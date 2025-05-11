{ *********** TINY - CAN Treiber **************                          }
{  begin             : 01.02.2017                                        }
{  last modify       : 01.08.2022                                        }
{  copyright         : (C) 2017 - 2022 by MHS-Elektronik GmbH & Co. KG   }
{                             http://www.mhs-elektronik.de               }
{  author            : Klaus Demlehner, klaus@mhs-elektronik.de          }
{                                                                        }
{ This program is free software; you can redistribute it and/or modify   }
{ it under the terms of the GNU General Public License as published by   }
{ the Free Software Foundation; either version 2 of the License, or      }
{ (at your option) any later version.                                    }
{                                                                        }
{ This program is distributed in the hope that it will be useful,        }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of         }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          }
{ GNU General Public License for more details.                           }
{                                                                        }
{ You should have received a copy of the GNU General Public License      }
{ along with this program; if not, write to the Free Software            }
{ Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.              }

unit TinyCanDrv;

interface


{$WARN SYMBOL_DEPRECATED OFF}
{$IFNDEF VER140}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CODE OFF}
{$ENDIF}

uses
  Windows, SysUtils, Messages, Classes, ComCtrls, Forms, Controls, Registry, Contnrs;

const 
  // ***** CAN-FD Flags
  FlagCanFdTxD: Word    = ($0001);  // TxD -> 1 = Tx CAN Nachricht, 0 = Rx CAN Nachricht
  FlagCanFdError: Word  = ($0002);  // Error -> 1 = CAN Bus Fehler Nachricht
  FlagCanFdRTR: Word    = ($0004);  // Remote Transmition Request bit -> Kennzeichnet eine RTR Nachricht
  FlagCanFdEFF: Word    = ($0008);  // Extended Frame Format bit -> 1 = 29 Bit Id's, 0 = 11 Bit Id's
  FlagCanFdFD: Word     = ($0010);  // CAN-FD Frame
  FlagCanFdBRS: Word    = ($0020);  // Bit Rate Switch
  FlagCanFdOV: Word     = ($0080);  // FIFO Overrun
  FlagCanFdFilHit: Word = ($8000);  // FilHit -> 1 = Filter Hit

  FlagsCanLength: DWORD = ($0000000F);
  FlagsCanTxD: DWORD    = ($00000010);
  FlagsCanError: DWORD  = ($00000020);
  FlagsCanRTR: DWORD    = ($00000040);
  FlagsCanEFF: DWORD    = ($00000080);
  FlagsCanSource: DWORD = ($0000FF00); // Quelle der Nachricht (Device)
  FlagsCanFilHit: DWORD = ($00010000); // FilHit -> 1 = Filter Hit

  FilFlagsEFF: DWORD    = ($00000080);
  FilFlagsEnable: DWORD = ($80000000);

  INDEX_FIFO_PUFFER_MASK: DWORD = ($0000FFFF);
  INDEX_SOFT_FLAG: DWORD        = ($02000000);
  INDEX_RXD_TXT_FLAG: DWORD     = ($01000000);
  INDEX_CAN_KANAL_MASK: DWORD   = ($000F0000);
  INDEX_CAN_DEVICE_MASK: DWORD  = ($00F00000);

  INDEX_CAN_KANAL_A: DWORD      = ($00000000);
  INDEX_CAN_KANAL_B: DWORD      = ($00010000);
  INDEX_INVALID: DWORD          = ($FFFFFFFF);

  CAN_CMD_NONE: Word              = ($0000);
  CAN_CMD_RXD_OVERRUN_CLEAR: Word = ($0001);
  CAN_CMD_RXD_FIFOS_CLEAR: Word   = ($0002);
  CAN_CMD_TXD_OVERRUN_CLEAR: Word = ($0004);
  CAN_CMD_TXD_FIFOS_CLEAR: Word   = ($0008);
  CAN_CMD_HW_FILTER_CLEAR: Word   = ($0010);
  CAN_CMD_SW_FILTER_CLEAR: Word   = ($0020);
  CAN_CMD_TXD_PUFFERS_CLEAR: Word = ($0040);

  CAN_CMD_ALL_CLEAR: Word         = ($0FFF);

  // SetEvent
  EVENT_ENABLE_PNP_CHANGE: Word          = ($0001);
  EVENT_ENABLE_STATUS_CHANGE: Word       = ($0002);
  EVENT_ENABLE_RX_FILTER_MESSAGES: Word  = ($0004);
  EVENT_ENABLE_RX_MESSAGES: Word         = ($0008);
  EVENT_ENABLE_ALL: Word                 = ($00FF);

  EVENT_DISABLE_PNP_CHANGE: Word         = ($0100);
  EVENT_DISABLE_STATUS_CHANGE: Word      = ($0200);
  EVENT_DISABLE_RX_FILTER_MESSAGES: Word = ($0400);
  EVENT_DISABLE_RX_MESSAGES: Word        = ($0800);
  EVENT_DISABLE_ALL: Word                = ($FF00);

  MHS_EVENT_TERMINATE: DWORD             = ($80000000);
  
  // MHS (EV)ent (S)ource
  MHS_EVS_STATUS: DWORD                  = (1);
  MHS_EVS_PNP: DWORD                     = (2);
  MHS_EVS_OBJECT: DWORD                  = (3); 
  MHS_EVS_DIN: DWORD                     = (4);
  MHS_EVS_ENC: DWORD                     = (5);
  MHS_EVS_KEY: DWORD                     = (6);

  TCAN_LOG_MESSAGE: DWORD                = ($00000001);
  TCAN_LOG_STATUS: DWORD                 = ($00000002);
  TCAN_LOG_RX_MSG: DWORD                 = ($00000004);
  TCAN_LOG_TX_MSG: DWORD                 = ($00000008);
  TCAN_LOG_API_CALL: DWORD               = ($00000010);
  TCAN_LOG_ERROR: DWORD                  = ($00000020);
  TCAN_LOG_WARN: DWORD                   = ($00000040);
  TCAN_LOG_ERR_MSG: DWORD                = ($00000080);
  TCAN_LOG_OV_MSG: DWORD                 = ($00000100);
  TCAN_LOG_DEBUG: DWORD                  = ($08000000);
  TCAN_LOG_WITH_TIME: DWORD              = ($40000000);
  TCAN_LOG_DISABLE_SYNC: DWORD           = ($80000000);
  
  DELPHI_RX_EVENT: DWORD                 = ($00000001);
  DELPHI_PNP_EVENT: DWORD                = ($00000002);
  DELPHI_STATUS_EVENT: DWORD             = ($00000004);
  DELPHI_RX_FILTER_EVENT: DWORD          = ($00000008);
  
  // <*>
  TCAN_INFO_KEY_OPEN_INDEX: DWORD    = ($01000001);
  TCAN_INFO_KEY_HARDWARE_ID: DWORD   = ($01000002);
  TCAN_INFO_KEY_HARDWARE: DWORD      = ($01000003);
  TCAN_INFO_KEY_VENDOR: DWORD        = ($01000004);
  TCAN_INFO_KEY_DEVICE_NAME: DWORD   = ($01000005);
  TCAN_INFO_KEY_SERIAL_NUMBER: DWORD = ($01000006);
  TCAN_INFO_KEY_FEATURES: DWORD      = ($01000007);
  TCAN_INFO_KEY_CAN_CHANNELS: DWORD  = ($01000008);
  TCAN_INFO_KEY_RX_FILTER_CNT: DWORD = ($01000009); 
  TCAN_INFO_KEY_TX_BUFFER_CNT: DWORD = ($0100000A);
  TCAN_INFO_KEY_CAN_CLOCKS: DWORD    = ($0100000B);
  TCAN_INFO_KEY_CAN_CLOCK1: DWORD    = ($0100000C);
  TCAN_INFO_KEY_CAN_CLOCK2: DWORD    = ($0100000D);
  TCAN_INFO_KEY_CAN_CLOCK3: DWORD    = ($0100000E);
  TCAN_INFO_KEY_CAN_CLOCK4: DWORD    = ($0100000F);
  TCAN_INFO_KEY_API_VERSION: DWORD   = ($02000001);
  TCAN_INFO_KEY_DLL: DWORD           = ($02000002);
  TCAN_INFO_KEY_CFG_APP: DWORD       = ($02000003);
  
  {#define DEV_LIST_SHOW_TCAN_ONLY 0x01
  #define DEV_LIST_SHOW_UNCONNECT 0x02

  #define CAN_FEATURE_LOM          0x0001  // Silent Mode (LOM = Listen only Mode)
  #define CAN_FEATURE_ARD          0x0002  // Automatic Retransmission disable
  #define CAN_FEATURE_TX_ACK       0x0004  // TX ACK (Gesendete Nachrichten bestätigen)
  #define CAN_FEATURE_HW_TIMESTAMP 0x8000  // Hardware Time Stamp}
  
  CanSpeedTab: array[0..9] of Word = (0,      // Cusom Speed
                                      10,    // 10 kBit/s
                                      20,    // 20 kBit/s
                                      50,    // 50 kBit/s
                                      100,   // 100 kBit/s
                                      125,   // 125 kBit/s
                                      250,   // 250 kBit/s
                                      500,   // 500 kBit/s
                                      800,   // 800 kBit/s
                                      1000); // 1 MBit/s

   CanFdSpeedTab: array[0..16] of Word = (0,     // Cusom Speed
                                         125,    // 125 kBit/s
                                         250,    // 250 kBit/s
                                         500,    // 500 kBit/s                                         
                                         1000,   // 1 MBit/s
                                         1500,   // 1,5 MBit/s
                                         2000,   // 2 MBit/s
                                         3000,   // 3 MBit/s
                                         4000,   // 4 MBit/s
                                         5000,   // 5 MBit/s 
                                         6000,   // 6 MBit/s 
                                         7000,   // 7 MBit/s 
                                         8000,   // 8 MBit/s 
                                         9000,   // 9 MBit/s 
                                         10000,  // 10 MBit/s
                                         11000,  // 11 MBit/s
                                         12000); // 12 MBit/s                                         
   
   BaudRateTab: array[0..18] of DWord = (0,
                                         4800,
                                         9600,
                                         10400,
                                         14400,
                                         19200,
                                         28800,
                                         38400,
                                         57600,
                                         115200,
                                         125000,
                                         153600,
                                         230400,
                                         250000,
                                         460800,
                                         500000,
                                         921600,
                                         1000000,
                                         3000000);                                      

  API_DRIVER_DLL: String = 'mhstcan.dll';
  REG_TINY_CAN_API: String = 'Software\Tiny-CAN\API\';
  REG_TINY_CAN_API_PATH_ENTRY: String = 'PATH';
  
// EX-API Konstanten
// (V)alue (T)ype
MhsValueTypeTab: array[0..26] of DWord = ($00,  // VT_ANY
                                          $01,  // VT_BYTE
                                          $02,  // VT_UBYTE      
                                          $03,  // VT_WORD       
                                          $04,  // VT_UWORD      
                                          $05,  // VT_LONG       
                                          $06,  // VT_ULONG      
                                          $07,  // VT_BYTE_ARRAY 
                                          $08,  // VT_UBYTE_ARRAY
                                          $09,  // VT_WORD_ARRAY
                                          $0A,  // VT_UWORD_ARRAY
                                          $0B,  // VT_LONG_ARRAY
                                          $0C,  // VT_ULONG_ARRAY
                                          $0D,  // VT_BYTE_RANGE_ARRAY 
                                          $0E,  // VT_UBYTE_RANGE_ARRAY
                                          $0F,  // VT_WORD_RANGE_ARRAY 
                                          $10,  // VT_UWORD_RANGE_ARRAY
                                          $11,  // VT_LONG_RANGE_ARRAY 
                                          $12,  // VT_ULONG_RANGE_ARRAY
                                          $40,  // VT_HBYTE  
                                          $41,  // VT_HWORD  
                                          $42,  // VT_HLONG  
                                          $80,  // VT_STREAM 
                                          $81,  // VT_STRING 
                                          $82,  // VT_POINTER
                                          $83,  // REVISION
                                          $84); // DATE 

type
EDllLoadError = class(Exception);

// CAN Übertragungsgeschwindigkeit
TCanFdSpeed = (FD_CUSTOM_SPEED, FD_125K_BIT, FD_250K_BIT, FD_500K_BIT, FD_1M_BIT, FD_1M5_BIT, FD_2M_BIT, FD_3M_BIT,
               FD_4M_BIT, FD_5M_BIT, FD_6M_BIT, FD_7M_BIT, FD_8M_BIT, FD_9M_BIT, FD_10M_BIT, FD_11M_BIT, FD_12M_BIT);
               
TCanSpeed = (CAN_CUSTOM_SPEED,CAN_10K_BIT, CAN_20K_BIT, CAN_50K_BIT, CAN_100K_BIT, CAN_125K_BIT,
             CAN_250K_BIT, CAN_500K_BIT, CAN_800K_BIT, CAN_1M_BIT);

TSerialBaudRate = (SER_AUTO_BAUD, SER_4800_BAUD, SER_9600_BAUD, SER_10k4_BAUD, 
                   SER_14k4_BAUD, SER_19k2_BAUD, SER_28k8_BAUD, SER_38k4_BAUD,
                   SER_57k6_BAUD, SER_115k2_BAUD, SER_125k_BAUD, SER_153k6_BAUD,
                   SER_230k4_BAUD, SER_250k_BAUD, SER_460k8_BAUD, SER_500k_BAUD,
                   SER_921k6_BAUD, SER_1M_BAUD, SER_3M_BAUD);

TEventMask = (CAN_TIMEOUT_EVENT, PNP_CHANGE_EVENT, STATUS_CHANGE_EVENT, RX_FILTER_MESSAGES_EVENT,
              RX_MESSAGES_EVENT);
TEventMasks = set of TEventMask;
TInterfaceType = (INTERFACE_USB, INTERFACE_SERIEL);

TLogFlag = (LOG_MESSAGE, LOG_STATUS, LOG_RX_MSG, LOG_TX_MSG, LOG_API_CALL, LOG_ERROR, LOG_WARN,
            LOG_ERR_MSG, LOG_OV_MSG, LOG_DEBUG, LOG_WITH_TIME, LOG_DISABLE_SYNC); 
TLogFlags = set of TLogFlag;


// CAN Bus Mode
TCanMode = (OP_CAN_NONE,              // 0 = keine Änderung
            OP_CAN_START,             // 1 = Startet den CAN Bus
            OP_CAN_STOP,              // 2 = Stopt den CAN Bus
            OP_CAN_RESET,             // 3 = Reset CAN Controller
            OP_CAN_START_LOM,         // 4 = Startet den CAN-Bus im Silent Mode (Listen Only Mode)
            OP_CAN_START_NO_RETRANS); // 5 = Startet den CAN-Bus im Automatic Retransmission disable Mode
PCanMode = ^TCanMode;

// DrvStatus
TDrvStatus = (DRV_NOT_LOAD,             // 0 = Die Treiber DLL wurde noch nicht geladen
              DRV_STATUS_NOT_INIT,      // 1 = Treiber noch nicht Initialisiert
              DRV_STATUS_INIT,          // 2 = Treiber erfolgrich Initialisiert
              DRV_STATUS_PORT_NOT_OPEN, // 3 = Die Schnittstelle wurde geöffnet
              DRV_STATUS_PORT_OPEN,     // 4 = Die Schnittstelle wurde nicht geöffnet
              DRV_STATUS_DEVICE_FOUND,  // 5 = Verbindung zur Hardware wurde Hergestellt
              DRV_STATUS_CAN_OPEN,      // 6 = Device wurde geöffnet und erfolgreich Initialisiert
              DRV_STATUS_CAN_RUN_TX,    // 7 = CAN Bus RUN nur Transmitter (wird nicht verwendet !)
              DRV_STATUS_CAN_RUN);      // 8 = CAN Bus RUN
PDrvStatus = ^TDrvStatus;

// CanStatus
TCanStatus = (CAN_STATUS_OK,            // 0 = CAN-Controller: Ok
              CAN_STATUS_ERROR,         // 1 = CAN-Controller: CAN Error
              CAN_STATUS_WARNING,       // 2 = CAN-Controller: Error warning
              CAN_STATUS_PASSIV,        // 3 = CAN-Controller: Error passiv
              CAN_STATUS_BUS_OFF,       // 4 = CAN-Controller: Bus Off
              CAN_STATUS_UNBEKANNT);    // 5 = CAN-Controller: Status Unbekannt
PCanStatus = ^TCanStatus;

// Fifo Status
TCanFifoStatus = (CAN_FIFO_OK,                // 0 = Fifo-Status: Ok
                  CAN_FIFO_HW_OVERRUN,        // 1 = Fifo-Status: Überlauf
                  CAN_FIFO_SW_OVERRUN,        // 2 = Fifo-Status: Überlauf
                  CAN_FIFO_HW_SW_OVERRUN,     // 3 = Fifo-Status: Überlauf
                  CAN_FIFO_STATUS_UNBEKANNT); // 4 = Fifo-Status: Unbekannt
PCanFifoStatus = ^TCanFifoStatus;

// EX-API Typen definitionen
// (V)alue (T)ype
TMhsValueType = (VT_ANY, VT_BYTE, VT_UBYTE, VT_WORD, VT_UWORD, VT_LONG, VT_ULONG, VT_BYTE_ARRAY,
                 VT_UBYTE_ARRAY, VT_WORD_ARRAY, VT_UWORD_ARRAY, VT_LONG_ARRAY, VT_ULONG_ARRAY,
                 VT_BYTE_RANGE_ARRAY, VT_UBYTE_RANGE_ARRAY, VT_WORD_RANGE_ARRAY,
                 VT_UWORD_RANGE_ARRAY, VT_LONG_RANGE_ARRAY, VT_ULONG_RANGE_ARRAY, VT_HBYTE,
                 VT_HWORD, VT_HLONG, VT_STREAM, VT_STRING, VT_POINTER, VT_REVISION, VT_DATE);

TIdFilterMode = (CAN_FILTER_MASKE_CODE, CAN_FILTER_START_STOP, CAN_FILTER_SINGLE_ID);

{/******************************************/}
{/*            CAN Message Type            */}
{/******************************************/}
TCanData = packed record
  case Integer of
    0: (Chars: array[0..7] of AnsiChar);
    1: (Bytes: array[0..7] of Byte);
    2: (Words: array[0..3] of Word);
    3: (Longs: array[0..1] of DWORD);
  end;
PCanData = ^TCanData;

TCanTime = packed record
  Sec: DWORD;
  USec: DWORD;
  end;
PCanTime = ^TCanTime;

TCanMsg = packed record
  Id: DWORD;
  Flags: DWORD;
  Data: TCanData;
  Time: TCanTime;
  end;
 PCanMsg = ^TCanMsg;

{/******************************************/}
{/*        CAN-FD Message Type             */}
{/******************************************/}
TCanFdData = packed record
  case Integer of
    0: (Chars: array[0..63] of AnsiChar);
    1: (Bytes: array[0..63] of Byte);
    2: (Words: array[0..31] of Word);
    3: (Longs: array[0..15] of DWORD);
  end;
PCanFdData = ^TCanFdData;

TCanFdMsg = packed record
  Id: DWORD;
  Source: Byte;
  Length: Byte;
  Flags: Word;
  Data: TCanFdData;
  Time: TCanTime;
  end;
PCanFdMsg = ^TCanFdMsg;  

{/******************************************/}
{/*         CAN Message Filter Type        */}
{/******************************************/}
TMsgFilterDrv = packed record
  Maske: DWORD;
  Code: DWORD;
  Flags: DWORD;
  Data: TCanData;
  end;
PMsgFilterDrv = ^TMsgFilterDrv;

TMsgFilter = record
  Code_Start_Id: DWORD;
  Maske_Stop: DWORD;
  Enabled: Boolean;  
  RTR: Boolean;            // remote transmition request bit
  EFF: Boolean;            // extended frame bit
  PurgeMessage: Boolean;    
  IdMode: TIdFilterMode;
  end;

{/******************************************/}
{/*             Device Status              */}
{/******************************************/}
TDeviceStatus = record
  DrvStatus: TDrvStatus;
  CanStatus: TCanStatus;
  FifoStatus: TCanFifoStatus;
  BusFailure: boolean;
  end;
PDeviceStatus = ^TDeviceStatus;


TDeviceStatusDrv = packed record
  DrvStatus: Integer;
  CanStatus: Byte;
  FifoStatus: Byte;
  end;
PDeviceStatusDrv = ^TDeviceStatusDrv;

// EX-API
TModulFeatures = packed record
  CanClock: DWORD;           // Clock-Frequenz des CAN-Controllers, muss nicht mit
                             // der Clock-Frequenz des Mikrocontrollers übereinstimmen
  Flags: DWORD;              // Unterstützte Features des Moduls:
                             //  Bit  0 -> Silent Mode (LOM = Listen only Mode)
                             //       1 -> Automatic Retransmission disable
                             //       2 -> TX ACK (Gesendete Nachrichten bestätigen)
                             //       3 -> Error Messages Support
                             //       8 -> CAN-FD Hardware
                             //      15 -> Hardware Time Stamp
  CanChannelsCount: DWORD;   // Anzahl der CAN Schnittstellen, reserviert für
                             // zukünftige Module mit mehr als einer Schnittstelle
  HwRxFilterCount: DWORD;    // Anzahl der zur Verfügung stehenden Receive-Filter
  HwTxPufferCount: DWORD;    // Anzahl der zur Verfügung stehenden Transmit Puffer mit Timer
  end;

TCanDevicesList = record
  TCanIdx: DWORD;                     // Ist das Device geöffnet ist der Wert auf dem Device-Index
                                      // gesetzt, ansonsten ist der Wert auf "INDEX_INVALID" gesetzt.
  HwId: DWORD;                        // Ein 32 Bit Schlüssel der die Hardware eindeutig Identifiziert.
                                      // Manche Module müssen erst geöffnet werden damit dieser Wert
                                      // gesetzt wird
  DeviceName: String[255];            // Nur Linux: entspricht den Device Namen des USB-Devices,
                                      //            z.B. /dev/ttyUSB0
  SerialNumber: String[16];           // Seriennummer des Moduls
  Description: String[64];            // Modul Bezeichnung, z.B. "Tiny-CAN IV-XL",
                                      // muss in den USB-Controller programmiert sein,
                                      // was zur Zeit nur bei den Modulen Tiny-CAN II-XL,
                                      // IV-XL u. M1 der Fall ist.
  ModulFeatures: TModulFeatures;      // Unterstützte Features des Moduls, nur gültig
                                      // wenn HwId > 0
  end;
PCanDevicesList = ^TCanDevicesList;


TCanDevicesListDev = packed record
  TCanIdx: DWORD;                         // Ist das Device geöffnet ist der Wert auf dem Device-Index
                                          // gesetzt, ansonsten ist der Wert auf "INDEX_INVALID" gesetzt.
  HwId: DWORD;                            // Ein 32 Bit Schlüssel der die Hardware eindeutig Identifiziert.
                                          // Manche Module müssen erst geöffnet werden damit dieser Wert
                                          // gesetzt wird
  DeviceName: array[0..254] of AnsiChar;  // Nur Linux: entspricht den Device Namen des USB-Devices,
                                          //            z.B. /dev/ttyUSB0
  SerialNumber: array[0..15] of AnsiChar; // Seriennummer des Moduls
  Description: array[0..63] of AnsiChar;  // Modul Bezeichnung, z.B. "Tiny-CAN IV-XL",
                                          // muss in den USB-Controller programmiert sein,
                                          // was zur Zeit nur bei den Modulen Tiny-CAN II-XL,
                                          // IV-XL u. M1 der Fall ist.
  ModulFeatures: TModulFeatures;          // Unterstützte Features des Moduls, nur gültig
                                          // wenn HwId > 0
  end;
PCanDevicesListDev = ^TCanDevicesListDev; 


TCanDeviceInfo = record
  HwId: DWORD;                            // Ein 32 Bit Schlüssel der die Hardware eindeutig Identifiziert.
  FirmwareVersion: DWORD;                 // Version der Firmware des Tiny-CAN Moduls
  FirmwareInfo: DWORD;                    // Informationen zum Stand der Firmware Version
                                          //   0 = Unbekannt
                                          //   1 = Firmware veraltet, Device kann nicht geöffnet werden
                                          //   2 = Firmware veraltet, Funktionsumfang eingeschränkt
                                          //   3 = Firmware veraltet, keine Einschränkungen
                                          //   4 = Firmware auf Stand
                                          //   5 = Firmware neuer als Erwartet
  SerialNumber: String[16];               // Seriennummer des Moduls
  Description: String[64];                // Modul Bezeichnung, z.B. "Tiny-CAN IV-XL"
  ModulFeatures: TModulFeatures;          // Unterstützte Features des Moduls
  end;
PCanDeviceInfo = ^TCanDeviceInfo;

TCanDeviceInfoDev = packed record
  HwId: DWORD;                            // Ein 32 Bit Schlüssel der die Hardware eindeutig Identifiziert.
  FirmwareVersion: DWORD;                 // Version der Firmware des Tiny-CAN Moduls
  FirmwareInfo: DWORD;                    // Informationen zum Stand der Firmware Version
                                          //   0 = Unbekannt
                                          //   1 = Firmware veraltet, Device kann nicht geöffnet werden
                                          //   2 = Firmware veraltet, Funktionsumfang eingeschränkt
                                          //   3 = Firmware veraltet, keine Einschränkungen
                                          //   4 = Firmware auf Stand
                                          //   5 = Firmware neuer als Erwartet
  SerialNumber: array[0..15] of AnsiChar; // Seriennummer des Moduls
  Description: array[0..63] of AnsiChar;  // Modul Bezeichnung, z.B. "Tiny-CAN IV-XL"
  ModulFeatures: TModulFeatures;          // Unterstützte Features des Moduls
  end;
PCanDeviceInfoDev = ^TCanDeviceInfoDev;


TCanInfoVarDate = record
  D:DWORD;
  M:DWORD;
  Y:DWORD;
  end;

TCanInfoVarVer = record
  Major: DWORD;
  Minor: DWORD;
  Revision: DWORD; 
  end;
 
TCanInfoValue = record
  case byte of 
    0: (I8Value: AnsiChar);
    1: (U8Value: Byte);
    2: (I16Value: Smallint);
    3: (U16Value: Word);
    4: (I32Value: Longint);
    5: (U32Value: DWord);
    6: (StrValue: String[255]);
    7: (DateValue: TCanInfoVarDate);
    8: (VerValue: TCanInfoVarVer);
  end;

TCanInfoVar = record
  Key: DWORD;                      // Variablen Schlüssel
  ValueType: TMhsValueType;        // Variablen Type
  Size: DWORD;                     // (Max)Größe der Variable in Byte
  Value: TCanInfoValue;
  ValueStr: String[80];
  end;
PCanInfoVar = ^TCanInfoVar;

TCanInfoVarDev = packed record
  Key: DWORD;                      // Variablen Schlüssel
  ValueType: DWORD;                // Variablen Type
  Size: DWORD;                     // (Max)Größe der Variable in Byte
  Data: array[0..254] of Byte;     // Wert der Variable
  end;
PCanInfoVarDev = ^TCanInfoVarDev;


{/***************************************************************/}
{/*  Funktionstypen                                             */}
{/***************************************************************/}
TF_CanInitDriver = function(options: PAnsiChar): Integer; stdcall;
TF_CanDownDriver = procedure; stdcall;
TF_CanSetOptions = function(options: PAnsiChar): Integer; stdcall;
TF_CanDeviceOpen = function(index: DWORD; parameter: PAnsiChar): Integer; stdcall;
TF_CanDeviceClose = function(index: DWORD): Integer; stdcall;
TF_CanSetMode = function(index: DWORD; can_op_mode: Byte; can_command: Word): Integer; stdcall;

TF_CanTransmit = function(index: DWORD; msg: PCanMsg; count: Integer): Integer; stdcall;
TF_CanTransmitClear = procedure(index: DWORD); stdcall;
TF_CanTransmitGetCount = function(index: DWORD): DWORD; stdcall;
TF_CanTransmitSet = function(index: DWORD; cmd: Word; time: DWORD): Integer; stdcall;
TF_CanReceive = function(index: DWORD; msg: PCanMsg; count: Integer): Integer; stdcall;
TF_CanReceiveClear = procedure(index: DWORD); stdcall;
TF_CanReceiveGetCount = function(index: DWORD): DWORD; stdcall;

TF_CanSetSpeed = function(index: DWORD; speed: Word): Integer; stdcall;
TF_CanSetSpeedUser = function(index: DWORD; value: DWORD): Integer; stdcall;
TF_CanDrvInfo = function: PAnsiChar; stdcall;
TF_CanDrvHwInfo = function(index: DWORD): PAnsiChar; stdcall;
TF_CanSetFilter = function(index: DWORD; msg_filter: PMsgFilterDrv): Integer; stdcall;

TF_CanGetDeviceStatus = function(index: DWORD; status: PDeviceStatusDrv): Integer; stdcall;

TF_CanSetEvents = procedure(events: Word); stdcall;
TF_CanEventStatus = function:DWORD; stdcall;

// EX-API
TF_CanExGetDeviceCount = function(flags: Integer): Integer; stdcall;
TF_CanExGetDeviceListPerform = function(flags: Integer): Integer; stdcall;
TF_CanExGetDeviceListGet = function(item: PCanDevicesListDev): Integer; stdcall;
TF_CanExGetDeviceInfoPerform = function(index: DWORD; device_info: PCanDeviceInfoDev): Integer; stdcall;
TF_CanExGetDeviceInfoGet = function(item: PCanInfoVarDev): Integer; stdcall;

TF_CanExCreateDevice = function(index: PDWORD; options: PAnsiChar): Integer; stdcall;
TF_CanExDestroyDevice = function(index: PDWORD): Integer; stdcall;
TF_CanExCreateFifo = function(index: DWORD; size: DWORD; event_obj: Pointer; event: DWORD; channels: DWORD): Integer; stdcall;
TF_CanExBindFifo = function(fifo_index: DWORD; device_index: DWORD; bind: DWORD): Integer; stdcall;
TF_CanExCreateEvent = function: Pointer; stdcall;
TF_CanExSetObjEvent = function(index: DWORD; source: DWORD; event_obj: Pointer; event: DWORD): Integer; stdcall;
TF_CanExSetEvent = procedure(event_obj: Pointer; event: DWORD); stdcall;
TF_CanExSetEventAll = procedure(event: DWORD); stdcall;
TF_CanExResetEvent = procedure(event_obj: Pointer; event: DWORD); stdcall;
TF_CanExWaitForEvent = function(event_obj: Pointer; timeout: DWORD): DWORD; stdcall;

TF_CanExInitDriver = function(options: PAnsiChar): Integer; stdcall;
TF_CanExSetOptions = function(index: DWORD; name: PAnsiChar; options: PAnsiChar): Integer; stdcall;
TF_CanExSetAsByte = function(index: DWORD; name: PAnsiChar; value: shortint): Integer; stdcall;
TF_CanExSetAsWord = function(index: DWORD; name: PAnsiChar; value: smallint): Integer; stdcall;
TF_CanExSetAsLong = function(index: DWORD; name: PAnsiChar; value: Integer): Integer; stdcall;
TF_CanExSetAsUByte = function(index: DWORD; name: PAnsiChar; value: Byte): Integer; stdcall;
TF_CanExSetAsUWord = function(index: DWORD; name: PAnsiChar; value: WORD): Integer; stdcall;
TF_CanExSetAsULong = function(index: DWORD; name: PAnsiChar; value: DWORD): Integer; stdcall;
TF_CanExSetAsString = function(index: DWORD; name: PAnsiChar; value: PAnsiChar): Integer; stdcall;
TF_CanExGetAsByte = function(index: DWORD; name: PAnsiChar; value: PShortint): Integer; stdcall;
TF_CanExGetAsWord = function(index: DWORD; name: PAnsiChar; value: Psmallint): Integer; stdcall;
TF_CanExGetAsLong = function(index: DWORD; name: PAnsiChar; value: PInteger): Integer; stdcall;
TF_CanExGetAsUByte = function(index: DWORD; name: PAnsiChar; value: PByte): Integer; stdcall;
TF_CanExGetAsUWord = function(index: DWORD; name: PAnsiChar; value: PWORD): Integer; stdcall;
TF_CanExGetAsULong = function(index: DWORD; name: PAnsiChar; value: PDWORD): Integer; stdcall;
TF_CanExGetAsStringCopy = function(index: DWORD; name: PAnsiChar; dest: PAnsiChar; dest_size: PDWORD): Integer; stdcall;
// **** CAN-FD
TF_CanFdTransmit = function(index: DWORD; msg: PCanFdMsg; count: Integer): Integer; stdcall;
TF_CanFdReceive = function(index: DWORD; msg: PCanFdMsg; count: Integer): Integer; stdcall;
TF_CanExGetInfoListPerform = function(index: DWORD; name: PAnsiChar; flags: Integer): Integer; stdcall;
TF_CanExGetInfoListGet = function(list_idx: DWORD; item: PCanInfoVarDev): Integer; stdcall;
TF_MhsCanGetApiHandle = function(api_handle: PPointer): Integer; stdcall;


TOnCanTimeoutEvent = procedure(Sender: TObject) of Object;
TOnCanPnPEvent = procedure(Sender: TObject) of Object;
TOnCanStatusEvent = procedure(Sender: TObject; index: DWORD; device_status: TDeviceStatus) of Object;
TOnCanRxDEvent = procedure(Sender: TObject; index: DWORD; msg: PCanMsg; count: Integer) of Object;
TOnCanRxDFdEvent = procedure(Sender: TObject; index: DWORD; msg: PCanFdMsg; count: Integer) of Object;
TOnCanRxDFilterEvent = procedure(Sender: TObject) of Object;


TCanEventThread = class;

TCanDevicesListObj = class(TList)
  private
    function Get(Index: Integer): PCanDevicesList;
  public
    destructor Destroy; override;
    function Add(item: PCanDevicesList): Integer;
    property Items[Index: Integer]: PCanDevicesList read Get; default;
  end;

TCanInfoVarObj = class(TList)
  private
    function Get(Index: Integer): PCanInfoVar;
  public
    destructor Destroy; override;
    function Add(item: PCanInfoVar): Integer;
    property Items[Index: Integer]: PCanInfoVar read Get; default;
  end;

TTinyCAN = class(TComponent)
  private
    FCanFifoOvClear: Boolean;
    FCanFifoOvMessages: Boolean;
    FFdMode: Boolean;
    FEventsEnable: Boolean;
    FTreiberName: String;
    FPort: Integer;
    FBaudRate: TSerialBaudRate;
    FCanSpeed: TCANSpeed;
    FCanSpeedBtr: DWord;
    FCanFdSpeed: TCanFdSpeed;
    FCanFdDbtr: DWord;
    FCanClockIndex: Byte;     
    FInterfaceType: TInterfaceType;
    FPnPEnable: boolean;
    FAutoReOpen: boolean;
    FRxDFifoSize: Word;
    FTxDFifoSize: Word;
    FCanRxDBufferSize: Word;
    RxMsgBuffer: PCanMsg;
    RxFdMsgBuffer: PCanFdMsg;
    FMinEventSleepTime: DWORD;
    FNoEventTimeout: DWORD;
    FDeviceSnr: String;
    FDeviceName: String;
    FCfgFile: String;
    FLogFile: String;
    FLogFlags: TLogFlags;
    FInitParameterStr: String;
    FOptionsStr: String;
    FOpenStr: String;
    function GetLogFlags: DWORD;
    function TestApi(name: String): Boolean;
    function RegReadStringEntry(path, entry: String): String;
    function GetApiDriverWithPath(driver_file: String): String;
    procedure SetCanSpeed(speed: TCanSpeed);
    procedure SetCanSpeedBtr(btr: DWord);
    procedure SetCanFdSpeed(speed: TCanFdSpeed);
    procedure SetCanFdDbtr(dbtr: DWord);
    procedure SetCanClockIndex(clock_idx: Byte);
    procedure SyncCanTimeoutEvent;
    procedure SyncCanPnPEvent;
    procedure SyncCanStatusEvent;
    procedure SyncCanRxDEvent;
    procedure SyncCanRxDFilterEvent;    
    procedure CanEventThreadTerminate;
    function ValTypeConvert(t: Byte): TMhsValueType;
    function GetWord(data_ptr: PByte): WORD;
    function GetLong(data_ptr: PByte): DWORD;
    function GetBCD(data: Byte): Byte;
    function InfoVarGetDate(data_ptr: PByte): TCanInfoVarDate;
    function InfoVarGetVersion(data_ptr: PByte): TCanInfoVarVer;
    function CanInfoVarCreate(dev_item: PCanInfoVarDev): PCanInfoVar;
  public
    FEventMasks: TEventMasks;
    TinyCanEvent: Pointer;
    DeviceIndex: DWORD;
    CanEventThread: TCanEventThread;
    FDeviceStatus: TDeviceStatus;
    { Events}
    pmCanTimeoutEvent: TOnCanTimeoutEvent;
    pmCanPnPEvent: TOnCanPnPEvent;
    pmCanStatusEvent: TOnCanStatusEvent;
    pmCanRxDEvent: TOnCanRxDEvent;
    pmCanRxDFdEvent: TOnCanRxDFdEvent;
    pmCanRxDFilterEvent: TOnCanRxDFilterEvent;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure CanDownDriver;
    function CanSetOptions: Integer;
    function CanDeviceOpen: Integer;
    function CanDeviceClose: Integer;
    function CanSetMode(index: DWORD; can_op_mode: TCanMode; can_command: Word): Integer;
    function CanTransmit(index: DWORD; msg: PCanMsg; count: Integer): Integer;
    procedure CanTransmitClear(index: DWORD);
    function CanTransmitGetCount(index: DWORD): DWORD;
    function CanTransmitSet(index: DWORD; cmd: Word; time: DWORD): Integer;
    function CanReceive(index: DWORD; msg: PCanMsg; count: Integer): Integer;
    procedure CanReceiveClear(index: DWORD);
    function CanReceiveGetCount(index: DWORD): DWORD;

    function CanSetSpeed(index: DWORD; speed: TCanSpeed): Integer;
    function CanSetSpeedUser(index: DWORD; btr: DWord): Integer;
    function CanSetFdSpeed(index: DWORD; fd_speed: TCanFdSpeed; dbtr: DWORD): Integer;
    function CanDrvInfo: PAnsiChar;
    function CanDrvHwInfo(index: DWORD): PAnsiChar;
    function CanSetFilter(index: DWORD; msg_filter: TMsgFilter): Integer;

    function CanGetDeviceStatus(index: DWORD; var status: TDeviceStatus): Integer;

    //procedure CanSetEvents(events: TEventMasks);<*>
    function CanEventStatus: DWORD;
    // EX-API
    function CanExGetDeviceCount(flags: Integer): Integer;
    function CanExGetDeviceListPerform(flags: Integer): Integer;
    function CanExGetDeviceListGet(var item: TCanDevicesList): Integer;
    function CanExGetDeviceList(flags: Integer): TCanDevicesListObj;
    function CanExGetDeviceInfoPerform(index: DWORD; var device_info: TCanDeviceInfo): Integer;
    function CanExGetDeviceInfoGet(item: PCanInfoVarDev): Integer;
    function CanExGetDeviceInfo(index: DWORD; var device_info: TCanDeviceInfo): TCanInfoVarObj;
    function CanExCreateDevice(var index: DWORD; options: String): Integer;
    function CanExDestroyDevice(var index: DWORD): Integer;
    function CanExCreateFifo(index: DWORD; size: DWORD; event_obj: Pointer; event: DWORD; channels: DWORD): Integer;
    function CanExBindFifo(fifo_index: DWORD; device_index: DWORD; bind: DWORD): Integer;
    function CanExCreateEvent:Pointer;
    function CanExSetObjEvent(index: DWORD; source: DWORD; event_obj: Pointer; event: DWORD): Integer;
    procedure CanExSetEvent(event_obj: Pointer; event: DWORD);
    procedure CanExSetEventAll(event: DWORD);
    procedure CanExResetEvent(event_obj: Pointer; event: DWORD);
    function CanExWaitForEvent(event_obj: Pointer; timeout: DWORD): DWORD;

    function CanExInitDriver: Integer;
    function CanExSetOptions(index: DWORD; name: String; options: String): Integer;
    function CanExSetAsByte(index: DWORD; name: String; value: shortint): Integer;
    function CanExSetAsWord(index: DWORD; name: String; value: smallint): Integer;
    function CanExSetAsLong(index: DWORD; name: String; value: Integer): Integer;
    function CanExSetAsUByte(index: DWORD; name: String; value: Byte): Integer;
    function CanExSetAsUWord(index: DWORD; name: String; value: WORD): Integer;
    function CanExSetAsULong(index: DWORD; name: String; value: DWORD): Integer;
    function CanExSetAsString(index: DWORD; name: String; value: String): Integer;
    function CanExGetAsByte(index: DWORD; name: String; var value: shortint): Integer;
    function CanExGetAsWord(index: DWORD; name: String; var value: smallint): Integer;
    function CanExGetAsLong(index: DWORD; name: String; var value: Integer): Integer;
    function CanExGetAsUByte(index: DWORD; name: String; var value: Byte): Integer;
    function CanExGetAsUWord(index: DWORD; name: String; var value: WORD): Integer;
    function CanExGetAsULong(index: DWORD; name: String; var value: DWORD): Integer;
    function CanExGetAsString(index: DWORD; name: String; var str: String): Integer;
    // **** CAN-FD
    function CanFdTransmit(index: DWORD; msg: PCanFdMsg; count: Integer): Integer;
    function CanFdReceive(index: DWORD; msg: PCanFdMsg; count: Integer): Integer;
    // **** <*> neu
    function CanExGetInfoListPerform(index: DWORD; name: PAnsiChar; flags: Integer): Integer;
    function CanExGetInfoListGet(list_idx: DWORD; item: PCanInfoVarDev): Integer;
    function CanExGetInfoList(index: DWORD; name: String; flags: Integer): TObjectList;
    function MhsCanGetApiHandle(api_handle: PPointer): Integer;

    function LoadDriver: Integer;
    procedure DownDriver;
  published
    { Published-Deklarationen }
    property CanFifoOvClear: Boolean read FCanFifoOvClear write FCanFifoOvClear default FALSE;
    property CanFifoOvMessages: Boolean read FCanFifoOvMessages write FCanFifoOvMessages default FALSE;
    property FdMode: Boolean read FFdMode write FFdMode default FALSE;
    property TreiberName: String read FTreiberName write FTreiberName;
    property Port: Integer read FPort write FPort default 0;
    property BaudRate: TSerialBaudRate read FBaudRate write FBaudRate default SER_921k6_BAUD;
    property CanSpeed: TCanSpeed read FCanSpeed write SetCanSpeed default CAN_125K_BIT;
    property CanSpeedBtr: DWord read FCanSpeedBtr write SetCanSpeedBtr default 0;
    property CanFdSpeed: TCanFdSpeed read FCanFdSpeed write SetCanFdSpeed default FD_1M_BIT;
    property CanFdDbtr: DWord read FCanFdDbtr write SetCanFdDbtr default 0;
    property CanClockIndex: Byte read FCanClockIndex write SetCanClockIndex default 0;
    property EventMasks: TEventMasks read FEventMasks write FEventMasks default [];
    property EventsEnable: Boolean read FEventsEnable write FEventsEnable default TRUE;
    property InterfaceType: TInterfaceType read FInterfaceType write FInterfaceType default INTERFACE_USB;
    property PnPEnable: boolean read FPnPEnable write FPnPEnable default true;
    property AutoReOpen: boolean read FAutoReOpen write FAutoReOpen default true;
    property RxDFifoSize: Word read FRxDFifoSize write FRxDFifoSize default 4096;
    property TxDFifoSize: Word read FTxDFifoSize write FTxDFifoSize default 255;
    property CanRxDBufferSize: Word read FCanRxDBufferSize write FCanRxDBufferSize default 50;
    property MinEventSleepTime: DWORD read FMinEventSleepTime write FMinEventSleepTime default 0;
    property NoEventTimeout: DWORD read FNoEventTimeout write FNoEventTimeout default 0;

    property DeviceSnr: String read FDeviceSnr write FDeviceSnr;
    property DeviceName: String read FDeviceName write FDeviceName;
    property CfgFile: String read FCfgFile write FCfgFile;
    property LogFile: String read FLogFile write FLogFile;
    property LogFlags: TLogFlags read FLogFlags write FLogFlags default [];
    property InitParameterStr: String read FInitParameterStr write FInitParameterStr;
    property OptionsStr: String read FOptionsStr write FOptionsStr;
    property OpenStr: String read FOpenStr write FOpenStr;
    { Events }
    property OnCanTimeoutEvent: TOnCanTimeoutEvent read pmCanTimeoutEvent write pmCanTimeoutEvent;
    property OnCanPnPEvent: TOnCanPnPEvent read pmCanPnPEvent write pmCanPnPEvent;
    property OnCanStatusEvent: TOnCanStatusEvent read pmCanStatusEvent write pmCanStatusEvent;
    property OnCanRxDEvent: TOnCanRxDEvent read pmCanRxDEvent write pmCanRxDEvent;
    property OnCanRxDFdEvent: TOnCanRxDFdEvent read pmCanRxDFdEvent write pmCanRxDFdEvent;
    property OnCanRxDFilterEvent: TOnCanRxDFilterEvent read pmCanRxDFilterEvent write pmCanRxDFilterEvent;
  end;

TCanEventThread = class(TThread)
  private
    Owner: TTinyCAN;
  protected
    procedure Execute; override;
  public        
    constructor Create(AOwner: TTinyCAN);
    destructor Destroy; override;
  end;

procedure Register;



implementation

var
  DrvDLLWnd: HWnd = 0;
  DrvRefCounter: Integer = 0;

  pmCanInitDriver: TF_CanInitDriver = nil;
  pmCanDownDriver: TF_CanDownDriver = nil;
  pmCanSetOptions: TF_CanSetOptions = nil;
  pmCanDeviceOpen: TF_CanDeviceOpen = nil;
  pmCanDeviceClose: TF_CanDeviceClose = nil;
  pmCanSetMode: TF_CanSetMode = nil;
  pmCanTransmit: TF_CanTransmit = nil;
  pmCanTransmitClear: TF_CanTransmitClear = nil;
  pmCanTransmitGetCount: TF_CanTransmitGetCount = nil;
  pmCanTransmitSet: TF_CanTransmitSet = nil;
  pmCanReceive: TF_CanReceive = nil;
  pmCanReceiveClear: TF_CanReceiveClear = nil;
  pmCanReceiveGetCount: TF_CanReceiveGetCount = nil;
  pmCanSetSpeed: TF_CanSetSpeed = nil;
  pmCanSetSpeedUser: TF_CanSetSpeedUser = nil;
  pmCanDrvInfo: TF_CanDrvInfo = nil;
  pmCanDrvHwInfo: TF_CanDrvHwInfo = nil;
  pmCanSetFilter: TF_CanSetFilter = nil;
  pmCanGetDeviceStatus: TF_CanGetDeviceStatus = nil;
  pmCanSetEvents: TF_CanSetEvents = nil;
  pmCanEventStatus: TF_CanEventStatus = nil;
  // EX-API
  pmCanExGetDeviceCount: TF_CanExGetDeviceCount = nil;
  pmCanExGetDeviceListPerform: TF_CanExGetDeviceListPerform = nil;
  pmCanExGetDeviceListGet: TF_CanExGetDeviceListGet = nil;
  pmCanExGetDeviceInfoPerform: TF_CanExGetDeviceInfoPerform = nil;
  pmCanExGetDeviceInfoGet: TF_CanExGetDeviceInfoGet = nil;
  pmCanExCreateDevice: TF_CanExCreateDevice = nil; 
  pmCanExDestroyDevice: TF_CanExDestroyDevice = nil;
  pmCanExCreateFifo: TF_CanExCreateFifo = nil;
  pmCanExBindFifo: TF_CanExBindFifo = nil;
  pmCanExCreateEvent: TF_CanExCreateEvent = nil;
  pmCanExSetObjEvent: TF_CanExSetObjEvent = nil;
  pmCanExSetEvent: TF_CanExSetEvent = nil;
  pmCanExSetEventAll: TF_CanExSetEventAll = nil;
  pmCanExResetEvent: TF_CanExResetEvent = nil;
  pmCanExWaitForEvent: TF_CanExWaitForEvent = nil;
  pmCanExInitDriver: TF_CanExInitDriver = nil; 
  pmCanExSetOptions: TF_CanExSetOptions = nil; 
  pmCanExSetAsByte: TF_CanExSetAsByte = nil;
  pmCanExSetAsWord: TF_CanExSetAsWord = nil;
  pmCanExSetAsLong: TF_CanExSetAsLong = nil;
  pmCanExSetAsUByte: TF_CanExSetAsUByte = nil; 
  pmCanExSetAsUWord: TF_CanExSetAsUWord = nil;
  pmCanExSetAsULong: TF_CanExSetAsULong = nil; 
  pmCanExSetAsString: TF_CanExSetAsString = nil;
  pmCanExGetAsByte: TF_CanExGetAsByte = nil;
  pmCanExGetAsWord: TF_CanExGetAsWord = nil;
  pmCanExGetAsLong: TF_CanExGetAsLong = nil;
  pmCanExGetAsUByte: TF_CanExGetAsUByte = nil;
  pmCanExGetAsUWord: TF_CanExGetAsUWord = nil;
  pmCanExGetAsULong: TF_CanExGetAsULong = nil; 
  pmCanExGetAsStringCopy: TF_CanExGetAsStringCopy = nil;
  // **** CAN-FD
  pmCanFdTransmit: TF_CanFdTransmit = nil;
  pmCanFdReceive: TF_CanFdReceive = nil;
  pmCanExGetInfoListPerform: TF_CanExGetInfoListPerform = nil;
  pmCanExGetInfoListGet: TF_CanExGetInfoListGet = nil;
  pmMhsCanGetApiHandle: TF_MhsCanGetApiHandle = nil;

{ TCanDevicesListObj }

function TCanDevicesListObj.Add(item: PCanDevicesList): Integer;

begin
Result := inherited Add(item);
end;


destructor TCanDevicesListObj.Destroy;
var i: Integer;

begin
for i := 0 to Count - 1 do
  FreeMem(Items[i]);
inherited;
end;


function TCanDevicesListObj.Get(Index: Integer): PCanDevicesList;

begin
Result := PCanDevicesList(inherited Get(Index));
end;


{ TCanInfoVarObj }

function TCanInfoVarObj.Add(item: PCanInfoVar): Integer;

begin
Result := inherited Add(item);
end;


destructor TCanInfoVarObj.Destroy;
var i: Integer;

begin
for i := 0 to Count - 1 do
  FreeMem(Items[i]);
inherited;
end;


function TCanInfoVarObj.Get(Index: Integer): PCanInfoVar;

begin
Result := PCanInfoVar(inherited Get(Index));
end;


{**************************************************************}
{* Object erzeugen                                            *}
{**************************************************************}
constructor TTinyCAN.Create(AOwner: TComponent);

begin;
inherited Create(AOwner);
FTreiberName := '';
FPort := 0;
FBaudRate := SER_921k6_BAUD;
FCanSpeed := CAN_125K_BIT;
FEventMasks := [];
FInterfaceType := INTERFACE_USB;
FPnPEnable := true;
FAutoReOpen := true;
FEventsEnable := TRUE;
FRxDFifoSize := 4096;
FTxDFifoSize := 255;
FCanRxDBufferSize := 50;
RxMsgBuffer := nil;
RxFdMsgBuffer := nil;
FDeviceSnr:='';
FDeviceName:='';
FCfgFile:='';
FLogFile:='';
FLogFlags:=[];
FInitParameterStr:='';
FOptionsStr:='';
FOpenStr:='';
end;


{**************************************************************}
{* Object löschen                                             *}
{**************************************************************}
destructor TTinyCAN.Destroy;

begin
FEventsEnable := FALSE;
CanDeviceClose;
DownDriver;
inherited Destroy;
end;


{**************************************************************}
{* Hilfsfunktionen                                            *}
{**************************************************************}
function TTinyCAN.ValTypeConvert(t: Byte): TMhsValueType;
var o, i: Byte;

begin;
o := 0;
for i := 0 to 26 do
  begin;
  if MhsValueTypeTab[i] = t then
    begin;
    o := i;
    break;
    end; 
  end;
result := TMhsValueType(o);
end;


function TTinyCAN.GetBCD(data: Byte): Byte;
var h, l: Byte;

begin;
l := (data) and $0F;
h := (data shr 4) and $0F;
result := l + (h * 10);
end;


function TTinyCAN.InfoVarGetDate(data_ptr: PByte): TCanInfoVarDate;

begin;
result.D := DWORD(GetBCD(data_ptr^));
inc(data_ptr);
result.M := DWORD(GetBCD(data_ptr^));
inc(data_ptr);
result.Y := DWORD(GetBCD(data_ptr^));
end;


function TTinyCAN.InfoVarGetVersion(data_ptr: PByte): TCanInfoVarVer;
var value: DWORD;

begin;
value := GetLong(data_ptr);
result.Major := value div 10000;
value := value mod 10000;
result.Minor := value div 100;
result.Revision := value mod 100; 
end;


 
function TTinyCAN.GetWord(data_ptr: PByte): WORD;
var l, h: Byte;

begin;
l := data_ptr^;
inc(data_ptr);
h := data_ptr^;
result := (h shl 8) or l;
end;


function TTinyCAN.GetLong(data_ptr: PByte): DWORD;
var l, m1, m2, h: Byte;

begin;
l := data_ptr^;
inc(data_ptr);
m1 := data_ptr^;
inc(data_ptr);
m2 := data_ptr^;
inc(data_ptr);
h := data_ptr^;
result := (h shl 24) or (m2 shl 16) or (m1 shl 8) or l;
end;


function TTinyCAN.CanInfoVarCreate(dev_item: PCanInfoVarDev): PCanInfoVar;
var i, size: DWORD;
    b: Byte;
    var_type: TMhsValueType;
    item: PCanInfoVar;    
    str: String;
    err: boolean;

begin;    
result := nil;
var_type := ValTypeConvert(dev_item.ValueType);  // Variablen Type
size := DWORD(dev_item.Size);                    // (Max)Größe der Variable in Byte
if var_type in [VT_ANY, VT_BYTE_ARRAY, VT_UBYTE_ARRAY, VT_WORD_ARRAY, VT_UWORD_ARRAY, VT_LONG_ARRAY,
                VT_ULONG_ARRAY, VT_BYTE_RANGE_ARRAY, VT_UBYTE_RANGE_ARRAY, VT_WORD_RANGE_ARRAY,
             VT_UWORD_RANGE_ARRAY, VT_LONG_RANGE_ARRAY, VT_ULONG_RANGE_ARRAY, VT_STREAM, VT_POINTER] then
  exit;
err := FALSE;
case var_type of
  VT_BYTE, VT_UBYTE, VT_HBYTE :
       begin
       if size <> 1 then
         err := TRUE;
       end;
  VT_WORD, VT_UWORD, VT_HWORD :
       begin
       if size <> 2 then
         err := TRUE;
       end;
  VT_LONG, VT_ULONG, VT_HLONG :
       begin
       if size <> 4 then
         err := TRUE;
       end;
   end;
if err then
  exit;
GetMem(item, sizeOf(TCanInfoVar));
item.Key := DWORD(dev_item.Key);                       // Variablen Schlüssel
item.ValueType := var_type;
item.Size := size;
case var_type of
  VT_BYTE :
       begin
       item.Value.I8Value := AnsiChar(dev_item.Data[0]);
       item.ValueStr := ShortString(Format('%d', [item.Value.I8Value]));
       end;
  VT_UBYTE, VT_HBYTE :
       begin
       item.Value.U8Value := Byte(dev_item.Data[0]);
       if var_type = VT_HBYTE then
         item.ValueStr := ShortString(Format('0x%.2X', [item.Value.U8Value]))
       else
         item.ValueStr := ShortString(Format('%u', [item.Value.U8Value]));
       end;
  VT_WORD :
       begin
       item.Value.I16Value := Smallint(GetWord(@dev_item.Data[0]));
       item.ValueStr := ShortString(Format('%d', [item.Value.I16Value]));
       end;
  VT_UWORD, VT_HWORD :
       begin
       item.Value.U16Value := Word(GetWord(@dev_item.Data[0]));
       if var_type = VT_HWORD then
         item.ValueStr := ShortString(Format('0x%.4X', [item.Value.U16Value]))
       else
         item.ValueStr := ShortString(Format('%u', [item.Value.U16Value]));
       end;
  VT_LONG :
       begin
       item.Value.I32Value := Longint(GetLong(@dev_item.Data[0]));
       item.ValueStr := ShortString(Format('%d', [item.Value.I32Value]));
       end;
  VT_ULONG, VT_HLONG :
       begin
       item.Value.U32Value := DWord(GetLong(@dev_item.Data[0]));
       if var_type = VT_HLONG then
         item.ValueStr := ShortString(Format('0x%.8X', [item.Value.U32Value]))
       else
         item.ValueStr := ShortString(Format('%u', [item.Value.U32Value]));
       end;
  VT_STRING :
       begin
       str := '';
       for i:= 0 to size - 1 do
         begin;
         b := dev_item.Data[i];
         if b = 0 then
           break;
         str := str + Char(AnsiChar(b));
         end;
       item.Value.StrValue := ShortString(str);
       item.ValueStr := ShortString(str);
       end;
  VT_REVISION :
       begin
       item.Value.VerValue := InfoVarGetVersion(@dev_item.Data[0]);
       item.ValueStr := ShortString(Format('%u.%u.%u', [item.Value.VerValue.Major, item.Value.VerValue.Minor, item.Value.VerValue.Revision]));
       end;
  VT_DATE :
       begin
       item.Value.DateValue := InfoVarGetDate(@dev_item.Data[0]);
       item.ValueStr := ShortString(Format('%.2u.%.2u.%.4u', [item.Value.DateValue.D, item.Value.DateValue.M, item.Value.DateValue.Y]));
       end;
  end;
result := item;      
end;


{**************************************************************}
{* Treiber DLL suchen                                         *}
{**************************************************************}
function TTinyCAN.TestApi(name: String): Boolean;
var dll_wnd: HWnd;

begin;
result := False;
if length(name) > 0 then
  begin;
  dll_wnd := LoadLibrary(PChar(Name));
  if dll_wnd <> 0 then
    begin;
    if GetProcAddress(dll_wnd, 'CanDrvInfo') <> nil then
      result := True;
    FreeLibrary(dll_wnd);
    end;
  end;    
end;


function TTinyCAN.RegReadStringEntry(path, entry: String): String;
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


function TTinyCAN.GetApiDriverWithPath(driver_file: String): String;
var file_name: String;

begin;
result := '';
if driver_file = '' then
  driver_file := API_DRIVER_DLL
else
  begin;
  if ExtractFileExt(driver_file) = '' then
    driver_file := driver_file + '.dll';
  if ExtractFilePath(driver_file) <> '' then
    begin;
    result := driver_file;
    exit;
    end;
  end;  
file_name := RegReadStringEntry(REG_TINY_CAN_API, REG_TINY_CAN_API_PATH_ENTRY);
if length(file_name) > 0 then
  begin;
  file_name := file_name + '\' + driver_file;
  if TestApi(file_name) then
    result := file_name;
  end;
if length(result) = 0 then
  begin;
  file_name := ExtractFilePath(Application.ExeName) + driver_file;
  if TestApi(file_name) then
    result := file_name;
  end;
end;


{**************************************************************}
{*  Events                                                    *}
{**************************************************************}
procedure TTinyCAN.SyncCanTimeoutEvent;

begin;
if FEventsEnable and Assigned(pmCanTimeoutEvent) then
  pmCanTimeoutEvent(self);
end;


procedure TTinyCAN.SyncCanPnPEvent;

begin;
if FEventsEnable and Assigned(pmCanPnPEvent) then
  pmCanPnPEvent(self);
end;


procedure TTinyCAN.SyncCanStatusEvent;

begin;
if FEventsEnable and Assigned(pmCanStatusEvent) then
  begin;
  CanGetDeviceStatus(DeviceIndex, FDeviceStatus);
  pmCanStatusEvent(self, DeviceIndex, FDeviceStatus);
  end;
end;


procedure TTinyCAN.SyncCanRxDEvent;
var count: Integer;

begin;
if not FEventsEnable then
  exit;
if FFdMode then
  begin;
  if Assigned(pmCanRxDFdEvent) then
    begin;
    if RxFdMsgBuffer <> nil then
      count := CanFdReceive($80000000, RxFdMsgBuffer, FCanRxDBufferSize)
    else
      count := 0;
    pmCanRxDFdEvent(self, DeviceIndex, RxFdMsgBuffer, count);
    end;
  end
else
  begin;
  if Assigned(pmCanRxDEvent) then
    begin;
    if RxMsgBuffer <> nil then
      count := CanReceive($80000000, RxMsgBuffer, FCanRxDBufferSize)
    else
      count := 0;
    pmCanRxDEvent(self, DeviceIndex, RxMsgBuffer, count);
    end;
  end
end;


procedure TTinyCAN.SyncCanRxDFilterEvent;

begin;
if FEventsEnable and Assigned(pmCanRxDFilterEvent) then
  pmCanRxDFilterEvent(self);
end;

{ TCanEventThread }

constructor TCanEventThread.Create(AOwner: TTinyCAN);

begin
inherited Create(True);  // Thread erzeugen nicht starten
{CanEventsLock := TRUE; <*>
InitializeCriticalSection(ThreadLock);}
Owner := AOwner;
Priority := tpHigher;
//CanEventsLock := False;
FreeOnTerminate := false;
Resume;                  // Thread starten
end;


destructor TCanEventThread.Destroy;

begin
if not Terminated then
  begin
  Terminate;
  if Owner <> nil then    
    Owner.CanExSetEvent(Owner.TinyCanEvent, MHS_EVENT_TERMINATE);
  end;  
inherited;
end;

  
procedure TCanEventThread.Execute;
var
  event, timeout: DWORD;

begin
inherited;
while not Terminated do
  begin
  if CAN_TIMEOUT_EVENT in Owner.FEventMasks then
    timeout := Owner.FNoEventTimeout
  else
    timeout := 0;
  event := Owner.CanExWaitForEvent(Owner.TinyCanEvent, timeout);
  if (event and $80000000) > 0 then
    break;
  if event = 0 then
    begin;
    if CAN_TIMEOUT_EVENT in Owner.FEventMasks then
      Synchronize(Owner.SyncCanTimeoutEvent);
    continue;
    end;
  if (event and DELPHI_PNP_EVENT) > 0 then        // Pluy &  Play Event
    begin;
    if PNP_CHANGE_EVENT in Owner.FEventMasks then
      Synchronize(Owner.SyncCanPnPEvent);
    end;
  if (event and DELPHI_STATUS_EVENT) > 0 then      // Event Status änderung  
    begin;
    if STATUS_CHANGE_EVENT in Owner.FEventMasks then
      Synchronize(Owner.SyncCanStatusEvent);
    end;
  if (event and DELPHI_RX_FILTER_EVENT) > 0 then   // CAN Rx Event
    begin
    if RX_FILTER_MESSAGES_EVENT in Owner.FEventMasks then
      Synchronize(Owner.SyncCanRxDFilterEvent);
    end;    
    
  if (event and DELPHI_RX_EVENT) > 0 then          // CAN Rx Event
    begin;
    if RX_MESSAGES_EVENT in Owner.FEventMasks then
      Synchronize(Owner.SyncCanRxDEvent);
    end;
  if Owner.FMinEventSleepTime > 0then
    Sleep(Owner.FMinEventSleepTime);  // x ms Pause
  end;     
end;


procedure TTinyCAN.CanEventThreadTerminate;

begin
if Assigned(CanEventThread) then
  begin
  CanEventThread.Destroy;
  CanEventThread := nil;
  end;
end;


{**************************************************************}
{* Property Set Funktionen                                    *}
{**************************************************************}
procedure TTinyCAN.SetCanSpeed(speed: TCanSpeed);

begin;
FCanSpeed := speed;
if not (csDesigning in ComponentState) then
  CanSetSpeed(DeviceIndex, speed);
end;


procedure TTinyCAN.SetCanSpeedBtr(btr: DWord);

begin;
FCanSpeedBtr := btr;
if not (csDesigning in ComponentState) then
  CanSetSpeedUser(DeviceIndex, btr);
end;


procedure TTinyCAN.SetCanFdSpeed(speed: TCanFdSpeed);

begin;
FCanFdSpeed := speed;
if not (csDesigning in ComponentState) then
  CanSetFdSpeed(DeviceIndex, speed, FCanFdDBtr);
end;


procedure TTinyCAN.SetCanFdDbtr(dbtr: DWord);

begin;
FCanFdDbtr := dbtr;
if not (csDesigning in ComponentState) then
  CanSetFdSpeed(DeviceIndex, FCanFdSpeed, dbtr);
end;


procedure TTinyCAN.SetCanClockIndex(clock_idx: Byte);

begin;
FCanClockIndex := clock_idx;
if not (csDesigning in ComponentState) then
  CanExSetAsUByte(DeviceIndex, 'CanClockIndex', clock_idx);
end;


function TTinyCan.GetLogFlags: DWORD;

begin
result := 0; 
if LOG_MESSAGE in FLogFlags then
  result := result or TCAN_LOG_MESSAGE;
if LOG_STATUS in FLogFlags then  
  result := result or TCAN_LOG_STATUS;
if LOG_RX_MSG in FLogFlags then      
  result := result or TCAN_LOG_RX_MSG;
if LOG_TX_MSG in FLogFlags then
  result := result or TCAN_LOG_TX_MSG;
if LOG_API_CALL in FLogFlags then        
  result := result or TCAN_LOG_API_CALL;
if LOG_ERROR in FLogFlags then
  result := result or TCAN_LOG_ERROR;
if LOG_WARN in FLogFlags then         
  result := result or TCAN_LOG_WARN;
if LOG_WARN in FLogFlags then          
  result := result or TCAN_LOG_ERR_MSG;
if LOG_OV_MSG in FLogFlags then       
  result := result or TCAN_LOG_OV_MSG;
if LOG_DEBUG in FLogFlags then        
  result := result or TCAN_LOG_DEBUG;
if LOG_WITH_TIME in FLogFlags then         
  result := result or TCAN_LOG_WITH_TIME;
if LOG_DISABLE_SYNC in FLogFlags then     
  result := result or TCAN_LOG_DISABLE_SYNC;
end;


{**************************************************************}
{* Treiber Funktionen                                         *}
{**************************************************************}
function TTinyCAN.CanExInitDriver: Integer;
var Str: String;

begin;
result := -1;
RxMsgBuffer := nil;
RxFdMsgBuffer := nil;
Str := Format('CanCallThread=0;CanRxDMode=0;CanRxDFifoSize=0;CanTxDFifoSize=%u', [FTxDFifoSize]);              
if FFdMode then
    Str := Str + ';FdMode=1';
if length(FCfgFile) > 0 then
  Str := Str + ';CfgFile=' + FCfgFile;
if length(FLogFile) > 0 then
  begin;
  Str := Str + ';LogFile=' + FLogFile;
  Str := Str + Format(';LogFlags=%u', [GetLogFlags]);
  end; 
if length(FInitParameterStr) > 0 then
  Str := Str + ';' + FInitParameterStr;
if FCanFifoOvClear then
  begin;
  if FCanFifoOvMessages then
    Str := Str + ';FifoOvMode=0x0101'
  else
    Str := Str + ';FifoOvMode=0x8101'  
  end
else
  Str := Str + ';FifoOvMode=0x0000';
if Assigned(pmCanExInitDriver) then
  result := pmCanExInitDriver(PAnsiChar(AnsiString(Str)));
if result > -1 then
  begin;  
  if FCanRxDBufferSize > 0 then
    begin;
    if FFdMode then
      RxFdMsgBuffer := AllocMem(FCanRxDBufferSize * SizeOf(TCanFdMsg))
    else
      RxMsgBuffer := AllocMem(FCanRxDBufferSize * SizeOf(TCanMsg));
    end;  
  TinyCanEvent := CanExCreateEvent;
  CanExCreateDevice(DeviceIndex, '');
  if FRxDFifoSize > 0 then
    CanExCreateFifo($80000000, FRxDFifoSize, TinyCanEvent, DELPHI_RX_EVENT, $FFFFFFFF);    
  CanExSetObjEvent(DeviceIndex, MHS_EVS_STATUS, TinyCanEvent, DELPHI_STATUS_EVENT);  
  CanExSetObjEvent(INDEX_INVALID, MHS_EVS_PNP, TinyCanEvent, DELPHI_PNP_EVENT);
  CanEventThread := TCanEventThread.Create(self);
  end;    
end;


procedure TTinyCAN.CanDownDriver;
var i, cnt: Integer;
    saved_events: TEventMasks;

begin;
saved_events := FEventMasks;
FEventMasks := [];
if Assigned(pmCanDownDriver) then
  begin;
  if Assigned(pmCanExSetEventAll) then
    pmCanExSetEventAll(MHS_EVENT_TERMINATE);
  CanEventThreadTerminate;  
  for i := 0 to 5 do
    begin;
    cnt := 100;
    while DrvRefCounter > 0 do
      begin;
      Sleep(10);
      Application.ProcessMessages;
      dec(cnt);
      if cnt = 0 then
        break;
      end;
    Sleep(1);
    if DrvRefCounter = 0 then
      break;
    end;  
  DrvRefCounter := 0;
  pmCanDownDriver;
  end;
if RxMsgBuffer <> nil then
  begin;
  FreeMem(RxMsgBuffer);
  RxMsgBuffer := nil;
  end;
if RxFdMsgBuffer <> nil then
  begin;
  FreeMem(RxFdMsgBuffer);
  RxFdMsgBuffer := nil;
  end;  
FEventMasks := saved_events;  
end;


function TTinyCAN.CanSetOptions: Integer;
var Str: String;

begin;
// Treiber Optionen setzen
result := -1;
if FPnPEnable then
  begin;
  if FAutoReOpen then
    Str := 'AutoConnect=1;AutoReopen=1'
  else
    Str := 'AutoConnect=1'
  end
else
  Str := 'AutoConnect=0';
if length(FOptionsStr) > 0 then
  Str := Str + ';' + FOptionsStr;
if (DrvDLLWnd <> 0) and Assigned(pmCanSetOptions) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanSetOptions(PAnsiChar(AnsiString(Str)));
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanDeviceOpen: Integer;
var str: String;
    baud_rate: DWord;

begin;
result := -1;
baud_rate := BaudRateTab[ord(FBaudRate)];
if length(FDeviceName) > 0 then
  str := Format('DeviceName=%s', [FDeviceName])
else  
  begin;
  if FInterfaceType = INTERFACE_USB then
    begin;
    if (length(FDeviceSnr) > 0)  and (baud_rate > 0) then
      str := Format('ComDrvType=1;Snr=%s;BaudRate=%u', [FDeviceSnr, baud_rate])
    else if length(FDeviceSnr) > 0 then
      str := Format('ComDrvType=1;Snr=%s', [FDeviceSnr])
    else if baud_rate > 0 then
      str := Format('ComDrvType=1;BaudRate=%u', [baud_rate])
    else
      str := 'ComDrvType=1';
    end  
  else
    begin;
    if baud_rate > 0 then                     
      str := Format('ComDrvType=0;Port=%u;BaudRate=%u',[FPort, baud_rate])
    else
      str := Format('ComDrvType=0;Port=%u',[FPort]);
    end;
  end;                          
if length(FOpenStr) > 0 then
  str := str + ';' + FOpenStr;
if (DrvDLLWnd <> 0) and Assigned(pmCanDeviceOpen) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanDeviceOpen(DeviceIndex, PAnsiChar(AnsiString(str)));
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanDeviceClose: Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanDeviceClose) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanDeviceClose(0);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanSetMode(index: DWORD; can_op_mode: TCanMode; can_command: Word): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanSetMode) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanSetMode(index, ord(can_op_mode), can_command);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanTransmit(index: DWORD; msg: PCanMsg; count: Integer): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanTransmit) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanTransmit(index, msg, count);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


