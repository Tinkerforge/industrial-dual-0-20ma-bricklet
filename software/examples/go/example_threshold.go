package main

import (
	"fmt"
	"github.com/tinkerforge/go-api-bindings/industrial_dual_0_20ma_bricklet"
	"github.com/tinkerforge/go-api-bindings/ipconnection"
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

	// Get threshold receivers with a debounce time of 10 seconds (10000ms).
	id020.SetDebouncePeriod(10000)

	id020.RegisterCurrentReachedCallback(func(sensor uint8, current int32) {
		fmt.Printf("Sensor: %d\n", sensor)
		fmt.Printf("Current: %f mA\n", float64(current)/1000000.0)
		fmt.Println()
	})

	// Configure threshold for current (sensor 1) "greater than 10 mA".
	id020.SetCurrentCallbackThreshold(1, '>', 10*1000000, 0)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()

}
