function plotalltraces_troubleshoot(allData, mouse1, mouse2, tracetype)

for m = mouse1:mouse2

    if strcmp(tracetype, 'golaysignal')
        testtraces = allData.data{1, m}.golaysignal;
    elseif strcmp(tracetype, 'golaysignal2')
        testtraces = allData.data{1, m}.golaysignal2;
    elseif strcmp(tracetype, 'golaysignal3')
        testtraces = allData.data{1, m}.golaysignal3;
    end
    
    ntestcells = size(testtraces, 2)
    ntesttrials = size(testtraces, 3)
    
    
    figure;
    for i = 1:ntestcells
        for j = 1:ntesttrials
    
            plot(testtraces(:, i, j), 'Color', [0 0 0 0.1])
            hold on
    
        end
    end

end

end

