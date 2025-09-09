unit uModuleConnection;

interface

uses

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SqlExpr ,Menus, DBXpress, DB, ComCtrls,
  StdCtrls, AdvCGrid,StrUtils, ExtCtrls, grids,DBClient,Provider,DBAdvGrd,
  Math, IBQuery,cxLookupEdit, cxDBLookupEdit,cxCustomPivotGrid,
  cxDBExtLookupComboBox,cxgrid,cxGridDBTableView,cxGridFilterHelpers,cxCustomData,cxDBPivotGrid, 
  OleServer, ExcelXP,printers,WinSpool,DBGrids,cxDropDownEdit,cxCurrencyEdit,cxCalendar,cxExportPivotGridLink,
  cxGridExportLink,cxFilter,cxGridTableView,cxGridCustomTableView, MyAccess, DBAccess, MemDS;  // unit MyDAC;

type
  TCDS = class(TClientDataSet)
  private

  public
  end;
  TConextMain = class(TObject)
   private
  public
    class function cOpenCDS(AQuery: string; aOwner: TComponent = nil)
      : TCDS; overload;
  end;





 TcxDBGridHelper = class(TcxGridDBTableView)
  private
  public
    procedure AutoFormatCurrency(ADisplayFormat: String = ',0;(,0)');
    procedure AutoFormatDate(ADisplayFormat: String = 'yyyy/mm/dd');

    procedure ExportToXLS(sFileName: String = ''; DoShowInfo: Boolean = True);
    function GetFooterSummary(sFieldName : String): Variant; overload;
    function GetFooterSummary(aColumn: TcxGridDBColumn): Variant; overload;
    procedure LoadFromCDS(ACDS: TClientDataSet; AutoFormat: Boolean = True;
        DoBestFit: Boolean = True);
    procedure LoadFromSQL(aSQL: String; aOwner: TComponent);
    procedure SetAllUpperCaseColumn;
    procedure SetColumnsCaption(ColumnSets, ColumnCaption: Array Of String);
    procedure SetSummaryByColumns(ColumnSets: Array Of String; SummaryKind:
        TcxSummaryKind = skSum; SFormat: String = ',0;(,0)');
    procedure SetDetailKeyField(aKeyField: String);
    procedure SetMasterKeyField(aKeyField: String);
    procedure SetReadOnly(IsReadOnly: Boolean);
    procedure SetVisibleColumns(ColumnSets: Array Of String; IsVisible: Boolean);
        overload;
    procedure SetColumnsWidth(ColumnSets: Array Of String; Widths: Array Of
        Integer); overload;
    procedure SetExtLookupCombo(ExtLookup: TcxExtLookupComboBox; IDField,
        DisplayField: String; HideIDField: Boolean = True); overload;
    procedure SetExtLookupCombo(ExtLookupProp: TcxExtLookupComboBoxProperties;
        IDField, DisplayField: String; HideIDField: Boolean = True); overload;
  end;

TcxDBPivotHelper = class(TcxDBPivotGrid)
public
     procedure ExportToXLS(ExpandAll: Boolean = True; sFileName: String = '';
         DoShowInfo: Boolean = True);
     procedure LoadFromCDS(ACDS: TClientDataSet; ExpandAll: Boolean = True;
         ReCreateAllItem: Boolean = True);
     procedure SetAllUpperCaseColumn;
     procedure SetColColumns(ColumnSets: Array Of String);
     procedure SetColumnsCaption(ColumnSets, ColumnCaption: Array Of String);
     procedure SetColumnsWidth(ColumnSets: Array Of String; Widths: Array Of
         Integer); overload;
     procedure SetDataColumns(ColumnSets: Array Of String);
     procedure SetRowColumns(ColumnSets: Array Of String); overload;
     procedure SetVisibleColumns(ColumnSets: Array Of String; IsVisible: Boolean);
end;



