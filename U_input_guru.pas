unit U_input_guru;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sEdit, sLabel, sMemo, sRadioButton, sComboBox, Mask,
  sMaskEdit, sCustomComboEdit, sTooledit, Buttons, sBitBtn, ExtCtrls, sPanel,
  sGroupBox;

type
  TF_input_guru = class(TForm)
    sLabel1: TsLabel;
    edit_nip: TsEdit;
    sLabel2: TsLabel;
    edit_nama: TsEdit;
    sLabel3: TsLabel;
    edit_tgl: TsDateEdit;
    sLabel4: TsLabel;
    cb_status: TsComboBox;
    sLabel5: TsLabel;
    sLabel6: TsLabel;
    cb_agama: TsComboBox;
    sLabel7: TsLabel;
    btn_simpan: TsBitBtn;
    btn_edit: TsBitBtn;
    sGroupBox1: TsGroupBox;
    sPanel1: TsPanel;
    sGroupBox2: TsGroupBox;
    sRadioGroup1: TsRadioGroup;
    rb_laki: TsRadioButton;
    rb_perempauan: TsRadioButton;
    edit_alamat: TsMemo;
    procedure FormShow(Sender: TObject);
    procedure btn_simpanClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure Btn_kembaliClick(Sender: TObject);
    procedure edit_nipKeyPress(Sender: TObject; var Key: Char);
    procedure edit_namaKeyPress(Sender: TObject; var Key: Char);
    procedure edit_alamatExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure bersih;
    procedure simpanGuru;
    var jk :string;
  end;

var
  F_input_guru: TF_input_guru;

implementation

uses U_DM, U_data_guru;

{$R *.dfm}
 function SetCueBanner(const Edit: TEdit;  const Placeholder: String ): Boolean;
const
  EM_SETCUEBANNER = $1501;
var
  UniStr: WideString;
begin
  UniStr := Placeholder;
  SendMessage(Edit.Handle, EM_SETCUEBANNER, WParam(True),LParam(UniStr));
  Result := GetLastError() = ERROR_SUCCESS;
end;

procedure TF_input_guru.bersih;
begin
 edit_nip.Clear;
 edit_nama.Clear;
 edit_alamat.Clear;

 edit_tgl.Date:=Now;
 cb_status.Text:='--Pilih--';
 cb_agama.Text:='--Pilih--';
 SetCueBanner(edit_nip,'Masukkan NIP Guru');
 SetCueBanner(edit_nama,'Masukkan Nama Guru');
 //SetCueBanner(edit_alamat,'Masukkan Alamat Guru');
end;
procedure TF_input_guru.simpanGuru;

begin
  with DM.q_guru do
  begin
    Active:=False;
    SQL.Text:='select * from guru';
    Active:=True;
  end;
  try
  DM.koneksi.BeginTrans;
  with DM.q_guru do
  begin
    Active:=True;
    Close;
    SQL.Clear;
    SQL.Add('insert into guru values('+QuotedStr(edit_nip.Text)+','+QuotedStr(edit_nama.Text)+','+QuotedStr(jk)+','+QuotedStr(FormatDateTime('yyyy/mm/dd',edit_tgl.Date))+','+QuotedStr(cb_agama.Text)+','+QuotedStr(edit_alamat.Text)+','+QuotedStr(cb_status.Text)+')');
    ExecSQL;
  end;
  DM.koneksi.CommitTrans;
  ShowMessage('Data Guru Tersimpan');


  except
  DM.koneksi.RollbackTrans;
  ShowMessage('Data Guru Gagal di Simpan');
  end;





end;

procedure TF_input_guru.btn_editClick(Sender: TObject);
begin
if (rb_laki.Checked=True) then
jk:='Laki-laki'
else if (rb_perempauan.Checked=True) then
     jk:='Perempuan' ;



