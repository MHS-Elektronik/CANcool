{***************************************************************************
                       CanGaugeForm.pas  -  description
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
unit CanGaugeForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CanRxPrototyp, MainForm,
  IntegerTerm, CanGaugeSetupForm, Menus, A3nalogGauge, Util, TinyCanDrv;

type
  TCanGaugeWin = class(TCanRxPrototypForm)
    AnalogInstMenu: TPopupMenu;
    ConfigBtn: TMenuItem;
    AktivBtn: TMenuItem;
    N1: TMenuItem;
    DestroyBtn: TMenuItem;
    Gauge: TA3nalogGauge;
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
    FSizeType: Integer;
    CanId: longword;
    MuxEnable: boolean;
    MuxDlc: Byte;
    MuxCanMask: array[0..7] of Byte;
    MuxCanData: array[0..7] of Byte;
    Formula: string;
    procedure SetFSizeType(value: Integer);
    property SizeType: Integer read FSizeType write SetFSizeType;
  public
    { Public-Deklarationen }
    procedure RxCanMessages(can_msg: PCanFdMsg; count: Integer); override;
    procedure RxCanUpdate; override; 
    procedure LoadConfig(ConfigList: TStrings); override;
    procedure SaveConfig(ConfigList: TStrings); override;
  end;

implementation

{$R *.dfm}

procedure TCanGaugeWin.FormCreate(Sender: TObject);
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
//slef.Selected;
Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMin, ShowIndicatorMid, ShowIndicatorMax];
SizeType := 1;
Gauge.ScaleMin := 0;
Gauge.ScaleMax := 100;
Gauge.NumberMainTicks := 10;
Gauge.NumberSubTicks := 5;
Gauge.IndMinimum := 30;
Gauge.IndMaximum := 70;
Gauge.Caption := 'x';
CanId := 0;
MuxEnable := False;
MuxDlc := 8;
for i := 0 to 7 do
  begin;
  MuxCanMask[i] := 0;
  MuxCanData[i] := 0;
  end;
Formula := '(d0 << 8) + d1';
FormResize(self);
end;


procedure TCanGaugeWin.FormResize(Sender: TObject);
begin
inherited;
self.ClientWidth := Gauge.Width;
self.ClientHeight := Gauge.Top + Gauge.Height;
end;

procedure TCanGaugeWin.SetFSizeType(value: Integer);
begin
if value <> FSizeType then
  begin
  FSizeType := value;
  case value of
    0 : begin;
        Gauge.Width := 150;
        Gauge.Height := 150;
        Gauge.ArrowWidth := 1;
        Gauge.TicksWidth := 1;
        Gauge.Font.Size := 8;
        end;
    1 : begin;
        Gauge.Width := 250;
        Gauge.Height := 250;
        Gauge.ArrowWidth := 2;
        Gauge.TicksWidth := 2;
        Gauge.Font.Size := 8;
        end;
    2 : begin;
        Gauge.Width := 400;
        Gauge.Height := 400;
        Gauge.ArrowWidth := 4;
        Gauge.TicksWidth := 4;
        Gauge.Font.Size := 14;
        end;
    else
      Gauge.Width := 250;
      Gauge.Height := 250;
      Gauge.ArrowWidth := 2;
      Gauge.TicksWidth := 2;
      Gauge.Font.Size := 8;
    end;
  end;
end;


procedure TCanGaugeWin.RxCanMessages(can_msg: PCanFdMsg; count: Integer);
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


procedure TCanGaugeWin.RxCanUpdate; 
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
  Gauge.Position := BerechnungsObj.TermLoesen(Formula, @Varis);
except
  WidgetAktiv := false;
  MessageDlg('Im Berechnungs Term ist ein Fehler aufgetretten:'+#13+#10+
        BerechnungsObj.GetFehlerText, mtError, [mbOk], 0);
  end;
end;


