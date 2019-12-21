unit U_input_login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, StdCtrls, sGroupBox, sComboBox, Buttons, sBitBtn,
  sEdit, sLabel, sCheckBox;

type
  Tf_input_login = class(TForm)
    sPanel1: TsPanel;
    sGroupBox1: TsGroupBox;
    sLabel1: TsLabel;
    sLabel3: TsLabel;
    edit_username: TsEdit;
    edit_pass: TsEdit;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    edit_langpass: TsEdit;
    sLabel6: TsLabel;
    cb_status: TsComboBox;
    sGroupBox2: TsGroupBox;
    btn_edit: TsBitBtn;
    btn_simpan: TsBitBtn;
    sLabel7: TsLabel;
    edit_kd: TsEdit;
    sCheckBox1: TsCheckBox;
    sLabel8: TsLabel;
    cb_nip: TsComboBox;
    sEdit1: TsEdit;
    sLabel2: TsLabel;
    procedure FormShow(Sender: TObject);
    procedure edit_langpassChange(Sender: TObject);
    procedure sCheckBox1Click(Sender: TObject);
    procedure btn_cariClick(Sender: TObject);
    procedure btn_simpanClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure btn_dataClick(Sender: TObject);
    procedure Btn_kembaliClick(Sender: TObject);
    procedure cb_nipClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure bersih;
    procedure simpanlog;
  end;

var
  f_input_login: Tf_input_login;

implementation

uses U_data_guru, U_DM, U_data_akun;

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


procedure Tf_input_login.bersih;
begin
 edit_kd.Clear;
// edit_kd.SetFocus;
sEdit1.Clear;
sEdit1.Enabled:=False;

edit_username.Clear;
edit_pass.Clear;
edit_langpass.Clear;
cb_status.Text:='--Pilih--';
cb_nip.Text:='--Pilih--';
sLabel8.Caption:='';
SetCueBanner(edit_username,'Masukkan UserName');
SetCueBanner(edit_pass,'************');
SetCueBanner(edit_langpass,'************');

end;
procedure Tf_input_login.simpanlog;
begin
  with DM.q_login do
  begin
    Active:=False;
    SQL.Text:='select * from login';
    Active:=True;
  end;
  try
    DM.koneksi.BeginTrans;
    with DM.q_login do
    begin
      Active:=True;
      Close;
      SQL.Clear;
      SQL.Add('insert into login values ('+QuotedStr(edit_kd.Text)+','+QuotedStr(edit_username.Text)+','+QuotedStr(edit_langpass.Text)+','+QuotedStr(cb_status.Text)+','+QuotedStr(cb_nip.Text)+')');
      ExecSQL;
    end;
    DM.koneksi.CommitTrans;
    ShowMessage('Data Akun Tersimpan');

  except
  DM.koneksi.RollbackTrans;
  ShowMessage('Data Akun Gagal Tersimpan');
  end;


end;

procedure Tf_input_login.btn_cariClick(Sender: TObject);
begin
F_data_guru.Show;
F_data_guru.btn_ubah.Enabled:=False;
F_data_guru.btn_ubah.Enabled:=False;
F_data_guru.btn_hapus.Enabled:=False;
F_data_guru.btn_tambah.Enabled:=False;
end;

procedure Tf_input_login.btn_dataClick(Sender: TObject);
begin
F_data_akun.Show;
end;

procedure Tf_input_login.btn_editClick(Sender: TObject);
begin
 if edit_username.Text='' then
     begin
        Application.MessageBox('UserName Masih Kosong','Warning',MB_OK+MB_ICONWARNING);
        edit_username.SetFocus;
     end
else if edit_pass.Text='' then
          begin
             Application.MessageBox('Password Masih Kosong','Warning',MB_OK+MB_ICONWARNING);
             edit_pass.SetFocus;
          end
else if edit_langpass.Text='' then
     begin
       Application.MessageBox('Ulangi Pasword Masih Kosong','Warning',MB_OK+MB_ICONWARNING);
       edit_langpass.SetFocus;
     end
else if cb_status.Text='--Pilih--' then
     begin
        Application.MessageBox('Satus Login Masih Kosong Suahkan Pilih','Warning',MB_OK+MB_ICONWARNING);
        cb_status.SetFocus;

     end
     else if cb_nip.Text='--Pilih--' then
          begin
            Application.MessageBox('Nip Guru Masih Kosong Silahkan Pilih','Warning',MB_OK+MB_ICONWARNING);
            cb_nip.SetFocus;
          end
else if edit_pass.Text <> edit_langpass.Text then
begin
   Application.MessageBox('Pasword Tidak Cocok','Warning',MB_OK+MB_ICONWARNING);
   edit_langpass.SetFocus;
