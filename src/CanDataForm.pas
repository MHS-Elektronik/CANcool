{***************************************************************************
                       CanDataForm.pas  -  description
                             -------------------
    begin             : 24.12.2021
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
unit CanDataForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, StrUtils, Util, CanCoolDefs,
  CanRxPrototyp, CanRx, setup, TinyCanDrv, ComCtrls, Menus, MainForm;




type
  TRxMsgShowMode = (RxMsgShowAll, RxMsgShowUsed, RxMsgShowUnused);

  TCanDataWin = class(TCanRxPrototypForm)
    RxView: TStringGrid;
    SaveDialog: TSaveDialog;
    CanDataMenu: TPopupMenu;
    ConfigBtn: TMenuItem;
    AktivBtn: TMenuItem;
    N1: TMenuItem;
    DestroyBtn: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RxViewDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure ConfigBtnClick(Sender: TObject);
    procedure AktivBtnClick(Sender: TObject);
    procedure DestroyBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }    
    LineHeight: Integer;
    procedure SetDataView;
    procedure SetSetup;
    function CheckFrame(can_msg: PCanFdMsg): boolean;
  public
    { Public-Deklarationen }
    RxList: TRxCanList;
    TraceFile: String;
    MsgHitDisable: Boolean;
    IdMode: Integer; 
    CanIdStart: longword;
    CanMaskEnd: longword;
    FrameFormat: Integer;
    CanFd: Integer;
    MuxEnable: boolean;
    MuxDlc: Byte;
    MuxCanMask: array[0..7] of Byte;
    MuxCanData: array[0..7] of Byte;    
    procedure RxCanMessages(can_msg: PCanFdMsg; count: Integer); override;
    procedure RxCanUpdate; override;
    function ExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer; override;
    procedure LoadConfig(ConfigList: TStrings); override;
    procedure SaveConfig(ConfigList: TStrings); override;
  end;

implementation

uses CanDataSetupForm;

{$R *.dfm}

{ TEmpfangForm }


procedure TCanDataWin.SetSetup;
begin;
RxView.Font.Name := SetupData.TraceFont.Name;
RxView.Font.Size := SetupData.TraceFont.Size;
RxView.Font.Style := SetupData.TraceFont.Style;
SetDataView;
end;


procedure TCanDataWin.SetDataView;
var i, col_cnt, col, row_cnt, h, w, h_max, w_max: Integer;
    rect: TRect;
    s: String;

begin;
row_cnt := RxList.Count + 1;
col_cnt := 6;
if row_cnt < 2 then
  row_cnt := 2;
RxView.RowCount := row_cnt;
RxView.ColCount := col_cnt; 
h_max := 1;
RxView.Canvas.Font.Assign(RxView.Font);
for col := 0 to col_cnt - 1 do
  begin;  
  w_max := 1;        
  for i := 0 to 1 do
    begin;      
    s := RxviewCanTraceHeaders[col, i];
    if i = 0 then
      RxView.Cells[col,0] := s;
    DrawText(RxView.Canvas.Handle, PChar(s), length(s), rect, DT_CalcRect or DT_Left);
    w := rect.Right - rect.Left;  // Breite
    h := rect.Bottom - rect.Top;   // Höhe
    if w_max < w then
      w_max := w;
    if h_max < h then
      h_max := h;            
    end;
  RxView.ColWidths[col] := w_max + 5;  
  end;
RxView.RowHeights[0] := h_max + 4;
LineHeight := h_max;  
RxView.Refresh;
end;


procedure TCanDataWin.FormCreate(Sender: TObject);

begin
inherited;
CommandMask := SYS_COMMAND or RX_WIN_COMMAND;
RxList := TRxCanList.Create(self);
TraceFile := '';
SetSetup;
//SetDataView;  <*>
end;


procedure TCanDataWin.FormDestroy(Sender: TObject);

begin
if Assigned(RxList) then
  FreeAndNil(RxList);
inherited;
end;


