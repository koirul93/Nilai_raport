unit U_data_tgsAjar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, sBitBtn, sEdit, sComboBox,
  sGroupBox, sLabel;

type
  TF_data_tgsAjar = class(TForm)
    sGroupBox1: TsGroupBox;
    sLabel3: TsLabel;
    sGroupBox2: TsGroupBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    cb_kategori: TsComboBox;
    Edit_key: TsEdit;
    DBGrid1: TDBGrid;
    sGroupBox3: TsGroupBox;
    btn_ubah: TsBitBtn;
    btn_tambah: TsBitBtn;
    btn_hapus: TsBitBtn;
    procedure btn_tambahClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_ubahClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure btn_hapusClick(Sender: TObject);
    procedure Edit_keyChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure tampil;
  end;

var
  F_data_tgsAjar: TF_data_tgsAjar;

implementation

uses U_input_tgsajar, U_DM;

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


procedure TF_data_tgsAjar.btn_ubahClick(Sender: TObject);
begin
F_input_tgsajar.Show;
F_input_tgsajar.btn_simpan.Enabled:=False;
F_input_tgsajar.btn_edit.Enabled:=True;
F_input_tgsajar.edit_kdtgsajr.Enabled:=False;
F_input_tgsajar.cb_kdmapel.SetFocus;

with DM.q_tugasmengajar do
begin

  F_input_tgsajar.edit_kdtgsajr.Text:=FieldByName('tm_kd').AsString;
  F_input_tgsajar.cb_kdmapel.Text:=FieldByName('mapel_kd').AsString;
  F_input_tgsajar.edit_jlmhsiswa.Text:=FieldByName('siswa').AsString;
  F_input_tgsajar.cb_kdguru.Text:=FieldByName('guru_nip').AsString;
  F_input_tgsajar.cb_semester.Text:=FieldByName('mapel_smt').AsString;
  F_input_tgsajar.cb_kelas.Text:=FieldByName('kelas_kd').AsString ;
end;
with DM.q_guru do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select * from guru where guru_nip='+QuotedStr(F_input_tgsajar.cb_kdguru.Text);
  Active:=True;
  F_input_tgsajar.edit_namaguru.Text:=FieldByName('guru_nama').AsString;
end;
with DM.q_mapel do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select * from mapel where mapel_kd='+QuotedStr(F_input_tgsajar.cb_kdmapel.Text);
  Active:=True;
  F_input_tgsajar.edit_nmmapel.Text:=FieldByName('mapel_nama').AsString;
end;

end;

procedure TF_data_tgsAjar.DBGrid1CellClick(Column: TColumn);
begin
with DM.q_tugasmengajar do
begin
  sLabel3.Caption:=FieldByName('tm_kd').AsString;
end;
end;

procedure TF_data_tgsAjar.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
if DBGrid1.DataSource.DataSet.RecNo mod 2 =0 then
DBGrid1.Canvas.Brush.Color := clSkyBlue;
DBGrid1.DefaultDrawColumnCell(rect, datacol, column, state);
end;

procedure TF_data_tgsAjar.Edit_keyChange(Sender: TObject);
var cari: string;
begin
if cb_kategori.Text='Nama Mata Pelajaran' then
cari:='mapel_nama'
else if cb_kategori.Text='Nama Guru' then
cari:='guru_nama';

if Edit_key.Text='' then
begin
  with DM.q_tugasmengajar do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by tm_kd ) as NO, tugasmengajar.tm_kd,tugasmengajar.mapel_kd ,mapel.mapel_nama,guru.guru_nip,guru.guru_nama,kelas.kelas_kd,mapel.mapel_smt, tugasmengajar.siswa  from kelas,mapel,tugasmengajar, guru'    +
  ' where tugasmengajar.kelas_kd=kelas.kelas_kd and tugasmengajar.guru_nip=guru.guru_nip and tugasmengajar.mapel_kd=mapel.mapel_kd';
  Active:=True;
