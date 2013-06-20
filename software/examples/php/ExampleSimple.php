<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletIndustrialDual020mA.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletIndustrialDual020mA;

$host = 'localhost';
$port = 4223;
$uid = 'XYZ'; // Change to your UID

$ipcon = new IPConnection(); // Create IP connection
$dual020 = new BrickletIndustrialDual020mA($uid, $ipcon); // Create device object

$ipcon->connect($host, $port); // Connect to brickd
// Don't use device before ipcon is connected

// Get current current from sensor 1 (unit is nA)
$current = $dual020->getCurrent(1) / (1000.0*1000.0);

echo "Current: $current mA\n";

echo "Press key to exit\n";
fgetc(fopen('php://stdin', 'r'));

?>
