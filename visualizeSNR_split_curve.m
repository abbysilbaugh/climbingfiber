function visualizeSNR_split_curve(allData, SNR, baselineNoise, ~, SNR_max, neuron_colors, expression_type, normType)
% visualizeSNR_split(..., ~, SNR_max, ...)  % nBins is ignored on purpose
% Now uses KDE fits that do NOT depend on the specified number of bins.
% normType only affects the y-axis label text.

if nargin < 8 || isempty(normType); normType = 'probability'; end

nMice = size(allData.data, 2);
nMice = linspace(1, nMice, nMice);

PVdist_SNR = []; PNdist_SNR = []; UCdist_SNR = []; VIPdist_SNR = []; SSTdist_SNR = [];
PVdist_bN  = []; PNdist_bN  = []; UCdist_bN  = []; VIPdist_bN  = []; SSTdist_bN  = [];

is_transgenic_mice = strcmp(expression_type(:, 2), 'transgenic');
transgenic_mice = nMice(is_transgenic_mice);
virus_mice      = nMice(~is_transgenic_mice);

figure('Position', [50 50 1600 800]);

% ---------- helpers ----------
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

    % Let ksdensity pick its own adaptive grid (no dependency on nBins)
    function [xi, f] = kde_auto(data, support_hi)
        data = data(~isnan(data));
        if isempty(data)
            xi = [0 support_hi]; f = [NaN NaN];
            return
        end
        try
            [f, xi] = ksdensity(data, 'Support', [0 support_hi]);
        catch
            [f, xi] = ksdensity(data);
            xi(xi < 0) = []; f = f(numel(f)-numel(xi)+1:end); % keep nonnegative tail if needed
        end
    end

    function plotCurve(ax, xi, f, col, lw, ls)
        axes(ax); %#ok<LAXES>
        hold(ax, 'on');
        if all(isnan(f)), return; end
        plot(ax, xi, f, 'Color', col, 'LineWidth', lw, 'LineStyle', ls);
    end

    function setXYlabels(ax, xlab, normType)
        xlabel(ax, xlab, 'FontWeight', 'bold');
        ylabel(ax, normTypeLabel(normType), 'FontWeight', 'bold');
    end

% ---------- accumulate: TRANSGENIC ----------
for i = transgenic_mice
    accumulate(i);
end

alldist_SNR = [PVdist_SNR, PNdist_SNR, VIPdist_SNR, SSTdist_SNR, UCdist_SNR];
alldist_bN  = [PVdist_bN,  PNdist_bN,  VIPdist_bN,  SSTdist_bN,  UCdist_bN];

% Precompute KDEs for TRANSGENIC (adaptive grids; no nBins)
[xPV_SNR, fPV_SNR]     = kde_auto(PVdist_SNR,  SNR_max);
[xPN_SNR, fPN_SNR]     = kde_auto(PNdist_SNR,  SNR_max);
[xVIP_SNR, fVIP_SNR]   = kde_auto(VIPdist_SNR, SNR_max);
[xSST_SNR, fSST_SNR]   = kde_auto(SSTdist_SNR, SNR_max);
[xUC_SNR, fUC_SNR]     = kde_auto(UCdist_SNR,  SNR_max);
[xALL_SNR, fALL_SNR]   = kde_auto(alldist_SNR, SNR_max);

[xPV_bN, fPV_bN]       = kde_auto(PVdist_bN,   0.2);
[xPN_bN, fPN_bN]       = kde_auto(PNdist_bN,   0.2);
[xVIP_bN, fVIP_bN]     = kde_auto(VIPdist_bN,  0.2);
[xSST_bN, fSST_bN]     = kde_auto(SSTdist_bN,  0.2);
[xUC_bN, fUC_bN]       = kde_auto(UCdist_bN,   0.2);
[xALL_bN, fALL_bN]     = kde_auto(alldist_bN,  0.2);

% ---- Axes grid ----
ax = gobjects(3,6);
for r = 1:3
    for c = 1:6
        ax(r,c) = subplot(3,6,(r-1)*6+c);
    end
end

% ---- Plot TRANSGENIC KDE curves (solid) ----
plotCurve(ax(1,1), xPV_SNR,  fPV_SNR,  neuron_colors{1}, 1, '-');
setXYlabels(ax(1,1), 'SNR (% \DeltaF/F)', normType);
title(ax(1,1), sprintf('n PV = %d; mean = %.3g', numel(PVdist_SNR), mean(PVdist_SNR,'omitnan')), 'FontWeight','bold');

