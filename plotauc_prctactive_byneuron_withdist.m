function plotauc_prctactive_byneuron_withdist(m1_cond1, m1_cond2, m2_cond1, m2_cond2, m1_prctactive, m2_prctactive, neuron_colors, plotscatter, evoked_win, group_names, condition_names, ylimits, chooseoutliers)

% Get AUC for each neuron
m1_cond1 = getauc(m1_cond1, evoked_win);
m1_cond2 = getauc(m1_cond2, evoked_win);
m2_cond1 = getauc(m2_cond1, evoked_win);
m2_cond2 = getauc(m2_cond2, evoked_win);

% Calculate delta
m1_delta = calculatedelta(m1_cond1, m1_cond2);
m2_delta = calculatedelta(m2_cond1, m2_cond2);

for i = 1:5
makescatterplot(m1_delta{i}, m1_prctactive{i}, neuron_colors{i}, 'nofill', chooseoutliers)
makescatterplot(m2_delta{i}, m2_prctactive{i}, neuron_colors{i}, 'filled', chooseoutliers)
end


end

function var = getauc(var, evoked_win)
[nMice, ncellType] = size(var);
    for i = 1:nMice
        for j = 1:ncellType
            signal = var{i, j};
            if ~isempty(signal)
                [~, nCells, nTrials] = size(signal);
                signal = signal(evoked_win(1):evoked_win(2), :, :);
                AUC = NaN(nCells, nTrials);
                for k = 1:nCells
                    for t = 1:nTrials
                        temp = signal(:, k, t);
                            %AUC(k, t) = abs(trapz(temp));
                            AUC(k, t) = trapz(temp);
                    end
                end
                var{i, j} = AUC;
            end
        end
    end
end

function delta = calculatedelta(var1, var2)

ncellType = length(var1);
delta = cell(1, ncellType);

for i = 1:ncellType
    temp1 = var1{i};
    temp2 = var2{i};

    temp_delta = (temp2-temp1)./temp1;
    delta{i} = temp_delta;

end

end

function makescatterplot(delta, prctactive, color, choosefill, chooseoutliers)

    % Remove outliers
    if strcmp(chooseoutliers, 'nooutliers')
    outliers = isoutlier(delta, 'median');
    delta = delta(~outliers);
    prctactive = prctactive(~outliers);
    end

% Create axes for joint plot
figure;
tiledlayout(4, 4, 'Padding', 'compact', 'TileSpacing', 'compact');

% Top distribution (prctactive)
nexttile([1 3])  % Top row, first 3 columns
[f, xi] = ksdensity(prctactive);
plot(xi, f, 'Color', color, 'LineWidth', 1.5)
axis tight
set(gca, 'XTick', [], 'YTick', [], 'FontSize', 12, 'FontName', 'Helvetica')
xlim([0 100])

% Right distribution (delta)
nexttile(4)  % This is the tile at row 1, column 4
nexttile([3 3])  % Now tiles (2:4,4)
if strcmp(choosefill, 'filled')
    scatter(prctactive, delta, 10, color, 'filled')
else
    scatter(prctactive, delta, 10, color)
end
xlabel('% active trials')
ylabel('∆AUC')
xlim([0 100])
set(gca, 'FontSize', 12, 'FontName', 'Helvetica')

% Main scatter plot

hold on


    % Normality test
    has_swtest = exist('swtest', 'file') == 2;
    if has_swtest
        [h1, ~] = swtest(prctactive);
        [h2, ~] = swtest(delta);
    else
        warning('swtest not found. Using jbtest instead.');
        [h1, ~] = jbtest(prctactive);
        [h2, ~] = jbtest(delta);
    end
    normal1 = ~h1;
    normal2 = ~h2;

    % Correlation + trend line
    if normal1 && normal2
        [r, p] = corr(prctactive(:), delta(:), 'Type', 'Pearson');
        corrtype = 'Pearson';

        if p < 0.05
            lm = fitlm(prctactive, delta);
            xfit = linspace(min(prctactive), max(prctactive), 100)';
            [yfit, yci] = predict(lm, xfit);
            plot(xfit, yfit, '-', 'Color', color, 'LineWidth', 1.5)
            fill([xfit; flipud(xfit)], [yci(:,1); flipud(yci(:,2))], color, ...
                 'FaceAlpha', 0.2, 'EdgeColor', 'none')
        end
    else
        [r, p] = corr(prctactive(:), delta(:), 'Type', 'Spearman');
        corrtype = 'Spearman';

        if p < 0.05
%             [xsort, idx] = sort(prctactive);
%             ysort = delta(idx);
%             ysmoothed = smooth(xsort, ysort, 0.3, 'lowess');
%             plot(xsort, ysmoothed, '-', 'Color', color, 'LineWidth', 1.5)
        end
    end

    title(sprintf('%s r = %.2f, p = %.3f', corrtype, r, p))
        if strcmp(chooseoutliers, 'includeoutliers')
        ylim([-3, 10])
    end

    nexttile(5)  % This is tile at (2,1)
nexttile([3 1])  % Now tiles (2:4, 1:3)
[f2, xi2] = ksdensity(delta);
plot(f2, xi2, 'Color', color, 'LineWidth', 1.5)
axis tight
set(gca, 'XTick', [], 'YTick', [], 'FontSize', 12, 'FontName', 'Helvetica')

    if strcmp(chooseoutliers, 'includeoutliers')
        ylim([-3, 10])
    end

end
