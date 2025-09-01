%% Plot sequential activation
get_trialType = 'W';
get_trialmotType = 'all'; % can be M, NM, T, H
get_var = 'golayshift';
exclude = false; % excludes traces/data based on exclusion criteria
get_cellType = 'all';
responsive_win = 15;

[pre_tet, vartype_pre] = grabdata(allData, get_cellType, 'all', get_trialType, get_trialmotType, 'PRE', 'NO DCZ', get_var, exclude);
[post_tet, vartype_post] = grabdata(allData, get_cellType, 'all', get_trialType, get_trialmotType, 'POST', 'NO DCZ', get_var, exclude);

grabsumresponsive = zeros(20, 2);
for i = 1:20
    Imouse = i;
    pre_traces = pre_tet{Imouse}; post_traces = post_tet{Imouse};
    pre_traces = mean(pre_traces,3); post_traces = mean(post_traces,3);
    nCells = size(pre_traces, 2);
    
    % Sort and Normalize
    [maxvals_pre, fpeak_pre] = max(pre_traces(310:end,:)); [maxvals_post, fpeak_post] = max(post_traces(310:end,:));
    grabsumresponsive(i, 1) = length(find(fpeak_pre < responsive_win))/length(fpeak_pre); grabsumresponsive(i, 2) = length(find(fpeak_post < responsive_win))/length(fpeak_post);
    [sorted_pre, I_pre] = sort(fpeak_pre); [sorted_post, I_post] = sort(fpeak_post);
    pre_traces = ((pre_traces - maxvals_pre) ./ range(pre_traces)); post_traces = ((post_traces - maxvals_post) ./ range(post_traces));
%     global_max = max(max(max(pre_traces,post_traces)));
%     pre_traces = pre_traces/global_max; post_traces = post_traces/global_max;
    % pre_traces = (pre_traces - maxvals_pre) ./ range(pre_traces); post_traces = (post_traces - maxvals_pre) ./ range(pre_traces);
    % pre_traces = pre_traces ./ max(pre_traces); post_traces = post_traces ./  max(post_traces);

    extrema = [min(vertcat(pre_traces,post_traces),[],'all'), max(vertcat(pre_traces,post_traces),[],'all')];
        figure('Position', [200,558,1611,420]);
        subplot(2, 3, 1)
        plot(sorted_pre, -(1:nCells))
        hold on
        plot(sorted_post, -(1:nCells))
        plot(sorted_post-sorted_pre, -(1:nCells))
        xline(0)
        xticks([0 31 62 93 124 156 186 217 248 279 310]);
        xticklabels([0 1 2 3 4 5 6 7 8 9 10]);
        xlim([-200 310])
        ylim([-nCells 0])
        yticklabels([])
    
        subplot(2, 3, 2);
        imagesc(pre_traces(154:end,I_pre)');
        xline(310-154)
        colorbar
        clim(extrema)
        xticks([0 31 62 93 124 156 186 217 248 279 310 341 372 404 434 465]);
        xticklabels([-5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10]);
        xlabel('s')
        
        if strcmp(allData.data{i}.experimentType, 'whiskerTet')
            title('Pre RWS')
        elseif strcmp(allData.data{i}.experimentType, 'whiskerOptoTet')
            title('Pre RWSCF')
        end
        
        subplot(2, 3, 3);
        imagesc(post_traces(154:end,I_post)');
    %     imagesc(post_traces(:,I_pre)'); % Keep pre sorting
        xline(310-154)
        colorbar
        clim(extrema)
        xticks([0 31 62 93 124 156 186 217 248 279 310 341 372 404 434 465]);
        xticklabels([-5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10]);
        xlabel('s')
    
        if strcmp(allData.data{i}.experimentType, 'whiskerTet')
            title('Post RWS')
        elseif strcmp(allData.data{i}.experimentType, 'whiskerOptoTet')
            title('Post RWSCF')
        end
    
        subplot(2, 3, 4)
        scatter(fpeak_pre, fpeak_post)
      
        subplot(2, 3, 5)
        histogram(fpeak_pre, 31)
        ylim([0 150])
    
        subplot(2, 3, 6)
        histogram(fpeak_post, 31)
        ylim([0 150])
end
