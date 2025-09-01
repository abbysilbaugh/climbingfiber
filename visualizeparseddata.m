function visualizeparseddata(xlimits, ylimits, stimframe,...
    pre, pre_wo, ...
    RWS_pre, RWS_pre_wo, RWS_post, ...
    RWSCF_pre, RWSCF_pre_wo, RWSCF_post, ...
    RWSCF_PV_JAWS_pre, RWSCF_PV_JAWS_pre_wo, RWSCF_PV_JAWS_post, ...
    control_PV_JAWS_pre, control_PV_JAWS_pre_wo, control_PV_JAWS_post, ...
    RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_wo, RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, ...
    control_PV_Gi_pre, control_PV_Gi_pre_wo, control_PV_Gi_pre_dcz, control_PV_Gi_post, ...
    RWSCF_SST_Gi_pre, RWSCF_SST_Gi_pre_wo, RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, ...
    control_SST_Gi_pre, control_SST_Gi_pre_wo, control_SST_Gi_pre_dcz, control_SST_Gi_post, ...
    RWS_SST_Gq_pre, RWS_SST_Gq_pre_wo, RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, ...
    control_SST_Gq_pre, control_SST_Gq_pre_wo, control_SST_Gq_pre_dcz, control_SST_Gq_post)

neuron_colors = {[187/255, 37/255, 37/255], [34/255, 75/255, 170/255], [10/255, 138/255, 35/255],  [0, 0, 0], [99/255, 63/255, 115/255]};

neuron_names = {'PV', 'PN', 'VIP', 'UC', 'SST'};

figure;
% for i = 1:length(neuron_names)
%     subplot(1, length(neuron_names), i)
%     plot(pre{i}, 'Color', [0.5 0.5 0.5])
%     hold on
%     plot(pre_wo{i}, 'Color', neuron_colors{i})
%     xlim(xlimits)
%     ylim(ylimits)
% end

