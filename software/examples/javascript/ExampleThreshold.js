var IPConnection = require('Tinkerforge/IPConnection');
var BrickletIndustrialDual020mA = require('Tinkerforge/BrickletIndustrialDual020mA');

var HOST = 'localhost';
var PORT = 4223;
var UID = 'ftn';// Change to your UID

var ipcon = new IPConnection();// Create IP connection
var dual020 = new BrickletIndustrialDual020mA(UID, ipcon);// Create device object

ipcon.connect(HOST, PORT,
    function(error) {
        console.log('Error: '+error);        
    }
);// Connect to brickd

// Don't use device before ipcon is connected
ipcon.on(IPConnection.CALLBACK_CONNECTED,
    function(connectReason) {
        // Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        dual020.setDebouncePeriod(10000);
        // Configure threshold (sensor 1) for "greater than 10mA" (unit is nA)
        dual020.setCurrentCallbackThreshold(1, '>', 10*1000*1000, 0);      
    }
);

// Register threshold reached callback
dual020.on(BrickletIndustrialDual020mA.CALLBACK_CURRENT_REACHED,
    // Callback for current greater than 10mA
    function(sensor, current) {
        console.log('Current (sensor '+sensor+') is greater than 10mA: '+current/(1000*1000)+' mA');
    }
);

console.log("Press any key to exit ...");
process.stdin.on('data',
    function(data) {
        ipcon.disconnect();
        process.exit(0);
    }
);

