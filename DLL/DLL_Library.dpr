library DLL_Library;

uses
  SysUtils,
  Classes,
  KP_CommonDataTypes,
  KP_MainCommClass in 'KP_MainCommClass.pas',
  ExtAI in 'ExtAI.pas';

{$R *.res}

var
  Comm: ICommunicationInterface = nil;
  TestExtAI: TKPTestExtAI = nil;


// Register communication interface
procedure RegisterCommInterface(aCommInt: ICommunicationInterface); stdcall;
begin
  writeln('DLL Register communication interface');
  Comm :=  aCommInt;
  // Test callbacks
  writeln('DLL action act1 was sent');
  Comm.Act1(1,1);
  writeln(  'DLL State received: ' + IntToStr( Comm.State1(1,1) )  );
end;


// Initialization
procedure InitDLL(); stdcall;
begin
  writeln('DLL InitializeExtAI');
  TestExtAI := TKPTestExtAI.Create();
end;

procedure TerminDLL(); stdcall;
begin
  writeln('DLL TerminateExtAI');
  TestExtAI.Free();
  TestExtAI := nil;
end;


// Events
procedure Event1(aVal: ui8); stdcall;
begin
  writeln('DLL CallEvent: ' + IntToStr(aVal));
end;

procedure EventMainLoop(); stdcall;
begin
  writeln('DLL CallLoop');
  TestExtAI.ExtAILoop();
end;


// Exports
exports
  RegisterCommInterface,
  InitDLL,
  TerminDLL,
  Event1,
  EventMainLoop;

begin
  writeln('DLL Main code');
end.
