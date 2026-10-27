clc;
clear;
close all;

%% Sampling Parameters
Fs = 5000;
f = 50;
T = 0.2;
t = 0:1/Fs:T;

Vm = 325;

%% Select Signal (1–7)
choice = 5;

switch choice

    case 1
        V = Vm*sin(2*pi*f*t);
        signalName = "Normal Voltage";

    case 2
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.05 & t<=0.12;
        V(idx)=0.6*V(idx);
        signalName = "Voltage Sag";

    case 3
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.05 & t<=0.12;
        V(idx)=1.3*V(idx);
        signalName = "Voltage Swell";

    case 4
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.05 & t<=0.12;
        V(idx)=0;
        signalName = "Voltage Interruption";

    case 5
        V = Vm*sin(2*pi*f*t) ...
          +0.20*Vm*sin(2*pi*150*t) ...
          +0.10*Vm*sin(2*pi*250*t);
        signalName = "Harmonic Distortion";

    case 6
        V = Vm*sin(2*pi*52*t);
        signalName = "Frequency Variation";

    case 7
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.08 & t<=0.081;
        V(idx)=V(idx)+300;
        signalName = "Transient";

end

%% Time Domain Analysis

Vrms = rms(V);
Vpeak = max(abs(V));

zeroCross = find(diff(sign(V)));
EstimatedFrequency = length(zeroCross)/(2*T);

%% FFT

N = length(V);

Y = fft(V);

P2 = abs(Y/N);

P1 = P2(1:floor(N/2)+1);

P1(2:end-1)=2*P1(2:end-1);

Freq = Fs*(0:floor(N/2))/N;

%% THD

fundamentalIndex = find(Freq>=49 & Freq<=51,1);

V1 = P1(fundamentalIndex);

harmonics = [3 5 7 9];

harmonicVoltages = zeros(size(harmonics));

for i=1:length(harmonics)

    target = harmonics(i)*50;

    idx = find(Freq>=target-1 & Freq<=target+1,1);

    harmonicVoltages(i)=P1(idx);

end

THD = sqrt(sum(harmonicVoltages.^2))/V1*100;

%% Automatic Classification

classification = "Unknown";

if Vrms < 150

    classification = "Voltage Interruption";

elseif Vrms < 210

    classification = "Voltage Sag";

elseif Vrms > 250

    classification = "Voltage Swell";

elseif EstimatedFrequency < 49 || EstimatedFrequency > 51

    classification = "Frequency Variation";

elseif THD > 5

    classification = "Harmonic Distortion";

elseif Vpeak > 550

    classification = "Transient";

else

    classification = "Normal Voltage";

end

%% Display

fprintf("\n");
fprintf("============== RESULT ==============\n");

fprintf("Actual Signal      : %s\n",signalName);
fprintf("Detected Signal    : %s\n",classification);

fprintf("\n");

fprintf("RMS Voltage        : %.2f V\n",Vrms);
fprintf("Peak Voltage       : %.2f V\n",Vpeak);
fprintf("Frequency          : %.2f Hz\n",EstimatedFrequency);
fprintf("THD                : %.2f %%\n",THD);

%% Plot

figure

subplot(2,1,1)

plot(t,V,'b','LineWidth',1.5)

grid on

xlabel('Time (s)')
ylabel('Voltage (V)')
title(signalName)

subplot(2,1,2)

stem(Freq,P1,'filled')

grid on

xlabel('Frequency (Hz)')
ylabel('Magnitude')

title(['Detected: ',char(classification)])

xlim([0 500])