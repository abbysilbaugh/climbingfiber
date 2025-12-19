function [allData] = getmean(allData, frame_win)

nMice = size(allData.data, 2);

for i = 1:nMice
    [~, nCells, nTrials] = size(allData.data{i}.golayshift);

    mean_fluo_in_win = zeros(nCells, nTrials);
    mean_num_mot = zeros(nTrials, 1);

    for k = 1:nTrials

        mot = allData.data{i}.motionInfo(frame_win(1):frame_win(2), k);

        mean_num_mot(k) = sum(mot);

        for j = 1:nCells
            trace = allData.data{i}.golayshift(frame_win(1):frame_win(2), j, k);
            

            mean_fluo_in_win(j, k) = mean(trace);
            

        end
    end

    allData.data{i}.mean_fluo_in_win = mean_fluo_in_win; % average fluorescence in window
    allData.data{i}.mean_num_mot = mean_num_mot; % number of mot frames in window

end