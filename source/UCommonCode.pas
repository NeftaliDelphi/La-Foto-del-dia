unit UCommonCode;

//==============================================================================
//
//  I N T E R F A C E
//
//==============================================================================
interface

uses
  System.Types, System.SysUtils,
  FMX.Effects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Graphics;

// Obtener a partir del nombre de fichero, el de la minitatura
// Get the new name for the thumbnail of the image
function GetMiniaturaFileName(AFileName:string):string;

// Grabar un bitmap al que se le ha aplicado un efecto  // Save the image with effect applied
procedure SaveBitmapWithEffect(const Image:TImage; EfectoApliado:TFilterEffect; const FileName:string);
// Abrir la página web con el programa por defecto   // open the webpage with default app
procedure OpenWebPage(sURL:String);

// various constants
const
  STR_TITLE = '     La foto del día';
const
  STR_EMPTY = '';
const
  PREFIX_MINIATURA = '_mini';
const
  API_KEY = 'GtbpAJbjkWgQMEtSeaw8q8tevzwDP2TXwPuOFbmk';
  BASE_URL = 'https://api.nasa.gov/planetary/apod?api_key=';
  LINK_CONTEST = 'https://community.embarcadero.com/blogs/entry/nasa-apis-mashup-competition';
  NASA_API_LINK = 'https://api.nasa.gov/index.html';
  DELPHI_LINK = 'https://www.embarcadero.com/products/delphi';
  LINK_GERMAN = 'http://neftali.clubdelphi.com/about/';
  LINK_BLOG = 'http://neftali.clubdelphi.com/';

//==============================================================================
//
//  I M P L E M E N T A C I O N
//
//==============================================================================
implementation

uses
{$IFDEF ANDROID}
  Androidapi.Helpers, FMX.Helpers.Android, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.App, Androidapi.JNI.Net, Androidapi.JNI.JavaTypes,
{$ENDIF ANDROID}
{$IFDEF MSWINDOWS}
  Winapi.ShellAPI,
{$ENDIF MSWINDOWS}
  FMX.Dialogs, FMX.Types, System.StrUtils;


// Thanks to  http://www.fmxexpress.com/
// Grabar la imagen conel efecto aplicado   // Save the image with applies effect
procedure SaveBitmapWithEffect(const Image:TImage; EfectoApliado:TFilterEffect; const FileName: string);
var
  Temp: TBitmap;
begin
  Temp := TBitmap.Create;
  try
    Temp.Assign(Image.Bitmap);
    //  EfectoNegativo.ProcessEffect(Image1.Bitmap.Canvas, Image2.Bitmap, 0);
    EfectoApliado.ProcessEffect(Image.Bitmap.Canvas, Temp, 0);
    Temp.SaveToFile(FileName);
  finally
    Temp.DisposeOf;
  end;
end;



// Obtener a partir del nombre de fichero, el de la minitatura 
function GetMiniaturaFileName(AFileName:string):string;
var
  ext:string;
begin
  Result := AFileName;
  // No contiene el prefijo?
  if not AnsiContainsText(AFileName, PREFIX_MINIATURA) then begin
    ext := ExtractFileExt(AFileName);
    Result := ChangeFileExt(AFileName, PREFIX_MINIATURA + ext);
  end;
end;


// Abrir la página web con el programa por defecto   // open the webpage with default app
procedure OpenWebPage(sURL:String);
{$IFDEF ANDROID}
var
  Intent: JIntent;
{$ENDIF ANDROID}
begin
{$IFDEF MSWINDOWS}
  ShellExecute(0, 'OPEN', PChar(sURL), '', '', 0);
{$ENDIF MSWINDOWS}
{$IFDEF ANDROID}
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(StrToJURI(sURL));
  TAndroidHelper.Activity.startActivity(Intent);
{$ENDIF ANDROID}
end;


end.
