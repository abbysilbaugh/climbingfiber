function edge_coords = getedgecoords(roi_list)

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

end