#!/bin/sh
# connects to localhost:4223 by default, use --host and --port to change it

# change to your UID
uid=XYZ

# set period for current callback to 1s (1000ms)
# note: the current callback is only called every second if the
#       current has changed since the last call!
tinkerforge call industrial-dual-0-20ma-bricklet $uid set-current-callback-period 1 1000

# handle incoming illuminance callbacks (unit is nA)
tinkerforge dispatch industrial-dual-0-20ma-bricklet $uid current
