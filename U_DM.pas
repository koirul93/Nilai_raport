unit U_DM;

interface

uses
  SysUtils, Classes, DB, ADODB, DBTables;

type
  TDM = class(TDataModule)
    koneksi: TADOConnection;
    q_kelas: TADOQuery;
    q_siswa: TADOQuery;
    q_guru: TADOQuery;
    q_akademis: TADOQuery;
    q_login: TADOQuery;
    q_mapel: TADOQuery;
    q_nilai: TADOQuery;
    ds_akadeis: TDataSource;
    ds_tugasmengajar: TDataSource;
    ds_kepribadian: TDataSource;
    ds_login: TDataSource;
    ds_nilai: TDataSource;
    ds_guru: TDataSource;
    ds_mapel: TDataSource;
    ds_kelas: TDataSource;
    q_tugasmengajar: TADOQuery;
    ds_siswa: TDataSource;
    q_kepribadian: TADOQuery;
    ADOQuery1: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

end.
