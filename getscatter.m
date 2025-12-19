function getscatter(xvar, yvar, get_title, get_xlabel, get_ylabel, cellType, savename, xlimits, ylimits)

if strcmp(cellType, 'PV')
    Color = [187, 37, 37]/255; % Red
elseif strcmp(cellType, 'PN')
    Color = [37, 112, 187]/255; % Blue
elseif strcmp(cellType, 'VIP')
    Color = [37 187 112]/255; % Green
elseif strcmp(cellType, 'UC')
    Color = [0 0 0]/255; % Green 
end

% figure;
scatter(xvar, yvar, 70, 'filled', 'MarkerEdgeColor', 'none', 'MarkerFaceColor', Color, 'MarkerFaceAlpha', 0.3)

% Fit the linear model to all data
mdl = fitlm(xvar, yvar);

if isempty(xvar)
    warning('Data does not exist for condition')
else

    % Create array for x values for regression line
    xVals = linspace(min(xvar), max(yvar), 100);
    
    % Calculate y values for regression line
    yVals = mdl.Coefficients.Estimate(1) + mdl.Coefficients.Estimate(2)*xVals;
    
    hold on

end

%plot(xVals, yVals, 'k', 'LineWidth', 2, 'Color', Color); % k for black color

title(get_title)
xlabel(get_xlabel)
ylabel(get_ylabel)

xlim(xlimits)
ylim(ylimits)

print('-dtiff', '-r300', savename);
plot([0 1], [0 1])

hold on


end