object CanRxWin: TCanRxWin
  Left = 345
  Top = 1795
  Width = 709
  Height = 296
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Empfang'
  Color = clBtnFace
  Constraints.MinHeight = 160
  Constraints.MinWidth = 476
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 110
  TextHeight = 16
  object RxView: TStringGrid
    Left = 0
    Top = 0
    Width = 701
    Height = 122
    Align = alClient
    ColCount = 6
    DefaultColWidth = 53
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -31
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    PopupMenu = RxWinPopup
    ShowHint = True
    TabOrder = 0
    OnClick = RxViewClick
    OnDrawCell = RxViewDrawCell
  end
  object RxPanel: TPanel
    Left = 0
    Top = 122
    Width = 701
    Height = 125
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PopupMenu = RxWinPopup
    TabOrder = 1
    Visible = False
    object HeaderLabel: TLabel
      Left = 0
      Top = 0
      Width = 344
      Height = 17
      Caption = '[ID: ] [Count: 0] [Period: * Min: * Max: *]'
    end
    object Label2: TLabel
      Left = 0
      Top = 49
      Width = 32
      Height = 17
      Caption = 'Hex:'
    end
    object Label3: TLabel
      Left = 0
      Top = 69
      Width = 64
      Height = 17
      Caption = 'Dezimal:'
    end
    object Label4: TLabel
      Left = 0
      Top = 89
      Width = 56
      Height = 17
      Caption = 'Binary:'
    end
    object AsciiLabel: TLabel
      Left = 69
      Top = 108
      Width = 8
      Height = 17
    end
    object Label6: TLabel
      Left = 0
      Top = 108
      Width = 48
      Height = 17
      Caption = 'ASCII:'
    end
    object BinLabel: TLabel
      Left = 69
      Top = 89
      Width = 8
      Height = 17
    end
    object DezLabel: TLabel
      Left = 69
      Top = 69
      Width = 8
      Height = 17
    end
    object HexLabel: TLabel
      Left = 69
      Top = 49
      Width = 8
      Height = 17
    end
    object Label10: TLabel
      Left = 69
      Top = 20
      Width = 568
      Height = 17
      Caption = 
        '--- 0 -- --- 1 -- --- 2 -- --- 3 -- --- 4 -- --- 5 -- --- 6 -- -' +
        '-- 7 --'
    end
    object Analog1: TProgressBar
      Left = 69
      Top = 39
      Width = 69
      Height = 11
      Max = 255
      Smooth = True
      TabOrder = 0
    end
    object Analog2: TProgressBar
      Left = 146
      Top = 39
      Width = 69
      Height = 11
      Max = 255
      Smooth = True
      TabOrder = 1
    end
    object Analog3: TProgressBar
      Left = 224
      Top = 39
      Width = 69
      Height = 11
      Max = 255
      Smooth = True
      TabOrder = 2
    end
    object Analog4: TProgressBar
      Left = 302
      Top = 39
      Width = 68
      Height = 11
      Max = 255
      Smooth = True
      TabOrder = 3
    end
    object Analog5: TProgressBar
      Left = 379
      Top = 39
      Width = 69
      Height = 11
      Max = 255
      Smooth = True
      TabOrder = 4
    end
    object Analog6: TProgressBar
      Left = 457
      Top = 39
      Width = 69
      Height = 11
      Max = 255
      Smooth = True
      TabOrder = 5
    end
    object Analog7: TProgressBar
      Left = 534
      Top = 39
      Width = 69
      Height = 11
      Max = 255
      Smooth = True
      TabOrder = 6
    end
    object Analog8: TProgressBar
      Left = 612
      Top = 39
      Width = 69
      Height = 11
      Max = 255
      Smooth = True
      TabOrder = 7
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CAN-Log (*.csv)|*.csv|Alle Dateien (*.*)|*.*'
    Title = 'CAN Trace speichern'
    Left = 344
    Top = 8
  end
  object RxWinPopup: TPopupMenu
    Left = 376
    Top = 8
    object AddMsgToTxWinPopup: TMenuItem
      Caption = 'Nachricht in Senden-Fenster einf'#252'gen'
      OnClick = AddMsgToTxWinPopupClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ShowRxPannelPopup: TMenuItem
      AutoCheck = True
      Caption = 'Show Rx Pannel'
      OnClick = ShowRxPannelPopupClick
    end
    object ClearStatistikPopup: TMenuItem
      Caption = 'Statistik l'#246'schen'
      OnClick = ClearStatistikPopupClick
    end
  end
end
