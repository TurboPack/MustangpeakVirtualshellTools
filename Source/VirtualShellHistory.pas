unit VirtualShellHistory;

// Version 2.4.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
//----------------------------------------------------------------------------

//The initial developer of this code is Robert Lee.


{

Requirements:
  - Mike Lischke's Virtual Treeview (VT)
    http://www.lischke-online.de/VirtualTreeview/VT.html
  - Jim Kuenaman's Virtual Shell Tools
    http://groups.yahoo.com/group/VirtualExplorerTree

Credits:
  Special thanks to Mike Lischke (VT) and Jim Kuenaman (VSTools) for the
  magnificent components they have made available to the Delphi community.

How to use:
  VirtualShellHistory is basically a History manager, it keeps an array of
  TNamespaces that the attached VET control has been navigating.
  To use it just attach a VirtualExplorerTree to the VET property and use the
  following methods or properties:
  - Back/Next: to move to the previous or next directory.
  - FillPopupMenu: fills a TPopupMenu to mimic the Explorer's Back and Next Buttons PopupMenu.
  - Add, Delete, Clear, Count, Items, ItemIndex: to manage the items.
  - MaxCount: maximum items capacity.

Todo:
  -
Known issues:
  -

History:
30 June 2006 - version 0.5
  - Removed USE_TOOLBAR_TBX compiler define, for TB2K, TBX and SpTBXLib
    support just define USE_TOOLBAR_TB2K in VSToolsAddIns.inc

12 April 2004 - version 0.4
  - Fixed recursion bug, the itemchange was dispatched to the VET control for
    every item when the items were loaded from file.
  - Added unicode support for TBX items.
  - The component automatically deletes invalid namespaces when the itemindex is
    changed and generates an OnChanged event with hctInvalidSelected as the
    parameter.

5 September 2002 - version 0.3.1
  - Added an extra check to LoadFromRegistry and fixed a problem with setting
    the focus to the ActiveControl, thanks to Ebi.

16 July 2002 - version 0.3
  - Robert debugged my changes and I added a Most Recently Used layer to the class
  - Added Support for Toolbar 2000 and TBX Toolbar

14 July 2002 - version 0.2  (Jim Kueneman)
  - Finshed Component and added to VirtualShellTools package
  - Added more options such as using the entire path, images, etc in the popupmenu

13 July 2002 - version 0.1  (Robert Lee)
  - First release, with a lousy unicode support.

==============================================================================}

interface

{$include ..\Include\AddIns.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Menus, VirtualExplorerTree, MPShellUtilities,
  ShlObj, ShellAPI, CommCtrl, ImgList,
  MPCommonUtilities, MPCommonObjects,
  VirtualResources,
  {$IFDEF USE_TOOLBAR_TB2K}
  TB2Item,
  {$ENDIF}
  Registry;

const
  REGISTRYDATASIZE = 'VirtualShellHistoryMRUSize';
  REGISTRYDATA = 'VirtualShellHistoryMRUData';

type
  TVSHChangeType = (
    hctAdded,           // A path was added to the history list
    hctDeleted,         // A path was deleted from the history list
    hctSelected,        // A path was selected
    hctInvalidSelected  // An invalid path was selected
  );

  TVSHMenuTextType = (
    mttName, // Simple in folder name used in menu
    mttPath  // Full Path used in menu
  );

  TBaseVSPState = (
    bvsChangeNotified,    // The component has been notified that a change happened in the associated VET or Combobox
    bvsChangeDispatching, // The component has been interacting with and is changing the associated VET or Combobox
    bvsChangeItemsLoading // The items are being loaded from stream
  );
  TBaseVSPStates = set of TBaseVSPState;

  TFillPopupDirection = (
    fpdNewestToOldest,   // Fill menu present to past
    fpdOldestToNewest    // Fill menu past to present
  );

type
  TCustomVirtualShellHistory = class;
  TBaseVirtualShellPersistent = class;

  TVSPChangeEvent = procedure(Sender: TBaseVirtualShellPersistent; ItemIndex: Integer; ChangeType: TVSHChangeType) of object;
  TVSPGetImageEvent = procedure(Sender: TBaseVirtualShellPersistent; NS: TNamespace; var ImageList: TImageList; var ImageIndex: Integer) of object;

  TVSHMenuOptions = class(TPersistent)
  private
    FEllipsisPlacement: TShortenStringEllipsis; // Where the ellipsis goes if the string must be shortened
    FImages: Boolean;            // Show Images in menu
    FImageBorder: Integer;       // Border between Image and the drawn frame
    FLargeImages: Boolean;       // Use large (32x32) images in the menu
    FTextType: TVSHMenuTextType; // What type of text is used in the menu
    FMaxWidth: Integer;          // Set a max width for the Menu, the text will be shortened

  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(Dest: TPersistent); override;
  published
    property EllipsisPlacement: TShortenStringEllipsis read FEllipsisPlacement write FEllipsisPlacement default sseFilePathMiddle;
    property Images: Boolean read FImages write FImages default False;
    property ImageBorder: Integer read FImageBorder write FImageBorder default 1;
    property LargeImages: Boolean read FLargeImages write FLargeImages default False;
    property TextType: TVSHMenuTextType read FTextType write FTextType default mttName;
    property MaxWidth: Integer read FMaxWidth write FMaxWidth default -1;
  end;

