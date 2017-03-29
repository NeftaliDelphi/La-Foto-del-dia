unit frImagen;

//==============================================================================
//
//  I N T E R F A C E
//
//==============================================================================
interface

uses
  UDownloadThread,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, System.Actions, FMX.ActnList,
  FMX.StdActns, FMX.MediaLibrary.Actions, FMX.ScrollBox, FMX.Memo,
  System.ImageList, FMX.ImgList, FMX.Ani, FMX.Effects, FMX.Filter.Effects;

type
  TFrameImagen = class;
  // Tipo de recursos // Resource types
  TMediaType = (mtFoto, mtVideo, mtError);
  // Estados para el Frame // Frame states
  TFrameStates = (feDownloading, feDiskLoaded, feDownloaded, feMaximized);
  TFrameState = set of TFrameStates;
  // Tipo para el evento OnMaximize
  TMaximizeEvent = procedure(aValue:boolean) of object;
  // Tipo para el evento de vsualizar info.
  TViewInfo = TMaximizeEvent;

  TFrameImagen = class(TFrame)
    Panel1: TPanel;
    Panel3: TPanel;
    pnlImagen: TRectangle;
    img: TImage;
    aniDescarga: TAniIndicator;
    lblFecha: TLabel;
    Button1: TButton;
    btnInfo: TButton;
    btnShare: TButton;
    lblTitulo: TLabel;
    ActionList1: TActionList;
    ShowShareSheetAction1: TShowShareSheetAction;
    ViewAction1: TViewAction;
    ViewAction2: TViewAction;
    pnlTitulo: TPanel;
    mmExpl: TMemo;
    btnMaximize: TButton;
    ImageList1: TImageList;
    Button2: TButton;
    btnRefresh: TButton;
    lblPorcentaje: TLabel;
    btnLoad: TButton;
    TimerLoadImage: TTimer;
    FloatAnimOpacy: TFloatAnimation;
    FloatAnimScaleX: TFloatAnimation;
    FloatAnimScaleY: TFloatAnimation;
    btnEdit: TButton;
    ContrastEffect1: TContrastEffect;
    procedure btnInfoClick(Sender: TObject);
    procedure mmExplClick(Sender: TObject);
    procedure imgDblClick(Sender: TObject);
    procedure btnShareClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure TimerLoadImageTimer(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    fFecha: TDate;
    fKey: string;
    th: TDownloadThread;
    FURLImagen: string;
    FMediaType: TMediaType;
    FBigImage: TImage;
    FTitulo: string;
    FExplanation: string;
    FFilename: string;
    FOnEditImage: TNotifyEvent;
    FFrameState: TFrameState;
    FOnMaximize: TMaximizeEvent;
    FOnViewInfo: TViewInfo;

    procedure SetFecha(const Value: TDate);
    procedure SetExplanation(const Value: string);
    procedure SetTitulo(const Value: string);
    procedure EndDownload(const Sender: TObject; AStatus: Integer);
    procedure TerminateThread(Sender: TObject);
    procedure InternalLoadImage();
    procedure ActivateLoadImage();

    // Directorio o ubiucacion donde se guardan las imagenes // Image directory
    function GetDirectorioImagenes():string;
    // Activar-Deshabilitar animaciones   // Active-Disable animations
    procedure EnableDisableAnimation(aEnable:boolean);
  public
    pathImage:String;

    constructor Create(AOwner: TComponent); override;
    destructor destroy();override;

    // Propiedades de la imagen // Image properties
    property Fecha:TDate read fFecha write SetFecha;
    property Key:string read fKey write fKey;
    property URLImagen:string read FURLImagen write FURLImagen;
    property MediaType:TMediaType read FMediaType write FMediaType;
    property Titulo:string read FTitulo write SetTitulo;
    property Explanation:string read FExplanation write SetExplanation;

    // Nombre del fichero en disco // Filename of the image on disk
    property FileName:String read FFileName write FFileName;
    // Evento para cuando se edita la imagen // Event for editing image
    property OnEditImage:TNotifyEvent read FOnEditImage write FOnEditImage;
    // evento cuando se maximiza la imagen
    property OnMaximize:TMaximizeEvent read FOnMaximize write FOnMaximize;
    // evento al visualizar la informacion
    property OnViewInfo:TViewInfo read FOnViewInfo write FOnViewInfo;

    property BigImage:TImage read FBigImage write FBigImage;
    // estado del frame  // Frame estate
    property FrameState:TFrameState read FFrameState write FFrameState;
    // Recargar la imagen de disco // Reload image from disk
    procedure ReloadImage;
    // Descargar una imagen Con Threads // Download an image usiong threads
    procedure DescargarImagen(ABitmapND:TBitmap; pForceDownload:boolean=False);

  end;



{$DEFINE IMAGEANIMATION}


//==============================================================================
//
//  I M P L E M E N T A C I O N
//
//==============================================================================
implementation

{$R *.fmx}

uses
  IdURI, UCommonCode,
  System.IOUtils
{$IFDEF ANDROID}
  ,Androidapi.JNI.JavaTypes, Androidapi.JNI.Net, Androidapi.JNI.Os, Androidapi.Helpers,
  Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.App,
  FMX.Platform.Android
{$ENDIF}
 ;

// Activar la carga de imagen // Activate the image Charge
procedure TFrameImagen.ActivateLoadImage;
begin

{$IFDEF IMAGEANIMATION}
  EnableDisableAnimation(False);
  img.Opacity := 0;
{$ENDIF IMAGEANIMATION}

  // Cargar la imagen // really charge the image
  InternalLoadImage;

{$IFDEF IMAGEANIMATION}
  EnableDisableAnimation(True);
{$ENDIF IMAGEANIMATION}


end;

// Activar-Deshabilitar animaciones   // Active-Disable animations
procedure TFrameImagen.EnableDisableAnimation(aEnable:boolean);
begin
  if (aEnable) then begin
    // Props iniciales
    img.Scale.X:= 0;
    img.Scale.Y := 0;
  end;
  FloatAnimOpacy.Enabled := aEnable;
  FloatAnimScaleX.Enabled := aEnable;
  FloatAnimScaleY.Enabled := aEnable;
end;

procedure TFrameImagen.btnEditClick(Sender: TObject);
begin
  // editar // Edit the image
  if Assigned(FOnEditImage) then begin
    FOnEditImage(Self);
  end;
end;

procedure TFrameImagen.btnInfoClick(Sender: TObject);
begin
  // Visualizar la información  // View image info
  mmExpl.Visible := not mmExpl.Visible;
  mmExpl.Align := TAlignLayout.Client;
  ContrastEffect1.Enabled := mmExpl.Visible;
  if Assigned(FOnViewInfo) then begin
    Self.FOnViewInfo(mmExpl.Visible);
  end;
end;

procedure TFrameImagen.btnShareClick(Sender: TObject);
begin
  // Compartir la imagen // Share the image
  ShowShareSheetAction1.TextMessage := Self.Titulo;
  ShowShareSheetAction1.Bitmap.Assign(img.Bitmap);
  ShowShareSheetAction1.Execute;
end;

procedure TFrameImagen.btnRefreshClick(Sender: TObject);
begin
  // Ini
  FrameState := [];
  // Borrar y descargar de nuevo  // delete and download again
  DeleteFile(pathImage);
  img.Bitmap.Assign(nil);
  // descargar la imagen (forzar)  // Forze to download image
  DescargarImagen(nil, True);
end;

// -debug-
procedure TFrameImagen.btnLoadClick(Sender: TObject);
begin
  ReloadImage;
end;

constructor TFrameImagen.Create(AOwner: TComponent);
begin
  inherited;

  // ini
  FrameState := [];
  mmExpl.Visible := False;
  ContrastEffect1.Enabled := mmExpl.Visible;
  aniDescarga.Visible := False;
  btnLoad.Visible := False;    // debug
  // fondo negro  // black background
  pnlImagen.Fill.Color := TAlphaColorRec.Black;

end;


procedure TFrameImagen.DescargarImagen(ABitmapND:TBitmap; pForceDownload:boolean=False);
var
  pathImages, fMini:string;
  URI:TidURI;
  LSart:Int64;
begin
  // si se ha descargado, salimos...  // If downloaded exit
  if ((feDownloaded in FrameState) or (feDiskLoaded in FrameState)) and (not pForceDownload) then Exit;
  // Si estamos descargando salimos...  // If downloading exit
  if (feDownloading in FrameState) then Exit;

  if (Self.FMediaType = mtVideo) then begin
    if Assigned(ABitmapND) then begin
      img.Bitmap.Assign(ABitmapND);
      Exit;
    end;
  end;

  // ini
  // -debug- lblPorcentaje.Visible := False;
  lblPorcentaje.Visible := False;
  lblPorcentaje.Text := 'URL';
  aniDescarga.Visible := False;
  pathIMages := GetDirectorioImagenes();

  // Procesar a URL  //  Process the URL
  URI := TidURI.Create(FURLImagen);
  try
    FFileName := pathImages + URI.Document;
  finally
    URI.Free;
  end;

  // Miniatura // file for thumbnail
  fMini := GetMiniaturaFileName(FFileName);

  // Exista ya la imagen????   // If exist, load form disk
  if (FileExists(FFileName) or FileExists(fMini)) and (not pForceDownload) then begin
    // La cargamos de disco   // Charge the image
    ActivateLoadImage;
  end
  else begin
    // La descargamos de internet -  inicializar // DownLoad - initialize
    lblPorcentaje.Visible := True;
    lblPorcentaje.Text := '...';
    aniDescarga.Enabled := True;
    aniDescarga.Visible := True;
    FrameState := FrameState + [feDownloading];
    LSart := 0;
    // Lanzar el trhread // Launch the thread
    th := TDownloadThread.Create(FURLImagen, FFileName, 0, LSart, -1);
    th.FreeOnTerminate := True;
    th.OnEndDownload := EndDownload;
    th.OnTerminate := TerminateThread;
    th.LabelPorcentaje := lblPorcentaje;
    th.Start;
  end;
  // fondo negro // Black background
  pnlImagen.Fill.Color := TAlphaColorRec.Black;

end;
destructor TFrameImagen.destroy;
begin
  // -debug-
  // Self.Titulo := 'Cerrando...';
  inherited;
end;

procedure TFrameImagen.EndDownload(const Sender: TObject; AStatus: Integer);
var
  fNameMini:string;
begin
  // Acabado; Imagen creada   // Download End
  FFilename := TDownloadThread(Sender).FileName;
  fNameMini := GetMiniaturaFileName(FFileName);

  // Redimensionar la imagen a 400  // Redim Image to 400 pixels
  Sleep(100);
  lblPorcentaje.Text := 'Mini';
  lblPorcentaje.Text := 'ok';

  // Controles
  aniDescarga.Enabled := False;
  aniDescarga.Visible := False;
  lblPorcentaje.Visible := False;

  // Se ha finalizado   // End work
  FrameState := FrameState - [feDownloading];
  FrameState := FrameState + [feDownloaded];
end;


// Directorio o ubiucacion donde se guardan las imagenes // Images directory
function TFrameImagen.GetDirectorioImagenes: string;
begin
  // Imagenes public
  Result := IncludeTrailingPathDelimiter(TPath.GetPicturesPath());
  Result := Result + 'PicOfTheDay';
  Result := IncludeTrailingPathDelimiter(Result);
  ForceDirectories(Result);
end;

procedure TFrameImagen.imgDblClick(Sender: TObject);
var
  pnl:TRectangle;
begin

  if ((not (feDownloaded in FrameState)) and (not (feDiskLoaded in FrameState))) or (feDownloading in FrameState) then Exit;

  // Cambiar la vista a grande // Change the view to big image
  pnl := TRectangle(Self.BigImage.ParentControl);
  pnl.BringToFront;
  pnl.Visible := True;
  pnl.BringToFront;
  Self.BigImage.Bitmap.Assign(img.Bitmap);
  pnl.Align := TAlignLayout.Client;

  if Assigned(FOnMaximize) then begin
    Self.FOnMaximize(True);
  end;
end;

procedure TFrameImagen.InternalLoadImage;
var
  ext:String;
  fLoad:String;
  fNameMini:String;
begin

  // Si es un video salimos...
  if (Self.FMediaType = mtVideo) then Exit;

  fLoad := FFileName;
  if (FFilename <> '') then begin
    ext := LowerCase(ExtractFileExt(FFileName));
    fNameMini := GetMiniaturaFileName(FFileName);
    // Si se ha generado, tiene preferencia
    if FileExists(fNameMini) then begin
      fLoad := fNameMini;
    end;

    if FileExists(fLoad) and
      ((ext = '.png') or (ext = '.jpg') or (ext = '.bmp') or (ext = '.jpeg')) then begin
      try
        Img.Bitmap.LoadFromFile(fLoad);
        FrameState := FrameState + [feDiskLoaded];
        img.Repaint;
      except
        on E:exception do begin
          // Es incorrecto o "a medias"   => Borrarlo
          DeleteFile(FFileName);
          DeleteFile(fNameMini);
          ShowMessage('ERROR: ' + E.Message);
        end;
      end;
    end;
  end;
end;

procedure TFrameImagen.mmExplClick(Sender: TObject);
begin
  btnInfoClick(nil);
  if Assigned(FOnViewInfo) then begin
    Self.FOnViewInfo(False);
  end;
end;

procedure TFrameImagen.ReloadImage;
begin
  ActivateLoadImage;
end;

procedure TFrameImagen.SetExplanation(const Value: string);
begin
  FExplanation := Value;
  Self.mmExpl.Lines.Text := Value;
end;

procedure TFrameImagen.SetFecha(const Value: TDate);
begin
  fFecha := Value;
  Self.lblFecha.Text := Format('%s',[FormatDateTime('dd/mm/yy', fFecha)]);
end;

procedure TFrameImagen.SetTitulo(const Value: string);
begin
  FTitulo := Value;
  lblTitulo.Text := Value;
end;

procedure TFrameImagen.TerminateThread(Sender: TObject);
begin
  // Leer la imagen
  ActivateLoadImage;
  // Controles
  aniDescarga.Enabled := False;
  aniDescarga.Visible := False;
  lblPorcentaje.Visible := False;

end;

procedure TFrameImagen.TimerLoadImageTimer(Sender: TObject);
begin
  // -debug-
  TimerLoadImage.Enabled := False;
  InternalLoadImage;
end;


end.
