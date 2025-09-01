%% Get trace ordering
get_trialType = 'W';
get_trialmotType = 'all'; % can be M, NM, T, H
get_var = 'golayshift';
exclude = false; % excludes traces/data based on exclusion criteria
get_cellType = 'all';
responsive_win = 15;
Imouse = 1;

[pre_tet, vartype_pre] = grabdata(temp, get_cellType, 'all', get_trialType, get_trialmotType, 'PRE', 'NO DCZ', get_var, exclude);
[post_tet, vartype_post] = grabdata(temp, get_cellType, 'all', get_trialType, get_trialmotType, 'POST', 'NO DCZ', get_var, exclude);
pre_traces = mean(pre_tet{1},3); post_traces = mean(post_tet{1},3);
ncells = size(pre_traces, 2);

% Sort traces by max value
[~, fpeak_pre] = max(pre_traces(310:end,:)); [~, fpeak_post] = max(post_traces(310:end,:));
[~, I_pre] = sort(fpeak_pre); [~, I_post] = sort(fpeak_post);
%% Get edges of ROIs
edge_coords = cell(ncells,1);

imm = imread('AVG_003_026_002_OUT_MotCor.jpg'); % load the jpeg
[total_num_rows, total_num_columns] = size(imm); % figure out rows and columns
[ROIName, ROIPath] = uigetfile('*set.zip'); % Load ImageJ ROIs from the .roi zip file
roi_list = ReadImageJROI([ROIPath,ROIName]);

% Get edge coords
for i = 1:numel(roi_list)
    roi = roi_list{i};
    
    switch roi.strType
        case 'Rectangle'
            x_start = roi.vnRectBounds(1);
            y_start = roi.vnRectBounds(2);
            x_end = roi.vnRectBounds(3);
            y_end = roi.vnRectBounds(4);
            
            roi_mask(y_start:y_end, x_start:x_end) = true;
        case 'Oval'
            % You can use regionprops to obtain the ellipse mask
            error('Oval ROIs are not yet supported in this code.');
        case 'Polygon'
            xv = roi.mnCoordinates(:, 1);
            yv = roi.mnCoordinates(:, 2);

            edge_coords{i} = roi.mnCoordinates;

        otherwise
            error('Unsupported ROI type: %s', roi.strType);
    end
end

%% Plot

% Color scheme
r = [1 0 0];
b = [0 0 1];
colors = zeros(ncells,3);
for i = 1:3
    colors(1:floor(size(colors,1)/2), i) = linspace(r(i) ,b(i) ,floor(size(colors,1)/2));
end
colors(floor(size(colors,1)/2)+1:end, :) = flipud(colors(1:ceil(size(colors,1)/2), :));

% Pre
figure;
imshow(imm)
hold on
for i = 1:int64(ncells)
    fill(edge_coords{i}(:,1), edge_coords{i}(:,2), colors(I_pre(i),:))
end
hold off

% Post
figure;
imshow(imm)
hold on
for i = 1:int64(ncells)
    fill(edge_coords{i}(:,1), edge_coords{i}(:,2), colors(I_post(i),:))
end
hold off