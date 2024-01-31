classdef peakFinderTest < matlab.unittest.TestCase
    % PEAKDATATEST - Test class for the peakfinder_f function.
    %
    % Author:  Jonathan Cook
    % Created: 2018-07-01
    
    methods(Test)
        function sinusoid_multipleCycles_maxPeak_valid(testCase)
            % SINUSOID_MULTIPLECYCLES_MAXPEAK_VALID Verify each
            % peak value and the index within a sinusoidial waveform.
            
            % One cycle per second, five cycles, no multipler, no verticle
            % shift.  The peak value occurs at a values equal to 1.
            waveform = segmentation.test.functions.waveformGenerator(1, 5, 1, 0);
            [~, waveformVoltage] = waveform.sinusoid;
            
            % Determine the indexes and magnitudes when the 'voltage' equal 1.
            [expectedPeakMag, expectedPeakIndex] = find(waveformVoltage == 1);
            
            [actualPeakIndex, actualPeakMag] = segmentation.functions.peakFinder_f(waveformVoltage, [], [], 1, false, []);
            
            verifyEqual(testCase, actualPeakIndex, expectedPeakIndex);
            verifyEqual(testCase, actualPeakMag, expectedPeakMag);
        end
        
        function sinusoid_multipleCycles_maxPeakSmallAmp_valid(testCase)
            % SINUSOID_MULTIPLECYCLES_MAXPEAKSMALLAMP_VALID Verify each
            % peak value and index within a sinusoidial waveform.  The
            % peak values are unusually small.
            
            % One cycle per second, five cycles, multiplied by 1 x 10e-7,
            % no verticle shift.  The peak value occurs at a values equal to 1.
            waveform = segmentation.test.functions.waveformGenerator(1, 5, 1e-7, 0);
            [~, waveformVoltage] = waveform.sinusoid;
            
            expectedPeakIndex = find(waveformVoltage == 1e-7);
            expectedPeakMag = waveformVoltage(waveformVoltage == 1e-7);
            
            % Because the 4th parameter is equal to 1, maxima will be
            % determined.
            [actualPeakIndex, actualPeakMag] = segmentation.functions.peakFinder_f(waveformVoltage, [], [], 1, false, []);
            
            verifyEqual(testCase, actualPeakIndex, expectedPeakIndex);
            verifyEqual(testCase, actualPeakMag, expectedPeakMag);
        end
        
        function sinusoid_multipleCycles_variableEven_maxPeak_valid(testCase)
            % SINUSOID_MULTIPLECYCLES_VARIABLEEVEN_MAXPEAK_VALID Verify each
            % peak value and index is within a variable amplitude sinusoidal
            % waveform. Out of the 5 cycles, the even numbered cycles will have a
            % amplitude of 1, and the odd numbered cycles will have an
            % amplitude of 0.5.
            %
            % Since the first cycle's peak (1.0) is larger than the second cycle's
            % peak (0.5), all five peaks should be accounted for.
            
            waveform = segmentation.test.functions.waveformGenerator(1, 5, 1, 0);
            [~, waveformVoltage] = waveform.variableAmplitudeSinsoid(false);
            
            % Preallocate
            expectedPeakIndex = zeros(1, 5);
            waveNum = 1;
            
            % Identify the index (with correct order) where the peak is
            % either equal to 1 or 0.5.
            for i=1:length(waveformVoltage)
                if(waveformVoltage(i) == 1.0 || waveformVoltage(i) == 0.5)
                    expectedPeakIndex(waveNum) = i;
                    waveNum = waveNum + 1;
                    continue;
                end
            end
            
            % Using the previously determined indexes - determine the magnitudes.
            expectedPeakMag = waveformVoltage(expectedPeakIndex);
            
            [actualPeakIndex, actualPeakMag] = segmentation.functions.peakFinder_f(waveformVoltage, [], [], 1, false, []);
            
            verifyEqual(testCase, actualPeakIndex, expectedPeakIndex);
            verifyEqual(testCase, actualPeakMag, expectedPeakMag);
        end
        
        function sinusoid_multipleCycles_variableOdd_maxPeak_valid(testCase)
            % SINUSOID_MULTIPLECYCLES_VARIABLEODD_MAXPEAK_VALID Verify each
            % peak value and index within a sinsoidal waveform.  Out of the
            % 5 cycles, the odd numbered cycles will have an amplitude of 1,
            % and the even numbered cycles will have an amplitude of 0.5.
            %
            % Since the first cycle's peak (0.5) is smaller than the second
            % cycle (1.0), the first peak/index will be omitted.  Four out
            % of the five cycles will be accounted for.
            
            waveform = segmentation.test.functions.waveformGenerator(1, 5, 1, 0);
            [~, waveformVoltage] = waveform.variableAmplitudeSinsoid(true);
            
            % Preallocate
            expectedPeakIndex = zeros(1, 5);
            waveNum = 1;
            
            % Identify the index (with correct order) where the peak is
            % either equal to 1 or 0.5.
            for i=1:length(waveformVoltage)
                if(waveformVoltage(i) == 1.0 || waveformVoltage(i) == 0.5)
                    expectedPeakIndex(waveNum) = i;
                    waveNum = waveNum + 1;
                    continue;
                end
            end
            
            % Using the previously determined indexes - determine the magnitudes.
            expectedPeakMag = waveformVoltage(expectedPeakIndex);
            
            % Remove the first value - the first peak will never be
            % detected.
            expectedPeakIndex = expectedPeakIndex(2:5);
            expectedPeakMag = expectedPeakMag(2:5);
            
            [actualPeakIndex, actualPeakMag] = segmentation.functions.peakFinder_f(waveformVoltage, [], [], 1, false, []);
            
            verifyEqual(testCase, actualPeakIndex, expectedPeakIndex);
            verifyEqual(testCase, actualPeakMag, expectedPeakMag);
        end
        
        function sinusoid_multipleCycles_minPeak_valid(testCase)
            % SINUSOID_MULTIPLECYCLES_MINPEAK_VALID Verify each
            % peak value and the index where the minimum peak is identified
            % within sinusoidial waveform.
            
            % One cycle per second, five cycles, no amplitude multiplier,
            % no verticle shift.  The peak value occurs at a values equal to 1.
            waveform = segmentation.test.functions.waveformGenerator(1, 5, 1, 0);
            [~, waveformVoltage] = waveform.sinusoid;
            
            expectedPeakIndex = find(waveformVoltage == -1);
            expectedPeakMag = waveformVoltage(waveformVoltage == -1);
            
            [actualPeakIndex, actualPeakMag] = segmentation.functions.peakFinder_f(waveformVoltage, [], [], -1, false, []);
            
            verifyEqual(testCase, actualPeakIndex, expectedPeakIndex);
            verifyEqual(testCase, actualPeakMag, expectedPeakMag);
        end
        
        function sinusoid_twoCycles_maxPeak_valid(testCase)
            % SINUSOID_TWOCYCLES_MAXPEAK_VALID Verify each peak
            % value and the index within a sinusoidal waveform
            % that contains only two cycles.
            
            % One cycle per second, two cycles, no amplitude multiplier,
            % no verticle shift.  The peak value occurs at a values equal to 1.
            waveform = segmentation.test.functions.waveformGenerator(1, 2, 1, 0);
            [~, waveformVoltage] = waveform.sinusoid;
            
            [expectedPeakMag, expectedPeakIndex] = find(waveformVoltage == 1);
            
            [actualPeakIndex, actualPeakMag] = segmentation.functions.peakFinder_f(waveformVoltage, [], [], 1, false, []);
            
            verifyEqual(testCase, actualPeakIndex, expectedPeakIndex);
            verifyEqual(testCase, actualPeakMag, expectedPeakMag);
        end
        
        function sinusoid_singleCycle_maxPeak_empty(testCase)
            % SINUSOID_SINGLECYCLE_MAXPEAK_EMPTY Verify peak
            % detection fails since there is only a single cycle.
            
            waveform = segmentation.test.functions.waveformGenerator(1, 1, 1, 0);
            [~, waveformVoltage] = waveform.sinusoid;
            
            [actualPeakIndex, actualPeakMag] = segmentation.functions.peakFinder_f(waveformVoltage, [], [], 1, false, []);
            
            verifyEqual(testCase, actualPeakIndex, []);
            verifyEqual(testCase, actualPeakMag, []);
        end
        
        function sinusoid_halfCycle_maxPeak_empty(testCase)
            % SINUSOID_HALFCYCLE_MAXPEAK_EMPTY Verify peak
            % detection fails when a 1/2 cycle's peak is attempted to
            % be identified.
            
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 0);
            [~, waveformVoltage] = waveform.sinusoid;
            
            [actualPeakIndex, actualPeakMag] = segmentation.functions.peakFinder_f(waveformVoltage, [], [], 1, false, []);
            
            verifyEqual(testCase, actualPeakIndex, []);
            verifyEqual(testCase, actualPeakMag, []);
        end
    end
end