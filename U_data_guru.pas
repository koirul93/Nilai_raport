unit U_data_guru;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, sBitBtn, sEdit, sComboBox,
  sGroupBox, sLabel, Menus;

type
  TF_data_guru = class(TForm)
    sGroupBox1: TsGroupBox;
    DBGrid1: TDBGrid;
    sGroupBox2: TsGroupBox;
    cb_kategori: TsComboBox;
    Edit_key: TsEdit;
    sGroupBox3: TsGroupBox;
    btn_ubah: TsBitBtn;
    btn_tambah: TsBitBtn;
    btn_hapus: TsBitBtn;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    procedure btn_tampilClick(Sender: TObject);
    procedure btn_tambahClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Edit_keyChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_ubahClick(Sender: TObject);
    procedure btn_hapusClick(Sender: TObject);
    procedure Hapus1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure tampil;
    procedure hapus;
  end;

var
  F_data_guru: TF_data_guru;

implementation

uses U_DM, U_input_guru;

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


procedure TF_data_guru.tampil;
begin
with DM.q_guru do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select ROW_NUMBER() over (order by guru_nip ) as NO, * from guru';
  Active:=True;
  DBGrid1.DataSource:=DM.ds_guru;
  DM.ds_guru.DataSet:=DM.q_guru;
end;


end;

procedure TF_data_guru.hapus;

begin
try
DM.koneksi.BeginTrans;
with DM.q_guru do
begin
  Connection:=DM.koneksi;
  SQL.Text:='delete from guru where guru_nip='+QuotedStr(sLabel3.Caption);
  ExecSQL;
end;
DM.koneksi.CommitTrans;
ShowMessage('Data Guru Terhapus');
except
DM.koneksi.RollbackTrans;
ShowMessage('Data Guru Gagal terhapus');
end;

end;
procedure TF_data_guru.Hapus1Click(Sender: TObject);
begin
 if (Application.MessageBox('Yakin Hapus Data Guru ini ?','KONFIRM',MB_YESNO+MB_ICONQUESTION)=ID_YES) then


hapus;
  tampil;
end;

procedure TF_data_guru.btn_hapusClick(Sender: TObject);
begin
if (Application.MessageBox('Yakin Hapus Data Guru ini ?','KONFIRM',MB_YESNO+MB_ICONQUESTION)=ID_YES) then


hapus;
  tampil;

end;

procedure TF_data_guru.btn_tambahClick(Sender: TObject);
begin
F_input_guru.Show;
F_input_guru.edit_nip.Enabled:=True;
F_input_guru.btn_edit.Enabled:=False;
F_input_guru.btn_simpan.Enabled:=True;
F_input_guru.edit_nip.SetFocus;
end;

procedure TF_data_guru.btn_tampilClick(Sender: TObject);
begin
 with DM.q_guru do
 begin
   Active:=False;
   Close;
   SQL.Clear;
   SQL.Text :='select * from guru';
   Active:=True;
   DBGrid1.DataSource:=DM.ds_guru;
   DM.ds_guru.DataSet:=DM.q_guru;
 end;
end;

procedure TF_data_guru.btn_ubahClick(Sender: TObject);
begin

F_input_guru.Show;
F_input_guru.btn_simpan.Enabled:=False;

F_input_guru.btn_edit.Enabled:=True;
F_input_guru.edit_nama.SetFocus;
with DM.q_guru do
begin
F_input_guru.edit_nip.Text:=FieldByName('guru_nip').AsString ;
F_input_guru.edit_nip.Enabled:=False;
F_input_guru.edit_nama.Text:=FieldByName('guru_nama').AsString;

F_input_guru.jk:=FieldByName('guru_jk').AsString;
if F_input_guru.jk='Laki-laki' then
begin
  F_input_guru.rb_laki.Checked:=True;
  F_input_guru.rb_perempauan.Checked:=False
end
else
begin
  F_input_guru.rb_perempauan.Checked:=True;
  F_input_guru.rb_laki.Checked:=False;
end;
F_input_guru.cb_agama.Text:=FieldByName('guru_agama').AsString ;
F_input_guru.edit_tgl.Text:=FieldByName('guru_tgllahir').AsString;
F_input_guru.edit_alamat.Text:=FieldByName('guru_alamat').AsString;
F_input_guru.cb_status.Text:=FieldByName('guru_sattus').AsString;




end;

end;

procedure TF_data_guru.DBGrid1CellClick(Column: TColumn);
begin
with DM.q_guru do
begin
  sLabel3.Caption:=FieldValues['guru_nip']
end;
end;

procedure TF_data_guru.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
if DBGrid1.DataSource.DataSet.RecNo mod 2 =0 then
DBGrid1.Canvas.Brush.Color := clSkyBlue;
DBGrid1.DefaultDrawColumnCell(rect, datacol, column, state);
end;

procedure TF_data_guru.Edit_keyChange(Sender: TObject);
var cari:string;
begin
if cb_kategori.Text='NIP' then
cari:='guru_nip'
else if cb_kategori.Text='Nama Guru' then
cari:='guru_nama' ;

if Edit_key.Text='' then
begin
  with DM.q_guru do
  begin
    Active:=False;
    Close;
    SQL.Clear;
    SQL.Text:='select ROW_NUMBER() over (order by guru_nip ) as NO, * from guru';
    Active:=True;
  end;
  DBGrid1.DataSource:=DM.ds_guru;
end
else
begin
 with DM.q_guru do
 begin
   Active:=False;
   Close;
   SQL.Clear;
   SQL.Text:='select ROW_NUMBER() over (order by guru_nip ) as NO, * from guru where '+cari+' like ' +QuotedStr(Edit_key.Text+ '%');
   Active:=True;
 end;
 DBGrid1.DataSource:=DM.ds_guru;
end;



end;

procedure TF_data_guru.FormShow(Sender: TObject);
begin
cb_kategori.Text:='Nama Guru' ;
Edit_key.Clear;
Edit_key.SetFocus;
sLabel3.Caption:='';

SetCueBanner(Edit_key,'Masukkan Kata Pencarian');
end;

end.
