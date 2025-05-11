{***************************************************************************
                        zahlen32.pas  -  description
                             -------------------
    begin             : 19.06.2022                                        
    last modify       : 26.01.2025                                        							    
    copyright         : (C) 2022 - 2025 MHS-Elektronik GmbH & Co. KG, Germany
                               http://www.mhs-elektronik.de    
    author            : Klaus Demlehner, klaus@mhs-elektronik.de
 ***************************************************************************}

{***************************************************************************
 *                                                                         *
 *   This program is free software, you can redistribute it and/or modify  *
 *   it under the terms of the MIT License <LICENSE.TXT or                 *
 *   http://opensource.org/licenses/MIT>                                   *              
 *                                                                         *
 ***************************************************************************}
unit zahlen32;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

{$WARN SYMBOL_DEPRECATED OFF}

uses
{$IFnDEF FPC}
  Messages, WinProcs, WinTypes,
{$ELSE}
  LResources, LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, StdCtrls, MHSTypes;

const
  MulTab: array[1..8] of UINT =  ($10000000,$01000000,$00100000,$00010000,
                                   $00001000,$00000100,$00000010,$00000001);
  BinTab: array[0..31] of UINT = ($00000001,$00000002,$00000004,$00000008,
                                   $00000010,$00000020,$00000040,$00000080,
                                   $00000100,$00000200,$00000400,$00000800,
                                   $00001000,$00002000,$00004000,$00008000,
                                   $00010000,$00020000,$00040000,$00080000,
                                   $00100000,$00200000,$00400000,$00800000,
                                   $01000000,$02000000,$04000000,$08000000,
                                   $10000000,$20000000,$40000000,$8000000);

type
  TZahlen32Edit = class(TCustomEdit)
  protected
    FFormat: TFormat;
    FIDShow: boolean;
    FBinMode: TBin32Mode;
    FHexMode: TBin32Mode;
    AltValue: UINT;
    FAutoFormat: boolean;
   { FAutoTab: boolean; }
    pmOnChange: TNotifyEvent;

    function RealtoUINT(In_: Real):UINT;
    function UINTtoReal(In_: UINT): Real;
    function StrtoUINT(In_: String): UINT;
    function UINTtoStr(In_: UINT): String;
    function StrtoHex(Str_: String): UINT;
    function HextoStr(In_Dez: UINT): String;
    function BintoStr(In_: UINT): String;
    function StrtoBin(In_: String): UINT;
    function CleanLeer(InString: String):String;

    function AsZahl : UINT;
    procedure SetZahl(In_ : UINT);
    procedure SetFormat(value: TFormat);
    procedure SetIDShow(value: boolean);
    procedure SetBinMode(value: TBin32Mode);
    procedure SetHexMode(value: TBin32Mode);
    procedure SetAutoFormat(value: boolean);
   { procedure SetAutoTab(value: boolean); }
  public
    AFormat: TFormat;
    procedure NeuAnzeigen;
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    constructor Create(AOwner : TComponent); override;
  published
    property Number : UINT read AsZahl write SetZahl;
    property ZahlenFormat: TFormat read FFormat write SetFormat;
    property IdShowing: boolean read FIdShow write SetIDShow;
    property BinMode: TBin32Mode read FBinMode write SetBinMode;
    property HexMode: TBin32Mode read FHexMode write SetHexMode;
    property AutoFormat: boolean read FAutoFormat write SetAutoFormat;
   { property AutoTab: boolean read FAutoTab write SetAutoTab;}
    property OnChange: TNotifyEvent read pmOnChange write pmOnChange;

    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Color;
{$IFnDEF FPC}
    property Ctl3D;
{$ENDIF}
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property MaxLength;
   { property OEMConvert; }
    property ParentColor;
{$IFnDEF FPC}
    property ParentCtl3D;
{$ENDIF}
    property ParentFont;
    property ParentShowHint;
   { property PasswordChar; }
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
   { property Text; }
    property Visible;

  {  property OnChange;}
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
{$IFDEF FPC}
  {$I zahlen32.lrs}
{$ENDIF}  
  RegisterComponents('MHS', [TZahlen32Edit]);
