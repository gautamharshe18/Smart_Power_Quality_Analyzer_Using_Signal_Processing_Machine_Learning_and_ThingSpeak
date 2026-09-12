function thdResults = thdAnalysis(fftResults)

%------------------------------------------
% TOTAL HARMONIC DISTORTION (THD)
%------------------------------------------

Freq = fftResults.Frequency;
P1 = fftResults.Magnitude;

% Fundamental (50 Hz)
V1 = fftResults.Fundamental;

% Harmonic Orders
harmonicOrders = [3 5 7 9];

harmonicMagnitudes = zeros(size(harmonicOrders));

for i = 1:length(harmonicOrders)

    targetFreq = harmonicOrders(i)*50;

    idx = find(Freq >= targetFreq-1 & Freq <= targetFreq+1,1);

    if ~isempty(idx)
        harmonicMagnitudes(i) = P1(idx);
    else
        harmonicMagnitudes(i) = 0;
    end

end

% THD Calculation
THD = sqrt(sum(harmonicMagnitudes.^2))/V1*100;

% Power Quality Status
if THD <= 5
    status = "GOOD POWER QUALITY";
else
    status = "POOR POWER QUALITY";
end

% Store Results
thdResults.Fundamental = V1;
thdResults.HarmonicOrders = harmonicOrders;
thdResults.HarmonicMagnitudes = harmonicMagnitudes;
thdResults.THD = THD;
thdResults.Status = status;

end