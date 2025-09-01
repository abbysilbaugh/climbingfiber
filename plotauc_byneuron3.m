function plotauc_byneuron3(m1_cond1, m1_cond2, m1_cond3, m2_cond1, m2_cond2, m2_cond3, neuron_colors, plotlines, evoked_win, group_names, condition_names, ylimits)

% Get AUC for each neuron
m1_cond1 = getauc(m1_cond1, evoked_win);
m1_cond2 = getauc(m1_cond2, evoked_win);
m1_cond3 = getauc(m1_cond3, evoked_win);
m2_cond1 = getauc(m2_cond1, evoked_win);
m2_cond2 = getauc(m2_cond2, evoked_win);
m2_cond3 = getauc(m2_cond3, evoked_win);

% Reformat data
% Column 1 is condition 1, column 2 is condition 2, and column 3 is condition 3
m1_PV = reformatdata(m1_cond1, m1_cond2, m1_cond3, 1);
m1_PN = reformatdata(m1_cond1, m1_cond2, m1_cond3, 2);
m1_VIP = reformatdata(m1_cond1, m1_cond2, m1_cond3, 3);
m1_UC = reformatdata(m1_cond1, m1_cond2, m1_cond3, 4);
m1_SST = reformatdata(m1_cond1, m1_cond2, m1_cond3, 5);

m2_PV = reformatdata(m2_cond1, m2_cond2, m2_cond3, 1);
m2_PN = reformatdata(m2_cond1, m2_cond2, m2_cond3, 2);
m2_VIP = reformatdata(m2_cond1, m2_cond2, m2_cond3, 3);
m2_UC = reformatdata(m2_cond1, m2_cond2, m2_cond3, 4);
m2_SST = reformatdata(m2_cond1, m2_cond2, m2_cond3, 5);

PNs = {m1_PN, m2_PN};
UCs = {m1_UC, m2_UC};
VIPs = {m1_VIP, m2_VIP};
PVs = {m1_PV, m2_PV};
SSTs = {m1_SST, m2_SST};

analyze_and_plot_relative_change(m1_PV, m2_PV, neuron_colors{1}, 'PV')
analyze_and_plot_relative_change(m1_PN, m2_PN, neuron_colors{2}, 'PN')
analyze_and_plot_relative_change(m1_VIP, m2_VIP, neuron_colors{3}, 'VIP')
analyze_and_plot_relative_change(m1_UC, m2_UC, neuron_colors{4}, 'UC')
analyze_and_plot_relative_change(m1_SST, m2_SST, neuron_colors{5}, 'SST')

% Create bar plots for mouse 1
figure('Position', [374,508,693,128]);
title('Group 1 (Cond 1 vs Cond 2 vs Cond 3; each neuron)')
subplot(1, 5, 1)
ylabel('AUC (ΔFt/F)')
if ~isempty(m1_PN)
dabarplot(m1_PN,'xtlabels', condition_names,'fill', 0,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{2}, 'mean', '1');
ylim(ylimits)
title(group_names(1))
ylabel('AUC (ΔFt/F)')
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end

subplot(1, 5, 2)
if ~isempty(m1_UC)
dabarplot(m1_UC,'xtlabels', condition_names,'fill', 0,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{4}, 'mean', '1');
ylim(ylimits)
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end

subplot(1, 5, 3)
if ~isempty(m1_VIP)
dabarplot(m1_VIP,'xtlabels', condition_names,'fill', 0,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{3}, 'mean', '1');
ylim(ylimits)
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end

subplot(1, 5, 4)
if ~isempty(m1_SST)
dabarplot(m1_SST,'xtlabels', condition_names,'fill', 0,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{5}, 'mean', '1');
ylim(ylimits)
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end

subplot(1, 5, 5)
if ~isempty(m1_PV)
dabarplot(m1_PV,'xtlabels', condition_names,'fill', 0,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{1}, 'mean', '1');
ylim(ylimits)
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end


% Create bar plots for mouse 2
figure('Position', [374,508,693,128]);
subplot(1, 5, 1)
if ~isempty(m2_PN)
dabarplot(m2_PN,'xtlabels', condition_names,'fill', 1,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{2}, 'mean', '1');
ylim(ylimits)
title(group_names(2))
ylabel('AUC (ΔFt/F)')
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end

subplot(1, 5, 2)
if ~isempty(m2_UC)
dabarplot(m2_UC,'xtlabels', condition_names,'fill', 1,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{4}, 'mean', '1');
ylim(ylimits)
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end

subplot(1, 5, 3)
if ~isempty(m2_VIP)
dabarplot(m2_VIP,'xtlabels', condition_names,'fill', 1,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{3}, 'mean', '1');
ylim(ylimits)
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end

subplot(1, 5, 4)
if ~isempty(m2_SST)
dabarplot(m2_SST,'xtlabels', condition_names,'fill', 1,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{5}, 'mean', '1');
ylim(ylimits)
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end

subplot(1, 5, 5)
if ~isempty(m2_PV)
dabarplot(m2_PV,'xtlabels', condition_names,'fill', 1,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{1}, 'mean', '1');
ylim(ylimits)
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end

