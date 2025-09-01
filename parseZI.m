function parseZI(allData, mouse, celltype)

w_pre_traces = cell(2, 1);
wo_pre_traces = cell(2, 1);
w_dcz_traces = cell(2, 1);
wo_dcz_traces = cell(2, 1);

w_pre_prob = cell(2, 1);
wo_pre_prob = cell(2, 1);
w_dcz_prob = cell(2, 1);
wo_dcz_prob = cell(2, 1);

for i = [mouse]

tempdata = allData.data{i};

trialType = tempdata.trialType;
cellType = tempdata.cellType;
dczPeriod = tempdata.dczPeriod;
motType = tempdata.trialmotType;

NM = strcmp(motType, 'NM');
PN = strcmp(cellType, 'PN');
UC = strcmp(cellType, 'UC');

w_trials = strcmp(trialType, 'W');
wo_trials = strcmp(trialType, 'WO');

w_pre = w_trials & strcmp(dczPeriod, 'NO DCZ'); %& NM;
wo_pre = wo_trials & strcmp(dczPeriod, 'NO DCZ'); %& NM;
w_dcz = w_trials & strcmp(dczPeriod, 'DCZ'); %& NM;
wo_dcz = wo_trials & strcmp(dczPeriod, 'DCZ'); %& NM;

w_pre_NM = w_trials & strcmp(dczPeriod, 'NO DCZ') & strcmp(motType, 'NM');
wo_pre_NM = wo_trials & strcmp(dczPeriod, 'NO DCZ') & strcmp(motType, 'NM');
w_dcz_NM = w_trials & strcmp(dczPeriod, 'DCZ') & strcmp(motType, 'NM');
wo_dcz_NM = wo_trials & strcmp(dczPeriod, 'DCZ') & strcmp(motType, 'NM');

w_pre_T = w_trials & strcmp(dczPeriod, 'NO DCZ') & strcmp(motType, 'T');
wo_pre_T = wo_trials & strcmp(dczPeriod, 'NO DCZ') & strcmp(motType, 'T');
w_dcz_T = w_trials & strcmp(dczPeriod, 'DCZ') & strcmp(motType, 'T');
wo_dcz_T = wo_trials & strcmp(dczPeriod, 'DCZ') & strcmp(motType, 'T');

if strcmp(celltype, 'PN')
    signal = tempdata.evokedtraces(:, PN, :);
else
signal = tempdata.evokedtraces(:, :, :);
end
%signal = tempdata.evokedtraces;

[nFrames, nCells, nTrials] = size(signal);

for j = 1:nCells
    for k = 1:nTrials
        temp = signal(:, j, k);
        temp = temp - mean(temp(300:305));
        signal(:, j, k) = temp;

    end
end

w_pre = signal(:, :, w_pre);
wo_pre = signal(:, :, wo_pre);
w_dcz = signal(:, :, w_dcz);
wo_dcz = signal(:, :, wo_dcz);

w_pre_evokedprob = nan(nCells, 1);
wo_pre_evokedprob = nan(nCells, 1);
w_dcz_evokedprob = nan(nCells, 1);
wo_dcz_evokedprob = nan(nCells, 1);

for j = 1:nCells
    temp = squeeze(w_pre(1, j, :));
    w_pre_evokedprob(j) = sum(~isnan(temp))/length(temp);

    temp = squeeze(wo_pre(1, j, :));
    wo_pre_evokedprob(j) = sum(~isnan(temp))/length(temp);

    temp = squeeze(w_dcz(1, j, :));
    w_dcz_evokedprob(j) = sum(~isnan(temp))/length(temp);

    temp = squeeze(wo_dcz(1, j, :));
    wo_dcz_evokedprob(j) = sum(~isnan(temp))/length(temp);

end

