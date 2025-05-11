object HwInfoForm: THwInfoForm
  Left = 328
  Top = 1419
  Width = 729
  Height = 518
  BorderIcons = [biSystemMenu]
  BorderWidth = 5
  Caption = 'Hardware Info Variablen'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 110
  TextHeight = 16
  object InfoGridWdg: TStringGrid
    Left = 0
    Top = 0
    Width = 711
    Height = 410
    Align = alClient
    BorderStyle = bsNone
    Color = clBtnFace
    ColCount = 2
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    GridLineWidth = 0
    Options = []
    ParentFont = False
    TabOrder = 0
    ColWidths = (
      341
      347)
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 410
    Width = 711
    Height = 49
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      711
      49)
    object Button1: TButton
      Left = 596
      Top = 8
      Width = 107
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
