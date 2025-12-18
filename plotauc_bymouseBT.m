function plotauc_bymouseBT(m1_cond1, m1_cond2, neuron_colors, plotlines, evoked_win, condition_names, ylimits, getpersistent, chooseplotstyle)

% Get AUC for each 
m1_cond1 = getauc(m1_cond1, evoked_win);
m1_cond2 = getauc(m1_cond2, evoked_win);

if strcmp(getpersistent, 'persistent')
    [m1_cond1, m1_cond2] = keeppersistent(m1_cond1, m1_cond2);
end

% Get average AUC for each mouse
[m1_cond1] = getavgAUC(m1_cond1);
[m1_cond2] = getavgAUC(m1_cond2);

% Reformat data
% Reformat data
m1_cond1 = reformat1(m1_cond1);
m1_cond2 = reformat1(m1_cond2);

% Column 1 is condition 1 and column 2 is condition 2
m1_PV = reformatdata(m1_cond1, m1_cond2, 1);
m1_PN = reformatdata(m1_cond1, m1_cond2, 2);
m1_VIP = reformatdata(m1_cond1, m1_cond2, 3);
m1_UC = reformatdata(m1_cond1, m1_cond2, 4);
m1_SST = reformatdata(m1_cond1, m1_cond2, 5);

% RUN STATS (1 group, 2 conditions)
p_m1_PV = runstats(m1_PV, chooseplotstyle, 'PV');
p_m1_PN = runstats(m1_PN, chooseplotstyle, 'PN');
p_m1_VIP = runstats(m1_VIP, chooseplotstyle, 'VIP');
p_m1_UC = runstats(m1_UC, chooseplotstyle, 'UC');
p_m1_SST = runstats(m1_SST, chooseplotstyle, 'SST');

if strcmp(chooseplotstyle, 'normalize')
    % Normalize W+CF to W
    m1_PV_Wnorm = m1_PV(:,1) ./ m1_PV(:,1);
    m1_PN_Wnorm = m1_PN(:,1) ./ m1_PN(:,1);
    m1_VIP_Wnorm = m1_VIP(:,1) ./ m1_VIP(:,1);
    m1_UC_Wnorm = m1_UC(:,1) ./ m1_UC(:,1);
    m1_SST_Wnorm = m1_SST(:,1) ./ m1_SST(:,1);
    
    m1_PV_WCFnorm = m1_PV(:,2) ./ m1_PV(:,1);
    m1_PN_WCFnorm = m1_PN(:,2) ./ m1_PN(:,1);
    m1_VIP_WCFnorm = m1_VIP(:,2) ./ m1_VIP(:,1);
    m1_UC_WCFnorm = m1_UC(:,2) ./ m1_UC(:,1);
    m1_SST_WCFnorm = m1_SST(:,2) ./ m1_SST(:,1);
    
    m1_PV(:, 1) = m1_PV_Wnorm; m1_PV(:, 2) = m1_PV_WCFnorm;
    m1_PN(:, 1) = m1_PN_Wnorm; m1_PN(:, 2) = m1_PN_WCFnorm;
    m1_VIP(:, 1) = m1_VIP_Wnorm; m1_VIP(:, 2) = m1_VIP_WCFnorm;
    m1_UC(:, 1) = m1_UC_Wnorm; m1_UC(:, 2) = m1_UC_WCFnorm;
    m1_SST(:, 1) = m1_SST_Wnorm; m1_SST(:, 2) = m1_SST_WCFnorm;
end


% Create boxplots for mouse 1
% X values for pre (1) and post (2)
x = [1, 2];
figure('Position', [246,495,700,170]);
title('Group 1 (Cond 1 vs Cond 2; each neuron)')
subplot(1, 5, 1)
if ~isempty(m1_PN)
    numMice = size(m1_PN, 1);
    means = mean(m1_PN, 1, 'omitnan');
    hold on
    for i = 1:numMice
        plot(x, m1_PN(i,:), '-o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', neuron_colors{2}, 'MarkerFaceColor', [1 1 1]);
    ylim(ylimits)
    xlim([1 2])
    end
    plot(x, means, ':', 'Color', 'cyan', 'LineWidth', 1)
    xticks([1 2])
xticklabels(condition_names);
ylabel('AUC (ΔFt/F)'); % Adjust based on what your data represents
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7)
if p_m1_PN < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 2)
if ~isempty(m1_UC)
    numMice = size(m1_UC, 1);
    means = mean(m1_UC, 1, 'omitnan');
    plot(x, means, ':', 'Color', neuron_colors{4}, 'LineWidth', 1)
    hold on
    for i = 1:numMice
        plot(x, m1_UC(i,:), '-o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', neuron_colors{4}, 'MarkerFaceColor', [1 1 1]);
    end
    xticks([1 2])
xticklabels(condition_names);
ylabel('AUC (ΔFt/F)'); % Adjust based on what your data represents
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7)
if p_m1_UC < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 3)
if ~isempty(m1_VIP)
    numMice = size(m1_VIP, 1);
    means = mean(m1_VIP, 1, 'omitnan');
    plot(x, means, ':', 'Color', neuron_colors{3}, 'LineWidth', 1)
    hold on
    for i = 1:numMice
        plot(x, m1_VIP(i,:), '-o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', neuron_colors{3}, 'MarkerFaceColor', [1 1 1]);
        hold on
    end
    xticks([1 2])
