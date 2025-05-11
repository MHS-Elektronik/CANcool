{***************************************************************************
                          Util.pas  -  description
                             -------------------
    begin             : 07.01.2013
    last modified     : 13.10.2022
    copyright         : (C) 2013 - 2022 by MHS-Elektronik GmbH & Co. KG, Germany
                               http://www.mhs-elektronik.de    
    autho             : Klaus Demlehner, klaus@mhs-elektronik.de
 ***************************************************************************}

{***************************************************************************
 *                                                                         *
 *   This program is free software, you can redistribute it and/or modify  *
 *   it under the terms of the MIT License <LICENSE.TXT or                 *
 *   http://opensource.org/licenses/MIT>                                   *              
 *                                                                         *
 ***************************************************************************}
unit Util;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, IniFiles, TinyCanDrv;


const
    HexDigits : array[0..15] of Char = '0123456789ABCDEF';

type
    TFontDesc = record
    Name: String;
    Size: Integer;
    Style: TFontStyles;
    end;


procedure InitUtil;
procedure DestroyUtil;

function ReadListInteger(Liste: TStrings; const Name: string; Standard: integer): integer;
function ReadListString(Liste: TStrings; const Name: string; Standard: string): string;

procedure ReadListFont(Liste: TStrings; const Name: string; var Font: TFontDesc; DefFont: TFontDesc);
procedure WriteListFont(Liste: TStrings; const Name: string; Font: TFontDesc);

function StrToHex(str: String): DWord;
function ExtractSubstr(const s: string; var pos: Integer; const delims: TSysCharSet): string;
procedure AutoStringGridSize(view: TStringGrid; var height, width: Integer);
procedure RxCanEnterCritical;
procedure RxCanLeaveCritical;

function IniReadColor(IniF: TIniFile; const Section, Ident: string;
  Default: TColor): TColor;
procedure IniWriteColor(IniF: TIniFile; const Section, Ident: string;
  Value: TColor);

function FontStylesToString(Styles: TFontStyles): string;
function StringToFontStyles(const Styles: string): TFontStyles;
function FontToString(Font: TFontDesc): string;
procedure StringToFont(const Str: string; var Font: TFontDesc);

procedure IniReadFont(IniF: TIniFile; var Font: TFontDesc; const Section,
  Ident: string; DefFont: TFontDesc);
procedure IniWriteFont(IniF: TIniFile; const Section, Ident: string; Font: TFontDesc);
function GetTextWidth(Font: TFont; Text: String): Integer;
function GetTextHeight(Font: TFont; Text: String): Integer;

procedure CopyFontDesc(var dst: TFontDesc; src: TFontDesc);
procedure FontDescToFont(font_desc: TFontDesc; font: TFont);
procedure FontDescFromFont(var font_desc: TFontDesc; font: TFont);

function CorrectCanFdLen(len: Byte): Byte;
function CorrectCanFdLenEx(len: Byte; can_msg: PCanFdMsg; pattern: Byte): Byte;

implementation

var RxCanCriticalSection: TRTLCriticalSection;


function ReadListInteger(Liste: TStrings; const Name: string; Standard: integer): integer;
var
  s: string;
begin
  s := Liste.Values[Name];
  if s <> '' then
  begin
    try
      result := StrToInt(s);
    except
      result := Standard;
    end;
  end
else
  result := Standard;
end;


function ReadListString(Liste: TStrings; const Name: string; Standard: string): string;

begin
result := Liste.Values[Name];
if result = '' then
  result := Standard;
end;


procedure ReadListFont(Liste: TStrings; const Name: string; var Font: TFontDesc; DefFont: TFontDesc);
var s: string;
  
begin
  s := Liste.Values[Name];
  if s <> '' then
    StringToFont(s, Font)
else
  Font := DefFont;
end;    


procedure WriteListFont(Liste: TStrings; const Name: string; Font: TFontDesc);
var str: String;

begin;
str := Name + '=' + FontToString(Font);
Liste.Append(str);
end;


