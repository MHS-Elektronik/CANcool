{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE. Based on work given by Louis S. Berman from
              BrainTree Ltd, lsb@braintree.com
Description:  MD5 is an implementation of the MD5 Message-Digest Algorithm
              as described in RFC-1321
Creation:     October 11, 1997
Version:      8.00
EMail:        francois.piette@overbyte.be  http://www.overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 1997-2012 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium.
              <francois.piette@overbyte.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

Updates:
Oct 26, 1997 Changed MD5Final form function to procedure to be compatible
             with C++Builder.
Jul 09, 1998 V1.01 Adapted for Delphi 4
Aug 06, 1998 V1.02 Added R- Q- directive
Jun 05, 1999 V1.03 Wolfgang Klein found a bug in MD5Update.
Dec 04, 2002 V1.04 Added function FileMD5 from Leon Zandman <leon@wirwar.com>
Mar 14, 2003 V1.05 Bas Steendijk <steendijk@xs4all.nl> corrected a bug when
             file size is exactly 256MB. See comment in code.
Mar 26, 2006 V6.00 New version 6 started
Sep 18, 2006 V6.01 Angus - fix to allow files larger than 2 gigs
Sep 20, 2006 V6.02 Arno - added a progress callback to FileMD5().
Oct 31, 2006 V6.03 Angus - progress reports position not size
July 2007    V6.04 changes for .net compatibility
27 Nov 2007  V6.05 Angus added FileMD5 for partial file, removed duplicate code
08 Jan 2008  V6.06 Angus added FileListMD5, optional file mode to stop file being share locked
Apr 12, 2008 *Temporary, non-breaking Unicode changes* AG.
17 Apr, 2008 MD5UpdateBuffer String to AnsiString type-change.
Aug 05, 2008 V6.07 F. Piette added casts to AnsiString to avoid warnings
Jan 03, 2009 V6.08 A. Garrels added function MD5SameDigest and an overload
             to MD5UpdateBuffer() which takes a TMD5Digest.
Apr 03, 2009 V6.09 Angus added StreamMD5, StreamMD5Context, MD5DigestToHex,
             MD5DigestInit, which allow duplicated code to be removed
Apr 04, 2009 V6.10 F. Piette added OverbyteIcsTypes for TBytes definition.
Apr 10, 2009 V6.11 Arno added an explicit AnsiString cast to remove compiler
             warnings from MD5DigestToHex().
Apr 18, 2009 V6.12 Arno fixed a bug in procedure MD5UpdateBuffer.
             Only Unicode compilers were effected.
Apr 22, 2009 V7.00 Angus assume STREAM64
Sep 20, 2010 V7.01 Arno added HMAC_MD5 routine from OverbyteIcsSmtpProt.pas
             and MD5DigestToHex functions.
Sep 21, 2010 V7.02 Arno - Changed parameters of MD5SameDigest() to reference
             types rather than value types. Changed MD5DigestToLowerHexA to
             return RawByteString.
Mar 15, 2012 V7.03 Arno - HMAC_MD5() did not handle key sizes > 64 bytes correctly.
May 2012 - V8.00 - Arno added FireMonkey cross platform support with POSIX/MacOS
                   also IPv6 support, include files now in sub-directory

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsMD5;

{$I include\OverbyteIcsDefs.inc}
{$IFDEF COMPILER14_UP}
  {$IFDEF NO_EXTENDED_RTTI}
    {$RTTI EXPLICIT METHODS([]) FIELDS([]) PROPERTIES([])}
  {$ENDIF}
{$ENDIF}
{$IFDEF CLR}
    {$DEFINE SAFE}
{$ENDIF}

interface

uses
    {$IFDEF RTL_NAMESPACES}System.SysUtils{$ELSE}SysUtils{$ENDIF},
    {$IFDEF RTL_NAMESPACES}System.Classes{$ELSE}Classes{$ENDIF},
    OverbyteIcsTypes;   // For TBytes

const
    MD5Version         = 800;
    CopyRight : String = ' MD5 Message-Digest (c) 1997-2012 F. Piette V8.00 ';
    DefaultMode =  fmOpenRead or fmShareDenyWrite;

{$Q-}
{$R-}

type
    TMD5Progress = procedure(Obj: TObject; Count: Int64; var Cancel: Boolean);  { V6.02, V7.00 }

    TMD5State = array [0..3] of LongInt;
    TMD5Context = record
        State: TMD5State;
        Count: array [0..1] of LongInt;
{$IFDEF SAFE}
        BufLong: array [0..15] of LongInt;
{$ELSE}
        case Integer of
        0: (BufChar: array [0..63] of Byte);
        1: (BufLong: array [0..15] of LongInt);
{$ENDIF}
    end;
    TMD5Digest = array [0..15] of Byte;

procedure MD5Init(var MD5Context: TMD5Context);
procedure MD5Update(var MD5Context: TMD5Context;
{$IFDEF SAFE}
    const Data : TBytes;
{$ELSE}
    const Data;
{$ENDIF}
    Len: Integer);

procedure MD5Transform(var Buf: array of LongInt;
                       const Data: array of LongInt);
procedure MD5UpdateBuffer(var MD5Context: TMD5Context;
                          {$IFDEF SAFE}
                          const Buffer: TBytes;
                          {$ELSE}
                          Buffer: Pointer;
                          {$ENDIF}
                          BufSize: Integer); overload;
procedure MD5UpdateBuffer(
    var MD5Context : TMD5Context;
    const Buffer   : AnsiString); overload;
procedure MD5UpdateBuffer(
    var MD5Context: TMD5Context;
    const Buffer: TMD5Digest); overload;    
procedure MD5Final(var Digest: TMD5Digest; var MD5Context: TMD5Context);

function  MD5GetBufChar(const MD5Context : TMD5Context; Index : Integer) : Byte;
procedure MD5SetBufChar(var MD5Context : TMD5Context; Index : Integer; Value : Byte);
procedure MD5MoveToBufChar(var MD5Context : TMD5Context;
                           const Data {$IFDEF SAFE}: TBytes{$ENDIF};
                           Offset : Integer;
                           Index  : Integer;
                           Len    : Integer);
procedure MD5FillBufChar(var MD5Context : TMD5Context;
                         Index          : Integer;
                         Count          : Integer;
                         Value          : Byte);
procedure MD5ContextClear(var MD5Context : TMD5Context);
procedure MD5MoveStateToDigest(
    const State  : TMD5State;
    var   Digest : TMD5Digest);

function GetMD5({$IFDEF SAFE}
                const Buffer: TBytes;
                {$ELSE}
                Buffer: Pointer;
                {$ENDIF}
                BufSize: Integer): AnsiString; overload;
function StrMD5(Buffer : String): String;
{$IFDEF COMPILER12_UP}
overload;
function StrMD5(Buffer : AnsiString): AnsiString; overload;
{$ENDIF}
function FileMD5(const Filename: String; Mode: Word = DefaultMode) : AnsiString; overload;
function FileMD5(const Filename: String; Obj: TObject; ProgressCallback: TMD5Progress;
                                           Mode: Word = DefaultMode) : AnsiString; overload;
function FileMD5(const Filename: String; StartPos, EndPos: Int64;
                                 Mode: Word = DefaultMode) : AnsiString; overload; { V6.05 }
function FileMD5(const Filename: String; Obj: TObject; ProgressCallback : TMD5Progress;
        StartPos, EndPos: Int64;  Mode: Word = DefaultMode): AnsiString; overload; { V6.05 }
function FileListMD5(FileList: TStringList; Obj: TObject;
    ProgressCallback : TMD5Progress; Mode: Word = DefaultMode) : AnsiString;    { V6.06 }

function MD5SameDigest(const D1, D2: TMD5Digest): Boolean; { V7.02 }

procedure StreamMD5Context(Stream: TStream; Obj: TObject; ProgressCallback :
                 TMD5Progress; StartPos, EndPos: Int64; var MD5Context: TMD5Context); { V6.09 }
function StreamMD5(Stream: TStream; Obj: TObject; ProgressCallback : TMD5Progress;
                                                StartPos, EndPos: Int64): AnsiString; { V6.09 }
{$IFNDEF SAFE}
function MD5DigestToHex (const MD5Digest: TMD5Digest): AnsiString;  { V6.09 }   { V7.01 }
function MD5DigestToLowerHexA(const MD5Digest: TMD5Digest): RawByteString; { V7.01 } { V7.02 }
function MD5DigestToLowerHex(const MD5Digest: TMD5Digest): String;   { V7.01 }
procedure HMAC_MD5(const Buffer; BufferSize: Integer; const Key; KeySize: Integer;   { V7.01 }
                   out Digest: TMD5Digest);
{$ENDIF}

procedure MD5DigestInit (var MD5Digest: TMD5Digest);                { V6.09 }

implementation

const
    MaxBufSize = 16384;

type
    PMD5Buffer = ^TMD5Buffer;
    TMD5Buffer = array [0..(MaxBufSize - 1)] of Char;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF NEVER}
