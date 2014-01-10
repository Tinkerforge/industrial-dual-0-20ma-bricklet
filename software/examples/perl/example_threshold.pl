#!/usr/bin/perl  

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletIndustrialDual020mA;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'ftn'; # Change to your UID

my $ipcon = IPConnection->new(); # Create IP connection
my $dual020 = BrickletIndustrialDual020mA->new(&UID, $ipcon); # Create device object

# Callback for current greater than 10mA
sub cb_reached
{
    my ($sensor, $current) = @_;
    print "\nCurrent (sensor ".$sensor.") is greather than 10mA: ".$current/(1000.0*1000.0)." mA\n";
}

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$dual020->set_debounce_period(10000);

# Register threshold reached callback to function cb_reached
$dual020->register_callback($dual020->CALLBACK_CURRENT_REACHED, 'cb_reached');

# Configure threshold (sensor 1) for "greater than 10mA" (unit is nA)
$dual020->set_current_callback_threshold(1, '>', 10*1000*1000, 0);

print "\nPress any key to exit...\n";
<STDIN>;
$ipcon->disconnect();

