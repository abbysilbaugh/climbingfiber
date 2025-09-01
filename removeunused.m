function allData = removeunused(allData)

nMice = length(allData.data);

fieldnames = fields(allData.data{1});

for i = 1:nMice
    tempsignal = allData.data{i}.golaysignal3;
    [nFrames, nCells, nTrials] = size(tempsignal);

    if nCells == nTrials
        warning('nCells = nTrials; Fix removeunused!')
    end

    tempsignal = squeeze(tempsignal(1, :, 1));
    nancells = isnan(tempsignal);
    if sum(nancells) > 0
        warning('NaN cell removed')

        for f = 1:length(fieldnames)
            FIELD = fieldnames{f};
            variable = allData.data{i}.(FIELD);
            sizevariable = size(variable);
            if length(sizevariable) == 2 && sizevariable(1) == nCells
                variable = variable(~nancells, :);
                allData.data{i}.(FIELD) = variable;
            elseif length(sizevariable) == 3
                variable = variable(:, ~nancells, :);
                allData.data{i}.(FIELD) = variable;
            end
            
        end
    end

    tempsignal = allData.data{i}.golaysignal3;
    tempsignal = squeeze(tempsignal(1, :, :));
    if sum(isnan(tempsignal), 'all') > 0
        warning('hi')
    end

    

end

end