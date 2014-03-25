function matlab_example_callback
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletIndustrialDual020mA;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'ftn'; % Change to your UID
    
    ipcon = IPConnection(); % Create IP connection
    dual020 = BrickletIndustrialDual020mA(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Set Period (sensor 1) for current callback to 1s (1000ms)
    % Note: The callback is only called every second if the 
    %       current has changed since the last call!
    dual020.setCurrentCallbackPeriod(1, 1000);

    % Register current callback to function cb_current
    set(dual020, 'CurrentCallback', @(h, e)cb_current(e.sensor, e.current));

    input('\nPress any key to exit...\n', 's');
    ipcon.disconnect();
end

% Callback function for current callback (parameter has unit nA)
function cb_current(sensor_value, current_value)
    fprintf('Current [sensor %g] : %g mA\n', sensor_value, current_value/(1000*1000));
end