end;


constructor TZahlen32Edit.Create(AOwner : TComponent);

begin;
inherited Create(AOwner);
Text:='0';
AltValue:=0;
end;


procedure TZahlen32Edit.DoExit;

begin;
NeuAnzeigen;
inherited DoExit;
end;


procedure TZahlen32Edit.KeyDown(var Key: Word; Shift: TShiftState);

begin;
if Key=VK_Return then
  begin;
  NeuAnzeigen;
  end;
inherited KeyDown(Key,Shift);
end;


function TZahlen32Edit.StrtoUINT(In_: String):UINT;
var i: Integer;
    hlp: Real;

begin;
val(In_,hlp,i);
if i<>0 then
  begin;
  result:=0;
  Exit;
  end;
  result:=RealtoUINT(hlp);
end;


function TZahlen32Edit.RealtoUINT(In_: Real): UINT;
var Out_Hlp: UINT;
    Real_Hlp: Real;

begin;
Real_Hlp:=1294967295;
Real_Hlp:=Real_Hlp+2000000000;
Real_Hlp:=Real_Hlp+1000000000;
if In_>Real_Hlp then
  begin;
  result:=$FFFFFFFF;
  Exit;
  end;
if In_>2000000000 then
  begin;
  Out_Hlp:=2000000000;
  In_:=In_-2000000000;
  end else Out_Hlp:=0;
if In_>1000000000 then
  begin;
  Out_Hlp:=Out_Hlp+1000000000;
  In_:=In_-1000000000;
  end;
result:=Out_Hlp+trunc(In_);
end;


function TZahlen32Edit.UINTtoReal(In_: UINT): Real;
var In_Hlp: Real;

begin;
if (In_ AND $80000000) = $80000000 then
  begin;
  In_Hlp:=In_ AND $7FFFFFFF;
  In_Hlp:=In_Hlp+1147483648;
  In_Hlp:=In_Hlp+1000000000;
  end
else In_Hlp:=In_;
result:=In_Hlp;
end;


function TZahlen32Edit.UINTtoStr(In_: UINT): String;
var hlp: String;
    In_Hlp: Real;

begin;
In_Hlp:=UINTtoReal(In_);
hlp:=format('%.0f',[In_Hlp]);
result:=hlp;
end;


function TZahlen32Edit.StrtoHex(Str_: String):UINT;

var i: Integer;
    Puf: Byte;

begin;
while Length(Str_)<8 do Str_:='0'+Str_;
Result:=0;
for i:=8 downto 1 do
  begin;
  if (ord(Str_[i])>47) AND (ord(Str_[i])<58) then
    Puf:=ord(Str_[i])-48
  else if (ord(Str_[i])>64) AND (ord(Str_[i])<71) then
    Puf:=ord(Str_[i])-55
  else
    Exit;
  result:=result + (Puf * MulTab[i]);
  end;
end;


function TZahlen32Edit.HextoStr(In_Dez: UINT): String;
var hlp_: Word;
    i : Integer;
    Mode: Integer;
    Str_: String;

begin;
Mode:=0;
case FHexMode of
  Z32DWord    :  Mode:=2;
  Z32Word     : Mode:=1;
  Z32AutoMode : begin;
                if (In_Dez and $FFFF0000) > 0 then Mode:=2
                else if (In_Dez and $FFFFFF00) > 0 then Mode:=1;
                end;
  end;
