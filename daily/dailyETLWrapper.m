%Daily processing - wrapper function

%% Define environment
addpath('/Users/josephinewallner/Documents/MATLAB/Addons/datajoint-matlab-master')
addpath('/Users/josephinewallner/Desktop/LabWork/MillerLab/dataJoint/ETL/file_processing')
workingFolder = '/Users/josephinewallner/Desktop/working';
dataFolder = '/Volumes/fsmresfiles/Basic_Sciences/Phys/L_MillerLab/data/';
mapFileFolder = '';

%% Check connections

%FSM
%dataJoint


%% Get list of files to load in
%       1. check server for new files - maybe include a 'process' and 'doNotProcess' folder
%       2. create list of files & relevant info from server location/file
%       metadata
checkDate = datetime('today') - caldays(40);
activeDirectories = getActiveDirectories();
newFiles = findNewFiles(dataFolder, activeDirectories, checkDate);

%% Get list of active monkeys


%% Loop through the files:
%       1. Download files locally
%       2. Run DQ metrics on raw data
%       3. Identify map file. If it doesn't already exist locally, then
%       download it
%       4. Set parameters for xds processing
%       5. Process xds (cds -> xds)
%       6. Load into database (including error handling)

for i = 1:length(newFiles)
    
    file = newFiles(i);
    
    try
        mapFile = getMapFile(file); %download any new map files here, if they don't exist yet
    
        %download file to local machine

        dq = dataQualityWrapper(file); %run DQ metrics
        xds = processXdsWrapper(file); %process xds
        insertDataFile(xds, file, params);%insert into DJ    
    catch
        %make entry in error table, and try processing the next file
    end 
end

