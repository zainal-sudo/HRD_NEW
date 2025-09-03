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
  cxLookupEdit, cxDBLookupEdit, cxDBExtLookupComboBox, DBClient;

type
  TfrmLembur = class(TForm)
    AdvPanel1: TAdvPanel;
    Label2: TLabel;
    edtNIK: TAdvEdit;
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
  edtNomor.Text := getmaxkode;
  edtNIK.clear;
  dtTanggal.DateTime := Date;
  dtJamMulai.Time := Time;
  dtJamAkhir.Time := Time;
  edtKeterangan.Clear;
  Image1.Picture := nil;
  edtNIK.SetFocus;
end;

procedure TfrmLembur.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  foto, Msg: String;  
begin
  if (Key = VK_F1) AND (Sender = edtNIK) then
  begin
    sqlbantuan := 'SELECT kar_nik NIK, kar_nama from tkaryawan';
    Application.CreateForm(Tfrmbantuan2, frmbantuan2);
    frmBantuan2.SQLMaster := sqlbantuan;
    frmBantuan2.ShowModal;

    if keyfield <> '' then
    begin
      edtNIK.Text := keyfield;
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
        edtKeterangan.Text := fieldbyname('lem_keterangan').AsString;
        Image1.Hint := fieldbyname('lem_foto').AsString;
        FID := fieldbyname('lem_nomor').Asstring;

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
       + ' lem_foto = ' + Quot(afoto)
       + ' WHERE lem_nomor = ' + quot(FID) + ';'
  else
  begin
    edtNomor.Text := getmaxkode;

    s := 'INSERT INTO tlembur '
       + ' (lem_nomor, lem_kar_nik, lem_tanggal, lem_jammulai, lem_jamakhir, lem_keterangan, lem_foto) '
       + ' VALUES ( '
       + Quot(edtNomor.Text) + ','
       + Quot(edtNIK.Text) + ','
       + QuotD(dtTanggal.DateTime) + ','
       + Quot(FormatDateTime('hh:nn', dtJamMulai.Time)) + ','
       + Quot(FormatDateTime('hh:nn', dtJamAkhir.Time)) + ','
       + Quot(edtKeterangan.Text) + ','
       + Quot(afoto)
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

end.
