unit U_laporan_kelas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, StdCtrls, Buttons, sBitBtn, sComboBox, Grids,
  DBGrids, sLabel, sGroupBox, sEdit;

type
  TF_laporan_akademis = class(TForm)
    sGroupBox1: TsGroupBox;
    sLabel1: TsLabel;
    sGroupBox2: TsGroupBox;
    cb_kelas: TsComboBox;
    btn_kelas: TsBitBtn;
    sPanel1: TsPanel;
    DBGrid1: TDBGrid;
    btn_nama: TsBitBtn;
    edit_nama: TsEdit;
    sLabel3: TsLabel;
    cb_semster_mapel: TsComboBox;
    sLabel13: TsLabel;
    cb_tahunajrn: TsComboBox;
    sLabel2: TsLabel;
    procedure FormShow(Sender: TObject);
    procedure cb_kelasClick(Sender: TObject);
    procedure btn_kelasClick(Sender: TObject);
    procedure edit_namaChange(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure btn_namaClick(Sender: TObject);
    procedure cb_tahunajrnClick(Sender: TObject);
    procedure cb_semster_mapelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_laporan_akademis: TF_laporan_akademis;

implementation

uses U_DM, U_laporan_akademis_k, Ulaporan_akademis_s;

{$R *.dfm}


function SetCueBanner(const Edit: TEdit; const Placeholder: String): Boolean;
const
  EM_SETCUEBANNER = $1501;
var
  UniStr: WideString;
begin
  UniStr := Placeholder;
  SendMessage(Edit.Handle, EM_SETCUEBANNER, WParam(True),LParam(UniStr));
  Result := GetLastError() = ERROR_SUCCESS;
end;
procedure TF_laporan_akademis.btn_kelasClick(Sender: TObject);
begin
if cb_kelas.Text='--Pilih--' then
begin
  Application.MessageBox('Pilih Dahulu kelas Akasemis','Warning',MB_OK+MB_ICONWARNING);
  cb_kelas.SetFocus;
end
else
begin
  with DM.q_akademis do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by akademis_kd ) as NO,siswa.siswa_nis,siswa.siswa_nama,akademis.akademis_kd,kepribadian.kep_jenis,akademis.nilai,akademis.akademis_keterangan,siswa.kelas_kd, kelas.kelas_nama, kelas.guru_nip, guru.guru_nama, '+
  'akademis.ta,akademis.smt from siswa, kelas, akademis, kepribadian, guru where akademis.kep_kd=kepribadian.kep_kd and siswa.kelas_kd=kelas.kelas_kd and kelas.guru_nip=guru.guru_nip and akademis.siswa_nis=siswa.siswa_nis and kelas_nama like '+QuotedStr(cb_kelas.Text);
  Active:=True;
  if DM.q_akademis.IsEmpty then
  begin
    ShowMessage('Data Akademis Tidak Ditemukan!!');
  end
  else
  begin
    with DM.q_akademis do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by akademis_kd ) as NO,siswa.siswa_nis,siswa.siswa_nama,akademis.akademis_kd,kepribadian.kep_jenis,akademis.nilai,akademis.akademis_keterangan,siswa.kelas_kd, kelas.kelas_nama, kelas.guru_nip, guru.guru_nama, '+
  'akademis.ta,akademis.smt from siswa, kelas, akademis, kepribadian, guru where akademis.kep_kd=kepribadian.kep_kd and siswa.kelas_kd=kelas.kelas_kd and kelas.guru_nip=guru.guru_nip and akademis.siswa_nis=siswa.siswa_nis and kelas_nama like '+QuotedStr(cb_kelas.Text);
  Active:=True;
  F_laporan_akademis_k.QuickRep1.DataSet:=DM.q_akademis;
  F_laporan_akademis_k.QRLKELAS.Caption:=DM.q_akademis.FieldByName('kelas_nama').AsString;
  F_laporan_akademis_k.QRLabelNIP.Caption:=DM.q_akademis.FieldByName('guru_nip').AsString;
  F_laporan_akademis_k.QRLTahun.Caption:=DM.q_akademis.FieldByName('ta').AsString;
  F_laporan_akademis_k.QRLabel22.Caption:=DM.q_akademis.FieldByName('smt').AsString;
  F_laporan_akademis_k.QRLlabelNAMA.Caption:=DM.q_akademis.FieldByName('guru_nama').AsString;
  F_laporan_akademis_k.QRPLabelnipt.Caption:=DM.q_akademis.FieldByName('guru_nip').AsString;
  F_laporan_akademis_k.QRPLabelnamawlait.Caption:=DM.q_akademis.FieldByName('guru_nama').AsString;
  F_laporan_akademis_k.QRDBNIS.DataSet:=DM.q_akademis; F_laporan_akademis_k.QRDBNIS.DataField:='siswa_nis';

  F_laporan_akademis_k.QRDBNAMA.DataSet:=DM.q_akademis; F_laporan_akademis_k.QRDBNAMA.DataField:='siswa_nama';
  F_laporan_akademis_k.QRDBTEMPAT.DataSet:=DM.q_akademis; F_laporan_akademis_k.QRDBTEMPAT.DataField:='kep_jenis';
  F_laporan_akademis_k.QRDBTGLLHR.DataSet:=DM.q_akademis; F_laporan_akademis_k.QRDBTGLLHR.DataField:='nilai';
  F_laporan_akademis_k.QRDBALAMAT.DataSet:=DM.q_akademis; F_laporan_akademis_k.QRDBALAMAT.DataField:='akademis_keterangan';
  F_laporan_akademis_k.QuickRep1.Preview;
