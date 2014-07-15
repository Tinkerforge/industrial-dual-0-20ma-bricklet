import com.tinkerforge.BrickletIndustrialDual020mA;
import com.tinkerforge.IPConnection;

public class ExampleSimple {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;
	private static final String UID = "XYZ"; // Change to your UID

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions you
	//       might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletIndustrialDual020mA dual020 =
		  new BrickletIndustrialDual020mA(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get current current from sensor 1 (unit is nA)
		int current = dual020.getCurrent((short)1); // Can throw IPConnection.TimeoutException

		System.out.println("Current (sensor 1): " + current/(1000.0*1000.0) + " mA");

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
