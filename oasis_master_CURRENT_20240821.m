%% ANALYSIS PIPELINE
% Run from 
% C:/Users/silbaugh/Desktop/Abby folder
% Only 'figs' folder can exist in 20230516_analysis folder

%% ADD DEFAULT STIMULUS ARTIFACT FRAMES FOR NEW MICE
% % artifactframes = [312];
% % save('20250103_artifactframes.mat', 'artifactframes')
%% COMPILE DATA
clear all
addpath('20230516_analysis');
allData = compileDataset;

%% MANUALLY INSPECT ARTIFACT

% removeartifact
%%
allData = removetettrials(allData);
%% REMOVE ARTIFACT

allData = interpartifact_new(allData, NaN);
allData = interpbaselineartifact(allData, 'noplot'); 

%%
% visualizeartifactremoval(allData)
%% BACKGROUND SUBTRACT

allData = backgroundsubtract(allData, 'noplot');

%%
% visualizerawdata(allData)
% visualizerawdata_eachcell(allData, 36, 'rawminusfirstprctile') % ac_bs_signal or rawminusfirstprctile
%% SMOOTH AND EXPRESS AS dF/F0 
b_percent = 1;
sliding_window_size = 10;
smooth_win = 15;

allData = getGOLAY_new(allData, 1, 10, 15, 'rawminusfirstprctile');

%%
baselineshiftperiod = [300, 305];
baselineshift = 1;
baseline_reject_thresh = 0.5;

% visualizesmoothing(allData)
% visualizesmoothing_individualneurons(allData, 47, 'golaysignal3', [-0.5, 2], [279 372],...
    %'ploteachtrial', 'all', baselineshiftperiod, baselineshift, baseline_reject_thresh);
%% PROCESS MOTION DATA (REST, RUNNING; M, NM, T, H TRIALS) (OPTIMIZE!)

allData = getrest(allData, 12);

NM_thresh = [0, 0];
T_thresh = [0, 1]; 
M_thresh = [1, 1];
H_thresh = [1, 0];

% [allData] = gettransition(allData, [298 310], [310 322], NM_thresh, T_thresh, M_thresh, H_thresh);
[allData] = gettransition(allData, [304 310], [310 316], NM_thresh, T_thresh, M_thresh, H_thresh, 'noplot');
%%
visualizemotion(allData, 'all', [304 310], [310 316], 'noeach')
%%
visualizemotion_byperiod(allData, [279, 372], 'noeach')
%% CALCULATE BASELINE NOISE (σ) and SNR
noise_prc = 5; % changed from 15 20240821

[baselineNoise, SNR] = getbaselinenoise_fast(allData, 15, 95, 'golaysignal', 10);
[baselineNoise2, SNR2] = getbaselinenoise_fast(allData, noise_prc, 95, 'golaysignal2', 10);
[baselineNoise3, SNR3] = getbaselinenoise_fast(allData, noise_prc, 95, 'golaysignal3', 10);
% [baselineNoise4, SNR4] = getbaselinenoise_fast(allData, 15, 95, 'golaysignal4', 10);

%% REMOVE UNUSED CELLS
% allData = removeunused(allData);
%%
[~] = visualizeSNR(allData, SNR, baselineNoise, 21);
[~] = visualizeSNR(allData, SNR2, baselineNoise2, 21);
[~] = visualizeSNR(allData, SNR3, baselineNoise3, 21);
% [~] = visualizeSNR(allData, SNR4, baselineNoise4, 21);

%% RUN OASIS
% changed from baselineNoise to baselineNoise3 20240821 

allData = runoasis(allData, baselineNoise3, false, 2, 'golaysignal3');
allData2 = runoasis(allData, baselineNoise2, false, 2, 'golaysignal2');
allData3 = runoasis(allData, baselineNoise3, false, 3, 'golaysignal3');

%% CORRELATE CELL WITH MOTION
[allData] = getcellxmotion(allData, 'motion', 'golayshift');
[allData] = cellxmotion_prepost(allData);
[allData] = getmotcells(allData, 0.1, 'correlation');
%%
% [~] = visualizemotioncorrelation(allData, 0.1, 50, 'PRE');

%% CALCULATE SPIKE RATE AND MEAN dF/F0 FOR SPONTANEOUS REST/RUN CONDITIONS

% Normalize by amount of motion in run period?
spontFrames = true(620, 1); spontFrames(310:372) = false;

[allData] = getspontinfo(allData, spontFrames);

%% SET CONTROL POST DATA
controlmice = []; %[24, 25, 38, 39, 36, 30, 32, 44];
allData = setcontrolpost(allData, controlmice);
allData2 = setcontrolpost(allData, controlmice);
allData3 = setcontrolpost(allData, controlmice);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIND PEAKS (OPTIMIZE!)
% changed from baselineNoise to baselineNoise3 20240821
peaks_thr = 3;
stim_onset = 310; % changed from 305, relevant only for first variables

[allData] = getpeaks_new(allData, peaks_thr, NaN, baselineNoise3, stim_onset, 'golayshift');
[allData2] = getpeaks_new(allData2, peaks_thr, NaN, baselineNoise2, stim_onset, 'golayshift');
[allData3] = getpeaks_new(allData3, peaks_thr, NaN, baselineNoise3, stim_onset, 'golayshift');

%%
std_thresh = 2;

[peak_win, spike_win] = visualizealleventsbymouse(allData, std_thresh);
[peak_win2, spike_win2] = visualizealleventsbymouse(allData2, std_thresh);
[peak_win3, spike_win3] = visualizealleventsbymouse(allData3, std_thresh);
%visualizepooledspikes(allData, 'PN', [310, 340], 'NM')
%visualizepooledpeaks(allData, 'PN', [310, 340], 'NM')
%visualizetrialavgpeaks(allData, baselineNoise3, 'PN', [310, 314])

%% GRAB EVENTS IN EVOKED PERIOD
% spike_win = [310 325]; % changed from 305, 320 9/8
% peak_win = [311 325]; % changed from 306, 335 9/8
[allData] = getwindowevents(allData, spike_win, peak_win);
[allData2] = getwindowevents(allData2, spike_win2, peak_win2);
[allData3] = getwindowevents(allData3, spike_win3, peak_win3);

%% GRAB EVOKED TRACES AND AMPLITUDES
    % Dependent on # spikes in window
    % getevokedtraces function corrected 20240821

[allData] = getevokedtraces(allData, spike_win);
[allData2] = getevokedtraces(allData2, spike_win2);
[allData3] = getevokedtraces(allData3, spike_win3);
%%
[allData] = getevokedtraces_bypeak(allData, peak_win); %[310, peak_win(2)]);
[allData2] = getevokedtraces_bypeak(allData2, peak_win); %[310, peak_win2(2)]);
[allData3] = getevokedtraces_bypeak(allData3, peak_win); %[310, peak_win3(2)]);
%%
visualizeevokedtraces(allData, 'all', 'evokedtraces2')
% visualizeevokedtraces(allData2, 'NM', 'evokedtraces2')
% visualizeevokedtraces(allData3, 'NM', 'evokedtraces2')
%%
%visualizeevokedtracesORcells(allData, 'NM', spike_win)
%visualizeevokedtracesORcells_DREADD(allData, 'NM', evoked_win)
%visualizeevokedtracesANDcells(allData, 'NM', evoked_win)
%visualizeevokedtraces_each(allData, 'NM', evoked_win, [310 387])
%visualizeamplitudedistribution(allData, 'NM', evoked_win, [310 387], 'amp', 'scatter') % 'amp', 'locs', 'scatter'

%% PARSE DATA
BT_mice = getBTmice(allData); % [1:54]; 

RWS_mice = [2, 3, 4, 5, 10, 11, 18, 20, 32, 34];
RWSCF_mice = [1, 6, 7, 8, 9, 13, 14, 15, 27, 28, 31];

RWSCF_PV_JAWS_mice = [35, 36, 37];
control_PV_JAWS_mice = 38;

RWSCF_PV_Gi_mice = [22, 23, 39];
control_PV_Gi_mice =  [24, 25, 40, 41];

RWS_PV_Gq_mice = [];
control_PV_Gq_mice = [];

RWSCF_SST_Gi_mice = [29, 42, 43, 44];
control_SST_Gi_mice = [30, 33, 46];

RWS_SST_Gq_mice = [19, 50, 51, 52];
control_SST_Gq_mice = [53, 54, 55];

RWSCF_VIP_Gq_mice = [56, 57, 58, 69];
control_VIP_Gq_mice = [61, 62, 63];

RWS_VIP_Gi_mice = [59, 60, 67];
control_VIP_Gi_mice = [64, 65, 70];

SST_Gi_ZI_mice = [47, 48];
PV_Gi_ZI_mice = [49, 66, 68];

mottype = 'all'; % 'all', 'NM', 'M', 'T'
tracetype = 'evokedtraces2'; % evokedtraces, evokedtraces2, golaysignal, golaysignal2, golaysignal3, golaysignal4

trialavg = true; % trial average each cell
cellavg = false; % average all cells together for each mouse
catmouse = true;
baselineshift = 1; %NaN or 1

[pre, pre_wo, ...
    RWS_pre, RWS_pre_wo, RWS_post, ...
    RWSCF_pre, RWSCF_pre_wo, RWSCF_post, ...
    RWSCF_PV_JAWS_pre, RWSCF_PV_JAWS_pre_wo, RWSCF_PV_JAWS_post, ...
    control_PV_JAWS_pre, control_PV_JAWS_pre_wo, control_PV_JAWS_post, ...
    RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_wo, RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, ...
    control_PV_Gi_pre, control_PV_Gi_pre_wo, control_PV_Gi_pre_dcz, control_PV_Gi_post, ...
    RWS_PV_Gq_pre, RWS_PV_Gq_pre_wo, RWS_PV_Gq_pre_dcz, RWS_PV_Gq_post, ...
    control_PV_Gq_pre, control_PV_Gq_pre_wo, control_PV_Gq_pre_dcz, control_PV_Gq_post, ...
    RWSCF_SST_Gi_pre, RWSCF_SST_Gi_pre_wo, RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, ...
    control_SST_Gi_pre, control_SST_Gi_pre_wo, control_SST_Gi_pre_dcz, control_SST_Gi_post, ... 
    RWS_SST_Gq_pre, RWS_SST_Gq_pre_wo, RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, ...
    control_SST_Gq_pre, control_SST_Gq_pre_wo, control_SST_Gq_pre_dcz, control_SST_Gq_post,...
    RWSCF_VIP_Gq_pre, RWSCF_VIP_Gq_pre_wo, RWSCF_VIP_Gq_pre_dcz, RWSCF_VIP_Gq_post, ...
    control_VIP_Gq_pre, control_VIP_Gq_pre_wo, control_VIP_Gq_pre_dcz, control_VIP_Gq_post, ... 
    RWS_VIP_Gi_pre, RWS_VIP_Gi_pre_wo, RWS_VIP_Gi_pre_dcz, RWS_VIP_Gi_post, ...
    control_VIP_Gi_pre, control_VIP_Gi_pre_wo, control_VIP_Gi_pre_dcz, control_VIP_Gi_post, ...
    SST_Gi_ZI_pre, SST_Gi_ZI_pre_wo, SST_Gi_ZI_pre_dcz, SST_Gi_ZI_pre_dcz_wo, ...
    PV_Gi_ZI_pre, PV_Gi_ZI_pre_wo, PV_Gi_ZI_pre_dcz, PV_Gi_ZI_pre_dcz_wo]...
    = parsetraces(baselineshiftperiod, baselineshift, baseline_reject_thresh, trialavg,...
    cellavg, catmouse, mottype, allData, tracetype, BT_mice, RWS_mice, RWSCF_mice, RWSCF_PV_JAWS_mice, control_PV_JAWS_mice, RWSCF_PV_Gi_mice, control_PV_Gi_mice, RWS_PV_Gq_mice, control_PV_Gq_mice, RWSCF_SST_Gi_mice, control_SST_Gi_mice, RWS_SST_Gq_mice, control_SST_Gq_mice, RWSCF_VIP_Gq_mice, control_VIP_Gq_mice, RWS_VIP_Gi_mice, control_VIP_Gi_mice, SST_Gi_ZI_mice, PV_Gi_ZI_mice);
%%
visualizeparsedtraces([300, 351], [-0.05, 1], 305, ...
    pre, pre_wo, ...
    RWS_pre, RWS_pre_wo, RWS_post, ...
    RWSCF_pre, RWSCF_pre_wo, RWSCF_post, ...
    RWSCF_PV_JAWS_pre, RWSCF_PV_JAWS_pre_wo, RWSCF_PV_JAWS_post, ...
    control_PV_JAWS_pre, control_PV_JAWS_pre_wo, control_PV_JAWS_post, ...
    RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_wo, RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, ...
    control_PV_Gi_pre, control_PV_Gi_pre_wo, control_PV_Gi_pre_dcz, control_PV_Gi_post, ...
    RWS_PV_Gq_pre, RWS_PV_Gq_pre_wo, RWS_PV_Gq_pre_dcz, RWS_PV_Gq_post, ...
    control_PV_Gq_pre, control_PV_Gq_pre_wo, control_PV_Gq_pre_dcz, control_PV_Gq_post, ...
    RWSCF_SST_Gi_pre, RWSCF_SST_Gi_pre_wo, RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, ...
    control_SST_Gi_pre, control_SST_Gi_pre_wo, control_SST_Gi_pre_dcz, control_SST_Gi_post, ... 
    RWS_SST_Gq_pre, RWS_SST_Gq_pre_wo, RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, ...
    control_SST_Gq_pre, control_SST_Gq_pre_wo, control_SST_Gq_pre_dcz, control_SST_Gq_post,...
    RWSCF_VIP_Gq_pre, RWSCF_VIP_Gq_pre_wo, RWSCF_VIP_Gq_pre_dcz, RWSCF_VIP_Gq_post, ...
    control_VIP_Gq_pre, control_VIP_Gq_pre_wo, control_VIP_Gq_pre_dcz, control_VIP_Gq_post, ... 
    RWS_VIP_Gi_pre, RWS_VIP_Gi_pre_wo, RWS_VIP_Gi_pre_dcz, RWS_VIP_Gi_post, ...
    control_VIP_Gi_pre, control_VIP_Gi_pre_wo, control_VIP_Gi_pre_dcz, control_VIP_Gi_post, ...
    SST_Gi_ZI_pre, SST_Gi_ZI_pre_wo, SST_Gi_ZI_pre_dcz, SST_Gi_ZI_pre_dcz_wo, ...
    PV_Gi_ZI_pre, PV_Gi_ZI_pre_wo, PV_Gi_ZI_pre_dcz, PV_Gi_ZI_pre_dcz_wo)

%% ZI
parseZI(allData, 49, 'PN');
% 47, 48, 49, 66, 68

%% PERCENT RESPONSIVE CELLS
norm = true;
getpercentresponsivecells(mottype, allData, tracetype, BT_mice, RWS_mice, RWSCF_mice, RWSCF_PV_JAWS_mice, control_PV_JAWS_mice, RWSCF_PV_Gi_mice, control_PV_Gi_mice, RWSCF_SST_Gi_mice, control_SST_Gi_mice, RWS_SST_Gq_mice, control_SST_Gq_mice, norm);

%% EVENT PROBABILITY
geteventprobability(mottype, allData, tracetype, BT_mice, RWS_mice, RWSCF_mice, RWSCF_PV_JAWS_mice, control_PV_JAWS_mice, RWSCF_PV_Gi_mice, control_PV_Gi_mice, RWSCF_SST_Gi_mice, control_SST_Gi_mice, RWS_SST_Gq_mice, control_SST_Gq_mice, norm);

%% SLOPES
%getslopes(mottype, allData, tracetype, BT_mice, RWS_mice, RWSCF_mice, RWSCF_PV_JAWS_mice, control_PV_JAWS_mice, RWSCF_PV_Gi_mice, control_PV_Gi_mice, RWSCF_SST_Gi_mice, control_SST_Gi_mice, RWS_SST_Gq_mice, control_SST_Gq_mice, norm);
getslopes_bymouse(mottype, allData, tracetype, BT_mice, RWS_mice, RWSCF_mice, RWSCF_PV_JAWS_mice, control_PV_JAWS_mice, RWSCF_PV_Gi_mice, control_PV_Gi_mice, RWSCF_SST_Gi_mice, control_SST_Gi_mice, RWS_SST_Gq_mice, control_SST_Gq_mice, norm); 

%% AMPLITUDES (EVOKED  EVENTS)
norm = false;
getevokedamplitudes(mottype, allData, tracetype, BT_mice, RWS_mice, RWSCF_mice, RWSCF_PV_JAWS_mice, control_PV_JAWS_mice, RWSCF_PV_Gi_mice, control_PV_Gi_mice, RWSCF_SST_Gi_mice, control_SST_Gi_mice, RWS_SST_Gq_mice, control_SST_Gq_mice, norm);
%getevokedamplitudes_bymouse(mottype, allData, tracetype, BT_mice, RWS_mice, RWSCF_mice, RWSCF_PV_JAWS_mice, control_PV_JAWS_mice, RWSCF_PV_Gi_mice, control_PV_Gi_mice, RWSCF_SST_Gi_mice, control_SST_Gi_mice, RWS_SST_Gq_mice, control_SST_Gq_mice, norm);
%% AUC









%% Obsolete code
% [allData] = getevokedtraces2(allData, evoked_win, baselineNoise3, 2);
% [allData2] = getevokedtraces2(allData2, evoked_win, baselineNoise2, 2);
% [allData3] = getevokedtraces2(allData3, evoked_win, baselineNoise3, 2);

% visualizewindowevents(allData, 'NM', 'PN')
% visualizewindowevents(allData2, 'NM', 'PN')
% visualizewindowevents(allData3, 'NM', 'PN')

%[allData] = getspktimes(allData);



% Not using getevokedtraces2 9/10/24
% [allData] = getevokedtraces2(allData, evoked_win, baselineNoise3, 2);
% [allData2] = getevokedtraces2(allData2, evoked_win, baselineNoise2, 2);
% [allData3] = getevokedtraces2(allData3, evoked_win, baselineNoise3, 2);


% remove NaN cells (cells not contained in both experimental conditions)
% [pre, pre_wo] = bothcond(pre, pre_wo);
% [RWS_pre, RWS_post] = bothcond(RWS_pre, RWS_post);
% [RWSCF_pre, RWSCF_post] = bothcond(RWSCF_pre, RWSCF_post);
% [RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_dcz1] = bothcond(RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_dcz);
% [RWSCF_PV_Gi_pre_dcz2, RWSCF_PV_Gi_post] = bothcond(RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post);
% [control_PV_Gi_pre, control_PV_Gi_pre_dcz1] = bothcond(control_PV_Gi_pre, control_PV_Gi_pre_dcz);
% [control_PV_Gi_pre_dcz2, control_PV_Gi_post] = bothcond(control_PV_Gi_pre_dcz, control_PV_Gi_post);
% [RWSCF_SST_Gi_pre, RWSCF_SST_Gi_pre_dcz1] = bothcond(RWSCF_SST_Gi_pre, RWSCF_SST_Gi_pre_dcz);
% [RWSCF_SST_Gi_pre_dcz2, RWSCF_SST_Gi_post] = bothcond(RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post);
% [control_SST_Gi_pre, control_SST_Gi_pre_dcz1] = bothcond(control_SST_Gi_pre, control_SST_Gi_pre_dcz);
% [control_SST_Gi_pre_dcz2, control_SST_Gi_post] = bothcond(control_SST_Gi_pre_dcz, control_SST_Gi_post);

%% PLOT BAR PLOTS
[increase_cells, decrease_cells, active_PRE_RWS, active_POST_RWS] = visualizebarplots_presentation(allData, 'all', evoked_win, [310 387], 'dots', [0 2]); % 'onlylines' or 'dots'
%visualizeviolinplots(allData, 'NM', evoked_win, [310 387], [0 8]);

%% PLOT ROIs
for i = 1:length(allData.data)
    ROIplot(allData, i, 'all', evoked_win, [310 387]);
end

%% Cross-corr
for i = 1:length(allData.data)
    crosscorr_prepost(allData, i, [310 320]);
end

%% Plot time series

for i = 1:length(allData.data)
    plottimeseries(allData2, i, 'PN', 'all')
end
%%

for i = 1:length(allData.data)
    plottimeseriesDREADD(allData, i, 'PN', 'all', [0 43000])
end

%% PCA
for i = 1:length(allData.data)
    ensemblePREPOST(allData, i, [1 620], [310 320])
end
%% Covariance calculation
for i = 1:length(allData.data)
    plotspontcov(allData, i, [1,310])
end

%% GRANT PLOT 05/15/24
grantplot(allData, 2, increase_cells{2}, decrease_cells{2}, active_PRE_RWS{2}, active_POST_RWS{2})
%crosscorr_grant(allData, 2, increase_cells{2}, [310 320])
%traces_grant(allData, active_PRE_RWS{2}, active_POST_RWS{2}, increase_cells{2}, decrease_cells{2}, true)
plot_ROI_FOV(allData, active_PRE_RWS{2}, active_POST_RWS{2})

% [~, ~, ~, ~] = visualizebarplots_grant(allData, 'NM', evoked_win, [310 330], 'dots', [0 3]); % 'onlylines' or 'dots'
% slope_grant(allData, active_PRE_RWS{2}, active_POST_RWS{2}, increase_cells{2}, decrease_cells{2}, true, [311 317])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%% CALCULATE MEAN, MAX, DIFF (dF/F0 AND MOTION) IN SPECIFIED WINDOW
frame_win = [310, 341];
[allData] = getmeanbefore(allData, [300 310]);
[allData] = getmean(allData, frame_win);
[allData] = getmaxinwin(allData, frame_win);
[allData] = getmeandiff(allData, [300 310], frame_win);

%% GUI to visualize traces
oasisGUI(allData);
%% Plot all traces from single experiment

plotalltraces_troubleshoot(allData, 1, 2, 'golaysignal2') % select range of mice
%% Exclusion criteria

SNRthresh = {false, 10};
SNRmin = {false, 1};
delta_b_oasis_thresh = {false, 5}; % Reject trace if baseline fluctuates
trace_b_thresh = {false, 0.5};
spike_after_peak = {false}; % reject trace if peak occurs before spike % CHANGED FROM FALSE 2/11/24
peak_win = {false, 10};
spike_win = {false, 10}; % CHANGED FROM 10 Nov 5, CHANGED FROM 4 2/11/24 (4)


[allData] = excludecellstraces(allData, SNR3, SNRthresh, SNRmin, delta_b_oasis_thresh, trace_b_thresh, spike_after_peak, peak_win, spike_win);

% End processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot sequential activation
get_trialType = 'W';
get_trialmotType = 'all'; % can be M, NM, T, H
get_var = 'golayshift';
exclude = false; % excludes traces/data based on exclusion criteria
get_cellType = 'all';
responsive_win = 15;

[pre_tet, vartype_pre] = grabdata(allData, get_cellType, 'all', get_trialType, get_trialmotType, 'PRE', 'NO DCZ', get_var, exclude);
[post_tet, vartype_post] = grabdata(allData, get_cellType, 'all', get_trialType, get_trialmotType, 'POST', 'NO DCZ', get_var, exclude);

grabsumresponsive = zeros(20, 2);
for i = 1:20
    Imouse = i;
    pre_traces = pre_tet{Imouse}; post_traces = post_tet{Imouse};
    pre_traces = mean(pre_traces,3); post_traces = mean(post_traces,3);
    nCells = size(pre_traces, 2);
    
    % Sort and Normalize
    [maxvals_pre, fpeak_pre] = max(pre_traces(310:end,:)); [maxvals_post, fpeak_post] = max(post_traces(310:end,:));
    grabsumresponsive(i, 1) = length(find(fpeak_pre < responsive_win))/length(fpeak_pre); grabsumresponsive(i, 2) = length(find(fpeak_post < responsive_win))/length(fpeak_post);
    [sorted_pre, I_pre] = sort(fpeak_pre); [sorted_post, I_post] = sort(fpeak_post);
    pre_traces = ((pre_traces - maxvals_pre) ./ range(pre_traces)); post_traces = ((post_traces - maxvals_post) ./ range(post_traces));
