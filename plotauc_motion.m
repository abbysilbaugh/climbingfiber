function statsout = plotauc_motion(m1_cond1, m1_cond2, evoked_win, condition_names, ylimits, getpersistent, chooseplotstyle)
% plotauc_motion
% - m1_cond1, m1_cond2: cell arrays where {1} is nFrames x nMice signals
% - evoked_win: [startFrame endFrame]
% - condition_names: {'Cond 1','Cond 2'}
% - ylimits: [] or [ymin ymax]
% - getpersistent: 'persistent' or anything else
% - chooseplotstyle: 'pairedlines' (default), 'dotsOnly'
%
% Returns:
% - statsout: struct with fields .test, .p, .N, .effect, etc.

if nargin < 7 || isempty(chooseplotstyle);  chooseplotstyle = 'pairedlines'; end
if nargin < 5 || isempty(ylimits);          ylimits = []; end

% Unwrap
m1_cond1 = m1_cond1{1};
m1_cond2 = m1_cond2{1};

% Get AUC per mouse (columns are mice)
m1_cond1 = getauc(m1_cond1, evoked_win);   % 1 x nMice
m1_cond2 = getauc(m1_cond2, evoked_win);   % 1 x nMice

% Keep only mice present in both, if requested
if strcmpi(getpersistent, 'persistent')
    [m1_cond1, m1_cond2] = keeppersistent(m1_cond1, m1_cond2);
end

% Ensure column vectors
m1_cond1 = m1_cond1(:);
m1_cond2 = m1_cond2(:);

% Remove any residual NaNs pairwise
valid = ~isnan(m1_cond1) & ~isnan(m1_cond2);
m1 = m1_cond1(valid);
m2 = m1_cond2(valid);
N  = numel(m1);

if N < 2
    warning('Not enough paired data after filtering. N=%d', N);
end

% Decide test based on normality of paired differences
diffs = m1 - m2;
isNormal = false;
try
    % Lilliefors normality test on diffs
    isNormal = ~lillietest(diffs);
catch
    % If Statistics Toolbox not available, fall back to a simple heuristic:
    isNormal = abs(kurtosis(diffs) - 3) < 1.5;
end

statsout = struct();
statsout.N = N;

if isNormal
    [h,p,~,st] = ttest(m1, m2);                % paired t-test
    % Cohen's dz for paired samples
    dz = mean(diffs) / std(diffs, 0);
    statsout.test        = 'paired t-test';
    statsout.tstat       = st.tstat;
    statsout.df          = st.df;
    statsout.p           = p;
    statsout.effect_name = 'Cohen''s dz';
    statsout.effect      = dz;
else
    % Wilcoxon signed-rank
    [p,~,st] = signrank(m1, m2);
    % Rank-biserial correlation (matched pairs)
    nonzero = diffs(diffs ~= 0);
    pos = sum(nonzero > 0);
    neg = sum(nonzero < 0);
    rrb = (pos - neg) / (pos + neg);
    statsout.test        = 'Wilcoxon signed-rank';
    statsout.signedrank  = st.signedrank;
    statsout.p           = p;
    statsout.effect_name = 'rank-biserial r';
    statsout.effect      = rrb;
end

% Summary stats for plotting
mean1 = mean(m1, 'omitnan');  mean2 = mean(m2, 'omitnan');
sem1  = std(m1, 0, 'omitnan') / sqrt(N);
sem2  = std(m2, 0, 'omitnan') / sqrt(N);

% --- Plot ---
figure('Position', [1101,696,100,183]); hold on
barH = bar([1 2], [mean1 mean2]);    % bars
% Error bars
errorbar([1 2], [mean1 mean2], [sem1 sem2], 'k', 'LineStyle','none', 'LineWidth',1.2);

% Overlay paired points
xj = 0.10;                                     % jitter for visibility
x1 = 1 + (rand(N,1)*2-1)*xj;
x2 = 2 + (rand(N,1)*2-1)*xj;
scatter(x1, m1, 5, 'k', 'filled', 'MarkerFaceAlpha', 0.7);
scatter(x2, m2, 5, 'k', 'filled', 'MarkerFaceAlpha', 0.7);

if strcmpi(chooseplotstyle, 'pairedlines')
    for i = 1:N
        plot([x1(i) x2(i)], [m1(i) m2(i)], '-', 'Color', [0 0 0 0.25]);
    end
end

% Axes cosmetics
set(gca, 'XTick', [1 2], 'XTickLabel', condition_names, 'FontSize', 11, 'LineWidth',1)
ylabel('AUC (a.u.)')
box off
if ~isempty(ylimits); ylim(ylimits); end

% Title with p-value and effect size
ttl = sprintf('%s: p = %.3g | %s = %.3f (N=%d)', statsout.test, statsout.p, statsout.effect_name, statsout.effect, N);
title(ttl, 'FontWeight','bold');
set(gca, 'FontSize', 7)
end % main function


% ---------- helpers ----------
function AUC = getauc(var, evoked_win)
% var: nFrames x nMice
nMice = size(var, 2);
AUC = NaN(1, nMice);
seg = var(evoked_win(1):evoked_win(2), :);
for i = 1:nMice
    AUC(i) = trapz(seg(:, i));
end
end

function [cond1, cond2] = keeppersistent(cond1, cond2)
% keep mice with non-NaN in BOTH conditions
idx = ~isnan(cond1) & ~isnan(cond2);
cond1 = cond1(idx);
cond2 = cond2(idx);
end
