function functionHandles = cycleCalculations_f
% CYCLECALCULATIONS_F Individual cycle calculations - functions that calculate
% attributes on the individual 'periods' (single cycle) of a waveform
% segmentation.
%
% NOTE: Although this class works on the individual cycles - there are
%       functions that could work on the aggregate segmented cycles, such as
%       the cycleTime and cycleVoltage.  These functions can be safely used to
%       help segment from the 'base' waveform, or indiviual cycles with a
%       segmented waveform.
%
% See also:
% cycleCalculations_f>cyclePeakTime
% cycleCalculations_f>cyclePeakVoltage
% cycleCalculations_f>cycleTime
% cycleCalculations_f>cycleVoltage
% cycleCalculations_f>cycleMinVoltage
% cycleCalculations_f>cycleABSAmplitude
%
% Author:  Jonathan Cook
% Created: 2018-08-20ß

functionHandles.cyclePeakTime = @cyclePeakTime;
functionHandles.cyclePeakVoltage = @cyclePeakVoltage;
functionHandles.cycleTime = @cycleTime;
functionHandles.cycleVoltage = @cycleVoltage;
functionHandles.cycleMinVoltage = @cycleMinVoltage;
functionHandles.cycleABSAmplitude = @cycleABSAmplitude;
end

function rslt = cyclePeakTime(time, voltage)
% CYCLEPEAKTIME Time value at peak voltage - the time value for the
% largest value in the voltage vector.
%
% INPUT:
%     time:        A vector of time measurements.
%     voltage:     A vector of voltage measurements.
%
% OUTPUT:
%     rslt:  The time measurment when the voltage measurement is
%            at a maximum.  If either the time or voltage vectors
%         	 are empty, the return value will be empty.
% See also:
% cycleCalculations_f

rslt = [];
if(~isempty(voltage) && ~isempty(time))
    rslt = min(time(voltage == max(voltage)));
end
end

function rslt = cyclePeakVoltage(voltage)
% CYCLEPEAKVOLTAGE Highest voltage - the largest voltage measurement.
%
% INPUT:
%     voltage:  A vector of voltage measurements.
%
% OUTPUT
%     rslt:  The hight voltage measurement.  If the voltage vector
%            is empty, the return value will be empty.
%
% See also:
% cycleCalculations_f

rslt = [];
if(~isempty(voltage))
    rslt = max(voltage);
end
end

function rslt = cycleMinVoltage(time, voltage, peakTime)
% CYCLEMINVOLTAGE Smallest voltage after peak time - the smallest
% voltage measurement after the time at which the peak voltage has
% been identified.  This does not represent a 'true' minimum.  It
% is with respect to peak time.
%
% INPUT:
%     time:       A vector of time measurements.
%     voltage:    A vector of voltage measurements.
%     peakTime:   The time at which the voltage was the highest.
%
% OUTPUT:
%     rslt:  The smallest voltage measurement within the voltage
%            vector after the peak time.  If the time, voltage, or
%            peakTime vectors/values are empty, the return value will
%            be empty.  If the peakTime is not wihin the time vector,
%            the return value will be empty.
%
% See also:
% cycleCalculations_f

rslt = [];
if(~isempty(voltage) && ~isempty(time) && ~isempty(peakTime))
    rslt = min(voltage(time > peakTime));
end
end

function rslt = cycleABSAmplitude(max, min)
% CYCLEABSAMPLITUDE Amplitude - the difference between the min
% and max values.
%
% INPUT:
%     max:  A max value [typically voltage].
%     min:  A min value [typically voltage].
%
% OUTPUT:
%     rslt: The difference between the max and min value.  If
%           the max or min values are empty, or if min is
%           greater than max, the return value will be empty.
%
% See also:
% cycleCalculations_f

rslt = [];
if(~isempty(max) && ~isempty(min) && (max > min))
    rslt = max - min;
end
end

function rslt = cycleTime(time, startTime, stopTime)
% CYCLETIME Cycle time vector - Reduce the time vector to all values
% >= the start time and <= the stop time.  The start and stop times
% will be validated against the time vector as well as with respect to each
% other.  Refer to the see also section.
%
% INPUT:
%     time:       A vector of time measurements.
%     startTime:  The start time.
%     stopTime:   The stop time.
%
% OUTPUT:
%     rslt:  A time vector whose values are between the start and stop
%            time.
%
% EXCEPTION:
%     [1] If validation fails - refer to cycleAggregateCalculations_f.validateStartStopTimeInterval.
%         Built into the validation is a test to ensure the time vector is not empty.
%
% See also:
% cycleAggregateCalculations_f.validateStartStopTimeInterval [validation]
% cycleCalculations_f


calcAggregateCalc = segmentation.functions.cycleAggregateCalculations_f;
calcAggregateCalc.validateStartStopTimeInterval(time, startTime, stopTime);
rslt = time(time >= startTime & time <= stopTime);
end

function rslt = cycleVoltage(time, voltage, startTime, stopTime)
% CYCLEVOLTAGE Cycle voltage vector - Reduce the voltage vector to all values
% that have a time measurement >= start time and <= stop time.  The start and stop
% times will be validated against the time vector, as well as with respect to each
% other.  Refer to the see also section.
%
% INPUT:
%     time:       A vector of time measurements.
%     voltage:    A vector of voltage measurements.
%     startTime:  The start time.
%     stopTime:   The stop time.
%
% OUTPUT:
%     rslt:  A voltage vector whose values are between time values
%            between the start and stop time.
%
% EXCEPTION:
%     [1] If validation fails - refer to cycleAggregateCalculations_f.validateStartStopTimeInterval.
%         Built into the validation is a test to ensure the time vector is not empty.
%     [2] If the voltage vector is empty.
%
% See also:
% cycleAggregateCalculations_f.validateStartStopTimeInterval [validation]
% cycleCalculations_f

if(isempty(voltage))
    error('MATLAB:waveformVoltage:voltageEmpty', ...
        segmentation.model.errorData.msgCycleCalculationsVoltageVectorEmpty);
end

calcAggregateCalc = segmentation.functions.cycleAggregateCalculations_f;
calcAggregateCalc.validateStartStopTimeInterval(time, startTime, stopTime);
rslt = voltage(time >= startTime & time <= stopTime);
end