figure('Position', [2020,387,980,137]);
subplot(1, 5, 1)
if ~isempty(PNs{1})
daboxplot(PNs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',1,'outliers',0,'outsymbol','r*','scatter',0,'scattersize', 2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{2}]);
ylabel('AUC (ΔFt/F)'); 
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
ylim(ylimits)
end

subplot(1, 5, 2)
if ~isempty(UCs{1})
daboxplot(UCs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',1,'outliers',0,'outsymbol','r*','scatter',0,'scattersize', 2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{4}]);
ylabel('AUC (ΔFt/F)'); 
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
ylim(ylimits)
end

subplot(1, 5, 3)
if ~isempty(VIPs{1}) && ~isempty(VIPs{2})
daboxplot(VIPs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',1,'outliers',0,'outsymbol','r*','scatter',0,'scattersize', 2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{3}]);
ylabel('AUC (ΔFt/F)'); 
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
ylim(ylimits)
end

subplot(1, 5, 4)
if ~isempty(PVs{1})
daboxplot(PVs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',1,'outliers',0,'outsymbol','r*','scatter',0,'scattersize', 2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{1}]);
ylabel('AUC (ΔFt/F)'); 
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
ylim(ylimits)
end

subplot(1, 5, 5)
if ~isempty(SSTs{1})
daboxplot(SSTs,'linkline',1,...
    'xtlabels', condition_names,...
    'whiskers',1,'outliers',0,'outsymbol','r*','scatter',0,'scattersize', 2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{5}]);
ylabel('AUC (ΔFt/F)'); 
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
ylim(ylimits)
end
end

function output = reformatdata(var1, var2, var3, celltype)
    counter = 1;
    output = [];
    for i = 1:size(var1, 1)
        temp1 = var1{i, celltype};
        temp2 = var2{i, celltype};
        temp3 = var3{i, celltype};
        
        if isempty(temp1)
            output = output;
        else
            % Trial average!
            temp1 = mean(temp1, 2, 'omitnan');
            temp2 = mean(temp2, 2, 'omitnan');
            temp3 = mean(temp3, 2, 'omitnan');
            for j = 1:length(temp1)
                output(counter, 1) = temp1(j);
                output(counter, 2) = temp2(j);
                output(counter, 3) = temp3(j);
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

function analyze_and_plot_relative_change(m1_var, m2_var, color, cellType)
    % ANALYZE_AND_PLOT_RELATIVE_CHANGE - Computes and visualizes the relative change
    % from DCZ to Post in control and experimental groups.
    %
    % Inputs:
    %   m1_PN - [n1 x 3] matrix (Control group: Pre, DCZ, Post)
    %   m2_PN - [n2 x 3] matrix (Experimental group: Pre, DCZ, Post)
    %
    % Outputs:
    %   Prints statistical results and generates a bar plot.

    % Compute relative change from DCZ to Post for both groups
    if ~isempty(m1_var) && ~isempty(m2_var)
    rel_change_control = (m1_var(:,3) - m1_var(:,2)) ./ m1_var(:,2);
    rel_change_experiment = (m2_var(:,3) - m2_var(:,2)) ./ m2_var(:,2);

    % Compute the mean of the control group to remove baseline effects
    baseline_control_effect = mean(rel_change_control, 'omitnan');

    % Correct the experimental group by removing control effects
    adjusted_control = rel_change_control - baseline_control_effect;
    adjusted_experiment = rel_change_experiment - baseline_control_effect;

    % Compute means and standard errors
    mean_control = mean(adjusted_control, 'omitnan');
    median_control = median(adjusted_control, 'omitnan');
    sem_control = std(adjusted_control, 'omitnan') / sqrt(length(adjusted_control(~isnan(rel_change_control))));

    mean_experiment = mean(adjusted_experiment, 'omitnan');
    median_experiment = median(adjusted_experiment, 'omitnan');
    sem_experiment = std(adjusted_experiment, 'omitnan') / sqrt(length(adjusted_experiment(~isnan(adjusted_experiment))));

    % Create bar plot with error bars
    figure('Position', [695,247,147,128]);
    hold on;
    bar_data = [mean_control, mean_experiment];
    errors = [sem_control, sem_experiment];

    bar(1, mean_control, 'FaceColor', 'none', 'EdgeColor', color);
    bar(2, mean_experiment, 'FaceColor', color, 'EdgeColor', color);
    % Define error bars
    errorbar(1:2, bar_data, errors, 'k', 'LineStyle', 'none', 'LineWidth', 0.5);
    if mean_experiment < 0
        ylim([mean_experiment-sem_experiment*1.5, 0])
    elseif mean_experiment > 0
        ylim([0, (mean_experiment+sem_experiment*1.5)])
    end
    xlim([0.5 2.5])

    % Format plot
    xticks([1 2]);
    xticklabels({'Control', 'Plasticity'});
    ylabel('Corrected ∆AUC');
    title('');
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica');
    %ylim([-5.5, 5.5])
    box off;


    % Display statistics
    warning(cellType)
    fprintf('Control Mean ± SEM: %.4f ± %.4f\n', mean_control, sem_control);
    fprintf('Control Median: %.4f ± %.4f\n', median_control, sem_control);
    fprintf('Experimental (Corrected) Mean ± SEM: %.4f ± %.4f\n', mean_experiment, sem_experiment);
    fprintf('Experimental (Corrected) Median ± SEM: %.4f ± %.4f\n', median_experiment, sem_experiment);

    % Perform statistical test
    [h, p_norm] = kstest(adjusted_experiment); % Kolmogorov-Smirnov test

    if p_norm > 0.05
        [h, p] = ttest(adjusted_experiment);
        test_used = 't-test';
    else
        [p, h] = signrank(adjusted_experiment);
        test_used = 'Wilcoxon signed-rank test';
    end

    fprintf('Statistical test used: %s\n', test_used);
    fprintf('p-value: %.4f\n', p);

    if p < 0.05
        fprintf('The change from DCZ to Post in the experimental group is significant (p < 0.05).\n');
    else
        fprintf('No significant change detected (p >= 0.05).\n');
    end

    hold off;
    end
end

