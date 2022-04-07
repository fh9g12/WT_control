function setSineGust(obj,amplitude,freq)
%SETRANDOMGUST Summary of this function goes here
%   Detailed explanation goes here
obj.setAmplitude(amplitude,wt.GustMode.Sine);
obj.setFrequency(freq);
obj.setMode(wt.GustMode.Sine);
end

