function [data, labels, labelIdx, frequency] = findEmgData(file, workingFolder)

    %find emg file - how is this done in cds?
    tmp = strsplit(file.name, '.');
    fileName = tmp{1}; 
    NSxList = dir([workingFolder dealWithSlashes('\') fileName '.ns*']);
    
    
    %open each .NSx file, and check for '*emg*' labels
    for iFile = 1:length(NSxList)
        
        NSx = openNSx(strcat(workingFolder, dealWithSlashes('\'), NSxList(iFile).name));
        [labels, labelIdx] = getLabels(NSx.ElectrodesInfo);
        
        %check if this file has emg labels
        if regexpi(labels{1}, '^.*emg.*', 'once') || regexpi(labels{end}, '^.*emg.*', 'once')
            
            %find emg data
            %usually NS3.Data or NS3.Data{1,2}
            if size(NSx.Data,1) > 5, data = NSx.Data;
            else
                disp(['NS3.Data: ' num2str(size(NSx.Data))]);
                for i = 1:length(NSx.Data)
                    disp(['NSx.Data{' num2str(i) '} : ' num2str(size(NSx.Data{i}))])
                end
                data = input('Where is the data?');
            end
            
            frequency = NSx.MetaTags.SamplingFreq;
            break
            
        end
    end   
end

function [labels, labelIdx] = getLabels(electrodeInfo)
    count = 0;
    for i = 1:length(electrodeInfo)
        if ~ (strcmp(electrodeInfo(i).Label(1:4), 'elec') || contains(electrodeInfo(i).Label, 'force', 'IgnoreCase', true))
            count = count + 1;
            labels{count} = deblank(electrodeInfo(i).Label); %#ok<AGROW>
            labelIdx{count} = i; %#ok<AGROW>
        end
    end    
end