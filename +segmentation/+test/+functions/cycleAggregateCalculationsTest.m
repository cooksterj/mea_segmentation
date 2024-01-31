classdef cycleAggregateCalculationsTest < matlab.unittest.TestCase
    % CYCLEAGGREGATECALCULATIONSTEST - Test class for the cycleAggregateCalculations_f
    % functions
    %
    % Author:  Jonathan Cook
    % Created: 2018-08-23
    
    properties
        % Retrieve all of the testable functions.
        cycleAggregateCalculationsHandles;
    end
    
    % Initialization.
    methods (TestClassSetup)
        function ClassSetup(testCase)
            % CLASSSETUP - Set the test case properties.
            
            testCase.cycleAggregateCalculationsHandles = segmentation.functions.cycleAggregateCalculations_f;
        end
    end
    
    methods(Test)
        function allCycleIntervals_singleInterval_valid(testCase)
            % ALLCYCLEINTERVALS_SINGLEINTERVAL_VALID Single start/stop
            % interval - validate a single start and stop value will be
            % identified.
            
            timeMeasurements = (1:1:10);
            cycleStartStop = 5;
            
            expectedStartTime = [1, 5];
            expectedEndTime = [5, 10];
            
            [actualStartTime, actualEndTime] = testCase.cycleAggregateCalculationsHandles.allCycleIntervals(timeMeasurements, cycleStartStop);
            
            % Single start and stop time interval.
            verifyEqual(testCase, actualStartTime, expectedStartTime)
            verifyEqual(testCase, actualEndTime, expectedEndTime)
        end
        
        function allCycleIntervals_multipleTimePoints_valid(testCase)
            % ALLCYCLEINTERVALS_MULTIPLETIMEPOINTS Multiple start/stop
            % intervals - validate multiple start and stop intervals will
            % be identified.
            
            timeMeasurements = (1:1:25);
            cycleStartStop = [5, 10];
            
            expectedStartTime = [1, 5, 10];
            expectedEndTime = [5, 10, 25];
            
            [actualStartTime, actualEndTime] = testCase.cycleAggregateCalculationsHandles.allCycleIntervals(timeMeasurements, cycleStartStop);
            
            % Multiple start and stop time intervals.
            verifyEqual(testCase, actualStartTime, expectedStartTime);
            verifyEqual(testCase, actualEndTime, expectedEndTime);
        end
        
        function allCycleTimeAndVolts_valid(testCase)
            % ALLCYCLETIMEANDVOLTS_VALID Segmented time, voltage, and voltage smoothed -
            % validate three vectors are returned and are not empty.
            % [1] time segmentation, [2] voltage segmentation, [3] voltage segmentation
            % that has been smoothed.
            
            timeMeasurements = (1:1:100);
            voltageMeasurements = (1:1:100);
            segmentationStart = 5;
            segmentationStop = 75;
            
            [segmentedTime, segmentedVoltage, segmentedVoltageSmoothed] =...
                testCase.cycleAggregateCalculationsHandles.allCycleTimeAndVolts(timeMeasurements,...
                voltageMeasurements, segmentationStart, segmentationStop);
            
            % None of the results should be empty.
            verifyNotEmpty(testCase, segmentedTime);
            verifyNotEmpty(testCase, segmentedVoltage);
            verifyNotEmpty(testCase, segmentedVoltageSmoothed);
        end
        
        function allCycleAvgFrequency_valid(testCase)
            % ALLCYCLEAVGFREQUENCY_VALID Average frequency - verify three apdData
            % objects will have their average frequency calcualted.
            
            % Single outDataResult with left and right cursors set.
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, 1, [], [], 1, []);
            initializedOutData(1).apLeftCursorLoc = 0;
            initializedOutData(1).apRightCursorLoc = 1.5;
            
            % Three apdData objects.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, [], [], [], []);
            initializedAPDData(2) = segmentation.model.apdData(2, [], [], [], []);
            initializedAPDData(3) = segmentation.model.apdData(3, [], [], [], []);
            initializedOutData(1).apdData = initializedAPDData;
            
            actualAPDData = testCase.cycleAggregateCalculationsHandles.allCycleAvgFrequency(initializedAPDData,...
                initializedOutData(1).apLeftCursorLoc, initializedOutData(1).apRightCursorLoc);
            
            % Verify all three apdData objects have the same average frequency.
            verifyEqual(testCase, actualAPDData(1).avgFrequency, 2);
            verifyEqual(testCase, actualAPDData(2).avgFrequency, 2);
            verifyEqual(testCase, actualAPDData(3).avgFrequency, 2);
        end
        
        function allCycleAvgFrequency_rightCursorEmpty(testCase)
            % ALLCYCLEAVGFREQUENCY_RIGHTCURSOREMPTY Empty average frequency - verify three apdData
            % objects will have empty average frequencies due to an empty right cursor value.
            
            % Single outDataResult with left and right cursors set.
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, 1, [], [], 1, []);
            initializedOutData(1).apLeftCursorLoc = 0;
            
            % Three apdData objects.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, [], [], [], []);
            initializedAPDData(2) = segmentation.model.apdData(2, [], [], [], []);
            initializedAPDData(3) = segmentation.model.apdData(3, [], [], [], []);
            initializedOutData(1).apdData = initializedAPDData;
            
            actualAPDData = testCase.cycleAggregateCalculationsHandles.allCycleAvgFrequency(initializedAPDData,...
                initializedOutData(1).apLeftCursorLoc, initializedOutData(1).apRightCursorLoc);
            
            % Verify all three apdData objects have empty average frequencies.
            verifyEmpty(testCase, actualAPDData(1).avgFrequency);
            verifyEmpty(testCase, actualAPDData(2).avgFrequency);
            verifyEmpty(testCase, actualAPDData(3).avgFrequency);
        end
        
        function allCycleAvgFrequency_leftCursorEmpty(testCase)
            % ALLCYCLEAVGFREQUENCY_LEFTCURSOREMPTY Empty average frequency - verify three apdData
            % objects will have empty average frequencies due to an empty left cursor value.
            
            % Single outDataResult with left and right cursors set.
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, 1, [], [], 1, []);
            initializedOutData(1).apRightCursorLoc = 1.5;
            
            % Three apdData objects.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, [], [], [], []);
            initializedAPDData(2) = segmentation.model.apdData(2, [], [], [], []);
            initializedAPDData(3) = segmentation.model.apdData(3, [], [], [], []);
            initializedOutData(1).apdData = initializedAPDData;
            
            actualAPDData = testCase.cycleAggregateCalculationsHandles.allCycleAvgFrequency(initializedAPDData,...
                initializedOutData(1).apLeftCursorLoc, initializedOutData(1).apRightCursorLoc);
            
            % Verify all three apdData objects have empty average frequencies.
            verifyEmpty(testCase, actualAPDData(1).avgFrequency);
            verifyEmpty(testCase, actualAPDData(2).avgFrequency);
            verifyEmpty(testCase, actualAPDData(3).avgFrequency);
        end
        
        function allCycleAvgFrequency_leftGreaterThanRightCursor(testCase)
            % ALLCYCLEAVGFREQUENCY_LEFTGREATERTHANRIGHTCURSOR Empty average frequency - verify three apdData
            % objects will have empty average frequencies due the left cursor value being
            % greater than the right cursor value.
            
            % Single outDataResult with left and right cursors set.
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, 1, [], [], 1, []);
            initializedOutData(1).apLeftCursorLoc = 2.5;
            initializedOutData(1).apRightCursorLoc = 1.5;
            
            % Three apdData objects.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, [], [], [], []);
            initializedAPDData(2) = segmentation.model.apdData(2, [], [], [], []);
            initializedAPDData(3) = segmentation.model.apdData(3, [], [], [], []);
            initializedOutData(1).apdData = initializedAPDData;
            
            actualAPDData = testCase.cycleAggregateCalculationsHandles.allCycleAvgFrequency(initializedAPDData,...
                initializedOutData(1).apLeftCursorLoc, initializedOutData(1).apRightCursorLoc);
            
            % Verify all three apdData objects have empty average frequencies.
            verifyEmpty(testCase, actualAPDData(1).avgFrequency);
            verifyEmpty(testCase, actualAPDData(2).avgFrequency);
            verifyEmpty(testCase, actualAPDData(3).avgFrequency);
        end
        
        function allCycleLength_emptyObj(testCase)
            % ALLCYCLELENGTH_EMPTYOBJ Cycle lengh for empty obj - ensure the cycle length is not
            % calculated due to an empty object.  No errors are thrown.
            
            % Single outDataResult
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, 1, [], [], 1, []);
            initializedOutData(1).apLeftCursorLoc = 0;
            initializedOutData(1).apRightCursorLoc = 1.5;
            
            % Initialize the three waveforms as apdData objects.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedOutData(1).apdData = initializedAPDData;
            
            actualAPDData = testCase.cycleAggregateCalculationsHandles.allCycleLength(initializedAPDData);
            
            % There is no change with between the actual/expected outData objects.
            verifyEqual(testCase, actualAPDData, initializedAPDData);
        end
        
        function allCycleLength_singleObj(testCase)
            % ALLCYCLELENGTH_SINGLEOBJ Cycle lengh for a single obj - ensure the cycle length is not
            % calculated due since there is only a single object.
            
            % First waveform
            first = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [firstX, firstY] = first.sinusoid;
            
            % Single outDataResult
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, 1, [], [], 1, []);
            initializedOutData(1).apLeftCursorLoc = 0;
            initializedOutData(1).apRightCursorLoc = 1.5;
            
            % Initialize a single apdData object.
            initializedAPDData(1) = segmentation.model.apdData(1, firstX, firstY, min(firstX), max(firstX));
            
            actualAPDData = testCase.cycleAggregateCalculationsHandles.allCycleLength(initializedAPDData);
            
            % Empty cycle length.
            verifyEmpty(testCase, actualAPDData.cycleLength);
        end
        
        function allCycleLength_partialEmptyPeakTime(testCase)
            % ALLCYCLELENGTH_PARTIALEMPTYPEAKTIME Partial cycle length - verify the only one of the
            % three apdData objects will have their cycle length calculated.  The first apdData object
            % will have an empty peakTime.  The third apdData object should never have its cycle time
            % calculated (no next reference).
            
            % First waveform
            first = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [firstX, firstY] = first.sinusoid;
            
            % Second waveform - time shifted with respect to the first
            % waveform.
            second = segmentation.test.functions.waveformGenerator(1, 0.5,  1, 5);
            [secondX, secondY] = second.sinusoid;
            secondX = secondX + max(firstX);
            
            % Third waveform - time shifted with respect to the second
            % waveform.
            third = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [thirdX, thirdY] = third.sinusoid;
            thirdX = thirdX + max(secondX);
            
            % Single outDataResult
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, 1, [], [], 1, []);
            initializedOutData(1).apLeftCursorLoc = 0;
            initializedOutData(1).apRightCursorLoc = 1.5;
            
            % Initialize the three waveforms as apdData objects.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, firstX, firstY, min(firstX), max(firstX));
            initializedAPDData(1).peakTime = [];
            initializedAPDData(2) = segmentation.model.apdData(2, secondX, secondY, min(secondX), max(secondX));
            initializedAPDData(3) = segmentation.model.apdData(3, thirdX, thirdY, min(thirdX), max(thirdX));
            initializedOutData(1).apdData = initializedAPDData;
            
            actualAPDData = testCase.cycleAggregateCalculationsHandles.allCycleInstantFrequency(initializedAPDData);
            
            % Verify only the second apdData object has a cycleLength.  The first apdData object has
            % an empty peak time and the third cycle (last) will always be empty.
            verifyEmpty(testCase, actualAPDData(1).cycleLength);
            verifyEqual(testCase, actualAPDData(2).cycleLength, 0.5);
            verifyEmpty(testCase, actualAPDData(3).cycleLength);
        end
        
        function allCycleLength_valid(testCase)
            % ALLCYCLELENGTH_VALID Valid cycle length - verify the correct cycle length (time between
            % two peaks).  The last cycle (third) will have a empty cycle length.
            
            % First waveform
            first = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [firstX, firstY] = first.sinusoid;
            
            % Second waveform - time shifted with respect to the first
            % waveform.
            second = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [secondX, secondY] = second.sinusoid;
            secondX = secondX + max(firstX);
            
            % Third waveform - time shifted with respect to the second
            % waveform.
            third = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [thirdX, thirdY] = third.sinusoid;
            thirdX = thirdX + max(secondX);
            
            % Single outDataResult
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, 1, [], [], 1, []);
            initializedOutData(1).apLeftCursorLoc = 0;
            initializedOutData(1).apRightCursorLoc = 1.5;
            
            % Initialize the three waveforms as apdData objects.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, firstX, firstY, min(firstX), max(firstX));
            initializedAPDData(2) = segmentation.model.apdData(2, secondX, secondY, min(secondX), max(secondX));
            initializedAPDData(3) = segmentation.model.apdData(3, thirdX, thirdY, min(thirdX), max(thirdX));
            initializedOutData(1).apdData = initializedAPDData;
            
            actualAPDData = testCase.cycleAggregateCalculationsHandles.allCycleInstantFrequency(initializedAPDData);
            
            % Verify the first two cycles' cycle length equals 0.5 and
            % the third cycle (last) has no cycle length.
            verifyEqual(testCase, actualAPDData(1).cycleLength, 0.5);
            verifyEqual(testCase, actualAPDData(2).cycleLength, 0.5);
            verifyEmpty(testCase, actualAPDData(3).cycleLength);
        end
        
        function allCycleAvgFrequency_emptyObj(testCase)
            % ALLCYCLEAVGFREQUENCY_EMPTYAPDDATA Empty average frequency - verify three apdData
            % object will have empty average frequencies due to an empty object.
            
            % Single outDataResult.
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, 1, [], [], 1, []);
            initializedOutData(1).apLeftCursorLoc = 3.5;
            initializedOutData(1).apRightCursorLoc = 1.5;
            
            % Three empty apdData objects.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedOutData(1).apdData = initializedAPDData;
            
            actualAPDData = testCase.cycleAggregateCalculationsHandles.allCycleAvgFrequency(initializedAPDData,...
                initializedOutData(1).apLeftCursorLoc, initializedOutData(1).apRightCursorLoc);
            
            % There is no change with between the actual/expected apdData objects.
            verifyEqual(testCase, actualAPDData, initializedAPDData);
        end
        
        function allCycleInstantFrequency_valid(testCase)
            % ALLCYCLEINSTANTFREQUENCY_VALID Instantaneous frequency - verify three apdData
            % objects will have their instantaneous frequency calculated.
            
            % First waveform
            first = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [firstX, firstY] = first.sinusoid;
            
            % Second waveform - time shifted with respect to the first
            % waveform.
            second = segmentation.test.functions.waveformGenerator(1, 0.5,  1, 5);
            [secondX, secondY] = second.sinusoid;
            secondX = secondX + max(firstX);
            
            % Third waveform - time shifted with respect to the second
            % waveform.
            third = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [thirdX, thirdY] = third.sinusoid;
            thirdX = thirdX + max(secondX);
            
            % Single outDataResult
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, 1, [], [], 1, []);
            initializedOutData(1).apLeftCursorLoc = 0;
            initializedOutData(1).apRightCursorLoc = 1.5;
            
            % Initialize the three waveforms as apdData objects.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, firstX, firstY, min(firstX), max(firstX));
            initializedAPDData(2) = segmentation.model.apdData(2, secondX, secondY, min(secondX), max(secondX));
            initializedAPDData(3) = segmentation.model.apdData(3, thirdX, thirdY, min(thirdX), max(thirdX));
            initializedOutData(1).apdData = initializedAPDData;
            
            actualAPDData = testCase.cycleAggregateCalculationsHandles.allCycleInstantFrequency(initializedAPDData);
            
            % Verify the first two cycles' instantaneous frequency equals 2 and
            % the third cycle (last) has no instantaneous frequency.
            verifyEqual(testCase, actualAPDData(1).instantFrequency, 2);
            verifyEqual(testCase, actualAPDData(2).instantFrequency, 2);
            verifyEmpty(testCase, actualAPDData(3).instantFrequency);
        end
        
        function allCycleInstantFrequency_singleObj(testCase)
            % ALLCYCLEINSTANTFREQUENCY_SINGLEOBJ Empty instantaneous frequency - verify an
            % empty instantaneous frequency due to only a single apdData object.
            
            % First waveform
            first = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [firstX, firstY] = first.sinusoid;
            
            % Single outDataResult
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, 1, [], [], 1, []);
            initializedOutData(1).apLeftCursorLoc = 0;
            initializedOutData(1).apRightCursorLoc = 1.5;
            
            % Initialize a single apdData object.
            initializedAPDData(1) = segmentation.model.apdData(1, firstX, firstY, min(firstX), max(firstX));
            
            actualAPDData = testCase.cycleAggregateCalculationsHandles.allCycleInstantFrequency(initializedAPDData);
            
            % Verify the instantaneous frequency will be empty - no 'future' reference.
            verifyEmpty(testCase, actualAPDData.instantFrequency);
        end
        
        function allCycleInstantFrequency_emptyObj(testCase)
            % ALLCYCLEINSTANTFREQUENCY_EMPTYOBJ Empty instantaneous frequency - verify three
            % apdData objects have empty instantaneous frequencies due to empty adpData
            % objects.
            
            % Single outDataResult
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, 1, [], [], 1, []);
            initializedOutData(1).apLeftCursorLoc = 0;
            initializedOutData(1).apRightCursorLoc = 1.5;
            
            % Initialize the three waveforms as apdData objects.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedOutData(1).apdData = initializedAPDData;
            
            actualAPDData = testCase.cycleAggregateCalculationsHandles.allCycleInstantFrequency(initializedAPDData);
            
            % There is no change with between the actual/expected outData objects.
            verifyEqual(testCase, actualAPDData, initializedAPDData);
        end
        
        function validateStartStopTimeIntervals_emptyTime_exception(testCase)
            % VALIDATESTARTSTOPTIMEINTERVALS_EMPTYPARAMETERS_EXCEPTION Empty parameters -
            % verify a exeception will be thrown due to an empty time vector.
            
            timeMeasurements = [];
            startTime = 10;
            stopTime = 5;
            
            % Empty time vector.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateStartStopTimeInterval(timeMeasurements, startTime, stopTime), 'MATLAB:validateStartStopTimeInterval:emptyStartStopOrTime');
        end
        
        function validateStartStopTimeIntervals_emptyStart_exception(testCase)
            % VALIDATESTARTSTOPTIMEINTERVALS_EMPTYSTART_EXCEPTION Empty parameters -
            % verify a exeception will be thrown due to an empty start interval.
            
            timeMeasurements = (1:1:25);
            startTime = [];
            stopTime = 5;
            
            % Empty start interval.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateStartStopTimeInterval(timeMeasurements, startTime, stopTime), 'MATLAB:validateStartStopTimeInterval:emptyStartStopOrTime');
        end
        
        function validateStartStopTimeIntervals_emptyStop_exception(testCase)
            % VALIDATESTARTSTOPTIMEINTERVALS_EMPTYSTOP_EXCEPTION Empty parameters -
            % verify a exeception will be thrown due to an empty stop interval.
            
            timeMeasurements = (1:1:25);
            startTime = 1;
            stopTime = [];
            
            % Empty stop interval.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateStartStopTimeInterval(timeMeasurements, startTime, stopTime), 'MATLAB:validateStartStopTimeInterval:emptyStartStopOrTime');
        end
        
        function validateStartStopTimeIntervals_multipleStart_exception(testCase)
            % VALIDATESTARTSTOPTIMEINTERVALS_MULTIPLESTART_EXCEPTION Multiple value parameters -
            % verify a exeception will be thrown due to the presence of more than one start
            % interval.
            
            timeMeasurements = (1:1:25);
            startTime = [1, 5];
            stopTime = 10;
            
            % Empty stop interval.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateStartStopTimeInterval(timeMeasurements, startTime, stopTime), 'MATLAB:validateStartStopTimeInterval:multipleStartOrStopIntervals');
        end
        
        function validateStartStopTimeIntervals_multipleStop_exception(testCase)
            % VALIDATESTARTSTOPTIMEINTERVALS_MULTIPLESTOP_EXCEPTION Multiple value parameters -
            % verify a exeception will be thrown due to the presence of more than one stop
            % interval.
            
            timeMeasurements = (1:1:25);
            startTime = 1;
            stopTime = [10, 25];
            
            % Empty stop interval.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateStartStopTimeInterval(timeMeasurements, startTime, stopTime), 'MATLAB:validateStartStopTimeInterval:multipleStartOrStopIntervals');
        end
        
        function validateStartStopTimeIntervals_startNotAMember_exception(testCase)
            % VALIDATESTARTSTOPTIMEINTERVALS_STARTNOTAMEMBER_EXCEPTION Invalid parameters -
            % verify a exeception will be thrown due to a start interval that is not in the
            % time vector.
            
            timeMeasurements = (1:1:25);
            startTime = 1.5;
            stopTime = 10;
            
            % Empty stop interval.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateStartStopTimeInterval(timeMeasurements, startTime, stopTime), 'MATLAB:validateStartStopTimeInterval:notValid');
        end
        
        function validateStartStopTimeIntervals_stopNotAMember_exception(testCase)
            % VALIDATESTARTSTOPTIMEINTERVALS_STOPNOTAMEMBER_EXCEPTION Invalid parameters -
            % verify a exeception will be thrown due to a start interval that is not in the
            % time vector.
            
            timeMeasurements = (1:1:25);
            startTime = 1;
            stopTime = 10.5;
            
            % Empty stop interval.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateStartStopTimeInterval(timeMeasurements, startTime, stopTime), 'MATLAB:validateStartStopTimeInterval:notValid');
        end
        
        function validateStartStopTimeIntervals_startGreaterThanStop_exception(testCase)
            % VALIDATESTARTSTOPTIMEINTERVALS_STARTGREATERTHANSTOP_EXCEPTION Invalid parameters -
            % verify a exeception will be thrown due to a start interval greater than the stop
            % interval.
            
            timeMeasurements = (1:1:25);
            startTime = 20;
            stopTime = 10;
            
            % Start interval greater than the stop interval.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateStartStopTimeInterval(timeMeasurements, startTime, stopTime), 'MATLAB:validateStartStopTimeInterval:incorrectStartStop');
        end
        
        function validateTimeIntervals_emptyTime_exception(testCase)
            % VALIDATETIMEINTERVALS_EMPTYTIME_EXCEPTION Empty time parameter - verify an
            % exception will be thrown due to an empty time vector.
            
            timeMeasurements = [];
            troughTimePoints = [1, 5, 10];
            
            % Empty time vector.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateTimeIntervals(timeMeasurements, troughTimePoints), 'MATLAB:validateTimeIntervals:empty');
        end
        
        function validateTimeIntervals_emptyTrough_exception(testCase)
            % VALIDATETIMEINTERVALS_EMPTYTROUGH_EXCEPTION Empty trough parameter - verify an
            % exception will be thrown due to an trough parameter.
            
            timeMeasurements = (1:1:25);
            troughTimePoints = [];
            
            % Empty time vector.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateTimeIntervals(timeMeasurements, troughTimePoints), 'MATLAB:validateTimeIntervals:empty');
        end
        
        function validateTimeIntervals_troughGreaterThanTime_exception(testCase)
            % VALIDATETIMEINTERVALS_TROUGHGREATERTHANTIME_EXCEPTION Trough greater
            % than - verify an exception will be thrown due to the trough being greater
            % than the maximum time vector value.
            
            timeMeasurements = (1:1:5);
            cycleTimes = 10;
            
            % Cycle time is greater than max time vector.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateTimeIntervals(timeMeasurements, cycleTimes), 'MATLAB:validateTimeIntervals:outOfRange');
        end
        
        function validateTimeIntervals_troughLessThanTime_exception(testCase)
            % VALIDATETIMEINTERVALS_TROUGHLESSTHANTIME_EXCEPTION Trough less
            % than - verify an exception will be thrown due to the trough being less
            % than the minimum time vector value.
            
            timeMeasurements = (1:1:5);
            cycleTimes = 0.5;
            
            % Cycle time is greater than max time vector.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateTimeIntervals(timeMeasurements, cycleTimes), 'MATLAB:validateTimeIntervals:outOfRange');
        end
        
        function validateTimeIntervals_troughNotAMember_exception(testCase)
            % VALIDATETIMEINTERVALS_TROUGHNOTAMEMBER_EXCEPTION Invalid trough -
            % verify an exception will be thrown due to the trough not being in the
            % time vector.
            
            timeMeasurements = (1:1:5);
            cycleTimes = 1.5;
            
            % Cycle time is greater than max time vector.
            testCase.verifyError(@()testCase.cycleAggregateCalculationsHandles.validateTimeIntervals(timeMeasurements, cycleTimes), 'MATLAB:validateTimeIntervals:notValid');
        end
    end
end