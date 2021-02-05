function monkeyList = getAllMonkeys

%this function is called with no inputs and returns a list of all
%monkey names within the Miller Lab data directory

dataDir = dir(dealWithSlashes('R:\Basic_Sciences\Phys\L_MillerLab\data'));

monkeyList = {};

dirFlags = [dataDir.isdir];
dataDir = dataDir(dirFlags);

for i = 1:length(dataDir)
    if contains(dataDir(i).name, '_')
        splitName = split(dataDir(i).name, '_');
        monkeyList{end+1} = splitName{1};
    else
        monkeyList{end+1} = dataDir(i).name;
    end
end

monkeyList = unique(monkeyList);
monkeyList = setdiff(monkeyList, {'archive', 'cds', 'Behavior', 'IMU', 'OldCerebusTest', 'Rats', 'Test data', '.', '..', 'CompiledCOFiles', 'DeepLabCutVids', 'Backed', 'LoadCell'});