% EDITED 20240121

% Sample data
function [reltime] = findreltime(tetPeriod, abstime)

% Find the index of the first POST trial
firstPostIdx = find(strcmp(tetPeriod, 'POST'), 1);

% Extract the reference time
refTime = abstime(firstPostIdx, :);

% Convert abstime and refTime into minutes for easier calculation
abstimeInMins = abstime(:, 1)*60 + abstime(:, 2) + abstime(:, 3)/60;

if isempty(firstPostIdx) % ADDED SO EXPERIMENTS WITHOUT TET CAN BE INCLUDED
    refTimeInMins = NaN;
else
    refTimeInMins = refTime(1)*60 + refTime(2) + refTime(3)/60;
end

% Compute the difference in minutes
reltime = abstimeInMins - refTimeInMins;

% Mask TET trials
reltime(strcmp(tetPeriod, 'TET')) = NaN;

end
