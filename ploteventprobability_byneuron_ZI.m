function ploteventprobability_byneuron_ZI(m1_cond1, m1_cond2, m2_cond1, m2_cond2, neuron_colors, plotlines)
% Enter as w_pre, w_dcz, wo_pre, wo_dcz
% m1 is whisker, m2 is whiskerOpto
% cond1 is pre, cond2 is after dcz administration

% Get event probability (n responses/ntrials) for each neuron
m1_cond1 = getproportion(m1_cond1);
m1_cond2 = getproportion(m1_cond2);
m2_cond1 = getproportion(m2_cond1);
m2_cond2 = getproportion(m2_cond2);

% Reformat data
% Whisker stimulus; column 1 is cond1 (pre) and column 2 is cond2 (dcz)
w_PV = reformatdata(m1_cond1, m1_cond2, 1);
w_PN = reformatdata(m1_cond1, m1_cond2, 2);
w_VIP = reformatdata(m1_cond1, m1_cond2, 3);
w_UC = reformatdata(m1_cond1, m1_cond2, 4);
w_SST = reformatdata(m1_cond1, m1_cond2, 5);

% whiskerOpto stimulus; column 1 is cond1 and column 2 is cond2 (dcz)
wo_PV = reformatdata(m2_cond1, m2_cond2, 1);
wo_PN = reformatdata(m2_cond1, m2_cond2, 2);
wo_VIP = reformatdata(m2_cond1, m2_cond2, 3);
wo_UC = reformatdata(m2_cond1, m2_cond2, 4);
wo_SST = reformatdata(m2_cond1, m2_cond2, 5);

% pre; column 1 is whisker and column 2 is whiskerOpto
pre_PV = reformatdata(m1_cond1, m2_cond1, 1);
pre_PN = reformatdata(m1_cond1, m2_cond1, 2);
pre_VIP = reformatdata(m1_cond1, m2_cond1, 3);
pre_UC = reformatdata(m1_cond1, m2_cond1, 4);
pre_SST = reformatdata(m1_cond1, m2_cond1, 5);

% dcz; column 1 is whisker and column 2 is whiskerOpto
dcz_PV = reformatdata(m1_cond2, m2_cond2, 1);
dcz_PN = reformatdata(m1_cond2, m2_cond2, 2);
dcz_VIP = reformatdata(m1_cond2, m2_cond2, 3);
dcz_UC = reformatdata(m1_cond2, m2_cond2, 4);
dcz_SST = reformatdata(m1_cond2, m2_cond2, 5);

% PNs
PNs{1} = w_PN;
PNs{2} = wo_PN;
UCs{1} = w_UC;
UCs{2} = wo_UC;
VIPs{1} = w_VIP;
VIPs{2} = wo_VIP;
PVs{1} = w_PV;
PVs{2} = wo_PV;
SSTs{1} = w_SST;
SSTs{2} = wo_SST;

% RUN STATS (whisker pre vs whisker dcz)
condition_names = {'Pre', 'DCZ'};
group_names = {'W', 'W + CF'};
p_w_PV = runpairedstats(w_PV);
p_w_PN = runpairedstats(w_PN);
p_w_VIP = runpairedstats(w_VIP);
p_w_UC = runpairedstats(w_UC);
p_w_SST = runpairedstats(w_SST);

% RUN STATS (whiskerOpto pre vs whiskerOpto dcz)
p_wo_PV = runpairedstats(wo_PV);
p_wo_PN = runpairedstats(wo_PN);
p_wo_VIP = runpairedstats(wo_VIP);
p_wo_UC = runpairedstats(wo_UC);
p_wo_SST = runpairedstats(wo_SST);

% RUN STATS (whisker pre vs whiskerOpto pre)
p_pre_PV = runpairedstats(pre_PV);
p_pre_PN = runpairedstats(pre_PN);
p_pre_VIP = runpairedstats(pre_VIP);
p_pre_UC = runpairedstats(pre_UC);
p_pre_SST = runpairedstats(pre_SST);