w_pre_trialavg = mean(w_pre, 3, 'omitnan');
wo_pre_trialavg = mean(wo_pre, 3, 'omitnan');
w_dcz_trialavg = mean(w_dcz, 3, 'omitnan');
wo_dcz_trialavg = mean(wo_dcz, 3, 'omitnan');


w_pre_traces{i} = w_pre_trialavg;
wo_pre_traces{i} = wo_pre_trialavg;
w_dcz_traces{i} = w_dcz_trialavg;
wo_dcz_traces{i} = wo_dcz_trialavg;

w_pre_prob{i} = w_pre_evokedprob;
wo_pre_prob{i} = wo_pre_evokedprob;
w_dcz_prob{i} = w_dcz_evokedprob;
wo_dcz_prob{i} = wo_dcz_evokedprob;

end

w_pre_traces = cat(2, w_pre_traces{:});
wo_pre_traces = cat(2, wo_pre_traces{:});
w_dcz_traces = cat(2, w_dcz_traces{:});
wo_dcz_traces = cat(2, wo_dcz_traces{:});

w_pre_prob = cat(1, w_pre_prob{:});
wo_pre_prob = cat(1, wo_pre_prob{:});
w_dcz_prob = cat(1, w_dcz_prob{:});
wo_dcz_prob = cat(1, wo_dcz_prob{:});

w_pre_popavg = mean(w_pre_traces, 2, 'omitnan');
wo_pre_popavg = mean(wo_pre_traces, 2, 'omitnan');
w_dcz_popavg = mean(w_dcz_traces, 2, 'omitnan');
wo_dcz_popavg = mean(wo_dcz_traces, 2, 'omitnan');

% Combine the probability data into a matrix for grouped bar plot
probabilities = [mean(w_pre_prob), mean(wo_pre_prob), mean(w_dcz_prob), mean(wo_dcz_prob)];
sem_probabilities = [std(w_pre_prob)/sqrt(length(w_pre_prob)), std(wo_pre_prob)/sqrt(length(wo_pre_prob)), ...
                     std(w_dcz_prob)/sqrt(length(w_dcz_prob)), std(wo_dcz_prob)/sqrt(length(wo_dcz_prob))];

% Perform t-tests
[~, p_pre] = ttest2(w_pre_prob, wo_pre_prob);
[~, p_dcz] = ttest2(w_dcz_prob, wo_dcz_prob);

% Combine the probability data into a matrix for grouped bar plot
probabilities = [mean(w_pre_prob), mean(wo_pre_prob), mean(w_dcz_prob), mean(wo_dcz_prob)];
sem_probabilities = [std(w_pre_prob)/sqrt(length(w_pre_prob)), std(wo_pre_prob)/sqrt(length(wo_pre_prob)), ...
                     std(w_dcz_prob)/sqrt(length(w_dcz_prob)), std(wo_dcz_prob)/sqrt(length(wo_dcz_prob))];

% Create a bar plot
figure;
b = bar(probabilities, 'FaceColor', 'flat');

% Set colors for each bar
b.CData(1, :) = [0.5, 0.5, 0.5]; % Grey for the first bar (w_pre_prob)
b.CData(2, :) = [171, 94, 36]/255; % Custom color for the second bar (wo_pre_prob)
b.CData(3, :) = [0.5, 0.5, 0.5]; % Grey for the third bar (w_dcz_prob)
b.CData(4, :) = [171, 94, 36]/255; % Custom color for the fourth bar (wo_dcz_prob)

% Add error bars (SEM)
hold on;
errorbar(1:4, probabilities, sem_probabilities, 'k', 'linestyle', 'none', 'LineWidth', 1.5);

% Set y limits
ylim([0 1]);

% Add significance lines
y_max = max(probabilities + sem_probabilities) + 0.05; % Place the line slightly above the bars
line([1, 2], [y_max, y_max], 'Color', 'k', 'LineWidth', 1.5); % Line between w_pre and wo_pre
text(1.5, y_max + 0.05, sprintf('p = %.3f', p_pre), 'HorizontalAlignment', 'center');