  TBaseVirtualShellPersistent = class(TComponent)
  private
    FOnChange: TVSPChangeEvent;
    FSaveMappedDrivePaths: Boolean;
    FSaveNetworkPaths: Boolean;
    FSaveRemovableDrivePaths: Boolean;
  {$IFDEF EXPLORERCOMBOBOX_L}
    FVirtualExplorerComboBox: TCustomVirtualExplorerCombobox;
  {$ENDIF}
  {$IFDEF EXPLORERTREE_L}
    FVirtualExplorerTree: TCustomVirtualExplorerTree;
  {$ENDIF}
    FLevels: Integer;
    FOnGetImage: TVSPGetImageEvent;
    FMenuOptions: TVSHMenuOptions;
    FItemIndex: integer;
    FNamespaces: TList;
    FState: TBaseVSPStates;
  {$IFDEF EXPLORERCOMBOBOX_L}
    procedure SetVirtualExplorerComboBox(const Value: TCustomVirtualExplorerCombobox);
  {$ENDIF}
  {$IFDEF EXPLORERTREE_L}
    procedure SetVirtualExplorerTree(const Value: TCustomVirtualExplorerTree);
  {$ENDIF}
    procedure SetLevels(const Value: Integer);
    procedure SetMenuOptions(const Value: TVSHMenuOptions);
    function GetLargeSysImages: TImageList;
    function GetSmallSysImages: TImageList;
    function GetItems(Index: integer): TNamespace;
    procedure SetItemIndex(Value: integer);
    function GetCount: integer;
    function GetHasBackItems: Boolean;
    function GetHasNextItems: Boolean;
  protected
    procedure ChangeLinkChanging(Server: TObject; NewPIDL: PItemIDList); dynamic;
    procedure ChangeLinkDispatch(PIDL: PItemIDList); virtual;
    procedure ChangeLinkFreeing(ChangeLink: IVETChangeLink); dynamic;
    function CreateMenuOptions: TVSHMenuOptions; dynamic;
    function DeleteDuplicates(NS: TNamespace): Boolean;
    procedure ValidateLevels;
    procedure DoGetImage(NS: TNamespace; var ImageList: TImageList; var ImageIndex: Integer); virtual;
    procedure DoItemChange(ItemIndex: Integer; ChangeType: TVSHChangeType);
    procedure OnMenuItemClick(Sender: TObject); virtual;
    procedure OnMenuItemDraw(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean); virtual;
    procedure OnMenuItemMeasure(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer); virtual;

    property Count: integer read GetCount;
    property HasBackItems: Boolean read GetHasBackItems;
    property HasNextItems: Boolean read GetHasNextItems;
    property ItemIndex: integer read FItemIndex write SetItemIndex;
    property LargeSysImages: TImageList read GetLargeSysImages;
    property Levels: Integer read FLevels write SetLevels default 10;
    property MenuOptions: TVSHMenuOptions read FMenuOptions write SetMenuOptions;
    property Namespaces: TList read FNamespaces write FNamespaces;
    property OnChange: TVSPChangeEvent read FOnChange write FOnChange;
    property OnGetImage: TVSPGetImageEvent read FOnGetImage write FOnGetImage;
    property SaveMappedDrivePaths: Boolean read FSaveMappedDrivePaths write FSaveMappedDrivePaths default False;
    property SaveNetworkPaths: Boolean read FSaveNetworkPaths write FSaveNetworkPaths default False;
    property SaveRemovableDrivePaths: Boolean read FSaveRemovableDrivePaths write FSaveRemovableDrivePaths default False;
    property SmallSysImages: TImageList read GetSmallSysImages;
  {$IFDEF EXPLORERCOMBOBOX_L}
    property VirtualExplorerComboBox: TCustomVirtualExplorerCombobox read FVirtualExplorerComboBox write SetVirtualExplorerComboBox;
  {$ENDIF}
  {$IFDEF EXPLORERTREE_L}
    property VirtualExplorerTree: TCustomVirtualExplorerTree read FVirtualExplorerTree write SetVirtualExplorerTree;
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Add(Value: TNamespace; Release: Boolean = False; SelectAsIndex: Boolean = True): integer; virtual;
    procedure Clear; virtual;
    procedure Delete(Index: integer);
    procedure FillPopupMenu(Popupmenu: TPopupMenu; FillDirection: TFillPopupDirection;
      ClearItemText: WideString = ''); virtual;
    {$IFDEF USE_TOOLBAR_TB2K}
    procedure FillPopupMenu_TB2000(PopupMenu: TTBCustomItem; ItemClass: TTBCustomItemClass;
      FillDirection: TFillPopupDirection; ClearItemText: WideString = ''); virtual;
    {$ENDIF}
    procedure LoadFromFile(FileName: WideString);
    procedure LoadFromStream(S: TStream); virtual;
    procedure LoadFromRegistry(RootKey: DWORD; SubKey: string);
    procedure SaveToFile(FileName: WideString);
    procedure SaveToStream(S: TStream; ForceSaveAllPaths: Boolean = False); virtual;
    procedure SaveToRegistry(RootKey: DWORD; SubKey: string);

    property State: TBaseVSPStates read FState write FState;
    property Items[Index: integer]: TNamespace read GetItems; default;
  end;

