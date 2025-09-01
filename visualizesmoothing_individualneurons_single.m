% Function notes:
    % Plots all conditions for single neuron
    % if baselineshift...
        

function visualizesmoothing_individualneurons_single(allData, mouse, choosesignal, ylimit, window, ...
    plotindivtrials, motType, baselineshiftperiod, baselineshift, baseline_reject_thresh, choose_neuron, neuron_colors, frameidx1, frameidx2, choosecolor, auc_max_win) %, normstyle, normto, window, normwindow)

trialType = allData.data{mouse}.trialType;
cellType = allData.data{mouse}.cellType;
tetPeriod = allData.data{mouse}.tetPeriod;
dczPeriod = allData.data{mouse}.dczPeriod;
motionType = allData.data{mouse}.trialmotType;

pre_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ');
pre_w_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
post_DCZ_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'DCZ');
post_DCZ_w_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ');
post_tet_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W');

pre_wo_trials_mot = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, motType);
pre_w_trials_mot = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, motType);
post_DCZ_wo_trials_mot = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'DCZ') & strcmp(motionType, motType);
post_DCZ_w_trials_mot = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ') & strcmp(motionType, motType);
post_tet_trials_mot = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(motionType, motType);


if strcmp(choosesignal, 'golaysignal4')
    signal = allData.data{mouse}.golaysignal4;
elseif strcmp(choosesignal, 'golaysignal3')
    signal = allData.data{mouse}.golaysignal3;
elseif strcmp(choosesignal, 'golaysignal2')
    signal = allData.data{mouse}.golaysignal2;
elseif strcmp(choosesignal, 'golaysignal')
    signal = allData.data{mouse}.golaysignal;
elseif strcmp(choosesignal, 'golayshift')
    signal = allData.data{mouse}.golayshift;
elseif strcmp(choosesignal, 'evokedtraces')
    signal = allData.data{mouse}.evokedtraces;
elseif strcmp(choosesignal, 'evokedtraces2')
    signal = allData.data{mouse}.evokedtraces2;
end

[nFrames, nCells, nTrials] = size(signal);

% Find traces with baseline above baseline_reject_threshold (if specified)
reject_indices = zeros(nCells, nTrials);
if ~isnan(baseline_reject_thresh(1))
    for i = 1:nCells
        for j=1:nTrials
            temp = signal(:, i, j);
            getbaseline = temp(baselineshiftperiod(1):baselineshiftperiod(2));
            getbaseline = mean(getbaseline);
            if mean(getbaseline) > baseline_reject_thresh(2)
                reject_indices(i, j) = 1;
            end
        end
    end
end

reject_indices = logical(reject_indices);

prestimbaselines = zeros(nCells, nTrials);
% Normalize remaining traces to baseline specified by baselineshiftperiod
if ~isnan(baselineshift)
    for i = 1:nCells
        for j = 1:nTrials
            if ~reject_indices(i, j)
                temp = signal(:, i, j);
                getbaseline = temp(baselineshiftperiod(1):baselineshiftperiod(2));
                prestimbaselines(i, j) = min(getbaseline);
                temp = temp - prestimbaselines(i, j);
                signal(:, i, j) = temp;
            end
        end
    end
end

signal_pre_wo = signal(:, :, pre_wo_trials);
signal_pre_w = signal(:, :, pre_w_trials);
signal_post_dcz_wo = signal(:, :, post_DCZ_wo_trials);
signal_post_dcz_w = signal(:, :, post_DCZ_w_trials);
signal_post_tet = signal(:, :, post_tet_trials);

signal_pre_wo_mot = signal(:, :, pre_wo_trials_mot);
signal_pre_mot_w = signal(:, :, pre_w_trials_mot);
signal_post_dcz_wo_mot = signal(:, :, post_DCZ_wo_trials_mot);
signal_post_dcz_w_mot = signal(:, :, post_DCZ_w_trials_mot);
signal_post_tet_mot = signal(:, :, post_tet_trials_mot);

