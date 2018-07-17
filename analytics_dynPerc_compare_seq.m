function[output] = analytics_dynPerc_compare_seq(File1, File2) 

%clear all

% if you want to save matlab output to file
% diary('matlab.compareSequences279_2.out') 

%% create the labels for the dynamic perceptron nodes

% we just create a couple of cell arrays to satisfy the requirements for the 
% previous code
N = 813; % total number of nodes in the network, it might be 814 try both

redConLabels = {};
fullConLabels = {}; 

for i = 1:N
  redConLabels{end+1} = num2str(i);
  fullConLabels = num2str(i);
end

 % load file and save variable to use
  load (File1); % put the different file names here
  fullCircuitSeq = final; % try different types of sequences
  load (File2); % put the different file names here
  subCircuitSeq = final; % try different types of sequences

  X = ['Example 1 vs. Example 2']; % swap the example files, 
                                   % and test against the same example
				   % to sanity check
  disp(X);
  [temp1 temp2 temp3 temp4 temp5 final_ans] = analytics_gabe_compare_redCon_to_fulCon(redConLabels,redConLabels,subCircuitSeq,fullCircuitSeq);
  disp(final_ans);
  output = final_ans;
% diary off

end
