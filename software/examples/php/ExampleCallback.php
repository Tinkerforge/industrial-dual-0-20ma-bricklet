<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletIndustrialDual020mA.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletIndustrialDual020mA;

$host = 'localhost';
$port = 4223;
$uid = 'XYZ'; // Change to your UID

// Callback function for current callback (parameter has unit mA)
function cb_current($sensor, $current)
{
    echo "Current (sensor " . $sensor . "): " . $current / (1000.0*1000.0) . " mA\n";
}

$ipcon = new IPConnection(); // Create IP connection
$dual020 = new BrickletIndustrialDual020mA($uid, $ipcon); // Create device object

$ipcon->connect($host, $port); // Connect to brickd
// Don't use device before ipcon is connected

// Set Period (sensor 1) for current callback to 1s (1000ms)
// Note: The callback is only called every second if the 
//       current has changed since the last call!
$dual020->setCurrentCallbackPeriod(1, 1000);

// Register current callback to function cb_current
$dual020->registerCallback(BrickletIndustrialDual020mA::CALLBACK_CURRENT, 'cb_current');

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
