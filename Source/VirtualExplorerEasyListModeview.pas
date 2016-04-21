unit VirtualExplorerEasyListModeview;

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

interface

{.$UNDEF USE_TOOLBAR_TB2K}

{$I ..\Include\AddIns.inc}
{$B-}


{.$DEFINE GEXPERTS}

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ShellAPI,
  ShlObj,
  ExtCtrls,
  StdCtrls,
  Menus,
  {$IFDEF GEXPERTS}
  DbugIntf,
  {$ENDIF}
  {$IFDEF SpTBX}
  SpTBXControls,
  SpTBXTabs,
  SpTBXDkPanels,
  SpTBXSkins,
  SpTBXItem,
  TB2Item,
  {$ENDIF}
  Themes,
  UxTheme,
  EasyListview,
  MPThreadManager,
  VirtualResources,
  VirtualExplorerEasyListview,
  MPShellUtilities,
  VirtualExplorerTree,
  VirtualThumbnails,
  MPCommonUtilities,
  VirtualShellNotifier,
  MPCommonObjects;

const
  WIDTH_COLUMN = 200;  // Default Width of Column
  WM_FREEVIEW = WM_APP + 401;
  WM_POSTFOCUSBACKTOVIEW = WM_APP + 402;
  WM_POSTVIEWLOSINGFOCUS = WM_APP + 403;

