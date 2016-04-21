// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualShellNotifier.pas' rev: 31.00 (Windows)

#ifndef VirtualshellnotifierHPP
#define VirtualshellnotifierHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Winapi.ShlObj.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.Win.ComObj.hpp>
#include <MPCommonObjects.hpp>
#include <VirtualResources.hpp>
#include <MPThreadManager.hpp>
#include <MPCommonUtilities.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualshellnotifier
{
//-- forward type declarations -----------------------------------------------
__interface IVirtualChangeNotifier;
typedef System::DelphiInterface<IVirtualChangeNotifier> _di_IVirtualChangeNotifier;
class DELPHICLASS TChangeNamespace;
struct TWMShellNotify;
struct TKernelWatchRec;
class DELPHICLASS TVirtualShellEvent;
class DELPHICLASS TVirtualReferenceCountedList;
class DELPHICLASS TVirtualShellEventList;
class DELPHICLASS TVirtualChangeDispatchThread;
class DELPHICLASS TVirtualShellChangeThread;
class DELPHICLASS TVirtualKernelChangeThread;
class DELPHICLASS TVirtualChangeControl;
class DELPHICLASS TVirtualChangeNotifier;
__interface IVirtualShellNotify;
typedef System::DelphiInterface<IVirtualShellNotify> _di_IVirtualShellNotify;
class DELPHICLASS TShellNotifyManager;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::WideString, 20> Virtualshellnotifier__1;

enum DECLSPEC_DENUM TVirtualShellNotifyEvent : unsigned char { vsneRenameFolder, vsneRenameItem, vsneAssoccChanged, vsneAttributes, vsneCreate, vsneDelete, vsneDriveAdd, vsneDriveAddGUI, vsneDriveRemoved, vsneFreeSpace, vsneMediaInserted, vsneMediaRemoved, vsneMkDir, vsneNetShare, vsneNetUnShare, vsneRmDir, vsneServerDisconnect, vsneUpdateDir, vsneUpdateImage, vsneUpdateItem, vsneNone };

enum DECLSPEC_DENUM TVirtualKernelNotifyEvent : unsigned char { vkneFileName, vkneDirName, vkneAttributes, vkneSize, vkneLastWrite, vkneLastAccess, vkneCreation, vkneSecurity };

typedef System::Set<TVirtualKernelNotifyEvent, TVirtualKernelNotifyEvent::vkneFileName, TVirtualKernelNotifyEvent::vkneSecurity> TVirtualKernelNotifyEvents;

__interface  INTERFACE_UUID("{7F1E9F93-87C2-49E1-8AD5-F5A2E057122C}") IVirtualChangeNotifier  : public System::IInterface 
{
	virtual void __fastcall AddEvent(TVirtualShellNotifyEvent ShellNotifyEvent, Winapi::Shlobj::PItemIDList PIDL1, Winapi::Shlobj::PItemIDList PIDL2, Mpcommonobjects::TCommonPIDLManager* APIDLMgr) = 0 ;
	virtual bool __fastcall GetFilterEvents(void) = 0 ;
	virtual bool __fastcall GetMapVirtualFolders(void) = 0 ;
	virtual void __fastcall LockNotifier(void) = 0 ;
	virtual bool __fastcall NotifyWatchFolder(Vcl::Controls::TWinControl* Control, System::WideString WatchFolder) = 0 ;
	virtual void __fastcall PostShellNotifyEvent(NativeInt NotifyType, Winapi::Shlobj::PItemIDList PIDL1, Winapi::Shlobj::PItemIDList PIDL2) = 0 ;
	virtual bool __fastcall RegisterKernelChangeNotify(Vcl::Controls::TWinControl* Control, TVirtualKernelNotifyEvents NotifyEvents) = 0 ;
	virtual void __fastcall RegisterKernelSpecialFolderWatch(unsigned SpecialFolder) = 0 ;
	virtual bool __fastcall RegisterShellChangeNotify(Vcl::Controls::TWinControl* Control) = 0 ;
	virtual void __fastcall SetFilterEvents(const bool DoFilter) = 0 ;
	virtual void __fastcall SetMapVirtualFolders(const bool Value) = 0 ;
	virtual void __fastcall StripDuplicates(System::Classes::TList* List) = 0 ;
	virtual void __fastcall UnLockNotifier(void) = 0 ;
	virtual bool __fastcall UnRegisterKernelChangeNotify(Vcl::Controls::TWinControl* Control) = 0 ;
	virtual bool __fastcall UnRegisterShellChangeNotify(Vcl::Controls::TWinControl* Control) = 0 ;
	virtual void __fastcall UnRegisterChangeNotify(Vcl::Controls::TWinControl* Control) = 0 ;
	virtual void __fastcall UnRegisterAllNotify(void) = 0 ;
};

class PASCALIMPLEMENTATION TChangeNamespace : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	_ITEMIDLIST *FAbsolutePIDL;
	_di_IShellFolder FParentShellFolder;
	_ITEMIDLIST *FRelativePIDL;
	
public:
	__fastcall TChangeNamespace(Winapi::Shlobj::PItemIDList AnAbsolutePIDL);
	__fastcall virtual ~TChangeNamespace(void);
	bool __fastcall Valid(void);
	__property Winapi::Shlobj::PItemIDList AbsolutePIDL = {read=FAbsolutePIDL, write=FAbsolutePIDL};
	__property _di_IShellFolder ParentShellFolder = {read=FParentShellFolder};
	__property Winapi::Shlobj::PItemIDList RelativePIDL = {read=FRelativePIDL};
};


