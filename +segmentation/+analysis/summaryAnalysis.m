function summaryAnalysis(fileDir)
% SUMMARYANALYSIS File aggregation with plot - read in all the files within the 
% present in the fileDir parameter that has a file extension of .csv.  Call
% analysis functions to produce a baseline analysis of the experiment.
%
% INPUT:
%     fileDir:  The file directory where the .csv's are located.

% Read in all the files with a .csv extension.
dataStore = tabularTextDatastore(fileDir, 'FileExtensions', '.csv');
dataStoreTable = readall(dataStore);

% Call plotting scripts to create figures for a quick baseline
% analysis.
constructs(dataStoreTable);
wellAttributes(dataStoreTable);
batchAttributes(dataStoreTable);
end