function analysisAttributes(tableToProcess)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis Refactored Part4 01 9/7/18 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This code is the refactored version of APP_Test_figures.m.

% Authors: Christopher Beal and Jon Cook

%% variables
apd30 = table2array(tableToProcess(:,7));
apd80 = table2array(tableToProcess(:,12));
ratio = table2array(tableToProcess(:,14)); 
diff  = table2array(tableToProcess(:,15));
buckets = 20;

%% figures
figure; clf;
A = histogram(ratio, buckets, 'FaceColor', 'k', 'Normalization', 'probability'); hold on;
apr1 = prctile(ratio, [5,95]); hold on;
ratioFilter = (ratio >= apr1(1,1) & ratio <= apr1(1,2)); hold on;
ymax1 = round((max(A.BinCounts) / sum(A.BinCounts)) * 1.1, 2); hold on;
line1 = line([apr1(1,1), apr1(1,1)], [0, ymax1], 'Linestyle', '--', 'Linewidth', 1); hold on;
graphLabel1 = sprintf('5th percentile:\n %.2f', apr1(1,1)); hold on;
text1 = text(0.98*apr1(1,1), 0.99*ymax1, graphLabel1, 'HorizontalAlignment', 'right'); hold on;
line2 = line([apr1(1,2), apr1(1,2)], [0, ymax1], 'Linestyle', '--', 'Linewidth', 1); hold on;
graphLabel2 = sprintf('95th percentile:\n %.2f', apr1(1,2)); hold on;
text2 = text(1.05*apr1(1,2), 0.95*ymax1, graphLabel2, 'HorizontalAlignment', 'right'); hold on;
set(gca, 'FontName', 'Arial', 'FontSize', 10); hold on;
xlabel('XLABEL');
xlim([0,1]);
ylabel('Probability');
title('TITLE')

figure; clf;
B = histogram(diff, buckets, 'FaceColor', 'k', 'Normalization', 'probability'); hold on;
apr2 = prctile(diff, [5,95]);
diffFilter = (diff >= apr2(1,1) & diff <= apr2(1,2));
ymax2 = round((max(B.BinCounts) / sum(B.BinCounts)) * 1.2, 2);
line3 = line([apr2(1,1), apr2(1,1)], [0, ymax2], 'Linestyle', '--', 'Linewidth', 1); hold on;
graphLabel3 = sprintf('5th percentile:\n %.2f', apr2(1,1));
text3 = text(1.05*apr2(1,1), 0.95*ymax2, graphLabel3, 'HorizontalAlignment', 'left'); hold on;
line4 = line([apr2(1,2), apr2(1,2)], [0, ymax2], 'Linestyle', '--', 'Linewidth', 1); hold on;
graphLabel4 = sprintf('95th percentile:\n %.2f', apr2(1,2)); hold on;
text4 = text(1.05*apr2(1,2), 0.95*ymax2, graphLabel4, 'HorizontalAlignment', 'left'); hold on;
set(gca, 'FontName', 'Arial', 'FontSize', 10);
xlabel('XLABEL');
ylabel('Probability');
title('TITLE');

end

