unit ufrmLapAbsensi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmCxBrowse, Menus, cxLookAndFeelPainters, cxStyles,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkSide,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinValentine, dxSkinXmas2008Blue,
  dxSkinscxPCPainter, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, FMTBcd, Provider, SqlExpr, ImgList,
  ComCtrls, StdCtrls, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  cxButtons, ExtCtrls, AdvPanel, DBClient, cxLookAndFeels,
  dxSkinsDefaultPainters, dxSkinDarkRoom, dxSkinFoggy, dxSkinSeven,
  dxSkinSharp;

type
  TfrmLapAbsensi = class(TfrmCxBrowse)
    PopupMenu1: TPopupMenu;
    ransaksiIjin1: TMenuItem;
    EditAbsensi1: TMenuItem;
    CheckBox1: TCheckBox;
    cxButton5: TcxButton;
    cxButton9: TcxButton;
    cxButton10: TcxButton;
  procedure btnRefreshClick(Sender: TObject);
  procedure FormShow(Sender: TObject);
  procedure cxButton6Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure cxButton9Click(Sender: TObject);
    procedure cxButton10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLapAbsensi: TfrmLapAbsensi;

implementation
   uses ufrmMenu, uModuleConnection, uLib, uFrmPreviewImage;
{$R *.dfm}

procedure TfrmLapAbsensi.btnRefreshClick(Sender: TObject);
var
  asakit :string;
  aijin: string;
  aalpha:string;
  asetengahhari:string;
