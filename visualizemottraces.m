% Note: will only work on trialavg = 1 & catmouse = 1 OR trialavg = 1 & cellavg = 1 & catmouse = 1

function visualizemottraces(xlimits, ylimits, stimframe,...
    pre, post, ...
    pre2, post2, showtraces, trialmottype)

    if strcmp(trialmottype, 'all')
        color = 'k';
    elseif strcmp(trialmottype, 'NM')
        color = [40, 62, 74]/255;
    elseif strcmp(trialmottype, 'M')
        color = 'k';
    elseif strcmp(trialmottype, 'T')
        color = 'k';
    elseif strcmp(trialmottype, 'MT')
        color = [77, 123, 161]/255;
    elseif strcmp(trialmottype, 'H')
        color = [86, 202, 193]/255;
    end



pre_selected = pre{1};
post_selected = post{1};
pre2_selected = pre2{1};
post2_selected = post2{1};


getmean_1_pre = mean(pre_selected, 2, 'omitnan');
getmean_1_post = mean(post_selected, 2, 'omitnan');

getmean_2_pre = mean(pre2_selected, 2, 'omitnan');
getmean_2_post = mean(post2_selected, 2, 'omitnan');

getsem_1_pre = mean(pre_selected, 2, 'omitnan') / sqrt(size(pre_selected, 2));
getsem_1_post = mean(post_selected, 2, 'omitnan') / sqrt(size(post_selected, 2));

getsem_2_pre = mean(pre2_selected, 2, 'omitnan') / sqrt(size(pre2_selected, 2));
getsem_2_post = mean(post2_selected, 2, 'omitnan') / sqrt(size(post2_selected, 2));


% PLOT Expt1, Expt2
if strcmp(showtraces, 'yesplot')
    figure('Position', [50 50 900 500]);
    subplot(1, 2, 1)
    plot(getmean_1_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5)
    hold on
    set(gca, 'FontSize', 15)
    fill([1:length(getmean_1_pre), length(getmean_1_pre):-1:1], [getmean_1_pre - getsem_1_pre; flipud(getmean_1_pre + getsem_1_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
    plot(getmean_1_post, 'Color', color, 'LineWidth', 0.5)
    fill([1:length(getmean_1_post), length(getmean_1_post):-1:1], [getmean_1_post - getsem_1_post; flipud(getmean_1_post + getsem_1_post)], color, 'linestyle', 'none', 'FaceAlpha', 0.5);
    xlim(xlimits)
    ylim(ylimits)
    % Manually draw x-axis only for the first 500 msec
    plot([xlimits(1), xlimits(1) + 15.49], [ylimits(1), ylimits(1)], 'k', 'LineWidth', 0.5')
    % Manually draw y-axis only up to y=0.25
    plot([xlimits(1), xlimits(1)], [ylimits(1), 0.25], 'k', 'LineWidth', 0.5')
    ax = gca;
    ax.XColor = 'none'; % Hide default x-axis
    ax.YColor = 'none'; % Hide default y-axis
    title('Expt 1')
    line([stimframe, stimframe], [-0.05 ylimits(2)], 'Color', 'k', 'LineWidth', 1)
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
    box off
    hold off
    
    subplot(1, 2, 2)
    plot(getmean_2_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5)
    hold on
    set(gca, 'FontSize', 15)
    fill([1:length(getmean_2_pre), length(getmean_2_pre):-1:1], [getmean_2_pre - getsem_2_pre; flipud(getmean_2_pre + getsem_2_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
    plot(getmean_2_post, 'Color', color, 'LineWidth', 0.5)
    fill([1:length(getmean_2_post), length(getmean_2_post):-1:1], [getmean_2_post - getsem_2_post; flipud(getmean_2_post + getsem_2_post)], color, 'linestyle', 'none', 'FaceAlpha', 0.5);
    xlim(xlimits)
    ylim(ylimits)
    % Manually draw x-axis only for the first 500 msec
   plot([xlimits(1), xlimits(1) + 15.49], [ylimits(1), ylimits(1)], 'k', 'LineWidth', 0.5')
    % Manually draw y-axis only up to y=0.25
    plot([xlimits(1), xlimits(1)], [ylimits(1), 0.25], 'k', 'LineWidth', 0.5')
    ax = gca;
    ax.XColor = 'none'; % Hide default x-axis
    ax.YColor = 'none'; % Hide default y-axis
    title('Expt 2')
    line([stimframe, stimframe], [-0.05 ylimits(2)], 'Color', 'k', 'LineWidth', 1)
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
    box off
    hold off
end

end