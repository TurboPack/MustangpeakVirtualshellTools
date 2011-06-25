unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList, ActiveX, ComCtrls, ToolWin,
  VirtualTrees, VirtualExplorerTree, MPShellUtilities,
  VirtualSendToMenu;

type
  TForm1 = class(TForm)
    VirtualSendToMenu1: TVirtualSendToMenu;
    VirtualExplorerListview1: TVirtualExplorerListview;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ImageList1: TImageList;
    procedure VirtualExplorerListview1Change(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure VirtualExplorerListview1RootChange(
      Sender: TCustomVirtualExplorerTree);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure VirtualSendToMenu1SendToEvent(Sender: TVirtualSendToMenu;
      SendToTarget: TNamespace; var SourceData: IDataObject);
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
    ToolButton1.Enabled := NS.CanCopy;
    ToolButton3.Enabled := NS.Folder;
    ToolButton2.Enabled := not VirtualExplorerListview1.RootFolderNamespace.IsDesktop
  end
end;

procedure TForm1.VirtualExplorerListview1RootChange(Sender: TCustomVirtualExplorerTree);
var
  NS: TNamespace;
begin
  ToolButton2.Enabled := not VirtualExplorerListview1.RootFolderNamespace.IsDesktop;
  if VirtualExplorerListview1.ValidateNamespace(VirtualExplorerListview1.GetFirstSelected, NS) then
  begin
    ToolButton1.Enabled := NS.CanCopy;
    ToolButton3.Enabled := NS.Folder;
  end else
  begin
    ToolButton1.Enabled := False;
    ToolButton3.Enabled := False;
  end
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  VirtualExplorerListview1.BrowseToNextLevel;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  VirtualExplorerListview1.BrowseToPrevLevel;
end;

procedure TForm1.VirtualSendToMenu1SendToEvent(Sender: TVirtualSendToMenu;
  SendToTarget: TNamespace; var SourceData: IDataObject);
begin
  SourceData := VirtualExplorerListview1.SelectedToDataObject;
end;

end.
