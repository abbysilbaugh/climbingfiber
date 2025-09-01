function [allData] = getmeandiff(allData, frame_win_before, frame_win_after)

nMice = size(allData.data, 2);

for i = 1:nMice
    [~, nCells, nTrials] = size(allData.data{i}.golayshift);

    mean_fluo_diff = zeros(nCells, nTrials);

    for k = 1:nTrials

        for j = 1:nCells
            trace_before = allData.data{i}.golayshift(frame_win_before(1):frame_win_before(2), j, k);
            trace_after = allData.data{i}.golayshift(frame_win_after(1):frame_win_after(2), j, k);
            
            mean_fluo_diff(j, k) = abs(mean(trace_after)-mean(trace_before)/mean(trace_before));
            

        end
    end

    allData.data{i}.mean_fluo_diff = mean_fluo_diff; % average fluorescence in window

end