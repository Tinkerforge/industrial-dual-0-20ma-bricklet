package main

import (
	"fmt"
	"tinkerforge/industrial_dual_0_20ma_bricklet"
	"tinkerforge/ipconnection"
)

const ADDR string = "localhost:4223"
const UID string = "XYZ" // Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet.

func main() {
	ipcon := ipconnection.New()
	defer ipcon.Close()
	id020, _ := industrial_dual_0_20ma_bricklet.New(UID, &ipcon) // Create device object.

	ipcon.Connect(ADDR) // Connect to brickd.
	defer ipcon.Disconnect()
	// Don't use device before ipcon is connected.

	// Get current current from sensor 1.
	current, _ := id020.GetCurrent(1)
	fmt.Printf("Current (Sensor 1): %f mA\n", float64(current)/1000000.0)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()

}
