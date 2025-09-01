% adds new variables...
    % pks_win
    % spks_win

function [pks_win, spks_win] = visualizealleventsbymouse(allData, std_thresh, showeach)

nMice = length(allData.data);
nFrames = size(allData.data{1}.ac_bs_signal, 1);
allmicehist_spks = zeros(nFrames, nMice);
allmicehist_pks = zeros(nFrames, nMice);
% nBins = nFrames;
% allmicehist_spks = zeros(nBins, nMice);
% allmicehist_pks = zeros(nBins, nMice);

    
for i = 1:nMice
    [~, nCells, nTrials] = size(allData.data{i}.golayshift);
    
    spkLocs = allData.data{i}.spkLocs;
    pkLocs = allData.data{i}.pkLocs;
    spikevec = spkLocs(:); 
    spikevec = cell2mat(spikevec);
    spikevec = spikevec(~isnan(spikevec));
    peakvec = pkLocs(:); 
    peakvec = cell2mat(peakvec);
    peakvec = peakvec(~isnan(peakvec));

    % Determine probability of event occurring in each frame
    prob_spike = zeros(620, 1);
    for j = 1:nFrames
        prob_spike(j) = length(find(spikevec == j))/length(spikevec);
    end

    prob_peak = zeros(620, 1);
    for j = 1:nFrames
        prob_peak(j) = length(find(peakvec == j))/length(peakvec);
    end

    allmicehist_spks(:, i) = prob_spike;
    allmicehist_pks(:, i) = prob_peak;

    if strcmp(showeach, 'showeach')
    % Plot using bar plot
    figure('Position', [166,623,158,135]);
    bar(1:nFrames, prob_spike, 'histc'); % Use 'histc' to align bins with frames
    hold on
    bar(1:nFrames, prob_peak, 'histc'); % Use 'histc' to align bins with frames

%     h = histogram(spikevec, 'BinEdges', binedges, 'FaceAlpha', 0.3, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'Normalization', 'probability');
%     allmicehist_spks(:, i) = h.Values;
%     hold on
%     pkvec = pkLocs(:); 
%     pkvec = cell2mat(pkvec); 
%     pkvec = pkvec(~isnan(pkvec));
%     h = histogram(pkvec, 'BinEdges', binedges, 'FaceAlpha', 0.3, 'FaceColor', 'k', 'EdgeColor', 'none','Normalization', 'probability');
%     allmicehist_pks(:, i) = h.Values;

    legend('Spike', 'Peak')
    ylabel('Event probability')
    x = linspace(0, 620, 11);
    xticks(x-5)
    x2 = linspace(-10, 10, 11);
    xticklabels(x2)
    xlabel('Time from Stimulus Onset (s)')
    %title(['Mouse ', num2str(i)])
    end
    
end

% Plot summary data
figure('Position', [166,575,158,183]);
allmicehist_pks = sum(allmicehist_pks, 2)/nMice;
allmicehist_spks = sum(allmicehist_spks, 2)/nMice;
bar(1:nFrames, prob_spike, 'FaceColor', 'k', 'FaceAlpha', 0.5, 'EdgeAlpha', 0, 'BarWidth', 1);
hold on
%bar(1:nFrames, prob_peak, 'FaceColor', 'b', 'FaceAlpha', 0.5, 'EdgeAlpha', 0, 'BarWidth', 1);
% histogram('BinEdges', binedges, 'BinCounts', allmicehist_spks, 'FaceAlpha', 0.3, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none')
% hold on
% histogram('BinEdges', binedges, 'BinCounts', allmicehist_pks, 'FaceAlpha', 0.3, 'FaceColor', 'k', 'EdgeColor', 'none')
%legend('Spike', 'Peak', 'FontSize', 12, 'location', 'best', 'Box', 'off')
ylabel('Norm. event count', 'FontSize', 12)
x = linspace(0, 620, 11);
xticks(x-5)
x2 = linspace(-10, 10, 11);
xticklabels(x2)
xlim([243 367])
xlabel('Time from stimulus onset (s)')
title('')

% Find frames with probability of spike or peak above std_thresh*std above mean
pk_mean = mean(allmicehist_pks); pk_std = std(allmicehist_pks);
spk_mean = mean(allmicehist_spks(6:614));  spk_std = std(allmicehist_spks(6:614)); % ignore edge cases
pks_win = find(allmicehist_pks > pk_mean + std_thresh*pk_std);
spks_win = find(allmicehist_spks > spk_mean + std_thresh*spk_std);

% Ensure pks_win and spks_win contain consecutive frames
temp = pks_win(1);
temp2 = linspace(temp, temp+length(pks_win)-1, length(pks_win))';
temp3 = pks_win == temp2;
pks_win = pks_win(temp3);
pks_win = [min(pks_win), max(pks_win)];

% % Find frames with probability of spike or peak above std_thresh*std of specified spont period
% temp = ones(nFrames, 1);
% temp(1:61) = 0;
% temp(nFrames - 61) = 0;
% temp(154:465) = 0;
% temp = logical(temp);
% allmicehist_pks_spont = allmicehist_pks(temp);
% allmicehist_pks_spont_mean = mean(allmicehist_pks_spont);
% allmicehist_pks_spont_std = std(allmicehist_pks_spont);
% pks_window_thresh = allmicehist_pks_spont_mean + std_thresh*allmicehist_pks_spont_std;
% pks_win = find(allmicehist_pks > pks_window_thresh);
% 
% allmicehist_spks_spont = allmicehist_spks(temp);
% allmicehist_spks_spont_mean = mean(allmicehist_spks_spont);
% allmicehist_spks_spont_std = std(allmicehist_spks_spont);
% spks_window_thresh = allmicehist_spks_spont_mean + std_thresh*allmicehist_spks_spont_std;
% spks_win = find(allmicehist_spks > spks_window_thresh);



ylimit = max(allmicehist_pks);

%rectangle('Position', [pks_win(1), 0, pks_win(2)-pks_win(1), ylim], 'FaceColor', [0/255, 130/255, 230/255, 0.2], 'EdgeColor', 'none')
%text(sprintf((pks_win(1)-pks_win(2))*32.2581), 'HorizontalAlignment', 'center', 'FontSize', 12)
yticklabels([])
temp = spks_win(1);
temp2 = linspace(temp, temp+length(spks_win)-1, length(spks_win))';
temp3 = spks_win == temp2;
spks_win = spks_win(temp3);
spks_win = [min(spks_win), max(spks_win)];
spks_win(1) = spks_win(1) - 1; % CORRECTED 20250825
yticks([])
rectangle('Position', [spks_win(1), 0, spks_win(2)-spks_win(1), ylimit], 'FaceColor', [0 0 1 0.3], 'EdgeColor', 'none')
ylim([0 ylimit])
set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
end