unit ufrmLembur2;

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
  AdvEdBtn, cxGroupBox, DateUtils, cxStyles, dxSkinscxPCPainter,
  cxCustomData, cxFilter, cxData, cxDataStorage, DB, cxDBData,
  cxButtonEdit, cxTimeEdit, cxCheckBox, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid;

type
  TfrmLembur2 = class(TForm)
    AdvPanel1: TAdvPanel;
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
    lbl2: TLabel;
    btn1: TcxButton;
    Image1: TImage;
    OpenDialog1: TOpenDialog;
    AdvPanel4: TAdvPanel;
    cxGrid1: TcxGrid;
    cxGridLembur: TcxGridDBTableView;
    clNo: TcxGridDBColumn;
    clNik: TcxGridDBColumn;
    clNama: TcxGridDBColumn;
    clJamMulai: TcxGridDBColumn;
    clJamAkhir: TcxGridDBColumn;
    cxGrid1Level1: TcxGridLevel;
    Button1: TButton;
    clDurasi: TcxGridDBColumn;
    clPoin: TcxGridDBColumn;
    PopupMenu1: TPopupMenu;
    HapusRecord1: TMenuItem;
    procedure refreshdata;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure simpandata(afoto:string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton8Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    function getmaxkode(aCount: Integer = 1):string;
    procedure FormShow(Sender: TObject);
    procedure dtTanggalChange(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    function HitungPoin(AMulai, AAkhir: TDateTime): Double;
    function HitungDurasi(AMulai, AAkhir: TDateTime): string;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure clNikPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    function GetCDSLembur: TClientDataSet;
    procedure bantuankaryawan;
    procedure clNoGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: String);
    procedure clJamMulaiPropertiesEditValueChanged(Sender: TObject);
    procedure initgrid;
    procedure HapusRecord1Click(Sender: TObject);
    procedure clJamAkhirPropertiesEditValueChanged(Sender: TObject);
    procedure CDSLemburNewRecord(DataSet: TDataSet);
  private
    FFLAGEDIT: Boolean;
    FFLAGUPLOAD: Boolean;
    FID: string;
    { Private declarations }
  protected
    FCDSLembur: TClientDataSet;
  public
    property CDSLembur: TClientDataSet read GetCDSLembur write FCDSLembur;
    property FLAGEDIT: Boolean read FFLAGEDIT write FFLAGEDIT;
    property FLAGUPLOAD: Boolean read FFLAGUPLOAD write FFLAGUPLOAD;
    property ID: string read FID write FID;
    { Public declarations }
  end;

var
  frmLembur2: TfrmLembur2;

const
   NOMERATOR = 'LEM';
   PREFIX = 'LM';
         
implementation
uses uModuleConnection, ufrmMenu, Ulib, uFrmbantuan2;

{$R *.dfm}

procedure TfrmLembur2.refreshdata;
begin
  FID := '';
  FLAGEDIT := FALSE;
  FLAGUPLOAD := FALSE;
  dtTanggal.Date := Date;
  edtKeterangan.Clear;
  Image1.Picture := nil;
  edtNomor.Text := getmaxkode;
  dtTanggal.SetFocus;
  initgrid;
end;

procedure TfrmLembur2.initgrid;
begin
  CDSLembur.EmptyDataSet;
  CDSLembur.Append;
  CDSLembur.FieldByName('jamawal').AsDateTime  := EncodeTime(0,0,0,0);
  CDSLembur.FieldByName('jamakhir').AsDateTime := EncodeTime(0,0,0,0);
  CDSLembur.FieldByName('durasi').AsString     := '00:00';
  CDSLembur.FieldByName('poin').AsFloat        := 0;
  CDSLembur.Post;
end;

procedure TfrmLembur2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  foto, Msg: String;  
begin
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

      if (not FLAGEDIT) and ( not cekinsert(frmMenu.KDUSER, 'frmLembur')) then
      begin
        MessageDlg('Anda tidak berhak Insert di Modul ini', mtWarning, [mbOK],0);
        Exit;
      End;

      if MessageDlg('Yakin ingin simpan ?',mtCustom,
                            [mbYes,mbNo], 0)= mrNo
      then Exit;

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

procedure TfrmLembur2.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    SelectNext(ActiveControl, True, True);
end;

procedure TfrmLembur2.simpandata(afoto:string);
var
  s: String;
  tt: TStrings;
  i: Integer;
  atgl: TDateTime;
  anomor: String;
  a: Integer;
begin
  {if FLAGEDIT then
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
  ExecSQLDirect(frmMenu.MyConnection1, s);}

  tt := TStringList.Create;
  a := 1;

  CDSLembur.first;
  while not CDSLembur.Eof do
  begin
    if (CDSLembur.FieldByName('nik').asstring <> '')  then
    begin
      anomor := getmaxkode(a);

      s := ' INSERT INTO tlembur '
         + ' (lem_nomor, lem_kar_nik, lem_tanggal, lem_jammulai, lem_jamakhir, lem_keterangan, lem_foto, lem_poin, lem_durasi) '
         + ' VALUES ( '
         + Quot(anomor) + ','
         + Quot(CDSLembur.FieldByName('nik').AsString) + ','
         + QuotD(dtTanggal.DateTime) + ','
         + Quot(FormatDateTime('hh:nn', CDSLembur.FieldByName('jamawal').AsDateTime)) + ','
         + Quot(FormatDateTime('hh:nn', CDSLembur.FieldByName('jamakhir').AsDateTime)) + ','
         + Quot(edtKeterangan.Text) + ','
         + Quot(afoto) + ','
         + Quot(CDSLembur.FieldByName('poin').AsString) + ','
         + Quot(CDSLembur.FieldByName('durasi').AsString)
         + ');';

      tt.Append(s);
      a := a+1;
    end;

    CDSLembur.Next;
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

procedure TfrmLembur2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

procedure TfrmLembur2.cxButton1Click(Sender: TObject);
var
  foto, Msg: String;
begin
  try
    if (FLAGEDIT) and ( not cekedit(frmMenu.KDUSER,self.name)) then
    begin
       MessageDlg('Anda tidak berhak Edit di Modul ini',mtWarning, [mbOK],0);
       Exit;
    End;

    if (not FLAGEDIT) and ( not cekinsert(frmMenu.KDUSER, 'frmLembur')) then
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

procedure TfrmLembur2.cxButton8Click(Sender: TObject);
begin
  Release;
end;

procedure TfrmLembur2.cxButton2Click(Sender: TObject);
var
  foto, Msg: String;
begin
  try
    if (FLAGEDIT) and ( not cekedit(frmMenu.KDUSER,self.name)) then
    begin
      MessageDlg('Anda tidak berhak Edit di Modul ini',mtWarning, [mbOK],0);
      Exit;
    End;
    
    if (not FLAGEDIT) and ( not cekinsert(frmMenu.KDUSER, 'frmLembur')) then
    begin
      MessageDlg('Anda tidak berhak Insert di Modul ini',mtWarning, [mbOK],0);
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

function TfrmLembur2.getmaxkode(aCount: Integer = 1):string;
var
  s: String;
  arc: Integer;
begin
  s := 'select max(right(lem_nomor,4)) from tlembur '
       + ' where lem_nomor like ' + quot(NOMERATOR+'.'+FormatDateTime('yymm',dtTanggal.Date)+'.%');
       
  with xOpenQuery(s, arc, frmMenu.MyConnection1) do
  begin
    try
      if Fields[0].AsString = '' then
      begin
         result:= NOMERATOR+'.'+FormatDateTime('yymm',dtTanggal.Date)+'.'+RightStr(IntToStr(10000+aCount),4)
      end
      else
         result:= NOMERATOR+'.'+FormatDateTime('yymm',dtTanggal.Date)+'.'+RightStr(IntToStr(10000+fields[0].AsInteger+aCount),4);
    finally
      free;
    end;
  end;
end;

procedure TfrmLembur2.FormShow(Sender: TObject);
begin
  refreshdata;
end;

procedure TfrmLembur2.dtTanggalChange(Sender: TObject);
begin
  edtNomor.Text := getmaxkode;
end;

procedure TfrmLembur2.btn1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenDialog1.FileName);
    Image1.Hint := OpenDialog1.FileName;
    FLAGUPLOAD := True;
  end;
