unit ufrmBrowseJabatan;

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
  TfrmBrowseJabatan = class(TfrmCxBrowse)
  procedure btnRefreshClick(Sender: TObject);
  procedure FormShow(Sender: TObject);
  procedure cxButton2Click(Sender: TObject);
  procedure cxButton1Click(Sender: TObject);
  procedure cxButton6Click(Sender: TObject);
  procedure cxButton4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBrowseJabatan: TfrmBrowseJabatan;

implementation
   uses ufrmjabatan,uModuleConnection, ufrmMenu;
{$R *.dfm}

procedure TfrmBrowseJabatan.btnRefreshClick(Sender: TObject);
begin
  Self.SQLMaster := 'select kd_jabat Kode, nm_jabat Nama from tjabatan';
  inherited;
  cxGrdMaster.ApplyBestFit();
  cxGrdMaster.Columns[0].Width :=100;
  cxGrdMaster.Columns[1].Width :=200;
end;

procedure TfrmBrowseJabatan.FormShow(Sender: TObject);
begin
  ShowWindowAsync(Handle, SW_MAXIMIZE);
  inherited;
  btnRefreshClick(Self);
end;

procedure TfrmBrowseJabatan.cxButton2Click(Sender: TObject);
var
  frmjabatan: Tfrmjabatan;
begin
  inherited;
  if ActiveMDIChild.Caption <> 'Master Jabatan' then
  begin
    frmjabatan  := frmmenu.ShowForm(Tfrmjabatan) as Tfrmjabatan;
    frmjabatan.edtKode.SetFocus;
  end;
  frmjabatan.Show;
end;

procedure TfrmBrowseJabatan.cxButton1Click(Sender: TObject);
var
  frmjabatan: Tfrmjabatan;
begin
  inherited;
  If CDSMaster.FieldByname('KODE').IsNull then exit;
  if ActiveMDIChild.Caption <> 'Master jabatan' then
  begin
    //ShowForm(TfrmBrowseBarang).Show;
    frmjabatan  := frmmenu.ShowForm(Tfrmjabatan) as Tfrmjabatan;
    frmjabatan.ID := CDSMaster.FieldByname('KODE').AsString;
    frmjabatan.FLAGEDIT := True;
    frmjabatan.edtKode.Text := CDSMaster.FieldByname('KODE').AsString;
    frmjabatan.loaddata(CDSMaster.FieldByname('KODE').AsString);
    frmjabatan.edtKode.Enabled := False;
  end;
  frmjabatan.Show;
end;

procedure TfrmBrowseJabatan.cxButton6Click(Sender: TObject);
begin
  inherited;
  refreshdata;
end;

procedure TfrmBrowseJabatan.cxButton4Click(Sender: TObject);
var
  s:string;
begin
  inherited;
  try
    if not cekdelete(frmMenu.KDUSER,'frmjabatan') then
    begin
      MessageDlg('Anda tidak berhak Menghapus di Modul ini',mtWarning, [mbOK],0);
      Exit;
    End;

    if MessageDlg('Yakin ingin hapus ?',mtCustom,
                    [mbYes,mbNo], 0)= mrNo
    then Exit ;
    
    s:='delete from tjabatan '
    + ' where kd_jabat = ' + quot(CDSMaster.FieldByname('KODE').AsString) + ';' ;

    EnsureConnected(frmMenu.MyConnection1);
    ExecSQLDirect(frmMenu.MyConnection1,s);

    CDSMaster.Delete;
  except
    MessageDlg('Gagal Hapus',mtError, [mbOK],0);

    Exit;
  end;
end;

end.
