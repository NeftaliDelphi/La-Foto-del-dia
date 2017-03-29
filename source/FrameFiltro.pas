unit FrameFiltro;

//==============================================================================
//
//  I N T E R F A C E
//
//==============================================================================
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Filter.Effects, FMX.Effects;

type
  // Clase para los filtros // Filter class
  TFilterEffectClass = class of TImageFXEffect;

  TfrFiltro = class(TFrame)
    pnlName: TPanel;
    RectImage: TRectangle;
    img: TImage;
    lblTitulo: TLabel;
    procedure imgClick(Sender: TObject);
  private
    FFilterEffectClass: TFilterEffectClass;
    FEffect: TImageFXEffect;
    FImageEffect: TImageFXEffect;
    FOnActivate: TNotifyEvent;
    procedure SetFilterEffectClass(const Value: TFilterEffectClass);
    procedure SetTitle(const Value: string);
    function GetTitle: string;
    function GetBitmap: TBitmap;
    procedure SetBitmap(const Value: TBitmap);
  public
    constructor Create(ATitle:string; AImage:TBitmap;
                       AImageEffect:TImageFXEffect; AEffectClass:TFilterEffectClass); reintroduce;
    destructor Destroy(); override;
    // Activar el filtro   //   Acticvate the filter
    procedure Activate(aValue:boolean);
    property Bitmap:TBitmap read GetBitmap write SetBitmap;
    property Title:string read GetTitle write SetTitle;
    property EffectClass:TFilterEffectClass read FFilterEffectClass write SetFilterEffectClass;
    property ImageEffect:TImageFXEffect read FImageEffect write FImageEffect;
    property Effect:TImageFXEffect read FEffect write FEffect;
    // evento al activar // Event On Activate
    property OnActivate:TNotifyEvent read FOnActivate write FOnActivate;
  end;

//==============================================================================
//
//  I M P L E M E N T A C I O N
//
//==============================================================================
implementation

{$R *.fmx}


procedure TfrFiltro.Activate(aValue: boolean);
begin
  // Borde para el filtro // Border of the filter
  if (aValue) then begin
    RectImage.Stroke.Color := TAlphaColorRec.Aqua;
  end
  else begin
    RectImage.Stroke.Color := TAlphaColorRec.Black;
  end;
  // Activar ese en la imagen principal  // apply this effect to the main image
  if Assigned(Self.FImageEffect) then begin
    Self.FImageEffect.Enabled := aValue;
  end;

end;

constructor TfrFiltro.Create(ATitle:string; AImage:TBitmap;
                             AImageEffect:TImageFXEffect; AEffectClass:TFilterEffectClass);
begin
  inherited Create(nil);

  // ini
  Self.Title := ATitle;
  Self.FImageEffect := AImageEffect;
  Self.FFilterEffectClass  := AEffectClass;
  Self.FEffect := AEffectClass.Create(img);
  Self.FEffect.Enabled := True;
  img.Bitmap.Assign(AImage);

end;

destructor TfrFiltro.Destroy;
begin
  // Liberar // Free resorces
  Self.FEffect.DisposeOf;

  inherited;

end;

function TfrFiltro.GetBitmap: TBitmap;
begin
  Result := img.Bitmap;
end;

function TfrFiltro.GetTitle: string;
begin
  Result := lblTitulo.Text;
end;

procedure TfrFiltro.imgClick(Sender: TObject);
begin
  // Activar este filtro  // Active this filter
  Activate(True);
  if Assigned(FOnActivate) then begin
    Self.FOnActivate(Self);
  end;

end;

procedure TfrFiltro.SetBitmap(const Value: TBitmap);
begin
  img.Bitmap.Assign(Value);
end;


procedure TfrFiltro.SetFilterEffectClass(const Value: TFilterEffectClass);
begin
  Self.FFilterEffectClass := Value;
  if Assigned(Value) then begin
    if Assigned(Self.FEffect) then begin
      Self.FEffect.DisposeOf;
    end;
    Self.FEffect := Self.FFilterEffectClass.Create(img);
    Self.FEffect.Parent := img;
    Self.FEffect.Enabled := True;
  end;
end;

procedure TfrFiltro.SetTitle(const Value: string);
begin
  lblTitulo.Text := Value;
end;

end.
