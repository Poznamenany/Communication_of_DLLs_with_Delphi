unit ExtAIAPI;

interface
uses
  Windows, System.SysUtils, InterfaceDelphi, CommonDataTypes;


type

TExtAIAPI = class(TInterfacedObject, IActions)
  private
    fID: ui8;
    // Actions
    procedure Action1(aID: ui32; aCmd: ui32); StdCall;
  public
    Events: IEvents;

    property ID: ui8 read fID;

    constructor Create(aID: ui8); reintroduce;
    destructor Destroy(); override;
    procedure UpdateState();
  end;

implementation


{ TExtAIAPI }
constructor TExtAIAPI.Create(aID: ui8);
begin
  inherited Create();
  writeln('TExtAIAPI: Constructor');
  Events := nil;
  fID := aID;
end;

destructor TExtAIAPI.Destroy();
begin
  writeln('TExtAIAPI: Destructor');
  Events := nil;
  inherited;
end;

procedure TExtAIAPI.Action1(aID: ui32; aCmd: ui32);
begin
  writeln('TExtAIAPI: Action1; class fID: ' + IntToStr(fID) + '; parameter1 aID: ' + IntToStr(aID) + '; parameter2 aCmd: ' + IntToStr(aCmd));
end;


procedure TExtAIAPI.UpdateState();
begin
  // Test all callbacks and functions in ExtAI:
  Events.Event1(121); // Call action 1 from ExtAI in DLL
end;

end.