object CanTxWin: TCanTxWin
  Left = 196
  Top = 258
  Width = 1053
  Height = 314
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Senden'
  Color = clBtnFace
  Constraints.MinHeight = 160
  Constraints.MinWidth = 570
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
  OnShow = FormShow
  PixelsPerInch = 110
  TextHeight = 16
  object TxView: TStringGrid
    Left = 0
    Top = 0
    Width = 1045
    Height = 145
    Align = alClient
    ColCount = 9
    DefaultColWidth = 35
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = TxViewClick
    OnDrawCell = TxViewDrawCell
    OnMouseDown = TxViewMouseDown
    OnMouseUp = TxViewMouseUp
  end
  object KopfPanel: TPanel
    Left = 0
    Top = 145
    Width = 1045
    Height = 120
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 74
      Top = 10
      Width = 13
      Height = 16
      Alignment = taRightJustify
      Caption = 'ID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 197
      Top = 10
      Width = 36
      Height = 16
      Alignment = taRightJustify
      Caption = 'Daten'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 150
      Top = 10
      Width = 26
      Height = 16
      Alignment = taRightJustify
      Caption = 'DLC'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 601
      Top = 20
      Width = 55
      Height = 16
      Caption = 'TX Mode'
    end
    object Label5: TLabel
      Left = 302
      Top = 79
      Width = 69
      Height = 16
      Caption = 'Bemerkung'
    end
    object Label6: TLabel
      Left = 597
      Top = 59
      Width = 60
      Height = 16
      Caption = 'Trigger ID'
    end
    object Label7: TLabel
      Left = 583
      Top = 89
      Width = 75
      Height = 16
      Caption = 'Intervall (ms)'
    end
    object MsgAddBtn: TBitBtn
      Left = 798
      Top = 20
      Width = 119
      Height = 32
      Caption = 'Hinzuf'#252'gen'
      TabOrder = 15
      OnClick = MsgAddBtnClick
      NumGlyphs = 2
    end
    object MsgDelBtn: TBitBtn
      Left = 926
      Top = 69
      Width = 99
      Height = 32
      Caption = 'Entfernen'
      TabOrder = 16
      OnClick = MsgDelBtnClick
      NumGlyphs = 2
    end
    object DataEdit0: TZahlenEdit
      Left = 197
      Top = 30
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object DataEdit1: TZahlenEdit
      Tag = 1
      Left = 242
      Top = 30
      Width = 46
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object DataEdit2: TZahlenEdit
      Tag = 2
      Left = 289
      Top = 30
      Width = 46
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object DataEdit3: TZahlenEdit
      Tag = 3
      Left = 336
      Top = 30
      Width = 46
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object DataEdit7: TZahlenEdit
      Tag = 7
      Left = 522
      Top = 30
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
    object DataEdit4: TZahlenEdit
      Tag = 4
      Left = 382
      Top = 30
      Width = 45
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object DataEdit5: TZahlenEdit
      Tag = 5
      Left = 428
      Top = 30
      Width = 46
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object DataEdit6: TZahlenEdit
      Tag = 6
      Left = 475
      Top = 30
      Width = 46
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object DLCEdit: TZahlenEdit
      Tag = 9
      Left = 149
      Top = 30
      Width = 29
      Height = 24
      Number = 0
      ZahlenFormat = DezFormat
      IdShowing = False
      ByteMode = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object CanFormatGroupBox: TGroupBox
      Left = 9
      Top = 60
      Width = 272
      Height = 50
      Caption = 'CAN Format '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      object RTRCheck: TCheckBox
        Tag = 10
        Left = 10
        Top = 20
        Width = 112
        Height = 22
        Caption = 'RTR Paket'
        TabOrder = 0
      end
      object EFFCheck: TCheckBox
        Tag = 11
        Left = 128
        Top = 20
        Width = 139
        Height = 22
        Caption = 'Ext. Frame Format'
        TabOrder = 1
      end
    end
    object IDEdit: TZahlen32Edit
      Tag = 8
      Left = 10
      Top = 30
      Width = 119
      Height = 24
      Number = 234881024
      ZahlenFormat = HexFormat
      IdShowing = False
      BinMode = Z32AutoMode
      HexMode = Z32AutoMode
      AutoFormat = False
      TabOrder = 0
    end
    object CommentEdit: TEdit
      Tag = 12
      Left = 374
      Top = 74
      Width = 198
      Height = 24
      TabOrder = 11
    end
    object TxModeCombo: TComboBox
      Tag = 13
      Left = 660
      Top = 15
      Width = 99
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 12
      Text = 'OFF'
      Items.Strings = (
        'OFF'
        'Periodic'
        'RTR'
        'Trigger')
    end
    object TriggerIdEdit: TZahlen32Edit
      Tag = 14
      Left = 660
      Top = 54
      Width = 119
      Height = 24
      Number = 234881024
      ZahlenFormat = HexFormat
      IdShowing = False
      BinMode = Z32AutoMode
      HexMode = Z32AutoMode
      AutoFormat = False
      TabOrder = 13
    end
    object IntervallEdit: TZahlen32Edit
      Tag = 15
      Left = 660
      Top = 84
      Width = 70
      Height = 24
      Number = 0
      ZahlenFormat = DezFormat
      IdShowing = False
      BinMode = Z32AutoMode
      HexMode = Z32AutoMode
      AutoFormat = False
      TabOrder = 14
    end
    object MsgTxBtn: TBitBtn
      Left = 926
      Top = 20
      Width = 99
      Height = 30
      Caption = 'Senden'
      TabOrder = 17
      OnClick = MsgTxBtnClick
      NumGlyphs = 2
    end
    object MsgCopyBtn: TBitBtn
      Left = 798
      Top = 69
      Width = 119
      Height = 32
      Caption = 'Kopieren'
      TabOrder = 18
      OnClick = MsgCopyBtnClick
      NumGlyphs = 2
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'csv'
    Filter = 'CSV Format (*.csv)|*.csv|Alle Dateien (*.*)|*.*'
    Title = 'Senden Liste importieren'
    Left = 504
    Top = 136
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV Format (*.csv)|*.csv|Alle Dateien (*.*)|*.*'
    Title = 'Senden Liste exportieren'
    Left = 544
    Top = 136
  end
end
