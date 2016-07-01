<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletIndustrialDual020mA.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletIndustrialDual020mA;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

// Callback function for current callback (parameter has unit nA)
function cb_current($sensor, $current)
{
    echo "Sensor: $sensor\n";
    echo "Current: " . $current/1000000.0 . " mA\n";
    echo "\n";
}

$ipcon = new IPConnection(); // Create IP connection
$id020 = new BrickletIndustrialDual020mA(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Register current callback to function cb_current
$id020->registerCallback(BrickletIndustrialDual020mA::CALLBACK_CURRENT, 'cb_current');

// Set period for current (sensor 1) callback to 1s (1000ms)
// Note: The current (sensor 1) callback is only called every second
//       if the current (sensor 1) has changed since the last call!
$id020->setCurrentCallbackPeriod(1, 1000);

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
