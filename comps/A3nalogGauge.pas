unit A3nalogGauge;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$DEFINE TICKER}
interface

uses
{$IFnDEF FPC}
  Messages, WinProcs, WinTypes,
{$ELSE}
  LResources, LCLIntf, LCLType,
{$ENDIF}
  Windows, SysUtils, Classes, Graphics, Controls;

type
  TStyle = (LeftStyle, RightStyle, CenterStyle);
  TFaceOption = (ShowMargin, ShowCircles, ShowMainTicks, ShowSubTicks,
                    ShowIndicatorMin, ShowIndicatorMid, ShowIndicatorMax,
                    ShowValues, ShowCenter, ShowFrame, Show3D, ShowCaption);
  TFaceOptions = set of TFaceOption;
  TAntialiased = (aaNone, aaBiline, aaTriline, aaQuadral);

  TA3nalogGauge = class(TCustomControl)
  private
    // face elements colors
    FMinColor: TColor;
    FMidColor: TColor;
    FMaxColor: TColor;
    FFaceColor: TColor;
    FTicksColor: TColor;
    FValueColor: TColor;
    FCaptionColor: TColor;
    FArrowColor: TColor;
    FMarginColor: TColor;
    FCenterColor: TColor;
    FCircleColor: TColor;
    // face elements sizes, etc.
    FCenterRadius: Integer;
    FCircleRadius: Integer;
    FScaleAngle: Integer;
    FMargin: Integer;
    FStyle: TStyle;
    FArrowWidth: Integer;
    FTicksWidth: Integer;
    FNumMainTicks: Integer;
    FNumSubTicks: Integer;
    FLengthMainTicks: Integer;
    FLengthSubTicks: Integer;
    FFaceOptions: TFaceOptions;
    // values
    FPosition: Single;
    //FScaleValue: Integer;
    FScaleMin: Integer;
    FScaleMax: Integer;
    FMinimum: Integer;
    FMaximum: Integer;
    FIndicatorWidth: Integer;
    FCaption: string;
    // event handlers
    FOverMax: TNotifyEvent;
    FOverMin: TNotifyEvent;
    // anti-aliasing mode
    FAntiAliased: TAntialiased;
    // internal bitmaps
    FBackBitmap: TBitmap;
    FFaceBitmap: TBitmap;
    FAABitmap: TBitmap;
{$IFDEF TICKER}
    // performance tracking
    FTicker: Int64;
    FPeriod: Int64;
    FFrames: Integer;
    FOnFrames: TNotifyEvent;
{$ENDIF}
    // set properties
    procedure SetFMinColor(C: TColor);
    procedure SetFMidColor(C: TColor);
    procedure SetFMaxColor(C: TColor);
    procedure SetFFaceColor(C: TColor);
    procedure SetFTicksColor(C: TColor);
    procedure SetFValueColor(C: TColor);
    procedure SetFCaptionColor(C: TColor);
    procedure SetFArrowColor(C: TColor);
    procedure SetFMarginColor(C: TColor);
    procedure SetFCenterColor(C: TColor);
    procedure SetFCircleColor(C: TColor);
    procedure SetFCenterRadius(I: Integer);
    procedure SetFCircleRadius(I: Integer);
    procedure SetFScaleAngle(I: Integer);
    procedure SetFMargin(I: Integer);
    procedure SetFStyle(S: TStyle);
    procedure SetFArrowWidth(I: Integer);
    procedure SetFTicksWidth(I: Integer);
    procedure SetFNumMainTicks(I: Integer);
    procedure SetFNumSubTicks(I: Integer);
    procedure SetFLengthMainTicks(I: Integer);
    procedure SetFLengthSubTicks(I: Integer);
    procedure SetFFaceOptions(O: TFaceOptions);
    procedure SetFPosition(V: Single);
    //procedure SetFScaleValue(I: Integer);
    procedure SetFScaleMin(I: Integer);
    procedure SetFScaleMax(I: Integer);
    procedure SetFMaximum(I: Integer);
    procedure SetFMinimum(I: Integer);
    procedure SetFIndicatorWidth(I: Integer);
    procedure SetFCaption(const S: string);
    procedure SetFAntiAliased(V: TAntialiased);
    function GetAAMultipler: Integer;
  protected
    procedure DrawScale(Bitmap: TBitmap; K: Integer);
    procedure DrawArrow(Bitmap: TBitmap; K: Integer);
    procedure RedrawScale;
    procedure RedrawArrow;
    procedure FastAntiAliasPicture;
    procedure Paint; override;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMFontChanged(var Msg: TMessage); message CM_FontChanged;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Font;
    property MinColor: TColor read FMinColor write SetFMinColor;
    property MidColor: TColor read FMidColor write SetFMidColor;
    property MaxColor: TColor read FMaxColor write SetFMaxColor;
    property FaceColor: TColor read FFaceColor write SetFFaceColor;
    property TicksColor: TColor read FTicksColor write SetFTicksColor;
    property ValueColor: TColor read FValueColor write SetFValueColor;
    property CaptionColor: TColor read FCaptionColor write SetFCaptionColor;
    property ArrowColor: TColor read FArrowColor write SetFArrowColor;
    property MarginColor: TColor read FMarginColor write SetFMarginColor;
    property CenterColor: TColor read FCenterColor write SetFCenterColor;
    property CircleColor: TColor read FCircleColor write SetFCircleColor;
    property CenterRadius: Integer read FCenterRadius write SetFCenterRadius;
    property CircleRadius: Integer read FCircleRadius write SetFCircleRadius;
    property Angle: Integer read FScaleAngle write SetFScaleAngle;
    property Margin: Integer read FMargin write SetFMargin;
    property Style: TStyle read FStyle write SetFStyle;
    property ArrowWidth: Integer read FArrowWidth write SetFArrowWidth;
    property TicksWidth: Integer read FTicksWidth write SetFTicksWidth;
    property NumberMainTicks: Integer read FNumMainTicks write SetFNumMainTicks;
    property NumberSubTicks: Integer read FNumSubTicks write SetFNumSubTicks;
    property LengthMainTicks: Integer read FLengthMainTicks write SetFLengthMainTicks;
    property LengthSubTicks: Integer read FLengthSubTicks write SetFLengthSubTicks;
    property FaceOptions: TFaceOptions read FFaceOptions write SetFFaceOptions;
    property Position: Single read FPosition write SetFPosition;
    //property Scale: Integer read FScaleValue write SetFScaleValue;
    property ScaleMin: Integer read FScaleMin write SetFScaleMin;
    property ScaleMax: Integer read FScaleMax write SetFScaleMax;
    property IndMaximum: Integer read FMaximum write SetFMaximum;
    property IndMinimum: Integer read FMinimum write SetFMinimum;
    property IndicatorWidth: Integer read FIndicatorWidth write SetFIndicatorWidth default 4;
    property Caption: string read FCaption write SetFCaption;
    property AntiAliased: TAntialiased read FAntiAliased write SetFAntiAliased;
    property OnOverMax: TNotifyEvent read FOverMax write FOverMax;
    property OnOverMin: TNotifyEvent read FOverMin write FOverMin;
{$IFDEF TICKER}
    property OnFrames: TNotifyEvent read FOnFrames write FOnFrames;
    property Frames: Integer read FFrames;
{$ENDIF}
  end;

