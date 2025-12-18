function visualizeSNR_split(allData, SNR, baselineNoise, nBins, SNR_max, neuron_colors, expression_type, normType)

% visualizeSNR_split(..., normType)
% normType: 'probability' (default) or 'pdf'
if nargin < 8 || isempty(normType); normType = 'probability'; end

nMice = size(allData.data, 2);
nMice = linspace(1, nMice, nMice);

PVdist_SNR = []; PNdist_SNR = []; UCdist_SNR = []; VIPdist_SNR = []; SSTdist_SNR = [];
PVdist_bN  = []; PNdist_bN  = []; UCdist_bN  = []; VIPdist_bN  = []; SSTdist_bN  = [];

is_transgenic_mice = strcmp(expression_type(:, 2), 'transgenic');
transgenic_mice = nMice(is_transgenic_mice);
virus_mice      = nMice(~is_transgenic_mice);

figure('Position', [50,410,1001,440]);

% ---------- helper to accumulate ----------
    function accumulate(idx)
        cellType = allData.data{idx}.cellType;
        SNRtemp  = SNR{idx};
        bNtemp   = baselineNoise{idx};
        nCells   = numel(cellType);
        for jj = 1:nCells
            t = cellType(jj);
            if strcmp(t,'PV')
                PVdist_SNR = [PVdist_SNR, SNRtemp{jj}]; %#ok<AGROW>
                PVdist_bN  = [PVdist_bN,  bNtemp{jj}];  %#ok<AGROW>
            elseif strcmp(t,'PN')
                PNdist_SNR = [PNdist_SNR, SNRtemp{jj}];
                PNdist_bN  = [PNdist_bN,  bNtemp{jj}];
            elseif strcmp(t,'UC')
                UCdist_SNR = [UCdist_SNR, SNRtemp{jj}];
                UCdist_bN  = [UCdist_bN,  bNtemp{jj}];
            elseif strcmp(t,'VIP')
                VIPdist_SNR = [VIPdist_SNR, SNRtemp{jj}];
                VIPdist_bN  = [VIPdist_bN,  bNtemp{jj}];
            elseif strcmp(t,'SST')
                SSTdist_SNR = [SSTdist_SNR, SNRtemp{jj}];
                SSTdist_bN  = [SSTdist_bN,  bNtemp{jj}];
            end
        end
    end

% ---------- accumulate: TRANSGENIC ----------
for i = transgenic_mice
    accumulate(i);
end

alldist_SNR = [PVdist_SNR, PNdist_SNR, VIPdist_SNR, SSTdist_SNR, UCdist_SNR];
alldist_bN  = [PVdist_bN,  PNdist_bN,  VIPdist_bN,  SSTdist_bN,  UCdist_bN];

binsSNR = linspace(0, SNR_max, nBins);
binsbN  = linspace(0, 0.1,    nBins);

% Store histogram handles so we can normalize axes later
hSNR = gobjects(1,6); hbN = gobjects(1,6);

subplot(3, 6, 1)
hSNR(1) = histogram(PVdist_SNR, 'BinEdges', binsSNR, 'Normalization', normType, ...
    'FaceColor', neuron_colors{1}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{1});
xlabel('SNR (% \DeltaF/F)','FontWeight','bold')
ylabel(normTypeLabel(normType),'FontWeight','bold')
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 2)
hSNR(2) = histogram(PNdist_SNR, 'BinEdges', binsSNR, 'Normalization', normType, ...
    'FaceColor', neuron_colors{2}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{2});
xlabel('SNR (% \DeltaF/F)','FontWeight','bold')
ylabel(normTypeLabel(normType),'FontWeight','bold')
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 3)
hSNR(3) = histogram(VIPdist_SNR, 'BinEdges', binsSNR, 'Normalization', normType, ...
    'FaceColor', neuron_colors{3}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{3});
xlabel('SNR (% \DeltaF/F)','FontWeight','bold')
ylabel(normTypeLabel(normType),'FontWeight','bold')
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 4)
hSNR(4) = histogram(SSTdist_SNR, 'BinEdges', binsSNR, 'Normalization', normType, ...
    'FaceColor', neuron_colors{5}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{5});
