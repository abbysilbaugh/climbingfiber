function [pre, RWS, RWSCF,...
    RWSCF_PV_JAWS,control_PV_JAWS,RWSCF_PV_Gi,control_PV_Gi,RWS_PV_Gq,control_PV_Gq,...
    RWSCF_SST_Gi,control_SST_Gi,RWS_SST_Gq,control_SST_Gq,...
    RWSCF_VIP_Gq,control_VIP_Gq,RWS_VIP_Gi,control_VIP_Gi,...
    SST_Gi_ZI,PV_Gi_ZI]...
    = parseneurons(allData, parameter, setmice, catmice)

nMice = size(allData.data, 2);

parse_all_cells = cell(nMice, 5);
for i = 1:nMice
    cellType = allData.data{i}.cellType;
    if strcmp(parameter, 'max')
        temp = allData.data{i}.roi_sizes_max;
    elseif strcmp(parameter, 'avg')
        temp = allData.data{i}.roi_sizes_avg;
    end

    PVs = strcmp(cellType, 'PV');
    PNs = strcmp(cellType, 'PN');
    UCs = strcmp(cellType, 'UC');
    VIPs = strcmp(cellType, 'VIP');
    SSTs = strcmp(cellType, 'SST');
    
    parse_all_cells{i, 1} = temp(PVs);
    parse_all_cells{i, 2} = temp(PNs);
    parse_all_cells{i, 3} = temp(VIPs);
    parse_all_cells{i, 4} = temp(UCs);
    parse_all_cells{i, 5} = temp(SSTs);
end

pre = parse_all_cells(setmice.BT_mice, :);
RWS = parse_all_cells(setmice.RWS_mice, :);
RWSCF = parse_all_cells(setmice.RWSCF_mice, :);
RWSCF_PV_JAWS = parse_all_cells(setmice.RWSCF_PV_JAWS_mice, :);
control_PV_JAWS = parse_all_cells(setmice.control_PV_JAWS_mice, :);
RWSCF_PV_Gi = parse_all_cells(setmice.RWSCF_PV_Gi_mice, :);
control_PV_Gi = parse_all_cells(setmice.control_PV_Gi_mice, :);
RWS_PV_Gq = parse_all_cells(setmice.RWS_PV_Gq_mice, :);
control_PV_Gq = parse_all_cells(setmice.control_PV_Gq_mice, :);
RWSCF_SST_Gi = parse_all_cells(setmice.RWSCF_SST_Gi_mice, :);
control_SST_Gi = parse_all_cells(setmice.control_SST_Gi_mice, :);
RWS_SST_Gq = parse_all_cells(setmice.RWS_SST_Gq_mice, :);
control_SST_Gq = parse_all_cells(setmice.control_SST_Gq_mice, :);
RWSCF_VIP_Gq = parse_all_cells(setmice.RWSCF_VIP_Gq_mice, :);
control_VIP_Gq = parse_all_cells(setmice.control_VIP_Gq_mice, :);
RWS_VIP_Gi = parse_all_cells(setmice.RWS_VIP_Gi_mice, :);
control_VIP_Gi = parse_all_cells(setmice.control_VIP_Gi_mice, :);
SST_Gi_ZI = parse_all_cells(setmice.SST_Gi_ZI_mice, :);
PV_Gi_ZI = parse_all_cells(setmice.PV_Gi_ZI_mice, :);

if catmice
    pre = mouseconcatenate(pre);
    RWS = mouseconcatenate(RWS);
    RWSCF = mouseconcatenate(RWSCF);
    RWSCF_PV_JAWS = mouseconcatenate(RWSCF_PV_JAWS);
    control_PV_JAWS = mouseconcatenate(control_PV_JAWS);
    RWSCF_PV_Gi  = mouseconcatenate(RWSCF_PV_Gi);
    control_PV_Gi = mouseconcatenate(control_PV_Gi);
    RWS_PV_Gq = mouseconcatenate(RWS_PV_Gq);
    control_PV_Gq = mouseconcatenate(control_PV_Gq);
    RWSCF_SST_Gi = mouseconcatenate(RWSCF_SST_Gi);
    control_SST_Gi = mouseconcatenate(control_SST_Gi);
    RWS_SST_Gq = mouseconcatenate(RWS_SST_Gq);
    control_SST_Gq = mouseconcatenate(control_SST_Gq);
    RWSCF_VIP_Gq = mouseconcatenate(RWSCF_VIP_Gq);
    control_VIP_Gq = mouseconcatenate(control_VIP_Gq);
    RWS_VIP_Gi  = mouseconcatenate(RWS_VIP_Gi);
    control_VIP_Gi = mouseconcatenate(control_VIP_Gi);
    SST_Gi_ZI  = mouseconcatenate(SST_Gi_ZI);
    PV_Gi_ZI  = mouseconcatenate(PV_Gi_ZI);
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

        PV = cat(1, PV, PV_temp);
        PN = cat(1, PN, PN_temp);
        VIP = cat(1, VIP, VIP_temp);
        UC = cat(1, UC, UC_temp);
        SST = cat(1, SST, SST_temp);
    end

    variable = {PV, PN, VIP, UC, SST};

end