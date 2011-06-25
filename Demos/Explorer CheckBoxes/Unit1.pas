unit Unit1;

(*WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
  This demo shows how to synchronize checkboxes between the VETree and the
VEListview. It tries to mimic the behavior of the MS Backup utility.
  Based on robleen1's and Jim Kueneman's demo.

  Rules:
  - When a VETree node is checked/unchecked it will try to sync the
    changes in the VEListview. It'll work with checked/unchecked/mixed.
    For example: if you are currently browsing the Desktop and you check
    "Drive C" node in the VETree (don't change the dir, just check it) then
    you'll see a mixed state in the "My Computer" node under the VETListview.
    Pretty cool, eh?
  - When a VETree node is expanded all it's children will be updated.
  - When a VEListview node is checked/unchecked it will try to sync the
    changes in the VETree. It'll work with checked/unchecked/mixed.
    For example: select "Drive C" in the VETree without expanding it, now in
    the VEListview select a folder, for example "Windows", you'll see a mixed
    state in the "Drive C" under the VETree (even though it's not expanded).
    Pretty cool, eh? :D
  - When you browse a folder with VEListview by double-clicking a node or
    pressing Backspace to go up a level the VEListview will be automatically
    synched with it's corresponding node in the VETree.

  To store the checked nodes to a file use the "Write Tree" button, only the
  VETree checked nodes are saved because they are all that we need.
  To retrieve the checked nodes from a file use the "Read Tree" button.
  The "Checked" and "Resolved" buttons will scan the VETree and show you all
  the checked folders out in the Memo box.
  Use the "Set Paths" button to check a node FROM the Memo box, simply type in
  a valid folder path and when you click that button the folder will be checked
  in the Tree, now how cool is that?

WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, VirtualExplorerTree, MPShellUtilities, StdCtrls,
  ExtCtrls, Buttons, ComCtrls, InfoForm, VirtualCheckboxesSynchronizer;

type
  TForm1 = class(TForm)
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    Panel5: TPanel;
    ReadTreeFileBtn: TButton;
    CheckBoxTreeInfo: TCheckBox;
    WriteTreeFileBtn: TButton;
    GetTreeCheckedBtn: TButton;
    GetTreeResolvedBtn: TButton;
    SetTreeBtn: TButton;
    TreeMemo: TMemo;
    SysTree: TVirtualExplorerTreeview;
    SysList: TVirtualExplorerListview;
    CheckBoxListInfo: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure WriteFileBtnClick(Sender: TObject);
    procedure ReadFileBtnClick(Sender: TObject);
    procedure SetPathsButtonClick(Sender: TObject);
    procedure GetAllCheckedPathsButtonClick(Sender: TObject);
    procedure GetResolvedPathsButtonClick(Sender: TObject);
    procedure CheckBoxTreeInfoClick(Sender: TObject);
    procedure CheckBoxListInfoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SysTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure SysListChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    VCS: TVirtualCheckboxesSynchronizer;
    TreeInfo: TFormInfo;
    ListInfo: TFormInfo;
    procedure BuildTree;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
//{$R winxp.res}

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Form }

procedure TForm1.BuildTree;
var
  MyComputer: PVirtualNode;
begin
  SysTree.BeginUpdate;
  try
    SysList.Active := True;
    SysTree.Active := True;
    MyComputer := SysTree.FindNodeByPIDL(DrivesFolder.AbsolutePIDL);
    if MyComputer <> nil then
      SysTree.Expanded[MyComputer] := true;
  finally
    SysTree.EndUpdate;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  VCS := TVirtualCheckboxesSynchronizer.Create(Self);
  VCS.VirtualExplorerTreeview := SysTree;
  VCS.VirtualExplorerListview := SysList;

  ListInfo := TFormInfo.Create(Form1);
  TreeInfo := TFormInfo.Create(Form1);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  BuildTree;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  VCS.Free;
  ListInfo.Free;
  TreeInfo.Free;
end;

procedure TForm1.CheckBoxTreeInfoClick(Sender: TObject);
var
  NS: TNamespace;
Begin
  TreeInfo.Visible := CheckBoxTreeInfo.Checked;
  If SysTree.ValidateNamespace(SysTree.GetFirstSelected, NS) And CheckBoxTreeInfo.Checked Then
    TreeInfo.UpdateInfo(NS);
end;

procedure TForm1.CheckBoxListInfoClick(Sender: TObject);
var
  NS: TNamespace;
Begin
  ListInfo.Visible := CheckBoxListInfo.Checked;
  If SysList.ValidateNamespace(SysList.GetFirstSelected, NS) And CheckBoxListInfo.Checked Then
    ListInfo.UpdateInfo(NS);
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Storage }

procedure TForm1.WriteFileBtnClick(Sender: TObject);
begin
  ViewManager.Snapshot('SysTree Checks', SysTree);
  ViewManager.SaveToFile('Tree.dat');
end;

procedure TForm1.ReadFileBtnClick(Sender: TObject);
begin
  ViewManager.LoadFromFile('Tree.dat');
  ViewManager.ShowView('SysTree Checks', SysTree);
  VCS.UpdateListView;
end;

procedure TForm1.SetPathsButtonClick(Sender: TObject);
begin
  VCS.SetCheckedFileNames(TreeMemo.Lines);
end;

procedure TForm1.GetAllCheckedPathsButtonClick(Sender: TObject);
begin
  VCS.GetCheckedFileNames(TreeMemo.Lines);
end;

procedure TForm1.GetResolvedPathsButtonClick(Sender: TObject);
begin
  VCS.GetResolvedFileNames(TreeMemo.Lines);
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ SysTree}

procedure TForm1.SysTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NS: TNamespace;
begin
  If SysTree.ValidateNamespace(SysTree.GetFirstSelected, NS) And CheckBoxTreeInfo.Checked Then
    TreeInfo.UpdateInfo(NS);
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ SysList }

procedure TForm1.SysListChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NS: TNamespace;
begin
  If SysList.ValidateNamespace(SysList.GetFirstSelected, NS) and CheckBoxListInfo.Checked Then
    ListInfo.UpdateInfo(NS);
end;

end.

