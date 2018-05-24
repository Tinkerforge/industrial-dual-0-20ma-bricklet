#!/usr/bin/perl

use strict;
use Tinkerforge::IPConnection;
use Tinkerforge::BrickletIndustrialDual020mA;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

# Callback subroutine for current reached callback
sub cb_current_reached
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

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$id020->set_debounce_period(10000);

# Register current reached callback to subroutine cb_current_reached
$id020->register_callback($id020->CALLBACK_CURRENT_REACHED, 'cb_current_reached');

# Configure threshold for current (sensor 1) "greater than 10 mA"
$id020->set_current_callback_threshold(1, '>', 10*1000000, 0);

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
