function [xcorr_pre, xcorr_post] = crosscorr_prepost(allData, mouse, window)
    signal = allData.data{mouse}.golayshift;
    trialType = allData.data{mouse}.trialType;
    tetType = allData.data{mouse}.tetPeriod;
    cellType = allData.data{mouse}.cellType;
    trialmotType = allData.data{mouse}.trialmotType;
    expType = allData.data{mouse}.experimentType;


    PNs = strcmp(cellType, 'PN');

    w_pre = strcmp(trialType, 'W') & strcmp(tetType, 'PRE') & strcmp(trialmotType, 'NM');
    w_post = strcmp(trialType, 'W') & strcmp(tetType, 'POST') & strcmp(trialmotType, 'NM');

    w_pre = signal(window(1):window(2), PNs, w_pre);
    [~, nCells, nTrials_pre] = size(w_pre);
    w_post = signal(window(1):window(2), PNs, w_post);
    nTrials_post = size(w_post,3);

    xcorr_pre = zeros(nCells);
    xcorr_post = zeros(nCells);

    % Get autocorrelation first
    autocorr_pre = zeros(nCells,1);
    autocorr_post = zeros(nCells,1);
    for i = 1:nCells
        for j = 1:nTrials_pre
            autocorr_pre(i) = autocorr_pre(i) + xcorr(w_pre(:,i,j),w_pre(:,i,j),0);
        end
        for j = 1:nTrials_post
            autocorr_post(i) = autocorr_post(i) + xcorr(w_post(:,i,j),w_post(:,i,j),0);
        end
    end

    % Get cross-correlations
    for i = 1:nCells
        for j = i+1:nCells
            for k = 1:nTrials_pre
                xcorr_pre(i,j) = xcorr_pre(i,j) + xcorr(w_pre(:,i,k), w_pre(:,j,k),0);
            end
            xcorr_pre(i,j) = xcorr_pre(i,j) / sqrt(autocorr_pre(i)*autocorr_pre(j)); % normalize

            for k = 1:nTrials_post
                xcorr_post(i,j) = xcorr_post(i,j) + xcorr(w_post(:,i,k), w_post(:,j,k),0);
            end
            xcorr_post(i,j) = xcorr_post(i,j) / sqrt(autocorr_post(i)*autocorr_post(j));
        end
    end

    % Reflect
    xcorr_pre = xcorr_pre + xcorr_pre';
    xcorr_post = xcorr_post + xcorr_post';

    % Fill in diagonal
    for i = 1:nCells
        xcorr_pre(i,i) = 1;
        xcorr_post(i,i) = 1;
    end
    
    % Sort by mean correlation
    [~, Isort_pre] = sort(mean(xcorr_pre));
    [~, Isort_post] = sort(mean(xcorr_post), 'descend');
    xcorr_pre = xcorr_pre(Isort_post,:);
    xcorr_pre = xcorr_pre(:,Isort_post);
    xcorr_post = xcorr_post(Isort_post,:);
    xcorr_post = xcorr_post(:,Isort_post);

    figure('Position', [50 50 1500 500]);
    subplot(1, 4, 1)
    title('PRE')
    imagesc(xcorr_pre);
    caxis([0 1])
    colorbar;
    

    subplot(1, 4, 2)
    title('POST')
    imagesc(xcorr_post);
    caxis([0 1])
    colorbar;

    subplot(1, 4, 3)
    points_pre = xcorr_pre(triu(true(nCells), 1));
    points_post = xcorr_post(triu(true(nCells), 1));
    hold on
    plot([ones(length(points_pre),1), 2*ones(length(points_post),1)]', [points_pre, points_post]', '-o', 'Color', [34/255, 75/255, 170/255, 0.5], 'MarkerFaceColor', [34/255, 75/255, 170/255], 'MarkerEdgeColor', 'none');
    xticks([1 2])
    xticklabels({'PRE'; 'POST'})
    ylabel('cross-corr')

    subplot(1, 4, 4)
    boxplot([points_pre, points_post])
    title(expType)


    
end