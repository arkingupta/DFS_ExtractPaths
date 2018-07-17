function [] = append_all(pattern_list, size, number)

load(pattern_list{1});
newShortestCycleFinal = newShortestCycle;

for i = 2:size
    load(pattern_list{i});
    newShortestCycle2 = newShortestCycle;

    for j = 1:length(newShortestCycle2)
        newShortestCycleFinal{length(newShortestCycleFinal)+1} = newShortestCycle2{j};
    end

end

dict_name = strcat('dict_', number);
fileName = char(dict_name);
newShortestCycle = newShortestCycleFinal;
save(fileName,'newShortestCycle');

end