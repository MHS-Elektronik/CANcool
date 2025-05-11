{***************************************************************************
                      CanBitValueForm.pas  -  description
                             -------------------
    begin             : 03.12.2012
    last modified     : 27.12.2021     
    copyright         : (C) 2012 - 2021 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit CanBitValueForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CanRxPrototyp, StdCtrls, Buttons, Imglist, StrUtils, MainForm,
  IntegerTerm, ExtCtrls, Menus, Contnrs, Kr_Led, Util, TinyCanDrv;

type
  TBitConf = record
    Name: String[80];
    Color: TColor;
    BytePos: Byte;
    BitPos: Byte;
    end;

  PBitConf = ^TBitConf;

  TCanBitValueWin = class(TCanRxPrototypForm)
    BitIndikMenu: TPopupMenu;
    ConfigBtn: TMenuItem;
    AktivBtn: TMenuItem;
    N1: TMenuItem;
    DestroyBtn: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ConfigBtnClick(Sender: TObject);
    procedure AktivBtnClick(Sender: TObject);
    procedure DestroyBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private-Deklarationen }
    DataChange: Boolean;
    Data: array[0..63] of Byte;
    CanId: longword;
    MuxEnable: boolean;
    MuxDlc: Byte;
    MuxCanMask: array[0..7] of Byte;
    MuxCanData: array[0..7] of Byte;      
    BitConfListe: TList;
    LEDS: TObjectList;   
    procedure CreateLEDS;
  public
    { Public-Deklarationen }
    procedure BitConfListeClear(liste: TList);
    procedure BitConfListeAdd(liste: TList; Name: String;
      LedColor: TColor; BytePos, BitPos: Byte);
    procedure RxCanMessages(can_msg: PCanFdMsg; count: Integer); override;
    procedure RxCanUpdate; override;               
    procedure LoadConfig(ConfigList: TStrings); override;
    procedure SaveConfig(ConfigList: TStrings); override;
  end;

var
  CanBitValueWin: TCanBitValueWin;

implementation

uses CanBitValueSetupForm;

{$R *.dfm}


procedure TCanBitValueWin.FormCreate(Sender: TObject);
var
  i: integer;
  
begin
inherited;
BitConfListe := TList.Create;
LEDS := TObjectList.Create;
CanId := 0;
MuxEnable := False;
MuxDlc := 8;
for i := 0 to 7 do
  begin;
  MuxCanMask[i] := 0;
  MuxCanData[i] := 0;
  end;
end;


procedure TCanBitValueWin.FormDestroy(Sender: TObject);

begin
inherited;
LEDS.Free;
BitConfListeClear(BitConfListe);
BitConfListe.Free;
end;


procedure TCanBitValueWin.BitConfListeClear(liste: TList);
var i: Integer;

begin;
if liste.Count = 0 then
  exit;
for i := 0 to liste.Count-1 do
  dispose(liste.Items[i]);
liste.Clear;
end;


procedure TCanBitValueWin.BitConfListeAdd(liste: TList; Name: String;
    LedColor: TColor; BytePos, BitPos: Byte);
var item: PBitConf;
    
begin
new(item);
item.Name := Name;       // Bezeichnung
item.Color := LedColor;  // Farbe
item.BytePos := BytePos; // Byte
item.BitPos := BitPos;   // Bit
liste.Add(item);
end;


procedure TCanBitValueWin.FormResize(Sender: TObject);
var
  i, h, top: integer;

begin
inherited;
if LEDS.Count = 0 then
  exit;
h := KrLed(LEDS[0]).Height;
top := 0;  
for i := 0 to LEDS.Count-1 do
  begin
  KrLed(LEDS[i]).Top := top;
  top := top + h;
  end;
self.ClientWidth := KrLed(LEDS[0]).Width;   
self.ClientHeight := top;
end;  


procedure TCanBitValueWin.LoadConfig(ConfigList: TStrings);
const
  Delims = ['=', ';'];
