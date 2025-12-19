function dataGUI(allData)


   % allData = compileDataset(condition, nMotion, Motion_win);

    % Initialize with first cell and first trial
    currentCell = 1;
    currentTrial = 1;
    currentMouse = 1;
    
    % Maximum cells and trials
    maxCells = 0;
    maxTrials = 0;
    maxMice = size(allData.data, 2);
    for i = 1:size(allData.data, 2)
        cells = length(allData.data{i}.cellType);
        trials = length(allData.data{i}.trialType);
        if cells > maxCells
            maxCells = cells;
        end
        if trials > maxTrials
            maxTrials = trials;
        end
    end

    % Create figure and GUI components
    f = figure('Position', [300,196,489,704]);

    % Create axes to plot data
    ax_c = axes('Units', 'pixels', 'Position', [50 450 400 150]);
    ax_s = axes('Units', 'pixels', 'Position', [50 250 400 150]);
    ax_m = axes('Units', 'pixels', 'Position', [50 50 400 150]);

    % Cell slider
    uicontrol('Style', 'text', 'String', 'Cell', 'Position', [50 670 50 20]);
    cellSlider = uicontrol('Style', 'slider', 'Min', 1, 'Max', maxCells, 'Value', currentCell, ...
                           'Position', [100 670 300 20], 'SliderStep', [1/(maxCells-1) 10/(maxCells-1)], ...
                           'Callback', @changeCell);
    
    % Trial slider
    uicontrol('Style', 'text', 'String', 'Trial', 'Position', [50 640 50 20]);
    trialSlider = uicontrol('Style', 'slider', 'Min', 1, 'Max', maxTrials, 'Value', currentTrial, ...
                            'Position', [100 640 300 20], 'SliderStep', [1/(maxTrials-1) 10/(maxTrials-1)], ...
                            'Callback', @changeTrial);

    % Mouse slider
    uicontrol('Style', 'text', 'String', 'Mouse', 'Position', [50 610 50 20]);
    mouseSlider = uicontrol('Style', 'slider', 'Min', 1, 'Max', maxMice, 'Value', currentMouse, ...
                            'Position', [100 610 300 20], 'SliderStep', [1/(maxMice-1) 10/(maxMice-1)], ...
                            'Callback', @changeMouse);

    % Plot initial data

    plotData();

    % Callback functions
    function changeCell(source, ~)
        currentCell = round(source.Value);
        plotData();
    end

    function changeTrial(source, ~)
        currentTrial = round(source.Value);

        % Ensure currentTrial is within valid range
        if currentTrial < 1 || currentTrial > length(allData.data{currentMouse}.trialType)
            return;  % or handle the out-of-range condition appropriately
        end
        plotData();
    end

    function changeMouse(source, ~)
        currentCell = round(source.Value);
        % Ensure currentTrial is within valid range
        if currentCell < 1 || currentCell > length(allData.data{currentCell}.cellType)
            return;  % or handle the out-of-range condition appropriately
        end
        plotData();
    end

    function plotData()
        trace_colors = {'#ea9595', '#7b9be5',  '#0a8a23', '#949494', '#46cccf'}; % [PV, PN, VIP, UC, PC]
        oasis_colors = {'#bb2525', '#224baa', '#0a8a23', 'k', '#46cccf'}; % [PV, PN, VIP, UC, PC]

        cla(ax_c);
        cla(ax_s);
        cla(ax_m);

        trialType = allData.data{currentMouse}.trialType(currentTrial);
        tetType = allData.data{currentMouse}.tetPeriod(currentTrial);
        cellType = allData.data{currentMouse}.cellType(currentCell);
        trace = allData.data{currentMouse}.golayshift(:, currentCell, currentTrial);
        pkLocs = allData.data{currentMouse}.pkLocs{currentCell, currentTrial};
        amps = allData.data{currentMouse}.amps{currentCell, currentTrial};
        
        motion = allData.data{currentMouse}.motionInfo(:, currentTrial);
        c_oasis = allData.data{currentMouse}.c_oasis(:, currentCell, currentTrial);
        s_oasis = allData.data{currentMouse}.s_oasis(:, currentCell, currentTrial);
        firstspike = allData.data{currentMouse}.firstspike{currentCell, currentTrial};


        % c
        axes(ax_c);
        % axes('position', [0.05,.75,0.882,0.2]);
        hold on;
        
        if strcmp(cellType, 'PV')
            plot(trace, 'color', trace_colors{1});
        elseif strcmp(cellType, 'PN')
            plot(trace, 'color', trace_colors{2});
        elseif strcmp(cellType, 'UC')
            plot(trace, 'color', trace_colors{4});
        elseif strcmp(cellType, 'VIP')
            plot(trace, 'color', trace_colors{3});
        elseif strcmp(cellType, 'PC')
            plot(trace, 'color', trace_colors{5});
        end
        % alpha(.7);
        % plot(true_c, 'color', col{3}/255, 'linewidth', 1.5);

        scatter(pkLocs, amps);
        
        if strcmp(cellType, 'PV')
            plot(c_oasis, 'color', oasis_colors{1}, 'LineStyle', '--');
        elseif strcmp(cellType, 'PN')
            plot(c_oasis, 'color', oasis_colors{2}, 'LineStyle', '--');
        elseif strcmp(cellType, 'UC')
            plot(c_oasis, 'color', oasis_colors{4}, 'LineStyle', '--');
        elseif strcmp(cellType, 'VIP')
            plot(c_oasis, 'color', oasis_colors{3}, 'LineStyle', '--');
        elseif strcmp(cellType, 'PC')
            plot(c_oasis, 'color',  oasis_colors{5}, 'LineStyle', '--'); 
        end
        
        axis tight;
        
        if strcmp(trialType, 'W') & strcmp(tetType, 'PRE')
            xline(310, 'LineWidth', 2, 'Color', 'k')
        elseif strcmp(trialType, 'O') & strcmp(tetType, 'PRE')
            xline(310, 'LineWidth', 2, 'Color', '#4DBEEE')
        elseif strcmp(trialType, 'WO') & strcmp(tetType, 'PRE')
            xline(310, 'LineWidth', 2, 'Color', '#0072BD')
        elseif strcmp(trialType, 'W') & strcmp(tetType, 'POST')
            xline(310, 'LineWidth', 2, 'Color', 'k', 'LineStyle', '--')
        end

        
        xlim([0, 620]);
        ylim([-0.2 2]);
        set(gca, 'xtick', (0:20)*31);
        set(gca, 'xticklabel', (0:20));
        %set(gca, 'ytick', 0:2);
        ylabel('Fluor.');
        box off;
        legend('Data', 'OASIS', 'location', 'northeast', 'orientation', 'horizontal');
        
        % s
       
        axes(ax_s);
        % axes('position', [0.05,0.45,0.882,0.2]);
        hold on;
        %plot(true_s, 'color', col{3}/255, 'linewidth', 1.5);
        
        if strcmp(cellType, 'PV')
            plot(s_oasis, 'color', oasis_colors{1}, 'LineStyle', '--');
        elseif strcmp(cellType, 'PN')
            plot(s_oasis, 'color', oasis_colors{2}, 'LineStyle', '--');
        elseif strcmp(cellType, 'UC')
            plot(s_oasis, 'color', oasis_colors{4}, 'LineStyle', '--');
        elseif strcmp(cellType, 'VIP')
            plot(s_oasis, 'color', oasis_colors{3}, 'LineStyle', '--');
        elseif strcmp(cellType, 'PC')
            plot(s_oasis, 'color', oasis_colors{5}, 'LineStyle', '--');
        end
        
        spikes = find(s_oasis);
        
        for spike = 1:length(spikes)
            xline(spikes(spike), 'LineWidth', 1, 'Color', 'k')
        end

