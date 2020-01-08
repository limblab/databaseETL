%Insert xds fields from server into database (ETL)
%
%   1. read files to load from excel file
%   2. for each file:
%       a. download the file into working folder on desktop
%       b. load file into matlab, and insert into database
%       c. check to see if everything succeeded, otherwise roll it back
%       d. delete file from desktop

%% Define environment
addpath('/Users/josephinewallner/Documents/MATLAB/Addons/datajoint-matlab-master')
addpath('/Users/josephinewallner/Desktop/LabWork/MillerLab/dataJoint/')
serverFolder = '/Volumes/fsmresfiles/Basic_Sciences/Phys/L_MillerLab/limblab/User_folders/Josie/XDS4DJ';
workingFolder = '/Users/josephinewallner/Desktop/working';

%% Get list of files to load in
%[~,~,excelData] = xlsread('/Users/josephinewallner/Desktop/Database/PaperData.xlsx', 'Sheet1');
[~,~,excelData] = xlsread('/Users/josephinewallner/Desktop/Database/PaperData.xlsx', 'darpaData');
loadIdx = find(strcmp(excelData(:,5),'Y'));
files2load = excelData(strcmp(excelData(:,5),'Y'), 3);
nevFileNames = excelData(strcmp(excelData(:,5),'Y'), 6);
paperKeys = excelData(strcmp(excelData(:,5),'Y'), 4);
nevFileLocations = excelData(strcmp(excelData(:,5),'Y'), 7);
tasks = excelData(strcmp(excelData(:,5),'Y'), 8);
monkeys = excelData(strcmp(excelData(:,5),'Y'), 9);

%% Fetch the latest data file key from database
query = limblab_db.DataFile;
lastFileKey = max(query.fetchn('data_file_key'));
if isempty(lastFileKey), lastFileKey = 0; end

%% Loop through files and populate database
for i = 1:length(files2load)
    file = files2load{i};
    nevFile = nevFileNames{i};
    
    %copy from server to working folder
    status = copyfile(char(strcat(serverFolder, '/', file, '.mat')), workingFolder);
    if ~status
        error('Failed to copy the file from the server!')
    end
    
    %check if file already exists in database
    query = limblab_db.DataFile & char(strcat('nev_file_name = ''', nevFile, ''''));
    matchingFiles = query.fetchn('data_file_key');
    if ~isempty(matchingFiles)
        
        disp([file ' already exists in the database'])
        delete(char(strcat(workingFolder, '/', file, '.mat')))
    
    else
        
        % define fields to insert
        load(char(strcat(workingFolder, '/', file, '.mat')))
        df = struct;
        df = loadFieldsFromXds(df, xds);

        lastFileKey = lastFileKey + 1;

        df.data_file_key = lastFileKey;
        df.nev_file_name = nevFile;
        df.nev_file_location = nevFileLocations{i};
        df.paper_key = paperKeys{i};
        df.task = tasks{i};
        df.monkey = monkeys{i};
        df.data_stretch_key = -1;

        df.emg_data_quality = "NULL"; %populate with data quality
        df.neural_data_quality = "NULL"; %populate with data quality
        df.behavior_notes = "NULL"; %populate with data quality
        df.other_notes = "NULL"; %populate with data quality

        %insert!
        insert(limblab_db.DataFile, df)
        disp([file ' was added to the database'])

        %delete file from working folder
        delete(char(strcat(workingFolder, '/', file, '.mat')))
        
    end
    
    
end




