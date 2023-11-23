classdef (Abstract) GraphDataset < Dataset
    properties(Constant)
        CHANNELS = { 'EEGFz', 'EEG', 'EEG1', 'EEG2', 'EEG3', 'EEG4', ...
            'EEG5', 'EEGC3', 'EEG6', 'EEGCz', 'EEG7', 'EEGC4',  'EEG8', ...
            'EEG9', 'EEG10', 'EEG11',  'EEG12', 'EEG13', 'EEG14', ...
            'EEGPz', 'EEG15', 'EEG16'};

        xPos = [    0, ...
            -2, -1, 0, 1, 2, ...
        -3, -2, -1, 0, 1, 2, 3 ...
            -2, -1, 0, 1, 2, ...
                -1, 0, 1, ...
                    0];

        yPos = [    2, ...
              1, 1, 1, 1, 1, ...
           0, 0, 0, 0, 0, 0, 0 ...
           -1, -1, -1, -1, -1, ...
               -2, -2, -2, ...
                   -3];
    end

    methods (Abstract)
        synchValue = obtainSynch(obj, signal1, signal2)
    end

    methods(Access=public)
        function obj = GraphDataset()
        end

        function obj = calculateGraphs(obj, bpValues, dataset)
            data = dataset.getData();
            labels = dataset.getLabels();

            for i = 1 : length(data)
                signals = data{i, 1};
                [nSamples, channels] = size(signals);

                filt = fir1(ceil(nSamples / 5), ...
                        bpValues / 250, 'bandpass', ...
                        hamming(ceil(nSamples / 5) + 1), 'scale');

                signals = fastfc_filt(filt, signals, 1);
                
                matrix = obj.obtainSynch(signals);
                signalGraph = graph(matrix, obj.CHANNELS, 'upper');
                obj = obj.addData(signalGraph, labels{i, 1});
            end
        end

        function plotAdj(obj, nGraph)
            figure;
            h = heatmap(full(adjacency(obj.Data{nGraph}, 'weighted')), ...
                'MissingDataColor', 'w');

            labels = obj.Data{nGraph}.Nodes.Name;
            h.XDisplayLabels = labels;
            h.YDisplayLabels = labels;
        end

        function plotAvgAdj(obj, thr)
            figure;

            classes = unique(cell2mat(obj.Labels));
            
            tiledlayout(2, length(classes))

            for i = 1 : length(classes)
                idx = find(cell2mat(obj.Labels) == classes(i));

                mtx{i} = obj.calculateAvgAdjMatrix(classes(i));

                if nargin == 2
                    mtx{i}(mtx{i} <= thr) = 0;
                end
            end

            for i = 1 : length(classes)
                nexttile
                h = heatmap(tril(mtx{i}), ...
                    'MissingDataColor', 'w', 'ColorLimits',[0 1]);
                labels = obj.Data{1}.Nodes.Name;
                h.XDisplayLabels = labels;
                h.YDisplayLabels = labels;

                title(['Event: ' int2str(classes(i))])
            end

            for i = 1 : length(classes)
                mtx{i}(logical(eye(size(mtx{i})))) = 0;
                mtx{i} = graph(mtx{i}, obj.CHANNELS, 'upper');
                
                nexttile
                lWidths = 5 * abs(mtx{i}.Edges.Weight) / max(mtx{i}.Edges.Weight);
                
                p = plot(mtx{i}, 'LineWidth', lWidths, 'XData', obj.xPos, 'YData', obj.yPos);

                p.Marker = 's';
                p.MarkerSize = 6;
                p.NodeColor = 'r';
                axis off;
            end
        end

        function avgAdjMatrix = calculateAvgAdjMatrix(obj, eventType)
            idx = find(cell2mat(obj.Labels) == eventType);

            avgAdjMatrix = [];

            for j = 1 : length(idx)
                graphO = obj.Data(idx(j));
                avgAdjMatrix(:, :, j) = full(adjacency(graphO{1}, 'weighted'));
            end

            avgAdjMatrix = mean(avgAdjMatrix, 3);
            avgAdjMatrix(logical(eye(size(avgAdjMatrix)))) = 0;
        end
    end

    methods(Access=protected)
        function adjMatrix = getBinaryAdjMatrix(obj, adjMatrix, thr)
            adjMatrix(adjMatrix > thr) = 1;
        end

        function normMatrix = normalizeMatrix(obj, matrix)
            minVal = min(matrix(:));
            maxVal = max(matrix(:));
            
            normMatrix = (matrix - minVal) / (maxVal - minVal);
        end
    end

    methods(Static)
        function fGraph = thrFilter(thr, sGraph)
            adjMatrix = full(adjacency(sGraph, 'weighted'));
            adjMatrix(adjMatrix <= thr) = 0;
            fGraph = graph(adjMatrix, sGraph.Nodes.Name, 'upper');
        end

        function fGraph = binaryFilter(binMatrix, sGraph)
            adjMatrix = full(adjacency(sGraph, 'weighted'));
            adjMatrix = adjMatrix .* binMatrix;
            fGraph = graph(adjMatrix, sGraph.Nodes.Name, 'upper');
        end
    end
end