  TCustomVirtualShellMRU = class(TBaseVirtualShellPersistent)
  public
    property ItemIndex;
    property LargeSysImages;
    property SmallSysImages;
  end;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualShellMRU = class(TCustomVirtualShellMRU)
  published
    property Count;
    property Levels;
    property MenuOptions;
    property OnChange;
    property OnGetImage;
    property SaveMappedDrivePaths;
    property SaveNetworkPaths;
    property SaveRemovableDrivePaths;
  {$IFDEF EXPLORERCOMBOBOX_L}
    property VirtualExplorerComboBox;
  {$ENDIF}
  {$IFDEF EXPLORERTREE_L}
    property VirtualExplorerTree;
  {$ENDIF}
  end;

  TCustomVirtualShellHistory = class(TBaseVirtualShellPersistent)
  public
    function Add(Value: TNamespace; Release: Boolean = False; SelectAsIndex: Boolean = True): integer; override;
    procedure Clear; override;
    procedure Back;
    procedure Next;

    property HasBackItems;
    property HasNextItems;
    property ItemIndex;
    property LargeSysImages;
    property SmallSysImages;
  end;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualShellHistory = class(TCustomVirtualShellHistory)
  published
    property Count;
    property Levels;
    property MenuOptions;
    property OnChange;
    property OnGetImage;
    property SaveMappedDrivePaths;
    property SaveNetworkPaths;
    property SaveRemovableDrivePaths;
  {$IFDEF EXPLORERCOMBOBOX_L}
    property VirtualExplorerComboBox;
  {$ENDIF}
  {$IFDEF EXPLORERTREE_L}
    property VirtualExplorerTree;
  {$ENDIF}
  end;

implementation

uses
  {$IFDEF USE_TOOLBAR_TB2K}
  TypInfo,
  {$ENDIF}
  Forms,
  VirtualTrees;

{$IFDEF USE_TOOLBAR_TB2K}
procedure SetTBItemCaption(Item: TTBCustomItem; Caption: WideString);
// Set the unicode caption to the Item if it has a valid
// WideString Caption property.
var
  PropInfo: PPropInfo;
begin
  PropInfo := GetPropInfo(Item, 'Caption', [tkWString]);
  if PropInfo = nil then
    Item.Caption := Caption
  else
    SetWideStrProp(Item, PropInfo, Caption);
end;
{$ENDIF}

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ TCustomVirtualShellHistory}
function TCustomVirtualShellHistory.Add(Value: TNamespace;
  Release: Boolean = False; SelectAsIndex: Boolean = True): integer;
begin
  Result := -1;
  if Assigned(Value) then
  begin
    //If ItemIndex is NOT the LastItem then delete all Namespaces between
    //ItemIndex and LastItem (delete all the "Next branch").
    if (Count > 0) and (FItemIndex < Count-1) then
      while Count-1 > FItemIndex do
        Delete(Count-1);
    Result := inherited Add(Value, Release, SelectAsIndex);
  end
end;

procedure TCustomVirtualShellHistory.Back;
begin
  SetItemIndex(ItemIndex - 1);
end;

procedure TCustomVirtualShellHistory.Clear;
begin
  inherited; 
end;

procedure TCustomVirtualShellHistory.Next;
begin
  SetItemIndex(ItemIndex + 1);
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ TVSHMenuOptions }

procedure TVSHMenuOptions.Assign(Source: TPersistent);
begin
  if Source is TVSHMenuOptions then
  begin
    Images := TVSHMenuOptions(Source).Images;
    ImageBorder := TVSHMenuOptions(Source).ImageBorder;
    LargeImages := TVSHMenuOptions(Source).LargeImages;
    TextType := TVSHMenuOptions(Source).TextType;
    MaxWidth := TVSHMenuOptions(Source).MaxWidth ;
  end else
    inherited
end;

procedure TVSHMenuOptions.AssignTo(Dest: TPersistent);
begin
  if Dest is TVSHMenuOptions then
  begin
    TVSHMenuOptions(Dest).Images := Images;
    TVSHMenuOptions(Dest).ImageBorder := ImageBorder;
    TVSHMenuOptions(Dest).LargeImages := LargeImages;
    TVSHMenuOptions(Dest).TextType := TextType;
    TVSHMenuOptions(Dest).MaxWidth := MaxWidth;
  end else
    inherited
end;

constructor TVSHMenuOptions.Create;
begin
  FMaxWidth := -1;
  FImageBorder := 1;
  EllipsisPlacement := sseFilePathMiddle
end;

destructor TVSHMenuOptions.Destroy;
begin
  inherited;
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ TBaseVirtualShellPersistent}
function TBaseVirtualShellPersistent.Add(Value: TNamespace;
  Release: Boolean = False; SelectAsIndex: Boolean = True): integer;
var
  NS: TNamespace;
begin
  Result := -1; // if no item is added it should return -1
  //Check if the LastItem is the same as Value
  if (Count = 0) or (not ILIsEqual(Items[Count-1].AbsolutePIDL, Value.AbsolutePIDL)) then
  begin
    ValidateLevels;  //validate first
    if Release then
      NS := Value
    else
      NS := Value.Clone(True);  //Clone it, we should free it explicitly
    Result := Namespaces.Add(NS);
    if SelectAsIndex then
      ItemIndex := Result;
    DoItemChange(FItemIndex, hctAdded);
  end;
