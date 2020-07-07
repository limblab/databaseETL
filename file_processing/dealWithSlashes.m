function adaptedString = dealWithSlashes(oldString)
    adaptedString = oldString;
    os = computer;
    if (strcmp(os(1:2), 'PC'))
        %replace any / or \ with \
        adaptedString(adaptedString == '/') = '\';       
    else
        %replace any / or \ with /
        adaptedString(adaptedString == '\') = '/';     
    end
    
end