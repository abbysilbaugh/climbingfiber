% Plots individual cells (trial averaged) for each condition and the maximum in max_win
% Only takes traces from evokedtraces

% evoked_win may not be used

function visualizeevokedtraces_each(allData, selectmottype, evoked_win, max_win)
window = (evoked_win(2) - evoked_win(1))*32.25;
colors = {[187/255, 37/255, 37/255, 0.5], [34/255, 75/255, 170/255, 0.5], [10/255, 138/255, 35/255, 0.5], [99/255, 63/255, 115/255, 0.5], [0, 0, 0, 0.5]};

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
 figure('Position', [50 50 1800 800]);
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
         
         getvar = allData.data{i}.evokedtraces(:, getcells, w_pre_trials{i}); getvar = mean(getvar, 3, 'omitnan');
         wpre_wo_mice{i} = getvar;
         getvar = allData.data{i}.evokedtraces(:, getcells, wo_pre_trials{i});  getvar = mean(getvar, 3, 'omitnan');
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
         
         getvar = allData.data{i}.evokedtraces(:, getcells, w_pre_trials{i});  getvar = mean(getvar, 3, 'omitnan');
         wpre_RWS_mice{i} = getvar;
         getvar = allData.data{i}.evokedtraces(:, getcells, w_post_trials{i});  getvar = mean(getvar, 3, 'omitnan');
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
         
         getvar = allData.data{i}.evokedtraces(:, getcells, w_pre_trials{i});  getvar = mean(getvar, 3, 'omitnan');
         wpre_RWSCF_mice{i} = getvar;
         getvar = allData.data{i}.evokedtraces(:, getcells, w_post_trials{i});  getvar = mean(getvar, 3, 'omitnan');
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
    
     pks_w = grabpeaks(w, max_win);
     pks_wo = grabpeaks(wo, max_win);
     pks_pre_RWS = grabpeaks(pre_RWS, max_win);
     pks_post_RWS = grabpeaks(post_RWS, max_win);
     pks_pre_RWSCF = grabpeaks(pre_RWSCF, max_win);
     pks_post_RWSCF = grabpeaks(post_RWSCF, max_win);

    subplot(5, 3, imagecount)
    plot(w, 'Color', [0 0 0 0.5])
    hold on
    plot(wo, 'Color', colors{counter});
    imagecount = imagecount + 1;
    title('Basic Transmission')
    for n = 1:size(pks_w, 1)
        scatter(pks_w{n, 2}, pks_w{n, 1}, 'MarkerFaceColor', [0 0 0], 'MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', 'none')
        scatter(pks_wo{n, 2}, pks_wo{n, 1}, 'MarkerFaceColor', colors{counter}(1:3), 'MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', 'none')
    end
    

    subplot(5, 3, imagecount)
    plot(pre_RWS, 'Color', [0 0 0 0.5])
    hold on
    plot(post_RWS, 'Color', colors{counter});
    imagecount = imagecount + 1;
    title('RWS')
    for n = 1:size(pks_pre_RWS, 1)
        scatter(pks_pre_RWS{n, 2}, pks_pre_RWS{n, 1}, 'MarkerFaceColor', [0 0 0], 'MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', 'none')
        scatter(pks_post_RWS{n, 2}, pks_post_RWS{n, 1}, 'MarkerFaceColor', colors{counter}(1:3), 'MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', 'none')
    end

    subplot(5, 3, imagecount)
    plot(pre_RWSCF, 'Color', [0 0 0 0.5])
    hold on
    plot(post_RWSCF, 'Color', colors{counter});
    imagecount = imagecount + 1;
    title('RWSCF')
    for n = 1:size(pks_pre_RWSCF, 1)
        scatter(pks_pre_RWSCF{n, 2}, pks_pre_RWSCF{n, 1}, 'MarkerFaceColor', [0 0 0], 'MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', 'none')
        scatter(pks_post_RWSCF{n, 2}, pks_post_RWSCF{n, 1}, 'MarkerFaceColor', colors{counter}(1:3), 'MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', 'none')
    end

 end


end

function [grabpeaks] = grabpeaks(tracematrix, max_win)

    grabpeaks = cell(size(tracematrix, 2), 2);
    for n = 1:size(tracematrix, 2)
%         [pks, locs] = findpeaks(tracematrix(:, n));
%         idx = (locs > evoked_win(1));
%         pks = pks(idx);
%         locs = locs(idx);
% 
%         if length(locs > 0)
%             max_idx = (pks == max(pks));
%             pks = pks(max_idx);
%             locs = locs(max_idx);
%             grabpeaks{n, 1} = pks;
%             grabpeaks{n, 2} = locs;
%         else
%             grabpeaks{n, 1} = NaN;
%             grabpeaks{n, 2} = NaN;
%         end

        temp = tracematrix(max_win(1):max_win(2), n);
        [maximum, idx] = max(temp);
        idx = idx + max_win(1);

        if ~isnan(maximum)
            grabpeaks{n, 1} = maximum;
            grabpeaks{n, 2} = idx;
        else
            grabpeaks{n, 1} = NaN;
            grabpeaks{n, 2} = NaN;
        end
    end





end