xticklabels(condition_names);
ylabel('AUC (ΔFt/F)'); % Adjust based on what your data represents
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7)
if p_m1_VIP < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 4)
if ~isempty(m1_SST)
    numMice = size(m1_SST, 1);
    means = mean(m1_SST, 1, 'omitnan');
    plot(x, means, ':', 'Color', neuron_colors{5}, 'LineWidth', 1)
    hold on
    for i = 1:numMice
        plot(x, m1_SST(i,:), '-o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', neuron_colors{5}, 'MarkerFaceColor', [1 1 1]);
        hold on
    end
    xticks([1 2])
xticklabels(condition_names);
ylabel('AUC (ΔFt/F)'); % Adjust based on what your data represents
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7)
if p_m1_SST < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 5)
if ~isempty(m1_PV)
    numMice = size(m1_PV, 1);
    means = mean(m1_PV, 1, 'omitnan');
    plot(x, means, ':', 'Color', neuron_colors{1}, 'LineWidth', 1)
    hold on
    for i = 1:numMice
        plot(x, m1_PV(i,:), '-o', 'MarkerSize', 5, 'LineWidth', 1, 'Color', neuron_colors{1}, 'MarkerFaceColor', [1 1 1]);
        hold on
    end
    xticks([1 2])
xticklabels(condition_names);
ylabel('AUC (ΔFt/F)'); % Adjust based on what your data represents
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7)
if p_m1_PV < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20)
end
end


end

function p = runstats(data, mode, cellType)
% data: n x 2 matrix (Pre in col 1, Post in col 2)
% mode: 'paired' for W vs W+CF, 'normalized' for W+CF/W vs 1

    p = NaN; % Default output

    if ~isempty(data) && size(data,2) == 2
        data1 = data(:, 1); 
        data2 = data(:, 2);
        
        valid_idx = ~isnan(data1) & ~isnan(data2);
        data1 = data1(valid_idx);
        data2 = data2(valid_idx);

        if numel(data1) >= 4 && numel(data2) >= 4
            switch lower(mode)
                case 'paired'
                    is_normal_1 = lillietest(data1);
                    is_normal_2 = lillietest(data2);
                    
                    if ~is_normal_1 && ~is_normal_2
                        [~, p] = ttest(data1, data2);
                        testtype = 'paired ttest';
                    else
                        p = signrank(data1, data2);
                        testtype = 'paired signrank';
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
                        fprintf('n Pre: %d, n Post: %d\n', n1, n2);
                        fprintf('Mean Pre: %.4f, Mean Post: %.4f\n', mean_data1, mean_data2);
                        fprintf('SEM Pre: %.4f, SEM Post: %.4f\n', sem_data1, sem_data2);

                case 'normalize'
                    norm_vals1 = (data1 ./ data1);
                    norm_vals = (data2 ./ data1);
                    
                    is_normal = lillietest(norm_vals);
                    
                    if ~is_normal
                        [~, p] = ttest(norm_vals, 1);
                        testtype = 'one-sample t-test';
                    else
                        p = signrank(norm_vals, 1);
                        testtype = 'one-sample signrank';
                    end

                        n1 = sum(~isnan(data1));
                        n2 = sum(~isnan(data2));
                        mean_data1 = mean(norm_vals1, 'omitnan');
                        mean_data2 = mean(norm_vals, 'omitnan');
                        sem_data1 = std(norm_vals1, 'omitnan')./sqrt(n1);
                        sem_data2 = std(norm_vals, 'omitnan')./sqrt(n2);

                        fprintf('Cell Type: %s\n', cellType);
                        fprintf('Test Type: %s\n', testtype);
                        fprintf('p-value: %.4f\n', p);
                        fprintf('n Pre: %d, n Post: %d\n', n1, n2);
                        fprintf('Mean Pre: %.4f, Mean Post: %.4f\n', mean_data1, mean_data2);
                        fprintf('SEM Pre: %.4f, SEM Post: %.4f\n', sem_data1, sem_data2);

                otherwise
                    error('Invalid mode. Use "paired" or "normalized".');
            end
        end
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

function var = getauc(var, evoked_win)
[nMice, ncellType] = size(var);
    for i = 1:nMice
        for j = 1:ncellType
            signal = var{i, j};
            if ~isempty(signal)
                [~, nCells, nTrials] = size(signal);
                signal = signal(evoked_win(1):evoked_win(2), :, :);
                AUC = NaN(nCells, nTrials);
                for k = 1:nCells
                    for t = 1:nTrials
                        temp = signal(:, k, t);
                            %AUC(k, t) = abs(trapz(temp));
                            AUC(k, t) = trapz(temp);
                    end
                end
                var{i, j} = AUC;
            end
        end
    end
end

function var = getavgAUC(var)
    [nMice, ncellType] = size(var);
    for i = 1:nMice
        for j = 1:ncellType
            temp = var{i, j};
            var{i, j} = mean(temp, 'omitnan');
        end
    end

end

function [cond1, cond2] = keeppersistent(cond1, cond2)
    [nMice, ncellType] = size(cond1);

    for i = 1:nMice
        for j = 1:ncellType
            temp_c1 = cond1{i, j};
            temp_c2 = cond2{i, j};

            idx1 = ~isnan(temp_c1);
            idx2 = ~isnan(temp_c2);
            idx = idx1 & idx2;
            cond1{i, j} = temp_c1(idx);
            cond2{i, j} = temp_c2(idx);
        end
    end
end

function reformatvar = reformat1(var)
    [nMice, ncellType] = size(var);
    reformatvar = cell(1, ncellType);
    for j = 1:ncellType
        concatmice = NaN(nMice, 1);
        for i = 1:nMice
            temp = var{i, j};
                concatmice(i) = temp;
        end
        reformatvar{j} = concatmice;
    end

end
