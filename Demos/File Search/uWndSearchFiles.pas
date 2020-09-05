unit uWndSearchFiles;

// The demo makes use of TFindFile, an excellent freeware component
// created by Kambiz R. Khojasteh. TFindFile can be found in FindFile.pas.
// See http://www.delphiarea.com for further information and updates.
//
// The lastest version as of 12.2.02 is include with the demo. It is necessary
// to unzip it into the demo folder.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Spin, ActiveX, MPCommonUtilities,
  {$WARN UNIT_PLATFORM OFF}
  FindFile,
  {$WARN UNIT_PLATFORM ON}
  VirtualExplorerTree, VirtualTrees,
  VirtualShellNotifier, MPCommonObjects, ToolWin, VirtualShellToolBar,
  MPShellUtilities, MPDataObject;

const
  WM_ENTERSEARCHRESULT = WM_USER + 1;

type
  TWndSearchFiles = class(TForm)
    StatusBar: TStatusBar;
    Panel_Middle: TPanel;
    Panel_Top: TPanel;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit_Filename: TEdit;
    Edit_Location: TEdit;
    CheckBox_IncludeSubfolders: TCheckBox;
    Button_Browse: TButton;
    Edit_ContainingText: TEdit;
    CheckBox_CaseInsensitive: TCheckBox;
    TabSheet3: TTabSheet;
    DateTimePicker_BeforeDate: TDateTimePicker;
    RadioGroup_DateSelection: TRadioGroup;
    DateTimePicker_AfterDate: TDateTimePicker;
    DateTimePicker_BeforeTime: TDateTimePicker;
    DateTimePicker_AfterTime: TDateTimePicker;
    CheckBox_BeforeDate: TCheckBox;
    CheckBox_BeforeTime: TCheckBox;
    CheckBox_AfterDate: TCheckBox;
    CheckBox_AfterTime: TCheckBox;
    TabSheet2: TTabSheet;
    Attributes: TGroupBox;
    CheckBox_AttributeSystem: TCheckBox;
    CheckBox_AttributeHidden: TCheckBox;
    CheckBox_AttributeReadonly: TCheckBox;
    CheckBox_AttributeArchive: TCheckBox;
    CheckBox_AttributeDirectory: TCheckBox;
    CheckBox_AttributeExactMatch: TCheckBox;
    FileSize: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    SpinEdit_SizeMax: TSpinEdit;
    SpinEdit_SizeMin: TSpinEdit;
    Panel_Right: TPanel;
    Button_Find: TButton;
    Button_Stop: TButton;
    Animate: TAnimate;
    Panel_SearchResult: TPanel;
    SearchResult: TVirtualExplorerListview;
    Timer_Notify: TTimer;
    procedure Button_BrowseClick(Sender: TObject);
    procedure Button_FindClick(Sender: TObject);
    procedure Button_StopClick(Sender: TObject);
    procedure CheckBox_BeforeDateClick(Sender: TObject);
    procedure CheckBox_BeforeTimeClick(Sender: TObject);
    procedure CheckBox_AfterDateClick(Sender: TObject);
    procedure CheckBox_AfterTimeClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SearchResultHeaderRebuild(Sender: TCustomVirtualExplorerTree; Header: TVTHeader);
    procedure SearchResultClipboardCopy(Sender: TCustomVirtualExplorerTree;
                                        var Handled: Boolean);
    procedure SearchResultClipboardCut(Sender: TCustomVirtualExplorerTree;
                                       var MarkSelectedCut, Handled: Boolean);
    procedure SearchResultClipboardPaste(Sender: TCustomVirtualExplorerTree;
                                         var Handled: Boolean);
    procedure SearchResultCreateDataObject(Sender: TBaseVirtualTree;
                                           out IDataObject: IDataObject);
    procedure SearchResultEnter(Sender: TObject);
    procedure SearchResultShellNotify(Sender: TCustomVirtualExplorerTree;
                                      ShellEvent: TVirtualShellEvent);
    procedure SearchResultContextMenuCmd(
      Sender: TCustomVirtualExplorerTree; Namespace: TNamespace;
      Verb: string; MenuItemID: Integer; var Handled: Boolean);
  private
    FBackgroundUpdatedPaths: TStringList;
    FCompleteSearchResultExists: Boolean;
    FFindFile: TFindFile;
    FFolderCount: Integer;
    FSearchPath: string;
    FSortedSearchResults: TStringList;
    FStartTime: DWord;

    procedure BackgroundSearchFinished(Sender: TObject);
    procedure BackgroundSearchFileMatch(Sender: TObject; const Folder: string;
                                const FileInfo: TSearchRec);
    procedure ClipboardCopySelected(Sender: TCustomVirtualExplorerTree);
    procedure ClipboardCutSelected(Sender: TCustomVirtualExplorerTree);
    function  CreateDataObjectOfSelected(Sender: TCustomVirtualExplorerTree): IDataObject;
    procedure ExplicitSearchBegin(Sender: TObject);
    procedure ExplicitSearchFileMatch(Sender: TObject; const Folder: string;
                                const FileInfo: TSearchRec);
    procedure ExplicitSearchFinish(Sender: TObject);
    procedure ExplicitSearchFolderChange(Sender: TObject; const Folder: string;
                                   var IgnoreFolder: TFolderIgnore);
    procedure StartUpdateInBackground;
    procedure WMEnterSearchResult(var Message: TMessage); message WM_ENTERSEARCHRESULT;
  protected
  public
  end;

