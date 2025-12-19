% adds to allData.data{mouse}...
    % rest (nFrames x nTrials)
    % running (nFrames x nTrials)

% Function notes:
    % Adds rest (nFrames x nTrials) and running (nFrames x nTrials) to allData
    % Finds periods of rest for the number of frames specified by restthresh
    % If a frame is contained in a period of rest, it receives a "1" in rest
    % The opposite of rest is running (running = ~rest)

function [allData] = getrest(allData, restthresh)

nMice = size(allData.data, 2); 

for i = 1:nMice
    motion = allData.data{i}.motionInfo;

    [nFrames, nTrials] = size(motion);

    % Initialize rest array
    rest = zeros(nFrames, nTrials);
    
    for trial = 1:nTrials
        frame = 1;
        while frame <= nFrames
            % Find the start of a rest period (restthresh or more zeros)
            if frame <= nFrames - (restthresh - 1) && all(motion(frame:frame+(restthresh-1), trial) == 0)
                % Mark the start of the rest period
                startOfRest = frame;
    
                % Find the end of the rest period
                while frame <= nFrames && motion(frame, trial) == 0
                    frame = frame + 1;
                end
                endOfRest = frame - 1;
    
                % Mark the rest period in the rest array
                rest(startOfRest:endOfRest, trial) = 1;
            else
                frame = frame + 1;
            end
        end
    end

    allData.data{i}.rest = rest;
    allData.data{i}.running = ~rest;

end

end

