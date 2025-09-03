unit ufrmJabatan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AdvPanel, ComCtrls, StdCtrls, AdvEdit,SqlExpr, Menus,
  cxLookAndFeelPainters, cxButtons,StrUtils, cxGraphics, cxLookAndFeels,
  dxSkinsCore, dxSkinsDefaultPainters,MyAccess;

type
  TfrmJabatan = class(TForm)
    AdvPanel1: TAdvPanel;
    Label2: TLabel;
    edtKode: TAdvEdit;
    Label3: TLabel;
    edtNama: TAdvEdit;
    AdvPanel3: TAdvPanel;
    cxButton8: TcxButton;
    AdvPanel2: TAdvPanel;
    lbljudul: TLabel;
    cxButton2: TcxButton;
    cxButton1: TcxButton;
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
    procedure edtKodeExit(Sender: TObject);

  private
    FFLAGEDIT: Boolean;
    FID: string;


    { Private declarations }
  public
    property FLAGEDIT: Boolean read FFLAGEDIT write FFLAGEDIT;
    property ID: string read FID write FID;
    { Public declarations }
  end;

var
  frmJabatan: TfrmJabatan;

implementation
uses uModuleConnection, DB, ufrmMenu;

{$R *.dfm}

procedure TfrmJabatan.refreshdata;
begin
  FID:='';
  edtKode.Enabled := True;
  edtkode.clear;
  edtNama.Clear;
  edtkode.SetFocus;
end;

procedure TfrmJabatan.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F8 then
  begin
      Release;
  end;

  if Key= VK_F10 then
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

      simpandata;
      refreshdata;
   except
     ShowMessage('Gagal Simpan');

     Exit;
   end;
  end;
end;

procedure TfrmJabatan.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    SelectNext(ActiveControl,True,True);
end;

procedure TfrmJabatan.loaddata(akode:string) ;
var
  s: string;
  tsql : TmyQuery;
  arc:Integer;
begin
  s:= 'select kd_jabat, nm_jabat from tjabatan where kd_jabat = ' + Quot(akode) ;
  EnsureConnected(frmMenu.MyConnection1);  
  tsql := xOpenQuery(s,arc,frmMenu.myconnection1);
  with tsql do
  begin
    try
      if not Eof then
      begin
        FLAGEDIT := True;
        edtKode.Enabled := False;
        edtNama.Text := fieldbyname('nm_jabat').AsString;
        FID :=fieldbyname('kd_jabat').Asstring;
      end
      else
        FLAGEDIT := False;
    finally
      Free;
    end;
  end;
end;

procedure TfrmJabatan.simpandata;
var
  s:string;
begin
  if FLAGEDIT then
    s:='update tjabatan set '
    + ' nm_jabat = ' + Quot(edtNama.Text)
    + ' where kd_jabat = ' + quot(FID) + ';'
  else
  begin
    s := ' insert into tjabatan '
         + ' (kd_jabat, nm_jabat) '
         + ' values ( '
         + Quot(edtKode.Text) + ','
         + Quot(edtNama.Text)
         + ');';
  end;
  
  EnsureConnected(frmMenu.MyConnection1);
  ExecSQLDirect(frmMenu.MyConnection1, s);
end;

procedure TfrmJabatan.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

procedure TfrmJabatan.cxButton1Click(Sender: TObject);
begin
  try
    if edtKode.Text = '' then
    begin
      MessageDlg('Kode harus di isi',mtWarning, [mbOK],0);
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

procedure TfrmJabatan.cxButton8Click(Sender: TObject);
begin
  Release;
end;

procedure TfrmJabatan.cxButton2Click(Sender: TObject);
begin
  try
    if edtKode.Text = '' then
    begin
      MessageDlg('Kode harus di isi',mtWarning, [mbOK],0);
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

procedure TfrmJabatan.edtKodeExit(Sender: TObject);
begin
  loaddata(edtKode.Text);
end;

end.
