Imports Tinkerforge

Module ExampleSimple
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change to your UID

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim industrial_dual_0_20ma As New BrickletIndustrialDual020mA(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get current current from sensor 1 (unit is nA)
        Dim current As Integer = industrial_dual_0_20ma.GetCurrent(1)

        System.Console.WriteLine("Current (sensor 1): " + (current/(1000.0*1000)).ToString() + " mA")

        System.Console.WriteLine("Press key to exit")
        System.Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
