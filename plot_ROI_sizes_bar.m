function plot_ROI_sizes_bar(...
    BT, RWS, RWSCF, RWSCF_PV_JAWS, control_PV_JAWS, RWSCF_PV_Gi, control_PV_Gi, ...
    RWS_PV_Gq, control_PV_Gq, RWSCF_SST_Gi, control_SST_Gi, RWS_SST_Gq, control_SST_Gq, ...
    RWSCF_VIP_Gq, control_VIP_Gq, RWS_VIP_Gi, control_VIP_Gi, SST_Gi_ZI, PV_Gi_ZI, ...
    neuron_colors, stat)

% plot_ROI_sizes_bar
% - Grouped bar plot of PN vs UC per experiment (mean/median ± SEM)
% - Per-experiment PN vs UC stats with normality check
% - Skips experiments where both PN and UC are empty
% - Then plots PN and UC separately + runs all pairwise stats across experiments

if nargin < 21 || isempty(stat); stat = 'mean'; end

% ---- Collect conditions ----
PNs = {BT{2}, RWS{2}, RWSCF{2}, RWSCF_PV_JAWS{2}, control_PV_JAWS{2}, ...
       RWSCF_PV_Gi{2}, control_PV_Gi{2}, RWS_PV_Gq{2}, control_PV_Gq{2}, ...
       RWSCF_SST_Gi{2}, control_SST_Gi{2}, RWS_SST_Gq{2}, control_SST_Gq{2}, ...
       RWSCF_VIP_Gq{2}, control_VIP_Gq{2}, RWS_VIP_Gi{2}, control_VIP_Gi{2}, ...
       SST_Gi_ZI{2}, PV_Gi_ZI{2}};

UCs = {BT{4}, RWS{4}, RWSCF{4}, RWSCF_PV_JAWS{4}, control_PV_JAWS{4}, ...
       RWSCF_PV_Gi{4}, control_PV_Gi{4}, RWS_PV_Gq{4}, control_PV_Gq{4}, ...
       RWSCF_SST_Gi{4}, control_SST_Gi{4}, RWS_SST_Gq{4}, control_SST_Gq{4}, ...
       RWSCF_VIP_Gq{4}, control_VIP_Gq{4}, RWS_VIP_Gi{4}, control_VIP_Gi{4}, ...
       SST_Gi_ZI{4}, PV_Gi_ZI{4}};

labels = { ...
  'BT','RWS','RWSCF','RWSCF PV JAWS','Ctrl PV JAWS', ...
  'RWSCF PV Gi','Ctrl PV Gi','RWS PV Gq','Ctrl PV Gq', ...
  'RWSCF SST Gi','Ctrl SST Gi','RWS SST Gq','Ctrl SST Gq', ...
  'RWSCF VIP Gq','Ctrl VIP Gq','RWS VIP Gi','Ctrl VIP Gi', ...
  'SST Gi ZI','PV Gi ZI'};

% ---- Per-experiment PN vs UC summary + stats ----
nExp = numel(PNs);
PN_means = nan(1,nExp); UC_means = nan(1,nExp);
PN_sems  = nan(1,nExp); UC_sems  = nan(1,nExp);
pvals    = nan(1,nExp); testUsed = strings(1,nExp);

safe_stat = @(x) compute_stat(x, stat);
safe_sem  = @(x) compute_sem(x);

for i = 1:nExp
    xpn = PNs{i}; xuc = UCs{i};
    if ~isempty(xpn)
        PN_means(i) = safe_stat(xpn); PN_sems(i) = safe_sem(xpn);
    end
    if ~isempty(xuc)
        UC_means(i) = safe_stat(xuc); UC_sems(i) = safe_sem(xuc);
    end

    if ~isempty(xpn) && ~isempty(xuc)
        % Normality tests (Lilliefors)
        normPN = (numel(xpn) >= 4) && lillietest(xpn) == 0;
        normUC = (numel(xuc) >= 4) && lillietest(xuc) == 0;

        if normPN && normUC
            [~,p] = ttest2(xpn, xuc);  % unpaired t-test
            testUsed(i) = "t-test";
        else
            p = ranksum(xpn, xuc);     % Mann-Whitney
            testUsed(i) = "ranksum";
        end
        pvals(i) = p;

        fprintf('Experiment %s: %s p=%.4f (nPN=%d, nUC=%d)\n', ...
            labels{i}, testUsed(i), p, numel(xpn), numel(xuc));
    end
end