procedure TTinyCAN.CanTransmitClear(index: DWORD);

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanTransmitClear) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanTransmitClear(index);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanTransmitGetCount(index: DWORD): DWORD;

begin;
result := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanTransmitGetCount) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanTransmitGetCount(index);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanTransmitSet(index: DWORD; cmd: Word; time: DWORD): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanTransmitSet) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanTransmitSet(index, cmd, time);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanReceive(index: DWORD; msg: PCanMsg; count: Integer): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanReceive) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanReceive(index, msg, count);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


procedure TTinyCAN.CanReceiveClear(index: DWORD);

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanReceiveClear) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanReceiveClear(index);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanReceiveGetCount(index: DWORD): DWORD;

begin;
result := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanReceiveGetCount) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanReceiveGetCount(index);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanSetSpeed(index: DWORD; speed: TCanSpeed): Integer;
var speed_value: Word;

begin;
result := -1;
speed_value := CanSpeedTab[ord(speed)];
if (DrvDLLWnd <> 0) and Assigned(pmCanSetSpeed) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanSetSpeed(index, speed_value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanSetSpeedUser(index: DWORD; btr: DWord): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanSetSpeedUser) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanSetSpeedUser(index, btr);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanSetFdSpeed(index: DWORD; fd_speed: TCanFdSpeed; dbtr: DWORD): Integer;
var speed_value: Word;

