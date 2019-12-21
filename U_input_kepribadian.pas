unit U_input_kepribadian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, sMemo, sComboBox, sLabel, sEdit,
  sGroupBox, ExtCtrls, sPanel;

type
  Tf_input_akademis = class(TForm)
    sPanel1: TsPanel;
    sGroupBox1: TsGroupBox;
    edit_kd: TsEdit;
    sLabel1: TsLabel;
    cb_nis: TsComboBox;
    sLabel2: TsLabel;
    edit_nama: TsEdit;
    sLabel3: TsLabel;
    cb_kepribadian: TsComboBox;
    sLabel4: TsLabel;
    edit_keprbadian: TsEdit;
    sLabel5: TsLabel;
    sLabel6: TsLabel;
    edit_keterangan: TsMemo;
    sGroupBox2: TsGroupBox;
    btn_edit: TsBitBtn;
    btn_simpan: TsBitBtn;
    cb_kelas: TsComboBox;
    Cb_nilai: TsComboBox;
    sLabel7: TsLabel;
    sLabel8: TsLabel;
    sLabel9: TsLabel;
    cb_tahunajrn: TsComboBox;
    cb_semster_mapel: TsComboBox;
    sLabel13: TsLabel;
    procedure FormShow(Sender: TObject);
    procedure cb_nisClick(Sender: TObject);
    procedure cb_kepribadianClick(Sender: TObject);
    procedure btn_simpanClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure cb_kelasChange(Sender: TObject);
    procedure Cb_nilaiChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure bersih;
    procedure simpanakademis;
  end;

var
  f_input_akademis: Tf_input_akademis;

implementation

uses U_DM, U_data_akademis;

{$R *.dfm}
procedure Tf_input_akademis.bersih;
begin
edit_kd.Clear;
//edit_kd.SetFocus;
cb_kelas.Text:='--Pilih--';
Cb_nilai.Text:='--Pilih--';
cb_nis.Text:='--Pilih--';
cb_tahunajrn.Text:='--Pilih--';
cb_semster_mapel.Text:='--Pilih--';
edit_nama.Clear;
edit_nama.Enabled:=False;
cb_kepribadian.Text:='--Pilih--';
edit_keprbadian.Clear;
edit_keprbadian.Enabled:=False;
edit_keterangan.Clear;
edit_keterangan.Enabled:=False;

end;

procedure Tf_input_akademis.btn_editClick(Sender: TObject);
begin
 if edit_kd.Text='' then
begin
   Application.MessageBox('Data Kode Akademis Masih Kosong','Warning',+MB_OK+MB_ICONWARNING);
   edit_kd.SetFocus;
end
else if cb_nis.Text='--Pilih--' then
begin
    Application.MessageBox('NIS Masih Kosong Silahkan Pilih','Waning',+MB_OK+MB_ICONWARNING);
    cb_nis.SetFocus;
end
else if cb_kepribadian.Text='--Pilih--' then
begin
 Application.MessageBox('Kode Kepribadian Masih Kosong Silahkan Pilih','Warning',+MB_OK+MB_ICONWARNING);
cb_kepribadian.SetFocus;
end
else if Cb_nilai.Text='--Pilih--' then
     begin
       Application.MessageBox('Nilai Masih Kosong Silahkan Pilih','Warning',MB_OK+MB_ICONWARNING);
       Cb_nilai.SetFocus;
     end
else if edit_keterangan.Text='' then
     begin
       Application.MessageBox('Data Keterangan Masih Kosong','Warning',+MB_OK+MB_ICONWARNING);
       edit_keterangan.SetFocus;
     end

else
begin
  with DM.q_akademis do
  begin
    Active:=False;
    SQL.Text:='select * from akademis';
    Active:=True;
  end;
  try
    DM.koneksi.BeginTrans;
    with DM.q_akademis do
    begin
      Active:=True;
      Close;
      SQL.Clear;
      SQL.Text:='update akademis set ta='+QuotedStr(cb_tahunajrn.Text)+', smt='+QuotedStr(cb_semster_mapel.Text)+', siswa_nis='+QuotedStr(cb_nis.Text)+',kep_kd='+QuotedStr(cb_kepribadian.Text)+',nilai='+QuotedStr(Cb_nilai.Text)+',akademis_keterangan='+QuotedStr(edit_keterangan.Text)+'where akademis_kd='+QuotedStr(edit_kd.Text);
      ExecSQL;
    end;
    DM.koneksi.CommitTrans;
    ShowMessage('Data Akademis Berhasil di Rubah');
  except
    DM.koneksi.RollbackTrans;
    ShowMessage('Data AKademis Gagal di Rubah');
  end;
F_data_akademis.tampil;
f_input_akademis.Close;
end;
end;

procedure Tf_input_akademis.btn_simpanClick(Sender: TObject);
begin
if edit_kd.Text='' then
begin
   Application.MessageBox('Data Kode Akademis Masih Kosong','Warning',+MB_OK+MB_ICONWARNING);
   edit_kd.SetFocus;
end
else if cb_nis.Text='--Pilih--' then
begin
    Application.MessageBox('NIS Masih Kosong Silahkan Pilih','Waning',+MB_OK+MB_ICONWARNING);
    cb_nis.SetFocus;
end
else if cb_kepribadian.Text='--Pilih--' then
begin
 Application.MessageBox('Kode Kepribadian Masih Kosong Silahkan Pilih','Warning',+MB_OK+MB_ICONWARNING);
