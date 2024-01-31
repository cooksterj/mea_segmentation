function functionHandles = processH5_f
% PROCESSH5_F Process the H5 file for segmentation by using the MCS library.
%
% See also:
% processH5_f>sinitialize
% processH5_f>processWellElectrodeQueue
%
% Author:  Jonathan Cook
% Created: 2018-12-15

functionHandles.initialize = @initialize;
functionHandles.processWellElectrodeQueue = @processWellElectrodeQueue;
end

function initialize(handles)
% INITIALIZE H5 initialization - using the McsMatlabDataTools library,
% Read in the time, start/stop, and electroporation data.  Once initialized
% call the processWellElectrodeQueue to proceed with the segmentation.
%
% INPUT:
%    handles:  A structure with handles and user data from the main user
%              interface.
%
% See also:
% processH5_f
% processWellElectrodeQueue

addpath(strcat(pwd,'/McsMatlabDataTools_1.0.3/McsMatlabDataTools/'));
import +McsHDF5.*

uiWaitBar = waitbar(0, 'Starting...');
fileName = getappdata(handles.waveformAnalysisFigure, 'h5FileName');
filePath = getappdata(handles.waveformAnalysisFigure, 'h5FilePath');

waitbar(0.2, uiWaitBar, 'Starting preliminary processing...')
allExperimentData = mcsReadAllExperimentData(filePath, fileName);

allExperimentTime = mcsReadAllExperimentTime(allExperimentData);
waitbar(0.4, uiWaitBar, 'Processing Time Data...')

allElectroporationStop = mcsReadAllElectroporationStop(allExperimentData);
waitbar(0.1, uiWaitBar, 'Processing Electroporation Data...')

[wellIDs, electrodeIDs] = mcsWellElectrodeIDS(allExperimentData);
[recordStart, recordStop] = mcsReadRecordStartAndStop(allExperimentData);
close(uiWaitBar);

processWellElectrodeQueue(handles, wellIDs, electrodeIDs, allExperimentData, ...
    allExperimentTime, allElectroporationStop, recordStart, recordStop)
end

function processWellElectrodeQueue(handles, wellIDs, electrodeIDs, allExperimentData, allExperimentTime, allElectroporationStop, recordStart, recordStop)
% PROCESSWELLELECTRODEQUEUE Process each well/electrode combination in the work Queue.
% The voltage measurement varies depending on the well and electrode.  Experiment
% instantiation depends on the previously identified time, voltage, start, stop, and
% well/electrode combination.
%
% INPUT:
%     handles:                 A structure with handles and user data from the main user interface.
%     wellIDs:                 UI well identifiers.
%     electrodeIDs:            UI electrode identifiers
%     allExperimentData:       All of the experiment data as isolated by the Mcs library.
%     allExperimentTime:       All of the experiment time as isolated by the Mcs library.
%     allElectroporationStop:  All of the electroporation stop times as isolated by the Mcs library.
%     recordStart:             All of the start times as isolated by the Mcs library.
%     recordStop:              All of the stop times as isolated by the Mcs ibrary.
%
% See also:
% processH5_f
 
import +McsHDF5.*

mainWorkQueueFunctions = segmentation.functions.ui.main.workQueue_f;
signalQCFunctions = segmentation.functions.signalQC_f;
saveFunctions = segmentation.functions.ui.main.saveResults_f;

wellElectrodeQueue = getappdata(handles.waveformAnalysisFigure, 'wellElectrodeCombo');
unprocessedWellElectrodeCombo = mainWorkQueueFunctions.unprocessedWellElectrodeWorkQueue(wellElectrodeQueue);
outDataIndex = 1;
while ~isempty(unprocessedWellElectrodeCombo)
    uiWaitBar = waitbar(0.6, 'Extracting Voltages'); pause(0.3);
    allExperimentVoltage = mcsAllExperimentVoltage(handles, ...
        allExperimentData, ...
        wellIDs, ...
        electrodeIDs, ...
        unprocessedWellElectrodeCombo);
    close(uiWaitBar);
    
    initializedExperiments = segmentation.model.experiments(unprocessedWellElectrodeCombo, ...
        allExperimentData, ...
        allExperimentTime, ...
        allElectroporationStop, ...
        wellIDs, ...
        electrodeIDs, ...
        recordStart, ...
        recordStop, ...
        allExperimentVoltage);
    
    handles.medicationNameText.String = unprocessedWellElectrodeCombo.medicationName;
    handles.medicationConcentrationText.String = unprocessedWellElectrodeCombo.medicationConcentration;
    
    intermediateOutDataRslt = signalQCFunctions.plotBaseWaveform(initializedExperiments, handles);
    
    % If the length of the intermediate result is equal to 1, there was not
    % many starts/stops per well/electrode.
    if(length(intermediateOutDataRslt) == 1)
        outDataRslt(outDataIndex) = intermediateOutDataRslt;
        outDataIndex = outDataIndex + 1;
    end
    
    % If the length of the intermediate result is greater than 1, there were
    % many starts/stops per well/electrode.  Increment the separate index and
    % save off in an array.
    if(length(intermediateOutDataRslt) > 1)
        for j = 1:length(intermediateOutDataRslt)
            outDataRslt(outDataIndex) = intermediateOutDataRslt(j);
            outDataIndex = outDataIndex + 1;
        end
    end
    mainWorkQueueFunctions.updateProcessedWellElectrodeWorkQueue(unprocessedWellElectrodeCombo);
    unprocessedWellElectrodeCombo = mainWorkQueueFunctions.unprocessedWellElectrodeWorkQueue(wellElectrodeQueue);
