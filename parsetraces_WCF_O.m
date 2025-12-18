% For each condition...
        % Output: nMice x nCelltype cell array; each cell contains nFrames x nCells x nTrials

    % If trialavg (~cellavg and ~catmouse)...
        % Each cell is trial averaged within mice (NaN trials are not included)
        % Output: nMice x nCelltype cell array; each cell contains nFrames x nCells double
        
    % If trialavg & cellaverage (~catmouse)_...
        % Each cell is trial averaged within mice (NaN trials are not included)
        % Cells are averaged within mouse
        % Output: nMice x nCelltype cell array; each cell contains nFrames x 1 double

    % If trialavg & and catmouse (~cellavg)...
        % Each cell is trial averaged within mice
        % All cells are concatenated across mice
        % Output: 1 x nCelltype cell array; each cell contains nFrames x nTotalCells

    % If trialavg & cellaverage & catmouse...
        % Each cell is trial averaged within mice
        % All cells within mice are averaged
        % Output: 1 x nCelltype cell array; each cell contains nFrames x nMice
       
function [pre_wo, pre_o, ...
    RWS_pre_wo, RWS_pre_o, RWS_post, ...
    RWSCF_pre_wo, RWSCF_pre_o, RWSCF_post, ...
    RWSCF_PV_JAWS_pre_wo, RWSCF_PV_JAWS_pre_o, RWSCF_PV_JAWS_post, ...
    control_PV_JAWS_pre_wo, control_PV_JAWS_pre_o, control_PV_JAWS_post, ...
    RWSCF_PV_Gi_pre_wo, RWSCF_PV_Gi_pre_o, RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, ...
    control_PV_Gi_pre_wo, control_PV_Gi_pre_o, control_PV_Gi_pre_dcz, control_PV_Gi_post, ...
    RWS_PV_Gq_pre_wo, RWS_PV_Gq_pre_o, RWS_PV_Gq_pre_dcz, RWS_PV_Gq_post, ...
    control_PV_Gq_pre_wo, control_PV_Gq_pre_o, control_PV_Gq_pre_dcz, control_PV_Gq_post, ...
    RWSCF_SST_Gi_pre_wo, RWSCF_SST_Gi_pre_o, RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, ...
    control_SST_Gi_pre_wo, control_SST_Gi_pre_o, control_SST_Gi_pre_dcz, control_SST_Gi_post, ...
    RWS_SST_Gq_pre_wo, RWS_SST_Gq_pre_o, RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, ...
    control_SST_Gq_pre_wo, control_SST_Gq_pre_o, control_SST_Gq_pre_dcz, control_SST_Gq_post,...
    RWSCF_VIP_Gq_pre_wo, RWSCF_VIP_Gq_pre_o, RWSCF_VIP_Gq_pre_dcz, RWSCF_VIP_Gq_post, ...
    control_VIP_Gq_pre_wo, control_VIP_Gq_pre_o, control_VIP_Gq_pre_dcz, control_VIP_Gq_post, ... 
    RWS_VIP_Gi_pre_wo, RWS_VIP_Gi_pre_o, RWS_VIP_Gi_pre_dcz, RWS_VIP_Gi_post, ...
    control_VIP_Gi_pre_wo, control_VIP_Gi_pre_o, control_VIP_Gi_pre_dcz, control_VIP_Gi_post, ...
    SST_Gi_ZI_pre_wo, SST_Gi_ZI_pre_o, SST_Gi_ZI_pre_dcz, SST_Gi_ZI_pre_dcz_o, ...
    PV_Gi_ZI_pre_wo, PV_Gi_ZI_pre_o, PV_Gi_ZI_pre_dcz, PV_Gi_ZI_pre_dcz_o]...
    = parsetraces_WCF_O(baselineshiftperiod, baselineshift, baseline_reject_thresh, trialavg, cellavg, catmouse, mottype, allData, signaltype, setmice)

nMice = size(allData.data, 2);

% Compile basic transmission data
pre_wo = cell(nMice, 5);
pre_o = cell(nMice, 5);
for i = setmice.BT_mice
    [pre_wo{i, 1}, pre_o{i, 1}, ~, ~] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [pre_wo{i, 2}, pre_o{i, 2}, ~, ~] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [pre_wo{i, 3}, pre_o{i, 3}, ~, ~] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [pre_wo{i, 4}, pre_o{i, 4}, ~, ~] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [pre_wo{i, 5}, pre_o{i, 5}, ~, ~] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

pre_wo = pre_wo(setmice.BT_mice, :);
pre_o = pre_o(setmice.BT_mice, :);

% Compile RWS data
RWS_pre_wo = cell(nMice, 5);
RWS_pre_o = cell(nMice, 5);
RWS_post = cell(nMice, 5);

