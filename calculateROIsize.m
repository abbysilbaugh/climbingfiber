function [allData, roi_size_summary] = calculateROIsize(allData)
    getmice = 1:size(allData.data, 2);
    config2_1 = 1;
    config2_2 = 3;
    config2_3 = 7;
    
    % Initialize struct to store ROI sizes for each cell type
    roiSizes.PN.max = [];
    roiSizes.PN.avg = [];
    roiSizes.PN.max_std = [];
    roiSizes.PN.avg_std = [];
    roiSizes.UC.max = [];
    roiSizes.UC.avg = [];
    roiSizes.UC.max_std = [];
    roiSizes.UC.avg_std = [];
    roiSizes.VIP.max = [];
    roiSizes.VIP.avg = [];
    roiSizes.SST.max = [];
    roiSizes.SST.avg = [];
    roiSizes.PV.max = [];
    roiSizes.PV.avg = [];
    
    for i = getmice 
        temp = allData.data{i}.ROIcoords;
        cellType = allData.data{i}.cellType;
        roi_sizes_max = NaN(length(cellType), 1);
        roi_sizes_avg = NaN(length(cellType), 1);

        if length(temp) == length(cellType)
            if i ~= config2_1 && i ~= config2_2 && i ~= config2_3

                [roi_sizes_max, roi_sizes_avg] = computeDiameters(temp);
        
                % Identify cell type indices
                PNs = temp(strcmp(cellType, 'PN'));
                UCs = temp(strcmp(cellType, 'UC'));
                VIPs = temp(strcmp(cellType, 'VIP'));
                SSTs = temp(strcmp(cellType, 'SST'));
                PVs = temp(strcmp(cellType, 'PV'));
        
                % Compute max and average diameters for each ROI and store by cell type
                [maxPNs, avgPNs] = computeDiameters(PNs);
                [maxUCs, avgUCs] = computeDiameters(UCs);
                [maxVIPs, avgVIPs] = computeDiameters(VIPs);
                [maxSSTs, avgSSTs] = computeDiameters(SSTs);
                [maxPVs, avgPVs] = computeDiameters(PVs);
        
                roiSizes.PN.max = [roiSizes.PN.max; maxPNs];
                roiSizes.PN.avg = [roiSizes.PN.avg; avgPNs];
                roiSizes.UC.max = [roiSizes.UC.max; maxUCs];
                roiSizes.UC.avg = [roiSizes.UC.avg; avgUCs];
                roiSizes.VIP.max = [roiSizes.VIP.max; maxVIPs];
                roiSizes.VIP.avg = [roiSizes.VIP.avg; avgVIPs];
                roiSizes.SST.max = [roiSizes.SST.max; maxSSTs];
                roiSizes.SST.avg = [roiSizes.SST.avg; avgSSTs];
                roiSizes.PV.max = [roiSizes.PV.max; maxPVs];
                roiSizes.PV.avg = [roiSizes.PV.avg; avgPVs];
            end
        end

        allData.data{i}.roi_sizes_max = roi_sizes_max;
        allData.data{i}.roi_sizes_avg = roi_sizes_avg;
    end
    
    % Compile VIP, SST, and PV before calculating statistics
    compiledVIPs = [roiSizes.VIP.max; roiSizes.VIP.avg];
    compiledSSTs = [roiSizes.SST.max; roiSizes.SST.avg];
    compiledPVs = [roiSizes.PV.max; roiSizes.PV.avg];

    taggedINs_max = cat(1, roiSizes.VIP.max, roiSizes.SST.max, roiSizes.PV.max);
    taggedINs_avg = cat(1, roiSizes.VIP.avg, roiSizes.SST.avg, roiSizes.PV.avg);

    mean_max_taggedINs = mean(taggedINs_max, 'omitnan');
    std_max_taggedINs = std(taggedINs_max, 'omitnan');
    mean_avg_taggedINs = mean(taggedINs_avg, 'omitnan');
    std_avg_taggedINs = std(taggedINs_avg, 'omitnan');

    % Compute the mean and standard deviation of max and avg diameters for PNs and UCs
    roi_size_summary.PN.max = mean(roiSizes.PN.max, 'omitnan');
    roi_size_summary.PN.max_std = std(roiSizes.PN.max, 'omitnan');
    roi_size_summary.PN.avg = mean(roiSizes.PN.avg, 'omitnan');
    roi_size_summary.PN.avg_std = std(roiSizes.PN.avg, 'omitnan');
   
    roi_size_summary.UC.max = mean(roiSizes.UC.max, 'omitnan');
    roi_size_summary.UC.max_std = std(roiSizes.UC.max, 'omitnan');
    roi_size_summary.UC.avg = mean(roiSizes.UC.avg, 'omitnan');
    roi_size_summary.UC.avg_std = std(roiSizes.UC.avg, 'omitnan');

    roi_size_summary.VIP.max = mean(roiSizes.VIP.max, 'omitnan');
    roi_size_summary.VIP.max_std = std(roiSizes.VIP.max, 'omitnan');
    roi_size_summary.VIP.avg = mean(roiSizes.VIP.avg, 'omitnan');
    roi_size_summary.VIP.avg_std = std(roiSizes.VIP.avg, 'omitnan');
   
    roi_size_summary.SST.max = mean(roiSizes.SST.max, 'omitnan');
    roi_size_summary.SST.max_std = std(roiSizes.SST.max, 'omitnan');
    roi_size_summary.SST.avg = mean(roiSizes.SST.avg, 'omitnan');
    roi_size_summary.SST.avg_std = std(roiSizes.SST.avg, 'omitnan');

    roi_size_summary.PV.max = mean(roiSizes.PV.max, 'omitnan');
    roi_size_summary.PV.max_std = std(roiSizes.PV.max, 'omitnan');
    roi_size_summary.PV.avg = mean(roiSizes.PV.avg, 'omitnan');
    roi_size_summary.PV.avg_std = std(roiSizes.PV.avg, 'omitnan');

    % Perform statistics
    PN_max = roiSizes.PN.max;
    PN_avg = roiSizes.PN.avg;

    UC_max = roiSizes.UC.max;
    UC_avg = roiSizes.UC.avg;

    

end

function [maxDiameters, avgDiameters] = computeDiameters(ROIs)
    numROIs = numel(ROIs);
    maxDiameters = nan(numROIs, 1);
    avgDiameters = nan(numROIs, 1);
    
    for j = 1:numROIs
        coords = ROIs{j}; % Nx2 array of (x,y) coordinates
        dists = pdist(coords, 'euclidean'); % Compute pairwise distances
        maxDiameters(j) = max(dists)*1.005; % Maximum distance in polygon, converted to mm
        avgDiameters(j) = mean(dists)*1.005; % Average distance in polygon, converted to mm
    end
end