typedef System::DynamicArray<TChangeNamespace*> TChangeNamespaceArray;

struct DECLSPEC_DRECORD TWMShellNotify
{
public:
	unsigned Msg;
	Winapi::Messages::TDWordFiller MsgFiller;
	TVirtualShellEventList* ShellEventList;
	NativeInt Unused;
	NativeInt Result;
};


typedef System::DynamicArray<NativeUInt> THandleArray;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TKernelWatchRec
{
public:
	THandleArray Handles;
	TChangeNamespaceArray NSs;
};
#pragma pack(pop)


typedef System::StaticArray<System::Classes::TList*, 20> TEventListArray;

class PASCALIMPLEMENTATION TVirtualShellEvent : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	unsigned FDoubleWord1;
	unsigned FDoubleWord2;
	bool FFreeContentsOnDestroy;
	bool FInvalidNamespace;
	_ITEMIDLIST *FPIDL1;
	_ITEMIDLIST *FPIDL2;
	_ITEMIDLIST *FParentPIDL1;
	_ITEMIDLIST *FParentPIDL2;
	TVirtualShellNotifyEvent FShellNotifyEvent;
	bool FHandled;
	
protected:
	Winapi::Shlobj::PItemIDList __fastcall CopyPIDL(Winapi::Shlobj::PItemIDList APIDL);
	Winapi::Shlobj::PItemIDList __fastcall NextID(Winapi::Shlobj::PItemIDList APIDL);
	int __fastcall PIDLSize(Winapi::Shlobj::PItemIDList APIDL);
	Winapi::Shlobj::PItemIDList __fastcall StripLastID(Winapi::Shlobj::PItemIDList APIDL);
	