begin
    {Self.SQLMaster := ' WITH RECURSIVE dates AS ('
                    + '     SELECT DATE('+quotd(startdate.datetime)+') AS dt '
                    + '     UNION ALL'
                    + '     SELECT DATE_ADD(dt, INTERVAL 1 DAY)'
                    + '     FROM dates'
                    + '     WHERE dt < '+quotd(enddate.datetime)
                    + ' )'
                    + ' SELECT'
                    + '     d.dt AS Tanggal,DAYNAME(d.dt) AS Hari,'
                    + '     emp.kar_nik Nik,kar_nama Nama,nm_jabat Jabatan,nm_unit Nama_Unit,'
                    + '     MIN(CASE WHEN e.status_absen = 1 THEN TIME(e.tanggal) END) AS Jam_in,'
                    + '     MAX(CASE WHEN e.status_absen in (1,2) THEN TIME(e.tanggal) END) AS Jam_out'
                    + ' FROM dates d'
                    + ' CROSS JOIN (SELECT DISTINCT kar_nik FROM tabsensitampung WHERE kar_nik <> ""  ) emp'
                    + ' LEFT JOIN tabsensitampung e'
                    + '     ON DATE(e.tanggal) = d.dt'
                    + '     AND e.kar_nik = emp.kar_nik'
                    + ' LEFT JOIN tkaryawan x ON x.kar_Nik=emp.kar_nik AND kar_pengecualian=0'
                    + ' LEFT JOIN tjabatan y ON x.kar_kd_jabat=y.kd_jabat '
                    + ' LEFT JOIN tunit z ON z.kd_unit=x.kar_kd_unit '
                    + ' where kar_status_aktif=1 AND x.kar_kd_unit LIKE ' + quot(frmMenu.KDUNIT)
                    + ' GROUP BY emp.kar_nik, d.dt'
                    + ' ORDER BY emp.kar_nik, d.dt';}
    Self.SQLMaster := ' WITH RECURSIVE dates AS (   '
                    + '     SELECT DATE(' + quotd(startdate.datetime) + ') AS dt '
                    + '     UNION ALL '
                    + '     SELECT DATE_ADD(dt, INTERVAL 1 DAY) '
                    + '     FROM dates '
                    + '     WHERE dt < ' + quotd(enddate.datetime)
                    + ' ), '
                    + ' base_absen AS ( '
                    + '     SELECT  '
                    + '         d.dt, emp.kar_nik, '
                    + '         MIN(CASE WHEN e.status_absen = 1 THEN TIME(e.tanggal) END) AS jam_in, '
                    + '         MAX(CASE WHEN e.status_absen IN (1,2) THEN TIME(e.tanggal) END) AS jam_out '
                    + '     FROM dates d '
                    + '     CROSS JOIN (SELECT DISTINCT kar_nik FROM tabsensitampung WHERE kar_nik <> "") emp '
                    + '     LEFT JOIN tabsensitampung e ON DATE(e.tanggal) = d.dt AND e.kar_nik = emp.kar_nik '
                    + '     GROUP BY d.dt, emp.kar_nik '
                    + ' ), '
                    + ' status_dasar AS ( '
                    + '     SELECT b.dt, b.kar_nik, b.jam_in, b.jam_out, x.kar_nama, y.nm_jabat, z.nm_unit, z.jam_kerja, l.hl_tanggal, '
                    + '         CASE  '
                    + '             WHEN z.jam_kerja = "shift full" THEN '
                    + '                 CASE  '
                    + '                     WHEN b.jam_in IS NULL AND b.jam_out IS NULL THEN "Potong Gaji" '
                    + '                     ELSE "Masuk" '
                    + '                 END '
                    + '             WHEN z.jam_kerja = "shift libur" THEN '
                    + '                 CASE  '
                    + '                     WHEN l.hl_tanggal IS NOT NULL OR DAYNAME(b.dt) IN ("Saturday","Sunday") THEN "" '
                    + '                     WHEN b.jam_in IS NULL AND b.jam_out IS NULL THEN "Potong Gaji" '
                    + '                     ELSE "Masuk" '
                    + '                 END '
                    + '             ELSE '
                    + '                 CASE  '
                    + '                     WHEN l.hl_tanggal IS NOT NULL THEN "" '
                    + '                     WHEN b.jam_in IS NULL AND b.jam_out IS NULL THEN "Potong Gaji" '
                    + '                     WHEN b.jam_in >= "08:01:00" THEN "Terlambat" '
                    + '                     ELSE "Masuk" '
                    + '                 END '
                    + '         END AS keterangan '
                    + '     FROM base_absen b '
                    + '     LEFT JOIN tkaryawan x ON x.kar_nik = b.kar_nik AND x.kar_pengecualian = 0 AND x.kar_status_aktif = 1 '
                    + '     LEFT JOIN tjabatan y ON x.kar_kd_jabat = y.kd_jabat  '
                    + '     LEFT JOIN tunit z ON z.kd_unit = x.kar_kd_unit  '
                    + '     LEFT JOIN tharilibur l ON l.hl_tanggal = b.dt '
                    + '     WHERE x.kar_kd_unit LIKE ' + quot(frmMenu.KDUNIT)
                    + ' ) '
                    + ' SELECT '
                    + '     s.dt AS Tanggal, DAYNAME(s.dt) AS Hari, s.kar_nik AS Nik, s.kar_nama AS Nama, s.nm_jabat AS Jabatan, s.nm_unit AS Nama_Unit, '
                    + '     s.jam_in AS Jam_in, s.jam_out AS Jam_out, s.keterangan AS Keterangan, COALESCE(i.alasan, s.keterangan) AS Payroll, i.ij_nomor AS NoIjin, '
                    + '     i.ij_foto AS foto '
                    + ' FROM status_dasar s '
                    + ' LEFT JOIN tijin i ON i.kar_nik = s.kar_nik AND DATE(i.tanggal) = s.dt '
                   + ' ORDER BY s.kar_nik, s.dt';


    inherited;
    cxGrdMaster.ApplyBestFit();
    cxGrdMaster.Columns[0].Width := 100;
    cxGrdMaster.Columns[1].Width := 200;
    cxGrdMaster.Columns[6].Width := 100;
    cxGrdMaster.Columns[7].Width := 100;
    cxGrdMaster.Columns[8].Width := 100;
    cxGrdMaster.Columns[9].Width := 100;
    cxGrdMaster.Columns[10].Width := 100;
    cxGrdMaster.Columns[11].Visible := False;
//    CDSMaster.FieldByName('Keterangan').Size := 200;
    CDSMaster.First;


end;

procedure TfrmLapAbsensi.FormShow(Sender: TObject);
begin
    ShowWindowAsync(Handle, SW_MAXIMIZE);
  inherited;
  btnRefreshClick(Self);
 end;