% PLOT BASIC TRANSMISSION
figure('Position', [50 50 1800 500]);
for i = 1:length(neuron_names)
    getmean_pre = mean(pre{i}, 2, 'omitnan');
    getsem_pre = getmean_pre / sqrt(size(pre{i}, 2));

    getmean_pre_wo = mean(pre_wo{i}, 2, 'omitnan');
    getsem_pre_wo = getmean_pre_wo / sqrt(size(pre_wo{i}, 2));

    subplot(1, length(neuron_names), i)
    plot(getmean_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
    hold on
    fill([1:length(getmean_pre), length(getmean_pre):-1:1], [getmean_pre - getsem_pre; flipud(getmean_pre + getsem_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
    plot(getmean_pre_wo, 'Color', neuron_colors{i}, 'LineWidth', 2)
    fill([1:length(getmean_pre_wo), length(getmean_pre_wo):-1:1], [getmean_pre_wo - getsem_pre_wo; flipud(getmean_pre_wo + getsem_pre_wo)], neuron_colors{i}, 'linestyle', 'none', 'FaceAlpha', 0.5);
    xlim(xlimits)
    title(neuron_names{i})
    ylabel('∆F/F0', 'FontSize', 12)
    xline(stimframe, 'LineWidth', 3)
    xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
    xticklabels([-500 0 500 1000 1500 2000 2500])
    xlabel('msec', 'FontSize', 12)
    legend('W', '', 'W+CF', '', 'Box', 'off', 'FontSize', 12)
end

getmean_RWS_pre = mean(RWS_pre{2}, 2, 'omitnan');
getmean_RWS_post = mean(RWS_post{2}, 2, 'omitnan');

getmean_RWSCF_pre = mean(RWSCF_pre{2}, 2, 'omitnan');
getmean_RWSCF_post = mean(RWSCF_post{2}, 2, 'omitnan');

getmean_RWSCF_PV_JAWS_pre = mean(RWSCF_PV_JAWS_pre{2}, 2, 'omitnan');
getmean_RWSCF_PV_JAWS_post = mean(RWSCF_PV_JAWS_post{2}, 2, 'omitnan');

getmean_control_PV_JAWS_pre = mean(control_PV_JAWS_pre{2}, 2, 'omitnan');
getmean_control_PV_JAWS_post = mean(control_PV_JAWS_post{2}, 2, 'omitnan');

getmean_RWSCF_PV_Gi_pre = mean(RWSCF_PV_Gi_pre{2}, 2, 'omitnan');
getmean_RWSCF_PV_Gi_pre_dcz = mean(RWSCF_PV_Gi_pre_dcz{2}, 2, 'omitnan');
getmean_RWSCF_PV_Gi_post = mean(RWSCF_PV_Gi_post{2}, 2, 'omitnan');

getmean_control_PV_Gi_pre = mean(control_PV_Gi_pre{2}, 2, 'omitnan');
getmean_control_PV_Gi_pre_dcz = mean(control_PV_Gi_pre_dcz{2}, 2, 'omitnan');
getmean_control_PV_Gi_post = mean(control_PV_Gi_post{2}, 2, 'omitnan');

getmean_RWSCF_SST_Gi_pre = mean(RWSCF_SST_Gi_pre{2}, 2, 'omitnan');
getmean_RWSCF_SST_Gi_pre_dcz = mean(RWSCF_SST_Gi_pre_dcz{2}, 2, 'omitnan');
getmean_RWSCF_SST_Gi_post = mean(RWSCF_SST_Gi_post{2}, 2, 'omitnan');

getmean_control_SST_Gi_pre = mean(control_SST_Gi_pre{2}, 2, 'omitnan');
getmean_control_SST_Gi_pre_dcz = mean(control_SST_Gi_pre_dcz{2}, 2, 'omitnan');
getmean_control_SST_Gi_post = mean(control_SST_Gi_post{2}, 2, 'omitnan');

getmean_RWS_SST_Gq_pre = mean(RWS_SST_Gq_pre{2}, 2, 'omitnan');
getmean_RWS_SST_Gq_pre_dcz = mean(RWS_SST_Gq_pre_dcz{2}, 2, 'omitnan');
getmean_RWS_SST_Gq_post = mean(RWS_SST_Gq_post{2}, 2, 'omitnan');

getmean_control_SST_Gq_pre = mean(control_SST_Gq_pre{2}, 2, 'omitnan');
getmean_control_SST_Gq_pre_dcz = mean(control_SST_Gq_pre_dcz{2}, 2, 'omitnan');
getmean_control_SST_Gq_post = mean(control_SST_Gq_post{2}, 2, 'omitnan');

getsem_RWS_pre = mean(RWS_pre{2}, 2, 'omitnan') / sqrt(size(RWS_pre{2}, 2));
getsem_RWS_post = mean(RWS_post{2}, 2, 'omitnan') / sqrt(size(RWS_post{2}, 2));

getsem_RWSCF_pre = mean(RWSCF_pre{2}, 2, 'omitnan') / sqrt(size(RWSCF_pre{2}, 2));
getsem_RWSCF_post = mean(RWSCF_post{2}, 2, 'omitnan') / sqrt(size(RWSCF_post{2}, 2));

getsem_RWSCF_PV_JAWS_pre = mean(RWSCF_PV_JAWS_pre{2}, 2, 'omitnan') / sqrt(size(RWSCF_PV_JAWS_pre{2}, 2));
getsem_RWSCF_PV_JAWS_post = mean(RWSCF_PV_JAWS_post{2}, 2, 'omitnan') / sqrt(size(RWSCF_PV_JAWS_post{2}, 2));

getsem_control_PV_JAWS_pre = mean(control_PV_JAWS_pre{2}, 2, 'omitnan') / sqrt(size(control_PV_JAWS_pre{2}, 2));
getsem_control_PV_JAWS_post = mean(control_PV_JAWS_post{2}, 2, 'omitnan') / sqrt(size(control_PV_JAWS_post{2}, 2));

getsem_RWSCF_PV_Gi_pre = mean(RWSCF_PV_Gi_pre{2}, 2, 'omitnan') / sqrt(size(RWSCF_PV_Gi_pre{2}, 2));
getsem_RWSCF_PV_Gi_pre_dcz = mean(RWSCF_PV_Gi_pre_dcz{2}, 2, 'omitnan') / sqrt(size(RWSCF_PV_Gi_pre_dcz{2}, 2));
getsem_RWSCF_PV_Gi_post = mean(RWSCF_PV_Gi_post{2}, 2, 'omitnan') / sqrt(size(RWSCF_PV_Gi_post{2}, 2));

getsem_control_PV_Gi_pre = mean(control_PV_Gi_pre{2}, 2, 'omitnan') / sqrt(size(control_PV_Gi_pre{2}, 2));
getsem_control_PV_Gi_pre_dcz = mean(control_PV_Gi_pre_dcz{2}, 2, 'omitnan') / sqrt(size(control_PV_Gi_pre_dcz{2}, 2));
getsem_control_PV_Gi_post = mean(control_PV_Gi_post{2}, 2, 'omitnan') / sqrt(size(control_PV_Gi_post{2}, 2));

getsem_RWSCF_SST_Gi_pre = mean(RWSCF_SST_Gi_pre{2}, 2, 'omitnan') / sqrt(size(RWSCF_SST_Gi_pre{2}, 2));
getsem_RWSCF_SST_Gi_pre_dcz = mean(RWSCF_SST_Gi_pre_dcz{2}, 2, 'omitnan') / sqrt(size(RWSCF_SST_Gi_pre_dcz{2}, 2));
getsem_RWSCF_SST_Gi_post = mean(RWSCF_SST_Gi_post{2}, 2, 'omitnan') / sqrt(size(RWSCF_SST_Gi_post{2}, 2));

getsem_control_SST_Gi_pre = mean(control_SST_Gi_pre{2}, 2, 'omitnan') / sqrt(size(control_SST_Gi_pre{2}, 2));
getsem_control_SST_Gi_pre_dcz = mean(control_SST_Gi_pre_dcz{2}, 2, 'omitnan') / sqrt(size(control_SST_Gi_pre_dcz{2}, 2));
getsem_control_SST_Gi_post = mean(control_SST_Gi_post{2}, 2, 'omitnan') / sqrt(size(control_SST_Gi_post{2}, 2));

getsem_RWS_SST_Gq_pre = mean(RWS_SST_Gq_pre{2}, 2, 'omitnan') / sqrt(size(RWS_SST_Gq_pre{2}, 2));
getsem_RWS_SST_Gq_pre_dcz = mean(RWS_SST_Gq_pre_dcz{2}, 2, 'omitnan') / sqrt(size(RWS_SST_Gq_pre_dcz{2}, 2));
getsem_RWS_SST_Gq_post = mean(RWS_SST_Gq_post{2}, 2, 'omitnan') / sqrt(size(RWS_SST_Gq_post{2}, 2));

getsem_control_SST_Gq_pre = mean(control_SST_Gq_pre{2}, 2, 'omitnan') / sqrt(size(control_SST_Gq_pre{2}, 2));
getsem_control_SST_Gq_pre_dcz = mean(control_SST_Gq_pre_dcz{2}, 2, 'omitnan') / sqrt(size(control_SST_Gq_pre_dcz{2}, 2));
getsem_control_SST_Gq_post = mean(control_SST_Gq_post{2}, 2, 'omitnan') / sqrt(size(control_SST_Gq_post{2}, 2));


% PLOT RWS, RWSCF
figure('Position', [50 50 1800 500]);
subplot(1, 2, 1)
plot(getmean_RWS_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
hold on
fill([1:length(getmean_RWS_pre), length(getmean_RWS_pre):-1:1], [getmean_RWS_pre - getsem_RWS_pre; flipud(getmean_RWS_pre + getsem_RWS_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_RWS_post, 'Color', neuron_colors{2}, 'LineWidth', 2)
fill([1:length(getmean_RWS_post), length(getmean_RWS_post):-1:1], [getmean_RWS_post - getsem_RWS_post; flipud(getmean_RWS_post + getsem_RWS_post)], neuron_colors{2}, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('RWS')
ylabel('∆F/F0', 'FontSize', 12)
xline(stimframe, 'LineWidth', 3)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('msec', 'FontSize', 12)
legend('Pre', '', 'Post', '', 'Box', 'off', 'FontSize', 12)
hold off

subplot(1, 2, 2)
plot(getmean_RWSCF_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
hold on
fill([1:length(getmean_RWSCF_pre), length(getmean_RWSCF_pre):-1:1], [getmean_RWSCF_pre - getsem_RWSCF_pre; flipud(getmean_RWSCF_pre + getsem_RWSCF_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_RWSCF_post, 'Color', neuron_colors{2}, 'LineWidth', 2)
fill([1:length(getmean_RWSCF_post), length(getmean_RWSCF_post):-1:1], [getmean_RWSCF_post - getsem_RWSCF_post; flipud(getmean_RWSCF_post + getsem_RWSCF_post)], neuron_colors{2}, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('RWSCF')
ylabel('∆F/F0', 'FontSize', 12)
xline(stimframe, 'LineWidth', 3)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('msec', 'FontSize', 12)
legend('Pre', '', 'Post', '', 'Box', 'off', 'FontSize', 12)
hold off

% PLOT RWSCF JAWS, Control JAWS
figure('Position', [50 50 1800 500]);
subplot(1, 2, 1)
plot(getmean_RWSCF_PV_JAWS_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
hold on
fill([1:length(getmean_RWSCF_PV_JAWS_pre), length(getmean_RWSCF_PV_JAWS_pre):-1:1], [getmean_RWSCF_PV_JAWS_pre - getsem_RWSCF_PV_JAWS_pre; flipud(getmean_RWSCF_PV_JAWS_pre + getsem_RWSCF_PV_JAWS_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_RWSCF_PV_JAWS_post, 'Color', neuron_colors{2}, 'LineWidth', 2)
fill([1:length(getmean_RWSCF_PV_JAWS_post), length(getmean_RWSCF_PV_JAWS_post):-1:1], [getmean_RWSCF_PV_JAWS_post - getsem_RWSCF_PV_JAWS_post; flipud(getmean_RWSCF_PV_JAWS_post + getsem_RWSCF_PV_JAWS_post)], neuron_colors{2}, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('RWSCF PV JAWS')
ylabel('∆F/F0', 'FontSize', 12)
xline(stimframe, 'LineWidth', 3)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('msec', 'FontSize', 12)
legend('Pre', '', 'Post', '', 'Box', 'off', 'FontSize', 12)
hold off

subplot(1, 2, 2)
figure('Position', [50 50 1800 500]);
subplot(1, 2, 1)
plot(getmean_control_PV_JAWS_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
hold on
fill([1:length(getmean_control_PV_JAWS_pre), length(getmean_control_PV_JAWS_pre):-1:1], [getmean_control_PV_JAWS_pre - getsem_control_PV_JAWS_pre; flipud(getmean_control_PV_JAWS_pre + getsem_control_PV_JAWS_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_control_PV_JAWS_post, 'Color', neuron_colors{2}, 'LineWidth', 2)
fill([1:length(getmean_control_PV_JAWS_post), length(getmean_control_PV_JAWS_post):-1:1], [getmean_control_PV_JAWS_post - getsem_control_PV_JAWS_post; flipud(getmean_control_PV_JAWS_post + getsem_control_PV_JAWS_post)], neuron_colors{2}, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('PV JAWS')
ylabel('∆F/F0', 'FontSize', 12)
xline(stimframe, 'LineWidth', 3)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('msec', 'FontSize', 12)
legend('Pre', '', 'Post', '', 'Box', 'off', 'FontSize', 12)
hold off

% PLOT RWSCF PVCre Gi and Control PVCre Gi
figure('Position', [50 50 1800 500]);
subplot(1, 2, 1)
plot(getmean_RWSCF_PV_Gi_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2, 'LineStyle', ':')
hold on
fill([1:length(getmean_RWSCF_PV_Gi_pre), length(getmean_RWSCF_PV_Gi_pre):-1:1], [getmean_RWSCF_PV_Gi_pre - getsem_RWSCF_PV_Gi_pre; flipud(getmean_RWSCF_PV_Gi_pre + getsem_RWSCF_PV_Gi_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_RWSCF_PV_Gi_pre_dcz, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
fill([1:length(getmean_RWSCF_PV_Gi_pre_dcz), length(getmean_RWSCF_PV_Gi_pre_dcz):-1:1], [getmean_RWSCF_PV_Gi_pre_dcz - getsem_RWSCF_PV_Gi_pre_dcz; flipud(getmean_RWSCF_PV_Gi_pre_dcz + getsem_RWSCF_PV_Gi_pre_dcz)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_RWSCF_PV_Gi_post, 'Color', neuron_colors{2}, 'LineWidth', 2)
fill([1:length(getmean_RWSCF_PV_Gi_post), length(getmean_RWSCF_PV_Gi_post):-1:1], [getmean_RWSCF_PV_Gi_post - getsem_RWSCF_PV_Gi_post; flipud(getmean_RWSCF_PV_Gi_post + getsem_RWSCF_PV_Gi_post)], neuron_colors{2}, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('RWSCF + PV Inhibition')
ylabel('∆F/F0', 'FontSize', 12)
xline(stimframe, 'LineWidth', 3)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('msec', 'FontSize', 12)
legend('Pre', '', 'Pre (DCZ)', '', 'Post', '', 'Box', 'off', 'FontSize', 12)
hold off

subplot(1, 2, 2)
plot(getmean_control_PV_Gi_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2, 'LineStyle', ':')
hold on
fill([1:length(getmean_control_PV_Gi_pre), length(getmean_control_PV_Gi_pre):-1:1], [getmean_control_PV_Gi_pre - getsem_control_PV_Gi_pre; flipud(getmean_control_PV_Gi_pre + getsem_control_PV_Gi_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_control_PV_Gi_pre_dcz, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
fill([1:length(getmean_control_PV_Gi_pre_dcz), length(getmean_control_PV_Gi_pre_dcz):-1:1], [getmean_control_PV_Gi_pre_dcz - getsem_control_PV_Gi_pre_dcz; flipud(getmean_control_PV_Gi_pre_dcz + getsem_control_PV_Gi_pre_dcz)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_control_PV_Gi_post, 'Color', neuron_colors{2}, 'LineWidth', 2)
fill([1:length(getmean_control_PV_Gi_post), length(getmean_control_PV_Gi_post):-1:1], [getmean_control_PV_Gi_post - getsem_control_PV_Gi_post; flipud(getmean_control_PV_Gi_post + getsem_control_PV_Gi_post)], neuron_colors{2}, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('PV Inhibition')
ylabel('∆F/F0', 'FontSize', 12)
xline(stimframe, 'LineWidth', 3)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('msec', 'FontSize', 12)
legend('Pre', '', 'DCZ', '', 'Post (Control)', '', 'Box', 'off', 'FontSize', 12)
hold off

% PLOT RWSCF SSTCre Gi and Control SSTCre Gi
figure('Position', [50 50 1800 500]);
subplot(1, 2, 1)
plot(getmean_RWSCF_SST_Gi_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2, 'LineStyle', ':')
hold on
fill([1:length(getmean_RWSCF_SST_Gi_pre), length(getmean_RWSCF_SST_Gi_pre):-1:1], [getmean_RWSCF_SST_Gi_pre - getsem_RWSCF_SST_Gi_pre; flipud(getmean_RWSCF_SST_Gi_pre + getsem_RWSCF_SST_Gi_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_RWSCF_SST_Gi_pre_dcz, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
fill([1:length(getmean_RWSCF_SST_Gi_pre_dcz), length(getmean_RWSCF_SST_Gi_pre_dcz):-1:1], [getmean_RWSCF_SST_Gi_pre_dcz - getsem_RWSCF_SST_Gi_pre_dcz; flipud(getmean_RWSCF_SST_Gi_pre_dcz + getsem_RWSCF_SST_Gi_pre_dcz)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_RWSCF_SST_Gi_post, 'Color', neuron_colors{2}, 'LineWidth', 2)
fill([1:length(getmean_RWSCF_SST_Gi_post), length(getmean_RWSCF_SST_Gi_post):-1:1], [getmean_RWSCF_SST_Gi_post - getsem_RWSCF_SST_Gi_post; flipud(getmean_RWSCF_SST_Gi_post + getsem_RWSCF_SST_Gi_post)], neuron_colors{2}, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('RWSCF + SST Inhibition')
ylabel('∆F/F0', 'FontSize', 12)
xline(stimframe, 'LineWidth', 3)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('msec', 'FontSize', 12)
legend('Pre', '', 'Pre (DCZ)', '', 'Post', '', 'Box', 'off', 'FontSize', 12)
hold off

subplot(1, 2, 2)
plot(getmean_control_SST_Gi_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2, 'LineStyle', ':')
hold on
fill([1:length(getmean_control_SST_Gi_pre), length(getmean_control_SST_Gi_pre):-1:1], [getmean_control_SST_Gi_pre - getsem_control_SST_Gi_pre; flipud(getmean_control_SST_Gi_pre + getsem_control_SST_Gi_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_control_SST_Gi_pre_dcz, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
fill([1:length(getmean_control_SST_Gi_pre_dcz), length(getmean_control_SST_Gi_pre_dcz):-1:1], [getmean_control_SST_Gi_pre_dcz - getsem_control_SST_Gi_pre_dcz; flipud(getmean_control_SST_Gi_pre_dcz + getsem_control_SST_Gi_pre_dcz)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_control_SST_Gi_post, 'Color', neuron_colors{2}, 'LineWidth', 2)
fill([1:length(getmean_control_SST_Gi_post), length(getmean_control_SST_Gi_post):-1:1], [getmean_control_SST_Gi_post - getsem_control_SST_Gi_post; flipud(getmean_control_SST_Gi_post + getsem_control_SST_Gi_post)], neuron_colors{2}, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('SST Inhibition')
ylabel('∆F/F0', 'FontSize', 12)
xline(stimframe, 'LineWidth', 3)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('msec', 'FontSize', 12)
legend('Pre', '', 'DCZ', '', 'Post (Control)', '', 'Box', 'off', 'FontSize', 12)
hold off

% PLOT RWS SSTCre Gq and Control SSTCre Gq
figure('Position', [50 50 1800 500]);
subplot(1, 2, 1)
plot(getmean_RWS_SST_Gq_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2, 'LineStyle', ':')
hold on
fill([1:length(getmean_RWS_SST_Gq_pre), length(getmean_RWS_SST_Gq_pre):-1:1], [getmean_RWS_SST_Gq_pre - getsem_RWS_SST_Gq_pre; flipud(getmean_RWS_SST_Gq_pre + getsem_RWS_SST_Gq_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_RWS_SST_Gq_pre_dcz, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
fill([1:length(getmean_RWS_SST_Gq_pre_dcz), length(getmean_RWS_SST_Gq_pre_dcz):-1:1], [getmean_RWS_SST_Gq_pre_dcz - getsem_RWS_SST_Gq_pre_dcz; flipud(getmean_RWS_SST_Gq_pre_dcz + getsem_RWS_SST_Gq_pre_dcz)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_RWS_SST_Gq_post, 'Color', neuron_colors{2}, 'LineWidth', 2)
fill([1:length(getmean_RWS_SST_Gq_post), length(getmean_RWS_SST_Gq_post):-1:1], [getmean_RWS_SST_Gq_post - getsem_RWS_SST_Gq_post; flipud(getmean_RWS_SST_Gq_post + getsem_RWSCF_SST_Gi_post)], neuron_colors{2}, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('RWS + SST Activation')
ylabel('∆F/F0', 'FontSize', 12)
xline(stimframe, 'LineWidth', 3)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('msec', 'FontSize', 12)
legend('Pre', '', 'DCZ', '', 'Post', '', 'Box', 'off', 'FontSize', 12)
hold off

subplot(1, 2, 2)
plot(getmean_control_SST_Gq_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2, 'LineStyle', ':')
hold on
fill([1:length(getmean_control_SST_Gq_pre), length(getmean_control_SST_Gq_pre):-1:1], [getmean_control_SST_Gq_pre - getsem_control_SST_Gq_pre; flipud(getmean_control_SST_Gq_pre + getsem_control_SST_Gq_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_control_SST_Gq_pre_dcz, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
fill([1:length(getmean_control_SST_Gq_pre_dcz), length(getmean_control_SST_Gq_pre_dcz):-1:1], [getmean_control_SST_Gq_pre_dcz - getsem_control_SST_Gq_pre_dcz; flipud(getmean_control_SST_Gq_pre_dcz + getsem_control_SST_Gq_pre_dcz)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_control_SST_Gq_post, 'Color', neuron_colors{2}, 'LineWidth', 2)
fill([1:length(getmean_control_SST_Gq_post), length(getmean_control_SST_Gq_post):-1:1], [getmean_control_SST_Gq_post - getsem_control_SST_Gq_post; flipud(getmean_control_SST_Gq_post + getsem_control_SST_Gq_post)], neuron_colors{2}, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('SST Activation')
ylabel('∆F/F0', 'FontSize', 12)
xline(stimframe, 'LineWidth', 3)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('msec', 'FontSize', 12)
legend('Pre', '', 'DCZ', '', 'Post (Control)', '', 'Box', 'off', 'FontSize', 12)
hold off

% figure;
% plot(getmean_RWSCF_PV_Gi_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
% hold on
% fill([1:length(getmean_RWSCF_PV_Gi_pre), length(getmean_RWSCF_PV_Gi_pre):-1:1], [getmean_RWSCF_PV_Gi_pre - getsem_RWSCF_PV_Gi_pre; flipud(getmean_RWSCF_PV_Gi_pre + getsem_RWSCF_PV_Gi_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
% plot(getmean_RWSCF_PV_Gi_pre_dcz, 'Color', [0 0 0], 'LineWidth', 2)
% fill([1:length(getmean_RWSCF_PV_Gi_pre_dcz), length(getmean_RWSCF_PV_Gi_pre_dcz):-1:1], [getmean_RWSCF_PV_Gi_pre_dcz - getsem_RWSCF_PV_Gi_pre_dcz; flipud(getmean_RWSCF_PV_Gi_pre_dcz + getsem_RWSCF_PV_Gi_pre_dcz)], [0 0 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
% plot(getmean_RWSCF_PV_Gi_post, 'Color', neuron_colors{2}, 'LineWidth', 2)
% fill([1:length(getmean_RWSCF_PV_Gi_post), length(getmean_RWSCF_PV_Gi_post):-1:1], [getmean_RWSCF_PV_Gi_post - getsem_RWSCF_PV_Gi_post; flipud(getmean_RWSCF_PV_Gi_post + getsem_RWSCF_PV_Gi_post)], neuron_colors{2}, 'linestyle', 'none', 'FaceAlpha', 0.5);
% xlim([300 (289.5+46.5)])
% ylim(ylimits)
% title('RWSCF + PV Inhibition')
% ylabel('∆F/F0', 'FontSize', 12)
% xline(stimframe, 'LineWidth', 3)
% xticks([0, 15.5, 31, 46.5]+289.5 - 2)
% xticklabels([-500 0 500 1000])
% xlabel('msec', 'FontSize', 12)
% legend('Pre', '', 'Post', '', 'Box', 'off', 'FontSize', 12)

end