// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualExplorerTree.pas' rev: 32.00 (Windows)

#ifndef VirtualexplorertreeHPP
#define VirtualexplorertreeHPP

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
#include <Winapi.ShellAPI.hpp>
#include <Winapi.ActiveX.hpp>
#include <Winapi.ShlObj.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <System.Win.Registry.hpp>
#include <VirtualTrees.hpp>
#include <MPShellUtilities.hpp>
#include <VirtualScrollbars.hpp>
#include <VirtualShellNotifier.hpp>
#include <VirtualShellAutoComplete.hpp>
#include <VirtualResources.hpp>
#include <MPCommonObjects.hpp>
#include <MPCommonUtilities.hpp>
#include <MPThreadManager.hpp>
#include <MPResources.hpp>
#include <MPShellTypes.hpp>
#include <MPDataObject.hpp>
#include <Vcl.Themes.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <Winapi.UxTheme.hpp>
#include <VirtualTrees.StyleHooks.hpp>
#include <EasyListview.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualexplorertree
{
//-- forward type declarations -----------------------------------------------
struct TNodeSearchRec;
struct TColumnWidthInfo;
struct TFindSpecialFolderByNameData;
class DELPHICLASS TExpandMarkThreadRequest;
__interface IVETChangeLink;
typedef System::DelphiInterface<IVETChangeLink> _di_IVETChangeLink;
class DELPHICLASS TVETChangeLink;
class DELPHICLASS TVETChangeDispatch;
struct TVer1CheckStorage;
struct TCheckStorage;
struct TColumnStorage;
struct TGroupStorage;
struct TThumbnailStorage;
class DELPHICLASS TUserDataStorage;
struct TStorage;
class DELPHICLASS TNodeStorage;
class DELPHICLASS TRootNodeStorage;
class DELPHICLASS TNodeStorageList;
class DELPHICLASS TLeafNode;
class DELPHICLASS TLeafNodeList;
class DELPHICLASS TVETPersistent;
class DELPHICLASS TView;
class DELPHICLASS TViewList;
class DELPHICLASS TViewManager;
class DELPHICLASS TGlobalViewManager;
class DELPHICLASS TVETDataObject;
class DELPHICLASS TVETColors;
class DELPHICLASS TColumnMenuItem;
class DELPHICLASS TColumnMenu;
class DELPHICLASS TVETHeader;
class DELPHICLASS TVETColumn;
class DELPHICLASS TColumnManager;
class DELPHICLASS TContextMenuManager;
class DELPHICLASS TCustomVirtualExplorerTreeOptions;
class DELPHICLASS TVirtualExplorerTreeOptions;
class DELPHICLASS TVirtualExplorerEditLink;
class DELPHICLASS TVirtualShellBackgroundContextMenu;
class DELPHICLASS TVirtualShellMultiParentContextMenu;
struct TNodeData;
class DELPHICLASS TCustomVirtualExplorerTree;
class DELPHICLASS TVirtualExplorerTree;
class DELPHICLASS TVirtualExplorerViews;
class DELPHICLASS TVirtualExplorerTreeview;
class DELPHICLASS TVirtualExplorerListview;
class DELPHICLASS TComboEdit;
class DELPHICLASS TSizeGrabber;
class DELPHICLASS TDropDownWnd;
class DELPHICLASS TPopupExplorerTree;
class DELPHICLASS TPopupExplorerOptions;
class DELPHICLASS TPopupExplorerDropDown;
class DELPHICLASS TPopupAutoCompleteTree;
class DELPHICLASS TPopupAutoCompleteOptions;
class DELPHICLASS TPopupAutoCompleteDropDown;
class DELPHICLASS TCustomVirtualExplorerCombobox;
class DELPHICLASS TVirtualExplorerCombobox;
class DELPHICLASS TExplorerComboBox;
class DELPHICLASS TVirtualBkGndEnumThreadList;
class DELPHICLASS TVirtualBackGndEnumThread;
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD TNodeSearchRec
{
public:
	Virtualtrees::TVirtualNode *Node;
	Mpshellutilities::TNamespace* NS;
};
#pragma pack(pop)


typedef System::DynamicArray<TNodeSearchRec> TNodeSearchArray;

enum DECLSPEC_DENUM TFileSizeFormat : unsigned char { fsfExplorer, fsfActual, fsfDiskUsage };

enum DECLSPEC_DENUM TRootFolder : unsigned char { rfAdminTools, rfAltStartup, rfAppData, rfBitBucket, rfCommonAdminTools, rfCommonAltStartup, rfCommonAppData, rfCommonDesktopDirectory, rfCommonDocuments, rfCommonFavorties, rfCommonPrograms, rfCommonStartMenu, rfCommonStartup, rfCommonTemplates, rfControlPanel, rfCookies, rfDesktop, rfDesktopDirectory, rfDrives, rfFavorites, rfFonts, rfHistory, rfInternet, rfInternetCache, rfLocalAppData, rfMyPictures, rfNetHood, rfNetwork, rfPersonal, rfPrinters, rfPrintHood, rfProfile, rfProgramFiles, rfCommonProgramFiles, rfPrograms, rfRecent, rfSendTo, rfStartMenu, rfStartUp, rfSystem, rfTemplate, rfWindows, rfCustom, rfCustomPIDL };

enum DECLSPEC_DENUM TColumnDetailType : unsigned char { cdUser, cdVETColumns, cdShellColumns };

enum DECLSPEC_DENUM TColumnDetails : unsigned char { cdFileName, cdSize, cdType, cdModified, cdAccessed, cdCreated, cdAttributes, cdPath, cdDOSName, cdCustom };

enum DECLSPEC_DENUM TColumnWidthView : unsigned char { cwv_Default, cwv_AutoFit, cwv_Minimize };

#pragma pack(push,1)
struct DECLSPEC_DRECORD TColumnWidthInfo
{
public:
	unsigned Width;
	TColumnWidthView WidthView;
};
#pragma pack(pop)


enum DECLSPEC_DENUM TButtonState : unsigned char { bsDown, bsUp };

enum DECLSPEC_DENUM TCoordType : unsigned char { ctClient, ctScreen, ctWindow };

enum DECLSPEC_DENUM TForceRightDragType : unsigned char { frdBegin, frdEnd };

enum DECLSPEC_DENUM TVETFolderOption : unsigned char { toFoldersExpandable, toHideRootFolder, toForceHideRecycleBin, toForceShowMyDocuments, toShowOpenIconOnSelect, toDisableGhostedFolders, toNoUseVETColorsProp, toThreadedExpandMark };

typedef System::Set<TVETFolderOption, TVETFolderOption::toFoldersExpandable, TVETFolderOption::toThreadedExpandMark> TVETFolderOptions;

enum DECLSPEC_DENUM TVETShellOption : unsigned char { toRightAlignSizeColumn, toContextMenus, toDragDrop, toShellHints, toShellColumnMenu, toFullRowContextMenuActivate };

typedef System::Set<TVETShellOption, TVETShellOption::toRightAlignSizeColumn, TVETShellOption::toFullRowContextMenuActivate> TVETShellOptions;

enum DECLSPEC_DENUM TVETMiscOption : unsigned char { toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toBrowseExecuteZipFolder, toChangeNotifierThread, toListviewLimitBrowseToRoot, toNoRebuildIconListOnAssocChange, toTrackChangesInMappedDrives, toPersistentColumns, toExecuteOnDblClk, toExecuteOnDblClkFullRow, toRightButtonSelect, toRemoveContextMenuShortCut, toUserSort, toAutoScrollHorz, toVETReadOnly, toRestoreTopNodeOnRefresh, toPersistListviewColumnSort };

typedef System::Set<TVETMiscOption, TVETMiscOption::toBrowseExecuteFolder, TVETMiscOption::toPersistListviewColumnSort> TVETMiscOptions;

enum DECLSPEC_DENUM TVETImageOption : unsigned char { toHideOverlay, toImages, toThreadedImages, toLargeImages, toMarkCutAndCopy };

typedef System::Set<TVETImageOption, TVETImageOption::toHideOverlay, TVETImageOption::toMarkCutAndCopy> TVETImageOptions;

enum DECLSPEC_DENUM TVETSyncOption : unsigned char { toCollapseTargetFirst, toExpandTarget, toSelectTarget };

typedef System::Set<TVETSyncOption, TVETSyncOption::toCollapseTargetFirst, TVETSyncOption::toSelectTarget> TVETSyncOptions;

enum DECLSPEC_DENUM TComboBoxStyle : unsigned char { cbsClassic, cbsVETEnhanced };

enum DECLSPEC_DENUM TExplorerComboboxText : unsigned char { ecbtNameOnly, ecbtFullPath };

enum DECLSPEC_DENUM TVETComboState : unsigned char { vcbsNotifyChanging, vcbsOverDropDownButton, vcbsDropDownButtonPressed, vcbsDropDownButtonPressPending };

typedef System::Set<TVETComboState, TVETComboState::vcbsNotifyChanging, TVETComboState::vcbsDropDownButtonPressPending> TVETComboStates;

enum DECLSPEC_DENUM TVETComboOption : unsigned char { vcboThreadedImages, vcboThemeAware, vcboSelectPathOnDropDown };

typedef System::Set<TVETComboOption, TVETComboOption::vcboThreadedImages, TVETComboOption::vcboSelectPathOnDropDown> TVETComboOptions;

enum DECLSPEC_DENUM TComboItemRect : unsigned char { crBackGround, crClient, crDropDownButton, crImage, crComboEdit };

enum DECLSPEC_DENUM TDropDown : unsigned char { ddExplorer, ddAutoComplete };

enum DECLSPEC_DENUM TShellComboStyle : unsigned char { scsDropDown, scsDropDownList };

enum DECLSPEC_DENUM TChangeLinkListState : unsigned char { clsDispatching };

typedef System::Set<TChangeLinkListState, TChangeLinkListState::clsDispatching, TChangeLinkListState::clsDispatching> TChangLinkListStates;

enum DECLSPEC_DENUM TUnRegisterType : unsigned char { utServer, utClient, utLink, utAll };

enum DECLSPEC_DENUM TVETState : unsigned char { vsBrowsing, vsNotifyChanging, vsLockChangeNotifier, vsHeaderWasShown, vsCreateNotificationLock };

typedef System::Set<TVETState, TVETState::vsBrowsing, TVETState::vsCreateNotificationLock> TVETStates;

enum DECLSPEC_DENUM TVETPersistentState : unsigned char { vpsFullInit };

typedef System::Set<TVETPersistentState, TVETPersistentState::vpsFullInit, TVETPersistentState::vpsFullInit> TVETPersistentStates;

enum DECLSPEC_DENUM TNamespaceStructureChange : unsigned char { nscDelete, nscAdd };

enum DECLSPEC_DENUM TStorageType : unsigned char { stChecks, stColumns, stGrouping, stUser };

enum DECLSPEC_DENUM TPopupState : unsigned char { psRolledDown, psFormHooked, psAboveHostControl, psBelowHostControl, psDroppedOnce, psScrollingUp, psScrollingDown, psFastScroll, psSlowScroll, psLeftScrollbar };

typedef System::Set<TPopupState, TPopupState::psRolledDown, TPopupState::psLeftScrollbar> TPopupStates;

enum DECLSPEC_DENUM TPopupOption : unsigned char { poAnimated, poEnabled, poPersistentSizing, poSizeable, poRespectSysAnimationFlag, poThemeAware };

typedef System::Set<TPopupOption, TPopupOption::poAnimated, TPopupOption::poThemeAware> TPopupOptions;

typedef TFindSpecialFolderByNameData *PFindSpecialFolderByNameData;

struct DECLSPEC_DRECORD TFindSpecialFolderByNameData
{
public:
	System::WideString Name;
	_ITEMIDLIST *PIDL;
};


typedef TVirtualBackGndEnumThread* *PVirtualBackGndEnumThread;

typedef void __fastcall (__closure *TVETChangeLinkEvent)(System::TObject* Server, Winapi::Shlobj::PItemIDList NewPIDL);

typedef void __fastcall (__closure *TVETChangeLinkFreeEvent)(_di_IVETChangeLink ChangeLink);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TExpandMarkThreadRequest : public Mpthreadmanager::TPIDLThreadRequest
{
	typedef Mpthreadmanager::TPIDLThreadRequest inherited;
	
private:
	unsigned FEnumFlags;
	bool FShowMark;
	
public:
	virtual bool __fastcall HandleRequest(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property unsigned EnumFlags = {read=FEnumFlags, write=FEnumFlags, nodefault};
	__property bool ShowMark = {read=FShowMark, nodefault};
public:
	/* TPIDLThreadRequest.Destroy */ inline __fastcall virtual ~TExpandMarkThreadRequest(void) { }
	
public:
	/* TCommonThreadRequest.Create */ inline __fastcall virtual TExpandMarkThreadRequest(void) : Mpthreadmanager::TPIDLThreadRequest() { }
	
};

#pragma pack(pop)

__interface  INTERFACE_UUID("{3C0AF30B-DA91-4F42-B02C-8A326704B368}") IVETChangeLink  : public System::IInterface 
{
	virtual TVETChangeLinkEvent __fastcall GetOnChangeLink(void) = 0 ;
	virtual void __fastcall SetOnChangeLink(const TVETChangeLinkEvent Value) = 0 ;
	virtual System::TObject* __fastcall GetChangeLinkServer(void) = 0 ;
	virtual void __fastcall SetChangeLinkServer(System::TObject* const Value) = 0 ;
	virtual System::TObject* __fastcall GetChangeLinkClient(void) = 0 ;
	virtual void __fastcall SetChangeLinkClient(System::TObject* const Value) = 0 ;
	virtual TVETChangeLinkFreeEvent __fastcall GetOnChangeLinkFree(void) = 0 ;
	virtual void __fastcall SetOnChangeLinkFree(const TVETChangeLinkFreeEvent Value) = 0 ;
	__property System::TObject* ChangeLinkServer = {read=GetChangeLinkServer, write=SetChangeLinkServer};
	__property System::TObject* ChangeLinkClient = {read=GetChangeLinkClient, write=SetChangeLinkClient};
	__property TVETChangeLinkEvent OnChangeLink = {read=GetOnChangeLink, write=SetOnChangeLink};
	__property TVETChangeLinkFreeEvent OnChangeLinkFree = {read=GetOnChangeLinkFree, write=SetOnChangeLinkFree};
};

class PASCALIMPLEMENTATION TVETChangeLink : public System::TInterfacedObject
{
	typedef System::TInterfacedObject inherited;
	
private:
	System::TObject* FChangeLinkServer;
	System::TObject* FChangeLinkClient;
	TVETChangeLinkEvent FOnChangeLink;
	TVETChangeLinkFreeEvent FOnChangeLinkFree;
	TVETChangeLinkEvent __fastcall GetOnChangeLink(void);
	void __fastcall SetOnChangeLink(const TVETChangeLinkEvent Value);
	System::TObject* __fastcall GetChangeLinkServer(void);
	void __fastcall SetChangeLinkClient(System::TObject* const Value);
	System::TObject* __fastcall GetChangeLinkClient(void);
	void __fastcall SetChangeLinkServer(System::TObject* const Value);
	TVETChangeLinkFreeEvent __fastcall GetOnChangeLinkFree(void);
	void __fastcall SetOnChangeLinkFree(const TVETChangeLinkFreeEvent Value);
	
public:
	__property TVETChangeLinkEvent OnChangeLink = {read=GetOnChangeLink, write=SetOnChangeLink};
	__property TVETChangeLinkFreeEvent OnChangeLinkFree = {read=GetOnChangeLinkFree, write=SetOnChangeLinkFree};
	__property System::TObject* ChangeLinkServer = {read=GetChangeLinkServer, write=SetChangeLinkServer};
	__property System::TObject* ChangeLinkClient = {read=GetChangeLinkClient, write=SetChangeLinkClient};
public:
	/* TObject.Create */ inline __fastcall TVETChangeLink(void) : System::TInterfacedObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TVETChangeLink(void) { }
	
private:
	void *__IVETChangeLink;	// IVETChangeLink 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {3C0AF30B-DA91-4F42-B02C-8A326704B368}
	operator _di_IVETChangeLink()
	{
		_di_IVETChangeLink intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator IVETChangeLink*(void) { return (IVETChangeLink*)&__IVETChangeLink; }
	#endif
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TVETChangeDispatch : public System::Classes::TInterfaceList
{
	typedef System::Classes::TInterfaceList inherited;
	
private:
	System::TObject* FInitialDispatcher;
	System::Classes::TInterfaceList* FChangeLinkCache;
	
protected:
	void __fastcall DispatchLinks(System::TObject* Server, Winapi::Shlobj::PItemIDList NewPIDL);
	int __fastcall FindLink(System::TObject* Server, System::TObject* Client);
	void __fastcall ReduceServerSet(System::TObject* Server);
	__property System::Classes::TInterfaceList* ChangeLinkCache = {read=FChangeLinkCache, write=FChangeLinkCache};
	__property System::TObject* InitialDispatcher = {read=FInitialDispatcher, write=FInitialDispatcher};
	
public:
	__fastcall TVETChangeDispatch(void);
	__fastcall virtual ~TVETChangeDispatch(void);
	void __fastcall DispatchChange(System::TObject* Server, Winapi::Shlobj::PItemIDList NewPIDL);
	void __fastcall RegisterChangeLink(System::TObject* Server, System::TObject* Client, TVETChangeLinkEvent ClientOnChangeEvent, TVETChangeLinkFreeEvent ChangeLinkFreeEvent);
	bool __fastcall UnRegisterChangeLink(System::TObject* Server, System::TObject* Client, TUnRegisterType UnRegisterType);
};

#pragma pack(pop)

typedef System::Set<TStorageType, TStorageType::stChecks, TStorageType::stUser> TStorageTypes;

typedef System::DynamicArray<System::Word> TVirtualWordArray;

typedef System::DynamicArray<bool> TBooleanArray;

typedef TVirtualWordArray TColumnWidths;

typedef TVirtualWordArray TColumnOrder;

typedef TVer1CheckStorage *PVer1CheckStorage;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TVer1CheckStorage
{
public:
	Virtualtrees::TCheckState CheckState;
};
#pragma pack(pop)


typedef TCheckStorage *PCheckStorage;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TCheckStorage
{
public:
	Virtualtrees::TCheckState CheckState;
	Virtualtrees::TCheckType CheckType;
};
#pragma pack(pop)


typedef TColumnStorage *PColumnStorage;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TColumnStorage
{
public:
	TVirtualWordArray Width;
	TVirtualWordArray Position;
	TBooleanArray Visible;
	int SortColumn;
	int SortDir;
	int DefaultSortDir;
};
#pragma pack(pop)


typedef TGroupStorage *PGroupStorage;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TGroupStorage
{
public:
	bool Enabled;
	int GroupColumn;
	int View;
};
#pragma pack(pop)


typedef TThumbnailStorage *PThumbnailStorage;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TThumbnailStorage
{
public:
	System::Types::TSize Size;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TUserDataStorage : public Mpshellutilities::TStreamableClass
{
	typedef Mpshellutilities::TStreamableClass inherited;
	
public:
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x6, bool WriteVerToStream = false);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
public:
	/* TStreamableClass.Create */ inline __fastcall TUserDataStorage(void) : Mpshellutilities::TStreamableClass() { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TUserDataStorage(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TUserDataStorageClass;

typedef TStorage *PStorage;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TStorage
{
public:
	TStorageTypes Types;
	TCheckStorage Check;
	TColumnStorage Column;
	TUserDataStorage* UserData;
	TGroupStorage Grouping;
	TThumbnailStorage Thumbnails;
	int Tag;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TNodeStorage : public Mpshellutilities::TStreamableClass
{
	typedef Mpshellutilities::TStreamableClass inherited;
	
private:
	TNodeStorageList* FChildNodeList;
	_ITEMIDLIST *FRelativePIDL;
	_ITEMIDLIST *FAbsolutePIDL;
	TNodeStorage* FParentNode;
	_di_IShellFolder FShellFolder;
	_di_IShellFolder __fastcall GetShellFolder(void);
	TRootNodeStorage* __fastcall GetRootNode(void);
	
public:
	TStorage Storage;
	HIDESBASE virtual void __fastcall Assign(TNodeStorage* Source);
	HIDESBASE virtual void __fastcall AssignTo(TNodeStorage* Destination);
	virtual void __fastcall Clear(bool FreeUserData = false);
	__fastcall virtual TNodeStorage(Winapi::Shlobj::PItemIDList AnAbsolutePIDL, TNodeStorage* AnOwnerNode);
	__fastcall virtual ~TNodeStorage(void);
	virtual void __fastcall LoadFromFile(System::WideString FileName, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToFile(System::WideString FileName, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x6, bool WriteVerToStream = false);
	__property Winapi::Shlobj::PItemIDList AbsolutePIDL = {read=FAbsolutePIDL, write=FAbsolutePIDL};
	__property TNodeStorageList* ChildNodeList = {read=FChildNodeList, write=FChildNodeList};
	__property TNodeStorage* ParentNode = {read=FParentNode, write=FParentNode};
	__property Winapi::Shlobj::PItemIDList RelativePIDL = {read=FRelativePIDL, write=FRelativePIDL};
	__property TRootNodeStorage* RootNode = {read=GetRootNode};
	__property _di_IShellFolder ShellFolder = {read=GetShellFolder};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TRootNodeStorage : public TNodeStorage
{
	typedef TNodeStorage inherited;
	
private:
	TNodeStorage* FCacheNode;
	System::Classes::TStringList* FCheckedFileNames;
	System::Classes::TStringList* FResolvedFileNames;
	Mpcommonobjects::TCommonPIDLList* FCheckedPIDLs;
	bool FStored;
	Mpcommonobjects::TCommonPIDLList* __fastcall GetCheckedPIDLs(void);
	void __fastcall SetCheckedPIDLs(Mpcommonobjects::TCommonPIDLList* const Value);
	System::Classes::TStrings* __fastcall GetCheckedFileNames(void);
	void __fastcall SetCheckFileNames(System::Classes::TStrings* const Value);
	System::Classes::TStrings* __fastcall GetResolvedFileNames(void);
	
protected:
	TNodeStorage* __fastcall ProcessNode(Winapi::Shlobj::PItemIDList RelativePIDL, TNodeStorage* CurrentNode, bool Force, bool MarkCheckMixed);
	TNodeStorage* __fastcall WalkPIDLToStorageNode(Winapi::Shlobj::PItemIDList PIDL, bool Force);
	__property TNodeStorage* CacheNode = {read=FCacheNode, write=FCacheNode};
	
public:
	__fastcall TRootNodeStorage(void);
	__fastcall virtual ~TRootNodeStorage(void);
	virtual void __fastcall Clear(bool FreeUserData = false);
	void __fastcall Delete(Winapi::Shlobj::PItemIDList APIDL, TStorageTypes StorageTypes, bool Force = false, bool FreeUserData = false);
	virtual TNodeStorage* __fastcall Find(Winapi::Shlobj::PItemIDList APIDL, TStorageTypes StorageTypes)/* overload */;
	virtual bool __fastcall Find(Winapi::Shlobj::PItemIDList APIDL, TStorageTypes StorageTypes, TNodeStorage* &StorageNode)/* overload */;
	bool __fastcall SetFileChecked(System::WideString FileName, Virtualtrees::TCheckType CheckBoxType);
	bool __fastcall SetPIDLChecked(Winapi::Shlobj::PItemIDList PIDL, Virtualtrees::TCheckType CheckBoxType);
	virtual TNodeStorage* __fastcall Store(Winapi::Shlobj::PItemIDList APIDL, TStorageTypes StorageTypes);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x0, bool ReadVerFromStream = false);
	__property System::Classes::TStrings* CheckedFileNames = {read=GetCheckedFileNames, write=SetCheckFileNames};
	__property System::Classes::TStrings* ResolvedFileNames = {read=GetResolvedFileNames};
	__property Mpcommonobjects::TCommonPIDLList* CheckedPIDLs = {read=GetCheckedPIDLs, write=SetCheckedPIDLs};
	__property bool Stored = {read=FStored, write=FStored, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TNodeStorageList : public Mpshellutilities::TStreamableList
{
	typedef Mpshellutilities::TStreamableList inherited;
	
public:
	TNodeStorage* operator[](int Index) { return this->Items[Index]; }
	
protected:
	TNodeStorage* __fastcall GetItems(int Index);
	void __fastcall SetItems(int Index, TNodeStorage* const Value);
	
public:
	virtual void __fastcall Clear(void);
	virtual void __fastcall LoadFromFile(System::WideString FileName, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToFile(System::WideString FileName, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x6, bool WriteVerToStream = false);
	__property TNodeStorage* Items[int Index] = {read=GetItems, write=SetItems/*, default*/};
public:
	/* TStreamableList.Create */ inline __fastcall TNodeStorageList(void) : Mpshellutilities::TStreamableList() { }
	
public:
	/* TList.Destroy */ inline __fastcall virtual ~TNodeStorageList(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TLeafNode : public Mpshellutilities::TStreamableClass
{
	typedef Mpshellutilities::TStreamableClass inherited;
	
private:
	bool FExpanded;
	_ITEMIDLIST *FPIDL;
	TLeafNodeList* FOwner;
	
public:
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x6, bool WriteVerToStream = false);
	__property bool Expanded = {read=FExpanded, write=FExpanded, nodefault};
	__property TLeafNodeList* Owner = {read=FOwner, write=FOwner};
	__property Winapi::Shlobj::PItemIDList PIDL = {read=FPIDL, write=FPIDL};
public:
	/* TStreamableClass.Create */ inline __fastcall TLeafNode(void) : Mpshellutilities::TStreamableClass() { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TLeafNode(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TLeafNodeList : public Mpshellutilities::TStreamableList
{
	typedef Mpshellutilities::TStreamableList inherited;
	
public:
	TLeafNode* operator[](int Index) { return this->Items[Index]; }
	
private:
	bool FShareNodes;
	TLeafNode* __fastcall GetItems(int Index);
	void __fastcall SetItems(int Index, TLeafNode* const Value);
	
public:
	void __fastcall AddLeafNode(Winapi::Shlobj::PItemIDList LeafPIDL, bool IsExpanded);
	virtual void __fastcall Clear(void);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x6, bool WriteVerToStream = false);
	__property bool ShareNodes = {read=FShareNodes, write=FShareNodes, nodefault};
	__property TLeafNode* Items[int Index] = {read=GetItems, write=SetItems/*, default*/};
public:
	/* TStreamableList.Create */ inline __fastcall TLeafNodeList(void) : Mpshellutilities::TStreamableList() { }
	
public:
	/* TList.Destroy */ inline __fastcall virtual ~TLeafNodeList(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TVETPersistent : public Mpshellutilities::TStreamableClass
{
	typedef Mpshellutilities::TStreamableClass inherited;
	
private:
	TLeafNodeList* FLeafNodes;
	Mpcommonobjects::TCommonPIDLList* FSelectedPIDLs;
	_ITEMIDLIST *FTopNodePIDL;
	System::WideString FRootFolderCustomPath;
	TRootFolder FRootFolder;
	_ITEMIDLIST *FSelectedPIDLsParent;
	TRootNodeStorage* FStorage;
	TVETPersistentStates FStates;
	_ITEMIDLIST *FRootFolderCustomPIDL;
	_ITEMIDLIST *FFocusPIDL;
	
protected:
	void __fastcall FullInitTree(TCustomVirtualExplorerTree* VET, bool DoInit);
	void __fastcall ReStoreLeafPIDLs(TCustomVirtualExplorerTree* VET, Virtualtrees::PVirtualNode RootNode);
	void __fastcall ReStoreSelectedPIDLs(TCustomVirtualExplorerTree* VET, Virtualtrees::PVirtualNode RootNode);
	Virtualtrees::PVirtualNode __fastcall StoreLeafPIDLs(TCustomVirtualExplorerTree* VET, Virtualtrees::PVirtualNode RootNode);
	void __fastcall StoreSelectedPIDLs(TCustomVirtualExplorerTree* VET, Virtualtrees::PVirtualNode RootNode);
	
public:
	__fastcall virtual TVETPersistent(void);
	__fastcall virtual ~TVETPersistent(void);
	virtual void __fastcall Clear(void);
	virtual void __fastcall LoadFromFile(System::WideString FileName, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x6, bool ReadVerFromStream = false);
	void __fastcall RestoreTree(TCustomVirtualExplorerTree* VET, bool RestoreSelection, bool RestoreFocus, bool ScrollToOldTopNode = false);
	void __fastcall RestoreTreeBranch(TCustomVirtualExplorerTree* VET, Virtualtrees::PVirtualNode Node, bool RestoreSelection);
	void __fastcall SaveTree(TCustomVirtualExplorerTree* VET, bool SaveSelection, bool SaveFocus);
	void __fastcall SaveTreeBranch(TCustomVirtualExplorerTree* VET, Virtualtrees::PVirtualNode Node, bool SaveSelection);
	virtual void __fastcall SaveToFile(System::WideString FileName, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x6, bool WriteVerToStream = false);
	__property Winapi::Shlobj::PItemIDList FocusPIDL = {read=FFocusPIDL, write=FFocusPIDL};
	__property TLeafNodeList* LeafNodes = {read=FLeafNodes};
	__property TRootFolder RootFolder = {read=FRootFolder, write=FRootFolder, nodefault};
	__property System::WideString RootFolderCustomPath = {read=FRootFolderCustomPath, write=FRootFolderCustomPath};
	__property Winapi::Shlobj::PItemIDList RootFolderCustomPIDL = {read=FRootFolderCustomPIDL, write=FRootFolderCustomPIDL};
	__property Mpcommonobjects::TCommonPIDLList* SelectedPIDLs = {read=FSelectedPIDLs};
	__property Winapi::Shlobj::PItemIDList SelectedPIDLsParent = {read=FSelectedPIDLsParent};
	__property TRootNodeStorage* Storage = {read=FStorage, write=FStorage};
	__property TVETPersistentStates States = {read=FStates, write=FStates, nodefault};
	__property Winapi::Shlobj::PItemIDList TopNodePIDL = {read=FTopNodePIDL, write=FTopNodePIDL};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TView : public TVETPersistent
{
	typedef TVETPersistent inherited;
	
private:
	System::WideString FViewName;
	
public:
	__fastcall TView(System::WideString AViewName);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x6, bool WriteVerToStream = false);
	__property System::WideString ViewName = {read=FViewName, write=FViewName};
public:
	/* TVETPersistent.Destroy */ inline __fastcall virtual ~TView(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TViewList : public Mpshellutilities::TStreamableList
{
	typedef Mpshellutilities::TStreamableList inherited;
	
private:
	TView* __fastcall GetItems(int Index);
	void __fastcall SetItems(int Index, TView* const Value);
	
public:
	__fastcall virtual ~TViewList(void);
	virtual void __fastcall LoadFromFile(System::WideString FileName, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x6, bool WriteVerToStream = false);
	virtual void __fastcall SaveToFile(System::WideString FileName, int Version = 0x6, bool ReadVerFromStream = false);
	__property TView* Items[int Index] = {read=GetItems, write=SetItems};
public:
	/* TStreamableList.Create */ inline __fastcall TViewList(void) : Mpshellutilities::TStreamableList() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TViewManager : public Mpshellutilities::TStreamableClass
{
	typedef Mpshellutilities::TStreamableClass inherited;
	
private:
	TViewList* FViews;
	TView* __fastcall GetView(System::WideString ViewName);
	int __fastcall GetViewCount(void);
	System::WideString __fastcall GetViewName(int Index);
	void __fastcall SetViewName(int Index, System::WideString NewViewName);
	
protected:
	__property TViewList* Views = {read=FViews, write=FViews};
	
public:
	virtual void __fastcall Clear(void);
	__fastcall TViewManager(void);
	__fastcall virtual ~TViewManager(void);
	void __fastcall DeleteView(System::WideString ViewName);
	virtual void __fastcall LoadFromFile(System::WideString FileName, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall ShowView(System::WideString ViewName, TCustomVirtualExplorerTree* VET);
	virtual void __fastcall Snapshot(System::WideString NewViewName, TCustomVirtualExplorerTree* VET);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x6, bool WriteVerToStream = false);
	virtual void __fastcall SaveToFile(System::WideString FileName, int Version = 0x6, bool ReadVerFromStream = false);
	__property TView* View[System::WideString ViewName] = {read=GetView};
	__property int ViewCount = {read=GetViewCount, nodefault};
	__property System::WideString ViewName[int Index] = {read=GetViewName, write=SetViewName};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGlobalViewManager : public TViewManager
{
	typedef TViewManager inherited;
	
public:
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x6, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x6, bool WriteVerToStream = false);
	virtual void __fastcall ShowView(System::WideString ViewName, TCustomVirtualExplorerTree* VET);
	virtual void __fastcall Snapshot(System::WideString NewViewName, TCustomVirtualExplorerTree* VET);
public:
	/* TViewManager.Create */ inline __fastcall TGlobalViewManager(void) : TViewManager() { }
	/* TViewManager.Destroy */ inline __fastcall virtual ~TGlobalViewManager(void) { }
	
};

#pragma pack(pop)

typedef System::DynamicArray<System::Word> TClipboardFormats;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TVETDataObject : public Virtualtrees::TVTDataObject
{
	typedef Virtualtrees::TVTDataObject inherited;
	
private:
	_di_IDataObject FShellDataObject;
	
public:
	virtual HRESULT __stdcall DAdvise(const tagFORMATETC &FormatEtc, int advf, const _di_IAdviseSink advSink, /* out */ int &dwConnection);
	virtual HRESULT __stdcall DUnadvise(int dwConnection);
	virtual HRESULT __stdcall EnumDAdvise(/* out */ _di_IEnumSTATDATA &enumAdvise);
	virtual HRESULT __stdcall EnumFormatEtc(int Direction, /* out */ _di_IEnumFORMATETC &EnumFormatEtc);
	virtual HRESULT __stdcall GetCanonicalFormatEtc(const tagFORMATETC &FormatEtc, /* out */ tagFORMATETC &FormatEtcOut);
	virtual HRESULT __stdcall GetData(const tagFORMATETC &FormatEtcIn, /* out */ tagSTGMEDIUM &Medium);
	virtual HRESULT __stdcall GetDataHere(const tagFORMATETC &FormatEtc, /* out */ tagSTGMEDIUM &Medium);
	virtual HRESULT __stdcall QueryGetData(const tagFORMATETC &FormatEtc);
	virtual HRESULT __stdcall SetData(const tagFORMATETC &FormatEtc, tagSTGMEDIUM &Medium, System::LongBool DoRelease);
	__property _di_IDataObject ShellDataObject = {read=FShellDataObject, write=FShellDataObject};
public:
	/* TVTDataObject.Create */ inline __fastcall virtual TVETDataObject(Virtualtrees::TBaseVirtualTree* AOwner, bool ForClipboard) : Virtualtrees::TVTDataObject(AOwner, ForClipboard) { }
	/* TVTDataObject.Destroy */ inline __fastcall virtual ~TVETDataObject(void) { }
	
};

#pragma pack(pop)

typedef System::StaticArray<System::Uitypes::TColor, 4> TVETColorArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TVETColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TVETColorArray FVETColors;
	TCustomVirtualExplorerTree* FOwner;
	System::Uitypes::TColor __fastcall GetVETColor(const int Index);
	void __fastcall SetVETColor(const int Index, const System::Uitypes::TColor Value);
	
protected:
	__property TCustomVirtualExplorerTree* Owner = {read=FOwner, write=FOwner};
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	__fastcall TVETColors(TCustomVirtualExplorerTree* AnOwner);
	__fastcall virtual ~TVETColors(void);
	
__published:
	__property System::Uitypes::TColor CompressedTextColor = {read=GetVETColor, write=SetVETColor, index=0, default=255};
	__property System::Uitypes::TColor FolderTextColor = {read=GetVETColor, write=SetVETColor, index=1, default=-16777208};
	__property System::Uitypes::TColor FileTextColor = {read=GetVETColor, write=SetVETColor, index=2, default=-16777208};
	__property System::Uitypes::TColor EncryptedTextColor = {read=GetVETColor, write=SetVETColor, index=3, default=32832};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TColumnMenuItem : public Vcl::Menus::TMenuItem
{
	typedef Vcl::Menus::TMenuItem inherited;
	
private:
	int FColumnIndex;
	
public:
	virtual void __fastcall Click(void);
	void __fastcall LiveVETUpdate(System::TObject* Sender);
	void __fastcall UpdateColumns(TCustomVirtualExplorerTree* VET, Virtualtrees::TVirtualStringTree* VST);
	__property int ColumnIndex = {read=FColumnIndex, write=FColumnIndex, nodefault};
public:
	/* TMenuItem.Create */ inline __fastcall virtual TColumnMenuItem(System::Classes::TComponent* AOwner) : Vcl::Menus::TMenuItem(AOwner) { }
	/* TMenuItem.Destroy */ inline __fastcall virtual ~TColumnMenuItem(void) { }
	
};


class PASCALIMPLEMENTATION TColumnMenu : public Vcl::Menus::TPopupMenu
{
	typedef Vcl::Menus::TPopupMenu inherited;
	
private:
	TCustomVirtualExplorerTree* FVET;
	
public:
	__fastcall TColumnMenu(TCustomVirtualExplorerTree* AOwner);
	virtual void __fastcall Popup(int X, int Y);
	__property TCustomVirtualExplorerTree* VET = {read=FVET};
public:
	/* TPopupMenu.Destroy */ inline __fastcall virtual ~TColumnMenu(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TVETHeader : public Virtualtrees::TVTHeader
{
	typedef Virtualtrees::TVTHeader inherited;
	
protected:
	virtual bool __fastcall CanWriteColumns(void);
public:
	/* TVTHeader.Create */ inline __fastcall virtual TVETHeader(Virtualtrees::TBaseVirtualTree* AOwner) : Virtualtrees::TVTHeader(AOwner) { }
	/* TVTHeader.Destroy */ inline __fastcall virtual ~TVETHeader(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TVETColumn : public Virtualtrees::TVirtualTreeColumn
{
	typedef Virtualtrees::TVirtualTreeColumn inherited;
	
private:
	TColumnDetails FColumnDetails;
	void __fastcall SetColumnDetails(const TColumnDetails Value);
	
public:
	__fastcall virtual TVETColumn(System::Classes::TCollection* Collection);
	
__published:
	__property TColumnDetails ColumnDetails = {read=FColumnDetails, write=SetColumnDetails, nodefault};
public:
	/* TVirtualTreeColumn.Destroy */ inline __fastcall virtual ~TVETColumn(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TVETColumnClass;

typedef System::DynamicArray<TColumnWidthInfo> TColumnsWidths;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TColumnManager : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TColumnsWidths FColumnWidths;
	TCustomVirtualExplorerTree* FVET;
	
protected:
	void __fastcall StoreColumnWidth(int Column);
	void __fastcall ValidateColumnWidths(void);
	__property TColumnsWidths ColumnWidths = {read=FColumnWidths, write=FColumnWidths};
	__property TCustomVirtualExplorerTree* VET = {read=FVET, write=FVET};
	
public:
	__fastcall TColumnManager(TCustomVirtualExplorerTree* AnOwner);
	__fastcall virtual ~TColumnManager(void);
	void __fastcall ToggleWidthAutoFit(int ColumnIndex);
	void __fastcall ToggleWidthMinimize(int ColumnIndex);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TContextMenuManager : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Virtualtrees::TVirtualNode *FActiveNode;
	Virtualtrees::TVirtualNode *FPreviousSelectedNode;
	TCustomVirtualExplorerTree* FOwner;
	Virtualtrees::TVirtualNode *FPreviousFocusNode;
	bool FIsEditingNode;
	bool FEnabled;
	bool FMenuPending;
	
protected:
	bool FMenuShown;
	void __fastcall ContextMenuCmdCallback(Mpshellutilities::TNamespace* Namespace, System::WideString Verb, int MenuItemID, bool &Handled);
	void __fastcall ContextMenuShowCallback(Mpshellutilities::TNamespace* Namespace, HMENU Menu, bool &Allow);
	void __fastcall ContextMenuAfterCmdCallback(Mpshellutilities::TNamespace* Namespace, System::WideString Verb, int MenuItemID, bool Successful);
	void __fastcall ShowContextMenu(Mpshellutilities::TNamespace* NS, System::Types::PPoint Position = (System::Types::PPoint)(0x0));
	
public:
	System::Types::TPoint __fastcall CalculatePopupPoint(Virtualtrees::PVirtualNode Node);
	__fastcall TContextMenuManager(TCustomVirtualExplorerTree* AnOwner);
	void __fastcall HandleContextMenuMsg(int Msg, int wParam, int lParam, NativeInt &Result);
	void __fastcall MenuSelect(int Msg, int wParam, int lParam, NativeInt &Result);
	void __fastcall ResetState(void);
	void __fastcall RightClick(int XPos, int YPos, TButtonState ButtonState, TCoordType Coordinates);
	bool __fastcall ShowContextMenuOfActiveNode(const System::Types::TPoint &Point);
	bool __fastcall ShowContextMenuOfSelectedItem(void);
	__property Virtualtrees::PVirtualNode ActiveNode = {read=FActiveNode};
	__property bool Enabled = {read=FEnabled, write=FEnabled, nodefault};
	__property bool IsEditingNode = {read=FIsEditingNode, write=FIsEditingNode, nodefault};
	__property bool MenuPending = {read=FMenuPending, write=FMenuPending, nodefault};
	__property bool MenuShown = {read=FMenuShown, nodefault};
	__property TCustomVirtualExplorerTree* Owner = {read=FOwner};
	__property Virtualtrees::PVirtualNode PreviousFocusNode = {read=FPreviousFocusNode};
	__property Virtualtrees::PVirtualNode PreviousSelectedNode = {read=FPreviousSelectedNode};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TContextMenuManager(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TCustomVirtualExplorerTreeOptions : public Virtualtrees::TStringTreeOptions
{
	typedef Virtualtrees::TStringTreeOptions inherited;
	
private:
	bool FForceMultiLevelMultiSelect;
	TVETFolderOptions FVETFolderOptions;
	TVETImageOptions FVETImageOptions;
	TVETMiscOptions FVETMiscOptions;
	TVETShellOptions FVETShellOptions;
	TVETSyncOptions FVETSyncOptions;
	void __fastcall SetVETFolderOptions(const TVETFolderOptions Value);
	void __fastcall SetVETImageOptions(const TVETImageOptions Value);
	void __fastcall SetVETMiscOptions(const TVETMiscOptions Value);
	void __fastcall SetVETShellOptions(const TVETShellOptions Value);
	HIDESBASE TCustomVirtualExplorerTree* __fastcall GetOwner(void);
	Virtualtrees::TVTAutoOptions __fastcall GetAutoOptions(void);
	HIDESBASE void __fastcall SetAutoOptions(const Virtualtrees::TVTAutoOptions Value);
	Virtualtrees::TVTSelectionOptions __fastcall GetSelectionOptions(void);
	HIDESBASE void __fastcall SetSelectionOptions(const Virtualtrees::TVTSelectionOptions Value);
	
protected:
	__property Virtualtrees::TVTAutoOptions AutoOptions = {read=GetAutoOptions, write=SetAutoOptions, default=1369};
	__property Virtualtrees::TVTSelectionOptions SelectionOptions = {read=GetSelectionOptions, write=SetSelectionOptions, default=0};
	__property TVETFolderOptions VETFolderOptions = {read=FVETFolderOptions, write=SetVETFolderOptions, default=1};
	__property TVETShellOptions VETShellOptions = {read=FVETShellOptions, write=SetVETShellOptions, nodefault};
	__property TVETMiscOptions VETMiscOptions = {read=FVETMiscOptions, write=SetVETMiscOptions, nodefault};
	__property TVETImageOptions VETImageOptions = {read=FVETImageOptions, write=SetVETImageOptions, nodefault};
	__property TVETSyncOptions VETSyncOptions = {read=FVETSyncOptions, write=FVETSyncOptions, nodefault};
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	__property bool ForceMultiLevelMultiSelect = {read=FForceMultiLevelMultiSelect, write=FForceMultiLevelMultiSelect, nodefault};
	__property TCustomVirtualExplorerTree* Owner = {read=GetOwner};
public:
	/* TCustomStringTreeOptions.Create */ inline __fastcall virtual TCustomVirtualExplorerTreeOptions(Virtualtrees::TBaseVirtualTree* AOwner) : Virtualtrees::TStringTreeOptions(AOwner) { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TCustomVirtualExplorerTreeOptions(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TVirtualExplorerTreeOptions : public TCustomVirtualExplorerTreeOptions
{
	typedef TCustomVirtualExplorerTreeOptions inherited;
	
__published:
	__property AnimationOptions = {default=0};
	__property AutoOptions = {default=1369};
	__property MiscOptions = {default=16809};
	__property PaintOptions = {default=7008};
	__property SelectionOptions = {default=0};
	__property StringOptions = {default=5};
	__property VETFolderOptions = {default=1};
	__property VETShellOptions;
	__property VETSyncOptions;
	__property VETMiscOptions;
	__property VETImageOptions;
public:
	/* TCustomStringTreeOptions.Create */ inline __fastcall virtual TVirtualExplorerTreeOptions(Virtualtrees::TBaseVirtualTree* AOwner) : TCustomVirtualExplorerTreeOptions(AOwner) { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TVirtualExplorerTreeOptions(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TVirtualExplorerEditLink : public Virtualtrees::TStringEditLink
{
	typedef Virtualtrees::TStringEditLink inherited;
	
public:
	/* TStringEditLink.Create */ inline __fastcall virtual TVirtualExplorerEditLink(void) : Virtualtrees::TStringEditLink() { }
	/* TStringEditLink.Destroy */ inline __fastcall virtual ~TVirtualExplorerEditLink(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TVirtualShellBackgroundContextMenu : public Mpshellutilities::TCommonShellBackgroundContextMenu
{
	typedef Mpshellutilities::TCommonShellBackgroundContextMenu inherited;
	
public:
	/* TCommonShellBackgroundContextMenu.Create */ inline __fastcall virtual TVirtualShellBackgroundContextMenu(System::Classes::TComponent* AOwner) : Mpshellutilities::TCommonShellBackgroundContextMenu(AOwner) { }
	/* TCommonShellBackgroundContextMenu.Destroy */ inline __fastcall virtual ~TVirtualShellBackgroundContextMenu(void) { }
	
};


class PASCALIMPLEMENTATION TVirtualShellMultiParentContextMenu : public Mpshellutilities::TCommonShellMultiParentContextMenu
{
	typedef Mpshellutilities::TCommonShellMultiParentContextMenu inherited;
	
public:
	/* TCommonShellContextMenu.Create */ inline __fastcall virtual TVirtualShellMultiParentContextMenu(System::Classes::TComponent* AOwner) : Mpshellutilities::TCommonShellMultiParentContextMenu(AOwner) { }
	/* TCommonShellContextMenu.Destroy */ inline __fastcall virtual ~TVirtualShellMultiParentContextMenu(void) { }
	
};


typedef TNodeData *PNodeData;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TNodeData
{
public:
	int ReservedForTCustomVirtualStringTree;
	Mpshellutilities::TNamespace* Namespace;
	TColumnManager* ColumnManager;
};
#pragma pack(pop)


typedef void __fastcall (__closure *TVETOnCustomColumnCompare)(TCustomVirtualExplorerTree* Sender, Virtualtrees::TColumnIndex Column, Virtualtrees::PVirtualNode Node1, Virtualtrees::PVirtualNode Node2, int &Result);

typedef void __fastcall (__closure *TVETOnHeaderRebuild)(TCustomVirtualExplorerTree* Sender, Virtualtrees::TVTHeader* Header);

typedef void __fastcall (__closure *TVETOnShellExecute)(TCustomVirtualExplorerTree* Sender, Mpshellutilities::TNamespace* Namespace, System::WideString &WorkingDir, System::WideString &CmdLineArgument, bool &Allow);

typedef void __fastcall (__closure *TVETOnShellNotify)(TCustomVirtualExplorerTree* Sender, Virtualshellnotifier::TVirtualShellEvent* ShellEvent);

typedef void __fastcall (__closure *TVETOnEnumFolder)(TCustomVirtualExplorerTree* Sender, Mpshellutilities::TNamespace* Namespace, bool &AllowAsChild);

typedef void __fastcall (__closure *TVETEnumFinishedEvent)(TCustomVirtualExplorerTree* Sender);

typedef void __fastcall (__closure *TVETEnumLenghyOperaionEvent)(TCustomVirtualExplorerTree* Sender, bool &ShowAnimation);

typedef void __fastcall (__closure *TVETOnContextMenuAfterCmd)(TCustomVirtualExplorerTree* Sender, Mpshellutilities::TNamespace* Namespace, System::WideString Verb, int MenuItemID, bool Successful);

typedef void __fastcall (__closure *TVETOnContextMenuCmd)(TCustomVirtualExplorerTree* Sender, Mpshellutilities::TNamespace* Namespace, System::WideString Verb, int MenuItemID, bool &Handled);

typedef void __fastcall (__closure *TVETOnContextMenuShow)(TCustomVirtualExplorerTree* Sender, Mpshellutilities::TNamespace* Namespace, HMENU Menu, bool &Allow);

typedef void __fastcall (__closure *TVETContextMenuItemChange)(TCustomVirtualExplorerTree* Sender, Mpshellutilities::TNamespace* Namespace, int MenuItemID, HMENU SubMenuID, bool MouseSelect);

typedef void __fastcall (__closure *TVETOnCustomNamespace)(TCustomVirtualExplorerTree* Sender, Virtualtrees::PVirtualNode AParentNode);

typedef void __fastcall (__closure *TVETOnDrawNodeText)(TCustomVirtualExplorerTree* Sender, Virtualtrees::TColumnIndex Column, Virtualtrees::PVirtualNode Node, Mpshellutilities::TNamespace* Namespace, System::UnicodeString &Text);

typedef void __fastcall (__closure *TVETOnTreeDblClick)(TCustomVirtualExplorerTree* Sender, Virtualtrees::PVirtualNode Node, System::Uitypes::TMouseButton Button, const System::Types::TPoint &Point);

typedef void __fastcall (__closure *TVETOnRootChange)(TCustomVirtualExplorerTree* Sender);

typedef void __fastcall (__closure *TVETOnRootChanging)(TCustomVirtualExplorerTree* Sender, const TRootFolder NewValue, Mpshellutilities::TNamespace* const CurrentNamespace, Mpshellutilities::TNamespace* const Namespace, bool &Allow);

typedef void __fastcall (__closure *TVETOnRootRebuild)(TCustomVirtualExplorerTree* Sender);

typedef void __fastcall (__closure *TVETOnClipboardCopy)(TCustomVirtualExplorerTree* Sender, bool &Handled);

typedef void __fastcall (__closure *TVETOnClipboardCut)(TCustomVirtualExplorerTree* Sender, bool &MarkSelectedCut, bool &Handled);

typedef void __fastcall (__closure *TVETOnClipboardPaste)(TCustomVirtualExplorerTree* Sender, bool &Handled);

typedef void __fastcall (__closure *TNamespaceStructureChangeEvent)(TCustomVirtualExplorerTree* Sender, Virtualtrees::PVirtualNode Node, Mpshellutilities::TNamespace* NS, TNamespaceStructureChange ChangeType);

typedef void __fastcall (__closure *TOnPopupRollDown)(System::TObject* Sender, bool &Allow);

typedef void __fastcall (__closure *TOnPopupRollUp)(System::TObject* Sender, bool Selected);

typedef void __fastcall (__closure *TVETOnComboInvalidEntry)(TCustomVirtualExplorerCombobox* Sender, System::WideString EnteredText);

typedef void __fastcall (__closure *TOnAutoCompleteUpdateList)(System::TObject* Sender, const System::WideString CurrentEditContents, System::Classes::TStringList* EnumList, bool &Handled);

typedef void __fastcall (__closure *TVETComboBoxDecodeSpecialVariableEvent)(TCustomVirtualExplorerCombobox* Sender, System::WideString Variable, Mpshellutilities::TNamespace* &NS);

typedef void __fastcall (__closure *TOnComboPathChange)(TCustomVirtualExplorerCombobox* Sender, Mpshellutilities::TNamespace* SelectedNamespace);

typedef void __fastcall (__closure *TOnComboPathChanging)(TCustomVirtualExplorerCombobox* Sender, Mpshellutilities::TNamespace* PrevNamespace, bool &Allow);

typedef void __fastcall (__closure *TVETOnComboDraw)(TCustomVirtualExplorerCombobox* Sender, Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &AClientRect, const System::Types::TRect &AButtonRect, TVETComboStates AComboState, Vcl::Comctrls::TCustomDrawStage Stage, bool &DefaultDraw);

class PASCALIMPLEMENTATION TCustomVirtualExplorerTree : public Virtualtrees::TCustomVirtualStringTree
{
	typedef Virtualtrees::TCustomVirtualStringTree inherited;
	
private:
	bool FActive;
	bool FActivated;
	bool FAltKeyDown;
	Vcl::Comctrls::TAnimate* FAnimateFolderEnum;
	bool FAutoFireChangeLink;
	TVirtualShellBackgroundContextMenu* FBackGndMenu;
	int FCurrentUpdateCount;
	_di_IDataObject FDragDataObject;
	Mpcommonobjects::TCommonPIDLList* FEnumBkGndList;
	unsigned FEnumBkGndTime;
	_RTL_CRITICAL_SECTION FEnumLock;
	TVirtualBackGndEnumThread* FEnumThread;
	NativeUInt FEnumTimer;
	System::Classes::TNotifyEvent FOnColumnUserChangedVisiblility;
	TVETEnumFinishedEvent FOnEnumFinished;
	TVETEnumLenghyOperaionEvent FOnEnumThreadLengthyOperation;
	int FDragMouseButton;
	bool FDropping;
	Virtualtrees::TVirtualNode *FLastDropTargetNode;
	int FLastDragEffect;
	bool FShellNotifySuspended;
	bool FThreadedExpandMarkEnabled;
	bool FThreadedEnum;
	int FUnknownFileIconIndex;
	int FUnknownFolderIconIndex;
	Mpshellutilities::TFileObjects FFileObjects;
	int FRebuildRootNamespaceCount;
	TRootFolder FRootFolder;
	System::WideString FRootFolderCustomPath;
	_ITEMIDLIST *FRootFolderCustomPIDL;
	Mpshellutilities::TNamespace* FRootFolderNamespace;
	Mpshellutilities::TNamespace* FTempRootNamespace;
	TVETPersistent* FVETPersistent;
	TViewManager* FViewManager;
	TFileSizeFormat FFileSizeFormat;
	Mpshellutilities::TFileSort FFileSort;
	TVETColors* FVETColors;
	TColumnDetailType FColumnDetails;
	int FWaitCursorRef;
	TColumnMenu* FColumnMenu;
	int FColumnMenuItemCount;
	TContextMenuManager* FContextMenuManager;
	bool FCreatingHeaders;
	int FShellBaseColumnCount;
	TCustomVirtualExplorerTree* FVirtualExplorerTree;
	TCustomVirtualExplorerCombobox* FExplorerComboBox;
	System::Classes::TStrings* FSelectedPaths;
	System::Classes::TStrings* FSelectedFiles;
	TVETOnClipboardCopy FOnClipboardCopy;
	TVETOnClipboardCut FOnClipboardCut;
	TVETOnClipboardPaste FOnClipboardPaste;
	TVETOnContextMenuAfterCmd FOnContextMenuAfterCmd;
	TVETOnContextMenuCmd FOnContextMenuCmd;
	TVETContextMenuItemChange FOnContextMenuItemChange;
	TVETOnContextMenuShow FOnContextMenuShow;
	TVETOnCustomColumnCompare FOnCustomColumnCompare;
	TVETOnCustomNamespace FOnCustomNamespace;
	TVETOnDrawNodeText FOnDrawNodeText;
	TVETOnEnumFolder FOnEnumFilter;
	TVETOnHeaderRebuild FOnHeaderRebuild;
	TVETOnRootChange FOnRootChange;
	TVETOnRootChanging FOnRootChanging;
	TVETOnShellExecute FOnShellExecute;
	TVETOnShellNotify FOnAfterShellNotify;
	TVETOnShellNotify FOnShellNotify;
	TVETOnTreeDblClick FOnTreeDblClick;
	TVETStates FVETState;
	bool FDisableWaitCursors;
	TVETOnRootRebuild FOnRootRebuild;
	NativeUInt FShellNotifyTimerHandle;
	System::Classes::TList* FShellNotifyQueue;
	bool FExpandingByButtonClick;
	Vcl::Menus::TPopupMenu* FShellContextSubMenu;
	System::WideString FShellContextSubMenuCaption;
	bool FChangeNotifierEnabled;
	bool FThreadedImagesEnabled;
	int FChangeNotifierCount;
	Mpshellutilities::TShellSortHelper* FSortHelper;
	_di_IMalloc FMalloc;
	TNamespaceStructureChangeEvent FOnNamespaceStructureChange;
	System::Classes::TNotifyEvent FOnInvalidRootNamespace;
	bool __fastcall GetContextMenuShown(void);
	int __fastcall GetNodeDataSize(void);
	bool __fastcall GetOkToShellNotifyDispatch(void);
	HIDESBASE TVirtualExplorerTreeOptions* __fastcall GetOptions(void);
	Virtualtrees::PVirtualNode __fastcall GetRecycleBinNode(void);
	System::WideString __fastcall GetSelectedFile(void);
	System::Classes::TStrings* __fastcall GetSelectedFiles(void);
	System::Classes::TStrings* __fastcall GetSelectedPaths(void);
	System::WideString __fastcall GetSelectedPath(void);
	Winapi::Shlobj::PItemIDList __fastcall GetSelectedPIDL(void);
	bool __fastcall GetThreadedExpandMarkEnabled(void);
	Virtualtrees::PVirtualNode __fastcall InternalWalkPIDLToNode(Winapi::Shlobj::PItemIDList PIDL);
	void __fastcall SetChangeNotiferEnabled(const bool Value);
	void __fastcall SetDisableWaitCursors(const bool Value);
	void __fastcall SetFileObjects(const Mpshellutilities::TFileObjects Value);
	void __fastcall SetFileSizeFormat(const TFileSizeFormat Value);
	void __fastcall SetFileSort(const Mpshellutilities::TFileSort Value);
	HIDESBASE void __fastcall SetNodeDataSize(const int Value);
	HIDESBASE void __fastcall SetOptions(TVirtualExplorerTreeOptions* const Value);
	void __fastcall SetRootFolder(const TRootFolder Value);
	void __fastcall SetRootFolderCustomPath(const System::WideString Value);
	void __fastcall SetRootFolderCustomPIDL(const Winapi::Shlobj::PItemIDList Value);
	void __fastcall SetThreadedExpandMarkEnabled(bool Value);
	void __fastcall SetThreadedImagesEnabled(const bool Value);
	void __fastcall SetVirtualExplorerTree(TCustomVirtualExplorerTree* const Value);
	void __fastcall SetColumnDetails(const TColumnDetailType Value);
	void __fastcall SetExplorerComboBox(TCustomVirtualExplorerCombobox* const Value);
	TRootNodeStorage* __fastcall GetNewStorage(void);
	__property Mpshellutilities::TNamespace* TempRootNamespace = {read=FTempRootNamespace, write=FTempRootNamespace};
	
protected:
	unsigned __fastcall BuildEnumFlags(void);
	virtual bool __fastcall CanShowDragImage(void);
	virtual int __fastcall ShowBkGndContextMenu(const System::Types::TPoint &Point);
	void __fastcall ActivateTree(bool Activate);
	void __fastcall AddMyDocumentsFolder(Virtualtrees::PVirtualNode FolderNode, bool DesktopFolderOnly);
	void __fastcall AfterValidEnumIDList(System::TObject* Sender);
	void __fastcall CollapseNamespaceFolder(Virtualtrees::PVirtualNode Node);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	void __fastcall DeleteNodeByPIDL(Winapi::Shlobj::PItemIDList PIDL);
	virtual void __fastcall DestroyWnd(void);
	virtual bool __fastcall DoBeforeDrag(Virtualtrees::PVirtualNode Node, Virtualtrees::TColumnIndex Column);
	virtual void __fastcall DoCanEdit(Virtualtrees::PVirtualNode Node, Virtualtrees::TColumnIndex Column, bool &Allowed);
	virtual void __fastcall DoChange(Virtualtrees::PVirtualNode Node);
	virtual void __fastcall DoChecked(Virtualtrees::PVirtualNode Node);
	virtual void __fastcall DoClipboardCopy(bool &Handled);
	virtual void __fastcall DoClipboardCut(bool &MarkSelectedCut, bool &Handled);
	virtual void __fastcall DoClipboardPaste(bool &Handled);
	virtual void __fastcall DoCollapsed(Virtualtrees::PVirtualNode Node);
	virtual bool __fastcall DoCollapsing(Virtualtrees::PVirtualNode Node);
	virtual void __fastcall DoColumnResize(Virtualtrees::TColumnIndex Column);
	virtual void __fastcall DoColumnUserChangedVisibility(void);
	virtual int __fastcall DoCompare(Virtualtrees::PVirtualNode Node1, Virtualtrees::PVirtualNode Node2, Virtualtrees::TColumnIndex Column);
	void __fastcall DoContextMenuAfterCmd(Mpshellutilities::TNamespace* Namespace, System::WideString Verb, int MenuItemID, bool Successful);
	bool __fastcall DoContextMenuCmd(Mpshellutilities::TNamespace* Namespace, System::WideString Verb, int MenuItemID);
	void __fastcall DoContextMenuSelect(Mpshellutilities::TNamespace* Namespace, int MenuItemID, HMENU SubMenuID, bool MouseSelect);
	bool __fastcall DoContextMenuShow(Mpshellutilities::TNamespace* Namespace, HMENU Menu);
	virtual _di_IDataObject __fastcall DoCreateDataObject(void);
	virtual void __fastcall DoCustomColumnCompare(Virtualtrees::TColumnIndex Column, Virtualtrees::PVirtualNode Node1, Virtualtrees::PVirtualNode Node2, int &Result);
	virtual void __fastcall DoCustomNamespace(Virtualtrees::PVirtualNode AParentNode);
	DYNAMIC void __fastcall DoEndDrag(System::TObject* Target, int X, int Y);
	virtual void __fastcall DoEdit(void);
	virtual void __fastcall DoEnumFolder(Mpshellutilities::TNamespace* const Namespace, bool &AllowAsChild);
	virtual bool __fastcall DoExpanding(Virtualtrees::PVirtualNode Node);
	void __fastcall DoEnumThreadLengthyOperation(bool &ShowAnimation);
	virtual void __fastcall DoFreeNode(Virtualtrees::PVirtualNode Node);
	virtual Vcl::Imglist::TCustomImageList* __fastcall DoGetImageIndex(Virtualtrees::PVirtualNode Node, Virtualtrees::TVTImageKind Kind, Virtualtrees::TColumnIndex Column, bool &Ghosted, System::Uitypes::TImageIndex &Index);
	virtual System::UnicodeString __fastcall DoGetNodeHint(Virtualtrees::PVirtualNode Node, Virtualtrees::TColumnIndex Column, Virtualtrees::TVTTooltipLineBreakStyle &LineBreakStyle);
	virtual Vcl::Menus::TPopupMenu* __fastcall DoGetPopupMenu(Virtualtrees::PVirtualNode Node, Virtualtrees::TColumnIndex Column, const System::Types::TPoint &Position);
	virtual void __fastcall DoGetText(Virtualtrees::TVSTGetCellTextEventArgs &pEventArgs);
	void __fastcall DoGetVETText(Virtualtrees::TColumnIndex Column, Virtualtrees::PVirtualNode Node, Mpshellutilities::TNamespace* Namespace, System::UnicodeString &Text);
	virtual void __fastcall DoInvalidRootNamespace(void);
	virtual void __fastcall DoHeaderClick(const Virtualtrees::TVTHeaderHitInfo &HitInfo);
	virtual void __fastcall DoHeaderMouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall DoHeaderRebuild(void);
	virtual bool __fastcall DoInitChildren(Virtualtrees::PVirtualNode Node, unsigned &ChildCount);
	virtual void __fastcall DoInitNode(Virtualtrees::PVirtualNode Parent, Virtualtrees::PVirtualNode Node, Virtualtrees::TVirtualNodeInitStates &InitStates);
	virtual bool __fastcall DoKeyAction(System::Word &CharCode, System::Classes::TShiftState &Shift);
	virtual void __fastcall DoNamespaceStructureChange(Virtualtrees::PVirtualNode Node, Mpshellutilities::TNamespace* NS, TNamespaceStructureChange ChangeType);
	virtual void __fastcall DoNewText(Virtualtrees::PVirtualNode Node, Virtualtrees::TColumnIndex Column, const System::UnicodeString Text);
	virtual void __fastcall DoPaintText(Virtualtrees::PVirtualNode Node, Vcl::Graphics::TCanvas* const Canvas, Virtualtrees::TColumnIndex Column, Virtualtrees::TVSTTextType TextType);
	virtual void __fastcall DoPopupMenu(Virtualtrees::PVirtualNode Node, Virtualtrees::TColumnIndex Column, const System::Types::TPoint &Position);
	virtual void __fastcall DoRootChange(void);
	virtual void __fastcall DoRootChanging(const TRootFolder NewRoot, Mpshellutilities::TNamespace* Namespace, bool &Allow);
	virtual void __fastcall DoRootRebuild(void);
	virtual void __fastcall DoShellExecute(Virtualtrees::PVirtualNode Node);
	virtual void __fastcall DoAfterShellNotify(Virtualshellnotifier::TVirtualShellEvent* ShellEvent);
	virtual void __fastcall DoShellNotify(Virtualshellnotifier::TVirtualShellEvent* ShellEvent);
	virtual void __fastcall DoTreeDblClick(System::Uitypes::TMouseButton Button, const System::Types::TPoint &Position);
	virtual void __fastcall DoUpdating(Virtualtrees::TVTUpdateState State);
	virtual HRESULT __fastcall DragDrop(const _di_IDataObject DataObject, int KeyState, const System::Types::TPoint &Pt, int &Effect);
	virtual HRESULT __fastcall DragEnter(int KeyState, const System::Types::TPoint &Pt, int &Effect);
	virtual void __fastcall DragAndDrop(unsigned AllowedEffects, const _di_IDataObject DataObject, int &DragEffect);
	virtual void __fastcall DragLeave(void);
	virtual HRESULT __fastcall DragOver(System::TObject* Source, int KeyState, System::Uitypes::TDragState DragState, const System::Types::TPoint &Pt, int &Effect);
	void __fastcall DummyOnDragOver(Virtualtrees::TBaseVirtualTree* Sender, System::TObject* Source, System::Classes::TShiftState Shift, System::Uitypes::TDragState State, const System::Types::TPoint &Pt, Virtualtrees::TDropMode Mode, int &Effect, bool &Accept);
	virtual void __fastcall EnumThreadFinished(void);
	virtual void __fastcall EnumThreadStart(void);
	void __fastcall EnumThreadTimer(bool Enable);
	virtual void __fastcall ExecuteNamespace(Mpshellutilities::TNamespace* Namespace, System::WideString &WorkingDir, System::WideString &CmdLineArgument);
	bool __fastcall EnumerateFolderCallback(HWND MessageWnd, Winapi::Shlobj::PItemIDList APIDL, Mpshellutilities::TNamespace* AParent, void * Data, bool &Terminate);
	virtual int __fastcall ExpandNamespaceFolder(Virtualtrees::PVirtualNode Node);
	bool __fastcall FindFolderByNameCallback(HWND MessageWnd, Winapi::Shlobj::PItemIDList APIDL, Mpshellutilities::TNamespace* AParent, void * Data, bool &Terminate);
	void __fastcall ForceIconCachRebuild(void);
	virtual Vcl::Controls::TWinControl* __fastcall GetAnimateWndParent(void);
	virtual Virtualtrees::TVirtualTreeColumnClass __fastcall GetColumnClass(void);
	virtual Virtualtrees::TVTHeaderClass __fastcall GetHeaderClass(void);
	TColumnMenu* __fastcall GetColumnMenu(void);
	virtual Virtualtrees::TTreeOptionsClass __fastcall GetOptionsClass(void);
	virtual bool __fastcall HasPopupMenu(Virtualtrees::PVirtualNode Node, Virtualtrees::TColumnIndex Column, const System::Types::TPoint &Pos);
	virtual System::WideString __fastcall InternalCreateNewFolder(Winapi::Shlobj::PItemIDList TargetPIDL, System::WideString SuggestedFolderName);
	void __fastcall HideAnimateFolderWnd(void);
	void __fastcall InvalidateChildNamespaces(Virtualtrees::PVirtualNode Node, bool RefreshIcon);
	void __fastcall InvalidateImageByIndex(int ImageIndex);
	void __fastcall InvalidateNodeByPIDL(Winapi::Shlobj::PItemIDList PIDL);
	virtual bool __fastcall IsAnyEditing(void);
	bool __fastcall ItemHasChildren(Mpshellutilities::TNamespace* NS, Virtualtrees::PVirtualNode Node, Virtualtrees::PVirtualNode ParentNode);
	void __fastcall LiveColumnUpdate(System::TObject* Sender);
	virtual void __fastcall LoadDefaultOptions(void);
	void __fastcall LoadExplorerComboBox(System::Classes::TReader* Reader);
	Virtualtrees::PVirtualNode __fastcall NextSelectedNode(Virtualtrees::PVirtualNode Node, bool DoSelectNext, bool &ResultIsParent);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual bool __fastcall OkToBrowseTo(Winapi::Shlobj::PItemIDList PIDL);
	bool __fastcall OkToExpandNode(Virtualtrees::PVirtualNode Node);
	System::WideString __fastcall PathofNameSpace(Mpshellutilities::TNamespace* NS);
	void __fastcall Notify(Winapi::Messages::TMessage &Msg);
	void __fastcall ReadChildNodes(Virtualtrees::PVirtualNode Node, TNodeSearchArray &ANodeArray, bool Sorted, int &ValidNodesRead);
	virtual void __fastcall RebuildRootNamespace(void);
	void __fastcall RebuildRootNamespaceBeginUpdate(void);
	void __fastcall RebuildRootNamespaceEndUpdate(void);
	void __fastcall RebuildShellHeader(Mpshellutilities::TNamespace* BasedOnNamespace);
	void __fastcall RebuildVETHeader(void);
	void __fastcall RefreshNodeByPIDL(Winapi::Shlobj::PItemIDList aPIDL, bool ForceExpand, bool SaveSelection);
	virtual void __fastcall ReStoreColumnState(void);
	virtual void __fastcall ShowAnimateFolderWnd(void);
	virtual void __fastcall StoreColumnState(void);
	virtual void __fastcall SetActive(const bool Value);
	virtual void __fastcall ShellExecuteFolderLink(Mpshellutilities::TNamespace* NS, System::WideString WorkingDir, System::WideString CmdLineArgument);
	virtual int __fastcall SuggestDropEffect(System::TObject* Source, System::Classes::TShiftState Shift, const System::Types::TPoint &Pt, int AllowedEffects);
	void __fastcall TerminateEnumThread(void);
	bool __fastcall ValidRootNamespace(void);
	Virtualtrees::PVirtualNode __fastcall WalkPIDLToNode(Winapi::Shlobj::PItemIDList AnAbsolutePIDL, bool SelectNode, bool ForceExpand, bool QuietExpand, bool ShowAllSiblings);
	void __fastcall WaitCursor(bool Show);
	MESSAGE void __fastcall WMCommonThreadCallback(Mpthreadmanager::TWMThreadRequest &Msg);
	HIDESBASE MESSAGE void __fastcall WMContextMenu(Winapi::Messages::TWMContextMenu &Msg);
	MESSAGE void __fastcall WMDeviceChange(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMDrawItem(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMDestroy(Winapi::Messages::TWMNoParams &Msg);
	MESSAGE void __fastcall WMInitMenuPopup(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMInvalidFileName(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMMeasureItem(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMMenuChar(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMMenuSelect(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMNCDestroy(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMRButtonDblClk(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMRButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMRButtonUp(Winapi::Messages::TWMMouse &Msg);
	MESSAGE void __fastcall WMShellNotify(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMSysChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMSysKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMSysKeyUp(Winapi::Messages::TWMKey &Msg);
	MESSAGE void __fastcall WMQueryEndSession(Winapi::Messages::TWMQueryEndSession &Msg);
	HIDESBASE MESSAGE void __fastcall WMTimer(Winapi::Messages::TWMTimer &Msg);
	__property bool Active = {read=FActive, write=SetActive, nodefault};
	__property bool AltKeyDown = {read=FAltKeyDown, write=FAltKeyDown, nodefault};
	__property Vcl::Comctrls::TAnimate* AnimateFolderEnum = {read=FAnimateFolderEnum, write=FAnimateFolderEnum};
	__property TVirtualShellBackgroundContextMenu* BackGndMenu = {read=FBackGndMenu, write=FBackGndMenu};
	__property int ChangeNotifierCount = {read=FChangeNotifierCount, write=FChangeNotifierCount, nodefault};
	__property bool ChangeNotifierEnabled = {read=FChangeNotifierEnabled, write=SetChangeNotiferEnabled, nodefault};
	__property TColumnDetailType ColumnDetails = {read=FColumnDetails, write=SetColumnDetails, nodefault};
	__property TColumnMenu* ColumnMenu = {read=GetColumnMenu, write=FColumnMenu};
	__property int ColumnMenuItemCount = {read=FColumnMenuItemCount, write=FColumnMenuItemCount, nodefault};
	__property bool CreatingHeaders = {read=FCreatingHeaders, write=FCreatingHeaders, nodefault};
	__property TContextMenuManager* ContextMenuManager = {read=FContextMenuManager, write=FContextMenuManager};
	__property int CurrentUpdateCount = {read=FCurrentUpdateCount, write=FCurrentUpdateCount, nodefault};
	__property bool DisableWaitCursors = {read=FDisableWaitCursors, write=SetDisableWaitCursors, nodefault};
	__property _di_IDataObject DragDataObject = {read=FDragDataObject, write=FDragDataObject};
	__property int DragMouseButton = {read=FDragMouseButton, write=FDragMouseButton, nodefault};
	__property bool Dropping = {read=FDropping, nodefault};
	__property Mpcommonobjects::TCommonPIDLList* EnumBkGndList = {read=FEnumBkGndList, write=FEnumBkGndList};
	__property _RTL_CRITICAL_SECTION EnumLock = {read=FEnumLock, write=FEnumLock};
	__property TVirtualBackGndEnumThread* EnumThread = {read=FEnumThread, write=FEnumThread};
	__property NativeUInt EnumTimer = {read=FEnumTimer, write=FEnumTimer, nodefault};
	__property unsigned EnumBkGndTime = {read=FEnumBkGndTime, write=FEnumBkGndTime, nodefault};
	__property bool ExpandingByButtonClick = {read=FExpandingByButtonClick, nodefault};
	__property TCustomVirtualExplorerCombobox* ExplorerComboBox = {read=FExplorerComboBox, write=SetExplorerComboBox};
	__property Mpshellutilities::TFileObjects FileObjects = {read=FFileObjects, write=SetFileObjects, default=1};
	__property TFileSizeFormat FileSizeFormat = {read=FFileSizeFormat, write=SetFileSizeFormat, nodefault};
	__property Mpshellutilities::TFileSort FileSort = {read=FFileSort, write=SetFileSort, nodefault};
	__property int LastDragEffect = {read=FLastDragEffect, write=FLastDragEffect, nodefault};
	__property Virtualtrees::PVirtualNode LastDropTargetNode = {read=FLastDropTargetNode, write=FLastDropTargetNode};
	__property _di_IMalloc Malloc = {read=FMalloc, write=FMalloc};
	__property int NodeDataSize = {read=GetNodeDataSize, write=SetNodeDataSize, default=-1};
	__property TVETOnClipboardCopy OnClipboardCopy = {read=FOnClipboardCopy, write=FOnClipboardCopy};
	__property TVETOnClipboardCut OnClipboardCut = {read=FOnClipboardCut, write=FOnClipboardCut};
	__property TVETOnClipboardPaste OnClipboardPaste = {read=FOnClipboardPaste, write=FOnClipboardPaste};
	__property System::Classes::TNotifyEvent OnColumnUserChangedVisiblility = {read=FOnColumnUserChangedVisiblility, write=FOnColumnUserChangedVisiblility};
	__property TVETOnContextMenuAfterCmd OnContextMenuAfterCmd = {read=FOnContextMenuAfterCmd, write=FOnContextMenuAfterCmd};
	__property TVETContextMenuItemChange OnContextMenuItemChange = {read=FOnContextMenuItemChange, write=FOnContextMenuItemChange};
	__property TVETOnContextMenuCmd OnContextMenuCmd = {read=FOnContextMenuCmd, write=FOnContextMenuCmd};
	__property TVETOnContextMenuShow OnContextMenuShow = {read=FOnContextMenuShow, write=FOnContextMenuShow};
	__property TVETOnCustomColumnCompare OnCustomColumnCompare = {read=FOnCustomColumnCompare, write=FOnCustomColumnCompare};
	__property TVETOnCustomNamespace OnCustomNamespace = {read=FOnCustomNamespace, write=FOnCustomNamespace};
	__property TVETEnumLenghyOperaionEvent OnEnumThreadLengthyOperation = {read=FOnEnumThreadLengthyOperation, write=FOnEnumThreadLengthyOperation};
	__property TVETOnDrawNodeText OnGetVETText = {read=FOnDrawNodeText, write=FOnDrawNodeText};
	__property TVETOnEnumFolder OnEnumFolder = {read=FOnEnumFilter, write=FOnEnumFilter};
	__property TVETEnumFinishedEvent OnEnumFinished = {read=FOnEnumFinished, write=FOnEnumFinished};
	__property TVETOnHeaderRebuild OnHeaderRebuild = {read=FOnHeaderRebuild, write=FOnHeaderRebuild};
	__property System::Classes::TNotifyEvent OnInvalidRootNamespace = {read=FOnInvalidRootNamespace, write=FOnInvalidRootNamespace};
	__property TNamespaceStructureChangeEvent OnNamespaceStructureChange = {read=FOnNamespaceStructureChange, write=FOnNamespaceStructureChange};
	__property TVETOnRootChange OnRootChange = {read=FOnRootChange, write=FOnRootChange};
	__property TVETOnRootChanging OnRootChanging = {read=FOnRootChanging, write=FOnRootChanging};
	__property TVETOnRootRebuild OnRootRebuild = {read=FOnRootRebuild, write=FOnRootRebuild};
	__property TVETOnShellExecute OnShellExecute = {read=FOnShellExecute, write=FOnShellExecute};
	__property TVETOnShellNotify OnAfterShellNotify = {read=FOnAfterShellNotify, write=FOnAfterShellNotify};
	__property TVETOnShellNotify OnShellNotify = {read=FOnShellNotify, write=FOnShellNotify};
	__property TVETOnTreeDblClick OnTreeDblClick = {read=FOnTreeDblClick, write=FOnTreeDblClick};
	__property int RebuildRootNamespaceCount = {read=FRebuildRootNamespaceCount, write=FRebuildRootNamespaceCount, nodefault};
	__property Virtualtrees::PVirtualNode RecycleBinNode = {read=GetRecycleBinNode};
	__property TRootFolder RootFolder = {read=FRootFolder, write=SetRootFolder, nodefault};
	__property int ShellBaseColumnCount = {read=FShellBaseColumnCount, write=FShellBaseColumnCount, nodefault};
	__property Vcl::Menus::TPopupMenu* ShellContextSubMenu = {read=FShellContextSubMenu, write=FShellContextSubMenu};
	__property System::WideString ShellContextSubMenuCaption = {read=FShellContextSubMenuCaption, write=FShellContextSubMenuCaption};
	__property bool OkToShellNotifyDispatch = {read=GetOkToShellNotifyDispatch, nodefault};
	__property System::Classes::TList* ShellNotifyQueue = {read=FShellNotifyQueue, write=FShellNotifyQueue};
	__property NativeUInt ShellNotifyTimerHandle = {read=FShellNotifyTimerHandle, write=FShellNotifyTimerHandle, nodefault};
	__property Mpshellutilities::TShellSortHelper* SortHelper = {read=FSortHelper, write=FSortHelper};
	__property bool ThreadedEnum = {read=FThreadedEnum, write=FThreadedEnum, default=0};
	__property bool ThreadedImagesEnabled = {read=FThreadedImagesEnabled, write=SetThreadedImagesEnabled, nodefault};
	__property TVirtualExplorerTreeOptions* TreeOptions = {read=GetOptions, write=SetOptions};
	__property int UnknownFolderIconIndex = {read=FUnknownFolderIconIndex, write=FUnknownFolderIconIndex, nodefault};
	__property int UnknownFileIconIndex = {read=FUnknownFileIconIndex, write=FUnknownFileIconIndex, nodefault};
	__property TVETColors* VETColors = {read=FVETColors, write=FVETColors};
	__property TVETStates VETState = {read=FVETState, write=FVETState, nodefault};
	__property TCustomVirtualExplorerTree* VirtualExplorerTree = {read=FVirtualExplorerTree, write=SetVirtualExplorerTree};
	
public:
	__fastcall virtual TCustomVirtualExplorerTree(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCustomVirtualExplorerTree(void);
	Virtualtrees::PVirtualNode __fastcall AddCustomNode(Virtualtrees::PVirtualNode ParentNode, Mpshellutilities::TNamespace* CustomNamespace, bool UsesCheckBoxes, Virtualtrees::TCheckType CheckBoxType = (Virtualtrees::TCheckType)(0x1));
	Virtualtrees::PVirtualNode __fastcall AddNodeToTree(Virtualtrees::PVirtualNode ParentNode);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	bool __fastcall BrowseTo(System::WideString APath, bool ExpandTarget, bool SelectTarget, bool SetFocusToVET, bool CollapseAllFirst)/* overload */;
	bool __fastcall BrowseTo(System::WideString APath, bool SetFocusToVET = true)/* overload */;
	virtual bool __fastcall BrowseToByPIDL(Winapi::Shlobj::PItemIDList APIDL, bool ExpandTarget, bool SelectTarget, bool SetFocusToVET, bool CollapseAllFirst, bool ShowAllSiblings = true);
	DYNAMIC void __fastcall ChangeLinkChanging(System::TObject* Server, Winapi::Shlobj::PItemIDList NewPIDL);
	virtual void __fastcall ChangeLinkDispatch(void);
	DYNAMIC void __fastcall ChangeLinkFreeing(_di_IVETChangeLink ChangeLink);
	virtual void __fastcall Clear(void);
	virtual void __fastcall CopyToClipboard(void);
	bool __fastcall CreateNewFolder(System::WideString TargetPath)/* overload */;
	bool __fastcall CreateNewFolder(System::WideString TargetPath, System::WideString &NewFolder)/* overload */;
	bool __fastcall CreateNewFolder(System::WideString TargetPath, System::WideString SuggestedFolderName, System::WideString &NewFolder)/* overload */;
	bool __fastcall CreateNewFolderByNode(Virtualtrees::PVirtualNode Node);
	virtual void __fastcall CutToClipboard(void);
	HIDESBASE void __fastcall DeleteNode(Virtualtrees::PVirtualNode Node, bool Reindex = true);
	HIDESBASE void __fastcall DeleteSelectedNodes(Mpshellutilities::TExecuteVerbShift ShiftKeyState = (Mpshellutilities::TExecuteVerbShift)(0x0));
	virtual bool __fastcall DoCancelEdit(void);
	virtual bool __fastcall DoEndEdit(void);
	bool __fastcall FindDesktopFolderByName(System::WideString AName, Mpshellutilities::TNamespace* &Namespace);
	Virtualtrees::PVirtualNode __fastcall FindNode(System::WideString APath);
	Virtualtrees::PVirtualNode __fastcall FindNodeByPIDL(Winapi::Shlobj::PItemIDList APIDL);
	bool __fastcall FindFolderByName(System::WideString AName, Mpshellutilities::TNamespace* &Namespace);
	Virtualtrees::PVirtualNode __fastcall ForceNode(System::WideString APath, bool Expand);
	Virtualtrees::PVirtualNode __fastcall ForceNodeByPIDL(Winapi::Shlobj::PItemIDList APIDL, bool Expand, bool ShowAllSiblings = true);
	void __fastcall EnableChangeNotifier(bool Enable);
	void __fastcall FlushChangeNotifier(void);
	void __fastcall InitAllChildren(Virtualtrees::PVirtualNode Node);
	void __fastcall InitAllNodes(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	void __fastcall MarkNodesCut(void);
	void __fastcall MarkNodesCopied(void);
	virtual bool __fastcall PasteFromClipboard(void);
	void __fastcall RebuildHeader(Mpshellutilities::TNamespace* BasedOnNamespace);
	bool __fastcall RebuildTree(void);
	bool __fastcall RefreshNode(Virtualtrees::PVirtualNode Node);
	bool __fastcall RefreshTree(bool RestoreTopNode = false);
	virtual void __fastcall ReReadAndRefreshNode(Virtualtrees::PVirtualNode Node, bool SortNode);
	virtual void __fastcall SaveToStream(System::Classes::TStream* Stream, Virtualtrees::PVirtualNode Node = (Virtualtrees::PVirtualNode)(0x0));
	virtual void __fastcall SelectedFilesDelete(Mpshellutilities::TExecuteVerbShift ShiftKeyState = (Mpshellutilities::TExecuteVerbShift)(0x0));
	virtual void __fastcall SelectedFilesPaste(bool AllowMultipleTargets);
	virtual void __fastcall SelectedFilesShowProperties(void);
	virtual _di_IDataObject __fastcall SelectedToDataObject(void);
	virtual Mpshellutilities::TNamespaceArray __fastcall SelectedToNamespaceArray(void);
	virtual Mpcommonobjects::TPIDLArray __fastcall SelectedToPIDLArray(void);
	void __fastcall ShowColumnDialog(void);
	bool __fastcall ValidateColumnManager(Virtualtrees::PVirtualNode Node, TColumnManager* &ColumnManager);
	bool __fastcall ValidateNamespace(Virtualtrees::PVirtualNode Node, Mpshellutilities::TNamespace* &Namespace);
	bool __fastcall ValidateParentNamespace(Virtualtrees::PVirtualNode Node, Mpshellutilities::TNamespace* &Namespace);
	__property bool AutoFireChangeLink = {read=FAutoFireChangeLink, write=FAutoFireChangeLink, nodefault};
	__property bool ContextMenuShown = {read=GetContextMenuShown, nodefault};
	__property System::WideString RootFolderCustomPath = {read=FRootFolderCustomPath, write=SetRootFolderCustomPath};
	__property Winapi::Shlobj::PItemIDList RootFolderCustomPIDL = {read=FRootFolderCustomPIDL, write=SetRootFolderCustomPIDL};
	__property Mpshellutilities::TNamespace* RootFolderNamespace = {read=FRootFolderNamespace};
	__property System::WideString SelectedFile = {read=GetSelectedFile};
	__property System::Classes::TStrings* SelectedFiles = {read=GetSelectedFiles};
	__property System::Classes::TStrings* SelectedPaths = {read=GetSelectedPaths};
	__property System::WideString SelectedPath = {read=GetSelectedPath};
	__property Winapi::Shlobj::PItemIDList SelectedPIDL = {read=GetSelectedPIDL};
	__property bool ShellNotifySuspended = {read=FShellNotifySuspended, write=FShellNotifySuspended, default=0};
	__property bool ThreadedExpandMarkEnabled = {read=GetThreadedExpandMarkEnabled, write=SetThreadedExpandMarkEnabled, nodefault};
	__property TVETPersistent* VETPersistent = {read=FVETPersistent};
	__property TViewManager* ViewManager = {read=FViewManager, write=FViewManager};
	__property TRootNodeStorage* Storage = {read=GetNewStorage};
public:
	/* TWinControl.CreateParented */ inline __fastcall TCustomVirtualExplorerTree(HWND ParentWindow) : Virtualtrees::TCustomVirtualStringTree(ParentWindow) { }
	
private:
	void *__IVirtualShellNotify;	// Virtualshellnotifier::IVirtualShellNotify 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {86888DA6-8429-4A7F-AC9C-9A9EB1F08E1A}
	operator Virtualshellnotifier::_di_IVirtualShellNotify()
	{
		Virtualshellnotifier::_di_IVirtualShellNotify intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Virtualshellnotifier::IVirtualShellNotify*(void) { return (Virtualshellnotifier::IVirtualShellNotify*)&__IVirtualShellNotify; }
	#endif
	
};


class PASCALIMPLEMENTATION TVirtualExplorerTree : public TCustomVirtualExplorerTree
{
	typedef TCustomVirtualExplorerTree inherited;
	
public:
	__property ColumnMenu;
	__property SortHelper;
	
__published:
	__property Action;
	__property Active;
	__property Align = {default=0};
	__property Alignment = {default=0};
	__property Anchors = {default=3};
	__property AnimationDuration = {default=200};
	__property AutoExpandDelay = {default=1000};
	__property AutoScrollDelay = {default=1000};
	__property AutoScrollInterval = {default=1};
	__property BackGndMenu;
	__property Background;
	__property BackgroundOffsetX = {index=0, default=0};
	__property BackgroundOffsetY = {index=1, default=0};
	__property BevelEdges = {default=15};
	__property BevelInner = {index=0, default=2};
	__property BevelOuter = {index=1, default=1};
	__property BevelKind = {default=0};
	__property BevelWidth = {default=1};
	__property BiDiMode;
	__property BorderStyle = {default=1};
	__property BorderWidth = {default=0};
	__property ButtonFillMode = {default=0};
	__property ButtonStyle = {default=0};
	__property ChangeDelay = {default=0};
	__property CheckImageKind = {default=1};
	__property Color = {default=-16777211};
	__property Colors;
	__property ColumnDetails;
	__property ColumnMenuItemCount;
	__property Constraints;
	__property Ctl3D;
	__property CustomCheckImages;
	__property DefaultNodeHeight = {default=18};
	__property DragCursor = {default=-12};
	__property DragHeight = {default=350};
	__property DragImageKind = {default=0};
	__property DragWidth = {default=200};
	__property DrawSelectionMode = {default=0};
	__property EditDelay = {default=1000};
	__property Enabled = {default=1};
	__property ExplorerComboBox;
	__property FileObjects = {default=1};
	__property FileSizeFormat;
	__property FileSort;
	__property Font;
	__property Header;
	__property HintAnimation = {default=3};
	__property HintMode = {default=0};
	__property HotCursor = {default=0};
	__property IncrementalSearch = {default=1};
	__property IncrementalSearchDirection = {default=0};
	__property IncrementalSearchStart = {default=2};
	__property IncrementalSearchTimeout = {default=1000};
	__property Indent = {default=18};
	__property LineMode = {default=0};
	__property LineStyle = {default=1};
	__property Margin = {default=4};
	__property NodeAlignment = {default=2};
	__property NodeDataSize = {default=-1};
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property RootFolder;
	__property RootFolderCustomPath = {default=0};
	__property SelectionBlendFactor = {default=128};
	__property SelectionCurveRadius = {default=0};
	__property ScrollBarOptions;
	__property ShellContextSubMenu;
	__property ShellContextSubMenuCaption = {default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop;
	__property TextMargin = {default=4};
	__property TreeOptions;
	__property VETColors;
	__property VirtualExplorerTree;
	__property Visible = {default=1};
	__property OnAdvancedHeaderDraw;
	__property OnAfterCellPaint;
	__property OnAfterItemErase;
	__property OnAfterItemPaint;
	__property OnAfterPaint;
	__property OnBeforeCellPaint;
	__property OnBeforeItemErase;
	__property OnBeforeItemPaint;
	__property OnBeforePaint;
	__property OnChange;
	__property OnChecked;
	__property OnChecking;
	__property OnClick;
	__property OnClipboardCopy;
	__property OnClipboardCut;
	__property OnClipboardPaste;
	__property OnCollapsed;
	__property OnCollapsing;
	__property OnColumnClick;
	__property OnColumnDblClick;
	__property OnColumnResize;
	__property OnColumnUserChangedVisiblility;
	__property OnCompareNodes;
	__property OnContextMenuAfterCmd;
	__property OnContextMenuCmd;
	__property OnContextMenuItemChange;
	__property OnContextMenuShow;
	__property OnCreateDataObject;
	__property OnCreateEditor;
	__property OnCustomColumnCompare;
	__property OnCustomNamespace;
	__property OnDblClick;
	__property OnDragAllowed;
	__property OnDragOver;
	__property OnDragDrop;
	__property OnEditCancelled;
	__property OnEdited;
	__property OnEditing;
	__property OnEndDrag;
	__property OnEndDock;
	__property OnEnter;
	__property OnEnumFolder;
	__property OnExit;
	__property OnExpanded;
	__property OnExpanding;
	__property OnFocusChanged;
	__property OnFocusChanging;
	__property OnFreeNode;
	__property OnGetCursor;
	__property OnGetHeaderCursor;
	__property OnGetHelpContext;
	__property OnGetHint;
	__property OnGetImageIndexEx;
	__property OnGetLineStyle;
	__property OnGetNodeDataSize;
	__property OnGetPopupMenu;
	__property OnGetVETText;
	__property OnHeaderClick;
	__property OnHeaderDblClick;
	__property OnHeaderDraw;
	__property OnHeaderDrawQueryElements;
	__property OnHeaderDragged;
	__property OnHeaderDragging;
	__property OnHeaderMouseDown;
	__property OnHeaderMouseMove;
	__property OnHeaderMouseUp;
	__property OnHeaderRebuild;
	__property OnHotChange;
	__property OnIncrementalSearch;
	__property OnInitChildren;
	__property OnInitNode;
	__property OnInvalidRootNamespace;
	__property OnKeyAction;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnNamespaceStructureChange;
	__property OnPaintBackground;
	__property OnPaintText;
	__property OnResize;
	__property OnRootChange;
	__property OnRootChanging;
	__property OnRootRebuild;
	__property OnScroll;
	__property OnShellExecute;
	__property OnAfterShellNotify;
	__property OnShellNotify;
	__property OnShortenString;
	__property OnStartDock;
	__property OnStartDrag;
	__property OnStructureChange;
	__property OnTreeDblClick;
	__property OnUpdating;
public:
	/* TCustomVirtualExplorerTree.Create */ inline __fastcall virtual TVirtualExplorerTree(System::Classes::TComponent* AOwner) : TCustomVirtualExplorerTree(AOwner) { }
	/* TCustomVirtualExplorerTree.Destroy */ inline __fastcall virtual ~TVirtualExplorerTree(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualExplorerTree(HWND ParentWindow) : TCustomVirtualExplorerTree(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualExplorerViews : public TCustomVirtualExplorerTree
{
	typedef TCustomVirtualExplorerTree inherited;
	
public:
	__property TColumnMenu* ColumnMenu = {read=GetColumnMenu};
	__property SortHelper;
	
__published:
	__property Action;
	__property Active;
	__property Align = {default=0};
	__property Alignment = {default=0};
	__property Anchors = {default=3};
	__property AnimationDuration = {default=200};
	__property AutoExpandDelay = {default=1000};
	__property AutoScrollDelay = {default=1000};
	__property AutoScrollInterval = {default=1};
	__property Background;
	__property BackgroundOffsetX = {index=0, default=0};
	__property BackgroundOffsetY = {index=1, default=0};
	__property BevelEdges = {default=15};
	__property BevelInner = {index=0, default=2};
	__property BevelOuter = {index=1, default=1};
	__property BevelKind = {default=0};
	__property BevelWidth = {default=1};
	__property BiDiMode;
	__property BorderStyle = {default=1};
	__property BorderWidth = {default=0};
	__property ButtonFillMode = {default=0};
	__property ButtonStyle = {default=0};
	__property ChangeDelay = {default=0};
	__property CheckImageKind = {default=1};
	__property Color = {default=-16777211};
	__property Colors;
	__property ColumnDetails;
	__property Constraints;
	__property Ctl3D;
	__property CustomCheckImages;
	__property DefaultNodeHeight = {default=18};
	__property DragCursor = {default=-12};
	__property DragHeight = {default=350};
	__property DragImageKind = {default=0};
	__property DragWidth = {default=200};
	__property DrawSelectionMode = {default=0};
	__property EditDelay = {default=1000};
	__property Enabled = {default=1};
	__property ExplorerComboBox;
	__property FileObjects = {default=5};
	__property FileSizeFormat;
	__property FileSort;
	__property Font;
	__property Header;
	__property HintAnimation = {default=3};
	__property HintMode = {default=0};
	__property HotCursor = {default=0};
	__property IncrementalSearch = {default=1};
	__property IncrementalSearchDirection = {default=0};
	__property IncrementalSearchStart = {default=2};
	__property IncrementalSearchTimeout = {default=1000};
	__property Indent = {default=18};
	__property LineMode = {default=0};
	__property LineStyle = {default=1};
	__property Margin = {default=4};
	__property NodeAlignment = {default=2};
	__property NodeDataSize = {default=-1};
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property RootFolder;
	__property RootFolderCustomPath = {default=0};
	__property SelectionBlendFactor = {default=128};
	__property SelectionCurveRadius = {default=0};
	__property ScrollBarOptions;
	__property ShellContextSubMenu;
	__property ShellContextSubMenuCaption = {default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop;
	__property TextMargin = {default=4};
	__property TreeOptions;
	__property Visible = {default=1};
	__property VETColors;
	__property OnAdvancedHeaderDraw;
	__property OnAfterCellPaint;
	__property OnAfterItemErase;
	__property OnAfterItemPaint;
	__property OnAfterPaint;
	__property OnBeforeCellPaint;
	__property OnBeforeItemErase;
	__property OnBeforeItemPaint;
	__property OnBeforePaint;
	__property OnChange;
	__property OnChecked;
	__property OnChecking;
	__property OnClick;
	__property OnClipboardCopy;
	__property OnClipboardCut;
	__property OnClipboardPaste;
	__property OnCollapsed;
	__property OnCollapsing;
	__property OnColumnClick;
	__property OnColumnDblClick;
	__property OnColumnResize;
	__property OnColumnUserChangedVisiblility;
	__property OnCompareNodes;
	__property OnContextMenuAfterCmd;
	__property OnContextMenuCmd;
	__property OnContextMenuItemChange;
	__property OnContextMenuShow;
	__property OnCreateDataObject;
	__property OnCreateEditor;
	__property OnCustomColumnCompare;
	__property OnCustomNamespace;
	__property OnDblClick;
	__property OnDragAllowed;
	__property OnDragOver;
	__property OnDragDrop;
	__property OnEditCancelled;
	__property OnEdited;
	__property OnEditing;
	__property OnEndDock;
	__property OnEndDrag;
	__property OnEnter;
	__property OnEnumFinished;
	__property OnEnumFolder;
	__property OnExit;
	__property OnExpanded;
	__property OnExpanding;
	__property OnFocusChanged;
	__property OnFocusChanging;
	__property OnFreeNode;
	__property OnGetCursor;
	__property OnGetHeaderCursor;
	__property OnGetHelpContext;
	__property OnGetHint;
	__property OnGetImageIndexEx;
	__property OnGetLineStyle;
	__property OnGetNodeDataSize;
	__property OnGetPopupMenu;
	__property OnGetVETText;
	__property OnHeaderClick;
	__property OnHeaderDblClick;
	__property OnHeaderDragged;
	__property OnHeaderDragging;
	__property OnHeaderDraw;
	__property OnHeaderDrawQueryElements;
	__property OnHeaderMouseDown;
	__property OnHeaderMouseMove;
	__property OnHeaderMouseUp;
	__property OnHotChange;
	__property OnIncrementalSearch;
	__property OnInitChildren;
	__property OnInitNode;
	__property OnInvalidRootNamespace;
	__property OnKeyAction;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnNamespaceStructureChange;
	__property OnNewText;
	__property OnPaintBackground;
	__property OnPaintText;
	__property OnResize;
	__property OnRootChange;
	__property OnRootChanging;
	__property OnRootRebuild;
	__property OnScroll;
	__property OnShellExecute;
	__property OnShellNotify;
	__property OnShortenString;
	__property OnStartDock;
	__property OnStartDrag;
	__property OnStructureChange;
	__property OnTreeDblClick;
	__property OnUpdating;
public:
	/* TCustomVirtualExplorerTree.Create */ inline __fastcall virtual TVirtualExplorerViews(System::Classes::TComponent* AOwner) : TCustomVirtualExplorerTree(AOwner) { }
	/* TCustomVirtualExplorerTree.Destroy */ inline __fastcall virtual ~TVirtualExplorerViews(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualExplorerViews(HWND ParentWindow) : TCustomVirtualExplorerTree(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualExplorerTreeview : public TVirtualExplorerViews
{
	typedef TVirtualExplorerViews inherited;
	
private:
	TVirtualExplorerListview* FVirtualExplorerListview;
	bool FRightButtonDown;
	void __fastcall SetVirtualExplorerListview(TVirtualExplorerListview* const Value);
	
protected:
	virtual void __fastcall LoadDefaultOptions(void);
	HIDESBASE MESSAGE void __fastcall WMRButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMRButtonUp(Winapi::Messages::TWMMouse &Msg);
	__property bool RightButtonDown = {read=FRightButtonDown, write=FRightButtonDown, nodefault};
	
public:
	DYNAMIC void __fastcall ChangeLinkFreeing(_di_IVETChangeLink ChangeLink);
	
__published:
	__property TVirtualExplorerListview* VirtualExplorerListview = {read=FVirtualExplorerListview, write=SetVirtualExplorerListview};
public:
	/* TCustomVirtualExplorerTree.Create */ inline __fastcall virtual TVirtualExplorerTreeview(System::Classes::TComponent* AOwner) : TVirtualExplorerViews(AOwner) { }
	/* TCustomVirtualExplorerTree.Destroy */ inline __fastcall virtual ~TVirtualExplorerTreeview(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualExplorerTreeview(HWND ParentWindow) : TVirtualExplorerViews(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualExplorerListview : public TVirtualExplorerViews
{
	typedef TVirtualExplorerViews inherited;
	
private:
	TVirtualExplorerTreeview* FVirtualExplorerTreeview;
	Mpshellutilities::TNamespace* FBackBrowseRoot;
	void __fastcall SetVirtualExplorerTreeview(TVirtualExplorerTreeview* const Value);
	void __fastcall SetBackBrowseRoot(Mpshellutilities::TNamespace* const Value);
	
protected:
	virtual int __fastcall ShowBkGndContextMenu(const System::Types::TPoint &Point);
	virtual void __fastcall CreateWnd(void);
	virtual Vcl::Imglist::TCustomImageList* __fastcall DoGetImageIndex(Virtualtrees::PVirtualNode Node, Virtualtrees::TVTImageKind Kind, Virtualtrees::TColumnIndex Column, bool &Ghosted, System::Uitypes::TImageIndex &Index);
	virtual bool __fastcall DoKeyAction(System::Word &CharCode, System::Classes::TShiftState &Shift);
	virtual void __fastcall DoShellExecute(Virtualtrees::PVirtualNode Node);
	virtual void __fastcall LoadDefaultOptions(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual bool __fastcall OkToBrowseTo(Winapi::Shlobj::PItemIDList PIDL);
	virtual void __fastcall RebuildRootNamespace(void);
	virtual void __fastcall ShellExecuteFolderLink(Mpshellutilities::TNamespace* NS, System::WideString WorkingDir, System::WideString CmdLineArgument);
	HIDESBASE MESSAGE void __fastcall WMShellNotify(Winapi::Messages::TMessage &Msg);
	
public:
	__fastcall virtual ~TVirtualExplorerListview(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	virtual bool __fastcall BrowseToByPIDL(Winapi::Shlobj::PItemIDList APIDL, bool ExpandTarget, bool SelectTarget, bool SetFocusToVET, bool CollapseAllFirst, bool ShowAllSiblings = true);
	void __fastcall BrowseToPrevLevel(void);
	bool __fastcall BrowseToNextLevel(void);
	virtual void __fastcall ChangeLinkDispatch(void);
	DYNAMIC void __fastcall ChangeLinkFreeing(_di_IVETChangeLink ChangeLink);
	virtual bool __fastcall PasteFromClipboard(void);
	virtual void __fastcall ReReadAndRefreshNode(Virtualtrees::PVirtualNode Node, bool SortNode);
	virtual void __fastcall SelectedFilesPaste(bool AllowMultipleTargets);
	__property Mpshellutilities::TNamespace* BackBrowseRoot = {read=FBackBrowseRoot, write=SetBackBrowseRoot};
	
__published:
	__property BackGndMenu;
	__property ColumnMenuItemCount;
	__property TVirtualExplorerTreeview* VirtualExplorerTreeview = {read=FVirtualExplorerTreeview, write=SetVirtualExplorerTreeview};
	__property ThreadedEnum = {default=0};
	__property OnEnumThreadLengthyOperation;
	__property OnHeaderRebuild;
public:
	/* TCustomVirtualExplorerTree.Create */ inline __fastcall virtual TVirtualExplorerListview(System::Classes::TComponent* AOwner) : TVirtualExplorerViews(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualExplorerListview(HWND ParentWindow) : TVirtualExplorerViews(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TComboEdit : public Vcl::Stdctrls::TCustomEdit
{
	typedef Vcl::Stdctrls::TCustomEdit inherited;
	
private:
	bool FKeyPressed;
	bool FIsEditing;
	TCustomVirtualExplorerCombobox* FExplorerComboBox;
	TCustomVirtualExplorerCombobox* FOwnerControl;
	Mpshellutilities::TNamespace* FOldNamespace;
	TShellComboStyle FStyle;
	System::Uitypes::TColor FColorOldFont;
	System::Uitypes::TColor FColorOldWindow;
	System::Uitypes::TCursor FCursorOld;
	bool FSelectingAll;
	HIDESBASE System::WideString __fastcall GetText(void);
	HIDESBASE void __fastcall SetText(const System::WideString Value);
	void __fastcall SetOldNamespace(Mpshellutilities::TNamespace* const Value);
	void __fastcall SetStyle(const TShellComboStyle Value);
	
protected:
	virtual void __fastcall CreateWnd(void);
	void __fastcall DefaultOnInvalidEntry(System::WideString InvalidText);
	virtual void __fastcall DoOnInvalidEntry(System::WideString InvalidPath);
	void __fastcall HandleDropDowns(TDropDown DropDown);
	virtual void __fastcall PaintWindow(HDC DC);
	void __fastcall SelectEnteredPath(void);
	void __fastcall UndoBufferSave(void);
	void __fastcall UndoBufferRestore(void);
	HIDESBASE MESSAGE void __fastcall CNCommand(Winapi::Messages::TWMCommand &Message);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Message);
	MESSAGE void __fastcall WMComboSelectAll(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall WMKeyUp(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSysKeyDown(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall CMSysColorChange(Winapi::Messages::TWMNoParams &Message);
	__property System::Uitypes::TColor ColorOldFont = {read=FColorOldFont, write=FColorOldFont, nodefault};
	__property System::Uitypes::TColor ColorOldWindow = {read=FColorOldWindow, write=FColorOldWindow, nodefault};
	__property System::Uitypes::TCursor CursorOld = {read=FCursorOld, write=FCursorOld, nodefault};
	__property bool IsEditing = {read=FIsEditing, write=FIsEditing, nodefault};
	__property bool KeyPressed = {read=FKeyPressed, write=FKeyPressed, nodefault};
	__property Mpshellutilities::TNamespace* OldNamespace = {read=FOldNamespace, write=SetOldNamespace};
	__property TCustomVirtualExplorerCombobox* OwnerControl = {read=FOwnerControl, write=FOwnerControl};
	__property bool SelectingAll = {read=FSelectingAll, write=FSelectingAll, nodefault};
	
public:
	__fastcall virtual TComboEdit(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TComboEdit(void);
	virtual void __fastcall SetFocus(void);
	__property TCustomVirtualExplorerCombobox* ExplorerComboBox = {read=FExplorerComboBox, write=FExplorerComboBox};
	__property TShellComboStyle Style = {read=FStyle, write=SetStyle, nodefault};
	__property System::WideString Text = {read=GetText, write=SetText};
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
public:
	/* TWinControl.CreateParented */ inline __fastcall TComboEdit(HWND ParentWindow) : Vcl::Stdctrls::TCustomEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TSizeGrabber : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
private:
	bool FCaptured;
	System::Types::TPoint FDragStartPos;
	TDropDownWnd* FOwnerDropDown;
	NativeUInt FThemeScrollbar;
	bool FThemesActive;
	bool FTransparent;
	
protected:
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Paint(void);
	void __fastcall PaintGrabber(HDC DC);
	HIDESBASE MESSAGE void __fastcall WMEraseBkGnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMPrintClient(Winapi::Messages::TWMPrint &Message);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Message);
	MESSAGE void __fastcall WMThemeChanged(Winapi::Messages::TMessage &Message);
	__property bool Captured = {read=FCaptured, write=FCaptured, nodefault};
	__property System::Types::TPoint DragStartPos = {read=FDragStartPos, write=FDragStartPos};
	__property TDropDownWnd* OwnerDropDown = {read=FOwnerDropDown, write=FOwnerDropDown};
	__property bool ThemesActive = {read=FThemesActive, write=FThemesActive, nodefault};
	__property NativeUInt ThemeScrollbar = {read=FThemeScrollbar, write=FThemeScrollbar, nodefault};
	__property bool Transparent = {read=FTransparent, write=FTransparent, default=0};
	
public:
	__fastcall virtual TSizeGrabber(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TSizeGrabber(void);
public:
	/* TWinControl.CreateParented */ inline __fastcall TSizeGrabber(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TDropDownWnd : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
private:
	TPopupOptions FPopupOptions;
	int FAnimationSpeed;
	TPopupStates FPopupStates;
	Virtualscrollbars::TOwnerDrawScrollbar* FRemoteScrollbar;
	TSizeGrabber* FGrabber;
	unsigned FDropDownCount;
	TOnPopupRollDown FOnRollDown;
	TOnPopupRollUp FOnRollUp;
	Mpcommonutilities::_di_ICallbackStub FAutoScrollTimerStub;
	int FAutoScrollTimer;
	int FAutoScrollSlowTime;
	int FAutoScrollFastTime;
	Vcl::Controls::TWinControl* FAutoScrollWindow;
	System::Classes::TNotifyEvent FOnRollDownInit;
	Vcl::Controls::TWinControl* FReFocusWindow;
	Vcl::Controls::TWinControl* FWheelMouseTarget;
	Vcl::Controls::TWinControl* FOwnerControl;
	void __fastcall SetPopupOptions(const TPopupOptions Value);
	bool __fastcall GetScrolling(void);
	void __fastcall SetDropDownCount(const unsigned Value);
	
protected:
	System::Types::TPoint FLastMousePos;
	virtual bool __fastcall AllowClickInWindow(HWND Window, const System::Types::TPoint &Point);
	void __fastcall AnimateRollDown(void);
	void __fastcall AutoPositionPopup(Vcl::Controls::TWinControl* AControl, System::Types::PPoint InitialExtents);
	void __stdcall AutoScrollTimerCallback(HWND Window, int Msg, int idEvent, unsigned dwTime);
	void __fastcall BitBltGrabber(Vcl::Graphics::TCanvas* Canvas, Vcl::Controls::TWinControl* Host, System::Uitypes::TColor BkGndColor);
	virtual bool __fastcall CanResize(int &NewWidth, int &NewHeight);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall DoRollDown(bool &Allow);
	virtual void __fastcall DoRollDownInit(void);
	virtual void __fastcall DoRollUp(bool Selected);
	void __fastcall DropDownMessageLoop(void);
	HRGN __fastcall GrabberPolyRgn(TSizeGrabber* Grabber, Vcl::Controls::TWinControl* Host);
	virtual void __fastcall KeyPressDispatch(Winapi::Messages::TMessage &Message, bool &Handled);
	virtual void __fastcall RefreshScrollbar(void);
	virtual unsigned __fastcall RowHeight(void);
	virtual void __fastcall RealignChildWindows(int NewWidth, int NewHeight);
	MESSAGE void __fastcall WMActivate(Winapi::Messages::TWMActivate &Message);
	MESSAGE void __fastcall WMActivateApp(Winapi::Messages::TWMActivateApp &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkGnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Message);
	MESSAGE void __fastcall WMPrint(Winapi::Messages::TWMPrint &Message);
	MESSAGE void __fastcall WMUpdateScrollbar(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMWindowPosChanging(Winapi::Messages::TWMWindowPosMsg &Message);
	
public:
	__fastcall virtual TDropDownWnd(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TDropDownWnd(void);
	__property int AnimationSpeed = {read=FAnimationSpeed, write=FAnimationSpeed, default=200};
	void __fastcall RollDown(Vcl::Controls::TWinControl* AnOwnerControl, Vcl::Controls::TWinControl* AlignmentControl, System::Types::PPoint Extents);
	void __fastcall RollUp(bool Select);
	void __fastcall ScrollTimerCreate(bool FastScroll);
	void __fastcall ScrollTimerDestroy(bool ClearFlags);
	__property int AutoScrollSlowTime = {read=FAutoScrollSlowTime, write=FAutoScrollSlowTime, default=200};
	__property int AutoScrollFastTime = {read=FAutoScrollFastTime, write=FAutoScrollFastTime, default=10};
	__property Vcl::Controls::TWinControl* AutoScrollWindow = {read=FAutoScrollWindow, write=FAutoScrollWindow};
	__property unsigned DropDownCount = {read=FDropDownCount, write=SetDropDownCount, nodefault};
	__property Vcl::Controls::TWinControl* ReFocusWindow = {read=FReFocusWindow, write=FReFocusWindow};
	__property TSizeGrabber* Grabber = {read=FGrabber, write=FGrabber};
	__property Vcl::Controls::TWinControl* WheelMouseTarget = {read=FWheelMouseTarget, write=FWheelMouseTarget};
	__property System::Classes::TNotifyEvent OnRollDownInit = {read=FOnRollDownInit, write=FOnRollDownInit};
	__property TOnPopupRollDown OnRollDown = {read=FOnRollDown, write=FOnRollDown};
	__property TOnPopupRollUp OnRollUp = {read=FOnRollUp, write=FOnRollUp};
	__property Vcl::Controls::TWinControl* OwnerControl = {read=FOwnerControl};
	__property TPopupOptions PopupOptions = {read=FPopupOptions, write=SetPopupOptions, default=50};
	__property TPopupStates PopupStates = {read=FPopupStates, nodefault};
	__property Virtualscrollbars::TOwnerDrawScrollbar* RemoteScrollbar = {read=FRemoteScrollbar, write=FRemoteScrollbar};
	__property bool Scrolling = {read=GetScrolling, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TDropDownWnd(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TPopupExplorerTree : public TVirtualExplorerTree
{
	typedef TVirtualExplorerTree inherited;
	
private:
	TPopupExplorerDropDown* FPopupExplorerDropDown;
	
protected:
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall DoCollapsed(Virtualtrees::PVirtualNode Node);
	virtual void __fastcall DoExpanded(Virtualtrees::PVirtualNode Node);
	virtual void __fastcall LoadDefaultOptions(void);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Message);
	HIDESBASE MESSAGE void __fastcall WMRButtonDown(Winapi::Messages::TWMMouse &Message);
	
public:
	__fastcall virtual TPopupExplorerTree(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TPopupExplorerTree(void);
	virtual bool __fastcall BrowseToByPIDL(Winapi::Shlobj::PItemIDList APIDL, bool ExpandTarget, bool SelectTarget, bool SetFocusToVET, bool CollapseAllFirst, bool ShowAllSiblings = true);
	virtual void __fastcall DoEnumFolder(Mpshellutilities::TNamespace* const Namespace, bool &AllowAsChild);
	__property TPopupExplorerDropDown* PopupExplorerDropDown = {read=FPopupExplorerDropDown, write=FPopupExplorerDropDown};
public:
	/* TWinControl.CreateParented */ inline __fastcall TPopupExplorerTree(HWND ParentWindow) : TVirtualExplorerTree(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TPopupExplorerOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TPopupExplorerDropDown* FPopupExplorerDropDown;
	int __fastcall GetAnimationSpeed(void);
	int __fastcall GetAutoScrollTimeFast(void);
	int __fastcall GetAutoScrollTimeSlow(void);
	Vcl::Graphics::TPicture* __fastcall GetBackground(void);
	int __fastcall GetBackgroundOffsetX(void);
	int __fastcall GetBackgroundOffsetY(void);
	TComboBoxStyle __fastcall GetComboBoxStyle(void);
	unsigned __fastcall GetDefaultNodeHeight(void);
	int __fastcall GetDropDownCount(void);
	int __fastcall GetIndent(void);
	TOnPopupRollDown __fastcall GetOnRollDown(void);
	TOnPopupRollUp __fastcall GetOnRollUp(void);
	TPopupOptions __fastcall GetOptions(void);
	void __fastcall SetAnimationSpeed(const int Value);
	void __fastcall SetAutoScrollTimeFast(const int Value);
	void __fastcall SetAutoScrollTimeSlow(const int Value);
	void __fastcall SetBackground(Vcl::Graphics::TPicture* const Value);
	void __fastcall SetBackgroundOffsetX(const int Value);
	void __fastcall SetBackgroundOffsetY(const int Value);
	void __fastcall SetComboBoxStyle(const TComboBoxStyle Value);
	void __fastcall SetDefaultNodeHeight(const unsigned Value);
	void __fastcall SetDropDownCount(const int Value);
	void __fastcall SetIndent(const int Value);
	void __fastcall SetOnRollDown(const TOnPopupRollDown Value);
	void __fastcall SetOnRollUp(const TOnPopupRollUp Value);
	void __fastcall SetOptions(const TPopupOptions Value);
	System::Uitypes::TColor __fastcall GetColor(void);
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	TVETOnEnumFolder __fastcall GetOnEnumFolder(void);
	void __fastcall SetOnEnumFolder(const TVETOnEnumFolder Value);
	
protected:
	__property TPopupExplorerDropDown* PopupExplorerDropDown = {read=FPopupExplorerDropDown, write=FPopupExplorerDropDown};
	
__published:
	__property int AnimationSpeed = {read=GetAnimationSpeed, write=SetAnimationSpeed, default=200};
	__property int AutoScrollTimeFast = {read=GetAutoScrollTimeFast, write=SetAutoScrollTimeFast, default=10};
	__property int AutoScrollTimeSlow = {read=GetAutoScrollTimeSlow, write=SetAutoScrollTimeSlow, default=200};
	__property Vcl::Graphics::TPicture* Background = {read=GetBackground, write=SetBackground};
	__property int BackgroundOffsetX = {read=GetBackgroundOffsetX, write=SetBackgroundOffsetX, default=0};
	__property int BackgroundOffsetY = {read=GetBackgroundOffsetY, write=SetBackgroundOffsetY, default=0};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, default=-16777211};
	__property TComboBoxStyle ComboBoxStyle = {read=GetComboBoxStyle, write=SetComboBoxStyle, default=0};
	__property unsigned DefaultNodeHeight = {read=GetDefaultNodeHeight, write=SetDefaultNodeHeight, default=17};
	__property int DropDownCount = {read=GetDropDownCount, write=SetDropDownCount, default=8};
	__property int Indent = {read=GetIndent, write=SetIndent, default=10};
	__property TVETOnEnumFolder OnEnumFolder = {read=GetOnEnumFolder, write=SetOnEnumFolder};
	__property TOnPopupRollDown OnRollDown = {read=GetOnRollDown, write=SetOnRollDown};
	__property TOnPopupRollUp OnRollUp = {read=GetOnRollUp, write=SetOnRollUp};
	__property TPopupOptions Options = {read=GetOptions, write=SetOptions, default=50};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TPopupExplorerOptions(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TPopupExplorerOptions(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TPopupExplorerDropDown : public TDropDownWnd
{
	typedef TDropDownWnd inherited;
	
private:
	TComboBoxStyle FComboBoxStyle;
	TPopupExplorerTree* FPopupExplorerTree;
	_ITEMIDLIST *FTargetPIDL;
	TCustomVirtualExplorerCombobox* FExplorerCombobox;
	bool FSelectOnDropDown;
	void __fastcall SetComboBoxStyle(const TComboBoxStyle Value);
	TPopupOptions __fastcall GetPopupOptions(void);
	HIDESBASE void __fastcall SetPopupOptions(const TPopupOptions Value);
	
protected:
	virtual bool __fastcall AllowClickInWindow(HWND Window, const System::Types::TPoint &Point);
	virtual TPopupExplorerTree* __fastcall CreatePopupExplorerTree(void);
	virtual void __fastcall DoRollDownInit(void);
	virtual void __fastcall DoRollUp(bool Selected);
	virtual void __fastcall KeyPressDispatch(Winapi::Messages::TMessage &Message, bool &Handled);
	virtual void __fastcall RealignChildWindows(int NewWidth, int NewHeight);
	virtual void __fastcall RefreshScrollbar(void);
	virtual unsigned __fastcall RowHeight(void);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &message);
	__property TComboBoxStyle ComboBoxStyle = {read=FComboBoxStyle, write=SetComboBoxStyle, default=0};
	
public:
	__fastcall virtual TPopupExplorerDropDown(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TPopupExplorerDropDown(void);
	__property TCustomVirtualExplorerCombobox* ExplorerCombobox = {read=FExplorerCombobox, write=FExplorerCombobox};
	__property TPopupExplorerTree* PopupExplorerTree = {read=FPopupExplorerTree};
	__property TPopupOptions PopupOptions = {read=GetPopupOptions, write=SetPopupOptions, default=50};
	__property Winapi::Shlobj::PItemIDList TargetPIDL = {read=FTargetPIDL, write=FTargetPIDL};
	__property bool SelectOnDropDown = {read=FSelectOnDropDown, write=FSelectOnDropDown, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TPopupExplorerDropDown(HWND ParentWindow) : TDropDownWnd(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TPopupAutoCompleteTree : public Virtualtrees::TVirtualStringTree
{
	typedef Virtualtrees::TVirtualStringTree inherited;
	
private:
	TPopupAutoCompleteDropDown* FPopupAutoCompleteDropDown;
	System::Types::TPoint FAutoScrollLastMousePos;
	Virtualshellautocomplete::TVirtualShellAutoComplete* FAutoComplete;
	System::Classes::TStringList* FStrings;
	
protected:
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall DoGetText(Virtualtrees::TVSTGetCellTextEventArgs &pEventArgs);
	void __fastcall DoUpdateList(const System::WideString CurrentEditContents, System::Classes::TStringList* EnumList, bool &Handled);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	void __fastcall UpdateList(System::WideString CurrentEditStr);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Message);
	HIDESBASE MESSAGE void __fastcall WMRButtonDown(Winapi::Messages::TWMMouse &Message);
	__property Virtualshellautocomplete::TVirtualShellAutoComplete* AutoComplete = {read=FAutoComplete, write=FAutoComplete};
	__property System::Types::TPoint AutoScrollLastMousePos = {read=FAutoScrollLastMousePos, write=FAutoScrollLastMousePos};
	__property System::Classes::TStringList* Strings = {read=FStrings, write=FStrings};
	
public:
	__fastcall virtual TPopupAutoCompleteTree(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TPopupAutoCompleteTree(void);
	__property TPopupAutoCompleteDropDown* PopupAutoCompleteDropDown = {read=FPopupAutoCompleteDropDown, write=FPopupAutoCompleteDropDown};
public:
	/* TWinControl.CreateParented */ inline __fastcall TPopupAutoCompleteTree(HWND ParentWindow) : Virtualtrees::TVirtualStringTree(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TPopupAutoCompleteOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TPopupAutoCompleteDropDown* FPopupAutoCompleteDropDown;
	int __fastcall GetAnimationSpeed(void);
	int __fastcall GetAutoScrollTimeFast(void);
	int __fastcall GetAutoScrollTimeSlow(void);
	Vcl::Graphics::TPicture* __fastcall GetBackground(void);
	int __fastcall GetBackgroundOffsetX(void);
	int __fastcall GetBackgroundOffsetY(void);
	Virtualshellautocomplete::TAutoCompleteContents __fastcall GetContents(void);
	unsigned __fastcall GetDefaultNodeHeight(void);
	int __fastcall GetDropDownCount(void);
	int __fastcall GetIndent(void);
	TOnAutoCompleteUpdateList __fastcall GetOnAutoCompleteUpdateList(void);
	TOnPopupRollDown __fastcall GetOnRollDown(void);
	TOnPopupRollUp __fastcall GetOnRollUp(void);
	TPopupOptions __fastcall GetOptions(void);
	void __fastcall SetAnimationSpeed(const int Value);
	void __fastcall SetAutoScrollTimeFast(const int Value);
	void __fastcall SetAutoScrollTimeSlow(const int Value);
	void __fastcall SetBackground(Vcl::Graphics::TPicture* const Value);
	void __fastcall SetBackgroundOffsetX(const int Value);
	void __fastcall SetBackgroundOffsetY(const int Value);
	void __fastcall SetContents(const Virtualshellautocomplete::TAutoCompleteContents Value);
	void __fastcall SetDefaultNodeHeight(const unsigned Value);
	void __fastcall SetDropDownCount(const int Value);
	void __fastcall SetIndent(const int Value);
	void __fastcall SetOnAutoCompleteUpdateList(const TOnAutoCompleteUpdateList Value);
	void __fastcall SetOnRollDown(const TOnPopupRollDown Value);
	void __fastcall SetOnRollUp(const TOnPopupRollUp Value);
	void __fastcall SetOptions(const TPopupOptions Value);
	System::Uitypes::TColor __fastcall GetColor(void);
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	
protected:
	void __fastcall AlwaysShowReader(System::Classes::TReader* Reader);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	__property TPopupAutoCompleteDropDown* PopupAutoCompleteDropDown = {read=FPopupAutoCompleteDropDown, write=FPopupAutoCompleteDropDown};
	
__published:
	__property int AnimationSpeed = {read=GetAnimationSpeed, write=SetAnimationSpeed, default=200};
	__property int AutoScrollTimeFast = {read=GetAutoScrollTimeFast, write=SetAutoScrollTimeFast, default=10};
	__property int AutoScrollTimeSlow = {read=GetAutoScrollTimeSlow, write=SetAutoScrollTimeSlow, default=200};
	__property Vcl::Graphics::TPicture* Background = {read=GetBackground, write=SetBackground};
	__property int BackgroundOffsetX = {read=GetBackgroundOffsetX, write=SetBackgroundOffsetX, default=0};
	__property int BackgroundOffsetY = {read=GetBackgroundOffsetY, write=SetBackgroundOffsetY, default=0};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, default=-16777211};
	__property Virtualshellautocomplete::TAutoCompleteContents Contents = {read=GetContents, write=SetContents, default=99};
	__property unsigned DefaultNodeHeight = {read=GetDefaultNodeHeight, write=SetDefaultNodeHeight, default=17};
	__property int DropDownCount = {read=GetDropDownCount, write=SetDropDownCount, default=8};
	__property int Indent = {read=GetIndent, write=SetIndent, default=0};
	__property TOnPopupRollDown OnRollDown = {read=GetOnRollDown, write=SetOnRollDown};
	__property TOnPopupRollUp OnRollUp = {read=GetOnRollUp, write=SetOnRollUp};
	__property TOnAutoCompleteUpdateList OnAutoCompleteUpdateList = {read=GetOnAutoCompleteUpdateList, write=SetOnAutoCompleteUpdateList};
	__property TPopupOptions Options = {read=GetOptions, write=SetOptions, default=50};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TPopupAutoCompleteOptions(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TPopupAutoCompleteOptions(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TPopupAutoCompleteDropDown : public TDropDownWnd
{
	typedef TDropDownWnd inherited;
	
private:
	TPopupAutoCompleteTree* FPopupAutoCompleteTree;
	TCustomVirtualExplorerCombobox* FExplorerCombobox;
	TOnAutoCompleteUpdateList FOnAutoCompleteUpdateList;
	TPopupOptions __fastcall GetPopupOptions(void);
	HIDESBASE void __fastcall SetPopupOptions(const TPopupOptions Value);
	
protected:
	virtual bool __fastcall AllowClickInWindow(HWND Window, const System::Types::TPoint &Point);
	virtual TPopupAutoCompleteTree* __fastcall CreatePopupAutoCompleteTree(void);
	virtual void __fastcall DoRollDown(bool &Allow);
	virtual void __fastcall DoRollDownInit(void);
	virtual void __fastcall DoRollUp(bool Selected);
	virtual void __fastcall KeyPressDispatch(Winapi::Messages::TMessage &Message, bool &Handled);
	virtual void __fastcall RealignChildWindows(int NewWidth, int NewHeight);
	virtual void __fastcall RefreshScrollbar(void);
	virtual unsigned __fastcall RowHeight(void);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &message);
	__property TOnAutoCompleteUpdateList OnAutoCompleteUpdateList = {read=FOnAutoCompleteUpdateList, write=FOnAutoCompleteUpdateList};
	__property TPopupAutoCompleteTree* PopupAutoCompleteTree = {read=FPopupAutoCompleteTree};
	
public:
	__fastcall virtual TPopupAutoCompleteDropDown(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TPopupAutoCompleteDropDown(void);
	__property TCustomVirtualExplorerCombobox* ExplorerCombobox = {read=FExplorerCombobox, write=FExplorerCombobox};
	__property TPopupOptions PopupOptions = {read=GetPopupOptions, write=SetPopupOptions, default=50};
public:
	/* TWinControl.CreateParented */ inline __fastcall TPopupAutoCompleteDropDown(HWND ParentWindow) : TDropDownWnd(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TCustomVirtualExplorerCombobox : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
private:
	Vcl::Extctrls::TTimer* FMouseTimer;
	System::Classes::TNotifyEvent FOldFontOnChange;
	TVETComboBoxDecodeSpecialVariableEvent FOnDecodeSpecialVariable;
	TOnComboPathChanging FOnPathChanging;
	TCustomVirtualExplorerTree* FVirtualExplorerTree;
	bool FThemesActive;
	NativeUInt FThemeCombo;
	NativeUInt FThemeEdit;
	NativeUInt FThemeButton;
	TVETOnComboInvalidEntry FOnInvalidEntry;
	Mpshellutilities::TNamespace* FEditNamespace;
	int FImageIndex;
	System::Types::TRect FButtonRect;
	TVETComboStates FVETComboState;
	TExplorerComboboxText FTextType;
	TVETComboOptions FOptions;
	TPopupAutoCompleteDropDown* FPopupAutoCompleteDropDown;
	TPopupAutoCompleteOptions* FPopupAutoCompleteOptions;
	TPopupExplorerDropDown* FPopupExplorerDropDown;
	TPopupExplorerOptions* FPopupExplorerOptions;
	TComboEdit* FComboEdit;
	TVETOnComboDraw FOnDraw;
	TOnComboPathChange FOnPathChange;
	TShellComboStyle FStyle;
	bool FFlat;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	bool FActive;
	bool FHotTracking;
	System::Uitypes::TColor __fastcall GetColor(void);
	TComboEdit* __fastcall GetComboEdit(void);
	int __fastcall GetImageIndex(void);
	TOnPopupRollDown __fastcall GetOnAutoCompleteRollDown(void);
	TOnPopupRollUp __fastcall GetOnAutoCompleteRollUp(void);
	TOnAutoCompleteUpdateList __fastcall GetOnAutoCompleteUpdateList(void);
	System::Classes::TNotifyEvent __fastcall GetOnChange(void);
	TOnPopupRollDown __fastcall GetOnComboRollDown(void);
	TOnPopupRollUp __fastcall GetOnComboRollUp(void);
	System::Classes::TNotifyEvent __fastcall GetOnEnter(void);
	TVETOnEnumFolder __fastcall GetOnEnumFolder(void);
	System::Classes::TNotifyEvent __fastcall GetOnExit(void);
	System::WideString __fastcall GetPath(void);
	bool __fastcall GetTabStop(void);
	HIDESBASE void __fastcall SetColor(const System::Uitypes::TColor Value);
	void __fastcall SetEditNamespace(Mpshellutilities::TNamespace* const Value);
	void __fastcall SetOnEnumFolder(const TVETOnEnumFolder Value);
	void __fastcall SetOnAutoCompleteRollDown(const TOnPopupRollDown Value);
	void __fastcall SetOnAutoCompleteRollUp(const TOnPopupRollUp Value);
	void __fastcall SetOnAutoCompleteUpdateList(const TOnAutoCompleteUpdateList Value);
	void __fastcall SetOnChange(const System::Classes::TNotifyEvent Value);
	void __fastcall SetOnComboRollDown(const TOnPopupRollDown Value);
	void __fastcall SetOnComboRollUp(const TOnPopupRollUp Value);
	void __fastcall SetOnEnter(const System::Classes::TNotifyEvent Value);
	void __fastcall SetOnExit(const System::Classes::TNotifyEvent Value);
	void __fastcall SetOptions(const TVETComboOptions Value);
	void __fastcall SetPath(const System::WideString Value);
	void __fastcall SetStyle(const TShellComboStyle Value);
	HIDESBASE void __fastcall SetTabStop(const bool Value);
	void __fastcall SetTextType(const TExplorerComboboxText Value);
	void __fastcall SetVirtualExplorerTree(TCustomVirtualExplorerTree* const Value);
	TPopupExplorerTree* __fastcall GetPopupExplorerTree(void);
	Virtualshellautocomplete::TVirtualShellAutoComplete* __fastcall GetAutoComplete(void);
	Virtualshellautocomplete::TVirtualAutoCompleteAddItem __fastcall GetOnAutoCompleteAddItem(void);
	void __fastcall SetOnAutoCompleteAddItem(const Virtualshellautocomplete::TVirtualAutoCompleteAddItem Value);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetFlat(const bool Value);
	
protected:
	System::Types::TRect __fastcall BackGroundRect(TComboItemRect ItemRect);
	void __fastcall ButtonClicked(System::TObject* Sender);
	int __fastcall CalculateEditHeight(void);
	virtual bool __fastcall CanResize(int &NewWidth, int &NewHeight);
	virtual void __fastcall ChangeLinkDispatch(Winapi::Shlobj::PItemIDList PIDL);
	virtual TPopupAutoCompleteOptions* __fastcall CreatePopupAutoCompleteOptions(void);
	virtual TPopupAutoCompleteDropDown* __fastcall CreatePopupAutoCompleteDropDown(void);
	virtual TPopupExplorerOptions* __fastcall CreatePopupExplorerOptions(void);
	virtual TPopupExplorerDropDown* __fastcall CreatePopupExplorerDropDown(void);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DestroyWnd(void);
	virtual void __fastcall DoDecodeSpecialVariable(System::WideString Variable, Mpshellutilities::TNamespace* &NS);
	virtual void __fastcall DoDraw(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &AClientRect, const System::Types::TRect &AButtonRect, TVETComboStates AComboState, Vcl::Comctrls::TCustomDrawStage Stage, bool &DefaultDraw);
	void __fastcall DoFontChange(Vcl::Graphics::TFont* NewFont);
	virtual void __fastcall DoPathChange(Mpshellutilities::TNamespace* SelectedNamespace);
	virtual void __fastcall DoPathChanging(Mpshellutilities::TNamespace* NS, bool &Allow);
	void __fastcall FontChange(System::TObject* Sender);
	void __fastcall FreeThemes(void);
	bool __fastcall MouseInDropDownButton(void);
	void __fastcall MouseTimerCallback(System::TObject* Sender);
	virtual void __fastcall Paint(void);
	void __fastcall PaintCombo(HDC PaintDC);
	void __fastcall RealignControls(void);
	void __fastcall RefreshComboEdit(bool SelectText);
	virtual void __fastcall SetActive(const bool Value);
	void __fastcall SetComboEditColor(System::Uitypes::TColor NewColor);
	virtual void __fastcall SetEnabled(bool Value);
	virtual void __fastcall SetName(const System::Classes::TComponentName Value);
	void __fastcall UpdateDropDownButtonState(void);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	HIDESBASE MESSAGE void __fastcall WMPrintClient(Winapi::Messages::TWMPrint &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Message);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	HIDESBASE MESSAGE void __fastcall WMWindowPosChanging(Winapi::Messages::TWMWindowPosMsg &Message);
	MESSAGE void __fastcall WMThemeChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMFocusChanged(Vcl::Controls::TCMFocusChanged &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMParentFontChanged(Winapi::Messages::TMessage &Message);
	__property bool Active = {read=FActive, write=SetActive, default=0};
	__property Virtualshellautocomplete::TVirtualShellAutoComplete* AutoComplete = {read=GetAutoComplete};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, default=-16777211};
	__property Mpshellutilities::TNamespace* EditNamespace = {read=FEditNamespace, write=SetEditNamespace};
	__property bool Flat = {read=FFlat, write=SetFlat, default=0};
	__property int ImageIndex = {read=GetImageIndex, nodefault};
	__property Vcl::Extctrls::TTimer* MouseTimer = {read=FMouseTimer, write=FMouseTimer};
	__property System::Classes::TNotifyEvent OldFontOnChange = {read=FOldFontOnChange, write=FOldFontOnChange};
	__property TVETComboBoxDecodeSpecialVariableEvent OnDecodeSpecialVariable = {read=FOnDecodeSpecialVariable, write=FOnDecodeSpecialVariable};
	__property TVETOnComboInvalidEntry OnInvalidEntry = {read=FOnInvalidEntry, write=FOnInvalidEntry};
	__property TOnPopupRollDown OnAutoCompleteRollDown = {read=GetOnAutoCompleteRollDown, write=SetOnAutoCompleteRollDown};
	__property TOnPopupRollUp OnAutoCompleteRollUp = {read=GetOnAutoCompleteRollUp, write=SetOnAutoCompleteRollUp};
	__property Virtualshellautocomplete::TVirtualAutoCompleteAddItem OnAutoCompleteAddPath = {read=GetOnAutoCompleteAddItem, write=SetOnAutoCompleteAddItem};
	__property TOnAutoCompleteUpdateList OnAutoCompleteUpdateList = {read=GetOnAutoCompleteUpdateList, write=SetOnAutoCompleteUpdateList};
	__property TOnPopupRollDown OnComboRollDown = {read=GetOnComboRollDown, write=SetOnComboRollDown};
	__property TOnPopupRollUp OnComboRollUp = {read=GetOnComboRollUp, write=SetOnComboRollUp};
	__property System::Classes::TNotifyEvent OnChange = {read=GetOnChange, write=SetOnChange};
	__property TVETOnComboDraw OnDraw = {read=FOnDraw, write=FOnDraw};
	__property System::Classes::TNotifyEvent OnEnter = {read=GetOnEnter, write=SetOnEnter};
	__property TVETOnEnumFolder OnEnumFolder = {read=GetOnEnumFolder, write=SetOnEnumFolder};
	__property System::Classes::TNotifyEvent OnExit = {read=GetOnExit, write=SetOnExit};
	__property TOnComboPathChange OnPathChange = {read=FOnPathChange, write=FOnPathChange};
	__property TOnComboPathChanging OnPathChanging = {read=FOnPathChanging, write=FOnPathChanging};
	__property TVETComboOptions Options = {read=FOptions, write=SetOptions, default=6};
	__property System::WideString Path = {read=GetPath, write=SetPath};
	__property TPopupAutoCompleteDropDown* PopupAutoCompleteDropDown = {read=FPopupAutoCompleteDropDown};
	__property TPopupAutoCompleteOptions* PopupAutoCompleteOptions = {read=FPopupAutoCompleteOptions, write=FPopupAutoCompleteOptions};
	__property TPopupExplorerDropDown* PopupExplorerDropDown = {read=FPopupExplorerDropDown};
	__property TPopupExplorerOptions* PopupExplorerOptions = {read=FPopupExplorerOptions, write=FPopupExplorerOptions};
	__property TPopupExplorerTree* PopupExplorerTree = {read=GetPopupExplorerTree};
	__property TShellComboStyle Style = {read=FStyle, write=SetStyle, default=0};
	__property bool TabStop = {read=GetTabStop, write=SetTabStop, default=1};
	__property TExplorerComboboxText TextType = {read=FTextType, write=SetTextType, default=0};
	__property NativeUInt ThemeButton = {read=FThemeButton, write=FThemeButton, nodefault};
	__property NativeUInt ThemeCombo = {read=FThemeCombo, write=FThemeCombo, nodefault};
	__property NativeUInt ThemeEdit = {read=FThemeEdit, write=FThemeEdit, nodefault};
	__property bool ThemesActive = {read=FThemesActive, write=FThemesActive, nodefault};
	__property TVETComboStates VETComboState = {read=FVETComboState, write=FVETComboState, nodefault};
	__property TCustomVirtualExplorerTree* VirtualExplorerTree = {read=FVirtualExplorerTree, write=SetVirtualExplorerTree};
	
public:
	__fastcall virtual TCustomVirtualExplorerCombobox(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCustomVirtualExplorerCombobox(void);
	DYNAMIC void __fastcall ChangeLinkChanging(System::TObject* Server, Winapi::Shlobj::PItemIDList NewPIDL);
	DYNAMIC void __fastcall ChangeLinkFreeing(_di_IVETChangeLink ChangeLink);
	virtual void __fastcall Loaded(void);
	__property TComboEdit* ComboEdit = {read=GetComboEdit};
	__property bool HotTracking = {read=FHotTracking, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TCustomVirtualExplorerCombobox(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualExplorerCombobox : public TCustomVirtualExplorerCombobox
{
	typedef TCustomVirtualExplorerCombobox inherited;
	
public:
	__property AutoComplete;
	__property EditNamespace;
	__property ComboEdit;
	__property PopupExplorerTree;
	__property PopupAutoCompleteDropDown;
	__property PopupExplorerDropDown;
	__property VETComboState;
	
__published:
	__property Active = {default=0};
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property BorderStyle = {default=1};
	__property Color = {default=-16777211};
	__property Constraints;
	__property Enabled = {default=1};
	__property Flat = {default=0};
	__property Font;
	__property Height = {default=23};
	__property Options = {default=6};
	__property ParentFont = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property Style = {default=0};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Path = {default=0};
	__property PopupAutoCompleteOptions;
	__property PopupExplorerOptions;
	__property TextType = {default=0};
	__property Visible = {default=1};
	__property VirtualExplorerTree;
	__property OnAutoCompleteAddPath;
	__property OnAutoCompleteRollDown;
	__property OnAutoCompleteRollUp;
	__property OnAutoCompleteUpdateList;
	__property OnChange;
	__property OnComboRollDown;
	__property OnComboRollUp;
	__property OnDecodeSpecialVariable;
	__property OnDraw;
	__property OnEnter;
	__property OnEnumFolder;
	__property OnExit;
	__property OnInvalidEntry;
	__property OnPathChange;
	__property OnPathChanging;
public:
	/* TCustomVirtualExplorerCombobox.Create */ inline __fastcall virtual TVirtualExplorerCombobox(System::Classes::TComponent* AOwner) : TCustomVirtualExplorerCombobox(AOwner) { }
	/* TCustomVirtualExplorerCombobox.Destroy */ inline __fastcall virtual ~TVirtualExplorerCombobox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualExplorerCombobox(HWND ParentWindow) : TCustomVirtualExplorerCombobox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TExplorerComboBox : public TVirtualExplorerCombobox
{
	typedef TVirtualExplorerCombobox inherited;
	
public:
	/* TCustomVirtualExplorerCombobox.Create */ inline __fastcall virtual TExplorerComboBox(System::Classes::TComponent* AOwner) : TVirtualExplorerCombobox(AOwner) { }
	/* TCustomVirtualExplorerCombobox.Destroy */ inline __fastcall virtual ~TExplorerComboBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TExplorerComboBox(HWND ParentWindow) : TVirtualExplorerCombobox(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TVirtualBkGndEnumThreadList : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TThreadList* FList;
	
protected:
	__property System::Classes::TThreadList* List = {read=FList, write=FList};
	
public:
	__fastcall TVirtualBkGndEnumThreadList(void);
	__fastcall virtual ~TVirtualBkGndEnumThreadList(void);
	void __fastcall Add(Mpthreadmanager::TCommonThread* Thread);
	void __fastcall Flush(void);
	void __fastcall Remove(Mpthreadmanager::TCommonThread* Thread);
};

#pragma pack(pop)

typedef TVirtualBackGndEnumThread* *PTVirtualBackGndEnumThread;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TVirtualBackGndEnumThread : public Mpthreadmanager::TCommonThread
{
	typedef Mpthreadmanager::TCommonThread inherited;
	
private:
	Mpcommonobjects::TCommonPIDLList* *FEnumBkGndList;
	_RTL_CRITICAL_SECTION FEnumLock;
	TVirtualBackGndEnumThread* *FEnumThread;
	bool FHideRecyleBin;
	Mpcommonobjects::TCommonPIDLList* FList;
	_ITEMIDLIST *FParentPIDL;
	Mpshellutilities::TFileObjects FFileObjects;
	NativeUInt FWndHandle;
	
protected:
	virtual void __fastcall Execute(void);
	virtual void __fastcall FinalizeThread(void);
	virtual void __fastcall InitializeThread(void);
	__property Mpcommonobjects::PCommonPIDLList EnumBkGndList = {read=FEnumBkGndList, write=FEnumBkGndList};
	__property _RTL_CRITICAL_SECTION EnumLock = {read=FEnumLock, write=FEnumLock};
	__property PVirtualBackGndEnumThread EnumThread = {read=FEnumThread, write=FEnumThread};
	__property Mpshellutilities::TFileObjects FileObject = {read=FFileObjects, write=FFileObjects, nodefault};
	__property bool HideRecycleBin = {read=FHideRecyleBin, write=FHideRecyleBin, nodefault};
	__property Mpcommonobjects::TCommonPIDLList* List = {read=FList, write=FList};
	__property Winapi::Shlobj::PItemIDList ParentPIDL = {read=FParentPIDL, write=FParentPIDL};
	__property NativeUInt WndHandle = {read=FWndHandle, write=FWndHandle, nodefault};
	
public:
	__fastcall virtual TVirtualBackGndEnumThread(bool Suspended, bool ForceHideRecycleBin, Winapi::Shlobj::PItemIDList AParentPIDL, Mpshellutilities::TFileObjects AFileObjects, NativeUInt AWndHandle, const _RTL_CRITICAL_SECTION &AnEnumLock, Mpcommonobjects::PCommonPIDLList APIDLList, PVirtualBackGndEnumThread AnEnumThread);
	__fastcall virtual ~TVirtualBackGndEnumThread(void);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 DragBorderWidth = System::Int8(0x5);
static const System::Int8 VETDropDownMinWidth = System::Int8(0x50);
static const System::Int8 VETDropDownMinHeight = System::Int8(0x14);
static const System::Int8 VETStreamStorageVer = System::Int8(0x6);
static const System::Int8 VETStreamStorageVer_0 = System::Int8(0x0);
static const System::Int8 VETStreamStorageVer_1 = System::Int8(0x1);
static const System::Int8 VETStreamStorageVer_2 = System::Int8(0x2);
static const System::Int8 VETStreamStorageVer_3 = System::Int8(0x3);
static const System::Int8 VETStreamStorageVer_4 = System::Int8(0x4);
static const System::Int8 VETStreamStorageVer_5 = System::Int8(0x5);
static const System::Int8 VETStreamStorageVer_6 = System::Int8(0x6);
static const System::Int8 BKGNDLENTHYOPERATIONTIME = System::Int8(0x14);
static const System::Int8 AFTEREDITDELAY = System::Int8(0x64);
static const System::Int8 BORDER = System::Int8(0x1);
#define INVALIDFILECHAR (System::Set<char, _DELPHI_SET_CHAR(0), _DELPHI_SET_CHAR(255)>() << '\x22' << '\x2a' << '\x2f' << '\x3a' << '\x3c' << '\x3e' << '\x3f' << '\x5c' << '\x7c' )
static const System::Byte ID_HARDREFRESHTIMER = System::Byte(0xcc);
static const System::Word TID_ICON = System::Word(0x2706);
static const System::Word TID_EXPANDMARK = System::Word(0x2707);
static const System::Word WM_VETCOMBO_SELECTALL = System::Word(0x8038);
#define DefaultVETPaintOptions (System::Set<Virtualtrees::TVTPaintOption, Virtualtrees::TVTPaintOption::toHideFocusRect, Virtualtrees::TVTPaintOption::toShowFilteredNodes>() << Virtualtrees::TVTPaintOption::toShowButtons << Virtualtrees::TVTPaintOption::toShowTreeLines << Virtualtrees::TVTPaintOption::toUseBlendedImages << Virtualtrees::TVTPaintOption::toGhostedIfUnfocused )
#define DefaultVETFolderOptions (System::Set<TVETFolderOption, TVETFolderOption::toFoldersExpandable, TVETFolderOption::toThreadedExpandMark>() << TVETFolderOption::toFoldersExpandable )
#define DefaultVETShellOptions (System::Set<TVETShellOption, TVETShellOption::toRightAlignSizeColumn, TVETShellOption::toFullRowContextMenuActivate>() << TVETShellOption::toRightAlignSizeColumn << TVETShellOption::toContextMenus )
#define DefaultVETMiscOptions (System::Set<TVETMiscOption, TVETMiscOption::toBrowseExecuteFolder, TVETMiscOption::toPersistListviewColumnSort>() << TVETMiscOption::toBrowseExecuteFolder << TVETMiscOption::toBrowseExecuteFolderShortcut << TVETMiscOption::toBrowseExecuteZipFolder << TVETMiscOption::toExecuteOnDblClk )
#define DefaultVETImageOptions (System::Set<TVETImageOption, TVETImageOption::toHideOverlay, TVETImageOption::toMarkCutAndCopy>() << TVETImageOption::toImages << TVETImageOption::toMarkCutAndCopy )
#define DefaultVETSyncOptions (System::Set<TVETSyncOption, TVETSyncOption::toCollapseTargetFirst, TVETSyncOption::toSelectTarget>() << TVETSyncOption::toCollapseTargetFirst << TVETSyncOption::toExpandTarget << TVETSyncOption::toSelectTarget )
#define DefaultExplorerTreeFileObjects (System::Set<Mpshellutilities::Mpshellutilities__5, Mpshellutilities::Mpshellutilities__5::foFolders, Mpshellutilities::Mpshellutilities__5::foIncludeSuperHidden>() << Mpshellutilities::Mpshellutilities__5::foFolders << Mpshellutilities::Mpshellutilities__5::foHidden )
#define DefaultExplorerTreeAutoOptions (System::Set<Virtualtrees::TVTAutoOption, Virtualtrees::TVTAutoOption::toAutoDropExpand, Virtualtrees::TVTAutoOption::toAutoBidiColumnOrdering>() << Virtualtrees::TVTAutoOption::toAutoScroll )
#define DefaultExplorerTreeMiscOptions (System::Set<Virtualtrees::TVTMiscOption, Virtualtrees::TVTMiscOption::toAcceptOLEDrop, Virtualtrees::TVTMiscOption::toReverseFullExpandHotKey>() << Virtualtrees::TVTMiscOption::toAcceptOLEDrop << Virtualtrees::TVTMiscOption::toEditable << Virtualtrees::TVTMiscOption::toToggleOnDblClick )
#define DefaultExplorerTreePaintOptions (System::Set<Virtualtrees::TVTPaintOption, Virtualtrees::TVTPaintOption::toHideFocusRect, Virtualtrees::TVTPaintOption::toShowFilteredNodes>() << Virtualtrees::TVTPaintOption::toShowButtons << Virtualtrees::TVTPaintOption::toShowTreeLines << Virtualtrees::TVTPaintOption::toUseBlendedImages << Virtualtrees::TVTPaintOption::toGhostedIfUnfocused )
#define DefaultExplorerTreeVETFolderOptions (System::Set<TVETFolderOption, TVETFolderOption::toFoldersExpandable, TVETFolderOption::toThreadedExpandMark>() << TVETFolderOption::toFoldersExpandable )
#define DefaultExplorerTreeVETShellOptions (System::Set<TVETShellOption, TVETShellOption::toRightAlignSizeColumn, TVETShellOption::toFullRowContextMenuActivate>() << TVETShellOption::toContextMenus )
#define DefaultExplorerTreeVETMiscOptions (System::Set<TVETMiscOption, TVETMiscOption::toBrowseExecuteFolder, TVETMiscOption::toPersistListviewColumnSort>() << TVETMiscOption::toBrowseExecuteFolder << TVETMiscOption::toBrowseExecuteFolderShortcut << TVETMiscOption::toBrowseExecuteZipFolder << TVETMiscOption::toChangeNotifierThread << TVETMiscOption::toRemoveContextMenuShortCut )
#define DefaultExplorerTreeVETImageOptions (System::Set<TVETImageOption, TVETImageOption::toHideOverlay, TVETImageOption::toMarkCutAndCopy>() << TVETImageOption::toImages << TVETImageOption::toThreadedImages << TVETImageOption::toMarkCutAndCopy )
#define DefaultExplorerTreeVETSelectionOptions (System::Set<Virtualtrees::TVTSelectionOption, Virtualtrees::TVTSelectionOption::toDisableDrawSelection, Virtualtrees::TVTSelectionOption::toRestoreSelection>() << Virtualtrees::TVTSelectionOption::toLevelSelectConstraint )
#define DefaultExplorerTreeVETSyncOptions (System::Set<TVETSyncOption, TVETSyncOption::toCollapseTargetFirst, TVETSyncOption::toSelectTarget>() << TVETSyncOption::toCollapseTargetFirst << TVETSyncOption::toExpandTarget << TVETSyncOption::toSelectTarget )
#define DefaultExplorerListFileObjects (System::Set<Mpshellutilities::Mpshellutilities__5, Mpshellutilities::Mpshellutilities__5::foFolders, Mpshellutilities::Mpshellutilities__5::foIncludeSuperHidden>() << Mpshellutilities::Mpshellutilities__5::foFolders << Mpshellutilities::Mpshellutilities__5::foNonFolders << Mpshellutilities::Mpshellutilities__5::foHidden << Mpshellutilities::Mpshellutilities__5::foEnableAsync )
#define DefaultExplorerListPaintOptions (System::Set<Virtualtrees::TVTPaintOption, Virtualtrees::TVTPaintOption::toHideFocusRect, Virtualtrees::TVTPaintOption::toShowFilteredNodes>() << Virtualtrees::TVTPaintOption::toShowTreeLines << Virtualtrees::TVTPaintOption::toUseBlendedImages << Virtualtrees::TVTPaintOption::toGhostedIfUnfocused )
#define DefaultExplorerListMiscOptions (System::Set<Virtualtrees::TVTMiscOption, Virtualtrees::TVTMiscOption::toAcceptOLEDrop, Virtualtrees::TVTMiscOption::toReverseFullExpandHotKey>() << Virtualtrees::TVTMiscOption::toAcceptOLEDrop << Virtualtrees::TVTMiscOption::toEditable << Virtualtrees::TVTMiscOption::toReportMode << Virtualtrees::TVTMiscOption::toToggleOnDblClick )
#define DefaultExplorerListAutoOptions (System::Set<Virtualtrees::TVTAutoOption, Virtualtrees::TVTAutoOption::toAutoDropExpand, Virtualtrees::TVTAutoOption::toAutoBidiColumnOrdering>() << Virtualtrees::TVTAutoOption::toAutoScroll )
#define DefaultExplorerListVETFolderOptions (System::Set<TVETFolderOption, TVETFolderOption::toFoldersExpandable, TVETFolderOption::toThreadedExpandMark>() << TVETFolderOption::toHideRootFolder )
#define DefaultExplorerListVETShellOptions (System::Set<TVETShellOption, TVETShellOption::toRightAlignSizeColumn, TVETShellOption::toFullRowContextMenuActivate>() << TVETShellOption::toRightAlignSizeColumn << TVETShellOption::toContextMenus << TVETShellOption::toShellColumnMenu )
#define DefaultExplorerListVETMiscOptions (System::Set<TVETMiscOption, TVETMiscOption::toBrowseExecuteFolder, TVETMiscOption::toPersistListviewColumnSort>() << TVETMiscOption::toBrowseExecuteFolder << TVETMiscOption::toBrowseExecuteFolderShortcut << TVETMiscOption::toBrowseExecuteZipFolder << TVETMiscOption::toChangeNotifierThread << TVETMiscOption::toExecuteOnDblClk )
#define DefaultExplorerListVETImageOptions (System::Set<TVETImageOption, TVETImageOption::toHideOverlay, TVETImageOption::toMarkCutAndCopy>() << TVETImageOption::toImages << TVETImageOption::toThreadedImages << TVETImageOption::toMarkCutAndCopy )
#define DefaultExplorerListVETSelectionOptions (System::Set<Virtualtrees::TVTSelectionOption, Virtualtrees::TVTSelectionOption::toDisableDrawSelection, Virtualtrees::TVTSelectionOption::toRestoreSelection>() << Virtualtrees::TVTSelectionOption::toLevelSelectConstraint << Virtualtrees::TVTSelectionOption::toMultiSelect << Virtualtrees::TVTSelectionOption::toRightClickSelect )
#define DefaultExplorerListVETSyncOptions (System::Set<TVETSyncOption, TVETSyncOption::toCollapseTargetFirst, TVETSyncOption::toSelectTarget>() << TVETSyncOption::toCollapseTargetFirst << TVETSyncOption::toExpandTarget << TVETSyncOption::toSelectTarget )
#define DefaultExplorerListHeaderOptions (System::Set<Virtualtrees::TVTHeaderOption, Virtualtrees::TVTHeaderOption::hoAutoResize, Virtualtrees::TVTHeaderOption::hoAutoColumnPopupMenu>() << Virtualtrees::TVTHeaderOption::hoColumnResize << Virtualtrees::TVTHeaderOption::hoDblClickResize << Virtualtrees::TVTHeaderOption::hoDrag << Virtualtrees::TVTHeaderOption::hoShowSortGlyphs )
#define DefaultExplorerComboFileObjects (System::Set<Mpshellutilities::Mpshellutilities__5, Mpshellutilities::Mpshellutilities__5::foFolders, Mpshellutilities::Mpshellutilities__5::foIncludeSuperHidden>() << Mpshellutilities::Mpshellutilities__5::foFolders << Mpshellutilities::Mpshellutilities__5::foHidden )
#define DefaultPopupMiscOptions System::Set<System::Byte>()
#define DefaultPopupPaintOptions (System::Set<Virtualtrees::TVTPaintOption, Virtualtrees::TVTPaintOption::toHideFocusRect, Virtualtrees::TVTPaintOption::toShowFilteredNodes>() << Virtualtrees::TVTPaintOption::toHideFocusRect << Virtualtrees::TVTPaintOption::toPopupMode << Virtualtrees::TVTPaintOption::toShowBackground << Virtualtrees::TVTPaintOption::toUseBlendedImages )
#define DefaultPopupAutoOptions (System::Set<Virtualtrees::TVTAutoOption, Virtualtrees::TVTAutoOption::toAutoDropExpand, Virtualtrees::TVTAutoOption::toAutoBidiColumnOrdering>() << Virtualtrees::TVTAutoOption::toAutoScroll << Virtualtrees::TVTAutoOption::toAutoScrollOnExpand )
#define DefaultPopupSelectionOptions (System::Set<Virtualtrees::TVTSelectionOption, Virtualtrees::TVTSelectionOption::toDisableDrawSelection, Virtualtrees::TVTSelectionOption::toRestoreSelection>() << Virtualtrees::TVTSelectionOption::toDisableDrawSelection )
#define DefaultExplorerComboVETFolderOptions (System::Set<TVETFolderOption, TVETFolderOption::toFoldersExpandable, TVETFolderOption::toThreadedExpandMark>() << TVETFolderOption::toFoldersExpandable )
#define DefaultExplorerComboVETShellOptions System::Set<System::Byte>()
#define DefaultExplorerComboVETMiscOptions (System::Set<TVETMiscOption, TVETMiscOption::toBrowseExecuteFolder, TVETMiscOption::toPersistListviewColumnSort>() << TVETMiscOption::toBrowseExecuteFolder << TVETMiscOption::toBrowseExecuteZipFolder )
#define DefaultExplorerComboVETImageOptions (System::Set<TVETImageOption, TVETImageOption::toHideOverlay, TVETImageOption::toMarkCutAndCopy>() << TVETImageOption::toImages )
#define DefaultExplorerComboVETSyncOptions (System::Set<TVETSyncOption, TVETSyncOption::toCollapseTargetFirst, TVETSyncOption::toSelectTarget>() << TVETSyncOption::toCollapseTargetFirst << TVETSyncOption::toSelectTarget )
#define DefaultExplorerComboOptions (System::Set<TVETComboOption, TVETComboOption::vcboThreadedImages, TVETComboOption::vcboSelectPathOnDropDown>() << TVETComboOption::vcboThemeAware << TVETComboOption::vcboSelectPathOnDropDown )
#define DefaultPopupOptions (System::Set<TPopupOption, TPopupOption::poAnimated, TPopupOption::poThemeAware>() << TPopupOption::poEnabled << TPopupOption::poRespectSysAnimationFlag << TPopupOption::poThemeAware )
extern DELPHI_PACKAGE int NodeCount;
extern DELPHI_PACKAGE TVETChangeDispatch* VETChangeDispatch;
extern DELPHI_PACKAGE TGlobalViewManager* ViewManager;
extern DELPHI_PACKAGE TVirtualBkGndEnumThreadList* BkGndEnumThreadList;
extern DELPHI_PACKAGE int VETChangeObjects;
extern DELPHI_PACKAGE int TestCount;
extern DELPHI_PACKAGE void __fastcall ReadFolder(_di_IShellFolder Folder, unsigned Flags, Mpcommonobjects::TPIDLArray &APIDLArray, bool Sorted, int &PIDLsRead);
}	/* namespace Virtualexplorertree */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALEXPLORERTREE)
using namespace Virtualexplorertree;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualexplorertreeHPP
