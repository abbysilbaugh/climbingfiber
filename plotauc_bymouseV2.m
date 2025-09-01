function plotauc_bymouseV2(m1_cond1, m1_cond2, m2_cond1, m2_cond2, neuron_colors, plotlines, evoked_win, group_names, condition_names, ylimits, getpersistent, chooseplotstyle)

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
p_m1_PV = runstats(m1_PV, chooseplotstyle, 'PV; RWS');
p_m1_PN = runstats(m1_PN, chooseplotstyle, 'PN; RWS');
p_m1_VIP = runstats(m1_VIP, chooseplotstyle, 'VIP; RWS');
p_m1_UC = runstats(m1_UC, chooseplotstyle, 'UC; RWS');
p_m1_SST = runstats(m1_SST, chooseplotstyle, 'SST; RWS');

p_m2_PV = runstats(m2_PV, chooseplotstyle, 'PV; RWS+CF');
p_m2_PN = runstats(m2_PN, chooseplotstyle, 'PN; RWS+CF');
p_m2_VIP = runstats(m2_VIP, chooseplotstyle, 'VIP; RWS+CF');
p_m2_UC = runstats(m2_UC, chooseplotstyle, 'UC; RWS+CF');
p_m2_SST = runstats(m2_SST, chooseplotstyle, 'SST; RWS+CF');

if strcmp(chooseplotstyle, 'normalized')
     % Normalize Post to Pre
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

    m2_PV_Wnorm = m2_PV(:,1) ./ m2_PV(:,1);
    m2_PN_Wnorm = m2_PN(:,1) ./ m2_PN(:,1);
    m2_VIP_Wnorm = m2_VIP(:,1) ./ m2_VIP(:,1);
    m2_UC_Wnorm = m2_UC(:,1) ./ m2_UC(:,1);
    m2_SST_Wnorm = m2_SST(:,1) ./ m2_SST(:,1);
    
    m2_PV_WCFnorm = m2_PV(:,2) ./ m2_PV(:,1);
    m2_PN_WCFnorm = m2_PN(:,2) ./ m2_PN(:,1);
    m2_VIP_WCFnorm = m2_VIP(:,2) ./ m2_VIP(:,1);
    m2_UC_WCFnorm = m2_UC(:,2) ./ m2_UC(:,1);
    m2_SST_WCFnorm = m2_SST(:,2) ./ m2_SST(:,1);
    
    m2_PV(:, 1) = m2_PV_Wnorm; m2_PV(:, 2) = m2_PV_WCFnorm;
    m2_PN(:, 1) = m2_PN_Wnorm; m2_PN(:, 2) = m2_PN_WCFnorm;
    m2_VIP(:, 1) = m2_VIP_Wnorm; m2_VIP(:, 2) = m2_VIP_WCFnorm;
    m2_UC(:, 1) = m2_UC_Wnorm; m2_UC(:, 2) = m2_UC_WCFnorm;
    m2_SST(:, 1) = m2_SST_Wnorm; m2_SST(:, 2) = m2_SST_WCFnorm;

end

% Create boxplots for mouse 1
% X values for pre (1) and post (2)
x = [1, 2];
figure('Position', [592,199,566,143]);
title('Group 1 (Cond 1 vs Cond 2; each neuron)')
subplot(1, 5, 1)
if ~isempty(m1_PN)
    numMice = size(m1_PN, 1);
    for i = 1:numMice
        plot(x, m1_PN(i,:), '-o', 'MarkerSize', 3, 'LineWidth', 0.5, 'Color', neuron_colors{2}, 'MarkerFaceColor', [1 1 1]);
        hold on
    end
    means = mean(m1_PN, 1);
    plot(x, means, ':', 'Color', neuron_colors{2}, 'LineWidth', .5)
    xticks([1 2])
xticklabels({'Pre', 'Post'});
if strcmp(chooseplotstyle, 'normalized')
    ylabel('Normalized AUC (ΔFt/F)');
else
    ylabel('AUC (ΔFt/F)');
end
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
if p_m1_PN < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'k');
end
end

