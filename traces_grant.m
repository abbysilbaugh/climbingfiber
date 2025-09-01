function traces_grant(allData, active_PRE_RWS, active_POST_RWS, increase_cells, decrease_cells, norm)

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

    all_post = cat(2, traces_post, traces_onlypost);

    % Calculate mean, std, sem
mean_pre = mean(traces_pre, 2, 'omitnan');
std_pre = std(traces_pre, 0, 2, 'omitnan'); %/ sqrt(size(traces_pre, 2));
sem_pre = std(traces_pre, 0, 2, 'omitnan')/ sqrt(size(traces_pre, 2));

mean_post = mean(traces_post, 2, 'omitnan');
std_post = std(traces_post, 0, 2, 'omitnan');% / sqrt(size(traces_post, 2));
sem_post = std(traces_post, 0, 2, 'omitnan') / sqrt(size(traces_post, 2));

mean_onlypost = mean(traces_onlypost, 2, 'omitnan');
std_onlypost = std(traces_onlypost, 0, 2, 'omitnan');% / sqrt(size(traces_onlypost, 2));
sem_onlypost = std(traces_onlypost, 0, 2, 'omitnan') / sqrt(size(traces_onlypost, 2));

% X values for plotting (adjust as needed)
x = 1:length(mean_pre);

figure;
% Plot for pre rise
subplot(1, 2, 1);
hold on;
plot(mean_pre, 'Color', [71 101 161]/255, 'LineWidth', 2, 'LineStyle', ':');
fill([x fliplr(x)], [mean_pre' + std_pre' fliplr(mean_pre' - std_pre')], [71 101 161]/255, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
ylabel('ΔF/F0')
xlim([303.8 320])
ylim([-0.5 2])
xticks([300.7 303.8 306.9 310 313.1 316.2 319.3])
xticklabels([-300 -200 -100 0 100 200 300])
xlabel('msec')
set(gca, 'FontSize', 15);
legend('PRE', 'FontSize', 15, 'box', 'off', 'Location', 'northwest')

% Plot for post rise
subplot(1, 2, 2);
hold on;
plot(mean_post, 'Color', [71 101 161]/255, 'LineWidth', 2);
plot(mean_onlypost, 'Color', [212,60,0]/255, 'LineWidth', 2);
xticks([linspace(1, 620, 80)])
fill([x fliplr(x)], [mean_post' + std_post' fliplr(mean_post' - std_post')], [71 101 161]/255, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([x fliplr(x)], [mean_onlypost' + std_onlypost' fliplr(mean_onlypost' - std_onlypost')], [212,60,0]/255, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
ylabel('ΔF/F0')
xlim([303.8 320])
ylim([-0.5 2])
xticks([300.7 303.8 306.9 310 313.1 316.2 319.3])
xticklabels([-300 -200 -100 0 100 200 300])
xlabel('msec')
set(gca, 'FontSize', 15);
legend('POST', 'POST', 'FontSize', 15, 'box', 'off', 'Location', 'northwest')

figure;
% Plot for pre rise
subplot(1, 2, 1);
hold on;
plot(traces_pre, 'Color', [71 101 161]/255);
plot(mean_pre, 'Color', [71 101 161]/255, 'LineWidth', 2);
ylabel('ΔF/F0')
xlim([303.8 320])
ylim([-0.5 2])
xticks([300.7 303.8 306.9 310 313.1 316.2 319.3])
xticklabels([-300 -200 -100 0 100 200 300])
xlabel('msec')
set(gca, 'FontSize', 15);

% Plot for post rise
subplot(1, 2, 2);
hold on;
plot(traces_post, 'Color', [71 101 161]/255);
plot(mean_post, 'Color', [71 101 161]/255, 'LineWidth', 2);
plot(traces_onlypost, 'Color', [212,60,0]/255);
plot(mean_onlypost, 'Color', [212,60,0]/255, 'LineWidth', 2);
ylabel('ΔF/F0')
xlim([303.8 320])
ylim([-0.5 2])
xticks([300.7 303.8 306.9 310 313.1 316.2 319.3])
xticklabels([-300 -200 -100 0 100 200 300])
xlabel('msec')
set(gca, 'FontSize', 15);

% Plot pre and post together
figure;
hold on
plot(mean_pre, 'Color', [71 101 161]/255, 'LineWidth', 2, 'LineStyle', ':');
plot(mean_post, 'Color', [71 101 161]/255, 'LineWidth', 2);
plot(mean_onlypost, 'Color', [212,60,0]/255, 'LineWidth', 2);
fill([x fliplr(x)], [mean_post' + sem_post' fliplr(mean_post' - sem_post')], [71 101 161]/255, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([x fliplr(x)], [mean_onlypost' + sem_onlypost' fliplr(mean_onlypost' - sem_onlypost')], [212,60,0]/255, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
ylabel('ΔF/F0')
fill([x fliplr(x)], [mean_pre' + sem_pre' fliplr(mean_pre' - sem_pre')], [71 101 161]/255, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
ylim([-0.25 2.25]);
ylabel('ΔF/F0', 'FontSize', 15)
xticks([0 31 62 93 124 155 186 217 248 279 310 341 372 403 434 465 496 527 558 589 620]);
xticklabels([-10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10])
xlim([300 380])
xlabel('seconds', 'FontSize', 15)
legend('PRE', 'POST', 'POST', 'box', 'off', 'FontSize', 15)
set(gca, 'FontSize', 15);



end