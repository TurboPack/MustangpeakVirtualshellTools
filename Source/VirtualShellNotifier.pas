unit VirtualShellNotifier;

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

//{$DEFINE VIRTUALNOTIFYDEBUG}

{$include Compilers.inc}
{$include ..\Include\AddIns.inc}

{$ifdef COMPILER_12_UP}
  {$WARN IMPLICIT_STRING_CAST       OFF}
 {$WARN IMPLICIT_STRING_CAST_LOSS  OFF}
{$endif COMPILER_12_UP}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  ShlObj, ShellAPI, ActiveX, ComObj,
  {$IFNDEF COMPILER_6_UP}
  Forms,
  {$ENDIF}
  MPCommonObjects,
  {$IFDEF TNTSUPPORT}
  TntClasses,
  {$ENDIF}
  VirtualResources,
  MPThreadManager, MPCommonUtilities;


const
  VirtualNotifyWndClass = 'vstVirtualNotifyWndClass';

  // Literal translations of TVirtualShellNotifyEvent type.  Useful when using the
  // OnShellNotify event to print out what event occured.  VirtualShellUtilities.pas
  // has a helper function ShellNotifyEventToStr that uses these.
  SHELL_NOTIFY_EVENTS: array[0..19] of WideString = (
    'Assocciation Changed',
    'Attributes',
    'Item Create',
    'Item Delete',
    'Drive Add',
    'Drive Add GUI',
    'Drive Removed',
    'Free Space',
    'Media Inserted',
    'Media Removed',
    'Make Directory',
    'Network Share',
    'Network Unshare',
    'Folder Rename',
    'Item Rename',
    'Remove Directory',
    'Server Disconnect',
    'Update Directory',
    'Update Image',
    'Update Item'
  );

type
  // Ordered in a particular way to sort on ordinal
  TVirtualShellNotifyEvent = (
    vsneRenameFolder,
    vsneRenameItem,
    vsneAssoccChanged,
    vsneAttributes,
    vsneCreate,
    vsneDelete,
    vsneDriveAdd,
    vsneDriveAddGUI,
    vsneDriveRemoved,
    vsneFreeSpace,
    vsneMediaInserted,
    vsneMediaRemoved,
    vsneMkDir,
    vsneNetShare,
    vsneNetUnShare,
    vsneRmDir,
    vsneServerDisconnect,
    vsneUpdateDir,
    vsneUpdateImage,
    vsneUpdateItem,
    vsneNone
  );

  TVirtualKernelNotifyEvent = (
    vkneFileName,         // Trigger when File Name changes
    vkneDirName,          // Trigger when Dir Name changes
    vkneAttributes,       // Trigger when file or dir attributes change
    vkneSize,             // Trigger when file size changes
    vkneLastWrite,        // Trigger when file last write data changes
    vkneLastAccess,       // Trigger when file last access date changes
    vkneCreation,         // Trigger when file creation date changes
    vkneSecurity          // Trigger when file security attributes change
  );
  TVirtualKernelNotifyEvents = set of TVirtualKernelNotifyEvent;

const
  // Having vkneLastAccess causes events when just displaying the file in a VET
  // window.  Not desireable so don't include it
  AllKernelNotifiers: TVirtualKernelNotifyEvents = [vkneFileName, vkneDirName,
    vkneAttributes, vkneSize, vkneLastWrite, {vkneLastAccess,} vkneCreation,
    vkneSecurity];

type
  IVirtualChangeNotifier = interface(IUnknown)
  ['{7F1E9F93-87C2-49E1-8AD5-F5A2E057122C}']
    procedure AddEvent(ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIdList; APIDLMgr: TCommonPIDLManager);
    function GetFilterEvents: Boolean;
    function GetMapVirtualFolders: Boolean;
    procedure LockNotifier;
    function NotifyWatchFolder(Control: TWinControl; WatchFolder: WideString): Boolean;
    procedure PostShellNotifyEvent(NotifyType: LPARAM; PIDL1, PIDL2: PItemIDList);
    function RegisterKernelChangeNotify(Control: TWinControl; NotifyEvents: TVirtualKernelNotifyEvents): Boolean;
    procedure RegisterKernelSpecialFolderWatch(SpecialFolder: Longword); // Use the SHGetSpecialFolder CSIDL_xxx constants
    function RegisterShellChangeNotify(Control: TWinControl): Boolean;
    procedure SetFilterEvents(const DoFilter: Boolean);
    procedure SetMapVirtualFolders(const Value: Boolean);
    procedure StripDuplicates(List: TList);
    procedure UnLockNotifier;
    function UnRegisterKernelChangeNotify(Control: TWinControl): Boolean;
    function UnRegisterShellChangeNotify(Control: TWinControl): Boolean;
    procedure UnRegisterChangeNotify(Control: TWinControl);
    procedure UnRegisterAllNotify;
  end;

{$IFDEF VIRTUALNOTIFYDEBUG}
type
  TVirtualNotifyDebug = class
  private
    FKernelEvents: Integer;
    FEventObjects: Integer;
    FShellEvents: Integer;
    FEventListObjects: Integer;
    FPeakKernelEvents: Integer;
    FPeakEventObjects: Integer;
    FPeakShellEvents: Integer;
    FPeakEventListObjects: Integer;
    FOnChange: TNotifyEvent;
    procedure SetEventObjects(const Value: Integer);
    procedure SetFEventListObjects(const Value: Integer);
    procedure SetKernelEvents(const Value: Integer);
    procedure SetShellEvents(const Value: Integer);
  protected
    procedure DoChange;
  public
    property KernelEvents: Integer read FKernelEvents write SetKernelEvents;
    property ShellEvents: Integer read FShellEvents write SetShellEvents;
    property EventObjects: Integer read FEventObjects write SetEventObjects;
    property EventListObjects: Integer read FEventListObjects write SetFEventListObjects;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property PeakKernelEvents: Integer read FPeakKernelEvents write FPeakKernelEvents;
    property PeakShellEvents: Integer read FPeakShellEvents write FPeakShellEvents;
    property PeakEventObjects: Integer read FPeakEventObjects write FPeakEventObjects;
    property PeakEventListObjects: Integer read FPeakEventListObjects write FPeakEventListObjects;
  end;
{$ENDIF}


type
  TVirtualChangeNotifier = class;  // Forward
  TVirtualShellEventList = class;  // Forward

  TChangeNamespace = class
  private
    FAbsolutePIDL: PItemIDList;
    FParentShellFolder: IShellFolder;
    FRelativePIDL: PItemIDList;
  public
    constructor Create(AnAbsolutePIDL: PItemIDList);
    destructor Destroy; override;
    function Valid: Boolean;
    property AbsolutePIDL: PItemIDList read FAbsolutePIDL write FAbsolutePIDL;
    property ParentShellFolder: IShellFolder read FParentShellFolder;
    property RelativePIDL: PItemIDList read FRelativePIDL;
  end;

  TChangeNamespaceArray = array of TChangeNamespace;

  // Structure of the TMessage sent to the window that registered as  notification recipient.
  TWMShellNotify = {$IFNDEF CPUX64}packed{$ENDIF} record
    Msg: Cardinal;
    {$IFDEF CPUX64}MsgFiller: TDWordFiller;{$ENDIF}
    ShellEventList: TVirtualShellEventList;
    Unused: LPARAM;
    Result: LRESULT;
  end;

  THandleArray = array of THandle;
  // Structure to hold the FindFirstChangeNotification handles and PILDs of the
  // folder associated with the handle
  TKernelWatchRec = packed record
    Handles: THandleArray;
    NSs: TChangeNamespaceArray;
  end;

  TEventListArray = array[0..19] of TList;


