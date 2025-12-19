function prebar(allData, cellType, cellmotType, trialmotType, variable, exclude, trialaverage, gettitle, savename, ylimit)


% Choose color
if strcmp(cellType, 'PV')
    Color = [187, 37, 37]/255; % Red
elseif strcmp(cellType, 'PN')
    Color = [37, 112, 187]/255; % Blue
elseif strcmp(cellType, 'VIP')
    Color = [37 187 112]/255; % Green
elseif strcmp(cellType, 'UC')
    Color = [37 187 112]/255; % Green
end

% Grab W data
[preW, pre_vartype] = grabdata(allData, cellType, cellmotType, 'W', trialmotType, 'PRE', variable, exclude);
if trialaverage
    [preW, ~, pre_vartype] = trialavg(preW, pre_vartype);
else
    [preW, pre_vartype] = trialpool(preW, pre_vartype);
end
[pre_catW, varcattype] = catmice(allData, preW, pre_vartype, 'all');

% Grab WO data
[preWO, pre_vartype] = grabdata(allData, cellType, cellmotType, 'WO', trialmotType, 'PRE', variable, exclude);
if trialaverage
    [preWO, ~, pre_vartype] = trialavg(preWO, pre_vartype);
else
    [preWO, pre_vartype] = trialpool(preWO, pre_vartype);
end
[pre_catWO, varcattype] = catmice(allData, preWO, pre_vartype, 'all');

% Grab O data
[preO, pre_vartype] = grabdata(allData, cellType, cellmotType, 'O', trialmotType, 'PRE', variable, exclude);
if trialaverage
    [preO, ~, pre_vartype] = trialavg(preO, pre_vartype);
else
    [preO, pre_vartype] = trialpool(preO, pre_vartype);
end
[pre_catO, varcattype] = catmice(allData, preO, pre_vartype, 'all');

mean_preW = mean(pre_catW(~isnan(pre_catW)));
mean_preWO = mean(pre_catWO(~isnan(pre_catWO)));
mean_preO = mean(pre_catO(~isnan(pre_catO)));

bar_data = [mean_preW, mean_preWO, mean_preO];

sem_preW = std(pre_catW(~isnan(pre_catW))) / sqrt(sum(~isnan(pre_catW)));
sem_preWO = std(pre_catWO(~isnan(pre_catWO))) / sqrt(sum(~isnan(pre_catWO)));
sem_preO = std(pre_catO(~isnan(pre_catO))) / sqrt(sum(~isnan(pre_catO)));

bar_sem = [sem_preW, sem_preWO, sem_preO];


% Create Pre figure

% Darken the original color for error bars
figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];

bar(1:3, bar_data, 'FaceColor', Color, 'EdgeColor', 'flat', 'LineWidth', 1); 
hold on;
errorbar(1:3, bar_data, bar_sem, 'Color', 'k', 'LineStyle', 'none', 'LineWidth', 1.5, 'CapSize', 10); 

set(gca, 'XTickLabel', {'W', 'W-CF', 'CF'}, 'FontSize', 25, 'FontWeight', 'normal'); 
ylabel('Mean ΔF/F0', 'FontSize', 25, 'FontWeight', 'normal'); 
title(gettitle, 'FontSize', 28, 'FontWeight', 'normal'); 

% Statistics
groupedData = [pre_catW(:); pre_catWO(:); pre_catO(:)];
groupLabels = [repmat({'W'}, numel(pre_catW), 1); repmat({'W-CF'}, numel(pre_catWO), 1); repmat({'CF'}, numel(pre_catO), 1)];
[p, ~, stats] = anova1(groupedData, groupLabels, 'off');

maxBar = max(bar_data);
if p < 0.05
    % Post-hoc comparisons if ANOVA is significant
    c = multcompare(stats, 'Display', 'off');
    
    for i = 1:size(c,1)
        lineY = maxBar + 0.02 + ((i)*0.03); % adjust height for each line
        line([c(i,1), c(i,2)], [lineY, lineY], 'Color', 'k', 'LineWidth', 1.5);
        
        % Determine significance stars
        if c(i,6) < 0.0001
            significanceStars = '***';
        elseif c(i,6) < 0.001
            significanceStars = '**';
        elseif c(i,6) < 0.01
            significanceStars = '*';
        else
            significanceStars = 'n.s.';
        end
        if strcmp(significanceStars, 'n.s.')
            text(mean([c(i,1), c(i,2)]), lineY + .04, significanceStars, 'FontSize', 14, 'FontWeight', 'normal', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
        else    
            text(mean([c(i,1), c(i,2)]), lineY -.022, significanceStars, 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        %elseif i == 3
            %text(mean([c(i,1), c(i,2)]), lineY, significanceStars, 'FontSize', 25, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        end
    end
end

ylim([ylimit(1) ylimit(2)]); % Adjust ylim based on number of significant lines


% Save as high resolution
print('-dtiff', '-r300', savename);

hold off

end
