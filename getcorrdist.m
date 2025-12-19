function [distcorr] = visualizemotioncorrelation(allData, alphaThreshold, nBins, mottype, usetype)

nMice = size(allData.data, 2);

PVmotdist = [];
PNmotdist = [];
UCmotdist = [];
VIPmotdist = [];
SSTmotdist = [];

for i = 1:nMice
    cellType = allData.data{i}.cellType;

    if strcmp(mottype, 'correlation')
        if strcmp(usetype, 'all')
            cellmot = allData.data{i}.cellxmot;
        elseif strcmp(usetype, 'PRE')
            cellmot = allData.data{i}.cellxmot_pre;
        elseif strcmp(usetype, 'POST')
            cellmot = allData.data{i}.cellxmot_post;
        end
    elseif strcmp(mottype, 'modidx')
        cellmot = allData.data{i}.modulationidx;
    end

    nCells = length(cellType);

    for j = 1:nCells
        if strcmp(cellType(j), 'PV')
            PVmotdist = [PVmotdist, cellmot(j)];
        elseif strcmp(cellType(j), 'PN')
            PNmotdist = [PNmotdist, cellmot(j)];
        elseif strcmp(cellType(j), 'UC')
            UCmotdist = [UCmotdist, cellmot(j)];
        elseif strcmp(cellType(j), 'VIP')
            VIPmotdist = [VIPmotdist, cellmot(j)];
        elseif strcmp(cellType(j), 'SST')
            SSTmotdist = [SSTmotdist, cellmot(j)];
        end
    end
end

allmotdist = [PVmotdist, PNmotdist, UCmotdist, VIPmotdist, SSTmotdist];

if strcmp(mottype, 'correlation')
    bins = linspace(-.3, .3, nBins);
elseif strcmp(mottype, 'modidx')
    bins = linspace(-5, 5, nBins);
end

figure('position', [81,334,1546,420]);
subplot(1, 6, 1)
histogram(PVmotdist(PVmotdist < -alphaThreshold | PVmotdist > alphaThreshold), 'BinEdges', bins, 'FaceColor', '#bb2525', 'FaceAlpha', 1, 'EdgeColor', '#bb2525')
hold on
histogram(PVmotdist(PVmotdist >= -alphaThreshold & PVmotdist <= alphaThreshold), 'BinEdges', bins, 'FaceColor', '#bb2525', 'FaceAlpha', .2, 'EdgeColor', '#bb2525')
xlabel('ρ', 'FontWeight', 'bold')
xticks([-alphaThreshold 0 alphaThreshold])
ylabel('Cell Count', 'FontWeight', 'bold')
nCor = sum(PVmotdist < -alphaThreshold | PVmotdist > alphaThreshold);
title(['nCells = ', num2str(length(PVmotdist)), '; nCor = ', num2str(nCor), ' (', num2str(100*nCor/length(PVmotdist), '%.2f'), '%)'], 'FontWeight', 'bold')
%axis off

subplot(1, 6, 2)
histogram(PNmotdist(PNmotdist < -alphaThreshold | PNmotdist > alphaThreshold), 'BinEdges', bins, 'FaceColor','#224baa', 'FaceAlpha', 1, 'EdgeColor', '#224baa')
hold on
histogram(PNmotdist(PNmotdist >= -alphaThreshold & PNmotdist <= alphaThreshold), 'BinEdges', bins, 'FaceColor','#224baa', 'FaceAlpha', .2, 'EdgeColor', '#224baa')
xlabel('ρ', 'FontWeight', 'bold')
xticks([-alphaThreshold 0 alphaThreshold])
ylabel('Cell Count', 'FontWeight', 'bold')
nCor = sum(PNmotdist < -alphaThreshold | PNmotdist > alphaThreshold);
title(['nCells = ', num2str(length(PNmotdist)), '; nPos = ', num2str(nCor), ' (', num2str(100*nCor/length(PNmotdist), '%.2f'), '%)'], 'FontWeight', 'bold')
%axis off

