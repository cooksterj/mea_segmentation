function functionHandles = conversion_f
% conversion Convert v1.0 structures to post v.10 structures.
%
% This conversion should only be used to analyze old structures.  It will
% create a new .mat file and .csv summary file.  Both the .csv and .mat file
% will have a _converted_ appened to the file name with date.  The
% .mat structures will contain omitted and non-omitted data; however, omits
% will not be present in the .csv summary.
%
% See also:
% conversion_f>convert [main]
% conversion_f>convertAPD
% conversion_f>convertPeakData
%
% Author:  Jonathan Cook
% Created On: 2018-07-20

functionHandles.convert = @convert;
functionHandles.convertAPD = @convertAPD;
functionHandles.convertPeakData = @convertPeakData;
end

function convert(oldStruct, fileName, fileDirectory)
% CONVERT MATLAB structures that were previously created post v1.0 will be
% converted to MATLAB structures post v1.0 - to the current version.
%
% If the input oldStruct is empty, the output(s) will be empty.
%
% INPUT:
%     oldStruct:         The structure that will be converted.
%     fileName:          The name of the file - with absolute location.
%     fileDirectory:     The directory where the converted files will be
%                        saved.

processedFileName = [fileName(1:end - 4), '_converted_', date, '.csv'];
if(isempty(fileDirectory))
    processedFileDirectory = pwd;
else
    processedFileDirectory = fileDirectory;
end

if(isempty(oldStruct))
    outDataStruct = [];
else
    for i = 1:length(oldStruct)
        wellElectrode = segmentation.model.wellElectrodeData();
        wellLogical = wellElectrode.wellMapping == oldStruct(i).well;
        electrodeLogical = wellElectrode.electrodeMapping == oldStruct(i).electrode;
        wellElectrode = segmentation.model.wellElectrodeData(1, wellLogical, electrodeLogical);
        
        outDataStruct(i) = segmentation.model.outData(oldStruct(i).Index, ...
            oldStruct(i).Time, ...
            oldStruct(i).Volt, ...
            oldStruct(i).esub, ...
            oldStruct(i).exp_num, ...
            wellElectrode);
        outDataStruct(i).apProcessed = oldStruct(i).chk;
        outDataStruct(i).apOmit = oldStruct(i).omit;
        outDataStruct(i).apVoltageSegment = oldStruct(i).vsub;
        outDataStruct(i).apTimeSegment = oldStruct(i).tsub;
        outDataStruct(i).apLeftCursorLoc = oldStruct(i).tleft;
        outDataStruct(i).apRightCursorLoc = oldStruct(i).tright;
        outDataStruct(i).apdData = convertAPD(oldStruct(i));
    end
    segmentation.model.experiments.writeResults([processedFileDirectory filesep fileName], outDataStruct);
end
structureFileName = [processedFileDirectory, filesep, processedFileName(1:end - 4)];
save(structureFileName, 'outDataStruct');
end

function rslt = convertAPD(oldOutData)
% CONVERTAPD Convert the apd data to an apdData object.
%
% INPUT:
%     oldOutData: Old out data that contains the action potential durations
%                 which will be converted.
%
% OUTPUT:
%     rslt: A apdData object
%
% See also:
% apdData [output]

if(isempty(oldOutData.apd))
    rslt = [];
else
    for i = 1:length(oldOutData.apd)
        rslt(i) = segmentation.model.apdData();
        rslt(i).peakNum = oldOutData.apd(i).peak_num;
        rslt(i).startTime = oldOutData.apd(i).st_time;
        rslt(i).stopTime = oldOutData.apd(i).stop_time;
        rslt(i).peakTime = oldOutData.apd(i).peak_time;
        rslt(i).peakVoltage = oldOutData.apd(i).pk_vtg;
        rslt(i).absAmplitude = oldOutData.apd(i).abs_amp;
        rslt(i).absAmplitude = oldOutData.apd(i).abs_amp;
        rslt(i).timeScale = oldOutData.apd(i).tscale;
        rslt(i).voltageScale = oldOutData.apd(i).vscale;
        rslt(i).peakData = convertPeakData(oldOutData.peak(i));
        
        if(oldOutData.apd(i).peak_num == 1)
            rslt(i).attenuation = [];
        else
            rslt(i).attenuation = oldOutData.apd(i).atten;
        end
    end
end
end

function rslt = convertPeakData(oldPeak)
% CONVERTPEAKDATA Convert the peak data into a peakData object.
%
% INPUT:
%     oldPeak: Old peak data that will be converted.
%
% OUTPUT:
%     rslt: A peakData object.
%
% See also:
% peakData

rslt = segmentation.model.peakData();
rslt.apdRatio = oldPeak.apd_ratio;
rslt.apdDiff = oldPeak.apd_diff;
rslt.triang = oldPeak.triang;
rslt.frac = oldPeak.frac;
rslt.a20 = oldPeak.A20;
rslt.a30 = oldPeak.A30;
rslt.a40 = oldPeak.A40;
rslt.a50 = oldPeak.A50;
rslt.a60 = oldPeak.A60;
rslt.a70 = oldPeak.A70;
rslt.a80 = oldPeak.A80;
rslt.a90 = oldPeak.A90;
end