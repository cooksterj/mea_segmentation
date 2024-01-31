classdef wellElectrodeTest < matlab.unittest.TestCase
    % WELLELECTRODETEST - Test class for the wellElectrodeData.m object file
    %
    % Author:  Jonathan Cook
    % Created: 2018-10-29
    
    methods(Test)
        function wellValueAndLabel_valid(testCase)
            % WELLVALUEANDLABEL_VALID - verify the wellUIValue and wellLabel are correctly
            % assigned for the provided well logical array.
            
            % Second position in the logic array = A2.
            wellElectrode = segmentation.model.wellElectrodeData;
            wellLogical = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            
            [wellUIValue, wellLabel] = wellElectrode.wellValueAndLabel(wellLogical);
            
            % Verify the second position is equal to a UI value of 1 and a lable of 'A2'.
            verifyEqual(testCase, wellUIValue, 1);
            verifyEqual(testCase, wellLabel, "A2");
        end
        
        function wellValueAndLabel_incorrectLogicArraySize(testCase)
            % WELLVALUEANDLABEL_INCORRECTLOGICARRAYSIZE - verify an exception is thrown due
            % to an incorrect well logic array size.
            
            wellElectrode = segmentation.model.wellElectrodeData;
            wellLogical = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            
            % Verify the correct exception is thrown - incorrect subscript due to an incorrect logic array.
            testCase.verifyError(@()wellElectrode.wellValueAndLabel(wellLogical), 'MATLAB:wellElectrodeData:wellLogicalVectorIncorrectSize');
        end
        
        
        function wellValueAndLabel_blankLogicArray(testCase)
            % WELLVALUEANDLABEL_BLANKLOGICARRAY - verify an exception is thrown due to a blank
            % well logic array.
            
            % Second position in the logic array = A2.
            wellElectrode = segmentation.model.wellElectrodeData;
            
            % Verify the correct exception is thrown - incorrect subscript due to an incorrect logic array.
            testCase.verifyError(@()wellElectrode.wellValueAndLabel([]), 'MATLAB:wellElectrodeData:wellLogicalVectorEmpty');
        end
        
        function electrodeValueAndLabel_valid(testCase)
            % ELECTRODEVALUEANDLABEL_VALID - verify the electrodeUIValue and electrodeLabel are corretly
            % assigned for the provided electrode logical array.
            
            wellElectrode = segmentation.model.wellElectrodeData;
            electrodeLogical = [0 1 0 0 0 0 0 0 0 0 0 0];
            
            [electrodeUIValue, electrodeLabel] = wellElectrode.electrodeValueAndLabel(electrodeLogical);
            
            % Verify the second position is equal to a UI value of 1 and a lable of 'A2'.
            verifyEqual(testCase, electrodeUIValue, 13);
            verifyEqual(testCase, electrodeLabel, "13");
        end
        
        function electrodeValueAndLabel_incorrectLogicArraySize(testCase)
            % ELECTRODEVALUEANDLABEL_INCORRECTLOGICARRAYSIZE - verify an exception is thrown due an incorrect
            % electrode logic array size.
            
            wellElectrode = segmentation.model.wellElectrodeData;
            electrodeLogical = [0 1 0 0 0 0 0 0 0 0 0 0 0 0];
            
            % Verify the correct exception is thrown - incorrect subscript due to an incorrect logic array.
            testCase.verifyError(@()wellElectrode.electrodeValueAndLabel(electrodeLogical), 'MATLAB:wellElectrodeData:electrodeLogicalVectorIncorrectSize');
        end
        
        function electrodeValueAndLabel_blankElectrodeLogicArray(testCase)
            % ELECTRODEVALUEANDLABEL_BLANKELECTRODELOGICARRAY - verify an exception is thrown for a blank
            % electrode logic array.
            
            % Second position in the logic array = A2.
            wellElectrode = segmentation.model.wellElectrodeData;
            
            % Verify the correct exception is thrown - incorrect subscript due to an incorrect logic array.
            testCase.verifyError(@()wellElectrode.electrodeValueAndLabel([]), 'MATLAB:wellElectrodeData:electrodeLogicalVectorEmpty');
        end
        
        function wellElectrodeData_valid(testCase)
            % WELLELECTRODEDATA_VALID - verify the correct well and electrode attributes
            % after wellElectrodeData instantiation.
            
            wellLogical = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            electrodeLogical = [0 1 0 0 0 0 0 0 0 0 0 0];
            id = 1;
            
            actualWellElectrodeData = segmentation.model.wellElectrodeData(id, wellLogical, electrodeLogical);
            
            verifyEqual(testCase, actualWellElectrodeData.wellElectrodeID, 1);
            verifyEqual(testCase, actualWellElectrodeData.wellUIValue, 1);
            verifyEqual(testCase, actualWellElectrodeData.wellStrLabel, "A2");
            verifyEqual(testCase, actualWellElectrodeData.electrodeUIValue, 13);
            verifyEqual(testCase, actualWellElectrodeData.electrodeStrLabel, "13");
            verifyEqual(testCase, actualWellElectrodeData.medicationName, "No Medication");
            verifyEqual(testCase, actualWellElectrodeData.medicationConcentration, "No Concentration");
            verifyEqual(testCase, actualWellElectrodeData.processed, false);
        end
    end
end