end;

function TfrmLembur2.HitungPoin(AMulai, AAkhir: TDateTime): Double;
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

function TfrmLembur2.HitungDurasi(AMulai, AAkhir: TDateTime): string;
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

procedure TfrmLembur2.Button1Click(Sender: TObject);
var
  awal, akhir, durasi, poin: String;
  i: Integer;
begin
  CDSLembur.First;
  i := 0;

  while not CDSLembur.Eof do
  begin
    if i = 0 then
    begin
      awal := CDSLembur.fieldbyname('jamawal').AsString;
      akhir := CDSLembur.fieldbyname('jamakhir').AsString;
      durasi := CDSLembur.fieldbyname('durasi').AsString;
      poin := CDSLembur.fieldbyname('poin').AsString;
    end
    else
    begin
      cdslembur.Edit;
      CDSLembur.fieldbyname('jamawal').AsString  := awal;
      CDSLembur.fieldbyname('jamakhir').AsString  := akhir;
      CDSLembur.fieldbyname('durasi').AsString  := durasi;
      CDSLembur.fieldbyname('poin').AsString  := poin;
      CDSLembur.Post;
    end;

    CDSLembur.next;
    Inc(i);
  end;
end;

function TfrmLembur2.GetCDSLembur: TClientDataSet;
begin
  If not Assigned(FCDSLembur) then
  begin
    FCDSLembur := TClientDataSet.Create(Self);
    zAddField(FCDSLembur, 'no', ftInteger, False);
    zAddField(FCDSLembur, 'nik', ftString, False,100);
    zAddField(FCDSLembur, 'nama', ftString, False,100);
    zAddField(FCDSLembur, 'jamawal', ftDateTime, False, 20);
    zAddField(FCDSLembur, 'jamakhir', ftDateTime, False, 20);
    zAddField(FCDSLembur, 'durasi', ftString, False, 20);
    zAddField(FCDSLembur, 'poin', ftFloat, False);
    FCDSLembur.OnNewRecord := CDSLemburNewRecord;
    FCDSLembur.CreateDataSet;
  end;
  Result := FCDSLembur;