procedure TCanDataWin.RxViewDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var can_msg: PCanFdMsg;
    msg_buf: TCanFdMsg;
    str: string;
    out_rect: TRect;
    d, err_nr, bus_stat: Byte;
    dlc, i, y, data_lines, char_cnt: integer;
    rtr, eff, fd, brs: boolean;
    ofs, timestamp, s, ms, lost_msgs: DWord;

begin
if ARow = 0 then
  exit;
RxView.Canvas.Brush.Color := RxView.Color;
RxView.Canvas.Font.Color := SetupData.TraceDefColor;
if gdFocused in State then
  RxView.Canvas.Brush.Color := clActiveCaption
else if gdFixed in State then
  RxView.Canvas.Brush.Color := RxView.FixedColor;
RxView.Canvas.FillRect(Rect);
str := '';
if RxList.ReadCanMsg(ARow-1, msg_buf) < 0 then
  begin;
  RxView.Canvas.TextOut(Rect.Left+1, Rect.Top+2, str);
  exit;
  end;  
can_msg := @msg_buf;  
ofs := (RxList.FirstTime.USec div 1000) + (RxList.FirstTime.Sec * 1000);
timestamp := (can_msg^.Time.USec div 1000) + (can_msg^.Time.Sec * 1000) - ofs;

// **** OV Frame anzeigen
if (can_msg^.Flags and FlagCanFdOV) > 0 then
  begin
  RxView.Canvas.Font.Color := SetupData.TraceStatusColor; 
  case ACol of       
    0 : begin;
        s := timestamp div 1000;            // Timestamp
        ms := timestamp mod 1000;
        str := format('%6u.%.3u', [s,ms]);
        end;
    1 : str := 'OV';                        // Frame Format
    2 : str := '';                          // ID
    3 : str := '';                          // DLC
    4 : begin;                              // Daten (Hex)
        err_nr := can_msg^.Data.Bytes[0];
        lost_msgs := can_msg^.Data.Bytes[1] and (can_msg^.Data.Bytes[2] shl $08);
        if (err_nr > 0) and (err_nr < 4) then
          str := format('[%u] Messages-Lost: %u', [err_nr, lost_msgs])
        else
          str := 'Unbek. Fehler';
        end;
    5 : str := '';                          // Daten (ASCII)      
    end;
  RxView.RowHeights[ARow] := LineHeight;
  RxView.Canvas.TextOut(Rect.Left+1, Rect.Top+2, str);
  exit;
  end;  
// **** Fehler anzeigen
if (can_msg^.Flags and FlagCanFdError) > 0 then
  begin;  // Fehler
  RxView.Canvas.Font.Color := SetupData.TraceErrorColor;
  case ACol of
    0 : begin;
        s := timestamp div 1000;            // Timestamp
        ms := timestamp mod 1000;
        str := format('%6u.%.3u', [s,ms]);
        end;    
    1 : str := 'ERROR';                     // Frame Format
    2 : str := '';                          // ID
    3 : str := '';                          // DLC
    4 : begin;                              // Daten (Hex)
        err_nr := can_msg^.Data.Bytes[0];
        bus_stat := can_msg^.Data.Bytes[1] and $0F;
        if (err_nr > 0) and (err_nr < 7) and (bus_stat < 4) then
          str := format('[%s] %s', [CanBusStatusStr[bus_stat], CanErrorsStr[err_nr]])
        else
          str := 'Unbek. Fehler';
        end;
    5 : begin;
        if (can_msg^.Data.Bytes[1] and $10) = $10 then
          str := 'BUS-FAILURE'
        else
          str := '';                          // Daten (ASCII)
        end;
    end;
  RxView.RowHeights[ARow] := LineHeight;
  RxView.Canvas.TextOut(Rect.Left+1, Rect.Top+2, str);
  exit;
  end;
dlc := can_msg^.Length;
if (can_msg^.Flags and FlagCanFdEFF) > 0 then
  eff := True
else
  eff := False;
if (can_msg^.Flags and FlagCanFdRTR) > 0 then
  rtr := True
else
  rtr := False;
if (can_msg^.Flags and FlagCanFdFD) > 0 then
  fd := True
else  
  fd := False;
if (can_msg^.Flags and FlagCanFdBRS) > 0 then
  brs := True
