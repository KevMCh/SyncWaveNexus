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
timeSteps = 1;

path = './Data/Graph/raw_user';

for i = 1 : numUsers
    info.user = i;

    gDataset = EEGDataset();    
    gDataset = gDataset.processFile(relatPath, info);

    gDataset.saveRawEEG([path int2str(info.user)]);
end





