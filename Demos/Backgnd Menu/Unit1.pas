unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShlObj, ActiveX, MPCommonUtilities, MPCommonObjects,
  MPShellTypes, MPShellUtilities, VirtualExplorerTree, ShellAPI,
  VirtualTrees, Menus, EasyListview, VirtualExplorerEasyListview, ExtCtrls;

type
  TForm1 = class(TForm)
    Button2: TButton;
    VirtualShellBackgroundContextMenu1: TVirtualShellBackgroundContextMenu;
    PopupMenuTop: TPopupMenu;
    opItem11: TMenuItem;
    opItem21: TMenuItem;
    opItem31: TMenuItem;
    opSubItem1: TMenuItem;
    SubItem11: TMenuItem;
    SubItem21: TMenuItem;
    N1: TMenuItem;
    PopupMenuBottom: TPopupMenu;
    MyItemFirst1: TMenuItem;
    PopupMenuNormal: TPopupMenu;
    MyItemNormal1: TMenuItem;
    Panel1: TPanel;
    VirtualExplorerListview1: TVirtualExplorerListview;
    VirtualExplorerEasyListview1: TVirtualExplorerEasyListview;
    VirtualShellBackgroundContextMenu2: TVirtualShellBackgroundContextMenu;
    Splitter1: TSplitter;
    PopupMenuViews: TPopupMenu;
    View1: TMenuItem;
    Icon1: TMenuItem;
    SmallIcon1: TMenuItem;
    List1: TMenuItem;
    Report1: TMenuItem;
    Thumbnails1: TMenuItem;
    Tile1: TMenuItem;
    N3: TMenuItem;
    ArrangeBy1: TMenuItem;
    Refresh1: TMenuItem;
    N4: TMenuItem;
    Name1: TMenuItem;
    Type1: TMenuItem;
    Size1: TMenuItem;
    Modified1: TMenuItem;
    N5: TMenuItem;
    Group1: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure VirtualShellBackgroundContextMenu1MenuMerge(
      Sender: TCommonShellContextMenu; Menu: HMENU; IndexMenu: Cardinal;
      var CmdFirst: Cardinal; CmdLast: Cardinal;
      Flags: TShellContextMenuFlags);
    procedure VirtualShellBackgroundContextMenu1MenuMergeTop(
      Sender: TCommonShellContextMenu; Menu: HMENU; IndexMenu: Cardinal;
      var CmdFirst: Cardinal; CmdLast: Cardinal;
      Flags: TShellContextMenuFlags);
    procedure VirtualShellBackgroundContextMenu1MenuMergeBottom(
      Sender: TCommonShellContextMenu; Menu: HMENU; IndexMenu: Cardinal;
      var CmdFirst: Cardinal; CmdLast: Cardinal;
      Flags: TShellContextMenuFlags);
    procedure VirtualShellBackgroundContextMenu1Show(
      Sender: TCommonShellContextMenu);
    procedure MyItemClick(Sender: TObject);
    procedure Icon1Click(Sender: TObject);
    procedure SmallIcon1Click(Sender: TObject);
    procedure List1Click(Sender: TObject);
    procedure Report1Click(Sender: TObject);
    procedure Thumbnails1Click(Sender: TObject);
    procedure Tile1Click(Sender: TObject);
    procedure VirtualShellBackgroundContextMenu2MenuMergeTop(
      Sender: TCommonShellContextMenu; Menu: HMENU; IndexMenu: Cardinal;
      var CmdFirst: Cardinal; CmdLast: Cardinal;
      Flags: TShellContextMenuFlags);
    procedure VirtualShellBackgroundContextMenu2NewItem(
      Sender: TCommonShellContextMenu; NS: TNamespace);
    procedure VirtualShellBackgroundContextMenu1NewItem(
      Sender: TCommonShellContextMenu; NS: TNamespace);
    procedure Refresh1Click(Sender: TObject);
    procedure Grup1Click(Sender: TObject);
    procedure Name1Click(Sender: TObject);
    procedure Type1Click(Sender: TObject);
    procedure Size1Click(Sender: TObject);
    procedure Modified1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UnCheckAll;
    procedure UnCheckGroups;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
