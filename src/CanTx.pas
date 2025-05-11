{***************************************************************************
                         CanTx.pas  -  description
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
unit CanTx;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}

uses
  Windows, SysUtils, Classes, StrUtils, Menus, mmsystem, ExtCtrls,
  util, TinyCanDrv;

const
  MaxTxCanListSize = 10000000;

type
  TTxCanMsg = record
    CanMsg: TCanFdMsg;
    //Lock: Boolean; <*>
    TxMode: Integer;
    TriggerId : longword;
    Intervall: longword;
    Timer: longword;
    Comment : String[100];
    end;

  PTxCanMsg = ^TTxCanMsg;

  TTxCanMsgList = array[0..MaxTxCanListSize] of TTxCanMsg;
  PTxCanMsgList = ^TTxCanMsgList;

  TTxCanList = class(TComponent)
  private
    FCount: Integer;
    Lock: boolean;
    FCanMsgs: PTxCanMsgList;
    FIntTimer: TTimer;
    GlobalIntervallEnable: boolean;
    LastSleepTime: Cardinal;
  protected
    procedure OnIntTimer(Sender : TObject);
    function GetCanMsg(index: Integer): PTxCanMsg;
  public
    FdMode: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure EmptyMessage(can_msg: PTxCanMsg);
    procedure Transmit(index: integer);
    procedure RxMessage(rx_msg: PCanFdMsg);
    function Add(can_msg: PTxCanMsg): Integer;
    procedure Delete(index: Integer);
    procedure Clear;
    function GetIndexById(id : longword): Integer;
    property Items[index: Integer]: PTxCanMsg read GetCanMsg; default;
    function SaveToFile(filename: String): Integer;
    function LoadFromFile(filename: String): Integer;
    procedure ResetIntervallTimers;
    procedure SetIntervallMode(enable: boolean);
  published
    property Count: Integer read FCount;
  end;

implementation

uses MainForm;

constructor TTxCanList.Create;

begin
inherited Create(AOwner);
FCount := 0;
Lock := FALSE;
FCanMsgs := nil;
FdMode := FALSE;
FIntTimer := TTimer.Create(self);
FIntTimer.Enabled := False;
FIntTimer.OnTimer := OnIntTimer;
end;


destructor TTxCanList.Destroy;

begin
FreeMem(FCanMsgs);
FIntTimer.Destroy;
inherited Destroy;
end;


procedure TTxCanList.EmptyMessage(can_msg: PTxCanMsg);
var i: Integer;

begin;
can_msg^.CanMsg.Flags := 0;
can_msg^.CanMsg.ID := 0;
can_msg^.CanMsg.Source := 0;
can_msg^.CanMsg.Length := 0;
can_msg^.CanMsg.Time.Sec := 0;
can_msg^.CanMsg.Time.USec := 0;
for i := 0 to 63 do
  can_msg^.CanMsg.Data.Bytes[i] := 0;
can_msg^.TxMode := 0;  // 0 = Off, 1 = Periodic, 2 = RTR, 3 = Trigger
can_msg^.Intervall := 0;
can_msg^.TriggerId := 0;
can_msg^.Comment := '';
end;


procedure TTxCanList.OnIntTimer(Sender : TObject);
var can_msg :PTxCanMsg;
    i: Integer;
    sleep_time, timer: DWord;

begin;
if FCount = 0 then
  exit;
sleep_time := 100;
for i := 0 to FCount-1 do
  begin;
  can_msg := @FCanMsgs[i];
  if (can_msg.TxMode = 1) and (can_msg^.Intervall > 0) then  // Intervall Timer aktiv
    begin;
    if can_msg^.Timer <= LastSleepTime then
      begin;  // Timer ist abgelaufen
      timer := can_msg^.Intervall;
      // CAN Nachricht senden
      MainWin.TinyCAN.CanFdTransmit(MainWin.TinyCAN.DeviceIndex, @can_msg^.CanMsg, 1);
      end
    else
      timer := can_msg^.Timer - LastSleepTime;
    if timer < sleep_time then
      sleep_time := timer;
    can_msg^.Timer := timer;        
    end;
  end;
