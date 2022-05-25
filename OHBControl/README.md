# OHBControl

This project allows remote control of the 7x5 tunnel's overhead balance (OHB) from a local network. Two files are needed for this:
- A *Python* script `OHBControlServer.py` runs on the balance computer and takes control of the mouse and keyboard to interface with the balance GUI.
- A *MATLAB* class `OHBControl.m` is used by the user on his personal computer and handles all communications over the local network.

***DISCLAIMER: Any updates or changes to the balance control software through the manufacturer may cause unexpected behaviour of the script. Supervise the balance computer at all times!***

## Usage

1. Connect your personal computer with the balance computer and setup a local network.

### On the balance computer:
2. Make sure that the ATE control software is running.
3. Launch the *Python* script `OHBControlServer.py` on the balance computer. A TCP server is created on port 57575 and its IP address is displayed on the command line.
4. The ATE GUI must be in foreground and maximised, otherwise the script will not execute commands received via TCP.

### On your personal computer:
5. Connect to the server by creating an instance of the `OHBControl` class in *MATLAB*.
6. Call the `OHBControl.connect(ip)` function with the server's IP provided as an argument. The function will return `1` upon successfully establishing a connection.
7. Use the `OHBControl` functions to remotely control the balance.

## *MATLAB* Example

```
ohb = OHBControl;

if ~ohb.connect('192.168.1.70')
  disp('Connection failed!')
  return
end

ohb.moveYaw(15);                    % Move yaw to +15°
ohb.moveIncidence(-10,2,2,2);       % Move incidence to -10° at maximum speed

ohb.sample();                       % Start a measurement

while true
  v = ohb.getWindSpeed();           % Read the current windspeed
  if ~isnan(v)
    break
  end
end
```

## `OHBControl` Documentation

- `success = OHBControl.connect(ip)` 
  
  Try to establish a connection to the OHB computer's TCP server.
  - `ip`                    IP address of the server in the format XXX.XXX.XXX.XXX. (string)
  - `success`               1 if successfully connected, else 0


- `OHBControl.sample(sampletime)` 
  
  Start a new sample.
  - `sampletime = 5`        Time over which sample is taken. (optional)


- `OHBControl.timeSeries(sampletime)` 
  
  Start a new time series.
  - `sampletime = 5`        Length of time series recording. (optional)


- `OHBControl.moveYaw(yaw, speed, acceleration, deceleration)` 
  
  Set a new yaw value and start movement.
  - `yaw`                   Commanded yaw value.
  - `speed = 0.5`           Commanded speed value. (optional)
  - `acceleration = 0.5`    Commanded acceleration value. (optional)
  - `deceleration = 0.5`    Commanded deceleration value. (optional)


- `yaw = OHBControl.readYaw()` 
  
  Read the current yaw value from the OHB UI.
  - `yaw`                   The current yaw value. Reading it fails sometimes, in this case 'NaN' is returned.


- `OHBControl.moveIncidence(yaw, speed, acceleration, deceleration)` 
  
  Set a new incidence value and start movement. Make sure that the *mm* input option is not selected on the OHB GUI.
  - `incidence`             Commanded incidence value.
  - `speed = 0.5`           Commanded speed value. (optional)
  - `acceleration = 0.5`    Commanded acceleration value. (optional)
  - `deceleration = 0.5`    Commanded deceleration value. (optional)


- `incidence = OHBControl.readIncidence()` 
  
  Read the current incidence value from the OHB UI.
  - `incidence`             The current incidence value. Reading it fails sometimes, in this case 'NaN' is returned.


- `OHBControl.setBaro(QFE)` 
  
  Set the barometric pressure.
  - `QFE`                   The local barometric pressure in hPa.


- `speed = OHBControl.readWindSpeed()` 

  Read the wind speed value from the OHB UI.
  - `speed`                 The current airspeed value in the high speed test section. Reading it fails sometimes, in this case 'NaN' is returned.


- `temp = OHBControl.readTemperature()` 

  Read the temperature value from the OHB UI.
  - `temp`                  The current temperature value in the high speed test section. Reading it fails sometimes, in this case 'NaN' is returned.

## Known Issues & Limitations

- The stability of the connection between the TCP sever and client varies greatly. The script allows for a long timeout period, which is often encountered. Sometimes the connection is lost completely, at which point the server has to be restarted and connected again.
- Values are currently read from the textboxes in the UI. Sometimes these are refreshed at the same time as the script attempts to read them, in which case NaN is returned.
