classdef GustVane
    %GUSTVANE Summary of this class goes here
    %   Detailed explanation goes here

    properties
        tcp_drive;
    end

    methods
        function obj = GustVane(ip,port)
            obj.tcp_drive = tcpclient(ip,port);
            obj.tcp_drive.ByteOrder = "big-endian";
        end
        function t = getRunTimer(obj,duration)
            t = timer;
            t.StartFcn = @(~,~)obj.startDrive();
            t.TimerFcn = @(~,~)obj.stopDrive();
            t.StartDelay = round(duration,3);
            t.ExecutionMode = 'singleShot';
        end
        function startDrive(obj)
            obj.writeToDrive(1930,1,1);
        end
        function stopDrive(obj)
            obj.writeToDrive(1930,0,1);
        end
        function setFrequency(obj,freq)
            if (freq>20)
                freq=20;
                warning('Clamped maximum frequency to 15 Hz');
            elseif (freq<0.1)
                freq=0.1;
                warning('Clamped minimum frequency to 0.1 Hz');
            end
            obj.writeToDrive(1911,floor(freq*10),1);
            obj.write_pause();
        end
        function setInverted(obj,inverted)
            if inverted
                obj.writeToDrive(1915 , 1 , 1);
            else
                obj.writeToDrive(1915 , 0 , 1);
            end
            obj.write_pause();
        end
        function setEndFrequency(obj,freq)
            if (freq>20)
                freq=20;
                warning('Clamped maximum frequency to 15 Hz');
            elseif (freq<0.1)
                freq=0.1;
                warning('Clamped minimum frequency to 0.1 Hz');
            end
            obj.writeToDrive(1914,floor(freq*10),1);
            obj.write_pause();
        end
        function setAmplitude(obj,amp,mode)
            if mode == wt.GustMode.RandomTurbulence
                maxAmp = 5;
            else
                maxAmp = 20;
            end
            if (amp>maxAmp)
                amp=maxAmp;
                warning('Clamped maximum amplitude to %.1f degs',maxAmp);
            elseif (amp<1)
                amp=1;
                disp('Clamped minimum amplitude to 1 degs');
            end
            obj.writeToDrive(1910,floor((amp)*10),1);
            obj.write_pause();
        end
        function write_pause(obj)
            arrayfun(@(x)x.read,[obj.tcp_drive],'UniformOutput',false);
        end
        function setDuration(obj,dur,mode)
            if mode == wt.GustMode.RandomTurbulence && dur>20
                dur=20;
                warning('Clamped maximum duration to 20 seconds');
            end
            if (dur<1)
                dur=1;
                disp('Clamped minimum duration to 1 second');
            end
            obj.writeToDrive(1913,floor(dur*10),1);
            obj.write_pause();
        end
        function setMode(obj,mode)
            % Modes => 3 single, 2 continuous, 1 analogue, 0 off
            if isa(mode,'wt.GustMode')
                obj.writeToDrive(1912,mode,1);
            else
                error('must be of type GustMode enumeration')
            end
        end
    end
end

