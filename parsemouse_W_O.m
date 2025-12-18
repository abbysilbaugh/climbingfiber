function [pre, pre_o, pre_DCZ, post] = parsemouse_W_O(motiontype, celltype, allData, mouse, choosesignal, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg)

trialType = allData.data{mouse}.trialType;
cellType = allData.data{mouse}.cellType;
tetPeriod = allData.data{mouse}.tetPeriod;
dczPeriod = allData.data{mouse}.dczPeriod;
motionType = allData.data{mouse}.trialmotType;

if strcmp(motiontype, 'all')
    pre_o_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'O') & strcmp(dczPeriod, 'NO DCZ');
    pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
    post_DCZ_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ');
    post_tet_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W');
elseif strcmp(motiontype, 'MT')
    pre_o_trials_M = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'O') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, 'M');
    pre_trials_M = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, 'M');
    post_DCZ_trials_M = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ') & strcmp(motionType, 'M');
    post_tet_trials_M = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(motionType, 'M');

    pre_o_trials_T = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'O') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, 'T');
    pre_trials_T = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, 'T');
    post_DCZ_trials_T = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ') & strcmp(motionType, 'T');
    post_tet_trials_T = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(motionType, 'T');

    pre_o_trials = logical(pre_o_trials_M + pre_o_trials_T);
    pre_trials = logical(pre_trials_M + pre_trials_T);
    post_DCZ_trials = logical(post_DCZ_trials_M + post_DCZ_trials_T);
    post_tet_trials = logical(post_tet_trials_M + post_tet_trials_T);
else
    pre_o_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'O') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, motiontype);
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
elseif strcmp(choosesignal, 'spont_rate_rest')
    signal = allData.data{mouse}.spont_rate_rest;
elseif strcmp(choosesignal, 'reltime')
    signal = allData.data{mouse}.reltime;
elseif strcmp(choosesignal, 'evokedtraces_settime')
    signal = allData.data{mouse}.evokedtraces_settime;
elseif strcmp(choosesignal, 'golaysignal3_settime')
    signal = allData.data{mouse}.golaysignal3_settime;
elseif strcmp(choosesignal, 'evokedtraces_settime2')
    signal = allData.data{mouse}.evokedtraces_settime2;
elseif strcmp(choosesignal, 'golaysignal3_settime2')
    signal = allData.data{mouse}.golaysignal3_settime2;
elseif strcmp(choosesignal, 'b_oasis')
    signal = allData.data{mouse}.b_oasis;
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
    
    cells = strcmp(cellType, celltype);
        
    pre_o = signal(:, cells, pre_o_trials);
    pre = signal(:, cells, pre_trials);
    pre_DCZ = signal(:, cells, post_DCZ_trials);
    post = signal(:, cells, post_tet_trials);
    
    if trialavg
        pre_o = mean(pre_o, 3, 'omitnan');
        pre = mean(pre, 3, 'omitnan');
        pre_DCZ = mean(pre_DCZ, 3, 'omitnan');
        post = mean(post, 3, 'omitnan');
    end

elseif length(size(signal)) == 2
    [nCells, nTrials] = size(signal);
    
    cells = strcmp(cellType, celltype);
        
    pre_o = signal(cells, pre_o_trials);
    pre = signal(cells, pre_trials);
    pre_DCZ = signal(cells, post_DCZ_trials);
    post = signal(cells, post_tet_trials);
    
    if trialavg
        pre_o = mean(pre_o, 2, 'omitnan');
        pre = mean(pre, 2, 'omitnan');
        pre_DCZ = mean(pre_DCZ, 2, 'omitnan');
        post = mean(post, 2, 'omitnan');
    end

end

end