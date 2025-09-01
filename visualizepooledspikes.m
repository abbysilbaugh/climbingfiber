function visualizepooledspikes(allData, celltype, responsivewindow, motiontrial)

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
allmicehist_pks = zeros(nBins, nMice);
numcells = 0;
numresponsivecells = 0;
for i = 1:nMice
    tetPeriod = allData.data{i}.tetPeriod;
    trialType = allData.data{i}.trialType;
    dczPeriod = allData.data{i}.dczPeriod;
    motType = allData.data{i}.trialmotType;
    if strcmp(motiontrial, 'all')
        get_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
    else
        get_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motType, motiontrial);
    end
    spkLocs = allData.data{i}.spkLocs(:, get_trials);

    if strcmp(celltype, 'all')
        spkLocs = spkLocs;
    else
        cellinfo = allData.data{i}.cellType;
        getcells = strcmp(cellinfo, celltype);
        spkLocs = spkLocs(getcells, :);
    end
        
        numcells = numcells + size(spkLocs, 1);
        for c = 1:size(spkLocs, 1)
            temp = spkLocs(c, :); temp = temp(:); temp = cell2mat(temp);
            temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
            if length(temp) >= 1
                numresponsivecells = numresponsivecells +1;
            end
        end

        pkvec = spkLocs(:); pkvec = cell2mat(pkvec); pkvec = pkvec(~isnan(pkvec));
        [h, binedges] = histcounts(pkvec, nBins, 'Normalization', 'probability');
        allmicehist_pks(:, i) = h;
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
title(['Global Event Probability (n responsive cells = ', num2str(numresponsivecells), '/', num2str(numcells), ')'])

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

allmicehist_pks = zeros(nBins, nMice);
numcells_W = 0;
numresponsivecells_W = 0;
for i = mice
    tetPeriod = allData.data{i}.tetPeriod;
    trialType = allData.data{i}.trialType;
    dczPeriod = allData.data{i}.dczPeriod;
    motType = allData.data{i}.trialmotType;

    if strcmp(motiontrial, 'all')
        get_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
    else
        get_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motType, motiontrial);
    end
    spkLocs = allData.data{i}.spkLocs(:, get_trials);
    

    if strcmp(celltype, 'all')
        spkLocs = spkLocs;
    else
        cellinfo = allData.data{i}.cellType;
        getcells = strcmp(cellinfo, celltype);
        spkLocs = spkLocs(getcells, :);
    end
        
        numcells_W = numcells_W + size(spkLocs, 1);
        for c = 1:size(spkLocs, 1)
            temp = spkLocs(c, :); temp = temp(:); temp = cell2mat(temp);
            temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
            if length(temp) >= 1
                numresponsivecells_W = numresponsivecells_W +1;
            end
        end

        pkvec = spkLocs(:); pkvec = cell2mat(pkvec); pkvec = pkvec(~isnan(pkvec));
        [h, ~] = histcounts(pkvec, nBins, 'Normalization', 'probability');
        allmicehist_pks(:, i) = h;
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

allmicehist_pks = zeros(nBins, nMice);
numcells_WO = 0;
numresponsivecells_WO = 0;
for i = mice
    tetPeriod = allData.data{i}.tetPeriod;
    trialType = allData.data{i}.trialType;
    dczPeriod = allData.data{i}.dczPeriod;
    motType = allData.data{i}.trialmotType;
    if strcmp(motiontrial, 'all')
        get_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ');
    else
        get_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'WO') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motType, motiontrial);
    end
    spkLocs = allData.data{i}.spkLocs(:, get_trials);

    if strcmp(celltype, 'all')
        spkLocs = spkLocs;
    else
        cellinfo = allData.data{i}.cellType;
        getcells = strcmp(cellinfo, celltype);
        spkLocs = spkLocs(getcells, :);
    end
        
        numcells_WO = numcells_WO + size(spkLocs, 1);
        for c = 1:size(spkLocs, 1)
            temp = spkLocs(c, :); temp = temp(:); temp = cell2mat(temp);
            temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
            if length(temp) >= 1
                numresponsivecells_WO = numresponsivecells_WO +1;
            end
        end

        pkvec = spkLocs(:); pkvec = cell2mat(pkvec); pkvec = pkvec(~isnan(pkvec));
        [h, ~] = histcounts(pkvec, nBins,  'Normalization', 'probability');
        allmicehist_pks(:, i) = h;
