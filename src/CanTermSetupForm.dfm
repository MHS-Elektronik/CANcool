object CanTermSetupWin: TCanTermSetupWin
  Left = 866
  Top = 1378
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 3
  Caption = 'Instrumenten Konfiguration'
  ClientHeight = 545
  ClientWidth = 556
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 110
  TextHeight = 16
  object RahmenBevel: TBevel
    Left = 0
    Top = 0
    Width = 433
    Height = 545
    Style = bsRaised
  end
  object Label9: TLabel
    Left = 10
    Top = 18
    Width = 37
    Height = 16
    Caption = 'Name'
  end
  object Label13: TLabel
    Left = 8
    Top = 448
    Width = 36
    Height = 16
    Caption = 'Schrift'
  end
  object Label3: TLabel
    Left = 16
    Top = 282
    Width = 37
    Height = 16
    Caption = 'Zeilen'
  end
  object Label4: TLabel
    Left = 168
    Top = 282
    Width = 46
    Height = 16
    Caption = 'Spalten'
  end
  object OKBtn: TBitBtn
    Left = 450
    Top = 6
    Width = 106
    Height = 31
    Caption = 'OK'
    TabOrder = 1
    OnClick = OKBtnClick
    NumGlyphs = 2
  end
  object AbbrechenBtn: TBitBtn
    Left = 450
    Top = 49
    Width = 104
    Height = 31
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
    NumGlyphs = 2
  end
  object NameEdit: TEdit
    Left = 54
    Top = 12
    Width = 347
    Height = 24
    TabOrder = 0
  end
  object LadenBtn: TBitBtn
    Left = 450
    Top = 105
    Width = 106
    Height = 30
    Caption = 'Laden'
    TabOrder = 3
    OnClick = LadenBtnClick
    NumGlyphs = 2
  end
  object SpeichernBtn: TBitBtn
    Left = 450
    Top = 148
    Width = 106
    Height = 30
    Caption = 'Speichern'
    TabOrder = 4
    OnClick = SpeichernBtnClick
    NumGlyphs = 2
  end
  object FontChangeBtn: TButton
    Left = 64
    Top = 440
    Width = 123
    Height = 25
    Caption = #196'ndern...'
    TabOrder = 5
    OnClick = FontChangeBtnClick
  end
  object Panel2: TPanel
    Left = 8
    Top = 472
    Width = 417
    Height = 65
    BevelOuter = bvLowered
    TabOrder = 6
    object FontLabel: TLabel
      Left = 8
      Top = 8
      Width = 401
      Height = 49
      AutoSize = False
      Caption = '...'
    end
  end
  object AutoCRCheckBox: TCheckBox
    Left = 9
    Top = 319
    Width = 120
    Height = 19
    Caption = 'AutoCR'
    TabOrder = 7
  end
  object AutoLFCheckBox: TCheckBox
    Left = 9
    Top = 347
    Width = 120
    Height = 20
    Caption = 'AutoLF'
    TabOrder = 8
  end
  object LocalEchoCheckBox: TCheckBox
    Left = 9
    Top = 376
    Width = 120
    Height = 19
    Caption = 'Local Echo'
    TabOrder = 9
  end
  object MonoChromeCheckBox: TCheckBox
    Left = 241
    Top = 319
    Width = 120
    Height = 19
    Caption = 'Monochrome'
    TabOrder = 10
  end
  object XlatCheckBox: TCheckBox
    Left = 9
    Top = 401
    Width = 120
    Height = 20
    Caption = 'OEM charset'
    TabOrder = 11
  end
  object GraphicDrawCheckBox: TCheckBox
    Left = 241
    Top = 347
    Width = 125
    Height = 20
    Caption = 'Graphic Draw'
    TabOrder = 12
  end
  object GroupBox1: TGroupBox
    Left = 217
    Top = 401
    Width = 202
    Height = 56
    Caption = 'Function &Keys'
    TabOrder = 13
    object FKeys1RadioButton: TRadioButton
      Left = 9
      Top = 27
      Width = 56
      Height = 20
      Caption = 'SCO'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object FKeys2RadioButton: TRadioButton
      Left = 73
      Top = 27
      Width = 74
      Height = 20
      Caption = 'VT100'
      TabOrder = 1
    end
    object FKeys3RadioButton: TRadioButton
      Left = 146
      Top = 27
      Width = 47
      Height = 20
      Caption = 'A11'
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 48
    Width = 385
    Height = 65
    Caption = ' Empfangen '
    TabOrder = 14
    object Label1: TLabel
      Left = 18
      Top = 33
      Width = 33
      Height = 16
      Caption = 'Rx-ID'
    end
    object RxCanIdEdit: TZahlen32Edit
      Left = 59
      Top = 25
      Width = 90
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      BinMode = Z32AutoMode
      HexMode = Z32AutoMode
      AutoFormat = False
      TabOrder = 0
    end
    object RxEffCheckBox: TCheckBox
      Left = 168
      Top = 32
      Width = 161
      Height = 17
      Caption = 'EFF Frames'
      TabOrder = 1
    end
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 128
    Width = 385
    Height = 129
    Caption = ' Senden '
    TabOrder = 15
    object Label2: TLabel
      Left = 18
      Top = 57
      Width = 32
      Height = 16
      Caption = 'Tx-ID'
    end
    object TxCanIdEdit: TZahlen32Edit
      Left = 59
      Top = 49
      Width = 90
      Height = 24
      Number = 0
      ZahlenFormat = HexFormat
      IdShowing = False
      BinMode = Z32AutoMode
      HexMode = Z32AutoMode
      AutoFormat = False
      TabOrder = 0
    end
    object TxEffCheckBox: TCheckBox
      Left = 168
      Top = 24
      Width = 161
      Height = 17
      Caption = 'EFF Frames'
      TabOrder = 1
    end
    object TxEnableCheckBox: TCheckBox
      Left = 16
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Enable'
      TabOrder = 2
    end
    object TxBrsCheckBox: TCheckBox
      Left = 168
      Top = 72
      Width = 97
      Height = 17
      Caption = 'BRS Set'
      TabOrder = 3
    end
    object TxFdCheckBox: TCheckBox
      Left = 168
      Top = 48
      Width = 97
      Height = 17
      Caption = 'FD Frames'
      TabOrder = 4
    end
    object TxOnReturnCheckBox: TCheckBox
      Left = 16
      Top = 96
      Width = 129
      Height = 17
      Caption = 'Tx on Return'
      TabOrder = 5
    end
  end
  object RowsEdit: TEdit
    Left = 73
    Top = 278
    Width = 56
    Height = 24
    TabOrder = 16
    Text = '25'
  end
  object ColsEdit: TEdit
    Left = 225
    Top = 278
    Width = 56
    Height = 24
    TabOrder = 17
    Text = '80'
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [fdAnsiOnly, fdFixedPitchOnly]
    Left = 496
    Top = 200
  end
end
