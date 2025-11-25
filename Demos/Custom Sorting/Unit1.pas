unit Unit1;

//
// Note there is no linking between the Tree and the List.  We
// have to use the EnumFolder to make sure that the header is correct
// in Details mode, just don't allow any of the items.
//
// The items are filled using FindFirst/FindNext enumeration and sorted
// via the OnItemCompare method.  Note the calls to Begin/EndUpdate.  These
// are critical to make sure that the OnItemCompare event is not called when
// the new item is created and before the Namespace parameter is assigned.
//

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MPCommonObjects, EasyListview, VirtualExplorerEasyListview,
  VirtualTrees, ShlObj, VirtualExplorerTree, MPShellUtilities,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    VirtualExplorerTreeview1: TVirtualExplorerTreeview;
    VirtualExplorerEasyListview1: TVirtualExplorerEasyListview;
    Panel2: TPanel;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    StatusBar1: TStatusBar;
    procedure VirtualExplorerTreeview1FocusChanged(
      Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    function VirtualExplorerEasyListview1ItemCompare(
      Sender: TCustomEasyListview; Column: TEasyColumn; Group: TEasyGroup;
      Item1, Item2: TEasyItem; var DoDefault: Boolean): Integer;
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure VirtualExplorerEasyListview1EnumFolder(
      Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace;
      var AllowAsChild: Boolean);
  private
    function GetCurrentDirectory: String;
  private
    { Private-Deklarationen }
    property CurrentDirectory: String read GetCurrentDirectory;
    function AddFiles(ADirectory: String): Integer;
    procedure AddFile(AFile: String);
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.AddFile(AFile: String);
var
  NS: TNamespace;
  PIDL: PItemIDList;
  oItem: TExplorerItem;
begin
  PIDL := PathToPIDL(AFile);
  if Assigned(PIDL) then
  begin
    NS := TNamespace.Create(PIDL, nil);
    // This Crashes because oItem.Namespace is not already assigned
    oItem := VirtualExplorerEasyListview1.Groups[0].Items.AddCustom(TExplorerItem) as TExplorerItem;
    oItem.Namespace := NS;
  end;
end;

function TForm1.AddFiles(ADirectory: String): Integer;
var
  SR: TSearchRec;
begin
  Result := 0;
  ADirectory := IncludeTrailingPathDelimiter(ADirectory);
  VirtualExplorerEasyListview1.BeginUpdate;
  try
    if SysUtils.FindFirst(ADirectory + '*.*', faAnyFile, SR) = 0 then
    begin
      repeat
        if ((SR.Attr and (faDirectory or faVolumeID)) = 0) and (SR.Name<>'.') and (SR.Name<>'..') then
        begin
          AddFile(ADirectory + SR.Name);
          Inc(Result)
        end;
      until SysUtils.FindNext(SR)<>0;
      SysUtils.FindClose(SR);
    end;
  finally
    VirtualExplorerEasyListview1.EndUpdate;
  end
end;

procedure TForm1.VirtualExplorerTreeview1FocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  VirtualExplorerEasyListview1.Clear;
  VirtualExplorerEasyListview1.Rebuild;
  StatusBar1.Panels[0].Text := 'File Objects Found = ' + IntToStr(AddFiles(CurrentDirectory))
end;

function TForm1.VirtualExplorerEasyListview1ItemCompare(
  Sender: TCustomEasyListview; Column: TEasyColumn; Group: TEasyGroup;
  Item1, Item2: TEasyItem; var DoDefault: Boolean): Integer;
begin
  // Not sure if this is Unicode enabled
  Result := CompareText(Item1.Captions[Column.Index], Item2.Captions[Column.Index]);
  if Column.SortDirection = esdDescending then
    Result := -Result
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    VirtualExplorerEasyListview1.OnItemCompare := VirtualExplorerEasyListview1ItemCompare
  else
    VirtualExplorerEasyListview1.OnItemCompare := nil;
  VirtualExplorerEasyListview1.Clear;
  AddFiles(CurrentDirectory);
end;

function TForm1.GetCurrentDirectory: String;
var
  NS: TNamespace;
begin
  if VirtualExplorerTreeview1.ValidateNamespace(VirtualExplorerTreeview1.GetFirstSelected, NS) then
    Result := NS.NameParseAddress
  else
    Result := '';
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  VirtualExplorerEasyListview1.View := TEasyListStyle(ComboBox1.ItemIndex)
end;

procedure TForm1.VirtualExplorerEasyListview1EnumFolder(
  Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace;
  var AllowAsChild: Boolean);
begin
  AllowAsChild := False
end;

end.
