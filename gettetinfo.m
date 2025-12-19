function [allData] = gettetinfo(allData)

fr_dur = 0.03228; % duration of 1 frame in seconds

nMice = size(allData.data, 2);

for i = 1:nMice

    tetPeriod = allData.data{i}.tetPeriod;

    tetTrials = strcmp(tetPeriod, 'TET');

    nCells = length(allData.data{i}.cellType);
    

    spikes = allData.data{i}.spiketimes(:, :, tetTrials);
    motion = allData.data{i}.motionInfo(:, tetTrials);
    traces = allData.data{i}.golayshift(:, :, tetTrials);

    tet_spike_rate = zeros(nCells, 1);
    tet_mu_fluo = zeros(nCells, 1);
    tet_stdev_fluo = zeros(nCells, 1);


    for j = 1:nCells

        if isempty(spikes)
            tet_spike_rate(j) = NaN;
            tet_mu_fluo(j) = NaN;
            tet_stdev_fluo(j) = NaN;
        else

            

            spk = spikes(:, j, :);
            spk = reshape(spk, 1, []);

            trc = traces(:, j, :);
            trc = reshape(trc, 1, []);

            tet_mu_fluo(j) = mean(trc);

            tet_stdev_fluo(j) = std(trc);

            dur = length(spk) * fr_dur;

            tet_spike_rate(j) = sum(spk)/dur;

           
        end

    end

    if isempty(motion)
        tet_motion_rate = NaN;
    else
        motion = reshape(motion, 1, []);
        tet_motion_rate = sum(motion)/dur;
    end


    allData.data{i}.tet_motion_rate = tet_motion_rate;
    allData.data{i}.tet_spike_rate = tet_spike_rate;
    allData.data{i}.tet_mu_fluo = tet_mu_fluo;
    allData.data{i}.tet_stdev_fluo = tet_stdev_fluo;

end



end