function plotTHRESHcells_trialavg(allData, cellType, cellmotType, trialmotType, variable, exclude, ylimit, xlimit, norm, gettitle, savename)
[PSI_4, PSI_4_vartype] = grabTHRESHdata(allData, cellType, cellmotType, 'W', trialmotType, 'all', variable, exclude, 'PSI_4');
[PSI_4, PSI_4_vartype] = trialavg(PSI_4, PSI_4_vartype);
PSI_4_cat = PSI_4{1};

[PSI_6, PSI_6_vartype] = grabTHRESHdata(allData, cellType, cellmotType, 'W', trialmotType, 'all', variable, exclude, 'PSI_6');
[PSI_6, PSI_6_vartype] = trialavg(PSI_6, PSI_6_vartype);
PSI_6_cat = PSI_6{1};


[PSI_8, PSI_8_vartype] = grabTHRESHdata(allData, cellType, cellmotType, 'W', trialmotType, 'all', variable, exclude, 'PSI_8');
[PSI_8, PSI_8_vartype] = trialavg(PSI_8, PSI_8_vartype);
PSI_8_cat = PSI_8{1};

[PSI_10, PSI_10_vartype] = grabTHRESHdata(allData, cellType, cellmotType, 'W', trialmotType, 'all', variable, exclude, 'PSI_10');
[PSI_10, PSI_10_vartype] = trialavg(PSI_10, PSI_10_vartype);
PSI_10_cat = PSI_10{1};

[PSI_12, PSI_12_vartype] = grabTHRESHdata(allData, cellType, cellmotType, 'W', trialmotType, 'all', variable, exclude, 'PSI_12');
[PSI_12, PSI_12_vartype] = trialavg(PSI_12, PSI_12_vartype);
PSI_12_cat = PSI_12{1};

PSI_4_cat_mean = mean(PSI_4_cat, 2, 'omitnan'); PSI_4_cat_sem = std(PSI_4_cat, [], 2, 'omitnan') / sqrt(sum(~all(isnan(PSI_4_cat))));
PSI_6_cat_mean = mean(PSI_6_cat, 2, 'omitnan'); PSI_6_cat_sem = std(PSI_6_cat, [], 2, 'omitnan') / sqrt(sum(~all(isnan(PSI_6_cat))));
PSI_8_cat_mean = mean(PSI_8_cat, 2, 'omitnan'); PSI_8_cat_sem = std(PSI_8_cat, [], 2, 'omitnan') / sqrt(sum(~all(isnan(PSI_8_cat))));
PSI_10_cat_mean = mean(PSI_10_cat, 2, 'omitnan'); PSI_10_cat_sem = std(PSI_10_cat, [], 2, 'omitnan') / sqrt(sum(~all(isnan(PSI_10_cat))));
PSI_12_cat_mean = mean(PSI_12_cat, 2, 'omitnan'); PSI_12_cat_sem = std(PSI_12_cat, [], 2, 'omitnan') / sqrt(sum(~all(isnan(PSI_12_cat))));

if norm
    shift_PSI_4 = mean(PSI_4_cat_mean(300:304));
    shift_PSI_6 = mean(PSI_6_cat_mean(300:304));
    shift_PSI_8 = mean(PSI_8_cat_mean(300:304));
    shift_PSI_10 = mean(PSI_10_cat_mean(300:304));
    shift_PSI_12 = mean(PSI_12_cat_mean(300:304));

    if shift_PSI_4 < 0
         PSI_4_cat_mean = PSI_4_cat_mean + shift_PSI_4;
    else
         PSI_4_cat_mean = PSI_4_cat_mean - shift_PSI_4;
    end

    if shift_PSI_6 < 0
         PSI_6_cat_mean = PSI_6_cat_mean + shift_PSI_6;
    else
         PSI_6_cat_mean = PSI_6_cat_mean - shift_PSI_6;
    end

    if shift_PSI_8 < 0
         PSI_8_cat_mean = PSI_8_cat_mean + shift_PSI_8;
    else
         PSI_8_cat_mean = PSI_8_cat_mean - shift_PSI_8;
    end

    if shift_PSI_10 < 0
         PSI_10_cat_mean = PSI_10_cat_mean + shift_PSI_10;
    else
         PSI_10_cat_mean = PSI_10_cat_mean - shift_PSI_10;
    end

    if shift_PSI_12 < 0
         PSI_12_cat_mean = PSI_12_cat_mean + shift_PSI_12;
    else
         PSI_12_cat_mean = PSI_12_cat_mean - shift_PSI_12;
    end
