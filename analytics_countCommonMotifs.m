% function which tells us how many of the motifs in the source are present in the target
% output give the number of sequences of the reduced connectivity set which are present in the full connectivity set
% inputs to the function are cell arrays of dynamic sequences
% Bug Fixes:
% 1. Instead of a break when you check m > o, there should be a continue, so that you check the next sequence to see if there is a match.
% 2. We get rid of the m>o check because we would like to know if a percentage of the seq of length m still found a match to the seq of length o
function [output, outputPairs] = analytics_countCommonMotifs(fullCon,redCon,percentMatch)

output = 0;
outputPairs = [];
out3 = []; 
out4 = [];
out5 = []; 
a = fullCon;
b = redCon;
numa = numel(a);
numb = numel(b);
maxCounter = 0; % this will be used to figure out the percent match for each redCon seq
maxCounterMatch = 0; % this will be used to capture which full sequence gave the best matches

% match = 0;

for i = 1:numb % redCon sequences set search
  bb = b{i};
  bb = [bb(:,1), bb(:,2)];
  [m n] = size(bb);
  maxMatchNodes = []; % initialize the variable
  for j = 1:numa % fullCon sequences set search
    aa = a{j};
    aa = [aa(:,1), aa(:,2)];
    [o p] = size(aa);
%    if(m > o)
      % BUG:  break % if the size of the redCon sequence is smaller than the fullCon sequence then we check the next full sequence
%      continue
%    else
      counter = 0;
      tempL = 1;
      for k = 1:m % go through all the activations in a redcon seq
	for l = tempL:o % go through the activations in a full seq
	  if(sum(bb(k,:) ==  aa(l,:)) == 2)
	    counter = counter +1;
	    tempL = l+1;
	    break; % once we find a match do not need to keep searching the list
	  end % ends if we find a match between reduced and full 
	end % ends search through each activation in a fullCon sequence
      end % ends for loop iteration through each activation in a redCon sequence
      if(counter >= m*percentMatch)
	output = output + 1;
	outputPairs = [outputPairs;[i, j]];
      end % complete sequence match found
%    end % end the if statement which looks to see if the redCon sequence is longer than fulCon
  end % check the next full connectivity sequence
  out3 = [out3; i (maxCounter/m)];
  maxCounter = 0;
  out4 = [out4; i  maxCounterMatch];
  maxCounterMatch = 0;
  out5{end+1} = maxMatchNodes;
end % check the next reduced connectivity sequence

end % end function
