%% 
clear
clc

close all

%% General
relatPath = 'Data';

% 768 0x0300 Start of a trial
% 769 0x0301 Cue onset left (class 1)
% 770 0x0302 Cue onset right (class 2)
% 771 0x0303 Cue onset foot (class 3)
% 772 0x0304 Cue onset tongue (class 4)
info.markers = [769, 770, 771, 772];

info.type = 'T';

numUsers = 9;

freqRanges = [8, 12, 30];

for i = 1 : numUsers
    info.user = i;

    gDataset = EEGDataset();
    gDataset = gDataset.processFile(relatPath, info);

    freqGraphs = {};
    for j = 1 : length(freqRanges) - 1

        %% Graph
        graphDS = PLVGraphDataset();
        graphDS = graphDS.calculateGraphs( ...
            [freqRanges(j), freqRanges(j + 1)], gDataset);
        
        % graphDS.plotAvgAdj(0.7)

        freqGraphs{j} = graphDS;
    end

    %% Save files
    nTrials = length(freqGraphs{j}.getData());
    nLabels = length(unique(cell2mat(freqGraphs{j}.getLabels())));
    
    for i = 1 : nTrials
        matL = tril(full(adjacency(freqGraphs{1}.getItem(i), 'weighted')));
        matU = triu(full(adjacency(freqGraphs{2}.getItem(i), 'weighted')));
    
        fullMatrix = matU + matL;
        fullMatrix = fullMatrix - diag(diag(fullMatrix));
    
        if(mod(i, (nTrials / nLabels)) == 0)
            itemNumber = nTrials / nLabels;
        else
            itemNumber =  mod(i, (nTrials / nLabels));
        end
        
        save(['./Data/Graph/graph_user' int2str(info.user) ...
            '_label' int2str(freqGraphs{1}.getLabel(i)) ...
            '_item' int2str(itemNumber)], 'fullMatrix');
    end
end




