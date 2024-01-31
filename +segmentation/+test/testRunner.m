% Script to run all the test methods in the 'test' folder.  If the file
% has test in the name, it will be automatically included in the test suite.
% The test results are output to the MATLAB console.
%
% Author:  Jonathan Cook
% Created: 2018-09-25

toTest = matlab.unittest.TestSuite.fromPackage('segmentation.test', ...
    'IncludeSubpackages', ...
    true, ...
    'Name', ...
    '*Test*');
results = run(toTest);

% Logical array of results.
state = [results.Passed];
failedResults = results(state == 0);

if(isempty(failedResults))
    table(results)
    fprintf('All test conditions [%d] have passed!\n', length(state));
else
    % Print the results to console.
    failedResults;
end