function GetBufLong(
    const MD5Context: TMD5Context;
    Index           : Integer) : LongInt;
var
    I : Integer;
begin
    I := Index shl 2;
    Result := (MD5GetBufChar(MD5Context, I)) +
              (MD5GetBufChar(MD5Context, I + 1) shl 8) +
              (MD5GetBufChar(MD5Context, I + 2) shl 16) +
              (MD5GetBufChar(MD5Context, I + 4) shl 24);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ MD5 initialization. Begins an MD5 operation, writing a new context.         }
procedure MD5Init(var MD5Context: TMD5Context);
begin
    MD5ContextClear(MD5Context);
    with MD5Context do begin
        { Load magic initialization constants. }
        State[0] := LongInt($67452301);
        State[1] := LongInt($EFCDAB89);
        State[2] := LongInt($98BADCFE);
        State[3] := LongInt($10325476);
    end
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ MD5 block update operation. Continues an MD5 message-digest operation,      }
{ processing another message block, and updating the context.                 }
procedure MD5Update(
    var MD5Context: TMD5Context;            { Context                         }
{$IFDEF SAFE}
    const Data : TBytes;                    { Input block                     }
{$ELSE}
    const Data;                             { Input block                     }
{$ENDIF}
    Len: Integer);                          { Length of input block           }
