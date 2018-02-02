function octave_example_simple()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

    ipcon = javaObject("com.tinkerforge.IPConnection"); % Create IP connection
    id020 = javaObject("com.tinkerforge.BrickletIndustrialDual020mA", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current current from sensor 1
    current = id020.getCurrent(1);
    fprintf("Current (Sensor 1): %g mA\n", current/1000000.0);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end
