classdef apdDataTest < matlab.unittest.TestCase
    % APDDATATEST - Test class for the apdData.m object file.
    %
    % Author:  Jonathan Cook
    % Created: 2018-06-21
    
    methods(Test)
        function apdData_valid(testCase)
            % APDDATA_VALID Constructor - verify the state of the apdData object
            % upon initialization.
            
            % One cycle per second, one-half cycle, no multiplier, one unit
            % shift up; therefore, peak voltage equals 2.
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 1);
            [waveformTime, waveformVoltage] = waveform.sinusoid;
            startTime = min(waveformTime);
            stopTime = max(waveformTime);
            
            % Amplitude is 2 (peak) - 1 (min); therefore, normalize by using value of 1.
            expectedScaledVoltage = waveformVoltage - 1;
            expectedShiftedTime = waveformTime - 0.25;
            
            actualAPDData = segmentation.model.apdData(1, waveformTime, waveformVoltage, startTime, stopTime);
            
            verifyEqual(testCase, actualAPDData.peakNum, 1);
            verifyEqual(testCase, actualAPDData.actionPotentialVoltage, waveformVoltage);
            verifyEqual(testCase, actualAPDData.actionPotentialTime, waveformTime);
            verifyEqual(testCase, actualAPDData.startTime, startTime);
            verifyEqual(testCase, actualAPDData.stopTime, stopTime);
            verifyEqual(testCase, actualAPDData.peakTime, 0.25);
            verifyEqual(testCase, actualAPDData.peakVoltage, 2.0);
            verifyEqual(testCase, actualAPDData.absAmplitude, 1, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData.timeScale, expectedShiftedTime, 'AbsTol', 1e-4);
            verifyEqual(testCase, actualAPDData.voltageScale, expectedScaledVoltage, 'AbsTol', 1e-4);
            verifyEmpty(testCase, actualAPDData.attenuation);
            verifyEmpty(testCase, actualAPDData.instantFrequency);
            verifyEmpty(testCase, actualAPDData.avgFrequency);
            verifyEmpty(testCase, actualAPDData.diastolicInterval);
        end
        
        function calcTimeScale_valid(testCase)
            % CALCTIMESCALE_VALID Time adjustment - verify the time shift takes
            % place where the peak voltage will reside at origin within a cartesian
            % coordinate system.
            
            % One cycle per second, one-half cycle, no multiplier, one unit
            % shift up; therefore, peak voltage equals 2.
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 1);
            [waveformTime, waveformVoltage] = waveform.sinusoid;
            
            % Since 1 cycle per second, and 0.5 cyle was created, peak time will be
            % equal to 1/4th of a second.
            peakTime = 0.25;
            
            % Junk attributes for instantiation
            apdDataRslt = segmentation.model.apdData(1, 0, 0, 0, 0);
            actualTimeScale = apdDataRslt.calcTimeScale(waveformTime, peakTime);
            
            % Verify the length has not changed after shifting and the voltage
            % value equals 2 at origin.
            verifyEqual(testCase, length(actualTimeScale), length(waveformTime));
            verifyEqual(testCase, waveformVoltage(actualTimeScale == 0), 2)
        end
        
        function calcTimeScale_emptyTime(testCase)
            % CALCTIMESCALE_EMPTYTIME Time adjustment - empty time shift vector
            % due to an empty action potential time vector
            
            % Since 1 cycle per second, and 0.5 cyle was created, peak time will be
            % equal to 1/4th of a second.
            peakTime = 0.25;
            
            % Junk attributes for instantiation
            apdDataRslt = segmentation.model.apdData(1, 0, 0, 0, 0);
            actualTimeScale = apdDataRslt.calcTimeScale([], peakTime);
            
            verifyEmpty(testCase, actualTimeScale);
        end
        
        function calcTimeScale_emptyPeakTime(testCase)
            % CALCTIMESCALE_EMPTYPEAKTIME Time adjustment - empty time
            % shift vector due to an empty peak time value.
            
            % One cycle per second, one-half cycle, no multiplier, one unit
            % shift up; therefore, peak voltage equals 2.
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 1);
            [waveformTime, ~] = waveform.sinusoid;
            
            % Junk attributes for instantiation
            apdDataRslt = segmentation.model.apdData(1, 0, 0, 0, 0);
            actualTimeScale = apdDataRslt.calcTimeScale(waveformTime, []);
            
            verifyEmpty(testCase, actualTimeScale);
        end
        
        function calcVoltageScale_valid(testCase)
            % CALCVOLTAGESCALE_VALID Voltage scaling - verify the voltage vector
            % will be normalized with respect to its amplitude, such that the peak
            % voltage will equal one.
            
            % One cycle per second, one-half cycle, no multiplier, five units
            % shift up; therefore, peak voltage equals 5.
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 2, 5);
            [waveformTime, waveformVoltage] = waveform.sinusoid;
            minPeakVoltage = 5;
            actionPotentialAmplitude = 2;
            
            % Junk attributes for instantiation
            apdDataRslt = segmentation.model.apdData(1, 0, 0, 0, 0);
            actualVoltageScale = apdDataRslt.calcVoltageScale(waveformVoltage, minPeakVoltage, actionPotentialAmplitude);
            
            % Verify the length has not changed after normalization and peak voltage
            % has normalized at time 0.25.
            verifyEqual(testCase, length(actualVoltageScale), length(waveformVoltage));
            verifyEqual(testCase, actualVoltageScale(waveformTime == 0.25), 1)
        end
        
        function calcVoltageScale_emptyVoltage(testCase)
            % CALCVOLTAGESCALE_EMPTYVOLTAGE Voltage scaling - empty normalized
            % voltage due to an empty action potential voltage vector.
            
            minPeakVoltage = 5;
            actionPotentialAmplitude = 2;
            
            % Junk attributes for instantiation
            apdDataRslt = segmentation.model.apdData(1, 0, 0, 0, 0);
            actualVoltageScale = apdDataRslt.calcVoltageScale([], minPeakVoltage, actionPotentialAmplitude);
            
            verifyEmpty(testCase, actualVoltageScale);
        end
        
        function calcVolageScale_emptyMinPeakVoltage(testCase)
            % CALCVOLAGESCALE_EMPTYMINPEAKVOLTAGE Voltage scalilng - empty normalized
            % voltage vector due to an empty min peak voltage.
            
            % One cycle per second, one-half cycle, no multiplier, five units
            % shift up; therefore, peak voltage equals 5.
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 2, 5);
            [~, waveformVoltage] = waveform.sinusoid;
            actionPotentialAmplitude = 2;
            
            % Junk attributes for instantiation
            apdDataRslt = segmentation.model.apdData(1, 0, 0, 0, 0);
            actualVoltageScale = apdDataRslt.calcVoltageScale(waveformVoltage, [], actionPotentialAmplitude);
            
            verifyEmpty(testCase, actualVoltageScale);
        end
        
        function calcVoltageScale_emptyAmplitude(testCase)
            % CALCVOLTAGESCALE_EMPTYAMPLITUDE Voltage scaling - empty normalized
            % voltage vector due to an empty action potential amplitude.
            
            % One cycle per second, one-half cycle, no multiplier, five units
            % shift up; therefore, peak voltage equals 5.
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 2, 5);
            [~, waveformVoltage] = waveform.sinusoid;
            minPeakVoltage = 5;
            
            % Junk attributes for instantiation
            apdDataRslt = segmentation.model.apdData(1, 0, 0, 0, 0);
            actualVoltageScale = apdDataRslt.calcVoltageScale(waveformVoltage, minPeakVoltage, []);
            
            % Verify the length has not changed after normalization.
            verifyEmpty(testCase, actualVoltageScale);
        end
    end
end