function plotLONGpreposttraces(allData, cellType, cellmotType, trialmotType, variable, exclude, savename, gettitle)

[pre, pre_vartype] = grabdata(allData, cellType, cellmotType, 'W', trialmotType, 'PRE', variable, exclude);
[pre, pre_vartype] = trialpool(pre, pre_vartype);
[pre_cat, varcattype] = catmice(allData, pre, pre_vartype, 'whiskerTet');
[pre_cat2, varcattype2] = catmice(allData, pre, pre_vartype, 'whiskerOptoTet');

[post, post_vartype] = grabdata(allData, cellType, cellmotType, 'W', trialmotType, 'POST', variable, exclude);
[post, post_vartype] = trialpool(post, post_vartype);
[post_cat, varcattype] = catmice(allData, post, post_vartype, 'whiskerTet');
[post_cat2, varcattype2] = catmice(allData, post, post_vartype, 'whiskerOptoTet');




pre_mean = mean(pre_cat, 2, 'omitnan'); pre_sem = std(pre_cat, 0, 2, 'omitnan') / sqrt(size(pre_cat, 2));
pre_mean2 = mean(pre_cat2, 2, 'omitnan'); pre_sem2 = std(pre_cat2, 0, 2, 'omitnan') / sqrt(size(pre_cat2, 2));
post_mean = mean(post_cat, 2, 'omitnan'); post_sem = std(post_cat, 0, 2, 'omitnan') / sqrt(size(post_cat, 2));
post_mean2 = mean(post_cat2, 2, 'omitnan'); post_sem2 = std(post_cat2, 0, 2, 'omitnan') / sqrt(size(post_cat2, 2));

% Set trace colors
% Choose color
if strcmp(cellType, 'PV')
    traceColor = [187, 37, 37]/255; % Red
elseif strcmp(cellType, 'PN')
    traceColor = [37, 112, 187]/255; % Blue
elseif strcmp(cellType, 'VIP')
    traceColor = [37 187 112]/255; % Green
elseif strcmp(cellType, 'UC')
    traceColor = [37 187 112]/255; % Green
end
semAlpha = 0.2; % Transparency for SEM shading

% Plot W PRE (whiskerTet)
upperBound = pre_mean + pre_sem;
lowerBound = pre_mean - pre_sem;

figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];


x = 1:length(pre_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], 'k', ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

hold on;

plot(x, pre_mean, 'Color', 'k', 'LineWidth', 2, 'LineStyle', '-.');


% Plot W POST (whiskerTet)
upperBound = post_mean + post_sem;
lowerBound = post_mean - post_sem;

x = 1:length(post_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], traceColor, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

plot(x, post_mean, 'Color', traceColor, 'LineWidth', 2);

% Add a rectangle
x = [304 308 308 304];
y = [0 0 1 1];
patch('XData', x, 'YData', y, 'FaceColor', 'black', 'EdgeColor', 'none', 'FaceAlpha', 0.2);
set(gca,'FontSize', 20, 'FontWeight', 'normal'); 
xlabel('Relative Time (s)', 'FontSize', 25);
ylabel('ΔF/F0', 'FontSize', 25);
title(gettitle{1}, 'FontSize', 28, 'FontWeight', 'normal');
xticks([29 122 215 308 401 494 587])
xticklabels([-9 -6 -3 0 3 6 9])
ylim([0 0.75])

xlabelHandle = xlabel('Relative Time (s)');
currentPosition = get(xlabelHandle, 'Position');
set(xlabelHandle, 'Position', [currentPosition(1), currentPosition(2) + 0.05, currentPosition(3)]);

ax = gca;
ticks = ax.XTick;
ticklabels = ax.XTickLabel;

% Create new text labels manually positioned closer to the x-axis
for i = 1:length(ticks)
    text(ticks(i), ax.YLim(1) + (0.015 * range(ax.YLim)), ticklabels(i,:), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'top', ...
        'Clipping', 'on', 'FontSize', 20);
end

% Remove the original x-tick labels
ax.XTickLabel = [];


print('-dtiff', '-r300', savename{1});

hold off

% Plot W PRE (whiskerOptoTet)
upperBound = pre_mean2 + pre_sem2;
lowerBound = pre_mean2 - pre_sem2;

figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];


x = 1:length(pre_mean2);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], 'k', ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

hold on;

plot(x, pre_mean2, 'Color', 'k', 'LineWidth', 2, 'LineStyle', '-.');

% Plot W POST (whiskerOptoTet)
upperBound = post_mean2 + post_sem2;
lowerBound = post_mean2 - post_sem2;

x = 1:length(post_mean2);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], traceColor, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

plot(x, post_mean2, 'Color', traceColor, 'LineWidth', 2);

% Add a rectangle
x = [304 308 308 304];
y = [0 0 1 1];
patch('XData', x, 'YData', y, 'FaceColor', 'black', 'EdgeColor', 'none', 'FaceAlpha', 0.2);
set(gca,'FontSize', 20, 'FontWeight', 'normal'); 
xlabel('Relative Time (s)', 'FontSize', 25);
ylabel('ΔF/F0', 'FontSize', 25);
title(gettitle{2}, 'FontSize', 28, 'FontWeight', 'normal');
xticks([29 122 215 308 401 494 587])
xticklabels([-9 -6 -3 0 3 6 9])
ylim([0 0.75])

xlabelHandle = xlabel('Relative Time (s)');
currentPosition = get(xlabelHandle, 'Position');
set(xlabelHandle, 'Position', [currentPosition(1), currentPosition(2) + 0.05, currentPosition(3)]);

ax = gca;
ticks = ax.XTick;
ticklabels = ax.XTickLabel;

% Create new text labels manually positioned closer to the x-axis
for i = 1:length(ticks)
    text(ticks(i), ax.YLim(1) + (0.015 * range(ax.YLim)), ticklabels(i,:), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'top', ...
        'Clipping', 'on', 'FontSize', 20);
end

% Remove the original x-tick labels
ax.XTickLabel = [];




hold off

print('-dtiff', '-r300', savename{2});


end

