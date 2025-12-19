% adds to allData.data{mouse}...    
        % spont_rate (nCells x nTrials)
        % spont_rate_norm (nCells x nTrials)
        % spont_rate_running (nCells x nTrials)
        % spont_rate_rest (nCells x nTrials)
        % mean_fluo_running (nCells x nTrials)
        % mean_fluo_rest (nCells x nTrials)
        % modulationidx (nCells x nTrials)


function [allData] = getspontinfo(allData, spike_win)

spontFrames = true(620, 1); 
spontFrames(spike_win(1):spike_win(2)) = false;

% 30.98 frames/second
% 1 frame = 32.28 msec (0.03228 seconds)

nMice = size(allData.data, 2);

for i = 1:nMice
    spiketimes = allData.data{i}.spiketimes;
    trace = allData.data{i}.golayshift;
    running = allData.data{i}.running;
    motionInfo = allData.data{i}.motionInfo;

    [~, nCells, nTrials] = size(spiketimes);

    mot_rate = zeros(nTrials, 1);
    spont_rate = zeros(nCells, nTrials);
    spont_rate_norm = zeros(nCells, nTrials);
    spont_rate_running = zeros(nCells, nTrials);
    spont_rate_rest = zeros(nCells, nTrials);
    mean_fluo_running = zeros(nCells, nTrials);
    mean_fluo_rest = zeros(nCells, nTrials);

    modulationidx = zeros(nCells, 1);

    for j = 1:nCells
        for k = 1:nTrials

            % get spont spike rate and mot rate for each trial
            n_spontspikes = sum(spiketimes(spontFrames, j, k));
            n_spont_mot = sum(motionInfo(spontFrames, k));
            sponttime = sum(spontFrames) * 0.03228; % spont time period in seconds

            mot_rate(k) = n_spont_mot/sponttime;
            spont_rate(j, k) = n_spontspikes/sponttime; % spontaneous firing rate in Hz

            if mot_rate(k) > 0
                spont_rate_norm(j,k) = spont_rate(j,k)/mot_rate(k);
            end

            % get spont spike rate for each trial only during run periods
            runframes = spontFrames & running(:, k);
            n_runspikes = sum(spiketimes(runframes, j, k));
            runtime = sum(runframes) * 0.02338;
            mean_run = mean(trace(runframes, j, k));

            % If there is no run period in a given trial, it gets a NaN
            if runtime == 0
                spont_rate_running(j, k) = NaN;
                mean_fluo_running(j, k) = NaN;
            else
                spont_rate_running(j, k) = n_runspikes/runtime;
                mean_fluo_running(j,k) = mean_run;
            end

            % get spont spike rate for each trial only during rest periods
            restframes = spontFrames & ~running(:, k);
            n_restspikes = sum(spiketimes(restframes, j, k));
            resttime = sum(restframes) * 0.02338;
            mean_rest = mean(trace(restframes, j, k));

            % If there is no rest period in a given trial
            if resttime == 0
                spont_rate_rest(j, k) = NaN;
                mean_fluo_rest(j,k) = NaN;
            else
                spont_rate_rest(j, k) = n_restspikes/resttime;
                mean_fluo_rest(j,k) = mean_rest;
            end

        end

    % Calculate modulation index (mean fluo run - mean fluo rest)/(mean fluo run + mean fluo rest) across all trials
    % Normalize by amount of motion in the same periods? Have to do this above using motionInfo...

    mu_run = mean_fluo_running(j, :);
    mu_run = mu_run(~isnan(mu_run));
    mu_run = mean(mu_run);
    mu_rest = mean_fluo_rest(j, :);
    mu_rest = mu_rest(~isnan(mu_rest));
    mu_rest = mean(mu_rest);
    modulationidx(j) = (mu_run - mu_rest) / (mu_run + mu_rest);
    

    end

    allData.data{i}.spont_rate = spont_rate;
    allData.data{i}.spont_rate_running = spont_rate_running;
    allData.data{i}.spont_rate_rest = spont_rate_rest;
    allData.data{i}.mean_fluo_running = mean_fluo_running;
    allData.data{i}.mean_fluo_rest = mean_fluo_rest;
    allData.data{i}.modulationidx = modulationidx;
    allData.data{i}.spont_rate_norm = spont_rate_norm;

end