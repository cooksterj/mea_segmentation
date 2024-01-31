classdef processFieldPotentialSegmentationTest < matlab.unittest.TestCase
    % PROCESSFIELDPOTENTIALSEGMENTATIONTEST - Test class for the
    % processFieldPotentialSegmentation_f functions.
    %
    % Author:  Jonathan
    % Created: 2018-08-29
    
    properties
        processFieldPotentialSegmentationHandles;
    end
    
    % Initialization.
    methods (TestClassSetup)
        function ClassSetup(testCase)
            % CLASSSETUP - Set the test case properties.
            
            testCase.processFieldPotentialSegmentationHandles = segmentation.functions.processFieldPotentialSegmentation_f;
        end
    end
    
    methods(Test)
        function identifyCycleStopTimePoints_valid(testCase)
            % IDENTIFYCYCLESTOPTIMEPOINTS_VALID	Identify cycle stop points - verify the correct
            % identification of cycle time points for a simulated 'field potential' sinusodial
            % waveform.
            
            % Once cycle per second, three cycles.
            waveform = segmentation.test.functions.waveformGenerator(1, 3, 1, 1);
            [time, voltage] = waveform.sinusoid;
            
            [actualStopTime, actualStopVoltage] = testCase.processFieldPotentialSegmentationHandles.identifyCycleStopTimePoints(time, voltage);
            
            % Verify expected results.
            verifyEqual(testCase, actualStopTime, [0.75 1.75], 'AbsTol', 1e-4);
            verifyEqual(testCase, actualStopVoltage, [0 0], 'AbsTol', 1e-4);
        end
        
        function identifyCycleStopTimePoints_emptyTime(testCase)
            % IDENTIFYCYCLESTOPTIMEPOINTS_EMPTYTIME Empty time - verify the cycle
            % stop time points are empty due to an empty time vector.
            
            % Once cycle per second, three cycles.
            waveform = segmentation.test.functions.waveformGenerator(1, 3, 1, 1);
            [~, voltage] = waveform.sinusoid;
            
            [actualStopTime, actualStopVoltage] = testCase.processFieldPotentialSegmentationHandles.identifyCycleStopTimePoints([], voltage);
            
            % Verify empty results.
            verifyEmpty(testCase, actualStopTime);
            verifyEmpty(testCase, actualStopVoltage, []);
        end
        
        function identifyCycleStopTimePoints_emptyVoltage(testCase)
            % IDENTIFYCYCLESTOPTIMEPOINTS_EMPTYVOLTAGE Empty voltage - verify the cycle
            % stop time points are empty due to an empty voltage vector.
            
            % Once cycle per second, three cycles.
            waveform = segmentation.test.functions.waveformGenerator(1, 3, 1, 1);
            [time, ~] = waveform.sinusoid;
            
            [actualStopTime, actualStopVoltage] = testCase.processFieldPotentialSegmentationHandles.identifyCycleStopTimePoints(time, []);
            
            % Verify empty results.
            verifyEmpty(testCase, actualStopTime);
            verifyEmpty(testCase, actualStopVoltage);
        end
        
        function calcSlope_singleFieldData_valid(testCase)
            % CALCSLOPE_VALID Single fieldData slope - verify the correct slope
            % calculation occurs for a teepee waveform.
            
            waveform = segmentation.test.functions.waveformGenerator();
            [time, voltage] = waveform.singleTeepee;
            
            % Shift all time values by 10 - sanity.
            time = time + 10;
            fieldDataTest = segmentation.model.fieldData(1, time, voltage, min(time), max(time));
            
            actualFieldData = testCase.processFieldPotentialSegmentationHandles.calcSlope(fieldDataTest);
            
            % Verify expected slope value.
            verifyEqual(testCase, actualFieldData.slope, -0.10, 'AbsTol', 1e-4);
        end
        
        function calcSlope_multipleFieldData_valid(testCase)
            % CALCSLOPE_MULTIPLEFIELDDATA_VALID Multiple fieldData slopes - verify
            % the correct slope calculation occurs for multiple teepee waveforms.
            
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
            
            % Create fieldData object array.
            fieldDataTest(1) = segmentation.model.fieldData(1, firstX, firstY, min(firstX), max(firstX));
            fieldDataTest(2) = segmentation.model.fieldData(2, secondX, secondY, min(secondX), max(secondX));
            fieldDataTest(3) = segmentation.model.fieldData(3, thirdX, thirdY, min(thirdX), max(thirdX));
            
            actualFieldData = testCase.processFieldPotentialSegmentationHandles.calcSlope(fieldDataTest);
            
            % Verify expected slope value.
            verifyEqual(testCase, actualFieldData(1).slope, -2.00, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualFieldData(2).slope, -3.00, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualFieldData(3).slope, -1.50, 'AbsTol', 1e-4);
        end
        
        function calcSlope_emptyTime(testCase)
            % CALCSLOPE_EMPTYTIME Empty slope - verify no slope is calculated
            % due to an empty time vector.
            
            waveform = segmentation.test.functions.waveformGenerator();
            [~, voltage] = waveform.singleTeepee;
            
            fieldDataTest = segmentation.model.fieldData(1, [], voltage, [], []);
            actualFieldData = testCase.processFieldPotentialSegmentationHandles.calcSlope(fieldDataTest);
            
            % Verify empty slope.
            verifyEmpty(testCase, actualFieldData.slope);
        end
        
        function calcSlope_emptyVoltage(testCase)
            % CALCSLOPE_EMPTYVOLTAGE Empty slope - verify no slope is calculated
            % due to an empty voltage vector.
            
            waveform = segmentation.test.functions.waveformGenerator();
            [time, ~] = waveform.singleTeepee;
            
            % Shift all time values by 10 - sanity.
            time = time + 10;
            fieldDataTest = segmentation.model.fieldData(1, time, [], min(time), max(time));
            
            actualFieldData = testCase.processFieldPotentialSegmentationHandles.calcSlope(fieldDataTest);
            
            % Verify empty slope.
            verifyEmpty(testCase, actualFieldData.slope);
        end
        
        function processFieldData_valid(testCase)
            % PROCESSFIELDDATA_VALID Process segmentation - verify the correct
            % fieldData cycle is created.
            
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
            
            % Start and stop times are based on the first teepee.
            startTime = min(firstX);
            stopTime = max(firstX);
            
            % Segmented time and voltage values.
            time = [firstX, secondX];
            voltage = [firstY, secondY];
            
            actualFieldData = testCase.processFieldPotentialSegmentationHandles.processFieldData(time, voltage, startTime, stopTime);
            
            % Verify only the first waveform has been identified.
            verifyEqual(testCase, length(actualFieldData), 1);
            verifyEqual(testCase, actualFieldData.peakNum, 1);
            verifyNotEmpty(testCase, actualFieldData.fieldPotentialVoltage);
            verifyNotEmpty(testCase, actualFieldData.fieldPotentialTime);
            verifyEqual(testCase, actualFieldData.startTime, 0);
            verifyEqual(testCase, actualFieldData.stopTime, 1);
            verifyEqual(testCase, actualFieldData.peakTime, 0.5);
            verifyEqual(testCase, actualFieldData.peakVoltage, 1);
            verifyEqual(testCase, actualFieldData.absAmplitude, 1);
            verifyEmpty(testCase, actualFieldData.instantFrequency);
            verifyEmpty(testCase, actualFieldData.avgFrequency);
            verifyEmpty(testCase, actualFieldData.slope);
        end
        
        function processFieldWaveforms_valid(testCase)
            % PROCESSFIELDWAVEFORMS_VALID Process the entire segmentation -
            % verify the correct correct attributes have been calculated for
            % each waveform.
            
            waveforms = segmentation.test.functions.waveformGenerator();
            [firstX, firstY] = waveforms.sizeZ;
            firstY = firstY * 1.9;
            
            padFirstX = (max(firstX):0.1:10);
            padFirstY = zeros(1, length(padFirstX));
            
            [secondX, secondY] = waveforms.sizeZ;
            secondX = secondX + max(padFirstX);
            secondY = secondY * 2;
            
            padSecondX = (max(secondX):0.1:25);
            padSecondY = zeros(1, length(padSecondX));
            
            [thirdX, thirdY] = waveforms.sizeZ;
            thirdX = thirdX + max(padSecondX);
            thirdY = thirdY * 2.5;
            
            finalX = [firstX, padFirstX, secondX, padSecondX, thirdX];
            finalY = [firstY, padFirstY, secondY, padSecondY, thirdY];
            
            % Initialize outData and supporting attributes.
            initializedOutData(1, 1) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, finalX, finalY, [], 1, []);
            initializedOutData(1).fpVoltageSegment = finalY;
            initializedOutData(1).fpVoltageSegmentSmoothed = finalY;
            initializedOutData(1).fpTimeSegment = finalX;
            initializedOutData(1).fpLeftCursorLoc = 0;
            initializedOutData(1).fprightCursorLoc = 30.5;
            
            actualProcessedOutData = testCase.processFieldPotentialSegmentationHandles.processFieldWaveforms(initializedOutData);
            
            % Verify three fieldData objects exist, as well as the calculated
            % attributes.
            verifyEqual(testCase, length(actualProcessedOutData.fieldData), 3);
            verifyEqual(testCase, actualProcessedOutData.fieldData(1).peakNum, 1);
            verifyNotEmpty(testCase, actualProcessedOutData.fieldData(1).fieldPotentialVoltage);
            verifyNotEmpty(testCase, actualProcessedOutData.fieldData(1).fieldPotentialTime);
            verifyEqual(testCase, actualProcessedOutData.fieldData(1).startTime, 0.0000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(1).stopTime, 7.0000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(1).peakTime, 2.0000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(1).peakVoltage, 3.8000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(1).absAmplitude, 9.5000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(1).instantFrequency, 0.1000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(1).avgFrequency, 0.0984, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(1).slope, -19.0, 'AbsTol', 1e-4);
            
            verifyEqual(testCase, actualProcessedOutData.fieldData(2).peakNum, 2);
            verifyNotEmpty(testCase, actualProcessedOutData.fieldData(2).fieldPotentialVoltage);
            verifyNotEmpty(testCase, actualProcessedOutData.fieldData(2).fieldPotentialTime);
            verifyEqual(testCase, actualProcessedOutData.fieldData(2).startTime, 7.0000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(2).stopTime, 19.5000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(2).peakTime, 12.0000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(2).peakVoltage, 4.0000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(2).absAmplitude, 10.0000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(2).instantFrequency, 0.0667, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(2).avgFrequency, 0.0984, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(2).slope, -20.0, 'AbsTol', 1e-4);
            
            verifyEqual(testCase, actualProcessedOutData.fieldData(3).peakNum, 3);
            verifyNotEmpty(testCase, actualProcessedOutData.fieldData(3).fieldPotentialVoltage);
            verifyNotEmpty(testCase, actualProcessedOutData.fieldData(3).fieldPotentialTime);
            verifyEqual(testCase, actualProcessedOutData.fieldData(3).startTime, 19.5000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(3).stopTime, 30.5000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(3).peakTime, 27.0000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(3).peakVoltage, 5.0000, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(3).absAmplitude, 12.5000, 'AbsTol', 1e-4);
            verifyEmpty(testCase, actualProcessedOutData.fieldData(3).instantFrequency);
            verifyEqual(testCase, actualProcessedOutData.fieldData(3).avgFrequency, 0.0984, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualProcessedOutData.fieldData(3).slope, -25.0, 'AbsTol', 1e-4);
        end
        
        function processFieldWaveforms_exception(testCase)
            % PROCESSFIELDWAVEFORMS_EXCEPTION Process field potential waveforms
            % exception - verify a MATLAB:processWaveforms:multipleOutDataObjects exception
            % is thrown when more than one outData object is used as an input.
            
            % Initialize outData and supporting attributes.
            initializedOutData(1, 2) = segmentation.model.outData;
            initializedOutData(1) = segmentation.model.outData(1, [], [], [], 1, []);
            initializedOutData(2) = segmentation.model.outData(2, [], [], [], 1, []);
            
            % Verify the correct exception is thrown.
            testCase.verifyError(@()testCase.processFieldPotentialSegmentationHandles.processFieldWaveforms(initializedOutData),...
                'MATLAB:processFPWaveforms:multipleOutDataObjects');
        end
        
        function processFieldWaveforms_fpOmit_true(testCase)
            % PROCESSFIELDWAVEFORMS_FPOMIT_TRUE Input equals output - verify
            % the input outData object equals the resultant outData object.
            
            % Initialize outData and supporting attributes.
            initializedOutData = segmentation.model.outData(1, [], [], [], 1, []);
            initializedOutData.fpOmit = 1;
            
            actualProcessedOutData = testCase.processFieldPotentialSegmentationHandles.processFieldWaveforms(initializedOutData);
            
            % Verify no change.
            verifyEqual(testCase, actualProcessedOutData, initializedOutData);
        end
    end
end
