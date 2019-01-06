program DLL_MainProgram;
/// Example of communication between Delphi and C++ with using shared functions, callbacks and interface
{$APPTYPE CONSOLE}

{$R *.res}

uses
  Windows, System.SysUtils, MainExtAI, CommonDataTypes;

const
  // Relative path to DLL
  str_DELPHI_DLL = '..\..\DLL_Delphi\Win32\Debug\DLL_Library.dll';
  str_C_DLL = '..\..\DLL_C\DLL_library.dll';

var
  ExtAIMaster: TExtAIMaster;
  ActualDLL: String;
begin

  writeln('Start test');
  //ActualDLL := str_DELPHI_DLL;
  ActualDLL := str_C_DLL;

  ExtAIMaster := TExtAIMaster.Create();
  try
    ExtAIMaster.NewDLL(ActualDLL);

    ExtAIMaster.NewExtAI(ActualDLL, 1);
    //ExtAIMaster.NewExtAI(ActualDLL, 2);
    //ExtAIMaster.NewExtAI(ActualDLL, 3);

    // Trigers, Start event, etc.

    ExtAIMaster.UpdateState();
  finally
    ExtAIMaster.Free();
  end;

  writeln('Test is finished. Press Enter');
  ReadLn;
end.
