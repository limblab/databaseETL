function [] = DirectoryWrapper(directory, workingFolder, checkDate, monkeyList)
    newFiles = findNewFiles(directory, checkDate);
    
    %% Loop through the files:
    %       1. Figure out which files are new
    %       2. Download files locally
    %       3. Set parameters for xds processing
    %       4.  Process xds (cds -> xds)
    %       5.  Run DQ metrics on raw data
    %       6. Load into database (including error handling)
   
    dataQuality = cell(size(newFiles, 1));
    for i = 1:length(newFiles)
        
        file = newFiles(i, :); %file is a 1x2 cell array, cell 1 is the file path and cell 2 is the file name
        downloadFromServer(file, workingFolder);
        query = limblab_db.DataFile;
        lastFileKey = max(query.fetchn('data_file_key'));
        [df, fileParams] = getFileInformation(file, monkeyList, checkDate); %download any new map files here, if they don't exist yet

        xds = ProcessXdsWrapper(file, fileParams, workingFolder);
        df = loadFieldsFromXds(df, xds);
        dataQuality{i} = DataQualityWrapper(file, workingFolder, fileParams);
        
        experimentNotes.day = ''; experimentNotes.file = '';
        %experimentNotes = getExperimentNotes(meta.monkey, meta.date, file);
        %insertDataFile(df, dataQuality, experimentNotes); %if anything goes wrong here, make an entry in error table, & cont.

    end
    
   % sendAlerts(dataQuality);
    
end

function meta = updateMeta(meta, xds)
    meta.hasEmg = xds.has_EMG;
    meta.hasKin = xds.has_kin;
    meta.hasForce = xds.has_force;
end