unit AbsensiData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Menus, 
  Data.DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection,
  ZConnection, AbsensiQuickReport;

type
  TF_AbsensiData = class(TForm)
    GroupBoxHutangPiutang: TGroupBox;
    ListViewData: TListView;
    LabelNPM: TLabel;
    LabelNamaMahasiswa: TLabel;
    ButtonBuat: TButton;
    ButtonHapus: TButton;
    ButtonUbah: TButton;
    ButtonBatal: TButton;
    ButtonKeluar: TButton;
    DateTimePickerReportData: TDateTimePicker;
    LabelReportData: TLabel;
    ButtonPreview: TButton;
    ZConnection: TZConnection;
    ZQuery: TZQuery;
    ButtonSimpan: TButton;
    ComboBoxStatus: TComboBox;
    EditMataKuliah: TEdit;
    LabelMataKuliah: TLabel;
    LabelStatusAbsensi: TLabel;
    LabelKeterangan: TLabel;
    EditNPM: TEdit;
    EditNamaMahasiswa: TEdit;
    RichEditKeterangan: TRichEdit;
    LabelTanggalAbsensi: TLabel;
    DateTimePickerAbsensi: TDateTimePicker;
    ButtonCari: TButton;
    ButtonReset: TButton;
    
    procedure FormCreate(Sender: TObject);

    
    procedure ButtonBuatClick(Sender: TObject);
    procedure ButtonHapusClick(Sender: TObject);
    procedure ButtonUbahClick(Sender: TObject);
    procedure ButtonBatalClick(Sender: TObject);
    procedure ButtonKeluarClick(Sender: TObject);
    procedure ButtonPreviewClick(Sender: TObject);
    procedure ButtonSimpanClick(Sender: TObject);

    procedure ButtonCariClick(Sender: TObject);
    procedure ButtonResetClick(Sender: TObject);

    
    procedure ListViewDataItemClick(Sender: TObject; Item: TListItem; Selected: Boolean);

    // sanitasi agar hanya angka yang dapat di input kepada EditNPM
    procedure EditNPMKeyPress(Sender: TObject; var Key: Char);
    
    procedure ConfigureMySQLConnection;
  private
    { Private declarations }
    FMode: string; 
    procedure SetStateAwal;
    procedure SetStateEdit;
    procedure SetStateInputBaru;
    procedure RefreshListView;
    procedure ClearFormFields;
  public
    { Public declarations }
  end;


var
  F_AbsensiData: TF_AbsensiData;

implementation

{$R *.dfm}

// Memunculkan data ke ListView berdasarkan tanggal yang dipilih pada DateTimePickerAbsensi
procedure TF_AbsensiData.ButtonCariClick(Sender: TObject);
begin 
  if not ZConnection.Connected then
  begin
    ShowMessage('Koneksi ke database belum berhasil.');
    Exit;
  end;

  ZQuery.SQL.Text := 'SELECT * FROM absensi WHERE DATE(datetime) = :tanggal ORDER BY datetime DESC';
  ZQuery.ParamByName('tanggal').AsDate := DateTimePickerAbsensi.Date;
  ZQuery.Open;
  
  // Check if there are results
  if ZQuery.IsEmpty then
  begin
    ShowMessage('Tidak ada data absensi untuk tanggal yang dipilih.');
    ZQuery.Close;
    Exit;
  end;
  ListViewData.Clear;
  while not ZQuery.Eof do
  begin
    with ListViewData.Items.Add do
    begin
      Caption := ZQuery.FieldByName('npm').AsString;
      SubItems.Add(ZQuery.FieldByName('nama_mahasiswa').AsString);
      SubItems.Add(ZQuery.FieldByName('mata_kuliah').AsString);
      if ZQuery.FieldByName('status_absensi').AsInteger = 0 then
        SubItems.Add('Hadir')
      else if ZQuery.FieldByName('status_absensi').AsInteger = 1 then
        SubItems.Add('Izin')
      else if ZQuery.FieldByName('status_absensi').AsInteger = 2 then
        SubItems.Add('Sakit')
      else
        SubItems.Add('Alpha');
      SubItems.Add(ZQuery.FieldByName('keterangan').AsString);
      Data := Pointer(ZQuery.FieldByName('id_absensi').AsInteger);
    end;
    ZQuery.Next;
  end;
  ZQuery.Close;
  ListViewData.Selected := nil; // Clear selection after search
  SetStateAwal; // Reset state after search
end;

