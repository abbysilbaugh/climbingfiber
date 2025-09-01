function visualizesmoothing_individualneurons(allData, mouse, choosesignal, ylimit, window, ...
    plotindivtrials, motType, baselineshiftperiod, baselineshift, baseline_reject_thresh, neuron_colors, isZI, choosecolor, stimframe, selectcells) %, normstyle, normto, window, normwindow)

trialType = allData.data{mouse}.trialType;
cellType = allData.data{mouse}.cellType;
tetPeriod = allData.data{mouse}.tetPeriod;
dczPeriod = allData.data{mouse}.dczPeriod;
motionType = allData.data{mouse}.trialmotType;

pre_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ');
pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
post_DCZ_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ');
post_DCZ_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'DCZ');
post_tet_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W');

pre_wo_trials_mot = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, motType);
pre_trials_mot = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, motType);
post_DCZ_trials_mot = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ') & strcmp(motionType, motType);
post_DCZ_wo_trials_mot = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'DCZ') & strcmp(motionType, motType);
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

% Reject traces with baseline above baseline_reject_threshold(2)
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
signal_pre = signal(:, :, pre_trials);
signal_post_dcz = signal(:, :, post_DCZ_trials);
signal_post_dcz_wo = signal(:, :, post_DCZ_wo_trials);
signal_post_tet = signal(:, :, post_tet_trials);

signal_pre_wo_mot = signal(:, :, pre_wo_trials_mot);
signal_pre_mot = signal(:, :, pre_trials_mot);
signal_post_dcz_mot = signal(:, :, post_DCZ_trials_mot);
signal_post_dcz_wo_mot = signal(:, :, post_DCZ_wo_trials_mot);
signal_post_tet_mot = signal(:, :, post_tet_trials_mot);