for i = setmice.RWS_mice
    [RWS_pre_wo{i, 1}, RWS_pre_o{i, 1}, ~, RWS_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_pre_wo{i, 2}, RWS_pre_o{i, 2}, ~, RWS_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_pre_wo{i, 3}, RWS_pre_o{i, 3}, ~, RWS_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_pre_wo{i, 4}, RWS_pre_o{i, 4}, ~, RWS_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_pre_wo{i, 5}, RWS_pre_o{i, 5}, ~, RWS_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWS_pre_wo = RWS_pre_wo(setmice.RWS_mice, :);
RWS_pre_o = RWS_pre_o(setmice.RWS_mice, :);
RWS_post = RWS_post(setmice.RWS_mice, :);

% Compile RWSCF data
RWSCF_pre_wo = cell(nMice, 5);
RWSCF_pre_o = cell(nMice, 5);
RWSCF_post = cell(nMice, 5);

for i = setmice.RWSCF_mice
    [RWSCF_pre_wo{i, 1}, RWSCF_pre_o{i, 1}, ~, RWSCF_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_pre_wo{i, 2}, RWSCF_pre_o{i, 2}, ~, RWSCF_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_pre_wo{i, 3}, RWSCF_pre_o{i, 3}, ~, RWSCF_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_pre_wo{i, 4}, RWSCF_pre_o{i, 4}, ~, RWSCF_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_pre_wo{i, 5}, RWSCF_pre_o{i, 5}, ~, RWSCF_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWSCF_pre_wo = RWSCF_pre_wo(setmice.RWSCF_mice, :);
RWSCF_pre_o = RWSCF_pre_o(setmice.RWSCF_mice, :);
RWSCF_post = RWSCF_post(setmice.RWSCF_mice, :);

% Compile RWSCF_PV_JAWS data
RWSCF_PV_JAWS_pre_wo = cell(nMice, 5);
RWSCF_PV_JAWS_pre_o = cell(nMice, 5);
RWSCF_PV_JAWS_post = cell(nMice, 5);

for i = setmice.RWSCF_PV_JAWS_mice
    [RWSCF_PV_JAWS_pre_wo{i, 1}, RWSCF_PV_JAWS_pre_o{i, 1}, ~, RWSCF_PV_JAWS_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_JAWS_pre_wo{i, 2}, RWSCF_PV_JAWS_pre_o{i, 2}, ~, RWSCF_PV_JAWS_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_JAWS_pre_wo{i, 3}, RWSCF_PV_JAWS_pre_o{i, 3}, ~, RWSCF_PV_JAWS_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_JAWS_pre_wo{i, 4}, RWSCF_PV_JAWS_pre_o{i, 4}, ~, RWSCF_PV_JAWS_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_JAWS_pre_wo{i, 5}, RWSCF_PV_JAWS_pre_o{i, 5}, ~, RWSCF_PV_JAWS_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWSCF_PV_JAWS_pre_wo = RWSCF_PV_JAWS_pre_wo(setmice.RWSCF_PV_JAWS_mice, :);
RWSCF_PV_JAWS_pre_o = RWSCF_PV_JAWS_pre_o(setmice.RWSCF_PV_JAWS_mice, :);
RWSCF_PV_JAWS_post = RWSCF_PV_JAWS_post(setmice.RWSCF_PV_JAWS_mice, :);

% Compile control_PV_JAWS data
control_PV_JAWS_pre_wo = cell(nMice, 5);
control_PV_JAWS_pre_o = cell(nMice, 5);
control_PV_JAWS_post = cell(nMice, 5);

for i = setmice.control_PV_JAWS_mice
    [control_PV_JAWS_pre_wo{i, 1}, control_PV_JAWS_pre_o{i, 1}, ~, control_PV_JAWS_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_JAWS_pre_wo{i, 2}, control_PV_JAWS_pre_o{i, 2}, ~, control_PV_JAWS_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_JAWS_pre_wo{i, 3}, control_PV_JAWS_pre_o{i, 3}, ~, control_PV_JAWS_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_JAWS_pre_wo{i, 4}, control_PV_JAWS_pre_o{i, 4}, ~, control_PV_JAWS_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_JAWS_pre_wo{i, 5}, control_PV_JAWS_pre_o{i, 5}, ~, control_PV_JAWS_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_PV_JAWS_pre_wo = control_PV_JAWS_pre_wo(setmice.control_PV_JAWS_mice, :);
control_PV_JAWS_pre_o = control_PV_JAWS_pre_o(setmice.control_PV_JAWS_mice, :);
control_PV_JAWS_post = control_PV_JAWS_post(setmice.control_PV_JAWS_mice, :);

% Compile RWSCF_PV_Gi data
RWSCF_PV_Gi_pre_wo = cell(nMice, 5);
RWSCF_PV_Gi_pre_o = cell(nMice, 5);
RWSCF_PV_Gi_pre_dcz = cell(nMice, 5);
RWSCF_PV_Gi_post = cell(nMice, 5);

for i = setmice.RWSCF_PV_Gi_mice
    [RWSCF_PV_Gi_pre_wo{i, 1}, RWSCF_PV_Gi_pre_o{i, 1}, RWSCF_PV_Gi_pre_dcz{i, 1}, RWSCF_PV_Gi_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_Gi_pre_wo{i, 2}, RWSCF_PV_Gi_pre_o{i, 2}, RWSCF_PV_Gi_pre_dcz{i, 2}, RWSCF_PV_Gi_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_Gi_pre_wo{i, 3}, RWSCF_PV_Gi_pre_o{i, 3}, RWSCF_PV_Gi_pre_dcz{i, 3}, RWSCF_PV_Gi_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_Gi_pre_wo{i, 4}, RWSCF_PV_Gi_pre_o{i, 4}, RWSCF_PV_Gi_pre_dcz{i, 4}, RWSCF_PV_Gi_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_Gi_pre_wo{i, 5}, RWSCF_PV_Gi_pre_o{i, 5}, RWSCF_PV_Gi_pre_dcz{i, 5}, RWSCF_PV_Gi_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWSCF_PV_Gi_pre_wo = RWSCF_PV_Gi_pre_wo(setmice.RWSCF_PV_Gi_mice, :);
RWSCF_PV_Gi_pre_o = RWSCF_PV_Gi_pre_o(setmice.RWSCF_PV_Gi_mice, :);
RWSCF_PV_Gi_pre_dcz = RWSCF_PV_Gi_pre_dcz(setmice.RWSCF_PV_Gi_mice, :);
RWSCF_PV_Gi_post = RWSCF_PV_Gi_post(setmice.RWSCF_PV_Gi_mice, :);

% Compile control_PV_Gi data
control_PV_Gi_pre_wo = cell(nMice, 5);
control_PV_Gi_pre_o = cell(nMice, 5);
control_PV_Gi_pre_dcz = cell(nMice, 5);
control_PV_Gi_post = cell(nMice, 5);

for i = setmice.control_PV_Gi_mice
    [control_PV_Gi_pre_wo{i, 1}, control_PV_Gi_pre_o{i, 1}, control_PV_Gi_pre_dcz{i, 1}, control_PV_Gi_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gi_pre_wo{i, 2}, control_PV_Gi_pre_o{i, 2}, control_PV_Gi_pre_dcz{i, 2}, control_PV_Gi_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gi_pre_wo{i, 3}, control_PV_Gi_pre_o{i, 3}, control_PV_Gi_pre_dcz{i, 3}, control_PV_Gi_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gi_pre_wo{i, 4}, control_PV_Gi_pre_o{i, 4}, control_PV_Gi_pre_dcz{i, 4}, control_PV_Gi_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gi_pre_wo{i, 5}, control_PV_Gi_pre_o{i, 5}, control_PV_Gi_pre_dcz{i, 5}, control_PV_Gi_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_PV_Gi_pre_wo = control_PV_Gi_pre_wo(setmice.control_PV_Gi_mice, :);
control_PV_Gi_pre_o = control_PV_Gi_pre_o(setmice.control_PV_Gi_mice, :);
control_PV_Gi_pre_dcz = control_PV_Gi_pre_dcz(setmice.control_PV_Gi_mice, :);
control_PV_Gi_post = control_PV_Gi_post(setmice.control_PV_Gi_mice, :);

% Compile RWS_PV_Gq data
RWS_PV_Gq_pre_wo = cell(nMice, 5);
RWS_PV_Gq_pre_o = cell(nMice, 5);
RWS_PV_Gq_pre_dcz = cell(nMice, 5);
RWS_PV_Gq_post = cell(nMice, 5);

for i = setmice.RWS_PV_Gq_mice
    [RWS_PV_Gq_pre_wo{i, 1}, RWS_PV_Gq_pre_o{i, 1}, RWS_PV_Gq_pre_dcz{i, 1}, RWS_PV_Gq_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_PV_Gq_pre_wo{i, 2}, RWS_PV_Gq_pre_o{i, 2}, RWS_PV_Gq_pre_dcz{i, 2}, RWS_PV_Gq_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_PV_Gq_pre_wo{i, 3}, RWS_PV_Gq_pre_o{i, 3}, RWS_PV_Gq_pre_dcz{i, 3}, RWS_PV_Gq_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_PV_Gq_pre_wo{i, 4}, RWS_PV_Gq_pre_o{i, 4}, RWS_PV_Gq_pre_dcz{i, 4}, RWS_PV_Gq_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_PV_Gq_pre_wo{i, 5}, RWS_PV_Gq_pre_o{i, 5}, RWS_PV_Gq_pre_dcz{i, 5}, RWS_PV_Gq_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWS_PV_Gq_pre_wo = RWS_PV_Gq_pre_wo(setmice.RWS_PV_Gq_mice, :);
RWS_PV_Gq_pre_o = RWS_PV_Gq_pre_o(setmice.RWS_PV_Gq_mice, :);
RWS_PV_Gq_pre_dcz = RWS_PV_Gq_pre_dcz(setmice.RWS_PV_Gq_mice, :);
RWS_PV_Gq_post = RWS_PV_Gq_post(setmice.RWS_PV_Gq_mice, :);

% Compile control_PV_Gq data
control_PV_Gq_pre_wo = cell(nMice, 5);
control_PV_Gq_pre_o = cell(nMice, 5);
control_PV_Gq_pre_dcz = cell(nMice, 5);
control_PV_Gq_post = cell(nMice, 5);

for i = setmice.control_PV_Gq_mice
    [control_PV_Gq_pre_wo{i, 1}, control_PV_Gq_pre_o{i, 1}, control_PV_Gq_pre_dcz{i, 1}, control_PV_Gq_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gq_pre_wo{i, 2}, control_PV_Gq_pre_o{i, 2}, control_PV_Gq_pre_dcz{i, 2}, control_PV_Gq_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gq_pre_wo{i, 3}, control_PV_Gq_pre_o{i, 3}, control_PV_Gq_pre_dcz{i, 3}, control_PV_Gq_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gq_pre_wo{i, 4}, control_PV_Gq_pre_o{i, 4}, control_PV_Gq_pre_dcz{i, 4}, control_PV_Gq_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gq_pre_wo{i, 5}, control_PV_Gq_pre_o{i, 5}, control_PV_Gq_pre_dcz{i, 5}, control_PV_Gq_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_PV_Gq_pre_wo = control_PV_Gq_pre_wo(setmice.control_PV_Gq_mice, :);
control_PV_Gq_pre_o = control_PV_Gq_pre_o(setmice.control_PV_Gq_mice, :);
control_PV_Gq_pre_dcz = control_PV_Gq_pre_dcz(setmice.control_PV_Gq_mice, :);
control_PV_Gq_post = control_PV_Gq_post(setmice.control_PV_Gq_mice, :);

% Compile RWSCF_SST_Gi data
RWSCF_SST_Gi_pre_wo = cell(nMice, 5);
RWSCF_SST_Gi_pre_o = cell(nMice, 5);
RWSCF_SST_Gi_pre_dcz = cell(nMice, 5);
RWSCF_SST_Gi_post = cell(nMice, 5);

for i = setmice.RWSCF_SST_Gi_mice
    [RWSCF_SST_Gi_pre_wo{i, 1}, RWSCF_SST_Gi_pre_o{i, 1}, RWSCF_SST_Gi_pre_dcz{i, 1}, RWSCF_SST_Gi_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_SST_Gi_pre_wo{i, 2}, RWSCF_SST_Gi_pre_o{i, 2}, RWSCF_SST_Gi_pre_dcz{i, 2}, RWSCF_SST_Gi_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_SST_Gi_pre_wo{i, 3}, RWSCF_SST_Gi_pre_o{i, 3}, RWSCF_SST_Gi_pre_dcz{i, 3}, RWSCF_SST_Gi_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_SST_Gi_pre_wo{i, 4}, RWSCF_SST_Gi_pre_o{i, 4}, RWSCF_SST_Gi_pre_dcz{i, 4}, RWSCF_SST_Gi_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_SST_Gi_pre_wo{i, 5}, RWSCF_SST_Gi_pre_o{i, 5}, RWSCF_SST_Gi_pre_dcz{i, 5}, RWSCF_SST_Gi_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWSCF_SST_Gi_pre_wo = RWSCF_SST_Gi_pre_wo(setmice.RWSCF_SST_Gi_mice, :);
RWSCF_SST_Gi_pre_o = RWSCF_SST_Gi_pre_o(setmice.RWSCF_SST_Gi_mice, :);
RWSCF_SST_Gi_pre_dcz = RWSCF_SST_Gi_pre_dcz(setmice.RWSCF_SST_Gi_mice, :);
RWSCF_SST_Gi_post = RWSCF_SST_Gi_post(setmice.RWSCF_SST_Gi_mice, :);

% Compile control_SST_Gi data
control_SST_Gi_pre_wo = cell(nMice, 5);
control_SST_Gi_pre_o = cell(nMice, 5);
control_SST_Gi_pre_dcz = cell(nMice, 5);
control_SST_Gi_post = cell(nMice, 5);

for i = setmice.control_SST_Gi_mice
    [control_SST_Gi_pre_wo{i, 1}, control_SST_Gi_pre_o{i, 1}, control_SST_Gi_pre_dcz{i, 1}, control_SST_Gi_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gi_pre_wo{i, 2}, control_SST_Gi_pre_o{i, 2}, control_SST_Gi_pre_dcz{i, 2}, control_SST_Gi_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gi_pre_wo{i, 3}, control_SST_Gi_pre_o{i, 3}, control_SST_Gi_pre_dcz{i, 3}, control_SST_Gi_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gi_pre_wo{i, 4}, control_SST_Gi_pre_o{i, 4}, control_SST_Gi_pre_dcz{i, 4}, control_SST_Gi_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gi_pre_wo{i, 5}, control_SST_Gi_pre_o{i, 5}, control_SST_Gi_pre_dcz{i, 5}, control_SST_Gi_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_SST_Gi_pre_wo = control_SST_Gi_pre_wo(setmice.control_SST_Gi_mice, :);
control_SST_Gi_pre_o = control_SST_Gi_pre_o(setmice.control_SST_Gi_mice, :);
control_SST_Gi_pre_dcz = control_SST_Gi_pre_dcz(setmice.control_SST_Gi_mice, :);
control_SST_Gi_post = control_SST_Gi_post(setmice.control_SST_Gi_mice, :);

% Compile RWS_SST_Gq data
RWS_SST_Gq_pre_wo = cell(nMice, 5);
RWS_SST_Gq_pre_o = cell(nMice, 5);
RWS_SST_Gq_pre_dcz = cell(nMice, 5);
RWS_SST_Gq_post = cell(nMice, 5);

for i = setmice.RWS_SST_Gq_mice
    [RWS_SST_Gq_pre_wo{i, 1}, RWS_SST_Gq_pre_o{i, 1}, RWS_SST_Gq_pre_dcz{i, 1}, RWS_SST_Gq_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_SST_Gq_pre_wo{i, 2}, RWS_SST_Gq_pre_o{i, 2}, RWS_SST_Gq_pre_dcz{i, 2}, RWS_SST_Gq_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_SST_Gq_pre_wo{i, 3}, RWS_SST_Gq_pre_o{i, 3}, RWS_SST_Gq_pre_dcz{i, 3}, RWS_SST_Gq_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_SST_Gq_pre_wo{i, 4}, RWS_SST_Gq_pre_o{i, 4}, RWS_SST_Gq_pre_dcz{i, 4}, RWS_SST_Gq_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_SST_Gq_pre_wo{i, 5}, RWS_SST_Gq_pre_o{i, 5}, RWS_SST_Gq_pre_dcz{i, 5}, RWS_SST_Gq_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWS_SST_Gq_pre_wo = RWS_SST_Gq_pre_wo(setmice.RWS_SST_Gq_mice, :);
RWS_SST_Gq_pre_o = RWS_SST_Gq_pre_o(setmice.RWS_SST_Gq_mice, :);
RWS_SST_Gq_pre_dcz = RWS_SST_Gq_pre_dcz(setmice.RWS_SST_Gq_mice, :);
RWS_SST_Gq_post = RWS_SST_Gq_post(setmice.RWS_SST_Gq_mice, :);


% Compile control_SST_Gq data
control_SST_Gq_pre_wo = cell(nMice, 5);
control_SST_Gq_pre_o = cell(nMice, 5);
control_SST_Gq_pre_dcz = cell(nMice, 5);
control_SST_Gq_post = cell(nMice, 5);

for i = setmice.control_SST_Gq_mice
    [control_SST_Gq_pre_wo{i, 1}, control_SST_Gq_pre_o{i, 1}, control_SST_Gq_pre_dcz{i, 1}, control_SST_Gq_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gq_pre_wo{i, 2}, control_SST_Gq_pre_o{i, 2}, control_SST_Gq_pre_dcz{i, 2}, control_SST_Gq_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gq_pre_wo{i, 3}, control_SST_Gq_pre_o{i, 3}, control_SST_Gq_pre_dcz{i, 3}, control_SST_Gq_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gq_pre_wo{i, 4}, control_SST_Gq_pre_o{i, 4}, control_SST_Gq_pre_dcz{i, 4}, control_SST_Gq_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gq_pre_wo{i, 5}, control_SST_Gq_pre_o{i, 5}, control_SST_Gq_pre_dcz{i, 5}, control_SST_Gq_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_SST_Gq_pre_wo = control_SST_Gq_pre_wo(setmice.control_SST_Gq_mice, :);
control_SST_Gq_pre_o = control_SST_Gq_pre_o(setmice.control_SST_Gq_mice, :);
control_SST_Gq_pre_dcz = control_SST_Gq_pre_dcz(setmice.control_SST_Gq_mice, :);
control_SST_Gq_post = control_SST_Gq_post(setmice.control_SST_Gq_mice, :);

% Compile RWSCF_VIP_Gq data
RWSCF_VIP_Gq_pre_wo = cell(nMice, 5);
RWSCF_VIP_Gq_pre_o = cell(nMice, 5);
RWSCF_VIP_Gq_pre_dcz = cell(nMice, 5);
RWSCF_VIP_Gq_post = cell(nMice, 5);

for i = setmice.RWSCF_VIP_Gq_mice
    [RWSCF_VIP_Gq_pre_wo{i, 1}, RWSCF_VIP_Gq_pre_o{i, 1}, RWSCF_VIP_Gq_pre_dcz{i, 1}, RWSCF_VIP_Gq_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_VIP_Gq_pre_wo{i, 2}, RWSCF_VIP_Gq_pre_o{i, 2}, RWSCF_VIP_Gq_pre_dcz{i, 2}, RWSCF_VIP_Gq_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_VIP_Gq_pre_wo{i, 3}, RWSCF_VIP_Gq_pre_o{i, 3}, RWSCF_VIP_Gq_pre_dcz{i, 3}, RWSCF_VIP_Gq_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_VIP_Gq_pre_wo{i, 4}, RWSCF_VIP_Gq_pre_o{i, 4}, RWSCF_VIP_Gq_pre_dcz{i, 4}, RWSCF_VIP_Gq_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_VIP_Gq_pre_wo{i, 5}, RWSCF_VIP_Gq_pre_o{i, 5}, RWSCF_VIP_Gq_pre_dcz{i, 5}, RWSCF_VIP_Gq_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWSCF_VIP_Gq_pre_wo = RWSCF_VIP_Gq_pre_wo(setmice.RWSCF_VIP_Gq_mice, :);
RWSCF_VIP_Gq_pre_o = RWSCF_VIP_Gq_pre_o(setmice.RWSCF_VIP_Gq_mice, :);
RWSCF_VIP_Gq_pre_dcz = RWSCF_VIP_Gq_pre_dcz(setmice.RWSCF_VIP_Gq_mice, :);
RWSCF_VIP_Gq_post = RWSCF_VIP_Gq_post(setmice.RWSCF_VIP_Gq_mice, :);

% Compile control_VIP_Gq data
control_VIP_Gq_pre_wo = cell(nMice, 5);
control_VIP_Gq_pre_o = cell(nMice, 5);
control_VIP_Gq_pre_dcz = cell(nMice, 5);
control_VIP_Gq_post = cell(nMice, 5);

for i = setmice.control_VIP_Gq_mice
    [control_VIP_Gq_pre_wo{i, 1}, control_VIP_Gq_pre_o{i, 1}, control_VIP_Gq_pre_dcz{i, 1}, control_VIP_Gq_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gq_pre_wo{i, 2}, control_VIP_Gq_pre_o{i, 2}, control_VIP_Gq_pre_dcz{i, 2}, control_VIP_Gq_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gq_pre_wo{i, 3}, control_VIP_Gq_pre_o{i, 3}, control_VIP_Gq_pre_dcz{i, 3}, control_VIP_Gq_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gq_pre_wo{i, 4}, control_VIP_Gq_pre_o{i, 4}, control_VIP_Gq_pre_dcz{i, 4}, control_VIP_Gq_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gq_pre_wo{i, 5}, control_VIP_Gq_pre_o{i, 5}, control_VIP_Gq_pre_dcz{i, 5}, control_VIP_Gq_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_VIP_Gq_pre_wo = control_VIP_Gq_pre_wo(setmice.control_VIP_Gq_mice, :);
control_VIP_Gq_pre_o = control_VIP_Gq_pre_o(setmice.control_VIP_Gq_mice, :);
control_VIP_Gq_pre_dcz = control_VIP_Gq_pre_dcz(setmice.control_VIP_Gq_mice, :);
control_VIP_Gq_post = control_VIP_Gq_post(setmice.control_VIP_Gq_mice, :);

% Compile RWS_VIP_Gi data
RWS_VIP_Gi_pre_wo = cell(nMice, 5);
RWS_VIP_Gi_pre_o = cell(nMice, 5);
RWS_VIP_Gi_pre_dcz = cell(nMice, 5);
RWS_VIP_Gi_post = cell(nMice, 5);

for i = setmice.RWS_VIP_Gi_mice
    [RWS_VIP_Gi_pre_wo{i, 1}, RWS_VIP_Gi_pre_o{i, 1}, RWS_VIP_Gi_pre_dcz{i, 1}, RWS_VIP_Gi_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_VIP_Gi_pre_wo{i, 2}, RWS_VIP_Gi_pre_o{i, 2}, RWS_VIP_Gi_pre_dcz{i, 2}, RWS_VIP_Gi_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_VIP_Gi_pre_wo{i, 3}, RWS_VIP_Gi_pre_o{i, 3}, RWS_VIP_Gi_pre_dcz{i, 3}, RWS_VIP_Gi_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_VIP_Gi_pre_wo{i, 4}, RWS_VIP_Gi_pre_o{i, 4}, RWS_VIP_Gi_pre_dcz{i, 4}, RWS_VIP_Gi_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_VIP_Gi_pre_wo{i, 5}, RWS_VIP_Gi_pre_o{i, 5}, RWS_VIP_Gi_pre_dcz{i, 5}, RWS_VIP_Gi_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWS_VIP_Gi_pre_wo = RWS_VIP_Gi_pre_wo(setmice.RWS_VIP_Gi_mice, :);
RWS_VIP_Gi_pre_o = RWS_VIP_Gi_pre_o(setmice.RWS_VIP_Gi_mice, :);
RWS_VIP_Gi_pre_dcz = RWS_VIP_Gi_pre_dcz(setmice.RWS_VIP_Gi_mice, :);
RWS_VIP_Gi_post = RWS_VIP_Gi_post(setmice.RWS_VIP_Gi_mice, :);


% Compile control_VIP_Gi data
control_VIP_Gi_pre_wo = cell(nMice, 5);
control_VIP_Gi_pre_o = cell(nMice, 5);
control_VIP_Gi_pre_dcz = cell(nMice, 5);
control_VIP_Gi_post = cell(nMice, 5);

for i = setmice.control_VIP_Gi_mice
    [control_VIP_Gi_pre_wo{i, 1}, control_VIP_Gi_pre_o{i, 1}, control_VIP_Gi_pre_dcz{i, 1}, control_VIP_Gi_post{i, 1}] = parsemouse_WCF_O(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gi_pre_wo{i, 2}, control_VIP_Gi_pre_o{i, 2}, control_VIP_Gi_pre_dcz{i, 2}, control_VIP_Gi_post{i, 2}] = parsemouse_WCF_O(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gi_pre_wo{i, 3}, control_VIP_Gi_pre_o{i, 3}, control_VIP_Gi_pre_dcz{i, 3}, control_VIP_Gi_post{i, 3}] = parsemouse_WCF_O(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gi_pre_wo{i, 4}, control_VIP_Gi_pre_o{i, 4}, control_VIP_Gi_pre_dcz{i, 4}, control_VIP_Gi_post{i, 4}] = parsemouse_WCF_O(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gi_pre_wo{i, 5}, control_VIP_Gi_pre_o{i, 5}, control_VIP_Gi_pre_dcz{i, 5}, control_VIP_Gi_post{i, 5}] = parsemouse_WCF_O(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_VIP_Gi_pre_wo = control_VIP_Gi_pre_wo(setmice.control_VIP_Gi_mice, :);
control_VIP_Gi_pre_o = control_VIP_Gi_pre_o(setmice.control_VIP_Gi_mice, :);
control_VIP_Gi_pre_dcz = control_VIP_Gi_pre_dcz(setmice.control_VIP_Gi_mice, :);
control_VIP_Gi_post = control_VIP_Gi_post(setmice.control_VIP_Gi_mice, :);

% Compile SST_Gi_ZI data
SST_Gi_ZI_pre_wo = cell(nMice, 5);
SST_Gi_ZI_pre_o = cell(nMice, 5);
SST_Gi_ZI_pre_dcz = cell(nMice, 5);
SST_Gi_ZI_pre_dcz_o = cell(nMice, 5);

for i = setmice.SST_Gi_ZI_mice
    [SST_Gi_ZI_pre_wo{i, 1}, SST_Gi_ZI_pre_o{i, 1}, SST_Gi_ZI_pre_dcz{i, 1}, SST_Gi_ZI_pre_dcz_o{i, 1}] = parsemouse_WCF_O_ZI(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [SST_Gi_ZI_pre_wo{i, 2}, SST_Gi_ZI_pre_o{i, 2}, SST_Gi_ZI_pre_dcz{i, 2}, SST_Gi_ZI_pre_dcz_o{i, 2}] = parsemouse_WCF_O_ZI(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [SST_Gi_ZI_pre_wo{i, 3}, SST_Gi_ZI_pre_o{i, 3}, SST_Gi_ZI_pre_dcz{i, 3}, SST_Gi_ZI_pre_dcz_o{i, 3}] = parsemouse_WCF_O_ZI(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [SST_Gi_ZI_pre_wo{i, 4}, SST_Gi_ZI_pre_o{i, 4}, SST_Gi_ZI_pre_dcz{i, 4}, SST_Gi_ZI_pre_dcz_o{i, 4}] = parsemouse_WCF_O_ZI(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [SST_Gi_ZI_pre_wo{i, 5}, SST_Gi_ZI_pre_o{i, 5}, SST_Gi_ZI_pre_dcz{i, 5}, SST_Gi_ZI_pre_dcz_o{i, 5}] = parsemouse_WCF_O_ZI(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

SST_Gi_ZI_pre_wo = SST_Gi_ZI_pre_wo(setmice.SST_Gi_ZI_mice, :);
SST_Gi_ZI_pre_o = SST_Gi_ZI_pre_o(setmice.SST_Gi_ZI_mice, :);
SST_Gi_ZI_pre_dcz = SST_Gi_ZI_pre_dcz(setmice.SST_Gi_ZI_mice, :);
SST_Gi_ZI_pre_dcz_o = SST_Gi_ZI_pre_dcz_o(setmice.SST_Gi_ZI_mice, :);

% Compile PV_Gi_ZI data
PV_Gi_ZI_pre_wo = cell(nMice, 5);
PV_Gi_ZI_pre_o = cell(nMice, 5);
PV_Gi_ZI_pre_dcz = cell(nMice, 5);
PV_Gi_ZI_pre_dcz_o = cell(nMice, 5);

for i = setmice.PV_Gi_ZI_mice
    [PV_Gi_ZI_pre_wo{i, 1}, PV_Gi_ZI_pre_o{i, 1}, PV_Gi_ZI_pre_dcz{i, 1}, PV_Gi_ZI_pre_dcz_o{i, 1}] = parsemouse_WCF_O_ZI(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [PV_Gi_ZI_pre_wo{i, 2}, PV_Gi_ZI_pre_o{i, 2}, PV_Gi_ZI_pre_dcz{i, 2}, PV_Gi_ZI_pre_dcz_o{i, 2}] = parsemouse_WCF_O_ZI(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [PV_Gi_ZI_pre_wo{i, 3}, PV_Gi_ZI_pre_o{i, 3}, PV_Gi_ZI_pre_dcz{i, 3}, PV_Gi_ZI_pre_dcz_o{i, 3}] = parsemouse_WCF_O_ZI(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [PV_Gi_ZI_pre_wo{i, 4}, PV_Gi_ZI_pre_o{i, 4}, PV_Gi_ZI_pre_dcz{i, 4}, PV_Gi_ZI_pre_dcz_o{i, 4}] = parsemouse_WCF_O_ZI(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [PV_Gi_ZI_pre_wo{i, 5}, PV_Gi_ZI_pre_o{i, 5}, PV_Gi_ZI_pre_dcz{i, 5}, PV_Gi_ZI_pre_dcz_o{i, 5}] = parsemouse_WCF_O_ZI(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

PV_Gi_ZI_pre_wo = PV_Gi_ZI_pre_wo(setmice.PV_Gi_ZI_mice, :);
PV_Gi_ZI_pre_o = PV_Gi_ZI_pre_o(setmice.PV_Gi_ZI_mice, :);
PV_Gi_ZI_pre_dcz = PV_Gi_ZI_pre_dcz(setmice.PV_Gi_ZI_mice, :);
PV_Gi_ZI_pre_dcz_o = PV_Gi_ZI_pre_dcz_o(setmice.PV_Gi_ZI_mice, :);


if cellavg
    pre_wo = cellaverage(pre_wo);
    pre_o = cellaverage(pre_o);
    RWS_pre_wo = cellaverage(RWS_pre_wo);
    RWS_pre_o = cellaverage(RWS_pre_o);
    RWS_post = cellaverage(RWS_post);
    
    RWSCF_pre_wo = cellaverage(RWSCF_pre_wo);
    RWSCF_pre_o = cellaverage(RWSCF_pre_o);
    RWSCF_post = cellaverage(RWSCF_post);

    RWSCF_PV_JAWS_pre_wo = cellaverage(RWSCF_PV_JAWS_pre_wo);
    RWSCF_PV_JAWS_pre_o = cellaverage(RWSCF_PV_JAWS_pre_o);
    RWSCF_PV_JAWS_post = cellaverage(RWSCF_PV_JAWS_post);

    control_PV_JAWS_pre_wo = cellaverage(control_PV_JAWS_pre_wo);
    control_PV_JAWS_pre_o = cellaverage(control_PV_JAWS_pre_o);
    control_PV_JAWS_post = cellaverage(control_PV_JAWS_post);

    RWSCF_PV_Gi_pre_wo = cellaverage(RWSCF_PV_Gi_pre_wo);
    RWSCF_PV_Gi_pre_o = cellaverage(RWSCF_PV_Gi_pre_o);
    RWSCF_PV_Gi_pre_dcz = cellaverage(RWSCF_PV_Gi_pre_dcz);
    RWSCF_PV_Gi_post = cellaverage(RWSCF_PV_Gi_post);

    control_PV_Gi_pre_wo = cellaverage(control_PV_Gi_pre_wo);
    control_PV_Gi_pre_o = cellaverage(control_PV_Gi_pre_o);
    control_PV_Gi_pre_dcz = cellaverage(control_PV_Gi_pre_dcz);
    control_PV_Gi_post = cellaverage(control_PV_Gi_post);

    RWS_PV_Gq_pre_wo = cellaverage(RWS_PV_Gq_pre_wo);
    RWS_PV_Gq_pre_o = cellaverage(RWS_PV_Gq_pre_o);
    RWS_PV_Gq_pre_dcz = cellaverage(RWS_PV_Gq_pre_dcz);
    RWS_PV_Gq_post = cellaverage(RWS_PV_Gq_post);

    control_PV_Gq_pre_wo = cellaverage(control_PV_Gq_pre_wo);
    control_PV_Gq_pre_o = cellaverage(control_PV_Gq_pre_o);
    control_PV_Gq_pre_dcz = cellaverage(control_PV_Gq_pre_dcz);
    control_PV_Gq_post = cellaverage(control_PV_Gq_post);

    RWSCF_SST_Gi_pre_wo = cellaverage(RWSCF_SST_Gi_pre_wo);
    RWSCF_SST_Gi_pre_o = cellaverage(RWSCF_SST_Gi_pre_o);
    RWSCF_SST_Gi_pre_dcz = cellaverage(RWSCF_SST_Gi_pre_dcz);
    RWSCF_SST_Gi_post = cellaverage(RWSCF_SST_Gi_post);

    control_SST_Gi_pre_wo = cellaverage(control_SST_Gi_pre_wo);
    control_SST_Gi_pre_o = cellaverage(control_SST_Gi_pre_o);
    control_SST_Gi_pre_dcz = cellaverage(control_SST_Gi_pre_dcz);
    control_SST_Gi_post = cellaverage(control_SST_Gi_post);

    RWS_SST_Gq_pre_wo = cellaverage(RWS_SST_Gq_pre_wo);
    RWS_SST_Gq_pre_o = cellaverage(RWS_SST_Gq_pre_o);
    RWS_SST_Gq_pre_dcz = cellaverage(RWS_SST_Gq_pre_dcz);
    RWS_SST_Gq_post = cellaverage(RWS_SST_Gq_post);

    control_SST_Gq_pre_wo = cellaverage(control_SST_Gq_pre_wo);
    control_SST_Gq_pre_o = cellaverage(control_SST_Gq_pre_o);
    control_SST_Gq_pre_dcz = cellaverage(control_SST_Gq_pre_dcz);
    control_SST_Gq_post = cellaverage(control_SST_Gq_post);

    RWSCF_VIP_Gq_pre_wo = cellaverage(RWSCF_VIP_Gq_pre_wo);
    RWSCF_VIP_Gq_pre_o = cellaverage(RWSCF_VIP_Gq_pre_o);
    RWSCF_VIP_Gq_pre_dcz = cellaverage(RWSCF_VIP_Gq_pre_dcz);
    RWSCF_VIP_Gq_post = cellaverage(RWSCF_VIP_Gq_post);

    control_VIP_Gq_pre_wo = cellaverage(control_VIP_Gq_pre_wo);
    control_VIP_Gq_pre_o = cellaverage(control_VIP_Gq_pre_o);
    control_VIP_Gq_pre_dcz = cellaverage(control_VIP_Gq_pre_dcz);
    control_VIP_Gq_post = cellaverage(control_VIP_Gq_post);

    RWS_VIP_Gi_pre_wo = cellaverage(RWS_VIP_Gi_pre_wo);
    RWS_VIP_Gi_pre_o = cellaverage(RWS_VIP_Gi_pre_o);
    RWS_VIP_Gi_pre_dcz = cellaverage(RWS_VIP_Gi_pre_dcz);
    RWS_VIP_Gi_post = cellaverage(RWS_VIP_Gi_post);

    control_VIP_Gi_pre_wo = cellaverage(control_VIP_Gi_pre_wo);
    control_VIP_Gi_pre_o = cellaverage(control_VIP_Gi_pre_o);
    control_VIP_Gi_pre_dcz = cellaverage(control_VIP_Gi_pre_dcz);
    control_VIP_Gi_post = cellaverage(control_VIP_Gi_post);

    SST_Gi_ZI_pre_wo = cellaverage(SST_Gi_ZI_pre_wo);
    SST_Gi_ZI_pre_o = cellaverage(SST_Gi_ZI_pre_o);
    SST_Gi_ZI_pre_dcz = cellaverage(SST_Gi_ZI_pre_dcz);
    SST_Gi_ZI_pre_dcz_o = cellaverage(SST_Gi_ZI_pre_dcz_o);

    PV_Gi_ZI_pre_wo = cellaverage(PV_Gi_ZI_pre_wo);
    PV_Gi_ZI_pre_o = cellaverage(PV_Gi_ZI_pre_o);
    PV_Gi_ZI_pre_dcz = cellaverage(PV_Gi_ZI_pre_dcz);
    PV_Gi_ZI_pre_dcz_o = cellaverage(PV_Gi_ZI_pre_dcz_o);


end

if catmouse
    pre_wo = mouseconcatenate(pre_wo);
    pre_o = mouseconcatenate(pre_o);
    RWS_pre_wo = mouseconcatenate(RWS_pre_wo);
    RWS_pre_o = mouseconcatenate(RWS_pre_o);
    RWS_post = mouseconcatenate(RWS_post);
    
    RWSCF_pre_wo = mouseconcatenate(RWSCF_pre_wo);
    RWSCF_pre_o = mouseconcatenate(RWSCF_pre_o);
    RWSCF_post = mouseconcatenate(RWSCF_post);

    RWSCF_PV_JAWS_pre_wo = mouseconcatenate(RWSCF_PV_JAWS_pre_wo);
    RWSCF_PV_JAWS_pre_o = mouseconcatenate(RWSCF_PV_JAWS_pre_o);
    RWSCF_PV_JAWS_post = mouseconcatenate(RWSCF_PV_JAWS_post);

    control_PV_JAWS_pre_wo = mouseconcatenate(control_PV_JAWS_pre_wo);
    control_PV_JAWS_pre_o = mouseconcatenate(control_PV_JAWS_pre_o);
    control_PV_JAWS_post = mouseconcatenate(control_PV_JAWS_post);

    RWSCF_PV_Gi_pre_wo = mouseconcatenate(RWSCF_PV_Gi_pre_wo);
    RWSCF_PV_Gi_pre_o = mouseconcatenate(RWSCF_PV_Gi_pre_o);
    RWSCF_PV_Gi_pre_dcz = mouseconcatenate(RWSCF_PV_Gi_pre_dcz);
    RWSCF_PV_Gi_post = mouseconcatenate(RWSCF_PV_Gi_post);

    control_PV_Gi_pre_wo = mouseconcatenate(control_PV_Gi_pre_wo);
    control_PV_Gi_pre_o = mouseconcatenate(control_PV_Gi_pre_o);
    control_PV_Gi_pre_dcz = mouseconcatenate(control_PV_Gi_pre_dcz);
    control_PV_Gi_post = mouseconcatenate(control_PV_Gi_post);

    RWS_PV_Gq_pre_wo = mouseconcatenate(RWS_PV_Gq_pre_wo);
    RWS_PV_Gq_pre_o = mouseconcatenate(RWS_PV_Gq_pre_o);
    RWS_PV_Gq_pre_dcz = mouseconcatenate(RWS_PV_Gq_pre_dcz);
    RWS_PV_Gq_post = mouseconcatenate(RWS_PV_Gq_post);

    control_PV_Gq_pre_wo = mouseconcatenate(control_PV_Gq_pre_wo);
    control_PV_Gq_pre_o = mouseconcatenate(control_PV_Gq_pre_o);
    control_PV_Gq_pre_dcz = mouseconcatenate(control_PV_Gq_pre_dcz);
    control_PV_Gq_post = mouseconcatenate(control_PV_Gq_post);

    RWSCF_SST_Gi_pre_wo = mouseconcatenate(RWSCF_SST_Gi_pre_wo);
    RWSCF_SST_Gi_pre_o = mouseconcatenate(RWSCF_SST_Gi_pre_o);
    RWSCF_SST_Gi_pre_dcz = mouseconcatenate(RWSCF_SST_Gi_pre_dcz);
    RWSCF_SST_Gi_post = mouseconcatenate(RWSCF_SST_Gi_post);

    control_SST_Gi_pre_wo = mouseconcatenate(control_SST_Gi_pre_wo);
    control_SST_Gi_pre_o = mouseconcatenate(control_SST_Gi_pre_o);
    control_SST_Gi_pre_dcz = mouseconcatenate(control_SST_Gi_pre_dcz);
    control_SST_Gi_post = mouseconcatenate(control_SST_Gi_post);

    RWS_SST_Gq_pre_wo = mouseconcatenate(RWS_SST_Gq_pre_wo);
    RWS_SST_Gq_pre_o = mouseconcatenate(RWS_SST_Gq_pre_o);
    RWS_SST_Gq_pre_dcz = mouseconcatenate(RWS_SST_Gq_pre_dcz);
    RWS_SST_Gq_post = mouseconcatenate(RWS_SST_Gq_post);

    control_SST_Gq_pre_wo = mouseconcatenate(control_SST_Gq_pre_wo);
    control_SST_Gq_pre_o = mouseconcatenate(control_SST_Gq_pre_o);
    control_SST_Gq_pre_dcz = mouseconcatenate(control_SST_Gq_pre_dcz);
    control_SST_Gq_post = mouseconcatenate(control_SST_Gq_post);

    RWSCF_VIP_Gq_pre_wo = mouseconcatenate(RWSCF_VIP_Gq_pre_wo);
    RWSCF_VIP_Gq_pre_o = mouseconcatenate(RWSCF_VIP_Gq_pre_o);
    RWSCF_VIP_Gq_pre_dcz = mouseconcatenate(RWSCF_VIP_Gq_pre_dcz);
    RWSCF_VIP_Gq_post = mouseconcatenate(RWSCF_VIP_Gq_post);

    control_VIP_Gq_pre_wo = mouseconcatenate(control_VIP_Gq_pre_wo);
    control_VIP_Gq_pre_o = mouseconcatenate(control_VIP_Gq_pre_o);
    control_VIP_Gq_pre_dcz = mouseconcatenate(control_VIP_Gq_pre_dcz);
    control_VIP_Gq_post = mouseconcatenate(control_VIP_Gq_post);

    RWS_VIP_Gi_pre_wo = mouseconcatenate(RWS_VIP_Gi_pre_wo);
    RWS_VIP_Gi_pre_o = mouseconcatenate(RWS_VIP_Gi_pre_o);
    RWS_VIP_Gi_pre_dcz = mouseconcatenate(RWS_VIP_Gi_pre_dcz);
    RWS_VIP_Gi_post = mouseconcatenate(RWS_VIP_Gi_post);

    control_VIP_Gi_pre_wo = mouseconcatenate(control_VIP_Gi_pre_wo);
    control_VIP_Gi_pre_o = mouseconcatenate(control_VIP_Gi_pre_o);
    control_VIP_Gi_pre_dcz = mouseconcatenate(control_VIP_Gi_pre_dcz);
    control_VIP_Gi_post = mouseconcatenate(control_VIP_Gi_post);

    SST_Gi_ZI_pre_wo = mouseconcatenate(SST_Gi_ZI_pre_wo);
    SST_Gi_ZI_pre_o = mouseconcatenate(SST_Gi_ZI_pre_o);
    SST_Gi_ZI_pre_dcz = mouseconcatenate(SST_Gi_ZI_pre_dcz);
    SST_Gi_ZI_pre_dcz_o = mouseconcatenate(SST_Gi_ZI_pre_dcz_o);

    PV_Gi_ZI_pre_wo = mouseconcatenate(PV_Gi_ZI_pre_wo);
    PV_Gi_ZI_pre_o = mouseconcatenate(PV_Gi_ZI_pre_o);
    PV_Gi_ZI_pre_dcz = mouseconcatenate(PV_Gi_ZI_pre_dcz);
    PV_Gi_ZI_pre_dcz_o = mouseconcatenate(PV_Gi_ZI_pre_dcz_o);

end

end

function variable = cellaverage(variable)
    for w = 1:size(variable, 1)
        for x = 1:size(variable, 2)
            temp = variable{w, x};
            temp = mean(temp, 2, 'omitnan');
            variable{w, x} = temp;
        end
    end

end

function variable = mouseconcatenate(variable)
    PV = [];
    PN = [];
    VIP = [];
    UC = [];
    SST = [];
    for y = 1:size(variable, 1)
        PV_temp = variable{y, 1};
        PN_temp = variable{y, 2};
        VIP_temp = variable{y, 3};
        UC_temp = variable{y, 4};
        SST_temp = variable{y, 5};

        PV = cat(2, PV, PV_temp);
        PN = cat(2, PN, PN_temp);
        VIP = cat(2, VIP, VIP_temp);
        UC = cat(2, UC, UC_temp);
        SST = cat(2, SST, SST_temp);
    end

    variable = {PV, PN, VIP, UC, SST};

end