procedure TCanGaugeWin.LoadConfig(ConfigList: TStrings);

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
Gauge.Caption := ReadListString(ConfigList, 'Unit', Gauge.Caption);
Formula := ReadListString(ConfigList, 'Formula', Formula);
Gauge.FaceColor := TColor(ReadListInteger(ConfigList, 'BaseColor', Integer(Gauge.FaceColor)));
SizeType := ReadListInteger(ConfigList, 'SizeType', SizeType);
Gauge.ScaleMax := ReadListInteger(ConfigList, 'ScaleMax', Gauge.ScaleMax);
Gauge.ScaleMin := ReadListInteger(ConfigList, 'ScaleMin', Gauge.ScaleMin);

Gauge.NumberMainTicks := ReadListInteger(ConfigList, 'NumberMainTicks', Gauge.NumberMainTicks);
Gauge.NumberSubTicks := ReadListInteger(ConfigList, 'NumberSubTicks', Gauge.NumberSubTicks);
Gauge.IndMinimum := ReadListInteger(ConfigList, 'IndMin', Gauge.IndMinimum);
Gauge.IndMaximum := ReadListInteger(ConfigList, 'IndMax', Gauge.IndMaximum);
if ReadListInteger(ConfigList, 'EnableMinRange', 0) > 0 then
  Gauge.FaceOptions := Gauge.FaceOptions + [ShowIndicatorMin]
else
  Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMin];
if ReadListInteger(ConfigList, 'EnableMidRange', 0) > 0 then
  Gauge.FaceOptions := Gauge.FaceOptions + [ShowIndicatorMid]
else
  Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMid];
if ReadListInteger(ConfigList, 'EnableMaxRange', 0) > 0 then
  Gauge.FaceOptions := Gauge.FaceOptions + [ShowIndicatorMax]
else
  Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMax];
Gauge.MinColor := TColor(ReadListInteger(ConfigList, 'MinRangeColor', Integer(Gauge.MinColor)));
Gauge.MidColor := TColor(ReadListInteger(ConfigList, 'MidRangeColor', Integer(Gauge.MinColor)));
Gauge.MaxColor := TColor(ReadListInteger(ConfigList, 'MaxRangeColor', Integer(Gauge.MinColor)));  
FormResize(self);
WindowMenuItem.Caption :=  self.Caption;
EventsUnlock;
end;


procedure TCanGaugeWin.SaveConfig(ConfigList: TStrings);

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
ConfigList.Append(format('Unit=%s', [Gauge.Caption]));
ConfigList.Append(format('Formula=%s', [Formula]));
ConfigList.Append(format('BaseColor=%d', [Integer(Gauge.FaceColor)]));
ConfigList.Append(format('SizeType=%u', [SizeType]));
ConfigList.Append(format('ScaleMin=%d', [Gauge.ScaleMin]));
ConfigList.Append(format('ScaleMax=%d', [Gauge.ScaleMax]));
ConfigList.Append(format('NumberMainTicks=%u', [Gauge.NumberMainTicks]));
ConfigList.Append(format('NumberSubTicks=%u', [Gauge.NumberSubTicks]));
ConfigList.Append(format('IndMin=%u', [Gauge.IndMinimum]));
ConfigList.Append(format('IndMax=%u', [Gauge.IndMaximum]));
if ShowIndicatorMin in Gauge.FaceOptions then
  ConfigList.Append('EnableMinRange=1')
else
  ConfigList.Append('EnableMinRange=0');
if ShowIndicatorMid in Gauge.FaceOptions then
  ConfigList.Append('EnableMidRange=1')
else
  ConfigList.Append('EnableMidRange=0');
if ShowIndicatorMax in Gauge.FaceOptions then
  ConfigList.Append('EnableMaxRange=1')
else
  ConfigList.Append('EnableMaxRange=0');