public:
	__fastcall TVirtualShellEvent(TVirtualShellNotifyEvent AShellNotifyEvent, Winapi::Shlobj::PItemIDList aPIDL1, Winapi::Shlobj::PItemIDList aPIDL2, unsigned ADoubleWord1, unsigned ADoubleWord2, bool IsInvalidNamespace);
	__fastcall virtual ~TVirtualShellEvent(void);
	__property unsigned DoubleWord1 = {read=FDoubleWord1, write=FDoubleWord1, nodefault};
	__property unsigned DoubleWord2 = {read=FDoubleWord2, write=FDoubleWord2, nodefault};
	__property bool FreeContentsOnDestroy = {read=FFreeContentsOnDestroy, write=FFreeContentsOnDestroy, nodefault};
	__property bool Handled = {read=FHandled, write=FHandled, nodefault};
	__property bool InvalidNamespace = {read=FInvalidNamespace, write=FInvalidNamespace, nodefault};
	__property Winapi::Shlobj::PItemIDList ParentPIDL1 = {read=FParentPIDL1, write=FParentPIDL1};
	__property Winapi::Shlobj::PItemIDList ParentPIDL2 = {read=FParentPIDL2, write=FParentPIDL2};
	__property Winapi::Shlobj::PItemIDList PIDL1 = {read=FPIDL1, write=FPIDL1};
	__property Winapi::Shlobj::PItemIDList PIDL2 = {read=FPIDL2, write=FPIDL2};
	__property TVirtualShellNotifyEvent ShellNotifyEvent = {read=FShellNotifyEvent, nodefault};
};


class PASCALIMPLEMENTATION TVirtualReferenceCountedList : public System::Classes::TThreadList
{
	typedef System::Classes::TThreadList inherited;
	
protected:
	int FRefCount;
	
public:
	void __fastcall AddRef(void);
	HIDESBASE virtual void __fastcall Clear(void);
	void __fastcall Release(void);
	__property int RefCount = {read=FRefCount, nodefault};
public:
	/* TThreadList.Create */ inline __fastcall TVirtualReferenceCountedList(void) : System::Classes::TThreadList() { }
	/* TThreadList.Destroy */ inline __fastcall virtual ~TVirtualReferenceCountedList(void) { }
	
};


class PASCALIMPLEMENTATION TVirtualShellEventList : public TVirtualReferenceCountedList
{
	typedef TVirtualReferenceCountedList inherited;
	
private:
	unsigned FID;
	
public:
	__fastcall TVirtualShellEventList(void);
	__fastcall virtual ~TVirtualShellEventList(void);
	virtual void __fastcall Clear(void);
	__property unsigned ID = {read=FID, write=FID, nodefault};
};


class PASCALIMPLEMENTATION TVirtualChangeDispatchThread : public Mpthreadmanager::TCommonThread
{
	typedef Mpthreadmanager::TCommonThread inherited;
	
private:
	NativeUInt FWorkerChangeEvent;
	TVirtualChangeNotifier* FChangeNotifier;
	TVirtualShellEventList* FDispatchList;
	TVirtualShellEventList* FWorkingList;
	_RTL_CRITICAL_SECTION FAddLock;
	bool FAddingEvents;
	System::Classes::TList* FRecycleFolderPIDLs;
	bool FFilterEvents;
	TVirtualShellEventList* __fastcall GetWorkingList(void);
	
protected:
	virtual void __fastcall Execute(void);
	void __fastcall FindRecycleFolders(void);
	bool __fastcall IsInRecycleBinFolder(Winapi::Shlobj::PItemIDList PIDL);
	bool __fastcall IsRedundant(TVirtualShellNotifyEvent ShellNotifyEvent, Winapi::Shlobj::PItemIDList PIDL1, Winapi::Shlobj::PItemIDList PIDL2, unsigned DoubleWord1, unsigned DoubleWord2);
	void __fastcall ReduceCreateDeleteEvents(TVirtualShellNotifyEvent ShellNotifyEvent, Winapi::Shlobj::PItemIDList PIDL1, Winapi::Shlobj::PItemIDList PIDL2, Mpcommonobjects::TCommonPIDLManager* APIDLMgr);
	void __fastcall ReduceRenameEvents(TVirtualShellNotifyEvent ShellNotifyEvent, Winapi::Shlobj::PItemIDList PIDL1, Winapi::Shlobj::PItemIDList PIDL2, Mpcommonobjects::TCommonPIDLManager* APIDLMgr);
	bool __fastcall ReduceRecycleBinEvent(TVirtualShellNotifyEvent ShellNotifyEvent, Winapi::Shlobj::PItemIDList PIDL1, Winapi::Shlobj::PItemIDList PIDL2, Mpcommonobjects::TCommonPIDLManager* APIDLMgr);
	__property System::Classes::TList* RecycleFolderPIDLs = {read=FRecycleFolderPIDLs, write=FRecycleFolderPIDLs};
	
public:
	__fastcall virtual TVirtualChangeDispatchThread(bool CreateSuspended, TVirtualChangeNotifier* AChangeNotifier);
	__fastcall virtual ~TVirtualChangeDispatchThread(void);
	void __fastcall AddEvent(TVirtualShellEvent* AShellEvent)/* overload */;
	void __fastcall AddEvent(TVirtualShellNotifyEvent ShellNotifyEvent, Winapi::Shlobj::PItemIDList PIDL1, Winapi::Shlobj::PItemIDList PIDL2, Mpcommonobjects::TCommonPIDLManager* APIDLMgr, bool InvalidNamespace)/* overload */;
	void __fastcall AddEvent(TVirtualShellNotifyEvent ShellNotifyEvent, Winapi::Shlobj::PItemIDList PIDL1, Winapi::Shlobj::PItemIDList PIDL2, unsigned DoubleWord1, unsigned DoubleWord2, Mpcommonobjects::TCommonPIDLManager* APIDLMgr, bool InvalidNamespace)/* overload */;
	HIDESBASE void __fastcall TriggerEvent(void);
	__property bool AddingEvents = {read=FAddingEvents, write=FAddingEvents, nodefault};
	__property _RTL_CRITICAL_SECTION AddLock = {read=FAddLock, write=FAddLock};
	__property TVirtualShellEventList* DispatchList = {read=FDispatchList};
	__property TVirtualChangeNotifier* ChangeNotifier = {read=FChangeNotifier};
	__property bool FilterEvents = {read=FFilterEvents, write=FFilterEvents, nodefault};
	__property NativeUInt WorkerChangeEvent = {read=FWorkerChangeEvent, write=FWorkerChangeEvent};
	__property TVirtualShellEventList* WorkingList = {read=GetWorkingList};
};


