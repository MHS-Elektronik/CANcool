{***************************************************************************
                         MainForm.pas  -  description
                             -------------------
    begin             : 07.01.2013
    last modified     : 14.10.2022
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
unit MainForm;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, IniFiles, StdCtrls, ExtCtrls, Buttons,
  ToolWin, Grids, StrUtils, ImgList, TinyCanDrv, XLAboutDialog, CanRx, CanRxForm,
  CanCoolDefs, CanTxForm, CanFdTxForm, jpeg, Just1_32, HwInfo, CanTx, XPMan,
  MhsCanUtil;

const
  RX_EVENT: DWORD = $00000001;
  RxMsgBufferSize: Cardinal = 4096;

  CanNSpeedsStrings: array [0..8] of String =
       (' 10 kBit/s',
        ' 20 kBit/s',
        ' 50 kBit/s',
        '100 kBit/s',
        '125 kBit/s',
        '250 kBit/s',
        '500 kBit/s',
        '800 kBit/s',
        '  1 MBit/s');
        
  CanDSpeedStrings: array[0..15] of String =
       ('125 kBit/s',
        '250 kBit/s',
        '500 kBit/s',
        '  1 MBit/s',
        '1,5 MBit/s',
        '  2 MBit/s',
        '  3 MBit/s',
        '  4 MBit/s',
        '  5 MBit/s',
        '  6 MBit/s',
        '  7 MBit/s',
        '  8 MBit/s',
        '  9 MBit/s',
        ' 10 MBit/s',
        ' 11 MBit/s',
        ' 12 MBit/s');

  DrvStatusStrings: array[0..8] of String =
     ('Treiber DLL nicht geladen',                          // Die Treiber DLL wurde noch nicht geladen
      'Treiber nicht Initialisiert ',                       // Treiber noch nicht Initialisiert (Funktion "CanInitDrv" noch nicht aufgerufen)
      'Treiber DLL geladen, CAN Interface nicht verbunden', // Treiber erfolgrich Initialisiert
      'CAN Interface kann nicht geöffnet werden',           // Die Schnittstelle wurde nicht geöffnet
      'System wird Initialisiert ...',                      // Die Schnittstelle wurde geöffnet
      'System wird Initialisiert ...',                      // Verbindung zur Hardware wurde Hergestellt
      'System Online',                                      // Device wurde geöffnet und erfolgreich Initialisiert
      'System Online',                                      // CAN Bus RUN nur Transmitter (wird nicht verwendet !)
      'System Online');                                     // CAN Bus RUN

  CanStatusStrings: array[0..5] of String =
     ('CAN: Ok',                  // Ok
      'CAN: Error',               // CAN Error
      'CAN: Error warning',       // Error warning
      'CAN: Error passiv',        // Error passiv
      'CAN: Bus Off',             // Bus Off
      'CAN: Unbek. Fehler');      // Status Unbekannt

type
  TCanHwStatus = (CanHwClose,
                  CanHwOpen,
                  CanHwError);
                   
  TDataRecord = (RecordStart,  { Aufzeichnung Starten bzw. läuft     }
                 RecordStop,   { Aufzeichnung Stopen                 }
                 RecordOV,     { FIFO Überlauf !                     }
                 RecordLimit); { Empfangslimit Erreicht !            }

  TSyncThread = class;
  TComThread = class;

  TMainWin = class(TForm)
    HauptMenu: TMainMenu;
    DateiMnu: TMenuItem;
    HilfeMnu: TMenuItem;
    Info1: TMenuItem;
    BeendenMnu: TMenuItem;
    ProjectLoadMnu: TMenuItem;
    StatusBar: TStatusBar;
    FensterMnu: TMenuItem;
    ButtonImages: TImageList;
    CANMnu: TMenuItem;
    ConnectImages: TImageList;
    SaveDialog: TSaveDialog;
    ResetMnu: TMenuItem;
    OpenDialog: TOpenDialog;
    ToolBar: TToolBar;
    ToolImageList: TImageList;
    NextMDIMnu: TMenuItem;
    PrevMDIMnu: TMenuItem;
    N6: TMenuItem;
    ProjectSaveMnu: TMenuItem;
    N7: TMenuItem;
    TinyCAN: TTinyCAN;
    NewChildBtn: TToolButton;
    AboutDialog: TXLAboutDialog;
    ProjectLoadBtn: TToolButton;
    ProjectSaveBtn: TToolButton;
    ToolButton3: TToolButton;
    RxDListBtn: TToolButton;
    TxDListBtn: TToolButton;
    ToolButton6: TToolButton;
    SetupBtn: TToolButton;
    ProjectNewNmu: TMenuItem;
    Optionen1: TMenuItem;
    Einstellungen1: TMenuItem;
    RxWinMnu: TMenuItem;
    TxWinMnu: TMenuItem;
    RxTraceViewMnu: TMenuItem;
    RxObjectViewMnu: TMenuItem;
    N1: TMenuItem;
    SaveTraceMnu: TMenuItem;
    N2: TMenuItem;
    RxClearWinMnu: TMenuItem;
    TxLoadMnu: TMenuItem;
    TxSaveMnu: TMenuItem;
    N3: TMenuItem;
    TxClearWinMnu: TMenuItem;
    RxPanelShowMnu: TMenuItem;
    RxStatClearMnu: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    RxShowAllMnu: TMenuItem;
    RxShowUsedMnu: TMenuItem;
    RxShowUnusedMnu: TMenuItem;
    ToolButton1: TToolButton;
    TraceObjListBtn: TToolButton;
    TraceClearBtn: TToolButton;
    TraceSetupBtn: TToolButton;
    TraceStartStopBtn: TToolButton;
    TxIntervallOnBtn: TToolButton;
    TraceSetupPopup: TPopupMenu;
    RxShowAllPopup: TMenuItem;
    RxShowUsedPopup: TMenuItem;
    RxShowUnusedPopup: TMenuItem;
    N8: TMenuItem;
    RxPanelShowPopup: TMenuItem;
    RxStatClearPopup: TMenuItem;
    N9: TMenuItem;
    RxStartStopMnu: TMenuItem;
    N10: TMenuItem;
    ShowToolBarMnu: TMenuItem;
    CanResetBtn: TToolButton;
    LomCheckBtn: TToolButton;
    HwInfoMnu: TMenuItem;
    CanConnMnu: TMenuItem;
    CanConnButton: TToolButton;
    N11: TMenuItem;
    XPManifest1: TXPManifest;
    MhsCanUtil: TMhsCanUtil;
    TCanJustOne: TJustOne32;
    procedure FormCreate(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TinyCANCanStatusEvent(Sender: TObject; index: Cardinal;
      device_status: TDeviceStatus);
    procedure NewChildBtnClick(Sender: TObject);
    procedure ProjectLoadBtnClick(Sender: TObject);
    procedure ProjectSaveBtnClick(Sender: TObject);
    procedure RxDListBtnClick(Sender: TObject);
    procedure TxDListBtnClick(Sender: TObject);
    procedure SetupBtnClick(Sender: TObject);
    procedure BeendenMnuClick(Sender: TObject);
    procedure ResetMnuClick(Sender: TObject);
    procedure NextMDIMnuClick(Sender: TObject);
    procedure PrevMDIMnuClick(Sender: TObject);
    procedure Info1Click(Sender: TObject);
    procedure ProjectNewNmuClick(Sender: TObject);
    procedure RxViewMnuClick(Sender: TObject);
    procedure RxPanelShowMnuClick(Sender: TObject);
    procedure RxShowMnuClick(Sender: TObject);
    procedure TraceSetupBtnClick(Sender: TObject);
    procedure TxIntervallOnBtnClick(Sender: TObject);
    procedure RxStartStopMnuClick(Sender: TObject);
    procedure ShowToolBarMnuClick(Sender: TObject);
    procedure LomCheckBtnClick(Sender: TObject);
    procedure RxPannelShowPopupClick(Sender: TObject);
    procedure RxShowPopupClick(Sender: TObject);
    procedure TinyCANCanPnPEvent(Sender: TObject);
    procedure HwInfoMnuClick(Sender: TObject);
    procedure CmdExecClickMnu(Sender: TObject);
    procedure CanConnMnuClick(Sender: TObject);
  private
    { Private-Deklarationen }
    ComThread: TComThread;
    SyncThread: TSyncThread;
    FEnableTrace: boolean;
    CanApiHandle: Pointer;
    procedure SetEnableTrace(value: Boolean);
    procedure ComThreadTerminate;
    procedure SyncThreadTerminate;
    procedure RefreshStatusBar;
    procedure SetRxObjView;
    procedure SetStartStop;
  public
    { Public-Deklarationen }
    RxPannelShow: boolean;
    RxShowingMode: integer;
    DataRecord: TDataRecord;
    CanHwStatus: TCanHwStatus;
    RxOjectView: boolean;
    DrvStatus: TDrvStatus;
    CanStatus: TCanStatus;
    BusFailure: boolean;
    ProjectFile: String;
    CanRxWin: TCanRxWin;
    CanTxWin: TCanTxWin;
    CanFdTxWin: TCanFdTxWin;
    TinyCanEvent: Pointer;
    TxList: TTxCanList;
    procedure TxWinLoadFile;
    procedure TxWinSaveFile;
    procedure SetupTxWindow;
    procedure RxCanUpdate;
    procedure TxUpdateMessage(msg_idx: Integer);
    function MDIClientNew(ClientForm: TFormClass): TForm;
    function  MenuMDIClientHinzufuegen(Sender: TForm): TMenuItem;
    procedure MenuMDIClientEntfernen(MenuItem: TMenuItem);
    procedure NewProject;
    function LoadProject(filename: String): boolean;
    function SaveProject(filename: String): boolean;
    function SetListenOnly: Integer;
    procedure ConnectHardware;
    procedure DisconnectHardware;
    procedure SetProjectName;
    procedure SetSetup(mode : Integer);
    procedure DisplayHint(Sender: TObject);
    procedure SetRxPannelShow;
    procedure SetRxShowingMode;
    procedure SetHwOpenClose;
    function MainExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer;
    property EnableTrace: Boolean read FEnableTrace write SetEnableTrace;
  end;

  TComThread = class(TThread)
  private
    Owner: TMainWin;
    CanEventsLock: Boolean;
  protected
    procedure Execute; override;
  public
    RxMsgBuffer: PCanFdMsg;
    TinyCanEvent: Pointer;
    procedure DisableCanEvents;
    procedure EnableCanEvents;
    constructor Create(AOwner: TMainWin);
    destructor Destroy; override;
  end;

  TSyncThread = class(TThread)
  private
    EventsLock: Boolean;
    Owner: TMainWin;
    SyncEvent: THandle;
  protected
    procedure SyncFunc;
    procedure Execute; override;
  public
    procedure SetSync;
    procedure DisableSync;
    procedure EnableSync;
    constructor Create(AOwner: TMainWin);
    destructor Destroy; override;
  end;

var
  MainWin: TMainWin;

implementation

{$R *.dfm}                      

uses
  Util, Setup, CanRxPrototyp, CanGaugeForm, CanValueForm, CanBitValueForm, CanBitTxForm,
  CanTermForm, CanDataForm, CanGraph, NewChild;

{ TMainWin }

procedure TMainWin.FormCreate(Sender: TObject);
var cfg: TIniFile;
    //res: Integer; <*>
    //msg_str: String; <*> raus

begin;
InitUtil;
MhsCanUtil.LoadCanUtil;
{res := MhsCanUtil.LoadCanUtil;  <*> raus
if res < 0 then
  begin;
  msg_str := Format('Beim laden der MHS CAN Utilities ist ein Fehler aufgetreten. Fehlercode: %d', [res]);
  MessageDlg(msg_str, mtError, [mbOk], 0);
  end;}
CanApiHandle := nil;  
TxList := TTxCanList.Create(self);
SyncThread := TSyncThread.Create(self);
DataRecord := RecordStop;
CanHwStatus := CanHwClose;
//StatusBar.Font.Style := [];
cfg := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
try
  ProjectFile := cfg.ReadString('GLOBAL', 'ProjectFile', '');
finally
  cfg.Free;
  end;
end;


procedure TMainWin.FormShow(Sender: TObject);
var default_prj_file: boolean;

begin;
{Hilfe in der Statuszeile}
//Application.OnHint:=DisplayHint;
// Project laden
default_prj_file := FALSE;
if ProjectFile = '' then
  begin;
  default_prj_file := TRUE;
  ProjectFile := ChangeFileExt(Application.ExeName, '.prj');
  end;
if LoadProject(ProjectFile) then
  begin;
  if SetupData.AutoHwOpen then
    ConnectHardware;
  end
else
  begin;
  if not default_prj_file then
    ProjectFile := '';
  LoadDefaultSetup;  
  NewProject;
  SetSetup(1);
  end;
if SetupData.AutoTraceStart and (CanHwStatus = CanHwOpen) then
  begin;
  DataRecord := RecordStart;
  SetStartStop;
  end;
SetProjectName;  
RefreshStatusBar;
end;


procedure TMainWin.FormClose(Sender: TObject; var Action: TCloseAction);
var cfg: TIniFile;

begin;
MhsCanUtil.DownCanUtil;
TinyCAN.CanDeviceClose;
ComThreadTerminate;    // muss vor SyncThreadTerminate aufgerufen werden
SyncThreadTerminate;
TinyCAN.DownDriver;
CanApiHandle := nil;
CanRxWin.Show;   // <*> Bgu Fix, MDI Fehler
cfg := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
try
  cfg.WriteString('GLOBAL', 'ProjectFile', ProjectFile);
finally
  cfg.Free;
  end;
// Project speichern
if ProjectFile <> '' then
  begin;
  if not SaveProject(ProjectFile) then
    MessageDlg('Projekt (' + ProjectFile + ') kann nicht gespeichert werden', mtError, [mbOk], 0);
  end;
if Assigned(TxList) then
  FreeAndNil(TxList); // <*> Destroy ?
DestroyUtil;
end;


function TMainWin.MenuMDIClientHinzufuegen(Sender: TForm): TMenuItem;

begin
result := TMenuItem.Create(self);
result.Caption := Sender.Caption;
result.OnClick := Sender.OnShow;
Hauptmenu.Items.Find('Fenster').Add(result);
end;


procedure TMainWin.MenuMDIClientEntfernen(MenuItem: TMenuItem);
var MenuItemIndex: integer;

begin
if assigned(Hauptmenu) then
  begin
  MenuItemIndex := Hauptmenu.Items.Find('Fenster').IndexOf(MenuItem);
  Hauptmenu.Items.Find('Fenster').Delete(MenuItemIndex);
  end;
end;


procedure TMainWin.NewProject;
var form: TForm;
    i: Integer;

begin;
if MDIChildCount > 0 then
  begin;
  for i := 0 to MDIChildCount-1 do
    begin
    form := MDIChildren[i];
    if (form is TCanRxPrototypForm) then
      begin;
      if (form <> CanRxWin) and (form <> CanTxWin) and (form <> CanFdTxWin) then
        TCanRxPrototypForm(form).close;
      end;
    end;
  end;
if not Assigned(CanRxWin) then
  CanRxWin := TCanRxWin(MDIClientNew(TCanRxWin));
CanRxWin.Left := 2;
CanRxWin.Top := 2;
CanRxWin.Width := 110;
CanRxWin.Height := 760;
CanRxWin.Show;
SetupTxWindow;
end;


function TMainWin.LoadProject(filename: String): boolean;
var i: integer;
    ini_file: TIniFile;
    SectionsListe: TStringList;
    ConfigList: TStringList;
    form_class: TClass;
    Form: TForm;

begin
SectionsListe := TStringList.Create;
ConfigList := TStringList.Create;
result := TRUE;
ini_file := TIniFile.Create(filename);
try
  try
    LoadSetup(ini_file);
    NewProject;
    Left := ini_file.ReadInteger('MainWin', 'XPos', 0);
    Top := ini_file.ReadInteger('MainWin', 'YPos', 0);
    Width := ini_file.ReadInteger('MainWin', 'Width', 1100);
    Height := ini_file.ReadInteger('MainWin', 'Height', 760);
    ini_file.ReadSections(SectionsListe);
    for i := SectionsListe.Count - 1 downto 0 do
      begin
      if AnsiStartsText('MDIWin', SectionsListe.Strings[i]) then
        begin
        form_class := GetClass(ini_file.ReadString(SectionsListe.Strings[i], 'Type', ''));
        if form_class <> nil then
          begin
          if form_class = TCanRxWin then          
            form := CanRxWin
          else if form_class = TCanTxWin then
            begin;
            if CanTxWin = nil then
              continue;
            form := CanTxWin;
            end
          else if form_class = TCanFdTxWin then
            begin;
            if CanFdTxWin = nil then
              continue;
            form := CanFdTxWin;
            end            
          else
            form := MDIClientNew(TFormClass(form_class));
          form.Left := ini_file.ReadInteger(SectionsListe.Strings[i], 'XPos', 0);
          form.Top := ini_file.ReadInteger(SectionsListe.Strings[i], 'YPos', 0);
          form.Width := ini_file.ReadInteger(SectionsListe.Strings[i], 'Width', 850);
          form.Height := ini_file.ReadInteger(SectionsListe.Strings[i], 'Height', 350);
          if form is TCanRxPrototypForm then
            begin
            ConfigList.Clear;
            ini_file.ReadSectionValues(SectionsListe.Strings[i], ConfigList);
            TCanRxPrototypForm(Form).LoadConfig(ConfigList);
            end;
          end;
        end;
      end;
  except
    result := FALSE;
    end;        
finally
  ConfigList.Free;
  SectionsListe.Free;
  ini_file.Free;
  end;
TxWinLoadFile;
SetSetup(1);
MainExecuteCmd(SYS_CMD_PRJ_LOAD_FINISH, nil, 0);
end;


function TMainWin.SaveProject(filename: String): boolean;
var i, j: integer;
    ini_file: TIniFile;
    IniSections: TStringList;
    ConfigList: TStringList;
    Form: TForm;
    name: String;

begin
result := TRUE;
if MDIChildCount > 0 then
  begin;
  for i := 0 to MDIChildCount-1 do
    self.MDIChildren[i].WindowState := wsNormal;
  Application.ProcessMessages;
  end;
TxWinSaveFile;
ConfigList := TStringList.Create;
ini_file := TIniFile.Create(filename);
try
  try
    SaveSetup(ini_file);
    ini_file.WriteInteger('MainWin', 'XPos', Left);
    ini_file.WriteInteger('MainWin', 'YPos', Top);
    ini_file.WriteInteger('MainWin', 'Width', Width);
    ini_file.WriteInteger('MainWin', 'Height', Height);

    IniSections := TStringList.Create;
    ini_file.ReadSections(IniSections);
    for i := 0 to IniSections.Count - 1 do
      begin
      if AnsiStartsText('MDIWin', IniSections.Strings[i]) then
        begin
        ini_file.EraseSection(IniSections.Strings[i]);
        end;
      end;
    IniSections.Free;
    if MDIChildCount > 0 then
      begin;
      for i := 0 to MDIChildCount-1 do
        begin
        Form := self.MDIChildren[i];
        ini_file.WriteString(format('MDIWin%u',[i]), 'Type', Form.ClassName);
        ini_file.WriteInteger(format('MDIWin%u',[i]), 'XPos', Form.Left);
        ini_file.WriteInteger(format('MDIWin%u',[i]), 'YPos', Form.Top);
        ini_file.WriteInteger(format('MDIWin%u',[i]), 'Width', Form.Width);
        ini_file.WriteInteger(format('MDIWin%u',[i]), 'Height', Form.Height);
        if Form is TCanRxPrototypForm then
          begin
          ConfigList.Clear;
          TCanRxPrototypForm(Form).SaveConfig(ConfigList);
          for j := 0 to ConfigList.Count - 1 do
            begin;
            name := ConfigList.Names[j];
            ini_file.WriteString(format('MDIWin%u',[i]), name, ConfigList.Values[name]);
            end;
          end;
        end;
      end;
  except
    result := FALSE;
    end;
finally
  ConfigList.Free;
  ini_file.Free;
  end;
end;


function TMainWin.SetListenOnly: Integer;

begin;
if CanHwStatus = CanHwOpen then
  begin;
  if SetupData.ListenOnly then
    result := TinyCAN.CanSetMode(0, OP_CAN_START_LOM, CAN_CMD_ALL_CLEAR)
  else
    result := TinyCAN.CanSetMode(0, OP_CAN_START, CAN_CMD_ALL_CLEAR);
  end
else
  result := 0;
end;


procedure TMainWin.SetProjectName;
begin;
if ProjectFile = '' then
  MainWin.Caption := 'CANcool - Kein Project geladen' 
else
  MainWin.Caption := 'CANcool - ' + ExtractFileName(ProjectFile);
end;


procedure TMainWin.SetSetup(mode : Integer);
var trace_clear: boolean;
    max_clumps: Integer;
    open_run: Integer;
    res: Integer;    
    //msg_str: String; <*> raus

begin;
trace_clear := FALSE;
if CanHwStatus = CanHwOpen then
  open_run := 1
else
  open_run := 0;
if Assigned(ComThread) then
  ComThread.DisableCanEvents;
SyncThread.DisableSync;
if mode > 0 then
  begin;
  trace_clear := TRUE;
  ComThreadTerminate;
  DisconnectHardware;
  MhsCanUtil.CanUtilRegisterDriver(CanApiHandle, 0);
  if SetupData.Driver = 0 then
    begin;
    TinyCAN.TreiberName := 'mhstcan.dll';      // Tiny-CAN
    TinyCan.DeviceName := '';
    end
  else if SetupData.Driver = 1 then
    begin;
    TinyCAN.TreiberName := 'mhsslcan.dll';     // SL-CAN
    TinyCan.DeviceName := '';
    end
  else
    begin;
    TinyCAN.TreiberName := 'mhspassthru.dll'; // PassThru
    TinyCan.DeviceName := SetupData.DeviceName;
    end;
  TinyCan.InterfaceType := TInterfaceType(SetupData.InterfaceType);
  TinyCan.Port := SetupData.Port;
  if (SetupData.Driver = 0) and (TinyCan.InterfaceType = INTERFACE_USB) then
    TinyCan.BaudRate := SER_AUTO_BAUD
  else
    TinyCan.BaudRate := TSerialBaudRate(SetupData.BaudRate+1);
  TinyCan.DeviceSnr := SetupData.HardwareSnr;
  //TinyCan.FdMode := SetupData.CanFd; <*> raus
  TinyCan.CanFifoOvClear := SetupData.CanFifoOvClear;
  TinyCan.CanFifoOvMessages := SetupData.CanFifoOvMessages;
  
  if TinyCAN.LoadDriver = 0 then
    begin
    res := TinyCan.MhsCanGetApiHandle(@CanApiHandle);
    if res > 0 then
      begin
      MhsCanUtil.CanUtilRegisterDriver(CanApiHandle, res);
      {res := MhsCanUtil.CanUtilRegisterDriver(CanApiHandle, res); <*> raus
      if res < 0 then
        begin;
        msg_str := Format('Beim "CanUtilRegisterDriver" ist ein Fehler aufgetreten. Fehlercode: %d', [res]);
        MessageDlg(msg_str, mtError, [mbOk], 0);
        end;}
      end;
    TinyCanEvent := TinyCAN.CanExCreateEvent;
    TinyCAN.CanExCreateFifo($80000000, 30000, TinyCanEvent, RX_EVENT, $FFFFFFFF);
    ComThread := TComThread.Create(self);
    if open_run > 0 then
      open_run := 2;
    end;
  end;
SetupTxWindow();
//CanRxWin.SetSetup;<*>
if Assigned(CanRxWin) then
  begin
  CanRxWin.RxList.FdMode := SetupData.CanFd;
  if CanRxWin.RxList.ClumpSize <> SetupData.RxDBufferSize then
    trace_clear := TRUE;
  if SetupData.RxDEnableDynamic then
    max_clumps := SetupData.RxDLimit
  else
    max_clumps := 1;
  if max_clumps <> CanRxWin.RxList.MaxClumps then
    trace_clear := TRUE;
  if trace_clear then
    begin;
    //MainExecuteCmd(RX_WIN_STOP_TRACE, nil, 0); <*>
    EnableTrace := FALSE;
    MainExecuteCmd(RX_WIN_CLEAR, nil, 0);
    end;
  CanRxWin.RxList.ClumpSize := SetupData.RxDBufferSize;
  if SetupData.RxDEnableDynamic then
    CanRxWin.RxList.MaxClumps := SetupData.RxDLimit
  else
    CanRxWin.RxList.MaxClumps := 1;
  end;
MainExecuteCmd(SYS_CMD_SET_SETUP, nil, 0);  // <*> neu
TinyCan.CanClockIndex := SetupData.CanClockIndex;
TinyCan.CanSpeed := TCanSpeed(SetupData.CANSpeed);  
TinyCan.CanSpeedBtr := SetupData.NBTRValue;
TinyCan.CanFdSpeed := TCanFdSpeed(SetupData.CANDataSpeed);
TinyCan.CanFdDbtr := SetupData.DBTRValue;
if SetupData.ShowErrorMessages then
  TinyCan.OptionsStr := 'CanErrorMsgsEnable=1'
else
  TinyCan.OptionsStr := 'CanErrorMsgsEnable=0';   
LomCheckBtn.Down := SetupData.ListenOnly;
TinyCan.CanSetOptions;
if open_run = 2 then
  ConnectHardware
else
  SetListenOnly;
if Assigned(ComThread) then
  ComThread.EnableCanEvents;
SyncThread.EnableSync;
if SetupData.AutoTraceStart and (CanHwStatus = CanHwOpen) then
  begin;
  DataRecord := RecordStart;
  SetStartStop;
  end;
RefreshStatusBar;
end;


procedure TMainWin.SetupTxWindow;
begin;
if SetupData.CanFd then
  begin;
  // *** CAN Tx Window löschen
  if CanTxWin <> nil then
    begin;
    TCanRxPrototypForm(CanTxWin).close;
    CanTxWin := nil;
    end;
  // *** CAN-FD Tx Window erzeugen/anzeigen  
  if CanFdTxWin <> nil then
    begin;
    CanFdTxWin.BringToFront;
    CanFdTxWin.WindowState := wsNormal;
    end
  else
    begin;
    CanFdTxWin := TCanFdTxWin(MDIClientNew(TCanFdTxWin));
    TxList.FdMode := TRUE;
    CanFdTxWin.SetTxList(TxList);
    CanFdTxWin.Left := 2;
    CanFdTxWin.Top := 309;
    CanFdTxWin.Width := 880;
    CanFdTxWin.Height := 254;
    CanFdTxWin.Show;
    end;
  end
else
  begin
  if CanFdTxWin <> nil then
    begin;
    TCanRxPrototypForm(CanFdTxWin).close;
    CanFdTxWin := nil;
    end;
  // *** CAN Tx Window erzeugen/anzeigen
  if CanTxWin <> nil then
    begin;
    CanTxWin.BringToFront;
    CanTxWin.WindowState := wsNormal;
    end
  else
    begin
    CanTxWin := TCanTxWin(MDIClientNew(TCanTxWin));
    TxList.FdMode := FALSE;
    CanTxWin.SetTxList(TxList);
    CanTxWin.Left := 2;
    CanTxWin.Top := 309;
    CanTxWin.Width := 880;
    CanTxWin.Height := 254;
    CanTxWin.Show;    
    end;
  end;
end;


function TMainWin.MDIClientNew(ClientForm: TFormClass): TForm;
begin;
result:=ClientForm.Create(self);
end;


procedure TMainWin.StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
var stat: Integer;
    str: String;

begin
  if Panel.ID = 0 then
  begin
    if DrvStatus >= DRV_STATUS_CAN_RUN then
      stat := 1
    else
      stat := 0;      
    ConnectImages.Draw(StatusBar.Canvas, Rect.Left+1, Rect.Top, stat);
    if SetupData.CANSpeed = 0 then
      str := SetupData.NBTRBitrate
    else
      str := CanNSpeedsStrings[SetupData.CANSpeed - 1];
    if SetupData.CanFd then
      begin;
      if SetupData.CANDataSpeed = 0 then
        str := str + ' [' + SetupData.DBTRBitrate + ']'
      else
        str := str + ' [' + CanDSpeedStrings[SetupData.CANDataSpeed - 1] + ']';
      end;                  
   StatusBar.Canvas.TextOut(Rect.Left + ConnectImages.Width + 5, Rect.Top + 1, str);      
  end;
end;


procedure TMainWin.RefreshStatusBar;
begin
if BusFailure then
  StatusBar.Panels[1].Text := CanStatusStrings[ord(CanStatus)] + ' [BUS-FAILURE]'
else
  StatusBar.Panels[1].Text := CanStatusStrings[ord(CanStatus)];
StatusBar.Panels[2].Text := DrvStatusStrings[ord(DrvStatus)];
StatusBar.Refresh;
end;


{**************************************************************}
{* Hilfe in der Status Zeile anzeigen                         *}
{**************************************************************}
procedure TMainWin.DisplayHint(Sender: TObject);

begin;
if Application.Hint <> '' then
  begin;
  StatusBar.SimplePanel := True;
  StatusBar.SimpleText := Application.Hint;
  end
else
  RefreshStatusBar;  
end;


procedure TMainWin.TinyCANCanStatusEvent(Sender: TObject;
  index: Cardinal; device_status: TDeviceStatus);
begin
DrvStatus := device_status.DrvStatus;
CanStatus := device_status.CanStatus;
BusFailure := device_status.BusFailure;
if DrvStatus < DRV_STATUS_CAN_RUN then
  begin
  if DataRecord in [RecordStart, RecordOV] then
    begin
    DataRecord := RecordStop;
    SetStartStop;
    end;
  end;
RefreshStatusBar;
end;


procedure TMainWin.NewChildBtnClick(Sender: TObject);
var form: TNewChildForm;

begin
form := TNewChildForm.Create(self);
form.Left := self.Left;
form.Top := self.Top + ToolBar.Height;
form.ShowModal;
form.Free;
end;


procedure TMainWin.ProjectLoadBtnClick(Sender: TObject);

begin
OpenDialog.FileName := ProjectFile;
if OpenDialog.Execute then
  begin;
  ProjectFile := OpenDialog.FileName;
  if ProjectFile <> '' then
    begin;  
    if not LoadProject(ProjectFile) then
      begin;
      MessageDlg('Projekt (' + ProjectFile + ') kann nicht geladen werden', mtError, [mbOk], 0);
      ProjectFile := '';
      end;
    end;
  end;
SetProjectName;  
end;


procedure TMainWin.ProjectSaveBtnClick(Sender: TObject);

begin
SaveDialog.FileName := ProjectFile;
if SaveDialog.Execute then
  begin;
  ProjectFile := SaveDialog.FileName;
  if ProjectFile <> '' then
    begin;
    if not SaveProject(ProjectFile) then
      MessageDlg('Projekt (' + ProjectFile + ') kann nicht gespeichert werden', mtError, [mbOk], 0);
    end;
  end;
SetProjectName;
end;


procedure TMainWin.RxDListBtnClick(Sender: TObject);

begin
CanRxWin.BringToFront;
CanRxWin.WindowState := wsNormal;
end;


procedure TMainWin.TxDListBtnClick(Sender: TObject);

begin
if SetupData.CanFd then
  begin;
  CanFdTxWin.BringToFront;
  CanFdTxWin.WindowState := wsNormal;
  end
else
  begin;
  CanTxWin.BringToFront;
  CanTxWin.WindowState := wsNormal;
  end;  
end;


procedure TMainWin.SetupBtnClick(Sender: TObject);
var
  setup_win: TSetupForm;
  i : Integer;

begin
setup_win := TSetupForm.Create(self);
i := setup_win.Execute;
setup_win.Free;
if i > -1 then
  SetSetup(i);
end;


procedure TMainWin.BeendenMnuClick(Sender: TObject);

begin
close;
end;


procedure TMainWin.ResetMnuClick(Sender: TObject);

begin
if CanHwStatus = CanHwOpen then
  begin;
  TinyCAN.CanSetMode(0, OP_CAN_RESET, CAN_CMD_RXD_FIFOS_CLEAR or CAN_CMD_TXD_FIFOS_CLEAR);
  RefreshStatusBar;
  end;
end;


procedure TMainWin.NextMDIMnuClick(Sender: TObject);

begin
self.Next;
end;


procedure TMainWin.PrevMDIMnuClick(Sender: TObject);

begin
self.Previous;
end;


procedure TMainWin.Info1Click(Sender: TObject);

begin
AboutDialog.Execute;
end;


procedure TMainWin.ProjectNewNmuClick(Sender: TObject);

begin
NewProject;
ProjectFile := '';
SaveDialog.FileName := '';
if SaveDialog.Execute then
  begin;
  ProjectFile := SaveDialog.FileName;
  if ProjectFile <> '' then
    begin;
    if not SaveProject(ProjectFile) then
      begin;
      MessageDlg('Projekt (' + ProjectFile + ') kann nicht gespeichert werden', mtError, [mbOk], 0);
      ProjectFile := '';
      end;
    end;
  end;
SetProjectName;
end;


procedure TMainWin.RxViewMnuClick(Sender: TObject);
begin
if RxOjectView then
  RxOjectView := False
else
  RxOjectView := True;
SetRxObjView;
end;


procedure TMainWin.SetRxPannelShow;

begin;
RxPanelShowMnu.Checked := RxPannelShow;
RxPanelShowPopup.Checked := RxPannelShow;
if Assigned(CanRxWin) then
  begin;
  if RxPannelShow then
    MainExecuteCmd(RX_WIN_SHOW_RX_PANNEL, nil, 0)
  else
    MainExecuteCmd(RX_WIN_HIDE_RX_PANNEL, nil, 0);
  end;
end;


procedure TMainWin.RxPanelShowMnuClick(Sender: TObject);
begin
RxPannelShow := RxPanelShowMnu.Checked;
SetRxPannelShow;
end;


procedure TMainWin.RxPannelShowPopupClick(Sender: TObject);

begin
RxPannelShow := RxPanelShowPopup.Checked;
SetRxPannelShow;
end;


procedure TMainWin.SetRxShowingMode;

begin;
if RxShowingMode = 1 then
  begin;
  RxShowUsedMnu.Checked := True;
  RxShowUsedPopup.Checked := True;
  end
else if RxShowingMode = 2 then
  begin;
  RxShowUnusedMnu.Checked := True;
  RxShowUnusedPopup.Checked := True;
  end
else
  begin;
  RxShowAllMnu.Checked := True;
  RxShowAllPopup.Checked := True;
  end;
if Assigned(CanRxWin) then
  begin;
  if RxShowingMode = 1 then
    MainExecuteCmd(RX_WIN_SHOW_USED_MSG, nil, 0)
  else if RxShowingMode = 2 then
    MainExecuteCmd(RX_WIN_SHOW_UNUSED_MSG, nil, 0)
  else
    MainExecuteCmd(RX_WIN_SHOW_ALL_MSG, nil, 0);
  end;
end;


procedure TMainWin.ConnectHardware;

begin;
if CanHwStatus <> CanHwOpen then
  begin;
  CanHwStatus := CanHwOpen;
  SetHwOpenClose;
  end;
end;


procedure TMainWin.DisconnectHardware;

begin;
CanHwStatus := CanHwClose;
SetHwOpenClose;
end;


procedure TMainWin.SetHwOpenClose;
var res: Integer;

begin
if CanHwStatus in [CanHwOpen, CanHwError] then
  begin;
  res := TinyCAN.CanDeviceOpen;
  if res > -1 then
    res := SetListenOnly;  
  if res < 0 then
    begin;
    MessageDlg('Fehler beim öffnen des Device', mtError, [mbOk], 0);
    CanHwStatus := CanHwError;
    end;
  end
else
  TinyCAN.CanDeviceClose;
if CanHwStatus = CanHwOpen then
  begin;
  // Buttom
  CanConnButton.Down := True;
  CanConnButton.ImageIndex := 15;
  CanConnButton.Caption := 'Verbunden';
  // Menue
  CanConnMnu.Caption := 'CAN trennen';
  end
else
  begin;
  // Buttom
  CanConnButton.Down := False;
  CanConnButton.ImageIndex := 16;
  CanConnButton.Caption := 'Getrennt';
  // Menue
  CanConnMnu.Caption := 'CAN verbinden';
  end;
RefreshStatusBar;
end;


function TMainWin.MainExecuteCmd(cmd: Longword; can_msg: PCanFdMsg; param1: Integer): Integer;
var i: DWORD;
    form: TForm;

begin
result := 0;
if MDIChildCount > 0 then
  begin;
  for i := 0 to MDIChildCount - 1 do
    begin
    form := MDIChildren[i];
    if (form is TCanRxPrototypForm) then
      begin;
      if not TCanRxPrototypForm(form).CheckEventsLock then
        begin; 
        if (TCanRxPrototypForm(form).CommandMask and cmd) > 0 then
          begin;
          if TCanRxPrototypForm(form).ExecuteCmd(cmd, can_msg, param1) < 0 then
            result := -1;
          end;  
        end;  
      end;
    end;
  end;  
end;


procedure TMainWin.RxShowMnuClick(Sender: TObject);

begin
if RxShowUsedMnu.Checked then
  RxShowingMode := 1
else if RxShowUnusedMnu.Checked then
  RxShowingMode := 2
else
  RxShowingMode := 0;
SetRxShowingMode;
end;


procedure TMainWin.RxShowPopupClick(Sender: TObject);
begin
if RxShowUsedPopup.Checked then
  RxShowingMode := 1
else if RxShowUnusedPopup.Checked then
  RxShowingMode := 2
else
  RxShowingMode := 0;
SetRxShowingMode;
end;


procedure TMainWin.CanConnMnuClick(Sender: TObject);

begin
if CanHwStatus in [CanHwClose, CanHwError] then
  CanHwStatus := CanHwOpen
else
  CanHwStatus := CanHwClose;                                  
SetHwOpenClose;
if SetupData.AutoTraceStart and (CanHwStatus = CanHwOpen) then
  begin;
  DataRecord := RecordStart;
  SetStartStop;
  end;
end;


procedure TMainWin.CmdExecClickMnu(Sender: TObject);
var cmd: Longword;

begin
cmd := TMenuItem(Sender).Tag;
MainExecuteCmd(cmd, nil, 0);
end;


procedure TMainWin.TxUpdateMessage(msg_idx: Integer);
begin
if SetupData.CanFd then
  begin;
  if Assigned(CanFdTxWin) then
    CanFdTxWin.ExecuteCmd(TX_WIN_UPDATE_MSG, nil, msg_idx);
  end
else 
  begin;
  if Assigned(CanTxWin) then
    CanTxWin.ExecuteCmd(TX_WIN_UPDATE_MSG, nil, msg_idx);
  end; 
end;


procedure TMainWin.TxWinLoadFile;
begin
MainExecuteCmd(TX_WIN_LOAD_FILE, nil, 0);
end;


procedure TMainWin.TxWinSaveFile;
begin
MainExecuteCmd(TX_WIN_SAVE_FILE, nil, 0);
end;

  
procedure TMainWin.SetRxObjView;

begin;
if RxOjectView then
  begin;
  TraceObjListBtn.Down := True;
  RxObjectViewMnu.Checked := True;
  if Assigned(CanRxWin) then
    MainExecuteCmd(RX_WIN_SHOW_OBJECT, nil, 0);
  end
else
  begin;
  TraceObjListBtn.Down := False;
  RxTraceViewMnu.Checked := True;
  if Assigned(CanRxWin) then
    MainExecuteCmd(RX_WIN_SHOW_TRACE, nil, 0);
  end;
end;


procedure TMainWin.SetEnableTrace(value: Boolean);

begin;
FEnableTrace := value;
if FEnableTrace then
  begin;
  // **** Enable Trace
  // Button
  TraceStartStopBtn.Down := True;
  TraceStartStopBtn.ImageIndex := 10;
  TraceStartStopBtn.Caption := 'Stop';
  // Menü
  RxStartStopMnu.Caption := 'Aufzeichnung stoppen';  
  // Setup sperren
  SetupBtn.Enabled := False;
  Einstellungen1.Enabled := False;  
  MainExecuteCmd(RX_WIN_START_TRACE, nil, 0);
  end
else
  begin;
  // **** Disable Trace
  // Button
  TraceStartStopBtn.Down := False;
  TraceStartStopBtn.ImageIndex := 9;
  TraceStartStopBtn.Caption := 'Start';
  // Menü
  RxStartStopMnu.Caption := 'Aufzeichnung starten';  
  // Setup freigeben
  SetupBtn.Enabled := True;
  Einstellungen1.Enabled := True;
  MainExecuteCmd(RX_WIN_STOP_TRACE, nil, 0);
  end;
end;


procedure TMainWin.SetStartStop;
var clear_data: boolean;

begin;
clear_data := FALSE;
if not Assigned(CanRxWin) then
  exit;
if DataRecord in [RecordStart, RecordOV] then
  begin;
  if SetupData.DataClearMode = 0 then
    clear_data := TRUE
  else if SetupData.DataClearMode = 1 then
    begin;
    if CanRxWin.RxList.Count > 0 then
      begin;
      if MessageDlg('Trace Daten löschen ?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
        clear_data := TRUE;
      end;
    end;
  if clear_data then
    MainExecuteCmd(RX_WIN_CLEAR, nil, 0);
  EnableTrace := TRUE;
  end
else
  EnableTrace := FALSE;
end;


procedure TMainWin.TraceSetupBtnClick(Sender: TObject);
begin
TraceSetupBtn.CheckMenuDropdown;
end;


procedure TMainWin.TxIntervallOnBtnClick(Sender: TObject);
var cmd: Integer;

begin
if TxIntervallOnBtn.Down then
  cmd := TX_WIN_ENABLE_INTERVALL
else
  cmd := TX_WIN_DISABLE_INTERVALL;
if SetupData.CanFd then   
  begin;
  if Assigned(CanFdTxWin) then
    CanFdTxWin.ExecuteCmd(cmd, nil, 0);
  end
else
  begin;
  if Assigned(CanTxWin) then
    CanTxWin.ExecuteCmd(cmd, nil, 0);
  end;
end;


procedure TMainWin.RxStartStopMnuClick(Sender: TObject);

begin
if DataRecord in [RecordStart, RecordOV] then
  DataRecord := RecordStop
else
  DataRecord := RecordStart;
SetStartStop;
end;


procedure TMainWin.ShowToolBarMnuClick(Sender: TObject);

begin
if ShowToolBarMnu.Checked then
  ToolBar.Show
else
  ToolBar.Hide;
end;


procedure TMainWin.LomCheckBtnClick(Sender: TObject);

begin
SetupData.ListenOnly := LomCheckBtn.Down;
SetListenOnly;
end;


procedure TMainWin.ComThreadTerminate;

begin
if Assigned(ComThread) then
  begin
  ComThread.Destroy;
  ComThread := nil;
  end;
end;


{ TComThread }

constructor TComThread.Create(AOwner: TMainWin);
begin
inherited Create(True);  // Thread erzeugen nicht starten
Owner := AOwner;
CanEventsLock := TRUE;
//Priority := tpHighest;
Priority := tpHigher;
CanEventsLock := False;
FreeOnTerminate := false;
Resume;                  // Thread starten
end;


destructor TComThread.Destroy;

begin
if not Terminated then
  begin
  Terminate;
  if Owner <> nil then
    begin
    if Owner.TinyCAN <> nil then
      Owner.TinyCAN.CanExSetEvent(Owner.TinyCanEvent, MHS_EVENT_TERMINATE);
    end;
  end;
inherited;
end;


procedure TComThread.DisableCanEvents;

begin;
RxCanEnterCritical;
CanEventsLock := TRUE;
RxCanLeaveCritical;
end;


procedure TComThread.EnableCanEvents;

begin;
RxCanEnterCritical;
CanEventsLock := FALSE;
RxCanLeaveCritical;
end;


procedure TComThread.Execute;
var
  i, event: DWORD;
  count: Integer;
  form: TForm;     

begin
inherited;
RxMsgBuffer := AllocMem(RxMsgBufferSize * SizeOf(TCanFdMsg));
while not Terminated do
  begin
  event := Owner.TinyCAN.CanExWaitForEvent(Owner.TinyCanEvent, 0);
  if (event and $80000000) > 0 then
    break;
  if event = RX_EVENT then
    begin;    
    count := Owner.TinyCAN.CanFdReceive($80000000, RxMsgBuffer, RxMsgBufferSize);
    if count > 0 then
      begin;
      RxCanEnterCritical;
      if CanEventsLock then
        begin;
        RxCanLeaveCritical;
        continue;
        end;
      if Owner.MDIChildCount > 0 then
        begin;
        for i := 0 to Owner.MDIChildCount-1 do
          begin
          form := Owner.MDIChildren[i];
          if (form is TCanRxPrototypForm) then
            begin;                  
            if not TCanRxPrototypForm(form).CheckEventsLock then
              begin;
              if (form <> Owner.CanRxWin) and (form <> Owner.CanTxWin) and (form <> Owner.CanFdTxWin) then
                TCanRxPrototypForm(form).RxCanMessages(RxMsgBuffer, count);
              end;  
            end;
          end;
        if Owner.CanRxWin <> nil then
          Owner.CanRxWin.RxCanMessages(RxMsgBuffer, count);
        if SetupData.CanFd then
          begin;
          if Owner.CanFdTxWin <> nil then
            Owner.CanFdTxWin.RxCanMessages(RxMsgBuffer, count);
          end  
        else    
          begin;    
          if Owner.CanTxWin <> nil then
            Owner.CanTxWin.RxCanMessages(RxMsgBuffer, count);
          end;  
        end;
      RxCanLeaveCritical;
      if Owner.SyncThread <> nil then
        Owner.SyncThread.SetSync;
      end;
    end;
  end;
FreeMem(RxMsgBuffer);      
end;


procedure TMainWin.SyncThreadTerminate;

begin
if Assigned(SyncThread) then
  begin
  SetEvent(SyncThread.SyncEvent);
  SyncThread.Destroy;
  SyncThread := nil;
  end;
end;


procedure TMainWin.RxCanUpdate;
var i: DWORD;
    form: TForm;

begin
if MDIChildCount > 0 then
  begin;
  for i := 0 to MDIChildCount - 1 do
    begin
    form := MDIChildren[i];
    if (form is TCanRxPrototypForm) then
      begin;
      if not TCanRxPrototypForm(form).CheckEventsLock then
        begin;
        if (form <> CanRxWin) and (form <> CanTxWin) and (form <> CanFdTxWin) then
          TCanRxPrototypForm(form).RxCanUpdate;
        end;  
      end;
    end;
  if CanRxWin <> nil then
    CanRxWin.RxCanUpdate;    
  if SetupData.CanFd then  
    begin;  
    if CanFdTxWin <> nil then
      CanFdTxWin.RxCanUpdate;
    end
  else
    begin;      
    if CanTxWin <> nil then
      CanTxWin.RxCanUpdate;
    end;  
  end;
end;

{ TSyncThread }

constructor TSyncThread.Create(AOwner: TMainWin);
  
begin
inherited Create(True);  // Thread erzeugen nicht starten
Owner := AOwner;
SyncEvent := CreateEvent(nil, false, false, 'CAN_SYNC_EVENT');
if SyncEvent = 0 then
  raise Exception.Create('Unable to create SYNC_EVENT');
EventsLock := TRUE;
Priority := tpLower;
FreeOnTerminate := FALSE;
Resume;                  // Thread starten
end;


destructor TSyncThread.Destroy;

begin
EventsLock := TRUE;
if not Terminated then
  begin
  Terminate;
  SetEvent(SyncEvent);
  end;
inherited;
end;


procedure TSyncThread.DisableSync; 

begin;
EventsLock := TRUE;
end;


procedure TSyncThread.EnableSync; 

begin;
EventsLock := FALSE;
end;


procedure TSyncThread.SetSync;

begin
SetEvent(SyncEvent);
end;


procedure TSyncThread.SyncFunc;
 
begin; 
if not EventsLock then
  Owner.RxCanUpdate;
end;


procedure TSyncThread.Execute;
begin
while not Terminated do
  begin
  WaitForSingleObject(SyncEvent, INFINITE);
  if Terminated then
    break;      
  Synchronize(SyncFunc);
  Sleep(100);  // 100 ms Pause
  end;
CloseHandle(SyncEvent);  
end;


procedure TMainWin.TinyCANCanPnPEvent(Sender: TObject);

begin
RefreshStatusBar;
end;


procedure TMainWin.HwInfoMnuClick(Sender: TObject);
var info_list: TCanInfoVarObj;
    device_info: TCanDeviceInfo;

begin
info_list := TinyCAN.CanExGetDeviceInfo(TinyCan.DeviceIndex, device_info);
if info_list = nil then
  exit;
HwInfoForm.Execute(info_list, 'Hardware Info');
end;


initialization
  RegisterClasses([TCanRxWin, TCanTxWin, TCanFdTxWin,
        TCanGaugeWin, TCanBitValueWin, TCanBitTxWin,
        TCanValueWin, TCanTermWin, TCanDataWin, TCanGraphWin]);

end.
