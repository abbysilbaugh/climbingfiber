function [golayshift, c_oasis, spiketimes, b, smin, sn, M, cell_motion_type,...
spont_rate, spont_rate_running, spont_rate_rest, tet_spike_rate, trialtime...
    ] = getOasis(data, cellTypes, trialTypes, tetPeriods, motionCT)
% assumes data = allData{mouse}
% all other parameters assume to be single string

Itt = false(length(data.trialType),1);
if strcmp(trialTypes,'all')
    Itt(:) = true;
elseif iscell(trialTypes)
    for i = 1:length(trialTypes)
        Itt(strcmp(data.trialType,trialTypes(i))) = true;
    end
else
    Itt(strcmp(data.trialType,trialTypes)) = true;
end

Itp = false(length(data.tetPeriod),1);
if strcmp(tetPeriods,'all')
    Itp(:) = true;
elseif iscell(tetPeriods)
    for i = 1:length(tetPeriods)
        Itp(strcmp(data.tetPeriod,tetPeriods(i))) = true;
    end
else
    Itp(strcmp(data.tetPeriod,tetPeriods)) = true;
end

Im = false(length(data.motionCT),1);
if strcmp(motionCT,'all')
    Im(:) = true;
elseif iscell(motionCT)
    for i = 1:length(motionCT)
        Im(strcmp(data.motionCT,motionCT(i))) = true;
    end
else
    Im(strcmp(data.motionCT,motionCT)) = true;
end

Itrials = Itt & Itp & Im;

Icells = false(length(data.cellType),1);
if strcmp(cellTypes,'all')
    Icells(:) = true;
elseif iscell(cellTypes)
    for i = 1:length(cellTypes)
        Icells(strcmp(data.cellType, cellTypes(i))) = true;
    end
else
    Icells(strcmp(data.cellType, cellTypes)) = true;
end

golayshift = data.golayshift(:, Icells, Itrials);
c_oasis = data.c_oasis(:, Icells, Itrials);
spiketimes = data.spiketimes(:, Icells, Itrials);
b = data.b_oasis(Icells, Itrials);
smin = data.smin_oasis(Icells, Itrials);
sn = data.sn_oasis(Icells, Itrials);
M = data.motionInfo(:,Itrials);
cell_motion_type = data.cellmotType(Icells);
spont_rate = data.spont_rate(Icells, Itrials);
spont_rate_running = data.spont_rate_running(Icells, Itrials);
spont_rate_rest = data.spont_rate_rest(Icells, Itrials);
tet_spike_rate = data.tet_mu_fluo(Icells);
trialtime = data.reltime(Itrials);
end