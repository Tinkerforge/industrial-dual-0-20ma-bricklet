function matlab_example_callback()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletIndustrialDual020mA;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'ftn'; % Change to your UID
    
    ipcon = IPConnection(); % Create IP connection
    dual020 = BrickletIndustrialDual020mA(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    dual020.setDebouncePeriod(10000);

    % Register threshold reached callback to function cb_reached
    set(dual020, 'CurrentReachedCallback', @(h, e) cb_reached(e));

    % Configure threshold (sensor 1) for "greater than 10mA" (unit is nA)
    dual020.setCurrentCallbackThreshold(1, '>', 10*1000*1000, 0);

    input('Press any key to exit...\n', 's');
    ipcon.disconnect();
end

% Callback for current greater than 10mA
function cb_reached(e)
    fprintf('Current [sensor %g]: %g mA\n', e.sensor, e.current/(1000*1000));
end
