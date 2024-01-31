function functionHandles = signalQC_f
% SIGNALQC_F Signal quality control - display baseline, segmentation,
% and the basic statistic summary to the user as they progress through
% the user interface.
%
% The baseline, segmented, and boxplot summary will be displayed for each
% initialized experiment.
%
% See also:
% signalQC_f>plotBaseWaveform
% signalQC_f>plotSegmentedWaveform
% signalQC_f>plotBasicStats
%
% Author:          Jonathan Cook
% Original Author: Don Conrad
%                  [Content was heavilty refactored with the permission of the
%                  original author]
% Created:         2018-08-24

functionHandles.plotBaseWaveform = @plotBaseWaveform;
functionHandles.plotSegmentedWaveform = @ plotSegmentedWaveform;
functionHandles.plotBasicStats = @plotBasicStats;
end

function rslt = plotBaseWaveform(initializedExperiments, handles)
% PLOTBASEWAVEFORM Base waveform - plot the experiment's voltage vs. time measurments.
% This will allow the user to interact with the baseline waveform for
% segmentation and eventual summary statistics.
%
% Input:
%     initializedExperiments:  An experiment object that has been initialized
%                              through the objects constructor.
%     handles:                 A structure of objects from waveformAnalysis
%                              figure that has available the base waveform axis.
%
% Output:
%     A outData object that has the following state depending how the user
%     has interacted with the waveformAnalysis figure.
%         [1] If the baseline waveform has been kept the plotSegmentedWaveform
%         function will be called. Depending on how the user interacts with
%         this data, additional attributes within the outData object may or
%         may not be populated.
%
%         [2] If the baseline, segmented waveforms, and/or statistics have
%         not been kept, the return value will not have additional attributes
%         initialized that are not part of the outData constructor except for the
%         medication name and concentration. The process and omit status in the
%         returned outData object will equal 1.
%
%     The output will either be a fully processed outData object
%     with either the apdData and peakData object fully populated, or
%     completely blank.
%
% See also:
% signalQC_f
% plotSegmentedWaveform [called if waveform is kept]
% experiments
% outData
% apdData
% peakData
% experiments
% waveformAnalysis

i = 1;
while i <= length(initializedExperiments.outDataRslt)
    set(handles.ns, 'Value', 1);
    cla(handles.baseWaveform, 'reset');
    cla(handles.segmentedWaveformFieldPotential, 'reset');
    cla(handles.basicStatsFieldPotential, 'reset');
    cla(handles.segmentedWaveformActionPotential, 'reset');
    cla(handles.basicStatsActionPotential, 'reset');
    
    % Plot measured voltage vs. time.
    basePlotHandle = plot(handles.baseWaveform, initializedExperiments.outDataRslt(i).time, initializedExperiments.outDataRslt(i).voltage);
    hold(handles.baseWaveform, 'on');
    
    % Plot the electroporation events.
    scatter(handles.baseWaveform, initializedExperiments.outDataRslt(i).esub, ones(size(initializedExperiments.outDataRslt(i).esub)));
    
    % Establish the title.
    label = sprintf('Well: %s, Electrode: %s, Experiment Number: %d',...
        initializedExperiments.outDataRslt(i).wellElectrodeData.wellStrLabel, ...
        initializedExperiments.outDataRslt(i).wellElectrodeData.electrodeStrLabel, ...
        initializedExperiments.outDataRslt(i).experimentNum);
    title(handles.baseWaveform, label, 'FontSize', 10);
    handles.baseWaveform.YLabel.String = 'Voltage [mV]';
    handles.baseWaveform.XLabel.String = 'Time [sec]';
    
    % Ideal start and stop time/voltage markers.
    fixLeft = initializedExperiments.outDataRslt(i).esub(end) + 5;
    fixRight = min(initializedExperiments.outDataRslt(i).esub(end) + 15, initializedExperiments.outDataRslt(i).time(end));
    
    if (initializedExperiments.outDataRslt(i).esub(end) + 15 > initializedExperiments.outDataRslt(i).time(end))
        eLabelText = {'estop + 5 sec', 'end of exp'};
    else
        eLabelText = {'estop + 5 sec', 'estop + 15 sec'};
    end
    
    % Plot the ideal markers - for cursor usage
    scatter(handles.baseWaveform, [fixLeft fixRight], [1 1]);
    text(handles.baseWaveform, [fixLeft + .2 fixRight + .2], [1 1], eLabelText);
    
    % Cursor autodetection.
    auto = segmentation.functions.autoSegmentDetection_f;
    auto.apFPCursors(handles.waveformAnalysisFigure, basePlotHandle, initializedExperiments.outDataRslt(i));
    hold(handles.baseWaveform, 'off');
    
    initializedExperiments.outDataRslt(i) = plotSegmentedWaveform(initializedExperiments.outDataRslt(i), handles);
    i = i + 1;