end

keepmice = allmicehist_pks(1, :); keepmice = sum(~isnan(keepmice));
allmicehist_pks = sum(allmicehist_pks, 2, 'omitnan')/keepmice;
histogram('BinEdges', binedges, 'BinCounts', allmicehist_pks, 'FaceAlpha', 0.5, 'FaceColor', color, 'EdgeColor', 'none')
legend('W', 'W + CF', 'box', 'off')
title(['n W responsive cells = ', num2str(numresponsivecells_W), '/', num2str(numcells_W), ';', 'n WO reponsive cells = ', num2str(numresponsivecells_WO), '/', num2str(numcells_WO)])


subplot(4, 1, 3)
% Plot W Pre/W Post RWS

allmicehist_pks = zeros(nBins, nMice);
numcells_preRWS = 0;
numresponsivecells_preRWS = 0;

mice = zeros(nMice, 1);
for i = 1:nMice
    exptype = allData.data{i}.experimentType;
    if strcmp(exptype, 'whiskerTet')
        mice(i) = 1;
    end
end

mice = logical(mice);
temp = linspace(1, nMice, nMice);
mice = temp(mice);

for i = mice
    tetPeriod = allData.data{i}.tetPeriod;
    trialType = allData.data{i}.trialType;
    dczPeriod = allData.data{i}.dczPeriod;
    motType = allData.data{i}.trialmotType;
    if strcmp(motiontrial, 'all')
        get_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
    else
        get_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motType, motiontrial);
    end
    spkLocs = allData.data{i}.spkLocs(:, get_trials);

    if strcmp(celltype, 'all')
        spkLocs = spkLocs;
    else
        cellinfo = allData.data{i}.cellType;
        getcells = strcmp(cellinfo, celltype);
        spkLocs = spkLocs(getcells, :);
    end
        
        numcells_preRWS = numcells_preRWS + size(spkLocs, 1);
        for c = 1:size(spkLocs, 1)
            temp = spkLocs(c, :); temp = temp(:); temp = cell2mat(temp);
            temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
            if length(temp) >= 1
                numresponsivecells_preRWS = numresponsivecells_preRWS +1;
            end
        end

        pkvec = spkLocs(:); pkvec = cell2mat(pkvec); pkvec = pkvec(~isnan(pkvec));
        [h, ~] = histcounts(pkvec, nBins,  'Normalization', 'probability');
        allmicehist_pks(:, i) = h;
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

allmicehist_pks = zeros(nBins, nMice);
numcells_postRWS = 0;
numresponsivecells_postRWS = 0;
for i = mice
    tetPeriod = allData.data{i}.tetPeriod;
    trialType = allData.data{i}.trialType;
    dczPeriod = allData.data{i}.dczPeriod;
    motType = allData.data{i}.trialmotType;
    if strcmp(motiontrial, 'all')
        get_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
    else
        get_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motType, motiontrial);
    end
    spkLocs = allData.data{i}.spkLocs(:, get_trials);

    if strcmp(celltype, 'all')
        spkLocs = spkLocs;
    else
        cellinfo = allData.data{i}.cellType;
        getcells = strcmp(cellinfo, celltype);
        spkLocs = spkLocs(getcells, :);
    end
        
        numcells_postRWS = numcells_postRWS + size(spkLocs, 1);
        for c = 1:size(spkLocs, 1)
            temp = spkLocs(c, :); temp = temp(:); temp = cell2mat(temp);
            temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
            if length(temp) >= 1
                numresponsivecells_postRWS = numresponsivecells_postRWS +1;
            end
        end

        pkvec = spkLocs(:); pkvec = cell2mat(pkvec); pkvec = pkvec(~isnan(pkvec));
        [h, ~] = histcounts(pkvec, nBins,  'Normalization', 'probability');
        allmicehist_pks(:, i) = h;
end

keepmice = allmicehist_pks(1, :); keepmice = sum(~isnan(keepmice));
allmicehist_pks = sum(allmicehist_pks, 2, 'omitnan')/keepmice;
histogram('BinEdges', binedges, 'BinCounts', allmicehist_pks, 'FaceAlpha', 0.5, 'FaceColor', color, 'EdgeColor', 'none')
legend('Pre RWS', 'Post RWS', 'box', 'off')
title(['n responsive cells (pre) = ', num2str(numresponsivecells_preRWS), '/', num2str(numcells_preRWS), ';', 'n reponsive cells (post) = ', num2str(numresponsivecells_postRWS), '/', num2str(numcells_postRWS)])

