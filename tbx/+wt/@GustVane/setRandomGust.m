function setRandomGust(obj,duration,amplitude)
%SETRANDOMGUST Summary of this function goes here
%   Detailed explanation goes here
obj.setAmplitude(amplitude,wt.GustMode.RandomTurbulence);
obj.setDuration(duration,wt.GustMode.RandomTurbulence);
obj.setMode(wt.GustMode.RandomTurbulence);
end

