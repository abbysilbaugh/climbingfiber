% adds to allData.data{mouse}...
    % c_oasis (nFrames x nCells x nTrials)
    % s_oasis (nFrames x nCells x nTrials)
    % spiketimes (nFrames x nCells x nTrials)
    % b_oasis (nCells x nTrials)
    % smin_oasis (nCells x nTrials)
    % sn_oasis (nCells x nTrials)

function [allData] = runoasis(allData, baselineNoise, plot_all, sn_thresh, tracetype)

trace_colors = {'#ea9595', '#7b9be5', '#0a8a23', '#c487de', '#949494'}; % [PV, PN, VIP, SST, UC]
oasis_colors = {'#bb2525', '#224baa', '#0a8a23', '#633f73', 'k'}; % [PV, PN, VIP, SST, UC]

for i = 1:size(allData.mouseIDs, 2)

    nCells = length(allData.data{i}.cellType);
    nTrials = length(allData.data{i}.trialType);

    allData.data{i}.c_oasis = zeros(size(allData.data{i}.raw_signal));
    allData.data{i}.s_oasis = zeros(size(allData.data{i}.raw_signal));
    allData.data{i}.golayshift = zeros(size(allData.data{i}.raw_signal));
    allData.data{i}.spiketimes = zeros(size(allData.data{i}.raw_signal));
    allData.data{i}.b_oasis = zeros(nCells, nTrials);
    allData.data{i}.smin_oasis = zeros(nCells, nTrials);
    allData.data{i}.sn_oasis = zeros(nCells, nTrials);
  
    for j = 1:nCells
        for k = 1:nTrials

            trialType = allData.data{i}.trialType(k);
            tetType = allData.data{i}.tetPeriod(k);
            cellType = allData.data{i}.cellType(j);

            if strcmp(tracetype, 'golaysignal')
                golaytrace = allData.data{i}.golaysignal(:, j, k);
            elseif strcmp(tracetype, 'golaysignal1')
                golaytrace = allData.data{i}.golaysignal1(:, j, k);
            elseif strcmp(tracetype, 'golaysignal2')
                golaytrace = allData.data{i}.golaysignal2(:, j, k);
            elseif strcmp(tracetype, 'golaysignal4')
                golaytrace = allData.data{i}.golaysignal4(:, j, k);
            end
            motion = allData.data{i}.motionInfo(:, k);

            % Deconvolve trace using FOOPSI and constrain spike size to be sn_thresh times the noise levels
            % use BaselineNoise calculated for each cell
            
            bNoise = baselineNoise{i}{j};

            if isnan(golaytrace(1))
                allData.data{i}.golayshift(:, j, k) = golaytrace;
                allData.data{i}.c_oasis(:, j, k) = golaytrace;
                allData.data{i}.s_oasis(:, j, k) = golaytrace;
                allData.data{i}.spiketimes(:, j, k) = golaytrace;
                allData.data{i}.b_oasis(j, k) = NaN;
                allData.data{i}.smin_oasis(j, k) = NaN;
                allData.data{i}.sn_oasis(j, k) = NaN;
            else
             % First version: set sn and smin
                % switched from foopsi to constrained foopsi 9/3/2023
                %[c_oasis, s_oasis, options] = deconvolveCa(golaytrace, 'foopsi', 'ar1', 'smin', -sn_thresh, 'sn', bNoise, 'optimize_b', true);


             % Second version: set smin only
                [c_oasis, s_oasis, options] = deconvolveCa(golaytrace, 'foopsi', 'ar1', 'smin', sn_thresh*bNoise, 'optimize_pars', true, 'optimize_b', true);
    
                spiketimes = s_oasis; spiketimes(spiketimes > 0) = 1;
    
                allData.data{i}.golayshift(:, j, k) = golaytrace - options.b;
                allData.data{i}.c_oasis(:, j, k) = c_oasis;
                allData.data{i}.s_oasis(:, j, k) = s_oasis;
                allData.data{i}.spiketimes(:, j, k) = spiketimes;
                allData.data{i}.b_oasis(j, k) = options.b;
                allData.data{i}.smin_oasis(j, k) = options.smin;
                allData.data{i}.sn_oasis(j, k) = options.sn;
            end


            if plot_all
                figure;
                title('Baseline Noise: ',num2str(bNoise))
    
                % c
                subplot(3, 1, 1)
                % axes('position', [0.05,.75,0.882,0.2]);
                hold on;
                
                if strcmp(cellType, 'PV')
                    plot(golaytrace, 'color', trace_colors{1});
                elseif strcmp(cellType, 'PN')
                    plot(golaytrace, 'color', trace_colors{2});
                elseif strcmp(cellType, 'VIP')
                    plot(golaytrace, 'color', trace_colors{3});
                elseif strcmp(cellType, 'SST')
                    plot(golaytrace, 'color', trace_colors{4});
                elseif strcmp(cellType, 'UC')
                    plot(golaytrace, 'color', trace_colors{5});
                end
                alpha(.7);
                %plot(true_c, 'color', col{3}/255, 'linewidth', 1.5);
                
                if strcmp(cellType, 'PV')
                    plot(c_oasis, 'color', oasis_colors{1}, 'LineStyle', '-');
                elseif strcmp(cellType, 'PN')
                    plot(c_oasis, 'color', oasis_colors{2}, 'LineStyle', '-');
                elseif strcmp(cellType, 'VIP')
                    plot(c_oasis, 'color', oasis_colors{3}, 'LineStyle', '-');
                elseif strcmp(cellType, 'SST')
                    plot(c_oasis, 'color', oasis_colors{4}, 'LineStyle', '-');
                elseif strcmp(cellType, 'UC')
                    plot(c_oasis, 'color', oasis_colors{5}, 'LineStyle', '-');
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
                    plot(s_oasis, 'color', oasis_colors{1}, 'LineStyle', '-');
                elseif strcmp(cellType, 'PN')
                    plot(s_oasis, 'color', oasis_colors{2}, 'LineStyle', '-');
                elseif strcmp(cellType, 'VIP')
                    plot(s_oasis, 'color', oasis_colors{3}, 'LineStyle', '-');
                elseif strcmp(cellType, 'SST')
                    plot(s_oasis, 'color', oasis_colors{4}, 'LineStyle', '-');
                elseif strcmp(cellType, 'UC')
                    plot(s_oasis, 'color', oasis_colors{5}, 'LineStyle', '-');
                end
                
                m = find(s_oasis);
                
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