%% !!!This has not been tested or commented!!!!
function [df, fileParams] = getFileInformation(file, activeMonkeyList, checkDate)
    
    df = struct;
    taskList = {'RW','CO','CObump','COactpas','BD','DCO','multi_gadget','UNT','RP','none','Unknown','SABES','UCK','OOR','WF','TRT','RT','RR','AFC', 'FR', 'WS','WI','WM','WB','key','PG'}; %keep this list somewhere else
    nameParts = strsplit(file{2}(1:end-4), '_');
    
    df.nev_file_name = file{2};
    df.nev_file_location = file{1};
    df.date_recorded = checkDate;

    for iParts = 1:length(nameParts)
        if isempty(fileParams.task) && any(strcmpi(taskList, nameParts{iParts}))
            %meta.task = getTaskName(nameParts{iParts});
            df.task = getCdsTask(nameParts{iParts});
        elseif isempty(fileParams.monkey) && any(strcmpi(activeMonkeyList, nameParts{iParts}))
            df.monkey = nameParts{iParts};
        end
    end
    
    fileParams = struct;
    fileParams.monkey_name = df.monkey;
    fileParams.task_name = df.task;
    fileParams.file_dir = df.nev_file_location;
    fileParams.file_dir = df.nev_file_name;
    fileParams.array_name = getArray(fileParams.monkey, fileParams.date);
    fileParams.mapFile = getMapFile(fileParams.monkey, fileParams.date);
    fileParams.bin_width = .01;
    
    if contains(fileParams.array_name, 'M1') %not really sure if this is the best way to do this
        fileParams.lab = 1;
    else
        fileParams.lab = 6;
    end
    
    fileParams.ran_by = getExperimenter(fileParams.monkey); %get from monkey watering sheet (won't work for historical loading)
    fileParams.sorted = 0;
    fileParams.requires_raw_emg = 0;

end




%this will eventually come from data collection interface
function experimenter = getExperimenter(monkey)
    monkeyWaterDataLoc = dealWithSlashes('R:\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Lab-Wide Animal Info/WeekendWatering/');
    monkeyWaterData = 'MonkeyWaterData.xlsx';
    currentMonkeyData = readtable([monkeyWaterDataLoc monkeyWaterData]);
    
    %get first in charge
    experimenter = currentMonkeyData.personInCharge(strcmpi(currentMonkeyData.animalName, monkey));
    experimenter = char(experimenter);
end
