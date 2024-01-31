function functionHandles = processFieldPotentialSegmentation_f
% PROCESSFIELDPOTENTIALSEGMENTATION_F Process a segmented field potential waveform for
% an experiment.
%
% Process the segmented waveform to create fieldData objects for each cycle.
%
% See also:
% processFieldPotentialSegmentation_f>processFieldWaveforms [main]
% processFieldPotentialSegmentation_f>processFieldData
% processFieldPotentialSegmentation_f>identifyCycleStopTimePoints
% processFieldPotentialSegmentation_f>calcSlope
%
% Author:  Jonathan Cook
% Created: 2018-08-29

functionHandles.processFieldWaveforms = @processFieldWaveforms;
functionHandles.processFieldData = @processFieldData;
functionHandles.identifyCycleStopTimePoints = @identifyCycleStopTimePoints;
functionHandles.identifySegmentedTimeAndVolts = @identifySegmentedTimeAndVolts;
functionHandles.calcSlope = @calcSlope;
end

function rslt = processFieldWaveforms(fpSection)
% PROCESSFIELDWAVEFORMS Initialize fieldData objects - given a fully
% initialized outData object, determine the fieldData information.
% Aggregate attributes that require a fieldData array will also be determined.
%
% INPUT:
%     outDataIn:  A single outData object that has been initialized through the user
%                 interface (signalQC).
%
% OUTPUT:
%     A outData object that has been fully processed with respect to its field
%     potential attributes.  If the fpOmit flag within the outData input parameter
%     is set to 1, the return value will equal the input parameter.
%
% EXCEPTION:
%     [1] If more than one outData object is being processed at a time.

if(length(fpSection) > 1)
    error('MATLAB:processFPWaveforms:multipleOutDataObjects',...
        segmentation.model.errorData.msgMultipleOutDataObjects);
end

if (fpSection.omit == 0)
    cycleAggregateCalc = segmentation.functions.cycleAggregateCalculations_f;
    [cycleTimePoints, ~] = identifyCycleStopTimePoints(fpSection.timeSection, fpSection.voltageSectionSmoothed);
    [startTime, stopTime] = cycleAggregateCalc.allCycleIntervals(fpSection.timeSection, cycleTimePoints);
    fpSection.attributeData = processFieldData(fpSection.timeSection, fpSection.voltageSection, startTime, stopTime);
    
    % Supplemental calculations.
    fpSection.attributeData = cycleAggregateCalc.allCycleInstantFrequency(fpSection.attributeData);
    fpSection.attributeData = cycleAggregateCalc.allCycleAvgFrequency(fpSection.attributeData, fpSection.leftCursorLoc, fpSection.rightCursorLoc);
    fpSection.attributeData = calcSlope(fpSection.attributeData);
    rslt = fpSection;
else
    rslt = fpSection;
end
end

function rslt = processFieldData(time, voltage, startTime, stopTime)
% PROCESSFIELDDATA Process fieldData - Within the segmented time vector
% iterate over the startTime vector to determine individual field potential
% waveforms.  Calculations that require all of the waveforms to be
% identified will not be processed here:
%     [1] instantFrequency
%     [2] avgFrequency
%     [3] slope
%
% INPUT:
%     time:       A vector of segmented time measurments.
%     voltage:    A vector of segmented voltage measurements.
%     startTime:  A vector of start times.
%     stopTime:   A vector of stop times.
%
% OUTPUT:
%     An array of fieldData objects.
%
% EXCEPTION:
%     [1] If there is an error while procesisng fieldData objects.
%
% See also:
% processFieldPotentialSegmentation_f

cycleCalc = segmentation.functions.cycleCalculations_f;
rslt(1, length(startTime)) = segmentation.model.fieldData;
for i = 1:length(startTime)
    try
        intervalTime = cycleCalc.cycleTime(time, startTime(i), stopTime(i));
        intervalVoltage = cycleCalc.cycleVoltage(time, voltage, startTime(i), stopTime(i));
        rslt(i) = segmentation.model.fieldData(i, intervalTime, intervalVoltage, startTime(i), stopTime(i));
    catch me
        causeException = MException('MATLAB:processFieldData:fieldDataObjectError',...
            segmentation.model.errorData.msgFieldDataGeneral);
        me = addCause(me, causeException);
        rethrow(me)
    end
end
end

function [finalCycleTime, finalCycleVoltage] = identifyCycleStopTimePoints(time, voltage)
% IDENTIFYCYCLESTOPTIMEPOINTS Cycle stop points - identify time points where a
% cycle should stop.  The calculation takes into consideration the next cycle.
% The difference in time between the 'current' and 'next' cycle, divided in half
% represents when a cycle should stop.  The calculation only takes into
% consideration the maximum peak values.
%
% INPUT:
%     time:    A vector of time measurements.
%     voltage: A vector of voltage measurements.
%
% OUTPUT:
%     finalCycleTime:     The time measurement when the cycle
%                         should stop.
%     finalCycleVoltage:  The voltage measurement when the cycle
%                         should stop.
%
% See also:
% processFieldPotentialSegmentation_f

if(isempty(time) || isempty(voltage))
    finalCycleTime = [];
    finalCycleVoltage = [];
    return;
end

peakVoltageIndex = segmentation.functions.peakFinder_f(voltage, [], [], 1, false, []);
peakTimePoints = time(peakVoltageIndex);

for i = 1:length(peakTimePoints)
    if(i == length(peakTimePoints))
        continue;
    else
        offset = ((peakTimePoints(i + 1) - peakTimePoints(i)) / 2) + peakTimePoints(i);
        cycleTime(i) = offset;
    end
end

% Find definite value - next highest.
for i = 1:length(cycleTime)
    [closestDiff, closestIndex] = min(abs(time - cycleTime(i)));
    finalCycleTime(i) = time(closestIndex);
    finalCycleVoltage(i) = voltage(closestIndex);
end
end

function rslt = calcSlope(fieldData)
% CALCSLOPE Slope - Determine the slope of the field potential.  For
% each fieldData object, the maximum voltage is identified, as well as
% the time point associated with the maximum voltage.  The minimum
% voltage is also identified after the time point of the maximum voltage.
% A time point associated with the minimum voltage is also identified.
% Two sets of (x, y) values are required to determine the slope
% calculation.
%
% INPUT:
%     fieldData:
%
% OUTPUT:
%     fieldData that has its slope calculated.  If the fieldPotentialVoltage
%     or fieldPotentialTime vectors are empty in the fieldData object, no
%     slope will be calculated.
%
% See also:
% processFieldPotentialSegmentation_f

for i = 1:length(fieldData)
    if(isempty(fieldData(i).fieldPotentialVoltage) || isempty(fieldData(i).fieldPotentialTime))
        continue;
    end
    
    [y1, maxIndexY] = max(fieldData(i).fieldPotentialVoltage);
    
    % Identify, 1 or 0, if where to start processing the minimum y value.
    indexFilter = fieldData(i).fieldPotentialTime > fieldData(i).fieldPotentialTime(maxIndexY);
    
    % The minIndexY is the index value AFTER the reduction by the filter - it will need
    % to be added to maxIndexY.
    [y2, minIndexY] = min(fieldData(i).fieldPotentialVoltage(indexFilter));
    
    % Retrieve the appropriate x values.
    x1 = fieldData(i).fieldPotentialTime(maxIndexY);
    x2 = fieldData(i).fieldPotentialTime(minIndexY + maxIndexY);
    
    % Slope calculation.
    fieldData(i).slope = (y2 - y1)/(x2 - x1);
end
rslt = fieldData;
end