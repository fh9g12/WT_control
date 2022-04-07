clear all; fclose all;
vanes = [wt.GustVane('192.168.1.101',502),wt.GustVane('192.168.1.102',502)];

%% play games
freq = 0.2;
amp = 20;
duration = 5;
start_delay = 1;
end_freq = 5;
inverted = false;

mode = wt.GustMode.OneMinusCosine;

disp('apply settings')
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

t = vanes.getRunTimer(duration);
disp('starting Gust vanes')
pause(start_delay)
start(t)
wait(t)
disp('Motion over')