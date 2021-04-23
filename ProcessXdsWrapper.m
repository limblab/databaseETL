function xds = ProcessXdsWrapper(file, fileParams, workingFolder)

    params = setParams(fileParams);
    %this should point to working folder instead of server
    xds = raw_to_xdsplus([workingFolder filesep], file{2}, [fileParams.mapFile.folder filesep], fileParams.mapFile.name, params);
    
end


function params = setParams(meta)

    params.monkey_name = meta.monkey;
    params.array_name = getArray(meta.monkey); 
    params.task_name = meta.task; %need to look up CDS task names
    params.lab = meta.lab; %this is not robust! need to setup data collection interface
    params.ran_by = meta.experimenter; %not robust, need to setup data collection interface
    params.sorted = 0; %only works for unsorted files atm
    params.bin_width = 0.01;
    
end