{***************************************************************************
                          zahlen.pas  -  description
                             -------------------
    begin             : 19.06.2022                                        
    last modify       : 05.04.2023							    
    copyright         : (C) 2022 - 2023 MHS-Elektronik GmbH & Co. KG, Germany
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
unit zahlen;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

{$IFnDEF FPC}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CODE OFF}
{$ENDIF}

uses
{$IFnDEF FPC}
  WinProcs, WinTypes,
{$ELSE}
  LResources, LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls;

const
  MulTab: array[1..4] of Word = ($1000,$0100,$0010,$0001);

type
  TZahlenFormat = (HexFormat, DezFormat, BinFormat, ChrFormat);

  TZahlenEdit = class(TCustomEdit)
  protected
    FFormat: TZahlenFormat;
    FIDShow: boolean;
    FByteMode: boolean;
    AltValue: Integer;
    pmOnChange: TNotifyEvent;

    function StrtoHex(Str_: String):word;
    function HextoStr(In_: Word;  ByteMode_: boolean): String;
    function BintoStr(In_: Word;  ByteMode_: boolean): String;
    function StrtoBin(In_: String): word;
    function CleanLeer(In_: String):String;

    function AsZahl : Word;
    procedure SetZahl(In_ : Word);
    procedure SetFormat(value: TZahlenFormat);
    procedure SetMode(value: boolean);
    procedure SetIDShow(value: boolean);
    function GetFormat(In_: String;
      Default_: TZahlenFormat): TZahlenFormat;
  public
    procedure NeuAnzeigen;
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    constructor Create(AOwner : TComponent); override;
  published
    property Number : Word read AsZahl write SetZahl;
    property ZahlenFormat: TZahlenFormat read FFormat write SetFormat;
    property IdShowing: boolean read FIdShow write SetIDShow;
    property ByteMode: boolean read FByteMode write SetMode;

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
  {$I zahlen.lrs}
{$ENDIF} 
  RegisterComponents('MHS', [TZahlenEdit]);
end;


constructor TZahlenEdit.Create(AOwner : TComponent);

begin;
inherited Create(AOwner);
Number:=0;
AltValue:=0;
end;


procedure TZahlenEdit.DoExit;

begin;
NeuAnzeigen;
inherited DoExit;
end;


procedure TZahlenEdit.KeyDown(var Key: Word; Shift: TShiftState);

begin;
if Key=VK_Return then
  begin;
  NeuAnzeigen;
  end;
inherited KeyDown(Key,Shift);
end;


function TZahlenEdit.StrtoHex(Str_: String):word;

var i: Integer;
    Puf: Byte;

begin;
while Length(Str_)<4 do Str_:='0'+Str_;
Result:=0;
for i:=4 downto 1 do
  begin;
  if (ord(Str_[i])>47) AND (ord(Str_[i])<58) then
    Puf:=ord(Str_[i])-48
  else if (ord(Str_[i])>64) AND (ord(Str_[i])<71) then
    Puf:=ord(Str_[i])-55
  else
    Exit;
  Result:=Result + (Puf * MulTab[i]);
  end;
end;


function TZahlenEdit.HextoStr(In_: word; ByteMode_: boolean): String;
var hlp_: Word;
    i : Integer;
    Str_: String;


begin;
SetLength(Str_,4);
Str_:='';
if ByteMode then
  begin;
  for i:=4 downto 3 do
    begin;
    if (In_>0) then
      hlp_:=(In_ div MulTab[i]) and $0F
    else
      hlp_:=In_;
    if (hlp_)>9 then
      Str_:=chr(hlp_+55)+Str_
    else
      Str_:=chr(hlp_+48)+Str_;
    end;
  end
else
  begin;
  for i:=4 downto 1 do
    begin;
    if (In_>0) then
      hlp_:=(In_ div MulTab[i]) and $0F
    else
      hlp_:=In_;
    if (hlp_)>9 then
      Str_:=chr(hlp_+55)+Str_
    else
      Str_:=chr(hlp_+48)+Str_;
    end;
   end;