end
rslt = initializedExperiments.outDataRslt;
end

function rslt = getCursors(outDataRslt, handles)
% TODO: Comments

cursorMode = datacursormode(handles.waveformAnalysisFigure);
cursorInfo = getCursorInfo(cursorMode);

signalQCCursor = segmentation.functions.signalQCCursor_f;
rslt = signalQCCursor.fpAPCursorPositions(outDataRslt.esub, cursorInfo);
end

function rslt = plotSegmentedWaveform(outDataRslt, handles)
% PLOTSEGMENTEDWAVEFORM Plot of segmented waveform - using the segmented data
% in outDataRslt, plot the data to the user for validation.  Trough and
% peaks will be identified to provide a quick method of quality control.
% Depending on how the cursors have been selected by the user - different plots
% will be generated [see signalQCCursor for more details].
%
% INPUT:
%     outDataRslt:  An outData object that has been kept by plotBaseWaveform.
%     handles:      A structure of objects from waveformAnalysis
%                   figure that has available the segmented waveform axis.
%
% OUTPUT:
%     A outData object that has the following state depending how the user
%     has interacted with the waveformAnalysis figure.
%         [1] If the segmented waveform has been kept, the
%         plotBasicStats function will be called.  The voltageSub,
%         timeSub, leftCursorLoc, rightCursorLoc, measGap, medication
%         name, medication concentration and apdData, peakData will be
%         initialized.
%
%         [2] If the segmented waveform and/or statistics have not been
%         kept, the return value will not have the apdData/peakData and/or
%         fieldData objects populated.  The process and omit status will
%         equal 1.
%
% See also:
% signalQC_f
% plotBasicStats [called if segmented waveform is kept]
% plotBaseWaveform [caller]
% outData
% apdData
% peakData
% fieldData
% signalQCCursor
% experiments
% waveformAnalysis

set(handles.ns, 'Value', 1);
cursorPositions = getCursors(outDataRslt, handles);

% Assign medication name and concentration.
outDataRslt.medicationName = handles.medicationNameText.String;
outDataRslt.medicationConcen = handles.medicationConcentrationText.String;

% Check the cursor types and plot accordingly.
for i = 1:length(cursorPositions)
    
    % Plot the action potential segmentation.
    if(strcmp(cursorPositions(i).cursorType, "Action Potential"))
        outDataRslt = plotSegmentedActionPotential(outDataRslt, cursorPositions(i), handles);
    end
    
    % Plot the action potential segmentation.
    if(strcmp(cursorPositions(i).cursorType, "Field Potential"))
        outDataRslt = plotSegmentedFieldPotential(outDataRslt, cursorPositions(i), handles);
    end
end

% Wait for the user to select 'Keep' or 'Skip'
waitfor(handles.waveformOptionsPanel, 'SelectedObject');
if (strcmp(convertCharsToStrings(handles.waveformOptionsPanel.SelectedObject.String), "Keep"))
    outDataRslt.fpSection.processed = 1;
    outDataRslt.fpSection.omit = 0;
elseif (strcmp(convertCharsToStrings(handles.waveformOptionsPanel.SelectedObject.String), "Update"))
    cursorPositions = getCursors(outDataRslt, handles);
    fpCursorRowIndex = find(cellfun(@(x)isequal(x, "Field Potential"), {cursorPositions.cursorType}));
    apCursorRowIndex = find(cellfun(@(x)isequal(x, "Action Potential"), {cursorPositions.cursorType}));
    plotSegmentedWaveform(outDataRslt, handles);
else
    outDataRslt.fpSection.processed = 1;
    outDataRslt.fpSection.omit = 1;
    outDataRslt.apSection.processed = 1;
    outDataRslt.apSection.omit = 1;
end
rslt = outDataRslt;
end

function rslt = plotSegmentedActionPotential(outDataRslt, apCursorPosition, handles)
% TODO: Comments

cla(handles.segmentedWaveformActionPotential);
apProcessSegmentation = segmentation.functions.processActionPotentialSegmentation_f;
cycleAggregateCalculations = segmentation.functions.cycleAggregateCalculations_f;

% Get cursor positions.
leftCursorLoc = apCursorPosition.leftCursor;
rightCursorLoc = apCursorPosition.rightCursor;

[segmentedTime, segmentedVoltage, segmentedVoltageSmoothed]...
    = cycleAggregateCalculations.allCycleTimeAndVolts(outDataRslt.time, outDataRslt.voltage,...
    leftCursorLoc, rightCursorLoc);

outDataRslt.apSection = segmentation.model.section(segmentation.model.sectionType.ACTION_POTENTIAL, ...
    segmentedVoltage, ...
    segmentedVoltageSmoothed, ...
    segmentation.model.smoothAlgorithmType.SLIDING_WINDOW_AVERAGE, ...
    segmentedTime, ...
    leftCursorLoc, ...
    rightCursorLoc);

