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
  ExtAIMaster: TExtAIMaster;
  CheckDLL: TCheckDLL;

  DLLPath: String;
  K: Integer; //@Krom: just small 'nice to have' hint: indexes I and J are prohibited because they are similar and confusing (Matlab, Python and maybe lib. in C use complex numbers)
  //@Martin: Sorry, in Delphi world (and in C/JS/others I've seen), I-J-K are universal loop iterators. We code in Delphi, hence ...
begin
  Writeln('Start test');

// gGameApp init:
  // DLL role: detect all valid DLLs with ExtAI
  // @Martin: This begin/end section should go into TExtAIMaster.Create
  begin
    Writeln('');
    Writeln('Find DLL files');
    CheckDLL := TCheckDLL.Create();

    for K := 0 to CheckDLL.DLL.Count-1 do
    begin
      DLLPath := CheckDLL.DLL[K];
      // Get DLLs config + name
      // Display it in lobby
    end;
  end;

// gGame start (load phase):
  Writeln('');
  Writeln('Create communication interface');
  ExtAIMaster := TExtAIMaster.Create(); //@Krom: maybe it is worth it to move this line to init phase
  //@Martin: Yes. It should be in init phase above
  // Feedback from lobby -> return selected DLL / ExtAI in DLLPath (or name of ExtAI etc.)
  // Changed: Game does not care about DLL interface, it only requires initialization of new ExtAI and it does not care if this ExtAI is in the same DLL like previous
  ExtAIMaster.NewExtAI(DLLPath, 1);
  //todo: extAI := ExtAIMaster.NewExtAI(dllPath, 1); //@Krom: what do you want to return? TExtAIAPI?

// gGame.UpdateState flow:
  Writeln('');
  Writeln('Loop');
  // Each tick the game does its work. ExtAI should integrate with that
  for K := 0 to 1 do
  begin
    //todo: issue event to extAI
    //todo: Trigers, Start event, etc. //@Krom: calling of function UpdateState is equal to all events, only parameters will be changed
    ExtAIMaster.UpdateState();
  end;

//gGame end:
  // Mission has ended, ExtAIs need to be freed
  //todo: extAI.Release

//gGameApp end:
  // App is terminated.
  Writeln('');
  Writeln('Terminate');
  ExtAIMaster.Free();
  CheckDLL.Free();

  Writeln('');
  Writeln('Test is finished. Press Enter');
  ReadLn;
end.

