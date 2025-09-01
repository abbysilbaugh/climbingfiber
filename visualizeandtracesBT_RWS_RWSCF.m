% Note: will only work on trialavg = 1 & catmouse = 1 OR trialavg = 1 & cellavg = 1 & catmouse = 1

function [RWS_pre, RWS_pre_wo, RWS_post, RWSCF_pre, RWSCF_pre_wo, RWSCF_post, pre_cat, pre_wo_cat] = visualizeandtracesBT_RWS_RWSCF(neuron_colors, xlimits, ylimits, stimframe,...
    RWS_pre, RWS_pre_wo, RWS_post, ...
    RWSCF_pre, RWSCF_pre_wo, RWSCF_post, showtraces)

neuron_names = {'PV', 'PN', 'VIP', 'UC', 'SST'};

% Find neurons with evoked events in relevant conditions
for i = 1:length(neuron_names)

        RWS_pre_selected = RWS_pre{i};
        RWS_pre_wo_selected = RWS_pre_wo{i};
        RWS_post_selected = RWS_post{i};
        RWSCF_pre_selected = RWSCF_pre{i};
        RWSCF_pre_wo_selected = RWSCF_pre_wo{i};
        RWSCF_post_selected = RWSCF_post{i};
        
        find_RWS = ~isnan(RWS_pre_selected(1, :)) & ~isnan(RWS_pre_wo_selected(1,:)); % & ~isnan(RWS_post_selected(1,:));
        find_RWSCF = ~isnan(RWSCF_pre_selected(1, :))  & ~isnan(RWSCF_pre_wo_selected(1,:)); % & ~isnan(RWSCF_post_selected(1,:));
        
        RWS_pre_selected = RWS_pre_selected(:, find_RWS);
        RWS_pre_wo_selected = RWS_pre_wo_selected(:, find_RWS);
        RWS_post_selected = RWS_post_selected(:, find_RWS);
        RWSCF_pre_selected = RWSCF_pre_selected(:, find_RWSCF);
        RWSCF_pre_wo_selected = RWSCF_pre_wo_selected(:, find_RWSCF);
        RWSCF_post_selected = RWSCF_post_selected(:, find_RWSCF);
        
        RWS_pre{i} = RWS_pre_selected;
        RWS_pre_wo{i} = RWS_pre_wo_selected;
        RWS_post{i} = RWS_post_selected;
        RWSCF_pre{i} = RWSCF_pre_selected;
        RWSCF_pre_wo{i} = RWSCF_pre_wo_selected;
        RWSCF_post{i} = RWSCF_post_selected;
        
        
        getmean_RWS_pre = mean(RWS_pre_selected, 2, 'omitnan');
        getmean_RWS_pre_wo = mean(RWS_pre_wo_selected, 2, 'omitnan');
        getmean_RWS_post = mean(RWS_post_selected, 2, 'omitnan');
        
        getmean_RWSCF_pre = mean(RWSCF_pre_selected, 2, 'omitnan');
        getmean_RWSCF_pre_wo = mean(RWSCF_pre_wo_selected, 2, 'omitnan');
        getmean_RWSCF_post = mean(RWSCF_post_selected, 2, 'omitnan');
        
        getsem_RWS_pre = mean(RWS_pre_selected, 2, 'omitnan') / sqrt(size(RWS_pre_selected, 2));
        getsem_RWS_pre_wo = mean(RWS_pre_wo_selected, 2, 'omitnan') / sqrt(size(RWS_pre_wo_selected, 2));
        getsem_RWS_post = mean(RWS_post_selected, 2, 'omitnan') / sqrt(size(RWS_post_selected, 2));
        
        getsem_RWSCF_pre = mean(RWSCF_pre_selected, 2, 'omitnan') / sqrt(size(RWSCF_pre_selected, 2));
        getsem_RWSCF_pre_wo = mean(RWSCF_pre_wo_selected, 2, 'omitnan') / sqrt(size(RWSCF_pre_wo_selected, 2));
        getsem_RWSCF_post = mean(RWSCF_post_selected, 2, 'omitnan') / sqrt(size(RWSCF_post_selected, 2));


        % PLOT W, W+CF (separate RWS, RWSCF)
        if strcmp(showtraces, 'yesplot')
            figure('Position', [50 50 900 500]);
            subplot(1, 2, 1)
            plot(getmean_RWS_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5)
            hold on
            set(gca, 'FontSize', 7)
            fill([1:length(getmean_RWS_pre), length(getmean_RWS_pre):-1:1], [getmean_RWS_pre - getsem_RWS_pre; flipud(getmean_RWS_pre + getsem_RWS_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
            plot(getmean_RWS_pre_wo, 'Color', neuron_colors{i}, 'LineWidth', 0.5)
            fill([1:length(getmean_RWS_pre_wo), length(getmean_RWS_pre_wo):-1:1], [getmean_RWS_pre_wo - getsem_RWS_pre_wo; flipud(getmean_RWS_pre_wo + getsem_RWS_pre_wo)], neuron_colors{i}, 'linestyle', 'none', 'FaceAlpha', 0.5);
            xlim(xlimits)
            ylim(ylimits)
            title('RWS')
            ylabel('∆F/F0')
            line([stimframe, stimframe], [-0.05 ylimits(2)], 'Color', 'k', 'LineWidth', 1)
            xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
            xticklabels([-500 0 500 1000 1500 2000 2500])
            xlabel('ms')
            %legend('Pre', '', 'Post', '', 'Box', 'off')
            %ylim([ylimits(1), max(getmean_RWS_pre)*2.75])
            box off
            hold off
            
            subplot(1, 2, 2)
            plot(getmean_RWSCF_pre, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5)
            hold on
            set(gca, 'FontSize', 7)
            fill([1:length(getmean_RWSCF_pre), length(getmean_RWSCF_pre):-1:1], [getmean_RWSCF_pre - getsem_RWSCF_pre; flipud(getmean_RWSCF_pre + getsem_RWSCF_pre)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
            plot(getmean_RWSCF_pre_wo, 'Color', neuron_colors{i}, 'LineWidth', 0.5)
            fill([1:length(getmean_RWSCF_pre_wo), length(getmean_RWSCF_pre_wo):-1:1], [getmean_RWSCF_pre_wo - getsem_RWSCF_pre_wo; flipud(getmean_RWSCF_pre_wo + getsem_RWSCF_pre_wo)], neuron_colors{i}, 'linestyle', 'none', 'FaceAlpha', 0.5);
            xlim(xlimits)
            ylim(ylimits)
            title('RWSCF')
            ylabel('∆F/F0')
            line([stimframe, stimframe], [-0.05 ylimits(2)], 'Color', 'k', 'LineWidth', 1)
            xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
            xticklabels([-500 0 500 1000 1500 2000 2500])
            xlabel('ms')
            %legend('Pre', '', 'Post', '', 'Box', 'off')
            %ylim([ylimits(1), max(getmean_RWSCF_pre)*2.75])
            box off
            hold off
        end

% PLOT W, W+CF (compile RWS, RWSCF)
pre_cat_selected = cat(2, RWS_pre_selected, RWSCF_pre_selected);
pre_wo_cat_selected = cat(2, RWS_pre_wo_selected, RWSCF_pre_wo_selected);

pre_cat{i} = pre_cat_selected;
pre_wo_cat{i} = pre_wo_cat_selected;

getmean_pre_cat = mean(pre_cat_selected, 2, 'omitnan');
getmean_pre_wo_cat = mean(pre_wo_cat_selected, 2, 'omitnan');

getsem_pre_cat = mean(pre_cat_selected, 2, 'omitnan') / sqrt(size(pre_cat_selected, 2));
getsem_pre_wo_cat = mean(pre_cat_selected, 2, 'omitnan') / sqrt(size(pre_wo_cat_selected, 2));

figure('Position', [733,240,242,500]);
plot(getmean_pre_cat, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5)
hold on
set(gca, 'FontSize', 12)
fill([1:length(getmean_pre_cat), length(getmean_pre_cat):-1:1], [getmean_pre_cat - getsem_pre_cat; flipud(getmean_pre_cat + getsem_pre_cat)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
plot(getmean_pre_wo_cat, 'Color', [50, 164, 168]/255, 'LineWidth', 0.5)
fill([1:length(getmean_pre_wo_cat), length(getmean_pre_wo_cat):-1:1], [getmean_pre_wo_cat - getsem_pre_wo_cat; flipud(getmean_pre_wo_cat + getsem_pre_wo_cat)], [50, 164, 168]/255, 'linestyle', 'none', 'FaceAlpha', 0.5);
xlim(xlimits)
ylim(ylimits)
title('BT')
ylabel('∆F/F0')
line([stimframe, stimframe], [-0.05 ylimits(2)], 'Color', 'k', 'LineWidth', 1)
xticks([0, 15.5, 31, 46.5, 62, 77.5, 93]+289.5)
xticklabels([-500 0 500 1000 1500 2000 2500])
xlabel('ms')
%ylim([ylimits(1), max(getmean_RWS_pre)*2.75])
box off
hold off

end

end