classdef experimentTest < matlab.unittest.TestCase
    % experimentTest - Test class for the experiment.m object file.  There
    % are two aspects of this class that were not tested and require
    % additional investigation on how to mock the behaviors.
    %     [1] How to mock behaviors within signalQC_f and
    %     segmentationBasicStats_f.  Both of these functions produce the
    %     user interface and require the use of uiwaits.
    %
    % Author:  Jonathan Cook
    % Created: 2018-07-10
    
    properties
        % Temporary files that will be deleted in the classTearDown
        % function.
        
        tempFile
    end
    
    methods(TestMethodTeardown)
        function classTearDown(testCase)
            % CLASSTEARDOWN - Execute after every test method to remove any
            % temp file that has been created.  If this is not executed,
            % the temp file system may become cluttered.
            
            % Delete the temporary files - just in case it is not deleted by
            % the operating system or within the test itself.
            if(~isempty(testCase.tempFile))
                for i=1:length(testCase.tempFile)
                    delete(testCase.tempFile(i));
                end
            end
            
            % Reset to blank.
            testCase.tempFile = "";
        end
    end
    
    methods(Test)
        function validatePeakData_allAttribuesEmpty_false(testCase)
            % VALIDATEPEAKDATA_ALLATTRIBUESEMPTY_FALSE False status - validate
            % a false status will be returned since all the attributes within peakData
            % are empty.
            
            peakDataToValidate = segmentation.model.peakData();
            
            % Verify false - all attribues in the peakData object are empty
            verifyFalse(testCase, segmentation.model.experiments.validatePeakData(peakDataToValidate));
        end
        
        function validatePeakData_partialAttribuesEmpty_false(testCase)
            % VALIDATEPEAKDATA_PARTIALATTRIBUESEMPTY_FALSE False status - validate
            % a false status will be returned - not all of the attributes have a
            % value.  Partial completion = invalid.
            
            peakDataToValidate = segmentation.model.peakData();
            peakDataToValidate.a20 = 1;
            peakDataToValidate.a30 = 1;
            peakDataToValidate.a40 = 1;
            peakDataToValidate.a50 = 1;
            peakDataToValidate.a60 = 1;
            peakDataToValidate.a70 = 1;
            
            % Verify false - partial attribues in the peakData object are empty
            verifyFalse(testCase, segmentation.model.experiments.validatePeakData(peakDataToValidate));
        end
        
        function validatePeakData_true(testCase)
            % VALIDATEPEAKDATA_TRUE True status - validate a true status will be returned
            % since all of the desired peakData attributes have been initialized.
            
            peakDataToValidate = segmentation.model.peakData();
            peakDataToValidate.a20 = 1;
            peakDataToValidate.a30 = 1;
            peakDataToValidate.a40 = 1;
            peakDataToValidate.a50 = 1;
            peakDataToValidate.a60 = 1;
            peakDataToValidate.a70 = 1;
            peakDataToValidate.a80 = 1;
            peakDataToValidate.a90 = 1;
            peakDataToValidate.apdRatio = 1;
            peakDataToValidate.apdDiff = 1;
            peakDataToValidate.triang = 1;
            peakDataToValidate.frac = 1;
            
            % Verify true - all desired attributes have a value.
            verifyTrue(testCase, segmentation.model.experiments.validatePeakData(peakDataToValidate));
        end
        
        function validateFieldData_allAttributesEmpty_false(testCase)
            % VALIDATEFIELDDATA_ALLATTRIBUTESEMPTY_FALSE False status - validate
            % a false status will be returned since all the attributes within fieldData
            % are empty.
            
            fieldToValidate = segmentation.model.fieldData();
            
            % Verify false - all attribues in the fieldData object are empty
            verifyFalse(testCase, segmentation.model.experiments.validateFieldData(fieldToValidate));
        end
        
        function validateFieldData_partialAttributesEmpty_false(testCase)
            % VALIDATEFIELDDATA_PARTIALATTRIBUTESEMPTY_FALSE False status - validate
            % a false status will be returned - not all of the attributes have a
            % value.  Partial completion = invalid.
            
            fieldToValidate = segmentation.model.fieldData();
            fieldToValidate.absAmplitude = 1;
            fieldToValidate.instantFrequency = 1;
            fieldToValidate.avgFrequency = 1;
            
            % Verify false - not all attribues in the fieldData object are populated.
            verifyFalse(testCase, segmentation.model.experiments.validateFieldData(fieldToValidate));
        end
        
        function validateFieldData_true(testCase)
            % VALIDATEFIELDDATA_TRUE True status - validate a true status will be returned
            % since all of the desired fieldData attributes have been initialized.
            
            fieldToValidate = segmentation.model.fieldData();
            fieldToValidate.absAmplitude = 1;
            fieldToValidate.instantFrequency = 1;
            fieldToValidate.avgFrequency = 1;
            fieldToValidate.slope = 1;
            
            % Verify false - not all attribues in the fieldData object are populated.
            verifyTrue(testCase, segmentation.model.experiments.validateFieldData(fieldToValidate));
        end
        
        function omitOutDataCount_singleOutData_nonInitializedOmit(testCase)
            % OMITOUTDATACOUNT_SINGLEOUTDATA_NONINITIALIZEDOMIT NaN Counts - Verify
            % the apOmitCount and fpOmitCount will be equal to NaN.  The outData
            % object did its omit statuses properly set to a 0 or 1.
            
            tempOutData = segmentation.model.outData();
            [actualAPOmitCount, actualFPOmitCount] = segmentation.model.experiments.omitOutDataCount(tempOutData);
            
            % Verify both ap and fp omit counts equal NaN.
            verifyEqual(testCase, actualAPOmitCount, NaN);
            verifyEqual(testCase, actualFPOmitCount, NaN);
        end
        
        function omitOutDataCount_multipleOutData_apOmitNotInit_fpOmitInit(testCase)
            % OMITOUTDATACOUNT_MULTIPLEOUTDATA_APOMITNOTINIT_FPOMITINIT
            % Verify omit counts with NaN - verify a NaN (not a number)
            % is returned for the apOmitCount.  The fpOmitCount equals 2.
            
            tempOutData(1) = segmentation.model.outData();
            tempOutData(2) = segmentation.model.outData();
            tempOutData(1).fpOmit = 1;
            tempOutData(2).apOmit = 0;
            tempOutData(2).fpOmit = 1;
            
            [actualAPOmitCount, actualFPOmitCount] = segmentation.model.experiments.omitOutDataCount(tempOutData);
            
            % Verify both ap and fp omit counts equal NaN.
            verifyEqual(testCase, actualAPOmitCount, NaN);
            verifyEqual(testCase, actualFPOmitCount, 2);
        end
        
        function omitOutDataCount_multipleOutData_apOmitInit_fpNotOmitInit(testCase)
            % OMITOUTDATACOUNT_MULTIPLEOUTDATA_APOMITINIT_FPNOTOMITINIT
            % Verify omit counts with NaN - verify a NaN (not a number)
            % is returned for the fpOmitCount.  The apOmitCount equals 2.
            
            tempOutData(1) = segmentation.model.outData();
            tempOutData(2) = segmentation.model.outData();
            tempOutData(1).apOmit = 1;
            tempOutData(2).apOmit = 1;
            tempOutData(2).fpOmit = 0;
            
            [actualAPOmitCount, actualFPOmitCount] = segmentation.model.experiments.omitOutDataCount(tempOutData);
            
            % Verify both ap and fp omit counts equal NaN.
            verifyEqual(testCase, actualAPOmitCount, 2);
            verifyEqual(testCase, actualFPOmitCount, NaN);
        end
        
        function omitOutDataCount_multipleOutData_apOmitInit_fpOmitInit(testCase)
            % OMITOUTDATACOUNT_MULTIPLEOUTDATA_APOMITINIT_FPOMITINIT
            % Verify omit counts - verify fpOmitCount equals 1 and
            % apOmitCount equals 1.
            
            tempOutData(1) = segmentation.model.outData();
            tempOutData(2) = segmentation.model.outData();
            tempOutData(1).apOmit = 1;
            tempOutData(1).fpOmit = 0;
            tempOutData(2).apOmit = 0;
            tempOutData(2).fpOmit = 1;
            
            [actualAPOmitCount, actualFPOmitCount] = segmentation.model.experiments.omitOutDataCount(tempOutData);
            
            % Verify both ap and fp omit counts equal NaN.
            verifyEqual(testCase, actualAPOmitCount, 1);
            verifyEqual(testCase, actualFPOmitCount, 1);
        end
        
        function omitOutDataCount_multipleOutData_bothNonOmit(testCase)
            % OMITOUTDATACOUNT_MULTIPLEOUTDATA_BOTHNONOMIT
            % Verify omit counts - verify fpOmitCount equals 0 and
            % apOmitCount equals 0.
            
            tempOutData(1) = segmentation.model.outData();
            tempOutData(2) = segmentation.model.outData();
            tempOutData(1).apOmit = 0;
            tempOutData(1).fpOmit = 0;
            tempOutData(2).apOmit = 0;
            tempOutData(2).fpOmit = 0;
            
            [actualAPOmitCount, actualFPOmitCount] = segmentation.model.experiments.omitOutDataCount(tempOutData);
            
            % Verify both ap and fp omit counts equal NaN.
            verifyEqual(testCase, actualAPOmitCount, 0);
            verifyEqual(testCase, actualFPOmitCount, 0);
        end
        
        function processCSVFileName_validH5(testCase)
            % PROCESSCSVFILENAME_VALIDH5 Valid .h5 file - verify two file names
            % will be generated with 'today's date.  One file name will contain
            % a 'fp' and one will contain 'ap'.
            
            fileName = 'test_wmd.h5';
            actualFileNames = segmentation.model.experiments.processCSVFileName(fileName);
            
            % Verify the correct file names have been produced for action potential
            % and field potential.
            verifyEqual(testCase, actualFileNames.actionPotentialCSV, ['test_ap_processed_', date, '.csv']);
            verifyEqual(testCase, actualFileNames.fieldPotentialCSV, ['test_fp_processed_', date, '.csv']);
        end
        
        function processCSVFileName_validMAT(testCase)
            % PROCESSCSVFILENAME_VALIDMAT Valid .mat file - verify only
            % a single file name will be generated for the action potential.
            % When processing a .mat file - the use case is for old vs. new
            % model conversion.  Field potentials will never be converted.
            
            fileName = 'test_processed.mat';
            actualFileName = segmentation.model.experiments.processCSVFileName(fileName);
            
            % Verify the correct file names have been produced for action potential
            % and field potential.
            verifyEqual(testCase, actualFileName.actionPotentialCSV, ['test_processed_ap_converted_', date, '.csv']);
        end
        
        function processCSVActionPotential_withEmptyPeakData(testCase)
            % PROCESSCSVACTIONPOTENTIAL_WITHEMPTYPEAKDATA Action potential
            % data with invalid peakData - verify a single
            % record will be produced provided two records are available.
            % One of the two results does not have peakData, and one does.
            
            testFileName = 'test_M123456_wmd.h5';
            testBatchName = 'M123456';
            
            % Create outData object.
            wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            wellElectrode = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            tempOutData = segmentation.model.outData(1, 1, 1, 1, 1, wellElectrode);
            tempOutData.apLeftCursorLoc = 50;
            tempOutData.apRightCursorLoc = 51;
            
            % Create two apdData objects.  The reason the absAmplitude
            % attribute is manually set is due to the minimum voltage after
            % the peak has not been identified - there is no peak.
            tempAPDData(1) = segmentation.model.apdData(1, 1, 1, 1, 1);
            tempAPDData(1).absAmplitude = 1;
            tempAPDData(2).attenuation = 0;
            tempAPDData(2) = segmentation.model.apdData(2, 1, 1, 1, 1);
            tempAPDData(2).absAmplitude = 1;
            tempAPDData(2).attenuation = 10;
            tempAPDData(2).cycleLength = 1.1;
            tempAPDData(2).instantFrequency = 20;
            tempAPDData(2).avgFrequency = 30;
            tempAPDData(2).diastolicInterval = 40;
            
            % Within the second apdData object - initialize a peakData
            % object.  Set the desired attributes to a value of 1.
            tempAPDData(2).peakData = segmentation.model.peakData(1, 1);
            tempAPDData(2).peakData.a20 = 2;
            tempAPDData(2).peakData.a30 = 3;
            tempAPDData(2).peakData.a40 = 4;
            tempAPDData(2).peakData.a50 = 5;
            tempAPDData(2).peakData.a60 = 6;
            tempAPDData(2).peakData.a70 = 7;
            tempAPDData(2).peakData.a80 = 8;
            tempAPDData(2).peakData.a90 = 9;
            tempAPDData(2).peakData.apdRatio = 10;
            tempAPDData(2).peakData.apdDiff = 11;
            tempAPDData(2).peakData.triang = 12;
            tempAPDData(2).peakData.frac = 13;
            
            % In the outData object - set the apdData array to the two
            % previously created apdData objects - one had an empty
            % peakData object and one has a non-empty peakData object.
            tempOutData.apdData = tempAPDData;
            
            actualFinalAPDToCsv = segmentation.model.experiments.processCSVActionPotential(testFileName, testBatchName, tempOutData);
            dim = size(actualFinalAPDToCsv);
            
            % Verify the content that will eventually be printed to csv.
            verifyEqual(testCase, dim(1), 1);
            verifyEqual(testCase, dim(2), 32);
            verifyEqual(testCase, actualFinalAPDToCsv{1,1}, 1); % Experiment
            verifyEqual(testCase, actualFinalAPDToCsv{1,2}, 0); % Well
            verifyEqual(testCase, actualFinalAPDToCsv{1,3}, 12); % Electrode
            verifyEqual(testCase, actualFinalAPDToCsv{1,4}, 2); % Peak Number
            verifyEqual(testCase, actualFinalAPDToCsv{1,5}, 1); % Amplitude
            verifyEqual(testCase, actualFinalAPDToCsv{1,6}, 2); % A20
            verifyEqual(testCase, actualFinalAPDToCsv{1,7}, 3); % A30
            verifyEqual(testCase, actualFinalAPDToCsv{1,8}, 4); % A40
            verifyEqual(testCase, actualFinalAPDToCsv{1,9}, 5); % A50
            verifyEqual(testCase, actualFinalAPDToCsv{1,10}, 6); % A60
            verifyEqual(testCase, actualFinalAPDToCsv{1,11}, 7); % A70
            verifyEqual(testCase, actualFinalAPDToCsv{1,12}, 8); % A80
            verifyEqual(testCase, actualFinalAPDToCsv{1,13}, 9); % A90
            verifyEqual(testCase, actualFinalAPDToCsv{1,14}, 10); % APDRatio
            verifyEqual(testCase, actualFinalAPDToCsv{1,15}, 11); % APDDiff
            verifyEqual(testCase, actualFinalAPDToCsv{1,16}, 12); % Triangulation
            verifyEqual(testCase, actualFinalAPDToCsv{1,17}, 13); % Fractional Repolarization
            verifyEqual(testCase, actualFinalAPDToCsv{1,18}, 10); % Attenuation
            verifyEqual(testCase, actualFinalAPDToCsv{1,19}, 1.1); % Cycle length
            verifyEqual(testCase, actualFinalAPDToCsv{1,20}, 20); % Instantaneous Frequency
            verifyEqual(testCase, actualFinalAPDToCsv{1,21}, 30); % Average Frequency
            verifyEqual(testCase, actualFinalAPDToCsv{1,22}, 40); % Diastolic Interval
            verifyEqual(testCase, actualFinalAPDToCsv{1,23}, "No Medication"); % Medication Name
            verifyEqual(testCase, actualFinalAPDToCsv{1,24}, "No Concentration"); % Medication Concentration
            verifyEqual(testCase, actualFinalAPDToCsv{1,25}, 1); % Peak Time
            verifyEqual(testCase, actualFinalAPDToCsv{1,26}, 1); % Start Time
            verifyEqual(testCase, actualFinalAPDToCsv{1,27}, 1); % Stop Time
            verifyEqual(testCase, actualFinalAPDToCsv{1,28}, 50); % AP Left Cursor Position
            verifyEqual(testCase, actualFinalAPDToCsv{1,29}, 51); % AP Right Cursor Position
            verifyEqual(testCase, actualFinalAPDToCsv{1,30}, 'test_M123456_wmd.h5'); % Original File Name
            verifyEqual(testCase, actualFinalAPDToCsv{1,31}, 'M123456'); % Batch Name
            verifyEqual(testCase, actualFinalAPDToCsv{1,32}, '2.5.0'); % Version
        end
        
        function processCSVActionPotential_withNoEmptyPeakData(testCase)
            % PROCESSCSVACTIONPOTENTIAL_WITHNOEMPTYPEAKDATA Action potential
            % data with no invalid peakData object- verify two records will
            % be produced.
            
            testFileName = 'test_M123456_wmd.h5';
            testBatchName = 'M123456';
            
            % Create outData object.
            wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            wellElectrode = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            tempOutData = segmentation.model.outData(1, 1, 1, 1, 1, wellElectrode);
            tempOutData.apLeftCursorLoc = 50;
            tempOutData.apRightCursorLoc = 51;
            
            % Create two apdData objects.  The reason the absAmplitude
            % attribute is manually set is due to the minimum voltage after
            % the peak has not been identified - there is no peak.
            tempAPDData(1) = segmentation.model.apdData(1, 1, 1, 1, 1);
            tempAPDData(1).absAmplitude = 1;
            tempAPDData(1).attenuation = [];
            tempAPDData(1).cycleLength = 1.1;
            tempAPDData(1).instantFrequency = 20;
            tempAPDData(1).avgFrequency = 30;
            tempAPDData(1).diastolicInterval = [];
            
            tempAPDData(2) = segmentation.model.apdData(2, 1, 1, 1, 1);
            tempAPDData(2).absAmplitude = 1;
            tempAPDData(2).attenuation = -10;
            tempAPDData(2).cycleLength = 1.2;
            tempAPDData(2).instantFrequency = [];
            tempAPDData(2).avgFrequency = 300;
            tempAPDData(2).diastolicInterval = 400;
            
            % Within the first apdData object - initialize a peakData
            % object.  Set the desired attributes to a value of 1.
            tempAPDData(1).peakData = segmentation.model.peakData(1, 1);
            tempAPDData(1).peakData.a20 = 2;
            tempAPDData(1).peakData.a30 = 3;
            tempAPDData(1).peakData.a40 = 4;
            tempAPDData(1).peakData.a50 = 5;
            tempAPDData(1).peakData.a60 = 6;
            tempAPDData(1).peakData.a70 = 7;
            tempAPDData(1).peakData.a80 = 8;
            tempAPDData(1).peakData.a90 = 9;
            tempAPDData(1).peakData.apdRatio = 10;
            tempAPDData(1).peakData.apdDiff = 11;
            tempAPDData(1).peakData.frac = 12;
            tempAPDData(1).peakData.triang = 13;
            
            % Within the second apdData object - initialize a peakData
            % object.  Set the desired attributes to a value of 1.
            tempAPDData(2).peakData = segmentation.model.peakData(1, 1);
            tempAPDData(2).peakData.a20 = 20;
            tempAPDData(2).peakData.a30 = 30;
            tempAPDData(2).peakData.a40 = 40;
            tempAPDData(2).peakData.a50 = 50;
            tempAPDData(2).peakData.a60 = 60;
            tempAPDData(2).peakData.a70 = 70;
            tempAPDData(2).peakData.a80 = 80;
            tempAPDData(2).peakData.a90 = 90;
            tempAPDData(2).peakData.apdRatio = 100;
            tempAPDData(2).peakData.apdDiff = 110;
            tempAPDData(2).peakData.frac = 120;
            tempAPDData(2).peakData.triang = 130;
            
            % In the outData object - set the apdData array to the two
            % previously created apdData objects.
            tempOutData.apdData = tempAPDData;
            
            actualFinalAPDToCsv = segmentation.model.experiments.processCSVActionPotential(testFileName, testBatchName, tempOutData);
            dim = size(actualFinalAPDToCsv);
            
            % Verify the content that will eventually be printed to csv.
            verifyEqual(testCase, dim(1), 2);
            verifyEqual(testCase, dim(2), 32);
            verifyEqual(testCase, actualFinalAPDToCsv{1,1}, 1); % Experiment
            verifyEqual(testCase, actualFinalAPDToCsv{1,2}, 0); % Well
            verifyEqual(testCase, actualFinalAPDToCsv{1,3}, 12); % Electrode
            verifyEqual(testCase, actualFinalAPDToCsv{1,4}, 1); % Peak Number
            verifyEqual(testCase, actualFinalAPDToCsv{1,5}, 1); % Amplitude
            verifyEqual(testCase, actualFinalAPDToCsv{1,6}, 2); % A20
            verifyEqual(testCase, actualFinalAPDToCsv{1,7}, 3); % A30
            verifyEqual(testCase, actualFinalAPDToCsv{1,8}, 4); % A40
            verifyEqual(testCase, actualFinalAPDToCsv{1,9}, 5); % A50
            verifyEqual(testCase, actualFinalAPDToCsv{1,10}, 6); % A60
            verifyEqual(testCase, actualFinalAPDToCsv{1,11}, 7); % A70
            verifyEqual(testCase, actualFinalAPDToCsv{1,12}, 8); % A80
            verifyEqual(testCase, actualFinalAPDToCsv{1,13}, 9); % A90
            verifyEqual(testCase, actualFinalAPDToCsv{1,14}, 10); % APDRatio
            verifyEqual(testCase, actualFinalAPDToCsv{1,15}, 11); % APDDiff
            verifyEqual(testCase, actualFinalAPDToCsv{1,16}, 13); % Triangulation
            verifyEqual(testCase, actualFinalAPDToCsv{1,17}, 12); % Fractional repolarization
            verifyEqual(testCase, actualFinalAPDToCsv{1,18}, NaN); % Attenuation
            verifyEqual(testCase, actualFinalAPDToCsv{1,19}, 1.1); % Cycle length
            verifyEqual(testCase, actualFinalAPDToCsv{1,20}, 20); % Instantaneous Frequency
            verifyEqual(testCase, actualFinalAPDToCsv{1,21}, 30); % Average Frequency
            verifyEqual(testCase, actualFinalAPDToCsv{1,22}, NaN); % Diastolic Interval
            verifyEqual(testCase, actualFinalAPDToCsv{1,23}, "No Medication"); % Medication Name
            verifyEqual(testCase, actualFinalAPDToCsv{1,24}, "No Concentration"); % Medication Concentration
            verifyEqual(testCase, actualFinalAPDToCsv{1,25}, 1); % Peak Time
            verifyEqual(testCase, actualFinalAPDToCsv{1,26}, 1); % Start Time
            verifyEqual(testCase, actualFinalAPDToCsv{1,27}, 1); % Stop Time
            verifyEqual(testCase, actualFinalAPDToCsv{1,28}, 50); % AP Left Cursor Position
            verifyEqual(testCase, actualFinalAPDToCsv{1,29}, 51); % AP Right Cursor Position
            verifyEqual(testCase, actualFinalAPDToCsv{1,30}, 'test_M123456_wmd.h5'); % Original File Name
            verifyEqual(testCase, actualFinalAPDToCsv{1,31}, 'M123456'); % Batch Name
            verifyEqual(testCase, actualFinalAPDToCsv{1,32}, '2.5.0'); % Version
            
            verifyEqual(testCase, actualFinalAPDToCsv{2,1}, 1); % Experiment
            verifyEqual(testCase, actualFinalAPDToCsv{2,2}, 0); % Well
            verifyEqual(testCase, actualFinalAPDToCsv{2,3}, 12); % Electrode
            verifyEqual(testCase, actualFinalAPDToCsv{2,4}, 2); % Peak Number
            verifyEqual(testCase, actualFinalAPDToCsv{2,5}, 1); % Amplitude
            verifyEqual(testCase, actualFinalAPDToCsv{2,6}, 20); % A20
            verifyEqual(testCase, actualFinalAPDToCsv{2,7}, 30); % A30
            verifyEqual(testCase, actualFinalAPDToCsv{2,8}, 40); % A40
            verifyEqual(testCase, actualFinalAPDToCsv{2,9}, 50); % A50
            verifyEqual(testCase, actualFinalAPDToCsv{2,10}, 60); % A60
            verifyEqual(testCase, actualFinalAPDToCsv{2,11}, 70); % A70
            verifyEqual(testCase, actualFinalAPDToCsv{2,12}, 80); % A80
            verifyEqual(testCase, actualFinalAPDToCsv{2,13}, 90); % A90
            verifyEqual(testCase, actualFinalAPDToCsv{2,14}, 100); % APDRatio
            verifyEqual(testCase, actualFinalAPDToCsv{2,15}, 110); % APDDiff
            verifyEqual(testCase, actualFinalAPDToCsv{2,16}, 130); % Triangulation
            verifyEqual(testCase, actualFinalAPDToCsv{2,17}, 120); % Fractional repolarization
            verifyEqual(testCase, actualFinalAPDToCsv{2,18}, -10); % Attenuation
            verifyEqual(testCase, actualFinalAPDToCsv{2,19}, 1.2); % Attenuation
            verifyEqual(testCase, actualFinalAPDToCsv{2,20}, NaN); % Instantaneous Frequency
            verifyEqual(testCase, actualFinalAPDToCsv{2,21}, 300); % Average Frequency
            verifyEqual(testCase, actualFinalAPDToCsv{2,22}, 400); % Diastolic Interval
            verifyEqual(testCase, actualFinalAPDToCsv{2,23}, "No Medication"); % Medication Name
            verifyEqual(testCase, actualFinalAPDToCsv{2,24}, "No Concentration"); % Medication Concentration
            verifyEqual(testCase, actualFinalAPDToCsv{2,25}, 1); % Peak Time
            verifyEqual(testCase, actualFinalAPDToCsv{2,26}, 1); % Start Time
            verifyEqual(testCase, actualFinalAPDToCsv{2,27}, 1); % Stop Time
            verifyEqual(testCase, actualFinalAPDToCsv{2,28}, 50); % AP Left Cursor Position
            verifyEqual(testCase, actualFinalAPDToCsv{2,29}, 51); % AP Right Cursor Position
            verifyEqual(testCase, actualFinalAPDToCsv{2,30}, 'test_M123456_wmd.h5'); % Original File Name
            verifyEqual(testCase, actualFinalAPDToCsv{2,31}, 'M123456'); % Batch Name
            verifyEqual(testCase, actualFinalAPDToCsv{2,32}, '2.5.0'); % Version
        end
        
        function processCSVFieldPotential_withEmptyFieldData(testCase)
            % PROCESSCSVFIELDPOTENTIAL_WITHEMPTYFIELDDATA Field potential
            % data with invalid fieldData - verify a single
            % record will be produced provided two records are available.
            % One of the two results does not have all of the necessary
            % fieldData attributes, and one does.
            
            testFileName = 'test_M123456_wmd.h5';
            testBatchName = 'M123456';
            
            % Create outData object.
            wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            wellElectrode = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            tempOutData = segmentation.model.outData(1, 1, 1, 1, 1, wellElectrode);
            tempOutData.fpLeftCursorLoc = 50;
            tempOutData.fprightCursorLoc = 51;
            
            % First fieldData's attributes not completely populated.
            tempFieldData(1) = segmentation.model.fieldData(1, 1, 1, 1, 1);
            
            % Second fieldData's attributes are completely populated.
            tempFieldData(2) = segmentation.model.fieldData(2, 1, 1, 1, 1);
            tempFieldData(2).peakVoltage = 2;
            tempFieldData(2).absAmplitude = 3;
            tempFieldData(2).instantFrequency = 4;
            tempFieldData(2).avgFrequency = 5;
            tempFieldData(2).slope = -6;
            tempFieldData(2).cycleLength= 1.1;
            
            % In the outData object - set the fieldData array to the two
            % previously created fieldData objects - one had an partial
            % completion of attributes and one with all attributed
            % populated.
            tempOutData.fieldData = tempFieldData;
            
            actualFinalFPToCsv = segmentation.model.experiments.processCSVFieldPotential(testFileName, testBatchName, tempOutData);
            dim = size(actualFinalFPToCsv);
            
            % Verify the content that will eventually be printed to csv.
            verifyEqual(testCase, dim(1), 1);
            verifyEqual(testCase, dim(2), 16);
            verifyEqual(testCase, actualFinalFPToCsv{1,1}, 1); % Experiment
            verifyEqual(testCase, actualFinalFPToCsv{1,2}, 0); % Well
            verifyEqual(testCase, actualFinalFPToCsv{1,3}, 12); % Electrode
            verifyEqual(testCase, actualFinalFPToCsv{1,4}, 2); % Peak Number
            verifyEqual(testCase, actualFinalFPToCsv{1,5}, 1); % Start Time
            verifyEqual(testCase, actualFinalFPToCsv{1,6}, 1); % Stop Time
            verifyEqual(testCase, actualFinalFPToCsv{1,7}, 1); % Peak Time
            verifyEqual(testCase, actualFinalFPToCsv{1,8}, 2); % Peak Voltage
            verifyEqual(testCase, actualFinalFPToCsv{1,9}, 3); % Amplitude
            verifyEqual(testCase, actualFinalFPToCsv{1,10}, 1.1); % Cycle length
            verifyEqual(testCase, actualFinalFPToCsv{1,11}, 4); % Instantaneous Frequency
            verifyEqual(testCase, actualFinalFPToCsv{1,12}, 5); % Average Frequency
            verifyEqual(testCase, actualFinalFPToCsv{1,13}, -6); % Slope
            verifyEqual(testCase, actualFinalFPToCsv{1,14}, 'test_M123456_wmd.h5'); % Original File Name
            verifyEqual(testCase, actualFinalFPToCsv{1,15}, 'M123456'); % Batch Name
            verifyEqual(testCase, actualFinalFPToCsv{1,16}, '2.5.0'); % Version
        end
        
        function processCSVFieldPotential_withNoEmptyFieldData(testCase)
            % PROCESSCSVFIELDPOTENTIAL_WITHNOEMPTYFIELDDATA Field potential data
            % - verify two fieldData object will be produced.  All objects have
            % their fieldData attributes populated.
            
            testFileName = 'test_M123456_wmd.h5';
            testBatchName = 'M123456';
            
            % Create outData object.
            wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            wellElectrode = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            tempOutData = segmentation.model.outData(1, 1, 1, 1, 1, wellElectrode);
            tempOutData.fpLeftCursorLoc = 50;
            tempOutData.fprightCursorLoc = 51;
            
            % First fieldData's attributes.
            tempFieldData(1) = segmentation.model.fieldData(1, 1, 1, 1, 1);
            tempFieldData(1).peakVoltage = 2;
            tempFieldData(1).absAmplitude = 3;
            tempFieldData(1).instantFrequency = 4;
            tempFieldData(1).avgFrequency = 5;
            tempFieldData(1).slope = -6;
            tempFieldData(1).cycleLength = 1.1;
            
            % Second fieldData's attributes.
            tempFieldData(2) = segmentation.model.fieldData(2, 1, 1, 1, 1);
            tempFieldData(2).peakVoltage = 20;
            tempFieldData(2).absAmplitude = 30;
            tempFieldData(2).instantFrequency = 40;
            tempFieldData(2).avgFrequency = 50;
            tempFieldData(2).slope = -60;
            tempFieldData(2).cycleLength = 1.2;
            
            % In the outData object - set the fieldData array to the two
            % previously created fieldData objects.
            tempOutData.fieldData = tempFieldData;
            
            actualFinalFPToCsv = segmentation.model.experiments.processCSVFieldPotential(testFileName, testBatchName, tempOutData);
            dim = size(actualFinalFPToCsv);
            
            % Verify the content that will eventually be printed to csv.
            verifyEqual(testCase, dim(1), 2);
            verifyEqual(testCase, dim(2), 16);
            verifyEqual(testCase, actualFinalFPToCsv{1,1}, 1); % Experiment
            verifyEqual(testCase, actualFinalFPToCsv{1,2}, 0); % Well
            verifyEqual(testCase, actualFinalFPToCsv{1,3}, 12); % Electrode
            verifyEqual(testCase, actualFinalFPToCsv{1,4}, 1); % Peak Number
            verifyEqual(testCase, actualFinalFPToCsv{1,5}, 1); % Start Time
            verifyEqual(testCase, actualFinalFPToCsv{1,6}, 1); % Stop Time
            verifyEqual(testCase, actualFinalFPToCsv{1,7}, 1); % Peak Time
            verifyEqual(testCase, actualFinalFPToCsv{1,8}, 2); % Peak Voltage
            verifyEqual(testCase, actualFinalFPToCsv{1,9}, 3); % Amplitude
            verifyEqual(testCase, actualFinalFPToCsv{1,10}, 1.1); % Cycle length
            verifyEqual(testCase, actualFinalFPToCsv{1,11}, 4); % Instantaneous Frequency
            verifyEqual(testCase, actualFinalFPToCsv{1,12}, 5); % Average Frequency
            verifyEqual(testCase, actualFinalFPToCsv{1,13}, -6); % Slope
            verifyEqual(testCase, actualFinalFPToCsv{1,14}, 'test_M123456_wmd.h5'); % Original File Name
            verifyEqual(testCase, actualFinalFPToCsv{1,15}, 'M123456'); % Batch Name
            verifyEqual(testCase, actualFinalFPToCsv{1,16}, '2.5.0'); % Version
            
            verifyEqual(testCase, actualFinalFPToCsv{2,1}, 1); % Experiment
            verifyEqual(testCase, actualFinalFPToCsv{2,2}, 0); % Well
            verifyEqual(testCase, actualFinalFPToCsv{2,3}, 12); % Electrode
            verifyEqual(testCase, actualFinalFPToCsv{2,4}, 2); % Peak Number
            verifyEqual(testCase, actualFinalFPToCsv{2,5}, 1); % Start Time
            verifyEqual(testCase, actualFinalFPToCsv{2,6}, 1); % Stop Time
            verifyEqual(testCase, actualFinalFPToCsv{2,7}, 1); % Peak Time
            verifyEqual(testCase, actualFinalFPToCsv{2,8}, 20); % Peak Voltage
            verifyEqual(testCase, actualFinalFPToCsv{2,9}, 30); % Amplitude
            verifyEqual(testCase, actualFinalFPToCsv{2,10}, 1.2); % Cycle length
            verifyEqual(testCase, actualFinalFPToCsv{2,11}, 40); % Instantaneous Frequency
            verifyEqual(testCase, actualFinalFPToCsv{2,12}, 50); % Average Frequency
            verifyEqual(testCase, actualFinalFPToCsv{2,13}, -60); % Slope
            verifyEqual(testCase, actualFinalFPToCsv{2,14}, 'test_M123456_wmd.h5'); % Original File Name
            verifyEqual(testCase, actualFinalFPToCsv{2,15}, 'M123456'); % Batch Name
            verifyEqual(testCase, actualFinalFPToCsv{2,16}, '2.5.0'); % Version
        end
        
        function writeResults_valid(testCase)
            % WRITERESULTS_VALID Action and field potential CSV - verify two .csv are created,
            % one for field potential and one for action potential.  Verify the contents of both
            % .csvs.
            
            % Scheme to control temp files and their eventual deletion from the temp
            % directory.
            originalFileName = 'test_M123456';
            tempFileDirectory = tempdir;
            tempAPFileName = [originalFileName '_ap_processed_' date '.csv'];
            tempFPFileName = [originalFileName '_fp_processed_' date '.csv'];
            
            % Assign the temp files to the tempFile property.  The classTearDown method will automatically
            % remove the files
            fullyQualifiedTempFile1 = convertCharsToStrings([tempFileDirectory, tempAPFileName]);
            fullyQualifiedTempFile2 = convertCharsToStrings([tempFileDirectory, tempFPFileName]);
            testCase.tempFile = [fullyQualifiedTempFile1, fullyQualifiedTempFile2];
            
            % Create outData object.
            wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            wellElectrode = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            tempOutData = segmentation.model.outData(1, 1, 1, 1, 1, wellElectrode);
            tempOutData.apLeftCursorLoc = 50;
            tempOutData.apRightCursorLoc = 51;
            tempOutData.fpLeftCursorLoc = 40;
            tempOutData.fprightCursorLoc = 41;
            
            % Create two apdData objects.  The reason the absAmplitude
            % attribute is manually set is due to the minimum voltage after
            % the peak has not been identified - there is no peak.
            tempAPDData(1) = segmentation.model.apdData(1, 1, 1, 1, 1);
            tempAPDData(1).absAmplitude = 1;
            tempAPDData(1).attenuation = [];
            tempAPDData(1).instantFrequency = 20;
            tempAPDData(1).avgFrequency = 30;
            tempAPDData(1).diastolicInterval = [];
            
            tempAPDData(2) = segmentation.model.apdData(2, 1, 1, 1, 1);
            tempAPDData(2).absAmplitude = 1;
            tempAPDData(2).attenuation = -10;
            tempAPDData(2).instantFrequency = [];
            tempAPDData(2).avgFrequency = 300;
            tempAPDData(2).diastolicInterval = 400;
            
            % Within the first apdData object - initialize a peakData
            % object.  Set the desired attributes to a value of 1.
            tempAPDData(1).peakData = segmentation.model.peakData(1, 1);
            tempAPDData(1).peakData.a20 = 2;
            tempAPDData(1).peakData.a30 = 3;
            tempAPDData(1).peakData.a40 = 4;
            tempAPDData(1).peakData.a50 = 5;
            tempAPDData(1).peakData.a60 = 6;
            tempAPDData(1).peakData.a70 = 7;
            tempAPDData(1).peakData.a80 = 8;
            tempAPDData(1).peakData.a90 = 9;
            tempAPDData(1).peakData.apdRatio = 10;
            tempAPDData(1).peakData.apdDiff = 11;
            tempAPDData(1).peakData.triang = 12;
            tempAPDData(1).peakData.frac = 13;
            
            % Within the second apdData object - initialize a peakData
            % object.  Set the desired attributes to a value of 1.
            tempAPDData(2).peakData = segmentation.model.peakData(1, 1);
            tempAPDData(2).peakData.a20 = 20;
            tempAPDData(2).peakData.a30 = 30;
            tempAPDData(2).peakData.a40 = 40;
            tempAPDData(2).peakData.a50 = 50;
            tempAPDData(2).peakData.a60 = 60;
            tempAPDData(2).peakData.a70 = 70;
            tempAPDData(2).peakData.a80 = 80;
            tempAPDData(2).peakData.a90 = 90;
            tempAPDData(2).peakData.apdRatio = 100;
            tempAPDData(2).peakData.apdDiff = 110;
            tempAPDData(2).peakData.triang = 120;
            tempAPDData(2).peakData.frac = 130;
            
            % First fieldData's attributes.
            tempFieldData(1) = segmentation.model.fieldData(1, 1, 1, 1, 1);
            tempFieldData(1).peakVoltage = 2;
            tempFieldData(1).absAmplitude = 3;
            tempFieldData(1).instantFrequency = 4;
            tempFieldData(1).avgFrequency = 5;
            tempFieldData(1).slope = -6;
            
            % Second fieldData's attributes.
            tempFieldData(2) = segmentation.model.fieldData(2, 1, 1, 1, 1);
            tempFieldData(2).peakVoltage = 20;
            tempFieldData(2).absAmplitude = 30;
            tempFieldData(2).instantFrequency = 40;
            tempFieldData(2).avgFrequency = 50;
            tempFieldData(2).slope = -60;
            
            % Assign the apdData and fieldData object arrays to outData.
            tempOutData.apdData = tempAPDData;
            tempOutData.fieldData = tempFieldData;
            
            % Write results to temp directory.
            segmentation.model.experiments.writeResults([tempFileDirectory originalFileName '_wmd.h5'], tempOutData)
            
            % Retrieve files.
            actualAPFile = importdata(testCase.tempFile(1));
            actualFPFile = importdata(testCase.tempFile(2));
            
            expectedAPData1 = strcat('1,0,12,1,1,2,3,4,5,6,7,8,9,10,11,12,13,NaN,NaN,20,30,NaN,No Medication,No Concentration,1,1,1,50,51,', [tempFileDirectory originalFileName, '_wmd.h5'], ',M123456,2.5.0');
            expectedAPData2 = strcat('1,0,12,2,1,20,30,40,50,60,70,80,90,100,110,120,130,-10,NaN,NaN,300,400,No Medication,No Concentration,1,1,1,50,51,', [tempFileDirectory originalFileName, '_wmd.h5'], ',M123456,2.5.0');
            
            expectedFPData1 = strcat('1,0,12,1,1,1,1,2,3,NaN,4,5,-6,', [tempFileDirectory originalFileName, '_wmd.h5'], ',M123456,2.5.0');
            expectedFPData2 = strcat('1,0,12,2,1,1,1,20,30,NaN,40,50,-60,', [tempFileDirectory originalFileName, '_wmd.h5'], ',M123456,2.5.0');
            
            % Verify results.
            verifyEqual(testCase, length(actualAPFile), 3);
            verifyEqual(testCase, actualAPFile(1), join(segmentation.model.experiments.apColumnNames, ","));
            verifyEqual(testCase, actualAPFile(2), {expectedAPData1});
            verifyEqual(testCase, actualAPFile(3), {expectedAPData2});
            
            verifyEqual(testCase, length(actualFPFile), 3);
            verifyEqual(testCase, actualFPFile(1), join(segmentation.model.experiments.fpColumnNames, ","));
            verifyEqual(testCase, actualFPFile(2), {expectedFPData1});
            verifyEqual(testCase, actualFPFile(3), {expectedFPData2});
        end
        
        function writeResults_apOmitTrue(testCase)
            % WRITERESULTS_APOMITTRUE Action and field potential CSV - verify a single .csv is created for
            % field potential.  Although there is action potential data available to be printed to .csv,
            % the apOmit status has been set to 1.  It should never be printed.
            
            % Scheme to control temp files and their eventual deletion from the temp
            % directory.
            originalFileName = 'test_M123456';
            tempFileDirectory = tempdir;
            tempAPFileName = [originalFileName '_ap_processed_' date '.csv'];
            tempFPFileName = [originalFileName '_fp_processed_' date '.csv'];
            
            % Assign the temp files to the tempFile property.  The classTearDown method will automatically
            % remove the files
            fullyQualifiedTempFile1 = convertCharsToStrings([tempFileDirectory, tempAPFileName]);
            fullyQualifiedTempFile2 = convertCharsToStrings([tempFileDirectory, tempFPFileName]);
            testCase.tempFile = [fullyQualifiedTempFile1, fullyQualifiedTempFile2];
            
            % Create outData object.
            wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            wellElectrode = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            tempOutData = segmentation.model.outData(1, 1, 1, 1, 1, wellElectrode);
            tempOutData.apLeftCursorLoc = 50;
            tempOutData.apRightCursorLoc = 51;
            tempOutData.apOmit = 1;
            tempOutData.fpLeftCursorLoc = 40;
            tempOutData.fprightCursorLoc = 41;
            
            % Create two apdData objects.  The reason the absAmplitude
            % attribute is manually set is due to the minimum voltage after
            % the peak has not been identified - there is no peak.
            tempAPDData(1) = segmentation.model.apdData(1, 1, 1, 1, 1);
            tempAPDData(1).absAmplitude = 1;
            tempAPDData(1).attenuation = [];
            tempAPDData(1).instantFrequency = 20;
            tempAPDData(1).avgFrequency = 30;
            tempAPDData(1).diastolicInterval = [];
            
            tempAPDData(2) = segmentation.model.apdData(2, 1, 1, 1, 1);
            tempAPDData(2).absAmplitude = 1;
            tempAPDData(2).attenuation = -10;
            tempAPDData(2).instantFrequency = [];
            tempAPDData(2).avgFrequency = 300;
            tempAPDData(2).diastolicInterval = 400;
            
            % Within the first apdData object - initialize a peakData
            % object.  Set the desired attributes to a value of 1.
            tempAPDData(1).peakData = segmentation.model.peakData(1, 1);
            tempAPDData(1).peakData.a20 = 2;
            tempAPDData(1).peakData.a30 = 3;
            tempAPDData(1).peakData.a40 = 4;
            tempAPDData(1).peakData.a50 = 5;
            tempAPDData(1).peakData.a60 = 6;
            tempAPDData(1).peakData.a70 = 7;
            tempAPDData(1).peakData.a80 = 8;
            tempAPDData(1).peakData.a90 = 9;
            tempAPDData(1).peakData.apdRatio = 10;
            tempAPDData(1).peakData.apdDiff = 11;
            
            % Within the second apdData object - initialize a peakData
            % object.  Set the desired attributes to a value of 1.
            tempAPDData(2).peakData = segmentation.model.peakData(1, 1);
            tempAPDData(2).peakData.a20 = 20;
            tempAPDData(2).peakData.a30 = 30;
            tempAPDData(2).peakData.a40 = 40;
            tempAPDData(2).peakData.a50 = 50;
            tempAPDData(2).peakData.a60 = 60;
            tempAPDData(2).peakData.a70 = 70;
            tempAPDData(2).peakData.a80 = 80;
            tempAPDData(2).peakData.a90 = 90;
            tempAPDData(2).peakData.apdRatio = 100;
            tempAPDData(2).peakData.apdDiff = 110;
            
            % First fieldData's attributes.
            tempFieldData(1) = segmentation.model.fieldData(1, 1, 1, 1, 1);
            tempFieldData(1).peakVoltage = 2;
            tempFieldData(1).absAmplitude = 3;
            tempFieldData(1).cycleLength = 3.1;
            tempFieldData(1).instantFrequency = 4;
            tempFieldData(1).avgFrequency = 5;
            tempFieldData(1).slope = -6;
            
            % Second fieldData's attributes.
            tempFieldData(2) = segmentation.model.fieldData(2, 1, 1, 1, 1);
            tempFieldData(2).peakVoltage = 20;
            tempFieldData(2).cycleLength = 3.2;
            tempFieldData(2).absAmplitude = 30;
            tempFieldData(2).instantFrequency = 40;
            tempFieldData(2).avgFrequency = 50;
            tempFieldData(2).slope = -60;
            
            % Assign the apdData and fieldData object arrays to outData.
            tempOutData.apdData = tempAPDData;
            tempOutData.fieldData = tempFieldData;
            
            % Write results to temp directory.
            segmentation.model.experiments.writeResults([tempFileDirectory originalFileName '_wmd.h5'], tempOutData)
            
            % Retrieve action potential files.
            try
                actualAPFile = importdata(testCase.tempFile(1));
            catch ME
                actualAPFile = [];
            end
            
            % Retreive field potential files.
            try
                actualFPFile = importdata(testCase.tempFile(2));
            catch ME
                actualFPFile = [];
            end
            
            expectedFPData1 = strcat('1,0,12,1,1,1,1,2,3,3.1,4,5,-6,', [tempFileDirectory originalFileName, '_wmd.h5'], ',M123456,2.5.0');
            expectedFPData2 = strcat('1,0,12,2,1,1,1,20,30,3.2,40,50,-60,', [tempFileDirectory originalFileName, '_wmd.h5'], ',M123456,2.5.0');
            
            % Verify results.
            verifyEmpty(testCase, actualAPFile);
            verifyEqual(testCase, length(actualFPFile), 3);
            verifyEqual(testCase, actualFPFile(1), join(segmentation.model.experiments.fpColumnNames, ","));
            verifyEqual(testCase, actualFPFile(2), {expectedFPData1});
            verifyEqual(testCase, actualFPFile(3), {expectedFPData2});
        end
        
        function writeResults_fpOmitTrue(testCase)
            % WRITERESULTS_FPOMITTRUE Action and field potential CSV - verify a single .csv is created for
            % action potential.  Although there is field potential data available to be printed to .csv,
            % the fpOmit status has been set to 1.  It should never be printed.
            
            % Scheme to control temp files and their eventual deletion from the temp
            % directory.
            originalFileName = 'test_M123456';
            tempFileDirectory = tempdir;
            tempAPFileName = [originalFileName '_ap_processed_' date '.csv'];
            tempFPFileName = [originalFileName '_fp_processed_' date '.csv'];
            
            % Assign the temp files to the tempFile property.  The classTearDown method will automatically
            % remove the files
            fullyQualifiedTempFile1 = convertCharsToStrings([tempFileDirectory, tempAPFileName]);
            fullyQualifiedTempFile2 = convertCharsToStrings([tempFileDirectory, tempFPFileName]);
            testCase.tempFile = [fullyQualifiedTempFile1, fullyQualifiedTempFile2];
            
            % Create outData object.
            wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            wellElectrode = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            tempOutData = segmentation.model.outData(1, 1, 1, 1, 1, wellElectrode);
            tempOutData.apLeftCursorLoc = 50;
            tempOutData.apRightCursorLoc = 51;
            tempOutData.fpLeftCursorLoc = 40;
            tempOutData.fprightCursorLoc = 41;
            tempOutData.fpOmit = 1;
            
            % Create two apdData objects.  The reason the absAmplitude
            % attribute is manually set is due to the minimum voltage after
            % the peak has not been identified - there is no peak.
            tempAPDData(1) = segmentation.model.apdData(1, 1, 1, 1, 1);
            tempAPDData(1).absAmplitude = 1;
            tempAPDData(1).attenuation = [];
            tempAPDData(1).cycleLength = 1.1;
            tempAPDData(1).instantFrequency = 20;
            tempAPDData(1).avgFrequency = 30;
            tempAPDData(1).diastolicInterval = [];
            
            tempAPDData(2) = segmentation.model.apdData(2, 1, 1, 1, 1);
            tempAPDData(2).absAmplitude = 1;
            tempAPDData(2).attenuation = -10;
            tempAPDData(2).cycleLength = 1.2;
            tempAPDData(2).instantFrequency = [];
            tempAPDData(2).avgFrequency = 300;
            tempAPDData(2).diastolicInterval = 400;
            
            % Within the first apdData object - initialize a peakData
            % object.  Set the desired attributes to a value of 1.
            tempAPDData(1).peakData = segmentation.model.peakData(1, 1);
            tempAPDData(1).peakData.a20 = 2;
            tempAPDData(1).peakData.a30 = 3;
            tempAPDData(1).peakData.a40 = 4;
            tempAPDData(1).peakData.a50 = 5;
            tempAPDData(1).peakData.a60 = 6;
            tempAPDData(1).peakData.a70 = 7;
            tempAPDData(1).peakData.a80 = 8;
            tempAPDData(1).peakData.a90 = 9;
            tempAPDData(1).peakData.apdRatio = 10;
            tempAPDData(1).peakData.apdDiff = 11;
            tempAPDData(1).peakData.triang = 12;
            tempAPDData(1).peakData.frac = 13;
            
            % Within the second apdData object - initialize a peakData
            % object.  Set the desired attributes to a value of 1.
            tempAPDData(2).peakData = segmentation.model.peakData(1, 1);
            tempAPDData(2).peakData.a20 = 20;
            tempAPDData(2).peakData.a30 = 30;
            tempAPDData(2).peakData.a40 = 40;
            tempAPDData(2).peakData.a50 = 50;
            tempAPDData(2).peakData.a60 = 60;
            tempAPDData(2).peakData.a70 = 70;
            tempAPDData(2).peakData.a80 = 80;
            tempAPDData(2).peakData.a90 = 90;
            tempAPDData(2).peakData.apdRatio = 100;
            tempAPDData(2).peakData.apdDiff = 110;
            tempAPDData(2).peakData.triang = 120;
            tempAPDData(2).peakData.frac = 130;
            
            % First fieldData's attributes.
            tempFieldData(1) = segmentation.model.fieldData(1, 1, 1, 1, 1);
            tempFieldData(1).peakVoltage = 2;
            tempFieldData(1).absAmplitude = 3;
            tempFieldData(1).instantFrequency = 4;
            tempFieldData(1).avgFrequency = 5;
            tempFieldData(1).slope = -6;
            
            % Second fieldData's attributes.
            tempFieldData(2) = segmentation.model.fieldData(2, 1, 1, 1, 1);
            tempFieldData(2).peakVoltage = 20;
            tempFieldData(2).absAmplitude = 30;
            tempFieldData(2).instantFrequency = 40;
            tempFieldData(2).avgFrequency = 50;
            tempFieldData(2).slope = -60;
            
            % Assign the apdData and fieldData object arrays to outData.
            tempOutData.apdData = tempAPDData;
            tempOutData.fieldData = tempFieldData;
            
            % Write results to temp directory.
            segmentation.model.experiments.writeResults([tempFileDirectory originalFileName '_wmd.h5'], tempOutData)
            
            % Retrieve action potential files.
            try
                actualAPFile = importdata(testCase.tempFile(1));
            catch ME
                actualAPFile = [];
            end
            
            % Retreive field potential files.
            try
                actualFPFile = importdata(testCase.tempFile(2));
            catch ME
                actualFPFile = [];
            end
            
            expectedAPData1 = strcat('1,0,12,1,1,2,3,4,5,6,7,8,9,10,11,12,13,NaN,1.1,20,30,NaN,No Medication,No Concentration,1,1,1,50,51,', [tempFileDirectory originalFileName, '_wmd.h5'], ',M123456,2.5.0');
            expectedAPData2 = strcat('1,0,12,2,1,20,30,40,50,60,70,80,90,100,110,120,130,-10,1.2,NaN,300,400,No Medication,No Concentration,1,1,1,50,51,', [tempFileDirectory originalFileName, '_wmd.h5'], ',M123456,2.5.0');
            
            % Verify results.
            verifyEqual(testCase, length(actualAPFile), 3);
            verifyEqual(testCase, actualAPFile(1), join(segmentation.model.experiments.apColumnNames, ","));
            verifyEqual(testCase, actualAPFile(2), {expectedAPData1});
            verifyEqual(testCase, actualAPFile(3), {expectedAPData2});
            verifyEmpty(testCase, actualFPFile);
        end
    end
end