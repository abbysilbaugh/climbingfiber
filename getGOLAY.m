% CF PAPER METHODS: choose golaysignal3
% Other 3 methods commented out for speed

% adds to allData.data{mouse}...
    % golaysignal (nFrames x nCells x nTrials)
    % golaysignal2 (nFrames x nCells x nTrials)
    % golaysignal3 (nFrames x nCells x nTrials)
    % golaysignal4 (nFrames x nCells x nTrials)

% Function notes:
    % Smooths background subtracted trace with Savitsky-Golay filter using window of size smooth_win
    % Calculates baseline F0 for each ROI using 4 different methods (see below)
    % Expresses signal as dF/F0

% Reference notes:
% Helmchen 2019 Nature Communications Pipeline...
        % Background fluorescence (1st percentile of signal across entire movie) is subtracted from all trials
            % Completed here in backgroundsubtract function
        % Smooth trace over 500 msec window using Savitsky-Golay filter
            % Equivalent of 15 frames here
        % Calculate baseline F0 for each ROI as 1st percentile of smoothed trace across entire session
            % Try 4 different methods here
        % Express signal as dF/F0


        function [allData] = getGOLAY(allData, b_percent, sliding_window_size, smooth_win, whichbackgroundmethod)


nMice = size(allData.data, 2);
for i = 1:nMice

    % Select which method to use from backgroundsubtract function
    if strcmp(whichbackgroundmethod, 'ac_bs_signal')
        signal = allData.data{i}.ac_bs_signal;
    elseif strcmp(whichbackgroundmethod, 'rawminusfirstprctile')
        signal = allData.data{i}.rawminusfirstprctile;
    end
    
    [nFrames, nCells, nTrials] = size(signal);
    
    % Smooth signal with Savitsky-Golay filter of size smooth_win
    smoothsignal = zeros(nFrames, nCells, nTrials);
    for j = 1:nTrials
        for k = 1:nCells
            trace = signal(:, k, j);
            golaytrace = sgolayfilt(trace, 1, smooth_win);
            smoothsignal(:, k, j) = golaytrace;
        end
    end

%     % Method 1: for each cell, find b_percent prctile value of smoothed trace as in Helmchen 2019 (1 value)
%         % Output: golaysignal1
%     smoothcorrsignal1 = zeros(nFrames, nCells, nTrials);
%     for k = 1:nCells
%         trace = squeeze(signal(:, k, :));
%         trace = trace(:);
%         large_window_golaytrace = sgolayfilt(trace, 1, 157);
%         F0 = prctile(large_window_golaytrace, b_percent);
%         for j = 1:nTrials
%             trace = smoothsignal(:, k, j);
%             trace = (trace - F0)./F0;
%             if F0 < 0 
%                 smoothcorrsignal1(:, k, j) = NaN;
%             else
%                 smoothcorrsignal1(:, k, j) = trace;
%             end
%         end
%         if F0 < 0 
%                 warning(['Method 1 F0 < 0 for Cell ', num2str(k), ', Mouse ', num2str(i)])
%         end
%     end

%     % Method 2: for each cell, find b_percent prctile value for each trial individually (nTrials values)
%         % Output: golaysignal2
%     smoothcorrsignal2 = zeros(nFrames, nCells, nTrials);
%     for k = 1:nCells
%         for j = 1:nTrials
%         smoothsignal_temp = smoothsignal(:, k, j);
%         F0 = prctile(smoothsignal_temp, b_percent);
%         if F0 < 0
%             warning(['Method 2 F0 < 0 for Cell ', num2str(k), ', Mouse ', num2str(i), ', Trial', num2str(j)])
%             smoothsignal_temp(:) = NaN;
%         else
%             smoothsignal_temp = (smoothsignal_temp - F0)./F0;
%         end
%         smoothcorrsignal2(:, k, j) = smoothsignal_temp;
%         end
%     end

    % Method 3: for each cell, find b_percent prctile value of average trace (1 value)
        % Output: golaysignal
    smoothcorrsignal = zeros(nFrames, nCells, nTrials);
    for k = 1:nCells
        avgtrace = squeeze(smoothsignal(:, k, :));
        avgtrace = mean(avgtrace, 2, 'omitnan');
        F0 = prctile(avgtrace, b_percent);
        for j = 1:nTrials
            if F0 < 0
                smoothcorrsignal(:, k, j) = NaN(nFrames, 1);
            else
                smoothsignal_temp = smoothsignal(:, k, j);
                smoothsignal_temp = (smoothsignal_temp - F0)./F0;
                smoothcorrsignal(:, k, j) = smoothsignal_temp;
            end
        end
        if F0 < 0
            warning(['Method 3 F0 < 0 for Cell ', num2str(k), ', Mouse ', num2str(i)])
        end
    end

%     % Method 4: for each cell, find b_percent prctile value in sliding window of size sliding_window trials
%         % Output: golaysignal4
%     % Initialize the baseline F0 array
%     smoothcorrsignal4 = zeros(nFrames, nCells, nTrials);
%     
%     % Calculate F0 using a sliding window approach
%     for cell = 1:nCells
%         for trial = 1:nTrials
% 
%             smoothsignal_temp = smoothsignal(:, cell, trial);
%             % Determine the start and end of the window
%             start_idx = max(trial - floor(sliding_window_size / 2), 1);
%             end_idx = min(trial + floor(sliding_window_size / 2), nTrials);
%     
%             % Extract the window of trials for the current cell
%             F0 = smoothsignal(:, cell, start_idx:end_idx);
%             F0 = F0(:);
%     
%             % Calculate the first percentile for each frame within the window
%             F0 = prctile(F0, b_percent);
%             if F0 < 0
%                 warning(['Method 4 F0 < 0 for Cell ', num2str(k), ', Mouse ', num2str(i), ', Trial', num2str(j)])
%                 smoothcorrsignal4(:, cell, trial) = NaN;
%             else
%                 smoothcorrsignal4(:, cell, trial) = (smoothsignal_temp - F0)/F0;
%             end
%         end
%     end
    

    %allData.data{i}.golaysignal1 = smoothcorrsignal1;
    %allData.data{i}.golaysignal2 = smoothcorrsignal2;
    allData.data{i}.golaysignal = smoothcorrsignal;
    %allData.data{i}.golaysignal4 = smoothcorrsignal4;

end

end
