function [outVec, outCharVec] = distinctWell_f(input)
% DISTINCTWELL_F Identification of experiment well annotation for a given integer
% represented in the raw .h5 file.
%
% INPUTS:
%     input: Integer value that represents a well.
%
% OUTPUTS:
%     outVec:         The mapped integer representation of the value used to lookup
%                     internally what the alphanumeric value should be.
%     outCharVec:     The alphanumeric representation (well identifier) of the input
%                     integer.
%
% Author(s): Don Conrad (original)
%            Jonathan Cook (refactored)
%
% Created:   Unknown (original)

if(~isnumeric(input))
    error(segmentation.model.errorData.msgDistinctWellNonNumeric)
else
    outVec = unique(input);
    outVec = outVec + 1;
    charVec = {
        'A1','A2','A3','A4','A5','A6', ...
        'B1','B2','B3','B4','B5','B6', ...
        'C1','C2','C3','C4','C5','C6', ...
        'D1','D2','D3','D4','D5','D6'};
    outCharVec = charVec(outVec);
end
end