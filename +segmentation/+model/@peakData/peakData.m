classdef peakData
    % PEAKDATA Individual peak class
    %   Starting at the timestamp at peak amplitude, time intervals
    %   at decreasing amplitude percentages from 100% are determined.,
    %   As well as calculations that utilize the repolarizations.
    %
    % Author:  Jonathan Cook
    % Created: 2018-08-23
    
    properties
        apdRatio     % Action potential ratio.
        apdDiff      % Action potential difference.
        triang       % Action potential triangulation.
        frac         % Action potential fractional repolarization.
        a20          % 20% repolarization (80% of waveform remains - starting at the peak).
        a30          % 30% repolarization (70% of waveform remains - starting at the peak).
        a40          % 40% repolarization (60% of waveform remains - starting at the peak).
        a50          % 50% repolarization (50% of waveform remains - starting at the peak).
        a60          % 60% repolarization (40% of waveform remains - starting at the peak).
        a70          % 70% repolarization (30% of waveform remains - starting at the peak).
        a80          % 80% repolarization (20% of waveform remains - starting at the peak).
        a90          % 90% repolarization (10% of waveform remains - starting at the peak).
    end
    
    properties (Constant)
        apdRange = 0.1:0.1:0.9;  % Action potential range.
        apdOffset = 0.005;       % Action potential range offset - used to determine sub AP intervals.
    end
    
    methods
        function obj = peakData(timeScale, voltageScale)
            % PEAKDATA Constructor - during instantiation, each attribute will be determined
            % from the timeScale and voltageScale.
            %
            % INPUT:
            %     timeScale:     Time where the max voltage equals time zero.s
            %     voltageScale:  Voltage measurements whose max value is equal to 1 (normalized).
            %
            % OUTPUT:
            %     Initialized peakData object.
            
            if nargin > 0
                apdValue = obj.apdRange;
                for i = 1:length(apdValue)
                    [tAPDRange, vAPDRange] = timeAndVoltageAPDRange(obj, apdValue(i), timeScale, voltageScale);
                    if(isempty(tAPDRange))
                        break;
                    end
                    
                    peakAttr = calcPeakAttr(obj, apdValue(i), tAPDRange, vAPDRange);
                    switch round(obj.apdRange(i), 1)
                        case 0.1000
                            obj.a90 = peakAttr;
                        case 0.2000
                            obj.a80 = peakAttr;
                        case 0.3000
                            obj.a70 = peakAttr;
                        case 0.4000
                            obj.a60 = peakAttr;
                        case 0.5000
                            obj.a50 = peakAttr;
                        case 0.6000
                            obj.a40 = peakAttr;
                        case 0.7000
                            obj.a30 = peakAttr;
                        case 0.8000
                            obj.a20 = peakAttr;
                    end
                end
            end
            
            obj.apdDiff = calcDifference(obj, obj.a90, obj.a50);
            obj.apdRatio = calcRatio(obj, obj.a90, obj.a50);
            obj.triang = calcDifference(obj, obj.a80, obj.a30);
            obj.frac = calcFrac(obj, obj.a80, obj.a30);
        end
        
        function [timeAPDRange, voltageAPDRange] = timeAndVoltageAPDRange(obj, apdPct, timeScale, voltageScale)
            % TIMEANDVOLTAGEAPDRANGE Time and voltage ranges for interpolation - determine the action
            % potential time and voltage range for a specific repolarization percentage.  A range is
            % required because a time measurement may not fall on the exact repolarization
            % percentage - due the sample rate of 20,000Hz.
            %
            % INPUT:
            %     apdPct:       The percentage of the waveform that is 'remaining'
            %                   after the peak.
            %     timeScale:    The time vector such that the zeroth time
            %                   represents the peak voltage (time shifted).
            %     voltageScale: The voltage vector such that the measured
            %                   peak voltage resides at time zero.  The
            %                   maximum value should be 1 (normalized to the
            %                   amplitude).
            %
            % OUTPUTS:
            %     timeAPDRange:     Range of time values that are greater
            %                       than zero and fall within the apdPct +/- 0.005.
            %     voltageAPDRange:  Range of voltage values fall within the
            %                       apdPct +/- 0.005.
            %
            % EXCEPTION:
            %     [1] If the voltageScale's maximum value does not equal 1.  Incorrect normalization.
            
            timeAPDRange = [];
            voltageAPDRange = [];
            
            % Inproper voltage normalization - do not proceed.
            if(max(voltageScale) ~= 1)
                error('MATLAB:timeAndVoltageAPDRange:incorrectNormalizedVoltageScale', ...
                    segmentation.model.errorData.msgPeakDataVoltageScaleIncorrectMax);
            end
            
            if(~isempty(apdPct) && ~isempty(timeScale) && ~isempty(voltageScale))
                conditional = timeScale >= 0 & voltageScale >= (apdPct - obj.apdOffset) & voltageScale <= (apdPct + obj.apdOffset);
                voltageAPDRange = voltageScale(conditional);
                timeAPDRange = timeScale(conditional);
            end
        end
        
        function rslt = calcPeakAttr(obj, apdPct, tAPDRange, vAPDRange)
            % CALCPEAKATTR Peak attribute through interpolation - for time and
            % voltage vectors (range of possbile values) use linear interpolation
            % to determine what the time measurment would be for a particular apdPct.
            %
            % INPUT:
            %     apdPct:       The percentage of the waveform that is 'remaining'
            %                   after the peak.
            %     tAPDRange:    The range of possible time measurments.
            %     vAPDRange:    The range of possible voltage measurements.
            %
            % OUTPUT:   The time measurment at a particular apd percentage.
            %           This value is determined using linear
            %           interpolation.
            %
            % EXCEPTION:
            %     [1] If the size of tAPDRange and vAPDRange do not match.
            %         Linear interpolation can not occur if the predictor
            %         vectors are not equal in size (for every x there needs to
            %         be a y).
            %     [2] The apdPct is greater than the vAPDRange.  The
            %         percentage is not represented in the vAPDRange.
            %     [3] If linear interpolation results in NaN.
            
            % If the voltage range is greater than expected - error.
            if (vAPDRange(1,1) < apdPct - obj.apdOffset)
                error('MATLAB:calcPeakAttr:scaledVoltageOutOfRange', ...
                    segmentation.model.errorData.msgPeakDataVoltageScaleOutOfRange);
                
                % If the lengths do no equal - error.
            elseif (length(vAPDRange) ~= length(tAPDRange))
                error('MATLAB:calcPeakAttr:mismatchTimeAndVoltageRangeVectors', ...
                    segmentation.model.errorData.msgPeakDataVoltageScaleAndTimeSizeMismatch);
            else
                try
                    % Linear interpolation
                    rslt = max(tAPDRange) - (((apdPct - vAPDRange(length(vAPDRange)))*(max(tAPDRange) - min(tAPDRange))) / (vAPDRange(1,1) - vAPDRange(length(vAPDRange))));
                    if(isnan(rslt))
                        error('MATLAB:calcPeakAttr:linearInterpolationNaN', ...
                            segmentation.model.errorData.msgPeakDataLinearInterpolationNaN);
                    end
                catch me
                    causeException = MException('MATLAB:calcPeakAttr:linearInterpolationFailed', ...
                        segmentation.model.errorData.msgPeakDataLinearInterpolationGeneral);
                    me = addCause(me, causeException);
                    rethrow(me)
                end
            end
        end
        
        function rslt = calcDifference(~, a1, a2)
            % CALCDIFFERENCE Repolarization difference - calculate the difference
            % in time between timestamps when the action potential has repolarized to
            % different percentages.  If a1 is not larger than a2, the result will be empty.
            %
            % INPUTS:
            %     a1:  Timeframe when the action potential has repolarized by a certain percentage.
            %     a2:  Timeframe when the action potential has repolarized by a certain percentage.
            %
            % OUTPUTS:  The difference between a1 and a2 repolarization. If the value of a1 is not
            %           larger than a2, then the result will be empty.  If either input parameter
            %           is also empty, the result will be empty.
            
            rslt = [];
            if(~isempty(a1) && ~isempty(a2) && (a1 > a2))
                rslt = (a1 - a2);
            end
        end
        
        function rslt = calcRatio(~, a90, a50)
            % CALCRATIO Repolarization ratior [90 - 50] - calculate the ratio between the
            % timestamps when the action potential has repolarized 50% and 90%.
            %
            % INPUTS:
            %     a90:  Timeframe when the action potential has repolarized by 90%.
            %     a50:  Timeframe when the action potential has repolarized by 50%.
            %
            % OUTPUTS:  The ratio between 50% and 90% repolarization. If either the a90
            %           or a50 value is empty, the result will be empty.
            
            rslt = [];
            if(~isempty(a50) && ~isempty(a90))
                rslt = a50 / a90;
            end
        end
        
        function rslt = calcFrac(obj, a80, a30)
            % CALCFRAC Fractional repolarization - determine the fractional repolarization
            % phase - the ratio between the trianglulation (difference between 80% and 30%
            % repolarizations) and 80% repolarization.
            %
            % INPUTS:
            %     a80:  Timeframe when the action potential has repolarized by 80%.
            %     a30:  Timeframe when the action potential has repolarized by 30%.
            %
            % OUTPUTS:
            %     The fractional repolarization calculation.  If either the a80 or a30
            %     value is empty, the result will be empty.
            
            rslt = [];
            if(~isempty(a80) && ~isempty(a30))
                rslt = obj.calcDifference(a80, a30) / a80;
            end
        end
    end
end