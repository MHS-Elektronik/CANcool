{***************************************************************************
                       CanGraph.pas  -  description
                             -------------------
    begin             : 28.12.2021
    last modified     : 31.12.2021     
    copyright         : (C) 2021 by MHS-Elektronik GmbH & Co. KG, Germany
                               http://www.mhs-elektronik.de
    autho             : Klaus Demlehner, klaus@mhs-elektronik.de
 ***************************************************************************}

{***************************************************************************
 *                                                                         *
 *   This program is free software, you can redistribute it and/or modify  *
 *   it under the terms of the MIT License <LICENSE.TXT or                 *
 *   http://opensource.org/licenses/MIT>                                   *
 *                                                                         *
 ***************************************************************************}
unit CanGraph;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CanRxPrototyp, ExtCtrls, StdCtrls, Buttons, MainForm, CanCoolDefs,
  IntegerTerm, Util, TinyCanDrv, Menus;

const
  GraphValuesCapacity: Longword = 10000;

type
  TCanGraphWin = class(TCanRxPrototypForm)
    GraphFrame: TBevel;
    CanGraphMenu: TPopupMenu;
    ConfigBtn: TMenuItem;
    AktivBtn: TMenuItem;
    N1: TMenuItem;
    DestroyBtn: TMenuItem;    
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ConfigBtnClick(Sender: TObject);
    procedure AktivBtnClick(Sender: TObject);
    procedure DestroyBtnClick(Sender: TObject);    
  private
    { Private-Deklarationen }
    BerechnungsTerm: String;
    GraphValuesCount: Longword;
    GraphValuesLimit: Longword;
    GraphValues: array[0..10000] of Integer;  // <*> GraphValuesCapacity
    BerechnungsObj: TIntTerm;
    Varis: VarArray;
    GraphLayer: TBitmap;  // Speichert das Bild im Hintergrund
    GraphBackground: TBitmap;
    GraphLeft: integer;
    GraphTop: integer;
    ColorBackground: TColor;
    ColorRaster: TColor;
    ColorLine: Tcolor;
    Margin: integer;
    MinValue: integer;
    MaxValue: integer;
    CanId: longword;
    FrameFormat: Integer;
    CanFd: Integer;
    MuxEnable: boolean;
    MuxDlc: Byte;
    MuxCanMask: array[0..7] of Byte;
    MuxCanData: array[0..7] of Byte;
    procedure CreateBackground();
    function CheckFrame(can_msg: PCanFdMsg): boolean;
  public
    { Public-Deklarationen }   
    procedure RxCanMessages(can_msg: PCanFdMsg; count: Integer); override;
    procedure RxCanUpdate; override;
    function ExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer; override;
    procedure LoadConfig(ConfigList: TStrings); override;
    procedure SaveConfig(ConfigList: TStrings); override;
  end;

implementation

uses CanGraphSetupForm;

{$R *.dfm}

procedure TCanGraphWin.FormCreate(Sender: TObject);
var i: integer;

begin
inherited;
CommandMask := SYS_COMMAND or RX_WIN_COMMAND;
BerechnungsObj := TIntTerm.Create;
GraphBackground := TBitmap.Create;
GraphLayer := TBitmap.Create;
GraphValuesCount := 0;
GraphValuesLimit := GraphValuesCapacity;
MinValue := 0;
MaxValue := 10000;
SetLength(Varis, 64);
for i := 0 to high(Varis) do
begin
  Varis[i].Name := format('d%u',[i]);
  Varis[i].Wert := 0;
end;
ColorBackground := rgb(10,50,10);
ColorRaster := rgb(10,65,10);
ColorLine := rgb(220,200,10);
Margin := 5;
GraphLayer.Width := 500;
GraphLayer.Height := 250;
GraphFrame.Left := Margin;
GraphFrame.Top := Margin;
GraphFrame.Width := GraphLayer.Width + 2;
GraphFrame.Height := GraphLayer.Height + 2;
GraphLeft := GraphFrame.Left + 1;
GraphTop := GraphFrame.Top + 1;
self.ClientWidth := GraphLayer.Width + (2 * Margin) + 2;
self.ClientHeight := GraphTop + GraphLayer.Height + Margin + 2;
BerechnungsTerm := '(d0 << 8) + d1';
CreateBackground;
end;


procedure TCanGraphWin.FormDestroy(Sender: TObject);
begin
  inherited;
  GraphLayer.Free;
  GraphBackground.Free;
end;

procedure TCanGraphWin.FormPaint(Sender: TObject);
var i: integer;
    Offset: integer;
    
begin
inherited;

BitBlt(GraphLayer.Canvas.Handle, 0, 0, GraphLayer.Width, GraphLayer.Height,
      GraphBackground.Canvas.Handle, (GraphValuesCount mod 10), 0, SRCCOPY);
