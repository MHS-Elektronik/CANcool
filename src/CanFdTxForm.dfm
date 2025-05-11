object CanFdTxWin: TCanFdTxWin
  Left = 218
  Top = 237
  Width = 902
  Height = 725
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
  PixelsPerInch = 110
  TextHeight = 16
  object TxView: TStringGrid
    Left = 0
    Top = 0
    Width = 894
    Height = 437
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
    Top = 437
    Width = 894
    Height = 239
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 26
      Top = 18
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
      Left = 325
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
      Left = 198
      Top = 18
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
      Left = 9
      Top = 148
      Width = 55
      Height = 16
      Caption = 'TX Mode'
    end
    object Label5: TLabel
      Left = 14
      Top = 207
      Width = 69
      Height = 16
      Caption = 'Bemerkung'
    end
    object Label6: TLabel
      Left = 133
      Top = 179
      Width = 60
      Height = 16
      Caption = 'Trigger ID'
    end
    object Label7: TLabel
      Left = 175
      Top = 145
      Width = 75
      Height = 16
      Caption = 'Intervall (ms)'
    end
    object Label9: TLabel
      Left = 336
      Top = 56
      Width = 22
      Height = 16
      Caption = '[08]'
      Layout = tlCenter
    end
    object Label10: TLabel
      Left = 336
      Top = 80
      Width = 22
      Height = 16
      Caption = '[16]'
      Layout = tlCenter
    end
    object Label11: TLabel
      Left = 336
      Top = 104
      Width = 22
      Height = 16
      Caption = '[24]'
      Layout = tlCenter
    end
    object Label12: TLabel
      Left = 336
      Top = 128
      Width = 22
      Height = 16
      Caption = '[32]'
      Layout = tlCenter
    end
    object Label13: TLabel
      Left = 336
      Top = 152
      Width = 22
      Height = 16
      Caption = '[40]'
      Layout = tlCenter
    end
    object Label14: TLabel
      Left = 336
      Top = 176
      Width = 22
      Height = 16
      Caption = '[48]'
      Layout = tlCenter
    end
    object Label15: TLabel
      Left = 336
      Top = 200
      Width = 22
      Height = 16
      Caption = '[56]'
      Layout = tlCenter
    end
    object Label8: TLabel
      Left = 336
      Top = 32
      Width = 22
      Height = 16
      Caption = '[00]'
      Layout = tlCenter
    end
    object Label16: TLabel
      Left = 364
      Top = 10
      Width = 14
      Height = 16
      Alignment = taCenter
      Caption = '+0'
    end
    object Label17: TLabel
      Left = 410
      Top = 10
      Width = 14
      Height = 16
      Alignment = taCenter
      Caption = '+1'
    end
    object Label18: TLabel
      Left = 456
      Top = 10
      Width = 14
      Height = 16
      Alignment = taCenter
      Caption = '+2'
    end
    object Label19: TLabel
      Left = 502
      Top = 10
      Width = 14
      Height = 16
      Alignment = taCenter
      Caption = '+3'
    end
    object Label20: TLabel
      Left = 548
      Top = 10
      Width = 14
      Height = 16
      Alignment = taCenter
      Caption = '+4'
    end
    object Label21: TLabel
      Left = 594
      Top = 10
      Width = 14
      Height = 16
      Alignment = taCenter
      Caption = '+5'
    end
    object Label22: TLabel
      Left = 640
      Top = 10
      Width = 14
      Height = 16
      Alignment = taCenter
      Caption = '+6'
    end
    object Label23: TLabel
      Left = 686
      Top = 10
      Width = 14
      Height = 16
      Alignment = taCenter
      Caption = '+7'
    end
    object MsgAddBtn: TBitBtn
      Left = 758
      Top = 92
      Width = 119
      Height = 32
      Caption = 'Hinzuf'#252'gen'
      TabOrder = 71
      OnClick = MsgAddBtnClick
      NumGlyphs = 2
    end
    object MsgDelBtn: TBitBtn
      Left = 758
      Top = 189
      Width = 119
      Height = 32
      Caption = 'Entfernen'
      TabOrder = 73
      OnClick = MsgDelBtnClick
      NumGlyphs = 2
    end
    object DataEdit0: TZahlenEdit
      Left = 364
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
      TabOrder = 1
    end
    object DataEdit1: TZahlenEdit
      Tag = 1
      Left = 410
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
    object DataEdit2: TZahlenEdit
      Tag = 2
      Left = 456
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
      TabOrder = 3
    end
    object DataEdit3: TZahlenEdit
      Tag = 3
      Left = 502
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
      TabOrder = 4
    end
    object DataEdit7: TZahlenEdit
      Tag = 7
      Left = 686
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
      TabOrder = 8
    end
    object DataEdit4: TZahlenEdit
      Tag = 4
      Left = 548
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
      TabOrder = 5
    end
    object DataEdit5: TZahlenEdit
      Tag = 5
      Left = 594
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
    object DataEdit6: TZahlenEdit
      Tag = 6
      Left = 640
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
      TabOrder = 7
    end
    object CanFormatGroupBox: TGroupBox
      Left = 9
      Top = 52
      Width = 304
      Height = 77
      Caption = 'CAN Format '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 65
      object RTRCheck: TCheckBox
        Tag = 66
        Left = 10
        Top = 20
        Width = 112
        Height = 22
        Caption = 'RTR Paket'
        TabOrder = 0
      end
      object EFFCheck: TCheckBox
        Tag = 67
        Left = 136
        Top = 20
        Width = 139
        Height = 22
        Caption = 'Ext. Frame Format'
        TabOrder = 1
      end
      object CanFdCheck: TCheckBox
        Tag = 68
        Left = 10
        Top = 44
        Width = 112
        Height = 22
        Caption = 'CAN-FD Frame'
        TabOrder = 2
      end
      object CanFdBrsCheck: TCheckBox
        Tag = 69
        Left = 136
        Top = 44
        Width = 139
        Height = 22
        Caption = 'Bit Rate Switch'
        TabOrder = 3
      end
    end
    object IDEdit: TZahlen32Edit
      Tag = 64
      Left = 50
      Top = 14
      Width = 119
      Height = 24
      Number = 15663104
      ZahlenFormat = HexFormat
      IdShowing = False
      BinMode = Z32AutoMode
      HexMode = Z32AutoMode
      AutoFormat = False
      TabOrder = 0
    end
    object CommentEdit: TEdit
      Tag = 73
      Left = 88
      Top = 202
      Width = 227
      Height = 24
      TabOrder = 69
    end
    object TxModeCombo: TComboBox
      Tag = 70
      Left = 68
      Top = 143
      Width = 99
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 66
      Text = 'OFF'
      Items.Strings = (
        'OFF'
        'Periodic'
        'RTR'
        'Trigger')
    end
    object TriggerIdEdit: TZahlen32Edit
      Tag = 72
      Left = 196
      Top = 174
      Width = 119
      Height = 24
      Number = 234881024
      ZahlenFormat = HexFormat
      IdShowing = False
      BinMode = Z32AutoMode
      HexMode = Z32AutoMode
      AutoFormat = False
      TabOrder = 67
    end
    object IntervallEdit: TZahlen32Edit
      Tag = 71
      Left = 256
      Top = 140
      Width = 58
      Height = 24
      Number = 0
      ZahlenFormat = DezFormat
      IdShowing = False
      BinMode = Z32AutoMode
      HexMode = Z32AutoMode
      AutoFormat = False
      TabOrder = 68
    end
    object MsgTxBtn: TBitBtn
      Left = 758
      Top = 28
      Width = 119
      Height = 30
      Caption = 'Senden'
      TabOrder = 70
      OnClick = MsgTxBtnClick
      NumGlyphs = 2
    end
    object MsgCopyBtn: TBitBtn
      Left = 758
      Top = 141
      Width = 119
      Height = 32
      Caption = 'Kopieren'
      TabOrder = 72
      OnClick = MsgCopyBtnClick
      NumGlyphs = 2
    end
    object DataEdit8: TZahlenEdit
      Tag = 8
      Left = 364
      Top = 54
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
    object DataEdit9: TZahlenEdit
      Tag = 9
      Left = 410
      Top = 54
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
      TabOrder = 10
    end
    object DataEdit10: TZahlenEdit
      Tag = 10
      Left = 456
      Top = 54
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
      TabOrder = 11
    end
    object DataEdit11: TZahlenEdit
      Tag = 11
      Left = 502
      Top = 54
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
      TabOrder = 12
    end
    object DataEdit15: TZahlenEdit
      Tag = 15
      Left = 686
      Top = 54
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
      TabOrder = 16
    end
    object DataEdit12: TZahlenEdit
      Tag = 12
      Left = 548
      Top = 54
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
      TabOrder = 13
    end
    object DataEdit13: TZahlenEdit
      Tag = 13
      Left = 594
      Top = 54
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
      TabOrder = 14
    end
    object DataEdit14: TZahlenEdit
      Tag = 14
      Left = 640
      Top = 54
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
      TabOrder = 15
    end
    object DataEdit16: TZahlenEdit
      Tag = 16
      Left = 364
      Top = 78
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
      TabOrder = 17
    end
    object DataEdit17: TZahlenEdit
      Tag = 17
      Left = 410
      Top = 78
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
      TabOrder = 18
    end
    object DataEdit18: TZahlenEdit
      Tag = 18
      Left = 456
      Top = 78
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
      TabOrder = 19
    end
    object DataEdit19: TZahlenEdit
      Tag = 19
      Left = 502
      Top = 78
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
      TabOrder = 20
    end
    object DataEdit23: TZahlenEdit
      Tag = 23
      Left = 686
      Top = 78
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
      TabOrder = 24
    end
    object DataEdit20: TZahlenEdit
      Tag = 20
      Left = 548
      Top = 78
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
      TabOrder = 21
    end
    object DataEdit21: TZahlenEdit
      Tag = 21
      Left = 594
      Top = 78
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
      TabOrder = 22
    end
    object DataEdit22: TZahlenEdit
      Tag = 22
      Left = 640
      Top = 78
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
      TabOrder = 23
    end
    object DataEdit24: TZahlenEdit
      Tag = 24
      Left = 364
      Top = 102
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
      TabOrder = 25
    end
    object DataEdit25: TZahlenEdit
      Tag = 25
      Left = 410
      Top = 102
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
      TabOrder = 26
    end
    object DataEdit26: TZahlenEdit
      Tag = 26
      Left = 456
      Top = 102
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
      TabOrder = 27
    end
    object DataEdit27: TZahlenEdit
      Tag = 27
      Left = 502
      Top = 102
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
      TabOrder = 28
    end
    object DataEdit31: TZahlenEdit
      Tag = 31
      Left = 686
      Top = 102
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
      TabOrder = 32
    end
    object DataEdit28: TZahlenEdit
      Tag = 28
      Left = 548
      Top = 102
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
      TabOrder = 29
    end
    object DataEdit29: TZahlenEdit
      Tag = 29
      Left = 594
      Top = 102
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
      TabOrder = 30
    end
    object DataEdit30: TZahlenEdit
      Tag = 30
      Left = 640
      Top = 102
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
      TabOrder = 31
    end
    object DataEdit32: TZahlenEdit
      Tag = 32
      Left = 364
      Top = 126
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
      TabOrder = 33
    end
    object DataEdit33: TZahlenEdit
      Tag = 33
      Left = 410
      Top = 126
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
      TabOrder = 34
    end
    object DataEdit34: TZahlenEdit
      Tag = 34
      Left = 456
      Top = 126
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
      TabOrder = 35
    end
    object DataEdit35: TZahlenEdit
      Tag = 35
      Left = 502
      Top = 126
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
      TabOrder = 36
    end
    object DataEdit39: TZahlenEdit
      Tag = 39
      Left = 686
      Top = 126
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
      TabOrder = 40
    end
    object DataEdit36: TZahlenEdit
      Tag = 36
      Left = 548
      Top = 126
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
      TabOrder = 37
    end
    object DataEdit37: TZahlenEdit
      Tag = 37
      Left = 594
      Top = 126
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
      TabOrder = 38
    end
    object DataEdit38: TZahlenEdit
      Tag = 38
      Left = 640
      Top = 126
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
      TabOrder = 39
    end
    object DataEdit40: TZahlenEdit
      Tag = 40
      Left = 364
      Top = 150
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
      TabOrder = 41
    end
    object DataEdit41: TZahlenEdit
      Tag = 41
      Left = 410
      Top = 150
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
      TabOrder = 42
    end
    object DataEdit42: TZahlenEdit
      Tag = 42
      Left = 456
      Top = 150
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
      TabOrder = 43
    end
    object DataEdit43: TZahlenEdit
      Tag = 43
      Left = 502
      Top = 150
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
      TabOrder = 44
    end
    object DataEdit47: TZahlenEdit
      Tag = 47
      Left = 686
      Top = 150
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
      TabOrder = 48
    end
    object DataEdit44: TZahlenEdit
      Tag = 44
      Left = 548
      Top = 150
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
      TabOrder = 45
    end
    object DataEdit45: TZahlenEdit
      Tag = 45
      Left = 594
      Top = 150
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
      TabOrder = 46
    end
    object DataEdit46: TZahlenEdit
      Tag = 46
      Left = 640
      Top = 150
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
      TabOrder = 47
    end
    object DataEdit48: TZahlenEdit
      Tag = 48
      Left = 364
      Top = 174
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
      TabOrder = 49
    end
    object DataEdit49: TZahlenEdit
      Tag = 49
      Left = 410
      Top = 174
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
      TabOrder = 50
    end
    object DataEdit50: TZahlenEdit
      Tag = 50
      Left = 456
      Top = 174
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
      TabOrder = 51
    end
    object DataEdit51: TZahlenEdit
      Tag = 51
      Left = 502
      Top = 174
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
      TabOrder = 52
    end
    object DataEdit55: TZahlenEdit
      Tag = 55
      Left = 686
      Top = 174
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
      TabOrder = 56
    end
    object DataEdit52: TZahlenEdit
      Tag = 52
      Left = 548
      Top = 174
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
      TabOrder = 53
    end
    object DataEdit53: TZahlenEdit
      Tag = 53
      Left = 594
      Top = 174
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
      TabOrder = 54
    end
    object DataEdit54: TZahlenEdit
      Tag = 54
      Left = 640
      Top = 174
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
      TabOrder = 55
    end
    object DataEdit56: TZahlenEdit
      Tag = 56
      Left = 364
      Top = 198
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
      TabOrder = 57
    end
    object DataEdit57: TZahlenEdit
      Tag = 57
      Left = 410
      Top = 198
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
      TabOrder = 58
    end
    object DataEdit58: TZahlenEdit
      Tag = 58
      Left = 456
      Top = 198
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
      TabOrder = 59
    end
    object DataEdit59: TZahlenEdit
      Tag = 59
      Left = 502
      Top = 198
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
      TabOrder = 60
    end
    object DataEdit63: TZahlenEdit
      Tag = 63
      Left = 686
      Top = 198
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
      TabOrder = 64
    end
    object DataEdit60: TZahlenEdit
      Tag = 60
      Left = 548
      Top = 198
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
      TabOrder = 61
    end
    object DataEdit61: TZahlenEdit
      Tag = 61
      Left = 594
      Top = 198
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
      TabOrder = 62
    end
    object DataEdit62: TZahlenEdit
      Tag = 62
      Left = 640
      Top = 198
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
      TabOrder = 63
    end
    object DLCEdit: TComboBox
      Tag = 65
      Left = 232
      Top = 16
      Width = 73
      Height = 24
      ItemHeight = 16
      TabOrder = 74
      Text = '0'
      Items.Strings = (
        '0'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '12'
        '16'
        '20'
        '24'
        '32'
        '48'
        '64')
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
