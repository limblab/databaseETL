%Part of Limblab data processing pipeline
%
%   Cross-references folders in 'data' folder on server with active monkey
%   list.
%
%   Dictates where the daily processing code will look for newly recorded
%   files
%
%   JJW 1/8/2020


function [activeDirectories, activeMonkeyList] = getActiveDirectories()

    %monkeyWaterDataLoc = dealWithSlashes('/Volumes/fsmresfiles/Basic_Sciences/Phys/L_MillerLab/limblab/lab_folder/Lab-Wide Animal Info/WeekendWatering/');
    monkeyWaterDataLoc = dealWithSlashes('R:\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Lab-Wide Animal Info/WeekendWatering/');
    monkeyWaterData = 'MonkeyWaterData.xlsx';
    dataFolders = dir(dealWithSlashes('R:/Basic_Sciences/Phys/L_MillerLab/data/'));
    
    currentMonkeyData = readtable([monkeyWaterDataLoc monkeyWaterData]);
    activeMonkeyList = currentMonkeyData.animalName;
    
    dirFlags = [dataFolders.isdir];
    dataFolders = dataFolders(dirFlags);
    
    activeDirectories = {};
    for i = 1:length(dataFolders)
        monkeyName = split(dataFolders(i).name, '_');
        monkeyName = monkeyName{1};
        
        if any(strcmp(activeMonkeyList,monkeyName))
            activeDirectories{end + 1} = dataFolders(i).name; %#ok<AGROW>
        end
    end 
    
end