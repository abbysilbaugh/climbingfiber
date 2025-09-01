function visualizebaseline(allData)

nMice = length(allData.data);

for i = 1:nMice
    figure;
    motion = allData.data{i}.motionInfo;
    motion = motion(:)*1000;
    signal = allData.data{i}.raw_signal;
    signal = squeeze(mean(signal, 2));
    signal = signal(:);
    baseline = allData.data{i}.baseline_signal;
    baseline = baseline(:);
    plot(baseline)
    hold on
    plot(signal)
    plot(motion)


end