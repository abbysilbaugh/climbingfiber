function visualizetrialavgpeaks(allData, baselineNoise, celltype, responsivewindow)

nMice = length(allData.data);
nFrames = size(allData.data{1}.ac_bs_signal, 1);
nBins = nFrames;

if strcmp(celltype, 'all') || strcmp(celltype, 'UC')
    color = 'k';
elseif strcmp(celltype, 'PV')
    color = '#bb2525';
elseif strcmp(celltype, 'PN')
    color = '#224baa';
elseif strcmp(celltype, 'VIP')
    color = '#0a8a23';
elseif strcmp(celltype, 'SST')
    color = '#633f73';
end

figure('Position', [50 50 1500 800])
subplot(4, 1, 1)
% Plot all W pre responses
[allData] = gettrialavgpeaks(allData, 2, baselineNoise, 'W', 'PRE', 'all', 'NO DCZ');
allmicehist_pks = zeros(nBins, nMice);
numcells = 0;
numresponsivecells = 0;
for i = 1:nMice
    avgpkLocs = allData.data{i}.avgpkLocs;
    if isempty(avgpkLocs)
        allmicehist_pks(:, i) = NaN;
    else
        if strcmp(celltype, 'all')
            avgpkLocs = allData.data{i}.avgpkLocs;
        else
            cellinfo = allData.data{i}.cellType;
            getcells = strcmp(cellinfo, celltype);
            avgpkLocs = allData.data{i}.avgpkLocs(getcells);
        end
        
        numcells = numcells + length(avgpkLocs);
        for c = 1:length(avgpkLocs)
            if length(avgpkLocs{c}) > 1
                temp = avgpkLocs{c};
                temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
                if length(temp) >= 1
                    numresponsivecells = numresponsivecells +1;
                end
            end
        end

        avgpkvec = avgpkLocs(:); avgpkvec = cell2mat(avgpkvec); 
        [h, binedges] = histcounts(avgpkvec, nBins);
        allmicehist_pks(:, i) = h;
    end
end