i = choose_neuron;
    % Visualize kept and rejected traces
    temp_reject = reject_indices(i, :);

    temp_pre_wo = squeeze(signal_pre_wo(:, i, ~temp_reject(pre_wo_trials)));
    temp_pre = squeeze(signal_pre_w(:, i, ~temp_reject(pre_w_trials)));
    temp_post_dcz_wo = squeeze(signal_post_dcz_wo(:, i, ~temp_reject(post_DCZ_wo_trials)));
    temp_post_dcz = squeeze(signal_post_dcz_w(:, i, ~temp_reject(post_DCZ_w_trials)));
    temp_post_tet = squeeze(signal_post_tet(:, i, ~temp_reject(post_tet_trials)));

    temp_pre_wo_reject = squeeze(signal_pre_wo(:, i, temp_reject(pre_wo_trials)));
    temp_pre_reject = squeeze(signal_pre_w(:, i, temp_reject(pre_w_trials)));
    temp_post_dcz_reject_wo = squeeze(signal_post_dcz_wo(:, i, temp_reject(post_DCZ_wo_trials)));
    temp_post_dcz_reject = squeeze(signal_post_dcz_w(:, i, temp_reject(post_DCZ_w_trials)));
    temp_post_tet_reject = squeeze(signal_post_tet(:, i, temp_reject(post_tet_trials)));

    temp_pre_wo_mot = squeeze(signal_pre_wo_mot(:, i, ~temp_reject(pre_wo_trials_mot)));
    temp_pre_mot = squeeze(signal_pre_mot_w(:, i, ~temp_reject(pre_w_trials_mot)));
    temp_post_dcz_mot_wo = squeeze(signal_post_dcz_wo_mot(:, i, ~temp_reject(post_DCZ_wo_trials_mot)));
    temp_post_dcz_mot = squeeze(signal_post_dcz_w_mot(:, i, ~temp_reject(post_DCZ_w_trials_mot)));
    temp_post_tet_mot = squeeze(signal_post_tet_mot(:, i, ~temp_reject(post_tet_trials_mot)));

    mean_pre_wo = mean(temp_pre_wo, 2, 'omitnan');
    mean_pre = mean(temp_pre, 2, 'omitnan');
    mean_post_dcz_wo = mean(temp_post_dcz_wo, 2, 'omitnan');
    mean_post_dcz = mean(temp_post_dcz, 2, 'omitnan');
    mean_post_tet = mean(temp_post_tet, 2, 'omitnan');

    mean_pre_wo_reject = mean(temp_pre_wo_reject, 2, 'omitnan');
    mean_pre_reject = mean(temp_pre_reject, 2, 'omitnan');
    mean_post_dcz_reject_wo = mean(temp_post_dcz_reject_wo, 2, 'omitnan');
    mean_post_dcz_reject = mean(temp_post_dcz_reject, 2, 'omitnan');
    mean_post_tet_reject = mean(temp_post_tet_reject, 2, 'omitnan');

    mean_pre_wo_mot  = mean(temp_pre_wo_mot, 2, 'omitnan');
    mean_pre_mot = mean(temp_pre_mot, 2, 'omitnan');
    mean_post_dcz_mot_wo = mean(temp_post_dcz_mot_wo, 2, 'omitnan');
    mean_post_dcz_mot = mean(temp_post_dcz_mot, 2, 'omitnan');
    mean_post_tet_mot = mean(temp_post_tet_mot, 2, 'omitnan');

    sem_pre_wo = (std(temp_pre_wo, 0, 2, 'omitnan')) / sqrt(size(mean_pre_wo, 2));
    sem_pre = (std(temp_pre, 0, 2, 'omitnan')) / sqrt(size(mean_pre, 2));
    sem_post_dcz_wo = (std(temp_post_dcz_wo, 0, 2, 'omitnan')) / sqrt(size(mean_post_dcz_wo, 2));
    sem_post_dcz = (std(temp_post_dcz, 0, 2, 'omitnan')) / sqrt(size(mean_post_dcz, 2));
    sem_post_tet = (std(temp_post_tet, 0, 2, 'omitnan')) / sqrt(size(mean_post_tet, 2));

    sem_pre_wo_mot = (std(temp_pre_wo_mot, 0, 2, 'omitnan')) / sqrt(size(mean_pre_wo_mot, 2));
    sem_pre_mot = (std(temp_pre_mot, 0, 2, 'omitnan')) / sqrt(size(mean_pre_mot, 2));
    sem_post_dcz_mot_wo = (std(temp_post_dcz_mot_wo, 0, 2, 'omitnan')) / sqrt(size(mean_post_dcz_mot_wo, 2));
    sem_post_dcz_mot = (std(temp_post_dcz_mot, 0, 2, 'omitnan')) / sqrt(size(mean_post_dcz_mot, 2));
    sem_post_tet_mot = (std(temp_post_tet_mot, 0, 2, 'omitnan')) / sqrt(size(mean_post_tet_mot, 2));