class PASCALIMPLEMENTATION TVirtualShellChangeThread : public Mpthreadmanager::TCommonThread
{
	typedef Mpthreadmanager::TCommonThread inherited;
	
private:
	NativeUInt FChangeNotifyHandle;
	Mpcommonobjects::TCommonPIDLManager* FThreadPIDLMgr;
	_ITEMIDLIST *FMyDocsDeskPIDL;
	_ITEMIDLIST *FMyDocsPIDL;
	bool FMapVirtualFolders;
	HWND FNotifyWindowHandle;
	TVirtualChangeNotifier* FChangeNotifier;
	Mpcommonutilities::_di_ICallbackStub FNotifyWndProcStub;
	void __fastcall CreateNotifyWindow(void);
	void __fastcall DestroyNotifyWindow(void);
	NativeInt __stdcall NotifyWndProc(HWND Wnd, unsigned Msg, NativeInt wParam, NativeInt lParam);
	void __fastcall RegisterChangeNotify(void);
	void __fastcall UnRegisterChangeNotify(void);
	__property NativeUInt ChangeNotifyHandle = {read=FChangeNotifyHandle, write=FChangeNotifyHandle};
	__property HWND NotifyWindowHandle = {read=FNotifyWindowHandle, write=FNotifyWindowHandle};
	
protected:
	virtual void __fastcall Execute(void);
	__property Winapi::Shlobj::PItemIDList MyDocsDeskPIDL = {read=FMyDocsDeskPIDL, write=FMyDocsDeskPIDL};
	__property Winapi::Shlobj::PItemIDList MyDocsPIDL = {read=FMyDocsPIDL, write=FMyDocsPIDL};
	__property Mpcommonutilities::_di_ICallbackStub NotifyWndProcStub = {read=FNotifyWndProcStub, write=FNotifyWndProcStub};
	__property Mpcommonobjects::TCommonPIDLManager* ThreadPIDLMgr = {read=FThreadPIDLMgr, write=FThreadPIDLMgr};
	
public:
	__fastcall virtual TVirtualShellChangeThread(bool CreateSuspended, TVirtualChangeNotifier* AChangeNotifier);
	__fastcall virtual ~TVirtualShellChangeThread(void);
	__property TVirtualChangeNotifier* ChangeNotifier = {read=FChangeNotifier};
	__property bool MapVirtualFolders = {read=FMapVirtualFolders, write=FMapVirtualFolders, nodefault};
};


