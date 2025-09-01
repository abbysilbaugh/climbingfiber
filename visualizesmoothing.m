

function visualizesmoothing(allData)

for i = 1:length(allData.data)
    trialtypes = allData.data{i}.trialType;
    stimtrials = logical(strcmp(trialtypes, 'W') + strcmp(trialtypes, 'WO')); % + strcmp(trialtypes, 'O'));
    
    corrected_signal = allData.data{i}.corrected_rawtrace(:, :, stimtrials);
    golaysignal = allData.data{i}.golaysignal(:, :, stimtrials);
    golaysignal2 = allData.data{i}.golaysignal2(:, :, stimtrials);
    golaysignal3 = allData.data{i}.golaysignal3(:, :, stimtrials);
    golaysignal4 = allData.data{i}.golaysignal4(:, :, stimtrials);

    [nFrames, nCells, nTrials] = size(corrected_signal);
    %trialavg = mean(signal, 3);


    figure('Position', [10 100 2000 500]);
    for j = 1:nCells
        corr_traces = squeeze(corrected_signal(:, j, :));
        corr_traces = mean(corr_traces, 2, 'omitnan');
        
        golay_traces = squeeze(golaysignal(:, j, :));
        golay_traces = mean(golay_traces, 2, 'omitnan');
        
        golay_traces2 = squeeze(golaysignal2(:, j, :));
        golay_traces2 = mean(golay_traces2, 2, 'omitnan');
        
        golay_traces3 = squeeze(golaysignal3(:, j, :));
        golay_traces3 = mean(golay_traces3, 2, 'omitnan');

        golay_traces4 = squeeze(golaysignal4(:, j, :));
        golay_traces4 = mean(golay_traces4, 2, 'omitnan');


        subplot(1, 5, 1)
        plot(corr_traces, 'Color', [0 0 0 0.1])
        hold on
        title('Artifact Corrected')
        %ylim([minsig, maxsig+500]);

        subplot(1, 5, 2)
        plot(golay_traces, 'Color', [0 0 0 0.1])
        hold on
        title('golaysignal')
        %ylim([minsig, maxsig+500]);

        subplot(1, 5, 3)
        plot(golay_traces2, 'Color', [0 0 0 0.1])
        hold on 
        title('golaysignal2')
        %ylim([minsig, maxsig+500]);

        subplot(1, 5, 4)
        plot(golay_traces3, 'Color', [0 0 0 0.1])
        hold on
        title('golaysignal3')
        %ylim([minsig, maxsig+500]);

        subplot(1, 5, 5)
        plot(golay_traces4, 'Color', [0 0 0 0.1])
        hold on
        title('golaysignal4')
        %ylim([minsig, maxsig+500]);

       

    end



        
        
    

    



%     figure('Position', [50 50 1600 500]);
%     Plot raw trace and baseline (trial averaged)
%     subplot(1, 3, 1);
%     x = linspace(0, nFrames, nFrames)';
%     y1 = baseline_signal_trialavg + baseline_signal_std;
%     y2 = baseline_signal_trialavg - baseline_signal_std;
%     fill([x; flipud(x)], [y1; flipud(y2)], 'b', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);
%     hold on
%     plot(x, baseline_signal_trialavg, 'Color', 'b')
%     title('Raw Trace')
%     
%     hold on
%     for j = 1:nCells
%         plot(raw_signal_trialavg(:, j), 'Color', [1 0 0 0.2])
%     end
% 
%     subplot(1, 3, 2);
%     Plot corrected trace and baseline (trial averaged)
%         Baseline is calculated as first percentile value across entire baseline trace (ROI containing no cells)
%     title('Background Subtracted (1st prctile value)')
%     
%     hold on
%     for j = 1:nCells
%         plot(raw_signal_minus_firstprctile_trialavg(:, j), 'Color', [1 0 0 0.2])
%     end
% 
%     subplot(1, 3, 3);
%     Plot corrected trace and baseline (trial averaged)
%         Baseline (ROI containing no cells) is subtracted from each trial individually
%     title('Background Subtracted (by trial)')
%     hold on
%     for j = 1:nCells
%         plot(signal_bytrialsubtraction_trialavg(:, j), 'Color', [1 0 0 0.2])
%     end




end

end