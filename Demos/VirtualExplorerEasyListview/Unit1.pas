unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, Buttons, ExtCtrls, ActnList, ComCtrls, ShlObj,
  MPShellTypes, MPCommonObjects, MPCommonUtilities,
  VirtualTrees, VirtualExplorerTree, EasyListview, VirtualExplorerEasyListview,
  MPShellUtilities, VirtualShellNotifier, VirtualThumbnails,
  ActiveX, MPDataObject;

type
  TForm1 = class(TForm)
    LV: TVirtualExplorerEasyListview;
    Tree: TVirtualExplorerTree;
    Splitter1: TSplitter;
    ActionList1: TActionList;
    PopupMenu1: TPopupMenu;
    LargeIcons1: TMenuItem;
    SmallIcons1: TMenuItem;
    List1: TMenuItem;
    Report1: TMenuItem;
    humbnails1: TMenuItem;
    iles1: TMenuItem;
    Views1: TMenuItem;
    N1: TMenuItem;
    GroupView1: TMenuItem;
    Copy1: TMenuItem;
    Delete1: TMenuItem;
    N2: TMenuItem;
    ActionGroupByName: TAction;
    CollapseAll: TMenuItem;
    ExpandAll: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    GroupbyName: TMenuItem;
    GroupByType: TMenuItem;
    ActionGroupByType: TAction;
    ActionGrouping: TAction;
    Grouping: TMenuItem;
    N5: TMenuItem;
    Panel1: TPanel;
    VirtualExplorerCombobox1: TVirtualExplorerCombobox;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    cbthRepository: TRadioButton;
    cbthPerFolder: TRadioButton;
    cbthShellExtraction: TCheckBox;
    cbthFoldersShellExtraction: TCheckBox;
    cbthAutoSave: TCheckBox;
    cbthAutoLoad: TCheckBox;
    cbthLoadAllAtOnce: TCheckBox;
    Label3: TLabel;
    Bevel1: TBevel;
    cbthSubsampling: TCheckBox;
    cbthCompressed: TCheckBox;
    GroupBox3: TGroupBox;
    CheckBoxBrowseFolder: TCheckBox;
    CheckBoxBrowseFolderShortcut: TCheckBox;
    CheckBoxBrowseExecuteZipFolder: TCheckBox;
    CheckBoxExecuteOnDblClk: TCheckBox;
    CheckBoxHideRecycleBin: TCheckBox;
    CheckBoxThreadedImages: TCheckBox;
    GroupBySize: TMenuItem;
    GroupByAttribute: TMenuItem;
    ActionGroupByAttribute: TAction;
    ActionExpandAllGroups: TAction;
    ActionCollapseAllGroups: TAction;
    ActionGroupBySize: TAction;
    ActionIconView: TAction;
    ActionSmallIconView: TAction;
    ActionListView: TAction;
    ActionReportView: TAction;
    ActionThumbnailView: TAction;
    ActionTileView: TAction;
    CheckBoxQueryInfo: TCheckBox;
    CheckBoxContextMenu: TCheckBox;
    CheckBoxNotifierThread: TCheckBox;
    TabSheet4: TTabSheet;
    CheckBoxCustomGrouping: TCheckBox;
    Label4: TLabel;
    EditGroupingColumn: TEdit;
    Label5: TLabel;
    ActionFilmStrip: TAction;
    FilmStrip1: TMenuItem;
    CheckBoxEditableCaptions: TCheckBox;
    CheckBoxDragDrop: TCheckBox;
    cbthExifThumbnail: TCheckBox;
    TrackBar1: TTrackBar;
    GroupBox4: TGroupBox;
    cbthFastResize: TCheckBox;
    N6: TMenuItem;
    FoldersAlwaysOnTop: TMenuItem;
    CheckBoxAlwaysShowHeader: TCheckBox;
    procedure CheckBoxThreadedImagesClick(Sender: TObject);
    procedure CheckBoxHideRecycleBinClick(Sender: TObject);
    procedure CheckBoxExecuteOnDblClkClick(Sender: TObject);
    procedure CheckBoxBrowseExecuteZipFolderClick(Sender: TObject);
    procedure CheckBoxBrowseFolderShortcutClick(Sender: TObject);
    procedure CheckBoxBrowseFolderClick(Sender: TObject);
    procedure cbthCompressedClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbthPerFolderClick(Sender: TObject);
    procedure cbthRepositoryClick(Sender: TObject);
    procedure cbthLoadAllAtOnceClick(Sender: TObject);
    procedure cbthAutoLoadClick(Sender: TObject);
    procedure cbthAutoSaveClick(Sender: TObject);
    procedure cbthFoldersShellExtractionClick(Sender: TObject);
    procedure cbthShellExtractionClick(Sender: TObject);
    procedure cbthSubsamplingClick(Sender: TObject);
    procedure ActionGroupingExecute(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ActionGroupByNameExecute(Sender: TObject);
    procedure ActionGroupBySizeExecute(Sender: TObject);
    procedure ActionGroupByTypeExecute(Sender: TObject);
    procedure ActionGroupByAttributeExecute(Sender: TObject);
    procedure ActionCollapseAllGroupsExecute(Sender: TObject);
    procedure ActionExpandAllGroupsExecute(Sender: TObject);
    procedure ActionChangeViewExecute(Sender: TObject);
    procedure CheckBoxQueryInfoClick(Sender: TObject);
    procedure CheckBoxContextMenuClick(Sender: TObject);
    procedure CheckBoxNotifierThreadClick(Sender: TObject);
    procedure EditGroupingColumnExit(Sender: TObject);
    procedure EditGroupingColumnKeyPress(Sender: TObject; var Key: Char);
    procedure LVCustomGroup(Sender: TCustomVirtualExplorerEasyListview;
      Groups: TEasyGroups; NS: TNamespace; var Group: TExplorerGroup);
    procedure CheckBoxCustomGroupingClick(Sender: TObject);
    procedure CheckBoxEditableCaptionsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure CheckBoxDragDropClick(Sender: TObject);
    procedure cbthExifThumbnailClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure cbthFastResizeClick(Sender: TObject);
    procedure LVOLEDragDrop(Sender: TCustomEasyListview;
      DataObject: IDataObject; KeyState: TCommonKeyStates;
      WindowPt: TPoint; AvailableEffects: TCommonDropEffects;
      var DesiredDropEffect: TCommonDropEffect; var Handled: Boolean);
    procedure FoldersAlwaysOnTopClick(Sender: TObject);
    procedure CheckBoxAlwaysShowHeaderClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  LV.ThumbsManager.StorageRepositoryFolder := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'AlbumsRepository';
  ChangeNotifier.RegisterKernelChangeNotify(LV, AllKernelNotifiers);
  // Register some special Folders that the thread will be able to generate
  // notification PIDLs for Virtual Folders too.
  ChangeNotifier.RegisterKernelSpecialFolderWatch(CSIDL_DESKTOP);
  ChangeNotifier.RegisterKernelSpecialFolderWatch(CSIDL_PERSONAL);
  ChangeNotifier.RegisterKernelSpecialFolderWatch(CSIDL_COMMON_DOCUMENTS);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  CheckBoxEditableCaptions.Checked := LV.EditManager.Enabled;
  CheckBoxDragDrop.Checked := LV.DragManager.Enabled;
  CheckBoxBrowseFolder.Checked := eloBrowseExecuteFolder in LV.Options;
  CheckBoxBrowseFolderShortcut.Checked := eloBrowseExecuteFolderShortcut in LV.Options;
  CheckBoxBrowseExecuteZipFolder.Checked := eloBrowseExecuteZipFolder in LV.Options;
  CheckBoxExecuteOnDblClk.Checked := eloExecuteOnDblClick in LV.Options;
  CheckBoxHideRecycleBin.Checked := eloHideRecycleBin in LV.Options;
  CheckBoxThreadedImages.Checked :=  eloThreadedImages in LV.Options;
  CheckBoxQueryInfo.Checked :=  eloQueryInfoHints in LV.Options;
  CheckBoxContextMenu.Checked :=  eloShellContextMenus in LV.Options;
  CheckBoxNotifierThread.Checked :=  eloChangeNotifierThread in LV.Options;
  CheckBoxAlwaysShowHeader.Checked := LV.Header.ShowInAllViews;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ChangeNotifier.UnRegisterKernelChangeNotify(LV);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt.X := SpeedButton1.Left;
  Pt.Y := SpeedButton1.Top + SpeedButton1.Height;
  Pt := SpeedButton1.Parent.ClientToScreen(Pt);
  PopupMenu1.Popup(Pt.X, Pt.Y);
end;

procedure TForm1.LVCustomGroup(Sender: TCustomVirtualExplorerEasyListview;
  Groups: TEasyGroups; NS: TNamespace; var Group: TExplorerGroup);
var
  i: Integer;
begin
  if CheckBoxCustomGrouping.Checked then
  begin
    i := 0;
    while not Assigned(Group) and (i < Groups.Count) do
    begin
      if WideStrIComp(PWideChar(Groups[i].Caption), PWideChar(WideExtractFileExt(NS.NameForParsing))) = 0 then
        Group := TExplorerGroup(Groups[i]);
      Inc(i)
    end;
    if not Assigned(Group) then
    begin
      Group := Groups.AddCustom(TExplorerGroup) as TExplorerGroup;
      Group.Caption := WideExtractFileExt(NS.NameForParsing)
    end
  end
end;

procedure TForm1.TreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NS: TNamespace;
begin
  if Tree.ValidateNamespace(Node, NS) then
    ChangeNotifier.NotifyWatchFolder(LV, NS.NameForParsing)
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Actions }

