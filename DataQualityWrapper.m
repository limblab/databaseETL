function [dq, summaryTable] = DataQualityWrapper(file, workingFolder, meta)
    
    if meta.hasEmg
        [dq.emg, summaryTable.emg] = DataQualityWrapperEmg(file, workingFolder, meta);
    end
    
    if meta.hasForce
        %dq.force = DataQualityWrapperForce(file);
    end
    
    if meta.hasKin
        %dq.kin = DataQualityWrapperKin(file);
    end
    
    %dq.neural = DataQualityNeural(file);
    
end