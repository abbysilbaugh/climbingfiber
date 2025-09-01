function plotmax_bymouseBT(m1_cond1, m1_cond2, neuron_colors, plotlines, evoked_win, condition_names, ylimits)

% Get Maximum for each 
m1_cond1 = getmax(m1_cond1, evoked_win);
m1_cond2 = getmax(m1_cond2, evoked_win);

% Reformat data
% Column 1 is condition 1 and column 2 is condition 2
m1_PV = reformatdata(m1_cond1, m1_cond2, 1);
m1_PN = reformatdata(m1_cond1, m1_cond2, 2);
m1_VIP = reformatdata(m1_cond1, m1_cond2, 3);
m1_UC = reformatdata(m1_cond1, m1_cond2, 4);
m1_SST = reformatdata(m1_cond1, m1_cond2, 5);

PNs{1} = m1_PN;
UCs{1} = m1_UC;
VIPs{1} = m1_VIP;
PVs{1} = m1_PV;
SSTs{1} = m1_SST;

% RUN STATS (1 group, 2 conditions)
p_m1_PV = runpairedstats(m1_PV, 'PV');
p_m1_PN = runpairedstats(m1_PN, 'PN');
p_m1_VIP = runpairedstats(m1_VIP, 'VIP');
p_m1_UC = runpairedstats(m1_UC, 'UC');
p_m1_SST = runpairedstats(m1_SST, 'SST');


% Create boxplots for mouse 1
% X values for pre (1) and post (2)
x = [1, 2];
figure('Position', [255,651,770,142]);
title('Group 1 (Cond 1 vs Cond 2; each neuron)')
subplot(1, 5, 1)
if ~isempty(m1_PN)
    numMice = size(m1_PN, 1);
    means = mean(m1_PN, 1);
   % plot(x, means, '-', 'Color', 'b', 'LineWidth', 1)
    hold on
    for i = 1:numMice
        plot(x, m1_PN(i,:), '-o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', neuron_colors{2}, 'MarkerFaceColor', [1 1 1]);
    %ylim(%ylimits)
    xlim([1 2])
    end
    xticks([1 2])
xticklabels(condition_names);
ylabel('Maximum (ΔF/F0)'); % Adjust based on what your data represents
%ylim(%ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7)
if p_m1_PN < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 2)
if ~isempty(m1_UC)
    numMice = size(m1_UC, 1);
    means = mean(m1_UC, 1);
   % plot(x, means, '-', 'Color','b', 'LineWidth', 1)
    hold on
    for i = 1:numMice
        plot(x, m1_UC(i,:), '-o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', neuron_colors{4}, 'MarkerFaceColor', [1 1 1]);
    end
    xticks([1 2])
xticklabels(condition_names);
ylabel('Maximum (ΔF/F0)'); % Adjust based on what your data represents
%ylim(%ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7)
if p_m1_UC < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 3)
if ~isempty(m1_VIP)
    numMice = size(m1_VIP, 1);
    means = mean(m1_VIP, 1);
    plot(x, means, ':', 'Color', neuron_colors{3}, 'LineWidth', 1)
    hold on
    for i = 1:numMice
        plot(x, m1_VIP(i,:), '-o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', neuron_colors{3}, 'MarkerFaceColor', [1 1 1]);
        hold on
    end
    xticks([1 2])
xticklabels(condition_names);
ylabel('Maximum (ΔF/F0)'); % Adjust based on what your data represents
%ylim(%ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7)
if p_m1_VIP < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 4)
if ~isempty(m1_SST)
    numMice = size(m1_SST, 1);
    means = mean(m1_SST, 1);
    plot(x, means, ':', 'Color', neuron_colors{5}, 'LineWidth', 1)
    hold on
    for i = 1:numMice
        plot(x, m1_SST(i,:), '-o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', neuron_colors{5}, 'MarkerFaceColor', [1 1 1]);
        hold on
    end
    xticks([1 2])
xticklabels(condition_names);
ylabel('Maximum (ΔF/F0)'); % Adjust based on what your data represents
%ylim(%ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7)
if p_m1_SST < 0.05
    text(1.5, 0.8, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 5)
if ~isempty(m1_PV)
    numMice = size(m1_PV, 1);
    means = mean(m1_PV, 1);
    plot(x, means, ':', 'Color', neuron_colors{1}, 'LineWidth', 1)
    hold on
    for i = 1:numMice
        plot(x, m1_PV(i,:), '-o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', neuron_colors{1}, 'MarkerFaceColor', [1 1 1]);
        hold on
    end
    xticks([1 2])
