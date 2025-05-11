{ *********** TINY - CAN Utilities **************                        }
{  begin             : 19.06.2022                                        }
{  last modify       : 14.08.2022                                        }
{  copyright         : (C) 2022 by MHS-Elektronik GmbH & Co. KG          }
{                             http://www.mhs-elektronik.de               }
{  author            : Klaus Demlehner, klaus@mhs-elektronik.de          }
unit MhsCanUtil;

interface


{$WARN SYMBOL_DEPRECATED OFF}
{$IFNDEF VER140}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CODE OFF}
{$ENDIF}

uses
  Windows, SysUtils, Messages, Classes, ComCtrls, Forms, Controls, Registry, Contnrs, TinyCanDrv;

const
  ERR_NO_CAN_UTIL_DLL_LOAD: Integer = -10000; // <*>

  CAN_CFG_SP_FLAGS_CLR: DWORD              = ($FFFFCFFF);
  CAN_CFG_FD_SP_FLAGS_CLR: DWORD           = ($FFFF3FFF);
                                        
  CAN_CFG_CLOCK_IDX_MASK: DWORD            = ($0000007F);
  CAN_CFG_CLOCK_SELECT_ONE: DWORD          = ($00000080);
  CAN_CFG_USE_ONE_CLOCK: DWORD             = ($00000100);
                                        
  CAN_CFG_USE_CIA_SP: DWORD                = ($00001000);
  CAN_CFG_USE_SP_RANGE: DWORD              = ($00002000);
  CAN_CFG_FD_USE_CIA_SP: DWORD             = ($00004000);
  CAN_CFG_FD_USE_SP_RANGE: DWORD           = ($00008000);
  CAN_CFG_USE_SAM: DWORD                   = ($00010000);
  CAN_CFG_USE_TDC: DWORD                   = ($00020000);
  CAN_CFG_USE_FD: DWORD                    = ($00040000);
                                        
  CAN_CFG_AUTO_SJW: DWORD                  = ($00100000);
  CAN_CFG_FD_AUTO_SJW: DWORD               = ($00200000);

  CAN_CFG_AUTO_CLEAN_BITRATE_ERRORS: DWORD = ($01000000);
  CAN_CFG_FD_ONLY_SAME_BRP: DWORD          = ($02000000);
  CAN_CFG_FD_AUTO_SAME_BRP: DWORD          = ($04000000);

  CUTIL_WIN_IDX_ANY: DWORD              = (0);

  CUTIL_WIN_IDX_DRIVER_LIST: DWORD      = (1);
  CUTIL_WIN_IDX_HW_LIST: DWORD          = (2);
  CUTIL_WIN_IDX_HW_INFO: DWORD          = (3);
  CUTIL_WIN_IDX_BITCALC_START: DWORD    = (4);
  CUTIL_WIN_IDX_BITCALC_FD_CFG: DWORD   = (5);
  CUTIL_WIN_IDX_BITCALC_STD_CFG: DWORD  = (6);
  CUTIL_WIN_IDX_BITCALC_FD: DWORD       = (7);
  CUTIL_WIN_IDX_BITCALC_STD: DWORD      = (8);

  CUTIL_INFO_ONLY: DWORD                 = ($00000001);

  CUTIL_HW_SCAN_ACTIVE: DWORD            = ($00000010);
  CUTIL_HW_SCAN_DISABLE: DWORD           = ($00000020);
  CUTIL_HW_SHOW_ALL: DWORD               = ($00000040);

  CUTIL_BITCALC_EXIT_BUTTON: DWORD       = ($00000100);
  CUTIL_BITCALC_EXTRA_BUTTONS: DWORD     = ($00000200);
  CUTIL_BITCALC_CONTROLLER_SEL: DWORD    = ($00000400);
  
  CUTIL_BITCALC_SHOW_BTR_REGISTER: DWORD = ($00001000);

  MHS_CAN_UTIL_DLL: String = 'mhscanutil.dll';
  REG_TINY_CAN_API: String = 'Software\Tiny-CAN\API\';
  REG_TINY_CAN_API_PATH_ENTRY: String = 'PATH';
  
  
type
ECanUtilDllLoadError = class(Exception);  
  
