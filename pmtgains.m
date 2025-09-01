% Define the main folder
mainFolder = 'C:\Users\silbaugh\Desktop\2P FOVs';

% Initialize arrays to store gains
pmt0_gains = [];
pmt1_gains = [];

% Recursively process all subfolders
processSubfolders(mainFolder);

% Function to process subfolders recursively
function processSubfolders(currentFolder)
    files = dir(fullfile(currentFolder, '*.mat')); % Find .mat files
    subfolders = dir(currentFolder); % Get all contents of the folder
    subfolders = subfolders([subfolders.isdir]); % Keep only directories
    
    % Iterate through all .mat files in the current folder
    for i = 1:length(files)
        matFilePath = fullfile(currentFolder, files(i).name);
        data = load(matFilePath, 'info'); % Load only the 'info' variable
        
        if isfield(data, 'info') && isfield(data.info, 'config')
            if isfield(data.info.config, 'pmt0_gain') && isfield(data.info.config, 'pmt1_gain')
                % Store the gain values
                assignin('base', 'pmt0_gains', [evalin('base', 'pmt0_gains'), data.info.config.pmt0_gain]);
                assignin('base', 'pmt1_gains', [evalin('base', 'pmt1_gains'), data.info.config.pmt1_gain]);
            end
        end
    end
    
    % Recursively process subfolders
    for j = 1:length(subfolders)
        subfolderName = subfolders(j).name;
        if ~ismember(subfolderName, {'.', '..'}) % Skip '.' and '..'
            processSubfolders(fullfile(currentFolder, subfolderName));
        end
    end
end
