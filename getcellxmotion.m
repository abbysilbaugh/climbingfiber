function [allData] = getcellxmotion(allData, motion_type, signal_type)

    nMice = size(allData.data, 2);
    for mouse = 1:nMice

        if strcmp(signal_type, 'signal')
            signal = allData.data{mouse}.signal;
        elseif strcmp(signal_type, 'golaysignal')
            signal = allData.data{mouse}.golaysignal;
        elseif strcmp(signal_type, 'golayshift')
            signal = allData.data{mouse}.golayshift;
        elseif strcmp(signal_type, 'spiketimes')
            signal = allData.data{mouse}.spiketimes;
        elseif strcmp(signal_type, 'c_oasis')
            signal = allData.data{mouse}.c_oasis;
        elseif strcmp(signal_type, 'golaysignal2')
            signal = allData.data{mouse}.golaysignal2;
        elseif strcmp(signal_type, 'golaysignal1')
            signal = allData.data{mouse}.golaysignal1;
        elseif strcmp(signal_type, 'golaysignal4')
            signal = allData.data{mouse}.golaysignal4;
        end

        if strcmp(motion_type, 'running')
            motion = allData.data{mouse}.running;
        elseif strcmp(motion_type, 'motion')
            motion = allData.data{mouse}.motionInfo;
        end
        
        [~, nCells, nTrials] = size(signal);

        cellxmot = zeros(nCells, 1);

        % Iterate over each cell
        for i = 1:nCells
            % For each cell, accumulate the correlation with motion across trials
            temp_corr = 0;
            for j = 1:nTrials

                % Get the trace for current cell and trial
                trace = squeeze(signal(:, i, j));
                
                % Get the corresponding motion trace for the current trial
                mot_trace = double(motion(:, j));
                
                % Compute correlation and accumulate
                correlation_matrix = corrcoef(trace, mot_trace);
                % Check if correlation is NaN (which happens if mot_trace is constant)
                if isnan(correlation_matrix(1, 2))
                    temp_corr = temp_corr + 0; % Assign a correlation of 0
                else
                    temp_corr = temp_corr + correlation_matrix(1, 2);
                end

            end
            
            % Average the correlation across trials
            cellxmot(i, 1) = temp_corr / nTrials;
        end

        allData.data{mouse}.cellxmot = cellxmot;
    end
end

