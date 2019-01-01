unit CommunicationDLL;

interface
uses
  Windows, System.SysUtils,
  CommonDataTypes;


type
  // Definition of types of callback functions (states and actions are called from ExtAI)
  // It is possible to create 1 class for this code and send pointer to the class,
  // but for sake of compatibility I prefer this approach
  // cdecl = Change calling convention to C
  // Actions
  TAction1 = function(sig: ui8): b; cdecl;
  // Events
  TInitDLL = procedure(); cdecl;
  TTerminDLL = procedure();  cdecl;
  TEvent1 = procedure(aID: ui32; aAct: ui16);  cdecl;
  TLoop = procedure(aTick: si64); cdecl;
  // States
  TState1 = function(sig: ui32): si16; cdecl;

TCommunicationDLL = class
  private
    fLibHandle: THandle;
    // Initialization
    procedure InitActions();
    procedure InitEvents();
    procedure InitStates();
  public
    // Events
    InitDLL: TInitDLL;
    TerminDLL: TTerminDLL;
    Event1: TEvent1;
    Loop: TLoop;

    constructor Create();
    destructor Destroy(); override;

    // Service methods
    procedure FindDLL(const aDLLPath: String);
  end;

implementation


{ Actions }
function Action1(sig: ui8): b; cdecl;
begin
  writeln('TCDLL: callback in Action 1, value: ' + IntToStr(sig));
  Result := true;
end;

{ States }
function State1(sig: ui32): si16; cdecl;
begin
  writeln('TCDLL: callback in State 1, value: ' + IntToStr(sig));
  Result := 1;
end;


{ TCommunicationDLL }

constructor TCommunicationDLL.Create();
begin
  inherited;
  writeln('TCDLL: Constructor');
  fLibHandle := 0;
end;

destructor TCommunicationDLL.Destroy();
begin
  writeln('TCDLL: Destructor');
  if (fLibHandle <> 0) then
    FreeLibrary(fLibHandle);
  inherited;
end;


// Find DLL, init methods
procedure TCommunicationDLL.FindDLL(const aDLLPath: String);
begin
  if fileexists(aDLLPath) then
  begin
    writeln('TCDLL: DLL file detected');
    fLibHandle := SafeLoadLibrary( aDLLPath );
    if (fLibHandle <> 0) then
    begin
      writeln('TCDLL: library was loaded, last error (just info): ' + IntToStr( GetLastError() ));
      InitActions();
      InitEvents();
      InitStates();

      //if assigned(InitDLL) then writeln('TCDLL: link established);
    end
    else
      writeln('TCDLL: library was NOT loaded, error: ' + IntToStr( GetLastError() ));
  end
  else
    writeln('TCDLL: DLL file was NOT found');

end;


procedure TCommunicationDLL.InitActions();
var
  CallbackAction1: procedure(x: TAction1); cdecl;
begin
  CallbackAction1 := GetProcAddress(fLibHandle, 'CallbackAction1');
  if assigned(CallbackAction1) then
    CallbackAction1( @Action1 );
end;

procedure TCommunicationDLL.InitEvents();
begin
  InitDLL := GetProcAddress(fLibHandle, 'InitDLL');
  TerminDLL := GetProcAddress(fLibHandle, 'TerminDLL');
  Event1 := GetProcAddress(fLibHandle, 'Event1');
  Loop := GetProcAddress(fLibHandle, 'Loop');
end;

procedure TCommunicationDLL.InitStates();
var
  CallbackState1: procedure(x: TState1); cdecl;
begin
  CallbackState1 := GetProcAddress(fLibHandle, 'CallbackState1');
  if assigned(CallbackState1) then
    CallbackState1( @State1 );
end;


end.