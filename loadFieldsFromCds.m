function df = loadFieldsFromCds(df, params, file_dir, file_name, map_dir, map_name)
    
    data_file = strcat(file_dir, file_name);
    map_file = strcat(map_dir, map_name);
    monkey_name = params.monkey_name;
    array_name = params.array_name;
    task_name = params.task_name;
    lab = params.lab;
    ran_by = params.ran_by;
    sorted = params.sorted;

    % Here are some fields for raw data
    requires_raw_emg = 0;
    requires_raw_force = 0;
    if isfield(params,'requires_raw_emg')
        requires_raw_emg = params.requires_raw_emg;
    end
    if isfield(params,'requires_raw_force')
        requires_raw_force = params.requires_raw_force;
    end

    cds=commonDataStructure();
    cds.file2cds(data_file,['array', array_name],...
                ['monkey', monkey_name],lab,'ignoreJumps',['task', task_name], ...
                ['ranBy', ran_by], ['mapFile', map_file]);


    
    df.date_processed = datestr(cds.meta.processedTime, 'YYYYmmDD'); %this should be taken automatically from xds
    df.file_length = floor(cds.meta.duration);
    df.date_recorded = datestr(cds.meta.dateTime, 'YYYYmmDD');

    if cds.meta.hasEmg
        df.emg_recorded = "muscles!"; %populate with list muscles
    else
        df.emg_recorded = "NULL";
    end
    
    df.has_emg = cds.meta.hasEmg;
    df.has_lfp = cds.meta.hasLfp;
    df.has_kin = cds.meta.hasKinematics;
    df.has_force = cds.meta.hasForce;
    df.has_analog = cds.meta.hasAnalog;
    df.has_units = cds.meta.hasUnits;
    df.has_triggers = cds.meta.hasTriggers;
    df.has_bumps = cds.meta.hasBumps;
    df.has_chaotic_load = cds.meta.hasChaoticLoad;
    df.has_sorting = cds.meta.hasSorting;
   
    clear cds;
    
end