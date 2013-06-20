Imports Tinkerforge

Module ExampleCallback
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change to your UID

    ' Callback function for current callback (parameter has unit nA)
    Sub CurrentCB(ByVal sender As BrickletIndustrialDual020mA, ByVal sensor As Byte, ByVal current As Integer)
        System.Console.WriteLine("Current (sensor" + sensor.ToString() + "): " + (current/(1000.0*1000.0)).ToString() + " mA")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim industrial_dual_0_20_ma As New BrickletIndustrialDual020mA(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Set Period (sensor 1) for current callback to 1s (1000ms)
        ' Note: The current callback is only called every second if the 
        '       current has changed since the last call!
        industrial_dual_0_20_ma.SetCurrentCallbackPeriod(1, 1000)

        ' Register current callback to function CurrentCB
        AddHandler industrial_dual_0_20_ma.Current, AddressOf CurrentCB

        System.Console.WriteLine("Press key to exit")
        System.Console.ReadKey()
        ipcon.Disconnect()
    End Sub
End Module
