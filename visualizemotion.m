function visualizemotion(allData, trialmottype, prestim_win, poststim_win, showeach)

nMice = length(allData.data);
nFrames = size(allData.data{1}.ac_bs_signal, 1);
nBins = nFrames-1;
allmicehist_mot = zeros(nBins, nMice);

for i = 1:nMice
    motion = allData.data{i}.motionInfo;
    trialtype = allData.data{i}.trialmotType;

    if strcmp(trialmottype, 'all')
        motion = motion;
    elseif strcmp(trialmottype, 'NM')
        nmtrials = strcmp(trialtype, 'NM');
        motion = motion(:, nmtrials);
    elseif strcmp(trialmottype, 'M')
        mtrials = strcmp(trialtype, 'M');
        motion = motion(:, mtrials);
    elseif strcmp(trialmottype, 'T')
        ttrials = strcmp(trialtype, 'T');
        motion = motion(:, ttrials);
    end

    [~, nTrials] = size(motion);
    findmot = cell(nTrials, 1);
    for j = 1:nTrials
        m = motion(:, j);
        m = find(m);
        findmot{j} = m;
    end
    

    % Create the figure and store the handle
    fig = figure('Position', [50 50 1500 500]);
    
    % Plot the histogram
    motvec = cell2mat(findmot);

    % Note: select 'probability' as normalization type to compare across animals
    h = histogram(motvec, nBins, 'FaceAlpha', 0.2, 'FaceColor', 'k', 'EdgeColor', 'none', 'Normalization', 'probability');
    allmicehist_mot(:, i) = h.Values;
    binedges = h.BinEdges;
    hold on;
    
    % Add labels and title
    ylabel('Probability');
    x = linspace(0, 620, 11);
    xticks(x);
    x2 = linspace(-10, 10, 11);
    xticklabels(x2);
    yticks([])
    xlabel('Time from Stimulus Onset (s)');
    title(['Mouse ', num2str(i)]);
    
    % Close the current figure if showeach condition is not met
    if ~strcmp(showeach, 'showeach')
        close(fig); % Close only the specific figure created
    end

    
end

% Create the figure
figure('Position', [50 50 1500 500]);

% Compute and plot the histogram
allmicehist_mot = sum(allmicehist_mot, 2) / nMice;
histogram('BinEdges', binedges, 'BinCounts', allmicehist_mot, ...
    'FaceAlpha', 0.5, 'FaceColor', 'k', 'EdgeColor', 'none');

% Add labels and titles
ylabel('Probability', 'FontSize', 12);
xlabel('Time from stimulus onset (s)');
title('Running behavior');

% Adjust x-axis properties
x = linspace(0, 620, 11);
xlim([0 620]);
xticks(x);
x2 = linspace(-10, 10, 11);
xticklabels(x2);

% Adjust y-axis properties
yticklabels([]);

% Add rectangles for prestim and poststim windows
hold on; % Ensure the rectangles are added to the existing plot
rectangle('Position', [prestim_win(1), 0, diff(prestim_win), max(allmicehist_mot)], ...
    'EdgeColor', 'none', 'FaceColor', [0 0 1 0.2]); % Blue rectangle with transparency
rectangle('Position', [poststim_win(1), 0, diff(poststim_win), max(allmicehist_mot)], ...
    'EdgeColor', 'none', 'FaceColor', [1 0 0 0.2]); % Red rectangle with transparency
hold off;


end
