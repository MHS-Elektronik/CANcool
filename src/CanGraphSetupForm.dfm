object CanGraphSetupWin: TCanGraphSetupWin
  Left = 1116
  Top = 1538
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 3
  Caption = 'Instrumenten Konfiguration'
  ClientHeight = 393
  ClientWidth = 580
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 110
  TextHeight = 16
  object RahmenBevel: TBevel
    Left = 0
    Top = 2
    Width = 464
    Height = 391
    Style = bsRaised
  end
  object CanIdStartLabel: TLabel
    Left = 66
    Top = 49
    Width = 13
    Height = 16
    Alignment = taRightJustify
    Caption = 'ID'
  end
  object Label9: TLabel
    Left = 18
    Top = 12
    Width = 37
    Height = 16
    Caption = 'Name'
  end
  object Label7: TLabel
    Left = 14
    Top = 95
    Width = 84
    Height = 16
    Caption = 'Frame Format'
  end
  object Label2: TLabel
    Left = 16
    Top = 122
    Width = 60
    Height = 16
    Caption = 'CAN - Fd: '
  end
  object Label1: TLabel
    Left = 16
    Top = 336
    Width = 59
    Height = 16
    Caption = 'Min Value'
  end
  object Label3: TLabel
    Left = 280
    Top = 336
    Width = 63
    Height = 16
    Caption = 'Max Value'
  end
  object Label5: TLabel
    Left = 16
    Top = 368
    Width = 85
    Height = 16
    Caption = 'Max Samples:'
  end
  object Label8: TLabel
    Left = 8
    Top = 304
    Width = 115
    Height = 16
    Caption = 'Berechnungs-Term'
  end
  object OKBtn: TBitBtn
    Left = 474
    Top = 0
    Width = 106
    Height = 31
    Caption = 'OK'
    TabOrder = 1
    OnClick = OKBtnClick
    NumGlyphs = 2
  end
  object AbbrechenBtn: TBitBtn
    Left = 474
    Top = 43
    Width = 104
    Height = 31
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
    NumGlyphs = 2
  end
  object NameEdit: TEdit
    Left = 62
    Top = 6
    Width = 219
    Height = 24
    TabOrder = 0
  end
  object LadenBtn: TBitBtn
    Left = 474
    Top = 99
    Width = 106
    Height = 30
    Caption = 'Laden'
    TabOrder = 3
    OnClick = LadenBtnClick
    NumGlyphs = 2
  end
  object SpeichernBtn: TBitBtn
    Left = 474
    Top = 142
    Width = 106
    Height = 30
    Caption = 'Speichern'
    TabOrder = 4
    OnClick = SpeichernBtnClick
    NumGlyphs = 2
  end
  object CanIdEdit: TZahlen32Edit
    Left = 83
    Top = 42
    Width = 90
    Height = 24
    Number = 0
    ZahlenFormat = HexFormat
    IdShowing = False
    BinMode = Z32AutoMode
    HexMode = Z32AutoMode
    AutoFormat = False
    TabOrder = 5
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 156
    Width = 444
    Height = 125
    Caption = 'MUX'
    TabOrder = 6
    object Label4: TLabel
      Left = 14
      Top = 69
      Width = 41
      Height = 16
      Alignment = taRightJustify
      Caption = 'Maske'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 167
      Top = 30
      Width = 26
      Height = 16
      Caption = 'DLC'
    end
    object Label11: TLabel
      Left = 19
      Top = 98
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
    object DLCEdit: TZahlenEdit
      Tag = 1
      Left = 198
      Top = 20
      Width = 30
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
      TabOrder = 0
    end
    object Mask7Edit: TZahlenEdit
      Tag = 8
      Left = 337
      Top = 59
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
      TabOrder = 1
    end
    object Mask8Edit: TZahlenEdit
      Tag = 9
      Left = 384
      Top = 59
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
      TabOrder = 2
    end
    object Mask6Edit: TZahlenEdit
      Tag = 7
      Left = 290
      Top = 59
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
    object Mask5Edit: TZahlenEdit
      Tag = 6
      Left = 244
      Top = 59
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
    object Mask4Edit: TZahlenEdit
      Tag = 5
      Left = 198
      Top = 59
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
    object Mask3Edit: TZahlenEdit
      Tag = 4
      Left = 151
      Top = 59
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
      TabOrder = 6
    end
    object Mask2Edit: TZahlenEdit
      Tag = 3
      Left = 105
      Top = 59
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
    object Mask1Edit: TZahlenEdit
      Tag = 2
      Left = 59
      Top = 59
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
    object Data8Edit: TZahlenEdit
      Tag = 9
      Left = 384
      Top = 89
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
      TabOrder = 9
    end
    object Data7Edit: TZahlenEdit
      Tag = 8
      Left = 337
      Top = 89
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
      TabOrder = 10
    end
    object Data6Edit: TZahlenEdit
      Tag = 7
      Left = 290
      Top = 89
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
      TabOrder = 11
    end
    object Data5Edit: TZahlenEdit
      Tag = 6
      Left = 244
      Top = 89
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
    object Data4Edit: TZahlenEdit
      Tag = 5
      Left = 198
      Top = 89
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
      TabOrder = 13
    end
    object Data3Edit: TZahlenEdit
      Tag = 4
      Left = 151
      Top = 89
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
      TabOrder = 14
    end
    object Data2Edit: TZahlenEdit
      Tag = 3
      Left = 105
      Top = 89
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
    object Data1Edit: TZahlenEdit
      Tag = 2
      Left = 59
      Top = 89
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
      TabOrder = 16
    end
    object MuxEnabledCheck: TCheckBox
      Left = 10
      Top = 30
      Width = 119
      Height = 20
      Caption = 'Aktivieren'
      TabOrder = 17
    end
  end
  object FrameFormatEdit: TComboBox
    Left = 112
    Top = 90
    Width = 145
    Height = 24
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 7
    Text = 'Alle Frames'
    Items.Strings = (
      'Alle Frames'
      'Std.-Frames'
      'Ext.-Frames')
  end
  object CanFdEdit: TComboBox
    Left = 112
    Top = 122
    Width = 145
    Height = 24
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 8
    Text = 'Alle Frames'
    Items.Strings = (
      'Alle Frames'
      'Nur Classical Frames'
      'Nur CAN-FD Frames'
      'Nur CAN-FD Frames (BRS unset)'
      'Nur CAN-FD Frames (BRS set)'
      '')
  end
  object MinValueEdit: TLongIntEdit
    Left = 96
    Top = 328
    Width = 97
    Height = 24
    TabOrder = 9
    Text = '0'
    Number = 0
  end
  object MaxValueEdit: TLongIntEdit
    Left = 360
    Top = 328
    Width = 97
    Height = 24
    TabOrder = 10
    Text = '0'
    Number = 0
  end
  object GraphValuesLimitEdit: TLongIntEdit
    Left = 104
    Top = 360
    Width = 121
    Height = 24
    TabOrder = 11
    Text = '0'
    Number = 0
  end
  object BerechnungsTermEdit: TEdit
    Left = 136
    Top = 296
    Width = 321
    Height = 24
    TabOrder = 12
  end
end
