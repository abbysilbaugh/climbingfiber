function plotpremotion(allData, trialmotType, exclude, includeopto, savename, xlimit, norm)

[whisker, w_vartype] = grabdata(allData, 'all', 'all', 'W', trialmotType, 'PRE',  'NO DCZ', 'motionInfo', exclude);
%[whisker, w_vartype] = trialpool(whisker, w_vartype);
[w_cat, varcattype] = catmice(allData, whisker, w_vartype, 'all');
for i = 1:size(w_cat, 2)
    w_cat(:, i) = smooth(w_cat(:, i), 15);
end


[whiskeropto, wo_vartype] = grabdata(allData, 'all', 'all', 'WO', trialmotType, 'PRE',  'NO DCZ', 'motionInfo', exclude);
%[whiskeropto, wo_vartype] = trialpool(whiskeropto, wo_vartype);
[wo_cat, varcattype] = catmice(allData, whiskeropto, wo_vartype, 'all');
for i = 1:size(wo_cat, 2)
    wo_cat(:, i) = smooth(wo_cat(:, i), 15);
end


[opto, o_vartype] = grabdata(allData, 'all', 'all', 'O', trialmotType, 'PRE',  'NO DCZ', 'motionInfo', exclude);
%[opto, o_vartype] = trialpool(opto, o_vartype);
[o_cat, varcattype] = catmice(allData, opto, o_vartype, 'all');
for i = 1:size(o_cat, 2)
    o_cat(:, i) = smooth(o_cat(:, i), 15);
end


w_cat_mean = mean(w_cat, 2, 'omitnan'); w_cat_sem = std(w_cat, 0, 2, 'omitnan') / sqrt(size(w_cat, 2));
wo_cat_mean = mean(wo_cat, 2, 'omitnan'); wo_cat_sem = std(wo_cat, 0, 2, 'omitnan') / sqrt(size(wo_cat, 2));
o_cat_mean = mean(o_cat, 2, 'omitnan'); o_cat_sem = std(o_cat, 0, 2, 'omitnan') / sqrt(size(o_cat, 2));

if norm
    shift_w = mean(w_cat_mean(300:310)); w_cat_mean = w_cat_mean - shift_w;
    shift_wo = mean(wo_cat_mean(300:310)); wo_cat_mean = wo_cat_mean - shift_wo;
    shift_o = mean(o_cat_mean(300:310)); o_cat_mean = o_cat_mean - shift_o;
end

% Set trace colors
traceColor = [0, 0, 0]; % Black
optoColor = [37, 187, 187]/255;
semAlpha = 0.2; % Transparency for SEM shading

% Plot W
upperBound = w_cat_mean + w_cat_sem;
lowerBound = w_cat_mean - w_cat_sem;

figure('units', 'pixels','Position', [0,0,500,450]); 

ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];



x = 1:length(w_cat_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], traceColor, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

hold on;

whisker = plot(x, w_cat_mean, 'Color', traceColor, 'LineWidth', 2, 'LineStyle', '-.');

% Plot WO
upperBound = wo_cat_mean + wo_cat_sem;
lowerBound = wo_cat_mean - wo_cat_sem;

x = 1:length(wo_cat_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], traceColor, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

whiskeropto = plot(x, wo_cat_mean, 'Color', traceColor, 'LineWidth', 2, 'LineStyle', '-');

% Plot O
if includeopto
    upperBound = o_cat_mean + o_cat_sem;
    lowerBound = o_cat_mean - o_cat_sem;
    
    x = 1:length(o_cat_mean);
    fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], optoColor, ...
        'linestyle', 'none', 'FaceAlpha', semAlpha);
    
    opto = plot(x, o_cat_mean, 'Color', optoColor, 'LineWidth', 2, 'LineStyle', '-');
end

% Add a rectangle
x = [304 308 308 304];
y = [-1 -1 3 3];
patch('XData', x, 'YData', y, 'FaceColor', 'black', 'EdgeColor', 'none', 'FaceAlpha', 0.2);
set(gca,'FontSize', 20, 'FontWeight', 'normal'); 
%xlabel('Relative Time (s)', 'FontSize', 25);
ylabel('P(ΔMotion)', 'FontSize', 25);
xticks([304 - 30.98, 304, 304 + 30.98, 304 + 30.98 + 30.98, 304+ 3*30.98])
xticklabels([-1 0 1 2 3])
xlim([300 402])
ylim([-.1 1])

xlabelHandle = xlabel('Time relative to stim. onset (s)', 'FontSize', 20);
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

if includeopto
    lgd = legend([whisker, whiskeropto, opto], {'W', 'W-CF', 'CF'});
    % Set the location of the legend to 'NorthWest' which is the upper left corner
    lgd.Location = 'northeast';
    
    % Remove the box around the legend
    lgd.Box = 'off';
else
    lgd = legend([whisker, whiskeropto], {'W', 'W-CF'});
    % Set the location of the legend to 'NorthWest' which is the upper left corner
    lgd.Location = 'northeast';
    
    % Remove the box around the legend
    lgd.Box = 'off';
end

box off

hold off

print('-dtiff', '-r300', savename);


end

