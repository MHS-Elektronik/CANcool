{***************************************************************************
                      CanTermForm.pas  -  description
                             -------------------
    begin             : 23.12.2021
    last modified     : 11.01.2022     
    copyright         : (C) 2021 - 2022 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit CanTermForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CanRxPrototyp, StdCtrls, Buttons, MainForm, IntegerTerm, CanCoolDefs,
  ExtCtrls, Menus, RackCtls, Util, TinyCanDrv, OverbyteIcsEmulVT;
  
const 
  TxBufferSize = 10000;  

type
  TCanTermWin = class(TCanRxPrototypForm)
    CanTermMenu: TPopupMenu;
    ConfigBtn: TMenuItem;
    AktivBtn: TMenuItem;
    N1: TMenuItem;
    DestroyBtn: TMenuItem;
    VT: TEmulVT;
    procedure FormCreate(Sender: TObject);
    procedure ConfigBtnClick(Sender: TObject);
    procedure AktivBtnClick(Sender: TObject);
    procedure DestroyBtnClick(Sender: TObject);
    procedure VTKeyBuffer(Sender: TObject; Buffer: PAnsiChar;
      Len: Integer);
    procedure VTKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
    StrBuffer: String;
    RxCanId: Longword;
    RxEff: Boolean;
    TxCanId: Longword;
    TxEff: Boolean;
    TxEnable: Boolean;
    TxBrs: Boolean;
    TxFd: Boolean;
    TxOnReturn: Boolean;
    TxBuffer: array[0..TxBufferSize-1] of AnsiChar;
    TxPtr: Integer;
    procedure SetConfig;
    procedure TxData(buffer: PAnsiChar; len: Integer);
    procedure PutTxData(buffer: PAnsiChar; len: Integer; forced_tx: Boolean);
  public
    { Public-Deklarationen }
    procedure RxCanMessages(can_msg: PCanFdMsg; count: Integer); override;
    procedure RxCanUpdate; override;
    function ExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer; override;
    procedure LoadConfig(ConfigList: TStrings); override;
    procedure SaveConfig(ConfigList: TStrings); override;
  end;

var
  CanTermWin: TCanTermWin;

implementation

uses CanTermSetupForm; 

{$R *.dfm}

procedure TCanTermWin.SetConfig;
var DC : HDC;
    Metrics : TTextMetric;
    hObject : THandle;
    
begin;
DC := GetDC(0);
hObject := SelectObject(DC, VT.Font.Handle);
GetTextMetrics(DC, Metrics);
SelectObject(DC, hOBject);
ReleaseDC(0, DC);
VT.LineHeight := Metrics.tmHeight;
VT.CharWidth := Metrics.tmMaxCharWidth;
VT.Repaint;
end;


procedure TCanTermWin.FormCreate(Sender: TObject);

begin
inherited;
CommandMask := SYS_COMMAND or RX_WIN_COMMAND;
StrBuffer := '';
TxPtr := 0;
VT.Clear;
SetConfig;
end;


procedure TCanTermWin.LoadConfig(ConfigList: TStrings);
var font_desc: TFontDesc;

begin
EventsLock;
self.Caption := ReadListString(ConfigList, 'Name', self.Caption);

RxCanId := ReadListInteger(ConfigList, 'RxCanId', RxCanId);
RxEff := ReadListInteger(ConfigList, 'RxEff', ord(RxEff)) <> 0;
TxCanId := ReadListInteger(ConfigList, 'TxCanId', TxCanId);
TxEff := ReadListInteger(ConfigList, 'TxEff', ord(TxEff)) <> 0;
TxEnable := ReadListInteger(ConfigList, 'TxEnable', ord(TxEnable)) <> 0;
TxBrs := ReadListInteger(ConfigList, 'TxBrs', ord(TxBrs)) <> 0;
TxFd := ReadListInteger(ConfigList, 'TxFd', ord(TxFd)) <> 0;
TxOnReturn := ReadListInteger(ConfigList, 'TxOnReturn', ord(TxOnReturn)) <> 0;
VT.AutoCR := ReadListInteger(ConfigList, 'AutoCR', ord(VT.AutoCR)) <> 0;
VT.AutoLF := ReadListInteger(ConfigList, 'AutoLF', ord(VT.AutoLF)) <> 0;
VT.LocalEcho := ReadListInteger(ConfigList, 'LocalEcho', ord(VT.LocalEcho)) <> 0;
VT.MonoChrome := ReadListInteger(ConfigList, 'MonoChrome', ord(VT.MonoChrome)) <> 0;
VT.Xlat := ReadListInteger(ConfigList, 'Xlat', ord(VT.Xlat)) <> 0;
VT.GraphicDraw := ReadListInteger(ConfigList, 'GraphicDraw', ord(VT.GraphicDraw)) <> 0;
VT.Rows := ReadListInteger(ConfigList, 'Rows', VT.Rows);
VT.Cols := ReadListInteger(ConfigList, 'Cols', VT.Cols);
VT.FKeys := ReadListInteger(ConfigList, 'FKeys', VT.FKeys);
ReadListFont(ConfigList, 'Font', font_desc, DefaultFont);
FontDescToFont(font_desc, VT.Font);
WindowMenuItem.Caption :=  self.Caption;
SetConfig;
EventsUnlock;
end;


procedure TCanTermWin.SaveConfig(ConfigList: TStrings);
var font_desc: TFontDesc;

begin
ConfigList.Append(format('Name=%s', [self.Caption]));
ConfigList.Append(format('RxCanId=%u', [RxCanId]));
ConfigList.Append(format('RxEff=%u', [ord(RxEff)]));
ConfigList.Append(format('TxCanId=%u', [TxCanId]));
ConfigList.Append(format('TxEff=%u', [ord(TxEff)]));
ConfigList.Append(format('TxEnable=%u', [ord(TxEnable)]));
ConfigList.Append(format('TxBrs=%u', [ord(TxBrs)]));
ConfigList.Append(format('TxFd=%u', [ord(TxFd)]));
ConfigList.Append(format('TxOnReturn=%u', [ord(TxOnReturn)]));;
ConfigList.Append(format('AutoCR=%u', [ord(VT.AutoCR)]));
ConfigList.Append(format('AutoLF=%u', [ord(VT.AutoLF)]));
ConfigList.Append(format('LocalEcho=%u', [ord(VT.LocalEcho)]));
ConfigList.Append(format('MonoChrome=%u', [ord(VT.MonoChrome)]));
ConfigList.Append(format('Xlat=%u', [ord(VT.Xlat)]));
ConfigList.Append(format('GraphicDraw=%u', [ord(VT.GraphicDraw)]));
ConfigList.Append(format('Rows=%u', [VT.Rows]));
ConfigList.Append(format('Cols=%u', [VT.Cols]));
ConfigList.Append(format('FKeys=%u', [VT.FKeys]));
FontDescFromFont(font_desc, VT.Font);
WriteListFont(ConfigList, 'Font', font_desc);
end;


procedure TCanTermWin.RxCanMessages(can_msg: PCanFdMsg; count: Integer);
var
  i, dlc, idx: integer;
  fault: boolean;
  
begin;
if (not MainWin.EnableTrace) or (count = 0) then
  exit;
for i := 1 to count do
  begin;
  fault := false;
  if (can_msg^.Flags and FlagCanFdRTR) > 0 then
    fault := true
  else if can_msg^.ID <> RxCanId then
    fault := true
  else 
    begin;
    if RxEff then
      begin;
      if (can_msg^.Flags and FlagCanFdEFF) = 0 then
        fault := true;
      end
    else
      begin
      if (can_msg^.Flags and FlagCanFdEFF) > 0 then
        fault := true;
      end;  
    end;  
  if not fault then
    begin;      
    can_msg^.Flags := can_msg^.Flags or FlagCanFdFilHit;
    dlc := can_msg^.Length;
    if dlc > 0 then
      begin;
      for idx := 0 to dlc - 1 do
        StrBuffer := StrBuffer + can_msg^.Data.Chars[idx];
      end;       
    end;
  inc(can_msg);
  end;   
end;


procedure TCanTermWin.RxCanUpdate;
var str: String;

begin
if not MainWin.EnableTrace then
  exit;
RxCanEnterCritical;
str := StrBuffer;
StrBuffer := '';
RxCanLeaveCritical;
VT.WriteStr(str);
end;


function TCanTermWin.ExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer;

begin
result := 0;
case cmd of                       
  RX_WIN_CLEAR       : begin;
                       VT.Clear;
                       VT.UpdateScreen;
                       end;
  {RX_WIN_START_TRACE : EnableTrace := True; <*>
  RX_WIN_STOP_TRACE  : EnableTrace := False; }
  end;
end;


procedure TCanTermWin.ConfigBtnClick(Sender: TObject);
var Form: TCanTermSetupWin;

begin
EventsLock;
Form := TCanTermSetupWin.Create(self);
Form.NameEdit.Text := self.Caption;

Form.RxCanIdEdit.Number := RxCanId;
Form.RxEffCheckBox.Checked := RxEff;
Form.TxCanIdEdit.Number := TxCanId;
Form.TxEffCheckBox.Checked := TxEff;
Form.TxEnableCheckBox.Checked := TxEnable;
Form.TxBrsCheckBox.Checked := TxBrs;
Form.TxFdCheckBox.Checked := TxFd;
Form.TxOnReturnCheckBox.Checked := TxOnReturn;

Form.AutoCRCheckBox.Checked := VT.AutoCR;
Form.AutoLFCheckBox.Checked := VT.AutoLF;
Form.LocalEchoCheckBox.Checked := VT.LocalEcho;
Form.MonoChromeCheckBox.Checked := VT.MonoChrome;
Form.XlatCheckBox.Checked := VT.Xlat;
Form.GraphicDrawCheckBox.Checked := VT.GraphicDraw;
Form.Rows := VT.Rows;
Form.Cols := VT.Cols;
Form.FKeys := VT.FKeys;
//Form.FontLabel.Font := TFont(VT.Font);
Form.FontLabel.Font.Name := VT.Font.Name;
Form.FontLabel.Font.Size := VT.Font.Size;
Form.FontLabel.Font.Style := VT.Font.Style;
if Form.ShowModal = mrOK then
  begin
  self.Caption := Form.NameEdit.Text;
  RxCanId := Form.RxCanIdEdit.Number;        
  RxEff := Form.RxEffCheckBox.Checked;     
  TxCanId := Form.TxCanIdEdit.Number;        
  TxEff := Form.TxEffCheckBox.Checked;     
  TxEnable := Form.TxEnableCheckBox.Checked;  
  TxBrs := Form.TxBrsCheckBox.Checked;     
  TxFd := Form.TxFdCheckBox.Checked;      
  TxOnReturn := Form.TxOnReturnCheckBox.Checked;

  VT.AutoCR := Form.AutoCRCheckBox.Checked;
  VT.AutoLF := Form.AutoLFCheckBox.Checked;
  VT.LocalEcho := Form.LocalEchoCheckBox.Checked;
  VT.MonoChrome := Form.MonoChromeCheckBox.Checked;
  VT.Xlat := Form.XlatCheckBox.Checked;
  VT.GraphicDraw := Form.GraphicDrawCheckBox.Checked;
  VT.Rows := Form.Rows;
  VT.Cols := Form.Cols;
  VT.FKeys := Form.FKeys;
  VT.Font.Name := Form.FontLabel.Font.Name;
  VT.Font.Size := Form.FontLabel.Font.Size;
  VT.Font.Style := Form.FontLabel.Font.Style;
  SetConfig;  
  WindowMenuItem.Caption := self.Caption;
  end;
Form.Free;
EventsUnlock;
end;


procedure TCanTermWin.AktivBtnClick(Sender: TObject);

begin
WidgetAktiv := AktivBtn.Checked;
end;


procedure TCanTermWin.DestroyBtnClick(Sender: TObject);

begin
close;
end;


procedure TCanTermWin.VTKeyBuffer(Sender: TObject; buffer: PAnsiChar; len: Integer);

begin
inherited;
PutTxData(buffer, len, TRUE);
end;


procedure TCanTermWin.VTKeyPress(Sender: TObject; var Key: Char);
var ch: AnsiChar;

begin
  inherited;
ch := AnsiChar(Key);
PutTxData(@ch, 1, FALSE);
end;


procedure TCanTermWin.TxData(buffer: PAnsiChar; len: Integer);
var i, ii, msg_size: longword;
    can_msg: TCanFdMsg;

begin;
ii := 0;
can_msg.Flags := 0;
if TxEff then
  can_msg.Flags := can_msg.Flags or FlagCanFdEFF;
if TxFd then
  begin;
  msg_size := 64;
  can_msg.Flags := can_msg.Flags or FlagCanFdFD;
  if TxBrs then
    can_msg.Flags := can_msg.Flags or FlagCanFdBRS;
  end
else
  msg_size := 8;
can_msg.Length := msg_size;       
can_msg.Id := TxCanId;
for i := 0 to Len - 1 do
  begin;
  can_msg.Data.Chars[ii] := Buffer[i];
  inc(ii);
  if ii = msg_size then
    begin;
    ii := 0;
    MainWin.TinyCAN.CanFdTransmit(MainWin.TinyCAN.DeviceIndex, @can_msg, 1);
    end;
  end;
if ii > 0 then
  begin;
  //can_msg.Length := ii;
  CorrectCanFdLenEx(ii, @can_msg, $00);
  MainWin.TinyCAN.CanFdTransmit(MainWin.TinyCAN.DeviceIndex, @can_msg, 1);
  end;
end;


procedure TCanTermWin.PutTxData(buffer: PAnsiChar; len: Integer; forced_tx: Boolean);
var i: Integer;
    ch: AnsiChar;
    tx: Boolean;
    
begin;
if (not TxEnable) or (len < 1) then
  exit;  
if TxOnReturn then
  begin;
  tx := forced_tx;
  for i := 0 to len - 1 do
    begin;
    if TxPtr > (TxBufferSize - 2) then
      TxPtr := 0;
    ch := buffer[i];
    if ch = AnsiChar($0D) then
      tx := TRUE;  
    TxBuffer[TxPtr] := ch;
    inc(TxPtr);
    end;
  if tx then
    begin;
    TxData(@TxBuffer, TxPtr);
    TxPtr := 0;
    end;
  end
else
  TxData(buffer, len);
end;

end.
