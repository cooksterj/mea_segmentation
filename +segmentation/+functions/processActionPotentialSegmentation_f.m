function functionHandles = processActionPotentialSegmentation_f
% processSegmentation_f Process a segmented action potential waveform for an experiment.
%
% Process the segmented waveform to create apdData and peakData objects
% for each cycle.
%
% See also:
% processSegmentation_f>processActionPotentialWaveforms [main]
% processSegmentation_f>processAPDData
% processSegmentation_f>identifyCycleStopTimePoints
% processSegmentation_f>calcAttenuation
% processSegmentation_f>calcDiastolicInterval
% processSegmentation_f>findFirstAPDData
%
% Author:  Jonathan Cook
% Created: 2018-07-24

functionHandles.processActionPotentialWaveforms = @processActionPotentialWaveforms;
functionHandles.processAPDData = @processAPDData;
functionHandles.identifyCycleStopTimePoints = @identifyCycleStopTimePoints;
functionHandles.calcAttenuation = @calcAttenuation;
functionHandles.calcDiastolicInterval = @calcDiastolicInterval;
functionHandles.findFirstAPDData = @findFirstAPDData;
end

function rslt = processActionPotentialWaveforms(apSection)
% PROCESSACTIONPOTENTIALWAVEFORMS Initialize apdData/peakData objects - given
% a fully initialized outData object, determine the apdData and peakData information.
% Aggregate attributes that require an apdData array will also be determined.
%
% INPUT:
%     outDataIn:  A single outData object that has been initialized through the user
%                 interface (signalQC)
%
% OUTPUT:
%     A outData object that has been fully processed with respect to its action
%     potential attributes.  If the apOmit flag within the outData input parameter
%     is set to 1, the output outData object will equal the input.
%
% EXCEPTION:
%     [1] If more than one outData object is being processed at a time.

if(length(apSection) > 1)
    error('MATLAB:processWaveforms:multipleOutDataObjects', ...
        segmentation.model.errorData.msgMultipleOutDataObjects);
end

if(apSection.omit == 0)
    cycleAggregateCalc = segmentation.functions.cycleAggregateCalculations_f;
    [cycleTimePoints, ~] = identifyCycleStopTimePoints(apSection.timeSection, ...
        apSection.voltageSectionSmoothed);
    [startTime, stopTime] = cycleAggregateCalc.allCycleIntervals(apSection.timeSection, ...
        cycleTimePoints);
    apSection.attributeData = processAPDData(apSection.timeSection, ...
        apSection.voltageSectionSmoothed, ...
        startTime, ...
        stopTime);
    
    % Supplemental calculations.
    apSection.attributeData = cycleAggregateCalc.allCycleInstantFrequency(apSection.attributeData);
    apSection.attributeData = cycleAggregateCalc.allCycleAvgFrequency(apSection.attributeData, ...
        apSection.leftCursorLoc, ...
        apSection.rightCursorLoc);
    apSection.attributeData = calcAttenuation(apSection.attributeData);
    apSection.attributeData = calcDiastolicInterval(apSection.attributeData);
    rslt = apSection;
else
    rslt = apSection;
end
end

function rslt = processAPDData(time, voltage, startTime, stopTime)
% PROCESSAPDDATA Process individual waveforms - For each start/stop time, determine the
% apdData and peakData attributes.  Calculations that require all waveforms to be initialized
% are not processed.
%   [1] attenuation
%   [2] instantaneous frequency
%   [3] average frequency
%   [4] diastolic interval
%
% INPUT:
%     time:      A vector of time measurements that have been segmented.
%     voltage:   A vector of voltage measurements that have been segmented.
%     startTime: A vector of start times.
%     stopTime:  A vector of stop times.
%
% OUTPUT:
%     An array of apdData objects.
%
% EXCEPTION:
%     [1] If the apdData object has an exception during attribute calculation.

cycleCalc = segmentation.functions.cycleCalculations_f;
rslt(1, length(startTime)) = segmentation.model.apdData;
for i = 1:length(startTime)
    try
        intervalTime = cycleCalc.cycleTime(time, startTime(i), stopTime(i));
        intervalVoltage = cycleCalc.cycleVoltage(time, voltage, startTime(i), stopTime(i));
        apdIntermediate = segmentation.model.apdData(i, intervalTime, intervalVoltage, startTime(i), stopTime(i));
        apdIntermediate.peakData = segmentation.model.peakData(apdIntermediate.timeScale, apdIntermediate.voltageScale);
        rslt(i) = apdIntermediate;
    catch me
        causeException = MException('MATLAB:processAPDData:apdDataObjectError', ...
            'Unable to create apdData object.');
        me = addCause(me, causeException);
        throw(me)
    end
end
end

function [finalCycleTime, finalCycleVoltage] = identifyCycleStopTimePoints(time, voltage)
% IDENTIFYCYCLESTOPTIMEPOINTS Cycle stop points - within the voltage vector, determine the
% voltage and time points where a minimum peak is identified.  The method used to determin
% minimum peak values is peakFinder_f.
%
% INPUT:
%     time:     A vector of time measurements.
%     voltage:  A vector of voltage measurements.
%
% OUTPUT:
%     finalCycleTime:     A vector of time measurements where minimum voltages have been
%                         identifed.
%     finalCycleVoltage:  A vector of minimum voltage measurements.
%
% See also:
% processActionPotentialSegmentation_f
% peakFinder_f

