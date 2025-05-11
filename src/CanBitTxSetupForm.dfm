object CanBitTxSetupWin: TCanBitTxSetupWin
  Left = 847
  Top = 1435
  Width = 618
  Height = 588
  AutoSize = True
  BorderWidth = 3
  Caption = 'CAN Tx Bits Message'
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
    Left = 51
    Top = 72
    Width = 13
    Height = 16
    Caption = 'ID'
  end
  object Label9: TLabel
    Left = 26
    Top = 26
    Width = 37
    Height = 16
    Caption = 'Name'
  end
  object Bevel1: TBevel
    Left = 486
    Top = 205
    Width = 118
    Height = 7
    Shape = bsTopLine
  end
  object OKBtn: TBitBtn
    Left = 492
    Top = 14
    Width = 106
    Height = 31
    Caption = 'OK'
    TabOrder = 0
    OnClick = OKBtnClick
    NumGlyphs = 2
  end
  object AbbrechenBtn: TBitBtn
    Left = 492
    Top = 57
    Width = 104
    Height = 31
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 1
    NumGlyphs = 2
  end
  object NameEdit: TEdit
    Left = 70
    Top = 20
    Width = 192
    Height = 24
    TabOrder = 2
  end
  object LadenBtn: TBitBtn
    Left = 492
    Top = 113
    Width = 106
    Height = 30
    Caption = 'Laden'
    TabOrder = 3
    OnClick = LadenBtnClick
    NumGlyphs = 2
  end
  object SpeichernBtn: TBitBtn
    Left = 492
    Top = 156
    Width = 106
    Height = 30
    Caption = 'Speichern'
    TabOrder = 4
    OnClick = SpeichernBtnClick
    NumGlyphs = 2
  end
  object BitNameGrid: TStringGrid
    Left = 8
    Top = 104
    Width = 454
    Height = 427
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
    Left = 492
    Top = 223
    Width = 106
    Height = 31
    Caption = 'Hinzuf'#252'gen'
    TabOrder = 6
    OnClick = HinzufuegenBtnClick
    NumGlyphs = 2
  end
  object EntfernenBtn: TBitBtn
    Left = 492
    Top = 266
    Width = 106
    Height = 31
    Caption = 'Entfernen'
    TabOrder = 7
    OnClick = EntfernenBtnClick
    NumGlyphs = 2
  end
  object BitComboBox: TComboBox
    Left = 476
    Top = 438
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
    Left = 478
    Top = 470
    Width = 109
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 9
    OnExit = ColorBoxExit
  end
  object CanIdEdit: TZahlen32Edit
    Left = 71
    Top = 68
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
  object AutoTxCheckBox: TCheckBox
    Left = 280
    Top = 24
    Width = 145
    Height = 17
    Caption = 'Auto Transmit'
    TabOrder = 11
  end
  object ShowTxBtnCheckBox: TCheckBox
    Left = 280
    Top = 64
    Width = 137
    Height = 17
    Caption = 'Transmit Button'
    TabOrder = 12
  end
  object FdBitComboBox: TComboBox
    Left = 476
    Top = 406
    Width = 61
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 13
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