end

% % Choose color
% if strcmp(cellType, 'PV')
%     traceColor = [187, 37, 37]/255; % Red
% elseif strcmp(cellType, 'PN')
%     traceColor = [37, 112, 187]/255; % Blue
% elseif strcmp(cellType, 'VIP')
%     traceColor = [37 187 112]/255; % Green
% elseif strcmp(cellType, 'UC')
%     traceColor = [37 187 112]/255; % Black
% elseif strcmp(cellType, 'PC')
%     traceColor = [70, 204, 207]/255; % Cyan
% end

semAlpha = 0.2; % Transparency for SEM shading

% Plot PSI_4
upperBound = PSI_4_cat_mean + PSI_4_cat_sem;
lowerBound = PSI_4_cat_mean - PSI_4_cat_sem;

figure('units', 'pixels','Position', [0,0,500,450]); 

ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];


x = 1:length(PSI_4_cat_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], [91, 95, 227]/255, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

hold on;

PSI_4 = plot(x, PSI_4_cat_mean, 'Color', [91, 95, 227]/255, 'LineWidth', 2, 'LineStyle', '-');

% Plot PSI_6
upperBound = PSI_6_cat_mean + PSI_6_cat_sem;
lowerBound = PSI_6_cat_mean - PSI_6_cat_sem;

x = 1:length(PSI_6_cat_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], [91, 200, 227]/255, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

hold on;

PSI_6 = plot(x, PSI_6_cat_mean, 'Color', [91, 200, 227]/255, 'LineWidth', 2, 'LineStyle', '-');

% Plot PSI_8
upperBound = PSI_8_cat_mean + PSI_8_cat_sem;
lowerBound = PSI_8_cat_mean - PSI_8_cat_sem;

x = 1:length(PSI_8_cat_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], [91, 95, 227]/255, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

hold on;

PSI_8 = plot(x, PSI_8_cat_mean, 'Color', [91, 227, 127]/255, 'LineWidth', 2, 'LineStyle', '-');

% Plot PSI_10
upperBound = PSI_10_cat_mean + PSI_10_cat_sem;
lowerBound = PSI_10_cat_mean - PSI_10_cat_sem;

x = 1:length(PSI_10_cat_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], [227, 173, 91]/255, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

hold on;

PSI_10 = plot(x, PSI_10_cat_mean, 'Color', [227, 173, 91]/255, 'LineWidth', 2, 'LineStyle', '-');

% Plot PSI_12
upperBound = PSI_12_cat_mean + PSI_12_cat_sem;
lowerBound = PSI_12_cat_mean - PSI_12_cat_sem;

x = 1:length(PSI_12_cat_mean);
fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], [227, 93, 91]/255, ...
    'linestyle', 'none', 'FaceAlpha', semAlpha);

hold on;

PSI_12 = plot(x, PSI_12_cat_mean, 'Color', [227, 93, 91]/255, 'LineWidth', 2, 'LineStyle', '-');


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
ylim([-.3 ylimit])

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


lgd = legend({'', '4', '', '6', '', '8', '', '10', '', '12'}); 
% Set the location of the legend to 'NorthWest' which is the upper left corner
lgd.Location = 'northeast';

% Remove the box around the legend
lgd.Box = 'off';


box off

hold off

print('-dtiff', '-r300', savename);
%print('-dsvg', '-r300', savename);


end