type
    TByteArray = array [0..0] of Byte;
var
    Index: Word;
    T: LongInt;
begin
    with MD5Context do begin
        T := Count[0];
        Inc(Count[0], LongInt(Len) shl 3);
        if Cardinal(Count[0]) < Cardinal(T) then    {20030314 Bas Steendijk}
            Inc(Count[1]);
        Inc(Count[1], Len shr 29);
        T := (T shr 3) and $3F;
        Index := 0;
        if T <> 0 then begin
            Index := T;
            T := 64 - T;
            if Len < T then begin
                {$IFDEF SAFE}
                MD5MoveToBufChar(MD5Context, Data, 0, Index, Len);
                {$ELSE}
                Move(Data, BufChar[Index], Len);
                {$ENDIF}
                Exit;
            end;
            {$IFDEF SAFE}
            MD5MoveToBufChar(MD5Context, Data, 0, Index, T);
            {$ELSE}
            Move(Data, BufChar[Index], T);
            {$ENDIF}
            MD5Transform(State, BufLong);
            Dec(Len, T);
            Index := T;  { Wolfgang Klein, 05/06/99 }
        end;
        while Len >= 64 do begin
            {$IFDEF SAFE}
            MD5MoveToBufChar(MD5Context, Data, Index, 0, 64);
            {$ELSE}
            Move(TByteArray(Data)[Index], BufChar, 64);
            {$ENDIF}
            MD5Transform(State, BufLong);
            Inc(Index, 64);
            Dec(Len, 64);
        end;
        {$IFDEF SAFE}
        MD5MoveToBufChar(MD5Context, Data, Index, 0, Len);
        {$ELSE}
        Move(TByteArray(Data)[Index], BufChar, Len);
        {$ENDIF}
    end
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ MD5 finalization. Ends an MD5 message-digest operation, writing the message }
{ digest and zeroizing the context.                                           }
procedure MD5Final(var Digest: TMD5Digest; var MD5Context: TMD5Context);
var
    Cnt : Word;
    P   : Byte;
