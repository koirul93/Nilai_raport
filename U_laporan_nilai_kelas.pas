unit U_laporan_nilai_kelas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QRCtrls, jpeg, QuickRpt, ExtCtrls, qrpctrls;

type
  TF_Laporan_nilai_kelas = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRImage1: TQRImage;
    QRLabel1: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabelKELAS: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabelNIP: TQRLabel;
    QRLabel12: TQRLabel;
    QRLlabelNAMA: TQRLabel;
    QRBand2: TQRBand;
    QRShape1: TQRShape;
    QRLabel9: TQRLabel;
    QRBand3: TQRBand;
    QRShape2: TQRShape;
    QRDBnama: TQRDBText;
    QRSysData1: TQRSysData;
    QRBand4: TQRBand;
    QRLabel5: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRLabel17: TQRLabel;
    QRLabel18: TQRLabel;
    QRDBNIS: TQRDBText;
    QRDBMAPEL: TQRDBText;
    QRDBULANGAN: TQRDBText;
    QRDBTUGAS: TQRDBText;
    QRDBUTS: TQRDBText;
    QRDBUAS: TQRDBText;
    QRDBTOTAL: TQRDBText;
    QRDBKET: TQRDBText;
    QRSysData2: TQRSysData;
    QRLabel8: TQRLabel;
    QRLabel19: TQRLabel;
    QRLabel20: TQRLabel;
    QRLabel21: TQRLabel;
    QRPLabel1: TQRPLabel;
    QRPLabel2: TQRPLabel;
    QRPLabelnipt: TQRPLabel;
    QRPLabelnamawlait: TQRPLabel;
    QRLTahun: TQRLabel;
    QRLabel22: TQRLabel;
    qrlsmt: TQRLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Laporan_nilai_kelas: TF_Laporan_nilai_kelas;

implementation

uses U_DM;

{$R *.dfm}

end.
