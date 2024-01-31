classdef processActionPotentialSegmentationTest < matlab.unittest.TestCase
    % PROCESSACTIONPOTENTIALSEGMENTATIONTEST - Test class for the
    % processActionPotentialSegmentation_f functions.
    %
    % Author:  Jonathan Cook
    % Created: 2018-08-27
    
    properties
        processActionPotentialSegmentationHandles;
    end
    
    % Initialization.
    methods (TestClassSetup)
        function ClassSetup(testCase)
            % CLASSSETUP - Set the test case properties.
            
            testCase.processActionPotentialSegmentationHandles = segmentation.functions.processActionPotentialSegmentation_f;
        end
    end
    
    methods(Test)
        function findFirstAPDData_valid(testCase)
            % FINDFIRSTAPDDATA_VALID Identify first peak - verify the first peak
            % is properly identified when multiple peaks are available.
            
            % Three peaks - apdData object - with junk initialization other
            % than the peak number.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, [], [], [], []);
            initializedAPDData(2) = segmentation.model.apdData(2, [], [], [], []);
            initializedAPDData(3) = segmentation.model.apdData(3, [], [], [], []);
            
            % Verify the first peak has been identified.
            actualFirstAPDData = testCase.processActionPotentialSegmentationHandles.findFirstAPDData(initializedAPDData);
            verifyEqual(testCase, actualFirstAPDData, initializedAPDData(1))
        end
        
        
        function findFirstAPDData_noPeakNumOne_exception(testCase)
            % FINDFIRSTAPDDATA_NOPEAKNUMONE_EXCEPTION Missing first peak - Verify a
            % MATLAB:findFirstAPDData:missingPeakNumOne exception is thrown
            % when no 'first' peak is present.
            
            % Three peaks - apdData object - with junk initialization other
            % than the peak number.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(99, [], [], [], []);
            initializedAPDData(2) = segmentation.model.apdData(2, [], [], [], []);
            initializedAPDData(3) = segmentation.model.apdData(3, [], [], [], []);
            
            % Verify the correct exception is thrown.
            testCase.verifyError(@()testCase.processActionPotentialSegmentationHandles.findFirstAPDData(initializedAPDData), 'MATLAB:findFirstAPDData:missingPeakNumOne');
        end
        
        function findFirstAPDData_noInitialization_exception(testCase)
            % FINDFIRSTAPDDATA_NOINITIALIZATION_EXCEPTION No initialization -
            % verify a MATLAB:findFirstAPDData:apdDataNotInitialized exception
            % is thrown when the apdData object has not been initialized.
            
            % Verify the correct exception is thrown.
            testCase.verifyError(@()testCase.processActionPotentialSegmentationHandles.findFirstAPDData([]), 'MATLAB:findFirstAPDData:apdDataNotInitialized');
        end
        
        function calcAttenuation_noShift_inOrderAttenuation(testCase)
            % CALCATTENUATION_NOSHIFT_INORDERATTENUATION Attenuation - three
            % waveforms will be processed for attenuation.  No verticle
            % shift is present.  Each attenuation w.r.t the first peak, as
            % well as with the previous peak, is always decreasing.
            
            first = segmentation.test.functions.waveformGenerator(1, 0.5, 15, 0);
            [firstX, firstY] = first.sinusoid;
            
            second = segmentation.test.functions.waveformGenerator(1, 0.5, 10, 0);
            [secondX, secondY] = second.sinusoid;
            
            third = segmentation.test.functions.waveformGenerator(1, 0.5, 5, 0);
            [thirdX, thirdY] = third.sinusoid;
            
            % Three sinusoid waveforms - varying amplitudes.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, firstX, firstY, min(firstX), max(firstX));
            initializedAPDData(2) = segmentation.model.apdData(2, secondX, secondY, min(secondX), max(secondX));
            initializedAPDData(3) = segmentation.model.apdData(3, thirdX, thirdY, min(thirdX), max(thirdX));
            
            actualAttenuation = testCase.processActionPotentialSegmentationHandles.calcAttenuation(initializedAPDData);
            
            % Verify each attenuation.
            verifyEqual(testCase, actualAttenuation(1, 1).attenuation, []);
            verifyEqual(testCase, actualAttenuation(1, 2).attenuation, -5);
            verifyEqual(testCase, actualAttenuation(1, 3).attenuation, -10);
        end
        
        function calcAttenuation_withShift_inOrderAttenuation(testCase)
            % CALCATTENUATION_WITHSHIFT_INORDERATTENUATION Attenuation with axis cross -
            % Three waveforms will be processed for attenuation.  Verticle shift is
            % present allowing waveforms to cross the 0th x-axis.  Each attenuation
            % w.r.t the first peak, as well as with the previous peak, is
            % always decreasing.
            
            first = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [firstX, firstY] = first.sinusoid;
            
            second = segmentation.test.functions.waveformGenerator(1, 0.5,  1, -5);
            [secondX, secondY] = second.sinusoid;
            
            third = segmentation.test.functions.waveformGenerator(1, 0.5, 1, -10);
            [thirdX, thirdY] = third.sinusoid;
            
            % Three sinusoid waveforms - varying amplitudes.  The first
            % waveform is above the 0th x-axis, the 2nd and 3rd waveform is
            % below the 0th x-axis
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, firstX, firstY, min(firstX), max(firstX));
            initializedAPDData(2) = segmentation.model.apdData(2, secondX, secondY, min(secondX), max(secondX));
            initializedAPDData(3) = segmentation.model.apdData(3, thirdX, thirdY, min(thirdX), max(thirdX));
            
            actualAttenuation = testCase.processActionPotentialSegmentationHandles.calcAttenuation(initializedAPDData);
            
            % Verify each attenuation.
            verifyEqual(testCase, actualAttenuation(1, 1).attenuation, []);
            verifyEqual(testCase, actualAttenuation(1, 2).attenuation, -10);
            verifyEqual(testCase, actualAttenuation(1, 3).attenuation, -15);
        end
        
        function calcAttenuation_withShift_outOfOrderAttenuation(testCase)
            % CALCATTENUATION_WITHSHIFT_OUTOFORDERATTENUATION Attenuation out of
            % order - three waveforms will be processed for attenuation.  Verticle
            % shift is present allowing waveforms to cross the 0th x-axis.  Each
            % attenuation w.r.t the first peak is always decreasing, but not w.r.t to
            % the previous.
            
            first = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [firstX, firstY] = first.sinusoid;
            
            second = segmentation.test.functions.waveformGenerator(1, 0.5,  1, -5);
            [secondX, secondY] = second.sinusoid;
            
            third = segmentation.test.functions.waveformGenerator(1, 0.5, 1, -1);
            [thirdX, thirdY] = third.sinusoid;
            
            % Three sinusoid waveforms - varying amplitudes.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, firstX, firstY, min(firstX), max(firstX));
            initializedAPDData(2) = segmentation.model.apdData(2, secondX, secondY, min(secondX), max(secondX));
            initializedAPDData(3) = segmentation.model.apdData(3, thirdX, thirdY, min(thirdX), max(thirdX));
            
            actualAttenuation = testCase.processActionPotentialSegmentationHandles.calcAttenuation(initializedAPDData);
            
            % Verif each attenuation.
            verifyEqual(testCase, actualAttenuation(1, 1).attenuation, []);
            verifyEqual(testCase, actualAttenuation(1, 2).attenuation, -10);
            verifyEqual(testCase, actualAttenuation(1, 3).attenuation, -6);
        end
        
        function calcAttenuation_missingPeakOne_Exception(testCase)
            % CALCATTENUATION_MISSINGPEAKONE_EXCEPTION Attenuation exception -
            % verify a MATLAB:findFirstAPDData:missingPeakNumOne exception will be
            % thrown when trying to calculate a peak's attenuation when
            % the first peak is missing (point of reference).
            
            first = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [firstX, firstY] = first.sinusoid;
            
            second = segmentation.test.functions.waveformGenerator(1, 0.5,  1, -5);
            [secondX, secondY] = second.sinusoid;
            
            % Two sinusoid waveforms - varying amplitudes.
            initializedAPDData(1, 2) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(3, firstX, firstY, min(firstX), max(firstX));
            initializedAPDData(2) = segmentation.model.apdData(2, secondX, secondY, min(secondX), max(secondX));
            
            testCase.verifyError(@()testCase.processActionPotentialSegmentationHandles.calcAttenuation(initializedAPDData), 'MATLAB:findFirstAPDData:missingPeakNumOne');
        end
        
        function calcAttenuation_notInitializedAPDException(testCase)
            % CALCATTENUATION_NOTINITIALIZEDAPDEXCEPTION Attenuation exception -
            % Verify that a MATLAB:findFirstAPDData:apdDataNotInitialized exception is
            % thrown when trying to calculate a peak's attenuation but the
            % apdData object is not initialized.
            
            testCase.verifyError(@()testCase.processActionPotentialSegmentationHandles.calcAttenuation([]), 'MATLAB:findFirstAPDData:apdDataNotInitialized');
        end
        
        function calcDiastolicInterval_valid(testCase)
            % CALCDIASTOLICINTERVAL_VALID Diastolic interval - for a given set of three
            % action potentials, verify the diastolic interval.
            
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
            
            % Initialize the three waveforms as apdData objects.
            % Each a80 value cannot be 80% of peak (normalized value of 1)
            % - this is not what happens physiologically.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, firstX, firstY, min(firstX), max(firstX));
            initializedAPDData(1).peakData = segmentation.model.peakData();
            initializedAPDData(1).peakData.a80 = 0.15;
            initializedAPDData(2) = segmentation.model.apdData(2, secondX, secondY, min(secondX), max(secondX));
            initializedAPDData(2).peakData = segmentation.model.peakData();
            initializedAPDData(2).peakData.a80 = 0.16;
            initializedAPDData(3) = segmentation.model.apdData(3, thirdX, thirdY, min(thirdX), max(thirdX));
            initializedAPDData(3).peakData = segmentation.model.peakData();
            initializedAPDData(3).peakData.a80 = 0.17;
            
            actualOutData = testCase.processActionPotentialSegmentationHandles.calcDiastolicInterval(initializedAPDData);
            
            % Verify the diastlic interval has been correctly calculated.
            % The first waveform will always have an empty diastolic interval.
            verifyEmpty(testCase, actualOutData(1).diastolicInterval)
            verifyEqual(testCase, actualOutData(2).diastolicInterval, 0.35, 'AbsTol', 1e-6)
            verifyEqual(testCase, actualOutData(3).diastolicInterval, 0.34, 'AbsTol', 1e-6)
        end
        
        function calcDiastolicInverval_negativeDI_exception(testCase)
            % CALCDIASTOLICINVERVAL_NEGATIVEDI_EXCEPTION Diastolic interval exception -
            % verify a MATLAB:calcDiastolicInterval:negativeDiastolicInverval
            % exception is thrown when the calculation results in negative number.
            % Physiologically, this should never happen.
            
            % First waveform
            first = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 5);
            [firstX, firstY] = first.sinusoid;
            
            % Second waveform - time shifted with respect to the first
            % waveform.
            second = segmentation.test.functions.waveformGenerator(1, 0.5,  1, 5);
            [secondX, secondY] = second.sinusoid;
            secondX = secondX + max(firstX);
            
            % Initialize the three waveforms as apdData objects.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            initializedAPDData(1) = segmentation.model.apdData(1, firstX, firstY, min(firstX), max(firstX));
            initializedAPDData(1).peakData = segmentation.model.peakData();
            initializedAPDData(1).peakData.a80 = 0.80;
            initializedAPDData(2) = segmentation.model.apdData(2, secondX, secondY, min(secondX), max(secondX));
            initializedAPDData(2).peakData = segmentation.model.peakData();
            initializedAPDData(2).peakData.a80 = 0.81;
            
            % Verify the correct exception is thrown.
            testCase.verifyError(@()testCase.processActionPotentialSegmentationHandles.calcDiastolicInterval(initializedAPDData),...
                'MATLAB:calcDiastolicInterval:negativeDiastolicInverval');
        end
        
        function calcDiastolicInterval_emptyAPDData(testCase)
            % CALCDIASTOLICINTERVAL_EMPTYAPDDATA Empty diastolic interval - verify no
            % diastolic interval is calculated when a set of apdData object has empty
            % data.
            
            % Initialize the three waveforms as apdData objects.
            initializedAPDData(1, 3) = segmentation.model.apdData;
            actualOutData = testCase.processActionPotentialSegmentationHandles.calcDiastolicInterval(initializedAPDData);
            
            % There is no change with between the actual/expected outData objects
            verifyEqual(testCase, actualOutData, initializedAPDData);
        end
        
        function identifyCycleStopTimePoints_valid(testCase)
            % IDENTIFYCYCLESTOPTIMEPOINTS_VALID Cycle stop times - for a sinusoidal waveform
            % identify three time and voltage points where a cycle should stop.
            
            % Once cycle per second, three cycles.
            waveform = segmentation.test.functions.waveformGenerator(1, 3, 1, 1);
            [time, voltage] = waveform.sinusoid;
            
            [actualStopTime, actualStopVoltage] = testCase.processActionPotentialSegmentationHandles.identifyCycleStopTimePoints(time, voltage);
            
            % Verify expected results.
            verifyEqual(testCase, actualStopTime, [0.75 1.75 2.75]);
            verifyEqual(testCase, actualStopVoltage, [0 0 0]);
        end
        
        function identifyCycleStopTimePoints_emptyTime(testCase)
            % IDENTIFYCYCLESTOPTIMEPOINTS_EMPTYTIME Empty cycle stop times - verify the empty
            % stop times/voltages due to an empty time vector.
            
            % Once cycle per second, three cycles
            waveform = segmentation.test.functions.waveformGenerator(1, 3, 1, 1);
            [~, voltage] = waveform.sinusoid;
            
            [actualStopTime, actualStopVoltage] = testCase.processActionPotentialSegmentationHandles.identifyCycleStopTimePoints([], voltage);
            
            % Verify empty results.
            verifyEqual(testCase, actualStopTime, []);
            verifyEqual(testCase, actualStopVoltage, []);
        end
        
        function identifyCycleStopTimePoints_emptyVoltage(testCase)
            % IDENTIFYCYCLESTOPTIMEPOINTS_EMPTYVOLTAGE Empty cycle stop times - verify the empty
            % stop times/voltages due to an empty voltage vector.
            
            % Once cycle per second, three cycles.
            waveform = segmentation.test.functions.waveformGenerator(1, 3, 1, 1);
            [time, ~] = waveform.sinusoid;
            
            [actualStopTime, actualStopVoltage] = testCase.processActionPotentialSegmentationHandles.identifyCycleStopTimePoints(time, []);
            
            % Verify empty results.
            verifyEqual(testCase, actualStopTime, []);
            verifyEqual(testCase, actualStopVoltage, []);
        end
        
        function processAPDData_valid(testCase)
            % PROCESSAPDDATA_VALID Process two peaks - for two identical sinusoidal waveforms
            % determine the apdData and peakData attributes.  Since they are sinusoidal, they
            % should be equal (except for peakNum and start/stop times).  Attributes that require
            % all of the waveform values to be populated are not calculated.
            %   [1] attenuation
            %   [2] instantaneous frequency
            %   [3] average frequency
            %   [4] diastolic interval
            
            % Once cycle per second, three cycles.
            waveform = segmentation.test.functions.waveformGenerator(1, 3, 1, 1);
            [time, voltage] = waveform.sinusoid;
            startTime = [0 0.75];
            stopTime = [0.75 1.75];
            
            actualAPDData = testCase.processActionPotentialSegmentationHandles.processAPDData(time, voltage, startTime, stopTime);
            
            % Verify both sinusoidal peaks.
            verifyEqual(testCase, length(actualAPDData), 2);
            verifyEqual(testCase, actualAPDData(1).peakNum, 1);
            verifyEqual(testCase, actualAPDData(1).startTime, 0);
            verifyEqual(testCase, actualAPDData(1).stopTime, 0.75);
            verifyEqual(testCase, actualAPDData(1).peakTime, 0.25);
            verifyEqual(testCase, actualAPDData(1).peakVoltage, 2);
            verifyEqual(testCase, actualAPDData(1).absAmplitude, 2);
            verifyNotEmpty(testCase, actualAPDData(1).timeScale);
            verifyNotEmpty(testCase, actualAPDData(1).voltageScale);
            verifyEmpty(testCase, actualAPDData(1).attenuation);
            verifyEmpty(testCase, actualAPDData(1).instantFrequency);
            verifyEmpty(testCase, actualAPDData(1).avgFrequency);
            verifyEmpty(testCase, actualAPDData(1).diastolicInterval);
            verifyEqual(testCase, actualAPDData(1).peakData.apdRatio, 0.6288, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(1).peakData.apdDiff, 0.1476, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(1).peakData.triang, 0.1679, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(1).peakData.frac, 0.4765, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(1).peakData.a20, 0.1476, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(1).peakData.a30, 0.1845, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(1).peakData.a40, 0.2180, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(1).peakData.a50, 0.2500, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(1).peakData.a60, 0.2820, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(1).peakData.a70, 0.3155, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(1).peakData.a80, 0.3524, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(1).peakData.a90, 0.3976, 'AbsTol', 1e-4);
            
            verifyEqual(testCase, actualAPDData(2).peakNum, 2);
            verifyEqual(testCase, actualAPDData(2).startTime, 0.75);
            verifyEqual(testCase, actualAPDData(2).stopTime, 1.75);
            verifyEqual(testCase, actualAPDData(2).peakTime, 1.25);
            verifyEqual(testCase, actualAPDData(2).peakVoltage, 2);
            verifyEqual(testCase, actualAPDData(2).absAmplitude, 2);
            verifyNotEmpty(testCase, actualAPDData(2).timeScale);
            verifyNotEmpty(testCase, actualAPDData(2).voltageScale);
            verifyEmpty(testCase, actualAPDData(2).attenuation);
            verifyEmpty(testCase, actualAPDData(2).instantFrequency);
            verifyEmpty(testCase, actualAPDData(2).avgFrequency);
            verifyEmpty(testCase, actualAPDData(2).diastolicInterval);
            verifyEqual(testCase, actualAPDData(2).peakData.apdRatio, 0.6288, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(2).peakData.apdDiff, 0.1476, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(2).peakData.triang, 0.1679, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(2).peakData.frac, 0.4765, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(2).peakData.a20, 0.1476, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(2).peakData.a30, 0.1845, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(2).peakData.a40, 0.2180, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(2).peakData.a50, 0.2500, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(2).peakData.a60, 0.2820, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(2).peakData.a70, 0.3155, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(2).peakData.a80, 0.3524, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData(2).peakData.a90, 0.3976, 'AbsTol', 1e-4);
        end
        
        function processActionPotentialWaveforms_valid(testCase)
            % PROCESSACTIONPOTENTIALWAVEFORMS_VALID Process the entire segmentation -
            % verify the correct attributes have been determined for the created
            % waveform.
            
            % First waveform - teepee starting at t = 0, ending at t = 1
            % (1Hz), amplitude of 1.0.
            waveforms = segmentation.test.functions.waveformGenerator();
            [firstX, firstY] = waveforms.singleTeepee;
            firstX = (firstX / 20);
            firstX = firstX + 0.5;
            
            % Second waveform - teepee starting at t = 1, ending at t = 2
            % (1Hz), amplitude of 1.5.
            [secondX, secondY] = waveforms.singleTeepee;
            secondY = secondY * 1.5;
            secondX = (secondX / 20);
            secondX = secondX + 0.5 + max(firstX);
            
            % Third waveform - teepee starting at t = 2, ending at t = 3
            % (1Hz), amplitude of 0.75
            [thirdX, thirdY] = waveforms.singleTeepee;
            thirdY = thirdY * 0.75;
            thirdX = (thirdX / 20);
            thirdX = thirdX + 0.5 + max(secondX);
            
            % Forth waveform - partial waveform - will have no peakData.
            forth = segmentation.test.functions.waveformGenerator();
            [forthX, forthY] = forth.singleTeepee;
            forthY = forthY * 0.75;
            forthX = (forthX / 20);
            forthX = forthX + 0.5 + max(thirdX);
            cutIndex = find(forthY == max(forthY));
            forthX = forthX(forthX(cutIndex) >= forthX);
            forthY = forthY(forthX(cutIndex) >= forthX);
            
            % Aggregate all the of the X and Y values.
            finalX = [firstX, secondX, thirdX, forthX];
            finalY = [firstY, secondY, thirdY, forthY];
            
            % Initialize outData and supporting attributes.
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, finalX, finalY, [], 1, []);
            initializedOutData(1).apVoltageSegment = finalY;
            initializedOutData(1).apVoltageSegmentSmoothed = segmentation.functions.smooth_f(finalY, 50); % Smoothing feature is implemented in signalQC - it is needed here.
            initializedOutData(1).apTimeSegment = finalX;
            initializedOutData(1).apLeftCursorLoc = 0;
            initializedOutData(1).apRightCursorLoc = 3;
            
            actualProcessedOutData = testCase.processActionPotentialSegmentationHandles.processActionPotentialWaveforms(initializedOutData);
            
            % Verify apdData objects have been created.
            verifyEqual(testCase, length(actualProcessedOutData.apdData), 4);
            
            % Verify three out of the four data object have valid peak
            % data.  The forth one represent a partial waveform.
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakNum, 1);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(1).actionPotentialVoltage);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(1).actionPotentialTime);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).startTime, 0);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).stopTime, 0.9980, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakTime, 0.5);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakVoltage, 0.9875, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).absAmplitude, 0.9731, 'AbsTol', 1e-4);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(1).timeScale);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(1).voltageScale);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).attenuation, []);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).instantFrequency, 1);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).avgFrequency, 1.3333, 'AbsTol', 1e-4);
            verifyEmpty(testCase, actualProcessedOutData.apdData(1).diastolicInterval);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(1).peakData);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakData.apdRatio, 0.5621, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakData.apdDiff, 0.1946, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakData.triang, 0.2433, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakData.frac, 0.6147, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakData.a20, 0.1038, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakData.a30, 0.1525, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakData.a40, 0.2011, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakData.a50, 0.2498, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakData.a60, 0.2984, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakData.a70, 0.3471, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakData.a80, 0.3957, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(1).peakData.a90, 0.4444, 'AbsTol', 1e-4);
            
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakNum, 2);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(2).actionPotentialVoltage);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(2).actionPotentialTime);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).startTime, 0.9980, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).stopTime, 2.0040, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakTime, 1.5);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakVoltage, 1.4813, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).absAmplitude, 1.4693, 'AbsTol', 1e-4);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(2).timeScale);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(2).voltageScale);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).attenuation, 0.4938, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).instantFrequency, 1);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).avgFrequency, 1.3333, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).diastolicInterval, 0.6043, 'AbsTol', 1e-4);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(2).peakData);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakData.apdRatio, 0.5620, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakData.apdDiff, 0.1959, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakData.triang, 0.2449, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakData.frac, 0.6148, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakData.a20, 0.1045, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakData.a30, 0.1534, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakData.a40, 0.2024, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakData.a50, 0.2514, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakData.a60, 0.3004, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakData.a70, 0.3493, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakData.a80, 0.3983, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(2).peakData.a90, 0.4473, 'AbsTol', 1e-4);
            
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakNum, 3);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(3).actionPotentialVoltage);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(3).actionPotentialTime);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).startTime, 2.0040);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).stopTime, 3);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakTime, 2.5);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakVoltage, 0.7406, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).absAmplitude, 0.7316, 'AbsTol', 1e-4);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(3).timeScale);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(3).voltageScale);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).attenuation, -0.2469, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).instantFrequency, 1.0121, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).avgFrequency, 1.3333, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).diastolicInterval, 0.6017, 'AbsTol', 1e-4);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(3).peakData);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakData.apdRatio, 0.5620, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakData.apdDiff, 0.1951, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakData.triang, 0.2439, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakData.frac, 0.6148, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakData.a20, 0.1041, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakData.a30, 0.1528, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakData.a40, 0.2016, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakData.a50, 0.2504, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakData.a60, 0.2991, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakData.a70, 0.3479, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakData.a80, 0.3967, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(3).peakData.a90, 0.4455, 'AbsTol', 1e-4);
            
            verifyEqual(testCase, actualProcessedOutData.apdData(4).peakNum, 4);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(4).actionPotentialVoltage);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(4).actionPotentialTime);
            verifyEqual(testCase, actualProcessedOutData.apdData(4).startTime, 3);
            verifyEqual(testCase, actualProcessedOutData.apdData(4).stopTime, 3.5);
            verifyEqual(testCase, actualProcessedOutData.apdData(4).peakTime, 3.4880, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(4).peakVoltage, 0.7316, 'AbsTol', 1e-4);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).absAmplitude);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(4).timeScale);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).voltageScale);
            verifyEqual(testCase, actualProcessedOutData.apdData(4).attenuation, -0.2559, 'AbsTol', 1e-4);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).instantFrequency);
            verifyEqual(testCase, actualProcessedOutData.apdData(4).avgFrequency, 1.3333, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.apdData(4).diastolicInterval, 0.5913, 'AbsTol', 1e-4);
            verifyNotEmpty(testCase, actualProcessedOutData.apdData(4).peakData);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).peakData.apdRatio);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).peakData.apdDiff);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).peakData.triang);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).peakData.frac);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).peakData.a20);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).peakData.a30);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).peakData.a40);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).peakData.a50);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).peakData.a60);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).peakData.a70);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).peakData.a80);
            verifyEmpty(testCase, actualProcessedOutData.apdData(4).peakData.a90);
        end
        
        function processActionPotentialWaveforms_exception(testCase)
            % PROCESSACTIONPOTENTIALWAVEFORMS_EXCEPTION Process action potential waveforms
            % exception - verify a MATLAB:processWaveforms:multipleOutDataObjects exception
            % is thrown when more than one outData object is used as an input.
            
            % Initialize outData and supporting attributes.
            initializedOutData(1, 2) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, [], [], [], 1, []);
            initializedOutData(2) = segmentation.model.outData(2, [], [], [], 1, []);
            
            % Verify the correct exception is thrown.
            testCase.verifyError(@()testCase.processActionPotentialSegmentationHandles.processActionPotentialWaveforms(initializedOutData),...
                'MATLAB:processWaveforms:multipleOutDataObjects');
        end
        
        function processActionPotentialWaveforms_apOmit_true(testCase)
            % PROCESSACTIONPOTENTIALWAVEFORMS_APOMIT_TRUE Input equals output - verify
            % the input outData object equals the resultant outData object.
            
            % Initialize outData and supporting attributes.
            initializedOutData = segmentation.model.outData(1, [], [], [], 1, []);
            initializedOutData.apOmit = 1;
            
            actualProcessedOutData = testCase.processActionPotentialSegmentationHandles.processActionPotentialWaveforms(initializedOutData);
            
            % Verify no change.
            verifyEqual(testCase, actualProcessedOutData, initializedOutData);
        end
    end
end

