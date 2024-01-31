classdef distinctWellTest < matlab.unittest.TestCase
    % DISTINCTWELLTEST - Test class for the distinctWell_f function.
    %
    % Author:  Jonathan Cook
    % Created: 2018-05-08
    
    methods(Test)
        function uniqueness_singleValues(testCase)
            % UNIQUENESS_SINGLEVALUES Duplicate inputs get reduced to
            % a single value.
            
            expected = 1;
            actual = length(segmentation.functions.distinctWell_f([1, 1, 1]));
            verifyEqual(testCase, actual, expected);
        end
        
        function uniqueness_multipleValues(testCase)
            % UNIQUENESS_MULTIPLEVALUES Duplicate inputs get
            % reduced to a size of three.
            
            expected = 3;
            actual = length(segmentation.functions.distinctWell_f([1, 2, 2, 3, 3, 3]));
            verifyEqual(testCase, actual, expected);
        end
        
        function uniqueness_withoutDuplicates(testCase)
            % UNIQUENESS_WITHOUTDUPLICATES Non-duplicates are preserved.
            
            expected = 3;
            actual = length(segmentation.functions.distinctWell_f([1, 2, 3]));
            verifyEqual(testCase, actual, expected);
        end
        
        function wellMapping_single(testCase)
            % WELLMAPPING_SINGLE Single well mapping for a single input.
            
            expected = {'A2'};
            [~, actual] = segmentation.functions.distinctWell_f(1);
            verifyEqual(testCase, actual, expected)
        end
        
        function wellMapping_multiple(testCase)
            % wellMapping_multiple Multiple well mapping for three
            % inputs.
            
            expected = {'A1', 'A2', 'A3'};
            [~, actual] = segmentation.functions.distinctWell_f([0, 1, 2]);
            verifyEqual(testCase, actual, expected)
        end
    end
end