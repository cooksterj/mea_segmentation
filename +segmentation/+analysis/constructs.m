function constructs(tableToProcess)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis Refactored Part1 01 9/7/18  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is the new refactored version of APP_apd_box_plot.m

% Authors: Christopher R. Beal and Jon Cook

% Caution: Be careful if changing the "constructs", "constructs1", and
% "constructs2" variable names in this file.  They are slightly different in this file
% than they are in the other 3 files.

%% variables
apdWell     = table2array(tableToProcess(:, 2));
electrodes1 = table2array(tableToProcess(:, 3));
apdRatio    = table2array(tableToProcess(:, 14));
apdDiff     = table2array(tableToProcess(:, 15));
batchNumber = table2array(tableToProcess(:, 30));

electrodes2 = unique(electrodes1);

wellNumber = (0:1:23);
wellLabels = {'A1','A2','A3','A4','A5','A6',...
    'B1','B2','B3','B4','B5','B6',...
    'C1','C2','C3','C4','C5','C6',...
    'D1','D2','D3','D4','D5','D6'};

%% Jon Added Comments - logical 'ratio' buckets - same dimensions as 'ratio'.
apdRatio3 = (apdRatio > 0.85);
apdRatio2 = (apdRatio > 0.65 & apdRatio <= 0.85);
apdRatio1 = (apdRatio > 0.20 & apdRatio <= 0.65);

apdDiff1 = (apdDiff >  0.175);
apdDiff2 = (apdDiff >  0.130 & apdDiff <= 0.175);
apdDiff3 = (apdDiff <= 0.130);

% Jon Added Comments - biologically significant?!
clusterFilter3 = logical((apdRatio3 .* apdDiff3) + (apdRatio2 .* apdDiff3));

%% Create constructs (make into column vectors. adjust diff matrix when this happens. 9/7/18)
for i = 1:length(apdWell)
    for j = 1:length(wellNumber)
        if (apdWell(i) == wellNumber(j))
            constructs1(i) = strcat(string(batchNumber(i)),'_',string(apdWell(i)));
            constructLabels(i) = strcat(wellLabels(j),'.',string(batchNumber(i)));
        end
    end
end

% JC Added Comments - we need to preserve dimensions - this can be handled
% in the above 'for' loop better - proof of concept.
constructLabels = constructLabels';

% JC Added Comments - this is likely no longer needed.
constructs2 = [constructLabels]; %constructs = constructs(keep);

% JC Added Comments - complete override from previous 'for' loop.
constructs1 = unique(constructs2);

%% Difference Matrix
diffmatrix = [];
tempDiffMatrix = [];

% Problem: The original alldata structure is working off the average data.  we
% need to work off of the raw data. also, the "filters" are a crude way of
% separating the data by batch number.  should separate by batch number
% first and keep supdividing the data to get the result we want. 8/24/18

% Solution (Temporary fix): use the average apd data instead of the raw apd
% data.  Using the average for now inorder to keep moving. 8/31/18

for i = 1:length(constructs1)
    constructFilter1 = (constructs2 == constructs1(i));
    for j = 1:length(electrodes2)
        electrodeFilter = (electrodes1 == electrodes2(j));
        constructFilter2 = logical(constructFilter1 .* electrodeFilter .* clusterFilter3);
        
        % JC Comments - within the cluster (well + batch) and electrode,
        % if there is no measurement that falls in clust3log - NaN.
        if (sum(constructFilter2) == 0)
            diffmatrix(i,j) = NaN;
        else
            diffmatrix(i,j) = mean(apdDiff(constructFilter2));
        end
    end
end

%% figure
figure; clf;
boxplot(diffmatrix' * 1000);
h = findobj(gca,'tag','Outliers');
shade = (0:1/99:1); hold on;
line1 = line([0, length(constructs1)],[50,   50],'Color',[shade(50), shade(50), shade(50)],'Linewidth',2); hold on;
line2 = line([0, length(constructs1)],[130, 130],'Color',[shade(50), shade(50), shade(50)],'Linewidth',2); hold on;
line3 = line([0, length(constructs1)],[175, 175],'Color',[shade(50), shade(50), shade(50)],'LineStyle','--','Linewidth',2); hold on;
line4 = line([0, length(constructs1)],[200, 200],'Color',[shade(50), shade(50), shade(50)],'LineStyle','--','Linewidth',2); hold on;
set(gca,'FontName','Arial','FontSize',10); hold on;
set(gca, 'box', 'on');
xlabel('Constructs');
xticks([1:1:length(constructs1)]);
xticklabels(cellstr(constructs1));
xtickangle(45);
ylabel('APD_{90}-APD_{50} (ms)');
ylim([0,275]);
title('Boxplot of Each Construct');

end

