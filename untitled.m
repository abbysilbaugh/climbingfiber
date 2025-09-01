tempdata = allData.data{2};

trialType = tempdata.trialType;
cellType = tempdata.cellType;
PN = strcmp(cellType, 'PN');
UC = strcmp(cellType, 'UC');

w_trials = strcmp(trialType, 'W');
wo_trials = strcmp(trialType, 'WO');

dczPeriod = tempdata.dczPeriod;

w_pre = w_trials & strcmp(dczPeriod, 'NO DCZ');
wo_pre = wo_trials & strcmp(dczPeriod, 'NO DCZ');
w_dcz = w_trials & strcmp(dczPeriod, 'DCZ');
wo_dcz = wo_trials & strcmp(dczPeriod, 'DCZ');

%signal = tempdata.evokedtraces(:, PN, :);
signal = tempdata.evokedtraces;

w_pre = signal(:, :, w_pre);
wo_pre = signal(:, :, wo_pre);
w_dcz = signal(:, :, w_dcz);
wo_dcz = signal(:, :, wo_dcz);

w_pre_trialavg = mean(w_pre, 3, 'omitnan');
wo_pre_trialavg = mean(wo_pre, 3, 'omitnan');
w_dcz_trialavg = mean(w_dcz, 3, 'omitnan');
wo_dcz_trialavg = mean(wo_dcz, 3, 'omitnan');

w_pre_cellavg = mean(w_pre_trialavg, 2, 'omitnan');
wo_pre_cellavg = mean(wo_pre_trialavg, 2, 'omitnan');
w_dcz_cellavg = mean(w_dcz_trialavg, 2, 'omitnan');
wo_dcz_cellavg = mean(wo_dcz_trialavg, 2, 'omitnan');

w_pre_cellavg_shift = w_pre_cellavg - mean(w_pre_cellavg(300:310));
wo_pre_cellavg_shift = wo_pre_cellavg - mean(wo_pre_cellavg(300:310));
w_dcz_cellavg_shift = w_dcz_cellavg - mean(w_dcz_cellavg(300:310));
wo_dcz_cellavg_shift = wo_dcz_cellavg - mean(wo_dcz_cellavg(300:310));


figure;
plot(w_pre_trialavg, 'color', 'k')
hold on
plot(wo_pre_trialavg, 'color', [171, 94, 36, 255]/255)

figure;
plot(w_dcz_trialavg, 'color', 'k')
hold on
plot(wo_dcz_trialavg, 'color', [171, 94, 36, 255]/255)

figure;
plot(w_pre_cellavg_shift, 'color', 'k')
hold on
plot(wo_pre_cellavg_shift, 'color', [171, 94, 36, 255]/255)
ylim([-0.05 0.4])
xlim([300 450])

figure;
plot(w_dcz_cellavg_shift, 'color', 'k')
hold on
plot(wo_dcz_cellavg_shift, 'color', [171, 94, 36, 255]/255)
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
fill([1:length(w_pre_cellavg_shift), fliplr(1:length(w_pre_cellavg_shift))], ...
     [w_pre_cellavg_shift + w_pre_sem; flipud(w_pre_cellavg_shift - w_pre_sem)], ...
     'k', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
plot(w_pre_cellavg_shift, 'color', 'k', 'LineWidth', 1.5);

% wo_pre plot
fill([1:length(wo_pre_cellavg_shift), fliplr(1:length(wo_pre_cellavg_shift))], ...
     [wo_pre_cellavg_shift + wo_pre_sem; flipud(wo_pre_cellavg_shift - wo_pre_sem)], ...
     [171, 94, 36]/255, 'FaceAlpha', 0.2, 'EdgeColor', 'none');
plot(wo_pre_cellavg_shift, 'color', [171, 94, 36]/255, 'LineWidth', 1.5);
ylim([-0.05 0.4]);
xlim([300 450])
hold off;
title('Pre-DCZ');

% Plot w_dcz and wo_dcz with shaded SEM
figure;
hold on;
% w_dcz plot
fill([1:length(w_dcz_cellavg_shift), fliplr(1:length(w_dcz_cellavg_shift))], ...
     [w_dcz_cellavg_shift + w_dcz_sem; flipud(w_dcz_cellavg_shift - w_dcz_sem)], ...
     'k', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
plot(w_dcz_cellavg_shift, 'color', 'k', 'LineWidth', 1.5);

% wo_dcz plot
fill([1:length(wo_dcz_cellavg_shift), fliplr(1:length(wo_dcz_cellavg_shift))], ...
     [wo_dcz_cellavg_shift + wo_dcz_sem; flipud(wo_dcz_cellavg_shift - wo_dcz_sem)], ...
     [171, 94, 36]/255, 'FaceAlpha', 0.2, 'EdgeColor', 'none');
plot(wo_dcz_cellavg_shift, 'color', [171, 94, 36]/255, 'LineWidth', 1.5);
ylim([-0.05 0.4]);
xlim([300 450])
hold off;
title('DCZ');

