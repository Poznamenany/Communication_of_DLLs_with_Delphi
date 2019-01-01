program DLL_MainProgram;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Windows, System.SysUtils,
  CommunicationDLL, CommonDataTypes;

const
  // Relative path to DLL
  str_DELPHI_DLL = '..\..\DLL_Delphi\Win32\Debug\DLL_Library.dll';
  str_C_DLL = '..\..\DLL_C\DLL_library.dll';

var
  comm: TCommunicationDLL;
begin
  writeln('Start test');

  comm := TCommunicationDLL.Create();
  try
    comm.FindDLL(str_DELPHI_DLL); // Choose DLL
    //comm.FindDLL(str_C_DLL); // Choose DLL
    comm.InitDLL();

    //...
    comm.Event1(10000, 512);
    //...
    comm.Loop(si64(-9223372036854775805));
    //...

    comm.TerminDLL();
  finally
    comm.free();
  end;

  writeln('Test is finished. Press Enter');
  ReadLn;
end.
