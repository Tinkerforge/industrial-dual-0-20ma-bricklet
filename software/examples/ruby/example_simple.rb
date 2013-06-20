#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_industrial_dual_0_20_ma'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'XYZ' # Change to your UID

ipcon = IPConnection.new # Create IP connection
dual020 = BrickletIndustrialDual020mA.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Get current current from sensor 1 (unit is nA)
current = dual020.get_current(1) / (1000.0*1000.0)
puts "Current: #{current} mA"

puts 'Press key to exit'
$stdin.gets