result:=Str_;
end;


function TZahlenEdit.BintoStr(In_: Word; ByteMode_: boolean): String;
var Puffer_: String;

begin;
if ByteMode_ then
  begin;
  Puffer_:='00000000';
  if (In_ AND $0001) = $0001 then Puffer_[8]:='1';
  if (In_ AND $0002) = $0002 then Puffer_[7]:='1';
  if (In_ AND $0004) = $0004 then Puffer_[6]:='1';
  if (In_ AND $0008) = $0008 then Puffer_[5]:='1';
  if (In_ AND $0010) = $0010 then Puffer_[4]:='1';
  if (In_ AND $0020) = $0020 then Puffer_[3]:='1';
  if (In_ AND $0040) = $0040 then Puffer_[2]:='1';
  if (In_ AND $0080) = $0080 then Puffer_[1]:='1';
  end
else
  begin;
  Puffer_:='0000000000000000';
  if (In_ AND $0001) = $0001 then Puffer_[16]:='1';
  if (In_ AND $0002) = $0002 then Puffer_[15]:='1';
  if (In_ AND $0004) = $0004 then Puffer_[14]:='1';
  if (In_ AND $0008) = $0008 then Puffer_[13]:='1';
  if (In_ AND $0010) = $0010 then Puffer_[12]:='1';
  if (In_ AND $0020) = $0020 then Puffer_[11]:='1';
  if (In_ AND $0040) = $0040 then Puffer_[10]:='1';
  if (In_ AND $0080) = $0080 then Puffer_[9]:='1';
  if (In_ AND $0100) = $0100 then Puffer_[8]:='1';
  if (In_ AND $0200) = $0200 then Puffer_[7]:='1';
  if (In_ AND $0400) = $0400 then Puffer_[6]:='1';
  if (In_ AND $0800) = $0800 then Puffer_[5]:='1';
  if (In_ AND $1000) = $1000 then Puffer_[4]:='1';
  if (In_ AND $2000) = $2000 then Puffer_[3]:='1';
  if (In_ AND $4000) = $4000 then Puffer_[2]:='1';
  if (In_ AND $8000) = $8000 then Puffer_[1]:='1';
  end;
BintoStr:=Puffer_;
end;


function TZahlenEdit.StrtoBin(In_: String): word;
var Puffer_: word;

begin;
while Length(In_)<16 do In_:='0'+In_;
Puffer_:=0;
if In_[16]='1' then Puffer_:=Puffer_+$0001;
if In_[15]='1' then Puffer_:=Puffer_+$0002;
if In_[14]='1' then Puffer_:=Puffer_+$0004;
if In_[13]='1' then Puffer_:=Puffer_+$0008;
if In_[12]='1' then Puffer_:=Puffer_+$0010;
if In_[11]='1' then Puffer_:=Puffer_+$0020;
if In_[10]='1' then Puffer_:=Puffer_+$0040;
if In_[9]='1' then Puffer_:=Puffer_+$0080;
if In_[8]='1' then Puffer_:=Puffer_+$0100;
if In_[7]='1' then Puffer_:=Puffer_+$0200;
if In_[6]='1' then Puffer_:=Puffer_+$0400;
if In_[5]='1' then Puffer_:=Puffer_+$0800;
if In_[4]='1' then Puffer_:=Puffer_+$1000;
if In_[3]='1' then Puffer_:=Puffer_+$2000;
if In_[2]='1' then Puffer_:=Puffer_+$4000;
if In_[1]='1' then Puffer_:=Puffer_+$8000;
StrtoBin:=Puffer_;
end;


function TZahlenEdit.CleanLeer(In_: String):String;

begin;
while Pos(' ',In_)>0 do
  begin;
  delete(In_,Pos(' ',In_),1);
  end;
CleanLeer:=In_;
end;


procedure TZahlenEdit.NeuAnzeigen;
var hlp: Word;
    Merker: boolean;

