use std::{error::Error, io};

use tinkerforge::{industrial_dual_0_20ma_bricklet::*, ipconnection::IpConnection};

const HOST: &str = "127.0.0.1";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection
    let industrial_dual_0_20ma_bricklet = IndustrialDual020mABricklet::new(UID, &ipcon); // Create device object

    ipcon.connect(HOST, PORT).recv()??; // Connect to brickd
                                        // Don't use device before ipcon is connected

    // Get current current from sensor 1
    let current = industrial_dual_0_20ma_bricklet.get_current(1).recv()?;
    println!("Current (Sensor 1): {}{}", current as f32 / 1000000.0, " mA");

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
