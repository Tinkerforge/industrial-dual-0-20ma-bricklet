var Tinkerforge = require('tinkerforge');

var HOST = 'localhost';
var PORT = 4223;
var UID = 'ftn';// Change to your UID

var ipcon = new Tinkerforge.IPConnection(); //Create IP connection
var dual020 = new Tinkerforge.BrickletIndustrialDual020mA(UID, ipcon);// Create device object

ipcon.connect(HOST, PORT,
    function(error) {
        console.log('Error: '+error);        
    }
);// Connect to brickd

// Don't use device before ipcon is connected
ipcon.on(Tinkerforge.IPConnection.CALLBACK_CONNECTED,
    function(connectReason) {
        // Get current current for sensor 1 (unit is nA)
        dual020.getCurrent(1, 
            function(current) {
                console.log('Current: '+current/(1000*1000)+' mA');
            },
            function(error) {
                console.log('Error: '+error);
            }
        );
    }
);

console.log("Press any key to exit ...");
process.stdin.on('data',
    function(data) {
        ipcon.disconnect();
        process.exit(0);
    }
);

