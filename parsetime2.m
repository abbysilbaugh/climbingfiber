function [binned_RWS, binned_RWSCF] = parsetime2(mottype, allData, RWS_mice, RWSCF_mice, RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, celltype, numBins)

% Select cell type
if strcmp(celltype, 'PN')
    RWS_pre = RWS_pre(:, 2);
    RWS_post = RWS_post(:, 2);
    RWSCF_pre = RWSCF_pre(:, 2);
    RWSCF_post = RWSCF_post(:, 2);

elseif strcmp(celltype, 'UC')
    RWS_pre = RWS_pre(:, 4);
    RWS_post = RWS_post(:, 4);
    RWSCF_pre = RWSCF_pre(:, 4);
    RWSCF_post = RWSCF_post(:, 4);
end

% Compile time data
nMice = size(allData.data, 2);

% Compile RWS data
RWS_pre_time = cell(nMice, 1);
RWS_post_time = cell(nMice, 1);
for i = RWS_mice
    [RWS_pre_time{i, 1}, RWS_post_time{i, 1}] = gettime(mottype, allData, i);
end
RWS_pre_time = RWS_pre_time(RWS_mice);
RWS_post_time = RWS_post_time(RWS_mice);

% Compile RWSCF data
RWSCF_pre_time = cell(nMice, 1);
RWSCF_post_time = cell(nMice, 1);
for i = RWSCF_mice
    [RWSCF_pre_time{i, 1}, RWSCF_post_time{i, 1}] = gettime(mottype, allData, i);
end
RWSCF_pre_time = RWSCF_pre_time(RWSCF_mice);
RWSCF_post_time = RWSCF_post_time(RWSCF_mice);

binned_RWS = cell(size(RWS_pre, 1), numBins);
binned_RWSCF = cell(size(RWSCF_pre, 1), numBins);

% Define bin edges dynamically
binEdges = linspace(-60, 60, numBins+1);

% Bin RWS mice
for i = 1:size(binned_RWS, 1)
    temp_pre = RWS_pre{i};
    temp_post = RWS_post{i};
    temp_pre_time = RWS_pre_time{i};
    temp_post_time = RWS_post_time{i};
    
    for b = 1:numBins
        binMask_pre = temp_pre_time > binEdges(b) & temp_pre_time <= binEdges(b+1);
        binMask_post = temp_post_time > binEdges(b) & temp_post_time <= binEdges(b+1);
        
        if b <= numBins/2
            binned_RWS{i, b} = mean(temp_pre(:, :, binMask_pre), 3, 'omitnan');
        else
            binned_RWS{i, b} = mean(temp_post(:, :, binMask_post), 3, 'omitnan');
        end
    end
end

% Bin RWSCF mice
for i = 1:size(binned_RWSCF, 1)
    temp_pre = RWSCF_pre{i};
    temp_post = RWSCF_post{i};
    temp_pre_time = RWSCF_pre_time{i};
    temp_post_time = RWSCF_post_time{i};
    
    for b = 1:numBins
        binMask_pre = temp_pre_time > binEdges(b) & temp_pre_time <= binEdges(b+1);
        binMask_post = temp_post_time > binEdges(b) & temp_post_time <= binEdges(b+1);
        
        if b <= numBins/2
            binned_RWSCF{i, b} = mean(temp_pre(:, :, binMask_pre), 3, 'omitnan');
        else
            binned_RWSCF{i, b} = mean(temp_post(:, :, binMask_post), 3, 'omitnan');
        end
    end
end

end

function [pre, post] = gettime(motiontype, allData, mouse)
    trialType = allData.data{mouse}.trialType;
    tetPeriod = allData.data{mouse}.tetPeriod;
    motionType = allData.data{mouse}.trialmotType;

    if strcmp(motiontype, 'all')
        pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W');
        post_tet_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W');
    else
        pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(motionType, motiontype);
        post_tet_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(motionType, motiontype);
    end

    signal = allData.data{mouse}.reltime;

    pre = signal(pre_trials);
    post = signal(post_tet_trials);
end
