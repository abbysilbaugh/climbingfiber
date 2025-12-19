function motionpiechart(allData, plot_stimType, plot_preORpost, plot_expType, exclude)

if strcmp(plot_expType, 'whiskerTet')
    mice = [2, 3, 4, 5, 10, 11, 18];
elseif strcmp(plot_expType, 'whiskerOptoTet')
    mice = [13, 14, 15]; % [1, 6, 7, 8, 9]; %mice = [1, 6, 7, 8, 9, 13, 14, 15];
elseif strcmp(plot_expType, 'all')
    mice = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] %, 13, 14, 15, 18];
end

nMice = length(mice);

% Grab data
[NM, vartype] = grabdata(allData, 'all', 'all', plot_stimType, 'NM', plot_preORpost,  'NO DCZ', 'motionInfo', exclude);
NM = NM(mice);
[T, vartype] = grabdata(allData, 'all', 'all', plot_stimType, 'T', plot_preORpost,  'NO DCZ', 'motionInfo', exclude);
T = T(mice);
[M, vartype] = grabdata(allData, 'all', 'all', plot_stimType, 'M', plot_preORpost,  'NO DCZ', 'motionInfo', exclude);
M = M(mice);
[all_types, vartype] = grabdata(allData, 'all', 'all', plot_stimType, 'all', plot_preORpost,  'NO DCZ', 'motionInfo', exclude);
all_types = all_types(mice);


nTrials_permouse_NM = zeros(nMice, 1);
nTrials_permouse_T = zeros(nMice, 1);
nTrials_permouse_M = zeros(nMice, 1);
nTrials_permouse_all_types = zeros(nMice, 1);
nTrials_permouse_other = zeros(nMice, 1);
for i = 1:nMice
    nTrials_permouse_NM(i) = size(NM{i}, 2);
    nTrials_permouse_T(i) = size(T{i}, 2);
    nTrials_permouse_M(i) = size(M{i}, 2);
    nTrials_permouse_all_types(i) = size(all_types{i}, 2);
    nTrials_permouse_other(i) = size(all_types{i}, 2) - size(M{i}, 2) - size(T{i}, 2) - size(NM{i}, 2);
end

nTrials_NM = sum(nTrials_permouse_NM);
nTrials_T = sum(nTrials_permouse_T);
nTrials_M = sum(nTrials_permouse_M);
nTrials_all_types = sum(nTrials_permouse_all_types);
nTrials_other = sum(nTrials_permouse_other);

% Create a vector of the different trial counts
trialCounts = [nTrials_NM, nTrials_T, nTrials_M, nTrials_other];

% Create a cell array with labels for each slice
labels = {
    ['Rest: ' num2str((nTrials_NM/nTrials_all_types)*100, '%.2f%%')], 
    ['Transition: ' num2str((nTrials_T/nTrials_all_types)*100, '%.2f%%')], 
    ['Run: ' num2str((nTrials_M/nTrials_all_types)*100, '%.2f%%')], 
    ['Other: ' num2str((nTrials_other/nTrials_all_types)*100, '%.2f%%')]
};

% Create a pie chart with customized labels
figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];
pie(trialCounts, labels);

hold off

%print('-dtiff', '-r300', savename);


end

