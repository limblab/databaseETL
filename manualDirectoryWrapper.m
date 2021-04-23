function [] = manualDirectoryWrapper(serverFolder)

% Here's the gameplan for this:
%   1. Get a full .nev dir of all files in this monkey's directory
%   2. For each individual file: 
%       3a. Check to see if this file is already in the database. If so,
%       skip it or see if the nev location matches; if not, update.
%       3b. If it's not, download it locally. 
%       try
%       3c. Run processing wrapper on it to extract all fields for database
%       3d. Do DQ metrics (work in progress). 
%       3e. Load into database. 
%       Catch
%       3f. If error occurs, catch it. Save all errors from directory in
%       one big cell array and save it to some folder somewhere. 

workingFolder ='C:\Users\bps6383\Desktop\working';



%% Get full listing of all nev files for this directory 

allFiles = dir(fullfile(serverFolder, '**\*.nev'));
allFiles = allFiles(~[allFiles.isdir]);
badFiles = {};
%% big loop!

for i=1:length(allFiles)
    
    try
    
        query = limblab_db.DataFile;
        %check if file already exists in database

        query = limblab_db.DataFile & char(strcat('nev_file_name = ''', allFiles.name, ''''));
        matchingFiles = query.fetchn('data_file_key');
        if ~isempty(matchingFiles)

            disp([file ' already exists in the database. changing nev file location now'])
            query = limblab_db.DataFile & ['data_file_key = ' int2str(matchingFiles)];
            df = struct();
            [df.data_file_key, df.data_stretch_key, df.paper_key, df.date_recorded, df.nev_file_name, df.nev_file_location, df.date_processed, df.file_length, df.emg_recorded, df.has_emg, df.has_lfp, df.has_kin, df.has_force, df.has_analog, df.has_units, df.has_triggers, df.has_bumps, df.has_chaotic_load, df.has_sorting, df.task, df.sub_task, df.monkey, df.cds_server_location, df.emg_data_quality, df.neural_data_quality, df.behavior_notes, df.other_notes] = query.fetchn('data_file_key', 'data_stretch_key', 'paper_key', 'date_recorded', 'nev_file_name', 'nev_file_location', 'date_processed', 'file_length', 'emg_recorded', 'has_emg', 'has_lfp', 'has_kin', 'has_force', 'has_analog', 'has_units', 'has_triggers', 'has_bumps', 'has_chaotic_load', 'has_sorting', 'task', 'sub_task', 'monkey', 'cds_server_location', 'emg_data_quality', 'neural_data_quality', 'behavior_notes', 'other_notes');
            fn = fieldnames(df);
            
            %datajoint outputs character string fields as strings in cells,
            %so take them out of the cells
            for ii = 1:numel(fn)
                if isa(df.(fn{ii}), cell)
                    df.(fn{ii}) = df.(fn{ii}){1};
                end
            end
            
            df.nev_file_location = allFiles(i).folder;
            
            %datajoint doesn't allow changing individual values in a
            %table so delete the current entry and replace it with an
            %identical entry with fixed nev_file_location
            
            del(limblab_db.DataFile & char(strcat('nev_file_name = ''', df.nev_file_name, '''')))
            lastFileKey = max(query.fetchn('data_file_key'));
            df.data_file_key = lastFileKey+1;
            insert(limblab_db.DataFile, df)



        else
            %copy from server to working folder
            currentFile{1} = allFiles(i).folder;
            currentFile{2} = allFiles(i).name;
            downloadFromServer(currentFile, workingFolder);
            lastFileKey = max(query.fetchn('data_file_key'));


            [df, fileParams] = getManualFileInformation([allFiles(i).folder filesep allFiles(i).name]);
            df.data_file_key = lastFileKey+1;
            mapFile = getMapFile(df.monkey, df.date_recorded);
            map_dir = mapFile.folder;
            map_name = mapFile.name;

            df = loadFieldsFromCds(df, fileParams, [workingFolder filesep], currentFile{2}, [map_dir filesep], map_name);
            df.paper_key = -1;
            df.data_stretch_key = -1;
            df.emg_data_quality = "NULL"; %populate with data quality
            df.neural_data_quality = "NULL"; %populate with data quality
            df.behavior_notes = "NULL"; %populate with data quality
            df.other_notes = "NULL"; %populate with data quality
            df.sub_task = "NULL"; 
            df.cds_server_location = "NULL"; 

            %insert!
            insert(limblab_db.DataFile, df)
            disp([df.nev_file_name ' was added to the database'])

            %delete files from working folder
            workingDir = dir(workingFolder);

            for j=1:length(workingDir)  
                if ~workingDir(j).isdir
                    delete([workingFolder filesep workingDir(j).name])
                end
            end

        end
        clear df
        clear currentFile
        clear mapFile
        clear map_dir
        clear map_name
        clear lastFileKey
    catch ME
        badFiles{end+1, 1} = [allFiles(i).folder filesep allFiles(i).name];
        badFiles{end, 2} = ME;
    end
end
    
save([serverFolder filesep datestr(today) '_database_processing_errors.mat'], 'badFiles');
end






%% Subfunctions
function [df, fileParams] = getManualFileInformation(filePathInput)
df = struct;
fileDir = dir(filePathInput);
monkeyList = getAllMonkeys;
taskList = {'RW','CO','CObump','COactpas','BD','DCO','multi_gadget','UNT','RP','none','Unknown','SABES','UCK','OOR','WF','TRT','RT','RR','AFC', 'FR', 'WS','WI','WM','WB','key','PG'}; %keep this list somewhere else
nameParts = split(fileDir.name(1:end-4), '_');

df.nev_file_name = fileDir.name;
df.nev_file_location = fileDir.folder;
for iParts = 1:length(nameParts)
    if any(strcmpi(nameParts(iParts), monkeyList))
        df.monkey = nameParts{iParts};      
    elseif any(strcmpi(nameParts(iParts), taskList))
        df.task = nameParts{iParts};
    end
end
df.task = getCdsTask(df.task);
df.date_recorded = fileDir.date;

fileParams = struct;
fileParams.file_dir = fileDir.folder;
fileParams.file_name = fileDir.name;
fileParams.monkey_name = df.monkey;
fileParams.task_name = df.task;
fileParams.array_name = getArray(df.monkey, df.date_recorded);
fileParams.bin_width = .01;

%if contains(fileParams.array_name, 'M1')
%    fileParams.lab = 1;
%else
%    fileParams.lab = 6;
%end

fileParams.lab = -1;

%fileParams.ran_by = input("Who was the experimenter for this file? Enter answer without any spaces", 's');
%if isempty(fileParams.ran_by)
%    fileParams.ran_by = 'Unknown';
%end

fileParams.ran_by = 'Unknown';

fileParams.sorted = 0;
fileParams.requires_raw_emg = 0;
end
