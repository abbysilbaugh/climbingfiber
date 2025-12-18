function plot_ROI_sizes2(BT, RWS, RWSCF,RWSCF_PV_JAWS,control_PV_JAWS,RWSCF_PV_Gi,control_PV_Gi,RWS_PV_Gq,control_PV_Gq,RWSCF_SST_Gi,control_SST_Gi,RWS_SST_Gq,control_SST_Gq,RWSCF_VIP_Gq,control_VIP_Gq,RWS_VIP_Gi,control_VIP_Gi,SST_Gi_ZI,PV_Gi_ZI, neuron_colors)

% --- build PVs (unchanged) ---
PVs = cell(9, 1);
PVs{1} = BT{1};
PVs{2} = RWS{1};
PVs{3} = RWSCF{1};
PVs{4} = RWSCF_PV_JAWS{1};
PVs{5} = control_PV_JAWS{1};
PVs{6} = RWSCF_PV_Gi{1};
PVs{7} = control_PV_Gi{1};
PVs{8} = RWS_PV_Gq{1};
PVs{9} = control_PV_Gq{1};

% --- build PNs and UCs (same structure, but long lists) ---
PNs = cell(19, 1);
PNs{1} = BT{2};
PNs{2} = RWS{2};
PNs{3} = RWSCF{2};
PNs{4} = RWSCF_PV_JAWS{2};
PNs{5} = control_PV_JAWS{2};
PNs{6} = RWSCF_PV_Gi{2};
PNs{7} = control_PV_Gi{2};
PNs{8} = RWS_PV_Gq{2};
PNs{9} = control_PV_Gq{2};
PNs{10} = RWSCF_SST_Gi{2};
PNs{11} = control_SST_Gi{2};
PNs{12} = RWS_SST_Gq{2};
PNs{13} = control_SST_Gq{2};
PNs{14} = RWSCF_VIP_Gq{2};
PNs{15} = control_VIP_Gq{2};
PNs{16} = RWS_VIP_Gi{2};
PNs{17} = control_VIP_Gi{2};
PNs{18} = SST_Gi_ZI{2};
PNs{19} = PV_Gi_ZI{2};

UCs = cell(19, 1);
UCs{1} = BT{4};
UCs{2} = RWS{4};
UCs{3} = RWSCF{4};
UCs{4} = RWSCF_PV_JAWS{4};
UCs{5} = control_PV_JAWS{4};
UCs{6} = RWSCF_PV_Gi{4};
UCs{7} = control_PV_Gi{4};
UCs{8} = RWS_PV_Gq{4};
UCs{9} = control_PV_Gq{4};
UCs{10} = RWSCF_SST_Gi{4};
UCs{11} = control_SST_Gi{4};
UCs{12} = RWS_SST_Gq{4};
UCs{13} = control_SST_Gq{4};
UCs{14} = RWSCF_VIP_Gq{4};
UCs{15} = control_VIP_Gq{4};
UCs{16} = RWS_VIP_Gi{4};
UCs{17} = control_VIP_Gi{4};
UCs{18} = SST_Gi_ZI{4};
UCs{19} = PV_Gi_ZI{4};

VIPs = {BT{3}, RWS{3}, RWSCF{3}, RWSCF_VIP_Gq{3}, control_VIP_Gq{3}, RWS_VIP_Gi{3}, control_VIP_Gi{3}};
SSTs = {BT{5}, RWS{5}, RWSCF{5}, RWSCF_SST_Gi{5}, control_SST_Gi{5}, RWS_SST_Gq{5}, control_SST_Gq{5}};

% --- make boxplots ---
plot_boxplot(PVs, neuron_colors{1})
plot_boxplot_pair(PNs, UCs, neuron_colors{2}, neuron_colors{4})  % NEW: PN vs UC together
plot_boxplot(VIPs, neuron_colors{3})
plot_boxplot(SSTs, neuron_colors{5})

end


% -----------------------
% Helper: single-type boxplot
function plot_boxplot(var, color)
    nExp = numel(var);
    allData = cell2mat(var);

    group = [];
    for i = 1:nExp
        group = [group; i * ones(numel(var{i}), 1)];
    end

    figure;
    boxplot(allData, group, 'colors', color);

    xlabel('Experiment Type');
    ylim([0 18])
end


% -----------------------
% Helper: paired PN vs UC boxplot
function plot_boxplot_pair(PNs, UCs, colorPN, colorUC)
    nExp = numel(PNs);

    % Concatenate
    allData = [];
    expGroup = [];
    cellTypeGroup = [];

    for i = 1:nExp
        allData = [allData; PNs{i}; UCs{i}];
        expGroup = [expGroup; i*ones(numel(PNs{i}) + numel(UCs{i}),1)];
        cellTypeGroup = [cellTypeGroup; repmat({'PN'},numel(PNs{i}),1); repmat({'UC'},numel(UCs{i}),1)];
    end

    figure;
    boxplot(allData, {expGroup, cellTypeGroup}, 'factorseparator', 1, ...
        'colors', [colorPN; colorUC]);

    xlabel('Experiment Type');
    ylim([0 18])
    legend({'PN','UC'})
end
