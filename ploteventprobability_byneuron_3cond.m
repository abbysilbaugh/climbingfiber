function ploteventprobability_byneuron_3cond(m1_cond1, m1_cond2, m1_cond3, m2_cond1, m2_cond2, m2_cond3, neuron_colors, plotlines, neuronType, group_names)

if strcmp(neuronType, 'PV')
    getcell = 1;
elseif strcmp(neuronType, 'PN')
    getcell = 2;
 elseif strcmp(neuronType, 'VIP')
     getcell = 3;
elseif strcmp(neuronType, 'UC')
    getcell = 4;
elseif strcmp(neuronType, 'SST')
    getcell = 5;
end

% Get event probability (n responses/ntrials) for each neuron
m1_cond1 = getproportion(m1_cond1);
m1_cond2 = getproportion(m1_cond2);
m1_cond3 = getproportion(m1_cond3);
m2_cond1 = getproportion(m2_cond1);
m2_cond2 = getproportion(m2_cond2);
m2_cond3 = getproportion(m2_cond3);

% Reformat data
% Column 1 is condition 1, column 2 is condition 2, column 3 is condition 3
m1_CELL = reformatdata(m1_cond1, m1_cond2, m1_cond3, getcell);
m2_CELL = reformatdata(m2_cond1, m2_cond2, m2_cond3, getcell);

CELLs{1} = m1_CELL;
CELLs{2} = m2_CELL;

% RUN STATS (1 group, 3 conditions)
condition_names = {'Pre', 'DCZ', 'Post'};
[p_m1_c1c2, p_m1_c1c3, p_m1_c2c3] = runpairedstats(m1_CELL);
[p_m2_c1c2, p_m2_c1c3, p_m2_c2c3] = runpairedstats(m2_CELL);
fprintf('Group 1, Cond 1 vs Cond 2 %.4f\n', p_m1_c1c2);
fprintf('Group 1, Cond 1 vs Cond 3 %.4f\n', p_m1_c1c3);
fprintf('Group 1, Cond 2 vs Cond 3 %.4f\n', p_m1_c2c3);
fprintf('Group 2, Cond 1 vs Cond 2 %.4f\n', p_m2_c1c2);
fprintf('Group 2, Cond 1 vs Cond 3 %.4f\n', p_m2_c1c3);
fprintf('Group 2, Cond 2 vs Cond 3 %.4f\n', p_m2_c2c3);

% Create boxplots for mouse 1
figure;
daboxplot(m1_CELL,'xtlabels', condition_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{getcell}, 'linkline', 1);

% Create boxplots for mouse 2
figure;
daboxplot(m2_CELL,'xtlabels', condition_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{getcell}, 'linkline', 1);

% RUN STATS (2 groups, each condition)
[p_CELL_c1, p_CELL_c2, p_CELL_c3] = rununpairedstats(m1_CELL, m2_CELL);
fprintf('Group 1 vs Group 2 Cond 1 (PV) %.4f\n', p_CELL_c1);
fprintf('Group 1 vs Group 2 Cond 2 (PV) %.4f\n', p_CELL_c2);
fprintf('Group 1 vs Group 2 Cond 3 (PV) %.4f\n', p_CELL_c3);


figure;
daboxplot(CELLs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',0,'outliers',1,'outsymbol','r*','scatter',2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{getcell}]);
ylabel('Performance'); 
set(gca,'FontSize',12)

end

function [p_c1c2, p_c1c3, p_c2c3] = runpairedstats(data)
    if ~isempty(data)
    is_normal_1 = lillietest(data(:, 1)); % 0 = normal, 1 = not normal
    is_normal_2 = lillietest(data(:, 2));
    is_normal_3 = lillietest(data(:, 2));
    
    % Cond 1 and cond 2
    if ~is_normal_1 && ~is_normal_2
        [~, p_c1c2] = ttest(data(:, 1), data(:, 2));
    else
        % Wilcoxon signed-rank test (for non-normal data)
        p_c1c2 = signrank(data(:, 1), data(:, 2));
    end

    % Cond 1 and cond 3
    if ~is_normal_1 && ~is_normal_3
        [~, p_c1c3] = ttest(data(:, 1), data(:, 3));
    else
        % Wilcoxon signed-rank test (for non-normal data)
        p_c1c3 = signrank(data(:, 1), data(:, 3));
    end

    % Cond 2 and cond 3
    if ~is_normal_2 && ~is_normal_3
        [~, p_c2c3] = ttest(data(:, 2), data(:, 3));
    else
        % Wilcoxon signed-rank test (for non-normal data)
        p_c2c3 = signrank(data(:, 2), data(:, 3));
    end

    else
        p_c1c2 = NaN; p_c1c3 = NaN; p_c2c3 = NaN;
    end

end

function [p1, p2, p3] = rununpairedstats(data1, data2)
    % Check normality for each column in data1 and data2
    is_normal_1_data1 = lillietest(data1(:, 1));
    is_normal_2_data1 = lillietest(data1(:, 2));
    is_normal_3_data1 = lillietest(data1(:, 3));
    is_normal_1_data2 = lillietest(data2(:, 1));
    is_normal_2_data2 = lillietest(data2(:, 2));
    is_normal_3_data2 = lillietest(data2(:, 3));

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

    if ~is_normal_3_data1 && ~is_normal_3_data2
        % Unpaired t-test for condition 3
        [~, p3] = ttest2(data1(:, 3), data2(:, 3));
    else
        % Mann-Whitney U test (rank-sum test) for condition 2
        p3 = ranksum(data1(:, 3), data2(:, 3));
    end

end



function var = getproportion(var)
    for j = 1:size(var, 2)
        for i = 1:size(var, 1)
            temp = var{i, j};
            if ~isempty(temp)
                [~, nCells, nTrials] = size(temp);
                prop = NaN(nCells, 1);
                for k = 1:nCells
                    temp2 = squeeze(temp(1, k, :));
                    temp2 = sum(~isnan(temp2));
                    prop(k) = temp2/nTrials;
                end
                var{i, j} = prop;
            end
        end
    end
end

function output = reformatdata(var1, var2, var3, celltype)
        counter = 1;
        output = [];
        for i = 1:size(var1, 1)
            temp = var1{i, celltype};
            temp2 = var2{i, celltype};
            temp3 = var3{i, celltype};
            if isempty(temp) | isempty(temp2) | isempty(temp3)
                output = output;
            else
                for j = 1:length(temp)
                output(counter, 1) = temp(j);
                output(counter, 2) = temp2(j);
                output(counter, 3) = temp3(j);
                counter = counter + 1;
                end
            end
        end
end
