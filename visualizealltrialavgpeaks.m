function visualizetrialavgpeaks(allData)

nMice = length(allData.data);

nFrames = size(allData.data{1}.ac_bs_signal, 1);
nBins = nFrames;
allmicehist_pks = zeros(nBins, nMice);

for i = 1:nMice
    golayshift = allData.data{i}.golayshift;
    avgpkLocs = allData.data{i}.avgpkLocs;

    [~, nCells, nTrials] = size(golayshift);
    
    figure('Position', [50 50 1500 500]);
    allmicehist_spks(:, i) = h.Values;
    binedges = h.BinEdges;
    hold on
    pkvec = avgpkLocs(:); pkvec = cell2mat(pkvec); h = histogram(pkvec, nBins, 'FaceAlpha', 0.5, 'FaceColor', 'r', 'EdgeColor', 'none','Normalization', 'probability');
    allmicehist_pks(:, i) = h.Values;
    legend('Spike', 'Peak')
    ylabel('Probability')
    x = linspace(0, 620, 11);
    xticks(x)
    x2 = linspace(-10, 10, 11);
    xticklabels(x2)
    xlabel('Time from Stimulus Onset (s)')
    title(['Mouse ', num2str(i)])
    
end

figure('Position', [50 50 1500 500]);
allmicehist_pks = sum(allmicehist_pks, 2)/nMice;
allmicehist_spks = sum(allmicehist_spks, 2)/nMice;
histogram('BinEdges', binedges, 'BinCounts', allmicehist_spks, 'FaceAlpha', 0.2, 'FaceColor', 'k', 'EdgeColor', 'none')
hold on
histogram('BinEdges', binedges, 'BinCounts', allmicehist_pks, 'FaceAlpha', 0.5, 'FaceColor', 'r', 'EdgeColor', 'none')
legend('Spike', 'Peak', 'FontSize', 12, 'location', 'best', 'Box', 'off')
ylabel('Probability', 'FontSize', 12)
x = linspace(0, 620, 11);
xlim([0 620])
xticks(x)
x2 = linspace(-10, 10, 11);
xticklabels(x2)
xlabel('Time from Stimulus Onset (s)')
title('Global Event Probability')

end