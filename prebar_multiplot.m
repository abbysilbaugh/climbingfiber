function prebar_multiplot(allData, cellType, cellmotType, trialmotType, variable1, variable2, exclude, trialaverage, gettitle, savename, ylimit)


% Choose color
if strcmp(cellType, 'PV')
    Color = [187, 37, 37]/255; % Red
elseif strcmp(cellType, 'PN')
    Color = [37, 112, 187]/255; % Blue
elseif strcmp(cellType, 'VIP')
    Color = [37 187 112]/255; % Green
elseif strcmp(cellType, 'UC')
    Color = [0 0 0]/255; % Black
end

%%%%%%%%%%%%%%%% FIRST VARIABLE %%%%%%%%%%%%%%%%%
% Grab W data
[preW, pre_vartype] = grabdata(allData, cellType, cellmotType, 'W', trialmotType, 'PRE',  'NO DCZ', variable1, exclude);
if trialaverage
    [preW, ~, pre_vartype] = trialavg(preW, pre_vartype);
else
    [preW, pre_vartype] = trialpool(preW, pre_vartype);
end
[pre_catW, varcattype] = catmice(allData, preW, pre_vartype, 'all');

% Grab WO data
[preWO, pre_vartype] = grabdata(allData, cellType, cellmotType, 'WO', trialmotType, 'PRE',  'NO DCZ', variable1, exclude);
if trialaverage
    [preWO, ~, pre_vartype] = trialavg(preWO, pre_vartype);
else
    [preWO, pre_vartype] = trialpool(preWO, pre_vartype);
end
[pre_catWO, varcattype] = catmice(allData, preWO, pre_vartype, 'all');


%%%%%%%%%%%%%%%% SECOND VARIABLE %%%%%%%%%%%%%%%%%
% Grab W data
[preW2, pre_vartype2] = grabdata(allData, cellType, cellmotType, 'W', trialmotType, 'PRE',  'NO DCZ', variable2, exclude);
if trialaverage
    [preW2, ~, pre_vartype2] = trialavg(preW, pre_vartype2);
else
    [preW2, pre_vartype2] = trialpool(preW2, pre_vartype2);
end
[pre_catW2, varcattype2] = catmice(allData, preW2, pre_vartype2, 'all');

% Grab WO data
[preWO2, pre_vartype2] = grabdata(allData, cellType, cellmotType, 'WO', trialmotType, 'PRE',  'NO DCZ', variable2, exclude);
if trialaverage
    [preWO2, ~, pre_vartype2] = trialavg(preWO2, pre_vartype2);
else
    [preWO2, pre_vartype2] = trialpool(preWO2, pre_vartype2);
end
[pre_catWO2, varcattype2] = catmice(allData, preWO2, pre_vartype2, 'all');

%%% GET MEANS FIRST VARIABLE
mean_preW = mean(pre_catW(~isnan(pre_catW)));
mean_preWO = mean(pre_catWO(~isnan(pre_catWO)));
sem_preW = std(pre_catW(~isnan(pre_catW))) / sqrt(sum(~isnan(pre_catW)));
sem_preWO = std(pre_catWO(~isnan(pre_catWO))) / sqrt(sum(~isnan(pre_catWO2)));
size_preW = length(pre_catW(~isnan(pre_catW))); % Sample size for W
size_preWO = length(pre_catWO(~isnan(pre_catWO))); % Sample size for W-CF

%%% GET MEANS SECOND VARIABLE
mean_preW2 = mean(pre_catW2(~isnan(pre_catW2)));
mean_preWO2 = mean(pre_catWO2(~isnan(pre_catWO2)));
sem_preW2 = std(pre_catW2(~isnan(pre_catW2))) / sqrt(sum(~isnan(pre_catW2)));
sem_preWO2 = std(pre_catWO2(~isnan(pre_catWO2))) / sqrt(sum(~isnan(pre_catWO2)));
size_preW2 = length(pre_catW(~isnan(pre_catW2))); % Sample size for W
size_preWO2 = length(pre_catWO(~isnan(pre_catWO2))); % Sample size for W-CF


bar_data = [mean_preW, mean_preWO, mean_preW2, mean_preWO2];
bar_sem = [sem_preW, sem_preWO, sem_preW2, sem_preWO2];

%%%%%%%%%%%%%%%% BEGIN POWER ANALYSIS! %%%%%%%%%%%%%%%%%%%%
% Convert SEM to SD
sd_preW = sem_preW * sqrt(size_preW);
sd_preWO = sem_preWO * sqrt(size_preWO);

sd_preW2 = sem_preW2 * sqrt(size_preW2);
sd_preWO2 = sem_preWO2 * sqrt(size_preWO2);

% Significance level
alpha = 0.05;

% Calculate pooled standard deviation
pooledSD = sqrt(((size_preW - 1)*sd_preW^2 + (size_preWO - 1)*sd_preWO^2) / (size_preW + size_preWO - 2));
pooledSD2 = sqrt(((size_preW - 1)*sd_preW2^2 + (size_preWO2 - 1)*sd_preWO2^2) / (size_preW2 + size_preWO2 - 2));

% Calculate Cohen's d
cohens_d = (mean_preW - mean_preWO) / pooledSD;
cohens_d = (mean_preW2 - mean_preWO2) / pooledSD2;


%%%%%%%%%%%%%%%%%% Create figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the positions for each bar. If you have three bars, you might use 1, 2, and 3.
x_positions = [0.5 1.5 3 4];  % Adjust as necessary based on your specific plot.

% Define the colors for each bar.
colors = {
    [0, 0, 0],              % For 'W', black color.
    Color,                  % For 'W-CF', custom color based on cell type.
    [0, 0, 0],
    Color
};

