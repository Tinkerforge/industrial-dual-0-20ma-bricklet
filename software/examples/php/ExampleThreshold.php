<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletIndustrialDual020mA.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletIndustrialDual020mA;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change to your UID

// Callback function for current reached callback (parameter has unit nA)
function cb_currentReached($sensor, $current)
{
    echo "Sensor: $sensor\n";
    echo "Current: " . $current/1000000.0 . " mA\n";
    echo "\n";
}

$ipcon = new IPConnection(); // Create IP connection
$id020 = new BrickletIndustrialDual020mA(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$id020->setDebouncePeriod(10000);

// Register current reached callback to function cb_currentReached
$id020->registerCallback(BrickletIndustrialDual020mA::CALLBACK_CURRENT_REACHED, 'cb_currentReached');

// Configure threshold for current (sensor 1) "greater than 10 mA" (unit is nA)
$id020->setCurrentCallbackThreshold(1, '>', 10*1000000, 0);

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