LastSleepTime := sleep_time;
FIntTimer.Interval := sleep_time;
end;


procedure TTxCanList.RxMessage(rx_msg: PCanFdMsg);
var can_msg :PTxCanMsg;
    i : Integer;
    tx : Boolean;

begin;
if (FCount = 0) or Lock then
  exit;
for i := 0 to FCount-1 do
  begin;
  can_msg := @FCanMsgs[i];
  tx := False;
  if can_msg.TxMode = 2 then      // RTR
    begin;
    if ((rx_msg.Flags and FlagCanFdRTR) > 0) and (can_msg^.CanMsg.ID = rx_msg.ID) then
      tx := True;
    end
  else if can_msg.TxMode = 3 then // Trigger ID
    begin;
    if rx_msg.ID = can_msg^.TriggerId then
      tx := True;
    end;
  if tx then
    begin;
    can_msg^.Timer := can_msg^.Intervall;   // Interval Timer rücksetzen
    // CAN Nachricht senden
    MainWin.TinyCAN.CanFdTransmit(MainWin.TinyCAN.DeviceIndex, @can_msg^.CanMsg, 1);    
    end;
  end;
end;


function TTxCanList.GetIndexById(id : longword): Integer;
var can_msg :PTxCanMsg;
    i : Integer;    

begin;
result := -1;
if FCount = 0 then
  exit;
for i := 0 to FCount - 1 do
  begin;
  can_msg := @FCanMsgs[i];
  if can_msg^.CanMsg.ID = id then
    begin;
    result := i;
    exit;
    end;
  end;
end;

  
procedure TTxCanList.Transmit(index: integer);
var can_msg: PTxCanMsg;

begin
can_msg := GetCanMsg(index);
if can_msg = nil then
  exit;
can_msg^.Timer := can_msg^.Intervall;   // Interval Timer zurücksetzen
// CAN Nachricht senden
MainWin.TinyCAN.CanFdTransmit(MainWin.TinyCAN.DeviceIndex, @can_msg^.CanMsg, 1);
end;


function TTxCanList.GetCanMsg(index: Integer): PTxCanMsg;

begin
If (index < FCount) and (index >= 0) then
  Result := @FCanMsgs[index]
else
  Result := nil;
end;


function TTxCanList.Add(can_msg: PTxCanMsg): Integer;

begin
RxCanEnterCritical;
result := FCount;
ReallocMem (FCanMsgs, (FCount+1) * SizeOf(TTxCanMsg));
Move(can_msg^, FCanMsgs[FCount], SizeOf(TTxCanMsg));
Inc(FCount);
RxCanLeaveCritical;  
end;


procedure TTxCanList.Delete(index: Integer);

begin
If (index < 0) OR (index >= FCount) then
  exit;  
RxCanEnterCritical;  
If index < FCount-1 then
  Move(FCanMsgs[index+1], FCanMsgs[index], (FCount - index-1) * SizeOf(TTxCanMsg));
Dec(FCount);
If FCount = 0 then
  begin
  FreeMem(FCanMsgs);
  FCanMsgs := nil;
  end
else    
  ReallocMem(FCanMsgs, FCount*SizeOf(TTxCanMsg));
RxCanLeaveCritical;  
end;


procedure TTxCanList.Clear;

begin
RxCanEnterCritical;
FCount:=0;
FreeMem(FCanMsgs);
FCanMsgs := nil;
RxCanLeaveCritical;  
end;  


function TTxCanList.SaveToFile(filename: String): Integer;
var tx_msg: PTxCanMsg;
    can_msg: PCanFdMsg;
    line, fmt_str, id_dlc_str: string;
    str: string[255];
    txm_str: string[20];
    d, idx: Byte;
    dlc, dlc_max, i, ii: integer;
    rtr, eff, fd, brs: boolean;
    f: TextFile;

