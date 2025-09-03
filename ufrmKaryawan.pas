unit ufrmKaryawan;

interface
                           
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AdvPanel, ComCtrls, StdCtrls, AdvEdit,SqlExpr, Menus,
  cxLookAndFeelPainters, cxButtons,StrUtils, cxGraphics, cxLookAndFeels,
  dxSkinsCore, dxSkinsDefaultPainters,MyAccess, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinValentine, dxSkinXmas2008Blue, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBExtLookupComboBox, AdvEdBtn, Math, DBClient;

type
  TfrmKaryawan = class(TForm)
    AdvPanel1: TAdvPanel;
    Label2: TLabel;
    edtNIK: TAdvEdit;
    Label3: TLabel;
    edtNama: TAdvEdit;
    AdvPanel3: TAdvPanel;
    cxButton8: TcxButton;
    AdvPanel2: TAdvPanel;
    lbljudul: TLabel;
    cxButton2: TcxButton;
    cxButton1: TcxButton;
    Label1: TLabel;
    edtAlamat: TMemo;
    Label4: TLabel;
    edtTelp: TAdvEdit;
    Label5: TLabel;
    edtUnit: TAdvEditBtn;
    edtNamaUnit: TAdvEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    edtJabatan: TAdvEditBtn;
    edtNamaJabatan: TAdvEdit;
    edtDepartemen: TAdvEditBtn;
    edtNamaDept: TAdvEdit;
    edtNoBpjs: TAdvEdit;
    edtNoBpjsTk: TAdvEdit;
    dtMasuk: TDateTimePicker;
    dtLahir: TDateTimePicker;
    edtTmptLahir: TAdvEdit;
    cxExtJK: TcxExtLookupComboBox;
    cxExtStatus: TcxExtLookupComboBox;
    procedure refreshdata;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure loaddata(akode:string) ;
    procedure simpandata;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton8Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure edtNIKExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtUnitClickBtn(Sender: TObject);
    procedure edtJabatanClickBtn(Sender: TObject);
    procedure edtDepartemenClickBtn(Sender: TObject);
  private
    FCDSJenisKelamin: TClientDataset;
    FCDSStatus: TClientDataset;
    FFLAGEDIT: Boolean;
    FID: string;

    function GetCDSJenisKelamin: TClientDataset;
    function GetCDSStatus: TClientDataset;
    { Private declarations }
  public
    property CDSJenisKelamin: TClientDataset read GetCDSJenisKelamin write
        FCDSJenisKelamin;
    property CDSStatus: TClientDataset read GetCDSStatus write
        FCDSStatus;
    property FLAGEDIT: Boolean read FFLAGEDIT write FFLAGEDIT;
    property ID: string read FID write FID;
    { Public declarations }
  end;

var
  frmKaryawan: TfrmKaryawan;

implementation
uses uModuleConnection, DB, ufrmMenu, ufrmbantuan2, Ulib;

{$R *.dfm}

procedure TfrmKaryawan.refreshdata;
begin
  FID := '';
  edtNIK.Enabled := True;
  edtNIK.clear;
  edtNama.Clear;
  edtAlamat.Lines.Clear;
  edtTelp.Clear;
  edtUnit.Clear;
  edtNamaUnit.Clear;
  edtJabatan.Clear;
  edtNamaJabatan.Clear;
  edtDepartemen.Clear;
  edtNamaDept.Clear;
  edtNoBpjs.Clear;
  edtNoBpjsTk.Clear;
  cxExtJK.ItemIndex := 0;
  cxExtStatus.ItemIndex := 0;
  dtMasuk.DateTime := Date;
  dtLahir.DateTime := Date;
  edtTmptLahir.Clear;
  edtNIK.SetFocus;
end;

procedure TfrmKaryawan.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F8 then
  begin
    Release;
  end;

  if Key= VK_F10 then
  begin
    try
      if (FLAGEDIT) and ( not cekedit(frmMenu.KDUSER, self.name)) then
      begin
        MessageDlg('Anda tidak berhak Edit di Modul ini', mtWarning, [mbOK], 0);
        Exit;
      End;
    
      if (not FLAGEDIT) and ( not cekinsert(frmMenu.KDUSER,self.name)) then
      begin
        MessageDlg('Anda tidak berhak Insert di Modul ini',mtWarning, [mbOK], 0);;
        Exit;
      End;

      if MessageDlg('Yakin ingin simpan ?',mtCustom,
                            [mbYes,mbNo], 0)= mrNo
      then Exit ;

      simpandata;
      refreshdata;
    except
      ShowMessage('Gagal Simpan');
      Exit;
    end;
  end;
end;

procedure TfrmKaryawan.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    SelectNext(ActiveControl,True,True);
end;

procedure TfrmKaryawan.loaddata(akode:string) ;
var
  s: string;
  tsql : TmyQuery;
  arc:Integer;