subplot(1, 6, 3)
histogram(VIPmotdist(VIPmotdist < -alphaThreshold | VIPmotdist > alphaThreshold), 'BinEdges', bins, 'FaceColor', '#0a8a23', 'FaceAlpha', 1, 'EdgeColor', '#0a8a23')
hold on
histogram(VIPmotdist(VIPmotdist >= -alphaThreshold & VIPmotdist <= alphaThreshold), 'BinEdges', bins, 'FaceColor', '#0a8a23', 'FaceAlpha', .2, 'EdgeColor', '#0a8a23')
xlabel('ρ', 'FontWeight', 'bold')
xticks([-alphaThreshold 0 alphaThreshold])
ylabel('Cell Count', 'FontWeight', 'bold')
nCor = sum(VIPmotdist < -alphaThreshold | VIPmotdist > alphaThreshold);
title(['nCells = ', num2str(length(VIPmotdist)), '; nPos = ', num2str(nCor), ' (', num2str(100*nCor/length(VIPmotdist), '%.2f'), '%)'], 'FontWeight', 'bold')
%axis off

subplot(1, 6, 4)
histogram(SSTmotdist(SSTmotdist < -alphaThreshold | SSTmotdist > alphaThreshold), 'BinEdges', bins, 'FaceColor', '#633f73', 'FaceAlpha', 1, 'EdgeColor', '#633f73')
hold on
histogram(SSTmotdist(SSTmotdist >= -alphaThreshold & SSTmotdist <= alphaThreshold), 'BinEdges', bins, 'FaceColor', '#633f73', 'FaceAlpha', .2, 'EdgeColor', '#633f73')
xlabel('ρ', 'FontWeight', 'bold')
xticks([-alphaThreshold 0 alphaThreshold])
ylabel('Cell Count', 'FontWeight', 'bold')
nCor = sum(SSTmotdist < -alphaThreshold | SSTmotdist > alphaThreshold);
title(['nCells = ', num2str(length(SSTmotdist)), '; nCor = ', num2str(nCor), ' (', num2str(100*nCor/length(SSTmotdist), '%.2f'), '%)'], 'FontWeight', 'bold')
%axis off

subplot(1, 6, 5)
histogram(UCmotdist(UCmotdist < -alphaThreshold | UCmotdist > alphaThreshold), 'BinEdges', bins, 'FaceColor', 'k', 'FaceAlpha', 1, 'EdgeColor', 'k')
hold on
histogram(UCmotdist(UCmotdist >= -alphaThreshold & UCmotdist <= alphaThreshold), 'BinEdges', bins, 'FaceColor', 'k', 'FaceAlpha', .2, 'EdgeColor', 'k')
xlabel('ρ', 'FontWeight', 'bold')
xticks([-alphaThreshold 0 alphaThreshold])
ylabel('Cell Count', 'FontWeight', 'bold')
nCor = sum(UCmotdist < -alphaThreshold | UCmotdist > alphaThreshold);
title(['nCells = ', num2str(length(UCmotdist)), '; nPos = ', num2str(nCor), ' (', num2str(100*nCor/length(UCmotdist), '%.2f'), '%)'], 'FontWeight', 'bold')
%axis off

subplot(1, 6, 6)
histogram(allmotdist(allmotdist < -alphaThreshold | allmotdist > alphaThreshold), 'BinEdges', bins, 'FaceColor', 'k', 'FaceAlpha', 1, 'EdgeColor', 'k')
hold on
histogram(allmotdist(allmotdist >= -alphaThreshold & allmotdist <= alphaThreshold), 'BinEdges', bins, 'FaceColor', 'k', 'FaceAlpha', .2, 'EdgeColor', 'k')
xlabel('ρ', 'FontWeight', 'bold')
ylabel('Cell Count', 'FontWeight', 'bold')
xticks([-alphaThreshold 0 alphaThreshold])
nCor = sum(allmotdist < -alphaThreshold | allmotdist > alphaThreshold);
title(['nCells = ', num2str(length(allmotdist)), '; nPos = ', num2str(nCor), ' (', num2str(100*nCor/length(allmotdist), '%.2f'), '%)'], 'FontWeight', 'bold')
%axis off

hold off

distcorr.PVmotdist = PVmotdist;
distcorr.PNmotdist = PNmotdist;
distcorr.UCmotdist = UCmotdist;
distcorr.VIPmotdist = VIPmotdist;
distcorr.allmotdist = allmotdist;

end
