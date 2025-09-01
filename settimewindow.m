function [allData] = settimewindow(allData, starttime, endtime, starttime2, endtime2)

nMice = size(allData.data, 2);

for i = 1:nMice

    % Window 1
    evokedtraces = allData.data{i}.evokedtraces;
    golaysignal3 = allData.data{i}.golaysignal3;
    motionInfo = allData.data{i}.motionInfo;
    motType = allData.data{i}.trialmotType;
    reltime = allData.data{i}.reltime;

    rej1 = reltime < starttime;
    rej2 = reltime > endtime;

    rej = logical(rej1 + rej2);

    [~, ~, nTrials] = size(evokedtraces);
    for j = 1:nTrials
        if rej(j) == 1
            evokedtraces(:, :, j) = NaN;
            golaysignal3(:, :, j) = NaN;
            motionInfo(:, j) = NaN;
            motType{j} = NaN;
        end
    end

    allData.data{i}.evokedtraces_settime = evokedtraces;
    allData.data{i}.golaysignal3_settime = golaysignal3;
    allData.data{i}.motionInfo_settime = motionInfo;
    allData.data{i}.trialmotType_settime = motType;

    % Window 2
    evokedtraces = allData.data{i}.evokedtraces;
    golaysignal3 = allData.data{i}.golaysignal3;
    motionInfo = allData.data{i}.motionInfo;
    motType = allData.data{i}.trialmotType;
    reltime = allData.data{i}.reltime;

    rej1 = reltime < starttime2;
    rej2 = reltime > endtime2;

    rej = logical(rej1 + rej2);

    [~, ~, nTrials] = size(evokedtraces);
    for j = 1:nTrials
        if rej(j) == 1
            evokedtraces(:, :, j) = NaN;
            golaysignal3(:, :, j) = NaN;
            motionInfo(:, j) = NaN;
            motType{j} = NaN;
        end
    end

    allData.data{i}.evokedtraces_settime2 = evokedtraces;
    allData.data{i}.golaysignal3_settime2 = golaysignal3;
    allData.data{i}.motionInfo_settime2 = motionInfo;
    allData.data{i}.trialmotType_settime2 = motType;
end