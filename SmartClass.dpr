program SmartClass;

uses
  Vcl.Forms,
  AbsensiData in 'AbsensiData.pas' {F_AbsensiData},
  AbsensiQuickReport in 'AbsensiQuickReport.pas' {F_AbsensiQuickReport};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TF_AbsensiData, F_AbsensiData);
  Application.CreateForm(TF_AbsensiQuickReport, F_AbsensiQuickReport);
  Application.Run;
end.