begin
    with MD5Context do begin
        Cnt := (Count[0] shr 3) and $3F;
        P := Cnt;
        {$IFDEF SAFE}
        MD5SetBufChar(MD5Context, P, $80);
        {$ELSE}
        BufChar[P] := $80;
        {$ENDIF}
        Inc(P);
        Cnt := 64 - 1 - Cnt;
        if Cnt < 8 then begin
            {$IFDEF SAFE}
            MD5FillBufChar(MD5Context, P, Cnt, 0);
            {$ELSE}
            FillChar(BufChar[P], Cnt, #0);
            {$ENDIF}
            MD5Transform(State, BufLong);
            {$IFDEF SAFE}
            MD5FillBufChar(MD5Context, 0, 56, 0);
            {$ELSE}
            FillChar(BufChar, 56, #0);
            {$ENDIF}
        end
        else
            {$IFDEF SAFE}
            MD5FillBufChar(MD5Context, P, Cnt - 8, 0);
            {$ELSE}
            FillChar(BufChar[P], Cnt - 8, #0);
            {$ENDIF}
        BufLong[14] := Count[0];
        BufLong[15] := Count[1];
        MD5Transform(State, BufLong);
        {$IFDEF SAFE}
        MD5MoveStateToDigest(State, Digest);
        {$ELSE}
        Move(State, Digest, 16)
        {$ENDIF}
    end;
    MD5ContextClear(MD5Context);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ MD5 basic transformation. Transforms state based on block.                  }
procedure MD5Transform(
    var Buf: array of LongInt;
    const Data: array of LongInt);
var
    A, B, C, D: LongInt;

    procedure Round1(var W: LongInt; X, Y, Z, Data: LongInt; S: Byte);
    begin
        Inc(W, (Z xor (X and (Y xor Z))) + Data);
        W := (W shl S) or (W shr (32 - S));
        Inc(W, X)
    end;

    procedure Round2(var W: LongInt; X, Y, Z, Data: LongInt; S: Byte);
    begin
        Inc(W, (Y xor (Z and (X xor Y))) + Data);
        W := (W shl S) or (W shr (32 - S));
        Inc(W, X)
    end;

    procedure Round3(var W: LongInt; X, Y, Z, Data: LongInt; S: Byte);
    begin
        Inc(W, (X xor Y xor Z) + Data);
        W := (W shl S) or (W shr (32 - S));
        Inc(W, X)
    end;

    procedure Round4(var W: LongInt; X, Y, Z, Data: LongInt; S: Byte);
    begin
        Inc(W, (Y xor (X or not Z)) + Data);
        W := (W shl S) or (W shr (32 - S));
        Inc(W, X)
    end;
begin
    A := Buf[0];
    B := Buf[1];
    C := Buf[2];
    D := Buf[3];

    Round1(A, B, C, D, Data[ 0] + LongInt($d76aa478),  7);
    Round1(D, A, B, C, Data[ 1] + LongInt($e8c7b756), 12);
    Round1(C, D, A, B, Data[ 2] + LongInt($242070db), 17);
    Round1(B, C, D, A, Data[ 3] + LongInt($c1bdceee), 22);
    Round1(A, B, C, D, Data[ 4] + LongInt($f57c0faf),  7);
    Round1(D, A, B, C, Data[ 5] + LongInt($4787c62a), 12);
    Round1(C, D, A, B, Data[ 6] + LongInt($a8304613), 17);
    Round1(B, C, D, A, Data[ 7] + LongInt($fd469501), 22);
    Round1(A, B, C, D, Data[ 8] + LongInt($698098d8),  7);
    Round1(D, A, B, C, Data[ 9] + LongInt($8b44f7af), 12);
    Round1(C, D, A, B, Data[10] + LongInt($ffff5bb1), 17);
    Round1(B, C, D, A, Data[11] + LongInt($895cd7be), 22);
    Round1(A, B, C, D, Data[12] + LongInt($6b901122),  7);
    Round1(D, A, B, C, Data[13] + LongInt($fd987193), 12);
    Round1(C, D, A, B, Data[14] + LongInt($a679438e), 17);
    Round1(B, C, D, A, Data[15] + LongInt($49b40821), 22);

    Round2(A, B, C, D, Data[ 1] + LongInt($f61e2562),  5);
    Round2(D, A, B, C, Data[ 6] + LongInt($c040b340),  9);
    Round2(C, D, A, B, Data[11] + LongInt($265e5a51), 14);
    Round2(B, C, D, A, Data[ 0] + LongInt($e9b6c7aa), 20);
    Round2(A, B, C, D, Data[ 5] + LongInt($d62f105d),  5);
    Round2(D, A, B, C, Data[10] + LongInt($02441453),  9);
    Round2(C, D, A, B, Data[15] + LongInt($d8a1e681), 14);
    Round2(B, C, D, A, Data[ 4] + LongInt($e7d3fbc8), 20);
    Round2(A, B, C, D, Data[ 9] + LongInt($21e1cde6),  5);
    Round2(D, A, B, C, Data[14] + LongInt($c33707d6),  9);
    Round2(C, D, A, B, Data[ 3] + LongInt($f4d50d87), 14);
    Round2(B, C, D, A, Data[ 8] + LongInt($455a14ed), 20);
    Round2(A, B, C, D, Data[13] + LongInt($a9e3e905),  5);
    Round2(D, A, B, C, Data[ 2] + LongInt($fcefa3f8),  9);
    Round2(C, D, A, B, Data[ 7] + LongInt($676f02d9), 14);
    Round2(B, C, D, A, Data[12] + LongInt($8d2a4c8a), 20);

    Round3(A, B, C, D, Data[ 5] + LongInt($fffa3942),  4);
    Round3(D, A, B, C, Data[ 8] + LongInt($8771f681), 11);
    Round3(C, D, A, B, Data[11] + LongInt($6d9d6122), 16);
    Round3(B, C, D, A, Data[14] + LongInt($fde5380c), 23);
    Round3(A, B, C, D, Data[ 1] + LongInt($a4beea44),  4);
    Round3(D, A, B, C, Data[ 4] + LongInt($4bdecfa9), 11);
    Round3(C, D, A, B, Data[ 7] + LongInt($f6bb4b60), 16);
    Round3(B, C, D, A, Data[10] + LongInt($bebfbc70), 23);
    Round3(A, B, C, D, Data[13] + LongInt($289b7ec6),  4);
    Round3(D, A, B, C, Data[ 0] + LongInt($eaa127fa), 11);
    Round3(C, D, A, B, Data[ 3] + LongInt($d4ef3085), 16);
    Round3(B, C, D, A, Data[ 6] + LongInt($04881d05), 23);
    Round3(A, B, C, D, Data[ 9] + LongInt($d9d4d039),  4);
    Round3(D, A, B, C, Data[12] + LongInt($e6db99e5), 11);
    Round3(C, D, A, B, Data[15] + LongInt($1fa27cf8), 16);
    Round3(B, C, D, A, Data[ 2] + LongInt($c4ac5665), 23);

    Round4(A, B, C, D, Data[ 0] + LongInt($f4292244),  6);
    Round4(D, A, B, C, Data[ 7] + LongInt($432aff97), 10);
    Round4(C, D, A, B, Data[14] + LongInt($ab9423a7), 15);
    Round4(B, C, D, A, Data[ 5] + LongInt($fc93a039), 21);
    Round4(A, B, C, D, Data[12] + LongInt($655b59c3),  6);
    Round4(D, A, B, C, Data[ 3] + LongInt($8f0ccc92), 10);
    Round4(C, D, A, B, Data[10] + LongInt($ffeff47d), 15);
    Round4(B, C, D, A, Data[ 1] + LongInt($85845dd1), 21);
    Round4(A, B, C, D, Data[ 8] + LongInt($6fa87e4f),  6);
    Round4(D, A, B, C, Data[15] + LongInt($fe2ce6e0), 10);
    Round4(C, D, A, B, Data[ 6] + LongInt($a3014314), 15);
    Round4(B, C, D, A, Data[13] + LongInt($4e0811a1), 21);
    Round4(A, B, C, D, Data[ 4] + LongInt($f7537e82),  6);
    Round4(D, A, B, C, Data[11] + LongInt($bd3af235), 10);
    Round4(C, D, A, B, Data[ 2] + LongInt($2ad7d2bb), 15);
    Round4(B, C, D, A, Data[ 9] + LongInt($eb86d391), 21);

    Inc(Buf[0], A);
    Inc(Buf[1], B);
    Inc(Buf[2], C);
    Inc(Buf[3], D);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF SAFE}
procedure MD5UpdateBuffer(
    var MD5Context: TMD5Context;
    const Buffer: TBytes;
    BufSize: Integer);
var
    BufTmp : TBytes;
    BufPtr : Integer;
    Bytes  : Word;
    I      : Integer;
begin
    SetLength(BufTmp, MaxBufSize);
    BufPtr := 0;
    repeat
        if BufSize > MaxBufSize then
            Bytes := MaxBufSize
        else
            Bytes := BufSize;
        for I := 0 to Bytes - 1 do
            BufTmp[I] := Buffer[BufPtr + I];
        Inc(BufPtr, Bytes);
        Dec(BufSize, Bytes);
        if Bytes > 0 then
            MD5Update(MD5Context, BufTmp, Bytes);
    until Bytes < MaxBufSize;
end;

procedure MD5UpdateBuffer(
    var MD5Context : TMD5Context;
    const Buffer   : String);
var
    BufTmp : TBytes;
    Bytes  : Integer;
    I      : Integer;
begin
    Bytes := Length(Buffer);
    if Bytes > 0 then begin
        SetLength(BufTmp, Bytes);
        for I := 0 to Bytes - 1 do
            BufTmp[I] := Ord(Buffer[I]);
        MD5Update(MD5Context, BufTmp, Bytes);
    end;
end;

{$ELSE}
procedure MD5UpdateBuffer(
    var MD5Context: TMD5Context;
    Buffer: Pointer;
    BufSize: Integer);
var
    BufTmp : PMD5Buffer;
    BufPtr : PAnsiChar; { AG V6.12 !! }
    Bytes  : Word;
begin
    New(BufTmp);
    BufPtr := Buffer;
    try
        repeat
            if BufSize > MaxBufSize then
                Bytes := MaxBufSize
            else
                Bytes := BufSize;
            Move(BufPtr^, BufTmp^, Bytes);
            Inc(BufPtr, Bytes);
            Dec(BufSize, Bytes);
            if Bytes > 0 then
                MD5Update(MD5Context, BufTmp^, Bytes);
        until Bytes < MaxBufSize;
    finally
        Dispose(BufTmp);
    end;
end;

procedure MD5UpdateBuffer(
    var MD5Context : TMD5Context;
    const Buffer   : AnsiString);
begin
    MD5UpdateBuffer(MD5Context, Pointer(Buffer), Length(Buffer));
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure MD5UpdateBuffer(
    var MD5Context: TMD5Context;
    const Buffer: TMD5Digest);
{$IFDEF SAFE}
var
    Buf: TBytes;
    I : Integer;
{$ENDIF}
begin
{$IFDEF SAFE}
    SetLength(Buf, 16);
    for I := 0 to 15 do
        Buf[I] := Buffer[I];
    MD5Update(MD5Context, Buf, 16);
{$ELSE}
    MD5Update(MD5Context, Buffer[0], 16);
{$ENDIF}
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFNDEF SAFE}
function MD5DigestToHex (const MD5Digest: TMD5Digest): AnsiString;  { V7.01 }
const
    HexTable : array[0..15] of AnsiChar =
    ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var
    I : Integer;
    P : PAnsiChar;
