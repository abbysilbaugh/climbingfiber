function plotTHRESHcells_trialpool(allData, cellType, cellmotType, trialmotType, variable, exclude, ylimit, xlimit, norm, gettitle, savename)

[PSI_4, PSI_4_vartype] = grabTHRESHdata(allData, cellType, cellmotType, 'W', trialmotType, 'all', variable, exclude, 'PSI_4');
[PSI_4, PSI_4_vartype] = trialavg(PSI_4, PSI_4_vartype);
PSI_4 = PSI_4{1};


[PSI_6, PSI_6_vartype] = grabTHRESHdata(allData, cellType, cellmotType, 'W', trialmotType, 'all', variable, exclude, 'PSI_6');
[PSI_6, PSI_6_vartype] = trialavg(PSI_6, PSI_6_vartype);
PSI_6 = PSI_6{1};

[PSI_8, PSI_8_vartype] = grabTHRESHdata(allData, cellType, cellmotType, 'W', trialmotType, 'all', variable, exclude, 'PSI_8');
[PSI_8, PSI_8_vartype] = trialavg(PSI_8, PSI_8_vartype);
PSI_8 = PSI_8{1};

[PSI_10, PSI_10_vartype] = grabTHRESHdata(allData, cellType, cellmotType, 'W', trialmotType, 'all', variable, exclude, 'PSI_10');
[PSI_10, PSI_10_vartype] = trialavg(PSI_10, PSI_10_vartype);
PSI_10 = PSI_10{1};

[PSI_12, PSI_12_vartype] = grabTHRESHdata(allData, cellType, cellmotType, 'W', trialmotType, 'all', variable, exclude, 'PSI_12');
[PSI_12, PSI_12_vartype] = trialavg(PSI_12, PSI_12_vartype);
PSI_12 = PSI_12{1};

nCells = length(PSI_4);
mu = zeros(1,5);

figure;
for i = 1:nCells
    x = [4 6 8 10 12];

    if norm
        y = [PSI_4(i)/PSI_4(i), PSI_6(i)/PSI_4(i), PSI_8(i)/PSI_4(i), PSI_10(i)/PSI_4(i), PSI_12(i)/PSI_4(i)];
        ylabel('Norm. ΔF/F0')
    else
        y = [PSI_4(i), PSI_6(i), PSI_8(i), PSI_10(i), PSI_12(i)];
        ylabel('ΔF/F0')
    end
    mu = mu + y;
    plot(x,y, 'Marker', 'o')
    hold on
    xticks([4 6 8 10 12])
    xlabel('PSI')
end

% Plot mean
mu = mu ./ nCells;
plot(x,mu,'Marker','.','Color','k','LineWidth',5)

if strcmp(trialmotType, 'NM')
    title('ROI Avg Peak Amp. (Rest Trials)')
elseif strcmp(trialmotType, 'M')
    title('ROI Avg Peak Amp. (Run Trials)')
elseif strcmp(trialmotType, 'T')
    title('ROI Avg Peak Amp. (Transition Trials)')
elseif strcmp(trialmotType, 'all')
    title('ROI Avg Peak Amp. (All Trials)')
end


end