var
  ShellContextMenu: TCommonShellBackgroundContextMenu;
  Unk: IUnknown;
  Pt: TPoint;
begin
  // NOTE:  This is technically OK but Windows has various bugs that may not release the
  // object everytime.  I would highly suggest creating a single menu, create an
  // IUnknown reference to it and reuse it for the life of the application.
  Pt := Mouse.CursorPos;
  ShellContextMenu := TCommonShellBackgroundContextMenu.Create(Self);
  ShellContextMenu.ReferenceCounted := True;
  Unk := ShellContextMenu as IUnknown;
  ShellContextMenu.ShowContextMenu(Self, VirtualExplorerListview1.RootFolderNamespace, @Pt);
end;

procedure TForm1.VirtualShellBackgroundContextMenu1MenuMerge(
  Sender: TCommonShellContextMenu; Menu: HMENU; IndexMenu: Cardinal;
  var CmdFirst: Cardinal; CmdLast: Cardinal;
  Flags: TShellContextMenuFlags);
begin
  CmdFirst := Sender.MergeMenuIntoContextMenu(PopupMenuNormal, Menu, IndexMenu, CmdFirst)
end;

procedure TForm1.VirtualShellBackgroundContextMenu1MenuMergeTop(
  Sender: TCommonShellContextMenu; Menu: HMENU; IndexMenu: Cardinal;
  var CmdFirst: Cardinal; CmdLast: Cardinal; Flags: TShellContextMenuFlags);
begin
  CmdFirst := Sender.MergeMenuIntoContextMenu(PopupMenuTop, Menu, IndexMenu, CmdFirst)
end;

procedure TForm1.VirtualShellBackgroundContextMenu1MenuMergeBottom(
  Sender: TCommonShellContextMenu; Menu: HMENU; IndexMenu: Cardinal;
  var CmdFirst: Cardinal; CmdLast: Cardinal;
  Flags: TShellContextMenuFlags);
begin
  CmdFirst := Sender.MergeMenuIntoContextMenu(PopupMenuBottom, Menu, IndexMenu, CmdFirst)
end;

procedure TForm1.VirtualShellBackgroundContextMenu1Show(Sender: TCommonShellContextMenu);
begin
  // Clear the mapping between the Shell Menu items and the TPopupMenu items
  Sender.ClearMenuMap;
end;

procedure TForm1.MyItemClick(Sender: TObject);
begin
  MessageBox(Handle, PChar( (Sender as TMenuItem).Caption), 'Notice', MB_OK);
end;

procedure TForm1.Icon1Click(Sender: TObject);
begin
  VirtualExplorerEasyListview1.View := elsIcon;
  UncheckAll;
  Icon1.Checked := True;
end;

procedure TForm1.SmallIcon1Click(Sender: TObject);
begin
  VirtualExplorerEasyListview1.View := elsSmallIcon;
  UncheckAll;
  SmallIcon1.Checked := True;
end;

procedure TForm1.List1Click(Sender: TObject);
begin
  VirtualExplorerEasyListview1.View := elsList;
  UncheckAll;
  List1.Checked := True;
end;

procedure TForm1.Report1Click(Sender: TObject);
begin
  VirtualExplorerEasyListview1.View := elsReport;
  UncheckAll;
  Report1.Checked := True;
end;

procedure TForm1.Thumbnails1Click(Sender: TObject);
begin
  VirtualExplorerEasyListview1.View := elsThumbnail;
  UncheckAll;
  Thumbnails1.Checked := True;
end;

procedure TForm1.Tile1Click(Sender: TObject);
begin
  VirtualExplorerEasyListview1.View := elsTile;
  UncheckAll;
  Tile1.Checked := True;
