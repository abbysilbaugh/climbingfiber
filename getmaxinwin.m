function [allData] = getmaxinwin(allData, frame_win)

nMice = size(allData.data, 2);

for i = 1:nMice
    [~, nCells, nTrials] = size(allData.data{i}.golayshift);

    max_fluo_in_win = zeros(nCells, nTrials);

    for k = 1:nTrials

        for j = 1:nCells
            trace = allData.data{i}.golayshift(frame_win(1):frame_win(2), j, k);
            

            max_fluo_in_win(j, k) = max(trace);
            

        end
    end

    allData.data{i}.mean_fluo_in_win = max_fluo_in_win; % average fluorescence in window
end