subplot(1, 5, 2)
if ~isempty(m1_UC)
    numMice = size(m1_UC, 1);
    for i = 1:numMice
        plot(x, m1_UC(i,:), '-o', 'MarkerSize', 3, 'LineWidth', 0.5, 'Color', neuron_colors{4}, 'MarkerFaceColor', [1 1 1]);
        hold on
    end
    means = mean(m1_UC, 1);
    plot(x, means, ':', 'Color', neuron_colors{4}, 'LineWidth', 0.5)
    xticks([1 2])
xticklabels({'Pre', 'Post'});
if strcmp(chooseplotstyle, 'normalized')
    ylabel('Normalized AUC (ΔFt/F)');
else
    ylabel('AUC (ΔFt/F)');
end
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
if p_m1_UC < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 3)
if ~isempty(m1_VIP)
    numMice = size(m1_VIP, 1);
    for i = 1:numMice
        plot(x, m1_VIP(i,:), '-o', 'MarkerSize', 3, 'LineWidth', 0.5, 'Color', neuron_colors{3}, 'MarkerFaceColor', [1 1 1]);
        hold on
    end
        means = mean(m1_VIP, 1);
    plot(x, means, ':', 'Color', neuron_colors{3}, 'LineWidth', 0.5)
    xticks([1 2])
xticklabels({'Pre', 'Post'});
if strcmp(chooseplotstyle, 'normalized')
    ylabel('Normalized AUC (ΔFt/F)');
else
    ylabel('AUC (ΔFt/F)');
end
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
if p_m1_VIP < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 4)
if ~isempty(m1_SST)
    numMice = size(m1_SST, 1);
    for i = 1:numMice
        plot(x, m1_SST(i,:), '-o', 'MarkerSize', 3, 'LineWidth', 0.5, 'Color', neuron_colors{5}, 'MarkerFaceColor', [1 1 1]);
        hold on
    end
        means = mean(m1_SST, 1);
    plot(x, means, ':', 'Color', neuron_colors{5}, 'LineWidth', 0.5)
    xticks([1 2])
xticklabels({'Pre', 'Post'});
if strcmp(chooseplotstyle, 'normalized')
    ylabel('Normalized AUC (ΔFt/F)');
else
    ylabel('AUC (ΔFt/F)');
end
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
if p_m1_SST < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 5)
if ~isempty(m1_PV)
    numMice = size(m1_PV, 1);
    for i = 1:numMice
        plot(x, m1_PV(i,:), '-o', 'MarkerSize', 3, 'LineWidth', 0.5, 'Color', neuron_colors{1}, 'MarkerFaceColor', [1 1 1]);
        hold on
    end
        means = mean(m1_PV, 1);
    plot(x, means, ':', 'Color', neuron_colors{1}, 'LineWidth', 0.5)
    xticks([1 2])
xticklabels({'Pre', 'Post'});
if strcmp(chooseplotstyle, 'normalized')
    ylabel('Normalized AUC (ΔFt/F)');
else
    ylabel('AUC (ΔFt/F)');
end
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
if p_m1_PV < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20)
end
end


% Create boxplots for mouse 2
figure('Position', [592,199,566,143]);
title('Group 1 (Cond 1 vs Cond 2; each neuron)')
subplot(1, 5, 1)
if ~isempty(m2_PN)
    numMice = size(m2_PN, 1);
    for i = 1:numMice
        plot(x, m2_PN(i,:), '-o', 'MarkerSize', 3, 'LineWidth', 0.5, 'Color', neuron_colors{2}, 'MarkerFaceColor', neuron_colors{2});
        hold on
    end
        means = mean(m2_PN, 1);
    plot(x, means, ':', 'Color', neuron_colors{2}, 'LineWidth', 0.5)
    xticks([1 2])
xticklabels({'Pre', 'Post'});
if strcmp(chooseplotstyle, 'normalized')
    ylabel('Normalized AUC (ΔFt/F)');
else
    ylabel('AUC (ΔFt/F)');