TCanUtilDrvInfoDrv = packed record  
  Filename: array[0..254] of AnsiChar;
  Name: array[0..39] of AnsiChar;
  Version: array[0..39] of AnsiChar;
  Summary: array[0..254] of AnsiChar;
  Description: array[0..254] of AnsiChar;
  InterfaceType: DWORD;
  end;
PCanUtilDrvInfoDrv = ^TCanUtilDrvInfoDrv;


TCanUtilDrvInfo = record
  Filename: String[255];
  Name: String[40];
  Version: String[40];
  Summary: String[255];
  Description: String[255];
  InterfaceType: DWORD;
  end;
PCanUtilDrvInfo = ^TCanUtilDrvInfo;
  

{/***************************************************************/}
{/*  Funktionstypen                                             */}
{/***************************************************************/}
TF_CanUtilInit = function: Integer; stdcall;
TF_CanUtilDown = procedure; stdcall;
TF_CanUtilRegisterDriver = function(api_handle: Pointer; res: Integer): Integer; stdcall;

TF_CanUtilCloseWin = function(win_idx: DWORD): Integer; stdcall;

TF_CanUtilBitrateSelSetHw = function(tiny_can: PAnsiChar; revision: DWORD; snr: PAnsiChar; 
      hw_info: PCanInfoVarDev; hw_info_size, index: DWORD): Integer; stdcall;
TF_CanUtilBitrateSelSetDefaults = function(flags, bitrate: DWORD; sp, sp_error: Double; fd_bitrate: DWORD; fd_sp, fd_sp_error: Double): Integer; stdcall;
TF_CanUtilBitrateSelGetHwResult = function(nbtr_value: PDWORD; bitrate: PDWORD; clock_idx: PDWORD; bitrate_str, description: PAnsiChar;
                                   dbtr_value: PDWORD; fd_bitrate: PDWORD; fd_bitrate_str: PAnsiChar; fd_description: PAnsiChar): Integer; stdcall;
TF_CanUtilBitrateSelShowDialog = function(title: PAnsiChar; sub_title: PAnsiChar; flags: DWORD): Integer; stdcall;

TF_CanUtilGetDriverList = function(drv_info_list: Pointer): Integer; stdcall;
TF_CanUtilGetDriverListGet = function(item: PCanUtilDrvInfoDrv): Integer; stdcall; 
TF_CanUtilGetSelectedDriver = function(selected_drv: PCanUtilDrvInfoDrv): Integer; stdcall;
TF_CanUtilShowDriverList = function(title: PAnsiChar; sub_title: PAnsiChar; flags: DWORD; drv_name: PAnsiChar): Integer; stdcall;

TF_CanUtilGetHwList = function(list: Pointer): Integer; stdcall;
TF_CanUtilGetHwListGet = function(item: PCanDevicesListDev): Integer; stdcall;
TF_CanUtilGetSelectedHw = function(sel_dev: PCanDevicesListDev): Integer; stdcall;
TF_CanUtilShowHwWin = function(title: PAnsiChar; sub_title: PAnsiChar; flags: DWORD; snr: PAnsiChar): Integer; stdcall;

TF_CanUtilHwInfoWin = function(title: PAnsiChar; sub_title: PAnsiChar; flags: DWORD; hw_info: Pointer; hw_info_size, index: DWORD): Integer; stdcall;


TCanUtilDrvInfoObj = class(TList)
  private
    function Get(Index: Integer): PCanUtilDrvInfo;
  public
    destructor Destroy; override;
    function Add(item: PCanUtilDrvInfo): Integer;
    property Items[Index: Integer]: PCanUtilDrvInfo read Get; default;
  end;

