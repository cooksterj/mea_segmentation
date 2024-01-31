function functionHandles = workQueue_f
% WORKQUEUE_F Work queue process - within the context of the main user interface,
% update the work queue.
%
% See also:
% functionHandles.emptyWellAndElectrode = @emptyWellAndElectrode;
% functionHandles.multipleWellMultipleElectrode = @multipleWellMultipleElectrode;
% functionHandles.noWellOrElectrodeSelection = @noWellOrElectrodeSelection;
% functionHandles.wellElectrodeValid = @wellElectrodeValid;
% functionHandles.queueWellElectrodeCombo = @queueWellElectrodeCombo;
% functionHandles.setWellElectrodeWorkQueue = @setWellElectrodeWorkQueue;
% functionHandles.updateProcessedWellElectrodeWorkQueue = @updateProcessedWellElectrodeWorkQueue;
%
% Author:  Jonathan Cook
% Created: 2018-12-21

functionHandles.emptyWellAndElectrode = @emptyWellAndElectrode;
functionHandles.multipleWellMultipleElectrode = @multipleWellMultipleElectrode;
functionHandles.noWellOrElectrodeSelection = @noWellOrElectrodeSelection;
functionHandles.wellElectrodeValid = @wellElectrodeValid;
functionHandles.queueWellElectrodeCombo = @queueWellElectrodeCombo;
functionHandles.setWellElectrodeWorkQueue = @setWellElectrodeWorkQueue;
functionHandles.updateProcessedWellElectrodeWorkQueue = @updateProcessedWellElectrodeWorkQueue;
functionHandles.unprocessedWellElectrodeWorkQueue = @unprocessedWellElectrodeWorkQueue;
end

function rslt = emptyWellAndElectrode(wellLogical, electrodeLogical)
% EMPTYWELLANDELECTRODE Empty well or electrode selection.
%
% INPUT:
%     wellLogical:       A logical array representing the well welection in the
%                        in the main user interface.
%     electrodeLogical:  A logical array representing the electrode selection in
%                        in the main user interface.
%
% OUTPUT:
%     True if either of the well or electrode logical array are empty, else
%     false.
%
% See also:
% workQueue_f

if(isempty(wellLogical) || isempty(electrodeLogical))
    warning(segmentation.model.errorData.msgWellElectrodeCheckboxesEmpty);
    rslt = true;
else
    rslt = false;
end
end

function rslt = multipleWellMultipleElectrode(wellLogical, electrodeLogical)
% MULTIPLEWELLMULTIPLEELECTRODE Multiple well and electrode selections.
%
% INPUT:
%     wellLogical:       A logical array representing the well welection in the
%                        in the main user interface.
%     electrodeLogical:  A logical array representing the electrode selection in
%                        in the main user interface.
%
% OUTPUT:
%     True if there are multiple well and electrode selections, else
%     false.
%
% See also:
% workQueue_f

if(sum(wellLogical) > 1 && sum(electrodeLogical) > 1)
    warning(segmentation.model.errorData.msgMultipleWellsMultipleElectrodes, ...
        sum(wellLogical), sum(electrodeLogical));
    rslt = true;
else
    rslt = false;
end
end

function rslt = noWellOrElectrodeSelection(wellLogical, electrodeLogical)
% NOWELLORELECTRODESELECTION No well or electrode selections.
%
% INPUT:
%     wellLogical:       A logical array representing the well welection in the
%                        in the main user interface.
%     electrodeLogical:  A logical array representing the electrode selection in
%                        in the main user interface.
%
% OUTPUT:
%     True if there are no well or electrode selections, else false.
%
% See also:
% workQueue_f

if(sum(wellLogical) == 0 || sum(electrodeLogical) == 0)
    warning(segmentation.model.errorData.msgMultipleWellsMultipleElectrodes, ...
        sum(wellLogical), sum(electrodeLogical));
    rslt = true;
else
    rslt = false;
end
end

function rslt = wellElectrodeValid(wellLogical, electrodeLogical)
% WELLELECTRODEVALID Validate the well and electrode selections.
%
% INPUT:
%     wellLogical:       A logical array representing the well welection in the
%                        in the main user interface.
%     electrodeLogical:  A logical array representing the electrode selection in
%                        in the main user interface.
%
% OUTPUT:
%     True if and only if:
%       [1] The logical array are not empty - AND
%       [2] Something is elected - AND
%       [3] A single well with multiple electrodes are selected OR
%               a single electrode with multiple well are selected.
%      else false.
%
% See also:
% workQueue_f

if emptyWellAndElectrode(wellLogical, electrodeLogical)
    rslt = false;
elseif((sum(wellLogical) == 1 && sum(electrodeLogical) >= 1) ...
        || (sum(wellLogical) >= 1 && sum(electrodeLogical) == 1))
    rslt = true;
elseif(multipleWellMultipleElectrode(wellLogical, electrodeLogical))
    rslt = false;
elseif(noWellOrElectrodeSelection(wellLogical, electrodeLogical))
    rslt = false;
else
    rslt = false;
end
end

function queueWellElectrodeCombo(handles, wellLogical, electrodeLogical)
% QUEUEWELLELECTRODECOMBO Queue well/electrode combination - within the main user
% interface, set the well/eletrode combination for further processing.
%
% INPUT:
%     handles:           A structure with handles and user data from the main user
%                        interface.
%     wellLogical:       A logical array representing the well welection in the
%                        in the main user interface.
%     electrodeLogical:  A logical array representing the electrode selection in
%                        in the main user interface.
%
% See also:
% workQueue_f

