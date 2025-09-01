       
function [pre, pre_wo, ...
    RWS_pre, RWS_pre_wo, RWS_post, ...
    RWSCF_pre, RWSCF_pre_wo, RWSCF_post, ...
    RWSCF_PV_JAWS_pre, RWSCF_PV_JAWS_pre_wo, RWSCF_PV_JAWS_post, ...
    control_PV_JAWS_pre, control_PV_JAWS_pre_wo, control_PV_JAWS_post, ...
    RWSCF_PV_Gi_pre, RWSCF_PV_Gi_pre_wo, RWSCF_PV_Gi_pre_dcz, RWSCF_PV_Gi_post, ...
    control_PV_Gi_pre, control_PV_Gi_pre_wo, control_PV_Gi_pre_dcz, control_PV_Gi_post, ...
    RWS_PV_Gq_pre, RWS_PV_Gq_pre_wo, RWS_PV_Gq_pre_dcz, RWS_PV_Gq_post, ...
    control_PV_Gq_pre, control_PV_Gq_pre_wo, control_PV_Gq_pre_dcz, control_PV_Gq_post, ...
    RWSCF_SST_Gi_pre, RWSCF_SST_Gi_pre_wo, RWSCF_SST_Gi_pre_dcz, RWSCF_SST_Gi_post, ...
    control_SST_Gi_pre, control_SST_Gi_pre_wo, control_SST_Gi_pre_dcz, control_SST_Gi_post, ...
    RWS_SST_Gq_pre, RWS_SST_Gq_pre_wo, RWS_SST_Gq_pre_dcz, RWS_SST_Gq_post, ...
    control_SST_Gq_pre, control_SST_Gq_pre_wo, control_SST_Gq_pre_dcz, control_SST_Gq_post,...
    RWSCF_VIP_Gq_pre, RWSCF_VIP_Gq_pre_wo, RWSCF_VIP_Gq_pre_dcz, RWSCF_VIP_Gq_post, ...
    control_VIP_Gq_pre, control_VIP_Gq_pre_wo, control_VIP_Gq_pre_dcz, control_VIP_Gq_post, ... 
    RWS_VIP_Gi_pre, RWS_VIP_Gi_pre_wo, RWS_VIP_Gi_pre_dcz, RWS_VIP_Gi_post, ...
    control_VIP_Gi_pre, control_VIP_Gi_pre_wo, control_VIP_Gi_pre_dcz, control_VIP_Gi_post, ...
    SST_Gi_ZI_pre, SST_Gi_ZI_pre_wo, SST_Gi_ZI_pre_dcz, SST_Gi_ZI_pre_dcz_wo, ...
    PV_Gi_ZI_pre, PV_Gi_ZI_pre_wo, PV_Gi_ZI_pre_dcz, PV_Gi_ZI_pre_dcz_wo]...
    = parsemottraces(trialavg, catmouse, mottype, allData, setmice, choosemottype)

nMice = size(allData.data, 2);

% Compile basic transmission data
pre = cell(nMice, 1);
pre_wo = cell(nMice, 1);
for i = setmice.BT_mice
    [pre{i, 1}, pre_wo{i, 1}, ~, ~] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

pre = pre(setmice.BT_mice, :);
pre_wo = pre_wo(setmice.BT_mice, :);

% Compile RWS data
RWS_pre = cell(nMice, 1);
RWS_pre_wo = cell(nMice, 1);
RWS_post = cell(nMice, 1);

