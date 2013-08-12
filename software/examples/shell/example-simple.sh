#!/bin/sh
# connects to localhost:4223 by default, use --host and --port to change it

# change to your UID
uid=XYZ

# get current current from sensor 1 (unit is nA)
tinkerforge call industrial-dual-0-20ma-bricklet $uid get-current 1
