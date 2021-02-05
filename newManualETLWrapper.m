function newManualETLWrapper(filePath, bin_width)

%take a filepath string from the server WITH NEV EXTENSION, turn it into
%xdsplus (so it can be converted to TD as well), and then throw them into
%the database.

workingFolder = 'C:\Users\benja\Desktop\Miller_Lab\working'; %replace this with whatever the working folder is on the user's machine

%% Fetch the latest data file key from database
query = limblab_db.DataFile;
lastFileKey = max(query.fetchn('data_file_key'));
if isempty(lastFileKey), lastFileKey = 0; end

%% Get file information 
[df, params] = getManualFileInformation(filePath);
df.data_file_key = lastFileKey + 1;
params.bin_width = bin_width;
mapFile = getMapFile(df.monkey, df.date_recorded);
map_dir = mapFile.folder;
map_name = mapFile.name;

%copy from server to working folder
fullFileDir = dir(strcat([df.nev_file_location filesep df.nev_file_name(1:end-4)], ".*"));
for i=1:length(fullFileDir)   
    status = copyfile([fullFileDir(i).folder filesep fullFileDir(i).name], workingFolder);
        if ~status
            error('Failed to copy the file from the server!')
        end
end

%check if file already exists in database
query = limblab_db.DataFile & char(strcat('nev_file_name = ''', df.nev_file_name, ''''));
matchingFiles = query.fetchn('data_file_key');
if ~isempty(matchingFiles) %get rid of files if this file is already in the database
    disp([file ' already exists in the database'])
    for i=1:length(fullFileDir)     
        delete([workingFolder filesep fullFileDir(i).name])
    end
else
    % define fields to insert
    xds = raw_to_xdsplus([workingFolder filesep], df.nev_file_name, [map_dir filesep], map_name, params);
    df = loadFieldsFromXds(df, xds);

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

    %delete file from working folder
    for i=1:length(fullFileDir)     
        delete([workingFolder filesep fullFileDir(i).name])
    end
end

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
fileParams.array_name = getArray(monkey, df.date_recorded);


if contains(fileParams.array_name, 'M1')
    fileParams.lab = 1;
else
    fileParams.lab = 6;
end

fileParams.ran_by = input("Who was the experimenter for this file? Enter answer without any spaces", 's');
if isempty(fileParams.ran_by)
    fileParams.ran_by = 'Unknown';
end

fileParams.sorted = 0;
fileParams.requires_raw_emg = 0;
end
