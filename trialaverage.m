function [avgvar, semvar, avgvartype] = trialaverage(getvar, vartype)

% inputs:
% nCells x nTrials
% nFrames x nCells x nTrials
% nFrames x nTrials

% outputs:
% nFrames x nCells
% nCells x 1
% nFrames x 1

nMice = length(getvar);
avgvar = cell(nMice, 1);
semvar = cell(nMice, 1);
avgvartype = cell(1, 2);

for i = 1:nMice

    currvar = getvar{i};

    if strcmp(vartype, 'cell')
        currvar = cell2mat(currvar);
    end

    if strcmp(vartype{1}, 'nCells x 1') || strcmp(vartype{1}, 'nTrials x 1')
        warning('Use a different vartype')
    
    elseif strcmp(vartype{1}, 'nCells x nTrials')
        nTrials = size(currvar, 2);
        [stdev, avg] = std(currvar, 0, 2, 'omitnan');
        avgvar{i} = avg;
        semvar{i} = stdev/sqrt(nTrials);
        avgvartype{1} = 'nCells x 1'; vartype{2} = 'double';
        
    elseif strcmp(vartype{1}, 'nFrames x nCells x nTrials')
        nTrials = size(currvar, 3);
        [stdev, avg] = std(currvar, 0, 3, 'omitnan');
        avgvar{i} = avg;
        semvar{i} = stdev/sqrt(nTrials);
        avgvartype{1} = 'nFrames x nCells'; vartype{2} = 'double';

     elseif strcmp(vartype{1}, 'nFrames x nTrials')
         nTrials = size(currvar, 2);
         [stdev, avg] = std(currvar, 0, 2, 'omitnan');
         avgvar{i} = avg;
         semvar{i} = stdev/sqrt(nTrials);
         avgvartype{1} = 'nFrames x 1'; vartype{2} = 'double';
    end

end

end