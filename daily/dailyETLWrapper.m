%Daily processing - wrapper function

%% Define environment
%addpath('/Users/josephinewallner/Documents/MATLAB/Addons/datajoint-matlab-master')
%addpath('/Users/josephinewallner/Desktop/LabWork/MillerLab/dataJoint/ETL/file_processing')
workingFolder = 'C:\Users\benja\Desktop\working';
addpath(genpath(dealWithSlashes('C:\Users\benja\Desktop\Miller_Lab\Github_Host_Folder\ClassyDataAnalysis')))
addpath(genpath(dealWithSlashes('C:\Users\benja\Desktop\Miller_Lab\Github_Host_Folder\Data-Quality')))
addpath(genpath(dealWithSlashes('C:\Users\benja\Desktop\Miller_Lab\Github_Host_Folder\xds_matlab')))


%% Check connections

%FSM
%dataJoint
 

%% Get list of files to load in
%       1. check server for new files - maybe include a 'process' and 'doNotProcess' folder
%       2. create list of files & relevant info from server location/file
%       metadata
checkDate = datetime('today') - caldays(300);
[activeDirectories, activeMonkeyList] = getActiveDirectories();

%% Loop through directories
for i = 2:length(activeDirectories) %set to 2 for testing
    try
        DirectoryWrapper(activeDirectories{i}, workingFolder, checkDate, activeMonkeyList);
    catch ME
        newexception = MException.last;
        save(['R:\Basic_Sciences\Phys\L_MillerLab\limblab\User_folders\Ben\matlabErrorFolder\' checkDate activeDirectories{i} '.mat'], newexception);
        error(['Issue processing ' activeDirectories{i} '; exception saved to folder'])
    end
end


