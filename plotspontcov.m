function plotspontcov(allData, mouse, period)

cellTypes = allData.data{mouse}.cellType;

PNs = strcmp(cellTypes, 'PN');

signal = allData.data{mouse}.golayshift(period(1):period(2), PNs);

covdata = calccov(signal, true);

end