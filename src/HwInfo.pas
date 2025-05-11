unit HwInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, TinyCanDrv, ExtCtrls, util;
  
type
  TInfoVarDescItem = record
    Key: DWord;
    Text: String;
    end;

  THwInfoForm = class(TForm)
    InfoGridWdg: TStringGrid;
    ButtonPanel: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    function GetDescText(key: DWord): String;
  public
    { Public-Deklarationen }
    procedure Execute(info_list: TCanInfoVarObj; title: String);
  end;

const
  InfoVarDescTab: array[0..57] of TInfoVarDescItem = (
    (Key:$00001000; Text:'ID'),
    (Key:$00001001; Text:'ID String'),
    (Key:$00001002; Text:'Version'),
    (Key:$00001003; Text:'Version String'),
    (Key:$00001004; Text:'Autor'),
    (Key:$00001005; Text:'Optionen'),
    (Key:$00001006; Text:'Snr'),
    (Key:$00000002; Text:'Bios ID String'),
    (Key:$00000001; Text:'Hardware ID String'),
    (Key:$00000000; Text:'Hardware Snr'),
    (Key:$00000003; Text:'Hardware Revision'),
    (Key:$00000004; Text:'Fertigungsdatum'),
    (Key:$0000000A; Text:'Ident-String'),
    (Key:$00008000; Text:'Anzahl CAN Interfaces'),
    (Key:$00008001; Text:'CAN Features Flags'),
    (Key:$00008002; Text:'CAN Features Flags2'),
    (Key:$00008003; Text:'CAN Clock 1'),        
    (Key:$00008004; Text:'CAN Clock 2'),        
    (Key:$00008005; Text:'CAN Clock 3'),        
    (Key:$00008006; Text:'CAN Clock 4'),        
    (Key:$00008007; Text:'CAN Clock 5'),        
    (Key:$00008008; Text:'CAN Clock 6'),        
    (Key:$00008009; Text:'CAN Clock 7'),        
    (Key:$0000800A; Text:'CAN Clock 8'),        
    (Key:$0000800B; Text:'CAN Clock 9'),        
    (Key:$0000800C; Text:'CAN Clock 10'),
    (Key:$00008010; Text:'Treiber'),
    (Key:$00008020; Text:'Opto'),
    (Key:$00008030; Text:'Term'),
    (Key:$00008040; Text:'HighSpeed'),
    (Key:$00008050; Text:'Anzahl Interval Puffer'),
    (Key:$00008060; Text:'Anzahl Filter'),
    (Key:$00008100; Text:'Anzahl I2C Interfaces'),
    (Key:$00008200; Text:'Anzahl SPI Interfaces'),
    (Key:$01000001; Text:'Device-Index'),       // TCAN_INFO_KEY_OPEN_INDEX  
    (Key:$01000002; Text:'Hardware ID'),        // TCAN_INFO_KEY_HARDWARE_ID 
    (Key:$01000003; Text:'Hardware'),           // TCAN_INFO_KEY_HARDWARE    
    (Key:$01000004; Text:'Vendor'),             // TCAN_INFO_KEY_VENDOR      
    (Key:$01000005; Text:'Device Name'),        // TCAN_INFO_KEY_DEVICE_NAME 
    (Key:$01000006; Text:'Seriennummer'),       // TCAN_INFO_KEY_SERIAL_NUMBER
    (Key:$01000007; Text:'Features'),           // TCAN_INFO_KEY_FEATURES    
    (Key:$01000008; Text:'Anzahl CAN Kanaele'), // TCAN_INFO_KEY_CAN_CHANNELS
    (Key:$01000009; Text:'RX-Filter Count'),    // TCAN_INFO_KEY_RX_FILTER_CNT
    (Key:$0100000A; Text:'TX-Puffer Count'),    // TCAN_INFO_KEY_TX_BUFFER_CNT
    (Key:$0100000B; Text:'CAN Clocks Count'),   // TCAN_INFO_KEY_CAN_CLOCKS  
    (Key:$0100000C; Text:'CAN Clock 1'),        // TCAN_INFO_KEY_CAN_CLOCK1  
    (Key:$0100000D; Text:'CAN Clock 2'),        // TCAN_INFO_KEY_CAN_CLOCK2  
    (Key:$0100000E; Text:'CAN Clock 3'),        // TCAN_INFO_KEY_CAN_CLOCK3  
    (Key:$0100000F; Text:'CAN Clock 4'),        // TCAN_INFO_KEY_CAN_CLOCK4  
    (Key:$01000010; Text:'CAN Clock 5'),        // TCAN_INFO_KEY_CAN_CLOCK5  
    (Key:$01000011; Text:'CAN Clock 6'),        // TCAN_INFO_KEY_CAN_CLOCK6  
    (Key:$01000012; Text:'CAN Clock 7'),        // TCAN_INFO_KEY_CAN_CLOCK7  
    (Key:$01000013; Text:'CAN Clock 8'),        // TCAN_INFO_KEY_CAN_CLOCK8
    (Key:$01000014; Text:'CAN Clock 9'),        // TCAN_INFO_KEY_CAN_CLOCK9  
    (Key:$01000015; Text:'CAN Clock 10'),       // TCAN_INFO_KEY_CAN_CLOCK10         
    (Key:$02000001; Text:'API-Version'),        // TCAN_INFO_KEY_API_VERSION 
    (Key:$02000002; Text:'Driver DLL'),         // TCAN_INFO_KEY_DLL         
    (Key:$02000003; Text:'Config App'));        // TCAN_INFO_KEY_CFG_APP

var
  HwInfoForm: THwInfoForm;

implementation

{$R *.dfm}

function THwInfoForm.GetDescText(key: DWord): String;
var i: Integer;

begin;
for i := 0 to 57 do
  begin;
  if InfoVarDescTab[i].Key = key then
    begin;
    result := InfoVarDescTab[i].Text;
    exit;
    end;
  end;
result := Format('0x%.8X', [key]);
end;


procedure THwInfoForm.Execute(info_list: TCanInfoVarObj; title: String);
var item: PCanInfoVar;
    i, height, width, h_space, v_space: Integer;
    Line: Longint;

begin
if info_list.Count < 1 then
  begin;
  MessageDlg(title + ': keine Daten vorhanden', mtError, [mbOk], 0);
  exit;
  end;
HwInfoForm.Caption := title;
InfoGridWdg.RowCount := 1;
InfoGridWdg.Cells[0,0] := '';
for i := 0 to info_list.Count - 1 do
  begin;
  item := info_list[i];
  with InfoGridWdg do
    begin
    { 1. Zeiel Check}
    if Cells[0,0]<>'' then
      RowCount := RowCount + 1;
    Line := RowCount - 1;
    Cells[0,Line] := GetDescText(item.Key);
    Cells[1,Line] := item.ValueStr;
    end;
  end;
AutoStringGridSize(InfoGridWdg, height, width);
h_space := HwInfoForm.Height - HwInfoForm.ClientHeight;
v_space := HwInfoForm.Width - HwInfoForm.ClientWidth;
HwInfoForm.Height := height + ButtonPanel.Height + h_space;
HwInfoForm.Width := width + v_space;
ShowModal;
info_list.Free;
end;


procedure THwInfoForm.Button1Click(Sender: TObject);
begin
Close;
end;

end.
