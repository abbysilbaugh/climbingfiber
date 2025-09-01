signal = allData.data{21}.evokedtraces;

cells = allData.data{21}.cellType;

PVs = strcmp(cells, 'PV');

PNs = strcmp(cells, 'PN');

UCs = strcmp(cells, 'UC');

trialtype = allData.data{21}.trialType;

w = strcmp(trialtype, 'W');
wo = strcmp(trialtype, 'WO');
o = strcmp(trialtype, 'O');

PVs_w = signal(:, PVs, w);
PVs_wo = signal(:, PVs, wo);
PVs_o = signal(:, PVs, o);

for i = 1:15
figure;
plot(squeeze(PVs_w(:, i, :)), 'Color', 'k')
hold on
plot(squeeze(PVs_wo(:, i, :)), 'Color', 'r')
end

