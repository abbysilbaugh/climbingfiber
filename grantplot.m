function grantplot(allData, mouse, increase_cells, decrease_cells, active_PRE_RWS, active_POST_RWS)

    signal = allData.data{mouse}.golayshift;
    trialType = allData.data{mouse}.trialType;
    tetType = allData.data{mouse}.tetPeriod;
    cellType = allData.data{mouse}.cellType;
    trialmotType = allData.data{mouse}.trialmotType;
    expType = allData.data{mouse}.experimentType;

    pre_trials = strcmp(trialType, 'W') & strcmp(tetType, 'PRE') & strcmp(trialmotType, 'NM');
    post_trials = strcmp(trialType, 'W') & strcmp(tetType, 'POST') & strcmp(trialmotType, 'NM');

    %active_pre = active_PRE_RWS(:, 2) == mouse;
    active_post = active_POST_RWS(:, 2) == mouse;

    %active_PRE_RWS = active_PRE_RWS(active_pre);
    active_POST_RWS = active_POST_RWS(active_post);

    signal_pre = signal(:, active_POST_RWS, pre_trials); 
    signal_post = signal(:, active_POST_RWS, post_trials); 

    [nFrames, nCells, ~] = size(signal_pre);
    for i = 1:nCells
        pre = squeeze(signal_pre(:, i, :)); pre = mean(pre, 2);
        post = squeeze(signal_post(:, i, :)); post = mean(post, 2);
        figure;
        plot(pre, 'Color', 'k')
        hold on
        plot(post, 'Color', 'b')
        xline(310)
    end


end