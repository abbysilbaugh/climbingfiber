function runterminaldensity

    % Add path for data files
    addpath('Terminal density measurements');

    % Read CSV files into tables
    rostral = readtable('Results_D5.csv');
    middle = readtable('Results_D6.csv');
    caudal = readtable('Results_C1.csv');

    % Truncate ends (omit ROI overlay)
    rostral = rostral(2:end-1, :);
    middle = middle(2:end-1, :);
    caudal = caudal(2:end-1, :);

    % Extract intensity density and standard deviation
    r = rostral.IntDen;
    m = middle.IntDen;
    c = caudal.IntDen;

    r_std = rostral.StdDev;
    m_std = middle.StdDev;
    c_std = caudal.StdDev;

    % Normalize IntDen
    r_min = min(r); r_max = max(r);
    m_min = min(m); m_max = max(m);
    c_min = min(c); c_max = max(c);

    r = (r - r_min) / (r_max - r_min);
    m = (m - m_min) / (m_max - m_min);
    c = (c - c_min) / (c_max - c_min);

    % Normalize StdDev (relative to IntDen scale)
    r_std = r_std / (r_max - r_min);
    m_std = m_std / (m_max - m_min);
    c_std = c_std / (c_max - c_min);

    % Flip y-axis variable for plotting
    y_r = rostral.microns;
    y_m = middle.microns;
    y_c = caudal.microns;

    figure; hold on;

%     % Plot shaded regions (Mean ± StdDev)
%     fill([r + r_std; flip(r - r_std)], [y_r; flip(y_r)], 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
%     fill([m + m_std; flip(m - m_std)], [y_m; flip(y_m)], 'g', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
%     fill([c + c_std; flip(c - c_std)], [y_c; flip(y_c)], 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

    % Plot main curves
    plot(r, y_r, 'Color', [6, 150, 104]/255, 'LineWidth', 2);
    plot(m, y_m, 'Color', [20, 66, 66]/255, 'LineWidth', 2);
    plot(c, y_c, 'Color', [93, 153, 170]/255, 'LineWidth', 2);

    % Add reference line at y = 3
    yline(200, 'k--', 'LineWidth', 1.5);

    % Labels and formatting
    xlabel('Density', 'FontSize', 12);
    ylabel('Depth (μm)', 'FontSize', 12);
    %legend({'Rostral ± StdDev', 'Middle ± StdDev', 'Caudal ± StdDev', 'Rostral', 'Middle', 'Caudal'}, 'Location', 'best');
    set(gca, 'YDir', 'reverse'); % Flip Y-axis to match expected orientation
    xticks([0 1])
    yticks([200 400])
    ax = gca;
    ax.XAxisLocation = 'top';
    ax.FontSize = 14;

end
