function recordExperimentNotes(handles)

    %determine document path based on monkey name
    tmp = '';
    range = '';
    monkeyLog = 'C:\Users\jjw2788\Desktop\TestingLog.xlsx';
    
    %insert day notes (handles.day)
    d = handles.day;
    dayArray = {d.ccm_id, d.weight, d.h2o_start, d.h2o_end, d.treats,...
                d.behavior_note, d.health_notes, d.experimenter}; 
    xlswrite(monkeyLog, dayArray, 'Daily Log')
    
    
    %insert data file notes
    for iFile = 1:length(handles.allFiles)
        f = handles.allFiles{iFile};
        fileArray(iFile, :) = {f.lab_num, f. duration, f.reward_size};
    end  
    xlswrite(monkeyLog, fileArray, 'Data Log')


end