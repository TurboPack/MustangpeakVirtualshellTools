unit VirtualCheckboxesSynchronizer;

{==============================================================================
Version 0.8

Software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
either express or implied.
The initial developer of this code is Robert Lee.

Requirements:
  toAutoTristateTracking must be disabled!!!!!!!!!

History:
23 June 2005 - version 0.8
  - Fixed incorrect item display, the Network was not visible in the Tree.

21 December 2004 - version 0.7
  - Fixed incorrect ListView sync when a VELVEx is used, thanks to
    Gabriel Cristescu for reporting this.

12 November 2003 - version 0.6
  - Fixed incorrect Tree item TristateTrack when the Listview root was not
    expanded in the Tree, thanks to Bill Mudd.

17 September 2003 - version 0.5
  - Fixed incorrect expand buttons caused by VSTools 1.1.11

17 September 2003 - version 0.4
  - Bug fixed, when the Tree node is expanded all it's children will be updated.
  - Changed lstrcmpiW_VST call to StrICompW, W9x doesn't support lstrcmpiW.
  - Changed the parameter of SetCheckedFileNames to TWideStringList.
  - Added AutoSetupEvents property, it setups the required events of the Tree
    and Listview.

23 November 2002 - version 0.3
  - Changed the storage method, the Treeview now holds the main storage.
  - SetCheckedFileNames now works as expected, the nodes of the files to be
    checked doesn't have to be initialized now.

21 November 2002 - version 0.2
  - Minor bug fixes.

20 November 2002 - version 0.1
  - Wrapped the whole synchronization mechanism in a component

==============================================================================}

interface

{.$DEFINE TNTSUPPORT}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ShlObj, VirtualTrees, VirtualExplorerTree, MPShellUtilities,
  {$IFDEF TNTSUPPORT}
  TntClasses,
  TntSysUtils,
  TntWideStrings,
  {$ENDIF}
  FileCtrl,
  VirtualResources,
  MPCommonObjects,
  MPCommonUtilities;

type
  TVirtualCheckboxesSynchronizer = class(TComponent)
  private
    FTree: TVirtualExplorerTreeview;
    FList: TVirtualExplorerListview;

    FOldTreeOnInitNode: TVTInitNodeEvent;
    FOldTreeOnChecked: TVTChangeEvent;
    FOldTreeOnExpanded: TVTChangeEvent;
    FOldTreeOnEnumFolder: TVETOnEnumFolder;

    FOldListOnInitNode: TVTInitNodeEvent;
    FOldListOnChecked: TVTChangeEvent;
    FOldListOnRootChange: TVETOnRootChange;

    FAutoSetupEvents: Boolean;
    FHideTreeFiles: Boolean;

    procedure SetVirtualExplorerListview(const Value: TVirtualExplorerListview);
    procedure SetVirtualExplorerTreeview(const Value: TVirtualExplorerTreeview);
    procedure SetAutoSetupEvents(const Value: Boolean);
    procedure SetHideTreeFiles(const Value: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetupEvents(Reset: Boolean = false); virtual;

    //Tree Events
    procedure TreeOnInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates); virtual;
    procedure TreeOnChecked(Sender: TBaseVirtualTree; Node: PVirtualNode); virtual;
    procedure TreeOnExpanded(Sender: TBaseVirtualTree; Node: PVirtualNode); virtual;
    procedure TreeOnEnumFolder(Sender: TCustomVirtualExplorerTree; Namespace: TNamespace;
      var AllowAsChild: Boolean); virtual;

    //List Events
    procedure ListOnInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates); virtual;
    procedure ListOnChecked(Sender: TBaseVirtualTree; Node: PVirtualNode); virtual;
    procedure ListOnRootChange(Sender: TCustomVirtualExplorerTree); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {$IFDEF TNTSUPPORT}
    procedure GetCheckedFileNames(AStrings: TWideStrings; AllChecked: Boolean = False);
    procedure SetCheckedFileNames(AStrings: TWideStrings);
    procedure GetResolvedFileNames(AStrings: TWideStrings);
    {$ELSE}
    procedure GetCheckedFileNames(AStrings: TStrings; AllChecked: Boolean = False);
    procedure SetCheckedFileNames(AStrings: TStrings);
    procedure GetResolvedFileNames(AStrings: TStrings); 
    {$ENDIF}
    function SyncCheckedNode(CheckedOnTree: boolean; SourceNode: PVirtualNode): boolean;
    procedure UpdateListView;
  published
    property AutoSetupEvents: Boolean read FAutoSetupEvents write SetAutoSetupEvents default True;
    property HideTreeFiles: Boolean read FHideTreeFiles write SetHideTreeFiles default True;
    property VirtualExplorerTreeview: TVirtualExplorerTreeview read FTree write SetVirtualExplorerTreeview;
    property VirtualExplorerListview: TVirtualExplorerListview read FList write SetVirtualExplorerListview;
  end;