begin
    SetLength(Result, SizeOf(TMD5Digest) * 2);
    P := PAnsiChar(Result);
    for I := Low(MD5Digest) to High(MD5Digest) do begin
        P[I * 2]     := HexTable[(MD5Digest[I] shr 4) and 15];
        P[I * 2 + 1] := HexTable[MD5Digest[I] and 15];
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function MD5DigestToLowerHexA(const MD5Digest: TMD5Digest): RawByteString;
const                                                  { V7.01 } { V7.02 }
    HexTable : array[0..15] of AnsiChar =
    ('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f');
var
    I : Integer;
    P : PAnsiChar;
begin
    SetLength(Result, SizeOf(TMD5Digest) * 2);
    P := PAnsiChar(Result);
    for I := Low(MD5Digest) to High(MD5Digest) do begin
        P[I * 2]     := HexTable[(MD5Digest[I] and $F0) shr 4];
        P[I * 2 + 1] := HexTable[MD5Digest[I] and $0F];
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function MD5DigestToLowerHex(const MD5Digest: TMD5Digest): String;   { V7.01 }
const
    HexTable : array[0..15] of Char =
    ('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f');
var
    I : Integer;
    P : PChar;
begin
    SetLength(Result, SizeOf(TMD5Digest) * 2);
    P := PChar(Result);
    for I := Low(MD5Digest) to High(MD5Digest) do begin
        P[I * 2]     := HexTable[(MD5Digest[I] and $F0) shr 4];
        P[I * 2 + 1] := HexTable[MD5Digest[I] and $0F];
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure HMAC_MD5(const Buffer; BufferSize: Integer; const Key; KeySize: Integer;   { V7.01 }
    out Digest: TMD5Digest);  {See RFC2104 }
