% Note: will only work on trialavg = 1 & catmouse = 1 OR trialavg = 1 & cellavg = 1 & catmouse = 1

function visualizeortracesPVandSST(neuron_colors, xlimits, ylimits, stimframe,...
    pre, post, ...
    pre2, post2, showtraces)

neuron_names = {'PV', 'PN', 'VIP', 'UC', 'SST'};

% Find neurons with evoked events both pre and post

pre_PV = pre{1};
post_PV = post{1};
pre2_PV = pre2{1};
post2_PV = post2{1};

pre_SST = pre{5};
post_SST = post{5};
pre2_SST = pre2{5};
post2_SST = post2{5};

% find_1 = ~isnan(pre_selected(1, :)) & ~isnan(post_selected(1,:));% & ~isnan(RWS_pre_wo_selected(1,:));
% find_2 = ~isnan(pre2_selected(1, :)) & ~isnan(post2_selected(1,:));% & ~isnan(RWSCF_pre_wo_selected(1,:));
% 
% pre_selected = pre_selected(:, find_1);
% post_selected = post_selected(:, find_1);
% pre2_selected = pre2_selected(:, find_2);
% post2_selected = post2_selected(:, find_2);

pre = cat(2, pre_PV, pre_SST);
post = cat(2, post_PV, post_SST);
pre2 = cat(2, pre2_PV, pre2_SST);
post2 = cat(2, post2_PV, post2_SST);

neuron_color = (neuron_colors{1} + neuron_colors{2})/2;


getmean_1_pre = mean(pre, 2, 'omitnan');
getmean_1_post = mean(post, 2, 'omitnan');

getmean_2_pre = mean(pre2, 2, 'omitnan');
getmean_2_post = mean(post2, 2, 'omitnan');

getsem_1_pre = mean(pre, 2, 'omitnan') / sqrt(size(pre, 2));
getsem_1_post = mean(post, 2, 'omitnan') / sqrt(size(post, 2));

getsem_2_pre = mean(pre2, 2, 'omitnan') / sqrt(size(pre2, 2));
getsem_2_post = mean(post2, 2, 'omitnan') / sqrt(size(post2, 2));


% PLOT Expt1, Expt2
if strcmp(showtraces, 'yesplot')
    figure('Position', [50 50 900 500]);
    subplot(1, 2, 1)
    plot(getmean_1_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5)
    hold on
    set(gca, 'FontSize', 15)
    fill([1:length(getmean_1_pre), length(getmean_1_pre):-1:1], [getmean_1_pre - getsem_1_pre; flipud(getmean_1_pre + getsem_1_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
    plot(getmean_1_post, 'Color', neuron_color, 'LineWidth', 0.5)
    fill([1:length(getmean_1_post), length(getmean_1_post):-1:1], [getmean_1_post - getsem_1_post; flipud(getmean_1_post + getsem_1_post)], neuron_color, 'linestyle', 'none', 'FaceAlpha', 0.5);
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
    plot(getmean_2_post, 'Color', neuron_color, 'LineWidth', 0.5)
    fill([1:length(getmean_2_post), length(getmean_2_post):-1:1], [getmean_2_post - getsem_2_post; flipud(getmean_2_post + getsem_2_post)], neuron_color, 'linestyle', 'none', 'FaceAlpha', 0.5);
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