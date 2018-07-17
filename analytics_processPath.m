function analytics_processPath(endNode,startTime,startNode,beginNodeWindow,endNodeWindow,nrnFiringsNum,nrnFiringsTime);

%% define global variables which will use in this function %%
  global terminalMotifNode;
  global terminalMotifTime;
  global timeTargetFiring; 
  global nodeFiring; 
  global timeFiring;
  global traversedNodes;
  global path;
  global deleteFlag;


  %% set variables for passing to the getPath function %%
  terminalMotifNode = endNode;
  endNodeWindow = max(endNodeWindow);
  nrnFiringsNum = nrnFiringsNum(:,beginNodeWindow : endNodeWindow);
  nrnFiringsTime = nrnFiringsTime(:,beginNodeWindow : endNodeWindow);
  terminalMotifTime = nrnFiringsTime(1,end);
  timeTargetFiring = nrnFiringsTime(1,1:end);
  nodeFiring = nrnFiringsNum(2:end,1:end);
  timeFiring = nrnFiringsTime(2:end,1:end);
  traversedNodes = zeros(size(nodeFiring));
  path = []; % emptying path for new end node processing
  deleteFlag = 0;

  [placeholder1 placeholder2] = analytics_getPaths(startTime,startNode,size(traversedNodes,1),1); % this is going to be a recursive function

end % end function processPath