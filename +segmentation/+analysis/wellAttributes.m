function  wellAttributes(tableToProcess)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis Refactored Part2 02 9/7/18 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is the new refactored version of DonFigure4.m.

% Authors: Christopher Beal and Jon Cook

%% variables
apdWell = table2array(tableToProcess(:, 2));
apd30   = table2array(tableToProcess(:, 7));
apd50   = table2array(tableToProcess(:, 9));
apd80   = table2array(tableToProcess(:, 12));
apd90   = table2array(tableToProcess(:, 13));
apdTriang = table2array(tableToProcess(:, 16));
apdFrac = table2array(tableToProcess(:, 17));
batchNumber = table2array(tableToProcess(:, 30));

wellNumber = (0:1:23);
wellLabels = {'A1','A2','A3','A4','A5','A6',...
    'B1','B2','B3','B4','B5','B6',...
    'C1','C2','C3','C4','C5','C6',...
    'D1','D2','D3','D4','D5','D6'};

apd30Delta = 0.01;
apd30Edges = (0:apd30Delta:0.60);

apd80Delta = 0.01;
apd80Edges = (0:apd80Delta:0.75);

apdTriangDelta = 0.01;
apdTriangEdges = (0:apdTriangDelta:0.75);

apdFracDelta = 0.01;                  % apdFracDelta = bucket width in plot 8/31/18
apdFracEdges = (0:apdFracDelta:1.00); % apdFracEdges = how many buckets are available 8/31/18

%% Create constr and constrlbl columns
for i = 1:length(apdWell)
    for j = 1:length(wellNumber)
        if (apdWell(i) == wellNumber(j))
            constructs1(i,1) = strcat(string(batchNumber(i)),'_',string(apdWell(i)));
            constructLabels(i,1) = strcat(wellLabels(j),'.',string(batchNumber(i)));
        end
    end
end

%%% append constructs, constructLabels, and batchNumber onto M (dont move this section)
constructs1 = table(constructs1);
constructLabels = table(constructLabels);
batchNumber = table(batchNumber);
tableToProcess = [tableToProcess, constructs1, constructLabels, batchNumber];

%%%
constructs1 = [constructLabels];
constructs1 = unique(constructs1);

%% figures
w = unique(apdWell);
cutoff1 = [1,floor(0.5*length(w))]; % 1st half of well plots
j = 1;
figure; clf;
for i = cutoff1(1,1) : cutoff1(1,2)
    filter1 = (apdWell == w(i));
    subplot(cutoff1(1,2) - cutoff1(1,1) + 1,4,j)
    histogram(apd30(filter1),apd30Edges);
    WellLabelNumber = sprintf('W%d', i);
    ylabel(WellLabelNumber);
    if (i == 1)
        title('apd30');
    end
    
    subplot(cutoff1(1,2) - cutoff1(1,1) + 1,4,j+1)
    histogram(apd80(filter1),apd80Edges)
    if (i == 1)
        title('apd80');
    end
    
    subplot(cutoff1(1,2) - cutoff1(1,1) + 1,4,j+2)
    histogram(apdTriang(filter1),apdTriangEdges)
    if (i == 1)
        title('apdTriang');
    end
    
    subplot(cutoff1(1,2) - cutoff1(1,1) + 1,4,j+3)
    histogram(apdFrac(filter1), apdFracEdges)
    if (i == 1)
        title('apdFrac');
    end
    
    j = j+4;
end

cutoff2 = [ceil(0.5*length(w)),length(w)]; % 2nd half of well plots
j = 1;
figure; clf;
for i = cutoff2(1,1) : cutoff2(1,2)
    filter1 = (apdWell == w(i));
    subplot(cutoff2(1,2) - cutoff2(1,1) + 1,4,j)
    histogram(apd30(filter1),apd30Edges);
    WellLabelNumber = sprintf('W%d', i); % W_i = Well i
    ylabel(WellLabelNumber);
    if (i == cutoff2(1,1))
        title('apd30');
    end
    
    subplot(cutoff2(1,2) - cutoff2(1,1) + 1,4,j+1)
    histogram(apd80(filter1),apd80Edges)
    if (i == cutoff2(1,1))
        title('apd80');
    end
    
    subplot(cutoff2(1,2) - cutoff2(1,1) + 1,4,j+2)
    histogram(apdTriang(filter1),apdTriangEdges)
    if (i == cutoff2(1,1))
        title('apdTriang');
    end
    
    subplot(cutoff2(1,2) - cutoff2(1,1) + 1,4,j+3)
    histogram(apdFrac(filter1), apdFracEdges)
    if (i == cutoff2(1,1))
        title('apdFrac');
    end
    
    j = j+4;
end
end