function IsFolder(NS: TNamespace; IncludeMyComputer: Boolean = false;
  IncludeNetwork: Boolean = false; IncludeZipFolders: Boolean = false): Boolean;
function IsFile(NS: TNamespace): Boolean;
function ForceInit(VT: TBaseVirtualTree; Node: PVirtualNode): Boolean;
function FindNodeByFilename(VET: TVirtualExplorerTreeview; Filename: WideString;
  StartingPoint: PVirtualNode = nil): PVirtualNode;

function CheckStateTrack(Node: PVirtualNode): TCheckState;
{$IFDEF TNTSUPPORT}
procedure GetCheckedFileNames(VET: TCustomVirtualExplorerTree; AStrings: TWideStrings; AllChecked: Boolean = False); 
{$ELSE}
procedure GetCheckedFileNames(VET: TCustomVirtualExplorerTree; AStrings: TStrings; AllChecked: Boolean = False); 
{$ENDIF}

procedure ManualCheck(PIDL: PItemIDList; RootStorage: TRootNodeStorage; CheckType: TCheckType; CheckState: TCheckState); overload;
procedure ManualCheck(VET: TCustomVirtualExplorerTree; Node: PVirtualNode; CheckType: TCheckType; CheckState: TCheckState); overload;
procedure ManualTristateTrack(VET: TCustomVirtualExplorerTree; SyncList: TVirtualExplorerListview;
  N: PVirtualNode; CheckParents, CheckChilds: Boolean; AutoInit: Boolean = False);
function TreeCheck(VET, SyncVET: TCustomVirtualExplorerTree; NodeNS: TNamespace; CheckType: TCheckType; CheckState: TCheckState): boolean;

implementation

uses Math;

type
  TVTCrack = class(TBaseVirtualTree);

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Helpers }

function IsFolder(NS: TNamespace; IncludeMyComputer: Boolean = false;
  IncludeNetwork: Boolean = false; IncludeZipFolders: Boolean = false): Boolean;
begin
  Result := NS.Folder and
           (NS.FileSystem or (IncludeMyComputer and NS.IsMyComputer) or
           (IncludeNetwork and (NS.IsNetworkNeighborhood or NS.IsNetworkNeighborhoodChild))) and
           (IncludeZipFolders or (NS.Extension <> '.zip'));
end;

function IsFile(NS: TNamespace): boolean;
begin
  Result := (not NS.Folder and NS.FileSystem) or (NS.Extension = '.zip');
end;

function ForceInit(VT: TBaseVirtualTree; Node: PVirtualNode): Boolean;
//Initialize child nodes if needed
begin
  Result := (vsHasChildren in Node.States) and (Node.ChildCount = 0);
  if Result then
    VT.ReinitChildren(Node, false);
end;

function FindNodeByFilename(VET: TVirtualExplorerTreeview; Filename: WideString;
  StartingPoint: PVirtualNode): PVirtualNode;
//Finds the corresponding Node of a given Filename in the Tree.
//It's the same as VET.FindNode method, but it searches through uninitialized Parent Nodes.

  function FindNamespace(ParentNode: PVirtualNode; Filename: WideString): PVirtualNode;
  var
    N: PVirtualNode;
    NS: TNamespace;
  begin
    Result := nil;
    //Iterate the Tree
    N := ParentNode.FirstChild;
    while Assigned(N) do
    begin
      if VET.ValidateNamespace(N, NS) then
        if WideStrIComp(PWideChar(NS.NameForParsing), PWideChar(Filename)) = 0 then
        begin
          Result := N;
          Exit; //found it, get out of here
        end;
      N := N.NextSibling;
    end;
  end;

var
  N: PVirtualNode;
  I: integer;
  {$IFDEF TNTSUPPORT}
  L: TTntStringList;
  {$ELSE}
  L: TStringList;
  {$ENDIF}

  WS: WideString;