if(wellElectrodeValid(wellLogical, electrodeLogical))
    baseWellLogicalArray = false(1, length(wellLogical));
    baseElectrodeLogicalArray = false(1, length(electrodeLogical));
    
    logicalWellTrueIndexes = find(wellLogical == 1);
    logicalElectrodeTrueIndexes = find(electrodeLogical == 1);
    
    workQueueNum = 1;
    for i = 1:length(logicalWellTrueIndexes)
        baseWellLogicalArray(logicalWellTrueIndexes(i)) = true;
        for j = 1:length(logicalElectrodeTrueIndexes)
            baseElectrodeLogicalArray(logicalElectrodeTrueIndexes(j)) = true;
            if(isempty(getappdata(handles.waveformAnalysisFigure, 'wellElectrodeCombo')))
                wellElectrodeCombo(j) = segmentation.model.wellElectrodeData(workQueueNum, baseWellLogicalArray, baseElectrodeLogicalArray);
            else
                wellElectrodeCombo = getappdata(handles.waveformAnalysisFigure, 'wellElectrodeCombo');
                maxIndex = length(wellElectrodeCombo);
                wellElectrodeCombo(maxIndex + 1) = ...
                    segmentation.model.wellElectrodeData(segmentation.model.wellElectrodeData.maxWellElectrodeID(wellElectrodeCombo) + 1, ...
                    baseWellLogicalArray, baseElectrodeLogicalArray);
            end
            baseElectrodeLogicalArray(logicalElectrodeTrueIndexes(j)) = false;
            workQueueNum = workQueueNum + 1;
            setappdata(handles.waveformAnalysisFigure, 'wellElectrodeCombo', wellElectrodeCombo);
        end
        baseWellLogicalArray(logicalWellTrueIndexes(i)) = false;
    end
    workQueueHandles = workQueue;
    setWellElectrodeWorkQueue(handles, workQueueHandles);
end
end

function setWellElectrodeWorkQueue(handles, workQueueHandles)
% SETWELLELECTRODEWORKQUEUE Set the well/electrode work queue in the workQueue
% user interface.
%
% INPUT:
%     handles:           A structure with handles and user data from the main user interface.
%     workQueueHandles:  A structure with handles and user data from the workQueue interface.
%
% See also:
% workQueue_f

wellElectrodeCombo = getappdata(handles.waveformAnalysisFigure, 'wellElectrodeCombo');
if(~isempty(wellElectrodeCombo))
    for i = 1:length(wellElectrodeCombo)
        id{i, 1} = wellElectrodeCombo(i).wellElectrodeID;
        well{i, 1} = convertStringsToChars(wellElectrodeCombo(i).wellStrLabel);
        electrode{i, 1} = convertStringsToChars(wellElectrodeCombo(i).electrodeStrLabel);
        medication{i, 1} = convertStringsToChars(wellElectrodeCombo(i).medicationName);
        concentration{i, 1} = convertStringsToChars(wellElectrodeCombo(i).medicationConcentration);
        processed{i, 1} = wellElectrodeCombo(i).processed;
    end
    workQueueUITable = findall(workQueueHandles, 'tag', 'wellElectrodeWorkQueueTable');
    workQueueTable = table(id, well, electrode, medication, concentration, processed);
    workQueueCell = table2cell(workQueueTable);
    workQueueUITable.Data = workQueueCell;
end
end

function updateProcessedWellElectrodeWorkQueue(wellElectrodeCombo)
% UPDATEPROCESSEDWELLELECTRODEWORKQUEUE Update the well electrode combination - the
% processed flag will be set to true in the wellElectrodeData object, as well as the
% checkbox in the workQueue user interface.
%
% INPUT:
%    wellElectrodeCombo: A wellElectrodeData object.

workQueueHandles = workQueue;
wellElectrodeCombo.processed = 1;
workQueueUITable = findall(workQueueHandles, 'tag', 'wellElectrodeWorkQueueTable');
dim = size(workQueueUITable.Data);
for i = 1:dim(1)
    if(wellElectrodeCombo.wellElectrodeID == workQueueUITable.Data{i, 1})
        workQueueUITable.Data{i, 6} = true;
    end
end
end

function unprocessedWellElectrodeCombo = unprocessedWellElectrodeWorkQueue(wellElectrodeWorkQueue)
% UNPROCESSEDWELLELECTRODEWORKQUEUE Unprocessed well electrode combination - 
% identify the firstwell electrode combination within the wellElectrodeWorkQueue 
% paramater. If there is not an unprocessed well electrode combination, the return
% value will be empty.
%
% INPUT:
%     wellElectrodeWorkQueue: A wellElectrodeData object.
%
% OUTPUT:
%     unprocessedWellElectrode: A wellElectrodeData object whose processed
%     flag is equal to zero (unprocessed).  If a wellElectrodeData object
%     cannot be identified, the return value will be empty.

% Find all wellElectrodeCombinations in the work queue that have not been processed.
unprocessedWellElectrode = findobj(wellElectrodeWorkQueue, 'processed', 0);
if(isempty(unprocessedWellElectrode))
    unprocessedWellElectrodeCombo = [];
else
    firstUnprocessedID = min([unprocessedWellElectrode.wellElectrodeID]);
    unprocessedWellElectrodeCombo = findobj(wellElectrodeWorkQueue, 'wellElectrodeID', firstUnprocessedID);
end
end
