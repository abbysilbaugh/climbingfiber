function [baselineNoise, SNR] = getbaselinenoise_fast(allData, noise_prc, sig_prc, tracetype, seconds)

% Helmchen 2019
% 1. Background subtract (bottom 1st prctile of fluorescence signal across entire movie is subtracted from all trials)
% 2. Smooth trace using 51 point 1st order Savitsky-Golay filter
% 3. Calculate baseline (F0) as 1st prctile from entire session (using smoothed)
% 4. Express trace as ΔF/F = F-F0/F0
% Calculate baseline noise (σ) as stdev of fluorescence change during least noisy 5 sec period (1st prctile)
% SNR is 95th prctile of ΔF/F signals from session divided by σ
% Event is 2x σ

% Current pipeline
% 1. Smooth trace (getGOLAY function)
% 2. Calculate baseline using b_percent (getGOLAY function) across session
% 3. Subtract baseline from traces (getGOLAY function)
% 4. Calculate baseline noise in current function

windowSize = seconds * 31; % Window size of 5 seconds given 31 fps frame rate

nMice = length(allData.data);
baselineNoise = cell(nMice, 1);
SNR = cell(nMice, 1);

for i = 1:nMice
    nTrials = length(allData.data{i}.trialType);
    nCells = length(allData.data{i}.cellType);
    nFrames = size(allData.data{i}.golaysignal, 1);
    
    baselineNoise{i} = cell(nCells, 1);
    SNR{i} = cell(nCells, 1);

    for j = 1:nCells
        switch tracetype
            case 'golaysignal'
                longtrace = squeeze(allData.data{i}.golaysignal(:, j, :));
            case 'golaysignal2'
                longtrace = squeeze(allData.data{i}.golaysignal2(:, j, :));
            case 'golaysignal3'
                longtrace = squeeze(allData.data{i}.golaysignal3(:, j, :));
            case 'golaysignal4'
                longtrace = squeeze(allData.data{i}.golaysignal4(:, j, :));
        end
        longtrace = longtrace(:);

        % Get 95th percentile signal across entire session
        sig95 = prctile(longtrace, sig_prc);

        % Calculate sliding window standard deviations more efficiently
        STDEVs = movstd(longtrace, windowSize, 'Endpoints', 'discard');

        % Get the 1st percentile of the standard deviations
        sigma = prctile(STDEVs, noise_prc);

        SNR{i}{j} = sig95 / sigma;
        baselineNoise{i}{j} = sigma;

        if isnan(sigma)
            warning('sigma = NaN');
        end
    end
end
end