// TVirtualShellEvent Encapsulates a Shell Notification Event.  Since one the
// underlying notification systems is the undocumented SHChangeNotify client
// it must be in done in PIDL's
  TVirtualShellEvent = class
  private
    FDoubleWord1: DWORD;
    FDoubleWord2: DWORD;
    FFreeContentsOnDestroy: Boolean;
    FInvalidNamespace: Boolean;
    FPIDL1: PItemIDList;
    FPIDL2: PItemIDList;
    FParentPIDL1: PItemIDList;
    FParentPIDL2: PItemIDList;
    FShellNotifyEvent: TVirtualShellNotifyEvent;
    FHandled: Boolean; // Used in VET to allow app to handle the VET update and bypass built in checking

  protected
    function CopyPIDL(APIDL: PItemIDList): PItemIDList;
    function NextID(APIDL: PItemIDList): PItemIDList;
    function PIDLSize(APIDL: PItemIDList): integer;
    function StripLastID(APIDL: PItemIDList): PItemIDList;

  public
    constructor Create(AShellNotifyEvent: TVirtualShellNotifyEvent; aPIDL1,
      aPIDL2: PItemIDList; ADoubleWord1, ADoubleWord2: DWORD;
      IsInvalidNamespace: Boolean);
    destructor Destroy; override;

    property DoubleWord1: DWORD read FDoubleWord1 write FDoubleWord1;
    property DoubleWord2: DWORD read FDoubleWord2 write FDoubleWord2;
    property FreeContentsOnDestroy: Boolean read FFreeContentsOnDestroy write FFreeContentsOnDestroy;
    property Handled: Boolean read FHandled write FHandled;
    property InvalidNamespace: Boolean read FInvalidNamespace write FInvalidNamespace;
    property ParentPIDL1: PItemIDList read FParentPIDL1 write FParentPIDL1;
    property ParentPIDL2: PItemIDList read FParentPIDL2 write FParentPIDL2;
    property PIDL1: PItemIDList read FPIDL1 write FPIDL1;
    property PIDL2: PItemIDList read FPIDL2 write FPIDL2;
    property ShellNotifyEvent: TVirtualShellNotifyEvent read FShellNotifyEvent;
  end;

  // Implementation of a Reference counted list
  TVirtualReferenceCountedList = class(TThreadList)
  protected
    FRefCount: integer;
  public
    procedure AddRef;
    procedure Clear; virtual;
    procedure Release;
    property RefCount: integer read FRefCount;
  end;

  // Encapsulates a reference counted TList that contains TVirtualShellEvent objects.
  TVirtualShellEventList = class(TVirtualReferenceCountedList)
  private
    FID: Cardinal;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    property ID: Cardinal read FID write FID;
  end;

  TVirtualChangeDispatchThread = class(TCommonThread)
  private
    FWorkerChangeEvent: THandle;
    FChangeNotifier: TVirtualChangeNotifier;
    FDispatchList: TVirtualShellEventList; // The list that the thread is processing and dispatching
    FWorkingList: TVirtualShellEventList;  // The list that the notify thread dump into
    FAddLock: TRTLCriticalSection;
    FAddingEvents: Boolean;
    FRecycleFolderPIDLs: TList;
    FFilterEvents: Boolean;            // The virtual (@[0]) and hidden recycle bin folders on each logical drive
    function GetWorkingList: TVirtualShellEventList;
  protected
    procedure Execute; override;
    procedure FindRecycleFolders;
    function IsInRecycleBinFolder(PIDL: PItemIDList): Boolean;
    function IsRedundant(ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIDList; DoubleWord1, DoubleWord2: LongWord): Boolean;
    procedure ReduceCreateDeleteEvents(ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIdList; APIDLMgr: TCommonPIDLManager);
    procedure ReduceRenameEvents(ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIdList; APIDLMgr: TCommonPIDLManager);
    function ReduceRecycleBinEvent(ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIdList; APIDLMgr: TCommonPIDLManager): Boolean;

    property RecycleFolderPIDLs: TList read FRecycleFolderPIDLs write FRecycleFolderPIDLs;
  public
    constructor Create(CreateSuspended: Boolean; AChangeNotifier: TVirtualChangeNotifier); reintroduce; virtual;
    destructor Destroy; override;

    procedure AddEvent(AShellEvent: TVirtualShellEvent); overload;
    procedure AddEvent(ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIdList; APIDLMgr: TCommonPIDLManager; InvalidNamespace: Boolean); overload;
    procedure AddEvent(ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIdList; DoubleWord1, DoubleWord2: LongWord; APIDLMgr: TCommonPIDLManager; InvalidNamespace: Boolean); overload;
    procedure TriggerEvent;
    property AddingEvents: Boolean read FAddingEvents write FAddingEvents;
    property AddLock: TRTLCriticalSection read FAddLock write FAddLock;
    property DispatchList: TVirtualShellEventList read FDispatchList;
    property ChangeNotifier: TVirtualChangeNotifier read FChangeNotifier;
    property FilterEvents: Boolean read FFilterEvents write FFilterEvents;
    property WorkerChangeEvent: THandle read FWorkerChangeEvent write FWorkerChangeEvent;
    property WorkingList: TVirtualShellEventList read GetWorkingList;
  end;


  // The main thread that waits for ShellChange notification to then dispatch them
  // to the Worker Thread
  TVirtualShellChangeThread = class(TCommonThread)
  private
    FChangeNotifyHandle: THandle;
    FThreadPIDLMgr: TCommonPIDLManager;
    FMyDocsDeskPIDL: PItemIDList;
    FMyDocsPIDL: PItemIDList;
    FMapVirtualFolders: Boolean;
  private
    FNotifyWindowHandle: hWnd;
    FChangeNotifier: TVirtualChangeNotifier;
    FNotifyWndProcStub: ICallbackStub;

    procedure CreateNotifyWindow;
    procedure DestroyNotifyWindow;
    function NotifyWndProc(Wnd: HWND; Msg: UINT; wParam, lParam: LPARAM): LRESULT; stdcall;
    procedure RegisterChangeNotify;
    procedure UnRegisterChangeNotify;

    property ChangeNotifyHandle: THandle read FChangeNotifyHandle write FChangeNotifyHandle;
    property NotifyWindowHandle: hWnd read FNotifyWindowHandle write FNotifyWindowHandle;
  protected
    procedure Execute; override;

    property MyDocsDeskPIDL: PItemIDList read FMyDocsDeskPIDL write FMyDocsDeskPIDL;
    property MyDocsPIDL: PItemIDList read FMyDocsPIDL write FMyDocsPIDL;
    property NotifyWndProcStub: ICallbackStub read FNotifyWndProcStub write FNotifyWndProcStub;
    property ThreadPIDLMgr: TCommonPIDLManager read FThreadPIDLMgr write FThreadPIDLMgr;
  public
    constructor Create(CreateSuspended: Boolean; AChangeNotifier: TVirtualChangeNotifier); reintroduce; virtual;
    destructor Destroy; override;

    property ChangeNotifier: TVirtualChangeNotifier read FChangeNotifier;
    property MapVirtualFolders: Boolean read FMapVirtualFolders write FMapVirtualFolders;
  end;

  // The main thread that waits for KernelChange notification to then dispatch them
  // to the Worker Thread
  TVirtualKernelChangeThread = class(TCommonThread)
  private
    FKernelChangeEvent: THandle;
    FChangeNotifier: TVirtualChangeNotifier;
    FSpecialFolderVirtualPIDLs: TCommonPIDLList;
    FSpecialFolderPhysicalPIDL: TCommonPIDLList;
    FSpecialFolderPhysicalPath: {$IFDEF TNTSUPPORT}TTntStringList{$ELSE}TStringList{$ENDIF};

  protected
    function ChangeInSpecialFolder(PIDL: PItemIDList): Integer;
    procedure Execute; override;
    function GenerateVirtualFolderPathPIDL(PhysicalPIDL: PItemIdList; RegisteredSpecialFolderIndex: Integer; APIDLMgr: TCommonPIDLManager): PItemIDList;
    function PathToPIDL(APath: WideString): PItemIDList;

    property SpecialFolderVirtualPIDLs: TCommonPIDLList read FSpecialFolderVirtualPIDLs write FSpecialFolderVirtualPIDLs;
    property SpecialFolderPhysicalPIDL: TCommonPIDLList read FSpecialFolderPhysicalPIDL write FSpecialFolderPhysicalPIDL;
    property SpecialFolderPhysicalPath: {$IFDEF TNTSUPPORT}TTntStringList{$ELSE}TStringList{$ENDIF} read FSpecialFolderPhysicalPath write FSpecialFolderPhysicalPath;
  public
    constructor Create(CreateSuspended: Boolean; AChangeNotifier: TVirtualChangeNotifier); reintroduce; virtual;
    destructor Destroy; override;

    procedure RemoveEventFromWatchArray(var WatchArray: TKernelWatchRec; EventIndex: Integer);
    procedure TriggerEvent;

    property ChangeNotifier: TVirtualChangeNotifier read FChangeNotifier;
    property KernelChangeEvent: THandle read FKernelChangeEvent write FKernelChangeEvent;
  end;

  // Class that encapsulates a particular controls notification attributes.  These
  // objects are held in the TVirtualChangeNotifier.ControlList.
  TVirtualChangeControl = class
  private
    FShellChangeRegistered: Boolean;
    FKernelChangeRegistered: Boolean;
    FControl: TWinControl;
    FWatchFolder: WideString; // The folder that the Kernel Notification system is watching for a change
    FNotifyEvents: TVirtualKernelNotifyEvents; // Events that the Kernel Notification will trigger on
    procedure SetWatchFolder(const Value: WideString);
    function GetIsRegistered: Boolean;
  public
    function MapNotifyEvents: Longword;  // Maps the TVirtualKernelNotifyEvents to the API Flags

    property Control: TWinControl read FControl write FControl;
    property IsRegistered: Boolean read GetIsRegistered;
    property KernelChangeRegistered: Boolean read FKernelChangeRegistered write FKernelChangeRegistered;
    property NotifyEvents: TVirtualKernelNotifyEvents read FNotifyEvents write FNotifyEvents;
    property ShellChangeRegistered: Boolean read FShellChangeRegistered write FShellChangeRegistered;
    property WatchFolder: WideString read FWatchFolder write SetWatchFolder;
  end;

  TVirtualChangeNotifier = class(TInterfacedObject, IVirtualChangeNotifier)
  private
    FControlList: TThreadList;
    FKernelChangeThread: TVirtualKernelChangeThread;
    FShellChangeThread: TVirtualShellChangeThread;
    FChangeDispatchThread: TVirtualChangeDispatchThread;
    FListener: HWND;
    FSpecialFolderRegisterLock: TRTLCriticalSection;
    FPIDLMgr: TCommonPIDLManager;
    FListenerWndProcStub: Pointer;
    FIDCounter: Cardinal;
    function GetIDCounter: Cardinal;
    function GetKernelChangeThread: TVirtualKernelChangeThread;
    function GetShellChangeThread: TVirtualShellChangeThread;
    function GetChangeDispatchThead: TVirtualChangeDispatchThread;
    function GetFilterEvents: Boolean;
    procedure SetFilterEvents(const Value: Boolean);
    function GetMapVirtualFolders: Boolean;
    procedure SetMapVirtualFolders(const Value: Boolean);
  protected
    procedure CheckForAutoRelease;
    function FindControlIndex(const Control: TVirtualChangeControl): integer;
    function FindRegisteredControl(const Control: TWinControl): TVirtualChangeControl;
    procedure FreeShellNotifyThread;
    procedure FreeKernelNotifyThread;
    procedure FreeChangeDispatchThread;
    procedure ListenerWndProc(var Msg: TMessage);

    property ChangeDispatchThread: TVirtualChangeDispatchThread read GetChangeDispatchThead;
    property ControlList: TThreadList read FControlList write FControlList;
    property IDCounter: Cardinal read GetIDCounter;
    property Listener: hWnd read FListener write FListener;
    property ListenerWndProcStub: Pointer read FListenerWndProcStub write FListenerWndProcStub;
    property KernelChangeThread: TVirtualKernelChangeThread read GetKernelChangeThread;
    property PIDLMgr: TCommonPIDLManager read FPIDLMgr write FPIDLMgr;
    property ShellChangeThread: TVirtualShellChangeThread read GetShellChangeThread;
    property SpecialFolderRegisterLock: TRTLCriticalSection read FSpecialFolderRegisterLock write FSpecialFolderRegisterLock;

  public
    constructor Create;
    destructor Destroy; override;

    procedure AddEvent(ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIdList; APIDLMgr: TCommonPIDLManager);
    procedure LockNotifier;
    function NotifyWatchFolder(Control: TWinControl; WatchFolder: WideString): Boolean;
    procedure PostShellNotifyEvent(NotifyType: LPARAM; PIDL1, PIDL2: PItemIDList);
    function RegisterKernelChangeNotify(Control: TWinControl; NotifyEvents: TVirtualKernelNotifyEvents): Boolean;
    procedure RegisterKernelSpecialFolderWatch(SpecialFolder: Longword); // Use the SHGetSpecialFolder CSIDL_xxx constants
    function RegisterShellChangeNotify(Control: TWinControl): Boolean;
    procedure StripDuplicates(List: TList);
    procedure UnLockNotifier;
    function UnRegisterKernelChangeNotify(Control: TWinControl): Boolean;
    function UnRegisterShellChangeNotify(Control: TWinControl): Boolean;
    procedure UnRegisterChangeNotify(Control: TWinControl);
    procedure UnRegisterAllNotify;

    property FilterEvents: Boolean read GetFilterEvents write SetFilterEvents;
    property MapVirtualFolders: Boolean read GetMapVirtualFolders write SetMapVirtualFolders;
  end;

  IVirtualShellNotify = interface
  ['{86888DA6-8429-4A7F-AC9C-9A9EB1F08E1A}']
    function GetOkToShellNotifyDispatch: Boolean;
    procedure Notify(var Msg: TMessage);
    property OkToShellNotifyDispatch: Boolean read GetOkToShellNotifyDispatch;
  end;

  TShellNotifyManager = class
  private
    FEventList: TThreadList;
    FStub: ICallbackStub;
    FTimerID: Integer;
    FExplorerWndList: TThreadList;
  protected
    function FindExplorerWnd(ExplorerWnd: TWinControl): Integer;
    procedure ClearEventList;

    procedure EndTimer;
    procedure StartTimer;
    procedure Timer(HWnd: HWND; Msg: UINT; idEvent: UINT; dwTime: DWORD); stdcall;
    property ExplorerWndList: TThreadList read FExplorerWndList write FExplorerWndList;
    property Stub: ICallbackStub read FStub write FStub;
    property TimerID: Integer read FTimerID write FTimerID;
    property EventList: TThreadList read FEventList write FEventList;
  public
    constructor Create;
    destructor Destroy; override;

    function OkToDispatch: Boolean;
    procedure ReDispatchShellNotify(Event: TVirtualShellEventList);
    procedure RegisterExplorerWnd(ExplorerWnd: TWinControl);
    procedure UnRegisterExplorerWnd(ExplorerWnd: TWinControl);
  end;



function VirtualShellNotifyEventToStr(ShellNotifyEvent: TVirtualShellNotifyEvent): WideString;
function FreeSpaceNotifyToDrive(dwWord: DWORD): WideChar;
function ShellEventSort(Item1, Item2: Pointer): Integer;

function ChangeNotifier: IVirtualChangeNotifier;

var
{$IFDEF VIRTUALNOTIFYDEBUG}
  NotifyDebug: TVirtualNotifyDebug;
{$ENDIF}
  VirtualShellNotifyRefreshRate: Integer = 250;  // milliseconds
  ShellNotifyManager: TShellNotifyManager = nil;

implementation

uses
  MPShellTypes,
  MPShellUtilities;
type
  TShellILIsEqual = function(PIDL1: PItemIDList; PIDL2: PItemIDList): LongBool; stdcall;
  TShellILIsParent = function(PIDL1: PItemIDList; PIDL2: PItemIDList; ImmediateParent: Boolean): LongBool; stdcall;

var
  ShellILIsEqual: TShellILIsEqual = nil;
  ShellILIsParent: TShellILIsParent = nil;
  SHChangeNotifyRegister: function(Handle: hWnd; dwFlags: DWORD; wEventMask: ULONG;
    uMsg: UINT; cItems: DWORD; var NotifyRegister: TNotifyRegister): THandle; stdcall;
  SHChangeNotifyDeRegister: function(hNotify: THandle): BOOL; stdcall;
  SHChangeNotificationLock: function (hMemoryMap: THandle; dwProcessID: DWORD;
    var lppidls: PShellNotifyRec; var lpwEventId: DWORD): THandle; stdcall;
  SHChangeNotificationUnlock: function(hLock: THandle): BOOL; stdcall;

  VirtualChangeNotifier: IVirtualChangeNotifier = nil;   // Global ChangeNotifier interface
  Malloc: IMalloc; // Global Memory Allocator

function ChangeNotifier: IVirtualChangeNotifier;
begin
  if not Assigned(VirtualChangeNotifier) then
    VirtualChangeNotifier := TVirtualChangeNotifier.Create as IVirtualChangeNotifier;
  Result := VirtualChangeNotifier
end;

function FreeSpaceNotifyToDrive(dwWord: DWORD): WideChar;
// Converts the DWORD sent from a FreeSpace notification to a Drive Letter
begin
  if dwWord > 0 then
  begin
    Result := 'a';
    while dwWord and $01 = 0 do
    begin
      Result := WideChar( Ord(Result) + 1);
      dwWord := dwWord shr 1;
    end;
  end else
    Result := ' ';
end;

