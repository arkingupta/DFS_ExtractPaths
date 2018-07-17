function  [currentRow, currentColumn] = analytics_getPaths(startingTime,startingNode,lastRow,lastColumn) % this is going to be a recursive function

% defining global varialbes as needed by matlab
global timeTargetFiring;
global nodeFiring;
global timeFiring;
global traversedNodes;
global overallTerminalPaths; % paths which end at nodes with no succeeding activity
global overallGlobalPaths; % paths which go through nodes of interest, so as long as you go through one of the identified nodes, that pass will be a path
global overallContinousGlobalPaths;
global path;
global terminalMotifTime;
global terminalMotifNode;
global deleteFlag;

% sum(sum(traversedNodes))
% at the starting node at the starting time, find everything that is activated by that seed(ordered pari of startingNode,startingTime).
 % [rows, columns] = find((traversedNodes == 0) & (nodeFiring == startingNode) & (timeFiring == startingTime));
  [rows, columns] = find((traversedNodes == 0) & (nodeFiring == startingNode) & (timeFiring == startingTime));

  if(isempty(rows))
    currentRow = lastRow;
    currentColumn = lastColumn;
  % addPath1 = ((path(end,3) == terminalMotifTime) & (path(end,4) == terminalMotifNode)); % This condition is used if you want to only see the paths ending at a certain time, not just ending at a certain node
    if(isempty(path))
      addPath1 = 0;
    else
      addPath1 = (path(end,4) == terminalMotifNode);
    end
    addPath2 = (isempty(terminalMotifTime) | isempty(terminalMotifNode)); % this is a check to see if we want all the paths ending at a firing
    if (addPath1)
  %    traversedNodes(lastRow,lastColumn) = 1;
      overallTerminalPaths{end+1} = path;
%      overallGlobalPaths{end+1} = path; % removeing this beacuse i end up with duplicate global paths, and then when i look for subsets I dont get any subsets because there are duplicates
      path = path(1:end-1,:);
      deleteFlag = 1;
    elseif (addPath2) % this is the case when a terminal node is not seletected, we just want all paths that start somewhere and end at some u/specified time
   %   traversedNodes(lastRow,lastColumn) = 1;
      overallTerminalPaths{end+1} = path;
%      overallGlobalPaths{end+1} = path;  % removeing this beacuse i end up with duplicate global paths, and then when i look for subsets I dont get any subsets because there are duplicates
      path = path(1:end-1,:);
      deleteFlag = 1;
    else % this is part of addPath1 condition, so if you get to a terminal node which does not lead to one of the specified terminal nodes, then we just delete the path.
    %  traversedNodes(lastRow,lastColumn) = 1;
      path = path(1:end-1,:);
      deleteFlag = 1;
    end
  else % associated with the isempty(rows) statement
    for i=1:size(rows,1)
      deleteFlag = 0;
      newStartTime = timeTargetFiring(columns(i));
      newStartNode = rows(i);
      path(end+1,:) = [startingTime, startingNode, newStartTime, newStartNode];
      addPath1 = (path(end,4) == terminalMotifNode);
      addPath2 = (isempty(terminalMotifTime) | isempty(terminalMotifNode)); % this is a check to see if we want all the paths ending at a firing
      if (addPath1 | addPath2)
	overallGlobalPaths{end+1} = path; % these paths end at the selected nodes, the signals traverse the node, so it is not just the end of the signal, it is a path when a signal traverses the interesting node
      else
	% do nothing, we SHOULD be in the addPath1 cases alternate senario where we are looking for a terminal node which just was not found in this path node.
	% addPath2 cases should NOT lead here
      end
      [currentRow, currentColumn] = analytics_getPaths(newStartTime,newStartNode,rows(i),columns(i));
      if ((addPath1 | addPath2) & (deleteFlag == 1))
        overallContinousGlobalPaths{end+1} = path; % this is a list of exclusively non terminal paths which go through nodes of interest, this information can be gleaned from overallGlobalPaths but that would require post processing, here i just pull up the list.
      end % 
    end % end the for loop which iterates through the results of the find.
    if (deleteFlag == 1)
      path = path(1:end-1,:);
      deleteFlag = 1;
%      traversedNodes(lastRow,lastColumn) = 1; % the sum of the traversed nodes when you do not have a terminalNode should be the number of spikes
    end % end of the delete flag if statement
  end % end searching for rows which matched the find criteria

end % end function