procedure TForm1.ActionGroupingExecute(Sender: TObject);
begin
  ActionGroupbyName.Enabled := Grouping.Checked;
  ActionGroupbySize.Enabled := Grouping.Checked;
  ActionGroupbyType.Enabled := Grouping.Checked;
  ActionGroupbyAttribute.Enabled := Grouping.Checked;
  ActionCollapseAllGroups.Enabled := Grouping.Checked;
  ActionExpandAllGroups.Enabled := Grouping.Checked;
  LV.Grouped := Grouping.Checked
end;

procedure TForm1.ActionGroupByNameExecute(Sender: TObject);
begin
  LV.GroupingColumn := 0
end;

procedure TForm1.ActionGroupBySizeExecute(Sender: TObject);
begin
  LV.GroupingColumn := 1
end;

procedure TForm1.ActionGroupByTypeExecute(Sender: TObject);
begin
  LV.GroupingColumn := 2
end;

procedure TForm1.ActionGroupByAttributeExecute(Sender: TObject);
begin
  LV.GroupingColumn := 6
end;

procedure TForm1.ActionCollapseAllGroupsExecute(Sender: TObject);
begin
  LV.Groups.CollapseAll
end;

procedure TForm1.ActionExpandAllGroupsExecute(Sender: TObject);
begin
  LV.Groups.ExpandAll