end
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
if p_m2_PN < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 2)
if ~isempty(m2_UC)
    numMice = size(m2_UC, 1);
    for i = 1:numMice
        plot(x, m2_UC(i,:), '-o', 'MarkerSize', 3, 'LineWidth', 0.5, 'Color', neuron_colors{4}, 'MarkerFaceColor', neuron_colors{4});
        hold on
    end
        means = mean(m2_UC, 1);
    plot(x, means, ':', 'Color', neuron_colors{4}, 'LineWidth', 0.5)
    xticks([1 2])
xticklabels({'Pre', 'Post'});
if strcmp(chooseplotstyle, 'normalized')
    ylabel('Normalized AUC (ΔFt/F)');
else
    ylabel('AUC (ΔFt/F)');
end
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
if p_m2_UC < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 3)
if ~isempty(m2_VIP)
    numMice = size(m2_VIP, 1);
    for i = 1:numMice
        plot(x, m2_VIP(i,:), '-o', 'MarkerSize', 3, 'LineWidth', 0.5, 'Color', neuron_colors{3}, 'MarkerFaceColor', neuron_colors{3});
        hold on
    end
        means = mean(m2_VIP, 1);
    plot(x, means, ':', 'Color', neuron_colors{3}, 'LineWidth', 0.5)
    xticks([1 2])
xticklabels({'Pre', 'Post'});
if strcmp(chooseplotstyle, 'normalized')
    ylabel('Normalized AUC (ΔFt/F)');
else
    ylabel('AUC (ΔFt/F)');
end
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
if p_m2_VIP < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 4)
if ~isempty(m2_SST)
    numMice = size(m2_SST, 1);
    for i = 1:numMice
        plot(x, m2_SST(i,:), '-o', 'MarkerSize', 3, 'LineWidth', 0.5, 'Color', neuron_colors{5}, 'MarkerFaceColor', neuron_colors{5});
        hold on
    end
        means = mean(m2_SST, 1);
    plot(x, means, ':', 'Color', neuron_colors{5}, 'LineWidth', 0.5)
    xticks([1 2])
xticklabels({'Pre', 'Post'});
if strcmp(chooseplotstyle, 'normalized')
    ylabel('Normalized AUC (ΔFt/F)');
else
    ylabel('AUC (ΔFt/F)');
end
ylim(ylimits)
xlim([0.5 2.5]); box off; set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
if p_m2_SST < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

subplot(1, 5, 5)
if ~isempty(m2_PV)
    numMice = size(m2_PV, 1);
    for i = 1:numMice
        plot(x, m2_PV(i,:), '-o', 'MarkerSize', 3, 'LineWidth', 0.5, 'Color', neuron_colors{1}, 'MarkerFaceColor', neuron_colors{1});
        hold on
    end
        means = mean(m2_PV, 1);
    plot(x, means, ':', 'Color', neuron_colors{1}, 'LineWidth', 0.5)
xticks([1 2])
xticklabels({'Pre', 'Post'});
if strcmp(chooseplotstyle, 'normalized')
    ylabel('Normalized AUC (ΔFt/F)');
else
    ylabel('AUC (ΔFt/F)');
end
ylim(ylimits)
xlim([0.5 2.5])
box off; set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
if p_m2_PV < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end