end;

procedure TBaseVirtualShellPersistent.ChangeLinkChanging(Server: TObject; NewPIDL: PItemIDList);
var
  NS: TNamespace;
begin
  //VET informs us that it has changed its Directory
  // Don't add the new change if
  //  1) We initiated the change in the target VET or Combobox
  //  2) We are in a recursive ChangeNotified call
  //  3) The PIDL is not valid
  //  4) The Object that sent the notification was not a VET or a Combobox
   if (not (bvsChangeDispatching in FState)) and (not (bvsChangeNotified in FState)) and
    Assigned(NewPIDL) and ({$IFDEF EXPLORERTREE_L}    (Server = FVirtualExplorerTree)    {$ELSE}False{$ENDIF} or
                           {$IFDEF EXPLORERCOMBOBOX_L}(Server = FVirtualExplorerComboBox){$ELSE}False{$ENDIF}) then
  begin
    begin
      Include(FState, bvsChangeNotified);
      NS := TNamespace.Create(NewPIDL, nil); //create a temp namespace based on the PIDL
      try
        NS.FreePIDLOnDestroy := False;
        if NS.OkToBrowse(False) then
        begin
          if not DeleteDuplicates(NS) then
            Add(NS); //Add will clone the namespace and will take care of everything
        end
      finally
        NS.Free; //we don't use it anymore
        Exclude(FState, bvsChangeNotified);
      end
    end
  end;
end;

procedure TBaseVirtualShellPersistent.ChangeLinkDispatch(PIDL: PItemIDList);
begin
  //Informs all the Client VETs that we have selected a new Directory
  if not (bvsChangeNotified in FState) then
  begin
    Include(FState, bvsChangeDispatching);
    VETChangeDispatch.DispatchChange(Self, PIDL);
    Exclude(FState, bvsChangeDispatching);
  end
end;

procedure TBaseVirtualShellPersistent.ChangeLinkFreeing(ChangeLink: IVETChangeLink);
begin
  if ChangeLink.ChangeLinkClient = Self then
  begin
  {$IFDEF EXPLORERTREE_L}
    if ChangeLink.ChangeLinkServer = FVirtualExplorerTree then
      FVirtualExplorerTree := nil
    else
  {$ENDIF}
  {$IFDEF EXPLORERCOMBOBOX_L}
    if ChangeLink.ChangeLinkServer = FVirtualExplorerComboBox then
      FVirtualExplorerComboBox := nil
  {$ENDIF}
  end
end;

procedure TBaseVirtualShellPersistent.Clear;
begin
  while Count > 0 do
    Delete(0); // Make sure we fire all events
  FItemIndex := -1
end;

constructor TBaseVirtualShellPersistent.Create(AOwner: TComponent);
begin
  inherited;
  FNamespaces := TList.Create;
  FMenuOptions := CreateMenuOptions;
  FLevels := 10;
end;

function TBaseVirtualShellPersistent.CreateMenuOptions: TVSHMenuOptions;
begin
  Result := TVSHMenuOptions.Create;
end;

procedure TBaseVirtualShellPersistent.Delete(Index: integer);
var
  Temp: TNamespace;
  Changed: Boolean;
begin
  if (Index > -1) and (Index < Count) then
  begin
    Temp := TNamespace( Namespaces[Index]);
    Namespaces.Delete(Index);
    Temp.Free;
    if Count = 0 then
      SetItemIndex(-1);  
    DoItemChange(Index, hctDeleted);
    // The deleted item is the currently selected item need to change it
    if Index <= ItemIndex then
    begin
      // If the ItemIndex items is the one deleted then it is effectivly selecting
      // the next lower item
      Changed := Index = ItemIndex;
      // If a lower than selected item or the selected item is deleted the rest
      // will be shifted down so the index effectively is lowered by 1 (unless it
      // is the first item) although the actual selected item is the same.
      if Index > 0 then
        Dec(FItemIndex);

      if Changed then
        DoItemChange(FItemIndex, hctSelected);
    end;
    if Count = 0 then
      FItemIndex := -1
  end
end;

destructor TBaseVirtualShellPersistent.Destroy;
begin
  VETChangeDispatch.UnRegisterChangeLink(Self, Self, utAll);
  Clear;
  FNamespaces.Free;
  FreeAndNil(FMenuOptions); 
  inherited;
end;

procedure TBaseVirtualShellPersistent.DoGetImage(NS: TNamespace;
  var ImageList: TImageList; var ImageIndex: Integer);
begin
  if Assigned(OnGetImage) then
    OnGetImage(Self, NS, ImageList, ImageIndex);
end;

procedure TBaseVirtualShellPersistent.DoItemChange(ItemIndex: integer; ChangeType: TVSHChangeType);
begin
  if Assigned(OnChange) and not(csDestroying in ComponentState) then
    OnChange(Self, ItemIndex, ChangeType);
end;

procedure TBaseVirtualShellPersistent.FillPopupMenu(Popupmenu: TPopupMenu;
  FillDirection: TFillPopupDirection; ClearItemText: WideString = '');