end
else
begin
with DM.q_login do
begin
  Active:=False;
  SQL.Text:='select * from login';
  Active:=True;
end;
try
DM.koneksi.BeginTrans;
with DM.q_login do
begin
  Active:=True;
  Close;
  SQL.Clear;
  SQL.Text:='update login set login_user='+QuotedStr(edit_username.Text)+',login_pass='+QuotedStr(edit_langpass.Text)+',jabatan='+QuotedStr(cb_status.Text)+',guru_nip='+QuotedStr(cb_nip.Text)+'where login_kd='+QuotedStr(edit_kd.Text);
  ExecSQL;
end;
DM.koneksi.CommitTrans;
ShowMessage('Data Akun Berhasil di Ubah');
except
DM.koneksi.RollbackTrans;
ShowMessage('Data Akun Gagal di Ubah');

end;
  F_data_akun.tampil;
  f_input_login.Close;
end;

end;

procedure Tf_input_login.Btn_kembaliClick(Sender: TObject);
begin
Hide;
end;

procedure Tf_input_login.btn_simpanClick(Sender: TObject);
begin
if edit_kd.Text='' then
begin
Application.MessageBox('Kode Login Masih Kosong','Warning',MB_OK+MB_ICONWARNING);
edit_kd.SetFocus;
end

else if edit_username.Text='' then
     begin
        Application.MessageBox('UserName Masih Kosong','Warning',MB_OK+MB_ICONWARNING);
        edit_username.SetFocus;
     end
else if edit_pass.Text='' then
          begin
             Application.MessageBox('Password Masih Kosong','Warning',MB_OK+MB_ICONWARNING);
             edit_pass.SetFocus;
          end
else if edit_langpass.Text='' then
     begin
       Application.MessageBox('Ulangi Pasword Masih Kosong','Warning',MB_OK+MB_ICONWARNING);
       edit_langpass.SetFocus;
     end
else if cb_status.Text='--Pilih--' then
     begin
        Application.MessageBox('Satus Login Masih Kosong Suahkan Pilih','Warning',MB_OK+MB_ICONWARNING);
        cb_status.SetFocus;

     end
     else if cb_nip.Text='--Pilih--' then
          begin
            Application.MessageBox('Nip Guru Masih Kosong Silahkan Pilih','Warning',MB_OK+MB_ICONWARNING);
            cb_nip.SetFocus;
          end

else if edit_pass.Text <> edit_langpass.Text then
begin
   Application.MessageBox('Pasword Tidak Cocok','Warning',MB_OK+MB_ICONWARNING);
   edit_langpass.SetFocus;
end
else
begin
with DM.q_login do
begin
  Active:=False;
  Close;
  SQL.Clear;
  SQL.Text:='select * from login where login_kd='+QuotedStr(edit_kd.Text);
  Active:=True;
end;
  if DM.q_login.IsEmpty then
  begin
    simpanlog ;
  end
  else
  ShowMessage('Kd Login Sudah di Gunakan');
  F_data_akun.tampil;
  f_input_login.Close;

end;

end;

procedure Tf_input_login.cb_nipClick(Sender: TObject);
begin
DM.q_guru.Active:=False;
DM.q_guru.SQL.Clear;
DM.q_guru.SQL.Add('select guru_nama, guru_nip from guru')  ;
DM.q_guru.SQL.Add('where guru_nip='''+cb_nip.Text+'''');
DM.q_guru.Open;
sEdit1.Text:=DM.q_guru['guru_nama'];
end;

procedure Tf_input_login.edit_langpassChange(Sender: TObject);
begin
 if edit_pass.Text <> edit_langpass.Text then
 begin
   sLabel8.Font.Color:=clRed;
   sLabel8.Caption:='Password Tidak Cocok!!!'
   end
   else
   begin
   sLabel8.Font.Color:=clGreen;
   sLabel8.Caption:='Pasword Cocok.'
   end
end;

procedure Tf_input_login.FormShow(Sender: TObject);
begin
bersih;
begin
DM.q_guru.Active:=False;
DM.q_guru.Close;
 DM.q_guru.SQL.Clear;
 DM.q_guru.SQL.Add('select * from guru') ;
 DM.q_guru.Active:=True;
 cb_nip.Items.Clear;

 while not DM.q_guru.Eof do
 begin
   cb_nip.Items.Add(DM.q_guru.FieldByName('guru_nip').AsString);





   DM.q_guru.Next;

 end;
 end;
end;

procedure Tf_input_login.sCheckBox1Click(Sender: TObject);
begin
if sCheckBox1.Checked then
  begin
   edit_pass.PasswordChar:=#0;
   edit_langpass.PasswordChar:=#0;
  end
 else
  begin
   edit_pass.PasswordChar:='*';
   edit_langpass.PasswordChar:='*';
  end
end;

end.
