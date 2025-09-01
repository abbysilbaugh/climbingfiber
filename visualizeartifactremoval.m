% Plots Artifact Trials, Non Artifact Trials, and Artifact Corrected Trials
% separately for each mouse

function visualizeartifactremoval(allData)

for i = 1:length(allData.data)
    trialtypes = allData.data{i}.trialType;
    stimtrials = logical(strcmp(trialtypes, 'W') + strcmp(trialtypes, 'WO') + strcmp(trialtypes, 'O'));
    signal = allData.data{i}.raw_signal(:, :, stimtrials);
    corrected_signal = allData.data{i}.corrected_rawtrace(:, :, stimtrials);
    artifact_indices = allData.data{i}.artifact_idx(:, stimtrials);
    artifact_amps = allData.data{i}.artifact_amps(:, stimtrials);
    [nFrames, nCells, nTrials] = size(signal);
    %trialavg = mean(signal, 3);
    maxsig = max(signal(:));
    minsig = 0;



    
    figure('Position', [50 50 1500 500]);
    for j = 1:nCells
        indices = artifact_indices(j, :);
        isartifacttrace = ~isnan(indices);
        a_traces = squeeze(signal(:, j, isartifacttrace));
        a_traces = mean(a_traces, 2);
        a_indices = artifact_indices(j, isartifacttrace);
        a_indices = mean(a_indices);
        a_amps = artifact_amps(j, isartifacttrace);
        a_amps = mean(a_amps);
        na_traces = squeeze(signal(:, j, ~isartifacttrace));
        na_traces = mean(na_traces, 2);
        corr_traces = squeeze(corrected_signal(:, j, isartifacttrace));
        corr_traces = mean(corr_traces, 2);


        subplot(1, 3, 1)
        plot(na_traces, 'Color', [0 0 0 0.1])
        hold on
        title('Non Artifact Trials')
        ylim([minsig, maxsig+500]);

        subplot(1, 3, 2)
        plot(a_traces, 'Color', [0 0 0 0.1])
        hold on
        % scatter(a_indices, a_amps, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.2)
        title('Artifact Trials')
        ylim([minsig, maxsig+500]);

        subplot(1, 3, 3)
        plot(corr_traces, 'Color', [0 0 0 0.1])
        hold on
        title('Artifact Corrected Trials')
        ylim([minsig, maxsig+500]);

       

    end



end

end