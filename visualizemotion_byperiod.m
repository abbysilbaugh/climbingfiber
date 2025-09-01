% adds new variable...
    % proportion_mot_trials (1 x 1 struct)
%     proportion_mot_trials.proportion_pre_w (nMice x 1)
%     proportion_mot_trials.proportion_pre_wo (nMice x 1)
%     proportion_mot_trials.proportion_dcz_w (nMice x 1)
%     proportion_mot_trials.proportion_dcz_wo (nMice x 1)
%     proportion_mot_trials.proportion_post (nMice x 1)
        % within each cell is 4 x 1 array (proportion NM, M, T, H)
    

function [proportion_mot_trials] = visualizemotion_byperiod(allData, window, showeach, btsummary, choosemottype)

proportion_mot_trials = [];

nMice = length(allData.data);

% Parse trial types
all_pre_wo = cell(nMice, 2);
NM_pre_wo = cell(nMice, 2);
M_pre_wo = cell(nMice, 2);
T_pre_wo = cell(nMice, 2);
H_pre_wo = cell(nMice, 2);

all_pre_w = cell(nMice, 2);
NM_pre_w = cell(nMice, 2);
M_pre_w = cell(nMice, 2);
T_pre_w = cell(nMice, 2);
H_pre_w = cell(nMice, 2);

all_dcz_w = cell(nMice, 2);
NM_dcz_w = cell(nMice, 2);
M_dcz_w = cell(nMice, 2);
T_dcz_w = cell(nMice, 2);
H_dcz_w = cell(nMice, 2);

all_dcz_wo = cell(nMice, 2);
NM_dcz_wo = cell(nMice, 2);
M_dcz_wo = cell(nMice, 2);
T_dcz_wo = cell(nMice, 2);
H_dcz_wo = cell(nMice, 2);

all_post = cell(nMice, 2);
NM_post = cell(nMice, 2);
M_post = cell(nMice, 2);
T_post = cell(nMice, 2);
H_post = cell(nMice, 2);

proportion_pre_wo = cell(nMice, 1);
proportion_pre_w = cell(nMice, 1);
proportion_dcz_w = cell(nMice, 1);
proportion_dcz_wo = cell(nMice, 1);
proportion_post = cell(nMice, 1);




