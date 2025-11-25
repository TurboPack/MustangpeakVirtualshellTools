unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ImgList, ActiveX,
  VirtualTrees, VirtualExplorerTree, VirtualShellUtilities, VirtualSendToMenu,
  TB2Item, TB2Dock, TB2Toolbar, TBX;

type
  TForm1 = class(TForm)
    VirtualSendToMenu1: TVirtualSendToMenu;
    VirtualExplorerListview1: TVirtualExplorerListview;
    ImageList1: TImageList;
    TBDock1: TTBDock;
    TBXToolbar1: TTBXToolbar;
    TBXItem3: TTBXItem;
    TBXItem2: TTBXItem;
    TBXSubmenuItem1: TTBXSubmenuItem;
    procedure VirtualExplorerListview1Change(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure VirtualExplorerListview1RootChange(
      Sender: TCustomVirtualExplorerTree);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure VirtualSendToMenu1SendToEvent(Sender: TVirtualSendToMenu;
      SendToTarget: TNamespace; var SourceData: IDataObject);
    procedure TBXSubmenuItem1Popup(Sender: TTBCustomItem;
      FromLink: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
  VirtualExplorerListview1.Active := True;
end;

procedure TForm1.VirtualExplorerListview1Change(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NS: TNamespace;
begin
  if VirtualExplorerListview1.ValidateNamespace(Node, NS) then
  begin
    TBXSubmenuItem1.Enabled := NS.CanCopy;
    TBXItem3.Enabled := NS.Folder;
    TBXItem2.Enabled := not VirtualExplorerListview1.RootFolderNamespace.IsDesktop;
  end
end;

procedure TForm1.VirtualExplorerListview1RootChange(Sender: TCustomVirtualExplorerTree);
var
  NS: TNamespace;
begin
  TBXItem2.Enabled := not VirtualExplorerListview1.RootFolderNamespace.IsDesktop;
  if VirtualExplorerListview1.ValidateNamespace(VirtualExplorerListview1.GetFirstSelected, NS) then
  begin
    TBXSubmenuItem1.Enabled := NS.CanCopy;
    TBXItem3.Enabled := NS.Folder;
  end else
  begin
    TBXSubmenuItem1.Enabled := False;
    TBXItem3.Enabled := False;
  end
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  VirtualExplorerListview1.BrowseToPrevLevel;
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  VirtualExplorerListview1.BrowseToNextLevel;
end;

procedure TForm1.VirtualSendToMenu1SendToEvent(Sender: TVirtualSendToMenu;
  SendToTarget: TNamespace; var SourceData: IDataObject);
begin
  SourceData := VirtualExplorerListview1.SelectedToDataObject;
end;

procedure TForm1.TBXSubmenuItem1Popup(Sender: TTBCustomItem; FromLink: Boolean);
begin
  // Just call this method when the SubmenuItem is about to be showed.
  // To add unicode support use TSpTBXItem instead:
  // VirtualSendToMenu1.Populate_TB2000(Sender, TSpTBXItem);
  VirtualSendToMenu1.Populate_TB2000(Sender, TTBXItem);
end;

end.
