function cdsTask = getCdsTask(task)

    if strcmpi(task, 'COactpas')
        cdsTask = 'CObump';
    elseif any(strcmpi(task, {'key', 'PG'}))
        cdsTask = 'multi_gadget';
    elseif strcmpi(task, 'cage')
        cdsTask = 'none';
    elseif any(strcmpi(task, {'freereach', 'freereaching'}))
        cdsTask = 'FR';
    else
        cdsTask = task;
    end

end