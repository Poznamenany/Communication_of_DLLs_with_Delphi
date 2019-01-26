unit ExtAIListDLL;
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
  //@Martin: Let's rename it to match its role - to TExtDLLList, (same for unit name - ExtDLLList.pas)
  // (I know, LLL looks bad to read, but at least it reflects the meaning of the class. Suggest your alternative?)
  //@Krom: TExtAIListDLL ... ExtAI to secure connection with ExtAI and swap DLL behind list to improve readability
  //@Martin: What do you mean?
  TExtAIListDLL = class
  private
    fDLLs: TStringList;
    function GetDLL(aIndex: Integer): string;
    function GetCount: Integer;
  public
    property Count: Integer read GetCount;
    property DLL[aIndex: Integer]: string read GetDll; default;

    constructor Create();
    destructor Destroy(); override;

    procedure RefreshDLLs(aLogDLLs: Boolean = False);
    function ContainDLL(const aDLLPath: string): boolean;
  end;

implementation


{ TExtAIListDLL }
constructor TExtAIListDLL.Create();
begin
  fDLLs := TStringList.Create();
  RefreshDLLs(True); // Find available DLL (public method for possibility reload DLLs)
  inherited;
end;


destructor TExtAIListDLL.Destroy();
begin
  fDLLs.Free();
  inherited;
end;


function TExtAIListDLL.GetCount: Integer;
begin
  Result := fDLLs.Count;
end;


function TExtAIListDLL.GetDll(aIndex: Integer): string;
begin
  Result := fDLLs[aIndex];
end;


procedure TExtAIListDLL.RefreshDLLs(aLogDLLs: Boolean = False);
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
end;


function TExtAIListDLL.ContainDLL(const aDLLPath: string): boolean;
begin
  Result := fDLLs.IndexOf(aDLLPath) <> -1;
end;

end.