function setRandomGust(obj,duration,amplitude,opts)
%SETRANDOMGUST Summary of this function goes here
%   Detailed explanation goes here
arguments
obj
duration
amplitude
opts.repeats = 2;
end

for i = 1:opts.repeats
obj.setAmplitude(amplitude,wt.GustMode.RandomTurbulence);
obj.setDuration(duration,wt.GustMode.RandomTurbulence);
obj.setMode(wt.GustMode.RandomTurbulence);
end
end

