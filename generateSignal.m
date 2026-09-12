function [V,t,Fs,signalName] = generateSignal(choice)

%---------------------------------------
% POWER QUALITY SIGNAL GENERATOR
%---------------------------------------

Fs = 5000;
f = 50;
T = 0.2;

t = 0:1/Fs:T;

Vm = 325;


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
            +0.2*Vm*sin(2*pi*150*t) ...
            +0.1*Vm*sin(2*pi*250*t);

        signalName = "Harmonic Distortion";


    case 6
        
        V = Vm*sin(2*pi*f*t);

        idx = t>=0.08 & t<=0.081;

        V(idx)=V(idx)+300;

        signalName = "Transient Spike";


    otherwise
        
        error("Invalid choice. Enter 1 to 6.")

end

end