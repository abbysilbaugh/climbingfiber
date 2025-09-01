% For each condition...
    % Creates nMice x nCelltype cell array; each cell contains nFrames x nCells x nTrials double
    % If trialavg...
        % Each cell is trial averaged within mice (NaN trials are not included)
        % Output: nMice x nCelltype cell array; each cell contains nFrames nCells double
        
    % If trialavg & cellaverage...
        % Each cell is trial averaged within mice
        % Cells are averaged within mouse
        % Output: nMice x nCelltype cell array; each cell contains nFrames x 1 double

    % If trialavg & catmouse...
        % Each cell is trial averaged within mice
        % All cells are concatenated across mice
        % Output: nCelltype x 1 cell array; each cell contains nFrames x nTotalCells

    % If trialavg & cellaverage & catmouse...
        % Each cell is trial averaged within mice
       
                        


function [pre, pre_wo, ...
    RWS_pre, RWS_pre_wo, RWS_post, ...
    RWSCF_pre, RWSCF_pre_wo, RWSCF_post, ...
    RWSCF_PV_JAWS_pre, RWSCF_PV_JAWS_pre_wo, RWSCF_PV_JAWS_post, ...
    control_PV_JAWS_pre, control_PV_JAWS_pre_wo, control_PV_JAWS_post, ...
    RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_wo, RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, ...
    control_PV_Gi_pre, control_PV_Gi_pre_wo, control_PV_Gi_pre_dcz, control_PV_Gi_post, ...
    RWSCF_SST_Gi_pre, RWSCF_SST_Gi_pre_wo, RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, ...
    control_SST_Gi_pre, control_SST_Gi_pre_wo, control_SST_Gi_pre_dcz, control_SST_Gi_post, ...
    RWS_SST_Gq_pre, RWS_SST_Gq_pre_wo, RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, ...
    control_SST_Gq_pre, control_SST_Gq_pre_wo, control_SST_Gq_pre_dcz, control_SST_Gq_post] ...
    = parseexperiments(baselineshiftperiod, baselineshift, baseline_reject_thresh, trialavg, cellavg, catmouse, mottype, allData, signaltype, BT_mice, RWS_mice, RWSCF_mice, RWSCF_PV_JAWS_mice, control_PV_JAWS_mice, RWSCF_PV_Gi_mice, control_PV_Gi_mice, RWSCF_SST_Gi_mice, control_SST_Gi_mice, RWS_SST_Gq_mice, control_SST_Gq_mice)

nMice = size(allData.data, 2);