%     h = figure('Position', [50 50 1500 500]);
%     subplot(1, 5, 1)
%     makesubplot(plotindivtrials, temp_pre_wo, temp_pre_wo_reject, temp_pre_wo_mot, mean_pre_wo, mean_pre_wo_reject, sem_pre_wo, mean_pre_wo_mot, sem_pre_wo_mot, cellType{i}, ylimit, window, 'Pre (W+CF)', neuron_colors, choosecolor);
% 
%     subplot(1, 5, 2)
%     makesubplot(plotindivtrials, temp_pre, temp_pre_reject, temp_pre_mot, mean_pre, mean_pre_reject, sem_pre, mean_pre_mot, sem_pre_mot, cellType{i}, ylimit, window, 'Pre', neuron_colors, choosecolor);
% 
%     subplot(1, 5, 3)
%     makesubplot(plotindivtrials, temp_post_dcz, temp_post_dcz_reject, temp_post_dcz_mot, mean_post_dcz, mean_post_dcz_reject, sem_post_dcz, mean_post_dcz_mot, sem_post_dcz_mot, cellType{i}, ylimit, window, 'Pre (DCZ)', neuron_colors, choosecolor);
% 
%     subplot(1, 5, 4)
%     makesubplot(plotindivtrials, temp_post_dcz_wo, temp_post_dcz_reject_wo, temp_post_dcz_mot_wo, mean_post_dcz_wo, mean_post_dcz_reject_wo, sem_post_dcz_wo, mean_post_dcz_mot_wo, sem_post_dcz_mot_wo, cellType{i}, ylimit, window, 'Pre (DCZ; W+CF)', neuron_colors, choosecolor);
% 
%     subplot(1, 5, 5)
%     makesubplot(plotindivtrials, temp_post_tet, temp_post_tet_reject, temp_post_tet_mot, mean_post_tet, mean_post_tet_reject, sem_post_tet, mean_post_tet_mot, sem_post_tet_mot, cellType{i}, ylimit, window, 'Post', neuron_colors, choosecolor);
% 
%    print('-dtiff', '-r300', ['cell_', num2str(i)])

    % Plot neuron over time
    signal = allData.data{mouse}.golayshift(:, choose_neuron, :);
    signal = squeeze(signal);
    signal = signal(:);
    evokedsignal = allData.data{mouse}.evokedtraces;
    evokedsignal = evokedsignal(:, choose_neuron, :);
    evokedsignal = squeeze(evokedsignal);

     % Set evoked trace outside of auc_max_win to NaN for plotting
    evokedsignal(1:auc_max_win(1), :) = NaN;
    evokedsignal(auc_max_win(2):620, :) = NaN;

    evokedsignal = evokedsignal(:);

    evokedspiketimes = allData.data{mouse}.evoked_spkLocs;
    evokedspiketimes = evokedspiketimes(choose_neuron, :); 
    evokedspiketimes = reformatspiketimes(evokedspiketimes);
    evokedspiketimes = evokedspiketimes(:);
    evokedspiketimes = evokedspiketimes - 1.3;



    getcelltype = cellType{choose_neuron};
    if strcmp(getcelltype, 'PN')
        color = 2;
    elseif strcmp(getcelltype, 'UC')
        color = 4;
    elseif strcmp(getcelltype, 'VIP')
        color = 3;
    elseif strcmp(getcelltype, 'PV')
        color = 2;
    elseif strcmp(getcelltype, 'SST')
        color = 5;
    end
    x = linspace(0, length(evokedspiketimes), length(evokedspiketimes));
    sumtrialspre = pre_w_trials + pre_wo_trials; sumtrialspre = sum(sumtrialspre);
    sumtrials = pre_w_trials + pre_wo_trials + post_tet_trials; sumtrials = sum(sumtrials);
