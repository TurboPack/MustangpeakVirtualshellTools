unit Unit1;

interface

{$DEFINE KERNEL_SHELLNOTIFICATIONS}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, ComCtrls, StdCtrls, VirtualExplorerTree,
  VirtualShellToolBar, VirtualTrees, MPShellUtilities, ActiveX,
  MPCommonUtilities,   
  MPShellTypes, ShlObj, VirtualShellNewMenu, ToolWin,
  VirtualShellHistory, VirtualShellNotifier, ImgList;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel1: TPanel;
    VirtualExplorerComboBox1: TVirtualExplorerCombobox;
    Panel3: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    Tools1: TMenuItem;
    MapToDrive1: TMenuItem;
    UnMapDrive1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    VirtualExplorerListview1: TVirtualExplorerListview;
    VirtualExplorerTreeview1: TVirtualExplorerTreeview;
    Splitter2: TSplitter;
    Options1: TMenuItem;
    ModalDialogs1: TMenuItem;
    VirtualShellNewMenu1: TVirtualShellNewMenu;
    procedure VirtualExplorerListview1Change(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure VirtualExplorerListview1Updating(Sender: TBaseVirtualTree;
      State: TVTUpdateState);
    procedure FormShow(Sender: TObject);
    procedure VirtualExplorerListview1GetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure VirtualShellNewMenu1AfterFileCreate(Sender: TMenu;
      const NewMenuItem: TVirtualShellNewItem; const FileName: WideString);
    procedure PopupMenuMRUPopup(Sender: TObject);
    procedure VirtualExplorerListview1RootChanging(
      Sender: TCustomVirtualExplorerTree; const NewValue: TRootFolder;
      const CurrentNamespace, Namespace: TNamespace; var Allow: Boolean);
    procedure Close1Click(Sender: TObject);
    procedure MapToDrive1Click(Sender: TObject);
    procedure UnMapDrive1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VirtualExplorerListview1RootChange(
      Sender: TCustomVirtualExplorerTree);
    procedure ModalDialogs1Click(Sender: TObject);
    procedure VirtualExplorerListview1DragOver(Sender: TBaseVirtualTree;
      Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
      Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure VirtualShellNewMenu1CreateNewFile(Sender: TMenu;
      const NewMenuItem: TVirtualShellNewItem; var Path,
      FileName: WideString; var Allow: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    Sorting: TSortDirection;
    SortingColumn: Integer;
  end;

var
  Form1: TForm1;

implementation

uses About;

{$R *.DFM}


procedure WalkPIDL(ParsedName, NormalName: TStrings; PIDL: PItemIDList);
var
  NS: TNamespace;
  i: integer;
  TempPIDL: PItemIDList;
begin
  ParsedName.Clear;
  NormalName.Clear;
  TempPIDL := PIDLMgr.CopyPIDL(PIDL);
  if PIDLMgr.IsDesktopFolder(PIDL) then
  begin
    NS := TNamespace.Create(PIDL, nil);
    NS.FreePIDLOnDestroy := False;
    ParsedName.Add(NS.NameForParsing);
    NormalName.Add(NS.NameNormal);
    NS.Free;
  end else
    for i := 0 to PIDLMgr.IDCount(TempPIDL) - 1 do
    begin
      NS := TNamespace.Create(TempPIDL, nil);
      NS.FreePIDLOnDestroy := False;
      ParsedName.Add(NS.NameForParsing);
      NormalName.Add(NS.NameNormal);
      NS.Free;
      PIDLMgr.StripLastID(TempPIDL);
    end;
  PIDLMgr.FreePIDL(TempPIDL)
end;

procedure TForm1.VirtualExplorerListview1Change(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  StatusBar1.Panels[0].Text := 'Selected Count = ' + IntToStr(VirtualExplorerListview1.SelectedCount);
end;

procedure TForm1.VirtualExplorerListview1Updating(Sender: TBaseVirtualTree; State: TVTUpdateState);
begin
  if Assigned(VirtualExplorerListview1.RootNode) then
    StatusBar1.Panels[1].Text := 'Total Objects = ' +
      IntToStr(VirtualExplorerListview1.RootNode.ChildCount);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ModalDialogs1.Checked := MP_UseModalDialogs;
  VirtualExplorerTreeview1.SetFocus;
  if FileExists('Settings.cfg') then
 //   VirtualShellToolbar1.LoadFromFile('Settings.cfg');
//  VirtualShellMRU1.LoadFromRegistry(HKEY_CURRENT_USER, '\Software\VirtualShellTools\MRU');
end;

procedure TForm1.VirtualExplorerListview1GetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
var
  NS: TNamespace;
begin
  PopupMenu := nil;
  if (Sender as TVirtualExplorerListview).ValidateNamespace(Sender.RootNode, NS) then
    if DirectoryExists(NS.NameParseAddress) or (PIDLMgr.IsDesktopFolder(NS.AbsolutePIDL)) then
      PopupMenu := VirtualShellNewMenu1;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFDEF KERNEL_SHELLNOTIFICATIONS}
  ChangeNotifier.UnRegisterKernelChangeNotify(VirtualExplorerListview1);
  ChangeNotifier.UnRegisterKernelChangeNotify(VirtualExplorerTreeview1);
  {$ENDIF}
 // VirtualShellToolbar1.SaveToFile('Settings.cfg');
 // VirtualShellMRU1.SaveToRegistry(HKEY_CURRENT_USER, '\Software\VirtualShellTools\MRU');
end;

procedure TForm1.VirtualShellNewMenu1AfterFileCreate(Sender: TMenu;
  const NewMenuItem: TVirtualShellNewItem; const FileName: WideString);
var
  Node: PVirtualNode;
  NS: TNamespace;
begin
  Assert((toEditable in VirtualExplorerListview1.TreeOptions.MiscOptions), 'You must set the toEditable option to Edit paths');

  if DirectoryExists(FileName) or FileExists(FileName) then
  begin
    Node := VirtualExplorerListview1.FindNode(FileName);
    // Make sure we can get to the desired folder so we can select the new item
    if not Assigned(Node) then
    begin
      NS := TNamespace.Create(PathToPIDL(FileName), nil);
      Node := VirtualExplorerListview1.AddCustomNode(Node, NS, toCheckSupport in VirtualExplorerListview1.TreeOptions.MiscOptions);
    end;
    if Assigned(Node) then
    begin
      VirtualExplorerListview1.ClearSelection;
      VirtualExplorerListview1.FocusedNode := Node;
      VirtualExplorerListview1.Selected[Node] := True;
      if VirtualExplorerListview1.Header.Columns.Count = 0 then
        VirtualExplorerListview1.EditNode(Node, -1)
      else
        VirtualExplorerListview1.EditNode(Node, 0)
    end
  end
end;

procedure TForm1.PopupMenuMRUPopup(Sender: TObject);
begin
//  VirtualShellMRU1.FillPopupMenu(PopupMenuMRU, fpdNewestToOldest, 'Clear List...');
end;

procedure TForm1.VirtualExplorerListview1RootChanging(
  Sender: TCustomVirtualExplorerTree; const NewValue: TRootFolder;
  const CurrentNamespace, Namespace: TNamespace; var Allow: Boolean);
begin
  {$IFDEF KERNEL_SHELLNOTIFICATIONS}
  if Assigned(Namespace) then
  begin
    if DirectoryExists(Namespace.NameForParsing) then
      ChangeNotifier.NotifyWatchFolder(VirtualExplorerListview1, Namespace.NameForParsing)
    else
      ChangeNotifier.NotifyWatchFolder(VirtualExplorerListview1, '')
  end;
  {$ENDIF}
  
  // Save the state of the header
  if Assigned(CurrentNamespace) then
    if CurrentNamespace.FileSystem then
    begin
      Sorting := VirtualExplorerListview1.Header.SortDirection;
      SortingColumn := VirtualExplorerListview1.Header.SortColumn;
    end
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.MapToDrive1Click(Sender: TObject);
begin
  WNetConnectionDialog(Handle, RESOURCETYPE_DISK)
end;

procedure TForm1.UnMapDrive1Click(Sender: TObject);
begin
  WNetDisconnectDialog(Handle, RESOURCETYPE_DISK)
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  AboutBox.ShowModal
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {$IFDEF KERNEL_SHELLNOTIFICATIONS}
  ChangeNotifier.RegisterKernelChangeNotify(VirtualExplorerListview1, AllKernelNotifiers);
  ChangeNotifier.RegisterKernelChangeNotify(VirtualExplorerTreeview1, AllKernelNotifiers);
  // Register some special Folders that the thread will be able to generate
  // notification PIDLs for Virtual Folders too.
  ChangeNotifier.RegisterKernelSpecialFolderWatch(CSIDL_DESKTOP);
  ChangeNotifier.RegisterKernelSpecialFolderWatch(CSIDL_PERSONAL);
  ChangeNotifier.RegisterKernelSpecialFolderWatch(CSIDL_COMMON_DOCUMENTS);
  {$ENDIF}
end;

procedure TForm1.VirtualExplorerListview1RootChange(
  Sender: TCustomVirtualExplorerTree);
begin
  // Restore the state of the header
  if VirtualExplorerListview1.RootFolderNamespace.FileSystem then
  begin
    VirtualExplorerListview1.Header.SortDirection := Sorting;
    VirtualExplorerListview1.Header.SortColumn := SortingColumn
  end
end;

procedure TForm1.ModalDialogs1Click(Sender: TObject);
begin
  MP_UseModalDialogs := ModalDialogs1.Checked
end;

procedure TForm1.VirtualExplorerListview1DragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := True; //Sender <> VirtualExplorerListview1;
end;

procedure TForm1.VirtualShellNewMenu1CreateNewFile(Sender: TMenu;
  const NewMenuItem: TVirtualShellNewItem; var Path, FileName: WideString;
  var Allow: Boolean);
var
  NS: TNamespace;
begin
  if VirtualExplorerListview1.ValidateNamespace(VirtualExplorerListview1.RootNode, NS) then
  begin
    Path := NS.NameForParsing;
    if not DirectoryExists(Path) then
      Path := '';
  end
end;

end.


