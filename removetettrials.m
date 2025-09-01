% For ease of processing, remove trials collected during tetanization
% period from all relevant variables

function allData = removetettrials(allData)
nMice = length(allData.data);

fieldnames = fields(allData.data{1});

for i = 1:nMice
    raw_signal = allData.data{i}.raw_signal;
    [nFrames, nCells, nTrials] = size(raw_signal);
    if nCells == nTrials
        warning('nCells = nTrials; Fix removetettrials code!')
    end

    % Remove tettrials
    tettrial = allData.data{i}.tetPeriod;
    tettrial = logical(strcmp(tettrial, 'TET'));
    for f = 1:length(fieldnames)
        FIELD = fieldnames{f};
        variable = allData.data{i}.(FIELD);
        sizevariable = size(variable);
        if length(sizevariable) == 2 && sizevariable(1) == nTrials
            variable = variable(~tettrial);
            allData.data{i}.(FIELD) = variable;
        elseif length(sizevariable) == 2 && sizevariable(2) == nTrials
            variable = variable(:, ~tettrial);
            allData.data{i}.(FIELD) = variable;
        elseif length(sizevariable) == 3
            variable = variable(:, :, ~tettrial);
            allData.data{i}.(FIELD) = variable;
        end
        
    end

end
end