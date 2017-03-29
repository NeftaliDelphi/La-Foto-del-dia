// *************************************************************************
//   Código basado en:
//
//   https://community.embarcadero.com/blogs/entry/download-an-image-in-background-with-android-services
// *************************************************************************
unit uDownloadThread;

//==============================================================================
//
//  I N T E R F A C E
//
//==============================================================================
interface

uses
  System.Classes, System.SyncObjs,
  FMX.StdCtrls;

type
  TDownloadThreadEndDownloadEvent = procedure(const Sender: TObject; AStatus: Integer) of object;
  TDownloadThread = class(TThread)
  private
    FOnEndDownload: TDownloadThreadEndDownloadEvent;
    FLastDownloaded: Int64;
    procedure Download(AStartPoint, AEndPoint: Int64);
  protected
    FURL, FFileName: string;
    FStartPoint, FEndPoint: Int64;
    FThreadNo: Integer;
    FTimeStart: Cardinal;
    Porcentaje:Integer;

    procedure ReceiveDataEvent(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var Abort: Boolean);
  	// Actualiza el valor del procentaje descargado   // Update the % downloaded
    procedure UpdatePorcentaje();
  public
    LabelPorcentaje:TLabel;

    constructor Create(const URL, FileName: string; AThreadNo: Integer; StartPoint, EndPoint: Int64);
    destructor Destroy; override;
    procedure Execute; override;

    property OnEndDownload: TDownloadThreadEndDownloadEvent write FOnEndDownload;
    property URL: string read FURL;
    property FileName: string read FFileName;
    property ThreadNo: Integer read FThreadNo;
  end;


implementation

uses
  UCommonCode,
  System.Net.URLClient, System.Net.HttpClient, System.SysUtils;

{ TDownloadThread }
constructor TDownloadThread.Create(const URL, FileName: string; AThreadNo: Integer; StartPoint, EndPoint: Int64);
begin
  inherited Create(True);
  FURL := URL;
  FFileName := FileName;
  FThreadNo := AThreadNo;
  FStartPoint := StartPoint;
  FEndPoint := EndPoint;
  FLastDownloaded := StartPoint;
end;

destructor TDownloadThread.Destroy;
begin
  inherited;
end;

procedure TDownloadThread.Execute;
begin
  Download(FStartPoint, FEndPoint);
  while not terminated do
  begin
    Sleep(1);
    Download(FLastDownloaded, FEndPoint);
  end;
end;


procedure TDownloadThread.Download(AStartPoint, AEndPoint: Int64);
var
  LResponse: IHTTPResponse;
  LStream: TFileStream;
  LHttpClient: THTTPClient;
begin
  inherited;
  LHttpClient := THTTPClient.Create;
  try
    LHttpClient.OnReceiveData := ReceiveDataEvent;
    LStream := TFileStream.Create(FFileName, fmCreate, fmOpenWrite or fmShareDenyNone);
    try
      FTimeStart := GetTickCount;
      if FEndPoint = 0 then
        LResponse := LHttpClient.Get(FURL, LStream)
      else
      begin
        LStream.Seek(AStartPoint, TSeekOrigin.soBeginning);
        LResponse := LHttpClient.GetRange(FURL, AStartPoint, AEndPoint, LStream);
      end;
    finally
      LStream.Free;
    end;
    if Assigned(FOnEndDownload) then
    begin
      FOnEndDownload(Self, LResponse.StatusCode);
      Terminate;
    end;
  finally
    LHttpClient.Free;
  end;
end;

procedure TDownloadThread.ReceiveDataEvent(const Sender: TObject; AContentLength, AReadCount: Int64;
  var Abort: Boolean);
begin
  // Actualizar el proceso  // Update the process %
  if (AContentLength > 0) then begin
    porcentaje := Round(AReadCount/AContentLength*100);
    Synchronize(UpdatePOrcentaje);
  end;

  if Terminated  then
  begin
    ABort := true;
    FLastDownloaded := FLastDownloaded + AReadCount;
  end;
end;

procedure TDownloadThread.UpdatePorcentaje;
begin
  LabelPorcentaje.Text := IntToStr(porcentaje) + ' %';
end;

end.
