unit InterfaceDelphi;
interface
uses
  Windows, System.SysUtils, CommonDataTypes;

type

  // Interface for Actions
  IActions = interface(IInterface)
    ['{66FDB631-E3DC-4B8E-A745-4337C487ED69}']
    procedure Action1(aID: ui32; aCmd: ui32); StdCall;
  end;

  // Interface for Events
  IEvents = interface(IInterface)
    ['{8E77167C-CC59-4917-BE0B-BCF311B3CEEE}']
    procedure Event1(aID: ui32); StdCall;
  end;

  // Interface for States
  IStates = interface(IInterface)
    ['{2A228001-8FE0-4A01-8B5D-5D7D8394B1DD}']
    function State1(aID: ui32): ui8; StdCall;
    function State2(var aFirstElem: pui32; var aLength: si32): b; StdCall;
  end;


implementation



end.