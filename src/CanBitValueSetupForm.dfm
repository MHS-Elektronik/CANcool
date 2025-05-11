object CanBitValueSetupWin: TCanBitValueSetupWin
  Left = 1474
  Top = 1440
  Width = 610
  Height = 588
  AutoSize = True
  BorderWidth = 3
  Caption = 'Bit Indikator Konfiguration'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 110
  TextHeight = 16
  object RahmenBevel: TBevel
    Left = 0
    Top = 0
    Width = 464
    Height = 533
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 43
    Top = 55
    Width = 13
    Height = 16
    Caption = 'ID'
  end
  object Label9: TLabel
    Left = 18
    Top = 18
    Width = 37
    Height = 16
    Caption = 'Name'
  end
  object Bevel1: TBevel
    Left = 478
    Top = 197
    Width = 118
    Height = 7
    Shape = bsTopLine
  end
  object Label3: TLabel
    Left = 12
    Top = 234
    Width = 33
    Height = 16
    Caption = 'LEDs'
  end
  object OKBtn: TBitBtn
    Left = 484
    Top = 6
    Width = 106
    Height = 31
    Caption = 'OK'
    TabOrder = 0
    OnClick = OKBtnClick
    NumGlyphs = 2
  end
  object AbbrechenBtn: TBitBtn
    Left = 484
    Top = 49
    Width = 104
    Height = 31
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 1
    NumGlyphs = 2
  end
  object NameEdit: TEdit
    Left = 62
    Top = 12
    Width = 192
    Height = 24
    TabOrder = 2
  end
  object LadenBtn: TBitBtn
    Left = 484
    Top = 105
    Width = 106
    Height = 30
    Caption = 'Laden'
    TabOrder = 3
    OnClick = LadenBtnClick
    NumGlyphs = 2
  end
  object SpeichernBtn: TBitBtn
    Left = 484
    Top = 148
    Width = 106
    Height = 30
    Caption = 'Speichern'
    TabOrder = 4
    OnClick = SpeichernBtnClick
    NumGlyphs = 2
  end
  object BitNameGrid: TStringGrid
    Left = 12
    Top = 256
    Width = 442
    Height = 267
    ColCount = 4
    DefaultColWidth = 48
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 5
    OnDrawCell = BitNameGridDrawCell
    OnGetEditText = BitNameGridGetEditText
    OnSelectCell = BitNameGridSelectCell
    OnSetEditText = BitNameGridSetEditText
    ColWidths = (
      48
      48
      48
      48)
  end
  object HinzufuegenBtn: TBitBtn
    Left = 484
    Top = 215
    Width = 106
    Height = 31
    Caption = 'Hinzuf'#252'gen'
    TabOrder = 6
    OnClick = HinzufuegenBtnClick
    NumGlyphs = 2
  end
  object EntfernenBtn: TBitBtn
    Left = 484
    Top = 258
    Width = 106
    Height = 31
    Caption = 'Entfernen'
    TabOrder = 7
    OnClick = EntfernenBtnClick
    NumGlyphs = 2
  end
  object BitComboBox: TComboBox
    Left = 388
    Top = 14
    Width = 49
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 8
    Text = '0'
    OnExit = ComboBoxExit
    Items.Strings = (
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7')
  end
  object ColorBox: TColorBox
    Left = 270
    Top = 14
    Width = 109
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 9
    OnExit = ColorBoxExit
  end
  object CanIdEdit: TZahlen32Edit
    Left = 63
    Top = 48
    Width = 90
    Height = 24
    Number = 0
    ZahlenFormat = HexFormat
    IdShowing = False
    BinMode = Z32AutoMode
    HexMode = Z32AutoMode
    AutoFormat = False
    TabOrder = 10
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 89
    Width = 444
    Height = 129
    Caption = 'MUX'
    TabOrder = 11
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
  object FdBitComboBox: TComboBox
    Left = 388
    Top = 46
    Width = 61
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 12
    OnExit = ComboBoxExit
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
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16'
      '17'
      '18'
      '19'
      '20'
      '21'
      '22'
      '23'
      '24'
      '25'
      '26'
      '27'
      '28'
      '29'
      '30'
      '31'
      '32'
      '33'
      '34'
      '35'
      '36'
      '37'
      '38'
      '39'
      '40'
      '41'
      '42'
      '43'
      '44'
      '45'
      '46'
      '47'
      '48'
      '49'
      '50'
      '51'
      '52'
      '53'
      '54'
      '55'
      '56'
      '57'
      '58'
      '59'
      '60'
      '61'
      '62'
      '63')
  end
end
