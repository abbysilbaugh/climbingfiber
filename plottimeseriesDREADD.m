function plottimeseriesDREADD(allData, mouse, celltype, mottype, xlimits)

    expType = allData.data{mouse}.experimentType;

    if strcmp(expType, 'whiskerTet_DREADD') || strcmp(expType, 'whiskerOptoTet_DREADD')
        tetPeriod = allData.data{mouse}.tetPeriod;
        trialType = allData.data{mouse}.trialType;
        dczPeriod = allData.data{mouse}.dczPeriod;
        trialmotType = allData.data{mouse}.trialmotType;
        cellType = allData.data{mouse}.cellType;
        
        % get trials, cells, and traces
        if strcmp(mottype, 'all')
            pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
            post_DCZ_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ');
            post_tet_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W');
        else
            pre_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(trialmotType, mottype);
            post_DCZ_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'DCZ') & strcmp(trialmotType, mottype);
            post_tet_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(trialmotType, mottype);
        end
        
        getcells = strcmp(cellType, celltype);
        
        traces_pre = allData.data{mouse}.golayshift(:, getcells, pre_trials);
        traces_post_dcz = allData.data{mouse}.golayshift(:, getcells, post_DCZ_trials);
        traces_post_tet = allData.data{mouse}.golayshift(:, getcells, post_tet_trials);
        
        % concatenate all trials for each cell
        [nFrames, nCells, nTrials_pre] = size(traces_pre);
        [~, ~, nTrials_post_dcz] = size(traces_post_dcz);
        [~, ~, nTrials_post_tet] = size(traces_post_tet);

        traces_PRE = zeros(nCells, nFrames*nTrials_pre);
        traces_POST_DCZ = zeros(nCells, nFrames*nTrials_post_dcz);
        traces_POST_TET = zeros(nCells, nFrames*nTrials_post_tet);

        for i = 1:nCells
            temp = squeeze(traces_pre(:, i, :));
            temp = reshape(temp, 1, []);
            traces_PRE(i, :) = temp;

            temp = squeeze(traces_post_dcz(:, i, :));
            temp = reshape(temp, 1, []);
            traces_POST_DCZ(i, :) = temp;

            temp = squeeze(traces_post_tet(:, i, :));
            temp = reshape(temp, 1, []);
            traces_POST_TET(i, :) = temp;
        end

        mean_pre = mean(traces_PRE, 1);
        mean_post_dcz = mean(traces_POST_DCZ, 1);
        mean_post_tet = mean(traces_POST_TET, 1);
        
        % add 1 to each neuron's trace for visualization
        c = 1;
        for i = 1:nCells
            temp = traces_PRE(i, :) + c;
            traces_PRE(i, :) = temp;

            temp = traces_POST_DCZ(i, :) + c;
            traces_POST_DCZ(i, :) = temp;
        
            temp = traces_POST_TET(i, :) + c;
            traces_POST_TET(i, :) = temp;
        
            c = c+1;
        end
        
        % plot post dcz after pre by shifting post by the total number of frames pre
        % plot post tet after post dcz by shifting post tet by total number
        % of frames post dcz
        x1 = linspace(1, size(traces_PRE, 2), size(traces_PRE, 2));
        x2 = linspace(1, size(traces_POST_DCZ, 2), size(traces_POST_DCZ, 2)) + size(traces_PRE, 2) + 500;
        x3 = linspace(1, size(traces_POST_TET, 2), size(traces_POST_TET, 2)) + size(traces_PRE, 2) +size(traces_POST_DCZ, 2) + 1000;
        
        figure('Position', [50 50 1600 600]);
        %subplot(2, 1, 1)
        for i = 1:nCells
            temp = traces_PRE(i, :);
            plot(x1, temp, 'Color', [34/255, 75/255, 170/255]);
            hold on
        
            temp = traces_POST_DCZ(i, :);
            plot(x2, temp, 'Color', [34/255, 75/255, 170/255]);

            temp = traces_POST_TET(i, :);
            plot(x3, temp, 'Color', [34/255, 75/255, 170/255]);
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
        num_steps = nTrials_post_dcz;
        
        stim_vector_post_dcz = start_value:step_size:(start_value + step_size * (num_steps - 1));

        start_value = nFrames*nTrials_pre + nFrames*nTrials_post_dcz + 1000 + 310;
        step_size = nFrames;
        num_steps = nTrials_post_tet;

        stim_vector_post_tet = start_value:step_size:(start_value + step_size * (num_steps - 1));
        
        for i = 1:length(stim_vector_pre)
            xline(stim_vector_pre(i), 'Color', 'k')
        end
        
        for i = 1:length(stim_vector_post_dcz) 
            xline(stim_vector_post_dcz(i), 'Color', 'k')
        end

        for i = 1:length(stim_vector_post_tet) 
            xline(stim_vector_post_tet(i), 'Color', 'k')
        end 
        
        rectangle('Position', [nFrames*nTrials_pre, 0, 500, 1.1*nCells], 'LineStyle', ':', 'LineWidth', 1)

        rectangle('Position', [(nFrames*nTrials_pre + nFrames*nTrials_post_dcz + 500), 0, 500, 1.1*nCells], 'LineStyle', ':', 'LineWidth', 1)

%         if strcmp(expType, 'whiskerTet_DREADD')
%             title('RWS (DREADD)')
%         elseif strcmp(expType, 'whiskerOptoTet_DREADD')
%             title('RWSCF (DREADD)')
%         end

        xlim(xlimits)
        xticklabels('')
        ylabel('Neuron')
        set(gca, 'FontSize', 15)

        ylim([0 106])

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