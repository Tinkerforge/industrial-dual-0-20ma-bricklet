function octave_example_callback()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    id020 = java_new("com.tinkerforge.BrickletIndustrialDual020mA", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Register current callback to function cb_current
    id020.addCurrentCallback(@cb_current);

    % Set period for current (sensor 1) callback to 1s (1000ms)
    % Note: The current (sensor 1) callback is only called every second
    %       if the current (sensor 1) has changed since the last call!
    id020.setCurrentCallbackPeriod(1, 1000);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end

% Callback function for current callback (parameter has unit nA)
function cb_current(e)
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
