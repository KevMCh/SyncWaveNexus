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


% sampleSteps = 750;

for i = 1 : numUsers
    info.user = i;

    gDataset = EEGDataset();    
    gDataset = gDataset.processFile(relatPath, info);

    freqGraphs = {};
    for j = 1 : length(freqRanges) - 1

        %% Graph
        graphDS = FastPLVGraphDataset();
        % graphDS = graphDS.calculateGraphsBySteps( ...
        %     [freqRanges(j), freqRanges(j + 1)], gDataset, sampleSteps, true)

        graphDS = graphDS.calculateGraphs( ...
            [freqRanges(j), freqRanges(j + 1)], gDataset);
        
        graphDS = graphDS.filterGraphs(0.5);
        graphDS = graphDS.normalizeGraphs();
        % graphDS.plotAvgAdj(0.7);

        freqGraphs{j} = graphDS;
    end

    %% Save files
    nTrials = length(freqGraphs{1}.getData());
    nLabels = length(unique(cell2mat(freqGraphs{1}.getLabels())));

    for j = 1 : nTrials
        fullMatrix = [];

        for k = 1 : length(freqGraphs{1}.getItem(j))
            item_graphs = freqGraphs{1}.getItem(j);
            matL = tril(full(adjacency(item_graphs{k}, 'weighted')));

            item_graphs = freqGraphs{2}.getItem(j);
            matU = triu(full(adjacency(item_graphs{k}, 'weighted')));

            tmpMatrix = matU + matL;
            tmpMatrix = tmpMatrix - diag(diag(tmpMatrix));

            fullMatrix = cat(3, fullMatrix, tmpMatrix);
        end

        if(mod(j, (nTrials / nLabels)) == 0)
            itemNumber = nTrials / nLabels;
        else
            itemNumber =  mod(j, (nTrials / nLabels));
        end

        name = ['graph_user' int2str(info.user) ...
            '_label' int2str(freqGraphs{1}.getLabel(j)) ...
            '_item' int2str(itemNumber) '_thr05_norm_filter'];

        save(['./Data/Graph/' name], 'fullMatrix');

        disp(["Save: " name])
    end
end





