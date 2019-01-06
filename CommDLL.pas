unit CommDLL;

interface
uses
  Windows, System.SysUtils, ExtAIAPI, InterfaceDelphi, CommonDataTypes;


type
  TInitDLL = procedure(); StdCall;
  TTerminDLL = procedure(); StdCall;
  TInitNewExtAI = procedure(aID: ui8; aActions: IActions) StdCall;
  TNewExtAI = function(): IEvents; SafeCall; // Same like StdCall but allows exceptions

  TCallback1 = function(sig: ui8): b of object; StdCall;

TCommDLL = class
  private
    fLibHandle: THandle;
    fDLLPath: String;
    fExtAIAPICnt: ui8;
    fExtAIAPI: array[0..11] of TExtAIAPI;
    InitDLL: TInitDLL;
    TerminDLL: TTerminDLL;
    InitNewExtAI: TInitNewExtAI;
    NewExtAI: TNewExtAI;
  public
    property DLLPath: String read fDLLPath;
    //property ExtAICnt: ui8 read fExtAIAPICnt;
    //property ExtAI: TExtAI read fExtAI

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
  if assigned(TerminDLL) then
    TerminDLL();

  FreeLibrary(fLibHandle);
  for K := Low(fExtAIAPI) to High(fExtAIAPI) do
    fExtAIAPI[K] := nil; // Interface will be freed automatically
  inherited;
end;


function TCommDLL.LinkDLL(aDLLPath: String): boolean;
var
  Output: boolean;
  RegisterCallback1: procedure(x: TCallback1); StdCall;
begin
  Output := false;
  fDLLPath := aDLLPath;
  if fileexists(DLLPath) then
  begin
    writeln('TCommDLL: DLL file detected');
    fLibHandle := SafeLoadLibrary( DLLPath );
    if (fLibHandle <> 0) then
    begin
      writeln('TCDLL: last error (should be 0): ' + IntToStr( GetLastError() ));
      Output := true;

      InitDLL := GetProcAddress(fLibHandle, 'InitDLL');
      TerminDLL := GetProcAddress(fLibHandle, 'TerminDLL');
      NewExtAI := GetProcAddress(fLibHandle, 'NewExtAI');
      InitNewExtAI := GetProcAddress(fLibHandle, 'InitNewExtAI');

      //if  assigned(NewExtAI) then
      //  writeln('TCommDLL: NewExtAI');

      //if  assigned(InitNewExtAI) then
      //  writeln('TCommDLL: InitNewExtAI');

      if assigned(InitDLL) AND
         assigned(TerminDLL) AND
         assigned(NewExtAI) AND
         assigned(InitNewExtAI) then
      begin
        Output := True;
        InitDLL();
        writeln('TCommDLL: procedures of DLL assigned');
      end;

      RegisterCallback1 := GetProcAddress(fLibHandle, 'RegisterCallback1');
      if assigned(RegisterCallback1) then
        RegisterCallback1( Callback1 );
    end
    else
      writeln('TCDLL: library was NOT loaded, error: ' + IntToStr( GetLastError() ));
  end
  else
    writeln('TCommDLL: DLL file was NOT found');
  Result := Output;
end;


function TCommDLL.CreateNewExtAI(aExtAIID: ui8): b;
var
  Output: b;
begin
  Output := false;
  if (assigned(NewExtAI)) then
  begin
    fExtAIAPI[fExtAIAPICnt] := TExtAIAPI.Create(aExtAIID);
    try
      fExtAIAPI[fExtAIAPICnt].Events := NewExtAI();
      InitNewExtAI( aExtAIID, fExtAIAPI[fExtAIAPICnt] );
      Inc(fExtAIAPICnt);
    except
      on E: Exception do
      begin
        Writeln('Error ', E.ClassName, ': ', E.Message);
        Readln;
      end;
    end;

    Output := True;
  end;
  Result := Output;
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


function TCommDLL.Callback1(sig: ui8): b;
begin
  writeln('TCommDLL: callback1, value: ' + IntToStr(sig));
  Result := true;
end;


end.