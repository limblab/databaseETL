function monkey = getMonkeyFromDir(directory)
    tmp = strsplit(directory, dealWithSlashes('\'));
    tmp2 = strsplit(tmp{end}, '_');
   
    monkey = tmp2{1};
end