%     figure('Position', [1,777,1900,200]);
%     plot(signal, 'Color', [0.5 0.5 0.5])
%     hold on
%     plot(evokedsignal, 'Color', neuron_colors{color})
%     scatter(x, evokedspiketimes, 5, 'filled', 'MarkerFaceColor', neuron_colors{color});
%     for i = 0:sumtrialspre
%         scatter((620*i)+305, -.75, 5, 'filled', 'MarkerFaceColor', [0.5 0.5 0.5])
%     end
%     for i = sumtrialspre:sumtrials
%         scatter((620*i)+305, -.75, 5, 'filled', 'MarkerFaceColor', 'k')
%     end
%     ylim(ylimit)
% 
%     ylabel('ΔF/F0')
%     ax = gca; % Get current axes
%     ax.XColor = 'none'; % Hide x-axis
%     ax.YColor = 'k'; % Keep y-axis visible (black)
%     ax.Box = 'off'; % Remove the surrounding box
%     ax.XColor = 'none'; % Hide x-axis
%     ax.YColor = 'k'; % Keep y-axis visible (black)
%     ax.TickDir = 'out'; % Optional: moves ticks outward for clarity
%     ax.Box = 'off'; % Remove box
%     set(gca, 'FontSize', 7)




 figure('Position', [163,709,817,131])
    subplot(1, 2, 1)
    plot(signal, 'Color', [0.5 0.5 0.5 0.5])
    hold on
    plot(evokedsignal, 'Color', neuron_colors{color})
    scatter(x, evokedspiketimes, 5, 'filled', 'MarkerFaceColor', neuron_colors{color});
    for i = 0:sumtrialspre
        scatter((620*i)+305, -.75, 5, 'filled', 'MarkerFaceColor', [0.5 0.5 0.5])
    end
    for i = sumtrialspre:sumtrials
        scatter((620*i)+305, -.75, 5, 'filled', 'MarkerFaceColor', 'k')
    end
    xlim([frameidx1(1), frameidx1(2)])
    ylim(ylimit)

    ylabel('ΔF/F')
    ax = gca; % Get current axes
    ax.XColor = 'none'; % Hide x-axis
    ax.YColor = 'k'; % Keep y-axis visible (black)
    ax.Box = 'off'; % Remove the surrounding box
    ax.XColor = 'none'; % Hide x-axis
    ax.YColor = 'k'; % Keep y-axis visible (black)
    ax.TickDir = 'out'; % Optional: moves ticks outward for clarity
    ax.Box = 'off'; % Remove box
    set(gca, 'FontSize', 7)

    subplot(1, 2, 2)
    plot(signal, 'Color', [0.5 0.5 0.5 0.5])
    hold on
    plot(evokedsignal, 'Color', neuron_colors{color})
    scatter(x, evokedspiketimes, 5, 'filled', 'MarkerFaceColor', neuron_colors{color});
    for i = 0:sumtrialspre
        scatter((620*i)+305, -.75, 5, 'filled', 'MarkerFaceColor', [0.5 0.5 0.5])
    end
    for i = sumtrialspre:sumtrials
        scatter((620*i)+305, -.75, 5, 'filled', 'MarkerFaceColor', 'k')
    end
    xlim([frameidx2(1), frameidx2(2)])
    ylim(ylimit)

    ylabel('ΔF/F')
    ax = gca; % Get current axes
    ax.XColor = 'none'; % Hide x-axis
    ax.YColor = 'k'; % Keep y-axis visible (black)
    ax.Box = 'off'; % Remove the surrounding box
    ax.XColor = 'none'; % Hide x-axis
    ax.YColor = 'k'; % Keep y-axis visible (black)
    ax.TickDir = 'out'; % Optional: moves ticks outward for clarity
    ax.Box = 'off'; % Remove box
    set(gca, 'FontSize', 7)




allData.data{mouse}.golaybaselineshifted = signal;

end

