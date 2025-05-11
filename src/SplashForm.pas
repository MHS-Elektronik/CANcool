{***************************************************************************
                      SplashForm.pas  -  description
                             -------------------
    begin             : 01.01.2022
    last modified     : 01.01.2022
    copyright         : (C) 2022 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit SplashForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg;

type
  TSplashWin = class(TForm)
    imgSplashMe: TImage;
    tmrMinTiming: TTimer;
    procedure tmrMinTimingTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FInitializationDone: Boolean;
    procedure SetInitializationDone(const Value: Boolean);
    { Private declarations }
  public
    { Public declarations }
    property InitializationDone: Boolean read FInitializationDone write SetInitializationDone;
  end;

var
  SplashWin: TSplashWin;

implementation

{$R *.dfm}

procedure TSplashWin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
SplashWin := nil;
end;


procedure TSplashWin.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);

begin
CanClose := (not tmrMinTiming.Enabled) and FInitializationDone;
end;


procedure TSplashWin.SetInitializationDone(const Value: Boolean);
begin
FInitializationDone := Value;
Close;
end;


procedure TSplashWin.tmrMinTimingTimer(Sender: TObject);
begin
tmrMinTiming.Enabled := False;
Close;
end;

end.
