function visualizewindowevents(allData, selectmottype, celltype)
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

nMice = length(allData.data);
binedges = linspace(0, 3, 93);

 % Get trials and mice
 w_pre = cell(nMice, 1);
 wo_pre = cell(nMice, 1);
 w_post = cell(nMice, 1);

 wo_mice = zeros(nMice, 1);
 RWS_mice = zeros(nMice, 1);
 RWSCF_mice = zeros(nMice, 1);
 for i = 1:nMice
     trialtype = allData.data{i}.trialType;
     tettype = allData.data{i}.tetPeriod;
     dcztype = allData.data{i}.dczPeriod;
     mottype = allData.data{i}.trialmotType;
     exptype = allData.data{i}.experimentType;

     if strcmp(selectmottype, 'all')
        w_pre{i} = strcmp(trialtype, 'W') & strcmp(tettype, 'PRE') & strcmp(dcztype, 'NO DCZ');
        wo_pre{i} = strcmp(trialtype, 'WO') & strcmp(tettype, 'PRE') & strcmp(dcztype, 'NO DCZ');
        w_post{i} = strcmp(trialtype, 'W') & strcmp(tettype, 'POST') & strcmp(dcztype, 'NO DCZ');
     else
        w_pre{i} = strcmp(trialtype, 'W') & strcmp(tettype, 'PRE') & strcmp(dcztype, 'NO DCZ') & strcmp(mottype, selectmottype);
        wo_pre{i} = strcmp(trialtype, 'WO') & strcmp(tettype, 'PRE') & strcmp(dcztype, 'NO DCZ') & strcmp(mottype, selectmottype);
        w_post{i} = strcmp(trialtype, 'W') & strcmp(tettype, 'POST') & strcmp(dcztype, 'NO DCZ') & strcmp(mottype, selectmottype);
     end

    if sum(wo_pre{i}) > 1
        wo_mice(i) = 1;
    end

    if strcmp(exptype, 'whiskerTet')
        RWS_mice(i) = 1;
    elseif strcmp(exptype, 'whiskerOptoTet')
        RWSCF_mice(i) = 1;
    end
 end

 tempmice = linspace(1, nMice, nMice);
 wo_mice = logical(wo_mice); RWS_mice = logical(RWS_mice); RWSCF_mice = logical(RWSCF_mice);
 wo_mice = tempmice(wo_mice); RWS_mice = tempmice(RWS_mice); RWSCF_mice = tempmice(RWSCF_mice);

 % Grab data
 % w pre (all mice)
 wpre_allmice = zeros(nMice, length(binedges)-1);
 for i = 1:nMice
     celltypes = allData.data{i}.cellType; nCells = length(celltypes);
     if strcmp(celltype, 'all')
         getcells = ones(nCells, 1); getcells = logical(getcells);
     else
         getcells = strcmp(celltypes, celltype);
     end
     getvar = allData.data{i}.maxevoked_amp(getcells, w_pre{i}); 
     getvar = mean(getvar, 2, 'omitnan');
     h = histcounts(getvar, binedges);
     wpre_allmice(i, :) = h;
 end

 wpre_allmice = sum(wpre_allmice, 1, 'omitnan');

 % w pre and wo pre
 wpre_wo_mice = zeros(nMice, length(binedges)-1);
 wopre_wo_mice = zeros(nMice, length(binedges)-1);
 for i = wo_mice
     celltypes = allData.data{i}.cellType; nCells = length(celltypes);
     if strcmp(celltype, 'all')
         getcells = ones(nCells, 1); getcells = logical(getcells);
     else
         getcells = strcmp(celltypes, celltype);
     end
     getvar = allData.data{i}.maxevoked_amp(getcells, w_pre{i}); getvar = mean(getvar, 2, 'omitnan');
     h = histcounts(getvar, binedges);
     wpre_wo_mice(i, :) = h;
     getvar = allData.data{i}.maxevoked_amp(getcells, wo_pre{i}); getvar = mean(getvar, 2, 'omitnan'); 
     h = histcounts(getvar, binedges);
     wopre_wo_mice(i, :) = h;
 end

 wpre_wo_mice = wpre_wo_mice(wo_mice, :); wpre_wo_mice = sum(wpre_wo_mice, 1, 'omitnan');
 wopre_wo_mice = wopre_wo_mice(wo_mice, :); wopre_wo_mice = sum(wopre_wo_mice, 1, 'omitnan');

 % w pre RWS and w post RWS
 wpre_RWS_mice = zeros(nMice, length(binedges)-1);
 wpost_RWS_mice = zeros(nMice, length(binedges)-1);
 for i = RWS_mice
     celltypes = allData.data{i}.cellType; nCells = length(celltypes);
     if strcmp(celltype, 'all')
         getcells = ones(nCells, 1); getcells = logical(getcells);
     else
         getcells = strcmp(celltypes, celltype);
     end
     getvar = allData.data{i}.maxevoked_amp(getcells, w_pre{i}); getvar = mean(getvar, 2, 'omitnan'); 
     h = histcounts(getvar, binedges);
     wpre_RWS_mice(i, :) = h;
     getvar = allData.data{i}.maxevoked_amp(getcells, w_post{i}); getvar = mean(getvar, 2, 'omitnan'); 
     h = histcounts(getvar, binedges);
     wpost_RWS_mice(i, :) = h;
 end

 wpre_RWS_mice = wpre_RWS_mice(RWS_mice, :); wpre_RWS_mice = sum(wpre_RWS_mice, 1, 'omitnan');
 wpost_RWS_mice = wpost_RWS_mice(RWS_mice, :); wpost_RWS_mice = sum(wpost_RWS_mice, 1, 'omitnan');

 % w pre RWSCF and w post RWSCF
 wpre_RWSCF_mice = zeros(nMice, length(binedges)-1);
 wpost_RWSCF_mice = zeros(nMice, length(binedges)-1);
 for i = RWSCF_mice
     celltypes = allData.data{i}.cellType; nCells = length(celltypes);
     if strcmp(celltype, 'all')
         getcells = ones(nCells, 1); getcells = logical(getcells);
     else
         getcells = strcmp(celltypes, celltype);
     end
     getvar = allData.data{i}.maxevoked_amp(getcells, w_pre{i}); getvar = mean(getvar, 2, 'omitnan');
     h = histcounts(getvar, binedges);
     wpre_RWSCF_mice(i, :) = h;
     getvar = allData.data{i}.maxevoked_amp(getcells, w_post{i}); getvar = mean(getvar, 2, 'omitnan'); 
     h = histcounts(getvar, binedges);
     wpost_RWSCF_mice(i, :) = h;
 end

 wpre_RWSCF_mice = wpre_RWSCF_mice(RWSCF_mice, :); wpre_RWSCF_mice = sum(wpre_RWSCF_mice, 1, 'omitnan');
 wpost_RWSCF_mice = wpost_RWSCF_mice(RWSCF_mice, :); wpost_RWSCF_mice = sum(wpost_RWSCF_mice, 1, 'omitnan');

