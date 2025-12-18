function [m1_cond1, m1_cond2, m2_cond1, m2_cond2] = plotmotionproportion(proportion_mot_trials, mice, mice2, condition1, condition2, combineactive)

        % Mouse 1, condition 1 (m1_cond1)
        if strcmp(condition1, 'pre_w')
            m1_cond1 = proportion_mot_trials.proportion_pre_w(mice); % each cell contains proportion of trials in NM, M, T conditions, respectively
        elseif strcmp(condition1, 'pre_wo')
            m1_cond1 = proportion_mot_trials.proportion_pre_wo(mice);
        elseif strcmp(condition1, 'dcz_w')
            m1_cond1 = proportion_mot_trials.proportion_dcz_w(mice);
        elseif strcmp(condition1, 'dcz_wo')
            m1_cond1 = proportion_mot_trials.proportion_dcz_wo(mice);
        elseif strcmp(condition1, 'post')
            m1_cond1 = proportion_mot_trials.proportion_post(mice);
        end
        
        % Mouse 1, condition 2 (m1_cond2)
        if strcmp(condition2, 'pre_w')
            m1_cond2 = proportion_mot_trials.proportion_pre_w(mice); % each cell contains proportion of trials in NM, M, T conditions, respectively
        elseif strcmp(condition2, 'pre_wo')
            m1_cond2 = proportion_mot_trials.proportion_pre_wo(mice);
        elseif strcmp(condition2, 'dcz_w')
            m1_cond2 = proportion_mot_trials.proportion_dcz_w(mice);
        elseif strcmp(condition2, 'dcz_wo')
            m1_cond2 = proportion_mot_trials.proportion_dcz_wo(mice);
        elseif strcmp(condition2, 'post')
            m1_cond2 = proportion_mot_trials.proportion_post(mice);
        end
        
        % Mouse 2, condition 1 (m2_cond1)
        if strcmp(condition1, 'pre_w')
            m2_cond1 = proportion_mot_trials.proportion_pre_w(mice2); % each cell contains proportion of trials in NM, M, T conditions, respectively
        elseif strcmp(condition1, 'pre_wo')
            m2_cond1 = proportion_mot_trials.proportion_pre_wo(mice2);
        elseif strcmp(condition1, 'dcz_w')
            m2_cond1 = proportion_mot_trials.proportion_dcz_w(mice2);
        elseif strcmp(condition1, 'dcz_wo')
            m2_cond1 = proportion_mot_trials.proportion_dcz_wo(mice2);
        elseif strcmp(condition1, 'post')
            m2_cond1 = proportion_mot_trials.proportion_post(mice2);
        end
        
        % Mouse 2, condition 2 (m2_cond2)
        if strcmp(condition2, 'pre_w')
            m2_cond2 = proportion_mot_trials.proportion_pre_w(mice2);
        elseif strcmp(condition2, 'pre_wo')
            m2_cond2 = proportion_mot_trials.proportion_pre_wo(mice2);
        elseif strcmp(condition2, 'dcz_w')
            m2_cond2 = proportion_mot_trials.proportion_dcz_w(mice2);
        elseif strcmp(condition2, 'dcz_wo')
            m2_cond2 = proportion_mot_trials.proportion_dcz_wo(mice2);
        elseif strcmp(condition2, 'post')
            m2_cond2 = proportion_mot_trials.proportion_post(mice2);
        end
        
        % Convert cell arrays to matrices
        % Contains data in the following order: R, M, T, H
        m1_cond1 = cell2mat(m1_cond1);
        m1_cond2 = cell2mat(m1_cond2);
        m2_cond1 = cell2mat(m2_cond1);
        m2_cond2 = cell2mat(m2_cond2);
        
        
        if strcmp(combineactive, 'combineactive')
            % Combine M and T trials
            m1_cond1 = combineruntransition(m1_cond1);
            m1_cond2 = combineruntransition(m1_cond2);
            m2_cond1 = combineruntransition(m2_cond1);
            m2_cond2 = combineruntransition(m2_cond2);
        
            % Paired t-test: m1_cond1 vs. m1_cond2 (same mice, different conditions)
            [h, p] = ttest(m1_cond1(:, 1), m1_cond2(:, 1));
            fprintf('Group 1 NM: p = %.4f\n', p);
            [h, p] = ttest(m1_cond1(:, 2), m1_cond2(:, 2));
            fprintf('Group 1 MT: p = %.4f\n',p);
            [h, p] = ttest(m1_cond1(:, 3), m1_cond2(:, 3));
            fprintf('Group 1 H: p = %.4f\n',p);
            
            % Paired t-test: m2_cond1 vs. m2_cond2 (same mice, different conditions)
            [h, p] = ttest(m2_cond1(:, 1), m2_cond2(:, 1));
            fprintf('Group 2 NM: p = %.4f\n',p);
            [h, p] = ttest(m2_cond1(:, 2), m2_cond2(:, 2));
            fprintf('Group 2 MT: p = %.4f\n',  p);
            [h, p] = ttest(m2_cond1(:, 3), m2_cond2(:, 3));
            fprintf('Group 2 H: p = %.4f\n', p);
            
            % Unpaired t-test: m1_cond1 vs. m2_cond1 (different mice, same condition)
            [h, p] = ttest2(m1_cond1(:, 1), m2_cond1(:, 1));
            fprintf('Group 1 vs. Group 2 NM: p = %.4f\n', p);
            [h, p] = ttest2(m1_cond1(:, 2), m2_cond1(:, 2));
            fprintf('Group 1 vs. Group 2 MT: p = %.4f\n',  p);
            [h, p] = ttest2(m1_cond1(:, 3), m2_cond1(:, 3));
            fprintf('Group 1 vs. Group 2 H: p = %.4f\n',  p);
            
            % Unpaired t-test: m1_cond2 vs. m2_cond2 (different mice, same condition)
            [h, p] = ttest2(m1_cond2(:, 1), m2_cond2(:, 1));
            fprintf('Group 1 vs. Group 2 NM: p = %.4f\n',  p);
            [h, p] = ttest2(m1_cond2(:, 2), m2_cond2(:, 2));
            fprintf('Group 1 vs. Group 2 MT: p = %.4f\n', p);
            [h, p] = ttest2(m1_cond2(:, 3), m2_cond2(:, 3));
            fprintf('Group 1 vs. Group 2 H: p = %.4f\n',  p);
        
        else
            % Paired t-test: m1_cond1 vs. m1_cond2 (same mice, different conditions)
            [h, p] = ttest(m1_cond1(:, 1), m1_cond2(:, 1));
            fprintf('Group 1 NM: p = %.4f\n', p);
            [h, p] = ttest(m1_cond1(:, 2), m1_cond2(:, 2));
            fprintf('Group 1 M: p = %.4f\n',p);
            [h, p] = ttest(m1_cond1(:, 3), m1_cond2(:, 3));
            fprintf('Group 1 T: p = %.4f\n',p);
            [h, p] = ttest(m1_cond1(:, 4), m1_cond2(:, 4));
            fprintf('Group 1 H: p = %.4f\n',p);
            
            % Paired t-test: m2_cond1 vs. m2_cond2 (same mice, different conditions)
            [h, p] = ttest(m2_cond1(:, 1), m2_cond2(:, 1));
            fprintf('Group 2 NM: p = %.4f\n',p);
            [h, p] = ttest(m2_cond1(:, 2), m2_cond2(:, 2));
            fprintf('Group 2 M: p = %.4f\n',  p);
            [h, p] = ttest(m2_cond1(:, 3), m2_cond2(:, 3));
            fprintf('Group 2 T: p = %.4f\n', p);
            [h, p] = ttest(m2_cond1(:, 4), m2_cond2(:, 4));
            fprintf('Group 2 H: p = %.4f\n',  p);
            
            % Unpaired t-test: m1_cond1 vs. m2_cond1 (different mice, same condition)
            [h, p] = ttest2(m1_cond1(:, 1), m2_cond1(:, 1));
            fprintf('Group 1 vs. Group 2 NM: p = %.4f\n', p);
            [h, p] = ttest2(m1_cond1(:, 2), m2_cond1(:, 2));
            fprintf('Group 1 vs. Group 2 M: p = %.4f\n',  p);
            [h, p] = ttest2(m1_cond1(:, 3), m2_cond1(:, 3));
            fprintf('Group 1 vs. Group 2 T: p = %.4f\n',  p);
            [h, p] = ttest2(m1_cond1(:, 4), m2_cond1(:, 4));
            fprintf('Group 1 vs. Group 2 H: p = %.4f\n', p);
            
            % Unpaired t-test: m1_cond2 vs. m2_cond2 (different mice, same condition)
            [h, p] = ttest2(m1_cond2(:, 1), m2_cond2(:, 1));
            fprintf('Group 1 vs. Group 2 NM: p = %.4f\n',  p);
            [h, p] = ttest2(m1_cond2(:, 2), m2_cond2(:, 2));
            fprintf('Group 1 vs. Group 2 M: p = %.4f\n', p);
            [h, p] = ttest2(m1_cond2(:, 3), m2_cond2(:, 3));
            fprintf('Group 1 vs. Group 2 T: p = %.4f\n',  p);
            [h, p] = ttest2(m1_cond2(:, 4), m2_cond2(:, 4));
            fprintf('Group 1 vs. Group 2 H: p = %.4f\n',  p);
        end
        
        % Chi-squared test: m1_cond1 vs m1_cond2
        total_prct = 100; % Convert proportions to percentage (assuming 100% per mouse)
        counts_cond1 = m1_cond1 * total_prct;
        counts_cond2 = m1_cond2 * total_prct;
        
        % Aggregate counts across mice
        total_cond1 = sum(counts_cond1, 1);
        total_cond2 = sum(counts_cond2, 1);
        
        getzeros = (total_cond1 == 0) & (total_cond2 == 0);
        total_cond1 = total_cond1(~getzeros); total_cond2 = total_cond2(~getzeros);
        
        % Construct the contingency table
        contingency_table = [total_cond1; total_cond2];
        [chi2_stat, p_value] = chi2gof(1:size(contingency_table, 2), ...
            'Ctrs', 1:size(contingency_table, 2), ...
            'Frequency', sum(contingency_table, 1));
        % calculate manually
        total_per_category = sum(contingency_table, 1); % Total events per category
        total_per_group = sum(contingency_table, 2); % Total events per group
        grand_total = sum(total_per_category);
        expected = (total_per_group * total_per_category) / grand_total;
        manual_chi2_stat = sum((contingency_table - expected).^2 ./ expected, 'all');
        dof = (size(contingency_table, 1) - 1) * (size(contingency_table, 2) - 1);
        manual_p_value = 1 - chi2cdf(manual_chi2_stat, dof);
        
        % disp('Contingency Table:');
        % disp(contingency_table);
        disp(['Chi-squared Statistic (Exp 1): ', num2str(manual_chi2_stat)]);
        disp(['P-value: ', num2str(manual_p_value)]);
        
        
        % Chi-squared test: m2_cond1, m2_cond2
        counts_cond1 = m2_cond1 * total_prct;
        counts_cond2 = m2_cond2 * total_prct;
        
        % Aggregate counts across mice
        total_cond1 = sum(counts_cond1, 1);
        total_cond2 = sum(counts_cond2, 1);
        
        getzeros = (total_cond1 == 0) & (total_cond2 == 0);
        
        total_cond1 = total_cond1(~getzeros); total_cond2 = total_cond2(~getzeros);
        
        % Construct the contingency table
        contingency_table_2 = [total_cond1; total_cond2];
        [chi2_stat, p_value] = chi2gof(1:size(contingency_table_2, 2), ...
            'Ctrs', 1:size(contingency_table_2, 2), ...
            'Frequency', sum(contingency_table_2, 1));
        % calculate manually
        total_per_category = sum(contingency_table_2, 1); % Total events per category
        total_per_group = sum(contingency_table_2, 2); % Total events per group
        grand_total = sum(total_per_category);
        expected = (total_per_group * total_per_category) / grand_total;
        manual_chi2_stat = sum((contingency_table_2 - expected).^2 ./ expected, 'all');
        dof = (size(contingency_table_2, 1) - 1) * (size(contingency_table_2, 2) - 1);
        manual_p_value = 1 - chi2cdf(manual_chi2_stat, dof);
        
        % Display results
        % disp('Contingency Table:');
        % disp(contingency_table_2);
        disp(['Chi-squared Statistic (Exp 2): ', num2str(manual_chi2_stat)]);
        disp(['P-value: ', num2str(manual_p_value)]);
        
        % Compare m1_cond1 and m2_cond1
        % Convert proportions to percentage
        counts_m1_cond1 = m1_cond1 * total_prct;
        counts_m2_cond1 = m2_cond1 * total_prct;
        
        % Aggregate counts
        total_m1_cond1 = sum(counts_m1_cond1, 1);
        total_m2_cond1 = sum(counts_m2_cond1, 1);
        
        % Construct contingency table
        contingency_table_3 = [total_m1_cond1; total_m2_cond1];
        
        % Perform Chi-squared test
        total_per_category = sum(contingency_table_3, 1); % Total events per category
        total_per_group = sum(contingency_table_3, 2); % Total events per group
        grand_total = sum(total_per_category);
        expected = (total_per_group * total_per_category) / grand_total;
        manual_chi2_stat = sum((contingency_table_3 - expected).^2 ./ expected, 'all');
        dof = (size(contingency_table_3, 1) - 1) * (size(contingency_table_3, 2) - 1);
        manual_p_value = 1 - chi2cdf(manual_chi2_stat, dof);
        
        % Display results
        disp('Comparison: m1_cond1 vs. m2_cond1');
        % disp('Contingency Table:');
        % disp(contingency_table_3);
        disp(['Chi-squared Statistic: ', num2str(manual_chi2_stat)]);
        disp(['P-value: ', num2str(manual_p_value)]);
        
        % Repeat for m1_cond2 vs. m2_cond2
        counts_m1_cond2 = m1_cond2 * total_prct;
        counts_m2_cond2 = m2_cond2 * total_prct;
        
        % Aggregate counts
        total_m1_cond2 = sum(counts_m1_cond2, 1);
        total_m2_cond2 = sum(counts_m2_cond2, 1);
        
        % Construct contingency table
        contingency_table_4 = [total_m1_cond2; total_m2_cond2];
        
        % Perform Chi-squared test
        total_per_category = sum(contingency_table_4, 1); % Total events per category
        total_per_group = sum(contingency_table_4, 2); % Total events per group
        grand_total = sum(total_per_category);
        expected = (total_per_group * total_per_category) / grand_total;
        manual_chi2_stat = sum((contingency_table_4 - expected).^2 ./ expected, 'all');
        dof = (size(contingency_table_4, 1) - 1) * (size(contingency_table_4, 2) - 1);
        manual_p_value = 1 - chi2cdf(manual_chi2_stat, dof);
        
        % Display results
        disp('Comparison: m1_cond2 vs. m2_cond2');
        % disp('Contingency Table:');
        % disp(contingency_table_4);
        disp(['Chi-squared Statistic: ', num2str(manual_chi2_stat)]);
        disp(['P-value: ', num2str(manual_p_value)]);
        
        % visualization
        % figure;
        % subplot(1, 2, 1)
        % pie(contingency_table(1, :))
        % title('m1\_cond1');
        % subplot(1, 2, 2)
        % pie(contingency_table(2, :))
        % title('m1\_cond2');
        % legend('NM', 'M', 'T', 'H');
        % 
        % figure;
        % subplot(1, 2, 1)
        % pie(contingency_table_2(1, :))
        % title('m2\_cond1');
        % subplot(1, 2, 2)
        % pie(contingency_table_2(2, :))
        % title('m2\_cond2');
        % legend('NM', 'M', 'T', 'H');
        
        m1_cond1_mean = mean(m1_cond1, 1);
        m1_cond2_mean = mean(m1_cond2, 1);
        m2_cond1_mean = mean(m2_cond1, 1);
        m2_cond2_mean = mean(m2_cond2, 1);
        
        figure;
        bar([m1_cond1_mean; m1_cond2_mean]*100, 'stacked');
        title('Expt 1');
        if strcmp(combineactive, 'combineactive')
            legend('Rest', 'Active', 'Stop');
        else
            legend('Rest', 'Run', 'Go', 'Stop', 'Location', 'best');
        end
        ylabel('Percentage of trials');
        xticklabels({'Pre', 'Post'});
        ylim([0 100]); % Ensure y-axis represents percentages
        
        figure;
        bar([m2_cond1_mean; m2_cond2_mean]*100, 'stacked');
        title('Expt 2');
        if strcmp(combineactive, 'combineactive')
            legend('Rest', 'Active', 'Stop');
        else
            legend('Rest', 'Run', 'Go', 'Stop', 'Location', 'best');
        end
        ylabel('Percentage of trials');
        xticklabels({'Pre', 'Post'});
        ylim([0 100]);
        xlabel('Mouse');
        
        figure;
        subplot(2, 2, 1)
        h1 = pie(m1_cond1_mean);
        title('Pre (RWS)');
        set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

        subplot(2, 2, 2)
        h2 = pie(m2_cond1_mean);
        title('Pre (RWS+CF)');
        set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

        subplot(2, 2, 3)
        h3 = pie(m1_cond2_mean);
        title('Post (RWS)');
        set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

        subplot(2, 2, 4)
        h4 = pie(m2_cond2_mean);
        title('Post (RWS+CF)');
        set(gca, 'FontSize', 7, 'FontName', 'Helvetica')
        
        
        if strcmp(combineactive, 'combineactive')
            legend('Rest', 'Active', 'Stop');
            
            % Define colors
            colors = [40, 62, 74; 77, 123, 161; 86, 202, 193] / 255;
            
            % Apply colors to the pie charts
            applyPieColors(h1, colors);
            applyPieColors(h2, colors);
            applyPieColors(h3, colors);
            applyPieColors(h4, colors);
        else
            legend('Rest', 'Run', 'Go', 'Stop', 'Location', 'best');
        end
        set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

        


end

function combinedvar = combineruntransition(getvar)
nMice = size(getvar, 1);

combinedvar = zeros(nMice, 3);
for i = 1:nMice
    NM = getvar(i, 1);
    MT = getvar(i, 2) + getvar(i, 3);
    H = getvar(i, 4);

    combinedvar(i, :) = [NM, MT, H];

end

end

function applyPieColors(pieHandles, colors)
    % This function applies the specified colors to a pie chart
    % Pie charts return a sequence of text and patch objects
    piePatches = findobj(pieHandles, 'Type', 'Patch');
    
    for i = 1:min(length(piePatches), size(colors, 1))
        piePatches(i).FaceColor = colors(i, :);
    end
end