// Mengembalikan ListView ke kondisi awal dengan data hari ini
procedure TF_AbsensiData.ButtonResetClick(Sender: TObject);
begin
  if not ZConnection.Connected then
  begin
    ShowMessage('Koneksi ke database belum berhasil.');
    Exit;
  end;

  DateTimePickerAbsensi.Date := Now; // Reset DateTimePicker to today
  ZQuery.SQL.Text := 'SELECT * FROM absensi WHERE DATE(datetime) = :tanggal ORDER BY datetime DESC';
  ZQuery.ParamByName('tanggal').AsDate := DateTimePickerAbsensi.Date;
  ZQuery.Open;

  ListViewData.Clear;
  while not ZQuery.Eof do
  begin
    with ListViewData.Items.Add do
    begin
      Caption := ZQuery.FieldByName('npm').AsString;
      SubItems.Add(ZQuery.FieldByName('nama_mahasiswa').AsString);
      SubItems.Add(ZQuery.FieldByName('mata_kuliah').AsString);
      if ZQuery.FieldByName('status_absensi').AsInteger = 0 then
        SubItems.Add('Hadir')
      else if ZQuery.FieldByName('status_absensi').AsInteger = 1 then
        SubItems.Add('Izin')
      else if ZQuery.FieldByName('status_absensi').AsInteger = 2 then
        SubItems.Add('Sakit')
      else
        SubItems.Add('Alpha');
      SubItems.Add(ZQuery.FieldByName('keterangan').AsString);
      Data := Pointer(ZQuery.FieldByName('id_absensi').AsInteger);
    end;
    ZQuery.Next;
  end;
  ZQuery.Close;
  
  ClearFormFields; // Clear form fields after reset
end;



procedure TF_AbsensiData.EditNPMKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TF_AbsensiData.ClearFormFields;
begin
  ComboBoxStatus.ItemIndex := -1;
  EditNPM.Clear;
  EditNamaMahasiswa.Clear;
  EditMataKuliah.Clear;
  RichEditKeterangan.Clear;
  DateTimePickerReportData.Date := Now;
  DateTimePickerAbsensi.Date := Now;  
  ListViewData.Selected := nil; 
end;

procedure TF_AbsensiData.FormCreate(Sender: TObject);
begin
  ConfigureMySQLConnection;
  ComboBoxStatus.Items.Clear;
  ComboBoxStatus.Items.Add('Hadir');  // 0
  ComboBoxStatus.Items.Add('Izin');   // 1
  ComboBoxStatus.Items.Add('Sakit');  // 2
  ComboBoxStatus.Items.Add('Alpha');  // 3
  ClearFormFields;
  RefreshListView;
  ListViewData.OnSelectItem := ListViewDataItemClick;
  ListViewData.ReadOnly := True; // Prevent editing directly in ListView
  ListViewData.ViewStyle := vsReport;
  ListViewData.RowSelect := True;  
  ButtonBuat.OnClick := ButtonBuatClick;
  ButtonHapus.OnClick := ButtonHapusClick;
  ButtonUbah.OnClick := ButtonUbahClick;
  ButtonBatal.OnClick := ButtonBatalClick;
  ButtonKeluar.OnClick := ButtonKeluarClick;
  ButtonPreview.OnClick := ButtonPreviewClick;
  ButtonSimpan.OnClick := ButtonSimpanClick;
  EditNPM.OnKeyPress := EditNPMKeyPress;
  ButtonCari.OnClick := ButtonCariClick;
  ButtonReset.OnClick := ButtonResetClick;
  SetStateAwal;
end;

procedure TF_AbsensiData.ConfigureMySQLConnection;
begin
  ZConnection.HostName := 'localhost'; 
  ZConnection.Database := 'smartclass'; 
  ZConnection.User := 'root'; 
  ZConnection.Password := ''; 
  ZConnection.Protocol := 'mysql'; 
  ZConnection.Port := 3306; 
  ZConnection.Connect;
  ZQuery.Connection := ZConnection;
  if not ZConnection.Connected then
    ShowMessage('Failed to connect to the database.');
end;

procedure TF_AbsensiData.SetStateAwal;
begin
  ButtonBuat.Enabled := True;
  ButtonSimpan.Enabled := False;
  ButtonUbah.Enabled := False;
  ButtonHapus.Enabled := False;
  ButtonBatal.Enabled := True;
  ButtonKeluar.Enabled := True;
  ButtonPreview.Enabled := True;

  EditNPM.Enabled := False;
  EditMataKuliah.Enabled := False;
  EditNamaMahasiswa.Enabled := False;
  ComboBoxStatus.Enabled := False;
  RichEditKeterangan.Enabled := False;

  ListViewData.Enabled := True; // Enable ListView for data selection
  ListViewData.Selected := nil; // Clear any selection
  ClearFormFields;
