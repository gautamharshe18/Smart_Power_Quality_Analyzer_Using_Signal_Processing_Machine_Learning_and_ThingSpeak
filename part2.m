clc;
clear;
close all;

%% Sampling Parameters
Fs = 5000;          % Sampling Frequency
f = 50;             % Fundamental Frequency
T = 0.2;            % Duration
t = 0:1/Fs:T;

Vm = 325;           % Peak Voltage (230 V RMS)

%% Select Disturbance
choice = 1;         % Change from 1 to 7

switch choice

    case 1
        V = Vm*sin(2*pi*f*t);
        titleText = 'Normal Voltage';

    case 2
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.05 & t<=0.12;
        V(idx) = 0.6*V(idx);
        titleText = 'Voltage Sag';

    case 3
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.05 & t<=0.12;
        V(idx) = 1.3*V(idx);
        titleText = 'Voltage Swell';

    case 4
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.05 & t<=0.12;
        V(idx) = 0;
        titleText = 'Voltage Interruption';

    case 5
        V = Vm*sin(2*pi*f*t) ...
          + 0.20*Vm*sin(2*pi*150*t) ...
          + 0.10*Vm*sin(2*pi*250*t);
        titleText = 'Harmonic Distortion';

    case 6
        V = Vm*sin(2*pi*52*t);
        titleText = 'Frequency Variation';

    case 7
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.08 & t<=0.081;
        V(idx) = V(idx) + 300;
        titleText = 'Transient';

end

%% Time-Domain Calculations

Vrms = rms(V);

Vpeak = max(abs(V));

Vavg = mean(V);

CrestFactor = Vpeak / Vrms;

%% Frequency Estimation using Zero Crossings

zeroCross = find(diff(sign(V)));

EstimatedFrequency = length(zeroCross)/(2*T);

%% Display Results

fprintf('\n');
fprintf('========= TIME DOMAIN ANALYSIS =========\n');
fprintf('Signal               : %s\n',titleText);
fprintf('RMS Voltage          : %.2f V\n',Vrms);
fprintf('Peak Voltage         : %.2f V\n',Vpeak);
fprintf('Average Voltage      : %.2f V\n',Vavg);
fprintf('Crest Factor         : %.2f\n',CrestFactor);
fprintf('Estimated Frequency  : %.2f Hz\n',EstimatedFrequency);

%% Plot

figure;

subplot(2,1,1)
plot(t,V,'b','LineWidth',1.5);
grid on;
xlabel('Time (s)');
ylabel('Voltage (V)');
title(titleText);

subplot(2,1,2)

bar([Vrms Vpeak CrestFactor EstimatedFrequency]);

xticklabels({'RMS','Peak','Crest','Freq'});

ylabel('Value');

grid on;

title('Time Domain Parameters');