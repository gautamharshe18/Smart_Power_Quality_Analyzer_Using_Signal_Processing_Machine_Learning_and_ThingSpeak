function fftResults = fftAnalysis(V,Fs)

%------------------------------------------
% FFT ANALYSIS
%------------------------------------------

N = length(V);

% Compute FFT
Y = fft(V);

% Two-sided spectrum
P2 = abs(Y/N);

% Single-sided spectrum
P1 = P2(1:floor(N/2)+1);

P1(2:end-1) = 2*P1(2:end-1);

% Frequency Vector
Freq = Fs*(0:floor(N/2))/N;

% Fundamental (around 50 Hz)
fundamentalIndex = find(Freq>=49 & Freq<=51,1);

FundamentalMagnitude = P1(fundamentalIndex);

% Store Results
fftResults.N = N;
fftResults.Frequency = Freq;
fftResults.Magnitude = P1;
fftResults.Fundamental = FundamentalMagnitude;
fftResults.FundamentalIndex = fundamentalIndex;

end