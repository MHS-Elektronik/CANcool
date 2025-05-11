inherited CanGaugeWin: TCanGaugeWin
  Left = 2311
  Top = 1204
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Analog Instrument'
  ClientHeight = 502
  ClientWidth = 505
  Color = clWhite
  Constraints.MinHeight = 150
  Constraints.MinWidth = 150
  OldCreateOrder = True
  PopupMenu = AnalogInstMenu
  OnResize = FormResize
  PixelsPerInch = 110
  TextHeight = 16
  object Gauge: TA3nalogGauge
    Left = 0
    Top = 0
    Width = 492
    Height = 492
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    MinColor = clGreen
    MidColor = clYellow
    MaxColor = clRed
    FaceColor = clWhite
    TicksColor = clBlack
    ValueColor = clBlack
    CaptionColor = clBlack
    ArrowColor = clBlack
    MarginColor = clBlack
    CenterColor = clGray
    CircleColor = clBlue
    CenterRadius = 8
    CircleRadius = 3
    Angle = 270
    Margin = 7
    Style = CenterStyle
    ArrowWidth = 2
    TicksWidth = 1
    NumberMainTicks = 10
    NumberSubTicks = 5
    LengthMainTicks = 17
    LengthSubTicks = 8
    FaceOptions = [ShowMainTicks, ShowSubTicks, ShowIndicatorMin, ShowIndicatorMid, ShowIndicatorMax, ShowValues, ShowCenter, Show3D, ShowCaption]
    ScaleMin = 0
    ScaleMax = 140
    IndMaximum = 80
    IndMinimum = 10
    Caption = 'mV'
    AntiAliased = aaTriline
  end
  object AnalogInstMenu: TPopupMenu
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
