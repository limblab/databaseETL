function mapFile = getMapFile(monkey, fileDate)
    %go look on the server for the map file that was most recently created
    %before the file. returns a one-line dir entry of the matching map
    %file
    
    %find animal folder on server
    currentAnimalFolders = dir('R:\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Animal-Miscellany');
    pastAnimalFolders = dir('R:\Basic_Sciences\Phys\L_MillerLab\limblab-archive\Retired Animal Logs\Monkeys');
    animalFolders = [currentAnimalFolders; pastAnimalFolders];
    for i = 1:length(animalFolders)
        if animalFolders(i).isdir && ~isempty(regexp(animalFolders(i).name, ['^' monkey '.*'], 'once'))
            folder = animalFolders(i);
            break
        end
    end
    
    

    %find the most recent map file (.cmp)
    mapFiles = dir([folder.folder filesep folder.name '\**\*.cmp']);
    mapFile = mapFiles(1);
    if length(mapFiles) > 1
        %find the most recent date
        for i = 1:length(mapFiles)
            if datetime(mapFiles(i).date) > datetime(mapFile.date) && datetime(mapFiles(i).date) < datetime(fileDate)
                mapFile = mapFiles(i);
            end
        end
    end
       
end