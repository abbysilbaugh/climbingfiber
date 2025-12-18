% adds to allData.data{mouse}...
  % amps (nCells x nTrials)
  % pkLocs (nCells x nTrials)
  % spkLocs (nCells x nTrials)
  % firstspike (nCells x nTrials)
  % firstpeaktime (nCells x nTrials)
  % firstpeakamp (nCells x nTrials)
  % firstpeakprom (nCells x nTrials)
  % firstpeakwidth (nCells x nTrials)
    
function [allData] = getallpeaks(allData, peaks_prom, peaks_height, baselineNoise, stim_onset, signaltype, showplot)

nMice = size(allData.data, 2);

for i = 1:nMice
    % Select which trace to use
    if strcmp(signaltype, 'golayshift')
        signal = allData.data{i}.golayshift;
    elseif strcmp(signaltype, 'golaysignal')
        signal = allData.data{i}.golaysignal;
    elseif strcmp(signaltype, 'golaysignal2')
        signal = allData.data{i}.golaysignal2;
    elseif strcmp(signaltype, 'golaysignal1')
        signal = allData.data{i}.golaysignal1;
    elseif strcmp(signaltype, 'golaysignal4')
        signal = allData.data{i}.golaysignal4;
    end
    spiketimes = allData.data{i}.spiketimes;

    nNeurons = size(signal, 2);
    nTrials = size(signal, 3);
    
    amps = cell(nNeurons, nTrials);
    pkLocs = cell(nNeurons, nTrials);
    prom = cell(nNeurons, nTrials);
    width = cell(nNeurons, nTrials);
    firstspike = cell(nNeurons, nTrials);
    firstpeaktime = cell(nNeurons, nTrials);
    firstpeakamp = cell(nNeurons, nTrials);
    firstpeakwidth = cell(nNeurons, nTrials);
    firstpeakprom = cell(nNeurons, nTrials);
    spkLocs = cell(nNeurons, nTrials);

    for j = 1:nNeurons
        bNoise = baselineNoise{i}{j};
        for k = 1:nTrials

            trace = signal(:, j, k);
            spikes = spiketimes(:, j, k);

            % Find spkLocs
            spktime = find(spikes);
            for f = 1:length(spktime)
                tempspk = spktime(f);
                if tempspk > 614 || tempspk < 6 % get rid of edge cases
                    spktime(f) = NaN;
                end
            end

            spkLocs{j, k} = spktime;

            % Find all peaks in trial with peak prominence greater than peaks_prom*bNoise
            if isnan(peaks_height)
                [amps{j, k}, pkLocs{j, k}, width{j, k}, prom{j, k}] = findpeaks(trace, 'MinPeakProminence', peaks_prom*bNoise); %, 'MinPeakHeight', peaks_height);
            else
                [amps{j, k}, pkLocs{j, k}, width{j, k}, prom{j, k}] = findpeaks(trace, 'MinPeakProminence', peaks_prom*bNoise,'MinPeakHeight', peaks_height);
            end

            curr_pkLocs = pkLocs{j, k};
            curr_amps = amps{j, k};
            curr_width = width{j, k};
            curr_prom = prom{j, k};
            post_pkLocs = curr_pkLocs(curr_pkLocs > stim_onset);

            % Find the first peak after stim onset if it exists
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
    allData.data{i}.spkLocs = spkLocs;
    allData.data{i}.firstspike = firstspike;
    allData.data{i}.firstpeaktime = firstpeaktime;
    allData.data{i}.firstpeakamp = firstpeakamp;
    allData.data{i}.firstpeakprom = firstpeakprom;
    allData.data{i}.firstpeakwidth = firstpeakwidth;

    if strcmp(showplot, 'yesplot')
            figure;
            binedges = linspace(stim_onset, 620, (620-stim_onset+1));
            vector = cell2mat(allData.data{i}.firstspike); 
            vector = vector(:);
            histogram(vector, 'BinEdges', binedges, 'FaceAlpha', 0.2, 'FaceColor', 'k', 'EdgeColor', 'none')
            hold on
            xline(stim_onset, 'LineWidth', 2)
            xticks([stim_onset, stim_onset + 31, stim_onset + 62, stim_onset + 93, stim_onset + 124, stim_onset + 155, stim_onset + 186, stim_onset + 217, stim_onset + 248, stim_onset + 279, stim_onset + 310])
            xticklabels([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            ylabel('Event Count', 'FontSize', 15, 'FontWeight', 'bold')
            xlim([stim_onset-15.5, stim_onset + 10*31])
            
        
            xlabel('Latency to First Spike (s)', 'FontSize', 15, 'FontWeight', 'bold')
            ylabel('Event Count')
            title('Global Latency to First Spike')
    end


end

end