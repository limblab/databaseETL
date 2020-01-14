function newFiles = findNewFiles(directory, checkDate)

    newFiles = {};

    tic
    files = dir([directory '\**\*.nev']); %check operating system to pick correct slash 
    if (isempty(files))
        error('Directory is empty, check server connection')
    end

    %if a file is copied to the server a week after recorded, which
    %modification date will it have?

    for j = 1:length(files)
        if(files(j).date > checkDate)
            newFiles{end + 1} = files(j); %#ok<AGROW>
        end
    end
    toc
    
end