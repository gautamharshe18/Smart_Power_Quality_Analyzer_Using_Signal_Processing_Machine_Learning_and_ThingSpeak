clc;
clear;

Fs = 5000;
f = 50;
T = 0.2;

t = 0:1/Fs:T;

Vm = 325;

features = [];
labels = categorical([]);

samples = 200;      % Number of samples per disturbance

for i = 1:samples

    %% ---------------- NORMAL ----------------
    amp = Vm*(0.98 + 0.04*rand);      % ±2% variation
    noise = 0.005*amp*randn(size(t));

    V = amp*sin(2*pi*f*t) + noise;

    features(end+1,:) = extractFeatures(V,Fs)';
    labels(end+1,1) = categorical("Normal");


    %% ---------------- SAG ----------------
    amp = Vm*(0.98 + 0.04*rand);
    sagDepth = 0.4 + 0.4*rand;        % 40% to 80%

    V = amp*sin(2*pi*f*t);

    startIndex = randi([200 350]);
    duration = randi([180 320]);

    stopIndex = min(startIndex+duration,length(V));

    V(startIndex:stopIndex)=sagDepth*V(startIndex:stopIndex);

    V = V + 0.005*Vm*randn(size(V));

    features(end+1,:) = extractFeatures(V,Fs)';
    labels(end+1,1)=categorical("Sag");


    %% ---------------- SWELL ----------------
    amp = Vm*(0.98 + 0.04*rand);
    swell = 1.2 + 0.3*rand;           % 120% to 150%

    V = amp*sin(2*pi*f*t);

    startIndex = randi([200 350]);
    duration = randi([180 320]);

    stopIndex = min(startIndex+duration,length(V));

    V(startIndex:stopIndex)=swell*V(startIndex:stopIndex);

    V = V + 0.005*Vm*randn(size(V));

    features(end+1,:) = extractFeatures(V,Fs)';
    labels(end+1,1)=categorical("Swell");


    %% ---------------- HARMONIC ----------------
    H3 = 0.15 + 0.10*rand;
    H5 = 0.05 + 0.08*rand;

    V = Vm*sin(2*pi*f*t) ...
        + H3*Vm*sin(2*pi*150*t) ...
        + H5*Vm*sin(2*pi*250*t);

    V = V + 0.005*Vm*randn(size(V));

    features(end+1,:) = extractFeatures(V,Fs)';
    labels(end+1,1)=categorical("Harmonic");


    %% ---------------- TRANSIENT ----------------
    V = Vm*sin(2*pi*f*t);

    spike = 200 + 200*rand;

    startIndex = randi([300 700]);
    width = randi([3 10]);

    stopIndex = min(startIndex+width,length(V));

    V(startIndex:stopIndex)=V(startIndex:stopIndex)+spike;

    V = V + 0.005*Vm*randn(size(V));

    features(end+1,:) = extractFeatures(V,Fs)';
    labels(end+1,1)=categorical("Transient");


    %% ---------------- INTERRUPTION ----------------
    V = Vm*sin(2*pi*f*t);

    startIndex = randi([200 350]);
    duration = randi([180 320]);

    stopIndex = min(startIndex+duration,length(V));

    V(startIndex:stopIndex)=0;

    V = V + 0.005*Vm*randn(size(V));

    features(end+1,:) = extractFeatures(V,Fs)';
    labels(end+1,1)=categorical("Interruption");


    %% ---------------- FREQUENCY VARIATION ----------------
    freq = 48 + 4*rand;        % 48 Hz to 52 Hz

    amp = Vm*(0.98 + 0.04*rand);

    V = amp*sin(2*pi*freq*t);

    V = V + 0.005*Vm*randn(size(V));

    features(end+1,:) = extractFeatures(V,Fs)';
    labels(end+1,1)=categorical("Frequency Variation");

end

save TrainingData.mat features labels

disp("-----------------------------------------")
disp("Training Dataset Created Successfully")
disp("-----------------------------------------")

disp("Total Samples :")
disp(length(labels))

disp("Feature Matrix Size :")
disp(size(features))