for i = 1:nMice
    if strcmp(choosemottype, 'motionInfo')
        motion = allData.data{i}.motionInfo;
        trialtype = allData.data{i}.trialmotType;
    elseif strcmp(choosemottype, 'motionInfo_settime')
        motion = allData.data{i}.motionInfo_settime;
        trialtype = allData.data{i}.trialmotType_settime;
    elseif strcmp(choosemottype, 'motionInfo_settime2')
        motion = allData.data{i}.motionInfo_settime2;
        trialtype = allData.data{i}.trialmotType_settime2;
    end
    tetPeriod = allData.data{i}.tetPeriod;
    dczPeriod = allData.data{i}.dczPeriod;
    stimtype = allData.data{i}.trialType;
    exptype = allData.data{i}.experimentType;

    % Ignore NaN trials (outside time window of analysis)
    idxs = motion(1, :);
    idxs = ~isnan(idxs);

    motion = motion(:, idxs);
    trialtype = trialtype(idxs);
    tetPeriod = tetPeriod(idxs);
    stimtype = stimtype(idxs);
    dczPeriod = dczPeriod(idxs);

    all_pre_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'NO DCZ') & strcmp(stimtype, 'WO');
    NM_pre_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'NO DCZ') & strcmp(trialtype, 'NM') & strcmp(stimtype, 'WO');
    M_pre_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'NO DCZ') & strcmp(trialtype, 'M') & strcmp(stimtype, 'WO');
    T_pre_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'NO DCZ') & strcmp(trialtype, 'T') & strcmp(stimtype, 'WO');
    H_pre_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'NO DCZ') & strcmp(trialtype, 'H') & strcmp(stimtype, 'WO');

    all_pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'NO DCZ') & strcmp(stimtype, 'W');
    NM_pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'NO DCZ') & strcmp(trialtype, 'NM') & strcmp(stimtype, 'W');
    M_pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'NO DCZ') & strcmp(trialtype, 'M') & strcmp(stimtype, 'W');
    T_pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'NO DCZ') & strcmp(trialtype, 'T') & strcmp(stimtype, 'W');
    H_pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'NO DCZ') & strcmp(trialtype, 'H') & strcmp(stimtype, 'W');

    all_dcz_trials_w = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'DCZ') & strcmp(stimtype, 'W');
    NM_dcz_trials_w = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'DCZ') & strcmp(trialtype, 'NM') & strcmp(stimtype, 'W');
    M_dcz_trials_w = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'DCZ') & strcmp(trialtype, 'M') & strcmp(stimtype, 'W');
    T_dcz_trials_w = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'DCZ') & strcmp(trialtype, 'T') & strcmp(stimtype, 'W');
    H_dcz_trials_w = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'DCZ') & strcmp(trialtype, 'H') & strcmp(stimtype, 'W');

    all_dcz_trials_wo = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'DCZ') & strcmp(stimtype, 'WO');
    NM_dcz_trials_wo = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'DCZ') & strcmp(trialtype, 'NM') & strcmp(stimtype, 'WO');
    M_dcz_trials_wo = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'DCZ') & strcmp(trialtype, 'M') & strcmp(stimtype, 'WO');
    T_dcz_trials_wo = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'DCZ') & strcmp(trialtype, 'T') & strcmp(stimtype, 'WO');
    H_dcz_trials_wo = strcmp(tetPeriod, 'PRE') & strcmp(dczPeriod, 'DCZ') & strcmp(trialtype, 'H') & strcmp(stimtype, 'WO');

    all_post_trials = strcmp(tetPeriod, 'POST') & strcmp(stimtype, 'W');
    NM_post_trials = strcmp(tetPeriod, 'POST') & strcmp(trialtype, 'NM') & strcmp(stimtype, 'W');
    M_post_trials = strcmp(tetPeriod, 'POST') & strcmp(trialtype, 'M') & strcmp(stimtype, 'W');
    T_post_trials = strcmp(tetPeriod, 'POST') & strcmp(trialtype, 'T') & strcmp(stimtype, 'W');
    H_post_trials = strcmp(tetPeriod, 'POST') & strcmp(trialtype, 'H') & strcmp(stimtype, 'W');

    all_pre_wo_temp = motion(:, all_pre_wo_trials);
    NM_pre_wo_temp = motion(:, NM_pre_wo_trials);
    M_pre_wo_temp = motion(:, M_pre_wo_trials);
    T_pre_wo_temp = motion(:, T_pre_wo_trials);
    H_pre_wo_temp = motion(:, H_pre_wo_trials);

    all_pre_temp = motion(:, all_pre_trials);
    NM_pre_temp = motion(:, NM_pre_trials);
    M_pre_temp = motion(:, M_pre_trials);
    T_pre_temp = motion(:, T_pre_trials);
    H_pre_temp = motion(:, H_pre_trials);

    all_dcz_temp_w = motion(:, all_dcz_trials_w);
    NM_dcz_temp_w = motion(:, NM_dcz_trials_w);
    M_dcz_temp_w = motion(:, M_dcz_trials_w);
    T_dcz_temp_w = motion(:, T_dcz_trials_w);
    H_dcz_temp_w = motion(:, H_dcz_trials_w);

    all_dcz_temp_wo = motion(:, all_dcz_trials_wo);
    NM_dcz_temp_wo = motion(:, NM_dcz_trials_wo);
    M_dcz_temp_wo = motion(:, M_dcz_trials_wo);
    T_dcz_temp_wo = motion(:, T_dcz_trials_wo);
    H_dcz_temp_wo = motion(:, H_dcz_trials_wo);

    all_post_temp = motion(:, all_post_trials);
    NM_post_temp = motion(:, NM_post_trials);
    M_post_temp = motion(:, M_post_trials);
    T_post_temp = motion(:, T_post_trials);
    H_post_temp = motion(:, H_post_trials);

    all_pre_wo{i, 1} = sum(all_pre_wo_temp, 2); all_pre_wo{i, 2} = size(all_pre_wo_temp, 2);
    NM_pre_wo{i, 1} = sum(NM_pre_wo_temp, 2); NM_pre_wo{i, 2} = size(NM_pre_wo_temp, 2);
    M_pre_wo{i, 1} = sum(M_pre_wo_temp, 2); M_pre_wo{i, 2} = size(M_pre_wo_temp, 2);
    T_pre_wo{i, 1} = sum(T_pre_wo_temp, 2); T_pre_wo{i, 2} = size(T_pre_wo_temp, 2);
    H_pre_wo{i, 1} = sum(H_pre_wo_temp, 2); H_pre_wo{i, 2} = size(H_pre_wo_temp, 2);

    all_pre_w{i, 1} = sum(all_pre_temp, 2); all_pre_w{i, 2} = size(all_pre_temp, 2);
    NM_pre_w{i, 1} = sum(NM_pre_temp, 2); NM_pre_w{i, 2} = size(NM_pre_temp, 2);
    M_pre_w{i, 1} = sum(M_pre_temp, 2); M_pre_w{i, 2} = size(M_pre_temp, 2);
    T_pre_w{i, 1} = sum(T_pre_temp, 2); T_pre_w{i, 2} = size(T_pre_temp, 2);
    H_pre_w{i, 1} = sum(H_pre_temp, 2); H_pre_w{i, 2} = size(H_pre_temp, 2);

    all_dcz_w{i, 1} = sum(all_dcz_temp_w, 2); all_dcz_w{i, 2} = size(all_dcz_temp_w, 2);
    NM_dcz_w{i, 1} = sum(NM_dcz_temp_w, 2); NM_dcz_w{i, 2} = size(NM_dcz_temp_w, 2);
    M_dcz_w{i, 1} = sum(M_dcz_temp_w, 2); M_dcz_w{i, 2} = size(M_dcz_temp_w, 2);
    T_dcz_w{i, 1} = sum(T_dcz_temp_w, 2); T_dcz_w{i, 2} = size(T_dcz_temp_w, 2);
    H_dcz_w{i, 1} = sum(H_dcz_temp_w, 2); H_dcz_w{i, 2} = size(H_dcz_temp_w, 2);

    all_dcz_wo{i, 1} = sum(all_dcz_temp_wo, 2); all_dcz_wo{i, 2} = size(all_dcz_temp_wo, 2);
    NM_dcz_wo{i, 1} = sum(NM_dcz_temp_wo, 2); NM_dcz_wo{i, 2} = size(NM_dcz_temp_wo, 2);
    M_dcz_wo{i, 1} = sum(M_dcz_temp_wo, 2); M_dcz_wo{i, 2} = size(M_dcz_temp_wo, 2);
    T_dcz_wo{i, 1} = sum(T_dcz_temp_wo, 2); T_dcz_wo{i, 2} = size(T_dcz_temp_wo, 2);
    H_dcz_wo{i, 1} = sum(H_dcz_temp_wo, 2); H_dcz_wo{i, 2} = size(H_dcz_temp_wo, 2);

    all_post{i, 1} = sum(all_post_temp, 2); all_post{i, 2} = size(all_post_temp, 2);
    NM_post{i, 1} = sum(NM_post_temp, 2); NM_post{i, 2} = size(NM_post_temp, 2);
    M_post{i, 1} = sum(M_post_temp, 2); M_post{i, 2} = size(M_post_temp, 2);
    T_post{i, 1} = sum(T_post_temp, 2); T_post{i, 2} = size(T_post_temp, 2);
    H_post{i, 1} = sum(H_post_temp, 2); H_post{i, 2} = size(H_post_temp, 2);

    % proportion of NM, M, T, H trials
    proportion_pre_wo{i} = [NM_pre_wo{i, 2} / all_pre_wo{i, 2}, M_pre_wo{i, 2} / all_pre_wo{i, 2}, T_pre_wo{i, 2} / all_pre_wo{i, 2}, H_pre_wo{i, 2} / all_pre_wo{i, 2}];
    proportion_pre_w{i} = [NM_pre_w{i, 2} / all_pre_w{i, 2}, M_pre_w{i, 2} / all_pre_w{i, 2}, T_pre_w{i, 2} / all_pre_w{i, 2}, H_pre_w{i, 2} / all_pre_w{i, 2}];
    proportion_dcz_w{i} = [NM_dcz_w{i, 2} / all_dcz_w{i, 2}, M_dcz_w{i, 2} / all_dcz_w{i, 2}, T_dcz_w{i, 2} / all_dcz_w{i, 2}, H_dcz_w{i, 2} / all_dcz_w{i, 2}];
    proportion_dcz_wo{i} = [NM_dcz_wo{i, 2} / all_dcz_wo{i, 2}, M_dcz_wo{i, 2} / all_dcz_wo{i, 2}, T_dcz_wo{i, 2} / all_dcz_wo{i, 2}, H_dcz_wo{i, 2} / all_dcz_wo{i, 2}];
    proportion_post{i} = [NM_post{i, 2} / all_post{i, 2}, M_post{i, 2} / all_post{i, 2}, T_post{i, 2} / all_post{i, 2}, H_post{i, 2} / all_post{i, 2}];
    
    fig = figure('Position', [50 50 1500 500]);
    subplot(1, 5, 1)
    if ~strcmp(exptype, 'ZI')
        X = categorical({'Pre', 'Pre (W+CF)','Pre (DCZ)','Post'});
        X = reordercats(X,{'Pre', 'Pre (W+CF)','Pre (DCZ)','Post'});
        b = bar(X, [proportion_pre_w{i}; proportion_pre_wo{i}; proportion_dcz_w{i}; proportion_post{i}], 'stacked'); 
        b(1).FaceColor = '#47B3B1';
        b(2).FaceColor = '#005887'; 
        b(3).FaceColor = '#E39559';
    elseif strcmp(exptype, 'ZI')
        X = categorical({'W', 'W+CF','W (DCZ)','W+CF (DCZ)'});
        X = reordercats(X,{'W', 'W+CF','W (DCZ)','W+CF (DCZ)'});
        b = bar(X, [proportion_pre_w{i}; proportion_pre_wo{i}; proportion_dcz_w{i}; proportion_dcz_wo{i}], 'stacked'); 
        b(1).FaceColor = '#47B3B1';
        b(2).FaceColor = '#005887'; 
        b(3).FaceColor = '#E39559';
    end

    subplot(1, 5, 2)
    plot(smooth(all_pre_w{i, 1}/all_pre_w{i, 2}, 5), 'Color', '#9E4500', 'LineWidth', 2)
    hold on
    plot(smooth(NM_pre_w{i, 1}/all_pre_w{i, 2}, 5), 'Color', '#47B3B1', 'LineWidth', 2)
    plot(smooth(M_pre_w{i, 1}/all_pre_w{i, 2}, 5), 'Color',  '#005887', 'LineWidth', 2)
    plot(smooth(T_pre_w{i, 1}/all_pre_w{i, 2}, 5), 'Color', '#E39559', 'LineWidth', 2)
    xline(310)
    xticks([0 15.5 31 46.5 62 77.5 93 108.5 124 139.5 155 170.5 186 201.5 217 232.5 248 263.5 279 294.5 310 325.5 341 356.5 372 387.5 403 418.5 434 449.5 465 480.5 496 511.5 527 542.5 558 573.5 589 604.5 620])
    xticklabels([-10000 -9500 -9000 -8500 -8000 -7500 -7000 -6500 -6000 -5500 -5000 -4500 -4000 -3500 -3000 -2500 -2000 -1500 -1000 -500 0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 10000])
    xlabel('msec')
    xlim([window(1), window(2)])
    ylim([0 1])
    title('Pre (W)')

    subplot(1, 5, 3)
    plot(smooth(all_pre_wo{i, 1}/all_pre_wo{i, 2}, 5), 'Color', '#9E4500', 'LineWidth', 2)
    hold on
    plot(smooth(NM_pre_wo{i, 1}/all_pre_wo{i, 2}, 5), 'Color', '#47B3B1', 'LineWidth', 2)
    plot(smooth(M_pre_wo{i, 1}/all_pre_wo{i, 2}, 5), 'Color',  '#005887', 'LineWidth', 2)
    plot(smooth(T_pre_wo{i, 1}/all_pre_wo{i, 2}, 5), 'Color', '#E39559', 'LineWidth', 2)
    xline(310)
    xticks([0 15.5 31 46.5 62 77.5 93 108.5 124 139.5 155 170.5 186 201.5 217 232.5 248 263.5 279 294.5 310 325.5 341 356.5 372 387.5 403 418.5 434 449.5 465 480.5 496 511.5 527 542.5 558 573.5 589 604.5 620])
    xticklabels([-10000 -9500 -9000 -8500 -8000 -7500 -7000 -6500 -6000 -5500 -5000 -4500 -4000 -3500 -3000 -2500 -2000 -1500 -1000 -500 0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 10000])
    xlabel('msec')
    xlim([window(1), window(2)])
    ylim([0 1])
    title('Pre (W+CF)')


    subplot(1, 5, 4)
    plot(smooth(all_dcz_w{i, 1}/all_dcz_w{i, 2}, 5), 'Color', '#9E4500', 'LineWidth', 2)
    hold on
    plot(smooth(NM_dcz_w{i, 1}/all_dcz_w{i, 2}, 5), 'Color', '#47B3B1', 'LineWidth', 2)
    plot(smooth(M_dcz_w{i, 1}/all_dcz_w{i, 2}, 5), 'Color',  '#005887', 'LineWidth', 2)
    plot(smooth(T_dcz_w{i, 1}/all_dcz_w{i, 2}, 5), 'Color', '#E39559', 'LineWidth', 2)
    xline(310)
    xticks([0 15.5 31 46.5 62 77.5 93 108.5 124 139.5 155 170.5 186 201.5 217 232.5 248 263.5 279 294.5 310 325.5 341 356.5 372 387.5 403 418.5 434 449.5 465 480.5 496 511.5 527 542.5 558 573.5 589 604.5 620])
    xticklabels([-10000 -9500 -9000 -8500 -8000 -7500 -7000 -6500 -6000 -5500 -5000 -4500 -4000 -3500 -3000 -2500 -2000 -1500 -1000 -500 0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 10000])
    xlabel('msec')
    xlim([window(1), window(2)])    
    ylim([0 1])
    if ~strcmp(exptype, 'ZI')
        title('Pre (DCZ)')
    elseif strcmp(exptype, 'ZI')
        title('W (DCZ)')
    end


    subplot(1, 5, 5)
    if ~strcmp(exptype, 'ZI')
        plot(smooth(all_post{i, 1}/all_post{i, 2}, 5), 'Color', '#9E4500', 'LineWidth', 2)
        hold on
        plot(smooth(NM_post{i, 1}/all_post{i, 2}, 5), 'Color', '#47B3B1', 'LineWidth', 2)
        plot(smooth(M_post{i, 1}/all_post{i, 2}, 5), 'Color',  '#005887', 'LineWidth', 2)
        plot(smooth(T_post{i, 1}/all_post{i, 2}, 5), 'Color', '#E39559', 'LineWidth', 2)
        xline(310)
        xticks([0 15.5 31 46.5 62 77.5 93 108.5 124 139.5 155 170.5 186 201.5 217 232.5 248 263.5 279 294.5 310 325.5 341 356.5 372 387.5 403 418.5 434 449.5 465 480.5 496 511.5 527 542.5 558 573.5 589 604.5 620])
        xticklabels([-10000 -9500 -9000 -8500 -8000 -7500 -7000 -6500 -6000 -5500 -5000 -4500 -4000 -3500 -3000 -2500 -2000 -1500 -1000 -500 0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 10000])
        xlabel('msec')
        xlim([window(1), window(2)])   
        ylim([0 1])
        title('Post')
        legend({'All', 'Rest', 'Run', 'Transition'})
    elseif strcmp(exptype, 'ZI')
        plot(smooth(all_dcz_wo{i, 1}/all_dcz_wo{i, 2}, 5), 'Color', '#9E4500', 'LineWidth', 2)
        hold on
        plot(smooth(NM_dcz_wo{i, 1}/all_dcz_wo{i, 2}, 5), 'Color', '#47B3B1', 'LineWidth', 2)
        plot(smooth(M_dcz_wo{i, 1}/all_dcz_wo{i, 2}, 5), 'Color',  '#005887', 'LineWidth', 2)
        plot(smooth(T_dcz_wo{i, 1}/all_dcz_wo{i, 2}, 5), 'Color', '#E39559', 'LineWidth', 2)
        xline(310)
        xticks([0 15.5 31 46.5 62 77.5 93 108.5 124 139.5 155 170.5 186 201.5 217 232.5 248 263.5 279 294.5 310 325.5 341 356.5 372 387.5 403 418.5 434 449.5 465 480.5 496 511.5 527 542.5 558 573.5 589 604.5 620])
        xticklabels([-10000 -9500 -9000 -8500 -8000 -7500 -7000 -6500 -6000 -5500 -5000 -4500 -4000 -3500 -3000 -2500 -2000 -1500 -1000 -500 0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 10000])
        xlabel('msec')
        xlim([window(1), window(2)])   
        ylim([0 1])
        title('W+CF (DCZ)')
        legend({'All', 'Rest', 'Run', 'Transition'})
    end

    if strcmp(exptype, 'whiskerOptoTet')
        title('RWSCF')
    elseif strcmp(exptype, 'whiskerTet')
        title('RWS')
    elseif strcmp(exptype, 'whiskerOptoTet_DREADD')
        title('RWSCF + DREADD')
    elseif strcmp(exptype, 'whiskerTet_DREADD')
        title('RWS + DREADD')
    elseif strcmp(exptype, 'whiskerOptoTet_JAWS')
        title('RWSCF + JAWS')
    elseif strcmp(exptype, 'control_JAWS')
        title('JAWS')
    elseif strcmp(exptype, 'control_DREADD')
        title('DREADD')
    elseif strcmp(exptype, 'ZI')
        title('ZI')
    end

    if ~strcmp(showeach, 'showeach')
        close(fig)
    end

