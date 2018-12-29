unit ExtAI;

interface
uses
  SysUtils,
  Classes,
  KP_CommonDataTypes;

type
  // Test class
  TKPTestExtAI = class
  private
    fOwner: ui8;
    fGameData: ui8;

    procedure ChangeOwner(const aNewOwner: ui8);
    function GetOwner(): ui8;
  public
    constructor Create();
    destructor Destroy; override;

    // Properties
    property Owner: ui8 read GetOwner write ChangeOwner;

    // Public methods
    procedure GetGameData(aData: ui8);
    procedure ExtAILoop();
  end;

implementation


{ TKPTestExtAI }
constructor TKPTestExtAI.Create();
begin
  inherited;
  writeln('ExtAI Constructor');
  fOwner := 0;
  fGameData := 0;
end;

destructor TKPTestExtAI.Destroy();
begin
  writeln('ExtAI Destructor');
  inherited;
end;

procedure TKPTestExtAI.ChangeOwner(const aNewOwner: ui8);
begin
  fOwner := aNewOwner;
end;


function TKPTestExtAI.GetOwner(): ui8;
begin
  result := fOwner;
end;

procedure TKPTestExtAI.GetGameData(aData: ui8);
begin
  fGameData := aData;
end;

procedure TKPTestExtAI.ExtAILoop();
begin
  writeln('ExtAI loop, take game data: ' + IntToStr(fGameData));
end;

end.
