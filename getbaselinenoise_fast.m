% Creates new variables...
    % baselineNoise (nMice x 1)
    % SNR (nMice x 1)

% Reference notes:
% Helmchen 2019
    % Calculate baseline noise (σ) as stdev of fluorescence change during least noisy 5 sec period (1st prctile)
        % Adjust time using seconds variable
    % SNR is 95th prctile of ΔF/F signals from session divided by σ
    % Event is 2σ

function [baselineNoise, SNR] = getbaselinenoise_fast(allData, noise_prc, sig_prc, tracetype, seconds)



windowSize = seconds * 31; % Window size of 5 seconds given 31 fps frame rate

nMice = length(allData.data);
baselineNoise = cell(nMice, 1);
SNR = cell(nMice, 1);

for i = 1:nMice
    nCells = length(allData.data{i}.cellType);
    
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

        % Calculate sliding window standard deviations
        STDEVs = movstd(longtrace, windowSize, 'Endpoints', 'discard');

        % Get the 1st percentile of the standard deviations
        sigma = prctile(STDEVs, noise_prc);

        SNR{i}{j} = sig95 / sigma;
        baselineNoise{i}{j} = sigma;

        if isnan(sigma)
            warning('sigma = NaN');
        end

%         if SNR{i}{j} > 30
%             keep(c, :) = [i, j, SNR{i}{j}];
%             c = c+1;
%         end
    end
end
end