% Compile basic transmission data
pre = cell(nMice, 5);
pre_wo = cell(nMice, 5);
for i = BT_mice
    [pre{i, 1}, pre_wo{i, 1}, ~, ~] = parsemouse(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [pre{i, 2}, pre_wo{i, 2}, ~, ~] = parsemouse(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [pre{i, 3}, pre_wo{i, 3}, ~, ~] = parsemouse(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [pre{i, 4}, pre_wo{i, 4}, ~, ~] = parsemouse(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [pre{i, 5}, pre_wo{i, 5}, ~, ~] = parsemouse(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

pre = pre(BT_mice, :);
pre_wo = pre_wo(BT_mice, :);

% Compile RWS data
RWS_pre = cell(nMice, 5);
RWS_pre_wo = cell(nMice, 5);
RWS_post = cell(nMice, 5);

for i = RWS_mice
    [RWS_pre{i, 1}, RWS_pre_wo{i, 1}, ~, RWS_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_pre{i, 2}, RWS_pre_wo{i, 2}, ~, RWS_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_pre{i, 3}, RWS_pre_wo{i, 3}, ~, RWS_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_pre{i, 4}, RWS_pre_wo{i, 4}, ~, RWS_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_pre{i, 5}, RWS_pre_wo{i, 5}, ~, RWS_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWS_pre = RWS_pre(RWS_mice, :);
RWS_pre_wo = RWS_pre_wo(RWS_mice, :);
RWS_post = RWS_post(RWS_mice, :);

% Compile RWSCF data
RWSCF_pre = cell(nMice, 5);
RWSCF_pre_wo = cell(nMice, 5);
RWSCF_post = cell(nMice, 5);

for i = RWSCF_mice
    [RWSCF_pre{i, 1}, RWSCF_pre_wo{i, 1}, ~, RWSCF_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_pre{i, 2}, RWSCF_pre_wo{i, 2}, ~, RWSCF_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_pre{i, 3}, RWSCF_pre_wo{i, 3}, ~, RWSCF_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_pre{i, 4}, RWSCF_pre_wo{i, 4}, ~, RWSCF_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_pre{i, 5}, RWSCF_pre_wo{i, 5}, ~, RWSCF_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWSCF_pre = RWSCF_pre(RWS_mice, :);
RWSCF_pre_wo = RWSCF_pre_wo(RWS_mice, :);
RWSCF_post = RWSCF_post(RWS_mice, :);

% Compile RWSCF_PV_JAWS data
RWSCF_PV_JAWS_pre = cell(nMice, 5);
RWSCF_PV_JAWS_pre_wo = cell(nMice, 5);
RWSCF_PV_JAWS_post = cell(nMice, 5);

for i = RWSCF_PV_JAWS_mice
    [RWSCF_PV_JAWS_pre{i, 1}, RWSCF_PV_JAWS_pre_wo{i, 1}, ~, RWSCF_PV_JAWS_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_JAWS_pre{i, 2}, RWSCF_PV_JAWS_pre_wo{i, 2}, ~, RWSCF_PV_JAWS_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_JAWS_pre{i, 3}, RWSCF_PV_JAWS_pre_wo{i, 3}, ~, RWSCF_PV_JAWS_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_JAWS_pre{i, 4}, RWSCF_PV_JAWS_pre_wo{i, 4}, ~, RWSCF_PV_JAWS_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_JAWS_pre{i, 5}, RWSCF_PV_JAWS_pre_wo{i, 5}, ~, RWSCF_PV_JAWS_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWSCF_PV_JAWS_pre = RWSCF_PV_JAWS_pre(RWSCF_PV_JAWS_mice, :);
RWSCF_PV_JAWS_pre_wo = RWSCF_PV_JAWS_pre_wo(RWSCF_PV_JAWS_mice, :);
RWSCF_PV_JAWS_post = RWSCF_PV_JAWS_post(RWSCF_PV_JAWS_mice, :);

% Compile control_PV_JAWS data
control_PV_JAWS_pre = cell(nMice, 5);
control_PV_JAWS_pre_wo = cell(nMice, 5);
control_PV_JAWS_post = cell(nMice, 5);

for i = control_PV_JAWS_mice
    [control_PV_JAWS_pre{i, 1}, control_PV_JAWS_pre_wo{i, 1}, ~, control_PV_JAWS_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_JAWS_pre{i, 2}, control_PV_JAWS_pre_wo{i, 2}, ~, control_PV_JAWS_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_JAWS_pre{i, 3}, control_PV_JAWS_pre_wo{i, 3}, ~, control_PV_JAWS_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_JAWS_pre{i, 4}, control_PV_JAWS_pre_wo{i, 4}, ~, control_PV_JAWS_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_JAWS_pre{i, 5}, control_PV_JAWS_pre_wo{i, 5}, ~, control_PV_JAWS_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_PV_JAWS_pre = control_PV_JAWS_pre(control_PV_JAWS_mice, :);
control_PV_JAWS_pre_wo = control_PV_JAWS_pre_wo(control_PV_JAWS_mice, :);
control_PV_JAWS_post = control_PV_JAWS_post(control_PV_JAWS_mice, :);

% Compile RWSCF_PV_Gi data
RWSCF_PV_Gi_pre = cell(nMice, 5);
RWSCF_PV_Gi_pre_wo = cell(nMice, 5);
RWSCF_PV_Gi_pre_dcz = cell(nMice, 5);
RWSCF_PV_Gi_post = cell(nMice, 5);

for i = RWSCF_PV_Gi_mice
    [RWSCF_PV_Gi_pre{i, 1}, RWSCF_PV_Gi_pre_wo{i, 1}, RWSCF_PV_Gi_pre_dcz{i, 1}, RWSCF_PV_Gi_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_Gi_pre{i, 2}, RWSCF_PV_Gi_pre_wo{i, 2}, RWSCF_PV_Gi_pre_dcz{i, 2}, RWSCF_PV_Gi_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_Gi_pre{i, 3}, RWSCF_PV_Gi_pre_wo{i, 3}, RWSCF_PV_Gi_pre_dcz{i, 3}, RWSCF_PV_Gi_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_Gi_pre{i, 4}, RWSCF_PV_Gi_pre_wo{i, 4}, RWSCF_PV_Gi_pre_dcz{i, 4}, RWSCF_PV_Gi_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_Gi_pre{i, 5}, RWSCF_PV_Gi_pre_wo{i, 5}, RWSCF_PV_Gi_pre_dcz{i, 5}, RWSCF_PV_Gi_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWSCF_PV_Gi_pre = RWSCF_PV_Gi_pre(RWSCF_PV_Gi_mice, :);
RWSCF_PV_Gi_pre_wo = RWSCF_PV_Gi_pre_wo(RWSCF_PV_Gi_mice, :);
RWSCF_PV_Gi_pre_dcz = RWSCF_PV_Gi_pre_dcz(RWSCF_PV_Gi_mice, :);
RWSCF_PV_Gi_post = RWSCF_PV_Gi_post(RWSCF_PV_Gi_mice, :);

% Compile control_PV_Gi data
control_PV_Gi_pre = cell(nMice, 5);
control_PV_Gi_pre_wo = cell(nMice, 5);
control_PV_Gi_pre_dcz = cell(nMice, 5);
control_PV_Gi_post = cell(nMice, 5);

for i = control_PV_Gi_mice
    [control_PV_Gi_pre{i, 1}, control_PV_Gi_pre_wo{i, 1}, control_PV_Gi_pre_dcz{i, 1}, control_PV_Gi_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gi_pre{i, 2}, control_PV_Gi_pre_wo{i, 2}, control_PV_Gi_pre_dcz{i, 2}, control_PV_Gi_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gi_pre{i, 3}, control_PV_Gi_pre_wo{i, 3}, control_PV_Gi_pre_dcz{i, 3}, control_PV_Gi_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gi_pre{i, 4}, control_PV_Gi_pre_wo{i, 4}, control_PV_Gi_pre_dcz{i, 4}, control_PV_Gi_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gi_pre{i, 5}, control_PV_Gi_pre_wo{i, 5}, control_PV_Gi_pre_dcz{i, 5}, control_PV_Gi_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_PV_Gi_pre = control_PV_Gi_pre(control_PV_Gi_mice, :);
control_PV_Gi_pre_wo = control_PV_Gi_pre_wo(control_PV_Gi_mice, :);
control_PV_Gi_pre_dcz = control_PV_Gi_pre_dcz(control_PV_Gi_mice, :);
control_PV_Gi_post = control_PV_Gi_post(control_PV_Gi_mice, :);

% Compile RWSCF_SST_Gi data
RWSCF_SST_Gi_pre = cell(nMice, 5);
RWSCF_SST_Gi_pre_wo = cell(nMice, 5);
RWSCF_SST_Gi_pre_dcz = cell(nMice, 5);
RWSCF_SST_Gi_post = cell(nMice, 5);

for i = RWSCF_SST_Gi_mice
    [RWSCF_SST_Gi_pre{i, 1}, RWSCF_SST_Gi_pre_wo{i, 1}, RWSCF_SST_Gi_pre_dcz{i, 1}, RWSCF_SST_Gi_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_SST_Gi_pre{i, 2}, RWSCF_SST_Gi_pre_wo{i, 2}, RWSCF_SST_Gi_pre_dcz{i, 2}, RWSCF_SST_Gi_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_SST_Gi_pre{i, 3}, RWSCF_SST_Gi_pre_wo{i, 3}, RWSCF_SST_Gi_pre_dcz{i, 3}, RWSCF_SST_Gi_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_SST_Gi_pre{i, 4}, RWSCF_SST_Gi_pre_wo{i, 4}, RWSCF_SST_Gi_pre_dcz{i, 4}, RWSCF_SST_Gi_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_SST_Gi_pre{i, 5}, RWSCF_SST_Gi_pre_wo{i, 5}, RWSCF_SST_Gi_pre_dcz{i, 5}, RWSCF_SST_Gi_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWSCF_SST_Gi_pre = RWSCF_SST_Gi_pre(RWSCF_SST_Gi_mice, :);
RWSCF_SST_Gi_pre_wo = RWSCF_SST_Gi_pre_wo(RWSCF_SST_Gi_mice, :);
RWSCF_SST_Gi_pre_dcz = RWSCF_SST_Gi_pre_dcz(RWSCF_SST_Gi_mice, :);
RWSCF_SST_Gi_post = RWSCF_SST_Gi_post(RWSCF_SST_Gi_mice, :);

% Compile control_SST_Gi data
control_SST_Gi_pre = cell(nMice, 5);
control_SST_Gi_pre_wo = cell(nMice, 5);
control_SST_Gi_pre_dcz = cell(nMice, 5);
control_SST_Gi_post = cell(nMice, 5);

for i = control_SST_Gi_mice
    [control_SST_Gi_pre{i, 1}, control_SST_Gi_pre_wo{i, 1}, control_SST_Gi_pre_dcz{i, 1}, control_SST_Gi_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gi_pre{i, 2}, control_SST_Gi_pre_wo{i, 2}, control_SST_Gi_pre_dcz{i, 2}, control_SST_Gi_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gi_pre{i, 3}, control_SST_Gi_pre_wo{i, 3}, control_SST_Gi_pre_dcz{i, 3}, control_SST_Gi_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gi_pre{i, 4}, control_SST_Gi_pre_wo{i, 4}, control_SST_Gi_pre_dcz{i, 4}, control_SST_Gi_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gi_pre{i, 5}, control_SST_Gi_pre_wo{i, 5}, control_SST_Gi_pre_dcz{i, 5}, control_SST_Gi_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_SST_Gi_pre = control_SST_Gi_pre(control_SST_Gi_mice, :);
control_SST_Gi_pre_wo = control_SST_Gi_pre_wo(control_SST_Gi_mice, :);
control_SST_Gi_pre_dcz = control_SST_Gi_pre_dcz(control_SST_Gi_mice, :);
control_SST_Gi_post = control_SST_Gi_post(control_SST_Gi_mice, :);

% Compile RWS_SST_Gq data
RWS_SST_Gq_pre = cell(nMice, 5);
RWS_SST_Gq_pre_wo = cell(nMice, 5);
RWS_SST_Gq_pre_dcz = cell(nMice, 5);
RWS_SST_Gq_post = cell(nMice, 5);

for i = RWS_SST_Gq_mice
    [RWS_SST_Gq_pre{i, 1}, RWS_SST_Gq_pre_wo{i, 1}, RWS_SST_Gq_pre_dcz{i, 1}, RWS_SST_Gq_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_SST_Gq_pre{i, 2}, RWS_SST_Gq_pre_wo{i, 2}, RWS_SST_Gq_pre_dcz{i, 2}, RWS_SST_Gq_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_SST_Gq_pre{i, 3}, RWS_SST_Gq_pre_wo{i, 3}, RWS_SST_Gq_pre_dcz{i, 3}, RWS_SST_Gq_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_SST_Gq_pre{i, 4}, RWS_SST_Gq_pre_wo{i, 4}, RWS_SST_Gq_pre_dcz{i, 4}, RWS_SST_Gq_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_SST_Gq_pre{i, 5}, RWS_SST_Gq_pre_wo{i, 5}, RWS_SST_Gq_pre_dcz{i, 5}, RWS_SST_Gq_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWS_SST_Gq_pre = RWS_SST_Gq_pre(RWS_SST_Gq_mice, :);
RWS_SST_Gq_pre_wo = RWS_SST_Gq_pre_wo(RWS_SST_Gq_mice, :);
RWS_SST_Gq_pre_dcz = RWS_SST_Gq_pre_dcz(RWS_SST_Gq_mice, :);
RWS_SST_Gq_post = RWS_SST_Gq_post(RWS_SST_Gq_mice, :);


% Compile control_SST_Gq data
control_SST_Gq_pre = cell(nMice, 5);
control_SST_Gq_pre_wo = cell(nMice, 5);
control_SST_Gq_pre_dcz = cell(nMice, 5);
control_SST_Gq_post = cell(nMice, 5);

for i = control_SST_Gq_mice
    [control_SST_Gq_pre{i, 1}, control_SST_Gq_pre_wo{i, 1}, control_SST_Gq_pre_dcz{i, 1}, control_SST_Gq_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gq_pre{i, 2}, control_SST_Gq_pre_wo{i, 2}, control_SST_Gq_pre_dcz{i, 2}, control_SST_Gq_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gq_pre{i, 3}, control_SST_Gq_pre_wo{i, 3}, control_SST_Gq_pre_dcz{i, 3}, control_SST_Gq_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gq_pre{i, 4}, control_SST_Gq_pre_wo{i, 4}, control_SST_Gq_pre_dcz{i, 4}, control_SST_Gq_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gq_pre{i, 5}, control_SST_Gq_pre_wo{i, 5}, control_SST_Gq_pre_dcz{i, 5}, control_SST_Gq_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_SST_Gq_pre = control_SST_Gq_pre(control_SST_Gq_mice, :);
control_SST_Gq_pre_wo = control_SST_Gq_pre_wo(control_SST_Gq_mice, :);
control_SST_Gq_pre_dcz = control_SST_Gq_pre_dcz(control_SST_Gq_mice, :);
control_SST_Gq_post = control_SST_Gq_post(control_SST_Gq_mice, :);

if cellavg
    pre = cellaverage(pre);
    pre_wo = cellaverage(pre_wo);
    RWS_pre = cellaverage(RWS_pre);
    RWS_pre_wo = cellaverage(RWS_pre_wo);
    RWS_post = cellaverage(RWS_post);
    
    RWSCF_pre = cellaverage(RWSCF_pre);
    RWSCF_pre_wo = cellaverage(RWSCF_pre_wo);
    RWSCF_post = cellaverage(RWSCF_post);

    RWSCF_PV_JAWS_pre = cellaverage(RWSCF_PV_JAWS_pre);
    RWSCF_PV_JAWS_pre_wo = cellaverage(RWSCF_PV_JAWS_pre_wo);
    RWSCF_PV_JAWS_post = cellaverage(RWSCF_PV_JAWS_post);

    control_PV_JAWS_pre = cellaverage(control_PV_JAWS_pre);
    control_PV_JAWS_pre_wo = cellaverage(control_PV_JAWS_pre_wo);
    control_PV_JAWS_post = cellaverage(control_PV_JAWS_post);

    RWSCF_PV_Gi_pre = cellaverage(RWSCF_PV_Gi_pre);
    RWSCF_PV_Gi_pre_wo = cellaverage(RWSCF_PV_Gi_pre_wo);
    RWSCF_PV_Gi_pre_dcz = cellaverage(RWSCF_PV_Gi_pre_dcz);
    RWSCF_PV_Gi_post = cellaverage(RWSCF_PV_Gi_post);

    control_PV_Gi_pre = cellaverage(control_PV_Gi_pre);
    control_PV_Gi_pre_wo = cellaverage(control_PV_Gi_pre_wo);
    control_PV_Gi_pre_dcz = cellaverage(control_PV_Gi_pre_dcz);
    control_PV_Gi_post = cellaverage(control_PV_Gi_post);

    RWSCF_SST_Gi_pre = cellaverage(RWSCF_SST_Gi_pre);
    RWSCF_SST_Gi_pre_wo = cellaverage(RWSCF_SST_Gi_pre_wo);
    RWSCF_SST_Gi_pre_dcz = cellaverage(RWSCF_SST_Gi_pre_dcz);
    RWSCF_SST_Gi_post = cellaverage(RWSCF_SST_Gi_post);

    control_SST_Gi_pre = cellaverage(control_SST_Gi_pre);
    control_SST_Gi_pre_wo = cellaverage(control_SST_Gi_pre_wo);
    control_SST_Gi_pre_dcz = cellaverage(control_SST_Gi_pre_dcz);
    control_SST_Gi_post = cellaverage(control_SST_Gi_post);

    RWS_SST_Gq_pre = cellaverage(RWS_SST_Gq_pre);
    RWS_SST_Gq_pre_wo = cellaverage(RWS_SST_Gq_pre_wo);
    RWS_SST_Gq_pre_dcz = cellaverage(RWS_SST_Gq_pre_dcz);
    RWS_SST_Gq_post = cellaverage(RWS_SST_Gq_post);

    control_SST_Gq_pre = cellaverage(control_SST_Gq_pre);
    control_SST_Gq_pre_wo = cellaverage(control_SST_Gq_pre_wo);
    control_SST_Gq_pre_dcz = cellaverage(control_SST_Gq_pre_dcz);
    control_SST_Gq_post = cellaverage(control_SST_Gq_post);
end

if catmouse
    pre = mouseconcatenate(pre);
    pre_wo = mouseconcatenate(pre_wo);
    RWS_pre = mouseconcatenate(RWS_pre);
    RWS_pre_wo = mouseconcatenate(RWS_pre_wo);
    RWS_post = mouseconcatenate(RWS_post);
    
    RWSCF_pre = mouseconcatenate(RWSCF_pre);
    RWSCF_pre_wo = mouseconcatenate(RWSCF_pre_wo);
    RWSCF_post = mouseconcatenate(RWSCF_post);

    RWSCF_PV_JAWS_pre = mouseconcatenate(RWSCF_PV_JAWS_pre);
    RWSCF_PV_JAWS_pre_wo = mouseconcatenate(RWSCF_PV_JAWS_pre_wo);
    RWSCF_PV_JAWS_post = mouseconcatenate(RWSCF_PV_JAWS_post);

    control_PV_JAWS_pre = mouseconcatenate(control_PV_JAWS_pre);
    control_PV_JAWS_pre_wo = mouseconcatenate(control_PV_JAWS_pre_wo);
    control_PV_JAWS_post = mouseconcatenate(control_PV_JAWS_post);

    RWSCF_PV_Gi_pre = mouseconcatenate(RWSCF_PV_Gi_pre);
    RWSCF_PV_Gi_pre_wo = mouseconcatenate(RWSCF_PV_Gi_pre_wo);
    RWSCF_PV_Gi_pre_dcz = mouseconcatenate(RWSCF_PV_Gi_pre_dcz);
    RWSCF_PV_Gi_post = mouseconcatenate(RWSCF_PV_Gi_post);

    control_PV_Gi_pre = mouseconcatenate(control_PV_Gi_pre);
    control_PV_Gi_pre_wo = mouseconcatenate(control_PV_Gi_pre_wo);
    control_PV_Gi_pre_dcz = mouseconcatenate(control_PV_Gi_pre_dcz);
    control_PV_Gi_post = mouseconcatenate(control_PV_Gi_post);

    RWSCF_SST_Gi_pre = mouseconcatenate(RWSCF_SST_Gi_pre);
    RWSCF_SST_Gi_pre_wo = mouseconcatenate(RWSCF_SST_Gi_pre_wo);
    RWSCF_SST_Gi_pre_dcz = mouseconcatenate(RWSCF_SST_Gi_pre_dcz);
    RWSCF_SST_Gi_post = mouseconcatenate(RWSCF_SST_Gi_post);

    control_SST_Gi_pre = mouseconcatenate(control_SST_Gi_pre);
    control_SST_Gi_pre_wo = mouseconcatenate(control_SST_Gi_pre_wo);
    control_SST_Gi_pre_dcz = mouseconcatenate(control_SST_Gi_pre_dcz);
    control_SST_Gi_post = mouseconcatenate(control_SST_Gi_post);

    RWS_SST_Gq_pre = mouseconcatenate(RWS_SST_Gq_pre);
    RWS_SST_Gq_pre_wo = mouseconcatenate(RWS_SST_Gq_pre_wo);
    RWS_SST_Gq_pre_dcz = mouseconcatenate(RWS_SST_Gq_pre_dcz);
    RWS_SST_Gq_post = mouseconcatenate(RWS_SST_Gq_post);

    control_SST_Gq_pre = mouseconcatenate(control_SST_Gq_pre);
    control_SST_Gq_pre_wo = mouseconcatenate(control_SST_Gq_pre_wo);
    control_SST_Gq_pre_dcz = mouseconcatenate(control_SST_Gq_pre_dcz);
    control_SST_Gq_post = mouseconcatenate(control_SST_Gq_post);

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