% Sample data
nTrials = 90;
tetPeriod = allData.data{1}.tetPeriod;
abstime = allData.data{1}.abstime;

% Find the index of the first POST trial
firstPostIdx = find(strcmp(tetPeriod, 'POST'), 1);

% Extract the reference time
refTime = abstime(firstPostIdx, :);

% Convert abstime and refTime into minutes for easier calculation
abstimeInMins = abstime(:, 1)*60 + abstime(:, 2) + abstime(:, 3)/60;
refTimeInMins = refTime(1)*60 + refTime(2) + refTime(3)/60;

% Compute the difference in minutes
relativeTime = abstimeInMins - refTimeInMins;

% Mask TET trials
relativeTime(strcmp(tetPeriod, 'TET')) = NaN;

% Display the relative time
disp(relativeTime);
