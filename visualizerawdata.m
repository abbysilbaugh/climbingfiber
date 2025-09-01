% Plots raw traces and corrected_baseline, rawminusfirstprctile, and ac_bs_signal
% for each mouse separately. Traces are trial-averaged. Individual neurons
% are plotted

function visualizerawdata(allData)

for i = 1:length(allData.data)

    signal = allData.data{i}.corrected_rawtrace;
    raw_signal_minus_firstprctile = allData.data{i}.rawminusfirstprctile;
    raw_signal_minus_smoothed_b = allData.data{i}.ac_bs_signal;
    baseline_signal = allData.data{i}.corrected_baseline;

    [nFrames, nCells, nTrials] = size(signal);
    getmax = mean(signal, 3); getmax = max(getmax(:)) + 1000;


    % trial average for plotting
    raw_signal_trialavg = squeeze(mean(signal, 3));
    raw_signal_minus_firstprctile_trialavg = squeeze(mean(raw_signal_minus_firstprctile, 3));
    raw_signal_minus_smoothed_b_trialavg = squeeze(mean(raw_signal_minus_smoothed_b, 3));
    baseline_signal_trialavg = mean(baseline_signal, 2);
    baseline_signal_std = std(baseline_signal, 0, 2);

    figure('Position', [50 50 1600 500]);
    
    % Plot raw trace for each cell and baseline (trial averaged)
    subplot(1, 3, 1);
    x = linspace(0, nFrames, nFrames)';
    y1 = baseline_signal_trialavg + baseline_signal_std;
    y2 = baseline_signal_trialavg - baseline_signal_std;
    fill([x; flipud(x)], [y1; flipud(y2)], [235, 196, 89]/255, 'FaceAlpha', 0.3, 'EdgeAlpha', 0);
    hold on
    plot(x, baseline_signal_trialavg, 'Color', '#EBC459')
    title('Artifact Corrected Traces')
    
    hold on
    for j = 1:nCells
        plot(raw_signal_trialavg(:, j), 'Color', [0 0 0 0.2])
    end
    ylim([0 getmax])

    subplot(1, 3, 2);
    % Plot corrected trace for each cell (first prctile value subtracted)
        % Baseline is calculated as first percentile value across entire baseline trace (ROI containing no cells)
    title('Background Subtracted (1st prctile value)')
    
    hold on
    for j = 1:nCells
        plot(raw_signal_minus_firstprctile_trialavg(:, j), 'Color', [0 0 0 0.2])
    end
    ylim([0 getmax])

    subplot(1, 3, 3);
    % Plot corrected trace for each cell (smoothed baseline subtracted)
    title('Background Subtracted (smoothed baseline)')
    hold on
    for j = 1:nCells
        plot(raw_signal_minus_smoothed_b_trialavg(:, j), 'Color', [0 0 0 0.2])
    end
    ylim([0 getmax])




end

end