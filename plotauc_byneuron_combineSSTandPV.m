function plotauc_byneuron_combineSSTandPV(m1_cond1, m1_cond2, m2_cond1, m2_cond2, neuron_colors, plotscatter, evoked_win, group_names, condition_names, ylimits)

PV_SST_color = (neuron_colors{1} + neuron_colors{2})/2;

% Get AUC for each neuron
m1_cond1 = getauc(m1_cond1, evoked_win);
m1_cond2 = getauc(m1_cond2, evoked_win);
m2_cond1 = getauc(m2_cond1, evoked_win);
m2_cond2 = getauc(m2_cond2, evoked_win);

% Reformat data
% Column 1 is condition 1 and column 2 is condition 2
m1_PV = reformatdata(m1_cond1, m1_cond2, 1);
m1_PN = reformatdata(m1_cond1, m1_cond2, 2);
m1_VIP = reformatdata(m1_cond1, m1_cond2, 3);
m1_UC = reformatdata(m1_cond1, m1_cond2, 4);
m1_SST = reformatdata(m1_cond1, m1_cond2, 5);

m1_PV_SST = cat(1, m1_PV, m1_SST);

m2_PV = reformatdata(m2_cond1, m2_cond2, 1);
m2_PN = reformatdata(m2_cond1, m2_cond2, 2);
m2_VIP = reformatdata(m2_cond1, m2_cond2, 3);
m2_UC = reformatdata(m2_cond1, m2_cond2, 4);
m2_SST = reformatdata(m2_cond1, m2_cond2, 5);

m2_PV_SST = cat(1, m2_PV, m2_SST);

PNs{1} = m1_PN;
PNs{2} = m2_PN;
UCs{1} = m1_UC;
UCs{2} = m2_UC;
VIPs{1} = m1_VIP;
VIPs{2} = m2_VIP;
PV_SSTs{1} = m1_PV_SST;
PV_SSTs{2} = m2_PV_SST;

% RUN STATS (1 group, 2 conditions)
p_m1_PN = runpairedstats(m1_PN, 'PN; Expt1');
p_m1_VIP = runpairedstats(m1_VIP, 'VIP; Expt1');
p_m1_UC = runpairedstats(m1_UC, 'UC; Expt1');
p_m1_PV_SST = runpairedstats(m1_PV_SST, 'PV & SST; Expt1');

p_m2_PN = runpairedstats(m2_PN, 'PN; Expt2');
p_m2_VIP = runpairedstats(m2_VIP, 'VIP; Expt2');
p_m2_UC = runpairedstats(m2_UC, 'UC; Expt2');
p_m2_PV_SST = runpairedstats(m2_PV_SST, 'PV & SST; Expt2');

% Create bar plots for mouse 1
figure('Position', [100,387,500,120]);
title('Group 1 (Cond 1 vs Cond 2; each neuron)')
subplot(1, 5, 1)
ylabel('AUC (∆Ft/F)')
if ~isempty(m1_PN)
dabarplot(m1_PN,'xtlabels', condition_names,'fill', 0,...
    'scatter',plotscatter,'scattersize',3,'scatteralpha',1,'outliers',0, 'color', neuron_colors{2}, 'mean', '1');
ylim(ylimits)
if p_m1_PN < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
title(group_names(1))
end
ylabel('AUC (∆Ft/F)')
set(gca, 'FontSize', 7, 'FontName', 'Helvetica', 'LineWidth', 0.5)

subplot(1, 5, 2)
if ~isempty(m1_UC)
dabarplot(m1_UC,'xtlabels', condition_names,'fill', 0,...
    'scatter', plotscatter,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{4}, 'mean', '1');
ylim(ylimits)
if p_m1_UC < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

subplot(1, 5, 3)
if ~isempty(m1_VIP)
dabarplot(m1_VIP,'xtlabels', condition_names,'fill', 0,...
    'scatter', plotscatter,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{3}, 'mean', '1');
ylim(ylimits)
if p_m1_VIP < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end
set(gca, 'FontSize', 7, 'FontName', 'Helvetica', 'LineWidth', 0.5)

