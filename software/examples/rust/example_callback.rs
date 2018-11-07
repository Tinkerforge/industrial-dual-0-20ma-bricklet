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

    let current_receiver = id020.get_current_callback_receiver();

    // Spawn thread to handle received callback messages.
    // This thread ends when the `id020` object
    // is dropped, so there is no need for manual cleanup.
    thread::spawn(move || {
        for current in current_receiver {
            println!("Sensor: {}", current.sensor);
            println!("Current: {} mA", current.current as f32 / 1000000.0);
            println!();
        }
    });

    // Set period for current (sensor 1) receiver to 1s (1000ms).
    // Note: The current (sensor 1) callback is only called every second
    //       if the current (sensor 1) has changed since the last call!
    id020.set_current_callback_period(1, 1000);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
