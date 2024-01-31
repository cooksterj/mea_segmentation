% Script to convert old data structures (pre v1.0) to the most
% current data structure.  Two files will be generated per conversion.
%     [1] A .csv action potential summary
%     [2] A .mat structure
% They will be saved in the current working directory.  

conversionHandles = segmentation.convert.conversion_f;
[toConvertFileName, toConvertPath] = uigetfile(cd, 'Select an structure [.mat] to convert', '*', 'MultiSelect', 'on');

toConvertFileName = cellstr(toConvertFileName);
for i = 1:length(toConvertFileName)
    fprintf("Loading and converting %d out of %d structure(s)... \n", i, length(toConvertFileName));
    structureToConvert = load([toConvertPath, toConvertFileName{i}]);
    conversionHandles.convert(structureToConvert.outdata, toConvertFileName{i}, []);
end
sprintf("Finished conversion");