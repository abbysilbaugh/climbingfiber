function getspecialbarplot(allData, grabsumresponsive)
    nMice = length(grabsumresponsive);

    RWS = zeros(nMice, 1);
    RWSCF = zeros(nMice, 1);
    for i = 1:nMice
        exptType = allData.data{i}.experimentType;
        if strcmp(exptType, 'whiskerTet')
            RWS(i) = 1;
        elseif strcmp(exptType, 'whiskerOptoTet')
            RWSCF(i) = 1;
        end
    end

    pre = grabsumresponsive(:, 1);
    post = grabsumresponsive(:, 2);

    RWSpre = pre(logical(RWS), 1);
    RWSpost = post(logical(RWS), 1);
    RWSCFpre = pre(logical(RWSCF), 1);
    RWSCFpost = post(logical(RWSCF), 1);

    figure;
    scatter(RWSpre, RWSpost, 125, 'MarkerEdgeColor', 'k')
    hold on
    scatter(RWSCFpre, RWSCFpost, 125, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 0.5)
    x = [0 1];
    plot(x, x, 'Color', 'k')
    xlabel('% Cells Responsive Pre', 'FontWeight', 'bold')
    ylabel('% Cells Responsive Post', 'FontWeight', 'bold')
    xticks([0 0.5 1])
    yticks([0 0.5 1])
    %legend

% Calculate SEM for each group
    sem_RWSpre = std(RWSpre) / sqrt(length(RWSpre));
    sem_RWSpost = std(RWSpost) / sqrt(length(RWSpost));
    sem_RWSCFpre = std(RWSCFpre) / sqrt(length(RWSCFpre));
    sem_RWSCFpost = std(RWSCFpost) / sqrt(length(RWSCFpost));

    % Bar plot for RWS with error bars
    figure;
    y = [mean(RWSpre) mean(RWSpost)];
    sem = [sem_RWSpre sem_RWSpost]; % SEM values
    bar(y, 'FaceColor', [1 1 1], 'EdgeColor', [0 0 0], 'LineWidth', 2)
    hold on;
    errorbar(1:2, y, sem, 'k', 'linestyle', 'none', 'LineWidth', 2); % Add error bars
    ylim([0 1])
    yticks([0 1])
    yticklabels([0 100])
    ylabel('% Responsive Cells')
    title('RWS')

    % Bar plot for RWSCF with error bars
    figure;
    y = [mean(RWSCFpre) mean(RWSCFpost)];
    sem = [sem_RWSCFpre sem_RWSCFpost]; % SEM values
    bar(y, 'FaceColor', [0 0 0], 'FaceAlpha', 0.5, 'EdgeColor', [0 0 0], 'LineWidth', 2)
    hold on;
    errorbar(1:2, y, sem, 'k', 'linestyle', 'none', 'LineWidth', 2); % Add error bars
    ylim([0 1])
    yticks([0 1])
    yticklabels([0 100])
    ylabel('% Responsive Cells')
    title('RWSCF')
end

     

    




