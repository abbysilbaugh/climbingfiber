init_fig;

trace_colors = {'#ea9595', '#7b9be5', '#949494'}; % [PV, PC, UC]
oasis_colors = {'#bb2525', '#224baa', 'k'}; % [PV, PC, UC]

m = find(s_oasis);
% trialType{1} = trialType;
% tetType{1} = tetType;
% cellType{1} = cellType;

% c
axes('position', [0.05,.75,0.882,0.2]);
hold on;

if strcmp(cellType, 'PV')
    plot(BC_trace, 'color', trace_colors{1});
elseif strcmp(cellType, 'PC')
    plot(BC_trace, 'color', trace_colors{2});
elseif strcmp(cellType, 'UC')
    plot(BC_trace, 'color', trace_colors{3});
end
alpha(.7);
%plot(true_c, 'color', col{3}/255, 'linewidth', 1.5);

if strcmp(cellType, 'PV')
    plot(c_oasis, 'color', oasis_colors{1}, 'LineStyle', '-');
elseif strcmp(cellType, 'PC')
    plot(c_oasis, 'color', oasis_colors{2}, 'LineStyle', '-');
elseif strcmp(cellType, 'UC')
    plot(c_oasis, 'color', oasis_colors{3}, 'LineStyle', '-');
end

axis tight;

if strcmp(trialType, 'W') & strcmp(tetType, 'PRE')
    xline(310, 'LineWidth', 2, 'Color', 'k')
elseif strcmp(trialType, 'O') & strcmp(tetType, 'PRE')
    xline(310, 'LineWidth', 2, 'Color', '#4DBEEE')
elseif strcmp(trialType, 'WO') & strcmp(tetType, 'PRE')
    xline(310, 'LineWidth', 2, 'Color', '#0072BD')
elseif strcmp(trialType, 'W') & strcmp(tetType, 'POST')
    xline(310, 'LineWidth', 2, 'Color', 'k', 'LineStyle', '-')
end

xlim([0, 620]);
set(gca, 'xtick', [0, 20]*31);
set(gca, 'xticklabel', []);
%set(gca, 'ytick', 0:2);
ylabel('Fluor.');
box off;
legend('Data', 'OASIS', 'location', 'northeast', 'orientation', 'horizontal');
% s

axes('position', [0.05,0.45,0.882,0.2]);
hold on;
%plot(true_s, 'color', col{3}/255, 'linewidth', 1.5);

if strcmp(cellType, 'PV')
    plot(s_oasis, 'color', oasis_colors{1}, 'LineStyle', '-');
elseif strcmp(cellType, 'PC')
    plot(s_oasis, 'color', oasis_colors{2}, 'LineStyle', '-');
elseif strcmp(cellType, 'UC')
    plot(s_oasis, 'color', oasis_colors{3}, 'LineStyle', '-');
end


for spike = 1:length(m)
    xline(m(spike), 'LineWidth', 1, 'Color', 'k')
end

if strcmp(trialType, 'W') & strcmp(tetType, 'PRE')
    xline(310, 'LineWidth', 2, 'Color', 'k')
elseif strcmp(trialType, 'O') & strcmp(tetType, 'PRE')
    xline(310, 'LineWidth', 2, 'Color', '#4DBEEE')
elseif strcmp(trialType, 'WO') & strcmp(tetType, 'PRE')
    xline(310, 'LineWidth', 2, 'Color', '#0072BD')
elseif strcmp(trialType, 'W') & strcmp(tetType, 'POST')
    xline(310, 'LineWidth', 2, 'Color', 'k', 'LineStyle', '-')
end

axis tight;
xlim([0, 620]);
set(gca, 'xtick', [0, 20]*31);
set(gca, 'xticklabel', []);
set(gca, 'ytick', [0,1]);
%xlabel('Time [s]');
ylabel('Activity.');


axes('position', [0.05,0.15,0.882,0.2]);
hold on;
% plot(true_s, 'color', col{3}/255, 'linewidth', 1.5);
find_motion = find(motion);

for mot_spike = 1:length(find_motion)
    xline(find_motion(mot_spike), 'LineWidth', 1, 'Color', 'k')
end

if strcmp(trialType, 'W') & strcmp(tetType, 'PRE')
    xline(310, 'LineWidth', 2, 'Color', 'k')
elseif strcmp(trialType, 'O') & strcmp(tetType, 'PRE')
    xline(310, 'LineWidth', 2, 'Color', '#4DBEEE')
elseif strcmp(trialType, 'WO') & strcmp(tetType, 'PRE')
    xline(310, 'LineWidth', 2, 'Color', '#0072BD')
elseif strcmp(trialType, 'W') & strcmp(tetType, 'POST')
    xline(310, 'LineWidth', 2, 'Color', 'k', 'LineStyle', '-')
end

axis tight;
xlim([0, 620]);
set(gca, 'xtick', [0, 20]*31);
set(gca, 'xticklabel', get(gca, 'xtick')/31);
%set(gca, 'ytick', [0,1]);
xlabel('Time [s]');
ylabel('Motion');
