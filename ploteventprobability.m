function ploteventprobability(m1_cond1, m1_cond2, m2_cond1, m2_cond2, neuron_colors, plotlines)

% Get n responses/ntrials for each cell
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

% Run stats (1 group, 2 conditions)
condition_names = {'cond1', 'cond2'};
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
title('Group 1 (Cond 1 vs Cond 2; each neuron)')
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
title('Group 2 (Cond 1 vs Cond 2; each neuron)')
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





end

function p = runpairedstats(data)
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

end


function var = getproportion(var)
    for j = 1:size(var, 2)
        for i = 1:size(var, 1)
            temp = var{i, j};
            if ~isempty(temp)
                [~, nCells, nTrials] = size(temp);
                prop = zeros(nCells, 1);
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
            if isempty(temp)
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