procedure Register;

implementation
{ ========================================================================= }
constructor TA3nalogGauge.Create(AOwner: TComponent);
begin
  inherited;
  FBackBitmap := TBitmap.Create; FFaceBitmap := TBitmap.Create; FAABitmap := nil;
  //*****************************defaults:****************************************
  Width := 225;                   Height := 180;
  FBackBitmap.Width := Width; FBackBitmap.Height := Height;
  FFaceBitmap.Width := Width;     FFaceBitmap.Height := Height;
  FBackBitmap.Canvas.Brush.Style := bsClear;
  FBackBitmap.Canvas.Brush.Color := Self.Color;
  FFaceColor := clBtnFace; FTicksColor := clBlack; FValueColor := clBlack;
  FCaptionColor := clBlack; FArrowColor := clBlack; FMarginColor := clBlack;
  FCenterColor := clDkGray; FCircleColor := clBlue; FMinColor := clGreen;
  FMidColor := clYellow; FMaxColor := clRed;
  FArrowWidth := 1; FTicksWidth := 1; FPosition := 0; FMargin := 10;  FStyle := CenterStyle;
  FScaleMin := 0; FScaleMax := 140;
  FMaximum := 80; FMinimum := 30; FScaleAngle := 120;
  FIndicatorWidth := 4;
  FCircleRadius := 3; FCenterRadius := 8; FNumMainTicks := 7; FNumSubTicks := 5;
  FLengthMainTicks := 15; FLengthSubTicks := 8; FCaption := 'mV';
  FFaceOptions := [ShowMargin, ShowMainTicks, ShowSubTicks, ShowIndicatorMax,
                   ShowValues, ShowCenter, ShowFrame, Show3D, ShowCaption];
  FAntiAliased := aaNone;
{$IFDEF TICKER}
  FTicker := -1; FFrames := 0;
  if not QueryPerformanceFrequency(FPeriod) then FPeriod := 0;
{$ENDIF}
end;

