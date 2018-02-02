#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

# Get current current from sensor 1
tinkerforge call industrial-dual-0-20ma-bricklet $uid get-current 1
