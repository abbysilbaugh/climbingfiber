function [cond1, cond2] = bothcond(cond1, cond2)

for i = 1:length(cond1)
        % Find indices of cells in both conditions
        temp = cond1{i};
        find_c1 = ~isnan(temp(1, :));
        
        temp = cond2{i};
        find_c2 = ~isnan(temp(1, :));

        hasboth = find_c1 + find_c2;
        hasboth = hasboth == 2;

        % Keep cells in both conditions
        cond1{i} = cond1{i}(:, hasboth);
        cond2{i} = cond2{i}(:, hasboth);

        % Find number of cells included in both conditions
        sz1 = sum(hasboth);
        sz2 = sum(size(temp, 2));

end

end