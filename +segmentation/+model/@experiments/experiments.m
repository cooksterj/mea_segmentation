classdef experiments
    % EXPERIMENTS Controlling object for the waveform analyzer.
    %
    % Author:  Jonathan Cook
    % Created: 2018-08-31
    
    properties
        allExperimentData          % All experimental data - contains events and analog streams.
        allExperimentTime          % All experimental time data (all waveforms).
        allElectroporationStop     % All electroporation data (all waveforms).
        allExperimentVoltage       % All experimental voltage data (all waveforms).
        wellIDs                    % All well identifiers.
        electrodeIDs               % All electrode identifies.
        recordStop                 % The stop times of each experiment.
        recordStart                % The start times of eawch experiment.
        wellElectrodeData          % A wellElectrodeData object - what was selected in the UI.
        outDataRslt                % The outdataRslt object.
    end
    
    properties(Constant)
        apColumnNames = {'expNum', 'well', 'elec', 'peakNum','absAmp', 'apd20',...
            'apd30', 'apd40', 'apd50', 'apd60', 'apd70', 'apd80', 'apd90', 'apdRatio',...
            'apdDiff', 'apdTriang', 'apdFrac', 'apdAtten', 'apdCycleLength', ...
            'apdInstFreq', 'apdAvgFreq', 'apdDiastolicInter', 'medName', 'medConc', ...
            'peakTime', 'apdStart', 'apdStop', 'leftCursor', 'rightCursor', ...
            'fileName', 'batchName', 'version'};
        
        fpColumnNames = {'expNum', 'well', 'elec', 'peakNum', 'fpStart', 'fpStop',...
            'fpPeakTime', 'fpPeakVoltage', 'fpAmplitude', 'fpCycleLength', ...
            'fpInstFreq', 'fpAvgFreq', 'fpSlope', 'fileName', 'batchName', 'version'}
    end
    
    methods(Static)
        function rslt = processActionPotentialData(initializedOutDataRslts)
            % PROCESSACTIONPOTENTIALDATA Process action potential data -
            % process the action potential waveforms for each outDataRslt.
            %
            % Input:
            %     initializedOutDataRslts:  outDatRslts where the action potential
            %                               attributes have been populated..
            %
            % Output:
            %     outDataRslt: outData object where the action potential attributes
            %                  have been populated.
            
            processActionPotentialSegmentation = segmentation.functions.processActionPotentialSegmentation_f;
            rslt(1, length(initializedOutDataRslts)) = segmentation.model.outData;
            for i = 1:length(initializedOutDataRslts)
                rslt(i) = initializedOutDataRslts(i);
                if(initializedOutDataRslts(i).apSection.processed == 0)
                    rslt(i).apSection = processActionPotentialSegmentation.processActionPotentialWaveforms(initializedOutDataRslts(i).apSection);
                elseif(initializedOutDataRslts(i).apSection.processed == 1)
                    rslt(i).apSection = initializedOutDataRslts(i).apSection;
                end
            end
        end
        
        function rslt = processFieldData(initializedOutDataRslts)
            % PROCESSFIELDDATA Process field potential data -
            % process the field potential waveforms for each outDataRslt.
            %
            % Input:
            %     initializedOutDataRslts:  outDatRslts where the field potential
            %                               attributes have been populated..
            %
            % Output:
            %     outDataRslt: outData object where the field potential attributes
            %                  have been populated.
            
            processFieldPotentialSegmentation = segmentation.functions.processFieldPotentialSegmentation_f;
            rslt(1, length(initializedOutDataRslts)) = segmentation.model.outData;
            for i = 1:length(initializedOutDataRslts)
                rslt(i) = initializedOutDataRslts(i);
                if(initializedOutDataRslts(i).fpSection.processed == 0)
                    rslt(i).fpSection = processFieldPotentialSegmentation.processFieldWaveforms(initializedOutDataRslts(i).fpSection);
                elseif(initializedOutDataRslts(i).fpSection.processed == 1)
                    rslt(i).fpSection = initializedOutDataRslts(i).fpSection;
                end
            end
        end
        
        function rslt = processCSVFileName(fileName)
            % PROCESSCSVFILENAME Process CSV file names - from the fileName, determine
            % the correct resultant file name that will be created once segmentation is
            % complete.  If the input file name has a .h5 extension, two files will be
            % created: one for field potential, and one for action potential.  If the
            % input file name has a .mat file extension, only a action potential .csv
            % will be created.
            %
            % INPUT:
            %     fileName: The name of the file that will be processed.
            %
            % OUTPUT:
            %     [1] If the input file name had a .h5 extension.
            %          [a.] fileName_ap_processed_<date>.csv
            %          [b.] fileName_fp_processed_<date>.csv
            %     [2] If the input file name has a .mat file extension
            %          [a.] fileName_ap_converted_<date>.csv.
            %
            % EXCEPTION:
            %     [1] If the input file extension is not equal to .h5 or .csv
            
            if(~isempty(fileName) && ~isempty(regexp(fileName, '.h5', 'match')))
                rslt.actionPotentialCSV = [fileName(1:end - 6), 'ap_processed_', date '.csv'];
                rslt.fieldPotentialCSV = [fileName(1:end - 6), 'fp_processed_', date '.csv'];
            elseif (~isempty(fileName) && ~isempty(regexp(fileName, '.mat', 'match')))
                rslt.actionPotentialCSV = [fileName(1:end - 4) '_ap_converted_' date, '.csv'];
            else
                error('MATLAB:writeResults:incorrectBaselineFileType',...
                    segmentation.model.errorData.msgExperimentDataNoH5OrStruct);
            end
        end
        
        function finalFPData = processCSVFieldPotential(originalFileName, batch, experimentOutData)
            % PROCESSCSVFIELDPOTENTIAL Ready field potential data for printing - create a cell
            % that will contain the desired field potential elements.  If validateFieldData fails,
            % for a fieldData object, it will not be readied for printing.
            %
            % INPUT:
            %     originalFileName:     The original file name.
            %     batch:                The experiment batch number.
            %     experimentalOutData:  An outData object that is ready for printing.
            %
            % OUTPUT:
            %     A cell housing field potential attributes that is ready for printing.
            %
            % See also:
            %     validateFieldData
            
            dataIndex = 1;
            finalFPData = {};
            for i = 1:length(experimentOutData.fpSection.attributeData)
                if(~segmentation.model.experiments.validateFieldData(experimentOutData.fpSection.attributeData(1, i)))
                    continue;
                else
                    finalFPData{dataIndex, 1} = experimentOutData.experimentNum; % Experiment number
                    finalFPData{dataIndex, 2} = experimentOutData.wellElectrodeData.wellUIValue; % Well number.
                    finalFPData{dataIndex, 3} = experimentOutData.wellElectrodeData.electrodeUIValue; % Electrode.
                    finalFPData{dataIndex, 4} = experimentOutData.fpSection.attributeData(1, i).peakNum; % Peak number
                    finalFPData{dataIndex, 5} = experimentOutData.fpSection.attributeData(1, i).startTime; % Cycle start time
                    finalFPData{dataIndex, 6} = experimentOutData.fpSection.attributeData(1, i).stopTime; % Cycle stop time
                    finalFPData{dataIndex, 7} = experimentOutData.fpSection.attributeData(1, i).peakTime; % Peak time
                    finalFPData{dataIndex, 8} = experimentOutData.fpSection.attributeData(1, i).peakVoltage; % Peak Voltage
                    finalFPData{dataIndex, 9} = experimentOutData.fpSection.attributeData(1, i).absAmplitude; % Field potential amplitude
                    
                    % The last cycle length will always be empty.
                    if(isempty(experimentOutData.fpSection.attributeData(1, i).cycleLength))
                        finalFPData{dataIndex, 10} = NaN;
                    else
                        finalFPData{dataIndex, 10} = experimentOutData.fpSection.attributeData(1, i).cycleLength;
                    end
                    
                    % The last instantaneous frequency will always be empty.
                    if(isempty(experimentOutData.fpSection.attributeData(1, i).instantFrequency))
                        finalFPData{dataIndex, 11} = NaN;
                    else
                        finalFPData{dataIndex, 11} = experimentOutData.fpSection.attributeData(1, i).instantFrequency;
                    end
                    
                    finalFPData{dataIndex, 12} = experimentOutData.fpSection.attributeData(1, i).avgFrequency; % Average frequency
                    finalFPData{dataIndex, 13} = experimentOutData.fpSection.attributeData(1, i).slope; % Field potential slope.
                    finalFPData{dataIndex, 14} = originalFileName; % Original file name.
                    finalFPData{dataIndex, 15} = batch; % Batch name.
                    finalFPData{dataIndex, 16} = experimentOutData.version; % Version
                    dataIndex = dataIndex + 1;
                end
            end
        end
        
        function finalAPData = processCSVActionPotential(originalFileName, batch, experimentOutData)
            % PROCESSCSVACTIONPOTENTIAL Ready action potential data for printing - create
            % a cell that will contain the desired action potential elements.  If validatePeakData
            % fails for a peakData object, it will not be readied for printing.
            %
            % INPUT:
            %     originalFileName:     The original file name.
            %     batch:                The experiment batch number.
            %     experimentalOutData:  An outData object that is ready for printing.
            %
            % OUTPUT:
            %     A cell housing action potential attributes that is ready for printing.
            %
            % See also:
            %     validatePeakData
            
            dataIndex = 1;
            finalAPData = {};
            for i = 1:length(experimentOutData.apSection.attributeData)
                if(~segmentation.model.experiments.validatePeakData(experimentOutData.apSection.attributeData(1, i).peakData))
                    continue;
                else
                    finalAPData{dataIndex, 1} = experimentOutData.experimentNum; % Experiment number
                    finalAPData{dataIndex, 2} = experimentOutData.wellElectrodeData.wellUIValue; % Well number.
                    finalAPData{dataIndex, 3} = experimentOutData.wellElectrodeData.electrodeUIValue; % Electrode.
                    finalAPData{dataIndex, 4} = experimentOutData.apSection.attributeData(1, i).peakNum; % apdData - Peak number.
                    finalAPData{dataIndex, 5} = experimentOutData.apSection.attributeData(1, i).absAmplitude; % apdData - Amplitude.
                    finalAPData{dataIndex, 6} = experimentOutData.apSection.attributeData(1, i).peakData.a20; % apdData - peakData - a20.
                    finalAPData{dataIndex, 7} = experimentOutData.apSection.attributeData(1, i).peakData.a30; % apdData - peakData - a30.
                    finalAPData{dataIndex, 8} = experimentOutData.apSection.attributeData(1, i).peakData.a40; % apdData - peakData - a40.
                    finalAPData{dataIndex, 9} = experimentOutData.apSection.attributeData(1, i).peakData.a50; % apdData - peakData - a50.
                    finalAPData{dataIndex, 10} = experimentOutData.apSection.attributeData(1, i).peakData.a60; % apdData - peakData - a60.
                    finalAPData{dataIndex, 11} = experimentOutData.apSection.attributeData(1, i).peakData.a70; % apdData - peakData - a70.
                    finalAPData{dataIndex, 12} = experimentOutData.apSection.attributeData(1, i).peakData.a80; % apdData - peakData - a80.
                    finalAPData{dataIndex, 13} = experimentOutData.apSection.attributeData(1, i).peakData.a90; % apdData - peakData - a90.
                    finalAPData{dataIndex, 14} = experimentOutData.apSection.attributeData(1, i).peakData.apdRatio; % apdData - peakData - apdRatio.
                    finalAPData{dataIndex, 15} = experimentOutData.apSection.attributeData(1, i).peakData.apdDiff; % apdData - peakData - apdDiff.
                    finalAPData{dataIndex, 16} = experimentOutData.apSection.attributeData(1, i).peakData.triang; % apdData - triangulation.
                    finalAPData{dataIndex, 17} = experimentOutData.apSection.attributeData(1, i).peakData.frac; % apdData - fractional repolarization
                    
                    % The first cycle's attenuation will always be
                    % empty.
                    if(isempty(experimentOutData.apSection.attributeData(1, i).attenuation))
                        finalAPData{dataIndex, 18} = NaN;
                    else
                        finalAPData{dataIndex, 18} = experimentOutData.apSection.attributeData(1, i).attenuation; % apdData - attenuation
                    end
                    
                    % The last cycle's cycle length will always be
                    % empty.
                    if(isempty(experimentOutData.apSection.attributeData(1, i).cycleLength))
                        finalAPData{dataIndex, 19} = NaN;
                    else
                        finalAPData{dataIndex, 19} = experimentOutData.apSection.attributeData(1, i).cycleLength; % apdData - attenuation
                    end
                    
                    % The last cycle will always have a blank
                    % instantaneous frequency.
                    if(isempty(experimentOutData.apSection.attributeData(1, i).instantFrequency))
                        finalAPData{dataIndex, 20} = NaN;
                    else
                        finalAPData{dataIndex, 20} = experimentOutData.apSection.attributeData(1, i).instantFrequency; % apdData - instant frequency.
                    end
                    
                    % There are circumstances when conversion_f is called,
                    % this attribute will not be populated.
                    if(isempty(experimentOutData.apSection.attributeData(1, i).avgFrequency))
                        finalAPData{dataIndex, 21} = NaN;
                    else
                        finalAPData{dataIndex, 21} = experimentOutData.apSection.attributeData(1, i).avgFrequency; % apdData - average frequency.
                    end
                    
                    % The first cycle will always have a blank
                    % diastolic interval.
                    if(isempty(experimentOutData.apSection.attributeData(1, i).diastolicInterval))
                        finalAPData{dataIndex, 22} = NaN;
                    else
                        finalAPData{dataIndex, 22} = experimentOutData.apSection.attributeData(1, i).diastolicInterval; % apdData - diastolic interval.
                    end
                    
                    finalAPData{dataIndex, 23} = convertCharsToStrings(experimentOutData.medicationName); % Medication name.
                    finalAPData{dataIndex, 24} = convertCharsToStrings(experimentOutData.medicationConcen); % Medication concentration.
                    finalAPData{dataIndex, 25} = experimentOutData.apSection.attributeData(1, i).peakTime; % apdData - peak time.
                    finalAPData{dataIndex, 26} = experimentOutData.apSection.attributeData(1, i).startTime; % apdData - start time.
                    finalAPData{dataIndex, 27} = experimentOutData.apSection.attributeData(1, i).stopTime; % apdData - stop time.
                    finalAPData{dataIndex, 28} = experimentOutData.apSection.leftCursorLoc; % outData - left cursor position.
                    finalAPData{dataIndex, 29} = experimentOutData.apSection.rightCursorLoc; % outData - right cursor position.
                    finalAPData{dataIndex, 30} = originalFileName; % Original file name.
                    finalAPData{dataIndex, 31} = batch; % Batch name.
                    finalAPData{dataIndex, 32} = experimentOutData.version; % Version
                    dataIndex = dataIndex + 1;
                end
            end
        end
        
        function writeResults(fileName, experimentOutData)
            % WRITERESULTS Write to .csv - save the fieldData and apdData attritubes to .csv.
            % If the apOmit status is set to 1, the action potential attributes will not be saved.
            % Similiar, if the fpOmit status is set to 1, the field potential attributes will not be
            % saved.
            %
            % INPUT:
            %     fileName: The original name of the file.
            %     experimentOutData: An outData object that is ready to be saved to .csv.
            
            finalAP = [];
            finalFP = [];
            processedFileName = segmentation.model.experiments.processCSVFileName(fileName);
            batchName = regexp(fileName,'M[0-9]{6}', 'match');
            for i = 1:length(experimentOutData)
                if(experimentOutData(i).apSection.omit == 0)
                    finalAP = [finalAP; segmentation.model.experiments.processCSVActionPotential(fileName, batchName, experimentOutData(i))];
                end
                
                if(experimentOutData(i).fpSection.omit == 0)
                    finalFP = [finalFP; segmentation.model.experiments.processCSVFieldPotential(fileName, batchName, experimentOutData(i))];
                end
            end
            
            if(~isempty(finalAP))
                apTableToWrite = cell2table(finalAP, 'VariableNames', segmentation.model.experiments.apColumnNames);
                writetable(apTableToWrite, processedFileName.actionPotentialCSV);
            end
            
            if(~isempty(finalFP))
                fpTableToWrite = cell2table(finalFP, 'VariableNames', segmentation.model.experiments.fpColumnNames);
                writetable(fpTableToWrite, processedFileName.fieldPotentialCSV);
            end
        end
        
        function rslt = validatePeakData(peakData)
            % VALIDATEPEAKDATA Validate the peakData object - the peakData object should have
            % all of the following attibutes populated to be classified as valid.
            %      [1] Each repolarization interval (a20, a30, etc.).
            %      [2] Action potential duration ratio, difference, triangulation, and
            %      fractional repolarization.
            %
            % INPUT:
            %     peakData:  A peakData object.
            %
            % OUTPUT:
            %     1 if valid, 0 if invalid.
            
            if(isempty(peakData))
                rslt = false;
            elseif(isempty(peakData.a20) || isempty(peakData.a30) || isempty(peakData.a40)...
                    || isempty(peakData.a50) || isempty(peakData.a60) || isempty(peakData.a70)...
                    || isempty(peakData.a80) || isempty(peakData.a90) || isempty(peakData.apdRatio...
                    || isempty(peakData.apdDiff) || isempty(peakData.triang) || isempty(frac)))
                rslt = false;
            else
                rslt = true;
            end
        end
        
        function rslt = validateFieldData(fieldData)
            % VALIDATEFIELDDATA Validate the fieldData object - the fieldData object should have
            % all of the following attributes populated to be classificed as valid.
            %     [1] Amplitude, instant frequency, average frequency, and slope.
            %
            % INPUT:
            %     fieldData: A fieldData object.
            %
            % OUTPUT:
            %     1 if valid, 0 if invalid.
            
            if(isempty(fieldData))
                rslt = false;
            elseif(isempty(fieldData.absAmplitude) || isempty(fieldData.instantFrequency)...
                    || isempty(fieldData.avgFrequency) || isempty(fieldData.slope))
                rslt = false;
            else
                rslt = true;
            end
        end
        
        function [apOmitCount, fpOmitCount] = omitOutDataCount(experimentOutData)
            % OMITOUTDATACOUNT Omit counts - for an array of outDataRslts,
            % determine the number of instances of field/action potentials
            % that have been omitted.  If the at any index within the array
            % the omit value is empty, a warning will be displayed to the user
            % and the apOmit or fpOmit count will be set to NaN.
            %
            % INPUT:
            %     experimentOutData:  An array of outDataRslts
            %
            % OUTPUT:
            %     The number of outDataRslt field/action potential objects that
            %     have been omitted.
            %
            % WARNING:
            %     [1] If there has been an initialized omit status.
            
            apOmitCount = 0;
            fpOmitCount = 0;
            for i = 1:length(experimentOutData)
                if (isempty(experimentOutData(i).apOmit))
                    warning(segmentation.model.errorData.msgExperimentApOmitNotDetected);
                    apOmitCount = NaN;
                end
                
                if(isempty(experimentOutData(i).fpOmit))
                    warning(segmentation.model.errorData.msgExperimentFpOmitNotDetected);
                    fpOmitCount = NaN;
                end
                
                if (all(experimentOutData(i).apOmit == 1) && ~isnan(apOmitCount))
                    apOmitCount = apOmitCount + 1;
                end
                
                if(all(experimentOutData(i).fpOmit == 1) && ~isnan(fpOmitCount))
                    fpOmitCount = fpOmitCount + 1;
                end
            end
        end
    end
    
    methods
        function obj = experiments(wellElectrodeData, allExperimentData,...
                allExperimentTime, allElectroporationStop, wellIDs, electrodeIDs,...
                recordStart, recordStop, allExperimentVoltage)
            % experiments Constructor
            
            obj.wellElectrodeData = wellElectrodeData;
            obj.allExperimentData = allExperimentData;
            obj.allExperimentTime = allExperimentTime;
            obj.allElectroporationStop = allElectroporationStop;
            obj.wellIDs = wellIDs;
            obj.electrodeIDs = electrodeIDs;
            obj.recordStart = recordStart;
            obj.recordStop = recordStop;
            obj.allExperimentVoltage = allExperimentVoltage;
            obj.outDataRslt = processExperiments(obj);
        end
        
        function rslt = processExperiments(obj)
            % PROCESSEXPERIMENTS Iterate through each experiment and
            % initialize each outDataRslt object.  If multiple experiments
            % are available for a well/electrode combination, there will be
            % multiple outDataRslt(s).
            %
            % OUTPUT:
            %     outDataRslt:  outDataRslt object for each experiment
            %                   for a well/electrode combination.
            
            % Preallocate - speed increase.
            rslt(1, length(obj.recordStart)) = segmentation.model.outData;
            for i=1:length(obj.recordStart)
                low = experimentRecordingLow(obj, i);
                high = experimentRecordingHigh(obj, i);
                rslt(i) = segmentation.model.outData(i,...
                    obj.allExperimentTime(low & high),...
                    obj.allExperimentVoltage(low & high),...
                    experimentElectroporationStop(obj, low, high),...
                    i,...
                    obj.wellElectrodeData);
            end
        end
        
        function rslt = experimentRecordingLow(obj, i)
            %TODO: Comments
            
            rslt = obj.allExperimentTime >= obj.recordStart(i);
        end
        
        function rslt = experimentRecordingHigh(obj, i)
            %TODO: Comments
            
            rslt = obj.allExperimentTime <= obj.recordStop(i);
        end
        
        function rslt = experimentElectroporationStop(obj, low, high)
            %TODO: Comments
            
            rslt = obj.allElectroporationStop(...
                obj.allElectroporationStop >= min(obj.allExperimentTime(low)) &...
                obj.allElectroporationStop <= max(obj.allExperimentTime(high)));
        end
    end
end