for i = setmice.RWS_mice
    [RWS_pre{i, 1}, RWS_pre_wo{i, 1}, ~, RWS_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

RWS_pre = RWS_pre(setmice.RWS_mice, :);
RWS_pre_wo = RWS_pre_wo(setmice.RWS_mice, :);
RWS_post = RWS_post(setmice.RWS_mice, :);

% Compile RWSCF data
RWSCF_pre = cell(nMice, 1);
RWSCF_pre_wo = cell(nMice, 1);
RWSCF_post = cell(nMice, 1);

for i = setmice.RWSCF_mice
    [RWSCF_pre{i, 1}, RWSCF_pre_wo{i, 1}, ~, RWSCF_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

RWSCF_pre = RWSCF_pre(setmice.RWSCF_mice, :);
RWSCF_pre_wo = RWSCF_pre_wo(setmice.RWSCF_mice, :);
RWSCF_post = RWSCF_post(setmice.RWSCF_mice, :);

% Compile RWSCF_PV_JAWS data
RWSCF_PV_JAWS_pre = cell(nMice, 1);
RWSCF_PV_JAWS_pre_wo = cell(nMice, 1);
RWSCF_PV_JAWS_post = cell(nMice, 1);

for i = setmice.RWSCF_PV_JAWS_mice
    [RWSCF_PV_JAWS_pre{i, 1}, RWSCF_PV_JAWS_pre_wo{i, 1}, ~, RWSCF_PV_JAWS_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

RWSCF_PV_JAWS_pre = RWSCF_PV_JAWS_pre(setmice.RWSCF_PV_JAWS_mice, :);
RWSCF_PV_JAWS_pre_wo = RWSCF_PV_JAWS_pre_wo(setmice.RWSCF_PV_JAWS_mice, :);
RWSCF_PV_JAWS_post = RWSCF_PV_JAWS_post(setmice.RWSCF_PV_JAWS_mice, :);

% Compile control_PV_JAWS data
control_PV_JAWS_pre = cell(nMice, 1);
control_PV_JAWS_pre_wo = cell(nMice, 1);
control_PV_JAWS_post = cell(nMice, 1);

for i = setmice.control_PV_JAWS_mice
    [control_PV_JAWS_pre{i, 1}, control_PV_JAWS_pre_wo{i, 1}, ~, control_PV_JAWS_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

control_PV_JAWS_pre = control_PV_JAWS_pre(setmice.control_PV_JAWS_mice, :);
control_PV_JAWS_pre_wo = control_PV_JAWS_pre_wo(setmice.control_PV_JAWS_mice, :);
control_PV_JAWS_post = control_PV_JAWS_post(setmice.control_PV_JAWS_mice, :);

% Compile RWSCF_PV_Gi data
RWSCF_PV_Gi_pre = cell(nMice, 1);
RWSCF_PV_Gi_pre_wo = cell(nMice, 1);
RWSCF_PV_Gi_pre_dcz = cell(nMice, 1);
RWSCF_PV_Gi_post = cell(nMice, 1);

for i = setmice.RWSCF_PV_Gi_mice
    [RWSCF_PV_Gi_pre{i, 1}, RWSCF_PV_Gi_pre_wo{i, 1}, RWSCF_PV_Gi_pre_dcz{i, 1}, RWSCF_PV_Gi_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

RWSCF_PV_Gi_pre = RWSCF_PV_Gi_pre(setmice.RWSCF_PV_Gi_mice, :);
RWSCF_PV_Gi_pre_wo = RWSCF_PV_Gi_pre_wo(setmice.RWSCF_PV_Gi_mice, :);
RWSCF_PV_Gi_pre_dcz = RWSCF_PV_Gi_pre_dcz(setmice.RWSCF_PV_Gi_mice, :);
RWSCF_PV_Gi_post = RWSCF_PV_Gi_post(setmice.RWSCF_PV_Gi_mice, :);

% Compile control_PV_Gi data
control_PV_Gi_pre = cell(nMice, 1);
control_PV_Gi_pre_wo = cell(nMice, 1);
control_PV_Gi_pre_dcz = cell(nMice, 1);
control_PV_Gi_post = cell(nMice, 1);

for i = setmice.control_PV_Gi_mice
    [control_PV_Gi_pre{i, 1}, control_PV_Gi_pre_wo{i, 1}, control_PV_Gi_pre_dcz{i, 1}, control_PV_Gi_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

control_PV_Gi_pre = control_PV_Gi_pre(setmice.control_PV_Gi_mice, :);
control_PV_Gi_pre_wo = control_PV_Gi_pre_wo(setmice.control_PV_Gi_mice, :);
control_PV_Gi_pre_dcz = control_PV_Gi_pre_dcz(setmice.control_PV_Gi_mice, :);
control_PV_Gi_post = control_PV_Gi_post(setmice.control_PV_Gi_mice, :);

% Compile RWS_PV_Gq data
RWS_PV_Gq_pre = cell(nMice, 1);
RWS_PV_Gq_pre_wo = cell(nMice, 1);
RWS_PV_Gq_pre_dcz = cell(nMice, 1);
RWS_PV_Gq_post = cell(nMice, 1);

for i = setmice.RWS_PV_Gq_mice
    [RWS_PV_Gq_pre{i, 1}, RWS_PV_Gq_pre_wo{i, 1}, RWS_PV_Gq_pre_dcz{i, 1}, RWS_PV_Gq_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

RWS_PV_Gq_pre = RWS_PV_Gq_pre(setmice.RWS_PV_Gq_mice, :);
RWS_PV_Gq_pre_wo = RWS_PV_Gq_pre_wo(setmice.RWS_PV_Gq_mice, :);
RWS_PV_Gq_pre_dcz = RWS_PV_Gq_pre_dcz(setmice.RWS_PV_Gq_mice, :);
RWS_PV_Gq_post = RWS_PV_Gq_post(setmice.RWS_PV_Gq_mice, :);

% Compile control_PV_Gq data
control_PV_Gq_pre = cell(nMice, 1);
control_PV_Gq_pre_wo = cell(nMice, 1);
control_PV_Gq_pre_dcz = cell(nMice, 1);
control_PV_Gq_post = cell(nMice, 1);

for i = setmice.control_PV_Gq_mice
    [control_PV_Gq_pre{i, 1}, control_PV_Gq_pre_wo{i, 1}, control_PV_Gq_pre_dcz{i, 1}, control_PV_Gq_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

control_PV_Gq_pre = control_PV_Gq_pre(setmice.control_PV_Gq_mice, :);
control_PV_Gq_pre_wo = control_PV_Gq_pre_wo(setmice.control_PV_Gq_mice, :);
control_PV_Gq_pre_dcz = control_PV_Gq_pre_dcz(setmice.control_PV_Gq_mice, :);
control_PV_Gq_post = control_PV_Gq_post(setmice.control_PV_Gq_mice, :);

% Compile RWSCF_SST_Gi data
RWSCF_SST_Gi_pre = cell(nMice, 1);
RWSCF_SST_Gi_pre_wo = cell(nMice, 1);
RWSCF_SST_Gi_pre_dcz = cell(nMice, 1);
RWSCF_SST_Gi_post = cell(nMice, 1);

for i = setmice.RWSCF_SST_Gi_mice
    [RWSCF_SST_Gi_pre{i, 1}, RWSCF_SST_Gi_pre_wo{i, 1}, RWSCF_SST_Gi_pre_dcz{i, 1}, RWSCF_SST_Gi_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

RWSCF_SST_Gi_pre = RWSCF_SST_Gi_pre(setmice.RWSCF_SST_Gi_mice, :);
RWSCF_SST_Gi_pre_wo = RWSCF_SST_Gi_pre_wo(setmice.RWSCF_SST_Gi_mice, :);
RWSCF_SST_Gi_pre_dcz = RWSCF_SST_Gi_pre_dcz(setmice.RWSCF_SST_Gi_mice, :);
RWSCF_SST_Gi_post = RWSCF_SST_Gi_post(setmice.RWSCF_SST_Gi_mice, :);

% Compile control_SST_Gi data
control_SST_Gi_pre = cell(nMice, 1);
control_SST_Gi_pre_wo = cell(nMice, 1);
control_SST_Gi_pre_dcz = cell(nMice, 1);
control_SST_Gi_post = cell(nMice, 1);

for i = setmice.control_SST_Gi_mice
    [control_SST_Gi_pre{i, 1}, control_SST_Gi_pre_wo{i, 1}, control_SST_Gi_pre_dcz{i, 1}, control_SST_Gi_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

control_SST_Gi_pre = control_SST_Gi_pre(setmice.control_SST_Gi_mice, :);
control_SST_Gi_pre_wo = control_SST_Gi_pre_wo(setmice.control_SST_Gi_mice, :);
control_SST_Gi_pre_dcz = control_SST_Gi_pre_dcz(setmice.control_SST_Gi_mice, :);
control_SST_Gi_post = control_SST_Gi_post(setmice.control_SST_Gi_mice, :);

% Compile RWS_SST_Gq data
RWS_SST_Gq_pre = cell(nMice, 1);
RWS_SST_Gq_pre_wo = cell(nMice, 1);
RWS_SST_Gq_pre_dcz = cell(nMice, 1);
RWS_SST_Gq_post = cell(nMice, 1);

for i = setmice.RWS_SST_Gq_mice
    [RWS_SST_Gq_pre{i, 1}, RWS_SST_Gq_pre_wo{i, 1}, RWS_SST_Gq_pre_dcz{i, 1}, RWS_SST_Gq_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

RWS_SST_Gq_pre = RWS_SST_Gq_pre(setmice.RWS_SST_Gq_mice, :);
RWS_SST_Gq_pre_wo = RWS_SST_Gq_pre_wo(setmice.RWS_SST_Gq_mice, :);
RWS_SST_Gq_pre_dcz = RWS_SST_Gq_pre_dcz(setmice.RWS_SST_Gq_mice, :);
RWS_SST_Gq_post = RWS_SST_Gq_post(setmice.RWS_SST_Gq_mice, :);


% Compile control_SST_Gq data
control_SST_Gq_pre = cell(nMice, 1);
control_SST_Gq_pre_wo = cell(nMice, 1);
control_SST_Gq_pre_dcz = cell(nMice, 1);
control_SST_Gq_post = cell(nMice, 1);

for i = setmice.control_SST_Gq_mice
    [control_SST_Gq_pre{i, 1}, control_SST_Gq_pre_wo{i, 1}, control_SST_Gq_pre_dcz{i, 1}, control_SST_Gq_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

control_SST_Gq_pre = control_SST_Gq_pre(setmice.control_SST_Gq_mice, :);
control_SST_Gq_pre_wo = control_SST_Gq_pre_wo(setmice.control_SST_Gq_mice, :);
control_SST_Gq_pre_dcz = control_SST_Gq_pre_dcz(setmice.control_SST_Gq_mice, :);
control_SST_Gq_post = control_SST_Gq_post(setmice.control_SST_Gq_mice, :);

% Compile RWSCF_VIP_Gq data
RWSCF_VIP_Gq_pre = cell(nMice, 1);
RWSCF_VIP_Gq_pre_wo = cell(nMice, 1);
RWSCF_VIP_Gq_pre_dcz = cell(nMice, 1);
RWSCF_VIP_Gq_post = cell(nMice, 1);

for i = setmice.RWSCF_VIP_Gq_mice
    [RWSCF_VIP_Gq_pre{i, 1}, RWSCF_VIP_Gq_pre_wo{i, 1}, RWSCF_VIP_Gq_pre_dcz{i, 1}, RWSCF_VIP_Gq_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

RWSCF_VIP_Gq_pre = RWSCF_VIP_Gq_pre(setmice.RWSCF_VIP_Gq_mice, :);
RWSCF_VIP_Gq_pre_wo = RWSCF_VIP_Gq_pre_wo(setmice.RWSCF_VIP_Gq_mice, :);
RWSCF_VIP_Gq_pre_dcz = RWSCF_VIP_Gq_pre_dcz(setmice.RWSCF_VIP_Gq_mice, :);
RWSCF_VIP_Gq_post = RWSCF_VIP_Gq_post(setmice.RWSCF_VIP_Gq_mice, :);

% Compile control_VIP_Gq data
control_VIP_Gq_pre = cell(nMice, 1);
control_VIP_Gq_pre_wo = cell(nMice, 1);
control_VIP_Gq_pre_dcz = cell(nMice, 1);
control_VIP_Gq_post = cell(nMice, 1);

for i = setmice.control_VIP_Gq_mice
    [control_VIP_Gq_pre{i, 1}, control_VIP_Gq_pre_wo{i, 1}, control_VIP_Gq_pre_dcz{i, 1}, control_VIP_Gq_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

control_VIP_Gq_pre = control_VIP_Gq_pre(setmice.control_VIP_Gq_mice, :);
control_VIP_Gq_pre_wo = control_VIP_Gq_pre_wo(setmice.control_VIP_Gq_mice, :);
control_VIP_Gq_pre_dcz = control_VIP_Gq_pre_dcz(setmice.control_VIP_Gq_mice, :);
control_VIP_Gq_post = control_VIP_Gq_post(setmice.control_VIP_Gq_mice, :);

% Compile RWS_VIP_Gi data
RWS_VIP_Gi_pre = cell(nMice, 1);
RWS_VIP_Gi_pre_wo = cell(nMice, 1);
RWS_VIP_Gi_pre_dcz = cell(nMice, 1);
RWS_VIP_Gi_post = cell(nMice, 1);

for i = setmice.RWS_VIP_Gi_mice
    [RWS_VIP_Gi_pre{i, 1}, RWS_VIP_Gi_pre_wo{i, 1}, RWS_VIP_Gi_pre_dcz{i, 1}, RWS_VIP_Gi_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

RWS_VIP_Gi_pre = RWS_VIP_Gi_pre(setmice.RWS_VIP_Gi_mice, :);
RWS_VIP_Gi_pre_wo = RWS_VIP_Gi_pre_wo(setmice.RWS_VIP_Gi_mice, :);
RWS_VIP_Gi_pre_dcz = RWS_VIP_Gi_pre_dcz(setmice.RWS_VIP_Gi_mice, :);
RWS_VIP_Gi_post = RWS_VIP_Gi_post(setmice.RWS_VIP_Gi_mice, :);


% Compile control_VIP_Gi data
control_VIP_Gi_pre = cell(nMice, 1);
control_VIP_Gi_pre_wo = cell(nMice, 1);
control_VIP_Gi_pre_dcz = cell(nMice, 1);
control_VIP_Gi_post = cell(nMice, 1);

for i = setmice.control_VIP_Gi_mice
    [control_VIP_Gi_pre{i, 1}, control_VIP_Gi_pre_wo{i, 1}, control_VIP_Gi_pre_dcz{i, 1}, control_VIP_Gi_post{i, 1}] = parsemotmouse(mottype, allData, i,trialavg, choosemottype);
end

control_VIP_Gi_pre = control_VIP_Gi_pre(setmice.control_VIP_Gi_mice, :);
control_VIP_Gi_pre_wo = control_VIP_Gi_pre_wo(setmice.control_VIP_Gi_mice, :);
control_VIP_Gi_pre_dcz = control_VIP_Gi_pre_dcz(setmice.control_VIP_Gi_mice, :);
control_VIP_Gi_post = control_VIP_Gi_post(setmice.control_VIP_Gi_mice, :);

% Compile SST_Gi_ZI data
SST_Gi_ZI_pre = cell(nMice, 1);
SST_Gi_ZI_pre_wo = cell(nMice, 1);
SST_Gi_ZI_pre_dcz = cell(nMice, 1);
SST_Gi_ZI_pre_dcz_wo = cell(nMice, 1);

for i = setmice.SST_Gi_ZI_mice
    [SST_Gi_ZI_pre{i, 1}, SST_Gi_ZI_pre_wo{i, 1}, SST_Gi_ZI_pre_dcz{i, 1}, SST_Gi_ZI_pre_dcz_wo{i, 1}] = parsemotmouse_ZI(mottype, allData, i,trialavg, choosemottype);
end

SST_Gi_ZI_pre = SST_Gi_ZI_pre(setmice.SST_Gi_ZI_mice, :);
SST_Gi_ZI_pre_wo = SST_Gi_ZI_pre_wo(setmice.SST_Gi_ZI_mice, :);
SST_Gi_ZI_pre_dcz = SST_Gi_ZI_pre_dcz(setmice.SST_Gi_ZI_mice, :);
SST_Gi_ZI_pre_dcz_wo = SST_Gi_ZI_pre_dcz_wo(setmice.SST_Gi_ZI_mice, :);

% Compile PV_Gi_ZI data
PV_Gi_ZI_pre = cell(nMice, 1);
PV_Gi_ZI_pre_wo = cell(nMice, 1);
PV_Gi_ZI_pre_dcz = cell(nMice, 1);
PV_Gi_ZI_pre_dcz_wo = cell(nMice, 1);

for i = setmice.PV_Gi_ZI_mice
    [PV_Gi_ZI_pre{i, 1}, PV_Gi_ZI_pre_wo{i, 1}, PV_Gi_ZI_pre_dcz{i, 1}, PV_Gi_ZI_pre_dcz_wo{i, 1}] = parsemotmouse_ZI(mottype, allData, i,trialavg, choosemottype);
end

PV_Gi_ZI_pre = PV_Gi_ZI_pre(setmice.PV_Gi_ZI_mice, :);
PV_Gi_ZI_pre_wo = PV_Gi_ZI_pre_wo(setmice.PV_Gi_ZI_mice, :);
PV_Gi_ZI_pre_dcz = PV_Gi_ZI_pre_dcz(setmice.PV_Gi_ZI_mice, :);
PV_Gi_ZI_pre_dcz_wo = PV_Gi_ZI_pre_dcz_wo(setmice.PV_Gi_ZI_mice, :);

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

    RWS_PV_Gq_pre = mouseconcatenate(RWS_PV_Gq_pre);
    RWS_PV_Gq_pre_wo = mouseconcatenate(RWS_PV_Gq_pre_wo);
    RWS_PV_Gq_pre_dcz = mouseconcatenate(RWS_PV_Gq_pre_dcz);
    RWS_PV_Gq_post = mouseconcatenate(RWS_PV_Gq_post);

    control_PV_Gq_pre = mouseconcatenate(control_PV_Gq_pre);
    control_PV_Gq_pre_wo = mouseconcatenate(control_PV_Gq_pre_wo);
    control_PV_Gq_pre_dcz = mouseconcatenate(control_PV_Gq_pre_dcz);
    control_PV_Gq_post = mouseconcatenate(control_PV_Gq_post);

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

    RWSCF_VIP_Gq_pre = mouseconcatenate(RWSCF_VIP_Gq_pre);
    RWSCF_VIP_Gq_pre_wo = mouseconcatenate(RWSCF_VIP_Gq_pre_wo);
    RWSCF_VIP_Gq_pre_dcz = mouseconcatenate(RWSCF_VIP_Gq_pre_dcz);
    RWSCF_VIP_Gq_post = mouseconcatenate(RWSCF_VIP_Gq_post);

    control_VIP_Gq_pre = mouseconcatenate(control_VIP_Gq_pre);
    control_VIP_Gq_pre_wo = mouseconcatenate(control_VIP_Gq_pre_wo);
    control_VIP_Gq_pre_dcz = mouseconcatenate(control_VIP_Gq_pre_dcz);
    control_VIP_Gq_post = mouseconcatenate(control_VIP_Gq_post);

    RWS_VIP_Gi_pre = mouseconcatenate(RWS_VIP_Gi_pre);
    RWS_VIP_Gi_pre_wo = mouseconcatenate(RWS_VIP_Gi_pre_wo);
    RWS_VIP_Gi_pre_dcz = mouseconcatenate(RWS_VIP_Gi_pre_dcz);
    RWS_VIP_Gi_post = mouseconcatenate(RWS_VIP_Gi_post);

    control_VIP_Gi_pre = mouseconcatenate(control_VIP_Gi_pre);
    control_VIP_Gi_pre_wo = mouseconcatenate(control_VIP_Gi_pre_wo);
    control_VIP_Gi_pre_dcz = mouseconcatenate(control_VIP_Gi_pre_dcz);
    control_VIP_Gi_post = mouseconcatenate(control_VIP_Gi_post);

    SST_Gi_ZI_pre = mouseconcatenate(SST_Gi_ZI_pre);
    SST_Gi_ZI_pre_wo = mouseconcatenate(SST_Gi_ZI_pre_wo);
    SST_Gi_ZI_pre_dcz = mouseconcatenate(SST_Gi_ZI_pre_dcz);
    SST_Gi_ZI_pre_dcz_wo = mouseconcatenate(SST_Gi_ZI_pre_dcz_wo);

    PV_Gi_ZI_pre = mouseconcatenate(PV_Gi_ZI_pre);
    PV_Gi_ZI_pre_wo = mouseconcatenate(PV_Gi_ZI_pre_wo);
    PV_Gi_ZI_pre_dcz = mouseconcatenate(PV_Gi_ZI_pre_dcz);
    PV_Gi_ZI_pre_dcz_wo = mouseconcatenate(PV_Gi_ZI_pre_dcz_wo);

end

end


function variable = mouseconcatenate(variable)
catvar = [];
    for y = 1:size(variable, 1)
        temp = variable{y, 1};

        catvar = cat(2, catvar, temp);
    end

    variable = {catvar};

end