function getscatter_prepost(RWS_pre, RWS_post, RWSCF_pre, RWSCF_post, gettitle, cellType, savename)

darkeningFactor = .7;

if strcmp(cellType, 'PV')
    Color = [187, 37, 37]/255;
    Color2 = Color * darkeningFactor; % Darker Red
elseif strcmp(cellType, 'PN')
    Color = [37, 112, 187]/255;
    Color2 = Color * darkeningFactor; % Darker Blue
elseif strcmp(cellType, 'VIP')
    Color = [37, 187, 112]/255;
    Color2 = Color * darkeningFactor; % Darker Green
elseif strcmp(cellType, 'UC')
    Color = [37, 187, 112]/255;
    Color2 = Color * darkeningFactor; % Darker Green
end

% Create Pre figure
figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];

scatter(RWS_pre, RWS_post, 30, 'Marker', 'o', 'MarkerEdgeColor', Color, 'MarkerFaceColor', 'none')
hold on
scatter(RWSCF_pre, RWSCF_post, 30, 'filled', 'MarkerEdgeColor', Color, 'MarkerFaceColor', Color, 'MarkerFaceAlpha', 1)


% Fit the linear model to all data
mdl = fitlm(RWS_pre, RWS_post);
md2 = fitlm(RWSCF_pre, RWSCF_post);

if ~isempty(RWS_pre) && ~isempty(RWSCF_pre)
    % Create array for x values for regression line
    xVals = linspace(min(RWS_pre), max(RWS_pre), 100);
    xVals2 = linspace(min(RWSCF_pre), max(RWSCF_pre), 100);
    
    % Calculate y values for regression line
    yVals = mdl.Coefficients.Estimate(1) + mdl.Coefficients.Estimate(2)*xVals;
    yVals2 = md2.Coefficients.Estimate(1) + md2.Coefficients.Estimate(2)*xVals2;
    
    plot(xVals, yVals, 'k', 'LineWidth', 2, 'Color', Color2, 'LineStyle', '-.'); % k for black color
    plot(xVals2, yVals2, 'k', 'LineWidth', 2, 'Color', Color2); % k for black color
    
    set(gca,'FontSize', 20, 'FontWeight', 'normal'); 
    xlabel('ρ (PRE)', 'FontSize', 25);
    ylabel('ρ (POST)', 'FontSize', 25);
    title(gettitle, 'FontSize', 28, 'FontWeight', 'normal');
    xlim([0 5])
    ylim([0 5])
    
    xlabelHandle = xlabel('ρ (PRE)');
    currentPosition = get(xlabelHandle, 'Position');
    set(xlabelHandle, 'Position', [currentPosition(1), currentPosition(2) + 0.05, currentPosition(3)]);
    plot([0 10], [0 10], 'Color', 'k');
    
    ax = gca;
    ticks = ax.XTick;
    ticklabels = ax.XTickLabel;
    
    % Create new text labels manually positioned closer to the x-axis
    for i = 1:length(ticks)
        text(ticks(i), ax.YLim(1) + (0.015 * range(ax.YLim)), ticklabels(i,:), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'top', ...
            'Clipping', 'on', 'FontSize', 20);
    end
    
    % Remove the original x-tick labels
    ax.XTickLabel = [];
    
    
    
    print('-dtiff', '-r300', savename);
end


end