procedure TfrmLapAbsensi.cxButton6Click(Sender: TObject);
begin
  inherited;
  refreshdata;
end;

procedure TfrmLapAbsensi.cxButton5Click(Sender: TObject);
var
  s: string;
begin
  if ( not cekinsert(frmMenu.KDUSER,self.name)) then
  begin
    MessageDlg('Anda tidak berhak Insert di Modul ini',mtWarning, [mbOK],0);;
    Exit;
  End;
  
  inherited;

  Screen.Cursor := crSQLWait;
  cxButton5.Enabled := False;
  try
    EnsureConnected(frmMenu.MyConnection1);

    s := ' DELETE h ' +
         ' FROM tabsensitampung h ' +
         ' INNER JOIN tkaryawan k ON h.kar_nik = k.kar_nik ' +
         ' WHERE k.kar_kd_unit = 19 ' +
         ' AND DATE(h.tanggal) BETWEEN ' + QuotD(startdate.Date) +
         ' AND ' + QuotD(enddate.Date) + '; ' +
         ' INSERT IGNORE INTO hrd.tabsensitampung (kar_nik, tanggal, status_absen) ' +
         ' SELECT b.kar_nik, a.tanggal, a.status_absen ' +
         ' FROM hrd_roti.tabsensitampung a ' +
         ' INNER JOIN hrd_roti.tkaryawan b ON b.id_kar = a.id_kar ' +
         ' WHERE DATE(a.tanggal) BETWEEN ' + QuotD(startdate.Date) +
         ' AND ' + QuotD(enddate.Date) + ';';

    ExecSQLDirect(frmMenu.MyConnection1, s);
    Application.ProcessMessages;

    MessageDlg('Proses selesai!', mtInformation, [mbOK], 0);
  finally
    Screen.Cursor := crDefault;
    cxButton5.Enabled := True;
  end;
end;

procedure TfrmLapAbsensi.cxButton9Click(Sender: TObject);
var
  s: string;
begin
  if ( not cekinsert(frmMenu.KDUSER,self.name)) then
  begin
    MessageDlg('Anda tidak berhak Insert di Modul ini',mtWarning, [mbOK],0);;
    Exit;
  End;
  
  inherited;

  Screen.Cursor := crSQLWait;
  cxButton9.Enabled := False;
  try
    EnsureConnected(frmMenu.MyConnection1);

    s := ' DELETE h ' +
         ' FROM tabsensitampung h ' +
         ' INNER JOIN tkaryawan k ON h.kar_nik = k.kar_nik ' +
         ' WHERE k.kar_kd_unit = 20 ' +
         ' AND DATE(h.tanggal) BETWEEN ' + QuotD(startdate.Date) +
         ' AND ' + QuotD(enddate.Date) + '; ' +
         ' INSERT INTO hrd.tabsensitampung (kar_nik, tanggal, status_absen) ' +
         ' SELECT b.kar_nik, a.tanggal, a.status_absen ' +
         ' FROM hrd_entri.tabsensitampung a ' +
         ' INNER JOIN hrd_entri.tkaryawan b ON b.id_kar = a.id_kar ' +
         ' WHERE DATE(a.tanggal) BETWEEN ' + QuotD(startdate.Date) +
         ' AND ' + QuotD(enddate.Date) + ';';

    ExecSQLDirect(frmMenu.MyConnection1, s);
    Application.ProcessMessages;

    MessageDlg('Proses selesai!', mtInformation, [mbOK], 0);
  finally
    Screen.Cursor := crDefault;
    cxButton9.Enabled := True;
  end;
end;

procedure TfrmLapAbsensi.cxButton10Click(Sender: TObject);
begin
  inherited;
  If (CDSMaster.FieldByname('foto').IsNull) OR (CDSMaster.FieldByname('foto').AsString = '') then exit;
  
  Application.CreateForm(TfrmPrevImg, frmprevimg);
  frmprevimg.foto := CDSMaster.FieldByname('foto').AsString;
  frmprevimg.ShowModal;
end;

end.