end

saveFunctions.saveOutData(handles, outDataRslt);
end

function allExperimentData = mcsReadAllExperimentData(filePath, fileName)
% MCSREADALLEXPERIMENTDATA Read in and make available for processing
% all of the experiment data.
%
% INPUT:
%     filePath: The path of the file.
%     fileName: The name of the file.
%
% OUTPUT:
%     All of the experiment data that will be utilized throughout
%     the application.
%
% See also:
% processH5_f

dataFilePath = strcat(filePath, fileName);
allExperimentData = McsHDF5.McsData(dataFilePath);
end

function allExperimentTime = mcsReadAllExperimentTime(allExperimentData)
% MCSREADALLEXPERIMENTTIME Determine all of the experiment time from
% allExperimentData.  Time values were acquistioned in micro-seconds;
% therefore, each time value was scaled by 1e-6 to produce a
% measurement in seconds.
%
% INPUT:
%     allExperiments:  All of the experiment data.
%
% OUTPUT:
%     All of the time measurements converted into seconds.
%
% See also:
% processH5_f
% allExperimentData

allExperimentTime = double(allExperimentData.Recording{1, 1}.AnalogStream{1, 1}.ChannelDataTimeStamps) * 1e-6;
end

function allElectroporationStop = mcsReadAllElectroporationStop(allExperimentData)
% MCSREADALLELECTROPORATIONSTOP Determine all of the electroporation time
% stop times from allExperimentData.  Time values were acquistioned in
% micro-seconds; therefore, each electroporation value was scaled by 1e-6
% to produce a measurement in seconds.
%
% INPUT:
%     allExperiments:  All of the experiment data.
%
% OUTPUT:
%     All of the electroporation converted into seconds.
%
% See also:
% processH5_f
% allExperimentData

allElectroporationStop = double(allExperimentData.Recording{1,1}.EventStream{1,1}.Events{1,2}(1,:)) .* 1e-6;
end

function [wellIDs, electrodeIDs] = mcsWellElectrodeIDS(allExperimentData)
% MCSWELLELECTRODEIDS Determine the well and electrode IDs from
% allExperimentData.
%
% INPUT:
%     allExperiments:  All of the experiment data.
%
% OUTPUT:
%     Well and electrode IDs.
%
% See also:
% processH5_f
% allExperimentData

wellIDs = allExperimentData.Recording{1}.AnalogStream{1}.Info.GroupID;
electrodeIDs = str2double(allExperimentData.Recording{1}.AnalogStream{1}.Info.Label);
end

function [recordStart, recordStop] = mcsReadRecordStartAndStop(allExperimentData)
% MCSREADRECORDSTARTANDSTOP Determine all of the start and stop times from
% allExperiments.  Each start/stop time was acquisitioned in micro-seconds;
% therefore, each experiment start/stop interval was scaled by 1e-6 to produce
% a measurment in seconds.
%
% INPUT:
%     allExperiments:  All of the experiment data.
%
% OUTPUT:
%     recordStart: A vector of all of the recorded experiment start times.
%     recordStop:  A vector of all of the recorded experiment stop times.
%
% See also:
% processH5_f

allDataLabels = allExperimentData.Recording{1,1}.EventStream{1,2}.Info.Label;
recordingIndex = find(ismember(allDataLabels, 'RecordingStart'));
recordStart = double((allExperimentData.Recording{1,1}.EventStream{1,2}.Events{recordingIndex}(1,:))) .* 1e-6;

recordingIndex = find(ismember(allDataLabels, 'RecordingStop'));
recordStop = double(allExperimentData.Recording{1,1}.EventStream{1,2}.Events{recordingIndex}(1,:)) .* 1e-6;
end

function allExperimentVoltage = mcsAllExperimentVoltage(handles, allExperimentData, wellIDs, electrodeIDs, wellElectrodeQueue)
% MCSALLEXPERIMENTVOLTAGE Determine the voltage measurements from allExperiments.
% Voltage measurments was acquisitioned in pico-volts.  Each voltage should be
% converted to mV; therefore, each measurement was scaled by 1e-9 to produce a
% measurement in mV.  Voltage measurments will be rescricted to what the user selected
% in the user interface.
%
% INPUT:
%     handles:            Structure with handles and user data (see GUIDATA)
%     allExperimentData:  All of the experiment data.
%     wellIDs:            Well identifiers as selected by the user.
%     electrodeIDs:       Electrode identifier as selected by the user.
%
% OUTPUT:
%     All of the voltage measurements for the desired electrode/well
%     combination.
%
% See also:
% processH5_f
% allExperimentData

%use well values
%use electrode values
electrodeFilter = electrodeIDs == wellElectrodeQueue.electrodeUIValue;
wellFilter = wellIDs == wellElectrodeQueue.wellUIValue;
yFilter = logical(wellFilter .* electrodeFilter);
allExperimentVoltage = double(allExperimentData.Recording{1}.AnalogStream{1}.ChannelData(yFilter,:)) .* 1e-9;
end