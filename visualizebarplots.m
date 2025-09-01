% Plots individual cells (trial averaged) for each condition and the maximum in max_win
% Only takes traces from evokedtraces

% evoked_win may not be used

function [increase_cells, decrease_cells, active_PRE_RWS, active_POST_RWS] = visualizebarplots(allData, selectmottype, evoked_win, max_win, plottype, ylimit)
window = (evoked_win(2) - evoked_win(1))*32.25;
colors = {[187/255, 37/255, 37/255, 0.5], [34/255, 75/255, 170/255, 0.5], [10/255, 138/255, 35/255, 0.5], [99/255, 63/255, 115/255, 0.5], [0, 0, 0, 0.5]};

%colors = {'#bb2525', '#224baa', '#0a8a23', '#633f73', 'k'};
neurontypes = {'PV', 'PN', 'VIP', 'SST', 'UC'};

increase_cells = cell(length(neurontypes), 1);
decrease_cells = cell(length(neurontypes), 1);
active_PRE_RWS = cell(length(neurontypes), 1);
active_POST_RWS = cell(length(neurontypes), 1);

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
 for counter = 1:length(neurontypes)
     % w pre and wo pre
     wpre_wo_mice = cell(nMice, 1);
     wopre_wo_mice = cell(nMice, 1);
     
     wpre_wo_motion = cell(nMice, 1);
     wopre_wo_motion = cell(nMice, 1);

     wo_mice_ROInum = cell(nMice, 1);
     for i = wo_mice
         celltypes = allData.data{i}.cellType;
         getcells = strcmp(celltypes, neurontypes{counter});
         ROIs = linspace(1, length(celltypes), length(celltypes));
         ROIs = ROIs(getcells);
         wo_mice_ROInum{i} = ROIs;
         
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

     RWS_mice_ROInum = cell(nMice, 1);
     for i = RWS_mice
         celltypes = allData.data{i}.cellType;
         getcells = strcmp(celltypes, neurontypes{counter});
         ROIs = linspace(1, length(celltypes), length(celltypes));
         ROIs = ROIs(getcells);
         RWS_mice_ROInum{i} = ROIs;
         
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
     
     RWSCF_mice_ROInum = cell(nMice, 1);
     for i = RWSCF_mice
         celltypes = allData.data{i}.cellType;
         getcells = strcmp(celltypes, neurontypes{counter});
         ROIs = linspace(1, length(celltypes), length(celltypes));
         ROIs = ROIs(getcells);
         RWSCF_mice_ROInum{i} = ROIs;
         
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
     wo_ROIs = zeros(nCells_wo_mice, 2);

     c = 1;
     for n = 1:nMice
         if ~isempty(wpre_wo_mice{n})
         temp = wpre_wo_mice{n};
         ncells = size(temp, 2);
         w(:, c:c+ncells-1) = temp;
         temp = wopre_wo_mice{n};
         wo(:, c:c+ncells-1) = temp;
         temp = wo_mice_ROInum{n};
         wo_ROIs(c:c+ncells-1, 1) = temp;
         wo_ROIs(c:c+ncells-1, 2) = n;
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
     RWS_ROIs = zeros(nCells_RWS_mice, 2);

     c = 1;
     for n = 1:nMice
         if ~isempty(wpre_RWS_mice{n})
         temp = wpre_RWS_mice{n};
         ncells = size(temp, 2);
         pre_RWS(:, c:c+ncells-1) = temp;
         temp = wpost_RWS_mice{n};
         post_RWS(:, c:c+ncells-1) = temp;
         temp = RWS_mice_ROInum{n};
         RWS_ROIs(c:c+ncells-1, 1) = temp;
         RWS_ROIs(c:c+ncells-1, 2) = n;
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
     RWSCF_ROIs = zeros(nCells_RWS_mice, 2);
     c = 1;
     for n = 1:nMice
         if ~isempty(wpre_RWSCF_mice{n})
         temp = wpre_RWSCF_mice{n};
         ncells = size(temp, 2);
         pre_RWSCF(:, c:c+ncells-1) = temp;
         temp = wpost_RWSCF_mice{n};
         post_RWSCF(:, c:c+ncells-1) = temp;
         temp = RWSCF_mice_ROInum{n};
         RWSCF_ROIs(c:c+ncells-1, 1) = temp;
         RWSCF_ROIs(c:c+ncells-1, 2) = n;
         c = c + ncells;
         end
     end
    
     pks_w = grabpeaks(w, max_win);
     pks_wo = grabpeaks(wo, max_win);
     pks_pre_RWS = grabpeaks(pre_RWS, max_win);
     pks_post_RWS = grabpeaks(post_RWS, max_win);
     pks_pre_RWSCF = grabpeaks(pre_RWSCF, max_win);
     pks_post_RWSCF = grabpeaks(post_RWSCF, max_win);

     % Find ROIs that have larger peak post (analysis for grant 051524)
     increase_cells_temp = zeros(nCells_RWS_mice, 1);
     decrease_cells_temp = zeros(nCells_RWS_mice, 1);
     active_PRE_RWS_temp = zeros(nCells_RWS_mice, 1);
     active_POST_RWS_temp = zeros(nCells_RWS_mice, 1);
     for neuron = 1:nCells_RWS_mice
         pre = pks_pre_RWS(neuron);
         post = pks_post_RWS(neuron);
         if isnan(pre)
             pre = 0;
         else 
             active_PRE_RWS_temp(neuron) = 1;
         end
         if isnan(post)
             post = 0; 
         else 
             active_POST_RWS_temp(neuron) = 1;
         end
         if post > pre
             increase_cells_temp(neuron) = 1;
         end
         if post < pre
             decrease_cells_temp(neuron) = 1;
         end
     end
     increase_cells_temp = logical(increase_cells_temp);
     increase_cells_temp = RWS_ROIs(increase_cells_temp, :);
     increase_cells{counter} = increase_cells_temp;
     decrease_cells_temp = logical(decrease_cells_temp);
     decrease_cells_temp = RWS_ROIs(decrease_cells_temp, :);
     decrease_cells{counter} = decrease_cells_temp;
     active_PRE_RWS_temp = logical(active_PRE_RWS_temp);
     active_PRE_RWS_temp = RWS_ROIs(active_PRE_RWS_temp, :);
     active_PRE_RWS{counter} = active_PRE_RWS_temp;
     active_POST_RWS_temp = logical(active_POST_RWS_temp);
     active_POST_RWS_temp = RWS_ROIs(active_POST_RWS_temp, :);
     active_POST_RWS{counter} = active_POST_RWS_temp;


    figure('Position', [50 50 1500 850]);
    nCells_bt = numel(pks_w);
    nCells_RWS = numel(pks_pre_RWS);
    nCells_RWSCF = numel(pks_pre_RWSCF);

    % Calculate the number of samples for SEM
    n_w = sum(~isnan(pks_w));
    n_wo = sum(~isnan(pks_wo));
    n_pre_RWS = sum(~isnan(pks_pre_RWS));
    n_post_RWS = sum(~isnan(pks_post_RWS));
    n_pre_RWSCF = sum(~isnan(pks_pre_RWSCF));
    n_post_RWSCF = sum(~isnan(pks_post_RWSCF));

        % Subplot for basic transmission
    subplot(1,3,1);
    hold on;
    bar([1,2], [mean(pks_w, 'omitnan'), mean(pks_wo, 'omitnan')], 0.5, 'FaceColor', colors{counter}(1:3), 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    errorbar([1,2], [mean(pks_w, 'omitnan'), mean(pks_wo, 'omitnan')], [std(pks_w, 'omitnan')/sqrt(n_w), std(pks_wo, 'omitnan')/sqrt(n_wo)], 'Color', colors{counter}(1:3), 'linestyle', 'none');
    if strcmp(plottype, 'onlylines')
        plot([ones(nCells_bt,1), 2*ones(nCells_bt,1)]', [pks_w, pks_wo]', '-', 'Color', colors{counter}(1:3));
        errorbar([1,2], [mean(pks_w, 'omitnan'), mean(pks_wo, 'omitnan')], [std(pks_w, 'omitnan')/sqrt(n_w), std(pks_wo, 'omitnan')/sqrt(n_wo)], 'Color', colors{counter}(1:3), 'linestyle', 'none');
    else
        plot([ones(nCells_bt,1), 2*ones(nCells_bt,1)]', [pks_w, pks_wo]', '-o', 'Color', colors{counter}(1:3), 'MarkerFaceColor', colors{counter}(1:3));
    end
    xticks([1 2]);
    xticklabels({'W', 'W+CF'});
    ylabel('∆F/F0');
    title('Basic Transmission');
    hold off;
    ylim([ylimit])
    
    % Subplot for RWS
    subplot(1,3,2);
    hold on;
    bar([1,2], [mean(pks_pre_RWS, 'omitnan'), mean(pks_post_RWS, 'omitnan')], 0.5, 'FaceColor', colors{counter}(1:3), 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    if strcmp(plottype, 'onlylines')
        plot([ones(nCells_RWS,1), 2*ones(nCells_RWS,1)]', [pks_pre_RWS, pks_post_RWS]', '-', 'Color', colors{counter}(1:3));
        errorbar([1,2], [mean(pks_pre_RWS, 'omitnan'), mean(pks_post_RWS, 'omitnan')], [std(pks_pre_RWS, 'omitnan')/sqrt(n_pre_RWS), std(pks_post_RWS, 'omitnan')/sqrt(n_post_RWS)], 'Color', colors{counter}(1:3), 'linestyle', 'none');
    else
        plot([ones(nCells_RWS,1), 2*ones(nCells_RWS,1)]', [pks_pre_RWS, pks_post_RWS]', '-o', 'Color', colors{counter}(1:3), 'MarkerFaceColor', colors{counter}(1:3));
    end
    xticks([1 2]);
    xticklabels({'Pre', 'Post'});
    ylabel('∆F/F0');
    title('RWS');
    hold off;
    ylim([ylimit])
    
%     % Subplot for RWSCF
    subplot(1,3,3);
    hold on;
    bar([1,2], [mean(pks_pre_RWSCF, 'omitnan'), mean(pks_post_RWSCF, 'omitnan')], 0.5, 'FaceColor', colors{counter}(1:3), 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    if strcmp(plottype, 'onlylines')
        plot([ones(nCells_RWSCF,1), 2*ones(nCells_RWSCF,1)]', [pks_pre_RWSCF, pks_post_RWSCF]', '-', 'Color', colors{counter}(1:3));
        errorbar([1,2], [mean(pks_pre_RWSCF, 'omitnan'), mean(pks_post_RWSCF, 'omitnan')], [std(pks_pre_RWSCF, 'omitnan')/sqrt(n_pre_RWSCF), std(pks_post_RWSCF, 'omitnan')/sqrt(n_post_RWSCF)], 'Color', colors{counter}(1:3), 'linestyle', 'none');
    else
        plot([ones(nCells_RWSCF,1), 2*ones(nCells_RWSCF,1)]', [pks_pre_RWSCF, pks_post_RWSCF]', '-o', 'Color', colors{counter}(1:3), 'MarkerFaceColor', colors{counter}(1:3));
    end
    xticks([1 2]);
    xticklabels({'Pre', 'Post'});
    ylabel('∆F/F0');
    title('RWSCF');
    hold off;
    ylim([ylimit])

%     % Subplot for basic transmission
%     subplot(1,3,1);
%     hold on;
%     bar([1,2], [mean(pks_w, 'omitnan'), mean(pks_wo, 'omitnan')], 0.5, 'FaceColor', colors{counter}(1:3), 'FaceAlpha', 0.5, 'EdgeColor', 'none');
%     errorbar([1,2], [mean(pks_w, 'omitnan'), mean(pks_wo, 'omitnan')], [std(pks_w, 'omitnan'), std(pks_wo, 'omitnan')], 'Color', colors{counter}(1:3), 'linestyle', 'none');
%     if strcmp(plottype, 'onlylines')
%         plot([ones(nCells_bt,1), 2*ones(nCells_bt,1)]', [pks_w, pks_wo]', '-', 'Color', colors{counter}(1:3));
%     else
%         plot([ones(nCells_bt,1), 2*ones(nCells_bt,1)]', [pks_w, pks_wo]', '-o', 'Color', colors{counter}(1:3), 'MarkerFaceColor', colors{counter}(1:3));
%     end
%     xticks([1 2]);
%     xticklabels({'W', 'W+CF'});
%     ylabel('∆F/F0');
%     title('Basic Transmission');
%     hold off;

%     % Subplot for RWS
%     subplot(1,3,2);
%     hold on;
%     bar([1,2], [mean(pks_pre_RWS, 'omitnan'), mean(pks_post_RWS, 'omitnan')], 0.5, 'FaceColor', colors{counter}(1:3), 'FaceAlpha', 0.5, 'EdgeColor', 'none');
%     errorbar([1,2], [mean(pks_pre_RWS, 'omitnan'), mean(pks_post_RWS, 'omitnan')], [std(pks_pre_RWS, 'omitnan'), std(pks_post_RWS, 'omitnan')], 'Color', colors{counter}(1:3), 'linestyle', 'none');
%     if strcmp(plottype, 'onlylines')
%         plot([ones(nCells_RWS,1), 2*ones(nCells_RWS,1)]', [pks_pre_RWS, pks_post_RWS]', '-', 'Color', colors{counter}(1:3));
%     else
%         plot([ones(nCells_RWS,1), 2*ones(nCells_RWS,1)]', [pks_pre_RWS, pks_post_RWS]', '-o', 'Color', colors{counter}(1:3), 'MarkerFaceColor', colors{counter}(1:3));
%     end
%     xticks([1 2]);
%     xticklabels({'Pre RWS', 'Post RWS'});
%     ylabel('∆F/F0');
%     title('RWS');
%     hold off;
    
%         % Subplot for RWSCF
%         subplot(1,3,3);
%         hold on;
%         bar([1,2], [mean(pks_pre_RWSCF, 'omitnan'), mean(pks_post_RWSCF, 'omitnan')], 0.5, 'FaceColor', colors{counter}(1:3), 'FaceAlpha', 0.5, 'EdgeColor', 'none');
%         errorbar([1,2], [mean(pks_pre_RWSCF, 'omitnan'), mean(pks_post_RWSCF, 'omitnan')], [std(pks_pre_RWSCF, 'omitnan'), std(pks_post_RWSCF, 'omitnan')], 'Color', colors{counter}(1:3), 'linestyle', 'none');
%         if strcmp(plottype, 'onlylines')
%             plot([ones(nCells_RWSCF,1), 2*ones(nCells_RWSCF,1)]', [pks_pre_RWSCF, pks_post_RWSCF]', '-', 'Color', colors{counter}(1:3));
%         else
%             plot([ones(nCells_RWSCF,1), 2*ones(nCells_RWSCF,1)]', [pks_pre_RWSCF, pks_post_RWSCF]', '-o', 'Color', colors{counter}(1:3), 'MarkerFaceColor', colors{counter}(1:3));
%         end
%         xticks([1 2]);
%         xticklabels({'Pre RWSCF', 'Post RWSCF'});
%         ylabel('∆F/F0');
%         title('RWSCF');
%         hold off;
%     
%     % Adjust layout
%     sgtitle('Response Analysis');


    

 end


end

function [grabpeaks] = grabpeaks(tracematrix, max_win)

    grabpeaks = zeros(size(tracematrix, 2), 1);
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
        %idx = idx + max_win(1);

        if ~isnan(maximum)
            grabpeaks(n) = maximum;
            %grabpeaks{n, 2} = idx;
        else
            grabpeaks(n) = NaN;
            %grabpeaks{n, 2} = NaN;
        end
    end

end