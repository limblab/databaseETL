function xds = ProcessXdsWrapper(file, meta, workingFolder)

    params = setParams(meta);
    %this should point to working folder instead of server
    xds = raw_to_xds([file.folder dealWithSlashes('\')], file.name, meta.mapFile.folder, meta.mapFile.name, params);
    
end


function params = setParams(meta)

    params.monkey_name = meta.monkey;
    params.array_name = 'M1'; %need this
    params.task_name = meta.task; %need to look up CDS task names
    params.lab = meta.lab; %this is not robust! need to setup data collection interface
    params.ran_by = meta.experimenter; %not robust, need to setup data collection interface
    params.sorted = 0; %only works for unsorted files atm
    params.bin_width = 0.01;
    
end