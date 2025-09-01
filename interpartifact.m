% Created 4/5/24
% Edited 4/12/24; rawminusfirstprctile is updated with updated firstprctilevalue
% Linearly interpolates artifact

function [allData] = interpartifact(allData)

nMice = length(allData.data);

art_Idx = cell(nMice, 1);
art_INTERP = cell(nMice, 1);
for mouse = 1:nMice
    artifactFrames = allData.data{mouse}.artifactframes;
    
    traces = allData.data{mouse}.rawminusfirstprctile;
    trialTypes = allData.data{mouse}.trialType; Otrials = strcmp(trialTypes, 'O'); WOtrials = strcmp(trialTypes, 'WO');
    artifactTrials = logical(Otrials + WOtrials);
    [~, nCells, nTrials] = size(traces);
    
    % Preallocate arrays to store value at artifact frame, before, and after
    artifactAmp = zeros(nCells, nTrials);
    artifactIdx = zeros(nCells, nTrials);
    artifactPre = zeros(nCells, nTrials);
    artifactPost = zeros(nCells, nTrials);
    artifactINTERP = zeros(nCells, nTrials);
    for j = 1:nTrials
        for k = 1:nCells
            % If is not an artifact trial, put NaN
            if ~artifactTrials(j)
                artifactAmp(k, j) = NaN;
                artifactIdx(k, j) = NaN;
                artifactPre(k,j) = NaN;
                artifactPost(k,j) = NaN;
                artifactINTERP(k,j) = NaN;
            % If it is an artifact trial...
            else
                % Find positive peaks
                temptrace = traces(:, k, j);
                [pks, locs] = findpeaks(temptrace);
                if length(artifactFrames) == 1
                    idx = find(locs == artifactFrames);
                    pks = pks(idx); locs = locs(idx);
    
                elseif length(artifactFrames) == 2
                    idx1 = find(locs == artifactFrames(1)); pks1 = pks(idx1);
                    idx2 = find(locs == artifactFrames(2)); pks2 = pks(idx2);
                    if isempty(pks1) && isempty(pks2)
                        pks = []; locs = [];
                    elseif ~isempty(pks1) && isempty(pks2)
                        pks = pks(idx1); locs = locs(idx1);
                    elseif isempty(pks1) && ~isempty(pks2)
                        pks = pks(idx2); locs = locs(idx2);
                    elseif ~isempty(pks1) && ~isempty(pks2)
                        if pks1 > pks2
                            pks = pks(idx1); locs = locs(idx1);
                        elseif pks2 > pks1
                            pks = pks(idx2); locs = locs(idx2);
                        end
                    end
                end
    
                if ~isempty(locs)
                    artifactAmp(k,j) = pks;
                    artifactIdx(k,j) = locs;
                    artifactPre(k,j) = traces(locs - 3, k, j);
                    artifactPost(k,j) = traces(locs + 1, k, j);
                    artifactINTERP(k,j) = mean([artifactPre(k,j), artifactPost(k,j)]);
                else
                    % Find negative peaks (repeat above)
                    temptrace = -traces(:, k, j);
                    [pks, locs] = findpeaks(temptrace);
                    if length(artifactFrames) == 1
                        idx = find(locs == artifactFrames);
                        pks = pks(idx); locs = locs(idx);
        
                    elseif length(artifactFrames) == 2
                        idx1 = find(locs == artifactFrames(1)); pks1 = pks(idx1);
                        idx2 = find(locs == artifactFrames(2)); pks2 = pks(idx2);
                        if isempty(pks1) && isempty(pks2)
                            pks = []; locs = [];
                        elseif ~isempty(pks1) && isempty(pks2)
                            pks = pks(idx1); locs = locs(idx1);
                        elseif isempty(pks1) && ~isempty(pks2)
                            pks = pks(idx2); locs = locs(idx2);
                        elseif ~isempty(pks1) && ~isempty(pks2)
                            if pks1 > pks2
                                pks = pks(idx1); locs = locs(idx1);
                            elseif pks2 > pks1
                                pks = pks(idx2); locs = locs(idx2);
                            end
                        end
                    end
    
                    if ~isempty(locs)
                        artifactAmp(k,j) = -pks; % negative peak, compensate
                        artifactIdx(k,j) = locs;
                        artifactPre(k,j) = traces(locs - 3, k, j);
                        artifactPost(k,j) = traces(locs + 1, k, j);
                        artifactINTERP(k,j) = mean([artifactPre(k,j), artifactPost(k,j)]);
                    
                    else
    
                        artifactAmp(k, j) = NaN;
                        artifactIdx(k, j) = NaN;
                        artifactPre(k,j) = NaN;
                        artifactPost(k,j) = NaN;
                        artifactINTERP(k,j) = NaN;
                    end
                end
            end
        end
    end
    art_Idx{mouse} = artifactIdx;
    art_INTERP{mouse} = artifactINTERP;
    allData.data{mouse}.artifact_Idx = artifactIdx;
    allData.data{mouse}.artifact_Amp = artifactAmp;
end

% Replace points with interp
for i=1:nMice
    newtrace = allData.data{i}.rawminusfirstprctile;
    [~, nCells, nTrials] = size(newtrace);
    for j = 1:nTrials
        %figure;
        for k = 1:nCells
            index = art_Idx{i}(k, j);
            if ~isnan(index)
                newtrace(index, k, j) = art_INTERP{i}(k,j);
            end
%             plot(newtrace(:, k, j), 'Color', [0 0 0 0.5])
%             hold on
        end
    end
    allData.data{i}.corrected_rawtrace = newtrace;
end


end
