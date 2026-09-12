function results = timeAnalysis(V,t)

%-------------------------------
% TIME DOMAIN ANALYSIS
%-------------------------------

results.Vrms = rms(V);

results.Vpeak = max(abs(V));

results.Vavg = mean(V);

results.CrestFactor = results.Vpeak/results.Vrms;

results.MaxVoltage = max(V);

results.MinVoltage = min(V);

results.Duration = t(end)-t(1);

end