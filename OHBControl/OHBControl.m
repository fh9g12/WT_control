classdef OHBControl < handle
    properties (Access = private)
        % Connection handle to the TCP socket
        socket
    end

    properties (SetAccess = private, GetAccess = public)
        % Connection handle to the TCP socket
        connected = false
    end

    methods (Access = private)
        %% Send a command to the OHB TCP server
        function args_out = sendCmd(obj, cmd, args_in)
            % Only continue if server is connected
            if ~obj.connected
                disp('WARNING: OHB TCP server not connected!')
                return
            end

            % Assemble the data packet (command + optional arguments)
            data = cmd;

            if nargin > 2
                for k = 1:length(args_in)
                    data = [data ',' num2str(round(args_in(k),3))]; %#ok<AGROW>
                end
            end
            
            try
                % Send the command
                obj.socket.write(data)

                % Check for a valid response
                data = obj.socket.readline();
                data = split(data, ',');
                
                response = data{1};
                args_out = str2double(data(2:end));

                if strcmp(response, 'NACK')
                    % Bad response => do nothing
                    disp('WARNING: Command not accepted by OHB server!')
                    return
                elseif ~strcmp(response, 'ACK')
                    % No response => disconnect
                    obj.connected = false;
                    disp('WARNING: Received no response from OHB TCP server!')
                    return
                end
            catch
                % Connection broken => reset
                obj.connected = false;
                disp('WARNING: OHB TCP server disconnected!')
            end
        end
    end

    methods (Access = public)
        %% Try to establish a connection to the OHB computer's TCP server
        function success = connect(obj, ip)
            try
                obj.socket = tcpclient(ip, 57575, 'Timeout', 30, 'ConnectTimeout', 5);
                obj.connected = true;
                disp(['Successfully connected to OHB TCP server on ' ip '.'])
                success = 1;
            catch
                obj.connected = false;
                disp(['WARNING: Could not connect to OHB TCP server on ' ip '!'])
                success = 0;
            end
        end

        %% Start a new sample
        function sample(obj, sampletime)
            arguments
                obj
                sampletime (1,1) {mustBeInRange(sampletime,0,600,'exclude-lower')} = 5
            end

            obj.sendCmd('sample', sampletime);
        end
        
        %% Record a new time series
        function timeSeries(obj, sampletime)
            arguments
                obj
                sampletime (1,1) {mustBeInRange(sampletime,0,600,'exclude-lower')} = 5
            end

            obj.sendCmd('timeSeries', sampletime);
        end
        
        %% Set a new yaw value and start movement
        function moveYaw(obj, yaw, speed, acceleration, deceleration)
            arguments
                obj
                yaw (1,1) {mustBeNumeric}
                speed (1,1) {mustBeInRange(speed,0,2,'exclude-lower')} = 0.5
                acceleration (1,1) {mustBeInRange(acceleration,0,2,'exclude-lower')} = 0.5
                deceleration (1,1) {mustBeInRange(deceleration,0,2,'exclude-lower')} = 0.5
            end

            obj.sendCmd('moveYaw', [yaw, speed, acceleration, deceleration]);
        end
        
        %% Read the yaw value from the OHB UI
        function yaw = readYaw(obj)
            arguments
                obj
            end

            result = obj.sendCmd('readYaw');
            
            if ~isempty(result)
                yaw = result(1);
            else
                yaw = NaN;
            end
        end
        
       	%% Set a new incidence value and start movement
        function moveIncidence(obj, incidence, speed, acceleration, deceleration)
            arguments
                obj
                incidence (1,1) {mustBeNumeric}
                speed (1,1) {mustBeInRange(speed,0,2,'exclude-lower')} = 0.5
                acceleration (1,1) {mustBeInRange(acceleration,0,2,'exclude-lower')} = 0.5
                deceleration (1,1) {mustBeInRange(deceleration,0,2,'exclude-lower')} = 0.5
            end

            obj.sendCmd('moveIncidence', [incidence, speed, acceleration, deceleration]);
        end
        
        %% Read the incidence value from the OHB UI
        function incidence = readIncidence(obj)
            arguments
                obj
            end

            result = obj.sendCmd('readIncidence');
            
            if ~isempty(result)
                incidence = result(1);
            else
                incidence = NaN;
            end
        end
        
        %% Set the barometric pressure
        function setBaro(obj, QFE)
            arguments
                obj
                QFE (1,1) {mustBeInRange(QFE,800,1200)}
            end

            obj.sendCmd('setBaro', QFE);
        end
        
        %% Read the wind speed value from the OHB UI
        function speed = readWindSpeed(obj)
            arguments
                obj
            end

            result = obj.sendCmd('readWindSpeed');
            
            if ~isempty(result)
                speed = result(1);
            else
                speed = NaN;
            end
        end
        
        %% Read the temperature value from the OHB UI
        function temp = readTemperature(obj)
            arguments
                obj
            end

            result = obj.sendCmd('readTemperature');
            
            if ~isempty(result)
                temp = result(1);
            else
                temp = NaN;
            end
        end
    end
end
