unit U_keteraampilan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sGroupBox, ExtCtrls, sPanel, sLabel, sMemo, sEdit, Buttons,
  sBitBtn;

type
  TF_keterampilan = class(TForm)
    sPanel1: TsPanel;
    sGroupBox1: TsGroupBox;
    edit_jenis: TsEdit;
    edit_kepribadian: TsMemo;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    btn_simpan: TsBitBtn;
    btn_edit: TsBitBtn;
    btn_hapus: TsBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_keterampilan: TF_keterampilan;

implementation

{$R *.dfm}

end.
