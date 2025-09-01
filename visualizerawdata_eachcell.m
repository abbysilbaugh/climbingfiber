% plots individual trials separately. Each neuron is individually plotted.
% Plots rawminusfirstprctile or ac_bs_signal for specified mouse

function visualizerawdata_eachcell(allData, mousetoplot, choosetype)

if strcmp(choosetype, 'rawminusfirstprctile')
    traces = allData.data{mousetoplot}.rawminusfirstprctile;
elseif strcmp(choosetype, 'ac_bs_signal')
    traces = allData.data{mousetoplot}.ac_bs_signal;
end
[nFrames, nCells, nTrials] = size(traces);
    for i = 1:size(traces, 3)
        figure('Position', [76,179,1809,420]);
        for j = 1:nCells
            plot(traces(:, j, i), 'Color', [0 0 0 0.2])
            hold on
        end
        ylabel('Arbitrary Units')
        xticks([0 62 124 186 248 310 372 434 496 558 620])
        xticklabels([-10 -8 -6 -4 -2 0 2 4 6 8 10])
        xlabel('Seconds')
        xline(310, 'Color', 'r')
        ylim([0 15000])
    end
end