function VirtualShellNotifyEventToStr(ShellNotifyEvent: TVirtualShellNotifyEvent): WideString;
begin
  case ShellNotifyEvent of
    vsneAssoccChanged: Result := SHELL_NOTIFY_EVENTS[0];
    vsneAttributes: Result := SHELL_NOTIFY_EVENTS[1];
    vsneCreate: Result := SHELL_NOTIFY_EVENTS[2];
    vsneDelete: Result := SHELL_NOTIFY_EVENTS[3];
    vsneDriveAdd: Result := SHELL_NOTIFY_EVENTS[4];
    vsneDriveAddGUI: Result := SHELL_NOTIFY_EVENTS[5];
    vsneDriveRemoved: Result := SHELL_NOTIFY_EVENTS[6];
    vsneFreeSpace: Result := SHELL_NOTIFY_EVENTS[7];
    vsneMediaInserted: Result := SHELL_NOTIFY_EVENTS[8];
    vsneMediaRemoved: Result := SHELL_NOTIFY_EVENTS[9];
    vsneMkDir: Result := SHELL_NOTIFY_EVENTS[10];
    vsneNetShare: Result := SHELL_NOTIFY_EVENTS[11];
    vsneNetUnShare: Result := SHELL_NOTIFY_EVENTS[12];
    vsneRenameFolder: Result := SHELL_NOTIFY_EVENTS[13];
    vsneRenameItem: Result := SHELL_NOTIFY_EVENTS[14];
    vsneRmDir: Result := SHELL_NOTIFY_EVENTS[15];
    vsneServerDisconnect: Result := SHELL_NOTIFY_EVENTS[16];
    vsneUpdateDir: Result := SHELL_NOTIFY_EVENTS[17];
    vsneUpdateImage: Result := SHELL_NOTIFY_EVENTS[18];
    vsneUpdateItem: Result := SHELL_NOTIFY_EVENTS[19];
  end
end;

