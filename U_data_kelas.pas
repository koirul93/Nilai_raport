unit U_data_kelas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sEdit, Buttons, sBitBtn, Grids, DBGrids, sComboBox,
  sGroupBox, sLabel;

type
  TF_data_kelas = class(TForm)
    sGroupBox1: TsGroupBox;
    sLabel3: TsLabel;
    DBGrid1: TDBGrid;
    sGroupBox2: TsGroupBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    cb_kategori: TsComboBox;
    Edit_key: TsEdit;
    sGroupBox3: TsGroupBox;
    btn_ubah: TsBitBtn;
    btn_tambah: TsBitBtn;
    btn_hapus: TsBitBtn;
    procedure Edit_keyChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure btn_tambahClick(Sender: TObject);
    procedure btn_ubahClick(Sender: TObject);
    procedure btn_hapusClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure tampil;
    procedure hapus;
  end;

var
  F_data_kelas: TF_data_kelas;

implementation

uses U_DM, U_input_kelas;

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



 procedure TF_data_kelas.btn_hapusClick(Sender: TObject);
begin
if (Application.MessageBox('Yakin Hapus Data Kelas ini ?','KONFIRM',MB_YESNO+MB_ICONQUESTION)=ID_YES) then

hapus;
tampil;
end;

procedure TF_data_kelas.btn_tambahClick(Sender: TObject);
begin
F_input_kelas.Show;
F_input_kelas.btn_edit.Enabled:=False;
F_input_kelas.btn_simpan.Enabled:=True;
F_input_kelas.edit_kd.Enabled:=True;
F_input_kelas.edit_kd.SetFocus;
F_input_kelas.edit_kd.Enabled:=False;
with DM.ADOQuery1 do
begin
  Close;
  SQL.Clear;
  SQL.Add('select * from kelas');
  Open;
  if (DM.ADOQuery1.RecordCount<=0) then
  begin
    F_input_kelas.edit_kd.Text:='KLS001';
  end
  else
  begin
    DM.ADOQuery1.Close;
    DM.ADOQuery1.SQL.Clear;
    DM.ADOQuery1.SQL.Add('select max(right(kelas_kd,3))as kode from kelas');
    DM.ADOQuery1.Open;
    F_input_kelas.edit_kd.Text:='KLS00'+IntToStr(DM.ADOQuery1['kode']+1);


  end
end;

end;
procedure TF_data_kelas.hapus;
begin
try
 DM.koneksi.BeginTrans;
 with DM.q_kelas do
 begin
   Connection:=DM.koneksi;
   SQL.Text:='delete from kelas where kelas_kd='+QuotedStr(sLabel3.Caption);
   ExecSQL;

 end;
 DM.koneksi.CommitTrans;
 ShowMessage('Data Kelas Terhapus');
except
DM.koneksi.RollbackTrans;
ShowMessage('Data Kelas Gagal Terhapus');



end;
end;
procedure TF_data_kelas.btn_ubahClick(Sender: TObject);
begin
F_input_kelas.Show;
F_input_kelas.btn_simpan.Enabled:=False;
F_input_kelas.btn_edit.Enabled:=True;
F_input_kelas.edit_kd.Enabled:=False;
F_input_kelas.Edit_nama.SetFocus;

with DM.q_kelas do
begin
  F_input_kelas.edit_kd.Text:=FieldByName('kelas_kd').AsString   ;
  F_input_kelas.Edit_nama.Text:=FieldByName('kelas_nama').AsString;
 // F_input_kelas.edit_ruang.Text:=FieldByName('kelas_ruang').AsString;
  F_input_kelas.cb_wali.Text:=FieldByName('guru_nip').AsString ;
end;
with DM.q_guru do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select * from guru where guru_nip='+QuotedStr(F_input_kelas.cb_wali.Text);
  Active:=True;
  F_input_kelas.sEdit1.Text:=FieldByName('guru_nama').AsString;

end;


end;

procedure TF_data_kelas.DBGrid1CellClick(Column: TColumn);
begin
with DM.q_kelas do
begin
  sLabel3.Caption:=FieldValues['kelas_kd'];
end;
end;

procedure TF_data_kelas.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
if DBGrid1.DataSource.DataSet.RecNo mod 2 =0 then
DBGrid1.Canvas.Brush.Color := clSkyBlue;
DBGrid1.DefaultDrawColumnCell(rect, datacol, column, state);

end;

procedure TF_data_kelas.Edit_keyChange(Sender: TObject);
 var cari:string;
 begin
 if cb_kategori.Text='Nama Guru' then
 cari:='guru_nama'
 else if cb_kategori.Text='Nama Kelas' then
 cari:='kelas_nama'
 else if cb_kategori.Text='Nama Ruang' then
 cari:='kelas_ruang';
 if Edit_key.Text='' then
 begin
   with DM.q_kelas do
   begin
     Active:=False;
     Close;
     SQL.Clear;
     SQL.Text:='select ROW_NUMBER() over (order by kelas_kd ) as NO, kelas.kelas_kd,kelas.kelas_nama,kelas.guru_nip, guru.guru_nama from kelas, guru where kelas.guru_nip=guru.guru_nip';
     Active:=True;
   end;
   DBGrid1.DataSource:=DM.ds_kelas;

 end
 else
 begin
   with DM.q_kelas do
   begin
     Active:=False;
     Close;
     SQL.Clear;
     SQL.Text:='select ROW_NUMBER() over (order by kelas_kd ) as NO, kelas.kelas_kd,kelas.kelas_nama,kelas.guru_nip, guru.guru_nama from kelas, guru where kelas.guru_nip=guru.guru_nip and '+cari+' Like '+QuotedStr(Edit_key.Text+ '%');
     Active:=True;
   end;
   DBGrid1.DataSource:=DM.ds_kelas;
 end;




end;

procedure TF_data_kelas.FormShow(Sender: TObject);
begin
cb_kategori.Text:='Nama Kelas';
Edit_key.Clear;
Edit_key.SetFocus;
sLabel3.Caption:='';

SetCueBanner(Edit_key,'Masukkan Kata Pencarian');
end;

procedure TF_data_kelas.tampil;
 begin
 with DM.q_kelas do
 begin
   Active:=False;
   Close;
   SQL.Clear;
   SQL.Text:='select ROW_NUMBER() over (order by kelas_kd ) as NO, kelas.kelas_kd,kelas.kelas_nama,kelas.guru_nip, guru.guru_nama from kelas, guru where kelas.guru_nip=guru.guru_nip';
   Active:=True;
   DBGrid1.DataSource:=DM.ds_kelas;
   DM.ds_kelas.DataSet:=DM.q_kelas;
 end;

 end;
end.
