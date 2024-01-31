function functionHandles = readH5_f
% READH5_F Read an H5 file.
%
% See also:
% readH5_f>read
%
% Author: Jonathan Cook
% Created: 2018-12-21

functionHandles.read = @read;
end

function read(handles)
% READ Read into the application an h5 file using the Mcs library.
%
% INPUT:
%    handles:  A structure with handles and user data from the main user
%              interface.
%
% See also:
% readH5_f>read

import +McsHDF5.*
addpath(strcat(pwd,'/McsMatlabDataTools_1.0.3/McsMatlabDataTools/'));

% Restrict the file type to .h5 only.
[fileName, filePath] = uigetfile({'*.h5', 'H5 File (*.h5)'}, 'Select a single .h5 file');

% If 'cancel' is selected, the fileName and filePath return as a 0 (double), else str.  The char
% conversion will either be empty or the actual fileName and filePath.
fileName = char(fileName);
filePath = char(filePath);

if(~isempty(fileName) || ~isempty(filePath))
    handles.h5FileNameText.String = fileName;
    handles.directoryText.String = filePath;
    
    data = McsHDF5.McsData(strcat(filePath, filesep, fileName));
    [~, distinctWells] = segmentation.functions.distinctWell_f(data.Recording{1}.AnalogStream{1}.Info.GroupID);
    
    % Make available within the figure.
    setappdata(handles.waveformAnalysisFigure, 'h5FileName', fileName);
    setappdata(handles.waveformAnalysisFigure, 'h5FilePath', filePath);
    setappdata(handles.waveformAnalysisFigure, 'h5Data', data);
    setappdata(handles.waveformAnalysisFigure, 'h5DistinctWells', distinctWells);
    setappdata(handles.waveformAnalysisFigure, 'saveDirectory', filePath);
else
    warning(segmentation.model.errorData.msgNoH5Selection);
end
end