var
  WndSearchFiles : TWndSearchFiles;

implementation

{$R *.DFM}

uses
  {$WARN UNIT_PLATFORM OFF}
  FileCtrl,
  {$WARN UNIT_PLATFORM ON}
  ShellAPI, ShlObj, SyncObjs, ComObj;


const
  // Names given to a new shortcut file when NewShortcutNameW is called.
  // These names should maybe be put in VirtualResource.pas
  STR_NEWSHORTCUT1 = 'Shortcut to';
  STR_NEWSHORTCUT2 = 'Shortcut (%d) to';


// NewShortcutNameW should maybe be added to VirtualWideStrings.pas
function NewShortcutNameW(ParentFolder: string; TargetName: string): string;
var
  i: integer;
begin
  ParentFolder := WideStripTrailingBackslash(ParentFolder, True); // Strip even if a root folder
  i := 1;
  Result := ParentFolder + '\' + STR_NEWSHORTCUT1 + ' ' + TargetName + '.lnk';
  while FileExists(Result) and (i <= 20) do
  begin
    Result := ParentFolder + '\' + Format(STR_NEWSHORTCUT2, [i]) + ' ' + TargetName + '.lnk';
    Inc(i);
  end;
  if i > 20 then
    Result := '';
end;


function DeleteFiles(NamespaceArray: TNamespaceArray): Boolean;
var
  ShFileOpStruct : TShFileOpStruct;
  Files: string;
  i: Integer;
  SortedList: TStringList;
begin
  // Open the "flying files" dialog deleting all files in the NamespaceArray
  ShFileOpStruct.Wnd := 0;
  ShFileOpStruct.wFunc := FO_DELETE;
  Files := '';

  SortedList := TStringList.Create;
  try
    SortedList.Sorted := True;
    for i := High(NamespaceArray) downto Low(NamespaceArray) do
    begin
      SortedList.Add(NamespaceArray[i].NameForParsing);
    end;

    // Files and folders must be deleted in a certain order. All files in a
    // folder must be deleted before the folder is deleted.
    for i := Pred(SortedList.Count) downto 0 do
    begin
      Files := Files + SortedList[i] + #0;
    end;
  finally

  end;
  ShFileOpStruct.pFrom := PChar(Files);
  ShFileOpStruct.pTo:= #0;
  ShFileOpStruct.fFlags := FOF_ALLOWUNDO or FOF_MULTIDESTFILES;
  Result := ShFileOperation(ShFileOpStruct) = 0;
end;


{TWndSearchFiles}

procedure TWndSearchFiles.BackgroundSearchFileMatch(Sender: TObject;
                          const Folder: string; const FileInfo: TSearchRec);
