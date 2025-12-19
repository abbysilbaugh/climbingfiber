% Edited 1/22/24
function [allData] = excludecellstraces(allData, SNR, SNRthresh, SNRmin, delta_b_oasis_thresh, trace_b_thresh, spike_after_peak, peak_win, spike_win)


nMice = size(allData.data, 2);
stimOn = 310;

for i = 1:nMice

    [~, nCells, nTrials] = size(allData.data{i}.golayshift);

    mouse_SNR = SNR{i};
    mouse_b_oasis = allData.data{i}.b_oasis;
    mouse_traces = allData.data{i}.golayshift;
    mouse_peaks = cell2mat(allData.data{i}.firstpeaktime);
    mouse_spikes = cell2mat(allData.data{i}.firstspike);

    reject = zeros(nCells, nTrials);
    reject_cells = zeros(nCells, 1);

    for j = 1:nCells

        if SNRthresh{1}
            cell_SNR = mouse_SNR{j};
            if cell_SNR >= SNRthresh{2}
                reject(j, :) = true;
                reject_cells(j) = true;
            end
        end

        if SNRmin{1}
            cell_SNR = mouse_SNR{j};
            if cell_SNR <= SNRmin{2}
                reject(j, :) = true;
                reject_cells(j) = true;
            end
        end

        if delta_b_oasis_thresh{1}
            cell_b_oasis = mouse_b_oasis(j, :);
            if var(cell_b_oasis) >= delta_b_oasis_thresh{2}
                reject(j, :) = true;
                reject_cells(j) = true;
            end
        end

        for k = 1:nTrials
            single_trace = mouse_traces(:, j, k);
            single_peak = mouse_peaks(j, k);
            single_spike = mouse_spikes(j, k);
            single_trace_b = mean(single_trace(300:310));

            if trace_b_thresh{1}
                if single_trace_b >= trace_b_thresh{2}
                    reject(j, k) = true;
                end
            end

            % Another way of thinking about non-evoked
            if spike_after_peak{1}
                if single_spike > single_peak || isnan(single_spike) || isnan(single_peak)
                    reject(j, k) = true;
                end
            end

            % If peak occurs after window
            if peak_win{1}
                if single_peak >= (stimOn + peak_win{2})
                    reject(j, k) = true;
                end
            end

            % If spike occurs after window
            if spike_win{1}
                if single_spike >= (stimOn + spike_win{2})
                    reject(j, k) = true;
                end
            end

            if i == 15
                reject(j, k) = true;
                reject_cells(j) = true;
            end

        end
    end

    allData.data{i}.reject = reject;
    allData.data{i}.reject_cells = reject_cells;
end


end