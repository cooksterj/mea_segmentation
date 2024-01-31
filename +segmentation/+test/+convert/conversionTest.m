classdef conversionTest < matlab.unittest.TestCase
    % CONVERSIONTEST Test conditions to ensure attribute mappings are
    % correct between pre/post v1.0.  Test methods utilize the conversion_f
    % file.
    %
    % Author:  Jonathan Cook
    % Created: 2018-07-20
    
    properties
        tempFiles
        conversionHandles
    end
    
    % Initialization
    methods(TestClassSetup)
        function classSetup(testCase)
            % CLASSSETUP - Set the test case properties.
            
            testCase.conversionHandles = segmentation.convert.conversion_f;
        end
    end
    
    % Tear down
    methods(TestMethodTeardown)
        function classTearDown(testCase)
            % CLASSTEARDOWN Execute after every test method to remove any
            % temp file that has been created.  If this is not executed,
            % the temp file system may become cluttered.
            
            % Delete the temporary file - just incase it isn't deleted by
            % the operating system or within the test itself.
            if(~isempty(testCase.tempFiles))
                for i = 1:length(testCase.tempFiles)
                    delete(testCase.tempFiles(i));
                end
            end
            
            % Reset to blank.
            testCase.tempFiles = [];
            
            % To be safe - clear the workspace.
            clear;
        end
    end
    
    methods(Test)
        function convert_singleOldOutData_noOmit(testCase)
            % CONVERT_SINGLEOLDOUTDATA_NOOMIT Test to determine that the
            % conversion will result in a single array element in the
            % converted data structure, as well as a four records in the
            % .csv (header + three peaks).  The input structure has a single entry.
            
            % test/resource
            originalFileName = 'singleOldOutData_M123456_noOmit.mat';
            
            % Establish temp directory and files.
            tempFileDirectory = tempdir;
            tempFileNameCSV = ['singleOldOutData_M123456_noOmit_ap_converted_' date '.csv'];
            tempFileNameMat = ['singleOldOutData_M123456_noOmit_converted_' date '.mat'];
            
            % Save the established temp files to the class attribute - to
            % be used for deletion after the function completes.
            testCase.tempFiles = [convertCharsToStrings([tempFileDirectory, tempFileNameCSV]) ...
                convertCharsToStrings([tempFileDirectory, tempFileNameMat])];
            
            % Load the old structure.
            oldOutData = load([pwd, filesep, ...
                '+segmentation', filesep, ...
                '+test', filesep, ...
                '+resources', filesep, ...
                'singleOldOutData_M123456_noOmit.mat']);
            
            testCase.conversionHandles.convert(oldOutData.singleOldOutData_noOmit, originalFileName, tempFileDirectory);
            
            % Only one outData is required.
            wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            expectedWellElectrodeData = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            
            expectedOutData = segmentation.model.outData();
            expectedOutData.index = 1;
            expectedOutData.voltage = [10,20,30,40,50,60,70,80,90];
            expectedOutData.time = [0,5,6,7,8,9,10,11,12];
            expectedOutData.esub = [11,12,13,14,15,16];
            expectedOutData.experimentNum = 1;
            expectedOutData.wellElectrodeData = expectedWellElectrodeData;
            expectedOutData.apProcessed = 1;
            expectedOutData.apOmit = 0;
            expectedOutData.medicationName = 'No Medication';
            expectedOutData.medicationConcen = 'No Concentration';
            expectedOutData.apVoltageSegment = [10,15,20,25];
            expectedOutData.apTimeSegment = [1,2,3,4,5];
            expectedOutData.apLeftCursorLoc = 50;
            expectedOutData.apRightCursorLoc = 55;
            expectedOutData.apMeasGap = [];
            
            % Three apdData objects will be created.
            % First apdData
            expectedAPDData = segmentation.model.apdData();
            expectedAPDData(1).peakNum = 1;
            expectedAPDData(1).actionPotentialVoltage = [];
            expectedAPDData(1).actionPotentialTime = [];
            expectedAPDData(1).startTime = 50;
            expectedAPDData(1).stopTime = 51;
            expectedAPDData(1).peakTime = 52;
            expectedAPDData(1).peakVoltage = 53;
            expectedAPDData(1).absAmplitude = 54;
            expectedAPDData(1).timeScale = [1,2,3,4];
            expectedAPDData(1).voltageScale = [5,6,7,8];
            expectedAPDData(1).attenuation = [];
            
            % First peakData for the first apdData object.
            expectedPeakData = segmentation.model.peakData();
            expectedPeakData.apdRatio = 1;
            expectedPeakData.apdDiff = 1.5;
            expectedPeakData.triang = 0.1;
            expectedPeakData.frac = 0.11;
            expectedPeakData.a20 = 0.21;
            expectedPeakData.a30 = 0.31;
            expectedPeakData.a40 = 0.41;
            expectedPeakData.a50 = 0.51;
            expectedPeakData.a60 = 0.61;
            expectedPeakData.a70 = 0.71;
            expectedPeakData.a80 = 0.81;
            expectedPeakData.a90 = 0.91;
            expectedAPDData(1).peakData = expectedPeakData;
            
            % Second apdData.
            expectedAPDData(2).peakNum = 2;
            expectedAPDData(2).actionPotentialVoltage = [];
            expectedAPDData(2).actionPotentialTime = [];
            expectedAPDData(2).startTime = 60;
            expectedAPDData(2).stopTime = 61;
            expectedAPDData(2).peakTime = 62;
            expectedAPDData(2).peakVoltage = 63;
            expectedAPDData(2).absAmplitude = 64;
            expectedAPDData(2).timeScale = [5,6,7,8];
            expectedAPDData(2).voltageScale = [9,10,11,12];
            expectedAPDData(2).attenuation = 0.1;
            
            % Second peakData for the second apdData object.
            expectedPeakData.apdRatio = 2;
            expectedPeakData.apdDiff = 2.5;
            expectedPeakData.triang = 0.2;
            expectedPeakData.frac = 0.12;
            expectedPeakData.a20 = 0.22;
            expectedPeakData.a30 = 0.32;
            expectedPeakData.a40 = 0.42;
            expectedPeakData.a50 = 0.52;
            expectedPeakData.a60 = 0.62;
            expectedPeakData.a70 = 0.72;
            expectedPeakData.a80 = 0.82;
            expectedPeakData.a90 = 0.92;
            expectedAPDData(2).peakData = expectedPeakData;
            
            % Third apdData
            expectedAPDData(3).peakNum = 3;
            expectedAPDData(3).actionPotentialVoltage = [];
            expectedAPDData(3).actionPotentialTime = [];
            expectedAPDData(3).startTime = 70;
            expectedAPDData(3).stopTime = 71;
            expectedAPDData(3).peakTime = 72;
            expectedAPDData(3).peakVoltage = 73;
            expectedAPDData(3).absAmplitude = 74;
            expectedAPDData(3).timeScale = [9,10,11,12];
            expectedAPDData(3).voltageScale = [13,14,15,16];
            expectedAPDData(3).attenuation = 0.2;
            
            % Third peakData for the second apdData object.
            expectedPeakData.apdRatio = 3;
            expectedPeakData.apdDiff = 3.5;
            expectedPeakData.triang = 0.3;
            expectedPeakData.frac = 0.13;
            expectedPeakData.a20 = 0.23;
            expectedPeakData.a30 = 0.33;
            expectedPeakData.a40 = 0.43;
            expectedPeakData.a50 = 0.53;
            expectedPeakData.a60 = 0.63;
            expectedPeakData.a70 = 0.73;
            expectedPeakData.a80 = 0.83;
            expectedPeakData.a90 = 0.93;
            expectedAPDData(3).peakData = expectedPeakData;
            
            expectedOutData.apdData = expectedAPDData;
            
            actualConvertedCSV = importdata(testCase.tempFiles(1), ',');
            actualConvertedMAT = load(testCase.tempFiles(2));
            
            % Test CSV - the actual size should equal 4 due to the header
            % and three apdData waveforms.
            actualConvertedCSVSize = size(actualConvertedCSV);
            verifyEqual(testCase, actualConvertedCSVSize(1), 4);
            expectedCSVValue = 'expNum,well,elec,peakNum,absAmp,apd20,apd30,apd40,apd50,apd60,apd70,apd80,apd90,apdRatio,apdDiff,apdTriang,apdFrac,apdAtten,apdCycleLength,apdInstFreq,apdAvgFreq,apdDiastolicInter,medName,medConc,peakTime,apdStart,apdStop,leftCursor,rightCursor,fileName,batchName,version';
            verifyEqual(testCase, actualConvertedCSV(1), {expectedCSVValue});
            expectedCSVValue = strcat('1,0,12,1,54,0.21,0.31,0.41,0.51,0.61,0.71,0.81,0.91,1,1.5,0.1,0.11,NaN,NaN,NaN,NaN,NaN,No Medication,No Concentration,52,50,51,50,55,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(2), {expectedCSVValue});
            expectedCSVValue = strcat('1,0,12,2,64,0.22,0.32,0.42,0.52,0.62,0.72,0.82,0.92,2,2.5,0.2,0.12,0.1,NaN,NaN,NaN,NaN,No Medication,No Concentration,62,60,61,50,55,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(3), {expectedCSVValue});
            expectedCSVValue = strcat('1,0,12,3,74,0.23,0.33,0.43,0.53,0.63,0.73,0.83,0.93,3,3.5,0.3,0.13,0.2,NaN,NaN,NaN,NaN,No Medication,No Concentration,72,70,71,50,55,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(4), {expectedCSVValue});
            
            % Test MAT - there should only be a single record in the
            % outData array.
            verifyEqual(testCase, length(actualConvertedMAT.outDataStruct), 1);
            verifyEqual(testCase, actualConvertedMAT.outDataStruct.apdData(1), expectedOutData.apdData(1));
        end
        
        function convert_singleOldOutData_withSingleOmit(testCase)
            % CONVERT_SINGLEOLDOUTDATA_WITHSINGLEOMIT Test to determine
            % that the conversion will result in a two array elements in
            % the converted data structure, as well as a four records in
            % the .csv (header + three peaks).  The input structure has a two
            % entries, one with an omit status = 1 and one with an omit
            % status = 0.
            
            % test/resource
            originalFileName = 'singleOldOutData_M123456_withSingleOmit.mat';
            
            % Establish temp directory and files.
            tempFileDirectory = tempdir;
            tempFileNameCSV = ['singleOldOutData_M123456_withSingleOmit_ap_converted_', date, '.csv'];
            tempFileNameMat = ['singleOldOutData_M123456_withSingleOmit_converted_', date, '.mat'];
            
            % Save the established temp files to the class attribute - to
            % be used for deletion after the function completes.
            testCase.tempFiles = [convertCharsToStrings([tempFileDirectory, tempFileNameCSV]) ...
                convertCharsToStrings([tempFileDirectory, tempFileNameMat])];
            
            % Load the old structure.
            oldOutData = load([pwd, filesep, ...
                '+segmentation', filesep, ...
                '+test', filesep, ...
                '+resources', filesep, ...
                'singleOldOutData_M123456_withSingleOmit.mat']);
            
            testCase.conversionHandles.convert(oldOutData.singleOldOutData_withSingleOmit, originalFileName, tempFileDirectory);
            
            % Only one outData is required.
            wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            expectedWellElectrodeData = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            
            expectedOutData = segmentation.model.outData();
            expectedOutData(1).index = 1;
            expectedOutData(1).voltage = [10,20,30,40,50,60,70,80,90];
            expectedOutData(1).time = [0,5,6,7,8,9,10,11,12];
            expectedOutData(1).esub = [11,12,13,14,15,16];
            expectedOutData(1).experimentNum = 1;
            expectedOutData(1).wellElectrodeData = expectedWellElectrodeData;
            expectedOutData(1).apProcessed = 1;
            expectedOutData(1).apOmit = 0;
            expectedOutData(1).medicationName = 'No Medication';
            expectedOutData(1).medicationConcen = 'No Concentration';
            expectedOutData(1).apVoltageSegment = [10,15,20,25];
            expectedOutData(1).apTimeSegment = [1,2,3,4,5];
            expectedOutData(1).apLeftCursorLoc = 50;
            expectedOutData(1).apRightCursorLoc = 55;
            expectedOutData(1).apMeasGap = [];
            
            % First apdData
            expectedAPDData = segmentation.model.apdData();
            expectedAPDData(1).peakNum = 1;
            expectedAPDData(1).actionPotentialVoltage = [];
            expectedAPDData(1).actionPotentialTime = [];
            expectedAPDData(1).startTime = 50;
            expectedAPDData(1).stopTime = 51;
            expectedAPDData(1).peakTime = 52;
            expectedAPDData(1).peakVoltage = 53;
            expectedAPDData(1).absAmplitude = 54;
            expectedAPDData(1).timeScale = [1,2,3,4];
            expectedAPDData(1).voltageScale = [5,6,7,8];
            expectedAPDData(1).attenuation = [];
            
            % First peakData
            expectedPeakData = segmentation.model.peakData();
            expectedPeakData.apdRatio = 1;
            expectedPeakData.apdDiff = 1.5;
            expectedPeakData.triang = 0.1;
            expectedPeakData.frac = 0.11;
            expectedPeakData.a20 = 0.21;
            expectedPeakData.a30 = 0.31;
            expectedPeakData.a40 = 0.41;
            expectedPeakData.a50 = 0.51;
            expectedPeakData.a60 = 0.61;
            expectedPeakData.a70 = 0.71;
            expectedPeakData.a80 = 0.81;
            expectedPeakData.a90 = 0.91;
            expectedAPDData(1).peakData = expectedPeakData;
            
            % Second apdData
            expectedAPDData(2).peakNum = 2;
            expectedAPDData(2).actionPotentialVoltage = [];
            expectedAPDData(2).actionPotentialTime = [];
            expectedAPDData(2).startTime = 60;
            expectedAPDData(2).stopTime = 61;
            expectedAPDData(2).peakTime = 62;
            expectedAPDData(2).peakVoltage = 63;
            expectedAPDData(2).absAmplitude = 64;
            expectedAPDData(2).timeScale = [5,6,7,8];
            expectedAPDData(2).voltageScale = [9,10,11,12];
            expectedAPDData(2).attenuation = 0.1;
            
            % Second peakData
            expectedPeakData.apdRatio = 2;
            expectedPeakData.apdDiff = 2.5;
            expectedPeakData.triang = 0.2;
            expectedPeakData.frac = 0.12;
            expectedPeakData.a20 = 0.22;
            expectedPeakData.a30 = 0.32;
            expectedPeakData.a40 = 0.42;
            expectedPeakData.a50 = 0.52;
            expectedPeakData.a60 = 0.62;
            expectedPeakData.a70 = 0.72;
            expectedPeakData.a80 = 0.82;
            expectedPeakData.a90 = 0.92;
            expectedAPDData(2).peakData = expectedPeakData;
            
            % Third apdData
            expectedAPDData(3).peakNum = 3;
            expectedAPDData(3).actionPotentialVoltage = [];
            expectedAPDData(3).actionPotentialTime = [];
            expectedAPDData(3).startTime = 70;
            expectedAPDData(3).stopTime = 71;
            expectedAPDData(3).peakTime = 72;
            expectedAPDData(3).peakVoltage = 73;
            expectedAPDData(3).absAmplitude = 74;
            expectedAPDData(3).timeScale = [9,10,11,12];
            expectedAPDData(3).voltageScale = [13,14,15,16];
            expectedAPDData(3).attenuation = 0.2;
            
            % Third peakData
            expectedPeakData.apdRatio = 3;
            expectedPeakData.apdDiff = 3.5;
            expectedPeakData.triang = 0.3;
            expectedPeakData.frac = 0.13;
            expectedPeakData.a20 = 0.23;
            expectedPeakData.a30 = 0.33;
            expectedPeakData.a40 = 0.43;
            expectedPeakData.a50 = 0.53;
            expectedPeakData.a60 = 0.63;
            expectedPeakData.a70 = 0.73;
            expectedPeakData.a80 = 0.83;
            expectedPeakData.a90 = 0.93;
            expectedAPDData(3).peakData = expectedPeakData;
            
            expectedOutData(1).apdData = expectedAPDData;
            
            % Since new outData object -> new wellElectrode combination.
            wellLogical = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            expectedWellElectrodeData = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            
            expectedOutData(2).index = 2;
            expectedOutData(2).voltage = [10,20,30,40,50,60,70,80,90];
            expectedOutData(2).time = [0,5,6,7,8,9,10,11,12];
            expectedOutData(2).esub = [11,12,13,14,15,16];
            expectedOutData(2).experimentNum = 1;
            expectedOutData(2).wellElectrodeData = expectedWellElectrodeData;
            expectedOutData(2).apProcessed = 1;
            expectedOutData(2).apOmit = 1;
            expectedOutData(2).medicationName = 'No Medication';
            expectedOutData(2).medicationConcen = 'No Concentration';
            expectedOutData(2).fpProcessed = 0;
            expectedOutData(2).fpOmit = 0;
            
            actualConvertedCSV = importdata(testCase.tempFiles(1), ',');
            actualConvertedMAT = load(testCase.tempFiles(2));
            
            % Test CSV - the actual size should equal 4 due to the header
            % and three apdData waveforms.
            actualConvertedCSVSize = size(actualConvertedCSV);
            verifyEqual(testCase, actualConvertedCSVSize(1), 4);
            expectedCSVValue = 'expNum,well,elec,peakNum,absAmp,apd20,apd30,apd40,apd50,apd60,apd70,apd80,apd90,apdRatio,apdDiff,apdTriang,apdFrac,apdAtten,apdCycleLength,apdInstFreq,apdAvgFreq,apdDiastolicInter,medName,medConc,peakTime,apdStart,apdStop,leftCursor,rightCursor,fileName,batchName,version';
            verifyEqual(testCase, actualConvertedCSV(1), {expectedCSVValue});
            expectedCSVValue = strcat('1,0,12,1,54,0.21,0.31,0.41,0.51,0.61,0.71,0.81,0.91,1,1.5,0.1,0.11,NaN,NaN,NaN,NaN,NaN,No Medication,No Concentration,52,50,51,50,55,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(2), {expectedCSVValue});
            expectedCSVValue = strcat('1,0,12,2,64,0.22,0.32,0.42,0.52,0.62,0.72,0.82,0.92,2,2.5,0.2,0.12,0.1,NaN,NaN,NaN,NaN,No Medication,No Concentration,62,60,61,50,55,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(3), {expectedCSVValue});
            expectedCSVValue = strcat('1,0,12,3,74,0.23,0.33,0.43,0.53,0.63,0.73,0.83,0.93,3,3.5,0.3,0.13,0.2,NaN,NaN,NaN,NaN,No Medication,No Concentration,72,70,71,50,55,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(4), {expectedCSVValue});
            
            % Test MAT - there should only be a two records in the
            % outData array (with and without an omit).
            verifyEqual(testCase, length(actualConvertedMAT.outDataStruct), 2);
            verifyEqual(testCase, actualConvertedMAT.outDataStruct(1,2), expectedOutData(1,2));
        end
        
        function multipleOldOutData_noOmit(testCase)
            % MULTIPLEOLDOUTDATA_NOOMIT Test to determine that the
            % conversion will result in a two array elements in the
            % converted data structure, as well as seven records in the .csv
            % (header + three peaks for each array element).  The input structure
            % has two entries, both of which have an omit status = 0;
            
            % test/resource
            originalFileName = 'multipleOldOutData_M123456_noOmit.mat';
            
            % Establish temp directory and files.
            tempFileDirectory = tempdir;
            tempFileNameCSV = ['multipleOldOutData_M123456_noOmit_ap_converted_', date, '.csv'];
            tempFileNameMat = ['multipleOldOutData_M123456_noOmit_converted_', date, '.mat'];
            
            % Save the established temp files to the class attribute - to
            % be used for deletion after the function completes.
            testCase.tempFiles = [convertCharsToStrings([tempFileDirectory, tempFileNameCSV]) ...
                convertCharsToStrings([tempFileDirectory, tempFileNameMat])];
            
            % Load the old structure.
            oldOutData = load([pwd, filesep, ...
                '+segmentation', filesep, ...
                '+test', filesep, ...
                '+resources', filesep, ...
                'multipleOldOutData_M123456_noOmit.mat']);
            
            testCase.conversionHandles.convert(oldOutData.multipleOldOutData_noOmit, originalFileName, tempFileDirectory);
            
            % First outData.
            wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            expectedWellElectrodeData = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            
            expectedOutData = segmentation.model.outData();
            expectedOutData(1).index = 1;
            expectedOutData(1).voltage = [10,20,30,40,50,60,70,80,90];
            expectedOutData(1).time = [0,5,6,7,8,9,10,11,12];
            expectedOutData(1).esub = [11,12,13,14,15,16];
            expectedOutData(1).experimentNum = 1;
            expectedOutData(1).wellElectrodeData = expectedWellElectrodeData;
            expectedOutData(1).apProcessed = 1;
            expectedOutData(1).apOmit = 0;
            expectedOutData(1).medicationName = 'No Medication';
            expectedOutData(1).medicationConcen = 'No Concentration';
            expectedOutData(1).apVoltageSegment = [10,15,20,25];
            expectedOutData(1).apTimeSegment = [1,2,3,4,5];
            expectedOutData(1).apLeftCursorLoc = 50;
            expectedOutData(1).apRightCursorLoc = 55;
            expectedOutData(1).apMeasGap = [];
            expectedOutData(1).fpProcessed = 0;
            expectedOutData(1).fpOmit = 0;
            
            % First apdData for the first outData.
            expectedAPDData = segmentation.model.apdData();
            expectedAPDData(1).peakNum = 1;
            expectedAPDData(1).actionPotentialVoltage = [];
            expectedAPDData(1).actionPotentialTime = [];
            expectedAPDData(1).startTime = 50;
            expectedAPDData(1).stopTime = 51;
            expectedAPDData(1).peakTime = 52;
            expectedAPDData(1).peakVoltage = 53;
            expectedAPDData(1).absAmplitude = 54;
            expectedAPDData(1).timeScale = [1,2,3,4];
            expectedAPDData(1).voltageScale = [5,6,7,8];
            expectedAPDData(1).attenuation = [];
            
            % First peakData for first apdData in the first outData.
            expectedPeakData = segmentation.model.peakData();
            expectedPeakData.apdRatio = 1;
            expectedPeakData.apdDiff = 1.5;
            expectedPeakData.triang = 0.1;
            expectedPeakData.frac = 0.11;
            expectedPeakData.a20 = 0.21;
            expectedPeakData.a30 = 0.31;
            expectedPeakData.a40 = 0.41;
            expectedPeakData.a50 = 0.51;
            expectedPeakData.a60 = 0.61;
            expectedPeakData.a70 = 0.71;
            expectedPeakData.a80 = 0.81;
            expectedPeakData.a90 = 0.91;
            expectedAPDData(1).peakData = expectedPeakData;
            
            % Second apdData for the first outData.
            expectedAPDData(2).peakNum = 2;
            expectedAPDData(2).actionPotentialVoltage = [];
            expectedAPDData(2).actionPotentialTime = [];
            expectedAPDData(2).startTime = 60;
            expectedAPDData(2).stopTime = 61;
            expectedAPDData(2).peakTime = 62;
            expectedAPDData(2).peakVoltage = 63;
            expectedAPDData(2).absAmplitude = 64;
            expectedAPDData(2).timeScale = [5,6,7,8];
            expectedAPDData(2).voltageScale = [9,10,11,12];
            expectedAPDData(2).attenuation = 0.1;
            
            % Second peakData for the second apdData in the first outData.
            expectedPeakData.apdRatio = 2;
            expectedPeakData.apdDiff = 2.5;
            expectedPeakData.triang = 0.2;
            expectedPeakData.frac = 0.12;
            expectedPeakData.a20 = 0.22;
            expectedPeakData.a30 = 0.32;
            expectedPeakData.a40 = 0.42;
            expectedPeakData.a50 = 0.52;
            expectedPeakData.a60 = 0.62;
            expectedPeakData.a70 = 0.72;
            expectedPeakData.a80 = 0.82;
            expectedPeakData.a90 = 0.92;
            expectedAPDData(2).peakData = expectedPeakData;
            
            % Third apdData for the first outData.
            expectedAPDData(3).peakNum = 3;
            expectedAPDData(3).actionPotentialVoltage = [];
            expectedAPDData(3).actionPotentialTime = [];
            expectedAPDData(3).startTime = 70;
            expectedAPDData(3).stopTime = 71;
            expectedAPDData(3).peakTime = 72;
            expectedAPDData(3).peakVoltage = 73;
            expectedAPDData(3).absAmplitude = 74;
            expectedAPDData(3).timeScale = [9,10,11,12];
            expectedAPDData(3).voltageScale = [13,14,15,16];
            expectedAPDData(3).attenuation = 0.2;
            
            % Third peakData for the third apdData in the first outData.
            expectedPeakData.apdRatio = 3;
            expectedPeakData.apdDiff = 3.5;
            expectedPeakData.triang = 0.3;
            expectedPeakData.frac = 0.13;
            expectedPeakData.a20 = 0.23;
            expectedPeakData.a30 = 0.33;
            expectedPeakData.a40 = 0.43;
            expectedPeakData.a50 = 0.53;
            expectedPeakData.a60 = 0.63;
            expectedPeakData.a70 = 0.73;
            expectedPeakData.a80 = 0.83;
            expectedPeakData.a90 = 0.93;
            expectedAPDData(3).peakData = expectedPeakData;
            
            expectedOutData(1).apdData = expectedAPDData;
            
            % Second outData.
            wellLogical = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            expectedWellElectrodeData = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            
            expectedOutData(2).index = 2;
            expectedOutData(2).voltage = [11,20,30,40,50,60,70,80,90];
            expectedOutData(2).time = [1,5,6,7,8,9,10,11,12];
            expectedOutData(2).esub = [9,12,13,14,15,16];
            expectedOutData(2).experimentNum = 1;
            expectedOutData(2).wellElectrodeData = expectedWellElectrodeData;
            expectedOutData(2).apProcessed = 1;
            expectedOutData(2).apOmit = 0;
            expectedOutData(2).medicationName = 'No Medication';
            expectedOutData(2).medicationConcen = 'No Concentration';
            expectedOutData(2).apVoltageSegment = [11,15,20,25];
            expectedOutData(2).apTimeSegment = [11,2,3,4,5];
            expectedOutData(2).apLeftCursorLoc = 51;
            expectedOutData(2).apRightCursorLoc = 52;
            expectedOutData(2).apMeasGap = [];
            expectedOutData(2).fpProcessed = 0;
            expectedOutData(2).fpOmit = 0;
            
            % First apdData for the second outData.
            expectedAPDData = segmentation.model.apdData();
            expectedAPDData(1).peakNum = 1;
            expectedAPDData(1).actionPotentialVoltage = [];
            expectedAPDData(1).actionPotentialTime = [];
            expectedAPDData(1).startTime = 500;
            expectedAPDData(1).stopTime = 510;
            expectedAPDData(1).peakTime = 520;
            expectedAPDData(1).peakVoltage = 530;
            expectedAPDData(1).absAmplitude = 540;
            expectedAPDData(1).timeScale = [1,2,3,40];
            expectedAPDData(1).voltageScale = [5,6,7,80];
            expectedAPDData(1).attenuation = [];
            
            % First peakData for the first apdData in the second outData.
            expectedPeakData = segmentation.model.peakData();
            expectedPeakData.apdRatio = 10;
            expectedPeakData.apdDiff = 1.05;
            expectedPeakData.triang = 0.01;
            expectedPeakData.frac = 0.011;
            expectedPeakData.a20 = 0.021;
            expectedPeakData.a30 = 0.031;
            expectedPeakData.a40 = 0.041;
            expectedPeakData.a50 = 0.051;
            expectedPeakData.a60 = 0.061;
            expectedPeakData.a70 = 0.071;
            expectedPeakData.a80 = 0.081;
            expectedPeakData.a90 = 0.091;
            expectedAPDData(1).peakData = expectedPeakData;
            
            % Second apdData for the second outData.
            expectedAPDData(2).peakNum = 2;
            expectedAPDData(2).actionPotentialVoltage = [];
            expectedAPDData(2).actionPotentialTime = [];
            expectedAPDData(2).startTime = 600;
            expectedAPDData(2).stopTime = 610;
            expectedAPDData(2).peakTime = 620;
            expectedAPDData(2).peakVoltage = 630;
            expectedAPDData(2).absAmplitude = 640;
            expectedAPDData(2).timeScale = [5,6,7,80];
            expectedAPDData(2).voltageScale = [9,10,11,120];
            expectedAPDData(2).attenuation = 0.01;
            
            % Second peakData for the second apdData in the second outData.
            expectedPeakData.apdRatio = 20;
            expectedPeakData.apdDiff = 2.05;
            expectedPeakData.triang = 0.02;
            expectedPeakData.frac = 0.012;
            expectedPeakData.a20 = 0.022;
            expectedPeakData.a30 = 0.032;
            expectedPeakData.a40 = 0.042;
            expectedPeakData.a50 = 0.052;
            expectedPeakData.a60 = 0.062;
            expectedPeakData.a70 = 0.072;
            expectedPeakData.a80 = 0.082;
            expectedPeakData.a90 = 0.092;
            expectedAPDData(2).peakData = expectedPeakData;
            
            % Third apdData for the second outData.
            expectedAPDData(3).peakNum = 3;
            expectedAPDData(3).actionPotentialVoltage = [];
            expectedAPDData(3).actionPotentialTime = [];
            expectedAPDData(3).startTime = 700;
            expectedAPDData(3).stopTime = 710;
            expectedAPDData(3).peakTime = 720;
            expectedAPDData(3).peakVoltage = 730;
            expectedAPDData(3).absAmplitude = 740;
            expectedAPDData(3).timeScale = [9,10,11,120];
            expectedAPDData(3).voltageScale = [13,14,15,160];
            expectedAPDData(3).attenuation = 0.02;
            
            % Third peakData for the third apdData in the second outData.
            expectedPeakData.apdRatio = 30;
            expectedPeakData.apdDiff = 3.05;
            expectedPeakData.triang = 0.03;
            expectedPeakData.frac = 0.013;
            expectedPeakData.a20 = 0.023;
            expectedPeakData.a30 = 0.033;
            expectedPeakData.a40 = 0.043;
            expectedPeakData.a50 = 0.053;
            expectedPeakData.a60 = 0.063;
            expectedPeakData.a70 = 0.073;
            expectedPeakData.a80 = 0.083;
            expectedPeakData.a90 = 0.093;
            expectedAPDData(3).peakData = expectedPeakData;
            
            expectedOutData(2).apdData = expectedAPDData;
            
            actualConvertedCSV = importdata(testCase.tempFiles(1), ',');
            actualConvertedMAT = load(testCase.tempFiles(2));
            
            % Test CSV - the actual size should equal 7 due to the header
            % and six apdData waveforms.;
            actualConvertedCSVSize = size(actualConvertedCSV);
            verifyEqual(testCase, actualConvertedCSVSize(1), 7);
            expectedCSVValue = 'expNum,well,elec,peakNum,absAmp,apd20,apd30,apd40,apd50,apd60,apd70,apd80,apd90,apdRatio,apdDiff,apdTriang,apdFrac,apdAtten,apdCycleLength,apdInstFreq,apdAvgFreq,apdDiastolicInter,medName,medConc,peakTime,apdStart,apdStop,leftCursor,rightCursor,fileName,batchName,version';
            verifyEqual(testCase, actualConvertedCSV(1), {expectedCSVValue});
            expectedCSVValue = strcat('1,0,12,1,54,0.21,0.31,0.41,0.51,0.61,0.71,0.81,0.91,1,1.5,0.1,0.11,NaN,NaN,NaN,NaN,NaN,No Medication,No Concentration,52,50,51,50,55,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(2), {expectedCSVValue});
            expectedCSVValue = strcat('1,0,12,2,64,0.22,0.32,0.42,0.52,0.62,0.72,0.82,0.92,2,2.5,0.2,0.12,0.1,NaN,NaN,NaN,NaN,No Medication,No Concentration,62,60,61,50,55,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(3), {expectedCSVValue});
            expectedCSVValue = strcat('1,0,12,3,74,0.23,0.33,0.43,0.53,0.63,0.73,0.83,0.93,3,3.5,0.3,0.13,0.2,NaN,NaN,NaN,NaN,No Medication,No Concentration,72,70,71,50,55,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(4), {expectedCSVValue});
            expectedCSVValue = strcat('1,2,12,1,540,0.021,0.031,0.041,0.051,0.061,0.071,0.081,0.091,10,1.05,0.01,0.011,NaN,NaN,NaN,NaN,NaN,No Medication,No Concentration,520,500,510,51,52,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(5), {expectedCSVValue});
            expectedCSVValue = strcat('1,2,12,2,640,0.022,0.032,0.042,0.052,0.062,0.072,0.082,0.092,20,2.05,0.02,0.012,0.01,NaN,NaN,NaN,NaN,No Medication,No Concentration,620,600,610,51,52,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(6), {expectedCSVValue});
            expectedCSVValue = strcat('1,2,12,3,740,0.023,0.033,0.043,0.053,0.063,0.073,0.083,0.093,30,3.05,0.03,0.013,0.02,NaN,NaN,NaN,NaN,No Medication,No Concentration,720,700,710,51,52,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(7), {expectedCSVValue});
            
            % Test MAT
            verifyEqual(testCase, length(actualConvertedMAT.outDataStruct), 2);
            verifyEqual(testCase, actualConvertedMAT.outDataStruct, expectedOutData);
        end
        
        function multipleOldOutData_withSingleOmit(testCase)
            % MULTIPLEOLDOUTDATA_WITHSINGLEOMIT Test to determine that the
            % conversion will result in three array elements in the
            % converted data strucutre, as well as seven records in the .csv
            % (header + six peaks for each array element where the omit status =
            % 0).  The input structure has three entries.  Two of the three
            % elements have an omit status = 0, one of the three elements
            % has an omit status = 1;
            
            % test/resource
            originalFileName = 'multipleOldOutData_M123456_withSingleOmit.mat';
            
            % Establish temp directory and files.
            tempFileDirectory = tempdir;
            tempFileNameCSV = ['multipleOldOutData_M123456_withSingleOmit_ap_converted_', date, '.csv'];
            tempFileNameMat = ['multipleOldOutData_M123456_withSingleOmit_converted_', date, '.mat'];
            
            % Save the established temp files to the class attribute - to
            % be used for deletion after the function completes.
            testCase.tempFiles = [convertCharsToStrings([tempFileDirectory, tempFileNameCSV]) ...
                convertCharsToStrings([tempFileDirectory, tempFileNameMat])];
            
            % Load the old structure.
            oldOutData = load([pwd, filesep, ...
                '+segmentation', filesep, ...
                '+test', filesep, ...
                '+resources', filesep, ...
                'multipleOldOutData_M123456_withSingleOmit.mat']);
            
            testCase.conversionHandles.convert(oldOutData.multipleOldOutData_withSingleOmit, originalFileName, tempFileDirectory);
            
            % First outData.
            wellLogical = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            expectedWellElectrodeData = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            
            expectedOutData = segmentation.model.outData();
            expectedOutData(1).index = 1;
            expectedOutData(1).voltage = [10,20,30,40,50,60,70,80,90];
            expectedOutData(1).time = [0,5,6,7,8,9,10,11,12];
            expectedOutData(1).esub = [11,12,13,14,15,16];
            expectedOutData(1).experimentNum = 1;
            expectedOutData(1).wellElectrodeData = expectedWellElectrodeData;
            expectedOutData(1).apProcessed = 1;
            expectedOutData(1).apOmit = 0;
            expectedOutData(1).medicationName = 'No Medication';
            expectedOutData(1).medicationConcen = 'No Concentration';
            expectedOutData(1).apVoltageSegment = [10,15,20,25];
            expectedOutData(1).apTimeSegment = [1,2,3,4,5];
            expectedOutData(1).apLeftCursorLoc = 50;
            expectedOutData(1).apRightCursorLoc = 55;
            expectedOutData(1).apMeasGap = [];
            expectedOutData(1).fpProcessed = 0;
            expectedOutData(1).fpOmit = 0;
            
            % First apdData for the first outData.
            expectedAPDData = segmentation.model.apdData();
            expectedAPDData(1).peakNum = 1;
            expectedAPDData(1).actionPotentialVoltage = [];
            expectedAPDData(1).actionPotentialTime = [];
            expectedAPDData(1).startTime = 50;
            expectedAPDData(1).stopTime = 51;
            expectedAPDData(1).peakTime = 52;
            expectedAPDData(1).peakVoltage = 53;
            expectedAPDData(1).absAmplitude = 54;
            expectedAPDData(1).timeScale = [1,2,3,4];
            expectedAPDData(1).voltageScale = [5,6,7,8];
            expectedAPDData(1).attenuation = [];
            
            % First peakData for first apdData in the first outData.
            expectedPeakData = segmentation.model.peakData();
            expectedPeakData.apdRatio = 1;
            expectedPeakData.apdDiff = 1.5;
            expectedPeakData.triang = 0.1;
            expectedPeakData.frac = 0.11;
            expectedPeakData.a20 = 0.21;
            expectedPeakData.a30 = 0.31;
            expectedPeakData.a40 = 0.41;
            expectedPeakData.a50 = 0.51;
            expectedPeakData.a60 = 0.61;
            expectedPeakData.a70 = 0.71;
            expectedPeakData.a80 = 0.81;
            expectedPeakData.a90 = 0.91;
            expectedAPDData(1).peakData = expectedPeakData;
            
            % Second apdData for the first outData.
            expectedAPDData(2).peakNum = 2;
            expectedAPDData(2).actionPotentialVoltage = [];
            expectedAPDData(2).actionPotentialTime = [];
            expectedAPDData(2).startTime = 60;
            expectedAPDData(2).stopTime = 61;
            expectedAPDData(2).peakTime = 62;
            expectedAPDData(2).peakVoltage = 63;
            expectedAPDData(2).absAmplitude = 64;
            expectedAPDData(2).timeScale = [5,6,7,8];
            expectedAPDData(2).voltageScale = [9,10,11,12];
            expectedAPDData(2).attenuation = 0.1;
            
            % Second peakData for the second apdData in the first outData.
            expectedPeakData.apdRatio = 2;
            expectedPeakData.apdDiff = 2.5;
            expectedPeakData.triang = 0.2;
            expectedPeakData.frac = 0.12;
            expectedPeakData.a20 = 0.22;
            expectedPeakData.a30 = 0.32;
            expectedPeakData.a40 = 0.42;
            expectedPeakData.a50 = 0.52;
            expectedPeakData.a60 = 0.62;
            expectedPeakData.a70 = 0.72;
            expectedPeakData.a80 = 0.82;
            expectedPeakData.a90 = 0.92;
            expectedAPDData(2).peakData = expectedPeakData;
            
            % Third apdData for the first outData.
            expectedAPDData(3).peakNum = 3;
            expectedAPDData(3).actionPotentialVoltage = [];
            expectedAPDData(3).actionPotentialTime = [];
            expectedAPDData(3).startTime = 70;
            expectedAPDData(3).stopTime = 71;
            expectedAPDData(3).peakTime = 72;
            expectedAPDData(3).peakVoltage = 73;
            expectedAPDData(3).absAmplitude = 74;
            expectedAPDData(3).timeScale = [9,10,11,12];
            expectedAPDData(3).voltageScale = [13,14,15,16];
            expectedAPDData(3).attenuation = 0.2;
            
            % Third peakData for the third apdData in the first outData.
            expectedPeakData.apdRatio = 3;
            expectedPeakData.apdDiff = 3.5;
            expectedPeakData.triang = 0.3;
            expectedPeakData.frac = 0.13;
            expectedPeakData.a20 = 0.23;
            expectedPeakData.a30 = 0.33;
            expectedPeakData.a40 = 0.43;
            expectedPeakData.a50 = 0.53;
            expectedPeakData.a60 = 0.63;
            expectedPeakData.a70 = 0.73;
            expectedPeakData.a80 = 0.83;
            expectedPeakData.a90 = 0.93;
            expectedAPDData(3).peakData = expectedPeakData;
            
            expectedOutData(1).apdData = expectedAPDData;
            
            % Second outData - no apdData/peakData objects.
            wellLogical = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            expectedWellElectrodeData = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            
            expectedOutData(2).index = 2;
            expectedOutData(2).voltage = [11,20,30,40,50,60,70,80,90];
            expectedOutData(2).time = [1,5,6,7,8,9,10,11,12];
            expectedOutData(2).esub = [9,12,13,14,15,16];
            expectedOutData(2).experimentNum = 1;
            expectedOutData(2).wellElectrodeData = expectedWellElectrodeData;
            expectedOutData(2).apProcessed = 1;
            expectedOutData(2).apOmit = 1;
            expectedOutData(2).medicationName = 'No Medication';
            expectedOutData(2).medicationConcen = 'No Concentration';
            expectedOutData(2).apMeasGap = [];
            expectedOutData(2).fpProcessed = 0;
            expectedOutData(2).fpOmit = 0;
            
            % Third outdata
            wellLogical = [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [1 0 0 0 0 0 0 0 0 0 0 0];
            expectedWellElectrodeData = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
            
            expectedOutData(3).index = 3;
            expectedOutData(3).voltage = [11,20,30,40,50,60,70,80,90];
            expectedOutData(3).time = [1,5,6,7,8,9,10,11,12];
            expectedOutData(3).esub = [9,12,13,14,15,16];
            expectedOutData(3).experimentNum = 1;
            expectedOutData(3).wellElectrodeData = expectedWellElectrodeData;
            expectedOutData(3).apProcessed = 1;
            expectedOutData(3).apOmit = 0;
            expectedOutData(3).medicationName = 'No Medication';
            expectedOutData(3).medicationConcen = 'No Concentration';
            expectedOutData(3).apVoltageSegment = [11,15,20,25];
            expectedOutData(3).apTimeSegment = [11,2,3,4,5];
            expectedOutData(3).apLeftCursorLoc = 51;
            expectedOutData(3).apRightCursorLoc = 52;
            expectedOutData(3).apMeasGap = [];
            expectedOutData(3).fpProcessed = 0;
            expectedOutData(3).fpOmit = 0;
            
            % First apdData for the third outData
            expectedAPDData = segmentation.model.apdData();
            expectedAPDData(1).peakNum = 1;
            expectedAPDData(1).actionPotentialVoltage = [];
            expectedAPDData(1).actionPotentialTime = [];
            expectedAPDData(1).startTime = 500;
            expectedAPDData(1).stopTime = 510;
            expectedAPDData(1).peakTime = 520;
            expectedAPDData(1).peakVoltage = 530;
            expectedAPDData(1).absAmplitude = 540;
            expectedAPDData(1).timeScale = [1,2,3,40];
            expectedAPDData(1).voltageScale = [5,6,7,80];
            expectedAPDData(1).attenuation = [];
            
            % First peakData for the first apdData in the third outData.
            expectedPeakData = segmentation.model.peakData();
            expectedPeakData.apdRatio = 10;
            expectedPeakData.apdDiff = 1.05;
            expectedPeakData.triang = 0.01;
            expectedPeakData.frac = 0.011;
            expectedPeakData.a20 = 0.021;
            expectedPeakData.a30 = 0.031;
            expectedPeakData.a40 = 0.041;
            expectedPeakData.a50 = 0.051;
            expectedPeakData.a60 = 0.061;
            expectedPeakData.a70 = 0.071;
            expectedPeakData.a80 = 0.081;
            expectedPeakData.a90 = 0.091;
            expectedAPDData(1).peakData = expectedPeakData;
            
            % Second apdData for the third outData.
            expectedAPDData(2).peakNum = 2;
            expectedAPDData(2).actionPotentialVoltage = [];
            expectedAPDData(2).actionPotentialTime = [];
            expectedAPDData(2).startTime = 600;
            expectedAPDData(2).stopTime = 610;
            expectedAPDData(2).peakTime = 620;
            expectedAPDData(2).peakVoltage = 630;
            expectedAPDData(2).absAmplitude = 640;
            expectedAPDData(2).timeScale = [5,6,7,80];
            expectedAPDData(2).voltageScale = [9,10,11,120];
            expectedAPDData(2).attenuation = 0.01;
            
            % Second peakData for the second apdData in the third outData.
            expectedPeakData.apdRatio = 20;
            expectedPeakData.apdDiff = 2.05;
            expectedPeakData.triang = 0.02;
            expectedPeakData.frac = 0.012;
            expectedPeakData.a20 = 0.022;
            expectedPeakData.a30 = 0.032;
            expectedPeakData.a40 = 0.042;
            expectedPeakData.a50 = 0.052;
            expectedPeakData.a60 = 0.062;
            expectedPeakData.a70 = 0.072;
            expectedPeakData.a80 = 0.082;
            expectedPeakData.a90 = 0.092;
            expectedAPDData(2).peakData = expectedPeakData;
            
            % Third apdData for the third outData.
            expectedAPDData(3).peakNum = 3;
            expectedAPDData(3).actionPotentialVoltage = [];
            expectedAPDData(3).actionPotentialTime = [];
            expectedAPDData(3).startTime = 700;
            expectedAPDData(3).stopTime = 710;
            expectedAPDData(3).peakTime = 720;
            expectedAPDData(3).peakVoltage = 730;
            expectedAPDData(3).absAmplitude = 740;
            expectedAPDData(3).timeScale = [9,10,11,120];
            expectedAPDData(3).voltageScale = [13,14,15,160];
            expectedAPDData(3).attenuation = 0.02;
            
            % Third peakData for the third apdData in the third outData.
            expectedPeakData.apdRatio = 30;
            expectedPeakData.apdDiff = 3.05;
            expectedPeakData.triang = 0.03;
            expectedPeakData.frac = 0.013;
            expectedPeakData.a20 = 0.023;
            expectedPeakData.a30 = 0.033;
            expectedPeakData.a40 = 0.043;
            expectedPeakData.a50 = 0.053;
            expectedPeakData.a60 = 0.063;
            expectedPeakData.a70 = 0.073;
            expectedPeakData.a80 = 0.083;
            expectedPeakData.a90 = 0.093;
            expectedAPDData(3).peakData = expectedPeakData;
            
            expectedOutData(3).apdData = expectedAPDData;
            
            actualConvertedCSV = importdata(testCase.tempFiles(1), ',');
            actualConvertedMAT = load(testCase.tempFiles(2));
            
            % Test CSV - the actual size should equal 7 due to the header
            % and six apdData waveforms.;
            actualConvertedCSVSize = size(actualConvertedCSV);
            verifyEqual(testCase, actualConvertedCSVSize(1), 7);
            expectedCSVValue = 'expNum,well,elec,peakNum,absAmp,apd20,apd30,apd40,apd50,apd60,apd70,apd80,apd90,apdRatio,apdDiff,apdTriang,apdFrac,apdAtten,apdCycleLength,apdInstFreq,apdAvgFreq,apdDiastolicInter,medName,medConc,peakTime,apdStart,apdStop,leftCursor,rightCursor,fileName,batchName,version';
            verifyEqual(testCase, actualConvertedCSV(1), {expectedCSVValue});
            expectedCSVValue = strcat('1,0,12,1,54,0.21,0.31,0.41,0.51,0.61,0.71,0.81,0.91,1,1.5,0.1,0.11,NaN,NaN,NaN,NaN,NaN,No Medication,No Concentration,52,50,51,50,55,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(2), {expectedCSVValue});
            expectedCSVValue = strcat('1,0,12,2,64,0.22,0.32,0.42,0.52,0.62,0.72,0.82,0.92,2,2.5,0.2,0.12,0.1,NaN,NaN,NaN,NaN,No Medication,No Concentration,62,60,61,50,55,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(3), {expectedCSVValue});
            expectedCSVValue = strcat('1,0,12,3,74,0.23,0.33,0.43,0.53,0.63,0.73,0.83,0.93,3,3.5,0.3,0.13,0.2,NaN,NaN,NaN,NaN,No Medication,No Concentration,72,70,71,50,55,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(4), {expectedCSVValue});
            expectedCSVValue = strcat('1,3,12,1,540,0.021,0.031,0.041,0.051,0.061,0.071,0.081,0.091,10,1.05,0.01,0.011,NaN,NaN,NaN,NaN,NaN,No Medication,No Concentration,520,500,510,51,52,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(5), {expectedCSVValue});
            expectedCSVValue = strcat('1,3,12,2,640,0.022,0.032,0.042,0.052,0.062,0.072,0.082,0.092,20,2.05,0.02,0.012,0.01,NaN,NaN,NaN,NaN,No Medication,No Concentration,620,600,610,51,52,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(6), {expectedCSVValue});
            expectedCSVValue = strcat('1,3,12,3,740,0.023,0.033,0.043,0.053,0.063,0.073,0.083,0.093,30,3.05,0.03,0.013,0.02,NaN,NaN,NaN,NaN,No Medication,No Concentration,720,700,710,51,52,', [tempFileDirectory filesep originalFileName], ',M123456,2.5.0');
            verifyEqual(testCase, actualConvertedCSV(7), {expectedCSVValue});
            
            % Test MAT
            verifyEqual(testCase, length(actualConvertedMAT.outDataStruct), 3);
            verifyEqual(testCase, actualConvertedMAT.outDataStruct, expectedOutData);
        end
    end
end