% Gets all events in specified window

function allData = getwindowevents(allData, spike_win, peak_win)

nMice = length(allData.data);

for i = 1:nMice
    peak_locs = allData.data{i}.pkLocs;
    spike_locs = allData.data{i}.spkLocs;
    amplitudes = allData.data{i}.amps;

    [nCells, nTrials] = size(peak_locs);

    evoked_pkLocs = cell(nCells, nTrials);
    evoked_spkLocs = cell(nCells, nTrials);
    evoked_amps = cell(nCells, nTrials);
    maxevoked_amp = zeros(nCells, nTrials);
    maxevoked_pkLoc = zeros(nCells, nTrials);
    sumevoked_spks = zeros(nCells, nTrials);
    for j = 1:nCells
        for k = 1:nTrials
            locs = peak_locs{j, k};
            spklocs = spike_locs{j, k};
            amps = amplitudes{j, k};
            evokedlocs = find(locs > peak_win(1) & locs < peak_win(2));
            evokedspklocs = find(spklocs > spike_win(1) & spklocs < spike_win(2));
            locs = locs(evokedlocs);
            amps = amps(evokedlocs);
            spklocs = spklocs(evokedspklocs);
            evoked_pkLocs{j, k} = locs; % all peaks within window
            evoked_spkLocs{j, k} = spklocs; % all spikes within window
            evoked_amps{j, k} = amps; % all amps within window

            % Find max peak
            if length(amps) < 1
                maxevoked_pkLoc(j, k) = NaN;
                sumevoked_spks(j, k) = NaN;
                maxevoked_amp(j, k) = NaN;
            elseif length(amps) == 1
                maxevoked_pkLoc(j, k) = NaN;
                sumevoked_spks(j, k) = length(spklocs);
                maxevoked_amp(j, k) = amps;
            else
                temploc = find(max(amps));
                maxevoked_pkLoc(j, k) = locs(temploc); % location of max peak in window
                sumevoked_spks(j, k) = length(spklocs); % sum of spikes in window 
                maxevoked_amp(j, k) = amps(temploc); % amp of max peak in window
            end
        end
    end 

allData.data{i}.evoked_pkLocs = evoked_pkLocs; % nCells x nTrials cell array
allData.data{i}.evoked_spkLocs = evoked_spkLocs; % nCells x nTrials cell array
allData.data{i}.evoked_amps = evoked_amps; % nCells x nTrials cell array 
allData.data{i}.maxevoked_pkLoc = maxevoked_pkLoc; % nCells x nTrials double
allData.data{i}.maxevoked_amp = maxevoked_amp; % nCells x nTrials double
allData.data{i}.sumevoked_spk = sumevoked_spks; % nCells x nTrials double


end

end
