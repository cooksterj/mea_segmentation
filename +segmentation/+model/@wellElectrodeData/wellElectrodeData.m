classdef wellElectrodeData < handle
    % WELLELECTRODEDATA well/electrode meta data class.
    %   Each well and electrode combination will be coded to represent their UI value
    %   as well as the value used by the user interface.
    %
    % Author:  Jonathan Cook
    % Created: 2018-10-12
    
    properties
        wellElectrodeID         % ID to identify the well/electrode combination.
        wellUIValue             % The well value as represented by the user interface.
        wellStrLabel            % The well value as represented by the checkbox label.
        wellLogicalVector       % A logical vector of well values.
        electrodeUIValue        % The electrode value as represented in the user interface.
        electrodeStrLabel       % The electrode value as represented by the checkbox label.
        electrodeLogicalVector  % A logical vector of electrode values.
        medicationName          % Medication name.
        medicationConcentration % Medication concentration.
        processed               % Processed indicator.
    end
    
    properties (Constant)
        % Well and electrode mappings - should never change unless the UI waveformAnalysis.m
        % changes.
        wellMapping = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23];
        wellLabel = ["A1" "A2" "A3" "A4" "A5" "A6" "B1" "B2" "B3" "B4" "B5" "B6" "C1" "C2" "C3" "C4" "C5" "C6" "D1" "D2" "D3" "D4" "D5" "D6"];
        electrodeMapping = [12 13 21 22 23 24 31 32 33 34 42 43];
        electrodeLabel = ["12", "13", "21", "22", "23", "24", "31", "32", "33", "34", "42", "43"];
    end
    
    methods (Static)
        function rslt = maxWellElectrodeID(wellElectrodeDataArray)
            for i = 1:length(wellElectrodeDataArray)
                tempID(i) = wellElectrodeDataArray(i).wellElectrodeID;
            end
            rslt = max(tempID);
        end
    end
    
    methods
        function obj = wellElectrodeData(id, wellLogical, electrodeLogical)
            % WELLELECTRODEDATA Constructor - during instantiation, each well and electrode attribute
            % attribute will be determined from the input logical array.
            %
            % INPUT:
            %     wellLogical:       A logical vector representing the well selectionm - from the UI.
            %     electrodeLogical:  A logical vector representing the electrode selection - from the UI.
            %
            % OUTPUT:
            %      Initialized wellElectrodeData object - with all of the attributes set.
            
            if nargin > 0
                obj.wellElectrodeID = id;
                obj.wellLogicalVector = wellLogical;
                obj.electrodeLogicalVector = electrodeLogical;
                obj.medicationName = "No Medication";
                obj.medicationConcentration = "No Concentration";
                
                [wellUIValue, wellLabel] = wellValueAndLabel(obj, obj.wellLogicalVector);
                obj.wellStrLabel = wellLabel;
                obj.wellUIValue = wellUIValue;
                
                [electrodeUIValue, electrodeLabel] = electrodeValueAndLabel(obj, obj.electrodeLogicalVector);
                obj.electrodeUIValue = electrodeUIValue;
                obj.electrodeStrLabel = electrodeLabel;
                obj.processed = false;
            end
        end
        
        function [wellUIValue, wellLabel] = wellValueAndLabel(obj, wellLogicalVector)
            % WELLVALUEANDLABEL Well value and label - from the logical vector, determine the UI label
            % and the string equalivalent.
            %
            % INPUT:
            %     wellLogicalVector:  A logical vector representing the well selection from the UI.
            %
            % OUTPUT:
            %     wellUIValue:  The well user interfact value.
            %     wellLabel:    The well string value.
            %
            % EXCEPTION:
            %     [1] If the wellLogicalVector is empty.
            %     [2] If the wellLogicalVector is not the same size as the wellMapping property.
            %     [3] If the indexing between the wellMapping and the wellLogicalVector is incorrect.
            
            try
                if(isempty(wellLogicalVector))
                    error('MATLAB:wellElectrodeData:wellLogicalVectorEmpty', ...
                        segmentation.model.errorData.msgWellLogicArrayEmpty);
                elseif(length(wellLogicalVector) ~= length(obj.wellMapping))
                    error('MATLAB:wellElectrodeData:wellLogicalVectorIncorrectSize', ...
                        segmentation.model.errorData.msgWellLogicArrayIncorrectSize);
                else
                    wellUIValue = obj.wellMapping(wellLogicalVector == 1);
                    wellLabel = obj.wellLabel(wellLogicalVector == 1);
                end
            catch me
                causeException = MException('MATLAB:wellElectrodeData:wellLogicalVectorError', ...
                    segmentation.model.errorData.msgWellSelectionUIGeneral);
                me = addCause(me, causeException);
                rethrow(me);
            end
        end
        
        function [electrodeUIValue, electrodeLabel] = electrodeValueAndLabel(obj, electrodeLogicalVector)
            % ELECTRODEVALUEANDLABEL Electrode value and label - from the logical vector, determine the UI label
            % and the string equalivalent.
            %
            % INPUT:
            %     electrodeLogicalVector:  A logical vector representing the electrode selection from the UI.
            %
            % OUTPUT:
            %     electrodeUIValue:  The well user interfact value.
            %     electrodeLabel:    The well string value.
            %
            % EXCEPTION:
            %     [1] If the electrodeLogicalVector is empty.
            %     [2] If the electrodeLogicalVector is not the same size as the electrodeMapping property.
            %     [3] If the indexing between the electrodeMapping and the electrodeLogicalVector is incorrect.
            
            try
                if(isempty(electrodeLogicalVector))
                    error('MATLAB:wellElectrodeData:electrodeLogicalVectorEmpty', ...
                        segmentation.model.errorData.msgElectrodeLogicArrayEmpty);
                elseif(length(electrodeLogicalVector) ~= length(obj.electrodeMapping))
                    error('MATLAB:wellElectrodeData:electrodeLogicalVectorIncorrectSize', ...
                        segmentation.model.errorData.msgElectrodeLogicArrayIncorrectSize);
                else
                    electrodeUIValue = obj.electrodeMapping(electrodeLogicalVector == 1);
                    electrodeLabel = obj.electrodeLabel(electrodeLogicalVector == 1);
                end
            catch me
                causeException = MException('MATLAB:wellElectrodeData:electrodeLogicalVectorError', ...
                    segmentation.model.errorData.msgElectrodeSelectionUIGeneral);
                me = addCause(me, causeException);
                rethrow(me);
            end
        end
    end
end
