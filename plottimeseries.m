function plottimeseries(allData, mouse, celltype, mottype)

    expType = allData.data{mouse}.experimentType;

    if strcmp(expType, 'whiskerTet') || strcmp(expType, 'whiskerOptoTet')
        tetPeriod = allData.data{mouse}.tetPeriod;
        trialType = allData.data{mouse}.trialType;
        trialmotType = allData.data{mouse}.trialmotType;
        cellType = allData.data{mouse}.cellType;
        
        % get trials, cells, and traces
        if strcmp(mottype, 'all')
            pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W');
            post_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W');
        else
            pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(trialmotType, mottype);
            post_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(trialmotType, mottype);
        end
        
        getcells = strcmp(cellType, celltype);
        
        traces_pre = allData.data{mouse}.golayshift(:, getcells, pre_trials);
        traces_post = allData.data{mouse}.golayshift(:, getcells, post_trials);

        [nFrames, nCells, nTrials_pre] = size(traces_pre);

        % Sort by max value in post condition
        savemax = zeros(nCells, 1);
        for i = 1:nCells
            temp = traces_post(:, i, :);
            temp = temp(:);
            savemax(i) = max(temp);
        end

        [~, sorted_indices] = sort(savemax);
        sorted_indices = flip(sorted_indices);
        traces_pre = traces_pre(:, sorted_indices, :);
        traces_post = traces_post(:, sorted_indices, :);
        
        % concatenate all trials for each cell
        [~, ~, nTrials_post] = size(traces_post);

        traces_PRE = zeros(nCells, nFrames*nTrials_pre);
        traces_POST = zeros(nCells, nFrames*nTrials_post);
        for i = 1:nCells
            temp = squeeze(traces_pre(:, i, :));
            temp = reshape(temp, 1, []);
            traces_PRE(i, :) = temp;

            temp = squeeze(traces_post(:, i, :));
            temp = reshape(temp, 1, []);
            traces_POST(i, :) = temp;
        end

        mean_pre = mean(traces_PRE, 1);
        mean_post = mean(traces_POST, 1);
        
        % add 1 to each trace for visualization
        c = 1;
        for i = 1:nCells
            temp = traces_PRE(i, :) + c;
            traces_PRE(i, :) = temp;
        
            temp = traces_POST(i, :) + c;
            traces_POST(i, :) = temp;
        
            c = c+1;
        end
        
        % plot post after pre by shifting post by the total number of frames pre
        x1 = linspace(1, size(traces_PRE, 2), size(traces_PRE, 2));
        x2 = linspace(1, size(traces_POST, 2), size(traces_POST, 2)) + size(traces_PRE, 2) + 500;
       


        figure('Position', [50 50 1600 600]);
        %subplot(2, 1, 1)
        for i = 1:nCells
            temp = traces_PRE(i, :);
            plot(x1, temp, 'Color', [34/255, 75/255, 170/255]);
            hold on
        
            temp = traces_POST(i, :);
            plot(x2, temp, 'Color', [34/255, 75/255, 170/255]);
        end
    
        % start_value = 1;
        % step_size = nFrames;
        % num_steps = nTrials_pre + nTrials_post;
        % 
        % vector = start_value:step_size:(start_value + step_size * (num_steps - 1));
        
        start_value = 310;
        step_size = nFrames;
        num_steps = nTrials_pre;
        
        stim_vector_pre = start_value:step_size:(start_value + step_size * (num_steps - 1));
        
        start_value = nFrames*nTrials_pre + 500 + 310;
        step_size = nFrames;
        num_steps = nTrials_post;
        
        stim_vector_post = start_value:step_size:(start_value + step_size * (num_steps - 1));
        
        for i = 1:length(stim_vector_pre)
            xline(stim_vector_pre(i), 'Color', 'k')
        end
        
        for i = 1:length(stim_vector_post) 
            xline(stim_vector_post(i), 'Color', 'k')
        end
        
        rectangle('Position', [nFrames*nTrials_pre, 0, 500, 1.1*nCells], 'LineStyle', ':', 'LineWidth', 1)
        if strcmp(expType, 'whiskerTet')
            title('RWS')
        elseif strcmp(expType, 'whiskerOptoTet')
            title('RWSCF')
        end

 

%         subplot(2, 1, 2)
%         plot(x1, mean_pre)
%         hold on
%         plot(x2, mean_post)
%         
%         start_value = 310;
%         step_size = nFrames;
%         num_steps = nTrials_pre;
%         
%         stim_vector_pre = start_value:step_size:(start_value + step_size * (num_steps - 1));
%         
%         start_value = nFrames*nTrials_pre + 500 + 310;
%         step_size = nFrames;
%         num_steps = nTrials_post;
%         
%         stim_vector_post = start_value:step_size:(start_value + step_size * (num_steps - 1));
%         
%         for i = 1:length(stim_vector_pre)
%             xline(stim_vector_pre(i), 'Color', 'r')
%         end
%         
%         for i = 1:length(stim_vector_post) 
%             xline(stim_vector_post(i), 'Color', 'r')
%         end
        
    
    end

end