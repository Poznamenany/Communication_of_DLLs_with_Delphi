program DLL_MainProgram;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Windows,
  System.SysUtils,
  KP_MainCommClass,
  KP_CommonDataTypes;

var
  CommInt: ICommunicationInterface;

// DLL static link to connect method (method must exists)
  // Initilization
  procedure InitDLL(); stdcall; external '..\..\DLL\Win32\Debug\DLL_Library.dll';
  procedure TerminDLL(); stdcall; external '..\..\DLL\Win32\Debug\DLL_Library.dll';
  // Events
  procedure Event1(aID: ui8); stdcall; external '..\..\DLL\Win32\Debug\DLL_Library.dll';
  procedure EventMainLoop(); stdcall; external '..\..\DLL\Win32\Debug\DLL_Library.dll';

// DLL dynamic link to connect method (method does not have to exist in ExtAI)
// Pass pointer to method to DLL and create callback (if DLL contain the same method)
function PassCommInterfaceToDLL(): Boolean;
var
  DLLHandle: THandle;
  pCommIntProc : procedure (aCommInt: ICommunicationInterface); stdcall;
begin
  CommInt := TKPMainCommClass.Create();
  DLLHandle := LoadLibrary('..\..\DLL\Win32\Debug\DLL_Library.dll');
  pCommIntProc := GetProcAddress(dllHandle, 'RegisterCommInterface');
  if assigned(pCommIntProc) then
      pCommIntProc(CommInt);
end;

var
  str_Commands: String;
begin
  {Constructor}
  CommInt := nil;
  PassCommInterfaceToDLL();
  InitDLL();

  {1 game Tick / 1 loop in thread}
  writeln('');
  writeln('Game Tick / loop of thread');
  // Event phase
  Event1(1);
  // Call Ext AI main loop
  EventMainLoop();
  // Within events are called states and actions, next approach must be discussed

  {Destructor}
  writeln('');
  writeln('Destructor');
  TerminDLL();

  writeln('Test is finished. Press Enter');
  ReadLn;

end.
