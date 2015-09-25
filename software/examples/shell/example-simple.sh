#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change to your UID

# Get current current from sensor 1 (unit is nA)
tinkerforge call industrial-dual-0-20ma-bricklet $uid get-current 1
