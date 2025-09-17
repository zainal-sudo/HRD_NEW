unit ufrmBrowseIjin;

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
  TfrmBrowseIjin = class(TfrmCxBrowse)
    cxButton5: TcxButton;
    cxButton9: TcxButton;
  procedure btnRefreshClick(Sender: TObject);
  procedure FormShow(Sender: TObject);
  procedure cxButton2Click(Sender: TObject);
  procedure cxButton1Click(Sender: TObject);
  procedure cxButton6Click(Sender: TObject);
  procedure cxButton4Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure cxButton9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBrowseIjin: TfrmBrowseIjin;

implementation
   uses ufrmIjin, ufrmIjin2, uModuleConnection, ufrmMenu, uFrmPreviewImage;
{$R *.dfm}

procedure TfrmBrowseIjin.btnRefreshClick(Sender: TObject);
begin
  Self.SQLMaster := 'SELECT a.ij_nomor Nomor, a.kar_nik NIK, b.kar_nama Nama, c.nm_jabat Jabatan, d.nm_dept Departmen, e.nm_unit Unit, '
                    + ' tanggal Tanggal, alasan Alasan, keterangan Keterangan, a.ij_foto foto '
                    + ' FROM tijin a '
                    + ' LEFT JOIN tkaryawan b ON a.kar_nik = b.kar_nik '
                    + ' LEFT JOIN tjabatan c ON c.kd_jabat = b.kar_kd_jabat '
                    + ' LEFT JOIN tdept d ON d.kd_dept = b.kar_kd_dept '
                    + ' LEFT JOIN tunit e ON e.kd_unit = b.kar_kd_unit '
                    + ' WHERE b.kar_kd_unit LIKE ' + Quot(frmMenu.KDUNIT)
                    + ' AND a.tanggal between ' + QuotD(startdate.DateTime) + ' and ' + QuotD(enddate.DateTime);
  inherited;
  cxGrdMaster.ApplyBestFit();
  cxGrdMaster.Columns[0].Width :=100;
  cxGrdMaster.Columns[1].Width :=150;
  cxGrdMaster.Columns[2].Width :=200;
  cxGrdMaster.Columns[3].Width :=200;
  cxGrdMaster.Columns[4].Width :=100;
  cxGrdMaster.Columns[5].Width :=200;
  cxGrdMaster.Columns[6].Width :=100;
  cxGrdMaster.Columns[7].Width :=100;
  cxGrdMaster.Columns[8].Width :=200;
  cxGrdMaster.Columns[9].Visible := False;
end;

procedure TfrmBrowseIjin.FormShow(Sender: TObject);
begin
  ShowWindowAsync(Handle, SW_MAXIMIZE);
  inherited;
  btnRefreshClick(Self);
end;

procedure TfrmBrowseIjin.cxButton2Click(Sender: TObject);
var
  frmijin: TfrmIjin;
begin
  inherited;
  if ActiveMDIChild.Caption <> 'Ijin' then
  begin
    frmijin  := frmmenu.ShowForm(TfrmIjin) as TfrmIjin;
    frmijin.edtNIK.SetFocus;
  end;

  frmijin.Show;
end;

procedure TfrmBrowseIjin.cxButton1Click(Sender: TObject);
var
  frmijin: TfrmIjin;
begin
  inherited;
  If CDSMaster.FieldByname('Nomor').IsNull then exit;
  
  if ActiveMDIChild.Caption <> 'Ijin' then
  begin
    // ShowForm(TfrmBrowseBarang).Show;
    frmijin  := frmmenu.ShowForm(TfrmIjin) as TfrmIjin;
    frmijin.ID := CDSMaster.FieldByname('Nomor').AsString;
    frmijin.FLAGEDIT := True;
    frmijin.edtNomor.Text := CDSMaster.FieldByname('Nomor').AsString;
    frmijin.loaddata(CDSMaster.FieldByname('Nomor').AsString);
  end;
  
  frmijin.Show;
end;

procedure TfrmBrowseIjin.cxButton6Click(Sender: TObject);
begin
  inherited;
  refreshdata;
end;

procedure TfrmBrowseIjin.cxButton4Click(Sender: TObject);
var
  s:string;
begin
  inherited;
  try
    if not cekdelete(frmMenu.KDUSER,'frmijin') then
    begin
      MessageDlg('Anda tidak berhak Menghapus di Modul ini',mtWarning, [mbOK],0);
      Exit;
    End;
  
    if MessageDlg('Yakin ingin hapus ?',mtCustom,
                            [mbYes,mbNo], 0)= mrNo
    then Exit ;
    
    s:='delete from tijin '
    + ' where ij_nomor = ' + quot(CDSMaster.FieldByname('Nomor').AsString) + ';' ;

    EnsureConnected(frmMenu.MyConnection1);
    ExecSQLDirect(frmMenu.MyConnection1,s);

    CDSMaster.Delete;
  except
    MessageDlg('Gagal Hapus',mtError, [mbOK],0);
    Exit;
  end;

end;

procedure TfrmBrowseIjin.cxButton5Click(Sender: TObject);
begin
  inherited;
  If (CDSMaster.FieldByname('foto').IsNull) OR (CDSMaster.FieldByname('foto').AsString = '') then exit;
  
  Application.CreateForm(TfrmPrevImg, frmprevimg);
  frmprevimg.foto := CDSMaster.FieldByname('foto').AsString;
  frmprevimg.ShowModal;
end;

procedure TfrmBrowseIjin.cxButton9Click(Sender: TObject);
var
  frmijin2: TfrmIjin2;
begin
  inherited;
  if ActiveMDIChild.Caption <> 'Ijin' then
  begin
    frmijin2  := frmmenu.ShowForm(TfrmIjin2) as TfrmIjin2;
    frmijin2.edtNIK.SetFocus;
  end;

  frmijin2.Show;
end;

end.



