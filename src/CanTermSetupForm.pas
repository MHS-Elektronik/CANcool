  {***************************************************************************
                    CanTermSetupForm.pas  -  description
                             -------------------
    begin             : 23.12.2021
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
unit CanTermSetupForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Spin, ExtCtrls, IniFiles, zahlen32, zahlen,
  CanCoolDefs;

type
  TCanTermSetupWin = class(TForm)
    RahmenBevel: TBevel;
    NameEdit: TEdit;
    OKBtn: TBitBtn;
    AbbrechenBtn: TBitBtn;
    Label9: TLabel;
    LadenBtn: TBitBtn;
    SpeichernBtn: TBitBtn;
    FontChangeBtn: TButton;
    Label13: TLabel;
    Panel2: TPanel;
    FontLabel: TLabel;
    FontDialog: TFontDialog;
    AutoCRCheckBox: TCheckBox;
    AutoLFCheckBox: TCheckBox;
    LocalEchoCheckBox: TCheckBox;
    MonoChromeCheckBox: TCheckBox;
    XlatCheckBox: TCheckBox;
    GraphicDrawCheckBox: TCheckBox;
    GroupBox1: TGroupBox;
    FKeys1RadioButton: TRadioButton;
    FKeys2RadioButton: TRadioButton;
    FKeys3RadioButton: TRadioButton;
    GroupBox2: TGroupBox;
    RxCanIdEdit: TZahlen32Edit;
    Label1: TLabel;
    RxEffCheckBox: TCheckBox;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    TxCanIdEdit: TZahlen32Edit;
    TxEffCheckBox: TCheckBox;
    TxEnableCheckBox: TCheckBox;
    TxBrsCheckBox: TCheckBox;
    TxFdCheckBox: TCheckBox;
    TxOnReturnCheckBox: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    RowsEdit: TEdit;
    ColsEdit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure LadenBtnClick(Sender: TObject);
    procedure SpeichernBtnClick(Sender: TObject);
    procedure FontChangeBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
    Dateiname: string;
    function  GetFKeys       : Integer;
    function  GetRows        : Integer;
    function  GetCols        : integer;
    procedure SetFKeys(Value: Integer);
    procedure SetRows(Value: Integer);
    procedure SetCols(Value: Integer);
  public
    { Public-Deklarationen }
    property Rows: Integer read GetRows write SetRows;
    property Cols: Integer read GetCols write SetCols;    
    property FKeys: Integer read GetFKeys write SetFkeys;
  end;

implementation

uses Util, MainForm, IntegerTerm, OverbyteIcsUtils;

{$R *.dfm}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCanTermSetupWin.SetFKeys(Value : Integer);

begin
case Value of
  0 : FKeys1RadioButton.Checked := TRUE;
  1 : FKeys2RadioButton.Checked := TRUE;
  2 : FKeys3RadioButton.Checked := TRUE;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCanTermSetupWin.SetRows(Value : Integer);

begin
RowsEdit.Text := IntToStr(Value);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCanTermSetupWin.SetCols(Value : Integer);

begin
ColsEdit.Text := IntToStr(Value);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCanTermSetupWin.GetFKeys : Integer;
begin
if FKeys1RadioButton.Checked then
  Result := 0
else if FKeys2RadioButton.Checked then
  Result := 1
else
  Result := 2;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function  TCanTermSetupWin.GetRows : Integer;
begin
Result := atoi(RowsEdit.Text);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function  TCanTermSetupWin.GetCols : integer;
begin
Result := atoi(ColsEdit.Text);
end;


procedure TCanTermSetupWin.FormCreate(Sender: TObject);

begin
TMainWin(Owner.Owner).ButtonImages.GetBitmap(0, OKBtn.Glyph);
TMainWin(Owner.Owner).ButtonImages.GetBitmap(1, AbbrechenBtn.Glyph);
TMainWin(Owner.Owner).ButtonImages.GetBitmap(5, LadenBtn.Glyph);
TMainWin(Owner.Owner).ButtonImages.GetBitmap(4, SpeichernBtn.Glyph);
end;


procedure TCanTermSetupWin.OKBtnClick(Sender: TObject);

begin
Dateiname := '';
ModalResult := mrOK;
end;


procedure TCanTermSetupWin.LadenBtnClick(Sender: TObject);
var
  IniDatei: TIniFile;
  font_desc: TFontDesc;

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
    RxCanIdEdit.Number := IniDatei.ReadInteger('Common', 'RxCanId', 0);
    RxEffCheckBox.Checked := IniDatei.ReadInteger('Common', 'RxEff', 0) <> 0;
    TxCanIdEdit.Number := IniDatei.ReadInteger('Common', 'TxCanId', 0);
    TxEffCheckBox.Checked := IniDatei.ReadInteger('Common', 'TxEff', 0) <> 9;
    TxEnableCheckBox.Checked := IniDatei.ReadInteger('Common', 'TxEnable', 0) <> 0;
    TxBrsCheckBox.Checked := IniDatei.ReadInteger('Common', 'TxBrs', 0) <> 0;
    TxFdCheckBox.Checked := IniDatei.ReadInteger('Common', 'TxFd', 0) <> 0;
    TxOnReturnCheckBox.Checked := IniDatei.ReadInteger('Common', 'TxOnReturn', 0) <> 0;
    AutoCRCheckBox.Checked := IniDatei.ReadInteger('Common', 'AutoCR', 0) <> 0;
    AutoLFCheckBox.Checked := IniDatei.ReadInteger('Common', 'AutoLF', 0) <> 0;
    LocalEchoCheckBox.Checked := IniDatei.ReadInteger('Common', 'LocalEcho', 0) <> 0;
    MonoChromeCheckBox.Checked := IniDatei.ReadInteger('Common', 'MonoChrome', 0) <> 0;
    XlatCheckBox.Checked := IniDatei.ReadInteger('Common', 'Xlat', 0) <> 0;
    GraphicDrawCheckBox.Checked := IniDatei.ReadInteger('Common', 'GraphicDraw', 0) <> 0;
    Rows := IniDatei.ReadInteger('Common', 'Rows', 25);
    Cols := IniDatei.ReadInteger('Common', 'Cols', 80);
    FKeys := IniDatei.ReadInteger('Common', 'FKeys', 0);    
    IniReadFont(IniDatei, font_desc, 'Common', 'Font', DefaultFont);
    FontDescToFont(font_desc, FontLabel.Font); 
    FontLabel.Caption := FontLabel.Font.Name + ', ' + IntToStr(FontLabel.Font.Size);
  finally
    IniDatei.Free;
    end;
  end;
end;


procedure TCanTermSetupWin.SpeichernBtnClick(Sender: TObject);
var
  IniDatei: TIniFile;
  font_desc: TFontDesc;

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
    IniDatei.WriteInteger('Common', 'RxCanId', RxCanIdEdit.Number);
    IniDatei.WriteInteger('Common', 'RxEff', ord(RxEffCheckBox.Checked));
    IniDatei.WriteInteger('Common', 'TxCanId', TxCanIdEdit.Number);
    IniDatei.WriteInteger('Common', 'TxEff', ord(TxEffCheckBox.Checked));
    IniDatei.WriteInteger('Common', 'TxEnable', ord(TxEnableCheckBox.Checked));
    IniDatei.WriteInteger('Common', 'TxBrs', ord(TxBrsCheckBox.Checked));
    IniDatei.WriteInteger('Common', 'TxFd', ord(TxFdCheckBox.Checked));
    IniDatei.WriteInteger('Common', 'TxOnReturn', ord(TxOnReturnCheckBox.Checked));
    IniDatei.WriteInteger('Common', 'AutoCR', ord(AutoCRCheckBox.Checked));
    IniDatei.WriteInteger('Common', 'AutoLF', ord(AutoLFCheckBox.Checked));
    IniDatei.WriteInteger('Common', 'LocalEcho', ord(LocalEchoCheckBox.Checked));
    IniDatei.WriteInteger('Common', 'MonoChrome', ord(MonoChromeCheckBox.Checked));
    IniDatei.WriteInteger('Common', 'Xlat', ord(XlatCheckBox.Checked));
    IniDatei.WriteInteger('Common', 'GraphicDraw', ord(GraphicDrawCheckBox.Checked));
    IniDatei.WriteInteger('Common', 'Rows', Rows);
    IniDatei.WriteInteger('Common', 'Cols', Cols);
    IniDatei.WriteInteger('Common', 'FKeys', FKeys);
    FontDescFromFont(font_desc, FontLabel.Font);
    IniWriteFont(IniDatei, 'Common', 'Font', font_desc);
  finally
    IniDatei.Free;
    end;
  end;
end;


procedure TCanTermSetupWin.FontChangeBtnClick(Sender: TObject);
begin
with FontDialog do
  begin;
  Font := FontLabel.Font;
  if Execute then
    begin;
    FontLabel.Caption := Font.Name + ', ' + IntToStr(Font.Size); 
    FontLabel.Font := Font;
    end;    
  end;
end;


procedure TCanTermSetupWin.FormShow(Sender: TObject);

begin
FontLabel.Caption := FontLabel.Font.Name + ', ' + IntToStr(FontLabel.Font.Size);
end;

end.
