% Note: will only work on trialavg = 1 & catmouse = 1 OR trialavg = 1 & cellavg = 1 & catmouse = 1

function [pre, pre_wo, pre2, pre_wo2] = visualizeandtraces_ZI(neuron_colors, xlimits, ylimits, stimframe,...
    pre, pre_wo, ...
    pre2, pre_wo2, showtraces)

neuron_names = {'PV', 'PN', 'VIP', 'UC', 'SST'};

% Find neurons with evoked events pre, pre_wo (before DCZ) and pre2, pre_wo2 (after DCZ)
for i = 1:length(neuron_names)

pre_selected = pre{i};
pre_wo_selected = pre_wo{i};
pre2_selected = pre2{i};
pre_wo2_selected = pre_wo2{i};

findcells = ~isnan(pre_selected(1, :)) & ~isnan(pre_wo_selected(1,:)) & ~isnan(pre2_selected(1, :)) & ~isnan(pre_wo2_selected(1,:));

pre_selected = pre_selected(:, findcells);
pre_wo_selected = pre_wo_selected(:, findcells);
pre2_selected = pre2_selected(:, findcells);
pre_wo2_selected = pre_wo2_selected(:, findcells);

pre{i} = pre_selected;
pre_wo{i} = pre_wo_selected;
pre2{i} = pre2_selected;
pre_wo2{i} = pre_wo2_selected;


getmean_1_pre = mean(pre_selected, 2, 'omitnan');
getmean_1_pre_wo = mean(pre_wo_selected, 2, 'omitnan');

getmean_2_pre = mean(pre2_selected, 2, 'omitnan');
getmean_2_pre_wo = mean(pre_wo2_selected, 2, 'omitnan');

getsem_1_pre = mean(pre_selected, 2, 'omitnan') / sqrt(size(pre_selected, 2));
getsem_1_pre_wo = mean(pre_wo_selected, 2, 'omitnan') / sqrt(size(pre_wo_selected, 2));

getsem_2_pre = mean(pre2_selected, 2, 'omitnan') / sqrt(size(pre2_selected, 2));
getsem_2_pre_wo = mean(pre_wo2_selected, 2, 'omitnan') / sqrt(size(pre_wo2_selected, 2));


% PLOT Expt1, Expt2
if strcmp(showtraces, 'yesplot')
    figure('Position', [50 50 900 500]);
    subplot(1, 2, 1)
    plot(getmean_1_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5)
    hold on
    set(gca, 'FontSize', 15)
    fill([1:length(getmean_1_pre), length(getmean_1_pre):-1:1], [getmean_1_pre - getsem_1_pre; flipud(getmean_1_pre + getsem_1_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
    plot(getmean_1_pre_wo, 'Color', neuron_colors{i}, 'LineWidth', 0.5)
    fill([1:length(getmean_1_pre_wo), length(getmean_1_pre_wo):-1:1], [getmean_1_pre_wo - getsem_1_pre_wo; flipud(getmean_1_pre_wo + getsem_1_pre_wo)], neuron_colors{i}, 'linestyle', 'none', 'FaceAlpha', 0.5);
    xlim(xlimits)
    ylim(ylimits)
    % Manually draw x-axis only for the first 500 msec
    plot([xlimits(1), xlimits(1) + 15.49], [ylimits(1), ylimits(1)], 'k', 'LineWidth', 0.5')
    % Manually draw y-axis only up to y=0.1
    plot([xlimits(1), xlimits(1)], [ylimits(1), 0.1], 'k', 'LineWidth', 0.5')
    ax = gca;
    ax.XColor = 'none'; % Hide default x-axis
    ax.YColor = 'none'; % Hide default y-axis
    title('Expt 1')
    line([stimframe, stimframe], [-0.05 ylimits(2)], 'Color', 'k', 'LineWidth', 1)
    box off
    hold off
    
    subplot(1, 2, 2)
    plot(getmean_2_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5)
    hold on
    set(gca, 'FontSize', 15)
    fill([1:length(getmean_2_pre), length(getmean_2_pre):-1:1], [getmean_2_pre - getsem_2_pre; flipud(getmean_2_pre + getsem_2_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
    plot(getmean_2_pre_wo, 'Color', neuron_colors{i}, 'LineWidth', 0.5)
    fill([1:length(getmean_2_pre_wo), length(getmean_2_pre_wo):-1:1], [getmean_2_pre_wo - getsem_2_pre_wo; flipud(getmean_2_pre_wo + getsem_2_pre_wo)], neuron_colors{i}, 'linestyle', 'none', 'FaceAlpha', 0.5);
    xlim(xlimits)
    ylim(ylimits)
    xlim(xlimits)
    ylim(ylimits)
    % Manually draw x-axis only for the first 500 msec
    plot([xlimits(1), xlimits(1) + 15.49], [ylimits(1), ylimits(1)], 'k', 'LineWidth', 0.5')
    % Manually draw y-axis only up to y=0.1
    plot([xlimits(1), xlimits(1)], [ylimits(1), 0.1], 'k', 'LineWidth', 0.5')
    ax = gca;
    ax.XColor = 'none'; % Hide default x-axis
    ax.YColor = 'none'; % Hide default y-axis
    title('Expt 2')
    line([stimframe, stimframe], [-0.05 ylimits(2)], 'Color', 'k', 'LineWidth', 1)
    box off
    hold off
end

end