% ---- Filter out experiments where BOTH PN and UC are empty ----
hasPN = ~cellfun(@(x) isempty(x) || all(isnan(x)), PNs);
hasUC = ~cellfun(@(x) isempty(x) || all(isnan(x)), UCs);
keepMask = hasPN | hasUC;

PNs_f    = PNs(keepMask);
UCs_f    = UCs(keepMask);
labels_f = labels(keepMask);

PN_means = PN_means(keepMask);
UC_means = UC_means(keepMask);
PN_sems  = PN_sems(keepMask);
UC_sems  = UC_sems(keepMask);
pvals    = pvals(keepMask);
testUsed = testUsed(keepMask);
nExp     = numel(labels_f);

% ---- Grouped bar plot (PN vs UC) ----
figure('Name','PN vs UC (grouped)','Color','w'); hold on;
B = bar([PN_means(:), UC_means(:)], 'grouped');
B(1).FaceColor = neuron_colors{2};  % PN color
B(2).FaceColor = neuron_colors{4};  % UC color

% Error bars
ngroups = nExp; nbars = 2;
groupwidth = min(0.8, nbars/(nbars+1.5));
x1 = (1:ngroups) - groupwidth/2 + (2*1-1)*groupwidth/(2*nbars);
x2 = (1:ngroups) - groupwidth/2 + (2*2-1)*groupwidth/(2*nbars);

errorbar(x1, PN_means, PN_sems, 'k', 'linestyle','none', 'LineWidth',1);
errorbar(x2, UC_means, UC_sems, 'k', 'linestyle','none', 'LineWidth',1);

% Significance stars (per-experiment PN vs UC)
for i = 1:nExp
    if ~isnan(pvals(i))
        y = max([PN_means(i)+PN_sems(i), UC_means(i)+UC_sems(i)]) + 0.5;
        stars = getSigStars(pvals(i));
        text(mean([x1(i),x2(i)]), y, stars, ...
            'HorizontalAlignment','center','FontSize',10,'FontWeight','bold');
    end
end

% Labels/axes
xticks(1:nExp);
xticklabels(labels_f); xtickangle(45);
ylabel(sprintf('ROI size (%s ± SEM)', lower(stat)));
legend({'PN','UC'}, 'Location','best');
title('PN vs UC across experiments');
ylim([0 18]); box on; grid on; hold off;

% ---- Also: plot PN and UC separately + all pairwise stats within each type ----
plot_celltype_separate_and_pairwise_stats( ...
    PNs_f, UCs_f, labels_f, neuron_colors{2}, neuron_colors{4}, 'median', true, true);

end


% ==================== Helpers ====================

function m = compute_stat(x, stat)
    x = x(:); x = x(~isnan(x));
    if isempty(x), m = NaN; return; end
    switch lower(stat)
        case 'mean',   m = mean(x,'omitnan');
        case 'median', m = median(x,'omitnan');
        otherwise, error('stat must be ''mean'' or ''median''.');
    end
end

function s = compute_sem(x)
    x = x(:); x = x(~isnan(x));
    n = numel(x);
    if n<=1, s = NaN; else, s = std(x,'omitnan')/sqrt(n); end
end

function stars = getSigStars(p)
    if p < 0.001, stars = '***';
    elseif p < 0.01, stars = '**';
    elseif p < 0.05, stars = '*';
    else, stars = 'n.s.';
    end
end


% ================================================================
% Plots PNs and UCs separately, and runs all pairwise stats within each.
% ================================================================
function [PN_tbl, UC_tbl, PN_pmat, UC_pmat] = plot_celltype_separate_and_pairwise_stats( ...
    PNs, UCs, labels, colorPN, colorUC, stat, doFDR, makeHeatmaps)

if nargin < 6 || isempty(stat),        stat = 'mean'; end
if nargin < 7 || isempty(doFDR),       doFDR = true;  end
if nargin < 8 || isempty(makeHeatmaps),makeHeatmaps = true; end

assert(numel(PNs)==numel(UCs), 'PNs and UCs must have same #experiments.');

N = numel(PNs);
labels = normalize_labels_length(labels, N);  % ensure label length

% ---------- Compute summaries for plotting ----------
[pn_mu, pn_sem, pn_n] = summarize_cells(PNs, stat);
[uc_mu, uc_sem, uc_n] = summarize_cells(UCs, stat);

