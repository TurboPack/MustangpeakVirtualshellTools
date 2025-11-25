unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, VirtualExplorerTree, StdCtrls, ExtCtrls, MPShellUtilities,
  Buttons, ComCtrls;

type
  TForm1 = class(TForm)
    VET: TVirtualExplorerTreeview;
    Panel1: TPanel;
    Panel2: TPanel;
    Memo1: TMemo;
    Panel3: TPanel;
    Button4: TButton;
    Button5: TButton;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    VET1: TVirtualExplorerTree;
    Panel4: TPanel;
    Button3: TButton;
    Button6: TButton;
    ButtonHideUnchecked: TButton;
    ButtonShowAll: TButton;
    procedure VETEnumFolder(Sender: TCustomVirtualExplorerTree;
      Namespace: TNamespace; var AllowAsChild: Boolean);
    procedure FormShow(Sender: TObject);
    procedure VETInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure VET1InitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure Button6Click(Sender: TObject);
    procedure ButtonHideUncheckedClick(Sender: TObject);
    procedure ButtonShowAllClick(Sender: TObject);
  private
    procedure BuildTree;
  public
  end;


var
  Form1: TForm1;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
procedure TForm1.BuildTree;
var
  MyComputer: PVirtualNode;
begin
  VET.BeginUpdate;
  try
    VET1.Active := True;
    VET.Active := false;
    VET.Active := true;
    MyComputer := VET.FindNodeByPIDL(DrivesFolder.AbsolutePIDL);
    if MyComputer <> nil then
      VET.Expanded[MyComputer] := true;
  finally
    VET.EndUpdate;
  end;
end;

//------------------------------------------------------------------------------
procedure TForm1.VETEnumFolder(Sender: TCustomVirtualExplorerTree;
  Namespace: TNamespace; var AllowAsChild: Boolean);
begin
  AllowAsChild := NameSpace.FileSystem or NameSpace.IsMyComputer;
end;

//------------------------------------------------------------------------------
procedure TForm1.FormShow(Sender: TObject);
begin
  BuildTree;
end;

//------------------------------------------------------------------------------
procedure TForm1.VETInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
   Node.CheckType := ctTriStateCheckBox
end;

//------------------------------------------------------------------------------

procedure TForm1.Button4Click(Sender: TObject);
begin
  ViewManager.Snapshot('CheckTest VET', VET);
  ViewManager.Snapshot('CheckTest VET1', VET1);
  ViewManager.SaveToFile('TestCheckbox.dat');

//  VET.Storage.SaveToFile('TEST.TXT');
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  ViewManager.LoadFromFile('TestCheckbox.dat');
  ViewManager.ShowView('CheckTest VET', VET);
  ViewManager.ShowView('CheckTest VET1', VET1);

 // VET.Storage.LoadFromFile('TEST.TXT');
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  VET.BeginUpdate;
  try
    VET.Storage.Clear;
    VET.CheckState[VET.GetFirst] := csUncheckedNormal;
    VET.Storage.CheckedFileNames := Memo1.Lines;
    // need to create the node to sync up the tree
    for i := 0 to Memo1.Lines.Count - 1 do
      VET.BrowseTo(Memo1.Lines[i], False);
    VET.RefreshTree;
  finally
    VET.EndUpdate
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Lines.BeginUpdate;
  try
    Memo1.Clear;
    VET.InitAllNodes;
    Memo1.Lines := VET.Storage.CheckedFileNames;
  finally
   Memo1.Lines.EndUpdate
  end
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ViewManager.Snapshot('CheckCopy', VET);
  ViewManager.ShowView('CheckCopy', VET1);
end;

procedure TForm1.VET1InitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
   Sender.CheckType[Node] := ctTriStateCheckBox;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Memo1.Lines.BeginUpdate;
  try
    Memo1.Clear;
    VET.InitAllNodes;
    Memo1.Lines := VET.Storage.ResolvedFileNames;
  finally
   Memo1.Lines.EndUpdate
  end
end;

procedure TForm1.ButtonHideUncheckedClick(Sender: TObject);
  procedure RunNodes(Tree: TVirtualExplorerTreeview; Node: PVirtualNode);
  begin
    while Assigned(Node) do
    begin
      Tree.IsVisible[Node] := Tree.CheckState[Node] <> csUncheckedNormal;
      if Node.ChildCount > 0 then
        RunNodes(Tree, Node.FirstChild);
      Node := Node.NextSibling
    end;
  end;

begin
  VET.BeginUpdate;
  RunNodes(VET, VET.GetFirst.FirstChild);
  VET.EndUpdate
end;

procedure TForm1.ButtonShowAllClick(Sender: TObject);

  procedure RunNodes(Tree: TVirtualExplorerTreeview; Node: PVirtualNode);
  begin
    while Assigned(Node) do
    begin
      Tree.IsVisible[Node] := True;
      if Node.ChildCount > 0 then
        RunNodes(Tree, Node.FirstChild);
      Node := Node.NextSibling
    end;
  end;

begin
  VET.BeginUpdate;
  RunNodes(VET, VET.GetFirst);
  VET.EndUpdate
end;

end.

