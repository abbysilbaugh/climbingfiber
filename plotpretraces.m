function plotpretraces(allData, cellType, cellmotType, trialmotType, variable, exclude, includeopto, ylimit, xlimit, norm, gettitle, savename)

[whisker, w_vartype] = grabdata(allData, cellType, cellmotType, 'W', trialmotType, 'PRE',  'NO DCZ', variable, exclude);
[whisker, w_vartype] = trialpool(whisker, w_vartype);
[w_cat, varcattype] = catmice(allData, whisker, w_vartype, 'all');

[whiskeropto, wo_vartype] = grabdata(allData, cellType, cellmotType, 'WO', trialmotType, 'PRE',  'NO DCZ', variable, exclude);
[whiskeropto, wo_vartype] = trialpool(whiskeropto, wo_vartype);
[wo_cat, varcattype] = catmice(allData, whiskeropto, wo_vartype, 'all');

[opto, o_vartype] = grabdata(allData, cellType, cellmotType, 'O', trialmotType, 'PRE',  'NO DCZ', variable, exclude);
[opto, o_vartype] = trialpool(opto, o_vartype);
[o_cat, varcattype] = catmice(allData, opto, o_vartype, 'all');

w_cat_mean = mean(w_cat, 2, 'omitnan'); w_cat_sem = std(w_cat, [], 2, 'omitnan') / sqrt(sum(~all(isnan(w_cat))));
wo_cat_mean = mean(wo_cat, 2, 'omitnan'); wo_cat_sem = std(wo_cat, [], 2, 'omitnan') / sqrt(sum(~all(isnan(w_cat))));
o_cat_mean = mean(o_cat, 2, 'omitnan'); o_cat_sem = std(o_cat, [], 2, 'omitnan') / sqrt(sum(~all(isnan(w_cat))));

if norm
    shift_w = mean(w_cat_mean(300:304));
    shift_wo = mean(wo_cat_mean(300:304));
    shift_o = mean(o_cat_mean(300:304));

    if shift_w < 0
         w_cat_mean = w_cat_mean + shift_w;
    else
         w_cat_mean = w_cat_mean - shift_w;
    end
    if shift_wo < 0
         wo_cat_mean = wo_cat_mean + shift_wo;
    else
        wo_cat_mean = wo_cat_mean - shift_wo;
    end
    if shift_o < 0
        o_cat_mean = o_cat_mean + shift_o;
    else
        o_cat_mean = o_cat_mean - shift_o;
    end
end

% Choose color
if strcmp(cellType, 'PV')
    traceColor = [187, 37, 37]/255; % Red
elseif strcmp(cellType, 'PN')
    traceColor = [37, 112, 187]/255; % Blue
elseif strcmp(cellType, 'VIP')
    traceColor = [37 187 112]/255; % Green
elseif strcmp(cellType, 'UC')
    traceColor = [37 187 112]/255; % Black
end

semAlpha = 0.2; % Transparency for SEM shading

optoColor = [37, 187, 187]/255;

% Plot W
upperBound = w_cat_mean + w_cat_sem;
lowerBound = w_cat_mean - w_cat_sem;

figure('units', 'pixels','Position', [0,0,500,450]); 

ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];


x = 1:length(w_cat_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], 'k', ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

hold on;

whisker = plot(x, w_cat_mean, 'Color', 'k', 'LineWidth', 2, 'LineStyle', '-');

% Plot WO
upperBound = wo_cat_mean + wo_cat_sem;
lowerBound = wo_cat_mean - wo_cat_sem;

x = 1:length(wo_cat_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], traceColor, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

hold on;

whiskeropto = plot(x, wo_cat_mean, 'Color', traceColor, 'LineWidth', 2, 'LineStyle', '-');

% Plot O
if includeopto
    upperBound = o_cat_mean + o_cat_sem;
    lowerBound = o_cat_mean - o_cat_sem;
    
    x = 1:length(o_cat_mean);
    fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], optoColor, ...
        'linestyle', 'none', 'FaceAlpha', semAlpha);
    
    hold on;

    opto = plot(x, o_cat_mean, 'Color', optoColor, 'LineWidth', 2, 'LineStyle', '-');
end

% Add a rectangle
x = [304 308 308 304]; %[304 308 308 304];
y = [-1 -1 3 3];
patch('XData', x, 'YData', y, 'FaceColor', 'black', 'EdgeColor', 'none', 'FaceAlpha',0.2 );
x1 = [304 309 309 304];
y1 = [-1 -1 3 3];
patch('XData', x1, 'YData', y1, 'FaceColor', 'black', 'EdgeColor', 'none', 'FaceAlpha', 0.2);
set(gca,'FontSize', 20, 'FontWeight', 'normal'); 
%xlabel('Relative Time (s)', 'FontSize', 25);
ylabel('ΔF/F0', 'FontSize', 25);
title(gettitle, 'FontSize', 28, 'FontWeight', 'normal');
xticks([304 - 30.98, 304, 304 + 30.98, 304 + 30.98 + 30.98, 304+ 3*30.98])
xticklabels([-1 0 1 2 3])
xlim(xlimit)
ylim([-.1 ylimit])

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
%print('-dsvg', '-r300', savename);


end

