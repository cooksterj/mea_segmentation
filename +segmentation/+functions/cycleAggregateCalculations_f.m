function functionHandles = cycleAggregateCalculations_f
% CYCLEAGGREGATECALCULATIONS_F Calculations involving the entire segmentation -
% functions that calculate attributes on the users segmentation that are
% common.
%
% See also:
% cycleAggregateCalculations_f>allCycleLength
% cycleAggregateCalculations_f>allCycleIntervals
% cycleAggregateCalculations_f>allCycleTimeAndVolts
% cycleAggregateCalculations_f>allCycleAvgFrequency
% cycleAggregateCalculations_f>allCycleInstantFrequency
% cycleAggregateCalculations_f>validateStartStopTimeInterval
% cycleAggregateCalculations_f>validateTimeIntervals
%
% Author:  Jonthan Cook
% Created: 2018-08-22

functionHandles.allCycleLength = @allCycleLength;
functionHandles.allCycleIntervals = @allCycleIntervals;
functionHandles.allCycleTimeAndVolts = @allCycleTimeAndVolts;
functionHandles.allCycleInstantFrequency = @allCycleInstantFrequency;
functionHandles.allCycleAvgFrequency = @allCycleAvgFrequency;
functionHandles.validateStartStopTimeInterval = @validateStartStopTimeInterval;
functionHandles.validateTimeIntervals = @validateTimeIntervals;
end

function rslt = allCycleLength(obj)
% ALLCYCLELENGTH Cycle length - within the input obj, determine
% the cycle length with respect to the 'next' cycle within a particular
% segmentation.  The cycle length is defined the duration in time between
% peaks (peak-to-peak measurement).
%
% INPUT:
%     obj:  The object that contains all cycles between a start and stop time
%           interval.
%
% OUTPUT:
%     rslt: Cycle length per cycle in the obj parameter.  The last cycle length
%     attribute will always be empty - the next cycle is not available.  If
%     the current peak time is empty - the cycle lengh will also be empty.

for i = 1:length(obj)
    if(i == length(obj) || isempty(obj(1, i).peakTime))
        obj(1, i).cycleLength = [];
    else
        obj(1, i).cycleLength = (obj(1, (i + 1)).peakTime - obj(1, i).peakTime);
    end
end
rslt = obj;
end

function [startTime, stopTime] = allCycleIntervals(time, troughTimePoints)
% ALLCYCLEINTERVALS Determine start and stop time intervals - using
% time points that represent a 'trough', identify the start and stop
% intervals for all of the cycles in a segmentation.
%
% INPUT:
%     time:              A vector of time measurements.
%     troughTimePoints:  Time points that represent potential
%                        cycle tarting or ending points within
%                        the segmented time vector.
%
% OUTPUT:
%     startTime:  A vector of start times within the input time vector.
%     stopTime:   A vector of stop times within the input time vector.
%
% EXCEPTION:
%     [1] If validationTimeIntervals fails.  Refer to the 'see also'
%     section.
%
% See also:
% cycleAggregateCalculations_f
% validateTimeIntervals [validation]

% Preallocation and validation.
validateTimeIntervals(time, troughTimePoints);
len = length(troughTimePoints) + 1;
startTime = zeros(1, len);
stopTime = zeros(1, len);

for i = 1 : len
    if i == 1
        startTime(i) = time(1, 1);
        stopTime(i) = troughTimePoints(1, 1);
        
    elseif i == length(troughTimePoints) + 1
        startTime(i) = troughTimePoints(i - 1);
        stopTime(i) = time(1, length(time));
        
    else
        startTime(i) = troughTimePoints(i - 1);
        stopTime(i) = troughTimePoints(i);
    end
end
end

function [segmentedTime, segmentedVoltage, segmentedVoltageSmoothed]...
    = allCycleTimeAndVolts(time, voltage, startTime, stopTime)
% ALLCYCLETIMEANDVOLTS Identify the segmented time, voltage, and smoothed voltage -
% For a specific start and stop time, segment the time and voltages that
% fall between the start and stop time values.  In addition to the segmented
% voltage, provide the smoothed version of the segmented voltage.
%
% INPUT:
%     time:       A vector of time measurements.
%     voltage:    A vector of voltage measurements.
%     startTime:  The start time value.
%     stopTime:   The stop time value.
%
% OUTPUT:
%     segmentedTime:             The segmented time.
%     segmentedVoltage:          The segmented voltage.
%     segmentedVoltageSmoothed:  The smoothed segmented voltage vector.
%
% See also:
% cycleAggregateCalculations_f
% cycleCalculations_f
% smooth_f

cycleCalculations = segmentation.functions.cycleCalculations_f;
segmentedTime = cycleCalculations.cycleTime(time, startTime, stopTime);
segmentedVoltage = cycleCalculations.cycleVoltage(time, voltage, startTime, stopTime);
segmentedVoltageSmoothed = segmentation.functions.smooth_f(segmentedVoltage, 51);
end

