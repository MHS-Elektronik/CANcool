{****************************************************************************}
{ Unit:    AboutDialog                                                       }
{ Class:   TAboutDialog                                                      }
{ Version: 1.0                                                               }
{ Purpose: Borland-Style about dialog box with additional features           }
{ Authpr:  Ian Huang                                                         }
{ E-Mail:  ian@jigsaw.com.au                                                }
{ Date:    11/01/1997                                                        }
{****************************************************************************}
unit XLAboutDialog;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFDEF FPC}
  LResources,
{$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls,
  Dialogs, XLAbout;

type
  TXLAboutDialog = class(TComponent)
  private
    FCompany, FProductName, FVersion, FCopyright, FURL, FEMAIL: string;
    FKompLines, FLizenzLines: TStrings;
    procedure SetFKompLines(text: TStrings);
    procedure SetFLizenzLines(text: TStrings);
  protected
  public
    function Execute: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Company: string read FCompany write FCompany;
    property ProductName: string read FProductName write FProductName;
    property Version: string read FVersion write FVersion;
    property Copyright: string read FCopyright write FCopyright;
    property URL: string read FURL write FURL;
    property EMail: string read FEMail write FEMail;
    property Komponenten: TStrings read FKompLines write SetFKompLines;
    property Lizenz: TStrings read FLizenzLines write SetFLizenzLines;
  end;

var
  XLAboutBox: TXLAboutBox;

procedure Register;

implementation

constructor TXLAboutDialog.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  FKompLines := TStringList.Create;
  FLizenzLines := TStringList.Create;
  Company := 'Your Company Name';
  ProductName := '';
  VERSION := 'Version';
  Copyright := 'Copyright Info';
  URL := 'Youe Web Site';
  EMail := 'Your E-Mail Address Here';
end;


destructor TXLAboutDialog.Destroy;

begin
if Assigned(FKompLines)
  then FreeAndNil(FKompLines);
if Assigned(FLizenzLines)
  then FreeAndNil(FLizenzLines);
inherited;
end;


procedure TXLAboutDialog.SetFKompLines(text: TStrings);

begin
if Assigned(FKompLines) then 
  FKompLines.Assign(text)
else
  FKompLines := text;
end;


procedure TXLAboutDialog.SetFLizenzLines(text: TStrings);

begin
if Assigned(FLizenzLines) then 
  FLizenzLines.Assign(text)
else
  FLizenzLines := text;
end;


function TXLAboutDialog.Execute: Boolean;

begin
  XLAboutBox := TXLAboutBox.Create(Application);
  if ProductName = '' then ProductName := Application.Title;
  try
    // Set dialog strings
    XLAboutBox.Company.Caption := Company;
    XLAboutBox.ProductName1.Caption := ProductName;
    XLAboutBox.ProductName2.Caption := ProductName;
    XLAboutBox.ProductName3.Caption := ProductName;
    XLAboutBox.VERSION.Caption := 'Version: ' + VERSION;
    XLAboutBox.Copyright.Caption := Copyright;
    XLAboutBox.URL.Caption := URL;
    XLAboutBox.EMail.Caption := EMail;
    XLAboutBox.Caption := 'Info über ' + ProductName;
    XLAboutBox.CompView.Lines.Text := FKompLines.Text;
    XLAboutBox.LizenzView.Lines.Text := FLizenzLines.Text;
    with XLAboutBox do
      begin
      ProgramIcon.Picture.Graphic := Application.ICON;
      Result := (ShowModal = IDOK);
      end;
  finally
    XLAboutBox.Free;
  end;
end;


procedure Register;
begin
{$IFDEF FPC}
  {$I XLAboutDialog.lrs}
{$ENDIF}
RegisterComponents('MHS',[TXLAboutDialog]);
end;

end.

