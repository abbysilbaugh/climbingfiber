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
       
function [RWSCF_PV_Gi_pre_comb, RWSCF_PV_Gi_post, ...
    control_PV_Gi_pre_comb, control_PV_Gi_post, ...
    RWS_PV_Gq_pre_comb, RWS_PV_Gq_post, ...
    control_PV_Gq_pre_comb, control_PV_Gq_post, ...
    RWSCF_SST_Gi_pre_comb, RWSCF_SST_Gi_post, ...
    control_SST_Gi_pre_comb, control_SST_Gi_post, ...
    RWS_SST_Gq_pre_comb, RWS_SST_Gq_post, ...
    control_SST_Gq_pre_comb, control_SST_Gq_post,...
    RWSCF_VIP_Gq_pre_comb, RWSCF_VIP_Gq_post, ...
    control_VIP_Gq_pre_comb, control_VIP_Gq_post, ... 
    RWS_VIP_Gi_pre_comb, RWS_VIP_Gi_post, ...
    control_VIP_Gi_pre_comb, control_VIP_Gi_post]...
    = parsetraces3(baselineshiftperiod, baselineshift, baseline_reject_thresh, trialavg, cellavg, catmouse, mottype, allData, signaltype, setmice)

nMice = size(allData.data, 2);

% Compile RWSCF_PV_Gi data
RWSCF_PV_Gi_pre_comb = cell(nMice, 5);
RWSCF_PV_Gi_post = cell(nMice, 5);

