% run from within climbingfiber folder
%clear all
        addpath('20230516_analysis');
        %% Compile S1 two photon data
        allData = compileDataset;
        %% set neuron colors and mice
        neuron_colors = {[188,5,66]/255, [22,109,42]/255, [44,55,113]/255,  [0, 0, 0]/255, [92,2,86]/255};
        neuron_names = {'PV', 'PN', 'VIP', 'UC', 'SST'};
        load('setmice.mat')
        %% manually inspect stimulus artifact frame
        % removeartifact
        %% ignore plasticity induction trials
        allData = removetettrials(allData);
        %% interpolate optical stimulus artifact
        allData = interpartifact(allData, NaN);
        allData = interpbaselineartifact(allData, 'noplot'); 
        % visualizeartifactremoval(allData)
        %% perform background subtraction
        allData = backgroundsubtract(allData, 'noplot');
        % visualizerawdata(allData)
        % visualizerawdata_eachcell(allData, 49, 'rawminusfirstprctile')
        %% smooth traces and express as ΔF/F0
        F0_percent = 1;
        smooth_win = 15;
        allData = getGOLAY(allData, F0_percent, 10, smooth_win, 'rawminusfirstprctile');
        %% set motion detection parameters (M, NM, T, H trials; binary rest/running trials)
        rest_period = 12;
        NM_thresh = [0, 0];
        T_thresh = [0, 1]; 
        M_thresh = [1, 1];
        H_thresh = [1, 0];
        prestim_win = [290 305];
        poststim_win = [305 336];
        allData = getrest(allData, rest_period);
        allData = gettransition(allData, prestim_win, poststim_win, NM_thresh, T_thresh, M_thresh, H_thresh, 'noplot');
        %% set pre-stimulus normalization period and threshold
        baselinenormperiod = [300, 305];
        baselinenorm = 1;
        baseline_reject_thresh = [NaN, 5];
        %% calculate baseline noise (σ) and SNR
        noise_prc = 1;
        sig_prc = 95;
        [baselineNoise, SNR] = getbaselinenoise_fast(allData, noise_prc, sig_prc, 'golaysignal', 10);
%% PLOT σ and SNR
        load('expression_type.mat')
        visualizeSNR(allData, SNR, baselineNoise, 20, 40, neuron_colors);
        visualizeSNR_split(allData, SNR, baselineNoise, 20, 40, neuron_colors, expression_type);
        %% perform oasis deconvolution (find spikes)
        sn_thresh_3 = 3;
        allData = runoasis(allData, baselineNoise, false, sn_thresh_3, 'golaysignal');
        %% correlate cell with motion
        [allData] = getcellxmotion(allData, 'motion', 'golaysignal');
        [allData] = cellxmotion_prepost(allData, 'excludedcz');
        [allData] = getmotcells(allData, 0.1, 'correlation');
%% PLOT neural correlation with motion behavior
        [~] = visualizemotioncorrelation(allData, 0.1, 40, 'PRE', neuron_colors);
        %% find peaks
        peaks_thr = 3; 
        [allData] = get_peaks(allData, peaks_thr, NaN, baselineNoise, 310, 'golaysignal', 'noplot');
%% PLOT evoked event window
        std_thresh = 3;
        [peak_win, spike_win] = visualizealleventsbymouse(allData, std_thresh, '');
        %% grab evoked events (based on spike or peak window)
        [allData] = getwindowevents(allData, spike_win, peak_win);
        [allData] = getevokedtraces_byspike(allData, spike_win);
        %[allData] = getevokedtraces_bypeak(allData, peak_win); 
        %% analyze spontaneous rest/run conditions (spike rate and mean dF/F0)
        [allData] = getspontinfo(allData, spike_win);
         %% calculate ROI size
         [allData, roi_sizes] = calculateROIsize(allData);
        %% set window for AUC, maximum calculations
        stim_onset = 301;
        auc_max_win = [306, 328];
        trace_window = [280, 367];
        %% set time window for analysis
        [allData] = settimewindow(allData, -50, 60, -50, 50);

        %% preprocess cerebellum two photon data %%
        cbdata = processcb;