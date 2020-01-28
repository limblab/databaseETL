%Daily processing - wrapper function

%% Define environment
%addpath('/Users/josephinewallner/Documents/MATLAB/Addons/datajoint-matlab-master')
%addpath('/Users/josephinewallner/Desktop/LabWork/MillerLab/dataJoint/ETL/file_processing')
%workingFolder = dealWithSlashes('/Users/josephinewallner/Desktop/working');
workingFolder = 'C:\Users\jjw2788\Desktop\workingFolder';
dataFolder = dealWithSlashes('R:/Basic_Sciences/Phys/L_MillerLab/data/');

addpath(genpath(dealWithSlashes('C:\Users\jjw2788\Documents\GitHub\ClassyDataAnalysis')))
addpath(genpath(dealWithSlashes('C:\Users\jjw2788\Documents\GitHub\Data-Quality')))
addpath(genpath(dealWithSlashes('C:\Users\jjw2788\Documents\GitHub\xds_matlab')))

mapFileFolder = '';

%% Check connections

%FSM
%dataJoint
 

%% Get list of files to load in
%       1. check server for new files - maybe include a 'process' and 'doNotProcess' folder
%       2. create list of files & relevant info from server location/file
%       metadata
checkDate = datetime('today') - caldays(300);
[activeDirectories, activeMonkeyList] = getActiveDirectories();
%newFiles = findNewFiles(dataFolder, activeDirectories, checkDate);

%% Loop through directories
for i = 2:length(activeDirectories) %set to 2 for testing
    %try
        DirectoryWrapper([dataFolder activeDirectories{i}], workingFolder, checkDate, activeMonkeyList);
    %catch
        %error(['Issue processing ' activeDirectories{i}])
    %end
end


