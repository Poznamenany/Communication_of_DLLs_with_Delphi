program DLL_MainProgram;
// Example of communication between Delphi and C++ with using shared functions, callbacks and interface
{$APPTYPE CONSOLE}

{$R *.res}

uses
  Windows,
  System.SysUtils,
  CommDLL in 'CommDLL.pas',
  CommonDataTypes in 'CommonDataTypes.pas',
  ExtAIAPI in 'ExtAIAPI.pas',
  InterfaceDelphi in 'InterfaceDelphi.pas',
  ExtAIMaster in 'ExtAIMaster.pas';

const
  // Relative path to DLL
  str_DELPHI_DLL_PATH = '..\..\DLL_Delphi\Win32\Debug\DLL_Library.dll';
  str_C_DLL_PATH = '..\..\DLL_C\DLL_library.dll';

var
  ExtAIMaster: TExtAIMaster;
  dllPath: string;
  I: Integer;
begin
  Writeln('Start test');
  dllPath := str_DELPHI_DLL_PATH;
  //dllPath := str_C_DLL_PATH;

  //@Martin: The code below closely resembles gGameApp code in KP/KMR. 
  // Let's restructure it that way:

  // gGameApp init:
  // (Try/Finally stripped out for readability)
  // Inititalize ExtAI master and list what was found
  ExtAIMaster := TExtAIMaster.Create();
  ExtAIMaster.NewDLL(dllPath);
  //todo: display a list of ExtAIs that ExtAIMaster has found
  
  // gGame start:
  // New mission is being started. Configure and init ExtAIs
  ExtAIMaster.NewExtAI(dllPath, 1);
  //todo: extAI := ExtAIMaster.NewExtAI(dllPath, 1);
  //ExtAIMaster.NewExtAI(dllPath, 2);
  //ExtAIMaster.NewExtAI(dllPath, 3);
  
  // gGame.UpdateState flow:
  // Each tick the game does its work. ExtAI should integrate with that
  for I := 0 to 999 do
  begin
    //todo: issue event to extAI
    //todo: Trigers, Start event, etc.
    //todo: extAI.UpdateState ?
  end;

  //gGame end:
  // Mission has ended, ExtAIs need to be freed
  //todo: extAI.Release

  //gGameApp end:
  // App is terminated.
  ExtAIMaster.Free();

  Writeln('Test is finished. Press Enter');
  ReadLn;
end.
