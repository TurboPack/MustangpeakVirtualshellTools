unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, VirtualExplorerTree, MPcommonObjects,
  VirtualFileSearch, StdCtrls,  ComCtrls, ExtCtrls,
  MPShellUtilities, EasyListview, VirtualExplorerEasyListview, ShlObj;

type
  TForm1 = class(TForm)
    VirtualExplorerTreeview1: TVirtualExplorerTreeview;
    VirtualFileSearch1: TVirtualFileSearch;
    Button1: TButton;
    TntLabel1: TLabel;
    TntMemoCriteria: TMemo;
    CheckBoxArchive: TCheckBox;
    CheckBoxCaseSensitive: TCheckBox;
    CheckBoxCompressed: TCheckBox;
    CheckBoxHidden: TCheckBox;
    CheckBoxNormal: TCheckBox;
    CheckBoxOffline: TCheckBox;
    CheckBoxReadOnly: TCheckBox;
    CheckBoxSubFolders: TCheckBox;
    CheckBoxSystem: TCheckBox;
    CheckBoxTemporary: TCheckBox;
    Label1: TLabel;
    CheckBoxEncrypted: TCheckBox;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CheckBoxAnimateProgress: TCheckBox;
    Button2: TButton;
    VirtualMultiPathExplorerEasyListview1: TVirtualMultiPathExplorerEasyListview;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VirtualExplorerTreeview1EnumFolder(Sender: TCustomVirtualExplorerTree; Namespace: TNamespace; var AllowAsChild: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ComboBox1Change(Sender: TObject);
    procedure VirtualFileSearch1SearchEnd(Sender: TObject; Results: TCommonPIDLList);
    procedure Button2Click(Sender: TObject);
    procedure VirtualMultiPathExplorerEasyListview1SortBegin(
      Sender: TCustomEasyListview);
    procedure VirtualMultiPathExplorerEasyListview1SortEnd(
      Sender: TCustomEasyListview);
    procedure VirtualMultiPathExplorerEasyListview1Scroll(
      Sender: TCustomEasyListview; DeltaX, DeltaY: Integer);
    procedure VirtualFileSearch1Progress(Sender: TObject; Results: TCommonPIDLList; var Handled, FreePIDLs: Boolean);
  private
    { Private declarations }
    FAnimateIndex: Integer;
    FPriority: TThreadPriority;
    FStartTime: Cardinal;
    FFileCount: Integer;
  public
    { Public declarations }
    procedure LoadListview(PIDLs: TCommonPIDLList);
    property AnimateIndex: Integer read FAnimateIndex write FAnimateIndex;
    property Priority: TThreadPriority read FPriority write FPriority;
    property StartTime: Cardinal read FStartTime write FStartTime;
    property FileCount: Integer read FFileCount write FFileCount;
  published
  end;

var
  Form1: TForm1;
  Animate: array[0..15] of string = ('.', '..', '...', '...', '....', '.....', '......', '.......', '........', '.........', '..........', '...........', '............', '.............', '..............', '...............');

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  VirtualFileSearch1.SearchPaths.Clear;
  VirtualFileSearch1.SearchPaths.Assign(VirtualExplorerTreeview1.SelectedPaths);
  VirtualFileSearch1.SearchCriteriaFilename.Clear;
  VirtualFileSearch1.SearchCriteriaFilename.Assign(TntMemoCriteria.Lines);
  VirtualFileSearch1.SearchAttribs := [];
  if CheckBoxArchive.Checked then
    VirtualFileSearch1.SearchAttribs := VirtualFileSearch1.SearchAttribs + [vsaArchive];
  if CheckBoxReadOnly.Checked then
    VirtualFileSearch1.SearchAttribs := VirtualFileSearch1.SearchAttribs + [vsaReadOnly];
  if CheckBoxCompressed.Checked then
    VirtualFileSearch1.SearchAttribs := VirtualFileSearch1.SearchAttribs + [vsaCompressed];
  if CheckBoxHidden.Checked then
    VirtualFileSearch1.SearchAttribs := VirtualFileSearch1.SearchAttribs + [vsaHidden];
  if CheckBoxNormal.Checked then
    VirtualFileSearch1.SearchAttribs := VirtualFileSearch1.SearchAttribs + [vsaNormal];
  if CheckBoxOffline.Checked then
    VirtualFileSearch1.SearchAttribs := VirtualFileSearch1.SearchAttribs + [vsaOffline];
  if CheckBoxSystem.Checked then
    VirtualFileSearch1.SearchAttribs := VirtualFileSearch1.SearchAttribs + [vsaSystem];
  if CheckBoxTemporary.Checked then
    VirtualFileSearch1.SearchAttribs := VirtualFileSearch1.SearchAttribs + [vsaTemporary];
  VirtualFileSearch1.CaseSensitive := CheckBoxCaseSensitive.Checked;
  VirtualFileSearch1.SubFolders := CheckBoxSubFolders.Checked;
  VirtualFileSearch1.UpdateRate := 50;
  VirtualMultiPathExplorerEasyListview1.BeginUpdate;
  try
    VirtualMultiPathExplorerEasyListview1.Clear;
  finally
    VirtualMultiPathExplorerEasyListview1.EndUpdate;
  end;
  Label3.Caption := 'Running!';
  Label4.Caption := '';
  Label5.Caption := '';
  StartTime := GetTickCount;
  FileCount := 0;
  VirtualFileSearch1.Run;
  Button2.Enabled := True;
  Button1.Enabled := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  VirtualExplorerTreeview1.TreeOptions.ForceMultiLevelMultiSelect := True;
  VirtualExplorerTreeview1.TreeOptions.VETMiscOptions :=
    VirtualExplorerTreeview1.TreeOptions.VETMiscOptions + [toVETReadOnly];
  VirtualExplorerTreeview1.TreeOptions.SelectionOptions :=
    VirtualExplorerTreeview1.TreeOptions.SelectionOptions + [toMultiSelect] - [toLevelSelectConstraint];
end;

procedure TForm1.VirtualExplorerTreeview1EnumFolder(
  Sender: TCustomVirtualExplorerTree; Namespace: TNamespace;
  var AllowAsChild: Boolean);
begin
  // Don't allow the Browsable Zips and such
  AllowAsChild := not Namespace.Browsable
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  VirtualFileSearch1.Stop;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  Priority := TThreadPriority( ComboBox1.ItemIndex);
end;  

procedure TForm1.VirtualFileSearch1SearchEnd(Sender: TObject;
  Results: TCommonPIDLList);
begin
  Label3.Caption := 'Done! Elapsed Search Time = '  + IntToStr(GetTickCount - StartTime) + ' ms';

  LoadListview(Results);

  FileCount := FileCount + Results.Count;
  Label4.Caption := IntToStr(FileCount) + ' items found';
  Label5.Caption := 'Blocks Allocated: ' + IntToStr(AllocMemCount) + '  Memory Allocated: ' + IntToStr(AllocMemSize);
  Results.Clear;
  Button2.Enabled := False;
  Button1.Enabled := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  VirtualFileSearch1.Stop;
  Button2.Enabled := False;
  Button1.Enabled := True;
end;

procedure TForm1.LoadListview(PIDLs: TCommonPIDLList);
var
  i: Integer;
  PIDL: PItemIDList;
begin
  VirtualMultiPathExplorerEasyListview1.BeginUpdate;
  try
    for i := 0 to PIDLs.Count - 1 do
    begin
      // The list owns the PIDLs
      PIDL := PIDLMgr.CopyPIDL(PIDLs[i]);
      VirtualMultiPathExplorerEasyListview1.AddCustomItem(nil, TNamespace.Create(PIDL, nil), True);
    end
  finally
    VirtualMultiPathExplorerEasyListview1.EndUpdate
  end;
end;

procedure TForm1.VirtualMultiPathExplorerEasyListview1SortBegin(
  Sender: TCustomEasyListview);
begin
  Label5.Caption := 'Blocks Allocated: ' + IntToStr(AllocMemCount) + '  Memory Allocated: ' + IntToStr(AllocMemSize)
end;

procedure TForm1.VirtualMultiPathExplorerEasyListview1SortEnd(
  Sender: TCustomEasyListview);
begin
  Label5.Caption := 'Blocks Allocated: ' + IntToStr(AllocMemCount) + '  Memory Allocated: ' + IntToStr(AllocMemSize)
end;

procedure TForm1.VirtualMultiPathExplorerEasyListview1Scroll(
  Sender: TCustomEasyListview; DeltaX, DeltaY: Integer);
begin
  Label5.Caption := 'Blocks Allocated: ' + IntToStr(AllocMemCount) + '  Memory Allocated: ' + IntToStr(AllocMemSize)
end;

procedure TForm1.VirtualFileSearch1Progress(Sender: TObject; Results: TCommonPIDLList; var Handled, FreePIDLs: Boolean);
begin
 if CheckBoxAnimateProgress.Checked then
  begin
    Label3.Caption := 'Running: ' + Animate[AnimateIndex];
    Inc(FAnimateIndex);
    if AnimateIndex > Length(Animate) - 1 then
      FAnimateIndex := 0;
    LoadListview(Results);
    FileCount := FileCount + Results.Count;
    Label4.Caption := IntToStr(FileCount) + ' items found so far';
    Handled := True;  // Allow the VirtualFileSearch to clear the list
    Label5.Caption := 'Blocks Allocated: ' + IntToStr(AllocMemCount) + '  Memory Allocated: ' + IntToStr(AllocMemSize)
  end
end;

end.
