function [getvarcat, varcattype] = catmice(allData, getvar, vartype, expType)

% Valid may contain the following size...
% nCells x 1 (raw or output of trial avg)
% nTrials x 1 (raw)
% nFrames x nCells (output of trial avg)
% nCells x 1 (raw or output of trial avg)
% nFrames x 1 (output of trial avg)
% nObservations x 1 (nCells*nTrials x 1; output of trial pool)
% nFrames x nObservations (nFrames x nCells*nTrials; output of trial pool)

% inputs:
% nFrames x 1
% nFrames x nTrials
% nObservations x 1
% nCells x 1
% nTrials x 1
% nFrames x nCells
% nFrames x nObservations

% varcattype outputs are...
% nFrames x nMice
% nFrames x nTrials
% nObservations x 1
% nFrames x nObservations
% nCells x 1
% nTrials x 1
% nFrames x nCells
% nFrames x nObservations

getvarcat = [];
nMice = length(getvar);

mice = 1:nMice;

if strcmp(expType, 'all')
    getmice = ones(nMice, 1);
elseif strcmp(expType, 'whiskerOptoTet') || strcmp(expType, 'whiskerTet') || strcmp(expType, 'whiskerTet_DREADD') || strcmp(expType, 'whiskerOptoTet_DREADD')
    getmice = zeros(1,nMice);
    for i = 1:nMice
        experimentType = allData.data{i}.experimentType;
        if strcmp(expType, experimentType)
            getmice(i) = 1;
        end
    end
end

mice = mice(logical(getmice));


if strcmp(vartype{1}, 'nFrames x nCells x nTrials') || strcmp(vartype{1}, 'nCells x nTrials')
    warning('Too many mismatched dimensions. Must trial average or pool trials first.')
    
elseif strcmp(vartype{1}, 'nFrames x 1')
    for i = mice
        getvarcat = cat(2, getvarcat, getvar{i});
    end
    varcattype = 'nFrames x nMice';

elseif strcmp(vartype{1}, 'nFrames x nTrials')
    for i = mice
        getvarcat = cat(2, getvarcat, getvar{i});
    end
    varcattype = 'nFrames x nTrials';

elseif strcmp(vartype{1}, 'nObservations x 1')
    for i = mice
        getvarcat = cat(1, getvarcat, getvar{i});
    end
    varcattype = 'nObservations x 1';

elseif strcmp(vartype{1}, 'nCells x 1')
    for i = mice
        getvarcat = cat(1, getvarcat, getvar{i});
    end
    varcattype = 'nCells x 1';

elseif strcmp(vartype{1}, 'nTrials x 1')
    for i = mice
        getvarcat = cat(1, getvarcat, getvar{i});
    end
    varcattype = 'nTrials x 1';

elseif strcmp(vartype{1}, 'nFrames x nCells')
    for i = mice
        getvarcat = cat(2, getvarcat, getvar{i});
    end
    varcattype = 'nFrames x nCells';

elseif strcmp(vartype{1}, 'nFrames x nObservations')
    for i = mice
        getvarcat = cat(2, getvarcat, getvar{i});
    end
    varcattype = 'nFrames x nObservations';

end


end
