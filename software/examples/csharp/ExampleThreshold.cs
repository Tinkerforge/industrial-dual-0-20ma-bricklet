using System;
using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change to your UID

	// Callback function for current reached callback (parameter has unit nA)
	static void CurrentReachedCB(BrickletIndustrialDual020mA sender, byte sensor, int current)
	{
		Console.WriteLine("Sensor: " + sensor);
		Console.WriteLine("Current: " + current/1000000.0 + " mA");
		Console.WriteLine("");
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletIndustrialDual020mA id020 =
		  new BrickletIndustrialDual020mA(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		id020.SetDebouncePeriod(10000);

		// Register current reached callback to function CurrentReachedCB
		id020.CurrentReached += CurrentReachedCB;

		// Configure threshold for current (sensor 1) "greater than 10 mA" (unit is nA)
		id020.SetCurrentCallbackThreshold(1, '>', 10*1000000, 0);

		Console.WriteLine("Press enter to exit");
		Console.ReadLine();
		ipcon.Disconnect();
	}
}
