function BT_mice = getBTmice(allData)

BT_mice = [];
c = 1;
for i = 1:length(allData.data)
    trialtype = allData.data{i}.trialType;

    wotrials = strcmp(trialtype, 'WO');

    wotrials = sum(wotrials);
    if wotrials > 1
        BT_mice(c) = i;
        c = c+1;
    end

end

end