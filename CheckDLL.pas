unit CheckDLL;
interface
uses
  IOUtils, Classes, System.SysUtils, CommonDataTypes;

const
  //@Krom: maybe set condition that folder with ExtAI must have the same name like DLL file?
  // In the game there will be 1 folder for ExtAI and in this folder will be subfolders with individual DLLs
  // For now keep multiple folders so I can use multiple projects in different IDE
  //@Martin: Sounds good. Let's assume there is:
  // game folder
  // - ext_ai
  //   - dll_delphi
  //     - dll_delphi.dll
  //   - dll_c
  //     - dll_c.dll
  // It's TExtAIMaster task to scan the ext_ai folder and detect all DLLs

  strArr_DLL_PATHS: array [0..1] of String = (
    '..\..\DLL_Delphi\Win32\Debug\',
    '..\..\DLL_C\'
  );

type
  // Check presence of all valid DLLs (in future it can also check CRC, save info etc.)
  TCheckDLL = class
  private
    fDLLs: TStringList;
    fLibHandle: THandle;
    procedure GetDLLs();
  public
    constructor Create();
    destructor Destroy(); override;

    property DLL: TStringList read fDLLs;
  end;

implementation


{ TCommDLL }
constructor TCheckDLL.Create();
begin
  fDLLs := TStringList.Create();
  GetDLLs();
  inherited;
end;

destructor TCheckDLL.Destroy();
begin
  fDLLs.Free();
  inherited;
end;


procedure TCheckDLL.GetDLLs();
var
  K: Integer;
  Path: String;
begin
  fDLLs.Clear();
  for K := Low(strArr_DLL_PATHS) to High(strArr_DLL_PATHS) do
    for Path in TDirectory.GetFiles( strArr_DLL_PATHS[K] ) do
      if (Length(Path) > 4) AND (Path.SubString(Length(Path)-4, 4) = '.dll') then // Make sure that the last 4 characters are .dll (and not name.ddl.exe)
      begin
        Writeln('  TCheckDLL: New DLL - ' + Path);
        // Check CRC
        // Try to initialize connection
        // Get version, configuration?, description
        fDLLs.Add(Path);
      end;
end;

end.