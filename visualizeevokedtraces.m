% Traces are trial averaged, then population averaged from evokedtraces

function visualizeevokedtraces(allData, selectmottype, tracetype)
ylimit = [0 0.5];
colors = {[187/255, 37/255, 37/255], [34/255, 75/255, 170/255], [10/255, 138/255, 35/255], [99/255, 63/255, 115/255], [0, 0, 0]};

%colors = {'#bb2525', '#224baa', '#0a8a23', '#633f73', 'k'};
neurontypes = {'PV', 'PN', 'VIP', 'SST', 'UC'};

nMice = length(allData.data);
nFrames = size(allData.data{1}.ac_bs_signal, 1);

 % Get trials and mice
 w_pre_trials = cell(nMice, 1);
 wo_pre_trials = cell(nMice, 1);
 w_post_trials = cell(nMice, 1);

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
        w_pre_trials{i} = strcmp(trialtype, 'W') & strcmp(tettype, 'PRE') & strcmp(dcztype, 'NO DCZ');
        wo_pre_trials{i} = strcmp(trialtype, 'WO') & strcmp(tettype, 'PRE') & strcmp(dcztype, 'NO DCZ');
        w_post_trials{i} = strcmp(trialtype, 'W') & strcmp(tettype, 'POST') & strcmp(dcztype, 'NO DCZ');
     else
        w_pre_trials{i} = strcmp(trialtype, 'W') & strcmp(tettype, 'PRE') & strcmp(dcztype, 'NO DCZ') & strcmp(mottype, selectmottype);
        wo_pre_trials{i} = strcmp(trialtype, 'WO') & strcmp(tettype, 'PRE') & strcmp(dcztype, 'NO DCZ') & strcmp(mottype, selectmottype);
        w_post_trials{i} = strcmp(trialtype, 'W') & strcmp(tettype, 'POST') & strcmp(dcztype, 'NO DCZ') & strcmp(mottype, selectmottype);
     end

    if sum(wo_pre_trials{i}) > 1
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
 figure('Position', [50,50,805,936]);
 imagecount = 1;
 for counter = 1:length(neurontypes)
     % w pre and wo pre
     wpre_wo_mice = cell(nMice, 1);
     wopre_wo_mice = cell(nMice, 1);
     
     wpre_wo_motion = cell(nMice, 1);
     wopre_wo_motion = cell(nMice, 1);
     for i = wo_mice
         celltypes = allData.data{i}.cellType;
         getcells = strcmp(celltypes, neurontypes{counter});
         
         if strcmp(tracetype, 'evokedtraces')
            getvar = allData.data{i}.evokedtraces(:, getcells, w_pre_trials{i}); getvar = mean(getvar, 3, 'omitnan');
         elseif strcmp(tracetype, 'evokedtraces2')
             getvar = allData.data{i}.evokedtraces2(:, getcells, w_pre_trials{i}); getvar = mean(getvar, 3, 'omitnan');
         end
         wpre_wo_mice{i} = getvar;
         if strcmp(tracetype, 'evokedtraces')
            getvar = allData.data{i}.evokedtraces(:, getcells, wo_pre_trials{i});  getvar = mean(getvar, 3, 'omitnan');
         elseif strcmp(tracetype, 'evokedtraces2')
             getvar = allData.data{i}.evokedtraces2(:, getcells, wo_pre_trials{i});  getvar = mean(getvar, 3, 'omitnan');
         end
            wopre_wo_mice{i} = getvar;
        
         getmot = allData.data{i}.motionInfo(:, w_pre_trials{i}); getmot = mean(getmot, 2, 'omitnan');
         wpre_wo_motion{i} = getmot;
         getmot = allData.data{i}.motionInfo(:, wo_pre_trials{i}); getmot = mean(getmot, 2, 'omitnan');
         wopre_wo_motion{i} = getmot;
     end
    
     % w pre RWS and w post RWS
     wpre_RWS_mice = cell(nMice, 1);
     wpost_RWS_mice = cell(nMice, 1);
     
     wpre_RWS_motion = cell(nMice, 1);
     wpost_RWS_motion = cell(nMice, 1);
     for i = RWS_mice
         celltypes = allData.data{i}.cellType;
         getcells = strcmp(celltypes, neurontypes{counter});
         
         if strcmp(tracetype, 'evokedtraces')
            getvar = allData.data{i}.evokedtraces(:, getcells, w_pre_trials{i});  getvar = mean(getvar, 3, 'omitnan');
         elseif strcmp(tracetype, 'evokedtraces2')
             getvar = allData.data{i}.evokedtraces2(:, getcells, w_pre_trials{i});  getvar = mean(getvar, 3, 'omitnan');
         end
         wpre_RWS_mice{i} = getvar;

         if strcmp(tracetype, 'evokedtraces')
            getvar = allData.data{i}.evokedtraces(:, getcells, w_post_trials{i});  getvar = mean(getvar, 3, 'omitnan');
         elseif strcmp(tracetype, 'evokedtraces2')
             getvar = allData.data{i}.evokedtraces2(:, getcells, w_post_trials{i});  getvar = mean(getvar, 3, 'omitnan');
         end

         wpost_RWS_mice{i} = getvar;
         
         getmot = allData.data{i}.motionInfo(:, w_pre_trials{i});  getmot = mean(getmot, 2, 'omitnan');
         wpre_RWS_motion{i} = getmot;
         getmot = allData.data{i}.motionInfo(:, w_post_trials{i});  getmot = mean(getmot, 2, 'omitnan');
         wpost_RWS_motion{i} = getmot;
     end
    
     % w pre RWSCF and w post RWSCF
     wpre_RWSCF_mice = cell(nMice, 1);
     wpost_RWSCF_mice = cell(nMice, 1);

     wpre_RWSCF_motion = cell(nMice, 1);
     wpost_RWSCF_motion = cell(nMice, 1);
     for i = RWSCF_mice
         celltypes = allData.data{i}.cellType;
         getcells = strcmp(celltypes, neurontypes{counter});
         
         if strcmp(tracetype, 'evokedtraces')
            getvar = allData.data{i}.evokedtraces(:, getcells, w_pre_trials{i});  getvar = mean(getvar, 3, 'omitnan');
         elseif strcmp(tracetype, 'evokedtraces2')
             getvar = allData.data{i}.evokedtraces2(:, getcells, w_pre_trials{i});  getvar = mean(getvar, 3, 'omitnan');
         end
         wpre_RWSCF_mice{i} = getvar;
         if strcmp(tracetype, 'evokedtraces')
            getvar = allData.data{i}.evokedtraces(:, getcells, w_post_trials{i});  getvar = mean(getvar, 3, 'omitnan');
         elseif strcmp(tracetype, 'evokedtraces2')
             getvar = allData.data{i}.evokedtraces2(:, getcells, w_post_trials{i});  getvar = mean(getvar, 3, 'omitnan');
         end
         wpost_RWSCF_mice{i} = getvar;

          getmot = allData.data{i}.motionInfo(:, w_pre_trials{i});  getmot = mean(getmot, 2, 'omitnan');
         wpre_RWSCF_motion{i} = getmot;
         getmot = allData.data{i}.motionInfo(:, w_post_trials{i});  getmot = mean(getmot, 2, 'omitnan');
         wpost_RWSCF_motion{i} = getmot;
     end

     % Count cells and compile mice
     nCells_wo_mice = 0;
     for n = 1:nMice
         if ~isempty(wpre_wo_mice{n})
         nCells_wo_mice = nCells_wo_mice + size(wpre_wo_mice{n}, 2);
         end
     end

     w = zeros(nFrames, nCells_wo_mice);
     wo = zeros(nFrames, nCells_wo_mice);

     c = 1;
     for n = 1:nMice
         if ~isempty(wpre_wo_mice{n})
         temp = wpre_wo_mice{n};
         ncells = size(temp, 2);
         w(:, c:c+ncells-1) = temp;
         temp = wopre_wo_mice{n};
         wo(:, c:c+ncells-1) = temp;
         c = c + ncells;
         end
     end

     nCells_RWS_mice = 0;
     for n = 1:nMice
         if ~isempty(wpre_RWS_mice{n})
         nCells_RWS_mice = nCells_RWS_mice + size(wpre_RWS_mice{n}, 2);
         end
     end

     pre_RWS = zeros(nFrames, nCells_RWS_mice);
     post_RWS = zeros(nFrames, nCells_RWS_mice);
     c = 1;
     for n = 1:nMice
         if ~isempty(wpre_RWS_mice{n})
         temp = wpre_RWS_mice{n};
         ncells = size(temp, 2);
         pre_RWS(:, c:c+ncells-1) = temp;
         temp = wpost_RWS_mice{n};
         post_RWS(:, c:c+ncells-1) = temp;
         c = c + ncells;
         end
     end

     nCells_RWSCF_mice = 0;
     for n = 1:nMice
         if ~isempty(wpre_RWSCF_mice{n})
         nCells_RWSCF_mice = nCells_RWSCF_mice + size(wpre_RWSCF_mice{n}, 2);
         end
     end

     pre_RWSCF = zeros(nFrames, nCells_RWSCF_mice);
     post_RWSCF = zeros(nFrames, nCells_RWSCF_mice);
     c = 1;
     for n = 1:nMice
         if ~isempty(wpre_RWSCF_mice{n})
         temp = wpre_RWSCF_mice{n};
         ncells = size(temp, 2);
         pre_RWSCF(:, c:c+ncells-1) = temp;
         temp = wpost_RWSCF_mice{n};
         post_RWSCF(:, c:c+ncells-1) = temp;
         c = c + ncells;
         end
     end
    
    subplot(5, 3, imagecount)
    getactivecells = ~isnan(w(1, :)); num_w = sum(getactivecells);
    w_mean = mean(w(:, getactivecells), 2);
    w_sem = std(w(:, getactivecells), 0, 2) / sqrt(num_w);
    getactivecells = ~isnan(wo(1, :)); num_wo = sum(getactivecells);
    wo_mean = mean(wo(:, getactivecells), 2);
    wo_sem = std(wo(:, getactivecells), 0, 2) / sqrt(num_wo);
    hold on
    h1 = fill([1:length(w_mean), length(w_mean):-1:1], [w_mean - w_sem; flipud(w_mean + w_sem)], [0 0 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
    h2 = fill([1:length(wo_mean), length(wo_mean):-1:1], [wo_mean - wo_sem; flipud(wo_mean + wo_sem)], colors{counter}, 'linestyle', 'none', 'FaceAlpha', 0.5);
    plot(w_mean, 'Color', [0 0 0 0.5])
    plot(wo_mean, 'Color', colors{counter});
    imagecount = imagecount + 1;
    legend([h1, h2], ['W: ', num2str(num_w)], ['W+CF: ', num2str(num_wo)], 'box', 'off', 'Location', 'northeast')
    title(['Basic Transmission; nCells = ', num2str(length(getactivecells))])
    ylim(ylimit)
    ylabel('ΔF/F0')
    xticks([0 62 124 186 248 310 372 434 496 558 620])
    xticklabels([-10 -8 -6 -4 -2 0 2 4 6 8 10])
    xlabel('s')
    xlim([300 434])

    subplot(5, 3, imagecount)
    getactivecells = ~isnan(pre_RWS(1, :)); num_preRWS = sum(getactivecells);
    pre_RWS_mean = mean(pre_RWS(:, getactivecells), 2);
    pre_RWS_sem = std(pre_RWS(:, getactivecells), 0, 2) / sqrt(num_preRWS); % SEM calculation
    hold on
    h1= fill([1:length(pre_RWS_mean), length(pre_RWS_mean):-1:1], [pre_RWS_mean - pre_RWS_sem; flipud(pre_RWS_mean + pre_RWS_sem)], [0 0 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
    getactivecells = ~isnan(post_RWS(1, :)); num_postRWS = sum(getactivecells);
    post_RWS_mean = mean(post_RWS(:, getactivecells), 2);
    post_RWS_sem = std(post_RWS(:, getactivecells), 0, 2) / sqrt(num_postRWS); % SEM calculation
    h2 = fill([1:length(post_RWS_mean), length(post_RWS_mean):-1:1], [post_RWS_mean - post_RWS_sem; flipud(post_RWS_mean + post_RWS_sem)], colors{counter}, 'linestyle', 'none', 'FaceAlpha', 0.5);
    plot(pre_RWS_mean, 'Color', [0 0 0 0.5])
    plot(post_RWS_mean, 'Color', colors{counter});
    imagecount = imagecount + 1;
    title(['RWS; nCells = ', num2str(length(getactivecells))])
    legend([h1, h2], ['Pre: ', num2str(num_preRWS)], ['Post: ', num2str(num_postRWS)], 'box', 'off', 'Location', 'northeast')
    ylim(ylimit)
    xticks([0 62 124 186 248 310 372 434 496 558 620])
    xticklabels([-10 -8 -6 -4 -2 0 2 4 6 8 10])
    xlabel('s')
    xlim([300 434])
    ylabel('ΔF/F0')

    subplot(5, 3, imagecount)
    getactivecells = ~isnan(pre_RWSCF(1, :)); num_preRWSCF = sum(getactivecells);
    pre_RWSCF_mean = mean(pre_RWSCF(:, getactivecells), 2);
    pre_RWSCF_sem = std(pre_RWSCF(:, getactivecells), 0, 2) / sqrt(num_preRWSCF); % SEM calculation
    hold on
    h1 = fill([1:length(pre_RWSCF_mean), length(pre_RWSCF_mean):-1:1], [pre_RWSCF_mean - pre_RWSCF_sem; flipud(pre_RWSCF_mean + pre_RWSCF_sem)], [0 0 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
    getactivecells = ~isnan(post_RWSCF(1, :)); num_postRWSCF = sum(getactivecells);
    post_RWSCF_mean = mean(post_RWSCF(:, getactivecells), 2);
    post_RWSCF_sem = std(post_RWSCF(:, getactivecells), 0, 2) / sqrt(num_postRWSCF); % SEM calculation
    h2 = fill([1:length(post_RWSCF_mean), length(post_RWSCF_mean):-1:1], [post_RWSCF_mean - post_RWSCF_sem; flipud(post_RWSCF_mean + post_RWSCF_sem)], colors{counter}, 'linestyle', 'none', 'FaceAlpha', 0.5);
    plot(pre_RWSCF_mean, 'Color', [0 0 0 0.5])
    plot(post_RWSCF_mean, 'Color', colors{counter});
    imagecount = imagecount + 1;
    legend([h1, h2], ['Pre: ', num2str(num_preRWSCF)], ['Post: ', num2str(num_postRWSCF)], 'box', 'off', 'Location', 'northeast')
    title(['RWSCF; nCells = ', num2str(length(getactivecells))])
    ylim(ylimit)
    xticks([0 62 124 186 248 310 372 434 496 558 620])
    xticklabels([-10 -8 -6 -4 -2 0 2 4 6 8 10])
    xlabel('s')
    xlim([300 434])
    ylabel('ΔF/F0')

 end

     figure('Position', [50,50,805,936/3])
     wpre_wo_motion = compilemotiontraces(wpre_wo_motion, wo_mice);
     wopre_wo_motion = compilemotiontraces(wopre_wo_motion, wo_mice);
     wpre_RWS_motion = compilemotiontraces(wpre_RWS_motion, RWS_mice);
     wpost_RWS_motion = compilemotiontraces(wpost_RWS_motion, RWS_mice);
     wpre_RWSCF_motion = compilemotiontraces(wpre_RWSCF_motion, RWSCF_mice);
     wpost_RWSCF_motion = compilemotiontraces(wpost_RWSCF_motion, RWSCF_mice);

     subplot(1, 3, 1)
     mean_w = mean(wpre_wo_motion, 2, 'omitnan');
     sem_w = std(wpre_wo_motion, 0, 2, 'omitnan')/sqrt(length(wpre_wo_motion));
     mean_wo = mean(wopre_wo_motion, 2, 'omitnan');
     sem_wo = std(wopre_wo_motion, 0, 2, 'omitnan')/sqrt(length(wopre_wo_motion));
     h1 = fill([1:length(mean_w), length(mean_w):-1:1], [mean_w- sem_w; flipud(mean_w + sem_w)], [0 0 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
     hold on
     h2 = fill([1:length(mean_wo), length(mean_wo):-1:1], [mean_wo - sem_wo; flipud(mean_wo + sem_wo)], [0 0 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
     plot(mean_w, 'Color', 'k', 'LineStyle', ':')
     plot(mean_wo, 'Color', 'k')
     xticks([0 62 124 186 248 310 372 434 496 558 620])
     xticklabels([-10 -8 -6 -4 -2 0 2 4 6 8 10])
     xlabel('Time Relative to Stimulus Onset (s)')
     xlim([300 434])
     ylabel('P(Motion)')

     subplot(1, 3, 2)
     mean_pre = mean(wpre_RWS_motion, 2, 'omitnan');
     sem_pre = std(wpre_RWS_motion, 0, 2, 'omitnan')/sqrt(length(wpre_RWS_motion));
     mean_post = mean(wpost_RWS_motion, 2, 'omitnan');
     sem_post = std(wpost_RWS_motion, 0, 2, 'omitnan')/sqrt(length(wpost_RWS_motion));
     h1 = fill([1:length(mean_pre), length(mean_pre):-1:1], [mean_pre- sem_pre; flipud(mean_pre + sem_pre)], [0 0 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
     hold on
     h2 = fill([1:length(mean_post), length(mean_post):-1:1], [mean_post - sem_post; flipud(mean_post + sem_post)], [0 0 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
     plot(mean_pre, 'Color', 'k', 'LineStyle', ':')
     plot(mean_post, 'Color', 'k')
     xticks([0 62 124 186 248 310 372 434 496 558 620])
     xticklabels([-10 -8 -6 -4 -2 0 2 4 6 8 10])
     xlabel('Time Relative to Stimulus Onset (s)')
     xlim([300 434])
     ylabel('P(Motion)')

     subplot(1, 3, 3)
     mean_pre = mean(wpre_RWSCF_motion, 2, 'omitnan');
     sem_pre = std(wpre_RWSCF_motion, 0, 2, 'omitnan')/sqrt(length(wpre_RWSCF_motion));
     mean_post = mean(wpost_RWSCF_motion, 2, 'omitnan');
     sem_post = std(wpost_RWSCF_motion, 0, 2, 'omitnan')/sqrt(length(wpost_RWSCF_motion));
     h1 = fill([1:length(mean_pre), length(mean_pre):-1:1], [mean_pre- sem_pre; flipud(mean_pre + sem_pre)], [0 0 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
     hold on
     h2 = fill([1:length(mean_post), length(mean_post):-1:1], [mean_post - sem_post; flipud(mean_post + sem_post)], [0 0 0], 'linestyle', 'none', 'FaceAlpha', 0.5);
     plot(mean_pre, 'Color', 'k', 'LineStyle', ':')
     plot(mean_post, 'Color', 'k')
     xticks([0 62 124 186 248 310 372 434 496 558 620])
     xticklabels([-10 -8 -6 -4 -2 0 2 4 6 8 10])
     xlabel('Time Relative to Stimulus Onset (s)')
     xlim([300 434])
     ylabel('P(Motion)')




end

function motiontraces = compilemotiontraces(m_trace, mice)
    mice = length(mice);
    motiontraces = zeros(620, mice);
    for n = 1:length(m_trace)
        if length(m_trace{n}) > 0
            motiontraces(:, n) = m_trace{n};
        else
            motiontraces(:, n) = NaN;
        end
    end

end