var
  i, Pos, Idx: integer;
  Str, Item, Name: String;
  LedColor: TColor;
  BytePos, BitPos: Byte;

begin
EventsLock;
self.Caption := ReadListString(ConfigList, 'Name', self.Caption);
CanId := ReadListInteger(ConfigList, 'CanId', CanId);
MuxDlc := ReadListInteger(ConfigList, 'MuxDlc', 8);
MuxCanMask[0] := ReadListInteger(ConfigList, 'MuxCanMask0', 0);
MuxCanMask[1] := ReadListInteger(ConfigList, 'MuxCanMask1', 0);
MuxCanMask[2] := ReadListInteger(ConfigList, 'MuxCanMask2', 0);
MuxCanMask[3] := ReadListInteger(ConfigList, 'MuxCanMask3', 0);
MuxCanMask[4] := ReadListInteger(ConfigList, 'MuxCanMask4', 0);
MuxCanMask[5] := ReadListInteger(ConfigList, 'MuxCanMask5', 0);
MuxCanMask[6] := ReadListInteger(ConfigList, 'MuxCanMask6', 0);
MuxCanMask[7] := ReadListInteger(ConfigList, 'MuxCanMask7', 0);
MuxCanData[0] := ReadListInteger(ConfigList, 'MuxCanData0', 0);
MuxCanData[1] := ReadListInteger(ConfigList, 'MuxCanData1', 0);
MuxCanData[2] := ReadListInteger(ConfigList, 'MuxCanData2', 0);
MuxCanData[3] := ReadListInteger(ConfigList, 'MuxCanData3', 0);
MuxCanData[4] := ReadListInteger(ConfigList, 'MuxCanData4', 0);
MuxCanData[5] := ReadListInteger(ConfigList, 'MuxCanData5', 0);
MuxCanData[6] := ReadListInteger(ConfigList, 'MuxCanData6', 0);
MuxCanData[7] := ReadListInteger(ConfigList, 'MuxCanData7', 0);
if ReadListInteger(ConfigList, 'MuxEnable', 0) > 0 then 
  MuxEnable := True
else
  MuxEnable := False;
BitConfListeClear(BitConfListe);
for i := 0 to ConfigList.Count-1 do
  begin
  Str := ConfigList.Strings[i];
  if AnsiStartsText('LED', Str) then
    begin
    Pos := 1;
    Idx := 0;
    LedColor := clRed;
    BytePos := 0;
    BitPos := 0;
    while Pos <= Length(Str) do
      begin
      Item := ExtractSubstr(Str, Pos, Delims);
      case Idx of
        1: Name := Item;
        2: LedColor := TColor(StrToInt(Item));
        3: BytePos := StrToInt(Item);
        4: BitPos := StrToInt(Item);
        end;
      Inc(Idx);
      end;
    BitConfListeAdd(BitConfListe, Name, LedColor, BytePos, BitPos);
    end;
  end;
CreateLEDS;
WindowMenuItem.Caption :=  self.Caption;
EventsUnlock;
end;


procedure TCanBitValueWin.SaveConfig(ConfigList: TStrings);
var
  i, LedColor: integer;
  BytePos, BitPos : Byte;
  Name: String;