%     global_max = max(max(max(pre_traces,post_traces)));
%     pre_traces = pre_traces/global_max; post_traces = post_traces/global_max;
    % pre_traces = (pre_traces - maxvals_pre) ./ range(pre_traces); post_traces = (post_traces - maxvals_pre) ./ range(pre_traces);
    % pre_traces = pre_traces ./ max(pre_traces); post_traces = post_traces ./  max(post_traces);

    extrema = [min(vertcat(pre_traces,post_traces),[],'all'), max(vertcat(pre_traces,post_traces),[],'all')];
        figure('Position', [200,558,1611,420]);
        subplot(2, 3, 1)
        plot(sorted_pre, -(1:nCells))
        hold on
        plot(sorted_post, -(1:nCells))
        plot(sorted_post-sorted_pre, -(1:nCells))
        xline(0)
        xticks([0 31 62 93 124 156 186 217 248 279 310]);
        xticklabels([0 1 2 3 4 5 6 7 8 9 10]);
        xlim([-200 310])
        ylim([-nCells 0])
        yticklabels([])
    
        subplot(2, 3, 2);
        imagesc(pre_traces(154:end,I_pre)');
        xline(310-154)
        colorbar
        clim(extrema)
        xticks([0 31 62 93 124 156 186 217 248 279 310 341 372 404 434 465]);
        xticklabels([-5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10]);
        xlabel('s')
        
        if strcmp(allData.data{i}.experimentType, 'whiskerTet')
            title('Pre RWS')
        elseif strcmp(allData.data{i}.experimentType, 'whiskerOptoTet')
            title('Pre RWSCF')
        end
        
        subplot(2, 3, 3);
         imagesc(post_traces(154:end,I_post)');
        %imagesc(post_traces(154:end,I_pre)'); % Keep pre sorting
        xline(310-154)
        colorbar
        clim(extrema)
        xticks([0 31 62 93 124 156 186 217 248 279 310 341 372 404 434 465]);
        xticklabels([-5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10]);
        xlabel('s')
    
        if strcmp(allData.data{i}.experimentType, 'whiskerTet')
            title('Post RWS')
        elseif strcmp(allData.data{i}.experimentType, 'whiskerOptoTet')
            title('Post RWSCF')
        end
    
        subplot(2, 3, 4)
        scatter(fpeak_pre, fpeak_post)
      
        subplot(2, 3, 5)
        histogram(fpeak_pre, 31)
        ylim([0 150])
    
        subplot(2, 3, 6)
        histogram(fpeak_post, 31)
        ylim([0 150])
end

getspecialbarplot(allData, grabsumresponsive);


%% PLOT RHO SCATTER (RWS and RWS-CF on same axes)
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
savename = {'PV_rhoscatter.tiff', 'pPN_rhoscatter.tiff', 'pVIP_rhoscatter.tiff', 'VIP_rhoscatter.tiff'};
gettitle = {'PV Corr. with Motion', 'pPN Corr. with Motion','pVIP Corr. with Motion', 'VIP Corr. with Motion'};

for i = 1:length(plot_cellType)
    [pre_RWS, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'all', 'all', 'all', 'NO DCZ', 'cellxmot_pre', false);
    [cat_pre_RWS, ~] = catmice(allData, pre_RWS, vartype, 'whiskerTet');
    
    [pre_RWSCF, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'all', 'all', 'all', 'NO DCZ', 'cellxmot_pre', false);
    [cat_pre_RWSCF, ~] = catmice(allData, pre_RWSCF, vartype, 'whiskerOptoTet');
    
    [post_RWS, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'all', 'all', 'all',  'NO DCZ', 'cellxmot_post', false);
    [cat_post_RWS, ~] = catmice(allData, post_RWS, vartype, 'whiskerTet');
    
    [post_RWSCF, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'all', 'all', 'all',  'NO DCZ', 'cellxmot_post', false);
    [cat_post_RWSCF, ~] = catmice(allData, post_RWSCF, vartype, 'whiskerOptoTet');
    
    getscatter_prepost_special(cat_pre_RWS, cat_post_RWS, cat_pre_RWSCF, cat_post_RWSCF, gettitle{i}, plot_cellType{i}, savename{i})
end

%% Plot scatter

plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
savename = {'PV_scatter.tiff', 'pPN_scatter.tiff', 'pVIP_scatter.tiff', 'VIP_scatter.tiff'};
gettitle = {'PV Pre Post', 'pPN Pre Post','pVIP Pre Post', 'VIP Pre Post'};
plotvar = 'mean_fluo_in_win';
exclude = false;
get_trialmotType = 'all';

for i = 1:length(plot_cellType)
    [pre_RWS, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'W', get_trialmotType, 'PRE', 'NO DCZ', plotvar, exclude);
    [pre_RWS, ~, vartype] = trialavg(pre_RWS, vartype);
    [cat_pre_RWS, ~] = catmice(allData, pre_RWS, vartype, 'whiskerTet');
    
    [pre_RWSCF, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'W', get_trialmotType, 'PRE', 'NO DCZ', plotvar, exclude);
    [pre_RWSCF, ~, vartype] = trialavg(pre_RWSCF, vartype);
    [cat_pre_RWSCF, ~] = catmice(allData, pre_RWSCF, vartype, 'whiskerOptoTet');
    
    [post_RWS, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'W', get_trialmotType, 'POST', 'NO DCZ', plotvar, exclude);
    [post_RWS, ~, vartype] = trialavg(post_RWS, vartype);
    [cat_post_RWS, ~] = catmice(allData, post_RWS, vartype, 'whiskerTet');
    
    [post_RWSCF, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'W', get_trialmotType, 'POST', 'NO DCZ', plotvar, exclude);
    [post_RWSCF, ~, vartype] = trialavg(post_RWSCF, vartype);
    [cat_post_RWSCF, ~] = catmice(allData, post_RWSCF, vartype, 'whiskerOptoTet');
    
    getscatter_prepost(cat_pre_RWS, cat_post_RWS, cat_pre_RWSCF, cat_post_RWSCF, gettitle{i}, plot_cellType{i}, savename{i})
end

%% PLOT PRE- BAR CHART MULTICOLOR (MULTIVARIABLE) (16) (NRSA)

% For C 12/12/23
% Currently plots two parameters: mean fluo and firstpeakamp
% Currently plots two stimulus conditions: W and WO
% Iterates through all, NM, T, M
% Plots PV, PN, UC, VIP

exclude = false;
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
plot_motType = {'all', 'NM', 'T', 'M'};
savename = {'PV_all_prebar_multiplot.jpg', 'pPN_all_prebar_multiplot.jpg', 'pVIP_all_prebar_multiplot.jpg', 'VIP_all_prebar_multiplot.jpg';...
    'PV_NM_prebar_multiplot.jpg', 'pPN_NM_prebar_multiplot.jpg', 'pVIP_NM_prebar_multiplot.jpg', 'VIP_NM_prebar_multiplot.jpg';...
    'PV_T_prebar_multiplot.jpg', 'pPN_T_prebar_multiplot.jpg', 'pVIP_T_prebar_multiplot.jpg', 'VIP_T_prebar_multiplot.jpg';...
    'PV_M_prebar_multiplot.jpg', 'pPN_M_prebar_multiplot.jpg', 'pVIP_M_prebar_multiplot.jpg', 'VIP_M_prebar_multiplot.jpg'};
gettitle = [];

ylimit = [0 1.18]; % 1.5 is best to plot every motion type, 1.18 is best to plot 'all'

for i = 1:length(plot_motType)
    for j = 1:length(plot_cellType)
    prebar_multiplot(allData, plot_cellType{j}, 'all', plot_motType{i}, 'mean_fluo_in_win', 'mean_fluo_in_win_before', exclude, false, gettitle, savename{i,j}, ylimit)
    end
end

%% PLOT PRE- BAR CHART % CELLS RESPONDING (16) !
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
plot_motType = {'all', 'NM', 'T', 'M'};
savename = {'PV_all_prebar_percentcells.jpg', 'pPN_all_prebar_percentcells.jpg', 'pVIP_all_prebar_percentcells.jpg', 'VIP_all_prebar_percentcells.jpg';...
    'PV_NM_prebar_percentcells.jpg', 'pPN_NM_prebar_percentcells.jpg', 'pVIP_NM_prebar_percentcells.jpg', 'VIP_NM_prebar_percentcells.jpg';...
    'PV_T_prebar_percentcells.jpg', 'pPN_T_prebar_percentcells.jpg', 'pVIP_T_prebar_percentcells.jpg', 'VIP_T_prebar_percentcells.jpg';...
    'PV_M_prebar_percentcells.jpg', 'pPN_M_prebar_percentcells.jpg', 'pVIP_M_prebar_percentcells.jpg', 'VIP_M_prebar_percentcells.jpg'};

for i = 1:length(plot_motType)
    for j = 1:length(plot_cellType)
    prebarpercentrespond(allData, plot_cellType{j}, 'all', plot_motType{i}, 'mean_fluo_in_win', true, savename{i, j})
    end
end

%% PROBABILITY % note can't take into account DREADD expts
plot_cellType = {'PV', 'PN', 'VIP'};
plot_motType = {'all'};
savename = {'temp.jpg'};
xlimits = [0 1];
ylimits = [0 1];
vartoplot = 'mean_fluo_in_win';
exclude = false;

for i = 1:length(plot_cellType)
%     [get_corr, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'all', 'all', 'all', 'NO DCZ', 'cellxmot_pre', false);
%     [get_corr, ~] = catmice(allData, get_corr, vartype, 'all');
    % PRE W
    [w_prob_PRE] = probability_calc(allData, plot_cellType{i}, plot_motType{1}, 'W', 'PRE', 'all');
    [w_fluo_PRE, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'W', plot_motType{1}, 'PRE', 'NO DCZ', vartoplot, exclude);
    [w_fluo_PRE, ~, vartype] = trialavg(w_fluo_PRE, vartype);
    [w_fluo_PRE, ~] = catmice(allData, w_fluo_PRE, vartype, 'all');
    
    % PRE WO
    [wo_prob_PRE] = probability_calc(allData, plot_cellType{i}, plot_motType{1}, 'WO', 'PRE', 'all');
    [wo_fluo_PRE, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'WO', plot_motType{1}, 'PRE', 'NO DCZ', vartoplot, exclude);
    [wo_fluo_PRE, ~, vartype] = trialavg(wo_fluo_PRE, vartype);
    [wo_fluo_PRE, ~] = catmice(allData, wo_fluo_PRE, vartype, 'all');

    % PRE RWS
    [w_prob_PRERWS] = probability_calc(allData, plot_cellType{i}, plot_motType{1}, 'W', 'PRE', 'whiskerTet');
    [w_fluo_PRERWS, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'W', plot_motType{1}, 'PRE', 'NO DCZ', vartoplot, exclude);
    [w_fluo_PRERWS, ~, vartype] = trialavg(w_fluo_PRERWS, vartype);
    [w_fluo_PRERWS, ~] = catmice(allData, w_fluo_PRERWS, vartype, 'whiskerTet');

    % POST RWS
    [w_prob_POSTRWS] = probability_calc(allData, plot_cellType{i}, plot_motType{1}, 'W', 'POST', 'whiskerTet');
    [w_fluo_POSTRWS, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'W', plot_motType{1}, 'POST', 'NO DCZ', vartoplot, exclude);
    [w_fluo_POSTRWS, ~, vartype] = trialavg(w_fluo_POSTRWS, vartype);
    [w_fluo_POSTRWS, ~] = catmice(allData, w_fluo_POSTRWS, vartype, 'whiskerTet');

    % PRE RWSCF
    [w_prob_PRERWSCF] = probability_calc(allData, plot_cellType{i}, plot_motType{1}, 'W', 'PRE', 'whiskerOptoTet');
    [w_fluo_PRERWSCF, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'W', plot_motType{1}, 'PRE', 'NO DCZ', vartoplot, exclude);
    [w_fluo_PRERWSCF, ~, vartype] = trialavg(w_fluo_PRERWSCF, vartype);
    [w_fluo_PRERWSCF, ~] = catmice(allData, w_fluo_PRERWSCF, vartype, 'whiskerOptoTet');

    % POST RWSCF
    [w_prob_POSTRWSCF] = probability_calc(allData, plot_cellType{i}, plot_motType{1}, 'W', 'POST', 'whiskerOptoTet');
    [w_fluo_POSTRWSCF, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'W', plot_motType{1}, 'POST', 'NO DCZ', vartoplot, exclude);
    [w_fluo_POSTRWSCF, ~, vartype] = trialavg(w_fluo_POSTRWSCF, vartype);
    [w_fluo_POSTRWSCF, ~] = catmice(allData, w_fluo_POSTRWSCF, vartype, 'whiskerOptoTet');

%     % PRE w, wo; prob
%     var1 = cell2mat(w_prob_PRE);
%     var2 = cell2mat(wo_prob_PRE);
    
    % PRE w, wo; fluo
%     var1 = w_fluo_PRE;
%     var2 = wo_fluo_PRE;
% 
% % % % % % %     PRE/POST RWS; prob
% % % %     var1 = cell2mat(w_prob_PRERWS);
% % % %     var2 = cell2mat(w_prob_POSTRWS);
%     
% %     % PRE/POST RWS; fluo
%     var1 = w_fluo_PRERWS;
%     var2 = w_fluo_POSTRWS;
% 
    % PRE/POST RWSCF; prob
% % % %     var1 = cell2mat(w_prob_PRERWSCF);
% % % %     var2 = cell2mat(w_prob_POSTRWSCF);

%     % PRE/POST RWSCF; fluo
    var1 = w_fluo_PRERWSCF;
    var2 = w_fluo_POSTRWSCF;

ignorenan = true;

plotdist(plot_cellType{i}, var1, var2, 'First Peak Amp. (RWSCF)', 'Amp (∆F/F)', 'Count', 20, savename{1}, [0 2], [], ignorenan)

    %getscatter(var1, var2, 'Mean Fluo.', 'Corr', 'Delta', plot_cellType{i}, savename{1}, xlimits, ylimits)
end

%% PLOT PRE- TRACES (16) ! (NRSA)
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
plot_motType = {'all', 'NM', 'T', 'M'};
savename = {'PV_all_pretraces.tiff', 'pPN_all_pretraces.tiff', 'pVIP_all_pretraces.tiff', 'VIP_all_pretraces.tiff';...
    'PV_NM_pretraces.tiff', 'pPN_NM_pretraces.tiff', 'pVIP_NM_pretraces.tiff', 'VIP_NM_pretraces.tiff';...
    'PV_T_pretraces.tiff', 'pPN_T_pretraces.tiff', 'pVIP_T_pretraces.tiff', 'VIP_T_pretraces.tiff';...
    'PV_M_pretraces.tiff', 'pPN_M_pretraces.tiff', 'pVIP_M_pretraces.tiff', 'VIP_M_pretraces.tiff'};
gettitle = [];
ylimit = 0.3; % CHANGED FROM 0.8
xlimit = [298 402];%[300 402];

includeopto = false;
exclude = false;
norm = false;        
for i = 1:length(plot_motType)
    for j = 1:length(plot_cellType)
    plotpretraces(allData, plot_cellType{j}, 'all', plot_motType{i}, 'golayshift', exclude, includeopto, ylimit, xlimit, norm, gettitle, savename{i, j})
    end
end

%% PLOT PRE- MOTION (4)!
plot_motType = {'all', 'NM', 'T', 'M'};
savename = {'all_premotion.tiff', 'NM_premotion.tiff', 'T_premotion.tiff', 'M_premotion.tiff'};
xlimit = [298 402];
exclude = false;
includeopto = false;
norm = false; % note it doesn't make much sense to norm? or norm to w stim instead

for i = 1:length(plot_motType)
    plotpremotion(allData, plot_motType{i}, exclude, includeopto, savename{i}, xlimit, norm)
end

%% PLOT PRE-POST BAR CHART (MULTIVARIABLE) (NRSA)

% For C 12/12/23

plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
plot_motType = {'all', 'NM', 'T', 'M'};
ylimit = [0 2]; % CHANGED FROM 1.5
gettitle = []; 
exclude = true;

savenameRWS = {'PV_all_prepostbar_multiplot_RWS.jpg', 'pPN_all_prepostbar_multiplot_RWS.jpg', 'pVIP_all_prepostbar_multiplot_RWS.jpg', 'VIP_all_prepostbar_multiplot_RWS.jpg';...
    'PV_NM_prepostbar_multiplot_RWS.jpg', 'pPN_NM_prepostbar_multiplot_RWS.jpg', 'pVIP_NM_prepostbar_multiplot_RWS.jpg', 'VIP_NM_prepostbar_multiplot_RWS.jpg';...
    'PV_T_prepostbar_multiplot_RWS.jpg', 'pPN_T_prepostbar_multiplot_RWS.jpg', 'pVIP_T_prepostbar_multiplot_RWS.jpg', 'VIP_T_prepostbar_multiplot_RWS.jpg';...
    'PV_M_prepostbar_multiplot_RWS.jpg', 'pPN_M_prepostbar_multiplot_RWS.jpg', 'pVIP_M_prepotbar_multiplot_RWS.jpg', 'VIP_M_prepostbar_multiplot_RWS.jpg'};

savenameRWSCF = {'PV_all_prepostbar_multiplot_RWSCF.jpg', 'pPN_all_prepostbar_multiplot_RWSCF.jpg', 'pVIP_all_prepostbar_multiplot_RWSCF.jpg', 'VIP_all_prepostbar_multiplot_RWSCF.jpg';...
    'PV_NM_prepostbar_multiplot_RWSCF.jpg', 'pPN_NM_prepostbar_multiplot_RWSCF.jpg', 'pVIP_NM_prepostbar_multiplot_RWSCF.jpg', 'VIP_NM_prepostbar_multiplot_RWSCF.jpg';...
    'PV_T_prepostbar_multiplot_RWSCF.jpg', 'pPN_T_prepostbar_multiplot_RWSCF.jpg', 'pVIP_T_prepostbar_multiplot_RWSCF.jpg', 'VIP_T_prepostbar_multiplot_RWSCF.jpg';...
    'PV_M_prepostbar_multiplot_RWSCF.jpg', 'pPN_M_prepostbar_multiplot_RWSCF.jpg', 'pVIP_M_prepostbar_multiplot_RWSCF.jpg', 'VIP_M_prepostbar_multiplot_RWSCF.jpg'};


for i = 1:length(plot_motType)
    for j = 1:length(plot_cellType)
        prepostbar_multiplot(allData, plot_cellType{j}, 'all', plot_motType{i}, 'mean_fluo_in_win', 'firstpeakamp', exclude, false, gettitle, savenameRWS{i, j}, ylimit, 'whiskerTet')
        prepostbar_multiplot(allData, plot_cellType{j}, 'all', plot_motType{i}, 'mean_fluo_in_win', 'firstpeakamp', exclude, false, gettitle, savenameRWSCF{i, j}, ylimit, 'whiskerOptoTet')
    end
end

%% PLOT PRE-POST TRACES (NRSA)
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
plot_motType = {'all', 'NM', 'T', 'M'};
savename = {{'PV_all_preposttraces_RWS.tiff', 'PV_all_preposttraces_RWSCF.tiff'}, {'pPN_all_preposttraces_RWS.tiff', 'pPN_all_preposttraces_RWSCF.tiff'}, {'pVIP_all_preposttraces_RWS.tiff', 'pVIP_all_preposttraces_RWSCF.tiff'}, {'VIP_all_preposttraces_RWS.tiff', 'VIP_all_preposttraces_RWSCF.tiff'};...
{'PV_NM_preposttraces_RWS.tiff', 'PV_NM_preposttraces_RWSCF.tiff'}, {'pPN_NM_preposttraces_RWS.tiff', 'pPN_NM_preposttraces_RWSCF.tiff'}, {'pVIP_NM_preposttraces_RWS.tiff', 'pVIP_NM_preposttraces_RWSCF.tiff'}, {'VIP_NM_preposttraces_RWS.tiff', 'VIP_NM_preposttraces_RWSCF.tiff'};...
{'PV_T_preposttraces_RWS.tiff', 'PV_T_preposttraces_RWSCF.tiff'}, {'pPN_T_preposttraces_RWS.tiff', 'pPN_T_preposttraces_RWSCF.tiff'}, {'pVIP_T_preposttraces_RWS.tiff', 'pVIP_T_preposttraces_RWSCF.tiff'}, {'VIP_T_preposttraces_RWS.tiff', 'VIP_T_preposttraces_RWSCF.tiff'};...
{'PV_M_preposttraces_RWS.tiff', 'PV_M_preposttraces_RWSCF.tiff'}, {'pPN_M_preposttraces_RWS.tiff', 'pPN_M_preposttraces_RWSCF.tiff'}, {'pVIP_M_preposttraces_RWS.tiff', 'pVIP_M_preposttraces_RWSCF.tiff'}, {'VIP_M_preposttraces_RWS.tiff', 'VIP_M_preposttraces_RWSCF.tiff'}};
gettitle = {[], []};
exclude = true; % switched 01/28/24

norm = true;

ylimit = 0.5;

for i = 1:length(plot_motType)
    for j = 1:length(plot_cellType)
    plotpreposttraces(allData, plot_cellType{j}, 'all', plot_motType{i}, 'golayshift', exclude, savename{i, j}, gettitle, norm, ylimit)
    end
end

%% DREADD EXPERIMENT TRACES
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
plot_motType = {'all', 'NM', 'T', 'M'};
gettitle = {[], []};
exclude = true; % switched 01/28/24

savename = {{'PV_all_preposttraces_RWS.tiff', 'PV_all_preposttraces_RWSCF.tiff'}, {'pPN_all_preposttraces_RWS.tiff', 'pPN_all_preposttraces_RWSCF.tiff'}, {'pVIP_all_preposttraces_RWS.tiff', 'pVIP_all_preposttraces_RWSCF.tiff'}, {'VIP_all_preposttraces_RWS.tiff', 'VIP_all_preposttraces_RWSCF.tiff'};...
{'PV_NM_preposttraces_RWS.tiff', 'PV_NM_preposttraces_RWSCF.tiff'}, {'pPN_NM_preposttraces_RWS.tiff', 'pPN_NM_preposttraces_RWSCF.tiff'}, {'pVIP_NM_preposttraces_RWS.tiff', 'pVIP_NM_preposttraces_RWSCF.tiff'}, {'VIP_NM_preposttraces_RWS.tiff', 'VIP_NM_preposttraces_RWSCF.tiff'};...
{'PV_T_preposttraces_RWS.tiff', 'PV_T_preposttraces_RWSCF.tiff'}, {'pPN_T_preposttraces_RWS.tiff', 'pPN_T_preposttraces_RWSCF.tiff'}, {'pVIP_T_preposttraces_RWS.tiff', 'pVIP_T_preposttraces_RWSCF.tiff'}, {'VIP_T_preposttraces_RWS.tiff', 'VIP_T_preposttraces_RWSCF.tiff'};...
{'PV_M_preposttraces_RWS.tiff', 'PV_M_preposttraces_RWSCF.tiff'}, {'pPN_M_preposttraces_RWS.tiff', 'pPN_M_preposttraces_RWSCF.tiff'}, {'pVIP_M_preposttraces_RWS.tiff', 'pVIP_M_preposttraces_RWSCF.tiff'}, {'VIP_M_preposttraces_RWS.tiff', 'VIP_M_preposttraces_RWSCF.tiff'}};

norm = true;

ylimit = 0.4;

for i = 1:length(plot_motType)
    for j = 1:length(plot_cellType)
    DREADDtraces(allData, plot_cellType{j}, 'all', plot_motType{i}, 'golayshift', false, savename{i, j}, gettitle, norm, ylimit)
    end
end

%% PLOT OVER TIME (NRSA)

% For C 12/12/23

% % mice hard coded in
% plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
% plot_motType = {'all', 'NM', 'T', 'M'};
% savename = {'PV_all_overtime.tiff', 'pPN_all_overtime.tiff', 'pVIP_all_overtime.tiff', 'VIP_all_overtime.tiff';...
%     'PV_NM_overtime.tiff', 'pPN_NM_overtime.tiff', 'pVIP_NM_overtime.tiff', 'VIP_NM_overtime.tiff';...
%     'PV_T_overtime.tiff', 'pPN_T_overtime.tiff', 'pVIP_T_overtime.tiff', 'VIP_T_overtime.tiff';...
%     'PV_M_overtime.tiff', 'pPN_M_overtime.tiff', 'pVIP_M_overtime.tiff', 'VIP_M_overtime.tiff'};
% 
% binsize = 1;
% gettitle = [];
% plot_var = 'mean_fluo_in_win';
% 
% for i = 1:length(plot_motType)
%     for j = 1:length(plot_cellType)
%         plottime(allData, plot_cellType{j}, 'all', plot_motType{i}, plot_var, false, binsize, gettitle, savename{i, j})
%     end
% end
ylimit =2;
xlimit = [-30 45];
exclude = false;

% mouse 10?

% For Poster
plottime(allData, 'PN', 'all', 'all', 'mean_fluo_diff', exclude, 1, ylimit, xlimit, 'PN; NM Trials; All Expts', 'ABBY_PN_all_overtime_dreadd.jpg')

%% Plot threshold experiment
cellType = 'PC';
cellmotType = 'all';
trialmotType = 'all';
variable = 'golayshift';
exclude = true;
ylimit = 1;
xlimit = [298 402];
norm = true;

%plotTHRESHtraces_trialpool(allData, cellType, cellmotType, 'all', variable, exclude, ylimit, xlimit, norm, [], 'test.tiff')
plotTHRESHcells_trialavg(allData, cellType, cellmotType, 'all', variable, exclude, ylimit, xlimit, norm, [], 'test.tiff')

variable = 'firstpeakamp';
cellType = 'PC';
cellmotType = 'all';
trialmotType = 'all';
exclude = true;
norm = true;
plotTHRESHcells_trialpool(allData, cellType, cellmotType, 'NM', variable, exclude, ylimit, xlimit, norm, [], 'test.tiff')

%% PLOT PRE-POST MOTION
plot_motType = {'all', 'NM', 'T', 'M'};
savename = {{'all_prepostmotion_RWS.jpg', 'all_prepostmotion_RWSCF.jpg'},{'NM_prepostmotion_RWS.jpg', 'NM_prepostmotion_RWSCF.jpg'}, {'T_prepostmotion_RWS.jpg', 'T_prepostmotion_RWSCF.jpg'}, {'M_prepostmotion_RWS.jpg', 'M_prepostmotion_RWSCF.jpg'}};
norm = false;
y_limit = [0 1];

for i = 1:length(plot_motType)
    plotprepostmotion(allData, plot_motType{i}, false, savename{i}, norm, y_limit)
end

%% PLOT MOTION BEHAVIOR

% need to edit this...

motion_type = 'running'; % or 'motion'
choose_norm = 'norm'; % 'norm' means baseline motion subtracted

savename = 'motionbehavior.tiff';

[motionpertrial] = getmotionpertrial(allData, motion_type, choose_norm, 305, 310, savename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% PLOT motion pie chart
% Mice currently hard coded in
plot_stimType = {'W', 'WO', 'O', 'W', 'W', 'W', 'W'};
plot_preORpost = {'PRE', 'PRE', 'PRE', 'PRE', 'POST', 'PRE', 'POST'};
plot_expType = {'all', 'all', 'all', 'whiskerTet', 'whiskerTet', 'whiskerOptoTet', 'whiskerOptoTet'};
plot_title = {'W_PRE', 'WO_PRE', 'O_PRE', 'W_RWS_PRE', 'W_RWS_POST', 'W_RWSCF_PRE', 'W_RWSCF_POST'};
exclude = false;

for i = 1:length(plot_stimType)
    motionpiechart(allData, plot_stimType{i}, plot_preORpost{i}, plot_expType{i}, exclude)
end

%% PLOT Pre- scatter
plot_cellType = {'PV', 'VIP'};
plot_motType = {'all'};
savename = {'PV_all_pretraces.tiff', 'pPN_all_pretraces.tiff', 'pVIP_all_pretraces.tiff', 'VIP_all_pretraces.tiff';...
    'PV_NM_pretraces.tiff', 'pPN_NM_pretraces.tiff', 'pVIP_NM_pretraces.tiff', 'VIP_NM_pretraces.tiff';...
    'PV_T_pretraces.tiff', 'pPN_T_pretraces.tiff', 'pVIP_T_pretraces.tiff', 'VIP_T_pretraces.tiff';...
    'PV_M_pretraces.tiff', 'pPN_M_pretraces.tiff', 'pVIP_M_pretraces.tiff', 'VIP_M_pretraces.tiff'};

exclude = true;

for i = 1:length(plot_motType)
    for j = 1:length(plot_cellType)

    [get_corr, vartype] = grabdata(allData, plot_cellType{j}, 'all', 'all', plot_motType{i}, 'all', 'NO DCZ', 'cellxmot_pre', exclude);
    [cat_corr, ~] = catmice(allData, get_corr, vartype, 'all');
    
    [get_w, vartype] = grabdata(allData, plot_cellType{j}, 'all', 'W', plot_motType{i}, 'PRE', 'NO DCZ', 'mean_fluo_in_win', exclude);
    [get_w, ~, vartype] = trialavg(get_w, vartype);
    [cat_w, varcattype] = catmice(allData, get_w, vartype, 'all');

    [get_wo, vartype] = grabdata(allData, plot_cellType{j}, 'all', 'WO', plot_motType{i}, 'PRE', 'NO DCZ', 'mean_fluo_in_win', exclude);
    [get_wo, ~, vartype] = trialavg(get_wo, vartype);
    [cat_wo, varcattype] = catmice(allData, get_wo, vartype, 'all');



    diff = abs((cat_wo-cat_w)./(cat_w+cat_wo));
    
    
    getscatter(cat_w, cat_wo, 'Mean Fluo.', 'Corr', 'Delta', plot_cellType{j}, savename{i, j}, xlimits, ylimits)
    end
end

%% PLOT Pre- scatter
plot_cellType = {'PV', 'PN', 'VIP'};
savename = {'nvm.jpg'};

exclude = false;

for j = 1:length(plot_cellType)

    [w_nm, vartype] = grabdata(allData, plot_cellType{j}, 'all', 'W', 'T', 'PRE', 'NO DCZ', 'mean_fluo_in_win', exclude);
    [w_nm, ~, vartype] = trialavg(w_nm, vartype);
    [w_nm, varcattype] = catmice(allData, w_nm, vartype, 'all');
    
    [w_m, vartype] = grabdata(allData, plot_cellType{j}, 'all', 'W', 'M', 'PRE', 'NO DCZ', 'mean_fluo_in_win', exclude);
    [w_m, ~, vartype] = trialavg(w_m, vartype);
    [w_m, varcattype] = catmice(allData, w_m, vartype, 'all');

    [wo_nm, vartype] = grabdata(allData, plot_cellType{j}, 'all', 'WO', 'T', 'PRE', 'NO DCZ', 'mean_fluo_in_win', exclude);
    [wo_nm, ~, vartype] = trialavg(wo_nm, vartype);
    [wo_nm, varcattype] = catmice(allData, wo_nm, vartype, 'all');
    
    [wo_m, vartype] = grabdata(allData, plot_cellType{j}, 'all', 'WO', 'M', 'PRE', 'NO DCZ', 'mean_fluo_in_win', exclude);
    [wo_m, ~, vartype] = trialavg(wo_m, vartype);
    [wo_m, varcattype] = catmice(allData, wo_m, vartype, 'all');

     diff1 = (wo_m-w_m)./(wo_m+w_m); diff2 = (wo_nm-w_nm)./(wo_nm+w_nm);
    
    
    getscatter(diff1, diff2, 'Mean Fluo.', 'Corr', 'Delta', plot_cellType{j}, savename{1})
end

%% PLOT scatter prob



%% PLOT rho histogram (distribution)
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
savename = {'PV_hist.tiff', 'pPN_hist.tiff', 'pVIP_hist.tiff', 'VIP_hist.tiff'};
gettitle = {'PV Corr. with Motion', 'pPN Corr. with Motion','pVIP Corr. with Motion', 'VIP Corr. with Motion'};

for i = 1:length(plot_cellType)
    % takes in getvarcat
    [getvar, vartype] = grabdata(allData, plot_cellType{i}, 'all', 'all', 'all', 'all', 'NO DCZ', 'cellxmot_pre', false);
    %[getvar, vartype] = trialpool(getvar, vartype);
    [getvarcat, varcattype] = catmice(allData, getvar, vartype, 'all');
    plotdist(plot_cellType{i}, getvarcat, gettitle{i}, 'Rho', 'Cell Count', 50, savename{i})
end

%% PLOT firstspike histogram (Pre-Post)
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
plot_motType = {'all', 'NM', 'T', 'M'};
savename = {{'PV_all_firstspiketime_RWS.tiff', 'PV_all_firstspiketime_RWSCF.tiff'}, {'pPN_all_firstspiketime_RWS.tiff', 'pPN_all_firstspiketime_RWSCF.tiff'}, {'pVIP_all_firstspiketime_RWS.tiff', 'pVIP_all_firstspiketime_RWSCF.tiff'}, {'VIP_all_firstspiketime_RWS.tiff', 'VIP_all_firstspiketime_RWSCF.tiff'};...
{'PV_NM_firstspiketime_RWS.tiff', 'PV_NM_firstspiketime_RWSCF.tiff'}, {'pPN_NM_firstspiketime_RWS.tiff', 'pPN_NM_firstspiketime_RWSCF.tiff'}, {'pVIP_NM_firstspiketime_RWS.tiff', 'pVIP_NM_firstspiketime_RWSCF.tiff'}, {'VIP_NM_firstspiketime_RWS.tiff', 'VIP_NM_firstspiketime_RWSCF.tiff'};...
{'PV_T_firstspiketime_RWS.tiff', 'PV_T_firstspiketime_RWSCF.tiff'}, {'pPN_T_firstspiketime_RWS.tiff', 'pPN_T_firstspiketime_RWSCF.tiff'}, {'pVIP_T_firstspiketime_RWS.tiff', 'pVIP_T_firstspiketime_RWSCF.tiff'}, {'VIP_T_firstspiketime_RWS.tiff', 'VIP_T_firstspiketime_RWSCF.tiff'};...
{'PV_M_firstspiketime_RWS.tiff', 'PV_M_firstspiketime_RWSCF.tiff'}, {'pPN_M_firstspiketime_RWS.tiff', 'pPN_M_firstspiketime_RWSCF.tiff'}, {'pVIP_M_firstspiketime_RWS.tiff', 'pVIP_M_firstspiketime_RWSCF.tiff'}, {'VIP_M_firstspiketime_RWS.tiff', 'VIP_M_firstspiketime_RWSCF.tiff'}};
exclude = false;

for i = 1:length(plot_motType)
    for j = 1:length(plot_cellType)
        dist_spikelatency_PREPOST(allData, plot_cellType{j}, plot_motType{i}, exclude, nBins, savename{i, j})
    end
end

%% PLOT firstspike histogram (pre)
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
plot_motType = {'all', 'NM', 'T', 'M'};
savename = {'PV_all_pre_firstspiketime.tiff', 'pPN_all_pre_firstspiketime.tiff', 'pVIP_all_pre_firstspiketime.tiff', 'VIP_all_pre_firstspiketime.tiff';...
    'PV_NM_pre_firstspiketime.tiff', 'pPN_NM_pre_firstspiketime.tiff', 'pVIP_NM_pre_firstspiketime.tiff', 'VIP_NM_pre_firstspiketime.tiff';...
    'PV_T_pre_firstspiketime.tiff', 'pPN_T_pre_firstspiketime.tiff', 'pVIP_T_pre_firstspiketime.tiff', 'VIP_T_pre_firstspiketime.tiff';...
    'PV_M_pre_firstspiketime.tiff', 'pPN_M_pre_firstspiketime.tiff', 'pVIP_M_pre_firstspiketime.tiff', 'VIP_M_pre_firstspiketime.tiff'};
exclude = false;
nBins = 100;
ylimit = 2500;
xlimit = 620;

for i = 1:length(plot_motType)
    for j = 1:length(plot_cellType)
        dist_spikelatency(allData, plot_cellType{j}, 'W', plot_motType{i}, exclude, nBins, ylimit, xlimit, savename{i, j})
    end
end

dist_spikelatency(allData, 'all', 'all', 'all', 'false', nBins, ylimit, xlimit, 'all_all_pre_firstspiketime.tiff')

%% PLOT Pre-Post scatter
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
plot_motType = {'all', 'NM', 'T', 'M'};
savename = {'PV_all_prepostscatter.tiff', 'pPN_all_prepostscatter.tiff', 'pVIP_all_prepostscatter.tiff', 'VIP_all_prepostscatter.tiff';...
    'PV_NM_prepostscatter.tiff', 'pPN_NM_prepostscatter.tiff', 'pVIP_NM_prepostscatter.tiff', 'VIP_NM_prepostscatter.tiff';...
    'PV_T_prepostscatter.tiff', 'pPN_T_prepostscatter.tiff', 'pVIP_T_prepostscatter.tiff', 'VIP_T_prepostscatter.tiff';...
    'PV_M_prepostscatter.tiff', 'pPN_M_prepostscatter.tiff', 'pVIP_M_prepostscatter.tiff', 'VIP_M_prepostscatter.tiff'};

plot_cellmotType = 'all';
plot_exclude = false;
gettitle = [];

plot_var = 'mean_fluo_in_win';

for i = 1:length(plot_motType)
    for j = 1:length(plot_cellType)
        [pre_RWS, vartype] = grabdata(allData, plot_cellType{j}, plot_cellmotType, 'W', plot_motType{i}, 'PRE', plot_var, plot_exclude);
        [pre_RWS, ~, vartype] = trialavg(pre_RWS, vartype);
        [cat_pre_RWS, ~] = catmice(allData, pre_RWS, vartype, 'whiskerTet');
        
        [pre_RWSCF, vartype] = grabdata(allData, plot_cellType{j}, plot_cellmotType, 'W', plot_motType{i}, 'PRE', plot_var, plot_exclude);
        [pre_RWSCF, ~, vartype] = trialavg(pre_RWSCF, vartype);
        [cat_pre_RWSCF, ~] = catmice(allData, pre_RWSCF, vartype, 'whiskerOptoTet');
        
        [post_RWS, vartype] = grabdata(allData, plot_cellType{j}, plot_cellmotType, 'W', plot_motType{i}, 'POST', plot_var, plot_exclude);
        [post_RWS, ~, vartype] = trialavg(post_RWS, vartype);
        [cat_post_RWS, ~] = catmice(allData, post_RWS, vartype, 'whiskerTet');
        
        [post_RWSCF, vartype] = grabdata(allData, plot_cellType{j}, plot_cellmotType, 'W', plot_motType{i}, 'POST', plot_var, plot_exclude);
        [post_RWSCF, ~, vartype] = trialavg(post_RWSCF, vartype);
        [cat_post_RWSCF, ~] = catmice(allData, post_RWSCF, vartype, 'whiskerOptoTet');
        
        getscatter_prepost(cat_pre_RWS, cat_post_RWS, cat_pre_RWSCF, cat_post_RWSCF, gettitle, plot_cellType{j}, savename{i, j})
    end
end

%% Plot Pre-Post Traces (LONGER WINDOW)
savename = {'VIP_prepost_traces_RWS_T_LONG.tiff', 'VIP_prepost_traces_RWSCF_T_LONG.tiff'};
gettitle = {'Pop. Trace (T; RWS)', 'Pop. Trace (T; RWS-CF)'};
plotLONGpreposttraces(allData, 'PN', 'all', 'NM', 'golayshift', true, savename, gettitle)

%% Plot Pre-Post Motion (LONGER WINDOW)
savename = {'T_motionpreposttraces_RWS.tiff', 'T_motionpreposttraces_RWSCF.tiff'};
plotLONGprepostmotion(allData, 'T', false, savename)

%% Plot SINGLE CELL
set_mouse = 12;
set_cell = 1;
plot_trialtype = 'W';
plot_tettype = 'POST';
x_limit = [300, 375];
y_limit = [-0.3, 1];
savename = 'mouse11_cell1_WPRE.tiff';
plotsinglecell(allData, set_mouse, set_cell, plot_trialtype, plot_tettype, x_limit, y_limit, savename);

%% Plot Pre- BOX PLOTS
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
trialaverage = false;
savefig = false;

for i = 1:length(plot_cellType)
    pretetbox(allData, plot_cellType{i}, 'all', 'all', 'mean_fluo_in_win', true, trialaverage, savefig)
end

%% Plot Pre- BAR CHART MULTICOLOR (optimized for firstpeakamp)
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
savename = {'PV_prebar_multicolor.tiff', 'pPN_prebar_multicolor.tiff', 'pVIP_prebar_multicolor.tiff', 'VIP_prebar_multicolor.tiff'};
gettitle = {'PV Mean Evoked Fluo.', 'pPN Mean Evoked Fluo.','pVIP Mean Evoked Fluo.', 'VIP Mean Evoked Fluo.'};

trialaverage = false;
ylimit = [0 1];

for i = 1:length(plot_cellType)
    prebar_multicolor(allData, plot_cellType{i}, 'all', 'all', 'firstpeakamp', true, trialaverage, gettitle{i}, savename{i}, ylimit)
end

%% Plot Pre- BAR CHART (optimized for mean_fluo_in_win)
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
savename = {'PV_prebar.tiff', 'pPN_prebar.tiff', 'pVIP_prebar.tiff', 'VIP_prebar.tiff'};
gettitle = {'PV Mean Evoked Fluo.', 'pPN Mean Evoked Fluo.','pVIP Mean Evoked Fluo.', 'VIP Mean Evoked Fluo.'};

trialaverage = false;
ylimit = [0 0.5];

for i = 1:length(plot_cellType)
    prebar(allData, plot_cellType{i}, 'all', 'all', 'mean_fluo_in_win', true, trialaverage, gettitle{i}, savename{i}, ylimit)
end

%% Plot Pre-Post BAR CHARTS (single variable)
% mice currently hard coded in
plot_cellType = {'PV', 'PN', 'UC', 'VIP'};
plot_motType = {'all', 'NM', 'T', 'M'};
savename = {{'PV_all_prepostbar_RWS.tiff', 'PV_all_prepostbar_RWSCF.tiff'}, {'pPN_all_prepostbar_RWS.tiff', 'pPN_all_prepostbar_RWSCF.tiff'}, {'pVIP_all_prepostbar_RWS.tiff', 'pVIP_all_prepostbar_RWSCF.tiff'}, {'VIP_all_prepostbar_RWS.tiff', 'VIP_all_prepostbar_RWSCF.tiff'};...
{'PV_NM_prepostbar_RWS.tiff', 'PV_NM_prepostbar_RWSCF.tiff'}, {'pPN_NM_prepostbar_RWS.tiff', 'pPN_NM_prepostbar_RWSCF.tiff'}, {'pVIP_NM_prepostbar_RWS.tiff', 'pVIP_NM_prepostbar_RWSCF.tiff'}, {'VIP_NM_prepostbar_RWS.tiff', 'VIP_NM_prepostbar_RWSCF.tiff'};...
{'PV_T_prepostbar_RWS.tiff', 'PV_T_prepostbar_RWSCF.tiff'}, {'pPN_T_prepostbar_RWS.tiff', 'pPN_T_prepostbar_RWSCF.tiff'}, {'pVIP_T_prepostbar_RWS.tiff', 'pVIP_T_prepostbar_RWSCF.tiff'}, {'VIP_T_prepostbar_RWS.tiff', 'VIP_T_prepostbar_RWSCF.tiff'};...
{'PV_M_prepostbar_RWS.tiff', 'PV_M_prepostbar_RWSCF.tiff'}, {'pPN_M_prepostbar_RWS.tiff', 'pPN_M_prepostbar_RWSCF.tiff'}, {'pVIP_M_prepostbar_RWS.tiff', 'pVIP_M_prepostbar_RWSCF.tiff'}, {'VIP_M_prepostbar_RWS.tiff', 'VIP_M_prepostbar_RWSCF.tiff'}};
gettitle = {[], []};

trialaverage = false;
plot_indiv_cells = false;
plot_indiv_mice = false;

% need to change ylabel manually in function currently

for i = 1:length(plot_motType)
    for j = 1:length(plot_cellType)
    prepostbar(allData, plot_cellType{j}, 'all', plot_motType{i}, 'mean_fluo_in_win', true, trialaverage, plot_indiv_cells, plot_indiv_mice, savename{i, j}, gettitle)
    end
end

%% Get subset of data
cellType = 'all'; % 'PV', 'PN', 'UC', 'VIP' or 'all'
cellmotType = 'all'; % 'POS', 'NEG', 'NONE' or 'all'
trialType = 'all'; % 'W', 'O', 'WO' or 'all'
trialmotType = 'all'; % 'M', 'NM', 'T', 'H' or 'all'
tetPeriod = 'PRE'; % 'PRE', 'TET', 'POST', or 'all'
exclude = false; % choose 
variable = 'motionInfo'; 

[getvar, vartype] = grabdata(allData, cellType, cellmotType, trialType, trialmotType, tetPeriod, variable, exclude);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[getvar, semvar, vartype] = trialavg(getvar, vartype);

%%
[getvar, vartype] = trialpool(getvar, vartype);

%%
expType = 'whiskerTet'; % whiskerOptoTet or whiskerTet or all

[getvarcat, varcattype] = catmice(allData, getvar, vartype, expType);

%% Prep data for scatter and plot (1 variable by 1 variable -- 2nd requires manipulation)
% Cellxmot; diff between w and wo
plot_cellType = 'PN'; plot_trialmotType = 'all'; plot_var = 'mean_fluo_in_win'; use_abs = true; plot_exclude = true;

trialmotType = 'all'; % 'M', 'NM', 'T', 'H' or 'all'
tetPeriod = 'all'; % 'PRE', 'TET', 'POST', or 'all'
exclude = false; % choose 
variable = 'modulationidx'; 
[pre_RWS, vartype] = grabdata(allData, plot_cellType, 'all', 'all', 'all', 'all', 'cellxmot', plot_exclude);
[cat_pre_RWS, varcattype] = catmice(allData, pre_RWS, vartype, 'all');

[get_w, vartype] = grabdata(allData, plot_cellType, 'all', 'W', plot_trialmotType, 'PRE', plot_var, plot_exclude);
[get_w, ~, vartype] = trialavg(get_w, vartype);
[cat_w, varcattype] = catmice(allData, get_w, vartype, 'all');

[get_wo, vartype] = grabdata(allData, plot_cellType, 'all', 'WO', plot_trialmotType, 'PRE', plot_var, plot_exclude);
[get_wo, ~, vartype] = trialavg(get_wo, vartype);
[cat_wo, varcattype] = catmice(allData, get_wo, vartype, 'all');

yvar = (cat_wo - cat_w) ./ (cat_wo + cat_w);
figure;
getscatter(cat_w, cat_wo, 'title', 'xlabel', 'ylabel', plot_cellType)

% figure;
% if use_abs
%     getscatter(abs(catcellxmot), abs(yvar), 'title', 'xlabel', 'ylabel', plot_cellType)
% else
%     getscatter(catcellxmot, yvar, 'title', 'xlabel', 'ylabel', plot_cellType)
% end
%xlim([-0.3 0.3])


hold off

% %% STOP
% 
% 
% 
% 
% %% Update motion trials...
% % nMotion = 3;
% % Motion_win = [298 322];
% % 
% % [allData] = getmotionconfound(allData, Motion_win, nMotion);
% 
% % nMotion_M = 1;
% % nMotion_NM = 1;
% % Motion_win = [298, 310+31+31];
% 
% % FOR INDIVIDUAL TRACES
% nMotion = 1;
% Motion_win = [307, 310];
% 
% [allData] = getmotionconfound(allData, Motion_win, nMotion);
% 
% 
% %% Set Parameters
% 
% ev_end = 310 + 6;  % end frame of evoked window (spike must occur in this window)
% ev_start = 310;    % start frame of evoked window
% stimOn = 310;      % stimulus onset frame
% baseline = 294;    % start frame to calculate baseline period
% thr = 0.5;         % baseline threshold for removal
% pk_thrs = 0.1;     % peak detection threshold
% f2ms = 30.98;
% tol_win = 1;       % if spike occurs within this number of frames before stimulus, don't count peaks/amps
% 
% save_individual_traces = false;
% foldername = "20230516_analysis/figs/NRSA_PREP_NO_MOTION_smallwin/";
% 
% %% Calculate avg traces, amps, pkLocs
% % Other parameters must be specified prior to running section!
% 
% % CHOOSE PARAMETERS
% % Choose motType
% % getTraces collects traces from this subset of trials
% motType = 'all'; % 'M', 'NM', or 'all' trials %CHANGE FROM NM 10:59PM
% 
% [allData] = getmotionconfound(allData, [Motion_win(1), Motion_win(2)], nMotion);
% 
% 
% % Choose latency type
% lattype = 'calcium'; % 'calcium or spike, get latency of calcium peak or spike
% 
% % Choose whether to include traces above thr
% % Amps, locs, traces, and motion traces are only grabbed from this subset of trials
% % Thus, event and non event, averages, etc are only calculated from these
% blShift = 'below'; % below', 'above', or 'all'
% 
% % Set experiment, trial, and cell types
% exType = {'whiskerOptoTet', 'whiskerTet'};
% cellType = {'PV', 'PC', 'UC'};
% trialType = {'O', 'WO', 'W', 'W'};
% tetType = {'PRE', 'PRE', 'PRE', 'POST'};
% cellmotType = {'NEG', 'POS', 'NONE'};
% 
% % comp = comp_traces_amps_pkLocs(allData, exType, cellType, trialType, tetType, motType, blShift, thr, stimOn, baseline, pk_thrs, ev_start, ev_end);
% 
% 
% % PREALLOCATE
% nExType = length(exType);
% nCellType = length(cellType);
% nCellMotType = length(cellmotType);
% nTrialType = length(trialType);
% nMice = length(allData.mouseIDs);
% 
% nAllCells = 0; % nCells across all mice * nTrialType
% for map = 1:nMice
%     nAllCells = nAllCells + length(allData.data{map}.cellType) * ...       
%         length(trialType);
% end
% 
% nFrames = size(allData.data{1}.signal,1);            % nFrames consistent across dataset
% 
% % Preallocate matrices
% all_non_event_traces = cell(nMice, nCellType, nTrialType);
% all_event_traces = cell(nMice,nCellType,nTrialType);
% all_traces = cell(nMice,nCellType,nTrialType);
% all_trialtimes = cell(nMice, nCellType, nTrialType);
% all_pkLocs = cell(nMice,nCellType,nTrialType);
% all_amps = cell(nMice,nCellType,nTrialType);
% all_motion = cell(nMice, nCellType, nTrialType);
% all_event_motion = cell(nMice, nCellType, nTrialType);
% all_non_event_motion = cell(nMice, nCellType, nTrialType);
% 
% all_mu_motion = zeros(nFrames, nAllCells);           % Average motion across all trials fitting motion and baseline conditions
% all_mu_traces = zeros(nFrames,nAllCells);            % Average signal across all trials fitting motion and baseline conditions
% all_mu_non_event_traces = zeros(nFrames, nAllCells); % Average signal across all non-event trials fitting motion and baseline conditions
% all_mu_non_event_motion = zeros(nFrames,nAllCells);  % Average motion across all non-event trials fitting motion and baseline conditions
% all_mu_event_traces = zeros(nFrames,nAllCells);      % Average signal across all event trials fitting motion and baseline conditions                    
% all_mu_event_motion = zeros(nFrames,nAllCells);      % Average motion across all event trials fitting motion and baseine conditions
% all_mu_amps = zeros(nAllCells,1);                    % Average of all amps from all trials fitting conditions
% all_mu_pkLocs = zeros(nAllCells,1);                  % Avgerage of all pkLocs from event and non-event trials
% all_mu_amps_event_traces = zeros(nAllCells,1);       % Amp from mu_event_traces
% all_mu_pkLocs_event_traces = zeros(nAllCells,1);     % pkLocs from mu_event_traces
% all_mu_amps_mu_traces = zeros(nAllCells,1);          % Amp from mu_traces
% all_mu_pkLocs_mu_traces = zeros(nAllCells,1);        % pkLocs from mu_traces
% all_mu_spont_rate = zeros(nAllCells, 1);
% all_mu_spont_rate_running = zeros(nAllCells, 1);
% all_mu_spont_rate_rest = zeros(nAllCells, 1);
% all_mu_b_oasis = zeros(nAllCells, 1);
% all_mu_sn_oasis = zeros(nAllCells, 1);
% 
% all_exIDs = cell(nAllCells,1);
% all_cellIDs = cell(nAllCells,1);
% all_cellmotIDs = cell(nAllCells, 1);
% all_cell_tet_rates = cell(nAllCells, 1);
% all_motIDs = cell(nAllCells, 1);
% all_trialIDs = cell(nAllCells,1);
% all_tetIDs = cell(nAllCells,1);
% all_CondsIDs = true(nAllCells,1); % true if cell has data in ALL trial types specified (after motion and blShift condition is specified condition is specified)
% all_anyEventIDs = true(nAllCells,1); % true if cell has event in at least one trial of ALL trial types specified (after motion and blShift condition is specified)
% 
% all_CondsIDs_pre = true(nAllCells,1); % true if cell has data across all trials in all PRE tet trial types specified
% all_anyEventIDs_pre = true(nAllCells,1); % true if cell has an event in at least one trial of all PRE tet trial types specified
% 
% c = 1; % counter to keep track when storing above data
% cc = 1; % second counter for allCondsIDs
% 
% % ITERATRE THROUGH EACH MOUSE, CELL TYPE, AND TRIAL TYPE
% for map = 1:nMice
%     for j = 1:nCellType
%         nCells = sum(strcmp(allData.data{map}.cellType, cellType{j}));
%         anyEvent = false(nCells,1);
%         anyEvent_pre = false(nCells, 1);
%         allCond = true(nCells,1);
%         allCond_pre = true(nCells, 1);
% 
%         for k = 1:nTrialType
% %             % Get traces/motion for specified trial and motion condition
% %             [traces, motion] = getTraces(allData.data{i},cellType{j},...
% %                 trialType{k},tetType{k},motType);
% 
%             % nFrames x nCells (of cell type) x nTrials (of trial type)
%             [traces, c_oasis, spiketimes, b, smin, sn, motion, cell_motion_type...
%                 , spont_rate, spont_rate_running, spont_rate_rest, tet_spike_rate, trialtime] = ...
%                 getOasis(allData.data{map}, cellType{j}, trialType{k}, tetType{k}, motType);
%           
%             % No data exists for this cell type/condition/mouse if traces is empty
%             if isempty(traces)
%                 allCond(:) = false;
% 
%                 if strcmp(tetType{k}, 'PRE')
%                     allCond_pre(:) = false;
%                 end
%                 
%                 all_mu_non_event_traces(:,c:c+nCells-1) = NaN;
%                 all_mu_event_traces(:,c:c+nCells-1) = NaN;
%                 all_mu_traces(:,c:c+nCells-1) = NaN;
%                 all_mu_amps(c:c+nCells-1) = NaN;
%                 all_mu_pkLocs(c:c+nCells-1) = NaN;
%                 all_mu_amps_event_traces(c:c+nCells-1) = NaN;
%                 all_mu_pkLocs_event_traces(c:c+nCells-1) = NaN;
%                 all_mu_amps_mu_traces(c:c+nCells-1) = NaN;
%                 all_mu_pkLocs_mu_traces(c:c+nCells-1) = NaN;
%                 all_mu_motion(:, c:c+nCells-1) = NaN;
%                 all_mu_event_motion(:, c:c+nCells-1) = NaN;
%                 all_mu_non_event_motion(:, c:c+nCells-1) = NaN;
%                 all_mu_spont_rate(c:c+nCells-1) = NaN;
%                 all_mu_spont_rate_running(c:c+nCells-1) = NaN;
%                 all_mu_spont_rate_rest(c:c+nCells-1) = NaN;
%                 all_mu_b_oasis(c:c+nCells-1) = NaN;
%                 all_mu_sn_oasis(c:c+nCells-1) = NaN;
%                 all_tet_rates(c:+nCells-1) = NaN;
% 
%     
%                 all_exIDs(c:c+nCells-1) = exType(...
%                     strcmp(exType,allData.data{map}.experimentType));
%                 all_cellIDs(c:c+nCells-1) = cellType(j);
%                 all_cellmotIDs(c:c+nCells-1) = cell_motion_type;
%                 all_trialIDs(c:c+nCells-1) = trialType(k);
%                 all_tetIDs(c:c+nCells-1) = tetType(k);
%                 all_tet_rates(c:c+nCells-1) = tet_spike_rate;
% 
%                 c = c + nCells;
%                 continue
%             end
% 
%      
%             % Get indices of traces with pre-stim baseline above thr
%             %[Ithr] = BLrej(traces, thr, stimOn, baseline);
% 
%             % Demean all traces (using pre stim baseline)
%             [traces, ~, Ithr] = shiftBL(traces,thr,stimOn,baseline);
% 
%             % indices of traces with event prior to stim
%             % onset???
%             [pkLocs, amps, Ithr_s] = findEvokedEvents(traces, c_oasis, ev_start:ev_end, spiketimes, tol_win, lattype);
% 
% 
% 
%             % Calculate peak locs and amps in specified window
% %             % nCells x nTrials, zero if there was no peak
% %             [pkLocs, amps] = calc_amps_pkLocs(pk_thrs, traces, ...
% %                 [ev_start, ev_end], 'max'); % can also do 'first'
% 
% 
%             
%             
%             % Each cell in the cell array is either (nFrames x nTrials) or (nCells x nTrials)
%             grab_event_traces = cell(nCells, 1);
%             grab_non_event_traces = cell(nCells, 1);
%             grab_traces = cell(nCells, 1);
%             grab_pkLocs = cell(nCells, 1);
%             grab_amps = cell(nCells, 1);
%             grab_motion = cell(nCells, 1);
%             grab_event_motion = cell(nCells, 1);
%             grab_non_event_motion = cell(nCells, 1);
%             grab_spont_rate = cell(nCells, 1);
%             grab_spont_rate_running = cell(nCells, 1);
%             grab_spont_rate_rest = cell(nCells, 1);
%             grab_b_oasis = cell(nCells, 1);
%             grab_sn_oasis = cell(nCells, 1);
%             grab_trialtime = cell(nCells, 1);
%             
%             % Preallocate arrays for calculating mean data
%             mu_non_event_traces = zeros(nFrames, nCells); 
%             mu_event_traces = zeros(nFrames,nCells);     
%             mu_traces = zeros(nFrames,nCells);   
%             mu_amps = zeros(nCells, 1);              
%             mu_pkLocs = zeros(nCells, 1);        
%             mu_motion = zeros(nFrames, nCells);
%             mu_event_motion = zeros(nFrames, nCells);
%             mu_non_event_motion = zeros(nFrames, nCells);
%             mu_spont_rate = zeros(nCells, 1);
%             mu_spont_rate_running = zeros(nCells, 1);
%             mu_spont_rate_rest = zeros(nCells, 1);
%             mu_b_oasis = zeros(nCells, 1);
%             mu_sn_oasis = zeros(nCells, 1);
%             
%             % Iterate through all cells and grab the traces (etc.) of those
%             % fitting condition
%             for l = 1:nCells
%                 % Reject condition. Ithr is a boolean matrix of size nCells
%                 % x nTrials, which is true if the average baseline trace is
%                 % above a threshold. We use this to index into each matrix
%                 % and grab only those that are below the threshold.
% 
%                 % Update: also account for Ithr_s trials that have traces 
%                 % with spikes in pre-stim window
%                 if strcmp(blShift, 'below')
%                     above_Thr_trials = Ithr(l, :); %| Ithr_s(l, :);
%                     grab_traces{l} = squeeze(traces(:, l, ~above_Thr_trials)); % Contains empty array if all traces are rejected (above thresh)
%                     grab_pkLocs{l} = pkLocs(l, ~above_Thr_trials);
%                     grab_amps{l} = amps(l, ~above_Thr_trials);
%                     grab_motion{l} = motion(:, ~above_Thr_trials);
%                     grab_spont_rate{l} = spont_rate(l, :);
%                     grab_spont_rate_running{l} = spont_rate_running(l, :);
%                     grab_spont_rate_rest{l} = spont_rate_rest(l, :);
%                     grab_b_oasis{l} = b(l, :);
%                     grab_sn_oasis{l} = sn(l, :);
%                     grab_trialtime{l} = trialtime(~above_Thr_trials);
%                     
% 
%                 elseif strcmp(blShift, 'above')
%                     above_Thr_trials = Ithr(l, :); %| Ithr_s(l, :);
%                     grab_traces{l} = squeeze(traces(:, l, above_Thr_trials)); % Contains empty array if all traces are rejected (above thresh)
%                     grab_pkLocs{l} = pkLocs(l, above_Thr_trials);
%                     grab_amps{l} = amps(l, above_Thr_trials);
%                     grab_motion{l} = motion(:, above_Thr_trials);
%                     grab_spont_rate{l} = spont_rate(l, :);
%                     grab_spont_rate_running{l} = spont_rate_running(l, :);
%                     grab_spont_rate_rest{l} = spont_rate_rest(l, :);
%                     grab_b_oasis{l} = b(l, :);
%                     grab_sn_oasis{l} = sn(l, :);
%                     grab_trialtime{l} = trialtime(above_Thr_trials);
%                 
%                 % Default condition. Grab all.
%                 elseif strcmp(blShift, 'all')
%                     % may only be one trial
%                     if length(size(traces)) == 3
%                         grab_traces{l} = squeeze(traces(:, l, :));
%                         grab_pkLocs{l} = pkLocs(l, :);
%                         grab_amps{l} = amps(l, :);
%                         grab_motion{l} = motion;
%                         grab_spont_rate{l} = spont_rate(l, :);
%                         grab_spont_rate_running{l} = spont_rate_running(l, :);
%                         grab_spont_rate_rest{l} = spont_rate_rest(l, :);
%                         grab_b_oasis{l} = b(l, :);
%                         grab_sn_oasis{l} = sn(l, :);
%                         grab_trialtime{l} = trialtime;
% 
%                         % Event exists in at least one trial type
%                         if sum(amps(l, :) > 0) > 0
%                             anyEvent(l) = true;
%                         end
%         
%                         if sum(amps(l, :) > 0) > 0 && strcmp(tetType{k}, 'PRE')
%                             anyEvent_pre(l) = true;
%                         end
%                     else
%                         grab_traces{l} = traces(:, l);
%                         grab_pkLocs{l} = pkLocs(l);
%                         grab_amps{l} = amps(l);
%                         grab_motion{l} = motion;
%                         grab_spont_rate{l} = spont_rate(l);
%                         grab_spont_rate_running{l} = spont_rate_running(l);
%                         grab_spont_rate_rest{l} = spont_rate_rest(l);
%                         grab_b_oasis{l} = b(l);
%                         grab_sn_oasis{l} = sn(l);
%                         grab_trialtime{l} = trialtime;
%                         warning('only one trial')
%                         % Event exists in at least one trial type
%                         if sum(amps(l) > 0) > 0
%                             anyEvent(l) = true;
%                         end
%         
%                         if sum(amps(l) > 0) > 0 && strcmp(tetType{k}, 'PRE')
%                             anyEvent_pre(l) = true;
%                         end
%                     end
%                 end
%                 
%                 
% 
% 
%                 % Grab the traces which contained an event. grab_amps
%                 % contains matrices of doubles. Some elements may be 0 --
%                 % these are trials without any events. Use this to grab
%                 % data from only those trials that had an event; calculate
%                 % mean of each data.
%                 Iev = grab_amps{l} > 0;
%                 grab_event_traces{l} = grab_traces{l}(:, Iev);
%                 grab_non_event_traces{l} = grab_traces{l}(:, ~Iev);
%                 grab_event_motion{l} = grab_motion{l}(:, Iev);
%                 grab_non_event_motion{l} = grab_motion{l}(:, ~Iev);
% 
%                 % this will return NaNs for those cells that contain no traces with events
%                 mu_non_event_traces(:, l) = mean(grab_traces{l}(:, ~Iev), 2);                
%                 mu_event_traces(:,l) = mean(grab_traces{l}(:, Iev), 2);
%                 mu_traces(:,l) = mean(grab_traces{l}, 2);
%                 mu_amps(l) = mean(grab_amps{l}(Iev));
%                 mu_pkLocs(l) = mean(grab_pkLocs{l}(Iev));
%                 mu_motion(:,l) = mean(grab_motion{l}, 2);
%                 mu_event_motion(:,l) = mean(grab_event_motion{l}, 2);
%                 mu_non_event_motion(:,l) = mean(grab_non_event_motion{l}, 2);
%                 mu_spont_rate(l) = mean(grab_spont_rate{l});
%                 mu_spont_rate_rest(l) = mean(grab_spont_rate_rest{l});
%                 mu_spont_rate_running(l) = mean(grab_spont_rate_running{l});
%                 mu_b_oasis(l) = mean(grab_b_oasis{l});
%                 mu_sn_oasis(l) = mean(grab_sn_oasis{l});
% 
%                 % IF cell has no traces
%                 if isempty(grab_traces{l})
%                     allCond(l) = false;
%                     if strcmp(tetType{k}, 'PRE')
%                         allCond_pre(l) = false;
%                     end
%                 end
%             end
%             
%             % Use the mean (event) traces to calculate average peaks
%             [mu_pkLocs_event_traces, mu_amps_event_traces] = calc_amps_pkLocs(...
%                 pk_thrs, mu_event_traces, [ev_start, ev_end], 'max');
%             [mu_pkLocs_mu_traces, mu_amps_mu_traces] = calc_amps_pkLocs(...
%                 pk_thrs, mu_traces, [ev_start, ev_end], 'max');
% 
%             % Store all data
%             all_non_event_traces{map, j, k} = grab_non_event_traces;
%             all_event_traces{map,j,k} = grab_event_traces;
%             all_traces{map,j,k} = grab_traces;
%             all_pkLocs{map,j,k} = grab_pkLocs;
%             all_trialtimes{map, j, k} = grab_trialtime;
%             all_amps{map,j,k} = grab_amps;
%             all_motion{map, j, k} = grab_motion;
%             all_event_motion{map, j, k} = grab_event_motion;
%             all_non_event_motion{map, j, k} = grab_non_event_motion;
%             
%             all_mu_non_event_traces(:,c:c+nCells-1) = mu_non_event_traces;
%             all_mu_event_traces(:,c:c+nCells-1) = mu_event_traces;
%             all_mu_traces(:,c:c+nCells-1) = mu_traces;
%             all_mu_amps(c:c+nCells-1) = mu_amps;
%             all_mu_pkLocs(c:c+nCells-1) = mu_pkLocs;
%             all_mu_amps_event_traces(c:c+nCells-1) = mu_amps_event_traces;
%             all_mu_pkLocs_event_traces(c:c+nCells-1) = mu_pkLocs_event_traces;
%             all_mu_amps_mu_traces(c:c+nCells-1) = mu_amps_mu_traces;
%             all_mu_pkLocs_mu_traces(c:c+nCells-1) = mu_pkLocs_mu_traces;
%             all_mu_motion(:,c:c+nCells-1) = mu_motion;
%             all_mu_event_motion(:,c:c+nCells-1) = mu_event_motion;
%             all_mu_non_event_motion(:,c:c+nCells-1) = mu_non_event_motion;
%             all_mu_spont_rate(c:c+nCells-1) = mu_spont_rate;
%             all_mu_spont_rate_running(c:c+nCells-1) = mu_spont_rate_running;
%             all_mu_spont_rate_rest(c:c+nCells-1) = mu_spont_rate_rest;
%             all_mu_b_oasis(c:c+nCells-1) = mu_b_oasis;
%             all_mu_sn_oasis(c:c+nCells-1) = mu_sn_oasis;
%             
% 
%             all_anyEventIDs(c:c+nCells-1) = anyEvent;
%             all_anyEventIDs_pre(c:c+nCells-1) = anyEvent_pre;
%             all_exIDs(c:c+nCells-1) = exType(...
%                 strcmp(exType,allData.data{map}.experimentType));
%             all_cellIDs(c:c+nCells-1) = cellType(j);
%             all_cellmotIDs(c:c+nCells-1) = cell_motion_type;
%             all_trialIDs(c:c+nCells-1) = trialType(k);
%             all_tetIDs(c:c+nCells-1) = tetType(k);
%             all_tet_rates(c:c+nCells-1) = tet_spike_rate;
% 
%             c = c + nCells;
%         end
% 
%         all_CondsIDs(cc:c-1) = repmat(allCond,nTrialType,1);
%         all_CondsIDs_pre(cc:c-1) = repmat(allCond_pre,nTrialType,1);
%         cc = c;
%     end
% end
% 
% %% Plot plasticity curve (time vs amplitude)
% % Plot separate figure for each mouse and cell type
% % all_trialtimes and all_amps are nMice x nCellType x nTrialType 
% % trial order is O/PRE, WO/PRE, W/PRE, W/POST based on previous section
% % cell order is PV, PN, UC based on previous section
% colors = {'r', 'b', 'k'};
% 
% % Iterate through each mouse
% figure('Position', [9,135,1879,420])
% %for i = 1:size(all_amps, 1)
% %for i = [2 3 4 5 10 11]
% for i = [1 6 7 8 9]
%     % Iterate through each cell type
%     %figure('Position', [9,135,1879,420]);
%     for j = 1:size(all_amps, 2)
%         % These variables are an nCells x 1 cell array fitting conditions
%         % (cell type and trial type conditions)
%         pre_tet_times = all_trialtimes{i, j, 3};
%         post_tet_times = all_trialtimes{i, j, 4};
%         pre_amps = all_amps{i, j, 3};
%         post_amps = all_amps{i, j, 4};
% 
%         if ~isempty(pre_amps) && ~isempty(post_amps)
%             temp_nTrials = length(pre_amps{1}); % same trials for each cell
%             temp_nCells = length(pre_amps);
%         else
%             continue
%         end
% 
%         subplot(1, 3, j);
%         for k = 1:temp_nCells
%             x_pre = pre_tet_times{k};
%             x_post = post_tet_times{k};
%             y_pre = pre_amps{k};
%             y_post = post_amps{k};
% 
%             %plot(x_pre, y_pre)
%             hold on
%             %plot(x_post, y_post)
%             
%             scatter(x_pre, y_pre, 'MarkerFaceColor', colors{j}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.1);
%             hold on
%             scatter(x_post, y_post, 'MarkerFaceColor', colors{j}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.1);
%         end
% 
% 
%     end
% end
% 
% 
% 
% %% Box plots & Pre/Post Tet comparison
% % Generates 2 figures
% % First 3 subplots are box plots for each cond for each cell
% % Second 3 subplots are scatter plots for each cell
% exType = {'whiskerTet', 'whiskerOptoTet'};
% to_plot = 'mu_amps' ; % mu_amps, mu_amps_event_traces, mu_amps_mu_traces, mu_pkLocs, mu_pkLocs_event_traces, mu_pkLocs_mu_traces...
%                  % mu_spont_rate, mu_spont_rate_running,
%                  % mu_spont_rate_rest, mu_b_oasis, mu_sn_oasis
% 
% trialType = {'O', 'WO', 'W', 'W'};
% tetType = {'PRE', 'PRE', 'PRE', 'POST'};
% 
% % NOTE: Make sure trialTypes and tetTypes are the same as the ones used
% % when generating pkLocs, amps, traces. all_CondsIDs and all_EventIDs will
% % not be accurate if not
% rm0s = 0; % Remove zeros
% rmNaNs = 0; % Remove cells that did not have data across all trials and cells that were unresponsive to all trials
% rmNaNs_rm0s = 0; % Same as rmNaNs except all zeros are also removed
% 
% % Plot
% colors = {'#bb2525', '#224baa', 'k'}; % [PV, PC, UC]
% xlabelswarm = trialType; xlabelswarm{end} = 'W+T'; xlabelswarm{end+1} = '';
% % unity_line_x = [0 100];
% % unity_line_y = [0 100];
% unity_line_x = [0 1];
% unity_line_y = [0 1];
% 
% maxval = zeros(nCellType,1);
% 
% % calculate ylim
% for map = 1:nExType
%     for j = 1:nCellType
%         for k = 1:nTrialType
%             % Collect data by conditions specified
%             I = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                 strcmp(all_trialIDs,trialType{k}) & strcmp(all_tetIDs,tetType{k});
% 
%             % Only indices that were not NaNs remain as 1s
%             if rmNaNs || rmNaNs_rm0s
%                 I = I & all_CondsIDs & all_anyEventIDs; % Fits index, cell has data for all conditions, and cell has event in at least 1 trial type
%             end
%             
%             if strcmp(to_plot, 'mu_amps')
%                 y = all_mu_amps(I);
%             elseif strcmp(to_plot, 'mu_amps_event_traces')
%                 y = all_mu_amps_event_traces(I);
%             elseif strcmp(to_plot, 'mu_amps_mu_traces')
%                 y = all_mu_amps_mu_traces(I);
%             elseif strcmp(to_plot, 'mu_pkLocs')
%                 y = (all_mu_pkLocs(I) -ev_start) * f2ms;
%             elseif strcmp(to_plot, 'mu_pkLocs_event_traces')
%                 y = (all_mu_pkLocs_event_traces(I) - ev_start) *f2ms;
%             elseif strcmp(to_plot, 'mu_pkLocs_mu_traces')
%                 y = (all_mu_pkLocs_mu_traces(I) -ev_start) *f2ms;
%             elseif strcmp(to_plot, 'mu_spont_rate')
%                 y = all_mu_spont_rate(I);
%             elseif strcmp(to_plot, 'mu_spont_rate_running')
%                 y = all_mu_spont_rate_running(I);
%             elseif strcmp(to_plot, 'mu_spont_rate_rest')
%                 y = all_mu_spont_rate_rest(I);
%             elseif strcmp(to_plot, 'mu_b_oasis')
%                 y = all_mu_b_oasis(I);
%             elseif strcmp(to_plot, 'mu_sn_oasis')
%                 y = all_mu_sn_oasis(I);
%             end
%     
%             % Remove all 0s
%             if rm0s || rmNaNs_rm0s
%                 y(y == 0) = []; 
%             end
% 
%             % Remove any NaNs as this will cause max(y) to return NaN
%             y(isnan(y)) = [];
% 
%             if max(y) > maxval(j)
%                 maxval(j) = max(y);
%             end
%         end
%     end
% end
% 
% unity_line_x = [0 100];
% unity_line_y = [0 100];
% 
% deltas = cell(nExType, nCellType);
% deltas2 = cell(nExType, nCellType);
% tet_rate = cell(nExType, nCellType);
% tet_rate_pos = cell(nExType, nCellType);
% tet_rate_neg = cell(nExType, nCellType);
% deltas_pos = cell(nExType, nCellType);
% deltas_neg = cell(nExType, nCellType);
% countys = cell(1, nExType * nCellType * nTrialType);
% count = 1;
% for map = 1:nExType
%     figure('position', [61,558,1543,420])%, 'Visible', 'off');
%     
%     for j = 1:nCellType
%         subplot(2,3,j)
%         
%         hold on
%         
%         for k = 1:nTrialType
%             % Collect data by conditions specified
%             I = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                 strcmp(all_trialIDs,trialType{k}) & strcmp(all_tetIDs,tetType{k});
% 
%             Ipos = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                 strcmp(all_trialIDs,trialType{k}) & strcmp(all_tetIDs,tetType{k}) & strcmp(all_cellmotIDs, 'POS');
% 
%             Ineg = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                 strcmp(all_trialIDs,trialType{k}) & strcmp(all_tetIDs,tetType{k}) & strcmp(all_cellmotIDs, 'NEG');
% 
% 
% %             if rmNaNs || rmNaNs_rm0s
% %                 I = I & all_CondsIDs & all_anyEventIDs; % Fits index, cell has data for all conditions, and cell has event in at least 1 trial type
% %             end
%     
%             I = I & ~ Ipos & ~ Ineg;
% 
%             if strcmp(to_plot, 'mu_amps')
%                 y = all_mu_amps(I);
%                 ypos = all_mu_amps(Ipos);
%                 yneg = all_mu_amps(Ineg);
%             elseif strcmp(to_plot, 'mu_amps_event_traces')
%                 y = all_mu_amps_event_traces(I);
%             elseif strcmp(to_plot, 'mu_amps_mu_traces')
%                 y = all_mu_amps_mu_traces(I);
%             elseif strcmp(to_plot, 'mu_pkLocs')
%                 y = (all_mu_pkLocs(I) - ev_start) * f2ms;
%             elseif strcmp(to_plot, 'mu_pkLocs_event_traces')
%                 y = (all_mu_pkLocs_event_traces(I) - ev_start) * f2ms;
%             elseif strcmp(to_plot, 'mu_pkLocs_mu_traces')
%                 y = (all_mu_pkLocs_mu_traces(I) - ev_start) * f2ms;
%             elseif strcmp(to_plot, 'mu_spont_rate')
%                 y = all_mu_spont_rate(I);
%             elseif strcmp(to_plot, 'mu_spont_rate_running')
%                 y = all_mu_spont_rate_running(I);
%                 ypos = all_mu_spont_rate_running(Ipos);
%                 yneg = all_mu_spont_rate_running(Ineg);
%             elseif strcmp(to_plot, 'mu_spont_rate_rest')
%                 y = all_mu_spont_rate_rest(I);
%                 ypos = all_mu_spont_rate_rest(Ipos);
%                 yneg = all_mu_spont_rate_rest(Ineg);
%             elseif strcmp(to_plot, 'mu_b_oasis')
%                 y = all_mu_b_oasis(I);
%             elseif strcmp(to_plot, 'mu_sn_oasis')
%                 y = all_mu_sn_oasis(I);
%             end
% 
% 
% %             if rm0s || rmNaNs_rm0s
% %             y(y == 0) = NaN;
% %             end
%     
%             if rm0s || rmNaNs_rm0s
%                 y(y == 0) = NaN; 
%                 ypos(ypos == 0) = NaN;
%                 yneg(yneg == 0) = NaN;
%             end
% 
% 
%             %y(isnan(y)) = [];
%             x = k*ones(1,length(y));
%             xpos = k*ones(1, length(ypos));
%             xneg = k*ones(1, length(yneg));
% %             scatter(x, y, 'filled')
% %             %hold on
% %             scatter(xneg, yneg, 'r')
% %             scatter(xpos, ypos, 'g')
%             boxchart(x, y, 'BoxFaceColor', 'k', 'BoxFaceAlpha', 0.2)
%             %boxchart(xneg, yneg, 'BoxFaceColor', 'r', 'BoxFaceAlpha', 0.5)
%             %boxchart(x, y)
%             %boxchart(xpos, ypos, 'BoxFaceColor', 'g', 'BoxFaceAlpha', 0.5)
%             catchys{count} = y;
%             count = count +1;
%         end
%         xticks(1:5)
%         xticklabels(xlabelswarm)
% 
%         if strcmp(to_plot, 'mu_amps') || strcmp(to_plot, 'mu_amps_event_traces') || strcmp(to_plot, 'mu_amps_mu_traces')
%             ylabel('Mean Amplitude (ΔF/F0)')
%         elseif strcmp(to_plot, 'mu_pkLocs') || strcmp(to_plot, 'mu_pkLocs_event_traces') || strcmp(to_plot, 'mu_pkLocs_mu_traces')
%             ylabel('Mean Latency (msec)')
%         end
%         ylim([0 maxval(j)])
%         title(cellType{j})
% 
%         subplot(2,3,j+3)
%         hold on
%         % Collect data by conditions specified
%         I = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%             strcmp(all_trialIDs,trialType{3}) & strcmp(all_tetIDs,tetType{3});
% 
%         Ipos = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                 strcmp(all_trialIDs,trialType{3}) & strcmp(all_tetIDs,tetType{3}) & strcmp(all_cellmotIDs, 'POS');
% 
%         Ineg = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                  strcmp(all_trialIDs,trialType{3}) & strcmp(all_tetIDs,tetType{3}) & strcmp(all_cellmotIDs, 'NEG');
% % 
% %         if rmNaNs || rmNaNs_rm0s
% %                 I = I & all_CondsIDs & all_anyEventIDs; % Fits index, cell has data for all conditions, and cell has event in at least 1 trial type
% %                 Ipos = Ipos & all_CondsIDs & all_anyEventIDs;
% %                 Ineg = Ineg & all_CondsIDs & all_anyEventIDs;
% %         end
% 
%         if strcmp(to_plot, 'mu_amps')
%             x = all_mu_amps(I);
%             xpos = all_mu_amps(Ipos);
%             xneg = all_mu_amps(Ineg);
%         elseif strcmp(to_plot, 'mu_amps_event_traces')
%             x = all_mu_amps_event_traces(I);
%             xpos = all_mu_amps_event_traces(Ipos);
%             xneg = all_mu_amps_event_traces(Ineg);
%         elseif strcmp(to_plot, 'mu_amps_mu_traces')
%             x = all_mu_amps_mu_traces(I);
%             xpos = all_mu_amps_mu_traces(Ipos);
%             xneg = all_mu_amps_mu_traces(Ineg);
%         elseif strcmp(to_plot, 'mu_pkLocs')
%             x = (all_mu_pkLocs(I) -ev_start) * f2ms;
%             xpos = (all_mu_pkLocs(Ipos) -ev_start) * f2ms;
%             xneg = (all_mu_pkLocs(Ineg) -ev_start) * f2ms;
%         elseif strcmp(to_plot, 'mu_pkLocs_event_traces')
%             x = (all_mu_pkLocs_event_traces(I) - ev_start) * f2ms;
%             xpos = (all_mu_pkLocs_event_traces(Ipos) - ev_start) * f2ms;
%             xneg = (all_mu_pkLocs_event_traces(Ineg) - ev_start) * f2ms;
%         elseif strcmp(to_plot, 'mu_pkLocs_mu_traces')
%             x = (all_mu_pkLocs_mu_traces(I) -ev_start) * f2ms;
%             xpos = (all_mu_pkLocs_mu_traces(Ipos) -ev_start) * f2ms;
%             xneg = (all_mu_pkLocs_mu_traces(Ineg) -ev_start) * f2ms;
%         elseif strcmp(to_plot, 'mu_spont_rate')
%             x = all_mu_spont_rate(I);
%             xpos = all_mu_spont_rate(Ipos);
%             xneg = all_mu_spont_rate(Ineg);
%         elseif strcmp(to_plot, 'mu_spont_rate_running')
%             x = all_mu_spont_rate_running(I);
%             xpos = all_mu_spont_rate_running(Ipos);
%             xneg = all_mu_spont_rate_running(Ineg);
%         elseif strcmp(to_plot, 'mu_spont_rate_rest')
%             x = all_mu_spont_rate_rest(I);
%             xpos = all_mu_spont_rate_rest(Ipos);
%             xneg = all_mu_spont_rate_rest(Ineg);
%         elseif strcmp(to_plot, 'mu_b_oasis')
%             x = all_mu_b_oasis(I);
%             xpos = all_mu_b_oasis(Ipos);
%             xneg = all_mu_b_oasis(Ineg);
%         elseif strcmp(to_plot, 'mu_sn_oasis')
%             x = all_mu_sn_oasis(I);
%             xpos = all_mu_b_oasis(Ipos);
%             xneg = all_mu_b_oasis(Ineg);
%         end
% 
%         if rm0s || rmNaNs_rm0s
%                 x(x == 0) = NaN;
%                 xpos(xpos == 0) = NaN;
%                 xneg(xneg == 0) = NaN;
%         end
% % 
% %         x(isnan(x)) = [];
% %         xpos(isnan(xpos)) = [];
% %         xneg(isnan(xneg)) = [];
% 
% %         if j == 2 & i == 2
% %             x = SAVEX_scatter;
% %         end
% 
%         I = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%             strcmp(all_trialIDs,trialType{4}) & strcmp(all_tetIDs,tetType{4});
% 
%         Ipos = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                 strcmp(all_trialIDs,trialType{4}) & strcmp(all_tetIDs,tetType{4}) & strcmp(all_cellmotIDs, 'POS');
% 
%         Ineg = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                 strcmp(all_trialIDs,trialType{4}) & strcmp(all_tetIDs,tetType{4}) & strcmp(all_cellmotIDs, 'NEG');
% 
% %         if rmNaNs || rmNaNs_rm0s
% %                 I = I & all_CondsIDs & all_anyEventIDs; % Fits index, cell has data for all conditions, and cell has event in at least 1 trial type
% %                 Ipos = Ipos & all_CondsIDs & all_anyEventIDs;
% %                 Ineg = Ineg & all_CondsIDs & all_anyEventIDs;
% %         end
% 
%         if strcmp(to_plot, 'mu_amps')
%             y = all_mu_amps(I);
%             ypos = all_mu_amps(Ipos);
%             yneg = all_mu_amps(Ineg);
%         elseif strcmp(to_plot, 'mu_amps_event_traces')
%             y = all_mu_amps_event_traces(I);
%             ypos = all_mu_amps_event_traces(Ipos);
%             yneg = all_mu_amps_event_traces(Ineg);
%         elseif strcmp(to_plot, 'mu_amps_mu_traces')
%             y = all_mu_amps_mu_traces(I);
%             ypos = all_mu_amps_mu_traces(Ipos);
%             yneg = all_mu_amps_mu_traces(Ineg);
%         elseif strcmp(to_plot, 'mu_pkLocs')
%             y = (all_mu_pkLocs(I) -ev_start) * f2ms;
%             ypos = (all_mu_pkLocs(Ipos) -ev_start) * f2ms;
%             yneg = (all_mu_pkLocs(Ineg) -ev_start) * f2ms;
%         elseif strcmp(to_plot, 'mu_pkLocs_event_traces')
%             y = (all_mu_pkLocs_event_traces(I) - ev_start) * f2ms;
%             ypos = (all_mu_pkLocs_event_traces(Ipos) - ev_start) * f2ms;
%             yneg = (all_mu_pkLocs_event_traces(Ineg) - ev_start) * f2ms;
%         elseif strcmp(to_plot, 'mu_pkLocs_mu_traces')
%             y = (all_mu_pkLocs_mu_traces(I) -ev_start) * f2ms;
%             ypos = (all_mu_pkLocs_mu_traces(Ipos) -ev_start) * f2ms;
%             yneg = (all_mu_pkLocs_mu_traces(Ineg) -ev_start) * f2ms;
%         elseif strcmp(to_plot, 'mu_spont_rate')
%             y = all_mu_spont_rate(I);
%             ypos = all_mu_spont_rate(Ipos);
%             yneg = all_mu_spont_rate(Ineg);
%         elseif strcmp(to_plot, 'mu_spont_rate_running')
%             y = all_mu_spont_rate_running(I);
%             ypos = all_mu_spont_rate_running(Ipos);
%             yneg = all_mu_spont_rate_running(Ineg);
%         elseif strcmp(to_plot, 'mu_spont_rate_rest')
%             y = all_mu_spont_rate_rest(I);
%             ypos = all_mu_spont_rate_rest(Ipos);
%             yneg = all_mu_spont_rate_rest(Ineg);
%         elseif strcmp(to_plot, 'mu_b_oasis')
%             y = all_mu_b_oasis(I);
%             ypos = all_mu_b_oasis(Ipos);
%             yneg = all_mu_b_oasis(Ineg);
%         elseif strcmp(to_plot, 'mu_sn_oasis')
%             y = all_mu_sn_oasis(I);
%             ypos = all_mu_b_oasis(Ipos);
%             yneg = all_mu_b_oasis(Ineg);
%         end
% 
%         z = all_tet_rates(I);
%         zpos = all_tet_rates(Ipos);
%         zneg = all_tet_rates(Ineg);
% 
%         if rm0s || rmNaNs_rm0s
%             y(y == 0) = NaN;
%             ypos(ypos == 0) = NaN;
%             yneg(ypos == 0) = NaN;
%         end
% 
% 
% 
% 
% 
% 
% % 
% %         y(isnan(y)) = [];
% %         ypos(isnan(ypos)) = [];
% %         yneg(isnan(yneg)) = [];
% 
% %         if j == 2 & i == 2
% %             y = SAVEY_scatter;
% %         end
% % 
% %         Irm = isnan(x) | isnan(y);
% %         x(Irm) = [];
% %         y(Irm) = [];
% % 
% %         Irm = isnan(xpos) | isnan(ypos);
% %         xpos(Irm) = [];
% %         ypos(Irm) = [];
% % 
% %         Irm = isnan(xneg) | isnan(yneg);
% %         xneg(Irm) = [];
% %         yneg(Irm) = [];
% 
%         fit = fitlm(x, y, 'Intercept', false);
%         fl = unity_line_x(2)*fit.Coefficients.Estimate;
% 
% %         % bootstrap + 2-tailed t-test
% %         n = 100; p = .6;
% %         slopes = bootstrap(x,y,n,p);
% %         mu = mean(slopes);
% %         sem = std(slopes) / sqrt(n);
% %         sim_data = normrnd(1,sem,n,1);
% %         mu_sim = mean(sim_data);
% %         zscore = (mu-mu_sim)/sem;
%         delta = y ./ x;
%         delta2 = (y - x)/x;
%         deltas{map,j} = delta;
%         %deltas2{i, j} = delta2;
%         deltas2{map, j} = (y-x)/sqrt(2);
%         deltas_pos{map, j} = (ypos - xpos)/sqrt(2);
%         deltas_neg{map, j} = (yneg - xneg)/sqrt(2);
%         tet_rate{map, j} = z;
%         tet_rate_pos{map, j} = zpos;
%         tet_rate_neg{map, j} = zneg;
%         mu = mean(delta);
%         n = length(y);
%         sem = std(delta) / sqrt(n);
%         sim_data = normrnd(1,sem,n,1);
%         mu_sim = mean(sim_data);
%         zscore = abs(mu-mu_sim)/sem;
%         pval = 2*normcdf(zscore, 'upper');
%         
%         plot_color = colors{j};
%         scatter(x,y,'filled','MarkerFaceColor',plot_color,'MarkerFaceAlpha',0.5)
%         scatter(xpos, ypos, 'o', 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'none');
%         scatter(xneg, yneg, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'none');
% 
%         if j == 1
%             xlim([0 1])
%             ylim([0 1])
%         else
%             xlim([0 3])
%             ylim([0 3])
%         end
%         
%         plot(unity_line_x, unity_line_y, 'k', 'LineWidth', 2, 'LineStyle', '--')
%         plot(unity_line_x, [0 fl], 'Color', plot_color, 'LineWidth', 2);
% 
%         xlabel('Pre (Hz)')
%         ylabel('Post (Hz)')
% %         if j == 1
% %             xlim([0 0.5])
% %             ylim([0 0.5])
% %         elseif j == 2
% %             xlim([0 2.5])
% %             ylim([0 2.5])
% %         elseif j == 3
% %             xlim([0 1.5])
% %             ylim([0 1.5])
% %         end
% % 
% %         ylim([0 maxval(j)])
% %         xlim([0 maxval(j)])
% 
%         title(sprintf('P-value: %.4f', pval))
%     end
%     figureTitle = sprintf(...
%             'Evoked win: frames (%d-%d), Threshold: %.2f, Motion win: frames (%d-%d), Evoked time win: %.2f msec', ...
%             ev_start, ev_end, pk_thrs, Motion_win(1), Motion_win(2), f2ms*(ev_end-ev_start));
%     sgtitle(strcat(exType{map}, ' - ', figureTitle))
% end
% 
% %% Quick stats test for NRSA... deal with this later
% % Assuming your cell array is named 'cellArray'
% 
% % Assuming your cell array is named 'catchys'
% 
% % Assuming your cell array is named 'catchys'
% 
% caty = cell(1, 12); % Initialize an empty cell array of size 1x12
% 
% for i = 1:12
%     % Ensure vectors are column vectors before concatenation
%     vector1 = catchys{i}(:);
%     vector2 = catchys{i+12}(:);
%     
%     % Now, concatenate the vectors vertically
%     caty{i} = [vector1; vector2];
% end
% 
% %% Set this...
% %temp_caty = caty;
% 
% % Then rerun with another trial (M) condition.
% 
% % PN whisker is caty{7)
% 
% % PN wo is caty{6}
% 
% pn_w_caty_nm = cond1;% [catchys{7}'];%, catchys{19}'];
% pn_w_caty_m = cond2; %[catchys{8}'];%, catchys{20}'];
% 
% 
% 
% 
% % Your vectors
% 
% 
% % Check for normality using the Lilliefors test
% h1 = lillietest(pn_w_caty_m);
% h2 = lillietest(pn_w_caty_nm);
% 
% alpha = 0.05; % significance level
% if h1 == false
%     disp('pn_w_caty_m is normally distributed');
% else
%     disp('pn_w_caty_m is not normally distributed');
% end
% 
% if h2 == 0
%     disp('pn_w_caty_nm is normally distributed');
% else
%     disp('pn_w_caty_nm is not normally distributed');
% end
% 
% % Perform statistical test based on normality results
% if h1 == 0 && h2 == 0
%     % Both vectors are normally distributed, so we use t-test
%     [~,p,~,stats] = ttest2(pn_w_caty_m, pn_w_caty_nm);
%     disp('Performed t-test:');
%     disp(['t-statistic: ', num2str(stats.tstat)]);
% else
%     % At least one of the vectors is not normally distributed, use Mann-Whitney U test
%     [p,h,stats] = ranksum(pn_w_caty_m, pn_w_caty_nm);
%     disp('Performed Mann-Whitney U test:');
%     disp(['U-statistic: ', num2str(stats.ranksum)]);
% end
% 
% disp(['p-value: ', num2str(p)]);
% 
% 
% 
% 
% 
% 
% %% Box plots & Pre/Post Tet comparison COMBINED
% 
% to_plot = 'mu_amps' ; % mu_amps, mu_amps_event_traces, mu_amps_mu_traces, mu_pkLocs, mu_pkLocs_event_traces, mu_pkLocs_mu_traces...
%                  % mu_spont_rate, mu_spont_rate_running,
%                  % mu_spont_rate_rest, mu_b_oasis, mu_sn_oasis
% colors = colors(1, :);
% 
% maxval = zeros(nCellType,1);
% 
% % calculate ylim
% for map = 1:nExType
%     for j = 1:nCellType
%         for k = 1:nTrialType
%             % Collect data by conditions specified
%             I = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                 strcmp(all_trialIDs,trialType{k}) & strcmp(all_tetIDs,tetType{k});
% 
%             if rmNaNs || rmNaNs_rm0s
%                 I = I & all_CondsIDs & all_anyEventIDs; % Fits index, cell has data for all conditions, and cell has event in at least 1 trial type
%             end
%             
%             if strcmp(to_plot, 'mu_amps')
%                 y = all_mu_amps(I);
%             elseif strcmp(to_plot, 'mu_amps_event_traces')
%                 y = all_mu_amps_event_traces(I);
%             elseif strcmp(to_plot, 'mu_amps_mu_traces')
%                 y = all_mu_amps_mu_traces(I);
%             elseif strcmp(to_plot, 'mu_pkLocs')
%                 y = (all_mu_pkLocs(I) -ev_start) * f2ms;
%             elseif strcmp(to_plot, 'mu_pkLocs_event_traces')
%                 y = (all_mu_pkLocs_event_traces(I) - ev_start) *f2ms;
%             elseif strcmp(to_plot, 'mu_pkLocs_mu_traces')
%                 y = (all_mu_pkLocs_mu_traces(I) -ev_start) *f2ms;
%             elseif strcmp(to_plot, 'mu_spont_rate')
%                 y = all_mu_spont_rate(I);
%             elseif strcmp(to_plot, 'mu_spont_rate_running')
%                 y = all_mu_spont_rate_running(I);
%             elseif strcmp(to_plot, 'mu_spont_rate_rest')
%                 y = all_mu_spont_rate_rest(I);
%             elseif strcmp(to_plot, 'mu_b_oasis')
%                 y = all_mu_b_oasis(I);
%             elseif strcmp(to_plot, 'mu_sn_oasis')
%                 y = all_mu_sn_oasis(I);
%             end
%     
%             if rm0s || rmNaNs_rm0s
%                 y(y == 0) = []; 
%             end
% 
%             y(isnan(y)) = [];
% 
%             if max(y) > maxval(j)
%                 maxval(j) = max(y);
%             end
%         end
%     end
% end
% 
% unity_line_x = [0 100];
% unity_line_y = [0 100];
% 
% deltas = cell(nExType, nCellType);
% deltas2 = cell(nExType, nCellType);
% tet_rate = cell(nExType, nCellType);
% tet_rate_pos = cell(nExType, nCellType);
% tet_rate_neg = cell(nExType, nCellType);
% deltas_pos = cell(nExType, nCellType);
% deltas_neg = cell(nExType, nCellType);
% 
% psize = 30;
% figure('position', [61,558,1543,420])%, 'Visible', 'off');
% for map = 1:nExType
%     
%     for j = 1:nCellType
%         hold on
%         % Collect data by conditions specified
%         I = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%             strcmp(all_trialIDs,trialType{3}) & strcmp(all_tetIDs,tetType{3});
% 
%         Ipos = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                 strcmp(all_trialIDs,trialType{3}) & strcmp(all_tetIDs,tetType{3}) & strcmp(all_cellmotIDs, 'POS');
% 
%         Ineg = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                  strcmp(all_trialIDs,trialType{3}) & strcmp(all_tetIDs,tetType{3}) & strcmp(all_cellmotIDs, 'NEG');
% % 
% %         if rmNaNs || rmNaNs_rm0s
% %                 I = I & all_CondsIDs & all_anyEventIDs; % Fits index, cell has data for all conditions, and cell has event in at least 1 trial type
% %                 Ipos = Ipos & all_CondsIDs & all_anyEventIDs;
% %                 Ineg = Ineg & all_CondsIDs & all_anyEventIDs;
% %         end
% 
%         if strcmp(to_plot, 'mu_amps')
%             x = all_mu_amps(I);
%             xpos = all_mu_amps(Ipos);
%             xneg = all_mu_amps(Ineg);
%         elseif strcmp(to_plot, 'mu_spont_rate')
%             x = all_mu_spont_rate(I);
%             xpos = all_mu_spont_rate(Ipos);
%             xneg = all_mu_spont_rate(Ineg);
%         elseif strcmp(to_plot, 'mu_spont_rate_running')
%             x = all_mu_spont_rate_running(I);
%             xpos = all_mu_spont_rate_running(Ipos);
%             xneg = all_mu_spont_rate_running(Ineg);
%         elseif strcmp(to_plot, 'mu_spont_rate_rest')
%             x = all_mu_spont_rate_rest(I);
%             xpos = all_mu_spont_rate_rest(Ipos);
%             xneg = all_mu_spont_rate_rest(Ineg);
%         elseif strcmp(to_plot, 'mu_b_oasis')
%             x = all_mu_b_oasis(I);
%             xpos = all_mu_b_oasis(Ipos);
%             xneg = all_mu_b_oasis(Ineg);
%         end
% 
%         if rm0s || rmNaNs_rm0s
%                 x(x == 0) = NaN;
%                 xpos(xpos == 0) = NaN;
%                 xneg(xneg == 0) = NaN;
%         end
% 
%         I = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%             strcmp(all_trialIDs,trialType{4}) & strcmp(all_tetIDs,tetType{4});
% 
%         Ipos = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                 strcmp(all_trialIDs,trialType{4}) & strcmp(all_tetIDs,tetType{4}) & strcmp(all_cellmotIDs, 'POS');
% 
%         Ineg = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%                 strcmp(all_trialIDs,trialType{4}) & strcmp(all_tetIDs,tetType{4}) & strcmp(all_cellmotIDs, 'NEG');
% 
% %         if rmNaNs || rmNaNs_rm0s
% %                 I = I & all_CondsIDs & all_anyEventIDs; % Fits index, cell has data for all conditions, and cell has event in at least 1 trial type
% %                 Ipos = Ipos & all_CondsIDs & all_anyEventIDs;
% %                 Ineg = Ineg & all_CondsIDs & all_anyEventIDs;
% %         end
% 
%         if strcmp(to_plot, 'mu_amps')
%             y = all_mu_amps(I);
%             ypos = all_mu_amps(Ipos);
%             yneg = all_mu_amps(Ineg);
%         elseif strcmp(to_plot, 'mu_spont_rate')
%             y = all_mu_spont_rate(I);
%             ypos = all_mu_spont_rate(Ipos);
%             yneg = all_mu_spont_rate(Ineg);
%         elseif strcmp(to_plot, 'mu_spont_rate_running')
%             y = all_mu_spont_rate_running(I);
%             ypos = all_mu_spont_rate_running(Ipos);
%             yneg = all_mu_spont_rate_running(Ineg);
%         elseif strcmp(to_plot, 'mu_spont_rate_rest')
%             y = all_mu_spont_rate_rest(I);
%             ypos = all_mu_spont_rate_rest(Ipos);
%             yneg = all_mu_spont_rate_rest(Ineg);
%         elseif strcmp(to_plot, 'mu_b_oasis')
%             y = all_mu_b_oasis(I);
%             ypos = all_mu_b_oasis(Ipos);
%             yneg = all_mu_b_oasis(Ineg);
%         end
% 
% 
%         if rm0s || rmNaNs_rm0s
%             y(y == 0) = NaN;
%             ypos(ypos == 0) = NaN;
%             yneg(ypos == 0) = NaN;
%         end
%         
%         plot_color = colors{j};
% 
%         unity_line_x = [0 100];
%         unity_line_y = [0 100];
%         if map == 1 % whisker tet
%             subplot(2, 3, j)
%             scatter(xpos,ypos,psize,'filled', 'MarkerEdgeColor',plot_color,'MarkerFaceColor','none', 'MarkerEdgeAlpha', .8, 'LineWidth', 2)
% 
%             hold on
%             fit = y./x;
%             fit(isnan(fit)) = [];
%             fit = mean(fit);
%             %fit = fitlm(xpos, ypos, 'Intercept', false);
%             fl = unity_line_x(2)*fit; %.Coefficients.Estimate;
%             plot(unity_line_x, unity_line_y, 'k', 'LineWidth', 1, 'LineStyle', '--')
%             plot(unity_line_x, [0 fl], 'Color', plot_color, 'LineWidth', 1);
%             
%             scatter(x, y, psize, 'filled','MarkerFaceColor',plot_color,'MarkerFaceAlpha',0.1);
%             %scatter(xneg, yneg, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'none');\
%         elseif map == 2 % whisker opto tet
%             subplot(2, 3, j+3)
%             scatter(xpos,ypos, psize, 'filled', 'MarkerEdgeColor',plot_color,'MarkerFaceColor','none', 'MarkerEdgeAlpha', .8, 'LineWidth', 2)
%             
%             hold on
%             fit = y./x;
%             fit(isnan(fit)) = [];
%             fit = mean(fit);
% 
%             %fit = fitlm(xpos, ypos, 'Intercept', false);
%             fl = unity_line_x(2)*fit; %.Coefficients.Estimate;
%             plot(unity_line_x, unity_line_y, 'k', 'LineWidth', 1, 'LineStyle', '--')
%             plot(unity_line_x, [0 fl], 'Color', plot_color, 'LineWidth', 1);
%             
%             scatter(x, y, psize, 'filled', 'MarkerFaceColor', plot_color, 'MarkerFaceAlpha', 0.1);
%             %scatter(xneg, yneg, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'none');
%         end
%         hold on
% 
% 
%         
%         
% 
%         if strcmp(to_plot, 'mu_amps')
%         xlabel('Pre (ΔF/F0)')
%         ylabel('Post (ΔF/F0)')
%         elseif strcmp(to_plot, 'spont_rate_rest') || strcmp(to_plot, 'spont_rate_running')
%         xlabel('Pre (Hz)')
%         ylabel('Post (Hz)')
%         end
% 
% 
%         if j == 1
%             xlim([0 1])
%             ylim([0 1])
%         elseif j == 2
%             xlim([0 1])
%             ylim([0 1])
%         elseif j == 3
%             xlim([0 1])
%             ylim([0 1])
%         end
%         xlabel('Pre (ΔF/F0)')
%         ylabel('Post (ΔF/F0)')
%         %title(sprintf('P-value: %.4f', pval))
%     end
%     figureTitle = sprintf(...
%             'Evoked win: frames (%d-%d), Threshold: %.2f, Motion win: frames (%d-%d), Evoked time win: %.2f msec', ...
%             ev_start, ev_end, pk_thrs, Motion_win(1), Motion_win(2), f2ms*(ev_end-ev_start));
%     sgtitle(strcat(exType{map}, ' - ', figureTitle))
% end
% 
% %%
% psize = 30;
% alpha_val = 0.5; % Change this value to set the transparency (0 for fully transparent, 1 for fully opaque)
% figure('position', [61,558,1543,420]);
% 
% rmNaNs_rm0s = true;
% 
% % Define colors for each cell type
% colors = {{'edge', hex2rgb('#bb2525'), 'face', hex2rgb('#ea9595')}; % PV
%           {'edge', hex2rgb('#224baa'), 'face', hex2rgb('#7b9be5')}; % PC
%           {'edge', 'k', 'face', hex2rgb('#949494')}}; % UC
% 
% for map = 1:nExType
%     for j = 1:nCellType
%         subplot(nExType, nCellType, (map-1)*nCellType+j)
%         hold on
% 
%         % Collect data by conditions specified
%         I_pre = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%             strcmp(all_trialIDs,trialType{3}) & strcmp(all_tetIDs,tetType{3});
%         I_post = strcmp(all_exIDs,exType{map}) & strcmp(all_cellIDs,cellType{j}) & ...
%             strcmp(all_trialIDs,trialType{4}) & strcmp(all_tetIDs,tetType{4});
% 
%         % Determine which data to plot based on 'to_plot' value
%         if strcmp(to_plot, 'mu_amps')
%             y_pre = all_mu_amps(I_pre);
%             y_post = all_mu_amps(I_post);
%         elseif strcmp(to_plot, 'mu_spont_rate')
%             y_pre = all_mu_spont_rate(I_pre);
%             y_post = all_mu_spont_rate(I_post);
%         end
% 
%         % Remove zeros if needed
%         if rm0s || rmNaNs_rm0s
%             y_pre(y_pre == 0) = NaN;
%             y_post(y_post == 0) = NaN;
%         end
% 
%         % Create x-values
%         x_pre = ones(size(y_pre));
%         x_post = 2*ones(size(y_post));
% 
%         % Plot data
%         scatter(x_pre, y_pre, psize, 'MarkerEdgeColor', colors{j}{2}, 'MarkerFaceColor', colors{j}{4}, 'MarkerFaceAlpha', alpha_val);
%         hold on
%         scatter(x_post, y_post, psize, 'MarkerEdgeColor', colors{j}{2}, 'MarkerFaceColor', colors{j}{4}, 'MarkerFaceAlpha', alpha_val);
%         plot([x_pre'; x_post'], [y_pre'; y_post'], '-', 'Color', colors{j}{2})
% 
%         xlim([0.5 2.5])
%         if strcmp(to_plot, 'mu_amps')
%             ylabel('Amplitude (\DeltaF/F0)')
%         elseif strcmp(to_plot, 'mu_spont_rate')
%             ylabel('Rate (Hz)')
%         end
% 
%         title(sprintf('%s, %s', exType{map}, cellType{j}))
%     end
% end
% 
% 
% 
% 
% %% Pre/Post deltas
% k = 1;
% figure('position', [61,558,1543,420])
% hold on
% xtickswarm = cellType;
% yz = cell(nExType, nCellType);
% countyz = cell(nExType,nCellType);
% for map = 1:nCellType
% %     xtickswarm{i} = strcat(xtickswarm{i},": ",string(pval));
% 
%     for j = 1:nExType
%         y = deltas2{j,map};
%         x = k*ones(1,length(y));
%         yz{j, map} = y;
%         countyz{j, map} = sum(~isnan(y));
% 
%         color = colors{map};
%         swarmchart(x, y, 100, 'MarkerFaceColor', color, 'MarkerEdgeColor', color, 'MarkerFaceAlpha', 0.5)
% 
%         k = k + 1;
%     end
%     ylabel('Δ Evoked Amplitude (ΔF/F0)', 'FontWeight', 'bold', 'FontSize', 15)
%  
% end
% 
% pval = zeros(nCellType, 1);
% % paired t-test btwn groups
% for map = 1:nCellType
%     y1 = yz{1, map};
%     y2 = yz{2, map};
%     
%     h1 = lillietest(y1);
%     h2 = lillietest(y2);
%     
%     if h1 ==0 && h2 == 0
%         group = [ones(size(y1)); 2*ones(size(y2))];
%         h = vartestn([y1; y2], group, 'TestType', 'LeveneAbsolute', ...
%             'Display', 'off');
%     
%         if h == 0
%             disp('using t-test')
%             [~,pval] = ttest2(y1,y2);
%         else
%             disp('using Welch''s t-test')
%             [~,pval] = ttest2(y1,y2,'Vartype','unequal');
%         end
%     else
%         disp('using Mann-Whitney U test')
%         pval(map) = ranksum(y1,y2);
%     end
% 
%     xtickswarm{map} = strcat(xtickswarm{map},": ",string(pval(map)));
% end
% 
% 
% xticks([1.5, 3.5, 5.5])
% xticklabels(xtickswarm)
% 
% figureTitle = sprintf(...
%             'Evoked win: frames (%d-%d), Threshold: %.2f, Motion win: frames (%d-%d), Evoked time win: %.2f msec', ...
%             stimOn, ev_end, pk_thrs, Motion_win(1), Motion_win(2), f2ms*(ev_end-stimOn));
%     sgtitle(figureTitle)
% 
% %% Plots for tet rate vs delta
% colors = {'#bb2525', '#224baa', 'k'; '#bb2525', '#224baa', 'k'};
% order = [1, 3, 5; 2, 4, 6];
% 
% figure('position', [14,595,1902,232]);
% for map = 1:nCellType
% %     xtickswarm{i} = strcat(xtickswarm{i},": ",string(pval));
% 
%     for j = 1:nExType
%         y = deltas2{j,map};
%         x = tet_rate{j, map};
%         xpos = tet_rate_pos{j, map};
%         ypos = deltas_pos{j, map};
%         xneg = tet_rate_neg{j, map};
%         yneg = deltas_neg{j, map};
% %         yz{j, i} = y;pre-tet
% %         countyz{j, i} = sum(~isnan(y));
% % 
% %         color = colors{i};
% 
%         color = colors{j, map};
%         subplot(1, 6, order(j, map))
%         
%         scatter(x, y, 100, 'MarkerFaceColor', color, 'MarkerEdgeColor', color, 'MarkerFaceAlpha', 0.5)
%         hold on
%         scatter(xpos, ypos, 100, 'o', 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'none')
%         scatter(xneg, yneg, 100, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'none')
% 
%     end
%     ylabel('Δ Evoked Amplitude (ΔF/F0)')
%     xlabel('Tet Event Rate')
%  
% end
% 
% 
% %% Box plots for all pre-tet conditions
% % Use all other variables generated earlier
% colors_POS = {'#bb2525', '#224baa', 'k'};
% colors = {'#ea9595', '#7b9be5', 'k'};
% to_plot = 'mu_amps'; % mu_amps, mu_amps_event_traces, mu_amps_mu_traces, mu_pkLocs, mu_pkLocs_event_traces, mu_pkLocs_mu_traces
% trialType = {'W', 'WO', 'O'};
% tetType = {'PRE', 'PRE', 'PRE'};
% nCellType = length(cellType);
% nTrialType = length(trialType);
% 
% % NOTE: Make sure trialTypes and tetTypes are the same as the ones used
% % when generating pkLocs, amps, traces. all_CondsIDs_pre and all_EventIDs_pre will
% % not be accurate if not
% rm0s = 1; % Remove zeros
% rmNaNs = 0; % Remove cells that did not have data across all trials and cells that were unresponsive to all trials
% rmNaNs_rm0s = 0; % Same as rmNaNs except zeros are also removed
% 
% % Plot
% xlabelswarm = {'W', 'W-CF', 'CF'};
% maxval = zeros(nCellType,1);
% 
% % Calculate ylim
% for j = 1:nCellType
%     for k = 1:nTrialType
%         % Collect data by conditions specified
%         I = strcmp(all_cellIDs,cellType{j}) & strcmp(all_trialIDs,trialType{k}) & strcmp(all_tetIDs,tetType{k}) ;
% 
%        
%         
% 
%     
%             %I = I & ~ Ipos & ~ Ineg;
% 
% 
%         if rmNaNs || rmNaNs_rm0s
%             I = I & all_CondsIDs_pre & all_anyEventIDs_pre; % Fits index, cell has data for all conditions, and cell has event in at least 1 trial type
%         end
% 
%         if strcmp(to_plot, 'mu_amps')
%             y = all_mu_amps(I);
%         elseif strcmp(to_plot, 'mu_amps_event_traces')
%             y = all_mu_amps_event_traces(I);
%         elseif strcmp(to_plot, 'mu_amps_mu_traces')
%             y = all_mu_amps_mu_traces(I);
%         elseif strcmp(to_plot, 'mu_pkLocs')
%             y = (all_mu_pkLocs(I) - ev_start) * f2ms;
%         elseif strcmp(to_plot, 'mu_pkLocs_event_traces')
%             y = (all_mu_pkLocs_event_traces(I) - ev_start) * f2ms;
%         elseif strcmp(to_plot, 'mu_pkLocs_mu_traces')
%             y = (all_mu_pkLocs_mu_traces(I) - ev_start) * f2ms;
%         elseif strcmp(to_plot, 'mu_spont_rate')
%             y = all_mu_spont_rate(I);
%         elseif strcmp(to_plot, 'mu_spont_rate_running')
%             y = all_mu_spont_rate_running(I);
%         elseif strcmp(to_plot, 'mu_spont_rate_rest')
%             y = all_mu_spont_rate_rest(I);
%         elseif strcmp(to_plot, 'mu_b_oasis')
%             y = all_mu_b_oasis(I);
%         elseif strcmp(to_plot, 'mu_sn_oasis')
%             y = all_mu_sn_oasis(I);
%         end
% 
%         if rm0s || rmNaNs_rm0s
%             y(y == 0) = []; 
%             
%         end
%         
%         if max(y) > maxval(j)
%             maxval(j) = max(y);
%         end
%     end
% end
% 
% 
%     
% figure('position', [61,558,1543,420])%, 'Visible', 'off');
% ys = cell(nTrialType, 1);
% for j = 1:nCellType
%     subplot(1,3,j)
%     
%     hold on
% 
%     pValues = []; % Store p-values for each comparison
%     
%     for k = 1:nTrialType
%         % Collect data by conditions specified
%         I = strcmp(all_cellIDs,cellType{j}) & strcmp(all_trialIDs,trialType{k}) & strcmp(all_tetIDs,tetType{k});
%         sum(I)
%          Ipos = strcmp(all_exIDs,exType{j}) & strcmp(all_trialIDs, trialType{k}) & strcmp(all_tetIDs,tetType{k}) & strcmp(all_cellmotIDs, 'POS');
%          sum(Ipos)
% 
%         I = I & ~Ipos;
% 
% 
%         
%         
% 
% %         if rmNaNs || rmNaNs_rm0s
% %             I = I & all_CondsIDs_pre & all_anyEventIDs_pre; % Fits index, cell has data for all conditions, and cell has event in at least 1 trial type
% %             Ipos = Ipos & all_CondsIDs_pre & all_anyEventIDs_pre;
% %         end
% 
%         if strcmp(to_plot, 'mu_amps')
%             y = all_mu_amps(I);
%             ypos = all_mu_amps(Ipos);
%         elseif strcmp(to_plot, 'mu_amps_event_traces')
%             y = all_mu_amps_event_traces(I);
%         elseif strcmp(to_plot, 'mu_amps_mu_traces')
%             y = all_mu_amps_mu_traces(I);
%         elseif strcmp(to_plot, 'mu_pkLocs')
%             y = (all_mu_pkLocs(I) - ev_start) * f2ms;
%         elseif strcmp(to_plot, 'mu_pkLocs_event_traces')
%             y = (all_mu_pkLocs_event_traces(I) - ev_start) * f2ms;
%         elseif strcmp(to_plot, 'mu_pkLocs_mu_traces')
%             y = (all_mu_pkLocs_mu_traces(I) - ev_start) * f2ms;
%         end
% 
% %         if rm0s || rmNaNs_rm0s
% %             y(y == 0) = [];
% %             ypos(ypos == 0) = [];
% %         end
% 
%         
%         ys{k} = y;
%         x = k*ones(1,length(y));
%         xpos = k*ones(1,length(ypos));
%         color = colors{j};
%         boxchart(x, y, "BoxFaceColor", colors{j}, 'MarkerColor', colors{j}, 'BoxWidth', 0.4, 'Notch', 'on', 'JitterOutliers', 'on', 'MarkerStyle', 'none', 'WhiskerLineColor', colors{j});
%         boxchart((xpos+.5), ypos, "BoxFaceColor", colors_POS{j}, 'MarkerColor', colors_POS{j}, 'BoxWidth', 0.4, 'Notch', 'on', 'JitterOutliers', 'on', 'MarkerStyle', 'none', 'WhiskerLineColor', colors_POS{j});
%         %swarmchart(x, y, 60, 'MarkerFaceColor', color, 'MarkerEdgeColor', color, 'MarkerFaceAlpha', 0.5)
%         % Do the statistical test if comparing W and WO groups
%         
% %         if j == 1 && (k == 1 || k == 2)
% %             if k == 1 % First group
% %                 group1 = y;
% %             else % Second group
% %                 group2 = y;
% %                 % Perform the Mann-Whitney U test
% %                 p = ranksum(group1, group2);
% %                 pValues(end+1) = p;
% %             end
% %         end
% 
%     end
%     xticks(1:5)
%     xticklabels(xlabelswarm)
%     yticks([0 0.5 1])
%     if strcmp(to_plot, 'mu_amps') || strcmp(to_plot, 'mu_amps_event_traces') || strcmp(to_plot, 'mu_amps_mu_traces')
%         ylabel('Mean Evoked Amplitude (ΔF/F0)', 'FontWeight', 'bold')
%     elseif strcmp(to_plot, 'mu_pkLocs') || strcmp(to_plot, 'mu_pkLocs_event_traces') || strcmp(to_plot, 'mu_pkLocs_mu_traces')
%         ylabel('Mean Latency (msec)')
%     end
%     
%     title(cellType{j})
% 
%     figureTitle = sprintf(...
%         'Evoked win: frames (%d-%d), Threshold: %.2f, Motion win: frames (%d-%d), Evoked time win: %.2f msec', ...
%         stimOn, ev_end, pk_thrs, Motion_win(1), Motion_win(2), f2ms*(ev_end-stimOn));
% 
%     % Add significance brackets and asterisks
%     maxY = maxval(j) * 1.2;  % Adjust the maximum y value for room
%     yHeight = maxval(j) * 0.05;  % Height of the significance bracket
%     for map = 1:numel(pValues)
%         p = pValues(map);
%         if p < 0.05
%             hold on;
%             line([map map+1], [maxY maxY], 'Color', 'k', 'LineWidth', 1)  % Bracket line
%             line([map map], [maxY-yHeight maxY], 'Color', 'k', 'LineWidth', 1)  % Left side of bracket
%             line([map+1 map+1], [maxY-yHeight maxY], 'Color', 'k', 'LineWidth', 1)  % Right side of bracket
%             if p < 0.001
%                 text(map+0.5, maxY + yHeight, '***', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 14)
%             elseif p < 0.01
%                 text(map+0.5, maxY + yHeight, '**', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 14)
%             else
%                 text(map+0.5, maxY + yHeight, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 14)
%             end
%         end
%     end
%     
%     % Adjust y-limit of the plot
%     ylim([0 maxY + 2*yHeight])
%     ylim([-0.1 1])
%     box on
% 
% end
% 
% % paired t-test btwn groups
% pvals = zeros(nTrialType);
% for map = 1:nTrialType
%     for j = 1:nTrialType
%         if map == j
%             continue
%         end
% 
%         y1 = ys{map};
%         y2 = ys{j};
% 
%         h1 = lillietest(y1);
%         h2 = lillietest(y2);
% 
%         if h1 ==0 && h2 == 0
%             group = [ones(size(y1)); 2*ones(size(y2))];
%             h = vartestn([y1; y2], group, 'TestType', 'LeveneAbsolute', ...
%                 'Display', 'off');
% 
%             if h == 0
%                 disp('using t-test')
%                 [~,pvals(map,j)] = ttest2(y1,y2);
%             else
%                 disp('using Welch''s t-test')
%                 [~,pvals(map,j)] = ttest2(y1,y2,'Vartype','unequal');
%             end
%         else
%             disp('using Mann-Whitney U test')
%             pvals(map,j) = ranksum(y1,y2);
%         end
%     end
% end
% 
% 
% 
% sgtitle(figureTitle);
% %% Plot traces (heatmaps)
% % Use all other variables generated earlier
% to_plot = 'mu_event_traces'; % mu_event_traces or mu_traces
% trialType = fliplr({'O', 'WO', 'W'});
% %trialType = fliplr({'WO', 'W'});
% tetType = {'PRE', 'PRE', 'PRE'};
% colors = {'r','b','k'};
% color = [187/255 37/255 37/255; 34/255 75/255 170/255; 0 0 0];
% %color = [1 0 0; 0 0 1; 0 0 0];
% nCellType = length(cellType);
% nTrialType = length(trialType);
% 
% %%%%%
% colormap_PV = [linspace(187/255, 205/255, 256); linspace(34/255, 51/255, 256); linspace(0, 0, 256)]'; % dark red to burnt orange
% colormap_PC = [linspace(0, 60/255, 256); linspace(0, 179/255, 256); linspace(139/255, 90/255, 256)]'; % navy blue to medium green
% colormap_UC = [linspace(0, 211/255, 256); linspace(0, 211/255, 256); linspace(0, 211/255, 256)]'; % black to light gray
% 
% 
% plot_win = [294, 310+31+16];
% 
% xticks([10 26 42 57])
% 
% xticklabels([0 500 1000 1500])
% 
% xlimit = [0, plot_win(2)-plot_win(1)];
% 
% rainbow = cell(nCellType, 1);
% alphas = cell(nCellType, 1);
% rainbow_out = cell(nCellType, 1);
% num_outlier_cells = cell(nCellType, 1);
% clim = zeros(nCellType, 2);
% Isort = cell(nCellType,1);
% Isort_max = cell(nCellType, 1);
% Ibelow_thr = cell(nCellType, 1);
% max_per_cell_store = cell(nCellType, 1);
% for map = 1:nCellType
%     for j = 1:nTrialType
%     
%         I = strcmp(all_cellIDs,cellType{map}) & strcmp(all_trialIDs,trialType{j}) & strcmp(all_tetIDs,tetType{j}) & all_CondsIDs_pre; %& all_anyEventIDs_pre;
%         
%         if strcmp(to_plot, 'mu_traces')
%             x = all_mu_traces(plot_win(1):plot_win(2), I);
%             pkLocs = all_mu_pkLocs_mu_traces(I);
%         else 
% 
%             x = all_mu_event_traces(plot_win(1):plot_win(2), I);
%             non_event_cells = all(isnan(x));
%             x2 = all_mu_non_event_traces(plot_win(1):plot_win(2), I);
%             x(:, non_event_cells) = x2(:, non_event_cells);
% 
%             pkLocs = all_mu_pkLocs_event_traces(I);
%             pkLocs(non_event_cells) = 0;
%         end
%         
%         % Calculate color bar limits
%         % max
%         m = max(x, [], 'all');
%         if m > clim(map, 2)
%             clim(map, 2) = m;
%         end
%         
%         % min
%         clim(map, 1) = 0;
%         m = min(x, [], 'all');
%         if m < clim(map, 1)
%             clim(map, 1) = m;
%         end
% 
%         if isempty(Ibelow_thr{map})
%             Ibelow_thr{map} = true(length(pkLocs),1);
%         else
%             Ibelow_thr{map} = Ibelow_thr{map} & (max(x)' > 1);
%         end
% 
%         if strcmp(trialType{j}, 'W')
%             max_per_cell = max(x)';
%             num_cell = length(max_per_cell);
%             
% %             rainbow{i} = lines(num_cell);
% %             rainbow{i} = jet(num_cell{i});
% %             rainbow{i} = flipud(cmap([187, 37, 37]/255, num_cell, 20, 50));
% %             if strcmp(cellType{i}, 'PV')
% %                 num_outlier_cells{i} = round(num_cell*.2);
% %             elseif strcmp(cellType{i}, 'PC')
% %                 num_outlier_cells{i} = round(num_cell*.02);
% %             elseif strcmp(cellType{i}, 'UC')
% %                 num_outlier_cells{i} = round(num_cell*.02);
% %             end
% %             rainbow_out{i} = lines(num_outlier_cells{i});
% %             
% %             if strcmp(cellType{i}, 'PV')
% %                 rainbow_out{i} = (cmap([187, 37, 37]/255, num_outlier_cells{i}, 20, 50));
% %             elseif strcmp(cellType{i}, 'PC')
% %                 rainbow_out{i} = (cmap([34, 75, 170]/255, num_outlier_cells{i}, 20, 50));
% %             elseif strcmp(cellType{i}, 'UC')
% %                 rainbow_out{i} = (cmap([0, 0, 0]/255, num_outlier_cells{i}, 5, 30));
% %             end
% %             alphas{i} = flip(linspace(0.1, 1, num_cell)');
% 
% 
% 
%             alphas{map} = max_per_cell ./ max(max_per_cell);
%             [~,Isort{map}] = sort(pkLocs, 'descend');
%             [~,Isort_max{map}] = sort(max_per_cell, 'descend');
%             max_per_cell_store{map} = sort(max_per_cell, 'descend');
%         end
%     end
% end
% 
% % figure('position', [61,558,1543,420])%, 'Visible', 'off');
% % c = 1;
% % for i = 1:nCellType
% %     for j = 1:nTrialType
% %         subplot(3, 3, c)
% %         hold on
% %         I = strcmp(all_cellIDs,cellType{i}) & strcmp(all_trialIDs,trialType{j}) & strcmp(all_tetIDs,tetType{j}) & all_CondsIDs_pre;% & all_anyEventIDs_pre;
% %         if strcmp(to_plot, 'mu_traces')
% %             x = all_mu_traces(plot_win(1):plot_win(2), I);
% %         else
% %             x = all_mu_event_traces(plot_win(1):plot_win(2), I);
% %             non_event_cells = all(isnan(x));
% %             x2 = all_mu_non_event_traces(plot_win(1):plot_win(2), I);
% %             x(:, non_event_cells) = x2(:, non_event_cells);
% %         end
% % 
% % %         imagesc(x', clim(i, :));
% %         imagesc(x(:,Isort{i})', [0 0.5])
% %         xline(stimOn-plot_win(1), 'LineWidth', 2, 'Color', 'k')
% %         c = c+1;
% %     end
% % end
% 
% % PLOT AVG TRACES AND MOTION
% % Use all other variables generated earlier
% figure('position', [61,169,1359,809])%, 'Visible', 'off');
% mulc = [187, 37, 37, 0.05*255; 34, 75, 170, 0.05*255; 0 0 0 0.05*255]/255; % PV, PC, UC
% c = 1;
% for map = 1:nTrialType
%     for j = 1:nCellType
% 
%         if mod(c,4) == 0
%             c = c + 1;
%         end
% 
%         subplot(3, 4, c)
%         hold on
%         I = strcmp(all_cellIDs,cellType{j}) & strcmp(all_trialIDs,trialType{map}) & strcmp(all_tetIDs,tetType{map}) & all_CondsIDs_pre;% & all_anyEventIDs_pre;
% 
% 
%         if strcmp(to_plot, 'mu_traces')
%             x = all_mu_traces(plot_win(1):plot_win(2), I);
%         else
%             x = all_mu_event_traces(plot_win(1):plot_win(2), I);
%             non_event_cells = all(isnan(x));
%             x2 = all_mu_non_event_traces(plot_win(1):plot_win(2), I);
%             x(:, non_event_cells) = x2(:, non_event_cells);
%         end
% 
%         x = x(:, Isort_max{j});
%         mux = mean(x,2);
%         %plot(smooth(mux),'Color',colors{j},'LineWidth',4)
%         
%         % Only plot depending on Ibelow_thr
% %         x = x(:, Ibelow_thr{j}(Isort_max{j}));
% 
%         for k = 1:size(x, 2)
% %             color = rainbow{i}(k, :);
% %             color = [rainbow_out{j}(1, :), 0.2];
% %             if k <= num_outlier_cells{j}
% %                 color = rainbow_out{j}(k, :);
% %             end
% 
% %             if max(x(:, k)) < 0.2
% %                 continue
% %             end
% 
%             % Smooth pv traces bc abby is anal
% %             if Ibelow_thr{j}(Isort_max{j}(k))
% %                 alpha = 1;
% %             else
% %                 alpha = .2;
% %             end
% 
%             if strcmp(cellType{j},'PV')
%                 plot(smooth(x(:, k)), 'Color', horzcat(color(j,:),alphas{j}(Isort_max{j}(k))), 'LineWidth', 1);
%             else
%                 plot(x(:,k), 'Color', horzcat(color(j,:),alphas{j}(Isort_max{j}(k))), 'LineWidth', 1);
%             end
%         end
% 
% 
% %         if strcmp(trialType{j}, 'O') || strcmp(trialType{j}, 'WO')
% %             xline(stimOn-plot_win(1), 'LineWidth', 3, 'Color', [0 0 1 0.3])
% %         else
%         xline(stimOn-plot_win(1) -1 , 'LineWidth', 2)
% %         end
% 
%         xlim(xlimit)
%         xticks([10 26 42 57])
%         xticklabels([0 500 1000 1500])
%         xlabel('msec')
% %         if i == 3
% %             xticklabels([0 500 100 1500])
% %             xlabel("msec")
% %         end
%         if j == 1
%             ylabel('ΔF/F0', 'FontSize', 12)
%         end
%         ylim(clim(j, :))
%         
% 
%         if c <= 3
%             title(strcat(cellType{j}, " (", string(size(x,2)), ")"))
%         end
%         c = c + 1;
%     end
% end
% 
% figureTitle = sprintf(...
%             'Evoked win: frames (%d-%d), Threshold: %.2f, Motion win: frames (%d-%d), Evoked time win: %.2f msec', ...
%             stimOn, ev_end, pk_thrs, Motion_win(1), Motion_win(2), f2ms*(ev_end-stimOn));
%     sgtitle(figureTitle)
% 
% % Plot motion info
% % Make sure calculations use same orderings as above
% d = zeros(nTrialType, 1);
% 
% % Calculate nTrials
% for map = 1:size(allData.mouseIDs, 2)
%    for j = 1:nTrialType
%        temp = all_motion(map, 1, j);
%        if isempty(temp)
%            continue
%        end
% 
%        temp = temp{1};
%        d(j) = d(j) + size(temp, 2);
%    end
% end
% 
% % preallocate
% nFrames = size(allData.data{1}.signal,1);
% all_motion2 = cell(nTrialType,1);
% for map = 1:nTrialType
%     all_motion2{map} = zeros(nFrames, d(map));
% end
% 
% % Get mean and sem
% dd = ones(nTrialType,1);
% for map = 1:size(allData.mouseIDs, 2)
%    for j = 1:nTrialType
%        temp = all_motion{map, 1, j};
%        if isempty(temp)
%            continue
%        end
% 
%        temp = temp{1};
%        nTrials = size(temp,2);
%        all_motion2{j}(:,dd(j):dd(j)+nTrials-1) = temp;
%        dd(j) = dd(j) + nTrials;
%    end
% end
% 
% % Generate motion histograms
% for map = 1:nTrialType
%     subplot(3, 4, 4*map)
%     hold on
%     mu_motion = mean(all_motion2{map}(plot_win(1):plot_win(2),:),2);
%     sem_motion = std(all_motion2{map}(plot_win(1):plot_win(2),:),[],2) / sqrt(d(map));
%     curve1 = smooth(mu_motion + sem_motion/2, 5, 'moving');
%     curve2 = smooth(mu_motion - sem_motion/2, 5, 'moving');
%     x = 1:numel(mu_motion);
%     x2 = [x, fliplr(x)];
%     inbetween = [curve1', fliplr(curve2')];
%     fill(x2, inbetween, [.7 .7 .7])
%     plot(smooth(mu_motion, 5, 'moving'), 'color', 'k', 'LineWidth', 2)
%     xticks([10 26 42 57])
%     if map == 3
%         xlabel('msec')
%     else
%         xticks([])
%     end
%     xticklabels([0 500 100 1500])
% %     plot(smooth(mu_motion+sem_motion/2, 5, 'moving'), 'color', 'k')
% %     plot(smooth(mu_motion-sem_motion/2, 5, 'moving'), 'color', 'k')
% %     histogram('BinEdges', 0:length(mu_motion), 'BinCounts', [mu_motion], 'EdgeAlpha', 0, 'FaceColor', 'k', 'FaceAlpha', 0.5)
% %     histogram('BinEdges', 0:length(mu_motion), 'BinCounts', [(mu_motion + sem_motion)], 'EdgeAlpha', 0, 'FaceColor', 'k', 'FaceAlpha', 0.2)
%     xline(stimOn-plot_win(1), 'LineWidth', 2, 'color', 'k')
%     c = c + 1;
%     ylim([0 1])
%     xlim(xlimit)
%     ylabel('P(Motion)', 'FontSize', 12)
%     if map == 1
%         title("Ave. Motion")
%     end
% end
% 
% figureTitle = sprintf(...
%             'Evoked win: frames (%d-%d), Threshold: %.2f, Motion win: frames (%d-%d), Evoked time win: %.2f msec', ...
%             stimOn, ev_end, pk_thrs, Motion_win(1), Motion_win(2), f2ms*(ev_end-stimOn));
%     sgtitle(figureTitle)
% 
% %% 
% % Get cell and trial type 
% plot_UC = 0;
% plot_PV = 1;
% plot_PC = 0;
% I = strcmp(all_cellIDs,'PV') & strcmp(all_trialIDs,'WO') & strcmp(all_tetIDs,'PRE') & all_CondsIDs_pre; %& all_anyEventIDs_pre;
% 
% x = all_mu_traces(100:600, I);
% y = all_mu_motion(100:600, I);
% 
% if plot_UC
%     x = x(:, Isort_max{3});
% elseif plot_PV
%     x = x(:, Isort_max{1});
% elseif plot_PC
%     x = x(:, Isort_max{2});
% end
% 
% %figure; plot(mean(y,2))
% 
% 
% n = size(x, 2);  % Length of your vector
% 
% % Assuming amplitudes is a vector of size nCells x 1
% if plot_UC
%     amplitudes = max_per_cell_store{3};
% elseif plot_PV
%     amplitudes = max_per_cell_store{1};
% elseif plot_PC
%     amplitudes = max_per_cell_store{2};
% end
% 
% % Get maximum amplitude
% maxAmplitude = max(amplitudes);
% 
% 
% % Define RGB for yellow and red
% yellow = [1, 0, 0];  % yellow
% red = [0, 0, 1];  % red
% 
% % Generate the color map
% nColors = 100;  % Number of colors in the color map
% R = linspace(yellow(1), red(1), nColors);
% G = linspace(yellow(2), red(2), nColors);
% B = linspace(yellow(3), red(3), nColors);
% colorMap = [R', G', B'];
% 
% % Scale amplitudes to color map indices
% scaledAmplitudes = round(amplitudes/maxAmplitude * nColors);
% findzero = scaledAmplitudes == 0;
% scaledAmplitudes(findzero) = 1;
% 
% 
% hold on;  % Allows multiple plots on the same figure
% 
% % Plot each trace with color based on amplitude
% for i = 1:length(x)
%     colorMap_ind = scaledAmplitudes(i);
%     if scaledAmplitudes(i) < 60
%         continue
%     else
%     colorPLOT = [colorMap(colorMap_ind, :), 1];
%     plot(smooth(x(:, i)), 'Color', colorPLOT, 'LineStyle', ':');
%     end
% end
% ylim([-0.3 5])
% 
% hold off;  % No more plots on this figure
% 
% 
% 
% % UC: 35
% 
% 
% 
% % % Define RGB for dark red and burnt orange
% % dark_red = [0, 0, 0]/255;  % dark red
% % burnt_orange = [255, 255, 255]/255;  % burnt orange
% % 
% % % Generate the gradient
% % R = linspace(dark_red(1), burnt_orange(1), n);
% % G = linspace(dark_red(2), burnt_orange(2), n);
% % B = linspace(dark_red(3), burnt_orange(3), n);
% % 
% % % Combine into an RGB matrix
% % RGB = [R', G', B'];
% % 
% % % Convert RGB matrix to hexadecimal color codes
% % hex_colors = cell(1, n);
% % for i = 1:n
% %     hex_colors{i} = rgb2hex_custom(RGB(i, :));
% % end
% % 
% % disp(hex_colors);
% % 
% % 
% % % Plot each trace
% % for i = 1:nCells
% %     plot(x(:, i), 'Color', RGB(i, :));
% %     hold on
% % end
% % 
% % hold off;  % No more plots on this figure
% 
% 
% 
% 
% %% Plot Population Average Event Trace for PV/PC during M/NM for W/WO pre-tet
% % Remember to rerun section that retrieves all data to switch between M/NM
% 
% nMice = 11;
% pawin = [294, 294+31+31+31+31];
% stimOn = 310;
% colors = {[187, 37 37]/255; [34 75 170]/255; [0 0 0]}; % PV, PC
% 
% % Copied here for reference
% % cellType = {'PV', 'PC', 'UC'};
% % trialType = {'O', 'WO', 'W', 'W'};
% % tetType = {'PRE', 'PRE', 'PRE', 'POST'};
% 
% figure()
% hold on
% 
% % Pulling data from all_event_traces
% % all_event_traces dimensions: nMice x nCellType x nTrialType
% 
% % Loop numbers correspond to trialType/tetType indices
% for k = 2:3
%     % Preallocate
%     pop_ave_event_trace = zeros(pawin(2)-pawin(1)+1,1);
% 
%     % Loop numbers correspond to cellType indices
%     for j = 1:3
%     %for j = 1:2
% 
%         counter = 0; % counter for running average
%         for map = 1:nMice
% 
%             % Loop over all cells
%             for cc = 1:length(all_event_traces{map,j,k})
% 
%                 % Check if cell has any event traces
%                 if isempty(all_event_traces{map,j,k}{cc})
%                     continue
%                 end
%                 
%                 % Add event traces within window together and adjust
%                 % counter
%                 pop_ave_event_trace = pop_ave_event_trace + ...
%                     sum(all_event_traces{map,j,k}{cc}(pawin(1):pawin(2),:), 2);
%                 counter = counter + size(all_event_traces{map,j,k}{cc},2);
%             end
%         end
% 
%         % Average
%         pop_ave_event_trace = pop_ave_event_trace / counter;
% 
%         % Plot
%         % WO
%         if k == 2
%             plot(smooth(pop_ave_event_trace),'Color',colors{j},'LineWidth',4)
% 
%         % W
%         else
%             shade_color = colors{j}; 
%             plot(smooth(pop_ave_event_trace),'Color',[shade_color, 0.5],...
%                 'LineStyle','-.','LineWidth', 3)
%         end
%     end
% end
% 
% ylim([-.05 0.5])
% % Finish plotting
% ylabel('ΔF/F0', 'FontSize', 12)
% %xline(stimOn-pawin(1), 'LineWidth', 1)
% xlim([0,pawin(2)-pawin(1)])
% xticks([.5 16 31.5 62.5 93.5 93.5+31])
% xticklabels([0 .5 1 2 3 4 5])
% yticks([0.05])
% xlabel('Seconds')
% % yticks([0.1])
% legend({'PV: W-CF', 'PN: W-CF', 'VIP: W-CF', 'PV: W', 'PN: W', 'VIP: W', ''})
% title('Evoked Population Average Event Traces')
% 
% %% Plot 2 sample neurons highly correlated with motion against avg motion trace
% % 
% 
% 
% %% Plot Population Average Event Trace for PV/PC/UC during M/NM for W PRE/POST
% % Remember to rerun section that retrieves all data to switch between M/NM
% 
% nMice = 11;
% pawin = [294, 294+31+31+31+31];
% stimOn = 310;
% colors = {[187, 37 37]/255; [34 75 170]/255; [0 0 0]}; % PV, PC
% 
% % Copied here for reference
% cellType = {'PV', 'PC', 'UC'};
% trialType = {'O', 'WO', 'W', 'W'};
% tetType = {'PRE', 'PRE', 'PRE', 'POST'};
% 
% figure()
% hold on
% 
% % Pulling data from all_event_traces
% % all_event_traces dimensions: nMice x nCellType x nTrialType
% 
% % Loop numbers correspond to trialType/tetType indices
% for k = 3:4
% %for k = 2:3
%     % Preallocate
%     pop_ave_event_trace = zeros(pawin(2)-pawin(1)+1,1);
% 
%     % Loop numbers correspond to cellType indices
%     for j = 1:3
% 
%         counter = 0; % counter for running average
%         for map = [2, 3, 4, 5, 10, 11]
%         %for map = [1, 6, 7, 8, 9]
%         %for i = 1:nMice
% 
%             % Loop over all cells
%             for cc = 1:length(all_event_traces{map,j,k})
% 
%                 % Check if cell has any event traces
%                 if isempty(all_event_traces{map,j,k}{cc})
%                     continue
%                 end
%                 
%                 % Add event traces within window together and adjust
%                 % counter
%                 pop_ave_event_trace = pop_ave_event_trace + ...
%                     sum(all_event_traces{map,j,k}{cc}(pawin(1):pawin(2),:), 2);
%                 counter = counter + size(all_event_traces{map,j,k}{cc},2);
%             end
%         end
% 
%         % Average
%         pop_ave_event_trace = pop_ave_event_trace / counter;
% 
%         % Plot
%         % W POST
%         if k == 4
%         %if k == 2
%             plot(smooth(pop_ave_event_trace),'Color',colors{j},'LineWidth',4)
% 
%         % W
%         else
%             %shade_color = colors{j}; 
%             %plot(smooth(pop_ave_event_trace),'Color',[shade_color, 0.3],...
%                 %'LineStyle','-.','LineWidth', 3)
%                 plot(smooth(pop_ave_event_trace),'Color',colors{j},...
%                 'LineStyle','--','LineWidth', 2)
%         end
%     end
% end
% 
% % Finish plotting
% ylabel('ΔF/F0', 'FontSize', 12)
% %xline(stimOn-pawin(1), 'LineWidth', 1)
% xlim([0,pawin(2)-pawin(1)])
% xticks([31.5])
% xticklabels([1])
% % yticks([0.1])
% legend({'PV: W (Pre)', 'PN: W (Pre)', 'UC: W (Pre)','PV: W (Post)', 'PN: W (Post)', 'UC: W (Post)'})
% title('Evoked Population Average Event Traces (Motion)')
% 
% %% Create Plots for Individual Traces
% % First four subplots plot individual traces and trial-averaged trace for each neuron for each
% % trial condition
% save_individual_traces = false;
% % Second four subplots plot motion histogram for each trial condition
% save_individual_traces = true;
% if save_individual_traces
%     
%     % (1) plot_motiontrials
%     % (2) plot_NOmotiontrials
%     % (3) plot_combinedtrials
%     plot_cond = 2;
%     
%     plot_win = [294, 372];
%     %plot_win = [1 620];
%     stim_loc = stimOn - plot_win(1);
%     
%     titles = {'Opto', 'Whisker + Opto', 'Whisker', 'Whisker Post Tet'};
%     trialType = {'O', 'WO', 'W', 'W'};
%     tetType = {'PRE', 'PRE', 'PRE', 'POST'};
%     motType = {'M', 'NM', 'all'};
%     cellType = {'PV', 'PC', 'UC'};
%     lc = {'#ea9595', '#7b9be5', '#949494'}; % [PV, PC, UC]
%     mulc = {'#bb2525', '#224baa', 'k'}; % [PV, PC, UC]
%     getPeaks = {'all'}; % option to get all, first, or max
%     
%     % Iterate through each mouse
%     for map = 1:size(allData.mouseIDs, 2) 
%         data = allData.data{map};              % 1 x num mice cell array each containing a 1 x 1 struct
%         traces = cell(length(trialType),1);
%         c_oasis = cell(length(trialType), 1);
%         spiketimes = cell(length(trialType), 1);
%         Ithr = cell(length(trialType),1);
%         Ithr_s = cell(length(trialType), 1);
%         muEVENTTraces = cell(length(trialType),1);
%         muTraces = cell(length(trialType), 1);
%         motion = cell(length(trialType),1);
%         nCells = length(data.cellType);
%         pkLocs = cell(length(trialType), 1);
%         amps = cell(length(trialType), 1);
%     
%         % [X, M] = getTraces(data, cellTypes, trialTypes, tetPeriods, motionCT)
%             % data:       1x1 struct with 10 fields
%             % cellTypes:  PV, PC, UC
%             % trialTypes: O, WO, W
%             % tetPeriods: PRE, TET, POST
%             % motionCT:   M, NM, all
%     
%             % X: nFrames x nCells x nTrials
%             % M: nFrames x nTrials
%     
%         % [BLShift, muBLShift, Ithr] = shiftBL(data,thr,Iso,Idt)
%             % data: nFrames x nCells x nTrials
%             % thr:  threshold value for baseline shift
%             % Iso:  stim onset frame #
%             % Idt:  pre- stim frame # to look back to calculate baseline
%         
%             % BLShift:   nFrames x nCells x nTrials; all traces now shifted
%             % muBLShift: nFrames x nCells;           average of only traces below thr
%             % Ithr:      nCells x nTrials logical;   indices of traces above thr
%     
%         % [pkLocs, amps] = calc_amps_pkLocs(pk_thrs, traces, win, getPeaks)
%             % pk_thrs:  vector or value for peak detection
%             % traces:   nFrames x nCells x nTrials
%             % win:      get peaks only in this window
%             % getPeaks: max, min, all
%         
%             % pkLocs:   nTrials x nCells cell array
%             % amps:     nTrials x nCells cell array
%     
%         % Calcium traces
%         % Iterate through trial conditions
%         for j = 1:length(trialType)
%             [~, traces{j}, c_oasis{j}, spiketimes{j}, ~, ~, ~, motion{j}] = ...
%                     getOasis(data, 'all', trialType{j}, tetType{j}, motType{plot_cond});
%     
%             [traces{j}, muTraces{j}, Ithr{j}] = shiftBL(traces{j},.5,stimOn,baseline);
% 
%            
% %             % if we don't want to shift baseline to pre-stim baseline
% %             [~, muTraces{j}, Ithr{j}] = shiftBL(traces{j},thr,stimOn,baseline);
%     
%             %[pkLocs{j}, amps{j}, Ithr_s{j}] = findEvokedEvents(traces{j}, c_oasis{j}, [310, 321], spiketimes{j}, 5);
%             [pkLocs{j}, amps{j}, Ithr_s{j}] = findEvokedEvents(traces{j}, c_oasis{j}, ev_start:ev_end, spiketimes{j}, tol_win, 'calcium');
%         end
% 
% 
% %         for j = 1:length(trialType)
% %             [~, traces{j}, c_oasis{j}, spiketimes{j}, ~, ~, ~, motion{j}] = ...
% %                      getOasis(data, 'all', trialType{j}, tetType{j}, motType{plot_cond});
% %             %[traces{j}, motion{j}] = getTraces(data,'all',trialType{j},tetType{j},motType{plot_cond});
% %             [traces{j}, muTraces{j}, Ithr{j}] = shiftBL(traces{j},thr,stimOn,baseline);
% %             [pkLocs{j}, amps{j}] = calc_amps_pkLocs(pk_thrs, traces{j}, [ev_start, ev_end], 'all');
% %         end
%     
%         for j = 1:nCells
%             figure('position', [61,558,1543,420]); %, 'Visible', 'off');
%     
%             % Plot traces color-coded based on cell type
%             for k = 1:length(trialType)
%                 subplot(2, length(trialType), k)
%                 hold on
%                 get_Ithr = Ithr{k}(j,:); %| Ithr_s{k}(j,:);
%                 if ~isempty(get_Ithr)
%                     get_y = squeeze(traces{k}(plot_win(1):plot_win(2),j, ~get_Ithr));
%     %                 get_y = squeeze(traces{k}(plot_win(1):plot_win(2),j,...
%     %                     ~Ithr{k}(j,:)));
%                     get_x = repmat(0:plot_win(2)-plot_win(1), size(get_y, 2), 1);
%                     plot(get_x', get_y, 'Color', lc{strcmp(cellType,data.cellType{j})});       % If below thr, plot in neuron's color
%                     
%                     get_y = squeeze(traces{k}(plot_win(1):plot_win(2),j, get_Ithr));
%     
%     %                 get_y = squeeze(traces{k}(plot_win(1):plot_win(2),j,...
%     %                     Ithr{k}(j,:)));
%                     get_x = repmat(0:plot_win(2)-plot_win(1), size(get_y, 2), 1);
%                     plot(get_x', get_y, 'Color', '#d3d3d3'); % If above thr, plot in grey
%                 end
%                
%                 if ~isempty(muTraces{k})
%                     get_y = muTraces{k}(plot_win(1):plot_win(2),j);
%                     get_x = repmat(0:plot_win(2)-plot_win(1), size(get_y, 2), 1);
%                     plot(get_x, get_y, 'Color', ...
%                         mulc{strcmp(cellType,data.cellType{j})}, 'LineWidth', 3);           % Average event trace
%                 end
%               
%                  temp_pkLoc = num2cell(pkLocs{k});
%                  temp_amp = num2cell(amps{k});
% 
%                 if ~isempty(get_Ithr)
%                     cellfun(@(x,y) scatter(x-plot_win(1),y, 9, 'filled','MarkerFaceColor',...   % Plots peaks
%                         mulc{strcmp(cellType,data.cellType{j})}),temp_pkLoc(j,~get_Ithr),...
%                         temp_amp(j,~get_Ithr));
%                     cellfun(@(x,y) scatter(x-plot_win(1),y, 9, 'filled','MarkerFaceColor',...   % If above thr, plot peaks in grey
%                         '#d3d3d3'),temp_pkLoc(j,get_Ithr), temp_amp(j,get_Ithr));
%                 end
% 
% %                 cellfun(@(x,y) scatter(x-plot_win(1),y, 9, 'filled','MarkerFaceColor',...   % Plots peaks
% %                     mulc{strcmp(cellType,data.cellType{j})}),temp_pkLoc(j,~Ithr{k}(j,:)),...
% %                     temp_amp(j,~Ithr{k}(j,:)));
% %                 cellfun(@(x,y) scatter(x-plot_win(1),y, 9, 'filled','MarkerFaceColor',...   % If above thr, plot peaks in grey
% %                     '#d3d3d3'),temp_pkLoc(j,Ithr{k}(j,:)), temp_amp(j,Ithr{k}(j,:)));
% 
% %                 cellfun(@(x,y) scatter(x-plot_win(1),y, 9, 'filled','MarkerFaceColor',...   % Plots peaks
% %                     mulc{strcmp(cellType,data.cellType{j})}),pkLocs{k}(j,~Ithr{k}(j,:)),...
% %                     amps{k}(j,~Ithr{k}(j,:)));
% %                 cellfun(@(x,y) scatter(x-plot_win(1),y, 9, 'filled','MarkerFaceColor',...   % If above thr, plot peaks in grey
% %                     '#d3d3d3'),pkLocs{k}(j,Ithr{k}(j,:)), amps{k}(j,Ithr{k}(j,:)));
%     
%                 %ylim(ylimit)
%                 xline(stim_loc, 'LineWidth', 2, 'Color', 'k');
%                 xlim([0 plot_win(2)-plot_win(1)])
%                 title(titles{k})
%                 xticks([294.5 310 325.5 341 356.5 372] - 294)
%                 xticklabels([-500 0 500 1000 1500 2000])
%                 xlabel('msec')
%                 ylabel('ΔF/F0')
%             end
%     
%             % Plot motion
%             for k = 1:length(trialType)
%                 subplot(2, length(trialType), k+length(trialType))
%                 hold on
%     %             x = 0:plot_win(2)-plot_win(1);
%     %             scatter(x,motion{k}(plot_win(1):plot_win(2),:),'filled',...
%     %                 'MarkerFaceColor','k','MarkerFaceAlpha',0.1)
%     %             ylim([0 2])
%     %             yticks([1])
%     %             yticklabels([])
%                 mu_motion = mean(motion{k}(plot_win(1):plot_win(2),:),2);
%                 sem_motion = std(motion{k}(plot_win(1):plot_win(2),:), 0, 2) / sqrt(size(motion{k}, 2));
%                 curve1 = smooth(mu_motion + sem_motion/2, 5, 'moving');
%                 curve2 = smooth(mu_motion - sem_motion/2, 5, 'moving');
%                 x = 1:numel(mu_motion);
%                 x2 = [x, fliplr(x)];
%                 inbetween = [curve1', fliplr(curve2')];
%                 fill(x2, inbetween, [.7 .7 .7])
%                 plot(smooth(mu_motion, 5, 'moving'), 'color', 'k', 'LineWidth', 2)
%                 ylim([0 1])
%                 xline(stim_loc, 'LineWidth', 2, 'Color', 'k');
%                 xlim([0 plot_win(2)-plot_win(1)])
%                 xticks([294.5 310 325.5 341 356.5 372] - 294)
%                 xticklabels([-500 0 500 1000 1500 2000])
%                 xlabel('msec')
%                 ylabel('P(Motion)')
%                 title(strcat(motType{plot_cond},' Trials = ',string(size(motion{k},2))))
%             end
%     
%             mid = split(allData.mouseIDs{map},"_");
%             fname = strcat(mid{2},"_N",string(j));
%             saveas(gcf,strcat(foldername,fname,".jpg"))
%             close all
%         end     
%     
%     end
% 
% end
% 
% %% Cross-correlograms
% 
% win = [310, 372];
% nMice = length(allData.mouseIDs);
% cellType = {'PV', 'PC', 'UC'};
% trialType = {'W', 'WO'};
% motType = {'M', 'NM'};
% tetType = {'PRE'};
% 
% nCT = length(cellType);
% nTT = length(trialType);
% nMT = length(motType);
% nTeT = length(tetType);
% 
% ntau = win(2)-win(1); % IFI ~= 31ms
% 
% % Number of comparisons between cell types
% npair = factorial(nCT);
% 
% % All cell type pairings. Used later for indexing
% % [PV/PV, PV/PC, PV/UC, PC/PC, PC/UC, UC/UC]
% pairs = cell(npair,1);
% c = 1; % counter
% for map = 1:nCT
%     for j = map:nCT
%         pairs{c} = strcat(cellType{map},'/',cellType{j});
%         c = c + 1;
%     end
% end
% 
% % Number of condition types
% ncond = nTT * nMT * nTeT;
% 
% % [W/M/PRE, W/NM/PRE, WO/M/PRE, WO/NM/PRE]
% conds = cell(ncond,1);
% c = 1; % counter
% for map = 1:nTT
%     for j = 1:nMT
%         for k = 1:nTeT
%             conds{c} = strcat(trialType{map},'/',motType{j},'/',tetType{k});
%             c = c + 1;
%         end
%     end
% end
% 
% r = zeros(2*ntau+1,npair,ncond); % rhos
% c = zeros(1,npair,ncond); % counter for running average
% 
% % Loop through conditions
% numcond = 1; % counter to know what condition we are on
% for map = 1:nTT % trial type
%     for j = 1:nMT % motion type
%         for k = 1:nTeT % tet type
% 
%             % Loop through mice
%             for l = 1:nMice
%                 data = allData.data{l}; % assigning for convenience
%                 
%                 % Get indices of all trials of specified condition
%                 I = strcmp(data.trialType,trialType{map}) & ...
%                     strcmp(data.motionCT,motType{j}) & ...
%                     strcmp(data.tetPeriod,tetType{k});
% 
%                 % Note that trials are always ordered PV->PC->UC
%                 traces = data.golayshift(win(1):win(2), :, I);
%                 [~, nCells, nTrials] = size(traces);
% 
%                 % Loop through all pairs of cells (second loop starts at m
%                 % to ignore double counting pairs)
%                 for m = 1:nCells
%                     for n = m:nCells
% 
%                         % No autocorrelations
%                         if m == n
%                             continue
%                         end
%                         
%                         % Get which cell type pairing (e.g., PV/PC) index
%                         I = strcmp(pairs, strcat(data.cellType{m},'/',data.cellType{n}));
%                         
%                         % Loop through all trials
%                         for t = 1:nTrials
%                             r(:,I,numcond) = r(:,I,numcond) + xcorr(traces(:,m,t), traces(:,n,t), ntau, 'coeff');
%                             c(1,I,numcond) = c(1,I,numcond) + 1;
%                         end
%                     end
%                 end
%             end
% 
%             numcond = numcond + 1;
%         end
%     end
% end
% 
% % Average
% for map = 1:(2*ntau+1)
%     r(map,:,:) = r(map,:,:) ./ c;
% end
% 
% % Plot
% ifi = 32.27;
% taus = ifi*(-ntau:ntau);
% for map = 1:ncond
%     c = 1; % counter
% 
%     figure
%     for j = 1:npair
%         subplot(2,3,c)
%         
%         plot(taus,r(:,j,map))
%         xlabel("\tau (ms)")
%         ylabel("\rho")
%         ylim([0,1])
%         title(pairs{c})
%         c = c + 1;
%     end
%     sgtitle(conds{map})
% end
% 
% %% Cross-correlation heatmamp
% 
% win = [300, 372];
% win = [300, 310+31+31];
% tau = 0;
% cellType = {'PV', 'PC', 'UC'};
% trialType = {'W'};
% motType = {'M', 'NM'};
% tetType = {'PRE','POST'};
% 
% % win = [300, 372];
% % win = [300, 310+31+31];
% % tau = 0;
% % cellType = {'PV', 'PC', 'UC'};
% % trialType = {'W', 'WO'};
% % motType = {'M', 'NM'};
% % tetType = {'PRE'};
% 
% nCT = length(cellType);
% nTT = length(trialType);
% nMT = length(motType);
% nTeT = length(tetType);
% 
% % Number of condition types
% ncond = nTT * nMT * nTeT;
% 
% % [W/M/PRE, W/NM/PRE, WO/M/PRE, WO/NM/PRE]
% conds = cell(ncond,1);
% c = 1; % counter
% for map = 1:nTT
%     for j = 1:nMT
%         for k = 1:nTeT
%             conds{c} = strcat(trialType{map},'/',motType{j},'/',tetType{k});
%             c = c + 1;
%         end
%     end
% end
% 
% nMice = length(allData.mouseIDs);
% r = cell(ncond,nMice);
% 
% % Loop through mice
% for map = 1:nMice
% 
%     % Loop through conditions
%     numcond = 1; % counter to know what condition we are on
%     for j = 1:nTT % trial type
%         for k = 1:nMT % motion type
%             for l = 1:nTeT % tet type
%                 data = allData.data{map}; % assigning for convenience
%                 
%                 % Get indices of all trials of specified condition
%                 I = strcmp(data.trialType,trialType{j}) & ...
%                     strcmp(data.motionCT,motType{k}) & ...
%                     strcmp(data.tetPeriod,tetType{l});
% 
%                 % Note that trials are always ordered PV->PC->UC
%                 traces = data.golaysignal(win(1):win(2), :, I);
%                 [~, nCells, nTrials] = size(traces);
% 
%                 % Remove undesired cell types
%                 I = false(nCells,1);
%                 for m = 1:nCT
%                     I = I | strcmp(data.cellType,cellType{m});
%                 end
%                 traces = traces(:,I,:);
%                 nCells = size(traces,2);
% 
%                 % preallocate
%                 temp = zeros(nCells);
% 
%                 % Iterate through all pairs of cells
%                 for cc = 1:nCells
%                     for dd = 1:nCells
%                         for tt = 1:nTrials
%                             temp(cc,dd) = temp(cc,dd) + ...
%                                     xcorr(traces(:,cc,tt),traces(:,dd,tt),tau,'coeff');
%                         end
%                     end
%                 end
% 
%                 r{numcond,map} = temp ./ nTrials; % average
%                 numcond = numcond + 1;
%             end
%         end
%     end
% end
% 
% %% Plot 2 sample neurons against motion trace
% 
% 
% nFrames = 620;
% 
% mouse_to_plot = 3;
% nMotion = 1;
% Motion_win = [310, 340];
% 
% [allData] = getmotionconfound(allData, Motion_win, nMotion);
% 
% 
% 
% mouse_sig = allData.data{mouse_to_plot}.golayshift;
% 
% motion_sig = allData.data{mouse_to_plot}.motionInfo;
% 
% whiskerM_trials = strcmp(allData.data{mouse_to_plot}.trialType, 'W') & strcmp(allData.data{mouse_to_plot}.tetPeriod, 'PRE'); %& strcmp(allData.data{mouse_to_plot}.motionCT, 'all');
% whiskeroptoM_trials = strcmp(allData.data{mouse_to_plot}.trialType, 'WO') & strcmp(allData.data{mouse_to_plot}.tetPeriod, 'PRE'); %& strcmp(allData.data{mouse_to_plot}.motionCT, 'all');
% 
% 
% cell_to_plot = 13; % try 13, also 19 for uncor
% cell_to_plot_2 = 11; % try 27, 66 is UC uncor
% 
% allData.data{mouse_to_plot}.cellxmot(cell_to_plot)
% allData.data{mouse_to_plot}.cellxmot(cell_to_plot_2)
% 
% trials_to_plot = whiskerM_trials; %or change to whiskeroptoM_trials
% 
% Catrace_1 = squeeze(mouse_sig(:, cell_to_plot, trials_to_plot));
% Catrace_2 = squeeze(mouse_sig(:, cell_to_plot_2, trials_to_plot));
% MotionTrace = motion_sig(:, trials_to_plot);
% 
% meanCaTrace_1 = mean(Catrace_1, 2);
% meanCaTrace_2 = mean(Catrace_2, 2);
% meanMotionTrace = mean(MotionTrace, 2);
% 
% semCaTrace_1 = std(Catrace_1, 0, 2)/sqrt(sum(whiskerM_trials));
% semCaTrace_2 = std(Catrace_2, 0, 2)/sqrt(sum(whiskerM_trials));
% semMotionTrace = std(MotionTrace, 0, 2)/sqrt(sum(whiskerM_trials));
% 
% 
% % meanMotionTrace = smooth(meanMotionTrace, 3);
% % semMotionTrace = smooth(semMotionTrace, 3);
% % avgCaTrace_1 = smooth(avgCaTrace_1, 30);
% % avgCaTrace_2 = smooth(avgCaTrace_2, 30);
% % semCaTrace_1 = smooth(semCaTrace_1, 30);
% % semCaTrace_2 = smooth(semCaTrace_2, 30);
% 
% figure('position', [100 100 1400 400]);
% subplot(2, 2, 1);
% plot(meanCaTrace_1, 'Color', [187/255, 37/255, 37/255], 'LineWidth', 2);
% hold on
% fill([1:nFrames, fliplr(1:nFrames)], [meanCaTrace_1' + semCaTrace_1', fliplr(meanCaTrace_1' - semCaTrace_1')], [187/255, 37/255, 37/255], 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% plot(meanCaTrace_2, 'Color', [34/255, 75/255, 255/255], 'LineWidth', 2);
% hold on
% fill([1:nFrames, fliplr(1:nFrames)], [meanCaTrace_2' + semCaTrace_2', fliplr(meanCaTrace_2' - semCaTrace_2')], [34/255, 75/255, 255/255], 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% 
% ylabel('dF/F', 'FontSize', 14, 'FontWeight', 'bold');
% set(gca, 'FontSize', 14);
% ylim([-0.1 1])
% xlim([294 372])
% xline(310)
% %xticks([0 154.9, 309.8, 464.7, 619.6])
% %xticklabels([])
% yticks([0.5 1 1.5])
% 
% 
% subplot(2, 2, 3);
% plot(meanMotionTrace, 'Color', [0 0 0], 'LineWidth', 2);
% hold on;
% fill([1:nFrames, fliplr(1:nFrames)], [meanMotionTrace' + semMotionTrace', fliplr(meanMotionTrace' - semMotionTrace')], [0 0 0], 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% xlabel('Frames', 'FontSize', 14);
% ylabel('PdMotion)', 'FontSize', 14);
% set(gca, 'FontSize', 14);
% ylabel('PdMotion)', 'FontSize', 14, 'FontWeight', 'bold')
% xlim([294 372])
% ylim([0 0.5])
% xline(310)
% %xticks([0 154.9, 309.8, 464.7, 619.6])
% %xticklabels([])
% xticklabels([5 10 15 20])
% xlabel('Seconds', 'FontSize', 14, 'FontWeight', 'bold');
% yticks([0 0.5 1 1.5])
% 
% trials_to_plot = whiskeroptoM_trials; %or change to whiskeroptoM_trials
% 
% Catrace_1 = squeeze(mouse_sig(:, cell_to_plot, trials_to_plot));
% Catrace_2 = squeeze(mouse_sig(:, cell_to_plot_2, trials_to_plot));
% MotionTrace = motion_sig(:, trials_to_plot);
% 
% meanCaTrace_1 = mean(Catrace_1, 2);
% meanCaTrace_2 = mean(Catrace_2, 2);
% meanMotionTrace = mean(MotionTrace, 2);
% 
% semCaTrace_1 = std(Catrace_1, 0, 2)/sqrt(sum(whiskerM_trials));
% semCaTrace_2 = std(Catrace_2, 0, 2)/sqrt(sum(whiskerM_trials));
% semMotionTrace = std(MotionTrace, 0, 2)/sqrt(sum(whiskeroptoM_trials));
% 
% % meanMotionTrace = smooth(meanMotionTrace, 5);
% % semMotionTrace = smooth(semMotionTrace, 5);
% 
% subplot(2, 2, 2)
% plot(meanCaTrace_1, 'Color', [187/255, 37/255, 37/255], 'LineWidth', 2);
% hold on
% fill([1:nFrames, fliplr(1:nFrames)], [meanCaTrace_1' + semCaTrace_1', fliplr(meanCaTrace_1' - semCaTrace_1')], [187/255, 37/255, 37/255], 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% plot(meanCaTrace_2, 'Color', [34/255, 75/255, 255/255], 'LineWidth', 2);
% 
% hold on
% fill([1:nFrames, fliplr(1:nFrames)], [meanCaTrace_2' + semCaTrace_2', fliplr(meanCaTrace_2' - semCaTrace_2')], [34/255, 75/255, 255/255], 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% 
% ylabel('dF/F', 'FontSize', 14, 'FontWeight', 'bold');
% set(gca, 'FontSize', 14);
% xlim([294 372])
% ylim([-0.1 1])
% xline(310)
% %xticks([0 154.9, 309.8, 464.7, 619.6])
% %xticklabels([])
% yticks([0.5 1 1.5])
% 
% subplot(2, 2, 4)
% plot(meanMotionTrace, 'Color', [0 0 0], 'LineWidth', 2);
% hold on;
% fill([1:nFrames, fliplr(1:nFrames)], [meanMotionTrace' + semMotionTrace', fliplr(meanMotionTrace' - semMotionTrace')], [0 0 0], 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% xlabel('Frames', 'FontSize', 14);
% ylabel('PdMotion)', 'FontSize', 14);
% set(gca, 'FontSize', 14);
% ylabel('PdMotion)', 'FontSize', 14, 'FontWeight', 'bold')
% xlim([294 372])
% ylim([0 0.5])
% xline(310)
% %xticks([0 154.9, 309.8, 464.7, 619.6])
% %xticklabels([])
% xticklabels([5 10 15 20])
% xlabel('Seconds', 'FontSize', 14, 'FontWeight', 'bold');
% yticks([0 0.5 1 1.5])
% 
% 
% hold off
% %% Plot
% 
% plot_PV_only = false;
% plot_PC_only = false;
% plot_UC_only = false; 
% 
% clim = [0 1];
% for map = 1:nMice
% 
%     % Get number of PV cells for x/y ticks
%     nPV = sum(strcmp(allData.data{map}.cellType,'PV'));
%     nPC = sum(strcmp(allData.data{map}.cellType,'PC'));
%     nUC = sum(strcmp(allData.data{map}.cellType,'UC'));
% 
% 
%     muxcorr = mean(r{3,map},2);
%     [~,Ipv] = sort(muxcorr(1:nPV),'descend');
%     [~,Ipc] = sort(muxcorr(nPV+1:nPV+nPC),'descend');
%     [~,Iuc] = sort(muxcorr(nPV+nPC+1:end),'descend');
%     %I = vertcat(Ipv,Ipc+nPV); %,Iuc+nPV+nPC);
%     
%     if plot_PV_only
%         I = Ipv;
%     elseif plot_PC_only
%         I = Ipc;
%     elseif plot_UC_only
%         I = Iuc;
%     else
%         I = vertcat(Ipv,Ipc+nPV); %,Iuc+nPV+nPC);
%     end
% 
%     figure('position', [210,279,781,619])
%     for j = 1:ncond
%         subplot(2,2,j)
% %         hold on
%         imagesc(r{j,map}(I,I),clim)
% 
%         % Get average cross correlation
%         muxcorr = 0;
%         
%         if plot_PV_only || plot_PC_only || plot_UC_only
%             N = size(r{j,map}(I,I),1);
%         else
%             N = size(r{j,map},1);
%         end
%         
%         for k = 1:N
%             for l = k:N
%                 if k == l
%                     continue
%                 end
% 
% 
%                 if plot_PV_only || plot_PC_only || plot_UC_only
%                     muxcorr = muxcorr + r{j,map}(I(k),I(l));
%                 else
%                     muxcorr = muxcorr + r{j,map}(k,l);
%                 end
%             end
%         end
%         muxcorr = muxcorr / (N*(N+1)/2);
% 
%         title(strcat(conds{j}, ' - Ave XCORR: ', string(muxcorr)))
%         xticks([1,nPV+2])
%         xticklabels(cellType)
%         yticks([1,nPV+2])
%         yticklabels(cellType)
%         xline(nPV+1,'--')
%         colorbar
% 
% % Define the transition points
% transition_points = [0, 1/3, 2/3, 5/6, 1];
% 
% % Define the colors at each transition point
% colors = [0.5, 0, 0; % Dark red
%           1, 0, 0; % Red
%           1, 1, 1; % White
%           0, .9, .9; % Cyan
%           0, 0, 0.4]; % Blue
% 
% % Generate a vector for the color map indexes
% idx = linspace(0, 1, 256);
% 
% % Use interp1 to generate the color map
% my_colormap = interp1(transition_points, colors, idx', 'linear');
% 
% % Create a new figure and set its colormap
% 
% colormap(my_colormap);
% colorbar; % Display a colorbar for reference
% 
% 
% 
% 
% 
% 
% 
% 
%         %colormap jet
%     end
% 
%     sgtitle(strcat("Mouse ",string(map)));
% end
% 
% %%
% % Initialize arrays to hold xcorr for each condition
% xcorr_WM = zeros(nMice, 1);
% xcorr_WNM = zeros(nMice, 1);
% xcorr_WMPOST = zeros(nMice, 1);
% xcorr_WNMPOST = zeros(nMice, 1);
% 
% % Loop over each mouse
% for map = 1:nMice
%     % Calculate average xcorr for each condition
%     for j = 1:ncond
%         muxcorr = 0;
%         if plot_PV_only || plot_PC_only
%             N = size(r{j,map}(I,I),1);
%         else
%             N = size(r{j,map},1);
%         end
%         for k = 1:N
%             for l = k:N
%                 if k == l
%                     continue
%                 end
%                  if plot_PV_only || plot_PC_only
%                     muxcorr = muxcorr + r{j,map}(I(k),I(l));
%                 else
%                     muxcorr = muxcorr + r{j,map}(k,l);
%                 end
%             end
%         end
%         muxcorr = muxcorr / (N*(N+1)/2);
%         
%         % Store xcorr in respective arrays
%         if strcmp(conds{j}, 'W/M/PRE')
%             xcorr_WM(map) = muxcorr;
%         elseif strcmp(conds{j}, 'W/NM/PRE')
%             xcorr_WNM(map) = muxcorr;
%         elseif strcmp(conds{j}, 'W/M/POST')
%             xcorr_WMPOST(map) = muxcorr;
%         elseif strcmp(conds{j}, 'W/NM/POST')
%             xcorr_WNMPOST(map) = muxcorr;
%         end
%     end
% end
% 
% % Create the summary plot
% figure('position', [210,279,781,619])
% hold on
% 
% % Plot points for each condition for each mouse, with lines connecting the points
% for map = [2, 3, 4, 5, 10, 11]
%     plot([1.2, 2.2], [xcorr_WNM(map), xcorr_WNMPOST(map)], '-o', 'Color', 'r', 'LineWidth', 2, 'MarkerSize', 10, 'MarkerFaceColor', 'r')
%     plot([3.2, 4.2], [xcorr_WM(map), xcorr_WMPOST(map)], '-o', 'Color', 'r', 'LineWidth', 2, 'MarkerSize', 10, 'MarkerFaceColor', 'r')
% end
% 
% % Set x-axis labels and title
% xticks([1.2,2.2,3.2,4.2])
% xticklabels({'W/NM/PRE', 'W/NM/POST', 'W/M/PRE', 'W/M/POST'})
% title('Summary Plot: W Tet')
% 
% % Create the summary plot
% figure('position', [210,279,781,619])
% hold on
% 
% % Plot points for each condition for each mouse, with lines connecting the points
% for map = [1, 6, 7, 8, 9]
%     line([1.2, 2.2], [xcorr_WNM(map), xcorr_WNMPOST(map)], 'Color', 'k', 'LineWidth', 2)
%     scatter([1.2, 2.2], [xcorr_WNM(map), xcorr_WNMPOST(map)], 150, 'o', 'filled', 'MarkerFaceAlpha', 1, 'MarkerEdgeColor', 'k', 'MarkerEdgeAlpha', 1, 'LineWidth', 2, 'MarkerFaceColor', [.5 .5 .5])
%     
%     scatter([3.2, 4.2], [xcorr_WM(map), xcorr_WMPOST(map)], 150, 'o', 'filled', 'MarkerFaceAlpha', 0.5)
%     line([3.2, 4.2], [xcorr_WM(map), xcorr_WMPOST(map)], 'Color', 'k', 'LineWidth', 2)
% end
% 
% % Set x-axis labels and title
% xticks([1.2,2.2,3.2,4.2])
% xticklabels({'PRE', 'POST RWS-CF', 'W/M/PRE', 'W/M/POST'})
% title('Summary Plot: W Tet')
% ylabel('Avg. XCorr')
% 
% % Set y limits to go from 0 to 1
% ylim([0.6 1.0])
% yticks([0.6 0.7 0.8 0.9 1])
% 
% % Add bracket and asterisk for the first two categories
% y_lim=get(gca,'ylim'); %get the current y-axis limits
% y=y_lim(2)-0.1*(y_lim(2)-y_lim(1)); %calculate y position of the bracket based on the current y limits
% line([1.2 1.2 2.2 2.2], [y y+0.05*(y_lim(2)-y_lim(1)) y+0.05*(y_lim(2)-y_lim(1)) y], 'Color', 'k', 'LineWidth', 1); %draw the bracket
% text(1.7, y+0.02*(y_lim(2)-y_lim(1)), '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 30); %add the asterisk
% hold off
% 
% 
% 
% %%
% % Group 1: Mouse 1, 6, 7, 8, 9
% % Group 2: Mouse 2, 3, 4, 5, 10, 11
% groups = {[1, 6, 7, 8, 9], [2, 3, 4, 5, 10, 11]};
% 
% for group = 1:2
%     % Select mice for this group
%     mice = groups{group};
% 
%     % Select xcorr values for this group
%     group_xcorr = all_xcorr(mice, :);
% 
%     % Create a condition list for this group
%     group_conds = repmat({'W/NM/PRE', 'W/NM/POST', 'W/M/PRE', 'W/M/POST'}, numel(mice), 1);
% 
%     % Create the box plots
%     figure('position', [210,279,781,619])
%     boxplot(group_xcorr(:), group_conds(:));
%     title(['Box Plots of xcorr for Different Conditions (Group ', num2str(group), ')'])
% 
%     % Perform one-way ANOVA
%     [p, ~, stats] = anova1(group_xcorr(:), group_conds(:), 'off');
% 
%     % If p < 0.05, there is a significant difference between groups
%     if p < 0.05
%         % Perform multiple comparisons test
%         c = multcompare(stats, 'CType', 'tukey-kramer', 'Display', 'off');
%         
%         % Loop over all comparisons that are significant
%         for i = 1:size(c, 1)
%             if c(i, end) < 0.05
%                 % Get the groups being compared
%                 group1 = c(i, 1);
%                 group2 = c(i, 2);
%                 
%                 % Get the maximum value in these two groups to position the brackets
%                 y = max(max(group_xcorr(:, [group1, group2]))) + 0.05;
%                 
%                 % Draw the brackets
%                 line([group1, group1, group2, group2], [y, y+0.01, y+0.01, y], 'Color', 'k');
%                 
%                 % Display the asterisks
%                 if c(i, end) < 0.001
%                     text((group1+group2)/2, y+0.02, '***', 'HorizontalAlignment', 'center');
%                 elseif c(i, end) < 0.01
%                     text((group1+group2)/2, y+0.02, '**', 'HorizontalAlignment', 'center');
%                 else
%                     text((group1+group2)/2, y+0.02, '*', 'HorizontalAlignment', 'center');
%                 end
%             end
%         end
%     end
% end
% hold off
% 
% 
% 
% 
% %% Statistical test
% % Loop over the mice
% for map = 1:nMice
% 
%     % Collect the data for the current mouse
%     mouse_data = [xcorr_WNM(map), xcorr_WNMPOST(map), xcorr_WM(map), xcorr_WMPOST(map)];
%     
%     % Perform ANOVA
%     [p, tbl, stats] = anova1(mouse_data);  % 'off' suppresses the automatic display of ANOVA table
% 
%     % If ANOVA is significant, perform post-hoc Tukey's HSD
%     if p < 0.5
%         c = multcompare(stats, 'CType', 'tukey-kramer', 'Display', 'off');  % 'off' suppresses the automatic display of comparison results
% 
%         % Loop over all comparisons that are significant
%         for i = 1:size(c, 1)
%             if c(i, end) < 0.05
%                 % Get the conditions being compared
%                 cond1 = conds{c(i, 1)};
%                 cond2 = conds{c(i, 2)};
%                 
%                 % Get the p-value of the comparison
%                 pval = c(i, end);
%                 
%                 % Print the result
%                 fprintf("'%s' is significantly different from '%s' for mouse %d with p = %f\n", cond1, cond2, map, pval);
%             end
%         end
%     end
% end
% 
% 
% 
% %% Plot diff (W/WO or W pre/W post) against rho (correlation w motion)
% % Scatter plots, each point is a cell, subplot for each cell type
% % x axis is the correlation with motion (ρ)
% % y axis is the absolute difference in between the two conditions
%     % for example, avg WO amp pre - avg W amp post
% % Each cell correlation with motion is stored in 'cellxmot' in 'allData'
% 
% % Copied here for reference (DIMENSIONS OF 'all_amps')
% % cellType = {'PV', 'PC', 'UC'};
% % trialType = {'O', 'WO', 'W', 'W'};
% % tetType = {'PRE', 'PRE', 'PRE', 'POST'};
% %
% % Easiest way is to hard-code which indices of the third dimension of
% % 'all_amps' we want, depending on the trialType. For instance, if we want
% % WO/PRE and W/PRE, we will hard-code indexing into the 2nd and 3rd indices
% % of the third dimension of 'all_amps'
% %
% % First condition: WO/PRE -- I=2
% % Second condition: W/PRE -- I=3
% 
% % Set variables for convenience
% colors = {'#bb2525', '#224baa', 'k'}; % PV, PC, UC
% cellType = {'PV', 'PC', 'UC'};
% nCT = length(cellType);
% nMice = length(allData.mouseIDs);
% 
% figure
% % Iterate through all mice
% for map = 1:nMice
%     data = allData.data{map}; % set for convenience
%     
%     % Iterate through cell types
%     for j = 1:nCT
%         
%         % Indices of cell type
%         I = strcmp(data.cellType, cellType{j});
% 
%         % Grab the correlation between each cell and motion
%         x = data.cellxmot(I);
% 
%         % Grab amps for conditions (this returns a cell array)
%         y1 = all_amps{map,j,2};
%         y2 = all_amps{map,j,3};
% 
%         % If data doesn't exist for one of these, continue
%         if isempty(y1) || isempty(y2)
%             continue
%         end
% 
%         % Get the average amplitude. NOTE: trials without an event are
%         % stored as NaNs -- ignore these. These two lines return a NaN if
%         % no trials contained an event.
%         y1 = cellfun(@(x) mean(x(~isnan(x))), y1);
%         y2 = cellfun(@(x) mean(x(~isnan(x))), y2);
% 
%         %Set NaNs to zero
%         y1(isnan(y1)) = 0;
%         y2(isnan(y2)) = 0;
% 
%         % Absolute difference between conditions. NOTE: a scalar minus a
%         % NaN returns a NaN.
%         y = (y1 - y2);
% 
%         % Plot
%         subplot(1,3,j)
%         hold on
% 
%         scatter(x,abs(y),'filled','MarkerEdgeColor','none', 'MarkerFaceColor', colors{j}, 'MarkerFaceAlpha', 0.3)
%         xticks([-0.09 0 0.09])
%         yticks([0.1 .2 .3 .4 .5])
%         hold on
%         xlabel('ρ', 'FontWeight', 'bold', 'FontSize', 12)
%         xlim([-.33 .33])
%         ylim([0 .5])
%         ylabel('Δ Amplitude', 'FontWeight', 'bold', 'FontSize', 12)
%         title(cellType{j})
%     end
% end
% 
% %% Diff for just PVs
% % Set variables for convenience
% colors = {'#bb2525', '#224baa', 'k'}; % PV, PC, UC
% cellType = {'PV'}; %{'PV', 'PC', 'UC'};
% nCT = length(cellType);
% nMice = length(allData.mouseIDs);
% 
% % Initialize arrays to collect all data
% allX = [];
% allY = [];
% 
% % Create a new figure
% figure
% 
% % Iterate through all mice
% for map = 1:nMice
%     data = allData.data{map}; % set for convenience
%     
%     % Iterate through cell types
%     for j = 1:nCT
%         
%         % Indices of cell type
%         I = strcmp(data.cellType, cellType{j});
% 
%         % Grab the correlation between each cell and motion
%         x = data.cellxmot(I);
% 
%         % Grab amps for conditions (this returns a cell array)
%         y1 = all_amps{map,j,2};
%         y2 = all_amps{map,j,3};
% 
%         % If data doesn't exist for one of these, continue
%         if isempty(y1) || isempty(y2)
%             continue
%         end
% 
%         % Get the average amplitude. NOTE: trials without an event are
%         % stored as NaNs -- ignore these. These two lines return a NaN if
%         % no trials contained an event.
%         y1 = cellfun(@(x) mean(x(~isnan(x))), y1);
%         y2 = cellfun(@(x) mean(x(~isnan(x))), y2);
% 
%         % Set NaNs to zero
%         y1(isnan(y1)) = 0;
%         y2(isnan(y2)) = 0;
% 
%         % Absolute difference between conditions. NOTE: a scalar minus a
%         % NaN returns a NaN.
%         y = abs(y1 - y2);
% 
%         % Ensure x and y are column vectors before collecting
%         if size(x,1) == 1
%             x = x';
%         end
%         if size(y,1) == 1
%             y = y';
%         end
% 
%         % Check if both x and y are zero, and ignore these cases
%         notZeros = ~(y == 0);
% 
%         % Collect x and y data
%         allX = [allX; x(notZeros)];
%         allY = [allY; y(notZeros)];
%         
%         % Create subplot for current cell type
%         subplot(1, nCT, j)
%         hold on
%         scatter(x(notZeros), y(notZeros), 70, 'filled', 'MarkerEdgeColor', 'none', 'MarkerFaceColor', colors{j}, 'MarkerFaceAlpha', 0.3)
%     end
% end
% 
% % Fit the linear model to all data
% mdl = fitlm(allX, allY);
% 
% % Create array for x values for regression line
% xVals = linspace(min(allX), max(allX), 100);
% 
% % Calculate y values for regression line
% yVals = mdl.Coefficients.Estimate(1) + mdl.Coefficients.Estimate(2)*xVals;
% 
% % Plot the regression line on each subplot
% for j = 1:nCT
%     subplot(1, nCT, j)
%     plot(xVals, yVals, 'k', 'LineWidth', 2, 'Color', colors{j}); % k for black color
%     xlabel('ρ', 'FontWeight', 'bold', 'FontSize', 12)
%     ylabel('Δ Amplitude', 'FontWeight', 'bold', 'FontSize', 12)
%     title(cellType{j})
%     xticks([-0.09 0 0.09])
%     xlim([-0.33 0.33])
%     ylim([0 0.63])
% end
% 
% %%
% % Custom rgb2hex function
% function hex = rgb2hex_custom(rgb)
%     assert(all(rgb >= 0 & rgb <= 1), 'RGB values should be in the range [0, 1]');
%     hex = cellstr(dec2hex(floor(rgb*255),2)');
%     hex = ['#', [hex{:}]];
% end