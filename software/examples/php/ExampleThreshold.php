<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletIndustrialDual020mA.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletIndustrialDual020mA;

$host = 'localhost';
$port = 4223;
$uid = 'XYZ'; // Change to your UID

// Callback for current greater than 5A
function cb_reached($sensor, $current)
{
    echo "Current (sensor " . $sensor . ") is greater than 10mA: " . $current / (1000.0*1000.0) . "\n";
}

$ipcon = new IPConnection(); // Create IP connection
$dual020 = new BrickletIndustrialDual020mA($uid, $ipcon); // Create device object

$ipcon->connect($host, $port); // Connect to brickd
// Don't use device before ipcon is connected

// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$dual020->setDebouncePeriod(10000);

// Register threshold reached callback to function cb_reached
$dual020->registerCallback(BrickletIndustrialDual020mA::CALLBACK_CURRENT_REACHED, 'cb_reached');

// Configure threshold (sensor 1) for "greater than 10mA" (unit is nA)
$dual020->setCurrentCallbackThreshold(1, '>', 5*1000, 0);

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