begin
  s:= 'SELECT kar_nik, kar_nama, kar_alamat, kar_telp, kar_kd_unit, kar_kd_jabat, kar_kd_dept, kar_no_bpjs, '
      + ' kar_no_bpjstk, kar_jnskelamin, kar_status_aktif, kar_tgl_masuk, kar_tgllahir, kar_tempatlahir '
      + ' FROM tkaryawan WHERE kar_nik = ' + Quot(akode) ;
  EnsureConnected(frmMenu.MyConnection1);
  tsql := xOpenQuery(s, arc, frmMenu.myconnection1);
  with tsql do
  begin
    try
      if not Eof then
      begin
        FLAGEDIT := True;
        edtNIK.Enabled := False;
        edtNama.Text := fieldbyname('kar_nama').AsString;
        edtAlamat.Text := fieldbyname('kar_alamat').AsString;
        edtTelp.Text := fieldbyname('kar_telp').AsString;
        edtUnit.Text := fieldbyname('kar_kd_unit').AsString;
        edtNamaUnit.Text := getnama('tunit','kd_unit', edtUnit.Text, 'nm_unit');
        edtJabatan.Text := fieldbyname('kar_kd_jabat').AsString;
        edtNamaJabatan.Text := getnama('tjabatan','kd_jabat', edtJabatan.Text, 'nm_jabat');
        edtDepartemen.Text := fieldbyname('kar_kd_dept').AsString;
        edtNamaDept.Text := getnama('tdept','kd_dept', edtDepartemen.Text, 'nm_dept');
        edtNoBpjs.Text := fieldbyname('kar_no_bpjs').AsString;
        edtNoBpjsTk.Text := fieldbyname('kar_no_bpjstk').AsString;
        cxExtJK.Text := fieldbyname('kar_jnskelamin').AsString;
        cxExtStatus.EditValue := FieldByName('kar_status_aktif').AsString;
        dtMasuk.Date := fieldbyname('kar_tgl_masuk').AsDateTime;
        dtLahir.Date := fieldbyname('kar_tgllahir').AsDateTime;
        edtTmptLahir.Text := fieldbyname('kar_tempatlahir').AsString;
        FID := fieldbyname('kar_nik').Asstring;
      end
      else
        FLAGEDIT := False;
    finally
      Free;
    end;
  end;
end;

procedure TfrmKaryawan.simpandata;
var
  s:string;
begin
  if FLAGEDIT then
    s := ' UPDATE tkaryawan SET '
         + ' kar_nama = ' + Quot(edtNama.Text) + ','
         + ' kar_alamat = ' + Quot(edtAlamat.Text) + ','
         + ' kar_telp = ' + Quot(edtTelp.Text) + ','
         + ' kar_kd_unit =  ' + Quot(edtUnit.Text) + ','
         + ' kar_kd_jabat =  ' + Quot(edtJabatan.Text) + ','
         + ' kar_kd_dept =  ' + Quot(edtDepartemen.Text) + ','
         + ' kar_no_bpjs =  ' + Quot(edtNoBpjs.Text) + ','
         + ' kar_no_bpjstk =  ' + Quot(edtNoBpjsTk.Text) + ','
         + ' kar_jnskelamin =  ' + Quot(cxExtJK.Text) + ','
         + ' kar_status_aktif =  ' + IntToStr(cVarToInt(cxExtStatus.EditValue)) + ','
         + ' kar_tgl_masuk = ' + QuotD(dtMasuk.Date) + ','
         + ' kar_tgllahir =   ' + QuotD(dtLahir.Date) + ','
         + ' kar_tempatlahir =  ' + Quot(edtTmptLahir.Text)
         + ' WHERE kar_nik =  ' + Quot(edtNIK.Text) + ';'
  else
  begin
    s := ' INSERT INTO tkaryawan (kar_nik, kar_nama, kar_alamat, kar_telp, kar_kd_unit, kar_kd_jabat, kar_kd_dept, '
         + ' kar_no_bpjs, kar_no_bpjstk, kar_jnskelamin, kar_status_aktif, kar_tgl_masuk, kar_tgllahir, kar_tempatlahir) '
         + ' VALUES( '
         + Quot(edtNIK.Text) + ','
         + Quot(edtNama.Text) + ','
         + Quot(edtAlamat.Text) + ','
         + Quot(edtTelp.Text) + ','
         + Quot(edtUnit.Text) + ','
         + Quot(edtJabatan.Text) + ','
         + Quot(edtDepartemen.Text) + ','
         + Quot(edtNoBpjs.Text) + ','
         + Quot(edtNoBpjsTk.Text) + ','
         + Quot(cxExtJK.Text) + ','
         + IntToStr(cVarToInt(cxExtStatus.EditValue)) + ','
         + QuotD(dtMasuk.Date) + ','
         + QuotD(dtLahir.Date) + ','
         + Quot(edtTmptLahir.Text)
         + ');';
  end;

  EnsureConnected(frmMenu.MyConnection1);
  ExecSQLDirect(frmMenu.MyConnection1, s);
end;

procedure TfrmKaryawan.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

