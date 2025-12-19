function [motionpertrial] = getmotionpertrial(allData, motion_type, choose_norm, baseline, stimOn, savename)

motion_w = [];
motion_o = [];
motion_wo = [];
motion_post_wtet = [];
motion_post_wotet = [];

win = [305, 332];

nMice = size(allData.data, 2);

for i = 1:nMice

        if strcmp(motion_type, 'running')
            motiondata = allData.data{i}.running;
        elseif strcmp(motion_type, 'motion')
            motiondata = allData.data{i}.motionInfo;
        end
        exp = allData.data{i}.experimentType;
        tetperiod = allData.data{i}.tetPeriod;
        trialtype = allData.data{i}.trialType;
    
        [~, nTrials] = size(motiondata);
    
        for j = 1:nTrials
            if strcmp(tetperiod(j), 'PRE') & strcmp(trialtype(j), 'O')
                motion_o = [motion_o, motiondata(:, j)];
            elseif strcmp(tetperiod(j), 'PRE') & strcmp(trialtype(j), 'WO')
                motion_wo = [motion_wo, motiondata(:, j)];
            elseif strcmp(tetperiod(j), 'PRE') & strcmp(trialtype(j), 'W')
                motion_w = [motion_w, motiondata(:, j)];
            elseif strcmp(tetperiod(j), 'POST') & strcmp(trialtype(j), 'W') & strcmp(exp, 'whiskerOptoTet')
                motion_post_wotet = [motion_post_wotet, motiondata(:, j)];
            elseif strcmp(tetperiod(j), 'POST') & strcmp(trialtype(j), 'W') & strcmp(exp, 'whiskerTet')
                motion_post_wtet = [motion_post_wtet, motiondata(:, j)];
            else
                continue
            end
        end
 
end

motion_w = mean(motion_w, 2);
motion_o = mean(motion_o, 2);
motion_wo = mean(motion_wo, 2);
motion_post_wtet = mean(motion_post_wtet, 2);
motion_post_wotet = mean(motion_post_wotet, 2);

% Subtract baseline P(Motion)
if strcmp(choose_norm, 'norm')
%     motion_w = (motion_w - mean(motion_w(baseline:stimOn)))/mean(motion_w(baseline:stimOn));
%     motion_o = (motion_o - mean(motion_o(baseline:stimOn)))/mean(motion_o(baseline:stimOn));
%     motion_wo = (motion_wo - mean(motion_wo(baseline:stimOn)))/mean(motion_wo(baseline:stimOn));
%     motion_post_wtet = (motion_post_wtet - mean(motion_post_wtet(baseline:stimOn)))/mean(motion_post_wtet(baseline:stimOn));
%     motion_post_wotet = (motion_post_wotet - mean(motion_post_wotet(baseline:stimOn)))/mean(motion_post_wotet(baseline:stimOn));

    motion_w = motion_w - mean(motion_w(baseline:stimOn)) %)/mean(motion_w(baseline:stimOn));
    motion_o = motion_o - mean(motion_o(baseline:stimOn)) %)/mean(motion_o(baseline:stimOn));
    motion_wo = motion_wo - mean(motion_wo(baseline:stimOn)) %)/mean(motion_wo(baseline:stimOn));
    motion_post_wtet = motion_post_wtet - mean(motion_post_wtet(baseline:stimOn)) %)/mean(motion_post_wtet(baseline:stimOn));
    motion_post_wotet = motion_post_wotet - mean(motion_post_wotet(baseline:stimOn)) %)/mean(motion_post_wotet(baseline:stimOn));
end
    

semmotion_w = std(motion_w, 1, 2)/sqrt(size(motion_w, 2));
semmotion_o = std(motion_o, 1, 2)/sqrt(size(motion_o, 2));
semmotion_wo = std(motion_wo, 1, 2)/sqrt(size(motion_wo, 2));
semmotion_post_wtet = std(motion_post_wtet, 1, 2)/sqrt(size(motion_post_wtet, 2));
semmotion_post_wotet = std(motion_post_wotet, 1, 2)/sqrt(size(motion_post_wotet, 2));


figure('units', 'pixels','Position', [0,0,500,450]);
ax = gca;
ax.Units = 'pixels';
ax.Position = [105, 95, 350, 300];

set(gca,'FontSize', 15, 'FontWeight', 'normal'); 

ylabel('P(ΔMotion)', 'FontSize', 15);
hold on
CF = [79, 194, 232]/255;
WCF = [26, 47, 171]/255;
plot(smooth(motion_w(win(1):win(2)), 5), 'Color', [0 0 0 0.5], 'LineStyle', '-.','LineWidth', 2)
%plot(smooth(motion_o(win(1):win(2)), 5), 'Color', [CF, 0.5], 'LineStyle', '-.','LineWidth', 3)
%plot(smooth(motion_wo(win(1):win(2)), 5), 'Color', [WCF, 0.5], 'LineStyle', '-.','LineWidth', 3)
plot(smooth(motion_post_wtet(win(1):win(2)), 5), 'Color', 'k', 'LineStyle', '-.', 'LineWidth', 2)
plot(smooth(motion_post_wotet(win(1):win(2)), 5), 'Color', 'k',  'LineWidth', 2)
%legend('W (Pre)', 'CF', 'W-CF', 'W (Post RWS)', 'W (Post RWS-CF)');
legend('Pre', 'Post RWS', 'Post RWS-CF', 'FontSize', 15, 'Box', 'off');



xticks([0 7.75 15.5 23.25 32])
yticks([])
xticklabels([0 250 500 750 1000])
xlabel('msec', 'FontSize', 15)
ylabel('P(ΔMotion)', 'FontSize', 15)
yticklabels([])

ylim([-0.005 0.15])

if strcmp(choose_norm, 'norm')
    yticks([0 0.1])
end

box off


motionpertrial.motion_w = motion_w;
motionpertrial.motion_o = motion_o;
motionpertrial.motion_wo = motion_wo;
motionpertrial.motion_post_wtet = motion_post_wtet;
motionpertrial.motion_post_wotet = motion_post_wotet;

motionpertrial.semmotion_w = semmotion_w;
motionpertrial.semmotion_o = semmotion_o;
motionpertrial.semmotion_wo = semmotion_wo;
motionpertrial.semmotion_post_wtet = semmotion_post_wtet;
motionpertrial.semmotion_post_wotet = semmotion_post_wotet;

print('-dtiff', '-r300', savename);

end

function plotWithSEM(x, data, SEM, color)
    upperBound = data + SEM;
    lowerBound = data - SEM;
    fill([x fliplr(x)], [upperBound fliplr(lowerBound)], 'k', 'EdgeColor', 'none', 'FaceAlpha', 0.2);
    plot(x, data, 'Color', color, 'LineWidth', 2);
end
