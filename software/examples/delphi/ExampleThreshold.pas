program ExampleThreshold;

{$ifdef MSWINDOWS}{$apptype CONSOLE}{$endif}
{$ifdef FPC}{$mode OBJFPC}{$H+}{$endif}

uses
  SysUtils, IPConnection, BrickletIndustrialDual020mA;

type
  TExample = class
  private
    ipcon: TIPConnection;
    id020: TBrickletIndustrialDual020mA;
  public
    procedure ReachedCB(sender: TBrickletIndustrialDual020mA; const sensor: byte; const current: longint);
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'XYZ'; { Change to your UID }

var
  e: TExample;

{ Callback for current greater than 10mA }
procedure TExample.ReachedCB(sender: TBrickletIndustrialDual020mA; const sensor: byte; const current: longint);
begin
  WriteLn(Format('Current (sensor %d) is greater than 10mA: %f', [sensor, current/(1000.0*1000.0)]));
end;

procedure TExample.Execute;
begin
  { Create IP connection }
  ipcon := TIPConnection.Create;

  { Create device object }
  id020 := TBrickletIndustrialDual020mA.Create(UID, ipcon);

  { Connect to brickd }
  ipcon.Connect(HOST, PORT);
  { Don't use device before ipcon is connected }

  { Get threshold callbacks with a debounce time of 10 seconds (10000ms) }
  id020.SetDebouncePeriod(10000);

  { Register threshold reached callback to procedure ReachedCB }
  id020.OnCurrentReached := {$ifdef FPC}@{$endif}ReachedCB;

  { Configure threshold (sensor 1) for "greater than 10mA" (unit is nA) }
  id020.SetCurrentCallbackThreshold(1, '>', 10*1000*1000, 0);

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy; { Calls ipcon.Disconnect internally }
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
