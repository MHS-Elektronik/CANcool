{***************************************************************************
                       CanFdTxForm.pas  -  description
                             -------------------
    begin             : 07.01.2013
    last modified     : 13.10.2022
    copyright         : (C) 2013 - 2022 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit CanFdTxForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, Buttons, StrUtils, Menus, mmsystem, CanCoolDefs,
  util, TinyCanDrv, zahlen32, zahlen, CanRxPrototyp, Setup, CanRx, CanTx;

type
  TCanFdTxWin = class(TCanRxPrototypForm)
    TxView: TStringGrid;
    KopfPanel: TPanel;
    MsgAddBtn: TBitBtn;
    MsgDelBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DataEdit0: TZahlenEdit;
    DataEdit1: TZahlenEdit;
    DataEdit2: TZahlenEdit;
    DataEdit3: TZahlenEdit;
    DataEdit7: TZahlenEdit;
    DataEdit4: TZahlenEdit;
    DataEdit5: TZahlenEdit;
    DataEdit6: TZahlenEdit;
    CanFormatGroupBox: TGroupBox;
    RTRCheck: TCheckBox;
    EFFCheck: TCheckBox;
    IDEdit: TZahlen32Edit;
    Label4: TLabel;
    Label5: TLabel;
    CommentEdit: TEdit;
    TxModeCombo: TComboBox;
    TriggerIdEdit: TZahlen32Edit;
    Label6: TLabel;
    Label7: TLabel;
    IntervallEdit: TZahlen32Edit;
    MsgTxBtn: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    MsgCopyBtn: TBitBtn;
    CanFdCheck: TCheckBox;
    CanFdBrsCheck: TCheckBox;
    DataEdit8: TZahlenEdit;
    DataEdit9: TZahlenEdit;
    DataEdit10: TZahlenEdit;
    DataEdit11: TZahlenEdit;
    DataEdit15: TZahlenEdit;
    DataEdit12: TZahlenEdit;
    DataEdit13: TZahlenEdit;
    DataEdit14: TZahlenEdit;
    DataEdit16: TZahlenEdit;
    DataEdit17: TZahlenEdit;
    DataEdit18: TZahlenEdit;
    DataEdit19: TZahlenEdit;
    DataEdit23: TZahlenEdit;
    DataEdit20: TZahlenEdit;
    DataEdit21: TZahlenEdit;
    DataEdit22: TZahlenEdit;
    DataEdit24: TZahlenEdit;
    DataEdit25: TZahlenEdit;
    DataEdit26: TZahlenEdit;
    DataEdit27: TZahlenEdit;
    DataEdit31: TZahlenEdit;
    DataEdit28: TZahlenEdit;
    DataEdit29: TZahlenEdit;
    DataEdit30: TZahlenEdit;
    DataEdit32: TZahlenEdit;
    DataEdit33: TZahlenEdit;
    DataEdit34: TZahlenEdit;
    DataEdit35: TZahlenEdit;
    DataEdit39: TZahlenEdit;
    DataEdit36: TZahlenEdit;
    DataEdit37: TZahlenEdit;
    DataEdit38: TZahlenEdit;
    DataEdit40: TZahlenEdit;
    DataEdit41: TZahlenEdit;
    DataEdit42: TZahlenEdit;
    DataEdit43: TZahlenEdit;
    DataEdit47: TZahlenEdit;
    DataEdit44: TZahlenEdit;
    DataEdit45: TZahlenEdit;
    DataEdit46: TZahlenEdit;
    DataEdit48: TZahlenEdit;
    DataEdit49: TZahlenEdit;
    DataEdit50: TZahlenEdit;
    DataEdit51: TZahlenEdit;
    DataEdit55: TZahlenEdit;
    DataEdit52: TZahlenEdit;
    DataEdit53: TZahlenEdit;
    DataEdit54: TZahlenEdit;
    DataEdit56: TZahlenEdit;
    DataEdit57: TZahlenEdit;
    DataEdit58: TZahlenEdit;
    DataEdit59: TZahlenEdit;
    DataEdit63: TZahlenEdit;
    DataEdit60: TZahlenEdit;
    DataEdit61: TZahlenEdit;
    DataEdit62: TZahlenEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label8: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    DLCEdit: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure MsgAddBtnClick(Sender: TObject);
    procedure MsgDelBtnClick(Sender: TObject);
    procedure TxViewDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure TxViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TxViewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MsgTxBtnClick(Sender: TObject);
    procedure MsgCopyBtnClick(Sender: TObject);
    procedure TxViewClick(Sender: TObject);
  private
    { Private-Deklarationen }
    LineHeight: Integer;
    PressedBtn: integer;
    CanDataEdit: array[0..63] of TZahlenEdit;
    TxList: TTxCanList;
    procedure UpdateUi;
    procedure UpdateTitle;
    procedure SetupTxView;
    procedure GetMsgFromUi(can_msg: PTxCanMsg);
    procedure SetMsgToUi(can_msg: PTxCanMsg);
    procedure DisableTxEditEvents;
    procedure EnableTxEditEvents;
    procedure TxEditChange(sender: TObject);
    procedure TxEditOnChange(Sender: TObject);
    procedure TxEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    { Public-Deklarationen }
    procedure SetTxList(tx_list: TTxCanList);
    procedure RxCanMessages(can_msg: PCanFdMsg; count: Integer); override;
    procedure RxCanUpdate; override;    
    function ExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer; override;
  end;


implementation

uses MainForm;

{$R *.dfm}

{ TSendenForm }


procedure TCanFdTxWin.FormCreate(Sender: TObject);
var i: Integer;
    obj: TComponent;

begin
inherited;
CommandMask := SYS_COMMAND or TX_WIN_COMMAND;
for i := 0 to 63 do
  begin;
  obj := FindComponent('DataEdit' + IntToStr(i));
  if obj is TZahlenEdit then 
    CanDataEdit[i] := TZahlenEdit(obj); 
  end;
TMainWin(owner).ButtonImages.GetBitmap(2, MsgAddBtn.Glyph);
TMainWin(owner).ButtonImages.GetBitmap(0, MsgCopyBtn.Glyph);
TMainWin(owner).ButtonImages.GetBitmap(6, MsgTxBtn.Glyph);
TMainWin(owner).ButtonImages.GetBitmap(3, MsgDelBtn.Glyph);
PressedBtn := 0;
TxList := nil;
SetupTxView;
EnableTxEditEvents;
end;


procedure TCanFdTxWin.SetTxList(tx_list: TTxCanList);

begin;
TxList := tx_list;
end;


procedure TCanFdTxWin.SetupTxView;
var i, col, h, w, h_max, w_max: Integer;
    rect: TRect;
    s: String;

begin;
TxView.ColCount := 9;
h_max := 1;
TxView.Canvas.Font.Assign(TxView.Font);
for col := 0 to 8 do
  begin;
  w_max := 1;
  for i := 0 to 1 do
    begin;
    s := TxViewHeaders[col, i];
    if i = 0 then
      TxView.Cells[col,0] := s;
    DrawText(TxView.Canvas.Handle, PChar(s), length(s), rect, DT_CalcRect or DT_Left);
    w := rect.Right - rect.Left;    // Breite
    h := rect.Bottom - rect.Top;    // Höhe
    if w_max < w then
      w_max := w;
    if h_max < h then
      h_max := h;
    end;
  TxView.ColWidths[col] := w_max + 5;
  end;
TxView.RowHeights[0] := h_max + 4;   
LineHeight := h_max;
TxView.Refresh;
end;





procedure TCanFdTxWin.UpdateUi;
var len: Byte;

begin;
DisableTxEditEvents;
len := CorrectCanFdLen(StrToInt(DLCEdit.Text));
DLCEdit.Text := IntToStr(len);
if len > 8 then
  CanFdCheck.Checked := True;
if not CanFdCheck.Checked then
   CanFdBrsCheck.Checked := False;
EnableTxEditEvents;
TxEditChange(CanFdCheck);
TxEditChange(DLCEdit);
end;


procedure TCanFdTxWin.GetMsgFromUi(can_msg: PTxCanMsg);
var i: Integer;
    len: Byte;

begin;
DisableTxEditEvents;

len := CorrectCanFdLen(StrToInt(DLCEdit.Text));
can_msg^.CanMsg.Length := len;
DLCEdit.Text := IntToStr(len);
if len > 8 then
  CanFdCheck.Checked := True;
if not CanFdCheck.Checked then
  CanFdBrsCheck.Checked := False;
can_msg^.CanMsg.Flags := 0;
if EFFCheck.Checked then
  can_msg^.CanMsg.Flags := can_msg^.CanMsg.Flags or FlagCanFdEFF;
if RTRCheck.Checked then
  can_msg^.CanMsg.Flags := can_msg^.CanMsg.Flags or FlagCanFdRTR;
if CanFdCheck.Checked then
  can_msg^.CanMsg.Flags := can_msg^.CanMsg.Flags or FlagCanFdFD;
if CanFdBrsCheck.Checked then
  can_msg^.CanMsg.Flags := can_msg^.CanMsg.Flags or FlagCanFdBRS;
can_msg^.CanMsg.ID:=IDEdit.Number;
can_msg^.TxMode := TxModeCombo.ItemIndex;   // 0 = Off, 1 = Periodic, 2 = RTR, 3 = Trigger
can_msg^.Intervall := IntervallEdit.Number;
can_msg^.TriggerId := TriggerIdEdit.Number;
can_msg^.Comment := CommentEdit.Text;
for i := 0 to 63 do
  can_msg^.CanMsg.Data.Bytes[i] := CanDataEdit[i].Number;
EnableTxEditEvents;
end;


procedure TCanFdTxWin.SetMsgToUi(can_msg: PTxCanMsg);
var len, i: integer;

begin;
DisableTxEditEvents;
if can_msg = nil then
  begin;
  DLCEdit.Text := '0';
  EFFCheck.Checked := False;
  RTRCheck.Checked := False;
  IDEdit.Number := 0;
  for i := 0 to 63 do
    CanDataEdit[i].Number := 0;
  TxModeCombo.ItemIndex := 0;
  IntervallEdit.Number := 0;
  TriggerIdEdit.Number := 0;
  CommentEdit.Text := '';
  end
else
  begin;
  len := can_msg^.CanMsg.Length;
  DLCEdit.Text := IntToStr(len);
  if (can_msg^.CanMsg.Flags and FlagCanFdEFF) > 0 then
    EFFCheck.Checked := True
  else
    EFFCheck.Checked := False;
  if (can_msg^.CanMsg.Flags and FlagCanFdRTR) > 0 then
    RTRCheck.Checked := True
  else
    RTRCheck.Checked := False;
  if (can_msg^.CanMsg.Flags and FlagCanFdFD) > 0 then  
    CanFdCheck.Checked := True
  else  
    CanFdCheck.Checked := False;
  if (can_msg^.CanMsg.Flags and FlagCanFdBRS) > 0 then
    CanFdBrsCheck.Checked := True
  else
    CanFdBrsCheck.Checked := False;  
  IDEdit.Number := can_msg^.CanMsg.ID;
  for i := 0 to 63 do
    begin;
    if i < len then
      CanDataEdit[i].Number := can_msg^.CanMsg.Data.Bytes[i]
    else  
      CanDataEdit[i].Number := 0;
    end;  
  TxModeCombo.ItemIndex := can_msg^.TxMode;   // 0 = Off, 1 = Periodic, 2 = RTR, 3 = Trigger
  IntervallEdit.Number := can_msg^.Intervall;
  TriggerIdEdit.Number := can_msg^.TriggerId;
  CommentEdit.Text := can_msg^.Comment;
  end;
EnableTxEditEvents;
end;


procedure TCanFdTxWin.MsgAddBtnClick(Sender: TObject);
var can_msg: TTxCanMsg;

begin
if TxList = nil then
  exit;
TxList.EmptyMessage(@can_msg);
TxList.Add(@can_msg);
TxView.RowCount := TxList.Count+1;
TxView.Row := TxView.RowCount - 1;
TxView.Refresh;
end;


procedure TCanFdTxWin.MsgCopyBtnClick(Sender: TObject);
var can_msg: TTxCanMsg;

begin
if TxList = nil then
  exit;
GetMsgFromUi(@can_msg);
TxList.Add(@can_msg);
TxView.RowCount := TxList.Count+1;
TxView.Row := TxView.RowCount - 1;
TxView.Refresh;
end;


procedure TCanFdTxWin.MsgDelBtnClick(Sender: TObject);

begin
if (TxList = nil) or (TxView.Row < 1) or (TxView.Row > TxList.Count) then
  exit;
TxList.Delete(TxView.Row-1);
if TxList.Count > 0 then
  TxView.RowCount := TxList.Count+1
else
  begin;
  TxView.RowCount := 2;
  TxView.Row := 1;
  end;
TxView.Refresh;
end;


procedure TCanFdTxWin.MsgTxBtnClick(Sender: TObject);
var can_msg: TTxCanMsg;

begin
if TxList = nil then
  exit;
if TxList.Count = 0 then
  begin;
  GetMsgFromUi(@can_msg);
  TxList.Add(@can_msg);
  TxView.RowCount := TxList.Count + 1;
  TxView.Row := TxView.RowCount - 1;
  TxView.Refresh;
  end
else
  UpdateUi;
if (TxView.Row <= TxList.Count) and (TxView.Row > 0) then
  TxList.Transmit(TxView.Row-1);
end;


procedure TCanFdTxWin.TxViewDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  can_msg: PTxCanMsg;
  str: string;
  d: Byte;
  out_rect: TRect;
  x, y, dlc, i, char_cnt, data_lines: integer;
  rtr, eff, fd, brs: boolean;

begin
if ARow = 0 then
  exit;
str := '';
TxView.Canvas.Brush.Color := TxView.Color;
TxView.Canvas.Font.Color := clWindowText;
if gdFixed in State then
  TxView.Canvas.Brush.Color := TxView.FixedColor
else if (ARow = TxView.Row) and (ACol <> 8) then  // or (gdFocused in State)
  begin
  TxView.Canvas.Brush.Color := clActiveCaption;
  TxView.Canvas.Font.Color := clCaptionText;
  end;
TxView.Canvas.FillRect(Rect);

if (TxList.Count = 0) then
  begin;
  TxView.Canvas.TextOut(Rect.Left+1, Rect.Top+2, '');
  exit;
  end;
can_msg := TxList[ARow-1];
if can_msg = nil then
  exit;
dlc := can_msg^.CanMsg.Length;
if (can_msg^.CanMsg.Flags and FlagCanFdEFF) > 0 then
  eff := True
else
  eff := False;
if (can_msg^.CanMsg.Flags and FlagCanFdRTR) > 0 then
  rtr := True
else
  rtr := False;
if (can_msg^.CanMsg.Flags and FlagCanFdFD) > 0 then
  fd := True
else
  fd := False;
if (can_msg^.CanMsg.Flags and FlagCanFdBRS) > 0 then
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
TxView.RowHeights[ARow] := y;
out_rect.Left := Rect.Left + 1;
out_rect.Top := Rect.Top + 2;
out_rect.Bottom := Rect.Top + y;
out_rect.Right := Rect.Right;  

case ACol of
  0 :  begin;                         // Frame Format
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
  1 :  begin;
       if eff then
         str := Format('%08X',[can_msg^.CanMsg.ID])   // ID
       else
         str := Format('%03X',[can_msg^.CanMsg.ID]);  // ID
       end;
  2 : str := format('%u',[dlc]);      // DLC
  3 : begin;                          // Daten (Hex)
      if (dlc > 0) and not rtr then
        begin;
        char_cnt := 0;
        for i := 0 to dlc - 1 do
          begin;
          d := can_msg^.CanMsg.Data.Bytes[i];
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
  4 : begin;    // Auto
      case can_msg^.TxMode of
        0 : str := 'Off';
        1 : str := 'Periodic';
        2 : str := 'RTR';
        3 : str := 'Trigger';
        end;
      end;
  5 : begin;
      str := format('%u',[can_msg^.Intervall])  // Intervall
      end;
  6 : begin;
      if can_msg^.TxMode = 3 then
        begin;
        if eff then
          str := Format('%08X',[can_msg^.TriggerId]) // Trigger ID
        else
          str := format('%03X',[can_msg^.TriggerId]) // Trigger ID
        end
      else
        str := '';
      end;
  7 : str := can_msg.Comment;  // Comment
  8 : begin       // Senden
      with TxView.Canvas do
        begin
        Brush.Color := clBtnFace;
        FillRect(Rect);
        if (PressedBtn <> ARow) then
          Pen.Color := clBtnHighlight
        else
          Pen.Color := clBtnShadow;
        MoveTo(Rect.Left, Rect.Bottom-1);
        LineTo(Rect.Left, Rect.Top);
        LineTo(Rect.Right-1, Rect.Top);
        if (PressedBtn <> ARow) then
          Pen.Color := clBtnShadow
        else
          Pen.Color := clBtnHighlight;
        LineTo(Rect.Right-1, Rect.Bottom-1);
        LineTo(Rect.Left, Rect.Bottom-1);
        str := 'Senden';
        Font.Color := clBtnText;
        x := (TxView.ColWidths[ACol] - TextWidth(str)) div 2;
        y := (TxView.DefaultRowHeight - TextHeight(str)) div 2;
        if (PressedBtn = ARow) then
          begin
          inc(x);
          inc(y);
          end;
        TextOut(Rect.Left+x, Rect.Top+y, str);
        end;
      end;
  end;
if ACol <> 8 then
  DrawText(TxView.Canvas.Handle, PChar(str), length(str), out_rect, DT_Left);
  //TxView.Canvas.TextOut(Rect.Left+1, Rect.Top+2, str);
if (ACol = TxView.Col) and (ARow = TxView.Row) and (ACol <> 8) then
  TxView.Canvas.DrawFocusRect(Rect);
end;


procedure TCanFdTxWin.TxViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
ACol, ARow: integer;

begin
TxView.MouseToCell(X, Y, ACol, ARow);
if ACol = 8 then       // Senden Schaltfläche
  PressedBtn := ARow;
end;


procedure TCanFdTxWin.TxViewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
ACol, ARow: integer;
//Key: char;

begin
TxView.MouseToCell(X, Y, ACol, ARow);
if (Button <> mbLeft) then
  Exit;
PressedBtn := 0;
if TxView.Col = 8 then    // Senden Schaltfläche
  begin
  TxViewDrawCell(Sender, TxView.Col, TxView.Row, TxView.CellRect(TxView.Col, TxView.Row), []);
  if (ACol = TxView.Col) and (ARow = TxView.Row) then
    if (ARow <= TxList.Count) and (ARow > 0) then
      TxList.Transmit(ARow-1);
  exit;
  end;
end;


procedure TCanFdTxWin.RxCanMessages(can_msg: PCanFdMsg; count: Integer);
var i: Integer;

begin;
if (count = 0) or (TxList = nil) then
  exit;
for i := 1 to count do
  begin;  
  TxList.RxMessage(can_msg);
  inc(can_msg);
  end;
end;


procedure TCanFdTxWin.RxCanUpdate;
begin
  ;
end;


procedure TCanFdTxWin.UpdateTitle;

begin;
if SetupData.TxListFile = '' then
  self.Caption := 'Senden'
else
  self.Caption := 'Senden - [' + ExtractFileName(SetupData.TxListFile) + ']';
end;


function TCanFdTxWin.ExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer;
var tx_msg: TTxCanMsg;
    tx_msg_ptr: PTxCanMsg;

begin;
result := 0;
case cmd of
  TX_WIN_SAVE  : begin;
                 if TxList.Count = 0 then
                   begin;
                   MessageDlg('Keine Daten zum Speichern!', mtError, [mbOk], 0);
                   exit;
                   end;
                 SaveDialog.FileName := SetupData.TxListFile;
                 if SaveDialog.Execute then
                   begin;
                   SetupData.TxListFile := SaveDialog.FileName;
                   if length(SetupData.TxListFile) > 0 then
                     TxList.SaveToFile(SetupData.TxListFile);
                   end;
                 UpdateTitle;
                 end;
  TX_WIN_LOAD  : begin;
                 OpenDialog.FileName := SetupData.TxListFile;
                 if OpenDialog.Execute then
                   begin;
                   SetupData.TxListFile := OpenDialog.FileName;
                   if length(SetupData.TxListFile) > 0 then
                     TxList.LoadFromFile(SetupData.TxListFile);
                   end;
                 TxView.RowCount := TxList.Count + 1;
                 TxView.Row := 1;
                 if TxView.Row <= TxList.Count then
                   SetMsgToUi(TxList.Items[TxView.Row-1])
                 else
                   SetMsgToUi(nil);
                 TxView.Refresh;
                 UpdateTitle;
                 end;
  TX_WIN_CLEAR : begin;
                 TxList.Clear;
                 SetMsgToUi(nil);
                 TxView.RowCount := 2;
                 TxView.Row := 1;
                 TxView.Refresh;
                 end;
  TX_WIN_ENABLE_INTERVALL :
                 begin;
                 TxList.SetIntervallMode(TRUE);
                 end;
  TX_WIN_DISABLE_INTERVALL :
                 begin;
                 TxList.SetIntervallMode(FALSE);
                 end;
  TX_WIN_ADD_MESSAGE :                 
                 begin;
                 if TxList <> nil then
                   begin;
                   TxList.EmptyMessage(@tx_msg);
                   Move(can_msg^, tx_msg.CanMsg, SizeOf(TCanFdMsg));
                   TxList.Add(@tx_msg);
                   TxView.RowCount := TxList.Count+1;
                   TxView.Row := TxView.RowCount - 1;
                   SetMsgToUi(TxList.Items[TxView.Row-1]);
                   TxView.Refresh;
                   end;
                 end; 
  TX_WIN_UPDATE_MSG :
                 begin;
                 if TxList <> nil then
                   begin;
                   tx_msg_ptr := TxList.Items[param1];
                   if tx_msg_ptr <> nil then
                     begin;
                     SetMsgToUi(tx_msg_ptr);
                     TxView.Refresh;
                     end;
                   end;
                 end;
  TX_WIN_SAVE_FILE :
                 begin;
                 if TxList.Count = 0 then
                   exit;
                 if length(SetupData.TxListFile) > 0 then
                   TxList.SaveToFile(SetupData.TxListFile);
                 UpdateTitle;
                 end;
  TX_WIN_LOAD_FILE :
                 begin;
                 if length(SetupData.TxListFile) > 0 then
                   begin;
                   if TxList.LoadFromFile(SetupData.TxListFile) > 0 then
                     begin;
                     TxView.RowCount := TxList.Count + 1;
                     TxView.Row := 1;
                     if TxView.Row <= TxList.Count then
                       SetMsgToUi(TxList.Items[TxView.Row-1])
                     else
                       SetMsgToUi(nil);
                     TxView.Refresh;
                     end;
                   end;
                 UpdateTitle;
                 end;                                   
  end;
end;


procedure TCanFdTxWin.DisableTxEditEvents;
var i: Integer;

begin;
IdEdit.OnChange := nil;
DLCEdit.OnChange := nil;
IdEdit.OnKeyUp := nil;
DLCEdit.OnKeyUp := nil;
for i := 0 to 63 do
  begin;
  CanDataEdit[i].OnChange := nil;
  CanDataEdit[i].OnKeyUp := nil;
  end;
TriggerIdEdit.OnChange := nil;
TriggerIdEdit.OnKeyUp := nil;
IntervallEdit.OnChange := nil;
IntervallEdit.OnKeyUp := nil;
CommentEdit.OnChange := nil;
RTRCheck.OnClick := nil;
EFFCheck.OnClick := nil;
CanFdCheck.OnClick := nil;
CanFdBrsCheck.OnClick := nil;
TxModeCombo.OnChange := nil;
end;


procedure TCanFdTxWin.EnableTxEditEvents;
var i: Integer;

begin;
IdEdit.OnChange := TxEditOnChange;
DLCEdit.OnChange := TxEditOnChange;
IdEdit.OnKeyUp := TxEditKeyUp;
DLCEdit.OnKeyUp := TxEditKeyUp;
for i := 0 to 63 do
  begin;
  CanDataEdit[i].OnChange := TxEditOnChange;
  CanDataEdit[i].OnKeyUp := TxEditKeyUp;
  end;
TriggerIdEdit.OnChange := TxEditOnChange;
TriggerIdEdit.OnKeyUp := TxEditKeyUp;
IntervallEdit.OnChange := TxEditOnChange;
IntervallEdit.OnKeyUp := TxEditKeyUp;
CommentEdit.OnChange := TxEditOnChange;
RTRCheck.OnClick := TxEditOnChange;
EFFCheck.OnClick := TxEditOnChange;
CanFdCheck.OnClick := TxEditOnChange;
CanFdBrsCheck.OnClick := TxEditOnChange;
TxModeCombo.OnChange := TxEditOnChange;
end;


procedure TCanFdTxWin.TxEditChange(sender: TObject);
var can_msg: PTxCanMsg;
    flags: DWord;
    tag: Integer;

begin;
can_msg := nil;
if (TxView.Row <= TxList.Count) and (TxView.Row > 0) then
  can_msg := TxList.Items[TxView.Row-1];
if can_msg = nil then
  exit;
tag := TComponent(sender).Tag;
if tag < 64 then
  can_msg^.CanMsg.Data.Bytes[tag] := CanDataEdit[tag].Number
else
  begin;
  case tag of
    64 : can_msg^.CanMsg.ID := IDEdit.Number;
    65 : can_msg^.CanMsg.Length := CorrectCanFdLen(StrToInt(DLCEdit.Text));
    66, 67, 68, 69 :
       begin;
       flags := 0;
       if RTRCheck.Checked then
         flags := flags or FlagCanFdRTR;
       if EFFCheck.Checked then
         flags := flags or FlagCanFdEFF;
       if CanFdCheck.Checked then
         flags := flags or FlagCanFdFD;
       if CanFdBrsCheck.Checked then
         flags := flags or FlagCanFdBRS;
       can_msg^.CanMsg.Flags:= flags;
       end;
    70 : can_msg^.TxMode := TxModeCombo.ItemIndex;   // 0 = Off, 1 = Periodic, 2 = RTR, 3 = Trigger
    71 : can_msg^.Intervall := IntervallEdit.Number;
    72 : can_msg^.TriggerId := TriggerIdEdit.Number;
    73 : can_msg^.Comment := CommentEdit.Text;
    end;        
  end;
TxView.Refresh;
end;


procedure TCanFdTxWin.TxEditOnChange(Sender: TObject);
begin
TxEditChange(Sender);
end;


procedure TCanFdTxWin.TxEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
TxEditChange(Sender);
end;


procedure TCanFdTxWin.TxViewClick(Sender: TObject);
var can_msg: PTxCanMsg;

begin
TxView.Repaint;
{if TxView.Col = 8 then  // ?
  exit;}
can_msg := nil;
if (TxView.Row <= TxList.Count) and (TxView.Row > 0) then
  can_msg := TxList.Items[TxView.Row-1];
if can_msg = nil then
  exit;
SetMsgToUi(can_msg);
end;


end.


