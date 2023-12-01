classdef EEGDataset < Dataset
    methods(Access=public)
        function obj = EEGDataset()
        end

        function obj = processFile(obj, relatPath, info)
            file = ['./' relatPath '/A0' int2str(info.user) info.type '.gdf'];

            disp(["Preproccesing file " file]);

            [data, hdr] = sload(file, 0, 'OVERFLOWDETECTION:OFF');

            for i = 1 : length(info.markers)
                indexes = find((hdr.EVENT.TYP) == info.markers(i));

                events = [hdr.EVENT.POS + 250, hdr.EVENT.POS +  250 * 4];
                specifEvents = events(indexes, :);
            
                for j = 1 : length(specifEvents)
                    obj = obj.addData( ...
                        EEGDataset.applyFilters(data(specifEvents(j, 1):specifEvents(j, 2), 1:22), file), ...
                        info.markers(i) ...
                    );
                end
            end
        end

        function saveRawEEG(obj, path)
            nTrials = length(obj.getData());
            nLabels = length(unique(cell2mat(obj.getLabels())));

            for i = 1 : nTrials
                tmpMatrix = obj.Data{i};

                if(mod(i, (nTrials / nLabels)) == 0)
                    itemNumber = nTrials / nLabels;
                else
                    itemNumber =  mod(i, (nTrials / nLabels));
                end

                save([path ...
                    '_label' int2str(obj.getLabel(i)) ...
                    '_item' int2str(itemNumber)], 'tmpMatrix');
            end
        end
    end

    methods(Static)
        function filteredSignals = applyFilters(signals, file)
            filteredSignals = EEGDataset.applyBP(signals);
            filteredSignals = EEGDataset.removeMean(filteredSignals);
            filteredSignals = EEGDataset.removeEyeArtifacts(filteredSignals, file);
        end

        function filteredSignals = applyBP(signals)
            fs = 250;
            freqLow = 5;
            freqHigh = 40;
            filteredSignals = bandpass(signals', [freqLow, freqHigh], fs);
            filteredSignals = filteredSignals';
        end

        function filteredSignals = removeMean(signals)
            avgData = mean(signals, 2);
            signals = signals - avgData;
            filteredSignals = signals;
        end

        function filteredSignals = removeEyeArtifacts(filteredSignals, file)
            % https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7591406
            
            % Butterworth filter
            fs = 250;
            filtData = bandpass(filteredSignals', [1, 7], fs);
            
            [nChannels, nTime] = size(filtData);
            
            regrAPZ = EEGDataset.calculateRegrSignal(file);

            % Derivative
            diffAPZ = diff([regrAPZ(1,1), regrAPZ]);
            
            % z-score
            mu = mean(diffAPZ); 
            sigma = std(diffAPZ);
            
            zAPZ = (diffAPZ - mu) / sigma;
            
            % Square raiz cuadrada
            zAPZ = zAPZ .^ 2;
            
            % Moving avg
            movingAvgLen = 10;
            zAPZ = [zAPZ(1, 1 : movingAvgLen - 1), zAPZ];
            
            thresAPZ = [];
            for i = movingAvgLen : length(zAPZ)
                thresAPZ = [thresAPZ, ...
                    mean(zAPZ(1, i + 1 - movingAvgLen : i))];
            end
            
            % Weights proportion in each channel
            weightChannels = [];
            avgSignalAPZ = mean(abs(regrAPZ));
            for i = 1 : nChannels
                weightChannels = [weightChannels, ...
                    (mean(abs(filtData(i, :))) / avgSignalAPZ)];
            end
            
            filteredSignals = filteredSignals';
            for j = 1 : nTime
                if thresAPZ(j) > 1
                    for i = 1 : nChannels
                        filteredSignals(i, j) = filteredSignals(i, j) - ...
                            (weightChannels(i) * regrAPZ(1, j));
                    end
                end
            end

            filteredSignals = filteredSignals';
        end

        function regrAPZ = calculateRegrSignal(file)
            [data, ~] = sload(file, 0, 'OVERFLOWDETECTION:OFF');
            regrAPZ = mean(data(:, end-2:end), 2)';
        end
    end
end