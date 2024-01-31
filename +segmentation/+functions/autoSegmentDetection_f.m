function functionHandles = autoSegmentDetection_f
% Comments

functionHandles.apFPCursors = @apFPCursors;
end

function apFPCursors(mainFigure, plotHandles, outDataRslt)
% Comments

fp = segmentation.functions.processFieldPotentialSegmentation_f;
ap = segmentation.functions.processActionPotentialSegmentation_f;

fpTimesLogical = logical(outDataRslt.time < outDataRslt.esub(1));
apTimesLogical = logical(logical(outDataRslt.time > outDataRslt.esub(end) + 5) ...
    .* logical(outDataRslt.time < outDataRslt.esub(end) + 15));

fpTime = outDataRslt.time(fpTimesLogical);
fpVoltage = outDataRslt.voltage(fpTimesLogical);
[fpCycleTime, fpCycleVoltage] = fp.identifyCycleStopTimePoints(fpTime, fpVoltage);

apTime = outDataRslt.time(apTimesLogical);
apVoltage = outDataRslt.voltage(apTimesLogical);
[apCycleTime, apCycleVoltage] = ap.identifyCycleStopTimePoints(apTime, apVoltage);

cursorMode = datacursormode(mainFigure);
if(~isempty(fpCycleTime) && ~isempty(fpCycleVoltage))
    hDatatip(1) = cursorMode.createDatatip(plotHandles);
    pos = [fpCycleTime(1) fpCycleVoltage(1) 1];
    set(hDatatip(1), 'Position', pos);
    
    hDatatip(2) = cursorMode.createDatatip(plotHandles);
    pos = [fpCycleTime(end) fpCycleVoltage(end) 1];
    set(hDatatip(2), 'Position', pos);
end

if(~isempty(apCycleTime) && ~isempty(apCycleVoltage))
    hDatatip(3) = cursorMode.createDatatip(plotHandles);
    pos = [apCycleTime(1) apCycleVoltage(1) 1];
    set(hDatatip(3), 'Position', pos);
    
    hDatatip(4) = cursorMode.createDatatip(plotHandles);
    pos = [apCycleTime(end) apCycleVoltage(end) 1];
    set(hDatatip(4), 'Position', pos);
    updateDataCursors(cursorMode);
end
end