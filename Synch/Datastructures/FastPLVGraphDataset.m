classdef FastPLVGraphDataset < GraphDataset
    methods(Access=public)
        function obj = FastPLVGraphDataset()
        end

        function filGraphDS = filterGraphs(obj, thr)
            filGraphDS = FastPLVGraphDataset();
            for i = 1 : length(obj.Data)

                graphs = {};
                for j = 1 : length(obj.Data{i})
                    graphs{j} = FastPLVGraphDataset.thrFilter(thr, obj.Data{i}{j});
                end

                filGraphDS = filGraphDS.addData(graphs, obj.Labels{i});
            end
        end

        function obj = normalizeGraphs(obj)
            for i = 1 : length(obj.Data)
                graphs = {};
                for j = length(obj.Data{i})
                    graphs{j} = graph( ...
                        obj.normalizeMatrix(full(adjacency(obj.Data{i}{j}, 'weighted'))), ...
                    obj.Data{i}{j}.Nodes.Name, 'upper');
                end

                obj.Data{i} = graphs;
            end
        end
    end

    methods(Access=protected)
        function obj = addData(obj, data, label)
            obj = addData@Dataset(obj, data, label);
        end
    end

    methods(Access=public, Static=true)
        function synchMat = obtainSynch(signals)
            % [synchMat, ~, ~] = fastfc_ps(signals, n_samples*.1, 1);
            [synchMat, ~, ~] = fastfc_ps(signals, 0, 1);
        end
    end
end