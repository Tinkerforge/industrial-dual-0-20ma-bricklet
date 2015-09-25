#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_industrial_dual_0_20ma'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'XYZ' # Change to your UID

ipcon = IPConnection.new # Create IP connection
id020 = BrickletIndustrialDual020mA.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Register current callback (parameter has unit nA)
id020.register_callback(BrickletIndustrialDual020mA::CALLBACK_CURRENT) do |sensor, current|
  puts "Sensor: #{sensor}"
  puts "Current: #{current/1000000.0} mA"
  puts ''
end

# Set period for current (sensor 1) callback to 1s (1000ms)
# Note: The current (sensor 1) callback is only called every second
#       if the current (sensor 1) has changed since the last call!
id020.set_current_callback_period 1, 1000

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
