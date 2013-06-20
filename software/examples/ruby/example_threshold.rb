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

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
dual020.set_debounce_period 10000

# Register threshold reached callback (unit is nA)
dual020.register_callback(BrickletIndustrialDual020mA::CALLBACK_CURRENT_REACHED) do |sensor, current|
  puts "Current (sensor #{sensor}) is greater than 10mA: #{current/(1000.0*1000.0)}"
end

# Configure threshold (sensor 1) for "greater than 10mA" (unit is nA)
dual020.set_current_callback_threshold 1, '>', 10*1000*1000, 0

puts 'Press key to exit'
$stdin.gets
