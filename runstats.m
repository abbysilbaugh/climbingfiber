function [stats] = runstats(sample1, sample2, pairedorunpaired)
    % Initialize output structure
    stats = struct();

    % Get rid of NaN values based on the mode selected
    if strcmp(pairedorunpaired, 'paired')
        % Cleaning NaNs in a way that keeps pairs aligned
        sample_1 = sample1(~isnan(sample1) & ~isnan(sample2));
        sample_2 = sample2(~isnan(sample1) & ~isnan(sample2));

        % Test for normality
        [h1, pValue1] = lillietest(sample_1);
        [h2, pValue2] = lillietest(sample_2);

        % Check normality and perform tests
        if pValue1 > 0.05 && pValue2 > 0.05 % If both samples are normally distributed
            stats.normality = 'Both Normal';
            [h, p, ci, statistics] = ttest(sample_1, sample_2);
            effectSize = statistics.tstat / sqrt(length(sample_1)); % Cohen's d
            stats.p = p; stats.effectSize = effectSize;
        else % If any of the samples are not normally distributed
            stats.normality = 'Not Normal';
            [p, h, statistics] = signrank(sample_1, sample_2);
            effectSize = (statistics.zval / sqrt(length(sample_1))); % Rank-biserial correlation
            stats.p = p; stats.effectSize = effectSize;
        end

    elseif strcmp(pairedorunpaired, 'unpaired')
        % Cleaning NaNs independently
        sample_1 = sample1(~isnan(sample1));
        sample_2 = sample2(~isnan(sample2));

        % Test for normality
        [h1, pValue1] = lillietest(sample_1);
        [h2, pValue2] = lillietest(sample_2);

        % Check normality and perform tests
        if pValue1 > 0.05 && pValue2 > 0.05 % If both samples are normally distributed
            stats.normality = 'Both Normal';
            [h, p, ci, statistics] = ttest2(sample_1, sample_2);
            effectSize = calculateCohenD(sample_1, sample_2); % Cohen's d for unpaired data
            stats.p = p; stats.effectSize = effectSize;
        else % If any of the samples are not normally distributed
            stats.normality = 'Not Normal';
            [p, h, statistics] = ranksum(sample_1, sample_2);
            effectSize = calculateRankBiserialEffectSize(statistics.ranksum, length(sample_1), length(sample_2)); % Rank-biserial correlation approximation
            stats.p = p; stats.effectSize = effectSize;
        end
    end
end

function d = calculateCohenD(x1, x2)
    % Calculate Cohen's d for unpaired data
    nx1 = length(x1);
    nx2 = length(x2);
    pooled_std = sqrt(((nx1 - 1)*std(x1)^2 + (nx2 - 1)*std(x2)^2) / (nx1 + nx2 - 2));
    d = (mean(x1) - mean(x2)) / pooled_std;
end

function rbc = calculateRankBiserialEffectSize(ranksum, n1, n2)
    % Calculate rank biserial correlation as an effect size for ranksum test
    U = ranksum - (n1 * (n1 + 1)) / 2;
    rbc = 1 - 2 * U / (n1 * n2);
end
