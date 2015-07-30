#!/usr/bin/env python
# -*- coding: utf-8 -*-

HOST = "localhost"
PORT = 4223
UID = "XYZ" # Change to your UID

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_industrial_dual_0_20ma import IndustrialDual020mA

# Callback for current greater than 10mA
def cb_reached(sensor, current):
    print('Current (Sensor' + str(sensor) + ') is greater than 10mA: ' + str(current/1000000.0))

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    id020 = IndustrialDual020mA(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    id020.set_debounce_period(10000)

    # Register threshold reached callback to function cb_reached
    id020.register_callback(dual020.CALLBACK_CURRENT_REACHED, cb_reached)

    # Configure threshold (sensor 1) for "greater than 10mA" (unit is nA)
    id020.set_current_callback_threshold(1, '>', 10*1000000, 0)

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.disconnect()
