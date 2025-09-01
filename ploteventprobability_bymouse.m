function ploteventprobability_bymouse(m1_cond1, m1_cond2, m2_cond1, m2_cond2, neuron_colors, plotlines)

% Get event probability (n responses/ntrials) for each neuron
m1_cond1 = getproportion(m1_cond1);
m1_cond2 = getproportion(m1_cond2);
m2_cond1 = getproportion(m2_cond1);
m2_cond2 = getproportion(m2_cond2);

% Reformat data
% Column 1 is condition 1 and column 2 is condition 2
m1_PV = reformatdata(m1_cond1, m1_cond2, 1);
m1_PN = reformatdata(m1_cond1, m1_cond2, 2);
m1_VIP = reformatdata(m1_cond1, m1_cond2, 3);
m1_UC = reformatdata(m1_cond1, m1_cond2, 4);
m1_SST = reformatdata(m1_cond1, m1_cond2, 5);

m2_PV = reformatdata(m2_cond1, m2_cond2, 1);
m2_PN = reformatdata(m2_cond1, m2_cond2, 2);
m2_VIP = reformatdata(m2_cond1, m2_cond2, 3);
m2_UC = reformatdata(m2_cond1, m2_cond2, 4);
m2_SST = reformatdata(m2_cond1, m2_cond2, 5);

PNs{1} = m1_PN;
PNs{2} = m2_PN;
UCs{1} = m1_UC;
UCs{2} = m2_UC;
VIPs{1} = m1_VIP;
VIPs{2} = m2_VIP;
PVs{1} = m1_PV;
PVs{2} = m2_PV;
SSTs{1} = m1_SST;
SSTs{2} = m2_SST;

% RUN STATS (1 group, 2 conditions)
condition_names = {'cond1', 'cond2'};
group_names = {'m1', 'm2'};
p_m1_PV = runpairedstats(m1_PV);
p_m1_PN = runpairedstats(m1_PN);
p_m1_VIP = runpairedstats(m1_VIP);
p_m1_UC = runpairedstats(m1_UC);
p_m1_SST = runpairedstats(m1_SST);

p_m2_PV = runpairedstats(m2_PV);
p_m2_PN = runpairedstats(m2_PN);
p_m2_VIP = runpairedstats(m2_VIP);
p_m2_UC = runpairedstats(m2_UC);
p_m2_SST = runpairedstats(m2_SST);

% Create boxplots for mouse 1
figure('Position', [100 100 1500 500]);
title('Group 1 (Cond 1 vs Cond 2; each mouse)')
subplot(1, 5, 1)
daboxplot(m1_PN,'xtlabels', condition_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{2}, 'linkline', 1);
ylim([0 1])
if p_m1_PN < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end

subplot(1, 5, 2)
daboxplot(m1_UC,'xtlabels', condition_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{4}, 'linkline', 1);
ylim([0 1])
if p_m1_UC < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end

subplot(1, 5, 3)
daboxplot(m1_VIP,'xtlabels', condition_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{3}, 'linkline', 1);
ylim([0 1])
if p_m1_VIP < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end

subplot(1, 5, 4)
daboxplot(m1_SST,'xtlabels', condition_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{5}, 'linkline', 1);
ylim([0 1])
if p_m1_SST < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end

subplot(1, 5, 5)
daboxplot(m1_PV,'xtlabels', condition_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{1}, 'linkline', 1);
if p_m1_PV < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end


% Create boxplots for mouse 2
figure('Position', [100 100 1500 500]);
title('Group 2 (Cond 1 vs Cond 2; each mouse)')
subplot(1, 5, 1)
daboxplot(m2_PN,'xtlabels', condition_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{2}, 'linkline', 1);
ylim([0 1])
if p_m2_PN < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end

subplot(1, 5, 2)
daboxplot(m2_UC,'xtlabels', condition_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{4}, 'linkline', 1);
ylim([0 1])
if p_m2_UC < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end

subplot(1, 5, 3)
daboxplot(m2_VIP,'xtlabels', condition_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{3}, 'linkline', 1);
ylim([0 1])
if p_m2_VIP < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end

subplot(1, 5, 4)
daboxplot(m2_SST,'xtlabels', condition_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{5}, 'linkline', 1);
ylim([0 1])
if p_m2_SST < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end

