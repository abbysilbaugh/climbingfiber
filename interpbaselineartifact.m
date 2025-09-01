% adds to allData.data{mouse}...
    % corrected_baseline (nFrames x nTrials)

% Function notes:
% Linearly interpolates artifact in baseline_signal (the signal from square containing no cells)
% If yesplot, plots baseline signal across entire movie for each mouse



function allData = interpbaselineartifact(allData, plotornot)
nMice = length(allData.data);

for i = 1:nMice
    artifacttrials = allData.data{i}.trialType;
    artifacttrials = strcmp(artifacttrials, 'WO') + strcmp(artifacttrials, 'O');
    baseline = allData.data{i}.baseline_signal;
    [nFrames, ~] = size(baseline);
    baseline = baseline(:);
    
    if strcmp(plotornot, 'yesplot')
        figure('Position', [50 50 1800 500]);
        plot(baseline)
        hold on
    end
    
    if sum(artifacttrials) > 0
        [pks, locs] = findpeaks(baseline, 'MinPeakProminence', 1000);
        for j = 1:length(locs)
            loc = locs(j);
            preb = baseline(loc -1); postb = baseline(loc +1);
            interp = mean([preb, postb]);
            baseline(loc) = interp;
        end

        if strcmp(plotornot, 'yesplot')
            scatter(locs, pks)
            plot(baseline, 'Color', 'b')
        end

    end

    baseline = reshape(baseline, nFrames, []);
    allData.data{i}.corrected_baseline = baseline;
    

end

end