function ILIsEqual(PIDL1: PItemIDList; PIDL2: PItemIDList): LongBool;
{ Wrapper around undocumented ILIsEqual function.  It can't take nil parameters }
begin
  if Assigned(PIDL1) and Assigned(PIDL2) then
    Result := ShellILIsEqual(PIDL1, PIDL2)
  else
    Result := False
end;

function ILIsParent(PIDL1: PItemIDList; PIDL2: PItemIDList; ImmediateParent: LongBool): LongBool;
{ Wrapper around undocumented ILIsParent function.  It can't take nil parameters }
begin
  if Assigned(PIDL1) and Assigned(PIDL2) then
    Result := ShellILIsParent(PIDL1, PIDL2, ImmediateParent)
  else
    Result := False
end;


function ShellEventSort(Item1, Item2: Pointer): Integer;
begin
  Result := 0;
  if Assigned(Item1) and Assigned(Item2) then
  begin
    Result := Ord(TVirtualShellEvent( Item1).ShellNotifyEvent) - Ord(TVirtualShellEvent( Item2).ShellNotifyEvent)
  end
end;

{ TVirtualShellEvent }

function TVirtualShellEvent.CopyPIDL(APIDL: PItemIDList): PItemIDList;
var
  Size: integer;
begin
  if Assigned(APIDL) then
  begin
    Size := PIDLSize(APIDL);
    Result := Malloc.Alloc(Size);
    if Result <> nil then
      CopyMemory(Result, APIDL, Size);
  end else
    Result := nil
end;

constructor TVirtualShellEvent.Create(AShellNotifyEvent: TVirtualShellNotifyEvent;
  aPIDL1, aPIDL2: PItemIDList; ADoubleWord1, ADoubleWord2: DWORD;
  IsInvalidNamespace: Boolean);
begin
  ParentPIDL1 := StripLastID(CopyPIDL(aPIDL1));
  ParentPIDL2 := StripLastID(CopyPIDL(aPIDL2));
  FPIDL1 := CopyPIDL(aPIDL1);
  FPIDL2 := CopyPIDL(aPIDL2);
  FShellNotifyEvent := AShellNotifyEvent;
  DoubleWord1 := ADoubleWord1;
  DoubleWord2 := ADoubleWord2;
  InvalidNamespace := IsInvalidNamespace;
  {$IFDEF VIRTUALNOTIFYDEBUG}
  NotifyDebug.EventObjects  := NotifyDebug.EventObjects + 1
  {$ENDIF}
end;

destructor TVirtualShellEvent.Destroy;
begin
  if FreeContentsOnDestroy then
  begin
    if Assigned(ParentPIDL1) then
      Malloc.Free(ParentPIDL1);
    if Assigned(ParentPIDL2) then
      Malloc.Free(ParentPIDL2);
    if Assigned(PIDL1) then
      Malloc.Free(PIDL1);
    if Assigned(PIDL2) then
      Malloc.Free(PIDL2);
  end;
  {$IFDEF VIRTUALNOTIFYDEBUG}
  NotifyDebug.EventObjects  := NotifyDebug.EventObjects - 1;
  {$ENDIF}
  inherited;
end;

function TVirtualShellEvent.NextID(APIDL: PItemIDList): PItemIDList;
begin
  Result := APIDL;
  if Assigned(APIDL) then
    Inc(PAnsiChar(Result), APIDL^.mkid.cb)
end;

function TVirtualShellEvent.PIDLSize(APIDL: PItemIDList): integer;
begin
  Result := 0;
  if Assigned(APIDL) then
  begin
    Result := SizeOf( Word);  // add the null terminating Word
    while APIDL.mkid.cb <> 0 do
    begin
      Result := Result + APIDL.mkid.cb;
      APIDL := NextID(APIDL);
    end;
  end
end;

function TVirtualShellEvent.StripLastID(APIDL: PItemIDList): PItemIDList;
var
  Head, Tail: PItemIDList;
begin
  Result := APIDL;
  if Assigned(APIDL) then
  begin
    { Strip off the last ID, which represents the new filename }
    Head := APIDL;
    Tail := Head;
    while Tail.mkid.cb > 0 do
    begin
      Inc(PAnsiChar( Tail), Head.mkid.cb);
      if Tail.mkid.cb > 0 then
        Head := Tail
      else begin
        Head.mkid.cb := 0
      end
    end
  end
end;

{ TVirtualShellEventList }

constructor TVirtualShellEventList.Create;
var
  List: TList;
begin
  inherited;
  List := LockList;
  try
    List.Capacity := 50;
  finally
    UnLockList
  end;
  {$IFDEF VIRTUALNOTIFYDEBUG}
  NotifyDebug.EventListObjects  := NotifyDebug.EventListObjects + 1
  {$ENDIF}
end;

destructor TVirtualShellEventList.Destroy;
begin
  Clear;
  inherited;
  {$IFDEF VIRTUALNOTIFYDEBUG}
  NotifyDebug.EventListObjects  := NotifyDebug.EventListObjects - 1
  {$ENDIF}
end;

procedure TVirtualShellEventList.Clear;
var
  i: integer;
  List: TList;
begin
  List := LockList;
  try
    for i := 0 to List.Count - 1 do
    begin
      // We are freeing the content the item done not need to worry about it
      TVirtualShellEvent(List.Items[i]).FreeContentsOnDestroy := False;
      if Assigned(TVirtualShellEvent(List.Items[i]).ParentPIDL1) then
        Malloc.Free(TVirtualShellEvent(List.Items[i]).ParentPIDL1);
      if Assigned(TVirtualShellEvent(List.Items[i]).ParentPIDL2) then
        Malloc.Free(TVirtualShellEvent(List.Items[i]).ParentPIDL2);
      if Assigned(TVirtualShellEvent(List.Items[i]).PIDL1) then
        Malloc.Free(TVirtualShellEvent(List.Items[i]).PIDL1);
      if Assigned(TVirtualShellEvent(List.Items[i]).PIDL2) then
        Malloc.Free(TVirtualShellEvent(List.Items[i]).PIDL2);
      TVirtualShellEvent(List.Items[i]).Free;
      List.Items[i] := nil;
    end;
  finally
    List.Clear;
    UnLockList;
  end;
end;

{ TVirtualReferenceCountedList }

procedure TVirtualReferenceCountedList.AddRef;
begin
  InterlockedIncrement(FRefCount)
end;

procedure TVirtualReferenceCountedList.Clear;
begin

end;

procedure TVirtualReferenceCountedList.Release;
begin
  InterlockedDecrement (FRefCount);
  if FRefCount <= 0 then
    Free;
end;

{ TVirtualChangeNotifier }

function TVirtualChangeNotifier.GetIDCounter: Cardinal;
begin
  Result := FIDCounter;
  Inc(FIDCounter);
end;


procedure TVirtualChangeNotifier.AddEvent(
  ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIdList; APIDLMgr: TCommonPIDLManager);
begin
  ChangeDispatchThread.AddEvent(ShellNotifyEvent, PIDL1, PIDL2, APIDLMgr, False)
end;

procedure TVirtualChangeNotifier.CheckForAutoRelease;
begin


 // not RELEASING KernelChangeThread or ShellChangeThread enough

  if Assigned(FKernelChangeThread) then
  begin
    if KernelChangeThread.RefCount = 0 then
      FreeKernelNotifyThread;
  end;
  if Assigned(FShellChangeThread) then
  begin
    if ShellChangeThread.RefCount = 0 then
      FreeShellNotifyThread;
  end;
  if Assigned(FChangeDispatchThread) then
  begin
    if ChangeDispatchThread.RefCount = 0 then
      FreeChangeDispatchThread;
  end
end;

constructor TVirtualChangeNotifier.Create;
begin
  ControlList := TThreadList.Create;
  {$IFNDEF COMPILER_6_UP}
  Listener := Forms.AllocateHWnd(ListenerWndProc);
  {$ELSE}
  Listener := Classes.AllocateHWnd(ListenerWndProc);
  {$ENDIF}
  InitializeCriticalSection(FSpecialFolderRegisterLock);
  PIDLMgr := TCommonPIDLManager.Create;
end;

destructor TVirtualChangeNotifier.Destroy;
begin
  if Assigned(FKernelChangeThread) then
    Assert(FKernelChangeThread.RefCount = 0, S_KERNELNOTIFERREGISTERED);
  if Assigned(FShellChangeThread) then
    Assert(FShellChangeThread.RefCount = 0, S_SHELLNOTIFERREGISTERED);
  if Assigned(FChangeDispatchThread) then
    Assert(FChangeDispatchThread.RefCount = 0, S_SHELLNOTIFERDISPATCHTHREAD);
  ControlList.Free;
  if Listener <> 0 then
    {$IFNDEF COMPILER_6_UP}
    Forms.DeallocateHWnd(FListener);
    {$ELSE}
    Classes.DeallocateHWnd(FListener);
    {$ENDIF}
  inherited;
  DeleteCriticalSection(FSpecialFolderRegisterLock);
  PIDLMgr.Free;
end;

function TVirtualChangeNotifier.FindControlIndex(const Control: TVirtualChangeControl): integer;
var
  List: TList;
  i: integer;
begin
  Result := -1;
  List := ControlList.LockList;
  try
    for i := 0 to List.Count - 1 do
    begin
      if Control = TVirtualChangeControl(List[i]) then
      begin
        Result := i;
        Exit
      end
    end
  finally
    ControlList.UnLockList
  end
end;

function TVirtualChangeNotifier.FindRegisteredControl(
  const Control: TWinControl): TVirtualChangeControl;
var
  List: TList;
  i: integer;
begin
  Result := nil;
  List := ControlList.LockList;
  try
    for i := 0 to List.Count - 1 do
    begin
      if Control = TVirtualChangeControl(List[i]).Control then
      begin
        Result := TVirtualChangeControl(List[i]);
        Exit
      end
    end
  finally
    ControlList.UnLockList
  end
end;

procedure TVirtualChangeNotifier.FreeChangeDispatchThread;
var
  i: Integer;
begin
  if Assigned(FChangeDispatchThread) then
  begin
    try
      if not FChangeDispatchThread.Finished then
      begin
        FChangeDispatchThread.Priority := tpNormal; // D6 lags on shut down with lower priority
        FChangeDispatchThread.Terminate;
        FChangeDispatchThread.TriggerEvent;
        i := 0;
        while not FChangeDispatchThread.Finished do
        begin
          Sleep(THREAD_SHUTDOWN_WAIT_DELAY);
          if i > FORCE_KILL_THREAD_COUNT then
          begin
            ChangeDispatchThread.ForceTerminate;
            Break
          end;
          Inc(i)
        end;
      end;
    finally
      FreeAndNil(FChangeDispatchThread);
    end
  end;
end;

procedure TVirtualChangeNotifier.FreeKernelNotifyThread;
var
  i: Integer;
begin
  if Assigned(FKernelChangeThread) then
  begin
    try
      if not FKernelChangeThread.Finished then
      begin
        FKernelChangeThread.Priority := tpNormal; // D6 lags on shut down with lower priority
        FKernelChangeThread.Terminate;
        FKernelChangeThread.TriggerEvent;
        i := 0;
        while not FKernelChangeThread.Finished do
        begin
          Sleep(THREAD_SHUTDOWN_WAIT_DELAY);
          if i > FORCE_KILL_THREAD_COUNT then
          begin
            KernelChangeThread.ForceTerminate;
            Break
          end;
          Inc(i)
        end
      end;
    finally
      FreeAndNil(FKernelChangeThread);
      ChangeDispatchThread.Release
    end
  end;
end;

procedure TVirtualChangeNotifier.FreeShellNotifyThread;
var
  i: Integer;
begin
  if Assigned(FShellChangeThread) then
  begin
    try
      if not FShellChangeThread.Finished then
      begin
        FShellChangeThread.Priority := tpNormal; // D6 lags on shut down with lower priority
        FShellChangeThread.Terminate;
        PostThreadMessage(FShellChangeThread.ThreadID, WM_SHELLNOTIFYTHREADQUIT, 0, 0);
        i := 0;
        while not FShellChangeThread.Finished do
        begin
          Sleep(THREAD_SHUTDOWN_WAIT_DELAY);
          if i > FORCE_KILL_THREAD_COUNT then
          begin
            ShellChangeThread.ForceTerminate;
            Break
          end;
          Inc(i)
        end;
      end;
    finally
      FreeAndNil(FShellChangeThread);
      ChangeDispatchThread.Release
    end
  end;
end;

function TVirtualChangeNotifier.GetChangeDispatchThead: TVirtualChangeDispatchThread;
begin
  if not Assigned(FChangeDispatchThread) then
  begin
    FChangeDispatchThread := TVirtualChangeDispatchThread.Create(True, Self);
    FChangeDispatchThread.Suspended := False
  end;
  Result := FChangeDispatchThread;
end;

function TVirtualChangeNotifier.GetFilterEvents: Boolean;
begin
  Result := ChangeDispatchThread.FilterEvents
end;

function TVirtualChangeNotifier.GetKernelChangeThread: TVirtualKernelChangeThread;
begin
  if not Assigned(FKernelChangeThread) then
  begin
    // Make sure the dispatch thread is created in the context of the main thread
    if not Assigned(FChangeDispatchThread) then
      ChangeDispatchThread;
    ChangeDispatchThread.AddRef;
    FKernelChangeThread := TVirtualKernelChangeThread.Create(True, Self);
    FKernelChangeThread.Suspended := False
  end;
  Result := FKernelChangeThread;
end;

function TVirtualChangeNotifier.GetMapVirtualFolders: Boolean;
begin
  Result := ShellChangeThread.MapVirtualFolders
end;

function TVirtualChangeNotifier.GetShellChangeThread: TVirtualShellChangeThread;
begin
  if not Assigned(FShellChangeThread) then
  begin
    // Make sure the dispatch thread is created in the context of the main thread
    if not Assigned(FChangeDispatchThread) then
      ChangeDispatchThread;
    ChangeDispatchThread.AddRef;
    FShellChangeThread := TVirtualShellChangeThread.Create(True, Self);
    FShellChangeThread.Suspended := False
  end;
  Result := FShellChangeThread;
end;

procedure TVirtualChangeNotifier.ListenerWndProc(var Msg: TMessage);

       procedure PackMessages(EventList: TVirtualShellEventList);
       // PackMessages Peeks all the WM_SHELLNOTIFY messages out of the Message
       // Queue and combines all like messages
       var
         Msg: TMsg;
         i: integer;
         List, Events: TList;
         RePostQuitCode: Integer;
         RePostQuit: Boolean;
       begin
         Events := EventList.LockList;
         try
           RePostQuit := False;
           RePostQuitCode := 0;
           while PeekMessage(Msg, FListener, WM_SHELLNOTIFY, WM_SHELLNOTIFY, PM_REMOVE) do
           begin
             if Msg.Message = WM_QUIT then
             begin
               RepostQuit := True;
               RePostQuitCode := Msg.wParam;
             end else
             begin
               List := TVirtualShellEventList( Msg.wParam).LockList;
               try
                 for i := 0 to List.Count - 1 do
                   Events.Add(List[i]);
               finally
                 // We have given the events to the EventList so don't free them
                 TVirtualShellEventList( Msg.wParam).Clear;
                 TVirtualShellEventList( Msg.wParam).UnLockList;
                 // tried to just free but caused problems. Allow each control to
                 // simpify its list
                 TVirtualShellEventList( Msg.wParam).Release;
               end
             end
           end;
           if RepostQuit then
             PostQuitMessage(RePostQuitCode)
         finally
           StripDuplicates(Events);
           Events.Pack;
           EventList.UnLockList;
         end
       end;

var
  List: TList;
  i: integer;
  Control: TWinControl;
  TempList: TVirtualShellEventList;
begin
    case Msg.Msg of
  WM_NCCREATE: Msg.Result := 1;
  WM_SHELLNOTIFY:
    begin
      TempList := TVirtualShellEventList(Msg.wParam);
      if Assigned(TempList) then
      begin
        // Had some strange AV's that may be related to this call
        // See if this fixes it. 1/22/03
  //      PackMessages(TempList);
        List := ControlList.LockList;
        try
          TempList.ID := IDCounter;
          Inc(TempList.FRefCount, List.Count);
          for i := 0 to List.Count - 1 do
          begin
            Control := TVirtualChangeControl(List[i]).Control;
            if Control.HandleAllocated then
            begin
              if not PostMessage(Control.Handle, WM_SHELLNOTIFY, WPARAM(TempList), 0) then
                TempList.Release
              end else
            TempList.Release;
          end;
        finally
          ControlList.UnlockList;
        end;
        TempList.Release;
      end
    end;
  else
    with Msg do
      Result := DefWindowProc(Listener, Msg, wParam, lParam);
  end
end;

procedure TVirtualChangeNotifier.LockNotifier;
begin
  // This locks the list so the dispatch thread is blocked so it can't call PostMesasge
  // this allows us to clear message queue's before unregistering a control
   ControlList.LockList;
end;

function TVirtualChangeNotifier.NotifyWatchFolder(Control: TWinControl;
  WatchFolder: WideString): Boolean;
var
  ChangeControl: TVirtualChangeControl;
begin
  ChangeControl := FindRegisteredControl(Control);
  if Assigned(ChangeControl) then
  begin
    if ChangeControl.WatchFolder <> WatchFolder then
    begin
      ChangeControl.WatchFolder := WatchFolder;
      KernelChangeThread.TriggerEvent;
    end;
    Result := True
  end else
    Result := False;
end;

procedure TVirtualChangeNotifier.PostShellNotifyEvent(NotifyType: LPARAM; PIDL1, PIDL2: PItemIDList);
// NotifyType is one of the SHCNE_xxx constants from SHChangeNotify
var
  SNR: PShellNotifyRec;
begin
  if Assigned(FShellChangeThread) then
  begin
    New(SNR);
    SNR.PIDL1 := PIDLMgr.CopyPIDL(PIDL1);
    SNR.PIDL2 := PIDLMgr.CopyPIDL(PIDL2);
    PostMessage(FShellChangeThread.NotifyWindowHandle, WM_CHANGENOTIFY_CUSTOM, WPARAM(SNR), NotifyType);
  end
end;

function TVirtualChangeNotifier.RegisterKernelChangeNotify(Control: TWinControl;
  NotifyEvents: TVirtualKernelNotifyEvents): Boolean;
// Registers the Control with the Kernel Change Notification System
var
  ChangeControl: TVirtualChangeControl;
  Index: integer;
  List: TList;
  DoTrigger: Boolean;
begin
  DoTrigger := False;
  List := ControlList.LockList;
  try
    ChangeControl := FindRegisteredControl(Control);
    // Control is already in the list
    if Assigned(ChangeControl) then
    begin
      // See if it is already assigned the Kernel Notifier
      if not ChangeControl.KernelChangeRegistered or (ChangeControl.NotifyEvents <> NotifyEvents) then
      begin
        // No it is not registered with the Kernel notifier so do so
        ChangeControl.KernelChangeRegistered := True;
        ChangeControl.NotifyEvents := NotifyEvents;
       // Notify the thread there is a change in the contol list;
        KernelChangeThread.AddRef;
        DoTrigger := True;
        Result := True;
      end else
        // Yes it is already resistered
        Result := True
    end
    else begin
      // Need to create a new ChangeControl
      ChangeControl := TVirtualChangeControl.Create;
      ChangeControl.Control := Control;

      Index := List.Add(ChangeControl);
      Result := Index > -1;
      if Result then
      begin
        ChangeControl.KernelChangeRegistered := True;
        KernelChangeThread.AddRef;
        ChangeControl.NotifyEvents := NotifyEvents;
        // Notify the thread there is a change in the contol list;
        DoTrigger := True;
      end else
      begin
        // Had an error adding it to the list
        ChangeControl.Free;
        Result := False
      end
    end
  finally
    ControlList.UnlockList;
    // The Rebuild of the ChangeNotifier list will try to lock the list so
    // do not allow the thread to rebuild this list from within the LockedListBlock
    if DoTrigger then
      KernelChangeThread.TriggerEvent;
  end
end;


procedure TVirtualChangeNotifier.RegisterKernelSpecialFolderWatch(SpecialFolder: Longword);
var
  DeskPIDL, ParentPIDL, PIDL: PItemIDList;
  WS: WideString;
  Desktop, Folder, DeskFolder: IShellFolder;
  PIDLMgr: TCommonPIDLManager;
  StrRet: TStrRet;
begin
  Assert(KernelChangeThread.RefCount > 0, S_KERNELSPECIALFOLDERWATCH);

  EnterCriticalSection(FSpecialFolderRegisterLock);
  try
    SHGetSpecialFolderLocation(0, SpecialFolder, PIDL);
    if Assigned(PIDL) then
    begin
      PIDLMgr := TCommonPIDLManager.Create;
      SHGetDesktopFolder(Desktop);
      if PIDLMgr.IDCount(PIDL) < 2 then
        Folder := Desktop
      else begin
        SHGetDesktopFolder(Desktop);
        ParentPIDL := PIDLMgr.StripLastID(PIDLMgr.CopyPIDL(PIDL));
        Desktop.BindToObject(ParentPIDL, nil, IID_IShellFolder, Pointer(Folder));
        PIDLMgr.FreePIDL(ParentPIDL);
      end;
      if Assigned(Folder) then
      begin
        if PIDL.mkid.cb = 0 then
        begin
          // Virtual Desktop on NT4 and Win95 does not return the path with
          // SHGDN_FORPARSING for the virtual desktop
          SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, DeskPIDL);
          ParentPIDL := PIDLMgr.StripLastID(PIDLMgr.CopyPIDL(DeskPIDL));
          Desktop.BindToObject(ParentPIDL, nil, IID_IShellFolder, Pointer(DeskFolder));
          PIDLMgr.FreePIDL(ParentPIDL);
          DeskFolder.GetDisplayNameOf(PIDLMgr.GetPointerToLastID(DeskPIDL), SHGDN_FORPARSING, StrRet);
          WS := StrRetToStr(StrRet, PIDLMgr.GetPointerToLastID(DeskPIDL));
          PIDLMgr.FreePIDL(DeskPIDL)
        end else
        begin
          Folder.GetDisplayNameOf(PIDLMgr.GetPointerToLastID(PIDL), SHGDN_FORPARSING, StrRet);
          WS := StrRetToStr(StrRet, PIDLMgr.GetPointerToLastID(PIDL));
        end;
        KernelChangeThread.SpecialFolderPhysicalPath.Add(WS);
        KernelChangeThread.SpecialFolderPhysicalPIDL.Add(KernelChangeThread.PathToPIDL(WS));
        // This only works for the CSIDL_DESKTOP folder.  The PIDL returned for others
        // is NOT a virtual folder
        if SpecialFolder = CSIDL_DESKTOP then
          KernelChangeThread.SpecialFolderVirtualPIDLs.Add(PIDL)
        else
        if SpecialFolder = CSIDL_PERSONAL then
        begin
          KernelChangeThread.SpecialFolderVirtualPIDLs.Add(GetMyDocumentsVirtualFolder);
          PIDLMgr.FreePIDL(PIDL);
        end else
        begin
          KernelChangeThread.SpecialFolderVirtualPIDLs.Add(nil);
          PIDLMgr.FreePIDL(PIDL);
        end;
        KernelChangeThread.TriggerEvent;
      end;
      PIDLMgr.Free;
    end
  finally
    LeaveCriticalSection(FSpecialFolderRegisterLock);
  end
end;

function TVirtualChangeNotifier.RegisterShellChangeNotify(Control: TWinControl): Boolean;
// Registers the Control with the Shell Change Notification System
var
  ChangeControl: TVirtualChangeControl;
  Index: integer;
  List: TList;
begin
  Result := False;
  List := ControlList.LockList;
  try
    ChangeControl := FindRegisteredControl(Control);
    // Control is already in the list
    if Assigned(ChangeControl) then
    begin
      // See if it is already assigned the Shell Notifier
      if not ChangeControl.ShellChangeRegistered then
      begin
        // No it is not registered with the Shell notifier so do so
        ChangeControl.ShellChangeRegistered := True;
       // Notify the thread there is a change in the contol list;
       ShellChangeThread.AddRef;
      end else
        // Yes it is already resistered
        Result := True
    end
    else begin
      // Need to create a new ChangeContol
      ChangeControl := TVirtualChangeControl.Create;
      ChangeControl.Control := Control;

      Index := List.Add(ChangeControl);
      Result := Index > -1;
      if Result then
      begin
        ChangeControl.ShellChangeRegistered := True;
        // Notify the thread there is a change in the contol list;
        ShellChangeThread.AddRef;     
      end else
      begin
        // Had an error adding it to the list
        ChangeControl.Free;
        Result := False
      end
    end
  finally
    ControlList.UnlockList
  end;
end;

procedure TVirtualChangeNotifier.SetFilterEvents(const Value: Boolean);
begin
  ChangeDispatchThread.FilterEvents := Value
end;

procedure TVirtualChangeNotifier.SetMapVirtualFolders(
  const Value: Boolean);
begin
  ShellChangeThread.MapVirtualFolders := Value
end;

procedure TVirtualChangeNotifier.StripDuplicates(List: TList);
  // this simply runs the N length list N times looking for duplicates.  It quickly
  // reduces its search time as if finds duplicates buy freeing and setting the duplicate
  // to nil.  It only checks the first PIDL in the Event object.
  // I tried a while loop and packed during the run and it was sloooooooow
  // It also eliminates reduncany by getting the highest common denominator in the
  // path structure
  var
    i, j: integer;
  begin
    for i := 0 to List.Count - 1 do
    begin
      for j := List.Count - 1 downto 0 do
        if (j <> i) and Assigned(List[i]) and Assigned(List[j]) then
        begin
          if ILIsEqual( TVirtualShellEvent(List[i]).PIDL1, TVirtualShellEvent(List[j]).PIDL1) then
          begin
            TObject(List[j]).Free;
            List[j] := nil
          end else
          if ILIsParent( TVirtualShellEvent(List[i]).PIDL1, TVirtualShellEvent(List[j]).PIDL1, False) then
          begin
            TObject(List[j]).Free;
            List[j] := nil
          end else
          if ILIsParent( TVirtualShellEvent(List[j]).PIDL1, TVirtualShellEvent(List[i]).PIDL1, False) then
          begin
            TObject(List[i]).Free;
            List[i] := nil
          end
        end
    end;
    // Get rid of the nil pointers
    List.Pack;
end;

procedure TVirtualChangeNotifier.UnLockNotifier;
begin
  ControlList.UnLockList;
end;

procedure TVirtualChangeNotifier.UnRegisterAllNotify;
var
  List: TList;
  i: integer;
  Controls: array of TWinControl;
begin
  // We can not have the list locked when we UnRegister a notify (Kernel mainly)
  // because when the thread is released it may try to rebuild the Notify Handle
  // list and in doing that will try to lock the same list, ending in deadlock
  List := ControlList.LockList;
  try
    SetLength(Controls, List.Count);
    for i := List.Count - 1 downto 0 do
      Controls[i] := TVirtualChangeControl(List[i]).Control
  finally
    ControlList.UnLockList;
  end;
  for i := 0 to Length(Controls) - 1 do
    UnRegisterChangeNotify( Controls[i])
end;

procedure TVirtualChangeNotifier.UnRegisterChangeNotify(Control: TWinControl);
begin
  UnRegisterKernelChangeNotify(Control);
  UnRegisterShellChangeNotify(Control);
end;

function TVirtualChangeNotifier.UnRegisterKernelChangeNotify(
  Control: TWinControl): Boolean;
var
  ChangeControl: TVirtualChangeControl;
  Index: integer;
  List: TList;
  DoTrigger: Boolean;
begin
  DoTrigger := False;
  List := ControlList.LockList;
  try
    ChangeControl := FindRegisteredControl(Control);
    if Assigned(ChangeControl) then
    begin
      if ChangeControl.KernelChangeRegistered then
      begin
        // Control is in the ControlList so Unregister it with the Kernel Change Notify
        ChangeControl.KernelChangeRegistered := False;
        // If the control is not registered with anyone then delete it
        if not ChangeControl.IsRegistered then
        begin
          Index := FindControlIndex(ChangeControl);
          // Remove it from the list
          List.Delete(Index);
          // Free the Control Item
          ChangeControl.Free;
        end;
        KernelChangeThread.Release;
        Result := True;
        DoTrigger := True;
      end else
        Result := True
    end else
      Result := False // Can't unregister a control that is not in the list
  finally
    ControlList.UnlockList;
    // The Rebuild of the ChangeNotifier list will try to lock the list so
    // do not allow the thread to rebuild this list from within the LockedListBlock
    if DoTrigger then
      KernelChangeThread.TriggerEvent;
  end;
  CheckForAutoRelease
end;

function TVirtualChangeNotifier.UnRegisterShellChangeNotify(
  Control: TWinControl): Boolean;
var
  ChangeControl: TVirtualChangeControl;
  Index: integer;
  List: TList;
begin
  List := ControlList.LockList;
  try
    ChangeControl := FindRegisteredControl(Control);
    if Assigned(ChangeControl) then
    begin
      if ChangeControl.ShellChangeRegistered then
      begin
        // Control is in the ControlList so Unregister it with the Kernel Change Notify
        ChangeControl.ShellChangeRegistered := False;
        // If the control is not registered with anyone then delete it
        if not ChangeControl.IsRegistered then
        begin
          Index := FindControlIndex(ChangeControl);
          // Remove it from the list
          List.Delete(Index);
          // Free the Control Item
          ChangeControl.Free;
        end;
        ShellChangeThread.Release;
        Result := True;
      end else
        Result := True
    end else
      Result := False // Can't unregister a control that is not in the list
  finally
    ControlList.UnlockList
  end;
  CheckForAutoRelease
end;

{ TVirtualChangeControl }

function TVirtualChangeControl.GetIsRegistered: Boolean;
begin
  Result := KernelChangeRegistered or ShellChangeRegistered
end;

function TVirtualChangeControl.MapNotifyEvents: Longword;
begin
  Result := 0;
  if vkneFileName in NotifyEvents then
    Result := Result or FILE_NOTIFY_CHANGE_FILE_NAME;
  if vkneDirName in NotifyEvents then
    Result := Result or FILE_NOTIFY_CHANGE_DIR_NAME;
  if vkneAttributes in NotifyEvents then
    Result := Result or FILE_NOTIFY_CHANGE_ATTRIBUTES;
  if vkneSize in NotifyEvents then
    Result := Result or FILE_NOTIFY_CHANGE_SIZE;
  if vkneLastWrite in NotifyEvents then
    Result := Result or FILE_NOTIFY_CHANGE_LAST_WRITE;

  // Windows 95 can't deal with these. Need to check Win98/ME
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    if vkneLastAccess in NotifyEvents then
      Result := Result or FILE_NOTIFY_CHANGE_LAST_ACCESS;
    if vkneCreation in NotifyEvents then
      Result := Result or FILE_NOTIFY_CHANGE_CREATION;
    if vkneSecurity in NotifyEvents then
      Result := Result or FILE_NOTIFY_CHANGE_SECURITY;
  end
end;

procedure TVirtualChangeControl.SetWatchFolder(const Value: WideString);
begin
  Assert(KernelChangeRegistered, 'Attempting to change WatchFolder with out registering a Kernel notifier in TVirtualChangeNotifier class');
  if KernelChangeRegistered then
    FWatchFolder := Value
  else
    FWatchFolder := ''
end;

{ TVirtualKernelChangeThread }

function TVirtualKernelChangeThread.ChangeInSpecialFolder(
  PIDL: PItemIDList): Integer;
var
  i: Integer;
begin
  Result := -1;
  i := 0;
  while (Result = -1) and (i < SpecialFolderPhysicalPIDL.Count) do
  begin
    if ILIsParent(SpecialFolderPhysicalPIDL[i], PIDL, False) then
      Result := i;
    Inc(i)
  end
end;

constructor TVirtualKernelChangeThread.Create(CreateSuspended: Boolean;
  AChangeNotifier: TVirtualChangeNotifier);
begin
  inherited Create(CreateSuspended);
  Priority := tpNormal;
  FChangeNotifier := AChangeNotifier;
  // Create an event object to break the ChangeNotifyFree on demand
  // Create with Manual Reset, and not signaled (fired)
  KernelChangeEvent := CreateEvent(nil, True, False, nil);
  SpecialFolderVirtualPIDLs := TCommonPIDLList.Create;
  SpecialFolderPhysicalPIDL := TCommonPIDLList.Create;
  {$IFDEF TNTSUPPORT}
  SpecialFolderPhysicalPath := TTntStringList.Create;
  {$ELSE}
  SpecialFolderPhysicalPath := TStringList.Create;
  {$ENDIF}
end;

destructor TVirtualKernelChangeThread.Destroy;
begin
  inherited;
  if KernelChangeEvent <> 0 then
    CloseHandle(KernelChangeEvent);
  KernelChangeEvent := 0;
  SpecialFolderVirtualPIDLs.Free;
  SpecialFolderPhysicalPIDL.Free;
  SpecialFolderPhysicalPath.Free;
end;

procedure TVirtualKernelChangeThread.Execute;

    function RebuildWatchNotify(var RegisteredCount: Integer; APIDLMgr: TCommonPIDLManager): TKernelWatchRec;
    const
      Special = FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or FILE_NOTIFY_CHANGE_ATTRIBUTES or
        FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE;
    var
      List: TList;
      i: integer;
      ChangeControl: TVirtualChangeControl;
      S: AnsiString;
      HandleIndex: integer;
      PIDL: PItemIDList;
    begin
      EnterCriticalSection(ChangeNotifier.FSpecialFolderRegisterLock);
      try
        HandleIndex := 0;
        RegisteredCount := 1;  // Always have the KernelChangeEvent
        List := ChangeNotifier.ControlList.LockList;
        try
          SetLength(Result.Handles, MAXIMUM_WAIT_OBJECTS);
          SetLength(Result.NSs, MAXIMUM_WAIT_OBJECTS);
          // Our safefy valve to release the WaitForMultipleObject
          Result.Handles[0] := KernelChangeEvent;
          Result.NSs[0] := nil;
          HandleIndex := 1;

          // These are the special folders that are difficult to watch
          for i := 0 to SpecialFolderPhysicalPath.Count - 1 do
          begin
            if Win32Platform = VER_PLATFORM_WIN32_NT then
              {$IFDEF TNTSUPPORT}
              Result.Handles[HandleIndex] := FindFirstChangeNotificationW_MP(
                PWideChar(SpecialFolderPhysicalPath[i]), False, Special)
              {$ELSE}
              Result.Handles[HandleIndex] := FindFirstChangeNotificationW_MP(
                PWideChar(WideString(SpecialFolderPhysicalPath[i])), False, Special)
              {$ENDIF}
            else begin
              S := SpecialFolderPhysicalPath[i];
              Result.Handles[HandleIndex] := FindFirstChangeNotificationA(PAnsiChar(S), False, Special)
            end;
            if Result.Handles[HandleIndex] <> INVALID_HANDLE_VALUE then
            begin
              Result.NSs[HandleIndex] := TChangeNamespace.Create(SpecialFolderPhysicalPIDL[i]);
              if Assigned(Result.NSs[HandleIndex]) then
                Inc(HandleIndex)
              else
                FindCloseChangeNotification(Result.Handles[HandleIndex])
            end
          end;

          // These are the WatchFolders specified by the registered Change Windows
          for i := 0 to List.Count - 1 do
          begin
            ChangeControl := TVirtualChangeControl( List[i]);
            if (ChangeControl.KernelChangeRegistered) then
            begin
              if (ChangeControl.WatchFolder <> '') then
              begin
                if Win32Platform = VER_PLATFORM_WIN32_NT then
                  Result.Handles[HandleIndex] := FindFirstChangeNotificationW_MP(PWideChar(ChangeControl.WatchFolder),
                    False, ChangeControl.MapNotifyEvents)
                else begin
                  S := ChangeControl.WatchFolder;
                  Result.Handles[HandleIndex] := FindFirstChangeNotificationA(PAnsiChar(S), False, ChangeControl.MapNotifyEvents)
                end;
                if Result.Handles[HandleIndex] <> INVALID_HANDLE_VALUE then
                begin
                  PIDL := PathToPIDL(ChangeControl.WatchFolder);
                  if Assigned(PIDL) then
                  begin
                    Result.NSs[HandleIndex] := TChangeNamespace.Create(PIDL);
                    if Assigned(Result.NSs[HandleIndex]) then
                      Inc(HandleIndex)
                    else
                      FindCloseChangeNotification(Result.Handles[HandleIndex])
                  end else
                    FindCloseChangeNotification(Result.Handles[HandleIndex])
                end
              end;
              Inc(RegisteredCount)
            end
          end
        finally
          ChangeNotifier.ControlList.UnlockList;
          SetLength(Result.Handles, HandleIndex);
          SetLength(Result.NSs, HandleIndex);
        end
      finally
        LeaveCriticalSection(ChangeNotifier.FSpecialFolderRegisterLock)
      end
    end;

var
  RunLoop: Boolean;
  WaitIndex, i, RegisteredCount: integer;
  WatchArray: TKernelWatchRec;
  Malloc: IMalloc;
  Index: Integer;
  VPIDL, PIDL: PItemIDList;
  LocalPIDLMgr: TCommonPIDLManager;
  InvalidNamespace: Boolean;
begin
  // MUST be created in context of thread since the PIDL manager retrives an
  // IMalloc interface and we can't use interfaces across threads without
  // marshalling
  LocalPIDLMgr := TCommonPIDLManager.Create;
  try
    SHGetMalloc(Malloc);
    while not Terminated do
    try
      // Reset Flags
      RunLoop := True;
      ResetEvent(KernelChangeEvent);

      WatchArray := RebuildWatchNotify(RegisteredCount, LocalPIDLMgr);

      if RegisteredCount > 0 then
      begin
        while RunLoop and not Terminated do
        begin
          WaitIndex := WaitForMultipleObjects(Length(WatchArray.Handles),
            PWOHandleArray(@WatchArray.Handles[0]), False, INFINITE);
          if not Terminated then
          begin
            InvalidNamespace := False;
            // As long as it is not the Event trigging the Wait keep looping waiting for change notifications
            if WaitIndex - WAIT_OBJECT_0 > 0 then
            begin
              PIDL := LocalPIDLMgr.CopyPIDL(WatchArray.NSs[WaitIndex].AbsolutePIDL);
              if not WatchArray.NSs[WaitIndex].Valid then
                InvalidNamespace := True;

              ChangeNotifier.ChangeDispatchThread.AddEvent(vsneUpdateDir, PIDL, PIDL, LocalPIDLMgr, InvalidNamespace);

              // Generate PIDLs rooted from the Virtual Namespace as well and dispatch them.
              Index := ChangeInSpecialFolder(PIDL);
              if Index > -1 then
              begin
                VPIDL := GenerateVirtualFolderPathPIDL(PIDL, Index, LocalPIDLMgr);
                if Assigned(VPIDL) then
                begin
                  ChangeNotifier.ChangeDispatchThread.AddEvent(vsneUpdateDir, VPIDL, VPIDL, LocalPIDLMgr, InvalidNamespace);
                  LocalPIDLMgr.FreeAndNilPIDL(VPIDL);
                end
              end;
              LocalPIDLMgr.FreeAndNilPIDL(PIDL);
              {$IFDEF VIRTUALNOTIFYDEBUG}
              NotifyDebug.KernelEvents  := NotifyDebug.KernelEvents + 1;
              {$ENDIF}

              if InvalidNamespace then
                RemoveEventFromWatchArray(WatchArray, WaitIndex)
              else
                FindNextChangeNotification(WatchArray.Handles[WaitIndex]);

            end else
              RunLoop := False
          end else
            RunLoop := False
        end;

        // Free all the notification handles
        for i := 1 to Length(WatchArray.Handles) - 1 do
        begin
          FindCloseChangeNotification(WatchArray.Handles[i]);
          WatchArray.NSs[i].Free
        end;

        // Keep the Event handle
        SetLength(WatchArray.Handles, 1);
        SetLength(WatchArray.NSs, 1);
      end
    except
      // catch all exceptions
    end;
  finally
    LocalPIDLMgr.Free;
    Malloc := nil;
  end
end;

function TVirtualKernelChangeThread.GenerateVirtualFolderPathPIDL(
  PhysicalPIDL: PItemIdList; RegisteredSpecialFolderIndex: Integer;
  APIDLMgr: TCommonPIDLManager): PItemIDList;
//
// This MUST be called from within a FSpecialFolderRegisterLock section. Currently
// it is called from the RebuildWatchNotify local function in the Exectute method
// which is wrapped with a Lock
//
// Actually this must be called from with the mentioned block ONLY since the arrays
// may get out of sync if not.
//
var
  Root, i: Integer;
  PIDL: PItemIDList;
begin
  Result := nil;
  if RegisteredSpecialFolderIndex < SpecialFolderPhysicalPIDL.Count then
  begin
    if SpecialFolderVirtualPIDLs[RegisteredSpecialFolderIndex] <> nil then
    begin
      i := 0;
      PIDL := PhysicalPIDL;
      Root := APIDLMgr.IDCount(SpecialFolderPhysicalPIDL[RegisteredSpecialFolderIndex]);
      while Assigned(PIDL) and (i < Root) do
      begin
        PIDL := APIDLMgr.NextID(PIDL);
        Inc(i)
      end;
      if Assigned(PIDL) then
        Result := APIDLMgr.AppendPIDL(SpecialFolderVirtualPIDLs[RegisteredSpecialFolderIndex], PIDL)
    end
  end
end;

function TVirtualKernelChangeThread.PathToPIDL(APath: WideString): PItemIDList;
var
  Desktop: IShellFolder;
  pchEaten, dwAttributes: ULONG;
begin
  SHGetDesktopFolder(Desktop);
  dwAttributes := 0;
  if Assigned(Desktop) then
  begin
    if Desktop.ParseDisplayName(0, nil, PWideChar(APath), pchEaten, Result, dwAttributes) <> NOERROR
    then
      Result := nil
  end else
    Result := nil
end;

procedure TVirtualKernelChangeThread.RemoveEventFromWatchArray(
  var WatchArray: TKernelWatchRec; EventIndex: Integer);
var
  i: Integer;
begin
  if EventIndex < Length(WatchArray.Handles) then
  begin
    FindCloseChangeNotification(WatchArray.Handles[EventIndex]);
    WatchArray.NSs[EventIndex].Free;
    for i := EventIndex to Length(WatchArray.Handles) - 2 do
    begin
      WatchArray.Handles[i] := WatchArray.Handles[i+1];
      WatchArray.NSs[i] := WatchArray.NSs[i+1]
    end;
    SetLength(WatchArray.Handles, Length(WatchArray.Handles) - 1);
    SetLength(WatchArray.NSs, Length(WatchArray.NSs) - 1)
  end
end;

procedure TVirtualKernelChangeThread.TriggerEvent;
begin
  if KernelChangeEvent <> 0 then
    SetEvent(KernelChangeEvent);
end;

{ TVirtualShellChangeThread }

constructor TVirtualShellChangeThread.Create(CreateSuspended: Boolean;
  AChangeNotifier: TVirtualChangeNotifier);
begin
  inherited Create(CreateSuspended);
  Priority := tpNormal;
  FChangeNotifier := AChangeNotifier;
  MapVirtualFolders := True;
end;

procedure TVirtualShellChangeThread.CreateNotifyWindow;
var
  ClassInfo: TWNDCLASS;
  ClassRegistered: Boolean;
begin
  NotifyWndProcStub := TCallbackStub.Create(Self, @TVirtualShellChangeThread.NotifyWndProc, 4);
  if (NotifyWindowHandle = 0) and Assigned(NotifyWndProcStub.StubPointer) then
  begin
    ClassRegistered := GetClassInfo(SysInit.HInstance, VirtualNotifyWndClass, ClassInfo);
    if not ClassRegistered then
    begin
      with ClassInfo do
      begin
        Style := CS_VREDRAW or CS_HREDRAW;
        lpfnWndProc := NotifyWndProcStub.StubPointer;
        cbClsExtra := 0;
        cbWndExtra := 0;
        hInstance := SysInit.hInstance;
        hIcon := 0;
        hCursor := 0;
        hbrBackground := COLOR_WINDOW + 1;
        lpszMenuName := nil;
        lpszClassName := VirtualNotifyWndClass;
      end;
      ClassRegistered := Windows.RegisterClass(ClassInfo) > 0
    end;
    if ClassRegistered then
      NotifyWindowHandle := CreateWindow(VirtualNotifyWndClass, '',
        WS_POPUP, 0, 0, 0, 0, 0, 0, hInstance, nil)
  end;
end;

destructor TVirtualShellChangeThread.Destroy;
begin
  inherited;
end;

procedure TVirtualShellChangeThread.DestroyNotifyWindow;
var
  ClassInfo: TWNDCLASS;
begin
  if NotifyWindowHandle <> 0 then
    DestroyWindow(NotifyWindowHandle);
  NotifyWindowHandle := 0;
  NotifyWndProcStub := nil;
  // DANGER DANGER DANGER:  The Stub is destroyed so the Class is still pointing
  // to it.  We MUST unregister the class or any new windows created will point
  // to la-la land for the window procedure
  if GetClassInfo(SysInit.HInstance, VirtualNotifyWndClass, ClassInfo) then
     Windows.UnregisterClass(VirtualNotifyWndClass, SysInit.HInstance);
end;

procedure TVirtualShellChangeThread.Execute;
var
  Msg: TMsg;
begin
  ThreadPIDLMgr := TCommonPIDLManager.Create;
  // Win9x does not send Shell Notifies to the My Document folder
  if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
  begin
    SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, FMyDocsPIDL);
    MyDocsDeskPIDL := GetMyDocumentsVirtualFolder;
  end;
  CreateNotifyWindow;
  RegisterChangeNotify;
  try
    while not Terminated do
    try
      if (NotifyWindowHandle > 0) then
      begin
        while not Terminated and GetMessage(Msg, 0, 0, 0) do
        begin
          Sleep(10);
          case Msg.message of
            WM_SHELLNOTIFYTHREADQUIT : PostQuitMessage(0);
          else
            TranslateMessage(Msg);
            DispatchMessage(Msg);
          end
        end;
      end else
        Terminate;
    except
      // Trap any exceptions
    end;
  finally
    UnRegisterChangeNotify;
    DestroyNotifyWindow;
    ThreadPIDLMgr.FreePIDL(FMyDocsDeskPIDL);
    ThreadPIDLMgr.FreePIDL(FMyDocsPIDL);
    ThreadPIDLMgr.Free;
  end
