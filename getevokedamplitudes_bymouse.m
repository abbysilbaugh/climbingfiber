function getevokedamplitudes_bymouse(mottype, allData, tracetype, BT_mice, RWS_mice, RWSCF_mice, RWSCF_PV_JAWS_mice, control_PV_JAWS_mice, RWSCF_PV_Gi_mice, control_PV_Gi_mice, RWSCF_SST_Gi_mice, control_SST_Gi_mice, RWS_SST_Gq_mice, control_SST_Gq_mice, norm)

celltypes = {'PV', 'PN', 'VIP', 'UC', 'SST'};

baselineshiftperiod = [300, 305];
baselineshift = 0;
baseline_reject_thresh = 0.5;
trialavg = true;
cellavg = true;
catmouse = true;

[pre, pre_wo, ...
    RWS_pre, RWS_pre_wo, RWS_post, ...
    RWSCF_pre, RWSCF_pre_wo, RWSCF_post, ...
    RWSCF_PV_JAWS_pre, RWSCF_PV_JAWS_pre_wo, RWSCF_PV_JAWS_post, ...
    control_PV_JAWS_pre, control_PV_JAWS_pre_wo, control_PV_JAWS_post, ...
    RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_wo, RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, ...
    control_PV_Gi_pre, control_PV_Gi_pre_wo, control_PV_Gi_pre_dcz, control_PV_Gi_post, ...
    RWSCF_SST_Gi_pre, RWSCF_SST_Gi_pre_wo, RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, ...
    control_SST_Gi_pre, control_SST_Gi_pre_wo, control_SST_Gi_pre_dcz, control_SST_Gi_post, ... 
    RWS_SST_Gq_pre, RWS_SST_Gq_pre_wo, RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, ...
    control_SST_Gq_pre, control_SST_Gq_pre_wo, control_SST_Gq_pre_dcz, control_SST_Gq_post]...
    = parsetraces(baselineshiftperiod, baselineshift, baseline_reject_thresh, trialavg,...
    cellavg, catmouse, mottype, allData, tracetype, BT_mice, RWS_mice, RWSCF_mice, RWSCF_PV_JAWS_mice, control_PV_JAWS_mice, RWSCF_PV_Gi_mice, control_PV_Gi_mice, RWSCF_SST_Gi_mice, control_SST_Gi_mice, RWS_SST_Gq_mice, control_SST_Gq_mice);

% FIND AMPS FROM TRIAL-AVERAGED AND CELL-AVERAGED (WITHIN MICE) TRACES
pre = calculateamps(pre);
pre_wo = calculateamps(pre_wo);

RWS_pre = calculateamps(RWS_pre);
%RWS_pre_wo = calculateamps(RWS_pre_wo);
RWS_post = calculateamps(RWS_post);

RWSCF_pre = calculateamps(RWSCF_pre);
%RWSCF_pre_wo = calculateamps(RWSCF_pre_wo);
RWSCF_post = calculateamps(RWSCF_post);

RWSCF_PV_JAWS_pre = calculateamps(RWSCF_PV_JAWS_pre);
%RWSCF_PV_JAWS_pre_wo = calculateamps(RWSCF_PV_JAWS_pre_wo);
RWSCF_PV_JAWS_post = calculateamps(RWSCF_PV_JAWS_post);

control_PV_JAWS_pre = calculateamps(control_PV_JAWS_pre);
%control_PV_JAWS_pre_wo = calculateamps(control_PV_JAWS_pre_wo);
control_PV_JAWS_post = calculateamps(control_PV_JAWS_post);

RWSCF_PV_Gi_pre = calculateamps(RWSCF_PV_Gi_pre);
%RWSCF_PV_Gi_pre_wo = calculateamps(RWSCF_PV_Gi_pre_wo);
RWSCF_PV_Gi_pre_dcz = calculateamps(RWSCF_PV_Gi_pre_dcz);
RWSCF_PV_Gi_post = calculateamps(RWSCF_PV_Gi_post);

control_PV_Gi_pre = calculateamps(control_PV_Gi_pre);
%control_PV_Gi_pre_wo = calculateamps(control_PV_Gi_pre_wo);
control_PV_Gi_pre_dcz = calculateamps(control_PV_Gi_pre_dcz);
control_PV_Gi_post = calculateamps(control_PV_Gi_post);

RWSCF_SST_Gi_pre = calculateamps(RWSCF_SST_Gi_pre);
%RWSCF_SST_Gi_pre_wo = calculateamps(RWSCF_SST_Gi_pre_wo);
RWSCF_SST_Gi_pre_dcz = calculateamps(RWSCF_SST_Gi_pre_dcz);
RWSCF_SST_Gi_post = calculateamps(RWSCF_SST_Gi_post);

