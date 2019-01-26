program DLL_MainProgram;
// Example of communication between Delphi and C++ with using shared functions, callbacks and interface
{$APPTYPE CONSOLE}

{$R *.res}

uses
  Windows,
  System.SysUtils,
  CommDLL in 'CommDLL.pas',
  CommonDataTypes in 'CommonDataTypes.pas',
  ExtAIListDLL in 'ExtAIListDLL.pas',
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

  //@Martin: gGameApp needs to get a list of AIs to show in UI, so the ChooseAI code belongs to here, not the gGame.Start
  Writeln('');
  Writeln('List ExtAIs');
  for K := 0 to ExtAIMaster.AvailableDLLs.Count-1 do // Get list of all DLLs(ExtAI)
    DLLPath := ExtAIMaster.AvailableDLLs[K];
  // Feedback from lobby -> return selected DLL / ExtAI in DLLPath (or name of ExtAI etc.)
  Writeln('  '+DLLPath);
  // Changed: Game does not care about DLL interface, it only requires initialization of new ExtAI and it does not care
  // if this ExtAI is in the same DLL like previous

// gGame start (load phase):
  Writeln('');
  Writeln('Create communication interface');
  ExtAIMaster.NewExtAI(DLLPath, 1);
  //todo: extAI := ExtAIMaster.NewExtAI(dllPath, 1); //@Krom: what do you want to return? TExtAIAPI?
  //@Martin: extAI should be something that goes into TKMAI implementation. I'm not sure yet, what TExtAIAPI class is and what it does
  //@Krom: TExtAIAPI is interface for callbacks from ExtAI, all callbacks should be implemented within this class.
  // Please check the picture in shared doc file. (chapter: DLL Communication (low-level stuff))
  //@Martin: ExtAIMaster.NewExtAI(DLLPath, 1) should return some kind of an object or a handle by which Hand.AI will address it
  // throughout the game and terminate it in the end (or in the middle, if e.g. Hand has lost according to games rules).
  // It is needed, e.g. because this is a games decision in which order Hands get updated (e.g. 0..to N-1 or e.g. reverse).
  // It's also required by the

// gGame.UpdateState flow:
  Writeln('');
  // Each tick the game does its work. ExtAI should integrate with that
  for K := 1 to 2 do
  begin
    Writeln('Loop: ' + IntToStr(K));
    //todo: issue event to extAI
    //todo: Trigers, Start event, etc.
    //@Krom: calling of function UpdateState is equal to all events, only parameters will be changed
    //@Martin: Do you have a special reason you want ExtAIMaster to do the UpdateState ?
    //instead of the each Hands calling it's AI.UpdateState which calls it's ExtAI.UpdateState on the inside?
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


