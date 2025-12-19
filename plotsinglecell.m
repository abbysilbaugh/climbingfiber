function plotsinglecell(allData, set_mouse, set_cell, plot_trialtype, plot_tettype, x_limit, y_limit, savename)

traces = squeeze(allData.data{set_mouse}.golaysignal(:, set_cell, :));

trials = allData.data{set_mouse}.trialType;
tetperiod = allData.data{set_mouse}.tetPeriod;

cellType = allData.data{set_mouse}.cellType(set_cell);

if strcmp(cellType, 'PV')
    traceColor = [187, 37, 37]/255; % Red
elseif strcmp(cellType, 'PN')
    traceColor = [37, 112, 187]/255; % Blue
elseif strcmp(cellType, 'VIP')
    traceColor = [37 187 112]/255; % Green
elseif strcmp(cellType, 'UC')
    traceColor = [37 187 112]/255; % Green
end

figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];




for i = 1:length(trials)
    if strcmp(trials(i), plot_trialtype) && strcmp(tetperiod(i), plot_tettype)
        trace = traces(:, i);
        norm = mean(trace(297:307));
        if norm > 0
            trace = trace - norm;
        elseif norm < 0
            trace = trace + norm;
        end

        if mean(trace(304:309)) < -.05
            continue
        else
        plot(trace, 'Color', traceColor)
        end
        hold on
    end
end

ylabel('ΔF/F0', 'FontSize', 25);
xlabel('Time relative to stim. onset (s)')
xticks([304 - 30.98, 304, 304 + 30.98, 304 + 30.98 + 30.98, 304+ 3*30.98])
xticklabels([-1 0 1 2 3])

set(gca,'FontSize', 15, 'FontWeight', 'normal'); 

xlim(x_limit)
ylim(y_limit)

box off

print('-dtiff', '-r300', savename);
end