subplot(1, 5, 5)
daboxplot(m2_PV,'xtlabels', condition_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{1}, 'linkline', 1);
ylim([0 1])
if p_m2_PV < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end

% RUN STATS (2 groups, each condition)
[p_PN_c1, p_PN_c2] = rununpairedstats(m1_PN, m2_PN);
fprintf('Group 1 vs Group 2 Cond 1 (PN) %.4f\n', p_PN_c1);
fprintf('Group 1 vs Group 2 Cond 2 (PN) %.4f\n', p_PN_c2);
[p_UC_c1, p_UC_c2] = rununpairedstats(m1_UC, m2_UC);
fprintf('Group 1 vs Group 2 Cond 1 (UC) %.4f\n', p_UC_c1);
fprintf('Group 1 vs Group 2 Cond 2 (UC) %.4f\n', p_UC_c2);
[p_VIP_c1, p_VIP_c2] = rununpairedstats(m1_VIP, m2_VIP);
fprintf('Group 1 vs Group 2 Cond 1 (VIP) %.4f\n', p_VIP_c1);
fprintf('Group 1 vs Group 2 Cond 2 (VIP) %.4f\n', p_VIP_c2);
[p_PV_c1, p_PV_c2] = rununpairedstats(m1_PV, m2_PV);
fprintf('Group 1 vs Group 2 Cond 1 (PV) %.4f\n', p_PV_c1);
fprintf('Group 1 vs Group 2 Cond 2 (PV) %.4f\n', p_PV_c2);
[p_SST_c1, p_SST_c2] = rununpairedstats(m1_SST, m2_SST);
fprintf('Group 1 vs Group 2 Cond 1 (SST) %.4f\n', p_SST_c1);
fprintf('Group 1 vs Group 2 Cond 2 (SST) %.4f\n', p_SST_c2);

figure('Position', [100 100 1500 500]);
subplot(1, 5, 1)
daboxplot(PNs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',0,'outliers',1,'outsymbol','r*','scatter',2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{2}]);
ylabel('Performance'); 
set(gca,'FontSize',12)

subplot(1, 5, 2)
daboxplot(UCs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',0,'outliers',1,'outsymbol','r*','scatter',2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{4}]);
ylabel('Performance'); 
set(gca,'FontSize',12)

subplot(1, 5, 3)
daboxplot(VIPs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',0,'outliers',1,'outsymbol','r*','scatter',2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{3}]);
ylabel('Performance'); 
set(gca,'FontSize',12)

subplot(1, 5, 4)
daboxplot(PVs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',0,'outliers',1,'outsymbol','r*','scatter',2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{1}]);
ylabel('Performance'); 
set(gca,'FontSize',12)

subplot(1, 5, 5)
daboxplot(SSTs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',0,'outliers',1,'outsymbol','r*','scatter',2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{5}]);
ylabel('Performance'); 
set(gca,'FontSize',12)



end

function [p1, p2] = rununpairedstats(data1, data2)
    % skip if sample vector has less than 4 observations
    x = sum(~isnan(data1(:, 1)));
    y = sum(~isnan(data2(:, 1)));
    if x >= 4 && y >=4
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
        p1 = NaN; p2 = NaN;
    end

end

function p = runpairedstats(data)
    % skip if sample vector has less than 4 observations
    x = sum(~isnan(data(:, 1)));
    if x >= 4
        is_normal_1 = lillietest(data(:, 1)); % 0 = normal, 1 = not normal
        is_normal_2 = lillietest(data(:, 2));
        
        % Display normality test results
        if ~is_normal_1 && ~is_normal_2
            
            % Paired t-test (for normal data)
            [~, p] = ttest(data(:, 1), data(:, 2));
        else
            % Wilcoxon signed-rank test (for non-normal data)
            p = signrank(data(:, 1), data(:, 2));
            
        end

    else
        p = NaN;
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

function output = reformatdata(var1, var2, celltype)
    nMice = size(var1, 1);
    output = NaN(nMice, 2);
        for i = 1:nMice
            temp = var1{i, celltype};
            temp2 = var2{i, celltype};
            if isempty(temp)
                output(i, 1) = NaN;
                output(i, 2) = NaN;
            else
                output(i, 1) = mean(temp);
                output(i, 2) = mean(temp2);
            end
        end
end
