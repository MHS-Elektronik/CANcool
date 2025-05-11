{***************************************************************************
                          Setup.pas  -  description
                             -------------------
    begin             : 07.01.2013
    last modify       : 31.07.2022
    copyright         : (C) 2013 - 2022 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit setup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, IniFiles, Longedit, zahlen, zahlen32, Contnrs,
  TinyCanDrv, ImgList, util, CanCoolDefs, MhsCanUtil;

type
  TSetupData = record
                   { Abschnitt: Hardware }
                Driver: Integer;   { => 0 = Tiny-CAN                    }
                                   {    1 = SL-CAN                      }
                                   {    2 = PassThru                    }
                DeviceName: String;{ PassThru Device Name               }                   
                Port: Integer;     { => 1 = COM1                        }
                                   {    2 = COM2                        }
                                   {    3 = COM3                        }
                                   {    4 = COM4                        }
                                   {    5 = COM5                        }
                                   {    6 = COM6                        }
                                   {    7 = COM7                        }
                                   {    8 = COM8                        }
                BaudRate: Integer;
                InterfaceType: Integer; { 0 = USB                       }
                                        { 1 = RS232                     }
                HardwareSnr: String;
                CANSpeed: Integer; { => 0 = Benutzerdefiniert 
                                   {    1 = 10kBit/s                    }
                                   {    2 = 20kBit/s                    }
                                   {    3 = 50kBit/s                    }
                                   {    4 = 100 kBit/s                  }
                                   {    5 = 125 kBit/s                  }
                                   {    6 = 250 kBit/s                  }
                                   {    7 = 500 kBit/s                  }
                                   {    8 = 800 kBit/s                  }
                                   {    9 = 1 MBit/s                    }
                CANDataSpeed: Integer; { => 0  = Benutzerdefiniert
                                       {    1  = 125 kBit/s             }
                                       {    2  = 250 kBit/s             }
                                       {    3  = 500 kBit/s             }
                                       {    4  = 1 Bit/s                }
                                       {    5  = 1,5 MBit/s             }
                                       {    6  = 2 MBit/s               }
                                       {    7  = 3 MBit/s               }
                                       {    8  = 4 MBit/s               }
                                       {    9  = 5 MBit/s               }
                                       {    10 = 6 MBit/s               }
                                       {    11 = 7 MBit/s               }
                                       {    12 = 8 MBit/s               }
                                       {    13 = 9 MBit/s               }
                                       {    14 = 10 MBit/s              }
                                       {    15 = 11 MBit/s              }
                                       {    16 = 12 MBit/s              }
               CanClockIndex: Byte;
               NBTRValue: Integer;
               NBTRBitrate: String;
               NBTRDesc: String;               
               DBTRValue: Integer;
               DBTRBitrate: String;
               DBTRDesc: String;
               AutoHwOpen: Boolean;
               AutoTraceStart: Boolean;
               ListenOnly: Boolean;
               ShowErrorMessages: Boolean;
               CanFd: Boolean;
               CanFifoOvClear: Boolean;
               CanFifoOvMessages: Boolean;
               DataClearMode: Integer; { 0 = Automatisch löschen        }
                                       { 1 = Benutzer fragen            }
                                       { 2 = nicht löschen              }
               RxDBufferSize: Longint;
               RxDEnableDynamic: Boolean;
               RxDLimit: Longint;
               TraceDefColor: TColor;
               TraceHitColor: TColor;
               TraceErrorColor: TColor;
               TraceStatusColor: TColor;
               TraceFont: TFontDesc;
               TxListFile: String;
               end;


  TSetupForm = class(TForm)
    Panel1: TPanel;
    SetupOkBtn: TButton;
    SetupBreakBtn: TButton;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    CANSpeedEdit: TRadioGroup;
    TabSheet3: TTabSheet;
    DataClearModeGrp: TRadioGroup;
    Label2: TLabel;
    RxDBufferSizeEdit: TLongIntEdit;
    Label3: TLabel;
    TabSheet1: TTabSheet;
    DriverEdit: TRadioGroup;
    LomCheckBox: TCheckBox;
    ShowErrMsgCheckBox: TCheckBox;
    RxDEnableDynamicCheckBox: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    RxDLimitEdit: TLongIntEdit;
    CanFdCheckBox: TCheckBox;
    CANDataSpeedEdit: TRadioGroup;
    NBTRStr: TLabel;
    NBTRHexStr: TLabel;
    DBTRHexStr: TLabel;
    DBTRStr: TLabel;
    CustomNBTRSetupBtn: TButton;
    CustomDBTRSetupBtn: TButton;
    NBTRDescEdit: TEdit;
    DBTRDescEdit: TEdit;
    NBTREdit: TZahlen32Edit;
    DBTREdit: TZahlen32Edit;
    NBTRBitrateEdit: TEdit;
    NBTRBitrateStr: TLabel;
    DBTRBitrateEdit: TEdit;
    DBTRBitrateStr: TLabel;
    Bevel1: TBevel;
    CanFifoOvClearBox: TCheckBox;
    CanFifoOvMessagesBox: TCheckBox;
    HwSetupNotebook: TNotebook;
    SnrEdit: TEdit;
    BaudRateEdit: TComboBox;
    Label1: TLabel;
    Label4: TLabel;
    PortEdit: TRadioGroup;
    InterfaceTypeEdit: TRadioGroup;
    Label7: TLabel;
    J2534ListBox: TListBox;
    Label8: TLabel;
    J2534VendorLabel: TLabel;
    J2534DevicesStatusLabel: TLabel;
    Label9: TLabel;
    J2534DriverDllLabel: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    J2534StatusImage: TImage;
    ConfStartBtn: TLabel;
    J2534ApiLabel: TLabel;
    J2534ConfAppLabel: TLabel;
    J2534ImageList: TImageList;
    Label12: TLabel;
    DefColorBox: TColorBox;
    FontDialog: TFontDialog;
    Panel2: TPanel;
    FontLabel: TLabel;
    Label13: TLabel;
    FontChangeBtn: TButton;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    HitColorBox: TColorBox;
    ErrorColorBox: TColorBox;
    StatusColorBox: TColorBox;
    AutoHwOpenBox: TCheckBox;
    AutoTraceStartBox: TCheckBox;
    CanClockIdxEdit: TZahlen32Edit;
    Label18: TLabel;
    DeviceSelectBtn: TButton;
    procedure InterfaceTypeEditClick(Sender: TObject);
    procedure DriverEditClick(Sender: TObject);
    procedure RxDEnableDynamicCheckBoxClick(Sender: TObject);
    procedure CanFdCheckBoxClick(Sender: TObject);
    procedure CANSpeedEditClick(Sender: TObject);
    procedure CANDataSpeedEditClick(Sender: TObject);
    procedure J2534ListBoxClick(Sender: TObject);
    procedure ConfStartBtnClick(Sender: TObject);
    procedure FontChangeBtnClick(Sender: TObject);
    procedure DeviceSelectBtnClick(Sender: TObject);
    procedure CustomNBTRSetupBtnClick(Sender: TObject);
    procedure CustomDBTRSetupBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    J2534DevsList: TObjectList;
    procedure UpdateCan;
    procedure UpdateDataList;
    procedure UpdateHardware;
    function GetSetupFromGui: integer;
    procedure PaintPassThruDevices;
    function CanInfoVarGetByKey(info_list: TCanInfoVarObj; key: DWORD): PCanInfoVar;
    procedure PassThruDeviceSelect(sel: Integer);
    procedure PassThruDeviceSelectByName(name: String);
    function PassThruDeviceGetSelectedDevice: String;
    function CalcCustemBittiming(fd: boolean): Integer;
  public
    { Public-Deklarationen }
    function Execute: integer;
    procedure UpdateSetupForm;
  end;

procedure LoadDefaultSetup;
procedure LoadSetup(ini_file: TIniFile);
procedure SaveSetup(ini_file: TIniFile);

var  
  SetupData: TSetupData;


implementation

{$R *.DFM}

uses MainForm, ShellAPI;

function TSetupForm.GetSetupFromGui: integer;
var i: integer;

begin;
i := 0;
SetupData.NBTRValue := NBTREdit.Number;
SetupData.NBTRBitrate := NBTRBitrateEdit.Text;
SetupData.NBTRDesc := NBTRDescEdit.Text;
SetupData.DBTRValue := DBTREdit.Number;
SetupData.DBTRBitrate := DBTRBitrateEdit.Text;
SetupData.DBTRDesc := DBTRDescEdit.Text;
SetupData.CanClockIndex := CanClockIdxEdit.Number;
if CANSpeedEdit.ItemIndex = 9 then
  SetupData.CANSpeed := 0
else
  SetupData.CANSpeed := CANSpeedEdit.ItemIndex + 1;
if CANDataSpeedEdit.ItemIndex = 16 then
  SetupData.CANDataSpeed := 0
else
  SetupData.CANDataSpeed := CANDataSpeedEdit.ItemIndex + 1;
SetupData.ListenOnly := LomCheckBox.Checked;
SetupData.AutoHwOpen := AutoHwOpenBox.Checked;
SetupData.AutoTraceStart := AutoTraceStartBox.Checked;
SetupData.ShowErrorMessages := ShowErrMsgCheckBox.Checked;
SetupData.CanFd := CanFdCheckBox.Checked;
SetupData.CanFifoOvClear := CanFifoOvClearBox.Checked;
SetupData.CanFifoOvMessages := CanFifoOvMessagesBox.Checked;
SetupData.DataClearMode:=DataClearModeGrp.ItemIndex;
SetupData.TraceDefColor := DefColorBox.Selected; 
SetupData.TraceHitColor:= HitColorBox.Selected;
SetupData.TraceErrorColor:= ErrorColorBox.Selected;
SetupData.TraceStatusColor:= StatusColorBox.Selected;
SetupData.TraceFont.Name := FontLabel.Font.Name; // <*>
SetupData.TraceFont.Size := FontLabel.Font.Size;
SetupData.TraceFont.Style := FontLabel.Font.Style;
SetupData.RxDBufferSize := RxDBufferSizeEdit.Number;
SetupData.RxDEnableDynamic := RxDEnableDynamicCheckBox.Checked;
SetupData.RxDLimit := RxDLimitEdit.Number;
if SetupData.Driver <> DriverEdit.ItemIndex then
  i := 1;
if SetupData.InterfaceType <> InterfaceTypeEdit.ItemIndex then
  i := 1;
if (SetupData.Port-1) <> PortEdit.ItemIndex then
  i := 1;
if SetupData.BaudRate <> BaudRateEdit.ItemIndex then
  i := 1;
if SetupData.HardwareSnr <> SnrEdit.Text then
  i := 1;
SetupData.Driver := DriverEdit.ItemIndex;
SetupData.InterfaceType := InterfaceTypeEdit.ItemIndex;
SetupData.Port := PortEdit.ItemIndex+1;
SetupData.BaudRate := BaudRateEdit.ItemIndex;
SetupData.HardwareSnr := SnrEdit.Text;
if SetupData.Driver = 2 then
  SetupData.DeviceName := PassThruDeviceGetSelectedDevice;
result := i;  
end;


function TSetupForm.Execute: integer;

begin;
result := -1;
if SetupData.Driver = 2 then
  begin;
  PaintPassThruDevices;
  PassThruDeviceSelectByName(SetupData.DeviceName);
  end;
NBTREdit.Number := SetupData.NBTRValue;
NBTRBitrateEdit.Text := SetupData.NBTRBitrate;
NBTRDescEdit.Text := SetupData.NBTRDesc;
DBTREdit.Number := SetupData.DBTRValue;
DBTRBitrateEdit.Text := SetupData.DBTRBitrate;
DBTRDescEdit.Text := SetupData.DBTRDesc;
CanClockIdxEdit.Number := SetupData.CanClockIndex;
DriverEdit.ItemIndex := SetupData.Driver;
if SetupData.CANSpeed = 0 then
  CANSpeedEdit.ItemIndex := 9
else
  CANSpeedEdit.ItemIndex := SetupData.CANSpeed - 1;
if SetupData.CANDataSpeed = 0 then
  CANDataSpeedEdit.ItemIndex := 16
else
  CANDataSpeedEdit.ItemIndex := SetupData.CANDataSpeed - 1;
LomCheckBox.Checked := SetupData.ListenOnly;
AutoHwOpenBox.Checked := SetupData.AutoHwOpen;
AutoTraceStartBox.Checked := SetupData.AutoTraceStart;
ShowErrMsgCheckBox.Checked := SetupData.ShowErrorMessages;
CanFdCheckBox.Checked := SetupData.CanFd;
CanFifoOvClearBox.Checked := SetupData.CanFifoOvClear;
CanFifoOvMessagesBox.Checked := SetupData.CanFifoOvMessages;
DataClearModeGrp.ItemIndex:= SetupData.DataClearMode;
DefColorBox.Selected := SetupData.TraceDefColor; 
HitColorBox.Selected := SetupData.TraceHitColor;
ErrorColorBox.Selected := SetupData.TraceErrorColor;
StatusColorBox.Selected := SetupData.TraceStatusColor;
FontLabel.Font.Name := SetupData.TraceFont.Name;  // <*>
FontLabel.Font.Size := SetupData.TraceFont.Size;
FontLabel.Font.Style := SetupData.TraceFont.Style;
FontLabel.Caption := FontLabel.Font.Name + ', ' + IntToStr(FontLabel.Font.Size);
RxDBufferSizeEdit.Number := SetupData.RxDBufferSize;
RxDEnableDynamicCheckBox.Checked := SetupData.RxDEnableDynamic;
RxDLimitEdit.Number := SetupData.RxDLimit;
InterfaceTypeEdit.ItemIndex := SetupData.InterfaceType;
PortEdit.ItemIndex := SetupData.Port-1;
BaudRateEdit.ItemIndex := SetupData.BaudRate;
SnrEdit.Text := SetupData.HardwareSnr;
UpdateSetupForm;
if ShowModal = idOk then
  result := GetSetupFromGui;
if J2534DevsList <> nil then
  J2534DevsList.Destroy;
end;


procedure TSetupForm.UpdateSetupForm;

begin;
InterfaceTypeEdit.Enabled := True;
UpdateCan;
UpdateDataList;
UpdateHardware;
end;


procedure TSetupForm.UpdateCan;

begin
if CanFdCheckBox.Checked then
  begin;
  CANDataSpeedEdit.Enabled := TRUE;
  if CANDataSpeedEdit.ItemIndex = 16 then
    begin;
    CANSpeedEdit.ItemIndex := 9;
    DBTRStr.Enabled := TRUE;
    DBTREdit.Enabled := TRUE;
    DBTRHexStr.Enabled := TRUE;
    DBTRBitrateStr.Enabled := TRUE;
    DBTRBitrateEdit.Enabled := TRUE;
    CustomDBTRSetupBtn.Enabled := TRUE;
    DBTRDescEdit.Enabled := TRUE;
    CanClockIdxEdit.Enabled := TRUE;
    end
  else
    begin;
    DBTRStr.Enabled := FALSE;
    DBTREdit.Enabled := FALSE;
    DBTRHexStr.Enabled := FALSE;
    DBTRBitrateStr.Enabled := FALSE;
    DBTRBitrateEdit.Enabled := FALSE;
    CustomDBTRSetupBtn.Enabled := FALSE;
    DBTRDescEdit.Enabled := FALSE;
    CanClockIdxEdit.Enabled := FALSE;
    CanClockIdxEdit.Number := 0;
    end;
  end
else
  begin;
  CANDataSpeedEdit.Enabled := FALSE;
  DBTRStr.Enabled := FALSE;
  DBTREdit.Enabled := FALSE;
  DBTRHexStr.Enabled := FALSE;
  DBTRBitrateStr.Enabled := FALSE;
  DBTRBitrateEdit.Enabled := FALSE;
  CustomDBTRSetupBtn.Enabled := FALSE;
  DBTRDescEdit.Enabled := FALSE;
  CanClockIdxEdit.Enabled := FALSE;
  CanClockIdxEdit.Number := 0;
  end;
if CANSpeedEdit.ItemIndex = 9 then
  begin;
  NBTRStr.Enabled := TRUE;
  NBTREdit.Enabled := TRUE;
  NBTRHexStr.Enabled := TRUE;
  NBTRBitrateStr.Enabled := TRUE;
  NBTRBitrateEdit.Enabled := TRUE;
  CustomNBTRSetupBtn.Enabled := TRUE;
  NBTRDescEdit.Enabled := TRUE;
  CanClockIdxEdit.Enabled := TRUE;  // <*> ?
  end
else
  begin;
  NBTRStr.Enabled := FALSE;
  NBTREdit.Enabled := FALSE;
  NBTRHexStr.Enabled := FALSE;
  NBTRBitrateStr.Enabled := FALSE;
  NBTRBitrateEdit.Enabled := FALSE;
  CustomNBTRSetupBtn.Enabled := FALSE;
  NBTRDescEdit.Enabled := FALSE;
  CanClockIdxEdit.Enabled := FALSE;
  CanClockIdxEdit.Number := 0;
  end;
end;


procedure TSetupForm.UpdateDataList;

begin
if RxDEnableDynamicCheckBox.Checked then
  RxDLimitEdit.Enabled := TRUE
else
  RxDLimitEdit.Enabled := FALSE;  
end;
  

function TSetupForm.CanInfoVarGetByKey(info_list: TCanInfoVarObj; key: DWORD): PCanInfoVar;
var item: PCanInfoVar;
    i: Integer;
  
begin;
result := nil;
if info_list = nil then
  exit; 
for i := 0 to info_list.Count - 1 do
  begin;
  item := info_list[i];
  if item.Key = key then
    begin;
    result := item;
    exit;
    end;  
  end;
end;  


procedure TSetupForm.PassThruDeviceSelect(sel: Integer);
var item: PCanInfoVar;
    info_list: TCanInfoVarObj;
    mode: Integer;
    driver_name: String;

begin;
mode := 0;
if (J2534DevsList <> nil) then
  begin;  
  if J2534DevsList.Count > 0 then
    mode := 1;
  if (sel > -1) and (J2534DevsList.Count > sel) then
    begin;
    info_list := TCanInfoVarObj(J2534DevsList[sel]);
    // Vendor
    item := CanInfoVarGetByKey(info_list, TCAN_INFO_KEY_VENDOR);
    if item <> nil then
      J2534VendorLabel.Caption := item.ValueStr
    else
      J2534VendorLabel.Caption := '?';
    // DLL
    item := CanInfoVarGetByKey(info_list, TCAN_INFO_KEY_DLL);
    if item <> nil then
      J2534DriverDllLabel.Caption := item.ValueStr
    else
      J2534DriverDllLabel.Caption := '?';
    // API Version
    item := CanInfoVarGetByKey(info_list, TCAN_INFO_KEY_API_VERSION);
    if item <> nil then
      J2534ApiLabel.Caption := item.ValueStr
    else
      J2534ApiLabel.Caption := '?';
    // Cfg App
    item := CanInfoVarGetByKey(info_list, TCAN_INFO_KEY_CFG_APP);
    if item <> nil then
      J2534ConfAppLabel.Caption := item.ValueStr
    else
      J2534ConfAppLabel.Caption := '?';
    driver_name := CanInfoVarGetByKey(info_list, TCAN_INFO_KEY_HARDWARE).ValueStr;  
    mode := 2;
    end;
  end;
  J2534StatusImage.Picture := nil;
if mode = 0 then
  begin;
  J2534ImageList.GetBitmap(0, J2534StatusImage.Picture.Bitmap);
  J2534DevicesStatusLabel.Caption := 'Kein PassThru Device gefunden';
  J2534VendorLabel.Caption := '?';
  J2534DriverDllLabel.Caption := '?';
  J2534ApiLabel.Caption := '?';
  J2534ConfAppLabel.Caption := '?';
  end
else if mode = 1 then
  begin;
  J2534ImageList.GetBitmap(1, J2534StatusImage.Picture.Bitmap);
  J2534DevicesStatusLabel.Caption := Format('%d PassThru Devices gefunden,'#13#10'kein PassThru Device ausgewählt', [J2534DevsList.Count]);
  J2534VendorLabel.Caption := '?';
  J2534DriverDllLabel.Caption := '?';
  J2534ApiLabel.Caption := '?';
  J2534ConfAppLabel.Caption := '?';
  end
else
  begin;
  J2534ImageList.GetBitmap(2, J2534StatusImage.Picture.Bitmap);
  J2534DevicesStatusLabel.Caption := Format('%d PassThru Devices gefunden,'#13#10'Device "%s" ausgewählt', [J2534DevsList.Count, driver_name]);
  end;
end;


procedure TSetupForm.PassThruDeviceSelectByName(name: String);
var i: Integer;

begin
for i := 0 to (J2534ListBox.Items.Count - 1) do 
  begin;
  if J2534ListBox.Items.Strings[i] = name then
    begin;
    J2534ListBox.ItemIndex := i;
    PassThruDeviceSelect(i);
    exit;
    end;
  end;  
PassThruDeviceSelect(-1);
end;


function TSetupForm.PassThruDeviceGetSelectedDevice: String;
var sel: Integer;
 
begin;
sel := J2534ListBox.ItemIndex;
if sel > -1 then
  result := J2534ListBox.Items.Strings[sel]
else
  result := '';
end;

  
procedure TSetupForm.PaintPassThruDevices;
var idx: Integer;
    info_list: TCanInfoVarObj;
    item: PCanInfoVar;

begin;
J2534ListBox.Clear;
if J2534DevsList <> nil then
  J2534DevsList.Destroy;
J2534DevsList := MainWin.TinyCAN.CanExGetInfoList(0, '', 0);
if J2534DevsList <> nil then
  begin;
  for idx := 0 to J2534DevsList.Count - 1 do
    begin;
    info_list := TCanInfoVarObj(J2534DevsList[idx]);
    item := CanInfoVarGetByKey(info_list, TCAN_INFO_KEY_HARDWARE);
    if item = nil then
      continue;
    J2534ListBox.AddItem(item.ValueStr, TObject(info_list));
    end;
  end;    
end;


procedure TSetupForm.UpdateHardware;
//var hit: boolean; <*>

begin;
// PassThru Treiber
//hit := FALSE;
if SetupData.Driver <> DriverEdit.ItemIndex then
  begin;
  SetupData.Driver := DriverEdit.ItemIndex;
  HwSetupNotebook.PageIndex := 2;
  HwSetupNotebook.Repaint;
  MainWin.SetSetup(1);    
  {if SetupData.Driver = 2 then <*>
    hit := TRUE
  else if DriverEdit.ItemIndex = 2 then
    hit := TRUE; 
  SetupData.Driver := DriverEdit.ItemIndex;
  if hit then
    begin;
    HwSetupNotebook.PageIndex := 2;
    //LoadingWdg.Active := TRUE;<*>
    HwSetupNotebook.Repaint;
    MainWin.SetSetup(1);
    //LoadingWdg.Active := FALSE;<*>
    end; }
  end;

if DriverEdit.ItemIndex = 2 then
  begin;
  HwSetupNotebook.PageIndex := 1;
  PaintPassThruDevices;  
  PassThruDeviceSelectByName(SetupData.DeviceName);
  end
else
// Tiny-CAN & SL-CAN Treiber
  begin;
  HwSetupNotebook.PageIndex := 0;
  if DriverEdit.ItemIndex = 0 then
    begin;
    if InterfaceTypeEdit.ItemIndex = 0 then
      begin;
      PortEdit.Enabled := False;
      BaudRateEdit.Enabled := False;
      SnrEdit.Enabled := True;
      end
    else
      begin;
      PortEdit.Enabled := True;
      BaudRateEdit.Enabled := True;
      SnrEdit.Enabled := False;
      end;
    end
  else
    begin;
    if InterfaceTypeEdit.ItemIndex = 0 then
      begin;
      PortEdit.Enabled := False;
      BaudRateEdit.Enabled := True;
      SnrEdit.Enabled := True;
      end
    else
      begin;
      PortEdit.Enabled := True;
      BaudRateEdit.Enabled := True;
      SnrEdit.Enabled := False;
      end;
    end;  
  end;
end;


procedure TSetupForm.CanFdCheckBoxClick(Sender: TObject);

begin
UpdateCan;
end;


procedure TSetupForm.CANSpeedEditClick(Sender: TObject);

begin
UpdateCan;
end;

procedure TSetupForm.CANDataSpeedEditClick(Sender: TObject);

begin
UpdateCan;
end;


procedure TSetupForm.RxDEnableDynamicCheckBoxClick(Sender: TObject);

begin
UpdateDataList;
end;


procedure TSetupForm.DriverEditClick(Sender: TObject);

begin
UpdateHardware;
end;


procedure TSetupForm.InterfaceTypeEditClick(Sender: TObject);

begin
UpdateHardware;
end;


procedure LoadSetup(ini_file: TIniFile);
var file_path, project_path, tx_list_file: String; 

begin;
SetupData.Driver := ini_file.ReadInteger('GLOBAL', 'Driver', 0);
SetupData.Port := ini_file.ReadInteger('GLOBAL', 'Port', 1);
SetupData.BaudRate := ini_file.ReadInteger('GLOBAL', 'BaudRate', 3000000);
SetupData.InterfaceType := ini_file.ReadInteger('GLOBAL', 'InterfaceType', 0);
SetupData.HardwareSnr := ini_file.ReadString('GLOBAL', 'HardwareSnr', '');
SetupData.DeviceName := ini_file.ReadString('GLOBAL', 'DeviceName', '');
// Tab CAN
SetupData.CANSpeed := ini_file.ReadInteger('GLOBAL', 'CANSpeed', 5);
SetupData.CANDataSpeed := ini_file.ReadInteger('GLOBAL', 'CANDataSpeed', 2);
SetupData.NBTRValue := ini_file.ReadInteger('GLOBAL', 'NBTRValue', 0);
SetupData.NBTRBitrate := ini_file.ReadString('GLOBAL', 'NBTRBitrate', '');
SetupData.NBTRDesc:= ini_file.ReadString('GLOBAL', 'NBTRDesc', '');
SetupData.DBTRValue := ini_file.ReadInteger('GLOBAL', 'DBTRValue', 0);
SetupData.DBTRBitrate := ini_file.ReadString('GLOBAL', 'DBTRBitrate', '');
SetupData.DBTRDesc := ini_file.ReadString('GLOBAL', 'DBTRDesc', '');
SetupData.CanClockIndex := ini_file.ReadInteger('GLOBAL', 'CanClockIndex', 0);
SetupData.ListenOnly := ini_file.ReadBool('GLOBAL', 'ListenOnly', false);
SetupData.AutoHwOpen := ini_file.ReadBool('GLOBAL', 'AutoHwOpen', true);
SetupData.AutoTraceStart := ini_file.ReadBool('GLOBAL', 'AutoTraceStart', true);
SetupData.ShowErrorMessages := ini_file.ReadBool('GLOBAL', 'ShowErrorMessages', false);
SetupData.CanFd := ini_file.ReadBool('GLOBAL', 'CanFd', false);
SetupData.CanFifoOvClear := ini_file.ReadBool('GLOBAL', 'CanFifoOvClear', false);
SetupData.CanFifoOvMessages := ini_file.ReadBool('GLOBAL', 'CanFifoOvMessages', false);

SetupData.DataClearMode := ini_file.ReadInteger('GLOBAL', 'DataClearMode', 0);
SetupData.TraceDefColor := IniReadColor(ini_file, 'GLOBAL', 'TraceDefColor', clBlack);
SetupData.TraceHitColor :=IniReadColor(ini_file, 'GLOBAL', 'TraceHitColor', clBlue);
SetupData.TraceErrorColor :=IniReadColor(ini_file, 'GLOBAL', 'TraceErrorColor', clRed);
SetupData.TraceStatusColor :=IniReadColor(ini_file, 'GLOBAL', 'TraceStatusColor', clRed);
IniReadFont(ini_file, SetupData.TraceFont, 'GLOBAL', 'TraceFont', DefaultFont);
SetupData.RxDBufferSize := ini_file.ReadInteger('GLOBAL', 'RxDBufferSize', 100000);
SetupData.RxDEnableDynamic := ini_file.ReadBool('GLOBAL', 'RxDEnableDynamic', false);
SetupData.RxDLimit := ini_file.ReadInteger('GLOBAL', 'RxDLimit', 0);
tx_list_file := ini_file.ReadString('GLOBAL', 'TxListFile', '');
project_path := ExtractFilePath(MainWin.ProjectFile);
file_path := ExtractFilePath(tx_list_file); 
if length(file_path) > 0 then 
  SetupData.TxListFile := tx_list_file
else
  SetupData.TxListFile := project_path + tx_list_file;  
end;


procedure SaveSetup(ini_file: TIniFile);
var file_path, project_path, tx_list_file: String; 

begin;
ini_file.WriteInteger('GLOBAL', 'Driver', SetupData.Driver);
ini_file.WriteString('GLOBAL', 'DeviceName', SetupData.DeviceName);
ini_file.WriteInteger('GLOBAL', 'Port', SetupData.Port);
ini_file.WriteInteger('GLOBAL', 'BaudRate', SetupData.BaudRate);
ini_file.WriteInteger('GLOBAL', 'InterfaceType', SetupData.InterfaceType);
ini_file.WriteString('GLOBAL', 'HardwareSnr', SetupData.HardwareSnr);
ini_file.WriteInteger('GLOBAL', 'CANSpeed', SetupData.CANSpeed);
ini_file.WriteInteger('GLOBAL', 'CANDataSpeed', SetupData.CANDataSpeed);
ini_file.WriteInteger('GLOBAL', 'NBTRValue', SetupData.NBTRValue);
ini_file.WriteString('GLOBAL', 'NBTRBitrate', SetupData.NBTRBitrate);
ini_file.WriteString('GLOBAL', 'NBTRDesc', SetupData.NBTRDesc);
ini_file.WriteInteger('GLOBAL', 'DBTRValue', SetupData.DBTRValue);
ini_file.WriteString('GLOBAL', 'DBTRBitrate', SetupData.DBTRBitrate);
ini_file.WriteString('GLOBAL', 'DBTRDesc', SetupData.DBTRDesc);
ini_file.WriteInteger('GLOBAL', 'CanClockIndex', SetupData.CanClockIndex);
ini_file.WriteBool('GLOBAL', 'ListenOnly', SetupData.ListenOnly);
ini_file.WriteBool('GLOBAL', 'AutoHwOpen', SetupData.AutoHwOpen);
ini_file.WriteBool('GLOBAL', 'AutoTraceStart', SetupData.AutoTraceStart);
ini_file.WriteBool('GLOBAL', 'ShowErrorMessages', SetupData.ShowErrorMessages);
ini_file.WriteBool('GLOBAL', 'CanFd', SetupData.CanFd);
ini_file.WriteBool('GLOBAL', 'CanFifoOvClear', SetupData.CanFifoOvClear);
ini_file.WriteBool('GLOBAL', 'CanFifoOvMessages', SetupData.CanFifoOvMessages);
ini_file.WriteInteger('GLOBAL', 'DataClearMode', SetupData.DataClearMode);
IniWriteColor(ini_file, 'GLOBAL', 'TraceDefColor', SetupData.TraceDefColor); 
IniWriteColor(ini_file, 'GLOBAL', 'TraceHitColor', SetupData.TraceHitColor);
IniWriteColor(ini_file, 'GLOBAL', 'TraceErrorColor', SetupData.TraceErrorColor);
IniWriteColor(ini_file, 'GLOBAL', 'TraceStatusColor', SetupData.TraceStatusColor);
IniWriteFont(ini_file, 'GLOBAL', 'TraceFont', SetupData.TraceFont);
ini_file.WriteInteger('GLOBAL', 'RxDBufferSize', SetupData.RxDBufferSize);
ini_file.WriteBool('GLOBAL', 'RxDEnableDynamic', SetupData.RxDEnableDynamic);
ini_file.WriteInteger('GLOBAL', 'RxDLimit', SetupData.RxDLimit);
project_path := ExtractFilePath(MainWin.ProjectFile);
file_path := ExtractFilePath(SetupData.TxListFile);
if project_path = file_path then
  tx_list_file := ExtractFileName(SetupData.TxListFile)
else
  tx_list_file := SetupData.TxListFile;   
ini_file.WriteString('GLOBAL', 'TxListFile', tx_list_file);
end;


procedure LoadDefaultSetup;

begin;
SetupData.Driver :=  0;
SetupData.Port :=  1;
SetupData.BaudRate := 3000000;
SetupData.InterfaceType := 0; // 0 = USB
SetupData.HardwareSnr := '';
SetupData.DeviceName := '';
// Tab CAN
SetupData.CANSpeed := 5;  // 125 kBit/s
SetupData.CANDataSpeed := 2; // 250 kBit/s
SetupData.NBTRValue := 0;
SetupData.NBTRBitrate := '';
SetupData.NBTRDesc:= '';
SetupData.DBTRValue := 0;
SetupData.DBTRBitrate := '';
SetupData.DBTRDesc:= '';
SetupData.CanClockIndex := 0;
SetupData.ListenOnly := false;
SetupData.AutoHwOpen := true;
SetupData.AutoTraceStart := true;
SetupData.ShowErrorMessages := false;
SetupData.CanFd := false;
SetupData.CanFifoOvClear := false;
SetupData.CanFifoOvMessages := false;

SetupData.DataClearMode := 0; // 0 = Automatisch löschen 
SetupData.TraceDefColor := clBlack;
SetupData.TraceHitColor := clBlue;
SetupData.TraceErrorColor := clRed;
SetupData.TraceStatusColor := clRed;
CopyFontDesc(SetupData.TraceFont, DefaultFont);
SetupData.RxDBufferSize := 100000;
SetupData.RxDEnableDynamic := false;
SetupData.RxDLimit := 0;
SetupData.TxListFile := '';
end;
 

procedure TSetupForm.J2534ListBoxClick(Sender: TObject);
begin
PassThruDeviceSelect(TListBox(Sender).ItemIndex);
end;


procedure TSetupForm.ConfStartBtnClick(Sender: TObject);
var sel: Integer;
    item: PCanInfoVar;
    info_list: TCanInfoVarObj;
    str: String;

begin
sel := J2534ListBox.ItemIndex;
if (J2534DevsList <> nil) and (sel > -1) then
  begin;  
  if J2534DevsList.Count > sel then
    begin;
    info_list := TCanInfoVarObj(J2534DevsList[sel]);
    item := CanInfoVarGetByKey(info_list, TCAN_INFO_KEY_CFG_APP);
    if item <> nil then
      begin;
      str := item.ValueStr;
      ShellExecute(0, 'open', PChar(str), nil, nil, SW_NORMAL);
      end;
    end;
  end;    
end;


procedure TSetupForm.FontChangeBtnClick(Sender: TObject);
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


procedure TSetupForm.DeviceSelectBtnClick(Sender: TObject);
var res: Integer;
    snr: String;

begin
res := MainWin.MhsCanUtil.CanUtilShowHwWin('Hardware auswahl', '', CUTIL_HW_SCAN_ACTIVE, snr);
if res > -1 then
  begin;
  SnrEdit.Text := snr;
  end;
end;


function TSetupForm.CalcCustemBittiming(fd: boolean): Integer;
var res: Integer;
    bitrate_str, fd_bitrate_str, description, fd_description: String;
    flags, nbtr_value, bitrate, clock, dbtr_value, fd_bitrate: DWORD;
    
begin;
flags := CAN_CFG_USE_CIA_SP or CAN_CFG_FD_USE_CIA_SP or CAN_CFG_AUTO_SJW or CAN_CFG_FD_AUTO_SJW or
  CAN_CFG_FD_ONLY_SAME_BRP or CAN_CFG_FD_AUTO_SAME_BRP;
if fd then
  begin;
  flags := flags or CAN_CFG_USE_FD;
  end;
//res := MainWin.MhsCanUtil.CanUtilBitrateSelSetHw('', 0, SetupData.HardwareSnr, INDEX_INVALID); <*>
res := MainWin.MhsCanUtil.CanUtilBitrateSelSetHw('', 0, SnrEdit.Text, INDEX_INVALID);
if res > -1 then
  begin;
  res := MainWin.MhsCanUtil.CanUtilBitrateSelSetDefaults(flags, 0, 0, 10, 0, 0, 10);
  end;
if res > -1 then
  begin;
  res := MainWin.MhsCanUtil.CanUtilBitrateSelShowDialog('Tiny-CAN Bitrate', '', 0);
  end;
if res > -1 then
  begin;
  res := MainWin.MhsCanUtil.CanUtilBitrateSelGetHwResult(nbtr_value, bitrate, clock, bitrate_str, description,
                           dbtr_value, fd_bitrate, fd_bitrate_str, fd_description);                           
  end;
if res > -1 then  
  begin;
  CanClockIdxEdit.Number := clock;
  NBTREdit.Number := nbtr_value;
  NBTRBitrateEdit.Text := bitrate_str;
  NBTRDescEdit.Text := description;
  if fd then
    begin;
    DBTREdit.Number := dbtr_value;
    DBTRBitrateEdit.Text := fd_bitrate_str;
    DBTRDescEdit.Text := fd_description;
    end
  else
    begin;
    DBTREdit.Number := 0;
    DBTRBitrateEdit.Text := '';
    DBTRDescEdit.Text := '';
    end;
  end;     
end;  


procedure TSetupForm.CustomNBTRSetupBtnClick(Sender: TObject);

begin
CalcCustemBittiming(FALSE);
end;


procedure TSetupForm.CustomDBTRSetupBtnClick(Sender: TObject);

begin
CalcCustemBittiming(TRUE);
end;

end.