var
    Context : TMD5Context;
    IPAD    : array [0..63] of Byte;
    OPAD    : array [0..63] of Byte;
    I       : Integer;
    PKey    : PByte;
begin
    { If key is longer than 64 bytes reset it to key = MD5(key) } { V7.03 }
    if KeySize > 64 then begin
        MD5Init(Context);
        MD5Update(Context, Key, KeySize);
        MD5Final(Digest, Context);
        KeySize := 16;
        PKey := @Digest[0];
    end
    else
        PKey := @Key;

    for I := Low(IPAD) to High(IPAD) do begin
        if (I + 1) <= KeySize then begin
            IPAD[I] := PKey^ xor $36;
            OPAD[I] := PKey^ xor $5C;
            Inc(PKey);
        end
        else begin
            IPAD[I] := 0 xor $36;
            OPAD[I] := 0 xor $5C;
        end;
    end;

    MD5Init(Context);
    MD5Update(Context, IPAD, 64);
    MD5UpdateBuffer(Context, @Buffer, BufferSize);
    MD5Final(Digest, Context);
    MD5Init(Context);
    MD5Update(Context, OPAD, 64);
    MD5Update(Context, Digest, 16);
    MD5Final(Digest, Context);
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure MD5DigestInit (var MD5Digest: TMD5Digest);
var
    I: integer;
begin
     for I := 0 to 15 do
         MD5Digest[I] := I + 1;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetMD5(
{$IFDEF SAFE}
    const Buffer: TBytes;
{$ELSE}
    Buffer: Pointer;
{$ENDIF}
    BufSize: Integer): AnsiString;
var
    MD5Digest  : TMD5Digest;
    MD5Context : TMD5Context;
begin
    Result := '';
    MD5DigestInit(MD5Digest);  { V6.09 }
    MD5Init(MD5Context);
    MD5UpdateBuffer(MD5Context, Buffer, BufSize);
    MD5Final(MD5Digest, MD5Context);
    Result := MD5DigestToHex(MD5Digest);  { V6.09 }
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StrMD5(Buffer : String): String;
{$IFDEF COMPILER12_UP}
begin
    // No a real unicode MD5 computation ! Should be updated !!
    Result := String(StrMD5(AnsiString(Buffer)));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StrMD5(Buffer : AnsiString): AnsiString;
{$ENDIF}
{$IFDEF SAFE}
var
    Bytes : TBytes;
    I     : Integer;
    Ch    : Integer;
begin
    SetLength(Bytes, Length(Buffer));
    for I := 0 to Length(Buffer) - 1 do begin
        Ch       := Ord(Buffer[I + 1]);
        if Ch > 255 then
            raise Exception.Create('StrMD5 works only on ascii strings');
        Bytes[I] := Ch;
    end;
    Result := GetMD5(Bytes, Length(Buffer));
end;
{$ELSE}
begin
    Result := GetMD5(@Buffer[1], Length(Buffer));
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}  { V6.09 }
procedure StreamMD5Context(Stream: TStream; Obj: TObject; ProgressCallback : TMD5Progress;
                      StartPos, EndPos: Int64; var MD5Context: TMD5Context);
const
    ChunkSize : Cardinal = 102400;
var
    J          : Integer;
    Num        : Integer;
    Rest       : Integer;
    Buf        : TBytes;
    Cancel     : Boolean;
    FSize      : Int64;
