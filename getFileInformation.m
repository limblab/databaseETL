%% !!!This has not been tested or commented!!!!
function meta = getFileInformation(file, activeMonkeyList)
    
    taskList = {'WF', 'WM', 'RW', 'RT', 'CO', 'cobump', 'cobumpmove', 'kramer', 'bumpdir'}; %keep this list somewhere else
    nameParts = strsplit(file.name(1:end-4), '_');
    
    meta.task = '';
    meta.date = '';
    meta.monkey = '';
    for iParts = 1:length(nameParts)
        %check if it's a date
        if isempty(meta.date) && ~isempty(regexp(nameParts{iParts}, '^20(19|20)[01-12][01-31]', 'once'))
            meta.date = nameParts{iParts};
        elseif isempty(meta.task) && any(strcmpi(taskList, nameParts{iParts}))
            %meta.task = getTaskName(nameParts{iParts});
            meta.task = getCdsTask(nameParts{iParts});
        elseif isempty(meta.monkey) && any(strcmpi(activeMonkeyList, nameParts{iParts}))
            meta.monkey = nameParts{iParts};
        end
    end
    
    meta.mapFile = getMapFile(meta.monkey, date);
    meta.lab = getLab(meta.monkey); %what's the best way to do this? can start with monkey, but this isn't super reliable
    meta.experimenter = getExperimenter(meta.monkey); %get from monkey watering sheet (won't work for historical loading)

end

function mapFile = getMapFile(monkey, date)
    %go look on the server
    %find file that corresponds to that monkey, with the most recent date -
    %will be different for manual loading - will need to be specified there
    
    %find animal folder on server
    animalFolders = dir('R:\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Animal-Miscellany');
    for i = 1:length(animalFolders)
        if animalFolders(i).isdir && ~isempty(regexp(animalFolders(i).name, ['^' monkey '.*'], 'once'))
            folder = animalFolders(i);
            break
        end
    end
    
    %find map file folder in the monkey's directory
    subFolders = dir([folder.folder dealWithSlashes('\') folder.name]);
    for i = 1:length(subFolders)
        if subFolders(i).isdir && ~isempty(regexpi(subFolders(i).name, '.*map.*', 'once'))
            mapFileFolder = subFolders(i);
            break
        end
    end
    
    %find the most recent map file (.cmp)
    mapFiles = dir([mapFileFolder.folder dealWithSlashes('\') mapFileFolder.name dealWithSlashes('\*\')  '*.cmp']);
    mapFile = mapFiles(1);
    if length(mapFiles) > 1
        %find the most recent date
        for i = 1:length(mapFiles)
            if datetime(mapFiles(i).date) > datetime(mapFile.date)
                mapFile = mapFiles(i);
            end
        end
    end
       
end

%this will eventually come from data collection interface
function lab = getLab(monkey)
    if any(strcmpi({'Yanny', 'Greyson', 'Pop'}, monkey))
        lab = 1;
    else
        lab = 6;
    end
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

function cdsTask = getCdsTask(task)

    if strcmpi(task, 'WM')
        cdsTask = 'WF';
    elseif strcmpi(task, 'CO')
        cdsTask = 'CObump';
    else
        cdsTask = task;
    end

end