control_SST_Gi_pre = calculateamps(control_SST_Gi_pre);
%control_SST_Gi_pre_wo = calculateamps(control_SST_Gi_pre_wo);
control_SST_Gi_pre_dcz = calculateamps(control_SST_Gi_pre_dcz);
control_SST_Gi_post = calculateamps(control_SST_Gi_post);

RWS_SST_Gq_pre = calculateamps(RWS_SST_Gq_pre);
%RWS_SST_Gq_pre_wo = calculateamps(RWS_SST_Gq_pre_wo);
RWS_SST_Gq_pre_dcz = calculateamps(RWS_SST_Gq_pre_dcz);
RWS_SST_Gq_post = calculateamps(RWS_SST_Gq_post);

control_SST_Gq_pre = calculateamps(control_SST_Gq_pre);
%control_SST_Gq_pre_wo = calculateamps(control_SST_Gq_pre_wo);
control_SST_Gq_pre_dcz = calculateamps(control_SST_Gq_pre_dcz);
control_SST_Gq_post = calculateamps(control_SST_Gq_post);

% PLOT MOUSE DATA
    for i = 1:length(celltypes)
        cells_plot2cond(pre, pre_wo, celltypes{i}, 'W', 'W+CF', 'BT', norm)
        cells_plot2cond_bar(pre, pre_wo, celltypes{i}, 'W', 'W+CF', 'BT')
    end
    
    for i = 1:length(celltypes)
        cells_plot2cond(RWS_pre, RWS_post, celltypes{i}, 'PRE', 'POST', 'RWS', norm)
        cells_plot2cond_bar(RWS_pre, RWS_post, celltypes{i}, 'PRE', 'POST', 'RWS')
    end
    
    for i = 1:length(celltypes)
        cells_plot2cond(RWSCF_pre, RWSCF_post, celltypes{i}, 'PRE', 'POST', 'RWSCF', norm)
        cells_plot2cond_bar(RWSCF_pre, RWSCF_post, celltypes{i}, 'PRE', 'POST', 'RWSCF')
    end
    
    for i = [1, 2, 4]
        cells_plot2cond(RWSCF_PV_JAWS_pre, RWSCF_PV_JAWS_post, celltypes{i}, 'PRE', 'POST', 'RWSCF - PV (JAWS)', norm)
        cells_plot2cond_bar(RWSCF_PV_JAWS_pre, RWSCF_PV_JAWS_post, celltypes{i}, 'PRE', 'POST', 'RWSCF - PV (JAWS)')
    end
    
    for i = [1, 2, 4]
        cells_plot2cond(control_PV_JAWS_pre, control_PV_JAWS_post, celltypes{i}, 'PRE', 'POST', '- PV (JAWS)', norm)
        cells_plot2cond_bar(control_PV_JAWS_pre, control_PV_JAWS_post, celltypes{i}, 'PRE', 'POST', '- PV (JAWS)')
    end
    
    for i = [1, 2, 4]
        cells_plot2cond(RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWSCF - PV (hM4D(Gi)))', norm)
        cells_plot2cond_bar(RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWSCF - PV (hM4D(Gi)))')
    end
    
    for i = [1, 2, 4]
        cells_plot2cond(control_PV_Gi_pre_dcz, control_PV_Gi_post, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '- PV (hM4D(Gi)))', norm)
        cells_plot2cond_bar(control_PV_Gi_pre_dcz, control_PV_Gi_post, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '- PV (hM4D(Gi)))')
    end
    
    for i = [2, 4, 5]
        cells_plot2cond(RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWSCF - SST (hM4D(Gi)))', norm)
        cells_plot2cond_bar(RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWSCF - SST (hM4D(Gi)))')
    end
    
    for i = [2, 4, 5]
        cells_plot2cond(control_SST_Gi_pre_dcz, control_SST_Gi_post, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '- SST (hM4D(Gi)))', norm)
        cells_plot2cond_bar(control_SST_Gi_pre_dcz, control_SST_Gi_post, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '- SST (hM4D(Gi)))')
    end
    
    for i = [2, 4, 5]
        cells_plot2cond(RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWS + SST (hM3D(Gq)))', norm)
        cells_plot2cond_bar(RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWS + SST (hM3D(Gq)))')
    end
    
    for i = [2, 4, 5]
        cells_plot2cond(control_SST_Gq_pre_dcz, control_SST_Gq_post, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '+ SST (hM3D(Gq)))', norm)
        cells_plot2cond_bar(control_SST_Gq_pre_dcz, control_SST_Gq_post, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '+ SST (hM3D(Gq)))')
    end



end

function var = calculateamps(var)
    for i = 1:size(var, 2)
        temp = var{i};
        amp = nan(size(temp, 2), 1);
        for j = 1:size(temp, 2)
            trace = temp(310:402, j);
            if ~isnan(trace(1))
                [maximum, idx] = max(trace);
                amp(j) = maximum;
            end
        end
        var{i} = amp;
    end
