clc;
clear;
close all;

%% POWER QUALITY ANALYZER
% Main Program

disp("====================================")
disp(" SOFTWARE POWER QUALITY ANALYZER ")
disp("====================================")


%% Select Unknown Signal

[file,path] = uigetfile('signals/*.mat', ...
    'Select Voltage Signal');

if isequal(file,0)

    disp("No file selected")
    return

end


%% Load Signal

data = load(fullfile(path,file));


V = data.VoltageSignal;
t = data.Time;
Fs = data.Fs;


disp("Signal Loaded Successfully")
disp("------------------------------------")


%% Time Domain Analysis

timeResults = timeAnalysis(V,t);


%% FFT Analysis

fftResults = fftAnalysis(V,Fs);


%% THD Calculation

thdResults = thdAnalysis(fftResults);


%% Machine Learning Classification

[knnClass,svmClass,rfClass] = classifyML(V,Fs);


%% Display Results

fprintf("\n============== RESULTS ==============\n")


fprintf("RMS Voltage : %.2f V\n",...
    timeResults.Vrms)


fprintf("Peak Voltage : %.2f V\n",...
    timeResults.Vpeak)


fprintf("Average Voltage : %.2f V\n",...
    timeResults.Vavg)


fprintf("Crest Factor : %.3f\n",...
    timeResults.CrestFactor)


fprintf("THD : %.2f %%\n",...
    thdResults.THD)


fprintf("\n===============================\n")

fprintf("KNN Prediction          : %s\n",knnClass);

fprintf("SVM Prediction          : %s\n",svmClass);

fprintf("Random Forest Prediction: %s\n",rfClass);

fprintf("===============================\n");

if thdResults.THD <= 5

    fprintf("Power Quality : GOOD\n")

else

    fprintf("Power Quality : POOR\n")

end


%% Plot Voltage Waveform

figure

subplot(2,1,1)

plot(t,V,'LineWidth',1.5)

grid on

xlabel("Time (seconds)")
ylabel("Voltage (V)")

title("Input Voltage Waveform")


%% Plot FFT

subplot(2,1,2)

stem(fftResults.Frequency,...
    fftResults.Magnitude,...
    'filled')

grid on

xlabel("Frequency (Hz)")
ylabel("Magnitude")

title("Frequency Spectrum")

xlim([0 500])


disp("------------------------------------")
disp("Analysis Completed")