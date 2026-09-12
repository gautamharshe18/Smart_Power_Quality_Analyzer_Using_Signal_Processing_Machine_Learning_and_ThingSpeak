clc;
clear;

% Replace these with YOUR values

channelID = 3480460;

writeKey = 'IGGWRIJ7XH6LA3SA';

thingSpeakWrite(channelID,...
    [230 325 3.8 1.41 1 3 1 95],...
    'WriteKey',writeKey);

disp("Data Uploaded Successfully");