function plotpie(pre, post, pre2, post2, neuron_colors)

% Note: will only work on trialavg = 1 & catmouse = 1 OR trialavg = 1 & cellavg = 1 & catmouse = 1

neuron_names = {'PV', 'PN', 'VIP', 'UC', 'SST'};

% Find neurons with evoked events both pre and post
expt1_PV = [];
expt2_PV = [];
expt1_SST = [];
expt2_SST = [];
for i = 1:length(neuron_names)

pre_selected = pre{i};
post_selected = post{i};
pre2_selected = pre2{i};
post2_selected = post2{i};

find_persistent = sum(~isnan(pre_selected(1, :)) & ~isnan(post_selected(1,:)));
find_persistent_2 = sum(~isnan(pre2_selected(1, :)) & ~isnan(post2_selected(1,:)));

find_recruited = sum(isnan(pre_selected(1, :))  & ~isnan(post_selected(1,:)));
find_recruited_2 = sum(isnan(pre2_selected(1, :))  & ~isnan(post2_selected(1,:)));

find_suppressed = sum(~isnan(pre_selected(1, :))  & isnan(post_selected(1,:)));
find_suppressed_2 = sum(~isnan(pre2_selected(1, :))  & isnan(post2_selected(1,:)));

find_unresponsive = sum(isnan(pre_selected(1, :))  & isnan(post_selected(1,:)));
find_unresponsive_2 = sum(isnan(pre2_selected(1, :))  & isnan(post2_selected(1,:)));

contingency_table = [find_persistent, find_recruited, find_suppressed, find_unresponsive;...
    find_persistent_2, find_recruited_2, find_suppressed_2, find_unresponsive_2];

% Calculate chi-squared manually
observed = contingency_table;

% Row and column sums
row_sums = sum(observed, 2);
col_sums = sum(observed, 1);
total = sum(row_sums);

% Expected frequencies
expected = (row_sums * col_sums) / total;

% Chi-squared statistic
chi2_stat = sum((observed - expected).^2 ./ expected, 'all');

% Degrees of freedom = (rows - 1) * (columns - 1)
df = (2 - 1) * (4 - 1);

% p-value
p_val = 1 - chi2cdf(chi2_stat, df)

color = neuron_colors{i}; % Base color for all slices

% Define alpha values for different categories
alpha_values = [1, 0.6, 0.3, 0]; % recruited, persistent, suppressed, unresponsive

% Define experimental data
expt1 = [find_persistent, find_recruited, find_suppressed, find_unresponsive];
expt2 = [find_persistent_2, find_recruited_2, find_suppressed_2, find_unresponsive_2];

if i ==1 
    expt1_PV = expt1;
    expt2_PV = expt2;
elseif i == 5
    expt1_SST = expt1;
    expt2_SST = expt2;
end


figure;

% First subplot
subplot(1, 2, 1)
h1 = pie(expt1);
applyAlpha(h1, color, alpha_values);

% Second subplot
subplot(1, 2, 2)
h2 = pie(expt2);
applyAlpha(h2, color, alpha_values);

set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

legend({'Persistent', 'Recruited', 'Suppressed', 'Unresponsive'}, 'Location', 'best', 'box', 'off')

end

expt1 = expt1_PV + expt1_SST;
expt2 = expt2_PV + expt2_SST;
color = (neuron_colors{1} + neuron_colors{5})/2;

figure;

% First subplot
subplot(1, 2, 1)
h1 = pie(expt1);
applyAlpha(h1, color, alpha_values);

% Second subplot
subplot(1, 2, 2)
h2 = pie(expt2);
applyAlpha(h2, color, alpha_values);

set(gca, 'FontSize', 7, 'FontName', 'Helvetica')

legend({'Persistent', 'Recruited', 'Suppressed', 'Unresponsive'}, 'Location', 'best', 'box', 'off')
end

function applyAlpha(pieHandles, color, alpha_values)
    % Extract the patches (slices)
    sliceIdx = 1:2:length(pieHandles); % Get indices of pie slices
    textIdx = 2:2:length(pieHandles); % Get indices of text labels

    for i = 1:length(sliceIdx)
        h = pieHandles(sliceIdx(i));
        h.FaceColor = color; % Keep the same color
        h.FaceAlpha = alpha_values(i); % Apply transparency
    end

    % Hide text labels (percentages)
    for i = textIdx
        pieHandles(i).String = ''; % Remove text
    end
end