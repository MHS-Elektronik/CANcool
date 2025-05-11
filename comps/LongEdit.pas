{***************************************************************************
                        zahlen32.pas  -  description
                             -------------------
    begin             : 19.06.2022                                        
    last modify       : 05.04.2023                                        							    
    copyright         : (C) 2022 - 2023 MHS-Elektronik GmbH & Co. KG, Germany
                               http://www.mhs-elektronik.de    
    author            : Klaus Demlehner, klaus@mhs-elektronik.de
 ***************************************************************************}

{***************************************************************************
 *                                                                         *
 *   This program is free software, you can redistribute it and/or modify  *
 *   it under the terms of the MIT License <LICENSE.TXT or                 *
 *   http://opensource.org/licenses/MIT>                                   *              
 *                                                                         *
 ***************************************************************************}
unit LongEdit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

// Messages <*> raus
uses
{$IFnDEF FPC}
  WinProcs, WinTypes,
{$ELSE}
  LResources, LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, StdCtrls;

type
  TLongIntEdit = class(TEdit)
  protected
    function AsInt : longint;
    procedure SetInt(i : longint);
  published
    property Number : longint read AsInt write SetInt;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
{$IFDEF FPC}
  {$I LongEdit.lrs}
{$ENDIF} 
  RegisterComponents('MHS', [TLongIntEdit]);
end;

function TLongIntEdit.AsInt : longint;
begin
  try
    Result:=StrToInt(Text);
  except
    on EConvertError do
      Result:=0;
  end;
end;

procedure TLongIntEdit.SetInt(i : longint);
begin
  Text:=IntToStr(i);
end;

end.
