program ExampleCallback;

{$ifdef MSWINDOWS}{$apptype CONSOLE}{$endif}
{$ifdef FPC}{$mode OBJFPC}{$H+}{$endif}

uses
  SysUtils, IPConnection, BrickletIndustrialDual020mA;

type
  TExample = class
  private
    ipcon: TIPConnection;
    dual020: TBrickletIndustrialDual020mA;
  public
    procedure CurrentCB(sender: TBrickletIndustrialDual020mA; const sensor: byte; const current: longint);
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'XYZ'; { Change to your UID }

var
  e: TExample;

{ Callback function for current callback (parameter has unit nA) }
procedure TExample.CurrentCB(sender: TBrickletIndustrialDual020mA; const sensor: byte; const current: longint);
begin
  WriteLn(Format('Current (sensor %d): %f mA', [sensor, current/(1000.0*1000.0)]));
end;

procedure TExample.Execute;
begin
  { Create IP connection }
  ipcon := TIPConnection.Create;

  { Create device object }
  dual020 := TBrickletIndustrialDual020mA.Create(UID, ipcon);

  { Connect to brickd }
  ipcon.Connect(HOST, PORT);
  { Don't use device before ipcon is connected }

  { Set Period (sensor 1) for current callback to 1s (1000ms)
    Note: The current callback is only called every second if the
          current has changed since the last call! }
  dual020.SetCurrentCallbackPeriod(1, 1000);

  { Register current callback to procedure CurrentCB }
  dual020.OnCurrent := {$ifdef FPC}@{$endif}CurrentCB;

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy;
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