end;
DBGrid1.DataSource:=DM.ds_tugasmengajar;
end
else
begin
  with DM.q_tugasmengajar do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by tm_kd ) as NO, tugasmengajar.tm_kd,tugasmengajar.mapel_kd ,mapel.mapel_nama,guru.guru_nip,guru.guru_nama,kelas.kelas_kd,mapel.mapel_smt, tugasmengajar.siswa  from kelas,mapel,tugasmengajar, guru'    +
  ' where tugasmengajar.kelas_kd=kelas.kelas_kd and tugasmengajar.guru_nip=guru.guru_nip and tugasmengajar.mapel_kd=mapel.mapel_kd and '+cari+' like '+QuotedStr(Edit_key.Text+ '%');
  Active:=True;
end;
DBGrid1.DataSource:=DM.ds_tugasmengajar;
 end;




end;

procedure TF_data_tgsAjar.FormShow(Sender: TObject);
begin
cb_kategori.Text:='Nama Mata Pelajaran';
Edit_key.Clear;
Edit_key.SetFocus;
sLabel3.Caption:='';

SetCueBanner(Edit_key,'Masukkan Kata Pencarian');
end;

procedure TF_data_tgsAjar.tampil;
begin
with DM.q_tugasmengajar do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by tm_kd ) as NO, tugasmengajar.tm_kd,tugasmengajar.mapel_kd ,mapel.mapel_nama,guru.guru_nip,guru.guru_nama,kelas.kelas_kd,mapel.mapel_smt, tugasmengajar.siswa  from kelas,mapel,tugasmengajar, guru'    +
  ' where tugasmengajar.kelas_kd=kelas.kelas_kd and tugasmengajar.guru_nip=guru.guru_nip and tugasmengajar.mapel_kd=mapel.mapel_kd';
  Active:=True;
  DBGrid1.DataSource:=DM.ds_tugasmengajar;
  DM.ds_tugasmengajar.DataSet:=DM.q_tugasmengajar;
end;

end;


procedure TF_data_tgsAjar.btn_hapusClick(Sender: TObject);
begin
if (Application.MessageBox('Yakin Hapus Tugas Mengajar ini ?','KONFIRM',MB_YESNO+MB_ICONQUESTION)=ID_YES) then
begin
  try
    DM.koneksi.BeginTrans;
    with DM.q_tugasmengajar do
    begin
      Connection:=DM.koneksi;
      SQL.Text:='delete from tugasmengajar where tm_kd='+QuotedStr(sLabel3.Caption);
      ExecSQL;
    end;
    DM.koneksi.CommitTrans;
    ShowMessage('Data Tugas Mengajar Terhapus');
  except
  DM.koneksi.RollbackTrans;
  ShowMessage('Data Tugas Mengajar Gagal Terhapus');

  end;
  tampil;
end;
end;

procedure TF_data_tgsAjar.btn_tambahClick(Sender: TObject);
begin
F_input_tgsajar.Show;
F_input_tgsajar.btn_simpan.Enabled:=True;
F_input_tgsajar.btn_edit.Enabled:=False;
F_input_tgsajar.edit_kdtgsajr.Enabled:=False;
//F_input_tgsajar.edit_kdtgsajr.SetFocus;

with DM.ADOQuery1 do
begin
  Close;
  SQL.Clear;
  SQL.Add('select * from tugasmengajar');
  Open;
  if (DM.ADOQuery1.RecordCount<=0) then
  begin
    F_input_tgsajar.edit_kdtgsajr.Text:='TGM001';
  end
  else
  begin
    DM.ADOQuery1.Close;
    DM.ADOQuery1.SQL.Clear;
    DM.ADOQuery1.SQL.Add('select max(right(tm_kd,3))as kode from tugasmengajar');
    DM.ADOQuery1.Open;
    F_input_tgsajar.edit_kdtgsajr.Text:='TGM00'+IntToStr(DM.ADOQuery1['kode']+1);
  end

     end;

end;

end.
