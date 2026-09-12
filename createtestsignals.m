clc;
clear;
close all;

%% Create Folder

if ~exist('signals','dir')
    mkdir('signals')
end


%% Sampling Parameters

Fs = 5000;

f = 50;

T = 0.2;

t = 0:1/Fs:T;

Vm = 325;      % Peak voltage (230V RMS)


%% 1. Normal Voltage

V = Vm*sin(2*pi*f*t);

VoltageSignal = V;
Time = t;

save('signals/Normal.mat',...
    'VoltageSignal','Time','Fs')


%% 2. Voltage Sag

V = Vm*sin(2*pi*f*t);

idx = t>=0.05 & t<=0.12;

V(idx)=0.6*V(idx);

VoltageSignal = V;

save('signals/Sag.mat',...
    'VoltageSignal','Time','Fs')


%% 3. Voltage Swell

V = Vm*sin(2*pi*f*t);

idx = t>=0.05 & t<=0.12;

V(idx)=1.3*V(idx);

VoltageSignal = V;

save('signals/Swell.mat',...
    'VoltageSignal','Time','Fs')


%% 4. Voltage Interruption

V = Vm*sin(2*pi*f*t);

idx = t>=0.05 & t<=0.12;

V(idx)=0;

VoltageSignal = V;

save('signals/Interruption.mat',...
    'VoltageSignal','Time','Fs')


%% 5. Harmonic Distortion

V = Vm*sin(2*pi*f*t) ...
    +0.20*Vm*sin(2*pi*150*t) ...
    +0.10*Vm*sin(2*pi*250*t);


VoltageSignal = V;

save('signals/Harmonic.mat',...
    'VoltageSignal','Time','Fs')


%% 6. Transient Spike

V = Vm*sin(2*pi*f*t);

idx = t>=0.08 & t<=0.081;

V(idx)=V(idx)+300;


VoltageSignal = V;

save('signals/Transient.mat',...
    'VoltageSignal','Time','Fs')


disp("================================")
disp(" Test Signals Created Successfully ")
disp("================================")

disp("Files created:")
disp("Normal.mat")
disp("Sag.mat")
disp("Swell.mat")
disp("Interruption.mat")
disp("Harmonic.mat")
disp("Transient.mat")