function setOneMinusCosine(obj,amplitude,freq,inverted,opts)
arguments
obj
amplitude
freq
inverted
opts.repeats = 2;
end
%SETRANDOMGUST Summary of this function goes here
%   Detailed explanation goes here
for i = 1:opts.repeats
obj.setAmplitude(amplitude,wt.GustMode.OneMinusCosine);
obj.setFrequency(freq);
obj.setInverted(inverted);
obj.setMode(wt.GustMode.OneMinusCosine);
end
end

