#!/usr/bin/perl

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletIndustrialDual020mA;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change to your UID

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $id020 = Tinkerforge::BrickletIndustrialDual020mA->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get current current from sensor 1 (unit is nA)
my $current = $id020->get_current(1);
print "Current (Sensor 1): " . $current/1000000.0 . " mA\n";

print "Press any key to exit...\n";
<STDIN>;
$ipcon->disconnect();
