import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletIndustrialDual020mA;

public class ExampleThreshold {
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

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		id020.setDebouncePeriod(10000);

		// Add current reached listener (parameter has unit nA)
		id020.addCurrentReachedListener(new BrickletIndustrialDual020mA.CurrentReachedListener() {
			public void currentReached(short sensor, int current) {
				System.out.println("Sensor: " + sensor);
				System.out.println("Current: " + current/1000000.0 + " mA");
				System.out.println("");
			}
		});

		// Configure threshold for current (sensor 1) "greater than 10 mA" (unit is nA)
		id020.setCurrentCallbackThreshold((short)1, '>', 10*1000000, 0);

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
