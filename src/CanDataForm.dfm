object CanDataWin: TCanDataWin
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
    Height = 247
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
    PopupMenu = CanDataMenu
    ShowHint = True
    TabOrder = 0
    OnDrawCell = RxViewDrawCell
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CAN-Log (*.csv)|*.csv|Alle Dateien (*.*)|*.*'
    Title = 'CAN Trace speichern'
    Left = 344
    Top = 8
  end
  object CanDataMenu: TPopupMenu
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