plotCurve(ax(1,2), xPN_SNR,  fPN_SNR,  neuron_colors{2}, 1, '-');
setXYlabels(ax(1,2), 'SNR (% \DeltaF/F)', normType);
title(ax(1,2), sprintf('n PN = %d; mean = %.3g', numel(PNdist_SNR), mean(PNdist_SNR,'omitnan')), 'FontWeight','bold');

plotCurve(ax(1,3), xVIP_SNR, fVIP_SNR, neuron_colors{3}, 1, '-');
setXYlabels(ax(1,3), 'SNR (% \DeltaF/F)', normType);
title(ax(1,3), sprintf('n VIP = %d; mean = %.3g', numel(VIPdist_SNR), mean(VIPdist_SNR,'omitnan')), 'FontWeight','bold');

plotCurve(ax(1,4), xSST_SNR, fSST_SNR, neuron_colors{5}, 1, '-');
setXYlabels(ax(1,4), 'SNR (% \DeltaF/F)', normType);
title(ax(1,4), sprintf('n SST = %d; mean = %.3g', numel(SSTdist_SNR), mean(SSTdist_SNR,'omitnan')), 'FontWeight','bold');

plotCurve(ax(1,5), xUC_SNR,  fUC_SNR,  neuron_colors{4}, 1, '-');
setXYlabels(ax(1,5), 'SNR (% \DeltaF/F)', normType);
title(ax(1,5), sprintf('n Unclass. = %d; mean = %.3g', numel(UCdist_SNR), mean(UCdist_SNR,'omitnan')), 'FontWeight','bold');

plotCurve(ax(1,6), xALL_SNR, fALL_SNR, neuron_colors{4}, 1, '-');
setXYlabels(ax(1,6), 'SNR (% \DeltaF/F)', normType);
title(ax(1,6), sprintf('nCells = %d; mean = %.3g', numel(alldist_SNR), mean(alldist_SNR,'omitnan')), 'FontWeight','bold');

plotCurve(ax(2,1), xPV_bN,   fPV_bN,   neuron_colors{1}, 1, '-'); setXYlabels(ax(2,1), '\sigma (% \DeltaF/F)', normType); xticks(ax(2,1), [0 0.1 0.2 0.3]); xticklabels(ax(2,1), [0 10 20 30]);
plotCurve(ax(2,2), xPN_bN,   fPN_bN,   neuron_colors{2}, 1, '-'); setXYlabels(ax(2,2), '\sigma (% \DeltaF/F)', normType); xticks(ax(2,2), [0 0.1 0.2 0.3]); xticklabels(ax(2,2), [0 10 20 30]);
plotCurve(ax(2,3), xVIP_bN,  fVIP_bN,  neuron_colors{3}, 1, '-'); setXYlabels(ax(2,3), '\sigma (% \DeltaF/F)', normType); xticks(ax(2,3), [0 0.1 0.2 0.3]); xticklabels(ax(2,3), [0 10 20 30]);
plotCurve(ax(2,4), xSST_bN,  fSST_bN,  neuron_colors{5}, 1, '-'); setXYlabels(ax(2,4), '\sigma (% \DeltaF/F)', normType); xticks(ax(2,4), [0 0.1 0.2 0.3]); xticklabels(ax(2,4), [0 10 20 30]);
plotCurve(ax(2,5), xUC_bN,   fUC_bN,   neuron_colors{4}, 1, '-'); setXYlabels(ax(2,5), '\sigma (% \DeltaF/F)', normType); xticks(ax(2,5), [0 0.1 0.2 0.3]); xticklabels(ax(2,5), [0 10 20 30]);
plotCurve(ax(2,6), xALL_bN,  fALL_bN,  neuron_colors{4}, 1, '-'); setXYlabels(ax(2,6), '\sigma (% \DeltaF/F)', normType); xticks(ax(2,6), [0 0.1 0.2 0.3]); xticklabels(ax(2,6), [0 10 20 30]);

