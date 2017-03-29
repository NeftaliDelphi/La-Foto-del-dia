unit frMain;

//==============================================================================
//
//  I N T E R F A C E
//
//==============================================================================
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts, frImagen, FMX.Gestures, FMX.Controls.Presentation, FMX.StdCtrls, IPPeerClient, FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base, Data.DB, FMX.ListView, Datasnap.DBClient, REST.Response.Adapter, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Data.Bind.DBScope, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.Ani, FrameFiltro, System.Generics.Collections, FMX.TabControl, FMX.Filter.Effects, FMX.Effects, System.ImageList, FMX.ImgList;

type
  TFormMain = class(TForm)
    tbMain: TToolBar;
    VertScrollBox1: TVertScrollBox;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1copyright: TStringField;
    ClientDataSet1date: TStringField;
    ClientDataSet1explanation: TStringField;
    ClientDataSet1hdurl: TStringField;
    ClientDataSet1media_type: TStringField;
    ClientDataSet1service_version: TStringField;
    ClientDataSet1title: TStringField;
    ClientDataSet1url: TStringField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    imgNoDisponible: TImage;
    imgGrande: TImage;
    pnlImage: TRectangle;
    imgTitulo: TImage;
    Timer1: TTimer;
    FloatAnimation1: TFloatAnimation;
    rectTitulo: TRectangle;
    tcMain: TTabControl;
    tabImagen: TTabItem;
    tabEdicion: TTabItem;
    imgEdicion: TImage;
    EfectoMonocromo: TMonochromeEffect;
    EfectoNegativo: TInvertEffect;
    EfectoAltoContr: TContrastEffect;
    EfectoBajoContr: TContrastEffect;
    EfectoHue: THueAdjustEffect;
    StyleBook1: TStyleBook;
    pnlFiltros: TPanel;
    sbFiltros: TScrollBox;
    FrFiltroMonocromo: TfrFiltro;
    FrFiltroNormal: TfrFiltro;
    FrFiltroInvertido: TfrFiltro;
    FrFiltroAltoContr: TfrFiltro;
    FrFiltroBajoContr: TfrFiltro;
    FrFiltroHue: TfrFiltro;
    tbEdicion: TToolBar;
    ilMain: TImageList;
    tabAbout: TTabItem;
    pnlFondo: TPanel;
    pnlNasa: TPanel;
    imgNasa: TImage;
    lblNASALink: TLabel;
    lblNASAAPILink: TLabel;
    pnlCentral: TPanel;
    pnlGerman: TPanel;
    imgGerman: TImage;
    pnlDatos: TPanel;
    lblCopyright: TLabel;
    lblWeb: TLabel;
    imgWeb: TImage;
    lblMail: TLabel;
    imgMail: TImage;
    lblAbout: TLabel;
    pnlPowered: TPanel;
    pnlInferior: TPanel;
    imgPowered: TImage;
    btnAbout: TButton;
    btnCerrar: TButton;
    EfectoSepia: TSepiaEffect;
    frFiltroSepia: TfrFiltro;
    EfectoEmboss: TEmbossEffect;
    frFiltroEmboss: TfrFiltro;
    lblTitulo: TLabel;
    BlurEffect1: TBlurEffect;
    FloatAnimation2: TFloatAnimation;
    btnCancelar: TButton;
    btnGrabar: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VertScrollBox1ViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure imgGrandeClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnBorrarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGrabarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCerrarClick(Sender: TObject);
    procedure lblNASALinkClick(Sender: TObject);
    procedure imgGermanClick(Sender: TObject);
    procedure imgNasaClick(Sender: TObject);
    procedure imgPoweredClick(Sender: TObject);
    procedure lblWebClick(Sender: TObject);
    procedure FloatAnimation2Finish(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    fListaFrames: TList<TFrameImagen>; // Lista de frame // Frame  list
    FrameHeight: single;
    FFrameApplyFilter: TFrameImagen;    // Frame seleccionado // Selected Frame
    FAppliedFilter: TFilterEffect;
    FrameInicial: Integer;  // el primero creado
    FrameFinal: Integer;    // el último creado
    LastActual: Integer;
    ListaURL: TStringList;
    fileURLs: string;
    Activando: boolean;
    LastDate: TDate;
    fListafiltros: TList<TfrFiltro>;
    Maximized, ViewingInfo:boolean;


    // Fichero con la lista de fotos // existing file with the photo list
    function GetListaFotosFileName(): string;
    // Crear los frames iniciales // Create the initial Frames
    procedure CreateFrames(NumFrames: integer);
    // Limpiar la imagen del Frame // Clear the frame image
    procedure LimpiarFrame(Aposicion: Integer);
    // Obrtener la URL para un día concreto (y otros datos) // Get the URL of Date (And other data)
    function GetURLDia(AFecha: TDate; var AMediaType: TMediaType; var tit, expl: string; ListaURLs: TStringList): string;
    // Procedimiento para editar una Imagen // Edit the actual image
    procedure EditarImagen(Sender: TObject);
    // al maximizar la imagen // Procedure on maximize an image
    procedure MaximizeImage(aValue:Boolean);
    // al visualizar la informacion // On visualize information
    procedure ViewInfo(aValue:Boolean);
    // Configurar los parámetros del filtro // Configure params
    procedure ConfigurarFiltro(AFiltroComp: TfrFiltro; ATitulo: string; AImageEffect: TImageFXEffect; AEffectClass: TFilterEffectclass);
    // Al activar filtro para una imagen  //  On active filter for a image
    procedure OnActivateFiltro(Sender: TObject);
    // Inicializar los filtros // Initialize filters
    procedure ConfigureVisualfilters();
    // Carga los datos en un Frame // Load data into the frame
    procedure CargarDatosFrame(AImageFrame: TFrameImagen);
    // obtener la Fecha a consultar // Get a new date
    function GetNewDate(): TDate;
    // Ocultar la informacion visible // Hide information
    procedure HideInfoFrames();
    // respuesta al dia´logo de cerrar // Response to the close dialog
    procedure OnCloseDialog(Sender: TObject; const AResult: TModalResult);
  public
    // Lista de Frames creados // List of created Frames
    property ListaFrame: TList<TFrameImagen>read fListaFrames write fListaFrames;
    // Lista de filtros disponibles // List of filter frames created
    property ListaFiltros: TList<TfrFiltro>read fListafiltros write fListaFiltros;
    // Frame seleccionado // selected Frame
    property FrameApplyFilter: TFrameImagen read FFrameApplyFilter;
    // Filtro aplicado  // Applied filter
    property AppliedFilter: TFilterEffect read FAppliedFilter;
    // Activa este y desactiva los demás
    procedure ActivarFiltro(AFrameFiltro: TfrFiltro; PropagarCambio: boolean);
  end;

var
  FormMain: TFormMain;


//==============================================================================
//
//  I M P L E M E N T A C I O N
//
//==============================================================================
implementation

{$R *.fmx}

uses
  FMX.VirtualKeyboard, FMX.Platform,
  DateUtils, IOUtils, UCommonCode, UnitAbout;

// Activar / desactivar filtros
procedure TFormMain.ActivarFiltro(AFrameFiltro: TfrFiltro; PropagarCambio: boolean);
var
  I: Integer;
  fr: TfrFiltro;
begin

  if Activando then
    Exit;

  Activando := True;
  try
    for I := 0 to (ComponentCount - 1) do begin
      if (Components[i] is TfrFiltro) then begin
        fr := TfrFiltro(Components[i]);
        // Activar el seleccionado   // Active the selected
        if (fr = AFrameFiltro) then begin
          fr.Activate(True);
          Self.FAppliedFilter := fr.ImageEffect;
        end
        else begin
          if PropagarCambio then begin
            fr.Activate(False);
          end;
        end;
      end;
    end;
  finally
    Activando := False;
  end;
end;

// Cerrar About   // Close the About windows
procedure TFormMain.btnBorrarClick(Sender: TObject);
begin
  // Visualizar la pantalla de información
  tcMain.ActiveTab := tabAbout;
end;

// Cancelar y volver al principal  // Cancel and turn to the main tab
procedure TFormMain.btnCancelarClick(Sender: TObject);
begin
  // Liberar el apuntado
  Self.FFrameApplyFilter := nil;
  Self.FAppliedFilter := nil;
  // Cambio de tab
  tcMain.ActiveTab := tabImagen;
end;

procedure TFormMain.btnCerrarClick(Sender: TObject);
begin
  // Activate    // Activate animation
  FloatAnimation2.Enabled := False;
  FloatAnimation2.Enabled := True;
end;

procedure TFormMain.btnGrabarClick(Sender: TObject);
begin
  // Pasar los cambios en la imagen original / Save changes to image
  if Assigned(FrameApplyFilter) and Assigned(AppliedFilter) then
  begin
    // Grabar los cambios /Save
    SaveBitmapWithEffect(imgEdicion, AppliedFilter, FrameApplyFilter.FileName);
    // Recargar la imagen /Reload Image
    FrameApplyFilter.ReloadImage;
    // Liberar el apuntado / Free vars
    Self.FFrameApplyFilter := nil;
    Self.FAppliedFilter := nil;
    // Cambio de tab // Change to main tab
    tcMain.ActiveTab := tabImagen;
  end;

end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  // Liberar el apuntado
  Self.FFrameApplyFilter := nil;
  Self.FAppliedFilter := nil;
  // Cambio de tab
  tcMain.ActiveTab := tabImagen;
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  // Pasar los cambios en la imagen original / Save changes to image
  if Assigned(FrameApplyFilter) and Assigned(AppliedFilter) then
  begin
    // Grabar los cambios /Save
    SaveBitmapWithEffect(imgEdicion, AppliedFilter, FrameApplyFilter.FileName);
    // Recargar la imagen /Reload Image
    FrameApplyFilter.ReloadImage;
    // Liberar el apuntado / Free vars
    Self.FFrameApplyFilter := nil;
    Self.FAppliedFilter := nil;
    // Cambio de tab // Change to main tab
    tcMain.ActiveTab := tabImagen;
  end;
end;

procedure TFormMain.ConfigurarFiltro(AFiltroComp: TfrFiltro; ATitulo: string; AImageEffect: TImageFXEffect; AEffectClass: TFilterEffectclass);
begin
  // Asignar datos al filtro  // Ini the filter
  AFiltroComp.Bitmap := imgEdicion.Bitmap;
  AFiltroComp.Title := ATitulo;
  AFiltroComp.ImageEffect := AImageEffect;
  AFiltroComp.EffectClass := AEffectClass;
  AFiltroComp.OnActivate := OnActivateFiltro;
  // Añadirlo a lal lista
  Self.fListafiltros.Add(AFiltroComp);
end;

// Inicializar los filtros // Initialize filters
procedure TFormMain.ConfigureVisualfilters();
begin
  // ini
  Activando := False;
{$IFDEF WINDOWS}
  sbFiltros.ShowScrollBars := True;
{$ENDIF}
{$IFDEF ANDROID}
  sbFiltros.ShowScrollBars := False;
{$ENDIF}

  // Asignar valores a los filtros
  //============================================================================
  // Normal
  ConfigurarFiltro(FrFiltroNormal, 'Normal', nil, nil);
  // Monocromo - Monochrome
  ConfigurarFiltro(FrFiltroMonocromo, 'Monocromo', EfectoMonocromo, TMonochromeEffect);
  // Invertido - Inverted
  ConfigurarFiltro(FrFiltroInvertido, 'Negativo', EfectoNegativo, TInvertEffect);
  // Contraste alto - Hight contrast
  ConfigurarFiltro(FrFiltroAltoContr, 'Hight Contr', EfectoAltoContr, TContrastEffect);
  // Contraste bajo - Low contrast
  ConfigurarFiltro(FrFiltroBajoContr, 'Low Contr', EfectoBajoContr, TContrastEffect);
  // Efecto Hue
  ConfigurarFiltro(FrFiltroHue, 'Hue', EfectoHue, THueAdjustEffect);
  // efecto sepia
  ConfigurarFiltro(FrFiltroSepia, 'Sepia', EfectoSepia, TSepiaEffect);
  // efecto emboss
  ConfigurarFiltro(frFiltroEmboss, 'Emboss', EfectoEmboss, TEmbossEffect);

  // Activar el normal (por defecto) // By default acticvate the normal (no effect)
  ActivarFiltro(FrFiltroNormal, True);

end;

// Crear un grupo de frames  // creatre a group of frames.
procedure TFormMain.CreateFrames(NumFrames: integer);
var
  fr: TFrameImagen;
  i, index: Integer;
  existentes: Integer;
begin
  // Ini
  existentes := fListaFrames.Count;
  // Recorrido
  for i := 1 to (NumFrames) do
  begin
    index := existentes + i - 1;       // Empieza por el 0   // ini by 0
    fr := TFrameImagen.Create(Self);
    fr.BigImage := imgGrande;
    fr.Name := 'Frame' + IntToStr(index);
    fr.Position.Y := (index) * (fr.Height);
    fr.Parent := VertScrollBox1;
    fr.Align := TAlignLayout.Top;
    fr.key := API_KEY;
    fr.OnEditImage := EditarImagen;
    fr.OnMaximize := MaximizeImage;
    fr.OnViewInfo := ViewInfo;
    FrameHeight := fr.Height;

    // Añadirlo a la lista // Added to the list
    fListaFrames.Add(fr);
  end;
end;

// Procedimiento para editar una Imagen // proc to edit an Image
procedure TFormMain.EditarImagen(Sender: TObject);
var
  i: Integer;
begin
  if (Sender is TFrameImagen) then
  begin
    // Acceder al Frame  // Access to the frame
    Self.FFrameApplyFilter := TFrameImagen(Sender);
    Self.FAppliedFilter := nil;
    // Asignar la imagen a modificar  // Assign the image to modify
    imgEdicion.Bitmap.Assign(FrameApplyFilter.img.Bitmap);

    // Asignarla a los componentes de filtro
    for i := 0 to (Self.fListafiltros.Count - 1) do begin
      fListafiltros[i].img.Bitmap.Assign(FrameApplyFilter.img.Bitmap);
    end;
    // Activar el filtro normal // Activate the Normal filter by default
    ActivarFiltro(FrFiltroNormal, True);
    // Cambiar la pestaña // Change the tab
    tcMain.ActiveTab := tabEdicion;

  end;
end;

// Clear the Frame
procedure TFormMain.LimpiarFrame(APosicion: Integer);
var
  fr: TFrameImagen;
begin

  if (fListaFrames.Count < APosicion) then
    Exit;

  fr := TFrameImagen(fListaFrames.Items[Aposicion]);
  if not Assigned(fr) then
    Exit;

  // Si no está descargado salimos...  // if not downloaded the exit
  if (fr.FrameState = []) or (fr.FrameState = [feDownloading]) then
    Exit;
  // Liberar memoria
  fr.img.Bitmap.Assign(nil);
  fr.FrameState := [];
end;


// al maximizar la imagen
procedure TFormMain.MaximizeImage(aValue: Boolean);
begin
  Maximized := True;
end;

// al visualizar la informacion
procedure TFormMain.ViewInfo(aValue: Boolean);
begin
  ViewingInfo := aValue;
end;

// Al activar el filtro   //   On activate filter
procedure TFormMain.OnActivateFiltro(Sender: TObject);
begin
  if (Sender is TfrFiltro) then
  begin
    ActivarFiltro(TfrFiltro(Sender), True);
  end;
end;

procedure TFormMain.OnCloseDialog(Sender: TObject; const AResult: TModalResult);
begin
  if AResult = mrOK then begin
    Close;
  end;
end;

procedure TFormMain.FloatAnimation2Finish(Sender: TObject);
begin
  // Volver a la pestaña principal // return to the main tab
  tcMain.ActiveTab := tabImagen;
  BlurEffect1.Softness := 0;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  // ini
  LastDate := 0;
  // Lista que contendrá los frames  // All frames created list
  FListaFrames := TList<TFrameImagen>.Create();
  FListaFiltros := TList<TfrFiltro>.Create();

  // Lista de filtros disponibles // List of filters avaibles
  FrameInicial := 1;
  imgNoDisponible.Visible := False;
  // Lista de direcciones // List of URL's
  ListaURL := TStringList.Create();
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  // Liberar // Free rresources
  fListaFrames.DisposeOf;
  fListafiltros.DisposeOf;
  ListaURL.DisposeOf
end;

procedure TFormMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
{$IFDEF ANDROID}
var
  FService :IFMXVirtualKeyboardService;
{$ENDIF}
begin
{$IFDEF ANDROID}
  if Key = vkHardwareBack then begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
{$ENDIF}
{$IFDEF MSWINDOWS}
  if key = vkEscape then begin
{$ENDIF}
    Key := 0;
    // editando, volvemos a la inicial    // Editing, come initial tab
    if (tcMain.ActiveTab = tabEdicion) then begin
      // Cancelar la edicion   // Cancel the edition
      btnCancelarClick(nil);
    end
    else if (Maximized) then begin
      imgGrandeClick(Self);
    end
    else if (ViewingInfo) then begin
      HideInfoFrames;
    end
    else  begin
      // boton de BAck   // Back button pressed 
      MessageDlg('¿Desea cerrar la aplicación?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], -1, OnCloseDialog);
    end;
  end;
end;




// obtener la Fecha a consultar // Get a new date
function TFormMain.GetNewDate(): TDate;
begin
  if (LastDate = 0) then begin
    LastDate := Date()
  end
  else begin
    LastDate := IncDay(LastDate, -1);
  end;
  Result := LastDate;
end;


// Carga los datos en u Frame
procedure TFormMain.CargarDatosFrame(AImageFrame: TFrameImagen);
var
  mt: TMediaType;
  Titulo, expl, sURL: string;
  cont: Integer;
  d: TDate;
begin
  // Ini
  cont := 0;
  sURL := STR_EMPTY;
  d := 0;

  if Assigned(AImageFrame) then  begin
    // Si no está la URL, la buscamos...  // If not exist URL, found it
    if (AImageFrame.URLImagen = '') then  begin
      // tres intentos, por si falla
      while (sURL = STR_EMPTY) and (cont < 5) do begin
        d := GetNewDate();
        sURL := GetURLDia(d, mt, Titulo, expl, ListaURL);
        if (mt = mtVideo) then begin
          sURL := STR_EMPTY;
        end
        else begin
          Inc(cont);
        end;
      end;

      // Asigna al frame la url de la imagen // Assign to the frame the URL an other data of image
      AImageFrame.URLImagen := sURL;
      AImageFrame.Fecha := d;
      AImageFrame.MediaType := mt;
      AImageFrame.Titulo := titulo;
      AImageFrame.Explanation := expl;
    end;
    // download the image
    AImageFrame.DescargarImagen(imgNoDisponible.Bitmap);
  end;
end;

procedure TFormMain.FormShow(Sender: TObject);
var
  fr: TFrameImagen;
begin
  // tabs (ocultas)  // Hide tabs
  tcMain.TabPosition := TTabPosition.None;
  tcMain.ActiveTab := tabImagen;
{$IFDEF WINDOWS}
  VertScrollBox1.ShowScrollBars := True;
{$ENDIF}
{$IFDEF ANDROID}
  VertScrollBox1.ShowScrollBars := False;
{$ENDIF}

  // Fichero en disco  //  Disk file with URL downloaded
  fileURLs := GetListaFotosFileName();
  // si existe, lo cargamos  // If exist use it
  if FileExists(fileURLs) then
  begin
    ListaURL.LoadFromFile(fileURLs);
  end;

  // situacion inicial  // Initial situation
  CreateFrames(25);   // siempre habrá 16 creados (7 + actual + 7)  // Always 16 created
  FrameInicial := 0;
  FrameFinal := 14;
  LastActual := 0;

  // Cargar el primer Frame   // Charge the first automatically
  fr := TFrameImagen(fListaFrames.Items[0]);
  CargarDatosFrame(fr);

  // configurar filtros visuales  // Configura visual filters
  ConfigureVisualFilters;
end;

// Fichero con la lista de fotos descargadas // File with URL's downloaded and other info
function TFormMain.GetListaFotosFileName(): string;
begin
  Result := IncludeTrailingPathDelimiter(TPath.GetSharedDocumentsPath()) + 'FotoDiaURLs.txt';
end;


// Obrtener la URL para un día concreto (y otros datos) // Get the URL of Date (And other data)
function TFormMain.GetURLDia(AFecha: TDate; var AMediaType: TMediaType; var tit, expl: string; ListaURLs: TStringList): string;
var
  Str: string;
  sDate: string;
  index: integer;
begin
  // ini
  Result := STR_EMPTY;
  sDate := FormatDateTime('yyyy-mm-dd', AFecha);

  // Buscar por la fecha en la lista existente  // Find by date
  index := ListaURLs.IndexOfName(sDate);
  if (index <> -1) then
  begin
    Result := ListaURLs.Values[sDate];
    // luego va el titulo y luego la descripcion // Next is the title and the description
    tit := ListaURLs.Strings[index + 1];
    expl := ListaURLs.Strings[index + 2];
    AMediaType := mtFoto;
  end
  else
  begin  // Buscarla // Find it
    Str := BASE_URL + API_KEY + '&date=';
    Str := Str + sDate;
    try
      RESTClient1.BaseURL := Str;
      RESTRequest1.Execute;
      Result := ClientDataSet1url.AsString;
      if (ClientDataSet1media_type.AsString = 'video') then begin
        AMediaType := mtVideo;
      end
      else if (ClientDataSet1media_type.AsString = 'image') then begin
        AMediaType := mtFoto;
      end
      else begin
        AMediaType := mtError;
      end;

      // si no hay Error ...
      if (AMediaType <> mtError) then begin
        tit := ClientDataSet1title.AsString;
        expl := ClientDataSet1explanation.AsString;
        // Fecha + TIT + EXPL
        ListaURLs.Add(sDate + '=' + ClientDataSet1url.AsString);
        ListaURLs.Add(ClientDataSet1title.AsString);
        ListaURLs.Add(ClientDataSet1explanation.AsString);
        // Grabarla // Save the list of URL's
        ListaURL.SaveToFile(fileURLs);
      end;
    except
      // nada
      // debug -error-  Log.
    end;
  end;
end;

// Ocultar la informacion visible // Hide information of images visible
procedure TFormMain.HideInfoFrames();
var
  i:integer;
begin
  for i := 0 to (Self.fListaFrames.Count - 1) do begin
    if (fListaFrames[i].mmExpl.Visible) then begin
      fListaFrames[i].mmExplClick(nil);
    end;
  end;
end;

// expandior la imagen a pantalla completa // expand the image
procedure TFormMain.imgGermanClick(Sender: TObject);
begin
  OpenWebPage(LINK_GERMAN);
end;

procedure TFormMain.imgGrandeClick(Sender: TObject);
begin
  // Ampiar imagen // Full screen
  pnlImage.Align := TAlignLayout.Center;
  pnlImage.Width := 50;
  pnlImage.Height := 50;
  pnlImage.Visible := False;
  // deja de estar maximizada
  Maximized := False;
end;

procedure TFormMain.imgNasaClick(Sender: TObject);
begin
  OpenWebPage(LINK_CONTEST);
end;

procedure TFormMain.imgPoweredClick(Sender: TObject);
begin
  OpenWebPage(DELPHI_LINK);
end;

procedure TFormMain.lblNASALinkClick(Sender: TObject);
begin
  OpenWebPage(LINK_CONTEST);
end;

procedure TFormMain.lblWebClick(Sender: TObject);
begin
  OpenWebPage(LINK_BLOG);
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  // Animacion superior // Animation Left Corner Upper
  FloatAnimation1.Enabled := False;
  FloatAnimation1.Enabled := True;
end;

procedure TFormMain.VertScrollBox1ViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
var
  fActual: integer;
  fr: TFrameImagen;
begin
  // -debug-
  // lblTitulo.Text := STR_TITLE + '  ' + IntToStr(fListaFrames.Count);

  // Cuamdo llegamos al 20, si hay 25 creamos más  // When arrive to 20, create new
  fActual := Trunc((NewViewportPosition.Y - (FrameHeight / 2)) / FrameHeight);
  // Si faltan 5 para el final, creamos 25 más...
  if (fActual + 5 >= fListaFrames.Count) then
  begin
    CreateFrames(25);
  end;

  // limpiar las imagenes  //   Clear the images
  if (fActual - 10 > 0) then
  begin
    // Limpiar la fActual - 10;
    LimpiarFrame(fActual - 10);
  end;

  // limpiar las imagenes
  if (fActual + 10 < fListaFrames.Count) then
  begin
    // Limpiar la fActual - 10;
    LimpiarFrame(fActual + 10);
  end;

  // descargar el visible y el siguiente... // Download the visible anD the next
  fr := TFrameImagen(fListaFrames.Items[fActual]);
  CargarDatosFrame(fr);
  fr := TFrameImagen(fListaFrames.Items[fActual + 1]);
  CargarDatosFrame(fr);

end;

end.