begin
  Result := nil;
  if not Assigned(VET) or (not WideDirectoryExists(Filename) and not WideFileExists(Filename)) then Exit;

  if not Assigned(StartingPoint) then
    StartingPoint := VET.FindNodeByPIDL(DrivesFolder.AbsolutePIDL); //default to MyComputer

  {$IFDEF TNTSUPPORT}
  L := TTntStringList.Create;
  {$ELSE}
  L := TStringList.Create;
  {$ENDIF}
  try
    //Parse the Filename and get the list of drive/folders/file that compose the Filename
    WS := Filename;
    L.Insert(0, WS);
    while Length(WS) > 3 do
    begin
      WS := WideExtractFileDir(WS);
      L.Insert(0, WS);
    end;

    N := StartingPoint;
    for I := 0 to L.count -1 do
    begin
      //Initialize child nodes if needed
      ForceInit(VET, N);

      //Iterate the Tree
      N := FindNamespace(N, L[I]);
      if not Assigned(N) then
        Exit; //no luck
    end;

    if Assigned(N) then
      Result := N;
  finally
    L.Free;
  end;
end;

function CheckStateTrack(Node: PVirtualNode): TCheckState;
//Gets the CheckState a Node should have, taking into account the CheckedState of its children
var
  ChildNode: PVirtualNode;
  CheckedCount, UnCheckedCount: integer;
begin
  Result := csUncheckedNormal;
  if not Assigned(Node) then exit;

  CheckedCount := 0;
  UnCheckedCount := 0;

  ChildNode := Node.FirstChild;
  while Assigned(ChildNode) do
  begin
    if ChildNode.CheckState = csMixedNormal then
    begin
      Result := csMixedNormal;
      Exit; //get out of here
    end
    else
      if ChildNode.CheckState = csUncheckedNormal then
        Inc(UnCheckedCount)
      else
        Inc(CheckedCount);

    ChildNode := ChildNode.NextSibling;
  end;

  if UnCheckedCount = 0 then
    Result := csCheckedNormal
  else
    if CheckedCount = 0 then
      Result := csUncheckedNormal
    else
      Result := csMixedNormal;
end;

{$IFDEF TNTSUPPORT}
procedure GetCheckedFileNames(VET: TCustomVirtualExplorerTree; AStrings: TWideStrings; AllChecked: Boolean = False);
  procedure RecurseInit(Node: PVirtualNode);
  //Checks and initializes all the required nodes on the tree
  begin
    while Assigned(Node) do
    begin
      if Node.ChildCount > 0 then
        RecurseInit(Node.FirstChild);
      if Node.CheckState = csCheckedNormal then
        ManualTristateTrack(VET, nil, Node.Parent, false, true, AllChecked); //update childs
      Node := Node.NextSibling;
    end;
  end;
begin
  RecurseInit(VET.GetFirst);
  AStrings.Assign(VET.Storage.CheckedFileNames);
end;
{$ELSE}
procedure GetCheckedFileNames(VET: TCustomVirtualExplorerTree; AStrings: TStrings; AllChecked: Boolean = False);
  procedure RecurseInit(Node: PVirtualNode);
  //Checks and initializes all the required nodes on the tree
  begin
    while Assigned(Node) do
    begin
      if Node.ChildCount > 0 then
        RecurseInit(Node.FirstChild);
      if Node.CheckState = csCheckedNormal then
        ManualTristateTrack(VET, nil, Node.Parent, false, true, AllChecked); //update childs
      Node := Node.NextSibling;
    end;
  end;
begin
  RecurseInit(VET.GetFirst);
  AStrings.Assign(VET.Storage.CheckedFileNames);
end;
{$ENDIF}


procedure ManualCheck(PIDL: PItemIDList; RootStorage: TRootNodeStorage;
  CheckType: TCheckType; CheckState: TCheckState);
//Adds or Deletes a PIDL from the RootStorage
var
  StorageNode: TNodeStorage;
begin
  if CheckState <> csUncheckedNormal then
  begin
    //Add the PIDL to the RootStorage with the CheckType and CheckState
    StorageNode := RootStorage.Store(PIDL, [stChecks]);
    if Assigned(StorageNode) then
    begin
      StorageNode.Storage.Check.CheckType := CheckType;
      StorageNode.Storage.Check.CheckState := CheckState;
    end;
  end
  else
    RootStorage.Delete(PIDL, [stChecks]); //Delete the PIDL from the RootStorage