xticklabels(condition_names);
ylabel('Maximum (ΔF/F0)'); % Adjust based on what your data represents
%ylim(%ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7)
if p_m1_PV < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20)
end
end

end

function p = runpairedstats(data, cellType)
if ~isempty(data)
    data1 = data(:, 1); data2 = data(:, 2);
    if sum(~isnan(data1)) >=4 && sum(~isnan(data2)) >=4
    is_normal_1 = lillietest(data1); % 0 = normal, 1 = not normal
    is_normal_2 = lillietest(data2);
    
    % Display normality test results
    if ~is_normal_1 && ~is_normal_2
        
        % Paired t-test (for normal data)
        [~, p] = ttest(data1, data2);
        testtype = 'Paired t-test';
    else
        % Wilcoxon signed-rank test (for non-normal data)
        p = signrank(data1, data2);
        testtype = 'Wilcoxon signed-rank test';
        
    end
    else
        p = NaN;
        testtype = NaN;
    end
else
    p = NaN;
    testtype = NaN;
end

n1 = sum(~isnan(data1));
n2 = sum(~isnan(data2));
mean_data1 = mean(data1, 'omitnan');
mean_data2 = mean(data2, 'omitnan');
sem_data1 = std(data1, 'omitnan')./sqrt(n1);
sem_data2 = std(data2, 'omitnan')./sqrt(n2);

% Print results
fprintf('Cell Type: %s\n', cellType);
fprintf('Test Type: %s\n', testtype);
fprintf('p-value: %.4f\n', p);
fprintf('n W: %d, n W+CF: %d\n', n1, n2);
fprintf('Mean W: %.4f, Mean W+CF: %.4f\n', mean_data1, mean_data2);
fprintf('SEM W: %.4f, SEM W+CF: %.4f\n', sem_data1, sem_data2);

end

function [p1, p2] = rununpairedstats(data1, data2)
    if ~isempty(data1) && ~isempty(data2)
        if sum(~isnan(data1(:, 1))) >=4 && sum(~isnan(data1(:, 2))) >=4 && sum(~isnan(data2(:, 1))) >=4 && sum(~isnan(data2(:, 2))) >=4
        % Check normality for each column in data1 and data2
        is_normal_1_data1 = lillietest(data1(:, 1));
        is_normal_2_data1 = lillietest(data1(:, 2));
        is_normal_1_data2 = lillietest(data2(:, 1));
        is_normal_2_data2 = lillietest(data2(:, 2));

        % Display normality test results
        if ~is_normal_1_data1 && ~is_normal_1_data2
            % Unpaired t-test for condition 1
            [~, p1] = ttest2(data1(:, 1), data2(:, 1));
        else
            % Mann-Whitney U test (rank-sum test) for condition 1
            p1 = ranksum(data1(:, 1), data2(:, 1));
        end
    
        if ~is_normal_2_data1 && ~is_normal_2_data2
            % Unpaired t-test for condition 2
            [~, p2] = ttest2(data1(:, 2), data2(:, 2));
        else
            % Mann-Whitney U test (rank-sum test) for condition 2
            p2 = ranksum(data1(:, 2), data2(:, 2));
        end
        else
            p1 = NaN;
            p2 = NaN;
        end

    else
        p1 = NaN;
        p2 = NaN;
    end

end


function output = reformatdata(var1, var2, celltype)
        counter = 1;
        output = [];
        for i = 1:size(var1, 1)
            temp = var1{i, celltype};
            temp2 = var2{i, celltype};

            if isempty(temp)
                output = output;
            else
                % Trial average!
                temp = mean(temp, 2, 'omitnan');
                temp2 = mean(temp2, 2, 'omitnan');
                for j = 1:length(temp)
                output(counter, 1) = temp(j);
                output(counter, 2) = temp2(j);
                counter = counter + 1;
                end
            end
        end
end

function var = getmax(var, evoked_win)
[nMice, ncellType] = size(var);
    for i = 1:nMice
        for j = 1:ncellType
            signal = var{i, j};
            if ~isempty(signal)
                [~, nCells, nTrials] = size(signal);
                signal = signal(evoked_win(1):evoked_win(2), :, :);
                getmaximum = NaN(nCells, nTrials);
                for k = 1:nCells
                    for t = 1:nTrials
                        temp = signal(:, k, t);
                            getmaximum(k, t) = max(temp);
                    end
                end
                var{i, j} = getmaximum;
            end
        end
    end
end
