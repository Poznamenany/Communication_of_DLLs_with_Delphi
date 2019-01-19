library DLL_Library;
{$DEFINE DLL_Library}
uses
  SysUtils, Classes, ExtAI, InterfaceDelphi, CommonDataTypes;

{$R *.res}

type
  TCallback1 = function(sig: ui8): b of object; StdCall;

const
  CONFIG: TDLLConfig = (
    Author: 'Jesus of Nazareth';
    Description: 'Test example for DLL with External AI (Delphi DLL)';
    ExtAIName: 'TestingExtAI Delphi';
    Version: 20190119
  );

var
  gExtAI: TList;
  Callback1: TCallback1;

procedure InitDLL(var aConfig: TDLLpConfig); StdCall;
begin
  writeln('  DLL: InitDLL - Delphi');
  gExtAI := TList.Create();
  with aConfig do
  begin
    Author := Addr(CONFIG.Author[1]);
    AuthorLen := Length(CONFIG.Author);
    Description := Addr(CONFIG.Description[1]);
    DescriptionLen := Length(CONFIG.Description);
    ExtAIName := Addr(CONFIG.ExtAIName[1]);
    ExtAINameLen := Length(CONFIG.ExtAIName);
    Version := CONFIG.Version;
  end;
end;

procedure TerminDLL(); StdCall;
var
  K: ui8;
begin
  writeln('  DLL: TerminDLL - Delphi');
  for K := 0 to gExtAI.Count-1 do
    if (gExtAI[K] <> nil) then
    begin
      TExtAI(gExtAI[K]).Actions := nil; // = decrement Interface Actions
      TExtAI(gExtAI[K]).States := nil; // = decrement Interface States
      gExtAI[K] := nil; // = decrement Interface Events
    end;
  gExtAI.Free();
end;

function NewExtAI(): IEvents; SafeCall;
var
  ExtAI: TExtAI;
begin
  writeln('  DLL: NewExtAI - Delphi');
  ExtAI := TExtAI.Create(); // = increment Interface Events
  gExtAI.Add(ExtAI);
  Result := ExtAI; // Return pointer to this class (ExtAI is derived from event interface)
end;

procedure InitNewExtAI(aID: ui8; aActions: IActions; aStates: IStates); StdCall;
begin
  writeln('  DLL: InitNewExtAI - Delphi');
  with TExtAI(gExtAI[gExtAI.Count-1]) do
  begin
    ID := aID;
    Actions := aActions; // = increment Interface Actions
    States := aStates; // = increment Interface States
  end;
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
