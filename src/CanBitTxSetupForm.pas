{***************************************************************************
                  CanBitTxSetupForm.pas  -  description
                             -------------------
    begin             : 25.10.2021
    last modified     : 10.01.2022     
    copyright         : (C) 2021 - 2022 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit CanBitTxSetupForm;

interface

{$WARN UNSAFE_CAST OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, IniFiles, StrUtils, zahlen32,
  zahlen;

type
  TCanBitTxSetupWin = class(TForm)
    RahmenBevel: TBevel;
    Label1: TLabel;
    Label9: TLabel;
    OKBtn: TBitBtn;
    AbbrechenBtn: TBitBtn;
    NameEdit: TEdit;
    LadenBtn: TBitBtn;
    SpeichernBtn: TBitBtn;
    BitNameGrid: TStringGrid;
    HinzufuegenBtn: TBitBtn;
    Bevel1: TBevel;
    EntfernenBtn: TBitBtn;
    BitComboBox: TComboBox;
    ColorBox: TColorBox;
    CanIdEdit: TZahlen32Edit;
    AutoTxCheckBox: TCheckBox;
    ShowTxBtnCheckBox: TCheckBox;
    FdBitComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxExit(Sender: TObject);
    procedure ColorBoxExit(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure LadenBtnClick(Sender: TObject);
    procedure SpeichernBtnClick(Sender: TObject);
    procedure HinzufuegenBtnClick(Sender: TObject);
    procedure EntfernenBtnClick(Sender: TObject);
    procedure BitNameGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BitNameGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure BitNameGridGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure BitNameGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  private
    { Private-Deklarationen }
    Dateiname: string;
    BitConfListe: TList;
    procedure AddBitConfItem(line: Integer);
    procedure CMDialogKey(var msg: TCMDialogKey); message CM_DIALOGKEY;
  public
    { Public-Deklarationen }    
    procedure SetBitConfListe(liste: TList);
    procedure GetBitConfListe(liste: TList);    
  end;

implementation

uses MainForm, Setup, CanBitTxForm;

{$R *.dfm}

procedure TCanBitTxSetupWin.FormCreate(Sender: TObject);
begin
  TMainWin(Owner.Owner).ButtonImages.GetBitmap(0, OKBtn.Glyph);
  TMainWin(Owner.Owner).ButtonImages.GetBitmap(1, AbbrechenBtn.Glyph);
  TMainWin(Owner.Owner).ButtonImages.GetBitmap(5, LadenBtn.Glyph);
  TMainWin(Owner.Owner).ButtonImages.GetBitmap(4, SpeichernBtn.Glyph);
  TMainWin(Owner.Owner).ButtonImages.GetBitmap(2, HinzufuegenBtn.Glyph);
  TMainWin(Owner.Owner).ButtonImages.GetBitmap(3, EntfernenBtn.Glyph);
  BitConfListe := TList.Create;

  BitNameGrid.ColWidths[0] := 220;
  BitNameGrid.Cells[0, 0] := 'Bezeichnung';
  BitNameGrid.ColWidths[1] := 90;
  BitNameGrid.Cells[1, 0] := 'Farbe';
  BitNameGrid.ColWidths[2] := 60;
  BitNameGrid.Cells[2, 0] := 'Byte';
  BitNameGrid.ColWidths[3] := 40;
  BitNameGrid.Cells[3, 0] := 'Bit';
  BitNameGrid.DefaultRowHeight := BitComboBox.Height;

  BitComboBox.Parent := BitNameGrid;
  BitComboBox.Visible := False;
  FdBitComboBox.Parent := BitNameGrid;
  FdBitComboBox.Visible := False;
  
  ColorBox.Parent := BitNameGrid;
  ColorBox.Visible := False;

  AddBitConfItem(1);
end;


procedure TCanBitTxSetupWin.FormDestroy(Sender: TObject);
begin
TCanBitTxWin(Owner).BitConfListeClear(BitConfListe);
BitConfListe.Free;
end;


procedure TCanBitTxSetupWin.SetBitConfListe(liste: TList);
var i: Integer;
    item: PTxBitConf;

begin;
if liste.Count = 0 then
  exit;
TCanBitTxWin(Owner).BitConfListeClear(BitConfListe);
for i := 0 to liste.Count-1 do
  begin
  new(item);
  item.Name := PTxBitConf(liste[i]).Name;       // Bezeichnung
  item.Color := PTxBitConf(liste[i]).Color;     // Farbe
  item.BytePos := PTxBitConf(liste[i]).BytePos; // Byte
  item.BitPos := PTxBitConf(liste[i]).BitPos;   // Bit
  BitConfListe.Add(item);
  end;
BitNameGrid.RowCount := liste.Count + 1;  
BitNameGrid.Refresh;
end;


procedure TCanBitTxSetupWin.GetBitConfListe(liste: TList);
var i: Integer;
    item: PTxBitConf;
     
begin;
if BitConfListe.Count = 0 then
  exit;
TCanBitTxWin(Owner).BitConfListeClear(liste);  
for i := 0 to BitConfListe.Count-1 do
  begin
  new(item);
  item.Name := PTxBitConf(BitConfListe[i]).Name;       // Bezeichnung
  item.Color := PTxBitConf(BitConfListe[i]).Color;     // Farbe
  item.BytePos := PTxBitConf(BitConfListe[i]).BytePos; // Byte
  item.BitPos := PTxBitConf(BitConfListe[i]).BitPos;   // Bit
  liste.Add(item);
  end;
end;


procedure TCanBitTxSetupWin.AddBitConfItem(line: Integer);
var item: PTxBitConf;

begin;
new(item);
item.Name := Format('TxBit %u', [line]); // Bezeichnung
item.Color := clRed;                     // Farbe
item.BytePos := 0;                       // Byte
item.BitPos := 0;                        // Bit
BitConfListe.Add(item);
end;


procedure TCanBitTxSetupWin.HinzufuegenBtnClick(Sender: TObject);
var line: Integer;

begin
if  BitNameGrid.RowCount < 48 then
  begin
  line := BitNameGrid.RowCount;
  AddBitConfItem(line);
  inc(line);
  BitNameGrid.RowCount := line;
  BitNameGrid.Refresh;
  end;
end;


procedure TCanBitTxSetupWin.EntfernenBtnClick(Sender: TObject);
var item_index: Integer;

begin
if BitNameGrid.RowCount > 2 then
  begin
  item_index := BitNameGrid.RowCount - 1;
  dispose(BitConfListe.Items[item_index-1]);
  BitConfListe.Delete(item_index-1);
  BitNameGrid.RowCount := item_index;
  end;
end;


procedure TCanBitTxSetupWin.CMDialogKey(var msg: TCMDialogKey);
begin
if (ActiveControl = BitComboBox) or
   (ActiveControl = FdBitComboBox) or
   (ActiveControl = ColorBox) then
  begin
  if msg.CharCode = VK_TAB then
    begin
    // setzt den Fokus zurück auf das StringGrid
    BitNameGrid.SetFocus;
    BitNameGrid.Perform(WM_KEYDOWN, msg.CharCode, msg.KeyData);
    msg.Result := 1;
    exit;
    end;
  end;
inherited;
end;


procedure TCanBitTxSetupWin.ComboBoxExit(Sender: TObject);
begin
TComboBox(sender).hide;
case BitNameGrid.Col of
  2 : PTxBitConf(BitConfListe[BitNameGrid.row-1]).BytePos := TComboBox(sender).ItemIndex;
  3 : PTxBitConf(BitConfListe[BitNameGrid.row-1]).BitPos := TComboBox(sender).ItemIndex;
  end;
end;


procedure TCanBitTxSetupWin.ColorBoxExit(Sender: TObject);
begin
TColorBox(sender).hide;
PTxBitConf(BitConfListe[BitNameGrid.row-1]).Color := TColorBox(sender).Selected;
BitNameGrid.Repaint;
end;


procedure TCanBitTxSetupWin.BitNameGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  Str: String;
  R: TRect;
  org: TPoint;
  box_obj: TComboBox;

begin
if (ACol in [1, 2, 3]) and (ARow >= BitNameGrid.FixedRows) then
  begin
  BitNameGrid.Perform(WM_CANCELMODE, 0, 0);
  R := BitNameGrid.CellRect(ACol, ARow);
  org := self.ScreenToClient(self.ClientToScreen(R.TopLeft));
  Str := BitNameGrid.Cells[ACol, ARow];
  case ACol of
    1 : begin
        box_obj := TComboBox(ColorBox);
        ColorBox.Selected := PTxBitConf(BitConfListe[ARow-1]).Color;
        end;
    2 : begin
        if SetupData.CanFd then
          begin;
          box_obj := FdBitComboBox;
          FdBitComboBox.ItemIndex := PTxBitConf(BitConfListe[ARow-1]).BytePos;
          end
        else
          begin;    
          box_obj := BitComboBox;
          BitComboBox.ItemIndex := PTxBitConf(BitConfListe[ARow-1]).BytePos;
          end;
        end;
    3 : begin;
        box_obj := BitComboBox;
        BitComboBox.ItemIndex := PTxBitConf(BitConfListe[ARow-1]).BitPos;
        end;
    else
        exit;    
    end;
  box_obj.SetBounds(org.X, org.Y, R.Right-R.Left, BitNameGrid.Height);  
  box_obj.Show;
  box_obj.BringToFront;
  box_obj.SetFocus;
  box_obj.DroppedDown := true;
  end;
end;


procedure TCanBitTxSetupWin.BitNameGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  Str: string;
  R: TRect;
  SelColor: TColor;
begin
BitNameGrid.Canvas.Brush.Color := BitNameGrid.Color;
BitNameGrid.Canvas.Font.Color := clWindowText;

if gdFocused in State then
  begin
  BitNameGrid.Canvas.Brush.Color := clActiveCaption;
  BitNameGrid.Canvas.Font.Color := clCaptionText;
  end
else
  if gdFixed in State then
    BitNameGrid.Canvas.Brush.Color := BitNameGrid.FixedColor;
//BitNameGrid.Canvas.FillRect(Rect);

if ARow = 0 then
  BitNameGrid.Canvas.TextOut(Rect.Left+1,Rect.Top+2, BitNameGrid.Cells[ACol, ARow])
else
  begin
  case ACol of
    0 : BitNameGrid.Canvas.TextOut(Rect.Left+1, Rect.Top+2,
                  PTxBitConf(BitConfListe[ARow-1]).Name); // Bezeichnung
    1 : begin  // Farbe
        SelColor := PTxBitConf(BitConfListe[ARow-1]).Color;
        with BitNameGrid.Canvas do
          begin;
          Pen.Color := clBlack;
          Brush.Color := clWhite;
          FillRect(Rect);
          Rectangle(Rect.Left+4,Rect.Top+2,Rect.Left+20,Rect.Bottom-3);
          Brush.Color := SelColor;
          R.Left := Rect.Left+5;
          R.Top := Rect.Top+3;
          R.Right := Rect.Left+19;
          R.Bottom := Rect.Bottom-4;
          FillRect(R);
          Brush.Color := BitNameGrid.Color;
          Font.Color := clWindowText;
          TextOut(Rect.Left+24, Rect.Top+2, ColorToString(SelColor));
          end;
        end;
    2 : begin   // Byte
        Str := Format('%u', [PTxBitConf(BitConfListe[ARow-1]).BytePos]);
        BitNameGrid.Canvas.TextOut(Rect.Left+1, Rect.Top+2, Str);
        end;
    3 : begin   // Bit
        Str := Format('%u', [PTxBitConf(BitConfListe[ARow-1]).BitPos]);
        BitNameGrid.Canvas.TextOut(Rect.Left+1, Rect.Top+2, Str);
        end;
    end;
  end;
end;


procedure TCanBitTxSetupWin.BitNameGridGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
if BitNameGrid.Row > BitConfListe.Count then
  exit;
if ACol = 0 then
  Value := PTxBitConf(BitConfListe[ARow-1]).Name;
end;


procedure TCanBitTxSetupWin.BitNameGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
if BitNameGrid.Row > BitConfListe.Count then
  exit;
if ACol = 0 then
  begin
  if length(Value) < 40 then
    PTxBitConf(BitConfListe[ARow-1]).Name := Value;
  end;
end;


procedure TCanBitTxSetupWin.OKBtnClick(Sender: TObject);
begin
Dateiname := '';
ModalResult := mrOK;
end;


procedure TCanBitTxSetupWin.LadenBtnClick(Sender: TObject);
var
  i, n: integer;
  IniDatei: TIniFile;
  BitListe: TStrings;
begin
TMainWin(Owner.Owner).OpenDialog.Title := 'Instrumenten-Einstellungen laden';
TMainWin(Owner.Owner).OpenDialog.DefaultExt := 'cin';
TMainWin(Owner.Owner).OpenDialog.Filter := 'Specific (*.cin)|*.cin|Alle Dateien (*.*)|*.*';

if TMainWin(Owner.Owner).OpenDialog.Execute then
  begin
  IniDatei := TIniFile.Create(TMainWin(Owner.Owner).OpenDialog.FileName);
  try
    NameEdit.Text := IniDatei.ReadString('Common', 'Name', TMainWin(Owner.Owner).OpenDialog.FileName);
    Dateiname := NameEdit.Text;
    CANIDEdit.Number := IniDatei.ReadInteger('Common', 'CanID', 0); // <*> .Tag ?
    {DLCEdit.Number := IniDatei.ReadInteger('Common', 'CanDlc', 8); <*>
    IntervallEdit.Number := IniDatei.ReadInteger('Common', 'Intervall', 0);}
    if IniDatei.ReadInteger('Common', 'AutoTxEnable', 0) > 0 then
      AutoTxCheckBox.Checked := True
    else
      AutoTxCheckBox.Checked := False;
    if IniDatei.ReadInteger('Common', 'ShowTxBtnEnable', 0) > 0 then
      ShowTxBtnCheckBox.Checked := True
    else
      ShowTxBtnCheckBox.Checked := False;
    BitListe := TStringList.Create;
    IniDatei.ReadSection('BitValue', BitListe);
    BitNameGrid.RowCount := 2;
    BitNameGrid.Cells[1, 1] := '';
    for i := 0 to BitListe.Count-1 do
      begin
      if AnsiStartsText('Bit', BitListe.Strings[i]) then
        begin
        n := StrToInt(copy(BitListe.Strings[i], 4, 4));
        while (n >= BitNameGrid.RowCount - 1) do
          BitNameGrid.RowCount := BitNameGrid.RowCount + 1;
        BitNameGrid.Cells[1, n+1] := IniDatei.ReadString('BitValue',
              BitListe.Strings[i], BitNameGrid.Cells[1, n+1]);
        end;
      end;
    BitListe.Free;
  finally
    IniDatei.Free;
    end;
  end;
end;

procedure TCanBitTxSetupWin.SpeichernBtnClick(Sender: TObject);
var
  i: integer;
  IniDatei: TIniFile;
begin
TMainWin(Owner.Owner).SaveDialog.Title := 'Instrumenten-Einstellungen speichern';
TMainWin(Owner.Owner).SaveDialog.DefaultExt := 'cin';
if Dateiname = '' then
  TMainWin(Owner.Owner).SaveDialog.FileName := NameEdit.Text + '.cin'
else
  TMainWin(Owner.Owner).SaveDialog.FileName := Dateiname;
TMainWin(Owner.Owner).SaveDialog.Filter := 'Specific (*.cin)|*.cin|Alle Dateien (*.*)|*.*';

if TMainWin(Owner.Owner).SaveDialog.Execute then
begin
  Dateiname := TMainWin(Owner.Owner).SaveDialog.FileName;
  IniDatei := TIniFile.Create(TMainWin(Owner.Owner).SaveDialog.FileName);
  try
    IniDatei.WriteString('Common', 'Name', NameEdit.Text);
    IniDatei.WriteInteger('Common', 'CanID', CANIDEdit.Number); //Tag); <*>
    {IniDatei.WriteInteger('Common', 'CanDlc', DLCEdit.Number); <*>
    IniDatei.WriteInteger('Common', 'Intervall', IntervallEdit.Number); }
    if AutoTxCheckBox.Checked then
      IniDatei.WriteInteger('Common', 'AutoTxEnable', 1)
    else
      IniDatei.WriteInteger('Common', 'AutoTxEnable', 0);
    if ShowTxBtnCheckBox.Checked then
      IniDatei.WriteInteger('Common', 'ShowTxBtnEnable', 1)
    else
      IniDatei.WriteInteger('Common', 'ShowTxBtnEnable', 0);
    for i := 1 to BitNameGrid.RowCount-1 do
      IniDatei.WriteString('BitValue', format('Bit%u', [i - 1]), BitNameGrid.Cells[1, i]);
    finally
      IniDatei.Free;
    end;
  end;
end;



end.
