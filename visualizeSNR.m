function visualizeSNR(allData, SNR, baselineNoise, nBins, SNR_max, neuron_colors)

nMice = size(allData.data, 2);

PVdist_SNR = [];
PNdist_SNR = [];
UCdist_SNR = [];
VIPdist_SNR = [];
SSTdist_SNR = [];

PVdist_bN = [];
PNdist_bN = [];
UCdist_bN = [];
VIPdist_bN = [];
SSTdist_bN = [];


figure('Position', [50,410,1001,440]);
for i = 1:nMice
    cellType = allData.data{i}.cellType;
    SNRtemp = SNR{i};
    bNtemp = baselineNoise{i};

    nCells = length(cellType);

    for j = 1:nCells
        if strcmp(cellType(j), 'PV')
            PVdist_SNR = [PVdist_SNR, SNRtemp{j}];
            PVdist_bN = [PVdist_bN, bNtemp{j}];
        elseif strcmp(cellType(j), 'PN')
            PNdist_SNR = [PNdist_SNR, SNRtemp{j}];
            PNdist_bN = [PNdist_bN, bNtemp{j}];
        elseif strcmp(cellType(j), 'UC')
            UCdist_SNR = [UCdist_SNR, SNRtemp{j}];
            UCdist_bN = [UCdist_bN, bNtemp{j}];
        elseif strcmp(cellType(j), 'VIP')
            VIPdist_SNR = [VIPdist_SNR, SNRtemp{j}];
            VIPdist_bN = [VIPdist_bN, bNtemp{j}];
        elseif strcmp(cellType(j), 'SST')
            SSTdist_SNR = [SSTdist_SNR, SNRtemp{j}];
            SSTdist_bN = [SSTdist_bN, bNtemp{j}];
        end
    end
end

alldist_SNR = [PVdist_SNR, PNdist_SNR, VIPdist_SNR, SSTdist_SNR, UCdist_SNR];
alldist_bN = [PVdist_bN, PNdist_bN, VIPdist_bN, SSTdist_bN, UCdist_bN];

binsSNR = linspace(0, SNR_max, nBins);
binsbN = linspace(0, .1, nBins);

