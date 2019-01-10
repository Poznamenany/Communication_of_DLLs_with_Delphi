unit CommDLL;
interface
uses
  Windows, System.SysUtils, ExtAIAPI, InterfaceDelphi, CommonDataTypes;

const
  MAX_HANDS = 12;

type
  TInitDLL = procedure(); StdCall;
  TTerminDLL = procedure(); StdCall;
  TInitNewExtAI = procedure(aID: ui8; aActions: IActions) StdCall;
  TNewExtAI = function(): IEvents; SafeCall; // Same like StdCall but allows exceptions

  TCallback1 = function(sig: ui8): b of object; StdCall;

  // Communication with 1 physical DLL with using exported methods.
  // Main targets: initialization of DLL, creation of ExtAIs and termination of DLL and ExtAIs
  TCommDLL = class
  private
    fLibHandle: THandle;
    fDLLPath: String;
    fExtAIAPICnt: ui8; //@Martin: Use Delphi datatypes in Delphi please. Integer here
    fExtAIAPI: array [0..MAX_HANDS-1] of TExtAIAPI; //@Martin: Better change to dynamic array or TList<> to avoid MAX_HANDS const (it is not needed here)
    fOnInitDLL: TInitDLL;
    fOnTerminDLL: TTerminDLL;
    fOnInitNewExtAI: TInitNewExtAI;
    fOnNewExtAI: TNewExtAI;
  public
    property DLLPath: String read fDLLPath;
    //property ExtAICnt: ui8 read fExtAIAPICnt;
    //property ExtAI: TExtAI read fExtAI

    constructor Create();
    destructor Destroy(); override;

    function LinkDLL(aDLLPath: String): b;
    function CreateNewExtAI(aExtAIID: ui8): b; //@Martin: This should return something (through TKMExtAIMaster maybe?). Something that TKMExtAI will be able to use directly
    procedure UpdateState(); //@Martin: This is not needed?

    function Callback1(sig: ui8): b; StdCall;
  end;

implementation


{ TCommDLL }
constructor TCommDLL.Create();
var
  K: ui8;
begin
  inherited;
  fExtAIAPICnt := 0;
  for K := Low(fExtAIAPI) to High(fExtAIAPI) do
    fExtAIAPI[K] := nil;
end;

destructor TCommDLL.Destroy();
var
  K: ui8;
begin
  if Assigned(fOnTerminDLL) then
    fOnTerminDLL();

  FreeLibrary(fLibHandle);
  for K := Low(fExtAIAPI) to High(fExtAIAPI) do
    fExtAIAPI[K] := nil; // Interface will be freed automatically
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
    Writeln('TCommDLL: DLL file detected');
    fLibHandle := SafeLoadLibrary(DLLPath);
    if (fLibHandle <> 0) then
    begin
      Writeln('TCDLL: last error (should be 0): ' + IntToStr(GetLastError()));
      Result := True;

      fOnInitDLL := GetProcAddress(fLibHandle, 'InitDLL');
      fOnTerminDLL := GetProcAddress(fLibHandle, 'TerminDLL');
      fOnNewExtAI := GetProcAddress(fLibHandle, 'NewExtAI');
      fOnInitNewExtAI := GetProcAddress(fLibHandle, 'InitNewExtAI');

      //if  Assigned(NewExtAI) then
      //  Writeln('TCommDLL: NewExtAI');

      //if  Assigned(InitNewExtAI) then
      //  Writeln('TCommDLL: InitNewExtAI');

      if Assigned(fOnInitDLL)
      AND Assigned(fOnTerminDLL)
      AND Assigned(fOnNewExtAI)
      AND Assigned(fOnInitNewExtAI) then
      begin
        Result := True;
        fOnInitDLL();
        Writeln('TCommDLL: procedures of DLL assigned');
      end;

      RegisterCallback1 := GetProcAddress(fLibHandle, 'RegisterCallback1');
      if Assigned(RegisterCallback1) then
        RegisterCallback1(Callback1);
    end
    else
      Writeln('TCDLL: library was NOT loaded, error: ' + IntToStr(GetLastError()));
  end
  else
    Writeln('TCommDLL: DLL file was NOT found');
      Writeln('TCDLL: last error (should be 0): ' + IntToStr( GetLastError() ));
end;


function TCommDLL.CreateNewExtAI(aExtAIID: ui8): b;
begin
  Result := False;
  if not Assigned(fOnNewExtAI) then Exit;
  
    fExtAIAPI[fExtAIAPICnt] := TExtAIAPI.Create(aExtAIID);
    try
      fExtAIAPI[fExtAIAPICnt].Events := fOnNewExtAI();
      fOnInitNewExtAI( aExtAIID, fExtAIAPI[fExtAIAPICnt] );
      Inc(fExtAIAPICnt);
    except
      on E: Exception do
      begin
        Writeln('Error ', E.ClassName, ': ', E.Message);
        Readln;
      end;
    end;
    Result := True;
end;

procedure TCommDLL.UpdateState();
var
  K: ui8;
begin
  for K := Low(fExtAIAPI) to High(fExtAIAPI) do
    if (fExtAIAPI[K] <> nil) then
    begin
      fExtAIAPI[K].UpdateState();
    end;
end;


function TCommDLL.Callback1(sig: ui8): b; StdCall;
begin
  Writeln('TCommDLL: callback1, value: ' + IntToStr(sig));
  Result := True;
end;


end.