end

clearvars -except btsummary proportion_pre_w proportion_pre_wo proportion_dcz_w proportion_dcz_wo proportion_post nMice all_pre_w all_pre_wo

if strcmp(btsummary, 'btsummaryplot')
traces_pre_w = zeros(nMice, length(all_pre_w{1, 1}));
traces_pre_wo = zeros(nMice, length(all_pre_wo{1, 1}));
for i = 1:nMice
    traces_pre_w(i, :) = smooth(all_pre_w{i, 1}, 5)/all_pre_w{i,2};
    traces_pre_wo(i, :) = smooth(all_pre_wo{i, 1}, 5)/all_pre_wo{i,2};
end

findnan = isnan(traces_pre_wo(:, 1));
traces_pre_w = traces_pre_w(~findnan, :);
traces_pre_wo = traces_pre_wo(~findnan, :);

% Calculate the mean and SEM for the two traces
mean_w = mean(traces_pre_w, 1);
mean_wo = mean(traces_pre_wo, 1);

sem_w = std(traces_pre_w, 0, 1) / sqrt(size(traces_pre_w, 1));
sem_wo = std(traces_pre_wo, 0, 1) / sqrt(size(traces_pre_wo, 1));

time = 1:size(traces_pre_w, 2);
figure;
hold on;

