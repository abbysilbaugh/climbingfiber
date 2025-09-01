% adds to allData.data{mouse}...
    % evokedtraces2 (nFrames x nCells x nTrials)

function allData = getevokedtraces_bypeak(allData, evoked_win)

nMice = length(allData.data);
for i = 1:nMice
    signal = allData.data{i}.golayshift;
    pkLocs = allData.data{i}.pkLocs;

    [nFrames, nCells, nTrials] = size(signal);
    evokedtraces = zeros(nFrames, nCells, nTrials);
    for j = 1:nCells
        for k = 1:nTrials
            pkLocs_temp = pkLocs{j, k};
            pks = find(pkLocs_temp >= evoked_win(1) & pkLocs_temp <= evoked_win(2));
            trace = signal(:, j, k);
            if length(pks) >= 1
                evokedtraces(:, j, k) = trace;
            else
                evokedtraces(:, j, k) = NaN(nFrames, 1);
            end
        end
    end

    allData.data{i}.evokedtraces2 = evokedtraces;
end

end