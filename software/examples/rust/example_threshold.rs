use std::{error::Error, io, thread};
use tinkerforge::{industrial_dual_0_20ma_bricklet::*, ipconnection::IpConnection};

const HOST: &str = "127.0.0.1";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection
    let industrial_dual_0_20ma_bricklet = IndustrialDual020mABricklet::new(UID, &ipcon); // Create device object

    ipcon.connect(HOST, PORT).recv()??; // Connect to brickd
                                        // Don't use device before ipcon is connected

    // Get threshold listeners with a debounce time of 10 seconds (10000ms)
    industrial_dual_0_20ma_bricklet.set_debounce_period(10000);

    //Create listener for current reached events.
    let current_reached_listener = industrial_dual_0_20ma_bricklet.get_current_reached_receiver();
    // Spawn thread to handle received events. This thread ends when the industrial_dual_0_20ma_bricklet
    // is dropped, so there is no need for manual cleanup.
    thread::spawn(move || {
        for event in current_reached_listener {
            println!("Sensor: {}", event.sensor);
            println!("Current: {}{}", event.current as f32 / 1000000.0, " mA");
            println!();
        }
    });

    // Configure threshold for current (sensor 1) "greater than 10 mA"
    industrial_dual_0_20ma_bricklet.set_current_callback_threshold(1, '>', 10 * 1000000, 0);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