TMhsCanUtil = class(TComponent)
  private
    function TestCanUtil(name: String): Boolean;
    function RegReadStringEntry(path, entry: String): String;
    function GetCanUtilWithPath: String;
    function CanUtilInit: Integer;
    procedure CanUtilDown;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;      
    function CanUtilRegisterDriver(api_handle: Pointer; res: Integer): Integer;
{/**************************************************************************************/}
{/*                              Public                                                */}
{/**************************************************************************************/}
    function CanUtilCloseWin(win_idx: DWORD): Integer;    
{/**************************************************************************************/}
{/*                               Bit Timing                                           */}
{/**************************************************************************************/}
    function CanUtilBitrateSelSetHw(tiny_can: String; revision: DWORD; snr: String; index: DWORD): Integer;
    function CanUtilBitrateSelSetDefaults(flags, bitrate: DWORD; sp, sp_error: Double; fd_bitrate: DWORD; fd_sp, fd_sp_error: Double): Integer;
    function CanUtilBitrateSelGetHwResult(var nbtr_value, bitrate, clock_idx: DWORD; var bitrate_str, description: String;
                                   var dbtr_value, fd_bitrate: DWORD; var fd_bitrate_str, fd_description: String): Integer;
    function CanUtilBitrateSelShowDialog(title, sub_title: String; flags: DWORD): Integer;
{/**************************************************************************************/}
{/*                          Driver DLLs Info                                          */}
{/**************************************************************************************/}
    function CanUtilGetDriverList: TCanUtilDrvInfoObj;
    function CanUtilGetSelectedDriver(var selected_drv: TCanUtilDrvInfo): Integer;
    function CanUtilShowDriverList(title, sub_title: String; flags: DWORD; var drv_name: String): Integer;
{/**************************************************************************************/}
{/*                          Connected Hardware                                        */}
{/**************************************************************************************/}
    function CanUtilGetHwList: TCanDevicesListObj;
    function CanUtilGetSelectedHw(var item: TCanDevicesList): Integer;
    function CanUtilShowHwWin(title, sub_title: String; flags: DWORD; var snr: String): Integer;
{/**************************************************************************************/}
{/*                            Show Hardware Info                                      */}
{/**************************************************************************************/}
    function CanUtilHwInfoWin(title, sub_title: String; flags, index: DWORD): Integer;

    function LoadCanUtil: Integer;
    procedure DownCanUtil;
  published
  end;


procedure Register;


implementation

var
  CanUtilDllWnd: HWnd = 0;
  DrvRefCounter: Integer = 0;

  pmCanUtilInit: TF_CanUtilInit= nil;
  pmCanUtilDown: TF_CanUtilDown= nil;
  pmCanUtilRegisterDriver: TF_CanUtilRegisterDriver = nil;
  pmCanUtilCloseWin: TF_CanUtilCloseWin = nil;
  pmCanUtilBitrateSelSetHw: TF_CanUtilBitrateSelSetHw = nil;
  pmCanUtilBitrateSelSetDefaults: TF_CanUtilBitrateSelSetDefaults = nil;
  pmCanUtilBitrateSelGetHwResult: TF_CanUtilBitrateSelGetHwResult = nil;
  pmCanUtilBitrateSelShowDialog: TF_CanUtilBitrateSelShowDialog = nil;
  pmCanUtilGetDriverList: TF_CanUtilGetDriverList = nil;
  pmCanUtilGetDriverListGet: TF_CanUtilGetDriverListGet = nil;
  pmCanUtilGetSelectedDriver: TF_CanUtilGetSelectedDriver = nil;
  pmCanUtilShowDriverList: TF_CanUtilShowDriverList = nil;
  pmCanUtilGetHwList: TF_CanUtilGetHwList = nil;
  pmCanUtilGetHwListGet: TF_CanUtilGetHwListGet = nil;
  pmCanUtilGetSelectedHw: TF_CanUtilGetSelectedHw = nil;
  pmCanUtilShowHwWin: TF_CanUtilShowHwWin = nil;
  pmCanUtilHwInfoWin: TF_CanUtilHwInfoWin = nil;


{ TCanUtilDrvInfoObj }

function TCanUtilDrvInfoObj.Add(item: PCanUtilDrvInfo): Integer;

begin
Result := inherited Add(item);
end;


destructor TCanUtilDrvInfoObj.Destroy;
var i: Integer;

begin
for i := 0 to Count - 1 do
  FreeMem(Items[i]);
inherited;
end;


function TCanUtilDrvInfoObj.Get(Index: Integer): PCanUtilDrvInfo;

begin
Result := PCanUtilDrvInfo(inherited Get(Index));
end;


{**************************************************************}
{* Object erzeugen                                            *}
{**************************************************************}
constructor TMhsCanUtil.Create(AOwner: TComponent);

begin;
inherited Create(AOwner);

end;

{**************************************************************}
{* Object löschen                                             *}
{**************************************************************}
destructor TMhsCanUtil.Destroy;

begin

inherited Destroy;
end;

{**************************************************************}
{* Treiber DLL suchen                                         *}
{**************************************************************}
function TMhsCanUtil.TestCanUtil(name: String): Boolean;
var dll_wnd: HWnd;

