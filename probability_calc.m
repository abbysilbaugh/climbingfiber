function [prob] = probability_calc(allData, cellType, trialmotType, stimType, tetPeriod, expType)

% Uses exclusion criteria to determine if there was an event
% Therefore ensure exclusion critera make sense


% Grab non excluded data
[ALLdata, vartype] = grabdata(allData, cellType, 'all', stimType, trialmotType, tetPeriod,  'NO DCZ', 'mean_fluo_in_win', false);

% Grab excluded data
[EVOKEDdata, vartype] = grabdata(allData, cellType, 'all', stimType, trialmotType, tetPeriod,  'NO DCZ', 'mean_fluo_in_win', true);

nMice = length(ALLdata);

if strcmp(expType, 'all')
    prob = cell(nMice, 1);
    for i = 1:nMice
        temp_ALLdata = ALLdata{i};
        temp_EVOKEDdata = EVOKEDdata{i};

        temp = temp_EVOKEDdata./temp_ALLdata;

        [nCells, nTrials] = size(temp);
        store_neurondata = zeros(nCells, 1);
        for j = 1:nCells
            temp_cell = temp(j, :);
            event_trials = sum(~isnan(temp_cell));
            store_neurondata(j) = event_trials/nTrials;
        end

        prob{i} = store_neurondata;
    end



elseif strcmp(expType, 'whiskerOptoTet')
    mice = zeros(nMice, 1);
    for i = 1:nMice
        if strcmp('whiskerOptoTet', allData.data{i}.experimentType)
            mice(i) = 1;
        end
        mice = logical(mice);
    end

    ALLdata = ALLdata(mice);
    EVOKEDdata = EVOKEDdata(mice);
    exptMice = length(ALLdata);
    prob = cell(exptMice, 1);
    for i = 1:exptMice
        temp_ALLdata = ALLdata{i};
        temp_EVOKEDdata = EVOKEDdata{i};

        temp = temp_EVOKEDdata./temp_ALLdata;

        [nCells, nTrials] = size(temp);
        store_neurondata = zeros(nCells, 1);
        for j = 1:nCells
            temp_cell = temp(j, :);
            event_trials = sum(~isnan(temp_cell));
            store_neurondata(j) = event_trials/nTrials;
        end

        prob{i} = store_neurondata;
    end



elseif strcmp(expType, 'whiskerTet')
    mice = zeros(nMice, 1);
    for i = 1:nMice
        if strcmp('whiskerTet', allData.data{i}.experimentType)
            mice(i) = 1;
        end
        mice = logical(mice);
    end

    ALLdata = ALLdata(logical(mice));
    EVOKEDdata = EVOKEDdata(logical(mice));
    exptMice = length(ALLdata);
    prob = cell(exptMice, 1);
    for i = 1:exptMice
        temp_ALLdata = ALLdata{i};
        temp_EVOKEDdata = EVOKEDdata{i};

        temp = temp_EVOKEDdata./temp_ALLdata;

        [nCells, nTrials] = size(temp);
        store_neurondata = zeros(nCells, 1);
        for j = 1:nCells
            temp_cell = temp(j, :);
            event_trials = sum(~isnan(temp_cell));
            store_neurondata(j) = event_trials/nTrials;
        end

        prob{i} = store_neurondata;
    end

end


end