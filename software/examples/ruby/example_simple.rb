#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_industrial_dual_0_20ma'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'XYZ' # Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

ipcon = IPConnection.new # Create IP connection
id020 = BrickletIndustrialDual020mA.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Get current current from sensor 1
current = id020.get_current 1
puts "Current (Sensor 1): #{current/1000000.0} mA"

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
