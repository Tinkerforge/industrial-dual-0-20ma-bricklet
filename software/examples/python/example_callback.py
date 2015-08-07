#!/usr/bin/env python
# -*- coding: utf-8 -*-

HOST = "localhost"
PORT = 4223
UID = "XYZ" # Change to your UID

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_industrial_dual_0_20ma import BrickletIndustrialDual020mA

# Callback function for current callback (parameter has unit nA)
def cb_current(sensor, current):
    print('Current (Sensor ' + str(sensor) + '): ' + str(current/1000000.0) + ' mA')

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    id020 = BrickletIndustrialDual020mA(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Set Period (sensor 1) for current callback to 1s (1000ms)
    # Note: The callback is only called every second if the 
    #       current has changed since the last call!
    id020.set_current_callback_period(1, 1000)

    # Register current callback to function cb_current
    id020.register_callback(dual020.CALLBACK_CURRENT, cb_current)

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.disconnect()