end;

procedure ManualCheck(VET: TCustomVirtualExplorerTree; Node: PVirtualNode;
  CheckType: TCheckType; CheckState: TCheckState);
//Adds or Deletes a Node from the RootStorage
var
  NS: TNamespace;
begin
  if VET.ValidateNamespace(Node, NS) then
  begin
    //first make the changes
    Node.CheckType := CheckType;
    Node.CheckState := CheckState;
    //work with the main storage
    ManualCheck(NS.AbsolutePIDL, VET.Storage, CheckType, CheckState);
    VET.InvalidateNode(Node);
  end;
end;

procedure ManualTristateTrack(VET: TCustomVirtualExplorerTree;
  SyncList: TVirtualExplorerListview; N: PVirtualNode; CheckParents, CheckChilds: Boolean; AutoInit: Boolean = False);
// Use this procedure when toAutoTristateTracking is off and you want to manually
// update parents/childrens check states

  //--------------- local function --------------------------------------------
  procedure CheckParent(Node: PVirtualNode);
  var
    ParentNode: PVirtualNode;
    NS: TNamespace;
    ChildIsMixed: boolean;
  begin
    ParentNode := Node.Parent;
    ChildIsMixed := N.CheckState = csMixedNormal; //robert false;
    while Assigned(ParentNode) and (ParentNode <> VET.RootNode) do
    begin
      if ChildIsMixed then
        ParentNode.CheckState := csMixedNormal
      else begin
        ParentNode.CheckState := CheckStateTrack(ParentNode);
        ChildIsMixed := ParentNode.CheckState = csMixedNormal;
      end;

      ManualCheck(VET, ParentNode, ParentNode.CheckType, ParentNode.CheckState);

      if Assigned(SyncList) and VET.ValidateNamespace(ParentNode, NS) then
        TreeCheck(SyncList, VET, NS, ParentNode.CheckType, ParentNode.CheckState);

      ParentNode := ParentNode.Parent;
    end;
  end;
  //--------------- local function --------------------------------------------
  procedure CheckChildren(Node: PVirtualNode);
  var
    ChildNode: PVirtualNode;
  begin
    Case Node.CheckState of
      csUncheckedNormal, csCheckedNormal:
        begin
          ChildNode := Node.FirstChild;
          while Assigned(ChildNode) do
          begin
            if AutoInit then
              ForceInit(VET, ChildNode);
            ManualCheck(VET, ChildNode, ctTriStateCheckBox, Node.CheckState);
            if ChildNode.ChildCount > 0 then
              CheckChildren(ChildNode);
            ChildNode := ChildNode.NextSibling;
          end;
        end;
    end;
  end;
  //--------------- end local function ----------------------------------------
begin
  if not Assigned(N) then Exit;
  //Since toAutoTristateTracking is off, update parents/children
  if CheckParents then
    CheckParent(N);
  if CheckChilds then
    CheckChildren(N);
end;

function TreeCheck(VET, SyncVET: TCustomVirtualExplorerTree; NodeNS: TNamespace;
  CheckType: TCheckType; CheckState: TCheckState): boolean;
var
  N, ParentNode: PVirtualNode;
  Valid: boolean;
  SysList: TVirtualExplorerListview;
begin
  Result := false;
  //Find the Node in the VET
  N := VET.FindNodeByPIDL(NodeNS.AbsolutePIDL);
  Valid := Assigned(N) and (N <> VET.RootNode);

  if not Valid and Assigned(NodeNS.Parent) then
  begin
    // We couldn't find the node in DestVET, maybe the node it's not initialized...
    ParentNode := VET.FindNodeByPIDL(NodeNS.Parent.AbsolutePIDL); //get the parent
    if Assigned(ParentNode) then
      ForceInit(VET, ParentNode);  //Initialize child nodes if needed
    //Try again...
    //Find the Node in the DestVET
    N := VET.FindNodeByPIDL(NodeNS.AbsolutePIDL);
    Valid := Assigned(N) and (N <> VET.RootNode);
  end;
  if Valid then
  begin
    ForceInit(VET, N);  //Initialize child nodes if needed
    ManualCheck(VET, N, CheckType, CheckState);

    if (VET is TVirtualExplorerTreeview) then
    begin
      //Since toAutoTristateTracking is off, update parents/children
      if Assigned(SyncVET) and (SyncVET is TVirtualExplorerListview) then
        SysList := SyncVET as TVirtualExplorerListview
      else
        SysList := nil;
      ManualTristateTrack(VET as TVirtualExplorerTreeview, SysList, N, true, true);
    end;

    Result := true;
  end;
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ TVirtualCheckboxesSynchronizer }