if(isempty(time) || isempty(voltage))
    finalCycleTime = [];
    finalCycleVoltage = [];
    return;
end

troughVoltageIndex = segmentation.functions.peakFinder_f(voltage, [], [], -1, false, []);
finalCycleTime = time(troughVoltageIndex);
finalCycleVoltage = voltage(troughVoltageIndex);
end

function rslt = findFirstAPDData(processedAPDData)
% FINDFIRSTAPDDATA First peak - identify apdData object where the peakNum attribute
% is equal to a value of one.
%
% INPUT:
%     processedAPDData:  Processed action potential data.
%
% OUTPUT: An apdData object where the peakNum attribute equals one.
%
% EXCEPTION:
%     [1] If there the apdData vector is empty (never initialized)
%     [2] Within the apdData vector, there is no peakNum attribute equal to
%     a value of 1.
%
% See also:
% processActionPotentialSegmentation_f

if(isempty(processedAPDData))
    error('MATLAB:findFirstAPDData:apdDataNotInitialized', ...
        segmentation.model.errorData.msgApdDataNotInitialized);
end

finalRslt = [];
for i = 1:length(processedAPDData)
    if (processedAPDData(i).peakNum == 1)
        finalRslt = processedAPDData(i);
    end
end

if(isempty(finalRslt))
    error('MATLAB:findFirstAPDData:missingPeakNumOne', ...
        segmentation.model.errorData.msgApdDataMissingFirstPeak);
end
rslt = finalRslt;
end

function rslt = calcAttenuation(processedAPDData)
% CALCATTENUATION Peak attenuation - determine the amplitude attenuation for all
% cycles within the segmented waveform.  Each waveform is compared to the first
% waveform.  The first waveform will always have a blank attenuation.
%
% INPUT:
%    processedADPData:  Processed action potential data, other than
%    attributes that require all of the waveforms to be processed within an
%    experiment.
%
% OUTPUT:
%    An updated apdData object array where each object has their
%    average frequency calculated.
%
% EXCEPTION:
%     [1] If there is a the first peak cannot be identified.
%     [2] If apdData object array has not been initialized.
%
% See also:
% processActionPotentialSegmentation_f
% processActionPotentialSegmentation_f>findFirstAPDData

try
    firstAPDData = findFirstAPDData(processedAPDData);
    for i = 1:length(processedAPDData)
        if(isequal(processedAPDData(i), firstAPDData))
            processedAPDData(i).attenuation = [];
        else
            processedAPDData(i).attenuation = processedAPDData(i).peakVoltage - firstAPDData.peakVoltage;
        end
    end
catch me
    if (strcmp(me.identifier, 'MATLAB:findFirstAPDData:apdDataNotInitialized') ...
            || strcmp(me.identifier, 'MATLAB:findFirstAPDData:missingPeakNumOne'))
        causeException = MException('MATLAB:calcAttenuation', ...
            segmentation.model.errorData.msgApdDataAttenuation);
        me = addCause(me, causeException);
    end
    rethrow(me)
end
rslt = processedAPDData;
end

function rslt = calcDiastolicInterval(processedAPDData)
% CALCDIASTOLICINTERVAL Diastolic interval - determine the diastolic interval
% of each waveform with respect to the 'previous' waveform.  Because the
% calculation requires the 'previous' waveform, the first waveform will not
% have this attribute calculated.
%
% FORMULA:
%     diastolic interval = cycle length - previous cycle's a80
%
% WHERE:
%     cycle length = current cycle peak time - previous cycle peak time
%
% INPUT:
%    processedADPData:  Processed action potential data, other than
%    attributes that require all of the waveforms to be processed within an
%    experiment.
%
% OUTPUT:
%    An updated apdData object array where each object has their
%    diastolic inverval calculated.  If the processedAPDData object is
%    empty - the diastolic interval will be empty.
%
% EXCEPTION
%     [1] If the diastolic interval is a negative number.  Physiologically,
%     this could never happen.  The action potential of the myocyte will
%     compensate when the cycle lengths shorten.  Mathematically this is
%     possible, so if this exception is thrown, the data/calculation may warrant
%     additional investigation.
%
% See also:
% processActionPotentialSegmentation_f

for i = 1:length(processedAPDData)
    if (i == 1 || isempty(processedAPDData(i).peakTime))
        processedAPDData(i).diastolicInterval = [];
        continue;
    else
        diastolicInterval...
            = (processedAPDData(i).peakTime - processedAPDData(i - 1).peakTime)...
            - processedAPDData(i - 1).peakData.a80;
    end
    
    if(diastolicInterval < 0)
        error('MATLAB:calcDiastolicInterval:negativeDiastolicInverval',...
            segmentation.model.errorData.msgApdDataNegativeDiastolicInterval);
    else
        processedAPDData(i).diastolicInterval = diastolicInterval;
    end
end
rslt = processedAPDData;
end
