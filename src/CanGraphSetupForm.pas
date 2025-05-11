  {***************************************************************************
                    CanGraphSetupForm.pas  -  description
                             -------------------
    begin             : 28.12.2021
    last modified     : 28.12.2021     
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
unit CanGraphSetupForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Spin, ExtCtrls, IniFiles, zahlen32, zahlen,
  Longedit;

type
  TCanGraphSetupWin = class(TForm)
    RahmenBevel: TBevel;
    NameEdit: TEdit;
    OKBtn: TBitBtn;
    AbbrechenBtn: TBitBtn;
    CanIdStartLabel: TLabel;
    Label9: TLabel;
    LadenBtn: TBitBtn;
    SpeichernBtn: TBitBtn;
    Label7: TLabel;
    CanIdEdit: TZahlen32Edit;
    GroupBox1: TGroupBox;
    DLCEdit: TZahlenEdit;
    Mask7Edit: TZahlenEdit;
    Mask8Edit: TZahlenEdit;
    Mask6Edit: TZahlenEdit;
    Mask5Edit: TZahlenEdit;
    Mask4Edit: TZahlenEdit;
    Mask3Edit: TZahlenEdit;
    Mask2Edit: TZahlenEdit;
    Mask1Edit: TZahlenEdit;
    Label4: TLabel;
    Label6: TLabel;
    Data8Edit: TZahlenEdit;
    Data7Edit: TZahlenEdit;
    Data6Edit: TZahlenEdit;
    Data5Edit: TZahlenEdit;
    Data4Edit: TZahlenEdit;
    Data3Edit: TZahlenEdit;
    Data2Edit: TZahlenEdit;
    Data1Edit: TZahlenEdit;
    Label11: TLabel;
    MuxEnabledCheck: TCheckBox;
    FrameFormatEdit: TComboBox;
    Label2: TLabel;
    CanFdEdit: TComboBox;
    MinValueEdit: TLongIntEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    MaxValueEdit: TLongIntEdit;
    GraphValuesLimitEdit: TLongIntEdit;
    BerechnungsTermEdit: TEdit;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure LadenBtnClick(Sender: TObject);
    procedure SpeichernBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Dateiname: string;
  public
    { Public-Deklarationen }
  end;

implementation

uses MainForm;

{$R *.dfm}

procedure TCanGraphSetupWin.FormCreate(Sender: TObject);

begin
TMainWin(Owner.Owner).ButtonImages.GetBitmap(0, OKBtn.Glyph);
TMainWin(Owner.Owner).ButtonImages.GetBitmap(1, AbbrechenBtn.Glyph);
TMainWin(Owner.Owner).ButtonImages.GetBitmap(5, LadenBtn.Glyph);
TMainWin(Owner.Owner).ButtonImages.GetBitmap(4, SpeichernBtn.Glyph);
end;


procedure TCanGraphSetupWin.OKBtnClick(Sender: TObject);

begin
Dateiname := '';
ModalResult := mrOK;
end;


procedure TCanGraphSetupWin.LadenBtnClick(Sender: TObject);
var
  IniDatei: TIniFile;

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
    CANIdEdit.Number := IniDatei.ReadInteger('Common', 'CanId', 0);
    FrameFormatEdit.ItemIndex := IniDatei.ReadInteger('Common', 'FrameFormat', 0);
    CanFdEdit.ItemIndex := IniDatei.ReadInteger('Common', 'CanFd', 0);
    DLCEdit.Number := IniDatei.ReadInteger('Common', 'MuxDlc', 8);
    Mask1Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask0', 0);
    Mask2Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask1', 0);
    Mask3Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask2', 0);
    Mask4Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask3', 0);
    Mask5Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask4', 0);
    Mask6Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask5', 0);
    Mask7Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask6', 0);
    Mask8Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanMask7', 0);
    Data1Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData0', 0);
    Data2Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData1', 0);
    Data3Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData2', 0);
    Data4Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData3', 0);
    Data5Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData4', 0);
    Data6Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData5', 0);
    Data7Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData6', 0);
    Data8Edit.Number := IniDatei.ReadInteger('Common', 'MuxCanData7', 0);
    if IniDatei.ReadInteger('Common', 'MuxEnable', 0) > 0 then 
      MuxEnabledCheck.Checked := True
    else
      MuxEnabledCheck.Checked := False;
    MinValueEdit.Number := IniDatei.ReadInteger('Common', 'MinValue', 0);
    MaxValueEdit.Number := IniDatei.ReadInteger('Common', 'MaxValue', 1000);
    GraphValuesLimitEdit.Number := IniDatei.ReadInteger('Common', 'GraphValuesLimit', 1000);
    BerechnungsTermEdit.Text := IniDatei.ReadString('Common', 'Formula', '');
  finally
    IniDatei.Free;
    end;
  end;
end;


procedure TCanGraphSetupWin.SpeichernBtnClick(Sender: TObject);
var
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
    IniDatei.WriteString('Common', 'Type', Owner.ClassName);
    IniDatei.WriteString('Common', 'Name', NameEdit.Text);

    IniDatei.WriteInteger('Common', 'CanId', CANIdEdit.Number);
    IniDatei.WriteInteger('Common', 'FrameFormat', FrameFormatEdit.ItemIndex);
    IniDatei.WriteInteger('Common', 'CanFd', CanFdEdit.ItemIndex);
    IniDatei.WriteInteger('Common', 'MuxDlc', DLCEdit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask0', Mask1Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask1', Mask2Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask2', Mask3Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask3', Mask4Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask4', Mask5Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask5', Mask6Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask6', Mask7Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanMask7', Mask8Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData0', Data1Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData1', Data2Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData2', Data3Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData3', Data4Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData4', Data5Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData5', Data6Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData6', Data7Edit.Number);
    IniDatei.WriteInteger('Common', 'MuxCanData7', Data8Edit.Number);
    if MuxEnabledCheck.Checked then
      IniDatei.WriteInteger('Common', 'MuxEnable', 1)
    else
      IniDatei.WriteInteger('Common', 'MuxEnable', 0);
    IniDatei.WriteInteger('Common', 'MinValue', MinValueEdit.Number);
    IniDatei.WriteInteger('Common', 'MaxValue', MaxValueEdit.Number);
    IniDatei.WriteInteger('Common', 'GraphValuesLimit', GraphValuesLimitEdit.Number);    
    IniDatei.WriteString('Common', 'Formula', BerechnungsTermEdit.Text);  
  finally
    IniDatei.Free;
    end;
  end;
end;


end.
