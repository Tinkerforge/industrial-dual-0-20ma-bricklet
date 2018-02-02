function octave_example_threshold()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

    ipcon = javaObject("com.tinkerforge.IPConnection"); % Create IP connection
    id020 = javaObject("com.tinkerforge.BrickletIndustrialDual020mA", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    id020.setDebouncePeriod(10000);

    % Register current reached callback to function cb_current_reached
    id020.addCurrentReachedCallback(@cb_current_reached);

    % Configure threshold for current (sensor 1) "greater than 10 mA"
    id020.setCurrentCallbackThreshold(1, ">", 10*1000000, 0);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end

% Callback function for current reached callback
function cb_current_reached(e)
    fprintf("Sensor: %d\n", java2int(e.sensor));
    fprintf("Current: %g mA\n", e.current/1000000.0);
    fprintf("\n");
end

function int = java2int(value)
    if compare_versions(version(), "3.8", "<=")
        int = value.intValue();
    else
        int = value;
    end
end
