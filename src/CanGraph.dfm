inherited CanGraphWin: TCanGraphWin
  Left = 278
  Top = 1342
  BorderStyle = bsSingle
  Caption = 'Oszillogramm'
  ClientHeight = 312
  ClientWidth = 719
  OldCreateOrder = True
  PopupMenu = CanGraphMenu
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 110
  TextHeight = 16
  object GraphFrame: TBevel
    Left = 6
    Top = 8
    Width = 707
    Height = 297
  end
  object CanGraphMenu: TPopupMenu
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