//Fills a TPopupMenu to mimic the Explorer's Back and Next Buttons PopupMenu.
//Depending on the value of the BackPopup boolean the PopupMenu is filled with
//the corresponding Back or Next Namespaces folder names.
//When UnicodeEnabled is true the PopupMenu is OwnerDrawed to draw the widestrings.

  procedure AddToPopup(AIndex: integer);
  var
    M: TMenuItem;
  begin
    M := TMenuItem.Create(PopupMenu);
    M.Caption := Items[AIndex].NameInFolder;
    M.Tag := AIndex; //this represents the real MenuItem index (the back popupmenu is upside down)
    M.OnClick := OnMenuItemClick;
    M.OnDrawItem := OnMenuItemDraw;
    M.OnMeasureItem := OnMenuItemMeasure;
    Popupmenu.Items.Add(M);
  end;

  procedure AddClear;
  var
    M: TMenuItem;
  begin
    // Draw a divider line and let VCL draw it
    M := TMenuItem.Create(PopupMenu);
    M.Caption := '-';
    M.Tag := -1; //this represents the real MenuItem index (the back popupmenu is upside down)
    Popupmenu.Items.Add(M);

    M := TMenuItem.Create(PopupMenu);
    M.Caption := ClearItemText;
    M.Tag := -1; //this represents the real MenuItem index (the back popupmenu is upside down)
    M.OnClick := OnMenuItemClick;
    M.OnDrawItem := OnMenuItemDraw;
    M.OnMeasureItem := OnMenuItemMeasure;
    Popupmenu.Items.Add(M);
  end;

var
  i: integer;
begin
  Popupmenu.Items.Clear;
  if Count > 0 then
  begin
    if FillDirection = fpdOldestToNewest then
    begin
      if Self is TCustomVirtualShellHistory then
      begin
        for i := FItemIndex + 1 to Count - 1 do
          AddToPopup(i); //upside down
      end else
      if Self is TBaseVirtualShellPersistent then // This is true for ShellHistory too so must be last
      begin
        for i := 0 to Count - 2 do
          AddToPopup(i);
      end
    end else
    begin
      if Self is TCustomVirtualShellHistory then
      begin
        for i := FItemIndex - 1 downto 0 do
          AddToPopup(i); //upside down
      end else
      if Self is TBaseVirtualShellPersistent then // This is true for ShellHistory too so must be last
      begin
        for i := Count - 2 downto 0 do
        AddToPopup(i);
      end
    end;
    if ClearItemText <> '' then
      AddClear;

    PopupMenu.OwnerDraw := true;
  end;
end;

{$IFDEF USE_TOOLBAR_TB2K}
procedure TBaseVirtualShellPersistent.FillPopupMenu_TB2000(PopupMenu: TTBCustomItem;
  ItemClass: TTBCustomItemClass; FillDirection: TFillPopupDirection; ClearItemText: WideString = '');
// Fills a TTBCustomItem to mimic the Explorer's Back and Next Buttons TBX Item.
// Depending on the value of the PopupType the PopupMenu is filled with
// the corresponding Back, Next or All Namespaces folder names.

  procedure AddToPopup(AIndex: integer);
  var
    M: TTBCustomItem;
    NS: TNamespace;
  begin
    NS := Items[AIndex];
    M := ItemClass.Create(nil);
    if MenuOptions.TextType = mttName then
      SetTBItemCaption(M, NS.NameInFolder)
    else
      SetTBItemCaption(M, NS.NameParseAddress);
    M.Tag := AIndex; // The real MenuItem index (the back popupmenu is upside down)
    M.ImageIndex := NS.GetIconIndex(False, icSmall);
    M.Images := SmallSysImages;
    M.OnClick := OnMenuItemClick;
    Popupmenu.Add(M);
  end;

  procedure AddClear;
  var
    M: TTBCustomItem;
    SI: TTBSeparatorItem;
  begin
    M := ItemClass.Create(nil);
    SI := TTBSeparatorItem.Create(nil);
    // Add a separator and the Clear All item
    SI.Tag := -1; // The real MenuItem index (the back popupmenu is upside down)
    PopupMenu.Add(SI);
    SetTBItemCaption(M, ClearItemText);
    M.Tag := -1; // The real MenuItem index (the back popupmenu is upside down)
    M.OnClick := OnMenuItemClick;
    M.Images := SmallSysImages;
    PopupMenu.Add(M);
  end;

var
  i: integer;
begin
  PopupMenu.Clear;
  if Count > 0 then
  begin
    if FillDirection = fpdOldestToNewest then
    begin
      if Self is TCustomVirtualShellHistory then
      begin
        for i := FItemIndex + 1 to Count - 1 do
          AddToPopup(i); // Upside down
      end else
      if Self is TBaseVirtualShellPersistent then // This is true for ShellHistory too so must be last
      begin
        for i := 0 to Count - 2 do
          AddToPopup(i);
      end
    end else
    begin
      if Self is TCustomVirtualShellHistory then
      begin
        for i := FItemIndex - 1 downto 0 do
          AddToPopup(i); // Upside down
      end else
      if Self is TBaseVirtualShellPersistent then // This is true for ShellHistory too so must be last
      begin
        for i := Count - 2 downto 0 do
        AddToPopup(i);
      end
    end;
    if (ClearItemText <> '') and (Popupmenu.Count > 0) then
      AddClear;
  end;
