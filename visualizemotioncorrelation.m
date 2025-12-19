function [distcorr] = visualizemotioncorrelation(allData, alphaThreshold, nBins, usetype, neuron_colors)

nMice = size(allData.data, 2);

PVmotdist = [];
PNmotdist = [];
UCmotdist = [];
VIPmotdist = [];
SSTmotdist = [];
PVmotdist_mice = [];
PNmotdist_mice = [];
UCmotdist_mice = [];
VIPmotdist_mice = [];
SSTmotdist_mice = [];

for i = 1:nMice
    cellType = allData.data{i}.cellType;


    if strcmp(usetype, 'all')
        cellmot = allData.data{i}.cellxmot;
    elseif strcmp(usetype, 'PRE')
        cellmot = allData.data{i}.cellxmot_pre;
    elseif strcmp(usetype, 'POST')
        cellmot = allData.data{i}.cellxmot_post;
    end


    nCells = length(cellType);

    for j = 1:nCells
        if strcmp(cellType(j), 'PV')
            PVmotdist = [PVmotdist, cellmot(j)];
            PVmotdist_mice = [PVmotdist_mice, i];
        elseif strcmp(cellType(j), 'PN')
            PNmotdist = [PNmotdist, cellmot(j)];
            PNmotdist_mice = [PNmotdist_mice, i];
        elseif strcmp(cellType(j), 'UC')
            UCmotdist = [UCmotdist, cellmot(j)];
            UCmotdist_mice = [UCmotdist_mice, i];
        elseif strcmp(cellType(j), 'VIP')
            VIPmotdist = [VIPmotdist, cellmot(j)];
            VIPmotdist_mice = [VIPmotdist_mice, i];
        elseif strcmp(cellType(j), 'SST')
            SSTmotdist = [SSTmotdist, cellmot(j)];
            SSTmotdist_mice = [SSTmotdist_mice, i];
        end
    end
end

PVmotdist = PVmotdist(~isinf(PVmotdist));
PNmotdist = PNmotdist(~isinf(PNmotdist));
VIPmotdist = VIPmotdist(~isinf(VIPmotdist));
UCmotdist = UCmotdist(~isinf(UCmotdist));
SSTmotdist = SSTmotdist(~isinf(SSTmotdist));
PVmotdist_mice = PVmotdist_mice(~isinf(PVmotdist));
PNmotdist_mice = PNmotdist_mice(~isinf(PNmotdist));
VIPmotdist_mice = VIPmotdist_mice(~isinf(VIPmotdist));
UCmotdist_mice = UCmotdist_mice(~isinf(UCmotdist));
SSTmotdist_mice = SSTmotdist_mice(~isinf(SSTmotdist));

nPVmice = length(unique(PVmotdist_mice));
nPNmice = length(unique(PNmotdist_mice));
nVIPmice = length(unique(VIPmotdist_mice));
nUCmice = length(unique(UCmotdist_mice));
nSSTmice = length(unique(SSTmotdist_mice));

allmotdist = [PVmotdist, PNmotdist, UCmotdist, VIPmotdist, SSTmotdist];


bins = linspace(-0.5, 0.5, nBins);


figure('position', [81,334,1546,420]);
subplot(1, 6, 1)
histogram(PVmotdist(PVmotdist < -alphaThreshold | PVmotdist > alphaThreshold), 'BinEdges', bins, 'FaceColor', neuron_colors{1}, 'FaceAlpha', 1, 'EdgeColor', neuron_colors{1})
hold on
histogram(PVmotdist(PVmotdist >= -alphaThreshold & PVmotdist <= alphaThreshold), 'BinEdges', bins, 'FaceColor', neuron_colors{1}, 'FaceAlpha', .2, 'EdgeColor', neuron_colors{1})
% [ksdensityValues, kdePoints] = ksdensity(PVmotdist);
% densityScale = max(histcounts(PVmotdist, bins)) / max(ksdensityValues);
% plot(kdePoints, ksdensityValues * densityScale, 'k-', 'LineWidth', 2)
xlabel('ρ', 'FontWeight', 'bold')
xticks([-alphaThreshold 0 alphaThreshold])
ylabel('Cell Count', 'FontWeight', 'bold')
nCor = sum(PVmotdist < -alphaThreshold | PVmotdist > alphaThreshold);
title(['nCells = ', num2str(length(PVmotdist)), '; nCor = ', num2str(nCor), ' (', num2str(100*nCor/length(PVmotdist), '%.2f'), '%)'], 'FontWeight', 'bold')
%axis off

subplot(1, 6, 2)
histogram(PNmotdist(PNmotdist < -alphaThreshold | PNmotdist > alphaThreshold), 'BinEdges', bins, 'FaceColor',neuron_colors{2}, 'FaceAlpha', 1, 'EdgeColor', neuron_colors{2})
hold on
histogram(PNmotdist(PNmotdist >= -alphaThreshold & PNmotdist <= alphaThreshold), 'BinEdges', bins, 'FaceColor',neuron_colors{2}, 'FaceAlpha', .2, 'EdgeColor', neuron_colors{2})
xlabel('ρ', 'FontWeight', 'bold')
xticks([-alphaThreshold 0 alphaThreshold])
ylabel('Cell Count', 'FontWeight', 'bold')
nCor = sum(PNmotdist < -alphaThreshold | PNmotdist > alphaThreshold);
title(['nCells = ', num2str(length(PNmotdist)), '; nCor = ', num2str(nCor), ' (', num2str(100*nCor/length(PNmotdist), '%.2f'), '%)'], 'FontWeight', 'bold')
%axis off