begin;
result := False;
if length(name) > 0 then
  begin;
  dll_wnd := LoadLibrary(PChar(Name));
  if dll_wnd <> 0 then
    begin;
    if GetProcAddress(dll_wnd, 'CanUtilRegisterDriver') <> nil then
      result := True;
    FreeLibrary(dll_wnd);
    end;
  end;    
end;


function TMhsCanUtil.RegReadStringEntry(path, entry: String): String;
var R: TRegistry;

begin;
result := '';
{Registry Komponente erzeugen}
R := TRegistry.Create(KEY_READ);
R.RootKey := HKEY_LOCAL_MACHINE;
if R.OpenKey(path, False) then
  begin;
  result := R.ReadString(entry);
  end;
{Registry Komponente freigeben}
R.CloseKey;
R.Free;
end;


function TMhsCanUtil.GetCanUtilWithPath: String;
var file_name: String;

begin;
result := '';  
file_name := RegReadStringEntry(REG_TINY_CAN_API, REG_TINY_CAN_API_PATH_ENTRY);
if length(file_name) > 0 then
  begin;
  file_name := file_name + '\' + MHS_CAN_UTIL_DLL;
  if TestCanUtil(file_name) then
    result := file_name;
  end;
if length(result) = 0 then
  begin;
  file_name := ExtractFilePath(Application.ExeName) + MHS_CAN_UTIL_DLL;
  if TestCanUtil(file_name) then
    result := file_name;
  end;
end;


function TMhsCanUtil.CanUtilRegisterDriver(api_handle: Pointer; res: Integer): Integer;
begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilRegisterDriver) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanUtilRegisterDriver(api_handle, res);
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := ERR_NO_CAN_UTIL_DLL_LOAD;
end;


function TMhsCanUtil.CanUtilCloseWin(win_idx: DWORD): Integer;
begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilCloseWin) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanUtilCloseWin(win_idx);
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := ERR_NO_CAN_UTIL_DLL_LOAD;
end;


{/**************************************************************************************/}
{/*                          CAN Util Init/Down                                        */}
{/**************************************************************************************/}
function TMhsCanUtil.CanUtilInit: Integer;
begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilInit) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanUtilInit;
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := ERR_NO_CAN_UTIL_DLL_LOAD;
end;


procedure TMhsCanUtil.CanUtilDown;
begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilDown) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanUtilDown;
  InterlockedDecrement(DrvRefCounter);
  end
end;


{/**************************************************************************************/}
{/*                               Bit Timing                                           */}
{/**************************************************************************************/}
function TMhsCanUtil.CanUtilBitrateSelSetHw(tiny_can: String; revision: DWORD; snr: String; index: DWORD): Integer;
begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilBitrateSelSetHw) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanUtilBitrateSelSetHw(PAnsiChar(AnsiString(tiny_can)), revision, PAnsiChar(AnsiString(snr)), nil, 0, index);
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := ERR_NO_CAN_UTIL_DLL_LOAD;
end;


function TMhsCanUtil.CanUtilBitrateSelSetDefaults(flags, bitrate: DWORD; sp, sp_error: Double; fd_bitrate: DWORD; fd_sp, fd_sp_error: Double): Integer;
begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilBitrateSelSetDefaults) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanUtilBitrateSelSetDefaults(flags, bitrate, sp, sp_error, fd_bitrate, fd_sp, fd_sp_error);
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := ERR_NO_CAN_UTIL_DLL_LOAD;
end;                            


function TMhsCanUtil.CanUtilBitrateSelGetHwResult(var nbtr_value, bitrate, clock_idx: DWORD; var bitrate_str, description: String;
                                   var dbtr_value, fd_bitrate: DWORD; var fd_bitrate_str, fd_description: String): Integer;
var rd_bitrate_str, rd_description, rd_fd_bitrate_str, rd_fd_description: AnsiString;
                                   
begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilBitrateSelGetHwResult) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  SetLength(rd_bitrate_str, 21);
  SetLength(rd_description, 81);
  SetLength(rd_fd_bitrate_str, 21);
  SetLength(rd_fd_description, 81);
  result := pmCanUtilBitrateSelGetHwResult(@nbtr_value, @bitrate, @clock_idx, PAnsiChar(rd_bitrate_str), PAnsiChar(rd_description), 
    @dbtr_value, @fd_bitrate, PAnsiChar(rd_fd_bitrate_str), PAnsiChar(rd_fd_description));
  bitrate_str := String(rd_bitrate_str);
  description := String(rd_description);
  fd_bitrate_str := String(rd_fd_bitrate_str);
  fd_description := String(rd_fd_description);
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := ERR_NO_CAN_UTIL_DLL_LOAD;
end;
                                   