constructor TVirtualCheckboxesSynchronizer.Create(AOwner: TComponent);
begin
  inherited;
  FAutoSetupEvents := true;
  FHideTreeFiles := true;

  FOldTreeOnExpanded := nil;
  FOldTreeOnChecked := nil;
  FOldListOnChecked := nil;
  FOldListOnRootChange := nil;
end;

destructor TVirtualCheckboxesSynchronizer.Destroy;
begin
  FOldTreeOnExpanded := nil;
  FOldTreeOnChecked := nil;
  FOldListOnChecked := nil;
  FOldListOnRootChange := nil;

  inherited;
end;

procedure TVirtualCheckboxesSynchronizer.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
    if AComponent = FTree then FTree := nil
    else
      if AComponent = FList then FList := nil;
end;

procedure TVirtualCheckboxesSynchronizer.TreeOnInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NS: TNamespace;
begin
  Node.CheckType := ctTriStateCheckBox;

  //Hide the file nodes, the Tree must enumerate ALL file and folders
  if FTree.ValidateNamespace(Node, NS) then
  begin
    if IsFile(NS) then begin
      if FHideTreeFiles then begin
        Exclude(Node.States, vsVisible);
        TVTCrack(FTree).DetermineHiddenChildrenFlag(Node.Parent);
      end;
    end
    else
      //If the folder doesn't have any subfolders hide all it's children
      //We don't want to see the expand buttons next to it
      //toAutoHideButtons must be enabled, this is automatically done by VCS
      if IsFolder(NS, true, true) and (Node <> FTree.RootNode) and (foNonFolders in FTree.FileObjects) then
        if not NS.HasSubFolder then
          Include(Node.States, vsAllChildrenHidden);
  end;

  if Assigned(FOldTreeOnInitNode) then FOldTreeOnInitNode(Sender, ParentNode, Node, InitialStates);
end;

procedure TVirtualCheckboxesSynchronizer.TreeOnChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  SyncCheckedNode(true, Node);
  if Assigned(FOldTreeOnChecked) then FOldTreeOnChecked(Sender, Node);
end;

