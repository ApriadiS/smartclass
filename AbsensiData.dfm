object F_AbsensiData: TF_AbsensiData
  Left = 0
  Top = 0
  Caption = 'Absensi'
  ClientHeight = 631
  ClientWidth = 881
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object GroupBoxHutangPiutang: TGroupBox
    Left = 8
    Top = 8
    Width = 865
    Height = 616
    Caption = 'Hutang Piutang'
    TabOrder = 0
    object LabelNPM: TLabel
      Left = 15
      Top = 31
      Width = 27
      Height = 15
      Caption = 'NPM'
    end
    object LabelNamaMahasiswa: TLabel
      Left = 15
      Top = 59
      Width = 93
      Height = 15
      Caption = 'Nama Mahasiswa'
    end
    object LabelMataKuliah: TLabel
      Left = 15
      Top = 88
      Width = 63
      Height = 15
      Caption = 'Mata Kuliah'
    end
    object LabelReportData: TLabel
      Left = 543
      Top = 18
      Width = 62
      Height = 15
      Caption = 'Report Data'
    end
    object LabelStatusAbsensi: TLabel
      Left = 15
      Top = 117
      Width = 76
      Height = 15
      Caption = 'Status Absensi'
    end
    object LabelKeterangan: TLabel
      Left = 15
      Top = 146
      Width = 60
      Height = 15
      Caption = 'Keterangan'
    end
    object LabelTanggalAbsensi: TLabel
      Left = 15
      Top = 299
      Width = 86
      Height = 15
      Caption = 'Tanggal Absensi'
    end
    object ListViewData: TListView
      Left = 15
      Top = 325
      Width = 834
      Height = 276
      Columns = <
        item
          AutoSize = True
          Caption = 'NPM'
        end
        item
          AutoSize = True
          Caption = 'Nama Mahasiswa'
        end
        item
          AutoSize = True
          Caption = 'Mata Kuliah'
        end
        item
          AutoSize = True
          Caption = 'Status'
        end
        item
          AutoSize = True
          Caption = 'Keterangan'
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 16
      TabStop = False
      ViewStyle = vsReport
    end
    object ButtonBuat: TButton
      Left = 340
      Top = 27
      Width = 75
      Height = 23
      Caption = 'Buat'
      TabOrder = 5
    end
    object ButtonHapus: TButton
      Left = 340
      Top = 58
      Width = 75
      Height = 23
      Caption = 'Hapus'
      TabOrder = 7
    end
    object ButtonUbah: TButton
      Left = 421
      Top = 27
      Width = 75
      Height = 23
      Caption = 'Ubah'
      TabOrder = 6
    end
    object ButtonBatal: TButton
      Left = 421
      Top = 58
      Width = 75
      Height = 23
      Caption = 'Batal'
      TabOrder = 8
    end
    object ButtonKeluar: TButton
      Left = 421
      Top = 89
      Width = 75
      Height = 23
      Caption = 'Keluar'
      TabOrder = 10
    end
    object ButtonSimpan: TButton
      Left = 340
      Top = 89
      Width = 75
      Height = 23
      Caption = 'Simpan'
      TabOrder = 9
    end
    object ComboBoxStatus: TComboBox
      Left = 127
      Top = 114
      Width = 185
      Height = 23
      Style = csDropDownList
      TabOrder = 3
    end
    object EditMataKuliah: TEdit
      Left = 127
      Top = 85
      Width = 185
      Height = 23
      TabOrder = 2
    end
    object ButtonPreview: TButton
      Left = 744
      Top = 39
      Width = 96
      Height = 25
      Caption = 'Preview'
      TabOrder = 15
    end
    object DateTimePickerReportData: TDateTimePicker
      Left = 543
      Top = 39
      Width = 186
      Height = 25
      Date = 45838.000000000000000000
      Format = 'dd-MMMM-yyyy'
      Time = 0.986119849534588900
      TabOrder = 14
    end
    object EditNPM: TEdit
      Left = 127
      Top = 27
      Width = 185
      Height = 23
      TabOrder = 0
    end
    object EditNamaMahasiswa: TEdit
      Left = 127
      Top = 56
      Width = 185
      Height = 23
      TabOrder = 1
    end
    object RichEditKeterangan: TRichEdit
      Left = 127
      Top = 143
      Width = 185
      Height = 106
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object DateTimePickerAbsensi: TDateTimePicker
      Left = 127
      Top = 294
      Width = 186
      Height = 25
      Date = 45838.000000000000000000
      Format = 'dd-MMMM-yyyy'
      Time = 0.986119849534588900
      TabOrder = 11
    end
    object ButtonCari: TButton
      Left = 320
      Top = 294
      Width = 75
      Height = 23
      Caption = 'Cari'
      TabOrder = 12
    end
    object ButtonReset: TButton
      Left = 401
      Top = 294
      Width = 75
      Height = 23
      Caption = 'Reset'
      TabOrder = 13
    end
  end
  object ZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    DisableSavepoints = False
    HostName = ''
    Port = 0
    Database = ''
    User = ''
    Password = ''
    Protocol = ''
    Left = 640
    Top = 88
  end
  object ZQuery: TZQuery
    Params = <>
    Left = 560
    Top = 88
  end
end
