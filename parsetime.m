function [binned_RWS, binned_RWSCF] = parsetime(mottype, allData, RWS_mice, RWSCF_mice, RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, celltype)

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

elseif strcmp(celltype, 'PV')
        RWS_pre = RWS_pre(:, 1);
    RWS_post = RWS_post(:, 1);
    RWSCF_pre = RWSCF_pre(:, 1);
    RWSCF_post = RWSCF_post(:, 1);

elseif strcmp(celltype, 'SST')
        RWS_pre = RWS_pre(:, 5);
    RWS_post = RWS_post(:, 5);
    RWSCF_pre = RWSCF_pre(:, 5);
    RWSCF_post = RWSCF_post(:, 5);

elseif strcmp(celltype, 'VIP')
        RWS_pre = RWS_pre(:, 3);
    RWS_post = RWS_post(:, 3);
    RWSCF_pre = RWSCF_pre(:, 3);
    RWSCF_post = RWSCF_post(:, 3);

elseif strcmp(celltype, 'SST and PV')
    RWS_pre_PV = RWS_pre(:, 1);
    RWS_post_PV = RWS_post(:, 1);
    RWSCF_pre_PV = RWSCF_pre(:, 1);
    RWSCF_post_PV = RWSCF_post(:, 1);

    RWS_pre_SST = RWS_pre(:, 5);
    RWS_post_SST = RWS_post(:, 5);
    RWSCF_pre_SST = RWSCF_pre(:, 5);
    RWSCF_post_SST = RWSCF_post(:, 5);

    nRWS_mice = size(RWS_pre_PV, 1);
    nRWSCF_mice = size(RWSCF_pre_PV, 1);

    RWS_pre = cell(nRWS_mice, 1);
    RWS_post = cell(nRWS_mice, 1);
    RWSCF_pre = cell(nRWSCF_mice, 1);
    RWSCF_post = cell(nRWSCF_mice, 1);

    for i = 1:nRWS_mice
        temp_PV = RWS_pre_PV{i};
        temp_SST = RWS_pre_SST{i};
        temp = cat(2, temp_PV, temp_SST);
        RWS_pre{i} = temp;

        temp_PV = RWS_post_PV{i};
        temp_SST = RWS_post_SST{i};
        temp = cat(2, temp_PV, temp_SST);
        RWS_post{i} = temp;
    end

    for i = 1:1:nRWSCF_mice
        temp_PV = RWSCF_pre_PV{i};
        temp_SST = RWSCF_pre_SST{i};
        temp = cat(2, temp_PV, temp_SST);
        RWSCF_pre{i} = temp;

        temp_PV = RWSCF_post_PV{i};
        temp_SST = RWSCF_post_SST{i};
        temp = cat(2, temp_PV, temp_SST);
        RWSCF_post{i} = temp;
    end
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

    binned_RWS = cell(size(RWS_pre, 1), 12);
    binned_RWSCF = cell(size(RWSCF_pre, 1), 12);

    % Bin RWS mice
    for i = 1:size(binned_RWS, 1)
        temp_pre = RWS_pre{i};
        temp_post = RWS_post{i};
        temp_pre_time = RWS_pre_time{i};
        temp_post_time = RWS_post_time{i};
    
        bin1 = -60 < temp_pre_time & temp_pre_time < -50;
        bin2 =  -50 < temp_pre_time & temp_pre_time < -40;
        bin3 =  -40 < temp_pre_time & temp_pre_time < -30;
        bin4 =  -30 < temp_pre_time & temp_pre_time < -20;
        bin5 =  -20 < temp_pre_time & temp_pre_time < -10;
        bin6 =  -10 < temp_pre_time & temp_pre_time < 0;
        bin7 = 0 < temp_post_time & temp_post_time < 10;
        bin8 =  10 < temp_post_time & temp_post_time < 20;
        bin9 =  20 < temp_post_time & temp_post_time < 30;
        bin10 =  30 < temp_post_time & temp_post_time < 40;
        bin11 =  40 < temp_post_time & temp_post_time < 50;
        bin12 =  50 < temp_post_time & temp_post_time < 60;

        binned_RWS{i, 1} = mean(temp_pre(:, :, bin1), 3, 'omitnan');
        binned_RWS{i, 2} = mean(temp_pre(:, :, bin2), 3, 'omitnan');
        binned_RWS{i, 3} = mean(temp_pre(:, :, bin3), 3, 'omitnan');
        binned_RWS{i, 4} = mean(temp_pre(:, :, bin4), 3, 'omitnan');
        binned_RWS{i, 5} = mean(temp_pre(:, :, bin5), 3, 'omitnan');
        binned_RWS{i, 6} = mean(temp_pre(:, :, bin6), 3, 'omitnan');
        binned_RWS{i, 7} = mean(temp_post(:, :, bin7), 3, 'omitnan');
        binned_RWS{i, 8} = mean(temp_post(:, :, bin8), 3, 'omitnan');
        binned_RWS{i, 9} = mean(temp_post(:, :, bin9), 3, 'omitnan');
        binned_RWS{i, 10} = mean(temp_post(:, :, bin10), 3, 'omitnan');
        binned_RWS{i, 11} = mean(temp_post(:, :, bin11), 3, 'omitnan');
        binned_RWS{i, 12} = mean(temp_post(:, :, bin12), 3, 'omitnan');
       
    end

    % Bin RWSCF mice
    for i = 1:size(binned_RWSCF, 1)
        temp_pre = RWSCF_pre{i};
        temp_post = RWSCF_post{i};
        temp_pre_time = RWSCF_pre_time{i};
        temp_post_time = RWSCF_post_time{i};
    
        bin1 = -60 < temp_pre_time & temp_pre_time < -50;
        bin2 =  -50 < temp_pre_time & temp_pre_time < -40;
        bin3 =  -40 < temp_pre_time & temp_pre_time < -30;
        bin4 =  -30 < temp_pre_time & temp_pre_time < -20;
        bin5 =  -20 < temp_pre_time & temp_pre_time < -10;
        bin6 =  -10 < temp_pre_time & temp_pre_time < 0;
        bin7 = 0 < temp_post_time & temp_post_time < 10;
        bin8 =  10 < temp_post_time & temp_post_time < 20;
        bin9 =  20 < temp_post_time & temp_post_time < 30;
        bin10 =  30 < temp_post_time & temp_post_time < 40;
        bin11 =  40 < temp_post_time & temp_post_time < 50;
        bin12 =  50 < temp_post_time & temp_post_time < 60;

        binned_RWSCF{i, 1} = mean(temp_pre(:, :, bin1), 3, 'omitnan');
        binned_RWSCF{i, 2} = mean(temp_pre(:, :, bin2), 3, 'omitnan');
        binned_RWSCF{i, 3} = mean(temp_pre(:, :, bin3), 3, 'omitnan');
        binned_RWSCF{i, 4} = mean(temp_pre(:, :, bin4), 3, 'omitnan');
        binned_RWSCF{i, 5} = mean(temp_pre(:, :, bin5), 3, 'omitnan');
        binned_RWSCF{i, 6} = mean(temp_pre(:, :, bin6), 3, 'omitnan');
        binned_RWSCF{i, 7} = mean(temp_post(:, :, bin7), 3, 'omitnan');
        binned_RWSCF{i, 8} = mean(temp_post(:, :, bin8), 3, 'omitnan');
        binned_RWSCF{i, 9} = mean(temp_post(:, :, bin9), 3, 'omitnan');
        binned_RWSCF{i, 10} = mean(temp_post(:, :, bin10), 3, 'omitnan');
        binned_RWSCF{i, 11} = mean(temp_post(:, :, bin11), 3, 'omitnan');
        binned_RWSCF{i, 12} = mean(temp_post(:, :, bin12), 3, 'omitnan');
       
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