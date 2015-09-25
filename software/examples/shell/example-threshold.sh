#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change to your UID

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
tinkerforge call industrial-dual-0-20ma-bricklet $uid set-debounce-period 10000

# Handle incoming current reached callbacks (parameter has unit nA)
tinkerforge dispatch industrial-dual-0-20ma-bricklet $uid current-reached &

# Configure threshold for current (sensor 1) "greater than 10 mA" (unit is nA)
tinkerforge call industrial-dual-0-20ma-bricklet $uid set-current-callback-threshold 1 greater 10000000 0

echo "Press key to exit"; read dummy

kill -- -$$ # Stop callback dispatch in background