subplot(3, 6, 1)
histogram(PVdist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{1}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{1})
xlabel('SNR', 'FontWeight', 'bold')
ylabel('Cell count', 'FontWeight', 'bold')
title(['n PV = ', num2str(length(PVdist_SNR)), '; mean = ', num2str(mean(PVdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
hold on
xlim([0 SNR_max])
%axis off
set(gca, 'FontSize', 7)

subplot(3, 6, 2)
histogram(PNdist_SNR, 'BinEdges', binsSNR, 'FaceColor',neuron_colors{2}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{2})
xlabel('SNR', 'FontWeight', 'bold')
ylabel('Cell count', 'FontWeight', 'bold')
title(['n PN = ', num2str(length(PNdist_SNR)), '; mean = ', num2str(mean(PNdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
xlim([0 SNR_max])
hold on
%axis off
set(gca, 'FontSize', 7)

subplot(3, 6, 3)
histogram(VIPdist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{3}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{3})
xlabel('SNR', 'FontWeight', 'bold')
ylabel('Cell count', 'FontWeight', 'bold')
title(['n VIP = ', num2str(length(VIPdist_SNR)), '; mean = ', num2str(mean(VIPdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
xlim([0 SNR_max])
hold on
%axis off
set(gca, 'FontSize', 7)

subplot(3, 6, 4)
histogram(SSTdist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{5}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{5})
xlabel('SNR', 'FontWeight', 'bold')
ylabel('Cell count', 'FontWeight', 'bold')
title(['n SST = ', num2str(length(SSTdist_SNR)), '; mean = ', num2str(mean(SSTdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
xlim([0 SNR_max])
hold on
%axis off
set(gca, 'FontSize', 7)

subplot(3, 6, 5)
histogram(UCdist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
xlabel('SNR', 'FontWeight', 'bold')
ylabel('Cell count', 'FontWeight', 'bold')
title(['n Unclass. = ', num2str(length(UCdist_SNR)), '; mean = ', num2str(mean(UCdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
xlim([0 SNR_max])
hold on
%axis off
set(gca, 'FontSize', 7)

subplot(3, 6, 6)
histogram(alldist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
xlabel('SNR', 'FontWeight', 'bold')
ylabel('Cell count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(alldist_SNR)), '; mean = ', num2str(mean(alldist_SNR, 'omitnan'))], 'FontWeight', 'bold')
xlim([0 SNR_max])
hold on
%axis off
set(gca, 'FontSize', 7)

subplot(3, 6, 7)
histogram(PVdist_bN, 'BinEdges', binsbN, 'FaceColor', neuron_colors{1}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{1})
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.05 0.1 0.15 0.2 0.25 0.3])
xticklabels([0 5 10 15 20 25 30])
%xlim([0 .10])
ylabel('Cell count', 'FontWeight', 'bold')
hold on
%axis off
set(gca, 'FontSize', 7)

subplot(3, 6, 8)
histogram(PNdist_bN, 'BinEdges', binsbN, 'FaceColor',neuron_colors{2}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{2})
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.05 0.1 0.15 0.2 0.25 0.3])
xticklabels([0 5 10 15 20 25 30])
%xlim([0 .10])
ylabel('Cell count', 'FontWeight', 'bold')
hold on
%axis off
set(gca, 'FontSize', 7)

subplot(3, 6, 9)
histogram(VIPdist_bN, 'BinEdges', binsbN, 'FaceColor', neuron_colors{3}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{3})
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.05 0.1 0.15 0.2 0.25 0.3])
xticklabels([0 5 10 15 20 25 30])
%xlim([0 .10])
ylabel('Cell count', 'FontWeight', 'bold')
hold on
%axis off
set(gca, 'FontSize', 7)

subplot(3, 6, 10)
histogram(SSTdist_bN, 'BinEdges', binsbN, 'FaceColor', neuron_colors{5}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{5})
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.05 0.1 0.15 0.2 0.25 0.3])
xticklabels([0 5 10 15 20 25 30])
ylabel('Cell count', 'FontWeight', 'bold')
%xlim([0 .10])
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 11)
histogram(UCdist_bN, 'BinEdges', binsbN, 'FaceColor',neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.05 0.1 0.15 0.2 0.25 0.3])
xticklabels([0 5 10 15 20 25 30])
ylabel('Cell count', 'FontWeight', 'bold')
%xlim([0 .10])
hold on
%axis off
set(gca, 'FontSize', 7)

subplot(3, 6, 12)
histogram(alldist_bN, 'BinEdges', binsbN, 'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.05 0.1 0.15 0.2 0.25 0.3])
xticklabels([0 5 10 15 20 25 30])
ylabel('Cell count', 'FontWeight', 'bold')
%xlim([0 .10])
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 13)
scatter(PVdist_bN, PVdist_SNR, 'MarkerFaceColor', neuron_colors{1}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('σ', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('SNR', 'FontWeight', 'bold')
%xlim([0 0.3])
%ylim([0 20])
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 14)
scatter(PNdist_bN, PNdist_SNR, 'MarkerFaceColor', neuron_colors{2}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('σ', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('SNR', 'FontWeight', 'bold')
%xlim([0 0.3])
%ylim([0 20])
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 15)
scatter(VIPdist_bN, VIPdist_SNR, 'MarkerFaceColor', neuron_colors{3}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('σ', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('SNR', 'FontWeight', 'bold')
%xlim([0 0.3])
%ylim([0 20])
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 16)
scatter(SSTdist_bN, SSTdist_SNR, 'MarkerFaceColor', neuron_colors{5}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('σ', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('SNR', 'FontWeight', 'bold')
%xlim([0 0.3])
%ylim([0 20])
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 17)
scatter(UCdist_bN, UCdist_SNR, 'MarkerFaceColor', neuron_colors{4}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('σ', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('SNR', 'FontWeight', 'bold')
%xlim([0 0.3])
%ylim([0 20])
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 18)
scatter(alldist_bN, alldist_SNR, 'MarkerFaceColor', neuron_colors{4}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('σ', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('SNR', 'FontWeight', 'bold')
%xlim([0 0.3])
%ylim([0 20])
hold on
set(gca, 'FontSize', 7)

end