end;

procedure TForm1.ActionChangeViewExecute(Sender: TObject);
begin
  LV.View := TEasyListStyle(TMenuItem(Sender).Tag);
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ ELV options }

procedure TForm1.CheckBoxBrowseFolderClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    LV.Options := LV.Options + [eloBrowseExecuteFolder]
  else
    LV.Options := LV.Options - [eloBrowseExecuteFolder];
end;

procedure TForm1.CheckBoxBrowseFolderShortcutClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    LV.Options := LV.Options + [eloBrowseExecuteFolderShortcut]
  else
    LV.Options := LV.Options - [eloBrowseExecuteFolderShortcut];
end;

procedure TForm1.CheckBoxBrowseExecuteZipFolderClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    LV.Options := LV.Options + [eloBrowseExecuteZipFolder]
  else
    LV.Options := LV.Options - [eloBrowseExecuteZipFolder];
end;

procedure TForm1.CheckBoxExecuteOnDblClkClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    LV.Options := LV.Options + [eloExecuteOnDblClick]
  else
    LV.Options := LV.Options - [eloExecuteOnDblClick];
end;

procedure TForm1.CheckBoxHideRecycleBinClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    LV.Options := LV.Options + [eloHideRecycleBin]
  else
    LV.Options := LV.Options - [eloHideRecycleBin];
end;

procedure TForm1.CheckBoxThreadedImagesClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    LV.Options := LV.Options + [eloThreadedImages]
  else
    LV.Options := LV.Options - [eloThreadedImages];
end;

procedure TForm1.CheckBoxQueryInfoClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    LV.Options := LV.Options + [eloQueryInfoHints]
  else
    LV.Options := LV.Options - [eloQueryInfoHints];
end;