alphas = [0.4, 0.6, 0.4, 0.6];

% Create a new figure (or specify the subplot, if you're working with multiple plots).
figure('units', 'pixels','Position', [0,0,500,450]);  
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];
set(gca, 'XTick', x_positions)

title(gettitle, 'FontSize', 28, 'FontWeight', 'normal'); 
set(gca, 'XTick', x_positions)
set(gca, 'XTickLabel', {'W', 'W-CF', 'W', 'W-CF'}, 'FontSize', 15, 'FontWeight', 'normal'); 

% Determine the new labels based on the provided variables
label1 = getVariableLabel(variable1);
label2 = getVariableLabel(variable2);

% Get the current tick labels
currentTickLabels = get(gca, 'XTickLabel');

% Calculate the position for the new labels
% These values might need adjustment based on the figure's dimensions
newLabelY = ax.YLabel.Extent(2) - .75; % Adjust the 0.15 as needed
middle1 = mean(x_positions(1:2));
middle2 = mean(x_positions(3:4));

% Add the new labels
text(middle1, newLabelY, label1, 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 15, 'Parent', ax);
text(middle2, newLabelY, label2, 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 15, 'Parent', ax);

hold on;

% Manually create each bar.
for i = 1:length(bar_data)
    bar(x_positions(i), bar_data(i), 'FaceColor', colors{i}, 'FaceAlpha', alphas(i), 'EdgeColor', colors{i}, 'LineWidth', 2);
end

% Add your error bars. You need to do this after the bars to ensure they're on top.
errorbar(x_positions, bar_data, bar_sem, 'k', 'linestyle', 'none', 'LineWidth', 1.5, 'CapSize', 10);


% Ensure everything is properly aligned.
xlim([0, max(x_positions) + 1]);  % Adjusting X limits to make sure all bars and error bars fit nicely.

% Statistics
% Data from FIRST VARIABLE
group1 = pre_catW(:); % Data from group 1 (e.g., 'W')
group2 = pre_catWO(:); % Data from group 2 (e.g., 'CF')

% Perform a t-test
[h, p] = ttest2(group1, group2); % 'h' is 1 if test rejects null hypothesis at the 5% significance level

formatted_p_value = sprintf('p = %.3f', p); % This creates a string like "p = 0.123" for example.

% Set the height of the significance bar
maxBar = max(bar_data(1:2)) + max(bar_sem(1:2)); % or set to a specific height based on your plot scale
lineY = maxBar + 0.1; % position of the line (you might need to adjust based on your plot)

% If the test is significant, then plot the significance bar
if h == 1
    lineX = [x_positions(1), x_positions(2)]; % X coordinates of your groups
    line(lineX, [lineY, lineY], 'Color', 'k', 'LineWidth', 1.5); % drawing the line

    % Determine the significance level and plot the appropriate number of stars
    if p < 0.0001
        significanceStars = '***';
    elseif p < 0.001
        significanceStars = '**';
    elseif p < 0.01
        significanceStars = '*';
    else
        significanceStars = 'n.s.'; % or simply don't plot anything if you prefer
    end

    % Add text (significance stars)
    textMean = mean(lineX);
    if strcmp(significanceStars, 'n.s.')
        text(textMean, lineY + 0.15, formatted_p_value, 'FontSize', 14, 'FontWeight', 'normal', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    else
        text(textMean, lineY - 0.02, significanceStars, 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
end

% Data from SECOND VARIABLE
group1 = pre_catW2(:); % Data from group 1 (e.g., 'W')
group2 = pre_catWO2(:); % Data from group 2 (e.g., 'CF')

% Perform a t-test
[h, p] = ttest2(group1, group2); % 'h' is 1 if test rejects null hypothesis at the 5% significance level

% Assume p holds the p-value you want to display, and you want to format it to 3 decimal places.
formatted_p_value = sprintf('p = %.3f', p); % This creates a string like "p = 0.123" for example.



% Set the height of the significance bar
maxBar = max(bar_data(3:4)) + max(bar_sem(3:4)); % or set to a specific height based on your plot scale
lineY = maxBar + 0.1; % position of the line (you might need to adjust based on your plot)

% If the test is significant, then plot the significance bar
if h == 1
    lineX = [x_positions(3), x_positions(4)]; % X coordinates of your groups
    line(lineX, [lineY, lineY], 'Color', 'k', 'LineWidth', 1.5); % drawing the line

    % Determine the significance level and plot the appropriate number of stars
    if p < 0.0001
        significanceStars = '***';
    elseif p < 0.001
        significanceStars = '**';
    elseif p < 0.01
        significanceStars = '*';
    else
        significanceStars = 'n.s.'; % or simply don't plot anything if you prefer
    end

    % Add text (significance stars)
    textMean = mean(lineX);
    if strcmp(significanceStars, 'n.s.')
        text(textMean, lineY + 0.15, formatted_p_value, 'FontSize', 14, 'FontWeight', 'normal', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    else
        text(textMean, lineY - 0.03, significanceStars, 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
end


xlim([-.3 4.8])
ylim([ylimit(1) ylimit(2)]); % Adjust ylim based on number of significant lines

if strcmp(trialmotType, 'all')
    ylim([ylimit(1) ylimit(2)]);
end

ylabel('ΔF/F0', 'FontSize', 20, 'FontWeight', 'bold'); 


hold off;




% Save as high resolution
print('-djpeg', '-r300', savename);

hold off

end

function label = getVariableLabel(variable)
    if strcmp(variable, 'mean_fluo_in_win')
        label = 'Evoked Mean';
    elseif strcmp(variable, 'firstpeakamp')
        label = 'Amplitude';
    else
        label = variable; % default case
    end
end

