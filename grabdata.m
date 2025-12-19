function [getvar, vartype] = grabdata(allData, cellType, cellmotType, trialType, trialmotType, tetPeriod, dczPeriod, variable, exclude)

% This function simply indexes into variables. Data may not exist for each condition.
% Could also make function that turns unwanted conditions to NaNs/empty...?
% vartypes outputs are...
% nCells x 1
    % cellxmot, modulationidx
% nTrials x 1
    % motdif, mean_num_mot, reltime
% nCells x nTrials
    % b_oasis, smin_oasis, sn_oasis
    % spont_rate, spont_rate_running, spont_rate_rest, mean_fluo_running, mean_fluo_rest
    % mean_fluo_in_win, firstspike, firstpeaktime, firstpeakamp, firstpeakwidth, firstpeakprom
% nFrames x nCells x nTrials
    % golayshift
% nFrames x nTrials
    % motionInfo, rest, running

nMice = size(allData.data, 2);
getvar = cell(nMice, 1);

for i = 1:nMice
    [nFrames, nCells, nTrials] = size(allData.data{i}.golayshift);
    temp_cellType = allData.data{i}.cellType; 
    temp_cellmotType = allData.data{i}.cellmotType;
    temp_trialType = allData.data{i}.trialType;
    temp_trialmotType = allData.data{i}.trialmotType;
    temp_tetPeriod = allData.data{i}.tetPeriod;
    temp_variable = allData.data{i}.(variable);
    temp_dczPeriod = allData.data{i}.dczPeriod;


    getsize = size(temp_variable);
    gettype = class(temp_variable);
    vartype = cell(1, 2);

    if iscell(temp_variable)
        temp_variable = cell2mat(temp_variable);
    end


    if exclude
        % If variable is nCells x 1
        temp_reject = logical(allData.data{i}.reject);
        temp_reject_cells = logical(allData.data{i}.reject_cells);
        if getsize(1) == nCells && getsize(2) == 1
            temp_variable(temp_reject_cells) = NaN;
        % If variable is nCells x nTrials
        elseif getsize(1) == nCells && getsize(2) == nTrials
            temp_variable(temp_reject) = NaN;
        % If variable is nFrames x nCells x nTrials
        elseif getsize(1) == nFrames && getsize(2) == nCells && getsize(3) == nTrials
            temp_variable(:, temp_reject) = NaN;      
        end
    end







    if strcmp(cellType, 'all')
        cID1 = ones(nCells, 1);
    else
        cID1 = strcmp(temp_cellType, cellType);
    end

    if strcmp(cellmotType, 'all')
        cID2 = ones(nCells, 1);
    else
        cID2 = strcmp(temp_cellmotType, cellmotType);
    end

    if strcmp(trialType, 'all')
        tID1 = ones(nTrials, 1);
    else
        tID1 = strcmp(temp_trialType, trialType);
    end

    if strcmp(trialmotType, 'all')
        tID2 = ones(nTrials, 1);
    else
        tID2 = strcmp(temp_trialmotType, trialmotType);
    end

    if strcmp(tetPeriod, 'all')
        tID3 = ones(nTrials, 1);
    else
        tID3 = strcmp(temp_tetPeriod, tetPeriod);
    end

    tID4 = strcmp(temp_dczPeriod, dczPeriod);

    cellID = cID1 & cID2;
    trialID = tID1 & tID2 & tID3 & tID4;

   

    % If variable is nCells x 1
    if getsize(1) == nCells && getsize(2) == 1
        getvar{i} = temp_variable(cellID);

        if strcmp(gettype, 'cell')
            vartype{1} = 'nCells x 1'; vartype{2} = 'cell';
        elseif strcmp(gettype, 'double')
            vartype{1} = 'nCells x 1'; vartype{2} = 'double';
        end
 
    % If variable is nCells x nTrials
    elseif getsize(1) == nCells && getsize(2) == nTrials
        getvar{i} = temp_variable(cellID, trialID);

        if strcmp(gettype, 'cell')
            vartype{1} = 'nCells x nTrials'; vartype{2} = 'cell';
        elseif strcmp(gettype, 'double')
            vartype{1} = 'nCells x nTrials'; vartype{2} = 'double';
        end

    % If variable is nTrials x 1
    elseif getsize(1) == nTrials && getsize(2) == 1
        getvar{i} = temp_variable(trialID);

        if strcmp(gettype, 'cell')
            vartype{1} = 'nTrials x 1'; vartype{2} = 'cell';
        elseif strcmp(gettype, 'double')
            vartype{1} = 'nTrials x 1'; vartype{2} = 'double';
        end

    % If variable is nFrames x nCells x nTrials
    elseif getsize(1) == nFrames && getsize(2) == nCells && getsize(3) == nTrials
        getvar{i} = temp_variable(:, cellID, trialID);

        if strcmp(gettype, 'cell')
            vartype{1} = 'nFrames x nCells x nTrials'; vartype{2} = 'cell';
        elseif strcmp(gettype, 'double')
            vartype{1} = 'nFrames x nCells x nTrials'; vartype{2} = 'double';
        end

    % If variable is nFrames x nTrials 
    elseif getsize(1) == nFrames && getsize(2) == nTrials
        getvar{i} = temp_variable(:, trialID);

        if strcmp(gettype, 'cell')
            vartype{1} = 'nFrames x nTrials'; vartype{2} = 'cell';
        elseif strcmp(gettype, 'double')
            vartype{1} = 'nFrames x nTrials'; vartype{2} = 'double';
        end
    end

end