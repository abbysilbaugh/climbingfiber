function [allData] = cellxmotion_prepost(allData, includedcz)

    nMice = size(allData.data, 2);
    for mouse = 1:nMice



        signal = allData.data{mouse}.golayshift;
        motion = allData.data{mouse}.motionInfo;
        tetperiod = allData.data{mouse}.tetPeriod;
        dcz_period = allData.data{mouse}.dczPeriod;


        [~, nCells, nTrials] = size(signal);

        cellxmot_pre = zeros(nCells, 1);

        cellxmot_post = zeros(nCells, 1);


        % Iterate over each cell
        for i = 1:nCells
            % For each cell, accumulate the correlation with motion across trials
            temp_corr_pre = 0;
            temp_corr_post = 0;
            for j = 1:nTrials

                % Get the trace for current cell and trial
                trace = squeeze(signal(:, i, j));
                
                % Get the corresponding motion trace for the current trial
                mot_trace = double(motion(:, j));
                
                % Compute correlation and accumulate
                correlation_matrix = corrcoef(trace, mot_trace);

                if strcmp(includedcz, 'includedcz')
                    if strcmp(tetperiod(j), 'PRE')
                    % Check if correlation is NaN (which happens if mot_trace is constant)
                        if isnan(correlation_matrix(1, 2))
                            temp_corr_pre = temp_corr_pre + 0; % Assign a correlation of 0
                        else
                            temp_corr_pre = temp_corr_pre + correlation_matrix(1, 2);
                        end
                    elseif strcmp(tetperiod(j), 'POST')
                        if isnan(correlation_matrix(1, 2))
                            temp_corr_post = temp_corr_post + 0; % Assign a correlation of 0
                        else
                            temp_corr_post = temp_corr_post + correlation_matrix(1, 2);
                        end
                     end

                else

                if strcmp(tetperiod(j), 'PRE') && strcmp(dcz_period(j), 'NO DCZ')
                % Check if correlation is NaN (which happens if mot_trace is constant)
                    if isnan(correlation_matrix(1, 2))
                        temp_corr_pre = temp_corr_pre + 0; % Assign a correlation of 0
                    else
                        temp_corr_pre = temp_corr_pre + correlation_matrix(1, 2);
                    end
                elseif strcmp(tetperiod(j), 'POST')
                    if isnan(correlation_matrix(1, 2))
                        temp_corr_post = temp_corr_post + 0; % Assign a correlation of 0
                    else
                        temp_corr_post = temp_corr_post + correlation_matrix(1, 2);
                    end
                end

                end

            end
            
            % Average the correlation across trials
            if strcmp(includedcz, 'includedcz')
                cellxmot_pre(i, 1) = temp_corr_pre / sum(strcmp(tetperiod, 'PRE'));
            else
            cellxmot_pre(i, 1) = temp_corr_pre / sum(strcmp(tetperiod, 'PRE')  & strcmp(dcz_period(j), 'NO DCZ'));
            end
            
            cellxmot_post(i, 1) = temp_corr_post / sum(strcmp(tetperiod, 'POST'));

        end

        allData.data{mouse}.cellxmot_pre = cellxmot_pre;
        allData.data{mouse}.cellxmot_post = cellxmot_post;
    end
end