procedure TForm1.CheckBoxContextMenuClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    LV.Options := LV.Options + [eloShellContextMenus]
  else
    LV.Options := LV.Options - [eloShellContextMenus];
end;

procedure TForm1.CheckBoxNotifierThreadClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    LV.Options := LV.Options + [eloChangeNotifierThread]
  else
    LV.Options := LV.Options - [eloChangeNotifierThread];
end;

procedure TForm1.CheckBoxEditableCaptionsClick(Sender: TObject);
begin
  LV.EditManager.Enabled := CheckBoxEditableCaptions.Checked
end;

procedure TForm1.CheckBoxDragDropClick(Sender: TObject);
begin
  LV.DragManager.Enabled := CheckBoxDragDrop.Checked
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Thumbnails options }

procedure TForm1.cbthAutoLoadClick(Sender: TObject);
begin
  LV.ThumbsManager.AutoLoad := TCheckBox(Sender).Checked;
end;

procedure TForm1.cbthAutoSaveClick(Sender: TObject);
begin
  LV.ThumbsManager.AutoSave := TCheckBox(Sender).Checked;
end;

procedure TForm1.cbthCompressedClick(Sender: TObject);
begin
  LV.ThumbsManager.StorageCompressed := TCheckBox(Sender).Checked;
end;

procedure TForm1.cbthExifThumbnailClick(Sender: TObject);
begin
  LV.ThumbsManager.UseExifThumbnail := TCheckBox(Sender).Checked;
end;

procedure TForm1.cbthFastResizeClick(Sender: TObject);
begin
  // This will increase the size of the thumbnail bitmaps in the cache
  LV.ThumbsManager.MaxThumbWidth := 300;
  LV.ThumbsManager.MaxThumbHeight := 300;
end;

procedure TForm1.cbthFoldersShellExtractionClick(Sender: TObject);
begin
  LV.ThumbsManager.UseFoldersShellExtraction := TCheckBox(Sender).Checked;
end;

procedure TForm1.cbthLoadAllAtOnceClick(Sender: TObject);
begin
  LV.ThumbsManager.LoadAllAtOnce := TCheckBox(Sender).Checked;
end;

procedure TForm1.cbthPerFolderClick(Sender: TObject);
begin
  LV.ThumbsManager.StorageType := tasPerFolder;
end;

procedure TForm1.cbthRepositoryClick(Sender: TObject);
begin
  LV.ThumbsManager.StorageType := tasRepository;
end;

procedure TForm1.cbthShellExtractionClick(Sender: TObject);
begin
  LV.ThumbsManager.UseShellExtraction := TCheckBox(Sender).Checked;
end;

procedure TForm1.cbthSubsamplingClick(Sender: TObject);
begin
  LV.ThumbsManager.UseSubsampling := TCheckBox(Sender).Checked;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var
  I: Integer;
begin
  I := TrackBar1.Position * 10;
  LV.CellSizes.Thumbnail.SetSize(I, I);
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Grouping Options }

procedure TForm1.EditGroupingColumnExit(Sender: TObject);
begin
  LV.GroupingColumn := StrToInt(EditGroupingColumn.Text)
end;

procedure TForm1.EditGroupingColumnKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    LV.GroupingColumn := StrToInt(EditGroupingColumn.Text);
    Key := #0
  end
end;

procedure TForm1.CheckBoxCustomGroupingClick(Sender: TObject);
begin
  LV.Rebuild
end;

procedure TForm1.LVOLEDragDrop(Sender: TCustomEasyListview;
  DataObject: IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint;
  AvailableEffects: TCommonDropEffects;
  var DesiredDropEffect: TCommonDropEffect; var Handled: Boolean);
var
  HDrop: TCommonHDrop;
begin
  HDrop := TCommonHDrop.Create;
  try
    HDrop.LoadFromDataObject(DataObject);
    // Check for filenames here
    // if don't allow drop then
    //    Handled := True;
  finally
    HDrop.Free
  end
end;

procedure TForm1.FoldersAlwaysOnTopClick(Sender: TObject);
begin
  LV.SortFolderFirstAlways := FoldersAlwaysOnTop.Checked
end;

procedure TForm1.CheckBoxAlwaysShowHeaderClick(Sender: TObject);
begin
  LV.Header.ShowInAllViews := CheckBoxAlwaysShowHeader.Checked
end;

end.


