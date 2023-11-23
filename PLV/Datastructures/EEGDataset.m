classdef EEGDataset < Dataset
    methods(Access=public)
        function obj = EEGDataset()
        end

        function obj = processFile(obj, relatPath, info)

            [data, hdr] = sload([ './' relatPath '/A0' int2str(info.user) info.type '.gdf'], 0, 'OVERFLOWDETECTION:OFF');

            for i = 1 : length(info.markers)
                indexes = find((hdr.EVENT.TYP) == info.markers(i));

                events = [hdr.EVENT.POS + 250, hdr.EVENT.POS +  250 * 4];
                specifEvents = events(indexes, :);
            
                for j = 1 : length(specifEvents)
                    obj = obj.addData( ...
                        data(specifEvents(j, 1):specifEvents(j, 2), 1:22), ...
                        info.markers(i) ...
                    );
                end
            end
        end
    end

    methods(Static)
        function filteredData = filter(data)
            avgData = mean(data, 2);
            data = data - avgData;
            filteredData = data;
        end
    end
end