end;


function TVirtualShellChangeThread.NotifyWndProc(Wnd: HWND; Msg: UINT;
  wParam, lParam: LPARAM): LRESULT;

      procedure AddEventToList(Event: LongWord; SNR: PShellNotifyRec; W1, W2: DWORD);
      begin
        case Event of
          SHCNE_ASSOCCHANGED:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneAssoccChanged, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_ATTRIBUTES:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneAttributes, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_CREATE:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneCreate, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_DELETE:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneDelete, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_DRIVEADD:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneDriveAdd, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_DRIVEADDGUI:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneDriveAddGUI, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_DRIVEREMOVED:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneDriveRemoved, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_FREESPACE:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneFreeSpace, nil, nil, PDWordItemID(SNR.PIDL1).dwItem1,
                PDWordItemID(SNR.PIDL1).dwItem2, ThreadPIDLMgr, False);
          SHCNE_MEDIAINSERTED:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneMediaInserted, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_MEDIAREMOVED:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneMediaRemoved, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_MKDIR:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneMkDir, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_NETSHARE:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneNetShare, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_NETUNSHARE:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneNetUnShare, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_RENAMEFOLDER:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneRenameFolder, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_RENAMEITEM:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneRenameItem, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_RMDIR:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneRmDir, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_SERVERDISCONNECT:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneServerDisconnect, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_UPDATEDIR:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneUpdateDir, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
          SHCNE_UPDATEIMAGE:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneUpdateImage, nil, nil, PDWordItemID(SNR.PIDL1).dwItem1,
                PDWordItemID(SNR.PIDL1).dwItem2, ThreadPIDLMgr, False);
          SHCNE_UPDATEITEM:
            ChangeNotifier.ChangeDispatchThread.AddEvent(
              vsneUpdateItem, SNR.PIDL1, SNR.PIDL2, W1, W2, ThreadPIDLMgr, False);
        end;
      end;