begin;
result := -1;
speed_value := CanFdSpeedTab[ord(fd_speed)];
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsUWord) and Assigned(pmCanExSetAsULong) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  if speed_value > 0 then
    result := pmCanExSetAsUWord(index, PAnsiChar(AnsiString('CanDSpeed1')), speed_value)
  else
    result := pmCanExSetAsULong(index, PAnsiChar(AnsiString('CanDSpeed1User')), dbtr);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanDrvInfo: PAnsiChar;

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanDrvInfo) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanDrvInfo;
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := nil;
end;


function TTinyCAN.CanDrvHwInfo(index: DWORD): PAnsiChar;

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanDrvHwInfo) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanDrvHwInfo(index);
  InterlockedDecrement(DrvRefCounter);
  end
else
  result := nil;
end;


function TTinyCAN.CanSetFilter(index: DWORD; msg_filter: TMsgFilter): Integer;
var drv_filter: TMsgFilterDrv;
    flags: DWORD;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanSetFilter) then
  begin;
  drv_filter.Maske := msg_filter.Maske_Stop;
  drv_filter.Code := msg_filter.Code_Start_Id;
  if msg_filter.IdMode = CAN_FILTER_START_STOP then
    flags := $00000100
  else if msg_filter.IdMode = CAN_FILTER_SINGLE_ID then
    flags := $00000200
  else
    flags := 0;
  if msg_filter.Enabled then  
    flags := flags or FilFlagsEnable;
  if msg_filter.RTR then
    flags := flags or FlagsCanRTR;
  if msg_filter.EFF then
    flags := flags or FlagsCanEFF;  
  if not msg_filter.PurgeMessage then
    flags := flags or $40000000;   // 0 = Message entfernen      
  drv_filter.Flags := flags;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanSetFilter(index, @drv_filter);
  InterlockedDecrement(DrvRefCounter);
  end;
