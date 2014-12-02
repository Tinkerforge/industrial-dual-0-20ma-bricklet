using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change to your UID

	// Callback function for current callback (parameter has unit nA)
	static void CurrentCB(BrickletIndustrialDual020mA sender, byte sensor, int current)
	{
		System.Console.WriteLine("Current (sensor " + sensor + "): " +
		                         current/(1000.0*1000.0) + " mA");
	}

	static void Main() 
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletIndustrialDual020mA dual020 =
		  new BrickletIndustrialDual020mA(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Set Period (sensor 1) for current callback to 1s (1000ms)
		// Note: The current callback is only called every second if the 
		//       current has changed since the last call!
		dual020.SetCurrentCallbackPeriod(1, 1000);

		// Register current callback to function CurrentCB
		dual020.Current += CurrentCB;

		System.Console.WriteLine("Press enter to exit");
		System.Console.ReadLine();
		ipcon.Disconnect();
	}
}
