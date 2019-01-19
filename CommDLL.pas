unit CommDLL;
interface
uses
  Classes, Windows, System.SysUtils, ExtAIAPI, InterfaceDelphi, CommonDataTypes;

type
  TInitDLL = procedure(); StdCall;
  TTerminDLL = procedure(); StdCall;
  TInitNewExtAI = procedure(aID: ui8; aActions: IActions; aStates: IStates) StdCall;
  TNewExtAI = function(): IEvents; SafeCall; // Same like StdCall but allows exceptions

  TCallback1 = function(sig: ui8): b of object; StdCall;

  // Communication with 1 physical DLL with using exported methods.
  // Main targets: initialization of DLL, creation of ExtAIs and termination of DLL and ExtAIs
  TCommDLL = class
  private
    fLibHandle: THandle;
    fDLLPath: String;
    fExtAIAPI: TList;
    fOnInitDLL: TInitDLL;
    fOnTerminDLL: TTerminDLL;
    fOnInitNewExtAI: TInitNewExtAI;
    fOnNewExtAI: TNewExtAI;
  public
    property DLLPath: String read fDLLPath;
    //property ExtAIAPI: TList read fExtAIAPI;

    constructor Create();
    destructor Destroy(); override;

    function LinkDLL(aDLLPath: String): b;
    function CreateNewExtAI(aExtAIID: ui8): b;
    procedure UpdateState();

    function Callback1(sig: ui8): b; StdCall;
  end;

implementation


{ TCommDLL }
constructor TCommDLL.Create();
begin
  inherited;
  fExtAIAPI := TList.Create();
end;

destructor TCommDLL.Destroy();
var
  K: ui8;
begin
  Writeln('  TCommDLL: Termin DLL request');
  if Assigned(fOnTerminDLL) then
    fOnTerminDLL(); // = remove reference from ExtAIAPI

  Writeln('  TCommDLL: Destroy class');
  for K := 0 to fExtAIAPI.Count-1 do
    fExtAIAPI[K] := nil;
  FreeAndNil(fExtAIAPI);

  FreeLibrary(fLibHandle);
  inherited;
end;


function TCommDLL.LinkDLL(aDLLPath: String): b;
var
  RegisterCallback1: procedure(x: TCallback1); StdCall;
begin
  Result := False;
  fDLLPath := aDLLPath;
  if fileexists(DLLPath) then
  begin
    Writeln('  TCommDLL: DLL file detected');
    fLibHandle := SafeLoadLibrary( DLLPath );
    if (fLibHandle <> 0) then
    begin
      Writeln('  TCDLL: last error (should be 0): ' + IntToStr( GetLastError() ));
      Result := True;

      fOnInitDLL := GetProcAddress(fLibHandle, 'InitDLL');
      fOnTerminDLL := GetProcAddress(fLibHandle, 'TerminDLL');
      fOnNewExtAI := GetProcAddress(fLibHandle, 'NewExtAI');
      fOnInitNewExtAI := GetProcAddress(fLibHandle, 'InitNewExtAI');

      if Assigned(fOnInitDLL)
      AND Assigned(fOnTerminDLL)
      AND Assigned(fOnNewExtAI)
      AND Assigned(fOnInitNewExtAI) then
      begin
        Result := True;
        fOnInitDLL();
        Writeln('  TCommDLL: procedures of DLL assigned');
      end;

      //RegisterCallback1 := GetProcAddress(fLibHandle, 'RegisterCallback1');
      //if Assigned(RegisterCallback1) then
      //  RegisterCallback1( Callback1 );
    end
    else
      Writeln('  TCDLL: library was NOT loaded, error: ' + IntToStr( GetLastError() ));
  end
  else
    Writeln('  TCommDLL: DLL file was NOT found');
end;


function TCommDLL.CreateNewExtAI(aExtAIID: ui8): b;
var
  ExtAIAPI: TExtAIAPI;
begin
  Result := False;
  if (Assigned(fOnNewExtAI)) then
  begin
    Writeln('  TCommDLL: New ExtAI');
    ExtAIAPI := TExtAIAPI.Create(aExtAIID);
    try
      ExtAIAPI.Events := fOnNewExtAI(); // = add reference to ExtAIAPI
      fOnInitNewExtAI( aExtAIID, ExtAIAPI, ExtAIAPI );
    except
      on E: Exception do
      begin
        Writeln('  TCommDLL: Error ', E.ClassName, ': ', E.Message);
        Readln;
      end;
    end;
    fExtAIAPI.Add(ExtAIAPI);
    Result := True;
  end;
end;


procedure TCommDLL.UpdateState();
var
  K: ui8;
begin
  for K := 0 to fExtAIAPI.Count-1 do
    if (fExtAIAPI[K] <> nil) then
    begin
      TExtAIAPI( fExtAIAPI[K] ).UpdateState();
      //...
    end;
end;


function TCommDLL.Callback1(sig: ui8): b; StdCall;
begin
  Writeln('  TCommDLL: callback1, value: ' + IntToStr(sig));
  Result := True;
end;


end.