Imports System
Imports Tinkerforge

Module ExampleThreshold
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change XYZ to the UID of your Industrial Dual 0-20mA Bricklet

    ' Callback subroutine for current reached callback (parameter has unit nA)
    Sub CurrentReachedCB(ByVal sender As BrickletIndustrialDual020mA, _
                         ByVal sensor As Byte, ByVal current As Integer)
        Console.WriteLine("Sensor: " + sensor.ToString())
        Console.WriteLine("Current: " + (current/1000000.0).ToString() + " mA")
        Console.WriteLine("")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim id020 As New BrickletIndustrialDual020mA(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        id020.SetDebouncePeriod(10000)

        ' Register current reached callback to subroutine CurrentReachedCB
        AddHandler id020.CurrentReached, AddressOf CurrentReachedCB

        ' Configure threshold for current "greater than 10 mA" (unit is nA)
        id020.SetCurrentCallbackThreshold(1, ">"C, 10*1000000, 0)

        Console.WriteLine("Press key to exit")
        Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
