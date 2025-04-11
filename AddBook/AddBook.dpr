program AddBook;

uses
  Vcl.Forms,
  UFormMain in 'UFormMain.pas' {FormMain},
  Vcl.Themes,
  Vcl.Styles,
  Wait in 'Wait.pas' {frmWait};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TfrmWait, frmWait);
  Application.Run;
end.
