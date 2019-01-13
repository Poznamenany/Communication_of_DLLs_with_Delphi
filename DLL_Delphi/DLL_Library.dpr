library DLL_Library;

{$DEFINE DLL_Library}

uses
  SysUtils, Classes, ExtAI, InterfaceDelphi, CommonDataTypes;

{$R *.res}

type
  TCallback1 = function(sig: ui8): b of object; StdCall;

var
  ExtAICnt: ui8;
  ExtAI: array[0..11] of TExtAI;
  Callback1: TCallback1;


procedure InitDLL(); StdCall;
var
  K: ui8;
begin
  writeln('  DLL: InitDLL - Delphi');
  ExtAICnt := 0;
  for K := Low(ExtAI) to High(ExtAI) do
  begin
    ExtAI[K] := nil;
  end;
end;

procedure TerminDLL(); StdCall;
var
  K: ui8;
begin
  writeln('  DLL: TerminDLL - Delphi');
  for K := Low(ExtAI) to High(ExtAI) do
    if (ExtAI[K] <> nil) then
    begin
      ExtAI[K].Actions := nil; // = decrement Interface Actions
      ExtAI[K] := nil; // = decrement Interface Events
    end;
end;

function NewExtAI(): IEvents; SafeCall;
begin
  writeln('  DLL: NewExtAI - Delphi');
  ExtAI[ExtAICnt] := TExtAI.Create(); // = increment Interface Events
  Inc(ExtAICnt);
  Result := ExtAI[ExtAICnt-1]; // Return pointer to this class (ExtAI is derived from event interface)
end;

procedure InitNewExtAI(aID: ui8; aActions: IActions); StdCall;
var
  tst: si32;
begin
  writeln('  DLL: InitNewExtAI - Delphi');
  ExtAI[ExtAICnt-1].ID := aID;
  ExtAI[ExtAICnt-1].Actions := aActions; // = increment Interface Actions
end;


procedure RegisterCallback1(aCallback1: TCallback1); StdCall;
begin
  writeln('  DLL: Callback1');
  Callback1 := aCallback1;
  Callback1(212);
end;

// Exports
exports
  InitDLL,
  TerminDLL,
  NewExtAI,
  InitNewExtAI,
  RegisterCallback1;

begin
end.
