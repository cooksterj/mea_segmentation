function batchAttributes(tableToProcess)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis Refactored Part3 01 9/7/18 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This code is the refactored version of DonFigure5.m

% Authors: Christopher Beal and Jon Cook

%% variables
apdWell = table2array(tableToProcess(:,2));
apd30   = table2array(tableToProcess(:,7));
apd50   = table2array(tableToProcess(:,9));
apd80   = table2array(tableToProcess(:,12));
apd90   = table2array(tableToProcess(:,13));
apdTriang = table2array(tableToProcess(:, 16));
apdFrac = table2array(tableToProcess(:, 17));
batchNumber = table2array(tableToProcess(:, 30));
buckets = 20;

wellNumber = (0:1:23);
wellLabels = {'A1','A2','A3','A4','A5','A6',...
              'B1','B2','B3','B4','B5','B6',...
              'C1','C2','C3','C4','C5','C6',...
              'D1','D2','D3','D4','D5','D6'};
 
%% Create constructs and constructLabel columns
for i = 1:length(apdWell)
    for j = 1:length(wellNumber)
        if (apdWell(i) == wellNumber(j))
            constructs(i,1) = strcat(string(batchNumber(i)),'_',string(apdWell(i)));
            constructLabels(i,1) = strcat(wellLabels(j),'.',string(batchNumber(i)));
        end
    end
end

%%% append constructs, constructLabels, and batchNumber onto M (dont move this section)
constructs = table(constructs);
constructLabels = table(constructLabels);
batchNumber = table(batchNumber);
tableToProcess = [tableToProcess, constructs, constructLabels, batchNumber];

%% figures
j = 1;
figure; clf;

filterable = convertCharsToStrings(tableToProcess.batchNumber);
uniqueBatchNumbers = unique(filterable);
for i = 1:length(uniqueBatchNumbers) % length(batchNumber)    
    filter = (filterable == uniqueBatchNumbers(i));   % choose Batch 1, Batch 2, or Batch 3
    
    subplot(3,4,j)
    histogram(apd30(filter), buckets) 
    yLabelOut = sprintf('Batch %s', uniqueBatchNumbers(i));
    ylabel(yLabelOut);
    if (j == 1)
        title('apd30')
    end

    subplot(3,4,j+1)
    histogram(apd80(filter),buckets)
    if (j == 1)
        title('apd80')
    end

    subplot(3,4,j+2)
    histogram(apdTriang(filter),buckets)
    if (j == 1)
        title('apdTriang')
    end
    
    subplot(3,4,j+3)
    histogram(apdFrac(filter),buckets)
    if (j == 1)
        title('apdFrac')
    end
    
    j = j + 4;
end
end

