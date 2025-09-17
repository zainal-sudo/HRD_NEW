unit ufrmLembur;

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
  cxLookupEdit, cxDBLookupEdit, cxDBExtLookupComboBox, DBClient, Math,
  AdvEdBtn, cxGroupBox, DateUtils;

type
  TfrmLembur = class(TForm)
    AdvPanel1: TAdvPanel;
    Label2: TLabel;
    Label3: TLabel;
    edtKeterangan: TAdvEdit;
    AdvPanel3: TAdvPanel;
    cxButton8: TcxButton;
    AdvPanel2: TAdvPanel;
    lbljudul: TLabel;
    cxButton2: TcxButton;
    cxButton1: TcxButton;
    dtTanggal: TDateTimePicker;
    Label4: TLabel;
    Label5: TLabel;
    edtNomor: TAdvEdit;
    dtJamMulai: TDateTimePicker;
    Label1: TLabel;
    lbl1: TLabel;
    dtJamAkhir: TDateTimePicker;
    lbl2: TLabel;
    btn1: TcxButton;
    Image1: TImage;
    OpenDialog1: TOpenDialog;
    Label6: TLabel;
    edtPoin: TAdvEdit;
    edtNIK: TAdvEditBtn;
    cxGroupBox1: TcxGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    edtAbsenMsk: TAdvEdit;
    edtAbsenKlr: TAdvEdit;
    Label9: TLabel;
    edtNama: TAdvEdit;
    edtDepartemen: TAdvEdit;
    lbl3: TLabel;
    lbl4: TLabel;
    edtJabatan: TAdvEdit;
    lbl5: TLabel;
    edtDurasi: TAdvEdit;
    procedure refreshdata;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure loaddata(anomor:string) ;
    procedure simpandata(afoto:string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton8Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    function getmaxkode:string;
    procedure edtNomorExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dtTanggalChange(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    function HitungPoin(AMulai, AAkhir: TDateTime): Double;
    procedure edtNIKClickBtn(Sender: TObject);
    procedure ShowAbsensi;
    procedure edtNIKChange(Sender: TObject);
    procedure detailkaryawan;
    function HitungDurasi(AMulai, AAkhir: TDateTime): string;
    procedure dtJamAkhirChange(Sender: TObject);
    procedure dtJamMulaiChange(Sender: TObject);
  private
    FFLAGEDIT: Boolean;
    FFLAGUPLOAD: Boolean;
    FID: string;
    { Private declarations }
  public
    property FLAGEDIT: Boolean read FFLAGEDIT write FFLAGEDIT;
    property FLAGUPLOAD: Boolean read FFLAGUPLOAD write FFLAGUPLOAD;
    property ID: string read FID write FID;
    { Public declarations }
  end;

var
  frmLembur: TfrmLembur;

const
   NOMERATOR = 'LEM';
   PREFIX = 'LM';
         
implementation
uses uModuleConnection, DB, ufrmMenu, Ulib, uFrmbantuan2;

{$R *.dfm}

procedure TfrmLembur.refreshdata;
begin
  FID:='';
  FLAGEDIT := FALSE;
  FLAGUPLOAD := FALSE;
  edtNIK.clear;
  dtTanggal.Date := Date;
  dtJamMulai.Time := Time;
  dtJamAkhir.Time := Time;
  edtKeterangan.Clear;
  Image1.Picture := nil;
  edtNomor.Text := getmaxkode;
  edtDurasi.Text := HitungDurasi(dtJamMulai.Time, dtJamAkhir.Time); 
  edtNIK.SetFocus;
end;

procedure TfrmLembur.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  foto, Msg: String;  
begin
  if (Key = VK_F1) AND (Sender = edtNIK) then
  begin
    sqlbantuan := 'SELECT kar_nik NIK, kar_nama from tkaryawan where kar_status_aktif = 1 AND kar_kd_unit LIKE ' + Quot(frmMenu.KDUNIT);
    Application.CreateForm(Tfrmbantuan2, frmbantuan2);
    frmBantuan2.SQLMaster := sqlbantuan;
    frmBantuan2.ShowModal;

    if keyfield <> '' then
    begin
      edtNIK.Text := keyfield;
      edtNama.Text := displayfield;
      detailkaryawan;
    end;
  end;

  if Key = VK_F8 then
  begin
    Release;
  end;

  if Key = VK_F10 then
  begin
    try
      if (FLAGEDIT) and ( not cekedit(frmMenu.KDUSER,self.name)) then
      begin
        MessageDlg('Anda tidak berhak Edit di Modul ini', mtWarning, [mbOK],0);
        Exit;
      End;

      if (not FLAGEDIT) and ( not cekinsert(frmMenu.KDUSER,self.name)) then
      begin
        MessageDlg('Anda tidak berhak Insert di Modul ini', mtWarning, [mbOK],0);;
        Exit;
      End;

      if MessageDlg('Yakin ingin simpan ?',mtCustom,
                            [mbYes,mbNo], 0)= mrNo
      then Exit ;

      if FLAGUPLOAD then
      begin
        if not UploadFile(Image1.Hint, frmMenu.aurl + '/upload.php', PREFIX, foto, Msg) then
        begin
          MessageDlg(Msg, mtError, [mbOK], 0);
          Exit;
        end;
      end
      else
      begin
        foto := Image1.Hint;
      end;

      simpandata(foto);
      refreshdata;
    except
      ShowMessage('Gagal Simpan');
      Exit;
    end;
  end;
end;

procedure TfrmLembur.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    SelectNext(ActiveControl, True, True);
end;

procedure TfrmLembur.loaddata(anomor:string);
var
  s: string;
  tsql: TmyQuery;
  arc: Integer;
begin
  s:= 'select * from tlembur where lem_nomor = ' + Quot(anomor);
  EnsureConnected(frmMenu.MyConnection1);
  tsql := xOpenQuery(s, arc, frmMenu.myconnection1);
  with tsql do
  begin
    try
      if not Eof then
      begin
        FLAGEDIT := True;
        edtNIK.Text := fieldbyname('lem_kar_nik').AsString;
        dtTanggal.Date := fieldbyname('lem_tanggal').AsDateTime;
        dtJamMulai.Time := fieldbyname('lem_jammulai').AsDateTime;
        dtJamAkhir.Time := fieldbyname('lem_jamakhir').AsDateTime;
        edtPoin.Text := fieldbyname('lem_poin').AsString;
        edtKeterangan.Text := fieldbyname('lem_keterangan').AsString;
        Image1.Hint := fieldbyname('lem_foto').AsString;
        FID := fieldbyname('lem_nomor').Asstring;
        edtDurasi.Text := FormatDateTime('HH:nn', FieldByName('lem_durasi').AsDateTime);

        detailkaryawan;
        ShowAbsensi;
        if (Image1.Hint <> '') then
        begin
          LoadImageFromURL(frmMenu.aurl + '/bukti/' + Image1.Hint, Image1);
        end;
      end
      else
        FLAGEDIT := False;
    finally
      Free;
    end;
  end;
end;

procedure TfrmLembur.simpandata(afoto:string);
var
  s:string;
begin
  if FLAGEDIT then
    s := 'UPDATE tlembur SET '
       + ' lem_kar_nik = ' + Quot(edtNIK.Text) + ','
       + ' lem_tanggal = ' + QuotD(dtTanggal.DateTime) + ','
       + ' lem_jammulai = ' + Quot(FormatDateTime('hh:nn:ss', dtJamMulai.Time)) + ','
       + ' lem_jamakhir = ' + Quot(FormatDateTime('hh:nn:ss', dtJamAkhir.Time)) + ','
       + ' lem_keterangan = ' + Quot(edtKeterangan.Text) + ','
       + ' lem_foto = ' + Quot(afoto) + ','
       + ' lem_poin = ' + floattostr(cstrtoFloat(edtPoin.Text)) + ','
       + ' lem_durasi = ' + Quot(edtDurasi.Text)
       + ' WHERE lem_nomor = ' + quot(FID) + ';'
  else
  begin
    edtNomor.Text := getmaxkode;

    s := 'INSERT INTO tlembur '
       + ' (lem_nomor, lem_kar_nik, lem_tanggal, lem_jammulai, lem_jamakhir, lem_keterangan, lem_foto, lem_poin, lem_durasi) '
       + ' VALUES ( '
       + Quot(edtNomor.Text) + ','
       + Quot(edtNIK.Text) + ','
       + QuotD(dtTanggal.DateTime) + ','
       + Quot(FormatDateTime('hh:nn', dtJamMulai.Time)) + ','
       + Quot(FormatDateTime('hh:nn', dtJamAkhir.Time)) + ','
       + Quot(edtKeterangan.Text) + ','
       + Quot(afoto) + ','
       + floattostr(cstrtoFloat(edtPoin.Text)) + ','
       + Quot(edtDurasi.Text)
       + ');';
  end;
  
  EnsureConnected(frmMenu.MyConnection1);
  ExecSQLDirect(frmMenu.MyConnection1, s);
end;

procedure TfrmLembur.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

procedure TfrmLembur.cxButton1Click(Sender: TObject);
var
  foto, Msg: String;
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

    if FLAGUPLOAD then
    begin
      if not UploadFile(Image1.Hint, frmMenu.aurl + '/upload.php', PREFIX, foto, Msg) then
      begin
        MessageDlg(Msg, mtError, [mbOK], 0);
        Exit;
      end;
    end
    else
    begin
      foto := Image1.Hint;
    end;    

    simpandata(foto);
    refreshdata;
  except
    ShowMessage('Gagal Simpan');
    Exit;
  end;
end;

procedure TfrmLembur.cxButton8Click(Sender: TObject);
begin
  Release;
end;

procedure TfrmLembur.cxButton2Click(Sender: TObject);
var
  foto, Msg: String;
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

    if FLAGUPLOAD then
    begin
      if not UploadFile(Image1.Hint, frmMenu.aurl + '/upload.php', PREFIX, foto, Msg) then
      begin
        MessageDlg(Msg, mtError, [mbOK], 0);
        Exit;
      end;
    end
    else
    begin
      foto := Image1.Hint;
    end;

    simpandata(foto);
    refreshdata;
  except
    ShowMessage('Gagal Simpan');
    Exit;
  end;

  Release;
end;

function TfrmLembur.getmaxkode:string;
var
  s:string;
  arc: Integer;
begin
  s := 'select max(right(lem_nomor,4)) from tlembur '
       + ' where lem_nomor like ' + quot(NOMERATOR+'.'+FormatDateTime('yymm',dtTanggal.Date)+'.%');
       
  with xOpenQuery(s, arc, frmMenu.MyConnection1) do
  begin
    try
      if Fields[0].AsString = '' then
      begin
         result:= NOMERATOR+'.'+FormatDateTime('yymm',dtTanggal.Date)+'.'+RightStr(IntToStr(10000+1),4)
      end
      else
         result:= NOMERATOR+'.'+FormatDateTime('yymm',dtTanggal.Date)+'.'+RightStr(IntToStr(10000+fields[0].AsInteger+1),4);
    finally
      free;
    end;
  end;
end;

procedure TfrmLembur.edtNomorExit(Sender: TObject);
begin
  loaddata(edtNomor.Text);
end;

procedure TfrmLembur.FormShow(Sender: TObject);
begin
  refreshdata;
end;

procedure TfrmLembur.dtTanggalChange(Sender: TObject);
begin
  edtNomor.Text := getmaxkode;

  if (edtNIK.Text = '') OR (dtTanggal.Date = 0) then Exit;

  ShowAbsensi;  
end;

procedure TfrmLembur.btn1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenDialog1.FileName);
    Image1.Hint := OpenDialog1.FileName;
    FLAGUPLOAD := True;
  end;
end;

function TfrmLembur.HitungPoin(AMulai, AAkhir: TDateTime): Double;
var
  DurasiJam: Double;
  SisaJam: Double;
begin
  DurasiJam := (AAkhir - AMulai) * 24;
  DurasiJam := RoundTo(DurasiJam, -4);

  Result := 0;

  if DurasiJam <= 0 then
    Exit;

  if DurasiJam <= 1 then
  begin
    Result := DurasiJam * 1.5;
  end
  else
  begin
    Result := 1.5;
    SisaJam := DurasiJam - 1;
    Result := Result + (SisaJam * 2);
  end;

  Result := RoundTo(Result, -4);
end;

procedure TfrmLembur.edtNIKClickBtn(Sender: TObject);
begin
  sqlbantuan := 'SELECT kar_nik NIK, kar_nama from tkaryawan where kar_status_aktif = 1 AND kar_kd_unit LIKE ' + Quot(frmMenu.KDUNIT);
  Application.CreateForm(Tfrmbantuan2, frmbantuan2);
  frmBantuan2.SQLMaster := sqlbantuan;
  frmBantuan2.ShowModal;

  if keyfield <> '' then
  begin
    edtNIK.Text := keyfield;
    edtNama.Text := displayfield;
    detailkaryawan;
  end;
end;

procedure TfrmLembur.ShowAbsensi;
var
  s: string;
  tsql: TmyQuery;
  arc: Integer;
begin
  s:= 'select MIN(CASE WHEN status_absen = 1 THEN TIME(tanggal) END) AS Jam_in, '
      + ' MAX(CASE WHEN status_absen in (1,2) THEN TIME(tanggal) END) AS Jam_out '
      + ' from tabsensitampung where kar_nik = ' + Quot(edtNIK.Text)
      + ' AND date(tanggal) = ' + QuotD(dtTanggal.Date);
  EnsureConnected(frmMenu.MyConnection1);
  tsql := xOpenQuery(s, arc, frmMenu.myconnection1);
  with tsql do
  begin
    try
      if not Eof then
      begin
        edtAbsenMsk.Text := FormatDateTime('HH:nn:ss', FieldByName('Jam_in').AsDateTime);
        edtAbsenKlr.Text := FormatDateTime('HH:nn:ss', FieldByName('Jam_out').AsDateTime);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrmLembur.edtNIKChange(Sender: TObject);
begin
  if (edtNIK.Text = '') OR (dtTanggal.Date = 0) then Exit;

  ShowAbsensi;
end;

procedure TfrmLembur.detailkaryawan;
var
  s: string;
  tsql: TmyQuery;
  arc: Integer;
begin
  s:= 'SELECT a.kar_nama, b.nm_dept, c.nm_jabat '
      + ' FROM karyawan a '
      + ' INNER JOIN tdept b ON a.kar_dep_kode = b.kd_dept '
      + ' INNER JOIN tjabatan c ON a.kar_jab_kode = c.kd_jabat '
      + ' WHERE a.kar_nik = ' + Quot(edtNIK.Text);
  EnsureConnected(frmMenu.MyConnection1);
  tsql := xOpenQuery(s, arc, frmMenu.myconnection1);
  with tsql do
  begin
    try
      if not Eof then
      begin
        edtNama.Text := FieldByName('kar_nama').AsString;;
        edtDepartemen.Text := FieldByName('nm_dept').AsString;
        edtJabatan.Text := FieldByName('nm_jabat').AsString;
      end;
    finally
      Free;
    end;
  end;
end;

function TfrmLembur.HitungDurasi(AMulai, AAkhir: TDateTime): string;
var
  SelisihMenit: Integer;
  Jam, Menit: Integer;
begin
  AMulai := Frac(AMulai);
  AAkhir := Frac(AAkhir);

  if AAkhir < AMulai then
    AAkhir := AAkhir + 1;

  SelisihMenit := Round((AAkhir - AMulai) * 24 * 60);
  Jam := SelisihMenit div 60;
  Menit := SelisihMenit mod 60;

  Result := Format('%.2d:%.2d', [Jam, Menit]);
end;

procedure TfrmLembur.dtJamAkhirChange(Sender: TObject);
var
  Poin: Double;
begin
  Poin := HitungPoin(dtJamMulai.Time, dtJamAkhir.Time);
  edtPoin.Text := FloatToStr(Poin);

  edtDurasi.Text := HitungDurasi(dtJamMulai.Time, dtJamAkhir.Time);
end;

procedure TfrmLembur.dtJamMulaiChange(Sender: TObject);
begin
  edtDurasi.Text := HitungDurasi(dtJamMulai.Time, dtJamAkhir.Time);
end;

end.
