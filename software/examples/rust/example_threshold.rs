use std::{error::Error, io, thread};
use tinkerforge::{industrial_dual_0_20ma_bricklet::*, ip_connection::IpConnection};

const HOST: &str = "localhost";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet.

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection.
    let id020 = IndustrialDual020maBricklet::new(UID, &ipcon); // Create device object.

    ipcon.connect((HOST, PORT)).recv()??; // Connect to brickd.
                                          // Don't use device before ipcon is connected.

    // Get threshold receivers with a debounce time of 10 seconds (10000ms).
    id020.set_debounce_period(10000);

    // Create receiver for current reached events.
    let current_reached_receiver = id020.get_current_reached_receiver();

    // Spawn thread to handle received events. This thread ends when the `id020` object
    // is dropped, so there is no need for manual cleanup.
    thread::spawn(move || {
        for current_reached in current_reached_receiver {
            println!("Sensor: {}", current_reached.sensor);
            println!("Current: {} mA", current_reached.current as f32 / 1000000.0);
            println!();
        }
    });

    // Configure threshold for current (sensor 1) "greater than 10 mA".
    id020.set_current_callback_threshold(1, '>', 10 * 1000000, 0);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
