unit ExtAIMaster;
interface
uses
  Classes, Windows, System.SysUtils, CommDLL, CommonDataTypes;

type
  // Manager class. It controls all initialized DLLs and eventually mediating the interface between game and ExtAI.
  TExtAIMaster = class
  private
    fCommDLL: TList;
  public
    constructor Create();
    destructor Destroy(); override;

    function NewExtAI(aDLLPath: String; aExtAIID: ui8): b;
    procedure UpdateState();
end;


implementation

{ TExtAIMaster }
constructor TExtAIMaster.Create();
begin
  inherited;
  fCommDLL := TList.Create();
end;

destructor TExtAIMaster.Destroy();
begin
  fCommDLL.Free();
  inherited;
end;


function TExtAIMaster.NewExtAI(aDLLPath: String; aExtAIID: ui8): b;
var
  DLLExist: boolean;
  K: Integer;
  DLL: TCommDLL;
begin
  Result := False;
  DLL := nil;
  for K := 0 to (fCommDLL.Count-1) do
    if (fCommDLL[K] <> nil) AND (  ansicomparestr( TCommDLL(fCommDLL[K]).DLLPath, aDLLPath ) = 0  ) then
    begin
      DLL := TCommDLL(fCommDLL[K]);
      break;
    end;
  if (DLL = nil) then
  begin
    DLL := TCommDLL.Create();
    DLL.LinkDLL(aDLLPath);

    fCommDLL.Add( DLL );
  end;
  Result := DLL.CreateNewExtAI( aExtAIID );
end;


procedure TExtAIMaster.UpdateState();
var
  K: Integer;
begin
  for K := 0 to fCommDLL.Count-1 do
    if (fCommDLL[K] <> nil) then
      TCommDLL(fCommDLL[K]).UpdateState();
end;


end.