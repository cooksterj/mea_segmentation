function functionHandles = saveResults_f
% SAVERESULTS_F Save the results of the segmentation to file.
%
% See also:
% saveResults_f>saveOutData
% saveResults_f>directorySelect

functionHandles.saveOutData = @saveOutData;
functionHandles.directorySelect = @directorySelect;
end

function saveOutData(handles, outDataRslt)
% SAVEOUTDATA Save the outData object and the .csv equalivalent.
%
% INPUT:
%     handles:     A structure with handles and user data from the main user interface.
%     outDataRslt: An outData object that has been processed.
%
% See also:
% saveResult_f

saveDirectory = getappdata(handles.waveformAnalysisFigure, 'saveDirectory');
fileName = getappdata(handles.waveformAnalysisFigure, 'h5FileName');
progressBar = getappdata(handles.waveformAnalysisFigure, 'progressBar');

% Finished Processing - save the files off.
absoluteFileName = [saveDirectory, fileName];

uiWaitBar = waitbar(0.4, 'Saving .csv(s)'); pause(0.3);
segmentation.model.experiments.writeResults(absoluteFileName, outDataRslt);

structureFileName = absoluteFileName(1:end - 3);
saveDataStructure = outDataRslt;

waitbar(0.4, uiWaitBar, 'Saving .mat'); pause(0.3);
save(structureFileName, 'saveDataStructure');
close(uiWaitBar);
end

function directorySelect(handles)
% DIRECTORYSELECT Directory selection - update in the main user interface the
% save directory.
%
% INPUT:
%      handles:  A structure with handles and user data from the main user interface.
% 
% See also:
% saveResult_f    

selectedPath = uigetdir;
handles.directoryText.String = selectedPath;
setappdata(handles.waveformAnalysisFigure, 'saveDirectory', [selectedPath filesep]);
end