function StrToHex(str: String): DWord;
var i: Integer;
    n: Byte;
    z: DWord;
    
begin;
z := 0;
for i := 1 to length(str) do
  begin;
  if str[i] in ['0' .. '9'] then 
    n := ord(str[i]) - $30
  else if str[i] in ['A' .. 'F'] then
    n := ord(str[i]) - $37
  else
    n := 0;
  z := (z shl 4) + n;  
  end;
result := z;
end;


function ExtractSubstr(const s: string; var pos: Integer; const delims: TSysCharSet): string;
var i, l: Integer;

begin
i := pos;
l := Length(s);
while (i <= l) and not (s[i] in delims) do Inc(i);
if i = pos then
  Result := ''
else
  Result := Copy(s, pos, i - pos);
if (i <= Length(s)) and (s[i] in delims) then Inc(i);
pos := i;
end;


procedure AutoStringGridSize(view: TStringGrid; var height, width: Integer);
var row_cnt, col_cnt, row, col, h, w, h_max, w_max, grid_space: Integer;
    rect: TRect;
    s: String;

begin;
col_cnt := view.ColCount;
row_cnt := view.RowCount;
if (col_cnt < 1) or (row_cnt < 1) then
  exit;
view.Canvas.Font.Assign(view.Font);
h_max := 1;
width := 2;
grid_space := view.GridLineWidth;
for col := 0 to col_cnt - 1 do  // Spalten
  begin;
  w_max := 1;
  for row := 0 to row_cnt - 1 do  // Zeilen
    begin;
    s := view.Cells[col, row];
    DrawText(view.Canvas.Handle, PChar(s), length(s), rect, DT_CalcRect or DT_Left);
    w := rect.Right - rect.Left;   // Breite
    h := rect.Bottom - rect.Top;   // Höhe
    if w_max < w then
      w_max := w;
    if h_max < h then
      h_max := h;
    end;
  inc(w_max, 5);
  view.ColWidths[col] := w_max;
  width := width + w_max + grid_space;
  end;
inc(h_max, 4);
height := 2 + ((h_max + grid_space) * row_cnt);
for row := 0 to row_cnt - 1 do     // Zeilen
  view.RowHeights[row] := h_max;
view.Refresh;
end;


procedure InitUtil;
begin
InitializeCriticalSection(RxCanCriticalSection)
end;


procedure DestroyUtil;
begin
DeleteCriticalSection(RxCanCriticalSection);
end;


procedure RxCanEnterCritical;
begin
EnterCriticalSection(RxCanCriticalSection);
end;


procedure RxCanLeaveCritical;
begin
LeaveCriticalSection(RxCanCriticalSection);  
end;


{**************************************************************}
{* Color lesen und schreiben                                  *}
{**************************************************************}
function IniReadColor(IniF: TIniFile; const Section, Ident: string;
  Default: TColor): TColor;
begin
  try
    Result := StringToColor(IniF.ReadString(Section, Ident,
      ColorToString(Default)));
  except
    Result := Default;
  end;
end;


procedure IniWriteColor(IniF: TIniFile; const Section, Ident: string;
  Value: TColor);
begin
  IniF.WriteString(Section, Ident, ColorToString(Value));
end;


function FontStylesToString(Styles: TFontStyles): string;
begin
  Result := '';
  if fsBold in Styles then Result := Result + 'B';
  if fsItalic in Styles then Result := Result + 'I';
  if fsUnderline in Styles then Result := Result + 'U';
  if fsStrikeOut in Styles then Result := Result + 'S';
end;


function StringToFontStyles(const Styles: string): TFontStyles;

begin
  Result := [];
  if Pos('B', UpperCase(Styles)) > 0 then Include(Result, fsBold);
  if Pos('I', UpperCase(Styles)) > 0 then Include(Result, fsItalic);
  if Pos('U', UpperCase(Styles)) > 0 then Include(Result, fsUnderline);
  if Pos('S', UpperCase(Styles)) > 0 then Include(Result, fsStrikeOut);