%         if ~isnan(firstspike)
%             xline(firstspike, 'LineWidth', 1, 'Color', 'k')
%         end

        
        if strcmp(trialType, 'W') & strcmp(tetType, 'PRE')
            xline(310, 'LineWidth', 2, 'Color', 'k')
        elseif strcmp(trialType, 'O') & strcmp(tetType, 'PRE')
            xline(310, 'LineWidth', 2, 'Color', '#4DBEEE')
        elseif strcmp(trialType, 'WO') & strcmp(tetType, 'PRE')
            xline(310, 'LineWidth', 2, 'Color', '#0072BD')
        elseif strcmp(trialType, 'W') & strcmp(tetType, 'POST')
            xline(310, 'LineWidth', 2, 'Color', 'k', 'LineStyle', '--')
        end

        xline(316, 'LineWidth', 1, 'Color', 'r', 'LineStyle', '--')
        
        axis tight;
        ylim([0 1]);
        xlim([0, 620]);
        set(gca, 'xtick', [0, 20]*31);
        set(gca, 'xticklabel', []);
        set(gca, 'ytick', [0,1]);
        %xlabel('Time [s]');
        ylabel('Activity.');

        
        axes(ax_m);
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
            xline(310, 'LineWidth', 2, 'Color', 'k', 'LineStyle', '--')
        end
        
        axis tight;
        xlim([0, 620]);
        set(gca, 'xtick', [0, 20]*31);
        set(gca, 'xticklabel', get(gca, 'xtick')/31);
        %set(gca, 'ytick', [0,1]);
        xlabel('Time [s]');
        ylabel('Motion');

        hold off




            % show_results_practice;
        % Use currentCell and currentTrial to index your data
    end
end
