function octave_example_threshold()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "ftn"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    dual020 = java_new("com.tinkerforge.BrickletIndustrialDual020mA", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    dual020.setDebouncePeriod(10000);

    % Register threshold reached callback to function cb_reached
    dual020.addCurrentReachedCallback(@cb_reached);

    % Configure threshold (sensor 1) for "greater than 10mA" (unit is nA)
    dual020.setCurrentCallbackThreshold(1, dual020.THRESHOLD_OPTION_GREATER, 10*1000*1000, 0);

    input("Press any key to exit...\n", "s");
    ipcon.disconnect();
end

% Callback function for current callback (parameter has unit nA)
function cb_reached(e)
    fprintf("Current [sensor %d]: %g mA\n", short2int(e.sensor), e.current/(1000*1000));
end

function int = short2int(short)
    if compare_versions(version(), "3.8", "<=")
        int = short.intValue();
    else
        int = short;
    end
end
