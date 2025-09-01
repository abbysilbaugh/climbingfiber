function geteventprobability(mottype, allData, signaltype, BT_mice, RWS_mice, RWSCF_mice, RWSCF_PV_JAWS_mice, control_PV_JAWS_mice, RWSCF_PV_Gi_mice, control_PV_Gi_mice, RWSCF_SST_Gi_mice, control_SST_Gi_mice, RWS_SST_Gq_mice, control_SST_Gq_mice, norm)

nMice = size(allData.data, 2);
celltypes = {'PV', 'PN', 'VIP', 'UC', 'SST'};

% COMPILE DATA FOR EACH EXPERIMENTAL CONDITION
    % Compile basic transmission data
    pre = cell(nMice, 5);
    pre_wo = cell(nMice, 5);
    for i = BT_mice
        [pre{i, 1}, pre_wo{i, 1}, ~, ~] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [pre{i, 2}, pre_wo{i, 2}, ~, ~] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [pre{i, 3}, pre_wo{i, 3}, ~, ~] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [pre{i, 4}, pre_wo{i, 4}, ~, ~] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [pre{i, 5}, pre_wo{i, 5}, ~, ~] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
    end
    
%     pre = pre(BT_mice, :);
%     pre_wo = pre_wo(BT_mice, :);
    
    % Compile RWS data
    RWS_pre = cell(nMice, 5);
    RWS_pre_wo = cell(nMice, 5);
    RWS_post = cell(nMice, 5);
    
    for i = RWS_mice
        [RWS_pre{i, 1}, RWS_pre_wo{i, 1}, ~, RWS_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWS_pre{i, 2}, RWS_pre_wo{i, 2}, ~, RWS_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWS_pre{i, 3}, RWS_pre_wo{i, 3}, ~, RWS_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWS_pre{i, 4}, RWS_pre_wo{i, 4}, ~, RWS_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWS_pre{i, 5}, RWS_pre_wo{i, 5}, ~, RWS_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
    end
    
%     RWS_pre = RWS_pre(RWS_mice, :);
%     RWS_pre_wo = RWS_pre_wo(RWS_mice, :);
%     RWS_post = RWS_post(RWS_mice, :);
    
    % Compile RWSCF data
    RWSCF_pre = cell(nMice, 5);
    RWSCF_pre_wo = cell(nMice, 5);
    RWSCF_post = cell(nMice, 5);
    
    for i = RWSCF_mice
        [RWSCF_pre{i, 1}, RWSCF_pre_wo{i, 1}, ~, RWSCF_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_pre{i, 2}, RWSCF_pre_wo{i, 2}, ~, RWSCF_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_pre{i, 3}, RWSCF_pre_wo{i, 3}, ~, RWSCF_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_pre{i, 4}, RWSCF_pre_wo{i, 4}, ~, RWSCF_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_pre{i, 5}, RWSCF_pre_wo{i, 5}, ~, RWSCF_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
    end
    
%     RWSCF_pre = RWSCF_pre(RWSCF_mice, :);
%     RWSCF_pre_wo = RWSCF_pre_wo(RWSCF_mice, :);
%     RWSCF_post = RWSCF_post(RWSCF_mice, :);
    
    % Compile RWSCF_PV_JAWS data
    RWSCF_PV_JAWS_pre = cell(nMice, 5);
    RWSCF_PV_JAWS_pre_wo = cell(nMice, 5);
    RWSCF_PV_JAWS_post = cell(nMice, 5);
    
    for i = RWSCF_PV_JAWS_mice
        [RWSCF_PV_JAWS_pre{i, 1}, RWSCF_PV_JAWS_pre_wo{i, 1}, ~, RWSCF_PV_JAWS_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_PV_JAWS_pre{i, 2}, RWSCF_PV_JAWS_pre_wo{i, 2}, ~, RWSCF_PV_JAWS_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_PV_JAWS_pre{i, 3}, RWSCF_PV_JAWS_pre_wo{i, 3}, ~, RWSCF_PV_JAWS_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_PV_JAWS_pre{i, 4}, RWSCF_PV_JAWS_pre_wo{i, 4}, ~, RWSCF_PV_JAWS_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_PV_JAWS_pre{i, 5}, RWSCF_PV_JAWS_pre_wo{i, 5}, ~, RWSCF_PV_JAWS_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
    end
    
%     RWSCF_PV_JAWS_pre = RWSCF_PV_JAWS_pre(RWSCF_PV_JAWS_mice, :);
%     RWSCF_PV_JAWS_pre_wo = RWSCF_PV_JAWS_pre_wo(RWSCF_PV_JAWS_mice, :);
%     RWSCF_PV_JAWS_post = RWSCF_PV_JAWS_post(RWSCF_PV_JAWS_mice, :);
    
    % Compile control_PV_JAWS data
    control_PV_JAWS_pre = cell(nMice, 5);
    control_PV_JAWS_pre_wo = cell(nMice, 5);
    control_PV_JAWS_post = cell(nMice, 5);
    
    for i = control_PV_JAWS_mice
        [control_PV_JAWS_pre{i, 1}, control_PV_JAWS_pre_wo{i, 1}, ~, control_PV_JAWS_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_PV_JAWS_pre{i, 2}, control_PV_JAWS_pre_wo{i, 2}, ~, control_PV_JAWS_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_PV_JAWS_pre{i, 3}, control_PV_JAWS_pre_wo{i, 3}, ~, control_PV_JAWS_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_PV_JAWS_pre{i, 4}, control_PV_JAWS_pre_wo{i, 4}, ~, control_PV_JAWS_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_PV_JAWS_pre{i, 5}, control_PV_JAWS_pre_wo{i, 5}, ~, control_PV_JAWS_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
    end
    
%     control_PV_JAWS_pre = control_PV_JAWS_pre(control_PV_JAWS_mice, :);
%     control_PV_JAWS_pre_wo = control_PV_JAWS_pre_wo(control_PV_JAWS_mice, :);
%     control_PV_JAWS_post = control_PV_JAWS_post(control_PV_JAWS_mice, :);
    
    % Compile RWSCF_PV_Gi data
    RWSCF_PV_Gi_pre = cell(nMice, 5);
    RWSCF_PV_Gi_pre_wo = cell(nMice, 5);
    RWSCF_PV_Gi_pre_dcz = cell(nMice, 5);
    RWSCF_PV_Gi_post = cell(nMice, 5);
    
    for i = RWSCF_PV_Gi_mice
        [RWSCF_PV_Gi_pre{i, 1}, RWSCF_PV_Gi_pre_wo{i, 1}, RWSCF_PV_Gi_pre_dcz{i, 1}, RWSCF_PV_Gi_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_PV_Gi_pre{i, 2}, RWSCF_PV_Gi_pre_wo{i, 2}, RWSCF_PV_Gi_pre_dcz{i, 2}, RWSCF_PV_Gi_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_PV_Gi_pre{i, 3}, RWSCF_PV_Gi_pre_wo{i, 3}, RWSCF_PV_Gi_pre_dcz{i, 3}, RWSCF_PV_Gi_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_PV_Gi_pre{i, 4}, RWSCF_PV_Gi_pre_wo{i, 4}, RWSCF_PV_Gi_pre_dcz{i, 4}, RWSCF_PV_Gi_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_PV_Gi_pre{i, 5}, RWSCF_PV_Gi_pre_wo{i, 5}, RWSCF_PV_Gi_pre_dcz{i, 5}, RWSCF_PV_Gi_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
    end
    
%     RWSCF_PV_Gi_pre = RWSCF_PV_Gi_pre(RWSCF_PV_Gi_mice, :);
%     RWSCF_PV_Gi_pre_wo = RWSCF_PV_Gi_pre_wo(RWSCF_PV_Gi_mice, :);
%     RWSCF_PV_Gi_pre_dcz = RWSCF_PV_Gi_pre_dcz(RWSCF_PV_Gi_mice, :);
%     RWSCF_PV_Gi_post = RWSCF_PV_Gi_post(RWSCF_PV_Gi_mice, :);
    
    % Compile control_PV_Gi data
    control_PV_Gi_pre = cell(nMice, 5);
    control_PV_Gi_pre_wo = cell(nMice, 5);
    control_PV_Gi_pre_dcz = cell(nMice, 5);
    control_PV_Gi_post = cell(nMice, 5);
    
    for i = control_PV_Gi_mice
        [control_PV_Gi_pre{i, 1}, control_PV_Gi_pre_wo{i, 1}, control_PV_Gi_pre_dcz{i, 1}, control_PV_Gi_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_PV_Gi_pre{i, 2}, control_PV_Gi_pre_wo{i, 2}, control_PV_Gi_pre_dcz{i, 2}, control_PV_Gi_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_PV_Gi_pre{i, 3}, control_PV_Gi_pre_wo{i, 3}, control_PV_Gi_pre_dcz{i, 3}, control_PV_Gi_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_PV_Gi_pre{i, 4}, control_PV_Gi_pre_wo{i, 4}, control_PV_Gi_pre_dcz{i, 4}, control_PV_Gi_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_PV_Gi_pre{i, 5}, control_PV_Gi_pre_wo{i, 5}, control_PV_Gi_pre_dcz{i, 5}, control_PV_Gi_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
    end
    
%     control_PV_Gi_pre = control_PV_Gi_pre(control_PV_Gi_mice, :);
%     control_PV_Gi_pre_wo = control_PV_Gi_pre_wo(control_PV_Gi_mice, :);
%     control_PV_Gi_pre_dcz = control_PV_Gi_pre_dcz(control_PV_Gi_mice, :);
%     control_PV_Gi_post = control_PV_Gi_post(control_PV_Gi_mice, :);
    
    % Compile RWSCF_SST_Gi data
    RWSCF_SST_Gi_pre = cell(nMice, 5);
    RWSCF_SST_Gi_pre_wo = cell(nMice, 5);
    RWSCF_SST_Gi_pre_dcz = cell(nMice, 5);
    RWSCF_SST_Gi_post = cell(nMice, 5);
    
    for i = RWSCF_SST_Gi_mice
        [RWSCF_SST_Gi_pre{i, 1}, RWSCF_SST_Gi_pre_wo{i, 1}, RWSCF_SST_Gi_pre_dcz{i, 1}, RWSCF_SST_Gi_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_SST_Gi_pre{i, 2}, RWSCF_SST_Gi_pre_wo{i, 2}, RWSCF_SST_Gi_pre_dcz{i, 2}, RWSCF_SST_Gi_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_SST_Gi_pre{i, 3}, RWSCF_SST_Gi_pre_wo{i, 3}, RWSCF_SST_Gi_pre_dcz{i, 3}, RWSCF_SST_Gi_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_SST_Gi_pre{i, 4}, RWSCF_SST_Gi_pre_wo{i, 4}, RWSCF_SST_Gi_pre_dcz{i, 4}, RWSCF_SST_Gi_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWSCF_SST_Gi_pre{i, 5}, RWSCF_SST_Gi_pre_wo{i, 5}, RWSCF_SST_Gi_pre_dcz{i, 5}, RWSCF_SST_Gi_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
    end
    
%     RWSCF_SST_Gi_pre = RWSCF_SST_Gi_pre(RWSCF_SST_Gi_mice, :);
%     RWSCF_SST_Gi_pre_wo = RWSCF_SST_Gi_pre_wo(RWSCF_SST_Gi_mice, :);
%     RWSCF_SST_Gi_pre_dcz = RWSCF_SST_Gi_pre_dcz(RWSCF_SST_Gi_mice, :);
%     RWSCF_SST_Gi_post = RWSCF_SST_Gi_post(RWSCF_SST_Gi_mice, :);
    
    % Compile control_SST_Gi data
    control_SST_Gi_pre = cell(nMice, 5);
    control_SST_Gi_pre_wo = cell(nMice, 5);
    control_SST_Gi_pre_dcz = cell(nMice, 5);
    control_SST_Gi_post = cell(nMice, 5);
    
    for i = control_SST_Gi_mice
        [control_SST_Gi_pre{i, 1}, control_SST_Gi_pre_wo{i, 1}, control_SST_Gi_pre_dcz{i, 1}, control_SST_Gi_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_SST_Gi_pre{i, 2}, control_SST_Gi_pre_wo{i, 2}, control_SST_Gi_pre_dcz{i, 2}, control_SST_Gi_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_SST_Gi_pre{i, 3}, control_SST_Gi_pre_wo{i, 3}, control_SST_Gi_pre_dcz{i, 3}, control_SST_Gi_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_SST_Gi_pre{i, 4}, control_SST_Gi_pre_wo{i, 4}, control_SST_Gi_pre_dcz{i, 4}, control_SST_Gi_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_SST_Gi_pre{i, 5}, control_SST_Gi_pre_wo{i, 5}, control_SST_Gi_pre_dcz{i, 5}, control_SST_Gi_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
    end
    
%     control_SST_Gi_pre = control_SST_Gi_pre(control_SST_Gi_mice, :);
%     control_SST_Gi_pre_wo = control_SST_Gi_pre_wo(control_SST_Gi_mice, :);
%     control_SST_Gi_pre_dcz = control_SST_Gi_pre_dcz(control_SST_Gi_mice, :);
%     control_SST_Gi_post = control_SST_Gi_post(control_SST_Gi_mice, :);
    
    % Compile RWS_SST_Gq data
    RWS_SST_Gq_pre = cell(nMice, 5);
    RWS_SST_Gq_pre_wo = cell(nMice, 5);
    RWS_SST_Gq_pre_dcz = cell(nMice, 5);
    RWS_SST_Gq_post = cell(nMice, 5);
    
    for i = RWS_SST_Gq_mice
        [RWS_SST_Gq_pre{i, 1}, RWS_SST_Gq_pre_wo{i, 1}, RWS_SST_Gq_pre_dcz{i, 1}, RWS_SST_Gq_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWS_SST_Gq_pre{i, 2}, RWS_SST_Gq_pre_wo{i, 2}, RWS_SST_Gq_pre_dcz{i, 2}, RWS_SST_Gq_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWS_SST_Gq_pre{i, 3}, RWS_SST_Gq_pre_wo{i, 3}, RWS_SST_Gq_pre_dcz{i, 3}, RWS_SST_Gq_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWS_SST_Gq_pre{i, 4}, RWS_SST_Gq_pre_wo{i, 4}, RWS_SST_Gq_pre_dcz{i, 4}, RWS_SST_Gq_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [RWS_SST_Gq_pre{i, 5}, RWS_SST_Gq_pre_wo{i, 5}, RWS_SST_Gq_pre_dcz{i, 5}, RWS_SST_Gq_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
    end
    
%     RWS_SST_Gq_pre = RWS_SST_Gq_pre(RWS_SST_Gq_mice, :);
%     RWS_SST_Gq_pre_wo = RWS_SST_Gq_pre_wo(RWS_SST_Gq_mice, :);
%     RWS_SST_Gq_pre_dcz = RWS_SST_Gq_pre_dcz(RWS_SST_Gq_mice, :);
%     RWS_SST_Gq_post = RWS_SST_Gq_post(RWS_SST_Gq_mice, :);
    
    
    % Compile control_SST_Gq data
    control_SST_Gq_pre = cell(nMice, 5);
    control_SST_Gq_pre_wo = cell(nMice, 5);
    control_SST_Gq_pre_dcz = cell(nMice, 5);
    control_SST_Gq_post = cell(nMice, 5);
    
    for i = control_SST_Gq_mice
        [control_SST_Gq_pre{i, 1}, control_SST_Gq_pre_wo{i, 1}, control_SST_Gq_pre_dcz{i, 1}, control_SST_Gq_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_SST_Gq_pre{i, 2}, control_SST_Gq_pre_wo{i, 2}, control_SST_Gq_pre_dcz{i, 2}, control_SST_Gq_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_SST_Gq_pre{i, 3}, control_SST_Gq_pre_wo{i, 3}, control_SST_Gq_pre_dcz{i, 3}, control_SST_Gq_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_SST_Gq_pre{i, 4}, control_SST_Gq_pre_wo{i, 4}, control_SST_Gq_pre_dcz{i, 4}, control_SST_Gq_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
        [control_SST_Gq_pre{i, 5}, control_SST_Gq_pre_wo{i, 5}, control_SST_Gq_pre_dcz{i, 5}, control_SST_Gq_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 0);
    end
    
%     control_SST_Gq_pre = control_SST_Gq_pre(control_SST_Gq_mice, :);
%     control_SST_Gq_pre_wo = control_SST_Gq_pre_wo(control_SST_Gq_mice, :);
%     control_SST_Gq_pre_dcz = control_SST_Gq_pre_dcz(control_SST_Gq_mice, :);
%     control_SST_Gq_post = control_SST_Gq_post(control_SST_Gq_mice, :);


% GET # RESPONSES/#TRIALS FOR EACH CELL
    pre2 = getproportion(pre);
    pre_wo2 = getproportion(pre_wo);
    
    RWS_pre2 = getproportion(RWS_pre);
    %RWS_pre_wo2 = getproportion(RWS_pre_wo);
    RWS_post2 = getproportion(RWS_post);
    
    RWSCF_pre2 = getproportion(RWSCF_pre);
    %RWSCF_pre_wo2 = getproportion(RWSCF_pre_wo);
    RWSCF_post2 = getproportion(RWSCF_post);
    
    RWSCF_PV_JAWS_pre2 = getproportion(RWSCF_PV_JAWS_pre);
    %RWSCF_PV_JAWS_pre_wo2 = getproportion(RWSCF_PV_JAWS_pre_wo);
    RWSCF_PV_JAWS_post2 = getproportion(RWSCF_PV_JAWS_post);
    
    control_PV_JAWS_pre2 = getproportion(control_PV_JAWS_pre);
    %control_PV_JAWS_pre_wo2 = getproportion(control_PV_JAWS_pre_wo);
    control_PV_JAWS_post2 = getproportion(control_PV_JAWS_post);
    
    RWSCF_PV_Gi_pre2 = getproportion(RWSCF_PV_Gi_pre);
    %RWSCF_PV_Gi_pre_wo2 = getproportion(RWSCF_PV_Gi_pre_wo);
    RWSCF_PV_Gi_pre_dcz2 = getproportion(RWSCF_PV_Gi_pre_dcz);
    RWSCF_PV_Gi_post2 = getproportion(RWSCF_PV_Gi_post);
    
    control_PV_Gi_pre2 = getproportion(control_PV_Gi_pre);
    %control_PV_Gi_pre_wo2 = getproportion(control_PV_Gi_pre_wo);
    control_PV_Gi_pre_dcz2 = getproportion(control_PV_Gi_pre_dcz);
    control_PV_Gi_post2 = getproportion(control_PV_Gi_post);
    
    RWSCF_SST_Gi_pre2 = getproportion(RWSCF_SST_Gi_pre);
    %RWSCF_SST_Gi_pre_wo2 = getproportion(RWSCF_SST_Gi_pre_wo);
    RWSCF_SST_Gi_pre_dcz2 = getproportion(RWSCF_SST_Gi_pre_dcz);
    RWSCF_SST_Gi_post2 = getproportion(RWSCF_SST_Gi_post);
    
    control_SST_Gi_pre2 = getproportion(control_SST_Gi_pre);
    %control_SST_Gi_pre_wo2 = getproportion(control_SST_Gi_pre_wo);
    control_SST_Gi_pre_dcz2 = getproportion(control_SST_Gi_pre_dcz);
    control_SST_Gi_post2 = getproportion(control_SST_Gi_post);
    
    RWS_SST_Gq_pre2 = getproportion(RWS_SST_Gq_pre);
    %RWS_SST_Gq_pre_wo2 = getproportion(RWS_SST_Gq_pre_wo);
    RWS_SST_Gq_pre_dcz2 = getproportion(RWS_SST_Gq_pre_dcz);
    RWS_SST_Gq_post2 = getproportion(RWS_SST_Gq_post);
    
    control_SST_Gq_pre2 = getproportion(control_SST_Gq_pre);
    %control_SST_Gq_pre_wo2 = getproportion(control_SST_Gq_pre_wo);
    control_SST_Gq_pre_dcz2 = getproportion(control_SST_Gq_pre_dcz);
    control_SST_Gq_post2 = getproportion(control_SST_Gq_post);

% PAD EMPTY TRIALS WITH NANS
    % If a cell has 0, trial type exists but no events exist
    % If a cell has NaN, trial type doesn't exist (e.g. no rest trials)
    pre2 = padnans(pre2, allData);
    pre_wo2 = padnans(pre_wo2, allData);
    
    RWS_pre2 = padnans(RWS_pre2, allData);
    %RWS_pre_wo2 = padnans(RWS_pre_wo2, allData);
    RWS_post2 = padnans(RWS_post2, allData);
    
    RWSCF_pre2 = padnans(RWSCF_pre2, allData);
    %RWSCF_pre_wo2 = padnans(RWSCF_pre_wo2, allData);
    RWSCF_post2 = padnans(RWSCF_post2, allData);
    
    RWSCF_PV_JAWS_pre2 = padnans(RWSCF_PV_JAWS_pre2, allData);
    %RWSCF_PV_JAWS_pre_wo2 = padnans(RWSCF_PV_JAWS_pre_wo2, allData);
    RWSCF_PV_JAWS_post2 = padnans(RWSCF_PV_JAWS_post2, allData);
    
    control_PV_JAWS_pre2 = padnans(control_PV_JAWS_pre2, allData);
    %control_PV_JAWS_pre_wo2 = padnans(control_PV_JAWS_pre_wo2, allData);
    control_PV_JAWS_post2 = padnans(control_PV_JAWS_post2, allData);
    
    RWSCF_PV_Gi_pre2 = padnans(RWSCF_PV_Gi_pre2, allData);
    %RWSCF_PV_Gi_pre_wo2 = padnans(RWSCF_PV_Gi_pre_wo2, allData);
    RWSCF_PV_Gi_pre_dcz2 = padnans(RWSCF_PV_Gi_pre_dcz2, allData);
    RWSCF_PV_Gi_post2 = padnans(RWSCF_PV_Gi_post2, allData);
    
    control_PV_Gi_pre2 = padnans(control_PV_Gi_pre2, allData);
    %control_PV_Gi_pre_wo2 = padnans(control_PV_Gi_pre_wo2, allData);
    control_PV_Gi_pre_dcz2 = padnans(control_PV_Gi_pre_dcz2, allData);
    control_PV_Gi_post2 = padnans(control_PV_Gi_post2, allData);
    
    RWSCF_SST_Gi_pre2 = padnans(RWSCF_SST_Gi_pre2, allData);
    %RWSCF_SST_Gi_pre_wo2 = padnans(RWSCF_SST_Gi_pre_wo2, allData);
    RWSCF_SST_Gi_pre_dcz2 = padnans(RWSCF_SST_Gi_pre_dcz2, allData);
    RWSCF_SST_Gi_post2 = padnans(RWSCF_SST_Gi_post2, allData);
    
    control_SST_Gi_pre2 = padnans(control_SST_Gi_pre2, allData);
    %control_SST_Gi_pre_wo2 = padnans(control_SST_Gi_pre_wo2, allData);
    control_SST_Gi_pre_dcz2 = padnans(control_SST_Gi_pre_dcz2, allData);
    control_SST_Gi_post2 = padnans(control_SST_Gi_post2, allData);
    
    RWS_SST_Gq_pre2 = padnans(RWS_SST_Gq_pre2, allData);
    %RWS_SST_Gq_pre_wo2 = padnans(RWS_SST_Gq_pre_wo2, allData);
    RWS_SST_Gq_pre_dcz2 = padnans(RWS_SST_Gq_pre_dcz2, allData);
    RWS_SST_Gq_post2 = padnans(RWS_SST_Gq_post2, allData);
    
    control_SST_Gq_pre2 = padnans(control_SST_Gq_pre2, allData);
    %control_SST_Gq_pre_wo2 = padnans(control_SST_Gq_pre_wo2, allData);
    control_SST_Gq_pre_dcz2 = padnans(control_SST_Gq_pre_dcz2, allData);
    control_SST_Gq_post2 = padnans(control_SST_Gq_post2, allData);

% CONCATENATE MICE
    pre2 = concatenatemice(pre2);
    pre_wo2 = concatenatemice(pre_wo2);
    
    RWS_pre2 = concatenatemice(RWS_pre2);
    %RWS_pre_wo2 = concatenatemice(RWS_pre_wo2);
    RWS_post2 = concatenatemice(RWS_post2);
    
    RWSCF_pre2 = concatenatemice(RWSCF_pre2);
    %RWSCF_pre_wo2 = concatenatemice(RWSCF_pre_wo2);
    RWSCF_post2 = concatenatemice(RWSCF_post2);
    
    RWSCF_PV_JAWS_pre2 = concatenatemice(RWSCF_PV_JAWS_pre2);
    %RWSCF_PV_JAWS_pre_wo2 = concatenatemice(RWSCF_PV_JAWS_pre_wo2);
    RWSCF_PV_JAWS_post2 = concatenatemice(RWSCF_PV_JAWS_post2);
    
    control_PV_JAWS_pre2 = concatenatemice(control_PV_JAWS_pre2);
    %control_PV_JAWS_pre_wo2 = concatenatemice(control_PV_JAWS_pre_wo2);
    control_PV_JAWS_post2 = concatenatemice(control_PV_JAWS_post2);
    
    RWSCF_PV_Gi_pre2 = concatenatemice(RWSCF_PV_Gi_pre2);
    %RWSCF_PV_Gi_pre_wo2 = concatenatemice(RWSCF_PV_Gi_pre_wo2);
    RWSCF_PV_Gi_pre_dcz2 = concatenatemice(RWSCF_PV_Gi_pre_dcz2);
    RWSCF_PV_Gi_post2 = concatenatemice(RWSCF_PV_Gi_post2);
    
    control_PV_Gi_pre2 = concatenatemice(control_PV_Gi_pre2);
    %control_PV_Gi_pre_wo2 = concatenatemice(control_PV_Gi_pre_wo2);
    control_PV_Gi_pre_dcz2 = concatenatemice(control_PV_Gi_pre_dcz2);
    control_PV_Gi_post2 = concatenatemice(control_PV_Gi_post2);
    
    RWSCF_SST_Gi_pre2 = concatenatemice(RWSCF_SST_Gi_pre2);
    %RWSCF_SST_Gi_pre_wo2 = concatenatemice(RWSCF_SST_Gi_pre_wo2);
    RWSCF_SST_Gi_pre_dcz2 = concatenatemice(RWSCF_SST_Gi_pre_dcz2);
    RWSCF_SST_Gi_post2 = concatenatemice(RWSCF_SST_Gi_post2);
    
    control_SST_Gi_pre2 = concatenatemice(control_SST_Gi_pre2);
    %control_SST_Gi_pre_wo2 = concatenatemice(control_SST_Gi_pre_wo2);
    control_SST_Gi_pre_dcz2 = concatenatemice(control_SST_Gi_pre_dcz2);
    control_SST_Gi_post2 = concatenatemice(control_SST_Gi_post2);
    
    RWS_SST_Gq_pre2 = concatenatemice(RWS_SST_Gq_pre2);
    %RWS_SST_Gq_pre_wo2 = concatenatemice(RWS_SST_Gq_pre_wo2);
    RWS_SST_Gq_pre_dcz2 = concatenatemice(RWS_SST_Gq_pre_dcz2);
    RWS_SST_Gq_post2 = concatenatemice(RWS_SST_Gq_post2);
    
    control_SST_Gq_pre2 = concatenatemice(control_SST_Gq_pre2);
    %control_SST_Gq_pre_wo2 = concatenatemice(control_SST_Gq_pre_wo2);
    control_SST_Gq_pre_dcz2 = concatenatemice(control_SST_Gq_pre_dcz2);
    control_SST_Gq_post2 = concatenatemice(control_SST_Gq_post2);

 % PLOT CELL DATA
    for i = 1:length(celltypes)
        cells_plot2cond(pre2, pre_wo2, celltypes{i}, 'W', 'W+CF', 'BT', norm)
    end
    
    for i = 1:length(celltypes)
        cells_plot2cond(RWS_pre2, RWS_post2, celltypes{i}, 'PRE', 'POST', 'RWS', norm)
    end
    
    for i = 1:length(celltypes)
        cells_plot2cond(RWSCF_pre2, RWSCF_post2, celltypes{i}, 'PRE', 'POST', 'RWSCF', norm)
    end
    
    for i = [1, 2, 4]
        cells_plot2cond(RWSCF_PV_JAWS_pre2, RWSCF_PV_JAWS_post2, celltypes{i}, 'PRE', 'POST', 'RWSCF - PV (JAWS)', norm)
    end
    
    for i = [1, 2, 4]
        cells_plot2cond(control_PV_JAWS_pre2, control_PV_JAWS_post2, celltypes{i}, 'PRE', 'POST', '- PV (JAWS)', norm)
    end
    
    for i = [1, 2, 4]
        cells_plot2cond(RWSCF_PV_Gi_pre_dcz2, RWSCF_PV_Gi_post2, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWSCF - PV (hM4D(Gi)))', norm)
    end
    
    for i = [1, 2, 4]
        cells_plot2cond(control_PV_Gi_pre_dcz2, control_PV_Gi_post2, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '- PV (hM4D(Gi)))', norm)
    end
    
    for i = [2, 4, 5]
        cells_plot2cond(RWSCF_SST_Gi_pre_dcz2, RWSCF_SST_Gi_post2, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWSCF - SST (hM4D(Gi)))', norm)
    end
    
    for i = [2, 4, 5]
        cells_plot2cond(control_SST_Gi_pre_dcz2, control_SST_Gi_post2, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '- SST (hM4D(Gi)))', norm)
    end
    
    for i = [2, 4, 5]
        cells_plot2cond(RWS_SST_Gq_pre_dcz2, RWS_SST_Gq_post2, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWS + SST (hM3D(Gq)))', norm)
    end
    
    for i = [2, 4, 5]
        cells_plot2cond(control_SST_Gq_pre_dcz2, control_SST_Gq_post2, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '+ SST (hM3D(Gq)))', norm)
    end



% GET # RESPONSES/#TRIALS FOR EACH CELL, AVERAGE WITHIN MICE
    pre1 = getproportion_mean(pre);
    pre_wo1 = getproportion_mean(pre_wo);
    
    RWS_pre1 = getproportion_mean(RWS_pre);
    %RWS_pre_wo1 = getproportion_mean(RWS_pre_wo);
    RWS_post1 = getproportion_mean(RWS_post);
    
    RWSCF_pre1 = getproportion_mean(RWSCF_pre);
    %RWSCF_pre_wo1 = getproportion_mean(RWSCF_pre_wo);
    RWSCF_post1 = getproportion_mean(RWSCF_post);
    
    RWSCF_PV_JAWS_pre1 = getproportion_mean(RWSCF_PV_JAWS_pre);
    %RWSCF_PV_JAWS_pre_wo1 = getproportion_mean(RWSCF_PV_JAWS_pre_wo);
    RWSCF_PV_JAWS_post1 = getproportion_mean(RWSCF_PV_JAWS_post);
    
    control_PV_JAWS_pre1 = getproportion_mean(control_PV_JAWS_pre);
    %control_PV_JAWS_pre_wo1 = getproportion_mean(control_PV_JAWS_pre_wo);
    control_PV_JAWS_post1 = getproportion_mean(control_PV_JAWS_post);
    
    RWSCF_PV_Gi_pre1 = getproportion_mean(RWSCF_PV_Gi_pre);
    %RWSCF_PV_Gi_pre_wo1 = getproportion_mean(RWSCF_PV_Gi_pre_wo);
    RWSCF_PV_Gi_pre_dcz1 = getproportion_mean(RWSCF_PV_Gi_pre_dcz);
    RWSCF_PV_Gi_post1 = getproportion_mean(RWSCF_PV_Gi_post);
    
    control_PV_Gi_pre1 = getproportion_mean(control_PV_Gi_pre);
    %control_PV_Gi_pre_wo1 = getproportion_mean(control_PV_Gi_pre_wo);
    control_PV_Gi_pre_dcz1 = getproportion_mean(control_PV_Gi_pre_dcz);
    control_PV_Gi_post1 = getproportion_mean(control_PV_Gi_post);
    
    RWSCF_SST_Gi_pre1 = getproportion_mean(RWSCF_SST_Gi_pre);
    %RWSCF_SST_Gi_pre_wo1 = getproportion_mean(RWSCF_SST_Gi_pre_wo);
    RWSCF_SST_Gi_pre_dcz1 = getproportion_mean(RWSCF_SST_Gi_pre_dcz);
    RWSCF_SST_Gi_post1 = getproportion_mean(RWSCF_SST_Gi_post);
    
    control_SST_Gi_pre1 = getproportion_mean(control_SST_Gi_pre);
    %control_SST_Gi_pre_wo1 = getproportion_mean(control_SST_Gi_pre_wo);
    control_SST_Gi_pre_dcz1 = getproportion_mean(control_SST_Gi_pre_dcz);
    control_SST_Gi_post1 = getproportion_mean(control_SST_Gi_post);
    
    RWS_SST_Gq_pre1 = getproportion_mean(RWS_SST_Gq_pre);
    %RWS_SST_Gq_pre_wo1 = getproportion_mean(RWS_SST_Gq_pre_wo);
    RWS_SST_Gq_pre_dcz1 = getproportion_mean(RWS_SST_Gq_pre_dcz);
    RWS_SST_Gq_post1 = getproportion_mean(RWS_SST_Gq_post);
    
    control_SST_Gq_pre1 = getproportion_mean(control_SST_Gq_pre);
    %control_SST_Gq_pre_wo1 = getproportion_mean(control_SST_Gq_pre_wo);
    control_SST_Gq_pre_dcz1 = getproportion_mean(control_SST_Gq_pre_dcz);
    control_SST_Gq_post1 = getproportion_mean(control_SST_Gq_post);


% PLOT MOUSE BY MOUSE DATA
    norm = false;
    for i = 1:length(celltypes)
        plot2cond(pre1, pre_wo1, celltypes{i}, 'W', 'W+CF', 'BT', norm)
    end
    
    for i = 1:length(celltypes)
        plot2cond(RWS_pre1, RWS_post1, celltypes{i}, 'PRE', 'POST', 'RWS', norm)
    end
    
    for i = 1:length(celltypes)
        plot2cond(RWSCF_pre1, RWSCF_post1, celltypes{i}, 'PRE', 'POST', 'RWSCF', norm)
    end
    
    for i = [1, 2, 4]
        plot2cond(RWSCF_PV_JAWS_pre1, RWSCF_PV_JAWS_post1, celltypes{i}, 'PRE', 'POST', 'RWSCF - PV (JAWS)', norm)
    end
    
    for i = [1, 2, 4]
        plot2cond(control_PV_JAWS_pre1, control_PV_JAWS_post1, celltypes{i}, 'PRE', 'POST', '- PV (JAWS)', norm)
    end
    
    for i = [1, 2, 4]
        plot2cond(RWSCF_PV_Gi_pre_dcz1, RWSCF_PV_Gi_post1, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWSCF - PV (hM4D(Gi)))', norm)
    end
    
    for i = [1, 2, 4]
        plot2cond(control_PV_Gi_pre_dcz1, control_PV_Gi_post1, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '- PV (hM4D(Gi)))', norm)
    end
    
    for i = [2, 4, 5]
        plot2cond(RWSCF_SST_Gi_pre_dcz1, RWSCF_SST_Gi_post1, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWSCF - SST (hM4D(Gi)))', norm)
    end
    
    for i = [2, 4, 5]
        plot2cond(control_SST_Gi_pre_dcz1, control_SST_Gi_post1, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '- SST (hM4D(Gi)))', norm)
    end
    
    for i = [2, 4, 5]
        plot2cond(RWS_SST_Gq_pre_dcz1, RWS_SST_Gq_post1, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWS + SST (hM3D(Gq)))', norm)
    end
    
    for i = [2, 4, 5]
        plot2cond(control_SST_Gq_pre_dcz1, control_SST_Gq_post1, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '+ SST (hM3D(Gq)))', norm)
    end

end

function var = padnans(var, allData)
    nMice = size(var, 1);
    neurontypes = {'PV', 'PN', 'VIP', 'UC', 'SST'};
    for i = 1:nMice
        celltype = allData.data{i}.cellType;
        for j = 1:size(var, 2)
            temp = var{i, j};
            nt = neurontypes{j};
            if isempty(temp)
                getncells = strcmp(celltype, nt);
                getncells = sum(getncells);
                insertnans = nan(getncells, 1);
                var{i, j} = insertnans;
            end
        end
    end
end

function var = getproportion(var)
    for j = 1:size(var, 2)
        for i = 1:size(var, 1)
            temp = var{i, j};
            if ~isempty(temp)
                [~, nCells, nTrials] = size(temp);
                prop = zeros(nCells, 1);
                for k = 1:nCells
                    temp2 = squeeze(temp(1, k, :));
                    temp2 = sum(~isnan(temp2));
                    prop(k) = temp2/nTrials;
                end
                var{i, j} = prop;
            end
        end
    end
end

function var = concatenatemice(var)
    PV = [];
    PN = [];
    VIP = [];
    UC = [];
    SST = [];
    for y = 1:size(var, 1)
        PV_temp = var{y, 1};
        PN_temp = var{y, 2};
        VIP_temp = var{y, 3};
        UC_temp = var{y, 4};
        SST_temp = var{y, 5};

        if ~isempty(PV_temp)
            PV = cat(1, PV, PV_temp);
        end
        if ~isempty(PN_temp)
            PN = cat(1, PN, PN_temp);
        end
        if ~isempty(VIP_temp)
            VIP = cat(1, VIP, VIP_temp);
        end
        if ~isempty(UC_temp)
            UC = cat(1, UC, UC_temp);
        end
        if ~isempty(SST_temp)
            SST = cat(1, SST, SST_temp);
        end
    end
    var = {PV, PN, VIP, UC, SST};
end


function var = getproportion_mean(var)
var_temp = zeros(size(var, 1), size(var, 2));
    for i = 1:size(var, 1)
        for j = 1:size(var, 2)
            temp = var{i, j};
            if ~isempty(temp)
                [~, nCells, nTrials] = size(temp);
                prop = zeros(nCells, 1);
                for k = 1:nCells
                    temp2 = squeeze(temp(1, k, :));
                    temp2 = sum(~isnan(temp2));
                    prop(k) = temp2/nTrials;
                end
                var_temp(i, j) = mean(prop);
            else
                var_temp(i, j) = NaN;
            end
    
        end
    end
    var = var_temp;
end

% PLOT BY MICE
function plot2cond(cond1, cond2, choosecell, cond1name, cond2name, figtitle, choosenorm)
        colors = {[187/255, 37/255, 37/255], [34/255, 75/255, 170/255], [10/255, 138/255, 35/255],  [0, 0, 0], [99/255, 63/255, 115/255]};
        temp = size(cond1);
        if temp(1) == 0
            warning('Expt has no Ns')
        else
            if strcmp(choosecell, 'PV')
                cell_temp = cond1(:, 1);
                cell_temp2 = cond2(:, 1);
                color = colors{1};
            elseif strcmp(choosecell, 'PN')
                cell_temp = cond1(:, 2);
                cell_temp2 = cond2(:, 2);
                color = colors{2};
            elseif strcmp(choosecell, 'VIP')
                cell_temp = cond1(:, 3);
                cell_temp2 = cond2(:, 3);
                color = colors{3};
            elseif strcmp(choosecell, 'UC')
                cell_temp = cond1(:, 4);
                cell_temp2 = cond2(:, 4);
                color = colors{4};
            elseif strcmp(choosecell, 'SST')
                cell_temp = cond1(:, 5);
                cell_temp2 = cond2(:, 5);
                color = colors{5};
            end
%             cell_temp = cell_temp(~isnan(cell_temp));
%             cell_temp2 = cell_temp2(~isnan(cell_temp2));
%             % Get rid of mice with no responsive cells in either cond.
%             t = cell_temp == 0;
%             t2 = cell_temp2 == 0;
%             temp = t + t2;
%             temp = temp < 2;
%             cell_temp = cell_temp(temp);
%             cell_temp2 = cell_temp2(temp);
    
            num_mice = length(cell_temp);
    
            figure('Position', [680,558,323,420]);
            if choosenorm
                for n = 1:size(cell_temp, 1)
                    g = plot([1, 2], [cell_temp(n)/cell_temp(n), cell_temp2(n)/cell_temp(n)], 'Color', color, 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor', color);
                    hold on
                end
                %ylim([0, 2])
                xlim([0.5, 2.5])
                set(gca, 'FontSize', 15)
                xticks([1, 2])
                xticklabels({cond1name, cond2name})
                ylabel('% Responsive Cells')
                title(figtitle)
        
                [h,p,ci,stats] = ttest(cell_temp, cell_temp2);
                getgca = gca().YLim;
                text(1.5, getgca(2)-0.1, ['p = ', num2str(p, '%.3f')], 'HorizontalAlignment', 'center', 'FontSize', 12);
                text(1.5, getgca(2)-0.15, ['nMice = ', num2str(num_mice')], 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Color', color);
            else
                for n = 1:size(cell_temp, 1)
                    g = plot([1, 2], [cell_temp(n), cell_temp2(n)], 'Color', color, 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor', color);
                    hold on
                end
                %ylim([0, 1.2])
                xlim([0.5, 2.5])
                set(gca, 'FontSize', 15)
                xticks([1, 2])
                xticklabels({cond1name, cond2name})
                ylabel('% Responsive Cells')
                title(figtitle)
        
                [h,p,ci,stats] = ttest(cell_temp, cell_temp2);
                getgca = gca().YLim;
                text(1.5, getgca(2)-0.1, ['p = ', num2str(p, '%.3f')], 'HorizontalAlignment', 'center', 'FontSize', 12);
                text(1.5, getgca(2)-0.15, ['nMice = ', num2str(num_mice')], 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Color', color);
            end

        end
end

function cells_plot2cond(cond1, cond2, choosecell, cond1name, cond2name, figtitle, choosenorm)
    linecolors = {[187/255, 37/255, 37/255, 0.2], [34/255, 75/255, 170/255, 0.2], [10/255, 138/255, 35/255, 0.2],  [0, 0, 0, 0.2], [99/255, 63/255, 115/255, 0.2]};
    colors = {[187/255, 37/255, 37/255], [34/255, 75/255, 170/255], [10/255, 138/255, 35/255],  [0, 0, 0], [99/255, 63/255, 115/255]};
    if strcmp(choosecell, 'PV')
        cell_temp = cond1{1};
        cell_temp2 = cond2{1};
        color = colors{1};
        lcolor = linecolors{1};
    elseif strcmp(choosecell, 'PN')
        cell_temp = cond1{2};
        cell_temp2 = cond2{2};
        color = colors{2};
        lcolor = linecolors{2};
    elseif strcmp(choosecell, 'VIP')
        cell_temp = cond1{3};
        cell_temp2 = cond2{3};
        color = colors{3};
        lcolor = linecolors{3};
    elseif strcmp(choosecell, 'UC')
        cell_temp = cond1{4};
        cell_temp2 = cond2{4};
        color = colors{4};
        lcolor = linecolors{4};
    elseif strcmp(choosecell, 'SST')
        cell_temp = cond1{5};
        cell_temp2 = cond2{5};
        color = colors{5};
        lcolor = linecolors{5};
    end

    figure('Position', [680,558,323,420]);
    if choosenorm
        for n = 1:size(cell_temp, 1)
            g = plot([1, 2], [cell_temp(n)/cell_temp(n), cell_temp2(n)/cell_temp(n)], 'Color', lcolor, 'LineWidth', 2); %, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor', lcolor) %, 'MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', 'None');
            hold on
            scatter([1, 2], [cell_temp(n)/cell_temp(n), cell_temp2(n)/cell_temp(n)], 100, 'filled', 'o', 'MarkerFaceColor', color, 'MarkerFaceAlpha', 0.2);
        end
        %ylim([0, 2])
        xlim([0.5, 2.5])
        set(gca, 'FontSize', 15)
        xticks([1, 2])
        xticklabels({cond1name, cond2name})
        ylabel('Event Probability')
        title(figtitle)

        [h,p,ci,stats] = ttest(cell_temp, cell_temp2);
        getgca = gca().YLim;
        text(1.5, getgca(2)-0.1, ['p = ', num2str(p, '%.3f')], 'HorizontalAlignment', 'center', 'FontSize', 12);
        text(1.5, getgca(2)-0.15, ['nCells = ', num2str(size(cell_temp, 1)')], 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Color', color);
    else
        for n = 1:size(cell_temp, 1)
            g = plot([1, 2], [cell_temp(n), cell_temp2(n)], 'Color', lcolor, 'LineWidth', 2); %, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor', color, 'MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', 'none');
            hold on
            scatter([1, 2],  [cell_temp(n), cell_temp2(n)], 100, 'filled', 'o', 'MarkerFaceColor', color, 'MarkerFaceAlpha', 0.2)
        end
        ylim([0, 1.2])
        xlim([0.5, 2.5])
        set(gca, 'FontSize', 15)
        xticks([1, 2])
        xticklabels({cond1name, cond2name})
        ylabel('Event Probability')
        title(figtitle)

        [h,p,ci,stats] = ttest(cell_temp, cell_temp2);
        getgca = gca().YLim;
        text(1.5, getgca(2)-0.1, ['p = ', num2str(p, '%.3f')], 'HorizontalAlignment', 'center', 'FontSize', 12);
        text(1.5, getgca(2)-0.15, ['nCells = ', num2str(size(cell_temp, 1)')], 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Color', color);
    end
end