function rslt = allCycleAvgFrequency(obj, startTime, stopTime)
% ALLCYCLEAVGFREQUENCY Average frequency - within the input obj, determine
% the average frequncy using the start and stop time interval for the
% entire segmentation.
%
% NOTE: It is assumed the obj input parameter has average frquency
%       as an attribute [avgFrequency].
%
% INPUT:
%     obj:        The object that contains all cycles between a start and
%                 stop interval.
%     startTime:  The start time value for the entire segmentation.
%     stopTime:   The stop time value for the entire segmentation.
%
% OUTPUT:
%     rslt:  Average frequency.  All average frequency attributes will contain
%            the same value.  If either the startTime or stopTime is empty, the
%            returned object will equal in the input object.  Additionally, if the
%            startTime is greater than the stopTime, the returned object will
%            equal the input object.
%
% See also:
% cycleAggregateCalculations_f

if(isempty(startTime) || isempty(stopTime) || isempty(obj) || startTime > stopTime)
    rslt = obj;
    return;
end

maxNumPeaks = max(max([obj.peakNum]));
avgFrequency = maxNumPeaks / (stopTime - startTime);

for i = 1:length(obj)
    obj(1, i).avgFrequency = avgFrequency;
end
rslt = obj;
end

function rslt = allCycleInstantFrequency(obj)
% ALLCYCLEINSTANTFREQUENCY Instantaneous frequency - within the input obj, determine
% the instantaneous frequency with respect to the 'next' cycle within a particular
% segmentation.  Instantaneous frequency is defined as 1 / cycle length.
%
% NOTE:  It is assumed the obj input parameter has instantaneous frequency as an
%        attribute [instantFrequency].
%
% INPUT:
%     obj:  The object that contains all cycles between a start and stop time
%           interval.
%
% OUTPUT:
%     rslt: Instantaneous frequency per cycle in the obj parameter.  The last
%           cycle's instantaneous frequency attribute will always be empty - the
%           next cycle is not available.  If the cycle length is empty, the
%           instantaneous frequency is also empty.
%
% See also:
% cycleAggregateCalculations_f

obj = allCycleLength(obj);
for i = 1:length(obj)
    if(i == length(obj) || isempty(obj(1, i).cycleLength))
        obj(1, i).instantFrequency = [];
    else
        obj(1, i).instantFrequency = 1 / obj(1, i).cycleLength;
    end
end
rslt = obj;
end

function validateStartStopTimeInterval(time, startTime, stopTime)
% VALIDATESTARTSTOPTIMEINTERVAL Time validation - validate the time vector, and the
% start/stop interval.
%   [1] Each input parameter should not be empty
%   [2] The start and stop time values should be a 'member' of the time vector.
%   [3] The start time interval should never be after the stop time interval.
%   [4] The stop time interval should never be before the start time interval.
%   [5] Multiple start or stop intervals have been detected.  Only one start or stop
%       should be processed at a time.
%
% If any of the five conditions are met, an error is thrown.
%
% INPUT:
%     time:       A vector of time measurements.
%     startTime:  The start time value for the entire segmentation.
%     stopTime:   The stop time value for the entire segmentation.
%
% See also:
% cycleAggregateCalculations_f

if(length(startTime) > 1 || length(stopTime) > 1)
    error('MATLAB:validateStartStopTimeInterval:multipleStartOrStopIntervals', ...
        segmentation.model.errorData.msgCycleAggregateCalculationsMultipleStartStop)
end

if (isempty(time) || isempty(startTime) || isempty(stopTime))
    error('MATLAB:validateStartStopTimeInterval:emptyStartStopOrTime', ...
        segmentation.model.errorData.msgCycleAggregateCalculationsEmptyStartStop)
end

if (~ismember(startTime, time) || ~ismember(stopTime, time))
    error('MATLAB:validateStartStopTimeInterval:notValid', ...
        segmentation.model.errorData.msgCycleAggregateCalculationsInvalidStartStop, ...
        num2str(startTime), num2str(stopTime));
end

if (startTime >= stopTime)
    error('MATLAB:validateStartStopTimeInterval:incorrectStartStop', ...
        segmentation.model.errorData.msgCycleAggregateCalculationsStartGreaterStop', ...
        startTime, stopTime);
end
end

function validateTimeIntervals(time, troughTimePoints)
% VALIDATETIMEINTERVALS Time validation - validate the time vector, and the
% trough time values that help identify a cycle.
%   [1] Each input parameter should not be empty.
%   [2] Each trough time value should never be before the smallest time value.
%   [3] Each trough time value should never be after the largest time value.
%   [4] Each trough time value should be in the time vector.
%
% If any of the four condition are not met, an error is thrown.
%
% INPUT:
%     time:              A vector of time measurements.
%     troughTimePoints:  Points in time that represent a potential cycle within
%                        a segmentation.
%
% See also:
% cycleAggregateCalculations_f

if (isempty(time) || isempty(troughTimePoints))
    error('MATLAB:validateTimeIntervals:empty', ...
        segmentation.model.errorData.msgCycleAggregateCalculationsTimeEmpty);
end

for i = 1 : length(troughTimePoints)
    if (troughTimePoints(i) < min(time) || troughTimePoints(i) > max(time))
        error('MATLAB:validateTimeIntervals:outOfRange', ...
            segmentation.model.errorData.msgCycleAggregateCalculationsTroughOutOfRange);
    end
    
    if (~ismember(troughTimePoints(i), time))
        error('MATLAB:validateTimeIntervals:notValid',...
            segmentation.model.errorData.msgCycleAggregateCalculationsTroughNotEqual);
    end
end
end