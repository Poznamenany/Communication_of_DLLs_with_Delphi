unit KP_MainCommClass;

interface
uses
  System.SysUtils,
  KP_CommonDataTypes;


type

// Communication interface for actions and states
// DLL calls methods in main program
ICommunicationInterface = interface(IInterface)
  // Actions
  procedure Act1(aID: ui32; aCmd: ui32); stdcall;
  // States
  function State1(aID: ui32; aProperty: ui32): ui32; stdcall;
end;

TKPMainCommClass = class(TInterfacedObject, ICommunicationInterface)
  private
  public
    constructor Create();
    destructor Destroy(); override;
    // Actions
    procedure Act1(aID: ui32; aCmd: ui32); stdcall;
    // States
    function State1(aID: ui32; aProperty: ui32): ui32; stdcall;
  end;

implementation


{ TKPMainCommClass }

constructor TKPMainCommClass.Create();
begin
  inherited;
  writeln('MainCommClass: constructor');
end;

destructor TKPMainCommClass.Destroy();
begin
  writeln('MainCommClass: Destructor');
  inherited;
end;

procedure TKPMainCommClass.Act1(aID: ui32; aCmd: ui32);
begin
  writeln('MainCommClass: Act1; aID = ' + IntToStr(aID) + '; aCmd = ' + IntToStr(aCmd));
end;

function TKPMainCommClass.State1(aID: ui32; aProperty: ui32): ui32;
begin
  writeln('MainCommClass: State1; aID = ' + IntToStr(aID) + '; aProperty = ' + IntToStr(aProperty));
  Result := aID;
end;

end.