function plot_ROI_FOV(allData, active_PRE_RWS, active_POST_RWS)
mouse = 2;
FOVfile = '20230306_FOV_scalebar.jpg';
ROIName = '20230306_RoiSet.zip';
ROIPath = 'C:\Users\silbaugh\Desktop\Abby\20230516_analysis\20230306 PVCre Whisker Tet\';


    active_PRE = active_PRE_RWS(:, 2) == mouse;
    active_POST = active_POST_RWS(:, 2) == mouse;

    active_PRE = active_PRE_RWS(active_PRE, 1);
    active_POST = active_POST_RWS(active_POST, 1);

    active_PREandPOST = intersect(active_PRE, active_POST);
    active_onlyPOST = setdiff(active_POST, active_PRE);
    active_onlyPRE = setdiff(active_PRE, active_POST);


ncells = size(allData.data{mouse}.golayshift, 2);
edge_coords = cell(ncells,1);

imm = imread('AVG_003_026_002_OUT_MotCor.jpg'); % load the jpeg
[total_num_rows, total_num_columns] = size(imm); % figure out rows and columns
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
areas = zeros(1, length(edge_coords));
for i = 1:length(edge_coords)
    area = polyarea(edge_coords{i}(:,1), edge_coords{i}(:,2));
    if area > 120
        areas(i) = area;
    end
end
areas = logical(areas);
plotcells = linspace(1, length(edge_coords), length(edge_coords));
plotcells = plotcells(areas);

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
im = imshow(FOVfile);
set(im, 'AlphaData', 0.9);
hold on
for i = plotcells
    p = fill(edge_coords{i}(:,1), edge_coords{i}(:,2), [0.5,0.5,0.5]);
    p.EdgeColor = 'k';
    p.FaceColor = [0.5 0.5 0.5];
    p.FaceAlpha = 0;
end
for i = active_onlyPRE'
    p = fill(edge_coords{i}(:,1), edge_coords{i}(:,2), [71 101 161]/255);
    p.EdgeColor = [71 101 161]/255;
    p.FaceColor = [71 101 161]/255;
    p.FaceAlpha = 0.6;
end

for i = active_PREandPOST'
    p = fill(edge_coords{i}(:,1), edge_coords{i}(:,2), [71 101 161]/255);
    p.EdgeColor = [71 101 161]/255;
    p.FaceColor = [71 101 161]/255;
    p.FaceAlpha = 0.6;
end
ax = gca;
ax.Visible = 'off';

% Post
figure;
im = imshow(FOVfile);
set(im, 'AlphaData', 0.9);
hold on
for i = plotcells
    p = fill(edge_coords{i}(:,1), edge_coords{i}(:,2), [0.5,0.5,0.5]);
    p.EdgeColor = 'k';
    p.FaceColor = [0.5 0.5 0.5];
    p.FaceAlpha = 0;
end
for i = active_onlyPOST'
    p = fill(edge_coords{i}(:,1), edge_coords{i}(:,2), [212,60,0]/255);
    p.EdgeColor = [212,60,0]/255;
    p.FaceColor = [212,60,0]/255;
    p.FaceAlpha = 0.6;
end

for i = active_PREandPOST'
    p = fill(edge_coords{i}(:,1), edge_coords{i}(:,2), [71 101 161]/255);
    p.EdgeColor = [71 101 161]/255;
    p.FaceColor = [71 101 161]/255;
    p.FaceAlpha = 0.6;
end
ax = gca;
ax.Visible = 'off';
end