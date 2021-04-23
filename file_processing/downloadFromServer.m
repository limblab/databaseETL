function [] = downloadFromServer(file, workingFolder)

    serverLocation = file{1};
    tmp = strsplit(file{2}, '.');
    fileName = tmp{1};
    
    %get list of all files with the same name
    fileList = dir([serverLocation dealWithSlashes('\') fileName '.*']);
    
    try
        for iFile = 1:length(fileList) 
            %ignore ccf files
            if ~strcmp(fileList(iFile).name(end-2:end), 'ccf')
                %need to copy all files with the same name to the working folder!
                copyfile([serverLocation dealWithSlashes('\') fileList(iFile).name], workingFolder);
            end
        end
    catch
        disp('There was an issue copying the file from the server. Check server connection and file path')
    end
        
    
%     if exist([workingFolder, dealWithSlashes('\'), fileName], 'file') ~= 2
%         error('There was an issue copying the file from the server. Check server connection and file path')
%     end
    
end