% adds to allData.data{mouse}:
    % corrected_rawtrace (nFrames x nCells x nTrials); artifact-corrected raw trace
    % artifact_idx (nCells x nTrials); contains frame number of artifact
    % artifact_amps (nCells x nTrials); contains amplitude of artifact

% Function notes:
% Linearly interpolates artifact
% If mousetoplot ~NaN, the artifact-corrected traces are plotted (individual neurons are plotted for each trial)

function [allData] = interpartifact_new(allData, mousetoplot)

nMice = length(allData.data);
for mouse = 1:nMice
    artifactFrames = allData.data{mouse}.artifactframes;
    
    traces = allData.data{mouse}.raw_signal;
    trialTypes = allData.data{mouse}.trialType; Otrials = strcmp(trialTypes, 'O'); WOtrials = strcmp(trialTypes, 'WO');
    artifactTrials = logical(Otrials + WOtrials);
    [nFrames, nCells, nTrials] = size(traces);
    
    % FIND LOCATIONS OF POSITIVE AND NEGATIVE PEAKS
    artifact_frames = cell(nCells, nTrials);
    artifact_prom = cell(nCells, nTrials);
    indices = zeros(nCells, nTrials);
    amplitudes = zeros(nCells, nTrials);
    for j = 1:nTrials
        for k = 1:nCells
            % If trial could not contain artifact, put NaN
            if ~artifactTrials(j)
                artifact_frames{k, j} = [NaN, NaN];
                indices(k, j) = NaN;
                amplitudes(k,j) = NaN;
            % If trial could contain artifact...
            else
                % Find positive peaks
                temptrace = traces(:, k, j);
                [pks, locs, ~, p] = findpeaks(temptrace);
                if length(artifactFrames) == 1
                    idx = find(locs == artifactFrames);
                    locs = locs(idx); p = p(idx); pks = pks(idx);
                    if length(locs) == 0
                        locs = NaN; p = NaN; pks = NaN;
                    end
    
                elseif length(artifactFrames) == 2
                    idx1 = find(locs == artifactFrames(1)); pks1 = pks(idx1);
                    idx2 = find(locs == artifactFrames(2)); pks2 = pks(idx2);
                    if isempty(pks1) && isempty(pks2)
                        locs = NaN; p = NaN; pks = NaN;
                    elseif ~isempty(pks1) && isempty(pks2)
                        locs = locs(idx1); p = p(idx1); pks = pks(idx1);
                    elseif isempty(pks1) && ~isempty(pks2)
                        locs = locs(idx2); p = p(idx2); pks = pks(idx2);
                    elseif ~isempty(pks1) && ~isempty(pks2)
                        if pks1 > pks2
                            locs = locs(idx1); p = p(idx1); pks = pks(idx1);
                        elseif pks2 > pks1
                            locs = locs(idx2); p = p(idx2); pks = pks(idx2);
                        end
                    end
                end
    
                % Find negative peaks
                temptrace = -traces(:, k, j);
                [pks_neg, locs_neg, ~, p_neg] = findpeaks(temptrace);
                if length(artifactFrames) == 1
                    idx = find(locs_neg == artifactFrames);
                    locs_neg = locs_neg(idx); p_neg = p_neg(idx); pks_neg = pks_neg(idx);
                    if length(locs_neg) == 0
                        locs_neg = NaN; p_neg = NaN; pks_neg = pks_neg(idx);
                    end
    
                elseif length(artifactFrames) == 2
                    idx1 = find(locs_neg == artifactFrames(1)); pks1 = pks_neg(idx1);
                    idx2 = find(locs_neg == artifactFrames(2)); pks2 = pks_neg(idx2);
                    if isempty(pks1) && isempty(pks2)
                        locs_neg = NaN; p_neg = NaN; pks_neg = NaN;
                    elseif ~isempty(pks1) && isempty(pks2)
                        locs_neg = locs_neg(idx1); p_neg = p_neg(idx1); pks_neg = pks_neg(idx1);
                    elseif isempty(pks1) && ~isempty(pks2)
                        locs_neg = locs_neg(idx2); p_neg = p_neg(idx2); pks_neg = pks_neg(idx2);
                    elseif ~isempty(pks1) && ~isempty(pks2)
                        if pks1 > pks2
                            locs_neg = locs_neg(idx1); p_neg = p_neg(idx1); pks_neg = pks_neg(idx1);
                        elseif pks2 > pks1
                            locs_neg = locs_neg(idx2); p_neg = p_neg(idx2); pks_neg = pks_neg(idx2);
                        end
                    end
                end

                if isnan(locs) && isnan(locs_neg)
                    artifact_frames{k, j} = [NaN, NaN];
                    artifact_prom{k, j} = [NaN, NaN];
                    indices(k, j) = NaN;
                    amplitudes(k, j) = NaN;
                elseif isnan(locs) && ~isnan(locs_neg)
                    artifact_frames{k, j} = [NaN, locs_neg];
                    artifact_prom{k, j} = [NaN, p_neg];
                    indices(k, j) = locs_neg;
                    amplitudes(k, j) = pks_neg;
                elseif ~isnan(locs) && isnan(locs_neg)
                    artifact_frames{k,j} = [locs, NaN];
                    artifact_prom{k, j} = [p, NaN];
                    indices(k, j) = locs;
                    amplitudes(k, j) = pks;
                elseif ~isnan(locs) && ~isnan(locs_neg)
                    artifact_frames{k, j} = [locs, locs_neg];
                    artifact_prom{k, j} = [p, p_neg];
                    temp = [locs, locs_neg];
                    largerprom = find(max([p, p_neg]));
                    artifactpoint = temp(largerprom);
                    artifactvalue = traces(artifactpoint, k, j);
                    indices(k, j) = artifactpoint;
                    amplitudes(k, j) = artifactvalue;
                end
            end
        end
    end


    % INTERPOLATE
    artcorrtrace = zeros(nFrames, nCells, nTrials);
    for j = 1:nTrials
        for k = 1:nCells
            temp_trace = traces(:, k, j);
            temp_artinfo = artifact_frames{k, j};
            if sum(isnan(temp_artinfo)) == 2
                artcorrtrace(:, k, j) = temp_trace;
            elseif sum(isnan(temp_artinfo)) == 1
                temp_artinfo = temp_artinfo(~isnan(temp_artinfo));
                pre_val = temp_trace(temp_artinfo -1); post_val = temp_trace(temp_artinfo +1);
                INTERP = mean([pre_val, post_val]);
                temp_trace(temp_artinfo) = INTERP;
                artcorrtrace(:, k, j) = temp_trace;
            elseif sum(~isnan(temp_artinfo)) == 2
                pre_frame = min(temp_artinfo) - 1; post_frame = max(temp_artinfo) + 1;
                pre_val = temp_trace(pre_frame); post_val = temp_trace(post_frame);
                INTERP = mean([pre_val, post_val]);
                temp_trace(temp_artinfo) = INTERP;
                artcorrtrace(:, k, j) = temp_trace;
            end



        end
    end

allData.data{mouse}.corrected_rawtrace = artcorrtrace;
allData.data{mouse}.artifact_idx = indices;
allData.data{mouse}.artifact_amps = amplitudes;

if mouse == mousetoplot
    for i = 1:size(artcorrtrace, 3)
        figure('Position', [76,179,1809,420]);
        for j = 1:nCells
            plot(artcorrtrace(:, j, i), 'Color', [0 0 0 0.2])
            hold on
        end
        ylabel('Arbitrary Units')
        xticks([0 62 124 186 248 310 372 434 496 558 620])
        xticklabels([-10 -8 -6 -4 -2 0 2 4 6 8 10])
        xlabel('Seconds')
        xline(310, 'Color', 'r')
        ylim([0 25000])
    end
end


end



end
