% Loads files and compiles data in allData struct (contains allData.data and allData.mouseIDs)
% Adds to allData.data{mouse}...
    % experimentType        ('whiskerOptoTet' or 'whiskerTet' or 'optoTet' or 'whiskerOptoTet_DREADD' or 'whiskerTet_DREADD' or 'noTet' or 'Threshold' or 'control_DREADD' or 'whiskerOptoTet_JAWS' or 'whiskerTet_JAWS' or 'control_JAWS' or 'ZI' or 'control')
    % mouseType             ('VIPCre', 'SSTCre', 'PVCre', 'L7Cre')
    % dreaddExpt            (true or false)
    % artifactframes        (empty, one or two integers)
    % ROIcoords             (nCells x 1)

    % cellType              (nCells x 1)

    % trialType             (nTrials x 1)
    % tetPeriod             (nTrials x 1)
    % dczPeriod             (nTrials x 1)
    % reltime               (nTrials x 1)

    % motionInfo            (nFrames x nTrials)
    % artifactFrames        (nFrames x nTrials)
    % baselinesignal        (nFrames x nTrials)

    % raw_signal            (nFrames x nCells x nTrials)

function allData = compileDataset
% Requires _neuroninfo, trialinfo, _percentilevalues, motion_confound, signal, firstprctile, artifact_fames, RoiSet, and abstime information to be stored in separate files under each experiment

% Root directory where each mouse folder is located
rootDir = strcat(pwd(),'\20230516_analysis'); 

% Get a list of all files and folders in this folder
allFiles = dir(rootDir);

% Get a logical vector that tells which is a directory
dirFlags = [allFiles.isdir];

% Extract only those that are directories
subFolders = allFiles(dirFlags);

% Create an empty struct to store data
allData = struct;
allData.mouseIDs = cell(length(subFolders),1);
allData.data = cell(length(subFolders),1);

