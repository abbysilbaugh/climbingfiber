function getpercentresponsivecells(mottype, allData, signaltype, BT_mice, RWS_mice, RWSCF_mice, RWSCF_PV_JAWS_mice, control_PV_JAWS_mice, RWSCF_PV_Gi_mice, control_PV_Gi_mice, RWSCF_SST_Gi_mice, control_SST_Gi_mice, RWS_SST_Gq_mice, control_SST_Gq_mice, norm)

nMice = size(allData.data, 2);

% Compile basic transmission data
pre = cell(nMice, 5);
pre_wo = cell(nMice, 5);
for i = BT_mice
    [pre{i, 1}, pre_wo{i, 1}, ~, ~] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [pre{i, 2}, pre_wo{i, 2}, ~, ~] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [pre{i, 3}, pre_wo{i, 3}, ~, ~] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [pre{i, 4}, pre_wo{i, 4}, ~, ~] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [pre{i, 5}, pre_wo{i, 5}, ~, ~] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
end

pre = pre(BT_mice, :);
pre_wo = pre_wo(BT_mice, :);

% Compile RWS data
RWS_pre = cell(nMice, 5);
RWS_pre_wo = cell(nMice, 5);
RWS_post = cell(nMice, 5);

for i = RWS_mice
    [RWS_pre{i, 1}, RWS_pre_wo{i, 1}, ~, RWS_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWS_pre{i, 2}, RWS_pre_wo{i, 2}, ~, RWS_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWS_pre{i, 3}, RWS_pre_wo{i, 3}, ~, RWS_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWS_pre{i, 4}, RWS_pre_wo{i, 4}, ~, RWS_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWS_pre{i, 5}, RWS_pre_wo{i, 5}, ~, RWS_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
end

RWS_pre = RWS_pre(RWS_mice, :);
RWS_pre_wo = RWS_pre_wo(RWS_mice, :);
RWS_post = RWS_post(RWS_mice, :);

% Compile RWSCF data
RWSCF_pre = cell(nMice, 5);
RWSCF_pre_wo = cell(nMice, 5);
RWSCF_post = cell(nMice, 5);

for i = RWSCF_mice
    [RWSCF_pre{i, 1}, RWSCF_pre_wo{i, 1}, ~, RWSCF_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_pre{i, 2}, RWSCF_pre_wo{i, 2}, ~, RWSCF_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_pre{i, 3}, RWSCF_pre_wo{i, 3}, ~, RWSCF_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_pre{i, 4}, RWSCF_pre_wo{i, 4}, ~, RWSCF_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_pre{i, 5}, RWSCF_pre_wo{i, 5}, ~, RWSCF_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
end

RWSCF_pre = RWSCF_pre(RWSCF_mice, :);
RWSCF_pre_wo = RWSCF_pre_wo(RWSCF_mice, :);
RWSCF_post = RWSCF_post(RWSCF_mice, :);

% Compile RWSCF_PV_JAWS data
RWSCF_PV_JAWS_pre = cell(nMice, 5);
RWSCF_PV_JAWS_pre_wo = cell(nMice, 5);
RWSCF_PV_JAWS_post = cell(nMice, 5);

for i = RWSCF_PV_JAWS_mice
    [RWSCF_PV_JAWS_pre{i, 1}, RWSCF_PV_JAWS_pre_wo{i, 1}, ~, RWSCF_PV_JAWS_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_PV_JAWS_pre{i, 2}, RWSCF_PV_JAWS_pre_wo{i, 2}, ~, RWSCF_PV_JAWS_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_PV_JAWS_pre{i, 3}, RWSCF_PV_JAWS_pre_wo{i, 3}, ~, RWSCF_PV_JAWS_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_PV_JAWS_pre{i, 4}, RWSCF_PV_JAWS_pre_wo{i, 4}, ~, RWSCF_PV_JAWS_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_PV_JAWS_pre{i, 5}, RWSCF_PV_JAWS_pre_wo{i, 5}, ~, RWSCF_PV_JAWS_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
end

RWSCF_PV_JAWS_pre = RWSCF_PV_JAWS_pre(RWSCF_PV_JAWS_mice, :);
RWSCF_PV_JAWS_pre_wo = RWSCF_PV_JAWS_pre_wo(RWSCF_PV_JAWS_mice, :);
RWSCF_PV_JAWS_post = RWSCF_PV_JAWS_post(RWSCF_PV_JAWS_mice, :);

% Compile control_PV_JAWS data
control_PV_JAWS_pre = cell(nMice, 5);
control_PV_JAWS_pre_wo = cell(nMice, 5);
control_PV_JAWS_post = cell(nMice, 5);

for i = control_PV_JAWS_mice
    [control_PV_JAWS_pre{i, 1}, control_PV_JAWS_pre_wo{i, 1}, ~, control_PV_JAWS_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_PV_JAWS_pre{i, 2}, control_PV_JAWS_pre_wo{i, 2}, ~, control_PV_JAWS_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_PV_JAWS_pre{i, 3}, control_PV_JAWS_pre_wo{i, 3}, ~, control_PV_JAWS_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_PV_JAWS_pre{i, 4}, control_PV_JAWS_pre_wo{i, 4}, ~, control_PV_JAWS_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_PV_JAWS_pre{i, 5}, control_PV_JAWS_pre_wo{i, 5}, ~, control_PV_JAWS_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
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
    [RWSCF_PV_Gi_pre{i, 1}, RWSCF_PV_Gi_pre_wo{i, 1}, RWSCF_PV_Gi_pre_dcz{i, 1}, RWSCF_PV_Gi_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_PV_Gi_pre{i, 2}, RWSCF_PV_Gi_pre_wo{i, 2}, RWSCF_PV_Gi_pre_dcz{i, 2}, RWSCF_PV_Gi_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_PV_Gi_pre{i, 3}, RWSCF_PV_Gi_pre_wo{i, 3}, RWSCF_PV_Gi_pre_dcz{i, 3}, RWSCF_PV_Gi_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_PV_Gi_pre{i, 4}, RWSCF_PV_Gi_pre_wo{i, 4}, RWSCF_PV_Gi_pre_dcz{i, 4}, RWSCF_PV_Gi_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_PV_Gi_pre{i, 5}, RWSCF_PV_Gi_pre_wo{i, 5}, RWSCF_PV_Gi_pre_dcz{i, 5}, RWSCF_PV_Gi_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
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
    [control_PV_Gi_pre{i, 1}, control_PV_Gi_pre_wo{i, 1}, control_PV_Gi_pre_dcz{i, 1}, control_PV_Gi_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_PV_Gi_pre{i, 2}, control_PV_Gi_pre_wo{i, 2}, control_PV_Gi_pre_dcz{i, 2}, control_PV_Gi_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_PV_Gi_pre{i, 3}, control_PV_Gi_pre_wo{i, 3}, control_PV_Gi_pre_dcz{i, 3}, control_PV_Gi_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_PV_Gi_pre{i, 4}, control_PV_Gi_pre_wo{i, 4}, control_PV_Gi_pre_dcz{i, 4}, control_PV_Gi_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_PV_Gi_pre{i, 5}, control_PV_Gi_pre_wo{i, 5}, control_PV_Gi_pre_dcz{i, 5}, control_PV_Gi_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
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
    [RWSCF_SST_Gi_pre{i, 1}, RWSCF_SST_Gi_pre_wo{i, 1}, RWSCF_SST_Gi_pre_dcz{i, 1}, RWSCF_SST_Gi_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_SST_Gi_pre{i, 2}, RWSCF_SST_Gi_pre_wo{i, 2}, RWSCF_SST_Gi_pre_dcz{i, 2}, RWSCF_SST_Gi_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_SST_Gi_pre{i, 3}, RWSCF_SST_Gi_pre_wo{i, 3}, RWSCF_SST_Gi_pre_dcz{i, 3}, RWSCF_SST_Gi_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_SST_Gi_pre{i, 4}, RWSCF_SST_Gi_pre_wo{i, 4}, RWSCF_SST_Gi_pre_dcz{i, 4}, RWSCF_SST_Gi_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWSCF_SST_Gi_pre{i, 5}, RWSCF_SST_Gi_pre_wo{i, 5}, RWSCF_SST_Gi_pre_dcz{i, 5}, RWSCF_SST_Gi_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
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
    [control_SST_Gi_pre{i, 1}, control_SST_Gi_pre_wo{i, 1}, control_SST_Gi_pre_dcz{i, 1}, control_SST_Gi_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_SST_Gi_pre{i, 2}, control_SST_Gi_pre_wo{i, 2}, control_SST_Gi_pre_dcz{i, 2}, control_SST_Gi_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_SST_Gi_pre{i, 3}, control_SST_Gi_pre_wo{i, 3}, control_SST_Gi_pre_dcz{i, 3}, control_SST_Gi_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_SST_Gi_pre{i, 4}, control_SST_Gi_pre_wo{i, 4}, control_SST_Gi_pre_dcz{i, 4}, control_SST_Gi_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_SST_Gi_pre{i, 5}, control_SST_Gi_pre_wo{i, 5}, control_SST_Gi_pre_dcz{i, 5}, control_SST_Gi_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
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
    [RWS_SST_Gq_pre{i, 1}, RWS_SST_Gq_pre_wo{i, 1}, RWS_SST_Gq_pre_dcz{i, 1}, RWS_SST_Gq_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWS_SST_Gq_pre{i, 2}, RWS_SST_Gq_pre_wo{i, 2}, RWS_SST_Gq_pre_dcz{i, 2}, RWS_SST_Gq_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWS_SST_Gq_pre{i, 3}, RWS_SST_Gq_pre_wo{i, 3}, RWS_SST_Gq_pre_dcz{i, 3}, RWS_SST_Gq_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWS_SST_Gq_pre{i, 4}, RWS_SST_Gq_pre_wo{i, 4}, RWS_SST_Gq_pre_dcz{i, 4}, RWS_SST_Gq_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [RWS_SST_Gq_pre{i, 5}, RWS_SST_Gq_pre_wo{i, 5}, RWS_SST_Gq_pre_dcz{i, 5}, RWS_SST_Gq_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
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
    [control_SST_Gq_pre{i, 1}, control_SST_Gq_pre_wo{i, 1}, control_SST_Gq_pre_dcz{i, 1}, control_SST_Gq_post{i, 1}] = parsemouse(mottype, 'PV', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_SST_Gq_pre{i, 2}, control_SST_Gq_pre_wo{i, 2}, control_SST_Gq_pre_dcz{i, 2}, control_SST_Gq_post{i, 2}] = parsemouse(mottype, 'PN', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_SST_Gq_pre{i, 3}, control_SST_Gq_pre_wo{i, 3}, control_SST_Gq_pre_dcz{i, 3}, control_SST_Gq_post{i, 3}] = parsemouse(mottype, 'VIP', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_SST_Gq_pre{i, 4}, control_SST_Gq_pre_wo{i, 4}, control_SST_Gq_pre_dcz{i, 4}, control_SST_Gq_post{i, 4}] = parsemouse(mottype, 'UC', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
    [control_SST_Gq_pre{i, 5}, control_SST_Gq_pre_wo{i, 5}, control_SST_Gq_pre_dcz{i, 5}, control_SST_Gq_post{i, 5}] = parsemouse(mottype, 'SST', allData, i, signaltype, NaN, [300, 305], 0.5, 1);
end

control_SST_Gq_pre = control_SST_Gq_pre(control_SST_Gq_mice, :);
control_SST_Gq_pre_wo = control_SST_Gq_pre_wo(control_SST_Gq_mice, :);
control_SST_Gq_pre_dcz = control_SST_Gq_pre_dcz(control_SST_Gq_mice, :);
control_SST_Gq_post = control_SST_Gq_post(control_SST_Gq_mice, :);

celltypes = {'PV', 'PN', 'VIP', 'UC', 'SST'};

% Get % cells active PER MOUSE
pre1 = getprctactive(pre);
pre_wo1 = getprctactive(pre_wo);

for i = 1:length(celltypes)
    plot2cond(pre1, pre_wo1, celltypes{i}, 'W', 'W+CF', 'BT', norm)
end

RWS_pre1 = getprctactive(RWS_pre);
RWS_pre_wo1 = getprctactive(RWS_pre_wo);
RWS_post1 = getprctactive(RWS_post);

for i = 1:length(celltypes)
    plot2cond(RWS_pre1, RWS_post1, celltypes{i}, 'PRE', 'POST', 'RWS', norm)
end

RWSCF_pre1 = getprctactive(RWSCF_pre);
RWSCF_pre_wo1 = getprctactive(RWSCF_pre_wo);
RWSCF_post1 = getprctactive(RWSCF_post);

for i = 1:length(celltypes)
    plot2cond(RWSCF_pre1, RWSCF_post1, celltypes{i}, 'PRE', 'POST', 'RWSCF', norm)
end

RWSCF_PV_JAWS_pre1 = getprctactive(RWSCF_PV_JAWS_pre);
RWSCF_PV_JAWS_pre_wo1 = getprctactive(RWSCF_PV_JAWS_pre_wo);
RWSCF_PV_JAWS_post1 = getprctactive(RWSCF_PV_JAWS_post);

for i = [1, 2, 4]
    plot2cond(RWSCF_PV_JAWS_pre1, RWSCF_PV_JAWS_post1, celltypes{i}, 'PRE', 'POST', 'RWSCF - PV (JAWS)', norm)
end

control_PV_JAWS_pre1 = getprctactive(control_PV_JAWS_pre);
control_PV_JAWS_pre_wo1 = getprctactive(control_PV_JAWS_pre_wo);
control_PV_JAWS_post1 = getprctactive(control_PV_JAWS_post);

for i = [1, 2, 4]
    plot2cond(control_PV_JAWS_pre1, control_PV_JAWS_post1, celltypes{i}, 'PRE', 'POST', '- PV (JAWS)', norm)
end

RWSCF_PV_Gi_pre1 = getprctactive(RWSCF_PV_Gi_pre);
RWSCF_PV_Gi_pre_wo1 = getprctactive(RWSCF_PV_Gi_pre_wo);
RWSCF_PV_Gi_pre_dcz1 = getprctactive(RWSCF_PV_Gi_pre_dcz);
RWSCF_PV_Gi_post1 = getprctactive(RWSCF_PV_Gi_post);

for i = [1, 2, 4]
    plot2cond(RWSCF_PV_Gi_pre_dcz1, RWSCF_PV_Gi_post1, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWSCF - PV (hM4D(Gi)))', norm)
end

control_PV_Gi_pre1 = getprctactive(control_PV_Gi_pre);
control_PV_Gi_pre_wo1 = getprctactive(control_PV_Gi_pre_wo);
control_PV_Gi_pre_dcz1 = getprctactive(control_PV_Gi_pre_dcz);
control_PV_Gi_post1 = getprctactive(control_PV_Gi_post);

for i = [1, 2, 4]
    plot2cond(control_PV_Gi_pre_dcz1, control_PV_Gi_post1, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '- PV (hM4D(Gi)))', norm)
end

RWSCF_SST_Gi_pre1 = getprctactive(RWSCF_SST_Gi_pre);
RWSCF_SST_Gi_pre_wo1 = getprctactive(RWSCF_SST_Gi_pre_wo);
RWSCF_SST_Gi_pre_dcz1 = getprctactive(RWSCF_SST_Gi_pre_dcz);
RWSCF_SST_Gi_post1 = getprctactive(RWSCF_SST_Gi_post);

for i = [2, 4, 5]
    plot2cond(RWSCF_SST_Gi_pre_dcz1, RWSCF_SST_Gi_post1, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWSCF - SST (hM4D(Gi)))', norm)
end

control_SST_Gi_pre1 = getprctactive(control_SST_Gi_pre);
control_SST_Gi_pre_wo1 = getprctactive(control_SST_Gi_pre_wo);
control_SST_Gi_pre_dcz1 = getprctactive(control_SST_Gi_pre_dcz);
control_SST_Gi_post1 = getprctactive(control_SST_Gi_post);

for i = [2, 4, 5]
    plot2cond(control_SST_Gi_pre_dcz1, control_SST_Gi_post1, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '- SST (hM4D(Gi)))', norm)
end

RWS_SST_Gq_pre1 = getprctactive(RWS_SST_Gq_pre);
RWS_SST_Gq_pre_wo1 = getprctactive(RWS_SST_Gq_pre_wo);
RWS_SST_Gq_pre_dcz1 = getprctactive(RWS_SST_Gq_pre_dcz);
RWS_SST_Gq_post1 = getprctactive(RWS_SST_Gq_post);

for i = [2, 4, 5]
    plot2cond(RWS_SST_Gq_pre_dcz1, RWS_SST_Gq_post1, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWS + SST (hM3D(Gq)))', norm)
end

control_SST_Gq_pre1 = getprctactive(control_SST_Gq_pre);
control_SST_Gq_pre_wo1 = getprctactive(control_SST_Gq_pre_wo);
control_SST_Gq_pre_dcz1 = getprctactive(control_SST_Gq_pre_dcz);
control_SST_Gq_post1 = getprctactive(control_SST_Gq_post);

for i = [2, 4, 5]
    plot2cond(control_SST_Gq_pre_dcz1, control_SST_Gq_post1, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '+ SST (hM3D(Gq)))', norm)
end

% Get cumulative % responsive


pre = mouseconcatenate(pre);
pre_wo = mouseconcatenate(pre_wo);

for i = 1:5
    plotproportion(pre, pre_wo, celltypes{i}, 'W', 'W+CF', 'BT')
end

RWS_pre = mouseconcatenate(RWS_pre);
RWS_pre_wo = mouseconcatenate(RWS_pre_wo);
RWS_post = mouseconcatenate(RWS_post);

for i = 1:5
    plotproportion(RWS_pre, RWS_post, celltypes{i}, 'PRE', 'POST', 'RWS')
end

RWSCF_pre = mouseconcatenate(RWSCF_pre);
RWSCF_pre_wo = mouseconcatenate(RWSCF_pre_wo);
RWSCF_post = mouseconcatenate(RWSCF_post);

for i = 1:5
    plotproportion(RWSCF_pre, RWSCF_post, celltypes{i}, 'PRE', 'POST', 'RWSCF')
end

RWSCF_PV_JAWS_pre = mouseconcatenate(RWSCF_PV_JAWS_pre);
RWSCF_PV_JAWS_pre_wo = mouseconcatenate(RWSCF_PV_JAWS_pre_wo);
RWSCF_PV_JAWS_post = mouseconcatenate(RWSCF_PV_JAWS_post);

for i = [1, 2, 4]
    plotproportion(RWSCF_PV_JAWS_pre, RWSCF_PV_JAWS_post, celltypes{i}, 'PRE', 'POST', 'RWSCF - PV (JAWS)')
end

control_PV_JAWS_pre = mouseconcatenate(control_PV_JAWS_pre);
control_PV_JAWS_pre_wo = mouseconcatenate(control_PV_JAWS_pre_wo);
control_PV_JAWS_post = mouseconcatenate(control_PV_JAWS_post);

for i = [1, 2, 4]
    plotproportion(control_PV_JAWS_pre, control_PV_JAWS_post, celltypes{i}, 'PRE', 'POST (Control)', '- PV (JAWS)')
end

RWSCF_PV_Gi_pre = mouseconcatenate(RWSCF_PV_Gi_pre);
RWSCF_PV_Gi_pre_wo = mouseconcatenate(RWSCF_PV_Gi_pre_wo);
RWSCF_PV_Gi_pre_dcz = mouseconcatenate(RWSCF_PV_Gi_pre_dcz);
RWSCF_PV_Gi_post = mouseconcatenate(RWSCF_PV_Gi_post);

for i = [1, 2, 4]
    plotproportion(RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWSCF - PV (hm4D(Gi))')
end

control_PV_Gi_pre = mouseconcatenate(control_PV_Gi_pre);
control_PV_Gi_pre_wo = mouseconcatenate(control_PV_Gi_pre_wo);
control_PV_Gi_pre_dcz = mouseconcatenate(control_PV_Gi_pre_dcz);
control_PV_Gi_post = mouseconcatenate(control_PV_Gi_post);

for i = [1, 2, 4]
    plotproportion(control_PV_Gi_pre_dcz, control_PV_Gi_post, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '- PV (hm4D(Gi))')
end

RWSCF_SST_Gi_pre = mouseconcatenate(RWSCF_SST_Gi_pre);
RWSCF_SST_Gi_pre_wo = mouseconcatenate(RWSCF_SST_Gi_pre_wo);
RWSCF_SST_Gi_pre_dcz = mouseconcatenate(RWSCF_SST_Gi_pre_dcz);
RWSCF_SST_Gi_post = mouseconcatenate(RWSCF_SST_Gi_post);

for i = [2, 4, 5]
    plotproportion(RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWSCF - SST (hm4D(Gi))')
end

control_SST_Gi_pre = mouseconcatenate(control_SST_Gi_pre);
control_SST_Gi_pre_wo = mouseconcatenate(control_SST_Gi_pre_wo);
control_SST_Gi_pre_dcz = mouseconcatenate(control_SST_Gi_pre_dcz);
control_SST_Gi_post = mouseconcatenate(control_SST_Gi_post);

for i = [2, 4, 5]
    plotproportion(control_SST_Gi_pre_dcz, control_SST_Gi_post, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '- SST (hm4D(Gi))')
end

RWS_SST_Gq_pre = mouseconcatenate(RWS_SST_Gq_pre);
RWS_SST_Gq_pre_wo = mouseconcatenate(RWS_SST_Gq_pre_wo);
RWS_SST_Gq_pre_dcz = mouseconcatenate(RWS_SST_Gq_pre_dcz);
RWS_SST_Gq_post = mouseconcatenate(RWS_SST_Gq_post);

for i = [2, 4, 5]
    plotproportion(RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, celltypes{i}, 'PRE (DCZ)', 'POST', 'RWS + SST (hm3D(Gq))')
end

control_SST_Gq_pre = mouseconcatenate(control_SST_Gq_pre);
control_SST_Gq_pre_wo = mouseconcatenate(control_SST_Gq_pre_wo);
control_SST_Gq_pre_dcz = mouseconcatenate(control_SST_Gq_pre_dcz);
control_SST_Gq_post = mouseconcatenate(control_SST_Gq_post);

for i = [2, 4, 5]
    plotproportion(control_SST_Gq_pre_dcz, control_SST_Gq_post, celltypes{i}, 'PRE (DCZ)', 'POST (Control)', '+ SST (hm3D(Gq))')
end

end

function var = getprctactive(var)
    for i = 1:size(var, 1)
        for j = 1:size(var, 2)
            temp = var{i, j};
            temp = temp(1, :);
            responsive = sum(~isnan(temp))/length(temp);
            var{i, j} = responsive;
        end
    end
    var = cell2mat(var);
end

function plotproportion(cond1, cond2, choosecell, cond1name, cond2name, figtitle)
    colors = {[187/255, 37/255, 37/255], [34/255, 75/255, 170/255], [10/255, 138/255, 35/255],  [0, 0, 0], [99/255, 63/255, 115/255]};
        if strcmp(choosecell, 'PV')
            cell_temp = cond1{1};
            cell_temp2 = cond2{1};
            color = colors{1};
        elseif strcmp(choosecell, 'PN')
            cell_temp = cond1{2};
            cell_temp2 = cond2{2};
            color = colors{2};
        elseif strcmp(choosecell, 'VIP')
            cell_temp = cond1{3};
            cell_temp2 = cond2{3};
            color = colors{3};
        elseif strcmp(choosecell, 'UC')
            cell_temp = cond1{4};
            cell_temp2 = cond2{4};
            color = colors{4};
        elseif strcmp(choosecell, 'SST')
            cell_temp = cond1{5};
            cell_temp2 = cond2{5};
            color = colors{5};
        end

        temp = size(cell_temp);
        if temp(1) == 0
            warning('Expt has no Ns')
        else
            nneurons = size(cell_temp, 2);
        
            cell_temp = (sum(~isnan(cell_temp(1, :))))/size(cell_temp, 2);
            cell_temp2 = (sum(~isnan(cell_temp2(1, :))))/size(cell_temp2, 2);
        
            figure('Position', [680,558,323,420]);
            h = bar([1, 2], [cell_temp, cell_temp2], 'FaceColor', color, 'EdgeColor', 'none');
            ylim([0 1.2])
            yticks([0.25 0.5 0.75 1])
            yticklabels({'25', '50', '75', '100'})
            xlim([0.5, 2.5])
            set(gca, 'FontSize', 15)
            xticks([1, 2])
            xticklabels({cond1name, cond2name})
            ylabel('% Responsive Cells')
            title(figtitle)
        
            % Add text above each bar
            x = h.XData; % Get the x positions of the bars
            y = h.YData; % Get the heights of the bars
            for i = 1:length(y)
                text(x(i), y(i) + 0.05, sprintf('%.0f%%', y(i) * 100), 'HorizontalAlignment', 'center', 'FontSize', 12)
            end
            text(1.5, 1.15, ['nCells = ', num2str(nneurons')], 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Color', color);
         end
end

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
    
    
            cell_temp = cell_temp(~isnan(cell_temp));
            cell_temp2 = cell_temp2(~isnan(cell_temp2));
            % Get rid of mice with no responsive cells in either cond.
            t = cell_temp == 0;
            t2 = cell_temp2 == 0;
            temp = t + t2;
            temp = temp < 2;
            cell_temp = cell_temp(temp);
            cell_temp2 = cell_temp2(temp);
    
            num_mice = length(cell_temp);
    
            figure('Position', [680,558,323,420]);
            if choosenorm
                for n = 1:size(cell_temp, 1)
                    g = plot([1, 2], [cell_temp(n)/cell_temp(n), cell_temp2(n)/cell_temp(n)], 'Color', color, 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor', color);
                    hold on
                end
                ylim([0, 2])
                xlim([0.5, 2.5])
                set(gca, 'FontSize', 15)
                xticks([1, 2])
                xticklabels({cond1name, cond2name})
                ylabel('% Responsive Cells')
                title(figtitle)
        
                %[h,p,ci,stats] = ttest(cell_temp, cell_temp2);
                %text(1.5, 1.9, ['p = ', num2str(p, '%.3f')], 'HorizontalAlignment', 'center', 'FontSize', 12);
                text(1.5, 1.9, ['nMice = ', num2str(num_mice')], 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Color', color);
            else
                for n = 1:size(cell_temp, 1)
                    g = plot([1, 2], [cell_temp(n), cell_temp2(n)], 'Color', color, 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor', color);
                    hold on
                end
                ylim([0, 1.2])
                xlim([0.5, 2.5])
                set(gca, 'FontSize', 15)
                xticks([1, 2])
                xticklabels({cond1name, cond2name})
                ylabel('% Responsive Cells')
                title(figtitle)
        
                [h,p,ci,stats] = ttest(cell_temp, cell_temp2);
                text(1.5, 1.1, ['p = ', num2str(p, '%.3f')], 'HorizontalAlignment', 'center', 'FontSize', 12);
                text(1.5, 1.15, ['nMice = ', num2str(num_mice')], 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Color', color);
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