using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change to your UID

	static void Main() 
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletIndustrialDual020mA dual020 =
		  new BrickletIndustrialDual020mA(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get current current from sensor 1 (unit is nA)
		int current = dual020.GetCurrent(1);

		System.Console.WriteLine("Current (sensor 1): " + current/(1000.0*1000.0) + " mA");

		System.Console.WriteLine("Press enter to exit");
		System.Console.ReadLine();
		ipcon.Disconnect();
	}
}
