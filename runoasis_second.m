function [allData] = runoasis_second(allData, baselineNoise2, plot_all, sn_thresh)

% UPDATE PLOT FUNCTION

trace_colors = {'#ea9595', '#7b9be5', '#0a8a23', '#c487de', '#949494'}; % [PV, PN, VIP, SST, UC]
oasis_colors = {'#bb2525', '#224baa', '#0a8a23', '#633f73', 'k'}; % [PV, PN, VIP, SST, UC]


for i = 1:size(allData.mouseIDs, 2)

    nCells = length(allData.data{i}.cellType);
    nTrials = length(allData.data{i}.trialType);

    allData.data{i}.c_oasis2 = zeros(size(allData.data{i}.golaysignal2));
    allData.data{i}.s_oasis2 = zeros(size(allData.data{i}.golaysignal2));
    allData.data{i}.golayshift2 = zeros(size(allData.data{i}.golaysignal2));
    allData.data{i}.spiketimes2 = zeros(size(allData.data{i}.golaysignal2));

    allData.data{i}.b_oasis2 = zeros(nCells, nTrials);
    allData.data{i}.smin_oasis2 = zeros(nCells, nTrials);
    allData.data{i}.sn_oasis2 = zeros(nCells, nTrials);
  

    for j = 1:nCells
        for k = 1:nTrials

            trialType = allData.data{i}.trialType(k);
            tetType = allData.data{i}.tetPeriod(k);
            cellType = allData.data{i}.cellType(j);
            golaytrace2 = allData.data{i}.golaysignal2(:, j, k);
            motion = allData.data{i}.motionInfo(:, k);

            %filterWindow = 5;
            %polynomialOrder = 1;
            %golaytrace = sgolayfilt(golaytrace, polynomialOrder, filterWindow);


            % Deconvolve trace using FOOPSI and constrain spike size to be 2 times the noise levels
            % use baselines calculated across sessions for each cell
            
            bNoise2 = baselineNoise2{i}{j};

            % First version: set sn and smin
            % switched from foopsi to constrained foopsi 9/3/2023
            %[c_oasis, s_oasis, options] = deconvolveCa(golaytrace, 'foopsi', 'ar1', 'smin', -sn_thresh, 'sn', bNoise, 'optimize_b', true);

            if isnan(golaytrace2(1)) % ADDED THIS DUE TO MISSING ROIS IN 20240112 VIPCre WhiskerOpto Tet DREADD and 20241020
                allData.data{i}.golayshift2(:, j, k) = golaytrace2; % this is 620 x 1 double with NaNs
                allData.data{i}.c_oasis2(:, j, k) = golaytrace2;
                allData.data{i}.s_oasis2(:, j, k) = golaytrace2;
                allData.data{i}.spiketimes2(:, j, k) = golaytrace2;
                allData.data{i}.b_oasis2(j, k) = NaN;
                allData.data{i}.smin_oasis2(j, k) = NaN;
                allData.data{i}.sn_oasis2(j, k) = NaN;
            else

                % Second version: set smin only
                [c_oasis2, s_oasis2, options2] = deconvolveCa(golaytrace2, 'foopsi', 'ar1', 'smin', 2*bNoise2, 'optimize_pars', true, 'optimize_b', true);
    
                spiketimes2 = s_oasis2; spiketimes2(spiketimes2 > 0) = 1;
    
                allData.data{i}.golayshift2(:, j, k) = golaytrace2 - options2.b;
                allData.data{i}.c_oasis2(:, j, k) = c_oasis2;
                allData.data{i}.s_oasis2(:, j, k) = s_oasis2;
                allData.data{i}.spiketimes2(:, j, k) = spiketimes2;
                allData.data{i}.b_oasis2(j, k) = options2.b;
                allData.data{i}.smin_oasis2(j, k) = options2.smin;
                allData.data{i}.sn_oasis2(j, k) = options2.sn;
            end


            if plot_all
                figure;
                title('Baseline Noise: ',num2str(bNoise2))
    
                % c
                subplot(3, 1, 1)
                % axes('position', [0.05,.75,0.882,0.2]);
                hold on;
                
                if strcmp(cellType, 'PV')
                    plot(golaytrace2, 'color', trace_colors{1});
                elseif strcmp(cellType, 'PN')
                    plot(golaytrace2, 'color', trace_colors{2});
                elseif strcmp(cellType, 'VIP')
                    plot(golaytrace2, 'color', trace_colors{3});
                elseif strcmp(cellType, 'SST')
                    plot(golaytrace2, 'color', trace_colors{4});
                elseif strcmp(cellType, 'UC')
                    plot(golaytrace2, 'color', trace_colors{5});
                end
                alpha(.7);
                %plot(true_c, 'color', col{3}/255, 'linewidth', 1.5);
                
                if strcmp(cellType, 'PV')
                    plot(c_oasis2, 'color', oasis_colors{1}, 'LineStyle', '-');
                elseif strcmp(cellType, 'PN')
                    plot(c_oasis2, 'color', oasis_colors{2}, 'LineStyle', '-');
                elseif strcmp(cellType, 'VIP')
                    plot(c_oasis2, 'color', oasis_colors{3}, 'LineStyle', '-');
                elseif strcmp(cellType, 'SST')
                    plot(c_oasis2, 'color', oasis_colors{4}, 'LineStyle', '-');
                elseif strcmp(cellType, 'UC')
                    plot(c_oasis2, 'color', oasis_colors{5}, 'LineStyle', '-');
                end
                
                axis tight;
                
                if strcmp(trialType, 'W') & strcmp(tetType, 'PRE')
                    xline(310, 'LineWidth', 2, 'Color', 'k')
                elseif strcmp(trialType, 'O') & strcmp(tetType, 'PRE')
                    xline(310, 'LineWidth', 2, 'Color', '#4DBEEE')
                elseif strcmp(trialType, 'WO') & strcmp(tetType, 'PRE')
                    xline(310, 'LineWidth', 2, 'Color', '#0072BD')
                elseif strcmp(trialType, 'W') & strcmp(tetType, 'POST')
                    xline(310, 'LineWidth', 2, 'Color', 'k', 'LineStyle', '-')
                end
                
                xlim([0, 620]);
                ylim([-0.2 1]);
                set(gca, 'xtick', [0, 20]*31);
                set(gca, 'xticklabel', []);
                %set(gca, 'ytick', 0:2);
                ylabel('Fluor.');
                box off;
                legend('Data', 'OASIS', 'location', 'northeast', 'orientation', 'horizontal');
                % s
                
                subplot(3, 1, 2)
                % axes('position', [0.05,0.45,0.882,0.2]);
                hold on;
                %plot(true_s, 'color', col{3}/255, 'linewidth', 1.5);
                
                if strcmp(cellType, 'PV')
                    plot(s_oasis2, 'color', oasis_colors{1}, 'LineStyle', '-');
                elseif strcmp(cellType, 'PN')
                    plot(s_oasis2, 'color', oasis_colors{2}, 'LineStyle', '-');
                elseif strcmp(cellType, 'VIP')
                    plot(s_oasis2, 'color', oasis_colors{3}, 'LineStyle', '-');
                elseif strcmp(cellType, 'SST')
                    plot(s_oasis2, 'color', oasis_colors{4}, 'LineStyle', '-');
                elseif strcmp(cellType, 'UC')
                    plot(s_oasis2, 'color', oasis_colors{5}, 'LineStyle', '-');
                end
                
                m = find(s_oasis2);
                
                for spike = 1:length(m)
                    xline(m(spike), 'LineWidth', 1, 'Color', 'k')
                end
                
                if strcmp(trialType, 'W') & strcmp(tetType, 'PRE')
                    xline(310, 'LineWidth', 2, 'Color', 'k')
                elseif strcmp(trialType, 'O') & strcmp(tetType, 'PRE')
                    xline(310, 'LineWidth', 2, 'Color', '#4DBEEE')
                elseif strcmp(trialType, 'WO') & strcmp(tetType, 'PRE')
                    xline(310, 'LineWidth', 2, 'Color', '#0072BD')
                elseif strcmp(trialType, 'W') & strcmp(tetType, 'POST')
                    xline(310, 'LineWidth', 2, 'Color', 'k', 'LineStyle', '-')
                end
                
                axis tight;
                ylim([0 1]);
                xlim([0, 620]);
                set(gca, 'xtick', [0, 20]*31);
                set(gca, 'xticklabel', []);
                set(gca, 'ytick', [0,1]);
                %xlabel('Time [s]');
                ylabel('Activity.');
                
                subplot(3, 1, 3)
                % axes('position', [0.05,0.15,0.882,0.2]);
                hold on;
                % plot(true_s, 'color', col{3}/255, 'linewidth', 1.5);
                find_motion = find(motion);
                
                for mot_spike = 1:length(find_motion)
                    xline(find_motion(mot_spike), 'LineWidth', 1, 'Color', 'k')
                end
                
                if strcmp(trialType, 'W') & strcmp(tetType, 'PRE')
                    xline(310, 'LineWidth', 2, 'Color', 'k')
                elseif strcmp(trialType, 'O') & strcmp(tetType, 'PRE')
                    xline(310, 'LineWidth', 2, 'Color', '#4DBEEE')
                elseif strcmp(trialType, 'WO') & strcmp(tetType, 'PRE')
                    xline(310, 'LineWidth', 2, 'Color', '#0072BD')
                elseif strcmp(trialType, 'W') & strcmp(tetType, 'POST')
                    xline(310, 'LineWidth', 2, 'Color', 'k', 'LineStyle', '-')
                end
                
                axis tight;
                xlim([0, 620]);
                set(gca, 'xtick', [0, 20]*31);
                set(gca, 'xticklabel', get(gca, 'xtick')/31);
                %set(gca, 'ytick', [0,1]);
                xlabel('Time [s]');
                ylabel('Motion');
            end



            % show_results_practice;
        end
    end
end

end