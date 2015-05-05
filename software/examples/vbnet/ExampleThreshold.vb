Imports Tinkerforge

Module ExampleThreshold
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change to your UID

    '  Callback for current greater than 10mA
    Sub ReachedCB(ByVal sender As BrickletIndustrialDual020mA, ByVal sensor As Byte, ByVal current As Integer)
        System.Console.WriteLine("Current (sensor " + sensor.ToString() + ") is greater than 10mA: " + (current/(1000.0*1000.0)).ToString() + "mA")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim industrial_dual_0_20ma As New BrickletIndustrialDual020mA(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get threshold callbacks with a debounce time of 1 seconds (1000ms)
        industrial_dual_0_20ma.SetDebouncePeriod(1000)

        ' Register threshold reached callback to function ReachedCB
        AddHandler industrial_dual_0_20ma.CurrentReached, AddressOf ReachedCB

        ' Configure threshold (sensor 1) for "greater than 10mA" (unit is nA)
        industrial_dual_0_20ma.SetCurrentCallbackThreshold(1, ">"C, 10*1000*1000, 0)

        System.Console.WriteLine("Press key to exit")
        System.Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
