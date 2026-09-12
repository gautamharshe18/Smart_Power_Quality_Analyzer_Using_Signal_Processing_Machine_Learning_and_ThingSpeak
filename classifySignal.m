function classification = classifySignal(results, thdResults)

%---------------------------------------------------
% DISTURBANCE CLASSIFICATION
%---------------------------------------------------

Vrms = results.Vrms;
Peak = results.Vpeak;
MaxV = results.MaxVoltage;
MinV = results.MinVoltage;

THD = thdResults.THD;

% Default Values
classification.Disturbance = "Unknown";
classification.PowerQuality = thdResults.Status;
classification.Reason = "";

%---------------------------------------------------
% CLASSIFICATION
%---------------------------------------------------

% 1. Voltage Interruption
if Vrms < 120

    classification.Disturbance = "Voltage Interruption";
    classification.Reason = "Very low RMS voltage.";

% 2. Voltage Sag
elseif Vrms >=120 && Vrms <210

    classification.Disturbance = "Voltage Sag";
    classification.Reason = "RMS voltage below normal.";

% 3. Voltage Swell
elseif Vrms >245 && THD <=5

    classification.Disturbance = "Voltage Swell";
    classification.Reason = "RMS voltage above normal.";

% 4. Harmonic Distortion
elseif THD >5

    classification.Disturbance = "Harmonic Distortion";
    classification.Reason = "THD exceeds 5%.";

% 5. Transient Spike
elseif Peak >550

    classification.Disturbance = "Transient Spike";
    classification.Reason = "High voltage spike detected.";

% 6. Normal Voltage
else

    classification.Disturbance = "Normal Voltage";
    classification.Reason = "Voltage and THD are within limits.";

end

end