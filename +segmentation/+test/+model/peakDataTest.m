classdef peakDataTest < matlab.unittest.TestCase
    % PEAKDATATEST - Test class for the peakData.m object file
    %
    % Author:  Jonathan Cook
    % Created: 2018-06-15
    
    methods(Test)
        function timeAndVoltageAPDRange_valid(testCase)
            % TIMEANDVOLTAGEAPDRANGE_VALID Time and voltage range - validate the
            % correct range of action potential time and voltage measurements
            % will be identified for an 80% interval (20% repolarization).
            
            % One cycle per second, one-half cycle, no multiplier, no
            % verticle shift.  The peak voltage occurs at 0.25s.  Amplitude
            % normalization does not need to occur.  To make the peak
            % 'voltage' equal to a time of 0, each waveformTime value will
            % be shifted by 0.25.
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 0);
            [waveformTime, waveformVoltage] = waveform.sinusoid;
            waveformTime = waveformTime - 0.25;
            
            % Determine the expectedAPDRange - time and voltage - for 80%.  Conditions:
            %     [1] Voltage >= 0 (peak is at time 0)
            %     [2] Voltage >= 0.795 (80% with a -0.5% wiggle factor)
            %     [3] Voltage <= 0.805 (80% with a +0.5% wiggle factor)
            apd80 = (waveformTime >= 0 & waveformVoltage >= 0.7950 & waveformVoltage <= 0.8050);
            expectedTimeAPDRange = waveformTime(apd80);
            expectedVoltageAPDRange = waveformVoltage(apd80);
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            [actualTimeAPDRange, actualVoltageAPDRange] = testPeakData.timeAndVoltageAPDRange(0.8000, waveformTime, waveformVoltage);
            
            % The voltage and time ranges should equal.
            verifyEqual(testCase, actualVoltageAPDRange, expectedVoltageAPDRange);
            verifyEqual(testCase, actualTimeAPDRange, expectedTimeAPDRange);
        end
        
        function timeAndVoltageAPDRange_emptyAPDRange(testCase)
            % TIMEANDVOLTAGEAPDRANGE_EMPTYAPDRANGE Empty APD percentage - validate the
            % action potential repolarization time and voltage ranges are empty when a empty
            % apdPct is provided.
            
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 0);
            [waveformTime, waveformVoltage] = waveform.sinusoid;
            waveformTime = waveformTime - 0.25;
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            
            % The result of timeAndVoltageAPDRange should be empty.
            verifyEmpty(testCase, testPeakData.timeAndVoltageAPDRange([], waveformTime, waveformVoltage));
        end
        
        function timeAndVoltageAPDRange_emptyTimeScale(testCase)
            % TIMEANDVOLTAGEAPDRANGE_EMPTYTIMESCALE Empty time scale - validate the
            % action potential repolarization time and voltage vectors are empty when
            % a empty time scale vector is provided.
            
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 0);
            [~, waveformVoltage] = waveform.sinusoid;
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            
            % The result of timeAndVoltageAPDRange should be empty.
            verifyEmpty(testCase, testPeakData.timeAndVoltageAPDRange(0.90, [], waveformVoltage));
        end
        
        function timeAndVoltageAPDRange_emptyVoltageScale(testCase)
            % TIMEANDVOLTAGEAPDRANGE_EMPTYVOLTAGESCALE Empty voltage sacel - validate
            % the action potential repolarization time and voltage vectors are empty
            % when a empty voltage scale is provided.
            
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 1, 0);
            [waveformTime, ~] = waveform.sinusoid;
            waveformTime = waveformTime - 0.25;
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            
            % The result of timeAndVoltageAPDRange should be empty.
            verifyEmpty(testCase, testPeakData.timeAndVoltageAPDRange(0.50, waveformTime, []));
        end
        
        function timeAndVoltageAPDRange_nonNormalizedVoltage_exception(testCase)
            % TIMEANDVOLTAGEAPDRANGE_NONNORMALIZEDVOLTAGE_EXCEPTION
            % Incorrect voltage normalization - validate that a
            % MATLAB:timeAndVoltageAPDRange:incorrectNormalizedVoltageScale
            % exception will be produced when the scaled voltage vector has
            % not been normalized.
            
            % The sinusoid does not have a peak value of 1, due to the
            % scale = 10.
            waveform = segmentation.test.functions.waveformGenerator(1, 0.5, 10, 0);
            [waveformTime, waveformVoltage] = waveform.sinusoid;
            waveformTime = waveformTime - 0.25;
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            
            % Verify the correct error has been thrown.
            testCase.verifyError(@()testPeakData.timeAndVoltageAPDRange(0.20, waveformTime, waveformVoltage), 'MATLAB:timeAndVoltageAPDRange:incorrectNormalizedVoltageScale');
        end
        
        function calcPeakAttr_multipleVectorPair_equalSize_singleSlope_valid(testCase)
            % CALCPEAKATTR_MULTIPLEVECTORPAIR_EQUALSIZE_SINGLESLOPE_VALID
            % Peak attribute - validate the time value for a repolarization
            % percentage at 50%.  The time and voltage vectors are linear with a single slope.
            
            actPct = 0.5000;
            vAPDRange = [0.55, 0.45];
            tAPDRange = [0.10, 0.50];
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            actualAPDTime = round(testPeakData.calcPeakAttr(actPct, tAPDRange, vAPDRange), 4);
            
            % The expected value was determined using an independant web
            % service:
            %     [1] https://www.johndcook.com/interpolator.html
            %     [2] (x1, y1) = (0.55, 0.45)
            %     [3] (x3, y3) = (0.10, 0.50)
            %     [4] (y2) = 0.50
            verifyEqual(testCase, actualAPDTime, 0.3000);
        end
        
        function calcPeakAttr_multipleVectorPair_equalSize_multipleSlope_valid(testCase)
            % CALCPEAKATTR_MULTIPLEVECTORPAIR_EQUALSIZE_MULTIPLESLOPE_VALID
            % Peak attribute - validate the time value for a repolarization percentage at 50%.
            % The time and voltage vectors are not linear.  The slope transition
            % occurs at (x, y) = (0.5, 0.45).
            
            actPct = 0.5000;
            vAPDRange = [0.55, 0.45, 0.35, 0.25, 0.15];
            tAPDRange = [0.10, 0.50, 0.51, 0.52, 0.53];
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            
            actualAPDTime = round(testPeakData.calcPeakAttr(actPct, tAPDRange, vAPDRange), 4);
            
            % The expected value was determined using an independant web
            % service:
            %     [1] https://www.johndcook.com/interpolator.html
            %     [2] (x1, y1) = (0.1, 0.55)
            %     [3] (x3, y3) = (0.53, 0.15)
            %     [4] (y2) = 0.50
            verifyEqual(testCase, actualAPDTime, 0.1538);
        end
        
        function calcPeakAttr_singleVectorPair_noSlope_exception(testCase)
            % CALCPEAKATTR_SINGLEVECTORPAIR_NOSLOPE_EXCEPTION Exception - verify a
            % MATLAB:calcPeakAttr:linearInterpolationNaN exception will be
            % produced when there is a single x, y value.  Linear
            % interpolation cannot occur if there is no slope.
            
            actPct = 0.5000;
            vAPDRange = 0.55;
            tAPDRange = 0.10;
            
            testPeakData = segmentation.model.peakData([], []);
            
            % Verify linear interpolation will produce a NaN - throw an
            % exception.
            testCase.verifyError(@()testPeakData.calcPeakAttr(actPct, tAPDRange, vAPDRange), 'MATLAB:calcPeakAttr:linearInterpolationNaN');
        end
        
        function calcPeakAttr_multipleVectorPair_differentSize_exception(testCase)
            % CALCPEAKATTR_MULTIPLEVECTORPAIR_DIFFERENTSIZE_EXCEPTION Exception -
            % verify a MATLAB:calcPeakAttr:mismatchTimeAndVoltageRangeVectors
            % exception will be thrown when the voltage and time vectors
            % are not of equal length.  There should be no circumstances
            % where there is a voltage measurement with no corresponding
            % time measurement, and vice-versa.
            
            actPct = 0.5000;
            vAPDRange = [0.55, 0.45, 0.35, 0.25, 0.15];
            tAPDRange = [0.10, 0.50, 0.51, 0.52];
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            
            % Verify the correct excption has been thrown.
            testCase.verifyError(@()testPeakData.calcPeakAttr(actPct, tAPDRange, vAPDRange), 'MATLAB:calcPeakAttr:mismatchTimeAndVoltageRangeVectors');
        end
        
        function calcPeakAttr_voltageAPDRangeLessThanAPDPct_exception(testCase)
            % CALCPEAKATTR_VOLTAGEAPDRANGELESSTHANAPDPCT_EXCEPTION Exception - veirfy a
            % MATLAB:calcPeakAttr:scaledVoltageOutOfRange exception will be
            % thrown when the largest (first) value in the voltage APD
            % range is smaller than the repolarization percentage of
            % interest.
            
            apdPct = 0.80;
            vAPDRange = [0.55, 0.45, 0.35, 0.25, 0.15];
            tAPDRange = [0.10, 0.50, 0.51, 0.52, 0.51];
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            
            % Verify the correct exception has been thrown.
            testCase.verifyError(@()testPeakData.calcPeakAttr(apdPct, tAPDRange, vAPDRange), 'MATLAB:calcPeakAttr:scaledVoltageOutOfRange');
        end
        
        function calcDifference_valid(testCase)
            % CALCDIFFERENCE_VALID Repolarization difference - Verify the difference
            % between the a90 and a50 attributes.
            
            a90 = 0.50;
            a50 = 0.10;
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            actualDifference = round(testPeakData.calcDifference(a90, a50), 4);
            
            % Verif the correct difference.
            verifyEqual(testCase, actualDifference, 0.4000);
        end
        
        function calcDifference_emptyA90(testCase)
            % CALCDIFFERENCE_EMPTYA90 Empty apd - verify the a90 - a50 difference
            % produces a an empty result when a blank a90 is present.
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            
            % Verify empty result.
            verifyEmpty(testCase, testPeakData.calcDifference([], 0.10));
        end
        
        function calcDifference_emptyA50(testCase)
            % CALCDIFFERENCE_EMPTYA50 Empty apd - verify the a90 - a50 difference
            % produces a an empty result when a blank a50 is present.
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            
            % Verify empty result.
            verifyEmpty(testCase, testPeakData.calcDifference(0.10, []));
        end
        
        function calcDifference_a50GreaterA90(testCase)
            % CALCDIFFERENCE_A50GREATERA90 Incorrect relationship - verify
            % the a90 - a50 difference produces an empty result when a50 > a90.
            
            a90 = 0.50;
            a50 = 0.60;
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            actualRatio = round(testPeakData.calcDifference(a90, a50), 4);
            
            % Verify empty result.
            verifyEmpty(testCase, actualRatio)
        end
        
        function calcRatio_valid(testCase)
            % CALCRATIO_VALID Repolarization ratio - verify the ratio between
            % the a50 and a90 repolarization time measurements.
            
            a90 = 0.50;
            a50 = 0.10;
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            actualRatio = round(testPeakData.calcRatio(a90, a50), 4);
            
            % Verify the correct result.
            verifyEqual(testCase, actualRatio, 0.2000);
        end
        
        function calcRatio_emptyA90(testCase)
            % CALCRATIO_EMPTYA90 Empty apd - verify the a90 / a50 ratio
            % produces a  an empty result when a blank a90 is present.
            
            a50 = 0.10;
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            
            % Verify empty result
            verifyEmpty(testCase, testPeakData.calcRatio([], a50));
        end
        
        function calcRatio_emptyA50(testCase)
            % CALCRATIO_EMPTYA50 Empty apd - verify the a90 / a50
            % difference produces an empty result when a blank a50 is present.
            
            a90 = 0.10;
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            
            % Verify empty result
            verifyEmpty(testCase, testPeakData.calcRatio(a90, []));
        end
        
        function calcFrac_valid(testCase)
            % CALCFRAC_VALID Fractional repolarization - verify the
            % the correct fractional calculation.
            
            a80 = 0.40;
            a30 = 0.10;
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            actualFrac = round(testPeakData.calcFrac(a80, a30), 4);
            
            % Verify the the correct calculation.
            verifyEqual(testCase, actualFrac, 0.7500);
        end
        
        function calcFrac_emptyA80(testCase)
            % CALCFRAC_EMPTYA80 Empty apd - verify an empty frac is
            % calculated when a blank a80 is present.
            
            a30 = 0.10;
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            actualRatio = round(testPeakData.calcFrac([], a30), 4);
            
            % Verify an empty result.
            verifyEmpty(testCase, actualRatio);
        end
        
        function calcFrac_emptyA30(testCase)
            % CALCFRAC_EMPTYA30 Empty apd - verify an empty frac
            % is created when a blank a30 is present.
            
            a80 = 0.80;
            
            % Initialize a peakData objet with blank attributes.
            testPeakData = segmentation.model.peakData([], []);
            actualRatio = round(testPeakData.calcFrac(a80, []), 4);
            
            % Verify an empty result.
            verifyEmpty(testCase, actualRatio);
        end
        
        function peakData_teePeeWaveform_valid(testCase)
            % PEAKDATA_TEEPEEWAVEFORM_VALID TeePee waveform - Verify the repolarization
            % attributes for a waveform shaped like a teepee.  Each repolarization percentage
            % has an actual 'time' value. No simple linear interpolation is required.
            
            % The Teepee waveform will be used - no need to provide waveform attributes.
            waveform = segmentation.test.functions.waveformGenerator();
            [waveformTime, waveformVoltage] = waveform.singleTeepee;
            
            % Initialize a peakData with the teepee x (time) and y (voltage) vectors.
            testPeakData = segmentation.model.peakData(waveformTime, waveformVoltage);
            
            % Verify the time value at each repolarization phase.
            verifyEqual(testCase, round(testPeakData.a20, 4), 2.000); % 20% repolarization - 80% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a30, 4), 3.000); % 30% repolarization - 70% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a40, 4), 4.000); % 40% repolarization - 60% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a50, 4), 5.000); % 50% repolarization - 50% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a60, 4), 6.000); % 60% repolarization - 40% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a70, 4), 7.000); % 70% repolarization - 30% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a80, 4), 8.000); % 80% repolarization - 20% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a90, 4), 9.000); % 90% repolarization - 10% of the waveform after the peak remains.
            
            % Verify auxillary calculations
            verifyEqual(testCase, round(testPeakData.apdRatio, 4), 0.5556);
            verifyEqual(testCase, round(testPeakData.apdDiff, 4), 4.000);
            verifyEqual(testCase, round(testPeakData.triang, 4), 5.000);
            verifyEqual(testCase, round(testPeakData.frac, 4), 0.6250);
        end
        
        function peakData_verticalLine_valid(testCase)
            % peakData_verticalLine_valid Vertical line - verify the repolarization
            % attributes for a waveform that is represented by a verticle line.
            % The repolarization voltage is controlled by the y-value (voltage)
            % which is equal to 0. Each repolarization percentage and attribute
            % calculation will be equal to zero, except for the APDRatio - which
            % will be equal to NaN (division by zero).
            
            % A verticle line.
            waveformTime = zeros(1, 201);
            waveformVoltage = (0:0.005:1.000);
            
            % Initialize a peakData object.
            testPeakData = segmentation.model.peakData(waveformTime, waveformVoltage);
            
            % Verify the time value at each repolarization phase.
            verifyEqual(testCase, round(testPeakData.a20, 4), 0.000); % 20% repolarization - 80% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a30, 4), 0.000); % 30% repolarization - 70% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a40, 4), 0.000); % 40% repolarization - 60% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a50, 4), 0.000); % 50% repolarization - 50% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a60, 4), 0.000); % 60% repolarization - 40% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a70, 4), 0.000); % 70% repolarization - 30% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a80, 4), 0.000); % 80% repolarization - 20% of the waveform after the peak remains.
            verifyEqual(testCase, round(testPeakData.a90, 4), 0.000); % 90% repolarization - 10% of the waveform after the peak remains.
            
            % Verify auxillary calculations
            verifyEqual(testCase, round(testPeakData.apdRatio, 4), NaN);
            verifyEqual(testCase, round(testPeakData.apdDiff, 4), []);
            verifyEqual(testCase, round(testPeakData.triang, 4), []);
            verifyEqual(testCase, round(testPeakData.frac, 4), []);
        end
        
        function peakData_horizontalLine_valid(testCase)
            % PEAKDATA_HORIZONTALLINE_VALID Horizontal line - verify the repolarization
            % attributes for a waveform that is represented by a horizontal
            % line.  No repolarization will take place; therefore, each percentage
            % and attribute will be empty.
            
            % A horizontal line - no repolarization.
            waveformTime = (0:0.0500:10);
            waveformVoltage = ones(1, 201);
            
            % Initialize a peakData object.
            testPeakData = segmentation.model.peakData(waveformTime, waveformVoltage);
            
            % Verify the time value at each repolarization phase.
            verifyEmpty(testCase, testPeakData.a20); % 20% repolarization - 80% of the waveform after the peak remains.
            verifyEmpty(testCase, testPeakData.a30); % 30% repolarization - 70% of the waveform after the peak remains.
            verifyEmpty(testCase, testPeakData.a40); % 40% repolarization - 60% of the waveform after the peak remains.
            verifyEmpty(testCase, testPeakData.a50); % 50% repolarization - 50% of the waveform after the peak remains.
            verifyEmpty(testCase, testPeakData.a60); % 60% repolarization - 40% of the waveform after the peak remains.
            verifyEmpty(testCase, testPeakData.a70); % 70% repolarization - 30% of the waveform after the peak remains.
            verifyEmpty(testCase, testPeakData.a80); % 80% repolarization - 20% of the waveform after the peak remains.
            verifyEmpty(testCase, testPeakData.a90); % 90% repolarization - 10% of the waveform after the peak remains.
            
            % Verify auxillary calculations
            verifyEmpty(testCase, testPeakData.apdRatio);
            verifyEmpty(testCase, testPeakData.apdDiff);
            verifyEmpty(testCase, testPeakData.triang);
            verifyEmpty(testCase, testPeakData.frac);
        end
    end
end