unit U_data_nilai;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, sBitBtn, sEdit, sComboBox,
  sGroupBox, sLabel, Menus, DB, DBTables;

type
  TF_data_nilai = class(TForm)
    sGroupBox1: TsGroupBox;
    sLabel3: TsLabel;
    sGroupBox2: TsGroupBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    cb_kategori: TsComboBox;
    Edit_key: TsEdit;
    sGroupBox3: TsGroupBox;
    btn_ubah: TsBitBtn;
    btn_tambah: TsBitBtn;
    btn_hapus: TsBitBtn;
    DBGrid1: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure btn_tambahClick(Sender: TObject);
    procedure btn_ubahClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure btn_hapusClick(Sender: TObject);
    procedure Edit_keyChange(Sender: TObject);
    procedure Ubah1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure tampil;
  end;

var
  F_data_nilai: TF_data_nilai;

implementation

uses U_DM, U_input_nilai;

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


procedure TF_data_nilai.btn_hapusClick(Sender: TObject);
begin
if (Application.MessageBox('Yakin Hapus Data Nilai ini ?','KONFIRM',MB_YESNO+MB_ICONQUESTION)=ID_YES) then

begin
try
   DM.koneksi.BeginTrans;
   with DM.q_nilai do
   begin
     Connection:=DM.koneksi;
     SQL.Text:='delete from nilai where nilai_kd='+QuotedStr(sLabel3.Caption);
     ExecSQL;
   end;
   DM.koneksi.CommitTrans;
   ShowMessage('Data Nilai Berhasil Terhapus');
except
DM.koneksi.RollbackTrans;
ShowMessage('Data Nilai Gagal Terhapus');


end;
tampil;
end;
end;

procedure TF_data_nilai.btn_tambahClick(Sender: TObject);
begin
F_input_nilai.Show;
F_input_nilai.btn_edit.Enabled:=False;
F_input_nilai.btn_simpan.Enabled:=True;
F_input_nilai.edit_Kd.Enabled:=False;
//F_input_nilai.edit_Kd.SetFocus;
                                 with DM.ADOQuery1 do
begin
  Close;
  SQL.Clear;
SQL.Add('select * from nilai');
Open;
  if (DM.ADOQuery1.RecordCount<=0) then
  begin
    F_input_nilai.edit_Kd.Text:='NIL001';
  end
  else
  begin
    DM.ADOQuery1.Close;
    DM.ADOQuery1.SQL.Clear;
    DM.ADOQuery1.SQL.Add('select max(right(nilai_kd,3))as kode from nilai');
    DM.ADOQuery1.Open;
    F_input_nilai.edit_kd.Text:='NIL00'+IntToStr(DM.ADOQuery1['kode']+1);
  end

     end;

end;

procedure TF_data_nilai.btn_ubahClick(Sender: TObject);
begin
  F_input_nilai.Show;
 F_input_nilai.btn_simpan.Enabled:=False;
 F_input_nilai.btn_edit.Enabled:=True;
 F_input_nilai.edit_Kd.Enabled:=False;
 F_input_nilai.cb_semster_mapel.SetFocus;

 with DM.q_nilai do


 begin
   F_input_nilai.edit_Kd.Text:=FieldByName('nilai_kd').AsString;
   F_input_nilai.cb_tahunajrn.Text:=FieldByName('tahun').AsString;
   F_input_nilai.cb_nis.Text:=FieldByName('siswa_nis').AsString;
   F_input_nilai.cb_mapel.Text:=FieldByName('mapel_kd').AsString;
   F_input_nilai.edit_ulangan.Text:=FieldByName('nilai_ulangan').AsString;
   F_input_nilai.edit_tugas.Text:=FieldByName('nilai_tugas').AsString;
   F_input_nilai.edit_uts.Text:=FieldByName('nilai_uts').AsString;
   F_input_nilai.edit_uas.Text:=FieldByName('nilai_uas').AsString;
   F_input_nilai.edit_total.Text:=FieldByName('nilai_total').AsString;
   F_input_nilai.edit_ket.Text:=FieldByName('nilai_keterangan').AsString;

 end;
 with DM.q_mapel do
 begin
   Active:=False;
   Close;
   SQL.Clear;
   SQL.Text:='select * from mapel where mapel_kd='+QuotedStr(F_input_nilai.cb_mapel.Text);
   Active:=True;
   F_input_nilai.cb_semster_mapel.Text:=FieldByName('mapel_smt').AsString;
   F_input_nilai.edit_nama_mapel.Text:=FieldByName('mapel_nama').AsString;
 end;
 with DM.q_siswa do
 begin
   Active:=False;
   Close;
   SQL.Clear;
   SQL.Text:='select * from siswa where siswa_nis='+QuotedStr(F_input_nilai.cb_nis.Text);
   Active:=True;
   F_input_nilai.cb_kelas_siswa.Text:=FieldByName('kelas_kd').AsString;
   F_input_nilai.edit_nama_siswa.Text:=FieldByName('siswa_nama').AsString;
 end;


end;

procedure TF_data_nilai.DBGrid1CellClick(Column: TColumn);
begin
with DM.q_nilai do
begin
  sLabel3.Caption:=FieldValues['nilai_kd'];
end;
end;

