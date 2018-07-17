load('ss_ex_459_label_0.mat');
newShortestCycle1 = newShortestCycle;

load('ss_ex_429_label_9.mat');
newShortestCycle2 = newShortestCycle;

newShortestCycleFinal = newShortestCycle1;
for i = 1:length(newShortestCycle2)
    newShortestCycleFinal{length(newShortestCycle1)+i} = newShortestCycle2{i};
end

newShortestCycle = newShortestCycleFinal;
fileName = ['ss_1_15_4'];
save(fileName,'newShortestCycle');