keepmice = allmicehist_pks(1, :); keepmice = sum(~isnan(keepmice));
allmicehist_pks = sum(allmicehist_pks, 2, 'omitnan')/keepmice;
histogram('BinEdges', binedges, 'BinCounts', allmicehist_pks, 'FaceAlpha', 0.5, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none')
ylabel('Probability', 'FontSize', 12)
x = linspace(0, 620, 11);
xlim([0 620])
xticks(x)
x2 = linspace(-10, 10, 11);
xticklabels(x2)
xlabel('Time from Stimulus Onset (s)')
title(['Average Event Probability (n responsive cells = ', num2str(numresponsivecells), '/', num2str(numcells), ')'])

subplot(4, 1, 2)
% Plot W Pre, WO Pre
mice = zeros(nMice, 1);
for i = 1:nMice
    trialType = allData.data{i}.trialType;
    WO_trials = strcmp(trialType, 'WO');
    if sum(WO_trials) > 1
        mice(i) = 1;
    end
end

mice = logical(mice);
temp = linspace(1, nMice, nMice);
mice = temp(mice);

[allData] = gettrialavgpeaks(allData, 2, baselineNoise, 'W', 'PRE', 'all', 'NO DCZ');
allmicehist_pks = zeros(nBins, nMice);
numcells_W = 0;
numresponsivecells_W = 0;
for i = mice
    avgpkLocs = allData.data{i}.avgpkLocs;
    if isempty(avgpkLocs)
        allmicehist_pks(:, i) = NaN;
    else
        if strcmp(celltype, 'all')
            avgpkLocs = allData.data{i}.avgpkLocs;
        else
            cellinfo = allData.data{i}.cellType;
            getcells = strcmp(cellinfo, celltype);
            avgpkLocs = allData.data{i}.avgpkLocs(getcells);
        end

        numcells_W = numcells_W + length(avgpkLocs);
        for c = 1:length(avgpkLocs)
            if length(avgpkLocs{c}) > 1
                temp = avgpkLocs{c};
                temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
                if length(temp) >= 1
                    numresponsivecells_W = numresponsivecells_W +1;
                end
            end
        end

        avgpkvec = avgpkLocs(:); avgpkvec = cell2mat(avgpkvec); 
        [h, ~] = histcounts(avgpkvec, binedges);
        allmicehist_pks(:, i) = h;
    end
end

keepmice = allmicehist_pks(1, :); keepmice = sum(~isnan(keepmice));
allmicehist_pks = sum(allmicehist_pks, 2, 'omitnan')/keepmice;
histogram('BinEdges', binedges, 'BinCounts', allmicehist_pks, 'FaceAlpha', 0.5, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none')
ylabel('Probability', 'FontSize', 12)
x = linspace(0, 620, 11);
xlim([0 620])
xticks(x)
x2 = linspace(-10, 10, 11);
xticklabels(x2)
xlabel('Time from Stimulus Onset (s)')

hold on
[allData] = gettrialavgpeaks(allData, 2, baselineNoise, 'WO', 'PRE', 'all', 'NO DCZ');
allmicehist_pks = zeros(nBins, nMice);
numcells_WO = 0;
numresponsivecells_WO = 0;
for i = mice
    avgpkLocs = allData.data{i}.avgpkLocs;
    if isempty(avgpkLocs)
        allmicehist_pks(:, i) = NaN;
    else
        if strcmp(celltype, 'all')
            avgpkLocs = allData.data{i}.avgpkLocs;
        else
            cellinfo = allData.data{i}.cellType;
            getcells = strcmp(cellinfo, celltype);
            avgpkLocs = allData.data{i}.avgpkLocs(getcells);
        end
        numcells_WO = numcells_WO + length(avgpkLocs);
        for c = 1:length(avgpkLocs)
            if length(avgpkLocs{c}) > 1
                temp = avgpkLocs{c};
                temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
                if length(temp) >= 1
                    numresponsivecells_WO = numresponsivecells_WO +1;
                end
            end
        end
        avgpkvec = avgpkLocs(:); avgpkvec = cell2mat(avgpkvec); 
        [h, ~] = histcounts(avgpkvec, binedges);
        allmicehist_pks(:, i) = h;
    end
end

keepmice = allmicehist_pks(1, :); keepmice = sum(~isnan(keepmice));
allmicehist_pks = sum(allmicehist_pks, 2, 'omitnan')/keepmice;
histogram('BinEdges', binedges, 'BinCounts', allmicehist_pks, 'FaceAlpha', 0.5, 'FaceColor', color, 'EdgeColor', 'none')
legend('W', 'W + CF', 'box', 'off')
title(['n W responsive cells = ', num2str(numresponsivecells_W), '/', num2str(numcells_W), ';', 'n WO reponsive cells = ', num2str(numresponsivecells_WO), '/', num2str(numcells_WO)])


subplot(4, 1, 3)
% Plot W Pre/W Post RWS
[allData] = gettrialavgpeaks(allData, 2, baselineNoise, 'W', 'PRE', 'whiskerTet', 'NO DCZ');
allmicehist_pks = zeros(nBins, nMice);
numcells_preRWS = 0;
numresponsivecells_preRWS = 0;
for i = 1:nMice
    avgpkLocs = allData.data{i}.avgpkLocs;
    if isempty(avgpkLocs)
        allmicehist_pks(:, i) = NaN;
    else
        if strcmp(celltype, 'all')
            avgpkLocs = allData.data{i}.avgpkLocs;
        else
            cellinfo = allData.data{i}.cellType;
            getcells = strcmp(cellinfo, celltype);
            avgpkLocs = allData.data{i}.avgpkLocs(getcells);
        end
        numcells_preRWS = numcells_preRWS + length(avgpkLocs);
        for c = 1:length(avgpkLocs)
            if length(avgpkLocs{c}) > 1
                temp = avgpkLocs{c};
                temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
                if length(temp) >= 1
                    numresponsivecells_preRWS = numresponsivecells_preRWS +1;
                end
            end
        end
        avgpkvec = avgpkLocs(:); avgpkvec = cell2mat(avgpkvec); 
        [h, ~] = histcounts(avgpkvec, binedges);
        allmicehist_pks(:, i) = h;
    end
end

keepmice = allmicehist_pks(1, :); keepmice = sum(~isnan(keepmice));
allmicehist_pks = sum(allmicehist_pks, 2, 'omitnan')/keepmice;
histogram('BinEdges', binedges, 'BinCounts', allmicehist_pks, 'FaceAlpha', 0.5, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none')
ylabel('Probability', 'FontSize', 12)
x = linspace(0, 620, 11);
xlim([0 620])
xticks(x)
x2 = linspace(-10, 10, 11);
xticklabels(x2)
xlabel('Time from Stimulus Onset (s)')

hold on
[allData] = gettrialavgpeaks(allData, 2, baselineNoise, 'W', 'POST', 'whiskerTet', 'NO DCZ');
allmicehist_pks = zeros(nBins, nMice);
numcells_postRWS = 0;
numresponsivecells_postRWS = 0;
for i = 1:nMice
    avgpkLocs = allData.data{i}.avgpkLocs;
    if isempty(avgpkLocs)
        allmicehist_pks(:, i) = NaN;
    else
        if strcmp(celltype, 'all')
            avgpkLocs = allData.data{i}.avgpkLocs;
        else
            cellinfo = allData.data{i}.cellType;
            getcells = strcmp(cellinfo, celltype);
            avgpkLocs = allData.data{i}.avgpkLocs(getcells);
        end

        numcells_postRWS = numcells_postRWS + length(avgpkLocs);
        for c = 1:length(avgpkLocs)
            if length(avgpkLocs{c}) > 1
                temp = avgpkLocs{c};
                temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
                if length(temp) >= 1
                    numresponsivecells_postRWS = numresponsivecells_postRWS +1;
                end
            end
        end

        avgpkvec = avgpkLocs(:); avgpkvec = cell2mat(avgpkvec); 
        [h, ~] = histcounts(avgpkvec, binedges);
        allmicehist_pks(:, i) = h;
    end
end

keepmice = allmicehist_pks(1, :); keepmice = sum(~isnan(keepmice));
allmicehist_pks = sum(allmicehist_pks, 2, 'omitnan')/keepmice;
histogram('BinEdges', binedges, 'BinCounts', allmicehist_pks, 'FaceAlpha', 0.5, 'FaceColor', color, 'EdgeColor', 'none')
legend('Pre RWS', 'Post RWS', 'box', 'off')
title(['n responsive cells (pre) = ', num2str(numresponsivecells_preRWS), '/', num2str(numcells_preRWS), ';', 'n reponsive cells (post) = ', num2str(numresponsivecells_postRWS), '/', num2str(numcells_postRWS)])

subplot(4, 1, 4)
% Plot W Pre/W Post RWSCF
[allData] = gettrialavgpeaks(allData, 2, baselineNoise, 'W', 'PRE', 'whiskerOptoTet', 'NO DCZ');
allmicehist_pks = zeros(nBins, nMice);
numcells_preRWSCF = 0;
numresponsivecells_preRWSCF = 0;
for i = 1:nMice
    avgpkLocs = allData.data{i}.avgpkLocs;
    if isempty(avgpkLocs)
        allmicehist_pks(:, i) = NaN;
    else
        if strcmp(celltype, 'all')
            avgpkLocs = allData.data{i}.avgpkLocs;
        else
            cellinfo = allData.data{i}.cellType;
            getcells = strcmp(cellinfo, celltype);
            avgpkLocs = allData.data{i}.avgpkLocs(getcells);
        end

        numcells_preRWSCF = numcells_preRWSCF + length(avgpkLocs);
        for c = 1:length(avgpkLocs)
            if length(avgpkLocs{c}) > 1
                temp = avgpkLocs{c};
                temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
                if length(temp) >= 1
                    numresponsivecells_preRWSCF = numresponsivecells_preRWSCF +1;
                end
            end
        end

        avgpkvec = avgpkLocs(:); avgpkvec = cell2mat(avgpkvec); 
        [h, ~] = histcounts(avgpkvec, binedges);
        allmicehist_pks(:, i) = h;
    end
end

keepmice = allmicehist_pks(1, :); keepmice = sum(~isnan(keepmice));
allmicehist_pks = sum(allmicehist_pks, 2, 'omitnan')/keepmice;
histogram('BinEdges', binedges, 'BinCounts', allmicehist_pks, 'FaceAlpha', 0.5, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none')
ylabel('Probability', 'FontSize', 12)
x = linspace(0, 620, 11);
xlim([0 620])
xticks(x)
x2 = linspace(-10, 10, 11);
xticklabels(x2)
xlabel('Time from Stimulus Onset (s)')

hold on
[allData] = gettrialavgpeaks(allData, 2, baselineNoise, 'W', 'POST', 'whiskerOptoTet', 'NO DCZ');
allmicehist_pks = zeros(nBins, nMice);
numcells_postRWSCF = 0;
numresponsivecells_postRWSCF = 0;
for i = 1:nMice
    avgpkLocs = allData.data{i}.avgpkLocs;
    if isempty(avgpkLocs)
        allmicehist_pks(:, i) = NaN;
    else
        if strcmp(celltype, 'all')
            avgpkLocs = allData.data{i}.avgpkLocs;
        else
            cellinfo = allData.data{i}.cellType;
            getcells = strcmp(cellinfo, celltype);
            avgpkLocs = allData.data{i}.avgpkLocs(getcells);
        end

         numcells_postRWSCF = numcells_postRWSCF + length(avgpkLocs);
        for c = 1:length(avgpkLocs)
            if length(avgpkLocs{c}) > 1
                temp = avgpkLocs{c};
                temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
                if length(temp) >= 1
                    numresponsivecells_postRWSCF = numresponsivecells_postRWSCF +1;
                end
            end
        end

        avgpkvec = avgpkLocs(:); avgpkvec = cell2mat(avgpkvec); 
        [h, ~] = histcounts(avgpkvec, binedges);
        allmicehist_pks(:, i) = h;
    end
end

keepmice = allmicehist_pks(1, :); keepmice = sum(~isnan(keepmice));
allmicehist_pks = sum(allmicehist_pks, 2, 'omitnan')/keepmice;
histogram('BinEdges', binedges, 'BinCounts', allmicehist_pks, 'FaceAlpha', 0.5, 'FaceColor', color, 'EdgeColor', 'none')
legend('Pre RWSCF', 'Post RWSCF', 'box', 'off')
title(['n responsive cells (pre) = ', num2str(numresponsivecells_preRWSCF), '/', num2str(numcells_preRWSCF), ';', 'n reponsive cells (post) = ', num2str(numresponsivecells_postRWSCF), '/', num2str(numcells_postRWSCF)])

end