% function makesubplot(plotindivtrials, cond, cond_reject, cond_mot, mean_cond, mean_cond_reject, sem_cond, mean_cond_mot, sem_cond_mot, cellType, ylimit, window, gettitle, neuron_colors, choosecolor)
%     if strcmp(plotindivtrials, 'ploteachtrial')
%         if strcmp(cellType, 'UC')
%             plot(cond, 'Color', neuron_colors{4})
%         elseif strcmp(cellType, 'PN')
%             plot(cond, 'Color', neuron_colors{2})
%         elseif strcmp(cellType, 'PV')
%             plot(cond, 'Color', neuron_colors{1})
%         elseif strcmp(cellType, 'VIP')
%             plot(cond, 'Color', neuron_colors{3})
%         elseif strcmp(cellType, 'SST')
%             plot(cond, 'Color', neuron_colors{5})
%         end
%         hold on
%         plot(cond_mot, 'Color', [0.5 0.5 0.5])
%         plot(cond_reject, 'Color', 'r')
%         
%     else
%         if strcmp(cellType, 'UC')
%             plot(mean_cond, 'Color', neuron_colors{choosecolor}, 'LineWidth', 2)
%             hold on
%             fill([1:length(mean_cond), length(mean_cond):-1:1], [mean_cond - sem_cond; flipud(mean_cond + sem_cond)], neuron_colors{4}, 'linestyle', 'none', 'FaceAlpha', 0.5);
%         elseif strcmp(cellType, 'PN')
%             plot(mean_cond, 'Color', neuron_colors{choosecolor}, 'LineWidth', 2)
%             hold on
%             fill([1:length(mean_cond), length(mean_cond):-1:1], [mean_cond - sem_cond; flipud(mean_cond + sem_cond)], neuron_colors{2}, 'linestyle', 'none', 'FaceAlpha', 0.5);
%         elseif strcmp(cellType, 'PV')
%             plot(mean_cond, 'Color', neuron_colors{choosecolor}, 'LineWidth', 2)
%             hold on
%             fill([1:length(mean_cond), length(mean_cond):-1:1], [mean_cond - sem_cond; flipud(mean_cond + sem_cond)], neuron_colors{1}, 'linestyle', 'none', 'FaceAlpha', 0.5);
%         elseif strcmp(cellType, 'VIP')
%             plot(mean_cond, 'Color', neuron_colors{choosecolor}, 'LineWidth', 2)
%             hold on
%             fill([1:length(mean_cond), length(mean_cond):-1:1], [mean_cond - sem_cond; flipud(mean_cond + sem_cond)], neuron_colors{3}, 'linestyle', 'none', 'FaceAlpha', 0.5);
%         elseif strcmp(cellType, 'SST')
%             plot(mean_cond, 'Color', neuron_colors{choosecolor}, 'LineWidth', 2)
%             hold on
%             fill([1:length(mean_cond), length(mean_cond):-1:1], [mean_cond - sem_cond; flipud(mean_cond + sem_cond)], neuron_colors{5}, 'linestyle', 'none', 'FaceAlpha', 0.5);
%         end
% 
%         hold on
%         plot(mean_cond_mot, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
%         fill([1:length(mean_cond_mot), length(mean_cond_mot):-1:1], [mean_cond_mot - sem_cond_mot; flipud(mean_cond_mot + sem_cond_mot)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
%         plot(mean_cond_reject, 'Color', [1 1 0])
%     end
% 
%         xline(310-5, 'LineWidth', 2)
%         ylim(ylimit)
%         xticks([0 15.5 31 46.5 62 77.5 93 108.5 124 139.5 155 170.5 186 201.5 217 232.5 248 263.5 279 294.5 310 325.5 341 356.5 372 387.5 403 418.5 434 449.5 465 480.5 496 511.5 527 542.5 558 573.5 589 604.5 620]-5)
%         xticklabels([-10000 -9500 -9000 -8500 -8000 -7500 -7000 -6500 -6000 -5500 -5000 -4500 -4000 -3500 -3000 -2500 -2000 -1500 -1000 -500 0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 10000])
%         xlabel('msec')
%         ylabel('dF/F0')
%         title(gettitle)
%         xlim([window(1), window(2)])
% end

function evokedspiketimes = reformatspiketimes(var)

nTrials = length(var);

evokedspiketimes = NaN(620, nTrials);
for i = 1:nTrials
    temp = var{i};
    evokedspiketimes(temp, i) = 1;
end

end