% Background subtraction methods

function allData = subtractbaseline(allData, plotornot)
nMice = length(allData.data);

for i = 1:nMice

   signal = allData.data{i}.corrected_rawtrace;
   [nFrames, nCells, nTrials] = size(signal);

   baseline = allData.data{i}.corrected_baseline;
   baseline = baseline(:);
   smoothed_b = smooth(baseline, 155, 'sgolay', 1);
   new_b = reshape(smoothed_b, nFrames, nTrials);


   % Method 1: subtract singular baseline value (1st prctile baseline)
   firstprctile = prctile(baseline(:), 1);
   rawminus_prc = signal - firstprctile;

   % Method 2: subtract smoothed baseline from each trial
   rawminus_smoothed_b = zeros(nFrames, nCells, nTrials);
   for j = 1:nCells
       for k = 1:nTrials
            temptrace = signal(:, j, k);
            tempb = new_b(:, k);
            temptrace = temptrace - tempb;
            rawminus_smoothed_b(:, j, k) = temptrace;
       end
   end

   cellmean_signal = squeeze(mean(signal, 2)); cellmean_signal = cellmean_signal(:);
   avgcorr_signal = squeeze(mean(rawminus_smoothed_b, 2)); avgcorr_signal = avgcorr_signal(:);
   % avgcorr2_signal = squeeze(mean(rawminus_prctrace, 2)); avgcorr2_signal = avgcorr2_signal(:);

   if strcmp(plotornot, 'yesplot')
       figure('Position', [50 50 1500 500]);
       plot(baseline, 'Color', '#EBC459')
       hold on
       plot(smoothed_b, 'LineWidth', 2, 'Color', '#EB822D')
       plot(cellmean_signal, 'Color', '#6EB1EB')
       plot(avgcorr_signal, 'Color', '#59636B')
       % plot(avgcorr2_signal, 'Color', 'c')
   end

   allData.data{i}.ac_bs_signal = rawminus_smoothed_b;
   allData.data{i}.rawminusfirstprctile = rawminus_prc;
   

end

end