function cOpenCDS(AQuery: string; AOwner: TComponent = nil):TCDS;
function xOpenQuery(aSQL: string; out RecCount: Integer; aMyConn: TMyConnection = nil): TMyQuery;
function cekedit(akodeuser:string;anamaform:string) : Boolean;
function cekview(akodeuser:string;anamaform:string) : Boolean;
function cekinsert(akodeuser:string;anamaform:string) : Boolean;
function cekdelete(akodeuser:string;anamaform:string) : Boolean;
function QuotD(aDate : TDateTime; aTambahJam235959 : Boolean = false): String;
function Quot(aString : String) : String;
function ExecSQLDirect(AConnection: TMyConnection; const ASQL: string): Integer;
procedure EnsureConnected(AConn: TMyConnection);
function cGetReportPath: String;
function cGetServerTime: TDateTime;
procedure zAddField(aDataset: TDataSet; AFieldName: string;
  aFieldType: TFieldType; aIsCalculated: Boolean = false; aLength: Integer = 0;
  aDispFormat: String = '##,##0.00;(##,##0.00)');


implementation
uses ufrmMenu;
procedure TcxDBGridHelper.AutoFormatCurrency(ADisplayFormat: String =
    ',0;(,0)');
var
  i: Integer;
  lDS: TDataSet;
begin
  lDS := Self.DataController.DataSource.DataSet;

  //why use DS, because sometime format CDS <> grid.column.format
  for i := 0 to lDS.FieldCount-1 do
  begin
    If not Assigned(Self.GetColumnByFieldName(lDS.Fields[i].FieldName)) then
      continue;
    with Self.GetColumnByFieldName(lDS.Fields[i].FieldName) do
    begin
      If lDS.Fields[i].DataType = ftFloat then
      begin
        PropertiesClassName := 'TcxCurrencyEditProperties';
        TcxCurrencyEditProperties( Properties).DisplayFormat := ADisplayFormat;
        TcxCurrencyEditProperties( Properties).Alignment.Horz := taRightJustify;
        DataBinding.ValueType := 'Float';
      end;
    end;
  end;
end;

procedure TcxDBGridHelper.AutoFormatDate(ADisplayFormat: String =
    'yyyy/mm/dd');
var
  i: Integer;
  lDS: TDataSet;
begin
  lDS := Self.DataController.DataSource.DataSet;

  //why use DS, because sometime format CDS <> grid.column.format
  for i := 0 to lDS.FieldCount-1 do
  begin
    If not Assigned(Self.GetColumnByFieldName(lDS.Fields[i].FieldName)) then
      continue;
    with Self.GetColumnByFieldName(lDS.Fields[i].FieldName) do
    begin
      If lDS.Fields[i].DataType in [ftDate, ftDateTime] then
      begin
        PropertiesClassName := 'TcxDateEditProperties';
        TcxDateEditProperties( Properties).DisplayFormat := ADisplayFormat;
        TcxDateEditProperties( Properties).EditMask := ADisplayFormat;
        DataBinding.ValueType := 'DateTime';
      end;
    end;
  end;
end;

procedure TcxDBGridHelper.ExportToXLS(sFileName: String = ''; DoShowInfo:
    Boolean = True);
var
  DoSave: Boolean;
  lSaveDlg: TSaveDialog;
begin
  DoSave := True;
  If sFileName = '' then
  begin
    lSaveDlg := TSaveDialog.Create(nil);
    Try
      if lSaveDlg.Execute then
        sFileName := lSaveDlg.FileName
      else
        DoSave := False;
    Finally
      lSaveDlg.Free;
    End;
  end;

  If DoSave then
  begin
    Try
      ExportGridToExcel(sFileName, TcxGrid(Self.Control));
      If DoSHowInfo then ShowMessage('Data berhasil diexport ke: ' + sFileName);
    except
      If DoSHowInfo then ShowMessage('Gagal menyimpan data ke excel');
    end;
  end;
end;

function TcxDBGridHelper.GetFooterSummary(aColumn: TcxGridDBColumn): Variant;
var
  i: Integer;
begin
  Result := Null;

  with Self.DataController.Summary do
  begin
    for i :=0 to FooterSummaryItems.Count-1 do
    begin
//      If FooterSummaryItems.Items[i].ItemLink.ClassName <> aColumn.ClassName then
//        continue;
      If FooterSummaryItems.Items[i].ItemLink = aColumn then
        Result := FooterSummaryValues[i];
    end;
  end;
end;

function TcxDBGridHelper.GetFooterSummary(sFieldName : String): Variant;
//var
//  i: Integer;
begin
  Result := Self.GetFooterSummary(Self.GetColumnByFieldName(sFieldName));
