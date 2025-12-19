function plotLONGprepostmotion(allData, trialmotType, exclude, savename)

[pre, pre_vartype] = grabdata(allData, 'all', 'all', 'W', trialmotType, 'PRE', 'motionInfo', exclude);
%[whisker, w_vartype] = trialpool(whisker, w_vartype);
[pre_cat_W, varcattype] = catmice(allData, pre, pre_vartype, 'whiskerTet');
for i = 1:size(pre_cat_W, 2)
    pre_cat_W(:, i) = smooth(pre_cat_W(:, i), 15);
end

[post, post_vartype] = grabdata(allData, 'all', 'all', 'W', trialmotType, 'POST', 'motionInfo', exclude);
%[whisker, w_vartype] = trialpool(whisker, w_vartype);
[post_catW, varcattype] = catmice(allData, post, post_vartype, 'whiskerTet');
for i = 1:size(post_catW, 2)
    post_catW(:, i) = smooth(post_catW(:, i), 15);
end

[pre2, pre_vartype2] = grabdata(allData, 'all', 'all', 'W', trialmotType, 'PRE', 'motionInfo', exclude);
%[whisker, w_vartype] = trialpool(whisker, w_vartype);
[pre_cat2, varcattype] = catmice(allData, pre2, pre_vartype2, 'whiskerOptoTet');
for i = 1:size(pre_cat2, 2)
    pre_cat2(:, i) = smooth(pre_cat2(:, i), 15);
end

[post2, post_vartype2] = grabdata(allData, 'all', 'all', 'W', trialmotType, 'POST', 'motionInfo', exclude);
%[whisker, w_vartype] = trialpool(whisker, w_vartype);
[post_cat2, varcattype] = catmice(allData, post2, post_vartype2, 'whiskerOptoTet');
for i = 1:size(post_cat2, 2)
    post_cat2(:, i) = smooth(post_cat2(:, i), 15);
end


pre_cat_mean = mean(pre_cat_W, 2, 'omitnan'); pre_cat_sem = std(pre_cat_W, 0, 2, 'omitnan') / sqrt(size(pre_cat_W, 2));
post_cat_mean = mean(post_catW, 2, 'omitnan'); post_cat_sem = std(post_catW, 0, 2, 'omitnan') / sqrt(size(post_catW, 2));

pre_cat_mean2 = mean(pre_cat2, 2, 'omitnan'); pre_cat_sem2 = std(pre_cat2, 0, 2, 'omitnan') / sqrt(size(pre_cat2, 2));
post_cat_mean2 = mean(post_cat2, 2, 'omitnan'); post_cat_sem2 = std(post_cat2, 0, 2, 'omitnan') / sqrt(size(post_cat2, 2));

% Set trace colors
traceColor = [0, 0, 0]; % Black
semAlpha = 0.2; % Transparency for SEM shading

% Plot PRE (whiskerTet)
upperBound = pre_cat_mean + pre_cat_sem;
lowerBound = pre_cat_mean - pre_cat_sem;

figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];


x = 1:length(pre_cat_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], traceColor, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

hold on;

plot(x, pre_cat_mean, 'Color', traceColor, 'LineWidth', 2, 'LineStyle', '-.');

% Plot POST (whiskerTet)
upperBound = post_cat_mean + post_cat_sem;
lowerBound = post_cat_mean - post_cat_sem;

x = 1:length(post_cat_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], traceColor, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

plot(x, post_cat_mean, 'Color', traceColor, 'LineWidth', 2, 'LineStyle', '-');


% Add a rectangle
x = [304 308 308 304];
y = [0 0 1 1];
patch('XData', x, 'YData', y, 'FaceColor', 'black', 'EdgeColor', 'none', 'FaceAlpha', 0.2);
set(gca,'FontSize', 20, 'FontWeight', 'normal'); 
xlabel('Relative Time (s)', 'FontSize', 25);
ylabel('P(ΔMotion)', 'FontSize', 25);

xticks([29 122 215 308 401 494 587])
xticklabels([-9 -6 -3 0 3 6 9])

ylim([0 1])

xlabelHandle = xlabel('Relative Time (s)');
currentPosition = get(xlabelHandle, 'Position');
set(xlabelHandle, 'Position', [currentPosition(1), currentPosition(2) + .01, currentPosition(3)]);

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

% Plot PRE (whiskerOptoTet)
upperBound = pre_cat_mean2 + pre_cat_sem2;
lowerBound = pre_cat_mean2 - pre_cat_sem2;

figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];

x = 1:length(pre_cat_mean2);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], traceColor, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

hold on;

plot(x, pre_cat_mean2, 'Color', traceColor, 'LineWidth', 2, 'LineStyle', '-.');

% Plot POST (whiskerTet)
upperBound = post_cat_mean2 + post_cat_sem2;
lowerBound = post_cat_mean2 - post_cat_sem2;

x = 1:length(post_cat_mean2);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], traceColor, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

plot(x, post_cat_mean2, 'Color', traceColor, 'LineWidth', 2, 'LineStyle', '-');

% Add a rectangle
x = [304 308 308 304];
y = [0 0 1 1];
patch('XData', x, 'YData', y, 'FaceColor', 'black', 'EdgeColor', 'none', 'FaceAlpha', 0.2);
set(gca,'FontSize', 20, 'FontWeight', 'normal'); 
xlabel('Relative Time (s)', 'FontSize', 25);
ylabel('P(ΔMotion)', 'FontSize', 25);

xticks([29 122 215 308 401 494 587])
xticklabels([-9 -6 -3 0 3 6 9])

ylim([0 1])

xlabelHandle = xlabel('Relative Time (s)');
currentPosition = get(xlabelHandle, 'Position');
set(xlabelHandle, 'Position', [currentPosition(1), currentPosition(2) + 0.01, currentPosition(3)]);

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

print('-dtiff', '-r300', savename{2});


end

