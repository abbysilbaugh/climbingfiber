%% Manually identify potential artifact frames and verify
mouse = 1;

traces = allData.data{mouse}.rawminusfirstprctile; %rawminusfirstprctile;
nCells = size(traces, 2);
trialTypes = allData.data{mouse}.trialType; Otrials = strcmp(trialTypes, 'O'); WOtrials = strcmp(trialTypes, 'WO');
artifactTrials = logical(Otrials + WOtrials);
artifactTraces = traces(:, :, artifactTrials);

% Test all trials
% for i = 1:size(traces, 3)
%     figure('Position', [76,179,1809,420]);
%     for j = 1:nCells
%         plot(traces(:, j, i), 'Color', [0 0 0 0.2])
%         hold on
%     end
% end

% Test only O, WO trials
for i = 1:sum(artifactTrials)
    figure('Position', [76,179,1809,420]);
    for j = 1:nCells
        plot(artifactTraces(:, j, i), 'Color', [0 0 0 0.2])
        hold on
    end
end

%% Save artifact frames
artifactframes = []; % change as necessary
%save('20230201_artifactframes.mat', 'artifactframes')

%% Find artifacts (positive and negative) and visually inspect
mouse = 14;
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
                artifactPre(k,j) = traces(locs - 1, k, j);
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
                    artifactPre(k,j) = traces(locs - 1, k, j);
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

artifactTemp = traces(:, :, artifactTrials);
AmpTemp = artifactAmp(:, artifactTrials);
IdxTemp = artifactIdx(:, artifactTrials);
PreTemp = artifactPre(:, artifactTrials);
PostTemp = artifactPost(:, artifactTrials);

% Visual inspection
for j = 1:size(artifactTemp, 3)
    figure;
    for k = 1:nCells
        if ~isnan(IdxTemp(k,j))
        plot(artifactTemp(:, k, j), 'Color', [0 0 0 0.3])
        hold on
        scatter(IdxTemp(k, j), AmpTemp(k,j), 'Color', 'r')
        end
    end
end      

%% Linear interpolation
nMice = length(allData.data);
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
                artifactPre(k,j) = traces(locs - 1, k, j);
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
                    artifactPre(k,j) = traces(locs - 1, k, j);
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



%% 
setthresh = 6000;

newtraces = traces;
for j = 1:nTrials
    figure;
    for k = 1:nCells
        if artifactdiff(k, j) > setthresh
            newtraces(artifactIdx(k, j), k, j) = artifactINTERP(k, j);
            plot(newtraces(:, k, j), 'Color', [1 0 0 0.2])
            hold on
        else
            plot(traces(:, k, j), 'Color', [0 0 0 .2])
            hold on
        end
    end
end




% testtrialsSTIM = allData.data{mouse}.trialType; testtrialsSTIM = strcmp('W', testtrialsSTIM);
% testtracesSTIM = testtraces(:, :, testtrialsSTIM);
% for i = 1:sum(testtrialsSTIM)
%     figure('Position', [76,179,1809,420]);
%     for j = 1:nCells
%         plot(testtracesSTIM(:, j, i), 'Color', [0 0 0 0.5])
%         hold on
%     end
% end


