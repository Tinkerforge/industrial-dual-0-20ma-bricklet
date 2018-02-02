var Tinkerforge = require('tinkerforge');

var HOST = 'localhost';
var PORT = 4223;
var UID = 'XYZ'; // Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

var ipcon = new Tinkerforge.IPConnection(); // Create IP connection
var id020 = new Tinkerforge.BrickletIndustrialDual020mA(UID, ipcon); // Create device object

ipcon.connect(HOST, PORT,
    function (error) {
        console.log('Error: ' + error);
    }
); // Connect to brickd
// Don't use device before ipcon is connected

ipcon.on(Tinkerforge.IPConnection.CALLBACK_CONNECTED,
    function (connectReason) {
        // Set period for current (sensor 1) callback to 1s (1000ms)
        // Note: The current (sensor 1) callback is only called every second
        //       if the current (sensor 1) has changed since the last call!
        id020.setCurrentCallbackPeriod(1, 1000);
    }
);

// Register current callback
id020.on(Tinkerforge.BrickletIndustrialDual020mA.CALLBACK_CURRENT,
    // Callback function for current callback
    function (sensor, current) {
        console.log('Sensor: ' + sensor);
        console.log('Current: ' + current/1000000.0 + ' mA');
        console.log();
    }
);

console.log('Press key to exit');
process.stdin.on('data',
    function (data) {
        ipcon.disconnect();
        process.exit(0);
    }
);