end;


function FontToString(Font: TFontDesc): string;

begin
Result := Format('%s,%d,%s', [Font.Name, Font.Size, FontStylesToString(Font.Style)]);
end;



procedure StringToFont(const Str: string; var Font: TFontDesc);

const
  Delims = [',', ';'];
var
  Pos: Integer;
  I: Byte;
  S: string;

begin
Pos := 1;
I := 0;
Font.Size := 12;
Font.Style := [];
while Pos <= Length(Str) do
  begin
  Inc(I);
  S := Trim(ExtractSubstr(Str, Pos, Delims));
  case I of
      1: Font.Name := S;
      2: Font.Size := StrToIntDef(S, Font.Size);
      3: Font.Style := StringToFontStyles(S);
  {   4: Font.Pitch := TFontPitch(StrToIntDef(S, Ord(Font.Pitch)));
      5: Font.Color := StringToColor(S); }
    end;
  end;
end;


procedure IniReadFont(IniF: TIniFile; var Font: TFontDesc; const Section,
  Ident: string; DefFont: TFontDesc);

begin
  Font := DefFont;
  try
    StringToFont(IniF.ReadString(Section, Ident, FontToString(Font)), Font);
  except
    { do nothing, ignore any exceptions }
  end;
end;


procedure IniWriteFont(IniF: TIniFile; const Section, Ident: string; Font: TFontDesc);

begin
  IniF.WriteString(Section, Ident, FontToString(Font));
end;


function GetTextWidth(Font: TFont; Text: String): Integer;
var B: TBitMap;
  
begin
B := TBitMap.Create;
B.Canvas.Font := Font;
Result := B.Canvas.TextWidth(Text);
B.Free;
end;


function GetTextHeight(Font: TFont; Text: String): Integer;
var B: TBitMap;
  
begin
B := TBitMap.Create;
B.Canvas.Font := Font;
Result := B.Canvas.TextHeight(Text);
B.Free;
end; 


procedure FontDescToFont(font_desc: TFontDesc; font: TFont);

begin;
font.Name := font_desc.Name;
font.Size := font_desc.Size;
font.Style := font_desc.Style;

end;


procedure FontDescFromFont(var font_desc: TFontDesc; font: TFont);

begin;
font_desc.Name := font.Name;
font_desc.Size := font.Size;
font_desc.Style := font.Style;
end;


procedure CopyFontDesc(var dst: TFontDesc; src: TFontDesc);

begin;
dst.Name := src.Name;
dst.Size := src.Size;
dst.Style := src.Style;
end;


function CorrectCanFdLen(len: Byte): Byte;

begin;
if len <= 8 then
  result := len
else if len > 64 then // Datenlänge auf 64 Byte begrenzen
  result := 64
else if len > 48 then
  result := 64  // Datenlänge = 64 Byte
else if len > 32 then
  result := 48  // Datenlänge = 48 Byte
else if len > 24 then
  result := 32  // Datenlänge = 32 Byte
else if len > 20 then
  result := 24  // Datenlänge = 24 Byte
else if len > 16 then
  result := 20  // Datenlänge = 20 Byte
else if len > 12 then
  result := 16  // Datenlänge = 16 Byte
else
  result := 12  // Datenlänge = 12 Byte
end;


function CorrectCanFdLenEx(len: Byte; can_msg: PCanFdMsg; pattern: Byte): Byte;
var i, x: Byte;

begin;
if (can_msg.Flags and FlagCanFdFD) > 0 then
  begin;
  result := CorrectCanFdLen(len);
  if (result <> 64) and (result <> len) then
    begin;
    x := (result - len) - 1;  
    for i := len to x do    
      can_msg^.Data.Bytes[i] := pattern;
    end;
  end    
else
  begin;
  if len > 8 then
    result := 8
  else
    result := len;
  end;
can_msg.Length := result;
end;

end.