if result > -1 then  
  CanExSetObjEvent(index, MHS_EVS_OBJECT, TinyCanEvent, DELPHI_RX_FILTER_EVENT);  // <*> neu  
end;


function TTinyCAN.CanGetDeviceStatus(index: DWORD; var status: TDeviceStatus): Integer;
var status_drv: TDeviceStatusDrv;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanGetDeviceStatus) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanGetDeviceStatus(index, @status_drv);
  InterlockedDecrement(DrvRefCounter);
  end;
if result < 0 then
  begin;
  status.DrvStatus := DRV_NOT_LOAD;
  status.CanStatus := CAN_STATUS_UNBEKANNT;
  status.FifoStatus := CAN_FIFO_STATUS_UNBEKANNT;
  status.BusFailure := FALSE;
  end
else
  begin;
  if status_drv.DrvStatus > 8 then
    status.DrvStatus := DRV_STATUS_CAN_RUN
  else
    status.DrvStatus := TDrvStatus(status_drv.DrvStatus);
  if (status_drv.CanStatus and $0F) > 5 then
    status.CanStatus := CAN_STATUS_UNBEKANNT
  else
    status.CanStatus := TCanStatus(status_drv.CanStatus and $0F);
  if status_drv.FifoStatus > 4 then
    status.FifoStatus := CAN_FIFO_STATUS_UNBEKANNT
  else
    status.FifoStatus := TCanFifoStatus(status_drv.FifoStatus);
  end;
