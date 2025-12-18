function plotauc_byneuronBT_w_wo_o(m1_cond1, m1_cond2, m1_cond3, neuron_colors, evoked_win, condition_names, ylimits)
% Get AUC for each neuron
m1_cond1 = getauc(m1_cond1, evoked_win);
m1_cond2 = getauc(m1_cond2, evoked_win);
m1_cond3 = getauc(m1_cond3, evoked_win);

% Reformat data
% Column 1 is condition 1, column 2 is condition 2, column 3 is condition 3
m1_PV = reformatdata(m1_cond1, m1_cond2, m1_cond3, 1);
m1_PN = reformatdata(m1_cond1, m1_cond2, m1_cond3, 2);
m1_VIP = reformatdata(m1_cond1, m1_cond2, m1_cond3, 3);
m1_UC = reformatdata(m1_cond1, m1_cond2, m1_cond3, 4);
m1_SST = reformatdata(m1_cond1, m1_cond2, m1_cond3, 5);


% Create boxplots for mouse 1
figure('Position', [193,391,980,144]);
subplot(1, 5, 1)
ylabel('AUC (ΔFt/F)')
if ~isempty(m1_PN)
dabarplot(m1_PN,'xtlabels', condition_names,'fill', 1, ...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{2}, 'mean', '1');
ylim(ylimits)
end
ylabel('AUC (ΔFt/F)')

subplot(1, 5, 2)
if ~isempty(m1_UC)
dabarplot(m1_UC,'xtlabels', condition_names,'fill', 1,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{4}, 'mean', '1');
ylim(ylimits)
end
ylabel('AUC (ΔFt/F)')

subplot(1, 5, 3)
if ~isempty(m1_VIP)
dabarplot(m1_VIP,'xtlabels', condition_names,'fill', 1,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{3}, 'mean', '1');
ylim(ylimits)
end
ylabel('AUC (ΔFt/F)')

subplot(1, 5, 4)
if ~isempty(m1_SST)
dabarplot(m1_SST,'xtlabels', condition_names,'fill', 1,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{5}, 'mean', '1');
ylim(ylimits)
end
ylabel('AUC (ΔFt/F)')

subplot(1, 5, 5)
if ~isempty(m1_PV)
dabarplot(m1_PV,'xtlabels', condition_names,'fill', 1,...
    'scatter',0,'scattersize',2,'scatteralpha',1,'outliers',0, 'color', neuron_colors{1}, 'mean', '1');
ylim(ylimits)
end
ylabel('AUC (∆Ft/F)')

end


function output = reformatdata(var1, var2, var3, celltype)
        counter = 1;
        output = [];
        for i = 1:size(var1, 1)
            temp = var1{i, celltype};
            temp2 = var2{i, celltype};
            temp3 = var3{i, celltype};

            if isempty(temp)
                output = output;
            else
                % Trial average!
                temp = mean(temp, 2, 'omitnan');
                temp2 = mean(temp2, 2, 'omitnan');
                temp3 = mean(temp3, 2, 'omitnan');
                for j = 1:length(temp)
                output(counter, 1) = temp(j);
                output(counter, 2) = temp2(j);
                output(counter, 3) = temp3(j);
                counter = counter + 1;
                end
            end
        end
end

function var = getauc(var, evoked_win)
[nMice, ncellType] = size(var);
    for i = 1:nMice
        for j = 1:ncellType
            signal = var{i, j};
            if ~isempty(signal)
                [~, nCells, nTrials] = size(signal);
                signal = signal(evoked_win(1):evoked_win(2), :, :);
                AUC = NaN(nCells, nTrials);
                for k = 1:nCells
                    for t = 1:nTrials
                        temp = signal(:, k, t);
                            %AUC(k, t) = abs(trapz(temp));
                            AUC(k, t) = trapz(temp);
                    end
                end
                var{i, j} = AUC;
            end
        end
    end
end
