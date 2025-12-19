% adds to allData.data{mouse}...
    % motdif (nTrials x 1)
    % prestim (nTrials x 1)
    % poststim  (nTrials x 1)
    % trialmotType  (nTrials x 1)

% Function notes:
    % Finds trial types

    
function [allData] = gettransition(allData, pre_win, post_win, NM_thresh, T_thresh, M_thresh, H_thresh, toplot)

nMice = size(allData.data, 2);

storemotdif = cell(nMice, 1);
storeprestim = cell(nMice, 1);
storepoststim = cell(nMice, 1);

for i = 1:nMice
    motion = allData.data{i}.motionInfo;

    [nFrames, nTrials] = size(motion);

    motdif = zeros(nTrials, 1);
    prestim = zeros(nTrials, 1);
    poststim = zeros(nTrials, 1);
    trialmotType = cell(nTrials, 1);

    % Find # motion frames in pre and post stim windows, take difference
    for j = 1:nTrials
        prestim(j) = sum(motion(pre_win(1):pre_win(2), j));
        poststim(j) = sum(motion(post_win(1):post_win(2), j));
        motdif(j) = poststim(j) - prestim(j);

        % NM (no motion) trial is one without motion in both pre and post periods
        if prestim(j) <= NM_thresh(1) && poststim(j) <= NM_thresh(2)
            trialmotType{j} = 'NM';

        % T (transition) trial is one without motion in pre and motion in
        % post
        elseif prestim(j) <= T_thresh(1) && poststim(j) >= T_thresh(2)
            trialmotType{j} = 'T';

        % M (motion) trial is one with motion in both pre and post periods
        elseif prestim(j) >= M_thresh(1) && poststim(j) >= M_thresh(2)
            trialmotType{j} = 'M';

        % H (halt) trial is one with motion in pre but not post
        elseif prestim(j) >= H_thresh(1) && poststim(j) <= H_thresh(2)
            trialmotType{j} = 'H';
        end


    end

allData.data{i}.motdif = motdif;
allData.data{i}.prestim = prestim;
allData.data{i}.poststim = poststim;
allData.data{i}.trialmotType = trialmotType;
storemotdif{i} = motdif;
storeprestim{i} = prestim;
storepoststim{i} = poststim;

%figure;
% scatter(allData.data{i}.prestim, allData.data{i}.poststim, 'k', 'filled', 'o', 'MarkerFaceAlpha', 0.2);
% hold on
% xlabel('# Mot Pre')
% ylabel('# Mot Post')


end

if strcmp(toplot, 'yesplot')

    figure;
    storemotdif = cell2mat(storemotdif);
    storemotdif = abs(storemotdif);
    
    
    storeprestim = cell2mat(storeprestim); storepoststim = cell2mat(storepoststim);
    histogram(storemotdif, 5, 'FaceAlpha', 0.2, 'FaceColor', 'k')
    hold on
    xlabel('Motdif (# frames post - # frames pre)')
    ylabel('Number of Trials')
    
    
    figure;
    scatter(storeprestim, storepoststim, 100, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.05)
end



end