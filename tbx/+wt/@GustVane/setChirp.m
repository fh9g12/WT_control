function setChirp(obj,duration,amplitude,start_freq,end_freq,opts)
arguments
obj
duration
amplitude
start_freq
end_freq
opts.repeats = 2;
end
%SETRANDOMGUST Summary of this function goes here
%   Detailed explanation goes here
for i = 1:opts.repeats
obj.setAmplitude(amplitude,wt.GustMode.Chirp);
obj.setDuration(duration,wt.GustMode.Chirp);
obj.setFrequency(start_freq);
obj.setEndFrequency(end_freq);
obj.setMode(wt.GustMode.Chirp);
end
end

