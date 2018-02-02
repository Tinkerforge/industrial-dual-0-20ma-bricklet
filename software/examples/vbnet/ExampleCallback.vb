Imports System
Imports Tinkerforge

Module ExampleCallback
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

    ' Callback subroutine for current callback
    Sub CurrentCB(ByVal sender As BrickletIndustrialDual020mA, ByVal sensor As Byte, _
                  ByVal current As Integer)
        Console.WriteLine("Sensor: " + sensor.ToString())
        Console.WriteLine("Current: " + (current/1000000.0).ToString() + " mA")
        Console.WriteLine("")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim id020 As New BrickletIndustrialDual020mA(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Register current callback to subroutine CurrentCB
        AddHandler id020.CurrentCallback, AddressOf CurrentCB

        ' Set period for current (sensor 1) callback to 1s (1000ms)
        ' Note: The current (sensor 1) callback is only called every second
        '       if the current (sensor 1) has changed since the last call!
        id020.SetCurrentCallbackPeriod(1, 1000)

        Console.WriteLine("Press key to exit")
        Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
