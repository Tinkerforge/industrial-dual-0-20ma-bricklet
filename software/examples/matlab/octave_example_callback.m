function octave_example_callback
    more off;
    
    HOST = "localhost";
    PORT = 4223;
    UID = "ftn"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    dual020 = java_new("com.tinkerforge.BrickletIndustrialDual020mA", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Set Period (sensor 1) for current callback to 1s (1000ms)
    % Note: The callback is only called every second if the 
    %       current has changed since the last call!
    dual020.setCurrentCallbackPeriod(1, 1000);

    % Register current callback to function cb_current
    dual020.addCurrentListener("cb_current");

    input("\nPress any key to exit...\n", "s");
    ipcon.disconnect();
end

% Callback function for current callback (parameter has unit nA)
function cb_current(sensor_value, current_value)
    fprintf("Current [sensor %s] : %g mA\n", sensor_value.toString(), current_value/(1000*1000));
end
