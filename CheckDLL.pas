unit CheckDLL;
interface
uses
  IOUtils, Classes, System.SysUtils, CommonDataTypes;

const
  // Expected folder structure:
  // - ext_ai
  //   - dll_delphi
  //     - dll_delphi.dll
  //   - dll_c
  //     - dll_c.dll
  // For now keep multiple folders so I can use multiple projects in different IDE
  strArr_DLL_PATHS: array [0..1] of String = (
    '..\..\DLL_Delphi\Win32\Debug\',
    '..\..\DLL_C\'
  );

type
  // Check presence of all valid DLLs (in future it can also check CRC, save info etc.)
  TCheckDLL = class
  private
    fDLLs: TStringList;
  public
    property DLL: TStringList read fDLLs;

    constructor Create();
    destructor Destroy(); override;

    procedure RefreshDLLs(aLogDLLs: Boolean = False);
    function ContainDLL(const aDLLPath: String): boolean;
  end;

implementation


{ TCommDLL }
constructor TCheckDLL.Create();
begin
  fDLLs := TStringList.Create();
  RefreshDLLs(True); // Find available DLL (public method for possibility reload DLLs)
  inherited;
end;

destructor TCheckDLL.Destroy();
begin
  fDLLs.Free();
  inherited;
end;


procedure TCheckDLL.RefreshDLLs(aLogDLLs: Boolean = False);
var
  K: Integer;
  Path: String;
begin
  fDLLs.Clear();
  for K := Low(strArr_DLL_PATHS) to High(strArr_DLL_PATHS) do
    for Path in TDirectory.GetFiles( strArr_DLL_PATHS[K] ) do
      if (ExtractFileExt(Path) = '.dll') then
      begin
        if aLogDLLs then
          Writeln('  TCheckDLL: New DLL - ' + Path);
        // Check CRC
        // Try to initialize connection
        // Get version, configuration?, description
        fDLLs.Add(Path);
      end;
  fDLLs.Sort(); // So Find will work
end;


function TCheckDLL.ContainDLL(const aDLLPath: String): boolean;
var
  Idx: Integer;
begin
  Result := fDLLs.Find(aDLLPath,Idx);
end;

end.