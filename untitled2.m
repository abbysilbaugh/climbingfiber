mouse = 19;

temp_data = allData.data{19};

pre_trials = strcmp('PRE', temp_data.tetPeriod) & strcmp('NO DCZ', temp_data.dczPeriod) & strcmp('W', temp_data.trialType);
after_DCZ_trials = strcmp('PRE', temp_data.tetPeriod) & strcmp('DCZ', temp_data.dczPeriod) & strcmp('W', temp_data.trialType);
post_trials = strcmp('POST', temp_data.tetPeriod) & strcmp('W', temp_data.trialType);

PN_cells = strcmp('PN', temp_data.cellType); UC_cells = strcmp('UC', temp_data.cellType);



temp_golayshift_pre = allData.data{19}.golayshift(:, PN_cells, pre_trials);
temp_golayshift_pre_mean = mean(temp_golayshift_pre, 3);
temp_golayshift_pre_sem = std(temp_golayshift_pre, 0, 3, 'omitnan') / sqrt(size(temp_golayshift_pre, 3));

temp_golayshift_after_DCZ = allData.data{19}.golayshift(:, PN_cells, after_DCZ_trials);
temp_golayshift_after_DCZ_mean = mean(temp_golayshift_after_DCZ, 3);
temp_golayshift_after_DCZ_sem = std(temp_golayshift_after_DCZ, 0, 3, 'omitnan') / sqrt(size(temp_golayshift_after_DCZ, 3));

temp_golayshift_post = allData.data{19}.golayshift(:, PN_cells, post_trials);
temp_golayshift_post_mean = mean(temp_golayshift_post, 3);
temp_golayshift_post_sem = std(temp_golayshift_post, 0, 3, 'omitnan') / sqrt(size(temp_golayshift_post, 3));

n_PN_cells = sum(PN_cells);

for i = 1:n_PN_cells
    figure;
    hold on
    plot(temp_golayshift_pre_mean(:, i), 'Color', [0, 0, 0, 0.5], 'LineWidth', 2)
    upperBound = temp_golayshift_pre_mean(:, i) + temp_golayshift_pre_sem(:, i);
    lowerBound = temp_golayshift_pre_mean(:, i) - temp_golayshift_pre_sem(:, i);
    x = 1:length(temp_golayshift_pre_mean(:, i));
    fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], 'k', 'linestyle', 'none', 'FaceAlpha', 0.2);

    plot(temp_golayshift_after_DCZ_mean(:, i), 'Color', [160/277, 189/277, 235/277, 0.5], 'LineWidth', 2)
    upperBound = temp_golayshift_after_DCZ_mean(:, i) + temp_golayshift_after_DCZ_sem(:, i);
    lowerBound = temp_golayshift_after_DCZ_mean(:, i) - temp_golayshift_after_DCZ_sem(:, i);
    x = 1:length(temp_golayshift_after_DCZ_mean(:, i));
    fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], [160/277, 189/277, 235/277], 'linestyle', 'none', 'FaceAlpha', 0.2);

    plot(temp_golayshift_post_mean(:, i), 'Color', [9/277, 49/277, 112/277, 0.5], 'LineWidth', 2)
    upperBound = temp_golayshift_post_mean(:, i) + temp_golayshift_pre_sem(:, i);
    lowerBound = temp_golayshift_post_mean(:, i) - temp_golayshift_pre_sem(:, i);
    x = 1:length(temp_golayshift_post_mean(:, i));
    fill([x, fliplr(x)], [upperBound', fliplr(lowerBound')], [9/277, 49/277, 112/277], 'linestyle', 'none', 'FaceAlpha', 0.2);

    xlim([300, 400])
end


temp_meanfluo_pre = allData.data{19}.mean_fluo_in_win(PN_cells, pre_trials);
temp_meanfluo_after_DCZ = allData.data{19}.mean_fluo_in_win(PN_cells, after_DCZ_trials);
temp_meanfluo_post = allData.data{19}.mean_fluo_in_win(PN_cells, post_trials);

