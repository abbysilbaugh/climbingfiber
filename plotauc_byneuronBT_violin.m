function plotauc_byneuronBT_violin(m1_cond1, m1_cond2, neuron_colors, evoked_win, condition_names, ylimits, statstype)

% Get AUC for each neuron
m1_cond1 = getauc(m1_cond1, evoked_win);
m1_cond2 = getauc(m1_cond2, evoked_win);

% Reformat data
% Column 1 is condition 1 and column 2 is condition 2
m1_PV = reformatdata(m1_cond1, m1_cond2, 1);
m1_PN = reformatdata(m1_cond1, m1_cond2, 2);
m1_VIP = reformatdata(m1_cond1, m1_cond2, 3);
m1_UC = reformatdata(m1_cond1, m1_cond2, 4);
m1_SST = reformatdata(m1_cond1, m1_cond2, 5);

if strcmp(statstype, 'pairedstats')
% RUN STATS (1 group, 2 conditions)
p_m1_PV = runpairedstats(m1_PV, 'PV');
p_m1_PN = runpairedstats(m1_PN, 'PN');
p_m1_VIP = runpairedstats(m1_VIP, 'VIP');
p_m1_UC = runpairedstats(m1_UC, 'UC');
p_m1_SST = runpairedstats(m1_SST, 'SST');
elseif strcmp(statstype, 'unpairedstats')
p_m1_PV = rununpairedstats(m1_PV, 'PV');
p_m1_PN = rununpairedstats(m1_PN, 'PN');
p_m1_VIP = rununpairedstats(m1_VIP, 'VIP');
p_m1_UC = rununpairedstats(m1_UC, 'UC');
p_m1_SST = rununpairedstats(m1_SST, 'SST');
end

% Create boxplots
figure('Position', [1101,696,515,183]);
title('Group 1 (Cond 1 vs Cond 2; each neuron)')
subplot(1, 5, 1)
ylabel('AUC (∆Ft/F)'); xlim([0.5 2.5])
if ~isempty(m1_PN)
    %violin_fileexchange(m1_PN, 'facecolor', neuron_colors{2}, 'edgecolor', neuron_colors{2})
daviolinplot(m1_PN,'xtlabels', condition_names, ...
     'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{2}, 'linkline', 1);
ylim(ylimits)
if p_m1_PN < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end
ylabel('AUC (∆Ft/F)'); xlim([0.5 2.5])

subplot(1, 5, 2)
if ~isempty(m1_UC)
  %  violin_fileexchange(m1_UC, 'facecolor', neuron_colors{4}, 'edgecolor', neuron_colors{4})
 daviolinplot(m1_UC,'xtlabels', condition_names,...
     'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{4}, 'linkline', 1);
ylim(ylimits)
if p_m1_UC < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end
ylabel('AUC (∆Ft/F)'); xlim([0.5 2.5])

subplot(1, 5, 3)
if ~isempty(m1_VIP)
  %  violin_fileexchange(m1_VIP, 'facecolor', neuron_colors{3}, 'edgecolor', neuron_colors{3})
 daviolinplot(m1_VIP,'xtlabels', condition_names,...
     'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{3}, 'linkline', 1);
ylim(ylimits)
if p_m1_VIP < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end
ylabel('AUC (∆Ft/F)'); xlim([0.5 2.5])

subplot(1, 5, 4)
if ~isempty(m1_SST)
 %   violin_fileexchange(m1_SST, 'facecolor', neuron_colors{5}, 'edgecolor', neuron_colors{5})
 daviolinplot(m1_SST,'xtlabels', condition_names,...
     'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{5}, 'linkline', 1);
ylim(ylimits)
if p_m1_SST < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end
ylabel('AUC (∆Ft/F)'); xlim([0.5 2.5])

subplot(1, 5, 5)
if ~isempty(m1_PV)
 %   violin_fileexchange(m1_PV, 'facecolor', neuron_colors{1}, 'edgecolor', neuron_colors{1})
 daviolinplot(m1_PV,'xtlabels', condition_names,...
     'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{1}, 'linkline', 1);
ylim(ylimits)
if p_m1_PV < 0.05
    text(1.5, 1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20);
end
end
ylabel('AUC (∆Ft/F)'); xlim([0.5 2.5])

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
    end
else
    p = NaN;


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
    fprintf('n W: %d, n W+CF: %d\n', n1, n2);
    fprintf('Mean W: %.4f, Mean W+CF: %.4f\n', mean_data1, mean_data2);
    fprintf('Median W: %.4f, Median W+CF: %.4f\n', median_data1, median_data2);
    fprintf('SEM W: %.4f, SEM W+CF: %.4f\n', sem_data1, sem_data2);

end

function p = rununpairedstats(data, cellType)
if ~isempty(data)
    data1 = data(:, 1); data2 = data(:, 2);
    if sum(~isnan(data1)) >=4 && sum(~isnan(data2)) >=4
    is_normal_1 = lillietest(data1); % 0 = normal, 1 = not normal
    is_normal_2 = lillietest(data2);
    
    % Display normality test results
    if ~is_normal_1 && ~is_normal_2

        % Unpaired t-test (for normal data)
        [~, p] = ttest(data1, data2);
        testtype = 'Unpaired t-test';

    else

        p = ranksum(data1, data2);
        testtype = 'Mann-Whitney U';
        
    end
    else
        p = NaN;

        testtype = 'error';
    end
else
    p = NaN;

    testtype = 'error';
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
    fprintf('n W: %d, n W+CF: %d\n', n1, n2);
    fprintf('Mean W: %.4f, Mean W+CF: %.4f\n', mean_data1, mean_data2);
    fprintf('Median W: %.4f, Median W+CF: %.4f\n', median_data1, median_data2);
    fprintf('SEM W: %.4f, SEM W+CF: %.4f\n', sem_data1, sem_data2);

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