procedure TF_data_nilai.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
if (TDBGrid(Sender).DataSource.DataSet.FieldByName('nilai_keterangan').AsString='TIDAK TUNTAS') then
TDBGrid(Sender).Canvas.Brush.Color:=clRed
else
TDBGrid(Sender).Canvas.Brush.Color:=clSkyBlue;
TDBGrid(Sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
//end;


end;

procedure TF_data_nilai.Edit_keyChange(Sender: TObject);
var cari:string;
begin
 if cb_kategori.Text='Tahun Ajaran' then
 cari:='tahun'
 else if cb_kategori.Text='Semester' then
 cari:='mapel_smt'
 else if cb_kategori.Text='Kelas' then
 cari:='kelas_nama'
 else if cb_kategori.Text='Nama Siswa' then
 cari:='siswa_nama'
 else if cb_kategori.Text='Mata Pelajaran' then
 cari:='mapel_nama'
 else if cb_kategori.Text='Keterangan' then
 cari:='nilai_keterangan';

 if Edit_key.Text='' then
 begin
with DM.q_nilai do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by nilai_kd) as NO, nilai.nilai_kd,nilai.tahun,mapel.mapel_smt,kelas.kelas_nama,nilai.siswa_nis,siswa.siswa_nama,mapel.mapel_kd,mapel.mapel_nama,nilai.nilai_ulangan,nilai.nilai_tugas,nilai.nilai_uts,nilai.nilai_uas,'+
  'nilai.nilai_total,nilai.nilai_keterangan from kelas,siswa,nilai,mapel where nilai.siswa_nis=siswa.siswa_nis and nilai.mapel_kd=mapel.mapel_kd and siswa.kelas_kd=kelas.kelas_kd';
  Active:=True;
end;
   DBGrid1.DataSource:=DM.ds_nilai;

 end
 else
 begin
     with DM.q_nilai do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by nilai_kd) as NO, nilai.nilai_kd,nilai.tahun,mapel.mapel_smt,kelas.kelas_nama,nilai.siswa_nis,siswa.siswa_nama,mapel.mapel_kd,mapel.mapel_nama,nilai.nilai_ulangan,nilai.nilai_tugas,nilai.nilai_uts,nilai.nilai_uas,'+
  'nilai.nilai_total,nilai.nilai_keterangan from kelas,siswa,nilai,mapel where nilai.siswa_nis=siswa.siswa_nis and nilai.mapel_kd=mapel.mapel_kd and siswa.kelas_kd=kelas.kelas_kd and '+cari+' like '+QuotedStr(Edit_key.Text+ '%') ;
  Active:=True;
 end;
  DBGrid1.DataSource:=DM.ds_nilai;
 end;






end;

procedure TF_data_nilai.FormShow(Sender: TObject);
begin
cb_kategori.Text:='Tahun Ajaran';
Edit_key.Clear;
Edit_key.SetFocus;
sLabel3.Caption:='';



SetCueBanner(Edit_key,'Masukkan Kata Pencarian');
end;

procedure TF_data_nilai.tampil;
begin
with DM.q_nilai do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by nilai_kd) as NO, nilai.nilai_kd,nilai.tahun,mapel.mapel_smt,kelas.kelas_nama,nilai.siswa_nis,siswa.siswa_nama,mapel.mapel_kd,mapel.mapel_nama,nilai.nilai_ulangan,nilai.nilai_tugas,nilai.nilai_uts,nilai.nilai_uas,'+
  'nilai.nilai_total,nilai.nilai_keterangan from kelas,siswa,nilai,mapel where nilai.siswa_nis=siswa.siswa_nis and nilai.mapel_kd=mapel.mapel_kd and siswa.kelas_kd=kelas.kelas_kd';
  Active:=True;
  DBGrid1.DataSource:=DM.ds_nilai;
  DM.ds_nilai.DataSet:=DM.q_nilai;
end;
//end;

end;

procedure TF_data_nilai.Ubah1Click(Sender: TObject);
begin
 F_input_nilai.Show;
 F_input_nilai.btn_simpan.Enabled:=False;
 F_input_nilai.btn_edit.Enabled:=True;
 F_input_nilai.edit_Kd.Enabled:=False;

 with DM.q_nilai do
 begin
 F_input_nilai.edit_Kd.Text:=FieldValues['nilai_kd'];
   F_input_nilai.cb_tahunajrn.Text:=FieldByName('tahun').AsString;
   F_input_nilai.cb_nis.Text:=FieldByName('siswa_nis').AsString;
   F_input_nilai.cb_mapel.Text:=FieldByName('mapel_kd').AsString;
   F_input_nilai.edit_ulangan.Text:=FieldByName('nilai_ulangan').AsString;
   F_input_nilai.edit_tugas.Text:=FieldByName('nilai_tugas').AsString;
   F_input_nilai.edit_uts.Text:=FieldByName('nilai_uts').AsString;
   F_input_nilai.edit_uas.Text:=FieldByName('nilai_uas').AsString;
   F_input_nilai.edit_total.Text:=FieldByName('nilai_total').AsString;
   F_input_nilai.edit_ket.Text:=FieldByName('nilai_keterangan').AsString;

end;
with DM.q_mapel do
 begin
   Active:=False;
   Close;
   SQL.Clear;
   SQL.Text:='select * from mapel where mapel_kd='+QuotedStr(F_input_nilai.cb_mapel.Text);
   Active:=True;
   F_input_nilai.cb_semster_mapel.Text:=FieldByName('mapel_smt').AsString;
   F_input_nilai.edit_nama_mapel.Text:=FieldByName('mapel_nama').AsString;
 end;
 with DM.q_siswa do
 begin
   Active:=False;
   Close;
   SQL.Clear;
   SQL.Text:='select * from siswa where siswa_nis='+QuotedStr(F_input_nilai.cb_nis.Text);
   Active:=True;
   F_input_nilai.cb_kelas_siswa.Text:=FieldByName('kelas_kd').AsString;
   F_input_nilai.edit_nama_siswa.Text:=FieldByName('siswa_nama').AsString;
   end
 //end;



end;

end.