begin
ConfigList.Append(format('Name=%s', [self.Caption]));
ConfigList.Append(format('CanId=%u', [CanId]));
ConfigList.Append(format('MuxDlc=%u', [MuxDlc]));
ConfigList.Append(format('MuxCanMask0=%u', [MuxCanMask[0]]));
ConfigList.Append(format('MuxCanMask1=%u', [MuxCanMask[1]]));
ConfigList.Append(format('MuxCanMask2=%u', [MuxCanMask[2]]));
ConfigList.Append(format('MuxCanMask3=%u', [MuxCanMask[3]]));
ConfigList.Append(format('MuxCanMask4=%u', [MuxCanMask[4]]));
ConfigList.Append(format('MuxCanMask5=%u', [MuxCanMask[5]]));
ConfigList.Append(format('MuxCanMask6=%u', [MuxCanMask[6]]));
ConfigList.Append(format('MuxCanMask7=%u', [MuxCanMask[7]]));
ConfigList.Append(format('MuxCanData0=%u', [MuxCanData[0]]));
ConfigList.Append(format('MuxCanData1=%u', [MuxCanData[1]]));
ConfigList.Append(format('MuxCanData2=%u', [MuxCanData[2]]));
ConfigList.Append(format('MuxCanData3=%u', [MuxCanData[3]]));
ConfigList.Append(format('MuxCanData4=%u', [MuxCanData[4]]));
ConfigList.Append(format('MuxCanData5=%u', [MuxCanData[5]]));
ConfigList.Append(format('MuxCanData6=%u', [MuxCanData[6]]));
ConfigList.Append(format('MuxCanData7=%u', [MuxCanData[7]]));
if MuxEnable then
  ConfigList.Append('MuxEnable=1')
else
  ConfigList.Append('MuxEnable=0');
if BitConfListe.Count > 0 then
  begin;
  for i := 0 to BitConfListe.Count-1 do
    begin;
    Name := PBitConf(BitConfListe[i]).Name;
    LedColor := Integer(PBitConf(BitConfListe[i]).Color);
    BytePos := PBitConf(BitConfListe[i]).BytePos;
    BitPos := PBitConf(BitConfListe[i]).BitPos;
    ConfigList.Append(format('LED%u=%s;%d;%u;%u', [i, Name, LedColor, BytePos, BitPos]));
    end;
  end;  
end;


procedure TCanBitValueWin.CreateLEDS;
var i: Integer;
    led: KrLed;

begin;
LEDS.Clear;
if BitConfListe.Count = 0 then
  exit;
for i := 0 to BitConfListe.Count-1 do
  begin
  led := KrLed.Create(self);
  led.Parent := self;
  led.Left := 0;
  led.Height := 25;
  led.LedCircle := 16;
  led.Width := 200;
  led.LedOffColor := clSilver;
  led.Font.Style := [fsBold];
  led.LedOnColor := PBitConf(BitConfListe[i]).Color;
  led.Caption := PBitConf(BitConfListe[i]).Name;
  led.LedState := stOff;
  LEDS.Add(led);
  end;
FormResize(self);
end;


procedure TCanBitValueWin.RxCanMessages(can_msg: PCanFdMsg; count: Integer);
var
  dlc, i, idx: integer;
  hit_msg: PCanFdMsg;
  fault: boolean;

begin;
if count = 0 then
  exit;
hit_msg := nil;
for i := 1 to count do
  begin;
  fault := false;
  if can_msg^.ID <> CanId then
    fault := true;        
  if not fault and MuxEnable and (MuxDlc > 0) then
    begin;
    dlc := can_msg^.Length;
    if dlc <> MuxDlc then
      fault := True
    else
      begin;
      for idx := 0 to MuxDlc-1 do
        begin;
        if ((can_msg^.Data.Bytes[idx] xor MuxCanData[idx]) and MuxCanMask[idx]) <> 0 then
          begin;
          fault := true;
          break;
          end;
        end;
      end;      
    end;
  if not fault then
    begin;
    if (can_msg^.Flags and FlagCanFdRTR) = 0 then
      begin;
      can_msg^.Flags := can_msg^.Flags or FlagCanFdFilHit;
      hit_msg := can_msg;
      end;    
    end;
  inc(can_msg);
  end;
if hit_msg <> nil then
  begin;
  dlc := hit_msg^.Length;
  if (dlc >= 1) and (dlc <= 64) then
    begin
    for i := 0 to dlc-1 do
      begin
      if hit_msg^.Data.Bytes[i] <> Data[i] then
        DataChange := True;
      Data[i] := hit_msg^.Data.Bytes[i];
      end; 
    end; 
  end;   
end;


procedure TCanBitValueWin.RxCanUpdate; 
var
  i: integer;
  maske: Byte;
  tmp_data: array[0..63] of Byte;

