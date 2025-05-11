{***************************************************************************
                        CanCoolDefs.pas  -  description
                             -------------------
    begin             : 25.12.2021
    last modified     : 31.12.2021      
    copyright         : (C) 2021 by MHS-Elektronik GmbH & Co. KG, Germany
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
unit CanCoolDefs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, IniFiles, util;
  
const
  RX_WIN_COMMAND           = $1000;

  RX_WIN_SHOW_TRACE        = $1001;
  RX_WIN_SHOW_OBJECT       = $1002;
  RX_WIN_CLEAR             = $1003;
  RX_WIN_SAVE_TRACE        = $1004;
  RX_WIN_SHOW_RX_PANNEL    = $1005;
  RX_WIN_HIDE_RX_PANNEL    = $1006;
  RX_WIN_STAT_CLEAR        = $1007;
  RX_WIN_SHOW_ALL_MSG      = $1008;
  RX_WIN_SHOW_USED_MSG     = $1009;
  RX_WIN_SHOW_UNUSED_MSG   = $100A;
  RX_WIN_START_TRACE       = $100B;
  RX_WIN_STOP_TRACE        = $100C;
  
  TX_WIN_COMMAND           = $2000;
  
  TX_WIN_SAVE              = $2001;
  TX_WIN_LOAD              = $2002;
  TX_WIN_CLEAR             = $2003;
  TX_WIN_ENABLE_INTERVALL  = $2004;
  TX_WIN_DISABLE_INTERVALL = $2005;
  TX_WIN_ADD_MESSAGE       = $2006;
  TX_WIN_UPDATE_MSG        = $2007;
  TX_WIN_SAVE_FILE         = $2008;
  TX_WIN_LOAD_FILE         = $2009; 
  
  SYS_COMMAND              = $8000;
  
  SYS_CMD_SET_SETUP        = $8001;
  SYS_CMD_PRJ_LOAD_FINISH  = $8002;
  

  CanBusStatusStr: array[0..3] of String = ('Bus Ok',
                                            'Error Warn.',
                                            'Error Passiv',
                                            'Bus Off!');
                                           
  CanErrorsStr: array[1..6] of String = ('Stuff Error',
                                         'Form Error',
                                         'Ack Error',
                                         'Bit1 Error',
                                         'Bit0 Error',
                                         'CRC Error');

  RxviewCanTraceHeaders: array[0..5,0..1] of String = (('Time [s.ms]',  'XXXXXX.XXX'),
                                                       ('Frame',        'STD/RTR FD/BRS'),         
                                                       ('ID',           '12345678'),               
                                                       ('DLC',          '64'),
                                                       ('DATA [HEX]',   'XX XX XX XX XX XX XX XX'),
                                                       ('DATA [ASCII]', 'AAAAAAAA')); 
                                                       
  RxViewCanObjHeaders: array[0..6,0..1] of String = (('Anzahl',        'XXXXXXXXXX'),
                                                     ('Period [s.ms]', 'XXXXXX.XXX'),
                                                     ('Frame',         'STD/RTR FD/BRS'),
                                                     ('ID',            '12345678'),
                                                     ('DLC',           '64'),
                                                     ('DATA [HEX]',    'XX XX XX XX XX XX XX XX'),
                                                     ('DATA [ASCII]',  'AAAAAAAA'));
                                                        

  TxViewHeaders: array[0..8,0..1] of String = (('Frame',      'STD/RTR  FD/BRS'),
                                               ('ID',         '12345678'),
                                               ('DLC',        '64'),
                                               ('DATA [HEX]', 'XX XX XX XX XX XX XX XX'),
                                               ('Auto',       'Periodic'),
                                               ('Intervall',  'XXXXXX'),
                                               ('Trigger ID', '12345678'),
                                               ('Komentar',   'XXXXXXXXXXXXXXXXXXXXXXXXX'),
                                               ('Senden',     '-Senden-'));

  DefaultFont: TFontDesc = (Name: 'Courier New'; Size: 12; Style: []);                                               
                                                                                              
                                             
type
  TRxMsgShowMode = (RxMsgShowAll, RxMsgShowUsed, RxMsgShowUnused);
  
implementation                                           
                                         
end.                                           
  
  