function TMhsCanUtil.CanUtilBitrateSelShowDialog(title, sub_title: String; flags: DWORD): Integer;
begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilBitrateSelShowDialog) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanUtilBitrateSelShowDialog(PAnsiChar(AnsiString(title)), PAnsiChar(AnsiString(sub_title)), flags);
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := ERR_NO_CAN_UTIL_DLL_LOAD;
end;

{/**************************************************************************************/}
{/*                          Driver DLLs Info                                          */}
{/**************************************************************************************/}
function TMhsCanUtil.CanUtilGetDriverList: TCanUtilDrvInfoObj;
var count, i: Integer;
    item: PCanUtilDrvInfo;
    drv_item: TCanUtilDrvInfoDrv;

begin;
if (CanUtilDllWnd = 0) or not Assigned(pmCanUtilGetDriverList) or not Assigned(pmCanUtilGetDriverListGet) then
  begin;
  result := nil;
  exit;
  end;
InterlockedIncrement(DrvRefCounter);  
count := pmCanUtilGetDriverList(nil);
if count > 0 then
  begin;
  result := TCanUtilDrvInfoObj.Create;  
  for i := 1 to count do
    begin;
    if pmCanUtilGetDriverListGet(@drv_item) < 1 then
      break;
    GetMem(item, sizeOf(TCanUtilDrvInfo));    
    item.Filename := ShortString(drv_item.Filename);
    item.Name := ShortString(drv_item.Name);
    item.Version := ShortString(drv_item.Version);
    item.Summary := ShortString(drv_item.Summary);
    item.Description := ShortString(drv_item.Description);
    item.InterfaceType := drv_item.InterfaceType;
    result.Add(item);
    end;  
  end
else
  result := nil;
InterlockedDecrement(DrvRefCounter);  
end;


function TMhsCanUtil.CanUtilGetSelectedDriver(var selected_drv: TCanUtilDrvInfo): Integer;
var drv_item: TCanUtilDrvInfoDrv;

begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilGetSelectedDriver) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanUtilGetSelectedDriver(@drv_item);
  selected_drv.Filename := ShortString(drv_item.Filename);
  selected_drv.Name := ShortString(drv_item.Name);
  selected_drv.Version := ShortString(drv_item.Version);
  selected_drv.Summary := ShortString(drv_item.Summary);
  selected_drv.Description := ShortString(drv_item.Description);
  selected_drv.InterfaceType := drv_item.InterfaceType;
  InterlockedDecrement(DrvRefCounter);  
  end
else
  result := ERR_NO_CAN_UTIL_DLL_LOAD;
end;
    

function TMhsCanUtil.CanUtilShowDriverList(title, sub_title: String; flags: DWORD; var drv_name: String): Integer;
var rd_name: AnsiString;

begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilShowDriverList) then
  begin;
  SetLength(rd_name, 40);
  result := pmCanUtilShowDriverList(PAnsiChar(AnsiString(title)), PAnsiChar(AnsiString(sub_title)), flags, PAnsiChar(rd_name));
  SetLength(rd_name, StrLen(PAnsiChar(rd_name)));
  drv_name := String(rd_name);
  end
else
  begin
  drv_name := '';
  result := ERR_NO_CAN_UTIL_DLL_LOAD;
  end;
end;


{/**************************************************************************************/}
{/*                          Connected Hardware                                        */}
{/**************************************************************************************/}
function TMhsCanUtil.CanUtilGetHwList: TCanDevicesListObj;
var count, i: Integer;
    item: PCanDevicesList;
    dev_item: TCanDevicesListDev;

begin;
if (CanUtilDllWnd = 0) or not Assigned(pmCanUtilGetHwList) or not Assigned(pmCanUtilGetHwListGet) then
  begin;
  result := nil;
  exit;
  end;
