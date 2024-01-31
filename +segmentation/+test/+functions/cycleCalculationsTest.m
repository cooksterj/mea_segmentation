classdef cycleCalculationsTest < matlab.unittest.TestCase
    % CYCLECALCULATIONSTEST - Test class for the cycleCalculations_f functions.
    %
    % Author:  Jonathan Cook
    % Created: 2018-08-22
    
    properties
        % Retrieve all of the testable functions.
        cycleCalculationHandles;
    end
    
    % Initialization.
    methods (TestClassSetup)
        function ClassSetup(testCase)
            % CLASSSETUP - Set the test case properties.
            
            testCase.cycleCalculationHandles = segmentation.functions.cycleCalculations_f;
        end
    end
    
    methods(Test)
        function calcPeakTime_valid(testCase)
            % CALCPEAKTIME_VALID Peak Time - validate the peak time is
            % correctly determined.
            
            % One cycle per second, one-half cycle, no multiplier, no
            % shift
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 0);
            [waveformTime, waveformVoltage] = waveform.sinusoid;
            
            actualPeakTime = testCase.cycleCalculationHandles.cyclePeakTime(waveformTime, waveformVoltage);
            
            % Peak should be at a time interval of 0.25 (1/2 of 0.5)
            verifyEqual(testCase, actualPeakTime, 0.25);
        end
        
        function calcPeakTime_emptyVoltage(testCase)
            % CALCPEAKTIME_EMPTYVOLTAGE Peak time with empty voltage - validate
            % an empty return value.
            
            % One cycle per second, one-half cycle, no multiplier, no
            % shift
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 0);
            [waveformTime, ~] = waveform.sinusoid;
            
            actualPeakTime = testCase.cycleCalculationHandles.cyclePeakTime(waveformTime, []);
            
            % Empty due to an empty voltage input parameter.
            verifyEmpty(testCase, actualPeakTime);
        end
        
        function calcPeakTime_emptyTime(testCase)
            % CALCPEAKTIME_EMPTYTIME Peak time with empty time - validate
            % an empty return value.
            
            % One cycle per second, one-half cycle, no multiplier, no
            % shift
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 0);
            [~, waveformVoltage] = waveform.sinusoid;
            
            actualPeakTime = testCase.cycleCalculationHandles.cyclePeakTime([], waveformVoltage);
            
            % Empty due to an empty time input parameter.
            verifyEmpty(testCase, actualPeakTime);
        end
        
        function calcPeakTime_emptyTimeAndVoltage(testCase)
            % CALCPEAKTIME_EMPTYTIMEANDVOLTAGE Peak time with empty voltage and
            % time vectors - validate an empty return value.
            
            actualPeakTime = testCase.cycleCalculationHandles.cyclePeakTime([], []);
            
            % Empty due to an empty voltage and time input parameter.
            verifyEmpty(testCase, actualPeakTime);
        end
        
        function calcMinVoltage_valid(testCase)
            % CALCMINVOLTAGE Minimum voltage post peak time - validate a minimum
            % voltage is correctly determined.
            
            % One cycle per second, one-half cycle, no multiplier, shift
            % the waveform by 1.8 - minimum voltage after peak equals a value
            % of 1.8.
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 1.8);
            [waveformTime, waveformVoltage] = waveform.sinusoid;
            
            actualMinPeakVoltage = round(testCase.cycleCalculationHandles.cycleMinVoltage(waveformTime, waveformVoltage, 0.25), 2);
            
            % Value equals vertical shift.
            verifyEqual(testCase, actualMinPeakVoltage, 1.80)
        end
        
        function calcMinVoltage_emptyVoltage(testCase)
            % CALCMINVOLTAGE_EMPTYVOLTAGE  Minimum voltage post peak time with empty
            % voltage - validate an empty return value;
            
            % One cycle per second, one-half cycle, no multiplier, shift
            % the waveform by 1.8 - minimum voltage after peak equals a value
            % of 1.8.
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 1.8);
            [waveformTime, ~] = waveform.sinusoid;
            
            actualMinPeakVoltage = round(testCase.cycleCalculationHandles.cycleMinVoltage(waveformTime, [], 0.25), 2);
            
            % Empty due to an empty voltage input parameter.
            verifyEmpty(testCase, actualMinPeakVoltage)
        end
        
        function calcMinVoltage_emptyTime(testCase)
            % CALCMINVOLTAGE_EMPTYTIME Minimum voltage post peak time with an empty
            % time vector - validate an empty return value.
            
            % One cycle per second, one-half cycle, no multiplier, shift
            % the waveform by 1.8 - minimum voltage after peak equals a value
            % of 1.8.
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 1.8);
            [~, waveformVoltage] = waveform.sinusoid;
            
            actualMinPeakVoltage = round(testCase.cycleCalculationHandles.cycleMinVoltage([], waveformVoltage, 0.25), 2);
            
            % Empty due to an empty time input parmeter.
            verifyEmpty(testCase, actualMinPeakVoltage)
        end
        
        function calcMinVoltage_emptyPeakTime(testCase)
            % CALCMINVOLTAGE_EMPTYPEAKTIME Minimum voltage post peak time with an
            % empty peak time value - validate an empty return value.
            
            % One cycle per second, one-half cycle, no multiplier, shift
            % the waveform by 1.8 - minimum voltage after peak equals a value
            % of 1.8.
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 1.8);
            [waveformTime, waveformVoltage] = waveform.sinusoid;
            
            actualMinPeakVoltage = round(testCase.cycleCalculationHandles.cycleMinVoltage(waveformTime, waveformVoltage, []), 2);
            
            % Empty due to an empty time input parmeter.
            verifyEmpty(testCase, actualMinPeakVoltage)
            
        end
        
        function calcMinVoltage_emptyTimeVoltageAndPeakTime(testCase)
            % CALCMINVOLTAGE_EMPTYTIMEANDVOLTAGE Minimum voltage post peak time with
            % an empty time and voltage vectors - validate an empty return value.
            
            actualMinPeakVoltage = round(testCase.cycleCalculationHandles.cycleMinVoltage([], [], 0.25), 2);
            
            % Empty due to an empty time input parmeter.
            verifyEmpty(testCase, actualMinPeakVoltage)
        end
        
        function calcABSAmplitude_maxGreaterThanZero_minGreaterThanZero_valid(testCase)
            % CALCABSAMPLITUDE_MAXGREATERTHANZERO_MINGREATERTHANZERO_VALID
            % Amplitude - min and max values are greater than zero, and max greater
            % than min.
            
            max = 10;
            min = 1;
            
            actualABSAmplitude = round(testCase.cycleCalculationHandles.cycleABSAmplitude(max, min), 2);
            
            % Amplitude = 10 - 1;
            verifyEqual(testCase, actualABSAmplitude, 9);
        end
        
        function calcABSAmplitude_maxGreaterThanZero_minLessThanZero_valid(testCase)
            % CALCABSAMPLITUDE_MAXGREATERTHANZERO_MINLESSTHANZERO_VALID
            % Amplitude - max is greater than zero, min less than zero, and max greater
            % than min.
            
            max = 10;
            min = -10;
            
            actualABSAmplitude = round(testCase.cycleCalculationHandles.cycleABSAmplitude(max, min), 2);
            
            % Amplitude = 10 - (-10);
            verifyEqual(testCase, actualABSAmplitude, 20);
        end
        
        function calcABSAmplitude_maxLessThanZero_minLessThanZero_valid(testCase)
            % CALCABSAMPLITUDE_MAXGREATERTHANZERO_MINLESSTHANZERO_VALID
            % Amplitude - max and min less than zero, and max greater
            % than min.
            
            max = -10;
            min = -100;
            
            actualABSAmplitude = round(testCase.cycleCalculationHandles.cycleABSAmplitude(max, min), 2);
            
            % Amplitude = -10 - (-100);
            verifyEqual(testCase, actualABSAmplitude, 90);
        end
        
        function calcABSAmplitude_minGreaterThanMax(testCase)
            % CALCABSAMPLITUDE_MAXGREATERTHANZERO_MINLESSTHANZERO_VALID
            % Empty amplitude - max is less than min.
            
            max = 100;
            min = 1000;
            
            actualABSAmplitude = round(testCase.cycleCalculationHandles.cycleABSAmplitude(max, min), 2);
            
            % Empty due to min > max
            verifyEmpty(testCase, actualABSAmplitude);
        end
        
        function calcABSAmplitude_emptyMax(testCase)
            % CALCABSAMPLITUDE_EMPTYMAX Empty amplitude - max value is empty.
            
            min = 1000;
            
            actualABSAmplitude = round(testCase.cycleCalculationHandles.cycleABSAmplitude([], min), 2);
            
            % Empty due to empty max value
            verifyEmpty(testCase, actualABSAmplitude);
        end
        
        function calcABSAmplitude_emptyMin(testCase)
            % CALCABSAMPLITUDE_EMPTYMIN Empty amplitude - min value is empty.
            
            max = 1000;
            
            actualABSAmplitude = round(testCase.cycleCalculationHandles.cycleABSAmplitude(max, []), 2);
            
            % Empty due to empty min value
            verifyEmpty(testCase, actualABSAmplitude);
        end
        
        function calcABSAmplitude_emptyMaxAndMin(testCase)
            % CALCABSAMPLITUDE_EMPTYMAXANDMIN Empty amplitude - min and max
            % values are empty.
            
            actualABSAmplitude = round(testCase.cycleCalculationHandles.cycleABSAmplitude([], []), 2);
            
            % Empty due to empty min and max value
            verifyEmpty(testCase, actualABSAmplitude);
        end
        
        function cycleTime_valid(testCase)
            % CYCLETIME_VALID Time vector subset - time vector between
            % start and stop values.
            
            timeMeasurements = (1:1:25);
            startTime = 5;
            stopTime = 15;
            
            expectedTime = (5:1:15);
            
            actualTime = testCase.cycleCalculationHandles.cycleTime(timeMeasurements, startTime, stopTime);
            
            % Time subsets match.
            verifyEqual(testCase, actualTime, expectedTime);
        end
        
        function cycleTime_emptyTime_exception(testCase)
            % CYCLETIME_EMPTYTIME_EXCEPTION Time vector exception - verify
            % an exception will be thrown due to an empty time vector.
            
            startTime = 5;
            stopTime = 15;
            
            % Verify an exception is thrown.
            testCase.verifyError(@()testCase.cycleCalculationHandles.cycleTime([], startTime, stopTime), 'MATLAB:validateStartStopTimeInterval:emptyStartStopOrTime');
        end
        
        function cycleTime_startTimeAfterStopTime_exception(testCase)
            % CYCLETIME_STARTTIMEAFTERSTOPTIME Time vector exception - verify
            % an exception will be thrown due to a greater start time value
            % than the stop time (start > stop)
            
            timeMeasurements = (1:1:25);
            startTime = 25;
            stopTime = 15;
            
            % Verify an exception is thrown.
            testCase.verifyError(@()testCase.cycleCalculationHandles.cycleTime(timeMeasurements, startTime, stopTime), 'MATLAB:validateStartStopTimeInterval:incorrectStartStop');
        end
        
        function cycleTime_stopTimeBeforeStartTime_exception(testCase)
            % CYCLETIME_STARTTIMEAFTERSTOPTIME Time vector exception - verify
            % an exception will be thrown due to the stop time being smaller
            % than the start time (stop < start)
            
            timeMeasurements = (1:1:25);
            startTime = 5;
            stopTime = 1;
            
            % Verify an exception is thrown.
            testCase.verifyError(@()testCase.cycleCalculationHandles.cycleTime(timeMeasurements, startTime, stopTime), 'MATLAB:validateStartStopTimeInterval:incorrectStartStop');
        end
        
        function cycleVoltage_valid(testCase)
            % CYCLEVOLTAGE_VALID Voltage vector subset - voltage vector between
            % start and stop values.
            
            timeMeasurements = (1:1:25);
            voltageMeasurements = (1.1:1:25);
            startTime = 5;
            stopTime = 10;
            
            expectedVoltage = (5.1:1:10.1);
            
            actualVoltage = testCase.cycleCalculationHandles.cycleVoltage(timeMeasurements, voltageMeasurements, startTime, stopTime);
            verifyEqual(testCase, actualVoltage, expectedVoltage);
        end
        
        function cycleVoltage_emptyVoltage_exception(testCase)
            % CYCLEVOLTAGE_EMPTYVOLTAGE_EXCEPTION Voltage vector exception - verify
            % an exception will be thrown due to an empty voltage vector.
            
            timeMeasurements = (1:1:25);
            startTime = 5;
            stopTime = 15;
            
            % Verify an exception is thrown.
            testCase.verifyError(@()testCase.cycleCalculationHandles.cycleVoltage(timeMeasurements, [], startTime, stopTime), 'MATLAB:waveformVoltage:voltageEmpty');
        end
    end
end