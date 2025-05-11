unit OverbyteIcsMhsReg;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, OverbyteIcsEmulVT;
  
procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('MHS', [TEmulVT]);
end;  

end.