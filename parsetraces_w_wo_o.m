% For each condition...
        % Output: nMice x nCelltype cell array; each cell contains nFrames x nCells x nTrials

    % If trialavg (~cellavg and ~catmouse)...
        % Each cell is trial averaged within mice (NaN trials are not included)
        % Output: nMice x nCelltype cell array; each cell contains nFrames x nCells double
        
    % If trialavg & cellaverage (~catmouse)_...
        % Each cell is trial averaged within mice (NaN trials are not included)
        % Cells are averaged within mouse
        % Output: nMice x nCelltype cell array; each cell contains nFrames x 1 double

    % If trialavg & and catmouse (~cellavg)...
        % Each cell is trial averaged within mice
        % All cells are concatenated across mice
        % Output: 1 x nCelltype cell array; each cell contains nFrames x nTotalCells

    % If trialavg & cellaverage & catmouse...
        % Each cell is trial averaged within mice
        % All cells within mice are averaged
        % Output: 1 x nCelltype cell array; each cell contains nFrames x nMice
       
function [pre_w, pre_wo, pre_o]...
    = parsetraces_w_wo_o(baselineshiftperiod, baselineshift, baseline_reject_thresh, trialavg, cellavg, catmouse, mottype, allData, signaltype, setmice)

nMice = size(allData.data, 2);

% Compile basic transmission data
pre_w = cell(nMice, 5);
pre_wo = cell(nMice, 5);
pre_o = cell(nMice, 5);
for i = setmice.BT_mice
    [pre_w{i, 1}, pre_wo{i, 1}, pre_o{i, 1}] = parsemouse_w_wo_o(mottype, 'PV', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [pre_w{i, 2}, pre_wo{i, 2}, pre_o{i, 2}] = parsemouse_w_wo_o(mottype, 'PN', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [pre_w{i, 3}, pre_wo{i, 3}, pre_o{i, 3}] = parsemouse_w_wo_o(mottype, 'VIP', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [pre_w{i, 4}, pre_wo{i, 4}, pre_o{i, 4}] = parsemouse_w_wo_o(mottype, 'UC', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
    [pre_w{i, 5}, pre_wo{i, 5}, pre_o{i, 5}] = parsemouse_w_wo_o(mottype, 'SST', allData, i, signaltype, baselineshift, baselineshiftperiod, baseline_reject_thresh, trialavg);
end

pre_w = pre_w(setmice.BT_mice, :);
pre_wo = pre_wo(setmice.BT_mice, :);
pre_o = pre_o(setmice.BT_mice, :);

if cellavg
    pre_w = cellaverage(pre_w);
    pre_wo = cellaverage(pre_wo);
    pre_o = cellaverage(pre_o);
end

if catmouse
    pre_w = mouseconcatenate(pre_w);
    pre_wo = mouseconcatenate(pre_wo);
    pre_o = mouseconcatenate(pre_o);
end

end

function variable = cellaverage(variable)
    for w = 1:size(variable, 1)
        for x = 1:size(variable, 2)
            temp = variable{w, x};
            temp = mean(temp, 2, 'omitnan');
            variable{w, x} = temp;
        end
    end

end

function variable = mouseconcatenate(variable)
    PV = [];
    PN = [];
    VIP = [];
    UC = [];
    SST = [];
    for y = 1:size(variable, 1)
        PV_temp = variable{y, 1};
        PN_temp = variable{y, 2};
        VIP_temp = variable{y, 3};
        UC_temp = variable{y, 4};
        SST_temp = variable{y, 5};

        PV = cat(2, PV, PV_temp);
        PN = cat(2, PN, PN_temp);
        VIP = cat(2, VIP, VIP_temp);
        UC = cat(2, UC, UC_temp);
        SST = cat(2, SST, SST_temp);
    end

    variable = {PV, PN, VIP, UC, SST};

end