% ---------- Scatter panels (unchanged) ----------
subplot(3, 6, 13)
scatter(PVdist_bN, PVdist_SNR, 'MarkerFaceColor', neuron_colors{1}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('\sigma','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30]); ylabel('SNR','FontWeight','bold'); hold on
subplot(3, 6, 14)
scatter(PNdist_bN, PNdist_SNR, 'MarkerFaceColor', neuron_colors{2}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('\sigma','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30]); ylabel('SNR','FontWeight','bold'); hold on
subplot(3, 6, 15)
scatter(VIPdist_bN, VIPdist_SNR, 'MarkerFaceColor', neuron_colors{3}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('\sigma','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30]); ylabel('SNR','FontWeight','bold'); hold on
subplot(3, 6, 16)
scatter(SSTdist_bN, SSTdist_SNR, 'MarkerFaceColor', neuron_colors{5}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('\sigma','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30]); ylabel('SNR','FontWeight','bold'); hold on
subplot(3, 6, 17)
scatter(UCdist_bN, UCdist_SNR, 'MarkerFaceColor', neuron_colors{4}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('\sigma','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30]); ylabel('SNR','FontWeight','bold'); hold on
subplot(3, 6, 18)
scatter(alldist_bN, alldist_SNR, 'MarkerFaceColor', neuron_colors{4}, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
xlabel('\sigma','FontWeight','bold'); xticks([0 0.1 0.2 0.3]); xticklabels([0 10 20 30]); ylabel('SNR','FontWeight','bold'); hold on

% ---------- accumulate: VIRUS, then overlay dashed KDEs ----------
for i = virus_mice
    accumulate(i);
end
alldist_SNR = [PVdist_SNR, PNdist_SNR, VIPdist_SNR, SSTdist_SNR, UCdist_SNR];
alldist_bN  = [PVdist_bN,  PNdist_bN,  VIPdist_bN,  SSTdist_bN,  UCdist_bN];

[xx, f] = kde_auto(PVdist_SNR,  SNR_max); plotCurve(ax(1,1), xx, f, neuron_colors{1}, 1, '--');
[xx, f] = kde_auto(PNdist_SNR,  SNR_max); plotCurve(ax(1,2), xx, f, neuron_colors{2}, 1, '--');
[xx, f] = kde_auto(VIPdist_SNR, SNR_max); plotCurve(ax(1,3), xx, f, neuron_colors{3}, 1, '--');
[xx, f] = kde_auto(SSTdist_SNR, SNR_max); plotCurve(ax(1,4), xx, f, neuron_colors{5}, 1, '--');
[xx, f] = kde_auto(UCdist_SNR,  SNR_max); plotCurve(ax(1,5), xx, f, neuron_colors{4}, 1, '--');
[xx, f] = kde_auto(alldist_SNR, SNR_max); plotCurve(ax(1,6), xx, f, neuron_colors{4}, 1, '--');

[xx, f] = kde_auto(PVdist_bN,   0.2);     plotCurve(ax(2,1), xx, f, neuron_colors{1}, 1, '--');
[xx, f] = kde_auto(PNdist_bN,   0.2);     plotCurve(ax(2,2), xx, f, neuron_colors{2}, 1, '--');
[xx, f] = kde_auto(VIPdist_bN,  0.2);     plotCurve(ax(2,3), xx, f, neuron_colors{3}, 1, '--');
[xx, f] = kde_auto(SSTdist_bN,  0.2);     plotCurve(ax(2,4), xx, f, neuron_colors{5}, 1, '--');
[xx, f] = kde_auto(UCdist_bN,   0.2);     plotCurve(ax(2,5), xx, f, neuron_colors{4}, 1, '--');
[xx, f] = kde_auto(alldist_bN,  0.2);     plotCurve(ax(2,6), xx, f, neuron_colors{4}, 1, '--');

% ---------- unify y-limits across KDE plots ----------
yMaxSNR = 0.1; %max([fPV_SNR,fPN_SNR,fVIP_SNR,fSST_SNR,fUC_SNR,fALL_SNR], [], 'omitnan');
yMaxbN  = 50; %max([fPV_bN, fPN_bN, fVIP_bN, fSST_bN, fUC_bN, fALL_bN],  [], 'omitnan');
if isempty(yMaxSNR) || isnan(yMaxSNR); yMaxSNR = 1; end
if isempty(yMaxbN)  || isnan(yMaxbN);  yMaxbN  = 1; end
for c = 1:6, ylim(ax(1,c), [0, yMaxSNR*1.05]); end
for c = 1:6, ylim(ax(2,c), [0, yMaxbN*1.05]);  end
for c = 1:6, xlim(ax(1,c), [0, 100]); end
for c = 1:6, xlim(ax(2,c), [0, .1]);  end

end % main

% ---------- helper label ----------
function ylab = normTypeLabel(normType)
switch lower(normType)
    case 'probability'
        ylab = 'Cell fraction (KDE)';
    case 'pdf'
        ylab = 'Density (KDE)';
    otherwise
        ylab = 'Normalized (KDE)';
end
end
