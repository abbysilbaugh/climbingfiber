function [getvar] = grabdata(allData, cellType, cellmotType, trialType, trialmotType, tetPeriod, variable)

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

    cellID = cID1 & cID2;
    trialID = tID1 & tID2 & tID3;

    getsize = size(temp_variable);

    % If variable is nCells x 1
    if getsize(1) == nCells && getsize(2) == 1
        getvar{i} = temp_variable(cellID);
 
    % If variable is nCells x nTrials
    elseif getsize(1) == nCells && getsize(2) == nTrials
        getvar{i} = temp_variable(cellID, trialID);

    % If variable is nTrials x 1
    elseif getsize(1) == nTrials && getsize(2) == 1
        getvar{i} = temp_variable(trialID);

    % If variable is nFrames x nCells x nTrials
    elseif getsize(1) == nFrames && getsize(2) == nCells && getsize(3) == nTrials
        getvar{i} = temp_variable(:, cellID, trialID);
    end

end