cb_kepribadian.SetFocus;
end
else if Cb_nilai.Text='--Pilih--' then
     begin
       Application.MessageBox('Nilai Masih Kosong Silahkan Pilih','Warning',MB_OK+MB_ICONWARNING);
       Cb_nilai.SetFocus;
     end
else if edit_keterangan.Text='' then
     begin
       Application.MessageBox('Data Keterangan Masih Kosong','Warning',+MB_OK+MB_ICONWARNING);
       edit_keterangan.SetFocus;
     end

else
begin
  with DM.q_akademis do
  begin
    Active:=False;
    Close;
    SQL.Clear;
    SQL.Text:='select * from akademis where akademis_kd='+QuotedStr(edit_kd.Text);
    Active:=True;
  end;
  if DM.q_akademis.IsEmpty then
  begin
    simpanakademis;
  end
  else
  ShowMessage('Kode Akademis sudah di Gunakan');

    F_data_akademis.tampil;
  f_input_akademis.Close;
end;


end;

procedure Tf_input_akademis.cb_kelasChange(Sender: TObject);
begin
DM.q_siswa.Active:=False;
DM.q_siswa.Close;
DM.q_siswa.SQL.Clear;
DM.q_siswa.SQL.Add('select * from siswa');
DM.q_siswa.SQL.Add(' where kelas_kd like '+QuotedStr(cb_kelas.Text));
DM.q_siswa.Active:=True;
cb_nis.Items.Clear;
while not DM.q_siswa.Eof do
begin
  cb_nis.Items.Add(DM.q_siswa.FieldByName('siswa_nis').AsString);
  DM.q_siswa.Next;
end;
end;

procedure Tf_input_akademis.cb_kepribadianClick(Sender: TObject);
begin
DM.q_kepribadian.Active:=False;
DM.q_kepribadian.SQL.Clear;
DM.q_kepribadian.SQL.Add('select kep_jenis, kep_kd from kepribadian');
DM.q_kepribadian.SQL.Add('where kep_kd='''+cb_kepribadian.Text+'''');
DM.q_kepribadian.Open;
edit_keprbadian.Text:=DM.q_kepribadian['kep_jenis'];
end;

procedure Tf_input_akademis.Cb_nilaiChange(Sender: TObject);
begin
if Cb_nilai.Text='A' then
edit_keterangan.Text:='Sangat Baik'
else if Cb_nilai.Text='B' then
     edit_keterangan.Text:='Baik'
     else if Cb_nilai.Text='C' then
          edit_keterangan.Text:='Sedang'
          else if Cb_nilai.Text='D' then
               edit_keterangan.Text:='Buruk'
               else if Cb_nilai.Text='E' then
                    edit_keterangan.Text:='Sangat Buruk';

end;

procedure Tf_input_akademis.cb_nisClick(Sender: TObject);
begin
DM.q_siswa.Active:=False;
DM.q_siswa.SQL.Clear;
DM.q_siswa.SQL.Add('select siswa_nama, siswa_nis from siswa');
DM.q_siswa.SQL.Add('where siswa_nis='''+cb_nis.Text+'''');
DM.q_siswa.Open;
edit_nama.Text:=DM.q_siswa['siswa_nama'];
end;

procedure Tf_input_akademis.FormShow(Sender: TObject);
begin
DM.q_kelas.Active:=False;
DM.q_kelas.SQL.Clear;
DM.q_kelas.SQL.Add('select * from kelas');
DM.q_kelas.Active:=True;
cb_kelas.Items.Clear;
while not DM.q_kelas.Eof do
begin
  cb_kelas.Items.Add(DM.q_kelas.FieldByName('kelas_kd').AsString);
  DM.q_kelas.Next;
end;

bersih;
begin
  DM.q_siswa.Active:=False;
  DM.q_siswa.SQL.Clear;
  DM.q_siswa.SQL.Add('select * from siswa')  ;
  DM.q_siswa.Active:=True;
  cb_nis.Items.Clear;
  while not DM.q_siswa.Eof do
  begin
      cb_nis.Items.Add(DM.q_siswa.FieldByName('siswa_nis').AsString);
      DM.q_siswa.Next;
  end;
end;
begin
  DM.q_kepribadian.Active:=False;
  DM.q_kepribadian.SQL.Clear;
  DM.q_kepribadian.SQL.Add('select * from kepribadian');
  DM.q_kepribadian.Active:=True;
  cb_kepribadian.Items.Clear;
  while not DM.q_kepribadian.Eof do
  begin
    cb_kepribadian.Items.Add(DM.q_kepribadian.FieldByName('kep_kd').AsString);
    DM.q_kepribadian.Next;
  end;
end;
end;
procedure Tf_input_akademis.simpanakademis;
begin
with DM.q_akademis do
begin
  Active:=False;
  sql.Text:='select * from akademis';
  Active:=True;
end;
try
  DM.koneksi.BeginTrans;
  with DM.q_akademis do
  begin
    Active:=True;
    Close;
    SQL.Clear;
    SQL.Add('insert into akademis values ('+QuotedStr(edit_kd.Text)+','+QuotedStr(cb_tahunajrn.Text)+','+QuotedStr(cb_semster_mapel.Text)+','+QuotedStr(cb_nis.Text)+','+QuotedStr(cb_kepribadian.Text)+','+QuotedStr(Cb_nilai.Text)+','+QuotedStr(edit_keterangan.Text)+')');
    ExecSQL;
  end;
  DM.koneksi.CommitTrans;
  ShowMessage('Data Akademis Tersimpan');
except
  DM.koneksi.RollbackTrans;
  ShowMessage('Data Akademis Gagal disimpan');
end;

end;

end.