destructor TA3nalogGauge.Destroy;
begin
  FBackBitmap.Free;
  FFaceBitmap.Free;
  FAABitmap.Free;
  inherited;
end;
{ ------------------------------------------------------------------------- }
procedure SetPenStyles(Pen: TPen; Width: Integer; Color: TColor);
var
  HP: HPen;
  LB: TLOGBRUSH;
begin
  LB.lbStyle := BS_SOLID; LB.lbColor := Color; LB.lbHatch := 0;
  HP := ExtCreatePen(PS_GEOMETRIC or PS_SOLID or PS_ENDCAP_FLAT or
                     PS_JOIN_ROUND, Width, LB, 0, nil);
  if HP = 0 then begin Pen.Width := Width; Pen.Color := Color end
            else Pen.Handle := HP;
end;

procedure TA3nalogGauge.DrawScale(Bitmap: TBitmap; K: Integer);
var
  I, J, X, Y, N, M, W, H, R: Integer;
  Max, Min, ScaleValue: Int64;
  A, C: Single;
  str: String;
begin
  Bitmap.Canvas.Font := Font;
  W := Bitmap.Width; H := Bitmap.Height;
  N := FNumMainTicks*FNumSubTicks; M := FMargin * K; R := FCircleRadius * K;
  with Bitmap do begin
    Canvas.Brush.Color := FFaceColor;
    Canvas.FillRect(Canvas.ClipRect);
    Canvas.Font.Height := Canvas.Font.Height * K;
    // ***************************** Out Frame **************************
    if ShowFrame in fFaceOptions then begin
      if Show3D in fFaceOptions then begin
        Canvas.Pen.Width := 2*K;
        Canvas.Pen.Color := clBtnShadow;
        Canvas.MoveTo(W, 0); Canvas.LineTo(0, 0); Canvas.LineTo(0, H);
        Canvas.Pen.Color := clBtnHighlight;
        Canvas.LineTo(W, H); Canvas.LineTo(W, 0);
      end else begin
        Canvas.Pen.Width := K;
        Canvas.Pen.Color := clBtnText;
        Canvas.Rectangle(0, 0, W, H);
      end;
    end;
    //************************* Out Margins **************************
    if ShowMargin in fFaceOptions then begin
      Canvas.Pen.Color := FMarginColor; Canvas.Pen.Width := K;
      Canvas.Rectangle(M, M, W - M, H - M);
    end;
    //****************************************************************
    case fStyle of
      RightStyle: begin
        A := 0; C := W - M; X := W - M; Y := H - M;
        if fScaleAngle > 90 then fScaleAngle := 90; J := W - 2*M;
      end;
      LeftStyle:begin
        A := 90; C := M; X := M; Y := H - M;
        if fScaleAngle > 90 then fScaleAngle := 90; J := W - 2*M;
      end;
      else begin
        X := W div 2; A := (180 - fScaleAngle)/2; C := W/2;
        if fScaleAngle >= 180 then begin
          J := (W - 2*M) div 2;
          Y := H div 2;
        end else begin
          J := Round(((W - 2*M)/2)/Cos(A*2*pi/360));
          if J > H - 2*M then J := H - 2*M;
          Y := (H - J) div 2 + J;
        end;
      end;
    end;{case}

