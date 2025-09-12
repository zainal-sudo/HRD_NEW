program HRDNEW;

uses
  Forms,
  ufrmMenu in 'ufrmMenu.pas' {frmMenu},
  uModuleConnection in 'bantu\uModuleConnection.pas',
  ufrmCxBrowse in 'ufrmCxBrowse.pas' {frmCxBrowse},
  ufrmBrowseJabatan in 'ufrmBrowseJabatan.pas' {frmBrowseJabatan},
  ufrmJabatan in 'ufrmJabatan.pas' {frmJabatan},
  ufrmBrowseKaryawan in 'ufrmBrowseKaryawan.pas' {frmBrowseKaryawan},
  uReport in 'bantu\uReport.pas',
  ufrmBrowseDepartemen in 'ufrmBrowseDepartemen.pas' {frmBrowseDepartemen},
  ufrmDepartemen in 'ufrmDepartemen.pas' {frmDepartemen},
  ufrmUser in 'ufrmUser.pas' {frmUser},
  Ulib in 'bantu\Ulib.pas',
  UfrmLogin in 'UfrmLogin.pas' {frmLogin},
  ufrmBrowseUnit in 'ufrmBrowseUnit.pas' {frmBrowseUnit},
  ufrmUnit in 'ufrmUnit.pas' {frmUnit},
  uFrmbantuan2 in 'bantu\uFrmbantuan2.pas' {frmBantuan2},
  ufrmKaryawan in 'ufrmKaryawan.pas' {frmKaryawan},
  ufrmBrowseIjin in 'ufrmBrowseIjin.pas' {frmBrowseIjin},
  ufrmIjin in 'ufrmIjin.pas' {frmIjin},
  ufrmLapAbsensi in 'ufrmLapAbsensi.pas',
  ufrmBrowseLembur in 'ufrmBrowseLembur.pas' {frmBrowseLembur},
  ufrmLembur in 'ufrmLembur.pas' {frmLembur},
  uFrmPreviewImage in 'bantu\uFrmPreviewImage.pas' {frmPrevImg},
  ufrmLapRekapAbsensi in 'ufrmLapRekapAbsensi.pas' {frmLapRekapAbsensi};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMenu, frmMenu);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
