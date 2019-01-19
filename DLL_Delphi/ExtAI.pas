unit ExtAI;

interface
uses
  Windows, System.SysUtils, InterfaceDelphi, CommonDataTypes;

type
TExtAI = class(TInterfacedObject, IEvents)
  private
    // IInterface
    //procedure AfterConstruction; override;
    //procedure BeforeDestruction; override;
    // IEvents
    procedure Event1(aID: ui32); StdCall;
  public
    Actions: IActions;
    States: IStates;
    ID: ui8;

    constructor Create();
    destructor Destroy(); override;
  end;

implementation


{ TExtAI }
constructor TExtAI.Create();
begin
  inherited Create();
  writeln('    TExtAI: Constructor');
  ID := 0;
  Actions := nil;
end;

destructor TExtAI.Destroy();
begin
  writeln('    TExtAI: Destructor');
  Actions := nil;
  inherited;
end;


//procedure TExtAI.AfterConstruction;
//begin
//  inherited;
//  writeln('    TExtAI: AfterConstruction: ID ' + IntToStr(ID));
//end;

//procedure TExtAI.BeforeDestruction;
//begin
//  writeln('    TExtAI: BeforeDestruction: ID ' + IntToStr(ID));
//  inherited;
//end;


// Test all callbacks and events
procedure TExtAI.Event1(aID: ui32);
var
  testVar, K: ui8;
  pMap: pui32;
  mapLen: si32;
  Map: ui32Arr;
begin
  writeln('    TExtAI: Event1, class fID: ' + IntToStr(ID) + '; parameter aID: ' + IntToStr(aID)); // Show event 1
  Actions.Action1(11,22); // Check callback
  testVar := States.State1(22);
  writeln('    TExtAI: Event1, class fID: ' + IntToStr(ID) + '; testVar: ' + IntToStr(testVar)); // Show test var from State 1
  // Get array (pointer to first element) from Main program and copy memory so we can work with it
  pMap := nil;
  if States.State2(pMap, mapLen) then
  begin
    SetLength(Map,mapLen);
    Move(pMap^, Map[0], SizeOf(Map[0]) * Length(Map));
    write('    TExtAI: Event1, class fID: ' + IntToStr(ID) + '; log array:'); // Show values of array
    for K := Low(Map) to High(Map) do
      write(' ' + IntToStr(Map[K]));
    writeln('');
  end;
end;


end.