ConfigList.Append(format('MinRangeColor=%d', [Integer(Gauge.MinColor)]));
ConfigList.Append(format('MidRangeColor=%d', [Integer(Gauge.MidColor)]));
ConfigList.Append(format('MaxRangeColor=%d', [Integer(Gauge.MaxColor)]));
end;


procedure TCanGaugeWin.ConfigBtnClick(Sender: TObject);
var
  Form: TCanGaugeSetupWin;

begin
EventsLock;
Form := TCanGaugeSetupWin.Create(self);

Form.NameEdit.Text := self.Caption;
Form.EinheitEdit.Text := Gauge.Caption;
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
Form.ColorEdit.Selected := Gauge.FaceColor;
Form.SizeEdit.ItemIndex := SizeType;
Form.MinSkalaSpin.Value := Gauge.ScaleMin;
Form.MaxSkalaSpin.Value := Gauge.ScaleMax;
Form.SkalaTeilungSpin.Value := Gauge.NumberMainTicks;
Form.SkalaUnterteilungSpin.Value := Gauge.NumberSubTicks;
Form.IndMinSpin.Value := Gauge.IndMinimum;
Form.IndMaxSpin.Value := Gauge.IndMaximum;
if ShowIndicatorMin in Gauge.FaceOptions then
  Form.MinRangeCheck.Checked := True
else
  Form.MinRangeCheck.Checked := False;
if ShowIndicatorMid in Gauge.FaceOptions then
  Form.MidRangeCheck.Checked := True
else
  Form.MidRangeCheck.Checked := False;
if ShowIndicatorMax in Gauge.FaceOptions then
  Form.MaxRangeCheck.Checked := True
else
  Form.MaxRangeCheck.Checked := False;
Form.MinRangeColorEdit.Selected := Gauge.MinColor; 
Form.MidRangeColorEdit.Selected := Gauge.MidColor;
Form.MaxRangeColorEdit.Selected := Gauge.MaxColor;

if Form.ShowModal = mrOK then
  begin
  self.Caption := Form.NameEdit.Text;
  CanId := Form.CANIDEdit.Number;
  Gauge.Caption := Form.EinheitEdit.Text;
  Formula := Form.BerechnungsTermEdit.Text;
  Gauge.FaceColor := Form.ColorEdit.Selected;
  SizeType := Form.SizeEdit.ItemIndex;
  Gauge.ScaleMin := Form.MinSkalaSpin.Value;
  Gauge.ScaleMax := Form.MaxSkalaSpin.Value;
  Gauge.NumberMainTicks := Form.SkalaTeilungSpin.Value;
  Gauge.NumberSubTicks := Form.SkalaUnterteilungSpin.Value;
  Gauge.IndMinimum := Form.IndMinSpin.Value;
  Gauge.IndMaximum := Form.IndMaxSpin.Value;
  if Form.MinRangeCheck.Checked then
    Gauge.FaceOptions := Gauge.FaceOptions + [ShowIndicatorMin]
  else
    Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMin];
  if Form.MidRangeCheck.Checked then
    Gauge.FaceOptions := Gauge.FaceOptions + [ShowIndicatorMid]
  else
    Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMid];
  if Form.MaxRangeCheck.Checked then
    Gauge.FaceOptions := Gauge.FaceOptions + [ShowIndicatorMax]
  else
    Gauge.FaceOptions := Gauge.FaceOptions - [ShowIndicatorMax];
  Gauge.MinColor := Form.MinRangeColorEdit.Selected;
  Gauge.MidColor := Form.MidRangeColorEdit.Selected;
  Gauge.MaxColor := Form.MaxRangeColorEdit.Selected;  
  FormResize(self);
  WindowMenuItem.Caption :=  self.Caption;
  end;
Form.Free;
EventsUnlock;
end;


procedure TCanGaugeWin.AktivBtnClick(Sender: TObject);

begin
WidgetAktiv := AktivBtn.Checked;
end;


procedure TCanGaugeWin.DestroyBtnClick(Sender: TObject);

begin
close;
end;

end.
