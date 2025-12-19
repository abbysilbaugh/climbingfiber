function dist_spikelatency_PREPOST(allData, plot_cellType, plot_motType, exclude, nBins, savename)



if strcmp(plot_cellType, 'PV')
    Color = [187, 37, 37]/255; % Red
elseif strcmp(plot_cellType, 'PN')
    Color = [37, 112, 187]/255; % Blue
elseif strcmp(plot_cellType, 'VIP')
    Color = [37 187 112]/255; % Green
elseif strcmp(plot_cellType, 'UC')
    Color = [37 187 112]/255; % Green
end

[getspiketimes_RWSpre, vartype] = grabdata(allData, plot_cellType, 'all', 'W', plot_motType, 'PRE', 'firstspike', exclude);
[getspiketimes_RWSpre, vartype] = trialpool(getspiketimes_RWSpre, vartype);
[spiketimes_cat_RWSpre, varcattype] = catmice(allData, getspiketimes_RWSpre, vartype, 'whiskerTet');

[getspiketimes_RWSpost, vartype] = grabdata(allData, plot_cellType, 'all', 'W', plot_motType, 'POST', 'firstspike', exclude);
[getspiketimes_RWSpost, vartype] = trialpool(getspiketimes_RWSpost, vartype);
[spiketimes_cat_RWSpost, varcattype] = catmice(allData, getspiketimes_RWSpost, vartype, 'whiskerTet');

[getspiketimes_RWSCFpre, vartype] = grabdata(allData, plot_cellType, 'all', 'W', plot_motType, 'PRE', 'firstspike', exclude);
[getspiketimes_RWSCFpre, vartype] = trialpool(getspiketimes_RWSCFpre, vartype);
[spiketimes_cat_RWSCFpre, varcattype] = catmice(allData, getspiketimes_RWSCFpre, vartype, 'whiskerOptoTet');

[getspiketimes_RWSCFpost, vartype] = grabdata(allData, plot_cellType, 'all', 'W', plot_motType, 'POST', 'firstspike', exclude);
[getspiketimes_RWSCFpost, vartype] = trialpool(getspiketimes_RWSCFpost, vartype);
[spiketimes_cat_RWSCFpost, varcattype] = catmice(allData, getspiketimes_RWSCFpost, vartype, 'whiskerOptoTet');

bins = linspace(300, 402, nBins);

if ~isempty(getspiketimes_RWSpre)
    
    % PLOT RWS
    figure('units', 'pixels','Position', [0,0,500,450]);
    ax = gca;
    ax.Units = 'pixels';
    ax.Position = [105, 95, 350, 300];
    
    histogram(spiketimes_cat_RWSpre, 'BinEdges', bins, 'FaceColor', 'k', 'FaceAlpha', 0.2, 'EdgeColor', 'k')
    hold on
    histogram(spiketimes_cat_RWSpost, 'BinEdges', bins, 'FaceColor', Color, 'FaceAlpha', 0.2, 'EdgeColor', Color)
    
    set(gca,'FontSize', 20, 'FontWeight', 'normal'); 
    % xlabel(x_label, 'FontSize', 40);
    % ylabel(y_label, 'FontSize', 25);
    % title(gettitle, 'FontSize', 28, 'FontWeight', 'normal');
    
    xticks([304 - 30.98, 304, 304 + 30.98, 304 + 30.98 + 30.98, 304+ 3*30.98])
    xticklabels([-1 0 1 2 3])
    xlim([300 402])
    ylim([0 1500])

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
    
    print('-dtiff', '-r300', savename{1});
    
    hold off


    % PLOT RWSCF
    figure('units', 'pixels','Position', [0,0,500,450]);
    ax = gca;
    ax.Units = 'pixels';
    ax.Position = [105, 95, 350, 300];
    
    histogram(spiketimes_cat_RWSCFpre, 'BinEdges', bins, 'FaceColor', 'k', 'FaceAlpha', 0.2, 'EdgeColor', 'k')
    hold on
    histogram(spiketimes_cat_RWSCFpost, 'BinEdges', bins, 'FaceColor', Color, 'FaceAlpha', 0.2, 'EdgeColor', Color)
    
    % set(gca,'FontSize', 20, 'FontWeight', 'normal'); 
    % xlabel(x_label, 'FontSize', 40);
    % ylabel(y_label, 'FontSize', 25);
    % title(gettitle, 'FontSize', 28, 'FontWeight', 'normal');
    
    xticks([304 - 30.98, 304, 304 + 30.98, 304 + 30.98 + 30.98, 304+ 3*30.98])
    xticklabels([-1 0 1 2 3])
    xlim([300 402])
    ylim([0 1500])

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
    
    print('-dtiff', '-r300', savename{2});
    
    hold off
end

end
