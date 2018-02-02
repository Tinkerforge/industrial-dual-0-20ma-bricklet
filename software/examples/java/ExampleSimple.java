import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletIndustrialDual020mA;

public class ExampleSimple {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;

	// Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet
	private static final String UID = "XYZ";

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions
	//       you might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletIndustrialDual020mA id020 =
		  new BrickletIndustrialDual020mA(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get current current from sensor 1
		int current = id020.getCurrent((short)1); // Can throw com.tinkerforge.TimeoutException
		System.out.println("Current (Sensor 1): " + current/1000000.0 + " mA");

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
