function allData = setcontrolpost(allData, controlmice)

for i = controlmice
    tet = allData.data{i}.tetPeriod;

    for j = 1:length(tet)
        if j > 80
            tet{j} = 'POST';
        end
    end

    allData.data{i}.tetPeriod = tet;
end