function slope_grant(allData, active_PRE_RWS, active_POST_RWS, increase_cells, decrease_cells, norm, window)

maxnumcells = max(size(active_POST_RWS, 1), size(active_PRE_RWS, 1));

nFrames = size(allData.data{1}.evokedtraces, 1);

traces_pre = zeros(nFrames, maxnumcells);
traces_post = zeros(nFrames, maxnumcells);
traces_onlypost = zeros(nFrames, maxnumcells);
traces_onlypre = zeros(nFrames, maxnumcells);

nMice = length(allData.data);

c = 1;
d = 1;
e = 1;
ff = 1;
for i = 1:nMice
    active_PRE = active_PRE_RWS(:, 2) == i;
    active_POST = active_POST_RWS(:, 2) == i;

    active_PRE = active_PRE_RWS(active_PRE, 1);
    active_POST = active_POST_RWS(active_POST, 1);

    active_PREandPOST = intersect(active_PRE, active_POST);
    active_onlyPOST = setdiff(active_POST, active_PRE);
    active_onlyPRE = setdiff(active_PRE, active_POST);

    trialType = allData.data{i}.trialType;
    trialmotType = allData.data{i}.trialmotType;
    tetPeriod = allData.data{i}.tetPeriod;

    traces = allData.data{i}.evokedtraces;
    
    % normalize
    [~, N, T] = size(traces);
    for n = 1:N
        for t = 1:T
            temp = traces(:, n, t);
            pre_stim = mean(temp(300:310));
            temp = temp-pre_stim;
            traces(:, n, t) = temp;
        end
    end

    pre_trials = strcmp(trialType, 'W') & strcmp(tetPeriod, 'PRE') & strcmp(trialmotType, 'NM');
    post_trials = strcmp(trialType, 'W') & strcmp(tetPeriod, 'POST')  & strcmp(trialmotType, 'NM');

    pre_active_onlyPRE = traces(:, active_onlyPRE, pre_trials);
    pre_active_PREandPOST = traces(:, active_PREandPOST, pre_trials);
    post_active_PREandPOST = traces(:, active_PREandPOST, post_trials);
    post_active_onlyPOST = traces(:, active_onlyPOST, post_trials);

    pre_active_onlyPRE = mean(pre_active_onlyPRE, 3, 'omitnan');
    pre_active_PREandPOST = mean(pre_active_PREandPOST, 3, 'omitnan');
    post_active_PREandPOST = mean(post_active_PREandPOST, 3, 'omitnan');
    post_active_onlyPOST = mean(post_active_onlyPOST, 3, 'omitnan');

    if length(pre_active_PREandPOST) > 0
        temp_cells = size(pre_active_PREandPOST, 2);
        traces_pre(:, c:c+temp_cells-1) = pre_active_PREandPOST ;
        c = c + temp_cells;
    end

    if length(post_active_PREandPOST) > 0
        temp_cells = size(post_active_PREandPOST, 2);
        traces_post(:, d:d+temp_cells-1) = post_active_PREandPOST ;
        d = d + temp_cells;
    end

    if length(post_active_onlyPOST) > 0
        temp_cells = size(post_active_onlyPOST, 2);
        traces_onlypost(:, e:e+temp_cells-1) = post_active_onlyPOST ;
        e = e + temp_cells;
    end

    if length(pre_active_onlyPRE) > 0
        temp_cells = size(pre_active_onlyPRE, 2);
        traces_onlypre(:, ff:ff+temp_cells-1) = pre_active_onlyPRE ;
        ff = ff + temp_cells;
    end


end

    for i = 1:maxnumcells
        if traces_pre(310, i) > 0.25
            traces_pre(:, i) = NaN;
        end
        if traces_onlypre(310, i) > 0.5
            traces_onlypre(:, i) = NaN;
        end
        if traces_post(310, i) > 0.5
            traces_post(:, i) = NaN;
        end
        if traces_onlypost(310, i) > 0.5
            traces_onlypost(:, i) = NaN;
        end

    end
    removecols = all(traces_pre == 0, 1);
    traces_pre(:, removecols) = [];

    removecols = all(traces_onlypre == 0, 1);
    traces_onlypre(:, removecols) = [];

    removecols = all(traces_post == 0, 1);
    traces_post(:, removecols) = [];

    removecols = all(traces_onlypost == 0, 1);
    traces_onlypost(:, removecols) = [];

    all_pre = cat(2, traces_pre, traces_onlypre);
    all_post = cat(2, traces_post, traces_onlypost);

    deriv_all_pre = zeros(1, size(all_pre, 2));
    for d = 1:size(all_pre, 2)
        temp = all_pre(:, d);
        temp = diff(temp);
        temp = mean(temp(window(1):window(2)), 'omitnan');
        deriv_all_pre(1, d) = temp;
    end