figure('Position', [50 50 1800 600]);
subplot(1, 4, 1)
histogram('BinEdges', binedges, 'BinCounts', wpre_allmice, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.5)
ylabel('Probability')
title('Response Amplitudes (W stim)')
xlabel('∆F/F0')

subplot(1, 4, 2)
histogram('BinEdges', binedges, 'BinCounts', wpre_wo_mice, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.5)
hold on
histogram('BinEdges', binedges, 'BinCounts', wopre_wo_mice, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.5)
legend('W', 'W+CF', 'box', 'off')
title('Basic Transmission')
xlabel('∆F/F0')

subplot(1, 4, 3)
histogram('BinEdges', binedges, 'BinCounts', wpre_RWS_mice, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.5)
hold on
histogram('BinEdges', binedges, 'BinCounts', wpost_RWS_mice, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.5)
legend('W pre RWS', 'W post RWS', 'box', 'off')
title('RWS')
xlabel('∆F/F0')

subplot(1, 4, 4)
histogram('BinEdges', binedges, 'BinCounts', wpre_RWSCF_mice, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.5)
hold on
histogram('BinEdges', binedges, 'BinCounts', wpost_RWSCF_mice, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.5)
legend('W pre RWSCF', 'W post RWSCF', 'box', 'off')
title('RWSCF')
xlabel('∆F/F0')



end