line([3, 4], [y_max, y_max], 'Color', 'k', 'LineWidth', 1.5); % Line between w_dcz and wo_dcz
text(3.5, y_max + 0.05, sprintf('p = %.3f', p_dcz), 'HorizontalAlignment', 'center');

% Customize the plot
set(gca, 'XTickLabel', {'W', 'WO', 'W (DCZ)', 'WO (DCZ)'});
ylabel('Evoked Probability');
title('Evoked Probability by Condition');
hold off;




figure;
plot(w_pre_trialavg, 'color', 'k')
hold on
plot(wo_pre_trialavg, 'color', [171, 94, 36, 255]/255)

figure;
plot(w_dcz_trialavg, 'color', 'k')
hold on
plot(wo_dcz_trialavg, 'color', [171, 94, 36, 255]/255)

figure;
plot(w_pre_popavg, 'color', 'k')
hold on
plot(wo_pre_popavg, 'color', [171, 94, 36, 255]/255)
ylim([-0.05 0.4])
xlim([300 450])

figure;
plot(w_dcz_popavg, 'color', 'k')
hold on
plot(wo_dcz_popavg, 'color', [171, 94, 36, 255]/255)
ylim([-0.05 0.4])
xlim([300 450])


% Compute the standard error of the mean (SEM) for each condition
w_pre_sem = std(w_pre_trialavg, [], 2, 'omitnan') / sqrt(size(w_pre_trialavg, 2));
wo_pre_sem = std(wo_pre_trialavg, [], 2, 'omitnan') / sqrt(size(wo_pre_trialavg, 2));
w_dcz_sem = std(w_dcz_trialavg, [], 2, 'omitnan') / sqrt(size(w_dcz_trialavg, 2));
wo_dcz_sem = std(wo_dcz_trialavg, [], 2, 'omitnan') / sqrt(size(wo_dcz_trialavg, 2));

% Plot w_pre and wo_pre with shaded SEM
figure;
hold on;
% w_pre plot
fill([1:length(w_pre_popavg), fliplr(1:length(w_pre_popavg))], ...
     [w_pre_popavg + w_pre_sem; flipud(w_pre_popavg - w_pre_sem)], ...
     'k', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
plot(w_pre_popavg, 'color', 'k', 'LineWidth', 1.5);

% wo_pre plot
fill([1:length(wo_pre_popavg), fliplr(1:length(wo_pre_popavg))], ...
     [wo_pre_popavg + wo_pre_sem; flipud(wo_pre_popavg - wo_pre_sem)], ...
     [171, 94, 36]/255, 'FaceAlpha', 0.2, 'EdgeColor', 'none');
plot(wo_pre_popavg, 'color', [171, 94, 36]/255, 'LineWidth', 1.5);
ylim([-0.05 0.4]);
xlim([300 450])
hold off;
title('Pre-DCZ');

% Plot w_dcz and wo_dcz with shaded SEM
figure;
hold on;
% w_dcz plot
fill([1:length(w_dcz_popavg), fliplr(1:length(w_dcz_popavg))], ...
     [w_dcz_popavg + w_dcz_sem; flipud(w_dcz_popavg - w_dcz_sem)], ...
     'k', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
plot(w_dcz_popavg, 'color', 'k', 'LineWidth', 1.5);

% wo_dcz plot
fill([1:length(wo_dcz_popavg), fliplr(1:length(wo_dcz_popavg))], ...
     [wo_dcz_popavg + wo_dcz_sem; flipud(wo_dcz_popavg - wo_dcz_sem)], ...
     [171, 94, 36]/255, 'FaceAlpha', 0.2, 'EdgeColor', 'none');
plot(wo_dcz_popavg, 'color', [171, 94, 36]/255, 'LineWidth', 1.5);
ylim([-0.05 0.4]);
xlim([300 450])
hold off;
title('DCZ');



end