using System;
using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

	// Callback function for current callback (parameter has unit nA)
	static void CurrentCB(BrickletIndustrialDual020mA sender, byte sensor, int current)
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

		// Register current callback to function CurrentCB
		id020.CurrentCallback += CurrentCB;

		// Set period for current (sensor 1) callback to 1s (1000ms)
		// Note: The current (sensor 1) callback is only called every second
		//       if the current (sensor 1) has changed since the last call!
		id020.SetCurrentCallbackPeriod(1, 1000);

		Console.WriteLine("Press enter to exit");
		Console.ReadLine();
		ipcon.Disconnect();
	}
}