% RUN STATS (whisker dcz vs whiskerOpto dcz)
p_dcz_PV = runpairedstats(dcz_PV);
p_dcz_PN = runpairedstats(dcz_PN);
p_dcz_VIP = runpairedstats(dcz_VIP);
p_dcz_UC = runpairedstats(dcz_UC);
p_dcz_SST = runpairedstats(dcz_SST);

% Create boxplots for pre
figure('Position', [100 100 1500 500]);
subplot(1, 5, 1)
if ~isempty(pre_PN)
daboxplot(pre_PN,'xtlabels', group_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{2}, 'linkline', 1);
ylim([0 1]); ylabel('Evoked Event Probability')
if p_pre_PN < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end
title('Pre')
end

subplot(1, 5, 2)
if ~isempty(pre_UC)
daboxplot(pre_UC,'xtlabels', group_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{4}, 'linkline', 1);
ylim([0 1]); ylabel('Evoked Event Probability')
if p_pre_UC < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end
end

subplot(1, 5, 3)
if ~isempty(pre_VIP)
daboxplot(pre_VIP,'xtlabels', group_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{3}, 'linkline', 1);
ylim([0 1]); ylabel('Evoked Event Probability')
if p_pre_VIP < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end
end

subplot(1, 5, 4)
if ~isempty(pre_SST)
daboxplot(pre_SST,'xtlabels', group_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{5}, 'linkline', 1);
ylim([0 1]); ylabel('Evoked Event Probability')
if p_pre_SST < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end
end

subplot(1, 5, 5)
if ~isempty(pre_PV)
daboxplot(pre_PV,'xtlabels', group_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{1}, 'linkline', 1);
if p_pre_PV < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end
end


% Create boxplots for dcz
figure('Position', [100 100 1500 500]);
subplot(1, 5, 1)
if ~isempty(dcz_PN)
daboxplot(dcz_PN,'xtlabels', group_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{2}, 'linkline', 1);
ylim([0 1]); ylabel('Evoked Event Probability')
if p_dcz_PN < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end
title('DCZ')
end

subplot(1, 5, 2)
if ~isempty(dcz_UC)
daboxplot(dcz_UC,'xtlabels', group_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{4}, 'linkline', 1);
ylim([0 1]); ylabel('Evoked Event Probability')
if p_dcz_UC < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end
end

subplot(1, 5, 3)
if ~isempty(dcz_VIP)
daboxplot(dcz_VIP,'xtlabels', group_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{3}, 'linkline', 1);
ylim([0 1]); ylabel('Evoked Event Probability')
if p_dcz_VIP < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end
end

subplot(1, 5, 4)
if ~isempty(dcz_SST)
daboxplot(dcz_SST,'xtlabels', group_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{5}, 'linkline', 1);
ylim([0 1]); ylabel('Evoked Event Probability')
if p_dcz_SST < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end
end

subplot(1, 5, 5)
if ~isempty(dcz_PV)
daboxplot(dcz_PV,'xtlabels', group_names,'whiskers',0,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'withinlines',plotlines,'outliers',0, 'color', neuron_colors{1}, 'linkline', 1);
if p_dcz_PV < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 50);
end
end


