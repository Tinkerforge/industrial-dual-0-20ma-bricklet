#!/usr/bin/perl  

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletIndustrialDual020mA;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'ftn'; # Change to your UID

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $dual020 = Tinkerforge::BrickletIndustrialDual020mA->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get current current for sensor 1 (unit is nA)
my $current = $dual020->get_current(1)/(1000.0*1000.0);
print "Current: $current mA\n";

print "Press any key to exit...\n";
<STDIN>;
$ipcon->disconnect();

