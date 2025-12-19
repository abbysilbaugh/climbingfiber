function [allData] = getmotcells(allData, corrthresh, mottype)

nMice = size(allData.data, 2);



for i = 1:nMice

    if strcmp(mottype, 'correlation')
        cellmot = allData.data{i}.cellxmot;
    elseif strcmp(mottype, 'modidx')
        cellmot = allData.data{i}.modulationidx;
    end

        nCells = length(cellmot);

    cellmotType = cell(nCells, 1);
    for j = 1:nCells
        if cellmot(j) < -(corrthresh)
            cellmotType{j} = 'NEG';
        elseif cellmot(j) > (corrthresh)
            cellmotType{j} = 'POS';
        else
            cellmotType{j} = 'NONE';
        end
    end

    allData.data{i}.cellmotType = cellmotType;


end