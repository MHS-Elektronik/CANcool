{***************************************************************************
                      CanValueForm.pas  -  description
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
unit CanValueForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CanRxPrototyp, StdCtrls, Buttons, MainForm, IntegerTerm,
  ExtCtrls, Menus, RackCtls, Util, TinyCanDrv;

type
  TCanValueWin = class(TCanRxPrototypForm)
    EinheitLabel: TLabel;
    WertAnzMenu: TPopupMenu;
    ConfigBtn: TMenuItem;
    AktivBtn: TMenuItem;
    N1: TMenuItem;
    DestroyBtn: TMenuItem;
    LEDDisplay: TLEDDisplay;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ConfigBtnClick(Sender: TObject);
    procedure AktivBtnClick(Sender: TObject);
    procedure DestroyBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    BerechnungsObj: TIntTerm;
    DataChange: Boolean;
    Data: array[0..63] of Byte;
    Varis: VarArray;
    CanId: longword;
    MuxEnable: boolean;
    MuxDlc: Byte;
    MuxCanMask: array[0..7] of Byte;
    MuxCanData: array[0..7] of Byte;
    Formula: string;
    UnitStr: string;
    Margin: integer;       // Abstand der Skala zum Rand
    FSizeType: Integer;
    procedure SetFSizeType(value: Integer);
    property SizeType: Integer read FSizeType write SetFSizeType;
  public
    { Public-Deklarationen }
    procedure RxCanMessages(can_msg: PCanFdMsg; count: Integer); override;
    procedure RxCanUpdate; override; 
    procedure LoadConfig(ConfigList: TStrings); override;
    procedure SaveConfig(ConfigList: TStrings); override;
  end;

var
  CanValueWin: TCanValueWin;

implementation

uses CanValueSetupForm; 

{$R *.dfm}

procedure TCanValueWin.FormCreate(Sender: TObject);
var
  i: integer;

begin
inherited;
BerechnungsObj := TIntTerm.Create;
SetLength(Varis, 64);
for i := 0 to high(Varis) do
  begin
  Varis[i].Name := format('d%u',[i]);
  Varis[i].Wert := 0;
  end;
Margin := 5;
UnitStr := 'x';
CanId := 0;
MuxEnable := False;
MuxDlc := 8;
for i := 0 to 7 do
  begin;
  MuxCanMask[i] := 0;
  MuxCanData[i] := 0;
  end;
Formula := '(d0 << 8) + d1';
SizeType := 1;
LEDDisplay.FractionDigits := 0;
LEDDisplay.Value := 0;
FormResize(self);
end;


procedure TCanValueWin.FormResize(Sender: TObject);
var h: Integer;

begin
inherited;
LEDDisplay.Left := Margin;
EinheitLabel.Left := LEDDisplay.Left + LEDDisplay.Width + Margin;
EinheitLabel.Width := EinheitLabel.Canvas.TextWidth(UnitStr);
EinheitLabel.Height := EinheitLabel.Canvas.TextHeight(UnitStr);
self.ClientWidth := LEDDisplay.Width + EinheitLabel.Width + (2 * Margin);
h := LEDDisplay.Top + LEDDisplay.Height + Margin;
EinheitLabel.Top := h - (EinheitLabel.Height + 5);
self.ClientHeight := h;
EinheitLabel.Caption := UnitStr;
end;


procedure TCanValueWin.SetFSizeType(value: Integer);
begin
if value <> FSizeType then
  begin
  FSizeType := value;
  case value of
    0 : begin;
        EinheitLabel.Font.Size := 10;
        LEDDisplay.DigitLineWidth := 2;
        LEDDisplay.DigitHeight := 28;
        LEDDisplay.DigitWidth := 15;
        LEDDisplay.Height := 30;
        LEDDisplay.Width := 120;
        end;
    1 : begin;
        EinheitLabel.Font.Size := 18;
        LEDDisplay.DigitLineWidth := 4;
        LEDDisplay.DigitHeight := 50;
        LEDDisplay.DigitWidth := 28;
        LEDDisplay.Height := 57;
        LEDDisplay.Width := 209;
        end;
    2 : begin;
        EinheitLabel.Font.Size := 28;
        LEDDisplay.DigitLineWidth := 7;
        LEDDisplay.DigitHeight := 90;
        LEDDisplay.DigitWidth := 57;
        LEDDisplay.Height := 100;
        LEDDisplay.Width := 400;
        end;
    else

    end;
  end;
end;


procedure TCanValueWin.LoadConfig(ConfigList: TStrings);

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
Formula := ReadListString(ConfigList, 'Formula', Formula);
UnitStr := ReadListString(ConfigList, 'Unit', UnitStr);
LEDDisplay.ColorLED := TColor(ReadListInteger(ConfigList, 'BaseColor', Integer(LEDDisplay.ColorLED)));
EinheitLabel.Font.Color := LEDDisplay.ColorLED;
SizeType := ReadListInteger(ConfigList, 'SizeType', SizeType);
LEDDisplay.FractionDigits := ReadListInteger(ConfigList, 'PrecDigits', LEDDisplay.FractionDigits);
FormResize(self);
WindowMenuItem.Caption :=  self.Caption;
EventsUnlock;
end;


procedure TCanValueWin.SaveConfig(ConfigList: TStrings);

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
ConfigList.Append(format('Formula=%s', [Formula]));
ConfigList.Append(format('Unit=%s', [UnitStr]));
ConfigList.Append(format('BaseColor=%d', [Integer(LEDDisplay.ColorLED)]));
ConfigList.Append(format('SizeType=%u', [SizeType]));
ConfigList.Append(format('PrecDigits=%d', [LEDDisplay.FractionDigits]));
end;


procedure TCanValueWin.RxCanMessages(can_msg: PCanFdMsg; count: Integer);
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
  if (dlc >= 1) and (dlc <= 8) then
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


procedure TCanValueWin.RxCanUpdate; 
var
  i: integer;

begin
if not DataChange then
  exit;
RxCanEnterCritical;  
DataChange := False;
for i := 0 to high(Varis) do
  Varis[i].Wert := Data[i];
RxCanLeaveCritical;
try
  LEDDisplay.Value := BerechnungsObj.TermLoesen(Formula, @Varis);
except
  WidgetAktiv := false;
  MessageDlg('Im Berechnungs Term ist ein Fehler aufgetretten:'+#13+#10+
        BerechnungsObj.GetFehlerText, mtError, [mbOk], 0);
  end;
end;


procedure TCanValueWin.ConfigBtnClick(Sender: TObject);
var
  Form: TCanValueSetupWin;

begin
EventsLock;
Form := TCanValueSetupWin.Create(self);
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
Form.BerechnungsTermEdit.Text := Formula;
Form.EinheitEdit.Text := UnitStr;
Form.ColorEdit.Selected := LEDDisplay.ColorLED;
Form.SizeEdit.ItemIndex := SizeType;
Form.PrecDigitEdit.Value := LEDDisplay.FractionDigits;
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
  Formula := Form.BerechnungsTermEdit.Text;
  UnitStr := Form.EinheitEdit.Text;
  LEDDisplay.ColorLED := Form.ColorEdit.Selected;
  EinheitLabel.Font.Color := LEDDisplay.ColorLED;
  SizeType := Form.SizeEdit.ItemIndex;
  LEDDisplay.FractionDigits := Form.PrecDigitEdit.Value;

  FormResize(self);
  WindowMenuItem.Caption :=  self.Caption;
  end;
Form.Free;
EventsUnlock;
end;


procedure TCanValueWin.AktivBtnClick(Sender: TObject);

begin;
WidgetAktiv := AktivBtn.Checked;
end;


procedure TCanValueWin.DestroyBtnClick(Sender: TObject);

begin
close;
end;

end.