end

function cells_plot2cond(cond1, cond2, choosecell, cond1name, cond2name, figtitle, choosenorm)
    colors = {[187/255, 37/255, 37/255], [34/255, 75/255, 170/255], [10/255, 138/255, 35/255],  [0, 0, 0], [99/255, 63/255, 115/255]};
    if strcmp(choosecell, 'PV')
        cell_temp = cond1{1};
        cell_temp2 = cond2{1};
        color = colors{1};
    elseif strcmp(choosecell, 'PN')
        cell_temp = cond1{2};
        cell_temp2 = cond2{2};
        color = colors{2};
    elseif strcmp(choosecell, 'VIP')
        cell_temp = cond1{3};
        cell_temp2 = cond2{3};
        color = colors{3};
    elseif strcmp(choosecell, 'UC')
        cell_temp = cond1{4};
        cell_temp2 = cond2{4};
        color = colors{4};
    elseif strcmp(choosecell, 'SST')
        cell_temp = cond1{5};
        cell_temp2 = cond2{5};
        color = colors{5};
    end

    figure('Position', [680,558,323,420]);
    if choosenorm
        for n = 1:size(cell_temp, 1)
            g = plot([1, 2], [cell_temp(n)/cell_temp(n), cell_temp2(n)/cell_temp(n)], 'Color', color, 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor', color);
            hold on
        end
        %ylim([0, 2])
        xlim([0.5, 2.5])
        set(gca, 'FontSize', 15)
        xticks([1, 2])
        xticklabels({cond1name, cond2name})
        ylabel('Max Amp. (∆F/F0)')
        title(figtitle)

        %[h,p,ci,stats] = ttest(cell_temp, cell_temp2);
        %text(1.5, 1.9, ['p = ', num2str(p, '%.3f')], 'HorizontalAlignment', 'center', 'FontSize', 12);
        %text(1.5, 1.9, ['nMice = ', num2str(size(cell_temp, 1)')], 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Color', color);
    else
        for n = 1:size(cell_temp, 1)
            g = plot([1, 2], [cell_temp(n), cell_temp2(n)], 'Color', color, 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor', color);
            hold on
        end
        ylim([0, 1.2])
        xlim([0.5, 2.5])
        set(gca, 'FontSize', 15)
        xticks([1, 2])
        xticklabels({cond1name, cond2name})
        ylabel('Max Amp. (∆F/F0)')
        title(figtitle)

        [h,p,ci,stats] = ttest(cell_temp, cell_temp2);
        text(1.5, 1.1, ['p = ', num2str(p, '%.3f')], 'HorizontalAlignment', 'center', 'FontSize', 12);
    end
end

function cells_plot2cond_bar(cond1, cond2, choosecell, cond1name, cond2name, figtitle)
colors = {[187/255, 37/255, 37/255], [34/255, 75/255, 170/255], [10/255, 138/255, 35/255],  [0, 0, 0], [99/255, 63/255, 115/255]};
    if strcmp(choosecell, 'PV')
        cell_temp = cond1{1};
        cell_temp2 = cond2{1};
        color = colors{1};
    elseif strcmp(choosecell, 'PN')
        cell_temp = cond1{2};
        cell_temp2 = cond2{2};
        color = colors{2};
    elseif strcmp(choosecell, 'VIP')
        cell_temp = cond1{3};
        cell_temp2 = cond2{3};
        color = colors{3};
    elseif strcmp(choosecell, 'UC')
        cell_temp = cond1{4};
        cell_temp2 = cond2{4};
        color = colors{4};
    elseif strcmp(choosecell, 'SST')
        cell_temp = cond1{5};
        cell_temp2 = cond2{5};
        color = colors{5};
    end
    mean_cell_temp = mean(cell_temp, 'omitnan');
    mean_cell_temp2 = mean(cell_temp2, 'omitnan');
    sem_cell_temp = std(cell_temp, 'omitnan') / sqrt(sum(~isnan(cell_temp)));
    sem_cell_temp2 = std(cell_temp2, 'omitnan') / sqrt(sum(~isnan(cell_temp2)));
    
    means = [mean_cell_temp, mean_cell_temp2];
    sems = [sem_cell_temp, sem_cell_temp2];
    
    figure('Position', [680,558,323,420]);
    
    bar_handle = bar(means,'FaceColor', color, 'EdgeColor', 'none');
    hold on;
    errorbar(1:length(means), means, sems, 'k', 'linestyle', 'none'); % 'k' is the color black
    set(gca, 'XTickLabel', {cond1name, cond2name}); % Customize x-axis labels
    ylabel('Max Amp. (∆F/F0)');
    xlim([0.5, 2.5])
    title(figtitle);
    set(gca, 'FontSize', 15)
    
    % Release the hold
    hold off;
end
