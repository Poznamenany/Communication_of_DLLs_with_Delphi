library DLL_Library;

uses
  SysUtils,
  Classes,
  CommonDataTypes;

{$R *.res}

type
  // cdecl = Change calling convention to C
  // Declare callback function types
  // Actions
  TAction1 = function(sig: ui8): b; cdecl;
  // States
  TState1 = function(sig: ui32): si16; cdecl;


var
  Action1: TAction1;
  State1: TState1;


// Actions
procedure CallbackAction1(aAction1: TAction1); cdecl;
begin
  Action1 := aAction1;
  writeln('DLL CallbackAction1');
  Action1(211);
end;

// Events
procedure InitDLL(); cdecl;
begin
  writeln('DLL InitDLL - Delphi');
  // gExtAI := TExtAI.Create();
end;

procedure TerminDLL(); cdecl;
begin
  writeln('DLL TerminDLL - Delphi');
  // gExtAI.Free();
end;

procedure Event1(aID: ui32; aAct: ui16); cdecl;
begin
  writeln('DLL Event1, ID: ' + IntToStr(aID) + '; Act: ' + IntToStr(aAct));
end;

procedure Loop(aTick: si64); cdecl;
begin
  writeln('DLL Loop, tick: ' + IntToStr(aTick));
  //test := State1(1,2);
  //Action1(50);
end;

// States
procedure CallbackState1(aState1: TState1); cdecl;
begin
  State1 := aState1;
  writeln('DLL CallbackState1');
  State1(211);
end;


// Exports
exports
  CallbackAction1,
  InitDLL,
  TerminDLL,
  Event1,
  Loop,
  CallbackState1;

begin
  writeln('DLL Main code');
end.