subplot(4, 1, 4)
% Plot W Pre/W Post RWSCF

mice = zeros(nMice, 1);
for i = 1:nMice
    exptype = allData.data{i}.experimentType;
    if strcmp(exptype, 'whiskerOptoTet')
        mice(i) = 1;
    end
end

mice = logical(mice);
temp = linspace(1, nMice, nMice);
mice = temp(mice);

allmicehist_pks = zeros(nBins, nMice);
numcells_preRWSCF = 0;
numresponsivecells_preRWSCF = 0;
for i = mice
    tetPeriod = allData.data{i}.tetPeriod;
    trialType = allData.data{i}.trialType;
    dczPeriod = allData.data{i}.dczPeriod;
    motType = allData.data{i}.trialmotType;
    if strcmp(motiontrial, 'all')
        get_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
    else
        get_trials = strcmp(tetPeriod, 'PRE') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motType, motiontrial);
    end
    spkLocs = allData.data{i}.spkLocs(:, get_trials);

    if strcmp(celltype, 'all')
        spkLocs = spkLocs;
    else
        cellinfo = allData.data{i}.cellType;
        getcells = strcmp(cellinfo, celltype);
        spkLocs = spkLocs(getcells, :);
    end
        
        numcells_preRWSCF = numcells_preRWSCF + size(spkLocs, 1);
        for c = 1:size(spkLocs, 1)
            temp = spkLocs(c, :); temp = temp(:); temp = cell2mat(temp);
            temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
            if length(temp) >= 1
                numresponsivecells_preRWSCF = numresponsivecells_preRWSCF +1;
            end
        end

        pkvec = spkLocs(:); pkvec = cell2mat(pkvec); pkvec = pkvec(~isnan(pkvec));
        [h, ~] = histcounts(pkvec, nBins,  'Normalization', 'probability');
        allmicehist_pks(:, i) = h;
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

allmicehist_pks = zeros(nBins, nMice);
numcells_postRWSCF = 0;
numresponsivecells_postRWSCF = 0;
for i = mice
    tetPeriod = allData.data{i}.tetPeriod;
    trialType = allData.data{i}.trialType;
    dczPeriod = allData.data{i}.dczPeriod;
    motType = allData.data{i}.trialmotType;
    if strcmp(motiontrial, 'all')
        get_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ');
    else
        get_trials = strcmp(tetPeriod, 'POST') & strcmp(trialType, 'W') & strcmp(dczPeriod, 'NO DCZ') & strcmp(motType, motiontrial);
    end
    spkLocs = allData.data{i}.spkLocs(:, get_trials);

    if strcmp(celltype, 'all')
        spkLocs = spkLocs;
    else
        cellinfo = allData.data{i}.cellType;
        getcells = strcmp(cellinfo, celltype);
        spkLocs = spkLocs(getcells, :);
    end
        
        numcells_postRWSCF = numcells_postRWSCF + size(spkLocs, 1);
        for c = 1:size(spkLocs, 1)
            temp = spkLocs(c, :); temp = temp(:); temp = cell2mat(temp);
            temp = find(temp > responsivewindow(1) & temp < responsivewindow(2));
            if length(temp) >= 1
                numresponsivecells_postRWSCF = numresponsivecells_postRWSCF +1;
            end
        end

        pkvec = spkLocs(:); pkvec = cell2mat(pkvec);  pkvec = pkvec(~isnan(pkvec));
        [h, ~] = histcounts(pkvec, nBins, 'Normalization', 'probability');
        allmicehist_pks(:, i) = h;
end

keepmice = allmicehist_pks(1, :); keepmice = sum(~isnan(keepmice));
allmicehist_pks = sum(allmicehist_pks, 2, 'omitnan')/keepmice;
histogram('BinEdges', binedges, 'BinCounts', allmicehist_pks, 'FaceAlpha', 0.5, 'FaceColor', color, 'EdgeColor', 'none')
legend('Pre RWSCF', 'Post RWSCF', 'box', 'off')
title(['n responsive cells (pre) = ', num2str(numresponsivecells_preRWSCF), '/', num2str(numcells_preRWSCF), ';', 'n reponsive cells (post) = ', num2str(numresponsivecells_postRWSCF), '/', num2str(numcells_postRWSCF)])

end