Str_:='';
//SetLength(Str_,8);<*>
case Mode of
  0 : begin;
      for i:=8 downto 7 do
        begin;
        if (In_Dez>0) then
          hlp_:=(In_Dez DIV MulTab[i]) and $0F
        else hlp_:=0;
        if (hlp_)>9 then Str_:=chr(hlp_+55)+Str_
          else Str_:=chr(hlp_+48)+Str_;
       end;
     end;
 1 : begin;
     for i:=8 downto 5 do
       begin;
       if (In_Dez>0) then
       hlp_:=(In_Dez DIV MulTab[i]) and $0F
         else hlp_:=0;
       if (hlp_)>9 then Str_:=chr(hlp_+55)+Str_
         else Str_:=chr(hlp_+48)+Str_;
       end;
     end;
 2 : begin;
     for i:=8 downto 1 do
       begin;
       if (In_Dez>$0) then
       hlp_:=(In_Dez DIV MulTab[i]) and $0F
         else hlp_:=0;
       if (hlp_)>9 then Str_:=chr(hlp_+55)+Str_
         else Str_:=chr(hlp_+48)+Str_;
       end;
     end;
   end;
result:=Str_;
end;


function TZahlen32Edit.BintoStr(In_: UINT): String;
var Puffer_: String;
    i: Integer;
    hlp: Integer;

begin;
hlp:=7;
Puffer_ := '';
case FBinMode of
  Z32DWord    : hlp:=31;
  Z32Word     : hlp:=15;
  Z32AutoMode : begin;
                if (In_ and $FFFF0000) > 0 then hlp:=31
                else if (In_ and $FFFFFF00) > 0 then hlp:=15
                end;
  end;
for i:=0 to hlp do
  begin;
  if (In_ AND BinTab[i])=BinTab[i] then Puffer_:='1'+Puffer_
    else Puffer_:='0'+Puffer_;
  end;
BintoStr:=Puffer_;
end;


function TZahlen32Edit.StrtoBin(In_: String): UINT;
var Puffer_: UINT;

begin;
while Length(In_)<32 do In_:='0'+In_;
Puffer_:=0;
if In_[32]='1' then Puffer_:=Puffer_+$00000001;
if In_[31]='1' then Puffer_:=Puffer_+$00000002;
if In_[30]='1' then Puffer_:=Puffer_+$00000004;
if In_[29]='1' then Puffer_:=Puffer_+$00000008;
if In_[28]='1' then Puffer_:=Puffer_+$00000010;
if In_[27]='1' then Puffer_:=Puffer_+$00000020;
if In_[26]='1' then Puffer_:=Puffer_+$00000040;
if In_[25]='1' then Puffer_:=Puffer_+$00000080;
if In_[24]='1' then Puffer_:=Puffer_+$00000100;
if In_[23]='1' then Puffer_:=Puffer_+$00000200;
if In_[22]='1' then Puffer_:=Puffer_+$00000400;
if In_[21]='1' then Puffer_:=Puffer_+$00000800;
if In_[20]='1' then Puffer_:=Puffer_+$00001000;
if In_[19]='1' then Puffer_:=Puffer_+$00002000;
if In_[18]='1' then Puffer_:=Puffer_+$00004000;
if In_[17]='1' then Puffer_:=Puffer_+$00008000;
if In_[16]='1' then Puffer_:=Puffer_+$00010000;
if In_[15]='1' then Puffer_:=Puffer_+$00020000;
if In_[14]='1' then Puffer_:=Puffer_+$00040000;
if In_[13]='1' then Puffer_:=Puffer_+$00080000;
if In_[12]='1' then Puffer_:=Puffer_+$00100000;
if In_[11]='1' then Puffer_:=Puffer_+$00200000;
if In_[10]='1' then Puffer_:=Puffer_+$00400000;
if In_[9]='1'  then Puffer_:=Puffer_+$00800000;
if In_[8]='1'  then Puffer_:=Puffer_+$01000000;
if In_[7]='1'  then Puffer_:=Puffer_+$02000000;
if In_[6]='1'  then Puffer_:=Puffer_+$04000000;
if In_[5]='1'  then Puffer_:=Puffer_+$08000000;
if In_[4]='1'  then Puffer_:=Puffer_+$10000000;
if In_[3]='1'  then Puffer_:=Puffer_+$20000000;
if In_[2]='1'  then Puffer_:=Puffer_+$40000000;
if In_[1]='1'  then Puffer_:=Puffer_+$80000000;
StrtoBin:=Puffer_;
end;


