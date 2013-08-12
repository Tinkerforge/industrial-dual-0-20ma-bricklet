#!/bin/sh
# connects to localhost:4223 by default, use --host and --port to change it

# change to your UID
uid=XYZ

# get threshold callbacks with a debounce time of 10 seconds (10000ms)
tinkerforge call industrial-dual-0-20ma-bricklet $uid set-debounce-period 10000

# configure threshold (sensor 1) for "greater than 10mA" (unit is nA)
tinkerforge call industrial-dual-0-20ma-bricklet $uid set-current-callback-threshold 1 greater 10000000 0

# handle incoming current-reached callbacks (unit is nA)
tinkerforge dispatch industrial-dual-0-20ma-bricklet $uid current-reached\
 --execute "echo Current (sensor {sensor}) is greater than 10mA: {current} nA"
