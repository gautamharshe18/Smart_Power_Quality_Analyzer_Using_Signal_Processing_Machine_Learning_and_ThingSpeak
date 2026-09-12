function featureVector = extractFeatures(V,Fs)

%---------------------------------------
% FEATURE EXTRACTION FOR ML CLASSIFIER
%---------------------------------------

% RMS
Vrms = rms(V);

% Peak
Vpeak = max(abs(V));

% Crest Factor
CrestFactor = Vpeak/Vrms;


% FFT
N = length(V);

Y = fft(V);

P2 = abs(Y/N);

P1 = P2(1:floor(N/2)+1);

P1(2:end-1)=2*P1(2:end-1);

Freq = Fs*(0:floor(N/2))/N;


% Fundamental
searchIdx = find(Freq>=45 & Freq<=55);

[~,k] = max(P1(searchIdx));

V1 = P1(searchIdx(k));


% Harmonics

harmonic3 = find(Freq>=149 & Freq<=151,1);

harmonic5 = find(Freq>=249 & Freq<=251,1);


H3 = P1(harmonic3);

H5 = P1(harmonic5);


% THD

THD = sqrt(H3^2+H5^2)/V1*100;

%% Additional Features

% Fundamental Magnitude
Fundamental = V1;

% Signal Energy
Energy = sum(V.^2);

% Standard Deviation
StdDev = std(V);

% Variance
Variance = var(V);

% Form Factor
FormFactor = Vrms/mean(abs(V));

% Shape Factor
ShapeFactor = Vrms/(mean(sqrt(abs(V)))^2);
% Feature Vector

featureVector = [

Vrms
Vpeak
CrestFactor
THD
H3
H5
Fundamental
Energy
StdDev
Variance
FormFactor
ShapeFactor

];

end