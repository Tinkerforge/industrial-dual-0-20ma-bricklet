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
        // Get current current from sensor 1 (unit is nA)
        id020.getCurrent(1,
            function (current) {
                console.log('Current (Sensor 1): ' + current/1000000.0 + ' mA');
            },
            function (error) {
                console.log('Error: ' + error);
            }
        );
    }
);

console.log('Press key to exit');
process.stdin.on('data',
    function (data) {
        ipcon.disconnect();
        process.exit(0);
    }
);
