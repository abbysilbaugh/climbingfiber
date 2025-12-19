function prepostbar(allData, cellType, cellmotType, trialmotType, variable, exclude, trialaverage, plot_indiv_cells, plot_indiv_mice, savename, gettitle)

whiskerTetMice = [2, 3, 4, 5, 10, 11];
whiskerOptoTetMice = [1, 6, 7, 8, 9];

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

% Grab Pre data
[pre, pre_vartype] = grabdata(allData, cellType, cellmotType, 'W', trialmotType, 'PRE', variable, exclude);
if trialaverage
    [pre, ~, pre_vartype] = trialavg(pre, pre_vartype);
else
    [pre, pre_vartype] = trialpool(pre, pre_vartype);
end
[pre_cat, varcattype] = catmice(allData, pre, pre_vartype, 'whiskerTet');
[pre_cat2, varcattype2] = catmice(allData, pre, pre_vartype, 'whiskerOptoTet');


% Grab Post data
[post, post_vartype] = grabdata(allData, cellType, cellmotType, 'W', trialmotType, 'POST', variable, exclude);
if trialaverage
    [post, ~, post_vartype] = trialavg(post, post_vartype);
else
    [post, post_vartype] = trialpool(post, post_vartype);
end
[post_cat, varcattype] = catmice(allData, post, post_vartype, 'whiskerTet');
[post_cat2, varcattype2] = catmice(allData, post, post_vartype, 'whiskerOptoTet');

% Create Pre/Post whiskerTet figure
figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];

% Compute SEM, excluding NaN values
sem1_pre = nanstd(pre_cat) / sqrt(sum(~isnan(pre_cat)));
sem1_post = nanstd(post_cat) / sqrt(sum(~isnan(post_cat)));

bar_data1 = [nanmean(pre_cat), nanmean(post_cat)]; % use nanmean to exclude NaN values
bar_sem1 = [sem1_pre, sem1_post];


bar(1:2, bar_data1, 'FaceColor', Color, 'FaceAlpha', 1, 'EdgeColor', 'none');
hold on;
errorbar(1:2, bar_data1, bar_sem1, 'k.', 'linewidth', 1.5); % adding error bars

if trialaverage && plot_indiv_cells
    plotIndividualCells(pre, post, whiskerTetMice)
end

if plot_indiv_mice
    plotIndividualMice(pre, post, whiskerTetMice)
end

% Statistics for whiskerTet
[~, p] = ttest2(pre_cat, post_cat, 'Vartype','unequal'); % Two-sample t-test

maxBar1 = max(bar_data1) + 0.1;

pStr = sprintf('p=%.4g', p); % Format the p-value to have up to 4 significant figures

lineY = maxBar1;
bracketLength = 0.02; % Define the bracket's length. Adjust as needed.

if p < 0.05
% Bracket lines
line([1, 1], [lineY-bracketLength, lineY], 'Color', 'k', 'LineWidth', 1.5);
line([2, 2], [lineY-bracketLength, lineY], 'Color', 'k', 'LineWidth', 1.5);
line([1, 2], [lineY, lineY], 'Color', 'k', 'LineWidth', 1.5);


    text(1.5, lineY, pStr, 'FontSize', 20, 'FontWeight', 'normal', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end



if strcmp(variable, 'mean_fluo_in_win')
    ylim([0 0.7])
elseif strcmp(variable, 'firstpeakamp')
    ylim([0 1])
end

set(gca, 'XTickLabel', {'PRE', 'POST'}, 'FontSize', 25, 'FontWeight', 'normal'); 
ylabel('Mean ΔF/F0', 'FontSize', 25, 'FontWeight', 'normal'); 
title(gettitle{1}, 'FontSize', 28, 'FontWeight', 'normal'); 

print('-dtiff', '-r300', savename{1});

hold off;

% Create Pre/Post whiskerOptoTet figure
figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];


% Compute SEM, excluding NaN values
sem2_pre = nanstd(pre_cat2) / sqrt(sum(~isnan(pre_cat2)));
sem2_post = nanstd(post_cat2) / sqrt(sum(~isnan(post_cat2)));

bar_data2 = [nanmean(pre_cat2), nanmean(post_cat2)]; % use nanmean to exclude NaN values
bar_sem2 = [sem2_pre, sem2_post];

bar(1:2, bar_data2, 'FaceColor', Color, 'FaceAlpha', 1, 'EdgeColor', 'none');
hold on;
errorbar(1:2, bar_data2, bar_sem2, 'k.', 'linewidth', 1.5); % adding error bars

if trialaverage && plot_indiv_cells
    plotIndividualCells(pre, post, whiskerOptoTetMice)
end

if plot_indiv_mice
    plotIndividualMice(pre, post, whiskerOptoTetMice)
end

% Statistics for whiskerOptoTet
[~, p] = ttest2(pre_cat2, post_cat2, 'Vartype','unequal'); % Two-sample t-test

maxBar2 = max(bar_data2) + 0.1;

pStr = sprintf('p=%.4g', p); % Format the p-value to have up to 4 significant figures

lineY = maxBar2;
bracketLength = 0.02; % Define the bracket's length. Adjust as needed.

if p < 0.05
% Bracket lines
line([1, 1], [lineY-bracketLength, lineY], 'Color', 'k', 'LineWidth', 1.5);
line([2, 2], [lineY-bracketLength, lineY], 'Color', 'k', 'LineWidth', 1.5);
line([1, 2], [lineY, lineY], 'Color', 'k', 'LineWidth', 1.5);


    text(1.5, lineY, pStr, 'FontSize', 20, 'FontWeight', 'normal', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end


if strcmp(variable, 'mean_fluo_in_win')
    ylim([0 0.7])
elseif strcmp(variable, 'firstpeakamp')
    ylim([0 1])
end

set(gca, 'XTickLabel', {'PRE', 'POST'}, 'FontSize', 25, 'FontWeight', 'normal'); 
ylabel('Mean ΔF/F0', 'FontSize', 25, 'FontWeight', 'normal'); 
title(gettitle{2}, 'FontSize', 28, 'FontWeight', 'normal'); 

print('-dtiff', '-r300', savename{2});

hold off;

end

% Function to plot individual neuron data
function plotIndividualCells(pre, post, mice)
    for i = mice
        neuron_pre = pre{i};
        neuron_post = post{i};
        
        for j = 1:length(neuron_pre)
            % Here we'll use x-values of 1 for 'Pre' and 2 for 'Post'
            plot([1, 2], [neuron_pre(j), neuron_post(j)], 'color', [0, 0, 0, 0.2], 'LineWidth', 1); % Light grey line
            hold on;
        end
    end
end

% Function to plot individual mouse data
function plotIndividualMice(pre, post, mice)
    for i = mice
        neuron_pre = pre{i};
        neuron_post = post{i};

        neuron_pre = mean(neuron_pre, 'omitnan');
        neuron_post = mean(neuron_post, 'omitnan');
        
        plot([1, 2], [neuron_pre, neuron_post], 'color', [0, 0, 0, 0.2], 'LineWidth', 1); % Light grey line
            hold on;
    end
end