if ~strcmp(chooseplotstyle, 'normalized')

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
    
    figure('Position', [592,199,513,143]);
    subplot(1, 5, 1)
    if ~isempty(PNs{1})
    daboxplot(PNs,'linkline',1,...
        'xtlabels', condition_names,...
        'whiskers',1,'outliers',0,'outsymbol','r*','scatter',0,'scattersize', 2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{2}]);
    ylabel('AUC'); 
    set(gca,'FontSize',7)
    end
    ylim(ylimits)
    
    subplot(1, 5, 2)
    if ~isempty(UCs{1})
    daboxplot(UCs,'linkline',1,...
        'xtlabels', condition_names,...
        'whiskers',1,'outliers',0,'outsymbol','r*','scatter',0,'scattersize', 2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{4}]);
    ylabel('AUC'); 
    set(gca,'FontSize',7)
    end
    ylim(ylimits)
    
    subplot(1, 5, 3)
    if ~isempty(VIPs{1}) && ~isempty(VIPs{2})
    daboxplot(VIPs,'linkline',1,...
        'xtlabels', condition_names,...
        'whiskers',1,'outliers',0,'outsymbol','r*','scatter',0,'scattersize', 2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{3}]);
    ylabel('AUC'); 
    set(gca,'FontSize',7)
    end
    ylim(ylimits)
    
    subplot(1, 5, 4)
    if ~isempty(PVs{1})
    daboxplot(PVs,'linkline',1,...
        'xtlabels', condition_names,...
        'whiskers',1,'outliers',0,'outsymbol','r*','scatter',0,'scattersize', 2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{1}]);
    ylabel('AUC'); 
    set(gca,'FontSize',7)
    end
    ylim(ylimits)
    
    subplot(1, 5, 5)
    if ~isempty(SSTs{1})
    daboxplot(SSTs,'linkline',1,...
        'xtlabels', condition_names,...
        'whiskers',1,'outliers',0,'outsymbol','r*','scatter',0,'scattersize', 2,'boxalpha',0.6, 'color', [[.5 .5 .5]; neuron_colors{5}]);
    ylabel('AUC'); 
    set(gca,'FontSize',7)
    end
    ylim(ylimits)
    
    % Plot scatter plots
    figure('Position', [2020,387,980,137]);
    % Define cell types and data
    cell_types = {'PV', 'PN', 'VIP', 'UC', 'SST'};
    m1_data = {m1_PV, m1_PN, m1_VIP, m1_UC, m1_SST};
    m2_data = {m2_PV, m2_PN, m2_VIP, m2_UC, m2_SST};
    
    for i = 1:5
        % Extract data for the current cell type
        m1 = m1_data{i};
        m2 = m2_data{i};
    
        if ~isempty(m1) && ~isempty(m2)
            if size(m1, 2) >= 4 && size(m2, 2) >=4
        
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
            scatter(m1(:, 1), m1(:, 2), 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.5 0.5 0.5],'MarkerFaceAlpha', 0.5);
            hold on;
            scatter(m2(:, 1), m2(:, 2), 'MarkerEdgeColor', 'none', 'MarkerFaceColor', neuron_colors{i}, 'MarkerFaceAlpha', 0.5);
            % Plot the line y=x
            plot([min([m1(:, 1); m2(:, 1)]) max([m1(:, 1); m2(:, 1)])], ...
                 [min([m1(:, 1); m2(:, 1)]) max([m1(:, 1); m2(:, 1)])], ...
                 'k--', 'LineWidth', 0.5);
            % Add fit line
            fit_m1 = polyfit(m1(:, 1), m1(:, 2), 1);
            fit_line_x_m1 = linspace(min(m1(:, 1)), max(m1(:, 1)), 100);
            fit_line_y_m1 = polyval(fit_m1, fit_line_x_m1);
            plot(fit_line_x_m1, fit_line_y_m1, 'Color', 'k', 'LineWidth', 0.5);
            
            fit_m2 = polyfit(m2(:, 1), m2(:, 2), 1);
            fit_line_x_m2 = linspace(min(m2(:, 1)), max(m2(:, 1)), 100);
            fit_line_y_m2 = polyval(fit_m2, fit_line_x_m2);
            plot(fit_line_x_m2, fit_line_y_m2, 'Color', neuron_colors{i}, 'LineWidth', 0.5);
            
            % Add title with p-values
            title(sprintf('%s\np(m1)=%.3g, p(m2)=%.3g', cell_types{i}, p_m1, p_m2));
            xlabel('AUC');
            ylabel('AUC');
            axis equal;
            hold off;
            end
        end
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

                case 'normalized'
                    norm_vals1 = (data1 ./ data1);
                    norm_vals = (data2 ./ data1);
                    
                    is_normal = lillietest(norm_vals);
                    
                    if ~is_normal
                        testtype = 'one-sample t-test';
                        [~, p] = ttest(norm_vals, 1);
                    else
                        testtype = 'one-sample signrank';
                        p = signrank(norm_vals, 1);
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
