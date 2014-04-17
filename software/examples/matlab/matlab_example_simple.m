function matlab_example_simple()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletIndustrialDual020mA;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'ftn'; % Change to your UID
    
    ipcon = IPConnection(); % Create IP connection
    dual020 = BrickletIndustrialDual020mA(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current current for sensor 1 (unit is nA)
    current = dual020.getCurrent(1);
    fprintf('Current: %g mA', current/(1000*1000));

    input('Press any key to exit...\n', 's');
    ipcon.disconnect();
end
