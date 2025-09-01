function [PN_potentiate, PN_depress, UC_potentiate, UC_depress] = findneurons(motiontype, celltype, allData, mouse, choosesignal, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg, evoked_win)

trialType = allData.data{mouse}.trialType;
cellType = allData.data{mouse}.cellType;
tetPeriod = allData.data{mouse}.tetPeriod;
dczPeriod = allData.data{mouse}.dczPeriod;
motionType = allData.data{mouse}.trialmotType;

if strcmp(motiontype, 'all')
    pre_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ');
    pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
    post_DCZ_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ');
    post_tet_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W');
else
    pre_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, motiontype);
    pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, motiontype);
    post_DCZ_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ') & strcmp(motionType, motiontype);
    post_tet_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(motionType, motiontype);
end


if strcmp(choosesignal, 'golaysignal4')
    signal = allData.data{mouse}.golaysignal4;
elseif strcmp(choosesignal, 'golaysignal3')
    signal = allData.data{mouse}.golaysignal3;
elseif strcmp(choosesignal, 'golaysignal2')
    signal = allData.data{mouse}.golaysignal2;
elseif strcmp(choosesignal, 'golaysignal')
    signal = allData.data{mouse}.golaysignal;
elseif strcmp(choosesignal, 'evokedtraces')
    signal = allData.data{mouse}.evokedtraces;
elseif strcmp(choosesignal, 'evokedtraces2')
    signal = allData.data{mouse}.evokedtraces2;
elseif strcmp(choosesignal, 'golayshift')
    signal = allData.data{mouse}.golaysignal;
elseif strcmp(choosesignal, 'spont_rate_norm')
    signal = allData.data{mouse}.spont_rate_norm;
elseif strcmp(choosesignal, 'spont_rate')
    signal = allData.data{mouse}.spont_rate;
elseif strcmp(choosesignal, 'spont_rate_running')
    signal = allData.data{mouse}.spont_rate_running;
end

if length(size(signal)) == 3

    [nFrames, nCells, nTrials] = size(signal);
    
    % If baseline shift... 
        %   1) reject traces with mean signal in baselineshiftperiod above baseline_reject_thresh(2) (if ~isnan(baseline_reject_thresh(1)))
        %   2) subtract mean signal in baselineshiftperiod from remaining traces
        if ~isnan(baselineshift)
            for i = 1:nCells
                for j=1:nTrials
                    temp = signal(:, i, j);
                    getbaseline = temp(baselineshiftperiod(1):baselineshiftperiod(2));
                    getbaseline = mean(getbaseline);
                    if ~isnan(baseline_reject_thresh(1))
                        if getbaseline >= baseline_reject_thresh(2)
                            signal(:, i, j) = NaN;
                        else
                            signal(:, i, j) = temp - getbaseline;
                        end
                    else
                        signal(:, i, j) = temp - getbaseline;
                    end
                end
            end
        end
    
    %cells = strcmp(cellType, celltype);
        
    pre_wo = signal(:, :, pre_wo_trials);
    pre = signal(:, :, pre_trials);
    pre_DCZ = signal(:, :, post_DCZ_trials);
    post = signal(:, :, post_tet_trials);
    
    if trialavg
        pre_wo = mean(pre_wo, 3, 'omitnan');
        pre = mean(pre, 3, 'omitnan');
        pre_DCZ = mean(pre_DCZ, 3, 'omitnan');
        post = mean(post, 3, 'omitnan');
    end

    pre = pre(evoked_win(1):evoked_win(2), :);
    post = post(evoked_win(1):evoked_win(2), :);

    PN_potentiate = zeros(nCells, 1);
    PN_depress = zeros(nCells, 1);
    UC_potentiate  = zeros(nCells, 1);
    UC_depress  = zeros(nCells, 1);

    for i = 1:nCells
        auc_pre = trapz(pre(:, i));
        auc_post = trapz(post(:, i));

        diff = auc_post - auc_pre;

        if strcmp(cellType(i), 'PN') && diff > 0
            PN_potentiate(i) = 1;
        elseif strcmp(cellType(i), 'PN') && diff < 0
            PN_depress(i) = 1;
        elseif strcmp(cellType(i), 'UC') && diff > 0
            UC_potentiate(i) = 1;
        elseif strcmp(cellType(i), 'UC') && diff < 0
            UC_depress(i) = 1;
        end

    end

    getcells = auc_post - auc_pre;




elseif length(size(signal)) == 2
    [nCells, nTrials] = size(signal);
    
    cells = strcmp(cellType, celltype);
        
    pre_wo = signal(cells, pre_wo_trials);
    pre = signal(cells, pre_trials);
    pre_DCZ = signal(cells, post_DCZ_trials);
    post = signal(cells, post_tet_trials);
    
    if trialavg
        pre_wo = mean(pre_wo, 2, 'omitnan');
        pre = mean(pre, 2, 'omitnan');
        pre_DCZ = mean(pre_DCZ, 2, 'omitnan');
        post = mean(post, 2, 'omitnan');
    end

    

end

end