figure('Position', [100 100 1500 500]);
subplot(1, 5, 1)
if ~isempty(PNs{1})
daboxplot(PNs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',0,'outliers',1,'outsymbol','r*','scatter',2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{2}]);
ylabel('Evoked Event Probability'); 
set(gca,'FontSize',12)
end

subplot(1, 5, 2)
if ~isempty(UCs{1})
daboxplot(UCs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',0,'outliers',1,'outsymbol','r*','scatter',2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{4}]);
ylabel('Evoked Event Probability'); 
set(gca,'FontSize',12)
end

subplot(1, 5, 3)
if ~isempty(VIPs{1})
daboxplot(VIPs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',0,'outliers',1,'outsymbol','r*','scatter',2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{3}]);
ylabel('Evoked Event Probability'); 
set(gca,'FontSize',12)
end

subplot(1, 5, 4)
if ~isempty(PVs{1})
daboxplot(PVs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',0,'outliers',1,'outsymbol','r*','scatter',2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{1}]);
ylabel('Evoked Event Probability'); 
set(gca,'FontSize',12)
end

subplot(1, 5, 5)
if ~isempty(SSTs{1})
daboxplot(SSTs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',0,'outliers',1,'outsymbol','r*','scatter',2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{5}]);
ylabel('Evoked Event Probability'); 
set(gca,'FontSize',12)
end

% Plot scatter plots
figure('Position', [100 100 1500 500]);
% Define cell types and data
cell_types = {'PV', 'PN', 'VIP', 'UC', 'SST'};
m1_data = {w_PV, w_PN, w_VIP, w_UC, w_SST};
m2_data = {wo_PV, wo_PN, wo_VIP, wo_UC, wo_SST};

for i = 1:5
    % Extract data for the current cell type
    m1 = m1_data{i};
    m2 = m2_data{i};

    if ~isempty(m1)
    
    % Residuals for the null hypothesis line (y=x)
    residuals_m1 = m1(:, 2) - m1(:, 1);
    residuals_m2 = m2(:, 2) - m2(:, 1);
    
    % Perform normality test for residuals
    is_normal_m1 = lillietest(residuals_m1); % 0 = normal, 1 = not normal
    is_normal_m2 = lillietest(residuals_m2);
    
    % Statistical test for residuals (against the null hypothesis of 0 mean)
    if ~is_normal_m1
        % Paired t-test for mouse 1
        [~, p_m1] = ttest(residuals_m1);
    else
        % Wilcoxon signed-rank test for mouse 1
        p_m1 = signrank(residuals_m1);
    end
    
    if ~is_normal_m2
        % Paired t-test for mouse 2
        [~, p_m2] = ttest(residuals_m2);
    else
        % Wilcoxon signed-rank test for mouse 2
        p_m2 = signrank(residuals_m2);
    end
    
    % Plot data
    subplot(1, 5, i);
    scatter(m1(:, 1), m1(:, 2), 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerFaceAlpha', 0.5);
    hold on;
    scatter(m2(:, 1), m2(:, 2), 'MarkerEdgeColor', 'none', 'MarkerFaceColor', neuron_colors{i}, 'MarkerFaceAlpha', 0.5);
    % Plot the line y=x
    plot([min([m1(:, 1); m2(:, 1)]) max([m1(:, 1); m2(:, 1)])], ...
         [min([m1(:, 1); m2(:, 1)]) max([m1(:, 1); m2(:, 1)])], ...
         'k--', 'LineWidth', 1);
    % Add fit line
    fit_m1 = polyfit(m1(:, 1), m1(:, 2), 1);
    fit_line_x_m1 = linspace(min(m1(:, 1)), max(m1(:, 1)), 100);
    fit_line_y_m1 = polyval(fit_m1, fit_line_x_m1);
    plot(fit_line_x_m1, fit_line_y_m1, 'Color', 'k', 'LineWidth', 1.5);
    
    fit_m2 = polyfit(m2(:, 1), m2(:, 2), 1);
    fit_line_x_m2 = linspace(min(m2(:, 1)), max(m2(:, 1)), 100);
    fit_line_y_m2 = polyval(fit_m2, fit_line_x_m2);
    plot(fit_line_x_m2, fit_line_y_m2, 'Color', neuron_colors{i}, 'LineWidth', 1.5);
    
    % Add title with p-values
    title(sprintf('%s\np(W)=%.3g, p(W + CF)=%.3g', cell_types{i}, p_m1, p_m2));
    xlabel('Pre');
    ylabel('DCZ');
    axis equal;
    xlim([0 1])
    ylim([0 1])
    hold off;
    end
end




end

function p = runpairedstats(data)
    if ~isempty(data)
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

function [p1, p2] = rununpairedstats(data1, data2)
if ~isempty(data1) && ~isempty(data2)
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

    p1  = NaN;
    p2 = NaN;
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
        counter = 1;
        output = [];
        for i = 1:size(var1, 1)
            temp = var1{i, celltype};
            temp2 = var2{i, celltype};
            if isempty(temp) || isempty(temp2)
                output = output;
            else
                for j = 1:length(temp)
                output(counter, 1) = temp(j);
                output(counter, 2) = temp2(j);
                counter = counter + 1;
                end
            end
        end
end