begin;
try
  AssignFile(f, filename);
  Rewrite(f);
  if FdMode then
    begin;
    Writeln(f, 'Frame;ID;DLC;D0;D1;D2;D3;D4;D5;D6;D7;D8;D9;D10;D11;D12;D13;D14;D15;' +
                            'D16;D17;D18;D19;D20;D21;D22;D23;D24;D25;D26;D27;D28;D29;D30;D31;' +
                            'D32;D33;D34;D35;D36;D37;D38;D39;D40;D41;D42;D43;D44;D45;D46;D47;' +
                            'D48;D49;D50;D51;D52;D53;D54;D55;D56;D57;D58;D59;D60;D61;D62;D63;' +
                            'TxMode;TriggerId;Intervall;Coment');
    dlc_max := 64;
    end
  else
    begin;
    dlc_max := 8;
    Writeln(f, 'Frame;ID;DLC;D0;D1;D2;D3;D4;D5;D6;D7;TxMode;TriggerId;Intervall;Coment');
    end;
  for i := 0 to FCount-1 do
    begin
    tx_msg := @FCanMsgs[i];
    can_msg := @tx_msg^.CanMsg;
    dlc := can_msg^.Length;
    if not FdMode and (dlc > 8) then
      dlc := 8;
    if FdMode then
      begin;
      if (can_msg^.Flags and FlagCanFdFD) > 0 then
        fd := True
      else
        fd := False;
      if (can_msg^.Flags and FlagCanFdBRS) > 0 then
        brs := True
      else
        brs := False;
      end
    else
      begin;
      fd := False;
      brs := False;
      end;
    if (can_msg^.Flags and FlagCanFdEFF) > 0 then
      eff := True
    else
      eff := False;
    if (can_msg^.Flags and FlagCanFdRTR) > 0 then
      rtr := True
    else
      rtr := False;
    //  Frame Format
    if rtr and eff then
      fmt_str := 'EFF/RTR'
    else if eff then
      fmt_str := 'EFF'
    else if rtr then
      fmt_str := 'STD/RTR'
    else
      fmt_str := 'STD';
    if fd and brs then
      fmt_str := fmt_str + ' FD/BRS'
    else if fd then
      fmt_str := fmt_str + ' FD';
    // ID; DLC;
    if eff then
      id_dlc_str := format('%08X;%u', [can_msg^.ID, dlc])
    else
      id_dlc_str := format('%04X;%u', [can_msg^.ID, dlc]);
    // Data  
    idx := 0;
    if (dlc > 0) and not rtr then
      begin;
      for ii := 0 to dlc-1 do
        begin;
        d := can_msg^.Data.Bytes[ii];
        inc(idx);
        str[idx] := HexDigits[d SHR $04];
        inc(idx);
        str[idx] := HexDigits[d AND $0F];
        inc(idx);
        str[idx] := ';';
        end;
      end;
    if rtr then
      dlc := 0;
    if dlc < dlc_max then
      begin;
      for ii := dlc to dlc_max do
        begin;
        inc(idx);
        str[idx] := ';';
        end;
      end;
    str[0] := Char(idx);
    case tx_msg^.TxMode of
      0 : txm_str := 'Off';
      1 : txm_str := 'Periodic';
      2 : txm_str := 'RTR';
      3 : txm_str := 'Trigger'
      end;
    line := format('%s;%s;%s%s;%08X;%u;%s;', [fmt_str, id_dlc_str, str, txm_str, tx_msg^.TriggerId, tx_msg^.Intervall, tx_msg^.Comment]);
    Writeln(f, line);
    end;
finally
  CloseFile(f);
  end;
result := 0;
end;


function TTxCanList.LoadFromFile(filename: String): Integer;
const
    Delims = [';'];
var  f: TextFile;
     line, item: String;
     i, items_cnt, p, dlc_max: Integer;
     tx_msg: TTxCanMsg;
     value: DWord;
     fd: boolean; 

