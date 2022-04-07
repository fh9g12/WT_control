function setChirp(obj,duration,amplitude,start_freq,end_freq)
%SETRANDOMGUST Summary of this function goes here
%   Detailed explanation goes here
obj.setAmplitude(amplitude,wt.GustMode.Chirp);
obj.setDuration(duration,wt.GustMode.Chirp);
obj.setFrequency(start_freq);
obj.setEndFrequency(end_freq);
obj.setMode(wt.GustMode.Chirp);
end