for i = setmice.RWSCF_PV_Gi_mice
    [RWSCF_PV_Gi_pre_comb{i, 1}, RWSCF_PV_Gi_post{i, 1}] = parsemouse3(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_Gi_pre_comb{i, 2}, RWSCF_PV_Gi_post{i, 2}] = parsemouse3(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_Gi_pre_comb{i, 3}, RWSCF_PV_Gi_post{i, 3}] = parsemouse3(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_Gi_pre_comb{i, 4}, RWSCF_PV_Gi_post{i, 4}] = parsemouse3(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_PV_Gi_pre_comb{i, 5}, RWSCF_PV_Gi_post{i, 5}] = parsemouse3(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWSCF_PV_Gi_pre_comb = RWSCF_PV_Gi_pre_comb(setmice.RWSCF_PV_Gi_mice, :);
RWSCF_PV_Gi_post = RWSCF_PV_Gi_post(setmice.RWSCF_PV_Gi_mice, :);

% Compile control_PV_Gi data
control_PV_Gi_pre_comb = cell(nMice, 5);
control_PV_Gi_post = cell(nMice, 5);

for i = setmice.control_PV_Gi_mice
    [control_PV_Gi_pre_comb{i, 1}, control_PV_Gi_post{i, 1}] = parsemouse3(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gi_pre_comb{i, 2}, control_PV_Gi_post{i, 2}] = parsemouse3(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gi_pre_comb{i, 3}, control_PV_Gi_post{i, 3}] = parsemouse3(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gi_pre_comb{i, 4}, control_PV_Gi_post{i, 4}] = parsemouse3(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gi_pre_comb{i, 5}, control_PV_Gi_post{i, 5}] = parsemouse3(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_PV_Gi_pre_comb = control_PV_Gi_pre_comb(setmice.control_PV_Gi_mice, :);
control_PV_Gi_post = control_PV_Gi_post(setmice.control_PV_Gi_mice, :);

% Compile RWS_PV_Gq data
RWS_PV_Gq_pre_comb = cell(nMice, 5);
RWS_PV_Gq_post = cell(nMice, 5);

for i = setmice.RWS_PV_Gq_mice
    [RWS_PV_Gq_pre_comb{i, 1}, RWS_PV_Gq_post{i, 1}] = parsemouse3(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_PV_Gq_pre_comb{i, 2}, RWS_PV_Gq_post{i, 2}] = parsemouse3(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_PV_Gq_pre_comb{i, 3}, RWS_PV_Gq_post{i, 3}] = parsemouse3(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_PV_Gq_pre_comb{i, 4}, RWS_PV_Gq_post{i, 4}] = parsemouse3(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_PV_Gq_pre_comb{i, 5}, RWS_PV_Gq_post{i, 5}] = parsemouse3(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWS_PV_Gq_pre_comb = RWS_PV_Gq_pre_comb(setmice.RWS_PV_Gq_mice, :);
RWS_PV_Gq_post = RWS_PV_Gq_post(setmice.RWS_PV_Gq_mice, :);

% Compile control_PV_Gq data
control_PV_Gq_pre_comb = cell(nMice, 5);
control_PV_Gq_post = cell(nMice, 5);

for i = setmice.control_PV_Gq_mice
    [control_PV_Gq_pre_comb{i, 1}, control_PV_Gq_post{i, 1}] = parsemouse3(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gq_pre_comb{i, 2}, control_PV_Gq_post{i, 2}] = parsemouse3(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gq_pre_comb{i, 3}, control_PV_Gq_post{i, 3}] = parsemouse3(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gq_pre_comb{i, 4}, control_PV_Gq_post{i, 4}] = parsemouse3(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_PV_Gq_pre_comb{i, 5}, control_PV_Gq_post{i, 5}] = parsemouse3(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_PV_Gq_pre_comb = control_PV_Gq_pre_comb(setmice.control_PV_Gq_mice, :);
control_PV_Gq_post = control_PV_Gq_post(setmice.control_PV_Gq_mice, :);

% Compile RWSCF_SST_Gi data
RWSCF_SST_Gi_pre_comb = cell(nMice, 5);
RWSCF_SST_Gi_post = cell(nMice, 5);

for i = setmice.RWSCF_SST_Gi_mice
    [RWSCF_SST_Gi_pre_comb{i, 1}, RWSCF_SST_Gi_post{i, 1}] = parsemouse3(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_SST_Gi_pre_comb{i, 2}, RWSCF_SST_Gi_post{i, 2}] = parsemouse3(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_SST_Gi_pre_comb{i, 3}, RWSCF_SST_Gi_post{i, 3}] = parsemouse3(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_SST_Gi_pre_comb{i, 4}, RWSCF_SST_Gi_post{i, 4}] = parsemouse3(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_SST_Gi_pre_comb{i, 5}, RWSCF_SST_Gi_post{i, 5}] = parsemouse3(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWSCF_SST_Gi_pre_comb = RWSCF_SST_Gi_pre_comb(setmice.RWSCF_SST_Gi_mice, :);
RWSCF_SST_Gi_post = RWSCF_SST_Gi_post(setmice.RWSCF_SST_Gi_mice, :);

% Compile control_SST_Gi data
control_SST_Gi_pre_comb = cell(nMice, 5);
control_SST_Gi_post = cell(nMice, 5);

for i = setmice.control_SST_Gi_mice
    [control_SST_Gi_pre_comb{i, 1}, control_SST_Gi_post{i, 1}] = parsemouse3(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gi_pre_comb{i, 2}, control_SST_Gi_post{i, 2}] = parsemouse3(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gi_pre_comb{i, 3}, control_SST_Gi_post{i, 3}] = parsemouse3(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gi_pre_comb{i, 4}, control_SST_Gi_post{i, 4}] = parsemouse3(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gi_pre_comb{i, 5}, control_SST_Gi_post{i, 5}] = parsemouse3(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_SST_Gi_pre_comb = control_SST_Gi_pre_comb(setmice.control_SST_Gi_mice, :);
control_SST_Gi_post = control_SST_Gi_post(setmice.control_SST_Gi_mice, :);

% Compile RWS_SST_Gq data
RWS_SST_Gq_pre_comb = cell(nMice, 5);
RWS_SST_Gq_post = cell(nMice, 5);

for i = setmice.RWS_SST_Gq_mice
    [RWS_SST_Gq_pre_comb{i, 1}, RWS_SST_Gq_post{i, 1}] = parsemouse3(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_SST_Gq_pre_comb{i, 2}, RWS_SST_Gq_post{i, 2}] = parsemouse3(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_SST_Gq_pre_comb{i, 3}, RWS_SST_Gq_post{i, 3}] = parsemouse3(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_SST_Gq_pre_comb{i, 4}, RWS_SST_Gq_post{i, 4}] = parsemouse3(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_SST_Gq_pre_comb{i, 5}, RWS_SST_Gq_post{i, 5}] = parsemouse3(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWS_SST_Gq_pre_comb = RWS_SST_Gq_pre_comb(setmice.RWS_SST_Gq_mice, :);
RWS_SST_Gq_post = RWS_SST_Gq_post(setmice.RWS_SST_Gq_mice, :);


% Compile control_SST_Gq data
control_SST_Gq_pre_comb = cell(nMice, 5);
control_SST_Gq_post = cell(nMice, 5);

for i = setmice.control_SST_Gq_mice
    [control_SST_Gq_pre_comb{i, 1}, control_SST_Gq_post{i, 1}] = parsemouse3(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gq_pre_comb{i, 2}, control_SST_Gq_post{i, 2}] = parsemouse3(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gq_pre_comb{i, 3}, control_SST_Gq_post{i, 3}] = parsemouse3(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gq_pre_comb{i, 4}, control_SST_Gq_post{i, 4}] = parsemouse3(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_SST_Gq_pre_comb{i, 5}, control_SST_Gq_post{i, 5}] = parsemouse3(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_SST_Gq_pre_comb = control_SST_Gq_pre_comb(setmice.control_SST_Gq_mice, :);
control_SST_Gq_post = control_SST_Gq_post(setmice.control_SST_Gq_mice, :);

% Compile RWSCF_VIP_Gq data
RWSCF_VIP_Gq_pre_comb = cell(nMice, 5);
RWSCF_VIP_Gq_post = cell(nMice, 5);

for i = setmice.RWSCF_VIP_Gq_mice
    [RWSCF_VIP_Gq_pre_comb{i, 1}, RWSCF_VIP_Gq_post{i, 1}] = parsemouse3(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_VIP_Gq_pre_comb{i, 2}, RWSCF_VIP_Gq_post{i, 2}] = parsemouse3(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_VIP_Gq_pre_comb{i, 3}, RWSCF_VIP_Gq_post{i, 3}] = parsemouse3(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_VIP_Gq_pre_comb{i, 4}, RWSCF_VIP_Gq_post{i, 4}] = parsemouse3(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWSCF_VIP_Gq_pre_comb{i, 5}, RWSCF_VIP_Gq_post{i, 5}] = parsemouse3(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWSCF_VIP_Gq_pre_comb = RWSCF_VIP_Gq_pre_comb(setmice.RWSCF_VIP_Gq_mice, :);
RWSCF_VIP_Gq_post = RWSCF_VIP_Gq_post(setmice.RWSCF_VIP_Gq_mice, :);

% Compile control_VIP_Gq data
control_VIP_Gq_pre_comb = cell(nMice, 5);
control_VIP_Gq_post = cell(nMice, 5);

for i = setmice.control_VIP_Gq_mice
    [control_VIP_Gq_pre_comb{i, 1}, control_VIP_Gq_post{i, 1}] = parsemouse3(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gq_pre_comb{i, 2}, control_VIP_Gq_post{i, 2}] = parsemouse3(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gq_pre_comb{i, 3}, control_VIP_Gq_post{i, 3}] = parsemouse3(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gq_pre_comb{i, 4}, control_VIP_Gq_post{i, 4}] = parsemouse3(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gq_pre_comb{i, 5}, control_VIP_Gq_post{i, 5}] = parsemouse3(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_VIP_Gq_pre_comb = control_VIP_Gq_pre_comb(setmice.control_VIP_Gq_mice, :);
control_VIP_Gq_post = control_VIP_Gq_post(setmice.control_VIP_Gq_mice, :);

% Compile RWS_VIP_Gi data
RWS_VIP_Gi_pre_comb = cell(nMice, 5);
RWS_VIP_Gi_post = cell(nMice, 5);

for i = setmice.RWS_VIP_Gi_mice
    [RWS_VIP_Gi_pre_comb{i, 1}, RWS_VIP_Gi_post{i, 1}] = parsemouse3(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_VIP_Gi_pre_comb{i, 2}, RWS_VIP_Gi_post{i, 2}] = parsemouse3(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_VIP_Gi_pre_comb{i, 3}, RWS_VIP_Gi_post{i, 3}] = parsemouse3(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_VIP_Gi_pre_comb{i, 4}, RWS_VIP_Gi_post{i, 4}] = parsemouse3(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [RWS_VIP_Gi_pre_comb{i, 5}, RWS_VIP_Gi_post{i, 5}] = parsemouse3(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

RWS_VIP_Gi_pre_comb = RWS_VIP_Gi_pre_comb(setmice.RWS_VIP_Gi_mice, :);
RWS_VIP_Gi_post = RWS_VIP_Gi_post(setmice.RWS_VIP_Gi_mice, :);


% Compile control_VIP_Gi data
control_VIP_Gi_pre_comb = cell(nMice, 5);
control_VIP_Gi_post = cell(nMice, 5);

for i = setmice.control_VIP_Gi_mice
    [control_VIP_Gi_pre_comb{i, 1}, control_VIP_Gi_post{i, 1}] = parsemouse3(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gi_pre_comb{i, 2}, control_VIP_Gi_post{i, 2}] = parsemouse3(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gi_pre_comb{i, 3}, control_VIP_Gi_post{i, 3}] = parsemouse3(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gi_pre_comb{i, 4}, control_VIP_Gi_post{i, 4}] = parsemouse3(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [control_VIP_Gi_pre_comb{i, 5}, control_VIP_Gi_post{i, 5}] = parsemouse3(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

control_VIP_Gi_pre_comb = control_VIP_Gi_pre_comb(setmice.control_VIP_Gi_mice, :);
control_VIP_Gi_post = control_VIP_Gi_post(setmice.control_VIP_Gi_mice, :);


if cellavg
    RWSCF_PV_Gi_pre_comb = cellaverage(RWSCF_PV_Gi_pre_comb);
    RWSCF_PV_Gi_post = cellaverage(RWSCF_PV_Gi_post);

    control_PV_Gi_pre_comb = cellaverage(control_PV_Gi_pre_comb);
    control_PV_Gi_post = cellaverage(control_PV_Gi_post);

    RWS_PV_Gq_pre_comb = cellaverage(RWS_PV_Gq_pre_comb);
    RWS_PV_Gq_post = cellaverage(RWS_PV_Gq_post);

    control_PV_Gq_pre_comb = cellaverage(control_PV_Gq_pre_comb);
    control_PV_Gq_post = cellaverage(control_PV_Gq_post);

    RWSCF_SST_Gi_pre_comb = cellaverage(RWSCF_SST_Gi_pre_comb);
    RWSCF_SST_Gi_post = cellaverage(RWSCF_SST_Gi_post);

    control_SST_Gi_pre_comb = cellaverage(control_SST_Gi_pre_comb);
    control_SST_Gi_post = cellaverage(control_SST_Gi_post);

    RWS_SST_Gq_pre_comb = cellaverage(RWS_SST_Gq_pre_comb);
    RWS_SST_Gq_post = cellaverage(RWS_SST_Gq_post);

    control_SST_Gq_pre_comb = cellaverage(control_SST_Gq_pre_comb);
    control_SST_Gq_post = cellaverage(control_SST_Gq_post);

    RWSCF_VIP_Gq_pre_comb = cellaverage(RWSCF_VIP_Gq_pre_comb);
    RWSCF_VIP_Gq_post = cellaverage(RWSCF_VIP_Gq_post);

    control_VIP_Gq_pre_comb = cellaverage(control_VIP_Gq_pre_comb);
    control_VIP_Gq_post = cellaverage(control_VIP_Gq_post);

    RWS_VIP_Gi_pre_comb = cellaverage(RWS_VIP_Gi_pre_comb);
    RWS_VIP_Gi_post = cellaverage(RWS_VIP_Gi_post);

    control_VIP_Gi_pre_comb = cellaverage(control_VIP_Gi_pre_comb);
    control_VIP_Gi_post = cellaverage(control_VIP_Gi_post);
end

if catmouse
    RWSCF_PV_Gi_pre_comb = mouseconcatenate(RWSCF_PV_Gi_pre_comb);
    RWSCF_PV_Gi_post = mouseconcatenate(RWSCF_PV_Gi_post);

    control_PV_Gi_pre_comb = mouseconcatenate(control_PV_Gi_pre_comb);
    control_PV_Gi_post = mouseconcatenate(control_PV_Gi_post);

    RWS_PV_Gq_pre_comb = mouseconcatenate(RWS_PV_Gq_pre_comb);
    RWS_PV_Gq_post = mouseconcatenate(RWS_PV_Gq_post);

    control_PV_Gq_pre_comb = mouseconcatenate(control_PV_Gq_pre_comb);
    control_PV_Gq_post = mouseconcatenate(control_PV_Gq_post);

    RWSCF_SST_Gi_pre_comb = mouseconcatenate(RWSCF_SST_Gi_pre_comb);
    RWSCF_SST_Gi_post = mouseconcatenate(RWSCF_SST_Gi_post);

    control_SST_Gi_pre_comb = mouseconcatenate(control_SST_Gi_pre_comb);
    control_SST_Gi_post = mouseconcatenate(control_SST_Gi_post);

    RWS_SST_Gq_pre_comb = mouseconcatenate(RWS_SST_Gq_pre_comb);
    RWS_SST_Gq_post = mouseconcatenate(RWS_SST_Gq_post);

    control_SST_Gq_pre_comb = mouseconcatenate(control_SST_Gq_pre_comb);
    control_SST_Gq_post = mouseconcatenate(control_SST_Gq_post);

    RWSCF_VIP_Gq_pre_comb = mouseconcatenate(RWSCF_VIP_Gq_pre_comb);
    RWSCF_VIP_Gq_post = mouseconcatenate(RWSCF_VIP_Gq_post);

    control_VIP_Gq_pre_comb = mouseconcatenate(control_VIP_Gq_pre_comb);
    control_VIP_Gq_post = mouseconcatenate(control_VIP_Gq_post);

    RWS_VIP_Gi_pre_comb = mouseconcatenate(RWS_VIP_Gi_pre_comb);
    RWS_VIP_Gi_post = mouseconcatenate(RWS_VIP_Gi_post);

    control_VIP_Gi_pre_comb = mouseconcatenate(control_VIP_Gi_pre_comb);
    control_VIP_Gi_post = mouseconcatenate(control_VIP_Gi_post);
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