class PASCALIMPLEMENTATION TVirtualKernelChangeThread : public Mpthreadmanager::TCommonThread
{
	typedef Mpthreadmanager::TCommonThread inherited;
	
private:
	NativeUInt FKernelChangeEvent;
	TVirtualChangeNotifier* FChangeNotifier;
	Mpcommonobjects::TCommonPIDLList* FSpecialFolderVirtualPIDLs;
	Mpcommonobjects::TCommonPIDLList* FSpecialFolderPhysicalPIDL;
	System::Classes::TStringList* FSpecialFolderPhysicalPath;
	
protected:
	int __fastcall ChangeInSpecialFolder(Winapi::Shlobj::PItemIDList PIDL);
	virtual void __fastcall Execute(void);
	Winapi::Shlobj::PItemIDList __fastcall GenerateVirtualFolderPathPIDL(Winapi::Shlobj::PItemIDList PhysicalPIDL, int RegisteredSpecialFolderIndex, Mpcommonobjects::TCommonPIDLManager* APIDLMgr);
	Winapi::Shlobj::PItemIDList __fastcall PathToPIDL(System::WideString APath);
	__property Mpcommonobjects::TCommonPIDLList* SpecialFolderVirtualPIDLs = {read=FSpecialFolderVirtualPIDLs, write=FSpecialFolderVirtualPIDLs};
	__property Mpcommonobjects::TCommonPIDLList* SpecialFolderPhysicalPIDL = {read=FSpecialFolderPhysicalPIDL, write=FSpecialFolderPhysicalPIDL};
	__property System::Classes::TStringList* SpecialFolderPhysicalPath = {read=FSpecialFolderPhysicalPath, write=FSpecialFolderPhysicalPath};
	
public:
	__fastcall virtual TVirtualKernelChangeThread(bool CreateSuspended, TVirtualChangeNotifier* AChangeNotifier);
	__fastcall virtual ~TVirtualKernelChangeThread(void);
	void __fastcall RemoveEventFromWatchArray(TKernelWatchRec &WatchArray, int EventIndex);
	HIDESBASE void __fastcall TriggerEvent(void);
	__property TVirtualChangeNotifier* ChangeNotifier = {read=FChangeNotifier};
	__property NativeUInt KernelChangeEvent = {read=FKernelChangeEvent, write=FKernelChangeEvent};
};


class PASCALIMPLEMENTATION TVirtualChangeControl : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	bool FShellChangeRegistered;
	bool FKernelChangeRegistered;
	Vcl::Controls::TWinControl* FControl;
	System::WideString FWatchFolder;
	TVirtualKernelNotifyEvents FNotifyEvents;
	void __fastcall SetWatchFolder(const System::WideString Value);
	bool __fastcall GetIsRegistered(void);
	
public:
	unsigned __fastcall MapNotifyEvents(void);
	__property Vcl::Controls::TWinControl* Control = {read=FControl, write=FControl};
	__property bool IsRegistered = {read=GetIsRegistered, nodefault};
	__property bool KernelChangeRegistered = {read=FKernelChangeRegistered, write=FKernelChangeRegistered, nodefault};
	__property TVirtualKernelNotifyEvents NotifyEvents = {read=FNotifyEvents, write=FNotifyEvents, nodefault};
	__property bool ShellChangeRegistered = {read=FShellChangeRegistered, write=FShellChangeRegistered, nodefault};
	__property System::WideString WatchFolder = {read=FWatchFolder, write=SetWatchFolder};
public:
	/* TObject.Create */ inline __fastcall TVirtualChangeControl(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TVirtualChangeControl(void) { }
	
};


