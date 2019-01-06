unit ExtAI;

interface
uses
  Windows, System.SysUtils, InterfaceDelphi, CommonDataTypes;


type

TExtAI = class(TInterfacedObject, IEvents)
  private
    procedure Event1(aID: ui32); StdCall;
  public
    Actions: IActions;
    ID: ui8;

    constructor Create();
    destructor Destroy(); override;
  end;

implementation


{ TExtAI }
constructor TExtAI.Create();
begin
  inherited Create();
  writeln('TExtAI: Constructor');
  ID := 0;
  Actions := nil;
end;

destructor TExtAI.Destroy();
begin
  Actions := nil;
  writeln('TExtAI: Destructor');
  inherited;
end;

// Test all callbacks and events
procedure TExtAI.Event1(aID: ui32);
begin
  writeln('TExtAI: Event1, class fID: ' + IntToStr(fID) + '; parameter aID: ' + IntToStr(aID)); // Show event 1
  Actions.Action1(11,22); // Check callback
end;


end.
