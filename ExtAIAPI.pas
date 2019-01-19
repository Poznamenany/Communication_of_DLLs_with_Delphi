unit ExtAIAPI;
interface
uses
  Windows, System.SysUtils, InterfaceDelphi, CommonDataTypes;


type
  // API for 1 specific ExtAI class in DLL. Allows ExtAI to communicate during the game.
  TExtAIAPI = class(TInterfacedObject, IActions, IStates)
  private
    fID: ui8;
    fMap: ui32Arr;
    // IInterface
    //procedure AfterConstruction; override;
    //procedure BeforeDestruction; override;
    // IActions
    procedure Action1(aID: ui32; aCmd: ui32); StdCall;
    function State1(aID: ui32): ui8; StdCall;
    function State2(var aFirstElem: pui32; var aLength: si32): b; StdCall;
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
  writeln('    TExtAIAPI: Constructor');
  fID := aID;
  Events := nil;
end;

destructor TExtAIAPI.Destroy();
begin
  writeln('    TExtAIAPI: Destructor');
  Events := nil;
  inherited;
end;


//procedure TExtAIAPI.AfterConstruction;
//begin
//  inherited;
//  writeln('    TExtAIAPI: AfterConstruction: ID ' + IntToStr(fID));
//end;

//procedure TExtAIAPI.BeforeDestruction;
//begin
//  writeln('    TExtAIAPI: BeforeDestruction: ID ' + IntToStr(fID));
//  inherited;
//end;


procedure TExtAIAPI.Action1(aID: ui32; aCmd: ui32);
begin
  writeln('    TExtAIAPI: Action1; class fID: ' + IntToStr(fID) + '; parameter1 aID: ' + IntToStr(aID) + '; parameter2 aCmd: ' + IntToStr(aCmd));
end;


function TExtAIAPI.State1(aID: ui32): ui8;
begin
  writeln('    TExtAIAPI: State1; class fID: ' + IntToStr(fID) + '; parameter1 aID: ' + IntToStr(aID));
  Result := aID*2;
end;

function TExtAIAPI.State2(var aFirstElem: pui32; var aLength: si32): b; StdCall;
var
  K: Integer;
begin
  write('    TExtAIAPI: State2; class fID: ' + IntToStr(fID) + '; create array:');
  // Declare / refresh local array fMap
  SetLength(fMap,5);
  for K := Low(fMap) to High(fMap) do
  begin
    fMap[K] := K;
    write(' ' + IntToStr(fMap[K]));
  end;
  writeln('');
  aFirstElem := @fMap[0];
  aLength := Length(fMap);
  Result := True;
end;


procedure TExtAIAPI.UpdateState();
begin
  // Test all callbacks and functions in ExtAI:
  Events.Event1(123); // Call action 1 from ExtAI in DLL
end;

end.