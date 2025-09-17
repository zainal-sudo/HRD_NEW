unit ufrmIjin2;

interface
                           
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AdvPanel, ComCtrls, StdCtrls, AdvEdit,SqlExpr, Menus,
  cxLookAndFeelPainters, cxButtons, StrUtils, cxGraphics, cxLookAndFeels,
    dxSkinsCore, dxSkinsDefaultPainters,MyAccess, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinValentine, dxSkinXmas2008Blue, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBExtLookupComboBox, DBClient,
  IdHTTP, IdMultipartFormData, JPEG, AdvEdBtn, cxGroupBox, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, DB,
  cxDBData, cxCalendar, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid;

type
  TfrmIjin2 = class(TForm)
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
    cxLookupAlasan: TcxExtLookupComboBox;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtNomor: TAdvEdit;
    Label6: TLabel;
    Image1: TImage;
    btn1: TcxButton;
    OpenDialog1: TOpenDialog;
    edtNIK: TAdvEditBtn;
    cxGroupBox1: TcxGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    edtAbsenMsk: TAdvEdit;
    edtAbsenKlr: TAdvEdit;
    lbl3: TLabel;
    edtDepartemen: TAdvEdit;
    lbl4: TLabel;
    edtJabatan: TAdvEdit;
    lbl5: TLabel;
    edtNama: TAdvEdit;
    AdvPanel4: TAdvPanel;
    cxGrid1: TcxGrid;
    cxGridIjin: TcxGridDBTableView;
    clTanggal: TcxGridDBColumn;
    cxGrid1Level1: TcxGridLevel;
    Label7: TLabel;
    cxButton3: TcxButton;
    dtMulai: TcxDateEdit;
    dtAkhir: TcxDateEdit;
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
    procedure FormCreate(Sender: TObject);
    function getmaxkode(aTanggal:TDateTime; aCount: Integer = 1):string;
    procedure edtNomorExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dtMulaiChange(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure edtNIKClickBtn(Sender: TObject);
    procedure ShowAbsensi;
    procedure edtNIKChange(Sender: TObject);
    procedure detailkaryawan;
    procedure cxButton3Click(Sender: TObject);
    function GetCDSIjin: TClientDataSet;
    procedure initgrid;
    function IsHariLibur(ATanggal: TDateTime; ATipe: string): Boolean;
  private
    FCDSAlasan: TClientDataset;
    FFLAGEDIT: Boolean;
    FFLAGUPLOAD: Boolean;
    FID: string;
    FJAMKERJA: String;
    function GetCDSAlasan: TClientDataset;
    { Private declarations }
  protected
    FCDSIjin: TClientDataSet;
  public
    property CDSIjin: TClientDataSet read GetCDSIjin write FCDSIjin;
    property CDSAlasan: TClientDataset read GetCDSAlasan write FCDSAlasan;
    property FLAGEDIT: Boolean read FFLAGEDIT write FFLAGEDIT;
    property FLAGUPLOAD: Boolean read FFLAGUPLOAD write FFLAGUPLOAD;
    property ID: string read FID write FID;
    property JAMKERJA: string read FJAMKERJA write FJAMKERJA;
    { Public declarations }
  end;

var
  frmIjin2: TfrmIjin2;

const
   NOMERATOR = 'IJN';
   PREFIX = 'IZ';
         
implementation
uses uModuleConnection, ufrmMenu, Ulib, uFrmbantuan2;

{$R *.dfm}

procedure TfrmIjin2.refreshdata;
begin
  FID:='';
  FLAGEDIT := FALSE;
  FLAGUPLOAD := FALSE;
  edtNIK.clear;
  dtMulai.Date := Date;
  dtAkhir.Date := Date;
  cxLookupAlasan.ItemIndex := 0;
  edtKeterangan.Clear;
  Image1.Picture := nil;
  edtNomor.Text := getmaxkode(dtMulai.Date);
  edtNIK.SetFocus;
  initgrid;
end;

function TfrmIjin2.GetCDSIjin: TClientDataSet;
begin
  If not Assigned(FCDSIjin) then
  begin
    FCDSIjin := TClientDataSet.Create(Self);
    zAddField(FCDSIjin, 'tanggal', ftDateTime, False, 20);
    FCDSIjin.CreateDataSet;
  end;
  Result := FCDSIjin;
end;

procedure TfrmIjin2.initgrid;
begin
  CDSIjin.EmptyDataSet;
  CDSIjin.Append;
  CDSIjin.Post;
end;

procedure TfrmIjin2.FormKeyDown(Sender: TObject; var Key: Word;
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
    end;
  end;

  if Key = VK_F8 then
  begin
    Release;
  end;

  if Key = VK_F10 then
  begin
    try
      if ((cxLookupAlasan.Text = 'Sakit') OR (cxLookupAlasan.Text = 'Masuk') OR (cxLookupAlasan.Text = 'Terlambat')) AND (Image1.Hint = '') then
      begin
        MessageDlg('Lampiran foto harus di isi', mtWarning, [mbOK],0);
        Exit;
      end;

      if (FLAGEDIT) and ( not cekedit(frmMenu.KDUSER,self.name)) then
      begin
        MessageDlg('Anda tidak berhak Edit di Modul ini',mtWarning, [mbOK],0);
        Exit;
      End;
    
      if (not FLAGEDIT) and ( not cekinsert(frmMenu.KDUSER, 'frmIjin')) then
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
end;

procedure TfrmIjin2.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    SelectNext(ActiveControl, True, True);
end;

procedure TfrmIjin2.loaddata(anomor:string);
var
  s: string;
  tsql: TmyQuery;
  arc: Integer;
begin
  s:= 'select * from tijin where ij_nomor = ' + Quot(anomor);
  EnsureConnected(frmMenu.MyConnection1);
  tsql := xOpenQuery(s, arc, frmMenu.myconnection1);
  with tsql do
  begin
    try
      if not Eof then
      begin
        FLAGEDIT := True;
        edtNIK.Text := fieldbyname('kar_nik').AsString;
        dtMulai.Date := fieldbyname('tanggal').AsDateTime;
        cxLookupAlasan.Text := fieldbyname('alasan').AsString;
        edtKeterangan.Text := fieldbyname('keterangan').AsString;
        Image1.Hint := fieldbyname('ij_foto').AsString;
        FID := fieldbyname('ij_nomor').Asstring;

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

procedure TfrmIjin2.simpandata(afoto:string);
var
  s: String;
  tt: TStrings;
  i: Integer;
  atgl: TDateTime;
  anomor: String;
  a: Integer;
begin
  tt := TStringList.Create;
  a := 1;

  CDSIjin.first;
  while not CDSIjin.Eof do
  begin
    if (CDSIjin.FieldByName('tanggal').AsString <> '')  then
    begin
      anomor := getmaxkode(CDSIjin.FieldByName('tanggal').AsDateTime, a);

      s := 'INSERT INTO tijin '
         + ' (ij_nomor, kar_nik, tanggal, alasan, keterangan, ij_foto) '
         + ' VALUES ( '
         + Quot(anomor) + ','
         + Quot(edtNIK.Text) + ','
         + QuotD(CDSIjin.FieldByName('tanggal').AsDateTime) + ','
         + Quot(cxLookupAlasan.Text) + ','
         + Quot(edtKeterangan.Text)  + ','
         + Quot(afoto)
         + ');';

      tt.Append(s);
      a := a+1;
    end;

    CDSIjin.Next;
  end;

  try
    for i:=0 to tt.Count -1 do
    begin
      EnsureConnected(frmMenu.MyConnection1);
      ExecSQLDirect(frmMenu.MyConnection1, tt[i]);
    end;
  finally
    tt.Free;
  end;
end;

procedure TfrmIjin2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

procedure TfrmIjin2.cxButton1Click(Sender: TObject);
var
  foto, Msg: String;
begin
  try
    if ((cxLookupAlasan.Text = 'Sakit') OR (cxLookupAlasan.Text = 'Masuk') OR (cxLookupAlasan.Text = 'Terlambat')) AND (Image1.Hint = '') then
    begin
      MessageDlg('Lampiran foto harus di isi', mtWarning, [mbOK],0);
      Exit;
    end;

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

    if (not FLAGEDIT) and ( not cekinsert(frmMenu.KDUSER, 'frmIjin')) then
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

procedure TfrmIjin2.cxButton8Click(Sender: TObject);
begin
  Release;
end;

procedure TfrmIjin2.cxButton2Click(Sender: TObject);
var
  foto, Msg: String;
begin
  try
    if ((cxLookupAlasan.Text = 'Sakit') OR (cxLookupAlasan.Text = 'Masuk') OR (cxLookupAlasan.Text = 'Terlambat')) AND (Image1.Hint = '') then
    begin
      MessageDlg('Lampiran foto harus di isi', mtWarning, [mbOK],0);
      Exit;
    end;
      
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
    
    if (not FLAGEDIT) and ( not cekinsert(frmMenu.KDUSER, 'frmIjin')) then
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

function TfrmIjin2.GetCDSAlasan: TClientDataset;
var s:String;
begin
  If not Assigned(FCDSAlasan) then
  begin
    S := 'select ji_id Kode, ji_keterangan Alasan'
         + ' from tjenisijin ORDER BY ji_keterangan';

    FCDSAlasan := TConextMain.cOpenCDS(S, nil);
  end;
  Result := FCDSAlasan;
end;

procedure TfrmIjin2.FormCreate(Sender: TObject);
begin
  with TcxExtLookupHelper(cxLookupAlasan.Properties) do
    LoadFromCDS(CDSAlasan, 'Kode', 'Alasan',['Kode'],Self);

  TcxDBGridHelper(cxGridIjin).LoadFromCDS(CDSIjin, False, False);
end;

function TfrmIjin2.getmaxkode(aTanggal:TDateTime; aCount: Integer = 1): String;
var
  s:string;
  arc: Integer;
begin
  s := 'select max(right(ij_nomor,4)) from tijin '
       + ' where ij_nomor like ' + quot(NOMERATOR+'.'+FormatDateTime('yymm', aTanggal)+'.%');

  with xOpenQuery(s, arc, frmMenu.MyConnection1) do
  begin
    try
      if Fields[0].AsString = '' then
      begin
         result:= NOMERATOR+'.'+FormatDateTime('yymm', aTanggal)+'.'+RightStr(IntToStr(10000+aCount),4)
      end
      else
         result:= NOMERATOR+'.'+FormatDateTime('yymm', aTanggal)+'.'+RightStr(IntToStr(10000+fields[0].AsInteger+aCount),4);

    finally
      free;
    end;
  end;
end;

procedure TfrmIjin2.edtNomorExit(Sender: TObject);
begin
  loaddata(edtNomor.Text);
end;

procedure TfrmIjin2.FormShow(Sender: TObject);
begin
  refreshdata;
end;

procedure TfrmIjin2.dtMulaiChange(Sender: TObject);
begin
  edtNomor.Text := getmaxkode(dtMulai.Date);

  if (edtNIK.Text = '') OR (dtMulai.Date = 0) then Exit;

  ShowAbsensi;  
end;

procedure TfrmIjin2.btn1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenDialog1.FileName);
    Image1.Hint := OpenDialog1.FileName;
    FLAGUPLOAD := True;
  end;
end;

//function TfrmIjin.UploadFile(const AFilePath, AURL: string; out AServerResponse: string): Boolean;
//var
//  HTTP: TIdHTTP;
//  FormData: TIdMultiPartFormDataStream;
//begin
//  Result := False;
//  AServerResponse := '';
//  HTTP := TIdHTTP.Create(nil);
//  FormData := TIdMultiPartFormDataStream.Create;
//  try
//    try
//      FormData.AddFile('file', AFilePath, 'application/octet-stream');
//      AServerResponse := HTTP.Post(AURL, FormData);
//      Result := True;
//    except
//      on E: Exception do
//      begin
//        AServerResponse := 'Error: ' + E.Message;
//        Result := False;
//      end;
//    end;
//  finally
//    FormData.Free;
//    HTTP.Free;
//  end;
//end;

procedure TfrmIjin2.edtNIKClickBtn(Sender: TObject);
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

procedure TfrmIjin2.ShowAbsensi;
var
  s: string;
  tsql: TmyQuery;
  arc: Integer;
begin
  s:= 'select MIN(CASE WHEN status_absen = 1 THEN TIME(tanggal) END) AS Jam_in, '
      + ' MAX(CASE WHEN status_absen in (1,2) THEN TIME(tanggal) END) AS Jam_out '
      + ' from tabsensitampung where kar_nik = ' + Quot(edtNIK.Text)
      + ' AND date(tanggal) = ' + QuotD(dtMulai.Date);
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

procedure TfrmIjin2.edtNIKChange(Sender: TObject);
begin
  if (edtNIK.Text = '') OR (dtMulai.Date = 0) then Exit;

  ShowAbsensi;
end;

procedure TfrmIjin2.detailkaryawan;
var
  s: string;
  tsql: TmyQuery;
  arc: Integer;
begin
  s:= ' SELECT a.kar_nama, b.nm_dept, c.nm_jabat, u.jam_kerja '
    + ' FROM tkaryawan a '
    + ' LEFT JOIN tdept b ON a.kar_kd_dept = b.kd_dept '
    + ' LEFT JOIN tjabatan c ON a.kar_kd_jabat = c.kd_jabat '
    + ' LEFT JOIN tunit u ON u.kd_unit = a.kar_kd_unit '
    + ' WHERE a.kar_nik = ' + Quot(edtNIK.Text);
    
  EnsureConnected(frmMenu.MyConnection1);
  tsql := xOpenQuery(s, arc, frmMenu.myconnection1);
  with tsql do
  begin
    try
      if not Eof then
      begin
        edtNama.Text := FieldByName('kar_nama').AsString;
        edtDepartemen.Text := FieldByName('nm_dept').AsString;
        edtJabatan.Text := FieldByName('nm_jabat').AsString;
        JAMKERJA := FieldByName('jam_kerja').AsString;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrmIjin2.cxButton3Click(Sender: TObject);
var
  i: Integer;
  atgl: TDate;
begin
  CDSIjin.EmptyDataSet;
  atgl := dtMulai.Date;

  while atgl <= dtAkhir.Date do
  begin
    if not IsHariLibur(atgl, JAMKERJA) then
    begin
      CDSIjin.Append;
      CDSIjin.FieldByName('tanggal').AsDateTime := atgl;
      CDSIjin.Post;
    end;

    atgl := atgl + 1;
  end;
end;

function TfrmIjin2.IsHariLibur(ATanggal: TDateTime; ATipe: string): Boolean;
var
  dayName, s: string;
  arc: Integer;
  tsql: TmyQuery;
begin
  Result := False;

  if SameText(ATipe, 'Normal') then
  begin
    s:= ' SELECT COUNT(*) AS jml FROM tharilibur WHERE hl_tanggal = ' + QuotD(ATanggal);
    EnsureConnected(frmMenu.MyConnection1);
    tsql := xOpenQuery(s, arc, frmMenu.myconnection1);
    with tsql do
    begin
      try
        Result := FieldByName('jml').AsInteger > 0;
      finally
        Free;
      end;
    end;
  end;

  if SameText(ATipe, 'Shift libur') then
  begin
    s:= ' SELECT COUNT(*) AS jml FROM tharilibur WHERE hl_tanggal = ' + QuotD(ATanggal);
    EnsureConnected(frmMenu.MyConnection1);
    tsql := xOpenQuery(s, arc, frmMenu.myconnection1);
    with tsql do
    begin
      try
        Result := FieldByName('jml').AsInteger > 0;
      finally
        Free;
      end;
    end;

    if not Result then
    begin
      if DayOfWeek(ATanggal) = 7 then
        Result := True;
    end;
  end;
end;

end.
