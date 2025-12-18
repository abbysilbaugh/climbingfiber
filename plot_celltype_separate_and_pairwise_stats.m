function [PN_tbl, UC_tbl, PN_pmat, UC_pmat] = plot_celltype_separate_and_pairwise_stats( ...
    PNs, UCs, labels, colorPN, colorUC, stat, doFDR, makeHeatmaps)

% plot_celltype_separate_and_pairwise_stats
% Plots PNs and UCs separately (mean/median ± SEM) and performs
% pairwise comparisons between EVERY experiment within EACH cell type.
%
% Inputs
%   PNs, UCs : 1xN (or Nx1) cell arrays; each cell is a numeric vector
%   labels   : 1xN cellstr of experiment names
%   colorPN  : 1x3 RGB for PN bars
%   colorUC  : 1x3 RGB for UC bars
%   stat     : 'mean' (default) or 'median' for bar height
%   doFDR    : true/false (default: true) apply BH-FDR within each cell type
%   makeHeatmaps : true/false (default: true) draw p-value heatmaps
%
% Outputs
%   PN_tbl, UC_tbl : tables of all pairwise results (exp_i, exp_j, test, p, p_adj, n_i, n_j)
%   PN_pmat, UC_pmat : symmetric matrices of raw p-values (NaN on diagonal)
%
% Abby-ready: drop this in your path and call with your PNs/UCs arrays.

    if nargin < 6 || isempty(stat),        stat = 'mean'; end
    if nargin < 7 || isempty(doFDR),       doFDR = true;  end
    if nargin < 8 || isempty(makeHeatmaps),makeHeatmaps = true; end

    assert(numel(PNs)==numel(UCs), 'PNs and UCs must have same #experiments.');
    N = numel(PNs);
    if nargin < 3 || isempty(labels)
        labels = strcat("Exp_", string(1:N));
    end

    % ---------- Compute summaries for plotting ----------
    [pn_mu, pn_sem, pn_n] = summarize_cells(PNs, stat);
    [uc_mu, uc_sem, uc_n] = summarize_cells(UCs, stat);

    % Filter out experiments where BOTH are empty (optional; keep all by default)
    % keep = ~(isnan(pn_mu) & isnan(uc_mu)); % uncomment to drop all-empty exps
    keep = true(1,N);

    % ---------- Plot PN bar chart ----------
    figure('Name','PNs','Color','w'); hold on;
    b1 = bar(find(keep), pn_mu(keep), 'FaceColor', colorPN, 'EdgeColor','none');
    e1 = errorbar(find(keep), pn_mu(keep), pn_sem(keep), 'k', 'linestyle','none','LineWidth',1);
    xticks(1:N); xticklabels(labels); xtickangle(45);
    ylabel(sprintf('ROI size (%s \\pm SEM)', lower(stat)));
    title('PNs'); box on; grid on;
    for i = find(keep)
        if ~isnan(pn_n(i))
            text(i, pn_mu(i)+pn_sem(i)+0.2, sprintf('n=%d', pn_n(i)), ...
                'HorizontalAlignment','center','FontSize',9);
        end
    end

    % ---------- Plot UC bar chart ----------
    figure('Name','UCs','Color','w'); hold on;
    b2 = bar(find(keep), uc_mu(keep), 'FaceColor', colorUC, 'EdgeColor','none');
    e2 = errorbar(find(keep), uc_mu(keep), uc_sem(keep), 'k', 'linestyle','none','LineWidth',1);
    xticks(1:N); xticklabels(labels); xtickangle(45);
    ylabel(sprintf('ROI size (%s \\pm SEM)', lower(stat)));
    title('UCs'); box on; grid on;
    for i = find(keep)
        if ~isnan(uc_n(i))
            text(i, uc_mu(i)+uc_sem(i)+0.2, sprintf('n=%d', uc_n(i)), ...
                'HorizontalAlignment','center','FontSize',9);
        end
    end

    % ---------- Pairwise stats within PN and within UC ----------
    [PN_tbl, PN_pmat] = pairwise_all(PNs, labels);
    [UC_tbl, UC_pmat] = pairwise_all(UCs, labels);

    % ---------- Multiple comparisons (FDR) ----------
    if doFDR
        PN_tbl.p_adj = bh_fdr(PN_tbl.p);
        UC_tbl.p_adj = bh_fdr(UC_tbl.p);
    else
        PN_tbl.p_adj = PN_tbl.p;
        UC_tbl.p_adj = UC_tbl.p;
    end

    % ---------- Optional: heatmaps of p-values ----------
    if makeHeatmaps
        figure('Name','PN pairwise p-values','Color','w');
        imagesc(PN_pmat); axis square; colorbar; caxis([0 0.05]);
        title('PN pairwise p-values'); xticks(1:N); yticks(1:N);
        xticklabels(labels); yticklabels(labels); xtickangle(45);
        set(gca,'YDir','normal');

        figure('Name','UC pairwise p-values','Color','w');
        imagesc(UC_pmat); axis square; colorbar; caxis([0 0.05]);
        title('UC pairwise p-values'); xticks(1:N); yticks(1:N);
        xticklabels(labels); yticklabels(labels); xtickangle(45);
        set(gca,'YDir','normal');
    end
end

% ==================== Helpers ====================

function [mu, sem, n] = summarize_cells(C, stat)
    N = numel(C);
    mu  = nan(1,N); sem = nan(1,N); n = nan(1,N);
    for i = 1:N
        x = C{i};
        if isempty(x), continue; end
        x = x(:); x = x(~isnan(x));
        if isempty(x), continue; end
        n(i) = numel(x);
        switch lower(stat)
            case 'mean',   mu(i) = mean(x,'omitnan');
            case 'median', mu(i) = median(x,'omitnan');
            otherwise, error('stat must be ''mean'' or ''median''.');
        end
        if n(i) > 1
            sem(i) = std(x, 'omitnan') / sqrt(n(i));
        else
            sem(i) = NaN;
        end
    end
end

function [T, pmat] = pairwise_all(C, labels)
    % All pairwise tests across experiments within a cell type
    N = numel(C);
    rows = [];
    pmat = nan(N,N);
    for i = 1:N
        xi = C{i}; xi = xi(:);
        xi = xi(~isnan(xi));
        for j = i+1:N