count := pmCanUtilGetHwList(nil);
if count > 0 then
  begin;
  result := TCanDevicesListObj.Create;
  InterlockedIncrement(DrvRefCounter);
  for i := 1 to count do
    begin;
    if pmCanUtilGetHwListGet(@dev_item) < 1 then
      break;
    GetMem(item, sizeOf(TCanDevicesList));
    item.TCanIdx := dev_item.TCanIdx;
    item.HwId := dev_item.HwId;
    item.DeviceName := ShortString(dev_item.DeviceName);
    item.SerialNumber := ShortString(dev_item.SerialNumber);
    item.Description := ShortString(dev_item.Description);
    item.ModulFeatures := dev_item.ModulFeatures;
    result.Add(item);
    end;
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := nil;
end;


function TMhsCanUtil.CanUtilGetSelectedHw(var item: TCanDevicesList): Integer;
var dev_item: TCanDevicesListDev;

begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilGetSelectedHw) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanUtilGetSelectedHw(@dev_item);
  item.TCanIdx := dev_item.TCanIdx;
  item.HwId := dev_item.HwId;
  item.DeviceName := ShortString(dev_item.DeviceName);
  item.SerialNumber := ShortString(dev_item.SerialNumber);
  item.Description := ShortString(dev_item.Description);
  item.ModulFeatures := dev_item.ModulFeatures;
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := ERR_NO_CAN_UTIL_DLL_LOAD;
end;


function TMhsCanUtil.CanUtilShowHwWin(title, sub_title: String; flags: DWORD; var snr: String): Integer;
var rd_snr: AnsiString;

begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilShowHwWin) then
  begin;
  SetLength(rd_snr, 40);
  result := pmCanUtilShowHwWin(PAnsiChar(AnsiString(title)), PAnsiChar(AnsiString(sub_title)), flags, PAnsiChar(rd_snr));
  SetLength(rd_snr, StrLen(PAnsiChar(rd_snr)));
  snr := String(rd_snr);
  end
else
  begin
  snr := '';
  result := ERR_NO_CAN_UTIL_DLL_LOAD;
  end;
end;


{/**************************************************************************************/}
{/*                            Show Hardware Info                                      */}
{/**************************************************************************************/}
function TMhsCanUtil.CanUtilHwInfoWin(title, sub_title: String; flags, index: DWORD): Integer;
begin;
if (CanUtilDllWnd <> 0) and Assigned(pmCanUtilHwInfoWin) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanUtilHwInfoWin(PAnsiChar(AnsiString(title)), PAnsiChar(AnsiString(sub_title)), flags, nil, 0, index);
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := ERR_NO_CAN_UTIL_DLL_LOAD;
end;


{**************************************************************}
{* MHS CAN Utilities DLL laden                                *}
{**************************************************************}
function TMhsCanUtil.LoadCanUtil: Integer;

