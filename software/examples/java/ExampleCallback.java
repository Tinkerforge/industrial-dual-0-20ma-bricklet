import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletIndustrialDual020mA;

public class ExampleCallback {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;
	private static final String UID = "XYZ"; // Change to your UID

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions
	//       you might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletIndustrialDual020mA id020 =
		  new BrickletIndustrialDual020mA(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Add current listener (parameter has unit nA)
		id020.addCurrentListener(new BrickletIndustrialDual020mA.CurrentListener() {
			public void current(short sensor, int current) {
				System.out.println("Sensor: " + sensor);
				System.out.println("Current: " + current/1000000.0 + " mA");
				System.out.println("");
			}
		});

		// Set period for current (sensor 1) callback to 1s (1000ms)
		// Note: The current (sensor 1) callback is only called every second
		//       if the current (sensor 1) has changed since the last call!
		id020.setCurrentCallbackPeriod((short)1, 1000);

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
