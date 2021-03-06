function matlab_example_callback()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletIndustrialDual020mA;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

    ipcon = IPConnection(); % Create IP connection
    id020 = handle(BrickletIndustrialDual020mA(UID, ipcon), 'CallbackProperties'); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Register current callback to function cb_current
    set(id020, 'CurrentCallback', @(h, e) cb_current(e));

    % Set period for current (sensor 1) callback to 1s (1000ms)
    % Note: The current (sensor 1) callback is only called every second
    %       if the current (sensor 1) has changed since the last call!
    id020.setCurrentCallbackPeriod(1, 1000);

    input('Press key to exit\n', 's');
    ipcon.disconnect();
end

% Callback function for current callback
function cb_current(e)
    fprintf('Sensor: %i\n', e.sensor);
    fprintf('Current: %g mA\n', e.current/1000000.0);
    fprintf('\n');
end
