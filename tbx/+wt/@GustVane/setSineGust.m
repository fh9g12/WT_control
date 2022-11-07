function setSineGust(obj,amplitude,freq,opts)
arguments
obj
amplitude
freq
opts.repeats = 2;
end
%SETRANDOMGUST Summary of this function goes here
%   Detailed explanation goes here
for i = 1:opts.repeats
obj.setAmplitude(amplitude,wt.GustMode.Sine);
obj.setFrequency(freq);
obj.setMode(wt.GustMode.Sine);
end
end