end;
  end;
end;

end;
end;

procedure TF_laporan_akademis.btn_namaClick(Sender: TObject);
begin
if edit_nama.Text='' then
begin
  Application.MessageBox('Pilih Dahulu Nama Siswa','Warning',MB_OK+MB_ICONWARNING);
  edit_nama.SetFocus;
end
else
begin
  with DM.q_akademis do
  begin
      Active:=False;
  Close;
  SQL.Clear;
       SQL.Text:='select ROW_NUMBER() over (order by akademis_kd ) as NO,siswa.siswa_nis,siswa.siswa_nama,akademis.akademis_kd,kepribadian.kep_jenis,akademis.nilai,akademis.akademis_keterangan,siswa.kelas_kd, kelas.kelas_nama, kelas.guru_nip, guru.guru_nama, '+
       'akademis.ta,akademis.smt from siswa, kelas, akademis, kepribadian, guru where akademis.kep_kd=kepribadian.kep_kd and siswa.kelas_kd=kelas.kelas_kd and kelas.guru_nip=guru.guru_nip and akademis.siswa_nis=siswa.siswa_nis and siswa_nama like '+QuotedStr(edit_nama.Text + '%');
  Active:=True;
  if DM.q_akademis.IsEmpty then
  begin
    ShowMessage('DATA TIDAK DITEMUKAN !!');
  end
  else
    Active:=False;
  Close;
  SQL.Clear;
       SQL.Text:='select ROW_NUMBER() over (order by akademis_kd ) as NO,siswa.siswa_nis,siswa.siswa_nama,akademis.akademis_kd,kepribadian.kep_jenis,akademis.nilai,akademis.akademis_keterangan,siswa.kelas_kd, kelas.kelas_nama, kelas.guru_nip, guru.guru_nama, '+
       'akademis.ta,akademis.smt from siswa, kelas, akademis, kepribadian, guru where akademis.kep_kd=kepribadian.kep_kd and siswa.kelas_kd=kelas.kelas_kd and kelas.guru_nip=guru.guru_nip and akademis.siswa_nis=siswa.siswa_nis and siswa_nama like '+QuotedStr(edit_nama.Text + '%');
  Active:=True;
  F_laporan_akademis_s.QuickRep1.DataSet:=DM.q_akademis;
  F_laporan_akademis_s.QRLabelKELAS.Caption:=DM.q_akademis.FieldByName('kelas_nama').AsString;
  F_laporan_akademis_s.QRLlabelNAMA.Caption:=DM.q_akademis.FieldByName('siswa_nama').AsString;
    F_laporan_akademis_s.QRLTahun.Caption:=DM.q_akademis.FieldByName('ta').AsString;
  F_laporan_akademis_s.QRLabel22.Caption:=DM.q_akademis.FieldByName('smt').AsString;
  F_laporan_akademis_s.QRLabelNIP.Caption:=DM.q_akademis.FieldByName('siswa_nis').AsString;
  //F_laporan_akademis_k.QRLTahun.Caption:=DM.q_akademis.FieldByName('ta').AsString;
  //F_laporan_akademis_k.QRLabel22.Caption:=DM.q_akademis.FieldByName('smt').AsString;
  F_laporan_akademis_s.QRPLabelnipt.Caption:=DM.q_akademis.FieldByName('guru_nip').AsString;
  F_laporan_akademis_s.QRPLabelnamawlait.Caption:=DM.q_akademis.FieldByName('guru_nama').AsString;
  F_laporan_akademis_s.QRDBjenis.DataSet:=DM.q_akademis; F_laporan_akademis_s.QRDBjenis.DataField:='kep_jenis';
  F_laporan_akademis_s.QRDBnilai.DataSet:=DM.q_akademis; F_laporan_akademis_s.QRDBnilai.DataField:='nilai';
  F_laporan_akademis_s.QRDBKET.DataSet:=DM.q_akademis; F_laporan_akademis_s.QRDBKET.DataField:='akademis_keterangan';
  F_laporan_akademis_s.QuickRep1.Preview;
  end;
