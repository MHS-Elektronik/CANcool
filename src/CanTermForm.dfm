inherited CanTermWin: TCanTermWin
  Left = 321
  Top = 1577
  Width = 333
  Height = 131
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'CAN Terminal'
  OldCreateOrder = True
  PopupMenu = CanTermMenu
  PixelsPerInch = 110
  TextHeight = 16
  object VT: TEmulVT
    Left = 0
    Top = 0
    Width = 325
    Height = 82
    OnKeyPress = VTKeyPress
    OnKeyBuffer = VTKeyBuffer
    Align = alClient
    BorderStyle = bsSingle
    AutoRepaint = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = vtsWhite
    Font.Height = -18
    Font.Name = 'Terminal'
    Font.Style = []
    Font.BackColor = vtsBlack
    LocalEcho = True
    AutoLF = False
    AutoCR = False
    Xlat = True
    MonoChrome = False
    Log = False
    LogFileName = 'EMULVT.LOG'
    Rows = 25
    Cols = 80
    BackRows = 0
    BackColor = vtsWhite
    Options = [vtoBackColor]
    LineHeight = 18.000000000000000000
    CharWidth = 10.000000000000000000
    SoundOn = False
    AutoReSize = False
    TabOrder = 0
    FKeys = 1
    TopMargin = 4
    LeftMargin = 6
    RightMargin = 6
    BottomMargin = 4
    MarginColor = 0
  end
  object CanTermMenu: TPopupMenu
    object ConfigBtn: TMenuItem
      Caption = 'Konfigurieren'
      OnClick = ConfigBtnClick
    end
    object AktivBtn: TMenuItem
      AutoCheck = True
      Caption = 'Aktiv'
      Checked = True
      OnClick = AktivBtnClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object DestroyBtn: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = DestroyBtnClick
    end
  end
end