var
  Path: string;
begin
  (* Add only new files to the listview *)
  Path := IncludeTrailingPathDelimiter(Folder) + FileInfo.Name;

  if FSortedSearchResults.IndexOf(Path) = -1 then begin
    ExplicitSearchFileMatch(Sender, Folder, FileInfo);
  end;
end;

procedure TWndSearchFiles.BackgroundSearchFinished(Sender: TObject);
begin
  if FBackgroundUpdatedPaths.Count > 0 then
  begin
    // Remove the last updated path
    FBackgroundUpdatedPaths.Delete(0);
  end;

  if FBackgroundUpdatedPaths.Count > 0 then
  begin
    // Handle some paths that hasn't been handled yet
    StartUpdateInBackground;
  end;
end;

procedure TWndSearchFiles.Button_BrowseClick(Sender: TObject);
var
  Folder: string;
begin
  if Pos(';', Edit_Location.Text) = 0 then
    Folder := Edit_Location.Text;
  if SelectDirectory(Folder, [], 0) then
    Edit_Location.Text := Folder;
end;

procedure TWndSearchFiles.Button_FindClick(Sender: TObject);
begin
  // This variable is set to true when this explicit search has finished
  // without abortion.
  FCompleteSearchResultExists := False;

  // Clearing this list stops all background updates of the search list
  // initiated by notify events.
  FBackgroundUpdatedPaths.Clear;

  // Update some visual controls
  Button_Find.Enabled := False;
  Animate.Active := True;

  // Abort any executing background search operation. We are going to start a new search.
  if FFindFile.Busy then
  begin
    FFindFile.Abort;
    while FFindFile.Busy do Application.ProcessMessages;
  end;

  // This is an explicit file search. Set event handlers for the FindFile object
  FFindFile.OnFileMatch:= ExplicitSearchFileMatch;
  FFindFile.OnFolderChange:= ExplicitSearchFolderChange;
  FFindFile.OnSearchBegin:= ExplicitSearchBegin;
  FFindFile.OnSearchFinish:= ExplicitSearchFinish;

  // Fill other FindFile search properties

  // - Name & Location
  with FFindFile.Criteria.Files do
  begin
    FileName := Edit_Filename.Text;
    Location := Edit_Location.Text;
    FSearchPath:= SysUtils.AnsiLowerCase(Edit_Location.Text);
    Subfolders := CheckBox_IncludeSubfolders.Checked;
  end;
  // - Containing Text
  with FFindFile.Criteria.Content do
  begin
    Phrase := Edit_ContainingText.Text;
    IgnoreCase := CheckBox_CaseInsensitive.Checked;
  end;
  // - Attributes
  with FFindFile.Criteria.Attribute do
  begin
    Attributes := [];
    if CheckBox_AttributeArchive.Checked then
      Attributes := Attributes + [ffArchive];
    if CheckBox_AttributeReadonly.Checked then
      Attributes := Attributes + [ffReadonly];
    if CheckBox_AttributeHidden.Checked then
      Attributes := Attributes + [ffHidden];
    if CheckBox_AttributeSystem.Checked then
      Attributes := Attributes + [ffSystem];
    if CheckBox_AttributeDirectory.Checked then
      Attributes := Attributes + [ffDirectory];
    ExactMatch := CheckBox_AttributeExactMatch.Checked;
  end;
  // - Size ranges
  with FFindFile.Criteria.Size do
  begin
    Min := SpinEdit_SizeMin.Value * 1024; // KB -> byte
    Max := SpinEdit_SizeMax.Value * 1024; // KB -> byte
  end;
  // - TimeStamp ranges
  with FFindFile.Criteria.TimeStamp do
  begin
    AccessedBefore := 0;
    AccessedAfter := 0;
    ModifiedBefore := 0;
    ModifiedAfter := 0;
    CreatedBefore := 0;
    CreatedAfter := 0;
    case RadioGroup_DateSelection.ItemIndex of
      0: begin // Created on
           if CheckBox_BeforeDate.Checked then
             CreatedBefore := DateTimePicker_BeforeDate.Date;
           if CheckBox_BeforeTime.Checked then
             CreatedBefore := CreatedBefore + DateTimePicker_BeforeTime.Time;
           if CheckBox_AfterDate.Checked then
             CreatedAfter := DateTimePicker_AfterDate.Date;
           if CheckBox_AfterTime.Checked then
             CreatedAfter := CreatedAfter + DateTimePicker_AfterTime.Time;
         end;
      1: begin // Modified on
           if CheckBox_BeforeDate.Checked then
             ModifiedBefore := DateTimePicker_BeforeDate.Date;
           if CheckBox_BeforeTime.Checked then
             ModifiedBefore := ModifiedBefore + DateTimePicker_BeforeTime.Time;
           if CheckBox_AfterDate.Checked then
             ModifiedAfter := DateTimePicker_AfterDate.Date;
           if CheckBox_AfterTime.Checked then
             ModifiedAfter := ModifiedAfter + DateTimePicker_AfterTime.Time;
         end;
      2: begin // Last Accessed on
           if CheckBox_BeforeDate.Checked then
             AccessedBefore := DateTimePicker_BeforeDate.Date;
           if CheckBox_BeforeTime.Checked then
             AccessedBefore := AccessedBefore + DateTimePicker_BeforeTime.Time;
           if CheckBox_AfterDate.Checked then
             AccessedAfter := DateTimePicker_AfterDate.Date;
           if CheckBox_AfterTime.Checked then
             AccessedAfter := AccessedAfter + DateTimePicker_AfterTime.Time;
         end;
    end;
  end;

  Button_Stop.Enabled := True;

  // Start the search
  FFindFile.Execute;
