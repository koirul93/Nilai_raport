unit U_laporan_akademis_k;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, qrpctrls, QRCtrls, jpeg, QuickRpt, ExtCtrls;

type
  TF_laporan_akademis_k = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRImage1: TQRImage;
    QRLabel1: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabelNIP: TQRLabel;
    QRLabel12: TQRLabel;
    QRLlabelNAMA: TQRLabel;
    QRLKELAS: TQRLabel;
    QRBand2: TQRBand;
    QRShape1: TQRShape;
    QRLabel9: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel18: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel15: TQRLabel;
    QRBand3: TQRBand;
    QRShape2: TQRShape;
    QRSysData1: TQRSysData;
    QRDBNIS: TQRDBText;
    QRDBNAMA: TQRDBText;
    QRDBTEMPAT: TQRDBText;
    QRDBTGLLHR: TQRDBText;
    QRDBALAMAT: TQRDBText;
    QRBand4: TQRBand;
    QRSysData2: TQRSysData;
    QRLabel8: TQRLabel;
    QRLabel19: TQRLabel;
    QRLabel20: TQRLabel;
    QRLabel21: TQRLabel;
    QRPLabelnipt: TQRPLabel;
    QRPLabel2: TQRPLabel;
    QRPLabelnamawlait: TQRPLabel;
    QRPLabel1: TQRPLabel;
    QRLabel22: TQRLabel;
    QRLTahun: TQRLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_laporan_akademis_k: TF_laporan_akademis_k;

implementation

{$R *.dfm}

end.
