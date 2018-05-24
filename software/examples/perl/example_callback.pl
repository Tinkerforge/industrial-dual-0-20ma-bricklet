#!/usr/bin/perl

use strict;
use Tinkerforge::IPConnection;
use Tinkerforge::BrickletIndustrialDual020mA;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

# Callback subroutine for current callback
sub cb_current
{
    my ($sensor, $current) = @_;

    print "Sensor: $sensor\n";
    print "Current: " . $current/1000000.0 . " mA\n";
    print "\n";
}

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $id020 = Tinkerforge::BrickletIndustrialDual020mA->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Register current callback to subroutine cb_current
$id020->register_callback($id020->CALLBACK_CURRENT, 'cb_current');

# Set period for current (sensor 1) callback to 1s (1000ms)
# Note: The current (sensor 1) callback is only called every second
#       if the current (sensor 1) has changed since the last call!
$id020->set_current_callback_period(1, 1000);

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