end;

procedure TF_AbsensiData.SetStateEdit;
begin
  ButtonBuat.Enabled := False;
  ButtonSimpan.Enabled := True;
  ButtonUbah.Enabled := True;
  ButtonHapus.Enabled := True;
  ButtonBatal.Enabled := True;
  ButtonKeluar.Enabled := True;
  ButtonPreview.Enabled := True;
  
  EditNPM.Enabled := True;
  EditMataKuliah.Enabled := True;
  EditNamaMahasiswa.Enabled := True;
  ComboBoxStatus.Enabled := True;
  RichEditKeterangan.Enabled := True;
  
  ListViewData.Enabled := False; // Disable ListView while inputting new data
end;

procedure TF_AbsensiData.SetStateInputBaru;
begin
  ButtonBuat.Enabled := False;
  ButtonSimpan.Enabled := True;
  ButtonUbah.Enabled := False;
  ButtonHapus.Enabled := False;
  ButtonBatal.Enabled := True;
  ButtonKeluar.Enabled := True;
  ButtonPreview.Enabled := False;
  
  EditNPM.Enabled := True;
  EditMataKuliah.Enabled := True;
  EditNamaMahasiswa.Enabled := True;
  ComboBoxStatus.Enabled := True;
  RichEditKeterangan.Enabled := True;

  ListViewData.Selected := nil; 
  ListViewData.Enabled := False; // Disable ListView while inputting new data
  ClearFormFields;
end;

procedure TF_AbsensiData.RefreshListView;
begin
  ListViewData.Clear;
  ZQuery.SQL.Text := 'SELECT * FROM absensi WHERE DATE(datetime) = :tanggal ORDER BY datetime DESC';
  ZQuery.ParamByName('tanggal').AsDate := Date;
  ZQuery.Open;
  while not ZQuery.Eof do
  begin
    with ListViewData.Items.Add do
    begin
      Caption := ZQuery.FieldByName('npm').AsString;
      SubItems.Add(ZQuery.FieldByName('nama_mahasiswa').AsString);
      SubItems.Add(ZQuery.FieldByName('mata_kuliah').AsString);
      if ZQuery.FieldByName('status_absensi').AsInteger = 0 then
        SubItems.Add('Hadir')
      else if ZQuery.FieldByName('status_absensi').AsInteger = 1 then
        SubItems.Add('Izin')
      else if ZQuery.FieldByName('status_absensi').AsInteger = 2 then
        SubItems.Add('Sakit')
      else
        SubItems.Add('Alpha');
      SubItems.Add(ZQuery.FieldByName('keterangan').AsString);
      Data := Pointer(ZQuery.FieldByName('id_absensi').AsInteger);
    end;
    ZQuery.Next;
  end;
  ZQuery.Close;
end;

procedure TF_AbsensiData.ButtonBuatClick(Sender: TObject);
begin
  FMode := 'create';
  SetStateInputBaru;
end;

procedure TF_AbsensiData.ButtonSimpanClick(Sender: TObject);
var
  indexComboBox: Integer;
