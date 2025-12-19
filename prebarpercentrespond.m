function prebarpercentrespond(allData, cellType, cellmotType, trialmotType, variable, exclude, savename)


% Choose color
if strcmp(cellType, 'PV')
    Color = [187, 37, 37]/255; % Red
elseif strcmp(cellType, 'PN')
    Color = [37, 112, 187]/255; % Blue
elseif strcmp(cellType, 'VIP')
    Color = [37 187 112]/255; % Green
elseif strcmp(cellType, 'UC')
    Color = [0 0 0]/255; % Black
end

% Grab W data
[preW, pre_vartype] = grabdata(allData, cellType, cellmotType, 'W', trialmotType, 'PRE',  'NO DCZ', variable, exclude);
[preW, ~, pre_vartype] = trialavg(preW, pre_vartype);
[pre_catW, varcattype] = catmice(allData, preW, pre_vartype, 'all');

% Grab WO data
[preWO, pre_vartype] = grabdata(allData, cellType, cellmotType, 'WO', trialmotType, 'PRE',  'NO DCZ', variable, exclude);
[preWO, ~, pre_vartype] = trialavg(preWO, pre_vartype);
[pre_catWO, varcattype] = catmice(allData, preWO, pre_vartype, 'all');

% Grab O data
[preO, pre_vartype] = grabdata(allData, cellType, cellmotType, 'O', trialmotType, 'PRE',  'NO DCZ', variable, exclude);
[preO, ~, pre_vartype] = trialavg(preO, pre_vartype);
[pre_catO, varcattype] = catmice(allData, preO, pre_vartype, 'all');

num_W = sum(~isnan(pre_catW));
num_WO = sum(~isnan(pre_catWO));
num_O = sum(~isnan(pre_catO));

total_cells = length(pre_catW);

bar_data = [num_W/total_cells, num_WO/total_cells, num_O/total_cells]*100;


% Create figure
% Define the positions for each bar. If you have three bars, you might use 1, 2, and 3.
x_positions = 1:3;  % Adjust as necessary based on your specific plot.

% Define the colors for each bar.
colors = {
    [0, 0, 0],              % For 'W', black color.
    Color,                  % For 'W-CF', custom color based on cell type.
    [37, 187, 187] / 255    % For 'O', teal color.
};

alphas = [0.4, 0.6, 0.5];

% Create a new figure (or specify the subplot, if you're working with multiple plots).
figure('units', 'pixels','Position', [0,0,500,450]);  
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];
set(gca, 'XTick', x_positions)
set(gca, 'XTickLabel', {'W', 'W-CF', 'CF'}, 'FontSize', 25, 'FontWeight', 'normal'); 
ylabel('% cells responsive', 'FontSize', 25, 'FontWeight', 'normal'); 
hold on;

% Manually create each bar.
for i = 1:length(bar_data)
    bar(x_positions(i), bar_data(i), 'FaceColor', colors{i}, 'FaceAlpha', alphas(i), 'EdgeColor', colors{i}, 'LineWidth', 2);
end


% Ensure everything is properly aligned.
xlim([0, max(x_positions) + 1]);  % Adjusting X limits to make sure all bars and error bars fit nicely.

% Initialize title string
title_str = '';

% Check the cellType and construct the corresponding title
switch cellType
    case 'PV'
        title_str = ['Total ', cellType, ': ', num2str(total_cells)];
    case 'VIP'
        title_str = ['Total ', cellType, ': ', num2str(total_cells)];
    case 'UC'
        title_str = ['Total pVIP: ', num2str(total_cells)];
    case 'PN'
        title_str = ['Total pPN: ', num2str(total_cells)];
    otherwise
        warning('Unexpected cell type. No title will be set.')
end
title(title_str, 'FontSize', 28, 'FontWeight', 'normal'); 


ylim([0 100]); % Adjust ylim based on number of significant lines


% Save as high resolution
print('-djpeg', '-r300', savename);

hold off

end
