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

# Set Period (sensor 1) for current callback to 1s (1000ms)
# Note: The callback is only called every second if the 
#       current has changed since the last call!
dual020.set_current_callback_period 1, 1000

# Register current callback (parameter has unit mA)
dual020.register_callback(BrickletIndustrialDual020mA::CALLBACK_CURRENT) do |sensor, current|
  puts "Current (sensor #{sensor}): #{current/(1000.0*1000.0)} mA"
end

puts 'Press key to exit'
$stdin.gets