begin
  if (ComboBoxStatus.ItemIndex = -1) or
      (EditNPM.Text = '') or
      (EditMataKuliah.Text = '') or
      (EditNamaMahasiswa.Text = '') then
  begin
    ShowMessage('Silakan lengkapi semua data yang wajib diisi.');
    Exit;
  end
  else if (ComboBoxStatus.ItemIndex > 0) and (RichEditKeterangan.Text = '') then
  begin
    ShowMessage('Silakan isi keterangan jika status absensi tidak hadir.');
    Exit;
  end;
  if not ZConnection.Connected then
  begin
    ShowMessage('Koneksi ke database belum berhasil.');
    Exit;
  end;
  indexComboBox := ComboBoxStatus.ItemIndex; // 0: Hadir, 1: Izin, 2: Sakit, 3: Alpha
  try
    if FMode = 'create' then
    begin
      ZQuery.SQL.Text := 'INSERT INTO absensi (datetime, npm, nama_mahasiswa, mata_kuliah, status_absensi, keterangan) ' +
                         'VALUES (:datetime, :npm, :nama_mahasiswa, :mata_kuliah, :status_absensi, :keterangan)';
      ZQuery.ParamByName('datetime').AsDateTime := Now;
      ZQuery.ParamByName('npm').AsString := EditNPM.Text;
      ZQuery.ParamByName('nama_mahasiswa').AsString := EditNamaMahasiswa.Text;
      ZQuery.ParamByName('mata_kuliah').AsString := EditMataKuliah.Text;
      ZQuery.ParamByName('status_absensi').AsInteger := indexComboBox;
      if (indexComboBox = 0) and (RichEditKeterangan.Text = '') then
        ZQuery.ParamByName('keterangan').AsString := '-'
      else
        ZQuery.ParamByName('keterangan').AsString := RichEditKeterangan.Text;
      ZQuery.ExecSQL;
      ShowMessage('Data absensi berhasil ditambahkan.');
    end
    else if (FMode = 'edit') and (ListViewData.Selected <> nil) then
    begin
      ZQuery.SQL.Text := 'UPDATE absensi SET ' +
                         'status_absensi = :status_absensi, ' +
                         'nama_mahasiswa = :nama_mahasiswa, ' +
                         'keterangan = :keterangan ' +
                         'WHERE id_absensi = :id_absensi';
      ZQuery.ParamByName('status_absensi').AsInteger := indexComboBox;
      ZQuery.ParamByName('nama_mahasiswa').AsString := EditNamaMahasiswa.Text;
      if (indexComboBox = 0) and (RichEditKeterangan.Text = '') then
        ZQuery.ParamByName('keterangan').AsString := '-'
      else
        ZQuery.ParamByName('keterangan').AsString := RichEditKeterangan.Text;
      ZQuery.ExecSQL;
      ZQuery.ParamByName('id_absensi').AsInteger := Integer(ListViewData.Selected.Data);
      ZQuery.ExecSQL;
      ShowMessage('Data absensi berhasil diubah.');
    end;
    RefreshListView;
    SetStateAwal;
    FMode := '';
  except
    on E: Exception do
      ShowMessage('Gagal menyimpan data absensi: ' + E.Message);
  end;
end;

procedure TF_AbsensiData.ButtonHapusClick(Sender: TObject);
begin
  
  if ListViewData.Selected = nil then
  begin
    ShowMessage('Silakan pilih data absensi yang ingin dihapus.');
    Exit;
  end;

  if not ZConnection.Connected then
  begin
    ShowMessage('Koneksi ke database belum berhasil.');
    Exit;
  end;

  if MessageDlg('Apakah Anda yakin ingin menghapus data ini?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      ZQuery.SQL.Text := 'DELETE FROM absensi WHERE id_absensi = :id';
      ZQuery.ParamByName('id').AsInteger := Integer(ListViewData.Selected.Data);
      ZQuery.ExecSQL;
      ShowMessage('Data absensi berhasil dihapus.');
      RefreshListView;
      SetStateAwal;
    except
      on E: Exception do
        ShowMessage('Gagal menghapus data absensi: ' + E.Message);
    end;
  end;
end;

procedure TF_AbsensiData.ButtonUbahClick(Sender: TObject);
begin
  if ListViewData.Selected = nil then
  begin
    ShowMessage('Silakan pilih data absensi yang ingin diubah.');
    Exit;
  end;
  FMode := 'edit';
  SetStateEdit;
end;

procedure TF_AbsensiData.ButtonPreviewClick(Sender: TObject);
var
  LFinanceReport: TF_AbsensiQuickReport;
begin
  LFinanceReport := TF_AbsensiQuickReport.Create(Self);
  try
    LFinanceReport.GenerateReport(DateTimePickerReportData.Date);
  finally
    LFinanceReport.Free;
  end;
end;

procedure TF_AbsensiData.ListViewDataItemClick(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  
  if Selected then
  begin
    if Item.SubItems[2] = 'Hadir' then
      ComboBoxStatus.ItemIndex := 0
    else if Item.SubItems[2] = 'Izin' then
      ComboBoxStatus.ItemIndex := 1
    else if Item.SubItems[2] = 'Sakit' then
      ComboBoxStatus.ItemIndex := 2
    else if Item.SubItems[2] = 'Alpha' then
      ComboBoxStatus.ItemIndex := 3
    else
      ComboBoxStatus.ItemIndex := -1;
    EditNamaMahasiswa.Text := Item.SubItems[0];
    EditMataKuliah.Text := Item.SubItems[1];
    RichEditKeterangan.Text := Item.SubItems[3];
    EditNPM.Text := Item.Caption;
    ButtonUbah.Enabled := True;
    ButtonHapus.Enabled := True;
  end
  else
  begin
    ButtonUbah.Enabled := False;
    ButtonHapus.Enabled := False;
  end;
end;

procedure TF_AbsensiData.ButtonBatalClick(Sender: TObject);
begin  
  ClearFormFields;
  SetStateAwal;
end;

procedure TF_AbsensiData.ButtonKeluarClick(Sender: TObject);
begin  
  Application.Terminate;
end;

end.