else
  brs := False;  
// Zellenhöhe bestimmen
if rtr or (dlc = 0) then
  data_lines := 1
else
  begin;
  data_lines := dlc div 8; 
  if (dlc mod 8) > 0 then
    inc(data_lines); 
  end;
          
y := (LineHeight * data_lines) + 4;  
RxView.RowHeights[ARow] := y;
out_rect.Left := Rect.Left + 1;
out_rect.Top := Rect.Top + 2;
out_rect.Bottom := Rect.Top + y;
out_rect.Right := Rect.Right;
   
case ACol of
  0 : begin        // Timestamp
      s := timestamp div 1000;
      ms := timestamp mod 1000;
      str := format('%6u.%.3u', [s,ms]);    
      end;
  1 : begin;                         // Frame Format
      if rtr and eff then
        str := 'EFF/RTR'
      else if eff then
        str := 'EFF'
      else if rtr then
        str := 'STD/RTR'
      else
        str := 'STD';
      if fd and brs then
        str := str + ' FD/BRS'
      else if fd then
        str := str + ' FD';
      end;
  2 : begin;
      if eff then
        str := Format('%08X',[can_msg^.ID])   // ID
      else
        str := Format('%04X',[can_msg^.ID]);  // ID
      end;
  3 : str := format('%u',[dlc]);     // DLC
  4 : begin;                          // Daten (Hex)
      if (dlc > 0) and not rtr then
        begin;    
        char_cnt := 0;
        for i := 0 to dlc - 1 do
          begin;
          d := can_msg^.Data.Bytes[i];
          if char_cnt > 0 then          
            str := str + ' ';                    
          if char_cnt = 8 then
            begin;
            str := str + chr($0D) + chr($0A);          
            char_cnt := 0;
            end;  
          str := str + HexDigits[d SHR $04] + HexDigits[d AND $0F];        
          inc(char_cnt);
          end;
        end
      else
        str := '';
      end;
  5 : begin;       // Daten (ASCII)
      if (dlc > 0) and not rtr then
        begin;        
        char_cnt := 0;
        for i := 0 to dlc-1 do
          begin;   
          if char_cnt = 8 then
            begin;
            str := str + chr($0D) + chr($0A);
            char_cnt := 0;
            end;
          d := can_msg^.Data.Bytes[i];
          if chr(d) in [chr(32)..chr(126)] then
            str := str + chr(d)
          else
            str := str + '.';
          inc(char_cnt);
          end;        
        end
      else
        str := '';
      end;
  end;
DrawText(RxView.Canvas.Handle, PChar(str), length(str), out_rect, DT_Left);
end;


function TCanDataWin.CheckFrame(can_msg: PCanFdMsg): boolean;
var id: Longword;
    idx : Integer;
    eff, fd, brs: Boolean;

begin
result := TRUE;
if (can_msg^.Flags and FlagCanFdRTR) > 0 then
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
id := can_msg^.ID;
case IdMode of
  0 : begin;  // Single ID
      if id <> CanIdStart then
        result := FALSE;
      end;
  1 : begin;  // Start - Stop
      if (id < CanIdStart) or (id > CanMaskEnd) then
        result := FALSE;
      end;
  2 : begin;  // ID / Mask
      if (id and CanMaskEnd) <> (CanIdStart and CanMaskEnd) then
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


procedure TCanDataWin.RxCanMessages(can_msg: PCanFdMsg; count: Integer);
var i: Integer;

begin
if (not MainWin.EnableTrace) or (count = 0) then
  exit;
for i := 1 to count do
  begin;
  if CheckFrame(can_msg) then
    begin;
    if not MsgHitDisable then
      can_msg^.Flags := can_msg^.Flags or FlagCanFdFilHit;
    RxList.Add(can_msg);
    end;
  inc(can_msg);
  end;
end;


procedure TCanDataWin.RxCanUpdate;
var cnt: Integer;

begin
if not MainWin.EnableTrace then
  exit;
cnt := RxList.Count + 1;  
if cnt < 2 then
  cnt := 2;
