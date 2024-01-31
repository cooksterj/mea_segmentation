classdef fieldDataTest < matlab.unittest.TestCase
    % FIELDDATATEST - Test class for the fieldData.m object file.
    %
    % Author:  Jonathan Cook
    % Created: 2018-06-21
    
    methods(Test)
        function fieldData_valid(testCase)
            % FIELDDATA_VALID Constructor - verify the state of the fieldData
            % object is correctly set upon initialization.
            
            % Empty initialization to acquire the sideways 'z' waveform.
            waveform = segmentation.test.functions.waveformGenerator();
            [waveformTime, waveformVoltage] = waveform.sizeZ();
            startTime = min(waveformTime);
            stopTime = max(waveformTime);
            
            actualFieldData = segmentation.model.fieldData(1, waveformTime, waveformVoltage, startTime, stopTime);
            
            % The only attributes not set during instantiation is instantFrequency,
            % avgFrequency, and slope.
            verifyEqual(testCase, actualFieldData.peakNum, 1);
            verifyEqual(testCase, actualFieldData.fieldPotentialTime, waveformTime);
            verifyEqual(testCase, actualFieldData.fieldPotentialVoltage, waveformVoltage);
            verifyEqual(testCase, actualFieldData.startTime, startTime);
            verifyEqual(testCase, actualFieldData.stopTime, stopTime);
            verifyEqual(testCase, actualFieldData.peakTime, 2.0);
            verifyEqual(testCase, actualFieldData.peakVoltage, 2.0);
            verifyEqual(testCase, actualFieldData.absAmplitude, 5.0);
            
            verifyEmpty(testCase, actualFieldData.instantFrequency);
            verifyEmpty(testCase, actualFieldData.avgFrequency);
            verifyEmpty(testCase, actualFieldData.slope);
        end
    end
end