class PASCALIMPLEMENTATION TVirtualChangeNotifier : public System::TInterfacedObject
{
	typedef System::TInterfacedObject inherited;
	
private:
	System::Classes::TThreadList* FControlList;
	TVirtualKernelChangeThread* FKernelChangeThread;
	TVirtualShellChangeThread* FShellChangeThread;
	TVirtualChangeDispatchThread* FChangeDispatchThread;
	HWND FListener;
	_RTL_CRITICAL_SECTION FSpecialFolderRegisterLock;
	Mpcommonobjects::TCommonPIDLManager* FPIDLMgr;
	void *FListenerWndProcStub;
	unsigned FIDCounter;
	unsigned __fastcall GetIDCounter(void);
	TVirtualKernelChangeThread* __fastcall GetKernelChangeThread(void);
	TVirtualShellChangeThread* __fastcall GetShellChangeThread(void);
	TVirtualChangeDispatchThread* __fastcall GetChangeDispatchThead(void);
	bool __fastcall GetFilterEvents(void);
	void __fastcall SetFilterEvents(const bool Value);
	bool __fastcall GetMapVirtualFolders(void);
	void __fastcall SetMapVirtualFolders(const bool Value);
	
protected:
	void __fastcall CheckForAutoRelease(void);
	int __fastcall FindControlIndex(TVirtualChangeControl* const Control);
	TVirtualChangeControl* __fastcall FindRegisteredControl(Vcl::Controls::TWinControl* const Control);
	void __fastcall FreeShellNotifyThread(void);
	void __fastcall FreeKernelNotifyThread(void);
	void __fastcall FreeChangeDispatchThread(void);
	void __fastcall ListenerWndProc(Winapi::Messages::TMessage &Msg);
	__property TVirtualChangeDispatchThread* ChangeDispatchThread = {read=GetChangeDispatchThead};
	__property System::Classes::TThreadList* ControlList = {read=FControlList, write=FControlList};
	__property unsigned IDCounter = {read=GetIDCounter, nodefault};
	__property HWND Listener = {read=FListener, write=FListener};
	__property void * ListenerWndProcStub = {read=FListenerWndProcStub, write=FListenerWndProcStub};
	__property TVirtualKernelChangeThread* KernelChangeThread = {read=GetKernelChangeThread};
	__property Mpcommonobjects::TCommonPIDLManager* PIDLMgr = {read=FPIDLMgr, write=FPIDLMgr};
	__property TVirtualShellChangeThread* ShellChangeThread = {read=GetShellChangeThread};
	__property _RTL_CRITICAL_SECTION SpecialFolderRegisterLock = {read=FSpecialFolderRegisterLock, write=FSpecialFolderRegisterLock};
	
public:
	__fastcall TVirtualChangeNotifier(void);
	__fastcall virtual ~TVirtualChangeNotifier(void);
	void __fastcall AddEvent(TVirtualShellNotifyEvent ShellNotifyEvent, Winapi::Shlobj::PItemIDList PIDL1, Winapi::Shlobj::PItemIDList PIDL2, Mpcommonobjects::TCommonPIDLManager* APIDLMgr);
	void __fastcall LockNotifier(void);
	bool __fastcall NotifyWatchFolder(Vcl::Controls::TWinControl* Control, System::WideString WatchFolder);
	void __fastcall PostShellNotifyEvent(NativeInt NotifyType, Winapi::Shlobj::PItemIDList PIDL1, Winapi::Shlobj::PItemIDList PIDL2);
	bool __fastcall RegisterKernelChangeNotify(Vcl::Controls::TWinControl* Control, TVirtualKernelNotifyEvents NotifyEvents);
	void __fastcall RegisterKernelSpecialFolderWatch(unsigned SpecialFolder);
	bool __fastcall RegisterShellChangeNotify(Vcl::Controls::TWinControl* Control);
	void __fastcall StripDuplicates(System::Classes::TList* List);
	void __fastcall UnLockNotifier(void);
	bool __fastcall UnRegisterKernelChangeNotify(Vcl::Controls::TWinControl* Control);
	bool __fastcall UnRegisterShellChangeNotify(Vcl::Controls::TWinControl* Control);
	void __fastcall UnRegisterChangeNotify(Vcl::Controls::TWinControl* Control);
	void __fastcall UnRegisterAllNotify(void);
	__property bool FilterEvents = {read=GetFilterEvents, write=SetFilterEvents, nodefault};
	__property bool MapVirtualFolders = {read=GetMapVirtualFolders, write=SetMapVirtualFolders, nodefault};
private:
	void *__IVirtualChangeNotifier;	// IVirtualChangeNotifier 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {7F1E9F93-87C2-49E1-8AD5-F5A2E057122C}
	operator _di_IVirtualChangeNotifier()
	{
		_di_IVirtualChangeNotifier intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator IVirtualChangeNotifier*(void) { return (IVirtualChangeNotifier*)&__IVirtualChangeNotifier; }
	#endif
	
};


__interface  INTERFACE_UUID("{86888DA6-8429-4A7F-AC9C-9A9EB1F08E1A}") IVirtualShellNotify  : public System::IInterface 
{
	virtual bool __fastcall GetOkToShellNotifyDispatch(void) = 0 ;
	virtual void __fastcall Notify(Winapi::Messages::TMessage &Msg) = 0 ;
	__property bool OkToShellNotifyDispatch = {read=GetOkToShellNotifyDispatch};
};

class PASCALIMPLEMENTATION TShellNotifyManager : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TThreadList* FEventList;
	Mpcommonutilities::_di_ICallbackStub FStub;
	int FTimerID;
	System::Classes::TThreadList* FExplorerWndList;
	
protected:
	int __fastcall FindExplorerWnd(Vcl::Controls::TWinControl* ExplorerWnd);
	void __fastcall ClearEventList(void);
	void __fastcall EndTimer(void);
	void __fastcall StartTimer(void);
	void __stdcall Timer(HWND HWnd, unsigned Msg, unsigned idEvent, unsigned dwTime);
	__property System::Classes::TThreadList* ExplorerWndList = {read=FExplorerWndList, write=FExplorerWndList};
	__property Mpcommonutilities::_di_ICallbackStub Stub = {read=FStub, write=FStub};
	__property int TimerID = {read=FTimerID, write=FTimerID, nodefault};
	__property System::Classes::TThreadList* EventList = {read=FEventList, write=FEventList};
	
public:
	__fastcall TShellNotifyManager(void);
	__fastcall virtual ~TShellNotifyManager(void);
	bool __fastcall OkToDispatch(void);
	void __fastcall ReDispatchShellNotify(TVirtualShellEventList* Event);
	void __fastcall RegisterExplorerWnd(Vcl::Controls::TWinControl* ExplorerWnd);
	void __fastcall UnRegisterExplorerWnd(Vcl::Controls::TWinControl* ExplorerWnd);
};


//-- var, const, procedure ---------------------------------------------------
#define VirtualNotifyWndClass L"vstVirtualNotifyWndClass"
extern DELPHI_PACKAGE Virtualshellnotifier__1 SHELL_NOTIFY_EVENTS;
extern DELPHI_PACKAGE TVirtualKernelNotifyEvents AllKernelNotifiers;
extern DELPHI_PACKAGE int VirtualShellNotifyRefreshRate;
extern DELPHI_PACKAGE TShellNotifyManager* ShellNotifyManager;
extern DELPHI_PACKAGE _di_IVirtualChangeNotifier __fastcall ChangeNotifier(void);
extern DELPHI_PACKAGE System::WideChar __fastcall FreeSpaceNotifyToDrive(unsigned dwWord);
extern DELPHI_PACKAGE System::WideString __fastcall VirtualShellNotifyEventToStr(TVirtualShellNotifyEvent ShellNotifyEvent);
extern DELPHI_PACKAGE int __fastcall ShellEventSort(void * Item1, void * Item2);
}	/* namespace Virtualshellnotifier */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALSHELLNOTIFIER)
using namespace Virtualshellnotifier;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualshellnotifierHPP
