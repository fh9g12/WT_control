classdef GustMode < uint16
    % GUSTMODE an enumeration to define the mode of operation of the gust
    % vanes
    %
    % Author:   Fintan Healy  
    % Email:    fintan.healy@bristol.ac.uk
    % Date:     07/04/2022
    
    enumeration
        RandomTurbulence (5)    % between +/- Amplitude
        Chirp (4)               % between +/- Amplitude
        OneMinusCosine (3)      % single-sided "1-Cosine"
        Sine (2)                % between +/- Amplitude
        Analogue (1)            % @ 2.7 degree per volt
        Off (0)                 
    end
end

