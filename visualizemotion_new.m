function visualizemotion_new(allData, trialmottype, prestim_win, poststim_win, showeach, xlimits, choosemottype)

nMice = length(allData.data);
nFrames = size(allData.data{1}.ac_bs_signal, 1);
% nBins = nFrames-1;
allmicehist_mot = zeros(nFrames, nMice);

for i = 1:nMice
    if strcmp(choosemottype, 'motionInfo')
        motion = allData.data{i}.motionInfo;
        trialtype = allData.data{i}.trialmotType;
    elseif strcmp(choosemottype, 'motionInfo_settime')
        motion = allData.data{i}.motionInfo_settime;
        trialtype = allData.data{i}.trialmotType_settime;
    elseif strcmp(choosemottype, 'motionInfo_settime2')
        motion = allData.data{i}.motionInfo_settime2;
        trialtype = allData.data{i}.trialmotType_settime2;
    end

    if strcmp(trialmottype, 'all')
        motion = motion;
        color = [0.5 0.5 0.5];
    elseif strcmp(trialmottype, 'NM')
        nmtrials = strcmp(trialtype, 'NM');
        motion = motion(:, nmtrials);
        color = [40, 62, 74]/255;
    elseif strcmp(trialmottype, 'M')
        mtrials = strcmp(trialtype, 'M');
        motion = motion(:, mtrials);
        color = [0.5 0.5 0.5];
    elseif strcmp(trialmottype, 'T')
        ttrials = strcmp(trialtype, 'T');
        motion = motion(:, ttrials);
        color = [0.5 0.5 0.5];
    elseif strcmp(trialmottype, 'MT')
        mtrials = strcmp(trialtype, 'M');
        ttrials = strcmp(trialtype, 'T');
        gettrials = logical(mtrials + ttrials);
        motion = motion(:, gettrials);
        color = [77, 123, 161]/255;
    elseif strcmp(trialmottype, 'H')
        htrials = strcmp(trialtype, 'H');
        motion = motion(:, htrials);
        color = [86, 202, 193]/255;
    else
        warning('trial type does not exist; plotting all trials')
    end

    [~, nTrials] = size(motion);
    findmot = cell(nTrials, 1);
    for j = 1:nTrials
        m = motion(:, j);
        m = find(m);
        findmot{j} = m;
    end

    % Determine probability of event occurring in each frame
    motvec = cell2mat(findmot);
    probs = zeros(620, 1);
    for j = 1:nFrames
        probs(j) = length(find(motvec == j))/length(motvec);
    end
    
    % Create the figure and store the handle
    fig = figure('Position', [50 50 1500 500]);
    
    % Plot using bar plot
    bar(1:nFrames, probs, 'histc'); % Use 'histc' to align bins with frames
    allmicehist_mot(:, i) = probs;

    % Note: select 'probability' as normalization type to compare across animals
%     h = histogram(motvec, nBins, 'FaceAlpha', 0.2, 'FaceColor', 'k', 'EdgeColor', 'none', 'Normalization', 'probability');
%     allmicehist_mot(:, i) = h.Values;
%     binedges = h.BinEdges;
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

% Create the summary figure
figure('Position', [166,575,158,183]);

% Compute and plot the histogram
allmicehist_mot = sum(allmicehist_mot, 2, 'omitnan') / nMice;
% Plot using bar plot
bar(1:nFrames, allmicehist_mot, 'FaceColor', color, 'FaceAlpha', 1, 'EdgeAlpha', 0, 'BarWidth', 1);


% Add labels and titles
ylabel('P(Motion)', 'FontSize', 12);
xlabel('Time from stimulus onset (s)');
title('');

% Adjust x-axis properties
x = linspace(0, 620, 11);
x = x - 5;
xticks(x);
x2 = linspace(-10, 10, 11);
xticklabels(x2);

% Adjust y-axis properties
yticklabels([]);

% Add rectangles for prestim and poststim windows
getmax = max(allmicehist_mot);
hold on; % Ensure the rectangles are added to the existing plot
rectangle('Position', [prestim_win(1), 0, diff(prestim_win), getmax], ...
    'EdgeColor', 'none', 'FaceColor', [158/255, 189/255, 212/255, .5]);
rectangle('Position', [poststim_win(1), 0, diff(poststim_win), getmax], ...
    'EdgeColor', 'none', 'FaceColor', [158/255, 189/255, 212/255, .5]); % Red rectangle with transparency
hold off;

xlim([xlimits(1)-5, xlimits(2)])
ylim([0, getmax])
xline(305)
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')


end