end;
end;

procedure TF_laporan_akademis.cb_kelasClick(Sender: TObject);
begin
with DM.q_akademis do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by akademis_kd ) as NO,siswa.siswa_nis,akademis.ta,akademis.smt,siswa.siswa_nama,akademis.akademis_kd,kepribadian.kep_jenis,akademis.nilai,akademis.akademis_keterangan,siswa.kelas_kd, kelas.kelas_nama,  '+
  'kelas.guru_nip, guru.guru_nama from siswa, kelas, akademis, kepribadian, guru where akademis.kep_kd=kepribadian.kep_kd and siswa.kelas_kd=kelas.kelas_kd and kelas.guru_nip=guru.guru_nip and akademis.siswa_nis=siswa.siswa_nis and ta like '+QuotedStr(cb_tahunajrn.Text)+' and smt like '+QuotedStr(cb_semster_mapel.Text)+' and kelas_nama like '+QuotedStr(cb_kelas.Text);
  Active:=True;
end;
DBGrid1.DataSource:=DM.ds_akadeis;
end;

procedure TF_laporan_akademis.cb_semster_mapelClick(Sender: TObject);
begin
with DM.q_akademis do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by akademis_kd ) as NO,siswa.siswa_nis,akademis.ta,akademis.smt,siswa.siswa_nama,akademis.akademis_kd,kepribadian.kep_jenis,akademis.nilai,akademis.akademis_keterangan,siswa.kelas_kd, kelas.kelas_nama,  '+
  'kelas.guru_nip, guru.guru_nama from siswa, kelas, akademis, kepribadian, guru where akademis.kep_kd=kepribadian.kep_kd and siswa.kelas_kd=kelas.kelas_kd and kelas.guru_nip=guru.guru_nip and akademis.siswa_nis=siswa.siswa_nis and ta like '+QuotedStr(cb_tahunajrn.Text)+' and smt like '+QuotedStr(cb_semster_mapel.Text) ;
  Active:=True;
end;
DBGrid1.DataSource:=DM.ds_akadeis;
end;

procedure TF_laporan_akademis.cb_tahunajrnClick(Sender: TObject);
begin
with DM.q_akademis do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by akademis_kd ) as NO,siswa.siswa_nis,akademis.ta,akademis.smt,siswa.siswa_nama,akademis.akademis_kd,kepribadian.kep_jenis,akademis.nilai,akademis.akademis_keterangan,siswa.kelas_kd, kelas.kelas_nama,  '+
  'kelas.guru_nip, guru.guru_nama from siswa, kelas, akademis, kepribadian, guru where akademis.kep_kd=kepribadian.kep_kd and siswa.kelas_kd=kelas.kelas_kd and kelas.guru_nip=guru.guru_nip and akademis.siswa_nis=siswa.siswa_nis and ta like '+QuotedStr(cb_tahunajrn.Text);
  Active:=True;
