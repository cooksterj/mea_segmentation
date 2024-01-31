function functionHandles = signalQCCursor_f
% signalQCCursor_f TODO: Comments

functionHandles.fpAPCursorPositions = @fpAPCursorPositions;
functionHandles.fpAPCursorStatus = @fpAPCursorStatus;
end

function rslt = fpAPCursorPositions(esub, cursorInfo)
% fpAPCursorPositions TODO: Comments

if(fpAPCursorStatus(cursorInfo))
    [~, originalIndex] = sort([cursorInfo.DataIndex]);
    sortedCursorInfo = cursorInfo(originalIndex(1:length(originalIndex)));
    
    startElectroporation = esub(1);
    stopElectroporation = esub(end);
    apLeftCursorLoc = [];
    fpLeftCursorLoc = [];
    
    for i = 1:length(sortedCursorInfo)
        xCursorValue = sortedCursorInfo(i).Position(1);
        
        %When i = 1, the cursor will be 'left' most of 'something' - since the fpAPCursorStatus passed.
        if(xCursorValue < startElectroporation && i == 1)
            fpLeftCursorLoc = xCursorValue;
        end
        
        if((xCursorValue > stopElectroporation && i == 1)...
                || (xCursorValue > stopElectroporation && isempty(apLeftCursorLoc)))
            apLeftCursorLoc = sortedCursorInfo(i).Position(1);
        end
        
        if(xCursorValue < startElectroporation && i > 1)
            fpRightCursorLoc = xCursorValue;
        end
        
        if(xCursorValue > stopElectroporation && i > 1)
            apRightCursorLoc = xCursorValue;
        end
    end
    
    if(~isempty(fpLeftCursorLoc) && ~isempty(fpRightCursorLoc))
        rslt(1).cursorType = "Field Potential";
        rslt(1).leftCursor = fpLeftCursorLoc;
        rslt(1).rightCursor = fpRightCursorLoc;
    end
    
    if(~isempty(apLeftCursorLoc) && ~isempty(apRightCursorLoc))
        rslt(2).cursorType = "Action Potential";
        rslt(2).leftCursor = apLeftCursorLoc;
        rslt(2).rightCursor = apRightCursorLoc;
    end
end
end

function rslt = fpAPCursorStatus(cursorInfo)
% fpAPCursorStatus TODO: Comments

numOfCursors = length(cursorInfo);
if(numOfCursors == 2 || numOfCursors == 4)
    rslt = true;
    return;
end
rslt = false;
end