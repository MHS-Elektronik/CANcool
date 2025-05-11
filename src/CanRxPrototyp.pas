{***************************************************************************
                       CanRxPrototyp.pas  -  description
                             -------------------
    begin             : 07.01.2013
    last modified     : 25.12.2021    
    copyright         : (C) 2013 - 2021 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit CanRxPrototyp;

interface

uses Windows, Forms, Classes, Dialogs, Menus, TinyCanDrv, CanCoolDefs;

type
  TCanRxPrototypForm = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  protected
    WidgetAktiv: boolean;
    EventsLocked: boolean; 
    WindowMenuItem: TMenuItem;        
  public
    { Public-Deklarationen }   
    CommandMask: Longword;
    function CheckEventsLock: boolean;
    procedure EventsLock;
    procedure EventsUnlock;
    function ExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer; virtual;
    procedure RxCanMessages(can_msg: PCanFdMsg; count: Integer); virtual;
    procedure RxCanUpdate; virtual;
    procedure SaveConfig(ConfigList: TStrings); virtual;
    procedure LoadConfig(ConfigList: TStrings); virtual;
  end;

implementation

uses MainForm, util;

{$R *.dfm}

{ TEmpfangPrototypForm }

procedure TCanRxPrototypForm.FormCreate(Sender: TObject);
var MenuHandle: HMENU;

begin
CommandMask := SYS_COMMAND;
EventsLocked := False;
WidgetAktiv := True;
WindowMenuItem := TMainWin(owner).MenuMDIClientHinzufuegen(self);
MenuHandle := GetSystemMenu(Self.Handle, False);
DeleteMenu(MenuHandle, 7, MF_BYPOSITION);
DeleteMenu(MenuHandle, 6, MF_BYPOSITION);
DeleteMenu(MenuHandle, 4, MF_BYPOSITION);
end;


procedure TCanRxPrototypForm.FormClose(Sender: TObject; var Action: TCloseAction);

begin
EventsLock;
TMainWin(owner).MenuMDIClientEntfernen(WindowMenuItem);
Action := caFree;
end;


function TCanRxPrototypForm.CheckEventsLock: boolean;

begin;
result := FALSE;
if (not WidgetAktiv) or EventsLocked then
  result := TRUE;
end;  


procedure TCanRxPrototypForm.EventsLock;

begin
RxCanEnterCritical;
EventsLocked := True;
RxCanLeaveCritical;
end;


procedure TCanRxPrototypForm.EventsUnlock;

begin
RxCanEnterCritical;
EventsLocked := False;
RxCanLeaveCritical;
end;


procedure TCanRxPrototypForm.RxCanMessages(can_msg: PCanFdMsg; count: Integer);

begin
  ;
end;


procedure TCanRxPrototypForm.RxCanUpdate;

begin
  ;
end;


procedure TCanRxPrototypForm.LoadConfig(ConfigList: TStrings);

begin
  ;
end;


procedure TCanRxPrototypForm.SaveConfig(ConfigList: TStrings);

begin
  ;
end;


function TCanRxPrototypForm.ExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer;

begin;
result := 0;
end;


procedure TCanRxPrototypForm.FormShow(Sender: TObject);

begin
self.BringToFront;
self.WindowState := wsNormal;
end;

end.
