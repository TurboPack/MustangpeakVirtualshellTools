unit VirtualShellToolBar;

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

{$include ..\Include\AddIns.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, 
  Buttons, ShellAPI, CommCtrl, ShlObj, ActiveX,
  Imglist, VirtualExplorerTree, ToolWin, MPDataObject,
  MPShellTypes, MPShellUtilities, VirtualResources, MPCommonObjects,
  MPCommonUtilities, MPThreadManager,
  Themes,
  UxTheme;  // Windows XP themes support for D5-D6. Get these units from www.delphi-gems.com.

const

  ID_TIMER_HOTTRACK = 400;
  ID_TIMER_HOTTRACKDELAY = 401;

  HOTTRACKDELAY = 100;         // Every 100ms look for the mouse to be out of the window
  CFSTR_VSTSHELLTOOLBAR = 'VST ShellToolbar';

type
   TCaptionOption = (
    coFolderName,     // Button will show the folder name for the caption
    coFolderPath,     // Button will show the full path of the folder
    coNoExtension,    // Button will show the folder name minus the extension
    coDriveLetterOnly // Only shows the drive letter for DriveToolbar
  );
  TCaptionOptions = set of TCaptionOption;


  TButtonPaintState = (
    psNormal,         // Button is in its normal state
    psHot,            // Button is in a Hot state, i.e. the mouse is over it
    psPressed,        // Button is Pressed
    psDropTarget      // Button is a drop target
  );

  TButtonState = (
    bsMouseInButton,
    bsThemesActive,
    bsRMouseButtonDown
  );
  TButtonStates = set of TButtonState;

  TShellToolbarContent = (
    stcFolders,     //  Folders are allowed to be dropped into toolbar
    stcFiles,       //  Any file is allowed to be dropped into toolbar
    stcPrograms     //  Program files (exe, bat, com) files are allowed to dropped into toolbar
  );
  TShellToolbarContents = set of TShellToolbarContent;

  TVirtualToolbarOption = (
    toAnimateHot,            // Pops the image and text "up" on mouse over
    toContextMenu,           // Allows RightClick ContextMenu on the buttons
    toCustomizable,          // The user can rearrange the buttons by drag drop
    toEqualWidth,            // In horz mode all button are the same size
    toFlat,                  // Draws the buttons in a flat state
    toInsertDropable,        // The user can add more buttons to the toolbar by drag and drop
    toLaunchDropable,        // The user can drop an object on the button to launch to button object
    toShellNotifyThread,     // Monitor shell activing to keep refreshed
    toThemeAware,            // Use Themes in XP
    toThreadedImages,
    toTile,                  // The buttons are tiled to fit in the window
    toTransparent,           // The background is not painted
    toUserDefinedClickAction,
    toLargeButtons           // Use large button images instead of small ones.
  );
  TVirtualToolbarOptions = set of TVirtualToolbarOption;

  TVirtualToolbarState = (
    tsBackBitsStale,         // The background bitmap (for transparency) needs refreshing
    tsThemesActive,          // Cached value since UsesThemes is slow in the theme units
    tsShellIDListValid,      // The CF_SHELLIDLIST format is available in the dataObject and contains the right content to be droppped
    tsVSTShellToobarValid,   // The CF_VSTSHELLTOOLBAR format is available in the dataObject and can be used
    tsDragInLaunchZone,      // Current position of drag is on a button where a drop will launch the dropped files
    tsDragInDropZone,        // Current postion of drag is in an area where a drop will be interperted as an insert request
    tsInsertImageVisible     // Set if the InsertImage is currently being shown
  );
  TVirtualToolbarStates = set of TVirtualToolbarState;

  TDriveSpecialFolder = (
    dsfDesktop,              // Show Desktop in TXPDriveToolbar
    dsfMyComputer,           // Show MyDesktop in TVirtualDriveToolbar
    dsfNetworkNeighborhood,  // Show NetworkNeighborhood in TVirtualDriveToolbar
    dsfRemovable,            // Show all Removable drives
    dsfReadOnly,             // Show all ReadOnly drives (CD for example)
    dsfFixedDrive             // Show all fixed drives
  );
  TDriveSpecialFolders = set of TDriveSpecialFolder;

  TSpecialFolder = ( // Defines what special folder to show in TSpecialFolderToolbar
    sfAdminTools,
    sfAltStartup,
    sfAppData,
    sfBitBucket,
    sfControlPanel,
    sfCookies,
    sfDesktop,
    sfDesktopDirectory,
    sfDrives,
    sfFavorites,
    sfFonts,
    sfHistory,
    sfInternet,
    sfInternetCache,
    sfLocalAppData,
    sfMyPictures,
    sfNetHood,
    sfNetwork,
    sfPersonal,
    sfPrinters,
    sfPrintHood,
    sfProfile,
    sfProgramFiles,
    sfCommonProgramFiles,
    sfPrograms,
    sfRecent,
    sfSendTo,
    sfStartMenu,
    sfStartUp,
    sfSystem,
    sfTemplate,
    sfWindows
  );
  TSpecialFolders = set of TSpecialFolder;

  TSpecialCommonFolder = (  // Had to split this off TSpecialFolders, more than 32 items
    sfCommonAdminTools,
    sfCommonAltStartup,
    sfCommonAppData,
    sfCommonDesktopDirectory,
    sfCommonDocuments,
    sfCommonFavorties,
    sfCommonPrograms,
    sfCommonStartMenu,
    sfCommonStartup,
    sfCommonTemplates
  );
  TSpecialCommonFolders = set of TSpecialCommonFolder;

type
  TCustomVirtualToolbar = class;              // forward
  TCustomWideSpeedButton = class;             // forward
  TShellToolButton = class;                   // forward

  PClipRec = ^TClipRec;
  TClipRec = packed record
    ButtonInstance: Pointer;
    Process: Cardinal;
    PIDLSize: integer;
    PIDL: array[0..0] of Byte;
  end;

  TVirtualButtonList = class(TList)
  private
    FToolbar: TCustomVirtualToolbar;  // Toolbar associated with this list
    FUpdateCount: integer;       // Used to stop any screen updates until EndUpdate is call and FUpdateCount goes to 0

    function GetItems(Index: integer): TCustomWideSpeedButton;
    procedure SetItems(Index: integer; const Value: TCustomWideSpeedButton);
  protected
    function CreateToolButton: TCustomWideSpeedButton; virtual;
  public
    function AddButton(Index: integer = -1): TCustomWideSpeedButton; virtual;
    procedure RemoveButton(Button: TCustomWideSpeedButton);
    procedure BeginUpdate;
    procedure EndUpdate;

    procedure Clear; override;

    property Items[Index: integer]: TCustomWideSpeedButton read GetItems write SetItems; default;
    property Toolbar: TCustomVirtualToolbar read FToolbar write FToolbar;
  end;

  TVirtualShellButtonList = class(TVirtualButtonList)
  private
    function GetItems(Index: integer): TShellToolButton;
    procedure SetItems(Index: integer; const Value: TShellToolButton);
  protected
    function CreateToolButton: TCustomWideSpeedButton; override;

  public
    function AddButton(Index: integer = -1): TCustomWideSpeedButton; override;

    property Items[Index: integer]: TShellToolButton read GetItems write SetItems; default;
  end;

  // Basic Toolbutton that can be created an placed on a TVirtualToolbar
  TCustomWideSpeedButton = class(TGraphicControl, IDropSource)
  private
    FCaption: WideString;             // The caption to be displayed
    FImageIndex: integer;             // Index of the image in the Toolbar's ImageList
    FPaintState: TButtonPaintState;   // Flags to determine how the button is painted
    FSpacing: integer;
    FMargin: integer;
    FLayout: TButtonLayout;
    FImageList: TCustomImageList;
    FOldOnFontChange: TNotifyEvent;
    FFlat: Boolean;
    FThemeAware: Boolean;
    FTransparent: Boolean;
    FOnDblClk: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FThemeToolbar: HTheme;
    FTimer: THandle;
    FTimerStub: ICallbackStub;
    FState: TButtonStates;
    FDragging: Boolean;
    FImageListChangeLink: TChangeLink;
    FHotAnimate: Boolean;
    FOLEDraggable: Boolean;

    function GetBottom: integer;
    function GetCaption: WideString; virtual;
    function GetImageIndex: integer; virtual;
    function GetImageList: TCustomImageList;
    function GetRight: integer;
    function GetThemeToolbar: HTheme;
    procedure ReadCaption(Reader: TReader);
    procedure SetCaption(const Value: WideString);
    procedure SetFlat(const Value: Boolean);
    procedure SetImageIndex(const Value: integer);
    procedure SetImageList(const Value: TCustomImageList);
    procedure SetLayout(const Value: TButtonLayout);
    procedure SetMargin(const Value: integer);
    procedure SetPaintState(const Value: TButtonPaintState);
    procedure SetSpacing(const Value: integer);
    procedure SetTransparent(const Value: Boolean);
    procedure SetThemeAware(const Value: Boolean);
    procedure WriteCaption(Writer: TWriter);

  protected
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure CalcButtonLayout(DC: HDC; const Client: TRect; const AnOffset: TPoint;
      const Caption: WideString; Layout: TButtonLayout; Margin, Spacing: Integer;
      var GlyphPos: TPoint; var TextBounds: TRect; BiDiFlags: Integer);
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure DoDblClk; virtual;
    procedure DoMouseLeave; virtual;
    procedure DoMouseEnter; virtual;
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; virtual;
    function DragOverOLE(grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; virtual;
    function DragLeave: HResult; virtual;
    procedure DrawButtonText(DC: HDC; const Caption: WideString; TextBounds: TRect;
      Enabled: Boolean; BiDiFlags: Longint);
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; virtual;
    procedure FontChange(Sender: TObject);
    procedure FreeThemes; dynamic;
    function GiveFeedback(dwEffect: Longint): HResult; virtual; stdcall;
    procedure ImageListChange(Sender: TObject);
    function LoadFromDataObject(const DataObject: ICommonDataObject): Boolean; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure PaintButton(DC: HDC; ForDragImage: Boolean = False); virtual;
    function QueryContinueDrag(fEscapePressed: BOOL; grfKeyState: Longint): HResult; virtual; stdcall;
    function SaveToDataObject(const DataObject: ICommonDataObject): Boolean; virtual;
    procedure SetBoundsR(Rect: TRect); // Sets the bounds using a TRect
    procedure SetParent(AParent: TWinControl); override;
    procedure StartHotTimer;
    procedure TimerStubProc(Wnd: HWnd; uMsg: UINT; idEvent: UINT; dwTime: DWORD); stdcall;

    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMThemeChanged(var Message: TMessage); message WM_THEMECHANGED;

    property Caption: WideString read GetCaption write SetCaption stored False; // Stored in DefineProperties
    property Flat: Boolean read FFlat write SetFlat default False;
    property HotAnimate: Boolean read FHotAnimate write FHotAnimate default False;
    property ImageIndex: integer read GetImageIndex write SetImageIndex default -1;
    property ImageList: TCustomImageList read GetImageList write SetImageList;
    property ImageListChangeLink: TChangeLink read FImageListChangeLink write FImageListChangeLink;
    property Layout: TButtonLayout read FLayout write SetLayout default blGlyphLeft;
    property Margin: integer read FMargin write SetMargin default -1;
    property OLEDraggable: Boolean read FOLEDraggable write FOLEDraggable default False;
    property OnDblClk: TNotifyEvent read FOnDblClk write FOnDblClk;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property PaintState: TButtonPaintState read FPaintState write SetPaintState;
    property Spacing: integer read FSpacing write SetSpacing default 4;
    property State: TButtonStates read FState write FState;
    property ThemeAware: Boolean read FThemeAware write SetThemeAware default True;
    property ThemeToolbar: HTheme read GetThemeToolbar;
    property Timer: THandle read FTimer;
    property TimerStub: ICallbackStub read FTimerStub;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddToUpdateRgn; virtual;
    procedure Click; override;
    procedure DefineProperties(Filer: TFiler); override;
    function Dragging: Boolean;
    function CalcMaxExtentRect(Font: TFont): TRect; virtual;
    function CalcMaxExtentSize(Font: TFont): TSize; virtual;
    procedure LoadFromStream(S: TStream); virtual;
    procedure RebuildButton;
    procedure SaveToStream(S: TStream); virtual;

    property Bottom: integer read GetBottom;
    property Right: integer read GetRight;
  end;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TWideSpeedButton = class(TCustomWideSpeedButton)
    property Action;
    property AutoSize;
    property Caption;
    property Color;
    property Constraints;
    property Enabled;
    property Flat;
    property Font;
    property ImageIndex;
    property ImageList;
    property HotAnimate;
    property Layout;
    property Margin;
    property ParentBiDiMode;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Spacing;
    property Tag;
    property ThemeAware;
    property Transparent;
    property Visible;
    property Width;

    property OnClick;
    property OnDblClk;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseLeave;
    property OnMouseEnter;
  end;

  // Specialized Toolbutton that just display static text for a toolbar caption
  TCaptionButton = class(TCustomWideSpeedButton)
  protected
    function CanResize(var NewWidth: Integer; var NewHeight: Integer): Boolean; override;
    procedure PaintButton(DC: HDC; ForDragImage: Boolean = False); override;
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CalcMaxExtentRect(Font: TFont): TRect; override;
  end;

  // Specialized Toolbutton that display Shell Namespace object through a TNamespace object
  TShellToolButton = class(TCustomWideSpeedButton)
  private
    FNamespace: TNamespace;
    FCaptionOptions: TCaptionOptions;
    function GetCaption: WideString; override;
    function GetImageIndex: integer; override;
    procedure SetCaptionOptions(const Value: TCaptionOptions);

  protected
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; override;
    function DragOverOLE(grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; override;
    function DragLeave: HResult; override;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; override;

    function SaveToDataObject(const DataObject: ICommonDataObject): Boolean; override;

    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
    procedure LoadFromStream(S: TStream); override;
    procedure SaveToStream(S: TStream); override;


    property Action;
    property AutoSize;
    property Caption: WideString read GetCaption;
    property CaptionOptions: TCaptionOptions read FCaptionOptions write SetCaptionOptions default [];
    property Color;
    property Constraints;
    property Enabled;
    property Flat;
    property Font;
    property ImageIndex: integer read GetImageIndex default -1;
    property HotAnimate;
    property Layout;
    property Margin default 2;
    property Namespace: TNamespace read FNamespace write FNamespace;
    property ParentBiDiMode;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Spacing;
    property Tag;
    property ThemeAware;
    property Transparent;
    property Visible;
    property Width;
    property OnClick;
    property OnDblClk;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseLeave;
    property OnMouseEnter;
  end;

  TCustomVirtualToolbar = class(TToolWindow, IDropTarget, IDropSource)
  private
    FBackBits: TBitmap;                     // Bitmap that caches the background for the toolbar (mainly for transparent mode)
    FButtonList: TVirtualButtonList;        // Array of buttons in order they are displayed
    FCaptionButton: TCaptionButton;         // Button instance that handles the static toolbar caption
    FHotTrackTimer: THandle;                // Timer started when mouse enters control to make sure all hot track are removed on mouse leave
    FLockUpdateCount: integer;              // Locks the toolbar so no button layout calculation or screen update are performed
    FOldFontChangeEvent: TNotifyEvent;      // Stores the old method associated with the OnChange event of the Font (if one was associated)
    FOptions: TVirtualToolbarOptions;        // Options for Toolbar
    FScrollBtnSize: integer;                // Width of the scroll button
    FStates: TVirtualToolbarStates;         // Dynamic state of Toolbar
    FThemeToolbar: HTHEME;                  // Toolbar control theme handle

    FButtonSpacing: integer;
    FButtonMargin: integer;
    FButtonLayout: TButtonLayout;
    FDropTargetHelper: IDropTargetHelper;
    FDropTarget: TCustomWideSpeedButton;
    FDragDropDataObj: IDataObject;
    FDropMarkRect: TRect;
    FContent: TShellToolbarContents;
    FDropInsertMargin: integer;
    FThreadedImagesEnabled: Boolean;
    FChangeNotifierEnabled: Boolean;
    FMalloc: IMalloc;
    FOnRecreateButtons: TNotifyEvent;
    FOnCreateButtons: TNotifyEvent;

    function GetAlign: TAlign;
    function GetBkGndParent: TWinControl;
    function GetEdgeBorders: TEdgeBorders;
    function GetEdgeInner: TEdgeStyle;
    function GetEdgeOuter: TEdgeStyle;
    function GetWideCaption: WideString;
    procedure ReadCaption(Reader: TReader);
    procedure SetAlign(const Value: TAlign);
    procedure SetBkGndParent(const Value: TWinControl);
    procedure SetEdgeBorders(const Value: TEdgeBorders);
    procedure SetEdgeOuter(const Value: TEdgeStyle);
    procedure SetEdgeInner(const Value: TEdgeStyle);
    procedure SetOptions(const Value: TVirtualToolbarOptions);
    procedure SetWideCaption(const Value: WideString);
    procedure WriteCaption(Writer: TWriter);
    function GetViewportBounds: TRect;
    procedure SetButtonLayout(const Value: TButtonLayout);
    procedure SetButtonSpacing(const Value: integer);
    procedure SetButtonMargin(const Value: integer);
    procedure SetThreadedImagesEnabled(const Value: Boolean);
    procedure SetChangeNotiferEnabled(const Value: Boolean);
  protected
  {$IFDEF EXPLORERTREE_L}
    FVirtualExplorerTree: TCustomVirtualExplorerTree; // Make D6 and CBuilder happy
  {$ENDIF}
    procedure ArrangeButtons;
    function CalcMaxButtonSize(Font: TFont): TSize;
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    function ClosestButtonEdge(ScreenPoint: TPoint): TRect;
    procedure CreateButtons; virtual;
    function CreateButtonList: TVirtualButtonList; virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DestroyWnd; override;
    procedure DoCreateButtons; virtual;
    procedure DoRecreateButtons; virtual;
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; virtual; stdcall;
    function IDropTarget.DragOver = DragOverOLE; // Naming Clash
    function DragOverOLE(grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; virtual; stdcall;
    function DragLeave: HResult; virtual; stdcall;
    procedure DrawDropMarker(MousePos: PPoint; ForceDraw: Boolean);
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; virtual; stdcall;
    procedure FontChangeNotify(Sender: TObject);
    procedure FreeThemes;
    function GiveFeedback(dwEffect: Longint): HResult; virtual; stdcall;
    function IsValidIDListData(DataObject: IDataObject): Boolean;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PaintToolbar(DC: HDC); virtual;
    procedure PaintWindow(DC: HDC); override;
    function PointToButton(ScreenPt: TPoint): TCustomWideSpeedButton;
    function PointToInsertIndex(ScreenPt: TPoint): integer;
    function QueryContinueDrag(fEscapePressed: BOOL; grfKeyState: Longint): HResult; virtual; stdcall;
    procedure ReCreateButtons;
    procedure ResizeCaptionButton;
    procedure SetName(const Value: TComponentName); override;
    procedure StoreBackGndBitmap;
    procedure UpdateDropStates(ScreenMousePos: TPoint);
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMNCDestroy(var Message: TWMNCDestroy); message WM_NCDESTROY;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMPrint(var Message: TWMPrint); message WM_PRINT;
    procedure WMPrintClient(var Message: TWMPrintClient); message WM_PRINTCLIENT;
    procedure WMRemoveButton(var Message: TMessage); message WM_REMOVEBUTTON;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMThemeChanged(var Message: TMessage); message WM_THEMECHANGED;
    procedure WMTimer(var Message: TMessage); message WM_TIMER;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;

    property Align: TAlign read GetAlign write SetAlign default alTop;
    property BackBits: TBitmap read FBackBits write FBackBits;
    property BkGndParent: TWinControl read GetBkGndParent write SetBkGndParent;
    property ButtonLayout: TButtonLayout read FButtonLayout write SetButtonLayout default blGlyphLeft;
    property ButtonMargin: integer read FButtonMargin write SetButtonMargin default -1;
    property ButtonSpacing: integer read FButtonSpacing write SetButtonSpacing default 4;
    property Caption: WideString read GetWideCaption write SetWideCaption stored False; // Never let VCL store Widestring, done in DefineProperites
    property CaptionButton: TCaptionButton read FCaptionButton write FCaptionButton;
    property ChangeNotifierEnabled: Boolean read FChangeNotifierEnabled write SetChangeNotiferEnabled;
    property Content: TShellToolbarContents read FContent write FContent default [stcFolders, stcFiles, stcPrograms];
    property DragDropDataObj: IDataObject read FDragDropDataObj;
    property DropInsertMargin: integer read FDropInsertMargin write FDropInsertMargin default 4;
    property DropMarkRect: TRect read FDropMarkRect;
    property DropTarget: TCustomWideSpeedButton read FDropTarget;
    property DropTargetHelper: IDropTargetHelper read FDropTargetHelper;
    property EdgeBorders: TEdgeBorders read GetEdgeBorders write SetEdgeBorders default [ebTop];
    property EdgeInner: TEdgeStyle read GetEdgeInner write SetEdgeInner default esRaised;
    property EdgeOuter: TEdgeStyle read GetEdgeOuter write SetEdgeOuter default esLowered;
    property HotTrackTimer: THandle read FHotTrackTimer write FHotTrackTimer;
    property Malloc: IMalloc read FMalloc;
    property OnCreateButtons: TNotifyEvent read FOnCreateButtons write FOnCreateButtons;
    property OnRecreateButtons: TNotifyEvent read FOnRecreateButtons write FOnRecreateButtons;
    property Options: TVirtualToolbarOptions read FOptions write SetOptions default [toThemeAware];
    property States: TVirtualToolbarStates read FStates;
    property ThemeToolbar: HTHEME read FThemeToolbar write FThemeToolbar default 0;
    property ThreadedImagesEnabled: Boolean read FThreadedImagesEnabled write SetThreadedImagesEnabled;
    property ViewportBounds: TRect read GetViewportBounds;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure BeginUpdate;
    procedure EndUpdate;
    procedure LoadFromFile(FileName: WideString); virtual;
    procedure LoadFromStream(S: TStream); virtual;
    procedure Loaded; override;
    procedure RebuildToolbar;
    procedure RecreateToolbar;
    procedure SaveToFile(FileName: WideString); virtual;
    procedure SaveToStream(S: TStream); virtual;

    property ButtonList: TVirtualButtonList read FButtonList;
  end;

  TVirtualToolbar = class(TCustomVirtualToolbar)
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BkGndParent;
    property ButtonLayout;
    property ButtonMargin;
    property ButtonSpacing;
    property Caption;
    property Color;
    property Constraints;
    property Content;
    property DropInsertMargin;
    property EdgeBorders;
    property EdgeInner;
    property EdgeOuter;
    property Font;
    property Options;

    property OnClick;
    property OnCreateButtons;
    property OnRecreateButtons;
  end;


  TVSTOnAddButtonEvent = procedure(Sender: TCustomVirtualToolbar; Namespace: TNamespace; var Allow: Boolean) of object;

  TCustomVirtualShellToolbar = class(TCustomVirtualToolbar)
  private
    FButtonCaptionOptions: TCaptionOptions;
  {$IFDEF EXPLORERCOMBOBOX_L}
    FVirtualExplorerComboBox: TCustomVirtualExplorerComboBox;
  {$ENDIF}
    FOnAddButton: TVSTOnAddButtonEvent;

    procedure SetButtonCaptionOptions(const Value: TCaptionOptions);
  {$IFDEF EXPLORERTREE_L}
    procedure SetVirtualExplorerTree(const Value: TCustomVirtualExplorerTree);
  {$ENDIF}
  {$IFDEF EXPLORERCOMBOBOX_L}
    procedure SetVirtualExplorerComboBox(const Value: TCustomVirtualExplorerComboBox);
  {$ENDIF}
  protected
    procedure ChangeLinkDispatch(PIDL: PItemIDList); virtual;
    function CreateButtonList: TVirtualButtonList; override;
    procedure DoAddButton(Namespace: TNamespace; var Allow: Boolean);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CMRecreateWnd(var Message: TMessage); message CM_RECREATEWND;
    procedure WMCommonThreadCallback(var Msg: TWMThreadRequest); message WM_COMMONTHREADCALLBACK;
    procedure WMShellNotify(var Msg: TMessage); message WM_SHELLNOTIFY;
    property ButtonCaptionOptions: TCaptionOptions read FButtonCaptionOptions write SetButtonCaptionOptions default [];
    property OnAddButton: TVSTOnAddButtonEvent read FOnAddButton write FOnAddButton;
  {$IFDEF EXPLORERCOMBOBOX_L}
    property VirtualExplorerComboBox: TCustomVirtualExplorerComboBox read FVirtualExplorerComboBox
      write SetVirtualExplorerComboBox;
  {$ENDIF}  
  {$IFDEF EXPLORERTREE_L}
    property VirtualExplorerTree: TCustomVirtualExplorerTree read FVirtualExplorerTree
      write SetVirtualExplorerTree;
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeLinkFreeing(ChangeLink: IVETChangeLink); dynamic;
  end;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualShellToolbar = class(TCustomVirtualShellToolbar)
  published
    property Align;
    property AutoSize;
    property BiDiMode;
    property BkGndParent;
    property ButtonCaptionOptions;
    property ButtonLayout;
    property ButtonMargin;
    property ButtonSpacing;
    property Caption;
    property Color;
    property Constraints;
    property EdgeBorders;
    property EdgeInner;
    property EdgeOuter;
    property Font;
    property Options;
    property PopupMenu;
  {$IFDEF EXPLORERCOMBOBOX_L}
    property VirtualExplorerComboBox;
  {$ENDIF}
  {$IFDEF EXPLORERTREE_L}
    property VirtualExplorerTree;
  {$ENDIF}
    property Visible;

    property OnClick;
    property OnCreateButtons;
    property OnRecreateButtons;
  end;

  TCustomVirtualDriveToolbar = class(TCustomVirtualShellToolbar)
  private
    FDriveSpecialFolders: TDriveSpecialFolders;

    function GetOptions: TVirtualToolbarOptions;
    procedure SetOptions(const Value: TVirtualToolbarOptions);
    procedure SetSpecialDriveFolders(const Value: TDriveSpecialFolders);
    procedure WMRemoveButton(var Message: TMessage); message WM_REMOVEBUTTON;
  protected
    procedure CreateButtons; override;

    property Options: TVirtualToolbarOptions read GetOptions write SetOptions default [toThemeAware];
    property SpecialDriveFolders: TDriveSpecialFolders read FDriveSpecialFolders
      write SetSpecialDriveFolders default [dsfRemovable, dsfReadOnly, dsfFixedDrive];
  public
    constructor Create(AOwner: TComponent); override;
  end;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualDriveToolbar = class(TCustomVirtualDriveToolbar)
  published
    property Align;
    property AutoSize;
    property BiDiMode;
    property BkGndParent;
    property ButtonCaptionOptions;
    property ButtonLayout;
    property ButtonMargin;
    property ButtonSpacing;
    property Caption;
    property Color;
    property Constraints;
    property DropInsertMargin;
    property EdgeBorders;
    property EdgeInner;
    property EdgeOuter;
    property Font;
    property OnAddButton;
    property Options;
    property PopupMenu;
    property SpecialDriveFolders;
  {$IFDEF EXPLORERCOMBOBOX_L}
    property VirtualExplorerComboBox;
  {$ENDIF}
  {$IFDEF EXPLORERTREE_L}
    property VirtualExplorerTree;
  {$ENDIF}
    property Visible;

    property OnClick;
    property OnCreateButtons;
    property OnRecreateButtons;
  end;

  TCustomVirtualSpecialFolderToolbar = class(TCustomVirtualDriveToolbar)
  private
    FSpecialFolders: TSpecialFolders;
    FSpecialCommonFolders: TSpecialCommonFolders;
    procedure SetSpecialFolders(const Value: TSpecialFolders);
    procedure SetSpecialCommonFolders(const Value: TSpecialCommonFolders);
  protected

    procedure CreateButtons; override;

    property SpecialFolders: TSpecialFolders read FSpecialFolders write SetSpecialFolders;
    property SpecialCommonFolders: TSpecialCommonFolders read FSpecialCommonFolders
      write SetSpecialCommonFolders;
  end;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualSpecialFolderToolbar = class(TCustomVirtualSpecialFolderToolbar)
  published
    property Align;
    property AutoSize;
    property BiDiMode;
    property BkGndParent;
    property ButtonCaptionOptions;
    property ButtonLayout;
    property ButtonMargin;
    property ButtonSpacing;
    property Caption;
    property Color;
    property Constraints;
    property DropInsertMargin;
    property EdgeBorders;
    property EdgeInner;
    property EdgeOuter;
    property Font;
    property OnAddButton;
    property Options;
    property PopupMenu;
    property SpecialFolders;
    property SpecialCommonFolders;
  {$IFDEF EXPLORERCOMBOBOX_L}
    property VirtualExplorerComboBox;
  {$ENDIF}
  {$IFDEF EXPLORERTREE_L}
    property VirtualExplorerTree;
  {$ENDIF}
    property Visible;

    property OnClick;
    property OnCreateButtons;
    property OnRecreateButtons;
  end;

type
  TVSTShellToolbar = class(TCommonClipboardFormat)
  private
    FProcess: Cardinal;
    FPIDL: PItemIDList;
    function GetPIDLSize: integer;
  public
    function GetFormatEtc: TFormatEtc; override;
    function LoadFromDataObject(DataObject: IDataObject): Boolean; override;
    function SaveToDataObject(DataObject: IDataObject): Boolean; override;

    property Process: Cardinal read FProcess;
    property PIDLSize: integer read GetPIDLSize;
    property PIDL: PItemIDList read FPIDL write FPIDL;
  end;

var
  CF_VSTSHELLTOOLBAR: TClipFormat;

implementation

uses
  System.Types, ActnList, Forms, VirtualShellNotifier;

function RectWidth(ARect: TRect): integer;
begin
  Result := ARect.Right - ARect.Left
end;

function RectHeight(ARect: TRect): integer;
begin
  Result := ARect.Bottom - ARect.Top
end;

{ TCustomWideSpeedButton }

procedure TCustomWideSpeedButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited;
  with TCustomAction(Sender) do
  begin
    if not CheckDefaults or (Self.Caption = '') or (Self.Caption = Self.Name) then
      Self.Caption := Caption;
    Self.ImageList := ActionList.Images;
    Self.ImageIndex := ImageIndex
  end;
  RebuildButton
end;

procedure TCustomWideSpeedButton.AddToUpdateRgn;

// Adds the button to the update region of the owner toolbar, taking into account
// any scrolling that the toolbar may be using it maps the physical coordinates into
// logical coordinates

var
  R: TRect;
begin
  R := BoundsRect;
  if Assigned(Parent) and Parent.HandleAllocated then
    InvalidateRect(Parent.Handle, @R, False);
end;

procedure TCustomWideSpeedButton.CalcButtonLayout(DC: HDC; const Client: TRect;
  const AnOffset: TPoint; const Caption: WideString; Layout: TButtonLayout;
  Margin, Spacing: Integer; var GlyphPos: TPoint; var TextBounds: TRect;
  BiDiFlags: Integer);
var
  TextPos: TPoint;
  ClientSize, GlyphSize, TextSize: TPoint;
  TotalSize: TPoint;
  CaptionANSI: AnsiString;
begin
  if (BiDiFlags and DT_RIGHT) = DT_RIGHT then
  begin
    if Layout = blGlyphLeft then
      Layout := blGlyphRight
    else
    if Layout = blGlyphRight then
      Layout := blGlyphLeft;
  end;

  // calculate the item sizes
  ClientSize := Point(Client.Right - Client.Left, Client.Bottom -
    Client.Top);

  if Assigned(ImageList) and (ImageIndex > -1) then
    with ImageList do
      GlyphSize := Point(Width, Height)
  else
    GlyphSize := Point(0, 0);

  if Length(Caption) > 0 then
  begin
    TextBounds := Rect(0, 0, Client.Right - Client.Left, 0);
    if IsUnicode then
      DrawTextW_MP(DC, PWideChar(Caption), Length(Caption), TextBounds,
        DT_CALCRECT or BiDiFlags)
    else begin
      CaptionANSI := AnsiString(Caption);
      DrawTextA(DC, PAnsiChar(CaptionANSI), Length(CaptionANSI), TextBounds,
        DT_CALCRECT or BiDiFlags)
    end;
    TextSize := Point(TextBounds.Right - TextBounds.Left, TextBounds.Bottom -
      TextBounds.Top);
  end
  else
  begin
    TextBounds := Rect(0, 0, 0, 0);
    TextSize := Point(0,0);
  end;

  // If the layout has the glyph on the right or the left, then both the
  // text and the glyph are centered vertically.  If the glyph is on the top
  // or the bottom, then both the text and the glyph are centered horizontally.
  if Layout in [blGlyphLeft, blGlyphRight] then
  begin
    GlyphPos.Y := (ClientSize.Y - GlyphSize.Y + 1) div 2;
    TextPos.Y := (ClientSize.Y - TextSize.Y + 1) div 2;
  end
  else
  begin
    GlyphPos.X := (ClientSize.X - GlyphSize.X + 1) div 2;
    TextPos.X := (ClientSize.X - TextSize.X + 1) div 2;
  end;

  // if there is no text or no bitmap, then Spacing is irrelevant
  if (TextSize.X = 0) or (GlyphSize.X = 0) then
    Spacing := 0;

  // adjust Margin and Spacing
  if Margin = -1 then
  begin
    if Spacing = -1 then
    begin
      TotalSize := Point(GlyphSize.X + TextSize.X, GlyphSize.Y + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then
        Margin := (ClientSize.X - TotalSize.X) div 3
      else
        Margin := (ClientSize.Y - TotalSize.Y) div 3;
      Spacing := Margin;
    end
    else
    begin
      TotalSize := Point(GlyphSize.X + Spacing + TextSize.X, GlyphSize.Y +
        Spacing + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then
        Margin := (ClientSize.X - TotalSize.X + 1) div 2
      else
        Margin := (ClientSize.Y - TotalSize.Y + 1) div 2;
    end;
  end
  else
  begin
    if Spacing = -1 then
    begin
      TotalSize := Point(ClientSize.X - (Margin + GlyphSize.X), ClientSize.Y -
        (Margin + GlyphSize.Y));
      if Layout in [blGlyphLeft, blGlyphRight] then
        Spacing := (TotalSize.X - TextSize.X) div 2
      else
        Spacing := (TotalSize.Y - TextSize.Y) div 2;
    end;
  end;

  case Layout of
    blGlyphLeft:
      begin
        GlyphPos.X := Margin;
        TextPos.X := GlyphPos.X + GlyphSize.X + Spacing;
      end;
    blGlyphRight:
      begin
        GlyphPos.X := ClientSize.X - Margin - GlyphSize.X;
        TextPos.X := GlyphPos.X - Spacing - TextSize.X;
      end;
    blGlyphTop:
      begin
        GlyphPos.Y := Margin;
        TextPos.Y := GlyphPos.Y + GlyphSize.Y + Spacing;
      end;
    blGlyphBottom:
      begin
        GlyphPos.Y := ClientSize.Y - Margin - GlyphSize.Y;
        TextPos.Y := GlyphPos.Y - Spacing - TextSize.Y;
      end;
  end;

  // fixup the result variables
  with GlyphPos do
  begin
    Inc(X, Client.Left + AnOffset.X);
    Inc(Y, Client.Top + AnOffset.Y);
  end;
  OffsetRect(TextBounds, TextPos.X + Client.Left + AnOffset.X,
    TextPos.Y + Client.Top + AnOffset.X);
end;

function TCustomWideSpeedButton.CalcMaxExtentRect(Font: TFont): TRect;

// Calculates the size of the rectangle that is necessary to completely display
// the Caption, Glyph, user defined Margin, user defined Spacing, and any button
// frame or border. Also takes into acount if the image is above/below the caption
// or right/left of caption

const
  BorderMargin = 6;
var
  Size: TSize;
  Delta: integer;
begin
  Delta := 0;
  if Margin > -1 then
    Inc(Delta, Margin);
  if Spacing > -1 then
    Inc(Delta, Spacing);

  Size := TextExtentW(PWideChar(Caption), Font);

  if Assigned(ImageList) then
  begin
    if Layout in [blGlyphLeft, blGlyphRight] then
      Size.cx := Size.cx + ImageList.Width
    else
      Size.cy := Size.cy + ImageList.Height
  end;

  if Layout in [blGlyphLeft, blGlyphRight] then
    SetRect(Result, 0, 0, Size.cx + Delta + BorderMargin, Size.cy + BorderMargin)
  else
    SetRect(Result, 0, 0, Size.cx + BorderMargin, Size.cy + + BorderMargin + Delta);
end;

function TCustomWideSpeedButton.CalcMaxExtentSize(Font: TFont): TSize;
var
  R: TRect;
begin
  R := CalcMaxExtentRect(Font);
  Result.cx := RectWidth(R);
  Result.cy := RectHeight(R);
end;

function TCustomWideSpeedButton.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
var
  Size: TSize;
begin
  Result := inherited CanAutoSize(NewWidth, NewHeight);
  Size := CalcMaxExtentSize(Font);
  if NewWidth < Size.cx then
    NewWidth := Size.cx;
  if NewHeight < Size.cy then
    NewHeight := Size.cy
end;

procedure TCustomWideSpeedButton.Click;
// Fires the OnClick event in the parent toolbar
begin
  if not Dragging then
    inherited
end;

procedure TCustomWideSpeedButton.CMMouseEnter(var Message: TMessage);
begin
  if (csLButtonDown in ControlState) then
    PaintState := psPressed;
  Include(FState, bsMouseInButton);
  if Transparent and HotAnimate then
    Invalidate;
  DoMouseEnter
end;

procedure TCustomWideSpeedButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  PaintState := psNormal;
  Exclude(FState, bsMouseInButton);
  if Transparent and (Flat or HotAnimate) then
    Invalidate;
  DoMouseLeave
end;

constructor TCustomWideSpeedButton.Create(AOwner: TComponent);
begin
  inherited;
  FMargin := -1;
  FSpacing := 4;
  Width := 23;
  Height := 22;
  Enabled := True;
  ImageIndex := -1;
  Visible := True;
  ThemeAware := True;
  ControlStyle := ControlStyle - [csDoubleClicks]; // Map DblClicks to a click
  FOldOnFontChange := Font.OnChange;
  Font.OnChange := FontChange;
  Constraints.MinHeight := 22;
  Constraints.MinWidth := 23;
  FImageListChangeLink := TChangeLink.Create;
  FImageListChangeLink.OnChange := ImageListChange;
  FTimerStub := TCallbackStub.Create(Self, @TCustomWideSpeedButton.TimerStubProc, 4);
end;

procedure TCustomWideSpeedButton.DefineProperties(Filer: TFiler);

// Defines the WideString as a custom property with the custom name WideText.
// Acorrding to Mike Lischke the VCL streaming screws up streaming of WideStrings

begin
  inherited;
  Filer.DefineProperty('WideText', ReadCaption, WriteCaption, Caption <> '');
end;

destructor TCustomWideSpeedButton.Destroy;
begin
  Font.OnChange := FOldOnFontChange;
  FreeThemes;
  ImageListChangeLink.Free;
  inherited
end;

procedure TCustomWideSpeedButton.DoDblClk;
begin
  if Assigned(OnDblClk) then
    OnDblClk(Self)
end;

procedure TCustomWideSpeedButton.DoMouseEnter;
begin
  if Assigned(OnMouseEnter) then
    OnMouseEnter(Self)
end;

procedure TCustomWideSpeedButton.DoMouseLeave;
begin
  if Assigned(OnMouseLeave) then
    OnMouseLeave(Self)
end;

function TCustomWideSpeedButton.DragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  PaintState := psDropTarget;
  Result := S_OK;
end;

function TCustomWideSpeedButton.Dragging: Boolean;
begin
  Result := FDragging;
end;

function TCustomWideSpeedButton.DragLeave: HResult;
begin
  PaintState := psNormal;
  Result := S_OK;
end;

function TCustomWideSpeedButton.DragOverOLE(grfKeyState: Integer;
  pt: TPoint; var dwEffect: Integer): HResult;
begin
  Result := S_OK;
end;

procedure TCustomWideSpeedButton.DrawButtonText(DC: HDC; const Caption: WideString;
  TextBounds: TRect; Enabled: Boolean; BiDiFlags: Integer);
var
  CaptionANSI: AnsiString;
  OldColor, Flags, OldMode: Longword;
begin
  Flags := 0;
  OldMode := SetBkMode(DC, Windows.TRANSPARENT);
  if IsUnicode then
  begin
    Flags := {DT_CENTER or }DT_VCENTER or BiDiFlags;
    if not Enabled then
    begin
      OffsetRect(TextBounds, 1, 1);
      OldColor := SetTextColor(DC, ColorToRGB(clBtnHighlight));
      DrawTextW_MP(DC, PWideChar(Caption), Length(Caption), TextBounds, Flags);
      OffsetRect(TextBounds, -1, -1);
      SetTextColor(DC, ColorToRGB(clBtnShadow));
      DrawTextW_MP(DC, PWideChar(Caption), Length(Caption), TextBounds, Flags);
      SetTextColor(DC, ColorToRGB(OldColor));
    end else
      DrawTextW_MP(DC, PWideChar(Caption), Length(Caption), TextBounds, Flags);
  end else
  begin
    CaptionANSI := AnsiString(Caption);
    if not Enabled then
    begin
      OffsetRect(TextBounds, 1, 1);
      OldColor := SetTextColor(DC, ColorToRGB(clBtnHighlight));
      DrawText(DC, Caption, Length(Caption), TextBounds, Flags);
      OffsetRect(TextBounds, -1, -1);
      SetTextColor(DC, ColorToRGB(clBtnShadow));
      DrawTextA(DC, PAnsiChar(CaptionANSI), Length(Caption), TextBounds, Flags);
      SetTextColor(DC, ColorToRGB(OldColor));
    end else
      DrawTextA(DC, PAnsiChar(CaptionANSI), Length(Caption), TextBounds, Flags);
  end;
  SetBkMode(DC, OldMode);
end;


function TCustomWideSpeedButton.Drop(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  PaintState := psNormal;
  Invalidate;
  Update;
  Result := S_OK;
end;

procedure TCustomWideSpeedButton.FontChange(Sender: TObject);
begin
  if Assigned(FOldOnFontChange) then
    FOldOnFontChange(Sender);
  RebuildButton
end;

procedure TCustomWideSpeedButton.FreeThemes;
begin
  if FThemeToolbar <> 0 then
  begin
    CloseThemeData(FThemeToolbar);
    FThemeToolbar := 0;
    Exclude(FState, bsThemesActive)
  end;
end;

function TCustomWideSpeedButton.GetBottom: integer;
begin
  Result := Top + Height
end;

function TCustomWideSpeedButton.GetCaption: WideString;
begin
  Result := FCaption;
end;

function TCustomWideSpeedButton.GetImageIndex: integer;
begin
  Result := FImageIndex
end;

function TCustomWideSpeedButton.GetImageList: TCustomImageList;
begin
  Result := FImageList;
end;

function TCustomWideSpeedButton.GetRight: integer;
begin
  Result := Left + Width
end;

function TCustomWideSpeedButton.GetThemeToolbar: HTheme;
begin
  if (FThemeToolbar = 0) and Assigned(Parent) and Parent.HandleAllocated then
    FThemeToolbar := OpenThemeData(Parent.Handle, 'toolbar');
  Result := FThemeToolbar
end;

function TCustomWideSpeedButton.GiveFeedback(dwEffect: Integer): HResult;
begin
  Result := DRAGDROP_S_USEDEFAULTCURSORS
end;

procedure TCustomWideSpeedButton.ImageListChange(Sender: TObject);
begin
  //The Image list is changed (something has been added, deleted or moved).
  RebuildButton
end;

function TCustomWideSpeedButton.LoadFromDataObject(const DataObject: ICommonDataObject): Boolean;
begin
  Result := False;
end;

procedure TCustomWideSpeedButton.LoadFromStream(S: TStream);
begin
  // Load here
end;

procedure TCustomWideSpeedButton.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FImageList) then
  begin
    FImageList := nil;
    RebuildButton
  end;
end;

procedure TCustomWideSpeedButton.Paint;
begin
  Canvas.Font.Assign(Font);
  PaintButton(Canvas.Handle);
end;

procedure TCustomWideSpeedButton.PaintButton(DC: HDC; ForDragImage: Boolean = False);

  function GetCColor(Color1, Color2: TColor; total, weight2 :Integer): TColor;
  var //weight1: 0->Color1, total->Color2
    C1, C2: TColor;
    R1, G1, B1, R2, G2, B2: Byte;
    Nr, Ng, Nb: Integer;
  begin
    C1:=ColorToRGB(Color1);
    C2:=ColorToRGB(Color2);
    R1:=PByte(@C1)^;
    G1:=PByte(Integer(@C1)+1)^;
    B1:=PByte(Integer(@C1)+2)^;
    R2:=PByte(@C2)^;
    G2:=PByte(Integer(@C2)+1)^;
    B2:=PByte(Integer(@C2)+2)^;
    if total<>0 then
      begin
        Nr:=(R1+(R2-R1)*weight2 div total);
        Ng:=(G1+(G2-G1)*weight2 div total);
        Nb:=(B1+(B2-B1)*weight2 div total);
        if (Nr<0)   then Nr:=0;
        if (Nr>255) then Nr:=255;
        if (Ng<0)   then Ng:=0;
        if (Ng>255) then Ng:=255;
        if (Nb<0)   then Nb:=0;
        if (Nb>255) then Nb:=255;
        Result:=RGB(Nr, Ng, Nb);
      end
    else
      Result:=Color1;
  end;

// This Paint method makes the assumption that the HDC has shifted its viewport such
// to compenstate for any scrolling in the parent window.  The button will paint itself
// to the canvas at the Bounds rect of the button which may be positioned far off the
// screen if the viewport of the DC is not shifted

var
  R, TempR: TRect;
  PartType, PartState: Longword;
  Brush: TBrush;

  Offset, GlyphPos: TPoint;
  TextRect, GlyphRect: TRect;
  BiDiFlags, dwTextFlags2, rgbFg: Longword;
// OldOrg: TPoint;
begin
  if Visible then
  begin

  // set up some structures that are needed regardless if Theme drawing or not
    R := ClientRect;

    // Used in the icon and text positioning calculations
    if PaintState = psPressed then
    begin
      Offset.x := 1;
      Offset.y := 1;
    end else
    if (PaintState = psHot) and HotAnimate then
    begin
      Offset.x := -1;
      Offset.y := -1;
    end else
    begin
      Offset.x := 0;
      Offset.y := 0;
    end;

    // See if we are in Right to Left mode
    BiDiFlags := DrawTextBiDiModeFlags(0);

    // Themes for toolbars does not define the background so paint it for either
    if not Transparent or ForDragImage then
    begin
      Brush := TBrush.Create;
      if Enabled then
        Brush.Color := Color
      else
        Brush.Color := GetCColor(clBtnFace, Color, 100, 10);
      FillRect(DC, R, Brush.Handle);
      Brush.Free
    end;

    // Draw in Themes?
    if ThemeAware and (bsThemesActive in State) then
    begin

      PartType := TP_BUTTON;

      case PaintState of
        psHot:      PartState := TS_HOT;
        psPressed:  PartState := TS_PRESSED;
      else
        PartState := TS_NORMAL
      end;

      if ForDragImage then
        PartState := TS_HOT;

      if not Enabled then
        PartState := TS_DISABLED;

      DrawThemeBackground(ThemeToolbar, DC, PartType, PartState, R, nil);
      GetThemeBackgroundContentRect(ThemeToolbar, DC, PartType, PartState, R, @R);

      CalcButtonLayout(DC, R, Offset, Caption, Layout, Margin, Spacing, GlyphPos, TextRect, BiDiFlags);
      if Assigned(ImageList) and (ImageIndex > -1) then
      begin
        // Create an image rectangle from the position and the imagelist size
        SetRect(GlyphRect, GlyphPos.x, GlyphPos.y, GlyphPos.x + ImageList.Width, GlyphPos.y + ImageList.Height);

        // For some reason DrawThemeIcon won't work in the IDE
        if csDesigning in ComponentState then
          ImageList_DrawEx(ImageList.Handle, ImageIndex, DC, GlyphPos.X, GlyphPos.Y, 0, 0, CLR_NONE, CLR_NONE, ILD_TRANSPARENT)
        else
          DrawThemeIcon(ThemeToolbar, DC, PartType, PartState, GlyphRect, ImageList.Handle, ImageIndex);
      end;

      if not Enabled then
        dwTextFlags2 := DTT_GRAYED
      else
        dwTextFlags2 := 0;

      DrawThemeText(ThemeToolbar, DC, PartType, PartState, PWideChar(Caption),
        Length(Caption), BiDiFlags, dwTextFlags2, TextRect);
    end else // No Themes
    begin

      // if Flat and the the button is hot so 3D frame it to "raise" it up
      if ((PaintState = psHot) or (csDesigning in ComponentState)) and Flat then
        DrawEdge(DC, R, BDR_RAISEDINNER, BF_RECT);

      // if not Flat always draw the edge the hardway so the buttons can be truly
      // transparent
      if not Flat and (PaintState <> psPressed) or ForDragImage then
      begin
        TempR := R;
        InflateRect(TempR, 1, 1);
        OffsetRect(TempR, -2, -2);
        FrameRect(DC, TempR, GetStockObject(GRAY_BRUSH));
        OffsetRect(TempR, 3, 3);
        FrameRect(DC, TempR, GetStockObject(WHITE_BRUSH));
        OffsetRect(TempR, -2, -2);
        FrameRect(DC, TempR, GetStockObject(BLACK_BRUSH));
      end;

      // If pressed draw the button pushed "into" the toolbar
      if PaintState = psPressed then
        DrawEdge(DC, R, EDGE_SUNKEN, BF_RECT);

      // Use the extra variable
      dwTextFlags2 := ILD_TRANSPARENT;
      rgbFg := CLR_NONE;

      // If it is not enabled blend it with to backgound to make it weaker looking
      if not Enabled then
      begin
        rgbFg := ColorToRGB(Color);
        dwTextFlags2 :=  dwTextFlags2 or ILD_BLEND50;
      end;

      //  We know that the Draw Edge may have used 2 pixels account for them in the rect
      InflateRect(R, -2, -2);

      // Calcuate the rectangle for the Text and the postion of the Glyph
      CalcButtonLayout(DC, R, Offset, Caption, Layout, Margin, Spacing, GlyphPos, TextRect, BiDiFlags);

      // Draw the Glyph and the Text
      if Assigned(ImageList) and (ImageIndex > -1) then
        ImageList_DrawEx(ImageList.Handle, ImageIndex, DC, GlyphPos.X, GlyphPos.Y, 0, 0, CLR_NONE, rgbFg, dwTextFlags2);
      DrawButtonText(DC, Caption, TextRect, Enabled, BiDiFlags);
    end
  end;

  if PaintState = psDropTarget then
    DrawFocusRect(DC, ClientRect)
end;

function TCustomWideSpeedButton.QueryContinueDrag(fEscapePressed: BOOL;
  grfKeyState: Integer): HResult;
begin
  Result := S_OK;

  if fEscapePressed then
    Result := DRAGDROP_S_CANCEL
  else
{  if MouseManager.IsButtonDown(mbLeft) then
  begin
    if grfKeyState and MK_LBUTTON > 0 then  // is the LButton flag set?
      Result := S_OK                        // Button is still down
    else
      Result := DRAGDROP_S_DROP;            // Button has been released
  end;  else  if MouseButtonMgr.MouseDown(mbLeft)      }
  if bsRMouseButtonDown in State then
  begin
    if grfKeyState and MK_RBUTTON > 0 then  // is the RButton flag set?
      Result := S_OK                        // Button is still down
    else
      Result := DRAGDROP_S_DROP;            // Button has been released
  end
 {
  begin
    if grfKeyState and MK_MBUTTON > 0 then // is the MButton flag set?
      Result := S_OK                       // Button is still down
    else
      Result := DRAGDROP_S_DROP            // Button has been released
  end// else  if MouseButtonMgr.MouseDown(mbMiddle)
  //  Result := S_OK;     }
end;

procedure TCustomWideSpeedButton.ReadCaption(Reader: TReader);

// The Read procedure for the DefineProperty "WideText"

begin
  Caption := Reader.ReadString;
end;

procedure TCustomWideSpeedButton.RebuildButton;
begin
  if AutoSize then
    AdjustSize;
  AddToUpdateRgn;
  Perform(WM_THEMECHANGED, 0, 0);
end;

function TCustomWideSpeedButton.SaveToDataObject(const DataObject: ICommonDataObject): Boolean;
begin
  Result := False;
end;

procedure TCustomWideSpeedButton.SaveToStream(S: TStream);
begin
  // Save stuff here
end;

procedure TCustomWideSpeedButton.SetBoundsR(Rect: TRect);
begin
  SetBounds(Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top)
end;

procedure TCustomWideSpeedButton.SetCaption(const Value: WideString);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    RebuildButton
  end
end;

procedure TCustomWideSpeedButton.SetFlat(const Value: Boolean);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    RebuildButton
  end
end;

procedure TCustomWideSpeedButton.SetImageIndex(const Value: integer);
begin
  if Value <> FImageIndex then
  begin
    FImageIndex := Value;
    RebuildButton
  end
end;

procedure TCustomWideSpeedButton.SetImageList(const Value: TCustomImageList);
begin
  if FImageList <> Value then
  begin
    if FImageList <> nil then
      FImageList.UnRegisterChanges(FImageListChangeLink);
    FImageList := Value;
    if ImageList <> nil then
    begin
      ImageList.RegisterChanges(FImageListChangeLink);
      ImageList.FreeNotification(Self); // Incase the image list is in a different form
    end;
    ImageListChange(Self);
  end
end;

procedure TCustomWideSpeedButton.SetLayout(const Value: TButtonLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    RebuildButton
  end
end;

procedure TCustomWideSpeedButton.SetMargin(const Value: integer);
begin
  if FMargin <> Value then
  begin
    FMargin := Value;
    RebuildButton
  end
end;

procedure TCustomWideSpeedButton.SetPaintState(const Value: TButtonPaintState);
begin
  FPaintState := Value;
  if HotAnimate or Flat or ThemeAware then  // Stop flicker if nothing to repaint
    AddToUpdateRgn
end;

procedure TCustomWideSpeedButton.SetParent(AParent: TWinControl);
begin
  inherited;
  Perform(WM_THEMECHANGED, 0, 0);
end;

procedure TCustomWideSpeedButton.SetSpacing(const Value: integer);
begin
  if FSpacing <> Value then
  begin
   FSpacing := Value;
    RebuildButton
  end
end;

procedure TCustomWideSpeedButton.SetThemeAware(const Value: Boolean);
begin
  if FThemeAware <> Value then
  begin
    FThemeAware := Value;
    RebuildButton
  end
end;

procedure TCustomWideSpeedButton.StartHotTimer;
// Start timer to monitor the Hot state and clear it if we miss a CM_MOUSELEAVE
// It is necessary to use the Stub and the TimerProc so we get timers during OLE
// drag and drop
begin
  // Set a timer to remove the Hot track if we miss the CM_MOUSELEAVE
  if (FTimer = 0) and (Flat or (bsThemesActive in State)) then
   // The timerID uses object address for a unique value
    FTimer := SetTimer(Parent.Handle, ID_TIMER_HOTTRACKDELAY, HOTTRACKDELAY, TimerStub.StubPointer);
end;

procedure TCustomWideSpeedButton.TimerStubProc(Wnd: HWnd; uMsg, idEvent: UINT;
  dwTime: DWORD);
var
  Temp: integer;
begin
  if not PtInRect(ClientRect, ScreenToClient(Mouse.CursorPos)) and (FTimer <> 0)  then
  begin
    Temp := FTimer;
    FTimer := 0;
    KillTimer(Parent.Handle, Temp);
    if bsMouseInButton in State then
      Perform(CM_MOUSELEAVE, 0, 0);
    PaintState := psNormal;
    if Transparent and (Flat or HotAnimate) then
      Invalidate;
  end
end;

procedure TCustomWideSpeedButton.SetTransparent(const Value: Boolean);
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;

    // Don't let the parent clip the DC before drawing the window below the button
    if Value then
      ControlStyle := ControlStyle - [csOpaque]
    else
      ControlStyle := ControlStyle + [csOpaque];

    RebuildButton;
    Visible := False;
    if Assigned(Parent) and Parent.HandleAllocated then
      Parent.Invalidate;
    Visible := True;
  end
end;

procedure TCustomWideSpeedButton.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  inherited;
  if not Dragging then
    DoDblClk;
end;

procedure TCustomWideSpeedButton.WMRButtonDown(var Message: TWMRButtonDown);
var
  DataObject: ICommonDataObject;
  dwOkEffects, dwEffect: integer;
  DragImage: TBitmap;
  LogicalPerformedDropEffect: TCommonLogicalPerformedDropEffect;
  OldCapture: HWND;
begin
  Include(FState, bsRMouseButtonDown);
  inherited;
  if OLEDraggable then
  begin
    OldCapture := Mouse.Capture;
    FDragging := DragDetectPlus(Parent.Handle, ClientToScreen(SmallPointToPoint(Message.Pos)));
    if Dragging then
      try
        PaintState := psNormal;
        Parent.Invalidate;
        Parent.Update;

        DataObject := TCommonDataObject.Create as ICommonDataObject;

        DragImage := TBitmap.Create;
        DragImage.Width := Width;
        DragImage.Height := Height;
        PaintButton(DragImage.Canvas.Handle, True);
        DataObject.AssignDragImage(DragImage, Point(Message.XPos, Message.YPos), Color);
        FreeAndNil(DragImage);

        dwOkEffects := DROPEFFECT_COPY or DROPEFFECT_MOVE or DROPEFFECT_LINK;

        if SaveToDataObject(DataObject) then
          DoDragDrop(DataObject, Self, dwOkEffects, dwEffect);


        LogicalPerformedDropEffect := TCommonLogicalPerformedDropEffect.Create;
        if LogicalPerformedDropEffect.LoadFromDataObject(DataObject) then
        begin
          if LogicalPerformedDropEffect.Action = effectMove then
            PostMessage(Parent.Handle, WM_REMOVEBUTTON, WPARAM(Self), 0);
        end else
          PostMessage(Parent.Handle, WM_REMOVEBUTTON, WPARAM(Self), 0);
    finally
      FDragging := False;
    end else
      // Reaquire the capture that DragDetectPlus released
      Mouse.Capture := OldCapture;
  end
end;

procedure TCustomWideSpeedButton.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  PaintState := psPressed;
  Invalidate;
  Update;
end;

procedure TCustomWideSpeedButton.WMRButtonUp(var Message: TWMRButtonUp);
begin
  inherited;
  Exclude(FState, bsRMouseButtonDown);
end;

procedure TCustomWideSpeedButton.WMLButtonUp(var Message: TWMLButtonUp);
begin
  if not Dragging then
    inherited
  else
    Mouse.Capture := 0;
  if HotAnimate and (bsMouseInButton in State) then
    PaintState := psHot
  else
    PaintState := psNormal;
  FDragging := False;
  Invalidate;
end;

procedure TCustomWideSpeedButton.WMMouseMove(var Message: TWMMouseMove);
begin
  inherited;
  if not Dragging then
  begin
    if not(csLButtonDown in ControlState) and (PaintState <> psHot) then
      PaintState := psHot;
    StartHotTimer;
  end
end;

procedure TCustomWideSpeedButton.WMThemeChanged(var Message: TMessage);
begin
  inherited;
  FreeThemes;  // Force reload of Theme Handles on next call
  if UseThemes then
    Include(FState, bsThemesActive);
end;

procedure TCustomWideSpeedButton.WriteCaption(Writer: TWriter);

// The Write procedure for the DefineProperty "WideText"

begin
  Writer.WriteString(Caption);
end;

{ TCustomVirtualToolbar }

procedure TCustomVirtualToolbar.BeginUpdate;
begin
  Inc(FLockUpdateCount)
end;

function TCustomVirtualToolbar.CalcMaxButtonSize(Font: TFont): TSize;

// Runs through the ButtonList looking for the widest/highest button extent in the list
// and returns the larget value found for each direction

var
  i: integer;
  R: TRect;
begin
  ZeroMemory(@Result, SizeOf(Result));
  if ButtonList.Count = 0 then
    Result := CaptionButton.CalcMaxExtentSize(Font)
  else
    for i := 0 to ButtonList.Count - 1 do
    begin
      R := ButtonList[i].CalcMaxExtentRect(Font);
      if RectWidth(R) > Result.cx then
        Result.cx := RectWidth(R);
      if RectHeight(R) > Result.cy then
        Result.cy := RectHeight(R);
    end
end;

function TCustomVirtualToolbar.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;

// Called if the AutoSize property is set before any sizing is allowed

var
  R: TRect;
begin
  Result := inherited CanAutoSize(NewWidth, NewHeight);
  if Result then
  begin
    R := ViewportBounds;
    if NewWidth <> RectWidth(R) then
      NewWidth := RectWidth(R);
    if NewHeight <> RectHeight(R) then
      NewHeight := RectHeight(R);
  end
end;

function TCustomVirtualToolbar.ClosestButtonEdge(ScreenPoint: TPoint): TRect;
var
  ClientPt: TPoint;
  Button: TCustomWideSpeedButton;
begin
  Result := Rect(0, 0, 0, 0);
  if ButtonList.Count > 0 then
  begin
    ClientPt := ScreenToClient(ScreenPoint);
    Button := PointToButton(ScreenPoint);

    if Align in [alTop, alBottom] then
    begin
      if Assigned(Button) then
      begin
        if ClientPt.x < Button.Left + (Button.Right - Button.Left) div 2 then
          Result := Rect(Button.Left, Button.Top, Button.Left, Button.Bottom)
        else
          Result := Rect(Button.Right, Button.Top, Button.Right, Button.Bottom)
      end else
      begin
        if ClientPt.x < ButtonList[0].Left then
        begin
          Button := ButtonList[0];
          Result := Rect(Button.Left, Button.Top, Button.Left, Button.Bottom)
        end else
        begin
          Button := ButtonList[ButtonList.Count - 1];
          Result := Rect(Button.Right, Button.Top, Button.Right, Button.Bottom)
        end
      end
    end else
    begin
      if Assigned(Button) then
      begin
        if ClientPt.y < Button.Top + (Button.Bottom - Button.Top) div 2 then
          Result := Rect(Button.Left, Button.Top, Button.Right, Button.Top)
        else
          Result := Rect(Button.Left, Button.Bottom, Button.Right, Button.Bottom)
      end else
      begin
        if ClientPt.y < ButtonList[0].Top then
        begin
          Button := ButtonList[0];
          Result := Rect(Button.Left, Button.Top, Button.Right, Button.Top)
        end else
        begin
          Button := ButtonList[ButtonList.Count - 1];
          Result := Rect(Button.Left, Button.Bottom, Button.Right, Button.Bottom)
        end
      end
    end
  end
end;

procedure TCustomVirtualToolbar.CreateButtons;
begin
  DoCreateButtons
end;

procedure TCustomVirtualToolbar.CMColorChanged(var Message: TMessage);
begin
  inherited;
  Include(FStates, tsBackBitsStale);
  Invalidate
end;

constructor TCustomVirtualToolbar.Create(AOwner: TComponent);
begin
  inherited;
  SHGetMalloc(FMalloc);
  ControlState := ControlState + [csCreating];
  BeginUpdate;  // Lock the update until the window is created;
  ControlState := ControlState + [csCreating];
  FButtonList := CreateButtonList;
  FButtonList.Toolbar := Self;
  FCaptionButton := TCaptionButton.Create(Self);
  FCaptionButton.Parent := Self;
  BackBits := TBitmap.Create;
  Align := alTop;
  Height := 24;
  FScrollBtnSize := 12;
  FButtonLayout := blGlyphLeft;
  FButtonMargin := -1;
  FButtonSpacing := 4;
  FOldFontChangeEvent := Font.OnChange;
  Font.OnChange := FontChangeNotify;
  EdgeBorders := [ebTop];
  EdgeInner := esRaised;
  EdgeOuter := esLowered;
  ShowHint := True;
  TabStop := False;
  ControlState := ControlState - [csCreating];
  DoubleBuffered := True;
  FOptions := [toThemeAware];
  FContent := [stcFolders, stcFiles, stcPrograms];
  FDropInsertMargin := 4;
  CoCreateInstance(CLSID_DragDropHelper, nil, CLSCTX_INPROC_SERVER, IID_IDropTargetHelper, FDropTargetHelper);
  ControlState := ControlState - [csCreating]
end;

function TCustomVirtualToolbar.CreateButtonList: TVirtualButtonList;
// Overridable to create a new ButtonAttribute class decendant
begin
  Result := TVirtualButtonList.Create
end;

procedure TCustomVirtualToolbar.CreateParams(var Params: TCreateParams);
begin
  inherited;
end;

procedure TCustomVirtualToolbar.CreateWnd;
begin
  inherited;
  Perform(WM_THEMECHANGED, 0, 0);
  ThreadedImagesEnabled := toThreadedImages in Options;
  ChangeNotifierEnabled := toShellNotifyThread in Options;
  CreateButtons;
  Include(FStates, tsBackBitsStale); // Force the Background bits to be updated to new size
  // Now we can rebuild the toolbar and set things up (BeginUpdate is in the constructor)
  EndUpdate;
  if not (csDesigning in ComponentState) then
    RegisterDragDrop(Handle, Self);
end;

procedure TCustomVirtualToolbar.DefineProperties(Filer: TFiler);

// Per Mike Liscke the VCL screws up streaming WideStrings so define a new property
// type 'WideText'

begin
  inherited;
  Filer.DefineProperty('WideText', ReadCaption, WriteCaption, Caption <> '');
end;

destructor TCustomVirtualToolbar.Destroy;
begin
  ThreadedImagesEnabled := False;
  ChangeNotifierEnabled := False;
  BackBits.Free;
  ButtonList.Free;
  FreeThemes;
  FMalloc := nil;
  inherited;
end;

procedure TCustomVirtualToolbar.DestroyWnd;
begin
  inherited;
  if not (csDesigning in ComponentState) then
    RevokeDragDrop(Handle);
end;

function TCustomVirtualToolbar.DragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  FormatEtc: TFormatEtc;
begin
  if Assigned(DropTargetHelper) then
    DropTargetHelper.DragEnter(Handle, dataObj, Pt, dwEffect);

  FDragDropDataObj := dataObj;  // increase its ref count

  if ((toLaunchDropable in Options) or (toInsertDropable in Options)) and (IsValidIDListData(dataObj)) then
    Include(FStates, tsShellIDListValid);

  FormatEtc := FillFormatEtc(CF_VSTSHELLTOOLBAR, nil, DVASPECT_CONTENT, -1, TYMED_ISTREAM);
  if (toCustomizable in Options) and Succeeded( dataObj.QueryGetData(FormatEtc)) then
    Include(FStates, tsVSTShellToobarValid);

  UpdateDropStates(pt);

  // Just easier not to have to deal with this here.  Wait for a DragOver to handle Drag issues
  FDropTarget := nil;

  dwEffect := DROPEFFECT_NONE; // Think negative!
  if States * [tsVSTShellToobarValid, tsShellIDListValid] <> [] then
  begin
    if tsDragInLaunchZone in States then
      dwEffect := DROPEFFECT_MOVE
    else
    if tsDragInDropZone in States then
      dwEffect := DROPEFFECT_LINK
  end;


  Result := S_OK
end;

function TCustomVirtualToolbar.DragLeave: HResult;
begin
  Result := S_OK;
  try
    if Assigned(DropTargetHelper) then
      DropTargetHelper.DragLeave;

    FDragDropDataObj := nil;  // decrease its ref count

    if States * [tsVSTShellToobarValid, tsShellIDListValid] <> [] then
      if Assigned(FDropTarget) then
        Result := FDropTarget.DragLeave
  finally
    Exclude(FStates, tsVSTShellToobarValid);
    Exclude(FStates, tsShellIDListValid);
    Exclude(FStates, tsDragInDropZone);
    Exclude(FStates, tsDragInLaunchZone);
    FDropTarget := nil;
    DrawDropMarker(nil, False);
    Invalidate
  end
end;

function TCustomVirtualToolbar.DragOverOLE(grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
var
  OldTarget: TCustomWideSpeedButton;
begin
  // Update any drag image
  if Assigned(DropTargetHelper) then
    DropTargetHelper.DragOver(pt, dwEffect);

  Result := S_OK;

  // In the DragEnter we decided if the DataObject contained anything we could use
  if States * [tsVSTShellToobarValid, tsShellIDListValid] <> [] then
  begin
    OldTarget := FDropTarget;

    UpdateDropStates(pt);

    // If it is in an insert mode than do not allow the DropTarget property to be
    // valid since this operation is dependant on the toolbar to execute and not
    // on the button to execute as it will be during a launch drop.
    if tsDragInDropZone in States then
      FDropTarget := nil
    else
      FDropTarget := PointToButton(Pt);


    // If a different DropTarget then do a DragEnter/DragLeave on the buttons
    // Notice here we are using FDropTarget. If the mouse is in a DropZone we don't
    // want the button to think it is a drop target if the mode is insert
    if OldTarget <> FDropTarget then
    begin
      // Leave the old DropTarget
      if Assigned(OldTarget) then
        OldTarget.DragLeave;

      // Enter the new DropTarget
      if Assigned(FDropTarget) then
        FDropTarget.DragEnter(DragDropDataObj, grfKeyState, pt, dwEffect);
    end else
    begin
      // Same DropTarget to just move the mouse in it.
      if Assigned(FDropTarget) then
        Result := FDropTarget.DragOverOLE(grfKeyState, pt, dwEffect);
    end;
  end else
    dwEffect := DROPEFFECT_NONE;

  if not Assigned(FDropTarget) then
  begin
    dwEffect := DROPEFFECT_NONE;
    // In an insert (DropZone) button mode
    if (tsDragInDropZone in States) then
    begin
      // ShellIDLists are always "links"
      if tsShellIDListValid in States then
        dwEffect := DROPEFFECT_LINK
      else begin
        // Internal button moving can either copy or move
        if grfKeyState and MK_CONTROL <> 0 then
          dwEffect := DROPEFFECT_COPY
        else
          dwEffect := DROPEFFECT_MOVE
      end
    end
  end;

  UpdateWindow(Handle);
  DrawDropMarker(@Pt, False);
end;

procedure TCustomVirtualToolbar.DrawDropMarker(MousePos: PPoint; ForceDraw: Boolean);
// Draws the InsertMark in the Toolbar.  R should come in as a zero width (or height)
// rectangle that is inflated to the correct with.  Ususally it is the dividing line
// between to buttons or the first / last edge of button 0 or MaxButton

    function CalcDropMarkRect(Pt: PPoint): TRect;
    var
      Temp: TPoint;
    begin
      if not Assigned(Pt) then
        Temp := Mouse.CursorPos
      else
        Temp := Pt^;
      Result := ClosestButtonEdge(Temp);

      // Inflate the Line to at rectangle to contain the InsertMark image
      if Align in [alTop, alBottom] then
        InflateRect(Result, 4, 0)
      else
        InflateRect(Result, 0, 4);
    end;

var
  Bitmap, Bits: TBitmap;
  ImageList: TImageList;
  DC: hDc;
  R: TRect;
  i: integer;
begin

  if tsInsertImageVisible in States then
  begin
    R := CalcDropMarkRect(MousePos);

    // If the If the DropRect is in a new spot or the Mouse is no longer over a DropZone erase the Mark
    if not (EqualRect(R, FDropMarkRect) and (tsDragInDropZone in States)) then
    begin
      Exclude(FStates, tsInsertImageVisible);
      InvalidateRect(Handle, @FDropMarkRect, True);
      SetRect(FDropMarkRect, 0, 0, 0, 0);
    end
  end;

  if ((tsDragInDropZone in States) and IsRectEmpty(FDropMarkRect)) or ForceDraw then
  begin
    R := CalcDropMarkRect(MousePos);
    DC := 0;
    ImageList := TImageList.Create(nil);
    Bitmap := TBitmap.Create;
    try
      Bitmap.Width := RectWidth(R);
      Bitmap.Height := RectHeight(R);
      Bitmap.Canvas.Brush.Color := clFuchsia;
      Bitmap.Canvas.FillRect(Rect(0, 0, Bitmap.Width, Bitmap.Height));

      Bits := TBitmap.Create;
      try
        if Align in [alTop, alBottom] then
        begin
          Bits.LoadFromResourceName(hInstance, 'VERTCENTER');
          i := 0;
          while i < RectHeight(R) do
          begin
            Bitmap.Canvas.Draw(2, i, Bits);
            Inc(i)
          end;
          Bits.LoadFromResourceName(hInstance, 'VERTTOP');
          Bitmap.Canvas.Draw(0, 0, Bits);
          Bits.LoadFromResourceName(hInstance, 'VERTBOTTOM');
          Bitmap.Canvas.Draw(0, RectHeight(R) - 3, Bits);
        end else
        if Align in [alLeft, alRight] then
        begin
          Bits.LoadFromResourceName(hInstance, 'HORZCENTER');
          i := 0;
          while i < RectWidth(R) do
          begin
            Bitmap.Canvas.Draw(i, 2, Bits);
            Inc(i)
          end;
          Bits.LoadFromResourceName(hInstance, 'HORZLEFT');
          Bitmap.Canvas.Draw(0, 0, Bits);
          Bits.LoadFromResourceName(hInstance, 'HORZRIGHT');
          Bitmap.Canvas.Draw(RectWidth(R) - 3, 0, Bits);
        end;
      finally
        Bits.Free
      end;

      ImageList.Width := Bitmap.Width;
      ImageList.Height := Bitmap.Height;

      if Imagelist.HandleAllocated and(ImageList.Height > 0) and (ImageList.Width > 0) then
      begin
        ImageList.AddMasked(Bitmap, clFuchsia);
        DC := GetDC(Handle);
        if DC <> 0 then
          ImageList_DrawEx(ImageList.Handle, 0, DC, R.Left, R.Top, ImageList.Width,
           ImageList.Height, CLR_NONE, CLR_NONE, ILD_TRANSPARENT);
      end;

      Include(FStates, tsInsertImageVisible);
    finally
      FDropMarkRect := R;
      if DC <> 0 then
        ReleaseDC(Handle, DC);
      Bitmap.Free;
      ImageList.Free;
    end
  end
end;

function TCustomVirtualToolbar.Drop(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  ShellIDList: TCommonShellIDList;
  VSTShellToolbar: TVSTShellToolbar;
  LogicalPerformedDropEffect: TCommonLogicalPerformedDropEffect;
  i, DropIndex: integer;
  NewButton: TShellToolButton;
begin
  try
    if Assigned(DropTargetHelper) then
      DropTargetHelper.Drop(dataObj, pt, dwEffect);

    if States * [tsVSTShellToobarValid, tsShellIDListValid] <> [] then
    begin
      if Assigned(FDropTarget) then
        Result := FDropTarget.Drop(dataObj, grfKeyState, pt, dwEffect)
      else begin
        Result := S_OK;

        DropIndex := PointToInsertIndex( Pt);

        if tsShellIDListValid in States then
        begin
          BeginUpdate;
          ShellIDList := TCommonShellIDList.Create;
          try
            ShellIDList.LoadFromDataObject(dataObj);
            for i := 0 to ShellIDList.PIDLCount - 1 do
            begin
              NewButton := TShellToolButton( ButtonList.AddButton(DropIndex));
              NewButton.Namespace := TNamespace.Create(ShellIDList.AbsolutePIDL(i), nil);
            end
          finally
            ShellIDList.Free;
            EndUpdate;
          end
        end else
        if tsVSTShellToobarValid in States then
        begin
          VSTShellToolbar := TVSTShellToolbar.Create;
          try
            BeginUpdate;
            if VSTShellToolbar.LoadFromDataObject(dataObj) then
            begin
              NewButton := TShellToolButton( ButtonList.AddButton(DropIndex));
              NewButton.Namespace := TNamespace.Create(VSTShellToolbar.PIDL, nil);

              // Let the source know what happened
              LogicalPerformedDropEffect := TCommonLogicalPerformedDropEffect.Create;
              try
                if grfKeyState and MK_CONTROL <> 0 then
                  LogicalPerformedDropEffect.Action := effectCopy
                else
                  LogicalPerformedDropEffect.Action := effectMove;

                LogicalPerformedDropEffect.SaveToDataObject(dataObj);
              finally
                LogicalPerformedDropEffect.Free
              end

            end
          finally
            VSTShellToolbar.Free;
            EndUpdate;
          end
        end
      end
    end else
    begin
      dwEffect := DROPEFFECT_NONE;
      Result := S_OK
    end;

  finally
    Exclude(FStates, tsVSTShellToobarValid);
    Exclude(FStates, tsShellIDListValid);
    Exclude(FStates, tsDragInDropZone);
    Exclude(FStates, tsDragInLaunchZone);
    FDragDropDataObj := nil;  // decrease its ref count
    FDropTarget := nil;
    DrawDropMarker(@Pt, False);  
    DoCreateButtons
  end
end;

procedure TCustomVirtualToolbar.EndUpdate;
begin
  Dec(FLockUpdateCount);
  if FLockUpdateCount < 0 then
    FLockUpdateCount := 0;
  if FLockUpdateCount = 0 then
  begin
    RebuildToolbar;
    Invalidate;
    Update
  end
end;

procedure TCustomVirtualToolbar.FontChangeNotify(Sender: TObject);

// Hook the Font Change chain so we are notified when any Font attributes are
// changed

begin
  // don't break the chain
  if Assigned(FOldFontChangeEvent) then
    FOldFontChangeEvent(Sender);
  RebuildToolbar
end;

procedure TCustomVirtualToolbar.FreeThemes;

// Frees theme handles

begin
  if ThemeToolbar <> 0 then
  begin
    CloseThemeData(FThemeToolbar);
    FThemeToolbar := 0
  end;
end;

function TCustomVirtualToolbar.GetAlign: TAlign;
begin
  Result := inherited Align
end;

function TCustomVirtualToolbar.GetBkGndParent: TWinControl;
begin
  Result := Parent
end;

function TCustomVirtualToolbar.GetEdgeBorders: TEdgeBorders;
begin
  Result := inherited EdgeBorders
end;

function TCustomVirtualToolbar.GetEdgeInner: TEdgeStyle;
begin
  Result := inherited EdgeInner
end;

function TCustomVirtualToolbar.GetEdgeOuter: TEdgeStyle;
begin
   Result := inherited EdgeOuter
end;

function TCustomVirtualToolbar.GetViewportBounds: TRect;

// Finds the smallest rectangle that will contain all the buttons and caption
// Used for Autosizing the parent window

var
  i: integer;
begin
 // Result := CaptionButton.BoundsRect;
  SetRect(Result, 0, 0, 0, 0);
  for i := 0 to ButtonList.Count - 1 do
    UnionRect(Result, Result, ButtonList[i].BoundsRect);
  if Assigned(CaptionButton) then
    UnionRect(Result, Result, CaptionButton.BoundsRect);

  if EdgeInner in [esLowered, esRaised] then
  begin
    if ebLeft in EdgeBorders then
      Inc(Result.Right);
    if ebRight in EdgeBorders then
      Inc(Result.Right);
    if ebTop in EdgeBorders then
      Inc(Result.Bottom);
    if ebBottom in EdgeBorders then
      Inc(Result.Bottom);
  end;
   if EdgeOuter in [esLowered, esRaised] then
   begin
    if ebLeft in EdgeBorders then
      Inc(Result.Right);
    if ebRight in EdgeBorders then
      Inc(Result.Right);
    if ebTop in EdgeBorders then
      Inc(Result.Bottom);
    if ebBottom in EdgeBorders then
      Inc(Result.Bottom);
  end;
end;

function TCustomVirtualToolbar.GetWideCaption: WideString;
begin
  Result := CaptionButton.Caption
end;

procedure TCustomVirtualToolbar.Loaded;
begin
  inherited;
end;

procedure TCustomVirtualToolbar.LoadFromFile(FileName: WideString);
var
  F: TVirtualFileStream;
begin
  F := TVirtualFileStream.Create(FileName, fmOpenRead or fmShareExclusive);
  try
    LoadFromStream(F)
  finally
    F.Free
  end
end;

procedure TCustomVirtualToolbar.LoadFromStream(S: TStream);
var
  Count, i: integer;
begin
  BeginUpdate;
  try
    ButtonList.Clear;
    S.read(Count, SizeOf(Count));
    for i := 0 to Count - 1 do
      ButtonList.AddButton;
    for i := 0 to ButtonList.Count - 1 do
      ButtonList[i].LoadFromStream(S);
  finally
    DoCreateButtons;
    EndUpdate
  end
end;

function TCustomVirtualToolbar.GiveFeedback(dwEffect: Integer): HResult;
begin
  Result := DRAGDROP_S_USEDEFAULTCURSORS;
end;

function TCustomVirtualToolbar.IsValidIDListData(DataObject: IDataObject): Boolean;
var
  ShellIDList: TCommonShellIDList;
  i: integer;
  NS: TNamespace;
  IsFolder, IsFile, IsExe: Boolean;
  Ext: WideString;
begin
  Result := False;
  ShellIDList := TCommonShellIDList.Create;
  try
    try
      if ShellIDList.LoadFromDataObject(DataObject as IDataObject) then
      begin
        // If all are defined then it will always accept the dataobject
        if not (Content = [stcFolders, stcFiles, stcPrograms]) then
        begin
          i := 0;
          while not Result and (i < ShellIDList.PIDLCount) do
          begin
            NS := TNamespace.Create(ShellIDList.AbsolutePIDL(i), nil);
            try
              IsFolder := NS.Folder;
              IsFile := not NS.Folder;
              Ext := WideExtractFileExt(NS.NameParseAddress);
              Ext := WideLowerCase( PWideChar(Ext));
              IsExe := (Ext = '.exe') or (Ext = '.bat') or (Ext = '.com');
              if Content = [stcFolders, stcPrograms] then
                Result := IsFolder or IsExe
              else
              if Content = [stcFiles, stcPrograms] then
                Result := not IsFolder and IsFile
              else
              if Content = [stcFolders, stcFiles] then
                Result := (IsFolder or IsFile) and not IsExe
              else
              if Content = [stcFolders] then
                Result := IsFolder and not IsFile and not IsExe
              else
              if Content = [stcFiles] then
                Result := not IsFolder and IsFile and not IsExe
              else
              if Content = [stcPrograms] then
                Result := not IsFolder and IsFile and IsExe
              else
                Result := False;
            finally
              Inc(i);
              FreeAndNil(NS)
            end
          end
        end else
          Result := True;
      end
    finally
      ShellIDList.Free;
    end
  except
    Result := False
  end
end;

procedure TCustomVirtualToolbar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = BkGndParent) then
    BkGndParent := nil
end;

procedure TCustomVirtualToolbar.ReadCaption(Reader: TReader);
begin
  Caption := Reader.ReadString;
end;

procedure TCustomVirtualToolbar.RebuildToolbar;
var
  i: integer;
begin
  if not (csCreating in ControlState) and (FLockUpdateCount = 0) then
  begin
    Include(FStates, tsBackBitsStale); // Rebuild the background image
    for i := 0 to ButtonList.Count - 1 do
      ButtonList[i].RebuildButton;
    ArrangeButtons;
    if AutoSize then
    begin
      // Ugly but works. The toolbar won't let the button height change and the
      // button won't let the toolbar height change!
      CaptionButton.Align := alNone;
      if ButtonList.Count > 0 then
        CaptionButton.Height := ButtonList[ButtonList.Count - 1].Bottom
      else begin
        CaptionButton.Height := 24 - BorderWidth * 2;
      end;
      CaptionButton.Align := alLeft;
      AdjustSize;
    end;
    Invalidate
  end
end;

procedure TCustomVirtualToolbar.SaveToFile(FileName: WideString);
var
  F: TVirtualFileStream;
begin
  F := TVirtualFileStream.Create(FileName, fmCreate or fmShareExclusive);
  try
    SaveToStream(F)
  finally
    F.Free
  end
end;

procedure TCustomVirtualToolbar.SaveToStream(S: TStream);
var
  i: integer;
begin
  i := ButtonList.Count;
  S.write(i, SizeOf(i));
  for i := 0 to ButtonList.Count - 1 do
    ButtonList[i].SaveToStream(S);
end;

procedure TCustomVirtualToolbar.SetAlign(const Value: TAlign);
begin
  if inherited Align <> Value then
  begin
    inherited Align := Value;
    if (Value = alLeft) or (Value = alRight) then
    begin
      CaptionButton.Align := alTop;
      ResizeCaptionButton;
    end else
    if (Value = alTop) or (Value = alBottom) then
    begin
      CaptionButton.Align := alLeft;
      ResizeCaptionButton;
    end;
    RebuildToolbar
  end
end;

procedure TCustomVirtualToolbar.SetBkGndParent(const Value: TWinControl);
begin
  if (Value <> Parent) and (Value <> Self) then
  begin
    if Assigned(Value) then
      Parent := Value
    else
      Parent := GetParentForm(Self);
    RebuildToolbar
  end;
end;

procedure TCustomVirtualToolbar.SetButtonLayout(const Value: TButtonLayout);
var
  i: integer;
begin
  if FButtonLayout <> Value then
  begin
    FButtonLayout := Value;
    for i := 0 to ButtonList.Count - 1 do
      ButtonList[i].Layout := Value;
    RebuildToolbar
  end
end;

procedure TCustomVirtualToolbar.SetButtonMargin(const Value: integer);
var
  i: integer;
begin
  if FButtonMargin <> Value then
  begin
    FButtonMargin := Value;
    for i := 0 to ButtonList.Count - 1 do
      ButtonList[i].Margin := Value;
    RebuildToolbar
  end
end;

procedure TCustomVirtualToolbar.SetButtonSpacing(const Value: integer);
var
  i: integer;
begin
  if FButtonSpacing <> Value then
  begin
    FButtonSpacing := Value;
    for i := 0 to ButtonList.Count - 1 do
      ButtonList[i].Spacing := Value;
    RebuildToolbar
  end
end;

procedure TCustomVirtualToolbar.SetEdgeBorders(const Value: TEdgeBorders);
begin
  inherited EdgeBorders := Value;
  RebuildToolbar
end;

procedure TCustomVirtualToolbar.SetEdgeInner(const Value: TEdgeStyle);
begin
  inherited EdgeInner := Value;
  RebuildToolbar
end;

procedure TCustomVirtualToolbar.SetEdgeOuter(const Value: TEdgeStyle);
begin
  inherited EdgeOuter := Value;
  RebuildToolbar
end;

procedure TCustomVirtualToolbar.SetName(const Value: TComponentName);
var
  ChangeText: Boolean;
begin
  // Do it just like TControl but I have created a new Caption (widestring) so I
  // have to duplicate it.
  ChangeText := (csSetCaption in ControlStyle) and
    not (csLoading in ComponentState) and (Caption = Text) and
    ((Owner = nil) or not (Owner is TControl) or
    not (csLoading in TControl(Owner).ComponentState));
  inherited;
  if ChangeText then
    Caption := Text
end;

procedure TCustomVirtualToolbar.PaintToolbar(DC: HDC);
var
  i: Integer;
  Pt: TPoint;
begin
  if FLockUpdateCount = 0 then
  begin
    if tsBackBitsStale in States then
      StoreBackGndBitmap;

    if IsWinVista then
    begin
      SetWindowOrgEx(BackBits.Canvas.Handle, -CaptionButton.Left, -CaptionButton.Top, @Pt);
      CaptionButton.PaintButton(BackBits.Canvas.Handle, False);
      SetWindowOrgEx(BackBits.Canvas.Handle, Pt.X, Pt.Y, @Pt);

      for i := 0 to ButtonList.Count - 1 do
      begin
        SetWindowOrgEx(BackBits.Canvas.Handle, -ButtonList[i].Left, -ButtonList[i].Top, @Pt);
        ButtonList[i].PaintButton(BackBits.Canvas.Handle, False);
        SetWindowOrgEx(BackBits.Canvas.Handle, Pt.X, Pt.Y, @Pt);
      end
    end;
    
    BitBlt(DC, 0, 0, Width, Height, BackBits.Canvas.Handle, 0, 0, SRCCOPY);
  end
end;

procedure TCustomVirtualToolbar.PaintWindow(DC: HDC);
begin
  PaintToolbar(DC)
end;

function TCustomVirtualToolbar.PointToButton(ScreenPt: TPoint): TCustomWideSpeedButton;
var
  i: integer;
begin
  Result := nil;
  i := 0;
  ScreenPt := ScreenToClient(ScreenPt);
  while not Assigned(Result) and (i < ButtonList.Count) do
  begin
    if PtInRect(ButtonList[i].BoundsRect, ScreenPt) then
      Result :=  ButtonList[i];
    inc(i)
  end
end;

function TCustomVirtualToolbar.QueryContinueDrag(fEscapePressed: BOOL;
  grfKeyState: Integer): HResult;
begin
  if fEscapePressed then
  begin
    Result := DRAGDROP_S_CANCEL;
    Exit
  end;
  Result := S_OK
end;

procedure TCustomVirtualToolbar.ReCreateButtons;

// Frees all buttons then ReCreates them not allowing the window to resize or flicker

var
  WasAutoSize: Boolean;
begin
  WasAutoSize := AutoSize;
  BeginUpdate;
  try
    AutoSize := False;
    ButtonList.Clear;
    CreateButtons;
    ArrangeButtons;
  finally
    EndUpdate;
    AutoSize := WasAutoSize;
  end
end;

procedure TCustomVirtualToolbar.SetOptions(const Value: TVirtualToolbarOptions);

    function BitChanged(New, Old: TVirtualToolbarOptions; Bit: TVirtualToolbarOption): Boolean;
    begin
      Result := ((Bit in New) and not (Bit in Old)) or ((Bit in Old) and not (Bit in New))
    end;

var
  OldOptions: TVirtualToolbarOptions;
  i: integer;
  ImageList: TCustomImageList;
  
begin
  if FOptions <> Value then
  begin
    OldOptions := FOptions;
    FOptions := Value;

    // What transparent is and what should be transparent becomes unclear with
    // Themes so just don't use them with transparency
    if BitChanged(Value, OldOptions, toTransparent) then
    begin

    end;

    if BitChanged(Value, OldOptions, toThemeAware) then
    begin

    end;

    if BitChanged(Value, OldOptions, toShellNotifyThread) then
    begin
      if (toShellNotifyThread in Value) and not (ComponentState * [csDesigning, csLoading] <> []) then
        ChangeNotifierEnabled := True
      else
        ChangeNotifierEnabled := False
    end;

    if BitChanged(Value, OldOptions, toFlat) then
    begin
      for i := 0 to ButtonList.Count - 1 do
        ButtonList[i].Flat := toFlat in Value
    end;

    if BitChanged(Value, OldOptions, toThemeAware) then
    begin
      for i := 0 to ButtonList.Count - 1 do
        ButtonList[i].ThemeAware := toThemeAware in Value
    end;

    if BitChanged(Value, OldOptions, toTransparent) then
    begin
      for i := 0 to ButtonList.Count - 1 do
        ButtonList[i].Transparent := toTransparent in Value
    end;

    if BitChanged(Value, OldOptions, toThreadedImages) then
    begin
      if toThreadedImages in Value then
        ThreadedImagesEnabled := True
      else
        ThreadedImagesEnabled := False;                     
    end;

    if BitChanged(Value, OldOptions, toLargeButtons) then
    begin
      if toLargeButtons in FOptions then
        ImageList := LargeSysImages
      else
        ImageList := SmallSysImages;
      for i := 0 to ButtonList.Count - 1 do
        ButtonList[i].ImageList := ImageList;
    end;

    RebuildToolbar
  end;
end;

procedure TCustomVirtualToolbar.SetWideCaption(const Value: WideString);
begin
  CaptionButton.Caption := Value;
  RebuildToolbar;
end;

procedure TCustomVirtualToolbar.StoreBackGndBitmap;

// Stores a bitmap that is used for the backgound of the toolbar.  Its main use
// is to call WM_PRINT of its owner when the toolbar is to be transparent but since
// it is here if not transparent the normal solid brush is drawn.  The image is cached
// and to force a reload of the image set BackBitsStale to True then the next time
// PaintWindow is called the backgound image will be updated.

      procedure PaintBackGround(BkGndDC: hDc);
      const
        // If we print children we will be trying to print ourselves from within
        // a paint message ending in infinate recursion
        PrintFlags = PRF_CHECKVISIBLE {or PRF_CHILDREN} or PRF_CLIENT or PRF_ERASEBKGND;
      var
        Brush, OldBrush: hBrush;
        OldPt: TPoint;
      begin
        if toTransparent in Options then
        begin
         // Shift the viewport so the area under the control is painted to the bitmap
         // at (0, 0)
          SetViewportOrgEx(BkGndDC, -Left, -Top, @OldPt);
          Parent.Perform(WM_PRINT, Integer(BkGndDC), Integer(PrintFlags));
          SetViewportOrgEx(BkGndDC, OldPt.x, OldPt.y, nil);
        end else
        begin
          Brush := CreateSolidBrush(ColorToRGB(Color));
          OldBrush := SelectObject(BkGndDC, Brush);
          FillRect(BkGndDC, ClientRect, Brush);
          SelectObject(BkGndDC, OldBrush);
          DeleteObject(Brush);
        end
      end;

begin
  BackBits.Canvas.Lock;
  try
    BackBits.Width := Width;
    BackBits.Height := Height;
    PaintBackGround(BackBits.Canvas.Handle);
  finally
    BackBits.Canvas.UnLock;
    Exclude(FStates, tsBackBitsStale);
  end
end;

procedure TCustomVirtualToolbar.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  // We are handling the background
  Message.Result := 1;
end;

procedure TCustomVirtualToolbar.WMLButtonUp(var Message: TWMLButtonUp);
begin
  inherited;
end;

procedure TCustomVirtualToolbar.WMMouseMove(var Message: TWMMouseMove);
begin
  inherited;
  // Set a timer to catch any missed CM_MOUSELEAVE messages that leave hot images
  // behind.  CM_MOUSEENTER can miss it too so put this here
  if HotTrackTimer = 0 then
    // The timerID uses object address for a unique value
    HotTrackTimer := SetTimer(Handle, ID_TIMER_HOTTRACK, HOTTRACKDELAY, nil);
end;

procedure TCustomVirtualToolbar.WMPaint(var Message: TWMPaint);
begin
  inherited;
  DrawDropMarker(nil, False)
end;

procedure TCustomVirtualToolbar.WMPrint(var Message: TWMPrint);
begin
  PaintWindow(Message.DC);
end;

procedure TCustomVirtualToolbar.WMPrintClient(var Message: TWMPrintClient);
begin
  PaintWindow(Message.DC);
end;

procedure TCustomVirtualToolbar.WMRemoveButton(var Message: TMessage);
begin
  if Message.wParam <> 0 then
  begin
    ButtonList.RemoveButton(Pointer( Message.wParam));
    RebuildToolbar;
  end
end;

procedure TCustomVirtualToolbar.WMSize(var Message: TWMSize);
begin
  inherited;
  // WM_WindowPosChanging is tough to disinguish when the dx, dy params are
  // valid.  Here I know they are
  RebuildToolbar;
end;

procedure TCustomVirtualToolbar.WMThemeChanged(var Message: TMessage);
begin
  inherited;
  FreeThemes;
  if UseThemes then
  begin
    Include(FStates, tsThemesActive);
    ThemeToolbar := OpenThemeData(Handle, 'toolbar');
    RedrawWindow(Handle, nil, 0, RDW_FRAME or RDW_INVALIDATE or RDW_NOERASE or RDW_NOCHILDREN);
  end else
    Exclude(FStates, tsThemesActive);
end;

procedure TCustomVirtualToolbar.WMTimer(var Message: TMessage);
var
  Pt: TPoint;
begin
  // The timerID uses object address for a unique value
  if Message.wParam = Handle then
  begin
    Pt := ScreenToClient(Mouse.CursorPos);
    if not PtInRect(ClientRect, Pt) then
    begin
      KillTimer(Handle, HotTrackTimer);
      HotTrackTimer := 0;
      Perform(CM_MOUSELEAVE, 0, 0);
    end
  end
end;

procedure TCustomVirtualToolbar.WMWindowPosChanging(var Message: TWMWindowPosChanging);
const
  BackgroundValid = SWP_NOSIZE or SWP_NOMOVE;
begin
  with Message.WindowPos^ do
  begin
    if not (Flags and SWP_NOSIZE) <> 0 then
    begin
      Include(FStates, tsBackBitsStale);
    end;
    inherited;
  end
end;

procedure TCustomVirtualToolbar.WriteCaption(Writer: TWriter);
begin
  Writer.WriteString(Caption);
end;

//------------------------------------------------------------------------------


procedure TCustomVirtualToolbar.ArrangeButtons;
var
  i, DeltaX, DeltaY: integer;
  ButtonArea: TRect;
  Size: TSize;
begin
  ButtonArea := ClientRect;

  if ButtonList.Count > 0 then
  begin
    // The buttons need to be checked for size before they can be aligned
    Size := CalcMaxButtonSize(Font);
    for i := 0 to ButtonList.Count - 1 do
    begin
      ButtonList[i].AutoSize := True;
      if Align in [alLeft, alRight] then
      begin
        ButtonList[i].AutoSize := False;
        ButtonList[i].Width := ClientWidth; //maximum Width
      end
      else begin
        if toEqualWidth in Options then
        begin
          ButtonList[i].AutoSize := False;
          ButtonList[i].Width := Size.cx
        end;
        if not (toTile in Options) then
        begin
          ButtonList[i].AutoSize := False;
          ButtonList[i].Height := ClientHeight; //maximum Height
        end;
      end;
    end;


    if Align in [alLeft, alRight] then
    begin
      if toTile in Options then
      begin
        ButtonArea.Top := CaptionButton.Bottom;

        DeltaY := 0;
        DeltaX := 0;
        for i := 0 to ButtonList.Count - 1 do
        begin
          ButtonList[i].Left := ButtonArea.Left + DeltaX;
          ButtonList[i].Top := ButtonArea.Top + DeltaY;
          DeltaY := DeltaY + ButtonList[i].Height;

          if i < ButtonList.Count - 1 then
          begin
            if (ButtonArea.Top + DeltaY + ButtonList[i+1].Height) > (Top + Height) then
            begin
              DeltaX := DeltaX + ButtonList[i].Width;
              DeltaY := 0;
            end
          end
        end
      end else
      begin
        ButtonArea.Top := CaptionButton.Bottom;

        DeltaY := 0;
        for i := 0 to ButtonList.Count - 1 do
        begin
          ButtonList[i].Left := ButtonArea.Left;
          ButtonList[i].Top := ButtonArea.Top + DeltaY;
          DeltaY := DeltaY + ButtonList[i].Height
        end
      end
    end else
    begin
      if toTile in Options then
      begin
        ButtonArea.Left := CaptionButton.Right;

        DeltaX := 0;
        DeltaY := 0;
        for i := 0 to ButtonList.Count - 1 do
        begin
          ButtonList[i].Top := ButtonArea.Top + DeltaY;
          ButtonList[i].Left := ButtonArea.Left + DeltaX;
          DeltaX := DeltaX + ButtonList[i].Width;

          if i < ButtonList.Count - 1 then
          begin
            if (ButtonArea.Left + DeltaX + ButtonList[i+1].Width) > (Left + Width) then
            begin
              DeltaY := DeltaY + ButtonList[i].Height;
              DeltaX := 0;
            end
          end
        end
      end else
      begin
        ButtonArea.Left := CaptionButton.Right;

        DeltaX := 0;
        for i := 0 to ButtonList.Count - 1 do
        begin
          ButtonList[i].Top := ButtonArea.Top;
          ButtonList[i].Left := ButtonArea.Left + DeltaX;
          DeltaX := DeltaX + ButtonList[i].Width
        end

      end
    end
  end else
  begin
    AutoSize := False;
    Autosize := True;
  end;
  ResizeCaptionButton;
end;


procedure TCustomVirtualToolbar.ResizeCaptionButton;
var
  Size: TSize;
begin
  Size := CaptionButton.CalcMaxExtentSize(Font);
  if Align in [alLeft, alRight] then
  begin
    CaptionButton.Height := Size.cy;
    CaptionButton.Width := Width
  end else
  begin
    CaptionButton.Width := Size.cx;
    if ButtonList.Count > 0 then
      CaptionButton.Height := ButtonList[ButtonList.Count - 1].Bottom
    else
      CaptionButton.Height := Size.cy
  end;
end;

procedure TCustomVirtualToolbar.UpdateDropStates(ScreenMousePos: TPoint);
// Updates the State property by checking and marking the correct state the drop
// would produce if dropped on ScreenMousePos.  Either it would be an insert of
// a new button or a drop of file(s) to launch on an existing button
var
  BtnClientPt: TPoint;
begin
  // Do we have any formats we can use? These are set in DragEnter
  if States * [tsVSTShellToobarValid, tsShellIDListValid] <> [] then
  begin
    FDropTarget := PointToButton(ScreenMousePos);
    if Assigned(FDropTarget) then
    begin
      BtnClientPt := FDropTarget.ScreenToClient(ScreenMousePos);
      if Align in [alTop, alBottom] then
      begin
        // This is really confusing....  Ok
        // If the tsVSTShellToobarValid is in States if is always true
        // If the toolbar is toInsertDropable and the mouse is within the defined
        // margin at the front or tail edge of the button then the if is true
        if (tsVSTShellToobarValid in States) or
           ((toInsertDropable in Options) and
           ((BtnClientPt.x < DropInsertMargin) or
           (BtnClientPt.x > FDropTarget.Width - DropInsertMargin))) then
        begin
          Include(FStates, tsDragInDropZone);
          Exclude(FStates, tsDragInLaunchZone);
        end else
        begin
          Exclude(FStates, tsDragInDropZone);
          if (toLaunchDropable in Options) then
            Include(FStates, tsDragInLaunchZone)
          else
            Include(FStates, tsDragInLaunchZone)
        end
      end else
      begin
        // This is really confusing....  Ok
        // If the tsVSTShellToobarValid is in States if is always true
        // If the toolbar is toInsertDropable and the mouse is within the defined
        // margin at the front or tail edge of the button then the if is true
        if (tsVSTShellToobarValid in States) or
           ((toInsertDropable in Options) and
           ((BtnClientPt.y < DropInsertMargin) or
           (BtnClientPt.y > FDropTarget.Height - DropInsertMargin))) then
        begin
          Include(FStates, tsDragInDropZone);
          Exclude(FStates, tsDragInLaunchZone);
        end else
        begin
          Exclude(FStates, tsDragInDropZone);
          if (toLaunchDropable in Options) then
            Include(FStates, tsDragInLaunchZone)
          else
            Include(FStates, tsDragInLaunchZone)
        end
      end
    end else
    begin
      Exclude(FStates, tsDragInLaunchZone);
      if toInsertDropable in Options then
        Include(FStates, tsDragInDropZone)
      else
        Exclude(FStates, tsDragInDropZone);
    end
  end
end;

function TCustomVirtualToolbar.PointToInsertIndex(ScreenPt: TPoint): integer;
// Finds the index of where to insert a new button based on the point passed to the
// method.  The point must be in Screen Coordinates.  First finds the closest edge
// of the button then uses that edge to determine the insert point.
var
  R: TRect;
  Index: integer;
  Done: Boolean;
begin
  Result := 0;
  Done := False;

  R := ClosestButtonEdge(ScreenPt);

  if Align in [alTop, alBottom] then
  begin
    Index := 0;
    while not Done and (Index < ButtonList.Count) do
    begin
      if (ButtonList[Index].Left = R.Left) and (ButtonList[Index].Top >= R.Top)
        and (ButtonList[Index].Bottom <= R.Bottom)  then
      begin
        Result := Index;
        Done := True
      end else
      if (ButtonList[Index].Right = R.Left)  and (ButtonList[Index].Top >= R.Top)
        and (ButtonList[Index].Bottom <= R.Bottom) then
      begin
        Result := Index + 1;
        Done := True
      end;
      Inc(Index)
    end;
  end else
  if Align in [alLeft, alRight] then
  begin
    Index := 0;
    while not Done and (Index < ButtonList.Count) do
    begin
      if (ButtonList[Index].Top = R.Top) and (ButtonList[Index].Left >= R.Left)
        and (ButtonList[Index].Right <= R.Right)  then
      begin
        Result := Index;
        Done := True
      end else
      if (ButtonList[Index].Bottom = R.Top)  and (ButtonList[Index].Left >= R.Left)
        and (ButtonList[Index].Right <= R.Right) then
      begin
        Result := Index + 1;
        Done := True
      end;
      Inc(Index)
    end
  end
end;

procedure TCustomVirtualToolbar.SetThreadedImagesEnabled(const Value: Boolean);
begin
  if (ComponentState * [csDesigning, csLoading] = []) and not (csCreating in ControlState) then
  begin
    if FThreadedImagesEnabled <> Value then
    begin
      if Value then
      begin
        FThreadedImagesEnabled := True
      end else
      begin
        GlobalThreadManager.FlushMessageCache(Self, TID_ICON);
        FThreadedImagesEnabled := False
      end
    end
  end
end;

procedure TCustomVirtualToolbar.WMNCDestroy(var Message: TWMNCDestroy);
begin
  ThreadedImagesEnabled := False;
  ChangeNotifierEnabled := False;
  inherited;
end;

procedure TCustomVirtualToolbar.SetChangeNotiferEnabled(const Value: Boolean);
begin
  if FChangeNotifierEnabled <> Value then
  begin
    if Value and not (ComponentState * [csDesigning, csLoading] <> []) then
    begin
      ChangeNotifier.RegisterShellChangeNotify(Self);
      FChangeNotifierEnabled := True
    end else
    begin
      ChangeNotifier.UnRegisterShellChangeNotify(Self);
      FChangeNotifierEnabled := False
    end
  end
end;

procedure TCustomVirtualToolbar.RecreateToolbar;
begin
  ReCreateButtons;
  DoRecreateButtons
end;

procedure TCustomVirtualToolbar.DoRecreateButtons;
begin
  if Assigned(OnRecreateButtons) then
    OnReCreateButtons(Self)
end;

procedure TCustomVirtualToolbar.DoCreateButtons;
begin
  if Assigned(OnCreateButtons) then
    OnCreateButtons(Self)
end;

{ TVirtualButtonList }

function TVirtualButtonList.AddButton(Index: integer = -1): TCustomWideSpeedButton;

// Creates a new Toobar Button and adds it to the list based on the Index parameter
// If -1 then the button is added to the end of the list.
// Note CreateToolButton may be overridden to create different TCustomWideSpeedButton decendants

begin
  Toolbar.BeginUpdate;
  Result := CreateToolButton;
  Result.Flat := toFlat in Toolbar.Options;
  Result.Transparent := toTransparent in Toolbar.Options;
  Result.ThemeAware := toThemeAware in Toolbar.Options;
  Result.HotAnimate := toAnimateHot in Toolbar.Options;
  Result.Layout := Toolbar.ButtonLayout;
  Result.Margin := Toolbar.ButtonMargin;
  Result.Spacing := Toolbar.ButtonSpacing;
  Result.OLEDraggable := toCustomizable in Toolbar.Options;

  case Index of
    -1: Add(Result);
  else
    Insert(Index, Result)
  end;
  Toolbar.EndUpdate;
end;

procedure TVirtualButtonList.BeginUpdate;

// Locks any screen updating during any button maniuplation

begin
  Inc(FUpdateCount);
end;

procedure TVirtualButtonList.Clear;

// Overridden to automaticlly free the contents of the List (TCustomWideSpeedButton or
// decendants)

var
  i: integer;
  Button: TCustomWideSpeedButton;
begin
  for i := Count - 1 downto 0 do
  begin
    // During Design time the buttons are owned by the Toolbar so they can't
    // be selected in the IDE.  That means we must unassociate them from the
    // toolbar first.
    if csDesigning in Toolbar.ComponentState then
      Toolbar.RemoveComponent(Items[i]);
    Button := Items[i];
    Remove(Button);
    Button.Free;
  end;
  inherited;
end;

function TVirtualButtonList.CreateToolButton: TCustomWideSpeedButton;

// Simply creates a toolbutton but it is a virtual method so decendants of TCustomWideSpeedButton
// can be created by deriving from TVirtualButtonList, overriding this method to create
// decendants of TCustomWideSpeedButton.

begin
  // During Design time the buttons are owned by the Toolbar so they can't be selected in the IDE
  if csDesigning in Toolbar.ComponentState then
    Result := TCustomWideSpeedButton.Create(Toolbar)  // This list owns the buttons not the parent
  else
    Result := TCustomWideSpeedButton.Create(nil);  // This list owns the buttons not the parent
  Result.Parent := Toolbar
end;

procedure TVirtualButtonList.EndUpdate;

// Rebuilds the Toolbar after FUpdateCount falls to 0 so Adding or Deleting buttons
// can be done without taking lenghtly breaks to update the screen after each

begin
  Dec(FUpdateCount);
  if FUpdateCount < 0 then
    FUpdateCount := 0;
  if (FUpdateCount = 0) and Assigned(Toolbar) then
    Toolbar.RebuildToolbar
end;

function TVirtualButtonList.GetItems(Index: integer): TCustomWideSpeedButton;

// Override of TList to return a TCustomWideSpeedButton type

begin
  Result := TCustomWideSpeedButton( inherited Items[Index]);
end;

procedure TVirtualButtonList.RemoveButton(Button: TCustomWideSpeedButton);
begin
  if IndexOf(Button) <> -1 then
  begin
    Remove(Button);
    Button.Free
  end
end;

procedure TVirtualButtonList.SetItems(Index: integer; const Value: TCustomWideSpeedButton);

// Override of TList to set a TCustomWideSpeedButton type (not necessary but good practice
// in overriding properties)

begin
  inherited Items[Index] := Value
end;


{ TVirtualShellButtonList }

function TVirtualShellButtonList.AddButton(Index: integer): TCustomWideSpeedButton;
begin
  Toolbar.BeginUpdate;
  Result := inherited AddButton(Index);
  (Result as TShellToolButton).CaptionOptions := (Toolbar as TCustomVirtualShellToolbar).ButtonCaptionOptions;
  Toolbar.EndUpdate;
end;

function TVirtualShellButtonList.CreateToolButton: TCustomWideSpeedButton;

// Override of TVirtualButtonList to create a TCustomWideSpeedButton decendant.  Now calls to
// AddButton in a TVirtualShellButtonList object will create a TShellToolButton

begin
  // During Design time the buttons are owned by the Toolbar so they can't be selected in the IDE
  if csDesigning in Toolbar.ComponentState then
    Result := TShellToolButton.Create(Toolbar)  // This list owns the buttons not the parent
  else
    Result := TShellToolButton.Create(nil); // This list owns the buttons not the parent
  Result.Parent := Toolbar;
end;

function TVirtualShellButtonList.GetItems(Index: integer): TShellToolButton;

// Override of TVirtualButtonList to return a TCustomWideSpeedButton type decendant, TShellToolButton

begin
  Result := TShellToolButton( inherited Items[Index])
end;

procedure TVirtualShellButtonList.SetItems(Index: integer; const Value: TShellToolButton);

// Override of TVirtualButtonList to set a TShellToolButton type (not necessary but
// good practice in overriding properties)

begin
  inherited Items[Index] := Value
end;

{ TCaptionButton }

function TCaptionButton.CalcMaxExtentRect(Font: TFont): TRect;

// Calculates the size of the rectangle that is necessary to completely display
// the Caption.  The BorderMargin is an aritifical number just so the text does
// not touch the adjust button edge

const
  BorderMargin = 4;
var
  Size: TSize;
begin
  if Caption <> '' then
  begin
    Size := TextExtentW(PWideChar(Caption), Font);
    SetRect(Result, 0, 0, Size.cx + BorderMargin, Size.cy + BorderMargin);
  end else
    SetRect(Result, 0, 0, 0, 0)
end;

function TCaptionButton.CanAutoSize(var NewWidth,
  NewHeight: Integer): Boolean;
begin
  Result := inherited CanAutoSize(NewWidth, NewHeight);
end;

constructor TCaptionButton.Create(AOwner: TComponent);
begin
  inherited;
  Constraints.MinHeight := 0;
  Constraints.MinWidth := 0;
  AutoSize := True;
  Align := alLeft;
  Transparent := True
end;

function TCaptionButton.CanResize(var NewWidth: Integer; var NewHeight: Integer): Boolean;
begin
  Result:= inherited CanResize(NewWidth, NewHeight);
end;

procedure TCaptionButton.PaintButton(DC: HDC; ForDragImage: Boolean = False);

// Overriden method to paint the static text "button"

var
  BiDiFlags: Longword;
  TextBounds, R: TRect;
  OldMode: integer;
  PartType, PartState, dwTextFlags1, dwTextFlags2: Longword;
begin
  if Caption <> '' then
  begin
    BiDiFlags := DrawTextBiDiModeFlags(0);

    if ThemeAware and (bsThemesActive in State) then
    begin
      R := ClientRect;
      PartType := TP_BUTTON;
      PartState := TS_NORMAL;
      DrawThemeBackground(ThemeToolbar, DC, PartType, PartState, R, nil);
      GetThemeBackgroundContentRect(ThemeToolbar, DC, PartType, PartState, R, @R);

      dwTextFlags1 := DT_CENTER or DT_SINGLELINE or DT_VCENTER;
      dwTextFlags2 := 0;
      DrawThemeText(ThemeToolbar, DC, PartType, PartState, PWideChar(Caption),
        Length(Caption), dwTextFlags1 or BiDiFlags, dwTextFlags2, R);
    end else
    begin
      TextBounds := ClientRect;
      OldMode := SetBkMode(DC, Windows.TRANSPARENT);
      InflateRect(TextBounds, -2, -2);
      dwTextFlags1 := DT_CENTER or DT_SINGLELINE or DT_VCENTER;
      if IsUnicode then
        DrawTextW_MP(DC, PWideChar(Caption), Length(Caption), TextBounds,
          dwTextFlags1 or BiDiFlags)
      else begin
        DrawText(DC, Caption, Length(Caption), TextBounds,
          dwTextFlags1 or BiDiFlags)
      end;
      SetBkMode(DC, OldMode)
    end
  end
end;

{ TCustomVirtualDriveToolbar }

constructor TCustomVirtualDriveToolbar.Create(AOwner: TComponent);
begin
  inherited;
  ControlState := ControlState + [csCreating];
  FDriveSpecialFolders := [dsfRemovable, dsfReadOnly, dsfFixedDrive];
  ControlState := ControlState - [csCreating]
end;

procedure TCustomVirtualDriveToolbar.CreateButtons;

const
  FLAGS = SHCONTF_FOLDERS;

var
  Desktop, Folder: IShellFolder;
  EnumIDList: IEnumIDList;
  PIDL, SubPIDL, TempPIDL: PItemIDList;
  celtFetched: LongWord;
  Button: TShellToolButton;
  NS: TNamespace;
  IsFloppy, IsReadOnly, Allow, IsDrive: boolean;
begin
  BeginUpdate;
  try
    ButtonList.Clear;
    SHGetDesktopFolder(Desktop);
    if dsfDesktop in SpecialDriveFolders then
    begin
      Button := TShellToolButton( ButtonList.AddButton);
      Button.Namespace := TNamespace.Create(nil, nil);
      DoAddButton(Button.Namespace, Allow);
      if not Allow then
        ButtonList.RemoveButton(Button);
    end;

    // Always get this PIDL and keep it for enumeration later
    SHGetSpecialFolderLocation(0, CSIDL_DRIVES, PIDL);
    if (dsfMyComputer in SpecialDriveFolders) and Assigned(PIDL) then
    begin
      Button := TShellToolButton( ButtonList.AddButton);
      Button.Namespace := TNamespace.Create(PIDLMgr.CopyPIDL(PIDL), nil);
      Button.CaptionOptions := ButtonCaptionOptions;
      DoAddButton(Button.Namespace, Allow);
      if not Allow then
        ButtonList.RemoveButton(Button);
    end;

    if dsfNetworkNeighborhood in SpecialDriveFolders then
    begin
      SHGetSpecialFolderLocation(0, CSIDL_NETWORK, TempPIDL);
      if Assigned(TempPIDL) then
      begin
        Button := TShellToolButton( ButtonList.AddButton);
        Button.Namespace := TNamespace.Create(TempPIDL, nil);
        DoAddButton(Button.Namespace, Allow);
        if not Allow then
          ButtonList.RemoveButton(Button);
      end;
    end;

    if Assigned(PIDL) then
    begin
      if Desktop.BindToObject(PIDL, nil, IShellFolder, Pointer(Folder)) = S_OK then
      begin
        if Folder.EnumObjects(0, FLAGS, EnumIDList) = NOERROR then
        begin
          while EnumIDList.Next(1, SubPIDL, celtFetched) = NOERROR do
          begin
            NS := TNamespace.Create(PIDLMgr.AppendPIDL(PIDL, SubPIDL), nil);

            IsDrive := WideIsDrive(NS.NameForParsing);
            IsFloppy :=  IsDrive and ((NS.NameForParsing[1] = 'A') or (NS.NameForParsing[1] = 'B'));
            IsReadOnly := (not IsFloppy) and NS.ReadOnly;
            if IsDrive and (
               ((dsfRemovable in SpecialDriveFolders) and NS.Removable) or
               ((dsfReadOnly in SpecialDriveFolders) and IsReadOnly) or
               ((dsfFixedDrive in SpecialDriveFolders) and ((not IsReadOnly) and (not NS.Removable)))) then
            begin
              Button := TShellToolButton( ButtonList.AddButton);
              Button.Namespace := NS;
              Button.Hint := Button.Namespace.NameParseAddress;
              DoAddButton(Button.Namespace, Allow);
              if not Allow then
                ButtonList.RemoveButton(Button);
            end else
              NS.Free;
            CoTaskMemFree(SubPIDL);
          end
        end
      end;
      CoTaskMemFree(PIDL);
    end;
  finally
    EndUpdate;
    DoCreateButtons
  end
end;

function TCustomVirtualDriveToolbar.GetOptions: TVirtualToolbarOptions;
begin
  Result := inherited Options
end;

procedure TCustomVirtualDriveToolbar.SetOptions(const Value: TVirtualToolbarOptions);
var
  Temp: TVirtualToolbarOptions;
begin
  Temp := Value;
  // Can't allow these two options to occur with the Shell Buttons
  if Temp * [toCustomizable, toInsertDropable] <> [] then
    Beep;
  Temp := Temp - [toCustomizable, toInsertDropable];
  inherited Options := Temp;
end;

procedure TCustomVirtualDriveToolbar.SetSpecialDriveFolders(const Value: TDriveSpecialFolders);
begin
  if FDriveSpecialFolders <> Value then
  begin
    FDriveSpecialFolders := Value;
    CreateButtons;
  end
end;

procedure TCustomVirtualDriveToolbar.WMRemoveButton(var Message: TMessage);
begin
  // Just eat this we can't remove button from this toolbar
end;

{ TShellToolButton }

procedure TShellToolButton.Click;
begin
  AddToUpdateRgn;
  Update;
  if Assigned(Namespace) then
    if {$IFDEF EXPLORERTREE_L}Assigned((Parent as TCustomVirtualShellToolbar).VirtualExplorerTree){$ELSE}False{$ENDIF} 
       and Namespace.Folder then
      (Parent as TCustomVirtualShellToolbar).ChangeLinkDispatch(Namespace.AbsolutePIDL)
    else
    if not (toUserDefinedClickAction in (Parent as TCustomVirtualToolbar).Options) then
      Namespace.ShellExecuteNamespace('', '', True, MP_ThreadedShellExecute);
  inherited;
end;

constructor TShellToolButton.Create(AOwner: TComponent);
begin
  inherited;
  Margin := 2;
  AutoSize := True;
  FImageList := SmallSysImages;
end;

destructor TShellToolButton.Destroy;
begin
  Namespace.Free;
  inherited;
end;

function TShellToolButton.DragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  inherited DragEnter(dataObj, grfKeyState, pt, dwEffect);
  if Assigned(Namespace) then
    Result := Namespace.DragEnter(dataObj, grfKeyState, pt, dwEffect)
  else
    Result := S_OK
end;

function TShellToolButton.DragLeave: HResult;
begin
  inherited DragLeave;
  if Assigned(Namespace) then
    Result := Namespace.DragLeave
  else
    Result := S_OK
end;

function TShellToolButton.DragOverOLE(grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  inherited DragOverOLE(grfKeyState, pt, dwEffect);
  if Assigned(Namespace) then
    Result := Namespace.DragOver(grfKeyState, pt, dwEffect)
  else
    Result := S_OK
end;

function TShellToolButton.Drop(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  inherited Drop(dataObj, grfKeyState, pt, dwEffect);
  if Assigned(Namespace) then
    Result := Namespace.Drop(dataObj, grfKeyState, pt, dwEffect)
  else
    Result := S_OK
end;

function TShellToolButton.GetCaption: WideString;

// Overrides the Caption property getter to automaticlly retrieve the name of the
// Shell Object from the Namespace property.  To refresh the Caption set it to an
// empty string '' and the next call to retrieve it will force a reload from the
// namespace

begin
  if (FCaption = '') and Assigned(Namespace) then
  begin
    if coFolderName in CaptionOptions then
      FCaption := Namespace.NameNormal
    else
    if coFolderPath in CaptionOptions then
      FCaption := Namespace.NameParseAddress
    else
    if coDriveLetterOnly in CaptionOptions then
    begin
      if (Namespace.FileSystem and WideIsDrive(Namespace.NameParseAddress)) then
        FCaption := Namespace.NameParseAddress[1]
      else
      if Namespace.IsNetworkNeighborhood then
        FCaption := '\'
      else
        FCaption := '';
    end;

    if (coNoExtension in CaptionOptions) and (Length(FCaption) > 0) and not (coDriveLetterOnly in CaptionOptions) then
      WideStripExt(FCaption);


    Hint := Namespace.NameParseAddress;
  end;
  Result := FCaption
end;

function TShellToolButton.GetImageIndex: integer;

// Overrides the ImageIndex property getter to automaticlly retrieve the SystemImageList
// index of the Shell Object from the Namespace property.  To refresh the ImageIndex set
// it to -1 and the next call to retrieve it will force a reload from the namespace
var
  Request: TShellIconThreadRequest;
begin
  if Assigned(Namespace) then
  begin
    if Parent is TCustomVirtualShellToolbar then
    begin
      if TCustomVirtualShellToolbar(Parent).ThreadedImagesEnabled then
      begin
        if not Namespace.ThreadedIconLoaded then
        begin
          if not Namespace.ThreadIconLoading then
          begin
            Namespace.ThreadIconLoading := True;
            Request := TShellIconThreadRequest.Create;
            Request.ID := TID_ICON;
            Request.Window := Parent;
            Request.PIDL := PIDLMgr.CopyPIDL(Namespace.AbsolutePIDL);
            Request.Priority := 0;
            Request.Tag := Integer(Self);
            GlobalThreadManager.AddRequest(Request, True);
            Result := 0
          end else
            Result := 0
        end else
          Result := Namespace.GetIconIndex(False, icSmall, True);
      end else
      begin
        // Not using threaded images
        Result := Namespace.GetIconIndex(False, icSmall, True);
      end
    end else
      Result := Namespace.GetIconIndex(False, icSmall, True);
  end else
    Result := -1;
end;

procedure TShellToolButton.LoadFromStream(S: TStream);
begin
  inherited;
  if Assigned(Namespace) then
    FreeAndNil(FNamespace);
  Namespace := TNamespace.Create(PIDLMgr.LoadFromStream(S), nil)
end;

function TShellToolButton.SaveToDataObject(const DataObject: ICommonDataObject): Boolean;
var
  VSTShellToolbar: TVSTShellToolbar;
begin
  VSTShellToolbar := TVSTShellToolbar.Create;
  try
    VSTShellToolbar.PIDL := Namespace.AbsolutePIDL;
    Result := VSTShellToolbar.SaveToDataObject(DataObject);
  finally
    VSTShellToolbar.Free
  end;
end;

procedure TShellToolButton.SaveToStream(S: TStream);
begin
  inherited;
  if Assigned(Namespace) then
    PIDLMgr.SaveToStream(S, Namespace.AbsolutePIDL);
end;

procedure TShellToolButton.SetCaptionOptions(const Value: TCaptionOptions);

    function BitChanged(A, B: TCaptionOptions; Bit: TCaptionOption): Boolean;
    begin
      Result := ((Bit in A) and not(Bit in B)) or ((Bit in B) and not(Bit in A))
    end;

var
  Temp: TCaptionOptions;
begin
  if FCaptionOptions <> Value then
  begin
    Temp := Value;
    if BitChanged(Value, FCaptionOptions, coFolderName) then
      Temp := Temp - [coFolderPath, coDriveLetterOnly]
    else
    if BitChanged(Value, FCaptionOptions, coFolderPath) then
      Temp := Temp - [coFolderName, coDriveLetterOnly]
    else
    if BitChanged(Value, FCaptionOptions, coDriveLetterOnly) then
      Temp := Temp - [coFolderPath, coFolderName];

    FCaptionOptions := Temp;
    // Force the caption to be reread
    FCaption := '';
    RebuildButton
  end
end;

procedure TShellToolButton.WMContextMenu(var Message: TWMContextMenu);
begin
  if Assigned(Namespace) and (toContextMenu in (Parent as TCustomVirtualToolbar).Options) then
    Namespace.ShowContextMenu(Parent, nil, nil, nil);
end;

{ TCustomVirtualShellToolbar }
constructor TCustomVirtualShellToolbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  GlobalThreadManager.RegisterControl(Self);
end;

destructor TCustomVirtualShellToolbar.Destroy;
begin
  GlobalThreadManager.UnRegisterControl(Self);
  inherited Destroy;
end;


procedure TCustomVirtualShellToolbar.ChangeLinkDispatch(PIDL: PItemIDList);
begin
  VETChangeDispatch.DispatchChange(Self, PIDL);
end;

procedure TCustomVirtualShellToolbar.ChangeLinkFreeing(ChangeLink: IVETChangeLink);
begin
  if ChangeLink.ChangeLinkServer = Self then
  begin
  {$IFDEF EXPLORERTREE_L}
    if ChangeLink.ChangeLinkClient = FVirtualExplorerTree then
      FVirtualExplorerTree := nil;
  {$ENDIF}
  end
end;

function TCustomVirtualShellToolbar.CreateButtonList: TVirtualButtonList;
begin
  Result := TVirtualShellButtonList.Create
end;

procedure TCustomVirtualShellToolbar.DoAddButton(Namespace: TNamespace;
  var Allow: Boolean);
begin
  Allow := True;
  if Assigned(OnAddButton) then
    OnAddButton(Self, Namespace, Allow)
end;

procedure TCustomVirtualShellToolbar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
{$IFDEF EXPLORERCOMBOBOX_L}
  if (AComponent = FVirtualExplorerComboBox) and (Operation = opRemove) then
    VirtualExplorerComboBox := nil;
{$ENDIF}
{$IFDEF EXPLORERTREE_L}
  if (AComponent = FVirtualExplorerTree) and (Operation = opRemove) then
    VirtualExplorerTree := nil;
{$ENDIF}
end;

procedure TCustomVirtualShellToolbar.SetButtonCaptionOptions(
  const Value: TCaptionOptions);
var
  i: integer;
begin
  if FButtonCaptionOptions <> Value then
  begin
    FButtonCaptionOptions := Value;
    for i := 0 to ButtonList.Count - 1 do
    begin
      TShellToolButton(ButtonList[i]).CaptionOptions := Value;
      // Some choices are mutually exclusive so mirror what the button does
      FButtonCaptionOptions := TShellToolButton(ButtonList[i]).CaptionOptions;
    end
  end;
  RebuildToolbar
end;

{$IFDEF EXPLORERCOMBOBOX_L}
procedure TCustomVirtualShellToolbar.SetVirtualExplorerComboBox(
  const Value: TCustomVirtualExplorerComboBox);
begin
  if FVirtualExplorerComboBox <> Value then
  begin
    { We need to set us up as the server for Toolbars so this is a bit backwards }
    { from other VSTools components                                              }
    if Assigned(FVirtualExplorerComboBox) then
      VETChangeDispatch.UnRegisterChangeLink(Self, FVirtualExplorerComboBox, utLink );
    FVirtualExplorerComboBox := Value;
    if Assigned(FVirtualExplorerComboBox) then
      VETChangeDispatch.RegisterChangeLink(Self, FVirtualExplorerComboBox,
        FVirtualExplorerComboBox.ChangeLinkChanging, ChangeLinkFreeing);
  end
end;
{$ENDIF}

{$IFDEF EXPLORERTREE_L}
procedure TCustomVirtualShellToolbar.SetVirtualExplorerTree(
  const Value: TCustomVirtualExplorerTree);
begin
  if FVirtualExplorerTree <> Value then
  begin
    { We need to set us up as the server for Toolbars so this is a bit backwards }
    { from other VSTools components                                              }
    if Assigned(FVirtualExplorerTree) then
      VETChangeDispatch.UnRegisterChangeLink(Self, FVirtualExplorerTree, utLink );
    FVirtualExplorerTree := Value;
    if Assigned(FVirtualExplorerTree) then
      VETChangeDispatch.RegisterChangeLink(Self, FVirtualExplorerTree,
        FVirtualExplorerTree.ChangeLinkChanging, ChangeLinkFreeing);
  end
end;
{$ENDIF}

procedure TCustomVirtualShellToolbar.WMCommonThreadCallback(var Msg: TWMThreadRequest);
var
  i: integer;
  Found: Boolean;
  Request: TShellIconThreadRequest;
begin
  try
    case Msg.RequestID of
      TID_ICON:
        begin
          Request := Msg.Request as TShellIconThreadRequest;
          i := 0;
          Found := False;
          while not Found and (i < ButtonList.Count) do
          begin
            if ButtonList[i] = TCustomWideSpeedButton( Request.Tag) then
            begin
              TShellToolButton(ButtonList[i]).Namespace.SetIconIndexByThread(Request.ImageIndex, Request.OverlayIndex, True);
              TShellToolButton(ButtonList[i]).Invalidate;
              Found := True
            end;
            Inc(i)
          end
        end
      end;
  finally
    Msg.Request.Release;
  end
end;

procedure TCustomVirtualShellToolbar.WMShellNotify(var Msg: TMessage);
var
  Count: Integer;
  ShellEventList: TVirtualShellEventList;
  ShellEvent: TVirtualShellEvent;
  i: integer;
  List: TList;
  ReCreatedOnce: Boolean;
  NS: TNamespace;
  PIDL: PItemIDList;
  Flags: Longword;
begin
  BeginUpdate;
  try
    ReCreatedOnce := False;
    ShellEventList := TVirtualShellEventList( Msg.wParam);
    List := ShellEventList.LockList;
    try
      Count := List.Count;
      for i := 0 to Count - 1 do
      begin
        ShellEvent := TVirtualShellEvent(List.Items[i]);
        case ShellEvent.ShellNotifyEvent of
          // This group of notifications requires a reread of the parent folder.
          // They may have been the result of an item creation or deletion.
          // The NotifyThread removes redundant calls to these items so VET does not
          // need to respond to 5000 notifications if 5000 files are deleted.

          // Commented out events don't have any bearing on the toolbars state

     //     sneCreate,          // Creating a File
     //     sneDelete,          // Deleting a File
          vsneDriveAdd,          // Mapping a network drive
          vsneDriveAddGUI,       // CD inserted shell should create new window
          vsneDriveRemoved,      // UnMapping a network drive
     //     sneMkDir,           // Creating a Directory
     //     sneRmDir,           // Deleting a Directory
          vsneUpdateDir:       // Create or Delete File/Directory overload
            begin
              // WinVirtual sends a sneUpdateDir to remove a mapped Drive ???? Weird
              if not ReCreatedOnce then
              begin
                ReCreateButtons;
                ReCreatedOnce := True
              end
            end;
          // This group of notifications is special in that both PIDLs are used.  if
          // they have the same parent folder it is a rename, if not it is a move.
          // NT4 calls a deletion to the RecycleBin a move while Win2k calls it a
          // delete so the meaning varies depending on platform.
          vsneRenameFolder,  // Folder renamed or Moved; depends on Win version
          vsneRenameItem:    // File renamed or Moved; depends on Win version
            begin
            end;
          // This notification is sent when a namespace has been mapped to a
          // different image.
          vsneUpdateImage:   // New image has been mapped to the item
            begin
              FlushImageLists;
              if not ReCreatedOnce then
              begin
                ReCreateButtons;
                ReCreatedOnce := True
              end
            end;
          // This group of notifications is based on an existing namespace that has
          // had its properties changed.  As such the PIDL must be refreshed to read
          // in the new properties stored in the PIDL.
      //    sneAttributes,       // Printer properties changed and ???
          vsneMediaInserted,      // New CD inserted.
          vsneMediaRemoved,       // CD removed
          vsneNetShare,           // Folder being shared or unshared
          vsneNetUnShare,         // ?? Should be the opposite of NetShare
          vsneServerDisconnect:
       //   sneUpdateItem:       // Properties of file OR dir changed
            begin
              // M$ Hack to get Win9x to change the image and name of removable
              // drives when the media changes
              NS := TNamespace.Create(ShellEvent.PIDL1, nil);
              NS.FreePIDLOnDestroy := False;
              PIDL := NS.RelativePIDL;
              Flags := SFGAO_VALIDATE;
              NS.ParentShellFolder.GetAttributesOf(0, PIDL, Flags);
              NS.Free;
              if not ReCreatedOnce then
              begin
                ReCreateButtons;
                ReCreatedOnce := True
              end
            end;
          // This notification is sent when the freespace on a drive has changed.
          // for now it appears the only thing this my impact is the disk size
          // details under MyComputer.  Refresh if necessary.
          vsneFreeSpace:
            begin
            end;
          // This notification is sent when the shell has changed an assocciation of
          // file type was involved.
          vsneAssoccChanged:
            begin
              FlushImageLists;
              if not ReCreatedOnce then
              begin
                ReCreateButtons;
                ReCreatedOnce := True
              end
            end;
        end
      end;
    finally
      ShellEventList.UnlockList;
      ShellEventList.Release;
    end
  finally
    EndUpdate
  end
end;

{ TCustomSpecialFolderToolbar }

procedure TCustomVirtualSpecialFolderToolbar.CreateButtons;

  procedure CreateSpecialButton(CSIDL_BUTTON: Longword);
  var
    PIDL: PItemIDList;
    Button: TShellToolButton;
    Allow: Boolean;
  begin
    SHGetSpecialFolderLocation(0, CSIDL_BUTTON, PIDL);
    if Assigned(PIDL) then
    begin
      Button := TShellToolButton( ButtonList.AddButton);
      Button.Namespace := TNamespace.Create(PIDL, nil);
      Button.CaptionOptions := ButtonCaptionOptions;
      if toLargeButtons in FOptions then
        Button.ImageList := LargeSysImages
      else
        Button.ImageList := SmallSysImages;
      DoAddButton(Button.Namespace, Allow);
      if not Allow then
        ButtonList.RemoveButton(Button);
    end
  end;

begin
  BeginUpdate;
  try
    ButtonList.Clear;
    if sfAdminTools in SpecialFolders then
      CreateSpecialButton(CSIDL_ADMINTOOLS);
    if sfAltStartup in SpecialFolders then
      CreateSpecialButton(CSIDL_ALTSTARTUP);
    if sfAppData in SpecialFolders then
      CreateSpecialButton(CSIDL_APPDATA);
    if sfBitBucket in SpecialFolders then
      CreateSpecialButton(CSIDL_BITBUCKET);
    if sfCommonAdminTools in SpecialCommonFolders then
      CreateSpecialButton(CSIDL_COMMON_ADMINTOOLS);
    if sfCommonAltStartup in SpecialCommonFolders then
      CreateSpecialButton(CSIDL_COMMON_ALTSTARTUP);
    if sfCommonAppData in SpecialCommonFolders then
      CreateSpecialButton(CSIDL_COMMON_APPDATA);
    if sfCommonDesktopDirectory in SpecialCommonFolders then
      CreateSpecialButton(CSIDL_COMMON_DESKTOPDIRECTORY);
    if sfCommonDocuments in SpecialCommonFolders then
      CreateSpecialButton(CSIDL_COMMON_DOCUMENTS);
    if sfCommonFavorties in SpecialCommonFolders then
      CreateSpecialButton(CSIDL_COMMON_FAVORITES);
    if sfCommonPrograms in SpecialCommonFolders then
      CreateSpecialButton(CSIDL_COMMON_PROGRAMS);
    if sfCommonStartMenu in SpecialCommonFolders then
      CreateSpecialButton(CSIDL_COMMON_STARTMENU);
    if sfCommonStartup in SpecialCommonFolders then
      CreateSpecialButton(CSIDL_COMMON_STARTUP);
    if sfCommonTemplates in SpecialCommonFolders then
      CreateSpecialButton(CSIDL_COMMON_TEMPLATES);
    if sfControlPanel in SpecialFolders then
      CreateSpecialButton(CSIDL_CONTROLS);
    if sfCookies in SpecialFolders then
      CreateSpecialButton(CSIDL_COOKIES);
    if sfDesktop in SpecialFolders then
      CreateSpecialButton(CSIDL_DESKTOP);
    if sfDesktopDirectory in SpecialFolders then
      CreateSpecialButton(CSIDL_DESKTOPDIRECTORY);
    if sfDrives in SpecialFolders then
      CreateSpecialButton(CSIDL_DRIVES);
    if sfFavorites in SpecialFolders then
      CreateSpecialButton(CSIDL_FAVORITES);
    if sfFonts in SpecialFolders then
      CreateSpecialButton(CSIDL_FONTS);
    if sfHistory in SpecialFolders then
      CreateSpecialButton(CSIDL_HISTORY);
    if sfInternet in SpecialFolders then
      CreateSpecialButton(CSIDL_INTERNET);
    if sfInternetCache in SpecialFolders then
      CreateSpecialButton(CSIDL_INTERNET_CACHE);
    if sfLocalAppData in SpecialFolders then
      CreateSpecialButton(CSIDL_LOCAL_APPDATA);
    if sfMyPictures in SpecialFolders then
      CreateSpecialButton(CSIDL_MYPICTURES);
    if sfNetHood in SpecialFolders then
      CreateSpecialButton(CSIDL_NETHOOD);
    if sfNetwork in SpecialFolders then
      CreateSpecialButton(CSIDL_NETWORK);
    if sfPersonal in SpecialFolders then
      CreateSpecialButton(CSIDL_PERSONAL);
    if sfPrinters in SpecialFolders then
      CreateSpecialButton(CSIDL_PRINTERS);
    if sfPrintHood in SpecialFolders then
      CreateSpecialButton(CSIDL_PRINTHOOD);
    if sfProfile in SpecialFolders then
      CreateSpecialButton(CSIDL_PROFILE);
    if sfProgramFiles in SpecialFolders then
      CreateSpecialButton(CSIDL_PROGRAM_FILES);
    if sfCommonProgramFiles in SpecialFolders then
      CreateSpecialButton(CSIDL_PROGRAM_FILES_COMMON);
    if sfPrograms in SpecialFolders then
      CreateSpecialButton(CSIDL_PROGRAMS);
    if sfRecent in SpecialFolders then
      CreateSpecialButton(CSIDL_RECENT);
    if sfSendTo in SpecialFolders then
      CreateSpecialButton(CSIDL_SENDTO);
    if sfStartMenu in SpecialFolders then
      CreateSpecialButton(CSIDL_STARTMENU);
    if sfStartUp in SpecialFolders then
      CreateSpecialButton(CSIDL_STARTUP);
    if sfSystem in SpecialFolders then
      CreateSpecialButton(CSIDL_SYSTEM);
    if sfTemplate in SpecialFolders then
      CreateSpecialButton(CSIDL_TEMPLATES);
    if sfWindows in SpecialFolders then
      CreateSpecialButton(CSIDL_WINDOWS);
  finally
    EndUpdate
  end;
  DoCreateButtons;
end;

procedure TCustomVirtualSpecialFolderToolbar.SetSpecialCommonFolders(
  const Value: TSpecialCommonFolders);
begin
  if FSpecialCommonFolders <> Value then
  begin
    FSpecialCommonFolders := Value;
    // Get too much recreating of buttons and there is no point since the button will be created
    // when the window is created
    if not(csLoading in ComponentState) then
      CreateButtons;
//    if csDesigning in ComponentState then
      RebuildToolbar
  end
end;

procedure TCustomVirtualSpecialFolderToolbar.SetSpecialFolders(
  const Value: TSpecialFolders);
begin
  if FSpecialFolders <> Value then
  begin
    FSpecialFolders := Value;
    // Get too much recreating of buttons and there is no point since the button will be created
    // when the window is created
    if not(csLoading in ComponentState) then
      CreateButtons;
 //   if csDesigning in ComponentState then
      RebuildToolbar
  end
end;

procedure TCustomVirtualShellToolbar.CMRecreateWnd(var Message: TMessage);
begin
  inherited;
end;

{ TVSTShellToolbar }

function TVSTShellToolbar.GetFormatEtc: TFormatEtc;
begin
  Result.cfFormat := CF_VSTSHELLTOOLBAR;
  Result.ptd := nil;
  Result.dwAspect := DVASPECT_CONTENT;
  Result.lindex := -1;
  Result.tymed := TYMED_ISTREAM;
end;

function TVSTShellToolbar.GetPIDLSize: integer;
begin
  Result := PIDLMgr.PIDLSize(FPIDL)
end;

function TVSTShellToolbar.LoadFromDataObject(DataObject: IDataObject): Boolean;
var
  StgMedium: TStgMedium;
  Stream: IStream;
  BytesRead: LongInt;
  NewPos: uint64;
  LocalPIDLSize: integer;
  Malloc: IMalloc;
begin
  Result := False;
  if Succeeded(DataObject.QueryGetData(GetFormatEtc)) then
    if Succeeded(DataObject.GetData(GetFormatEtc, StgMedium)) then
    begin
      Stream := IStream( StgMedium.stm);
      Stream.Seek(0, STREAM_SEEK_SET, NewPos);
      Stream.read(@FProcess, SizeOf(Process), @BytesRead);
      Stream.read(@LocalPIDLSize, SizeOf(LocalPIDLSize), @BytesRead);
      SHGetMalloc(Malloc);
      PIDL := Malloc.Alloc(LocalPIDLSize);
      Stream.read(@PIDL^, LocalPIDLSize, @BytesRead);
      Result := True;
    end
end;

function TVSTShellToolbar.SaveToDataObject(DataObject: IDataObject): Boolean;
var
  StgMedium: TStgMedium;
  hMem: THandle;
  Stream: IStream;
  NewPos: uint64;
  Int: integer;
  BytesWritten: LongInt;
begin
  Result := True;
  ZeroMemory(@StgMedium, SizeOf(StgMedium));

  StgMedium.tymed := TYMED_ISTREAM;
  hMem := GlobalAlloc(GMEM_MOVEABLE or GMEM_SHARE or GMEM_ZEROINIT, 0);
  if hMem <> 0 then
    if Succeeded(CreateStreamOnHGlobal(hMem, True, IStream( StgMedium.stm))) then
    begin
      Stream := IStream( StgMedium.stm);
      Stream.Seek(0, STREAM_SEEK_SET, NewPos);

      Int := GetCurrentProcess;
      Stream.write(@Int, SizeOf(Int), @BytesWritten);
      Int := PIDLSize;
      Stream.write(@Int, SizeOf(Int), @BytesWritten);
      Stream.write(@FPIDL^, PIDLSize, @BytesWritten);

      // Give it to the data object
      Result := Succeeded(DataObject.SetData(GetFormatEtc, StgMedium, True))
    end
end;

initialization
  CF_VSTSHELLTOOLBAR := RegisterClipboardFormat(CFSTR_VSTSHELLTOOLBAR);

end.
