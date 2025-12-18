function plotcbdata(cbdata, auc_max_win)

mse1_sig1 = cbdata.mse1_sig1; % mouse 1; (1 x 50)
mse1_sig2 = cbdata.mse1_sig2; % mouse 1; (3 x 15)*2
mse2_sig1 = cbdata.mse2_sig1; % mouse 2; (3 x 15)
mse2_sig2 = cbdata.mse2_sig2; % mouse 2; (1 x 50)
mse2_sig3 = cbdata.mse2_sig3; % mouse 2; (2 x 20)
mse2_sig4 = cbdata.mse2_sig4; % mouse 2; (3 x 15)*2

% FIGURE ONE:
% Plot trial-averaged traces for selected ROIs (mouse2, stimulus condition 2)
    xlimits = [308, 350];
    mean_mse2_sig2 = mean(mse2_sig2, 3);
    sem_mse2_sig2 = std(mse2_sig2, 0, 3) ./ sqrt(size(mse2_sig2, 3));
    for i = [3, 7, 16, 19, 62]
    figure('Position', [1459,692,270,271])
    hold on;
    y = mean_mse2_sig2(:, i);
    sem_y = sem_mse2_sig2(:, i);
    x = 1:length(y);
    plot(x, y, 'Color', [179 78 157]/255, 'LineWidth', 0.5);
    fill([x, fliplr(x)], [y - sem_y; flipud(y + sem_y)], [179 78 157]/255, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    xlim(xlimits)
    
    % Manually draw x-axis only for the first 500 msec
    plot([308, 308 + 15.49], [-0.1, -0.1], 'k', 'LineWidth', 0.5')
    
    % Manually draw y-axis only up to y=0.1
    plot([308, 308], [-0.1, 0.1], 'k', 'LineWidth', 0.5')
    xticks([295 310 325 341 356])
    xticklabels([-500 0 500 1000 1500])
    xline(310)
    ax = gca;
    ax.XColor = 'none'; % Hide default x-axis
    ax.YColor = 'none'; % Hide default y-axis
    
    % Keep full y-axis range
    ylim([-0.1, 1.2])
    
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
    hold off;

    end

% Plot trial-averaged amplitude for each ROI from condition 2, mouse 2 -- BOX PLOT
    max_mse2_sig2 = max(mean_mse2_sig2);
    figure('Position', [962,778,120,200]);
    hold on;
    boxplot(max_mse2_sig2, 'Notch', 'off', 'Symbol', '', 'Widths', 0.3, 'Colors', 'k', 'Whisker', 0);
    boxLines = findobj(gca, 'Tag', 'Box');
    set(boxLines, 'LineWidth', 0.5, 'Color', 'k');
    medianLine = findobj(gca, 'Tag', 'Median');
    set(medianLine, 'Color', 'k', 'LineWidth', 1.5);
    numPoints = length(max_mse2_sig2);
    x_jitter = 0.2 * (rand(numPoints, 1) - 0.5); % Small random jitter around x = 1
    scatter(ones(size(max_mse2_sig2)) + x_jitter, max_mse2_sig2, 12, [179 78 157]/255, 'filled');
    set(gca, 'XColor', 'none', 'XTick', []);
    box off
    xlim([.6 1.4])
    ylim([.15 1.25])
    ylabel('Amplitude (∆F/F)')
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

% FIGURE S1:
% Plot population average traces for mouse 2 (all conditions plotted)
    mean_mse2_sig1 = mean(mse2_sig1, 3);
    mean_mse2_sig2 = mean(mse2_sig2, 3);
    mean_mse2_sig3 = mean(mse2_sig3, 3);
    mean_mse2_sig4 = mean(mse2_sig4, 3);

    mean_mse1_sig1 = mean(mse1_sig1, 3);
    mean_mse1_sig2 = mean(mse1_sig2, 3);

    cellavg_mse2_sig1 = mean(mean_mse2_sig1, 2);
    cellsem_mse2_sig1 = std(mean_mse2_sig1, 0, 2) ./ sqrt(size(mean_mse2_sig1, 2));
    cellavg_mse2_sig2 = mean(mean_mse2_sig2, 2);
    cellsem_mse2_sig2 = std(mean_mse2_sig2, 0, 2) ./ sqrt(size(mean_mse2_sig2, 2));
    cellavg_mse2_sig3 = mean(mean_mse2_sig3, 2);
    cellsem_mse2_sig3 = std(mean_mse2_sig3, 0, 2) ./ sqrt(size(mean_mse2_sig3, 2));
    cellavg_mse2_sig4 = mean(mean_mse2_sig4, 2);
    cellsem_mse2_sig4 = std(mean_mse2_sig4, 0, 2) ./ sqrt(size(mean_mse2_sig4, 2));

    figure('Position', [1460,347,178,271]);
    hold on
    % Signal 1
    x = (1:length(cellavg_mse2_sig1))';
    fill([x; flipud(x)], [cellavg_mse2_sig1 - cellsem_mse2_sig1; flipud(cellavg_mse2_sig1 + cellsem_mse2_sig1)], ...
        [42,95,160]/255, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    plot(x, cellavg_mse2_sig1, 'Color', [42,95,160]/255, 'LineWidth', 1.5);
    
    % Signal 2
    x = (1:length(cellavg_mse2_sig2))';
    fill([x; flipud(x)], [cellavg_mse2_sig2 - cellsem_mse2_sig2; flipud(cellavg_mse2_sig2 + cellsem_mse2_sig2)], ...
        [179 78 157]/255, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    plot(x, cellavg_mse2_sig2, 'Color', [179 78 157]/255, 'LineWidth', 1.5);
    
    % Signal 3
    x = (1:length(cellavg_mse2_sig3))';
    fill([x; flipud(x)], [cellavg_mse2_sig3 - cellsem_mse2_sig3; flipud(cellavg_mse2_sig3 + cellsem_mse2_sig3)], ...
        [52,81,211]/255, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    plot(x, cellavg_mse2_sig3, 'Color', [52,81,211]/255, 'LineWidth', 1.5);
    
    % Signal 4
    x = (1:length(cellavg_mse2_sig4))';
    fill([x; flipud(x)], [cellavg_mse2_sig4 - cellsem_mse2_sig4; flipud(cellavg_mse2_sig4 + cellsem_mse2_sig4)], ...
        [121,156,238]/255, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    plot(x, cellavg_mse2_sig4, 'Color', [121,156,238]/255, 'LineWidth', 1.5);
    ylim([-0.1 .5])
    xlim([308 360]);
    xline(310)
    % Manually draw x-axis only for the first 500 msec
    plot([308, 308 + 15.49], [-0.1, -0.1], 'k', 'LineWidth', 0.5')
    
    % Manually draw y-axis only up to y=0.1
    plot([308, 308], [-0.1, 0.1], 'k', 'LineWidth', 0.5')
    xticks([295 310 325 341 356])
    xticklabels([-500 0 500 1000 1500])
    xline(310)
    ylabel('ΔF/F0')
    xlabel('msec')

    ax = gca;
    ax.XColor = 'none'; % Hide default x-axis
    ax.YColor = 'none'; % Hide default y-axis
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

% Plot population average traces across both mice
    % 1 x 50 msec stim (compile)
    temp = mean_mse2_sig2(2:618, :);
    evokedcat = cat(2, mean_mse1_sig1, temp);
    evokedcat = evokedcat(300:345, :);
    getcatmean = mean(evokedcat, 2);
    getcatsem = std(evokedcat, 0, 2) ./ sqrt(size(evokedcat, 2));

    figure('Position', [962,778,120,200]);
    hold on;
    x = (1:length(getcatmean))';
    fill([x; flipud(x)], [getcatmean - getcatsem; flipud(getcatmean + getcatsem)], ...
        [179 78 157]/255, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    plot(x, getcatmean, 'Color', [179 78 157]/255, 'LineWidth', 1.5);
        ylim([-0.1 .4])
    xline(10)
        % Manually draw x-axis only for the first 500 msec
    plot([0, 15.49], [-0.1, -0.1], 'k', 'LineWidth', 0.5')
    % Manually draw y-axis only up to y=0.1
    plot([0, 0], [-0.1, 0.1], 'k', 'LineWidth', 0.5')
    ax = gca;
    ax.XColor = 'none'; % Hide default x-axis
    ax.YColor = 'none'; % Hide default y-axis

% Plot population average spontaneous trace across spontaneous events
    spont_m1 = cbdata.spontevents_m1;
    spont_m2 = cbdata.spontevents_m2;
    spontcat = cat(2, spont_m1, spont_m2);
    findnan = isnan(spontcat(1, :));

    spontrate_m1 = cbdata.sponteventrate_m1;
    spontrate_m2 = cbdata.sponteventrate_m2;
    spontratecat = cat(1, spontrate_m1, spontrate_m2);

    for i = 1:size(spontcat, 2)
        temp = spontcat(5:10, i);
        temp = mean(temp);
        spontcat(:, i) = spontcat(:, i) - temp;
    end

    avg_spont = mean(spontcat, 2, 'omitnan');
    sem_spont = std(spontcat, 0, 2, 'omitnan') ./ sqrt(sum(~findnan));

    figure('Position', [818,778,120,200]);
    hold on;
    x = (1:length(avg_spont))';
    fill([x; flipud(x)], [avg_spont - sem_spont; flipud(avg_spont + sem_spont)], ...
        'k', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    plot(x, avg_spont, 'Color', 'k', 'LineWidth', 1.5);
        % Manually draw x-axis only for the first 500 msec
    plot([0, 0 + 15.49], [-0.1, -0.1], 'k', 'LineWidth', 0.5')
    % Manually draw y-axis only up to y=0.1
    plot([0, 0], [-0.1, 0.1], 'k', 'LineWidth', 0.5')
            ylim([-0.1 .4])
    ax = gca;
    ax.XColor = 'none'; % Hide default x-axis
    ax.YColor = 'none'; % Hide default y-axis

% Compare maximum and latency between spontaneous and evoked events
    nCells = size(evokedcat, 2);
    evoked_mins = NaN(nCells, 2);
    evoked_maxs = NaN(nCells, 2);
    spont_mins = NaN(nCells, 2);
    spont_maxs = NaN(nCells, 2);
    
    for i = 1:nCells
        temp_evoked = evokedcat(:, i);
        evoked_mins(i, :) = [9, temp_evoked(9)];
        [m, idx] = max(temp_evoked(10:end));
        evoked_maxs(i, :) = [idx+10, m];
    
        temp_spont = spontcat(:, i);
        [m, idx] = min(temp_spont(1:9));
        spont_mins(i, :) = [idx, m];
        [m, idx] = max(temp_spont(10:end));
        spont_maxs(i, :) = [idx+9, m];
    
    end

    evoked_latency = evoked_maxs(:, 1) - evoked_mins(:, 1);
    evoked_amp = evoked_maxs(:, 2) - evoked_mins(:, 2);
    spont_latency = spont_maxs(:, 1) - spont_mins(:, 1);
    spont_amp = spont_maxs(:, 2) - spont_mins(:, 2);
    
    nan1 = isnan(evoked_latency);
    nan2 = isnan(evoked_amp);
    nan3 = isnan(spont_latency);
    nan4 = isnan(spont_amp);

    findnanvals = nan1 + nan2 + nan3 + nan4;

    evoked_latency = evoked_latency(~findnanvals);
    evoked_amp = evoked_amp(~findnanvals);
    spont_latency = spont_latency(~findnanvals);
    spont_amp = spont_amp(~findnanvals);
    spont_rate = spontratecat(~findnanvals);
    
%     evoked_latency = (evoked_latency/30.98)*1000;
%     spont_latency = (spont_latency/30.98)*1000;
    
    % Compute differences for normality testing
    diff_amp = spont_amp - evoked_amp;
    diff_latency = spont_latency - evoked_latency;
    
    % Use kstest on standardized differences
    normal_amp = kstest((diff_amp - mean(diff_amp)) / std(diff_amp)) == 0;        % 0 = normal
    normal_latency = kstest((diff_latency - mean(diff_latency)) / std(diff_latency)) == 0;
    
    % Select test based on normality
    if normal_amp
        [~, p_amp] = ttest(spont_amp, evoked_amp)
        warning('ttest')
    else
        [p_amp, ~] = signrank(spont_amp, evoked_amp)
        warning('signrank')
    end

    if normal_latency
        [~, p_latency] = ttest(spont_latency, evoked_latency)
        warning('ttest')
    else
        [p_latency, ~] = signrank(spont_latency, evoked_latency)
        warning('signrank')
    end

%% Amplitude Box Plot
figure('Position', [680,855,176,123]); 
hold on

amp_data = {spont_amp, evoked_amp};
amp_means = cellfun(@mean, amp_data);
amp_sems = cellfun(@(x) std(x)/sqrt(length(x)), amp_data);

% Combine for boxplot
data_all = [spont_amp(:); evoked_amp(:)];
group_all = [ones(size(spont_amp(:))); 2*ones(size(evoked_amp(:)))];

% Box plot
boxplot(data_all, group_all, 'Colors', 'k', 'Symbol', '', ...
    'BoxStyle', 'outline', 'Widths', 0.5, 'MedianStyle', 'target');

% Overlay mean points
plot(1:2, amp_means, 'ok', 'MarkerFaceColor', 'k', 'MarkerSize', 3);

% Error bars for SEM
errorbar(1:2, amp_means, amp_sems, 'k', 'linestyle', 'none', 'linewidth', 1);

% Axis formatting
set(gca, 'xtick', 1:2, 'xticklabel', {'Spontaneous', 'Evoked'});
ylabel('Amplitude (∆F/F)');
ylim([0 1.1]);
box off;
set(gca, 'FontSize', 7, 'FontName', 'Helvetica');

% Add significance marker
y_max = max(amp_means + amp_sems) * 1.1;
line([1 2], [y_max y_max], 'color', 'k');
text(1.5, y_max * 1.1, get_star(p_amp), 'HorizontalAlignment', 'center', 'FontSize', 7);
xlim([0.5 2.5]);

%% Latency Box Plot
figure('Position', [680,855,176,123]);
hold on

latency_data = {spont_latency, evoked_latency};
latency_means = cellfun(@mean, latency_data);
latency_sems = cellfun(@(x) std(x)/sqrt(length(x)), latency_data);

data_all = [spont_latency(:); evoked_latency(:)];
group_all = [ones(size(spont_latency(:))); 2*ones(size(evoked_latency(:)))];

boxplot(data_all, group_all, 'Colors', 'k', 'Symbol', '', ...
    'BoxStyle', 'outline', 'Widths', 0.5, 'MedianStyle', 'target');

% Overlay mean
plot(1:2, latency_means, 'ok', 'MarkerFaceColor', 'k', 'MarkerSize', 3);

% Error bars for SEM
errorbar(1:2, latency_means, latency_sems, 'k', 'linestyle', 'none', 'linewidth', 1);

% Axis formatting
set(gca, 'xtick', 1:2, 'xticklabel', {'Spontaneous', 'Evoked'});
yticks([3.098, 6.1960, 9.294, 12.3920]);
yticklabels([100, 200, 300, 400]);
ylabel('Latency to peak (ms)');
box off;
set(gca, 'FontSize', 7, 'FontName', 'Helvetica');
xlim([0.5 2.5]);

    % Add significance marker
    y_max = max(latency_means + latency_sems) * 1.1;
    line([1 2], [y_max y_max], 'color', 'k')
    text(1.5, y_max * 1.1, get_star(p_latency), 'HorizontalAlignment', 'center', 'FontSize', 7)
    xlim([0.5 2.5])
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
    ylim([0 15])


    
    % Amplitude Bar Plot
    amp_data = {spont_amp, evoked_amp};
    amp_means = cellfun(@mean, amp_data);
    amp_sems = cellfun(@(x) std(x)/sqrt(length(x)), amp_data);
    
    figure('Position', [680,855,176,123]);
    bar(1:2, amp_means, 'FaceColor', 'k')
    hold on
    errorbar(1:2, amp_means, amp_sems, 'k', 'linestyle', 'none', 'linewidth', 1)
    set(gca, 'xtick', 1:2, 'xticklabel', {'Spontaneous', 'Evoked'})
    ylabel('Amplitude (∆F/F)')
    ylim([0 0.5])
    box off
    
    % Add significance marker
    y_max = max(amp_means + amp_sems) * 1.1;
    line([1 2], [y_max y_max], 'color', 'k')
    text(1.5, y_max * 1.1, get_star(p_amp), 'HorizontalAlignment', 'center', 'FontSize', 7)
    xlim([0.5 2.5])
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

    
    % Latency Bar Plot
    latency_data = {spont_latency, evoked_latency};
    latency_means = cellfun(@mean, latency_data);
    latency_sems = cellfun(@(x) std(x)/sqrt(length(x)), latency_data);
    
    figure('Position', [680,855,176,123]);
    bar(1:2, latency_means, 'FaceColor', 'k')
    hold on
    errorbar(1:2, latency_means, latency_sems, 'k', 'linestyle', 'none', 'linewidth', 1)
    set(gca, 'xtick', 1:2, 'xticklabel', {'Spontaneous', 'Evoked'})
    yticks([3.098, 6.1960, 9.294, 12.3920])
    yticklabels([100, 200, 300, 400])
    ylabel('Latency to peak (ms)')

    box off
    
    % Add significance marker
    y_max = max(latency_means + latency_sems) * 1.1;
    line([1 2], [y_max y_max], 'color', 'k')
    text(1.5, y_max * 1.1, get_star(p_latency), 'HorizontalAlignment', 'center', 'FontSize', 7)
    xlim([0.5 2.5])
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

% Plot spontaneous event rate for each ROI
    figure('Position', [962,778,120,200]);
    hold on;
    boxplot(spont_rate, 'Notch', 'off', 'Symbol', '', 'Widths', 0.3, 'Colors', 'k', 'Whisker', 0);
    boxLines = findobj(gca, 'Tag', 'Box');
    set(boxLines, 'LineWidth', .5, 'Color', 'k');
    medianLine = findobj(gca, 'Tag', 'Median');
    set(medianLine, 'Color', 'k', 'LineWidth', 1.5);
    numPoints = length(spont_rate);
    x_jitter = 0.2 * (rand(numPoints, 1) - 0.5); % Small random jitter around x = 1
    scatter(ones(size(spont_rate)) + x_jitter, spont_rate, 12, 'k', 'filled');
    set(gca, 'XColor', 'none', 'XTick', []);
    box off
    xlim([.6 1.4])
    ylim([0 1.2])
    ylabel('Spontaneous event rate (Hz)')
    set(gca, 'FontSize', 5, 'FontName', 'Helvetica')


% Plot trial-averaged amplitude for each ROI from mouse 2 (conditions 1, 3, 4) -- BOX PLOTS
    max_mse2_sig1 = max(mean_mse2_sig1);
    figure('Position', [962,778,120,200]);
    hold on;
    boxplot(max_mse2_sig1, 'Notch', 'off', 'Symbol', '', 'Widths', 0.3, 'Colors', 'k', 'Whisker', 0);
    boxLines = findobj(gca, 'Tag', 'Box');
    set(boxLines, 'LineWidth', .5, 'Color', 'k');
    medianLine = findobj(gca, 'Tag', 'Median');
    set(medianLine, 'Color', 'k', 'LineWidth', 1.5);
    numPoints = length(max_mse2_sig1);
    x_jitter = 0.2 * (rand(numPoints, 1) - 0.5); % Small random jitter around x = 1
    scatter(ones(size(max_mse2_sig1)) + x_jitter, max_mse2_sig1, 12, [42,95,160]/255, 'filled');
    set(gca, 'XColor', 'none', 'XTick', []);
    box off
    xlim([.6 1.4])
    ylim([0 1])
    ylabel('Amplitude (∆F/F)')
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

    max_mse2_sig3 = max(mean_mse2_sig3);
    figure('Position', [962,778,120,200]);
    hold on;
    boxplot(max_mse2_sig3, 'Notch', 'off', 'Symbol', '', 'Widths', 0.3, 'Colors', 'k', 'Whisker', 0);
    boxLines = findobj(gca, 'Tag', 'Box');
    set(boxLines, 'LineWidth', .5, 'Color', 'k');
    medianLine = findobj(gca, 'Tag', 'Median');
    set(medianLine, 'Color', 'k', 'LineWidth', 1.5);
    numPoints = length(max_mse2_sig3);
    x_jitter = 0.2 * (rand(numPoints, 1) - 0.5); % Small random jitter around x = 1
    scatter(ones(size(max_mse2_sig3)) + x_jitter, max_mse2_sig3, 12, [52,81,211]/255, 'filled');
    set(gca, 'XColor', 'none', 'XTick', []);
    box off
    xlim([.6 1.4])
    ylim([0 1])
    ylabel('Amplitude (∆F/F)')
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

    max_mse2_sig4 = max(mean_mse2_sig4);
    figure('Position', [962,778,120,200]);
    hold on;
    boxplot(max_mse2_sig4, 'Notch', 'off', 'Symbol', '', 'Widths', 0.3, 'Colors', 'k', 'Whisker', 0);
    boxLines = findobj(gca, 'Tag', 'Box');
    set(boxLines, 'LineWidth', .5, 'Color', 'k');
    medianLine = findobj(gca, 'Tag', 'Median');
    set(medianLine, 'Color', 'k', 'LineWidth', 1.5);
    numPoints = length(max_mse2_sig4);
    x_jitter = 0.2 * (rand(numPoints, 1) - 0.5); % Small random jitter around x = 1
    scatter(ones(size(max_mse2_sig4)) + x_jitter, max_mse2_sig4, 12, [121,156,238]/255, 'filled');
    set(gca, 'XColor', 'none', 'XTick', []);
    box off
    xlim([.6 1.4])
    ylim([0 1])
    ylabel('Amplitude (∆F/F)')
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

% Plot trial-averaged amplitude for each ROI from mouse 2 -- BAR PLOT
    data = [max_mse2_sig1', max_mse2_sig3', max_mse2_sig2', max_mse2_sig4'];
    max_means = mean(data)
    max_sem = std(data) ./ sqrt(size(data, 1)) % SEM = std / sqrt(n)
        colors = [42, 95, 160; 
              52, 81, 211; 
              179, 78, 157;
              121, 156, 238] / 255;
    figure('Position', [1085,776,248,201]);
    hold on;
    num_groups = length(max_means);
    bar_handles = gobjects(1, num_groups);
    for i = 1:num_groups
        bar_handles(i) = bar(i, max_means(i), 'FaceColor', colors(i, :), 'EdgeColor', 'none'); 
    end
    x_positions = 1:num_groups; % X positions of bars
    errorbar(x_positions, max_means, max_sem, 'k', 'linestyle', 'none', 'linewidth', 0.5);
    ylabel('Amplitude (ΔF/F)');
    xticks([]);
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica');
    legend({'3x15', '2x20', '1x50' '(3x15)*2'}, 'Box', 'off', 'Location', 'northwest')
    hold off;

% Plot trial-averaged AUC for each ROI from mouse 2 -- BAR PLOT
    auc_mse2_sig1 = NaN(size(mean_mse2_sig1, 2), 1);
    for i = 1:size(mean_mse2_sig1, 2)
        temp = mean_mse2_sig1(:, i);
        temp = trapz(temp(auc_max_win(1):auc_max_win(2)));
        auc_mse2_sig1(i) = temp;
    end
    auc_mse2_sig2 = NaN(size(mean_mse2_sig2, 2), 1);
    for i = 1:size(mean_mse2_sig2, 2)
        temp = mean_mse2_sig2(:, i);
        temp = trapz(temp(auc_max_win(1):auc_max_win(2)));
        auc_mse2_sig2(i) = temp;
    end
    auc_mse2_sig3 = NaN(size(mean_mse2_sig3, 2), 1);
    for i = 1:size(mean_mse2_sig3, 2)
        temp = mean_mse2_sig3(:, i);
        temp = trapz(temp(auc_max_win(1):auc_max_win(2)));
        auc_mse2_sig3(i) = temp;
    end
    auc_mse2_sig4 = NaN(size(mean_mse2_sig3, 2), 1);
    for i = 1:size(mean_mse2_sig4, 2)
        temp = mean_mse2_sig4(:, i);
        temp = trapz(temp(auc_max_win(1):auc_max_win(2)));
        auc_mse2_sig4(i) = temp;
    end
    data = [auc_mse2_sig1, auc_mse2_sig3, auc_mse2_sig2, auc_mse2_sig4];
    auc_means = mean(data)
    auc_sem = std(data) ./ sqrt(size(data, 1)) % SEM = std / sqrt(n)
    colors = [42, 95, 160; 
              52, 81, 211; 
              179, 78, 157;
              121, 156, 238] / 255;
    figure('Position', [1085,776,248,201]);
    hold on;
    num_groups = length(auc_means);
    bar_handles = gobjects(1, num_groups);
    for i = 1:num_groups
        bar_handles(i) = bar(i, auc_means(i), 'FaceColor', colors(i, :), 'EdgeColor', 'none'); 
    end
    x_positions = 1:num_groups;
    errorbar(x_positions, auc_means, auc_sem, 'k', 'linestyle', 'none', 'linewidth', 0.5);
    ylabel('AUC (ΔFt/F)');
    xticks([]);
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica');
    legend({'3x15', '2x20', '1x50' '(3x15)*2'}, 'Box', 'off', 'Location', 'northwest')
    hold off;
end

function stars = get_star(p)
    if p < 0.001
        stars = '***';
    elseif p < 0.01
        stars = '**';
    elseif p < 0.05
        stars = '*';
    else
        stars = 'n.s.';
    end
end