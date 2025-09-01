function cbdata = processcb()

addpath('20220306 L7Cre/AC ROI Analysis');
addpath('20220310 L7Cre/AC ROI Analysis');

    % Define folders
    folders = {'20220306 L7Cre/AC ROI Analysis/Stim1', ...
        '20220306 L7Cre/AC ROI Analysis/Stim2', ...
        '20220306 L7Cre/AC ROI Analysis/Stim3', ...
        '20220310 L7Cre/AC ROI Analysis/Stim1', ...
        '20220310 L7Cre/AC ROI Analysis/Stim2', ...
        '20220310 L7Cre/AC ROI Analysis/Stim3', ...
        '20220310 L7Cre/AC ROI Analysis/Stim4'};
    
    % Initialize empty cell arrays to store trial data for each folder
    mse1_stim1 = {};
    mse1_stim2 = {};
    mse1_stim3 = {};
    mse2_stim1 = {};
    mse2_stim2 = {};
    mse2_stim3 = {};
    mse2_stim4 = {};
    
    % Iterate through each folder and load activs data
    for f = 1:length(folders)
        folder = folders{f};
        files = dir(fullfile(folder, '*.mat')); % Get list of .mat files
        
        trialIdx = 1; % Track trial index per folder
        
        for i = 1:length(files)
            filePath = fullfile(folder, files(i).name);
            data = load(filePath); % Load .mat file
            
            if isfield(data, 'activs')
                if f == 1
                    mse1_stim1{trialIdx} = data.activs;
                elseif f == 2
                    mse1_stim2{trialIdx} = data.activs;
                elseif f == 3
                    mse1_stim3{trialIdx} = data.activs;
                elseif f == 4
                    mse2_stim1{trialIdx} = data.activs;
                elseif f == 5
                    mse2_stim2{trialIdx} = data.activs;
                elseif f == 6
                    mse2_stim3{trialIdx} = data.activs;
                elseif f == 7
                    mse2_stim4{trialIdx} = data.activs;
                elseif f == 8
                end
                trialIdx = trialIdx + 1;
            else
                warning('File %s does not contain variable "activs". Skipping.', files(i).name);
            end
        end
    end
    
    % Convert cell arrays to 3D matrices (nFrames x nROIs x nTrials)
    mse1_sig1 = createSignalMatrix(mse1_stim1);
    mse1_sig2 = createSignalMatrix(mse1_stim2);
    mse1_sig3 = createSignalMatrix(mse1_stim3);
    mse2_sig1 = createSignalMatrix(mse2_stim1);
    mse2_sig2 = createSignalMatrix(mse2_stim2);
    mse2_sig3 = createSignalMatrix(mse2_stim3);
    mse2_sig4 = createSignalMatrix(mse2_stim4);

    % Background correct and smooth using Hansel algorithm (Busch and Hansel 2023)
    variables = {'mse1_sig1', 'mse1_sig2', 'mse1_sig3', 'mse2_sig1', 'mse2_sig2', 'mse2_sig3', 'mse2_sig4'};

    for v = 1:length(variables)
        eval([variables{v} ' = BCandSmooth(' variables{v} ', 5);']);
    end

    mse1_sig1_spont = mse1_sig1([1:305, 500:610], :, :);
    mse1_sig2_spont = mse1_sig2([1:305, 500:610], :, :);
    mse1_sig3_spont = mse1_sig3([1:305, 500:610], :, :);
    mse2_sig1_spont = mse2_sig1([1:305, 500:610], :, :);
    mse2_sig2_spont = mse2_sig2([1:305, 500:610], :, :);
    mse2_sig3_spont = mse2_sig3([1:305, 500:610], :, :);
    mse2_sig4_spont = mse2_sig4([1:305, 500:610], :, :);

    mse1_spont = cat(3, mse1_sig1_spont, mse1_sig2_spont);
    mse1_spont = cat(3, mse1_spont, mse1_sig3_spont);
    mse2_spont = cat(3, mse2_sig1_spont, mse2_sig2_spont);
    mse2_spont = cat(3, mse2_spont, mse2_sig3_spont);
    mse2_spont = cat(3, mse2_spont, mse2_sig4_spont);

    clear mse1_sig1_spont mse1_sig2_spont mse1_sig3_spont mse2_sig1_spont mse2_sig2_spont mse2_sig3_spont mse2_sig4_spont


    [spontevents_m1, sponteventrate_m1] = getspont(mse1_spont, 30, 9);
    [spontevents_m2, sponteventrate_m2] = getspont(mse2_spont, 30, 9);

    mean(sponteventrate_m1, 'omitnan')
    std(sponteventrate_m2, 'omitnan')


    mean(sponteventrate_m2, 'omitnan')
    std(sponteventrate_m2, 'omitnan')


    % Normalize each trace to pre-stimulus baseline
    mse1_sig1 = normtrace(mse1_sig1);
    mse1_sig2 = normtrace(mse1_sig2);
    mse1_sig3 = normtrace(mse1_sig3);
    mse2_sig1 = normtrace(mse2_sig1);
    mse2_sig2 = normtrace(mse2_sig2);
    mse2_sig3 = normtrace(mse2_sig3);
    mse2_sig4 = normtrace(mse2_sig4);

    cbdata = [];
    cbdata.spontevents_m1 = spontevents_m1;
    cbdata.spontevents_m2 = spontevents_m2;
    cbdata.sponteventrate_m1 = sponteventrate_m1;
    cbdata.sponteventrate_m2 = sponteventrate_m2;
    cbdata.mse1_sig1 = mse1_sig1;
    cbdata.mse1_sig2 = mse1_sig2;
    cbdata.mse1_sig3 = mse1_sig3;
    cbdata.mse2_sig1 = mse2_sig1;
    cbdata.mse2_sig2 = mse2_sig2;
    cbdata.mse2_sig3 = mse2_sig3;
    cbdata.mse2_sig4 = mse2_sig4;

