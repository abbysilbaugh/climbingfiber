% Note: will only work on trialavg = 1 & catmouse = 1 OR trialavg = 1 & cellavg = 1 & catmouse = 1

function [pre, post, pre2, post2, prctactive, prctactive2] = keeppersistent(pre, post, ...
    pre2, post2, prctactive, prctactive2)

neuron_names = {'PV', 'PN', 'VIP', 'UC', 'SST'};

% Find neurons with evoked events both pre and post
for i = 1:length(neuron_names)

pre_selected = pre{i};
post_selected = post{i};
pre2_selected = pre2{i};
post2_selected = post2{i};
prctactive_selected = prctactive{i};
prctactive2_selected = prctactive2{i};

find_1 = ~isnan(pre_selected(1, :)) & ~isnan(post_selected(1,:));% & ~isnan(RWS_pre_wo_selected(1,:));
find_2 = ~isnan(pre2_selected(1, :)) & ~isnan(post2_selected(1,:));% & ~isnan(RWSCF_pre_wo_selected(1,:));

pre_selected = pre_selected(:, find_1);
post_selected = post_selected(:, find_1);
pre2_selected = pre2_selected(:, find_2);
post2_selected = post2_selected(:, find_2);
prctactive_selected = prctactive_selected(find_1);
prctactive2_selected = prctactive2_selected(find_2);

pre{i} = pre_selected;
post{i} = post_selected;
pre2{i} = pre2_selected;
post2{i} = post2_selected;
prctactive{i} = prctactive_selected;
prctactive2{i} = prctactive2_selected;



end