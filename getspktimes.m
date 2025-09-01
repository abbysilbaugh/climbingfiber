% edited 3/1/24
% edited 9/9/24 to reduce redundancy

  % spkLocs (nCells x nTrials)

function [allData] = getspktimes(allData)

nMice = size(allData.data, 2);

for i = 1:nMice
%     if strcmp(signaltype, 'golayshift')
%         signal = allData.data{i}.golayshift;
%     elseif strcmp(signaltype, 'golaysignal')
%         signal = allData.data{i}.golaysignal;
%     elseif strcmp(signaltype, 'golaysignal2')
%         signal = allData.data{i}.golaysignal2;
%     elseif strcmp(signaltype, 'golaysignal3')
%         signal = allData.data{i}.golaysignal3;
%     elseif strcmp(signaltype, 'golaysignal4')
%         signal = allData.data{i}.golaysignal4;
%     end

    spiketimes = allData.data{i}.spiketimes;

    [~, nNeurons, nTrials] = size(spiketimes);
    
%     amps = cell(nCells, nTrials);
%     pkLocs = cell(nCells, nTrials);
    spkLocs = cell(nNeurons, nTrials);
%     prom = cell(nCells, nTrials);
%     width = cell(nCells, nTrials);

    for j = 1:nNeurons
%         bNoise = baselineNoise{i}{j};
        for k = 1:nTrials

%             trace = signal(:, j, k);
            spikes = spiketimes(:, j, k);
            spktime = find(spikes);
            for f = 1:length(spktime)
                tempspk = spktime(f);
                if tempspk > 615 || tempspk < 5
                    spktime(f) = NaN;
                end
            end

            spkLocs{j, k} = spktime;

%             [amps{j, k}, pkLocs{j, k}, width{j, k}, prom{j, k}] = findpeaks(trace, 'MinPeakProminence', peaks_thr*bNoise);

        end
    end

%     allData.data{i}.amps = amps;
%     allData.data{i}.pkLocs = pkLocs;
    allData.data{i}.spkLocs = spkLocs;

end