if (status_drv.CanStatus and $10) = $10 then
  status.BusFailure := TRUE
else
  status.BusFailure := FALSE;
end;


function TTinyCAN.CanEventStatus: DWORD;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanEventStatus) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanEventStatus;
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExGetDeviceCount(flags: Integer): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetDeviceCount) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetDeviceCount(flags);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExGetDeviceListPerform(flags: Integer): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetDeviceListPerform) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetDeviceListPerform(flags);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExGetDeviceListGet(var item: TCanDevicesList): Integer;
var dev_item: TCanDevicesListDev;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetDeviceListGet) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetDeviceListGet(@dev_item);
  item.TCanIdx := dev_item.TCanIdx;
  item.HwId := dev_item.HwId;
  item.DeviceName := ShortString(dev_item.DeviceName);
  item.SerialNumber := ShortString(dev_item.SerialNumber);
  item.Description := ShortString(dev_item.Description);
  item.ModulFeatures := dev_item.ModulFeatures;
  InterlockedDecrement(DrvRefCounter);  
  end;
end;


function TTinyCAN.CanExGetDeviceList(flags: Integer): TCanDevicesListObj;
var count, i: Integer;
    item: PCanDevicesList;
    dev_item: TCanDevicesListDev;

begin;
if (DrvDLLWnd = 0) or not Assigned(pmCanExGetDeviceListGet) then
  begin;
  result := nil;
  exit;
  end;