end;

procedure TWndSearchFiles.Button_StopClick(Sender: TObject);
begin
  FFindFile.Abort;
end;

procedure TWndSearchFiles.CheckBox_BeforeDateClick(Sender: TObject);
begin
  DateTimePicker_BeforeDate.Enabled := CheckBox_BeforeDate.Checked;
end;

procedure TWndSearchFiles.CheckBox_BeforeTimeClick(Sender: TObject);
begin
  DateTimePicker_BeforeTime.Enabled := CheckBox_BeforeTime.Checked;
end;

procedure TWndSearchFiles.CheckBox_AfterDateClick(Sender: TObject);
begin
  DateTimePicker_AfterDate.Enabled := CheckBox_AfterDate.Checked;
end;

procedure TWndSearchFiles.CheckBox_AfterTimeClick(Sender: TObject);
begin
  DateTimePicker_AfterTime.Enabled := CheckBox_AfterTime.Checked;
end;

procedure TWndSearchFiles.ClipboardCopySelected(Sender: TCustomVirtualExplorerTree);
var
  PreferredDropEffect: TCommonPreferredDropEffect;
  DataObject: IDataObject;
begin
  PreferredDropEffect := TCommonPreferredDropEffect.Create;
  try
    PreferredDropEffect.Action := effectCopy;
    DataObject := CreateDataObjectOfSelected(Sender);
    PreferredDropEffect.SaveToDataObject(DataObject);
    OLESetClipboard(DataObject);
  finally
    PreferredDropEffect.Free;
  end
end;

procedure TWndSearchFiles.ClipboardCutSelected(Sender: TCustomVirtualExplorerTree);
var
  PreferredDropEffect: TCommonPreferredDropEffect;
  DataObject: IDataObject;
begin
  PreferredDropEffect := TCommonPreferredDropEffect.Create;
  try
    // Signal the Shell to do an optimized move, it will delete the files for us
    PreferredDropEffect.Action := effectMove;
    DataObject := CreateDataObjectOfSelected(Sender);
    PreferredDropEffect.SaveToDataObject(DataObject);
    OLESetClipboard(DataObject);
  finally
    PreferredDropEffect.Free;
  end
end;

function TWndSearchFiles.CreateDataObjectOfSelected(
                               Sender: TCustomVirtualExplorerTree): IDataObject;
