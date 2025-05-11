{***************************************************************************
                      CanBitTxForm.pas  -  description
                             -------------------
    begin             : 25.10.2021
    last modified     : 31.12.2021
    copyright         : (C) 2021 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit CanBitTxForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CanRxPrototyp, StdCtrls, Buttons, Imglist, StrUtils, MainForm,
  CanCoolDefs, IntegerTerm, ExtCtrls, Menus, Contnrs, Util, TinyCanDrv;

type
  TTxBitConf = record
    Name: String[80];
    Color: TColor;
    BytePos: Byte;
    BitPos: Byte;
    end;

  PTxBitConf = ^TTxBitConf;

  TCanBitTxWin = class(TCanRxPrototypForm)
    BitIndikMenu: TPopupMenu;
    ConfigBtn: TMenuItem;
    N1: TMenuItem;
    DestroyBtn: TMenuItem;
    ButtonPanel: TPanel;
    TxBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ConfigBtnClick(Sender: TObject);
    procedure DestroyBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TxBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    CanId: longword;
    AutoTxEnable: boolean;
    ShowTxBtnEnable: boolean;
    BitConfListe: TList;
    ChkBits: TObjectList;
    procedure CreateChkBits;
    procedure ProcessDataChange(only_update: boolean; force_tx: boolean);
    procedure BitChkBtnClick(Sender: TObject);
  public
    { Public-Deklarationen }
    procedure BitConfListeClear(liste: TList);
    procedure BitConfListeAdd(liste: TList; Name: String;
      WidgetColor: TColor; BytePos, BitPos: Byte);
    procedure RxCanMessages(can_msg: PCanFdMsg; count: Integer); override;
    procedure RxCanUpdate; override;
    function ExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer; override;               
    procedure LoadConfig(ConfigList: TStrings); override;
    procedure SaveConfig(ConfigList: TStrings); override;
  end;

var
  CanBitTxWin: TCanBitTxWin;

implementation

uses CanBitTxSetupForm, CanTx, CanTxForm;

{$R *.dfm}


procedure TCanBitTxWin.FormCreate(Sender: TObject);

begin
inherited;
BitConfListe := TList.Create;
ChkBits := TObjectList.Create;
AutoTxEnable := True;
ShowTxBtnEnable := False;
CanId := 0;
end;


procedure TCanBitTxWin.FormDestroy(Sender: TObject);

begin
ChkBits.Free;
BitConfListeClear(BitConfListe);
BitConfListe.Free;
inherited;
end;


procedure TCanBitTxWin.BitConfListeClear(liste: TList);
var i: Integer;

begin;
if liste.Count = 0 then
  exit;
for i := 0 to liste.Count-1 do
  dispose(liste.Items[i]);
liste.Clear;
end;


procedure TCanBitTxWin.BitConfListeAdd(liste: TList; Name: String;
    WidgetColor: TColor; BytePos, BitPos: Byte);
var item: PTxBitConf;
    
begin
new(item);
item.Name := Name;       // Bezeichnung
item.Color := WidgetColor;  // Farbe
item.BytePos := BytePos; // Byte
item.BitPos := BitPos;   // Bit
liste.Add(item);
end;


procedure TCanBitTxWin.FormResize(Sender: TObject);
var
  i, w, width, h, top: integer;

begin
inherited;
if ChkBits.Count = 0 then
  exit;
h := TCheckBox(ChkBits[0]).Height;
top := 0;
width := 70;
for i := 0 to ChkBits.Count-1 do
  begin
  TCheckBox(ChkBits[i]).Top := top;
  w := TCheckBox(ChkBits[i]).Width;
  if w > width then
    width := w;
  top := top + h;
  end;
if ShowTxBtnEnable then
  begin;
  ButtonPanel.Visible := True;
  top := top + ButtonPanel.Height;
  end
else
  ButtonPanel.Visible := False;
self.ClientWidth := width;
self.ClientHeight := top;
end;


function TCanBitTxWin.ExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer;

begin;
result := 0;
case cmd of
  SYS_CMD_PRJ_LOAD_FINISH : begin;
                            ProcessDataChange(TRUE, FALSE);
                            end;
  end;
end;


procedure TCanBitTxWin.LoadConfig(ConfigList: TStrings);
const
  Delims = ['=', ';'];
var
  i, Pos, Idx: integer;
  Str, Item, Name: String;
  WidgetColor: TColor;
  BytePos, BitPos: Byte;

begin
EventsLock;
self.Caption := ReadListString(ConfigList, 'Name', self.Caption);
CanId := ReadListInteger(ConfigList, 'CanId', CanId);
{CanDlc := ReadListInteger(ConfigList, 'CanDlc', 8); <*>
Intervall := ReadListInteger(ConfigList, 'Intervall', 0);}
if ReadListInteger(ConfigList, 'AutoTxEnable', 0) > 0 then
  AutoTxEnable := True
else
  AutoTxEnable := False;
if ReadListInteger(ConfigList, 'ShowTxBtnEnable', 0) > 0 then
  ShowTxBtnEnable := True
else
  ShowTxBtnEnable := False;
BitConfListeClear(BitConfListe);
for i := 0 to ConfigList.Count-1 do
  begin
  Str := ConfigList.Strings[i];
  if AnsiStartsText('CanBit', Str) then
    begin
    Pos := 1;
    Idx := 0;
    WidgetColor := clRed;
    BytePos := 0;
    BitPos := 0;
    while Pos <= Length(Str) do
      begin
      Item := ExtractSubstr(Str, Pos, Delims);
      case Idx of
        1: Name := Item;
        2: WidgetColor := TColor(StrToInt(Item));
        3: BytePos := StrToInt(Item);
        4: BitPos := StrToInt(Item);
        end;
      Inc(Idx);
      end;
    BitConfListeAdd(BitConfListe, Name, WidgetColor, BytePos, BitPos);
    end;
  end;
CreateChkBits;
WindowMenuItem.Caption := self.Caption;
EventsUnlock;
end;


procedure TCanBitTxWin.SaveConfig(ConfigList: TStrings);
var
  i, WidgetColor: integer;
  BytePos, BitPos : Byte;
  Name: String;

begin
ConfigList.Append(format('Name=%s', [self.Caption]));
ConfigList.Append(format('CanId=%u', [CanId]));
{ConfigList.Append(format('CanDlc=%u', [CanDlc])); <*>
ConfigList.Append(format('Intervall=%u', [Intervall]));}
if AutoTxEnable then
  ConfigList.Append('AutoTxEnable=1')
else
  ConfigList.Append('AutoTxEnable=0');
if ShowTxBtnEnable then
  ConfigList.Append('ShowTxBtnEnable=1')
else
  ConfigList.Append('ShowTxBtnEnable=0');
if BitConfListe.Count > 0 then
  begin;
  for i := 0 to BitConfListe.Count-1 do
    begin;
    Name := PTxBitConf(BitConfListe[i]).Name;
    WidgetColor := Integer(PTxBitConf(BitConfListe[i]).Color);
    BytePos := PTxBitConf(BitConfListe[i]).BytePos;
    BitPos := PTxBitConf(BitConfListe[i]).BitPos;
    ConfigList.Append(format('CanBit%u=%s;%d;%u;%u', [i, Name, WidgetColor, BytePos, BitPos]));
    end;
  end;  
end;


procedure TCanBitTxWin.ProcessDataChange(only_update: boolean; force_tx: boolean);
var
  i: integer;
  maske: Byte;
  tmp_data: array[0..63] of Byte;
  tx_msg: PTxCanMsg;
  msg_idx: Integer;
  change: boolean;

begin;
if BitConfListe.Count = 0 then
  exit;
msg_idx := MainWin.TxList.GetIndexById(CanId);
if msg_idx < 0 then
  exit;
tx_msg := MainWin.TxList.Items[msg_idx];
for i := 0 to 63 do
  tmp_data[i] := tx_msg^.CanMsg.Data.Bytes[i];
for i := 0 to BitConfListe.Count-1 do
  begin
  if i >= ChkBits.Count then
    exit;
  maske := 1 shl PTxBitConf(BitConfListe[i]).BitPos;
  if TCheckBox(ChkBits.Items[i]).Checked then
    tmp_data[PTxBitConf(BitConfListe[i]).BytePos] := tmp_data[PTxBitConf(BitConfListe[i]).BytePos] or maske
  else
    tmp_data[PTxBitConf(BitConfListe[i]).BytePos] := tmp_data[PTxBitConf(BitConfListe[i]).BytePos] and (not maske);
  end;
change := FALSE;
for i := 0 to 63 do
  begin
  if tx_msg^.CanMsg.Data.Bytes[i] <> tmp_data[i] then
    change := TRUE;
  tx_msg^.CanMsg.Data.Bytes[i] := tmp_data[i];
  end;
if only_update or change then
  MainWin.TxUpdateMessage(msg_idx);
if not only_update and (change or force_tx) then
    MainWin.TxList.Transmit(msg_idx);
end;


procedure TCanBitTxWin.BitChkBtnClick(Sender: TObject);

begin;
if AutoTxEnable then
  ProcessDataChange(FALSE, FALSE);
end;


procedure TCanBitTxWin.TxBtnClick(Sender: TObject);

begin
ProcessDataChange(FALSE, TRUE);
end;


procedure TCanBitTxWin.CreateChkBits;
var i: Integer;
    chk_bits: TCheckBox;
    str: String;

begin;
ChkBits.Clear;
if BitConfListe.Count = 0 then
  exit;
for i := 0 to BitConfListe.Count-1 do
  begin
  chk_bits := TCheckBox.Create(self);
  chk_bits.Parent := self;
  chk_bits.Left := 5;
  chk_bits.Height := 25;  
  //chk_bits.Font.Color := clSilver;
  chk_bits.Font.Style := [fsBold];
  chk_bits.Font.Color := PTxBitConf(BitConfListe[i]).Color;
  str := PTxBitConf(BitConfListe[i]).Name;
  chk_bits.Width := GetTextWidth(chk_bits.Font, str) + 40;
  chk_bits.Caption := str;
  chk_bits.Checked := False;
  chk_bits.OnClick := BitChkBtnClick;
  chk_bits.Tag := i;
  ChkBits.Add(chk_bits);
  end;
FormResize(self);
end;


procedure TCanBitTxWin.RxCanMessages(can_msg: PCanFdMsg; count: Integer);

begin;
end;


procedure TCanBitTxWin.RxCanUpdate;

begin;
end;


procedure TCanBitTxWin.ConfigBtnClick(Sender: TObject);
var
  Form: TCanBitTxSetupWin;
  
begin
EventsLock;
Form := TCanBitTxSetupWin.Create(self);

Form.NameEdit.Text := self.Caption;
Form.CANIDEdit.Number := CanId;
{Form.DLCEdit.Number := CanDlc; <*>
Form.IntervallEdit.Number := Intervall;}
Form.AutoTxCheckBox.Checked := AutoTxEnable;
Form.ShowTxBtnCheckBox.Checked := ShowTxBtnEnable;
Form.SetBitConfListe(BitConfListe);
if Form.ShowModal = mrOK then
  begin
  self.Caption := Form.NameEdit.Text;
  CanId := Form.CANIDEdit.Number;
  {CanDlc := Form.DLCEdit.Number; <*>
  Intervall := Form.IntervallEdit.Number;}
  AutoTxEnable := Form.AutoTxCheckBox.Checked;
  ShowTxBtnEnable := Form.ShowTxBtnCheckBox.Checked;
  Form.GetBitConfListe(BitConfListe);
  CreateChkBits;
  WindowMenuItem.Caption := self.Caption;      
  end;
Form.Free;
EventsUnlock;
end;


procedure TCanBitTxWin.DestroyBtnClick(Sender: TObject);

begin
close;
end;

end.
