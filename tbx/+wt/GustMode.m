classdef GustMode < uint16
    enumeration
        RandomTurbulence (5)    % between +/- Amplitude
        Chirp (4)               % between +/- Amplitude
        OneMinusCosine (3)      % single-sided "1-Cosine"
        Sine (2)                % between +/- Amplitude
        Analogue (1)            % @ 2.7 degree per volt
        Off (0)                 
    end
end

