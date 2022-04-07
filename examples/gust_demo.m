% GUST_DEMO a demo script to show how to operate the gust vanes
%
% author: Fintan Healy
% email: fintan.healy@bristol.ac.uk
% date: 07/04/2022

clear all; fclose all;
% create the gust vane objects
vanes = [wt.GustVane('192.168.1.101',502),wt.GustVane('192.168.1.102',502)];

%% control the gust vanes

% choose the kind of gust to apply
mode = wt.GustMode.OneMinusCosine;
freq = 0.2;
amp = 20;
duration = 5;
start_delay = 1;
inverted = false;

% mode = wt.GustMode.Sine;
% freq = 2;
% amp = 5;
% duration = 5;
% start_delay = 1;
% inverted = false;

disp('apply settings')
% apply the settings to teh gust vanes
switch mode
    case wt.GustMode.RandomTurbulence
        vanes.setRandomGust(duration,amp);
    case wt.GustMode.Chirp
        vanes.setChirp(duration,amp,freq,end_freq);
    case wt.GustMode.OneMinusCosine
        vanes.setOneMinusCosine(amp,freq,inverted)
    case wt.GustMode.Sine
        vanes.setSineGust(amp,freq);
    case wt.GustMode.Analogue
        vanes.setAnalogue();
    case wt.GustMode.Off
        vanes.setSineGust(0,1);
end

% run the gust vanes
t = vanes.getRunTimer(duration);
disp('starting Gust vanes')
pause(start_delay)
start(t)
wait(t)
disp('Motion over')