var
  NSA: TNamespaceArray;
  HDrop: TCommonHDrop;
  FileList: TStringList;
  i: Integer;
begin
  NSA := Sender.SelectedToNamespaceArray;
  Result := TCommonDataObject.Create;
  HDrop := TCommonHDrop.Create;
  FileList := TStringList.Create;
  try
    for i := 0 to Length(NSA) - 1 do
      FileList.Add(NSA[i].NameForParsing);
    HDrop.AssignFilesA(FileList);
    HDrop.SaveToDataObject(Result)
  finally
    HDrop.Free;
    FileList.Free;
  end
end;

procedure TWndSearchFiles.ExplicitSearchBegin(Sender: TObject);
begin
  SearchResult.BeginUpdate;
  try
    SearchResult.Clear;
  finally
    SearchResult.EndUpdate;
  end;

  FFolderCount := 0;
  FStartTime := GetTickCount;
end;

procedure TWndSearchFiles.ExplicitSearchFileMatch(Sender: TObject;
                             const Folder: string; const FileInfo: TSearchRec);
var
  NS: TNamespace;
  PIDL: PItemIDList;
  Path: string;
begin
  (* Add all matching files to the listview *)
  Path := IncludeTrailingPathDelimiter(Folder) + FileInfo.Name;
  PIDL := PathToPIDL(Path);
  if Assigned(PIDL) then
  begin
    NS := TNamespace.Create(PIDL, nil);
    SearchResult.AddCustomNode(nil, NS, False);

    (* Keep a name copy of all files and folders in a sorted list. *)
    FSortedSearchResults.Add(Path);
  end;
end;

procedure TWndSearchFiles.ExplicitSearchFinish(Sender: TObject);
begin
  StatusBar.SimpleText := Format('%d folder(s) searched and %d file(s) found - %.3f second(s)',
    [FFolderCount, SearchResult.TotalCount, (GetTickCount - FStartTime) / 1000]);
  if FFindFile.Aborted then
    StatusBar.SimpleText := 'Search aborted - ' + StatusBar.SimpleText
  else
    FCompleteSearchResultExists := True;

  Animate.Active := False;
  Button_Stop.Enabled := False;
  Button_Find.Enabled := True;

  if (SearchResult.GetFirst <> nil) and (not SearchResult.Focused) then
  begin
    // Set focus and select the first item in search results
    SearchResult.SetFocus;
    SearchResult.FocusedNode := SearchResult.GetFirst;
    SearchResult.Selected[SearchResult.GetFirst] := True;
  end;
end;

procedure TWndSearchFiles.ExplicitSearchFolderChange(Sender: TObject; const Folder: string;
                                         var IgnoreFolder: TFolderIgnore);
begin
  Inc(FFolderCount);
  StatusBar.SimpleText := Folder;
end;

procedure TWndSearchFiles.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Clear event handlers. We do not want any new events from the
  // FindFile thread.
  FFindFile.OnFileMatch:= nil;
  FFindFile.OnFolderChange:= nil;
  FFindFile.OnSearchBegin:= nil;
  FFindFile.OnSearchFinish:= nil;

  // Abort any processing file search.
  if FFindFile.Busy then
    FFindFile.Abort;
end;

procedure TWndSearchFiles.FormCreate(Sender: TObject);
begin
  inherited;

  // Keep an alphabetically sorted list with all files in the search result.
  FSortedSearchResults := TStringList.Create;
  FSortedSearchResults.Sorted := True;

  // Create a list that may contain paths that must be updated in the background
  FBackgroundUpdatedPaths:= TStringList.Create;

  // Create the TFindFile object and set event handlers.
  FFindFile := TFindFile.Create(nil);
  FFindFile.Threaded := True;

  DateTimePicker_BeforeDate.Date := Date;
  DateTimePicker_BeforeDate.Time := 0;
  DateTimePicker_AfterDate.Date := Date;
  DateTimePicker_AfterDate.Time := 0;
  DateTimePicker_BeforeTime.Time := Time;
  DateTimePicker_BeforeTime.Date := 0;
  DateTimePicker_AfterTime.Time := Time;
  DateTimePicker_AfterTime.Date := 0;
