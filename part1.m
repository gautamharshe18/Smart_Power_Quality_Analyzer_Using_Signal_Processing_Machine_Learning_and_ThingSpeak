clc;
clear;
close all;

%% Sampling Parameters
Fs = 5000;          % Sampling Frequency (Hz)
f = 50;             % Fundamental Frequency (Hz)
T = 0.2;            % Duration (seconds)
t = 0:1/Fs:T;

Vm = 325;           % Peak Voltage (230 V RMS)

%% Select Disturbance
% Change this value from 1 to 7
choice = 1;

switch choice

    case 1
        % Normal Voltage
        V = Vm*sin(2*pi*f*t);
        titleText = 'Normal Voltage';

    case 2
        % Voltage Sag (40% reduction)
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.05 & t<=0.12;
        V(idx) = 0.6*V(idx);
        titleText = 'Voltage Sag';

    case 3
        % Voltage Swell (30% increase)
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.05 & t<=0.12;
        V(idx) = 1.3*V(idx);
        titleText = 'Voltage Swell';

    case 4
        % Voltage Interruption
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.05 & t<=0.12;
        V(idx) = 0;
        titleText = 'Voltage Interruption';

    case 5
        % Harmonic Distortion
        V = Vm*sin(2*pi*f*t) ...
          + 0.20*Vm*sin(2*pi*150*t) ...
          + 0.10*Vm*sin(2*pi*250*t);
        titleText = 'Harmonic Distortion';

    case 6
        % Frequency Variation (52 Hz)
        V = Vm*sin(2*pi*52*t);
        titleText = 'Frequency Variation';

    case 7
        % Transient Spike
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.08 & t<=0.081;
        V(idx) = V(idx) + 300;
        titleText = 'Transient';

end

%% Plot
figure;

plot(t,V,'LineWidth',1.5);

grid on;

xlabel('Time (Seconds)');
ylabel('Voltage (Volts)');
title(titleText);

xlim([0 0.2]);
ylim([-450 450]);