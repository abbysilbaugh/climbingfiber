% Created 7/7/2023
% EDITED 3/19/24
% EDITED 4/5/24

% adds golaysignal (nFrames x nCells x nTrials) to allData variable
% Steps:
    % 1. Background subtract (previously calculated; variable firstprctile is the bottom 1st percentile of signal across entire movie and is subtracted from signal)
    % 2. Smooth trace with Savitsky-Golay filter using window of size smooth_win
    % 3. Calculates baseline F0 for each ROI using percentile specified by b_percent (of smoothed trace) across entire session
        % potential artifact-containing frames are not used in the calculation of the baseline -- COMMENTED OUT 3/19
    % 4. Expresses signal as dF/F0

    % THIS IS BASED ON Helmchen 2019 Nature Communications Pipeline...
        % Background fluorescence (bottom 1st* percentile of signal across entire movie) is subtracted from all trials
        % Smooth trace over 500 msec (equivalent of 15 frames here) window using Savitsky-Golay filter
        % Calculate baseline F0 for each ROI as 1st* percentile of smoothed trace across entire session
        % Express signal as dF/F0

function [allData] = getGOLAY2(allData, b_percent, smooth_win)
% ~ used to refer to artifact_win, not using as of 3/19/24

nMice = size(allData.data, 2);



for i = 1:nMice
    % Subtract 1st percentile value of signal across entire movie % STEP
    % COMPLETED IN compileDataset, rawminusfirstprctile = signal - FIRSTPRCTILEVALUE
    % firstprctile = allData.data{i}.firstprctilevalue;
    % signal = allData.data{i}.signal - firstprctile;

    signal = allData.data{i}.corrected_rawtrace;
    
    [nFrames, nCells, nTrials] = size(signal);
    
    % Smooth signal with golay filter
    smoothsignal = zeros(nFrames, nCells, nTrials);
    for j = 1:nTrials
        for k = 1:nCells
            trace = signal(:, k, j);
            golaytrace = sgolayfilt(trace, 1, smooth_win); % smooth trace over specified window using Savitsky-Golay filter
            smoothsignal(:, k, j) = golaytrace;
        end
    end

    % For each cell, find 5th prctile value across entire session
    smoothcorrsignal = zeros(nFrames, nCells, nTrials);
    for k = 1:nCells
        smoothsignal_cell = smoothsignal(:, k, :);
        smoothsignal_cell = smoothsignal_cell(:);
        prc = prctile(smoothsignal_cell, b_percent);
        for j = 1:nTrials
            trace = smoothsignal(:, k, j);
            trace = (trace - prc)./prc;
            smoothcorrsignal(:, k, j) = trace;
        end
    end

    % Second method... for each cell, find 5th prctile value for each trial
    smoothcorrsignal2 = zeros(nFrames, nCells, nTrials);
    for k = 1:nCells
        for j = 1:nTrials
        smoothsignal_temp = smoothsignal(:, k, j);
        prc = prctile(smoothsignal_temp, b_percent);
        smoothsignal_temp = (smoothsignal_temp - prc)./prc;
        smoothcorrsignal2(:, k, j) = smoothsignal_temp;
        end
    end

    allData.data{i}.golaysignal = smoothcorrsignal;
    allData.data{i}.golaysignal2 = smoothcorrsignal2;

end

end