begin
    { Allocate buffer to read file }
    SetLength(Buf, ChunkSize);

    { V6.05 calculate how much of the file we are processing }
    FSize := Stream.Size;
    if (StartPos >= FSize) then StartPos := 0;
    if (EndPos > FSize) or (EndPos = 0) then EndPos := FSize;

    { Calculate number of full chunks that will fit into the buffer }
    Num  := EndPos div ChunkSize;
    { Calculate remaining bytes }
    Rest := EndPos mod ChunkSize;

    { Set the stream to the beginning of the file }
    Stream.Position := StartPos;

    { Process full chunks }
    Cancel := FALSE;
    for J := 0 to Num - 1 do begin
        Stream.Read(buf{$IFNDEF CLR}[0]{$ENDIF}, ChunkSize);
        MD5UpdateBuffer(MD5Context, buf, ChunkSize);
        if Assigned(ProgressCallback) then begin
            ProgressCallback(Obj, Stream.Position, Cancel);   { V6.03 }
            if Cancel then
                Exit;
        end;
    end;

    { Process remaining bytes }
    if Rest > 0 then begin
        Stream.Read(buf{$IFNDEF CLR}[0]{$ENDIF}, Rest);
        MD5UpdateBuffer(MD5Context, buf, Rest);
    end;

end ;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}  { V6.09 }
function StreamMD5(Stream: TStream; Obj: TObject; ProgressCallback : TMD5Progress;
                                                  StartPos, EndPos: Int64): AnsiString;
var
    MD5Digest  : TMD5Digest;
    MD5Context : TMD5Context;
begin
    Result := '';
    MD5DigestInit (MD5Digest);
    MD5Init(MD5Context);
    StreamMD5Context(Stream, Obj, ProgressCallback, StartPos, EndPos, MD5Context);
    MD5Final(MD5Digest, MD5Context);
    Result := MD5DigestToHex(MD5Digest);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}  { V6.05 }
function FileMD5(
    const Filename   : String;
    Obj              : TObject;
    ProgressCallback : TMD5Progress;
    StartPos, EndPos : Int64;              { V6.05 }
    Mode: Word = DefaultMode) : AnsiString;    { V6.06 }
var
    Stream     : TFileStream;
begin
    Result := '';
    { Open file }
    Stream := TFileStream.Create(Filename, Mode);  { V6.06 not necessarily share locked }
    try
        Result := StreamMD5(Stream, Obj, ProgressCallback, StartPos, EndPos); { V6.09 }
    finally
        { Free the file }
        Stream.Free;
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function FileMD5(const Filename: String; Mode: Word = DefaultMode) : AnsiString;    { V6.06 }
begin
    Result := FileMD5 (FileName, 0, 0, Mode);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function FileMD5(const Filename: String; StartPos, EndPos: Int64;
                                    Mode: Word = DefaultMode) : AnsiString;    { V6.06 }
begin
    Result := FileMD5(Filename, Nil, Nil, StartPos, EndPos, Mode);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}  { V6.05 }
function FileMD5(const Filename: String; Obj: TObject;
    ProgressCallback : TMD5Progress; Mode: Word = DefaultMode) : AnsiString;    { V6.06 }
begin
    Result := FileMD5(Filename, Obj, ProgressCallback, 0, 0, Mode);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function FileListMD5(FileList: TStringList; Obj: TObject;
    ProgressCallback : TMD5Progress; Mode: Word = DefaultMode) : AnsiString;    { V6.06 }
var
    K          : Integer;
    MD5Digest  : TMD5Digest;
    MD5Context : TMD5Context;
    Stream     : TFileStream;
    Cancel     : Boolean;
begin
    Result := '';
    if NOT Assigned (FileList) then exit;
    if FileList.Count = 0 then exit;

   { files must be processed in same order to match md5sum, so sort case insensitive }
    for K := 0 to FileList.Count - 1 do FileList [K] := Lowercase (FileList [K]) ;
    FileList.Sort ;

   { Initialize MD5 engine }
    MD5DigestInit (MD5Digest);     { V6.09 }
    MD5Init(MD5Context);

    { process each file in list }
    for K := 0 to FileList.Count - 1 do begin

    { Open file }
        if Assigned(ProgressCallback) then begin
            ProgressCallback(Obj, 0, Cancel);   { V6.03 }
            if Cancel then
                Exit;
        end;
        Stream := TFileStream.Create(FileList [K], Mode);
        try
            StreamMD5Context(Stream, Obj, ProgressCallback, 0, 0, MD5Context);   { V6.09 }
        finally
            { Free the file }
            Stream.Free;
        end;
    end;
    { Finalize MD5 calculation }
    MD5Final(MD5Digest, MD5Context);
    Result := MD5DigestToHex(MD5Digest);    { V6.09 }
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function MD5GetBufChar(const MD5Context : TMD5Context; Index : Integer) : Byte;
var
    L : LongInt;
begin
    L := MD5Context.BufLong[Index shr 2];
    case Index and 3 of
    0: Result := (L shr  0) and 255;
    1: Result := (L shr  8) and 255;
    2: Result := (L shr 16) and 255;
    3: Result := (L shr 24) and 255;
    else
       raise ERangeError.Create('MD5GetBufChar range exception');
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure MD5SetBufChar(
    var MD5Context : TMD5Context;
    Index          : Integer;
    Value          : Byte);
var
    L : LongInt;
