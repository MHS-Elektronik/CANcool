�
 TSETUPFORM 0�  TPF0
TSetupForm	SetupFormLeft7Top�BorderIconsbiSystemMenu BorderStylebsDialogCaptionEinstellungenClientHeightClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder	PositionpoMainFormCenterPixelsPerInchn
TextHeight TPanelPanel1Left Top�Width�Height(AlignalBottom
BevelOuterbvNoneTabOrder  TButton
SetupOkBtnLeft� TopWidthYHeightCaptionOkModalResultTabOrder   TButtonSetupBreakBtnLeftXTopWidthYHeightCaption	AbbrechenModalResultTabOrder   TPageControlPageControl1Left Top Width�Height�
ActivePage	TabSheet2AlignalClientTabOrder 	TTabSheet	TabSheet2CaptionCAN TLabelNBTRStrLeftTop� Width1Height	AlignmenttaRightJustifyAutoSizeCaptionNBTRLayouttlCenter  TLabel
NBTRHexStrLeft� Top� Width)HeightAutoSizeCaption(Hex)LayouttlCenter  TLabel
DBTRHexStrLeft� Top0Width)HeightAutoSizeCaption(Hex)LayouttlCenter  TLabelDBTRStrLeftTop0Width1Height	AlignmenttaRightJustifyAutoSizeCaptionDBTRLayouttlCenter  TLabelNBTRBitrateStrLeft� Top� WidthAHeight	AlignmenttaRightJustifyAutoSizeBiDiModebdLeftToRightCaptionBitrateParentBiDiModeLayouttlCenter  TLabelDBTRBitrateStrLeft� Top0WidthAHeight	AlignmenttaRightJustifyAutoSizeBiDiModebdLeftToRightCaptionBitrateParentBiDiModeLayouttlCenter  TBevelBevel1LeftTop� Width�HeightShape	bsTopLineStylebsRaised  TRadioGroupCANSpeedEditLeftTop	Width�HeightpCaption Nominal Bitrate ColumnsItems.Strings	10 kBit/s	20 kBit/s	50 kBit/s
100 kBit/s
125 kBit/s
250 kBit/s
500 kBit/s
800 kBit/s1 MBit/sBenutzerdefiniert TabOrder OnClickCANSpeedEditClick  	TCheckBoxLomCheckBoxLeftTop�Width� HeightCaptionListen only ModeTabOrder  	TCheckBoxShowErrMsgCheckBoxLeft� TopxWidth� HeightCaptionCAN Fehler Nachrichten anzeigenTabOrder  	TCheckBoxCanFdCheckBoxLeftTopxWidth� HeightCaptionCAN-FD ModeColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclGreenFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold ParentColor
ParentFontTabOrderOnClickCanFdCheckBoxClick  TRadioGroupCANDataSpeedEditLeftTop� Width�HeightYCaptionData Bitrate (CAN-FD) ColumnsItems.Strings
250 kBit/s
500 kBit/s1 MBit/s
1,5 MBit/s2 MBit/s3 MBit/s4 MBit/sBenutzerdefiniert TabOrderOnClickCANDataSpeedEditClick  TButtonCustomNBTRSetupBtnLeft�Top� Width)HeightCaption...TabOrder  TButtonCustomDBTRSetupBtnLeft�Top0Width)HeightCaption...TabOrder  TEditNBTRDescEditLeftTop� Width�HeightTabOrder  TEditDBTRDescEditLeftTopPWidth�HeightTabOrder  TZahlen32EditNBTREditLeft@Top� WidthaHeightNumber ZahlenFormat	HexFormat	IdShowingBinModeZ32AutoModeHexModeZ32AutoMode
AutoFormatTabOrder	  TZahlen32EditDBTREditLeft@Top0WidthaHeightNumber ZahlenFormat	HexFormat	IdShowingBinModeZ32AutoModeHexModeZ32AutoMode
AutoFormatTabOrder
  TEditNBTRBitrateEditLeft Top� WidthaHeightTabOrder  TEditDBTRBitrateEditLeft Top0WidthaHeightTabOrder  	TCheckBoxCanFifoOvClearBoxLeft� Top�Width� HeightCaption    Fifo Überschreiben (Auto Clear)TabOrder  	TCheckBoxCanFifoOvMessagesBoxLeft� Top�Width� HeightCaptionReport Data LostTabOrder   	TTabSheet	TabSheet3Caption	CAN Trace TLabelLabel2LeftTopWidth`Height	AlignmenttaRightJustifyAutoSizeCaption   Puffergröße :LayouttlCenter  TLabelLabel3Left Top� WidthaHeightAutoSizeCaption(min 100000)  TLabelLabel5Left� Top� Width3Height	AlignmenttaRightJustifyAutoSizeCaptionLimit:LayouttlCenter  TLabelLabel6Left;Top� Width;Height	AlignmenttaCenterAutoSizeCaption.   Maximale Puffergröße = Puffergröße * Limit  TRadioGroupDataClearModeGrpLeft@Top	WidthHeightXCaption    Daten löschen ... 	ItemIndex Items.Stringsautomatischfragen   nicht löschen TabOrder   TLongIntEditRxDBufferSizeEditLeft� Top� WidthyHeightTabOrderText100000Number��   	TCheckBoxRxDEnableDynamicCheckBoxLeft
Top� Width� HeightCaptionDynamisch erweiternTabOrderOnClickRxDEnableDynamicCheckBoxClick  TLongIntEditRxDLimitEditLeft� Top� Width<HeightTabOrderText0Number    	TTabSheet	TabSheet1CaptionHardware TLabelLabel4Left TopQWidth~Height	AlignmenttaRightJustifyAutoSizeCaptionSerien-Nummer :LayouttlCenter  TLabelLabel1Left� TopWidthcHeight	AlignmenttaRightJustifyAutoSizeCaption
Baud Rate:LayouttlCenter  TRadioGroupPortEditLeft� TopEWidth� Height� Caption	 Port... Columns	ItemIndex Items.StringsCOM 1COM 2COM 3COM 4COM 5COM 6COM 7COM 8COM 9COM 10COM 11COM 12COM 13COM 14COM 15COM 16COM 17COM 18COM 19COM 20COM 21COM 22COM 23COM 24 TabOrder   TEditSnrEditLeft� TopQWidth� Height	MaxLength
TabOrder  TRadioGroupInterfaceTypeEditLeftTopEWidth� HeightFCaption Schnittstelle... Items.StringsUSBRS 232 TabOrderOnClickInterfaceTypeEditClick  	TComboBoxBaudRateEditLeft
TopWidth� HeightStylecsDropDownList
ItemHeightTabOrderItems.Strings48009600104001440019200288003840057600115200  12500015360023040025000046080050000092160010000003000000   TRadioGroup
DriverEditLeftTop
Width� Height2Caption Treiber... Columns	ItemIndex Items.StringsTiny-CANSL-CAN TabOrderOnClickDriverEditClick     