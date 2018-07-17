function [newShortestCycle, seqPlot] = analytics_cycleAnalysis(finalStats,temporalMotifsVar,outputNodes)

%% load the statistics
% load finalStats
% load out_feed_seqCycleStats_01_Mar_2017_11_26_37.mat;
% load out_full_seqCycleStats_01_Mar_2017_11_47_39.mat;
% load out_full_global_seqCycleStats_03_Mar_2017_10_40_59.mat;

foundMatch = 0;
[m n] = size(finalStats);
matchList = zeros(m,3);

for i = 1:m % go through each temporal sequence
  seqDataA = finalStats{i,3};
  [o p] = size(seqDataA);
  for j = 1:o % go through all the compressions of that temporal sequence
    compressedSeqA = seqDataA{j,5}(1,:);
    for k=1:m % go to the next temporal sequence skipping if comparing the same
      if(i == k)
	continue
      else
	seqDataB = finalStats{k,3};
	[q r] = size(seqDataB);
	for h = 1:q % go through all the compressions of the 2nd temporal sequence
	  compressedSeqB = seqDataB{h,5}(1,:);
	  if(isequal(compressedSeqB,compressedSeqA)) % if you get a match stop and check the next sequence
	    foundMatch = 1;
	    break
	  end % end if statement
	end % end for loop going through all the compressions of the 2nd temporal sequence
      end % end the if statement skipping comparison of the same temporal sequence
      if(foundMatch == 1)
	break
      end
    end % end for loop comparing the two temporal sequences
    if(foundMatch == 1)
      break
    end
  end % end for loop cyceling through the compressions of the first temporal sequence
  if(foundMatch == 1) % we put the fact that the compressed temporal sequence found a match, in the first column and in the 2nd column we put the temporal sequence that we matched to
    matchList(i,:) = [i,1,k];
    foundMatch = 0;
  else
    matchList(i,:) = [i,0,0];
  end
end % end looking for loop of checking the sequence

% put the label of the temporal sequence in the 1st column
% matchList(:,1) = 1:m;
% Some Analysis on the finding in matchList
noMatch = m-sum(matchList(:,2));
strDisp1 = ['The number of sequences without any matches are: ', num2str(noMatch)];
disp(strDisp1)

% number of unique sequences in the simulation if there is a duplicate it not double counted
[value indx] = unique(matchList(:,3));
value
noMatch
uniqueSequences = noMatch + (numel(value) - 1)/2;
strDisp2 = ['The number of unique sequences are: ', num2str(uniqueSequences)];
disp(strDisp2)

k = matchList(matchList(:,3) == value(1));
seqPlot = {};
for i = 1:numel(k)
  seqPlot{end+1} = temporalMotifsVar{k(i)};
end
plotTitle = ['Unique Sequences without Match']
%cycle_motifsPlots(seqPlot,plotTitle,outputNodes)

%temp1 = [];
%shortestCycle = {};
%
%for i = 2:numel(value)
%  k = matchList(matchList(:,3) == value(i));
%  for j = 1:numel(k)
%    temp1 = [temp1; temporalMotifsVar{k(j)}(end,3)];
%  end
%  [temp2, temp3] = min(temp1);
%  shortestCycle{end+1} = temporalMotifsVar{k(temp3)};
%  temp1 = [];
%  temp2 = [];
%  temp3 = [];
%end
%plotTitle = ['Repeating Sequences of Terminal Activation in Full Circuit']
%cycle_motifsPlots(shortestCycle,plotTitle)
%

%temp4 = matchList(matchList(:,3) ~= 0,:);
%newMatchList = matchList;
%for i = 1:size(temp4,1)
%  ii = temp4(i,1);
%  ij = temp4(i,3);
%  jj = temp4(temp4(:,1)==ij,3);
%  if(ii==jj)
%    aa = temporalMotifsVar{ii}(end,3);
%    bb = temporalMotifsVar{ij}(end,3);
%    if(aa>bb)
%      % keep ij, remove ii
%      newMatchList(ii,:) = [];
%    else
%      newMatchList(ij,:) = [];
%    end 
%  end
%end
%

% this section of the code determines which temporal sequences to keep and
% which ones to get rid of
% we would like to keep the temporal sequences which are the shortest sequences
% which repeat, and we would like to keep the sequences which do not find a match
% the sequences which do not find a match are taken care of in the previous plot

toRem = [];
newMatchList = matchList;
for i = 1:size(matchList,1)
  ii = matchList(i,1);
  ij = matchList(i,3);
  if(ij == 0)
    continue
  else
    aa = temporalMotifsVar{ii}(end,3);
    bb = temporalMotifsVar{ij}(end,3);
    if(aa>bb)
      % keep ij, remove ii
      toRem = [toRem;ii];
    else
      toRem = [toRem;ij];
    end 
  end
end

newMatchList(toRem,:) = [];

temp1 = [];
newShortestCycle = {};

[newValue newIndx] = unique(newMatchList(:,3));
for i = 1:numel(newValue)
  if(newValue(i) == 0)
    continue
  else
    k = newMatchList(newMatchList(:,3) == newValue(i));
    for j = 1:numel(k)
      temp1 = [temp1; temporalMotifsVar{k(j)}(end,3)];
    end
    [temp2, temp3] = min(temp1);
    newShortestCycle{end+1} = temporalMotifsVar{k(temp3)};
    temp1 = [];
    temp2 = [];
    temp3 = [];
  end
end
plotTitle = ['Repeating Sequences of Terminal Activation in Full Circuit']
%cycle_motifsPlots(newShortestCycle,plotTitle,outputNodes)

% plot all sequences
%plotTitle = ['All Terminal Sequences in Full Circuit']
%cycle_motifsPlots(temporalMotifsVar,plotTitle,outputNodes)