end;

procedure TWndSearchFiles.FormDestroy(Sender: TObject);
begin
  // Wait until the thread in FindFile has finished before we exit the application
  while FFindFile.Busy do Application.ProcessMessages;

  // No one will destroy these objects for us. We have to do it.
  FreeAndNil(FFindFile);
  FreeAndNil(FSortedSearchResults);
  FreeAndNil(FBackgroundUpdatedPaths);

  inherited;
end;

procedure TWndSearchFiles.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Ignore refresh. Refresh clears the search result list.
  if Key = VK_F5 then
    Key := 0;
end;

procedure TWndSearchFiles.SearchResultHeaderRebuild(
  Sender: TCustomVirtualExplorerTree; Header: TVTHeader);
var
  Index : Integer;
  VETColumn : TVETColumn;
begin
  for Index := 0 to Pred(Header.Columns.Count) do
  begin
    VETColumn := TVETColumn(Header.Columns.Items[Index]);
    if VETColumn.ColumnDetails = cdPath then
    begin
      // Set PATH column as number two after FILENAME
      VETColumn.Options := VETColumn.Options + [coVisible];
      VETColumn.Position := 1;
      VETColumn.Width := 200;
    end;
    if VETColumn.ColumnDetails = cdSize then
    begin
      // Adjust the width of the SIZE column
      VETColumn.Width := 80;
    end;
  end;
end;

procedure TWndSearchFiles.SearchResultClipboardCopy(Sender: TCustomVirtualExplorerTree;
  var Handled: Boolean);
begin
  Handled := True;
  ClipboardCopySelected(Sender);
end;

procedure TWndSearchFiles.SearchResultClipboardCut(Sender: TCustomVirtualExplorerTree;
  var MarkSelectedCut, Handled: Boolean);
begin
  Handled := True;
  MarkSelectedCut := True;
  ClipboardCutSelected(Sender);
end;

procedure TWndSearchFiles.SearchResultCreateDataObject(Sender: TBaseVirtualTree;
  out IDataObject: IDataObject);
begin
  IDataObject := CreateDataObjectOfSelected(TCustomVirtualExplorerTree(Sender));
end;

procedure TWndSearchFiles.SearchResultClipboardPaste(Sender: TCustomVirtualExplorerTree;
  var Handled: Boolean);
begin
  // Paste is not possible. We don't have an explicit target folder.
  Handled := True;
end;

procedure TWndSearchFiles.SearchResultEnter(Sender: TObject);
begin
  PostMessage(Handle, WM_ENTERSEARCHRESULT, 0, 0);
end;

procedure TWndSearchFiles.SearchResultShellNotify(Sender: TCustomVirtualExplorerTree;
  ShellEvent: TVirtualShellEvent);
var
  BckUpdateActive: Boolean;
  NotifyPath: string;
begin
  // Don't allow VET to update the search list, we will do it.
  ShellEvent.Handled := True;

  // We only update the list if a complete search result exists.
  // The notification message must also concern a path included in the search
  NotifyPath := SysUtils.AnsiLowerCase(PIDLToPath(ShellEvent.PIDL1));
  if FCompleteSearchResultExists and (Pos(FSearchPath, NotifyPath) > 0) then
  begin
    BckUpdateActive := FBackgroundUpdatedPaths.Count > 0;
    FBackgroundUpdatedPaths.Add(NotifyPath);

    // We only handle one background update at the time
    if not BckUpdateActive then
      StartUpdateInBackground;
  end;
end;

procedure TWndSearchFiles.StartUpdateInBackground;
var
  i: Integer;
  Node: PVirtualNode;
  List: TList;
  NS: TNamespace;
