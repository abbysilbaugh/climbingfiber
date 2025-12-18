            load('climbingfiber_workspace.mat')
%% FIGURE 1; FIGURE 1 - FIGURE SUPPLEMENT 1; FIGURE 1 - FIGURE SUPPLEMENT 2   
    %% Purkinje cell responses to CF stimulation
            plotcbdata(cbdata, auc_max_win)
    
    %% Maximum and area under the curve (by neuron) pre- and post- plasticity
            % Persistent cells
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces_settime';
            [~, ~, RWS_pre, ~, RWS_post, RWSCF_pre, ~, RWSCF_post, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
            [RWS_pre, RWS_post, RWSCF_pre, RWSCF_post] = visualizeandtraces(neuron_colors, trace_window, [-0.1, 0.4], stim_onset, ...
            RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, 'yesplot');
            plotauc_byneuron_box(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, neuron_colors, 0, auc_max_win, {'RWS', 'RWSCF'}, {'Pre', 'Post'}, [-2, 12])
    %%
            % Persistent, recruited, and suppressed cells
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces_settime';
            [~, ~, ...
            RWS_pre, ~, RWS_post, RWSCF_pre, ~, RWSCF_post, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
            [RWS_pre, RWS_post, RWSCF_pre, RWSCF_post] = visualizeortraces(neuron_colors, trace_window, [-0.1, 0.4], stim_onset, ...
            RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, 'yesplot');
            plotauc_byneuron_unpaired(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, neuron_colors, 0, auc_max_win, {'RWS', 'RWSCF'}, {'Pre', 'Post'}, [0, 6])
            plotpie(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, neuron_colors)
    %%
            % All cells and traces
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'golaysignal_settime';
            [~, ~, ...
            RWS_pre, ~, RWS_post, RWSCF_pre, ~, RWSCF_post, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
            [RWS_pre, RWS_post, RWSCF_pre, RWSCF_post] = visualizeortraces(neuron_colors, trace_window, [-0.1, 0.2], stim_onset, ...
            RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, 'yesplot');
            plotauc_byneuron_box(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, neuron_colors, 0, auc_max_win, {'RWS', 'RWSCF'}, {'Pre', 'Post'}, [-2.5, 4.5])
    %% Area under the curve across time 
            % Persistent cells
            mottype = 'all';
            tracetype = 'evokedtraces_settime'; % evokedtraces, evokedtraces2
            [~, ~, ...
            RWS_pre, ~, RWS_post, RWSCF_pre, ~, RWSCF_post, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, false,...
            false, false, mottype, allData, tracetype, setmice);
            figure('Position', [350,429,314,183])
            [binned_RWS, binned_RWSCF] = parsetime(mottype, allData, setmice.RWS_mice, setmice.RWSCF_mice, RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, 'PN');
            timegraph_auc(binned_RWS, binned_RWSCF, auc_max_win, 'PN', neuron_colors, [-2, 12], 'ploterrorbars', [2, 12], 12, 'persistent');
            figure('Position', [350,429,314,183])
            [binned_RWS, binned_RWSCF] = parsetime(mottype, allData, setmice.RWS_mice, setmice.RWSCF_mice, RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, 'UC');
            timegraph_auc(binned_RWS, binned_RWSCF, auc_max_win, 'UC', neuron_colors, [-2, 12], 'ploterrorbars', [2, 12], 12, 'persistent');
    %% 
            % All cells and traces
            mottype = 'all';
            tracetype = 'golaysignal_settime';
            [~, ~, ...
            RWS_pre, ~, RWS_post, RWSCF_pre, ~, RWSCF_post, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, false,...
            false, false, mottype, allData, tracetype, setmice);

            figure('Position', [166,575,300,183]);
            [binned_RWS, binned_RWSCF] = parsetime(mottype, allData, setmice.RWS_mice, setmice.RWSCF_mice, RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, 'PN');
            timegraph_auc(binned_RWS, binned_RWSCF, auc_max_win, 'PN', neuron_colors, [0, 3.75], 'ploterrorbars', [2, 12], 12, '');
            
            figure('Position', [166,575,300,183]);
            [binned_RWS, binned_RWSCF] = parsetime(mottype, allData, setmice.RWS_mice, setmice.RWSCF_mice, RWS_pre,RWS_post, RWSCF_pre, RWSCF_post, 'UC');
            timegraph_auc(binned_RWS, binned_RWSCF, auc_max_win, 'UC', neuron_colors, [0, 3.75], 'ploterrorbars', [2, 12], 12, '');
            
            figure('Position', [166,575,300,183]);
            [binned_RWS, binned_RWSCF] = parsetime(mottype, allData, setmice.RWS_mice, setmice.RWSCF_mice, RWS_pre,RWS_post, RWSCF_pre, RWSCF_post, 'SST');
            timegraph_auc(binned_RWS, binned_RWSCF, auc_max_win, 'SST', neuron_colors, [0, 3.75], 'ploterrorbars', [2, 12], 12, '');
            
            figure('Position', [166,575,300,183]);
            [binned_RWS, binned_RWSCF] = parsetime(mottype, allData, setmice.RWS_mice, setmice.RWSCF_mice, RWS_pre,RWS_post, RWSCF_pre, RWSCF_post, 'PV');
            timegraph_auc(binned_RWS, binned_RWSCF, auc_max_win, 'PV', neuron_colors, [0, 3.75], 'ploterrorbars', [2, 12], 12, '');
            
            figure('Position', [166,575,300,183]);
            [binned_RWS, binned_RWSCF] = parsetime(mottype, allData, setmice.RWS_mice, setmice.RWSCF_mice, RWS_pre,RWS_post, RWSCF_pre, RWSCF_post, 'VIP');
            timegraph_auc(binned_RWS, binned_RWSCF, auc_max_win, 'VIP', neuron_colors, [0, 3.75], 'ploterrorbars', [2, 12], 12, '');
    %% Max and area under the curve (by mouse) pre- and post- plasticity

            % Persistent cells
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces_settime';
            [~, ~, RWS_pre, ~, RWS_post, RWSCF_pre, ~, RWSCF_post, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,...
            false, false, mottype, allData, tracetype, setmice);
            plotauc_bymouseV2(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, neuron_colors, 1, auc_max_win, {'RWS', 'RWSCF'}, {'Pre', 'Post'}, [0, 2], 'persistent', 'paired')
%% FIGURE 2
    %% Maximum and area under the curve (by neuron) to W and W+CF stimuli

            % PNs and INs (only those responsive to both W and W+CF)
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces_settime';
            [pre, pre_wo, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true, false, true, mottype, allData, tracetype, setmice);
            [pre, pre_wo] = visualizeandtracesBT(neuron_colors, trace_window, [-0.1, 0.4], stim_onset, pre, pre_wo, 'yesplot');
            plotauc_byneuronBT_violin(pre, pre_wo, neuron_colors, auc_max_win, {'W', 'W+CF'}, [-3, 12], 'pairedstats')
    %%
            % SST and PV neurons (only those responsive to both W and W+CF)
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces';
            [pre, pre_wo, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true, false, true, mottype, allData, tracetype, setmice);
            [pre, pre_wo] = visualizeandtracesBT(neuron_colors, trace_window, [-0.1, 0.4], stim_onset, pre, pre_wo, 'yesplot');
            plotauc_byneuronBT_violin(pre, pre_wo, neuron_colors, [326, 332], {'W', 'W+CF'}, [-3, 12], 'pairedstats')
    %%          
            % VIP neurons (only those responsive to both W and W+CF)
            load('setmice_VIP_BT.mat')
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces';
            [pre, pre_wo, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true, false, true, mottype, allData, tracetype, setmice_VIP_BT);
            [pre, pre_wo] = visualizeandtracesBT(neuron_colors, trace_window, [-0.1, 0.4], stim_onset, pre, pre_wo, 'yesplot');
            plotauc_byneuronBT_violin(pre, pre_wo, neuron_colors, auc_max_win, {'W', 'W+CF'}, [-3, 12], 'pairedstats')
            
            % Additional auc_max_win analysis window
            visualizeandtracesBT_windows(neuron_colors, trace_window, [-0.1, 0.4], stim_onset, pre, pre_wo, 'yesplot', auc_max_win, [326, 332]);
            plotauc_byneuronBT_violin(pre, pre_wo, neuron_colors, [326, 332], {'W', 'W+CF'}, [-3, 12], 'pairedstats')

            % VIP neurons (those responsive to W and/or W+CF)
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces';
            [pre, pre_wo, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,false, true, mottype, allData, tracetype, setmice_VIP_BT);
            [pre, pre_wo] = visualizeortracesBT(neuron_colors, trace_window, [-0.1, 0.4], stim_onset, pre, pre_wo, 'yesplot');
            plotauc_byneuronBT_violin(pre, pre_wo, neuron_colors, auc_max_win, {'W', 'W+CF'}, [-3, 12], 'unpairedstats')
    %% Maximum and area under the curve (by mouse) to W and W+CF stimuli
            % PN and IN neurons
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces_settime';
            [pre, pre_wo, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,false, false, mottype, allData, tracetype, setmice);
            plotauc_bymouseBT(pre, pre_wo, neuron_colors, 0, auc_max_win, {'W', 'W + CF'}, [0, 2.5], 'persistent', 'normalize')
     %%
            % SST and PV neurons
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces';
            [pre, pre_wo, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,false, false, mottype, allData, tracetype, setmice);
            plotauc_bymouseBT(pre, pre_wo, neuron_colors, 0, auc_max_win, {'W', 'W + CF'}, [0, 2.5], 'persistent', 'normalize')
     %%
            % VIP neurons
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces';
            [pre, pre_wo, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,false, false, mottype, allData, tracetype, setmice_VIP_BT);
            plotauc_bymouseBT(pre, pre_wo, neuron_colors, 0, auc_max_win, {'W', 'W + CF'}, [0, 2.5], '', 'normalize')
%% FIGURE 3
    %% Maximum and area under the curve (by neuron) pre- and post- plasticity
            % PNs, INs
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces';
            [~, ~, ~, ~, ~, ~, ~, ~, RWSCF_SST_Gi_pre_comb, RWSCF_SST_Gi_post, control_SST_Gi_pre_comb, control_SST_Gi_post, RWS_SST_Gq_pre_comb, RWS_SST_Gq_post, control_SST_Gq_pre_comb, control_SST_Gq_post,~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces3(baselinenormperiod, 1, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
           
            [control_SST_Gq_pre_comb, control_SST_Gq_post, RWS_SST_Gq_pre_comb, RWS_SST_Gq_post] = visualizeandtraces(neuron_colors, trace_window, [-0.1, 1], stim_onset, ...
            control_SST_Gq_pre_comb, control_SST_Gq_post, RWS_SST_Gq_pre_comb, RWS_SST_Gq_post, 'yesplot');
            [control_SST_Gi_pre_comb, control_SST_Gi_post, RWSCF_SST_Gi_pre_comb, RWSCF_SST_Gi_post] = visualizeandtraces(neuron_colors, trace_window, [-0.1, 1], stim_onset, ...
            control_SST_Gi_pre_comb, control_SST_Gi_post, RWSCF_SST_Gi_pre_comb, RWSCF_SST_Gi_post, 'yesplot');
            
            plotauc_byneuron_box(control_SST_Gq_pre_comb, control_SST_Gq_post, RWS_SST_Gq_pre_comb, RWS_SST_Gq_post, neuron_colors, 0, auc_max_win, {'+SST', 'RWS+SST'}, {'Pre', 'Post'}, [-1, 18])
            plotauc_byneuron_box(control_SST_Gi_pre_comb, control_SST_Gi_post, RWSCF_SST_Gi_pre_comb, RWSCF_SST_Gi_post, neuron_colors, 0, auc_max_win, {'-SST', 'RWSCF-SST'}, {'Pre', 'Post'}, [-1, 18])
            plotmax_byneuron(control_SST_Gq_pre_comb, control_SST_Gq_post, RWS_SST_Gq_pre_comb, RWS_SST_Gq_post, neuron_colors, 0, auc_max_win, {'+SST', 'RWS+SST'}, {'Pre', 'Post'}, [0, 1.2])
            plotmax_byneuron(control_SST_Gi_pre_comb, control_SST_Gi_post, RWSCF_SST_Gi_pre_comb, RWSCF_SST_Gi_post, neuron_colors, 0, auc_max_win, {'-SST', 'RWSCF-SST'}, {'Pre', 'Post'}, [0, 1.2])
    %%
            % SST neurons
            load('setmice_SST_DREADD.mat')
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces';
            [~, ~, ~, ~, ~, ~, ~, ~, RWSCF_SST_Gi_pre_comb, RWSCF_SST_Gi_post, control_SST_Gi_pre_comb, control_SST_Gi_post, RWS_SST_Gq_pre_comb, RWS_SST_Gq_post, control_SST_Gq_pre_comb, control_SST_Gq_post,~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces3(baselinenormperiod, 1, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice_SST_DREADD);
            
            [control_SST_Gq_pre_comb, control_SST_Gq_post, RWS_SST_Gq_pre_comb, RWS_SST_Gq_post] = visualizeandtraces(neuron_colors, trace_window, [-0.1, 0.8], stim_onset, ...
            control_SST_Gq_pre_comb, control_SST_Gq_post, RWS_SST_Gq_pre_comb, RWS_SST_Gq_post, 'yesplot');
            [control_SST_Gi_pre_comb, control_SST_Gi_post, RWSCF_SST_Gi_pre_comb, RWSCF_SST_Gi_post] = visualizeandtraces(neuron_colors, trace_window, [-0.1, 0.8], stim_onset, ...
            control_SST_Gi_pre_comb, control_SST_Gi_post, RWSCF_SST_Gi_pre_comb, RWSCF_SST_Gi_post, 'yesplot');
            
            plotauc_byneuron_violin(control_SST_Gq_pre_comb, control_SST_Gq_post, RWS_SST_Gq_pre_comb, RWS_SST_Gq_post, neuron_colors, 0, [306, 360], {'+SST', 'RWS+SST'}, {'Pre', 'Post'}, [-8, 25])
            plotauc_byneuron_violin(control_SST_Gi_pre_comb, control_SST_Gi_post, RWSCF_SST_Gi_pre_comb, RWSCF_SST_Gi_post, neuron_colors, 0, [306, 360], {'-SST', 'RWSCF-SST'}, {'Pre', 'Post'}, [-8, 25])
            plotauc_byneuron_box(control_SST_Gq_pre_comb, control_SST_Gq_post, RWS_SST_Gq_pre_comb, RWS_SST_Gq_post, neuron_colors, 0, [306, 360], {'+SST', 'RWS+SST'}, {'Pre', 'DCZ'}, [-1, 18])
            plotauc_byneuron_box(control_SST_Gi_pre_comb, control_SST_Gi_post, RWSCF_SST_Gi_pre_comb, RWSCF_SST_Gi_post, neuron_colors, 0, [306, 360], {'-SST', 'RWSCF-SST'}, {'Pre', 'DCZ'}, [-1, 18])
%% FIGURE 4; FIGURE 5
    %% Maximum and area under the curve (by neuron) pre- and post- plasticity
            % PNs, INs
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces';
            [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,RWSCF_VIP_Gq_pre_comb, RWSCF_VIP_Gq_post, control_VIP_Gq_pre_comb, control_VIP_Gq_post, RWS_VIP_Gi_pre_comb, RWS_VIP_Gi_post, control_VIP_Gi_pre_comb, control_VIP_Gi_post]...
            = parsetraces3(baselinenormperiod, 1, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
            
            [control_VIP_Gi_pre_comb, control_VIP_Gi_post, RWS_VIP_Gi_pre_comb, RWS_VIP_Gi_post] = visualizeandtraces(neuron_colors, trace_window, [-0.1, 0.4], stim_onset, ...
            control_VIP_Gi_pre_comb, control_VIP_Gi_post, RWS_VIP_Gi_pre_comb, RWS_VIP_Gi_post, 'yesplot');
            
            [control_VIP_Gq_pre_comb, control_VIP_Gq_post, RWSCF_VIP_Gq_pre_comb, RWSCF_VIP_Gq_post] = visualizeandtraces(neuron_colors, trace_window, [-0.1, 0.4], stim_onset, ...
            control_VIP_Gq_pre_comb, control_VIP_Gq_post, RWSCF_VIP_Gq_pre_comb, RWSCF_VIP_Gq_post, 'yesplot');
            
            plotauc_byneuron_box(control_VIP_Gi_pre_comb, control_VIP_Gi_post, RWS_VIP_Gi_pre_comb, RWS_VIP_Gi_post, neuron_colors, 0, auc_max_win, {'-VIP', 'RWS-VIP'}, {'Pre', 'Post'}, [-.5, 5.5])
            plotauc_byneuron_box(control_VIP_Gq_pre_comb, control_VIP_Gq_post, RWSCF_VIP_Gq_pre_comb, RWSCF_VIP_Gq_post, neuron_colors, 0, auc_max_win, {'+VIP', 'RWSCF+VIP'}, {'Pre', 'Post'}, [-.5, 5.5])
            plotmax_byneuron(control_VIP_Gi_pre_comb, control_VIP_Gi_post, RWS_VIP_Gi_pre_comb, RWS_VIP_Gi_post, neuron_colors, 0, auc_max_win, {'-VIP', 'RWS-VIP'}, {'Pre', 'Post'}, [0, 0.4])
            plotmax_byneuron(control_VIP_Gq_pre_comb, control_VIP_Gq_post, RWSCF_VIP_Gq_pre_comb, RWSCF_VIP_Gq_post, neuron_colors, 0, auc_max_win, {'+VIP', 'RWSCF+VIP'}, {'Pre', 'Post'}, [0, 0.4])
    %%
            % VIP neurons
            mottype = 'all';
            tracetype = 'golaysignal';
            [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,RWSCF_VIP_Gq_pre, ~, RWSCF_VIP_Gq_pre_dcz, RWSCF_VIP_Gq_post, control_VIP_Gq_pre, ~, control_VIP_Gq_pre_dcz, control_VIP_Gq_post, RWS_VIP_Gi_pre, ~, RWS_VIP_Gi_pre_dcz, RWS_VIP_Gi_post, control_VIP_Gi_pre, ~, control_VIP_Gi_pre_dcz, control_VIP_Gi_post, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, 1, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
            
            [control_VIP_Gi_pre, control_VIP_Gi_post, RWS_VIP_Gi_pre, RWS_VIP_Gi_post] = visualizeandtraces(neuron_colors, [290, 367], [0, 0.45], stim_onset, ...
            control_VIP_Gi_pre, control_VIP_Gi_post, RWS_VIP_Gi_pre, RWS_VIP_Gi_post, 'yesplot');
            [control_VIP_Gq_pre, control_VIP_Gq_post, RWSCF_VIP_Gq_pre, RWSCF_VIP_Gq_post] = visualizeandtraces(neuron_colors, [290, 367], [0, 0.45], stim_onset, ...
            control_VIP_Gq_pre, control_VIP_Gq_post, RWSCF_VIP_Gq_pre, RWSCF_VIP_Gq_post, 'yesplot');

            % Additional auc_max_win analysis window (similar to Figure 2)
            plotauc_byneuron_box(control_VIP_Gi_pre, control_VIP_Gi_post, RWS_VIP_Gi_pre, RWS_VIP_Gi_post, neuron_colors, 0, [327, 333], {'-VIP', 'RWS-VIP'}, {'Pre', 'DCZ'}, [-.5, 5.5])
            plotauc_byneuron_box(control_VIP_Gq_pre, control_VIP_Gq_post, RWSCF_VIP_Gq_pre, RWSCF_VIP_Gq_post, neuron_colors, 0, [327, 333], {'+VIP', 'RWSCF+VIP'}, {'Pre', 'DCZ'}, [-.5, 5.5]);
%% FIGURE 6
    %% Calculate terminal density
            runterminaldensity
    %% Maximum and area under the curve (by neuron) to W and W+CF stimuli, before and after DCZ admin
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces'; % evokedtraces, evokedtraces2
            [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, SST_Gi_ZI_pre, SST_Gi_ZI_pre_wo, SST_Gi_ZI_pre_dcz, SST_Gi_ZI_pre_dcz_wo, PV_Gi_ZI_pre, PV_Gi_ZI_pre_wo, PV_Gi_ZI_pre_dcz, PV_Gi_ZI_pre_dcz_wo]...
            = parsetraces(baselinenormperiod, 1, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
            
            % Grab only the neurons responsive to all conditions: pre (W and W+CF) and after DCZ admin (W and W+CF)
            [SST_Gi_ZI_pre, SST_Gi_ZI_pre_wo, SST_Gi_ZI_pre_dcz, SST_Gi_ZI_pre_dcz_wo] = visualizeandtraces(neuron_colors, trace_window, [-0.1, 0.61], stim_onset, ...
            SST_Gi_ZI_pre, SST_Gi_ZI_pre_wo, SST_Gi_ZI_pre_dcz, SST_Gi_ZI_pre_dcz_wo, 'yesplot');
            [PV_Gi_ZI_pre, PV_Gi_ZI_pre_wo, PV_Gi_ZI_pre_dcz, PV_Gi_ZI_pre_dcz_wo] = visualizeandtraces(neuron_colors, trace_window, [-0.1, 0.61], stim_onset, ...
            PV_Gi_ZI_pre, PV_Gi_ZI_pre_wo, PV_Gi_ZI_pre_dcz, PV_Gi_ZI_pre_dcz_wo, 'yesplot');
            plotauc_byneuron_violin(PV_Gi_ZI_pre, PV_Gi_ZI_pre_wo, PV_Gi_ZI_pre_dcz, PV_Gi_ZI_pre_dcz_wo, neuron_colors, 0, auc_max_win,   {'Pre', 'DCZ'}, {'W', 'W+CF'}, [-3, 12])       
            
%% FIGURE 1 - FIGURE SUPPLEMENT 3
    %% Behavioral data
            visualizemotion_new(allData, 'NM', prestim_win, poststim_win, '', [248, 372], 'motionInfo_settime')
            visualizemotion_new(allData, 'MT', prestim_win, poststim_win, '', [248, 372], 'motionInfo_settime')
            visualizemotion_new(allData, 'T', prestim_win, poststim_win, '', [248, 372], 'motionInfo_settime')
            
            % Proportion of rest, run, transition, halt trials
            [proportion_mot_trials] = visualizemotion_byperiod(allData, [279, 372], '', '', 'motionInfo_settime');
            [m1_cond1, m1_cond2, m2_cond1, m2_cond2] = plotmotionproportion(proportion_mot_trials, setmice.RWS_mice, setmice.RWSCF_mice, 'pre_w', 'post', '');
            plotproportionscatter(m1_cond1, m1_cond2, m2_cond1, m2_cond2, 'normalized')
            
            % Combine run and transition trials
            plotmotionproportion(proportion_mot_trials, setmice.RWS_mice, setmice.RWSCF_mice, 'pre_w', 'post', 'combineactive')
    %%
            % Motion traces (active state)
            mottype = 'MT'; % 'all', 'NM', 'M', 'T', 'H', 'MT'
            [w_MT, wo_MT, RWS_pre_MT, ~, RWS_post_MT, RWSCF_pre_MT, ~, RWSCF_post_MT, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsemottraces(true, true, mottype, allData, setmice, 'motionInfo_settime');
            
            visualizemottraces(trace_window, [-0.05, 1.1], stim_onset, RWS_pre_MT, RWS_post_MT, RWSCF_pre_MT, RWSCF_post_MT, 'yesplot', 'MT')
    %%
            % Motion traces (rest state)
            mottype = 'NM'; % 'all', 'NM', 'M', 'T', 'H', 'MT'
            [~, ~, RWS_pre_NM, ~, RWS_post_NM, RWSCF_pre_NM, ~, RWSCF_post_NM, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsemottraces(true, true, mottype, allData, setmice, 'motionInfo_settime');
            visualizemottraces(trace_window, [-0.05, 1.1], stim_onset, RWS_pre_NM, RWS_post_NM, RWSCF_pre_NM, RWSCF_post_NM, 'yesplot', 'NM')
    %%        
            % Motion traces (Go state)
            mottype = 'T'; % 'all', 'NM', 'M', 'T', 'H', 'MT'
            [~, ~, RWS_pre_T, ~, RWS_post_T, RWSCF_pre_T, ~, RWSCF_post_T, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsemottraces(true, true, mottype, allData, setmice, 'motionInfo_settime');
            visualizemottraces(trace_window, [-0.05, 1.1], stim_onset, RWS_pre_T, RWS_post_T, RWSCF_pre_T, RWSCF_post_T, 'yesplot', 'T')
            plotauc_motion(RWS_pre_T, RWS_post_T, auc_max_win, {'W', 'W + CF'}, [0, 23], 'persistent', 'normalize')
            plotauc_motion(RWSCF_pre_T, RWSCF_post_T, auc_max_win, {'W', 'W + CF'}, [0, 23], 'persistent', 'normalize')
    %% Maximum and area under the curve (by neuron) pre- and post- plasticity
            % Active state
            mottype = 'MT'; % 'all', 'NM', 'M', 'T', 'H', 'MT'
            tracetype = 'evokedtraces_settime';
            [~, ~, RWS_pre, ~, RWS_post, RWSCF_pre, ~, RWSCF_post, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
             
            [RWS_pre, RWS_post, RWSCF_pre, RWSCF_post] = visualizeandtraces(neuron_colors, trace_window, [-0.1, 0.4], stim_onset, ...
            RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, 'yesplot');
            
            plotauc_byneuron(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, neuron_colors, 0, auc_max_win, {'RWS', 'RWSCF'}, {'Pre', 'Post'}, [0, 7.5])

     %%
            % Rest state
            mottype = 'NM'; % 'all', 'NM', 'M', 'T', 'H', 'MT'
            tracetype = 'evokedtraces_settime';
            [~, ~, RWS_pre, ~, RWS_post, RWSCF_pre, ~, RWSCF_post, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
            
            [RWS_pre, RWS_post, RWSCF_pre, RWSCF_post] = visualizeandtraces(neuron_colors, trace_window, [-0.1, 0.45], stim_onset, ...
            RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, 'yesplot');
            plotauc_byneuron_box(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, neuron_colors, 0, auc_max_win, {'RWS', 'RWSCF'}, {'Pre', 'Post'}, [-2, 12])
            
    %% Max and area under the curve (by mouse) pre- and post- plasticity
            % Active state
            mottype = 'MT'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces_settime'; % evokedtraces, evokedtraces2, golaysignal, golayshift
            [~, ~, RWS_pre, ~, RWS_post, RWSCF_pre, ~, RWSCF_post, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,...
            false, false, mottype, allData, tracetype, setmice);
            
            %plotauc_bymouseV2(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, neuron_colors, 1, auc_max_win, {'RWS', 'RWSCF'}, {'Pre', 'Post'}, [0, 10.5], 'persistent', 'paired')
            plotauc_bymouseV2(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, neuron_colors, 1, auc_max_win, {'RWS', 'RWSCF'}, {'Pre', 'Post'}, [0.4, 2], 'persistent', 'normalize')
    %%
            % Rest state
            mottype = 'NM'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces_settime'; % evokedtraces, evokedtraces2, golaysignal, golayshift
            [~, ~, RWS_pre, ~, RWS_post, RWSCF_pre, ~, RWSCF_post, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,...
            false, false, mottype, allData, tracetype, setmice);
            
            %plotauc_bymouseV2(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, neuron_colors, 1, auc_max_win, {'RWS', 'RWSCF'}, {'Pre', 'Post'}, [0, 10.5], 'persistent', 'paired')
            plotauc_bymouseV2(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, neuron_colors, 1, auc_max_win, {'RWS', 'RWSCF'}, {'Pre', 'Post'}, [0.4, 2], 'persistent', 'normalized')
    %% Percent active trials versus ∆AUC
            % Grab active evoked events
            mottype = 'MT'; % 'all', 'NM', 'M', 'T', 'H', 'MT'
            tracetype = 'evokedtraces_settime';
            [~, ~, RWS_pre_MT, ~, RWS_post_MT, RWSCF_pre_MT, ~, RWSCF_post_MT, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, false,...
            false, false, mottype, allData, tracetype, setmice);
            
            % Grab all evoked events
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H', 'MT'
            tracetype = 'evokedtraces_settime';
            [~, ~, RWS_pre, ~, RWS_post, RWSCF_pre, ~, RWSCF_post, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, false,...
            false, false, mottype, allData, tracetype, setmice);
            
            % Calculate percent active trials for each cell
            [RWS_prctactive, RWSCF_prctactive] = calculatepercentactive(RWS_pre, RWS_pre_MT, RWS_post, RWS_post_MT, RWSCF_pre, RWSCF_pre_MT, RWSCF_post, RWSCF_post_MT);
            
            % Keep only persistent cells
            mottype = 'all'; % 'all', 'NM', 'M', 'T', 'H'
            tracetype = 'evokedtraces_settime';
            [~, ~, RWS_pre, ~, RWS_post, RWSCF_pre, ~, RWSCF_post, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, baselinenorm, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
            
            % Grab only the neurons responsive both pre and post 
            [RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, RWS_prctactive, RWSCF_prctactive] = keeppersistent(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, RWS_prctactive, RWSCF_prctactive);
            
            plotauc_prctactive_byneuron(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, RWS_prctactive, RWSCF_prctactive, neuron_colors, 0, auc_max_win, {'RWS', 'RWSCF'}, {'Pre', 'Post'}, [0, 6], '')
    %% Motion behavior in W, WO trials
            % Motion traces (active state)
            mottype = 'MT'; % 'all', 'NM', 'M', 'T', 'H', 'MT'
            [w_MT, wo_MT, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsemottraces(true, true, mottype, allData, setmice, 'motionInfo_settime');
            plotauc_motion(w_MT, wo_MT, auc_max_win, {'W', 'W + CF'}, [0, 23], 'persistent', 'normalize')
    %%
            % Motion traces (rest state)
            mottype = 'NM'; % 'all', 'NM', 'M', 'T', 'H', 'MT'
            [w_NM, wo_NM, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsemottraces(true, true, mottype, allData, setmice, 'motionInfo_settime');
            plotauc_motion(w_NM, wo_NM, auc_max_win, {'W', 'W + CF'}, [0, 23], 'persistent', 'normalize')
            visualizemottraces(trace_window, [-0.05, 1.1], stim_onset, w_NM, wo_NM, w_MT, wo_MT, 'yesplot', 'all')
            
%% FIGURE 4 - FIGURE SUPPLEMENT 1
    %% % PV neurons
            % Plot the neurons responsive pre, after DCZ administration, and post together
            mottype = 'all';
            tracetype = 'evokedtraces';
            [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_wo, RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, control_PV_Gi_pre, control_PV_Gi_pre_wo, control_PV_Gi_pre_dcz, control_PV_Gi_post, RWS_PV_Gq_pre, RWS_PV_Gq_pre_wo, RWS_PV_Gq_pre_dcz, RWS_PV_Gq_post, control_PV_Gq_pre, control_PV_Gq_pre_wo, control_PV_Gq_pre_dcz, control_PV_Gq_post, ~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, 0, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
            
            %[control_PV_Gq_pre, control_PV_Gq_pre_DCZ, control_PV_Gq_post, RWS_PV_Gq_pre, RWS_PV_Gq_pre_dcz, RWS_PV_Gq_post] = visualizeandtraces3(neuron_colors, trace_window, [0, 0.7], stim_onset, ...
            %control_PV_Gq_pre, control_PV_Gq_pre_dcz, control_PV_Gq_post, RWS_PV_Gq_pre, RWS_PV_Gq_pre_dcz, RWS_PV_Gq_post, 'yesplot');
            [control_PV_Gi_pre, control_PV_Gi_pre_dcz, control_PV_Gi_post, RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post] = visualizeandtraces3(neuron_colors, trace_window, [-.2, .72], stim_onset, ...
            control_PV_Gi_pre, control_PV_Gi_pre_dcz, control_PV_Gi_post, RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, 'yesplot');
            
            %plotauc_byneuron3(control_PV_Gq_pre, control_PV_Gq_pre_dcz, control_PV_Gq_post, RWS_PV_Gq_pre, RWS_PV_Gq_pre_dcz, RWS_PV_Gq_post, neuron_colors, 1, auc_max_win, {'+PV', 'RWS+PV'}, {'Pre' , 'DCZ', 'Post'}, [0, 5])
            plotauc_byneuron3(control_PV_Gi_pre, control_PV_Gi_pre_dcz, control_PV_Gi_post, RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, neuron_colors, 1, auc_max_win, {'-PV', 'RWSCF-PV'}, {'Pre' , 'DCZ', 'Post'}, [0, 14])
            
            % Plot conditions separately
            plotauc_byneuron(control_PV_Gi_pre, control_PV_Gi_pre_dcz, RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_dcz, neuron_colors, 1, auc_max_win, {'-PV', 'RWSCF-PV'}, {'Pre', 'Pre (DCZ)'}, [0, 15])
            plotauc_byneuron(control_PV_Gi_pre_dcz, control_PV_Gi_post, RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, neuron_colors, 1, auc_max_win, {'-PV', 'RWSCF-PV'}, {'Pre (DCZ)', 'Post'}, [0, 15])
            plotauc_byneuron(control_PV_Gi_pre, control_PV_Gi_post, RWSCF_PV_Gi_pre, RWSCF_PV_Gi_post, neuron_colors, 1, auc_max_win, {'-PV', 'RWSCF-PV'}, {'Pre', 'Post'}, [0, 15])
    %% SST neurons
            % Plot the neurons responsive pre, after DCZ administration, and post together
            mottype = 'all';
            tracetype = 'evokedtraces';
            [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, RWSCF_SST_Gi_pre, ~, RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, control_SST_Gi_pre, ~, control_SST_Gi_pre_dcz, control_SST_Gi_post, RWS_SST_Gq_pre, ~, RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, control_SST_Gq_pre, ~, control_SST_Gq_pre_dcz, control_SST_Gq_post,~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, 1, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
            
            [control_SST_Gq_pre, control_SST_Gq_pre_dcz, control_SST_Gq_post, RWS_SST_Gq_pre, RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post] = visualizeandtraces3(neuron_colors, trace_window, [0, 0.7], stim_onset, ...
            control_SST_Gq_pre, control_SST_Gq_pre_dcz, control_SST_Gq_post, RWS_SST_Gq_pre, RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, 'yesplot');
            [control_SST_Gi_pre, control_SST_Gi_pre_dcz, control_SST_Gi_post, RWSCF_SST_Gi_pre, RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post] = visualizeandtraces3(neuron_colors, trace_window, [0, 0.7], stim_onset, ...
            control_SST_Gi_pre, control_SST_Gi_pre_dcz, control_SST_Gi_post, RWSCF_SST_Gi_pre, RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, 'yesplot');
            
            plotauc_byneuron3(control_SST_Gq_pre, control_SST_Gq_pre_dcz, control_SST_Gq_post, RWS_SST_Gq_pre, RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, neuron_colors, 0, auc_max_win, {'+SST', 'RWS+SST'}, {'Pre' , 'DCZ', 'Post'}, [0, 5])
            plotauc_byneuron3(control_SST_Gi_pre, control_SST_Gi_pre_dcz, control_SST_Gi_post, RWSCF_SST_Gi_pre, RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, neuron_colors, 1, auc_max_win, {'-SST', 'RWSCF-SST'}, {'Pre' , 'DCZ', 'Post'}, [0, 5])
            
            % Plot conditions separately
            plotauc_byneuron(control_SST_Gq_pre, control_SST_Gq_pre_dcz, RWS_SST_Gq_pre, RWS_SST_Gq_pre_dcz, neuron_colors, 0, auc_max_win, {'+SST', 'RWS+SST'}, {'Pre', 'Pre (DCZ)'}, [0, 3.5])
            plotauc_byneuron(control_SST_Gq_pre_dcz, control_SST_Gq_post, RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, neuron_colors, 1, auc_max_win, {'+SST', 'RWS+SST'}, {'Pre (DCZ)', 'Post'}, [0, 3.5])
            plotauc_byneuron(control_SST_Gq_pre, control_SST_Gq_post, RWS_SST_Gq_pre, RWS_SST_Gq_post, neuron_colors, 0, auc_max_win, {'+SST', 'RWS+SST'}, {'Pre', 'Post'}, [0, 3.5])
            plotauc_byneuron(control_SST_Gi_pre, control_SST_Gi_pre_dcz, RWSCF_SST_Gi_pre, RWSCF_SST_Gi_pre_dcz, neuron_colors, 0, auc_max_win, {'-SST', 'RWSCF-SST'}, {'Pre', 'Pre (DCZ)'}, [0, 3.5])
            plotauc_byneuron(control_SST_Gi_pre_dcz, control_SST_Gi_post, RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, neuron_colors, 1, auc_max_win, {'-SST', 'RWSCF-SST'}, {'Pre (DCZ)', 'Post'}, [0, 3.5])
            plotauc_byneuron(control_SST_Gi_pre, control_SST_Gi_post, RWSCF_SST_Gi_pre, RWSCF_SST_Gi_post, neuron_colors, 0, auc_max_win, {'-SST', 'RWSCF-SST'}, {'Pre', 'Post'}, [0, 2.5]); 
    %% VIP neurons
            % Plot the neurons responsive pre, after DCZ administration, and post together
            mottype = 'all';
            tracetype = 'evokedtraces';
            [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~,RWSCF_VIP_Gq_pre, ~, RWSCF_VIP_Gq_pre_dcz, RWSCF_VIP_Gq_post, control_VIP_Gq_pre, ~, control_VIP_Gq_pre_dcz, control_VIP_Gq_post, RWS_VIP_Gi_pre, ~, RWS_VIP_Gi_pre_dcz, RWS_VIP_Gi_post, control_VIP_Gi_pre, ~, control_VIP_Gi_pre_dcz, control_VIP_Gi_post, ~, ~, ~, ~, ~, ~, ~, ~]...
            = parsetraces(baselinenormperiod, 1, baseline_reject_thresh, true,...
            false, true, mottype, allData, tracetype, setmice);
            
            [control_VIP_Gi_pre, control_VIP_Gi_pre_dcz, control_VIP_Gi_post, RWS_VIP_Gi_pre, RWS_SST__Gq_pre_dcz, RWS_VIP_Gi_post] = visualizeandtraces3(neuron_colors, trace_window, [0, 0.31], stim_onset, ...
            control_VIP_Gi_pre, control_VIP_Gi_pre_dcz, control_VIP_Gi_post, RWS_VIP_Gi_pre, RWS_VIP_Gi_pre_dcz, RWS_VIP_Gi_post, 'yesplot');
            [control_VIP_Gq_pre, control_VIP_Gq_pre_dcz, control_VIP_Gq_post, RWSCF_VIP_Gq_pre, RWSCF_VIP_Gq_pre_dcz, RWSCF_VIP_Gq_post] = visualizeandtraces3(neuron_colors, trace_window, [0, 0.31], stim_onset, ...
            control_VIP_Gq_pre, control_VIP_Gq_pre_dcz, control_VIP_Gq_post, RWSCF_VIP_Gq_pre, RWSCF_VIP_Gq_pre_dcz, RWSCF_VIP_Gq_post, 'yesplot');
            
            plotauc_byneuron3(control_VIP_Gi_pre, control_VIP_Gi_pre_dcz, control_VIP_Gi_post, RWS_VIP_Gi_pre, RWS_VIP_Gi_pre_dcz, RWS_VIP_Gi_post, neuron_colors, 1, auc_max_win, {'-VIP', 'RWS-VIP'}, {'Pre' , 'DCZ', 'Post'}, [0, 5])
            plotauc_byneuron3(control_VIP_Gq_pre, control_VIP_Gq_pre_dcz, control_VIP_Gq_post, RWSCF_VIP_Gq_pre, RWSCF_VIP_Gq_pre_dcz, RWSCF_VIP_Gq_post, neuron_colors, 1, auc_max_win, {'+VIP', 'RWSCF+VIP'}, {'Pre' , 'DCZ', 'Post'}, [0, 5])
            
            % Plot conditions separately
            plotauc_byneuron(control_VIP_Gi_pre, control_VIP_Gi_pre_dcz, RWS_VIP_Gi_pre, RWS_VIP_Gi_pre_dcz, neuron_colors, 1, auc_max_win, {'-VIP', 'RWS-VIP'}, {'Pre', 'Pre (DCZ)'}, [0, 3.5])
            plotauc_byneuron(control_VIP_Gi_pre_dcz, control_VIP_Gi_post, RWS_VIP_Gi_pre_dcz, RWS_VIP_Gi_post, neuron_colors, 1, auc_max_win, {'-VIP', 'RWS-VIP'}, {'Pre (DCZ)', 'Post'}, [0, 3.5])
            plotauc_byneuron(control_VIP_Gi_pre, control_VIP_Gi_post, RWS_VIP_Gi_pre, RWS_VIP_Gi_post, neuron_colors, 1, auc_max_win, {'-VIP', 'RWS-VIP'}, {'Pre', 'Post'}, [0, 3.5])
            plotauc_byneuron(control_VIP_Gq_pre, control_VIP_Gq_pre_dcz, RWSCF_VIP_Gq_pre, RWSCF_VIP_Gq_pre_dcz, neuron_colors, 1, auc_max_win, {'+VIP', 'RWSCF+VIP'}, {'Pre', 'Pre (DCZ)'}, [0, 3.5])
            plotauc_byneuron(control_VIP_Gq_pre_dcz, control_VIP_Gq_post, RWSCF_VIP_Gq_pre_dcz, RWSCF_VIP_Gq_post, neuron_colors, 1, auc_max_win, {'+VIP', 'RWSCF+VIP'}, {'Pre (DCZ)', 'Post'}, [0, 3.5])
            plotauc_byneuron(control_VIP_Gq_pre, control_VIP_Gq_post, RWSCF_VIP_Gq_pre, RWSCF_VIP_Gq_post, neuron_colors, 1, auc_max_win, {'+VIP', 'RWSCF+VIP'}, {'Pre', 'Post'}, [0, 2.5])