begin;
result := 0;
RxCanEnterCritical;
Lock := TRUE;
RxCanLeaveCritical;
Clear;
try
  AssignFile(f, filename);
  Reset(f);
  Readln(f, line);  // Header auslesen
  items_cnt := 0;
  for i := 1 to length(line) do
    begin;
    if line[i] = ';' then
      inc(items_cnt);
    end;
  if items_cnt = 70 then    
    begin;
    fd := TRUE;
    dlc_max := 64;
    end
  else
    begin;
    fd := FALSE;
    dlc_max := 8;
    end;  
  while not(eof(f)) do // Zeilenschleife
    begin
    // Frame;ID;DLC;D0;D1;D2;D3;D4;D5;D6;D7;TxMode;TriggerId;Intervall;Coment
    Readln(f, line);

    p := 1;
    tx_msg.CanMsg.Flags := 0;
    // *** Frame Type lesen
    item := UpperCase(ExtractSubstr(line, p, Delims));
    if Pos('EFF', item) <> 0 then
      tx_msg.CanMsg.Flags := tx_msg.CanMsg.Flags or FlagCanFdEFF;
    if Pos('RTR', item) <> 0 then
      tx_msg.CanMsg.Flags := tx_msg.CanMsg.Flags or FlagCanFdRTR;
    if fd then
      begin;
      if Pos('FD', item) <> 0 then
        tx_msg.CanMsg.Flags := tx_msg.CanMsg.Flags or FlagCanFdFD;
      if Pos('BRS', item) <> 0 then
        tx_msg.CanMsg.Flags := tx_msg.CanMsg.Flags or FlagCanFdBRS;
      end;  
    // **** ID
    item := ExtractSubstr(line, p, Delims);
    tx_msg.CanMsg.ID := StrToHex(item);
    // **** DLC
    item := ExtractSubstr(line, p, Delims);
    value := StrtoIntDef(item, 0);
    tx_msg.CanMsg.Length := value;
    for i := 0 to (dlc_max - 1) do
      begin;
      item := ExtractSubstr(line, p, Delims);
      tx_msg.CanMsg.Data.Bytes[i] := StrToHex(item);
      end;
    // **** TxMode
    item := UpperCase(ExtractSubstr(line, p, Delims));
    if Pos('PERIODIC', item) <> 0 then
      tx_msg.TxMode := 1
    else if Pos('RTR', item) <> 0 then
      tx_msg.TxMode := 2
    else if Pos('TRIGGER', item) <> 0 then
      tx_msg.TxMode := 3
    else
      tx_msg.TxMode := 0;
    // **** TriggerId
    item := ExtractSubstr(line, p, Delims);
    tx_msg.TriggerId := StrToHex(item);
    // **** Intervall
    item := ExtractSubstr(line, p, Delims);
    tx_msg.Intervall := StrtoIntDef(item, 0);
    // **** Comment
    item := ExtractSubstr(line, p, Delims);
    tx_msg.Comment := item;
    inc(result);
    Add(@tx_msg);
    end;
finally
  CloseFile(f);
  RxCanEnterCritical;
  Lock := FALSE;
  RxCanLeaveCritical;
  end;
end;


procedure TTxCanList.ResetIntervallTimers;
var tx_msg: PTxCanMsg;
    i: Integer;

begin;
for i := 0 to FCount-1 do
  begin
  tx_msg := @FCanMsgs[i];
  tx_msg^.Timer := tx_msg^.Intervall;   // Interval Timer zurücksetzen
  end;
end;


procedure TTxCanList.SetIntervallMode(enable: boolean);

begin;
GlobalIntervallEnable := enable;
if GlobalIntervallEnable then
  begin;
  ResetIntervallTimers;
  LastSleepTime := 100;
  FIntTimer.Interval := 100;
  FIntTimer.Enabled := True;
  end
else
  FIntTimer.Enabled := False;
end;

end.