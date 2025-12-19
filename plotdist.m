function plotdist(cellType, getvarcat, getvarcat2, gettitle, x_label, y_label, nBins, savename, xlimits, ylimits, ignorenan)

% Set colors, format plot
if strcmp(cellType, 'PV')
    Color = [187, 37, 37]/255; % Red
elseif strcmp(cellType, 'PN')
    Color = [37, 112, 187]/255; % Blue
elseif strcmp(cellType, 'VIP')
    Color = [37 187 112]/255; % Green
elseif strcmp(cellType, 'UC')
    Color = [0 0 0]/255; % Black
end

if ignorenan
    indices = ~isnan(getvarcat) & ~isnan(getvarcat2);
    getvarcat = getvarcat(indices); getvarcat2 = getvarcat2(indices);
end

if size(xlimits, 2) == 2
    xlim(xlimits)
    bins = linspace(xlimits(1), xlimits(2), nBins);
else
    minimum = min(min(getvarcat, getvarcat2));
    maximum = max(max(getvarcat, getvarcat2));
    bins = linspace(minimum, maximum, nBins);
end

if size(ylimits, 2) == 2
    ylim(ylimits)
end

figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];

% Plot
histogram(getvarcat, 'BinEdges', bins, 'FaceColor', [0.5 0.5 0.5], 'FaceAlpha', 0.2, 'EdgeColor', [0.5 0.5 0.5])
hold on
histogram(getvarcat2, 'BinEdges', bins, 'FaceColor', Color, 'FaceAlpha', 0.2, 'EdgeColor', Color)

length(getvarcat)
length(getvarcat2)

set(gca,'FontSize', 20, 'FontWeight', 'normal'); 
xlabel(x_label, 'FontSize', 15);
ylabel(y_label, 'FontSize', 25);
title(gettitle, 'FontSize', 28, 'FontWeight', 'normal');


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

print('-dtiff', '-r300', savename);


hold off

end
