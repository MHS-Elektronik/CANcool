unit XLAbout;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

{$WARN SYMBOL_DEPRECATED OFF}
{$IFnDEF FPC}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CODE OFF}
{$ENDIF}

// Messages <*> Delphi rein ?
uses
  SysUtils, Windows, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TXLAboutBox = class(TForm)
    OKButton: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Copyright: TLabel;
    Bevel1: TBevel;
    Version: TLabel;
    Label3: TLabel;
    PhysMem: TLabel;
    OS: TLabel;
    URL: TLabel;
    ProgramIcon: TImage;
    ProductName1: TLabel;
    ProductName3: TLabel;
    ProductName2: TLabel;
    Company: TLabel;
    EMAIL: TLabel;
    CompView: TMemo;
    LizenzView: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure URLClick(Sender: TObject);
    procedure EMAILClick(Sender: TObject);
  private
    procedure GetOSInfo;
    procedure InitializeCaptions;
    function Regkey(Key: HKEY; Subkey: string; var Data: string): Longint;
  end;
  
implementation

uses ShellAPI;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

function TXLAboutBox.Regkey(Key: HKEY; Subkey: string; var Data: string): Longint;
var
  H    : HKEY;                 
  tData: array[0..259] of Char;
  dSize: Integer;              
begin
  Result := RegOpenKeyEx(Key, PChar(Subkey), 0, KEY_QUERY_VALUE, H);
  if Result = ERROR_SUCCESS then
  begin
    dSize := Sizeof(tData);
    RegQueryValue(H, nil, tData, dSize);
    Data := StrPas(tData);
    RegCloseKey(H);
  end;
end;

procedure TXLAboutBox.GetOSInfo;
var
  Platform   : string; 
  BuildNumber: Integer;
begin
  case Win32Platform of
    VER_PLATFORM_WIN32_WINDOWS:
    begin
      Platform := 'Windows 95';
      BuildNumber := Win32BuildNumber and $0000FFFF;
    end;
    VER_PLATFORM_WIN32_NT:
    begin
      Platform := 'Windows NT';
      BuildNumber := Win32BuildNumber;
    end;
  else
  begin
    Platform := 'Windows';
    BuildNumber := 0;
  end;
end;
if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) or
  (Win32Platform = VER_PLATFORM_WIN32_NT) then
begin
  if Win32CSDVersion = '' then
    OS.Caption := Format('%s %d.%d (Build %d)',[Platform, Win32MajorVersion,
    Win32MinorVersion, BuildNumber])
  else
    OS.Caption := Format('%s %d.%d (Build %d: %s)',[Platform, Win32MajorVersion,
      Win32MinorVersion, BuildNumber, Win32CSDVersion]);
end
else
  OS.Caption := Format('%s %d.%d',[Platform, Win32MajorVersion,
    Win32MinorVersion])
end;

procedure TXLAboutBox.InitializeCaptions;
var
  ms: TMemoryStatus;
begin
  GetOSInfo;
  ms.dwLength := Sizeof(TMemoryStatus);
  GlobalMemoryStatus(ms);
  PhysMem.Caption := FormatFloat('#,###" KB"', ms.dwTotalPhys div 1024);
end;

procedure TXLAboutBox.FormCreate(Sender: TObject);
begin
  InitializeCaptions;
end;

procedure TXLAboutBox.URLClick(Sender: TObject);
var
  P  : Integer;
  Key: string; 
begin
  if Regkey(HKEY_CLASSES_ROOT, '.htm', Key) = ERROR_SUCCESS then
  begin
    Key := Key + '\shell\open\command';
    if Regkey(HKEY_CLASSES_ROOT, Key, Key) = ERROR_SUCCESS then
    begin
      P := Pos('"%1"', Key);
      if P = 0 then
        P := Pos('%1', Key);
      if P <> 0 then
        setlength(Key, P - 1);
      Key := Key + ' ' + URL.Caption;
      if WinExec(PChar(Key), SW_SHOWNORMAL) < 32 then
        raise Exception.Create('Couldn''t launch default browser');
    end;
  end;
end;

procedure TXLAboutBox.EMAILClick(Sender: TObject);
begin
  ShellExecute(0, nil, PChar('mailto:' + EMAIL.Caption), nil, nil, SW_NORMAL);
end;

end.