end;
DBGrid1.DataSource:=DM.ds_akadeis;
end;

procedure TF_laporan_akademis.DBGrid1CellClick(Column: TColumn);
begin
with DM.q_akademis do
begin
  edit_nama.Text:=FieldByName('siswa_nama').AsString;
end;
end;

procedure TF_laporan_akademis.edit_namaChange(Sender: TObject);
begin
if edit_nama.Text='' then
begin
with DM.q_akademis do
begin
  Active:=False;
  Close;
  SQL.Clear;
    SQL.Text:='select ROW_NUMBER() over (order by akademis_kd ) as NO,siswa.siswa_nis,siswa.siswa_nama,akademis.akademis_kd,kepribadian.kep_jenis,akademis.nilai,akademis.akademis_keterangan,siswa.kelas_kd, kelas.kelas_nama, kelas.guru_nip, guru.guru_nama, '+
    'akademis.ta,akademis.smt from siswa, kelas, akademis, kepribadian, guru where akademis.kep_kd=kepribadian.kep_kd and siswa.kelas_kd=kelas.kelas_kd and kelas.guru_nip=guru.guru_nip and akademis.siswa_nis=siswa.siswa_nis';
    Active:=True;
end;
DBGrid1.DataSource:=DM.ds_akadeis;

end
else
begin
 with DM.q_akademis do
begin
  Active:=False;
  Close;
  SQL.Clear;
       SQL.Text:='select ROW_NUMBER() over (order by akademis_kd ) as NO,siswa.siswa_nis,siswa.siswa_nama,akademis.akademis_kd,kepribadian.kep_jenis,akademis.nilai,akademis.akademis_keterangan,siswa.kelas_kd, kelas.kelas_nama, kelas.guru_nip, guru.guru_nama, '+
       'akademis.ta,akademis.smt from siswa, kelas, akademis, kepribadian, guru where akademis.kep_kd=kepribadian.kep_kd and siswa.kelas_kd=kelas.kelas_kd and kelas.guru_nip=guru.guru_nip and akademis.siswa_nis=siswa.siswa_nis and siswa_nama like '+QuotedStr(edit_nama.Text + '%');
  Active:=True;


end;
DBGrid1.DataSource:=DM.ds_akadeis;

end;
end;

procedure TF_laporan_akademis.FormShow(Sender: TObject);
begin
DM.q_kelas.Active:=False;
DM.q_kelas.SQL.Clear;
DM.q_kelas.SQL.Add('select * from kelas');
DM.q_kelas.Active:=True;
cb_kelas.Items.Clear;
while not DM.q_kelas.Eof do
begin
  cb_kelas.Items.Add(DM.q_kelas.FieldByName('kelas_nama').AsString);
  DM.q_kelas.Next;
end;
cb_kelas.Text:='--Pilih--';
cb_tahunajrn.Text:='--Pilih--';
cb_semster_mapel.Text:='--Pilih--';
edit_nama.Clear;
SetCueBanner(edit_nama,'Masukkan nama Siswa');


{with DM.q_akademis do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by akademis_kd ) as NO,siswa.siswa_nis,siswa.siswa_nama,akademis.akademis_kd,kepribadian.kep_jenis,akademis.nilai,akademis.akademis_keterangan,siswa.kelas_kd, kelas.kelas_nama, kelas.guru_nip, guru.guru_nama '+
  ' from siswa, kelas, akademis, kepribadian, guru where akademis.kep_kd=kepribadian.kep_kd and siswa.kelas_kd=kelas.kelas_kd and kelas.guru_nip=guru.guru_nip and akademis.siswa_nis=siswa.siswa_nis';
  Active:=True;
end;
DBGrid1.DataSource:=DM.ds_akadeis;  }

end;

end.
