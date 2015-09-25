#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change to your UID

# Handle incoming current callbacks (parameter has unit nA)
tinkerforge dispatch industrial-dual-0-20ma-bricklet $uid current &

# Set period for current (sensor 1) callback to 1s (1000ms)
# Note: The current (sensor 1) callback is only called every second
#       if the current (sensor 1) has changed since the last call!
tinkerforge call industrial-dual-0-20ma-bricklet $uid set-current-callback-period 1 1000

echo "Press key to exit"; read dummy

kill -- -$$ # Stop callback dispatch in background