end;
{$ENDIF}

function TBaseVirtualShellPersistent.GetCount: integer;
begin
  Result := Namespaces.Count
end;

function TBaseVirtualShellPersistent.GetHasBackItems: Boolean;
begin
  Result := ItemIndex > 0
end;


function TBaseVirtualShellPersistent.GetHasNextItems: Boolean;
begin
  Result := ItemIndex < Count - 1;
end;

function TBaseVirtualShellPersistent.GetItems(Index: integer): TNamespace;
begin
  if (Index > -1) and (Index < Count) then
    Result := TNamespace(Namespaces[Index])
  else
    Result := nil
end;

function TBaseVirtualShellPersistent.GetLargeSysImages: TImageList;
begin
  Result := MPCommonObjects.LargeSysImages;
end;

function TBaseVirtualShellPersistent.GetSmallSysImages: TImageList;
begin
  Result := MPCommonObjects.SmallSysImages;
end;

procedure TBaseVirtualShellPersistent.LoadFromFile(FileName: WideString);
var
  S: TVirtualFileStream;
begin
  S := TVirtualFileStream.Create(FileName, fmOpenRead or fmShareExclusive);
  try
    LoadFromStream(S)
  finally
    S.Free
  end
end;

procedure TBaseVirtualShellPersistent.LoadFromRegistry(RootKey: DWORD; SubKey: string);
var
  Reg: TRegistry;
  Stream: TMemoryStream;
begin
  Reg := TRegistry.Create;
  Stream := TMemoryStream.Create;
  try
    Reg.RootKey := RootKey;
    if Reg.OpenKey(SubKey, False) and Reg.ValueExists(REGISTRYDATASIZE) then
    begin
      Stream.Size := Reg.ReadInteger(REGISTRYDATASIZE);
      Reg.ReadBinaryData(REGISTRYDATA, Stream.Memory^, Stream.Size);
      LoadFromStream(Stream);
    end
  finally
    Reg.CloseKey;
    Reg.Free;
    Stream.Free;
    inherited;
  end
end;

procedure TBaseVirtualShellPersistent.LoadFromStream(S: TStream);
var
  C, I: integer;
  NS: TNamespace;
  OldErrorMode: Integer;
begin
  Include(FState, bvsChangeItemsLoading);
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    Clear;
    S.ReadBuffer(C, SizeOf(C));
    for I := 0 to C - 1 do begin
      // Dispatch the item change only for the last item
      if I = C - 1 then
        Exclude(FState, bvsChangeItemsLoading);
      NS := TNamespace.Create(PIDLMgr.LoadFromStream(S), nil);
      if NS.FileSystem and NS.Folder then
      begin
        if WideDirectoryExists(NS.NameForParsing) then
          Add(NS, True)
      end else
      if NS.Valid then
        Add(NS, True)
      else
        NS.Free
    end;
  finally
    Exclude(FState, bvsChangeItemsLoading);
    SetErrorMode(OldErrorMode);
  end;
end;

procedure TBaseVirtualShellPersistent.OnMenuItemClick(Sender: TObject);
var
  M: TComponent;
  OldFocus: TWinControl;
begin
  if (Sender is TComponent) then begin
    M := Sender as TComponent;
    OldFocus := Screen.ActiveForm.ActiveControl;
    if M.Tag > -1 then
      SetItemIndex(M.Tag)
    else
      Clear;
    if Assigned(OldFocus) then
      Screen.ActiveForm.SetFocusedControl(OldFocus)
  end;
end;

