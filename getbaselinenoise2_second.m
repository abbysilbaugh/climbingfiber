% Edited 9/2/2023
% baselineNoise and SNR are nMice x 1 cell array


function [baselineNoise2, SNR2] = getbaselinenoise2_second(allData, noise_prc, sig_prc)

% Helmchen 2019
    % 1. Background subtract (bottom 1st prctile of fluorescence signal across entire movie is subtracted from all trials)
            %%% Assume they mean taking the bottom 1st prctile signal from the entire FOV?
    % 2. Smooth trace using 51 point 1st order Savitsky-Golay filter
    % 3. Calculate baseline (F0) as 1st prctile from entire session (using smoothed)
    % 4. Express trace as ΔF/F = F-F0/F0
    % Calculate baseline noise (σ) as stdev of fluorescence change during least noisy 5 sec period (1st prctile)
        %  assumed to mean they get all the stdevs for 5-s segments, then take the 1st percentile stdev
    % SNR is 95th prctile of ΔF/F signals from session divided by σ
    % Event is 2x σ

% Current pipeline
    % 1. Smooth trace (getGOLAY function)
    % 2. Calculate baseline using b_percent (getGOLAY function) across session
    % 3. Subtract baseline from traces (getGOLAY function)
    % 4. Calculate baseline noise in current function

windowSize = 5 * 31; % Window size of 5 seconds given 31 fps frame rate

nMice = length(allData.data);
baselineNoise2 = cell(nMice, 1);
SNR2 = cell(nMice, 1);


% Find 1st prctile of all stdevs across windows and trials (σ)
% Also find 95th prctile of dF/F0 signal across trials (numerator of SNR)
for i = 1:nMice
    nTrials = length(allData.data{i}.trialType);
    nCells = length(allData.data{i}.cellType);
    nFrames = size(allData.data{i}.golaysignal2, 1);
    
    baselineNoise2{i} = cell(nCells, 1);
    SNR2{i} = cell(nCells, 1);
    for j = 1:nCells
        longtrace = allData.data{i}.golaysignal2(:, j, :);
        longtrace = reshape(longtrace, [], 1);

        % Get 95th percentile signal across entire session (or percentage specified by sig_prc) 
        sig95 = prctile(longtrace, sig_prc);

        % Create sliding window to collect STD for each 5-second window (windowSize)
        % Calculate nBins
        nBins = nTrials * nFrames - windowSize + 1;
        STDEVs = zeros(nBins, 1);
        for k = 1:nBins
            STDEVs(k) = std(longtrace(k:windowSize+k-1));
        end

        sigma = prctile(STDEVs, noise_prc);
        
        SNR2{i}{j} = sig95;
        baselineNoise2{i}{j} = sigma;

    end
end
end
        
        
%         nWindowsPerTrial = floor(nFrames/windowSize);
% 
%         allNoiseMetrics = zeros(nWindowsPerTrial*nTrials, 1); % an array to store all the noise metrics for all trials
% 
% 
%         noiseMetricIndex = 1;
%         
%         % Get 95th percentile dF/F0 value
%         sig95 = allData.data{i}.golaysignal(:, j, :);
%         sig95 = prctile(sig95(:), sig_prc); % vectorize the signal to get prctile across all trials
% 
%         for k = 1:nTrials
% 
%             golaytrace = allData.data{i}.golaysignal(:, j, k);
%             
%             for windowStart = 1:windowSize:length(golaytrace) - windowSize + 1
%                 windowEnd = windowStart + windowSize - 1;
%                 window = golaytrace(windowStart:windowEnd);
%             
%                 % Calculate the noise metric (e.g., standard deviation)
%                 noiseMetric = std(window);
%             
%                 % Add the current window's noise metric to the list for all trials
%                 allNoiseMetrics(noiseMetricIndex) = noiseMetric;
%                 noiseMetricIndex = noiseMetricIndex + 1;
%             end
%         end
% 
%         % Select the value at the percentile specified by noise_prc across all trials
%         noiseLevel = prctile(allNoiseMetrics, noise_prc);
%             
%         baselineNoise{i}{j} = noiseLevel;  % Store noise level for each cell
%         SNR{i}{j} = sig95/noiseLevel; % Store SNR for each cell
%     end
% end
% 
% end