procedure TfrmKaryawan.cxButton1Click(Sender: TObject);
begin
  try
    if edtNIK.Text = '' then
    begin
      MessageDlg('NIK harus di isi', mtWarning, [mbOK],0);
      Exit;
    end;

    if (FLAGEDIT) and ( not cekedit(frmMenu.KDUSER,self.name)) then
    begin
       MessageDlg('Anda tidak berhak Edit di Modul ini',mtWarning, [mbOK],0);
       Exit;
    End;

    if (not FLAGEDIT) and ( not cekinsert(frmMenu.KDUSER,self.name)) then
    begin
       MessageDlg('Anda tidak berhak Insert di Modul ini',mtWarning, [mbOK],0);;
       Exit;
    End;

    if MessageDlg('Yakin ingin simpan ?',mtCustom,
                              [mbYes,mbNo], 0)= mrNo
    then Exit ;

    simpandata;
    refreshdata;
  except
    ShowMessage('Gagal Simpan');
    Exit;
  end;
end;

procedure TfrmKaryawan.cxButton8Click(Sender: TObject);
begin
  Release;
end;

procedure TfrmKaryawan.cxButton2Click(Sender: TObject);
begin
  try
    if edtNIK.Text = '' then
    begin
      MessageDlg('NIK harus di isi',mtWarning, [mbOK],0);
      Exit;
    end;
    
    if (FLAGEDIT) and ( not cekedit(frmMenu.KDUSER,self.name)) then
    begin
      MessageDlg('Anda tidak berhak Edit di Modul ini',mtWarning, [mbOK],0);
      Exit;
    End;
    
    if (not FLAGEDIT) and ( not cekinsert(frmMenu.KDUSER,self.name)) then
    begin
      MessageDlg('Anda tidak berhak Insert di Modul ini',mtWarning, [mbOK],0);;
      Exit;
    End;

    if MessageDlg('Yakin ingin simpan ?',mtCustom,
                        [mbYes,mbNo], 0)= mrNo
    then Exit ;

    simpandata;
    refreshdata;
  except
    ShowMessage('Gagal Simpan');
    Exit;
  end;

  Release;
end;

procedure TfrmKaryawan.edtNIKExit(Sender: TObject);
begin
  loaddata(edtNIK.Text);
end;

procedure TfrmKaryawan.FormCreate(Sender: TObject);
begin
  with TcxExtLookupHelper(cxExtJK.Properties) do
    LoadFromCDS(CDSJenisKelamin, 'Kode', 'JK',['Kode'],Self);

  with TcxExtLookupHelper(cxExtStatus.Properties) do
    LoadFromCDS(CDSStatus, 'Kode','Status',['Kode'],Self);    
end;

procedure TfrmKaryawan.edtUnitClickBtn(Sender: TObject);
begin
  sqlbantuan := 'SELECT kd_unit, nm_unit from tunit';
  Application.CreateForm(Tfrmbantuan2,frmbantuan2);
  frmBantuan2.SQLMaster := sqlbantuan;
  frmBantuan2.ShowModal;

  if keyfield <> '' then
  begin
    edtUnit.Text := keyfield;
    edtNamaUnit.Text := displayfield;
  end;
end;

procedure TfrmKaryawan.edtJabatanClickBtn(Sender: TObject);
begin
  sqlbantuan := 'SELECT kd_jabat, nm_jabat from tjabatan';
  Application.CreateForm(Tfrmbantuan2, frmbantuan2);
  frmBantuan2.SQLMaster := sqlbantuan;
  frmBantuan2.ShowModal;

  if keyfield <> '' then
  begin
    edtJabatan.Text := keyfield;
    edtNamaJabatan.Text := displayfield;
  end;
end;

procedure TfrmKaryawan.edtDepartemenClickBtn(Sender: TObject);
begin
  sqlbantuan := 'SELECT kd_dept, nm_dept from tdept';
  Application.CreateForm(Tfrmbantuan2, frmbantuan2);
  frmBantuan2.SQLMaster := sqlbantuan;
  frmBantuan2.ShowModal;

  if keyfield <> '' then
  begin
    edtDepartemen.Text := keyfield;
    edtNamaDept.Text := displayfield;
  end;
end;

function TfrmKaryawan.GetCDSJenisKelamin: TClientDataset;
begin
  If not Assigned(FCDSJenisKelamin) then
  begin

    FCDSJenisKelamin := TClientDataSet.Create(Self);
    with FCDSJenisKelamin do
    begin
      FieldDefs.Add('Kode', ftString, 10);
      FieldDefs.Add('JK', ftString, 50);
      CreateDataSet;

      AppendRecord(['1', 'Pria']);
      AppendRecord(['2', 'Wanita']);
    end;
  end;
  Result := FCDSJenisKelamin;
end;

function TfrmKaryawan.GetCDSStatus: TClientDataset;
begin
  If not Assigned(FCDSStatus) then
  begin
    FCDSStatus := TClientDataSet.Create(Self);
    with FCDSStatus do
    begin
      FieldDefs.Add('Kode', ftString, 10);
      FieldDefs.Add('Status', ftString, 50);
      CreateDataSet;

      AppendRecord(['1', 'Aktif']);
      AppendRecord(['2', 'Tidak Aktif']);
    end;
  end;
  Result := FCDSStatus;
end;

end.