% Loop over the folders
for k = 1 : length(subFolders)
    % Ignore '.' and '..' directories
    if strcmp(subFolders(k).name, '.') || strcmp(subFolders(k).name, '..') ...
            || strcmp(subFolders(k).name, 'figs')
        continue
    end
    
    % Determine experiment type
    if contains(subFolders(k).name, 'WhiskerOpto Tet') && ~contains(subFolders(k).name, 'DREADD') && ~contains(subFolders(k).name, 'JAWS') && ~contains(subFolders(k).name, 'ZI')
        expType = 'whiskerOptoTet';
    elseif contains(subFolders(k).name, 'Opto Tet') && ~contains(subFolders(k).name, 'DREADD') && ~contains(subFolders(k).name, 'JAWS') && ~contains(subFolders(k).name, 'ZI')
        expType = 'optoTet';
    elseif contains(subFolders(k).name, 'Whisker Tet') && ~contains(subFolders(k).name, 'DREADD') && ~contains(subFolders(k).name, 'JAWS') && ~contains(subFolders(k).name, 'ZI')
        expType = 'whiskerTet';
    elseif contains(subFolders(k).name, 'Thresh') && ~contains(subFolders(k).name, 'DREADD') && ~contains(subFolders(k).name, 'JAWS')
        expType = 'Threshold';
    elseif contains(subFolders(k).name, 'WhiskerOpto Tet') && contains(subFolders(k).name, 'DREADD') && ~contains(subFolders(k).name, 'ZI')
        expType = 'whiskerOptoTet_DREADD';
    elseif contains(subFolders(k).name, 'Whisker Tet') && contains(subFolders(k).name, 'DREADD') && ~contains(subFolders(k).name, 'ZI')
        expType = 'whiskerTet_DREADD';
    elseif ~contains(subFolders(k).name, 'Whisker Tet') && ~contains(subFolders(k).name, 'WhiskerOpto Tet') && contains(subFolders(k).name, 'DREADD')  && ~contains(subFolders(k).name, 'ZI')
        expType = 'control_DREADD';
    elseif contains(subFolders(k).name, 'WhiskerOpto Tet') && contains(subFolders(k).name, 'JAWS')
        expType = 'whiskerOptoTet_JAWS';
    elseif contains(subFolders(k).name, 'Whisker Tet') && contains(subFolders(k).name, 'JAWS')
        expType = 'whiskerTet_JAWS';
    elseif ~contains(subFolders(k).name, 'Whisker Tet') && ~contains(subFolders(k).name, 'WhiskerOpto Tet') && contains(subFolders(k).name, 'JAWS')
        expType = 'control_JAWS';
    elseif contains(subFolders(k).name, 'ZI')
        expType = 'ZI';
    elseif ~contains(subFolders(k).name, 'Whisker Tet') && ~contains(subFolders(k).name, 'WhiskerOpto Tet') && ~contains(subFolders(k).name, 'JAWS') && ~contains(subFolders(k).name, 'DREADD')
        expType = 'control';
    end

    % Determine whether DREADD experiment
    if contains(subFolders(k).name, 'DREADD')
        dreaddExpt = true;
    else
        dreaddExpt = false;
    end

    % Determine mouse type
    if contains(subFolders(k).name, 'PVCre')
        mouseType = 'PVCre';
    elseif contains(subFolders(k).name, 'VIPCre')
        mouseType = 'VIPCre';
    elseif contains(subFolders(k).name, 'SSTCre')
        mouseType = 'SSTCre';
    elseif contains(subFolders(k).name, 'L7Cre')
        mouseType = 'L7Cre';
    end
    
    % Get full file names
    neuronFile = dir(fullfile(rootDir, subFolders(k).name, '*_neuroninfo.mat'));
    trialFile = dir(fullfile(rootDir, subFolders(k).name, '*trialinfo.mat'));
    motionFile = dir(fullfile(rootDir, subFolders(k).name, '*_motion_confound.mat'));
    abstimeFile = dir(fullfile(rootDir, subFolders(k).name, '*_abstime.mat'));
    signalFile = dir(fullfile(rootDir, subFolders(k).name, '*_signal.mat'));
    firstprctileFile = dir(fullfile(rootDir, subFolders(k).name, '*_firstprctile.mat'));
    artifactFile = dir(fullfile(rootDir, subFolders(k).name, '*_artifactframes.mat'));
    baselineFile = dir(fullfile(rootDir, subFolders(k).name, '*_percentilevalues.mat'));
    ROIcoords = dir(fullfile(rootDir, subFolders(k).name, '*RoiSet.zip'));

    % Get ROI coordinates
    ROIPath = [ROIcoords.folder, '\'];
    ROIName = ROIcoords.name;
    roi_list = ReadImageJROI([ROIPath,ROIName]);
    ROIcoordinates = getedgecoords(roi_list);
    
    if strcmp(expType, 'Threshold')
        threshTrialFile = dir(fullfile(rootDir, subFolders(k).name, '*_PSItrialinfo.mat'));  % added 02/11/24
    end

    % Load the .mat files
    load(fullfile(rootDir, subFolders(k).name, neuronFile.name));
    load(fullfile(rootDir, subFolders(k).name, trialFile.name));
    motionData = load(fullfile(rootDir, subFolders(k).name, motionFile.name));
    load(fullfile(rootDir, subFolders(k).name, abstimeFile.name));
    load(fullfile(rootDir, subFolders(k).name, signalFile.name));
    load(fullfile(rootDir, subFolders(k).name, firstprctileFile.name));
    load(fullfile(rootDir, subFolders(k).name, artifactFile.name));
    load(fullfile(rootDir, subFolders(k).name, baselineFile.name));
    
    if strcmp(expType, 'Threshold')
        load(fullfile(rootDir, subFolders(k).name, threshTrialFile.name));
    end

    
    % Store data in the struct, using the folder name (mouse ID) as a field name
    mouseID = ['Mouse_' strrep(subFolders(k).name, ' ', '_')];  % Replace spaces with underscores for valid field names
    allData.mouseIDs{k} = mouseID;
    allData.data{k} = struct;
    allData.data{k}.experimentType = expType;
    allData.data{k}.mouseType = mouseType;
    % allData.data{k}.firstprctilevalue = FIRSTPRCTILEVALUE;
    allData.data{k}.dreaddExpt = dreaddExpt;
    allData.data{k}.ROIcoords = ROIcoordinates';

    % Store cell type info
    Ipn = neuronDataStruct.PN; % nNeurons x 1 logical;
    Iuc = neuronDataStruct.unclassifiedNeuron; % nNeurons x 1 logical
    
    cellType = cell(length(Ipn),1);
    cellType = fillCA(cellType, Ipn, 'PN');
    cellType = fillCA(cellType, Iuc, 'UC');

    if isfield(neuronDataStruct, 'PV')
        Ipv = neuronDataStruct.PV;
        cellType = fillCA(cellType, Ipv, 'PV');
    end

    if isfield(neuronDataStruct, 'VIP')
        Ivip = neuronDataStruct.VIP;
        cellType = fillCA(cellType, Ivip, 'VIP');
    end

    if isfield(neuronDataStruct, 'PC')
        Ipc = neuronDataStruct.PC;
        Ipc_group = neuronDataStruct.PC_group;
        cellType = fillCA(cellType, Ipc, 'PC');
        cellType = fillCA(cellType, Ipc_group, 'PC_group');
    end

    if isfield(neuronDataStruct, 'SST')
        Isst = neuronDataStruct.SST;
        cellType = fillCA(cellType, Isst, 'SST');
    end

    allData.data{k}.cellType = cellType;

    % Store trial type info
    Iw = trialDataStruct.whisker; % nTrials x 1 logical
    Io = trialDataStruct.opto; % nTrials x 1 logical
    Iwo = trialDataStruct.whiskerOpto; % nTrials x 1 logical
    trialType = cell(length(Iw),1);
    trialType = fillCA(trialType,Iw,'W');
    trialType = fillCA(trialType,Io,'O');
    trialType = fillCA(trialType,Iwo,'WO');
    allData.data{k}.trialType = trialType;

    % Store trial type info for Threshold experiments
    if strcmp(expType, 'Threshold')
        I_PSI_4 = PSItrialDataStruct.PSI_4; % nTrials x 1 logical
        I_PSI_6 = PSItrialDataStruct.PSI_6; % nTrials x 1 logical
        I_PSI_8 = PSItrialDataStruct.PSI_8; % nTrials x 1 logical
        I_PSI_10 = PSItrialDataStruct.PSI_10; % nTrials x 1 logical
        I_PSI_12 = PSItrialDataStruct.PSI_12; % nTrials x 1 logical
        PSItrialType = cell(length(I_PSI_4),1);
        PSItrialType = fillCA(PSItrialType,I_PSI_4,'PSI_4');
        PSItrialType = fillCA(PSItrialType,I_PSI_6,'PSI_6');
        PSItrialType = fillCA(PSItrialType,I_PSI_8,'PSI_8');
        PSItrialType = fillCA(PSItrialType,I_PSI_10,'PSI_10');
        PSItrialType = fillCA(PSItrialType,I_PSI_12,'PSI_12');
        allData.data{k}.PSItrialType = PSItrialType;
    end

    % Store tet period
    Itet = trialDataStruct.tet; % nTrials x 1 logical
    Ipost = trialDataStruct.postTetTrial; % nTrials x 1 logical
    Ipre = ~xor(Itet,Ipost);
    tetPeriod = cell(length(Ipre),1);
    tetPeriod = fillCA(tetPeriod,Ipre,'PRE');
    tetPeriod = fillCA(tetPeriod,Itet,'TET');
    tetPeriod = fillCA(tetPeriod,Ipost,'POST');
    allData.data{k}.tetPeriod = tetPeriod;

    % Store DCZ periods
    if dreaddExpt
        Idcz = trialDataStruct.postDCZTrial; % nTrials x 1 logical
        Ipre_dcz = ~Idcz;
        dczPeriod = cell(length(Ipre_dcz),1);
        dczPeriod = fillCA(dczPeriod,Ipre_dcz,'NO DCZ');
        dczPeriod = fillCA(dczPeriod,Idcz,'DCZ');
        allData.data{k}.dczPeriod = dczPeriod;
    else
        dczPeriod = cell(length(Ipre),1);
        set_dcz = ones(length(Ipre), 1);
        dczPeriod = fillCA(dczPeriod, set_dcz, 'NO DCZ');
        allData.data{k}.dczPeriod = dczPeriod;
    end


    % Store relative time info
    allData.data{k}.reltime = findreltime(tetPeriod, absolutetime);

    % Store motion info
    allData.data{k}.motionInfo = motionData.motionData; % nFrames x nTrials double

    % Store artifact frames
    allData.data{k}.artifactframes = artifactframes;


    % Store signal info
        % allData.data{k}.ACsignal = ACimage_signal; % nFrames x nNeurons x nTrials double
    allData.data{k}.raw_signal = signal; % nFrames x nNeurons x nTrials double
        % allData.data{k}.rawminusfirstprctile = signal - % FIRSTPRCTILEVALUE;
    allData.data{k}.baseline_signal = percentileValues;


    % Remove empty cells in cell array
    Irm = cellfun('isempty',allData.mouseIDs);
    allData.mouseIDs(Irm) = [];
    allData.data(Irm) = [];

end
end



function listID = fillCA(listID, boolvec, ID)
for i = 1:length(boolvec)
    if boolvec(i) == 1
        listID{i} = ID;
    end
end
end