function array = getArray(monkey, fileDate)
%given a monkey name and date, go to the master implant sheet and get the correct
%array name


implantTable = readtable('R:\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Animal-Miscellany\monkeyImplantSheet.xlsx');


newColumn = split(implantTable.(monkey){1}, ';');
arrayDate = datetime(newColumn{1}, 'InputFormat', 'yyyy/MM/dd');
array = newColumn{2};

for i=2:height(implantTable)
    if ~isempty(implantTable.(monkey){i})
        newColumn = split(implantTable.(monkey){i}, ';');
        newArrayDate = datetime(newColumn{1}, 'InputFormat', 'yyyy/MM/dd');
        if newArrayDate>arrayDate && newArrayDate < datetime(fileDate)
            array = newColumn{2};
            arrayDate = newArrayDate;
            clear newArrayDate;
        end
    end
end

    
                
    
        
       