end;

procedure TfrmLembur2.CDSLemburNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('jamawal').AsDateTime  := EncodeTime(0,0,0,0);
  DataSet.FieldByName('jamakhir').AsDateTime := EncodeTime(0,0,0,0);
  DataSet.FieldByName('durasi').AsString     := '00:00';
  DataSet.FieldByName('poin').AsFloat        := 0;
end;

procedure TfrmLembur2.FormCreate(Sender: TObject);
begin
  TcxDBGridHelper(cxGridLembur).LoadFromCDS(CDSLembur, False, False);
end;

procedure TfrmLembur2.clNikPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  bantuankaryawan;
end;

procedure TfrmLembur2.bantuankaryawan;
var
  s: String;
  tsql: TmyQuery;
  i: Integer;
begin
  sqlbantuan := ' SELECT k.kar_nik Nik, kar_nama Nama, kar_tgllahir TglLahir, kar_jnskelamin Jenis_Kelamin, '
              + ' kar_tgl_masuk TglMasuk, nm_jabat Jabatan, nm_dept Departemen, kar_alamat Alamat, '
              + ' MIN(CASE WHEN a.status_absen = 1 THEN TIME(a.tanggal) END) AS Jam_in, '
              + ' MAX(CASE WHEN a.status_absen IN (1,2) THEN TIME(a.tanggal) END) AS Jam_out '
              + ' from tkaryawan k '
              + ' left join tjabatan on kd_jabat = k.kar_kd_jabat '
              + ' left join tdept on kd_dept = k.kar_kd_dept '
              + ' LEFT JOIN tabsensitampung a ON a.kar_nik = k.kar_nik AND DATE(a.tanggal) = ' + QuotD(dtTanggal.Date)
              + ' where kar_status_aktif = 1 '
              + ' and kar_kd_unit LIKE ' + Quot('%'+frmMenu.KDUNIT+'%')
              + ' GROUP BY k.kar_nik';

  sqlfilter := 'Nik, Nama';
  Application.CreateForm(TfrmBantuan2, frmBantuan2);
  frmBantuan2.SQLMaster := SQLbantuan;
  frmBantuan2.ShowModal;

  if keyfield <> '' then
  begin
    for i := 0 to cxGridLembur.DataController.RecordCount-1 do
    begin
      If(cxGridLembur.DataController.Values[i, clNik.Index] = keyfield) and (cxGridLembur.DataController.FocusedRecordIndex <> i)
      then
      begin
        ShowMessage('Karyawan ini sudah dimasukkan , sama dengan baris '+ IntToStr(i+1));
        CDSLembur.Cancel;

        exit;
      end;
    end;

    If CDSLembur.State <> dsEdit then
      CDSLembur.Edit;

    CDSLembur.FieldByName('nik').AsString := keyfield;
    CDSLembur.FieldByName('nama').AsString := displayfield;
  end;
end;

procedure TfrmLembur2.clNoGetDisplayText(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; var AText: String);
begin
  inherited;
  If Assigned(ARecord) then
  begin
    AText := Inttostr(ARecord.Index+1);
  end;
end;

procedure TfrmLembur2.clJamMulaiPropertiesEditValueChanged(
  Sender: TObject);
var
  i: Integer;
  lJamMulai, lJamAkhir: TDateTime;
begin
  inherited;
  cxGridLembur.DataController.Post;

  i := cxGridLembur.DataController.FocusedRecordIndex;
  lJamMulai := cxGridLembur.DataController.Values[i, clJamMulai.Index];
  lJamAkhir := cxGridLembur.DataController.Values[i, clJamAkhir.Index];

  If CDSLembur.State <> dsEdit then CDSLembur.Edit;
  CDSLembur.FieldByName('durasi').AsString := HitungDurasi(lJamMulai, lJamAkhir);
  CDSLembur.FieldByName('poin').AsFloat := HitungPoin(lJamMulai, lJamAkhir);
  CDSLembur.Post;
end;

procedure TfrmLembur2.HapusRecord1Click(Sender: TObject);
begin
  If CDSLembur.Eof then exit;
  CDSLembur.Delete;
  If CDSLembur.Eof then initgrid;
end;

procedure TfrmLembur2.clJamAkhirPropertiesEditValueChanged(
  Sender: TObject);
begin
  clJamMulaiPropertiesEditValueChanged(Sender);
end;

end.