procedure TVirtualCheckboxesSynchronizer.TreeOnExpanded(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  ManualTristateTrack(FTree, FList, Node, false, true);  //update childs
  if Assigned(FOldTreeOnExpanded) then FOldTreeOnExpanded(Sender, Node);
end;

procedure TVirtualCheckboxesSynchronizer.TreeOnEnumFolder(Sender: TCustomVirtualExplorerTree;
  Namespace: TNamespace; var AllowAsChild: Boolean);
begin
  //The Tree must enumerate ALL file and folders
  AllowAsChild := IsFile(Namespace) or IsFolder(Namespace, true, true);
  If Assigned(FOldTreeOnEnumFolder) then FOldTreeOnEnumFolder(Sender, Namespace, AllowAsChild);
end;

procedure TVirtualCheckboxesSynchronizer.ListOnInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctTriStateCheckBox;
  if Assigned(FOldListOnInitNode) then FOldListOnInitNode(Sender, ParentNode, Node, InitialStates);
end;

procedure TVirtualCheckboxesSynchronizer.ListOnChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  SyncCheckedNode(false, Node);
  if Assigned(FOldListOnChecked) then FOldListOnChecked(Sender, Node);
end;

procedure TVirtualCheckboxesSynchronizer.ListOnRootChange(Sender: TCustomVirtualExplorerTree);
begin
  UpdateListView;  //update listview nodes
  if Assigned(FOldListOnRootChange) then FOldListOnRootChange(Sender);
end;

procedure TVirtualCheckboxesSynchronizer.SetVirtualExplorerTreeview(const Value: TVirtualExplorerTreeview);
begin
  FTree := Value;
  if Value <> nil then
  begin
    Value.FreeNotification(Self);
    Value.FileObjects := [foFolders, foNonFolders, foHidden];  //It must enumerate ALL shell objects
    Value.TreeOptions.AutoOptions := Value.TreeOptions.AutoOptions - [toAutoTristateTracking] + [toAutoHideButtons];
    Value.TreeOptions.MiscOptions := Value.TreeOptions.MiscOptions + [toCheckSupport];
    FOldTreeOnInitNode := FTree.OnInitNode;
    FOldTreeOnChecked := FTree.OnChecked;
    FOldTreeOnExpanded := FTree.OnExpanded;
    FOldTreeOnEnumFolder := FTree.OnEnumFolder;
    if FAutoSetupEvents then begin
      if Value.Active then begin
        Value.Active := false;
        SetupEvents;
        Value.Active := true;
      end
      else
        SetupEvents;
    end;
  end;
end;

procedure TVirtualCheckboxesSynchronizer.SetVirtualExplorerListview(const Value: TVirtualExplorerListview);
begin
  FList := Value;
  if Value <> nil then
  begin
    Value.FreeNotification(Self);
    Value.FileObjects := [foFolders, foNonFolders, foHidden];  //It must enumerate ALL shell objects
    Value.TreeOptions.AutoOptions := Value.TreeOptions.AutoOptions - [toAutoTristateTracking] + [toAutoHideButtons];
    Value.TreeOptions.MiscOptions := Value.TreeOptions.MiscOptions + [toCheckSupport];
    FOldListOnInitNode := FList.OnInitNode;
    FOldListOnChecked := FList.OnChecked;
    FOldListOnRootChange := FList.OnRootChange;
    if FAutoSetupEvents then begin
      if Value.Active then begin
        Value.Active := false;
        SetupEvents;
        Value.Active := true;
      end
      else
        SetupEvents;
    end;
  end;
end;

procedure TVirtualCheckboxesSynchronizer.SetAutoSetupEvents(const Value: Boolean);
begin
  if FAutoSetupEvents <> Value then begin
    FAutoSetupEvents := Value;
    SetupEvents(Value);
  end;
end;

procedure TVirtualCheckboxesSynchronizer.SetHideTreeFiles(const Value: Boolean);
begin
  if FHideTreeFiles <> Value then begin
    FHideTreeFiles := Value;
  end;
end;

procedure TVirtualCheckboxesSynchronizer.SetupEvents(Reset: Boolean = false);
begin
  if Reset then begin
    if Assigned(FTree) then begin
      FTree.OnInitNode := FOldTreeOnInitNode;
      FTree.OnChecked := FOldTreeOnChecked;
      FTree.OnExpanded := FOldTreeOnExpanded;
      FTree.OnEnumFolder := FOldTreeOnEnumFolder;
    end;
    if Assigned(FList) then begin
      FList.OnInitNode := FOldListOnInitNode;
      FList.OnChecked := FOldListOnChecked;
      FList.OnRootChange := FOldListOnRootChange;
    end;
  end
  else begin
    if Assigned(FTree) then begin
      FTree.OnInitNode := TreeOnInitNode;
      FTree.OnChecked := TreeOnChecked;
      FTree.OnExpanded := TreeOnExpanded;
      FTree.OnEnumFolder := TreeOnEnumFolder;
    end;
    if Assigned(FList) then begin
      FList.OnInitNode := ListOnInitNode;
      FList.OnChecked := ListOnChecked;
      FList.OnRootChange := ListOnRootChange;
    end;
  end;
end;

function TVirtualCheckboxesSynchronizer.SyncCheckedNode(CheckedOnTree: boolean; SourceNode: PVirtualNode): boolean;
// This function will find SourceNode in the DestVET and will check/uncheck it
var
  SourceNS: TNamespace;
begin
  Result := false;
  if not Assigned(SourceNode) then Exit;

  if CheckedOnTree then
  begin
    if Assigned(FTree) and FTree.ValidateNamespace(SourceNode, SourceNS) then
    begin
      //First Check it in the Tree
      Result := TreeCheck(FTree, FList, SourceNS, SourceNode.CheckType, SourceNode.CheckState);
      if Assigned(FList) then begin
        //Sync the List
        ManualCheck(SourceNS.AbsolutePIDL, FList.Storage, SourceNode.CheckType, SourceNode.CheckState);
        //Update the listview
        UpdateListView;
      end;
    end;
  end
  else
    if Assigned(FList) and FList.ValidateNamespace(SourceNode, SourceNS) then
      //Sync the Tree
      Result := TreeCheck(FTree, FList, SourceNS, SourceNode.CheckType, SourceNode.CheckState);
end;

procedure TVirtualCheckboxesSynchronizer.UpdateListView;
var
  ListNode, TreeNode: PVirtualNode;
  ListNS: TNamespace;
begin
  if not Assigned(FTree) or not Assigned(FList) then Exit;

  FList.BeginUpdate;
  try
    ListNode := FList.GetFirst;
    if FList.ValidateNamespace(ListNode, ListNS) then
    begin
      // get parent of first node in listview
      ListNS := ListNS.Parent;
      TreeNode := FTree.FindNodeByPIDL(ListNS.AbsolutePIDL);
      if Assigned(TreeNode) then
      begin
        if ForceInit(FTree, TreeNode) then
          ManualTristateTrack(FTree, FList, TreeNode, false, true);  //update childs

        Case FTree.CheckState[TreeNode] of
          csCheckedNormal, csUncheckedNormal: // check/uncheck all nodes in listview
            while Assigned(ListNode) do
            begin
              ListNode.CheckState := TreeNode.CheckState;
              FList.InvalidateNode(ListNode);
              ListNode := FList.GetNextSibling(ListNode);
            end;
          csMixedNormal:
            begin
              ForceInit(FTree, TreeNode);
              while FList.ValidateNamespace(ListNode, ListNS) do //iterate and check/uncheck nodes
              begin
                TreeNode := FTree.FindNodeByPIDL(ListNS.AbsolutePIDL);
                if Assigned(TreeNode) then
                  ManualCheck(FList, ListNode, TreeNode.CheckType, TreeNode.CheckState);
                ListNode := FList.GetNextSibling(ListNode);
              end;
            end;
        end;
      end;
    end;
  finally
    FList.EndUpdate
  end;
end;

{$IFDEF TNTSUPPORT}
procedure TVirtualCheckboxesSynchronizer.SetCheckedFileNames(AStrings: TWideStrings);
var
  I: integer;
  Node: PVirtualNode;
begin
  if not Assigned(FTree) then Exit;

  FTree.BeginUpdate;
  try
    //Clear all checked nodes, and clear the storage
    FTree.GetFirst.CheckState := csUncheckedNormal;
    SyncCheckedNode(True, FTree.GetFirst);

    //Iterate the checked files list
    for i := 0 to AStrings.Count - 1 do
    begin
      Node := FindNodeByFilename(FTree, AStrings[I]);
      if Assigned(Node) then
      begin
        Node.CheckState := csCheckedNormal;
        SyncCheckedNode(True, Node);
      end;
    end;
  finally
    FTree.EndUpdate;
  end;
end;
{$ELSE}
procedure TVirtualCheckboxesSynchronizer.SetCheckedFileNames(AStrings: TStrings);
var
  I: integer;
  Node: PVirtualNode;
begin
  if not Assigned(FTree) then Exit;

  FTree.BeginUpdate;
  try
    //Clear all checked nodes, and clear the storage
    FTree.GetFirst.CheckState := csUncheckedNormal;
    SyncCheckedNode(True, FTree.GetFirst);

    //Iterate the checked files list
    for i := 0 to AStrings.Count - 1 do
    begin
      Node := FindNodeByFilename(FTree, AStrings[I]);
      if Assigned(Node) then
      begin
        Node.CheckState := csCheckedNormal;
        SyncCheckedNode(True, Node);
      end;
    end;
  finally
    FTree.EndUpdate;
  end;
end;
{$ENDIF}


{$IFDEF TNTSUPPORT}
procedure TVirtualCheckboxesSynchronizer.GetCheckedFileNames(AStrings: TWideStrings; AllChecked: Boolean = False);
begin
  VirtualCheckboxesSynchronizer.GetCheckedFileNames(FTree, AStrings, AllChecked);
end;
{$ELSE}
procedure TVirtualCheckboxesSynchronizer.GetCheckedFileNames(AStrings: TStrings; AllChecked: Boolean = False);
begin
  VirtualCheckboxesSynchronizer.GetCheckedFileNames(FTree, AStrings, AllChecked);
end;
{$ENDIF}

{$IFDEF TNTSUPPORT}
procedure TVirtualCheckboxesSynchronizer.GetResolvedFileNames(AStrings: TWideStrings);
begin
  AStrings.Assign(FTree.Storage.ResolvedFileNames);
end;
{$ELSE}
procedure TVirtualCheckboxesSynchronizer.GetResolvedFileNames(AStrings: TStrings);
begin
  AStrings.Assign(FTree.Storage.ResolvedFileNames);
end;
{$ENDIF}


end.
