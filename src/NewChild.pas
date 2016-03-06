{***************************************************************************
                       NewChild.pas  -  description
                             -------------------
    begin             : 07.01.2013
    last modified     : 05.02.2016    
    copyright         : (C) 2013 - 2016 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit NewChild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CanGaugeForm, CanValueForm, CanBitValueForm;

type
  TNewChildForm = class(TForm)
    GaugeNewBtn: TBitBtn;
    ValueNewBtn: TBitBtn;
    BitNewBtn: TBitBtn;
    Memo1: TMemo;
    procedure GaugeNewBtnClick(Sender: TObject);
    procedure ValueNewBtnClick(Sender: TObject);
    procedure BitNewBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewChildForm: TNewChildForm;

implementation

uses MainForm;

{$R *.dfm}

procedure TNewChildForm.GaugeNewBtnClick(Sender: TObject);
begin
TMainWin(owner).MDIClientNew(TCanGaugeWin);
close;
end;


procedure TNewChildForm.ValueNewBtnClick(Sender: TObject);
begin
TMainWin(owner).MDIClientNew(TCanValueWin);
close;
end;


procedure TNewChildForm.BitNewBtnClick(Sender: TObject);
begin
TMainWin(owner).MDIClientNew(TCanBitValueWin);
close;
end;


procedure TNewChildForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if shift = [] then
  begin
    case key of
      27 : close;
      end;
  end;
end;

end.
