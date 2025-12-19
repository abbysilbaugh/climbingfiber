function plottime(allData, cellType, cellmotType, trialmotType, variable, exclude, binsize, ylimit, xlimit, gettitle, savename)
% whiskerTetMice = [15];
% % %whiskerOptoTetMice = [1, 6, 7, 8, 9, 12, 13, 14];
% whiskerOptoTetMice = [1, 6, 7, 8, 9, 12, 13, 14];

% % OG
% whiskerTetMice = [2, 3, 4, 5, 10, 11];
% whiskerOptoTetMice = [1, 6, 7, 8, 9];

% ALL
whiskerTetMice = [2, 3, 4, 5, 10, 11, 18]; %, 16?];
whiskerOptoTetMice = [1, 6, 7, 8, 9, 12, 13, 14, 15];


% Choose color
if strcmp(cellType, 'PV')
    Color = [187, 37, 37]/255; % Red
elseif strcmp(cellType, 'PN')
    Color = [37, 112, 187]/255; % Blue
elseif strcmp(cellType, 'VIP')
    Color = [37 187 112]/255; % Green
elseif strcmp(cellType, 'UC')
    Color = [37 187 112]/255; % Green
end

% Get time data; returns nMice x 1 cell array. Each contains an nTrials x 1
% array with the relative time of the trial. nTrials may be different for
% each mouse.
[timedata, ~] = grabdata(allData, cellType, cellmotType, 'W', trialmotType, 'all',  'NO DCZ', 'reltime', exclude);

% Get variable data; should use a variable of size nCells x nTrials
[vardata, vardatatype] = grabdata(allData, cellType, cellmotType, 'W', trialmotType, 'all',  'NO DCZ', variable, exclude);

if ~strcmp(vardatatype{1}, 'nCells x nTrials')
    warning('Use different variable type')
end

%%%%%%%%%%% COMPILE INTO EXCEL FOR CHRISTIAN 12/13/23 %%%%%%%%%%%%%%%
% WhiskerTet Experiment
% Determine maximum number of neurons across mice and total trials
nNeurons = zeros(1, length(whiskerTetMice));
nTrials = zeros(1, length(whiskerTetMice));
for i = whiskerTetMice
    nNeurons(i) = size(vardata{i}, 1);
    nTrials(i) = size(vardata{i}, 2);
end
GETNUMROWS = max(nNeurons) + 1; % max number of neurons plus 1
GETNUMCOLUMNS = sum(nTrials); % total number of trials

WhiskerTetExcel = NaN(GETNUMROWS, GETNUMCOLUMNS);

% Fill in array
% First, iterate through each mouse in experiment
c = 1; % Counter to keep track of indices
for i = whiskerTetMice
    % For each mouse, fill in data across all trials
    WhiskerTetExcel(1, c:c+nTrials(i)-1) = timedata{i}; % Trial times
    WhiskerTetExcel(2:nNeurons(i)+1, c:c+nTrials(i)-1) = vardata{i}; % Data
    
    c = c + nTrials(i); % Update counter
end

% Now we need to sort the data so that all trial times are in order
% Use argsort to get the indices of the trial times (first row) and use
% those indices to sort the rest of the array
[~,I] = sort(WhiskerTetExcel(1,:));
WhiskerTetExcel_sort = WhiskerTetExcel(:,I);
WhiskerTet_nMice = length(whiskerTetMice);
WhiskerTet_nNeurons = sum(nNeurons);


% WhiskerOptoTet Experiment
nNeurons = zeros(1, length(whiskerOptoTetMice));
nTrials = zeros(1, length(whiskerOptoTetMice));
for i = whiskerOptoTetMice
    nNeurons(i) = size(vardata{i}, 1);
    nTrials(i) = size(vardata{i}, 2);
end
GETNUMROWS = max(nNeurons) + 1; % max number of neurons plus 1
GETNUMCOLUMNS = sum(nTrials); % total number of trials

WhiskerOptoTetExcel = NaN(GETNUMROWS, GETNUMCOLUMNS);

c = 1; % Counter to keep track of indices
for i = whiskerOptoTetMice
    WhiskerOptoTetExcel(1, c:c+nTrials(i)-1) = timedata{i}; % Trial times
    WhiskerOptoTetExcel(2:nNeurons(i)+1, c:c+nTrials(i)-1) = vardata{i}; % Data
    
    c = c + nTrials(i); % Update counter
end

[~,I] = sort(WhiskerOptoTetExcel(1,:));
WhiskerOptoTetExcel_sort = WhiskerOptoTetExcel(:,I);
WhiskerOptoTet_nMice = length(whiskerOptoTetMice);
WhiskerOptoTet_nNeurons = sum(nNeurons);

xlswrite('WhiskerTetExcel.xlsx',WhiskerTetExcel_sort);
xlswrite('WhiskerOptoTetExcel.xlsx',WhiskerOptoTetExcel_sort);
disp(['WhiskerTet contains ', num2str(WhiskerTet_nMice), ' mice and ', num2str(WhiskerTet_nNeurons), ' neurons'])
disp(['WhiskerOptoTet contains ', num2str(WhiskerOptoTet_nMice), ' mice and ', num2str(WhiskerOptoTet_nNeurons), ' neurons'])






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Define bin edges and initialize bin cell array
binWidth = binsize;
minTime = -50;
maxTime = 100;
binEdges = minTime:binWidth:maxTime;
binCenters = (binEdges(1:end-1) + binEdges(2:end)) / 2;
bins = cell(1, length(binCenters));

