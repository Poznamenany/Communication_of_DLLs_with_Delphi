program DLL_MainProgram;
// Example of communication between Delphi and C++ with using shared functions, callbacks and interface
{$APPTYPE CONSOLE}

{$R *.res}

uses
  Windows,
  System.SysUtils,
  CommDLL in 'CommDLL.pas',
  CommonDataTypes in 'CommonDataTypes.pas',
  CheckDLL in 'CheckDLL.pas',
  ExtAIAPI in 'ExtAIAPI.pas',
  ExtAIMaster in 'ExtAIMaster.pas',
  InterfaceDelphi in 'InterfaceDelphi.pas';

var
  K: Integer;
  DLLPath: String;
  ExtAIMaster: TExtAIMaster;
begin
  Writeln('Start test');

// gGameApp init:
  ExtAIMaster := TExtAIMaster.Create();

// gGame start (load phase):
  Writeln('');
  Writeln('Choose ExtAI');
  for K := 0 to ExtAIMaster.ListOfDLL.DLL.Count-1 do // Get list of all DLLs(ExtAI)
    DLLPath := ExtAIMaster.ListOfDLL.DLL[K];
  // Feedback from lobby -> return selected DLL / ExtAI in DLLPath (or name of ExtAI etc.)
  Writeln('  '+DLLPath);
  // Changed: Game does not care about DLL interface, it only requires initialization of new ExtAI and it does not care if this ExtAI is in the same DLL like previous

  Writeln('');
  Writeln('Create communication interface');
  ExtAIMaster.NewExtAI(DLLPath, 1);
  //todo: extAI := ExtAIMaster.NewExtAI(dllPath, 1); //@Krom: what do you want to return? TExtAIAPI?
  //@Martin: extAI should be something that goes into TKMAI implementation. I'm not sure yet, what TExtAIAPI class is and what it does
  //@Krom: TExtAIAPI is interface for callbacks from ExtAI, all callbacks should be implemented within this class. Please check the picture in shared doc file. (chapter: DLL Communication (low-level stuff))

// gGame.UpdateState flow:
  Writeln('');
  Writeln('Loop');
  // Each tick the game does its work. ExtAI should integrate with that
  for K := 0 to 1 do
  begin
    //todo: issue event to extAI
    //todo: Trigers, Start event, etc.
    //@Krom: calling of function UpdateState is equal to all events, only parameters will be changed
    ExtAIMaster.UpdateState();
  end;

//gGame end:
  // Mission has ended, ExtAIs need to be freed
  Writeln('');
  Writeln('Release DLLs and ExtAI');
  ExtAIMaster.Release();

//gGameApp end:
  // App is terminated.
  Writeln('');
  Writeln('Terminate');
  ExtAIMaster.Free();

  Writeln('');
  Writeln('Test is finished. Press Enter');
  ReadLn;
end.


