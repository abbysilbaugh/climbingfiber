function [covdata] = calccov(data,pltfig)

% pltfig is boolean to signal you want to plot the covariance matrix

[~, nCells, ~] = size(data);
covdata = zeros(nCells, nCells);

% Iterate over each pair of cells and calculate the covariance across all
% trials
for i = 1:nCells
    % Concatenate trace across all trials
    trace_0 = reshape(data(:,i,:),[],1);

    % Remove elements that are NaN (will be same elements across all cells)
    trace_0(isnan(trace_0)) = [];

    % Covariance is symmetric, only need upper triangle
    % i.e. cov between cell 1 and cell 2 is the same as cell 2 and cell 1
    for j = (i+1):nCells
        trace_1 = reshape(data(:,j,:),[],1);
        trace_1(isnan(trace_1)) = [];
        
        temp = cov(trace_0, trace_1); % Returns 2x2 covariance matrix
        covdata(i,j) = temp(1,2); % We only want covariance 
    end
end

% Reflect across diagonal for visualization / symmetry
covdata = covdata + transpose(covdata);

% Plot
if pltfig
    figure
    imagesc(covdata)
    colorbar
    
end

end