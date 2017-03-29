unit UTThreadImage;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
//  Vcl.Imaging.jpeg,
{$ENDIF}
  SysUtils, Variants, Classes,
  IdHTTP, IdIOHandlerSocket, IdSSLOpenSSL, IdIOHandler;

type
  {: Clase para descargar una imagen y almacenarla en disco.}
  TDownImageThread = class(TThread)
  private
    FURLImage: string;
    FPathImage: string;
    FFileNameImage: string;
    // Internas
    ImageName: string;
    PathURL: string;
    // Componente
    idH:TidHTTP;
    IdSSL:TIdSSLIOHandlerSocketOpenSSL;
  public
    // redefinir métodos
    constructor  Create(AURL:string; AOutPathImages:string);
    destructor Destroy; override;
    procedure Execute; override;
    {: URL de la imagen a descargar. }
    property URLImage:string read FURLImage write FURLImage;
    {: Path de disco local donde voy a almacenar la imagen.}
    property PathImage:string read FPathImage;
    {: Nombre completa (path+Nombre) de la imagen almacenada en disco local}
    property FileNameImage:string read FFileNameImage;
  end;

const
  STR_EMPTY = '';

implementation

uses
  IdURI, System.StrUtils;

{ TDownImageThread }
constructor TDownImageThread.Create(AURL, AOutPathImages: string);
var
  URI:TidURI;
begin

  // crear el thread suspendido
  inherited Create(True);
  // Parámetros: URL y dir de salida
  Self.FURLImage := AURL;
  Self.FPathImage := AOutPathImages;
  // Procesar a URL
  URI := TidURI.Create(AURL);
  try
    ImageName := URI.Document;
    PathURL := URI.Path;
  finally
    URI.Free;
  end;
end;

destructor TDownImageThread.Destroy;
begin
  inherited;
end;

//: recupara la imagen y la guarda en disco
procedure TDownImageThread.Execute();
var
  Stream:TFileStream;
  IdH:TidHTTP;
  path:string;
  dir:string;
begin
  // Directorio de salida
  //--dir := AnsiReplaceText(PathURL, '/', STR_EMPTY);
  // Nombre vacío
  if (ImageName = STR_EMPTY) then begin
    Exit;
  end;
  // Path de salida
  path := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(PathImage) + dir) + ImageName;

  // si existe, la cargamos desde disco...
  if FileExists(path) then begin
    FFileNameImage := path;
    Exit;
  end;

  // Crearlo por si no existe
  ForceDirectories(ExtractFilePath(path));
  try
    // Stream para la imagfen
    Stream  := TFileStream.Create(path, fmCreate);
    try

      // Crear componente para acceder
      IdH := TidHttp.Create(nil);
      IdH.AllowCookies := True;
      IdH.ReadTimeout := 30000;
      IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      IdH.IOHandler := IdSSL;
      IdSSL.SSLOptions.Method := sslvTLSv1_2;
      IdSSL.SSLOptions.Mode := sslmUnassigned;
      idH.HandleRedirects := True;
      IdH.RedirectMaximum := 3;
      // proteccion
      try
        FURLImage := AnsiReplaceText(FURLImage, 'http', 'https');
        IdH.Get(Trim( FURLImage), Stream);
      except
        // Error al descargar la imagen
        //..  Volcarlo al log
      end;
    finally
      // Liberar
      idH.Free;
      Stream.Free;
    end;
    // Path de salida
    FFileNameImage := path;
  except
    // error al crear el fichero
    //...  Log
  end;
end;



end.
