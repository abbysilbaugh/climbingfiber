function [pre_comb, post] = parsemouse3_v2(motiontype, celltype, allData, mouse, choosesignal, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg)

trialType = allData.data{mouse}.trialType;
cellType = allData.data{mouse}.cellType;
tetPeriod = allData.data{mouse}.tetPeriod;
motionType = allData.data{mouse}.trialmotType;
dczPeriod = allData.data{mouse}.dczPeriod;

if strcmp(motiontype, 'all')
    pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
    dcz_trials = strcmp(dczPeriod, 'DCZ') & strcmp(trialType, 'W');
else
    pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, motiontype);
    dcz_trials = strcmp(dczPeriod, 'DCZ') & strcmp(trialType, 'W') & strcmp(motionType, motiontype);
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
        
    pre_comb = signal(:, cells, pre_trials);
    post = signal(:, cells, dcz_trials);
    
    if trialavg
        pre_comb = mean(pre_comb, 3, 'omitnan');
        post = mean(post, 3, 'omitnan');
    end

elseif length(size(signal)) == 2
    [nCells, nTrials] = size(signal);
    
    cells = strcmp(cellType, celltype);
        
    pre_comb = signal(cells, pre_trials);
    post = signal(cells, dcz_trials);
    
    if trialavg
        pre_comb = mean(pre_comb, 2, 'omitnan');
        post = mean(post, 2, 'omitnan');
    end

end

end