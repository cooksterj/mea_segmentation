function functionHandles = workQueue_f
% WORKQUEUE_F Work queue process - within the context of the work queue user 
% interface - update the work queue.
%
% See also:
% functionHandles.removeRow = @removeRow;
% functionHandles.cellSelection = @cellSelection;
% functionHandles.updateWorkQueue = @updateWorkQueue;
% functionHandles.medUpdate = @medUpdate;
%
% Author:  Jonathan Cook
% Created: 2018-12-22

functionHandles.removeRow = @removeRow;
functionHandles.cellSelection = @cellSelection;
functionHandles.updateWorkQueue = @updateWorkQueue;
functionHandles.medUpdate = @medUpdate;
end

function removeRow(handles)
% REMOVEROW Remove row - eliminate a row from the work queue table.
%
% INPUT:
%     handles: A structure with handles and user data from the work queue
%              user interface.
%
% See also:
% workQueue_f

waveformAnalysisHandles = waveformAnalysis;
existingWellElectrodeCombo = getappdata(waveformAnalysisHandles, 'wellElectrodeCombo');
selectedRow = getappdata(handles.workQueueFigure, 'selectedRow');

if(~isempty(selectedRow))
    queueTableData = get(handles.wellElectrodeWorkQueueTable, 'data');
    
    queueTableData(selectedRow, :) = [];
    set(handles.wellElectrodeWorkQueueTable, 'data', queueTableData)
end

dim = size(queueTableData);
for i = 1:dim(1)
    matchedComboValue(i) = findobj(existingWellElectrodeCombo, 'wellElectrodeID', queueTableData{i,1});
end
setappdata(waveformAnalysisHandles, 'wellElectrodeCombo', matchedComboValue);
end

function cellSelection(eventData, handles)
% CELLSELECTION Row selection - based on the selected cell, update the 
% selectedRow attribute in the work queue user interface.
%
% INPUT:
%     eventData:  Event data releted to a user action.
%     handles:    A structure with handles and user data from the work queue
%                 user interface.
%
% See also:
% workQueue_f

if(~isempty(eventData.Indices))
    selectedRow = eventData.Indices(1);
    setappdata(handles.workQueueFigure, 'selectedRow', selectedRow);
end
end

function updateWorkQueue(eventData, handles)
% UPDATEWORKQUEUE Update work queue - synchronize the work queue between
% the main user interface and the work queue interface.
%
% INPUT:
%     eventData:  Event data releted to a user action.
%
% See also:
% workQueue_f

if(~isempty(eventData.Indices))
    % Retrieve the selected row and data - only a single row will be worked on at a time.
    selectedRow = eventData.Indices(1);
    queueTableData = get(handles.wellElectrodeWorkQueueTable, 'data');
    
    waveformAnalysisHandles = waveformAnalysis;
    existingWellElectrodeCombo = getappdata(waveformAnalysisHandles, 'wellElectrodeCombo');
    existingWellElectrodeCombo(selectedRow).medicationName = queueTableData{selectedRow, 4};
    existingWellElectrodeCombo(selectedRow).medicationConcentration = queueTableData{selectedRow, 5};
    existingWellElectrodeCombo(selectedRow).processed = queueTableData{selectedRow, 6};
    setappdata(waveformAnalysisHandles, 'wellElectrodeCombo', existingWellElectrodeCombo);
end
end