init_fig;

m = find(s_oasis);

% c
axes('position', [0.080666666666667,0.57,0.882,0.37]);
hold on;
plot(y, 'color', col{8}/255);
alpha(.7);
%plot(true_c, 'color', col{3}/255, 'linewidth', 1.5);
plot(c_oasis, '-.', 'color', col{1}/255);
axis tight;
xlim([0, 620]);
set(gca, 'xtick', [0, 20]*31);
set(gca, 'xticklabel', []);
%set(gca, 'ytick', 0:2);
ylabel('Fluor.');
box off;
legend('Data', 'OASIS', 'location', 'northeast', 'orientation', 'horizontal');
% s
axes('position', [0.080666666666667,0.18,0.882,0.37]);
hold on;
%plot(true_s, 'color', col{3}/255, 'linewidth', 1.5);
plot(s_oasis, '-.', 'color', col{1}/255);

for i = 1:length(m)
    xline(m(i), 'LineWidth', 1, 'Color', 'k')
end

axis tight;
xlim([0, 620]);
set(gca, 'xtick', [0, 20]*31);
set(gca, 'xticklabel', get(gca, 'xtick')/31);
set(gca, 'ytick', [0,1]);
xlabel('Time [s]');
ylabel('Activity.');