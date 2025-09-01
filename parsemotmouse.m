function [pre, pre_wo, pre_DCZ, post] = parsemotmouse(motiontype, allData, mouse, trialavg, choosemottype)

    if strcmp(choosemottype, 'motionInfo')
        signal = allData.data{mouse}.motionInfo;
        motionType = allData.data{mouse}.trialmotType;
    elseif strcmp(choosemottype, 'motionInfo_settime')
        signal = allData.data{mouse}.motionInfo_settime;
        motionType = allData.data{mouse}.trialmotType_settime;
    elseif strcmp(choosemottype, 'motionInfo_settime2')
        signal = allData.data{mouse}.motionInfo_settime2;
        motionType = allData.data{mouse}.trialmotType_settime2;
    end

    trialType = allData.data{mouse}.trialType;
    tetPeriod = allData.data{mouse}.tetPeriod;
    dczPeriod = allData.data{mouse}.dczPeriod;

     % Ignore NaN trials (outside time window of analysis)
    idxs = signal(1, :);
    idxs = ~isnan(idxs);

    signal = signal(:, idxs);
    motionType = motionType(idxs);
    tetPeriod = tetPeriod(idxs);
    trialType = trialType(idxs);
    dczPeriod = dczPeriod(idxs);

if strcmp(motiontype, 'all')
    pre_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ');
    pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
    post_DCZ_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ');
    post_tet_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W');
elseif strcmp(motiontype, 'MT')
    pre_wo_trials_M = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, 'M');
    pre_trials_M = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, 'M');
    post_DCZ_trials_M = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ') & strcmp(motionType, 'M');
    post_tet_trials_M = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(motionType, 'M');

    pre_wo_trials_T = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, 'T');
    pre_trials_T = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, 'T');
    post_DCZ_trials_T = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ') & strcmp(motionType, 'T');
    post_tet_trials_T = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(motionType, 'T');

    pre_wo_trials = logical(pre_wo_trials_M + pre_wo_trials_T);
    pre_trials = logical(pre_trials_M + pre_trials_T);
    post_DCZ_trials = logical(post_DCZ_trials_M + post_DCZ_trials_T);
    post_tet_trials = logical(post_tet_trials_M + post_tet_trials_T);
else
    pre_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, motiontype);
    pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, motiontype);
    post_DCZ_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ') & strcmp(motionType, motiontype);
    post_tet_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(motionType, motiontype);
end

for i = 1:size(signal, 2)
    temp = signal(:, i);
    temp = smooth(temp, 5);
    signal(:, i) = temp;
end
        
    pre_wo = signal(:, pre_wo_trials);
    pre = signal(:, pre_trials);
    pre_DCZ = signal(:, post_DCZ_trials);
    post = signal(:, post_tet_trials);
    
    if trialavg
        pre_wo = mean(pre_wo, 2, 'omitnan');
        pre = mean(pre, 2, 'omitnan');
        pre_DCZ = mean(pre_DCZ, 2, 'omitnan');
        post = mean(post, 2, 'omitnan');
    end

end