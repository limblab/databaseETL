function [] = DirectoryWrapper(directory, workingFolder, checkDate, monkeyList)
    newFiles = findNewFiles(directory, checkDate);
    %load C:\Users\jjw2788\Desktop\workingFolder\newFilesGreyson.mat newFiles
    
    %% Loop through the files:
    %       1. Download files locally
    %       2. Identify map file. If it doesn't already exist locally, then
    %       download it
    %       3. Set parameters for xds processing
    %       4.  Process xds (cds -> xds)
    %       5.  Run DQ metrics on raw data
    %       6. Load into database (including error handling)
   
    dataQuality = cell(length(newFiles));
    for i = 1:length(newFiles)
        
        file = newFiles(i);
        file = file{1};
        downloadFromServer(file, workingFolder);
        meta = getFileInformation(file, monkeyList); %download any new map files here, if they don't exist yet

        xds = ProcessXdsWrapper(file, meta, workingFolder);
        meta = updateMeta(meta, xds);
        dataQuality{i} = DataQualityWrapper(file, workingFolder, meta);
        
        experimentNotes.day = ''; experimentNotes.file = '';
        %experimentNotes = getExperimentNotes(meta.monkey, meta.date, file);
        %insertDataFile(file, xds, dataQuality, experimentNotes); %if anything goes wrong here, make an entry in error table, & cont.

    end
    
   % sendAlerts(dataQuality);
    
end

function meta = updateMeta(meta, xds)
    meta.hasEmg = xds.has_EMG;
    meta.hasKin = xds.has_kin;
    meta.hasForce = xds.has_force;
end