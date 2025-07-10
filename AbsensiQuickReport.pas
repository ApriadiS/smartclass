unit AbsensiQuickReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QuickRpt, QRCtrls, Vcl.ExtCtrls,
  ZAbstractConnection, ZConnection, Data.DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, Vcl.Imaging.pngimage;

type
  TF_AbsensiQuickReport = class(TForm)
    QuickRep: TQuickRep;
    TitleBand1: TQRBand;
    DetailBand1: TQRBand;
    LabelTitle: TQRLabel;
    QRLabelNPM: TQRLabel;
    QRLabelMataKuliah: TQRLabel;
    QRLabelStatus: TQRLabel;
    QRLabelKeterangan: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    ZQuery: TZQuery;
    ZConnection: TZConnection;
    QRLabelNama: TQRLabel;
    QRDBText5: TQRDBText;
    QRImageLogo: TQRImage;
    QRLabelAlamat: TQRLabel;
    QRLabelPerihal: TQRLabel;
    QRLabelTanggalAbsensi: TQRLabel;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRShape8: TQRShape;
    QRShape9: TQRShape;
    QRShape10: TQRShape;
  private
    { Private declarations }
    procedure ConnectionSetup;
    procedure QuerySetup(ATanggal: TDateTime);
    procedure DetailBandSetup;

  public
    { Public declarations }
    procedure GenerateReport(ATanggal: TDateTime);

  end;

var
  F_AbsensiQuickReport: TF_AbsensiQuickReport;

implementation

{$R *.dfm}

procedure TF_AbsensiQuickReport.ConnectionSetup;
begin
  ZConnection.HostName := 'localhost';
  ZConnection.Database := 'smartclass';
  ZConnection.User := 'root';
  ZConnection.Password := '';
  ZConnection.Protocol := 'mysql';
  ZConnection.Port := 3306;
  ZConnection.Connect;
  ZQuery.Connection := ZConnection;
  QuickRep.DataSet := ZQuery;
end;

procedure TF_AbsensiQuickReport.QuerySetup(ATanggal: TDateTime);
begin
  ZQuery.SQL.Text :=
    'SELECT datetime, ' +
    'CASE ' +
    '  WHEN status_absensi = 0 THEN ''Hadir'' ' +
    '  WHEN status_absensi = 1 THEN ''Izin'' ' +
    '  WHEN status_absensi = 2 THEN ''Sakit'' ' +
    '  ELSE ''Alpha'' ' +
    'END AS jenis_str, ' +
    'npm, nama_mahasiswa, mata_kuliah, keterangan ' +
    'FROM absensi WHERE DATE(datetime) = :datetime';
  ZQuery.ParamByName('datetime').AsDate := ATanggal;
  ZQuery.Open;
end;

procedure TF_AbsensiQuickReport.GenerateReport(ATanggal: TDateTime);
begin
  ConnectionSetup;
  DetailBandSetup;
  QuerySetup(ATanggal);
  QRLabelTanggalAbsensi.Caption := 'Tanggal: ' + FormatDateTime('dd mmmm yyyy', ATanggal);

  if ZQuery.IsEmpty then
  begin
    ShowMessage('Tidak ada data untuk datetime yang dipilih.');
    Exit;
  end;

  QuickRep.Preview;
end;

procedure TF_AbsensiQuickReport.DetailBandSetup;
begin
  QRDBText1.DataSet := ZQuery;
  QRDBText2.DataSet := ZQuery;
  QRDBText3.DataSet := ZQuery;
  QRDBText4.DataSet := ZQuery;
  QRDBText5.DataSet := ZQuery;
  QRDBText1.DataField := 'npm';
  QRDBText2.DataField := 'nama_mahasiswa';
  QRDBText3.DataField := 'mata_kuliah';
  QRDBText4.DataField := 'jenis_str';
  QRDBText5.DataField := 'keterangan';
end;

end.