begin;
result := 0;
try
  DownCanUtil;
  {Hardware Treiber laden}
  CanUtilDllWnd := LoadLibrary(PChar(GetCanUtilWithPath));
  if CanUtilDllWnd = 0 then raise ECanUtilDllLoadError.create('DLL "mhscanutil.dll" wurde nicht gefunden');
  pmCanUtilInit := GetProcAddress(CanUtilDllWnd, 'CanUtilInit');
  pmCanUtilDown := GetProcAddress(CanUtilDllWnd, 'CanUtilDown');
  pmCanUtilRegisterDriver := GetProcAddress(CanUtilDllWnd, 'CanUtilRegisterDriver');
  pmCanUtilCloseWin := GetProcAddress(CanUtilDllWnd, 'CanUtilCloseWin'); 
  pmCanUtilBitrateSelSetHw := GetProcAddress(CanUtilDllWnd, 'CanUtilBitrateSelSetHw');  
  pmCanUtilBitrateSelSetDefaults := GetProcAddress(CanUtilDllWnd, 'CanUtilBitrateSelSetDefaults');
  pmCanUtilBitrateSelGetHwResult := GetProcAddress(CanUtilDllWnd, 'CanUtilBitrateSelGetHwResult');
  pmCanUtilBitrateSelShowDialog := GetProcAddress(CanUtilDllWnd, 'CanUtilBitrateSelShowDialog');
  pmCanUtilGetDriverList := GetProcAddress(CanUtilDllWnd, 'CanUtilGetDriverList');
  pmCanUtilGetDriverListGet := GetProcAddress(CanUtilDllWnd, 'CanUtilGetDriverListGet');
  pmCanUtilGetSelectedDriver := GetProcAddress(CanUtilDllWnd, 'CanUtilGetSelectedDriver');
  pmCanUtilShowDriverList := GetProcAddress(CanUtilDllWnd, 'CanUtilShowDriverList');
  pmCanUtilGetHwList := GetProcAddress(CanUtilDllWnd, 'CanUtilGetHwList');
  pmCanUtilGetHwListGet := GetProcAddress(CanUtilDllWnd, 'CanUtilGetHwListGet');
  pmCanUtilGetSelectedHw := GetProcAddress(CanUtilDllWnd, 'CanUtilGetSelectedHw');
  pmCanUtilShowHwWin := GetProcAddress(CanUtilDllWnd, 'CanUtilShowHwWin');
  pmCanUtilHwInfoWin := GetProcAddress(CanUtilDllWnd, 'CanUtilHwInfoWin');

  if @pmCanUtilInit = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilInit" not found in "mhscanutil.dll"');
  if @pmCanUtilDown = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilDown" not found in "mhscanutil.dll"');
  if @pmCanUtilRegisterDriver = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilRegisterDriver" not found in "mhscanutil.dll"');
  if @pmCanUtilCloseWin = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilCloseWin" not found in "mhscanutil.dll"');
  if @pmCanUtilBitrateSelSetHw = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilBitrateSelSetHw" not found in "mhscanutil.dll"');  
  if @pmCanUtilBitrateSelSetDefaults = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilBitrateSelSetDefaults" not found in "mhscanutil.dll"');
  if @pmCanUtilBitrateSelGetHwResult = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilBitrateSelGetHwResult" not found in "mhscanutil.dll"');
  if @pmCanUtilBitrateSelShowDialog = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilBitrateSelShowDialog" not found in "mhscanutil.dll"');
  if @pmCanUtilGetDriverList = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilGetDriverList" not found in "mhscanutil.dll"');
  if @pmCanUtilGetDriverListGet = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilGetDriverListGet" not found in "mhscanutil.dll"');
  if @pmCanUtilGetSelectedDriver = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilGetSelectedDriver" not found in "mhscanutil.dll"');
  if @pmCanUtilShowDriverList = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilShowDriverList" not found in "mhscanutil.dll"');
  if @pmCanUtilGetHwList = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilGetHwList" not found in "mhscanutil.dll"');
  if @pmCanUtilGetHwListGet = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilGetHwListGet" not found in "mhscanutil.dll"');
  if @pmCanUtilGetSelectedHw = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilGetSelectedHw" not found in "mhscanutil.dll"');
  if @pmCanUtilShowHwWin = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilShowHwWin" not found in "mhscanutil.dll"');
  if @pmCanUtilHwInfoWin = nil then raise ECanUtilDllLoadError.create('Entry point "CanUtilHwInfoWin" not found in "mhscanutil.dll"');
except
  DownCanUtil;
  result := -1;
  end;
if result > -1 then
  result := CanUtilInit;
if result < 0 then
  DownCanUtil;
end;


procedure TMhsCanUtil.DownCanUtil;
var dll_wnd: HWnd;

begin;
CanUtilDown;
dll_wnd := CanUtilDllWnd;
CanUtilDllWnd := 0;
pmCanUtilInit := nil;
pmCanUtilDown := nil;
pmCanUtilRegisterDriver := nil;
pmCanUtilCloseWin := nil;
pmCanUtilBitrateSelSetHw := nil;  
pmCanUtilBitrateSelSetDefaults := nil;
pmCanUtilBitrateSelGetHwResult := nil;
pmCanUtilBitrateSelShowDialog := nil;
pmCanUtilGetDriverList := nil;
pmCanUtilGetDriverListGet := nil;
pmCanUtilGetSelectedDriver := nil;
pmCanUtilShowDriverList := nil;
pmCanUtilGetHwList := nil;
pmCanUtilGetHwListGet := nil;
pmCanUtilGetSelectedHw := nil;
pmCanUtilShowHwWin := nil;
pmCanUtilHwInfoWin := nil;
if dll_wnd <> 0 then
  FreeLibrary(dll_wnd);      
end;


procedure Register;
begin
  RegisterComponents('MHS', [TMhsCanUtil]);
end;

end.