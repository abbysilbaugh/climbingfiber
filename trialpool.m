function [poolvar, poolvartype] = trialpool(getvar, vartype)

% inputs: 
% nCells x nTrials
% nFrames x nCells x nTrials

% outputs:
% nObservations x 1
% nFrames x nObservations

nMice = length(getvar);
poolvar = cell(nMice, 1);
poolvartype = cell(1, 2);

for i = 1:nMice

    currvar = getvar{i};

    if strcmp(vartype, 'cell')
        currvar = cell2mat(currvar);
    end

    if strcmp(vartype{1}, 'nCells x nTrials')
        poolvar{i} = reshape(currvar,[],1);
        poolvartype{1} = 'nObservations x 1'; poolvartype{2} = 'double';

    elseif strcmp(vartype{1}, 'nFrames x nCells x nTrials')
        nFrames = size(currvar,1);
        poolvar{i} = reshape(currvar,nFrames,[]);
        poolvartype{1} = 'nFrames x nObservations'; poolvartype{2} = 'double';
    else
        warning('Use different variable type')
    end

end

end