count := CanExGetDeviceListPerform(flags);
if count > 0 then
  begin;
  result := TCanDevicesListObj.Create;
  InterlockedIncrement(DrvRefCounter);
  for i := 1 to count do
    begin;
    if pmCanExGetDeviceListGet(@dev_item) < 0 then
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
  

function TTinyCAN.CanExGetDeviceInfoPerform(index: DWORD; var device_info: TCanDeviceInfo): Integer;
var dev_info: TCanDeviceInfo;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetDeviceInfoPerform) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetDeviceInfoPerform(index, @dev_info);
  InterlockedDecrement(DrvRefCounter);
  device_info.HwId := dev_info.HwId; 
  device_info.FirmwareVersion := dev_info.FirmwareVersion; 
  device_info.FirmwareInfo := dev_info.FirmwareInfo;                                           
  device_info.SerialNumber := ShortString(dev_info.SerialNumber);
  device_info.Description := ShortString(dev_info.Description);
  device_info.ModulFeatures := dev_info.ModulFeatures; 
  end;
end;


function TTinyCAN.CanExGetDeviceInfoGet(item: PCanInfoVarDev): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetDeviceInfoGet) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetDeviceInfoGet(item);
  InterlockedDecrement(DrvRefCounter);
  end;
end;
    

function TTinyCAN.CanExGetDeviceInfo(index: DWORD; var device_info: TCanDeviceInfo): TCanInfoVarObj;
var dev_item: TCanInfoVarDev;
    item: PCanInfoVar;