begin;
if not DataChange then
  exit;
RxCanEnterCritical; 
DataChange := False;
Move(Data, tmp_data, 64);
RxCanLeaveCritical;  

if BitConfListe.Count = 0 then
  exit;
for i := 0 to BitConfListe.Count-1 do
  begin
  if i >= LEDS.Count then
    exit;
  maske := 1 shl PBitConf(BitConfListe[i]).BitPos;  
  if (tmp_data[PBitConf(BitConfListe[i]).BytePos] and maske) > 0 then
    KrLed(LEDS.Items[i]).LedState := stOn
  else
    KrLed(LEDS.Items[i]).LedState := stOff;
  end;
end;


procedure TCanBitValueWin.ConfigBtnClick(Sender: TObject);
var
  Form: TCanBitValueSetupWin;
  
begin
EventsLock;
Form := TCanBitValueSetupWin.Create(self);

Form.NameEdit.Text := self.Caption;
Form.CANIDEdit.Number := CanId;
Form.DLCEdit.Number := MuxDlc;
Form.Mask8Edit.Number := MuxCanMask[7];
Form.Mask7Edit.Number := MuxCanMask[6];
Form.Mask6Edit.Number := MuxCanMask[5];
Form.Mask5Edit.Number := MuxCanMask[4];
Form.Mask4Edit.Number := MuxCanMask[3];
Form.Mask3Edit.Number := MuxCanMask[2];
Form.Mask2Edit.Number := MuxCanMask[1];
Form.Mask1Edit.Number := MuxCanMask[0];
Form.Data8Edit.Number := MuxCanData[7];
Form.Data7Edit.Number := MuxCanData[6];
Form.Data6Edit.Number := MuxCanData[5];
Form.Data5Edit.Number := MuxCanData[4];
Form.Data4Edit.Number := MuxCanData[3]; 
Form.Data3Edit.Number := MuxCanData[2]; 
Form.Data2Edit.Number := MuxCanData[1];
Form.Data1Edit.Number := MuxCanData[0];
Form.MuxEnabledCheck.Checked := MuxEnable;
Form.SetBitConfListe(BitConfListe);
if Form.ShowModal = mrOK then
  begin
  self.Caption := Form.NameEdit.Text;
  CanId := Form.CANIDEdit.Number;
  MuxDlc := Form.DLCEdit.Number;            
  MuxCanMask[7] := Form.Mask8Edit.Number;   
  MuxCanMask[6] := Form.Mask7Edit.Number;   
  MuxCanMask[5] := Form.Mask6Edit.Number;   
  MuxCanMask[4] := Form.Mask5Edit.Number;   
  MuxCanMask[3] := Form.Mask4Edit.Number;   
  MuxCanMask[2] := Form.Mask3Edit.Number;   
  MuxCanMask[1] := Form.Mask2Edit.Number;   
  MuxCanMask[0] := Form.Mask1Edit.Number;   
  MuxCanData[7] := Form.Data8Edit.Number;   
  MuxCanData[6] := Form.Data7Edit.Number;   
  MuxCanData[5] := Form.Data6Edit.Number;   
  MuxCanData[4] := Form.Data5Edit.Number;   
  MuxCanData[3] := Form.Data4Edit.Number;   
  MuxCanData[2] := Form.Data3Edit.Number;   
  MuxCanData[1] := Form.Data2Edit.Number;   
  MuxCanData[0] := Form.Data1Edit.Number;   
  MuxEnable := Form.MuxEnabledCheck.Checked;
  Form.GetBitConfListe(BitConfListe);
  CreateLEDS;
  WindowMenuItem.Caption :=  self.Caption;
  end;
Form.Free;
EventsUnlock;
end;


procedure TCanBitValueWin.AktivBtnClick(Sender: TObject);

begin
WidgetAktiv := AktivBtn.Checked;
end;


procedure TCanBitValueWin.DestroyBtnClick(Sender: TObject);

begin
close;
end;

end.
