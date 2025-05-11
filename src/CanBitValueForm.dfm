inherited CanBitValueWin: TCanBitValueWin
  Left = 1229
  Top = 1763
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Bit Indikator'
  ClientHeight = 38
  ClientWidth = 262
  OldCreateOrder = True
  PopupMenu = BitIndikMenu
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = nil
  PixelsPerInch = 110
  TextHeight = 16
  object BitIndikMenu: TPopupMenu
    object ConfigBtn: TMenuItem
      Caption = 'Konfiguration'
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