{    // ************************************ base formula **********************************************
    Canvas.MoveTo(X, Y);
    Canvas.LineTo(Round(C-J*Cos((A+I*(FScaleAngle)/FNumMainTicks)*2*Pi/360)),
                  Round(Y-J*Sin((A+I*(FScaleAngle)/FNumMainTicks)*2*Pi/360))); }
    //******************************** Out Caption *******************
    if (ShowCaption in FFaceOptions) then begin
      Canvas.Font.Color := FCaptionColor;
      Canvas.TextOut(Round(C - J/2 * Cos((A + FScaleAngle/2)*2*Pi/360)) -
                     Canvas.TextWidth(FCaption) div 2,
                     Round(Y - J/2 * Sin((A + FScaleAngle/2)*2*Pi/360)),
                     FCaption);
    end;
    //********************************** Out MinMaxLines *************************************
    ScaleValue := FScaleMax-FScaleMin;
    Min := FMinimum-FScaleMin;
    Max := FMaximum-FScaleMin;
    if (ShowIndicatorMax in FFaceOptions) then begin
      SetPenStyles(Canvas.Pen, FIndicatorWidth * K, FMaxColor);
      Canvas.Arc(X - J, Y - J, X + J, Y + J,
        Round(C - J * Cos((A + FScaleAngle)*2*Pi/360)),
        Round(Y - J * Sin((A + FScaleAngle)*2*Pi/360)),
        Round(C - J * Cos((A + Max*FScaleAngle/ScaleValue)*2*pi/360)),
        Round(Y - J * Sin((A + Max*FScaleAngle/ScaleValue)*2*pi/360)));
    end;
    if (ShowIndicatorMid in FFaceOptions) and (FMinimum < FMaximum) then begin
      SetPenStyles(Canvas.Pen, FIndicatorWidth * K, FMidColor);
      Canvas.Arc(X - J, Y - J, X + J, Y + J,
        Round(C - J * Cos((A + Max*FScaleAngle/ScaleValue)*2*pi/360)),
        Round(Y - J * Sin((A + Max*FScaleAngle/ScaleValue)*2*pi/360)),
        Round(C - J * Cos((A + Min*FScaleAngle/ScaleValue)*2*pi/360)),
        Round(Y - J * Sin((A + Min*FScaleAngle/ScaleValue)*2*pi/360)));
    end;
    if (ShowIndicatorMin in FFaceOptions) then begin
      SetPenStyles(Canvas.Pen, FIndicatorWidth * K, FMinColor);
      Canvas.Arc(X - J, Y - J, X + J, Y + J,
        Round(C - J * Cos((A + Min*FScaleAngle/ScaleValue)*2*Pi/360)),
        Round(Y - J * Sin((A + Min*FScaleAngle/ScaleValue)*2*Pi/360)),
        Round(C - J * Cos(A*2*Pi/360)),
        Round(Y - J * Sin(A*2*Pi/360)));
    end;
    Canvas.Font.Color := FValueColor;
    Canvas.Pen.Color := FTicksColor; Canvas.Pen.Width := K * FTicksWidth;
    //********************************** Out SubTicks *************************************
    if (ShowSubTicks in fFaceOptions) and (FNumSubTicks > 0) then
      begin;
      for I := 0 to N do 
        begin
        Canvas.MoveTo(Round(C-(J-FLengthSubTicks * K)*Cos((A+I*(FScaleAngle)/N)*2*pi/360)),
                    Round(Y-(J-FLengthSubTicks * K)*Sin((A+I*(FScaleAngle)/N)*2*pi/360)));
        Canvas.LineTo(round(C-(J)*Cos((A+I*(FScaleAngle)/N)*2*pi/360)),
                    round(Y-(J)*Sin((A+I*(FScaleAngle)/N)*2*pi/360)));
        end;
      end;  
    //********************************** Out Main Ticks ************************************
    for I := 0 to FNumMainTicks do begin
      if ShowMainTicks in fFaceOptions then begin
        Canvas.MoveTo(Round(C-(J-FLengthMainTicks*K)*Cos((A+I*(FScaleAngle)/FNumMainTicks)*2*Pi/360)),
                      Round(Y-(J-FLengthMainTicks*K)*Sin((A+I*(FScaleAngle)/FNumMainTicks)*2*Pi/360)));
        Canvas.LineTo(Round(C-(J)*Cos((A+I*(FScaleAngle)/FNumMainTicks)*2*Pi/360)),
                      Round(Y-(J)*Sin((A+I*(FScaleAngle)/FNumMainTicks)*2*Pi/360)));
      end;
      //************************************* Out Circles ************************************
      if ShowCircles in fFaceOptions then begin
        Canvas.Brush.Color := FCircleColor;
        Canvas.Ellipse(Round(C-J*Cos((A+I*(FScaleAngle)/FNumMainTicks)*2*Pi/360)) - R,
                       Round(Y-J*Sin((A+I*(FScaleAngle)/FNumMainTicks)*2*Pi/360)) - R,
                       Round(C-J*Cos((A+I*(FScaleAngle)/FNumMainTicks)*2*Pi/360)) + R,
                       Round(Y-J*Sin((A+I*(FScaleAngle)/FNumMainTicks)*2*Pi/360)) + R);
      end;
      // ************************************* Out Values *************************************
      if ShowValues in fFaceOptions then 
        begin
        str := IntToStr(ScaleMin + (i*ScaleValue div fNumMainTicks));
        Canvas.Brush.Color := FFaceColor;
        Canvas.TextOut(Round(C-(J - fLengthMainTicks*K-5-I)*cos((A+i*(fScaleAngle)/fNumMainTicks)*2*pi/360)) -
                       Canvas.TextWidth(str) div 2,
                       Round(Y-(J-fLengthMainTicks*K-5)*sin((A+i*(fScaleAngle)/fNumMainTicks)*2*pi/360)),
                       str);
        end;
    end;
  end
