function matlab_example_simple()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletIndustrialDual020mA;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change to your UID

    ipcon = IPConnection(); % Create IP connection
    id020 = handle(BrickletIndustrialDual020mA(UID, ipcon), 'CallbackProperties'); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current current from sensor 1 (unit is nA)
    current = id020.getCurrent(1);
    fprintf('Current (Sensor 1): %g mA\n', current/1000000.0);

    input('Press key to exit\n', 's');
    ipcon.disconnect();
end
