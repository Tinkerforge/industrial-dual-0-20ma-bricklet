function matlab_example_threshold()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletIndustrialDual020mA;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change to your UID

    ipcon = IPConnection(); % Create IP connection
    id020 = handle(BrickletIndustrialDual020mA(UID, ipcon), 'CallbackProperties'); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    id020.setDebouncePeriod(10000);

    % Register current reached callback to function cb_current_reached
    set(id020, 'CurrentReachedCallback', @(h, e) cb_current_reached(e));

    % Configure threshold for current (sensor 1) "greater than 10 mA" (unit is nA)
    id020.setCurrentCallbackThreshold(1, '>', 10*1000000, 0);

    input('Press key to exit\n', 's');
    ipcon.disconnect();
end

% Callback function for current reached callback (parameter has unit nA)
function cb_current_reached(e)
    fprintf('Sensor: %i\n', e.sensor);
    fprintf('Current: %g mA\n', e.current/1000000.0);
    fprintf('\n');
end
