function plotauc_bymouseV2_combineSST_PV(m1_cond1, m1_cond2, m2_cond1, m2_cond2, neuron_colors, plotlines, evoked_win, group_names, condition_names, ylimits, getpersistent, chooseplotstyle)

PV_SST_color = (neuron_colors{1} + neuron_colors{2})/2;

% Get AUC for each 
m1_cond1 = getauc(m1_cond1, evoked_win);
m1_cond2 = getauc(m1_cond2, evoked_win);
m2_cond1 = getauc(m2_cond1, evoked_win);
m2_cond2 = getauc(m2_cond2, evoked_win);

if strcmp(getpersistent, 'persistent')
    [m1_cond1, m1_cond2] = keeppersistent(m1_cond1, m1_cond2);
    [m2_cond1, m2_cond2] = keeppersistent(m2_cond1, m2_cond2);
end

% Get average AUC for each mouse
[m1_cond1] = getavgAUC(m1_cond1);
[m1_cond2] = getavgAUC(m1_cond2);
[m2_cond1] = getavgAUC(m2_cond1);
[m2_cond2] = getavgAUC(m2_cond2);

% Reformat data
m1_cond1 = reformat1(m1_cond1);
m1_cond2 = reformat1(m1_cond2);
m2_cond1 = reformat1(m2_cond1);
m2_cond2 = reformat1(m2_cond2);

% Column 1 is condition 1 and column 2 is condition 2
m1_PV_temp = reformatdata(m1_cond1, m1_cond2, 1);
m1_SST_temp = reformatdata(m1_cond1, m1_cond2, 5);

m1_SST_PV = cat(1, m1_PV_temp, m1_SST_temp);

m2_PV_temp = reformatdata(m2_cond1, m2_cond2, 1);
m2_SST_temp = reformatdata(m2_cond1, m2_cond2, 5);

m2_SST_PV = cat(1, m2_PV_temp, m2_SST_temp);

% RUN STATS (1 group, 2 conditions)
p_m1_SST_PV = runstats(m1_SST_PV, chooseplotstyle, 'SST/PV; RWS');

p_m2_SST_PV = runstats(m2_SST_PV, chooseplotstyle, 'SST/PV; RWS+CF');

if strcmp(chooseplotstyle, 'normalize')
     % Normalize Post to Pre
    m1_SST_PV_Wnorm = m1_SST_PV(:,1) ./ m1_SST_PV(:,1);
    m1_SST_PV_WCFnorm = m1_SST_PV(:,2) ./ m1_SST_PV(:,1);
    
    m1_SST_PV(:, 1) = m1_SST_PV_Wnorm; m1_SST_PV(:, 2) = m1_SST_PV_WCFnorm;

    m2_SST_PV_Wnorm = m2_SST_PV(:,1) ./ m2_SST_PV(:,1);
    
    m2_SST_PV_WCFnorm = m2_SST_PV(:,2) ./ m2_SST_PV(:,1);
    
    m2_SST_PV(:, 1) = m2_SST_PV_Wnorm; m2_SST_PV(:, 2) = m2_SST_PV_WCFnorm;

end

% Create boxplots for mouse 1
% X values for pre (1) and post (2)
x = [1, 2];
figure('Position', [592,199,566,143]);
title('Group 1 (Cond 1 vs Cond 2; each neuron)')
subplot(1, 5, 1)
if ~isempty(m1_SST_PV)
    numMice = size(m1_SST_PV, 1);
    for i = 1:numMice
        plot(x, m1_SST_PV(i,:), '-o', 'MarkerSize', 3, 'LineWidth', 0.5, 'Color', PV_SST_color, 'MarkerFaceColor', [1 1 1]);
        hold on
    end
        means = mean(m1_SST_PV, 1);
    plot(x, means, ':', 'Color', PV_SST_color, 'LineWidth', 0.5)
    xticks([1 2])
xticklabels({'Pre', 'Post'});
if strcmp(chooseplotstyle, 'normalize')
    ylabel('Normalized AUC (ΔFt/F)');
else
    ylabel('AUC (ΔFt/F)');
end
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
if p_m1_SST_PV < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end


% Create boxplots for mouse 2
figure('Position', [592,199,566,143]);
title('Group 1 (Cond 1 vs Cond 2; each neuron)')
subplot(1, 5, 1)
subplot(1, 5, 1)
if ~isempty(m2_SST_PV)
    numMice = size(m2_SST_PV, 1);
    for i = 1:numMice
        plot(x, m2_SST_PV(i,:), '-o', 'MarkerSize', 3, 'LineWidth', 0.5, 'Color', PV_SST_color, 'MarkerFaceColor', neuron_colors{5});
        hold on
    end
        means = mean(m2_SST_PV, 1);
    plot(x, means, ':', 'Color', PV_SST_color, 'LineWidth', 0.5)
    xticks([1 2])
xticklabels({'Pre', 'Post'});
if strcmp(chooseplotstyle, 'normalize')
    ylabel('Normalized AUC (ΔFt/F)');
else
    ylabel('AUC (ΔFt/F)');
end
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
if p_m2_SST_PV < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

end

function p = runstats(data, mode, cellType)
% data: n x 2 matrix (Pre in col 1, Post in col 2)
% mode: 'paired' for Pre vs Post, 'normalized' for Post/Pre vs 1

    p = NaN; % Default output
    testtype = NaN;

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
                        testtype = 'paired t-test';
                        [~, p] = ttest(data1, data2);
                    else
                        testtype = 'signrank';
                        p = signrank(data1, data2);
                    end

                case 'normalize'
                    norm_vals = (data2 ./ data1);
                    
                    is_normal = lillietest(norm_vals);
                    
                    if ~is_normal
                        testtype = 'one-sample t-test';
                        [~, p] = ttest(norm_vals, 1);
                    else
                        testtype = 'one-sample signrank';
                        p = signrank(norm_vals, 1);
                    end

                otherwise
                    error('Invalid mode. Use "paired" or "normalized".');
            end
        end
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
            warning('unpaired t-test')
        else
            % Mann-Whitney U test (rank-sum test) for condition 1
            p1 = ranksum(data1(:, 1), data2(:, 1));
            warning('Mann-Whitney U test')
        end
    
        if ~is_normal_2_data1 && ~is_normal_2_data2
            % Unpaired t-test for condition 2
            [~, p2] = ttest2(data1(:, 2), data2(:, 2));
            warning('unpaired t-test')
        else
            % Mann-Whitney U test (rank-sum test) for condition 2
            p2 = ranksum(data1(:, 2), data2(:, 2));
            warning('Mann-Whitney U test')
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

function var = getavgAUC(var)
    [nMice, ncellType] = size(var);
    for i = 1:nMice
        for j = 1:ncellType
            temp = var{i, j};
            var{i, j} = mean(temp, 'omitnan');
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