end;

procedure TcxDBGridHelper.LoadFromCDS(ACDS: TClientDataSet; AutoFormat: Boolean
    = True; DoBestFit: Boolean = True);
begin
  If not Assigned(Self.DataController.DataSource) then
  begin
    Self.DataController.DataSource := TDataSource.Create(Self);
  end;
  Self.DataController.DataSource.DataSet := ACDS;
  Self.DataController.CreateAllItems(True);

  if AutoFormat then
  begin
    AutoFormatDate;
    AutoFormatCurrency;
    SetAllUpperCaseColumn;
  end;
  If DoBestFit then
  begin
    Self.OptionsBehavior.BestFitMaxRecordCount := 100;
    Self.ApplyBestFit;
  end;
end;

procedure TcxDBGridHelper.LoadFromSQL(aSQL: String; aOwner: TComponent);
var
  lCDS: TClientDataSet;
begin
  //method ini hanya digunakan sekali saja,
  //membuat cds sesuai owner form agar di free on destroy
  //ex digunakan utk extended lookup data master..

  If Assigned(Self.DataController.DataSource) then
    Raise Exception.Create('DataSource already created');

  lCDS := TConextMain.cOpenCDS(aSQL, aOwner);
  Self.LoadFromCDS(lCDS);
end;

procedure TcxDBGridHelper.SetAllUpperCaseColumn;
var
  i: Integer;
begin
  for i := 0 to Self.ColumnCount-1 do
  begin
    Self.Columns[i].Caption := UpperCase(Self.Columns[i].Caption);
  end;
end;

procedure TcxDBGridHelper.SetColumnsCaption(ColumnSets, ColumnCaption: Array Of
    String);
var
  i: Integer;
begin
  for i := Low(ColumnSets) to High(ColumnSets) do
  begin
    If Assigned(Self.GetColumnByFieldName(ColumnSets[i])) then
      Self.GetColumnByFieldName(ColumnSets[i]).Caption := ColumnCaption[i];
  end;
end;

procedure TcxDBGridHelper.SetSummaryByColumns(ColumnSets: Array Of String;
    SummaryKind: TcxSummaryKind = skSum; SFormat: String = ',0;(,0)');
var
  i: Integer;
begin
  If not Self.OptionsView.Footer then Self.OptionsView.Footer := True;
  for i := Low(ColumnSets) to High(ColumnSets) do
  begin
    If Assigned(Self.GetColumnByFieldName(ColumnSets[i])) then
    begin
      GetColumnByFieldName(ColumnSets[i]).Summary.FooterKind    := SummaryKind;
      GetColumnByFieldName(ColumnSets[i]).Summary.FooterFormat  := SFormat;
    end;
  end;
end;

procedure TcxDBGridHelper.SetDetailKeyField(aKeyField: String);
begin
  Self.DataController.MasterKeyFieldNames   := aKeyField ;
end;

procedure TcxDBGridHelper.SetMasterKeyField(aKeyField: String);
begin
  Self.DataController.DetailKeyFieldNames   := aKeyField ;
end;

procedure TcxDBGridHelper.SetReadOnly(IsReadOnly: Boolean);
begin
  Self.OptionsData.Editing    := not IsReadOnly;
  Self.OptionsData.Inserting  := not IsReadOnly;
  Self.OptionsData.Appending  := not IsReadOnly;
  Self.OptionsData.Deleting   := not IsReadOnly;
end;

procedure TcxDBGridHelper.SetVisibleColumns(ColumnSets: Array Of String;
    IsVisible: Boolean);
var
  i: Integer;
begin
  for i := Low(ColumnSets) to High(ColumnSets) do
  begin
    If Assigned(Self.GetColumnByFieldName(ColumnSets[i])) then
      Self.GetColumnByFieldName(ColumnSets[i]).Visible := IsVisible;
  end;
end;


procedure TcxDBGridHelper.SetColumnsWidth(ColumnSets: Array Of String; Widths:
    Array Of Integer);
var
  i: Integer;
begin
  for i := Low(ColumnSets) to High(ColumnSets) do
  begin
    If Assigned(Self.GetColumnByFieldName(ColumnSets[i])) then
      Self.GetColumnByFieldName(ColumnSets[i]).Width := Widths[i];
  end;
