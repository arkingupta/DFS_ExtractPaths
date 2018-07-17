function [overallTerminalPaths,overallContinousGlobalPaths,overallContinousGlobalPathsWoRepetitions,overallGlobalPaths] = analytics_getMotifs_mnist(oNodes,Mot,Tst,N)


%% Define global variables for use in this function and in getPath function
global terminalMotifNode;
global terminalMotifTime;
global timeTargetFiring; 
global nodeFiring; 
global timeFiring;
global traversedNodes;
global overallTerminalPaths;
global overallGlobalPaths;
global overallContinousGlobalPaths;
global path;


% I think ideally I would chop up the large motif matrix to include the start and end times, then I would use the find function of the starting node, find the column which is min, and then chop off the matrix again to start at the column which inlcudes the min, then I would do another find looking for the ending node, and find the column which contains the endNode and look for the max column. That would be the matrix I analyze below. Also I need to put a falg such that if the end is not the needed ending node, then do not save the path in the output.

%% Reset values of the global variables for this run %%
terminalMotifNode = [];
terminalMotifTime = [];
timeTargetFiring = []; 
nodeFiring = []; 
timeFiring = [];
traversedNodes = [];
overallTerminalPaths = {};  % Variables which need to be cleared for each files processing %
overallGlobalPaths = {};
overallContinousGlobalPaths = {};
path = [];


nrnFiringsNum  = Mot;
nrnFiringsTime = Tst;

stopTime = Mot(1,end);
endTime = stopTime;
startNode = N + 1;

outputNodeSet1 = [];
outputNodeSet2 = oNodes;
endNode = [outputNodeSet1, outputNodeSet2];
[temp1 startTimeVec] = find(Mot==startNode);
startTimeVec = unique(startTimeVec);

%% Find Motifs for the loaded files %%
for cycleStartTime = Mot(1,startTimeVec)
  startTime = cycleStartTime;
  % Setting the search space for motifs based on TIME WINDOW %
  [placeholder beginTimeWindow] = find(nrnFiringsNum(1,:) >= startTime); % nrnFiringsNum is fine to use because we are only searching in the first row, this contains only the time of activations
  [beginTimeWindow, minIdx] = min(nrnFiringsNum(1,beginTimeWindow));

  if (isempty(endTime))
    endTimeWindow = size(nrnFiringsNum,2);
  else
    [placeholder endTimeWindow] = find(nrnFiringsNum(1,:) <= endTime);
  end
  maxIdx = max(endTimeWindow); % BUG FIX: This will pick the last column which corresponds to endTime being less than the firingTime
%  [endTimeWindow, maxIdx] = max(nrnFiringsNum(1,endTimeWindow));

  nrnFiringsNum = nrnFiringsNum(:,minIdx : maxIdx);
  nrnFiringsTime = nrnFiringsTime(:,minIdx : maxIdx);


  %% Setting the search space for motifs based on the START AND END NODE %%
  [placeholder beginNodeWindow] = find(nrnFiringsNum == startNode);
  beginNodeWindow = min(beginNodeWindow);
  if(isempty(endNode))
    endNodeWindow = size(nrnFiringsNum,2);
    disp('is empty end node processing paths')
    analytics_processPath(endNode,startTime,startNode,beginNodeWindow,endNodeWindow,nrnFiringsNum,nrnFiringsTime);
  else
    for ii=1:length(endNode)
      [placeholder endNodeWindow] = find(nrnFiringsNum(endNode(ii)+1,:) ~= 0);
      if(isempty(endNodeWindow))
        continue
      else
        disp('start time: ')
        startTime
	disp('end time: ')
        stopTime
        disp('end node: ')
        endNode(ii)
        disp('with end node list processing paths')
        analytics_processPath(endNode(ii),startTime,startNode,beginNodeWindow,endNodeWindow,nrnFiringsNum,nrnFiringsTime);
      end
    end
  end % end of if statement for endNode processing
  %% Analyze Motifs %%
  %% remove the motifs which a subsets of larger motifs %
  %%% There is something wrong with this 
  %% motifsList = removeSubsetOverallPaths(overallTerminalPaths);
  motifsList = overallTerminalPaths;
  % motifsList = overallGlobalPaths;
  % % motifsList = overallContinousGlobalPaths;
  overallContinousGlobalPathsWoRepetitions = removeSubsetOverallPaths(overallContinousGlobalPaths);

end % end cycling through the start times