end;

procedure TA3nalogGauge.DrawArrow(Bitmap: TBitmap; K: Integer);
var
  ScaleValue, APos, J, X, Y, M, W, H, R: Integer;
  A, C: Single;
begin
  M := FMargin * K; R := FCenterRadius * K; W := Bitmap.Width; H := Bitmap.Height;
  with Bitmap do begin
    case FStyle of
      RightStyle: begin
        A := 0; C := W - M; X := W - M; Y := H - M;
        if FScaleAngle > 90 then FScaleAngle := 90; J := W - 2*M;
      end;
      LeftStyle: begin
        A := 90; C := M; X := M; Y := H - M;
        if FScaleAngle > 90 then FScaleAngle := 90; J := W - 2*M;
      end;
      else begin
        X := W div 2; A := (180 - fScaleAngle)/2; C := W/2;
        if FScaleAngle >= 180 then begin
          J := (W - 2*M) div 2;
          Y := H div 2;
        end else begin
          J := Round(((W - 2*M)/2)/Cos(A*2*pi/360));
          if J > H - 2*M then J := H - 2*M;
          Y := (H - J) div 2 + J;
        end;
      end;
    end;{case}
    ScaleValue:=FScaleMax-FScaleMin;
    if ScaleValue <= 0 then
      exit;
    if FPosition > FScaleMax then
      APos := ScaleValue
    else if FPosition < FScaleMin then
      APos := 0
    else
      APos := Round(FPosition)-ScaleMin;
    Canvas.Pen.Width := FArrowWidth * K; Canvas.Pen.Color := FArrowColor;
    Canvas.MoveTo(X, Y);
    Canvas.LineTo(Round(C - J*Cos((A + APos*FScaleAngle/ScaleValue)*2*pi/360)),
           Round(Y - J*Sin((A + APos*FScaleAngle/ScaleValue)*2*pi/360)));
    //********************************* Out Center ***************************************
    if ShowCenter in FFaceOptions then begin
      Canvas.Brush.Color := FCenterColor;
      Canvas.Ellipse(X - R, Y - R, X + R, Y + R);
    end;
  end;
end;

procedure TA3nalogGauge.RedrawArrow;
{$IFDEF TICKER}
var
  F: Integer;
  Ticker: Int64;
begin
  if FTicker < 0 then if FPeriod = 0 then FTicker := GetTickCount
                                     else QueryPerformanceCounter(FTicker);
{$ELSE}
begin
{$ENDIF}
  BitBlt(FFaceBitmap.Canvas.Handle, 0, 0, FBackBitmap.Width,
    FBackBitmap.Height, FBackBitmap.Canvas.Handle, 0, 0, SRCCOPY);
  DrawArrow(FFaceBitmap, GetAAMultipler);
  if FAntialiased <> aaNone then FastAntiAliasPicture;
  Paint;
{$IFDEF TICKER}
  if FPeriod = 0 then begin
    Ticker := GetTickCount;
    if Ticker < FTicker then Ticker := Ticker + $100000000;
    F := 1000 div (Ticker - FTicker)
  end else begin
    QueryPerformanceCounter(Ticker);
    F := FPeriod div (Ticker - FTicker)
  end;
  if F <> FFrames then begin
    FFrames := F;
    if Assigned(FOnFrames) then FOnFrames(Self)
  end;
  FTicker := -1;
{$ENDIF}
end;

