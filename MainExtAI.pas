unit MainExtAI;

interface
uses
  Windows, System.SysUtils, CommDLL, CommonDataTypes;

type
TExtAIMaster = class
  private
    fCommDLLCnt: ui8;
    fCommDLL: array[0..11] of TCommDLL;
  public
    constructor Create();
    destructor Destroy(); override;

    function NewDLL(aDLLPath: String): b;
    function NewExtAI(aDLLPath: String; aExtAIID: ui8): b;
    procedure UpdateState();
end;


implementation

{ TMainExtAI }
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
    fCommDLL[K].Free;
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
  Output: b;
begin
  Output := False;
  for K := Low(fCommDLL) to High(fCommDLL) do
    if (fCommDLL[K] <> nil) AND ( ansicomparestr(fCommDLL[K].DLLPath,aDLLPath) = 0 ) then
      Output := fCommDLL[K].CreateNewExtAI( aExtAIID );
  Result := Output;
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