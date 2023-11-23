classdef Dataset
    properties(Access=public)
        Data
        Labels
    end

    methods(Access=public)
        function obj = Dataset()
        end

        function data = getData(obj)
            data = obj.Data;
        end

        function labels = getLabels(obj)
            labels = obj.Labels;
        end

        function item = getItem(obj, idx)
            item = obj.Data{idx};
        end

        function label = getLabel(obj, idx)
            label = obj.Labels{idx};
        end
    end

    methods(Access=protected)
        function obj = addData(obj, data, label)
            obj.Data{end + 1, 1} = data;
            obj.Labels{end + 1, 1} = label;
        end
    end
end