if RxView.RowCount <> cnt then
  begin;
  RxView.RowCount := cnt;
  RxView.Row := cnt - 1;
  end;
RxView.Refresh;
end;


function TCanDataWin.ExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer;

begin
result := 0;
case cmd of
  SYS_CMD_SET_SETUP  : SetSetup;                       
  RX_WIN_CLEAR       : begin;
                       RxList.Clear;                       
                       RxView.RowCount := 2;
                       RxView.Refresh;
                       end;
  RX_WIN_SAVE_TRACE  : begin;
                       if self.Active then
                         begin;
                         if RxList.Count = 0 then
                           begin;
                           MessageDlg('Keine Daten zum Speichern!', mtError, [mbOk], 0);
                           exit;
                           end;                         
                         SaveDialog.Title := self.Caption;
                         if length(TraceFile) > 0 then
                           SaveDialog.FileName := TraceFile
                         else
                           SaveDialog.FileName := SaveDialog.Title;
                         if SaveDialog.Execute then
                           begin;
                           TraceFile := SaveDialog.FileName;
                           if length(TraceFile) > 0 then
                             RxList.SaveToFile(TraceFile);
                           end;
                         end;  
                       end;
  {RX_WIN_START_TRACE : EnableTrace := True; <*>
  RX_WIN_STOP_TRACE  : EnableTrace := False; }
  end;
end;


procedure TCanDataWin.ConfigBtnClick(Sender: TObject);
var
  Form: TCanDataSetupWin;

begin
EventsLock;
Form := TCanDataSetupWin.Create(self);

Form.NameEdit.Text := self.Caption;
Form.IdModeEdit.ItemIndex := IdMode;     
Form.CanIdStartEdit.Number := CanIdStart; 
Form.CanMaskEndEdit.Number := CanMaskEnd; 
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
Form.MsgHitDisableBox.Checked := MsgHitDisable;
if Form.ShowModal = mrOK then
  begin
  self.Caption := Form.NameEdit.Text;
  IdMode := Form.IdModeEdit.ItemIndex;
  CanIdStart := Form.CanIdStartEdit.Number;
  CanMaskEnd := Form.CanMaskEndEdit.Number;
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
  MsgHitDisable := Form.MsgHitDisableBox.Checked;
  WindowMenuItem.Caption :=  self.Caption;
  end;
Form.Free;
EventsUnlock;
end;


procedure TCanDataWin.LoadConfig(ConfigList: TStrings);

begin
EventsLock;
self.Caption := ReadListString(ConfigList, 'Name', self.Caption);
if ReadListInteger(ConfigList, 'MsgHitDisable', 0) > 0 then 
  MsgHitDisable := TRUE
else
  MsgHitDisable := FALSE;
IdMode := ReadListInteger(ConfigList, 'IdMode', 0); 
CanIdStart := ReadListInteger(ConfigList, 'CanIdStart', 0);
CanMaskEnd := ReadListInteger(ConfigList, 'CanMaskEnd', 0);
FrameFormat := ReadListInteger(ConfigList, 'FrameFormat', 0);
CanFd := ReadListInteger(ConfigList, 'CanFd', 0);
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
WindowMenuItem.Caption :=  self.Caption;
EventsUnlock;
end;


procedure TCanDataWin.SaveConfig(ConfigList: TStrings);

begin
ConfigList.Append(format('Name=%s', [self.Caption]));
if MsgHitDisable then
  ConfigList.Append('MsgHitDisable=1')
else
  ConfigList.Append('MsgHitDisable=0');
ConfigList.Append(format('IdMode=%u', [IdMode]));
ConfigList.Append(format('CanIdStart=%u', [CanIdStart]));
ConfigList.Append(format('CanMaskEnd=%u', [CanMaskEnd]));
ConfigList.Append(format('FrameFormat=%u', [FrameFormat]));
ConfigList.Append(format('CanFd=%u', [CanFd]));
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
end;


procedure TCanDataWin.AktivBtnClick(Sender: TObject);

begin
WidgetAktiv := AktivBtn.Checked;
end;


procedure TCanDataWin.DestroyBtnClick(Sender: TObject);

begin
close;
end;


end.