begin
  // Update the search result according to changes in the file structure.

  Assert(FBackgroundUpdatedPaths.Count > 0, 'At least one path to update must exist');

  // Iterate the visible list view with search results
  // Non existsing files and folders shall be removed from the list view and
  // the parallell alphabetically sorted stringlist
  List := TList.Create;
  try
    Node := SearchResult.GetFirst;
    while Assigned(Node) do
    begin
      if SearchResult.ValidateNamespace(Node, NS) then
        if not (DirectoryExists(NS.NameForParsing) or
                FileExists(NS.NameForParsing))
        then begin
          List.Add(Node);

          i := FSortedSearchResults.IndexOf(NS.NameForParsing);
          if i <> - 1 then
            FSortedSearchResults.Delete(i);
        end;
      Node := SearchResult.GetNext(Node)
    end;

    SearchResult.BeginUpdate;
    try
      for i := 0 to List.Count - 1 do
        SearchResult.DeleteNode(PVirtualNode(List[i]));
    finally
      SearchResult.EndUpdate;
    end;
  finally
    List.Free;
  end;

  // Add new files to the search result
  if not FFindFile.Busy then
  begin
    FFindFile.OnFileMatch:= BackgroundSearchFileMatch;
    FFindFile.Threaded := False;
    FFindFile.OnFolderChange:= nil;
    FFindFile.OnSearchBegin:= nil;
    FFindFile.OnSearchFinish := BackgroundSearchFinished;
    FFindFile.Criteria.Files.Location := FBackgroundUpdatedPaths[0];
    FFindFile.Criteria.Files.Subfolders := False;
    FFindFile.Execute;
  end;
end;

procedure TWndSearchFiles.WMEnterSearchResult(var Message: TMessage);
begin
  // Entering the list view. Always select a node if a node exists.
  if SearchResult.Focused and (GetCaptureControl <> SearchResult) and
    (SearchResult.TotalCount > 0) and (SearchResult.SelectedPath = '') then
  begin
    if Assigned(SearchResult.FocusedNode) then
      SearchResult.Selected[SearchResult.FocusedNode] := True
    else
      SearchResult.Selected[SearchResult.GetFirst] := True;
  end;
end;

procedure TWndSearchFiles.SearchResultContextMenuCmd(
  Sender: TCustomVirtualExplorerTree; Namespace: TNamespace;
  Verb: string; MenuItemID: Integer; var Handled: Boolean);
var
  NSA: TNamespaceArray;
  i: Integer;
begin
  NSA := nil;  // Avoid compiler warning. Don't know why this is needed!

  if Verb = 'delete' then
  begin
    Handled := True;
    NSA := Sender.SelectedToNamespaceArray;
    DeleteFiles(NSA);
  end;

  if Verb = 'copy' then
  begin
    Handled := True;
    ClipboardCopySelected(Sender);
  end;

  if Verb = 'cut' then
  begin
    Handled := True;
    ClipboardCutSelected(Sender);
  end;

  if Verb = 'link' then
  begin
    Handled := True;
    NSA := Sender.SelectedToNamespaceArray;

    if MessageDlg('It isn''t possible to create shortcuts here.'#13#10'' +
                  'Do you want to create shortcuts on the desktop instead?',
                  mtWarning, [mbYes, mbNo], 0) = mrYes
    then begin
      for i := Low(NSA) to High(NSA) do begin
        NSA[i].ShellLink.TargetPath := NSA[i].NameForParsing;
        NSA[i].ShellLink.IconLocation := NSA[i].NameForParsing;
        NSA[i].ShellLink.WriteLink(
          NewShortcutNameW(DeskTopFolder.NameForParsing,
                           ExtractFileName(NSA[i].NameForParsing)));
      end;
    end;
  end;

  if Verb = 'properties' then
  begin
    Handled := True;
    NSA := Sender.SelectedToNamespaceArray;
    Namespace.ShowPropertySheetMulti(Sender, NSA);
  end;

  if Verb = 'open' then
  begin
    Handled := True;
    NSA := Sender.SelectedToNamespaceArray;
    for I := Low(NSA) to High(NSA) do
      NSA[I].ShellExecuteNamespace('', '');
  end;

  if Verb = '' then
  begin
//  WinZip and other apps in context menu. ???
  end;

//  if Verb = 'open', 'open with' 'sendto' isn't handled yet if at all

end;

end.
