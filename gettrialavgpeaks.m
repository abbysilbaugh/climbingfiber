% edited 3/1/24

function [allData] = gettrialavgpeaks(allData, peaks_thr, baselineNoise, gettrial, gettet, getexptype, getdcz)

nMice = size(allData.data, 2);

for i = 1:nMice
    nCells = length(allData.data{i}.cellType);
    exptype = allData.data{i}.experimentType;
        if strcmp(exptype, getexptype) || strcmp(getexptype, 'all')
            golayshift = allData.data{i}.golayshift;
            trialtype = allData.data{i}.trialType;
            tettype = allData.data{i}.tetPeriod;
            dcztype = allData.data{i}.dczPeriod;
            get_trials = strcmp(trialtype, gettrial) & strcmp(tettype, gettet) & strcmp(dcztype, getdcz);
            get_trials = logical(get_trials);
        
            [~, nCells, ~] = size(golayshift);
            
            avgamps = cell(nCells, 1);
            avgpkLocs = cell(nCells, 1);
            avgprom = cell(nCells, 1);
            avgwidth = cell(nCells, 1);
        
            for j = 1:nCells
                bNoise = baselineNoise{i}{j};
                avgtrace = squeeze(golayshift(:, j, get_trials)); avgtrace = mean(avgtrace, 2);
                [avgamps{j}, avgpkLocs{j}, avgwidth{j}, avgprom{j}] = findpeaks(avgtrace, 'MinPeakProminence', peaks_thr*bNoise);
        
            end
        
            allData.data{i}.avgpkamps = avgamps;
            allData.data{i}.avgpkLocs = avgpkLocs;
        else
            allData.data{i}.avgpkamps = [];
            allData.data{i}.avgpkLocs = [];
        end

end