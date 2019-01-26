unit ExtAIMaster;
interface
uses
  Classes, Windows, System.SysUtils, ExtAIListDLL, CommDLL, CommonDataTypes;

type
  // Manager class. It controls all initialized DLLs and eventually mediating the interface between game and ExtAI.
  TExtAIMaster = class
  private
    fCommDLL: TList;
    fCheckDLL: TExtAIListDLL;

    function IndexOf(aDLLPath: String): Integer;
  public
    property AvailableDLLs: TExtAIListDLL read fCheckDLL;
    //Note for the future, the game doesn't care about DLLs. It needs a list of ExtAIs it can use
    //@Krom: 1 DLL = 1 ExtAI
    //@Martin: Why is that? It should be "1 DLL = 1 ExtAI class" and "1 DLL = any number of ExtAI instances"
    //TODO: Create DLL config structure (with name of ExtAI) and send it to the game instead of DLLs path

    constructor Create();
    destructor Destroy(); override;
    procedure Release();

    function NewExtAI(aDLLPath: String; aExtAIID: ui8): b;
    procedure UpdateState();
end;


implementation

{ TExtAIMaster }
constructor TExtAIMaster.Create();
begin
  inherited;
  fCommDLL := TList.Create();
  fCheckDLL := TExtAIListDLL.Create();
end;

destructor TExtAIMaster.Destroy();
begin
  Release(); // Make sure that DLLs are released
  fCommDLL.Free();
  fCheckDLL.Free();
  inherited;
end;


procedure TExtAIMaster.Release();
var
  K: Integer;
begin
  for K := 0 to fCommDLL.Count-1 do
    TCommDLL(fCommDLL[K]).Free();
  fCommDLL.Clear();
end;


function TExtAIMaster.NewExtAI(aDLLPath: String; aExtAIID: ui8): b;
var
  Idx: Integer;
  DLL: TCommDLL;
begin
  Result := False;

  // Make sure that DLLs exist
  fCheckDLL.RefreshDLLs();
  if NOT fCheckDLL.ContainDLL(aDLLPath) then
    Exit;

  // Check if we already have this DLL loaded
  Idx := IndexOf(aDLLPath);
  if (Idx <> -1) then
    DLL := TCommDLL(fCommDLL[Idx])
  else
  begin // if not, create the DLL
    DLL := TCommDLL.Create();
    DLL.LinkDLL(aDLLPath);
    fCommDLL.Add( DLL );
  end;
  // Create ExtAI in DLL
  //@Martin: What is the "aExtAIID" used for?
  //@Krom: For me it is debug variable which divide multiple instances of ExtAI
  //       in the future it should be ID of map loc or AI identifier
  Result := DLL.CreateNewExtAI( aExtAIID );
end;


function TExtAIMaster.IndexOf(aDLLPath: String): Integer;
var
  K: Integer;
begin
  Result := -1;
  for K := 0 to fCommDLL.Count-1 do
    if (fCommDLL[K] <> nil) AND (  AnsiCompareStr( TCommDLL(fCommDLL[K]).DLLPath, aDLLPath ) = 0  ) then
    begin
      Result := K;
      break;
    end;
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