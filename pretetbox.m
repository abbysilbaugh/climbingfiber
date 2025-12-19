function pretetbox(allData, cellType, cellmotType, trialmotType, variable, exclude, trialaverage, savefig)

[whisker, w_vartype] = grabdata(allData, cellType, cellmotType, 'W', trialmotType, 'PRE', variable, exclude);
if trialaverage
    [whisker, ~, w_vartype] = trialavg(whisker, w_vartype);
else
    [whisker, w_vartype] = trialpool(whisker, w_vartype);
end
[w_cat, varcattype] = catmice(allData, whisker, w_vartype, 'all');

[whiskeropto, wo_vartype] = grabdata(allData, cellType, cellmotType, 'WO', trialmotType, 'PRE', variable, exclude);
if trialaverage
    [whiskeropto, ~, wo_vartype] = trialavg(whiskeropto, wo_vartype);
else
    [whiskeropto, wo_vartype] = trialpool(whiskeropto, wo_vartype);
end
[wo_cat, varcattype] = catmice(allData, whiskeropto, wo_vartype, 'all');

[opto, o_vartype] = grabdata(allData, cellType, cellmotType, 'O', trialmotType, 'PRE', variable, exclude);
if trialaverage
    [opto, ~, o_vartype] = trialavg(opto, o_vartype);
else
    [opto, o_vartype] = trialpool(opto, o_vartype);
end
[o_cat, varcattype] = catmice(allData, opto, o_vartype, 'all');

% Remove NaNs
w_cat = w_cat(~isnan(w_cat));
wo_cat = wo_cat(~isnan(wo_cat));
o_cat = o_cat(~isnan(o_cat));

% Determine the max length to pad data
maxLength = max([length(w_cat), length(wo_cat), length(o_cat)]);

% Pad arrays with NaNs to make them the same length
w_cat(end+1:maxLength, 1) = NaN;
wo_cat(end+1:maxLength, 1) = NaN;
o_cat(end+1:maxLength, 1) = NaN;

% Prepare data for boxplot
dataMatrix = [w_cat, wo_cat, o_cat];

dataMatrix = double(dataMatrix);

% Choose color
if strcmp(cellType, 'PV')
    Color = [187, 37, 37]/255; % Red
elseif strcmp(cellType, 'PN')
    Color = [37, 112, 187]/255; % Blue
elseif strcmp(cellType, 'VIP')
    Color = [37 187 112]/255; % Green
elseif strcmp(cellType, 'UC')
    Color = [37 187 112]/255; % Green
end

% Prepare data for boxplot
dataMatrix = double(dataMatrix);

% Initialize the figure with specific dimensions
% Initialize the figure with specific dimensions
% Considering 300 DPI, the figure size in pixels should be 1500x1500 for 5x5 inches

% Boxchart with notches and without outliers
f = figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];
bc = boxchart(dataMatrix, 'BoxFaceColor', Color, 'BoxWidth', 0.75,  'MarkerColor', Color, 'Notch', 'on', 'MarkerStyle', 'none', 'WhiskerLineColor', Color);
hold on;

% Change the font size for the axes
set(gca, 'FontSize', 25);

% Determine the maximum whisker value among the three boxes
maxWhisker = max(max([~isoutlier(w_cat), ~isoutlier(wo_cat), ~isoutlier(o_cat)]));

% Update labels for the boxchart
xticks({'1', '2', '3'});
xticklabels({'W', 'W-CF', 'CF'});
ax = gca; % get current axis handle
ax.XAxis.FontWeight = 'bold';

% Set ylabel
ylabel('Mean ΔF/F0', 'FontSize', 25, 'FontWeight', 'bold');


% Determine line heights
% y_line_height1 = maxWhisker + 0.1*(maxWhisker); 
% y_line_height2 = y_line_height1 + 0.1*(maxWhisker); 
y_line_height1 = 0.6; 
y_line_height2 = 0.6 + 0.1; 

% Statistical Tests
[pval,~,stats] = kruskalwallis(dataMatrix,[],'off');

% If Kruskal-Wallis indicates a significant difference, do pairwise comparisons
if pval < 0.05
    [p_W_WO, ~] = ranksum(w_cat(~isnan(w_cat)), wo_cat(~isnan(wo_cat)));
    [p_W_O, ~] = ranksum(w_cat(~isnan(w_cat)), o_cat(~isnan(o_cat)));
    
    % Line from W to WO
    line([1, 2], [y_line_height1, y_line_height1], 'Color', 'k', 'LineWidth', 1.5);
    annotatePValue(p_W_WO, 1.5, y_line_height1);

    % Line from W to O
    line([1, 3], [y_line_height2, y_line_height2], 'Color', 'k', 'LineWidth', 1.5);
    annotatePValue(p_W_O, 2, y_line_height2);
end

% Adjust y-axis limits
ylim([-.05, 1]);

hold off

if savefig
% Save the figure with 300 DPI resolution
    print(f, 'boxplot.png', '-dpng', '-r300');
end

end

% Annotate function
function annotatePValue(p, x, y)
    maxWhisker = y - 0.1*y; % A workaround to get the max whisker value in this function

    % Decide on the number of stars based on p-value
    if p < 0.0001
        stars = '***';
    elseif p < 0.001
        stars = '**';
    elseif p < 0.01
        stars = '*';
    else
        stars = 'n.s.';
    end

    % Display the stars or 'n.s.' for non-significant
    text(x, y + 0.05*(maxWhisker), stars, 'HorizontalAlignment', 'center', 'FontSize', 20);
end

