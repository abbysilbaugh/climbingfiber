function plot_ROI_sizes(BT, RWS, RWSCF,RWSCF_PV_JAWS,control_PV_JAWS,RWSCF_PV_Gi,control_PV_Gi,RWS_PV_Gq,control_PV_Gq,RWSCF_SST_Gi,control_SST_Gi,RWS_SST_Gq,control_SST_Gq,RWSCF_VIP_Gq,control_VIP_Gq,RWS_VIP_Gi,control_VIP_Gi,SST_Gi_ZI,PV_Gi_ZI, neuron_colors,gettitle,ylimits)

PVs = cell(9, 1);
PNs = cell(19, 1);
VIPs = cell(7, 1);
UCs = cell(19, 1);
SSTs = cell(7, 1);

PVs{1} = BT{1};
PVs{2} = RWS{1};
PVs{3} = RWSCF{1};
PVs{4} = RWSCF_PV_JAWS{1};
PVs{5} = control_PV_JAWS{1};
PVs{6} = RWSCF_PV_Gi{1};
PVs{7} = control_PV_Gi{1};
PVs{8} = RWS_PV_Gq{1};
PVs{9} = control_PV_Gq{1};

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

VIPs{1} = BT{3};
VIPs{2} = RWS{3};
VIPs{3} = RWSCF{3};
VIPs{4} = RWSCF_VIP_Gq{3};
VIPs{5} = control_VIP_Gq{3};
VIPs{6} = RWS_VIP_Gi{3};
VIPs{7} = control_VIP_Gi{3};

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

SSTs{1} = BT{5};
SSTs{2} = RWS{5};
SSTs{3} = RWSCF{5};
SSTs{4} = RWSCF_SST_Gi{5};
SSTs{5} = control_SST_Gi{5};
SSTs{6} = RWS_SST_Gq{5};
SSTs{7} = control_SST_Gq{5};

plot_boxplot(PVs, neuron_colors{1})

plot_boxplot(PNs, neuron_colors{2})

plot_boxplot(VIPs, neuron_colors{3})

plot_boxplot(UCs, neuron_colors{4})

plot_boxplot(SSTs, neuron_colors{5})

catPVs = catneurons(PVs);
catPNs = catneurons(PNs);
catVIPs = catneurons(VIPs);
catUCs = catneurons(UCs);
catSSTs = catneurons(SSTs);

catall = [];
catall = cat(1, catall, catPVs);
catall = cat(1, catall, catPNs);
catall = cat(1, catall, catVIPs);
catall = cat(1, catall, catUCs);
catall = cat(1, catall, catSSTs);

binedges = linspace(3, 17, 15);

figure('Position', [50,410,1001,220]);
subplot(1, 6, 1)
histogram(catPVs, 'BinEdges', binedges, 'FaceColor', neuron_colors{1}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{1})
ylabel('Cell count', 'FontWeight', 'bold')
title(['n PV = ', num2str(length(catPVs)), '; mean = ', num2str(mean(catPVs, 'omitnan'))], 'FontWeight', 'bold')
hold on
%axis off
xlabel('microns')
set(gca, 'FontSize', 7)

subplot(1, 6, 2)
histogram(catPNs, 'BinEdges', binedges,  'FaceColor', neuron_colors{2}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{2})
ylabel('Cell count', 'FontWeight', 'bold')
title(['n PN = ', num2str(length(catPNs)), '; mean = ', num2str(mean(catPNs, 'omitnan'))], 'FontWeight', 'bold')
hold on
%axis off
xlabel('microns')
set(gca, 'FontSize', 7)

subplot(1, 6, 3)
histogram(catVIPs, 'BinEdges', binedges,  'FaceColor', neuron_colors{3}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{3})
ylabel('Cell count', 'FontWeight', 'bold')
title(['n VIP = ', num2str(length(catVIPs)), '; mean = ', num2str(mean(catVIPs, 'omitnan'))], 'FontWeight', 'bold')
hold on
%axis off
xlabel('microns')
set(gca, 'FontSize', 7)

subplot(1, 6, 4)
histogram(catSSTs, 'BinEdges', binedges,  'FaceColor', neuron_colors{5}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{5})
ylabel('Cell count', 'FontWeight', 'bold')
title(['n SST = ', num2str(length(catSSTs)), '; mean = ', num2str(mean(catSSTs, 'omitnan'))], 'FontWeight', 'bold')
hold on
%axis off
xlabel('microns')
set(gca, 'FontSize', 7)

subplot(1, 6, 5)
histogram(catUCs, 'BinEdges', binedges,  'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
ylabel('Cell count', 'FontWeight', 'bold')
title(['n UC = ', num2str(length(catUCs)), '; mean = ', num2str(mean(catUCs, 'omitnan'))], 'FontWeight', 'bold')
hold on
%axis off
xlabel('microns')
set(gca, 'FontSize', 7)

subplot(1, 6, 6)
histogram(catall, 'BinEdges', binedges,  'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
ylabel('Cell count', 'FontWeight', 'bold')
title(['n = ', num2str(length(catall)), '; mean = ', num2str(mean(catall, 'omitnan'))], 'FontWeight', 'bold')
hold on
%axis off
xlabel('microns')
set(gca, 'FontSize', 7)

% === BOX PLOT (PV, PN, VIP, SST, UC only) ===
groups = {catPVs, catPNs, catVIPs, catSSTs, catUCs};
labels = {'PV','PN','VIP','SST','UC'};
idx_map = [1 2 3 5 4];  % neuron_colors indices

figure('Position',[139,161,459,220]); hold on
for k = 1:numel(groups)
    y = groups{k}; y = y(~isnan(y));
    labels(k)
    mean(y)
    median(y)
    std(y)/sqrt(length(y))
    length(y)

    if isempty(y), continue; end

    bc = boxchart(k*ones(numel(y),1), y, ...
        'BoxFaceColor', neuron_colors{idx_map(k)}, ...
        'MarkerStyle', '.', ...
        'MarkerColor', neuron_colors{idx_map(k)});
    if isprop(bc,'BoxFaceAlpha');     bc.BoxFaceAlpha = 0.6; end
    if isprop(bc,'WhiskerLineColor'); bc.WhiskerLineColor = neuron_colors{idx_map(k)}; end
    if isprop(bc,'LineWidth');        bc.LineWidth = 1.0; end
end

set(gca,'XTick',1:numel(labels),'XTickLabel',labels,'FontSize',8)
ylabel('microns','FontWeight','bold')
title(gettitle,'FontWeight','bold')
grid off; box off
ylim(ylimits)



end

function plot_boxplot(var, color)

    % Number of experiments
    nExp = numel(var);

    % Concatenate all data
    allData = cell2mat(var);

    % Create grouping variable
    group = [];
    for i = 1:nExp
        group = [group; i * ones(numel(var{i}), 1)];
    end

    % Plot
    figure;
    boxplot(allData, group, 'color', color);

    xlabel('Experiment Type');
    ylim([0 18])
end

function catcells = catneurons(var)
nMice = length(var);

catcells = [];
for i = 1:nMice
    catcells = cat(1, catcells, var{i});
end

catcells = catcells(~isnan(catcells));

end
