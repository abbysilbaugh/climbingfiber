% Note: will only work on trialavg = 1 & catmouse = 1 OR trialavg = 1 & cellavg = 1 & catmouse = 1

function visualizeparsedtraces_INs_RWS_RWSCF(neuron_colors, xlimits, ylimits, stimframe,...
    RWS_pre, RWS_pre_wo, RWS_post, ...
    RWSCF_pre, RWSCF_pre_wo, RWSCF_post)

neuron_names = {'PV', 'PN', 'VIP', 'UC', 'SST'};

for i = 1:length(neuron_names)

getmean_RWS_pre = mean(RWS_pre{i}, 2, 'omitnan');
getmean_RWS_post = mean(RWS_post{i}, 2, 'omitnan');

getmean_RWSCF_pre = mean(RWSCF_pre{i}, 2, 'omitnan');
getmean_RWSCF_post = mean(RWSCF_post{i}, 2, 'omitnan');

getsem_RWS_pre = mean(RWS_pre{i}, 2, 'omitnan') / sqrt(size(RWS_pre{i}, 2));
getsem_RWS_post = mean(RWS_post{i}, 2, 'omitnan') / sqrt(size(RWS_post{i}, 2));

getsem_RWSCF_pre = mean(RWSCF_pre{i}, 2, 'omitnan') / sqrt(size(RWSCF_pre{i}, 2));
getsem_RWSCF_post = mean(RWSCF_post{i}, 2, 'omitnan') / sqrt(size(RWSCF_post{i}, 2));


% PLOT RWS, RWSCF
figure('Position', [50 50 900 500]);
subplot(1, 2, 1)
plot(getmean_RWS_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
hold on
set(gca, 'FontSize', 15)
fill([1:length(getmean_RWS_pre), length(getmean_RWS_pre):-1:1], [getmean_RWS_pre - getsem_RWS_pre; flipud(getmean_RWS_pre + getsem_RWS_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_RWS_post, 'Color', neuron_colors{i}, 'LineWidth', 2)
fill([1:length(getmean_RWS_post), length(getmean_RWS_post):-1:1], [getmean_RWS_post - getsem_RWS_post; flipud(getmean_RWS_post + getsem_RWS_post)], neuron_colors{i}, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('RWS')
ylabel('∆F/F0')
line([stimframe, stimframe], [-0.05 ylimits(2)], 'Color', 'k', 'LineWidth', 3)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('ms')
legend('Pre', '', 'Post', '', 'Box', 'off')
%ylim([ylimits(1), max(getmean_RWS_pre)*2.75])
hold off

subplot(1, 2, 2)
plot(getmean_RWSCF_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
hold on
set(gca, 'FontSize', 15)
fill([1:length(getmean_RWSCF_pre), length(getmean_RWSCF_pre):-1:1], [getmean_RWSCF_pre - getsem_RWSCF_pre; flipud(getmean_RWSCF_pre + getsem_RWSCF_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_RWSCF_post, 'Color', neuron_colors{i}, 'LineWidth', 2)
fill([1:length(getmean_RWSCF_post), length(getmean_RWSCF_post):-1:1], [getmean_RWSCF_post - getsem_RWSCF_post; flipud(getmean_RWSCF_post + getsem_RWSCF_post)], neuron_colors{i}, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('RWSCF')
ylabel('∆F/F0')
line([stimframe, stimframe], [-0.05 ylimits(2)], 'Color', 'k', 'LineWidth', 3)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('ms')
legend('Pre', '', 'Post', '', 'Box', 'off')
%ylim([ylimits(1), max(getmean_RWSCF_pre)*2.75])
hold off

end

end