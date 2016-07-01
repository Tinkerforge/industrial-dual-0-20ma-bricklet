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
        // Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        id020.setDebouncePeriod(10000);

        // Configure threshold for current (sensor 1) "greater than 10 mA" (unit is nA)
        id020.setCurrentCallbackThreshold(1, '>', 10*1000000, 0);
    }
);

// Register current reached callback
id020.on(Tinkerforge.BrickletIndustrialDual020mA.CALLBACK_CURRENT_REACHED,
    // Callback function for current reached callback (parameter has unit nA)
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