% ---------- Plot PN bar chart ----------
figure('Name','PNs (separate)','Color','w'); hold on;
bar(1:N, pn_mu, 'FaceColor', colorPN, 'EdgeColor','none');
errorbar(1:N, pn_mu, pn_sem, 'k', 'linestyle','none','LineWidth',1);
xticks(1:N); xticklabels(labels); xtickangle(45);
ylabel(sprintf('ROI size (%s \\pm SEM)', lower(stat)));
title('PNs'); box on; grid on;
for i = 1:N
    if ~isnan(pn_n(i))
        text(i, pn_mu(i)+pn_sem(i)+0.2, sprintf('n=%d', pn_n(i)), ...
            'HorizontalAlignment','center','FontSize',9);
    end
end
hold off;

% ---------- Plot UC bar chart ----------
figure('Name','UCs (separate)','Color','w'); hold on;
bar(1:N, uc_mu, 'FaceColor', colorUC, 'EdgeColor','none');
errorbar(1:N, uc_mu, uc_sem, 'k', 'linestyle','none','LineWidth',1);
xticks(1:N); xticklabels(labels); xtickangle(45);
ylabel(sprintf('ROI size (%s \\pm SEM)', lower(stat)));
title('UCs'); box on; grid on;
for i = 1:N
    if ~isnan(uc_n(i))
        text(i, uc_mu(i)+uc_sem(i)+0.2, sprintf('n=%d', uc_n(i)), ...
            'HorizontalAlignment','center','FontSize',9);
    end
end
hold off;

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

% ---------- Optional: heatmaps ----------
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


% ==================== Lower-level helpers ====================

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
    labels = normalize_labels_length(labels, N);  % ensure N labels

    rows = {};
    pmat = nan(N,N);
    for i = 1:N
        xi = C{i}; if ~isempty(xi), xi = xi(:); xi = xi(~isnan(xi)); end
        for j = i+1:N
            xj = C{j}; if ~isempty(xj), xj = xj(:); xj = xj(~isnan(xj)); end

            if isempty(xi) || isempty(xj)
                p = NaN; testname = "NA"; ni = numel(xi); nj = numel(xj);
            else
                [p, testname] = pick_and_test(xi, xj);
                ni = numel(xi); nj = numel(xj);
            end

            rows(end+1, :) = {labels{i}, labels{j}, testname, p, ni, nj}; %#ok<AGROW>
            pmat(i,j) = p; pmat(j,i) = p;
        end
    end
    T = cell2table(rows, 'VariableNames', {'exp_i','exp_j','test','p','n_i','n_j'});
end

function [p, testname] = pick_and_test(a, b)
    % Normality on each group; both normal => ttest2, else ranksum
    normA = is_normal(a);
    normB = is_normal(b);
    if normA && normB
        [~, p] = ttest2(a, b);
        testname = "t-test";
    else
        p = ranksum(a, b);
        testname = "ranksum";
    end
end

function tf = is_normal(x)
    x = x(:); x = x(~isnan(x));
    if numel(x) < 4
        tf = false; % conservative for small n
        return;
    end
    % Try Lilliefors, fall back to Jarque–Bera, else heuristic
    try
        tf = lillietest(x) == 0; % 0 => fail to reject normality
    catch
        try
            tf = jbtest(x) == 0;
        catch
            sk = skewness(x); kt = kurtosis(x);
            tf = (abs(sk) < 1) && (abs(kt-3) < 1.5);
        end
    end
end

function p_adj = bh_fdr(p)
    % Benjamini–Hochberg FDR on a vector of p-values (NaNs preserved)
    p = p(:);
    p_adj = nan(size(p));
    idx = find(~isnan(p));
    if isempty(idx), return; end
    [ps, order] = sort(p(idx));
    m = numel(ps);
    q = ps .* m ./ (1:m)';
    % enforce monotonicity
    for k = m-1:-1:1
        q(k) = min(q(k), q(k+1));
    end
    q(q>1) = 1;
    p_adj(idx(order)) = q;
end

function labels = normalize_labels_length(labels, N)
    % Ensure labels is a 1xN cellstr; pad or truncate if needed
    if nargin < 1 || isempty(labels)
        labels = arrayfun(@(k) sprintf('Exp_%d', k), 1:N, 'uni', 0);
        return;
    end
    labels = labels(:).';
    if numel(labels) < N
        labels = [labels, arrayfun(@(k) sprintf('Exp_%d', k), numel(labels)+1:N, 'uni', 0)];
    elseif numel(labels) > N
        labels = labels(1:N);
    end
end