end

function signal = createSignalMatrix(allTrials)
    % Convert cell array to 3D matrix if there is data
    if ~isempty(allTrials)
        [nFrames, nCells] = size(allTrials{1});
        nTrials = length(allTrials);
        
        signal = NaN(nFrames, nCells, nTrials);
        
        for t = 1:nTrials
            if size(allTrials{t}, 1) == nFrames && size(allTrials{t}, 2) == nCells
                signal(:,:,t) = allTrials{t};
            else
                error('Mismatch in dimensions of activs across trials.');
            end
        end
    else
        signal = []; % Return empty array if no data found
        warning('No valid "activs" data found.');
    end
end

function [smoothBC_signal]=BCandSmooth(signal, swindow)
    
    BC_signal=[];
    smoothBC_signal=[];
    for nfile=1:size(signal,3)
        %background correction
        bc_signal=FBackCorr(signal(:,:,nfile));
        BC_signal=cat(3,BC_signal,bc_signal);
        
        %smooth
        smoothbc_signal=arrayfun(@(x) smooth(bc_signal(:,x),swindow),1:size(bc_signal,2),'uni',0);
        smoothBC_signal=cat(3,smoothBC_signal,horzcat(smoothbc_signal{:}));
    end
end

function [corrF]=FBackCorr(F)
if length(size(F))==2
    pcr=prctile(F,20,1);
    corrF=(F-repmat(pcr,size(F,1),1))./pcr;
end
if length(size(F))==3
    pcr=prctile(F,20,3);
    corrF=(F-pcr)./pcr;
end
end

function signal = normtrace(signal)
[~, nCells, nTrials] = size(signal);

for i = 1:nCells
    for j = 1:nTrials
        temp = signal(:, i, j);

        getBL = mean(temp(305:310));
        signal(:, i, j) = temp - getBL;

    end
end

end

function [all_trialavg_events, all_trialavg_event_rate] = getspont(trace, window_size, event_window)
% all_trialavg_events: nFrames x nCells

% Preallocate list to store averaged event traces per neuron
all_trialavg_events = [];

% Preallocate list to store averaged event rate per neuron
all_trialavg_event_rate = [];

% Loop through all cells
for cellIdx = 1:size(trace, 2)
    neuron_events = []; % Collect all events across trials for this neuron
    neuron_event_rate = []; % Collect event rate across trials

    % Loop through all trials
    for trialIdx = 1:size(trace, 3)
        % Only include pre-stimulus period
        signal = squeeze(trace(:, cellIdx, trialIdx));
        
        % Compute first and second derivatives
        dF1 = [diff(signal); NaN];  % Pad with NaN to match signal length
        dF2 = [diff(dF1(1:end-1)); NaN; NaN];  % Pad with NaN to match signal length
        
        % Identify frames crossing derivative thresholds
        first_deriv_thresh = 0.04;
        second_deriv_thresh = 0.04;
        F1_idx = find(dF1(1:end-1) >= first_deriv_thresh); % First derivative threshold
        F2_idx = find(dF2 >= second_deriv_thresh); % Second derivative threshold
        
        % Find common threshold crossings within event_window
        event_cands = [];
        if length(F2_idx) > 1 && length(F1_idx) > 1
            for f = 1:length(F1_idx)
                gettemp = abs(F2_idx - F1_idx(f));
                if any(gettemp <= event_window)
                    event_cands = [event_cands; F1_idx(f)];
                end
            end
        end
        
        % Find peaks
        [pks, locs] = findpeaks(signal, 'MinPeakProminence', 0.1);
        
        % Select peaks occurring near event cands
        valid_events = [];
        for p = 1:length(locs)
            if any(abs(event_cands - locs(p)) <= event_window)
                valid_events = [valid_events; locs(p)];
            end
        end

        % Calculate event rate for this trial
        time_in_sec = length(signal)/30.98;
        rate_in_hz = length(valid_events)/time_in_sec;
        neuron_event_rate = cat(1, neuron_event_rate, rate_in_hz);
        
        % Determine event onsets for trace extraction
        event_onsets = [];
        for e = 1:length(valid_events)
            onset_idx = find(dF1(1:valid_events(e)) <= first_deriv_thresh, 1, 'last');
            if ~isempty(onset_idx)
                event_onsets = [event_onsets; onset_idx];
            end
        end
        
        % Extract event windows (traces) for this trial
        for e = 1:length(event_onsets)
            temp_onset = event_onsets(e) - (window_size/2);
            temp_offset = event_onsets(e) + window_size - 1;
            if temp_onset > 0 && temp_offset <= length(signal)
                getevent_window = signal(temp_onset:temp_offset);
                neuron_events = cat(2, neuron_events, getevent_window);
            end
        end
    end
    
    % Average events for this neuron (across all its trials)
    if ~isempty(neuron_events)
        avg_event = mean(neuron_events, 2, 'omitnan'); % Mean across events
        avg_event_rate = mean(neuron_event_rate, 'omitnan');
        all_trialavg_events = cat(2, all_trialavg_events, avg_event);
        all_trialavg_event_rate = cat(1, all_trialavg_event_rate, avg_event_rate);

    else
        NaNtrace = NaN(window_size*1.5, 1);
        all_trialavg_events = cat(2, all_trialavg_events, NaNtrace);
        all_trialavg_event_rate = cat(1, all_trialavg_event_rate, NaN);
    end
end

end
