% Created 9/9/24

function allData = getevokedtraces2(allData, evoked_win, baselineNoise, thr)

nMice = length(allData.data);
for i = 1:nMice
    signal = allData.data{i}.golayshift;
    %spikes = allData.data{i}.s_oasis;

    [nFrames, nCells, nTrials] = size(signal);
    evokedtraces = zeros(nFrames, nCells, nTrials);
    for j = 1:nCells
        bN_temp = baselineNoise{i}{j};

        for k = 1:nTrials
            trace = signal(:, j, k);
            trace_win = signal(evoked_win(1):evoked_win(2));
            max_trace_win = max(trace_win);
            min_trace_win = min(trace_win);

            if (max_trace_win - min_trace_win) > thr*bN_temp
                evokedtraces(:, j, k) = trace;
            else
                evokedtraces(:, j, k) = NaN(nFrames, 1);
            end
        end
    end

    allData.data{i}.evokedtraces2 = evokedtraces;
end

end