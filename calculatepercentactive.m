function [RWS_prctactive, RWSCF_prctactive] = calculatepercentactive(RWS_pre, RWS_pre_MT, RWS_post, RWS_post_MT, RWSCF_pre, RWSCF_pre_MT, RWSCF_post, RWSCF_post_MT)

% RWS experiment
[nMice, ncellType] = size(RWS_pre);
RWS_prctactive = cell(nMice, ncellType);

for i = 1:nMice
    for j = 1:ncellType
        temp_pre = RWS_pre{i, j};
        temp_pre_MT = RWS_pre_MT{i, j};
        temp_post = RWS_post{i, j};
        temp_post_MT = RWS_post_MT{i, j};

        temp = cat(3, temp_pre, temp_post);
        temp_MT = cat(3, temp_pre_MT, temp_post_MT);

        [~, nCells, ~] = size(temp);
        count_temp = NaN(nCells, 1);
        count_temp_MT = NaN(nCells, 1);
        for k = 1:nCells
            getcell_temp = squeeze(temp(1, k, :));
            count_temp(k) = sum(~isnan(getcell_temp));
            getcell_temp_MT = squeeze(temp_MT(1, k, :));
            count_temp_MT(k) = sum(~isnan(getcell_temp_MT));
        end

        RWS_prctactive{i, j} = (count_temp_MT./count_temp)*100;


    end
end

% RWSCF experiment
[nMice, ncellType] = size(RWSCF_pre);
RWSCF_prctactive = cell(nMice, ncellType);

for i = 1:nMice
    for j = 1:ncellType
        temp_pre = RWSCF_pre{i, j};
        temp_pre_MT = RWSCF_pre_MT{i, j};
        temp_post = RWSCF_post{i, j};
        temp_post_MT = RWSCF_post_MT{i, j};

        temp = cat(3, temp_pre, temp_post);
        temp_MT = cat(3, temp_pre_MT, temp_post_MT);

        [~, nCells, ~] = size(temp);
        count_temp = NaN(nCells, 1);
        count_temp_MT = NaN(nCells, 1);
        for k = 1:nCells
            getcell_temp = squeeze(temp(1, k, :));
            count_temp(k) = sum(~isnan(getcell_temp));
            getcell_temp_MT = squeeze(temp_MT(1, k, :));
            count_temp_MT(k) = sum(~isnan(getcell_temp_MT));
        end

        RWSCF_prctactive{i, j} = (count_temp_MT./count_temp)*100;


    end
end

RWS_prctactive = mouseconcatenate(RWS_prctactive);
RWSCF_prctactive = mouseconcatenate(RWSCF_prctactive);


    
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

        PV = cat(1, PV, PV_temp);
        PN = cat(1, PN, PN_temp);
        VIP = cat(1, VIP, VIP_temp);
        UC = cat(1, UC, UC_temp);
        SST = cat(1, SST, SST_temp);
    end

    variable = {PV, PN, VIP, UC, SST};

end