GraphLayer.Canvas.Pen.Color := ColorLine;
Offset := GraphValuesCount - GraphLayer.Width;
i := 0;
while (i < GraphLayer.Width) do
  begin
  if (Offset + i) > 0 then
    begin
    GraphLayer.Canvas.MoveTo(i - 1, (GraphLayer.Height - 1) -
          round((GraphValues[Offset + i - 1] - MinValue) *
          (GraphLayer.Height / (MaxValue - MinValue))));
    GraphLayer.Canvas.LineTo(i, (GraphLayer.Height - 1) -
          round((GraphValues[Offset + i] - MinValue) *
          (GraphLayer.Height / (MaxValue - MinValue))));
    end;
  inc(i);
  end;
BitBlt(self.Canvas.Handle, GraphLeft, GraphTop, GraphLayer.Width, GraphLayer.Height,
      GraphLayer.Canvas.Handle, 0, 0, SRCCOPY);
end;


procedure TCanGraphWin.CreateBackground;
var i: integer;

begin
GraphBackground.Width := GraphLayer.Width + 10;
GraphBackground.Height := GraphLayer.Height;
GraphBackground.Canvas.Pen.Color := ColorBackground;
GraphBackground.Canvas.Brush.Color := ColorBackground;
GraphBackground.Canvas.Rectangle(0, 0, GraphBackground.Width, GraphBackground.Height);
GraphBackground.Canvas.Pen.Color := ColorRaster;
i := 0;
while (i < GraphBackground.Width) do
  begin
  if ((GraphBackground.Width + 1 + i) mod 10 ) = 0 then
    begin
    GraphBackground.Canvas.MoveTo(i, 0);
    GraphBackground.Canvas.LineTo(i, GraphBackground.Height - 1);
    end;
  inc(i);
  end;
i := 0;
while (i < GraphBackground.Height) do
  begin
  GraphBackground.Canvas.MoveTo(0, i);
  GraphBackground.Canvas.LineTo(GraphBackground.Width - 1, i);
  inc(i, 10);
  end;
end;

{
procedure TCanGraphWin.SpeichernBtnClick(Sender: TObject);
var
  i: integer;
  Datei: TextFile;
begin
  TMainWin(owner).SaveDialog.Title := 'Daten-Log speichern';
  TMainWin(owner).SaveDialog.DefaultExt := 'csv';
  if Dateiname = '' then
    TMainWin(Owner).SaveDialog.FileName := self.Caption + '.csv'
  else
    TMainWin(Owner).SaveDialog.FileName := Dateiname;
  TMainWin(owner).SaveDialog.Filter := 'Daten-Log (*.csv)|*.csv|Alle Dateien (*.*)|*.*';

  if TMainWin(owner).SaveDialog.Execute then
  begin
    Dateiname := TMainWin(owner).SaveDialog.FileName;
    try
      AssignFile(Datei, TMainWin(owner).SaveDialog.FileName);
      Rewrite(Datei);
      Writeln(Datei, 'Zeitstempel;Datenwert');
      for i:=0 to GraphValuesCount-1 do
        Writeln(Datei, format('%u;%u', [GraphValues[i]]));
    finally
      CloseFile(Datei);
    end;
  end;
end;   }

function TCanGraphWin.CheckFrame(can_msg: PCanFdMsg): boolean;
var idx : Integer;
    eff, fd, brs: Boolean;

begin
result := TRUE;
if (can_msg^.ID <> CanId) or ((can_msg^.Flags and FlagCanFdRTR) > 0) then
  begin
  result := FALSE;
  exit;
  end;
if (can_msg^.Flags and FlagCanFdEFF) > 0 then
  eff := True
else
  eff := False;
if (can_msg^.Flags and FlagCanFdFD) > 0 then
  fd := True
else  
  fd := False;
if (can_msg^.Flags and FlagCanFdBRS) > 0 then
  brs := True
else
  brs := False;
{ 0 = Alle Frames
  1 = Std.-Frames
  2 = Ext.-Frames }
if FrameFormat > 0 then
  begin;  
  if FrameFormat = 2 then // nur EFF Frames
    begin;
    if not eff then
      result := FALSE;
    end
  else
    begin;  // nur Std.-Frames
    if eff then 
      result := FALSE;
    end;  
  end;
{ 0 = Alle Frames
  1 = Nur Classical Frames
  2 = Nur CAN-FD Frames
  3 = Nur CAN-FD Frames (BRS unset)
  4 = Nur CAN-FD Frames (BRS set) }
if CanFd > 0 then
  begin;
  if CanFd = 1 then
    begin;
    if fd then
      result := FALSE;
    end
  else if CanFd = 2 then
    begin;
    if not fd then
      result := FALSE;
    end
  else if CanFd = 3 then
    begin;
    if not (fd and not brs) then
      result := FALSE;
    end
  else if CanFd = 4 then
    begin;
    if not (fd and brs) then
      result := FALSE;
    end;  
  end;  
