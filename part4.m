clc;
clear;
close all;

%% Sampling Parameters
Fs = 5000;          % Sampling Frequency (Hz)
f = 50;             % Fundamental Frequency (Hz)
T = 0.2;            % Duration (s)
t = 0:1/Fs:T;

Vm = 325;           % Peak Voltage

%% Select Disturbance
choice = 5;         % Change from 1 to 7

switch choice

    case 1
        V = Vm*sin(2*pi*f*t);
        titleText = 'Normal Voltage';

    case 2
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.05 & t<=0.12;
        V(idx)=0.6*V(idx);
        titleText='Voltage Sag';

    case 3
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.05 & t<=0.12;
        V(idx)=1.3*V(idx);
        titleText='Voltage Swell';

    case 4
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.05 & t<=0.12;
        V(idx)=0;
        titleText='Voltage Interruption';

    case 5
        V = Vm*sin(2*pi*f*t) ...
          + 0.20*Vm*sin(2*pi*150*t) ...
          + 0.10*Vm*sin(2*pi*250*t);
        titleText='Harmonic Distortion';

    case 6
        V = Vm*sin(2*pi*52*t);
        titleText='Frequency Variation';

    case 7
        V = Vm*sin(2*pi*f*t);
        idx = t>=0.08 & t<=0.081;
        V(idx)=V(idx)+300;
        titleText='Transient';

end

%% FFT

N = length(V);

Y = fft(V);

P2 = abs(Y/N);

P1 = P2(1:floor(N/2)+1);

P1(2:end-1)=2*P1(2:end-1);

Freq = Fs*(0:floor(N/2))/N;

%% Harmonic Extraction

fundamentalIndex = find(Freq>=49 & Freq<=51,1);

V1 = P1(fundamentalIndex);

harmonicOrders = [3 5 7 9];

harmonicVoltages = zeros(size(harmonicOrders));

for i = 1:length(harmonicOrders)

    targetFreq = harmonicOrders(i)*50;

    idx = find(Freq>=targetFreq-1 & Freq<=targetFreq+1,1);

    harmonicVoltages(i)=P1(idx);

end

%% THD Calculation

THD = sqrt(sum(harmonicVoltages.^2))/V1*100;

%% Display

fprintf('\n');
fprintf('========== THD ANALYSIS ==========\n');
fprintf('Signal : %s\n',titleText);

fprintf('Fundamental Magnitude : %.2f\n',V1);

fprintf('\n');

for i=1:length(harmonicOrders)

    fprintf('%dth Harmonic : %.2f\n',harmonicOrders(i),harmonicVoltages(i));

end

fprintf('\n');

fprintf('Total Harmonic Distortion = %.2f %%\n',THD);

%% Power Quality Status

if THD<5
    status="GOOD POWER QUALITY";
else
    status="POOR POWER QUALITY";
end

fprintf('Status : %s\n',status);

%% Plot

figure

subplot(2,1,1)

plot(t,V,'LineWidth',1.5)

grid on

xlabel('Time (s)')

ylabel('Voltage (V)')

title(titleText)

subplot(2,1,2)

bar([1 harmonicOrders],[V1 harmonicVoltages])

xticklabels({'1st','3rd','5th','7th','9th'})

xlabel('Harmonic Order')

ylabel('Magnitude')

grid on

title(['THD = ' num2str(THD,'%.2f') ' %'])