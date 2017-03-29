program LaFotoDelDia;

uses
  System.StartUpCopy,
  FMX.Forms,
  frMain in 'frMain.pas' {FormMain},
  frImagen in 'frImagen.pas' {FrameImagen: TFrame},
  uDownloadThread in 'uDownloadThread.pas',
  UCommonCode in 'UCommonCode.pas',
  FrameFiltro in 'FrameFiltro.pas' {frFiltro: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFormMain, FormMain);
  // opciones de debug
  ReportMemoryLeaksOnShutdown := True;

  Application.Run;
end.