begin;
if CanExGetDeviceInfoPerform(index, device_info) < 0 then
  result := nil
else
  begin;
  result := TCanInfoVarObj.Create;
  while CanExGetDeviceInfoGet(@dev_item) > 0 do
    begin;
    item := CanInfoVarCreate(@dev_item);
    if item = nil then
      continue;
    result.Add(item);
    end;
  end
end;


function TTinyCAN.CanExCreateDevice(var index: DWORD; options: String): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExCreateDevice) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExCreateDevice(@index, PAnsiChar(AnsiString(options)));
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExDestroyDevice(var index: DWORD): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExDestroyDevice) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExDestroyDevice(@index);
  InterlockedDecrement(DrvRefCounter);
  end;
end;
                 

function TTinyCAN.CanExCreateFifo(index: DWORD; size: DWORD; event_obj: Pointer; event: DWORD; channels: DWORD): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExCreateFifo) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExCreateFifo(index, size, event_obj, event, channels);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExBindFifo(fifo_index: DWORD; device_index: DWORD; bind: DWORD): Integer;

begin;
result := 1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExBindFifo) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExBindFifo(fifo_index, device_index, bind);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExCreateEvent: Pointer;

begin;
result := nil;
if (DrvDLLWnd <> 0) and Assigned(pmCanExCreateEvent) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExCreateEvent;
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExSetObjEvent(index: DWORD; source: DWORD; event_obj: Pointer; event: DWORD): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetObjEvent) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetObjEvent(index, source, event_obj, event);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


procedure TTinyCAN.CanExSetEvent(event_obj: Pointer; event: DWORD);

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetEvent) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanExSetEvent(event_obj, event);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


procedure TTinyCAN.CanExSetEventAll(event: DWORD);

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetEventAll) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanExSetEventAll(event);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

 
procedure TTinyCAN.CanExResetEvent(event_obj: Pointer; event: DWORD);

begin;
if (DrvDLLWnd <> 0) and Assigned(pmCanExResetEvent) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  pmCanExResetEvent(event_obj, event);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExWaitForEvent(event_obj: Pointer; timeout: DWORD): DWORD;

begin;
result := $FFFFFFFF;  // <*> ?
if (DrvDLLWnd <> 0) and Assigned(pmCanExWaitForEvent) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExWaitForEvent(event_obj, timeout);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

                             
function TTinyCAN.CanExSetOptions(index: DWORD; name: String; options: String): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetOptions) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetOptions(index, PAnsiChar(AnsiString(name)), PAnsiChar(AnsiString(options)));
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExSetAsByte(index: DWORD; name: String; value: Shortint): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsByte) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsByte(index, PAnsiChar(AnsiString(name)), value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

    
function TTinyCAN.CanExSetAsWord(index: DWORD; name: String; value: smallint): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsWord) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsWord(index, PAnsiChar(AnsiString(name)), value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

    
function TTinyCAN.CanExSetAsLong(index: DWORD; name: String; value: Integer): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsLong) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsLong(index, PAnsiChar(AnsiString(name)), value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

     
function TTinyCAN.CanExSetAsUByte(index: DWORD; name: String; value: Byte): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsUByte) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsUByte(index, PAnsiChar(AnsiString(name)), value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

       
function TTinyCAN.CanExSetAsUWord(index: DWORD; name: String; value: WORD): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsUWord) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsUWord(index, PAnsiChar(AnsiString(name)), value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

       
function TTinyCAN.CanExSetAsULong(index: DWORD; name: String; value: DWORD): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsULong) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsULong(index, PAnsiChar(AnsiString(name)), value);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExSetAsString(index: DWORD; name: String; value: String): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanExSetAsString) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExSetAsString(index, PAnsiChar(AnsiString(name)), PAnsiChar(AnsiString(value)));
  InterlockedDecrement(DrvRefCounter);
  end;
end;

 
function TTinyCAN.CanExGetAsByte(index: DWORD; name: String; var value: shortint): Integer;
var read_value: shortint;

begin;
result := -1;
read_value := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsByte) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsByte(index, PAnsiChar(AnsiString(name)), @read_value);
  InterlockedDecrement(DrvRefCounter);
  end;
value := read_value;
end;


function TTinyCAN.CanExGetAsWord(index: DWORD; name: String; var value: smallint): Integer;
var read_value: smallint;

begin;
result := -1;
read_value := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsWord) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsWord(index, PAnsiChar(AnsiString(name)), @read_value);
  InterlockedDecrement(DrvRefCounter);
  end;
value := read_value;
end;

   
function TTinyCAN.CanExGetAsLong(index: DWORD; name: String; var value: Integer): Integer; 
var read_value: Integer;

begin;
result := -1;
read_value := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsLong) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsLong(index, PAnsiChar(AnsiString(name)), @read_value);
  InterlockedDecrement(DrvRefCounter);
  end;
value := read_value;  
end;


function TTinyCAN.CanExGetAsUByte(index: DWORD; name: String; var value: Byte): Integer;
var read_value: Byte;

begin;
result := -1;
read_value := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsUByte) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsUByte(index, PAnsiChar(AnsiString(name)), @read_value);
  InterlockedDecrement(DrvRefCounter);
  end;
value := read_value;
end;


function TTinyCAN.CanExGetAsUWord(index: DWORD; name: String; var value: WORD): Integer;
var read_value: WORD;

begin;
result := -1;
read_value := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsUWord) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsUWord(index, PAnsiChar(AnsiString(name)), @read_value);
  InterlockedDecrement(DrvRefCounter);
  end;
value := read_value;
end;

      
function TTinyCAN.CanExGetAsULong(index: DWORD; name: String; var value: DWORD): Integer;
var read_value: DWORD;

begin;
result := -1;
read_value := 0;
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsULong) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsULong(index, PAnsiChar(AnsiString(name)), @read_value);
  InterlockedDecrement(DrvRefCounter);
  end;
value := read_value;
end;

    
function TTinyCAN.CanExGetAsString(index: DWORD; name: String; var str: String): Integer;

begin;
result := -1;
{result := -1;    <*>
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetAsString) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetAsString(PAnsiChar(AnsiString(name)), );
  InterlockedDecrement(DrvRefCounter);
  end;
  }
end;


// **** CAN-FD
function TTinyCAN.CanFdTransmit(index: DWORD; msg: PCanFdMsg; count: Integer): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanFdTransmit) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanFdTransmit(index, msg, count);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanFdReceive(index: DWORD; msg: PCanFdMsg; count: Integer): Integer;

begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmCanFdReceive) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanFdReceive(index, msg, count);
  InterlockedDecrement(DrvRefCounter);
  end;
end;

// ********* <*> neu
function TTinyCAN.CanExGetInfoListPerform(index: DWORD; name: PAnsiChar; flags: Integer): Integer;

begin;
result := -1; // <*>
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetInfoListPerform) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetInfoListPerform(index, name, flags);
  InterlockedDecrement(DrvRefCounter);
  end;
end;  
  

function TTinyCAN.CanExGetInfoListGet(list_idx: DWORD; item: PCanInfoVarDev): Integer;

begin;
result := -1; // <*>
if (DrvDLLWnd <> 0) and Assigned(pmCanExGetInfoListGet) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmCanExGetInfoListGet(list_idx, item);
  InterlockedDecrement(DrvRefCounter);
  end;
end;


function TTinyCAN.CanExGetInfoList(index: DWORD; name: String; flags: Integer): TObjectList;
var dev_item: TCanInfoVarDev;
    item: PCanInfoVar;
    info_list: TCanInfoVarObj;
    res: Integer;
    idx: DWORD;

begin;
res := CanExGetInfoListPerform(index, PAnsiChar(AnsiString(name)), flags);
if res < 1 then
  result := nil
else
  begin;
  result := TObjectList.Create;
  for idx := 0 to res-1 do
    begin;
    info_list := TCanInfoVarObj.Create;
    while CanExGetInfoListGet(idx, @dev_item) > 0 do
      begin;
      item := CanInfoVarCreate(@dev_item);
      if item = nil then
        continue;
      info_list.Add(item);  
      end;  
    result.Add(TObject(info_list));
    end;
  end
end;


function TTinyCAN.MhsCanGetApiHandle(api_handle: PPointer): Integer;
begin;
result := -1;
if (DrvDLLWnd <> 0) and Assigned(pmMhsCanGetApiHandle) then
  begin;
  InterlockedIncrement(DrvRefCounter);
  result := pmMhsCanGetApiHandle(api_handle);
  InterlockedDecrement(DrvRefCounter);
  end;
end;  

{**************************************************************}
{* DLL Treiber laden                                          *}
{**************************************************************}
function TTinyCAN.LoadDriver: Integer;

