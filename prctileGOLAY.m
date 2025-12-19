% Created 7/2/2023

function [signal,golaysignal] = prctileGOLAY(allData, artifact_win, b_percent)
% Original smoothBCsignal took 20th percentile on a per-trial basis
% Second calculation of smoothBCsignal takes 20th percentile across all trials

% This version is based on Helmchen 2019
    % 1st percentile
    % Smooths using Savitsky-Golay filter
    % Smooths before taking percentile!

% Frames that could contain an artifact will not be included in 20th
% percentile calculation, but are still normalized by it

% Prompts the user to select multiple files and find the peaks and amplitudes
% for each file and each trace in the data.
%
% "pk_thrs" specifies the threshold a trace needs to cross in order to be
% considered a peak. This parameter can be either a single threshold or a
% vector of thresholds -- a vector indicates iterating through different
% thresholds.


% Prompt the user to select multiple files
[fileNames, pathName] = uigetfile('*.mat', 'Select one or more files', 'MultiSelect', 'on');
if ~iscell(fileNames)
    fileNames = {fileNames};
end

% Preallocate output variables
nTrials = length(fileNames);
temporary = load(fullfile(pathName, fileNames{1}));

data = temporary.activs; % nFrames x nCells
nCells = size(data, 2);
nFrames = size(data, 1);

signal = zeros(nFrames, nCells, nTrials);
smoothsignal = zeros(nFrames, nCells, nTrials);

% Generate compiled signal variable by iterating through trials
for i = 1:nTrials
    temporary = load(fullfile(pathName, fileNames{i}));
    data = temporary.activs;
    nCells = size(data,2);
    
    % Store signal
    signal(:, :, i) = data;
    
    % Store smoothed signal
    for j = 1:nCells
        trace = data(:, j);
        
        % polynomial order of 1 and window of size 5
        golaytrace = sgolayfilt(trace, 1, 5);
        data(: , j) = golaytrace;
        
    end
    
    smoothsignal(:,:,i) = data;
    
end

% Concatenate all whisker frames
signal_whisker = smoothsignal(:, :, trialDataStruct.whisker);
nTrials_whisker = sum(trialDataStruct.whisker);
signal_whisker = permute(signal_whisker, [1 3 2]);
signal_whisker = reshape(signal_whisker, [nFrames*nTrials_whisker, nCells]);

% Get list of non-artifact frames
non_artifact_frames = true(nFrames, 1);
non_artifact_frames(artifact_win(1):artifact_win(2)) = false;

% Get list of opto and whiskerOpto trials
blue_light_trials = trialDataStruct.opto | trialDataStruct.whiskerOpto;
nTrials_bluelight = sum(blue_light_trials);
nFrames_bluelight = sum(non_artifact_frames);

if sum(nTrials_bluelight) == 0
    prc = prctile(signal_whisker, b_percent, 1);
else
    % Concatenate all opto and whiskerOpto frames
    signal_bluelight = smoothsignal(non_artifact_frames, :, blue_light_trials);
    signal_bluelight = permute(signal_bluelight, [1 3 2]);
    signal_bluelight = reshape(signal_bluelight, [nFrames_bluelight*nTrials_bluelight, nCells]);

    % Concatenate blue light trials and whisker trials
    signal_percentile_cat = vertcat(signal_whisker, signal_bluelight);

    prc = prctile(signal_percentile_cat, b_percent, 1);
end

golaysignal = smoothsignal;

    
% dF/F0 = (F-F0/F0)
for i = 1:nTrials
    
    % data is nFrames x nCells, prc is 1 x nCells
    data = golaysignal(:, :, i);
    
    data = (data - prc) ./ prc;
    
    %data = preprocess(data, prc);
    golaysignal(:, :, i) = data;
end

end



% function [data] = preprocess(data, prc)
%     % Background correction: Ting grabs the 20th percentile value of the
%     % data to normalize with
%     
%     data = (data - prc) ./ prc;
%     
% end
