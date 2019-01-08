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
begin
  Writeln('Start test');
  dllPath := str_DELPHI_DLL_PATH;
  //dllPath := str_C_DLL_PATH;

  ExtAIMaster := TExtAIMaster.Create();
  try
    ExtAIMaster.NewDLL(dllPath);

    ExtAIMaster.NewExtAI(dllPath, 1);
    //ExtAIMaster.NewExtAI(dllPath, 2);
    //ExtAIMaster.NewExtAI(dllPath, 3);

    // Trigers, Start event, etc.

    ExtAIMaster.UpdateState();
  finally
    ExtAIMaster.Free();
  end;

  Writeln('Test is finished. Press Enter');
  ReadLn;
end.
