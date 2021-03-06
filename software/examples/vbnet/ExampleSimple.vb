Imports System
Imports Tinkerforge

Module ExampleSimple
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim id020 As New BrickletIndustrialDual020mA(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get current current from sensor 1
        Dim current As Integer = id020.GetCurrent(1)
        Console.WriteLine("Current (Sensor 1): " + (current/1000000.0).ToString() + " mA")

        Console.WriteLine("Press key to exit")
        Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
