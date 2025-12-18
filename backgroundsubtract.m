% CF PAPER METHODS: choose rawminusfirstprctile

% adds to allData.data{mouse}...
    % rawminusfirstprctile (nFrames x nCells x nTrials)
    % ac_bs_signal (nFrames x nCells x nTrials)

% Function notes:
% Background subtracts using two methods
% Method 1: take 1st percentile of corrected_baseline trace (the signal from non-cell containing square)
    % Output: rawminusfirstprctile
% Method 2: subtract smoothed corrected_baseline trace from each trial
    % Output: ac_bs_signal
% If 'yesplot', plots avg trace and baselines across entire session

function allData = backgroundsubtract(allData, plotornot)
nMice = length(allData.data);

for i = 1:nMice

   signal = allData.data{i}.corrected_rawtrace;
   [nFrames, nCells, nTrials] = size(signal);

   baseline = allData.data{i}.corrected_baseline;
   baseline = baseline(:);
   smoothed_b = smooth(baseline, 155, 'sgolay', 1);
   new_b = reshape(smoothed_b, nFrames, nTrials);


   % Method 1: subtract singular baseline value (1st prctile corrected_baseline; across all trials)
   firstprctile = prctile(baseline(:), 1);
   rawminus_prc = signal - firstprctile;

   % Method 2: subtract smoothed corrected_baseline from each trial
   rawminus_smoothed_b = zeros(nFrames, nCells, nTrials);
   for j = 1:nCells
       for k = 1:nTrials
            temptrace = signal(:, j, k);
            tempb = new_b(:, k);
            temptrace = temptrace - tempb;
            rawminus_smoothed_b(:, j, k) = temptrace;
       end
   end

   cellmean_signal = squeeze(mean(signal, 2, 'omitnan')); cellmean_signal = cellmean_signal(:);
   avgcorr_signal = squeeze(mean(rawminus_smoothed_b, 2, 'omitnan')); avgcorr_signal = avgcorr_signal(:);

   if strcmp(plotornot, 'yesplot')
       figure('Position', [50 50 1500 500]);
       plot(baseline, 'Color', '#EBC459')
       hold on
       plot(smoothed_b, 'LineWidth', 2, 'Color', '#EB822D')
       plot(cellmean_signal, 'Color', '#6EB1EB')
       plot(avgcorr_signal, 'Color', '#59636B')
   end

   allData.data{i}.rawminusfirstprctile = rawminus_prc;
   %allData.data{i}.ac_bs_signal = rawminus_smoothed_b;
   
   

end

end

