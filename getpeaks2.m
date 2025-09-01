% edited 3/1/24

function [allData] = getpeaks2(allData, peaks_thr, baselineNoise, stim_onset)

nMice = size(allData.data, 2);

for i = 1:nMice
    golayshift = allData.data{i}.golayshift;
    spiketimes = allData.data{i}.spiketimes;

    nNeurons = size(golayshift, 2);
    nTrials = size(golayshift, 3);
    
    amps = cell(nNeurons, nTrials);
    pkLocs = cell(nNeurons, nTrials);
    prom = cell(nNeurons, nTrials);
    width = cell(nNeurons, nTrials);
    firstspike = cell(nNeurons, nTrials);
    firstpeaktime = cell(nNeurons, nTrials);
    firstpeakamp = cell(nNeurons, nTrials);
    firstpeakwidth = cell(nNeurons, nTrials);
    firstpeakprom = cell(nNeurons, nTrials);

    for j = 1:nNeurons
        bNoise = baselineNoise{i}{j};
        for k = 1:nTrials

            trace = golayshift(:, j, k);
            spikes = spiketimes(:, j, k);

            [amps{j, k}, pkLocs{j, k}, width{j, k}, prom{j, k}] = findpeaks(trace, 'MinPeakProminence', peaks_thr*bNoise, 'MinPeakHeight', 0.2);

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

    vector = cell2mat(allData.data{i}.firstspike); vector = vector(:); histogram(vector, 100, 'FaceAlpha', 0.2, 'FaceColor', 'k')
    hold on
    xline(310, 'LineWidth', 2)

    xlabel('Frame # of First Spike')
    ylabel('Event Count')
    title('Global Latency to First Spike')


end



end