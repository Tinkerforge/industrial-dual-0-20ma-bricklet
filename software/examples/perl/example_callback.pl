#!/usr/bin/perl

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletIndustrialDual020mA;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change to your UID

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $id020 = Tinkerforge::BrickletIndustrialDual020mA->new(&UID, $ipcon); # Create device object

# Callback function for current callback (parameter has unit nA)
sub cb_current
{
    my ($sensor, $current) = @_;

    print "Current (sensor $sensor): ".$current/(1000.0*1000.0)." mA\n";
}

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Set Period (sensor 1) for current callback to 1s (1000ms)
# Note: The callback is only called every second if the 
#       current has changed since the last call!
$id020->set_current_callback_period(1, 1000);

# Register current callback to function cb_current
$id020->register_callback($id020->CALLBACK_CURRENT, 'cb_current');

print "Press any key to exit...\n";
<STDIN>;
$ipcon->disconnect();