subplot(1, 5, 4)
if ~isempty(m1_PV_SST)
dabarplot(m1_PV_SST,'xtlabels', condition_names,'fill', 0,...
    'scatter', plotscatter,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', PV_SST_color, 'mean', '1');
ylim(ylimits)
if p_m1_PV_SST < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end
set(gca, 'FontSize', 7, 'FontName', 'Helvetica', 'LineWidth', 0.5)


% Create bar plots for mouse 2
figure('Position', [100,387,500,120]);
subplot(1, 5, 1)
if ~isempty(m2_PN)
dabarplot(m2_PN,'xtlabels', condition_names,'fill', 1,...
    'scatter', plotscatter,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{2}, 'mean', '1');
ylim(ylimits)
if p_m2_PN < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
title(group_names(2))
end
ylabel('AUC (∆Ft/F)')
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

subplot(1, 5, 2)
if ~isempty(m2_UC)
dabarplot(m2_UC,'xtlabels', condition_names,'fill', 1,...
    'scatter', plotscatter,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{4}, 'mean', '1');
ylim(ylimits)
if p_m2_UC < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end
set(gca, 'FontSize', 7, 'FontName', 'Helvetica', 'LineWidth', 0.5)

subplot(1, 5, 3)
if ~isempty(m2_VIP)
dabarplot(m2_VIP,'xtlabels', condition_names,'fill', 1,...
    'scatter', plotscatter,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{3}, 'mean', '1');
ylim(ylimits)
if p_m2_VIP < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end
set(gca, 'FontSize', 7, 'FontName', 'Helvetica', 'LineWidth', 0.5)

subplot(1, 5, 4)
if ~isempty(m2_PV_SST)
dabarplot(m2_PV_SST,'xtlabels', condition_names,'fill', 1,...
    'scatter', plotscatter,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', PV_SST_color, 'mean', '1');
ylim(ylimits)
if p_m2_PV_SST < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end
set(gca, 'FontSize', 7, 'FontName', 'Helvetica', 'LineWidth', 0.5)


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
[p_PV_SST_c1, p_PV_SST_c2] = rununpairedstats(m1_PV_SST, m2_PV_SST);
fprintf('Group 1 vs Group 2 Cond 1 (PV & SST) %.4f\n', p_PV_SST_c1);
fprintf('Group 1 vs Group 2 Cond 2 (PV & SST) %.4f\n', p_PV_SST_c2);

figure('Position', [100,387,700,120]);
subplot(1, 5, 1)
if ~isempty(PNs{1})
dabarplot(PNs,...
    'xtlabels', condition_names,...
    'outliers',0,'scatter', 0,'scattersize', 2, 'color', [neuron_colors{2}; neuron_colors{2}]);
ylabel('AUC (∆Ft/F)'); 
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end
ylim(ylimits)
xlim([0.5 2.5])

subplot(1, 5, 2)
if ~isempty(UCs{1})
dabarplot(UCs,...
    'xtlabels', condition_names,...
    'outliers',0,'scatter', 0,'scattersize', 2, 'color', [neuron_colors{4}; neuron_colors{4}]);
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end
ylim(ylimits)
xlim([0.5 2.5])

subplot(1, 5, 3)
if ~isempty(VIPs{1}) && ~isempty(VIPs{2})
dabarplot(VIPs,...
    'xtlabels', condition_names,...
    'outliers',0,'scatter', 0,'scattersize', 2, 'color', [neuron_colors{3}; neuron_colors{3}]);
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end
ylim(ylimits)
xlim([0.5 2.5])

subplot(1, 5, 4)
if ~isempty(PV_SSTs{1})
dabarplot(PV_SSTs,...
    'xtlabels', condition_names,...
    'outliers',0,'scatter', 0,'scattersize', 2, 'color', [PV_SST_color; PV_SST_color]);
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end
ylim(ylimits)
xlim([0.5 2.5])

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

    n1 = sum(~isnan(data1));
    n2 = sum(~isnan(data2));
    mean_data1 = mean(data1, 'omitnan');
    mean_data2 = mean(data2, 'omitnan');
    median_data1 = median(data1, 'omitnan');
    median_data2 = median(data2, 'omitnan');
    sem_data1 = std(data1, 'omitnan')./sqrt(n1);
    sem_data2 = std(data2, 'omitnan')./sqrt(n2);
    
    % Print results
    fprintf('Cell Type: %s\n', cellType);
    fprintf('Test Type: %s\n', testtype);
    fprintf('p-value: %.4f\n', p);
    fprintf('n Pre: %d, n Post: %d\n', n1, n2);
    fprintf('Mean Pre: %.4f, Mean Post: %.4f\n', mean_data1, mean_data2);
    fprintf('Median Pre: %.4f, Median Post: %.4f\n', median_data1, median_data2);
    fprintf('SEM Pre: %.4f, SEM Post: %.4f\n', sem_data1, sem_data2);
else
    p = NaN;

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
            warning('mann-whitney u-test')
        end
    
        if ~is_normal_2_data1 && ~is_normal_2_data2
            % Unpaired t-test for condition 2
            [~, p2] = ttest2(data1(:, 2), data2(:, 2));
            warning('unpaired t-test')
        else
            % Mann-Whitney U test (rank-sum test) for condition 2
            p2 = ranksum(data1(:, 2), data2(:, 2));
            warning('mann-whitney u-test')
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