% Plot shaded SEM for 'w'
fill([time, fliplr(time)], [mean_w - sem_w, fliplr(mean_w + sem_w)], 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Plot mean trace for 'w'
plot(time, mean_w, 'b', 'LineWidth', 2);

% Plot shaded SEM for 'wo'
fill([time, fliplr(time)], [mean_wo - sem_wo, fliplr(mean_wo + sem_wo)], 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Plot mean trace for 'wo'
plot(time, mean_wo, 'r', 'LineWidth', 2);

% Add labels, title, and legend
xlabel('Time');
ylabel('Signal Amplitude');
title('Mean Trace with Shaded SEM');
legend('W SEM', 'Mean W', 'WO SEM', 'Mean WO');

hold off;


% Plot summary data (basic transmission)
prop_rest_w = zeros(nMice, 1);
prop_run_w = zeros(nMice, 1);
prop_transition_w = zeros(nMice, 1);
prop_rest_w_cf = zeros(nMice, 1);
prop_run_w_cf = zeros(nMice, 1);
prop_transition_w_cf = zeros(nMice, 1);
for i = 1:nMice
    prop_rest_w(i) = proportion_pre_w{i}(1);
    prop_run_w(i) = proportion_pre_w{i}(2);
    prop_transition_w(i) = proportion_pre_w{i}(3);

    prop_rest_w_cf(i) = proportion_pre_wo{i}(1);
    prop_run_w_cf(i) = proportion_pre_wo{i}(2);
    prop_transition_w_cf(i) = proportion_pre_wo{i}(3);

end

prop_transition_w = prop_rest_w./prop_transition_w;
prop_transition_w_cf = prop_rest_w_cf./prop_transition_w_cf;

% Get rid of mice that don't have W+CF stim trials
findnans = isnan(prop_transition_w_cf);
prop_transition_w(findnans) = NaN;

% Define x-values for the two sets of points
x1 = 1; % x-value for prop_transition_w
x2 = 2; % x-value for prop_transition_w_cf

% Number of points
n = length(prop_transition_w); 

% Create figure and plot
figure;

% Plot points for prop_transition_w at x1
plot(repmat(x1, n, 1), prop_transition_w, 'o', 'MarkerFaceColor', 'b'); 
hold on;

% Plot points for prop_transition_w_cf at x2
plot(repmat(x2, n, 1), prop_transition_w_cf, 'o', 'MarkerFaceColor', 'r'); 

% Draw lines between the points
for i = 1:n
    plot([x1 x2], [prop_transition_w(i) prop_transition_w_cf(i)], 'k-');
end

% Add labels and formatting
xticks([x1 x2]);
xticklabels({'prop\_transition\_w', 'prop\_transition\_w\_cf'});
xlabel('Condition');
ylabel('Values');
title('Transition Comparison');
hold off;

end

proportion_mot_trials.proportion_pre_w = proportion_pre_w;
proportion_mot_trials.proportion_pre_wo = proportion_pre_wo;
proportion_mot_trials.proportion_dcz_w = proportion_dcz_w;
proportion_mot_trials.proportion_dcz_wo = proportion_dcz_wo;
proportion_mot_trials.proportion_post = proportion_post;

end
