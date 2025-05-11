inherited CanBitTxWin: TCanBitTxWin
  Left = 1241
  Top = 1620
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Tx Bits'
  ClientHeight = 81
  ClientWidth = 239
  OldCreateOrder = True
  PopupMenu = BitIndikMenu
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = nil
  PixelsPerInch = 110
  TextHeight = 16
  object ButtonPanel: TPanel
    Left = 0
    Top = 40
    Width = 239
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    DesignSize = (
      239
      41)
    object TxBtn: TButton
      Left = 10
      Top = 5
      Width = 217
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      BiDiMode = bdRightToLeft
      Caption = 'Senden'
      ParentBiDiMode = False
      TabOrder = 0
      OnClick = TxBtnClick
    end
  end
  object BitIndikMenu: TPopupMenu
    object ConfigBtn: TMenuItem
      Caption = 'Konfiguration'
      OnClick = ConfigBtnClick
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