% Iterate through mice, classify each trial into a bin, and collect the corresponding data
figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];

% Plot whiskerTetMice as empty circles
allMice = whiskerTetMice;
avgBins = cell(1, length(binCenters));
semBins = cell(1, length(binCenters)); % For storing SEM

for i = allMice
    T = timedata{i};
    var = vardata{i}; % assuming size of var is nCells x nTrials
    
    for j = 1:length(T)
        % Find which bin this time point belongs to
        binIdx = find(T(j) >= binEdges(1:end-1) & T(j) < binEdges(2:end), 1);
        if ~isempty(binIdx)
            if isempty(bins{binIdx})
                bins{binIdx} = var(:,j);
            else
                bins{binIdx} = cat(1, bins{binIdx}, var(:,j)); % append data to this bin
            end
        end
    end
end

% Calculate the average and SEM for each bin
for idx = 1:length(binCenters)
    avgBins{idx} = nanmean(bins{idx});
    semBins{idx} = nanstd(bins{idx}) / sqrt(numel(bins{idx}));
end

% Plotting
for idx = 1:length(binCenters)
    RWS = scatter(repmat(binCenters(idx), numel(avgBins{idx}), 1), avgBins{idx}, 'Marker', 'o', 'MarkerFaceColor', 'none', 'MarkerEdgeColor', Color);
    hold on;
    errorbar(binCenters(idx), avgBins{idx}, semBins{idx}, 'LineStyle', 'none', 'Color', Color);
end

% Plot whiskerOptoTetMice as filled circles
allMice = whiskerOptoTetMice;
avgBins = cell(1, length(binCenters));
semBins = cell(1, length(binCenters)); % For storing SEM

for i = allMice
    T = timedata{i};
    var = vardata{i}; % assuming size of var is nCells x nTrials
    
    for j = 1:length(T)
        % Find which bin this time point belongs to
        binIdx = find(T(j) >= binEdges(1:end-1) & T(j) < binEdges(2:end), 1);
        if ~isempty(binIdx)
            if isempty(bins{binIdx})
                bins{binIdx} = var(:,j);
            else
                bins{binIdx} = cat(1, bins{binIdx}, var(:,j)); % append data to this bin
            end
        end
    end
end

% Calculate the average and SEM for each bin
for idx = 1:length(binCenters)
    avgBins{idx} = nanmean(bins{idx});
    semBins{idx} = nanstd(bins{idx}) / sqrt(numel(bins{idx}));
end

% Plotting
for idx = 1:length(binCenters)
    RWSCF = scatter(repmat(binCenters(idx), numel(avgBins{idx}), 1), avgBins{idx}, 'Filled', 'MarkerFaceColor', Color, 'MarkerEdgeColor', Color);
    hold on;
    errorbar(binCenters(idx), avgBins{idx}, semBins{idx}, 'LineStyle', 'none', 'Color', Color);
end

% x = [-5 0 0 -5];
% y = [0 0 1 1];
% patch('XData', x, 'YData', y, 'FaceColor', 'black', 'EdgeColor', 'none', 'FaceAlpha', 0.2);
set(gca,'FontSize', 18, 'FontWeight', 'normal'); 
xlabel('Relative Time (min)', 'FontSize', 18);
ylabel('Mean Fluo. (ΔF/F0)', 'FontSize', 18);

xticks([-30 -15 0 15 30 45])
xlim(xlimit)
ylim([-.05 ylimit])

xlabelHandle = xlabel('Time relative to plasticity ind. (min)', 'FontSize', 18);
currentPosition = get(xlabelHandle, 'Position');
set(xlabelHandle, 'Position', [currentPosition(1), currentPosition(2) + 0.03, currentPosition(3)]);

ax = gca;
ticks = ax.XTick;
ticklabels = ax.XTickLabel;

% Create new text labels manually positioned closer to the x-axis
for i = 1:length(ticks)
    text(ticks(i), ax.YLim(1) + (0.015 * range(ax.YLim)), ticklabels(i,:), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'top', ...
        'Clipping', 'on', 'FontSize', 18);
end

% Remove the original x-tick labels
ax.XTickLabel = [];

xline(-5, 'LineStyle', ':', 'LineWidth', 1, 'Color', 'k')
xline(-.5, 'LineStyle', ':', 'LineWidth', 1, 'Color', 'k')

lgd = legend([RWS, RWSCF], {'RWS', 'RWS-CF'});
if whiskerTetMice == 15
    lgd = legend([RWS, RWSCF], {'RWS-CF + DREADD', 'RWS-CF'});
end
    
lgd.Box = 'off';

title(gettitle, 'FontSize', 28)

print('-djpeg', '-r300', savename);


%%%% COMPILE INTO EXCEL DOCUMENT
% Column 1 has all relative times of trials
% Column 2 to Column n stores measurement for each cell for given trial





end