plot(handles.segmentedWaveformActionPotential, segmentedTime, segmentedVoltageSmoothed);
hold(handles.segmentedWaveformActionPotential, 'on');

[maxPeakXIndex, maxPeakY] = segmentation.functions.peakFinder_f(segmentedVoltageSmoothed, [], [], 1, false, []);
plot(handles.segmentedWaveformActionPotential, segmentedTime(maxPeakXIndex), maxPeakY, 'x');
hold(handles.segmentedWaveformActionPotential, 'on');

[cycleTimePoints, cycleVoltagePoints] = apProcessSegmentation.identifyCycleStopTimePoints(segmentedTime, segmentedVoltageSmoothed);
plot(handles.segmentedWaveformActionPotential, cycleTimePoints, cycleVoltagePoints, 'o');
hold(handles.segmentedWaveformActionPotential, 'off');

handles.segmentedWaveformActionPotential.YLabel.String = 'Voltage [mV]';
handles.segmentedWaveformActionPotential.XLabel.String = 'Time [sec]';
zoom(handles.baseWaveform, 'out')

outDataRslt = segmentation.model.experiments.processActionPotentialData(outDataRslt);
rslt = plotBasicActionPotentialStats(outDataRslt, handles);
end

function rslt = plotSegmentedFieldPotential(outDataRslt, fpCursorPosition, handles)
% TODO: Comments

cla(handles.segmentedWaveformFieldPotential);
fpProcessSegmentation = segmentation.functions.processFieldPotentialSegmentation_f;
cycleAggregateCalculations = segmentation.functions.cycleAggregateCalculations_f;

% Get cursor positions.
leftCursorLoc = fpCursorPosition.leftCursor;
rightCursorLoc = fpCursorPosition.rightCursor;

[segmentedTime, segmentedVoltage, segmentedVoltageSmoothed]...
    = cycleAggregateCalculations.allCycleTimeAndVolts(outDataRslt.time, outDataRslt.voltage,...
    leftCursorLoc, rightCursorLoc);

outDataRslt.fpSection = segmentation.model.section(segmentation.model.sectionType.FIELD_POTENTIAL, ...
    segmentedVoltage, ...
    segmentedVoltageSmoothed, ...
    segmentation.model.smoothAlgorithmType.SLIDING_WINDOW_AVERAGE, ...
    segmentedTime, ...
    leftCursorLoc, ...
    rightCursorLoc);

plot(handles.segmentedWaveformFieldPotential, segmentedTime, segmentedVoltageSmoothed);
hold(handles.segmentedWaveformFieldPotential, 'on');

[maxPeakXIndex, maxPeakY] = segmentation.functions.peakFinder_f(segmentedVoltageSmoothed, [], [], 1, false, []);
plot(handles.segmentedWaveformFieldPotential, segmentedTime(maxPeakXIndex), maxPeakY, 'x');
hold(handles.segmentedWaveformFieldPotential, 'on');

[cycleTimePoints, cycleVoltagePoints] = fpProcessSegmentation.identifyCycleStopTimePoints(segmentedTime, segmentedVoltageSmoothed);
plot(handles.segmentedWaveformFieldPotential, cycleTimePoints, cycleVoltagePoints, 'o');
hold(handles.segmentedWaveformFieldPotential, 'off');

handles.segmentedWaveformFieldPotential.YLabel.String = 'Voltage [mV]';
handles.segmentedWaveformFieldPotential.XLabel.String = 'Time [sec]';
zoom(handles.baseWaveform, 'out')

outDataRslt = segmentation.model.experiments.processFieldData(outDataRslt);
rslt = plotBasicFieldPotentialStats(outDataRslt, handles);
end

function rslt = plotBasicFieldPotentialStats(outDataRslt, handles)
% PLOTBASICFIELDPOTENTIALSTATS Basic statistics for field potential segmentation -
% display a box plot of all field potential cycles.
%
% INPUT:
%     outDataRslt:  An outData object that contains fieldData that has been populated.
%     handles:      A structure of objects from waveformAnalysis
%                   figure that has available the segmented waveform axis.
% OUTPUT:
%     An outData object with the fpProcessed and fpOmit flags set.
%
% See also:
% signalQC_f
% plotSegmentedWaveform [caller]
% outData
% fieldData
% waveformAnalysis

cla(handles.basicStatsFieldPotential, 'reset');
set(handles.ns, 'Value', 1);
allAmplitudeData = [outDataRslt.fpSection.attributeData(:).absAmplitude];

