unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, VirtualExplorerTree, VirtualTrees,
  VirtualExplorerListviewEx, VirtualShellUtilities, SHlObj,
  VirtualShellNotifier;

type
  TMyLV = class(TVirtualExplorerListviewEx)
  protected
    FZombieNode: PVirtualNode;
    procedure AddZombie;
    procedure RemoveZombie;
    function DoCompare(Node1: PVirtualNode; Node2: PVirtualNode; Column: TColumnIndex): Integer; override;
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString); override;
    procedure DoRootChanging(const NewRoot: TRootFolder; Namespace: TNamespace; var Allow: Boolean); override;
    procedure DoRootRebuild; override;
    procedure ReReadAndRefreshNode(Node: PVirtualNode; SortNode: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TForm1 = class(TForm)
    VET: TVirtualExplorerTreeview;
    Splitter1: TSplitter;
    Memo1: TMemo;
    Panel1: TPanel;
    ComboBox1: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MyLV: TMyLV;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function GetPrevNamespace(NS: TNamespace): TNamespace;
var
  PIDL: PItemIDList;
begin
  Result := nil;
  if Assigned(NS) and (not NS.IsDesktop) then begin
    PIDL := PIDLMgr.CopyPIDL(NS.AbsolutePIDL);
    PIDLMgr.StripLastID(PIDL);
    Result := TNamespace.Create(PIDL, nil);
    Result.FreePIDLOnDestroy := True; // the namespace will destroy the PIDL
  end;
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Form }

procedure TForm1.FormShow(Sender: TObject);
begin
  MyLV := TMyLV.Create(Self);
  MyLV.Parent := Self;
  MyLV.Align := alClient;
  MyLV.VirtualExplorerTreeview := VET;
  VET.VirtualExplorerListview := MyLV;

  // It's a good practice to activate the tree and the listview when the form
  // is about to be showed.
  VET.Active := True;
  MyLV.Active := True;
  ComboBox1.ItemIndex := 4;
end;

procedure TForm1.ComboBox1Click(Sender: TObject);
begin
  MyLV.ViewStyle := TViewStyleEx(Combobox1.ItemIndex);
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ TMyLV }

procedure TMyLV.AddZombie;
var
  NS: TNamespace;
begin
  // First we should create the Namespace that will represent the '..' dir.
  // Simply get the parent level namespace
  NS := GetPrevNamespace(RootFolderNamespace);
  if Assigned(NS) then begin
    // Now create the ZombieNode and sort the tree
    FZombieNode := AddCustomNode(RootNode, NS, False);
    SortTree(Header.SortColumn, Header.SortDirection);
  end;
end;

constructor TMyLV.Create(AOwner: TComponent);
begin
  inherited;
  // We are going to use Custom sorting to sort the ZombieNode to the top of
  // file list.
  TreeOptions.VETMiscOptions := TreeOptions.VETMiscOptions + [toUserSort];
end;

destructor TMyLV.Destroy;
begin
  FZombieNode := nil;
  inherited;
end;

function TMyLV.DoCompare(Node1, Node2: PVirtualNode;
  Column: TColumnIndex): Integer;
// DoCompareNodes is called every time the tree/listview must sort the items.
// There is one minor difference between VT and VET in the use of this event,
// in VET you should activate toUserSort in the TreeOptions.VETMiscOptions to
// to make it work.
var
  NS1, NS2: TNamespace;
begin
  Result := 0;
  if ValidateNamespace(Node1, NS1) and ValidateNamespace(Node2, NS2) then begin
    Result := SortHelper.CompareIDSort(Column, NS1, NS2);
    // Sort the '..' dir to be the first in the list
    if Assigned(FZombieNode) then
      if Header.SortDirection = sdAscending then begin
        if Node1 = FZombieNode then Result := -1
        else if Node2 = FZombieNode then Result := 1;
      end
      else begin
        if Node1 = FZombieNode then Result := 1
        else if Node2 = FZombieNode then Result := -1;
      end;
  end;
end;

procedure TMyLV.DoGetText(Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var Text: WideString);
// The change the ZombieNode caption to '[..]'
begin
  inherited;
  if Assigned(FZombieNode) and (Node = FZombieNode) then
    if Column < 1 then
      Text := '[..]'
    else
      Text := '';
end;

procedure TMyLV.DoRootChanging(const NewRoot: TRootFolder;
  Namespace: TNamespace; var Allow: Boolean);
begin
  // DoRootChanging is called when the directory is about to change
  // Use this event to clear the ZombieNode
  inherited;
  FZombieNode := nil;
end;

procedure TMyLV.DoRootRebuild;
begin
  // DoRootRebuild is called every time the actual directory must be rebuilt.
  // For example when the directory changes or F5 is pressed.
  // We can use this event to create the ZombieNode representing the '..' dir.
  inherited;
  AddZombie;
end;

procedure TMyLV.RemoveZombie;
begin
  DeleteNode(FZombieNode, True);
  FZombieNode := nil;
end;

procedure TMyLV.ReReadAndRefreshNode(Node: PVirtualNode; SortNode: Boolean);
begin
  RemoveZombie;
  inherited;
  AddZombie;
end;

end.