begin;
result := 0;
try
  DownDriver;
  {Hardware Treiber laden}
  DRVDLLWnd:=LoadLibrary(PChar(GetApiDriverWithPath(FTreiberName)));
  if DRVDLLWnd=0 then raise EDllLoadError.create('');
  pmCanInitDriver := GetProcAddress(DrvDLLWnd, 'CanInitDriver');
  pmCanDownDriver := GetProcAddress(DrvDLLWnd, 'CanDownDriver');
  pmCanSetOptions := GetProcAddress(DrvDLLWnd, 'CanSetOptions');
  pmCanDeviceOpen := GetProcAddress(DrvDLLWnd, 'CanDeviceOpen');
  pmCanDeviceClose := GetProcAddress(DrvDLLWnd, 'CanDeviceClose');
  pmCanSetMode := GetProcAddress(DrvDLLWnd, 'CanSetMode');
  pmCanTransmit := GetProcAddress(DrvDLLWnd, 'CanTransmit');
  pmCanTransmitClear := GetProcAddress(DrvDLLWnd, 'CanTransmitClear');
  pmCanTransmitGetCount := GetProcAddress(DrvDLLWnd, 'CanTransmitGetCount');
  pmCanTransmitSet := GetProcAddress(DrvDLLWnd, 'CanTransmitSet');
  pmCanReceive := GetProcAddress(DrvDLLWnd, 'CanReceive');
  pmCanReceiveClear := GetProcAddress(DrvDLLWnd, 'CanReceiveClear');
  pmCanReceiveGetCount := GetProcAddress(DrvDLLWnd, 'CanReceiveGetCount');
  pmCanSetSpeed := GetProcAddress(DrvDLLWnd, 'CanSetSpeed');
  pmCanSetSpeedUser := GetProcAddress(DrvDLLWnd, 'CanSetSpeedUser');
  pmCanDrvInfo := GetProcAddress(DrvDLLWnd, 'CanDrvInfo');
  pmCanDrvHwInfo := GetProcAddress(DrvDLLWnd, 'CanDrvHwInfo');
  pmCanSetFilter := GetProcAddress(DrvDLLWnd, 'CanSetFilter');
  pmCanGetDeviceStatus := GetProcAddress(DrvDLLWnd, 'CanGetDeviceStatus');
  pmCanSetEvents := GetProcAddress(DrvDLLWnd, 'CanSetEvents');
  pmCanEventStatus := GetProcAddress(DrvDLLWnd, 'CanEventStatus');
  // EX-API
  pmCanExGetDeviceCount := GetProcAddress(DrvDLLWnd, 'CanExGetDeviceCount');
  pmCanExGetDeviceListPerform := GetProcAddress(DrvDLLWnd, 'CanExGetDeviceListPerform');
  pmCanExGetDeviceListGet := GetProcAddress(DrvDLLWnd, 'CanExGetDeviceListGet');
  pmCanExGetDeviceInfoPerform := GetProcAddress(DrvDLLWnd, 'CanExGetDeviceInfoPerform');
  pmCanExGetDeviceInfoGet := GetProcAddress(DrvDLLWnd, 'CanExGetDeviceInfoGet');
  pmCanExCreateDevice := GetProcAddress(DrvDLLWnd, 'CanExCreateDevice'); 
  pmCanExDestroyDevice := GetProcAddress(DrvDLLWnd, 'CanExDestroyDevice');
  pmCanExCreateFifo := GetProcAddress(DrvDLLWnd, 'CanExCreateFifo'); 
  pmCanExBindFifo := GetProcAddress(DrvDLLWnd, 'CanExBindFifo');
  pmCanExCreateEvent := GetProcAddress(DrvDLLWnd, 'CanExCreateEvent');
  pmCanExSetObjEvent := GetProcAddress(DrvDLLWnd, 'CanExSetObjEvent');
  pmCanExSetEvent := GetProcAddress(DrvDLLWnd, 'CanExSetEvent');
  pmCanExSetEventAll := GetProcAddress(DrvDLLWnd, 'CanExSetEventAll');
  pmCanExResetEvent := GetProcAddress(DrvDLLWnd, 'CanExResetEvent');
  pmCanExWaitForEvent := GetProcAddress(DrvDLLWnd, 'CanExWaitForEvent');
  
  pmCanExInitDriver := GetProcAddress(DrvDLLWnd, 'CanExInitDriver'); 
  pmCanExSetOptions := GetProcAddress(DrvDLLWnd, 'CanExSetOptions'); 
  pmCanExSetAsByte := GetProcAddress(DrvDLLWnd, 'CanExSetAsByte');  
  pmCanExSetAsWord := GetProcAddress(DrvDLLWnd, 'CanExSetAsWord');  
  pmCanExSetAsLong := GetProcAddress(DrvDLLWnd, 'CanExSetAsLong');  
  pmCanExSetAsUByte := GetProcAddress(DrvDLLWnd, 'CanExSetAsUByte'); 
  pmCanExSetAsUWord := GetProcAddress(DrvDLLWnd, 'CanExSetAsUWord'); 
  pmCanExSetAsULong := GetProcAddress(DrvDLLWnd, 'CanExSetAsULong');
  pmCanExSetAsString := GetProcAddress(DrvDLLWnd, 'CanExSetAsString');
  pmCanExGetAsByte := GetProcAddress(DrvDLLWnd, 'CanExGetAsByte');  
  pmCanExGetAsWord := GetProcAddress(DrvDLLWnd, 'CanExGetAsWord');
  pmCanExGetAsLong := GetProcAddress(DrvDLLWnd, 'CanExGetAsLong');  
  pmCanExGetAsUByte := GetProcAddress(DrvDLLWnd, 'CanExGetAsUByte'); 
  pmCanExGetAsUWord := GetProcAddress(DrvDLLWnd, 'CanExGetAsUWord'); 
  pmCanExGetAsULong := GetProcAddress(DrvDLLWnd, 'CanExGetAsULong');
  pmCanExGetAsStringCopy := GetProcAddress(DrvDLLWnd, 'CanExGetAsStringCopy');
  // **** CAN-FD
  pmCanFdTransmit := GetProcAddress(DrvDLLWnd, 'CanFdTransmit');
  pmCanFdReceive := GetProcAddress(DrvDLLWnd, 'CanFdReceive');
  pmCanExGetInfoListPerform := GetProcAddress(DrvDLLWnd, 'CanExGetInfoListPerform');
  pmCanExGetInfoListGet := GetProcAddress(DrvDLLWnd, 'CanExGetInfoListGet');
  pmMhsCanGetApiHandle := GetProcAddress(DrvDLLWnd, 'MhsCanGetApiHandle');

  if @pmCanInitDriver = nil then raise EDllLoadError.create('');
  if @pmCanDownDriver = nil then raise EDllLoadError.create('');
  if @pmCanSetOptions = nil then raise EDllLoadError.create('');
  if @pmCanDeviceOpen = nil then raise EDllLoadError.create('');
  if @pmCanDeviceClose = nil then raise EDllLoadError.create('');
  if @pmCanSetMode = nil then raise EDllLoadError.create('');
  if @pmCanTransmit = nil then raise EDllLoadError.create('');
  if @pmCanTransmitClear = nil then raise EDllLoadError.create('');
  if @pmCanTransmitGetCount = nil then raise EDllLoadError.create('');
  if @pmCanTransmitSet = nil then raise EDllLoadError.create('');
  if @pmCanReceive = nil then raise EDllLoadError.create('');
  if @pmCanReceiveClear = nil then raise EDllLoadError.create('');
  if @pmCanReceiveGetCount = nil then raise EDllLoadError.create('');
  if @pmCanSetSpeed = nil then raise EDllLoadError.create('');
  if @pmCanSetSpeedUser = nil then raise EDllLoadError.create('');
  if @pmCanDrvInfo = nil then raise EDllLoadError.create('');
  if @pmCanDrvHwInfo = nil then raise EDllLoadError.create('');
  if @pmCanSetFilter = nil then raise EDllLoadError.create('');
  if @pmCanGetDeviceStatus = nil then raise EDllLoadError.create('');
  if @pmCanSetEvents = nil then raise EDllLoadError.create('');
  if @pmCanEventStatus = nil then raise EDllLoadError.create('');
  // EX-API
  if @pmCanExGetDeviceCount = nil then raise EDllLoadError.create('');
  if @pmCanExGetDeviceListPerform = nil then raise EDllLoadError.create('');
  if @pmCanExGetDeviceListGet = nil then raise EDllLoadError.create('');
  if @pmCanExGetDeviceInfoPerform = nil then raise EDllLoadError.create('');
  if @pmCanExGetDeviceInfoGet = nil then raise EDllLoadError.create('');
  if @pmCanExCreateDevice = nil then raise EDllLoadError.create(''); 
  if @pmCanExDestroyDevice = nil then raise EDllLoadError.create('');
  if @pmCanExCreateFifo = nil then raise EDllLoadError.create(''); 
  if @pmCanExBindFifo = nil then raise EDllLoadError.create('');
  if @pmCanExCreateEvent = nil then raise EDllLoadError.create('');
  if @pmCanExSetObjEvent = nil then raise EDllLoadError.create('');
  if @pmCanExSetEvent = nil then raise EDllLoadError.create('');
  if @pmCanExSetEventAll = nil then raise EDllLoadError.create('');
  if @pmCanExResetEvent = nil then raise EDllLoadError.create('');
  if @pmCanExWaitForEvent = nil then raise EDllLoadError.create('');
  
  if @pmCanExInitDriver = nil then raise EDllLoadError.create(''); 
  if @pmCanExSetOptions = nil then raise EDllLoadError.create(''); 
  if @pmCanExSetAsByte = nil then raise EDllLoadError.create('');  
  if @pmCanExSetAsWord = nil then raise EDllLoadError.create('');  
  if @pmCanExSetAsLong = nil then raise EDllLoadError.create('');
  if @pmCanExSetAsUByte = nil then raise EDllLoadError.create(''); 
  if @pmCanExSetAsUWord = nil then raise EDllLoadError.create('');
  if @pmCanExSetAsULong = nil then raise EDllLoadError.create(''); 
  if @pmCanExSetAsString = nil then raise EDllLoadError.create('');
  if @pmCanExGetAsByte = nil then raise EDllLoadError.create('');  
  if @pmCanExGetAsWord = nil then raise EDllLoadError.create('');  
  if @pmCanExGetAsLong = nil then raise EDllLoadError.create('');  
  if @pmCanExGetAsUByte = nil then raise EDllLoadError.create(''); 
  if @pmCanExGetAsUWord = nil then raise EDllLoadError.create(''); 
  if @pmCanExGetAsULong = nil then raise EDllLoadError.create('');
  if @pmCanExGetAsStringCopy = nil then raise EDllLoadError.create('');
  // **** CAN-FD
  if @pmCanFdTransmit = nil then raise EDllLoadError.create('');
  if @pmCanFdReceive = nil then raise EDllLoadError.create('');
  if @pmCanExGetInfoListPerform = nil then EDllLoadError.create('');
  if @pmCanExGetInfoListGet = nil then raise EDllLoadError.create('');
  // if @pmMhsCanGetApiHandle = nil then raise EDllLoadError.create('');
  // Treiber Initialisieren
  if CanExInitDriver <> 0 then raise EDllLoadError.create('');
  CanSetSpeed(DeviceIndex, FCanSpeed);
  // <*> CAN-FD / BTR setup ?
  // Treiber Optionen setzen
  CanSetOptions;
except
  DownDriver;
  result := -1;
  end;
end;


procedure TTinyCAN.DownDriver;
var dll_wnd: HWnd;

begin;
dll_wnd := DrvDLLWnd;
DrvDLLWnd := 0;
if dll_wnd <> 0 then
  CanDownDriver;
pmCanInitDriver := nil;
pmCanDownDriver := nil;
pmCanSetOptions := nil;
pmCanDeviceOpen := nil;
pmCanDeviceClose := nil;
pmCanSetMode := nil;
pmCanTransmit := nil;
pmCanTransmitClear := nil;
pmCanTransmitGetCount := nil;
pmCanTransmitSet := nil;
pmCanReceive := nil;
pmCanReceiveClear := nil;
pmCanReceiveGetCount := nil;
pmCanSetSpeed := nil;
pmCanSetSpeedUser := nil;
pmCanDrvInfo := nil;
pmCanDrvHwInfo := nil;
pmCanSetFilter := nil;
pmCanGetDeviceStatus := nil;
pmCanSetEvents := nil;
pmCanEventStatus := nil;
// EX-API
pmCanExGetDeviceCount := nil;
pmCanExGetDeviceListPerform := nil;
pmCanExGetDeviceListGet := nil;
pmCanExGetDeviceInfoPerform := nil;
pmCanExGetDeviceInfoGet := nil;

pmCanExCreateDevice := nil; 
pmCanExDestroyDevice := nil;
pmCanExCreateFifo := nil;
pmCanExBindFifo := nil;
pmCanExCreateEvent := nil;
pmCanExSetObjEvent := nil;
pmCanExSetEvent := nil;
pmCanExSetEventAll := nil;
pmCanExResetEvent := nil;
pmCanExWaitForEvent := nil;

pmCanExInitDriver := nil; 
pmCanExSetOptions := nil;
pmCanExSetAsByte := nil;
pmCanExSetAsWord := nil;
pmCanExSetAsLong := nil;
pmCanExSetAsUByte := nil; 
pmCanExSetAsUWord := nil; 
pmCanExSetAsULong := nil; 
pmCanExSetAsString := nil;
pmCanExGetAsByte := nil;
pmCanExGetAsWord := nil;
pmCanExGetAsLong := nil;
pmCanExGetAsUByte := nil; 
pmCanExGetAsUWord := nil;
pmCanExGetAsULong := nil; 
pmCanExGetAsStringCopy := nil;
// **** CAN-FD
pmCanFdTransmit := nil;
pmCanFdReceive := nil;
pmCanExGetInfoListPerform := nil;
pmCanExGetInfoListGet := nil;
pmMhsCanGetApiHandle := nil;

if dll_wnd <> 0 then
  FreeLibrary(dll_wnd);      
end;


procedure Register;
begin
  RegisterComponents('MHS', [TTinyCAN]);
end;

end.





