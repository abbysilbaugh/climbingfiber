function timegraph_max(binned_RWS, binned_RWSCF, evoked_win, cellType, neuron_colors)

if strcmp(cellType, 'PN')
    color = neuron_colors{2};
elseif strcmp(cellType, 'UC')
    color = neuron_colors{4};
end

% Prepare RWS cells
nRWScells = 0;
for i = 1:size(binned_RWS, 1)
    for j = 1:size(binned_RWS, 2)
        temp = binned_RWS{i, j};
        temp = getmax(temp, evoked_win);
        binned_RWS{i, j} = temp;
        nCells = length(temp);
    end
    nRWScells = nRWScells + nCells;
end

% Pool
pooledRWS = NaN(nRWScells, 12);
for j = 1:size(binned_RWS, 2)
    pool = [];
    for i = 1:size(binned_RWS, 1)
        temp = binned_RWS{i, j};
        pool = cat(1, pool, temp);
    end

    pooledRWS(:, j) = pool;

end

meanRWS = mean(pooledRWS, 1, 'omitnan');
semRWS = std(pooledRWS, 0, 1, 'omitnan') ./ sqrt(sum(~isnan(pooledRWS), 1));

% Prepare RWSCF cells
nRWSCFcells = 0;
for i = 1:size(binned_RWSCF, 1)
    for j = 1:size(binned_RWSCF, 2)
        temp = binned_RWSCF{i, j};
        temp = getmax(temp, evoked_win);
        binned_RWSCF{i, j} = temp;
        nCells = length(temp);
    end
    nRWSCFcells = nRWSCFcells + nCells;
end

% Pool
pooledRWSCF = NaN(nRWSCFcells, 12);
for j = 1:size(binned_RWSCF, 2)
    pool = [];
    for i = 1:size(binned_RWSCF, 1)
        temp = binned_RWSCF{i, j};
        pool = cat(1, pool, temp);
    end

    pooledRWSCF(:, j) = pool;

end

meanRWSCF = mean(pooledRWSCF, 1, 'omitnan');
semRWSCF = std(pooledRWSCF, 0, 1, 'omitnan') ./ sqrt(sum(~isnan(pooledRWSCF), 1));


x = linspace(1, 12, 12);

figure('Position', [386,429,240,183])
% Plot means with lines
% Add error bars (SEM)
errorbar(x, meanRWS, semRWS, 'Color', color, 'LineStyle', 'none', 'CapSize', 7);
hold on;
errorbar(x, meanRWSCF, semRWSCF, 'Color', color, 'LineStyle', 'none', 'CapSize', 7);
plot(x, meanRWS, '-o', 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', color, 'Color', color, 'LineWidth', 1.5, 'MarkerSize', 4);
plot(x, meanRWSCF, '-o', 'MarkerFaceColor', color, 'MarkerEdgeColor', color, 'Color', color, 'LineWidth', 1.5, 'MarkerSize', 4);

% Customize x-axis
xticks([0 1 2 3 4 5 6 7 8 9 10 11 12]);
xticklabels([-60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60]);

xlim([3 12])
ylim([0 .6])

% Labels
xlabel('Minutes');
ylabel('AUC (ΔF/F0)');

% Formatting
hold off;
box off;

set(gca, 'FontSize', 7, 'FontName', 'Helvetica')


end


% function var = getauc(signal, evoked_win)
%     [~, nCells, nTrials] = size(signal);
%     signal = signal(evoked_win(1):evoked_win(2), :, :);
%     AUC = NaN(nCells, nTrials);
%         for k = 1:nCells
%             for t = 1:nTrials
%                 temp = signal(:, k, t);
%                     %AUC(k, t) = abs(trapz(temp));
%                     AUC(k, t) = trapz(temp);
%             end
%         end
%         var = AUC;
% end

function var = getmax(signal, evoked_win)
    [~, nCells, nTrials] = size(signal);
    signal = signal(evoked_win(1):evoked_win(2), :, :);
    MAXIMUM = NaN(nCells, nTrials);
        for k = 1:nCells
            for t = 1:nTrials
                temp = signal(:, k, t);
                    MAXIMUM(k, t) = max(temp);
            end
        end
        var = MAXIMUM;
end