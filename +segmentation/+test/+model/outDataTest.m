classdef outDataTest < matlab.unittest.TestCase
    % OUTDATATEST - Test class for the outData.m object file.
    %
    % Author:  Jonathan Cook
    % Created: 2018-08-24
    
    methods(Test)
        function outData_valid(testCase)
            % OUTDATA_VALID Constructor - verify the state of the outData
            % object is correctly set upon initialization.
            
            % One cycle per second, one-half cycle, no multiplier, no
            % vertical shift
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 0);
            [waveformTime, waveformVoltage] = waveform.sinusoid;
            electroporation = [0:0.5:0.25];
            index = 1;
            wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            wellElectrode = segmentation.model.wellElectrodeData(index, wellLogical, electrodeLogical);
            experimentNum = 1;
            
            actualOutData = segmentation.model.outData(1, waveformTime, waveformVoltage, electroporation,...
                experimentNum, wellElectrode);
            
            verifyEqual(testCase, actualOutData.index, index);
            verifyEqual(testCase, actualOutData.voltage, waveformVoltage);
            verifyEqual(testCase, actualOutData.time, waveformTime);
            verifyEqual(testCase, actualOutData.esub, electroporation);
            verifyEqual(testCase, actualOutData.experimentNum, experimentNum);
            verifyEqual(testCase, actualOutData.wellElectrodeData, wellElectrode);
            verifyEqual(testCase, actualOutData.apProcessed, 0);
            verifyEqual(testCase, actualOutData.apOmit, 0);
            verifyEqual(testCase, actualOutData.fpProcessed, 0);
            verifyEqual(testCase, actualOutData.fpOmit, 0);
            verifyEqual(testCase, actualOutData.medicationName, 'No Medication');
            verifyEqual(testCase, actualOutData.medicationConcen, 'No Concentration');
            
            verifyEmpty(testCase, actualOutData.apdData);
            verifyEmpty(testCase, actualOutData.apVoltageSegment);
            verifyEmpty(testCase, actualOutData.apVoltageSegmentSmoothed);
            verifyEmpty(testCase, actualOutData.apTimeSegment);
            verifyEmpty(testCase, actualOutData.apLeftCursorLoc);
            verifyEmpty(testCase, actualOutData.apRightCursorLoc);
            verifyEmpty(testCase, actualOutData.apMeasGap);
            verifyEmpty(testCase, actualOutData.fieldData);
            verifyEmpty(testCase, actualOutData.fpVoltageSegment);
            verifyEmpty(testCase, actualOutData.fpVoltageSegmentSmoothed);
            verifyEmpty(testCase, actualOutData.fpTimeSegment);
            verifyEmpty(testCase, actualOutData.fpLeftCursorLoc);
            verifyEmpty(testCase, actualOutData.fprightCursorLoc);
        end
    end
end