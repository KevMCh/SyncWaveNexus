%% 
clear
clc

close all

%% General
gDataset = EEGDataset();

relatPath = 'data';

% 768 0x0300 Start of a trial
% 769 0x0301 Cue onset left (class 1)
% 770 0x0302 Cue onset right (class 2)
% 771 0x0303 Cue onset foot (class 3)
% 772 0x0304 Cue onset tongue (class 4)
info.markers = [769, 770, 771, 772];

info.type = 'T';

numUsers = 9;

% for i = 1 : numUsers
    % info.user = i;
    info.user = 1;
    gDataset = gDataset.processFile(relatPath, info);
% end