procedure TBaseVirtualShellPersistent.OnMenuItemDraw(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
var
  WS: WideString;
  S: AnsiString;
  i, Border: integer;
  ImageRect: TRect;
  TargetImageIndex: Integer;
  TargetImageList: TImageList;
  RTL: Boolean; // Left to Right reading
  OldMode: Longint;
begin
  if Sender is TMenuItem then
  begin
    RTL := Application.UseRightToLeftReading;
    i := TMenuItem(Sender).Tag;

    if IsWinXP and Selected then
    begin
      ACanvas.Brush.Color := clHighlight;
      ACanvas.Font.Color := clBtnHighlight;
      ACanvas.FillRect(ARect);
    end else
    begin
      ACanvas.Brush.Color := clMenu;
      ACanvas.Font.Color := clMenuText;
      ACanvas.FillRect(ARect);
    end;

    if i > -1 then
    begin
      if MenuOptions.TextType = mttName then
        WS := Items[i].NameInFolder
      else
        if MenuOptions.TextType = mttPath then
          WS := Items[i].NameParseAddress;
    end
    else
      WS := TMenuItem(Sender).Caption;

    if MenuOptions.Images then
    begin
      TargetImageIndex := -1;
      Border := MenuOptions.ImageBorder;
      if MenuOptions.LargeImages then
      begin
        TargetImageList := LargeSysImages;
        if i > -1 then
          TargetImageIndex := Items[i].GetIconIndex(False, icLarge)
      end else
      begin
        TargetImageList := SmallSysImages;
        if i > -1 then
          TargetImageIndex := Items[i].GetIconIndex(False, icSmall);
      end;
      // Allow custom icons
      if i > -1 then
        DoGetImage(Namespaces[i], TargetImageList, TargetImageIndex);


      if RTL then
        ImageRect := Rect(ARect.Right - (TargetImageList.Width + 2 * Border), ARect.Top, ARect.Right, ARect.Bottom)
      else
        ImageRect := Rect(ARect.Left, ARect.Top, ARect.Left + TargetImageList.Width + 2 * Border, ARect.Bottom);

      if Selected and not IsWinXP then
        DrawEdge(ACanvas.Handle, ImageRect, BDR_RAISEDINNER, BF_RECT);

      OffsetRect(ImageRect, Border, ((ImageRect.Bottom - ImageRect.Top) - TargetImageList.Height) div 2);

      ImageList_Draw(TargetImageList.Handle, TargetImageIndex, ACanvas.Handle,
        ImageRect.Left, ImageRect.Top, ILD_TRANSPARENT);

      if RTL then
        ARect.Right := ARect.Right - (TargetImageList.Width + (2 * Border) + 1)
      else
        ARect.Left := ARect.Left + TargetImageList.Width + (2 * Border) + 1
    end;

    if Selected and not IsWinXP then
    begin
      ACanvas.Brush.Color := clHighlight;
      ACanvas.Font.Color := clBtnHighlight;
      ACanvas.FillRect(ARect);
    end;

    Inc(ARect.Left, 2);
    if TextExtentW(WS, ACanvas).cx > ARect.Right-ARect.Left then
      WS := ShortenStringEx(ACanvas.Handle, WS, ARect.Right-ARect.Left, RTL, MenuOptions.EllipsisPlacement);
    OldMode := SetBkMode(ACanvas.Handle, TRANSPARENT);
    // Remove the & chars
    i := Pos('&', WS);
    System.Delete(WS, i, 1);
    if IsUnicode then
      DrawTextW_MP(ACanvas.handle, PWideChar(WS), lstrlenW(PWideChar(WS)), ARect, DT_SINGLELINE or DT_VCENTER)
    else begin
      S := AnsiString(WS);
      DrawTextA(ACanvas.handle, PAnsiChar(S), Length(S), ARect, DT_SINGLELINE or DT_VCENTER)
    end;
    SetBkMode(ACanvas.Handle, OldMode);
    //Note: it seems that DrawTextW doesn't draw the prefix.
  end;
end;

procedure TBaseVirtualShellPersistent.OnMenuItemMeasure(Sender: TObject;
  ACanvas: TCanvas; var Width, Height: Integer);
var
  WS: WideString;
  i: integer;
  Border: Integer;
begin
  if Sender is TMenuItem then
  begin
    i := TMenuItem(Sender).Tag;

    if i > -1 then
    begin
      if MenuOptions.TextType = mttName then
        WS := Items[i].NameInFolder
      else
        WS := Items[i].NameParseAddress;
      Width := TextExtentW(WS, ACanvas).cx;
    end else
      Width := TextExtentW(TMenuItem(Sender).Caption, ACanvas).cx;

    if MenuOptions.Images then
    begin
      Border := 2 * MenuOptions.ImageBorder;
      if MenuOptions.LargeImages then
      begin
        Inc(Width, LargeSysImages.Width + Border);
        if LargeSysImages.Height + Border > Height then
          Height := LargeSysImages.Height + Border
      end else
      begin
        Inc(Width, SmallSysImages.Width + Border);
        if SmallSysImages.Height + Border > Height then
          Height := SmallSysImages.Height + Border
      end
    end;
  end;

  if MenuOptions.MaxWidth > 0 then
  begin
    if Width > MenuOptions.MaxWidth then
      Width := MenuOptions.MaxWidth;
  end;

  if Width > Screen.Width then
    Width := Screen.Width - 12  // Purely imperical value seen on XP for the unaccessable borders
end;

procedure TBaseVirtualShellPersistent.SaveToFile(FileName: WideString);
var
  S: TVirtualFileStream;
begin
  S := TVirtualFileStream.Create(FileName, fmCreate or fmShareExclusive);
  try
    SaveToStream(S)
  finally
    S.Free
  end
end;

procedure TBaseVirtualShellPersistent.SaveToRegistry(RootKey: DWORD; SubKey: string);
var
  Reg: TRegistry;
  Stream: TMemoryStream;
begin
  Reg := TRegistry.Create;
  Stream := TMemoryStream.Create;
  try
    Reg.RootKey := RootKey;
    if Reg.OpenKey(SubKey, True) then
    begin
      SaveToStream(Stream);
      Reg.WriteInteger(REGISTRYDATASIZE, Stream.Size);
      Reg.WriteBinaryData(REGISTRYDATA, Stream.Memory^, Stream.Size)
    end
  finally
    Reg.CloseKey;
    Reg.Free;
    Stream.Free;
    inherited;
  end
end;

procedure TBaseVirtualShellPersistent.SaveToStream(S: TStream; ForceSaveAllPaths: Boolean = False);
var
  i, LocalCount: integer;
  NS: TNamespace;
  NSList: TVirtualNamespaceList;
  Store: Boolean;
begin
  NSList := TVirtualNamespaceList.Create;
  try
    NSList.OwnsObjects := False;
    for i := 0 to Namespaces.Count - 1 do
    begin
      NS := TNamespace(Namespaces[i]);
      if ForceSaveAllPaths then
        Store := True
      else begin
        Store := not NS.Removable or SaveRemovableDrivePaths;
        if Store then
          Store := not NS.IsNetworkNeighborhoodChild or SaveNetworkPaths;
            if Store then
              Store := not IsMappedDrivePath(NS.NameForParsing) or SaveMappedDrivePaths;
      end;
      if Store then
        NSList.Add(NS);
    end;

    LocalCount := NSList.Count;
    S.WriteBuffer(LocalCount, SizeOf(LocalCount));
    for i := 0 to LocalCount - 1 do
      PIDLMgr.SaveToStream(S, NSList[i].AbsolutePIDL);
  finally
    NSList.Free
  end
end;

procedure TBaseVirtualShellPersistent.SetItemIndex(Value: integer);
var
  PrevItemIndex: integer;
  NS: TNamespace;
begin
  if Value < 0 then Value := 0
  else
    if Value > Count - 1 then Value := Count - 1;

  if FItemIndex <> Value then
  begin
    PrevItemIndex := FItemIndex;
    if Count = 0 then
      FItemIndex := -1
    else begin
      FItemIndex := Value;
      //Inform VET that we have selected a new Directory
      if not (bvsChangeItemsLoading in FState) then
      begin
        NS := Items[FItemIndex];
        // Delete the item if it's invalid
        if Assigned(NS) and NS.FileSystem and (WideStrIComp(PWideChar(NS.Extension), '.zip') <> 0) and not WideDirectoryExists(NS.NameForParsing) then
        begin
          Delete(FItemIndex);
          if PrevItemIndex > Count - 1 then PrevItemIndex := Count - 1;
          FItemIndex := PrevItemIndex;
          DoItemChange(FItemIndex, hctInvalidSelected);
          Exit;
        end else
        begin
          ChangeLinkDispatch(NS.AbsolutePIDL);
          DoItemChange(FItemIndex, hctSelected);
        end;
      end;
    end;
  end;
end;

procedure TBaseVirtualShellPersistent.SetLevels(const Value: Integer);
begin
  if FLevels <> Value then
  begin
    FLevels := Value;
    ValidateLevels;
  end;
end;

procedure TBaseVirtualShellPersistent.SetMenuOptions(const Value: TVSHMenuOptions);
begin
  if Assigned(FMenuOptions) then
    FMenuOptions.Free;
  FMenuOptions := Value;
end;

{$IFDEF EXPLORERCOMBOBOX_L}
procedure TBaseVirtualShellPersistent.SetVirtualExplorerComboBox(const Value: TCustomVirtualExplorerCombobox);
begin
  if FVirtualExplorerComboBox <> Value then
  begin
    VirtualExplorerTree := nil;
    if Assigned(FVirtualExplorerComboBox) then
    begin
      VETChangeDispatch.UnRegisterChangeLink(FVirtualExplorerComboBox, Self, utLink);
      VETChangeDispatch.UnRegisterChangeLink(Self, FVirtualExplorerComboBox, utLink);
    end;
    FVirtualExplorerComboBox := Value;
    if Assigned(FVirtualExplorerComboBox) then
    begin
      //two way dispaching
      VETChangeDispatch.RegisterChangeLink(FVirtualExplorerComboBox, Self, ChangeLinkChanging, ChangeLinkFreeing);
      VETChangeDispatch.RegisterChangeLink(Self, FVirtualExplorerComboBox, FVirtualExplorerComboBox.ChangeLinkChanging, nil);
    end;
  end;
end;
{$ENDIF}

{$IFDEF EXPLORERTREE_L}
procedure TBaseVirtualShellPersistent.SetVirtualExplorerTree(const Value: TCustomVirtualExplorerTree);
begin
  if FVirtualExplorerTree <> Value then
  begin
  {$IFDEF EXPLORERCOMBOBOX_L}
    VirtualExplorerComboBox := nil;
  {$ENDIF}
    if Assigned(FVirtualExplorerTree) then
    begin
      VETChangeDispatch.UnRegisterChangeLink(FVirtualExplorerTree, Self, utLink);
      VETChangeDispatch.UnRegisterChangeLink(Self, FVirtualExplorerTree, utLink);
    end;
    FVirtualExplorerTree := Value;
    if Assigned(FVirtualExplorerTree) then
    begin
      //two way dispaching
      VETChangeDispatch.RegisterChangeLink(FVirtualExplorerTree, Self, ChangeLinkChanging, ChangeLinkFreeing);
      VETChangeDispatch.RegisterChangeLink(Self, FVirtualExplorerTree, FVirtualExplorerTree.ChangeLinkChanging, nil);
    end;
  end;
end;
{$ENDIF}

function TBaseVirtualShellPersistent.DeleteDuplicates(NS: TNamespace): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := Namespaces.Count - 1;
  while i > -1 do
  begin
    if NS.ComparePIDL(TNamespace( Namespaces[i]).AbsolutePIDL, True) = 0 then
    begin
      TNamespace( Namespaces[i]).Free;
      Namespaces.Delete(i)
    end;
    Dec(i);
  end
end;

procedure TBaseVirtualShellPersistent.ValidateLevels;
begin
  while Count > Levels do
    Delete(0); //delete will fire the change event, free the namespace properly and check the itemindex
end;

end.