end;

procedure TcxDBGridHelper.SetExtLookupCombo(ExtLookup: TcxExtLookupComboBox;
    IDField, DisplayField: String; HideIDField: Boolean = True);
begin
  SetExtLookupCombo( ExtLookup.Properties , IDField, DisplayField, HideIDField);
end;

procedure TcxDBGridHelper.SetExtLookupCombo(ExtLookupProp:
    TcxExtLookupComboBoxProperties; IDField, DisplayField: String; HideIDField:
    Boolean = True);
begin
  with ExtLookupProp do
  begin
    View              := Self;
    KeyFieldNames     := IDField;
    If HideIDField then Self.SetVisibleColumns([IDField],False);
    ListFieldItem     := Self.GetColumnByFieldName(DisplayField);
    DropDownAutoSize  := True;
  end;
  ExtLookupProp.PopupAutoSize := True;
  Self.OptionsBehavior.BestFitMaxRecordCount := 0;
  Self.ApplyBestFit;
end;


function cOpenCDS(AQuery: string; AOwner: TComponent = nil):
    TCDS;
var
  LDSP: TDataSetProvider;
  LMyQuery: TMyQuery;
begin
  Result    := TCDS.Create(AOwner);
  LDSP      := TDataSetProvider.Create(Result);
  LMyQuery  := TMyQuery.Create(LDSP);
  try
    EnsureConnected(frmMenu.MyConnection1);
    LMyQuery.Connection := frmMenu.MyConnection1; // koneksi MyDAC
    LMyQuery.SQL.Text   := AQuery;

    LDSP.DataSet := LMyQuery;
    Result.SetProvider(LDSP);
    Result.Open;
  except
    on E: Exception do
    begin
      MessageDlg('Open ClientDataset Failed. Check your Query!' + #13 + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function xOpenQuery(aSQL: string; out RecCount: Integer; aMyConn: TMyConnection = nil): TMyQuery;
begin
  Result := TMyQuery.Create(nil);
  RecCount := 0;

  if (UpperCase(LeftStr(aSQL,6)) <> 'SELECT') and (Length(Trim(aSQL)) = 0) then
  begin
    FreeAndNil(Result);
    Exit;
  end;

  with Result do
  begin
      EnsureConnected(aMyConn);
      // frmMenu.MyConnection1.Connected;
      Connection := aMyConn;   // default koneksi MyDAC


    SQL.Text := aSQL;
    try
      Open;
      First;
      while not Eof do
      begin
        Inc(RecCount);
        Next;
      end;
      First;
    except
      FreeAndNil(Result);
    end;
  end;

end;


procedure TcxDBPivotHelper.ExportToXLS(ExpandAll: Boolean = True; sFileName:
    String = ''; DoShowInfo: Boolean = True);
var
  DoSave: Boolean;
  lSaveDlg: TSaveDialog;
begin
  DoSave := True;
  If sFileName = '' then
  begin
    lSaveDlg := TSaveDialog.Create(nil);
    Try
      if lSaveDlg.Execute then
        sFileName := lSaveDlg.FileName
      else
        DoSave := False;
    Finally
      lSaveDlg.Free;
    End;
  end;

  If DoSave then
  begin
    Try
      cxExportPivotGridToExcel(sFileName, Self, ExpandAll);
      If DoShowInfo then ShowMessage('Data berhasil diexport ke: ' + sFileName);
    except
      If DoShowInfo then ShowMessage('Gagal menyimpan data ke excel');
    end;
  end;
end;

procedure TcxDBPivotHelper.LoadFromCDS(ACDS: TClientDataSet; ExpandAll: Boolean
    = True; ReCreateAllItem: Boolean = True);
var
  i: Integer;
begin
  if not Assigned(Self.DataSource) then
    Self.DataSource := TDataSource.Create(Self);
  Self.DataSource.DataSet := ACDS;

  If ReCreateAllItem then
  begin
    Self.DeleteAllFields;
    Self.CreateAllFields;
  end;

  for i:=0 to Self.FieldCount-1 do
  begin
    if AnsiMatchStr(Self.Fields[i].DataBinding.ValueType ,['Float','Currency']) then
    begin
      Self.Fields[i].PropertiesClass := TcxCurrencyEditProperties;
      TcxCurrencyEditProperties(Self.fields[i].Properties).DisplayFormat := ',0;(,0)';
      TcxCurrencyEditProperties(Self.fields[i].Properties).ReadOnly := True;
    end;
    If ExpandAll then Self.Fields[i].ExpandAll;
  end;
  SetAllUpperCaseColumn;
end;

procedure TcxDBPivotHelper.SetAllUpperCaseColumn;
var
  i: Integer;
begin
  for i := 0 to Self.FieldCount-1 do
  begin
    Self.Fields[i].Caption := UpperCase(Self.Fields[i].Caption);
  end;
end;

procedure TcxDBPivotHelper.SetColColumns(ColumnSets: Array Of String);
var
  i: Integer;
begin
  for i := Low(ColumnSets) to High(ColumnSets) do
  begin
    If Assigned(Self.GetFieldByName(ColumnSets[i])) then
      Self.GetFieldByName(ColumnSets[i]).Area := faColumn;
  end;
end;

procedure TcxDBPivotHelper.SetColumnsCaption(ColumnSets, ColumnCaption: Array
    Of String);
var
  i: Integer;
begin
  for i := Low(ColumnSets) to High(ColumnSets) do
  begin
    If Assigned(Self.GetFieldByName(ColumnSets[i])) then
      Self.GetFieldByName(ColumnSets[i]).Caption := ColumnCaption[i];
  end;
end;

procedure TcxDBPivotHelper.SetColumnsWidth(ColumnSets: Array Of String; Widths:
    Array Of Integer);
var
  i: Integer;
begin
  for i := Low(ColumnSets) to High(ColumnSets) do
  begin
    If Assigned(Self.GetFieldByName(ColumnSets[i])) then
      Self.GetFieldByName(ColumnSets[i]).Width := Widths[i];
  end;
end;

procedure TcxDBPivotHelper.SetDataColumns(ColumnSets: Array Of String);
var
  i: Integer;
begin
  for i := Low(ColumnSets) to High(ColumnSets) do
  begin
    If Assigned(Self.GetFieldByName(ColumnSets[i])) then
      Self.GetFieldByName(ColumnSets[i]).Area := faData;
  end;
end;

procedure TcxDBPivotHelper.SetRowColumns(ColumnSets: Array Of String);
var
  i: Integer;
begin
  for i := Low(ColumnSets) to High(ColumnSets) do
  begin
    If Assigned(Self.GetFieldByName(ColumnSets[i])) then
      Self.GetFieldByName(ColumnSets[i]).Area := faRow;
  end;
end;

procedure TcxDBPivotHelper.SetVisibleColumns(ColumnSets: Array Of String;
    IsVisible: Boolean);
var
  i: Integer;
begin
  for i := Low(ColumnSets) to High(ColumnSets) do
  begin
    If Assigned(Self.GetFieldByName(ColumnSets[i])) then
      Self.GetFieldByName(ColumnSets[i]).Hidden := not IsVisible;
  end;
end;



function cekedit(akodeuser:string;anamaform:string) : Boolean;
var
  s: string;
  tsql : TMyQuery;
  arc:Integer;
begin
  Result:= False;
  s:= ' select hak_men_edit from tuser a inner join thakuser  b on a.user =b.hak_user_kode '
    + ' inner join tmenu c on c.men_id =b.hak_men_id '
    + ' where a.user='+ Quot(akodeuser)
    + ' and c.men_nama = ' + Quot(anamaform) ;
  tsql := xOpenQuery(s,arc,frmMenu.MyConnection1);
  with tsql do
  begin
   try
    if Fields[0].AsString = 'Y' then
       Result := True;
   finally
    free;
   end;
  end;
end;

function cekview(akodeuser:string;anamaform:string) : Boolean;
var
  s: string;
  tsql : TMyQuery;
    arc:Integer;
begin
  Result:= False;
  anamaform := Copy(anamaform,2,Length(anamaform));
  anamaform := StringReplace(anamaform,'Browse','',[rfReplaceAll]);

  s:= ' select "Y" hak_men_view from tuser a inner join thakuser  b on a.user =b.hak_user_kode '
    + ' inner join tmenu c on c.men_id =b.hak_men_id '
    + ' where a.user='+ Quot(akodeuser)
    + ' and c.men_nama = ' + Quot(anamaform) ;
  tsql := xOpenQuery(s,arc,frmMenu.MyConnection1);
  with tsql do
  begin
   try
    if Fields[0].AsString = 'Y' then
       Result := True;
   finally
    free;
   end;
  end;
end;

function cekinsert(akodeuser:string;anamaform:string) : Boolean;
var
  s: string;
  tsql : TmyQuery;
    arc:Integer;
begin
  Result:= False;
  s:= ' select hak_men_insert from tuser a inner join thakuser  b on a.user =b.hak_user_kode '
    + ' inner join tmenu c on c.men_id =b.hak_men_id '
    + ' where a.user='+ Quot(akodeuser)
    + ' and c.men_nama = ' + Quot(anamaform)  ;
  tsql := xOpenQuery(s,arc,frmMenu.MyConnection1);
  with tsql do
  begin
   try
    if Fields[0].AsString = 'Y' then
       Result := True;
   finally
     free;
   end;
  end;
end;

function cekdelete(akodeuser:string;anamaform:string) : Boolean;
var
  s: string;
  tsql : TmyQuery;
    arc:Integer;
begin
  Result:= False;
  s:= ' select hak_men_delete from tuser a inner join thakuser  b on a.user = b.hak_user_kode'
    + ' inner join tmenu c on c.men_id = b.hak_men_id '
    + ' where a.user ='+ Quot(akodeuser)
    + ' and c.men_nama = ' + Quot(anamaform);
    
  tsql := xOpenQuery(s,arc,frmMenu.MyConnection1);
  with tsql do
  begin
   try
    if Fields[0].AsString = 'Y' then
       Result := True;
   finally
     free;
   end;
  end;
end;

function QuotD(aDate : TDateTime; aTambahJam235959 : Boolean = false): String;
begin
    if not aTambahJam235959 then
    begin
         result := Quot(FormatDateTime('yyyy/mm/dd', aDate));
    end else
    begin
        result := Quot(FormatDateTime('yyyy-mm-dd hh:nn:ss', aDate));
    end;
end;
function Quot(aString : String) : String;
begin
    result := QuotedSTr(trim(Astring));
end;

function ExecSQLDirect(AConnection: TMyConnection; const ASQL: string): Integer;
var
  Q: TMyQuery;
begin
  Result := 0;
  Q := TMyQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text := ASQL;
    Q.ExecSQL;
    Result := Q.RowsAffected; // kalau INSERT/UPDATE/DELETE akan return jumlah row
  finally
    Q.Free;
  end;
end;

procedure EnsureConnected(AConn: TMyConnection);
var
  Retry: Integer;
begin
  if (AConn = nil) then Exit;

  if not AConn.Connected then
  begin
    Retry := 0;
    while Retry < 3 do
    begin
      try
        AConn.Connect;
        Exit;
      except
        Inc(Retry);
        Sleep(1000);
      end;
    end;
    raise Exception.Create('Gagal konek ke database setelah retry');
  end
  else
  begin
    try
      AConn.Ping;
    except
      if AConn.Connected then
        AConn.Disconnect;

      Retry := 0;
      while Retry < 3 do
      begin
        try
          Sleep(1000);
          AConn.Connect;
          Exit;
        except
          Inc(Retry);
        end;
      end;
      raise Exception.Create('Koneksi database terputus dan gagal reconnect');
    end;
  end;
end;

function cGetReportPath: String;
 var
 ltemp : TStringList;

 begin

 ltemp := TStringList.Create;
 ltemp.loadfromfile(ExtractFileDir(application.ExeName) + '\' + 'default.cfg');
 Result :=  ltemp[4];
 ltemp.free;
 end;

function cGetServerTime: TDateTime;
var
    S: string;
    arec:integer;
begin
    S := 'Select now()';
    with xOpenQuery(S,arec,frmMenu.MyConnection1) do
    begin
         Result := fields[0].AsDateTime;
         free;
    end;

end;
procedure zAddField(aDataset: TDataSet; AFieldName: string;
  aFieldType: TFieldType; aIsCalculated: Boolean = false; aLength: Integer = 0;
  aDispFormat: String = '##,##0.00;(##,##0.00)');
var
  DTF: TDateTimeField;
  SF: TStringField;
  BF: TBlobField;
  BL: TBooleanField;
  FF: TFloatField;
  MF: TMemoField;
  F: TField;
begin
  Case aFieldType of
    ftDateTime:
      begin
        DTF := TDateTimeField.Create(aDataset);
        // make sure we get a unique component name
        DTF.Name := Format(aDataset.Name + 'col' + AFieldName + '%d',
          [Integer(DTF)]);
        DTF.FieldName := AFieldName;
        DTF.DataSet := aDataset;
        DTF.Calculated := aIsCalculated;
      end;
    ftDate:
      begin
        DTF := TDateField.Create(aDataset);
        // make sure we get a unique component name
        DTF.Name := Format(aDataset.Name + 'col' + AFieldName + '%d',
          [Integer(DTF)]);
        DTF.FieldName := AFieldName;
        DTF.DataSet := aDataset;
        DTF.Calculated := aIsCalculated;
      end;
    ftString:
      begin
        SF := TStringField.Create(aDataset);
        SF.Name := Format(aDataset.Name + 'col' + AFieldName + '%d',
          [Integer(SF)]);
        SF.FieldName := AFieldName;
        SF.Size := aLength;
        SF.DataSet := aDataset;
        SF.Calculated := aIsCalculated;
      end;
    ftBlob:
      begin
        BF := TBlobField.Create(aDataset);
        BF.Name := Format(aDataset.Name + 'col' + AFieldName + '%d',
          [Integer(BF)]);
        BF.FieldName := AFieldName;
        BF.DataSet := aDataset;
        BF.Calculated := aIsCalculated;
      end;
    ftFloat:
      begin
        FF := TFloatField.Create(aDataset);
        FF.Name := Format(aDataset.Name + 'col' + AFieldName + '%d',
          [Integer(FF)]);
        FF.FieldName := AFieldName;
        // FF.Size           := aLength;
        FF.DataSet := aDataset;
        FF.Calculated := aIsCalculated;
        FF.DisplayFormat := aDispFormat;
      end;
    ftMemo:
      begin
        MF := TMemoField.Create(aDataset);
        MF.Name := Format(aDataset.Name + 'col' + AFieldName + '%d',
          [Integer(MF)]);
        MF.FieldName := AFieldName;
        MF.Size := aLength;
        MF.DataSet := aDataset;
        MF.Calculated := aIsCalculated;
      end;
    ftSmallInt, ftInteger:
      begin
        F := TIntegerField.Create(aDataset);
        TIntegerField(F).Name := Format(aDataset.Name + 'col' + AFieldName +
          '%d', [Integer(TIntegerField(F))]);
        TIntegerField(F).FieldName := AFieldName;
        // TIntegerField(F).Size           := aLength;
        TIntegerField(F).DataSet := aDataset;
        TIntegerField(F).Calculated := aIsCalculated;
      end;
    ftBoolean:
      begin
        BL := TBooleanField.Create(aDataset);
        BL.Name := Format(aDataset.Name + 'col' + AFieldName +
          '%d', [Integer(BL)]);
        BL.FieldName := AFieldName;
        BL.DataSet := aDataset;
        BL.Index  := aDataSet.FieldCount;
        BL.Calculated := aIsCalculated;
      end;
  end;
end;
class function TConextMain.cOpenCDS(AQuery: string;
  aOwner: TComponent = nil): TCDS;
var
  LDSP: TDataSetProvider;
  LMyQuery: TMyQuery;
begin
  Result    := TCDS.Create(AOwner);
  LDSP      := TDataSetProvider.Create(Result);
  LMyQuery  := TMyQuery.Create(LDSP);
  try
    EnsureConnected(frmMenu.MyConnection1);
    LMyQuery.Connection := frmMenu.MyConnection1; // koneksi MyDAC
    LMyQuery.SQL.Text   := AQuery;

    LDSP.DataSet := LMyQuery;
    Result.SetProvider(LDSP);
    Result.Open;
  except
    on E: Exception do
    begin
      MessageDlg('Open ClientDataset Failed. Check your Query!' + #13 + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

end.

