function [SNRdist] = visualizeSNR(allData, SNR, baselineNoise, nBins)

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

binsSNR = linspace(0, 5, nBins);
binsbN = linspace(0, .3, nBins);

figure('Position', [50 50 1600 800]);
subplot(3, 6, 1)
histogram(PVdist_SNR, 'BinEdges', binsSNR, 'FaceColor', '#bb2525', 'FaceAlpha', 1, 'EdgeColor', '#bb2525')
xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
ylabel('Cell Count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(PVdist_SNR)), '; mean = ', num2str(mean(PVdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
%axis off

subplot(3, 6, 2)
histogram(PNdist_SNR, 'BinEdges', binsSNR, 'FaceColor','#224baa', 'FaceAlpha', 1, 'EdgeColor', '#224baa')
xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
ylabel('Cell Count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(PNdist_SNR)), '; mean = ', num2str(mean(PNdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
%axis off

subplot(3, 6, 3)
histogram(VIPdist_SNR, 'BinEdges', binsSNR, 'FaceColor', '#0a8a23', 'FaceAlpha', 1, 'EdgeColor', '#0a8a23')
xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
ylabel('Cell Count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(VIPdist_SNR)), '; mean = ', num2str(mean(VIPdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
%axis off

subplot(3, 6, 4)
histogram(SSTdist_SNR, 'BinEdges', binsSNR, 'FaceColor', '#633f73', 'FaceAlpha', 1, 'EdgeColor', '#633f73')
xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
ylabel('Cell Count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(SSTdist_SNR)), '; mean = ', num2str(mean(SSTdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
%axis off

subplot(3, 6, 5)
histogram(UCdist_SNR, 'BinEdges', binsSNR, 'FaceColor', 'k', 'FaceAlpha', 1, 'EdgeColor', 'k')
xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
ylabel('Cell Count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(UCdist_SNR)), '; mean = ', num2str(mean(UCdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
%axis off

subplot(3, 6, 6)
histogram(alldist_SNR, 'BinEdges', binsSNR, 'FaceColor', 'k', 'FaceAlpha', 1, 'EdgeColor', 'k')
xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
ylabel('Cell Count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(alldist_SNR)), '; mean = ', num2str(mean(alldist_SNR, 'omitnan'))], 'FontWeight', 'bold')
%axis off

subplot(3, 6, 7)
histogram(PVdist_bN, 'BinEdges', binsbN, 'FaceColor', '#bb2525', 'FaceAlpha', 1, 'EdgeColor', '#bb2525')
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('Cell Count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(PVdist_bN))], 'FontWeight', 'bold')
%axis off

subplot(3, 6, 8)
histogram(PNdist_bN, 'BinEdges', binsbN, 'FaceColor','#224baa', 'FaceAlpha', 1, 'EdgeColor', '#224baa')
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('Cell Count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(PNdist_bN))], 'FontWeight', 'bold')
%axis off

subplot(3, 6, 9)
histogram(VIPdist_bN, 'BinEdges', binsbN, 'FaceColor', '#0a8a23', 'FaceAlpha', 1, 'EdgeColor', '#0a8a23')
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('Cell Count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(VIPdist_bN))], 'FontWeight', 'bold')
%axis off

subplot(3, 6, 10)
histogram(SSTdist_bN, 'BinEdges', binsbN, 'FaceColor', 'k', 'FaceAlpha', 1, 'EdgeColor', 'k')
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('Cell Count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(SSTdist_bN))], 'FontWeight', 'bold')

subplot(3, 6, 11)
histogram(UCdist_bN, 'BinEdges', binsbN, 'FaceColor', 'k', 'FaceAlpha', 1, 'EdgeColor', 'k')
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('Cell Count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(UCdist_bN))], 'FontWeight', 'bold')
%axis off

subplot(3, 6, 12)
histogram(alldist_bN, 'BinEdges', binsbN, 'FaceColor', 'k', 'FaceAlpha', 1, 'EdgeColor', 'k')
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('Cell Count', 'FontWeight', 'bold')
title(['nCells = ', num2str(length(alldist_bN))], 'FontWeight', 'bold')

subplot(3, 6, 13)
scatter(PVdist_bN, PVdist_SNR)
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('SNR', 'FontWeight', 'bold')
xlim([0 0.3])
ylim([0 30])

subplot(3, 6, 14)
scatter(PNdist_bN, PNdist_SNR)
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('SNR', 'FontWeight', 'bold')
xlim([0 0.3])
ylim([0 30])

subplot(3, 6, 15)
scatter(VIPdist_bN, VIPdist_SNR)
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('SNR', 'FontWeight', 'bold')
xlim([0 0.3])
ylim([0 30])

subplot(3, 6, 16)
scatter(SSTdist_bN, SSTdist_SNR)
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('SNR', 'FontWeight', 'bold')
xlim([0 0.3])
ylim([0 30])

subplot(3, 6, 17)
scatter(UCdist_bN, UCdist_SNR)
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('SNR', 'FontWeight', 'bold')
xlim([0 0.3])
ylim([0 30])

subplot(3, 6, 18)
scatter(alldist_bN, alldist_SNR)
xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
xticks([0 0.1 0.2 0.3])
xticklabels([0 10 20 30])
ylabel('SNR', 'FontWeight', 'bold')
xlim([0 0.3])
ylim([0 30])

SNRdist.PVdist = PVdist_SNR;
SNRdist.PNdist = PNdist_SNR;
SNRdist.UCdist = UCdist_SNR;
SNRdist.VIPdist = VIPdist_SNR;
SNRdist.alldist = alldist_SNR;

end