type
  TListModeViewState = (
    lmvsBrowsing,       // In the middle of a BrowseTo call
    lmvsRebuildingView, // In the middle of a RebuildView call
    lmvsHilightingPath, // In the middle of a HilightPath call
    lmvsChangeLinkChanging,
    lmvsResizedOnce   // The window has been resized at least once
  );
  TListModeViewStates = set of TListModeViewState;

  PDetailInfo = ^TDetailInfo;
  TDetailInfo = record
    Title, Detail: WideString;
    TitleRect, DetailRect: TRect;
  end;

  TDetailInfoArray = array of TDetailInfo;

  //
  //  Forwards
  //                
  TVirtualColumnModeView = class;
  TCustomVirtualColumnModeView = class;
  {$IFNDEF SpTBX}TVirtualSplitter = class;{$ENDIF}
  TVirtualHeaderBar = class;

  //
  // Data Structures
  //
  TListModeLayoutData = record
    {$IFDEF SpTBX} Splitter: TSpTBXSplitter; {$ELSE} Splitter: TVirtualSplitter; {$ENDIF}
    iPosition: Integer;
  end;

  // Custom painter for the Report item, it paints the arrow on the right side when
  // the object is a folder
  TColumnModeViewReportItem = class(TEasyViewReportItem)
  private
    FArrowSize: TSize;
  public
    constructor Create(AnOwner: TEasyGroup); override;
    procedure ItemRectArray(Item: TEasyItem; Column: TEasyColumn; ACanvas: TCanvas; const Caption: WideString; var RectArray: TEasyRectArrayObject); override;
    procedure PaintBefore(Item: TEasyItem; Column: TEasyColumn; const Caption: WideString; ACanvas: TCanvas; RectArray: TEasyRectArrayObject; var Handled: Boolean); override;
    procedure PaintText(Item: TEasyItem; Column: TEasyColumn; const Caption: WideString; RectArray: TEasyRectArrayObject; ACanvas: TCanvas; LinesToDraw: Integer); override;
    property ArrowSize: TSize read FArrowSize write FArrowSize;
  end;

  //
  // The Explorer Listview windows that make up the ListMode Columns
  //
  TColumnModeEasyListview = class(TVirtualExplorerEasyListview)
  private
    FInfo: TListModeLayoutData;
    FColumnModeView: TCustomVirtualColumnModeView; // back reference
  protected
    function GetHeaderVisibility: Boolean; override;
    function GetSortColumn: TEasyColumn; override;
    function LoadStorageToRoot(StorageNode: TNodeStorage): Boolean; override;
    {$IFDEF SpTBX}
    function PaintSpTBXSelection: Boolean; override;
    {$ENDIF SpTBX}
    procedure DoColumnContextMenu(HitInfo: TEasyHitInfoColumn; WindowPoint: TPoint; var Menu: TPopupMenu); override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DoItemCustomView(Item: TEasyItem; ViewStyle: TEasyListStyle; var View: TEasyViewItemClass); override;
    procedure DoKeyAction(var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean); override;
    procedure DoShellNotify(ShellEvent: TVirtualShellEvent); override;
    procedure SaveRootToStorage(StorageNode: TNodeStorage); override;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function BrowseToByPIDL(APIDL: PItemIDList; SelectTarget: Boolean = True; ShowExplorerMsg: Boolean = True): Boolean; override;
    procedure BrowseToPrevLevel; override;

    property ColumnModeView: TCustomVirtualColumnModeView read FColumnModeView write FColumnModeView;
    property Info: TListModeLayoutData read FInfo write FInfo;
  end;
  TListModeEasyListviewClass = class of TColumnModeEasyListview;


  //
  // Window that shows the details of a file in the view
  //
  TListModeDetails = class(TVirtualScrollBox)
  private
    FDetailInfoList: TList;
    FDetailsPaintBox: TPaintBox;
    FExplorerListview: TVirtualExplorerEasyListview;
    FMaxTitleWidthCache: Integer;
    FOldWndProc: TWndMethod;
    FThumbnail: TImage;
    FValidDetails: Boolean;
  protected
    procedure ClearInfoList;
    procedure OnDetailsPaint(Sender: TObject);
    procedure ResizeLabels(NewClientW, NewClientH: Integer);
    procedure ShellExecuteNamespace;
    procedure SplitCaption(ACaption: Widestring; var ATitle: WideString; var ADetail: WideString);
    procedure BuildDetailInfo(Details: TCommonWideStringDynArray);
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMMouseActivate(var Msg: TWMMouseActivate); message WM_MOUSEACTIVATE;
    procedure WindowProcHook(var Msg: TMessage);
    procedure WMWindowPosChanging(var Msg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    property MaxTitleWidthCache: Integer read FMaxTitleWidthCache write FMaxTitleWidthCache;
    property OldWndProc: TWndMethod read FOldWndProc write FOldWndProc;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function MaxTitleWidth(DetailArray: TDetailInfoArray; AFont: TFont): TSize;
    property DetailInfoList: TList read FDetailInfoList write FDetailInfoList;
    property DetailsPaintBox: TPaintBox read FDetailsPaintBox write FDetailsPaintBox;
    property ExplorerListview: TVirtualExplorerEasyListview read FExplorerListview write FExplorerListview;
    property Thumbnail: TImage read FThumbnail write FThumbnail;
    property ValidDetails: Boolean read FValidDetails write FValidDetails;
  end;

   {$IFNDEF SpTBX}
  //
  // A Splitter will size larger then the client window.  A typical splitter will
  // lock up and not allow the child window to get larger then the main client
  //
  TVirtualSplitter = class(TGraphicControl)
  private
    FDownPt: TPoint;
    FDragged: Boolean;
    FLastSize: Integer;
    FLastWidth: Integer;
    FTestControl: TControl;
  protected
    function DoCanResize(var NewSize: Integer): Boolean;
    function FindControl: TControl;
    function VertScrollVisible: Boolean;
    procedure Click; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure Paint; override;
    procedure SetControlWidth(NewSize: Integer);
    property Dragged: Boolean read FDragged write FDragged;
    property LastSize: Integer read FLastSize write FLastSize;
    property LastWidth: Integer read FLastWidth write FLastWidth;
  public
    constructor Create(AOwner: TComponent); override;
  published
    function ExpandCollapseRect: TRect;
    property Cursor default crHSplit;
    property DownPt: TPoint read FDownPt write FDownPt;
    property TestControl: TControl read FTestControl write FTestControl;
  end;
  {$ENDIF}

  //
  // The header that is above the TListModeEasyListview windows
  //
  TVirtualHeaderBarAttributes = class(TPersistent)
  private
    FColor: TColor;
    FFlat: Boolean;
    FFont: TFont;
    FOwner: TVirtualHeaderBar;
    procedure SetColor(const Value: TColor);
    procedure SetFlat(const Value: Boolean);
  public
    constructor Create(AnOwner: TVirtualHeaderBar);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Owner: TVirtualHeaderBar read FOwner;
  published
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Flat: Boolean read FFlat write SetFlat default False;
    property Font: TFont read FFont write FFont;
  end;


  // Custom object that is used in place of the normal EasyListview header for the
  // column mode view
  TVirtualHeaderBar = class(TCommonCanvasControl)
  private
    FBackBits: TBitmap;
    FAttribs: TVirtualHeaderBarAttributes;
    FColumnModeView: TCustomVirtualColumnModeView;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure ResizeBackBits(NewWidth, NewHeight: Integer);
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMWindowPosChanged(var Msg: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMWindowPosChanging(var Msg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    property BackBits: TBitmap read FBackBits write FBackBits;
    property ColumnModeView: TCustomVirtualColumnModeView read FColumnModeView write FColumnModeView;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Attribs: TVirtualHeaderBarAttributes read FAttribs write FAttribs;
  end;

  TItemFocusChangeLMVEvent = procedure(Sender: TCustomVirtualColumnModeView; ListModeView: TCustomEasyListview; Item: TEasyItem) of object;
  TItemFocusChangingLMVEvent = procedure(Sender: TCustomVirtualColumnModeView; ListModeView: TCustomEasyListview; Item: TEasyItem; var Allow: Boolean) of object;
  TItemSelectionChangeLMVEvent = procedure(Sender: TCustomVirtualColumnModeView; ListModeView: TCustomEasyListview; Item: TEasyItem) of object;
  TItemSelectionChangingLMVEvent = procedure(Sender: TCustomVirtualColumnModeView; ListModeView: TCustomEasyListview; Item: TEasyItem; var Allow: Boolean) of object;
  TEasyItemSelectionsChangedLMVEvent = procedure(Sender: TCustomVirtualColumnModeView; ListModeView: TCustomEasyListview) of object;
  TExplorerListviewClassEvent = procedure(Sender: TCustomVirtualColumnModeView; var ViewClass: TListModeEasyListviewClass) of object;
  TListviewEnterEvent = procedure(Sender: TCustomVirtualColumnModeView; Listview: TColumnModeEasyListview) of object;
  TListviewExitEvent = procedure(Sender: TCustomVirtualColumnModeView; Listview: TColumnModeEasyListview) of object;
  TListviewItemMouseDownEvent = procedure(Sender: TCustomVirtualColumnModeView; Listview: TCustomEasyListview; Item: TEasyItem; Button: TCommonMouseButton; var DoDefault: Boolean) of object;
  TListviewItemMouseUpEvent = procedure(Sender: TCustomVirtualColumnModeView; Listview: TCustomEasyListview; Item: TEasyItem; Button: TCommonMouseButton; var DoDefault: Boolean) of object;
  TListviewEnumFolderEvent = procedure(Sender: TCustomVirtualColumnModeView; Listview: TCustomVirtualExplorerEasyListview; Namespace: TNamespace; var AllowAsChild: Boolean) of object;
  TListviewContextMenuEvent = procedure(Sender: TCustomVirtualColumnModeView; Listview: TCustomEasyListview; MousePt: TPoint; var Handled: Boolean) of object;
  TListviewContextMenu2MessageEvent = procedure(Sender: TCustomVirtualColumnModeView; Listview: TCustomVirtualExplorerEasyListview; var Msg: TMessage) of object;
  TListviewDblClickEvent = procedure(Sender: TCustomVirtualColumnModeView; Listview: TCustomEasyListview; Button: TCommonMouseButton; MousePos: TPoint; ShiftState: TShiftState) of object;
  TListviewMouseGestureEvent = procedure(Sender: TCustomVirtualColumnModeView; Listview: TCustomEasyListview; Button: TCommonMouseButton; KeyState: TCommonKeyStates; Gesture: WideString; var DoDefaultMouseAction: Boolean) of object;
  TListviewRootChangeLMVEvent = procedure(Sender: TCustomVirtualColumnModeView; Listview: TCustomVirtualExplorerEasyListview) of object;
  TColumnModeRebuildEvent = procedure(Sender: TCustomVirtualColumnModeView) of object;
  TColumnModeViewRebuildingEvent = procedure(Sender: TCustomVirtualColumnModeView) of object;
  TColumnModeViewAddedEvent = procedure(Sender: TCustomVirtualColumnModeView; NewView: TColumnModeEasyListview) of object;
  TColumnModeViewFreeingEvent = procedure(Sender: TCustomVirtualColumnModeView; View: TColumnModeEasyListview) of object;
  TColumnModeviewMouseUp = procedure(Sender: TCustomVirtualColumnModeView; View: TColumnModeEasyListview; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TColumnModePathChangingEvent = procedure(Sender: TCustomVirtualColumnModeView; NewPath, OldPath: TNamespace; var Allow: Boolean) of object;
  TColumnModePathChangeEvent = procedure(Sender: TCustomVirtualColumnModeView; NewPath: TNamespace) of object;

  TCustomVirtualColumnModeView = class(TScrollBox)
  private
    FActive: Boolean;
    FBandHilight: Boolean;
    FBandHilightColor: TColor;
    FCachedScrollPos: Integer;
    FDefaultColumnWidth: Integer;
    FDefaultSortColumn: Integer;
    FDefaultSortDir: TEasySortDirection;
    FFileObjects: TFileObjects;
    FFreeViewList: TList;
    FDetails: TListModeDetails;
  {$IFDEF EXPLORERCOMBOBOX_L}
    FExplorerCombobox: TVirtualExplorerCombobox;
  {$ENDIF}
    FGrouped: Boolean;
    FGroupingColumn: Integer;
    FHeaderBar: TVirtualHeaderBar;
    FHilightActiveColumn: Boolean;
    FHilightColumnColor: TColor;
    FHintType: TEasyHintType;
    FLastFocusedView: TColumnModeEasyListview;
    FOldFontChangeEvent: TNotifyEvent;
    FOnItemFocusChange: TItemFocusChangeLMVEvent;
    FOnItemFocusChanging: TItemFocusChangingLMVEvent;
    FOnItemSelectionChange: TItemSelectionChangeLMVEvent;
    FOnItemSelectionChanging: TItemSelectionChangingLMVEvent;
    FOnItemSelectionsChange: TEasyItemSelectionsChangedLMVEvent;
    FOnListviewClass: TExplorerListviewClassEvent;
    FOnListviewContextMenu: TListviewContextMenuEvent;
    FOnListviewContextMenu2Message: TListviewContextMenu2MessageEvent;
    FOnListviewDblClick: TListviewDblClickEvent;
    FOnListviewEnter: TListviewEnterEvent;
    FOnListviewEnumFolder: TListviewEnumFolderEvent;
    FOnListviewExit: TListviewExitEvent;
    FOnListviewItemMouseDown: TListviewItemMouseDownEvent;
    FOnListviewItemMouseUp: TListviewItemMouseUpEvent;
    FOnListviewRootChanged: TListviewRootChangeLMVEvent;
    FOnListviewMouseGesture: TListviewMouseGestureEvent;
    FOnPathChange: TColumnModePathChangeEvent;
    FOnPathChanging: TColumnModePathChangingEvent;
    FOnRebuild: TColumnModeRebuildEvent;
    FOnRebuilding: TColumnModeViewRebuildingEvent;
    FOnViewAdded: TColumnModeViewAddedEvent;
    FOnViewFreeing: TColumnModeViewFreeingEvent;
    FOnViewMouseUp: TColumnModeViewMouseUp;
    FOptions: TVirtualEasyListviewOptions;
    FPath: TNamespace;
    FRedrawLockCount: Integer;
    FResetDragPendings: Boolean;
    FSelectionChangeTimeInterval: Word;
    FSelectionChangeTimer: TTimer;
    FShellThumbnailExtraction: Boolean;
    FShowInactive: Boolean;
    FSmoothScrollDelta: Integer;
    FSortFolderFirstAlways: Boolean;
    FState: TListModeViewStates;
    FViewList: TList;
    function GetFocusedView: TColumnModeEasyListview;
    function GetHeader: TVirtualHeaderBarAttributes;
    function GetViews(Index: Integer): TColumnModeEasyListview;
    function GetViewCount: Integer;
    procedure SetActive(const Value: Boolean);
    procedure SetBandHilight(const Value: Boolean);
    procedure SetBandHilightColor(const Value: TColor);
    procedure SetDefaultColumnWidth(const Value: Integer);
    procedure SetDefaultSortColumn(const Value: Integer);
    procedure SetDefaultSortDir(const Value: TEasySortDirection);
  {$IFDEF EXPLORERCOMBOBOX_L}
    procedure SetExplorerCombobox(const Value: TVirtualExplorerCombobox);
  {$ENDIF}
    procedure SetFileObjects(const Value: TFileObjects);
    procedure SetGrouped(const Value: Boolean);
    procedure SetGroupingColumn(const Value: Integer);
    procedure SetHeader(const Value: TVirtualHeaderBarAttributes);
    procedure SetHilightActiveColumn(const Value: Boolean);
    procedure SetHilightColumnColor(const Value: TColor);
    procedure SetHintType(const Value: TEasyHintType);
    procedure SetOptions(const Value: TVirtualEasyListviewOptions);
    procedure SetPath(const Value: TNamespace);
    procedure SetSelectionChangeTimeInterval(const Value: Word);
    procedure SetShowInactive(const Value: Boolean);
    procedure SetSortFolderFirstAlways(const Value: Boolean);
    procedure SetViews(Index: Integer; Value: TColumnModeEasyListview);
  protected
    function AddView(PIDL: PItemIDList; AWidth: Integer): TColumnModeEasyListview; virtual;
    function ViewNamespace(Index: Integer): TNamespace;
    {$IFDEF SpTBX}
    function ViewSplitter(Index: Integer): TSpTBXSplitter;
    {$ELSE}
    function ViewSplitter(Index: Integer): TVirtualSplitter;
    {$ENDIF}
    procedure ClearViews;
    procedure CMColorChanged(var Msg: TMessage); message CM_COLORCHANGED;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DeleteListview(Item: TColumnModeEasyListview);
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DoItemFocusChange(Sender: TCustomEasyListview; Item: TEasyItem); virtual;
    procedure DoItemFocusChanging(ListModeView: TCustomEasyListview; Item: TEasyItem; var Allow: Boolean); virtual;
    procedure DoItemSelectionChange(ListModeView: TCustomEasyListview; Item: TEasyItem); virtual;
    procedure DoItemSelectionChanging(ListModeView: TCustomEasyListview; Item: TEasyItem; var Allow: Boolean); virtual;
    procedure DoItemSelectionsChange(ListModeView: TCustomEasyListview); virtual;
    procedure DoListModeEasyListviewClass(var ViewClass: TListModeEasyListviewClass);
    procedure DoListviewContextMenu(Sender: TCustomEasyListview; MousePt: TPoint; var Handled: Boolean); virtual;
    procedure DoListviewContextMenu2Message(Sender: TCustomVirtualExplorerEasyListview; var Msg: TMessage); virtual;
    procedure DoListviewDbkClick(Sender: TCustomEasyListview; Button: TCommonMouseButton; MousePos: TPoint; ShiftState: TShiftState; var Handled: Boolean); virtual;
    procedure DoListviewEnter(Listview: TColumnModeEasyListview);
    procedure DoListviewEnumFolder(Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace; var AllowAsChild: Boolean);
    procedure DoListviewExit(Listview: TColumnModeEasyListview);
    procedure DoListviewItemMouseDown(Sender: TCustomEasyListview; Item: TEasyItem; Button: TCommonMouseButton; var DoDefault: Boolean); virtual;
    procedure DoListviewItemMouseUp(Sender: TCustomEasyListview; Item: TEasyItem; Button: TCommonMouseButton; var DoDefault: Boolean); virtual;
    procedure DoListviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoListviewMouseGesture(Sender: TCustomEasyListview; Button: TCommonMouseButton; KeyState: TCommonKeyStates; Gesture: WideString; var DoDefaultMouseAction: Boolean); virtual;
    procedure DoListviewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoListviewRootChange(Listview: TCustomVirtualExplorerEasyListview); virtual;
    procedure DoPathChanged(NewPath: TNamespace); virtual;
    procedure DoPathChanging(OldPath, NewPath: TNamespace; var Allow: Boolean); virtual;
    procedure DoRebuild; virtual;
    procedure DoRebuilding; virtual;
    procedure DoViewAdded(NewView: TColumnModeEasyListview); virtual;
    procedure DoViewDeleting(View: TColumnModeEasyListview); virtual;
    procedure EnterWindow(Sender: TObject);
    procedure ExitWindow(Sender: TObject);
    procedure FlushFreeViewList(FlushQueue: Boolean);
    procedure FontChanging(Sender: TObject);
    procedure FreeView(View: TColumnModeEasyListview);
    procedure ItemFocusChange(Sender: TCustomEasyListview; Item: TEasyItem);
    procedure ItemFocusChanging(Sender: TCustomEasyListview; Item: TEasyItem; var Allow: Boolean);
    procedure ItemSelectionChange(Sender: TCustomEasyListview; Item: TEasyItem);
    procedure ItemSelectionChanging(Sender: TCustomEasyListview; Item: TEasyItem; var Allow: Boolean);
    procedure ItemSelectionsChange(Sender: TCustomEasyListview);
    procedure ListviewContextMenu(Sender: TCustomEasyListview; MousePt: TPoint; var Handled: Boolean);
    procedure ListviewContextMenu2Message(Sender: TCustomVirtualExplorerEasyListview; var Msg: TMessage);
    procedure ListviewDblClick(Sender: TCustomEasyListview; Button: TCommonMouseButton; MousePos: TPoint; ShiftState: TShiftState; var Handled: Boolean);
    procedure ListviewEnumFolder(Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace; var AllowAsChild: Boolean);
    procedure ListviewItemFreeing(Sender: TCustomEasyListview; Item: TEasyItem);
    procedure ListviewItemMouseDown(Sender: TCustomEasyListview; Item: TEasyItem; Button: TCommonMouseButton; var DoDefault: Boolean); virtual;
    procedure ListviewItemMouseUp(Sender: TCustomEasyListview; Item: TEasyItem; Button: TCommonMouseButton; var DoDefault: Boolean); virtual;
    procedure ListviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListviewMouseGesture(Sender: TCustomEasyListview; Button: TCommonMouseButton; KeyState: TCommonKeyStates; Gesture: WideString; var DoDefaultMouseAction: Boolean);
    procedure ListviewResize(Sender: TObject);
    procedure ListviewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListviewRootChange(Sender: TCustomVirtualExplorerEasyListview);
    procedure RebuildView;
    procedure RemoveView(Index: Integer);
    procedure ScrollbarSetPosition(NewPos: Integer);
    procedure ScrollLeft;
    procedure ScrollRight;
    procedure SelectionChangeTimerEvent(Sender: TObject);
    procedure ShellExecute(Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace; var WorkingDir: WideString; var CmdLineArgument: WideString; var Allow: Boolean);
    procedure TestForRebuild(Sender: TObject);
    procedure WMDestroy(var Msg: TMessage); message WM_DESTROY;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMFreeView(var Msg: TMessage); message WM_FREEVIEW;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMMouseActivate(var Msg: TWMMouseActivate); message WM_MOUSEACTIVATE;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMPostFocusBackToView(var Msg: TMessage); message WM_POSTFOCUSBACKTOVIEW;
    {$IFDEF SpTBX}
    procedure WMSpSkinChange(var Msg: TMessage); message WM_SPSKINCHANGE;
    {$ENDIF SpTBX}
    procedure WMPostViewLosingFocus(var Msg: TMessage); message WM_POSTVIEWLOSINGFOCUS;
    procedure WMThreadCallback(var Msg: TWMThreadRequest); message WM_COMMONTHREADCALLBACK;
    procedure WMWindowPosChanged(var Msg: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    property Active: Boolean read FActive write SetActive default False;
    property FocusedView: TColumnModeEasyListview read GetFocusedView;
    property BandHilight: Boolean read FBandHilight write SetBandHilight default False;
    property BandHilightColor: TColor read FBandHilightColor write SetBandHilightColor default $00F7F7F7;
    property CachedScrollPos: Integer read FCachedScrollPos write FCachedScrollPos;
    property DefaultColumnWidth: Integer read FDefaultColumnWidth write SetDefaultColumnWidth default WIDTH_COLUMN;
    property DefaultSortColumn: Integer read FDefaultSortColumn write SetDefaultSortColumn default 0;
    property DefaultSortDir: TEasySortDirection read FDefaultSortDir write SetDefaultSortDir default esdNone;
    property Details: TListModeDetails read FDetails write FDetails;
  {$IFDEF EXPLORERCOMBOBOX_L}
    property ExplorerCombobox: TVirtualExplorerCombobox read FExplorerCombobox write SetExplorerCombobox;
  {$ENDIF}
    property FileObjects: TFileObjects read FFileObjects write SetFileObjects default [foFolders, foNonFolders];
    property FreeViewList: TList read FFreeViewList write FFreeViewList;
    property Grouped: Boolean read FGrouped write SetGrouped;
    property GroupingColumn: Integer read FGroupingColumn write SetGroupingColumn;
    property Header: TVirtualHeaderBarAttributes read GetHeader write SetHeader;
    property HeaderBar: TVirtualHeaderBar read FHeaderBar write FHeaderBar;
    property HilightActiveColumn: Boolean read FHilightActiveColumn write SetHilightActiveColumn default False;
    property HilightColumnColor: TColor read FHilightColumnColor write SetHilightColumnColor default $00F7F7F7;
    property HintType: TEasyHintType read FHintType write SetHintType default ehtText;
    property LastFocusedView: TColumnModeEasyListview read FLastFocusedView write FLastFocusedView;
    property OldFontChangeEvent: TNotifyEvent read FOldFontChangeEvent write FOldFontChangeEvent;
    property OnItemFocusChange: TItemFocusChangeLMVEvent read FOnItemFocusChange write FOnItemFocusChange;
    property OnItemFocusChanging: TItemFocusChangingLMVEvent read FOnItemFocusChanging write FOnItemFocusChanging;
    property OnItemSelectionChange: TItemSelectionChangeLMVEvent read FOnItemSelectionChange write FOnItemSelectionChange;
    property OnItemSelectionChanging: TItemSelectionChangingLMVEvent read FOnItemSelectionChanging write FOnItemSelectionChanging;
    property OnItemSelectionsChange: TEasyItemSelectionsChangedLMVEvent read FOnItemSelectionsChange write FOnItemSelectionsChange;
    property OnListviewClass: TExplorerListviewClassEvent read FOnListviewClass write FOnListviewClass;
    property OnListviewContextMenu: TListviewContextMenuEvent read FOnListviewContextMenu write FOnListviewContextMenu;
    property OnListviewContextMenu2Message: TListviewContextMenu2MessageEvent read FOnListviewContextMenu2Message write FOnListviewContextMenu2Message;
    property OnListviewDblClick: TListviewDblClickEvent read FOnListviewDblClick write FOnListviewDblClick;
    property OnListviewEnter: TListviewEnterEvent read FOnListviewEnter write FOnListviewEnter;
    property OnListviewEnumFolder: TListviewEnumFolderEvent read FOnListviewEnumFolder write FOnListviewEnumFolder;
    property OnListviewExit: TListviewExitEvent read FOnListviewExit write FOnListviewExit;
    property OnListviewItemMouseDown: TListviewItemMouseDownEvent read FOnListviewItemMouseDown write FOnListviewItemMouseDown;
    property OnListviewItemMouseUp: TListviewItemMouseUpEvent read FOnListviewItemMouseUp write FOnListviewItemMouseUp;
    property OnListviewMouseGesture: TListviewMouseGestureEvent read FOnListviewMouseGesture write FOnListviewMouseGesture;
    property OnListviewRootChange: TListviewRootChangeLMVEvent read FOnListviewRootChanged write FOnListviewRootChanged;
    property OnPathChange: TColumnModePathChangeEvent read FOnPathChange write FOnPathChange;
    property OnPathChanging: TColumnModePathChangingEvent read FOnPathChanging write FOnPathChanging;
    property OnRebuild: TColumnModeRebuildEvent read FOnRebuild write FOnRebuild;
    property OnRebuilding: TColumnModeViewRebuildingEvent read FOnRebuilding write FOnRebuilding;
    property OnViewAdded: TColumnModeViewAddedEvent read FOnViewAdded write FOnViewAdded;
    property OnViewFreeing: TColumnModeViewFreeingEvent read FOnViewFreeing write FOnViewFreeing;
    property OnViewMouseUp: TColumnModeViewMouseUp read FOnViewMouseUp write FOnViewMouseUp;
    property Options: TVirtualEasyListviewOptions read FOptions write SetOptions default [eloBrowseExecuteFolder, eloBrowseExecuteFolderShortcut, eloBrowseExecuteZipFolder, eloExecuteOnDblClick, eloThreadedImages, eloThreadedDetails];
    property Path: TNamespace read FPath write SetPath;
    property RedrawLockCount: Integer read FRedrawLockCount write FRedrawLockCount;
    property ResetDragPendings: Boolean read FResetDragPendings write FResetDragPendings;
    property SelectionChangeTimeInterval: Word read FSelectionChangeTimeInterval write SetSelectionChangeTimeInterval default 300;
    property SelectionChangeTimer: TTimer read FSelectionChangeTimer write FSelectionChangeTimer;
    property ShellThumbnailExtraction: Boolean read FShellThumbnailExtraction write FShellThumbnailExtraction default False;
    property ShowInactive: Boolean read FShowInactive write SetShowInactive default False;
    property SmoothScrollDelta: Integer read FSmoothScrollDelta write FSmoothScrollDelta default 0;
    property SortFolderFirstAlways: Boolean read FSortFolderFirstAlways write SetSortFolderFirstAlways default False;
    property State: TListModeViewStates read FState write FState;
    property ViewCount: Integer read GetViewCount;
    property ViewList: TList read FViewList write FViewList;
    property Views[Index: Integer]: TColumnModeEasyListview read GetViews write SetViews; default;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function BrowseToPrevLevel: Boolean;
    function FindFirstQuickFilteredView: TColumnModeEasyListview;
    procedure ChangeLinkChanging(Server: TObject; NewPIDL: PItemIDList); dynamic; // ChangeLink method
    procedure ChangeLinkDispatch; virtual;
    {$IFDEF EXPLORERCOMBOBOX_L}
    procedure ChangeLinkFreeing(ChangeLink: IVETChangeLink); dynamic;
    {$ENDIF EXPLORERCOMBOBOX_L}
    function BrowseTo(APIDL: PItemIDList): Boolean;
    procedure ClearSelections;
    procedure ClickColumn(ColumnIndex: Integer);
    procedure Flush;
    procedure FlushThreadRequests;
    procedure HilightPath(PIDL: PItemIDList);
    procedure LockRedraw;
    procedure Rebuild;
    procedure SortOnColumn(Index: Integer);
    procedure ToggleSortDir;
    procedure UnLockRedraw;
  end;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualColumnModeView = class(TCustomVirtualColumnModeView)
  private
  public
    property FocusedView;
    property Details;
    property HeaderBar;
    property LastFocusedView;
    property Path;
    property State;
    property ViewCount;
    property Views;
  published
    property Active;
    property BandHilight;
    property BandHilightColor;
    property Color;
    property Cursor;
    property DefaultColumnWidth;
    property DefaultSortColumn;
    property DefaultSortDir;
  {$IFDEF EXPLORERCOMBOBOX_L}
    property ExplorerCombobox;
  {$ENDIF}
    property FileObjects;
    property Grouped;
    property GroupingColumn;
    property HilightActiveColumn;
    property HilightColumnColor;
    property HintType;
    property OnEnter;
    property OnExit;
    property OnItemFocusChange;
    property OnItemFocusChanging;
    property OnItemSelectionChange;
    property OnItemSelectionChanging;
    property OnItemSelectionsChange;
    property OnListviewClass;
    property OnListviewContextMenu;
    property OnListviewContextMenu2Message;
    property OnListviewDblClick;
    property OnListviewEnter;
    property OnListviewEnumFolder;
    property OnListviewExit;
    property OnListviewItemMouseDown;
    property OnListviewItemMouseUp;
    property OnListviewMouseGesture;
    property OnListviewRootChange;
    property OnPathChange;
    property OnPathChanging;
    property OnRebuild;
    property OnRebuilding;
    property OnViewAdded;
    property OnViewFreeing;
    property OnViewMouseUp;
    property Options;
    property SelectionChangeTimeInterval;
    property ShellThumbnailExtraction;
    property ShowInactive;
    property SmoothScrollDelta;
    property SortFolderFirstAlways;
  end;

implementation

uses
  System.Types, System.UITypes;

type
  TEasyListviewHack = class(TCustomEasyListview);
  TEasySelectionManagerHack = class(TEasySelectionManager);
  TCustomVirtualExplorerEasyListviewHack = class(TCustomVirtualExplorerEasyListview);

{$IFNDEF SpTBX}

{TVirtualSplitter}
constructor TVirtualSplitter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Cursor := crHSplit;
  Width := 5;
end;

function TVirtualSplitter.DoCanResize(var NewSize: Integer): Boolean;
begin
  if Assigned(TestControl) then
  begin
    if NewSize <= GetSystemMetrics(SM_CXVSCROLL) then
      NewSize := 0;
    LastSize := NewSize;
    Result := True
  end else
    Result := False;
end;

function TVirtualSplitter.ExpandCollapseRect: TRect;
begin
  Result := Rect(0, Height div 2 - 12, Width, Height div 2 + 12)
end;

function TVirtualSplitter.FindControl: TControl;
var
  I: Integer;
  View: TColumnModeEasyListview;
begin
  Result := nil;
  for I := 0 to Parent.ControlCount - 1 do
  begin
    Result := Parent.Controls[I];
    if Result.Visible and Result.Enabled and (Result is TColumnModeEasyListview) then
    begin
      View := TColumnModeEasyListview(Result);
      if View.Info.Splitter = Self then
        Exit
    end;
  end;
end;

procedure TVirtualSplitter.Click;
var
  Control: TControl;
begin
  if PtInRect(ExpandCollapseRect, DownPt) and not Dragged then
  begin
    Control := FindControl;
    if Assigned(Control) then
    begin
      if Control.Width > 0 then
      begin
        LastWidth := Control.Width;
        SetControlWidth(0);
      end else
        SetControlWidth(LastWidth);
    end
  end
end;

procedure TVirtualSplitter.Paint;
var
  CenterV, CenterH, i: Integer;
  R: TRect;
begin
  Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(ClientRect);
  CenterV := Height div 2;
  CenterH := Width div 2;

  R := Rect(CenterH - 1, CenterV - 1, CenterH + 2, CenterV + 2);
  OffsetRect(R, 0, -12);

  for i := 0 to 6 do
  begin
    Canvas.Brush.Color := clWhite;
    Canvas.FillRect(R);
    Canvas.Brush.Color := clDkGray;
    Canvas.FrameRect(R);

    Canvas.Pen.Color := clSilver;
    Canvas.MoveTo(R.BottomRight.X - 1, R.BottomRight.Y - 1);
    Canvas.LineTo(R.BottomRight.X - 4, R.BottomRight.Y - 1);
    Canvas.MoveTo(R.BottomRight.X - 1, R.BottomRight.Y - 1);
    Canvas.LineTo(R.BottomRight.X - 1, R.BottomRight.Y - 4);

    OffsetRect(R, 0, 4);
  end
end;

procedure TVirtualSplitter.SetControlWidth(NewSize: Integer);
var
  WasZeroWidth: Boolean;
begin
  WasZeroWidth := TestControl.Width = 0;
  TestControl.Width := NewSize;
  if WasZeroWidth and (NewSize > 0) then
    TestControl.Left := Left - 1;
end;

function TVirtualSplitter.VertScrollVisible: Boolean;
begin
  if Assigned(TestControl) then
    Result := GetWindowLong(TWinControl( TestControl).Handle, GWL_STYLE) and WS_VSCROLL <> 0
  else
    Result := False
end;

procedure TVirtualSplitter.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  if ssLeft in Shift then
  begin
    Dragged := False;
    DownPt := Point(X, Y);
    TestControl := FindControl;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TVirtualSplitter.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
var
  NewSize: Integer;
begin
  if ssLeft in Shift then
  begin
    if TestControl.Width > 0 then
      NewSize := X - DownPt.X + TestControl.Width
    else
    if X > DownPt.X then
      NewSize := X - DownPt.X;

    if DoCanResize(NewSize) then
    begin
      Dragged := True;
      SetControlWidth(NewSize);
    end;
  end;
  inherited MouseMove(Shift, X, Y);
end;
{$ENDIF}


{ TListModeView }

constructor TCustomVirtualColumnModeView.Create(AOwner: TComponent);
//
// Do not do anything here that will cause RebuildView to be called.
//
begin
  inherited Create(AOwner);
  FPath := TNamespace.Create(nil, nil);
  FDetails := TListModeDetails.Create(nil);
  Options := [eloBrowseExecuteFolder, eloBrowseExecuteFolderShortcut, eloBrowseExecuteZipFolder, eloExecuteOnDblClick, eloThreadedImages, eloThreadedDetails];
  FViewList := TList.Create;
  HeaderBar := TVirtualHeaderBar.Create(Self);
  HeaderBar.Height := 17;
  HeaderBar.Align := alTop;
  HeaderBar.Parent := Self;
  HorzScrollBar.Tracking := True;
  HilightActiveColumn := False;
  HilightColumnColor := $00F7F7F7;
  FFreeViewList := TList.Create;
  VertScrollBar.Tracking := True;
  VertScrollBar.Smooth := True;
  OldFontChangeEvent := Font.OnChange;
  Font.OnChange := FontChanging;
  FDefaultColumnWidth := WIDTH_COLUMN;
  Color := clWindow;
  TabStop := True;
  FFileObjects := [foFolders, foNonFolders];
  FBandHilightColor := $00F7F7F7;
  SelectionChangeTimer := TTimer.Create(Self);
  SelectionChangeTimer.OnTimer := SelectionChangeTimerEvent;
  SelectionChangeTimer.Enabled := False;
  FSelectionChangeTimeInterval := 300;
  SelectionChangeTimer.Interval := SelectionChangeTimeInterval;
  {$IFDEF SpTBX}
  SkinManager.AddSkinNotification(Self);
  {$ENDIF}
end;

destructor TCustomVirtualColumnModeView.Destroy;
begin
  {$IFDEF SpTBX}
  SkinManager.RemoveSkinNotification(Self);
  {$ENDIF SpTBX}
  {$IFDEF EXPLORERCOMBOBOX_L}
  ExplorerComboBox := nil;
  {$ENDIF}
  ClearViews;
  Font.OnChange := OldFontChangeEvent;
  inherited Destroy;
  FreeAndNil(FViewList);
  FreeAndNil(FPath);
  FreeAndNil(FDetails);
  FreeAndNil(FFreeViewList);
end;

function TCustomVirtualColumnModeView.AddView(PIDL: PItemIDList; AWidth: Integer): TColumnModeEasyListview;
//
// Pass a nil for the desktop View
//
var
  {$IFDEF SpTBX}
  Splitter: TSpTBXSplitter;
  PrevSplitter: TSpTBXSplitter;
  {$ELSE}
  Splitter: TVirtualSplitter;
  PrevSplitter: TVirtualSplitter;
  {$ENDIF}
  PrevView: TColumnModeEasyListview;
  NextLeft: Integer;
  ViewClass: TListModeEasyListviewClass;
begin
  NextLeft := 0;
  DoListModeEasyListviewClass(ViewClass);
  Result := ViewClass.Create(Self);
  Result.Visible := False;
  if ViewCount > 0 then
  begin
    PrevView := Views[ViewCount - 1];
    PrevSplitter := PrevView.Info.Splitter;
    NextLeft := PrevSplitter.Left + PrevSplitter.Width
  end;
  Result.FColumnModeView := Self;
  Result.Selection.FirstItemFocus := False;
  Result.FileObjects := FileObjects;
  Result.Parent := Self;
  Result.Active := False;
  Result.ShowThemedBorder := True;
  Result.Themed := True;
  Result.Sort.AutoSort := True;
  Result.Left := NextLeft;
  Result.Align := alLeft;
  Result.SortFolderFirstAlways := SortFolderFirstAlways;
  Result.DefaultSortColumn := DefaultSortColumn;
  Result.DefaultSortDir := DefaultSortDir;
  if AWidth < 0 then
    Result.Width := WIDTH_COLUMN
  else
    Result.Width := AWidth;
  Result.View := elsReport;
  Result.TabStop := False;  // Handed by the container
  Result.Header.Visible := False;
  Result.Header.FixedSingleColumn := True;
  Result.TestVisiblilityForSingleColumn;
  Result.Options := Options + [eloShellContextMenus, eloGhostHiddenFiles] - [eloThreadedDetails];
  Result.DefaultSortColumn := DefaultSortColumn;
  Result.DefaultSortDir := DefaultSortDir;
  Result.HintType := HintType;
  Result.Selection.FullCellPaint := True;
  Result.Selection.MultiSelect := True;
  Result.Selection.EnableDragSelect := True;
  Result.Selection.AlphaBlendSelRect := True;
  Result.Selection.FullRowSelect := True;
  Result.Selection.RoundRect := True;
  Result.Selection.AlphaBlend := True;
  Result.Selection.UseFocusRect := False;
  Result.Selection.PopupMode := Assigned(FocusedView);
  Result.EditManager.Enabled := True;
  Result.DragManager.Enabled := True;
  Result.ShowThemedBorder := False;
  Result.IncrementalSearch.Enabled := True;
  Result.Selection.GroupSelections := True;
  Result.OnShellExecute := ShellExecute;
  Result.OnItemFocusChanged := ItemFocusChange;
  Result.OnItemFocusChanging := ItemFocusChanging;
  Result.OnItemSelectionChanged := ItemSelectionChange;
  Result.OnItemSelectionChanging := ItemSelectionChanging;
  Result.OnItemSelectionsChanged := ItemSelectionsChange;
  Result.OnItemMouseDown := ListviewItemMouseDown;
  Result.OnItemMouseUp := ListviewItemMouseUp;
  Result.OnDblClick := ListviewDblClick;
  Result.OnMouseGesture := ListviewMouseGesture;
  Result.OnRootChange := ListviewRootChange;
  Result.OnMouseUp := ListviewMouseUp;
  Result.OnEnumFolder := ListviewEnumFolder;
  Result.OnMouseDown := ListviewMouseDown;
  Result.OnContextMenu := ListviewContextMenu;
  Result.OnContextMenu2Message := ListviewContextMenu2Message;
  Result.OnItemFreeing := ListviewItemFreeing;
  Result.OnResize := ListviewResize;
  Result.OnEnter := EnterWindow;
  Result.OnExit := ExitWindow;
  Result.Selection.BlendIcon := False;
  Result.Visible := True;
  Result.Color := Color;
  {$IFDEF SpTBX}
  Splitter := TSpTBXSplitter.Create(nil);
  Splitter.AutoCalcMaxSize := False;
 // Splitter.MinSize := GetSystemMetrics(SM_CYVSCROLL) + 4 + 2 * BorderWidth;
  {$ELSE}
  Splitter := TVirtualSplitter.Create(nil);
 // Splitter.Constraints.MinWidth := GetSystemMetrics(SM_CYVSCROLL) + 4 + 2 * BorderWidth;
  {$ENDIF}
  Splitter.Align := alLeft;
  Splitter.Left := Result.Left + Result.Width;
  Splitter.Parent := Self;
  Result.FInfo.Splitter := Splitter;
  ViewList.Add(Result);
  DoViewAdded(Result)
end;

function TCustomVirtualColumnModeView.FindFirstQuickFilteredView: TColumnModeEasyListview;
var
  i: Integer;
begin
  Result := nil;
  i := 0;
  while not Assigned(Result) and (i < ViewCount) do
  begin
    if Views[i].QuickFiltered then
      Result := Views[i];
    Inc(i)
  end
end;

function TCustomVirtualColumnModeView.GetFocusedView: TColumnModeEasyListview;
var
  i: Integer;
begin
  Result := nil;
  i := 0;
  while not Assigned(Result) and (i < ViewCount) do
  begin
    if Views[i].Focused and Assigned(ViewNamespace(i)) then
      Result := Views[i];
    Inc(i)
  end
end;

function TCustomVirtualColumnModeView.GetHeader: TVirtualHeaderBarAttributes;
begin
  Result := HeaderBar.Attribs
end;

function TCustomVirtualColumnModeView.GetViews(Index: Integer): TColumnModeEasyListview;
begin
  Result := TColumnModeEasyListview( ViewList[Index])
end;

function TCustomVirtualColumnModeView.GetViewCount: Integer;
begin
  Result := ViewList.Count
end;

function TCustomVirtualColumnModeView.BrowseTo(APIDL: PItemIDList): Boolean;
var
  ChangePath: Boolean;
begin
  Result := False;
  if not (lmvsRebuildingView in State) then
  begin
    Include(FState, lmvsBrowsing);
    try
      if Assigned(Path) then
        ChangePath := Path.ComparePIDL(APIDL, True) <> 0
      else
        ChangePath := True;

      if ChangePath then
      begin
        ClearSelections;
        Path := TNamespace.Create(PIDLMgr.CopyPIDL(APIDL), nil);
        HilightPath(Path.AbsolutePIDL);
        HeaderBar.Invalidate;
        HeaderBar.Update;
      end
    finally
      Exclude(FState, lmvsBrowsing);
      Result := Path.ComparePIDL(APIDL, True) = 0
    end
  end
end;

function TCustomVirtualColumnModeView.BrowseToPrevLevel: Boolean;
var
  NS: TNamespace;
begin
  Result := False;
  if not Path.IsDesktop then
  begin
    NS := Path.Parent.Clone(True);
    Path := NS;
    Result := Path.ComparePIDL(NS.AbsolutePIDL, True) = 0;
    HilightPath(nil);
    if Path.IsDesktop and Assigned(FocusedView) then
      FocusedView.Selection.ClearAll;
    HeaderBar.Invalidate;
  end
end;

procedure TCustomVirtualColumnModeView.ChangeLinkChanging(Server: TObject; NewPIDL: PItemIDList);
var
  DoBrowse: Boolean;
  Desktop: IShellFolder;
  LastID: PItemIDList;
  OldCB: Word;
begin
  { Keep from recursively trying to respond to a notify if more than one        }
  { control has been registered with this instance as the client. Once is       }
  { enough and necessary.  VT can get out of wack if you try to call selection  }
  { methods recursively.                                                        }
  if ([lmvsRebuildingView, lmvsChangeLinkChanging] * State = []) and not ShowInactive then
  begin
    Include(FState, lmvsChangeLinkChanging);
    try
      if Assigned(NewPIDL) and Assigned(Path) and not(csDesigning in ComponentState) then
      begin
        SHGetDesktopFolder(Desktop);
        PIDLMgr.StripLastID(NewPIDL, OldCB, LastID);
        try
          DoBrowse := ShortInt(Desktop.CompareIDs(0, Path.AbsolutePIDL, NewPIDL)) <> 0;
          if DoBrowse then
            BrowseTo(NewPIDL);
        finally
          LastID.mkid.cb := OldCB
        end;
        HilightPath(NewPIDL);
        RebuildView;
      end;
    finally
      Exclude(FState, lmvsChangeLinkChanging);
    end
  end

end;

procedure TCustomVirtualColumnModeView.ChangeLinkDispatch;
begin
  Include(FState, lmvsBrowsing);
  if Assigned(Path) and Assigned(VETChangeDispatch) and not ([lmvsRebuildingView, lmvsHilightingPath] * FState = []) then
    VETChangeDispatch.DispatchChange(Self, Path.AbsolutePIDL);
  Exclude(FState, lmvsBrowsing);
end;

{$IFDEF EXPLORERCOMBOBOX_L}
procedure TCustomVirtualColumnModeView.ChangeLinkFreeing(ChangeLink: IVETChangeLink);
begin
   if Assigned(ChangeLink) then
    if (ChangeLink.ChangeLinkClient = Self) and (ChangeLink.ChangeLinkServer = FExplorerCombobox) then
      FExplorerCombobox := nil;
end;
{$ENDIF EXPLORERCOMBOBOX_L}

procedure TCustomVirtualColumnModeView.ClearSelections;
var
  i: Integer;
begin
  for i := 0 to ViewCount - 1 do
    Views[i].Selection.ClearAll;
end;

procedure TCustomVirtualColumnModeView.ClickColumn(ColumnIndex: Integer);
var
  i: Integer;
begin
  // TODO Rebuild??  Test!!!!!
  for i := 0 to ViewCount - 1 do
  begin
    if (ColumnIndex > -1) and (ColumnIndex < Views[i].Header.Columns.Count) then
      Views[i].Header.ClickColumn(Views[i].Header.Columns[ColumnIndex])
  end
end;

procedure TCustomVirtualColumnModeView.CMColorChanged(var Msg: TMessage);
var
  i: Integer;
begin
  inherited;
  for i := 0 to ViewCount - 1 do
      Views[i].Color := Color
end;

procedure TCustomVirtualColumnModeView.CreateWnd;
begin
  inherited CreateWnd;
  GlobalThreadManager.RegisterControl(Self);
end;

procedure TCustomVirtualColumnModeView.DeleteListview(Item: TColumnModeEasyListview);
begin
  if Assigned(Item) then
  begin
    // Disconnect from all events
    Item.OnShellExecute := nil;
    Item.OnItemFocusChanged := nil;
    Item.OnItemFocusChanging := nil;
    Item.OnItemSelectionChanged := nil;
    Item.OnItemSelectionChanging := nil;
    Item.OnItemSelectionsChanged := nil;
    Item.OnItemMouseDown := nil;
    Item.OnItemMouseUp := nil;
    Item.OnRootChange := nil;
    Item.OnIncrementalSearch := nil;
    Item.OnEnumFolder := nil;
    Item.OnMouseUp := nil;
    Item.OnMouseDown := nil;
    Item.OnContextMenu := nil;
    Item.OnContextMenu2Message := nil;
    Item.OnResize := nil;
    Item.OnEnter := nil;
    Item.OnExit := nil;

    Item.ChangeNotifierEnabled := False;
    ChangeNotifier.UnRegisterKernelChangeNotify(Item);
    DoViewDeleting(Item);
    Item.Visible := False;
    Item.Active := False;
    if Details.Parent = Item then
      Details.Parent := nil;
    ViewList.Remove(Item);
    Item.Info.Splitter.Visible := False;
    if LastFocusedView = Item then
      LastFocusedView := nil;

    // Typically called from within a message handler so don't free the object
    // or remove the parent here Delay it until after we are out of the Column windows message loop
    if HandleAllocated then
    begin
      FreeViewList.Add(Item);
      PostMessage(Handle, WM_FREEVIEW, 0, 0);
    end else
      FreeView(Item)
  end
end;

procedure TCustomVirtualColumnModeView.DoEnter;
begin
  inherited DoEnter;
  {$IFDEF GEXPERTS}
  SendDebug('TCustomVirtualColumnModeView DoEnter...');
  {$ENDIF}
end;

procedure TCustomVirtualColumnModeView.DoExit;
begin
  inherited DoExit;
   {$IFDEF GEXPERTS}
  SendDebug('TCustomVirtualColumnModeView DoExit...');
  {$ENDIF}
end;

procedure TCustomVirtualColumnModeView.DoListviewDbkClick(Sender: TCustomEasyListview; Button: TCommonMouseButton; MousePos: TPoint; ShiftState: TShiftState; var Handled: Boolean);
begin
  if Assigned(OnListviewDblClick) then
    OnListviewDblClick(Self, Sender, Button, MousePos, ShiftState)
end;

procedure TCustomVirtualColumnModeView.DoListviewMouseGesture(Sender: TCustomEasyListview; Button: TCommonMouseButton;
  KeyState: TCommonKeyStates; Gesture: WideString; var DoDefaultMouseAction: Boolean);
begin
  if Assigned(OnListviewMouseGesture) then
    OnListviewMouseGesture(Self, Sender, Button, KeyState, Gesture, DoDefaultMouseAction)
end;

procedure TCustomVirtualColumnModeView.DoListviewMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(OnViewMouseUp) then
    OnViewMouseUp(Self, Sender as TColumnModeEasyListview, Button, Shift, X, Y)
end;

procedure TCustomVirtualColumnModeView.DoViewAdded(NewView: TColumnModeEasyListview);
begin
  if Assigned(OnViewAdded) then
    OnViewAdded(Self, NewView)
end;

procedure TCustomVirtualColumnModeView.FontChanging(Sender: TObject);
begin
  // TODO Rebuild Columns Here
  if Assigned(OldFontChangeEvent) then
    OldFontChangeEvent(Sender)
end;

procedure TCustomVirtualColumnModeView.FreeView(View: TColumnModeEasyListview);
begin
  View.Parent := nil;
  FreeAndNil(View.FInfo.Splitter);
  View.FInfo.iPosition := -1;
  View.Free;
end;

procedure TCustomVirtualColumnModeView.DoItemFocusChange(Sender: TCustomEasyListview; Item: TEasyItem);
begin
  if Assigned(OnItemFocusChange) then
    OnItemFocusChange(Self, Sender, Item)
end;

procedure TCustomVirtualColumnModeView.DoItemFocusChanging(ListModeView: TCustomEasyListview; Item: TEasyItem; var Allow: Boolean);
begin
  if Assigned(OnItemFocusChanging) then
    OnItemFocusChanging(Self, ListModeView, Item, Allow)
end;

procedure TCustomVirtualColumnModeView.DoItemSelectionChange(ListModeView: TCustomEasyListview; Item: TEasyItem);
begin
  if Assigned(OnItemSelectionChange) then
    OnItemSelectionChange(Self, ListModeView, Item)
end;

procedure TCustomVirtualColumnModeView.DoItemSelectionChanging(ListModeView: TCustomEasyListview; Item: TEasyItem; var Allow: Boolean);
begin
  if Assigned(OnItemSelectionChanging) then
    OnItemSelectionChanging(Self, ListModeView, Item, Allow)
end;

procedure TCustomVirtualColumnModeView.DoItemSelectionsChange(ListModeView: TCustomEasyListview);
begin
  if Assigned(OnItemSelectionsChange) then
    OnItemSelectionsChange(Self, ListModeView)
end;

procedure TCustomVirtualColumnModeView.DoListModeEasyListviewClass(var ViewClass: TListModeEasyListviewClass);
begin
  ViewClass := nil;
  if Assigned(OnListviewClass) then
    OnListviewClass(Self, ViewClass);
  if not Assigned(ViewClass) then
    ViewClass := TColumnModeEasyListview;
end;

procedure TCustomVirtualColumnModeView.DoListviewContextMenu(Sender: TCustomEasyListview; MousePt: TPoint; var Handled: Boolean);
begin
  if Assigned(OnListviewContextMenu) then
    OnListviewContextMenu(Self, Sender, MousePt, Handled)
end;

procedure TCustomVirtualColumnModeView.DoListviewContextMenu2Message(Sender: TCustomVirtualExplorerEasyListview; var Msg: TMessage);
begin
  if Assigned(OnListviewContextMenu2Message) then
    OnListviewContextMenu2Message(Self, Sender, Msg)
end;

procedure TCustomVirtualColumnModeView.DoListviewEnter(Listview: TColumnModeEasyListview);
begin
  if Assigned(OnListviewEnter) then
    OnListviewEnter(Self, Listview)
end;

procedure TCustomVirtualColumnModeView.DoListviewEnumFolder(Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace; var AllowAsChild: Boolean);
begin
  if Assigned(OnListviewEnumFolder) then
    OnListviewEnumFolder(Self, Sender, Namespace, AllowAsChild)
end;

procedure TCustomVirtualColumnModeView.DoListviewExit(Listview: TColumnModeEasyListview);
begin
  if Assigned(OnListviewExit) then
    OnListviewExit(Self, Listview)
end;

procedure TCustomVirtualColumnModeView.DoListviewItemMouseDown(Sender: TCustomEasyListview; Item: TEasyItem; Button: TCommonMouseButton; var DoDefault: Boolean);
begin
  if Assigned(OnListviewItemMouseDown) then
    OnListviewItemMouseDown(Self, Sender, Item, Button, DoDefault)
end;

procedure TCustomVirtualColumnModeView.DoListviewItemMouseUp(Sender: TCustomEasyListview; Item: TEasyItem; Button: TCommonMouseButton; var DoDefault: Boolean);
begin
  if Assigned(OnListviewItemMouseUp) then
    OnListviewItemMouseUp(Self, Sender, Item, Button, DoDefault)
end;

procedure TCustomVirtualColumnModeView.DoListviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//  if Assigned(OnListviewMouseDown) then
//    OnListviewMouseDown(Self, Sender, Button, Shift)
end;

procedure TCustomVirtualColumnModeView.DoListviewRootChange(Listview: TCustomVirtualExplorerEasyListview);
begin
  if Assigned(OnListviewRootChange) then
    OnListviewRootChange(Self, Listview)
end;

procedure TCustomVirtualColumnModeView.DoPathChanged(NewPath: TNamespace);
begin
  if Assigned(OnPathChange) then
    OnPathChange(Self, NewPath)
end;

procedure TCustomVirtualColumnModeView.DoPathChanging(OldPath, NewPath: TNamespace; var Allow: Boolean);
begin
  if Assigned(OnPathChanging) then
    OnPathChanging(Self, OldPath, NewPath, Allow)
end;

procedure TCustomVirtualColumnModeView.DoRebuild;
begin
  if Assigned(OnRebuild) then
    OnRebuild(Self)
end;

procedure TCustomVirtualColumnModeView.DoRebuilding;
begin
  if Assigned(OnRebuilding) then
    OnRebuilding(Self)
end;

procedure TCustomVirtualColumnModeView.DoViewDeleting(View: TColumnModeEasyListview);
begin
  if Assigned(OnViewFreeing) then
    OnViewFreeing(Self, View)
end;

procedure TCustomVirtualColumnModeView.EnterWindow(Sender: TObject);
begin
  DoListviewEnter(Sender as TColumnModeEasyListview);
end;

procedure TCustomVirtualColumnModeView.ExitWindow(Sender: TObject);
begin
  LastFocusedView := Sender as TColumnModeEasyListview;
  DoListviewExit(Sender as TColumnModeEasyListview)
end;

procedure TCustomVirtualColumnModeView.Flush;
begin
  ClearViews;
end;

procedure TCustomVirtualColumnModeView.FlushFreeViewList(FlushQueue: Boolean);
var
  i: Integer;
  Msg: TMsg;
  RePostQuitCode: Integer;
  RePostQuit: Boolean;
begin
  // Flush the Queue
  if FlushQueue then
  begin
    RePostQuit := False;
    RePostQuitCode := 0;
    while PeekMessage(Msg, Handle, WM_FREEVIEW, WM_FREEVIEW, PM_REMOVE) do
    begin
      if Msg.message = WM_QUIT then
      begin
        RePostQuitCode := Msg.WParam;
        RePostQuit := True;
      end
    end;
    if RePostQuit then
      PostQuitMessage(RePostQuitCode);
  end;

  try
    for i := 0 to FreeViewList.Count - 1 do
      FreeView(TColumnModeEasyListview( FreeViewList[i]))
  finally
    FreeViewList.Count := 0;
  end
end;

procedure TCustomVirtualColumnModeView.FlushThreadRequests;
var
  i: Integer;
begin
  for i := 0 to ViewCount - 1 do
    GlobalThreadManager.FlushAllMessageCache(Views[i]);
end;

procedure TCustomVirtualColumnModeView.HilightPath(PIDL: PItemIDList);
//
// Pass nil to use the Path property as the source of the PIDL
//
var
  PIDLList: TCommonPIDLList;
  i: Integer;
  Item: TExplorerItem;
begin
  Include(FState, lmvsHilightingPath);
  PIDLList := TCommonPIDLList.Create;
  try
    if Assigned(PIDL) then
      PIDLMgr.ParsePIDL(PIDL, PIDLList, True)
    else
      PIDLMgr.ParsePIDL(Path.AbsolutePIDL, PIDLList, True);

    for i := 0 to PIDLList.Count - 1 do
    begin
      if i < ViewCount then
      begin
        Views[i].Selection.ClearAll;
        Item := Views[i].FindItemByPIDL(PIDLList[i]);
        if Assigned(Item) then
        begin
          Item.Focused := True;
          Item.Selected := True
        end;
      end
    end;
  finally
    Exclude(FState, lmvsHilightingPath);
    PIDLList.Free
  end
end;

procedure TCustomVirtualColumnModeView.ItemFocusChanging(Sender: TCustomEasyListview; Item: TEasyItem; var Allow: Boolean);
begin
  if not (lmvsHilightingPath in State) then
  begin
    DoItemFocusChanging(Sender, Item, Allow)
  end
end;

procedure TCustomVirtualColumnModeView.ItemSelectionChanging(Sender: TCustomEasyListview; Item: TEasyItem; var Allow: Boolean);
begin
  if not (lmvsHilightingPath in State) then
  begin
    DoItemSelectionChanging(Sender, Item, Allow)
  end
end;

procedure TCustomVirtualColumnModeView.ItemSelectionsChange(Sender: TCustomEasyListview);
begin
  if not (lmvsHilightingPath in State) then
  begin
    if not IsAnyMouseButtonDown then
    begin
      SelectionChangeTimer.Enabled := False;
      SelectionChangeTimer.Enabled := True;
    end;
    DoItemSelectionsChange(Sender)
  end
end;

procedure TCustomVirtualColumnModeView.ListviewContextMenu(Sender: TCustomEasyListview; MousePt: TPoint; var Handled: Boolean);
begin
  DoListviewContextMenu(Sender, MousePt, Handled)
end;

procedure TCustomVirtualColumnModeView.ListviewContextMenu2Message(Sender: TCustomVirtualExplorerEasyListview; var Msg: TMessage);
begin
  DoListviewContextMenu2Message(Sender, Msg)
end;

procedure TCustomVirtualColumnModeView.ListviewDblClick(Sender: TCustomEasyListview; Button: TCommonMouseButton; MousePos: TPoint; ShiftState: TShiftState; var Handled: Boolean);
begin
  DoListviewDbkClick(Sender, Button, MousePos, ShiftState, Handled)
end;

procedure TCustomVirtualColumnModeView.ListviewEnumFolder(Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace; var AllowAsChild: Boolean);
begin
  DoListviewEnumFolder(Sender, Namespace, AllowAsChild)
end;

procedure TCustomVirtualColumnModeView.ListviewItemFreeing(Sender: TCustomEasyListview; Item: TEasyItem);
begin
  GlobalThreadManager.FlushAllMessageCache(Sender, Item)
end;

procedure TCustomVirtualColumnModeView.ListviewItemMouseDown(Sender: TCustomEasyListview; Item: TEasyItem; Button: TCommonMouseButton; var DoDefault: Boolean);
begin
  DoListviewItemMouseDown(Sender, Item, Button, DoDefault)
end;

procedure TCustomVirtualColumnModeView.ListviewItemMouseUp(Sender: TCustomEasyListview; Item: TEasyItem; Button: TCommonMouseButton; var DoDefault: Boolean);
begin
  DoListviewItemMouseUp(Sender, Item, Button, DoDefault)
end;

procedure TCustomVirtualColumnModeView.ListviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DoListviewMouseDown(Sender, Button, Shift, X, Y)
end;

procedure TCustomVirtualColumnModeView.ListviewMouseGesture(Sender: TCustomEasyListview;
  Button: TCommonMouseButton; KeyState: TCommonKeyStates; Gesture: WideString; var DoDefaultMouseAction: Boolean);
begin
  DoListviewMouseGesture(Sender, Button, KeyState, Gesture, DoDefaultMouseAction)
end;

procedure TCustomVirtualColumnModeView.ListviewResize(Sender: TObject);
begin
  HeaderBar.Invalidate;
  HeaderBar.Update 
end;

function TCustomVirtualColumnModeView.ViewNamespace(Index: Integer): TNamespace;
begin
  Result := Views[Index].RootFolderNamespace
end;

{$IFDEF SpTBX}
function TCustomVirtualColumnModeView.ViewSplitter(Index: Integer): TSpTBXSplitter;
begin
  Result := Views[Index].Info.Splitter
end;
{$ELSE}
function TCustomVirtualColumnModeView.ViewSplitter(Index: Integer): TVirtualSplitter;
begin
  Result := Views[Index].Info.Splitter
end;
{$ENDIF}

{ TVirtualColumnModeView}

procedure TCustomVirtualColumnModeView.LockRedraw;
begin
  if HandleAllocated then
  begin
    Inc(FRedrawLockCount);
    if RedrawLockCount = 1 then
      SendMessage(Handle, WM_SETREDRAW, 0, 0)
  end;
end;

procedure TCustomVirtualColumnModeView.Rebuild;
var
  i: Integer;
  PIDL: PItemIDList;
begin
  PIDL := nil;
  if Assigned(Path) then
    PIDL := PIDLMgr.CopyPIDL(Path.AbsolutePIDL);

  // TODO Rebuild Columns Here
  for i := 0 to ViewCount - 1 do
  begin
    if Details.Parent <> Views[i] then
      Views[i].RereadAndRefresh(True);
  end;

  if Assigned(PIDL) then
  begin
    Path := TNamespace.Create(PIDL, nil);
    HilightPath(Path.AbsolutePIDL);
  end
end;

procedure TCustomVirtualColumnModeView.SelectionChangeTimerEvent(Sender: TObject);
begin
  SelectionChangeTimer.Enabled := False;
  TestForRebuild(FocusedView);
end;

procedure TCustomVirtualColumnModeView.SetBandHilight(const Value: Boolean);
begin
  if FBandHilight <> Value then
  begin
    FBandHilight := Value;
    Invalidate;
  end
end;

procedure TCustomVirtualColumnModeView.SetBandHilightColor(const Value: TColor);
begin
  if FBandHilightColor <> Value then
  begin
    FBandHilightColor := Value;
    Invalidate;
  end
end;

procedure TCustomVirtualColumnModeView.SetDefaultColumnWidth(
  const Value: Integer);
var
  i: Integer;
begin
  if FDefaultColumnWidth <> Value then
  begin
    FDefaultColumnWidth := Value;
    for i := 0 to ViewCount - 1 do
      Views[i].Width := Value
  end
end;

procedure TCustomVirtualColumnModeView.SetFileObjects(const Value: TFileObjects);
var
  i: Integer;
  OldPath: TNamespace;
begin
  if FFileObjects <> Value then
  begin
    FFileObjects := Value;
    ValidateFileObjects(FFileObjects);
    if Assigned(Path) then
      OldPath := Path.Clone(True)
    else
      OldPath := nil;
    LockRedraw;
    try    
      Path := nil;
      for i := 0 to ViewCount - 1 do
        Views[i].FileObjects := FFileObjects
    finally
      Path := OldPath;
      UnLockRedraw;
    end;
  end
end;

procedure TCustomVirtualColumnModeView.SetGrouped(const Value: Boolean);
var
  i: Integer;
begin
  if FGrouped <> Value then
  begin
    FGrouped := Value;
    for i := 0 to ViewCount - 2 do
    begin
      if Grouped and (GroupingColumn > -1) and (GroupingColumn < Views[i].Header.Columns.Count) then
        Views[i].Selection.FocusedColumn := Views[i].Header.Columns[GroupingColumn]
      else
        Views[i].Selection.FocusedColumn := Views[i].Header.Columns[0];

      Views[i].Sort.SortAll(True);
    end
  end
end;

procedure TCustomVirtualColumnModeView.SetGroupingColumn(const Value: Integer);
var
  i: Integer;
  OldCol: TEasyColumn;
begin
  if FGroupingColumn <> Value then
  begin
    FGroupingColumn := Value;
    for i := 0 to ViewCount - 2 do
    begin
      OldCol := Views[i].Selection.FocusedColumn;

      Views[i].GroupingColumn := Value;
      if Grouped and (FGroupingColumn > -1) and (FGroupingColumn < Views[i].Header.Columns.Count) then
        Views[i].Selection.FocusedColumn := Views[i].Header.Columns[FGroupingColumn]
      else
        Views[i].Selection.FocusedColumn := Views[i].Header.Columns[0];

      if Grouped and (OldCol <> Views[i].Selection.FocusedColumn) then
        Views[i].Sort.SortAll(True);
    end
  end
end;

procedure TCustomVirtualColumnModeView.SetHintType(const Value: TEasyHintType);
begin
  if FHintType <> Value then
  begin
    FHintType := Value;
    // TODO Rebuild Columns Here
  end
end;

procedure TCustomVirtualColumnModeView.SetOptions(const Value: TVirtualEasyListviewOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    // TODO
  end
end;

procedure TCustomVirtualColumnModeView.SetSelectionChangeTimeInterval(const Value: Word);
begin
  if FSelectionChangeTimeInterval <> Value then
  begin
    SelectionChangeTimer.Interval := Value;
    FSelectionChangeTimeInterval := Value;
  end
end;

procedure TCustomVirtualColumnModeView.SetSortFolderFirstAlways(
  const Value: Boolean);
var
  i: Integer;
begin
  if Value <> FSortFolderFirstAlways then
  begin
    FSortFolderFirstAlways := Value;
    for i := 0 to ViewCount - 1 do
      Views[i].SortFolderFirstAlways := Value
  end
end;

procedure TCustomVirtualColumnModeView.SortOnColumn(Index: Integer);
begin
  GroupingColumn := Index;
  ClickColumn(Index)
end;

procedure TCustomVirtualColumnModeView.ToggleSortDir;
begin
  if (DefaultSortDir = esdNone) or (DefaultSortDir = esdAscending) then
    DefaultSortDir := esdDescending
  else
    DefaultSortDir := esdAscending
end;

procedure TCustomVirtualColumnModeView.UnLockRedraw;
begin
  if HandleAllocated then
  begin
    Dec(FRedrawLockCount);
    if RedrawLockCount = 0 then
    begin
      SendMessage(Handle, WM_SETREDRAW, 1, 0);
      RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_ERASENOW or
          RDW_UPDATENOW or RDW_ALLCHILDREN or RDW_FRAME);
    end
  end;
end;

procedure TCustomVirtualColumnModeView.WMFreeView(var Msg: TMessage);
begin
  FlushFreeViewList(False)
end;

procedure TCustomVirtualColumnModeView.ClearViews;
var
  i: Integer;
begin
  try
    FlushThreadRequests;
    if Assigned(Details) then
      Details.Parent := nil;
    for i := ViewCount - 1 downto 0 do
      DeleteListview(Views[i])
  finally
    ViewList.Clear
  end
end;

procedure TCustomVirtualColumnModeView.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_CLIPCHILDREN or WS_CLIPSIBLINGS;
end;

procedure TCustomVirtualColumnModeView.ItemFocusChange(Sender: TCustomEasyListview; Item: TEasyItem);
begin  
  if not (lmvsHilightingPath in State) then
  begin
    if not (lmvsHilightingPath in State) then
      DoItemFocusChange(Sender, Item)
  end
end;

procedure TCustomVirtualColumnModeView.ItemSelectionChange(Sender: TCustomEasyListview; Item: TEasyItem);
begin
  if not (lmvsHilightingPath in State) then
  begin
    DoItemSelectionChange(Sender, Item);
  end
end;

procedure TCustomVirtualColumnModeView.ListviewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TestForRebuild(Sender);
  DoListviewMouseUp(Sender, Button, Shift, X, Y)
end;

procedure TCustomVirtualColumnModeView.ListviewRootChange(Sender: TCustomVirtualExplorerEasyListview);
begin
  DoListviewRootChange(Sender)
end;

procedure TCustomVirtualColumnModeView.SetDefaultSortColumn(const Value: Integer);
var
  i: Integer;
begin
  if Value <> FDefaultSortColumn then
  begin
    FDefaultSortColumn := Value;
    for i := 0 to ViewCount - 2 do
    begin
      TCustomVirtualExplorerEasyListviewHack( Views[i]).DefaultSortColumn := Value;
      TCustomVirtualExplorerEasyListviewHack( Views[i]).UpdateDefaultSortColumnAndSortDir;
      TCustomVirtualExplorerEasyListviewHack( Views[i]).Sort.SortAll(True)
    end
  end
end;

procedure TCustomVirtualColumnModeView.SetDefaultSortDir(const Value: TEasySortDirection);
var
  i: Integer;
begin
  if Value <> FDefaultSortDir then
  begin
    FDefaultSortDir := Value;
    for i := 0 to ViewCount - 1 do
    begin
      TCustomVirtualExplorerEasyListviewHack( Views[i]).DefaultSortDir := Value;
      TCustomVirtualExplorerEasyListviewHack( Views[i]).UpdateDefaultSortColumnAndSortDir;
      TCustomVirtualExplorerEasyListviewHack( Views[i]).Sort.SortAll(True)
    end
  end
end;

procedure TCustomVirtualColumnModeView.SetHilightActiveColumn(const Value: Boolean);
var
  i: Integer;
begin
  if FHilightActiveColumn <> Value then
  begin
    FHilightActiveColumn := Value;
    for i := 0 to ViewCount - 1 do
      Views[i].Invalidate
  end
end;

procedure TCustomVirtualColumnModeView.SetHilightColumnColor(const Value: TColor);
var
  i: Integer;
begin
  if FHilightColumnColor <> Value then
  begin
    FHilightColumnColor := Value;
    for i := 0 to ViewCount - 1 do
      Views[i].Invalidate
  end
end;

procedure TCustomVirtualColumnModeView.ShellExecute(Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace; var WorkingDir: WideString; var CmdLineArgument: WideString; var Allow: Boolean);
begin
  Allow := not Namespace.Folder
end;

procedure TCustomVirtualColumnModeView.RebuildView;

  function PrevViewWidth(iIndex: Integer): Integer;
  begin
    if iIndex <= 0 then
      Result := 0
    else begin
      Result := WIDTH_COLUMN;
      if (iIndex > -1) and (iIndex < ViewCount) then
        Result := Views[iIndex].Width
    end
  end;

  function PathFitsInWindow(var PathWidth: Integer): Boolean;
  var
    PathLength, i, PrevWidth: Integer;
  begin
    PathWidth := 0;
    if Assigned(Path) then
    begin

      // A Desktop PIDL is length 0 but shows in column one so must add 2
      PathLength := PIDLMgr.IDCount(Path.AbsolutePIDL) + 2;
      if PathLength <= ViewCount then
      begin
        PathWidth := 0;
        for i := 0 to PathLength - 1 do
          PathWidth := PathWidth + Views[i].Width + Views[i].Info.Splitter.Width
      end else
      begin
        PathWidth := 0;
        for i := 0 to ViewCount - 1 do
          PathWidth := PathWidth + Views[i].Width + Views[i].Info.Splitter.Width;
        PrevWidth := PrevViewWidth(ViewCount - 1);
        for i := ViewCount to PathLength - 1 do
          PathWidth := PathWidth + PrevWidth + Views[ViewCount - 1].Info.Splitter.Width
      end;
      Result := PathWidth <= ClientWidth
    end else
      Result := True
  end;

  procedure SoftScroll(Position: Integer; Delta: Integer);
  begin
    if Delta = 0 then
       HorzScrollBar.Position := Position
    else begin
      if Position > HorzScrollBar.Position then
      begin
        while Position <> HorzScrollBar.Position do
        begin
          if HorzScrollBar.Position + Delta > Position then
            HorzScrollBar.Position := Position
          else
            HorzScrollBar.Position := HorzScrollBar.Position + Delta;
          Update;
        end
      end else
      begin
        while Position <> HorzScrollBar.Position do
        begin
          if HorzScrollBar.Position - Delta < Position then
            HorzScrollBar.Position := Position
          else
            HorzScrollBar.Position := HorzScrollBar.Position - Delta;
          Update;
        end
      end
    end
  end;

  procedure InsertViews(Count: Integer);
  var
    i: Integer;
  begin
    for i := 0 to Count - 1 do
      AddView(nil, DefaultColumnWidth);
  end;

  procedure VerifyMinViewCount;
  begin
    // Make sure we always have 2 columns, one for desktop and one for details
    if ViewCount < 2 then
      InsertViews(2 - ViewCount)
  end;   

  procedure DeleteViews(Count: Integer);
  var
    i: Integer;
  begin
    for i := ViewCount - 1 downto ViewCount - Count do
      RemoveView(i)
  end;

  procedure ReIndexViews;
  var
    i: Integer;
  begin
    for i := 0 to ViewCount - 1 do
      Views[i].FInfo.iPosition := i
  end;

  procedure SetRootFoldersAndActivate;
  var
    PIDLList: TCommonPIDLList;
    i: Integer;
  begin
    if (ViewCount > 0) and Assigned(Path) then
    begin
      PIDLList := TCommonPIDLList.Create;
      try
        PIDLMgr.ParsePIDL(Path.AbsolutePIDL, PIDLList, True);

        // The first view is the Desktop that is always available
        Views[0].Active := CanFocus and Active;
        Views[0].Visible := True;

        // Start with first level after Desktop, that is handled above.  Also
        // the last view window is for showing the details
        for i := 1 to ViewCount - 2 do
        begin
          // The desktop is not in the PIDLList so we must subtract 1 to get lined up
          if Views[i].RootFolderNamespace.ComparePIDL(PIDLList[i-1], True, 0) <> 0 then
            Views[i].RootFolderCustomPIDL := PIDLList[i-1];
          Views[i].Active := CanFocus and Active;
          Views[i].Visible := True;
          if (i = ViewCount - 2) then
            LastFocusedView := Views[i]
        end;
      finally
        PIDLList.Free;
      end
    end;
  end;

  procedure LoadDetailsWindow;
  var
    FolderView, RedrawLocked: Boolean;
    ThumbSize: TPoint;
    TileRequest: TEasyDetailStringsThreadRequest;
    IconRequest: TShellIconThreadRequest;
    SelectedItem: TExplorerItem;
    i: Integer;
  begin
    RedrawLocked := False;
    if Details.HandleAllocated then
    begin
      RedrawLocked := True;
      SendMessage(Details.Handle, WM_SETREDRAW, 0, 0)
    end;
    try
      // First figure out what to display in the Details Windows based on what is
      // selected in the last Column that contains files
      FolderView := True;
      if (ViewCount > 1) and (Views[ViewCount - 2].Selection.Count = 1) then
      begin
        SelectedItem := Views[ViewCount - 2].Selection.First as TExplorerItem;
        FolderView := SelectedItem.Namespace.Folder;
        Details.ExplorerListview := Views[ViewCount - 2]
      end else
      begin
        SelectedItem := nil;
        Details.ExplorerListview := nil
      end;
      Details.ClearInfoList;
      Details.Thumbnail.Picture.Assign(nil);
      Details.ValidDetails := False;
      if (ViewCount > 0) then
      begin
        if Assigned(SelectedItem) and (SelectedItem.Namespace.OkToBrowse(False)) then
        begin
          if FolderView then
          begin
            Details.Parent := nil;
            // don't all it to change the state of the linked components
            Views[ViewCount - 1].VETStates := Views[ViewCount - 1].VETStates + [vsLockChangeNotifier];
            Views[ViewCount - 1].RootFolderCustomPIDL := SelectedItem.Namespace.AbsolutePIDL;
            Views[ViewCount - 1].Active := True;
            Views[ViewCount - 1].VETStates := Views[ViewCount - 1].VETStates - [vsLockChangeNotifier];
          end else
          begin
            Views[ViewCount - 1].Active := False;
            Details.Parent := Views[ViewCount - 1];

            // Send a thumb request to the GlobalThreadManager
            if Details.Thumbnail.Width < Details.Thumbnail.Height then
              ThumbSize.X := Details.Thumbnail.Width
            else
              ThumbSize.X := Details.Thumbnail.Height;
            ThumbSize.Y := ThumbSize.X;
            AddThumbRequest(Self, SelectedItem, ThumbSize, True, True, True, True, False, nil);
            IconRequest := TShellIconThreadRequest.Create;
            IconRequest.PIDL := PIDLMgr.CopyPIDL(SelectedItem.Namespace.AbsolutePIDL);
            IconRequest.Window := Self;
            IconRequest.Item := SelectedItem;
            IconRequest.ID := TID_ICON;
            // Icons should have the highest Priority
            IconRequest.Priority := 0;
            // Copy anything needed from the Item, NEVER access the Item from the thread
            // use what is copied here to access the data in a thread safe way
            GlobalThreadManager.AddRequest(IconRequest, True);

            // Send a tile request to the GlobalThreadManager
            TileRequest := TEasyDetailStringsThreadRequest.Create;
            TileRequest.AddTitleColumnCaption := True;
            TileRequest.PIDL := PIDLMgr.CopyPIDL(SelectedItem.Namespace.AbsolutePIDL);
            TileRequest.Window := Self;
            SetLength(TileRequest.FDetailRequest, Path.DetailsSupportedColumns);
            for i := 0 to Path.DetailsSupportedColumns - 1 do
              TileRequest.DetailRequest[i] := i;    // Use column 1
            TileRequest.ID := TID_DETAILS;
            GlobalThreadManager.AddRequest(TileRequest, True);
            Details.ValidDetails := True;
          end
        end else
        begin
          Views[ViewCount - 1].Active := False;
          Details.Parent := Views[ViewCount - 1];
        end
      end else
        Details.Parent := nil
    finally
      if RedrawLocked and Details.HandleAllocated then
      begin
        SendMessage(Details.Handle, WM_SETREDRAW, 1, 0);
        RedrawWindow(Details.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_ERASENOW or
          RDW_UPDATENOW or RDW_ALLCHILDREN or RDW_FRAME);
      end
    end
  end;

var
  PathWidth, PathLength: Integer;
begin
  if Active and (ComponentState * [csLoading, csDestroying] = []) and ([lmvsRebuildingView, lmvsHilightingPath] * State = []) and HandleAllocated then
  begin
    Include(FState, lmvsRebuildingView);
    try
      DoRebuilding;
      GlobalThreadManager.FlushMessageCache(Self, TID_START);

      // A Desktop PIDL is length 0 but shows in column one so must add 2
      if Assigned(Path) then
        PathLength := PIDLMgr.IDCount(Path.AbsolutePIDL) + 2
      else
        PathLength := 0;
      VerifyMinViewCount;
      if PathFitsInWindow(PathWidth) then
      begin
        SoftScroll(0, SmoothScrollDelta);
        LockRedraw;
        try
          if PathLength > ViewCount then
            InsertViews(PathLength - ViewCount)
          else
            DeleteViews(ViewCount - PathLength);
          ReIndexViews;
          SetRootFoldersAndActivate;
          LoadDetailsWindow;
        finally
          UnLockRedraw
        end
      end else
      begin
        // See if we need to scroll Left because Path is reduced
        if PathWidth <= (HorzScrollBar.Position + ClientWidth) then
          SoftScroll(PathWidth - ClientWidth, SmoothScrollDelta);
        LockRedraw;
        try
          if PathLength > ViewCount then
            InsertViews(PathLength - ViewCount)
          else
            DeleteViews(ViewCount - PathLength);
          VerifyMinViewCount;
          ReIndexViews;
          SetRootFoldersAndActivate;
        finally
          UnLockRedraw
        end;
        if PathWidth > (HorzScrollBar.Position + ClientWidth) then
          SoftScroll(PathWidth - ClientWidth, SmoothScrollDelta);
        LoadDetailsWindow;
      end;
    finally
      ChangeLinkDispatch;
      Exclude(FState, lmvsRebuildingView);
    end
  end;
  DoRebuild;
end;

procedure TCustomVirtualColumnModeView.RemoveView(Index: Integer);
begin
  DeleteListview(Views[Index]);
end;

procedure TCustomVirtualColumnModeView.ScrollbarSetPosition(NewPos: Integer);
begin
  HorzScrollBar.Position := NewPos
end;

procedure TCustomVirtualColumnModeView.ScrollLeft;
var
  View: TColumnModeEasyListview;
  Position: Integer;
begin
  View := FocusedView;
  if not Assigned(View) and (ViewCount > 0) then
  begin
    View := Views[0];
    View.SetFocus;
    if View.ItemCount > 0 then
      View.Items[0].Selected := True
  end else
  begin
    Position := View.Info.iPosition;
    if Position > 0 then
    begin
      Views[Position - 1].SetFocus;
      if Views[Position - 1].Selection.Count = 0 then
      begin
        Views[Position - 1].Items[0].Focused := True;
        Views[Position - 1].Items[0].Selected := True;
        Views[Position - 1].Items[0].MakeVisible(emvAuto);
      end
    end
  end;
  HeaderBar.Invalidate;
  HeaderBar.Update;
end;

procedure TCustomVirtualColumnModeView.ScrollRight;
var
  View: TColumnModeEasyListview;
  Position: Integer;
begin
  View := FocusedView;
  SelectionChangeTimerEvent(FocusedView);

  if not Assigned(View) and (ViewCount > 0) then
  begin
    View := Views[0];
    View.SetFocus;
    if View.ItemCount > 0 then
      View.Items[0].Selected := True
  end else
  begin
    Position := View.Info.iPosition;
    if (Position + 1 < ViewCount) and (Views[Position + 1].Active) then
    begin
      Views[Position + 1].SetFocus;
      if Views[Position + 1].Selection.Count = 0 then
      begin
        if Views[Position + 1].Items.Count > 0 then
        begin
          Views[Position + 1].Items[0].Focused := True;
          Views[Position + 1].Items[0].Selected := True;
          Views[Position + 1].Items[0].MakeVisible(emvAuto);
        end
      end
    end else
      ScrollbarSetPosition(HorzScrollbar.Range - Width)
  end;
  HeaderBar.Invalidate;
  HeaderBar.Update;
end;

procedure TCustomVirtualColumnModeView.SetActive(const Value: Boolean);
var
  i: Integer;
begin
  if FActive <> Value then
  begin
    LockRedraw;
    Include(FState, lmvsRebuildingView);
    try
      // Order matters here or we get recursion
      FActive := Value;
      for i := 0 to ViewCount - 1 do
        Views[i].Active := Value;
    finally
      Exclude(FState, lmvsRebuildingView);
      RebuildView;
      HilightPath(Path.AbsolutePIDL);
      UnLockRedraw
    end
  end
end;

{$IFDEF EXPLORERCOMBOBOX_L}
procedure TCustomVirtualColumnModeView.SetExplorerCombobox(const Value: TVirtualExplorerCombobox);
begin
  if Assigned(FExplorerComboBox) then
  begin
    VETChangeDispatch.UnRegisterChangeLink(FExplorerComboBox, Self, utLink);
    VETChangeDispatch.UnRegisterChangeLink(Self, FExplorerComboBox, utLink);
  end;
  FExplorerCombobox := Value;
  if Assigned(FExplorerCombobox) then
  begin
    VETChangeDispatch.RegisterChangeLink(FExplorerComboBox, Self, ChangeLinkChanging, ChangeLinkFreeing);
    VETChangeDispatch.RegisterChangeLink(Self, FExplorerComboBox, ExplorerComboBox.ChangeLinkChanging, ExplorerComboBox.ChangeLinkFreeing);
  end
end;
{$ENDIF}

procedure TCustomVirtualColumnModeView.SetHeader(const Value: TVirtualHeaderBarAttributes);
begin
  HeaderBar.Attribs.Assign(Value)
end;

procedure TCustomVirtualColumnModeView.SetPath(const Value: TNamespace);
//
// The passed namespace is given to the LMV and the LMV will free it
//
var
  DoStore: Boolean;
  Allow:Boolean;
begin
  if not (csDestroying in ComponentState) and not (lmvsRebuildingView in State) {and Active} then
  begin
    Allow := True;
    DoPathChanging(Path, Value, Allow);
    DoStore := True;
    if Assigned(FPath) and Assigned(Value) then
    begin
      if (FPath.ComparePIDL(Value.AbsolutePIDL, True, 0) = 0) then
      begin
        DoStore := False;
        Value.Free;
      end
    end;

    if DoStore then
    begin
      if Assigned(FPath) then
        FreeAndNil(FPath);
      FPath := Value;
      RebuildView;
      DoPathChanged(Value);
    end
  end else
    Value.Free
end;

procedure TCustomVirtualColumnModeView.SetShowInactive(const Value: Boolean);
var
  i: Integer;
begin
  for i := 0 to ViewCount - 1 do
  begin
    Views[i].ShowInactive := Value;
    if i = 0 then
    begin
      if Value then
        Details.Font.Color := clGrayText
      else
        Details.Font.Color := Views[i].Font.Color;
    end
  end;
  FShowInactive := Value;
end;

procedure TCustomVirtualColumnModeView.SetViews(Index: Integer; Value: TColumnModeEasyListview);
begin
  ViewList[Index] := Value
end;

procedure TCustomVirtualColumnModeView.TestForRebuild(Sender: TObject);
var
  LV: TVirtualExplorerEasyListview;
begin
  if Assigned(Sender) then
  begin
    LV := Sender as TVirtualExplorerEasyListview;
    if ([lmvsBrowsing, lmvsRebuildingView] * State = []) and HandleAllocated and Assigned(LV) then
    begin
      if Path.ComparePIDL(LV.RootFolderNamespace.AbsolutePIDL, True) <> 0 then
        Path := LV.RootFolderNamespace.Clone(True)
      else
      begin
        RebuildView;
        HeaderBar.Invalidate;
        HeaderBar.Update;
      end;
      if Assigned(Path.AbsolutePIDL) then
        HilightPath(Path.AbsolutePIDL);
    end
  end
end;

procedure TCustomVirtualColumnModeView.WMDestroy(var Msg: TMessage);
begin
  SelectionChangeTimer.Enabled := False;
  GlobalThreadManager.UnRegisterControl(Self);
  FlushFreeViewList(True);
  inherited;
end;

procedure TCustomVirtualColumnModeView.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
var
  BkCanvas: TCanvas;
begin
  BkCanvas := TCanvas.Create;
  try
    BkCanvas.Handle := Msg.DC;
    BkCanvas.Brush.Color := Color;
    BkCanvas.FillRect(ClientRect)
  finally
    BkCanvas.Handle := 0;
    BkCanvas.Free
  end
end;

procedure TCustomVirtualColumnModeView.WMKillFocus(var Msg: TWMKillFocus);
var
  i: Integer;
begin
  inherited;
  for i := 0 to ViewCount - 1 do
    Views[i].Selection.PopupMode := True;
end;

procedure TCustomVirtualColumnModeView.WMMouseActivate(var Msg: TWMMouseActivate);
begin
  inherited;
  Msg.Result := MA_NOACTIVATE; // Never let the window gain the focus
  
 // Why was I doing this?  Removed Dec 2008 when working on UE 3.0
//  ActivateTopLevelWindow(Handle)
end;

procedure TCustomVirtualColumnModeView.WMPostFocusBackToView(var Msg: TMessage);
begin
  if Assigned(LastFocusedView) and (LastFocusedView.CanFocus) then
    LastFocusedView.SetFocus
  else
  if ViewCount > 0 then
  begin
    if not Assigned(Details.Parent) and not Details.ValidDetails then
    begin
      if Views[ViewCount - 1].CanFocus then
        Views[ViewCount - 1].SetFocus
    end else
    begin
      if Views[ViewCount - 2].CanFocus then
        Views[ViewCount - 2].SetFocus;
    end
  end;
  Invalidate;
  Update;
end;

procedure TCustomVirtualColumnModeView.WMSetFocus(var Msg: TWMSetFocus);
var
  i: Integer;
begin
  inherited;
  PostMessage(Handle, WM_POSTFOCUSBACKTOVIEW, 0, 0);
  for i := 0 to ViewCount - 1 do
    Views[i].Selection.PopupMode := True;
  if Assigned(Path) then
    HilightPath(nil);
end;

{$IFDEF SpTBX}
procedure TCustomVirtualColumnModeView.WMSpSkinChange(var Msg: TMessage);
begin
  Invalidate;
  Update;
  if HeaderBar.HandleAllocated then
  begin
    HeaderBar.Invalidate;
    HeaderBar.Update;
  end
end;
{$ENDIF SpTBX}

procedure TCustomVirtualColumnModeView.WMPostViewLosingFocus(var Msg: TMessage);
var
  i: Integer;
begin
  if FocusedView = nil then
  begin
    for i := 0 to ViewCount - 1 do
    begin
      Views[i].Selection.PopupMode := False;
      if Views[i].HandleAllocated then
      begin
        Views[i].Invalidate;
        Views[i].Update
      end
    end
  end
end;

procedure TCustomVirtualColumnModeView.WMThreadCallback(var Msg: TWMThreadRequest);
var
  Request: TPIDLThreadRequest;
  ThumbRequest: TEasyThumbnailThreadRequest;
  DetailRequest: TEasyDetailStringsThreadRequest;
  IconRequest: TShellIconThreadRequest;
  Info: TThumbInfo;
  Bits: TBitmap;
  RedrawLocked: Boolean;
begin
  Request := Msg.Request as TPIDLThreadRequest;
  try
    case Request.ID of
      TID_ICON:
        begin
          if Details.Thumbnail.Picture.Bitmap.Empty then
          begin
            IconRequest :=  Msg.Request as TShellIconThreadRequest;
            ExtraLargeSysImages.GetBitmap(IconRequest.ImageIndex, Details.Thumbnail.Picture.Bitmap);
            Details.Invalidate;
          end
        end;
      TID_THUMBNAIL:
        begin
          ThumbRequest := Msg.Request as TEasyThumbnailThreadRequest;
          Info := TThumbInfo(ThumbRequest.Tag);
          if Assigned(Info) then
          begin
            Bits := TBitmap.Create;
            Bits.Width := Info.ImageWidth;
            Bits.Height := Info.ImageHeight;
            Info.ReadBitmap(Bits);
            Details.Thumbnail.Picture.Bitmap.Assign(Bits);
            Bits.Free;
          end;
          Details.Invalidate;
       end;
      TID_DETAILS:
        begin
          RedrawLocked := False;
          if Details.HandleAllocated then
          begin
            RedrawLocked := True;
            SendMessage(Details.Handle, WM_SETREDRAW, 0, 0)
          end;
          try
            if Details.ValidDetails then
            begin
              DetailRequest := Msg.Request as TEasyDetailStringsThreadRequest;
              Details.BuildDetailInfo( DetailRequest.Details)
            end
          finally
            if RedrawLocked and Details.HandleAllocated then
            begin
            SendMessage(Details.Handle, WM_SETREDRAW, 1, 0);
            RedrawWindow(Details.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_ERASENOW or
              RDW_UPDATENOW or RDW_ALLCHILDREN or RDW_FRAME);
          end
        end
      end
    end;
  finally
    Request.Release
  end
end;

procedure TCustomVirtualColumnModeView.WMWindowPosChanged(var Msg: TWMWindowPosChanged);
begin
  inherited;
  // For some reason the child windows are created off the right edge
  // when created from the DFM at runtime.  This rebuild them at 0,0
  if ([lmvsRebuildingView, lmvsResizedOnce] * State = []) then
    RebuildView;
  Include(FState, lmvsResizedOnce)
end;

constructor TColumnModeEasyListview.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TColumnModeEasyListview.Destroy;
begin
  // Listview owns the Splitter don't free it, it will free automatically
  inherited Destroy;
end;

function TColumnModeEasyListview.BrowseToByPIDL(APIDL: PItemIDList; SelectTarget: Boolean = True; ShowExplorerMsg: Boolean = True): Boolean;
begin
  Result:= inherited BrowseToByPIDL(APIDL, SelectTarget);
end;

function TColumnModeEasyListview.GetHeaderVisibility: Boolean;
begin
  Result := inherited GetHeaderVisibility and not Assigned(ColumnModeView)
end;

function TColumnModeEasyListview.GetSortColumn: TEasyColumn;
begin
  Result := Selection.FocusedColumn;  // Force the DefaultSortColumn to be used if nil
end;

function TColumnModeEasyListview.LoadStorageToRoot(StorageNode: TNodeStorage): Boolean;
begin
  // Don't load any storage in Column Mode View
{  if Assigned(ColumnModeView) then
    Result := False
  else  }
    Result := inherited LoadStorageToRoot(StorageNode)
end;

procedure TColumnModeEasyListview.BrowseToPrevLevel;
begin
//  if not Assigned(ColumnModeView) then
    inherited
  // else
  // Do nothing when in a ColumnModeView
end;

{$IFDEF SpTBX}
function TColumnModeEasyListview.PaintSpTBXSelection: Boolean;
begin
  // If it is focused use the SpTBX themes else use the grayed default (unless in Popup Mode then always paint SpTBX
  Result := Assigned(ColumnModeView.FocusedView) or Selection.PopupMode
end;
{$ENDIF SpTBX}

procedure TColumnModeEasyListview.DoColumnContextMenu(
  HitInfo: TEasyHitInfoColumn; WindowPoint: TPoint; var Menu: TPopupMenu);
begin
  // Don't allow the menu header
//  if Assigned(ColumnModeView) then
//    Menu := nil
//  else
    inherited
end;

procedure TColumnModeEasyListview.DoEnter;
begin
  inherited DoEnter;
end;

procedure TColumnModeEasyListview.DoExit;
begin
  inherited DoExit;
end;

procedure TColumnModeEasyListview.DoItemCustomView(Item: TEasyItem; ViewStyle: TEasyListStyle; var View: TEasyViewItemClass);
begin
  inherited DoItemCustomView(Item, ViewStyle, View);
  if not Assigned(View) and (ViewStyle = elsReport) and Assigned(ColumnModeView) then
    View := TColumnModeViewReportItem
end;

procedure TColumnModeEasyListview.DoKeyAction(var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean);
begin
  if Assigned(ColumnModeView) then
  begin
    if (CharCode = VK_LEFT) or (CharCode = VK_RIGHT) then
    begin
      // The ELV that contains the ListMode window can be called as well
      // and its parent is a TPanel at this time of this note.
      if Parent is TCustomVirtualColumnModeView then
      begin
        DoDefault := False;
        if CharCode = VK_LEFT then
          (Parent as TCustomVirtualColumnModeView).ScrollLeft
        else
        
        if CharCode = VK_RIGHT then
          (Parent as TCustomVirtualColumnModeView).ScrollRight
      end else
        inherited
    end else
      inherited;
  end else
    inherited
end;

procedure TColumnModeEasyListview.DoShellNotify(ShellEvent: TVirtualShellEvent);
begin
  inherited DoShellNotify(ShellEvent);
end;

procedure TColumnModeEasyListview.SaveRootToStorage(StorageNode: TNodeStorage);
begin
  // Don't save anything to Storage
//  if not Assigned(ColumnModeView) then
    inherited SaveRootToStorage(StorageNode)
end;

procedure TColumnModeEasyListview.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  PostMessage(ColumnModeView.Handle, WM_POSTVIEWLOSINGFOCUS, 0, 0)
end;

procedure TColumnModeEasyListview.WMSetFocus(var Msg: TWMSetFocus);
var
  i: Integer;
begin
  inherited;
  ColumnModeView.LastFocusedView := Self;
  for i := 0 to ColumnModeView.ViewCount - 1 do
  begin
    ColumnModeView.Views[i].Selection.PopupMode := True;
    if ColumnModeView.Views[i].HandleAllocated then
    begin
      ColumnModeView.Views[i].Invalidate;
      ColumnModeView.Views[i].Update
    end
  end;
  ColumnModeView.Invalidate;
  ColumnModeView.Update;
end;

{ TVirtualHeaderBar }
constructor TVirtualHeaderBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ColumnModeView := AOwner as TCustomVirtualColumnModeView;
  FAttribs := TVirtualHeaderBarAttributes.Create(Self);
  FBackBits := TBitmap.Create;
  BackBits.PixelFormat := pf32Bit;
  BackBits.Canvas.Lock;
end;

destructor TVirtualHeaderBar.Destroy;
begin
  BackBits.Canvas.Unlock;
  FreeAndNil(FBackBits);
  FreeAndNil(FAttribs);
  inherited Destroy;
end;

procedure TVirtualHeaderBar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle and not WS_EX_CLIENTEDGE;
end;

procedure TVirtualHeaderBar.CreateWnd;
begin
  inherited CreateWnd;
  ResizeBackBits(ClientWidth, ClientHeight);
end;

procedure TVirtualHeaderBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  ColumnModeView.ToggleSortDir;
end;

procedure TVirtualHeaderBar.ResizeBackBits(NewWidth, NewHeight: Integer);
begin
  // The Backbits grow to the largest window size
  if (NewWidth > BackBits.Width) then
    BackBits.Width := NewWidth;
  if NewHeight > BackBits.Height then
    BackBits.Height := NewHeight;
end;

procedure TVirtualHeaderBar.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
  Msg.Result := 1
end;

procedure TVirtualHeaderBar.WMPaint(var Msg: TWMPaint);
// The VCL does a poor job at optimizing the paint messages.  It does not look
// to see what rectangle the system actually needs painted.  Sometimes it only
// needs a small slice of the window painted, why paint it all?  This implementation
// also handles DoubleBuffering better
var
  PaintInfo: TPaintStruct;
  R: TRect;
  Pt, OffsetR: TPoint;
  i: Integer;
  DrawTextFlags: TCommonDrawTextWFlags;
  NS: TNamespace;
begin
  if UpdateCount = 0 then
  begin
    BackBits.Canvas.Lock;
    BeginPaint(Handle, PaintInfo);
    try
      if not IsRectEmpty(PaintInfo.rcPaint) then
      begin
        // Assign attributes to the Canvas used
        BackBits.Canvas.Font.Assign(Font);
        BackBits.Canvas.Font.Style := BackBits.Canvas.Font.Style + [fsBold];
        BackBits.Canvas.Brush.Color := clBlue;// Color;
        BackBits.Canvas.Brush.Assign(Brush);
        BackBits.Canvas.Brush.Style := bsClear;

        R := ClientRect;

        {$IFDEF SpTBX}
        if SkinManager.CurrentSkinName <> 'Default' then
        begin
          CurrentSkin.PaintBackground(BackBits.Canvas, R, skncHeader, sknsNormal, True, True);
        end else
       {$ENDIF SpTBX}
       {$IFDEF USETHEMES}
        if Themed then
        begin
          DrawThemeBackground(Themes.HeaderTheme, BackBits.Canvas.Handle, HP_HEADERITEM, HIS_NORMAL, R, nil);
        end else
        {$ENDIF USETHEMES}
        begin
          BackBits.Canvas.Brush.Color := Attribs.Color;
          BackBits.Canvas.FillRect(R);
        end;

        R := Rect(0, 0, 0, ClientHeight);
        for i := 0 to ColumnModeView.ViewCount - 1 do
        begin
          R.Right := R.Right + ColumnModeView.Views[i].Width;
          DrawTextFlags := [dtCenter, dtVCenter, dtSingleLine, dtEndEllipsis];

          BackBits.Canvas.Brush.Style := bsClear;
          NS := ColumnModeView.ViewNamespace(i);
          {$IFDEF USETHEMES}
            {$IFDEF SpTBX}
            if not Themed or (SkinManager.CurrentSkinName <> 'Default') then
            {$ELSE}
            if not Themed then
            {$ENDIF SpTBX}
            begin
              if ColumnModeView.Views[i] = ColumnModeView.FocusedView then
              begin
                R.Right := R.Right + ColumnModeView.ViewSplitter(i).Width;
                {$IFDEF SpTBX}
                CurrentSkin.PaintBackground(BackBits.Canvas, R, skncHeader, sknsHotTrack, True, False);
                 {$ENDIF SpTBX}
                R.Right := R.Right - ColumnModeView.ViewSplitter(i).Width;
              end;

              BackBits.Canvas.Brush.Style := bsClear;
              if Assigned(NS) and ColumnModeView.Views[i].Active then
                DrawTextWEx(BackBits.Canvas.Handle, NS.NameNormal, R, DrawTextFlags, 1);
            end;
          {$ELSE}
          if Assigned(NS) and ColumnModeView.Views[i].Active then
            DrawTextWEx(BackBits.Canvas.Handle, NS.NameNormal, R, DrawTextFlags, 1);
          {$ENDIF USETHEMES}

          R.Right := R.Right + ColumnModeView.ViewSplitter(i).Width;
          {$IFDEF SpTBX}
          if SkinManager.CurrentSkinName <> 'Default' then
            R.Left := R.Right - 2;
          {$ENDIF}
          // Dumb Themes assume TopLeft = 0,0.......
          SetWindowOrgEx(BackBits.Canvas.Handle, -R.Left, -R.Top, @Pt);
          OffsetR := R.TopLeft;
          OffsetRect(R, -R.Left, -R.Top);

          {$IFDEF SpTBX}
          if SkinManager.CurrentSkinName <> 'Default' then
            CurrentSkin.PaintBackground(BackBits.Canvas, R, skncSeparator, sknsNormal, True, True)
          else
          {$ENDIF}
          {$IFDEF USETHEMES}
          if Themed then
          begin
            R.Left := R.Right - ColumnModeView.Views[i].Width - ColumnModeView.ViewSplitter(i).Width;
            if ColumnModeView.Views[i] <> ColumnModeView.FocusedView then
              DrawThemeBackground(Themes.HeaderTheme, BackBits.Canvas.Handle, HP_HEADERITEM, HIS_NORMAL, R, nil)
            else
              DrawThemeBackground(Themes.HeaderTheme, BackBits.Canvas.Handle, HP_HEADERITEM, HIS_HOT, R, nil);

            if Assigned(NS) and ColumnModeView.Views[i].Active then
              DrawThemeText(Themes.HeaderTheme, BackBits.Canvas.Handle, HP_HEADERITEM, HIS_NORMAL, PWideChar( NS.NameNormal), -1, DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS, 0, R);
          end else
          {$ENDIF USETHEMES}
          begin
            if Attribs.Flat then
              DrawEdge(BackBits.Canvas.Handle, R, EDGE_ETCHED, BF_RECT)
            else
              DrawEdge(BackBits.Canvas.Handle, R, EDGE_RAISED, BF_RECT);
          end;
          OffsetRect(R, OffsetR.X, OffsetR.Y);
          SetWindowOrgEx(BackBits.Canvas.Handle, Pt.X, Pt.Y, nil);
          R.Left := R.Right;
        end;


        // Blast the bits to the screen
        BitBlt(PaintInfo.hdc, PaintInfo.rcPaint.Left, PaintInfo.rcPaint.Top,
          PaintInfo.rcPaint.Right - PaintInfo.rcPaint.Left,
          PaintInfo.rcPaint.Bottom - PaintInfo.rcPaint.Top,
          BackBits.Canvas.Handle, PaintInfo.rcPaint.Left, PaintInfo.rcPaint.Top, SRCCOPY);
      end
    finally
      BackBits.Canvas.Unlock;
      // Release the Handle from the canvas so that EndPaint may dispose of the DC as it sees fit
      EndPaint(Handle, PaintInfo);
    end
  end
end;

procedure TVirtualHeaderBar.WMWindowPosChanged(var Msg: TWMWindowPosChanged);
begin
  inherited;
  if Msg.WindowPos^.flags and SWP_NOSIZE = 0 then
    ResizeBackBits(Msg.WindowPos.cx, Msg.WindowPos.cy);
end;

procedure TVirtualHeaderBar.WMWindowPosChanging(var Msg: TWMWindowPosChanging);
begin
  inherited;
  if Msg.WindowPos^.flags and SWP_NOSIZE = 0 then
    ResizeBackBits(Msg.WindowPos.cx, Msg.WindowPos.cy);
end;

{ TVirtualHeaderBarAttributes}
constructor TVirtualHeaderBarAttributes.Create(AnOwner: TVirtualHeaderBar);
begin
  inherited Create;
  FFont := TFont.Create;
  Font.Style := Font.Style + [fsBold];
  FOwner := AnOwner;
  FColor := clBtnFace;
end;

destructor TVirtualHeaderBarAttributes.Destroy;
begin
  FreeAndNil(FFont);
  inherited Destroy;
end;

procedure TVirtualHeaderBarAttributes.Assign(Source: TPersistent);
var
  S: TVirtualHeaderBarAttributes;
begin
  if Source is TVirtualHeaderBarAttributes then
  begin
    S := TVirtualHeaderBarAttributes(Source);
    Color := S.Color;
    Flat := S.Flat;
    Font.Assign(S.Font)
  end
end;

procedure TVirtualHeaderBarAttributes.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Owner.Invalidate
  end
end;

procedure TVirtualHeaderBarAttributes.SetFlat(const Value: Boolean);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    Owner.Invalidate
  end
end;

{ TListModeDetails }
constructor TListModeDetails.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DetailInfoList := TList.Create;
  Align := alClient;
  Color := clWindow;
  BorderStyle := bsNone;
  BorderWidth := 0;
  BevelEdges := [];
  BevelWidth := 1;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  Ctl3D := False;
  BevelKind := bkNone;
  VertScrollBar.Smooth := True;
  HorzScrollBar.Smooth := True;
  VertScrollBar.Tracking := True;
  HorzScrollBar.Tracking := True;
  Tabstop := False;

  DoubleBuffered := True;
  Thumbnail := TImage.Create(Self);
  Thumbnail.ControlStyle := Thumbnail.ControlStyle + [csDoubleClicks, csClickEvents];
  Thumbnail.Align := alTop;
  Thumbnail.Height := 150;
  Thumbnail.Center := True;
  Thumbnail.Parent := Self;
  DetailsPaintBox := TPaintBox.Create(Self);
  DetailsPaintBox.Top := Thumbnail.Height + 1;
  DetailsPaintBox.Align := alTop;
  DetailsPaintBox.Parent := Self;
  DetailsPaintBox.OnPaint := OnDetailsPaint;
  OldWndProc := WindowProc;
  WindowProc := WindowProcHook;
end;

destructor TListModeDetails.Destroy;
begin
  FreeAndNil(FDetailInfoList);
  inherited Destroy;
end;

function TListModeDetails.MaxTitleWidth(DetailArray: TDetailInfoArray;
  AFont: TFont): TSize;
var
  i: Integer;
  Size: TSize;
begin
  Result.cx := 0;
  Result.cy := 0;
  for i := 0 to Length(DetailArray) - 1 do
  begin
    Size := TextExtentW(DetailArray[i].Title + ': ', AFont);
    if Size.cx > Result.cx then
      Result.cx := Size.cx;
    if Size.cy > Result.cy then
      Result.cy := Size.cy
  end;
  if Result.cy > ClientWidth then
     Result.cy := ClientWidth
end;

procedure TListModeDetails.ClearInfoList;
var
  i: Integer;
begin
  try
    for i := 0 to DetailInfoList.Count - 1 do
    begin
      Finalize(PDetailInfo( DetailInfoList[i])^);
      Dispose(PDetailInfo( DetailInfoList[i]));
    end
  finally
    DetailInfoList.Count := 0
  end
end;

procedure TListModeDetails.OnDetailsPaint(Sender: TObject);
var
  i: Integer;
  Info: PDetailInfo;
  DrawTextFlags: TCommonDrawTextWFlags;
begin
  if DetailInfoList.Count > 1 then
  begin
    DetailsPaintBox.Canvas.Font.Style := DetailsPaintBox.Canvas.Font.Style + [fsBold];
    DrawTextFlags := [dtRight, dtTop, dtEndEllipsis, dtSingleLine];
    for i := 0 to DetailInfoList.Count - 1 do
    begin
      Info := PDetailInfo( DetailInfoList[i]);
      if Info.Title <> '' then
        DrawTextWEx(DetailsPaintBox.Canvas.Handle, Info.Title, Info.TitleRect, DrawTextFlags, 1);
    end;

    DetailsPaintBox.Canvas.Font.Style := DetailsPaintBox.Canvas.Font.Style - [fsBold];
    DrawTextFlags := [dtLeft, dtTop];
    for i := 0 to DetailInfoList.Count - 1 do
    begin
      Info := PDetailInfo( DetailInfoList[i]);
      if (Info.Title <> '') and (RectHeight(Info.DetailRect) > 0) then
        DrawTextWEx(DetailsPaintBox.Canvas.Handle, Info.Detail, Info.DetailRect, DrawTextFlags, -1);
    end;
  end
end;

procedure TListModeDetails.ResizeLabels(NewClientW, NewClientH: Integer);
const
  SPACING = 4;

var
  i, MaxTitleWidth, MaxTitleHeight, Top, MinWidth: Integer;
  Info: PDetailInfo;
  DrawTextFlags: TCommonDrawTextWFlags;
  R: TRect;
begin
  if DetailInfoList.Count > 1 then
  begin
    SendMessage(Handle, WM_SETREDRAW, 0, 0);
    try
      DrawTextFlags := [dtCalcRect, dtRight, dtTop, dtCalcRectAdjR, dtSingleLine];
      DetailsPaintBox.Canvas.Font.Style := DetailsPaintBox.Canvas.Font.Style - [fsBold];
      R := Rect(0, 0, Screen.Width, 1);
      DrawTextWEx(DetailsPaintBox.Canvas.Handle, 'ABCD', R, DrawTextFlags, 1);
      MinWidth := RectWidth(R);


      DetailsPaintBox.Canvas.Font.Style := DetailsPaintBox.Canvas.Font.Style + [fsBold];
      MaxTitleHeight := 0;
      MaxTitleWidth := 0;

      DrawTextFlags := [dtCalcRect, dtRight, dtTop, dtCalcRectAdjR, dtEndEllipsis, dtSingleLine];
      for i := 0 to DetailInfoList.Count - 1 do
      begin
        Info := PDetailInfo( DetailInfoList[i]);
        Info.TitleRect := Rect(4, 0, ClientWidth, 1);
        if Info.Title <> '' then
        begin
          DrawTextWEx(DetailsPaintBox.Canvas.Handle, Info.Title, Info.TitleRect, DrawTextFlags, 1);
          if RectWidth(Info.TitleRect) > MaxTitleWidth then
            MaxTitleWidth := RectWidth(Info.TitleRect);
          if RectHeight(Info.TitleRect) > MaxTitleHeight then
            MaxTitleHeight := RectHeight(Info.TitleRect);
        end;
        if ClientWidth - MaxTitleWidth < MinWidth then
          MaxTitleWidth := ClientWidth - MinWidth;
      end;

      DrawTextFlags := [dtCalcRect, dtLeft, dtTop, dtCalcRectAdjR];
      for i := 0 to DetailInfoList.Count - 1 do
      begin
        Info := PDetailInfo( DetailInfoList[i]);
        Info.DetailRect := Rect(MaxTitleWidth + SPACING, 0, ClientWidth, 1);
        if Info.Title <> '' then
          DrawTextWEx(DetailsPaintBox.Canvas.Handle, Info.Detail, Info.DetailRect, DrawTextFlags, -1);
      end;

      Inc(MaxTitleWidth, 4);
      Top := 0;
      for i := 0 to DetailInfoList.Count - 1 do
      begin
        Info := PDetailInfo( DetailInfoList[i]);
        if Info.Title <> '' then
        begin
          if RectHeight(Info.DetailRect) > 0 then
          begin
            Info.TitleRect := Rect(4, Top, MaxTitleWidth, Top + RectHeight(Info.DetailRect) + 1);
            Info.DetailRect := Rect(Info.TitleRect.Right + SPACING, Top, ClientWidth, Top + RectHeight(Info.DetailRect) + 1);
          end else
            Info.TitleRect := Rect(4, Top, MaxTitleWidth, Top + RectHeight(Info.TitleRect) + 1);
          Top := Info.TitleRect.Bottom;
        end else
        begin
          Info.TitleRect := Rect(0, Top, ClientWidth, Top);
          Info.DetailRect := Rect(0, Top, ClientWidth, Top);
        end
      end;

      DetailsPaintBox.Height := Top

    finally
      SendMessage(Handle, WM_SETREDRAW, 1, 0);
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_ERASENOW or
          RDW_UPDATENOW or RDW_ALLCHILDREN or RDW_FRAME);
    end
  end
end;

procedure TListModeDetails.ShellExecuteNamespace;
begin
  if Assigned(ExplorerListview) then
    if ExplorerListview.Selection.Count = 1 then
      TCustomVirtualExplorerEasyListviewHack(ExplorerListview).DoShellExecute(ExplorerListview.Selection.First);
end;

procedure TListModeDetails.SplitCaption(ACaption: Widestring;
  var ATitle: WideString; var ADetail: WideString);
var
  W: PWideChar;
begin
  ATitle := '';
  ADetail := '';
  W := WideStrPos(PWideChar( ACaption), ':');
  if Assigned(W) then
  begin
    W^ := WideNull;
    ATitle := ACaption;
    SetLength(ATitle, lstrlenW(PWideChar( ATitle)));
    ATitle := ATitle + WideString(':');
    Inc(W, 1);
    // Calls the wrong Trim if not typecast to a WideString
    ADetail := Trim(WideString( W));
    SetLength(ADetail, lstrLenW(PWideChar( ADetail)));
    Dec(W, 1);
    W^ := WideChar(':');
  end
end;

procedure TListModeDetails.BuildDetailInfo(Details: TCommonWideStringDynArray);
var
  i: Integer;
  Info: PDetailInfo;
begin
  ClearInfoList;
  for i := 0 to Length(Details) - 1 do
  begin
    New(Info);
    ZeroMemory(Info, SizeOf(Info^));
    SplitCaption(Details[i], Info.Title, Info.Detail);
    DetailInfoList.Add(Info)
  end;
  ResizeLabels(ClientWidth, ClientHeight)
end;

procedure TListModeDetails.WindowProcHook(var Msg: TMessage);
begin
  if Msg.Msg = WM_LBUTTONDBLCLK then
  begin
    if (HiWord(Msg.lParam) < Thumbnail.BoundsRect.Bottom) and (LoWord(Msg.lParam) < Thumbnail.BoundsRect.Right) then
      ShellExecuteNamespace
  end else
  if Assigned(OldWndProc) then
    OldWndProc(Msg)
end;

procedure TListModeDetails.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
 // Msg.Result := 1;
  inherited
end;

procedure TListModeDetails.WMMouseActivate(var Msg: TWMMouseActivate);
begin
  Msg.Result := MA_NOACTIVATE;
  ActivateTopLevelWindow(Handle)
end;

procedure TListModeDetails.WMWindowPosChanging(var Msg: TWMWindowPosChanging);
begin
  inherited;
  if Msg.WindowPos^.flags and SWP_NOSIZE = 0 then
    ResizeLabels(Msg.WindowPos.cx, Msg.WindowPos.cy);
end;

constructor TColumnModeViewReportItem.Create(AnOwner: TEasyGroup);
begin
  inherited Create(AnOwner);
  MarlettFont.Size := 10;
  ArrowSize := TextExtentW('4', MarlettFont)
end;

procedure TColumnModeViewReportItem.ItemRectArray(Item: TEasyItem; Column: TEasyColumn; ACanvas: TCanvas; const Caption: WideString; var RectArray: TEasyRectArrayObject);
begin
  inherited ItemRectArray(Item, Column, ACanvas, Caption, RectArray);
  if (RectWidth(RectArray.TextRect) > ArrowSize.cx) then
  begin
    if RectArray.LabelRect.Right - ArrowSize.cx div 2 <  RectArray.TextRect.Right then
      RectArray.TextRect.Right := RectArray.TextRect.Right - ArrowSize.cx
  end
end;

procedure TColumnModeViewReportItem.PaintBefore(Item: TEasyItem; Column: TEasyColumn; const Caption: WideString; ACanvas: TCanvas; RectArray: TEasyRectArrayObject; var Handled: Boolean);
var
 R: TRect;
 Bits: TBitmap;
begin
  inherited PaintBefore(Item, Column, Caption, ACanvas, RectArray, Handled);
  if TColumnModeEasyListview( OwnerListview).ColumnModeView.BandHilight then
  begin
    if (Item.Index mod 2 = 0) and not Item.Selected then
    begin
      if TColumnModeEasyListview( OwnerListview).BackGround.Enabled then
      begin
        R := RectArray.BoundsRect;
        R.Right := Item.OwnerListview.ClientWidth;
        Bits := TBitmap.Create;
        try
          Bits.Width := RectWidth(R);
          Bits.Height := RectHeight(R);
          Bits.PixelFormat := pf32Bit;
          BitBlt(Bits.Canvas.Handle, 0, 0, RectWidth(R), RectHeight(R), ACanvas.Handle, R.Left, R.Top, SRCCOPY);
          AlphaBlend(0, Bits.Canvas.Handle, Rect(0, 0, RectWidth(R), RectHeight(R)), Point(0, 0), cbmConstantAlphaAndColor, 198, TColumnModeEasyListview( OwnerListview).ColumnModeView.BandHilightColor);
          ACanvas.Draw(R.Left, R.Top, Bits)
        finally
          Bits.Free
        end
      end else
      begin
        ACanvas.Brush.Color := TColumnModeEasyListview( OwnerListview).ColumnModeView.BandHilightColor;
        R := TEasyListview(Item.OwnerListview).Scrollbars.MapViewRectToWindowRect(RectArray.BoundsRect);
        R.Right := Item.OwnerListview.ClientWidth;
        R := TEasyListview(Item.OwnerListview).Scrollbars.MapWindowRectToViewRect(R);
        ACanvas.FillRect(R);
      end
    end
  end
end;

procedure TColumnModeViewReportItem.PaintText(Item: TEasyItem; Column: TEasyColumn; const Caption: WideString; RectArray: TEasyRectArrayObject; ACanvas: TCanvas; LinesToDraw: Integer);
begin
  inherited PaintText(Item, Column, Caption, RectArray, ACanvas, LinesToDraw);
  if (Item as TExplorerItem).Namespace.Folder then
  begin
    MarlettFont.Size := 10;
    ACanvas.Font.Assign(MarlettFont);
    ACanvas.TextOut(RectArray.LabelRect.Right - ArrowSize.cx, RectArray.LabelRect.Top + ((RectHeight(RectArray.LabelRect) - ArrowSize.cy) div 2), '4')
  end
end;

initialization
  RegisterClass(TVirtualColumnModeView);

finalization

end.
