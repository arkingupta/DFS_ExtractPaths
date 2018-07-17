% this script is for the paper it will compare the reduced connectivity network to the full connectivity network
% it is a self contained script
function [out1, out2, out3, out4, out5, answ] = analytics_gabe_compare_redCon_to_fulCon(FeedLabels,full277LabelsFrom279,feed_overallTerminalPaths,full277w279_overallTerminalPaths)

out1 = [];
out2 = [];
out3 = [];
out4 = [];
out5 = [];
answ = [];


% save needed files to some variables
redConLabels = FeedLabels;
fullConLabels = full277LabelsFrom279;

% create a table with the mapping from the reduced to the full circuit
n = size(redConLabels,2);
mapFeed277w279 = zeros(n,2);
mapFeed277w279(:,1) = [1:n];
m = size(fullConLabels,2);

for i = 1:n
  for j = 1:m
    if(strcmp(redConLabels{i},fullConLabels{j}))
      mapFeed277w279(i,2) = j;
      break
    end % end of if statement which does the assignment of the mapFeed277w279 variable
  end % end of the for statement which goes through the full conn list
end % end of the for statement which goes throught the red conn list
% add the stimulus node
mapFeed277w279 = [mapFeed277w279; (n+1), (m+1)]; % we can have silent errors here so look out for zeros

targetToMapCells = feed_overallTerminalPaths;
convertedRedMotifs = {};
for i = 1:size(targetToMapCells,2)
  A = targetToMapCells{i};
  for j = 1:size(A,1)
    A(j,1) = mapFeed277w279(A(j,1),2);
    A(j,2) = mapFeed277w279(A(j,2),2);
  end
  convertedRedMotifs{end+1} = A;
end

redCon  = convertedRedMotifs;
fullCon = full277w279_overallTerminalPaths;

percentMatch = 1;
[out1 out2] = analytics_countCommonMotifs(fullCon,redCon,percentMatch);
if isempty(out2)
    % do nothing output nothing here we will take care of it below
else
    unv = (unique(out2(:,1)));
    size(unv,1)
    out2Stat = [unv histc(out2(:,1),unv)]
end

counter = 0;
for i=0:0.25:1
  counter = counter + 1;
  percentMatch = i;
  [out1, out2] = analytics_countCommonMotifs(fullCon,redCon,percentMatch);
  if isempty(out2)
      sunv = 0;
      punv = 0;
  else
      unv = (unique(out2(:,1)));
      sunv = size(unv,1);
      punv = size(unv,1)/(size(redCon,2));
  end
  X = ['There are ', num2str(sunv), ' patterns out of ', num2str(size(redCon,2)), ' patterns which found a ', num2str(i*100), '% ordered consecutive match with the ', num2str(size(fullCon,2)), ' patterns of the larger network (more patterns). ', num2str(100*punv) '% of the patterns in the fewer patterns network matched.'];
  
  percent_match = i*100;
  ratio = (sunv)/(size(redCon,2));
  
  if percent_match == 25
        fileID = fopen('testLOG25.txt','a+');
        fprintf(fileID, '%d  ', i*100);
        fprintf(fileID, '%d\n', ratio);
        fclose(fileID);
  end
  
  if percent_match == 50
        fileID = fopen('testLOG50.txt','a+');
        fprintf(fileID, '%d  ', i*100);
        fprintf(fileID, '%d\n', ratio);
        fclose(fileID);
  end
  
  if percent_match == 75
        fileID = fopen('testLOG75.txt','a+');
        fprintf(fileID, '%d ', i*100);
        fprintf(fileID, '%d\n', ratio);
        fclose(fileID);
  end
  
  if percent_match == 100
        fileID = fopen('testLOG100.txt','a+');
        fprintf(fileID, '%d  ', i*100);
        fprintf(fileID, '%d\n', ratio);
        fclose(fileID);
  end
  
  answ = [answ;ratio];
end