var
  Message: TMessage;
  Event: DWORD;
  Handle: THandle;
  SNR: PShellNotifyRec;
  Rec: TShellNotifyRec;
  i, j: integer;
  PIDL: PItemIDList;
  OwnP1, OwnP2: Boolean;
begin
  Message.Msg := Msg;
  Message.lParam := lParam;
  Message.wParam := wParam;
  Message.Result := 0;
  case Msg of
    WM_NCCREATE: Message.Result := 1;
    { Message sent by shell }
    WM_CHANGENOTIFY_NT:
      begin
        Handle := SHChangeNotificationLock(WParam, LParam, SNR, Event);
        if Handle <> 0 then
        try
          AddEventToList(Event, SNR, 0, 0);
        finally
          SHChangeNotificationUnLock(Handle);
        end
      end;
    WM_CHANGENOTIFY:
      begin
        AddEventToList(lParam, PShellNotifyRec(wParam), 0, 0);

        if MapVirtualFolders then
        begin
          // Due to bug? in 9x we need to generate PIDLs for the My Documents under
          // the desktop if we get one for thet physical folder
          if Assigned(MyDocsPIDL) then
          begin
            OwnP1 := False;
            OwnP2 := False;
            i := ThreadPIDLMgr.IDCount(MyDocsPIDL);
            Rec := PShellNotifyRec(wParam)^;
            if ILIsParent(MyDocsPIDL, PShellNotifyRec(wParam).PIDL1, False) then
            begin
              PIDL := PShellNotifyRec(wParam).PIDL1;
              for j := 0 to i - 1 do
                PIDL := ThreadPIDLMgr.NextID(PIDL);
              Rec.PIDL1 := ThreadPIDLMgr.AppendPIDL(MyDocsDeskPIDL, PIDL);
              OwnP1 := True;
            end;
            if ILIsParent(MyDocsPIDL, PShellNotifyRec(wParam).PIDL2, False) then
            begin
              PIDL := PShellNotifyRec(wParam).PIDL2;
              for j := 0 to i - 1 do
                PIDL := ThreadPIDLMgr.NextID(PIDL);
              Rec.PIDL2 := ThreadPIDLMgr.AppendPIDL(MyDocsDeskPIDL, PIDL);
              OwnP2 := True;
            end;
            if OwnP1 or OwnP2 then
            begin
              AddEventToList(lParam, @Rec, 0, 0);
              if OwnP1 then
                ThreadPIDLMgr.FreePIDL(Rec.PIDL1);
              if OwnP2 then
                ThreadPIDLMgr.FreePIDL(Rec.PIDL2);
            end
          end
        end;
      end;
    WM_CHANGENOTIFY_CUSTOM:
      begin
        AddEventToList(lParam, PShellNotifyRec(wParam), 0, 0);
        Malloc.Free(PShellNotifyRec(wParam).PIDL1);
        Malloc.Free(PShellNotifyRec(wParam).PIDL2);
        Dispose(PShellNotifyRec(wParam));
      end;
  else
    Message.Result := DefWindowProc(NotifyWindowHandle, Msg, wParam, lParam);
  end;
  Result := Message.Result;
  {$IFDEF VIRTUALNOTIFYDEBUG}
  NotifyDebug.ShellEvents  := NotifyDebug.ShellEvents + 1
  {$ENDIF}
