unit ExtAIMaster;
interface
uses
  Windows, System.SysUtils, CommDLL, CommonDataTypes;

type
  // Manager class. It controls all initialized DLLs and eventually mediating the interface between game and ExtAI.
  TExtAIMaster = class
  private
    fCommDLLCnt: ui8;
    fCommDLL: array[0..MAX_HANDS-1] of TCommDLL;
  public
    constructor Create();
    destructor Destroy(); override;

    function NewDLL(aDLLPath: String): b;
    function NewExtAI(aDLLPath: String; aExtAIID: ui8): b;
    procedure UpdateState();
end;


implementation

{ TExtAIMaster }
constructor TExtAIMaster.Create();
var
  K: ui8;
begin
  inherited;
  fCommDLLCnt := 0;
  for K := Low(fCommDLL) to High(fCommDLL) do
    fCommDLL[K] := nil;
end;

destructor TExtAIMaster.Destroy();
var
  K: ui8;
begin
  for K := Low(fCommDLL) to High(fCommDLL) do
    FreeAndNil(fCommDLL[K]);
  inherited;
end;

function TExtAIMaster.NewDLL(aDLLPath: String): b;
begin
  fCommDLL[fCommDLLCnt] := TCommDLL.Create();
  Inc(fCommDLLCnt);
  Result := fCommDLL[fCommDLLCnt-1].LinkDLL(aDLLPath);
end;


function TExtAIMaster.NewExtAI(aDLLPath: String; aExtAIID: ui8): b;
var
  K: ui8;
begin
  Result := False;
  for K := Low(fCommDLL) to High(fCommDLL) do
    if (fCommDLL[K] <> nil) AND ( ansicomparestr(fCommDLL[K].DLLPath,aDLLPath) = 0 ) then
      Result := fCommDLL[K].CreateNewExtAI( aExtAIID );
end;


procedure TExtAIMaster.UpdateState();
var
  K: ui8;
begin
  for K := Low(fCommDLL) to High(fCommDLL) do
    if (fCommDLL[K] <> nil) then
      fCommDLL[K].UpdateState();
end;


end.