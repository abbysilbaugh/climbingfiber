function timegraph_auc(binned_RWS, binned_RWSCF, evoked_win, cellType, neuron_colors, ylimits, ploterrorbars, xlimit, endANOVA, choosepersistent)

if strcmp(cellType, 'PN')
    color = neuron_colors{2};
elseif strcmp(cellType, 'UC')
    color = neuron_colors{4};
elseif strcmp(cellType, 'PV')
    color = neuron_colors{1};
elseif strcmp(cellType, 'SST')
    color = neuron_colors{5};
elseif strcmp(cellType, 'VIP')
    color = neuron_colors{3};
elseif strcmp(cellType, 'SST and PV')
    color1 = neuron_colors{1};
    color2 = neuron_colors{5};
    color = (color1+color2)/2;

end

% Prepare RWS cells
nRWScells = 0;
for i = 1:size(binned_RWS, 1)
    for j = 1:size(binned_RWS, 2)
        temp = binned_RWS{i, j};
        temp = getauc(temp, evoked_win);
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

% Prepare RWSCF cells
nRWSCFcells = 0;
for i = 1:size(binned_RWSCF, 1)
    for j = 1:size(binned_RWSCF, 2)
        temp = binned_RWSCF{i, j};
        temp = getauc(temp, evoked_win);
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

if strcmp(choosepersistent, 'persistent')
    pre_RWS = pooledRWS(:, 1:7);
    post_RWS = pooledRWS(:, 8:end);
    temp_pre = ~isnan(pre_RWS);
    temp_pre = sum(temp_pre, 2);
    temp_pre = temp_pre > 0;
    temp_post = ~isnan(post_RWS);
    temp_post = sum(temp_post, 2);
    temp_post = temp_post > 0;
    getpersistent_RWS = temp_pre & temp_post;
    pooledRWS = pooledRWS(getpersistent_RWS, :);


    pre_RWSCF = pooledRWSCF(:, 1:7);
    post_RWSCF = pooledRWSCF(:, 8:end);
    temp_pre = ~isnan(pre_RWSCF);
    temp_pre = sum(temp_pre, 2);
    temp_pre = temp_pre > 0;
    temp_post = ~isnan(post_RWSCF);
    temp_post = sum(temp_post, 2);
    temp_post = temp_post > 0;
    getpersistent_RWSCF = temp_pre & temp_post;
    pooledRWSCF = pooledRWSCF(getpersistent_RWSCF, :);
end

meanRWS = mean(pooledRWS, 1, 'omitnan');
semRWS = std(pooledRWS, 0, 1, 'omitnan') ./ sqrt(sum(~isnan(pooledRWS), 1));
meanRWSCF = mean(pooledRWSCF, 1, 'omitnan');
semRWSCF = std(pooledRWSCF, 0, 1, 'omitnan') ./ sqrt(sum(~isnan(pooledRWSCF), 1));

% Count the number of mice at each time point
temp = zeros(size(binned_RWS, 1), 12);
for i = 1:size(binned_RWS, 1)
for j = 1:12
temp2 = binned_RWS{i, j};
temp2 = sum(~isnan(temp2));
if temp2 > 0
temp(i, j) = 1;
end
end
end
RWS_nummice = sum(temp);

temp = zeros(size(binned_RWSCF, 1), 12);
for i = 1:size(binned_RWSCF, 1)
for j = 1:12
temp2 = binned_RWSCF{i, j};
temp2 = sum(~isnan(temp2));
if temp2 > 0
temp(i, j) = 1;
end
end
end
RWSCF_nummice = sum(temp);

RWS_numcells = zeros(12, 1);
RWSCF_numcells = zeros(12, 1);
for i = 1:12
RWS_numcells(i) = sum(~isnan(pooledRWS(:, i)));
RWSCF_numcells(i) = sum(~isnan(pooledRWSCF(:, i)));
end




x = linspace(1, 12, 12);

%figure('Position', [350,429,260,183])
% Plot means with lines
% Add error bars (SEM)
hold on;
if strcmp(ploterrorbars, 'ploterrorbars')
errorbar(x, meanRWS, semRWS, 'Color', color, 'LineStyle', 'none', 'CapSize', 7)
errorbar(x, meanRWSCF, semRWSCF, 'Color', color, 'LineStyle', 'none', 'CapSize', 7);
end
plot(x, meanRWS, '-o', 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', color, 'Color', color, 'LineWidth', 1.5, 'MarkerSize', 4);
plot(x, meanRWSCF, '-o', 'MarkerFaceColor', color, 'MarkerEdgeColor', color, 'Color', color, 'LineWidth', 1.5, 'MarkerSize', 4);

% Customize x-axis
xticks([0 1 2 3 4 5 6 7 8 9 10 11 12]);
xticklabels([-60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60]);

xlim([xlimit(1)-.5, xlimit(2)])
ylim(ylimits)

% Labels
xlabel('Time (min)');
ylabel('AUC (ΔFt/F)');

% Formatting
box off;

set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
hold off

% Prepare data for statistics
pooledRWS = pooledRWS(:, 6:endANOVA);
pooledRWSCF = pooledRWSCF(:, 6:endANOVA);

% Get dimensions
[nCells, nTimePoints] = size(pooledRWS);
[nCells_CF, nTimePoints_CF] = size(pooledRWSCF);

% Ensure the same number of time points
if nTimePoints ~= nTimePoints_CF
    error('The two datasets must have the same number of time points.');
end

% Convert matrices to column vectors and create group/time labels
data = [];
group = [];
timePoints = [];

for t = 1:nTimePoints
    % Extract non-NaN values for each group
    data1 = pooledRWS(:, t);
    data2 = pooledRWSCF(:, t);

    % Remove NaNs
    data1 = data1(~isnan(data1));
    data2 = data2(~isnan(data2));

    % Append to arrays
    data = [data; data1; data2];
    group = [group; ones(length(data1), 1); 2 * ones(length(data2), 1)];
    timePoints = [timePoints; t * ones(length(data1) + length(data2), 1)];
end

% Perform Two-Way ANOVA
[p, tbl, stats] = anovan(data, {timePoints, group}, 'model', 'interaction', ...
                         'varnames', {'TimePoint', 'Group'});

% Display results
disp('Two-Way ANOVA Results:');
disp(['p-values: Time=', num2str(p(1)), ', Group=', num2str(p(2)), ', Interaction=', num2str(p(3))]);

figure;
% Perform post-hoc Tukey's HSD test for the "Group" effect
disp('Performing post-hoc Tukey’s HSD test for Group...');
groupComparisons = multcompare(stats, 'Dimension', 2); % Group comparisons



end


function var = getauc(signal, evoked_win)
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
        var = AUC;
end