function TZahlen32Edit.CleanLeer(InString: String):String;

begin;
while Pos(' ',InString)>0 do
  begin;
  delete(InString,Pos(' ',InString),1);
  end;
CleanLeer:=InString;
end;


procedure TZahlen32Edit.NeuAnzeigen;
var hlp: UINT;
    Merker: boolean;

begin;
hlp:=AsZahl;
if AltValue<>hlp then Merker:=True else Merker:=False;
SetZahl(hlp);
if (Assigned(pmOnChange)) AND (Merker=True) then pmOnChange(self);
end;


{procedure TZahlen32Edit.SetAutoTab(value: boolean);

begin;
FAutoTab:=value;
end;}


procedure TZahlen32Edit.SetAutoFormat(value: boolean);

begin;
FAutoFormat:=value;
NeuAnzeigen;
end;


procedure TZahlen32Edit.SetFormat(value: TFormat);
var hlp_: UINT;

begin;
hlp_:=AsZahl;
FFormat:=value;
AFormat:=value;
SetZahl(hlp_);
end;


procedure TZahlen32Edit.SetIDShow(value: boolean);

begin;
FIDShow:=value;
NeuAnzeigen;
end;


procedure TZahlen32Edit.SetBinMode(value: TBin32Mode);

begin;
FBinMode:=value;
NeuAnzeigen;
end;


procedure TZahlen32Edit.SetHexMode(value: TBin32Mode);

begin;
FHexMode:=value;
NeuAnzeigen;
end;


function TZahlen32Edit.AsZahl : UINT;
var str: String;

begin
result:=0;
  try
  str:=CleanLeer(Text);
{  AFormat:=FFormat;}
  if length(str)>0 then
    begin;
    if str[1]='.' then AFormat:=DezFormat else
      if ((str[1]='b') or (str[1]='B')) and (str[2]='´') and (length(str)>2)
        then AFormat:=BinFormat else
        if (length(str)>2) and (str[1]='0') and ((str[2]='x') or (str[2]='X'))
          then AFormat:=HexFormat else
            if (length(str)>1) and (str[1]='´')
              then AFormat:=ChrFormat;
    end
  else
    Exit;
  if AFormat<>ChrFormat then
    str:=AnsiUpperCase(str);
  case AFormat of
    HexFormat : begin;
                if (str[1]='0') and (str[2]='X')
                  then delete(str,1,2);
                Result:=StrtoHex(str);
                end;
    DezFormat : begin;
                if str[1]='.' then delete(str,1,1);
                Result:=StrToUINT(str);
                end;
    BinFormat : begin;
                if (str[1]='B') and (str[2]='´') then
                  delete(str,1,2);
                if (str[length(str)]='´') then delete(str,length(str),1);
                Result:=StrtoBin(str);
                end;
    ChrFormat : begin;
                if (length(str)>1) and (str[1]='´') then delete(str,1,1);
                Result:=ord(str[1]);
                end;
    end;
  except
    on EConvertError do
      Result:=0;
  end;
end;


procedure TZahlen32Edit.SetZahl(In_ : UINT);
var str_: String;

begin
AltValue:=In_;
if FAutoFormat=True then AFormat:=FFormat;
str_:='';
case AFormat of
  HexFormat : begin;
              str_:=HextoStr(In_);
              if (FIDShow=True) or (AFormat<>FFormat)
                then str_:='0x'+str_;
              end;
  DezFormat : begin;
              str_:=UINTToStr(In_);
              if (FIDShow=True) or (AFormat<>FFormat)
                then str_:='.'+str_;
              end;
  BinFormat : begin;
              str_:=BintoStr(In_);
              if (FIDShow=True) or (AFormat<>FFormat)
                then str_:='B´'+str_+'´';
              end;
  ChrFormat : begin;
              str_:=chr(In_ AND $FF);
              if (FIDShow=True) or (AFormat<>FFormat)
                then str_:='´'+str_+'´';
              end;
  end;
Text:=str_;
end;

end.