boxplot(handles.basicStatsFieldPotential, allAmplitudeData);
handles.basicStatsFieldPotential.YLabel.String = 'Amplitude [mV]';
handles.basicStatsFieldPotential.XLabel.String = 'Field Potentials';
title(handles.basicStatsFieldPotential, "QC FP Boxplot", 'FontSize', 10);
rslt = outDataRslt;
end

function rslt = plotBasicActionPotentialStats(outDataRslt, handles)
% PLOTBASICACTIONPOTENTIALSTATS Basic statistics for action potential segmentation -
% using the apdData that was initialized by plotSegmentedWaveform, plot each
% apdData normalized voltage measurements and time shifted time measurements.
% Each repolarization interval will also be displayed for quick quality control.
%
% INPUT:
%     outDataRslt:  An section object that has been processed by plotSegmentedWaveform.
%     handles:      A structure of objects from waveformAnalysis
%                   figure that has available the basicStats waveform axis.
%
% OUTPUT:
%     A outData object that has the following state depending how the user
%     has interacted with the waveformAnalysis figure.
%         [1] If the statistics plot has been kept, all of the
%         attributes in the outDataRslt parameter will be kept.  The
%         process state will be set to 1, the omit state will be set to 0.
%
%         [2] If the statistics plot has not been kept, the returned
%         outData object will have the leftCursorLoc, rightCursorLoc,
%         timeSub, voltageSub, and measGap set to blank.  The process
%         and omit status will equal 1.
%
% See also:
% signalQC_f
% plotSegmentedWaveform [caller]
% outData
% peakData
% waveformAnalysis

cla(handles.basicStatsActionPotential, 'reset');
set(handles.ns, 'Value', 1);
for i = 1:length(outDataRslt.apSection.attributeData)
    try
        plot(handles.basicStatsActionPotential, outDataRslt.apSection.attributeData(i).timeScale, outDataRslt.apSection.attributeData(i).voltageScale);
        hold(handles.basicStatsActionPotential, 'on');
    catch
        continue;
    end
end

% Summarize each repolarization - mean value.
allPeakData = [outDataRslt.apSection.attributeData(:).peakData];
apdBoxes(:, 1) = [allPeakData(:).a20]; % First position
apdBoxes(:, 2) = [allPeakData(:).a30]; % Second position
apdBoxes(:, 3) = [allPeakData(:).a40]; % Third position
apdBoxes(:, 4) = [allPeakData(:).a50]; % Fourth position
apdBoxes(:, 5) = [allPeakData(:).a60]; % Fifth position
apdBoxes(:, 6) = [allPeakData(:).a70]; % Sixth position
apdBoxes(:, 7) = [allPeakData(:).a80]; % Seventh position
apdBoxes(:, 8) = [allPeakData(:).a90]; % Eight position
labelNbr = round(mean(apdBoxes), 4);

% The label will be used to display each repolarization mean.
for j=1:length(labelNbr)
    switch(j)
        case 1 % First position A20 [80% of the waveform is remaining]
            label(j) = cellstr(['\leftarrow ', '20% ', num2str(labelNbr(j))]);
        case 2 % Second position A30 [70% of the waveform is remaining]
            label(j) = cellstr(['\leftarrow ', '30% ',num2str(labelNbr(j))]);
        case 3 % Third position A40 [60% of the waveform is remaining]
            label(j) = cellstr(['\leftarrow ', '40% ',num2str(labelNbr(j))]);
        case 4 % Fourth position A50 [50% of the waveform is remaining]
            label(j) = cellstr(['\leftarrow ', '50% ',num2str(labelNbr(j))]);
        case 5 % Fifth position A60 [40% of the waveform is remaining]
            label(j) = cellstr(['\leftarrow ', '60% ',num2str(labelNbr(j))]);
        case 6 % Sixth position A70 [30% of the waveform is remaining]
            label(j) = cellstr(['\leftarrow ', '70% ',num2str(labelNbr(j))]);
        case 7 % Seventh position A80 [20% of the waveform is remaining]
            label(j) = cellstr(['\leftarrow ', '80% ',num2str(labelNbr(j))]);
        case 8 % Eighth position A90 [10% of the waveform is remaining]
            label(j) = cellstr(['\leftarrow ', '90% ',num2str(labelNbr(j))]);
    end
end

% Add the labels to the basic stats stacked waveforms.
text(handles.basicStatsActionPotential, mean(apdBoxes), 0.8:-0.1:0.1, label, 'HorizontalAlignment', 'left', 'Fontsize', 10);
hold(handles.basicStatsActionPotential, 'on');

handles.basicStatsActionPotential.YLabel.String = 'Normalized Voltage';
handles.basicStatsActionPotential.XLabel.String = 'Shifted Time [s]';
title(handles.basicStatsActionPotential, "QC AP Stacked Waveforms", 'FontSize', 10);
rslt = outDataRslt;
end