procedure TA3nalogGauge.RedrawScale;
begin
{$IFDEF TICKER}
  if FPeriod = 0 then FTicker := GetTickCount
                 else QueryPerformanceCounter(FTicker);
{$ENDIF}
  DrawScale(FBackBitmap, GetAAMultipler);
  RedrawArrow;
end;

const
  MaxPixelCount = MaxInt div SizeOf(TRGBTriple);

type
  PRGBArray = ^TRGBArray;
  TRGBArray = array[0..MaxPixelCount-1] of TRGBTriple;

procedure TA3nalogGauge.FastAntiAliasPicture;
var
  x, y, cx, cy, cxi: Integer;
  totr, totg, totb: Integer;
  Row1, Row2, Row3, Row4, DestRow: PRGBArray;
  i, k: Integer;
begin
  // For each row
  K := GetAAMultipler; Row2 := nil; Row3 := nil; Row4 := nil;
  for Y := 0 to FAABitmap.Height - 1 do begin
    // We compute samples of K x K pixels
    cy := y*K;
    // Get pointers to actual, previous and next rows in supersampled bitmap
    Row1 := FFaceBitmap.ScanLine[cy];
    if K > 1 then Row2 := FFaceBitmap.ScanLine[cy+1];
    if K > 2 then Row3 := FFaceBitmap.ScanLine[cy+2];
    if K > 3 then Row4 := FFaceBitmap.ScanLine[cy+3];
    // Get a pointer to destination row in output bitmap
    DestRow := FAABitmap.ScanLine[y];
    // For each column...
    for x := 0 to FAABitmap.Width - 1 do begin
      // We compute samples of 3 x 3 pixels
      cx := x*K;
      // Initialize result color
      totr := 0; totg := 0; totb := 0;
      if K > 3 then begin
        for i := 0 to 3 do begin
          cxi := cx + i;
          totr := totr + Row1[cxi].rgbtRed + Row2[cxi].rgbtRed + Row3[cxi].rgbtRed + Row4[cxi].rgbtRed;
          totg := totg + Row1[cxi].rgbtGreen + Row2[cxi].rgbtGreen + Row3[cxi].rgbtGreen + Row4[cxi].rgbtGreen;
          totb := totb + Row1[cxi].rgbtBlue + Row2[cxi].rgbtBlue + Row3[cxi].rgbtBlue + Row4[cxi].rgbtBlue;
        end;
        DestRow[x].rgbtRed := totr div 16;
        DestRow[x].rgbtGreen := totg div 16;
        DestRow[x].rgbtBlue := totb div 16;
      end else if K > 2 then begin
        for i := 0 to 2 do begin
          cxi := cx + i;
          totr := totr + Row1[cxi].rgbtRed + Row2[cxi].rgbtRed + Row3[cxi].rgbtRed;
          totg := totg + Row1[cxi].rgbtGreen + Row2[cxi].rgbtGreen + Row3[cxi].rgbtGreen;
          totb := totb + Row1[cxi].rgbtBlue + Row2[cxi].rgbtBlue + Row3[cxi].rgbtBlue;
        end;
        DestRow[x].rgbtRed := totr div 9;
        DestRow[x].rgbtGreen := totg div 9;
        DestRow[x].rgbtBlue := totb div 9;
      end else if K > 1 then begin
        for i := 0 to 1 do begin
          cxi := cx + i;
          totr := totr + Row1[cxi].rgbtRed + Row2[cxi].rgbtRed;
          totg := totg + Row1[cxi].rgbtGreen + Row2[cxi].rgbtGreen;
          totb := totb + Row1[cxi].rgbtBlue + Row2[cxi].rgbtBlue;
        end;
        DestRow[x].rgbtRed := totr div 4;
        DestRow[x].rgbtGreen := totg div 4;
        DestRow[x].rgbtBlue := totb div 4;
      end else begin
        DestRow[x].rgbtRed   := Row1[cx].rgbtRed;
        DestRow[x].rgbtGreen := Row1[cx].rgbtGreen;
        DestRow[x].rgbtBlue  := Row1[cx].rgbtBlue;
      end;
    end;
  end
end;

procedure TA3nalogGauge.Paint;
begin
  if FAntiAliased = aaNone then BitBlt(Canvas.Handle, 0, 0, FFaceBitmap.Width,
    FFaceBitmap.Height,FFaceBitmap.Canvas.Handle, 0, 0, SRCCOPY) else
      BitBlt(Canvas.Handle, 0, 0, FAABitmap.Width,
    FAABitmap.Height, FAABitmap.Canvas.Handle, 0, 0, SRCCOPY)
