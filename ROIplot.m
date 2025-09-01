function ROIplot(allData, i, selectmottype, evoked_win, max_win)
    
% Get trials and data
    trialtype = allData.data{i}.trialType;
    tettype = allData.data{i}.tetPeriod;
    mottype = allData.data{i}.trialmotType;
    dcztype = allData.data{i}.dczPeriod;
    
    if strcmp(selectmottype, 'all')
        w_pre_trials = strcmp(trialtype, 'W') & strcmp(tettype, 'PRE') & strcmp(dcztype, 'NO DCZ');
        wo_pre_trials = strcmp(trialtype, 'WO') & strcmp(tettype, 'PRE') & strcmp(dcztype, 'NO DCZ');
        w_post_trials = strcmp(trialtype, 'W') & strcmp(tettype, 'POST') & strcmp(dcztype, 'NO DCZ');
    else
        w_pre_trials = strcmp(trialtype, 'W') & strcmp(tettype, 'PRE') & strcmp(dcztype, 'NO DCZ') & strcmp(mottype, selectmottype);
        wo_pre_trials = strcmp(trialtype, 'WO') & strcmp(tettype, 'PRE') & strcmp(dcztype, 'NO DCZ') & strcmp(mottype, selectmottype);
        w_post_trials = strcmp(trialtype, 'W') & strcmp(tettype, 'POST') & strcmp(dcztype, 'NO DCZ') & strcmp(mottype, selectmottype);
    end

    evokedtraces = allData.data{i}.evokedtraces;

    w_pre_trialavg = evokedtraces(:, :, w_pre_trials); w_pre_trialavg = mean(w_pre_trialavg, 3, 'omitnan');
    wo_pre_trialavg = evokedtraces(:, :, wo_pre_trials); wo_pre_trialavg = mean(wo_pre_trialavg, 3, 'omitnan');
    w_post_trialavg = evokedtraces(:, :, w_post_trials); w_post_trialavg = mean(w_post_trialavg, 3, 'omitnan');

    w_pre_pks = grabpeaks(w_pre_trialavg, max_win);
    wo_pre_pks = grabpeaks(wo_pre_trialavg, max_win);
    w_post_pks = grabpeaks(w_post_trialavg, max_win);

    [inc_wo, dec_wo, active_w_pre, active_wo_pre] = getROIchanges(w_pre_pks, wo_pre_pks);
    [inc_plasticity, dec_plasticity, ~, active_w_post] = getROIchanges(w_pre_pks, w_post_pks);

    cellType = allData.data{i}.cellType;
    ROIcoords = allData.data{i}.ROIcoords;
    colors = {[187/255, 37/255, 37/255], [34/255, 75/255, 170/255], [10/255, 138/255, 35/255], [99/255, 63/255, 115/255], [0, 0, 0]};
    exptype = allData.data{i}.experimentType;

    figure('Position', [50 50 1200 900]);
    subplot(2, 2, 1)
    plotpreROIs(ROIcoords, cellType, colors, active_w_pre)
    title('W PRE')

    subplot(2, 2, 2)
    if sum(wo_pre_trials) > 1
        plotchangeROIs(ROIcoords, cellType, colors, active_wo_pre, inc_wo)
        title('W+CF PRE')
    end

    subplot(2, 2, 3)
    plotpreROIs(ROIcoords, cellType, colors, active_w_pre)
    title('W PRE')

    subplot(2, 2, 4)
    plotchangeROIs(ROIcoords, cellType, colors, active_w_post, inc_plasticity)
    if strcmp(exptype, 'whiskerOptoTet')
        title('W POST RWSCF')
    elseif strcmp(exptype, 'whiskerTet')
        title('W POST RWS')
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

function [inc, dec, active_cond1, active_cond2] = getROIchanges(pks_cond1, pks_cond2)

    active_cond1 = ~isnan(pks_cond1);
    active_cond2 = ~isnan(pks_cond2);

    pks_cond1(~active_cond1) = 0;
    pks_cond2(~active_cond2) = 0;

    inc = pks_cond2 > pks_cond1;
    dec = pks_cond1 > pks_cond2;

end

function plotpreROIs(ROIcoords, cellType, colors, active_cond)
    for c = 1:length(ROIcoords)
            p = fill(ROIcoords{c}(:,1), ROIcoords{c}(:,2), [0.5,0.5,0.5]);
            if strcmp(cellType(c), 'PV')
                p.EdgeColor = colors{1};
                if active_cond(c)
                    p.FaceColor = colors{1};
                else
                    p.FaceColor = 'none';
                end
            elseif strcmp(cellType(c), 'PN')
                p.EdgeColor = colors{2};
                if active_cond(c)
                    p.FaceColor = colors{2};
                else
                    p.FaceColor = 'none';
                end
            elseif strcmp(cellType(c), 'VIP')
                p.EdgeColor = colors{3};
                if active_cond(c)
                    p.FaceColor = colors{3};
                else
                    p.FaceColor = 'none';
                end
            elseif strcmp(cellType(c), 'SST')
                p.EdgeColor = colors{4};
                if active_cond(c)
                    p.FaceColor = colors{4};
                else
                    p.FaceColor = 'none';
                end
            elseif strcmp(cellType(c), 'UC')
                p.EdgeColor = colors{5};
                if active_cond(c)
                    p.FaceColor = colors{5};
                else
                    p.FaceColor = 'none';
                end
            end
    
            p.FaceAlpha = 0.5;
            hold on
    end
end

function plotchangeROIs(ROIcoords, cellType, colors, active_cond, inc)
    for c = 1:length(ROIcoords)
            p = fill(ROIcoords{c}(:,1), ROIcoords{c}(:,2), [0.5,0.5,0.5]);
            if strcmp(cellType(c), 'PV')
                p.EdgeColor = colors{1};
                if active_cond(c)
                    p.FaceColor = colors{1};
                else
                    p.FaceColor = 'none';
                end
                if inc(c)
                    p.FaceAlpha = 1;
                else
                    p.FaceAlpha = 0.5;
                end
            elseif strcmp(cellType(c), 'PN')
                p.EdgeColor = colors{2};
                if active_cond(c)
                    p.FaceColor = colors{2};
                else
                    p.FaceColor = 'none';
                end
                if inc(c)
                    p.FaceAlpha = 1;
                else
                    p.FaceAlpha = 0.5;
                end
            elseif strcmp(cellType(c), 'VIP')
                p.EdgeColor = colors{3};
                if active_cond(c)
                    p.FaceColor = colors{3};
                else
                    p.FaceColor = 'none';
                end
                if inc(c)
                    p.FaceAlpha = 1;
                else
                    p.FaceAlpha = 0.5;
                end
            elseif strcmp(cellType(c), 'SST')
                p.EdgeColor = colors{4};
                if active_cond(c)
                    p.FaceColor = colors{4};
                else
                    p.FaceColor = 'none';
                end
                if inc(c)
                    p.FaceAlpha = 1;
                else
                    p.FaceAlpha = 0.5;
                end
            elseif strcmp(cellType(c), 'UC')
                p.EdgeColor = colors{5};
                if active_cond(c)
                    p.FaceColor = colors{5};
                else
                    p.FaceColor = 'none';
                end
                if inc(c)
                    p.FaceAlpha = 1;
                else
                    p.FaceAlpha = 0.5;
                end
            end
    
            hold on
    end
end