end;

procedure TVirtualShellChangeThread.RegisterChangeNotify;
var
  NR: TNotifyRegister;
  Flags, Msg: LongWord;
begin
  if (ChangeNotifyHandle = 0) and (NotifyWindowHandle > 0) then
  begin
    { Watch everything }
    NR.ItemIDList := nil;
    NR.bWatchSubTree := True;
    Flags := SHCNF_ACCEPT_INTERRUPTS or SHCNF_ACCEPT_NON_INTERRUPTS;
    Msg := WM_CHANGENOTIFY;
    if (Win32Platform = VER_PLATFORM_WIN32_NT) and
      Assigned(SHChangeNotificationLock) and
      Assigned(SHChangeNotificationUnlock)
    then begin
      Flags := Flags or SHCNF_NO_PROXY;
      Msg := WM_CHANGENOTIFY_NT
    end;
    ChangeNotifyHandle := SHChangeNotifyRegister(NotifyWindowHandle, Flags, SHCNE_ALLEVENTS, Msg, 1, NR);
  end;
end;

procedure TVirtualShellChangeThread.UnRegisterChangeNotify;
begin
  // Unregister the SHChangeNotify
  if ChangeNotifyHandle <> 0 then
    SHChangeNotifyDeRegister(ChangeNotifyHandle);
  ChangeNotifyHandle := 0
end;

{ TVirtualChangeDispatchThread }

procedure TVirtualChangeDispatchThread.AddEvent(AShellEvent: TVirtualShellEvent);
var
  List: TList;
begin
  if Assigned(AShellEvent) then
  begin
    List := WorkingList.LockList;
    try
      List.Add(AShellEvent);
    finally
      WorkingList.UnlockList;
      TriggerEvent
    end;

    EnterCriticalSection(FAddLock);
    try
      AddingEvents := True
    finally
      LeaveCriticalSection(FAddLock);
    end
  end
end;

procedure TVirtualChangeDispatchThread.AddEvent(
  ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIdList;
  APIDLMgr: TCommonPIDLManager; InvalidNamespace: Boolean);
begin
  AddEvent(ShellNotifyEvent, PIDL1, PIDL2, 0, 0, APIDLMgr, InvalidNamespace);

  EnterCriticalSection(FAddLock);
  try
    AddingEvents := True
  finally
    LeaveCriticalSection(FAddLock);
  end
end;

procedure TVirtualChangeDispatchThread.AddEvent(
  ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIdList;
  DoubleWord1, DoubleWord2: LongWord; APIDLMgr: TCommonPIDLManager;
  InvalidNamespace: Boolean);
var
  Handled: Boolean;
begin
  if FilterEvents then
  begin
    // Any Rename or Create/Delete event of an object will get stripped back to
    // its parent folder then converted to an UpdateDir event. This allows the events
    // to be reduced to a single event for multiple operation, i.e. deleting 10,000
    // files.  The last thing we want is 10,000 tree refreshes.
    if ShellNotifyEvent in [vsneRenameFolder, vsneRenameItem] then
      ReduceRenameEvents(ShellNotifyEvent, PIDL1, PIDL2, APIDLMgr)
    else
    if ShellNotifyEvent in [vsneCreate, vsneDelete, vsneMkDir, vsneRmDir] then
      ReduceCreateDeleteEvents(ShellNotifyEvent, PIDL1, PIDL2, APIDLMgr)
    else begin
      Handled := False;
      // NT4 sends a lot of UpdateItems in the RecycleBin. Normally we let these pass
      // through untouched but in the case of Updates in the Recycle Bin we need to
      // filter them.
      if ShellNotifyEvent in [vsneUpdateDir] then
        Handled := ReduceRecycleBinEvent(ShellNotifyEvent, PIDL1, PIDL2, APIDLMgr);
      // UpdateItem events in the recycle bin cause more events, endlessly....
      if not Handled and (ShellNotifyEvent in [vsneUpdateItem]) then
        Handled := IsInRecycleBinFolder(PIDL1);

      if not (Handled or IsRedundant(ShellNotifyEvent, PIDL1, PIDL2, DoubleWord1, DoubleWord2)) then
        AddEvent( TVirtualShellEvent.Create(ShellNotifyEvent, PIDL1, PIDL2, DoubleWord1, DoubleWord2, InvalidNamespace))
    end;
  end else
    AddEvent( TVirtualShellEvent.Create(ShellNotifyEvent, PIDL1, PIDL2, DoubleWord1, DoubleWord2, InvalidNamespace));


  EnterCriticalSection(FAddLock);
  try
    AddingEvents := True
  finally
    LeaveCriticalSection(FAddLock);
  end
end;

constructor TVirtualChangeDispatchThread.Create(CreateSuspended: Boolean;
  AChangeNotifier: TVirtualChangeNotifier);
begin
  inherited Create(CreateSuspended);
  FilterEvents := True;
  Priority := tpNormal;
  FChangeNotifier := AChangeNotifier;
  // Create an event object to break the ChangeNotifyFree on demand
  // Create with Manual Reset, and not signaled (fired)
  WorkerChangeEvent := CreateEvent(nil, True, False, nil);
  InitializeCriticalSection(FAddLock);
  RecycleFolderPIDLs := TList.Create;
end;

destructor TVirtualChangeDispatchThread.Destroy;
var
  Malloc: IMalloc;
  i: integer;
begin
  inherited;
  if WorkerChangeEvent <> 0 then
    CloseHandle(WorkerChangeEvent);
  WorkerChangeEvent := 0;
  FWorkingList.Free;
  DeleteCriticalSection(FAddLock);
  SHGetMalloc(Malloc);
  for i := 0 to RecycleFolderPIDLs.Count - 1 do
    Malloc.Free(RecycleFolderPIDLs[i]);
  RecycleFolderPIDLs.Free;
end;

procedure TVirtualChangeDispatchThread.Execute;
var
  TempList: TVirtualShellEventList;
  i: integer;
  DoneAdding: Boolean;
  WList, List: TList;
  LocalPIDLMgr: TCommonPIDLManager;
begin
  // MUST be created in context of thread since the PIDL manager retrives an
  // IMalloc interface and we can't use interfaces across threads without
  // marshalling
  LocalPIDLMgr := TCommonPIDLManager.Create;
  try
    FindRecycleFolders;
    while not Terminated do
    try
      WaitForSingleObject(WorkerChangeEvent, INFINITE);
      if not Terminated then
      begin
        // Let the threads pile up as many events as possible without a noticeable delay

        DoneAdding := False;
        // Update when no more items are being added or a reasonable amount of time has elapsed
        while not DoneAdding do
        begin
          Sleep(VirtualShellNotifyRefreshRate);
          EnterCriticalSection(FAddLock);
          try
            DoneAdding := not AddingEvents;
            AddingEvents := False;

            // for debugging
        //    DoneAdding := True;               
          finally
            LeaveCriticalSection(FAddLock);
          end;
        end;

        WList := WorkingList.LockList;
        try
          // Reset ourselves, by doing this in the locked list we ensure we don't
          // miss an event since no more can be added while the list is locked
          ResetEvent(WorkerChangeEvent);

          TempList := TVirtualShellEventList.Create;
          List := TempList.LockList;
          try
            List.Capacity := WList.Count;
            for i := 0 to WList.Count - 1 do
              List.Add(WList[i]);
          finally
            TempList.UnlockList
          end;
          WList.Clear;
        finally
          WorkingList.UnlockList
        end;
        TempList.FRefCount := 1;
        PostMessage(ChangeNotifier.Listener, WM_SHELLNOTIFY, Longword(TempList), 0)
      end
    except
      // trap all exceptions
    end
  finally
    LocalPIDLMgr.Free;
  end
end;

procedure TVirtualChangeDispatchThread.FindRecycleFolders;
// According to M$ Q articles the hidden recycle folder have these specific names
// FAT16 and FAT32 = Recycled
// NTFS            = Recycler
// Using this we can get the PIDL of the folder. This way I can catch update items
// in the recycle bin and convert them all into one UpdateDir. This should speed up
// working in the recycle bin dramaticlly.
var
  Folder: IShellFolder;
  PIDL: PItemIDList;
  Malloc: IMalloc;
  Drives, ParsedCount, Attribs: LongWord;
  i: integer;
  Drive: string;
  DriveW, RecycleFolder: Widestring;
begin
  // The first one in the list is the Virtual Recycle Bin
  SHGetSpecialFolderLocation(0, CSIDL_BITBUCKET, PIDL);
  RecycleFolderPIDLs.Add(PIDL);

  SHGetMalloc(Malloc);
  SHGetDesktopFolder(Folder);
  Drives := GetLogicalDrives;
  SetLength(Drive, 3);
  Drive[2] := ':';
  Drive[3] := '\';
  for i := 0 to 25 do
  begin
    if Drives and $0001 <> 0 then
    begin
      Drive[1] := Chr($41 + i);
      DriveW := Drive;
      if GetDriveType(PChar(Drive)) = DRIVE_FIXED then
      begin
        Attribs := 0;
        RecycleFolder := Drive + 'Recycled';
        if Succeeded(Folder.ParseDisplayName(0, nil, PWideChar(RecycleFolder), ParsedCount, PIDL, Attribs)) then
          RecycleFolderPIDLs.Add(PIDL)
        else begin
          Attribs := 0;
          RecycleFolder := Drive + 'Recycler';
          if Succeeded(Folder.ParseDisplayName(0, nil, PWideChar(RecycleFolder), ParsedCount, PIDL, Attribs)) then
            RecycleFolderPIDLs.Add(PIDL)
        end
      end
    end;
    Drives := Drives shr 1
  end;
end;

function TVirtualChangeDispatchThread.GetWorkingList: TVirtualShellEventList;
begin
  if not Assigned(FWorkingList) then
    FWorkingList := TVirtualShellEventList.Create;
  Result := FWorkingList;
end;

function TVirtualChangeDispatchThread.IsInRecycleBinFolder(
  PIDL: PItemIDList): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := 0;
  while (i < RecycleFolderPIDLs.Count) and not Result do
  begin
    Result := ILIsParent(RecycleFolderPIDLs[i], PIDL, False);
    Inc(i)
  end
end;

function TVirtualChangeDispatchThread.IsRedundant(ShellNotifyEvent: TVirtualShellNotifyEvent;
   PIDL1, PIDL2: PItemIDList; DoubleWord1, DoubleWord2: LongWord): Boolean;
var
  List: TList;
  i: integer;
//  NS, NS1: TNamespace;
begin
  Result := False;
  List := WorkingList.LockList;
  try
    i := 0;
    // Simply loop through the Current Event List and see if the passed event is
    // already covered by an event in the list.  The list should never have very
    // many items so an simple loop is fast enough
    while not Result and (i < List.Count) do
    begin
      if ShellNotifyEvent = TVirtualShellEvent(List[i]).ShellNotifyEvent then
      begin
{        NS := TNamespace.Create(PIDL1, nil);
        NS.FreePIDLOnDestroy := False;
        NS1 := TNamespace.Create(TVirtualShellEvent(List[i]).PIDL1, nil);
        NS1.FreePIDLOnDestroy := False;
        NS.Free;
        NS1.Free; }
        // There are cases where filtering this way is not a good idea such as
        // 2 Listviews where one is a one level and the other is in a child folder
        // of the others root.  In this case only an event will be sent for the
        // first ones folder and any in the child folders will be filtered out,
        // thus the second listview will not refresh
        Result := {ILIsParent(TVirtualShellEvent(List[i]).ParentPIDL1, PIDL1, False) or }
          ILIsEqual(TVirtualShellEvent(List[i]).PIDL1, PIDL1);
        if not Result then
        begin
          if ShellNotifyEvent = vsneFreeSpace then
            Result := TVirtualShellEvent(List[i]).FDoubleWord1 = DoubleWord1
        end;
      end;
      Inc(i)
    end
  finally
    WorkingList.UnlockList;
  end
