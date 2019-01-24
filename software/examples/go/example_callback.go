package main

import (
	"fmt"
	"github.com/Tinkerforge/go-api-bindings/industrial_dual_0_20ma_bricklet"
	"github.com/Tinkerforge/go-api-bindings/ipconnection"
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

	id020.RegisterCurrentCallback(func(sensor uint8, current int32) {
		fmt.Printf("Sensor: %d\n", sensor)
		fmt.Printf("Current: %f mA\n", float64(current)/1000000.0)
		fmt.Println()
	})

	// Set period for current (sensor 1) receiver to 1s (1000ms).
	// Note: The current (sensor 1) callback is only called every second
	//       if the current (sensor 1) has changed since the last call!
	id020.SetCurrentCallbackPeriod(1, 1000)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()
}
