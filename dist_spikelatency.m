function dist_spikelatency(allData, plot_cellType, plot_stimType, plot_motType, exclude, nBins, ylimit, xlimit, savename)



if strcmp(plot_cellType, 'PV')
    Color = [187, 37, 37]/255; % Red
elseif strcmp(plot_cellType, 'PN')
    Color = [37, 112, 187]/255; % Blue
elseif strcmp(plot_cellType, 'VIP')
    Color = [37 187 112]/255; % Green
elseif strcmp(plot_cellType, 'UC')
    Color = [37 187 112]/255; % Green
elseif strcmp(plot_cellType, 'all')
    Color = 'k';
end

[getspiketimes, vartype] = grabdata(allData, plot_cellType, 'all', plot_stimType, plot_motType, 'PRE', 'firstspike', exclude);
[getspiketimes, vartype] = trialpool(getspiketimes, vartype);
[spiketimes_cat, varcattype] = catmice(allData, getspiketimes, vartype, 'all');




minimum = min(spiketimes_cat);
maximum = max(spiketimes_cat);

if ~isempty(minimum)
    bins = linspace(minimum, xlimit, nBins);
    
    figure('units', 'pixels','Position', [0,0,500,450]);
    ax = gca;
    ax.Units = 'pixels';
    ax.Position = [105, 95, 350, 300];
    
    histogram(spiketimes_cat, 'BinEdges', bins, 'FaceColor', Color, 'FaceAlpha', 0.2, 'EdgeColor', Color)
    
    % set(gca,'FontSize', 20, 'FontWeight', 'normal'); 
    % xlabel(x_label, 'FontSize', 40);
    % ylabel(y_label, 'FontSize', 25);
    % title(gettitle, 'FontSize', 28, 'FontWeight', 'normal');
    
    xticks([304 - 30.98, 304, 304 + 30.98, 304 + 30.98 + 30.98, 304+ 3*30.98])
    xticklabels([-1 0 1 2 3])
    xlim([304 xlimit])
    ylim([0 ylimit])

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
    
    %print('-dtiff', '-r300', savename);
    
    hold off
end

end
