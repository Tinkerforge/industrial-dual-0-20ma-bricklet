using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change to your UID

	// Callback for current greater than 10mA
	static void ReachedCB(BrickletIndustrialDual020mA sender, byte sensor, int current)
	{
		System.Console.WriteLine("Current (Sensor " + sensor + ") is greater than 10mA: " +
		                         current/(1000000.0) + "mA");
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletIndustrialDual020mA id020 =
		  new BrickletIndustrialDual020mA(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 1 seconds (1000ms)
		id020.SetDebouncePeriod(1000);

		// Register threshold reached callback to function ReachedCB
		id020.CurrentReached += ReachedCB;

		// Configure threshold (sensor 1) for "greater than 10mA" (unit is nA)
		id020.SetCurrentCallbackThreshold(1, '>', 10*1000000, 0);

		System.Console.WriteLine("Press enter to exit");
		System.Console.ReadLine();
		ipcon.Disconnect();
	}
}