end;

procedure TVirtualChangeDispatchThread.ReduceCreateDeleteEvents(
  ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIdList; APIDLMgr: TCommonPIDLManager);

// Careful this assumes that ShellNotifyEvent is a Delete/Create event.

var
  PIDL: PItemIDList;
begin
  // Make copies of the PIDLs then strip them back to their parent folders
  // We can't write to the PIDL's sent by the SHChangeNotifier subsystem
  PIDL := APIDLMgr.StripLastID(APIDLMgr.CopyPIDL(PIDL1));
  try
    // Add an UpdateDir of the parent folder
    AddEvent(vsneUpdateDir, PIDL, nil, APIDLMgr, False)
  finally
    APIDLMgr.FreePIDL(PIDL);
  end
end;

function TVirtualChangeDispatchThread.ReduceRecycleBinEvent(
  ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1,
  PIDL2: PItemIdList; APIDLMgr: TCommonPIDLManager): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := 0;
  while (i < RecycleFolderPIDLs.Count) and not Result do
  begin
    // See if the Notification is in a recycle folder or the Recycle Bin
    if ILIsParent(RecycleFolderPIDLs[i], PIDL1, False) then
    begin
      // See if a reduced Event to the root of the recycle bin or the Recycle Bin is
      // unique.
      if not IsRedundant(vsneUpdateDir, RecycleFolderPIDLs[i], nil, 0, 0) then
      begin
        // If it is unique then add it to the list
        AddEvent(TVirtualShellEvent.Create(vsneUpdateDir, APIDLMgr.CopyPIDL(RecycleFolderPIDLs[i]), nil, 0, 0, False));
        // Now generate a Virtual RecycleBin event if necessary
        if not IsRedundant(vsneUpdateDir, RecycleFolderPIDLs[0], nil, 0, 0) then
          AddEvent(TVirtualShellEvent.Create(vsneUpdateDir, APIDLMgr.CopyPIDL(RecycleFolderPIDLs[0]), nil, 0, 0, False));
        Result := True
      end
    end;
    Inc(i)
  end;
end;

procedure TVirtualChangeDispatchThread.ReduceRenameEvents(
  ShellNotifyEvent: TVirtualShellNotifyEvent; PIDL1, PIDL2: PItemIdList;
  APIDLMgr: TCommonPIDLManager);

// Careful this assumes that ShellNotifyEvent is a Rename event.

var
  NewPIDL1, NewPIDL2: PItemIDList;
begin
  // Make copies of the PIDLs then strip them back to their parent folders
  // We can't write to the PIDL's sent by the SHChangeNotifier subsystem
  NewPIDL1 := APIDLMgr.StripLastID(APIDLMgr.CopyPIDL(PIDL1));
  NewPIDL2 := APIDLMgr.StripLastID(APIDLMgr.CopyPIDL(PIDL2));
  try
    // Are the parents are the same so it is only a rename of a file or folder?

    // Yes so just pass it on
    if ILIsEqual(NewPIDL1, NewPIDL2) then
      AddEvent(TVirtualShellEvent.Create(ShellNotifyEvent, PIDL1, PIDL2, 0, 0, False))
 //     AddEvent(vsneUpdateDir, NewPIDL1, nil, APIDLMgr, False)
    else begin
      // Nope it is a move so must update both folders
      AddEvent(vsneUpdateDir, NewPIDL1, nil, APIDLMgr, False);
      AddEvent(vsneUpdateDir, NewPIDL2, nil, APIDLMgr, False);
    end;
  finally
    APIDLMgr.FreePIDL(NewPIDL1);
    APIDLMgr.FreePIDL(NewPIDL2);
  end
end;

procedure TVirtualChangeDispatchThread.TriggerEvent;
begin
  if WorkerChangeEvent <> 0 then
    SetEvent(WorkerChangeEvent)
end;

var
ShellDLL: THandle;


{$IFDEF VIRTUALNOTIFYDEBUG}

{ TVirtualNotifyDebug }

procedure TVirtualNotifyDebug.DoChange;
begin
  if Assigned(OnChange) then
    OnChange(Self)
end;

procedure TVirtualNotifyDebug.SetEventObjects(const Value: Integer);
begin
  DoChange;
  FEventObjects := Value;
  if PeakEventObjects < Value then
    PeakEventObjects := Value
end;

procedure TVirtualNotifyDebug.SetFEventListObjects(const Value: Integer);
begin
  DoChange;
  FEventListObjects := Value;
  if PeakEventListObjects < Value then
    PeakEventListObjects := Value
end;

procedure TVirtualNotifyDebug.SetKernelEvents(const Value: Integer);
begin
  DoChange;
  FKernelEvents := Value;
  if PeakKernelEvents < Value then
    PeakKernelEvents := Value
end;

procedure TVirtualNotifyDebug.SetShellEvents(const Value: Integer);
begin
  DoChange;
  FShellEvents := Value;
  if PeakShellEvents < Value then
    PeakShellEvents := Value
end;
{$ENDIF}

{ TChangeNamespaceArray}
constructor TChangeNamespace.Create(AnAbsolutePIDL: PItemIDList);
var
  PIDLMgr: TCommonPIDLManager;
  Desktop: IShellFolder;
  PIDL: PItemIDList;
begin
  inherited Create;
  PIDLMgr := TCommonPIDLManager.Create;
  try
    FAbsolutePIDL := PIDLMgr.CopyPIDL(AnAbsolutePIDL);
    FRelativePIDL := PIDLMgr.GetPointerToLastID(FAbsolutePIDL);
    if SHGetDesktopFolder(Desktop) = S_OK then
    begin
      if PIDLMgr.IDCount(FAbsolutePIDL) = 1 then
        FParentShellFolder := Desktop
      else begin
        PIDL := PIDLMgr.CopyPIDL(FAbsolutePIDL);
        PIDL := PIDLMgr.StripLastID(PIDL);
        Desktop.BindToObject(PIDL, nil, IShellFolder, Pointer(FParentShellFolder));
        PIDLMgr.FreePIDL(PIDL);
      end
    end
  finally
    PIDLMgr.Free
  end
end;

destructor TChangeNamespace.Destroy;
var
  PIDLMgr: TCommonPIDLManager;
begin
  PIDLMgr := TCommonPIDLManager.Create;
  PIDLMgr.FreePIDL(FAbsolutePIDL);
  PIDLMgr.Free;
  inherited Destroy;
end;

function TChangeNamespace.Valid: Boolean;
var
  rgfInOut: UINT;
begin
  // This takes a lot of time and I am not sure it is necessary anymore since
  // I now understand where a lot of my crashes where with the syncronous context menu
  // actions that kept pumping messages to the app
  Result := True;
  Exit;
  

  // Does not work on floppy drives and such
  if Assigned(ParentShellFolder) then
  begin
    rgfInOut := SFGAO_VALIDATE;
    Result := ParentShellFolder.GetAttributesOf(1, FRelativePIDL, rgfInOut) = NOERROR
  end else
    Result := True
end;

{ TShellNotifyManager }

constructor TShellNotifyManager.Create;
begin
  inherited;
  ExplorerWndList := TThreadList.Create;
  EventList := TThreadList.Create;
  Stub := TCallbackStub.Create(Self, @TShellNotifyManager.Timer, 4);
end;

destructor TShellNotifyManager.Destroy;
begin
  ClearEventList;
  ExplorerWndList.Free;
  EventList.Free;
  inherited;
end;

procedure TShellNotifyManager.ClearEventList;
var
  List: TList;
  i: Integer;
begin
  List := EventList.LockList;
  try
    for i := List.Count - 1 downto 0 do
    begin
      // Events in the Manager carry a reference count of 1
      TVirtualShellEventList( List[i]).Release;
      List.Delete(i);
    end
  finally
    EventList.UnLockList
  end
end;

function TShellNotifyManager.FindExplorerWnd(ExplorerWnd: TWinControl): Integer;
var
  List: TList;
  i: Integer;
begin
  Result := -1;
  List := ExplorerWndList.LockList;
  try
    for i := 0 to List.Count - 1 do
      if ExplorerWnd = TWinControl( List[i]) then
        Result := i
  finally
    ExplorerWndList.UnLockList
  end
end;

function TShellNotifyManager.OkToDispatch: Boolean;
var
  List: TList;
  i: Integer;
  ExplorerWnd: TWinControl;
  ShellNotify: IVirtualShellNotify;
begin
  Result := False;
  List := ExplorerWndList.LockList;
  try
    for i := 0 to List.Count - 1 do
    begin
      ExplorerWnd := TWinControl( List[i]);
      if ExplorerWnd.GetInterface(IVirtualShellNotify, ShellNotify) then
        Result := ShellNotify.GetOkToShellNotifyDispatch
      else
        Result := False;
      if not Result then
      begin
        Break
      end
    end
  finally
    ExplorerWndList.UnLockList
  end
end;

procedure TShellNotifyManager.EndTimer;
begin
  if TimerID <> 0 then
  begin
    KillTimer(0, TimerID);
    TimerID := 0
  end
end;

procedure TShellNotifyManager.ReDispatchShellNotify(Event: TVirtualShellEventList);
var
  List: TList;
  Duplicate: Boolean;
  i: Integer;
begin
  StartTimer;
  Duplicate := False;
  List := EventList.LockList;
  try
    for i := 0 to List.Count - 1 do
    begin
      Duplicate := Event.ID = TVirtualShellEventList(List[i]).ID;
      if Duplicate then
        Break;
    end;
    if not Duplicate then
      List.Add(Event)
    else
      Event.Release
  finally
    EventList.UnLockList
  end
end;

procedure TShellNotifyManager.RegisterExplorerWnd(ExplorerWnd: TWinControl);
var
  List: TList;
begin
  List := ExplorerWndList.LockList;
  try
    if FindExplorerWnd(ExplorerWnd) = -1 then
      List.Add(ExplorerWnd);
  finally
    ExplorerWndList.UnLockList
  end
end;

procedure TShellNotifyManager.StartTimer;
begin
  if TimerID = 0 then
    TimerID := SetTimer(0, ID_TIMER_NOTIFY, ID_TIMER_SHELLNOTIFY, Stub.StubPointer);
end;

procedure TShellNotifyManager.Timer(HWnd: HWND; Msg: UINT; idEvent: UINT;
  dwTime: DWORD);
var
  VList,
  EList: TList;
  i, j: Integer;
  NotifyMsg: TMessage;
  ShellNotify: IVirtualShellNotify;
begin
  if OKToDispatch then
  begin
    EndTimer;
    NotifyMsg.Msg := WM_SHELLNOTIFY;
    NotifyMsg.lParam := 0;
    VList := ExplorerWndList.LockList;
    EList := EventList.LockList;
    try
      for i := EList.Count - 1 downto 0  do
      begin
        TVirtualReferenceCountedList(EList[i]).FRefCount := VList.Count;
        for j := 0 to VList.Count - 1 do
        begin
          NotifyMsg.wParam := Integer(TVirtualShellEventList(EList[i]));
          if TWinControl(VList[j]).GetInterface(IVirtualShellNotify, ShellNotify) then
            ShellNotify.Notify(NotifyMsg);
        end;
        EList.Delete(i);
      end
    finally
      ExplorerWndList.UnLockList;
      EventList.UnLockList
    end
  end
end;

procedure TShellNotifyManager.UnRegisterExplorerWnd(ExplorerWnd: TWinControl);
var
  List: TList;
  i: Integer;
begin
  List := ExplorerWndList.LockList;
  try
    i := FindExplorerWnd(ExplorerWnd);
    if i > -1 then
      List.Delete(i)
  finally
    ExplorerWndList.UnLockList
  end
end;

initialization
  { Don't see a point in making this all WideString compatible }
  ShellDLL := GetModuleHandleA(PAnsiChar(AnsiString(Shell32)));
  if ShellDll <> 0 then
  begin
    ShellILIsEqual := GetProcAddress(ShellDLL, PAnsiChar(21));
    ShellILIsParent := GetProcAddress(ShellDLL, PAnsiChar(23));
    SHChangeNotifyRegister := GetProcAddress(ShellDLL, PAnsiChar(2));
    SHChangeNotifyDeRegister := GetProcAddress(ShellDLL, PAnsiChar(4));
    SHChangeNotificationLock := GetProcAddress(ShellDLL, PAnsiChar(644));
    SHChangeNotificationUnlock := GetProcAddress(ShellDLL, PAnsiChar(645));
  end;
  SHGetMalloc(Malloc);
  ShellNotifyManager := TShellNotifyManager.Create;

  {$IFDEF VIRTUALNOTIFYDEBUG}
  NotifyDebug := TVirtualNotifyDebug.Create;
  {$ENDIF}

finalization
  VirtualChangeNotifier := nil;
  FreeAndNil(ShellNotifyManager);

  {$IFDEF VIRTUALNOTIFYDEBUG}
  NotifyDebug.Free
  {$ENDIF}

end.
