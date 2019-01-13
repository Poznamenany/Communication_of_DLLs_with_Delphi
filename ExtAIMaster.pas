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
var
  K: Integer;
begin
  for K := 0 to fCommDLL.Count-1 do
    TCommDLL(fCommDLL[K]).Free();
  fCommDLL.Free();
  inherited;
end;


function TExtAIMaster.NewExtAI(aDLLPath: String; aExtAIID: ui8): b;
var
  K: Integer;
  DLL: TCommDLL;
begin
  Result := False;
  DLL := nil;

  // Check if we already have this DLL loaded
  //@Martin: Could be split into "IndexOf(aDLLPath: String): Integer" func
  for K := 0 to (fCommDLL.Count-1) do
    if (fCommDLL[K] <> nil) AND (  AnsiCompareStr( TCommDLL(fCommDLL[K]).DLLPath, aDLLPath ) = 0  ) then
    begin
      DLL := TCommDLL(fCommDLL[K]);
      break;
    end;

  // if not, create the DLL
  if (DLL = nil) then
  begin
    DLL := TCommDLL.Create();
    DLL.LinkDLL(aDLLPath);
    fCommDLL.Add( DLL );
  end;

  // Create ExtAI in DLL
  //@Martin: What is the "aExtAIID" used for?
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