if  edit_nip.Text='' then
begin
Application.MessageBox('Data Nip Guru Masih Kosong','Warning',+MB_OK+MB_ICONWARNING);
edit_nip.SetFocus;
end
else if edit_nama.Text='' then
     begin
        Application.MessageBox('Data Nama Guru Masih Kosong','Waning',+MB_OK+MB_ICONWARNING);
        edit_nama.SetFocus;
     end
     else if cb_status.Text='--Pilih--' then
          begin
             Application.MessageBox('Pilih Dahulu Status Guru','Warning',+MB_OK+MB_ICONWARNING);
             cb_status.SetFocus;
          end
          else if cb_agama.Text='--Pilih--' then
          begin
              Application.MessageBox('Plih Dahulu Agama Guru','Warning',+MB_OK+MB_ICONWARNING);
          cb_agama.SetFocus;
          end
          else if edit_alamat.Text='' then
               begin
                  Application.MessageBox('Data Alamat masih Kosong','Warning',+MB_OK+MB_ICONWARNING);
                  edit_alamat.SetFocus;
               end

else
begin
  with DM.q_guru do
  begin
    Active:=False;
    SQL.Text:='select * from guru';
    Active:=True;
  end;
  try
  DM.koneksi.BeginTrans;
  with DM.q_guru do
  begin
    Active:=True;
    Close;
    SQL.Clear;
    SQL.Text:='update guru set guru_nama='+QuotedStr(edit_nama.Text)+',guru_jk='+QuotedStr(jk)+',guru_tgllahir='+QuotedStr(FormatDateTime('yyyy/mm/dd',edit_tgl.Date))+',guru_agama='+QuotedStr(cb_agama.Text)+',guru_alamat='+QuotedStr(edit_alamat.Text)+',guru_sattus='+QuotedStr(cb_status.Text)+'where guru_nip='+QuotedStr(edit_nip.Text);
    ExecSQL;
  end;
  DM.koneksi.CommitTrans;
  ShowMessage('Data Guru di Ruban');
  except
  DM.koneksi.RollbackTrans;
  ShowMessage('Data Guru Gagal di Rubah');
  Close;
  end;
  F_data_guru.tampil;
  F_input_guru.Close;
  end;
end;

procedure TF_input_guru.Btn_kembaliClick(Sender: TObject);
begin
Hide;
end;

procedure TF_input_guru.btn_simpanClick(Sender: TObject);
begin
if (rb_laki.Checked=True) then
jk:='Laki-laki'
else if (rb_perempauan.Checked=True) then
     jk:='Perempuan' ;

if  edit_nip.Text='' then
begin
Application.MessageBox('Data Nip Guru Masih Kosong','Warning',+MB_OK+MB_ICONWARNING);
edit_nip.SetFocus;
end
else if edit_nama.Text='' then
     begin
        Application.MessageBox('Data Nama Guru Masih Kosong','Waning',+MB_OK+MB_ICONWARNING);
        edit_nama.SetFocus;
     end
     else if cb_status.Text='--Pilih--' then
          begin
             Application.MessageBox('Pilih Dahulu Status Guru','Warning',+MB_OK+MB_ICONWARNING);
             cb_status.SetFocus;
          end
          else if cb_agama.Text='--Pilih--' then
          begin
              Application.MessageBox('Plih Dahulu Agama Guru','Warning',+MB_OK+MB_ICONWARNING);
          cb_agama.SetFocus;
          end
          else if edit_alamat.Text='' then
               begin
                  Application.MessageBox('Data Alamat masih Kosong','Warning',+MB_OK+MB_ICONWARNING);
                  edit_alamat.SetFocus;
               end


else
begin
  with DM.q_guru do
  begin
    Active:=False;
    Close;
    SQL.Clear;
    SQL.Text:='select * from guru where guru_nip='+QuotedStr(edit_nip.Text);
    Active:=True;
  end;
  if DM.q_guru.IsEmpty then
   begin
      simpanGuru;
   end
   else
   ShowMessage('Nip Guru Sudah di Gunakan');

  F_data_guru.tampil;
F_input_guru.Close;

end;



end;

procedure TF_input_guru.edit_alamatExit(Sender: TObject);
begin
//edit_alamat.Text:='Masukkan Alamat';
end;

procedure TF_input_guru.edit_namaKeyPress(Sender: TObject; var Key: Char);
begin
if not (key in['a'..'z','A'..'Z',#8,#13,#32]) then
begin
  Key:=#0;
  ShowMessage('Inputan Nama Guru Hanya Huruf');
end;

end;

procedure TF_input_guru.edit_nipKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key in['0'..'9']) then
begin
  Key:=#0;
  ShowMessage('Inputan NIP Hanya Angka');

end;
end;

procedure TF_input_guru.FormShow(Sender: TObject);
begin
bersih;
end;

end.