end;

procedure TA3nalogGauge.WMSize(var Message : TWMSize);
var
  K: Integer;
begin
  if Width  < 60 then Width := 60; if Height < 50 then Height := 50;
  if FAntiAliased = aaNone then begin
    FBackBitmap.Width := Width; FBackBitmap.Height := Height;
    FFaceBitmap.Width := Width; FFaceBitmap.Height := Height;
  end else begin
    K := GetAAMultipler;
    FBackBitmap.Width := Width * K; FBackBitmap.Height := Height * K;
    FFaceBitmap.Width := Width * K; FFaceBitmap.Height := Height * K;
    FAABitmap.Width := Width;       FAABitmap.Height := Height;
  end;
  RedrawScale;
  inherited;
end;

procedure TA3nalogGauge.CMFontChanged(var Msg:TMessage);
begin
  RedrawScale;
end;
{ ------------------------------------------------------------------------- }
procedure TA3nalogGauge.SetFMinColor(C: TColor);
begin
  if C <> FMinColor then begin FMinColor := C; RedrawScale end;
end;

procedure TA3nalogGauge.SetFMidColor(C: TColor);
begin
  if C <> FMidColor then begin FMidColor := C; RedrawScale end;
end;

procedure TA3nalogGauge.SetFMaxColor(C: TColor);
begin
  if C <> FMaxColor then begin FMaxColor := C; RedrawScale end;
end;

procedure TA3nalogGauge.SetFFaceColor(C: TColor);
begin
  if C <> FFaceColor then begin FFaceColor := C; RedrawScale end;
end;

procedure TA3nalogGauge.SetFTicksColor(C: TColor);
begin
  if C <> FTicksColor then begin FTicksColor := C; RedrawScale end;
end;

procedure TA3nalogGauge.SetFValueColor(C: TColor);
begin
  if C <> FValueColor then begin FValueColor := C; RedrawScale end;
end;

procedure TA3nalogGauge.SetFCaptionColor(C: TColor);
begin
  if C <> FCaptionColor then begin FCaptionColor := C; RedrawScale end;
end;

procedure TA3nalogGauge.SetFArrowColor(C: TColor);
begin
  if C <> FArrowColor then begin FArrowColor := C; RedrawArrow end;
end;

procedure TA3nalogGauge.SetFMarginColor(C: TColor);
begin
  if C <> FMarginColor then begin FMarginColor := C; RedrawScale end;
end;

procedure TA3nalogGauge.SetFCenterColor(C: TColor);
begin
  if C <> FCenterColor then begin FCenterColor := C; RedrawScale end;
end;

procedure TA3nalogGauge.SetFCircleColor(C: TColor);
begin
  if C <> FCircleColor then begin FCircleColor := C; RedrawScale end;
end;

procedure TA3nalogGauge.SetFCenterRadius(I: Integer);
begin
  if I <> FCenterRadius then begin FCenterRadius := I; RedrawScale end;
end;

procedure TA3nalogGauge.SetFCircleRadius(I: Integer);
begin
  if I <> FCircleRadius then begin FCircleRadius := I; RedrawScale end
end;

procedure TA3nalogGauge.SetFScaleAngle(I: Integer);
begin
  if I <> FScaleAngle then begin
    if (I > 10) and (I <= 360) then FScaleAngle := I;
    RedrawScale;
  end;
end;

procedure TA3nalogGauge.SetFMargin(I: Integer);
begin
  if I <> FMargin then begin FMargin := I; RedrawScale end;
end;

procedure TA3nalogGauge.SetFStyle(S: TStyle);
begin
  if S <> FStyle then begin FStyle := S; RedrawScale end;
end;

procedure TA3nalogGauge.SetFArrowWidth(I: Integer);
begin
  if I <> FArrowWidth then begin
    if I < 1 then fArrowWidth := 1 else
    if I > 5 then fArrowWidth := 5 else fArrowWidth := i;
    RedrawArrow;
  end
end;

procedure TA3nalogGauge.SetFTicksWidth(I: Integer);
begin
if I <> FTicksWidth then
  begin  
  if I < 1 then FTicksWidth := 1 else
  if I > 5 then FTicksWidth := 5 else FTicksWidth := I;
  RedrawScale;
  end;
end;

