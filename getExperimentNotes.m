function experimentNotes = getExperimentNotes(monkey, expDate, fileName)
    
    if strcmpi(monkey, 'Greyson')
        experimentLog = 'https://docs.google.com/spreadsheets/d/1A_HYPjdmoQZ0c0z1kMbb2b-wGPE6gblyvhei33GWpKI/edit?ts=5e1e36e2#gid=0';
    elseif strcmpi(monkey, 'Duncan')
        experimentLog = 'R:\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Animal-Miscellany\Duncan_17L1\DuncanDailyLog_working.xlsx';
    elseif strcmpi(monkey, 'Han')
        experimentLog = 'R:\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Animal-Miscellany\Han_13B1\HanDailyLog_notBroken (Autosaved).xlsx';
    elseif strcmpi(monkey, 'Pop')
        experimentLog = 'https://docs.google.com/spreadsheets/d/1f_YGAKqM9fVMRACyrlCPEeKVwBR2yoqIgkITsf5UUhw/edit#gid=733859225';
    elseif strcmpi(monkey, 'Snap')
        experimentLog = 'R:\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Animal-Miscellany\Snap 18 E1\Snap 18E1 Daily Log.xlsx';
    elseif strcmpi(monkey, 'Butter')
        experimentLog = 'R:\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Animal-Miscellany\Butter_17D2\Butter_Daily_Log.xlsx';
    end
      
    if regexpi(experimentLog, '^.*[docs.google.]*', 'once')
         experimentNotes = readExperimentLogFromGoogleDrive(experimentLog, expDate, fileName);  
    else
        experimentNotes = readExperimentLogFromServer(experimentLog, expDate, fileName);
    end   
    
end

function experimentNotes = readExperimentLogFromServer(experimentLog, expDate, fileName)
    %return experimentNotes with 2 fields: daily & dataFile
    
    dailyLog = readtable(experimentLog, 'Sheet', 'Daily Log');
    dataLog = readtable(experimentLog, 'Sheet', 'Data Log');
    
    dailyLogRow = find(datetime(dailyLog.Date) == datetime(expDate));
    %dataLogRow = find(strcmpi(fileName, dataLog));
    
    
    %2 - check daily log, store this as 'day notes'
    
    
    
    %3 - check data log, store this as 'data file notes'
    experimentNotes = '';
    
end

function experimentNotes = readExperimentLogFromGoogleDrive(experimentLog, date)
    %return experimentNotes with 2 fields: daily & dataFile
    
    %2 - check daily log, store this as 'day notes'
    
    %3 - check data log, store this as 'data file notes'
    
    experimentNotes.day = '';
    experimentNotes.file = '';
    
end