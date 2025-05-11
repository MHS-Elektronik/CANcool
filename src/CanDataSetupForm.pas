  {***************************************************************************
                    CanDataSetupForm.pas  -  description
                             -------------------
    begin             : 24.12.2021
    last modified     : 24.12.2021     
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
unit CanDataSetupForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Spin, ExtCtrls, IniFiles, zahlen32, zahlen;

type
  TCanDataSetupWin = class(TForm)
    RahmenBevel: TBevel;
    NameEdit: TEdit;
    OKBtn: TBitBtn;
    AbbrechenBtn: TBitBtn;
    CanIdStartLabel: TLabel;
    CanMaskEndLabel: TLabel;
    Label9: TLabel;
    LadenBtn: TBitBtn;
    SpeichernBtn: TBitBtn;
    Label7: TLabel;
    CanIdStartEdit: TZahlen32Edit;
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
    CanMaskEndEdit: TZahlen32Edit;
    FrameFormatEdit: TComboBox;
    Label2: TLabel;
    CanFdEdit: TComboBox;
    IdModeEdit: TRadioGroup;
    MsgHitDisableBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure LadenBtnClick(Sender: TObject);
    procedure SpeichernBtnClick(Sender: TObject);
    procedure IdModeEditClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Dateiname: string;
  public
    { Public-Deklarationen }
  end;

implementation

uses MainForm;

{$R *.dfm}

procedure TCanDataSetupWin.FormCreate(Sender: TObject);

begin
TMainWin(Owner.Owner).ButtonImages.GetBitmap(0, OKBtn.Glyph);
TMainWin(Owner.Owner).ButtonImages.GetBitmap(1, AbbrechenBtn.Glyph);
TMainWin(Owner.Owner).ButtonImages.GetBitmap(5, LadenBtn.Glyph);
TMainWin(Owner.Owner).ButtonImages.GetBitmap(4, SpeichernBtn.Glyph);
end;


procedure TCanDataSetupWin.OKBtnClick(Sender: TObject);

begin
Dateiname := '';
ModalResult := mrOK;
end;


procedure TCanDataSetupWin.LadenBtnClick(Sender: TObject);
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
    IdModeEdit.ItemIndex := IniDatei.ReadInteger('Common', 'IdModeEdit', 0);
    CANIdStartEdit.Number := IniDatei.ReadInteger('Common', 'CanIdStart', 0);
    CANMaskEndEdit.Number := IniDatei.ReadInteger('Common', 'CanMaskEnd', 0);
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
    if IniDatei.ReadInteger('Common', 'MsgHitDisable', 0) > 0 then
      MsgHitDisableBox.Checked := True
    else
      MsgHitDisableBox.Checked := False;
    if IniDatei.ReadInteger('Common', 'MuxEnable', 0) > 0 then 
      MuxEnabledCheck.Checked := True
    else
      MuxEnabledCheck.Checked := False;
  finally
    IniDatei.Free;
    end;
  end;
end;


procedure TCanDataSetupWin.SpeichernBtnClick(Sender: TObject);
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

    IniDatei.WriteInteger('Common', 'IdModeEdit', IdModeEdit.ItemIndex);
    IniDatei.WriteInteger('Common', 'CanIdStart', CANIdStartEdit.Number);
    IniDatei.WriteInteger('Common', 'CanMaskEnd', CANMaskEndEdit.Number);
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
    if MsgHitDisableBox.Checked then
      IniDatei.WriteInteger('Common', 'MsgHitDisable', 1)
    else
      IniDatei.WriteInteger('Common', 'MsgHitDisable', 0);
    if MuxEnabledCheck.Checked then
      IniDatei.WriteInteger('Common', 'MuxEnable', 1)
    else
      IniDatei.WriteInteger('Common', 'MuxEnable', 0);
  finally
    IniDatei.Free;
    end;
  end;
end;


procedure TCanDataSetupWin.IdModeEditClick(Sender: TObject);
begin

case IdModeEdit.ItemIndex of
  0 : begin;
      CanIdStartLabel.Caption := 'ID';
      CanMaskEndLabel.Visible := FALSE;
      CanMaskEndEdit.Visible := FALSE;
      end;
  1 : begin;
      CanIdStartLabel.Caption := 'Start Id';
      CanMaskEndLabel.Caption := 'End Id';
      CanMaskEndLabel.Visible := TRUE;
      CanMaskEndEdit.Visible := TRUE;
      end;
  2 : begin;
      CanIdStartLabel.Caption := 'ID';
      CanMaskEndLabel.Caption := 'Mask';
      CanMaskEndLabel.Visible := TRUE;
      CanMaskEndEdit.Visible := TRUE;      
      end;
  end;
end;

end.
