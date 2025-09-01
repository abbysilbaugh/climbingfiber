% From Carrillo-Reid et al (J. Neurosci, 2015); Carrillo-Reid et al
% (Science, 2017); Carrillo-Reid (Cell, 2019)

% 1. Infer spike probability from calicum signals (2 SDs above noise)
% 2. Construct N x F binary matrix (N = n active neurons; F = n frames for each movie). Can plot rasters
% 3. Select only population vectors with more active neurons at time T than expected by chance
    % Generate 1000 shuffled raster plots (use circular shift to preserve interburst interval)
    % Identify peaks of synchrony in shuffled and actual data
    % Calculate the p-values by comparing the original peaks against the distribution of peaks from the shifted data
    % Determine which peaks are above chance by checking if their p-value is below 0.01
    % Select these population vectors for further analysis


function ensemblePREPOST(allData, mouse, spont_window, evoked_window)

expType = allData.data{mouse}.experimentType;
    %if strcmp(expType, 'whiskerOptoTet') || strcmp(expType, 'whiskerTet')
    if strcmp(expType, 'whiskerTet')
    
        tetPeriod = allData.data{mouse}.tetPeriod;
        trialType = allData.data{mouse}.trialType;
        cellType = allData.data{mouse}.cellType;
        PNs = strcmp(cellType, 'PN');
        
        pre = strcmp(tetPeriod, 'PRE');
        post = strcmp(tetPeriod, 'POST');
        W_pre = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W');
        W_post = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W');
        
        pre_spont = allData.data{mouse}.spiketimes(spont_window(1):spont_window(2), PNs, pre);
        post_spont = allData.data{mouse}.spiketimes(spont_window(1):spont_window(2), PNs, post);
        pre_W = allData.data{mouse}.spiketimes(evoked_window(1):evoked_window(2), PNs, W_pre);
        post_W = allData.data{mouse}.spiketimes(evoked_window(1):evoked_window(2), PNs, W_post);
        
        % 2. reshape to nCells x nFrames
        [nFrames, nCells, nPre] = size(pre_spont);
        pre_spont = reshape(pre_spont, nCells, nFrames*nPre);
        [~, ~, nPost] = size(post_spont);
        post_spont = reshape(post_spont, nCells, nFrames*nPost);
        [nFrames, ~, nPre_W] = size(pre_W);
        pre_W = reshape(pre_W, nCells, nFrames*nPre_W);
        [~, ~, nPost_W] = size(post_W);
        post_W = reshape(post_W, nCells, nFrames*nPost_W);

        % 3. Select population vectors with more active neurons than ones expected by chance
        % Shuffle data 1000 times
        num_shuffles = 1000;
        shifted_pre_spont = zeros(num_shuffles, size(pre_spont, 2));
        shifted_post_spont = zeros(num_shuffles, size(post_spont, 2));
        shifted_pre_W = zeros(num_shuffles, size(pre_W, 2));
        shifted_post_W = zeros(num_shuffles, size(post_W, 2));

        for i = 1:num_shuffles
            [~, shifted_pre_spont(i, :)] = circular_shift(pre_spont);
            [~, shifted_post_spont(i, :)] = circular_shift(post_spont);
            [~, shifted_pre_W(i, :)] = circular_shift(pre_W);
            [~, shifted_post_W(i, :)] = circular_shift(post_W);
        end

        % Calculate p-value for each population vector (frame)
        pvals_pre_w = calcpvals(pre_W, shifted_pre_W, num_shuffles);
        pvals_post_w = calcpvals(post_W, shifted_post_W, num_shuffles);
        pvals_pre_spont = calcpvals(pre_spont, shifted_pre_spont, num_shuffles);
        pvals_post_spont = calcpvals(post_spont, shifted_post_spont, num_shuffles);

        % Select population vectors with pval < threshold (0.01)
        pre_spont = pre_spont(:, (pvals_pre_spont < 0.01));
        post_spont = post_spont(:, (pvals_post_spont < 0.01));
        pre_W = pre_W(:, (pvals_pre_w < 0.01));
        post_W = post_W(:, (pvals_post_w < 0.01));

        % Do PCA of spont and evoked population vectors (taking each neuron as the independent variable)
        [pre_spont_coef,pre_spont_score,~] = pca(pre_spont');
        pre_spont_coef = pre_spont_coef(:,1:3);
        pre_spont_score = pre_spont_score(:, 1:3);
        
        [post_spont_coef,post_spont_score,~] = pca(post_spont');
        post_spont_coef = post_spont_coef(:,1:3);
        post_spont_score = post_spont_score(:, 1:3);

        [pre_W_coef,pre_W_score,~] = pca(pre_W');
        pre_W_coef = pre_W_coef(:,1:3);
        pre_W_score = pre_W_score(:, 1:3);

        [post_W_coef,post_W_score,~] = pca(post_W');
        post_W_coef = post_W_coef(:,1:3);
        post_W_score = post_W_score(:, 1:3);

%         [pre_spont_coef,pre_spont_score,~] = pca(pre_spont');
%         pre_spont_coef = pre_spont_coef(:,1:3);
%         pre_spont_score = pre_spont_score(:, 1:3);
%         post_spont_score = post_spont'*pre_spont_coef;
% 
%         [pre_W_coef,pre_W_score,~] = pca(pre_W');
%         pre_W_coef = pre_W_coef(:,1:3);
%         pre_W_score = pre_W_score(:, 1:3);
%         post_W_score = post_W'*pre_W_coef;

      
        figure('Position', [50 50 1000 400]);
        subplot(1, 2, 1)
        scatter3(pre_spont_score(:, 1), pre_spont_score(:, 2), pre_spont_score(:, 3), 'MarkerEdgeColor',[34/255, 75/255, 170/255])
        hold on
        scatter3(post_spont_score(:, 1), post_spont_score(:, 2), post_spont_score(:, 3), 'MarkerFaceColor', [34/255, 75/255, 170/255], 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.5)
        title('Spontaneous')
        xlabel('PC1')
        ylabel('PC2')
        zlabel('PC3')
%         xlim([-1, 1])
%         ylim([-1, 1])
%         zlim([-1, 1])
        subplot(1, 2, 2)
        scatter3(pre_W_score(:, 1), pre_W_score(:, 2), pre_W_score(:, 3), 'MarkerEdgeColor',[34/255, 75/255, 170/255])
        hold on
        scatter3(post_W_score(:, 1), post_W_score(:, 2), post_W_score(:, 3), 'filled', 'MarkerFaceColor', [34/255, 75/255, 170/255], 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.5)
        title('Evoked')
        xlabel('PC1')
        ylabel('PC2')
        zlabel('PC3')
        
%         xlim([-1, 1])
%         ylim([-1, 1])
%         zlim([-1, 1])
    
    else
    warning('hi')
    end
end

function [shifted_matrix, ts] = circular_shift(matrix)
    [num_neurons, num_frames] = size(matrix);
    shifted_matrix = zeros(num_neurons, num_frames);
    
    for i = 1:num_neurons
        shift_amount = randi(num_frames);
        shifted_matrix(i, :) = circshift(matrix(i, :), [0, shift_amount]);
    end

    ts = sum(shifted_matrix, 1);
end

function pvals = calcpvals(matrix, shifted_matrix, num_shuffles)
    [~, nFrames] = size(matrix);
    pvals = zeros(1, nFrames);
    for i = 1:nFrames
        ts_real = sum(matrix, 1); ts_real = ts_real(i);
        ts_shuffled = shifted_matrix(:, i);
        temp = ts_shuffled > ts_real;
        pvals(i) = sum(temp)/num_shuffles;
    end
end