%     deriv_traces_pre = zeros(619, size(traces_pre, 2));
%     for d = 1:size(traces_pre, 2)
%         temp = traces_pre(:, d);
%         temp = diff(temp);
%         deriv_traces_pre(:, d) = temp;
%     end

    deriv_all_post = zeros(1, size(all_post, 2));
    for d = 1:size(all_post, 2)
        temp = all_post(:, d);
        temp = diff(temp);
        temp = mean(temp(window(1):window(2)), 'omitnan');
        deriv_all_post(1, d) = temp;
    end

        % Subplot for RWS
    figure;
    hold on;
    bar([1,2], [mean(deriv_all_pre, 'omitnan'), mean(deriv_all_post, 'omitnan')], 0.5, 'FaceColor', 'k', 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'BarWidth', 0.5);
    errorbar([1,2], [mean(deriv_all_pre, 'omitnan'), mean(deriv_all_post, 'omitnan')], [std(deriv_all_pre, 'omitnan')/sqrt(length(deriv_all_pre)), std(deriv_all_post, 'omitnan')/sqrt(length(deriv_all_post))], 'Color', 'k', 'linestyle', 'none');
%     if strcmp(plottype, 'onlylines')
%         plot([ones(nCells_RWS,1), 2*ones(nCells_RWS,1)]', [deriv_all_pre, deriv_all_post]', '-', 'Color', colors{counter}(1:3));
%         errorbar([1,2], [mean(deriv_all_pre, 'omitnan'), mean(deriv_all_post, 'omitnan')], [std(deriv_all_pre, 'omitnan')/sqrt(n_pre_RWS), std(deriv_all_post, 'omitnan')/sqrt(n_post_RWS)], 'Color', colors{counter}(1:3), 'linestyle', 'none');
%     else
%         plot([ones(nCells_RWS,1), 2*ones(nCells_RWS,1)]', [deriv_all_pre, deriv_all_post]', '-o', 'Color', colors{counter}(1:3), 'MarkerFaceColor', colors{counter}(1:3));
%     end
    xticks([1 2]);
    xticklabels({'Pre', 'Post'});
    ylabel('Slope (d(∆F/F0)/dt');
    %title('RWS');
    hold off;
   % ylim([ylimit])
    ax = gca;
    ax.FontSize = 15;

    getactive_pre = ~isnan(deriv_all_pre); getactive_pre = deriv_all_pre(getactive_pre);
    getactive_post = ~isnan(deriv_all_post); getactive_post = deriv_all_post(getactive_post);
    [p, ~] = ranksum(getactive_pre, getactive_post)

    % Plot line above error bars with asterisk if p-value is significant
    if p < 0.05
        y = max([mean(deriv_all_pre, 'omitnan') + std(deriv_all_pre, 'omitnan')/sqrt(length(deriv_all_pre)), mean(deriv_all_post, 'omitnan') + std(deriv_all_post, 'omitnan')/sqrt(length(deriv_all_post))]);
        line([1 2], [y y] * 1.1, 'Color', 'k', 'LineWidth', 1.5);
        text(1.5, y * 1.15, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 20);
    elseif p > 0.05
        y = max([mean(deriv_all_pre, 'omitnan') + std(deriv_all_pre, 'omitnan')/sqrt(length(deriv_all_pre)), mean(deriv_all_post, 'omitnan') + std(deriv_all_post, 'omitnan')/sqrt(length(deriv_all_post))]);
        line([1 2], [y y] * 1.1, 'Color', 'k', 'LineWidth', 1.5);
        text(1.5, y * 1.15, 'n.s.', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 20);
    end

    ylim([0 0.2])

end