begin
    L := MD5Context.BufLong[Index shr 2];
    case Index and 3 of
    0: L := (L and $FFFFFF00) or Value;
    1: L := (L and $FFFF00FF) or (Value shl 8);
    2: L := (L and $FF00FFFF) or (Value shl 16);
    3: L := (L and $00FFFFFF) or (Value shl 24);
    else
       raise ERangeError.Create('MD5SetBufChar range exception');
    end;
    MD5Context.BufLong[Index shr 2] := L;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure MD5MoveToBufChar(
    var MD5Context : TMD5Context;
    const Data {$IFDEF SAFE}: TBytes{$ENDIF};
    Offset         : Integer;
    Index          : Integer;
    Len            : Integer);
{$IFDEF SAFE}
var
    I : Integer;
begin
    for I := Index to Index + Len - 1 do
        MD5SetBufChar(MD5Context, I, Data[Offset + I]);
end;
{$ELSE}
begin
    Move(Data, MD5Context.BufChar[Index], Len);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure MD5FillBufChar(
    var MD5Context : TMD5Context;
    Index          : Integer;
    Count          : Integer;
    Value          : Byte);
{$IFDEF SAFE}
var
    I : Integer;
begin
    for I := Index to Index + Count - 1 do
        MD5SetBufChar(MD5Context, I, Value);
end;
{$ELSE}
begin
    FillChar(MD5Context.BufChar[Index], Count, Value);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure MD5ContextClear(var MD5Context : TMD5Context);
{$IFDEF SAFE}
var
    I : Integer;
begin
    MD5Context.State[0] := 0;
    MD5Context.State[1] := 0;
    MD5Context.State[2] := 0;
    MD5Context.State[3] := 0;
    MD5Context.Count[0] := 0;
    MD5Context.Count[1] := 0;
    for I := Low(MD5Context.BufLong) to High(MD5Context.BufLong) do
        MD5Context.BufLong[I] := 0;
end;
{$ELSE}
begin
    FillChar(MD5Context, SizeOf(TMD5Context), #0);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure MD5MoveStateToDigest(
    const State  : TMD5State;
    var   Digest : TMD5Digest);
{$IFDEF SAFE}
var
    I, J : Integer;
begin
    for I := Low(State) to High(State) do begin
        for J := 0 to 3 do begin    // 4 bytes per LongInt
            case J of
            0: Digest[(I shl 2) + J] := ((State[I] shr  0) and $000000FF);
            1: Digest[(I shl 2) + J] := ((State[I] shr  8) and $000000FF);
            2: Digest[(I shl 2) + J] := ((State[I] shr 16) and $000000FF);
            3: Digest[(I shl 2) + J] := ((State[I] shr 24) and $000000FF);
            end;
        end;
    end;
end;
{$ELSE}
begin
    Move(State, Digest, 16)
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function MD5SameDigest(const D1, D2: TMD5Digest): Boolean; { V7.02 }
var
    I : Integer;
begin
    Result := FALSE;
    for I := Low(D1) to High(D1) do      { V7.02 }
        if D1[I] <> D2[I] then
            Exit;
    Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF MD5_SELF_TEST}
const
    // Strings to test MD5. Expected checksums are below.
    // If you change strings, be sure tochange also expected checksums.
    MD5TestStrings : array [0..6] of String = (
        '' ,
        'a' ,
        'abc' ,
        'message digest' ,
        'abcdefghijklmnopqrstuvwxyz' ,
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ,
        '12345678901234567890123456789012345678901234567890123456789012' +
        '345678901234567890');

    // Expected MD5 checksum for the above strings
    MD5TestResults : array [0..6] of String = (
        'D41D8CD98F00B204E9800998ECF8427E',
        '0CC175B9C0F1B6A831C399E269772661',
        '900150983CD24FB0D6963F7D28E17F72',
        'F96B697D7CB7938D525A2F31AAF161D0',
        'C3FCD3D76192E4007DFB496CCA67E13B',
        'D174AB98D277D9F5A5611C2C9F419D9F',
        '57EDF4A22BE3C955AC49DA2E2107B67A');


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function MD5SelfTest(Verbose : Boolean) : Boolean;
var
    I      : Integer;
    MD5Sum : String;
    Buf    : String;
begin
    for I := 0 to 6 do begin
        if Verbose then
            Buf := 'MD5 test #' + IntToStr(I + 1) + ': ';
        MD5Sum := StrMD5(MD5TestStrings[I]);
        if not SameText(MD5Sum, MD5TestResults[I]) then begin
            if Verbose then
                Form1.Memo1.Lines.Add(Buf + 'failed');
            Result := TRUE;
            Exit;
        end;
        if Verbose then
            Form1.Memo1.Lines.Add(Buf + 'passed');
    end;
    Result := FALSE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TForm1.RunButtonClick(Sender: TObject);
begin
    Form1.Memo1.Clear;
    if MD5SelfTest(TRUE) then
        Form1.Memo1.Lines.Add('MD5 library failed')
    else
        Form1.Memo1.Lines.Add('MD5 library passed');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$ENDIF}

end.