begin;
hlp:=AsZahl;
if AltValue<>hlp then Merker:=True else Merker:=False;
SetZahl(hlp);
if (Assigned(pmOnChange)) AND Merker then pmOnChange(self);
end;


procedure TZahlenEdit.SetFormat(value: TZahlenFormat);
var hlp_: Word;

begin;
hlp_:=AsZahl;
FFormat:=value;
SetZahl(hlp_);
end;


procedure TZahlenEdit.SetMode(value: boolean);

begin;
FByteMode:=value;
NeuAnzeigen;
end;


procedure TZahlenEdit.SetIDShow(value: boolean);

begin;
FIDShow:=value;
NeuAnzeigen;
end;


function TZahlenEdit.GetFormat(In_: String;
  Default_: TZahlenFormat): TZahlenFormat;
var str: String;
    AFormat: TZahlenFormat;

begin;
str:=CleanLeer(In_);
AFormat:=Default_;
if length(str)>0 then
  begin;
  if str[1]='.' then AFormat:=DezFormat else
    if ((str[1]='b') or (str[1]='B')) and (str[2]='´') and (length(str)>2)
      then AFormat:=BinFormat else
      if (length(str)>2) and (str[1]='0') and ((str[2]='x') or (str[2]='X'))
        then AFormat:=HexFormat else
          if (length(str)>1) and (str[1]='´')
            then AFormat:=ChrFormat;

  end;
GetFormat:=AFormat;
end;


function TZahlenEdit.AsZahl : Word;
var str: String;
    AFormat: TZahlenFormat;

begin
Result:=0;
  try
  AFormat:=GetFormat(Text, FFormat);
  str:=CleanLeer(Text);
  str:=AnsiUpperCase(str);
  case AFormat of
    HexFormat : begin;
                if length(str)>1 then
                  begin;
                  if (str[1]='0') and ((str[2]='x') or (str[2]='X'))
                    then delete(str,1,2);
                  end;
                Result:=StrtoHex(str);
                end;
    DezFormat : begin;
                if length(str)>0 then
                  begin;
                  if str[1]='.' then delete(str,1,1);
                  end;
                if FByteMode then
                  Result:=StrToInt(str) AND $FF
                else
                  Result:=StrToInt(str);
                end;
    BinFormat : begin;
                if length(str)>0 then
                  begin;
                  if (str[1]='b') or (str[1]='B') and (str[2]='´') then
                    delete(str,1,2);
                  end;
                if (str[length(str)]='´') then delete(str,length(str),1);
                Result:=StrtoBin(str);
                end;
    ChrFormat : begin;
                if length(str)>0 then
                  begin;
                  if (length(str)>1) and (str[1]='´') then delete(str,1,1);
                  end;
                Result:=ord(str[1]);
                end;
    end;
  except
    on EConvertError do
      Result:=0;
  end;
end;


procedure TZahlenEdit.SetZahl(In_ : Word);
var str_: String;
    AFormat: TZahlenFormat;
    IDShowHlp: boolean;

begin
AltValue:=In_;
AFormat:=GetFormat(Text,FFormat);
if FIDShow then
  IDShowHlp:=True
else
  begin;
  IDShowHlp:=False;
  if AFormat<>FFormat then IDShowHlp:=True;
  end;
case AFormat of
  HexFormat : begin;
              str_:=HextoStr(In_, FByteMode);
              if IDShowHlp then
                str_:='0x'+str_;
              end;
  DezFormat : begin;
              if FByteMode then
              str_:=IntToStr(In_ AND $FF)
                else
              str_:=IntToStr(In_);
              if IDShowHlp then
                str_:='.'+str_;
              end;
  BinFormat : begin;
              str_:=BintoStr(In_, FByteMode);
              if IDShowHlp then
                str_:='B´'+str_+'´';
              end;
  ChrFormat : begin;
              str_:=chr(In_ AND $FF);
              if IDShowHlp then
                str_:='´'+str_+'´';
              end;
  end;
  Text:=str_;
end;

end.