subplot(1, 6, 3)
histogram(VIPmotdist(VIPmotdist < -alphaThreshold | VIPmotdist > alphaThreshold), 'BinEdges', bins, 'FaceColor', neuron_colors{3}, 'FaceAlpha', 1, 'EdgeColor', neuron_colors{3})
hold on
histogram(VIPmotdist(VIPmotdist >= -alphaThreshold & VIPmotdist <= alphaThreshold), 'BinEdges', bins, 'FaceColor', neuron_colors{3}, 'FaceAlpha', .2, 'EdgeColor', neuron_colors{3})
xlabel('ρ', 'FontWeight', 'bold')
xticks([-alphaThreshold 0 alphaThreshold])
ylabel('Cell Count', 'FontWeight', 'bold')
nCor = sum(VIPmotdist < -alphaThreshold | VIPmotdist > alphaThreshold);
title(['nCells = ', num2str(length(VIPmotdist)), '; nCor = ', num2str(nCor), ' (', num2str(100*nCor/length(VIPmotdist), '%.2f'), '%)'], 'FontWeight', 'bold')
%axis off

subplot(1, 6, 4)
histogram(SSTmotdist(SSTmotdist < -alphaThreshold | SSTmotdist > alphaThreshold), 'BinEdges', bins, 'FaceColor', neuron_colors{5}, 'FaceAlpha', 1, 'EdgeColor', neuron_colors{5})
hold on
histogram(SSTmotdist(SSTmotdist >= -alphaThreshold & SSTmotdist <= alphaThreshold), 'BinEdges', bins, 'FaceColor', neuron_colors{5}, 'FaceAlpha', .2, 'EdgeColor', neuron_colors{5})
xlabel('ρ', 'FontWeight', 'bold')
xticks([-alphaThreshold 0 alphaThreshold])
ylabel('Cell Count', 'FontWeight', 'bold')
nCor = sum(SSTmotdist < -alphaThreshold | SSTmotdist > alphaThreshold);
title(['nCells = ', num2str(length(SSTmotdist)), '; nCor = ', num2str(nCor), ' (', num2str(100*nCor/length(SSTmotdist), '%.2f'), '%)'], 'FontWeight', 'bold')
%axis off

subplot(1, 6, 5)
histogram(UCmotdist(UCmotdist < -alphaThreshold | UCmotdist > alphaThreshold), 'BinEdges', bins, 'FaceColor', neuron_colors{4}, 'FaceAlpha', 1, 'EdgeColor', neuron_colors{4})
hold on
histogram(UCmotdist(UCmotdist >= -alphaThreshold & UCmotdist <= alphaThreshold), 'BinEdges', bins, 'FaceColor', neuron_colors{4}, 'FaceAlpha', .2, 'EdgeColor', neuron_colors{4})
xlabel('ρ', 'FontWeight', 'bold')
xticks([-alphaThreshold 0 alphaThreshold])
ylabel('Cell Count', 'FontWeight', 'bold')
nCor = sum(UCmotdist < -alphaThreshold | UCmotdist > alphaThreshold);
title(['nCells = ', num2str(length(UCmotdist)), '; nCor = ', num2str(nCor), ' (', num2str(100*nCor/length(UCmotdist), '%.2f'), '%)'], 'FontWeight', 'bold')
%axis off

subplot(1, 6, 6)
histogram(allmotdist(allmotdist < -alphaThreshold | allmotdist > alphaThreshold), 'BinEdges', bins, 'FaceColor', neuron_colors{4}, 'FaceAlpha', 1, 'EdgeColor', neuron_colors{4})
hold on
histogram(allmotdist(allmotdist >= -alphaThreshold & allmotdist <= alphaThreshold), 'BinEdges', bins, 'FaceColor', neuron_colors{4}, 'FaceAlpha', .2, 'EdgeColor', neuron_colors{4})
xlabel('ρ', 'FontWeight', 'bold')
ylabel('Cell Count', 'FontWeight', 'bold')
xticks([-alphaThreshold 0 alphaThreshold])
nCor = sum(allmotdist < -alphaThreshold | allmotdist > alphaThreshold);
title(['nCells = ', num2str(length(allmotdist)), '; nCor = ', num2str(nCor), ' (', num2str(100*nCor/length(allmotdist), '%.2f'), '%)'], 'FontWeight', 'bold')
%axis off

hold off

distcorr.PVmotdist = PVmotdist;
distcorr.PNmotdist = PNmotdist;
distcorr.UCmotdist = UCmotdist;
distcorr.VIPmotdist = VIPmotdist;
distcorr.SSTmotdist = SSTmotdist;
distcorr.allmotdist = allmotdist;

figure('Position', [680,848,551,130]);
subplot(1, 5, 1)
makeboxplot(PVmotdist, neuron_colors{1})

subplot(1, 5, 2)
makeboxplot(PNmotdist, neuron_colors{2})

subplot(1, 5, 3)
makeboxplot(VIPmotdist, neuron_colors{3})

subplot(1, 5, 4)
makeboxplot(UCmotdist, neuron_colors{4})

subplot(1, 5, 5)
makeboxplot(SSTmotdist, neuron_colors{5})


end

function makeboxplot(variable, color)
    hold on;
    boxplot(variable, 'Notch', 'off', 'Symbol', '', 'Colors', color, 'Whisker', 1, 'BoxStyle', 'outline');
    set(gca, 'XColor', 'none', 'XTick', []);
    box off
    ylim([-0.3 0.3])
    xlim([0.8 1.1])
    ylabel('r')
    set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
    ncells = length(variable(~isnan(variable)));
    getavg = mean(variable, 'omitnan');
    getsem = std(variable, 'omitnan')./sqrt(ncells);

end
