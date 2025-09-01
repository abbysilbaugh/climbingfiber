keep = ones(134, 1);
keep(17) = 0;
keep(99) = 0;
keep = logical(keep);

%%
load('007_023_000_percentilevalues.mat')
percentileValues = percentileValues(:, keep);
percentileValues_std = percentileValues_std(:, keep);

load('007_023_abstime.mat')
absolutetime = absolutetime(keep, :);

load('20240723_DREADDtrialinfo.mat')
trialDataStruct.rawTrialNum = trialDataStruct.rawTrialNum(keep);
trialDataStruct.trialNum = trialDataStruct.trialNum(keep);
trialDataStruct.whisker = trialDataStruct.whisker(keep);
trialDataStruct.opto = trialDataStruct.opto(keep);
trialDataStruct.whiskerOpto = trialDataStruct.whiskerOpto(keep);
trialDataStruct.tet = trialDataStruct.tet(keep);
trialDataStruct.firstPostTetTrial = trialDataStruct.firstPostTetTrial(keep);
trialDataStruct.postTetTrial = trialDataStruct.postTetTrial(keep);
trialDataStruct.postDCZTrial = trialDataStruct.postDCZTrial(keep);

load('20240723_motion_confound.mat')
motionConfounds = motionConfounds(keep);
motionData = motionData(:, keep);

load('20240723_signal.mat')
ACimage_signal = ACimage_signal(:, :, keep);
signal = signal(:, :, keep);

%%
save('007_023_000_percentilevalues.mat', 'percentileValues', 'percentileValues_std')
save('007_023_abstime.mat', 'absolutetime')
save('20240723_DREADDtrialinfo.mat', 'trialDataStruct')
save('20240723_motion_confound.mat', 'motionConfounds', 'motionData')
save('20240723_signal.mat', 'ACimage_signal', 'signal')
