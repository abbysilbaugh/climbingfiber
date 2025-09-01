% adds to allData.data{mouse}...
    % evokedtraces (nFrames x nCells x nTrials)


function allData = getevokedtraces_byspike(allData, evoked_win)

nMice = length(allData.data);
for i = 1:nMice
    signal = allData.data{i}.golayshift;
    spikes = allData.data{i}.s_oasis;

    [nFrames, nCells, nTrials] = size(signal);
    evokedtraces = zeros(nFrames, nCells, nTrials);
    for j = 1:nCells
        for k = 1:nTrials
            trace = signal(:, j, k);
            spike = spikes(evoked_win(1):evoked_win(2), j, k);
            if sum(spike) > 0 %if sum(spike) >= 1
                evokedtraces(:, j, k) = trace;
            else
                evokedtraces(:, j, k) = NaN(nFrames, 1);
            end
        end
    end

    allData.data{i}.evokedtraces = evokedtraces;
end

end