procedure TA3nalogGauge.SetFNumMainTicks(I: Integer);
begin
  if I <> FNumMainTicks then begin FNumMainTicks := I; RedrawScale end;
end;


procedure TA3nalogGauge.SetFNumSubTicks(I: Integer);
begin
  if I <> FNumMainTicks then begin FNumSubTicks := I; RedrawScale end;
end;


procedure TA3nalogGauge.SetFLengthMainTicks(I: Integer);
begin
  if I <> FLengthMainTicks then begin FLengthMainTicks := I; RedrawScale end;
end;

procedure TA3nalogGauge.SetFLengthSubTicks(I: Integer);
begin
  if I <> FLengthSubTicks then begin FLengthSubTicks := I; RedrawScale end;
end;

procedure TA3nalogGauge.SetFFaceOptions(O: TFaceOptions);
begin
  if O <> FFaceOptions then begin FFaceOptions := O; RedrawScale end;
end;

procedure TA3nalogGauge.SetFPosition(V: Single);
begin
  if V <> FPosition then begin
    FPosition := V;
    if (FPosition > fMaximum) and Assigned(FOverMax) then OnOverMax(Self);
    if (FPosition < fMinimum) and Assigned(FOverMin) then OnOverMin(Self);
    RedrawArrow;
  end
end;

procedure TA3nalogGauge.SetFScaleMin(I: Integer);
begin
if I <> FScaleMin then 
  begin
  FScaleMin := I;
  if FMaximum > I then FMaximum := I;
  if FMinimum < I then FMinimum := I;
  if FMaximum < FMinimum then FMaximum := FMinimum;    
  RedrawScale;
  end;
end;

procedure TA3nalogGauge.SetFScaleMax(I: Integer);
begin
if I <> FScaleMax then
  begin
  FScaleMax := I;
  if FMaximum > I then FMaximum := I;
  if FMinimum < I then FMinimum := I;
  if FMaximum < FMinimum then FMaximum := FMinimum;
  RedrawScale;
  end;
end;

procedure TA3nalogGauge.SetFMinimum(I: Integer);
begin
if I <> FMinimum then
  begin
  if I >= FScaleMin then FMinimum := I;
  RedrawScale;
  end
end;

procedure TA3nalogGauge.SetFMaximum(I: Integer);
begin
if I <> FMaximum then
  begin
  if I <= FScaleMax then FMaximum := I;
  RedrawScale;
  end;
end;


procedure TA3nalogGauge.SetFIndicatorWidth(I: Integer);
begin
if I <> FIndicatorWidth then
  begin
  FIndicatorWidth := I;
  RedrawScale;
  end;
end;


procedure TA3nalogGauge.SetFCaption(const S: string);
begin
  if S <> FCaption then begin Canvas.Font := Font; FCaption := S; RedrawScale end
end;

procedure TA3nalogGauge.SetFAntiAliased(V: TAntialiased);
var
  K: Integer;
begin
  if V <> FAntiAliased then begin
    FAntiAliased := V;
    if FAntiAliased = aaNone then begin
      FreeAndNil(FAABitmap);
      FreeAndNil(FBackBitmap);       FreeAndNil(FFaceBitmap);
      FBackBitmap := TBitmap.Create; FFaceBitmap := TBitmap.Create;
      FBackBitmap.Width := Width;    FFaceBitmap.Width := Width;
      FBackBitmap.Height := Height;  FFaceBitmap.Height := Height;
    end else begin
      K := GetAAMultipler;
      FBackBitmap.PixelFormat := pf24bit; FFaceBitmap.PixelFormat := pf24bit;
      FBackBitmap.Width := Width * K;     FFaceBitmap.Width := Width * K;
      FBackBitmap.Height := Height * K;   FFaceBitmap.Height := Height * K;
      if not Assigned(FAABitmap) then FAABitmap := TBitmap.Create;
      FAABitmap.PixelFormat := pf24bit;
      FAABitmap.Width := Width;    FAABitmap.Height := Height;
    end;
    RedrawScale;
  end
end;

function TA3nalogGauge.GetAAMultipler: Integer;
begin
  case FAntiAliased of
    aaBiline: Result := 2;
    aaTriline: Result := 3;
    aaQuadral: Result := 4;
    else Result := 1
  end
end;

{ ------------------------------------------------------------------------- }
procedure Register;
begin
  RegisterComponents('MHS', [TA3nalogGauge]);
end;
{ ========================================================================= }
end.


