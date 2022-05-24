#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#   OHBControlServer.py
#   Version 13.05.2022
#  

import time
import socket
from ahk import AHK
import pyperclip

# AutoHotkey object for controlling mouse/keyboard
ahk = AHK()

# Get the user interface window
window = ahk.find_window(title=b'5 x 7 WTCS / Balance Controls  at Bristol University,  by ATE Aerotech')

if window == None:
    raise Exception('Balance UI window not found! Is it closed?')

# Create the TCP server socket
HOST = socket.gethostbyname(socket.gethostname())
PORT = 57575

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen()

print('OHB server hosted at ' + HOST + ' on port ' + str(PORT))

# Outer loop: Wait for client to connect to TCP socket
while True:
    conn, address = s.accept()
    
    print('Connected with client at ' + address[0] + ' on port ' + str(address[1]))

    # Inner loop: Receive and exectute commands over TCP
    while True:
        # Receive data over TCP
        data = conn.recv(1024)

        # Check if client has disconnected
        if not data:
            break

        # Answer with NACK if the UI window is not in foreground/maximised or wrong size (pixels)
        if (not window.active or not window.maximized 
            or window.rect[2] != 2580 or window.rect[3] != 1460):
            conn.sendall('NACK\n'.encode())
            continue
        
        # Parse the received command
        data = data.decode()
        
        if ',' in data:
            cmd = data.split(',')[0]
            args_in = data.split(',', maxsplit=1)[1].split(',')
        else:
            cmd = data
            args_in = []

        args_out = []

        # Execute the command
        if (cmd == 'sample') and (len(args_in) == 1):
            # Set the sampling time
            ahk.double_click(55, 802)
            ahk.type(args_in[0])
                        
            # Start a new sample
            ahk.click(170, 805)

        elif (cmd == 'timeSeries') and (len(args_in) == 1):
            # Set the time series length
            ahk.double_click(55, 858)
            ahk.type(args_in[0])
                        
            # Start recording time series
            ahk.click(170, 860)
            
        elif (cmd == 'moveYaw') and (len(args_in) == 4):
            # Set a new yaw angle
            ahk.double_click(1110, 265)
            ahk.key_press('Backspace')
            ahk.key_press('Backspace')
            ahk.type(args_in[0])
            
            # Set speed
            ahk.double_click(1110, 388)
            ahk.type(args_in[1])
            
            # Set acceleration
            ahk.double_click(1110, 445)
            ahk.type(args_in[2])
            
            # Set deceleration
            ahk.double_click(1110, 503)
            ahk.type(args_in[3])
            
            # Start moving
            ahk.click(1120, 335)

        elif (cmd == 'readYaw'):
            # Select yaw value
            ahk.mouse_move(1150, 180)
            ahk.mouse_drag(-90, 0, relative=True)

            # Reset clipboard and try copying value
            pyperclip.copy('NaN')
            ahk.send('^c')
            time.sleep(0.1)

            # Retrieve value from clipboard and send back to client
            args_out = [pyperclip.paste().strip()]

        elif (cmd == 'moveIncidence') and (len(args_in) == 4):
            # Set a new incidence angle
            ahk.double_click(1640, 265)
            ahk.key_press('Backspace')
            ahk.key_press('Backspace')
            ahk.type(args_in[0])
            
            # Set speed
            ahk.double_click(1640, 388)
            ahk.type(args_in[1])
            
            # Set acceleration
            ahk.double_click(1640, 445)
            ahk.type(args_in[2])
            
            # Set deceleration
            ahk.double_click(1640, 503)
            ahk.type(args_in[3])
            
            # Start moving
            ahk.click(1650, 335)

        elif (cmd == 'readIncidence'):
            # Select incidence value
            ahk.mouse_move(1670, 180)
            ahk.mouse_drag(-90, 0, relative=True)

            # Reset clipboard and try copying value
            pyperclip.copy('NaN')
            ahk.send('^c')
            time.sleep(0.1)

            # Retrieve value from clipboard and send back to client
            args_out = [pyperclip.paste().strip()]

        elif (cmd == 'setBaro') and (len(args_in) == 1):
            # Click on 'Update' to open text box and write new value
            ahk.click(2425, 735)
            ahk.type(args_in[0])
            ahk.key_press('Enter')

        elif (cmd == 'readWindSpeed'):
            # Select wind speed value
            ahk.double_click(2105, 728)

            # Reset clipboard and try copying value
            pyperclip.copy('NaN')
            ahk.send('^c')
            time.sleep(0.1)

            # Retrieve value from clipboard and send back to client
            args_out = [pyperclip.paste().strip()]

        elif (cmd == 'readTemperature'):
            # Select temperature value
            ahk.double_click(2355, 706)

            # Reset clipboard and try copying value
            pyperclip.copy('NaN')
            ahk.send('^c')
            time.sleep(0.1)

            # Retrieve value from clipboard and send back to client
            args_out = [pyperclip.paste().strip()]
            
        else:
            # Command not known => send not acknowledged
            conn.sendall('NACK\n'.encode())
            continue

        # Send an acknowledge to client together with the output arguments
        data = ','.join(['ACK'] + args_out) + '\n'
        conn.sendall(data.encode())
    
    print('Client disconnected')
