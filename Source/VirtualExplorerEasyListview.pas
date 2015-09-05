unit VirtualExplorerEasyListview;

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
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
//
//----------------------------------------------------------------------------

//  July 12, 2010
//   - Fixed issue where when a dialog is popped due to a context menu selection it may go
//     behind the application as the QueryInfoHint may try to show placing the focus back to the
//     application
//   - Fixed - OnOLEDragStart event not fired
//   - Added OnShellHeaderRebuilt event
//
//  May 30, 2010
//   - Removed the Critical Section calls in DoEnumFolder since these were WAGs at the random crashes that have since been fixed
//   - Added support to try to keep node selected if the file/folder name is renamed
//     outside of VirtualShellTools. If the Kernel Notifier is used it is not 100% guaranteed
//     but should work most of the time.
//
//  April 20, 2010
//      - Fixed bug with thumbnails in the QueryInfo tips, they were always included regardless of options
//      - Fixed hangs in Vista and Win 7
//      - Added more FileObjects to include in enumeration.  Most only valid in Vista or Win 7 see the Microsoft documentation on IShellFolder.EnumObjects and the SHCONTF_xxxx constants
//


interface

{$B-}
{.$DEFINE GX_DEBUG}
{.$DEFINE ALWAYS_SHOW_ALL_COLUMNS}  // If enabled all shell columns will be shown in report view by default
{.$DEFINE GXDEBUG_SHELLNOTIFY}


{$I ..\Include\AddIns.inc}

{$IFDEF GXDEBUG_SHELLNOTIFY}
  {$DEFINE GX_DEBUG}
{$ENDIF}
{$IFDEF GXDEBUG_SHELLNOTIFY}
  {$DEFINE GX_DEBUG}
{$ENDIF}

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Math,
  Menus,
  StdCtrls,
  Buttons,
  ImgList,
  Registry,
  ComCtrls,
  ShellAPI,
  ActiveX,
  ShlObj,
  {$IFDEF GX_DEBUG}
  DbugIntf,
  {$ENDIF}
  VirtualTrees,
  MPCommonUtilities,
  MPShellTypes,
  MPCommonObjects,
  MPThreadManager,
  MPDataObject,
  MPShellUtilities,
  VirtualResources,
  VirtualShellNotifier,
  VirtualThumbnails,
  {$IFDEF SpTBX}
  ColumnFormSpTBX,
  {$ELSE}
    {$IFDEF TBX}
    ColumnFormTBX,
    {$ELSE}
      ColumnForm,
    {$ENDIF}
  {$ENDIF}
  EasyListview,
  {$IFDEF USE_TOOLBAR_TB2K}
  TB2Item,
  {$ENDIF}
  VirtualExplorerTree;

const
    TID_ICON = TID_START + 100;
    TID_THUMBNAIL = TID_START + 1;
    TID_DETAILS = TID_START + 2;
    TID_DETAILSOF = TID_START + 3;

    WM_DETAILSOF_THREAD = WM_APP + 437;

 //   CURRENT_EASYLISTVIEWEXPLORER_STREAM_VERSION = 1;
    CURRENT_EASYLISTVIEWEXPLORER_STREAM_VERSION = 2;      // Added the ExtensionColorCode

    IE_NAMEFORPARSING = '::{871C5380-42A0-1069-A2EA-08002B30309D}';

    MaxInt64 = High(Int64);

    SPECIALFOLDERSTART = 6;
    MAXGROUPING = 12;

    ID_SIZE_COLUMN = 1;

var
  GROUPINGFILESIZE:  array[0..7] of WideString = (
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     ''
  );

  GROUPINGFILESIZEDELTA:  array[0..7] of Int64 = (
    0,         // 'Zero'
    $7FFF,     // 'Tiny'
    $1FFFF,     // 'Small'
    $FFFFE,    // 'Medium'
    $FFFFFE,   // 'Large'
    MAXINT64,  // 'Gigantic'
    0,         // Dummy     << SPECIALFOLDERSTART = 6;
    0          // Dummy
  );


  GROUPINGMODIFIEDDATE:  array[0..MAXGROUPING] of WideString = (
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     ''
  );

  GROUPINGMODIFIEDDATEDELTA:  array[0..MAXGROUPING] of Single = (
     0.4,   // 'Last Hour'
     1.0,   // 'Last twenty-four hours'
     7.0,   // 'This week',
     14.0,  // 'Two weeks ago'
     21.0,  // 'Three weeks ago'
     30.42,  // 'A month ago',
     60.83,  //'Two months ago',
     91.25,  // 'Three months ago'
     121.67, // 'Four months ago'
     152.08, // 'Five months ago'
     182.5, // 'Six months ago'
     365.0, //'Earlier this year',
     MAXSINGLE   //'A long time ago'
  );


type
  TCustomVirtualExplorerEasyListview = class;
  TExplorerItem = class;
  TVirtualExplorerEasyListview = class;
  TExplorerColumn = class;

  TEasyThumbnailThreadRequest = class;
  TCreateCustomThumbInfoProc = function(NS: TNamespace; ARequest: TEasyThumbnailThreadRequest): TThumbInfo of object;
  TELVOnBeforeItemThumbnailDraw = procedure(Item: TEasyItem) of object;

  TELVAddColumnProc = function: TExplorerColumn of object;

  {$IFDEF USE_TOOLBAR_TB2K}
  TTBPopupMenuClass = class of TTBPopupMenu;
  {$ENDIF}

  PositionSortType = (
    pstPosition,  // sort on the position
    pstIndex      // sort on the index
  );


  TVirtualFileSizeFormat = (
    vfsfDefault,
    vfsfExplorer,
    vfsfActual,
    vfsfDiskUsage,
    vfsfText
  );

  TGroupingModifiedRec = packed record
    Caption: WideString;
    Days: Single;
    Enabled: Boolean
  end;

  TGroupingFileSizeRec = packed record
    Caption: WideString;
    FileSize: Int64;
    Enabled: Boolean;
    SpecialFolder: Boolean;
  end;

  TColumnPositionIndex = packed record
    Index,              // "normal" index of the column based on the column enumeration order
    Position: Word;     // position the user has defined that index to be in the header
  end;

  TGroupingModifiedArray = array of TGroupingModifiedRec;
  TGroupingFileSizeArray = array of TGroupingFileSizeRec;

  PVirtualExplorerEasyListviewHeaderState = ^TVirtualExplorerEasyListviewHeaderState;
  TVirtualExplorerEasyListviewHeaderState = record
    Visible: array of Boolean;
    Width: array of Integer;
    Position: array of TColumnPositionIndex;
    SortDirection: array of TEasySortDirection;
  end;


  TEasyVirtualThumbView = class(TEasyViewThumbnailItem)
  public
    function FullRowSelect: Boolean; override;
    procedure ItemRectArray(Item: TEasyItem; Column: TEasyColumn;
      ACanvas: TCanvas; const Caption: WideString;
      var RectArray: TEasyRectArrayObject); override;
    procedure PaintAfter(Item: TEasyItem; Column: TEasyColumn;
      const Caption: WideString; ACanvas: TCanvas;
      RectArray: TEasyRectArrayObject); override;
    procedure PaintImage(Item: TEasyItem; Column: TEasyColumn;
      const Caption: WideString; RectArray: TEasyRectArrayObject;
      ImageSize: TEasyImageSize; ACanvas: TCanvas); override;
    procedure PaintText(Item: TEasyItem; Column: TEasyColumn;
      const Caption: WideString; RectArray: TEasyRectArrayObject;
      ACanvas: TCanvas; LinesToDraw: Integer); override;
  end;

  // ***************************************************************
  // A TThumbsManager that controls the thumbnails in TVirtualItem
  // ***************************************************************
  TEasyThumbsManager = class(TThumbsManager)
  private
    FController: TCustomVirtualExplorerEasyListview;
    FUseEndScrollDraw: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadAlbum(Force: Boolean = False); override;
    procedure SaveAlbum; override;
    procedure ReloadThumbnail(Item: TEasyItem);
    property Controller: TCustomVirtualExplorerEasyListview read FController;
    property UseEndScrollDraw: Boolean read FUseEndScrollDraw write FUseEndScrollDraw;
  end;

  // ***************************************************************
  // A ThreadRequest that extracts the Thumbnail of an object via a PIDL
  // ***************************************************************
  TEasyThumbnailThreadRequest = class(TPIDLThreadRequest)
  private
    FBackgroundColor: TColor;
    FUseExifThumbnail: Boolean;
    FUseExifOrientation: Boolean;
    FUseShellExtraction: Boolean;
    FUseSubsampling: Boolean;
    FInternalThumbInfo: TThumbInfo;
    FThumbSize: TPoint;
    FCreateCustomThumbInfoProc: TCreateCustomThumbInfoProc;
  public
    destructor Destroy; override;
    function HandleRequest: Boolean; override;
    procedure Assign(Source: TPersistent); override;
    property BackgroundColor: TColor read FBackgroundColor write FBackgroundColor;
    property ThumbSize: TPoint read FThumbSize write FThumbSize;
    property UseExifThumbnail: Boolean read FUseExifThumbnail write FUseExifThumbnail;
    property UseExifOrientation: Boolean read FUseExifOrientation write FUseExifOrientation;
    property UseShellExtraction: Boolean read FUseShellExtraction write FUseShellExtraction;
    property UseSubsampling: Boolean read FUseSubsampling write FUseSubsampling;
    property CreateCustomThumbInfoProc: TCreateCustomThumbInfoProc read FCreateCustomThumbInfoProc write FCreateCustomThumbInfoProc;
  end;

  // ***************************************************************
  // A ThreadRequest that extracts the Details of an object via a PIDL
  // ***************************************************************
  TEasyDetailsThreadRequest = class(TPIDLThreadRequest)
  public
    FDetailRequest: TCommonIntegerDynArray;
    FDetails: TCommonIntegerDynArray;

    function HandleRequest: Boolean; override;
    procedure Assign(Source: TPersistent); override;

    property DetailRequest: TCommonIntegerDynArray read FDetailRequest write FDetailRequest;
    property Details: TCommonIntegerDynArray read FDetails write FDetails;
  end;

  // ***************************************************************
  // A ThreadRequest that extracts DetailsOf strings within
  // the context of the thread.
  // ***************************************************************
  TEasyDetailStringsThreadRequest = class(TPIDLThreadRequest)
  private
    FAddTitleColumnCaption: Boolean;
  public
    FDetailRequest: TCommonIntegerDynArray;
    FDetails: TCommonWideStringDynArray;

    function HandleRequest: Boolean; override;
    procedure Assign(Source: TPersistent); override;

    property AddTitleColumnCaption: Boolean read FAddTitleColumnCaption write FAddTitleColumnCaption;
    property DetailRequest: TCommonIntegerDynArray read FDetailRequest write FDetailRequest;
    property Details: TCommonWideStringDynArray read FDetails write FDetails;
  end;

  TVirtualEasyListviewOption = (
    eloBrowseExecuteFolder,          // Browse the folder instead of opening it on Windows Explorer
    eloBrowseExecuteFolderShortcut,  // Browse the folder shortcut instead of opening it on Windows Explorer
    eloBrowseExecuteZipFolder,       // Browse the zip folder instead of opening it
    eloExecuteOnDblClick,            // Browse or execute on double click
    eloHideRecycleBin,               // Hides the RecycleBin
    eloThreadedEnumeration,          // Uses a thread to enumerate the items in a view before showing them
    eloThreadedImages,               // Use a thread to retrieve the item's icons
    eloThreadedDetails,              // Use threaded detail extraction if the Column reports it is slow
    eloQueryInfoHints,               // Show the popup shell information tip when hovering over items
    eloShellContextMenus,            // Show the shell context menus for the items
    eloChangeNotifierThread,         // Control tracks changes in the shell
    eloTrackChangesInMappedDrives,   // When the shell notifies the control of a change any mapped drives are included in the refresh
    eloNoRebuildIconListOnAssocChange, // In XP Rebuilding the IconList can cause the icons on the desktop to be rearranged
    eloRemoveContextMenuShortCut,    // Removes the Shortcut item from the context menu.  Used mainly when in the explorer Treeview to be consistent with Explorer
    eloPerFolderStorage,             // Saves the state of each folder (grouping, columns state etc)
    eloUseColumnOnByDefaultFlag,     // Checks to see if the column handler is "on by default" and makes the column visible if it is.  Some handlers misuse this so make it an option
    eloFullFlushItemsOnChangeNotify, // Enabled the best possible updating of item information (especially in Details mode such as when file size changes). When enabled the TNamespace is recreated for each item with the fresh PIDL.  Great for full update, bad for performance.
    eloGhostHiddenFiles,            // Draws the image blended (ghosted) if the item is hidden
    eloIncludeThumbnailsWithQueryInfoHints  // Show a Thumbnail with the Query Info Hint.  It size is based on the text for the QueryInfo
  );
  TVirtualEasyListviewOptions = set of TVirtualEasyListviewOption;

  TEasyCategoryType = (
    ectNoCategory,
    ectStandardAlphabetical,
    etcStandardDriveSize,
    ectStandardDriveType,
    ectStandardFreeSpace,
    ectStandardSize,
    ectStandardTime,
    ectStandardMerged,
    ectUnknown
  );

  TItemSearchRec = packed record
    Item: TExplorerItem;
    Valid: Boolean;
  end;
  TItemSearchArray = array of TItemSearchRec;

  TEVLPersistentState = (
    epsRestoring,
    epsSaving
  );
  TEVLPersistentStates = set of TEVLPersistentState;

  TELVPersistent = class(TStreamableClass)
  private
    FFocusPIDL: PItemIDList;
    FRootFolder: TRootFolder;
    FRootFolderCustomPath: WideString;
    FRootFolderCustomPIDL: PItemIDList;
    FSelectedPIDLs: TCommonPIDLList;
    FStates: TEVLPersistentStates;
    FStorage: TNodeStorage;
    FTopNodePIDL: PItemIDList;
  protected
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(FileName: WideString; Version: integer = VETStreamStorageVer; ReadVerFromStream: Boolean = True); override;
    procedure LoadFromStream(S: TStream; Version: integer = VETStreamStorageVer; ReadVerFromStream: Boolean = True); override;
    procedure RestoreList(ELV: TCustomVirtualExplorerEasyListview; RestoreSelection, RestoreFocus: Boolean; ScrollToOldTopNode: Boolean = False); reintroduce; virtual;
    procedure SaveList(ELV: TCustomVirtualExplorerEasyListview; SaveSelection, SaveFocus: Boolean); reintroduce; virtual;
    procedure SaveToFile(FileName: WideString; Version: integer = VETStreamStorageVer; ReadVerFromStream: Boolean = True); override;
    procedure SaveToStream(S: TStream; Version: integer = VETStreamStorageVer; WriteVerToStream: Boolean = True); override;
    property FocusPIDL: PItemIDList read FFocusPIDL write FFocusPIDL;
    property RootFolder: TRootFolder read FRootFolder write FRootFolder;
    property RootFolderCustomPath: WideString read FRootFolderCustomPath write FRootFolderCustomPath;
    property RootFolderCustomPIDL: PItemIDList read FRootFolderCustomPIDL write FRootFolderCustomPIDL;
    property SelectedPIDLs: TCommonPIDLList read FSelectedPIDLs write FSelectedPIDLs;
    property States: TEVLPersistentStates read FStates write FStates;
    property Storage: TNodeStorage read FStorage write FStorage;
    property TopNodePIDL: PItemIDList read FTopNodePIDL write FTopNodePIDL;
  published
  end;


  // ***************************************************************
  // Assigns a Font attribute to a particular file class (extension)
  // ***************************************************************
  TExtensionColorCode = class(TStreamableClass)
  private
    FBold: Boolean;
    FColor: TColor;
    FEnabled: Boolean;
    FExtension: TStringList;
    FFExtensionMask: WideString;
    FItalic: Boolean;
    FUnderLine: Boolean;
    function GetExtensionMask: WideString;
    procedure SetExtensionMask(const Value: WideString);
  protected
    property FExtensionMask: WideString read FFExtensionMask write FFExtensionMask;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromStream(S: TStream; Version: integer = 0; ReadVerFromStream: Boolean = False); override;
    procedure SaveToStream(S: TStream; Version: integer = 0; WriteVerToStream: Boolean = False); override;
    property Bold: Boolean read FBold write FBold;
    property Color: TColor read FColor write FColor;
    property Enabled: Boolean read FEnabled write FEnabled;
    property ExtensionMask: WideString read GetExtensionMask write SetExtensionMask;
    property Extensions: TStringList read FExtension write FExtension;
    property Italic: Boolean read FItalic write FItalic;
    property UnderLine: Boolean read FUnderLine write FUnderLine;
  end;


  // ***************************************************************
  // List of objects that assign a Font attribute to a particular file class (extension)
  // ***************************************************************
  TExtensionColorCodeList = class(TStreamableClass)
  private
    FItemList: TList;
    function GetCount: Integer;
    function GetItems(Index: Integer): TExtensionColorCode;
    procedure SetItems(Index: Integer; Value: TExtensionColorCode);
  protected
    property ItemList: TList read FItemList write FItemList;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(ExtList: WideString; AColor: TColor; IsBold: Boolean = False; IsItalic: Boolean = False; IsUnderLine: Boolean = False; IsEnabled: Boolean = True): TExtensionColorCode;
    function FindColorCode(NS: TNamespace): TExtensionColorCode; 
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    function Find(ExtList: WideString): TExtensionColorCode;
    procedure LoadFromStream(S: TStream; Version: integer = 0; ReadVerFromStream: Boolean = False); override;
    procedure SaveToStream(S: TStream; Version: integer = 0; WriteVerToStream: Boolean = False); override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TExtensionColorCode read GetItems write SetItems; default;
  end;

  // ***************************************************************
  // An EasyItemVirtual that has a TNamespace associated with it
  // ***************************************************************
  TExplorerItem = class(TEasyItemVirtual)
  private
    FNamespace: TNamespace;
    FThumbInfo: TThumbInfo;
  public
    constructor Create(ACollection: TEasyCollection); override;
    destructor Destroy; override;
    property Namespace: TNamespace read FNamespace write FNamespace;
    property ThumbInfo: TThumbInfo read FThumbInfo write FThumbInfo;
  end;
  TExplorerItemClass = class of TExplorerItem;

  // ***************************************************************
  TExplorerColumn = class(TEasyColumnStored)
  private
    FIsCustom: Boolean;
  public
    procedure LoadFromStream(S: TStream; var AVersion: Integer); override;
    procedure SaveToStream(S: TStream; AVersion: Integer = EASYLISTVIEW_STREAM_VERSION); override;
    property IsCustom: Boolean read FIsCustom write FIsCustom;
  end;
  TExplorerColumnClass = class of TExplorerColumn;

  // ***************************************************************
  // An EasyGroupVirtual that has a sorting key associated with it
  // ***************************************************************
  TExplorerGroup = class(TEasyGroupStored)
  private
    FGroupKey: Integer;
  public
    constructor Create(ACollection: TEasyCollection); override;
    destructor Destroy; override;
    property GroupKey: Integer read FGroupKey write FGroupKey;
  end;
  TExplorerGroupClass = class of TExplorerGroup;

  TEasyVirtualSelectionManager = class(TEasySelectionManager)
  private
    FFirstItemFocus: Boolean;
  public
    constructor Create(AnOwner: TCustomEasyListview); override;
  published
    property FirstItemFocus: Boolean read FFirstItemFocus write FFirstItemFocus default True;
    property ForceDefaultBlend default True;    
  end;

  TThumbThreadCreateProc = procedure(var ThumbRequest: TEasyThumbnailThreadRequest) of object;

  TELVOnEnumFolder = procedure(Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace; var AllowAsChild: Boolean) of object;
  TELVExplorerGroupClassEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; var ExplorerClass: TExplorerGroupClass) of object;
  TELVExplorerItemClassEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; var ExplorerClass: TExplorerItemClass) of object;
  TELVGetStorageEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; var Storage: TRootNodeStorage) of object;
  TELVInvalidRootNamespaceEvent = procedure(Sender: TCustomVirtualExplorerEasyListview) of object;
  TELVContextMenu2MessageEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; var Msg: TMessage) of object;
  TELVOnContextMenuAfterCmd = procedure(Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace; Verb: WideString; MenuItemID: Integer; Successful: Boolean) of object;
  TELVOnContextMenuCmd = procedure(Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace; Verb: WideString; MenuItemID: Integer; var Handled: Boolean) of object;
  TELVOnContextMenuShow = procedure(Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace; Menu: hMenu; var Allow: Boolean) of object;
  TVELCustomColumnAddEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; AddColumnProc: TELVAddColumnProc) of object;
  TELVCustomColumnCompareEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; Column: TExplorerColumn; Group: TEasyGroup; Item1, Item2: TExplorerItem; var CompareResult: Integer) of object;
  TELVCustomColumnGetCaptionEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; Column: TExplorerColumn; Item: TExplorerItem; var ACaption: WideString) of object;
  TELVContextMenuItemChange = procedure(Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace; MenuItemID : Integer; SubMenuID: hMenu; MouseSelect: Boolean) of object;
  TELVOnRootChange = procedure(Sender: TCustomVirtualExplorerEasyListview) of object;
  TELVOnRootChanging = procedure(Sender: TCustomVirtualExplorerEasyListview; const NewValue: TRootFolder; const CurrentNamespace, Namespace: TNamespace; var Allow: Boolean) of object;
  TELVOnRootRebuild = procedure(Sender: TCustomVirtualExplorerEasyListview) of object;
  TELVOnShellExecute = procedure(Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace;var WorkingDir: WideString; var CmdLineArgument: WideString; var Allow: Boolean) of object;
  TELVOnShellNotifyEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; ShellEvent: TVirtualShellEvent) of object;
  TEasyCustomGroupEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; Groups: TEasyGroups; NS: TNamespace; var Group: TExplorerGroup) of object;
  TELVLoadStorageFromRoot = procedure(Sender: TCustomVirtualExplorerEasyListview; NodeStorage: TNodeStorage) of object;
  TELVSaveRootToStorage = procedure(Sender: TCustomVirtualExplorerEasyListview; NodeStorage: TNodeStorage) of object;
  TELVEnumFinishedEvent = procedure(Sender: TCustomVirtualExplorerEasyListview) of object;
  TELVEnumLenghyOperaionEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; var ShowAnimation: Boolean) of object;
  TELVThumbThreadCreateCallbackEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; var ThumbRequestClass: TEasyThumbnailThreadRequest) of object;
  TELVQuickFilterCustomCompareEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; Item: TExplorerItem; Mask: WideString; var IsVisible: Boolean) of object;
  TELVQuickFilterStartEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; Mask: WideString) of object;
  TELVRebuildingShellHeaderEvent = procedure(Sender: TCustomVirtualExplorerEasyListview; var Allow: Boolean) of object;
  TELVRebuiltShellHeaderEvent = procedure(Sender: TCustomVirtualExplorerEasyListview) of object;

  TCategory = class
  private
    FCategory: TGUID;             // The GUID of the Category for grouping
    FCategoryType: TEasyCategoryType;
    FColumn: Integer;             // The header column that maps to the Category
    FColumnID: TSHColumnID;       // The SCID of the header column
    FEnumerated: Boolean; // True if the Category was aquired through ICategoryProvider.EnumCategories
    FIsDefault: Boolean;  // True if the Category is the default category defined by the namespace through ICategoryProvider.GetDefaultCategory
    FName: WideString;            // Name returned by ICategoryProvider.GetCategoryName, the standard AlphabeticalCategorizer always returns empty
  public
    property Category: TGUID read FCategory;
    property CategoryType: TEasyCategoryType read FCategoryType;
    property Column: Integer read FColumn;
    property ColumnID: TSHColumnID read FColumnID;
    property Enumerated: Boolean read FEnumerated write FEnumerated;
    property IsDefault: Boolean read FIsDefault;
    property Name: WideString read FName;
  end;

  TCategories = class
  private
    FCategoryList: TList;
    function GetCategories(Index: Integer): TCategory;
    function GetCount: Integer;
  protected
    procedure Delete(Index: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function Add: TCategory;
    procedure Clear;
    property Categories[Index: Integer]: TCategory read GetCategories; default;
    property Count: Integer read GetCount;
  end;

  TVirtualCustomFileTypes = class(TPersistent)
  private
    FColor: TColor;
    FFont: TFont;
    FHilight: Boolean;
    procedure SetHilight(const Value: Boolean);
  public
    constructor Create(AColor: TColor);
    destructor Destroy; override;
  published
    property Color: TColor read FColor write FColor;
    property Font: TFont read FFont write FFont;
    property Hilight: Boolean read FHilight write SetHilight default False;
  end;

  TVirtualEasyListviewDataObject = class(TEasyDataObjectManager, IDataObject)
  private
    FShellDataObject: IDataObject;
  protected
    function DAdvise(const formatetc: TFormatEtc; advf: Longint; const advSink: IAdviseSink; out dwConnection: Longint): HResult; override;
    function DUnadvise(dwConnection: Longint): HResult; override;
    function EnumDAdvise(out enumAdvise: IEnumStatData): HResult; override;
    function EnumFormatEtc(dwDirection: Longint; out enumFormatEtc: IEnumFormatEtc): HResult; override;
    function GetCanonicalFormatEtc(const formatetc: TFormatEtc; out formatetcOut: TFormatEtc): HResult; override;
    function GetData(const FormatEtcIn: TFormatEtc; out Medium: TStgMedium): HResult; override;
    function GetDataHere(const formatetc: TFormatEtc; out medium: TStgMedium): HResult; override;
    function QueryGetData(const formatetc: TFormatEtc): HResult; override;
    function SetData(const formatetc: TFormatEtc; var medium: TStgMedium; fRelease: BOOL): HResult; override;
    procedure DoGetCustomFormats(dwDirection: Integer; var Formats: TFormatEtcArray); override;
    property ShellDataObject: IDataObject read FShellDataObject write FShellDataObject;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TEasyExplorerMemoEditor = class(TEasyMemoEditor)
  private
    FFullSelToggleState: Boolean;
  protected
    procedure DoEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState; var DoDefault: Boolean); override;
    procedure SelectFileName(FileNameOnly: Boolean);
    property FullSelToggleState: Boolean read FFullSelToggleState write FFullSelToggleState;
  public
    function SetEditorFocus: Boolean; override;
  end;

  TEasyExplorerStringEditor = class(TEasyStringEditor)
  private
    FFullSelToggleState: Boolean;
  protected
    procedure DoEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState; var DoDefault: Boolean); override;
    procedure SelectFileName(FileNameOnly: Boolean);
    property FullSelToggleState: Boolean read FFullSelToggleState write FFullSelToggleState;
  public
    function SetEditorFocus: Boolean; override;
  end;

  TCustomVirtualExplorerEasyListview = class(TCustomEasyListview, IVirtualShellNotify)
  private
    FActivated: Boolean;
    FActive: Boolean;
    FAnimateFolderEnum: TAnimate;
    FBackBrowseRoot: TNamespace;  // The root that can't be browsed above, the Desktop by default
    FBackGndMenu: TVirtualShellBackgroundContextMenu;
    FCategoryInfo: TCategories;
    FChangeNotifierCount: integer;
    FChangeNotifierEnabled: Boolean;
    FClipChainWnd: HWnd;
    FColumnHeaderMenu: TPopupMenu;
    FColumnMenuItemCount: Integer;
    FCompressedFile: TVirtualCustomFileTypes;
    FContextMenuItem: TEasyItem;
    FContextMenuShown: Boolean;
    FDefaultSortColumn: Integer;
    FDefaultSortDir: TEasySortDirection;
    FDetailsOfThread: TCommonEventThread;
    FExtensionColorCode: Boolean;
    FExtensionColorCodeSelected: Boolean;
    FFileSizeFormat: TVirtualFileSizeFormat;
    FOldTopNode: PItemIDList;
    FOnAfterPaint: TAfterPaintEvent;
    FOnGroupingChange: TNotifyEvent;
    FOnQuickFilterCustomCompare: TELVQuickFilterCustomCompareEvent;
    FOnQuickFilterEnd: TNotifyEvent;
    FOnQuickFilterStart: TELVQuickFilterStartEvent;
    FOnRebuildingShellHeader: TELVRebuildingShellHeaderEvent;
    FOnRebuiltShellHeader: TELVRebuiltShellHeaderEvent;
    FOnThumbRequestCreate: TELVThumbThreadCreateCallbackEvent;
    FOrphanThreadList: TList;
    FDragDataObject: IDataObject;
    FELVPersistent: TELVPersistent;    // A snapshot of the current state of the Listview
    FEncryptedFile: TVirtualCustomFileTypes;
    FEnumBkGndList: TCommonPIDLList;
    FEnumBkGndTime: Cardinal;
    FEnumLock: TRTLCriticalSection;
    FEnumThread: TVirtualBackGndEnumThread;
    FEnumTimer: THandle;
  {$IFDEF EXPLORERCOMBOBOX_L}
    FExplorerCombobox: TVirtualExplorerCombobox;
  {$ENDIF}
  {$IFDEF EXPLORERTREEVIEW_L}
    FExplorerTreeview: TCustomVirtualExplorerTree;
  {$ENDIF}
    FFileObjects: TFileObjects;
    FGrouped: Boolean;
    FGroupingColumn: Integer;
    FGroupingFileSizeArray: TGroupingFileSizeArray;
    FGroupingModifiedArray: TGroupingModifiedArray;
    FIENamespaceShown: Boolean;
    {$IFDEF USE_TOOLBAR_TB2K}FItemClass: TTBCustomItemClass;{$ENDIF}  // Menu Item class for TB2000 support used on internally build menus
    FLastDropTargetNS: TNamespace;
    FLock: TRTLCriticalSection;
    FMalloc: IMalloc;
    {$IFDEF USE_TOOLBAR_TB2K}FMenuClass: TTBPopupMenuClass;{$ENDIF}
    FOnBeforeItemThumbnailDraw: TELVOnBeforeItemThumbnailDraw;
    FOnCustomColumnAdd: TVELCustomColumnAddEvent;
    FOnClipboardChange: TNotifyEvent;
    FOnContextMenu2Message: TELVContextMenu2MessageEvent;
    FOnContextMenuAfterCmd: TELVOnContextMenuAfterCmd;
    FOnContextMenuCmd: TELVOnContextMenuCmd;
    FOnContextMenuItemChange: TELVContextMenuItemChange;
    FOnContextMenuShow: TELVOnContextMenuShow;
    FOnCustomColumnCompare: TELVCustomColumnCompareEvent;
    FOnCustomColumnGetCaption: TELVCustomColumnGetCaptionEvent;
    FOnCustomGroup: TEasyCustomGroupEvent;
    FOnEnumFinished: TELVEnumFinishedEvent;
    FOnEnumFolder: TELVOnEnumFolder;
    FOnEnumThreadLengthyOperation: TELVEnumLenghyOperaionEvent;
    FOnExplorerGroupClass: TELVExplorerGroupClassEvent;
    FOnExplorerItemClass: TELVExplorerItemClassEvent;
    FExtensionColorCodeList: TExtensionColorCodeList;
    FOnGetStorage: TELVGetStorageEvent;
    FOnInvalidRootNamespace: TELVInvalidRootNamespaceEvent;
    FOnLoadStorageFromRoot: TELVLoadStorageFromRoot;
    FOnRootChange: TELVOnRootChange;
    FOnRootChanging: TELVOnRootChanging;
    FOnRootRebuild: TELVOnRootRebuild;
    FOnSaveRootToStorage: TELVSaveRootToStorage;
    FOnShellExecute: TELVOnShellExecute;
    FOnShellNotify: TELVOnShellNotifyEvent;
    FOptions: TVirtualEasyListviewOptions;
    // Stores a copy of what the last view setting were before the RootNamespace was changed.
    // A new object is created each time the Listview is browsed to a new root
    FPrevFolderSettings: TNodeStorage;
    FQueryInfoHintTimeout: Integer;
    FQuickFiltered: Boolean;
    FQuickFilterMask: WideString;
    FQuickFilterUpdatedNeeded: Boolean;
    FRebuildingRootNamespace: Boolean;
    FRootFolder: TRootFolder;
    FRootFolderCustomPath: WideString;
    FRootFolderCustomPIDL: PItemIDList;
    FRootFolderNamespace: TNamespace;
    FSelectedFiles: TStrings;
    FSelectedPaths: TStrings;
    FShellNotifySuspended: Boolean;
    FSortFolderFirstAlways: Boolean;
    FStorage: TRootNodeStorage;         // A tree structure that store the per instance state of the listview in each folder
    FTempRootNamespace: TNamespace;     // Temporary Namespace for internal use
    FThumbsManager: TEasyThumbsManager;
    FUseShellGrouping: Boolean;
    FVETStates: TVETStates;
    FOnAfterShellNotify: TELVOnShellNotifyEvent;
    function GetAutoSort: Boolean;
    function GetDropTargetNS: TNamespace;
    function GetEnumThread: TVirtualBackGndEnumThread;
    function GetExtensionColorCodeList: TExtensionColorCodeList;
    function GetGroupingColumn: Integer;
    function GetItemCount: Integer;
    function GetPaintInfoColumn: TEasyPaintInfoColumn;
    function GetPaintInfoGroup: TEasyPaintInfoGroup;
    function GetPaintInfoItem: TEasyPaintInfoItem;
    function GetSelectedFile: WideString;
    function GetSelectedFiles: TStrings;
    function GetSelectedPaths: TStrings;
    function GetSelectedPath: WideString;
    function GetSelection: TEasyVirtualSelectionManager;
    function GetStorage: TRootNodeStorage;
    function GetThreadedDetailsEnabled: Boolean;
    function GetThreadedIconsEnabled: Boolean;
    function GetThreadedThumbnailsEnabled: Boolean;
    function GetThreadedTilesEnabled: Boolean;
    procedure SetAutoSort(const Value: Boolean);
    procedure SetChangeNotifierEnabled(Value: Boolean);
    procedure SetDefaultSortColumn(const Value: Integer);
    procedure SetDefaultSortDir(const Value: TEasySortDirection);
    procedure SetEnumThread(const Value: TVirtualBackGndEnumThread);
  {$IFDEF EXPLORERCOMBOBOX_L}      
    procedure SetExplorerCombobox(Value: TVirtualExplorerCombobox);
  {$ENDIF}
  {$IFDEF EXPLORERTREEVIEW_L}
    procedure SetExplorerTreeview(Value: TCustomVirtualExplorerTree);
  {$ENDIF}
    procedure SetExtensionColorCode(const Value: Boolean);
    procedure SetFileObjects(Value: TFileObjects);
    procedure SetFileSizeFormat(const Value: TVirtualFileSizeFormat);
    procedure SetGrouped(Value: Boolean);
    procedure SetGroupingColumn(Value: Integer);
    procedure SetPaintInfoColumn(const Value: TEasyPaintInfoColumn);
    procedure SetPaintInfoGroup(const Value: TEasyPaintInfoGroup);
    procedure SetPaintInfoItem(const Value: TEasyPaintInfoItem);
    procedure SetQuickFiltered(const Value: Boolean);
    procedure SetQuickFilterMask(const Value: WideString);
    procedure SetSelection(Value: TEasyVirtualSelectionManager);
    procedure SetSortFolderFirstAlways(const Value: Boolean);
    procedure SetStorage(const Value: TRootNodeStorage);
  protected
    function AddColumnProc: TExplorerColumn;
    function CreateNewFolderInternal(TargetPIDL: PItemIDList; SuggestedFolderName: WideString): WideString;
    function CustomEasyHintWindowClass: THintWindowClass; override;
    function ExecuteDragDrop(AvailableEffects: TCommonDropEffects; DataObjectInf: IDataObject; DropSource: IDropSource; var dwEffect: Integer): HRESULT; override;
    function FindGroup(NS: TNamespace): TExplorerGroup;
    function GetAnimateWndParent: TWinControl; virtual;
    function GetHeaderVisibility: Boolean; virtual;
    function GetOkToShellNotifyDispatch: Boolean; {IVirtualShellNotify}
    function LoadStorageToRoot(StorageNode: TNodeStorage): Boolean; virtual;
    function UseInternalDragImage(DataObject: IDataObject): Boolean; override;
    procedure ActivateTree(Activate: Boolean);
    procedure AddDetailsOfRequest(Request: TEasyDetailStringsThreadRequest);
    procedure CheckForDefaultGroupVisibility;
    procedure CMFontChanged(var Msg: TMessage); message CM_FONTCHANGED;
    procedure CMParentFontChanged(var Msg: TMessage); message CM_PARENTFONTCHANGED;
    procedure ColumnHeaderMenuItemClick(Sender: TObject);
    procedure ColumnSettingCallback(Sender: TObject);
    procedure ContextMenuCmdCallback(Namespace: TNamespace; Verb: WideString; MenuItemID: Integer; var Handled: Boolean);
    procedure ContextMenuShowCallback(Namespace: TNamespace; Menu: hMenu; var Allow: Boolean);
    procedure ContextMenuAfterCmdCallback(Namespace: TNamespace; Verb: WideString; MenuItemID: Integer; Successful: Boolean);
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure DoAfterPaint(ACanvas: TCanvas; ClipRect: TRect); override;
    procedure DoAfterShellNotify(ShellEvent: TVirtualShellEvent); virtual;
    procedure DoColumnClick(Button: TCommonMouseButton; ShiftState: TShiftState; const Column: TEasyColumn); override;
    procedure DoColumnContextMenu(HitInfo: TEasyHitInfoColumn; WindowPoint: TPoint; var Menu: TPopupMenu); override;
    procedure DoContextMenu(MousePt: TPoint; var Handled: Boolean); override;
    procedure DoContextMenu2Message(var Msg: TMessage); virtual;
    procedure DoContextMenuAfterCmd(Namespace: TNamespace; Verb: WideString; MenuItemID: Integer; Successful: Boolean);
    function DoContextMenuCmd(Namespace: TNamespace; Verb: WideString; MenuItemID: Integer): Boolean;
    procedure DoContextMenuSelect(Namespace: TNamespace; MenuItemID : Integer; SubMenuID: hMenu; MouseSelect: Boolean);
    function DoContextMenuShow(Namespace: TNamespace; Menu: hMenu): Boolean;
    procedure DoCustomColumnAdd; virtual;
    procedure DoCustomColumnCompare(Column: TExplorerColumn; Group: TEasyGroup; Item1, Item2: TExplorerItem; var CompareResult: Integer); virtual;
    procedure DoCustomColumnGetCaption(Column: TExplorerColumn; Item: TExplorerItem; var Caption: WideString); virtual;
    procedure DoCustomGroup(Groups: TEasyGroups; NS: TNamespace; var Group: TExplorerGroup); virtual;
    procedure DoEnumFinished; virtual;
    procedure DoEnumFolder(const Namespace: TNamespace; var AllowAsChild: Boolean); virtual;
    function DoGroupCompare(Column: TEasyColumn; Group1, Group2: TEasyGroup): Integer; override;
    function DoItemCompare(Column: TEasyColumn; Group: TEasyGroup; Item1: TEasyItem; Item2: TEasyItem): Integer; override;
    procedure DoEnumThreadLengthyOperation(var ShowAnimation: Boolean);
    procedure DoExplorerGroupClass(var GroupClass: TExplorerGroupClass);
    procedure DoExplorerItemClass(var ItemClass: TExplorerItemClass); virtual;
    procedure DoGetHintTimeOut(var HintTimeOut: Integer); override;
    procedure DoGetStorage(var Storage: TRootNodeStorage); virtual;
    procedure DoGroupingChange; virtual;
    procedure DoHintPopup(TargetObj: TEasyCollectionItem; HintType: TEasyHintType; MousePos: TPoint; var AText: WideString; var HideTimeout: Integer; var ReshowTimeout: Integer; var Allow: Boolean); override;
    procedure DoInvalidRootNamespace;
    procedure DoItemContextMenu(HitInfo: TEasyHitInfoItem; WindowPoint: TPoint; var Menu: TPopupMenu; var Handled: Boolean); override;
    procedure DoItemCreateEditor(Item: TEasyItem; var Editor: IEasyCellEditor); override;
    procedure DoItemCustomView(Item: TEasyItem; ViewStyle: TEasyListStyle; var View: TEasyViewItemClass); override;
    procedure DoItemDblClick(Button: TCommonMouseButton; MousePos: TPoint; HitInfo: TEasyHitInfoItem); override;
    procedure DoItemGetCaption(Item: TEasyItem; Column: Integer; var ACaption: WideString); override;
    procedure DoItemGetEditCaption(Item: TEasyItem; Column: TEasyColumn; var Caption: WideString); override;
    procedure DoItemGetImageIndex(Item: TEasyItem; Column: Integer; ImageKind: TEasyImageKind; var ImageIndex: TCommonImageIndexInteger); override;
    procedure DoItemGetTileDetail(Item: TEasyItem; Line: Integer; var Detail: Integer); override;
    procedure DoItemGetTileDetailCount(Item: TEasyItem; var Count: Integer); override;
    procedure DoItemPaintText(Item: TEasyItem; Position: Integer; ACanvas: TCanvas); override;
    procedure DoItemSetCaption(Item: TEasyItem; Column: Integer; const Caption: WideString); override;
    procedure DoItemThumbnailDraw(Item: TEasyItem; ACanvas: TCanvas; ARect: TRect; AlphaBlender: TEasyAlphaBlender; var DoDefault: Boolean); override;
    procedure DoKeyAction(var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean); override;
    procedure DoLoadStorageToRoot(StorageNode: TNodeStorage); virtual;
    procedure DoNamespaceStructureChange(Item: TExplorerItem; ChangeType: TNamespaceStructureChange); virtual;
    procedure DoOLEDragStart(ADataObject: IDataObject; var AvailableEffects: TCommonDropEffects; var AllowDrag: Boolean); override;
    procedure DoOLEDropTargetDragDrop(DataObject: IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint; AvailableEffects: TCommonDropEffects; var DesiredEffect: TCommonDropEffect; var Handled: Boolean); override;
    procedure DoOLEDropTargetDragEnter(DataObject: IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint; AvailableEffects: TCommonDropEffects; var DesiredEffect: TCommonDropEffect); override;
    procedure DoOLEDropTargetDragLeave; override;
    procedure DoOLEDropTargetDragOver(KeyState: TCommonKeyStates; WindowPt: TPoint; AvailableEffects: TCommonDropEffects; var DesiredEffect: TCommonDropEffect); override;
    procedure DoOLEGetDataObject(var DataObject: IDataObject); override;
    procedure DoQuickFilterCustomCompare(Item: TExplorerItem; Mask: WideString; var IsVisible: Boolean); virtual;
    procedure DoQuickFilterEnd; virtual;
    procedure DoQuickFilterStart(Mask: WideString); virtual;
    procedure DoRebuildingShellHeader(var Allow: Boolean); virtual;
    procedure DoRebuiltShellHeader; virtual;
    procedure DoRootChange; virtual;
    procedure DoRootChanging(const NewRoot: TRootFolder; Namespace: TNamespace; var Allow: Boolean); virtual;
    procedure DoRootRebuild; virtual;
    procedure DoSaveRootToStorage(StorageNode: TNodeStorage); virtual;
    procedure DoScrollEnd(ScrollBar: TEasyScrollbarDir); override;
    procedure DoShellExecute(Item: TEasyItem); virtual;
    procedure DoShellNotify(ShellEvent: TVirtualShellEvent); virtual;
    procedure DoThreadCallback(var Msg: TWMThreadRequest); override;
    function EnumFolderCallback(ParentWnd: HWnd; APIDL: PItemIDList; AParent: TNamespace; Data: pointer; var Terminate: Boolean): Boolean; virtual;
    procedure DoThumbThreadCreate(var ThumbRequest: TEasyThumbnailThreadRequest); virtual;
    procedure Enqueue(NS: TNamespace; Item: TEasyItem; ThumbSize: TPoint; UseShellExtraction, IsResizing: Boolean);
    procedure EnumThreadFinished(DoSort: Boolean);
    procedure EnumThreadStart;
    procedure EnumThreadTimer(Enable: Boolean);
    procedure FlushDetailsOfThread;
    procedure ForceIconCachRebuild;
    procedure HideAnimateFolderWnd;
    procedure InvalidateImageByIndex(ImageIndex: Integer);
    function ItemBelongsToList(Item: TExplorerItem): Boolean;
    procedure LockChangeNotifier;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function OkToBrowseTo(PIDL: PItemIDList): Boolean; virtual;
    procedure Notify(var Msg: TMessage); {IShellNotify}
    procedure OrphanThreadsFree;
    procedure PackTileStrings(NS: TNamespace);
    procedure ReadItems(var AnItemArray: TEasyItemArray; Sorted: Boolean; var ValidItemsRead: Integer);
    procedure RebuildCategories;
    procedure RebuildRootNamespace;
    procedure SaveRebuildRestoreRootNamespace;
    procedure SaveRootToStorage(StorageNode: TNodeStorage); virtual;
    procedure SetActive(Value: Boolean); virtual;
    procedure SetOptions(Value: TVirtualEasyListviewOptions); virtual;
    procedure SetRootFolder(Value: TRootFolder); virtual;
    procedure SetRootFolderCustomPath(Value: WideString); virtual;
    procedure SetRootFolderCustomPIDL(Value: PItemIDList); virtual;
    procedure SetView(Value: TEasyListStyle); override;
    procedure ShowAnimateFolderWnd;
    procedure TerminateDetailsOfThread;
    procedure TerminateEnumThread;
    procedure TestVisiblilityForSingleColumn;
    procedure UpdateColumnsFromDialog(VST: TVirtualStringTree);
    procedure UpdateDefaultSortColumnAndSortDir;
    procedure WMChangeCBChain(var Msg: TMessage); message WM_CHANGECBCHAIN;
    procedure WMContextmenu(var Msg: TMessage); message WM_CONTEXTMENU;
    procedure WMCreate(var Msg: TMessage); message WM_CREATE;
    procedure WMDetailsOfThread(var Msg: TWMThreadRequest); message WM_DETAILSOF_THREAD;
    procedure WMDrawClipboard(var Msg: TMessage); message WM_DRAWCLIPBOARD;
    procedure WMDrawItem(var Msg: TWMDrawItem); message WM_DRAWITEM;
    procedure WMInitMenuPopup(var Msg: TWMInitMenuPopup); message WM_INITMENUPOPUP;
    procedure WMKeyDown(var Msg: TWMKeyDown); message WM_KEYDOWN;
    procedure WMMeasureItem(var Msg: TWMMeasureItem); message WM_MEASUREITEM;
    procedure WMMenuSelect(var Msg: TWMMenuSelect); message WM_MENUSELECT;
    procedure WMNCDestroy(var Msg: TMessage); message WM_NCDESTROY;
    procedure WMShellNotify(var Msg: TMessage); message WM_SHELLNOTIFY;
    procedure WMSysChar(var Msg: TWMSysChar); message WM_SYSCHAR;
    procedure WMTimer(var Msg: TWMTimer); message WM_TIMER;
    property Activated: Boolean read FActivated write FActivated;
    property Active: Boolean read FActive write SetActive default False;
    property AutoSort: Boolean read GetAutoSort write SetAutoSort default True;
    property BackBrowseRoot: TNamespace read FBackBrowseRoot write FBackBrowseRoot;
    property BackGndMenu: TVirtualShellBackgroundContextMenu read FBackGndMenu write FBackGndMenu;
    property CategoryInfo: TCategories read FCategoryInfo;
    property ChangeNotifierCount: integer read FChangeNotifierCount write FChangeNotifierCount;
    property ChangeNotifierEnabled: Boolean read FChangeNotifierEnabled write SetChangeNotifierEnabled;
    property ClipChainWnd: HWnd read FClipChainWnd write FClipChainWnd;
    property ColumnHeaderMenu: TPopupMenu read FColumnHeaderMenu write FColumnHeaderMenu;
    property ColumnMenuItemCount: Integer read FColumnMenuItemCount write FColumnMenuItemCount default 5;
    property CompressedFile: TVirtualCustomFileTypes read FCompressedFile write FCompressedFile;
    property DefaultSortColumn: Integer read FDefaultSortColumn write SetDefaultSortColumn default -1;
    property DefaultSortDir: TEasySortDirection read FDefaultSortDir write SetDefaultSortDir default esdNone;
    property DetailsOfThread: TCommonEventThread read FDetailsOfThread write FDetailsOfThread;
    property EnumThread: TVirtualBackGndEnumThread read GetEnumThread write SetEnumThread;
    property ExtensionColorCode: Boolean read FExtensionColorCode write SetExtensionColorCode default False;
    property ExtensionColorCodeSelected: Boolean read FExtensionColorCodeSelected write FExtensionColorCodeSelected default True;
    property FileSizeFormat: TVirtualFileSizeFormat read FFileSizeFormat write SetFileSizeFormat;
    property OldTopNode: PItemIDList read FOldTopNode write FOldTopNode;
    property OrphanThreadList: TList read FOrphanThreadList write FOrphanThreadList;
    property DragDataObject: IDataObject read FDragDataObject write FDragDataObject;
    property DropTargetNS: TNamespace read GetDropTargetNS;
    property EncryptedFile: TVirtualCustomFileTypes read FEncryptedFile write FEncryptedFile;
    property EnumBkGndList: TCommonPIDLList read FEnumBkGndList write FEnumBkGndList;
    property EnumBkGndTime: Cardinal read FEnumBkGndTime write FEnumBkGndTime;
    property EnumLock: TRTLCriticalSection read FEnumLock write FEnumLock;
    property EnumTimer: THandle read FEnumTimer write FEnumTimer;
   {$IFDEF EXPLORERCOMBOBOX_L}
    property ExplorerCombobox: TVirtualExplorerCombobox read FExplorerCombobox write SetExplorerCombobox;
   {$ENDIF}
   {$IFDEF EXPLORERTREEVIEW_L}
    property ExplorerTreeview: TCustomVirtualExplorerTree read FExplorerTreeview write SetExplorerTreeview;
   {$ENDIF}
    property ExtensionColorCodeList: TExtensionColorCodeList read GetExtensionColorCodeList;
    property FileObjects: TFileObjects read FFileObjects write SetFileObjects default [foFolders, foNonFolders];
    property Grouped: Boolean read FGrouped write SetGrouped;
    property GroupingColumn: Integer read GetGroupingColumn write SetGroupingColumn;
    property GroupingFileSizeArray: TGroupingFileSizeArray read FGroupingFileSizeArray write FGroupingFileSizeArray;
    property GroupingModifiedArray: TGroupingModifiedArray read FGroupingModifiedArray write FGroupingModifiedArray;
    property ItemCount: Integer read GetItemCount;
    property LastDropTargetNS: TNamespace read FLastDropTargetNS write FLastDropTargetNS;
    property Lock: TRTLCriticalSection read FLock write FLock;
    property Malloc: IMalloc read FMalloc write FMalloc;
    property OnAfterPaint: TAfterPaintEvent read FOnAfterPaint write FOnAfterPaint;
    property OnAfterShellNotify: TELVOnShellNotifyEvent read FOnAfterShellNotify write FOnAfterShellNotify;
    property OnBeforeItemThumbnailDraw: TELVOnBeforeItemThumbnailDraw read FOnBeforeItemThumbnailDraw write FOnBeforeItemThumbnailDraw;
    property OnCustomColumnAdd: TVELCustomColumnAddEvent read FOnCustomColumnAdd write FOnCustomColumnAdd;
    property OnClipboardChange: TNotifyEvent read FOnClipboardChange write FOnClipboardChange;
    property OnContextMenu2Message: TELVContextMenu2MessageEvent read FOnContextMenu2Message write FOnContextMenu2Message;
    property OnContextMenuAfterCmd: TELVOnContextMenuAfterCmd read FOnContextMenuAfterCmd write FOnContextMenuAfterCmd;
    property OnContextMenuItemChange: TELVContextMenuItemChange read FOnContextMenuItemChange write FOnContextMenuItemChange;
    property OnContextMenuCmd: TELVOnContextMenuCmd read FOnContextMenuCmd write FOnContextMenuCmd;
    property OnContextMenuShow: TELVOnContextMenuShow read FOnContextMenuShow write FOnContextMenuShow;
    property OnCustomColumnCompare: TELVCustomColumnCompareEvent read FOnCustomColumnCompare write FOnCustomColumnCompare;
    property OnCustomColumnGetCaption: TELVCustomColumnGetCaptionEvent read FOnCustomColumnGetCaption write FOnCustomColumnGetCaption;
    property OnCustomGroup: TEasyCustomGroupEvent read FOnCustomGroup write FOnCustomGroup;
    property OnEnumFinished: TELVEnumFinishedEvent read FOnEnumFinished write FOnEnumFinished;
    property OnEnumFolder: TELVOnEnumFolder read FOnEnumFolder write FOnEnumFolder;
    property OnEnumThreadLengthyOperation: TELVEnumLenghyOperaionEvent read FOnEnumThreadLengthyOperation write FOnEnumThreadLengthyOperation;
    property OnExplorerGroupClass: TELVExplorerGroupClassEvent read FOnExplorerGroupClass write FOnExplorerGroupClass;
    property OnExplorerItemClass: TELVExplorerItemClassEvent read FOnExplorerItemClass write FOnExplorerItemClass;
    property OnGetStorage: TELVGetStorageEvent read FOnGetStorage write FOnGetStorage;
    property OnGroupingChange: TNotifyEvent read FOnGroupingChange write FOnGroupingChange;
    property OnInvalidRootNamespace: TELVInvalidRootNamespaceEvent read FOnInvalidRootNamespace write FOnInvalidRootNamespace;
    property OnLoadStorageFromRoot: TELVLoadStorageFromRoot read FOnLoadStorageFromRoot write FOnLoadStorageFromRoot;
    property OnQuickFilterCustomCompare: TELVQuickFilterCustomCompareEvent read FOnQuickFilterCustomCompare write FOnQuickFilterCustomCompare;
    property OnQuickFilterEnd: TNotifyEvent read FOnQuickFilterEnd write FOnQuickFilterEnd;
    property OnQuickFilterStart: TELVQuickFilterStartEvent read FOnQuickFilterStart write FOnQuickFilterStart;
    property OnRebuildingShellHeader: TELVRebuildingShellHeaderEvent read FOnRebuildingShellHeader write FOnRebuildingShellHeader;
    property OnRebuiltShellHeader: TELVRebuiltShellHeaderEvent read FOnRebuiltShellHeader write FOnRebuiltShellHeader;
    property OnRootChange: TELVOnRootChange read FOnRootChange write FOnRootChange;
    property OnRootChanging: TELVOnRootChanging read FOnRootChanging write FOnRootChanging;
    property OnRootRebuild: TELVOnRootRebuild read FOnRootRebuild write FOnRootRebuild;
    property OnSaveRootToStorage: TELVSaveRootToStorage read FOnSaveRootToStorage write FOnSaveRootToStorage;
    property OnShellExecute: TELVOnShellExecute read FOnShellExecute write FOnShellExecute;
    property OnShellNotify: TELVOnShellNotifyEvent read FOnShellNotify write FOnShellNotify;
    property OnThumbRequestCreate: TELVThumbThreadCreateCallbackEvent read FOnThumbRequestCreate write FOnThumbRequestCreate;
    property Options: TVirtualEasyListviewOptions read FOptions write SetOptions default [eloBrowseExecuteFolder, eloBrowseExecuteFolderShortcut, eloBrowseExecuteZipFolder, eloExecuteOnDblClick, eloThreadedImages, eloThreadedDetails];
    property PaintInfoColumn: TEasyPaintInfoColumn read GetPaintInfoColumn write SetPaintInfoColumn;
    property PaintInfoGroup: TEasyPaintInfoGroup read GetPaintInfoGroup write SetPaintInfoGroup;
    property PaintInfoItem: TEasyPaintInfoItem read GetPaintInfoItem write SetPaintInfoItem;
    property QueryInfoHintTimeout: Integer read FQueryInfoHintTimeout write FQueryInfoHintTimeout default 2500;
    property QuickFilterUpdatedNeeded: Boolean read FQuickFilterUpdatedNeeded write FQuickFilterUpdatedNeeded;
    property RebuildingRootNamespace: Boolean read FRebuildingRootNamespace write FRebuildingRootNamespace;
    property RootFolder: TRootFolder read FRootFolder write SetRootFolder default rfDesktop;
    property RootFolderCustomPath: WideString read FRootFolderCustomPath write SetRootFolderCustomPath;
    property RootFolderCustomPIDL: PItemIDList read FRootFolderCustomPIDL write SetRootFolderCustomPIDL;
    property RootFolderNamespace: TNamespace read FRootFolderNamespace;
    property Selection: TEasyVirtualSelectionManager read GetSelection write SetSelection;
    property SortFolderFirstAlways: Boolean read FSortFolderFirstAlways write SetSortFolderFirstAlways default False;
    property TempRootNamespace: TNamespace read FTempRootNamespace write FTempRootNamespace;
    property ThreadedDetailsEnabled: Boolean read GetThreadedDetailsEnabled;
    property ThreadedIconsEnabled: Boolean read GetThreadedIconsEnabled;
    property ThreadedThumbnailsEnabled: Boolean read GetThreadedThumbnailsEnabled;
    property ThreadedTilesEnabled: Boolean read GetThreadedTilesEnabled;
    property ThumbsManager: TEasyThumbsManager read FThumbsManager write FThumbsManager;
    property UseShellGrouping: Boolean read FUseShellGrouping write FUseShellGrouping default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddCustomItem(Group: TEasyGroup; NS: TNamespace; LockoutSort: Boolean): TExplorerItem; virtual;
    function BrowseTo(APath: WideString; SelectTarget: Boolean = True): Boolean;
    function BrowseToByPIDL(APIDL: PItemIDList; SelectTarget: Boolean = True; ShowExplorerMsg: Boolean = True): Boolean; virtual;
    function BrowseToNextLevel: Boolean;
    function CreateNewFolder(TargetPath: WideString): Boolean; overload;
    function CreateNewFolder(TargetPath: WideString; var NewFolder: WideString): Boolean; overload;
    function CreateNewFolder(TargetPath, SuggestedFolderName: WideString; var NewFolder: WideString): Boolean; overload;
    function FindInsertPosition(WindowX, WindowY: Integer; var Group: TEasyGroup): Integer;
    function FindItemByPath(Path: WideString): TEasyItem;
    function FindItemByPIDL(PIDL: PItemIDList): TExplorerItem;
    function GroupClass:  TExplorerGroupClass;
    function IsRootNamespace(PIDL: PItemIDList): Boolean;
    function LoadFolderFromPropertyBag(IgnoreOptions: Boolean = False): Boolean;
    function LoadFolderFromPrevView: Boolean;
    function RereadAndRefresh(DoSort: Boolean): TEasyItem; dynamic;
    procedure RebuildShellHeader;
    function SelectedToDataObject: IDataObject; virtual;
    function SelectedToNamespaceArray: TNamespaceArray; virtual;
    function SelectedToPIDLArray: TRelativePIDLArray; virtual;
    function ValidateNamespace(Item: TEasyItem; var Namespace: TNamespace): Boolean;
    function ValidateThumbnail(Item: TEasyItem; var ThumbInfo: TThumbInfo): Boolean;
    function ValidRootNamespace: Boolean;
    procedure BrowseToPrevLevel; virtual;
    procedure ChangeLinkChanging(Server: TObject; NewPIDL: PItemIDList); dynamic; // ChangeLink method
    procedure ChangeLinkDispatch; virtual;
    procedure ChangeLinkFreeing(ChangeLink: IVETChangeLink); dynamic;
    procedure Clear;
    procedure CopyToClipboard(AbsolutePIDLs: Integer = 0); override;
    procedure CutToClipboard(AbsolutePIDLs: Integer = 0); override;
    procedure LoadAllThumbs;
    procedure Loaded; override;
    procedure LoadFromStream(S: TStream); override;
    procedure LockBrowseLevel;
    procedure MarkSelectedCopied;
    procedure PasteFromClipboard; override;
    procedure PasteFromClipboardAsShortcut;
    procedure QuickFilter;
    procedure Rebuild(RestoreTopNode: Boolean = False); dynamic;
    procedure SaveToStream(S: TStream); override;
    procedure SelectedFilesDelete(ShiftKeyState: TExecuteVerbShift = evsCurrent); virtual;
    procedure SelectedFilesShowProperties; virtual;
    procedure SortList;
    procedure StoreFolderToPropertyBag(Force: Boolean; IgnoreOptions: Boolean = False);
    property AnimateFolderEnum: TAnimate read FAnimateFolderEnum write FAnimateFolderEnum;
    property ContextMenuItem: TEasyItem read FContextMenuItem;
    property ELVPersistent: TELVPersistent read FELVPersistent write FELVPersistent;
    {$IFDEF USE_TOOLBAR_TB2K}
    property MenuClass: TTBPopupMenuClass read FMenuClass write FMenuClass;
    property ItemClass: TTBCustomItemClass read FItemClass write FItemClass;
    {$ENDIF}
    property ContextMenuShown: Boolean read FContextMenuShown;
    property IENamespaceShown: Boolean read FIENamespaceShown;
    property OnGenericCallback;
    property PrevFolderSettings: TNodeStorage read FPrevFolderSettings write FPrevFolderSettings;
    property QuickFiltered: Boolean read FQuickFiltered write SetQuickFiltered;
    property QuickFilterMask: WideString read FQuickFilterMask write SetQuickFilterMask;
    property SelectedFile: WideString read GetSelectedFile;
    property SelectedFiles: TStrings read GetSelectedFiles;
    property SelectedPaths: TStrings read GetSelectedPaths;
    property SelectedPath: WideString read GetSelectedPath;
    property ShellNotifySuspended: Boolean read FShellNotifySuspended write FShellNotifySuspended;
    property Storage: TRootNodeStorage read GetStorage write SetStorage;
    property VETStates: TVETStates read FVETStates write FVETStates;
  end;

  //
  // EasyListview Item for the DropStack window that stores the reference to
  // the DataObject for the objects to be moved/copies/linked
  //
   TVirtualDropStackAutoRemove = (
    dsarMoveOnly,
    dsarAlways,
    dsarRightDragOnly
  );

  TVirtualDropStackItem = class(TEasyItemStored)
  private
    FDataObject: IDataObject;
  public
    destructor Destroy; override;
    property DataObject: IDataObject read FDataObject write FDataObject;
  end;

  TCustomVirtualDropStack = class(TCustomEasyListview)
  private
    FAutoRemove: TVirtualDropStackAutoRemove;
    FDataObjectTemp: IDataObject;
    FOnDragDrop: TNotifyEvent;
    FHintItemCount: Word;
    FStackDepth: Word;
  protected
    procedure AddDropStackItems(const DataObject: IDataObject);
    procedure DoHintPopup(TargetObj: TEasyCollectionItem; HintType: TEasyHintType; MousePos: TPoint; var AText: WideString; var HideTimeout: Integer; var ReshowTimeout: Integer; var Allow: Boolean); override;
    procedure DoOLEDragEnd(ADataObject: IDataObject; DragResult: TCommonOLEDragResult; ResultEffect: TCommonDropEffects; KeyStates: TCommonKeyStates); override;
    procedure DoOLEDragStart(ADataObject: IDataObject; var AvailableEffects: TCommonDropEffects; var AllowDrag: Boolean); override;
    procedure DoOLEDropTargetDragDrop(DataObject: IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint; AvailableEffects: TCommonDropEffects; var DesiredEffect: TCommonDropEffect; var Handled: Boolean); override;
    procedure DoOLEDropTargetDragEnter(DataObject: IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint; AvailableEffects: TCommonDropEffects; var DesiredEffect: TCommonDropEffect); override;
    procedure DoOLEDropTargetDragLeave; override;
    procedure DoOLEDropTargetDragOver(KeyState: TCommonKeyStates; WindowPt: TPoint; AvailableEffects: TCommonDropEffects; var DesiredEffect: TCommonDropEffect); override;
    procedure DoOLEGetDataObject(var DataObject: IDataObject); override;
    procedure DoViewChange; override;
    property AutoRemove: TVirtualDropStackAutoRemove read FAutoRemove write FAutoRemove default dsarMoveOnly;
    property DataObjectTemp: IDataObject read FDataObjectTemp write FDataObjectTemp;
    property HintItemCount: Word read FHintItemCount write FHintItemCount default 16;
    property OnDragDrop: TNotifyEvent read FOnDragDrop write FOnDragDrop;
    property StackDepth: Word read FStackDepth write FStackDepth default 64;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualExplorerEasyListview = class(TCustomVirtualExplorerEasyListview)
  private
  public
    property AllowHiddenCheckedItems;
    property CategoryInfo;
    property ExtensionColorCodeList;
    property GlobalImages;
    property GroupingFileSizeArray;
    property GroupingModifiedArray;
    property ItemCount;
    property Items;
    property States;
    property RootFolderCustomPIDL;
    property RootFolderNamespace;
    property Scrollbars;
  published
    property Active;
    property Align;
    property Anchors;
    property AutoSort;
    property BackGndMenu;
    property BackGround;
    property BevelKind;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property CellSizes;
    property Color;
    property ColumnMenuItemCount;
    property CompressedFile;
    property Constraints;
    property Ctl3D;
    property DefaultSortColumn;
    property DefaultSortDir;
    property EditManager;
    property EncryptedFile;
    property ExtensionColorCode;
    property ExtensionColorCodeSelected;
    property DragKind;
    property DragManager;
  {$IFDEF EXPLORERCOMBOBOX_L}
    property ExplorerCombobox;
  {$ENDIF}
  {$IFDEF EXPLORERTREEVIEW_L}
    property ExplorerTreeview;
  {$ENDIF}
    property FileObjects;
    property FileSizeFormat;
    property Font;
    property Gesture;
    property GroupCollapseButton;
    property Grouped;
    property GroupExpandButton;
    property GroupingColumn;
    property Groups;
    property GroupFont;
    property HintAlignment;
    property HintType;
    property Header;
    property HotTrack;
    property IncrementalSearch;
    property OnRebuildingShellHeader;
    property OnRebuiltShellHeader;
    property Options;
    property PaintInfoColumn;
    property PaintInfoGroup;
    property PaintInfoItem;
    property ParentBiDiMode;
    property ParentBackground;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property QueryInfoHintTimeout;
    property RootFolder;
    property RootFolderCustomPath;
    property ShowHint;
    property ShowGroupMargins;
    property ShowImages;
    property ShowInactive;
    property ShowThemedBorder;
    property Sort;
    property SortFolderFirstAlways;
    property Selection;
    property TabOrder;
    property TabStop;
    property Themed;
    property ThumbsManager;
    property View;
    property Visible;
    property WheelMouseDefaultScroll;
    property WheelMouseScrollModifierEnabled;

    property OnAfterPaint;
    property OnAfterShellNotify;
    property OnBeforeItemThumbnailDraw;
    property OnBeginUpdate;
    property OnCanResize;
    property OnClick;
    property OnClipboardChange;
    property OnClipboardCopy;
    property OnClipboardCut;
    property OnClipboardPaste;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnColumnCheckChanged;
    property OnColumnCheckChanging;
    property OnColumnClick;
    property OnColumnContextMenu;
    property OnColumnCustomView;
    property OnColumnDblClick;
    property OnColumnEnableChanged;
    property OnColumnEnableChanging;
    property OnColumnFreeing;
    property OnColumnImageDraw;
    property OnColumnImageGetSize;
    property OnColumnImageDrawIsCustom;
    property OnColumnInitialize;
    property OnColumnLoadFromStream;
    property OnColumnPaintText;
    property OnColumnSaveToStream;
    property OnColumnSelectionChanged;
    property OnColumnSelectionChanging;
    property OnColumnSizeChanged;
    property OnColumnSizeChanging;
    property OnColumnStructureChange;
    property OnColumnVisibilityChanged;
    property OnColumnVisibilityChanging;
    property OnContextMenu;
    property OnContextMenu2Message;
    property OnContextMenuAfterCmd;
    property OnContextMenuCmd;
    property OnContextMenuItemChange;
    property OnContextMenuShow;
    property OnCustomColumnAdd;
    property OnCustomColumnCompare;
    property OnCustomColumnGetCaption;
    property OnCustomGrid;
    property OnCustomGroup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDockDrop;
    property OnDockOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEndUpdate;
    property OnEnter;
    property OnEnumFinished;
    property OnEnumFolder;
    property OnEnumThreadLengthyOperation;
    property OnExit;
    property OnExplorerGroupClass;
    property OnExplorerItemClass;
    property OnGetDragImage;
    property OnGetSiteInfo;
    property OnGetStorage;
    property OnGroupClick;
    property OnGroupCollapse;
    property OnGroupCollapsing;
    property OnGroupCompare;
    property OnGroupContextMenu;
    property OnGroupCustomView;
    property OnGroupDblClick;
    property OnGroupExpand;
    property OnGroupExpanding;
    property OnGroupFreeing;
    property OnGroupImageDraw;
    property OnGroupImageGetSize;
    property OnGroupImageDrawIsCustom;
    property OnGroupingChange;
    property OnGroupLoadFromStream;
    property OnGroupInitialize;
    property OnGroupPaintText;
    property OnGroupSaveToStream;
    property OnGroupStructureChange;
 //   property OnGroupHotTrack;
    property OnGroupVisibilityChanged;
    property OnGroupVisibilityChanging;
    property OnHeaderDblClick;
    property OnHeaderMouseDown;
    property OnHeaderMouseMove;
    property OnHeaderMouseUp;
    property OnHintCustomInfo;
    property OnHintCustomDraw;
    property OnHintPauseTime;
    property OnHintPopup;
    property OnIncrementalSearch;
    property OnInvalidRootNamespace;
    property OnItemCheckChange;
    property OnItemCheckChanging;
    property OnItemClick;
    property OnItemCompare;
    property OnItemContextMenu;
    property OnItemCreateEditor;
    property OnItemCustomView;
    property OnItemDblClick;
    property OnItemEditAccepted;
    property OnItemEditBegin;
    property OnItemEdited;
    property OnItemEditEnd;
    property OnItemEnableChange;
    property OnItemEnableChanging;
    property OnItemFreeing;
    property OnItemFocusChanged;
    property OnItemFocusChanging;
    property OnItemGetCaption;
    property OnItemGetEditCaption;
    property OnItemGetImageIndex;
    property OnItemGetImageList;
    property OnItemGetTileDetail;
    property OnItemGetTileDetailCount;
    property OnItemImageDraw;
    property OnItemImageGetSize;
    property OnItemImageDrawIsCustom;
    property OnItemInitialize;
    property OnItemLoadFromStream;
    property OnItemMouseDown;
    property OnItemPaintText;
    property OnItemSaveToStream;
    property OnItemSelectionChanged;
    property OnItemSelectionChanging;
    property OnItemStructureChange;
    property OnItemThumbnailDraw;
    property OnItemSelectionsChanged;
    property OnItemVisibilityChanged;
    property OnItemVisibilityChanging;
    property OnLoadStorageFromRoot;
    property OnKeyAction;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseGesture;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnOLEDragEnd;
    property OnOLEDragStart;
    property OnOLEDragEnter;
    property OnOLEDragOver;
    property OnOLEDragLeave;
    property OnOLEDragDrop;
    property OnOLEGetData;
    property OnOLEGetDataObject;
    property OnOLEQueryContineDrag;
    property OnOLEGiveFeedback;
    property OnOLEQueryData;
    property OnPaintHeaderBkGnd;
    property OnQuickFilterCustomCompare;
    property OnQuickFilterEnd;
    property OnQuickFilterStart;
    property OnResize;
    property OnRootChange;
    property OnRootChanging;
    property OnRootRebuild;
    property OnScroll;
    property OnSaveRootToStorage;
    property OnShellExecute;
    property OnShellNotify;
    property OnSortBegin;
    property OnSortEnd;
    property OnStartDock;
    property OnStartDrag;
    property OnThumbRequestCreate;
    property OnUnDock;
    property OnViewChange;
  end;

  TCustomVirtualMultiPathExplorerEasyListview = class(TCustomVirtualExplorerEasyListview)
  private
    FColumnIndex: Integer;
  protected
    function DoItemCompare(Column: TEasyColumn; Group: TEasyGroup; Item1: TEasyItem; Item2: TEasyItem): Integer; override;
    procedure DoCustomColumnAdd; override;
    procedure DoCustomColumnCompare(Column: TExplorerColumn; Group: TEasyGroup; Item1: TExplorerItem; Item2: TExplorerItem; var CompareResult: Integer); override;
    procedure DoCustomColumnGetCaption(Column: TExplorerColumn; Item: TExplorerItem; var Caption: WideString); override;
    procedure ScanAndDeleteInValidItems;
    property ColumnIndex: Integer read FColumnIndex write FColumnIndex;
  public
    constructor Create(AOwner: TComponent); override;
    function RereadAndRefresh(DoSort: Boolean): TEasyItem; override;
    procedure CopyToClipboard(AbsolutePIDLs: Integer = 1); override;
    procedure CutToClipboard(AbsolutePIDLs: Integer = 1); override;
    procedure Rebuild(RestoreTopNode: Boolean = False); override;
    procedure SelectedFilesDelete(ShiftKeyState: TExecuteVerbShift = evsCurrent); override;
  published
    property Active default True;
    property OnRebuildingShellHeader;
  end;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualMultiPathExplorerEasyListview = class(TCustomVirtualMultiPathExplorerEasyListview)
  public
    property CategoryInfo;
    property ExtensionColorCodeList;
    property GlobalImages;
    property GroupingFileSizeArray;
    property GroupingModifiedArray;
    property ItemCount;
    property Items;
    property States;
    property Scrollbars;
  published
    property Active;
    property AllowHiddenCheckedItems;
    property Align;
    property Anchors;
    property AutoSort;
    property BackGndMenu;
    property BackGround;
    property BevelKind;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property CellSizes;
    property Color;
    property ColumnMenuItemCount;
    property CompressedFile;
    property Constraints;
    property Ctl3D;
    property DefaultSortColumn;
    property DefaultSortDir;
    property EditManager;
    property EncryptedFile;
    property ExtensionColorCode;
    property ExtensionColorCodeSelected;
    property FileSizeFormat;
    property DragKind;
    property DragManager;
  {$IFDEF EXPLORERCOMBOBOX_L}
    property ExplorerCombobox;
  {$ENDIF}
  {$IFDEF EXPLORERTREEVIEW_L}
    property ExplorerTreeview;
  {$ENDIF}
    property Font;
    property GroupCollapseButton;
    property Grouped;
    property GroupExpandButton;
    property GroupingColumn;
    property Groups;
    property GroupFont;
    property HintAlignment;
    property HintType;
    property Header;
    property HotTrack;
    property IncrementalSearch;
    property Options;
    property PaintInfoColumn;
    property PaintInfoGroup;
    property PaintInfoItem;
    property ParentBiDiMode;
    property ParentBackground;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property QueryInfoHintTimeout;
    property RootFolder;
    property RootFolderCustomPath;
    property ShowHint;
    property ShowGroupMargins;
    property ShowInactive;
    property ShowThemedBorder;
    property Sort;
    property SortFolderFirstAlways;
    property Selection;
    property TabOrder;
    property TabStop;
    property Themed;
    property ThumbsManager;
    property View;
    property Visible;
    property WheelMouseDefaultScroll;
    property WheelMouseScrollModifierEnabled;

    property OnAfterPaint;
    property OnCanResize;
    property OnClick;
    property OnClipboardChange;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnColumnCheckChanged;
    property OnColumnCheckChanging;
    property OnColumnClick;
    property OnColumnContextMenu;
    property OnColumnCustomView;
    property OnColumnDblClick;
    property OnColumnEnableChanged;
    property OnColumnEnableChanging;
    property OnColumnFreeing;
    property OnColumnImageDraw;
    property OnColumnImageGetSize;
    property OnColumnImageDrawIsCustom;
    property OnColumnInitialize;
    property OnColumnLoadFromStream;
    property OnColumnPaintText;
    property OnColumnSaveToStream;
    property OnColumnSelectionChanged;
    property OnColumnSelectionChanging;
    property OnColumnSizeChanged;
    property OnColumnSizeChanging;
    property OnColumnVisibilityChanged;
    property OnColumnVisibilityChanging;
    property OnContextMenu;
    property OnContextMenu2Message;
    property OnContextMenuAfterCmd;
    property OnContextMenuCmd;
    property OnContextMenuItemChange;
    property OnContextMenuShow;
    property OnCustomColumnAdd;
    property OnCustomColumnCompare;
    property OnCustomColumnGetCaption;
    property OnCustomGrid;
    property OnCustomGroup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDockDrop;
    property OnDockOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEndUpdate;
    property OnEnter;
    property OnExit;
    property OnExplorerGroupClass;
    property OnExplorerItemClass;
    property OnGetDragImage;
    property OnGetSiteInfo;
    property OnGetStorage;
    property OnGroupClick;
    property OnGroupCollapse;
    property OnGroupCollapsing;
    property OnGroupCompare;
    property OnGroupContextMenu;
    property OnGroupCustomView;
    property OnGroupDblClick;
    property OnGroupExpand;
    property OnGroupExpanding;
    property OnGroupFreeing;
    property OnGroupImageDraw;
    property OnGroupImageGetSize;
    property OnGroupImageDrawIsCustom;
    property OnGroupLoadFromStream;
    property OnGroupInitialize;
    property OnGroupPaintText;
    property OnGroupSaveToStream;
 //   property OnGroupHotTrack;
    property OnGroupVisibilityChanged;
    property OnGroupVisibilityChanging;
    property OnHeaderDblClick;
    property OnHeaderMouseDown;
    property OnHeaderMouseMove;
    property OnHeaderMouseUp;
    property OnHintCustomInfo;
    property OnHintCustomDraw;
    property OnHintPauseTime;
    property OnHintPopup;
    property OnIncrementalSearch;
    property OnItemCheckChange;
    property OnItemCheckChanging;
    property OnItemClick;
    property OnItemCompare;
    property OnItemContextMenu;
    property OnItemCreateEditor;
    property OnItemCustomView;
    property OnItemDblClick;
    property OnItemEditBegin;
    property OnItemEdited;
    property OnItemEditEnd;
    property OnItemEnableChange;
    property OnItemEnableChanging;
    property OnItemFreeing;
    property OnItemFocusChanged;
    property OnItemFocusChanging;
    property OnItemGetCaption;
    property OnItemGetEditCaption;
    property OnItemGetImageIndex;
    property OnItemGetImageList;
    property OnItemGetTileDetail;
    property OnItemGetTileDetailCount;
    property OnItemImageDraw;
    property OnItemImageGetSize;
    property OnItemImageDrawIsCustom;
    property OnItemInitialize;
    property OnItemLoadFromStream;
    property OnItemMouseDown;
    property OnItemPaintText;
    property OnItemSaveToStream;
    property OnItemSelectionChanged;
    property OnItemSelectionChanging;
    property OnItemStructureChange;
    property OnItemThumbnailDraw;
    property OnItemSelectionsChanged;
    property OnItemVisibilityChanged;
    property OnItemVisibilityChanging;
    property OnKeyAction;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnOLEDragEnd;
    property OnOLEDragStart;
    property OnOLEDragEnter;
    property OnOLEDragOver;
    property OnOLEDragLeave;
    property OnOLEDragDrop;
    property OnOLEGetData;
    property OnOLEGetDataObject;
    property OnOLEQueryContineDrag;
    property OnOLEGiveFeedback;
    property OnOLEQueryData;
    property OnPaintHeaderBkGnd;
    property OnQuickFilterCustomCompare;
    property OnQuickFilterEnd;
    property OnQuickFilterStart;
    property OnRebuildingShellHeader;
    property OnRebuiltShellHeader;
    property OnResize;
    property OnScroll;
    property OnShellExecute;
    property OnShellNotify;
    property OnSortBegin;
    property OnSortEnd;
    property OnStartDock;
    property OnStartDrag;
    property OnThumbRequestCreate;
    property OnUnDock;
    property OnViewChange;
  end;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualDropStack = class(TCustomVirtualDropStack)
    private
  public
    property AllowHiddenCheckedItems;
    property GlobalImages;
    property Items;
    property States;
    property Scrollbars;
  published
    property Align;
    property Anchors;
    property AutoRemove;
    property BackGround;
    property BevelKind;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property CellSizes;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragKind;
    property DragManager;
    property Font;
    property HintItemCount;
    property HotTrack;
    property IncrementalSearch;
    property PaintInfoItem;
    property ParentBiDiMode;
    property ParentBackground;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Selection;
    property ShowHint;
    property ShowInactive;
    property ShowThemedBorder;
    property Sort;
    property StackDepth;
    property TabOrder;
    property TabStop;
    property Themed;
    property View;
    property Visible;
    property WheelMouseDefaultScroll;
    property WheelMouseScrollModifierEnabled;

    property OnAfterPaint;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnContextMenu;
    property OnDblClick;
    property OnDragDrop;
    property OnDockDrop;
    property OnDockOver;
    property OnEndDock;
    property OnEndUpdate;
    property OnEnter;
    property OnExit;
    property OnGetDragImage;
    property OnGetSiteInfo;
    property OnHintCustomInfo;
    property OnHintCustomDraw;
    property OnHintPauseTime;
    property OnHintPopup;
    property OnIncrementalSearch;
    property OnItemCheckChange;
    property OnItemCheckChanging;
    property OnItemClick;
    property OnItemCompare;
    property OnItemContextMenu;
    property OnItemCustomView;
    property OnItemDblClick;
    property OnItemEnableChange;
    property OnItemEnableChanging;
    property OnItemFreeing;
    property OnItemFocusChanged;
    property OnItemFocusChanging;
    property OnItemGetCaption;
    property OnItemGetEditCaption;
    property OnItemGetImageIndex;
    property OnItemGetImageList;
    property OnItemGetTileDetail;
    property OnItemGetTileDetailCount;
    property OnItemImageDraw;
    property OnItemImageGetSize;
    property OnItemImageDrawIsCustom;
    property OnItemInitialize;
    property OnItemLoadFromStream;
    property OnItemMouseDown;
    property OnItemPaintText;
    property OnItemSaveToStream;
    property OnItemSelectionChanged;
    property OnItemSelectionChanging;
    property OnItemThumbnailDraw;
    property OnItemSelectionsChanged;
    property OnItemVisibilityChanged;
    property OnItemVisibilityChanging;
    property OnKeyAction;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnScroll;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
    property OnViewChange;
  end;

  TVirtualExplorerEasyListviewHintWindow = class(TEasyHintWindow)
  private
    FThumbBits: TBitmap;
    FThumbRect: TRect;
  protected
    procedure Paint; override;
    property ThumbBits: TBitmap read FThumbBits write FThumbBits;
  public
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override;
    property ThumbRect: TRect read FThumbRect write FThumbRect;
  end;

  // Needs to be here for BCB
  TVirtualExplorerEasyListviewArray = array of TVirtualExplorerEasyListview;

var
  UnknownFolderIconIndex: Integer = -1;
  UnknownFileIconIndex: Integer = -1;

procedure AddThumbRequest(Window: TWinControl; Item: TExplorerItem; ThumbSize: TPoint; UseExifThumbnail, UseExifOrientation, UseShellExtraction, UseSubsampling, IsResizing: Boolean; ThumbRequestClassCallback: TThumbThreadCreateProc);
procedure LoadDefaultGroupingModifiedArray(var GroupingModifiedArray: TGroupingModifiedArray; CaptionsOnly: Boolean);
procedure LoadDefaultGroupingFileSizeArray(var GroupingFileSizeArray: TGroupingFileSizeArray; CaptionsOnly: Boolean);
function ListBinarySearch(Target: PItemIDList; List: TEasyItemArray; const ParentFolder: IShellFolder; Min, Max: Longint) : Longint;
procedure ItemNamespaceQuickSort(ItemArray: TEasyItemArray; const ParentFolder: IShellFolder; L, R: Integer);
procedure SaveHeaderState(Listview: TCustomVirtualExplorerEasyListview; var HeaderState: TVirtualExplorerEasyListviewHeaderState); overload;
procedure SaveHeaderState(Listview: TCustomVirtualExplorerEasyListview; HeaderState: PVirtualExplorerEasyListviewHeaderState); overload;
procedure SaveHeaderStateToStream(TargetStream: TStream; HeaderState: TVirtualExplorerEasyListviewHeaderState);
procedure LoadHeaderState(Listview: TCustomVirtualExplorerEasyListview; HeaderState: TVirtualExplorerEasyListviewHeaderState);
procedure LoadHeaderStateFromStream(SourceStream: TStream; var HeaderState: TVirtualExplorerEasyListviewHeaderState);
procedure HeaderStateSort(PositionType: PositionSortType; HeaderState: TVirtualExplorerEasyListviewHeaderState);
function HeaderStateValidate(HeaderState: TVirtualExplorerEasyListviewHeaderState): Boolean;
function HeaderStateCount(HeaderState: TVirtualExplorerEasyListviewHeaderState): Integer;
procedure SaveListviewToDefaultColumnWidths(Listview: TCustomVirtualExplorerEasyListview);
procedure SaveListviewToColumnArray(Listview: TCustomVirtualExplorerEasyListview; var ColumnWidths: TColumnWidthArray);
procedure LoadListviewWidthDefaultColumnWidths(Listview: TCustomVirtualExplorerEasyListview);
procedure LoadListviewWithColumnArray(Listview: TCustomVirtualExplorerEasyListview; ColumnWidths: TColumnWidthArray);

implementation

uses
  TypInfo, Dialogs, AnsiStrings;

type
  TEasySelectionManagerHack = class(TEasySelectionManager);
  TNamespaceHack = class(TNamespace);
  TEasyColumnsHack = class(TEasyColumns);
  TWinControlCracker = class(TWinControl);
  TEasyItemHack = class(TEasyItem);
  TEasyCellSizeHack = class(TEasyCellSize);
  TEasyCollectionHack = class(TEasyCollection);

procedure SaveListviewToDefaultColumnWidths(Listview: TCustomVirtualExplorerEasyListview);
begin
  SaveListviewToColumnArray(Listview, VET_ColumnWidths)
end;

procedure SaveListviewToColumnArray(Listview: TCustomVirtualExplorerEasyListview; var ColumnWidths: TColumnWidthArray);
var
  i: Integer;
begin
  if Assigned(Listview) then
  begin
    i := 0;
    while (i < Listview.Header.Columns.Count) and (i < Length(VET_ColumnWidths)) do
    begin
      ColumnWidths[i] := Listview.Header.Columns[i].Width;
      Inc(i)
    end
  end
end;

procedure LoadListviewWidthDefaultColumnWidths(Listview: TCustomVirtualExplorerEasyListview);
begin
  LoadListviewWithColumnArray(Listview, VET_DEFAULT_COLUMNWIDTHS)
end;

procedure LoadListviewWithColumnArray(Listview: TCustomVirtualExplorerEasyListview; ColumnWidths: TColumnWidthArray);
var
  i: Integer;
begin
  if Assigned(Listview) then
  begin
    i := 0;
    while (i < Listview.Header.Columns.Count) and (i < Length(VET_ColumnWidths)) do
    begin
      Listview.Header.Columns[i].Width := ColumnWidths[i];
      Inc(i)
    end
  end
end;

function HeaderStateCount(HeaderState: TVirtualExplorerEasyListviewHeaderState): Integer;
begin
  Result := -1;
  if HeaderStateValidate(HeaderState) then
    Result := Length(HeaderState.Visible)
end;

function HeaderStateValidate(HeaderState: TVirtualExplorerEasyListviewHeaderState): Boolean;
begin
  Result := (Length(HeaderState.Visible) = Length(HeaderState.Width)) and
            (Length(HeaderState.Width) = Length(HeaderState.Position)) and
            (Length(HeaderState.Position) = Length(HeaderState.SortDirection))
end;

procedure PositionQuickSort(PositionType: PositionSortType; HeaderState: TVirtualExplorerEasyListviewHeaderState; L, R: Integer);
///
///
var
  I, J: Integer;
  Middle: Integer;
  TempVisible: Boolean;
  TempWidth: Integer;
  TempPosition: TColumnPositionIndex;
  TempSortDirection: TEasySortDirection;
begin
  if L < R then
  repeat
    I := L;
    J := R;
    Middle := (L + R) shr 1;
    repeat
      if PositionType = pstPosition then
      begin
        while HeaderState.Position[I].Position < HeaderState.Position[Middle].Position do
          Inc(I);
        while HeaderState.Position[J].Position > HeaderState.Position[Middle].Position do
          Dec(J);
      end else
      if PositionType = pstIndex then
      begin
        while HeaderState.Position[I].Index < HeaderState.Position[Middle].Index do
          Inc(I);
        while HeaderState.Position[J].Index > HeaderState.Position[Middle].Index do
          Dec(J);
      end else
        Exit;
      if I <= J then
      begin
        TempVisible := HeaderState.Visible[I];
        TempWidth := HeaderState.Width[I];
        TempPosition := HeaderState.Position[I];
        TempSortDirection := HeaderState.SortDirection[I];

        HeaderState.Visible[I] := HeaderState.Visible[J];
        HeaderState.Width[I] := HeaderState.Width[J];
        HeaderState.Position[I] := HeaderState.Position[J];
        HeaderState.SortDirection[I] := HeaderState.SortDirection[J];

        HeaderState.Visible[J] := TempVisible;
        HeaderState.Width[J] := TempWidth;
        HeaderState.Position[J] := TempPosition;
        HeaderState.SortDirection[J] := TempSortDirection;

        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      PositionQuickSort(PositionType, HeaderState, L, J);
    L := I;
  until I >= R;
end;

procedure HeaderStateSort(PositionType: PositionSortType; HeaderState: TVirtualExplorerEasyListviewHeaderState);
begin
  if HeaderStateValidate(HeaderState) then
    PositionQuickSort(PositionType, HeaderState, 0, Length(HeaderState.Visible) - 1)
end;

procedure SaveHeaderState(Listview: TCustomVirtualExplorerEasyListview; HeaderState: PVirtualExplorerEasyListviewHeaderState);
begin
  SaveHeaderState(Listview, HeaderState^);
end;

procedure SaveHeaderState(Listview: TCustomVirtualExplorerEasyListview; var HeaderState: TVirtualExplorerEasyListviewHeaderState);
var
  i: Integer;
begin
  SetLength(HeaderState.Visible, Listview.Header.Columns.Count);
  SetLength(HeaderState.Width, Listview.Header.Columns.Count);
  SetLength(HeaderState.SortDirection, Listview.Header.Columns.Count);
  SetLength(HeaderState.Position, Listview.Header.Columns.Count);
  for i := 0 to Listview.Header.Columns.Count - 1 do
  begin
    HeaderState.Visible[i] := Listview.Header.Columns[i].Visible;
    HeaderState.Width[i] := Listview.Header.Columns[i].Width;
    HeaderState.SortDirection[i] := Listview.Header.Columns[i].SortDirection;
    HeaderState.Position[i].Index := Listview.Header.Columns[i].Index;
    HeaderState.Position[i].Position := Listview.Header.Columns[i].Position;
  end
end;

procedure SaveHeaderStateToStream(TargetStream: TStream; HeaderState: TVirtualExplorerEasyListviewHeaderState);
var
  Count: Integer;
begin
  if HeaderStateValidate(HeaderState) then
  begin
    HeaderStateSort(pstIndex, HeaderState);
    Count := HeaderStateCount(HeaderState);
    TargetStream.Write(Count, SizeOf(Count));
    TargetStream.Write(HeaderState.Visible[0], Count * SizeOf(HeaderState.Visible[0]));
    TargetStream.Write(HeaderState.Width[0], Count * SizeOf(HeaderState.Width[0]));
    TargetStream.Write(HeaderState.SortDirection[0], Count * SizeOf(HeaderState.SortDirection[0]));
    TargetStream.Write(HeaderState.Position[0], Count * SizeOf(HeaderState.Position[0]));
  end
end;

procedure LoadHeaderState(Listview: TCustomVirtualExplorerEasyListview; HeaderState: TVirtualExplorerEasyListviewHeaderState);
var
  i: Integer;
begin
  Listview.BeginUpdate;
  try
    if HeaderStateCount(HeaderState) = Listview.Header.Columns.Count then
    begin
      Listview.Sort.LockoutSort := True;
      HeaderStateSort(pstIndex, HeaderState);
      for i := 0 to Listview.Header.Columns.Count - 1 do
      begin
        Listview.Header.Columns[i].Visible := HeaderState.Visible[i];
        Listview.Header.Columns[i].Width := HeaderState.Width[i];
        Listview.Header.Columns[i].SortDirection := HeaderState.SortDirection[i];
        Listview.Header.Columns[i].Position := HeaderState.Position[i].Position;
      end
    end
  finally
    Listview.Sort.LockoutSort := False;
    Listview.Sort.SortAll;
    Listview.EndUpdate;
  end
end;

procedure LoadHeaderStateFromStream(SourceStream: TStream; var HeaderState: TVirtualExplorerEasyListviewHeaderState);
var
  Count: Integer;
begin
  SourceStream.Read(Count, SizeOf(Integer));
  SetLength(HeaderState.Visible, Count);
  SetLength(HeaderState.Width, Count);
  SetLength(HeaderState.SortDirection, Count);
  SetLength(HeaderState.Position, Count);
  SourceStream.Read(HeaderState.Visible[0], Count * SizeOf(HeaderState.Visible[0]));
  SourceStream.Read(HeaderState.Width[0], Count * SizeOf(HeaderState.Width[0]));
  SourceStream.Read(HeaderState.SortDirection[0], Count * SizeOf(HeaderState.SortDirection[0]));
  SourceStream.Read(HeaderState.Position[0], Count * SizeOf(HeaderState.Position[0]));
end;

function ListBinarySearch(Target: PItemIDList; List: TEasyItemArray; const ParentFolder: IShellFolder; Min, Max: Longint) : Longint;
//
// List must be sorted first
//
var
  Middle : LongInt;
  CompareResult: ShortInt;
begin
  // During the search the target's index will be between
  // min and max: min <= target index <= max
  while (Min <= Max) do
  begin
    Middle := (Min + Max) shr 1;
    CompareResult := ShortInt(ParentFolder.CompareIDs(0, TExplorerItem( List[Middle]).Namespace.RelativePIDL, Target));
    if CompareResult = 0 then
    begin
      Result := Middle;
      exit;
    end else
    begin
      if CompareResult > 0 then
        // Search the left half.
        Max := Middle - 1
      else
        // Search the right half.
        Min := Middle + 1;
    end
  end;

  // If we get here the target is not in the list.
  Result := -1;
end;

procedure LoadDefaultGroupingModifiedArray(var GroupingModifiedArray: TGroupingModifiedArray; CaptionsOnly: Boolean);
var
  i: Integer;
begin
  GROUPINGFILESIZE[0] := STR_GROUPSIZEZERO;
  GROUPINGFILESIZE[1] :=  STR_GROUPSIZETINY;
  GROUPINGFILESIZE[2] := STR_GROUPSIZESMALL;
  GROUPINGFILESIZE[3] := STR_GROUPSIZEMEDIUM;
  GROUPINGFILESIZE[4] := STR_GROUPSIZELARGE;
  GROUPINGFILESIZE[5] := STR_GROUPSIZEGIGANTIC;
  GROUPINGFILESIZE[6] := STR_GROUPSIZESYSFOLDER;
  GROUPINGFILESIZE[7] := STR_GROUPSIZEFOLDER;

  GROUPINGMODIFIEDDATE[0] := STR_GROUPMODIFIEDHOUR;
  GROUPINGMODIFIEDDATE[1] := STR_GROUPMODIFIEDTODAY;
  GROUPINGMODIFIEDDATE[2] := STR_GROUPMODIFIEDTHISWEEK;
  GROUPINGMODIFIEDDATE[3] := STR_GROUPMODIFIEDTWOWEEKS;
  GROUPINGMODIFIEDDATE[4] := STR_GROUPMODIFIEDTHREEWEEKS;
  GROUPINGMODIFIEDDATE[5] := STR_GROUPMODIFIEDMONTH;
  GROUPINGMODIFIEDDATE[6] := STR_GROUPMODIFIEDTWOMONTHS;
  GROUPINGMODIFIEDDATE[7] := STR_GROUPMODIFIEDTHREEMONTHS;
  GROUPINGMODIFIEDDATE[8] := STR_GROUPMODIFIEDFOURMONTHS;
  GROUPINGMODIFIEDDATE[9] := STR_GROUPMODIFIEDFIVEMONTHS;
  GROUPINGMODIFIEDDATE[10] := STR_GROUPMODIFIEDSIXMONTHS;
  GROUPINGMODIFIEDDATE[11] := STR_GROUPMODIFIEDEARLIERTHISYEAR;
  GROUPINGMODIFIEDDATE[12] := STR_GROUPMODIFIEDLONGTIMEAGO;

  SetLength(GroupingModifiedArray, High(GROUPINGMODIFIEDDATE) + 1);
  for i := 0 to Length(GroupingModifiedArray) - 1 do
  begin
    GroupingModifiedArray[i].Caption := GROUPINGMODIFIEDDATE[i];
    if not CaptionsOnly then
    begin
      GroupingModifiedArray[i].Days := GROUPINGMODIFIEDDATEDELTA[i];
      GroupingModifiedArray[i].Enabled := True;
    end
  end
end;

procedure LoadDefaultGroupingFileSizeArray(var GroupingFileSizeArray: TGroupingFileSizeArray; CaptionsOnly: Boolean);
var
  i: Integer;
begin
  SetLength(GroupingFileSizeArray, High(GROUPINGFILESIZE) + 1);
  for i := 0 to Length(GroupingFileSizeArray) - 1 do
  begin
    GroupingFileSizeArray[i].Caption := GROUPINGFILESIZE[i];
    if not CaptionsOnly then
    begin
      GroupingFileSizeArray[i].FileSize := GROUPINGFILESIZEDELTA[i];
      GroupingFileSizeArray[i].Enabled := True;
      GroupingFileSizeArray[i].SpecialFolder := i >= SPECIALFOLDERSTART;
    end
  end
end;

procedure AddThumbRequest(Window: TWinControl; Item: TExplorerItem;
  ThumbSize: TPoint; UseExifThumbnail, UseExifOrientation, UseShellExtraction,
  UseSubsampling, IsResizing: Boolean; ThumbRequestClassCallback: TThumbThreadCreateProc);
// Send a thumb request to the GlobalThreadManager
var
  ThumbRequest: TEasyThumbnailThreadRequest;
begin
  if Assigned(Item) and Assigned(Item.Namespace) then
  begin
    ThumbRequest := nil;
    if Assigned(ThumbRequestClassCallback) then
      ThumbRequestClassCallback(ThumbRequest);
    if not Assigned(ThumbRequest) then
      ThumbRequest := TEasyThumbnailThreadRequest.Create;
    ThumbRequest.Window := Window;
    ThumbRequest.Item := Item;
    ThumbRequest.ID := TID_THUMBNAIL;
    ThumbRequest.Priority := 50;
    ThumbRequest.BackgroundColor := TWinControlCracker(Window).Color;
    ThumbRequest.ThumbSize := ThumbSize;
    ThumbRequest.UseExifThumbnail := UseExifThumbnail;
    ThumbRequest.UseExifOrientation := UseExifOrientation;
    ThumbRequest.UseShellExtraction := UseShellExtraction;
    ThumbRequest.UseSubsampling := UseSubsampling;
    ThumbRequest.PIDL := PIDLMgr.CopyPIDL(Item.Namespace.AbsolutePIDL);
    if IsResizing then
      Item.Namespace.States := Item.Namespace.States + [nsThreadedImageResizing]
    else
      Item.Namespace.States := Item.Namespace.States + [nsThreadedImageLoading];
    GlobalThreadManager.AddRequest(ThumbRequest, True);
  end;
end;

function ShellCollectionSort(Column: TEasyColumn; Item1, Item2: TEasyItem): Integer;
var
  Index: Integer;
begin
  if not Assigned(Column) then
    Index := 0
  else
    Index := Column.Position;

  Result := TExplorerItem(Item2).Namespace.ComparePIDL(TExplorerItem(Item1).Namespace.AbsolutePIDL, True, Index);

  if Assigned(Column) and (Column.SortDirection = esdDescending) then
    Result := -Result
end;

procedure ItemNamespaceQuickSort(ItemArray: TEasyItemArray; const ParentFolder: IShellFolder; L, R: Integer);
///
/// NOTE:  Make sure any changes to this method are reflected in both VirtualExplorerTree.pas
//         and VirtualExplorerListview.pas
///
var
  I, J: Integer;
  P, T: TEasyItem;
begin
  if L < R then
  repeat
    I := L;
    J := R;
    P := ItemArray[(L + R) shr 1];
    repeat
      while ShortInt(ParentFolder.CompareIDs(0,
        TExplorerItem( ItemArray[I]).Namespace.RelativePIDL, TExplorerItem( P).Namespace.RelativePIDL))< 0 do
        Inc(I);
      while ShortInt(ParentFolder.CompareIDs(0,
        TExplorerItem( ItemArray[J]).Namespace.RelativePIDL, TExplorerItem( P).Namespace.RelativePIDL)) > 0 do
        Dec(J);
      if I <= J then
      begin
        T := ItemArray[I];
        ItemArray[I] := ItemArray[J];
        ItemArray[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      ItemNamespaceQuickSort(ItemArray, ParentFolder, L, J);
    L := I;
  until I >= R;
end;

{ TVirtualEasyListview }

constructor TCustomVirtualExplorerEasyListview.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Active := False;
  FOrphanThreadList := TList.Create;
  InitializeCriticalSection(FEnumLock);
  AutoSort := True;
  FUseShellGrouping := True;
  FCompressedFile := TVirtualCustomFileTypes.Create(ExplorerTextColor(vetcCompressed));
  FEncryptedFile :=  TVirtualCustomFileTypes.Create(ExplorerTextColor(vetcEncrypted));
  FThumbsManager := TEasyThumbsManager.Create(Self);
  FELVPersistent := TELVPersistent.Create;
  FCategoryInfo := TCategories.Create;
  Selection := TEasyVirtualSelectionManager.Create(Self);
  FColumnHeaderMenu := TVirtualPopupMenu.Create(Self);
  FSelectedFiles := TStringList.Create;
  FSelectedPaths := TStringList.Create;
  FExtensionColorCodeList := TExtensionColorCodeList.Create;
  InitializeCriticalSection(FLock);
  RootFolder := rfDesktop;
  FFileObjects := [foFolders, foNonFolders];
  FOptions := [eloBrowseExecuteFolder, eloBrowseExecuteFolderShortcut, eloBrowseExecuteZipFolder, eloExecuteOnDblClick, eloThreadedImages, eloThreadedDetails];
  ImagesSmall := SmallSysImages;
  ImagesLarge := LargeSysImages;
  ImagesExLarge := ExtraLargeSysImages;
  Groups.HideFromDFM := True;
  Header.Columns.HideFromDFM := True;
  SHGetMalloc(FMalloc);
  GlobalThreadManager.RegisterControl(Self);    
  FColumnMenuItemCount := 5;
  Header.StreamColumns := False;
  Groups.StreamGroups := False;
  LoadDefaultGroupingModifiedArray(FGroupingModifiedArray, False);
  LoadDefaultGroupingFileSizeArray(FGroupingFileSizeArray, False);
  FStorage := TRootNodeStorage.Create; // Keep this late in the order
  Storage.Stored := True;
  TEasyColumnsHack( Header.Columns).FItemClass := TExplorerColumn;
  HintAlignment := taLeftJustify;
  FQueryInfoHintTimeout := 2500;
  ExtensionColorCodeSelected := True;
  ExtensionColorCode := False;
  {$IFDEF USE_TOOLBAR_TB2K}
  MenuClass := TTBPopupMenu;
  ItemClass := TTBItem;
  {$ENDIF}
end;

destructor TCustomVirtualExplorerEasyListview.Destroy;
var
  SafetyNet: Integer;
begin
  TerminateDetailsOfThread;
  TerminateEnumThread;
  if Assigned(VETChangeDispatch) then
    VETChangeDispatch.UnRegisterChangeLink(Self, Self, utAll);
  StoreFolderToPropertyBag(False);
{$IFDEF EXPLORERCOMBOBOX_L}
  ExplorerComboBox := nil;
{$ENDIF}
{$IFDEF EXPLORERTREEVIEW_L}
  ExplorerTreeview := nil;
{$ENDIF}
  if ChangeNotifierEnabled then
    ChangeNotifier.UnRegisterChangeNotify(Self);
  GlobalThreadManager.FlushAllMessageCache(Self);
  GlobalThreadManager.UnRegisterControl(Self);
  if ThumbsManager.AutoSave then
    ThumbsManager.SaveAlbum;
  SafetyNet := 0;
  while (OrphanThreadList.Count > 0) and (SafetyNet < 100) do
  begin
    OrphanThreadsFree;
    Sleep(100);
    Inc(SafetyNet)
  end;
  inherited Destroy;
  FreeAndNil(FOrphanThreadList);
  FreeAndNil(FSelectedPaths);
  FreeAndNil(FSelectedFiles);
  FreeAndNil(FThumbsManager);
  FreeAndNil(FCategoryInfo);
  FreeAndNil(FStorage);
  FreeAndNil(FRootFolderNamespace);
  FreeAndNil(FELVPersistent);
  FreeAndNil(FPrevFolderSettings);
  FreeAndNil(FCompressedFile);
  FreeAndNil(FEncryptedFile);
  FreeAndNil(FBackBrowseRoot);
  FreeAndNil(FExtensionColorCodeList);
  DeleteCriticalSection(FLock);
  DeleteCriticalSection(FEnumLock);
  PIDLMgr.FreeAndNilPIDL(FOldTopNode);
end;

function TCustomVirtualExplorerEasyListview.AddColumnProc: TExplorerColumn;
begin
  Result := Header.Columns.AddCustom(TExplorerColumn, nil) as TExplorerColumn;
  if Assigned(Result) then
    Result.IsCustom := True
end;

function TCustomVirtualExplorerEasyListview.CreateNewFolder(TargetPath: WideString): Boolean;
{ Creates a new folder.  Note you do NOT pass the name of the new folder, only pass the }
{ the path up to where the new folder is to be created.  VET will then create the new   }
{ folder like Explorer does, in the "New Folder (X)" fashion (this constant is redefinable }
{ in the MPResources.pas file).  The folder will be created and immediatly selected so    }
{ the user may edit it.                                                                    }
var
  PIDL: PItemIDList;
begin
  PIDL := PathToPIDL(TargetPath);
  Result := CreateNewFolderInternal(PIDL, '') <> '';
  PIDLMgr.FreePIDL(PIDL);
end;

function TCustomVirtualExplorerEasyListview.CreateNewFolder(TargetPath: WideString; var NewFolder: WideString): Boolean;
var
  PIDL: PItemIDList;
begin
  Result := False;
  PIDL := PathToPIDL(TargetPath);
  if Assigned(PIDL) then
  begin
    NewFolder := CreateNewFolderInternal(PIDL, '');
     PIDLMgr.FreePIDL(PIDL);
    Result := NewFolder <> ''
  end
end;

function TCustomVirtualExplorerEasyListview.CreateNewFolder(TargetPath, SuggestedFolderName: WideString; var NewFolder: WideString): Boolean;
var
  PIDL: PItemIDList;
begin
  Result := False;
  PIDL := PathToPIDL(TargetPath);
  if Assigned(PIDL) then
  begin
    NewFolder := CreateNewFolderInternal(PIDL, SuggestedFolderName);
    PIDLMgr.FreePIDL(PIDL);
    Result := NewFolder <> ''
  end
end;

function TCustomVirtualExplorerEasyListview.CreateNewFolderInternal(TargetPIDL: PItemIDList; SuggestedFolderName: WideString): WideString;

   function FindChildByName(Parent: TNamespace; ChildName: WideString): PItemIDList;
   // Searches the Parent for the Child Name, returns AbsolutePIDL to the Child if found
   var
     EnumIDList:  IEnumIDList;
     Found: Boolean;
     PIDL: PItemIdList;
     Fetched: LongWord;
     ChildNS: TNamespace;
     EnumFlags: Cardinal;
     OldWow64: Pointer;
   begin
     Result := nil;
     EnumFlags := FileObjectsToFlags(FileObjects);
     if Parent.Folder then
     begin
       OldWow64 := Wow64RedirectDisable;
       try
         Found := False;
         Parent.ShellFolder.EnumObjects(0, EnumFlags, EnumIDList);
         while not Found and (EnumIDList.Next(1, PIDL, Fetched) = NOERROR) do
         begin
           ChildNS := TNamespace.Create(PIDLMgr.AppendPIDL(Parent.AbsolutePIDL, PIDL), nil);
           if ChildName = ChildNS.NameForParsing then
           begin
             Result := PIDLMgr.CopyPIDL(ChildNS.AbsolutePIDL);
             Found := True;
           end;
           ChildNS.Free;
           PIDLMgr.FreePIDL(PIDL);
         end;
       finally
         Wow64RedirectRevert(OldWow64)
       end
     end
   end;

const
  SAFETYVALVE = 200;

var
  NewItem: TExplorerItem;
  NewName: WideString;
  TargetPath: WideString;
  NS, ParentNS: TNamespace;
  NewChildPIDL: PItemIDList;
  i: Integer;
begin
  Assert(EditManager.Enabled, 'You must set the toEditable option to Edit paths');
  Result := '';
  if Assigned(TargetPIDL) then
  begin
    TargetPath := PIDLToPath(TargetPIDL);
    TargetPath := WideStripTrailingBackslash(TargetPath);

    if WideDirectoryExists(TargetPath) then
    begin
      // Generate a Unique Name
      NewName := WideNewFolderName(TargetPath, SuggestedFolderName);

      if WideCreateDir(NewName) then
      begin
        ParentNS := TNamespace.Create(TargetPIDL, nil);
        ParentNS.FreePIDLOnDestroy := False; // We don't own the PIDL

        // May need to spend some time waiting for windows to create the file,
        // especially in Win9x
        NewChildPIDL := nil;
        i := 0;
        while not Assigned(NewChildPIDL) and (i < SAFETYVALVE) do
        begin
          NewChildPIDL := FindChildByName(ParentNS, NewName);
          Inc(i);
          Sleep(10)
        end;

        if Assigned(NewChildPIDL) then
        begin
          Selection.ClearAll;
          Selection.FocusedItem := nil;
          // The namespace is given to the node, don't free it
          NS := TNamespace.Create(NewChildPIDL, nil);
          NewItem := AddCustomItem(nil, NS, True);
          if Assigned(NewItem) then
          begin
            Selection.FocusedItem := NewItem;
            NewItem.Selected := True;
            NewItem.Edit();
            Result := NewItem.Namespace.NameForEditing
          end else
            NS.Free
        end;
        FreeAndNil(ParentNS);
      end
    end
  end
end;

function TCustomVirtualExplorerEasyListview.CustomEasyHintWindowClass: THintWindowClass;
begin
  Result := TVirtualExplorerEasyListviewHintWindow;
end;

function TCustomVirtualExplorerEasyListview.DoContextMenuCmd(Namespace: TNamespace; Verb: WideString; MenuItemID: Integer): Boolean;
begin
  Result := False;
  if Assigned(OnContextMenuCmd) then
    OnContextMenuCmd(Self, Namespace, Verb, MenuItemID, Result);
      { Rename is a special case and MUST be handled by the application.            }
  if (Verb = 'rename') and not Result then
  begin
    Result := True;
    EditManager.BeginEdit(Selection.First, nil);
  end;
end;

function TCustomVirtualExplorerEasyListview.DoContextMenuShow(Namespace: TNamespace; Menu: hMenu): Boolean;
begin
  Result := True;
  if Assigned(OnContextMenuShow) then
    OnContextMenuShow(Self, Namespace, Menu, Result)
end;

function TCustomVirtualExplorerEasyListview.DoGroupCompare(Column: TEasyColumn;
  Group1, Group2: TEasyGroup): Integer;
begin
  if Assigned(OnGroupCompare) then
    Result := inherited DoGroupCompare(Column, Group1, Group2)
  else begin
    case GroupingColumn of
      1,3,4,5: Result := TExplorerGroup(Group1).GroupKey - TExplorerGroup(Group2).GroupKey
    else
      Result := inherited DoGroupCompare(Column, Group1, Group2)
    end
  end
end;

function TCustomVirtualExplorerEasyListview.DoItemCompare(Column: TEasyColumn;
  Group: TEasyGroup; Item1: TEasyItem; Item2: TEasyItem): Integer;
var
  ColumnIndex: Integer;
  DoDefault, IsFolder1, IsFolder2: Boolean;
  NS1, NS2: TNamespace;
begin
  ColumnIndex := 0;
  if Assigned(Column) and TExplorerColumn(Column).IsCustom then
    DoCustomColumnCompare(TExplorerColumn( Column), Group, TExplorerItem( Item1), TExplorerItem( Item2), Result)
  else begin
    DoDefault := True;
    if Assigned(OnItemCompare) then
      Result := OnItemCompare(Self, Column, Group, Item1, Item2, DoDefault);

    if DoDefault then
    begin
      if Assigned(Column) then
        ColumnIndex := Column.Index;

      NS1 := TExplorerItem(Item1).Namespace;
      NS2 := TExplorerItem(Item2).Namespace;
      if SortFolderFirstAlways then
      begin
        IsFolder1 := NS1.Folder and not TExplorerItem(Item1).Namespace.Browsable;
        IsFolder2 := NS2.Folder and not TExplorerItem(Item2).Namespace.Browsable;

        if IsFolder1 xor IsFolder2 then
        begin
          if IsFolder1 then
            Result := -1
          else
            Result := 1;
        end else
        begin
          if IsFolder1 and IsFolder2 then
            Result := NS2.ComparePIDL(NS1.RelativePIDL, False, ColumnIndex)
          else begin
            if (ColumnIndex = 2) and IsWinVista then
              Result := CompareText(WideString(NS1.DetailsOf(2)), WideString( NS2.DetailsOf(2)))
            else
              Result := NS2.ComparePIDL(NS1.RelativePIDL, False, ColumnIndex);
          end;
          // Secondary level of sorting is on the Name
          if (Result = 0) and (ColumnIndex > 0) then
             Result := NS2.ComparePIDL(NS1.RelativePIDL, False, 0);

          if (ColumnIndex > -1) and (Column.SortDirection = esdDescending) then
            Result := -Result
        end
      end else
      begin
        Result := NS2.ComparePIDL(NS1.RelativePIDL, False, ColumnIndex);
          
        // Secondary level of sorting is on the Name
        if (Result = 0) and (ColumnIndex > 0) then
           Result := NS2.ComparePIDL(NS1.RelativePIDL, False, 0);

        if (ColumnIndex > -1) and (Column.SortDirection = esdDescending) then
          Result := -Result
      end
    end;
  end;
end;

function TCustomVirtualExplorerEasyListview.ExecuteDragDrop(
  AvailableEffects: TCommonDropEffects; DataObjectInf: IDataObject;
  DropSource: IDropSource; var dwEffect: Integer): HRESULT;
var
  Medium: TStgMedium;
begin
  if (Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion >= 6) and Assigned(SHDoDragDrop_MP) then
  begin
    if Succeeded(DataObjectInf.GetData(HeaderClipFormat, Medium)) then
    begin
      ReleaseStgMedium(Medium);
      Result := inherited ExecuteDragDrop(AvailableEffects, DataObjectInf, DropSource, dwEffect)
    end else
      Result := SHDoDragDrop_MP(Handle, DataObjectInf, nil, DropEffectStatesToDropEffect(AvailableEffects), dwEffect)
  end else
    Result := inherited ExecuteDragDrop(AvailableEffects, DataObjectInf, DropSource, dwEffect)
end;

function TCustomVirtualExplorerEasyListview.FindGroup(NS: TNamespace): TExplorerGroup;
var
  i, iArray: Integer;
  TimeDelta: TDateTime;
  Size: Int64;
  Done: Boolean;
  WS: WideString;
 // ColumnID: TSHCOLUMNID;
 // CanCategorizeArray: array of Boolean;
 // CategoryGUID: TGUID;
 // Categorizer: ICategorizer;
 // Desc: array[0..128] of WideChar;
 // CategoryInfo: tagTCategoryInfo;
 // CategoryIDs: TWordArray;
 // dwCategoryId: DWORD;
begin
  Result := nil;
  DoCustomGroup(Groups, NS, Result);
  if UseShellGrouping then
  begin  (*
    if NS.IsMyComputer or NS.Parent.IsMyComputer then
    begin
      if Assigned(NS.CategoryProviderInterface) then
      begin
        SetLength(CanCategorizeArray, NS.DetailsSupportedColumns);
        for i := 0 to NS.DetailsSupportedColumns - 1 do
        begin
          CanCategorizeArray[i] := Succeeded( NS.ShellFolder2.MapColumnToSCID(i, ColumnID));

          if Succeeded( NS.ShellFolder2.MapColumnToSCID(i {GroupingColumn}, ColumnID)) then
          begin
            if Succeeded( NS.CategoryProviderInterface.GetCategoryForSCID(ColumnID, CategoryGUID)) then
            begin
              if Succeeded( NS.CategoryProviderInterface.CreateCategory(CategoryGUID, ICategorizer, Categorizer)) then
              begin
                Categorizer.GetDescription(Desc, Length(Desc) - 1);
          //      Categorizer.GetCategory(1, NS.AbsolutePIDL, CategoryIDs);
                dwCategoryId := 0;
                Categorizer.GetCategoryInfo(dwCategoryId, CategoryInfo);
                PIDLMgr.FreeOLEStr(Desc);
              end;
            end;
          end;
        end;
        if Succeeded( NS.CategoryProviderInterface.CreateCategory(CLSID_DriveSizeCategorizer, ICategorizer, Categorizer)) then
        begin
            Categorizer.GetDescription(Desc, Length(Desc) - 1);
    //      Categorizer.GetCategory(1, NS.AbsolutePIDL, CategoryIDs);
          dwCategoryId := 0;
          Categorizer.GetCategoryInfo(dwCategoryId, CategoryInfo);
          PIDLMgr.FreeOLEStr(Desc);
        end;
        if Succeeded( NS.CategoryProviderInterface.CreateCategory(CLSID_DriveTypeCategorizer, ICategorizer, Categorizer)) then
        begin
            Categorizer.GetDescription(Desc, Length(Desc) - 1);
    //      Categorizer.GetCategory(1, NS.AbsolutePIDL, CategoryIDs);
          dwCategoryId := 0;
          Categorizer.GetCategoryInfo(dwCategoryId, CategoryInfo);
          PIDLMgr.FreeOLEStr(Desc);
        end;
        if Succeeded( NS.CategoryProviderInterface.CreateCategory(CLSID_FreeSpaceCategorizer, ICategorizer, Categorizer)) then
        begin
            Categorizer.GetDescription(Desc, Length(Desc) - 1);
    //      Categorizer.GetCategory(1, NS.AbsolutePIDL, CategoryIDs);
          dwCategoryId := 0;
          Categorizer.GetCategoryInfo(dwCategoryId, CategoryInfo);
          PIDLMgr.FreeOLEStr(Desc);
        end;
      end
    end   *)
  end;
  if not Assigned(Result) then
  begin
    i := 0;
    while not Assigned(Result) and (i < Groups.Count) do
    begin
      case GroupingColumn of
        0: begin  // Name Grouping
             if (NS.NameInFolder <> '') and ((Groups[i].Caption <> '') and (Groups[i].Caption <> DEFAULT_GROUP_NAME)) then
             begin
               if Groups[i].Caption[1] = Uppercase( NS.NameInFolder[1]) then
                 Result := TExplorerGroup(Groups[i]);
             end else
             if (NS.NameInFolder = '') xor (Groups[i].Caption = '') then
               Result := TExplorerGroup(Groups[i])  // Both are blank so they match!
           end;
        1: begin // Size Grouping
             if NS.FileSystem then
             begin
               if NS.Folder and not NS.Browsable then
               begin
                 WS := GroupingFileSizeArray[Length(GroupingFileSizeArray) - 1].Caption;
                  if WideStrIComp(PWideChar(Groups[i].Caption), PWideChar(WS)) = 0 then
                    Result := TExplorerGroup(Groups[i])
               end else
               begin
                 Size := NS.SizeOfFileInt64;
                 iArray := 0;
                 Done := False;
                 while not Done and not Assigned(Result) and (iArray < Length(GroupingFileSizeArray) - 2) do
                 begin
                   if (Size <= GroupingFileSizeArray[iArray].FileSize) and (GroupingFileSizeArray[iArray].Enabled) then
                   begin
                     WS := GroupingFileSizeArray[iArray].Caption;
                     if WideStrIComp(PWideChar(Groups[i].Caption), PWideChar(WS)) = 0 then
                       Result := TExplorerGroup(Groups[i]);
                     Done := True
                   end;
                   Inc(iArray);
                 end
               end
             end else
             begin
               // Is a System Folder
               WS := GroupingFileSizeArray[Length(GroupingFileSizeArray) - 2].Caption;
               if WideStrIComp(PWideChar(Groups[i].Caption), PWideChar(WS)) = 0 then
                 Result := TExplorerGroup(Groups[i])
             end
           end;
        3,4,5: begin // I am making a leap of faith that this always Mod/Create/Access Dates
             TimeDelta := 0;
             case GroupingColumn of
               3: TimeDelta := Now - NS.LastWriteDateTime;
               4: TimeDelta := Now - NS.CreationDateTime;
               5: TimeDelta := Now - NS.LastAccessDateTime;
             end;

             iArray := 0;
             Done := False;
             while not Done and not Assigned(Result) and (iArray < Length(GroupingModifiedArray)) do
             begin
               if (TimeDelta <= GroupingModifiedArray[iArray].Days) and GroupingModifiedArray[iArray].Enabled then
               begin
                 if WideStrIComp(PWideChar(Groups[i].Caption), PWideChar(GroupingModifiedArray[iArray].Caption)) = 0 then
                   Result := TExplorerGroup(Groups[i]);
                 Done := True
               end;
               Inc(iArray)
             end
           end;
    else
      if WideStrIComp(PWideChar(Groups[i].Caption), PWideChar(NS.DetailsOf(GroupingColumn))) = 0 then
        Result := TExplorerGroup(Groups[i])
    end;
    Inc(i)
  end;
  if not Assigned(Result) then
  begin
    Result := Groups.AddCustom(GroupClass) as TExplorerGroup;
    case GroupingColumn of
      0: begin
           if NS.NameInFolder <> '' then
             Result.Caption := WideUpperCase( NS.NameInFolder[1]);
         end;
      1: begin
           if NS.FileSystem then
           begin
             if NS.Folder and not NS.Browsable then
             begin
               Result.Caption := GroupingFileSizeArray[Length(GroupingFileSizeArray) - 1].Caption;
               TExplorerGroup(Result).GroupKey := 8
             end else
             begin
               Size := NS.SizeOfFileInt64;
               iArray := 0;
               Done := False;
               while not Done and (iArray < Length(GroupingFileSizeArray) - 2) do
               begin
                 if (Size <= GroupingFileSizeArray[iArray].FileSize) and (GroupingFileSizeArray[iArray].Enabled) then
                 begin
                   Result.Caption := GroupingFileSizeArray[iArray].Caption;
                   TExplorerGroup(Result).GroupKey := iArray + 1;
                   Done := True
                 end;
                 Inc(iArray);
               end
             end
           end else
           begin
             Result.Caption := GroupingFileSizeArray[Length(GroupingFileSizeArray) - 2].Caption;
             TExplorerGroup(Result).GroupKey := 7;
           end
         end;
      3, 4, 5: begin  // I am making a leap of faith that this always Mod/Create/Access Dates
           TimeDelta := 0;
           case GroupingColumn of
             3: TimeDelta := Now - NS.LastWriteDateTime;
             4: TimeDelta := Now - NS.CreationDateTime;
             5: TimeDelta := Now - NS.LastAccessDateTime;
           end;
           iArray := 0;
           Done := False;
           while not Done and (iArray < Length(GroupingModifiedArray)) do
           begin
             if (TimeDelta <= GroupingModifiedArray[iArray].Days) and GroupingModifiedArray[iArray].Enabled then
             begin
               Result.Caption := GroupingModifiedArray[iArray].Caption;
               TExplorerGroup(Result).GroupKey := iArray + 1;
               Done := True
             end;
             Inc(iArray)
           end
         end;
      else
        Result.Caption := NS.DetailsOf(GroupingColumn)
      end;
    end
  end
end;

function TCustomVirtualExplorerEasyListview.EnumFolderCallback(ParentWnd: HWnd;
  APIDL: PItemIDList; AParent: TNamespace; Data: pointer;
  var Terminate: Boolean): Boolean;
{ This is what the TNamespace objects callback when they are enumerating a      }
{ folder.                                                                       }
var
  Allow: Boolean;
  NS: TNamespace;
begin
  Result := False;
  NS := TNamespace.Create(APIDL, AParent);
  if ((eloHideRecycleBin in Options) and NS.IsRecycleBin) or
    (NS.Parent.IsDesktop and (not IENamespaceShown and (NS.NameForParsing = IE_NAMEFORPARSING))) then
  begin
    NS.Free;
    Exit
  end;
  Allow := True;
  DoEnumFolder(NS, Allow);
  if Allow then
  begin
    if AddCustomItem(nil, NS, True) = nil then
      NS.Free
  end else
    NS.Free;
end;

function TCustomVirtualExplorerEasyListview.FindInsertPosition(WindowX, WindowY: Integer; var Group: TEasyGroup): Integer;
var
  ViewPt: TPoint;
begin
  ViewPt := Scrollbars.MapWindowToView( Point(WindowX, WindowY));
  if Groups.Count > 0 then
    Groups[0].Grid.FindInsertPosition(ViewPt, Group, Result)
  else
    Result := -1
end;

function TCustomVirtualExplorerEasyListview.GetAnimateWndParent: TWinControl;
begin
  Result := Self
end;

function TCustomVirtualExplorerEasyListview.GetAutoSort: Boolean;
begin
  Result := Sort.AutoSort
end;

function TCustomVirtualExplorerEasyListview.GetDropTargetNS: TNamespace;
begin
  if Assigned(DragManager.DropTarget) then
    Result := TExplorerItem(DragManager.DropTarget).Namespace
  else
    Result := RootFolderNamespace
end;

function TCustomVirtualExplorerEasyListview.GetEnumThread: TVirtualBackGndEnumThread;
begin
  Result := FEnumThread;
end;

function TCustomVirtualExplorerEasyListview.GetExtensionColorCodeList: TExtensionColorCodeList;
begin
  Result := FExtensionColorCodeList
end;

function TCustomVirtualExplorerEasyListview.GetGroupingColumn: Integer;
begin
  Result := FGroupingColumn;
  if Assigned(RootFolderNamespace) then
  begin
    if Result >= RootFolderNamespace.DetailsSupportedColumns then
      Result := 0
  end else
    Result := 0
end;

function TCustomVirtualExplorerEasyListview.GetHeaderVisibility: Boolean;
begin
  Result := (View = elsReport) or Header.ShowInAllViews
end;

function TCustomVirtualExplorerEasyListview.GetItemCount: Integer;
begin
  Result := Groups.ItemCount
end;

function TCustomVirtualExplorerEasyListview.GetOkToShellNotifyDispatch: Boolean;
begin
   Result := not(EditManager.Editing or DragManager.Dragging or Dragging or ShellNotifySuspended or ContextMenuShown or DragManager.DragTarget)
end;

function TCustomVirtualExplorerEasyListview.GetPaintInfoColumn: TEasyPaintInfoColumn;
begin
  Result := inherited PaintInfoColumn as TEasyPaintInfoColumn
end;

function TCustomVirtualExplorerEasyListview.GetPaintInfoGroup: TEasyPaintInfoGroup;
begin
  Result := inherited PaintInfoGroup as TEasyPaintInfoGroup;
end;

function TCustomVirtualExplorerEasyListview.GetPaintInfoItem: TEasyPaintInfoItem;
begin
  Result := inherited PaintInfoItem as TEasyPaintInfoItem
end;

function TCustomVirtualExplorerEasyListview.GetSelectedFile: WideString;
begin
  Result := '';
  if Selection.Count > 0 then
    Result := (Selection.First as TExplorerItem).Namespace.NameForParsingInFolder
end;

function TCustomVirtualExplorerEasyListview.GetSelectedFiles: TStrings;
var
  Item: TExplorerItem;
begin
  Result := FSelectedFiles;
  FSelectedFiles.Clear;
  Item := Selection.First as TExplorerItem;
  while Assigned(Item) do
  begin
    FSelectedFiles.Add( Item.Namespace.NameForParsingInFolder);
    Item := Selection.Next(Item) as TExplorerItem
  end;
end;

function TCustomVirtualExplorerEasyListview.GetSelectedPath: WideString;
begin
  Result := '';
  if Selection.Count > 0 then
    Result := (Selection.First as TExplorerItem).Namespace.NameForParsing
end;

function TCustomVirtualExplorerEasyListview.GetSelectedPaths: TStrings;
var
  Item: TExplorerItem;
begin
  Result := FSelectedPaths;
  FSelectedPaths.Clear;
  Item := Selection.First as TExplorerItem;
  while Assigned(Item) do
  begin
    FSelectedPaths.Add( Item.Namespace.NameForParsing);
    Item := Selection.Next(Item) as TExplorerItem
  end
end;

function TCustomVirtualExplorerEasyListview.GetSelection: TEasyVirtualSelectionManager;
begin
  Result := TEasyVirtualSelectionManager( inherited Selection)
end;

function TCustomVirtualExplorerEasyListview.GetStorage: TRootNodeStorage;
begin
  Result := nil;
  // Allow custom or shared storage
  DoGetStorage(Result);
  if not Assigned(Result) then
    Result := FStorage;
end;

function TCustomVirtualExplorerEasyListview.GetThreadedDetailsEnabled: Boolean;
begin
  Result := not (csDesigning in ComponentState) and (eloThreadedDetails in Options) and not (ebcsPrinting in States)
end;

function TCustomVirtualExplorerEasyListview.GetThreadedIconsEnabled: Boolean;
begin
  Result := not (csDesigning in ComponentState) and (eloThreadedImages in Options) and not (ebcsPrinting in States)
end;

function TCustomVirtualExplorerEasyListview.GetThreadedThumbnailsEnabled: Boolean;
begin
  Result := not (csDesigning in ComponentState) and not (ebcsPrinting in States)
end;

function TCustomVirtualExplorerEasyListview.GetThreadedTilesEnabled: Boolean;
begin
  Result := not (ebcsPrinting in States)
end;

function TCustomVirtualExplorerEasyListview.GroupClass:  TExplorerGroupClass;
begin
  Result := TExplorerGroup;
  DoExplorerGroupClass(Result)
end;

function TCustomVirtualExplorerEasyListview.IsRootNamespace(PIDL: PItemIDList): Boolean;
begin
  Result := RootFolderNamespace.ComparePIDL(PIDL, True) = 0
end;

function TCustomVirtualExplorerEasyListview.LoadStorageToRoot(StorageNode: TNodeStorage): Boolean;
//
// Copies the view settings stored in the StorageNode to the control
//
var
  i: Integer;
  NS: TNamespace;
begin
  Result := False;
  if Assigned(StorageNode) then
  begin
    NS := TNamespace.Create(StorageNode.AbsolutePIDL, nil);
    try
      NS.FreePIDLOnDestroy := False;
      // Make sure it makes sense to use the StorageNode on the current Folder
      if (RootFolderNamespace.FileSystem and NS.FileSystem) or (NS.ComparePIDL(RootFolderNamespace.AbsolutePIDL, True, 0) = 0) then
      begin
        // If the Arrays are not the right length assume that SaveStorageToRoot was not called
        if (Length(StorageNode.Storage.Column.Visible) = Header.Columns.Count) and
             (Length(StorageNode.Storage.Column.Position) = Header.Columns.Count) and
             (Length(StorageNode.Storage.Column.Width) = Header.Columns.Count) then
        begin
          BeginUpdate;
          try
            FGroupingColumn := StorageNode.Storage.Grouping.GroupColumn;
            Grouped := StorageNode.Storage.Grouping.Enabled;
            ShowGroupMargins := Grouped;
            if TEasyListStyle( StorageNode.Storage.Grouping.View) < High(View) then
              View := TEasyListStyle( StorageNode.Storage.Grouping.View)
            else
              View := elsIcon;

            for i := 0 to Header.Columns.Count - 1 do
            begin
              if StorageNode.Storage.Column.SortColumn = i then
                Header.Columns[i].SortDirection := TEasySortDirection( StorageNode.Storage.Column.SortDir)
              else
                Header.Columns[i].SortDirection := esdNone;

              Header.Columns[i].Visible := StorageNode.Storage.Column.Visible[i];
              Header.Columns[i].Position := StorageNode.Storage.Column.Position[i];
              if (Groups.Count > 0) and Assigned(Groups[0].Grid) and Assigned(Groups[0].Grid.CellSize) then
              begin
                if not TEasyCellSizeHack( Groups[0].Grid.CellSize).AutoSizeCaption then
                  Header.Columns[i].Width := StorageNode.Storage.Column.Width[i]
                else begin
                  if i = 0 then
                    Header.Columns[i].Width := TEasyCellSizeHack( Groups[0].Grid.CellSize).Width
                  else
                    Header.Columns[i].Width := StorageNode.Storage.Column.Width[i];
                end
              end else
                Header.Columns[i].Width := StorageNode.Storage.Column.Width[i];
            end;
            DoLoadStorageToRoot(StorageNode);
            TestVisiblilityForSingleColumn;
            Result := True;
          finally
            EndUpdate
          end
        end
      end
    finally
      NS.Free
    end
  end
end;

function TCustomVirtualExplorerEasyListview.OkToBrowseTo(PIDL: PItemIDList): Boolean;
// check the PIDL to make sure it does not violate the BackBrowseRoot namespace limit
// for browsing up the ShellTree.
begin
  Result := True;
  if Result and Assigned(BackBrowseRoot) then
  // If the backbrowse lock is unassigned everything goes
  begin
  {$IFDEF EXPLORERTREEVIEW_L}
    // Make the listview respect any other shell controls Root
    if Assigned(ExplorerTreeview) then
    begin
      if Assigned(ExplorerTreeview.RootFolderNameSpace) then
        Result := ILIsParent(ExplorerTreeview.RootFolderNameSpace.AbsolutePIDL, PIDL, False)
    end else
  {$ENDIF}
      Result := ILIsParent(FBackBrowseRoot.AbsolutePIDL, PIDL, False)
  end
end;

function TCustomVirtualExplorerEasyListview.UseInternalDragImage(DataObject: IDataObject): Boolean;
var
  Medium: TStgMedium;
begin
  if (Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion < 6) then
    Result := True
  else begin
    if Succeeded(DataObject.GetData(HeaderClipFormat, Medium)) then
    begin
      ReleaseStgMedium(Medium);
      Result := True
    end else
      Result := False
  end
end;

procedure TCustomVirtualExplorerEasyListview.AddDetailsOfRequest(Request: TEasyDetailStringsThreadRequest);
var
  List: TList;
begin
  if Assigned(DetailsOfThread) then
  begin
    List := DetailsOfThread.RequestList.LockList;
    try
       List.Add(Request)
    finally
      DetailsOfThread.RequestList.UnlockList;
      DetailsOfThread.TriggerEvent
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.CheckForDefaultGroupVisibility;
var
  Done: Boolean;
  Group: TEasyGroup;
begin
  Done := False;
  Group := Groups.FirstGroup;
  while Assigned(Group) and not Done do
  begin
    if Group.Caption = DEFAULT_GROUP_NAME then
    begin
      Group.Visible := not Grouped;
      Done := True;
    end;
    Group := Groups.NextGroup(Group);
  end;
end;

procedure TCustomVirtualExplorerEasyListview.Clear;
begin
  GlobalThreadManager.FlushAllMessageCache(Self);
  TerminateEnumThread;
  TerminateDetailsOfThread;
  Groups.Clear();
  Groups.AddCustom(GroupClass).Caption := DEFAULT_GROUP_NAME;
  CheckForDefaultGroupVisibility;
end;

procedure TCustomVirtualExplorerEasyListview.CMFontChanged(var Msg: TMessage);
begin
  inherited;
  if ParentFont then
  begin
    CompressedFile.Font.Assign(TWinControlCracker(Parent).Font);
    if CompressedFile.Hilight then
      CompressedFile.Font.Color := CompressedFile.Color;
    EncryptedFile.Font.Assign(TWinControlCracker(Parent).Font);
    if EncryptedFile.Hilight then
      EncryptedFile.Font.Color := EncryptedFile.Color;
  end else
  begin
    CompressedFile.Font.Assign(Font);
    if CompressedFile.Hilight then
      CompressedFile.Font.Color := CompressedFile.Color;
    EncryptedFile.Font.Assign(Font);
    if EncryptedFile.Hilight then
      EncryptedFile.Font.Color := EncryptedFile.Color;
  end
end;

procedure TCustomVirtualExplorerEasyListview.CMParentFontChanged(var Msg: TMessage);
begin
  inherited;
  if ParentFont then
  begin
    CompressedFile.Font.Assign(TWinControlCracker(Parent).Font);
    if CompressedFile.Hilight then
      CompressedFile.Font.Color := CompressedFile.Color;
    EncryptedFile.Font.Assign(TWinControlCracker(Parent).Font);
    if EncryptedFile.Hilight then
      EncryptedFile.Font.Color := EncryptedFile.Color;
  end else
  begin
    CompressedFile.Font.Assign(Font);
    if CompressedFile.Hilight then
      CompressedFile.Font.Color := CompressedFile.Color;
    EncryptedFile.Font.Assign(Font);
    if EncryptedFile.Hilight then
      EncryptedFile.Font.Color := EncryptedFile.Color;
  end
end;

procedure TCustomVirtualExplorerEasyListview.ColumnHeaderMenuItemClick(Sender: TObject);

  function IsDuplicate(VST: TVirtualStringTree; Text: WideString): Boolean;
  var
    ColData: PColumnData;
    Node: PVirtualNode;
  begin
    Result := False;
    Node := VST.GetFirst;
    while not Result and Assigned(Node) do
    begin
      ColData := VST.GetNodeData(Node);
      Result := WideStrComp(PWideChar(ColData^.Title), PWideChar( Text)) = 0;
      Node := VST.GetNext(Node)
    end
  end;

var
  {$IFDEF USE_TOOLBAR_TB2K}
  Item: TTBCustomItem;
  {$ELSE}
  Item: TVirtualMenuItem;
  {$ENDIF}
  ColumnSettings: TFormColumnSettings;
  ColumnNames: TVirtualStringTree;
  ColData: PColumnData;
  BackupHeader: TMemoryStream;
  i, j, Count: Integer;
begin
  {$IFDEF USE_TOOLBAR_TB2K}
  Item := Sender as TTBCustomItem;
  Count := TTBPopupMenu(ColumnHeaderMenu).Items.Count; // Items is not polymorphic
  {$ELSE}
  Item := Sender as TVirtualMenuItem;
  Count := ColumnHeaderMenu.Items.Count;
  {$ENDIF}

  if Item.Tag = Count - 1 then
  begin
    ColumnSettings := TFormColumnSettings.Create(nil);

    BackupHeader := TMemoryStream.Create;
    ColumnNames := ColumnSettings.VSTColumnNames;
    ColumnNames.BeginUpdate;
    try
      for i := 0 to Header.Columns.Count - 1 do
      begin
        j := 0;
        { Create the nodes ordered in columns items relative position }
        while (j < Header.Columns.Count) and (Header.Columns[j].Position <> i) do
          Inc(j);
        if (Header.Columns[j].Caption <> '') and not IsDuplicate(ColumnNames, Header.Columns[j].Caption) then
        begin
          ColData := ColumnNames.GetNodeData(ColumnNames.AddChild(nil));
          ColData.Title := Header.Columns[j].Caption;
          ColData.Enabled :=  Header.Columns[j].Visible;
          ColData.Width := Header.Columns[j].Width;
          ColData.ColumnIndex := Header.Columns[j].Index;
        end
      end;
      Header.SaveToStream(BackupHeader);
      BackupHeader.Seek(0, soFromBeginning);
    finally
      ColumnNames.EndUpdate;
    end;

    ColumnSettings.OnVETUpdate := ColumnSettingCallback;
    if ColumnSettings.ShowModal = mrOk then
    begin
      UpdateColumnsFromDialog(ColumnNames);
      DoColumnStructureChange;
    end else
    begin
      BeginUpdate;
      try
        Header.LoadFromStream(BackupHeader);
      finally
        EndUpdate
      end
    end;

    BackupHeader.Free;
    ColumnSettings.Release
  end else
  begin
    Header.Columns[Item.Tag].Visible := not Item.Checked;
    DoColumnStructureChange;
  end
end;

procedure TCustomVirtualExplorerEasyListview.ColumnSettingCallback(Sender: TObject);
begin
  UpdateColumnsFromDialog((Sender as TFormColumnSettings).VSTColumnNames);
end;

procedure TCustomVirtualExplorerEasyListview.DoAfterPaint(ACanvas: TCanvas; ClipRect: TRect);
begin
  if Assigned(OnAfterPaint) then
    OnAfterPaint(Self, ACanvas, ClipRect)
end;

procedure TCustomVirtualExplorerEasyListview.DoAfterShellNotify(ShellEvent: TVirtualShellEvent);
begin
  if Assigned(OnAfterShellNotify) then
    OnAfterShellNotify(Self, ShellEvent)
end;

procedure TCustomVirtualExplorerEasyListview.DoColumnContextMenu(HitInfo: TEasyHitInfoColumn; WindowPoint: TPoint; var Menu: TPopupMenu);

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


var
  i, MenuItemCount: Integer;
  Item: TVirtualMenuItem;
  {$IFDEF USE_TOOLBAR_TB2K}
  TBItem: TTBCustomItem;
  TBMenuItem: TTBRootItem;
  {$ENDIF}
begin
  inherited DoColumnContextMenu(HitInfo, WindowPoint, Menu);
  if not Assigned(Menu) then
  begin
    FreeAndNil(FColumnHeaderMenu);
    {$IFDEF USE_TOOLBAR_TB2K}if not(Assigned(ItemClass) and Assigned(MenuClass)) then {$ENDIF}
    begin
      // Don't let Tnt Thunk the menu. Jiang Hong claims this can cause problem here...
   //   ColumnHeaderMenu := TVirtualPopupMenu(TPopupMenu.Create(Self));
      ColumnHeaderMenu := TVirtualPopupMenu.Create(Self);
      Menu := ColumnHeaderMenu;
      Menu.Items.Clear;
      MenuItemCount := ColumnMenuItemCount;
      if MenuItemCount > RootFolderNamespace.DetailsSupportedColumns then
        MenuItemCount := RootFolderNamespace.DetailsSupportedColumns;
      for i := 0 to MenuItemCount - 1 do
      begin
        Item := TVirtualMenuItem.Create(Menu);
        Item.Caption := RootFolderNamespace.DetailsColumnTitle(i);
        Item.Checked := Header.Columns[i].Visible;
        Item.OnClick := ColumnHeaderMenuItemClick;
        Item.Tag := i;
        Menu.Items.Add(Item)
      end;
      Item := TVirtualMenuItem.Create(Menu);
      Item.Caption := '-';
      Item.Tag := MenuItemCount;
      Menu.Items.Add(Item);
      Item := TVirtualMenuItem.Create(Menu);
      Item.Caption := STR_HEADERMENUMORE;
      Item.Tag := MenuItemCount + 1;
      Item.OnClick := ColumnHeaderMenuItemClick;
      Menu.Items.Add(Item)
    end {$IFDEF USE_TOOLBAR_TB2K}else
    begin
      ColumnHeaderMenu := MenuClass.Create(Self);
      Menu := ColumnHeaderMenu;
      TBMenuItem := (Menu as TTBPopupMenu).Items;
      TBMenuItem.Clear;
      MenuItemCount := ColumnMenuItemCount;
      if MenuItemCount > RootFolderNamespace.DetailsSupportedColumns then
        MenuItemCount := RootFolderNamespace.DetailsSupportedColumns;
      for i := 0 to MenuItemCount - 1 do
      begin
        TBItem := ItemClass.Create(ColumnHeaderMenu);
        TBItem.Caption := RootFolderNamespace.DetailsColumnTitle(i);
        SetTBItemCaption(TBItem, RootFolderNamespace.DetailsColumnTitle(i));
        TBItem.Checked := Header.Columns[i].Visible;
        TBItem.OnClick := ColumnHeaderMenuItemClick;
        TBItem.Tag := i;
        TBMenuItem.Add(TBItem)
      end;
      TBItem := TTBSeparatorItem.Create(ColumnHeaderMenu);
      TBItem.Tag := MenuItemCount;
      TBMenuItem.Add(TBItem);
      TBItem := ItemClass.Create(ColumnHeaderMenu);
      TBItem.Caption := STR_HEADERMENUMORE;
      SetTBItemCaption(TBItem, STR_HEADERMENUMORE);
      TBItem.Tag := MenuItemCount + 1;
      TBItem.OnClick := ColumnHeaderMenuItemClick;
      TBMenuItem.Add(TBItem)
    end {$ENDIF}
  end
end;

procedure TCustomVirtualExplorerEasyListview.DoContextMenu(MousePt: TPoint;
  var Handled: Boolean);
begin
  if Assigned(BackGndMenu) then
  begin
    BackGndMenu.ShowContextMenu(Self, RootFolderNamespace, @MousePt);
    Handled := True; // We handled it.
  end else
    inherited
end;

procedure TCustomVirtualExplorerEasyListview.DoCustomColumnAdd;
begin
  if Assigned(OnCustomColumnAdd) then
    OnCustomColumnAdd(Self, AddColumnProc)
end;

procedure TCustomVirtualExplorerEasyListview.DoCustomColumnCompare(Column: TExplorerColumn; Group: TEasyGroup; Item1, Item2: TExplorerItem; var CompareResult: Integer);
begin
  if Assigned(OnCustomColumnCompare) then
    OnCustomColumnCompare(Self, Column, Group, Item1, Item2, CompareResult)
end;

procedure TCustomVirtualExplorerEasyListview.DoCustomColumnGetCaption(Column: TExplorerColumn; Item: TExplorerItem; var Caption: WideString);
begin
  if Assigned(OnCustomColumnGetCaption) then
    OnCustomColumnGetCaption(Self, Column, Item, Caption)
end;

procedure TCustomVirtualExplorerEasyListview.DoEnumFinished;
begin
  if Assigned(OnEnumFinished) then
    OnEnumFinished(Self);
end;

procedure TCustomVirtualExplorerEasyListview.DoEnumThreadLengthyOperation(var ShowAnimation: Boolean);
begin
  if Assigned(OnEnumThreadLengthyOperation) then
    OnEnumThreadLengthyOperation(Self, ShowAnimation)
end;

procedure TCustomVirtualExplorerEasyListview.DoExplorerGroupClass(var GroupClass: TExplorerGroupClass);
begin
  GroupClass := nil;
  if Assigned(OnExplorerGroupClass) then
    OnExplorerGroupClass(Self, GroupClass);
  if not Assigned(GroupClass) then
    GroupClass := TExplorerGroup
end;

procedure TCustomVirtualExplorerEasyListview.DoExplorerItemClass(var ItemClass: TExplorerItemClass);
begin
  if Assigned(OnExplorerItemClass) then
    OnExplorerItemClass(Self, ItemClass);
  if not Assigned(ItemClass) then
    ItemClass := TExplorerItem
end;

function TCustomVirtualExplorerEasyListview.LoadFolderFromPropertyBag(IgnoreOptions: Boolean = False): Boolean;
//
// Attempts to find the current RootFolder view setting in the Storage (local or overridden).
// If it finds it the view settings are copied to the control
begin
  Result := False;
  if (IgnoreOptions or (eloPerFolderStorage in Options)) and Assigned(RootFolderNamespace) and Assigned(Storage) then
    Result := LoadStorageToRoot(Storage.Find(RootFolderNamespace.AbsolutePIDL, [stGrouping, stColumns]))
end;

function TCustomVirtualExplorerEasyListview.LoadFolderFromPrevView: Boolean;
//
// Copies the contents of the PrevFolderSettings NodeStorage to the control. The
// PrevFolderSettings are automatically saved when the root folder is changed so
// there is no need to manually store it.
// This is different then LoadFolderFromPropertyBag in that this is not a persistent
// storage.  It is a one level deep (the last view) stack of how the user modified
// the control's view on the last folder.
//
begin
  Result := LoadStorageToRoot(PrevFolderSettings)
end;

procedure TCustomVirtualExplorerEasyListview.DoGetHintTimeOut(var HintTimeOut: Integer);
begin
  HintTimeOut := QueryInfoHintTimeout
end;

procedure TCustomVirtualExplorerEasyListview.DoGetStorage(var Storage: TRootNodeStorage);
begin
  if Assigned(OnGetStorage) then
    OnGetStorage(Self, Storage)
end;

procedure TCustomVirtualExplorerEasyListview.DoGroupingChange;
begin
  if Assigned(OnGroupingChange) then
    OnGroupingChange(Self)
end;

procedure TCustomVirtualExplorerEasyListview.DoItemCreateEditor(Item: TEasyItem; var Editor: IEasyCellEditor);
begin
  if View in MULTILINEVIEWS then
    Editor := TEasyExplorerMemoEditor.Create
  else
    Editor := TEasyExplorerStringEditor.Create;
end;

procedure TCustomVirtualExplorerEasyListview.DoItemCustomView(Item: TEasyItem;
  ViewStyle: TEasyListStyle; var View: TEasyViewItemClass);
begin
  inherited DoItemCustomView(Item, ViewStyle, View);
  if ThumbsManager.HideCaption then
  begin
    if not Assigned(View) and ((Self.View = elsThumbnail) or (Self.View = elsFilmStrip)) then
      View := TEasyVirtualThumbView
  end
end;

procedure TCustomVirtualExplorerEasyListview.DoItemGetEditCaption(Item: TEasyItem; Column: TEasyColumn; var Caption: WideString);
begin
  Caption := TExplorerItem( Item).Namespace.NameForEditingInFolder
end;

procedure TCustomVirtualExplorerEasyListview.DoItemPaintText(Item: TEasyItem;
  Position: Integer; ACanvas: TCanvas);
var
  ColorCode: TExtensionColorCode;
begin
  if CompressedFile.Hilight and (Position = 0) then
    if TExplorerItem(Item).Namespace.Compressed and not Item.Selected then
      ACanvas.Font.Assign(CompressedFile.Font);
  if EncryptedFile.Hilight and (Position = 0) then
    if TExplorerItem(Item).Namespace.Encrypted and not Item.Selected then
      ACanvas.Font.Assign(EncryptedFile.Font);

  if ExtensionColorCode and Assigned(TExplorerItem(Item).Namespace) and TExplorerItem(Item).Namespace.FileSystem and ((ExtensionColorCodeSelected and Item.Selected) or not Item.Selected) then
  begin
    ColorCode := ExtensionColorCodeList.FindColorCode(TExplorerItem(Item).Namespace);
    if Assigned(ColorCode) and ColorCode.Enabled then
    begin
      if ColorCode.Color <> clNone then
        ACanvas.Font.Color := ColorCode.Color;
      if ColorCode.Bold then
        ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
      if ColorCode.Italic then
        ACanvas.Font.Style := ACanvas.Font.Style + [fsItalic];
      if ColorCode.UnderLine then
        ACanvas.Font.Style := ACanvas.Font.Style + [fsUnderLine];
    end
  end;

  inherited DoItemPaintText(Item, Position, ACanvas);
end;

procedure TCustomVirtualExplorerEasyListview.DoQuickFilterCustomCompare(Item: TExplorerItem; Mask: WideString; var IsVisible: Boolean);
begin
  if Assigned(OnQuickFilterCustomCompare) then
    OnQuickFilterCustomCompare(Self, Item, Mask, IsVisible)
end;

procedure TCustomVirtualExplorerEasyListview.DoQuickFilterEnd;
begin
  if Assigned(OnQuickFilterEnd) then
    OnQuickFilterEnd(Self)
end;

procedure TCustomVirtualExplorerEasyListview.DoQuickFilterStart(Mask: WideString);
begin
  if Assigned(OnQuickFilterStart) then
    OnQuickFilterStart(Self, Mask)
end;

procedure TCustomVirtualExplorerEasyListview.DoRebuildingShellHeader(var Allow: Boolean);
begin
  if Assigned(OnRebuildingShellHeader) then
    OnRebuildingShellHeader(Self, Allow)
end;

procedure TCustomVirtualExplorerEasyListview.DoRebuiltShellHeader;
begin
  if Assigned(OnRebuiltShellHeader) then
    OnRebuiltShellHeader(Self)
end;

procedure TCustomVirtualExplorerEasyListview.DoSaveRootToStorage(StorageNode: TNodeStorage);
begin
  if Assigned(OnSaveRootToStorage) then
    OnSaveRootToStorage(Self, StorageNode)
end;

procedure TCustomVirtualExplorerEasyListview.DoThumbThreadCreate(var ThumbRequest: TEasyThumbnailThreadRequest);
begin
  if Assigned(OnThumbRequestCreate) then
    OnThumbRequestCreate(Self, ThumbRequest)
end;

procedure TCustomVirtualExplorerEasyListview.Enqueue(NS: TNamespace;
  Item: TEasyItem; ThumbSize: TPoint; UseShellExtraction, IsResizing: Boolean);
begin
  if not (csDestroying in ComponentState) then
    // Send a thumb request to the GlobalThreadManager
    AddThumbRequest(Self, Item as TExplorerItem, ThumbSize, ThumbsManager.UseExifThumbnail,
      ThumbsManager.UseExifOrientation, UseShellExtraction, ThumbsManager.UseSubsampling, IsResizing,
      DoThumbThreadCreate);
end;

procedure TCustomVirtualExplorerEasyListview.EnumThreadFinished(DoSort: Boolean);
var
  Item: TEasyItem;
begin
  BeginUpdate;
  try
    // Focus the first item (mimic Windows Explorer) and set the
    // Selection.AnchorItem to the first item
    if Sort.AutoSort then
    begin
      // The ListView won't be sorted until all the nested EndUpdate
      // are called (TCustomEasyListview.EndUpdate).
      // We need to force the sorting here before we focus the 1st item.
      if DoSort then
        Sort.SortAll(True)
      else
        Groups.Rebuild(True)
    end;
    Selection.ClearAll;
    Item := Groups.FirstItem;
    if Assigned(Item) then
    begin
      // AnchorItem should be forced to be the first item
      Selection.AnchorItem := Item;
      // Force the first item focus
      if Selection.FirstItemFocus then
      begin
        Item.Focused := True;
        //This was cause a brief selection/flicker on the first item
        //once the control was filled. Is it really necessary to Select here?
        //Item.Selected := True
      end
    end;
    if Assigned(OldTopNode) then
    begin
      Item := FindItemByPIDL(OldTopNode);
      if Assigned(Item) then
        Item.MakeVisible(emvTop);
      PIDLMgr.FreeAndNilPIDL(FOldTopNode)
    end;

    if Assigned(ThumbsManager) and ThumbsManager.AutoLoad then
      ThumbsManager.LoadAlbum;    
    LoadAllThumbs;
    QuickFilter;
    DoEnumFinished;
  finally
    EndUpdate
  end
end;

procedure TCustomVirtualExplorerEasyListview.EnumThreadStart;
begin
 // Cursor := crHourglass;
end;

procedure TCustomVirtualExplorerEasyListview.EnumThreadTimer(Enable: Boolean);
var
  Msg: TMsg;
  RePostQuitCode: Integer;
  RePostQuit: Boolean;
begin
  if HandleAllocated then
  begin
    if Enable then
    begin
      EnumTimer := SetTimer(Handle, ID_TIMER_ENUMBKGND, 50, nil);
      EnumBkGndTime := 0;
    end else
    begin
      if EnumTimer <> 0 then
        KillTimer(Handle, EnumTimer);
      EnumTimer := 0;

      RePostQuit := False;
      RePostQuitCode := 0;
      // Flush the cache of Timer Messages
      while PeekMessage(Msg, Handle, WM_TIMER, WM_TIMER, PM_REMOVE) do
      begin
        if Msg.message = WM_QUIT then
        begin
          RePostQuitCode := Msg.WParam;
          RePostQuit := True;
        end else
        if Msg.wParam <> ID_TIMER_ENUMBKGND then
        begin
          TranslateMessage(Msg);
          DispatchMessage(Msg)
        end
      end;
      if RePostQuit then
        PostQuitMessage(RePostQuitCode);
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.FlushDetailsOfThread;
var
  Msg: TMsg;
  R: TCommonThreadRequest;
  RePostQuitCode: Integer;
  RePostQuit: Boolean;
begin
  if Assigned(DetailsOfThread) then
  begin
    DetailsOfThread.RequestList.LockList;
    try
      if HandleAllocated then
      begin
        RePostQuit := False;
        RePostQuitCode := 0;
          // Remove the requests in the message cache
        while PeekMessage(Msg, Handle, WM_DETAILSOF_THREAD, WM_DETAILSOF_THREAD, PM_REMOVE) do
        begin
          if Msg.Message = WM_QUIT then
          begin
            RePostQuit := True;
            RePostQuitCode := Msg.WParam
          end else
          begin
              // If the message is for the window to flush then free it, else dispatch it normally
            R := TCommonThreadRequest(Msg.lParam);
            R.Free
          end
        end;
        if RepostQuit then
          PostQuitMessage(RePostQuitCode);
      end;
      if Assigned(DetailsOfThread) then
        DetailsOfThread.FlushRequestList;
    finally
      DetailsOfThread.RequestList.UnLockList
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.HideAnimateFolderWnd;
begin
  if Assigned(AnimateFolderEnum) then
  begin
    FreeAndNil(FAnimateFolderEnum);
    Header.Visible := GetHeaderVisibility;
    RebuildShellHeader;
  end;
end;

function TCustomVirtualExplorerEasyListview.ItemBelongsToList(Item: TExplorerItem): Boolean;
var
  i, j: Integer;
begin
  i := 0;
  Result := False;
  while not Result and (i < Groups.Count) do
  begin
    j := 0;
    while not Result and (j < Groups[i].ItemCount) do
    begin
      Result := Groups[i][j] = Item;
      Inc(j)
    end;
    Inc(i)
  end
end;

procedure TCustomVirtualExplorerEasyListview.LoadAllThumbs;
var
  NS: TNamespace;
  Item: TExplorerItem;
  VFF: TValidImageFileFormat;
  ThumbSize: TPoint;
  RectArray: TEasyRectArrayObject;
begin
  if ThumbsManager.LoadAllAtOnce and IsThumbnailView then
  begin
    Item := TExplorerItem(Groups.FirstItem);
    while Assigned(Item) do
    begin
      if ValidateNamespace(Item, NS) then
      begin
        if not ThumbsManager.Updating and (NS.States * [nsThreadedImageLoaded, nsThreadedImageLoading, nsThreadedImageResizing] = []) then
        begin
          Item.View.ItemRectArray(Item, nil, Canvas, Item.Caption, RectArray);
          VFF := ThumbsManager.IsValidImageFileFormat(NS);
          if VFF <> vffInvalid then
          begin
            ThumbSize.X := Max(RectWidth(RectArray.IconRect), ThumbsManager.MaxThumbWidth);
            ThumbSize.Y := Max(RectHeight(RectArray.IconRect), ThumbsManager.MaxThumbHeight);
            Enqueue(NS, Item, ThumbSize, VFF = vffUnknown, False);
          end;
        end
      end;
      Item := TExplorerItem( Groups.NextItem(Item))
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.LoadFromStream(S: TStream);
var
  RFolder: TRootFolder;
  CustomPIDL: PItemIDList;
  CustomPath: WideString;
  TempInt, i, Version: Integer;
begin
  VETStates := VETStates + [vsLockChangeNotifier];
  try
    inherited LoadFromStream(S);
    S.Read(Version, SizeOf(Version));
    S.ReadComponent(Self);
    if Version > 0 then
    begin
      S.Read(TempInt, SizeOf(TempInt));
      SetLength(FGroupingFileSizeArray, TempInt);
      for i := 0 to TempInt - 1 do
      begin
        LoadWideString(S, GroupingFileSizeArray[i].Caption);
        S.Read(GroupingFileSizeArray[i].FileSize, SizeOf(GroupingFileSizeArray[i].FileSize));
        S.Read(GroupingFileSizeArray[i].Enabled, SizeOf(GroupingFileSizeArray[i].Enabled));
        S.Read(GroupingFileSizeArray[i].SpecialFolder, SizeOf(GroupingFileSizeArray[i].SpecialFolder));
      end;

      S.Read(TempInt, SizeOf(TempInt));
      SetLength(FGroupingModifiedArray, TempInt);
      for i := 0 to TempInt - 1 do
      begin
        LoadWideString(S, GroupingModifiedArray[i].Caption);
        S.Read(GroupingModifiedArray[i].Days, SizeOf(GroupingModifiedArray[i].Days));
        S.Read(GroupingModifiedArray[i].Enabled, SizeOf(GroupingModifiedArray[i].Enabled));
      end;

      S.Read(RFolder, SizeOf(TRootFolder));
      CustomPIDL := PIDLMgr.LoadFromStream(S);
      LoadWideString(S, CustomPath);
      if RFolder = rfCustom then
      begin
        if WideDirectoryExists(CustomPath) then
          RootFolderCustomPath := CustomPath
        else
          RootFolder := rfDesktop
      end else
      if RFolder = rfCustomPIDL then
      begin
        RootFolder := rfDesktop;   // Necessary, stream won't load custom pidls
        if Assigned(CustomPIDL) then
          RootFolderCustomPIDL := CustomPIDL
        else
          RootFolder := rfDesktop
      end else
        RootFolder := RFolder;

      PIDLMgr.FreePIDL(CustomPIDL);
    end;
    { if Version > n then
      begin
      end }
    if Version > 1 then
      ExtensionColorCodeList.LoadFromStream(S, Version, True)
  finally
    VETStates := VETStates - [vsLockChangeNotifier];
  end
end;

procedure TCustomVirtualExplorerEasyListview.LockBrowseLevel;
begin
  if Assigned(RootFolderNamespace) then
    BackBrowseRoot := TNamespace.Create(PIDLMgr.CopyPIDL(RootFolderNamespace.AbsolutePIDL), nil)
  else
    FreeAndNil(FBackBrowseRoot)
end;

procedure TCustomVirtualExplorerEasyListview.OrphanThreadsFree;
var
  i: Integer;
  Temp: TCommonThread;
begin
  for i := OrphanThreadList.Count - 1 downto 0 do
  begin
    if TCommonThread( OrphanThreadList[i]).Finished then
    begin
      Temp := TCommonThread( OrphanThreadList[i]);
      OrphanThreadList.Remove(Temp);
      Temp.Free
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.PackTileStrings(NS: TNamespace);
//
// Packs the strings by removing any blank strings
var
  i, j: Integer;
begin
  for i := Length(NS.TileDetail) - 1 downto 0 do
  begin
    if NS.DetailsOf(NS.TileDetail[i]) = '' then
    begin
      for j := i to Length(NS.TileDetail) - 2 do
      begin
        NS.TileDetail[j] := NS.TileDetail[j + 1];
        NS.TileDetail[j + 1] := -1;
      end
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.PasteFromClipboardAsShortcut;
var
  NSA: TNamespaceArray;
begin
  // Explorer ALWAYS pastes into the current view.
  Cursor := crHourglass;
  try
    if Assigned(RootFolderNamespace) then
    begin
      SetLength(NSA, 1);
      NSA[0] := RootFolderNamespace;
      RootFolderNamespace.Paste(Self, NSA, True);
    end;
  finally
    Cursor := crDefault
  end
end;

procedure TCustomVirtualExplorerEasyListview.QuickFilter;
var
  Item: TExplorerItem;
  SearchResult: Integer;
  Custom, CustomVisible: Boolean;
begin
  if QuickFiltered then
  begin
    BeginUpdate;
    DoQuickFilterStart(QuickFilterMask);
    try
      Custom := Assigned(OnQuickFilterCustomCompare);
      Item := TExplorerItem( Groups.FirstItem);
      while Assigned(Item) do
      begin
        if Custom then
        begin
          CustomVisible := True;
          DoQuickFilterCustomCompare(Item, QuickFilterMask, CustomVisible);
          Item.Visible := CustomVisible
        end else
        begin
          SearchResult := WideIncrementalSearch(Item.Caption, QuickFilterMask);
          if SearchResult <> 0 then
            Item.Visible := WidePathMatchSpec(Item.Namespace.NameAddressbarInFolder, QuickFilterMask)
          else
            Item.Visible := True;
        end;
        Item := TExplorerItem( Groups.NextItem(Item))
      end;
    finally
      QuickFilterUpdatedNeeded := False;
      DoQuickFilterEnd;
      EndUpdate
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.SaveRebuildRestoreRootNamespace;
begin
  try
    BeginUpdate;
    FELVPersistent.SaveList(Self, True, True);
    FELVPersistent.RestoreList(Self, True, True);
  finally
    EndUpdate
  end;
end;

procedure TCustomVirtualExplorerEasyListview.SaveToStream(S: TStream);
var
  TempInt, i, Version: Integer;
begin
  inherited SaveToStream(S);
  Version := CURRENT_EASYLISTVIEWEXPLORER_STREAM_VERSION;
  S.Write(Version, SizeOf(Version));

  S.WriteComponent(Self);
  TempInt := Length(GroupingFileSizeArray);
  S.Write(TempInt, SizeOf(TempInt));
  for i := 0 to TempInt - 1 do
  begin
    SaveWideString(S, GroupingFileSizeArray[i].Caption);
    S.Write(GroupingFileSizeArray[i].FileSize, SizeOf(GroupingFileSizeArray[i].FileSize));
    S.Write(GroupingFileSizeArray[i].Enabled, SizeOf(GroupingFileSizeArray[i].Enabled));
    S.Write(GroupingFileSizeArray[i].SpecialFolder, SizeOf(GroupingFileSizeArray[i].SpecialFolder));
  end;

  TempInt := Length(GroupingModifiedArray);
  S.Write(TempInt, SizeOf(TempInt));
  for i := 0 to TempInt - 1 do
  begin
    SaveWideString(S, GroupingModifiedArray[i].Caption);
    S.Write(GroupingModifiedArray[i].Days, SizeOf(GroupingModifiedArray[i].Days));
    S.Write(GroupingModifiedArray[i].Enabled, SizeOf(GroupingModifiedArray[i].Enabled));
  end;

  S.Write(RootFolder, SizeOf(TRootFolder));
  PIDLMgr.SaveToStream(S, RootFolderCustomPIDL);
  SaveWideString(S, RootFolderCustomPath);

  if Version > 1 then
    ExtensionColorCodeList.SaveToStream(S, Version, True)

end;

procedure TCustomVirtualExplorerEasyListview.SelectedFilesDelete(ShiftKeyState: TExecuteVerbShift = evsCurrent);
var
  Item: TExplorerItem;
begin
  Cursor := crHourglass;
  try
    Item := TExplorerItem(Selection.First);
    if Assigned(Item) then
      Item.Namespace.Delete(Self, SelectedToNamespaceArray, ShiftKeyState)
  finally
    Cursor := crDefault
  end
end;

procedure TCustomVirtualExplorerEasyListview.SelectedFilesShowProperties;
var
  NS: TNamespace;
begin
  if ValidateNamespace(Selection.First, NS) then
    NS.ShowPropertySheetMulti(Self, SelectedToNamespaceArray);
end;

function TCustomVirtualExplorerEasyListview.SelectedToDataObject: IDataObject;
var
  NS: TNamespace;
  PIDLArray: TAbsolutePIDLArray;
begin
  PIDLArray := nil;
  if ValidateNamespace(Selection.First, NS) then
    Result := NS.DataObjectMulti(SelectedToNamespaceArray)
end;

function TCustomVirtualExplorerEasyListview.SelectedToNamespaceArray: TNamespaceArray;
var
  I: Integer;
  Item: TEasyItem;
begin
  SetLength(Result, Selection.Count);
  I := 0;
  Item := Selection.First;
  while Assigned(Item) do
  begin
    // This really slows things down
 //   if TExplorerItem(Item).Namespace.Valid then
    begin
      Result[I] := TExplorerItem(Item).Namespace;
      Inc(I);
    end;
    Item := Selection.Next(Item)
  end;
  SetLength(Result, I);
end;

function TCustomVirtualExplorerEasyListview.SelectedToPIDLArray: TRelativePIDLArray;
var
  I: Integer;
  Item: TEasyItem;
begin
  SetLength(Result, Selection.Count);
  I := 0;
  Item := Selection.First;
  while Assigned(Item) do
  begin
    // This really slows things down
 //   if TExplorerItem(Item).Namespace.Valid then
    begin
      Result[I] := TExplorerItem(Item).Namespace.RelativePIDL;
      Inc(I);
    end;
    Item := Selection.Next(Item);
  end;
  SetLength(Result, I);
end;

function TCustomVirtualExplorerEasyListview.ValidateNamespace(Item: TEasyItem;
  var Namespace: TNamespace): Boolean;
begin
  try
    if Assigned(Item) and (Item is TExplorerItem) then
      Namespace := TExplorerItem(Item).Namespace
    else
      Namespace := nil;
  //  Assert(Assigned(Namespace), 'ValidateNamespace fail, the Item was not a TExplorerItem or the passed Parameter was nil');
    Result := Assigned(Namespace);
  except
    // We don't always pull the item out of the system when the view changes and a thread will send an item
    // that was already destroyed.  I am not sure how to do more than I am to make sure I get all the stale Item pointers
    // out of the thread or message cache.....
    Result := False
  end
end;

function TCustomVirtualExplorerEasyListview.ValidateThumbnail(Item: TEasyItem; var ThumbInfo: TThumbInfo): Boolean;
begin
   if Assigned(Item) then
    ThumbInfo := TExplorerItem(Item).ThumbInfo
  else
    ThumbInfo := nil;
  Result := Assigned(ThumbInfo);
end;

function TCustomVirtualExplorerEasyListview.ValidRootNamespace: Boolean;
begin
  Result := False;
  if Assigned(RootFolderNamespace) then
    Result := RootFolderNamespace.Valid;
  if not Result then
    DoInvalidRootNamespace;
end;

procedure TCustomVirtualExplorerEasyListview.ActivateTree(Activate: Boolean);
begin
  if not (csLoading in ComponentState) then
  begin
    if Activate and not FActivated then
    begin
      FActivated := True;
      if Assigned(FRootFolderNamespace) then
      begin
        RebuildRootNamespace;
        RebuildShellHeader
      end
    end else
    if not Activate and FActivated then
    begin
      FActivated := False;
      GlobalThreadManager.FlushAllMessageCache(Self);
      TerminateEnumThread;
      TerminateDetailsOfThread;
      Groups.Clear;
    end
  end else
    if (csDesigning in ComponentState) then
      RebuildRootNamespace;
end;

function TCustomVirtualExplorerEasyListview.AddCustomItem(Group: TEasyGroup; NS: TNamespace; LockoutSort: Boolean): TExplorerItem;
var
  ItemClass: TExplorerItemClass;
begin
  ItemClass := nil;
  DoExplorerItemClass(ItemClass);
  if LockoutSort then
    Sort.LockoutSort := True;
  if Assigned(Group) then
    Result := Group.Items.InsertCustom(Group.Items.Count, ItemClass) as TExplorerItem
  else begin
    if Grouped then
      Result := FindGroup(NS).Items.AddCustom(ItemClass, nil) as TExplorerItem
    else
      Result := Items.AddCustom(ItemClass, nil) as TExplorerItem;
  end;
  Result.Ghosted := (eloGhostHiddenFiles in Options) and NS.Hidden;
  if LockoutSort then
    Sort.LockoutSort := False;
  Result.Namespace := NS;
end;

function TCustomVirtualExplorerEasyListview.BrowseTo(APath: WideString; SelectTarget: Boolean = True): Boolean;
var
  PIDL: PItemIdList;
begin
  Result := False;
  PIDL := PathToPIDL(APath);
  try
    if Assigned(PIDL) then
      Result := BrowseToByPIDL(PIDL, SelectTarget);
  finally
    PIDLMgr.FreePIDL(PIDL);
  end
end;

function TCustomVirtualExplorerEasyListview.BrowseToByPIDL(APIDL: PItemIDList; SelectTarget: Boolean = True; ShowExplorerMsg: Boolean = True): Boolean;
var
  NS: TNamespace;
  P, OldPIDL, JunctionPtPIDL: PItemIDList;
  SelectItem: TExplorerItem;
  Browsing, FreePIDL, ParentBrowsable: Boolean;
  JunctionPtPath: WideString;
begin
  P := nil;
  FreePIDL := False;
  Browsing := False;
  NS := TNamespace.Create(APIDL, nil);
  try
    NS.FreePIDLOnDestroy := False;
    if OkToBrowseTo(APIDL) and NS.OkToBrowse(ShowExplorerMsg) then
    begin
      ParentBrowsable := IsParentBrowseable(NS);
    // If the path was a file then find the parent folder
      if not NS.Folder and not ParentBrowsable then
        P := NS.Parent.AbsolutePIDL
      else begin
        if not ParentBrowsable then
          P := APIDL
        else begin
          if (eloBrowseExecuteZipFolder in Options) then
          begin
            if NS.Folder then
              P := APIDL
            else
              P := NS.Parent.AbsolutePIDL
          end else
          begin
            P := FindBrowseableRootPIDL(NS);
            FreeAndNil(NS);
            NS := TNamespace.Create(PIDLMgr.CopyPIDL(P), nil);
            P := PIDLMgr.StripLastID(P);
            FreePIDL := True
          end
        end
      end;

      // Don't change the rootfolder if it's not necessary
      if not PIDLMgr.EqualPIDL(FRootFolderCustomPIDL, P) then
      begin
        if NS.JunctionPoint then
        begin
          JunctionPtPIDL := nil;
          JunctionPtPath := NS.JunctionPointResolvePath;
          if JunctionPtPath <> '' then
            JunctionPtPIDL := PathToPIDL(JunctionPtPath);
          if Assigned(JunctionPtPIDL) then
            P := JunctionPtPIDL
          else
            P := nil;    
        end;

        if Assigned(P) then
        begin
          OldPIDL := FRootFolderCustomPIDL;
          FRootFolderCustomPIDL := nil;
          RootFolderCustomPIDL := P;
          if Assigned(RootFolderCustomPIDL) then
            PIDLMgr.FreeAndNilPIDL(OldPIDL)
          else
            FRootFolderCustomPIDL := OldPIDL;
        end
      end;

      // If the path was a file then select the file if desired
      if SelectTarget and Assigned(RootFolderCustomPIDL) and (not NS.Folder or FreePIDL) then
      begin
        Selection.ClearAll;
        SelectItem := FindItemByPIDL(NS.AbsolutePIDL);
        if Assigned(SelectItem) then
        begin
          SelectItem.Focused := True;
          SelectItem.Selected := True;
        end;
      end;

      Result := Assigned(RootFolderCustomPIDL) or Browsing;
    end else
      Result := False;
  finally
    NS.Free;
    if FreePIDL then
      PIDLMgr.FreePIDL(P);
  end;
end;

function TCustomVirtualExplorerEasyListview.BrowseToNextLevel: Boolean;
var
  NS: TNamespace;
  PIDL: PItemIDList;
begin
  Result := False;
  if ValidateNamespace(Selection.FocusedItem, NS) then
    if NS.Folder then
    begin
      PIDL := PIDLMgr.CopyPIDL(NS.AbsolutePIDL);
      try
        Result := BrowseToByPIDL(PIDL);
      finally
        PIDLMgr.FreePIDL(PIDL);
      end;
    end
end;

procedure TCustomVirtualExplorerEasyListview.BrowseToPrevLevel;
var
  PIDL: PItemIDList;
begin
  if Assigned(FRootFolderNamespace) then
  begin
    if not FRootFolderNamespace.IsDesktop then
    begin
      PIDL := PIDLMgr.CopyPIDL(FRootFolderNamespace.AbsolutePIDL);
      try
        PIDLMgr.StripLastID(PIDL);
        BrowseToByPIDL(PIDL);
      finally
        PIDLMgr.FreePIDL(PIDL);
      end
    end
  end;
end;

procedure TCustomVirtualExplorerEasyListview.ChangeLinkChanging(Server: TObject;
  NewPIDL: PItemIDList);
{ This method is called when ever we have installed a VETChangeLink to another  }
{ Control.  When the other control changes its selection or root it will send   }
{ this notification.                                                            }
var
  DoBrowse: Boolean;
  Desktop: IShellFolder;
begin
  { Keep from recursively trying to respond to a notify if more than one        }
  { control has been registered with this instance as the client. Once is       }
  { enough and necessary.  VT can get out of wack if you try to call selection  }
  { methods recursively.                                                        }
  if not(vsNotifyChanging in VETStates) and HandleAllocated and Assigned(Parent) then
  begin
    Include(FVETStates, vsNotifyChanging);
    try
      if Assigned(NewPIDL) and Assigned(RootFolderNamespace) and not(csDesigning in ComponentState) then
      begin
        SHGetDesktopFolder(Desktop);
        DoBrowse := ShortInt(Desktop.CompareIDs(0, RootFolderNamespace.AbsolutePIDL, NewPIDL)) <> 0;
        if DoBrowse then
          BrowseToByPIDL(NewPIDL);
      end;
    finally
      Exclude(FVETStates, vsNotifyChanging);
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.ChangeLinkDispatch;
begin
  if not(vsLockChangeNotifier in VETStates) then
  begin
    if Assigned(RootFolderNamespace) and Assigned(VETChangeDispatch) and (not (ebcsDragSelecting in States)) then
      VETChangeDispatch.DispatchChange(Self, RootFolderNamespace.AbsolutePIDL)
  end
end;

procedure TCustomVirtualExplorerEasyListview.ChangeLinkFreeing(ChangeLink: IVETChangeLink);
begin
  if Assigned(ChangeLink) then
  {$IFDEF EXPLORERTREEVIEW_L}
    if (ChangeLink.ChangeLinkClient = Self) and (ChangeLink.ChangeLinkServer = FExplorerTreeview) then
      FExplorerTreeview := nil;
  {$ENDIF}
end;

procedure TCustomVirtualExplorerEasyListview.ContextMenuAfterCmdCallback(Namespace: TNamespace; Verb: WideString; MenuItemID: Integer; Successful: Boolean);
begin
  DoContextMenuAfterCmd(Namespace, Verb, MenuItemID, Successful);
end;

procedure TCustomVirtualExplorerEasyListview.ContextMenuCmdCallback(Namespace: TNamespace; Verb: WideString; MenuItemID: Integer; var Handled: Boolean);
begin
  if Assigned(Owner) then
    Handled := DoContextMenuCmd(Namespace, Verb, MenuItemID)
  else
    Handled := False
end;

procedure TCustomVirtualExplorerEasyListview.ContextMenuShowCallback(Namespace: TNamespace; Menu: hMenu; var Allow: Boolean);

  function IndexIsSeparator(Index: Integer): Boolean;
  var
    MenuInfo: TMenuItemInfo;
  begin
    ZeroMemory(@MenuInfo, SizeOf(MenuInfo));
    MenuInfo.cbSize := SizeOf(MenuInfo);
    MenuInfo.fMask := MIIM_TYPE;
    GetMenuItemInfo(Menu, Index, True, MenuInfo);
    Result :=  MenuInfo.fType and MFT_SEPARATOR  <> 0
  end;

var
  i: Integer;
  S: AnsiString;
  Done: Boolean;

begin
  if Assigned(Owner) then
  begin
    if eloRemoveContextMenuShortCut in Options then
    begin
      Done := False;
      i := 0;
      while not Done and (i < GetMenuItemCount(Menu)) do
      begin
        S := AnsiString(Namespace.ContextMenuVerb(GetMenuItemID(Menu, i)));
        if AnsiStrings.StrComp(PAnsiChar(S), 'link') = 0 then
        begin
          DeleteMenu(Menu, i, MF_BYPOSITION);
          if IndexIsSeparator(i - 1) then
          begin
            if (GetMenuItemCount(Menu) = i) or IndexIsSeparator(i) then
              DeleteMenu(Menu, i - 1, MF_BYPOSITION)
          end;
          Done := True
        end;
        Inc(i)
      end
    end;
    Allow := DoContextMenuShow(Namespace, Menu);
  end else
    Allow := False
end;

procedure TCustomVirtualExplorerEasyListview.CopyToClipboard(AbsolutePIDLs: Integer = 0);
var
  Item: TExplorerItem;
  Handled: Boolean;
begin
  Cursor := crHourglass;
  try
    Handled := False;
    DoClipboardCopy(Handled);
    if not Handled then
    begin
      if AbsolutePIDLs <> 0 then
      begin
        DesktopFolder.Copy(Self, SelectedToNamespaceArray)
      end else
      begin
        Item := TExplorerItem( Selection.First);
        if Assigned(Item) then
          Item.Namespace.Copy(Self, SelectedToNamespaceArray)
      end
    end
  finally
    Cursor := crDefault;
  end
end;

procedure TCustomVirtualExplorerEasyListview.CreateWnd;
begin
  inherited CreateWnd;
  ClipChainWnd := SetClipboardViewer(Handle);
  ChangeNotifierEnabled := eloChangeNotifierThread in Options;
  if Active then
  begin
    RebuildRootNamespace;
    RebuildShellHeader
  end
end;

procedure TCustomVirtualExplorerEasyListview.CutToClipboard(AbsolutePIDLs: Integer = 0);
var
  Item: TExplorerItem;
  Handled, Mark: Boolean;
begin
  Cursor := crHourglass;
  try
    Handled := False;
    Mark := True;
    DoClipboardCut(Mark, Handled);
    if not Handled then
    begin
      if AbsolutePIDLS <> 0 then
      begin
        if DesktopFolder.Cut(Self, SelectedToNamespaceArray) and Mark then
          MarkSelectedCut
      end else
      begin
        Item := TExplorerItem( Selection.First);
        if Assigned(Item) then
        begin
           if Item.Namespace.Cut(Self, SelectedToNamespaceArray) and Mark then
             MarkSelectedCut;
        end
      end
    end else
      if Mark then
        MarkSelectedCut;
  finally
    Cursor := crDefault
  end
end;

procedure TCustomVirtualExplorerEasyListview.DestroyWnd;
begin
  inherited DestroyWnd;
end;

procedure TCustomVirtualExplorerEasyListview.DoColumnClick(Button: TCommonMouseButton; ShiftState: TShiftState; const Column: TEasyColumn);
begin
  inherited DoColumnClick(Button, ShiftState, Column);
end;

procedure TCustomVirtualExplorerEasyListview.DoContextMenu2Message(var Msg: TMessage);
begin
  if Assigned(OnContextMenu2Message) then
    OnContextMenu2Message(Self, Msg)
end;

procedure TCustomVirtualExplorerEasyListview.DoContextMenuAfterCmd(Namespace: TNamespace; Verb: WideString; MenuItemID: Integer; Successful: Boolean);
var
  AVerb: WideString;
begin
  if Assigned(OnContextMenuAfterCmd) then
    OnContextMenuAfterCmd(Self, Namespace, Verb, MenuItemID, Successful);
  if Successful then
  begin
    AVerb := WideLowerCase(Verb);
    if AVerb = 'cut' then
      MarkSelectedCut;
    if AVerb = 'copy' then
      MarkSelectedCopied;
  end
end;

procedure TCustomVirtualExplorerEasyListview.DoContextMenuSelect(Namespace: TNamespace; MenuItemID: Integer; SubMenuID: hMenu; MouseSelect: Boolean);
begin
  if Assigned(OnContextMenuItemChange) then
    OnContextMenuItemChange(Self, Namespace, MenuItemID, SubMenuID, MouseSelect);
end;

procedure TCustomVirtualExplorerEasyListview.DoCustomGroup(Groups: TEasyGroups;
  NS: TNamespace; var Group: TExplorerGroup);
begin
  if Assigned(OnCustomGroup) then
    OnCustomGroup(Self, Groups, NS, Group)
end;

procedure TCustomVirtualExplorerEasyListview.DoEnumFolder(const Namespace: TNamespace; var AllowAsChild: Boolean);
begin
  if Assigned(OnEnumFolder) then
    OnEnumFolder(Self, Namespace, AllowAsChild);
end;

procedure TCustomVirtualExplorerEasyListview.DoHintPopup(TargetObj: TEasyCollectionItem; HintType: TEasyHintType; MousePos: TPoint; var AText: WideString; var HideTimeout: Integer; var ReshowTimeout: Integer; var Allow: Boolean);
var
  R: TRect;
  ACanvas: TCanvas;
  TextSize: TSize;
  Item: TExplorerItem;
begin
  if not ContextMenuShown then
  begin
    inherited DoHintPopup(TargetObj, HintType, MousePos, AText, HideTimeout, ReshowTimeout, Allow);
    if Allow and (AText = '') then
    begin
      if (TargetObj is TExplorerItem) then
      begin
        Item := TExplorerItem(TargetObj);
        if eloQueryInfoHints in Options then
          AText := Item.Namespace.InfoTip;

        ACanvas := TCanvas.Create;
        try
          ACanvas.Handle := GetDC(0);
          R := Item.View.ItemRect(Item, nil, ertText);
          Item.View.LoadTextFont(Item, 0, ACanvas, True);
          TextSize := TextExtentW(Item.Caption, ACanvas);
          if RectWidth(R) < TextSize.cx then
            AText := Item.Namespace.NameInFolder + #13#10 + AText;
        finally
          ReleaseDC(0, ACanvas.Handle);
          ACanvas.Handle := 0;
          ACanvas.Free;
        end
      end;
      Trim(AText);
      Allow := Length(AText) > 0;
    end
  end else
    Allow := False;
end;

procedure TCustomVirtualExplorerEasyListview.DoInvalidRootNamespace;
begin
  if Assigned(OnInvalidRootNamespace) then
    OnInvalidRootNamespace(Self)
end;

procedure TCustomVirtualExplorerEasyListview.DoItemContextMenu(
  HitInfo: TEasyHitInfoItem; WindowPoint: TPoint; var Menu: TPopupMenu;
  var Handled: Boolean);
begin
  inherited DoItemContextMenu(HitInfo, WindowPoint, Menu, Handled);
  if not Handled and (HitInfo.HitInfo * [ehtOnText, ehtOnIcon] <> []) and (eloShellContextMenus in Options) then
  begin
    FContextMenuItem := HitInfo.Item;
    try
      TExplorerItem(HitInfo.Item).Namespace.ShowContextMenuMulti(Self, ContextMenuCmdCallback,
        ContextMenuShowCallback, ContextMenuAfterCmdCallback, SelectedToNamespaceArray, @WindowPoint,
        nil, '', TExplorerItem(HitInfo.Item).Namespace);
      Handled := True
    finally
      FContextMenuItem := nil;
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.DoItemDblClick(Button: TCommonMouseButton;
  MousePos: TPoint; HitInfo: TEasyHitInfoItem);
begin
  inherited DoItemDblClick(Button, MousePos, HitInfo);
  if (Selection.Count = 1) and (Button in Selection.MouseButton) then
    DoShellExecute(Selection.First);
end;

procedure TCustomVirtualExplorerEasyListview.DoItemGetCaption(Item: TEasyItem; Column: Integer; var ACaption: WideString);
var
  NS: TNamespace;
  DetailsOfRequest: TEasyDetailStringsThreadRequest;
  i: Integer;
begin
  if ValidateNamespace(Item, NS) and not (csDestroying in ComponentState) then
  begin
    if (Header.Columns.Count > 0) and (Column < Header.Columns.Count) then
    begin
      if TExplorerColumn( Header.Columns[Column]).IsCustom then
      begin
        DoCustomColumnGetCaption(TExplorerColumn( Header.Columns[Column]), TExplorerItem( Item), ACaption)
      end else
      begin
        if ThreadedDetailsEnabled and (not NS.ThreadedDetailLoaded[Column]) and (not NS.ThreadedDetailLoading[Column]) and (csSlow in RootFolderNamespace.DetailsGetDefaultColumnState(Column)) then
        begin
          DetailsOfRequest := TEasyDetailStringsThreadRequest.Create;
          DetailsOfRequest.AddTitleColumnCaption := True;
          DetailsOfRequest.PIDL := PIDLMgr.CopyPIDL((Item as TExplorerItem).Namespace.AbsolutePIDL);
          DetailsOfRequest.Window := Self;
          SetLength(DetailsOfRequest.FDetailRequest, 1);
          DetailsOfRequest.DetailRequest[0] := Column;
          DetailsOfRequest.Item := Item;
          DetailsOfRequest.AddTitleColumnCaption := False;
          DetailsOfRequest.Priority := 90;
          DetailsOfRequest.ID := TID_DETAILSOF;
          if not Assigned(DetailsOfThread) then
          begin
            DetailsOfThread := TCommonEventThread.Create(True);
            DetailsOfThread.Priority := tpLowest;
            DetailsOfThread.TargetWnd := Handle;
            DetailsOfThread.TargetWndNotifyMsg := WM_DETAILSOF_THREAD;
            DetailsOfThread.Suspended := False;
          end;
          AddDetailsOfRequest(DetailsOfRequest);
          NS.ThreadedDetailLoading[Column] := True;
          ACaption := ''
        end else
        begin
          if NS.ThreadedDetailLoading[Column] then
            ACaption := ''
          else begin
            if Column = ID_SIZE_COLUMN then
            begin
              case FileSizeFormat of
                vfsfDefault: ACaption := NS.DetailsOf(Column);
                vfsfExplorer: ACaption := NS.SizeOfFileKB;
                vfsfActual: ACaption := NS.SizeOfFile;
                vfsfDiskUsage: ACaption := NS.SizeOfFileDiskUsage;
                vfsfText:
                  begin
                    i := 0;
                    while (i < Length(GroupingFileSizeArray)) do
                    begin
                      if GroupingFileSizeArray[i].FileSize > NS.SizeOfFileInt64  then
                      begin
                        ACaption := GroupingFileSizeArray[i].Caption;
                        Exit
                      end;
                      Inc(i);
                    end
                  end
              end;
            end else
              ACaption := NS.DetailsOf(Column);
          end
        end
      end
    end
  end;
  inherited DoItemGetCaption(Item, Column, ACaption);
end;

procedure TCustomVirtualExplorerEasyListview.DoItemGetImageIndex(Item: TEasyItem; Column: Integer; ImageKind: TEasyImageKind; var ImageIndex: TCommonImageIndexInteger);
var
  NS: TNamespace;
  IconRequest: TShellIconThreadRequest;
begin
  if (Column = 0) and ValidateNamespace(Item, NS) and not (csDestroying in ComponentState) then
  begin
    if ThreadedIconsEnabled and (NS.States * [nsThreadedIconLoaded, nsThreadedIconLoading] = []) then
    begin
      IconRequest := TShellIconThreadRequest.Create;
      IconRequest.Window := Self;
      IconRequest.Item := Item;
      IconRequest.ID := TID_ICON;
      // Icons should have the highest Priority
      IconRequest.Priority := 0;
      // Copy anything needed from the Item, NEVER access the Item from the thread
      // use what is copied here to access the data in a thread safe way
      IconRequest.PIDL := PIDLMgr.CopyPIDL(NS.AbsolutePIDL);
      NS.States := NS.States + [nsThreadedIconLoading];
      GlobalThreadManager.AddRequest(IconRequest, True);
    end;

    if (nsThreadedIconLoading in NS.States) then
    begin
      if ImageKind = eikNormal then
      begin
        if NS.IconCache > -1 then
            ImageIndex := NS.IconCache
        else begin
          if NS.Folder and NS.FileSystem then
            ImageIndex := UnknownFolderIconIndex
          else
            ImageIndex := UnknownFileIconIndex;
        end
      end
    end else
    if  (ebcsPrinting in States) and not (ebcsPrintingIcons in States) then
    begin
      // Getting images takes a very long time, don't do it unless the user REALLY wants them
      case ImageKind of
        eikNormal:
          begin
            if NS.Folder and NS.FileSystem then
            ImageIndex := UnknownFolderIconIndex
          else
            ImageIndex := UnknownFileIconIndex;
        end;
        eikOverlay: begin end;
      end;
    end else
      case ImageKind of
        eikNormal: ImageIndex := NS.GetIconIndex(False, icSmall, False);
        eikOverlay: ImageIndex := NS.OverlayIndex;
      end;
  end;

  inherited DoItemGetImageIndex(Item, Column, ImageKind, ImageIndex);
end;

procedure TCustomVirtualExplorerEasyListview.DoItemGetTileDetail(Item: TEasyItem; Line: Integer; var Detail: Integer);
var
  NS: TNamespace;
  TileRequest: TEasyDetailsThreadRequest;
  IntegerArray: TCommonIntegerDynArray;
begin
  if ValidateNamespace(Item, NS) and not(csDestroying in ComponentState) then
  begin
    if ThreadedTilesEnabled and (NS.States * [nsThreadedTileInfoLoaded, nsThreadedTileInfoLoading] = []) then
    begin
      TileRequest := TEasyDetailsThreadRequest.Create;
      TileRequest.Window := Self;
      TileRequest.Item := Item;
      TileRequest.ID := TID_DETAILS;
      TileRequest.Priority := 10;
      SetLength(TileRequest.FDetailRequest, 2);
      TileRequest.DetailRequest[0] := 1;    // Use column 1
      TileRequest.DetailRequest[1] := 2;    // Use column 2
      TileRequest.PIDL := PIDLMgr.CopyPIDL(NS.AbsolutePIDL);
      NS.States := NS.States + [nsThreadedTileInfoLoading];
      GlobalThreadManager.AddRequest(TileRequest, True);
      Detail := 0
    end
    else begin
      if (ebcsPrinting in States) and (NS.States * [nsThreadedTileInfoLoaded] = []) then
      begin
        SetLength(IntegerArray, 2);
        IntegerArray[0] := 1;    // Use column 1
        IntegerArray[1] := 2;    // Use column 2
        NS.TileDetail := IntegerArray;
        PackTileStrings(NS);
        NS.States := (NS.States - [nsThreadedTileInfoLoading]) + [nsThreadedTileInfoLoaded];
      end;
      if Line = 0 then
        Detail := 0
      else
        if (nsThreadedTileInfoLoaded in NS.States) and (Line - 1 < Length(NS.TileDetail)) then
          Detail := NS.TileDetail[Line - 1]
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.DoItemGetTileDetailCount(Item: TEasyItem; var Count: Integer);
var
  NS: TNamespace;
begin
  if ValidateNamespace(Item, NS) then
    Count := Length(NS.TileDetail) + 1;
end;

procedure TCustomVirtualExplorerEasyListview.DoItemSetCaption(Item: TEasyItem; Column: Integer; const Caption: WideString);
begin
  if Column < 1 then
  begin
    TExplorerItem( Item).Namespace.SetNameOf(Caption);
    TExplorerItem( Item).Namespace.InvalidateDetailsOfCache(True);
  end
end;

procedure TCustomVirtualExplorerEasyListview.DoScrollEnd(ScrollBar: TEasyScrollbarDir);
var
  NS: TNamespace;
  ScrollRect: TRect;
  Item: TEasyItem;
  VFF: TValidImageFileFormat;
  ThumbSize: TPoint;
  RectArray: TEasyRectArrayObject;
begin
  if IsThumbnailView and ThumbsManager.UseEndScrollDraw then
  begin
    ScrollRect := Scrollbars.MapWindowRectToViewRect(ClientRect);
    Item := Groups.FirstItemInRect(ScrollRect);
    while Assigned(Item) do
    begin
      if Assigned(FOnBeforeItemThumbnailDraw) then
        FOnBeforeItemThumbnailDraw(Item);

      if ValidateNamespace(Item, NS) then
      begin
        if not ThumbsManager.Updating and (NS.States * [nsThreadedImageLoaded, nsThreadedImageLoading, nsThreadedImageResizing] = []) then
        begin
          Item.View.ItemRectArray(Item, nil, Canvas, Item.Caption, RectArray);
          VFF := ThumbsManager.IsValidImageFileFormat(NS);
          if VFF <> vffInvalid then
          begin
            ThumbSize.X := Max(RectWidth(RectArray.IconRect), ThumbsManager.MaxThumbWidth);
            ThumbSize.Y := Max(RectHeight(RectArray.IconRect), ThumbsManager.MaxThumbHeight);
            Enqueue(NS, Item, ThumbSize, VFF = vffUnknown, False);
          end;
        end
      end;
      Item := Groups.NextItemInRect(Item, ScrollRect);
    end;
  end;

  inherited DoScrollEnd(ScrollBar);
end;

procedure TCustomVirtualExplorerEasyListview.DoItemThumbnailDraw(Item: TEasyItem; ACanvas: TCanvas; ARect: TRect; AlphaBlender: TEasyAlphaBlender; var DoDefault: Boolean);
var
  NS: TNamespace;
  T: TThumbInfo;
  VFF: TValidImageFileFormat;
  ThumbSize, Sz: TPoint;
  ExplorerItem: TExplorerItem;
begin
  if Assigned(FOnBeforeItemThumbnailDraw) then
    FOnBeforeItemThumbnailDraw(Item);
  if ValidateNamespace(Item, NS) then
  begin
    if ThreadedThumbnailsEnabled and not ThumbsManager.Updating and (NS.States * [nsThreadedImageLoaded, nsThreadedImageLoading, nsThreadedImageResizing] = []) then
    begin
      if not ThumbsManager.UseEndScrollDraw
        or (ThumbsManager.UseEndScrollDraw and not (ebcsScrolling in States)) then
      begin
      VFF := ThumbsManager.IsValidImageFileFormat(NS);
      if VFF <> vffInvalid then
      begin
        ThumbSize.X := Max(RectWidth(ARect), ThumbsManager.MaxThumbWidth);
        ThumbSize.Y := Max(RectHeight(ARect), ThumbsManager.MaxThumbHeight);
        Enqueue(NS, Item, ThumbSize, VFF = vffUnknown, False);
        end;
      end;
    end else
    begin
      if (ebcsPrinting in States) and not (nsThreadedImageLoaded in NS.States) then
      begin
        ExplorerItem := TExplorerItem( Item);
        // Force the thumbnail loaded
        ThumbSize.X := Max(RectWidth(ARect), ThumbsManager.MaxThumbWidth);
        ThumbSize.Y := Max(RectHeight(ARect), ThumbsManager.MaxThumbHeight);
        T := SpCreateThumbInfoFromFile(ExplorerItem.Namespace, ThumbSize.X, ThumbSize.Y, True, True, True, True, Color);
        if Assigned(T) then
        try
          if not Assigned(ExplorerItem.ThumbInfo) then
            ExplorerItem.ThumbInfo := TThumbInfo.Create;
          if Assigned(ExplorerItem.ThumbInfo) then
          begin
            ExplorerItem.ThumbInfo.Assign(T);
            ExplorerItem.Namespace.States := ExplorerItem.Namespace.States - [nsThreadedImageLoading, nsThreadedImageResizing] + [nsThreadedImageLoaded]
          end
        finally
          T.Free
        end
      end;
      if (nsThreadedImageLoaded in NS.States) and ValidateThumbnail(Item, T) then
      begin
        ThumbSize.X := Max(RectWidth(ARect), ThumbsManager.MaxThumbWidth);
        ThumbSize.Y := Max(RectHeight(ARect), ThumbsManager.MaxThumbHeight);
        Sz := T.ThumbSize;
        if (T.ImageWidth = 0) or (T.ImageHeight = 0) then
          Sz := T.ThumbSize
        else
          Sz := Point(T.ImageWidth, T.ImageHeight);

        // Do we need to resize the thumbnails?
        // ShellExtracted items will not be resized
        if not (nsThreadedImageResizing in NS.States) and
          (Sz.X < ThumbSize.X) and (Sz.Y < ThumbSize.Y) and
          (Sz.X < T.ImageWidth) and (Sz.Y < T.ImageHeight) then
        begin
          Enqueue(NS, Item, ThumbSize, ThumbsManager.IsValidImageFileFormat(NS) = vffUnknown, True);
        end;

        T.Draw(ACanvas, ARect, ThumbsManager.Alignment, ThumbsManager.Stretch);

        if ShowInactive then
        begin
          ARect := Scrollbars.MapViewRectToWindowRect(ARect, True);
          IntersectRect(ARect, ARect, ClientRect);
          if Color < 0 then
            AlphaBlend(0, ACanvas.Handle, ARect, Point(0, 0), cbmConstantAlphaAndColor, 198, GetSysColor(Color and $000000FF))
          else
            AlphaBlend(0, ACanvas.Handle, ARect, Point(0, 0), cbmConstantAlphaAndColor, 198, Color)
        end;
        DoDefault := False;
      end;
    end;
  end;

  inherited DoItemThumbnailDraw(Item, ACanvas, ARect, AlphaBlender, DoDefault);
end;

procedure TCustomVirtualExplorerEasyListview.DoLoadStorageToRoot(StorageNode: TNodeStorage);
begin
  if Assigned(OnLoadStorageFromRoot) then
    OnLoadStorageFromRoot(Self, StorageNode)
end;

procedure TCustomVirtualExplorerEasyListview.DoKeyAction(var CharCode: Word;
  var Shift: TShiftState; var DoDefault: Boolean);
var
  Item: TEasyItem;
begin
  inherited DoKeyAction(CharCode, Shift, DoDefault);
  if DoDefault then
  begin
    DoDefault := False;
    case CharCode of
      VK_F5:
        begin
          RereadAndRefresh(True);
      //    Rebuild;
      //    RereadAndRefresh(False);
        end;
      VK_BACK:
        BrowseToPrevLevel;
      VK_RETURN:
        begin
          if Selection.Count = 1 then
            DoShellExecute(Selection.First)
          else begin
            Item := Selection.First;
            while Assigned(Item) do
            begin
              // Can't browse into multiple folders
              if not TExplorerItem( Item).Namespace.Folder then
                DoShellExecute(Item);
              Item := Selection.Next(Item)
            end
          end
        end;
      VK_DELETE: SelectedFilesDelete;
      VK_SPACE:
        if Assigned(Selection.FocusedItem) and (Shift * [ssShift, ssAlt] = []) then
          if Selection.FocusedItem.Selected then
            Selection.FocusedItem.Selected := not (ssCtrl in Shift)
          else
            Selection.FocusedItem.Selected := True;
      VK_INSERT:
      begin
        // Lefties favorate keys!
        if ssShift in Shift then
          PasteFromClipboard
        else
        if ssCtrl in Shift then
          CopyToClipboard;
        DoDefault := False
      end;
    else
      DoDefault := True
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.DoNamespaceStructureChange(Item: TExplorerItem; ChangeType: TNamespaceStructureChange);
begin
 
end;

procedure TCustomVirtualExplorerEasyListview.DoOLEDragStart(ADataObject: IDataObject; var AvailableEffects: TCommonDropEffects; var AllowDrag: Boolean);
begin
  if (Selection.Count > 0) and Assigned(RootFolderNamespace) then
  begin
    AvailableEffects := [cdeCopy, cdeMove, cdeLink];
    AllowDrag := True
  end;
  inherited DoOLEDragStart(ADataObject, AvailableEffects, AllowDrag)
end;

procedure TCustomVirtualExplorerEasyListview.DoOLEDropTargetDragDrop(
  DataObject: IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint;
  AvailableEffects: TCommonDropEffects; var DesiredEffect: TCommonDropEffect;
  var Handled: Boolean);
var
  dwEffect: Integer;
begin
  try
    DesiredEffect := cdeNone;
    inherited DoOLEDropTargetDragDrop(DataObject, KeyState, WindowPt, AvailableEffects, DesiredEffect, Handled);
    if DataObjectSupportsShell(DataObject) and not Handled then
    begin
      if Assigned(LastDropTargetNS) then
      begin
        dwEffect := DropEffectStatesToDropEffect(AvailableEffects);
        if Succeeded(LastDropTargetNS.Drop(DataObject, KeyStatesToKey(KeyState), WindowPt, dwEffect)) then
          DesiredEffect := DropEffectToDropEffectState(dwEffect);
      end
    end;
  finally
    LastDropTargetNS := nil;
    DragDataObject := nil;
  end
end;

procedure TCustomVirtualExplorerEasyListview.DoOLEDropTargetDragEnter(DataObject: IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint; AvailableEffects: TCommonDropEffects; var DesiredEffect: TCommonDropEffect);
var
  dwEffect: Integer;
begin
  LastDropTargetNS := nil;
  DesiredEffect := cdeNone;
  if DataObjectSupportsShell(DataObject) then
  begin
    DragDataObject := DataObject;
    // Always start out as the backgound
    LastDropTargetNS := RootFolderNamespace;
    dwEffect := DropEffectStatesToDropEffect(AvailableEffects);
    if Assigned(LastDropTargetNS) then
      LastDropTargetNS.DragEnter(DragDataObject, KeyStatesToKey(KeyState), WindowPt, dwEffect);
    DesiredEffect := DropEffectToDropEffectState(dwEffect)
  end;
  inherited DoOLEDropTargetDragEnter(DataObject, KeyState, WindowPt, AvailableEffects, DesiredEffect);
end;

procedure TCustomVirtualExplorerEasyListview.DoOLEDropTargetDragLeave;
begin
  try
    inherited DoOLEDropTargetDragLeave;
    if DataObjectSupportsShell(DragDataObject) then
    begin
      if Assigned(LastDropTargetNS) then
        LastDropTargetNS.DragLeave;
    end
  finally
    LastDropTargetNS := nil;
    DragDataObject := nil;
  end
end;

procedure TCustomVirtualExplorerEasyListview.DoOLEDropTargetDragOver(KeyState: TCommonKeyStates; WindowPt: TPoint; AvailableEffects: TCommonDropEffects; var DesiredEffect: TCommonDropEffect);
var
  dwEffect: Integer;
begin
  DesiredEffect := cdeNone;
  if DataObjectSupportsShell(DragDataObject) then
  begin
    dwEffect := DropEffectStatesToDropEffect(AvailableEffects);
    if (LastDropTargetNS <> DropTargetNS) then
    begin
      // Leave our last Drop Target
      if Assigned(LastDropTargetNS) then
        LastDropTargetNS.DragLeave;

      // Setup our next Drop Target
      if Assigned(DragManager.DropTarget) then
        LastDropTargetNS := TExplorerItem( DragManager.DropTarget).Namespace
      else
        LastDropTargetNS := RootFolderNamespace;

      if Assigned(LastDropTargetNS) then
      begin
        // Don't let the drag item drop on itself.
        if not DataObjectContainsPIDL(LastDropTargetNS.AbsolutePIDL, DragDataObject) then
          LastDropTargetNS.DragEnter(DragDataObject, KeyStatesToKey(KeyState), WindowPt, dwEffect)
        else
         LastDropTargetNS := nil
      end
    end;
    DesiredEffect := cdeNone;
    if Assigned(LastDropTargetNS) then
      if Succeeded(LastDropTargetNS.DragOver(KeyStatesToKey(KeyState), WindowPt, dwEffect)) then
        DesiredEffect := DropEffectToDropEffectState(dwEffect)
  end;
  inherited DoOLEDropTargetDragOver(KeyState, WindowPt, AvailableEffects, DesiredEffect);
end;

procedure TCustomVirtualExplorerEasyListview.DoOLEGetDataObject(var DataObject: IDataObject);
var
  DataObj: TVirtualEasyListviewDataObject;
  NSA: TNamespaceArray;
  NSList: TList;
begin
  NSA := nil;
  inherited DoOLEGetDataObject(DataObject);
  if not Assigned(DataObject) then
  begin
    if (Selection.Count > 0) and Assigned(RootFolderNamespace) then
    begin
      NSA := SelectedToNamespaceArray;
      DataObj := TVirtualEasyListviewDataObject.Create;
      DataObject := DataObj;
      DataObj.Listview := Self;
      if NSA[0].VerifyPIDLRelationship(NSA, True) then
        DataObj.ShellDataObject := NSA[0].DataObjectMulti(NSA)
      else begin
        DataObj.ShellDataObject := nil;
        NSList := NamespaceToNamespaceList(NSA);
        try
          CreateFullyQualifiedShellDataObject(NSList, ebcsDragging in States,  DataObject);
        finally
          FreeAndNil(NSList)
        end;
      end
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.DoRootChange;
begin
  if Assigned(OnRootChange) then
    OnRootChange(Self);
end;

procedure TCustomVirtualExplorerEasyListview.DoRootChanging(const NewRoot: TRootFolder;
  Namespace: TNamespace; var Allow: Boolean);
begin
  if Assigned(OnRootChanging) then
    OnRootChanging(Self, NewRoot, FRootFolderNamespace, Namespace, Allow);


  if Allow and Assigned(RootFolderNamespace) then
  begin
    // Save the view settings to the Storage (if PerFolderStorage Enabled)
    StoreFolderToPropertyBag(True);
    // Save the one level deep view settings cache for the LoadFolderFromPrevView method
    FreeAndNil(FPrevFolderSettings);
    if Assigned(RootFolderNamespace) then
    begin
      PrevFolderSettings := TNodeStorage.Create(PIDLMgr.CopyPIDL(RootFolderNamespace.AbsolutePIDL), nil);
      SaveRootToStorage(FPrevFolderSettings);
    end;
    if DragManager.Dragging then
    begin
      if Assigned(LastDropTargetNS) then
      begin
        LastDropTargetNS.DragLeave;
        LastDropTargetNS := nil;
      end
    end
  end;

  if Allow and not (csLoading in Componentstate) and Assigned(ThumbsManager) then
    if ThumbsManager.AutoSave then
      ThumbsManager.SaveAlbum;
end;

procedure TCustomVirtualExplorerEasyListview.DoRootRebuild;
begin
  if Assigned(OnRootRebuild) then
    OnRootRebuild(Self)
end;

procedure TCustomVirtualExplorerEasyListview.DoShellExecute(Item: TEasyItem);
{ Fired when the Namespace associated with an Item is to be used as a }
{ ShellExecuteEx parameter.                                           }
var
  NS: TNamespace;
  WorkingDir, CmdLineArgument: WideString;
  Allow, DefaultExecution: Boolean;
  ShellLink: TVirtualShellLink;
  LinkTarget: WideString;
  TempNS: TNamespace;
begin
  if ValidateNamespace(Item, NS) then
  begin
    // Make a copy in case the event changes the root and the item namespace is freed
    TempNS := NS.Clone(True);
    IncrementalSearch.ResetSearch;
    CmdLineArgument := '';
    WorkingDir := '';
    Allow := True;
    if Assigned(OnShellExecute) then
      OnShellExecute(Self, TempNS, WorkingDir, CmdLineArgument, Allow);

    if Allow and TempNS.OkToBrowse(MP_UseModalDialogs) then
    begin
      DefaultExecution := True;
      if TempNS.Folder and (eloBrowseExecuteFolder in Options) then
        if WideStrIComp(PWideChar(TempNS.Extension), '.zip') = 0 then
        begin
          if eloBrowseExecuteZipFolder in Options then
            DefaultExecution := (eloBrowseExecuteZipFolder in Options) and not BrowseToNextLevel // This works because the click has selected the node
          else
            DefaultExecution := eloExecuteOnDblClick in Options;
        end else
          DefaultExecution := not BrowseToNextLevel; // This works because the click has selected the node

      if DefaultExecution and (eloExecuteOnDblClick in Options) then
      begin
        // At this point the Namespace is a shortcut, a file or a folder that can be opened in Windows Explorer
        if TempNS.Link and (eloBrowseExecuteFolderShortcut in Options) then
        begin
          ShellLink := TVirtualShellLink.Create(nil);
          try
            ShellLink.ReadLink(TempNS.NameForParsing);
            LinkTarget := ShellLink.TargetPath;
            if WideDirectoryExists(LinkTarget) then
            begin
              if OkToBrowseTo(ShellLink.TargetIDList) then
                BrowseToByPIDL(ShellLink.TargetIDList);
            end else
              TempNS.ShellExecuteNamespace(WorkingDir, CmdLineArgument, True, True, MP_ThreadedShellExecute)
          finally
            ShellLink.Free;
          end;
        end
        else
          TempNS.ShellExecuteNamespace(WorkingDir, CmdLineArgument, True, True, MP_ThreadedShellExecute)
      end
    end;
    TempNS.Free
  end
end;

procedure TCustomVirtualExplorerEasyListview.DoShellNotify(ShellEvent: TVirtualShellEvent);
begin
  if Assigned(OnShellNotify) then
    OnShellNotify(Self, ShellEvent)
end;

procedure TCustomVirtualExplorerEasyListview.DoThreadCallback(var Msg: TWMThreadRequest);
var
  NS: TNamespace;
  AnItem: TExplorerItem;
begin
  try
    inherited;
    AnItem := TExplorerItem(Msg.Request.Item);
    // this is not efficient but once in a while this will cause a problem
    // that seems like the items did not get flushed from the thread before the
    // list is cleared.  It happens only once is a blue moon.  Can't seem to figure
    // it out.
    if ItemBelongsToList(AnItem) then
    begin
      // DON'T RELEASE THE REQUEST IN THE CALLBACK
      if Assigned(OnThreadCallback) then
        OnThreadCallBack(Self, Msg);
      case Msg.RequestID of
        TID_ICON:
          begin
            if ValidateNamespace(AnItem, NS) then
            begin
              NS.SetIconIndexByThread(TShellIconThreadRequest( Msg.Request).ImageIndex, TShellIconThreadRequest( Msg.Request).OverlayIndex, True);
              Groups.InvalidateItem(AnItem, False);
            end
          end;
        TID_THUMBNAIL:
          begin
            if ValidateNamespace(Msg.Request.Item, NS) then
            begin
              NS.States := (NS.States - [nsThreadedImageLoading]) + [nsThreadedImageLoaded];
              // Clone the ThumbInfo
              if Msg.Request.Tag > 0 then begin
                if not Assigned(AnItem.ThumbInfo) then
                  AnItem.ThumbInfo := TThumbInfo.Create;
                if nsThreadedImageResizing in NS.States then
                  NS.States := NS.States - [nsThreadedImageResizing];
                AnItem.ThumbInfo.Assign(TThumbInfo(Msg.Request.Tag));
                Groups.InvalidateItem(AnItem, False);
              end;
            end;
          end;
        TID_DETAILS:
          begin
            if ValidateNamespace(AnItem, NS) then
            begin
              NS.TileDetail := TCommonIntegerDynArray(TEasyDetailsThreadRequest(Msg.Request).Details);
              PackTileStrings(NS);
              NS.States := (NS.States - [nsThreadedTileInfoLoading]) + [nsThreadedTileInfoLoaded];
              Groups.InvalidateItem(AnItem, False);
            end;
          end;
      end
    end
  finally
    Msg.Request.Release;
  end
end;

function TCustomVirtualExplorerEasyListview.FindItemByPath(Path: WideString): TEasyItem;
var
  PIDL: PItemIDList;
begin
  PIDL := PathToPIDL(Path);
  try
    Result := FindItemByPIDL(PIDL);
  finally
    PIDLMgr.FreePIDL(PIDL);
  end;
end;

function TCustomVirtualExplorerEasyListview.FindItemByPIDL(PIDL: PItemIDList): TExplorerItem;
var
  Item: TExplorerItem;
begin
  Result := nil;
  Item := TExplorerItem( Groups.FirstItem);
  while not Assigned(Result) and Assigned(Item) do
  begin
    if Item.Namespace.ComparePIDL(PIDL, True) = 0 then
      Result := Item;
    Item := TExplorerItem(Groups.NextItem(Item));
  end
end;

procedure TCustomVirtualExplorerEasyListview.ForceIconCachRebuild;
var
  Reg: TRegistry;
  LargeIconSize: integer;
begin
  if not (eloNoRebuildIconListOnAssocChange in Options) then
  begin
    BeginUpdate;
    try
      FELVPersistent.SaveList(Self, True, True);
      Reg := TRegistry.Create;
      try
        try
          { This depends on the user having enough access rights under NT}
          Reg.Access := KEY_READ or KEY_WRITE;
          Reg.RootKey := HKEY_CURRENT_USER;
          if Reg.OpenKey('\Control Panel\Desktop\WindowMetrics', False) then
          begin
            FlushImageLists;
            { Flush the Icon Cache by changing the size of the icons }
            if Reg.ValueExists('Shell Icon Size') then
              LargeIconSize := StrToInt(Reg.ReadString('Shell Icon Size'))
            else
              LargeIconSize := GetSystemMetrics(SM_CXICON);
            Reg.WriteString('Shell Icon Size', IntToStr(LargeIconSize + 1));
            SendMessage(Handle, WM_SETTINGCHANGE, SPI_SETNONCLIENTMETRICS, WPARAM(PChar('WindowMetrics')));
            FileIconInit(True); // Flush the cached Icons
            Reg.WriteString('Shell Icon Size', IntToStr(LargeIconSize));
            SendMessage(Handle, WM_SETTINGCHANGE, SPI_SETNONCLIENTMETRICS, WPARAM(PChar('WindowMetrics')));
            FileIconInit(True); // Flush the cached Icons
          end;
        except // Quiet failure
        end
      finally
        Reg.Free;
        RebuildRootNamespace
      end
    finally
      FELVPersistent.RestoreList(Self, True, True);
      EndUpdate
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.InvalidateImageByIndex(ImageIndex: Integer);
var
  i, j: Integer;
  NS: TNamespace;
begin
  for j := 0 to Groups.Count - 1 do
    for i := 0 to Groups[j].ItemCount - 1 do
    begin
      NS := TExplorerItem( Groups[j][i]).Namespace;
      if (NS.GetIconIndex(False, icSmall, False) = ImageIndex) or
         (NS.GetIconIndex(True, icSmall, False) = ImageIndex) then
      begin
        NS.InvalidateNamespace;
        Groups[j][i].Invalidate(False)
      end
    end
end;

procedure TCustomVirtualExplorerEasyListview.Loaded;
begin
  inherited Loaded;
  Sort.Algorithm := esaMergeSort;
  Sort.Algorithm := esaQuickSort;
  Sort.AutoRegroup := False;
end;

procedure TCustomVirtualExplorerEasyListview.LockChangeNotifier;
begin
  Include(FVETStates, vsLockChangeNotifier);
  Inc(FChangeNotifierCount)
end;

procedure TCustomVirtualExplorerEasyListview.MarkSelectedCopied;
begin
  // Need to define what this means
end;

procedure TCustomVirtualExplorerEasyListview.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
  {$IFDEF EXPLORERTREEVIEW_L}
    if AComponent = ExplorerTreeview then
      ExplorerTreeview := nil;
  {$ENDIF}
  {$IFDEF EXPLORERCOMBOBOX_L}
    if AComponent = ExplorerComboBox then
      ExplorerComboBox := nil;
  {$ENDIF}
    if AComponent = BackGndMenu then
      BackGndMenu := nil;
  end
end;

procedure TCustomVirtualExplorerEasyListview.Notify(var Msg: TMessage);
begin
  if HandleAllocated then
    WMShellNotify(Msg)
end;

procedure TCustomVirtualExplorerEasyListview.PasteFromClipboard;
var
  NSA: TNamespaceArray;
begin
  // Explorer ALWAYS pastes into the current view.
  Cursor := crHourglass;
  try
    if Assigned(RootFolderNamespace) then
    begin
      SetLength(NSA, 1);
      NSA[0] := RootFolderNamespace;
      RootFolderNamespace.Paste(Self, NSA);
    end;
  finally
    Cursor := crDefault
  end
end;

procedure TCustomVirtualExplorerEasyListview.ReadItems(var AnItemArray: TEasyItemArray; Sorted: Boolean; var ValidItemsRead: Integer);
{ Fills the Array with the child nodes if the target node is expanded. The      }
{ array is then sorted  by Name if required with the Quicksort function.  This  }
{ sort appears to be about 20% faster than the Merge sort routine.              }
///
/// NOTE:  Make sure any changes to this method are reflected in both VirtualExplorerTree.pas
//         and VirtualExplorerListview.pas
///
var
  Item: TExplorerItem;
begin
  ValidItemsRead := 0;
  ValidItemsRead := 0;
  SetLength(AnItemArray, Groups.ItemCount);
  Item := TExplorerItem( Groups.FirstItem);
  while Assigned(Item) do
  begin
    AnItemArray[ValidItemsRead] := Item;
    Inc(ValidItemsRead);
    Item := TExplorerItem( Groups.NextItem(Item))
  end;
  SetLength(AnItemArray, ValidItemsRead);
  if Sorted then
  begin
    if Length(AnItemArray) > 0 then
      ItemNamespaceQuickSort(AnItemArray, RootFolderNamespace.ShellFolder, 0, Length(AnItemArray) - 1)
  end
end;

procedure TCustomVirtualExplorerEasyListview.Rebuild(RestoreTopNode: Boolean = False);
var
  Item: TExplorerItem;
begin
  BeginUpdate;
  try
    TerminateDetailsOfThread;
    TerminateEnumThread;
    GlobalThreadManager.FlushAllMessageCache(Self);
    if RestoreTopNode then
    begin
      Item := Groups.FirstItemInRect(Scrollbars.MapWindowRectToViewRect( Rect( 0, 0, ClientWidth, ClientHeight))) as TExplorerItem;
      if Assigned(Item) then
        OldTopNode := PIDLMgr.CopyPIDL(Item.Namespace.AbsolutePIDL)
    end;
    // Store state of listview
    Groups.Clear;
    if not Grouped then
      Groups.AddCustom(GroupClass);

    if Assigned(RootFolderNamespace) and Active then
    begin
      // Setup the global variable for this call as it takes time to do this
      FIENamespaceShown := MPShellUtilities.IENamespaceShown(True);
      if RootFolderNamespace.OkToBrowse(MP_UseModalDialogs) then
      begin
        if (eloThreadedEnumeration in Options) and not (csDesigning in ComponentState) then
        begin
          HandleNeeded;
          EnumThreadStart;
          EnumThread := TVirtualBackGndEnumThread.Create(True,
            eloHideRecycleBin in Options, RootFolderNamespace.AbsolutePIDL,
            FileObjects, Handle, EnumLock, @FEnumBkGndList, @FEnumThread);
          EnumThread.FreeOnTerminate := True;
          EnumThread.Priority := tpLower;
          EnumThread.Suspended := False;
          EnumThreadTimer(True);
        end else
        begin
          // Make sure the window will redraw if a dialog is popped up
          ForcePaint := True;
          try
            Items.ReIndexDisable := True;  // Not sure if this is a bad idea or not but this helps a LOT in performance
            RootFolderNamespace.EnumerateFolderEx(Handle, FileObjects, EnumFolderCallback, nil);
            Items.ReIndexDisable := False;
          finally
            ForcePaint := False;
            EnumThreadFinished(True)
          end
        end
      end
    end
  finally
    CheckForDefaultGroupVisibility;
    EndUpdate(True);
  end;

  DoRootRebuild;
end;

procedure TCustomVirtualExplorerEasyListview.RebuildCategories;
var
  NS: TNamespace;
  DefaultColumnID, pscid: TSHColumnID;
  Category: TGUID;
  WS: WideString;
  EnumGUID: IEnumGUID;
  Fetched, i: UINT;
  NewCategory: TCategory;
  Provider: ICategoryProvider;
  Categorizer: ICategorizer;
  Buffer: array[0..128] of WideChar;
begin
  Category := CLSID_DefCategoryProvider;
  
  NS := RootFolderNamespace;
  Provider := NS.CategoryProviderInterface;
  if Assigned(Provider) then
  begin
    CategoryInfo.Clear;
    Category := GUID_NULL;
    if not Succeeded(Provider.GetDefaultCategory(Category, DefaultColumnID)) then
      DefaultColumnID.fmtid := GUID_NULL;

 //   if not IsEqualGUID(Category, GUID_NULL) then
 //   begin
      Provider.CreateCategory(CLSID_DefCategoryProvider, IID_ICategorizer, Categorizer);
      if Assigned(Categorizer) then
        Categorizer.GetDescription(Buffer, SizeOf(Buffer));
      ZeroMemory(@Buffer, SizeOf(Buffer));
      Provider.CreateCategory(CLSID_AlphabeticalCategorizer, IID_ICategorizer, Categorizer);
      if Assigned(Categorizer) then
        Categorizer.GetDescription(Buffer, SizeOf(Buffer));
      ZeroMemory(@Buffer, SizeOf(Buffer));
      Provider.CreateCategory(CLSID_SizeCategorizer, IID_ICategorizer, Categorizer);
      if Assigned(Categorizer) then
        Categorizer.GetDescription(Buffer, SizeOf(Buffer));
      ZeroMemory(@Buffer, SizeOf(Buffer));
      Provider.CreateCategory(CLSID_DriveTypeCategorizer, IID_ICategorizer, Categorizer);
      if Assigned(Categorizer) then
        Categorizer.GetDescription(Buffer, SizeOf(Buffer));
      ZeroMemory(@Buffer, SizeOf(Buffer));
      Provider.CreateCategory(CLSID_FreeSpaceCategorizer, IID_ICategorizer, Categorizer);
      if Assigned(Categorizer) then
        Categorizer.GetDescription(Buffer, SizeOf(Buffer));
      ZeroMemory(@Buffer, SizeOf(Buffer));
      Provider.CreateCategory(CLSID_DriveSizeCategorizer, IID_ICategorizer, Categorizer);
      if Assigned(Categorizer) then
        Categorizer.GetDescription(Buffer, SizeOf(Buffer));
      ZeroMemory(@Buffer, SizeOf(Buffer));
      Provider.CreateCategory(CLSID_TimeCategorizer, IID_ICategorizer, Categorizer);
      if Assigned(Categorizer) then
        Categorizer.GetDescription(Buffer, SizeOf(Buffer));
      ZeroMemory(@Buffer, SizeOf(Buffer));
      Provider.CreateCategory(CLSID_MergedCategorizer, IID_ICategorizer, Categorizer);
      if Assigned(Categorizer) then
        Categorizer.GetDescription(Buffer, SizeOf(Buffer));
      ZeroMemory(@Buffer, SizeOf(Buffer));
 //   end;

    for i := 0 to Header.Columns.Count - 1 do
    begin
      Category := GUID_NULL;
      if Succeeded(NS.ShellFolder2.MapColumnToSCID(i, pscid)) then
        if Succeeded(Provider.CanCategorizeOnSCID(pscid)) then
          if Succeeded(Provider.GetCategoryForSCID(pscid, Category)) then
          begin
            NewCategory := CategoryInfo.Add;
            NewCategory.FColumnID := pscid;
            NewCategory.FColumn := i;
            NewCategory.FIsDefault := IsEqualGUID(DefaultColumnID.fmtid, pscid.fmtid) and (DefaultColumnID.pid = pscid.pid);
            if IsEqualGUID(GUID_NULL, Category) then
            begin
              // If Category is NULL that means use the "standard" Categorizors
              case i of
                0: CategoryInfo[i].FCategory := CLSID_AlphabeticalCategorizer;
                1: CategoryInfo[i].FCategory := CLSID_SizeCategorizer;
                2: CategoryInfo[i].FCategory := CLSID_DriveTypeCategorizer;
                3: CategoryInfo[i].FCategory := CLSID_TimeCategorizer;
              else
                CategoryInfo[i].FCategory := Category;
              end;
            end else
              CategoryInfo[i].FCategory := Category;
            Category := GUID_NULL   // GetCategoryForSCID won't clear the GUID
          end
    end;
    if Succeeded(Provider.EnumCategories(EnumGUID)) then
    begin
      while EnumGUID.Next(1, Category, Fetched) <> S_FALSE do
      begin
        NewCategory := CategoryInfo.Add;
        NewCategory.FCategory := Category;
        NewCategory.FColumn := -1;
      end
    end;

    for i := CategoryInfo.Count - 1 downto 0 do
    begin
      if not IsEqualGUID(GUID_NULL, CategoryInfo[i].Category) then
      begin
        if IsEqualGUID(CLSID_AlphabeticalCategorizer, CategoryInfo[i].Category) then
          CategoryInfo[i].FCategoryType := ectStandardAlphabetical
        else
        if IsEqualGUID(CLSID_DriveSizeCategorizer, CategoryInfo[i].Category) then
          CategoryInfo[i].FCategoryType := etcStandardDriveSize
        else
        if IsEqualGUID(CLSID_DriveTypeCategorizer, CategoryInfo[i].Category) then
          CategoryInfo[i].FCategoryType := ectStandardDriveType
        else
        if IsEqualGUID(CLSID_FreeSpaceCategorizer, CategoryInfo[i].Category) then
          CategoryInfo[i].FCategoryType := ectStandardFreeSpace
        else
        if IsEqualGUID(CLSID_SizeCategorizer, CategoryInfo[i].Category) then
          CategoryInfo[i].FCategoryType := ectStandardSize
        else
        if IsEqualGUID(CLSID_TimeCategorizer, CategoryInfo[i].Category) then
          CategoryInfo[i].FCategoryType := ectStandardTime
        else
        if IsEqualGUID(CLSID_MergedCategorizer, CategoryInfo[i].Category) then
          CategoryInfo[i].FCategoryType := ectStandardMerged
        else
        if IsEqualGUID(GUID_NULL, CategoryInfo[i].Category) then
          CategoryInfo[i].FCategoryType := ectNoCategory
        else
          CategoryInfo[i].FCategoryType := ectUnknown;

        SetLength(WS, 128);
        if Succeeded(Provider.GetCategoryName(CategoryInfo[i].Category, PWideChar(WS), 128)) then
        begin
          SetLength(WS, lstrlenW(PWideChar(WS)));
          CategoryInfo[i].FName := WS
        end
      end else
        CategoryInfo.Delete(i)
    end
  end else
    CategoryInfo.Clear
end;

procedure TCustomVirtualExplorerEasyListview.RebuildRootNamespace;
{ This will call InitNode for the root which will look at the FRootFolderNamespace }
{ and rebuild with that as its root after clearing the List.                       }
begin
  if not (csLoading in ComponentState) and Assigned(FRootFolderNamespace) and not RebuildingRootNamespace then
  begin
    if Active then
    begin
      BeginUpdate;
      RebuildingRootNamespace := True;
      try
        if Assigned(ThumbsManager) and ThumbsManager.AutoLoad then
          ThumbsManager.BeginUpdate; // Do not allow thread requests when changing the root folder
        try
          PaintInfoGroup.MarginTop.Visible := Grouped;
          Rebuild;
        finally
          if Assigned(ThumbsManager) then
            ThumbsManager.EndUpdate;
        end;
      finally
        EndUpdate;
        ChangeLinkDispatch;
        RebuildingRootNamespace := False;
      end;
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.RebuildShellHeader;

  function ValidIndex(TestIndex: Integer): Boolean;
  begin
    Result := TestIndex <= High(VET_DEFAULT_DRIVES_COLUMNWIDTHS)
  end;

var
  Column: TEasyColumn;
  I: Integer;
  Allow: Boolean;
begin
  if Active then
  begin
    Allow := True;
    DoRebuildingShellHeader(Allow);
    if Allow then
    begin
      BeginUpdate;
      try
        Header.Columns.Clear;
        // Don't worry about FixedSingleColumn as we may need the others
        // to sort on.
        if Assigned(RootFolderNamespace) then
        begin
          for I := 0 to RootFolderNamespace.DetailsSupportedColumns - 1 do
          begin
            Column := Header.Columns.AddCustom(TExplorerColumn, nil);
            Column.AutoToggleSortGlyph := True;
            Column.Caption :=  RootFolderNamespace.DetailsColumnTitle(i);
            Column.Alignment := RootFolderNamespace.DetailsAlignment(i);
            if ValidIndex(Column.Index) then
            begin
              if RootFolderNamespace.IsMyComputer then
                Column.Width := VET_DEFAULT_DRIVES_COLUMNWIDTHS[Column.Index]
              else
              if RootFolderNamespace.IsControlPanel then
                Column.Width := VET_DEFAULT_CONTROLPANEL_COLUMNWIDTHS[Column.Index]
              else
              if (RootFolderNamespace.IsNetworkNeighborhood or
                RootFolderNamespace.IsNetworkNeighborhoodChild) and
                ((RootFolderNamespace.DetailsSupportedColumns < 3)) then
                Column.Width := VET_DEFAULT_NETWORK_COLUMNWIDTHS[Column.Index]
              else begin
                if (Column.Index = 0) then
                begin
                  Column.Width := 0;
                  case View of
                    elsReport:
                      begin
                        if CellSizes.Report.AutoSizeCaption then
                          Column.Width := CellSizes.Report.Width
                      end;
                    elsReportThumb:
                       begin
                        if CellSizes.ReportThumb.AutoSizeCaption then
                          Column.Width := CellSizes.ReportThumb.Width
                       end
                  end;
                  if Column.Width = 0 then
                    Column.Width := VET_ColumnWidths[Column.Index]
                end else
                  Column.Width := VET_ColumnWidths[Column.Index]
              end
            end else
              Column.Width := 120;
            // Some Column Handers return this always and Explorer does not
            // respect that flag
            {$IFDEF ALWAYS_SHOW_ALL_COLUMNS}
            if eloUseColumnOnByDefaultFlag in Options then
              Column.Visible := csOnByDefault in RootFolderNamespace.DetailsGetDefaultColumnState(Column.Index);
            {$ELSE}
            Column.Visible := Column.Index < 4;
            {$ENDIF ALWAYS_SHOW_ALL_COLUMNS}
          end
        end;
        DoCustomColumnAdd;
        TestVisiblilityForSingleColumn;
        UpdateDefaultSortColumnAndSortDir;
        Header.Visible := GetHeaderVisibility;
        DoRebuiltShellHeader;
      finally
        EndUpdate(False)
      end
    end
  end
end;


function TCustomVirtualExplorerEasyListview.RereadAndRefresh(DoSort: Boolean): TEasyItem;
///
/// NOTE:  Make sure any changes to this method are reflected in both VirtualExplorerTree.pas
//         and VirtualExplorerListview.pas
//  Returns the first Item added to the groups if any were added
///
  procedure TestForItemAddThenAdd(PIDL: PItemIDList; NamespaceList: TList);
  var
    Allow: Boolean;
    NewNS: TNamespace;
  begin
    Allow := True;
    NewNS := TNamespace.Create(PIDLMgr.CopyPIDL(PIDL), RootFolderNamespace);
    if ((eloHideRecycleBin in Options) and NewNS.IsRecycleBin) or
       (NewNS.Parent.IsDesktop and (not IENamespaceShown and
       (NewNS.NameForParsing = IE_NAMEFORPARSING))) then
      NewNS.Free
    else begin
      // Need to make sure any additions are ok'ed by the application
      if Assigned(OnEnumFolder) then
        OnEnumFolder(Self, NewNS, Allow);
      // Add it to the bottom of the list
      if Allow then
        NamespaceList.Add(NewNS)
      else
        NewNS.Free;
    end;
  end;

var
  i, j, PIDLsRead, ItemsRead, PIDLArrayLen, ItemArrayLen: Integer;
  PIDLArray: TPIDLArray;
  ItemArray: TEasyItemArray;
  Compare: ShortInt;
  ItemDeleteList, ItemAddList: TList;
  Item: TExplorerItem;
 { NewNS: TNamespace;
  ItemClass: TExplorerItemClass;
  Group: TEasyGroup;    }

begin
  Result := nil;
  if ValidRootNamespace and Active then
  begin
    ItemDeleteList := TList.Create;
    ItemAddList := TList.Create;
    ItemDeleteList.Capacity := Groups.ItemCount; // Assume they will all be deleted
    Sort.LockoutSort := True;
    Selection.IncMultiChangeCount;
    Selection.GroupSelectBeginUpdate;
    try
      // Smarter to read child nodes that are currently cached in the tree
      // first so ReadFolder does not trigger more events
      ReadItems(ItemArray, True, ItemsRead);
      // Need to invalidate namespace as if a new item is added it may not be recognized by
      // the cached IShellFolder!
      RootFolderNamespace.InvalidateNamespace(True);
      ReadFolder(RootFolderNamespace.ShellFolder, FileObjectsToFlags(FileObjects), PIDLArray, True, PIDLsRead);
      BeginUpdate;
      try
        PIDLArrayLen := PIDLsRead;
        ItemArrayLen := ItemsRead;
        j := 0;
        i := 0;
        // Run the current nodes in the tree with the nodes read from the folder in
        // parallel to see what is missing/added
        while (i < PIDLArrayLen) and (j < ItemArrayLen) do
        begin
          Compare := ShortInt(RootFolderNamespace.ShellFolder.CompareIDs(0, PIDLArray[i], TExplorerItem( ItemArray[j]).Namespace.RelativePIDL));
          if Compare = 0 then
          begin
            if eloFullFlushItemsOnChangeNotify in Options then
              TNamespaceHack(TExplorerItem( ItemArray[j]).FNamespace).ReplacePIDL(PIDLArray[i], RootFolderNamespace);
            Inc(j);  // Node exists move on
            Inc(i)
          end else
          if Compare < 0 then
          begin
            TestForItemAddThenAdd(PIDLArray[i], ItemAddList);
            // Must be a new node, don't Inc j
            Inc(i)
          end else
          begin
            // Must be a removed node, don't Inc i
            DoNamespaceStructureChange(TExplorerItem( ItemArray[j]), nscDelete);
            ItemDeleteList.Add(ItemArray[j]);
            Inc(j)
          end
        end;

        // Now delete the Invalid Nodes
        while j < ItemArrayLen do
        begin
          // Must be a removed node, don't Inc i
          DoNamespaceStructureChange(TExplorerItem( ItemArray[j]), nscDelete);
          ItemDeleteList.Add(ItemArray[j]);
          Inc(j)
        end;

        Groups.DeleteItems(ItemDeleteList);

        // Add any new items
        while i < PIDLArrayLen do
        begin
          TestForItemAddThenAdd(PIDLArray[i], ItemAddList);
          Inc(i)
        end;

   (*     ItemDeleteList.Clear;
        Groups.ReIndexDisable := True;
        ItemClass := nil;
        DoExplorerItemClass(ItemClass);
        Group := Groups[0] as TEasyGroup;
        try
          for i := 0 to ItemAddList.Count - 1 do
          begin
            NewNS := TNamespace(ItemAddList[i]);
            if Grouped then
              Group := FindGroup(NewNS) as TExplorerGroup;

            Item := ItemClass.Create(Group.Items);
            if Assigned(Item) then
            begin
              TEasyCollectionHack( Group.Items).List.Add(nil); // Add it directly
              Item.Ghosted := (eloGhostHiddenFiles in Options) and NewNS.Hidden;
              Item.Namespace := NewNS;
              ItemDeleteList.Add(Item);  // Save for later
            end else
              NewNS.Free;
          end
        finally
          Groups.ReIndexDisable := False;
          for i := 0 to ItemAddList.Count - 1 do
          begin
            Item := TExplorerItem( ItemDeleteList[i]);
            TEasyCollectionHack( Group.Items).DoItemAdd(Item, Item.Index);
            DoNamespaceStructureChange(Item, nscAdd);
          end;
          TEasyCollectionHack( Group.Items).DoStructureChange;

        end;  *)

        ItemDeleteList.Clear;
        // I believe this safe.....
        if ItemAddList.Count > 0 then
        begin
          Groups.ReIndexDisable := True;
          for i := 0 to Groups.Count - 1 do
            Groups[i].Items.ReIndexDisable := True;
          try
            for i := 0 to ItemAddList.Count - 1 do
            begin
              Item := AddCustomItem(nil, TNamespace( ItemAddList[i]), True);
              if not Assigned(Result) then
                 Result := Item;
              ItemDeleteList.Add(Item)
            end;
          finally
            Groups.ReIndexDisable := False;
            for i := 0 to Groups.Count - 1 do
              Groups[i].Items.ReIndexDisable := False;

            for i := 0 to ItemAddList.Count - 1 do
              DoNamespaceStructureChange(TExplorerItem( ItemDeleteList[i]), nscAdd);
          end;
        end;


        for i := 0 to Length(PIDLArray) - 1 do
          PIDLMgr.FreePIDL(PIDLArray[i])
      finally
        ItemDeleteList.Free;
        ItemAddList.Free;
        EndUpdate;
        Sort.LockoutSort := False;
        if DoSort then
          Sort.SortAll
      end
    finally
      Selection.DecMultiChangeCount;
      Selection.GroupSelectEndUpdate;
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetActive(Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    TerminateDetailsOfThread;
    TerminateEnumThread;
    GlobalThreadManager.FlushAllMessageCache(Self);
    ActivateTree(Value);
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetAutoSort(const Value: Boolean);
begin
  Sort.AutoSort := Value
end;

procedure TCustomVirtualExplorerEasyListview.SetChangeNotifierEnabled(Value: Boolean);
var
  Msg: TMsg;
  RePostQuitCode: Integer;
  RePostQuit: Boolean;
begin
  if (ComponentState * [csDesigning, csLoading] = [] )and not (csCreating in ControlState) then
  begin
    if Value <> FChangeNotifierEnabled then
    begin
      if Value then
      begin
        if (eloChangeNotifierThread in Options) then
        begin
          ChangeNotifier.RegisterShellChangeNotify(Self);
          FChangeNotifierEnabled := True
        end
      end else
      begin
        RePostQuit := False;
        RePostQuitCode := 0;
        if HandleAllocated then
          // First flush out any pending messages and let them be processed
          while PeekMessage(Msg, Handle, WM_SHELLNOTIFY, WM_SHELLNOTIFY, PM_REMOVE) do
          begin
            if Msg.Message = WM_QUIT then
            begin
              RePostQuit := True;
              RePostQuitCode := Msg.WParam
            end else
            begin
              TranslateMessage(Msg);
              DispatchMessage(Msg)
            end
          end;
          if RePostQuit then
            PostQuitMessage(RePostQuitCode);

        ChangeNotifier.UnRegisterShellChangeNotify(Self);
        FChangeNotifierEnabled := False;
      end
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetDefaultSortColumn(const Value: Integer);
begin
  if FDefaultSortColumn <> Value then
  begin
    // Let the Listview decide if the column is valid when it renders the view
    if Value > -1 then
    begin
      FDefaultSortColumn := Value;
      UpdateDefaultSortColumnAndSortDir;
      Sort.SortAll(False)
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetDefaultSortDir(const Value: TEasySortDirection);
begin
  if FDefaultSortDir <> Value then
  begin
    FDefaultSortDir := Value;
    UpdateDefaultSortColumnAndSortDir;
    Sort.SortAll(False)
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetEnumThread(
  const Value: TVirtualBackGndEnumThread);
begin
  FEnumThread := Value;
end;

{$IFDEF EXPLORERCOMBOBOX_L}

procedure TCustomVirtualExplorerEasyListview.SetExplorerCombobox(Value: TVirtualExplorerCombobox);
begin
  if FExplorerComboBox <> Value then
  begin
    if Assigned(FExplorerComboBox) then
    begin
      VETChangeDispatch.UnRegisterChangeLink(FExplorerComboBox, Self, utLink );
      VETChangeDispatch.UnRegisterChangeLink(Self, FExplorerComboBox, utLink );
    end;
    FExplorerComboBox := Value;
    if Assigned(FExplorerComboBox) then
    begin
      VETChangeDispatch.RegisterChangeLink(FExplorerComboBox, Self, ChangeLinkChanging, ChangeLinkFreeing);
      VETChangeDispatch.RegisterChangeLink(Self, FExplorerComboBox, ExplorerComboBox.ChangeLinkChanging, ExplorerComboBox.ChangeLinkFreeing);
    end
  end;
end;
{$ENDIF}

{$IFDEF EXPLORERTREEVIEW_L}
procedure TCustomVirtualExplorerEasyListview.SetExplorerTreeview(Value: TCustomVirtualExplorerTree);
begin
  if FExplorerTreeview <> Value then
  begin
    if Assigned(FExplorerTreeview) then
    begin
      VETChangeDispatch.UnRegisterChangeLink(FExplorerTreeview, Self, utAll );
      VETChangeDispatch.UnRegisterChangeLink(Self, FExplorerTreeview, utAll );
    end;
    FExplorerTreeview := Value;
    if Assigned(FExplorerTreeview) then
    begin
      VETChangeDispatch.RegisterChangeLink(FExplorerTreeview, Self, ChangeLinkChanging, ChangeLinkFreeing);
      VETChangeDispatch.RegisterChangeLink(Self, FExplorerTreeview, ExplorerTreeview.ChangeLinkChanging, ExplorerTreeview.ChangeLinkFreeing);
    end
  end;
end;
{$ENDIF}

procedure TCustomVirtualExplorerEasyListview.SetExtensionColorCode(const Value: Boolean);
begin
  if FExtensionColorCode <> Value then
  begin
    SafeInvalidateRect(nil, False);
    FExtensionColorCode := Value;
  end;
end;

procedure TCustomVirtualExplorerEasyListview.SetFileObjects(Value: TFileObjects);
begin
  if Value <> FFileObjects then
  begin
    FFileObjects := Value;
    ValidateFileObjects(FFileObjects);
    if not (eloChangeNotifierThread in FOptions) then
      FFileObjects := FFileObjects - [foEnableAsync];   // Need to have change notifier to ensure all data is shown
    SaveRebuildRestoreRootNamespace;
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetFileSizeFormat(const Value: TVirtualFileSizeFormat);
begin
  if FFileSizeFormat <> Value then
  begin
    FFileSizeFormat := Value;
    Invalidate
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetGrouped(Value: Boolean);
begin
  if Value <> FGrouped then
  begin
    BeginUpdate;
    try
      FGrouped := Value;
      SaveRebuildRestoreRootNamespace;
      if QuickFiltered then
        QuickFilter;
      CheckForDefaultGroupVisibility;
      DoGroupingChange;
    finally
      EndUpdate
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetGroupingColumn(Value: Integer);
begin
  if Value <> FGroupingColumn then
  begin
    BeginUpdate;
    try
      FGroupingColumn := Value;
      if Grouped then
        SaveRebuildRestoreRootNamespace;
      if QuickFiltered then
        QuickFilter;
      CheckForDefaultGroupVisibility;
      DoGroupingChange;
    finally
      EndUpdate
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetOptions(Value: TVirtualEasyListviewOptions);
begin
  if (eloHideRecycleBin in Value) xor (eloHideRecycleBin in FOptions) then
  begin
    FOptions := Value;
    SaveRebuildRestoreRootNamespace;
  end else
  if (eloChangeNotifierThread in Value) xor (eloChangeNotifierThread in FOptions) then
  begin
    FOptions := Value;
    ChangeNotifierEnabled := eloChangeNotifierThread in FOptions;
    if IsWinVista then
    begin
      if eloChangeNotifierThread in Value then
        FileObjects := FileObjects + [foEnableAsync]    // Eliminate freezes during enumeration
      else
        FileObjects := FileObjects - [foEnableAsync];    // Eliminate freezes during enumeration
    end
  end else
  begin
    FOptions := Value;
    if eloQueryInfoHints in FOptions then
      ShowHint := True;
    Invalidate;
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetPaintInfoColumn(const Value: TEasyPaintInfoColumn);
begin
  inherited PaintInfoColumn := Value
end;

procedure TCustomVirtualExplorerEasyListview.SetPaintInfoGroup(const Value: TEasyPaintInfoGroup);
begin
  inherited PaintInfoGroup := Value;
end;

procedure TCustomVirtualExplorerEasyListview.SetPaintInfoItem(const Value: TEasyPaintInfoItem);
begin
  inherited PaintInfoItem := Value
end;

procedure TCustomVirtualExplorerEasyListview.SetQuickFiltered(const Value: Boolean);
begin
  if Value <> FQuickFiltered then
  begin
    BeginUpdate;
    try
      FQuickFiltered := Value;
      if not Value then
      begin
        Groups.MakeAllVisible;
      end else
        QuickFilter
    finally
      EndUpdate
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetQuickFilterMask(const Value: WideString);
begin
  if FQuickFilterMask <> Value then
  begin
    BeginUpdate;
    try
      FQuickFilterMask := Value;
      QuickFilter;
    finally
      EndUpdate
    end
  end;
end;

procedure TCustomVirtualExplorerEasyListview.SetRootFolder(Value: TRootFolder);

    function NewRootNamespace(Value: TRootFolder): TNamespace;
    begin
      case Value of
        rfAdminTools: Result := CreateSpecialNamespace(CSIDL_ADMINTOOLS);
        rfAltStartup: Result := CreateSpecialNamespace(CSIDL_ALTSTARTUP);
        rfAppData: Result := CreateSpecialNamespace(CSIDL_APPDATA);
        rfBitBucket: Result := CreateSpecialNamespace(CSIDL_BITBUCKET);
        rfCommonAdminTools: Result := CreateSpecialNamespace(CSIDL_COMMON_ADMINTOOLS);
        rfCommonAltStartup: Result := CreateSpecialNamespace(CSIDL_COMMON_ALTSTARTUP);
        rfCommonAppData: Result := CreateSpecialNamespace(CSIDL_COMMON_APPDATA);
        rfCommonDesktopDirectory: Result := CreateSpecialNamespace(CSIDL_COMMON_DESKTOPDIRECTORY);
        rfCommonDocuments: Result := CreateSpecialNamespace(CSIDL_COMMON_DOCUMENTS);
        rfCommonFavorties: Result := CreateSpecialNamespace(CSIDL_COMMON_FAVORITES);
        rfCommonPrograms: Result := CreateSpecialNamespace(CSIDL_COMMON_PROGRAMS);
        rfCommonStartMenu: Result := CreateSpecialNamespace(CSIDL_COMMON_STARTMENU);
        rfCommonStartup: Result := CreateSpecialNamespace(CSIDL_COMMON_STARTUP);
        rfCommonTemplates: Result := CreateSpecialNamespace(CSIDL_COMMON_TEMPLATES);
        rfControlPanel: Result := CreateSpecialNamespace(CSIDL_CONTROLS );
        rfCookies: Result := CreateSpecialNamespace(CSIDL_COOKIES );
        rfDesktop: Result := CreateSpecialNamespace(CSIDL_DESKTOP);
        rfDesktopDirectory: Result := CreateSpecialNamespace(CSIDL_DESKTOPDIRECTORY);
        rfDrives: Result := CreateSpecialNamespace(CSIDL_DRIVES);
        rfFavorites: Result := CreateSpecialNamespace(CSIDL_FAVORITES);
        rfFonts: Result := CreateSpecialNamespace(CSIDL_FONTS);
        rfHistory: Result := CreateSpecialNamespace(CSIDL_HISTORY);
        rfInternet: Result := CreateSpecialNamespace(CSIDL_INTERNET);
        rfInternetCache: Result := CreateSpecialNamespace(CSIDL_INTERNET_CACHE);
        rfLocalAppData: Result := CreateSpecialNamespace(CSIDL_LOCAL_APPDATA);
        rfMyPictures: Result := CreateSpecialNamespace(CSIDL_MYPICTURES);
        rfNetHood: Result := CreateSpecialNamespace(CSIDL_NETHOOD);
        rfNetwork: Result := CreateSpecialNamespace(CSIDL_NETWORK);
        rfPersonal: Result := CreateSpecialNamespace(CSIDL_PERSONAL);
        rfPrinters: Result := CreateSpecialNamespace(CSIDL_PRINTERS);
        rfPrintHood: Result := CreateSpecialNamespace(CSIDL_PRINTHOOD);
        rfProfile: Result := CreateSpecialNamespace(CSIDL_PROFILE);
        rfProgramFiles: Result := CreateSpecialNamespace(CSIDL_PROGRAM_FILES);
        rfCommonProgramFiles: Result := CreateSpecialNamespace(CSIDL_PROGRAM_FILES_COMMON);
        rfPrograms: Result := CreateSpecialNamespace(CSIDL_PROGRAMS);
        rfRecent: Result := CreateSpecialNamespace(CSIDL_RECENT);
        rfSendTo: Result := CreateSpecialNamespace(CSIDL_SENDTO);
        rfStartMenu: Result := CreateSpecialNamespace(CSIDL_STARTMENU);
        rfStartUp: Result := CreateSpecialNamespace(CSIDL_STARTUP);
        rfSystem: Result := CreateSpecialNamespace(CSIDL_SYSTEM);
        rfTemplate: Result := CreateSpecialNamespace(CSIDL_TEMPLATES);
        rfWindows: Result := CreateSpecialNamespace(CSIDL_WINDOWS);
        rfCustom: Result := TNamespace.Create(PathToPIDL(RootFolderCustomPath), nil);
        rfCustomPIDL: Result := TNamespace.Create(PIDLMgr.CopyPIDL(RootFolderCustomPIDL), nil);
      else
        Result := nil;
      end;
    end;

var
  Allow: Boolean;
  OldOffsetY: Integer;
begin
  Allow := True;
  { This has already been handled in the setters for a custom PIDL or custom Path }
  if (Value <> rfCustomPIDL) and (Value <> rfCustom) then
  begin
    TempRootNamespace := NewRootNamespace(Value);
    DoRootChanging(Value, TempRootNamespace, Allow);
  end;
  try
    if Allow then
    begin
      BeginUpdate;
      GlobalThreadManager.FlushAllMessageCache(Self);
      TerminateEnumThread;
      TerminateDetailsOfThread;
      Selection.GroupSelectBeginUpdate;
      try
        Groups.Clear;
        FRootFolder := Value;
        if not (Value = rfCustom) then
          FRootFolderCustomPath := '';
        if not (Value = rfCustomPIDL) then
          PIDLMgr.FreeAndNilPIDL(FRootFolderCustomPIDL);
        FreeAndNil(FRootFolderNamespace);

        { TempRootNamespace was created in the property setters for the custom  }
        { path and pidl selections.                                             }
        FRootFolderNamespace := TempRootNamespace;
        TempRootNamespace := nil;
        if Assigned(FRootFolderNamespace) then
          RebuildRootNamespace;
      finally
        EndUpdate;
        Selection.GroupSelectEndUpdate;
      end;

      OldOffsetY := Scrollbars.OffsetY;
      RebuildShellHeader;
      Scrollbars.OffsetY := OldOffsetY;
      LoadAllThumbs;
      LoadFolderFromPropertyBag;
      DoRootChange;
    end;
  finally
    { Always clean up the property }
    FreeAndNil(FTempRootNamespace);
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetRootFolderCustomPath(Value: WideString);
var
  Allow: Boolean;
  CustomPath: WideString;
begin
 // if Value <> FRootFolderCustomPath then
  begin
    Allow := True;
    if Value <> '' then
      CustomPath := IncludeTrailingBackslashW(Value)
    else
      CustomPath := Value;

    TempRootNamespace := TNamespace.Create(PathToPIDL(CustomPath), nil);
    try
      DoRootChanging(rfCustom, TempRootNamespace, Allow);
      if Allow then
      begin
        if WideDirectoryExists(CustomPath) then
        begin
          TerminateEnumThread;
          TerminateDetailsOfThread;
          FRootFolderCustomPath := CustomPath;
          { TempRootNamespace will be used in RootFolder Setter }
          RootFolder := rfCustom;
        end
      end
    finally
      { If all goes well this should be nil after returning from RootFolder :=    }
      { but in case.                                                              }
      FreeAndNil(FTempRootNamespace);
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetRootFolderCustomPIDL(Value: PItemIDList);
var
  Allow: Boolean;
begin
  if Assigned(Value) then
  begin
    BeginUpdate;
    try
      if not Assigned(FRootFolderCustomPIDL) or not (ILIsEqual(RootFolderNamespace.AbsolutePIDL, Value)) then
      begin
        Allow := True;
        TempRootNamespace := TNamespace.Create(PIDLMgr.CopyPIDL(Value), nil);
        try
          DoRootChanging(rfCustomPIDL, TempRootNamespace, Allow);
          if Allow then
          begin
            TerminateEnumThread;
            TerminateDetailsOfThread;
            if FRootFolderCustomPIDL <> Value then
            begin
              PIDLMgr.FreeAndNilPIDL(FRootFolderCustomPIDL);
              FRootFolderCustomPIDL := PIDLMgr.CopyPIDL(Value);
              { TempRootNamespace will be used in RootFolder Setter }
              RootFolder := rfCustomPIDL
            end
          end
        finally
          { If all goes well this should be nil after returning from RootFolder :=    }
          { but in case.                                                              }
          FreeAndNil(FTempRootNamespace);
          QuickFilter
        end
      end
    finally
      EndUpdate;
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetSelection(Value: TEasyVirtualSelectionManager);
begin
  inherited Selection := Value
end;

procedure TCustomVirtualExplorerEasyListview.SetSortFolderFirstAlways(const Value: Boolean);
begin
  if FSortFolderFirstAlways <> Value then
  begin
    FSortFolderFirstAlways := Value;
    if Grouped then
      SaveRebuildRestoreRootNamespace;
  end
end;

procedure TCustomVirtualExplorerEasyListview.SetStorage(const Value: TRootNodeStorage);
begin
  FStorage := Value;
end;

procedure TCustomVirtualExplorerEasyListview.SetView(Value: TEasyListStyle);
begin
  if Value <> View then
  begin
    inherited SetView(Value);
    RebuildShellHeader;
    Header.Visible := GetHeaderVisibility;
  end
end;

procedure TCustomVirtualExplorerEasyListview.ShowAnimateFolderWnd;
begin
  if not Assigned(AnimateFolderEnum) then
  begin
    Header.Visible := False;
    AnimateFolderEnum := TAnimate.Create(Parent);
    AnimateFolderEnum.Visible := False;
    AnimateFolderEnum.Parent := GetAnimateWndParent;
    AnimateFolderEnum.Align := alClient;
    AnimateFolderEnum.CommonAVI := aviFindFolder;
    AnimateFolderEnum.Visible := True;
    AnimateFolderEnum.Active := True;
    AnimateFolderEnum.Invalidate;
  end
end;

procedure TCustomVirtualExplorerEasyListview.SortList;
begin
  Sort.SortAll(True)
end;

procedure TCustomVirtualExplorerEasyListview.StoreFolderToPropertyBag(Force: Boolean; IgnoreOptions: Boolean = False);
//
// Stores the current view settings to the Storage object IF the eloPerFolderStorage
// flag is set.  The Storage can be the locally allocated Storage object or
// a custom Storage object by overriding the OnGetStorage event (or override DoGetStorage event)
//
var
  StorageNode: TNodeStorage;
begin
  if Assigned(RootFolderNamespace) and Assigned(Storage) and (IgnoreOptions or (eloPerFolderStorage in Options)) then
  begin
    if Force then
      StorageNode := Storage.Store(RootFolderNamespace.AbsolutePIDL, [stGrouping, stColumns])
    else
      StorageNode := Storage.Find(RootFolderNamespace.AbsolutePIDL, [stGrouping, stColumns]);
    SaveRootToStorage(StorageNode);
  end
end;

procedure TCustomVirtualExplorerEasyListview.SaveRootToStorage(StorageNode: TNodeStorage);
//
// Copies the current view settings of the control to the passed StorageNode.
// To copy a saved StorageNode to the control see LoadStorageToRoot
var
  i: Integer;
begin
  if Assigned(StorageNode) then
  begin
    StorageNode.Storage.Grouping.View := Integer(View);
    StorageNode.Storage.Grouping.Enabled := Grouped;
    StorageNode.Storage.Grouping.GroupColumn := GroupingColumn;
    if Assigned(Selection.FocusedColumn) then
      StorageNode.Storage.Column.SortDir := Integer( Selection.FocusedColumn.SortDirection)
    else
      StorageNode.Storage.Column.SortDir := Integer(esdNone);
    SetLength(StorageNode.Storage.Column.Position, Header.Columns.Count);
    SetLength(StorageNode.Storage.Column.Visible, Header.Columns.Count);
    SetLength(StorageNode.Storage.Column.Width, Header.Columns.Count);
    for i := 0 to Header.Columns.Count - 1 do
    begin
      if Header.Columns[i].SortDirection <> esdNone then
      begin
        StorageNode.Storage.Column.SortColumn := i;
        StorageNode.Storage.Column.SortDir := Integer(Header.Columns[i].SortDirection);
      end;
      StorageNode.Storage.Column.Visible[i] := Header.Columns[i].Visible;
      StorageNode.Storage.Column.Position[i] := Header.Columns[i].Position;
      StorageNode.Storage.Column.Width[i] := Header.Columns[i].Width;
    end;
    DoSaveRootToStorage(StorageNode)
  end;
end;

procedure TCustomVirtualExplorerEasyListview.TerminateDetailsOfThread;
begin
  OrphanThreadsFree;
  if Assigned(DetailsOfThread) then
  begin
    DetailsOfThread.Terminate;
    FlushDetailsOfThread;
    DetailsOfThread.TriggerEvent;
    OrphanThreadList.Add(DetailsOfThread);
    DetailsOfThread := nil;
  end
end;

procedure TCustomVirtualExplorerEasyListview.TerminateEnumThread;
begin
  try
    EnterCriticalSection(FEnumLock);
    if Assigned(EnumThread) then
    try
      EnumThread.Terminate;
      EnumThread.FlushRequestList;
    finally
      EnumThread := nil;
    end;
    EnumThreadTimer(False);
    HideAnimateFolderWnd;
    FreeAndNil(FEnumBkGndList);
  finally
    LeaveCriticalSection(FEnumLock)
  end
end;

procedure TCustomVirtualExplorerEasyListview.TestVisiblilityForSingleColumn;
var
  i: Integer;
begin
  if (Header.FixedSingleColumn and (View = elsReport)) then
  begin
    BeginUpdate;
    try
      for i := 0 to Header.Columns.Count - 1 do
        Header.Columns[i].Visible := i < 1
    finally
      EndUpdate(True)
    end
  end
end;

procedure TCustomVirtualExplorerEasyListview.UpdateColumnsFromDialog(VST: TVirtualStringTree);
var
  LocalColData: PColumnData;
  i: integer;
  LocalChildNode: PVirtualNode;
begin
  BeginUpdate;
  try
    i := 0;
    { Reposition columns based on order of Tree nodes and update data }
    LocalChildNode := VST.GetFirst;
    while Assigned(LocalChildNode) do
    begin
      LocalColData := VST.GetNodeData(LocalChildNode);
      Header.Columns[LocalColData.ColumnIndex].Position := i;
      Header.Columns[LocalColData.ColumnIndex].Visible := LocalColData.Enabled;
      Header.Columns[LocalColData.ColumnIndex].Width := LocalColData.Width;
      LocalChildNode := LocalChildNode.NextSibling;
      Inc(i)
    end;
  finally
    EndUpdate
  end
end;

procedure TCustomVirtualExplorerEasyListview.UpdateDefaultSortColumnAndSortDir;
begin
  if Header.Columns.Count > 0 then
  begin
    if (DefaultSortColumn > -1) and (DefaultSortColumn < Header.Columns.Count) then
    begin
      Selection.FocusedColumn := Header.Columns[DefaultSortColumn];
      if DefaultSortDir <> esdNone then
        Selection.FocusedColumn.SortDirection := DefaultSortDir
    end
    else
      Selection.FocusedColumn := Header.Columns[0]
  end;
end;

procedure TCustomVirtualExplorerEasyListview.WMChangeCBChain(var Msg: TMessage);
var
  RemovedWnd, NextWnd: HWnd;
begin
  RemovedWnd := Msg.WParam;
  NextWnd := Msg.LParam;
  if RemovedWnd = ClipChainWnd then
    ClipChainWnd := NextWnd    // If it's our "next guy", then re-adjust the next guy pointer
  else
    SendMessage(ClipChainWnd, WM_CHANGECBCHAIN, RemovedWnd, NextWnd); // else just pass the remove notice along
  Msg.Result := 0;   {we handled it}
end;

procedure TCustomVirtualExplorerEasyListview.WMContextmenu(var Msg: TMessage);
begin
  FContextMenuShown := True;
  try
    inherited
  finally
    FContextMenuShown := False
  end
end;

procedure TCustomVirtualExplorerEasyListview.WMCreate(var Msg: TMessage);
begin
  ShellNotifyManager.RegisterExplorerWnd(Self);
  inherited;
end;

procedure TCustomVirtualExplorerEasyListview.WMDetailsOfThread(var Msg: TWMThreadRequest);
var
  AnItem: TExplorerItem;
  NS: TNamespace;
  Column: Integer;
begin
  inherited;
  AnItem := TExplorerItem(Msg.Request.Item);
  if ValidateNamespace(AnItem, NS) then
  begin
    Column := TEasyDetailStringsThreadRequest(Msg.Request).DetailRequest[0];
    NS.SetDetailByThread(Column, TEasyDetailStringsThreadRequest(Msg.Request).Details[0]);
    Groups.InvalidateItem(AnItem, False);
    // Not referenced counted in this case
    Msg.Request.Free
  end
end;

procedure TCustomVirtualExplorerEasyListview.WMDrawClipboard(var Msg: TMessage);
begin
  if Assigned(OnClipboardChange) then
    OnClipboardChange(Self);
  SendMessage(ClipChainWnd, WM_DRAWCLIPBOARD, Msg.WParam, Msg.LParam);
  Msg.Result := 0;
end;

procedure TCustomVirtualExplorerEasyListview.WMDrawItem(var Msg: TWMDrawItem);
begin
  inherited;
  DoContextMenu2Message(TMessage(Msg))
end;

procedure TCustomVirtualExplorerEasyListview.WMInitMenuPopup(var Msg: TWMInitMenuPopup);
begin
  inherited;
  DoContextMenu2Message(TMessage(Msg))
end;

procedure TCustomVirtualExplorerEasyListview.WMKeyDown(var Msg: TWMKeyDown);
begin
  inherited;
end;

procedure TCustomVirtualExplorerEasyListview.WMMeasureItem(var Msg: TWMMeasureItem);
begin
  inherited;
  DoContextMenu2Message(TMessage(Msg))
end;

procedure TCustomVirtualExplorerEasyListview.WMMenuSelect(var Msg: TWMMenuSelect);
var
  ChildMenu: hMenu;
begin
  if Assigned(ContextMenuItem) then
  begin
    if HiWord(Longword( TMessage( Msg).wParam)) and MF_POPUP <> 0 then
      ChildMenu := GetSubMenu(LongWord( TMessage( Msg).lParam), LoWord(Longword( TMessage( Msg).wParam)))
    else
      ChildMenu := 0;
    DoContextMenuSelect((ContextMenuItem as TExplorerItem).Namespace, LoWord(Longword( TMessage( Msg).wParam)), ChildMenu,
      HiWord(Longword( TMessage( Msg).wParam)) and MF_MOUSESELECT <> 0);
  end
end;

procedure TCustomVirtualExplorerEasyListview.WMNCDestroy(var Msg: TMessage);
begin
  TerminateEnumThread;
  TerminateDetailsOfThread;
  GlobalThreadManager.FlushAllMessageCache(Self);
  ShellNotifyManager.UnRegisterExplorerWnd(Self);
  ChangeNotifierEnabled := False;
  ChangeClipboardChain(Handle, ClipChainWnd);
  inherited;
end;

procedure TCustomVirtualExplorerEasyListview.WMShellNotify(var Msg: TMessage);
{ WinZip does not follow the rules when creating a zip file.  It sends an       }
{ UpdateDir eventhough it really has not created the file yet!  Once you add    }
{ the new files to the zip it sends an UpdateItem to the file it did not create }
{ yet.  It appears it is sending the UpdateItem instead of the CreateItem like  }
{ the documentation clearly states.  This is WinZip 8.0.                        }

///
/// NOTE:  Make sure any changes to this method are reflected in both VirtualExplorerTree.pas
//         and VirtualExplorerListview.pas
///

var
  Count: integer;
  Item: TExplorerItem;
  ShellEventList: TVirtualShellEventList;
  ShellEvent: TVirtualShellEvent;
  i: integer;
  NS: TNamespace;
  S: string;
  WS: WideString;
  MappedDriveNotification: Boolean;
  List: TList;
  PIDL: PItemIDList;
  Flags: LongWord;
  ValidNS, WasSelected, WasFocused: Boolean;
begin
  if ValidRootNamespace then
  begin
    try
      {$IFDEF GXDEBUG_SHELLNOTIFY}
      SendDebug('  ');
      SendDebug('.........................................');
      SendDebug('............. New Message ...............');
      SendDebug('WM_SHELLNOTIFY');
      {$ENDIF}
      if not ShellNotifyManager.OkToDispatch then
      begin
        {$IFDEF GXDEBUG_SHELLNOTIFY}
        SendDebug('Resending Packet.....................');
        {$ENDIF}
        ShellNotifyManager.ReDispatchShellNotify(TVirtualShellEventList( Msg.wParam));
      end else
      begin
        {$IFDEF GXDEBUG_SHELLNOTIFY}
        SendDebug('Processing Packet.....................');
        {$ENDIF}
        ShellEventList := TVirtualShellEventList( Msg.wParam);
        List := ShellEventList.LockList;
        try
          // Put the Rename's in the front of the list so we don't rebuild and loose the old item
          List.Sort(ShellEventSort);
          try
            if Active then
            begin
              ValidNS := True;
              Count := List.Count;
              for i := 0 to Count - 1 do
              begin
                if ValidNS then
                begin
                  MappedDriveNotification := False;
                  ShellEvent := TVirtualShellEvent(List.Items[i]);

                  DoShellNotify(ShellEvent);
                  if not(ShellEvent.Handled) then
                  begin
                    // Mapped network drive get an UpdateDir for any event(s) on the drive
                    // keeps from being swamped with notifications from other machines
                    if (eloTrackChangesInMappedDrives in Options) and
                       (ShellEvent.ShellNotifyEvent in [vsneUpdateDir]) then
                    begin
                      NS := TNamespace.Create(ShellEvent.PIDL1, nil);
                      NS.FreePIDLOnDestroy := False;
                      if NS.Folder then
                      begin
                        if IsUnicode then
                        begin
                          WS := WideExtractFileDrive(NS.NameForParsing);
                          MappedDriveNotification := WideIsDrive(WS) and (GetDriveTypeW_MP(PWideChar(WS)) = DRIVE_REMOTE)
                        end else
                        begin
                          S := ExtractFileDrive(NS.NameForParsing);
                          MappedDriveNotification := WideIsDrive(S) and (GetDriveType(PChar(S)) = DRIVE_REMOTE)
                        end;
                        if MappedDriveNotification and IsRootNamespace(ShellEvent.PIDL1) then
                          RereadAndRefresh(False);
                      end;
                      NS.Free
                    end;


                    {$IFDEF GXDEBUG_SHELLNOTIFY}
                    SendDebug('Event: ' + VirtualShellNotifyEventToStr(ShellEvent.ShellNotifyEvent));
                    {$ENDIF}


                    if not MappedDriveNotification then
                    begin
                      case ShellEvent.ShellNotifyEvent of
                        // The notification thread maps these to UpdateDir notifications
                        vsneCreate,           // Creating a File
                        vsneDelete,           // Deleting a File
                        vsneMkDir,            // Creating a Directory
                        vsneRmDir:            // Deleting a Directory
                          begin
                          // It is now possible to recieve all the notification raw
                          // Don't expect the change notifictaions to work right but
                          // it is now possible
                          //  Assert(True=False, 'Unexpected Shell Notification');
                          end;

                        // Both PIDLs in the Rename notifications are valid. The thread ensures
                        // that these are truly renames and not moves so we don't have to check
                        // here.  (NT4 calls a move a Rename) The thread checks the parent PIDL
                        // and if they are different then it must be a move and it maps both
                        // directories to UpdateDir events. If it makes it here it means that
                        // the parent pidls of bother items/folders are the same and it is a true
                        // rename.
                        vsneRenameFolder,
                        vsneRenameItem:
                          begin
                            // We have already filtered out move operations that fire this so
                            //  it is for sure this is a pure rename so handle it as a special case

                            // Find the old node
                            Item := FindItemByPIDL(ShellEvent.PIDL1);
                            if Assigned(Item) then
                            begin
                              WasSelected := Item.Selected;
                              WasFocused := Item.Focused;
                              RereadAndRefresh(False);
                              Item := FindItemByPIDL(ShellEvent.PIDL2);
                              if Assigned(Item) then
                              begin
                                Item.Selected := WasSelected;
                                Item.Focused := WasFocused;
                                Item.MakeVisible(emvAuto);
                              end
                            end else
                              RereadAndRefresh(False)
                          end;

                        vsneDriveAdd,         // Mapping a network drive
                        vsneDriveAddGUI,      // CD inserted shell should create new window
                        vsneDriveRemoved:     // UnMapping a network drive
                          begin
                            if IsRootNamespace(ShellEvent.ParentPIDL1) then
                              RereadAndRefresh(False)
                          end;
                        vsneMediaInserted,    // New CD, Jazz Drive, Memory card etc. inserted.
                        vsneMediaRemoved:     // New CD, Jazz Drive, Memory card etc. removed
                          begin
                            // M$ Hack to get Win9x to change the image and name of removable
                            // drives when the media changes
                            NS := TNamespace.Create(ShellEvent.PIDL1, nil);
                            NS.FreePIDLOnDestroy := False;
                            PIDL := NS.RelativePIDL;
                            Flags := SFGAO_VALIDATE;
                            NS.ParentShellFolder.GetAttributesOf(0, PIDL, Flags);
                            try
                              if IsRootNamespace(ShellEvent.ParentPIDL1) then
                                RereadAndRefresh(False)
                            finally
                              NS.Free
                            end;
                          end;
                        // A lot of the different notifications are mapped to this event in
                        // the thread. This minimizes the number of times we have to refresh
                        // the tree.
                        vsneUpdateDir:
                          begin
                            if Assigned(ShellEvent.PIDL1) then
                            begin
                              if not ShellEvent.InvalidNamespace then
                              begin
                                {$IFDEF GXDEBUG_SHELLNOTIFY}
                                NS := TNamespace.Create(ShellEvent.PIDL1, nil);
                                NS.FreePIDLOnDestroy := False;
                                SendDebug('Event: ' + NS.NameForParsing);
                                NS.Free;
                                {$ENDIF}

                                if IsRootNamespace(ShellEvent.PIDL1) then
                                  RereadAndRefresh(False)
                              end else
                              begin
                                {$IFDEF GXDEBUG_SHELLNOTIFY}
                                SendDebug('ShellEvent.InvalidNamespace = True');
                                {$ENDIF}
                              end;
                            end else
                            begin
                              {$IFDEF GXDEBUG_SHELLNOTIFY}
                              SendDebug('PIDL1 was nil...');
                              {$ENDIF}
                            end
                          end;

                        // This notification is sent when a namespace has been mapped to a
                        // different image.
                        vsneUpdateImage:   // New image has been mapped to the item
                          begin
                            FlushImageLists;
                            InvalidateImageByIndex(Integer(ShellEvent.DoubleWord1));
                          end;

                        { This group of notifications is based on an existing namespace that   }
                        { has had its properties changed.  As such the PIDL must be refreshed  }
                        { to read in the new properties stored in the PIDL.                    }
                        vsneNetShare,         // Folder being shared or unshared
                        vsneNetUnShare,       //  ?? Should be the opposite of NetShare
                        vsneServerDisconnect,
                        vsneUpdateItem:       // Properties of file OR dir changed }
                          begin
                            Item := FindItemByPIDL(ShellEvent.PIDL1);
                            if Assigned(Item) then
                            begin
                              NS := Item.Namespace;
                             {$IFDEF GXDEBUG_SHELLNOTIFY}
                              SendDebug('Event: ' + NS.NameForParsing);
                              {$ENDIF}
                              { Must flush the PIDL since it stores info used in the details   }
                              NS.InvalidateRelativePIDL(FileObjects);
                              Item.Invalidate(True)
                            end
                          end;
                        vsneAttributes:       // Printer properties changed and ???
                          begin
                            Item := FindItemByPIDL(ShellEvent.PIDL1);
                            if Assigned(Item) then
                            begin
                              NS := Item.Namespace;
                              { Must flush the PIDL since it stores info used in the details   }
                              NS.InvalidateRelativePIDL(FileObjects);
                              Item.Invalidate(True)
                            end
                          end;
                        { This notification is sent when the freespace on a drive has changed. }
                        { for now it appears the only thing this may impact is the disk size   }
                        { details under MyComputer.  Don't update the image as it should be    }
                        { same.                                                                }
                        vsneFreeSpace:
                          begin
                            // Reports of installers folder creation not sending
                            // folder updates but do get FreeSpace change updates.
                            // Not sure if this is a good idea yet.  need to test
                     //       if RootFolderNamespace.IsMyComputer then
                              RereadAndRefresh(False)
                          end;
                        { This notification is sent when the shell has changed an assocciation }
                        { of a file type.                                                      }
                        vsneAssoccChanged:  // File association changed need new images
                          begin
                            ForceIconCachRebuild;
                          end
                      end
                    end
                  end; // Handled
                  DoAfterShellNotify(ShellEvent);   
                end
              end
            end
          except
            // The shell sometimes sends bogus PIDLs (likely applications with bugs sending bad PIDLs with SHChangeNotify)
          end
        finally
          ShellEventList.UnlockList;
          ShellEventList.Release;
        end
      end
    except
      raise
    end
  end else
    TVirtualShellEventList( Msg.wParam).Release;
end;

procedure TCustomVirtualExplorerEasyListview.WMSysChar(var Msg: TWMSysChar);
begin 
  case Msg.CharCode of
    VK_RETURN:
      begin
        if (Msg.CharCode = VK_RETURN) then
          SelectedFilesShowProperties
      end
    else   // Stop the beep
      inherited
  end
end;

procedure TCustomVirtualExplorerEasyListview.WMTimer(var Msg: TWMTimer);
var
  ShowAnimation: Boolean;
  i: Integer;
  Allow: Boolean;
  NS: TNamespace;
  LocalList:  TCommonPIDLList;
begin
  inherited;
  if (Msg.TimerID = ID_TIMER_ENUMBKGND)then
  begin
    BeginUpdate;
    try
      Inc(FEnumBkGndTime);
      if Assigned(EnumBkGndList) and not (vsNotifyChanging in VETStates) and HandleAllocated then
      begin
        EnterCriticalSection(FEnumLock);
        try
          LocalList := EnumBkGndList;
          EnumBkGndList := nil;
          TerminateEnumThread; // Must do this first to make sure we don't get another timer message, VT will dispatch messages if it validate a node apparently
          BeginUpdate;
          try
            LocalList.SharePIDLs := True;   // We give the PIDLs to the TNamespaces
            Items.Clear;
            Groups.ReIndexDisable := True;
            try
              for i := 0 to LocalList.Count - 1 do
              begin
                NS := TNamespace.Create(LocalList[i], RootFolderNamespace);
                if (eloHideRecycleBin in Options) and NS.IsRecycleBin then
                begin
                  NS.Free;
                  Exit
                end;
                Allow := True;
                DoEnumFolder(NS, Allow);
                if Allow then
                  AddCustomItem(nil, NS, True)
                else
                  NS.Free;
              end;
            finally
              Groups.ReIndexDisable := False;
            end;
          finally
            FreeAndNil(LocalList);
            EndUpdate;
          end
        finally
          LeaveCriticalSection(FEnumLock)
        end;
        EnumThreadFinished(True);
      end else
      if EnumBkGndTime > BKGNDLENTHYOPERATIONTIME then
      begin
        ShowAnimation := True;
        DoEnumThreadLengthyOperation(ShowAnimation);
        if ShowAnimation then
          ShowAnimateFolderWnd;
      end
    finally
      EndUpdate
    end
  end
end;

{ TExplorerItem }

constructor TExplorerItem.Create(ACollection: TEasyCollection);
begin
  inherited Create(ACollection);
end;

destructor TExplorerItem.Destroy;
begin
  if TCustomVirtualExplorerEasyListview( OwnerListview).LastDropTargetNS = Self.Namespace then
    TCustomVirtualExplorerEasyListview( OwnerListview).LastDropTargetNS := nil;
  SetDestroyFlags;
  FreeAndNil(FNamespace);
  FreeAndNil(FThumbInfo);
  inherited Destroy;
end;

{ TExplorerGroup }

constructor TExplorerGroup.Create(ACollection: TEasyCollection);
begin
  inherited Create(ACollection);
end;

destructor TExplorerGroup.Destroy;
begin
  SetDestroyFlags;
  inherited Destroy
end;

{ TEasyVirtualSelectionManager }

constructor TEasyVirtualSelectionManager.Create(AnOwner: TCustomEasyListview);
begin
  inherited;
  FFirstItemFocus := True;
  ForceDefaultBlend := True;
end;

{ TEasyDetailsThreadRequest }

function TEasyDetailsThreadRequest.HandleRequest: Boolean;
var
  i: Integer;
begin
  Result := True;
  SetLength(FDetails, Length(DetailRequest));
  for i := 0 to Length(DetailRequest) - 1 do
    Details[i] := DetailRequest[i];
end;

procedure TEasyDetailsThreadRequest.Assign(Source: TPersistent);
var
  S: TEasyDetailsThreadRequest;
begin
  inherited Assign(Source);
  if Source is TEasyDetailsThreadRequest then
  begin
    S := TEasyDetailsThreadRequest(Source);
    DetailRequest :=  S.DetailRequest;
    // Don't have to copy the Strings as they are output
  end
end;

{ TEasyThumbnailThreadRequest }

destructor TEasyThumbnailThreadRequest.Destroy;
begin
  // FlushMessageCache will free the Request, the extracted data needs to be freed
  FreeAndNil(FInternalThumbInfo);
  inherited;
end;

function TEasyThumbnailThreadRequest.HandleRequest: Boolean;
var
  NS: TNamespace;
begin
  // It is a bad idea to return false here for any reason.  If the thumbnail is corrupt
  // and SpCreateThumbInfoFromFile crashes the thumbnail thread will keep trying forever
  // to load the thumbnail
  Result := True;
  NS := TNamespace.Create(PIDL, nil);
  try
    NS.FreePIDLOnDestroy := False;
    try
      if Assigned(CreateCustomThumbInfoProc) then
        FInternalThumbInfo := CreateCustomThumbInfoProc(NS, Self);
      if not Assigned(FInternalThumbInfo) then
      FInternalThumbInfo := SpCreateThumbInfoFromFile(NS, ThumbSize.X, ThumbSize.Y,
        UseSubsampling, UseShellExtraction, UseExifThumbnail, UseExifOrientation, BackgroundColor);

      if Assigned(FInternalThumbInfo) then
        Tag := Integer(FInternalThumbInfo);
    except
      try
        FreeAndNil(FInternalThumbInfo);
      except
      end
    end;
  finally
    NS.Free;
  end
end;

procedure TEasyThumbnailThreadRequest.Assign(Source: TPersistent);
var
  S: TEasyThumbnailThreadRequest;
begin
  inherited Assign(Source);
  if Source is TEasyThumbnailThreadRequest then
  begin
    S := TEasyThumbnailThreadRequest(Source);
    BackgroundColor := S.BackgroundColor;
    ThumbSize := S.ThumbSize;
    UseExifThumbnail := S.UseExifThumbnail;
    UseExifOrientation := S.UseExifOrientation;
    UseShellExtraction := S.UseShellExtraction;
    UseSubsampling := S.UseSubsampling;
    CreateCustomThumbInfoProc := S.CreateCustomThumbInfoProc;
  end
end;

{ TEasyThumbsManager }

constructor TEasyThumbsManager.Create(AOwner: TComponent);
begin
  inherited;
  if AOwner is TCustomVirtualExplorerEasyListview then
    FController := AOwner as TCustomVirtualExplorerEasyListview;
end;

procedure LoadThumbInfoFromAlbum(LV: TCustomVirtualExplorerEasyListview; Album: TThumbAlbum);
var
  J, I, X: Integer;
  Items: TEasyItems;
  NS: TNamespace;
  AlbumT, T: TThumbInfo;
begin
  for J := 0 to LV.Groups.Count - 1 do
  begin
    Items := LV.Groups[J].Items;
    for I := 0 to Items.Count - 1 do
      if LV.ValidateNamespace(Items[I], NS) then
        if NS.States * [nsThreadedImageLoaded, nsThreadedImageLoading, nsThreadedImageResizing] = [] then
          if not Assigned(TExplorerItem(Items[I]).ThumbInfo) then begin
            X := Album.IndexOf(NS.NameForParsing);
            if Album.Read(X, AlbumT) then
              if (AlbumT.FileDateTime = NS.LastWriteDateTime) then begin
                T := TThumbInfo.Create;
                try
                  T.Assign(AlbumT);
                  NS.States := (NS.States - [nsThreadedImageLoading]) + [nsThreadedImageLoaded];
                  TExplorerItem(Items[I]).ThumbInfo := T;
                  TExplorerItem(Items[I]).Invalidate(True);
                except
                  T.Free;
                end;
              end;
          end;
  end;
end;

procedure SaveThumbInfoToAlbum(LV: TCustomVirtualExplorerEasyListview; Album: TThumbAlbum);
var
  J, I: Integer;
  Items: TEasyItems;
  NS: TNamespace;
  T: TThumbInfo;
  Compressed: Boolean;
begin
  Compressed := LV.ThumbsManager.StorageCompressed;

  Album.Clear;
  for J := 0 to LV.Groups.Count - 1 do
  begin
    Items := LV.Groups[J].Items;
    for I := 0 to Items.Count - 1 do
      if LV.ValidateNamespace(Items[I], NS) then
        if Assigned(TExplorerItem(Items[I]).ThumbInfo) then
        begin
          T := TThumbInfo.Create;
          try
            T.Assign(TExplorerItem(Items[I]).ThumbInfo);
            T.Filename := NS.NameForParsing;
            T.UseCompression := Compressed and (T.ImageWidth > 250) and (T.ImageHeight > 250);
            Album.Add(T);
          except
            T.Free;
          end;
        end;
  end;
end;

procedure TEasyThumbsManager.LoadAlbum(Force: Boolean);
var
  NS: TNamespace;
  AlbumFilename: WideString;
  Album: TThumbAlbum;
begin
  if Assigned(FController) then
  begin
    BeginUpdate;
    try
      NS := FController.RootFolderNamespace;
      if Assigned(NS) and NS.Folder and NS.FileSystem then
      begin
        AlbumFilename := GetAlbumFileToLoad(NS.NameForParsing);
        if FileExistsW(AlbumFilename) then
        begin
          Album := TThumbAlbum.Create;
          try
            Album.LoadFromFile(AlbumFilename);
            LoadThumbInfoFromAlbum(FController, Album);
          finally
            Album.Free;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TEasyThumbsManager.ReloadThumbnail(Item: TEasyItem);
var
  NS: TNamespace;
  VFF: TValidImageFileFormat;
  ThumbSize: TPoint;
  RectArray: TEasyRectArrayObject;
begin
  if Controller.ValidateNamespace(Item, NS) then
    if NS.States * [nsThreadedImageLoading, nsThreadedImageResizing] = [] then
      if nsThreadedImageLoaded in NS.States then begin
        // The thumbnail was loaded and it's not being resized, clear
        // the loaded flag
        NS.States := NS.States - [nsThreadedImageLoaded];
        // Enqueue the request
        Item.View.ItemRectArray(Item, nil, Controller.Canvas, Item.Caption, RectArray);
        VFF := IsValidImageFileFormat(NS);
        if VFF <> vffInvalid then begin
          ThumbSize.X := Max(RectWidth(RectArray.IconRect), MaxThumbWidth);
          ThumbSize.Y := Max(RectHeight(RectArray.IconRect), MaxThumbHeight);
          Controller.Enqueue(NS, Item, ThumbSize, VFF = vffUnknown, False);
        end;
      end;
end;

procedure TEasyThumbsManager.SaveAlbum;
var
  NS: TNamespace;
  AlbumFilename: WideString;
  Album: TThumbAlbum;
begin
  if Assigned(FController) then
  begin
    BeginUpdate;
    try
      NS := FController.RootFolderNamespace;
      if Assigned(NS) and NS.Folder and NS.FileSystem then
        if (StorageType = tasRepository) or not NS.ReadOnly then
        begin
          Album := TThumbAlbum.Create;
          try
            Album.Directory := NS.NameForParsing;
            AlbumFilename := GetAlbumFileToSave(NS.NameForParsing, True);
            if AlbumFilename <> '' then begin
              SaveThumbInfoToAlbum(FController, Album);
              Album.SaveToFile(AlbumFilename);
            end;
          finally
            Album.Free;
          end;
        end;
    finally
      EndUpdate;
    end;
  end;
end;

{ TCategories }

constructor TCategories.Create;
begin
  inherited;
  FCategoryList := TList.Create;
end;

destructor TCategories.Destroy;
begin
  Clear;
  FreeAndNil(FCategoryList);
  inherited Destroy;
end;

function TCategories.Add: TCategory;
begin
  Result := TCategory.Create;
  FCategoryList.Add(Result);
end;

function TCategories.GetCategories(Index: Integer): TCategory;
begin
  Result := TCategory(FCategoryList[Index])
end;

function TCategories.GetCount: Integer;
begin
  Result := FCategoryList.Count;
end;

procedure TCategories.Clear;
var
  i: Integer;
begin
  try
    for i := 0 to FCategoryList.Count - 1 do
      TObject( Categories[i]).Free;
  finally
    FCategoryList.Clear
  end
end;

procedure TCategories.Delete(Index: Integer);
begin
  TObject( FCategoryList.Items[Index]).Free;
  FCategoryList.Delete(Index)
end;

{ TVirtualEasyListviewDataObject }
constructor TVirtualEasyListviewDataObject.Create;
begin
  inherited Create;
end;

destructor TVirtualEasyListviewDataObject.Destroy;
begin
  ShellDataObject := nil;
  inherited Destroy;
end;

function TVirtualEasyListviewDataObject.DAdvise(const formatetc: TFormatEtc; advf: Longint; const advSink: IAdviseSink; out dwConnection: Longint): HResult;
begin
 // Just advise on the ShellDataObject.  This is not implemented very well but
 // I have never seen the Advise methods get called in a shell data transfer
 // so a more sophisicated implementation is not high priority.
 // We don't support much more then the drag image so there is not much to
 // advise on anyway.
   Result := E_FAIL;
   if Assigned(ShellDataObject) then
     Result := ShellDataObject.DAdvise(formatetc, advf, advSink, dwConnection)
end;

function TVirtualEasyListviewDataObject.DUnadvise(dwConnection: Longint): HResult;
begin
 // Just advise on the ShellDataObject.  This is not implemented very well but
 // I have never seen the Advise methods get called in a shell data transfer
 // so a more sophisicated implementation is not high priority.
 // We don't support much more then the drag image so there is not much to
 // advise on anyway.
  Result := E_FAIL;
  if Assigned(ShellDataObject) then
    Result := ShellDataObject.DUnadvise(dwConnection)
end;

function TVirtualEasyListviewDataObject.EnumDAdvise(out enumAdvise: IEnumStatData): HResult;
begin
 // Just advise on the ShellDataObject.  This is not implemented very well but
 // I have never seen the Advise methods get called in a shell data transfer
 // so a more sophisicated implementation is not high priority.
 // We don't support much more then the drag image so there is not much to
 // advise on anyway.
  Result := E_FAIL;
  if Assigned(ShellDataObject) then
    Result := ShellDataObject.EnumDAdvise(enumAdvise)
end;

function TVirtualEasyListviewDataObject.EnumFormatEtc(dwDirection: Longint; out enumFormatEtc: IEnumFormatEtc): HResult;
begin
  //
  // If we can't support the format then let the ShellDataObject try
  //
  Result := inherited EnumFormatEtc(dwDirection, enumFormatEtc);
  if (Result <> S_OK) and Assigned(ShellDataObject) then
    ShellDataObject.EnumFormatEtc(dwDirection, enumFormatEtc);
end;

function TVirtualEasyListviewDataObject.GetCanonicalFormatEtc(const formatetc: TFormatEtc; out formatetcOut: TFormatEtc): HResult;
begin
  //
  // If we can't support the format then let the ShellDataObject try
  //
  Result:= inherited GetCanonicalFormatEtc(formatetc, formatetcOut);
  if Assigned(ShellDataObject) and (Result <> S_OK) then
    Result := ShellDataObject.GetCanonicalFormatEtc(formatetc, formatetcOut);
end;

function TVirtualEasyListviewDataObject.GetData(const FormatEtcIn: TFormatEtc; out Medium: TStgMedium): HResult;
begin
  //
  // If we can't support the format then let the ShellDataObject try
  //
  Result:= inherited GetData(FormatEtcIn, Medium);
  if (Result <> S_OK) and Assigned(ShellDataObject) then
    Result := ShellDataObject.GetData(FormatEtcIn, Medium);
end;

function TVirtualEasyListviewDataObject.GetDataHere(const formatetc: TFormatEtc; out medium: TStgMedium): HResult;
begin
  //
  // If we can't support the format then let the ShellDataObject try
  //
  Result:= inherited GetDataHere(formatetc, medium);
  if (Result <> S_OK) and Assigned(ShellDataObject) then
    Result := ShellDataObject.GetDataHere(formatetc, medium);
end;

function TVirtualEasyListviewDataObject.QueryGetData(const formatetc: TFormatEtc): HResult;
begin
  //
  // If we can't support the format then let the ShellDataObject try
  //
  Result:= inherited QueryGetData(formatetc);
  if (Result <> S_OK) and Assigned(ShellDataObject) then
    Result := ShellDataObject.QueryGetData(formatetc);
end;

function TVirtualEasyListviewDataObject.SetData(const formatetc: TFormatEtc; var medium: TStgMedium; fRelease: BOOL): HResult;
begin
  Result:= inherited SetData(formatetc, medium, fRelease);
  if (Result <> S_OK) and Assigned(ShellDataObject) then
    Result := ShellDataObject.SetData(formatetc, medium, fRelease)
end;

procedure TVirtualEasyListviewDataObject.DoGetCustomFormats(dwDirection: Integer; var Formats: TFormatEtcArray);
//
// Here we proxy the formats that the ShellDataObject can support into
// our implemenation
//
var
  enumFormatEtc: IEnumFormatEtc;
  pceltFetched: Longint;
  elt: TeltArray;
begin
  inherited DoGetCustomFormats(dwDirection, Formats);
  if Assigned(ShellDataObject) then
  begin
    if Succeeded(ShellDataObject.EnumFormatEtc(dwDirection, enumFormatEtc)) then
    begin
      enumFormatEtc.Reset;
      while enumFormatEtc.Next(1, elt, @pceltFetched) = NOERROR do
      begin
        SetLength(Formats, Length(Formats) + 1);
        Formats[Length(Formats) - 1] := elt[0]
      end
    end
  end
end;

{ TEasyDetailStringsThreadRequest }
function TEasyDetailStringsThreadRequest.HandleRequest: Boolean;
var
  i: Integer;
  NS: TNamespace;
  WS, Title: WideString;
begin
  Result := True;
  NS := TNamespace.Create(PIDL, nil);
  try
    NS.FreePIDLOnDestroy := False;
    SetLength(FDetails, Length(DetailRequest));
    for i := 0 to Length(DetailRequest) - 1 do
    begin
      if AddTitleColumnCaption then
      begin
        WS := NS.DetailsOf(DetailRequest[i]);
        if WS <> '' then
        begin
          Title := NS.Parent.DetailsColumnTitle(i);
          if Title <> '' then
            Details[i] := NS.Parent.DetailsColumnTitle(i) + ': ' + WS
          else
            Details[i] := WS
        end
      end else
        Details[i] := NS.DetailsOf(DetailRequest[i])
    end
  finally
    NS.Free
  end
end;

procedure TEasyDetailStringsThreadRequest.Assign(Source: TPersistent);
var
  S: TEasyDetailStringsThreadRequest;
begin
  inherited Assign(Source);
  if Source is TEasyDetailStringsThreadRequest then
  begin
    S := TEasyDetailStringsThreadRequest(Source);
    DetailRequest :=  S.DetailRequest;
    AddTitleColumnCaption := S.AddTitleColumnCaption;
    // Don't have to copy the Strings as they are output
  end
end;

{ TELVPersistent }
constructor TELVPersistent.Create;
begin
  inherited;
  SelectedPIDLs := TCommonPIDLList.Create;
end;

destructor TELVPersistent.Destroy;
begin
  FreeAndNil(FSelectedPIDLs);
  FreeAndNil(FStorage);
  inherited;
end;

procedure TELVPersistent.Clear;
begin
  { TCommonPIDLLists know how to free the PIDL's automaticlly }
  SelectedPIDLs.Clear;
  PIDLMgr.FreeAndNilPIDL(FRootFolderCustomPIDL);
  PIDLMgr.FreeAndNilPIDL(FFocusPIDL);
  PIDLMgr.FreeAndNilPIDL(FTopNodePIDL);
  RootFolderCustomPath := '';
  FreeAndNil(FStorage)
end;

procedure TELVPersistent.LoadFromFile(FileName: WideString; Version: integer = VETStreamStorageVer; ReadVerFromStream: Boolean = True);
begin
  inherited LoadFromFile(FileName, Version, ReadVerFromStream);
end;

procedure TELVPersistent.LoadFromStream(S: TStream; Version: integer = VETStreamStorageVer; ReadVerFromStream: Boolean = True);
var
  Count: integer;
begin
  inherited;
  Clear;
  SelectedPIDLs.LoadFromStream(S);
  PIDLMgr.FreePIDL(FRootFolderCustomPIDL);
  FRootFolderCustomPIDL := PIDLMgr.LoadFromStream(S);
  FTopNodePIDL := PIDLMgr.LoadFromStream(S);
  FFocusPIDL := PIDLMgr.LoadFromStream(S);
  S.ReadBuffer(FRootFolder, SizeOf(RootFolder));
  S.read(Count, SizeOf(Count));
  SetLength(FRootFolderCustomPath, Count);
  S.read(PWideChar( FRootFolderCustomPath)^, Count * 2); 
  FreeAndNil(FStorage);
  Storage := TNodeStorage.Create(PIDLMgr.LoadFromStream(S), nil);
  Storage.LoadFromStream(S, Version, ReadVerFromStream);
  { Add new stream data here }
  { if Version >= PersistentStreamVersion_0 then }
  {   read new data                     }
end;

procedure TELVPersistent.RestoreList(ELV: TCustomVirtualExplorerEasyListview; RestoreSelection, RestoreFocus: Boolean; ScrollToOldTopNode: Boolean = False);
var
  VEEL: TVirtualExplorerEasyListview;
  Item: TExplorerItem;
  i: Integer;
  Sel: TEasySelectionManagerHack;
begin
  if States * [epsRestoring, epsSaving] = [] then
  begin
    Include(FStates, epsRestoring);
    try
      VEEL := TVirtualExplorerEasyListview( ELV);
      VEEL.BeginUpdate;   
      try
        Sel := TEasySelectionManagerHack( ELV.Selection);

        if RootFolder <> rfCustom then
        begin
          if RootFolderCustomPath <> '' then
            VEEL.RootFolderCustomPath := RootFolderCustomPath
          else
          if Assigned(RootFolderCustomPIDL) then
            VEEL.RootFolderCustomPIDL := RootFolderCustomPIDL;
        end;
        VEEL.LoadStorageToRoot(Storage);
        VEEL.RebuildRootNamespace;
        TEasyListview(VEEL).Sort.SortAll(True);
        VEEL.Groups.Rebuild(True);
        VEEL.Scrollbars.ReCalculateScrollbars(True, False);

        Sel.FocusedItem := VEEL.FindItemByPIDL(FocusPIDL);
        for i := 0 to SelectedPIDLs.Count - 1 do
        begin
          Item := VEEL.FindItemByPIDL(SelectedPIDLs[i]);
          if Assigned(Item) then
            Item.Selected := True;
        end;
        Item := VEEL.FindItemByPIDL(TopNodePIDL) as TExplorerItem;
        if Assigned(Item) then
          Item.MakeVisible(emvTop)
      finally
        VEEL.EndUpdate
      end
    finally
      Exclude(FStates, epsRestoring);
    end
  end
end;

procedure TELVPersistent.SaveList(ELV: TCustomVirtualExplorerEasyListview; SaveSelection, SaveFocus: Boolean);
var
  Sel: TEasySelectionManagerHack;
  VEEL: TVirtualExplorerEasyListview;
  Item: TExplorerItem;
  BaseItem: TEasyItem;
begin
  if States * [epsRestoring, epsSaving] = [] then
  begin
    Include(FStates, epsSaving);
    try
      VEEL := TVirtualExplorerEasyListview( ELV);
      VEEL.TerminateDetailsOfThread;
      VEEL.TerminateEnumThread;
      GlobalThreadManager.FlushAllMessageCache(ELV);
      Clear;
      Storage := TNodeStorage.Create(PIDLMgr.CopyPIDL( VEEL.RootFolderNamespace.AbsolutePIDL), nil);
      VEEL.SaveRootToStorage(Storage);
      if VEEL.Groups.ItemCount > 0 then
      begin
        Sel := TEasySelectionManagerHack( ELV.Selection);
        if Assigned(Sel.FocusedItem) then
          FocusPIDL := PIDLMgr.CopyPIDL((Sel.FocusedItem as TExplorerItem).Namespace.AbsolutePIDL);
        BaseItem := VEEL.Groups.FirstItemInRect(VEEL.Scrollbars.MapWindowRectToViewRect(VEEL.ClientRect, False));
        if Assigned(BaseItem) then
          TopNodePIDL := PIDLMgr.CopyPIDL((BaseItem as TExplorerItem).Namespace.AbsolutePIDL);
        RootFolder := VEEL.RootFolder;
        RootFolderCustomPath := VEEL.RootFolderCustomPath;
        RootFolderCustomPIDL := PIDLMgr.CopyPIDL(VEEL.RootFolderCustomPIDL);
        Item := VEEL.Selection.First as TExplorerItem;
        while Assigned(Item) do
        begin
          SelectedPIDLs.CopyAdd((Item as TExplorerItem).Namespace.AbsolutePIDL);
          Item := VEEL.Selection.Next(Item) as TExplorerItem
        end;
      end
    finally
      Exclude(FStates, epsSaving);
    end
  end
end;

procedure TELVPersistent.SaveToFile(FileName: WideString; Version: integer = VETStreamStorageVer; ReadVerFromStream: Boolean = True);
begin
  inherited SaveToFile(FileName, Version, ReadVerFromStream);
end;

procedure TELVPersistent.SaveToStream(S: TStream; Version: integer = VETStreamStorageVer; WriteVerToStream: Boolean = True);
var
  Count: Integer;
begin
  inherited;
  SelectedPIDLs.SaveToStream(S);
  PIDLMgr.SaveToStream(S, FRootFolderCustomPIDL);
  PIDLMgr.SaveToStream(S, TopNodePIDL);
  PIDLMgr.SaveToStream(S, FocusPIDL);
  S.WriteBuffer(FRootFolder, SizeOf(RootFolder));
  Count := Length(RootFolderCustomPath);
  S.WriteBuffer(Count, SizeOf(Count));
  S.WriteBuffer(PWideChar( FRootFolderCustomPath)^, Count * 2);
  PIDLMgr.SaveToStream(S, Storage.AbsolutePIDL);
  Storage.SaveToStream(S, Version, WriteVerToStream);
end;

{ TEasyExplorerMemoEditor}
procedure TEasyExplorerMemoEditor.DoEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState; var DoDefault: Boolean);
begin
  if Key = VK_F2 then
  begin
    FullSelToggleState := not FullSelToggleState;
    SelectFileName(not FullSelToggleState);
    DoDefault := False
  end else
    inherited DoEditKeyDown(Sender, Key, Shift, DoDefault);
end;

procedure TEasyExplorerMemoEditor.SelectFileName(FileNameOnly: Boolean);
var
  P: PWideChar;
  Position: Integer;
  Tail: PWideChar;
  TempItem: TExplorerItem;
  WS: WideString;
begin
  Position := 0;
  (Editor as TEasyMemo).SelStart := 0;
  WS := (Editor as TEasyMemo).Text;
  P := PWideChar(WS);
  Tail := P;
  Inc(Tail, Length(WS));
  TempItem := Item as TExplorerItem;
  // Need to make sure that the shell name has an extension included before trying to eliminate it
  if FileNameOnly and (not TempItem.Namespace.Folder or TempItem.Namespace.Browsable) and (WideStrIComp(PWideChar(TempItem.Namespace.NameInFolder), PWideChar(TempItem.Namespace.FileName)) = 0) then
  begin
    while (Tail > P) and (Position = 0) do
    begin
      if Tail^ = '.' then
        Position := Tail - P + 1;
      Dec(Tail);
    end
  end;

  if Position = 0 then
    (Editor as TEasyMemo).SelectAll
  else
    (Editor as TEasyMemo).SelLength := Position - 1;
end;

function TEasyExplorerMemoEditor.SetEditorFocus: Boolean;
begin
  if Editor.CanFocus then
  begin
    Editor.SetFocus;
    FullSelToggleState := False;
    SelectFileName(not FullSelToggleState);
    Result := Editor.Handle = GetFocus
  end else
    Result := False
end;

{ TEasyExplorerStringEditor}
procedure TEasyExplorerStringEditor.DoEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState; var DoDefault: Boolean);
begin
  if Key = VK_F2 then
  begin
    FullSelToggleState := not FullSelToggleState;
    SelectFileName(not FullSelToggleState);
    DoDefault := False
  end else
    inherited DoEditKeyDown(Sender, Key, Shift, DoDefault);
end;

procedure TEasyExplorerStringEditor.SelectFileName(FileNameOnly: Boolean);
var
  P: PWideChar;
  Position: Integer;
  Tail: PWideChar;
  TempItem: TExplorerItem;
  WS: WideString;
begin
  (Editor as TEasyEdit).SelStart := 0;
  WS := (Editor as TEasyEdit).Text;
  Position := 0;
  P := PWideChar(WS);
  Tail := P;
  Inc(Tail, Length(WS));
  TempItem := Item as TExplorerItem;
  // Need to make sure that the shell name has an extension included before trying to eliminate it
  if FileNameOnly and (not TempItem.Namespace.Folder or TempItem.Namespace.Browsable) and (WideStrIComp(PWideChar(TempItem.Namespace.NameInFolder), PWideChar(TempItem.Namespace.FileName)) = 0) then
  begin
    while (Tail > P) and (Position = 0) do
    begin
      if Tail^ = '.' then
        Position := Tail - P + 1;
      Dec(Tail);
    end
  end;

  if Position = 0 then
    (Editor as TEasyEdit).SelectAll
  else
    (Editor as TEasyEdit).SelLength := Position - 1;
end;

function TEasyExplorerStringEditor.SetEditorFocus: Boolean;
begin
  if Editor.CanFocus then
  begin
    Editor.SetFocus;
    FullSelToggleState := False;
    SelectFileName(not FullSelToggleState);
    Result := Editor.Handle = GetFocus
  end else
    Result := False;
end;

{ TVirtualCompressedFiles}
constructor TVirtualCustomFileTypes.Create(AColor: TColor);
begin
  inherited Create;
  Font := TFont.Create;
  Color := AColor;
end;

destructor TVirtualCustomFileTypes.Destroy;
begin
  FreeAndNil(FFont);
  inherited Destroy;
end;

procedure TVirtualCustomFileTypes.SetHilight(const Value: Boolean);
begin
  if FHilight <> Value then
  begin
    FHilight := Value;
    Font.Color := Color
  end
end;

{ TEasyVirtualThumbView }

function TEasyVirtualThumbView.FullRowSelect: Boolean;
begin
  Result := False
end;

procedure TEasyVirtualThumbView.ItemRectArray(Item: TEasyItem;
  Column: TEasyColumn; ACanvas: TCanvas; const Caption: WideString;
  var RectArray: TEasyRectArrayObject);
begin
  ZeroMemory(@RectArray, SizeOf(RectArray));
  RectArray.BoundsRect := TEasyItemHack( Item).DisplayRect;
  RectArray.ClickSelectBoundsRect := RectArray.BoundsRect;
  InflateRect(RectArray.ClickSelectBoundsRect, -2, -2);
  RectArray.DragSelectBoundsRect := RectArray.BoundsRect;
  InflateRect(RectArray.DragSelectBoundsRect, -2, -2);
  RectArray.IconRect := RectArray.BoundsRect;
  InflateRect(RectArray.IconRect, -2, -2);
  RectArray.SelectionRect := RectArray.BoundsRect;
  InflateRect(RectArray.SelectionRect, -2, -2);
  RectArray.FullFocusSelRect := RectArray.BoundsRect;
  InflateRect(RectArray.FullFocusSelRect, -2, -2);
end;

procedure TEasyVirtualThumbView.PaintAfter(Item: TEasyItem;
  Column: TEasyColumn; const Caption: WideString; ACanvas: TCanvas;
  RectArray: TEasyRectArrayObject);
begin
  if not TVirtualExplorerEasyListview( OwnerListview).ThumbsManager.HideBorder then
    inherited
end;

procedure TEasyVirtualThumbView.PaintImage(Item: TEasyItem;
  Column: TEasyColumn; const Caption: WideString;
  RectArray: TEasyRectArrayObject; ImageSize: TEasyImageSize; ACanvas: TCanvas);
begin
  inherited PaintImage(Item, Column, Caption, RectArray, ImageSize, ACanvas);
end;

procedure TEasyVirtualThumbView.PaintText(Item: TEasyItem; Column: TEasyColumn;
  const Caption: WideString; RectArray: TEasyRectArrayObject; ACanvas: TCanvas;
  LinesToDraw: Integer);
begin
//  inherited;
// Not painting the text
end;

{ TCustomVirtualDropStack}
constructor TCustomVirtualDropStack.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  HintItemCount := 16;
  StackDepth := 64;
  DragManager.Enabled := True;
  ImagesSmall := SmallSysImages;
  ImagesLarge := LargeSysImages;
  Selection.UseFocusRect := False;
  Selection.MultiSelect := True;
  Selection.EnableDragSelect := True;
  EditManager.Enabled := False;
  Header.FixedSingleColumn := True
end;

procedure TCustomVirtualDropStack.AddDropStackItems(const DataObject: IDataObject);
var
  Item: TVirtualDropStackItem;
  NS: TNamespace;
  ShellIDList: TCommonShellIDList;
begin
  BeginUpdate;
  ShellIDList := TCommonShellIDList.Create;
  try
    ShellIDList.LoadFromDataObject(DataObject);
    if ShellIDList.PIDLCount > 0 then
    begin
      Item := Items.AddCustom(TVirtualDropStackItem) as TVirtualDropStackItem;
      Item.DataObject := DataObject;
      NS := TNamespace.Create(ShellIDList.AbsolutePIDL(0), nil);
      Item.Caption := NS.NameNormal + ' ... (' + IntToStr(ShellIDList.PIDLCount) + ' objects)';
      Item.ImageIndex := NS.GetIconIndex(False, icSmall);
      NS.Free
    end
  finally
    // Keep the stack depth correct
    if (Items.Count > StackDepth) and (Items.Count > 0) then
      Items.Delete(0);
    EndUpdate;
    ShellIDList.Free
  end
end;

procedure TCustomVirtualDropStack.DoHintPopup(TargetObj: TEasyCollectionItem; HintType: TEasyHintType; MousePos: TPoint; var AText: WideString; var HideTimeout: Integer; var ReshowTimeout: Integer; var Allow: Boolean);
var
  Item: TVirtualDropStackItem;
  ShellIDList: TCommonShellIDList;
  i: Integer;
  NS: TNamespace;
begin
  if (TargetObj is TVirtualDropStackItem) and ShowHint then
  begin
    Allow := True;
    if Hint = '' then
    begin
      Item := TVirtualDropStackItem( TargetObj);
      ShellIDList := TCommonShellIDList.Create;
      try
        ShellIDList.LoadFromDataObject(Item.DataObject);
        AText := 'Item count = ' + IntToStr(ShellIDList.PIDLCount) + #13#10;
        i := 0;
        while (i < ShellIDList.PIDLCount) and (i < HintItemCount) do
        begin
          NS := TNamespace.Create(PIDLMgr.CopyPIDL(ShellIDList.AbsolutePIDL(i)), nil);
          AText := AText + NS.NameParseAddress + #13#10;
          NS.Free;
          Inc(i)
        end;
        if i < ShellIDList.PIDLCount then
          AText := AText + ' ...';
      finally
        ShellIDList.Free
      end
    end else
      AText := Hint
  end
end;

procedure TCustomVirtualDropStack.DoOLEDragEnd(ADataObject: IDataObject; DragResult: TCommonOLEDragResult; ResultEffect: TCommonDropEffects; KeyStates: TCommonKeyStates);
var
  Effect: TCommonLogicalPerformedDropEffect;
begin
  Effect := TCommonLogicalPerformedDropEffect.Create;
  try
    if ADataObject.QueryGetData(Effect.GetFormatEtc) = S_OK then
    begin
      Effect.LoadFromDataObject(ADataObject);
      // If it is a move then we can't reference it anymore so remove it
      if (Effect.Action = effectMove) or (AutoRemove = dsarAlways) or
       ((AutoRemove = dsarRightDragOnly) and (cksRButton in KeyStates)) then
        Selection.DeleteSelected;
    end
  finally
    Effect.Free
  end
end;

procedure TCustomVirtualDropStack.DoOLEDragStart(ADataObject: IDataObject; var AvailableEffects: TCommonDropEffects; var AllowDrag: Boolean);
begin
  AllowDrag := True;
  AvailableEffects := [cdeCopy, cdeMove, cdeLink]
end;

procedure TCustomVirtualDropStack.DoOLEDropTargetDragDrop(DataObject: IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint; AvailableEffects: TCommonDropEffects; var DesiredEffect: TCommonDropEffect; var Handled: Boolean);
begin
  try
    if Assigned(DragManager.DropTarget) then
    begin
    end else
      AddDropStackItems(DataObject)
  finally
    DataObjectTemp := nil;
    if Assigned(OnDragDrop) then
      OnDragDrop(Self)
  end
end;

procedure TCustomVirtualDropStack.DoOLEDropTargetDragEnter(DataObject: IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint; AvailableEffects: TCommonDropEffects; var DesiredEffect: TCommonDropEffect);
begin
  DesiredEffect := cdeNone;
  DataObjectTemp := DataObject;
  if DataObjectSupportsShell(DataObjectTemp) then
    DesiredEffect := cdeLink
end;

procedure TCustomVirtualDropStack.DoOLEDropTargetDragLeave;
begin
  DataObjectTemp := nil;
end;

procedure TCustomVirtualDropStack.DoOLEDropTargetDragOver(KeyState: TCommonKeyStates; WindowPt: TPoint; AvailableEffects: TCommonDropEffects; var DesiredEffect: TCommonDropEffect);
begin
  inherited DoOLEDropTargetDragOver(KeyState, WindowPt, AvailableEffects, DesiredEffect);
  DesiredEffect := cdeLink
end;

procedure TCustomVirtualDropStack.DoOLEGetDataObject(var DataObject: IDataObject);
var
  Item: TVirtualDropStackItem;
  ShellIDList: TCommonShellIDList;
  APIDLList: TCommonPIDLList;
  i: Integer;
  DataObj: TEasyDataObjectManager;
  HDrop: TCommonHDrop;
  FileListA: TStringList;
begin
  if Selection.Count > 0 then
  begin
    APIDLList := TCommonPIDLList.Create;
    ShellIDList := TCommonShellIDList.Create;
    HDrop := TCommonHDrop.Create;
    FileListA := TStringList.Create;
    try
      APIDLList.CopyAdd(DesktopFolder.AbsolutePIDL);
      // Add all the PIDL's from all the DataObjects based off the desktop (Absolute PIDLs)
      Item := Selection.First as TVirtualDropStackItem;
      while Assigned(Item) do
      begin
        ShellIDList.LoadFromDataObject(Item.DataObject);
        HDrop.LoadFromDataObject(Item.DataObject);
        for i := 0 to ShellIDList.PIDLCount - 1 do
          APIDLList.Add(ShellIDList.AbsolutePIDL(i));
        for i := 0 to HDrop.FileCount - 1 do
        begin
          FileListA.Add(HDrop.FileName(i))
        end;
        Item := Selection.Next(Item) as TVirtualDropStackItem;
      end;
      ShellIDList.AssignPIDLs(APIDLList);
      HDrop.AssignFilesA(FileListA);
      DataObj := TEasyDataObjectManager.Create;
      DataObject := DataObj as IDataObject;
      DataObj.Listview := Self;
      ShellIDList.SaveToDataObject(DataObject);
      HDrop.SaveToDataObject(DataObject)
    finally
      ShellIDList.Free;
      HDrop.Free;
      FileListA.Free;
      APIDLList.Free
    end
  end
end;

procedure TCustomVirtualDropStack.DoViewChange;
begin
  inherited DoViewChange;   
end;

{ TVirtualDropStackItem }
destructor TVirtualDropStackItem.Destroy;
begin
  DataObject := nil;
  inherited
end;

{ TCustomVirtualMultiPathExplorerEasyListview }
constructor TCustomVirtualMultiPathExplorerEasyListview.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActive := True
end;

function TCustomVirtualMultiPathExplorerEasyListview.DoItemCompare(Column: TEasyColumn; Group: TEasyGroup; Item1: TEasyItem; Item2: TEasyItem): Integer;
var
  iColumn: Integer;
  DoDefault: Boolean;
begin
  if Assigned(Column) and TExplorerColumn(Column).IsCustom then
    DoCustomColumnCompare(TExplorerColumn( Column), Group, TExplorerItem( Item1), TExplorerItem( Item2), Result)
  else begin
    DoDefault := True;
    if Assigned(OnItemCompare) then
      Result := OnItemCompare(Self, Column, Group, Item1, Item2, DoDefault);


    if DoDefault then
    begin
      Result := 0;
      if Assigned( Column) then
        iColumn := Column.Index
      else
        iColumn := 0;

      if iColumn = 3 then
      begin
        Result := CompareFileTime(TExplorerItem( Item1).Namespace.LastWriteTimeRaw, TExplorerItem( Item2).Namespace.LastWriteTimeRaw);
      end else
      if iColumn = 1 then
      begin
        if TExplorerItem( Item1).Namespace.SizeOfFileInt64 > TExplorerItem( Item2).Namespace.SizeOfFileInt64 then
          Result := 1
        else
        if TExplorerItem( Item1).Namespace.SizeOfFileInt64 < TExplorerItem( Item2).Namespace.SizeOfFileInt64 then
          Result := -1
      end else
        Result := WideStrComp( PWidechar( Item1.Captions[iColumn]), PWideChar( Item2.Captions[iColumn]));

      if (iColumn > 0) and (Result = 0) then
        Result := WideStrComp( PWidechar( Item1.Captions[0]), PWideChar( Item2.Captions[0]));

      if Column.SortDirection = esdDescending then
        Result := -Result;
    end
  end
end;

function TCustomVirtualMultiPathExplorerEasyListview.RereadAndRefresh(DoSort: Boolean): TEasyItem;
begin
  Result := nil;
  ScanAndDeleteInValidItems;
end;

procedure TCustomVirtualMultiPathExplorerEasyListview.CopyToClipboard(AbsolutePIDLs: Integer = 1);
begin
  inherited CopyToClipboard(AbsolutePIDLs);
end;

procedure TCustomVirtualMultiPathExplorerEasyListview.CutToClipboard(AbsolutePIDLs: Integer = 1);
begin
  inherited CutToClipboard(AbsolutePIDLs);
end;

procedure TCustomVirtualMultiPathExplorerEasyListview.DoCustomColumnAdd;
var
  Column: TEasyColumn;
begin
  Column := AddColumnProc;
  Column.Width := 250;
  Column.Caption := 'Path';
  Column.Visible := True;
  ColumnIndex := Column.Index;
  inherited DoCustomColumnAdd;
end;

procedure TCustomVirtualMultiPathExplorerEasyListview.DoCustomColumnCompare(Column: TExplorerColumn; Group: TEasyGroup; Item1: TExplorerItem; Item2: TExplorerItem; var CompareResult: Integer);
begin
  if Column.Index = ColumnIndex then
  begin
    CompareResult := WideStrComp( PWidechar( Item1.Captions[ColumnIndex]), PWideChar( Item2.Captions[ColumnIndex]));

    if Column.SortDirection = esdDescending then
      CompareResult := -CompareResult;
  end else
    inherited DoCustomColumnCompare(Column, Group, Item1, Item2, CompareResult);
end;

procedure TCustomVirtualMultiPathExplorerEasyListview.DoCustomColumnGetCaption(Column: TExplorerColumn; Item: TExplorerItem; var Caption: WideString);
begin
  if Column.Index = ColumnIndex then
  begin
    Caption := WideExtractFilePath( Item.Namespace.NameForParsing)
  end else
    inherited DoCustomColumnGetCaption(Column, Item, Caption);
end;

procedure TCustomVirtualMultiPathExplorerEasyListview.Rebuild(RestoreTopNode: Boolean = False);
begin
  ScanAndDeleteInValidItems;
end;

procedure TCustomVirtualMultiPathExplorerEasyListview.ScanAndDeleteInValidItems;
var
  i: Integer;
  ExplorerItem: TExplorerItem;
  ItemArray: TEasyItemArray;
begin
  i := 0;
  SetLength(ItemArray, Groups.ItemCount);
  BeginUpdate;
  try
    ExplorerItem := Groups.FirstItem as TExplorerItem;
    while Assigned(ExplorerItem) do
    begin
      if not ExplorerItem.Namespace.Valid then
      begin
        ItemArray[i] := ExplorerItem;
        Inc(i)
      end;
      ExplorerItem := Groups.NextItem(ExplorerItem) as TExplorerItem
    end;
    SetLength(ItemArray, i);
    Groups.DeleteItems(ItemArray);
  finally
    EndUpdate();
  end;
end;

procedure TCustomVirtualMultiPathExplorerEasyListview.SelectedFilesDelete(ShiftKeyState: TExecuteVerbShift = evsCurrent);
begin
  inherited SelectedFilesDelete(ShiftKeyState);
end;

{ TExtensionColorCodeList }
constructor TExtensionColorCodeList.Create;
begin
  inherited Create;
  ItemList := TList.Create;
end;

destructor TExtensionColorCodeList.Destroy;
begin
  Clear;
  FreeAndNil(FItemList);
  inherited Destroy;
end;

function TExtensionColorCodeList.Add(ExtList: WideString; AColor: TColor; IsBold: Boolean = False; IsItalic: Boolean = False; IsUnderLine: Boolean = False; IsEnabled: Boolean = True): TExtensionColorCode;
var
  WasFound: Boolean;
begin
  WasFound := False;
  Result := Find(ExtList);
  if not Assigned(Result) then
    Result := TExtensionColorCode.Create
  else
    WasFound := True;

  if Assigned(Result) then
  begin
    Result.ExtensionMask := ExtList;
    Result.Color := AColor;
    Result.Bold := IsBold;
    Result.Italic := IsItalic;
    Result.UnderLine := IsUnderLine;
    Result.Enabled := IsEnabled;
    if not WasFound then
      ItemList.Add(Result);
  end
end;

function TExtensionColorCodeList.FindColorCode(NS: TNamespace): TExtensionColorCode;
var
  i, j: Integer;
  TargetExt: WideString;
begin
  Result := nil;
  if NS.Link then
  begin
    TargetExt := WideLowerCase(ExtractFileExt(NS.ShellLink.TargetPath));
  end else
  begin
    TargetExt := WideLowerCase(ExtractFileExt(NS.FileName));
  end;
  if TargetExt <> '' then
  begin
    i := 0;
    while not Assigned(Result) and (i < ItemList.Count) do
    begin
      j := 0;
      while not Assigned(Result) and (j < Items[i].Extensions.Count) do
      begin
        if WideStrIComp(PWideChar( WideString((Items[i].Extensions[j]))), PWideChar( TargetExt)) = 0 then
          Result := Items[i];
        Inc(j)
      end;
      Inc(i)
    end
  end
end;

function TExtensionColorCodeList.GetCount: Integer;
begin
  Result := ItemList.Count
end;

function TExtensionColorCodeList.GetItems(Index: Integer): TExtensionColorCode;
begin
  Result := TExtensionColorCode( ItemList[Index])
end;

procedure TExtensionColorCodeList.Assign(Source: TPersistent);
var
  i: Integer;
  ColorCodeList: TExtensionColorCodeList;
begin
  if Source is TExtensionColorCodeList then
  begin
    ColorCodeList := TExtensionColorCodeList(Source);
    Clear;
    for i := 0 to ColorCodeList.Count - 1 do
      Add(ColorCodeList[i].ExtensionMask, ColorCodeList[i].Color, ColorCodeList[i].Bold, ColorCodeList[i].Italic, ColorCodeList[i].UnderLine, ColorCodeList[i].Enabled);
  end
end;

procedure TExtensionColorCodeList.Clear;
var
  i: Integer;
begin
  for i := 0 to ItemList.Count - 1 do
    TObject( Items[i]).Free;
  ItemList.Count := 0;
end;

function TExtensionColorCodeList.Find(ExtList: WideString): TExtensionColorCode;
var
  i: Integer;
//  Ext: WideString;
begin
  Result := nil;
  // Ext := ExtractFileExt(FileName);
   i := 0;
  // Do exhaustive search until decide it is a bottleneck then do binary search
  while not Assigned(Result) and (i < ItemList.Count) do
  begin
    if WideStrIComp( PWideChar( ExtList), PWideChar( Items[i].ExtensionMask)) = 0 then
      Result := Items[i];
    Inc(i)
  end
end;

procedure TExtensionColorCodeList.LoadFromStream(S: TStream; Version: integer = 0; ReadVerFromStream: Boolean = False);
var
  Count, i: Integer;
  Item: TExtensionColorCode;
begin
  Clear;
  inherited LoadFromStream(S, Version, ReadVerFromStream);
  Count := StreamHelper.ReadInteger(S);
  for i := 0 to Count - 1 do
  begin
    Item := TExtensionColorCode.Create;
    Item.LoadFromStream(S, Version, ReadVerFromStream);
    ItemList.Add(Item);
  end;
end;

procedure TExtensionColorCodeList.SaveToStream(S: TStream; Version: integer = 0; WriteVerToStream: Boolean = False);
var
  i: Integer;
begin
  inherited SaveToStream(S, Version, WriteVerToStream);
  StreamHelper.WriteInteger(S, ItemList.Count);
  for i := 0 to ItemList.Count - 1 do
    Items[i].SaveToStream(S, Version, WriteVerToStream)
end;

procedure TExtensionColorCodeList.SetItems(Index: Integer; Value: TExtensionColorCode);
begin
  ItemList[Index] := Value
end;

{ TExtensionColorCode }
constructor TExtensionColorCode.Create;
begin
  inherited Create;
  Extensions := TStringList.Create;
end;

destructor TExtensionColorCode.Destroy;
begin
  Extensions.Free;
  inherited Destroy;
end;

function TExtensionColorCode.GetExtensionMask: WideString;
begin
  Result := Extensions.CommaText
end;

procedure TExtensionColorCode.LoadFromStream(S: TStream; Version: integer = 0; ReadVerFromStream: Boolean = False);
begin
  inherited;
  FColor := StreamHelper.ReadColor(S);
  FEnabled := StreamHelper.ReadBoolean(S);
  FBold := StreamHelper.ReadBoolean(S);
  FItalic := StreamHelper.ReadBoolean(S);
  FUnderLine := StreamHelper.ReadBoolean(S);
  ExtensionMask := StreamHelper.ReadWideString(S)
end;

procedure TExtensionColorCode.SaveToStream(S: TStream; Version: integer = 0; WriteVerToStream: Boolean = False);
begin
  inherited;
  StreamHelper.WriteColor(S, Color);
  StreamHelper.WriteBoolean(S, Enabled);
  StreamHelper.WriteBoolean(S, Bold);
  StreamHelper.WriteBoolean(S, Italic);
  StreamHelper.WriteBoolean(S, UnderLine);
  StreamHelper.WriteWideString(S, ExtensionMask);
 end;

procedure TExtensionColorCode.SetExtensionMask(const Value: WideString);
begin
  Extensions.CommaText := WideValidateDelimitedExtList(Value, [vdwcPeriod], vdeComma)
end;

{ TExplorerColumn }
procedure TExplorerColumn.LoadFromStream(S: TStream; var AVersion: Integer);
begin
  inherited LoadFromStream(S, AVersion);
  S.ReadBuffer(FIsCustom, SizeOf(FIsCustom));
end;

procedure TExplorerColumn.SaveToStream(S: TStream; AVersion: Integer = EASYLISTVIEW_STREAM_VERSION);
begin
  inherited SaveToStream(S, AVersion);
  S.WriteBuffer(FIsCustom, SizeOf(FIsCustom));
end;

{ TVirtualExplorerEasyListviewHintWindow }
function TVirtualExplorerEasyListviewHintWindow.CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect;
var
  FontHeightR, ResizedResult: TRect;
  Item: TExplorerItem;
  LV: TCustomVirtualExplorerEasyListview;
  T, DummyT: TThumbInfo;
begin
  Result := inherited CalcHintRect(MaxWidth, AHint, AData);
  if [eloQueryInfoHints, eloIncludeThumbnailsWithQueryInfoHints] <= (PEasyHintInfoRec(AData).Listview as TCustomVirtualExplorerEasyListview).Options then
  begin
    if HintInfo.TargetObj is TExplorerItem then
    begin
      Item := TExplorerItem( HintInfo.TargetObj);
      LV := (HintInfo.Listview as TCustomVirtualExplorerEasyListview);
      ResizedResult := Result;
   
      SetRect(FontHeightR, 0, 0, 0, 0);
      DrawTextWEx(Canvas.Handle, 'Ty', FontHeightR, [dtLeft, dtCalcRect, dtSingleLine], 1);

      // Make them all 6 lines tall with 3x3 pixels margin
      ResizedResult.Bottom := Result.Top + (6 * RectHeight(FontHeightR)) + 6;
      // Make the thumbnail width 1.4x the height
      ResizedResult.Right := Result.Left + RectWidth(ResizedResult) + Round( RectHeight(ResizedResult) * 1.4);
      SetRect(FThumbRect, Result.Right + 6, ResizedResult.Top + 6, ResizedResult.Right - 6, ResizedResult.Bottom - 6);

      T := SpCreateThumbInfoFromFile(Item.Namespace, RectWidth(ThumbRect), RectHeight(ThumbRect), True, True, True, True, LV.Color);
      if Assigned(T) then
      try
        if not Assigned(Item.ThumbInfo) then
          Item.ThumbInfo := TThumbInfo.Create;
        if Assigned(Item.ThumbInfo) then
        begin
          Item.ThumbInfo.Assign(T);
          if LV.ValidateThumbnail(Item, DummyT) then
            Result := ResizedResult
        end
      finally
        T.Free
      end
    end
  end
end;

procedure TVirtualExplorerEasyListviewHintWindow.Paint;
var
  Item: TExplorerItem;
  LV: TCustomVirtualExplorerEasyListview;
  T: TThumbInfo;
begin
  inherited Paint;
  Item := TExplorerItem( HintInfo.TargetObj);
  LV := (HintInfo.Listview as TCustomVirtualExplorerEasyListview);
  if LV.ValidateThumbnail(Item, T) then
    T.Draw(Canvas, ThumbRect, talCenter, True);
end;

initialization
  LoadWideFunctions;
  LoadShell32Functions;
  UnknownFolderIconIndex := DefaultSystemImageIndex(diNormalFolder);
  UnknownFileIconIndex := DefaultSystemImageIndex(diUnknownFile);
  RegisterClass(TExplorerColumn);
  RegisterClass(TExplorerItem);
  RegisterClass(TExplorerGroup);
  RegisterClass(TExtensionColorCodeList);

finalization

end.