if not result then
  exit;  
if MuxEnable and (MuxDlc > 0) then
  begin;
  if can_msg^.Length <> MuxDlc then
    result := FALSE
  else
    begin;
    for idx := 0 to MuxDlc - 1 do
      begin;
      if ((can_msg^.Data.Bytes[idx] xor MuxCanData[idx]) and MuxCanMask[idx]) <> 0 then
        begin;
        result := FALSE;
        break;
        end;
      end;
    end;      
  end;     
end;


procedure TCanGraphWin.RxCanMessages(can_msg: PCanFdMsg; count: Integer);
var i, ii: Integer;

begin
if (not MainWin.EnableTrace) or (count = 0) then
  exit;
for i := 1 to count do
  begin;
  if CheckFrame(can_msg) then
    begin;
    can_msg^.Flags := can_msg^.Flags or FlagCanFdFilHit;
    for ii := 0 to high(Varis) do
      Varis[ii].Wert := can_msg^.Data.Bytes[ii];
    try
      GraphValues[GraphValuesCount] := round(BerechnungsObj.TermLoesen(BerechnungsTerm, @Varis));
      inc(GraphValuesCount);
      if GraphValuesCount = GraphValuesLimit then
        GraphValuesCount := 0;
    except
      WidgetAktiv := false;
      end;
    end;
  inc(can_msg);
  end;
end;


procedure TCanGraphWin.RxCanUpdate;

begin;
self.Paint;
{ <*>
MessageDlg('Im Berechnungs Term ist ein Fehler aufgetretten:'+#13+#10+
  BerechnungsObj.GetFehlerText, mtError, [mbOk], 0);}
end;


function TCanGraphWin.ExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer;

begin;
result := 0;
case cmd of
  //SYS_CMD_SET_SETUP  : SetSetup;                       
  RX_WIN_CLEAR       : begin;
                       GraphValuesCount := 0;
                       self.Paint;
                       end;
  RX_WIN_SAVE_TRACE  : begin;
                       if self.Active then
                         begin;                         
                         end;  
                       end;
  {RX_WIN_START_TRACE : EnableTrace := True; <*>
  RX_WIN_STOP_TRACE  : EnableTrace := False; }
  end;
end;


procedure TCanGraphWin.ConfigBtnClick(Sender: TObject);
var Form: TCanGraphSetupWin;

begin
EventsLock;
Form := TCanGraphSetupWin.Create(self);
Form.BerechnungsTermEdit.Text := BerechnungsTerm;
Form.MinValueEdit.Number := MinValue;
Form.MaxValueEdit.Number := MaxValue;
Form.GraphValuesLimitEdit.Number := GraphValuesLimit;
Form.NameEdit.Text := self.Caption;
Form.CanIdEdit.Number := CanId;
Form.FrameFormatEdit.ItemIndex := FrameFormat;
Form.CanFdEdit.ItemIndex := CanFd;
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
if Form.ShowModal = mrOK then
  begin
  self.Caption := Form.NameEdit.Text;
  BerechnungsTerm := Form.BerechnungsTermEdit.Text;
  MinValue := Form.MinValueEdit.Number;
  MaxValue := Form.MaxValueEdit.Number;
  GraphValuesLimit := Form.GraphValuesLimitEdit.Number;
  if GraphValuesLimit > GraphValuesCapacity then
    GraphValuesLimit := GraphValuesCapacity;
  CanId := Form.CanIdEdit.Number;
  FrameFormat := Form.FrameFormatEdit.ItemIndex;
  CanFd := Form.CanFdEdit.ItemIndex;
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
  WindowMenuItem.Caption :=  self.Caption;
  end;
Form.Free;
EventsUnlock;
end;


procedure TCanGraphWin.LoadConfig(ConfigList: TStrings);

begin
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
BerechnungsTerm := ReadListString(ConfigList, 'Formula', BerechnungsTerm);
MinValue := ReadListInteger(ConfigList, 'MinValue', 0); 
MaxValue := ReadListInteger(ConfigList, 'MaxValue', 0); 
GraphValuesLimit := ReadListInteger(ConfigList, 'GraphValuesLimit', 0); 
CreateBackground;
self.Paint;
end;


procedure TCanGraphWin.SaveConfig(ConfigList: TStrings);

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
ConfigList.Append(format('Formula=%s', [BerechnungsTerm]));
ConfigList.Append(format('MinValue=%d', [MinValue]));
ConfigList.Append(format('MaxValue=%d', [MaxValue]));
ConfigList.Append(format('GraphValuesLimit=%d', [GraphValuesLimit]));
end;


procedure TCanGraphWin.AktivBtnClick(Sender: TObject);

begin
WidgetAktiv := AktivBtn.Checked;
end;


procedure TCanGraphWin.DestroyBtnClick(Sender: TObject);

begin
close;
end;

end.