for i = selectcells
    temp_reject = reject_indices(i, :);

    temp_pre_wo = squeeze(signal_pre_wo(:, i, ~temp_reject(pre_wo_trials)));
    temp_pre = squeeze(signal_pre(:, i, ~temp_reject(pre_trials)));
    temp_post_dcz = squeeze(signal_post_dcz(:, i, ~temp_reject(post_DCZ_trials)));
    temp_post_dcz_wo = squeeze(signal_post_dcz_wo(:, i, ~temp_reject(post_DCZ_wo_trials)));
    temp_post_tet = squeeze(signal_post_tet(:, i, ~temp_reject(post_tet_trials)));

    temp_pre_wo_reject = squeeze(signal_pre_wo(:, i, temp_reject(pre_wo_trials)));
    temp_pre_reject = squeeze(signal_pre(:, i, temp_reject(pre_trials)));
    temp_post_dcz_reject = squeeze(signal_post_dcz(:, i, temp_reject(post_DCZ_trials)));
    temp_post_dcz_wo_reject = squeeze(signal_post_dcz(:, i, temp_reject(post_DCZ_wo_trials)));
    temp_post_tet_reject = squeeze(signal_post_tet(:, i, temp_reject(post_tet_trials)));

    temp_pre_wo_mot = squeeze(signal_pre_wo_mot(:, i, ~temp_reject(pre_wo_trials_mot)));
    temp_pre_mot = squeeze(signal_pre_mot(:, i, ~temp_reject(pre_trials_mot)));
    temp_post_dcz_mot = squeeze(signal_post_dcz_mot(:, i, ~temp_reject(post_DCZ_trials_mot)));
    temp_post_dcz_wo_mot = squeeze(signal_post_dcz_wo_mot(:, i, ~temp_reject(post_DCZ_wo_trials_mot)));
    temp_post_tet_mot = squeeze(signal_post_tet_mot(:, i, ~temp_reject(post_tet_trials_mot)));

    mean_pre_wo = mean(temp_pre_wo, 2, 'omitnan');
    mean_pre = mean(temp_pre, 2, 'omitnan');
    mean_post_dcz = mean(temp_post_dcz, 2, 'omitnan');
    mean_post_dcz_wo = mean(temp_post_dcz_wo, 2, 'omitnan');
    mean_post_tet = mean(temp_post_tet, 2, 'omitnan');

    mean_pre_wo_reject = mean(temp_pre_wo_reject, 2, 'omitnan');
    mean_pre_reject = mean(temp_pre_reject, 2, 'omitnan');
    mean_post_dcz_reject = mean(temp_post_dcz_reject, 2, 'omitnan');
    mean_post_dcz_wo_reject = mean(temp_post_dcz_wo_reject, 2, 'omitnan');
    mean_post_tet_reject = mean(temp_post_tet_reject, 2, 'omitnan');

    mean_pre_wo_mot  = mean(temp_pre_wo_mot, 2, 'omitnan');
    mean_pre_mot = mean(temp_pre_mot, 2, 'omitnan');
    mean_post_dcz_mot = mean(temp_post_dcz_mot, 2, 'omitnan');
    mean_post_dcz_wo_mot = mean(temp_post_dcz_wo_mot, 2, 'omitnan');
    mean_post_tet_mot = mean(temp_post_tet_mot, 2, 'omitnan');

    sem_pre_wo = (std(temp_pre_wo, 0, 2, 'omitnan')) / sqrt(size(mean_pre_wo, 2));
    sem_pre = (std(temp_pre, 0, 2, 'omitnan')) / sqrt(size(mean_pre, 2));
    sem_post_dcz = (std(temp_post_dcz, 0, 2, 'omitnan')) / sqrt(size(mean_post_dcz, 2));
    sem_post_dcz_wo = (std(temp_post_dcz_wo, 0, 2, 'omitnan')) / sqrt(size(mean_post_dcz_wo, 2));
    sem_post_tet = (std(temp_post_tet, 0, 2, 'omitnan')) / sqrt(size(mean_post_tet, 2));

    sem_pre_wo_mot = (std(temp_pre_wo_mot, 0, 2, 'omitnan')) / sqrt(size(mean_pre_wo_mot, 2));
    sem_pre_mot = (std(temp_pre_mot, 0, 2, 'omitnan')) / sqrt(size(mean_pre_mot, 2));
    sem_post_dcz_mot = (std(temp_post_dcz_mot, 0, 2, 'omitnan')) / sqrt(size(mean_post_dcz_mot, 2));
    sem_post_dcz_wo_mot = (std(temp_post_dcz_wo_mot, 0, 2, 'omitnan')) / sqrt(size(mean_post_dcz_wo_mot, 2));
    sem_post_tet_mot = (std(temp_post_tet_mot, 0, 2, 'omitnan')) / sqrt(size(mean_post_tet_mot, 2));

     %h = figure('Position', [50 50 1500 500]);
     if strcmp(isZI, 'ZI')
         %subplot(1, 4, 1)
         mean_cond = makesubplot(plotindivtrials, temp_pre, temp_pre_reject, temp_pre_mot, mean_pre, mean_pre_reject, sem_pre, mean_pre_mot, sem_pre_mot, cellType{i}, ylimit, window, 'W', neuron_colors);
         %subplot(1, 4, 2)
         mean_cond2 = makesubplot(plotindivtrials, temp_pre_wo, temp_pre_wo_reject, temp_pre_wo_mot, mean_pre_wo, mean_pre_wo_reject, sem_pre_wo, mean_pre_wo_mot, sem_pre_wo_mot, cellType{i}, ylimit, window, 'W + CF', neuron_colors);
        %subplot(1, 4, 3)
        mean_cond3 = makesubplot(plotindivtrials, temp_post_dcz, temp_post_dcz_reject, temp_post_dcz_mot, mean_post_dcz, mean_post_dcz_reject, sem_post_dcz, mean_post_dcz_mot, sem_post_dcz_mot, cellType{i}, ylimit, window, 'W (DCZ)', neuron_colors);
      %subplot(1, 4, 4)
        mean_cond4 = makesubplot(plotindivtrials, temp_post_dcz_wo, temp_post_dcz_wo_reject, temp_post_dcz_wo_mot, mean_post_dcz_wo, mean_post_dcz_wo_reject, sem_post_dcz_wo, mean_post_dcz_wo_mot, sem_post_dcz_wo_mot, cellType{i}, ylimit, window, 'W + CF (DCZ)', neuron_colors);
     else
       % subplot(1, 4, 1)
         mean_cond = makesubplot(plotindivtrials, temp_pre_wo, temp_pre_wo_reject, temp_pre_wo_mot, mean_pre_wo, mean_pre_wo_reject, sem_pre_wo, mean_pre_wo_mot, sem_pre_wo_mot, cellType{i}, ylimit, window, 'Pre (W+CF)', neuron_colors);
       % subplot(1, 4, 2)
         mean_cond2 = makesubplot(plotindivtrials, temp_pre, temp_pre_reject, temp_pre_mot, mean_pre, mean_pre_reject, sem_pre, mean_pre_mot, sem_pre_mot, cellType{i}, ylimit, window, 'Pre', neuron_colors);
       % subplot(1, 4, 3)
        mean_cond3 = makesubplot(plotindivtrials, temp_post_dcz, temp_post_dcz_reject, temp_post_dcz_mot, mean_post_dcz, mean_post_dcz_reject, sem_post_dcz, mean_post_dcz_mot, sem_post_dcz_mot, cellType{i}, ylimit, window, 'Pre (DCZ)', neuron_colors);
       % subplot(1, 4, 4)
        mean_cond4 = makesubplot(plotindivtrials, temp_post_tet, temp_post_tet_reject, temp_post_tet_mot, mean_post_tet, mean_post_tet_reject, sem_post_tet, mean_post_tet_mot, sem_post_tet_mot, cellType{i}, ylimit, window, 'Post', neuron_colors);
   
    figure('Position', [1015,300,120,420]);
    plot(mean_cond, 'color', [0.5 0.5 0.5])
    hold on
    plot(mean_cond2, 'color', neuron_colors{choosecolor})
    %ylim(ylimit)
    % Manually draw x-axis only for the first 500 msec
    plot([window(1), window(1) + 15.49], [ylimit(1), ylimit(1)], 'k', 'LineWidth', 0.5')
    % Manually draw y-axis only up to y=0.1
    plot([window(1), window(1)], [ylimit(1), 0.1], 'k', 'LineWidth', 0.5')
    ax = gca;
    ax.XColor = 'none'; % Hide default x-axis
    ax.YColor = 'none'; % Hide default y-axis
  %  line([stimframe, stimframe], [-0.05 ylimit(2)], 'Color', 'k', 'LineWidth', 1)
     end

      %xline(310-5, 'LineWidth', 2)
        ylim(ylimit)
        xticks([0 15.5 31 46.5 62 77.5 93 108.5 124 139.5 155 170.5 186 201.5 217 232.5 248 263.5 279 294.5 310 325.5 341 356.5 372 387.5 403 418.5 434 449.5 465 480.5 496 511.5 527 542.5 558 573.5 589 604.5 620]-5)
        xticklabels([-10000 -9500 -9000 -8500 -8000 -7500 -7000 -6500 -6000 -5500 -5000 -4500 -4000 -3500 -3000 -2500 -2000 -1500 -1000 -500 0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 10000])
        xlabel('msec')
        ylabel('dF/F0')
        xlim([window(1), window(2)])

    print('-dtiff', '-r300', ['cell_', num2str(i)])

end

allData.data{mouse}.golaybaselineshifted = signal;

end

function mean_cond = makesubplot(plotindivtrials, cond, cond_reject, cond_mot, mean_cond, mean_cond_reject, sem_cond, mean_cond_mot, sem_cond_mot, cellType, ylimit, window, gettitle, neuron_colors)
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
%             plot(mean_cond, 'Color', 'k', 'LineWidth', 2)
%             hold on
%             fill([1:length(mean_cond), length(mean_cond):-1:1], [mean_cond - sem_cond; flipud(mean_cond + sem_cond)], [0 0 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
%         elseif strcmp(cellType, 'PN')
%             plot(mean_cond, 'Color', 'b', 'LineWidth', 2)
%             hold on
%             fill([1:length(mean_cond), length(mean_cond):-1:1], [mean_cond - sem_cond; flipud(mean_cond + sem_cond)], [0 0 1], 'linestyle', 'none', 'FaceAlpha', 0.5);
%         elseif strcmp(cellType, 'PV')
%             plot(mean_cond, 'Color', 'r', 'LineWidth', 2)
%             hold on
%             fill([1:length(mean_cond), length(mean_cond):-1:1], [mean_cond - sem_cond; flipud(mean_cond + sem_cond)], [1 0 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
%         elseif strcmp(cellType, 'VIP')
%             plot(mean_cond, 'Color', 'g', 'LineWidth', 2)
%             hold on
%             fill([1:length(mean_cond), length(mean_cond):-1:1], [mean_cond - sem_cond; flipud(mean_cond + sem_cond)], [0 1 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
%         elseif strcmp(cellType, 'SST')
%             plot(mean_cond, 'Color', 'c', 'LineWidth', 2)
%             hold on
%             fill([1:length(mean_cond), length(mean_cond):-1:1], [mean_cond - sem_cond; flipud(mean_cond + sem_cond)], [0 1 1], 'linestyle', 'none', 'FaceAlpha', 0.5);
%         end
% 
%         hold on
%         plot(mean_cond_mot, 'Color', [0.5 0.5 0.5], 'LineWidth', 2)
%         fill([1:length(mean_cond_mot), length(mean_cond_mot):-1:1], [mean_cond_mot - sem_cond_mot; flipud(mean_cond_mot + sem_cond_mot)], [0.5 0.5 0.5], 'linestyle', 'none', 'FaceAlpha', 0.5);
%         plot(mean_cond_reject, 'Color', [1 1 0])
%     end
% 
% 
%         xline(310-5, 'LineWidth', 2)
%         ylim(ylimit)
%         xticks([0 15.5 31 46.5 62 77.5 93 108.5 124 139.5 155 170.5 186 201.5 217 232.5 248 263.5 279 294.5 310 325.5 341 356.5 372 387.5 403 418.5 434 449.5 465 480.5 496 511.5 527 542.5 558 573.5 589 604.5 620]-5)
%         xticklabels([-10000 -9500 -9000 -8500 -8000 -7500 -7000 -6500 -6000 -5500 -5000 -4500 -4000 -3500 -3000 -2500 -2000 -1500 -1000 -500 0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 10000])
%         xlabel('msec')
%         ylabel('dF/F0')
%         title(gettitle)
%         xlim([window(1), window(2)])
end