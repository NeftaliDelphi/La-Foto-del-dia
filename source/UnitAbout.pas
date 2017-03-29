unit UnitAbout;

//==============================================================================
//
//  I N T E R F A C E
//
//==============================================================================
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    lblNasa: TPanel;
    imgNasa: TImage;
    lblNASALink: TLabel;
    pnlCentral: TPanel;
    pnlGerman: TPanel;
    imgGerman: TImage;
    pnlDatos: TPanel;
    lblCopyright: TLabel;
    lblWeb: TLabel;
    lblMail: TLabel;
    lblAbout: TLabel;
    imgWeb: TImage;
    imgMail: TImage;
    pnlPowered: TPanel;
    pnlInferior: TPanel;
    imgPowered: TImage;
    lblNASAAPILink: TLabel;
    pnlFondo: TPanel;
    procedure lblWebClick(Sender: TObject);
    procedure lblMailClick(Sender: TObject);
    procedure lblNASALinkClick(Sender: TObject);
    procedure lblNASAAPILinkClick(Sender: TObject);
    procedure CloseEvent(Sender: TObject);
    procedure imgPoweredClick(Sender: TObject);
    procedure imgGermanClick(Sender: TObject);
    procedure lblNASALinkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure lblNASAAPILinkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure lblWebMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure lblMailMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  
//==============================================================================
//
//  I M P L E M E N T A C I O N
//
//==============================================================================  
implementation

{$R *.fmx}

uses
  UCommonCode;


procedure TForm1.imgGermanClick(Sender: TObject);
begin
  OpenWebPage(LINK_GERMAN);
end;

procedure TForm1.imgPoweredClick(Sender: TObject);
begin
  OpenWebPage(DELPHI_LINK);
end;

procedure TForm1.lblMailClick(Sender: TObject);
begin
  OpenWebPage('mailto:' + lblMail.Text);
end;

procedure TForm1.lblMailMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  OpenWebPage('mailto:' + lblMail.Text);
end;

procedure TForm1.lblNASAAPILinkClick(Sender: TObject);
begin
  OpenWebPage(NASA_API_LINK);
end;

procedure TForm1.lblNASAAPILinkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  OpenWebPage(NASA_API_LINK);
end;

procedure TForm1.CloseEvent(Sender: TObject);
begin
  Self.Close;
end;

procedure TForm1.lblNASALinkClick(Sender: TObject);
begin
  OpenWebPage(LINK_CONTEST);
end;

procedure TForm1.lblNASALinkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  OpenWebPage(LINK_CONTEST);
end;

procedure TForm1.lblWebClick(Sender: TObject);
begin
  OpenWebPage(lblWeb.Text);
end;

procedure TForm1.lblWebMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  OpenWebPage(lblWeb.Text);
end;

end.
