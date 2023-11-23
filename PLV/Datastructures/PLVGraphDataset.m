classdef PLVGraphDataset < GraphDataset
    methods(Access=public)
        function obj = PLVGraphDataset()
        end

        function filGraphDS = filterGraphs(obj, thr)
            filGraphDS = PLVGraphDataset();
            for i = 1 : length(obj.Data)
                filGraphDS = filGraphDS.addData( ...
                    PLVGraphDataset.thrFilter(thr, obj.Data{i}), obj.Labels{i});
            end
        end

        function obj = normalizeGraphs(obj)
            for i = 1 : length(obj.Data)
                obj.Data{i} = graph( ...
                        obj.normalizeMatrix(full(adjacency(obj.Data{i}, 'weighted'))), ...
                    obj.Data{i}.Nodes.Name, 'upper');
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