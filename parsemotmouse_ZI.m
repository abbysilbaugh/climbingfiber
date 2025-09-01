function [pre, pre_wo, pre_DCZ, pre_DCZ_wo] = parsemotmouse_ZI(motiontype, allData, mouse,  trialavg, choosemottype)

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
    wo_DCZ_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'DCZ');
    DCZ_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ');
else
    pre_wo_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, motiontype);
    pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motionType, motiontype);
    wo_DCZ_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'DCZ') & strcmp(motionType, motiontype);
    DCZ_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ') & strcmp(motionType, motiontype);
end

    
pre_wo = signal(:, pre_wo_trials);
pre = signal(:, pre_trials);
pre_DCZ = signal(:, DCZ_trials);
pre_DCZ_wo = signal(:, wo_DCZ_trials);

if trialavg
    pre_wo = mean(pre_wo, 2, 'omitnan');
    pre = mean(pre, 2, 'omitnan');
    pre_DCZ = mean(pre_DCZ, 2, 'omitnan');
    pre_DCZ_wo = mean(pre_DCZ_wo, 2, 'omitnan');
end


end