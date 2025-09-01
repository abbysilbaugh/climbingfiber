% edited 3/1/24

function [allData] = getpeaks_newer(allData, peaks_thr, baselineNoise, stim_onset)

nMice = size(allData.data, 2);
nBins = 620;

allmicehist_spks = zeros(nBins, nMice);
allmicehistpks = zeros(nBins, nMice);

for i = 1:nMice
    golayshift = allData.data{i}.golayshift;
    spiketimes = allData.data{i}.spiketimes;

    [~, nCells, nTrials] = size(golayshift);
    
    amps = cell(nCells, nTrials);
    pkLocs = cell(nCells, nTrials);
    spkLocs = cell(nCells, nTrials);
    prom = cell(nCells, nTrials);
    width = cell(nCells, nTrials);
    
    firstspike = cell(nCells, nTrials);
    firstpeaktime = cell(nCells, nTrials);
    firstpeakamp = cell(nCells, nTrials);
    firstpeakwidth = cell(nCells, nTrials);
    firstpeakprom = cell(nCells, nTrials);

    for j = 1:nCells
        bNoise = baselineNoise{i}{j};
        for k = 1:nTrials

            trace = golayshift(:, j, k);
            spikes = spiketimes(:, j, k);
            spktime = find(spikes);
            spkLocs{j, k} = spktime;

            [amps{j, k}, pkLocs{j, k}, width{j, k}, prom{j, k}] = findpeaks(trace, 'MinPeakProminence', peaks_thr*bNoise);

            curr_pkLocs = pkLocs{j, k};
            curr_amps = amps{j, k};
            curr_width = width{j, k};
            curr_prom = prom{j, k};
            post_pkLocs = curr_pkLocs(curr_pkLocs > stim_onset);

            if ~isempty(post_pkLocs)
                firstpeaktime{j, k} = post_pkLocs(1);

                peakIndex = find(curr_pkLocs == post_pkLocs(1), 1);

                firstpeakamp{j, k} = curr_amps(peakIndex);
                firstpeakwidth{j, k} = curr_width(peakIndex);
                firstpeakprom{j, k} = curr_prom(peakIndex);
            else
                firstpeaktime{j, k} = NaN;
                firstpeakamp{j, k} = NaN;
                firstpeakwidth{j, k} = NaN;
                firstpeakprom{j, k} = NaN;
            end

            poststimspikes = find(spikes(stim_onset+1:end) == 1); 
            
            if isempty(poststimspikes)
                firstspike{j, k} = NaN;
            else
                firstspike{j, k} = poststimspikes(1) + stim_onset; % Adjust for the indexing starting from stim_onset
            end


        end
    end

    allData.data{i}.amps = amps;
    allData.data{i}.pkLocs = pkLocs;
    allData.data{i}.firstspike = firstspike;
    allData.data{i}.firstpeaktime = firstpeaktime;
    allData.data{i}.firstpeakamp = firstpeakamp;
    allData.data{i}.firstpeakprom = firstpeakprom;
    allData.data{i}.firstpeakwidth = firstpeakwidth;
    allData.data{i}.spiketimes_frames = spkLocs;

%   vector = cell2mat(allData.data{i}.firstspike); vector = vector(:);
%   histogram(vector, 100, 'FaceAlpha', 0.2, 'FaceColor', 'k')
%   hold on
%   xline(310, 'LineWidth', 2)
% 
%   xlabel('Frame # of First Spike')
%   ylabel('Event Count')
%   title('Global Latency to First Spike')

    figure;
    spikevec = spkLocs(:); spikevec = cell2mat(spikevec); h = histogram(spikevec, nBins, 'FaceAlpha', 0.3, 'FaceColor', 'b', 'EdgeColor', 'none', 'Normalization', 'pdf');
    allmicehist_spks(:, i) = h.Values;
    binedges = h.BinEdges;
    hold on
    pkvec = pkLocs(:); pkvec = cell2mat(pkvec); h = histogram(pkvec, nBins, 'FaceAlpha', 0.3, 'FaceColor', 'r', 'EdgeColor', 'none', 'Normalization', 'pdf')
    allmicehistpks(:, i) = h.Values;
    xline(310, 'Color', 'r')
end

figure;
allmicehistpks = sum(allmicehistpks, 2)/nMice;
allmicehist_spks = sum(allmicehist_spks, 2)/nMice;
histogram('BinEdges', binedges, 'BinCounts', allmicehistpks, 'FaceAlpha', 0.2, 'FaceColor', 'k', 'EdgeColor', 'none')
hold on
histogram('BinEdges', binedges, 'BinCounts', allmicehist_spks, 'FaceAlpha', 0.4, 'FaceColor', 'r', 'EdgeColor', 'none')
legend

end