end;

procedure TForm1.UnCheckAll;
begin
  Icon1.Checked := False;
  SmallIcon1.Checked := False;
  List1.Checked := False;
  Report1.Checked := False;
  Thumbnails1.Checked := False;
  Tile1.Checked := False;
end;

procedure TForm1.VirtualShellBackgroundContextMenu2MenuMergeTop(
  Sender: TCommonShellContextMenu; Menu: HMENU; IndexMenu: Cardinal;
  var CmdFirst: Cardinal; CmdLast: Cardinal;
  Flags: TShellContextMenuFlags);
begin
  if not (cmfDefaultOnly in Flags) then
    CmdFirst := Sender.MergeMenuIntoContextMenu(PopupMenuViews, Menu, IndexMenu, CmdFirst);
end;

procedure TForm1.VirtualShellBackgroundContextMenu2NewItem(
  Sender: TCommonShellContextMenu; NS: TNamespace);
var
  Item: TExplorerItem;
  NewNS: TNamespace;
begin
  Item := VirtualExplorerEasyListview1.FindItemByPIDL(NS.AbsolutePIDL);
  if not Assigned(Item) then
  begin
    // The change notifier has not fired yet so add it ourselves
    // Don't forget to make a COPY of the PIDL as TNamespace takes over the PIDL
    NewNS := TNamespace.Create( PIDLMgr.CopyPIDL(NS.AbsolutePIDL), nil);
    // Create the new item and don't let it resort automatically
    Item := VirtualExplorerEasyListview1.AddCustomItem(nil, NewNS, True);
  end;
  VirtualExplorerEasyListview1.EditManager.BeginEdit(Item, nil);
end;

procedure TForm1.VirtualShellBackgroundContextMenu1NewItem(
  Sender: TCommonShellContextMenu; NS: TNamespace);
var
  Node: PVirtualNode;
  NewNS: TNamespace;
begin
  Node := VirtualExplorerListview1.FindNodeByPIDL(NS.AbsolutePIDL);
  if not Assigned(Node) then
  begin
    // The change notifier has not fired yet so add it ourselves
    // Don't forget to make a COPY of the PIDL as TNamespace takes over the PIDL
    NewNS := TNamespace.Create( PIDLMgr.CopyPIDL(NS.AbsolutePIDL), nil);
    // Create the new item and don't let it resort automatically
    Node := VirtualExplorerListview1.AddCustomNode(VirtualExplorerListview1.RootNode, NewNS, False);
  end;
  VirtualExplorerListview1.EditNode(Node, 0);
end;

procedure TForm1.Refresh1Click(Sender: TObject);
begin
  VirtualExplorerEasyListview1.Refresh
end;

procedure TForm1.Grup1Click(Sender: TObject);
begin
  Group1.Checked := not Group1.Checked;
  VirtualExplorerEasyListview1.Grouped := Group1.Checked
end;

procedure TForm1.Name1Click(Sender: TObject);
begin
  VirtualExplorerEasyListview1.GroupingColumn := 0;
  UnCheckGroups;
  Name1.Checked := True;
end;

procedure TForm1.Type1Click(Sender: TObject);
begin
  VirtualExplorerEasyListview1.GroupingColumn := 2;
  UnCheckGroups;
  Type1.Checked := True;
end;

procedure TForm1.Size1Click(Sender: TObject);
begin
  VirtualExplorerEasyListview1.GroupingColumn := 1;
  UnCheckGroups;
  Size1.Checked := True;
end;

procedure TForm1.Modified1Click(Sender: TObject);
begin
  VirtualExplorerEasyListview1.GroupingColumn := 3;
  UnCheckGroups;
  Modified1.Checked := True;
end;

procedure TForm1.UnCheckGroups;
begin
  Modified1.Checked := False;
  Size1.Checked := False;
  Name1.Checked := False;
  Type1.Checked := False;
end;

end.