xlabel('SNR (% \DeltaF/F)','FontWeight','bold')
ylabel(normTypeLabel(normType),'FontWeight','bold')
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 5)
hSNR(5) = histogram(UCdist_SNR, 'BinEdges', binsSNR, 'Normalization', normType, ...
    'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4});
xlabel('SNR (% \DeltaF/F)','FontWeight','bold')
ylabel(normTypeLabel(normType),'FontWeight','bold')
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 6)
hSNR(6) = histogram(alldist_SNR, 'BinEdges', binsSNR, 'Normalization', normType, ...
    'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4});
xlabel('SNR (% \DeltaF/F)','FontWeight','bold')
ylabel(normTypeLabel(normType),'FontWeight','bold')
hold on
set(gca, 'FontSize', 7)

subplot(3, 6, 7)
hbN(1) = histogram(PVdist_bN, 'BinEdges', binsbN, 'Normalization', normType, ...
    'FaceColor', neuron_colors{1}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{1});
xlabel('\sigma (% \DeltaF/F)','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30])
ylabel(normTypeLabel(normType),'FontWeight','bold'); hold on
set(gca, 'FontSize', 7)
xticks([0 0.05 0.1 0.15 0.2 0.25 0.3])
xticklabels([0 5 10 15 20 25 30])

subplot(3, 6, 8)
hbN(2) = histogram(PNdist_bN, 'BinEdges', binsbN, 'Normalization', normType, ...
    'FaceColor', neuron_colors{2}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{2});
xlabel('\sigma (% \DeltaF/F)','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30])
ylabel(normTypeLabel(normType),'FontWeight','bold'); hold on
set(gca, 'FontSize', 7)
xticks([0 0.05 0.1 0.15 0.2 0.25 0.3])
xticklabels([0 5 10 15 20 25 30])

subplot(3, 6, 9)
hbN(3) = histogram(VIPdist_bN, 'BinEdges', binsbN, 'Normalization', normType, ...
    'FaceColor', neuron_colors{3}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{3});
xlabel('\sigma (% \DeltaF/F)','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30])
ylabel(normTypeLabel(normType),'FontWeight','bold'); hold on
set(gca, 'FontSize', 7)
xticks([0 0.05 0.1 0.15 0.2 0.25 0.3])
xticklabels([0 5 10 15 20 25 30])

subplot(3, 6, 10)
hbN(4) = histogram(SSTdist_bN, 'BinEdges', binsbN, 'Normalization', normType, ...
    'FaceColor', neuron_colors{5}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{5});
xlabel('\sigma (% \DeltaF/F)','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30])
ylabel(normTypeLabel(normType),'FontWeight','bold'); hold on
set(gca, 'FontSize', 7)
xticks([0 0.05 0.1 0.15 0.2 0.25 0.3])
xticklabels([0 5 10 15 20 25 30])

subplot(3, 6, 11)
hbN(5) = histogram(UCdist_bN, 'BinEdges', binsbN, 'Normalization', normType, ...
    'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4});
xlabel('\sigma (% \DeltaF/F)','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30])
ylabel(normTypeLabel(normType),'FontWeight','bold'); hold on
set(gca, 'FontSize', 7)
xticks([0 0.05 0.1 0.15 0.2 0.25 0.3])
xticklabels([0 5 10 15 20 25 30])

subplot(3, 6, 12)
hbN(6) = histogram(alldist_bN, 'BinEdges', binsbN, 'Normalization', normType, ...
    'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4});
xlabel('\sigma (% \DeltaF/F)','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30])
ylabel(normTypeLabel(normType),'FontWeight','bold'); hold on
set(gca, 'FontSize', 7)
xticks([0 0.05 0.1 0.15 0.2 0.25 0.3])
xticklabels([0 5 10 15 20 25 30])

% Scatter panels (unchanged y meaning; SNR on Y)
subplot(3, 6, 13)
scatter(PVdist_bN, PVdist_SNR, 'MarkerFaceColor', neuron_colors{1}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('\sigma','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30]); ylabel('SNR','FontWeight','bold'); hold on
set(gca, 'FontSize', 7)
subplot(3, 6, 14)
scatter(PNdist_bN, PNdist_SNR, 'MarkerFaceColor', neuron_colors{2}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('\sigma','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30]); ylabel('SNR','FontWeight','bold'); hold on
set(gca, 'FontSize', 7)
subplot(3, 6, 15)
scatter(VIPdist_bN, VIPdist_SNR, 'MarkerFaceColor', neuron_colors{3}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('\sigma','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30]); ylabel('SNR','FontWeight','bold'); hold on
set(gca, 'FontSize', 7)
subplot(3, 6, 16)
scatter(SSTdist_bN, SSTdist_SNR, 'MarkerFaceColor', neuron_colors{5}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('\sigma','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30]); ylabel('SNR','FontWeight','bold'); hold on
set(gca, 'FontSize', 7)
subplot(3, 6, 17)
scatter(UCdist_bN, UCdist_SNR, 'MarkerFaceColor', neuron_colors{4}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('\sigma','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30]); ylabel('SNR','FontWeight','bold'); hold on
set(gca, 'FontSize', 7)
subplot(3, 6, 18)
scatter(alldist_bN, alldist_SNR, 'MarkerFaceColor', neuron_colors{4}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('\sigma','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30]); ylabel('SNR','FontWeight','bold'); hold on
set(gca, 'FontSize', 7)

% ---------- accumulate: VIRUS (adds in-place if you still overlay later) ----------
for i = virus_mice
    accumulate(i);
end

% NOTE:
% Your existing code re-plots into the SAME subplots (1..18) after adding virus data,
% which overlays a second set of histograms on top of the first. With 'Normalization'
% set, the y-axes are directly comparable across conditions.

% ---- Re-plot the overlaid (virus+transgenic) histograms using the same settings ----
% SNR
subplot(3,6,1); histogram(PVdist_SNR, 'BinEdges', binsSNR, 'Normalization', normType, ...
    'FaceColor', neuron_colors{1}, 'FaceAlpha', 0.20, 'EdgeColor', neuron_colors{1});
subplot(3,6,2); histogram(PNdist_SNR, 'BinEdges', binsSNR, 'Normalization', normType, ...
    'FaceColor', neuron_colors{2}, 'FaceAlpha', 0.20, 'EdgeColor', neuron_colors{2});
subplot(3,6,3); histogram(VIPdist_SNR, 'BinEdges', binsSNR, 'Normalization', normType, ...
    'FaceColor', neuron_colors{3}, 'FaceAlpha', 0.20, 'EdgeColor', neuron_colors{3});
subplot(3,6,4); histogram(SSTdist_SNR, 'BinEdges', binsSNR, 'Normalization', normType, ...
    'FaceColor', neuron_colors{5}, 'FaceAlpha', 0.20, 'EdgeColor', neuron_colors{5});
subplot(3,6,5); histogram(UCdist_SNR, 'BinEdges', binsSNR, 'Normalization', normType, ...
    'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.20, 'EdgeColor', neuron_colors{4});
alldist_SNR = [PVdist_SNR, PNdist_SNR, VIPdist_SNR, SSTdist_SNR, UCdist_SNR];
subplot(3,6,6); histogram(alldist_SNR, 'BinEdges', binsSNR, 'Normalization', normType, ...
    'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.20, 'EdgeColor', neuron_colors{4});

% bN
subplot(3,6,7);  histogram(PVdist_bN, 'BinEdges', binsbN, 'Normalization', normType, ...
    'FaceColor', neuron_colors{1}, 'FaceAlpha', 0.20, 'EdgeColor', neuron_colors{1});
subplot(3,6,8);  histogram(PNdist_bN, 'BinEdges', binsbN, 'Normalization', normType, ...
    'FaceColor', neuron_colors{2}, 'FaceAlpha', 0.20, 'EdgeColor', neuron_colors{2});
subplot(3,6,9);  histogram(VIPdist_bN, 'BinEdges', binsbN, 'Normalization', normType, ...
    'FaceColor', neuron_colors{3}, 'FaceAlpha', 0.20, 'EdgeColor', neuron_colors{3});
subplot(3,6,10); histogram(SSTdist_bN, 'BinEdges', binsbN, 'Normalization', normType, ...
    'FaceColor', neuron_colors{5}, 'FaceAlpha', 0.20, 'EdgeColor', neuron_colors{5});
subplot(3,6,11); histogram(UCdist_bN, 'BinEdges', binsbN, 'Normalization', normType, ...
    'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.20, 'EdgeColor', neuron_colors{4});
alldist_bN = [PVdist_bN, PNdist_bN, VIPdist_bN, SSTdist_bN, UCdist_bN];
subplot(3,6,12); histogram(alldist_bN, 'BinEdges', binsbN, 'Normalization', normType, ...
    'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.20, 'EdgeColor', neuron_colors{4});

% ---------- enforce common y-limits across HISTOGRAMS ONLY ----------
allHists = findall(gcf, 'Type', 'Histogram');
isSNRhist = arrayfun(@(h) isequal(h.BinEdges, binsSNR), allHists);
isbNhist  = arrayfun(@(h) isequal(h.BinEdges, binsbN),  allHists);

yMaxSNR = max(arrayfun(@(h) max(h.Values), allHists(isSNRhist)));
yMaxbN  = max(arrayfun(@(h) max(h.Values), allHists(isbNhist)));

allAxes = findall(gcf, 'Type', 'axes');
for ax = reshape(allAxes,1,[])
    h = findobj(ax, 'Type', 'Histogram');
    if isempty(h); continue; end
    if any(arrayfun(@(hh) isequal(hh.BinEdges, binsSNR), h))
        ylim(ax, [0, yMaxSNR]);
    elseif any(arrayfun(@(hh) isequal(hh.BinEdges, binsbN), h))
        ylim(ax, [0, yMaxbN]);
    end
end

end % main function

% ---------- helper label ----------
function ylab = normTypeLabel(normType)
switch lower(normType)
    case 'probability'
        ylab = 'Fraction of cells';
    case 'pdf'
        ylab = 'Density';
    otherwise
        ylab = 'Normalized';
end
end


% function visualizeSNR_split(allData, SNR, baselineNoise, nBins, SNR_max, neuron_colors, expression_type)
% 
% nMice = size(allData.data, 2);
% nMice = linspace(1, nMice, nMice);
% 
% PVdist_SNR = [];
% PNdist_SNR = [];
% UCdist_SNR = [];
% VIPdist_SNR = [];
% SSTdist_SNR = [];
% 
% PVdist_bN = [];
% PNdist_bN = [];
% UCdist_bN = [];
% VIPdist_bN = [];
% SSTdist_bN = [];
% 
% is_transgenic_mice = strcmp(expression_type(:, 2), 'transgenic');
% transgenic_mice = nMice(is_transgenic_mice);
% virus_mice = nMice(~is_transgenic_mice);
% 
% figure('Position', [50 50 1600 800]);
% for i = transgenic_mice
%     cellType = allData.data{i}.cellType;
%     SNRtemp = SNR{i};
%     bNtemp = baselineNoise{i};
% 
%     nCells = length(cellType);
% 
%     for j = 1:nCells
%         if strcmp(cellType(j), 'PV')
%             PVdist_SNR = [PVdist_SNR, SNRtemp{j}];
%             PVdist_bN = [PVdist_bN, bNtemp{j}];
%         elseif strcmp(cellType(j), 'PN')
%             PNdist_SNR = [PNdist_SNR, SNRtemp{j}];
%             PNdist_bN = [PNdist_bN, bNtemp{j}];
%         elseif strcmp(cellType(j), 'UC')
%             UCdist_SNR = [UCdist_SNR, SNRtemp{j}];
%             UCdist_bN = [UCdist_bN, bNtemp{j}];
%         elseif strcmp(cellType(j), 'VIP')
%             VIPdist_SNR = [VIPdist_SNR, SNRtemp{j}];
%             VIPdist_bN = [VIPdist_bN, bNtemp{j}];
%         elseif strcmp(cellType(j), 'SST')
%             SSTdist_SNR = [SSTdist_SNR, SNRtemp{j}];
%             SSTdist_bN = [SSTdist_bN, bNtemp{j}];
%         end
%     end
% end
% 
% alldist_SNR = [PVdist_SNR, PNdist_SNR, VIPdist_SNR, SSTdist_SNR, UCdist_SNR];
% alldist_bN = [PVdist_bN, PNdist_bN, VIPdist_bN, SSTdist_bN, UCdist_bN];
% 
% binsSNR = linspace(0, SNR_max, nBins);
% binsbN = linspace(0, .2, nBins);
% 
% subplot(3, 6, 1)
% histogram(PVdist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{1}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{1})
% xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
% ylabel('Cell Count', 'FontWeight', 'bold')
% title(['n PV = ', num2str(length(PVdist_SNR)), '; mean = ', num2str(mean(PVdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 2)
% histogram(PNdist_SNR, 'BinEdges', binsSNR, 'FaceColor',neuron_colors{2}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{2})
% xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
% ylabel('Cell Count', 'FontWeight', 'bold')
% title(['n PN = ', num2str(length(PNdist_SNR)), '; mean = ', num2str(mean(PNdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 3)
% histogram(VIPdist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{3}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{3})
% xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
% ylabel('Cell Count', 'FontWeight', 'bold')
% title(['n VIP = ', num2str(length(VIPdist_SNR)), '; mean = ', num2str(mean(VIPdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 4)
% histogram(SSTdist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{5}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{5})
% xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
% ylabel('Cell Count', 'FontWeight', 'bold')
% title(['n SST = ', num2str(length(SSTdist_SNR)), '; mean = ', num2str(mean(SSTdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 5)
% histogram(UCdist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
% xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
% ylabel('Cell Count', 'FontWeight', 'bold')
% title(['n Unclass. = ', num2str(length(UCdist_SNR)), '; mean = ', num2str(mean(UCdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 6)
% histogram(alldist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
% xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
% ylabel('Cell Count', 'FontWeight', 'bold')
% title(['nCells = ', num2str(length(alldist_SNR)), '; mean = ', num2str(mean(alldist_SNR, 'omitnan'))], 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 7)
% histogram(PVdist_bN, 'BinEdges', binsbN, 'FaceColor', neuron_colors{1}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{1})
% xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('Cell Count', 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 8)
% histogram(PNdist_bN, 'BinEdges', binsbN, 'FaceColor',neuron_colors{2}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{2})
% xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('Cell Count', 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 9)
% histogram(VIPdist_bN, 'BinEdges', binsbN, 'FaceColor', neuron_colors{3}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{3})
% xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('Cell Count', 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 10)
% histogram(SSTdist_bN, 'BinEdges', binsbN, 'FaceColor', neuron_colors{5}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{5})
% xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('Cell Count', 'FontWeight', 'bold')
% hold on
% 
% subplot(3, 6, 11)
% histogram(UCdist_bN, 'BinEdges', binsbN, 'FaceColor',neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
% xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('Cell Count', 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 12)
% histogram(alldist_bN, 'BinEdges', binsbN, 'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
% xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('Cell Count', 'FontWeight', 'bold')
% hold on
% 
% subplot(3, 6, 13)
% scatter(PVdist_bN, PVdist_SNR, 'MarkerFaceColor', neuron_colors{1}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
% xlabel('σ', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('SNR', 'FontWeight', 'bold')
% %xlim([0 0.3])
% %ylim([0 20])
% hold on
% 
% subplot(3, 6, 14)
% scatter(PNdist_bN, PNdist_SNR, 'MarkerFaceColor', neuron_colors{2}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
% xlabel('σ', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('SNR', 'FontWeight', 'bold')
% %xlim([0 0.3])
% %ylim([0 20])
% hold on
% 
% subplot(3, 6, 15)
% scatter(VIPdist_bN, VIPdist_SNR, 'MarkerFaceColor', neuron_colors{3}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
% xlabel('σ', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('SNR', 'FontWeight', 'bold')
% %xlim([0 0.3])
% %ylim([0 20])
% hold on
% 
% subplot(3, 6, 16)
% scatter(SSTdist_bN, SSTdist_SNR, 'MarkerFaceColor', neuron_colors{5}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
% xlabel('σ', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('SNR', 'FontWeight', 'bold')
% %xlim([0 0.3])
% %ylim([0 20])
% hold on
% 
% subplot(3, 6, 17)
% scatter(UCdist_bN, UCdist_SNR, 'MarkerFaceColor', neuron_colors{4}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
% xlabel('σ', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('SNR', 'FontWeight', 'bold')
% %xlim([0 0.3])
% %ylim([0 20])
% hold on
% 
% subplot(3, 6, 18)
% scatter(alldist_bN, alldist_SNR, 'MarkerFaceColor', neuron_colors{4}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
% xlabel('σ', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('SNR', 'FontWeight', 'bold')
% %xlim([0 0.3])
% %ylim([0 20])
% hold on
% 
% for i = virus_mice
%     cellType = allData.data{i}.cellType;
%     SNRtemp = SNR{i};
%     bNtemp = baselineNoise{i};
% 
%     nCells = length(cellType);
% 
%     for j = 1:nCells
%         if strcmp(cellType(j), 'PV')
%             PVdist_SNR = [PVdist_SNR, SNRtemp{j}];
%             PVdist_bN = [PVdist_bN, bNtemp{j}];
%         elseif strcmp(cellType(j), 'PN')
%             PNdist_SNR = [PNdist_SNR, SNRtemp{j}];
%             PNdist_bN = [PNdist_bN, bNtemp{j}];
%         elseif strcmp(cellType(j), 'UC')
%             UCdist_SNR = [UCdist_SNR, SNRtemp{j}];
%             UCdist_bN = [UCdist_bN, bNtemp{j}];
%         elseif strcmp(cellType(j), 'VIP')
%             VIPdist_SNR = [VIPdist_SNR, SNRtemp{j}];
%             VIPdist_bN = [VIPdist_bN, bNtemp{j}];
%         elseif strcmp(cellType(j), 'SST')
%             SSTdist_SNR = [SSTdist_SNR, SNRtemp{j}];
%             SSTdist_bN = [SSTdist_bN, bNtemp{j}];
%         end
%     end
% end
% 
% alldist_SNR = [PVdist_SNR, PNdist_SNR, VIPdist_SNR, SSTdist_SNR, UCdist_SNR];
% alldist_bN = [PVdist_bN, PNdist_bN, VIPdist_bN, SSTdist_bN, UCdist_bN];
% 
% binsSNR = linspace(0, SNR_max, nBins);
% binsbN = linspace(0, .2, nBins);
% 
% subplot(3, 6, 1)
% histogram(PVdist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{1}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{1})
% xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
% ylabel('Cell Count', 'FontWeight', 'bold')
% title(['n PV = ', num2str(length(PVdist_SNR)), '; mean = ', num2str(mean(PVdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 2)
% histogram(PNdist_SNR, 'BinEdges', binsSNR, 'FaceColor',neuron_colors{2}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{2})
% xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
% ylabel('Cell Count', 'FontWeight', 'bold')
% title(['n PN = ', num2str(length(PNdist_SNR)), '; mean = ', num2str(mean(PNdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 3)
% histogram(VIPdist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{3}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{3})
% xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
% ylabel('Cell Count', 'FontWeight', 'bold')
% title(['n VIP = ', num2str(length(VIPdist_SNR)), '; mean = ', num2str(mean(VIPdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 4)
% histogram(SSTdist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{5}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{5})
% xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
% ylabel('Cell Count', 'FontWeight', 'bold')
% title(['n SST = ', num2str(length(SSTdist_SNR)), '; mean = ', num2str(mean(SSTdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 5)
% histogram(UCdist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
% xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
% ylabel('Cell Count', 'FontWeight', 'bold')
% title(['n Unclass. = ', num2str(length(UCdist_SNR)), '; mean = ', num2str(mean(UCdist_SNR, 'omitnan'))], 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 6)
% histogram(alldist_SNR, 'BinEdges', binsSNR, 'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
% xlabel('SNR (% ΔF/F)', 'FontWeight', 'bold')
% ylabel('Cell Count', 'FontWeight', 'bold')
% title(['nCells = ', num2str(length(alldist_SNR)), '; mean = ', num2str(mean(alldist_SNR, 'omitnan'))], 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 7)
% histogram(PVdist_bN, 'BinEdges', binsbN, 'FaceColor', neuron_colors{1}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{1})
% xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('Cell Count', 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 8)
% histogram(PNdist_bN, 'BinEdges', binsbN, 'FaceColor',neuron_colors{2}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{2})
% xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('Cell Count', 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 9)
% histogram(VIPdist_bN, 'BinEdges', binsbN, 'FaceColor', neuron_colors{3}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{3})
% xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('Cell Count', 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 10)
% histogram(SSTdist_bN, 'BinEdges', binsbN, 'FaceColor', neuron_colors{5}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{5})
% xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('Cell Count', 'FontWeight', 'bold')
% hold on
% 
% subplot(3, 6, 11)
% histogram(UCdist_bN, 'BinEdges', binsbN, 'FaceColor',neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
% xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('Cell Count', 'FontWeight', 'bold')
% hold on
% %axis off
% 
% subplot(3, 6, 12)
% histogram(alldist_bN, 'BinEdges', binsbN, 'FaceColor', neuron_colors{4}, 'FaceAlpha', 0.5, 'EdgeColor', neuron_colors{4})
% xlabel('σ (% ΔF/F)', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('Cell Count', 'FontWeight', 'bold')
% hold on
% 
% subplot(3, 6, 13)
% scatter(PVdist_bN, PVdist_SNR, 'MarkerFaceColor', neuron_colors{1}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
% xlabel('σ', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('SNR', 'FontWeight', 'bold')
% %xlim([0 0.3])
% %ylim([0 20])
% hold on
% 
% subplot(3, 6, 14)
% scatter(PNdist_bN, PNdist_SNR, 'MarkerFaceColor', neuron_colors{2}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
% xlabel('σ', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('SNR', 'FontWeight', 'bold')
% %xlim([0 0.3])
% %ylim([0 20])
% hold on
% 
% subplot(3, 6, 15)
% scatter(VIPdist_bN, VIPdist_SNR, 'MarkerFaceColor', neuron_colors{3}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
% xlabel('σ', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('SNR', 'FontWeight', 'bold')
% %xlim([0 0.3])
% %ylim([0 20])
% hold on
% 
% subplot(3, 6, 16)
% scatter(SSTdist_bN, SSTdist_SNR, 'MarkerFaceColor', neuron_colors{5}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
% xlabel('σ', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('SNR', 'FontWeight', 'bold')
% %xlim([0 0.3])
% %ylim([0 20])
% hold on
% 
% subplot(3, 6, 17)
% scatter(UCdist_bN, UCdist_SNR, 'MarkerFaceColor', neuron_colors{4}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
% xlabel('σ', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('SNR', 'FontWeight', 'bold')
% %xlim([0 0.3])
% %ylim([0 20])
% hold on
% 
% subplot(3, 6, 18)
% scatter(alldist_bN, alldist_SNR, 'MarkerFaceColor', neuron_colors{4}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
% xlabel('σ', 'FontWeight', 'bold')
% xticks([0 0.1 0.2 0.3])
% xticklabels([0 10 20 30])
% ylabel('SNR', 'FontWeight', 'bold')
% %xlim([0 0.3])
% %ylim([0 20])
% hold on
% 
% end
% 
% 
