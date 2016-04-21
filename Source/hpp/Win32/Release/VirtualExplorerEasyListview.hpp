// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualExplorerEasyListview.pas' rev: 31.00 (Windows)

#ifndef VirtualexplorereasylistviewHPP
#define VirtualexplorereasylistviewHPP

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
#include <System.Math.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ImgList.hpp>
#include <System.Win.Registry.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Winapi.ActiveX.hpp>
#include <Winapi.ShlObj.hpp>
#include <VirtualTrees.hpp>
#include <MPCommonUtilities.hpp>
#include <MPShellTypes.hpp>
#include <MPCommonObjects.hpp>
#include <MPThreadManager.hpp>
#include <MPDataObject.hpp>
#include <MPShellUtilities.hpp>
#include <VirtualResources.hpp>
#include <VirtualShellNotifier.hpp>
#include <VirtualThumbnails.hpp>
#include <ColumnForm.hpp>
#include <EasyListview.hpp>
#include <VirtualExplorerTree.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>
#include <Vcl.Forms.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualexplorereasylistview
{
//-- forward type declarations -----------------------------------------------
struct TGroupingModifiedRec;
struct TGroupingFileSizeRec;
struct TColumnPositionIndex;
struct TVirtualExplorerEasyListviewHeaderState;
class DELPHICLASS TEasyVirtualThumbView;
class DELPHICLASS TEasyThumbsManager;
class DELPHICLASS TEasyThumbnailThreadRequest;
class DELPHICLASS TEasyDetailsThreadRequest;
class DELPHICLASS TEasyDetailStringsThreadRequest;
struct TItemSearchRec;
class DELPHICLASS TELVPersistent;
class DELPHICLASS TExtensionColorCode;
class DELPHICLASS TExtensionColorCodeList;
class DELPHICLASS TExplorerItem;
class DELPHICLASS TExplorerColumn;
class DELPHICLASS TExplorerGroup;
class DELPHICLASS TEasyVirtualSelectionManager;
class DELPHICLASS TCategory;
class DELPHICLASS TCategories;
class DELPHICLASS TVirtualCustomFileTypes;
class DELPHICLASS TVirtualEasyListviewDataObject;
class DELPHICLASS TEasyExplorerMemoEditor;
class DELPHICLASS TEasyExplorerStringEditor;
class DELPHICLASS TCustomVirtualExplorerEasyListview;
class DELPHICLASS TVirtualDropStackItem;
class DELPHICLASS TCustomVirtualDropStack;
class DELPHICLASS TVirtualExplorerEasyListview;
class DELPHICLASS TCustomVirtualMultiPathExplorerEasyListview;
class DELPHICLASS TVirtualMultiPathExplorerEasyListview;
class DELPHICLASS TVirtualDropStack;
class DELPHICLASS TVirtualExplorerEasyListviewHintWindow;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::WideString, 8> Virtualexplorereasylistview__1;

typedef System::StaticArray<System::WideString, 13> Virtualexplorereasylistview__2;

typedef Virtualthumbnails::TThumbInfo* __fastcall (__closure *TCreateCustomThumbInfoProc)(Mpshellutilities::TNamespace* NS, TEasyThumbnailThreadRequest* ARequest);

typedef void __fastcall (__closure *TELVOnBeforeItemThumbnailDraw)(Easylistview::TEasyItem* Item);

typedef TExplorerColumn* __fastcall (__closure *TELVAddColumnProc)(void);

enum DECLSPEC_DENUM PositionSortType : unsigned char { pstPosition, pstIndex };

enum DECLSPEC_DENUM TVirtualFileSizeFormat : unsigned char { vfsfDefault, vfsfExplorer, vfsfActual, vfsfDiskUsage, vfsfText };

#pragma pack(push,1)
struct DECLSPEC_DRECORD TGroupingModifiedRec
{
public:
	System::WideString Caption;
	float Days;
	bool Enabled;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TGroupingFileSizeRec
{
public:
	System::WideString Caption;
	__int64 FileSize;
	bool Enabled;
	bool SpecialFolder;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TColumnPositionIndex
{
public:
	System::Word Index;
	System::Word Position;
};
#pragma pack(pop)


typedef System::DynamicArray<TGroupingModifiedRec> TGroupingModifiedArray;

typedef System::DynamicArray<TGroupingFileSizeRec> TGroupingFileSizeArray;

typedef TVirtualExplorerEasyListviewHeaderState *PVirtualExplorerEasyListviewHeaderState;

struct DECLSPEC_DRECORD TVirtualExplorerEasyListviewHeaderState
{
	
private:
	typedef System::DynamicArray<bool> _TVirtualExplorerEasyListviewHeaderState__1;
	
	typedef System::DynamicArray<int> _TVirtualExplorerEasyListviewHeaderState__2;
	
	typedef System::DynamicArray<TColumnPositionIndex> _TVirtualExplorerEasyListviewHeaderState__3;
	
	typedef System::DynamicArray<Easylistview::TEasySortDirection> _TVirtualExplorerEasyListviewHeaderState__4;
	
	
public:
	_TVirtualExplorerEasyListviewHeaderState__1 Visible;
	_TVirtualExplorerEasyListviewHeaderState__2 Width;
	_TVirtualExplorerEasyListviewHeaderState__3 Position;
	_TVirtualExplorerEasyListviewHeaderState__4 SortDirection;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TEasyVirtualThumbView : public Easylistview::TEasyViewThumbnailItem
{
	typedef Easylistview::TEasyViewThumbnailItem inherited;
	
public:
	virtual bool __fastcall FullRowSelect(void);
	virtual void __fastcall ItemRectArray(Easylistview::TEasyItem* Item, Easylistview::TEasyColumn* Column, Vcl::Graphics::TCanvas* ACanvas, const System::WideString Caption, Easylistview::TEasyRectArrayObject &RectArray);
	virtual void __fastcall PaintAfter(Easylistview::TEasyItem* Item, Easylistview::TEasyColumn* Column, const System::WideString Caption, Vcl::Graphics::TCanvas* ACanvas, const Easylistview::TEasyRectArrayObject &RectArray);
	virtual void __fastcall PaintImage(Easylistview::TEasyItem* Item, Easylistview::TEasyColumn* Column, const System::WideString Caption, const Easylistview::TEasyRectArrayObject &RectArray, Easylistview::TEasyImageSize ImageSize, Vcl::Graphics::TCanvas* ACanvas);
	virtual void __fastcall PaintText(Easylistview::TEasyItem* Item, Easylistview::TEasyColumn* Column, const System::WideString Caption, const Easylistview::TEasyRectArrayObject &RectArray, Vcl::Graphics::TCanvas* ACanvas, int LinesToDraw);
public:
	/* TEasyOwnedPersistentGroupItem.Create */ inline __fastcall virtual TEasyVirtualThumbView(Easylistview::TEasyGroup* AnOwner) : Easylistview::TEasyViewThumbnailItem(AnOwner) { }
	
public:
	/* TEasyOwnedPersistentView.Destroy */ inline __fastcall virtual ~TEasyVirtualThumbView(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TEasyThumbsManager : public Virtualthumbnails::TThumbsManager
{
	typedef Virtualthumbnails::TThumbsManager inherited;
	
private:
	TCustomVirtualExplorerEasyListview* FController;
	bool FUseEndScrollDraw;
	
public:
	__fastcall virtual TEasyThumbsManager(System::Classes::TComponent* AOwner);
	virtual void __fastcall LoadAlbum(bool Force = false);
	virtual void __fastcall SaveAlbum(void);
	void __fastcall ReloadThumbnail(Easylistview::TEasyItem* Item);
	__property TCustomVirtualExplorerEasyListview* Controller = {read=FController};
	__property bool UseEndScrollDraw = {read=FUseEndScrollDraw, write=FUseEndScrollDraw, nodefault};
public:
	/* TCustomThumbsManager.Destroy */ inline __fastcall virtual ~TEasyThumbsManager(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TEasyThumbnailThreadRequest : public Mpthreadmanager::TPIDLThreadRequest
{
	typedef Mpthreadmanager::TPIDLThreadRequest inherited;
	
private:
	System::Uitypes::TColor FBackgroundColor;
	bool FUseExifThumbnail;
	bool FUseExifOrientation;
	bool FUseShellExtraction;
	bool FUseSubsampling;
	Virtualthumbnails::TThumbInfo* FInternalThumbInfo;
	System::Types::TPoint FThumbSize;
	TCreateCustomThumbInfoProc FCreateCustomThumbInfoProc;
	
public:
	__fastcall virtual ~TEasyThumbnailThreadRequest(void);
	virtual bool __fastcall HandleRequest(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property System::Uitypes::TColor BackgroundColor = {read=FBackgroundColor, write=FBackgroundColor, nodefault};
	__property System::Types::TPoint ThumbSize = {read=FThumbSize, write=FThumbSize};
	__property bool UseExifThumbnail = {read=FUseExifThumbnail, write=FUseExifThumbnail, nodefault};
	__property bool UseExifOrientation = {read=FUseExifOrientation, write=FUseExifOrientation, nodefault};
	__property bool UseShellExtraction = {read=FUseShellExtraction, write=FUseShellExtraction, nodefault};
	__property bool UseSubsampling = {read=FUseSubsampling, write=FUseSubsampling, nodefault};
	__property TCreateCustomThumbInfoProc CreateCustomThumbInfoProc = {read=FCreateCustomThumbInfoProc, write=FCreateCustomThumbInfoProc};
public:
	/* TCommonThreadRequest.Create */ inline __fastcall virtual TEasyThumbnailThreadRequest(void) : Mpthreadmanager::TPIDLThreadRequest() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TEasyDetailsThreadRequest : public Mpthreadmanager::TPIDLThreadRequest
{
	typedef Mpthreadmanager::TPIDLThreadRequest inherited;
	
public:
	Mpcommonutilities::TCommonIntegerDynArray FDetailRequest;
	Mpcommonutilities::TCommonIntegerDynArray FDetails;
	virtual bool __fastcall HandleRequest(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property Mpcommonutilities::TCommonIntegerDynArray DetailRequest = {read=FDetailRequest, write=FDetailRequest};
	__property Mpcommonutilities::TCommonIntegerDynArray Details = {read=FDetails, write=FDetails};
public:
	/* TPIDLThreadRequest.Destroy */ inline __fastcall virtual ~TEasyDetailsThreadRequest(void) { }
	
public:
	/* TCommonThreadRequest.Create */ inline __fastcall virtual TEasyDetailsThreadRequest(void) : Mpthreadmanager::TPIDLThreadRequest() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TEasyDetailStringsThreadRequest : public Mpthreadmanager::TPIDLThreadRequest
{
	typedef Mpthreadmanager::TPIDLThreadRequest inherited;
	
private:
	bool FAddTitleColumnCaption;
	
public:
	Mpcommonutilities::TCommonIntegerDynArray FDetailRequest;
	Mpcommonutilities::TCommonWideStringDynArray FDetails;
	virtual bool __fastcall HandleRequest(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property bool AddTitleColumnCaption = {read=FAddTitleColumnCaption, write=FAddTitleColumnCaption, nodefault};
	__property Mpcommonutilities::TCommonIntegerDynArray DetailRequest = {read=FDetailRequest, write=FDetailRequest};
	__property Mpcommonutilities::TCommonWideStringDynArray Details = {read=FDetails, write=FDetails};
public:
	/* TPIDLThreadRequest.Destroy */ inline __fastcall virtual ~TEasyDetailStringsThreadRequest(void) { }
	
public:
	/* TCommonThreadRequest.Create */ inline __fastcall virtual TEasyDetailStringsThreadRequest(void) : Mpthreadmanager::TPIDLThreadRequest() { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TVirtualEasyListviewOption : unsigned char { eloBrowseExecuteFolder, eloBrowseExecuteFolderShortcut, eloBrowseExecuteZipFolder, eloExecuteOnDblClick, eloHideRecycleBin, eloThreadedEnumeration, eloThreadedImages, eloThreadedDetails, eloQueryInfoHints, eloShellContextMenus, eloChangeNotifierThread, eloTrackChangesInMappedDrives, eloNoRebuildIconListOnAssocChange, eloRemoveContextMenuShortCut, eloPerFolderStorage, eloUseColumnOnByDefaultFlag, eloFullFlushItemsOnChangeNotify, eloGhostHiddenFiles, eloIncludeThumbnailsWithQueryInfoHints };

typedef System::Set<TVirtualEasyListviewOption, TVirtualEasyListviewOption::eloBrowseExecuteFolder, TVirtualEasyListviewOption::eloIncludeThumbnailsWithQueryInfoHints> TVirtualEasyListviewOptions;

enum DECLSPEC_DENUM TEasyCategoryType : unsigned char { ectNoCategory, ectStandardAlphabetical, etcStandardDriveSize, ectStandardDriveType, ectStandardFreeSpace, ectStandardSize, ectStandardTime, ectStandardMerged, ectUnknown };

#pragma pack(push,1)
struct DECLSPEC_DRECORD TItemSearchRec
{
public:
	TExplorerItem* Item;
	bool Valid;
};
#pragma pack(pop)


typedef System::DynamicArray<TItemSearchRec> TItemSearchArray;

enum DECLSPEC_DENUM TEVLPersistentState : unsigned char { epsRestoring, epsSaving };

typedef System::Set<TEVLPersistentState, TEVLPersistentState::epsRestoring, TEVLPersistentState::epsSaving> TEVLPersistentStates;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TELVPersistent : public Mpshellutilities::TStreamableClass
{
	typedef Mpshellutilities::TStreamableClass inherited;
	
private:
	_ITEMIDLIST *FFocusPIDL;
	Virtualexplorertree::TRootFolder FRootFolder;
	System::WideString FRootFolderCustomPath;
	_ITEMIDLIST *FRootFolderCustomPIDL;
	Mpcommonobjects::TCommonPIDLList* FSelectedPIDLs;
	TEVLPersistentStates FStates;
	Virtualexplorertree::TNodeStorage* FStorage;
	_ITEMIDLIST *FTopNodePIDL;
	
protected:
	void __fastcall Clear(void);
	
public:
	__fastcall TELVPersistent(void);
	__fastcall virtual ~TELVPersistent(void);
	virtual void __fastcall LoadFromFile(System::WideString FileName, int Version = 0x6, bool ReadVerFromStream = true);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x6, bool ReadVerFromStream = true);
	virtual void __fastcall RestoreList(TCustomVirtualExplorerEasyListview* ELV, bool RestoreSelection, bool RestoreFocus, bool ScrollToOldTopNode = false);
	virtual void __fastcall SaveList(TCustomVirtualExplorerEasyListview* ELV, bool SaveSelection, bool SaveFocus);
	virtual void __fastcall SaveToFile(System::WideString FileName, int Version = 0x6, bool ReadVerFromStream = true);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x6, bool WriteVerToStream = true);
	__property Winapi::Shlobj::PItemIDList FocusPIDL = {read=FFocusPIDL, write=FFocusPIDL};
	__property Virtualexplorertree::TRootFolder RootFolder = {read=FRootFolder, write=FRootFolder, nodefault};
	__property System::WideString RootFolderCustomPath = {read=FRootFolderCustomPath, write=FRootFolderCustomPath};
	__property Winapi::Shlobj::PItemIDList RootFolderCustomPIDL = {read=FRootFolderCustomPIDL, write=FRootFolderCustomPIDL};
	__property Mpcommonobjects::TCommonPIDLList* SelectedPIDLs = {read=FSelectedPIDLs, write=FSelectedPIDLs};
	__property TEVLPersistentStates States = {read=FStates, write=FStates, nodefault};
	__property Virtualexplorertree::TNodeStorage* Storage = {read=FStorage, write=FStorage};
	__property Winapi::Shlobj::PItemIDList TopNodePIDL = {read=FTopNodePIDL, write=FTopNodePIDL};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TExtensionColorCode : public Mpshellutilities::TStreamableClass
{
	typedef Mpshellutilities::TStreamableClass inherited;
	
private:
	bool FBold;
	System::Uitypes::TColor FColor;
	bool FEnabled;
	System::Classes::TStringList* FExtension;
	System::WideString FFExtensionMask;
	bool FItalic;
	bool FUnderLine;
	System::WideString __fastcall GetExtensionMask(void);
	void __fastcall SetExtensionMask(const System::WideString Value);
	
protected:
	__property System::WideString FExtensionMask = {read=FFExtensionMask, write=FFExtensionMask};
	
public:
	__fastcall TExtensionColorCode(void);
	__fastcall virtual ~TExtensionColorCode(void);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x0, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x0, bool WriteVerToStream = false);
	__property bool Bold = {read=FBold, write=FBold, nodefault};
	__property System::Uitypes::TColor Color = {read=FColor, write=FColor, nodefault};
	__property bool Enabled = {read=FEnabled, write=FEnabled, nodefault};
	__property System::WideString ExtensionMask = {read=GetExtensionMask, write=SetExtensionMask};
	__property System::Classes::TStringList* Extensions = {read=FExtension, write=FExtension};
	__property bool Italic = {read=FItalic, write=FItalic, nodefault};
	__property bool UnderLine = {read=FUnderLine, write=FUnderLine, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TExtensionColorCodeList : public Mpshellutilities::TStreamableClass
{
	typedef Mpshellutilities::TStreamableClass inherited;
	
public:
	TExtensionColorCode* operator[](int Index) { return this->Items[Index]; }
	
private:
	System::Classes::TList* FItemList;
	int __fastcall GetCount(void);
	TExtensionColorCode* __fastcall GetItems(int Index);
	void __fastcall SetItems(int Index, TExtensionColorCode* Value);
	
protected:
	__property System::Classes::TList* ItemList = {read=FItemList, write=FItemList};
	
public:
	__fastcall TExtensionColorCodeList(void);
	__fastcall virtual ~TExtensionColorCodeList(void);
	TExtensionColorCode* __fastcall Add(System::WideString ExtList, System::Uitypes::TColor AColor, bool IsBold = false, bool IsItalic = false, bool IsUnderLine = false, bool IsEnabled = true);
	TExtensionColorCode* __fastcall FindColorCode(Mpshellutilities::TNamespace* NS);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall Clear(void);
	TExtensionColorCode* __fastcall Find(System::WideString ExtList);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int Version = 0x0, bool ReadVerFromStream = false);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int Version = 0x0, bool WriteVerToStream = false);
	__property int Count = {read=GetCount, nodefault};
	__property TExtensionColorCode* Items[int Index] = {read=GetItems, write=SetItems/*, default*/};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TExplorerItem : public Easylistview::TEasyItemVirtual
{
	typedef Easylistview::TEasyItemVirtual inherited;
	
private:
	Mpshellutilities::TNamespace* FNamespace;
	Virtualthumbnails::TThumbInfo* FThumbInfo;
	
public:
	__fastcall virtual TExplorerItem(Easylistview::TEasyCollection* ACollection);
	__fastcall virtual ~TExplorerItem(void);
	__property Mpshellutilities::TNamespace* Namespace = {read=FNamespace, write=FNamespace};
	__property Virtualthumbnails::TThumbInfo* ThumbInfo = {read=FThumbInfo, write=FThumbInfo};
};

#pragma pack(pop)

typedef System::TMetaClass* TExplorerItemClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TExplorerColumn : public Easylistview::TEasyColumnStored
{
	typedef Easylistview::TEasyColumnStored inherited;
	
private:
	bool FIsCustom;
	
public:
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S, int &AVersion);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, int AVersion = 0x6);
	__property bool IsCustom = {read=FIsCustom, write=FIsCustom, nodefault};
public:
	/* TEasyColumnStored.Create */ inline __fastcall virtual TExplorerColumn(Easylistview::TEasyCollection* ACollection) : Easylistview::TEasyColumnStored(ACollection) { }
	/* TEasyColumnStored.Destroy */ inline __fastcall virtual ~TExplorerColumn(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TExplorerColumnClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TExplorerGroup : public Easylistview::TEasyGroupStored
{
	typedef Easylistview::TEasyGroupStored inherited;
	
private:
	int FGroupKey;
	
public:
	__fastcall virtual TExplorerGroup(Easylistview::TEasyCollection* ACollection);
	__fastcall virtual ~TExplorerGroup(void);
	__property int GroupKey = {read=FGroupKey, write=FGroupKey, nodefault};
};

#pragma pack(pop)

typedef System::TMetaClass* TExplorerGroupClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TEasyVirtualSelectionManager : public Easylistview::TEasySelectionManager
{
	typedef Easylistview::TEasySelectionManager inherited;
	
private:
	bool FFirstItemFocus;
	
public:
	__fastcall virtual TEasyVirtualSelectionManager(Easylistview::TCustomEasyListview* AnOwner);
	
__published:
	__property bool FirstItemFocus = {read=FFirstItemFocus, write=FFirstItemFocus, default=1};
	__property ForceDefaultBlend = {default=1};
public:
	/* TEasySelectionManager.Destroy */ inline __fastcall virtual ~TEasyVirtualSelectionManager(void) { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TThumbThreadCreateProc)(TEasyThumbnailThreadRequest* &ThumbRequest);

typedef void __fastcall (__closure *TELVOnEnumFolder)(TCustomVirtualExplorerEasyListview* Sender, Mpshellutilities::TNamespace* Namespace, bool &AllowAsChild);

typedef void __fastcall (__closure *TELVExplorerGroupClassEvent)(TCustomVirtualExplorerEasyListview* Sender, TExplorerGroupClass &ExplorerClass);

typedef void __fastcall (__closure *TELVExplorerItemClassEvent)(TCustomVirtualExplorerEasyListview* Sender, TExplorerItemClass &ExplorerClass);

typedef void __fastcall (__closure *TELVGetStorageEvent)(TCustomVirtualExplorerEasyListview* Sender, Virtualexplorertree::TRootNodeStorage* &Storage);

typedef void __fastcall (__closure *TELVInvalidRootNamespaceEvent)(TCustomVirtualExplorerEasyListview* Sender);

typedef void __fastcall (__closure *TELVContextMenu2MessageEvent)(TCustomVirtualExplorerEasyListview* Sender, Winapi::Messages::TMessage &Msg);

typedef void __fastcall (__closure *TELVOnContextMenuAfterCmd)(TCustomVirtualExplorerEasyListview* Sender, Mpshellutilities::TNamespace* Namespace, System::WideString Verb, int MenuItemID, bool Successful);

typedef void __fastcall (__closure *TELVOnContextMenuCmd)(TCustomVirtualExplorerEasyListview* Sender, Mpshellutilities::TNamespace* Namespace, System::WideString Verb, int MenuItemID, bool &Handled);

typedef void __fastcall (__closure *TELVOnContextMenuShow)(TCustomVirtualExplorerEasyListview* Sender, Mpshellutilities::TNamespace* Namespace, HMENU Menu, bool &Allow);

typedef void __fastcall (__closure *TVELCustomColumnAddEvent)(TCustomVirtualExplorerEasyListview* Sender, TELVAddColumnProc AddColumnProc);

typedef void __fastcall (__closure *TELVCustomColumnCompareEvent)(TCustomVirtualExplorerEasyListview* Sender, TExplorerColumn* Column, Easylistview::TEasyGroup* Group, TExplorerItem* Item1, TExplorerItem* Item2, int &CompareResult);

typedef void __fastcall (__closure *TELVCustomColumnGetCaptionEvent)(TCustomVirtualExplorerEasyListview* Sender, TExplorerColumn* Column, TExplorerItem* Item, System::WideString &ACaption);

typedef void __fastcall (__closure *TELVContextMenuItemChange)(TCustomVirtualExplorerEasyListview* Sender, Mpshellutilities::TNamespace* Namespace, int MenuItemID, HMENU SubMenuID, bool MouseSelect);

typedef void __fastcall (__closure *TELVOnRootChange)(TCustomVirtualExplorerEasyListview* Sender);

typedef void __fastcall (__closure *TELVOnRootChanging)(TCustomVirtualExplorerEasyListview* Sender, const Virtualexplorertree::TRootFolder NewValue, Mpshellutilities::TNamespace* const CurrentNamespace, Mpshellutilities::TNamespace* const Namespace, bool &Allow);

typedef void __fastcall (__closure *TELVOnRootRebuild)(TCustomVirtualExplorerEasyListview* Sender);

typedef void __fastcall (__closure *TELVOnShellExecute)(TCustomVirtualExplorerEasyListview* Sender, Mpshellutilities::TNamespace* Namespace, System::WideString &WorkingDir, System::WideString &CmdLineArgument, bool &Allow);

typedef void __fastcall (__closure *TELVOnShellNotifyEvent)(TCustomVirtualExplorerEasyListview* Sender, Virtualshellnotifier::TVirtualShellEvent* ShellEvent);

typedef void __fastcall (__closure *TEasyCustomGroupEvent)(TCustomVirtualExplorerEasyListview* Sender, Easylistview::TEasyGroups* Groups, Mpshellutilities::TNamespace* NS, TExplorerGroup* &Group);

typedef void __fastcall (__closure *TELVLoadStorageFromRoot)(TCustomVirtualExplorerEasyListview* Sender, Virtualexplorertree::TNodeStorage* NodeStorage);

typedef void __fastcall (__closure *TELVSaveRootToStorage)(TCustomVirtualExplorerEasyListview* Sender, Virtualexplorertree::TNodeStorage* NodeStorage);

typedef void __fastcall (__closure *TELVEnumFinishedEvent)(TCustomVirtualExplorerEasyListview* Sender);

typedef void __fastcall (__closure *TELVEnumLenghyOperaionEvent)(TCustomVirtualExplorerEasyListview* Sender, bool &ShowAnimation);

typedef void __fastcall (__closure *TELVThumbThreadCreateCallbackEvent)(TCustomVirtualExplorerEasyListview* Sender, TEasyThumbnailThreadRequest* &ThumbRequestClass);

typedef void __fastcall (__closure *TELVQuickFilterCustomCompareEvent)(TCustomVirtualExplorerEasyListview* Sender, TExplorerItem* Item, System::WideString Mask, bool &IsVisible);

typedef void __fastcall (__closure *TELVQuickFilterStartEvent)(TCustomVirtualExplorerEasyListview* Sender, System::WideString Mask);

typedef void __fastcall (__closure *TELVRebuildingShellHeaderEvent)(TCustomVirtualExplorerEasyListview* Sender, bool &Allow);

typedef void __fastcall (__closure *TELVRebuiltShellHeaderEvent)(TCustomVirtualExplorerEasyListview* Sender);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TCategory : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	GUID FCategory;
	TEasyCategoryType FCategoryType;
	int FColumn;
	Mpshelltypes::tagSHCOLUMNID FColumnID;
	bool FEnumerated;
	bool FIsDefault;
	System::WideString FName;
	
public:
	__property GUID Category = {read=FCategory};
	__property TEasyCategoryType CategoryType = {read=FCategoryType, nodefault};
	__property int Column = {read=FColumn, nodefault};
	__property Mpshelltypes::tagSHCOLUMNID ColumnID = {read=FColumnID};
	__property bool Enumerated = {read=FEnumerated, write=FEnumerated, nodefault};
	__property bool IsDefault = {read=FIsDefault, nodefault};
	__property System::WideString Name = {read=FName};
public:
	/* TObject.Create */ inline __fastcall TCategory(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TCategory(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TCategories : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TCategory* operator[](int Index) { return this->Categories[Index]; }
	
private:
	System::Classes::TList* FCategoryList;
	TCategory* __fastcall GetCategories(int Index);
	int __fastcall GetCount(void);
	
protected:
	void __fastcall Delete(int Index);
	
public:
	__fastcall TCategories(void);
	__fastcall virtual ~TCategories(void);
	TCategory* __fastcall Add(void);
	void __fastcall Clear(void);
	__property TCategory* Categories[int Index] = {read=GetCategories/*, default*/};
	__property int Count = {read=GetCount, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TVirtualCustomFileTypes : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Uitypes::TColor FColor;
	Vcl::Graphics::TFont* FFont;
	bool FHilight;
	void __fastcall SetHilight(const bool Value);
	
public:
	__fastcall TVirtualCustomFileTypes(System::Uitypes::TColor AColor);
	__fastcall virtual ~TVirtualCustomFileTypes(void);
	
__published:
	__property System::Uitypes::TColor Color = {read=FColor, write=FColor, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=FFont};
	__property bool Hilight = {read=FHilight, write=SetHilight, default=0};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TVirtualEasyListviewDataObject : public Easylistview::TEasyDataObjectManager
{
	typedef Easylistview::TEasyDataObjectManager inherited;
	
private:
	_di_IDataObject FShellDataObject;
	
protected:
	virtual HRESULT __stdcall DAdvise(const tagFORMATETC &formatetc, int advf, const _di_IAdviseSink advSink, /* out */ int &dwConnection);
	virtual HRESULT __stdcall DUnadvise(int dwConnection);
	virtual HRESULT __stdcall EnumDAdvise(/* out */ _di_IEnumSTATDATA &enumAdvise);
	virtual HRESULT __stdcall EnumFormatEtc(int dwDirection, /* out */ _di_IEnumFORMATETC &enumFormatEtc);
	virtual HRESULT __stdcall GetCanonicalFormatEtc(const tagFORMATETC &formatetc, /* out */ tagFORMATETC &formatetcOut);
	virtual HRESULT __stdcall GetData(const tagFORMATETC &FormatEtcIn, /* out */ tagSTGMEDIUM &Medium);
	virtual HRESULT __stdcall GetDataHere(const tagFORMATETC &formatetc, /* out */ tagSTGMEDIUM &medium);
	virtual HRESULT __stdcall QueryGetData(const tagFORMATETC &formatetc);
	virtual HRESULT __stdcall SetData(const tagFORMATETC &formatetc, tagSTGMEDIUM &medium, System::LongBool fRelease);
	virtual void __fastcall DoGetCustomFormats(int dwDirection, Mpdataobject::TFormatEtcArray &Formats);
	__property _di_IDataObject ShellDataObject = {read=FShellDataObject, write=FShellDataObject};
	
public:
	__fastcall TVirtualEasyListviewDataObject(void);
	__fastcall virtual ~TVirtualEasyListviewDataObject(void);
private:
	void *__IDataObject;	// IDataObject 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {0000010E-0000-0000-C000-000000000046}
	operator _di_IDataObject()
	{
		_di_IDataObject intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator IDataObject*(void) { return (IDataObject*)&__IDataObject; }
	#endif
	
};


class PASCALIMPLEMENTATION TEasyExplorerMemoEditor : public Easylistview::TEasyMemoEditor
{
	typedef Easylistview::TEasyMemoEditor inherited;
	
private:
	bool FFullSelToggleState;
	
protected:
	virtual void __fastcall DoEditKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift, bool &DoDefault);
	void __fastcall SelectFileName(bool FileNameOnly);
	__property bool FullSelToggleState = {read=FFullSelToggleState, write=FFullSelToggleState, nodefault};
	
public:
	virtual bool __fastcall SetEditorFocus(void);
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TEasyExplorerMemoEditor(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TEasyExplorerMemoEditor(void) : Easylistview::TEasyMemoEditor() { }
	
};


class PASCALIMPLEMENTATION TEasyExplorerStringEditor : public Easylistview::TEasyStringEditor
{
	typedef Easylistview::TEasyStringEditor inherited;
	
private:
	bool FFullSelToggleState;
	
protected:
	virtual void __fastcall DoEditKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift, bool &DoDefault);
	void __fastcall SelectFileName(bool FileNameOnly);
	__property bool FullSelToggleState = {read=FFullSelToggleState, write=FFullSelToggleState, nodefault};
	
public:
	virtual bool __fastcall SetEditorFocus(void);
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TEasyExplorerStringEditor(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TEasyExplorerStringEditor(void) : Easylistview::TEasyStringEditor() { }
	
};


class PASCALIMPLEMENTATION TCustomVirtualExplorerEasyListview : public Easylistview::TCustomEasyListview
{
	typedef Easylistview::TCustomEasyListview inherited;
	
private:
	bool FActivated;
	bool FActive;
	Vcl::Comctrls::TAnimate* FAnimateFolderEnum;
	Mpshellutilities::TNamespace* FBackBrowseRoot;
	Virtualexplorertree::TVirtualShellBackgroundContextMenu* FBackGndMenu;
	TCategories* FCategoryInfo;
	int FChangeNotifierCount;
	bool FChangeNotifierEnabled;
	HWND FClipChainWnd;
	Vcl::Menus::TPopupMenu* FColumnHeaderMenu;
	int FColumnMenuItemCount;
	TVirtualCustomFileTypes* FCompressedFile;
	Easylistview::TEasyItem* FContextMenuItem;
	bool FContextMenuShown;
	int FDefaultSortColumn;
	Easylistview::TEasySortDirection FDefaultSortDir;
	Mpthreadmanager::TCommonEventThread* FDetailsOfThread;
	bool FExtensionColorCode;
	bool FExtensionColorCodeSelected;
	TVirtualFileSizeFormat FFileSizeFormat;
	_ITEMIDLIST *FOldTopNode;
	Easylistview::TAfterPaintEvent FOnAfterPaint;
	System::Classes::TNotifyEvent FOnGroupingChange;
	TELVQuickFilterCustomCompareEvent FOnQuickFilterCustomCompare;
	System::Classes::TNotifyEvent FOnQuickFilterEnd;
	TELVQuickFilterStartEvent FOnQuickFilterStart;
	TELVRebuildingShellHeaderEvent FOnRebuildingShellHeader;
	TELVRebuiltShellHeaderEvent FOnRebuiltShellHeader;
	TELVThumbThreadCreateCallbackEvent FOnThumbRequestCreate;
	System::Classes::TList* FOrphanThreadList;
	_di_IDataObject FDragDataObject;
	TELVPersistent* FELVPersistent;
	TVirtualCustomFileTypes* FEncryptedFile;
	Mpcommonobjects::TCommonPIDLList* FEnumBkGndList;
	unsigned FEnumBkGndTime;
	_RTL_CRITICAL_SECTION FEnumLock;
	Virtualexplorertree::TVirtualBackGndEnumThread* FEnumThread;
	NativeUInt FEnumTimer;
	Virtualexplorertree::TVirtualExplorerCombobox* FExplorerCombobox;
	Virtualexplorertree::TCustomVirtualExplorerTree* FExplorerTreeview;
	Mpshellutilities::TFileObjects FFileObjects;
	bool FGrouped;
	int FGroupingColumn;
	TGroupingFileSizeArray FGroupingFileSizeArray;
	TGroupingModifiedArray FGroupingModifiedArray;
	bool FIENamespaceShown;
	Mpshellutilities::TNamespace* FLastDropTargetNS;
	_RTL_CRITICAL_SECTION FLock;
	_di_IMalloc FMalloc;
	TELVOnBeforeItemThumbnailDraw FOnBeforeItemThumbnailDraw;
	TVELCustomColumnAddEvent FOnCustomColumnAdd;
	System::Classes::TNotifyEvent FOnClipboardChange;
	TELVContextMenu2MessageEvent FOnContextMenu2Message;
	TELVOnContextMenuAfterCmd FOnContextMenuAfterCmd;
	TELVOnContextMenuCmd FOnContextMenuCmd;
	TELVContextMenuItemChange FOnContextMenuItemChange;
	TELVOnContextMenuShow FOnContextMenuShow;
	TELVCustomColumnCompareEvent FOnCustomColumnCompare;
	TELVCustomColumnGetCaptionEvent FOnCustomColumnGetCaption;
	TEasyCustomGroupEvent FOnCustomGroup;
	TELVEnumFinishedEvent FOnEnumFinished;
	TELVOnEnumFolder FOnEnumFolder;
	TELVEnumLenghyOperaionEvent FOnEnumThreadLengthyOperation;
	TELVExplorerGroupClassEvent FOnExplorerGroupClass;
	TELVExplorerItemClassEvent FOnExplorerItemClass;
	TExtensionColorCodeList* FExtensionColorCodeList;
	TELVGetStorageEvent FOnGetStorage;
	TELVInvalidRootNamespaceEvent FOnInvalidRootNamespace;
	TELVLoadStorageFromRoot FOnLoadStorageFromRoot;
	TELVOnRootChange FOnRootChange;
	TELVOnRootChanging FOnRootChanging;
	TELVOnRootRebuild FOnRootRebuild;
	TELVSaveRootToStorage FOnSaveRootToStorage;
	TELVOnShellExecute FOnShellExecute;
	TELVOnShellNotifyEvent FOnShellNotify;
	TVirtualEasyListviewOptions FOptions;
	Virtualexplorertree::TNodeStorage* FPrevFolderSettings;
	int FQueryInfoHintTimeout;
	bool FQuickFiltered;
	System::WideString FQuickFilterMask;
	bool FQuickFilterUpdatedNeeded;
	bool FRebuildingRootNamespace;
	Virtualexplorertree::TRootFolder FRootFolder;
	System::WideString FRootFolderCustomPath;
	_ITEMIDLIST *FRootFolderCustomPIDL;
	Mpshellutilities::TNamespace* FRootFolderNamespace;
	System::Classes::TStrings* FSelectedFiles;
	System::Classes::TStrings* FSelectedPaths;
	bool FShellNotifySuspended;
	bool FSortFolderFirstAlways;
	Virtualexplorertree::TRootNodeStorage* FStorage;
	Mpshellutilities::TNamespace* FTempRootNamespace;
	TEasyThumbsManager* FThumbsManager;
	bool FUseShellGrouping;
	Virtualexplorertree::TVETStates FVETStates;
	TELVOnShellNotifyEvent FOnAfterShellNotify;
	bool __fastcall GetAutoSort(void);
	Mpshellutilities::TNamespace* __fastcall GetDropTargetNS(void);
	Virtualexplorertree::TVirtualBackGndEnumThread* __fastcall GetEnumThread(void);
	TExtensionColorCodeList* __fastcall GetExtensionColorCodeList(void);
	int __fastcall GetGroupingColumn(void);
	int __fastcall GetItemCount(void);
	HIDESBASE Easylistview::TEasyPaintInfoColumn* __fastcall GetPaintInfoColumn(void);
	HIDESBASE Easylistview::TEasyPaintInfoGroup* __fastcall GetPaintInfoGroup(void);
	HIDESBASE Easylistview::TEasyPaintInfoItem* __fastcall GetPaintInfoItem(void);
	System::WideString __fastcall GetSelectedFile(void);
	System::Classes::TStrings* __fastcall GetSelectedFiles(void);
	System::Classes::TStrings* __fastcall GetSelectedPaths(void);
	System::WideString __fastcall GetSelectedPath(void);
	TEasyVirtualSelectionManager* __fastcall GetSelection(void);
	Virtualexplorertree::TRootNodeStorage* __fastcall GetStorage(void);
	bool __fastcall GetThreadedDetailsEnabled(void);
	bool __fastcall GetThreadedIconsEnabled(void);
	bool __fastcall GetThreadedThumbnailsEnabled(void);
	bool __fastcall GetThreadedTilesEnabled(void);
	void __fastcall SetAutoSort(const bool Value);
	void __fastcall SetChangeNotifierEnabled(bool Value);
	void __fastcall SetDefaultSortColumn(const int Value);
	void __fastcall SetDefaultSortDir(const Easylistview::TEasySortDirection Value);
	void __fastcall SetEnumThread(Virtualexplorertree::TVirtualBackGndEnumThread* const Value);
	void __fastcall SetExplorerCombobox(Virtualexplorertree::TVirtualExplorerCombobox* Value);
	void __fastcall SetExplorerTreeview(Virtualexplorertree::TCustomVirtualExplorerTree* Value);
	void __fastcall SetExtensionColorCode(const bool Value);
	void __fastcall SetFileObjects(Mpshellutilities::TFileObjects Value);
	void __fastcall SetFileSizeFormat(const TVirtualFileSizeFormat Value);
	void __fastcall SetGrouped(bool Value);
	void __fastcall SetGroupingColumn(int Value);
	HIDESBASE void __fastcall SetPaintInfoColumn(Easylistview::TEasyPaintInfoColumn* const Value);
	HIDESBASE void __fastcall SetPaintInfoGroup(Easylistview::TEasyPaintInfoGroup* const Value);
	HIDESBASE void __fastcall SetPaintInfoItem(Easylistview::TEasyPaintInfoItem* const Value);
	void __fastcall SetQuickFiltered(const bool Value);
	void __fastcall SetQuickFilterMask(const System::WideString Value);
	HIDESBASE void __fastcall SetSelection(TEasyVirtualSelectionManager* Value);
	void __fastcall SetSortFolderFirstAlways(const bool Value);
	void __fastcall SetStorage(Virtualexplorertree::TRootNodeStorage* const Value);
	
protected:
	TExplorerColumn* __fastcall AddColumnProc(void);
	System::WideString __fastcall CreateNewFolderInternal(Winapi::Shlobj::PItemIDList TargetPIDL, System::WideString SuggestedFolderName);
	DYNAMIC Vcl::Controls::THintWindowClass __fastcall CustomEasyHintWindowClass(void);
	virtual HRESULT __fastcall ExecuteDragDrop(Mpcommonutilities::TCommonDropEffects AvailableEffects, _di_IDataObject DataObjectInf, _di_IDropSource DropSource, int &dwEffect);
	TExplorerGroup* __fastcall FindGroup(Mpshellutilities::TNamespace* NS);
	virtual Vcl::Controls::TWinControl* __fastcall GetAnimateWndParent(void);
	virtual bool __fastcall GetHeaderVisibility(void);
	bool __fastcall GetOkToShellNotifyDispatch(void);
	virtual bool __fastcall LoadStorageToRoot(Virtualexplorertree::TNodeStorage* StorageNode);
	virtual bool __fastcall UseInternalDragImage(_di_IDataObject DataObject);
	void __fastcall ActivateTree(bool Activate);
	void __fastcall AddDetailsOfRequest(TEasyDetailStringsThreadRequest* Request);
	void __fastcall CheckForDefaultGroupVisibility(void);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMParentFontChanged(Winapi::Messages::TMessage &Msg);
	void __fastcall ColumnHeaderMenuItemClick(System::TObject* Sender);
	void __fastcall ColumnSettingCallback(System::TObject* Sender);
	void __fastcall ContextMenuCmdCallback(Mpshellutilities::TNamespace* Namespace, System::WideString Verb, int MenuItemID, bool &Handled);
	void __fastcall ContextMenuShowCallback(Mpshellutilities::TNamespace* Namespace, HMENU Menu, bool &Allow);
	void __fastcall ContextMenuAfterCmdCallback(Mpshellutilities::TNamespace* Namespace, System::WideString Verb, int MenuItemID, bool Successful);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DestroyWnd(void);
	virtual void __fastcall DoAfterPaint(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ClipRect);
	virtual void __fastcall DoAfterShellNotify(Virtualshellnotifier::TVirtualShellEvent* ShellEvent);
	virtual void __fastcall DoColumnClick(Mpcommonutilities::TCommonMouseButton Button, System::Classes::TShiftState ShiftState, Easylistview::TEasyColumn* const Column);
	virtual void __fastcall DoColumnContextMenu(const Easylistview::TEasyHitInfoColumn &HitInfo, const System::Types::TPoint &WindowPoint, Vcl::Menus::TPopupMenu* &Menu);
	virtual void __fastcall DoContextMenu(const System::Types::TPoint &MousePt, bool &Handled);
	virtual void __fastcall DoContextMenu2Message(Winapi::Messages::TMessage &Msg);
	void __fastcall DoContextMenuAfterCmd(Mpshellutilities::TNamespace* Namespace, System::WideString Verb, int MenuItemID, bool Successful);
	bool __fastcall DoContextMenuCmd(Mpshellutilities::TNamespace* Namespace, System::WideString Verb, int MenuItemID);
	void __fastcall DoContextMenuSelect(Mpshellutilities::TNamespace* Namespace, int MenuItemID, HMENU SubMenuID, bool MouseSelect);
	bool __fastcall DoContextMenuShow(Mpshellutilities::TNamespace* Namespace, HMENU Menu);
	virtual void __fastcall DoCustomColumnAdd(void);
	virtual void __fastcall DoCustomColumnCompare(TExplorerColumn* Column, Easylistview::TEasyGroup* Group, TExplorerItem* Item1, TExplorerItem* Item2, int &CompareResult);
	virtual void __fastcall DoCustomColumnGetCaption(TExplorerColumn* Column, TExplorerItem* Item, System::WideString &Caption);
	virtual void __fastcall DoCustomGroup(Easylistview::TEasyGroups* Groups, Mpshellutilities::TNamespace* NS, TExplorerGroup* &Group);
	virtual void __fastcall DoEnumFinished(void);
	virtual void __fastcall DoEnumFolder(Mpshellutilities::TNamespace* const Namespace, bool &AllowAsChild);
	virtual int __fastcall DoGroupCompare(Easylistview::TEasyColumn* Column, Easylistview::TEasyGroup* Group1, Easylistview::TEasyGroup* Group2);
	virtual int __fastcall DoItemCompare(Easylistview::TEasyColumn* Column, Easylistview::TEasyGroup* Group, Easylistview::TEasyItem* Item1, Easylistview::TEasyItem* Item2);
	void __fastcall DoEnumThreadLengthyOperation(bool &ShowAnimation);
	void __fastcall DoExplorerGroupClass(TExplorerGroupClass &GroupClass);
	virtual void __fastcall DoExplorerItemClass(TExplorerItemClass &ItemClass);
	DYNAMIC void __fastcall DoGetHintTimeOut(int &HintTimeOut);
	virtual void __fastcall DoGetStorage(Virtualexplorertree::TRootNodeStorage* &Storage);
	virtual void __fastcall DoGroupingChange(void);
	virtual void __fastcall DoHintPopup(Easylistview::TEasyCollectionItem* TargetObj, Easylistview::TEasyHintType HintType, const System::Types::TPoint &MousePos, System::WideString &AText, int &HideTimeout, int &ReshowTimeout, bool &Allow);
	void __fastcall DoInvalidRootNamespace(void);
	virtual void __fastcall DoItemContextMenu(const Easylistview::TEasyHitInfoItem &HitInfo, const System::Types::TPoint &WindowPoint, Vcl::Menus::TPopupMenu* &Menu, bool &Handled);
	virtual void __fastcall DoItemCreateEditor(Easylistview::TEasyItem* Item, Easylistview::_di_IEasyCellEditor &Editor);
	virtual void __fastcall DoItemCustomView(Easylistview::TEasyItem* Item, Easylistview::TEasyListStyle ViewStyle, Easylistview::TEasyViewItemClass &View);
	virtual void __fastcall DoItemDblClick(Mpcommonutilities::TCommonMouseButton Button, const System::Types::TPoint &MousePos, const Easylistview::TEasyHitInfoItem &HitInfo);
	virtual void __fastcall DoItemGetCaption(Easylistview::TEasyItem* Item, int Column, System::WideString &ACaption);
	virtual void __fastcall DoItemGetEditCaption(Easylistview::TEasyItem* Item, Easylistview::TEasyColumn* Column, System::WideString &Caption);
	virtual void __fastcall DoItemGetImageIndex(Easylistview::TEasyItem* Item, int Column, Easylistview::TEasyImageKind ImageKind, Mpcommonobjects::TCommonImageIndexInteger &ImageIndex);
	virtual void __fastcall DoItemGetTileDetail(Easylistview::TEasyItem* Item, int Line, int &Detail);
	virtual void __fastcall DoItemGetTileDetailCount(Easylistview::TEasyItem* Item, int &Count);
	virtual void __fastcall DoItemPaintText(Easylistview::TEasyItem* Item, int Position, Vcl::Graphics::TCanvas* ACanvas);
	virtual void __fastcall DoItemSetCaption(Easylistview::TEasyItem* Item, int Column, const System::WideString Caption);
	virtual void __fastcall DoItemThumbnailDraw(Easylistview::TEasyItem* Item, Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, Easylistview::TEasyAlphaBlender* AlphaBlender, bool &DoDefault);
	virtual void __fastcall DoKeyAction(System::Word &CharCode, System::Classes::TShiftState &Shift, bool &DoDefault);
	virtual void __fastcall DoLoadStorageToRoot(Virtualexplorertree::TNodeStorage* StorageNode);
	virtual void __fastcall DoNamespaceStructureChange(TExplorerItem* Item, Virtualexplorertree::TNamespaceStructureChange ChangeType);
	virtual void __fastcall DoOLEDragStart(_di_IDataObject ADataObject, Mpcommonutilities::TCommonDropEffects &AvailableEffects, bool &AllowDrag);
	virtual void __fastcall DoOLEDropTargetDragDrop(_di_IDataObject DataObject, Mpcommonutilities::TCommonKeyStates KeyState, const System::Types::TPoint &WindowPt, Mpcommonutilities::TCommonDropEffects AvailableEffects, Mpcommonutilities::TCommonDropEffect &DesiredEffect, bool &Handled);
	virtual void __fastcall DoOLEDropTargetDragEnter(_di_IDataObject DataObject, Mpcommonutilities::TCommonKeyStates KeyState, const System::Types::TPoint &WindowPt, Mpcommonutilities::TCommonDropEffects AvailableEffects, Mpcommonutilities::TCommonDropEffect &DesiredEffect);
	virtual void __fastcall DoOLEDropTargetDragLeave(void);
	virtual void __fastcall DoOLEDropTargetDragOver(Mpcommonutilities::TCommonKeyStates KeyState, const System::Types::TPoint &WindowPt, Mpcommonutilities::TCommonDropEffects AvailableEffects, Mpcommonutilities::TCommonDropEffect &DesiredEffect);
	virtual void __fastcall DoOLEGetDataObject(_di_IDataObject &DataObject);
	virtual void __fastcall DoQuickFilterCustomCompare(TExplorerItem* Item, System::WideString Mask, bool &IsVisible);
	virtual void __fastcall DoQuickFilterEnd(void);
	virtual void __fastcall DoQuickFilterStart(System::WideString Mask);
	virtual void __fastcall DoRebuildingShellHeader(bool &Allow);
	virtual void __fastcall DoRebuiltShellHeader(void);
	virtual void __fastcall DoRootChange(void);
	virtual void __fastcall DoRootChanging(const Virtualexplorertree::TRootFolder NewRoot, Mpshellutilities::TNamespace* Namespace, bool &Allow);
	virtual void __fastcall DoRootRebuild(void);
	virtual void __fastcall DoSaveRootToStorage(Virtualexplorertree::TNodeStorage* StorageNode);
	virtual void __fastcall DoScrollEnd(Easylistview::TEasyScrollbarDir ScrollBar);
	virtual void __fastcall DoShellExecute(Easylistview::TEasyItem* Item);
	virtual void __fastcall DoShellNotify(Virtualshellnotifier::TVirtualShellEvent* ShellEvent);
	virtual void __fastcall DoThreadCallback(Mpthreadmanager::TWMThreadRequest &Msg);
	virtual bool __fastcall EnumFolderCallback(HWND ParentWnd, Winapi::Shlobj::PItemIDList APIDL, Mpshellutilities::TNamespace* AParent, void * Data, bool &Terminate);
	virtual void __fastcall DoThumbThreadCreate(TEasyThumbnailThreadRequest* &ThumbRequest);
	void __fastcall Enqueue(Mpshellutilities::TNamespace* NS, Easylistview::TEasyItem* Item, const System::Types::TPoint &ThumbSize, bool UseShellExtraction, bool IsResizing);
	void __fastcall EnumThreadFinished(bool DoSort);
	void __fastcall EnumThreadStart(void);
	void __fastcall EnumThreadTimer(bool Enable);
	void __fastcall FlushDetailsOfThread(void);
	void __fastcall ForceIconCachRebuild(void);
	void __fastcall HideAnimateFolderWnd(void);
	void __fastcall InvalidateImageByIndex(int ImageIndex);
	bool __fastcall ItemBelongsToList(TExplorerItem* Item);
	void __fastcall LockChangeNotifier(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual bool __fastcall OkToBrowseTo(Winapi::Shlobj::PItemIDList PIDL);
	void __fastcall Notify(Winapi::Messages::TMessage &Msg);
	void __fastcall OrphanThreadsFree(void);
	void __fastcall PackTileStrings(Mpshellutilities::TNamespace* NS);
	void __fastcall ReadItems(Easylistview::TEasyItemArray &AnItemArray, bool Sorted, int &ValidItemsRead);
	void __fastcall RebuildCategories(void);
	void __fastcall RebuildRootNamespace(void);
	void __fastcall SaveRebuildRestoreRootNamespace(void);
	virtual void __fastcall SaveRootToStorage(Virtualexplorertree::TNodeStorage* StorageNode);
	virtual void __fastcall SetActive(bool Value);
	virtual void __fastcall SetOptions(TVirtualEasyListviewOptions Value);
	virtual void __fastcall SetRootFolder(Virtualexplorertree::TRootFolder Value);
	virtual void __fastcall SetRootFolderCustomPath(System::WideString Value);
	virtual void __fastcall SetRootFolderCustomPIDL(Winapi::Shlobj::PItemIDList Value);
	virtual void __fastcall SetView(Easylistview::TEasyListStyle Value);
	void __fastcall ShowAnimateFolderWnd(void);
	void __fastcall TerminateDetailsOfThread(void);
	void __fastcall TerminateEnumThread(void);
	void __fastcall TestVisiblilityForSingleColumn(void);
	void __fastcall UpdateColumnsFromDialog(Virtualtrees::TVirtualStringTree* VST);
	void __fastcall UpdateDefaultSortColumnAndSortDir(void);
	MESSAGE void __fastcall WMChangeCBChain(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMContextmenu(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMCreate(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMDetailsOfThread(Mpthreadmanager::TWMThreadRequest &Msg);
	MESSAGE void __fastcall WMDrawClipboard(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMDrawItem(Winapi::Messages::TWMDrawItem &Msg);
	MESSAGE void __fastcall WMInitMenuPopup(Winapi::Messages::TWMInitMenuPopup &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMMeasureItem(Winapi::Messages::TWMMeasureItem &Msg);
	MESSAGE void __fastcall WMMenuSelect(Winapi::Messages::TWMMenuSelect &Msg);
	HIDESBASE MESSAGE void __fastcall WMNCDestroy(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMShellNotify(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMSysChar(Winapi::Messages::TWMKey &Msg);
	MESSAGE void __fastcall WMTimer(Winapi::Messages::TWMTimer &Msg);
	__property bool Activated = {read=FActivated, write=FActivated, nodefault};
	__property bool Active = {read=FActive, write=SetActive, default=0};
	__property bool AutoSort = {read=GetAutoSort, write=SetAutoSort, default=1};
	__property Mpshellutilities::TNamespace* BackBrowseRoot = {read=FBackBrowseRoot, write=FBackBrowseRoot};
	__property Virtualexplorertree::TVirtualShellBackgroundContextMenu* BackGndMenu = {read=FBackGndMenu, write=FBackGndMenu};
	__property TCategories* CategoryInfo = {read=FCategoryInfo};
	__property int ChangeNotifierCount = {read=FChangeNotifierCount, write=FChangeNotifierCount, nodefault};
	__property bool ChangeNotifierEnabled = {read=FChangeNotifierEnabled, write=SetChangeNotifierEnabled, nodefault};
	__property HWND ClipChainWnd = {read=FClipChainWnd, write=FClipChainWnd, nodefault};
	__property Vcl::Menus::TPopupMenu* ColumnHeaderMenu = {read=FColumnHeaderMenu, write=FColumnHeaderMenu};
	__property int ColumnMenuItemCount = {read=FColumnMenuItemCount, write=FColumnMenuItemCount, default=5};
	__property TVirtualCustomFileTypes* CompressedFile = {read=FCompressedFile, write=FCompressedFile};
	__property int DefaultSortColumn = {read=FDefaultSortColumn, write=SetDefaultSortColumn, default=-1};
	__property Easylistview::TEasySortDirection DefaultSortDir = {read=FDefaultSortDir, write=SetDefaultSortDir, default=0};
	__property Mpthreadmanager::TCommonEventThread* DetailsOfThread = {read=FDetailsOfThread, write=FDetailsOfThread};
	__property Virtualexplorertree::TVirtualBackGndEnumThread* EnumThread = {read=GetEnumThread, write=SetEnumThread};
	__property bool ExtensionColorCode = {read=FExtensionColorCode, write=SetExtensionColorCode, default=0};
	__property bool ExtensionColorCodeSelected = {read=FExtensionColorCodeSelected, write=FExtensionColorCodeSelected, default=1};
	__property TVirtualFileSizeFormat FileSizeFormat = {read=FFileSizeFormat, write=SetFileSizeFormat, nodefault};
	__property Winapi::Shlobj::PItemIDList OldTopNode = {read=FOldTopNode, write=FOldTopNode};
	__property System::Classes::TList* OrphanThreadList = {read=FOrphanThreadList, write=FOrphanThreadList};
	__property _di_IDataObject DragDataObject = {read=FDragDataObject, write=FDragDataObject};
	__property Mpshellutilities::TNamespace* DropTargetNS = {read=GetDropTargetNS};
	__property TVirtualCustomFileTypes* EncryptedFile = {read=FEncryptedFile, write=FEncryptedFile};
	__property Mpcommonobjects::TCommonPIDLList* EnumBkGndList = {read=FEnumBkGndList, write=FEnumBkGndList};
	__property unsigned EnumBkGndTime = {read=FEnumBkGndTime, write=FEnumBkGndTime, nodefault};
	__property _RTL_CRITICAL_SECTION EnumLock = {read=FEnumLock, write=FEnumLock};
	__property NativeUInt EnumTimer = {read=FEnumTimer, write=FEnumTimer, nodefault};
	__property Virtualexplorertree::TVirtualExplorerCombobox* ExplorerCombobox = {read=FExplorerCombobox, write=SetExplorerCombobox};
	__property Virtualexplorertree::TCustomVirtualExplorerTree* ExplorerTreeview = {read=FExplorerTreeview, write=SetExplorerTreeview};
	__property TExtensionColorCodeList* ExtensionColorCodeList = {read=GetExtensionColorCodeList};
	__property Mpshellutilities::TFileObjects FileObjects = {read=FFileObjects, write=SetFileObjects, default=3};
	__property bool Grouped = {read=FGrouped, write=SetGrouped, nodefault};
	__property int GroupingColumn = {read=GetGroupingColumn, write=SetGroupingColumn, nodefault};
	__property TGroupingFileSizeArray GroupingFileSizeArray = {read=FGroupingFileSizeArray, write=FGroupingFileSizeArray};
	__property TGroupingModifiedArray GroupingModifiedArray = {read=FGroupingModifiedArray, write=FGroupingModifiedArray};
	__property int ItemCount = {read=GetItemCount, nodefault};
	__property Mpshellutilities::TNamespace* LastDropTargetNS = {read=FLastDropTargetNS, write=FLastDropTargetNS};
	__property _RTL_CRITICAL_SECTION Lock = {read=FLock, write=FLock};
	__property _di_IMalloc Malloc = {read=FMalloc, write=FMalloc};
	__property Easylistview::TAfterPaintEvent OnAfterPaint = {read=FOnAfterPaint, write=FOnAfterPaint};
	__property TELVOnShellNotifyEvent OnAfterShellNotify = {read=FOnAfterShellNotify, write=FOnAfterShellNotify};
	__property TELVOnBeforeItemThumbnailDraw OnBeforeItemThumbnailDraw = {read=FOnBeforeItemThumbnailDraw, write=FOnBeforeItemThumbnailDraw};
	__property TVELCustomColumnAddEvent OnCustomColumnAdd = {read=FOnCustomColumnAdd, write=FOnCustomColumnAdd};
	__property System::Classes::TNotifyEvent OnClipboardChange = {read=FOnClipboardChange, write=FOnClipboardChange};
	__property TELVContextMenu2MessageEvent OnContextMenu2Message = {read=FOnContextMenu2Message, write=FOnContextMenu2Message};
	__property TELVOnContextMenuAfterCmd OnContextMenuAfterCmd = {read=FOnContextMenuAfterCmd, write=FOnContextMenuAfterCmd};
	__property TELVContextMenuItemChange OnContextMenuItemChange = {read=FOnContextMenuItemChange, write=FOnContextMenuItemChange};
	__property TELVOnContextMenuCmd OnContextMenuCmd = {read=FOnContextMenuCmd, write=FOnContextMenuCmd};
	__property TELVOnContextMenuShow OnContextMenuShow = {read=FOnContextMenuShow, write=FOnContextMenuShow};
	__property TELVCustomColumnCompareEvent OnCustomColumnCompare = {read=FOnCustomColumnCompare, write=FOnCustomColumnCompare};
	__property TELVCustomColumnGetCaptionEvent OnCustomColumnGetCaption = {read=FOnCustomColumnGetCaption, write=FOnCustomColumnGetCaption};
	__property TEasyCustomGroupEvent OnCustomGroup = {read=FOnCustomGroup, write=FOnCustomGroup};
	__property TELVEnumFinishedEvent OnEnumFinished = {read=FOnEnumFinished, write=FOnEnumFinished};
	__property TELVOnEnumFolder OnEnumFolder = {read=FOnEnumFolder, write=FOnEnumFolder};
	__property TELVEnumLenghyOperaionEvent OnEnumThreadLengthyOperation = {read=FOnEnumThreadLengthyOperation, write=FOnEnumThreadLengthyOperation};
	__property TELVExplorerGroupClassEvent OnExplorerGroupClass = {read=FOnExplorerGroupClass, write=FOnExplorerGroupClass};
	__property TELVExplorerItemClassEvent OnExplorerItemClass = {read=FOnExplorerItemClass, write=FOnExplorerItemClass};
	__property TELVGetStorageEvent OnGetStorage = {read=FOnGetStorage, write=FOnGetStorage};
	__property System::Classes::TNotifyEvent OnGroupingChange = {read=FOnGroupingChange, write=FOnGroupingChange};
	__property TELVInvalidRootNamespaceEvent OnInvalidRootNamespace = {read=FOnInvalidRootNamespace, write=FOnInvalidRootNamespace};
	__property TELVLoadStorageFromRoot OnLoadStorageFromRoot = {read=FOnLoadStorageFromRoot, write=FOnLoadStorageFromRoot};
	__property TELVQuickFilterCustomCompareEvent OnQuickFilterCustomCompare = {read=FOnQuickFilterCustomCompare, write=FOnQuickFilterCustomCompare};
	__property System::Classes::TNotifyEvent OnQuickFilterEnd = {read=FOnQuickFilterEnd, write=FOnQuickFilterEnd};
	__property TELVQuickFilterStartEvent OnQuickFilterStart = {read=FOnQuickFilterStart, write=FOnQuickFilterStart};
	__property TELVRebuildingShellHeaderEvent OnRebuildingShellHeader = {read=FOnRebuildingShellHeader, write=FOnRebuildingShellHeader};
	__property TELVRebuiltShellHeaderEvent OnRebuiltShellHeader = {read=FOnRebuiltShellHeader, write=FOnRebuiltShellHeader};
	__property TELVOnRootChange OnRootChange = {read=FOnRootChange, write=FOnRootChange};
	__property TELVOnRootChanging OnRootChanging = {read=FOnRootChanging, write=FOnRootChanging};
	__property TELVOnRootRebuild OnRootRebuild = {read=FOnRootRebuild, write=FOnRootRebuild};
	__property TELVSaveRootToStorage OnSaveRootToStorage = {read=FOnSaveRootToStorage, write=FOnSaveRootToStorage};
	__property TELVOnShellExecute OnShellExecute = {read=FOnShellExecute, write=FOnShellExecute};
	__property TELVOnShellNotifyEvent OnShellNotify = {read=FOnShellNotify, write=FOnShellNotify};
	__property TELVThumbThreadCreateCallbackEvent OnThumbRequestCreate = {read=FOnThumbRequestCreate, write=FOnThumbRequestCreate};
	__property TVirtualEasyListviewOptions Options = {read=FOptions, write=SetOptions, default=207};
	__property Easylistview::TEasyPaintInfoColumn* PaintInfoColumn = {read=GetPaintInfoColumn, write=SetPaintInfoColumn};
	__property Easylistview::TEasyPaintInfoGroup* PaintInfoGroup = {read=GetPaintInfoGroup, write=SetPaintInfoGroup};
	__property Easylistview::TEasyPaintInfoItem* PaintInfoItem = {read=GetPaintInfoItem, write=SetPaintInfoItem};
	__property int QueryInfoHintTimeout = {read=FQueryInfoHintTimeout, write=FQueryInfoHintTimeout, default=2500};
	__property bool QuickFilterUpdatedNeeded = {read=FQuickFilterUpdatedNeeded, write=FQuickFilterUpdatedNeeded, nodefault};
	__property bool RebuildingRootNamespace = {read=FRebuildingRootNamespace, write=FRebuildingRootNamespace, nodefault};
	__property Virtualexplorertree::TRootFolder RootFolder = {read=FRootFolder, write=SetRootFolder, default=16};
	__property System::WideString RootFolderCustomPath = {read=FRootFolderCustomPath, write=SetRootFolderCustomPath};
	__property Winapi::Shlobj::PItemIDList RootFolderCustomPIDL = {read=FRootFolderCustomPIDL, write=SetRootFolderCustomPIDL};
	__property Mpshellutilities::TNamespace* RootFolderNamespace = {read=FRootFolderNamespace};
	__property TEasyVirtualSelectionManager* Selection = {read=GetSelection, write=SetSelection};
	__property bool SortFolderFirstAlways = {read=FSortFolderFirstAlways, write=SetSortFolderFirstAlways, default=0};
	__property Mpshellutilities::TNamespace* TempRootNamespace = {read=FTempRootNamespace, write=FTempRootNamespace};
	__property bool ThreadedDetailsEnabled = {read=GetThreadedDetailsEnabled, nodefault};
	__property bool ThreadedIconsEnabled = {read=GetThreadedIconsEnabled, nodefault};
	__property bool ThreadedThumbnailsEnabled = {read=GetThreadedThumbnailsEnabled, nodefault};
	__property bool ThreadedTilesEnabled = {read=GetThreadedTilesEnabled, nodefault};
	__property TEasyThumbsManager* ThumbsManager = {read=FThumbsManager, write=FThumbsManager};
	__property bool UseShellGrouping = {read=FUseShellGrouping, write=FUseShellGrouping, default=1};
	
public:
	__fastcall virtual TCustomVirtualExplorerEasyListview(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCustomVirtualExplorerEasyListview(void);
	virtual TExplorerItem* __fastcall AddCustomItem(Easylistview::TEasyGroup* Group, Mpshellutilities::TNamespace* NS, bool LockoutSort);
	bool __fastcall BrowseTo(System::WideString APath, bool SelectTarget = true);
	virtual bool __fastcall BrowseToByPIDL(Winapi::Shlobj::PItemIDList APIDL, bool SelectTarget = true, bool ShowExplorerMsg = true);
	bool __fastcall BrowseToNextLevel(void);
	bool __fastcall CreateNewFolder(System::WideString TargetPath)/* overload */;
	bool __fastcall CreateNewFolder(System::WideString TargetPath, System::WideString &NewFolder)/* overload */;
	bool __fastcall CreateNewFolder(System::WideString TargetPath, System::WideString SuggestedFolderName, System::WideString &NewFolder)/* overload */;
	int __fastcall FindInsertPosition(int WindowX, int WindowY, Easylistview::TEasyGroup* &Group);
	Easylistview::TEasyItem* __fastcall FindItemByPath(System::WideString Path);
	TExplorerItem* __fastcall FindItemByPIDL(Winapi::Shlobj::PItemIDList PIDL);
	TExplorerGroupClass __fastcall GroupClass(void);
	bool __fastcall IsRootNamespace(Winapi::Shlobj::PItemIDList PIDL);
	bool __fastcall LoadFolderFromPropertyBag(bool IgnoreOptions = false);
	bool __fastcall LoadFolderFromPrevView(void);
	DYNAMIC Easylistview::TEasyItem* __fastcall RereadAndRefresh(bool DoSort);
	void __fastcall RebuildShellHeader(void);
	virtual _di_IDataObject __fastcall SelectedToDataObject(void);
	virtual Mpshellutilities::TNamespaceArray __fastcall SelectedToNamespaceArray(void);
	virtual Mpcommonobjects::TPIDLArray __fastcall SelectedToPIDLArray(void);
	bool __fastcall ValidateNamespace(Easylistview::TEasyItem* Item, Mpshellutilities::TNamespace* &Namespace);
	bool __fastcall ValidateThumbnail(Easylistview::TEasyItem* Item, Virtualthumbnails::TThumbInfo* &ThumbInfo);
	bool __fastcall ValidRootNamespace(void);
	virtual void __fastcall BrowseToPrevLevel(void);
	DYNAMIC void __fastcall ChangeLinkChanging(System::TObject* Server, Winapi::Shlobj::PItemIDList NewPIDL);
	virtual void __fastcall ChangeLinkDispatch(void);
	DYNAMIC void __fastcall ChangeLinkFreeing(Virtualexplorertree::_di_IVETChangeLink ChangeLink);
	void __fastcall Clear(void);
	virtual void __fastcall CopyToClipboard(int AbsolutePIDLs = 0x0);
	virtual void __fastcall CutToClipboard(int AbsolutePIDLs = 0x0);
	void __fastcall LoadAllThumbs(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S);
	void __fastcall LockBrowseLevel(void);
	void __fastcall MarkSelectedCopied(void);
	virtual void __fastcall PasteFromClipboard(void);
	void __fastcall PasteFromClipboardAsShortcut(void);
	void __fastcall QuickFilter(void);
	DYNAMIC void __fastcall Rebuild(bool RestoreTopNode = false);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S);
	virtual void __fastcall SelectedFilesDelete(Mpshellutilities::TExecuteVerbShift ShiftKeyState = (Mpshellutilities::TExecuteVerbShift)(0x0));
	virtual void __fastcall SelectedFilesShowProperties(void);
	void __fastcall SortList(void);
	void __fastcall StoreFolderToPropertyBag(bool Force, bool IgnoreOptions = false);
	__property Vcl::Comctrls::TAnimate* AnimateFolderEnum = {read=FAnimateFolderEnum, write=FAnimateFolderEnum};
	__property Easylistview::TEasyItem* ContextMenuItem = {read=FContextMenuItem};
	__property TELVPersistent* ELVPersistent = {read=FELVPersistent, write=FELVPersistent};
	__property bool ContextMenuShown = {read=FContextMenuShown, nodefault};
	__property bool IENamespaceShown = {read=FIENamespaceShown, nodefault};
	__property OnGenericCallback;
	__property Virtualexplorertree::TNodeStorage* PrevFolderSettings = {read=FPrevFolderSettings, write=FPrevFolderSettings};
	__property bool QuickFiltered = {read=FQuickFiltered, write=SetQuickFiltered, nodefault};
	__property System::WideString QuickFilterMask = {read=FQuickFilterMask, write=SetQuickFilterMask};
	__property System::WideString SelectedFile = {read=GetSelectedFile};
	__property System::Classes::TStrings* SelectedFiles = {read=GetSelectedFiles};
	__property System::Classes::TStrings* SelectedPaths = {read=GetSelectedPaths};
	__property System::WideString SelectedPath = {read=GetSelectedPath};
	__property bool ShellNotifySuspended = {read=FShellNotifySuspended, write=FShellNotifySuspended, nodefault};
	__property Virtualexplorertree::TRootNodeStorage* Storage = {read=GetStorage, write=SetStorage};
	__property Virtualexplorertree::TVETStates VETStates = {read=FVETStates, write=FVETStates, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TCustomVirtualExplorerEasyListview(HWND ParentWindow) : Easylistview::TCustomEasyListview(ParentWindow) { }
	
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


enum DECLSPEC_DENUM TVirtualDropStackAutoRemove : unsigned char { dsarMoveOnly, dsarAlways, dsarRightDragOnly };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TVirtualDropStackItem : public Easylistview::TEasyItemStored
{
	typedef Easylistview::TEasyItemStored inherited;
	
private:
	_di_IDataObject FDataObject;
	
public:
	__fastcall virtual ~TVirtualDropStackItem(void);
	__property _di_IDataObject DataObject = {read=FDataObject, write=FDataObject};
public:
	/* TEasyItemStored.Create */ inline __fastcall virtual TVirtualDropStackItem(Easylistview::TEasyCollection* ACollection) : Easylistview::TEasyItemStored(ACollection) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TCustomVirtualDropStack : public Easylistview::TCustomEasyListview
{
	typedef Easylistview::TCustomEasyListview inherited;
	
private:
	TVirtualDropStackAutoRemove FAutoRemove;
	_di_IDataObject FDataObjectTemp;
	System::Classes::TNotifyEvent FOnDragDrop;
	System::Word FHintItemCount;
	System::Word FStackDepth;
	
protected:
	void __fastcall AddDropStackItems(const _di_IDataObject DataObject);
	virtual void __fastcall DoHintPopup(Easylistview::TEasyCollectionItem* TargetObj, Easylistview::TEasyHintType HintType, const System::Types::TPoint &MousePos, System::WideString &AText, int &HideTimeout, int &ReshowTimeout, bool &Allow);
	virtual void __fastcall DoOLEDragEnd(_di_IDataObject ADataObject, Mpcommonutilities::TCommonOLEDragResult DragResult, Mpcommonutilities::TCommonDropEffects ResultEffect, Mpcommonutilities::TCommonKeyStates KeyStates);
	virtual void __fastcall DoOLEDragStart(_di_IDataObject ADataObject, Mpcommonutilities::TCommonDropEffects &AvailableEffects, bool &AllowDrag);
	virtual void __fastcall DoOLEDropTargetDragDrop(_di_IDataObject DataObject, Mpcommonutilities::TCommonKeyStates KeyState, const System::Types::TPoint &WindowPt, Mpcommonutilities::TCommonDropEffects AvailableEffects, Mpcommonutilities::TCommonDropEffect &DesiredEffect, bool &Handled);
	virtual void __fastcall DoOLEDropTargetDragEnter(_di_IDataObject DataObject, Mpcommonutilities::TCommonKeyStates KeyState, const System::Types::TPoint &WindowPt, Mpcommonutilities::TCommonDropEffects AvailableEffects, Mpcommonutilities::TCommonDropEffect &DesiredEffect);
	virtual void __fastcall DoOLEDropTargetDragLeave(void);
	virtual void __fastcall DoOLEDropTargetDragOver(Mpcommonutilities::TCommonKeyStates KeyState, const System::Types::TPoint &WindowPt, Mpcommonutilities::TCommonDropEffects AvailableEffects, Mpcommonutilities::TCommonDropEffect &DesiredEffect);
	virtual void __fastcall DoOLEGetDataObject(_di_IDataObject &DataObject);
	virtual void __fastcall DoViewChange(void);
	__property TVirtualDropStackAutoRemove AutoRemove = {read=FAutoRemove, write=FAutoRemove, default=0};
	__property _di_IDataObject DataObjectTemp = {read=FDataObjectTemp, write=FDataObjectTemp};
	__property System::Word HintItemCount = {read=FHintItemCount, write=FHintItemCount, default=16};
	__property System::Classes::TNotifyEvent OnDragDrop = {read=FOnDragDrop, write=FOnDragDrop};
	__property System::Word StackDepth = {read=FStackDepth, write=FStackDepth, default=64};
	
public:
	__fastcall virtual TCustomVirtualDropStack(System::Classes::TComponent* AOwner);
public:
	/* TCustomEasyListview.Destroy */ inline __fastcall virtual ~TCustomVirtualDropStack(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TCustomVirtualDropStack(HWND ParentWindow) : Easylistview::TCustomEasyListview(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualExplorerEasyListview : public TCustomVirtualExplorerEasyListview
{
	typedef TCustomVirtualExplorerEasyListview inherited;
	
public:
	__property AllowHiddenCheckedItems = {default=0};
	__property CategoryInfo;
	__property ExtensionColorCodeList;
	__property GlobalImages;
	__property GroupingFileSizeArray;
	__property GroupingModifiedArray;
	__property ItemCount;
	__property Items;
	__property States;
	__property RootFolderCustomPIDL;
	__property RootFolderNamespace;
	__property Scrollbars;
	
__published:
	__property Active = {default=0};
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property AutoSort = {default=1};
	__property BackGndMenu;
	__property BackGround;
	__property BevelKind = {default=0};
	__property BevelInner = {index=0, default=2};
	__property BevelOuter = {index=1, default=1};
	__property BevelWidth = {default=1};
	__property BiDiMode;
	__property BorderStyle = {default=1};
	__property BorderWidth = {default=0};
	__property CellSizes;
	__property Color = {default=-16777211};
	__property ColumnMenuItemCount = {default=5};
	__property CompressedFile;
	__property Constraints;
	__property Ctl3D;
	__property DefaultSortColumn = {default=-1};
	__property DefaultSortDir = {default=0};
	__property EditManager;
	__property EncryptedFile;
	__property ExtensionColorCode = {default=0};
	__property ExtensionColorCodeSelected = {default=1};
	__property DragKind = {default=0};
	__property DragManager;
	__property ExplorerCombobox;
	__property ExplorerTreeview;
	__property FileObjects = {default=3};
	__property FileSizeFormat;
	__property Font;
	__property Gesture;
	__property GroupCollapseButton;
	__property Grouped;
	__property GroupExpandButton;
	__property GroupingColumn;
	__property Groups;
	__property GroupFont;
	__property HintAlignment = {default=0};
	__property HintType = {default=0};
	__property Header;
	__property HotTrack;
	__property IncrementalSearch;
	__property OnRebuildingShellHeader;
	__property OnRebuiltShellHeader;
	__property Options = {default=207};
	__property PaintInfoColumn;
	__property PaintInfoGroup;
	__property PaintInfoItem;
	__property ParentBiDiMode = {default=1};
	__property ParentBackground = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property QueryInfoHintTimeout = {default=2500};
	__property RootFolder = {default=16};
	__property RootFolderCustomPath = {default=0};
	__property ShowHint;
	__property ShowGroupMargins = {default=0};
	__property ShowImages = {default=1};
	__property ShowInactive = {default=0};
	__property ShowThemedBorder = {default=1};
	__property Sort;
	__property SortFolderFirstAlways = {default=0};
	__property Selection;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Themed = {default=1};
	__property ThumbsManager;
	__property View = {default=0};
	__property Visible = {default=1};
	__property WheelMouseDefaultScroll = {default=1};
	__property WheelMouseScrollModifierEnabled = {default=1};
	__property OnAfterPaint;
	__property OnAfterShellNotify;
	__property OnBeforeItemThumbnailDraw;
	__property OnBeginUpdate;
	__property OnCanResize;
	__property OnClick;
	__property OnClipboardChange;
	__property OnClipboardCopy;
	__property OnClipboardCut;
	__property OnClipboardPaste;
	__property OnConstrainedResize;
	__property OnContextPopup;
	__property OnColumnCheckChanged;
	__property OnColumnCheckChanging;
	__property OnColumnClick;
	__property OnColumnContextMenu;
	__property OnColumnCustomView;
	__property OnColumnDblClick;
	__property OnColumnEnableChanged;
	__property OnColumnEnableChanging;
	__property OnColumnFreeing;
	__property OnColumnImageDraw;
	__property OnColumnImageGetSize;
	__property OnColumnImageDrawIsCustom;
	__property OnColumnInitialize;
	__property OnColumnLoadFromStream;
	__property OnColumnPaintText;
	__property OnColumnSaveToStream;
	__property OnColumnSelectionChanged;
	__property OnColumnSelectionChanging;
	__property OnColumnSizeChanged;
	__property OnColumnSizeChanging;
	__property OnColumnStructureChange;
	__property OnColumnVisibilityChanged;
	__property OnColumnVisibilityChanging;
	__property OnContextMenu;
	__property OnContextMenu2Message;
	__property OnContextMenuAfterCmd;
	__property OnContextMenuCmd;
	__property OnContextMenuItemChange;
	__property OnContextMenuShow;
	__property OnCustomColumnAdd;
	__property OnCustomColumnCompare;
	__property OnCustomColumnGetCaption;
	__property OnCustomGrid;
	__property OnCustomGroup;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDockDrop;
	__property OnDockOver;
	__property OnEndDock;
	__property OnEndDrag;
	__property OnEndUpdate;
	__property OnEnter;
	__property OnEnumFinished;
	__property OnEnumFolder;
	__property OnEnumThreadLengthyOperation;
	__property OnExit;
	__property OnExplorerGroupClass;
	__property OnExplorerItemClass;
	__property OnGetDragImage;
	__property OnGetSiteInfo;
	__property OnGetStorage;
	__property OnGroupClick;
	__property OnGroupCollapse;
	__property OnGroupCollapsing;
	__property OnGroupCompare;
	__property OnGroupContextMenu;
	__property OnGroupCustomView;
	__property OnGroupDblClick;
	__property OnGroupExpand;
	__property OnGroupExpanding;
	__property OnGroupFreeing;
	__property OnGroupImageDraw;
	__property OnGroupImageGetSize;
	__property OnGroupImageDrawIsCustom;
	__property OnGroupingChange;
	__property OnGroupLoadFromStream;
	__property OnGroupInitialize;
	__property OnGroupPaintText;
	__property OnGroupSaveToStream;
	__property OnGroupStructureChange;
	__property OnGroupVisibilityChanged;
	__property OnGroupVisibilityChanging;
	__property OnHeaderDblClick;
	__property OnHeaderMouseDown;
	__property OnHeaderMouseMove;
	__property OnHeaderMouseUp;
	__property OnHintCustomInfo;
	__property OnHintCustomDraw;
	__property OnHintPauseTime;
	__property OnHintPopup;
	__property OnIncrementalSearch;
	__property OnInvalidRootNamespace;
	__property OnItemCheckChange;
	__property OnItemCheckChanging;
	__property OnItemClick;
	__property OnItemCompare;
	__property OnItemContextMenu;
	__property OnItemCreateEditor;
	__property OnItemCustomView;
	__property OnItemDblClick;
	__property OnItemEditAccepted;
	__property OnItemEditBegin;
	__property OnItemEdited;
	__property OnItemEditEnd;
	__property OnItemEnableChange;
	__property OnItemEnableChanging;
	__property OnItemFreeing;
	__property OnItemFocusChanged;
	__property OnItemFocusChanging;
	__property OnItemGetCaption;
	__property OnItemGetEditCaption;
	__property OnItemGetImageIndex;
	__property OnItemGetImageList;
	__property OnItemGetTileDetail;
	__property OnItemGetTileDetailCount;
	__property OnItemImageDraw;
	__property OnItemImageGetSize;
	__property OnItemImageDrawIsCustom;
	__property OnItemInitialize;
	__property OnItemLoadFromStream;
	__property OnItemMouseDown;
	__property OnItemPaintText;
	__property OnItemSaveToStream;
	__property OnItemSelectionChanged;
	__property OnItemSelectionChanging;
	__property OnItemStructureChange;
	__property OnItemThumbnailDraw;
	__property OnItemSelectionsChanged;
	__property OnItemVisibilityChanged;
	__property OnItemVisibilityChanging;
	__property OnLoadStorageFromRoot;
	__property OnKeyAction;
	__property OnMouseActivate;
	__property OnMouseDown;
	__property OnMouseGesture;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseWheel;
	__property OnMouseWheelDown;
	__property OnMouseWheelUp;
	__property OnOLEDragEnd;
	__property OnOLEDragStart;
	__property OnOLEDragEnter;
	__property OnOLEDragOver;
	__property OnOLEDragLeave;
	__property OnOLEDragDrop;
	__property OnOLEGetData;
	__property OnOLEGetDataObject;
	__property OnOLEQueryContineDrag;
	__property OnOLEGiveFeedback;
	__property OnOLEQueryData;
	__property OnPaintHeaderBkGnd;
	__property OnQuickFilterCustomCompare;
	__property OnQuickFilterEnd;
	__property OnQuickFilterStart;
	__property OnResize;
	__property OnRootChange;
	__property OnRootChanging;
	__property OnRootRebuild;
	__property OnScroll;
	__property OnSaveRootToStorage;
	__property OnShellExecute;
	__property OnShellNotify;
	__property OnSortBegin;
	__property OnSortEnd;
	__property OnStartDock;
	__property OnStartDrag;
	__property OnThumbRequestCreate;
	__property OnUnDock;
	__property OnViewChange;
public:
	/* TCustomVirtualExplorerEasyListview.Create */ inline __fastcall virtual TVirtualExplorerEasyListview(System::Classes::TComponent* AOwner) : TCustomVirtualExplorerEasyListview(AOwner) { }
	/* TCustomVirtualExplorerEasyListview.Destroy */ inline __fastcall virtual ~TVirtualExplorerEasyListview(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualExplorerEasyListview(HWND ParentWindow) : TCustomVirtualExplorerEasyListview(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TCustomVirtualMultiPathExplorerEasyListview : public TCustomVirtualExplorerEasyListview
{
	typedef TCustomVirtualExplorerEasyListview inherited;
	
private:
	int FColumnIndex;
	
protected:
	virtual int __fastcall DoItemCompare(Easylistview::TEasyColumn* Column, Easylistview::TEasyGroup* Group, Easylistview::TEasyItem* Item1, Easylistview::TEasyItem* Item2);
	virtual void __fastcall DoCustomColumnAdd(void);
	virtual void __fastcall DoCustomColumnCompare(TExplorerColumn* Column, Easylistview::TEasyGroup* Group, TExplorerItem* Item1, TExplorerItem* Item2, int &CompareResult);
	virtual void __fastcall DoCustomColumnGetCaption(TExplorerColumn* Column, TExplorerItem* Item, System::WideString &Caption);
	void __fastcall ScanAndDeleteInValidItems(void);
	__property int ColumnIndex = {read=FColumnIndex, write=FColumnIndex, nodefault};
	
public:
	__fastcall virtual TCustomVirtualMultiPathExplorerEasyListview(System::Classes::TComponent* AOwner);
	DYNAMIC Easylistview::TEasyItem* __fastcall RereadAndRefresh(bool DoSort);
	virtual void __fastcall CopyToClipboard(int AbsolutePIDLs = 0x1);
	virtual void __fastcall CutToClipboard(int AbsolutePIDLs = 0x1);
	DYNAMIC void __fastcall Rebuild(bool RestoreTopNode = false);
	virtual void __fastcall SelectedFilesDelete(Mpshellutilities::TExecuteVerbShift ShiftKeyState = (Mpshellutilities::TExecuteVerbShift)(0x0));
	
__published:
	__property Active = {default=1};
	__property OnRebuildingShellHeader;
public:
	/* TCustomVirtualExplorerEasyListview.Destroy */ inline __fastcall virtual ~TCustomVirtualMultiPathExplorerEasyListview(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TCustomVirtualMultiPathExplorerEasyListview(HWND ParentWindow) : TCustomVirtualExplorerEasyListview(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualMultiPathExplorerEasyListview : public TCustomVirtualMultiPathExplorerEasyListview
{
	typedef TCustomVirtualMultiPathExplorerEasyListview inherited;
	
public:
	__property CategoryInfo;
	__property ExtensionColorCodeList;
	__property GlobalImages;
	__property GroupingFileSizeArray;
	__property GroupingModifiedArray;
	__property ItemCount;
	__property Items;
	__property States;
	__property Scrollbars;
	
__published:
	__property Active = {default=1};
	__property AllowHiddenCheckedItems = {default=0};
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property AutoSort = {default=1};
	__property BackGndMenu;
	__property BackGround;
	__property BevelKind = {default=0};
	__property BevelInner = {index=0, default=2};
	__property BevelOuter = {index=1, default=1};
	__property BevelWidth = {default=1};
	__property BiDiMode;
	__property BorderStyle = {default=1};
	__property BorderWidth = {default=0};
	__property CellSizes;
	__property Color = {default=-16777211};
	__property ColumnMenuItemCount = {default=5};
	__property CompressedFile;
	__property Constraints;
	__property Ctl3D;
	__property DefaultSortColumn = {default=-1};
	__property DefaultSortDir = {default=0};
	__property EditManager;
	__property EncryptedFile;
	__property ExtensionColorCode = {default=0};
	__property ExtensionColorCodeSelected = {default=1};
	__property FileSizeFormat;
	__property DragKind = {default=0};
	__property DragManager;
	__property ExplorerCombobox;
	__property ExplorerTreeview;
	__property Font;
	__property GroupCollapseButton;
	__property Grouped;
	__property GroupExpandButton;
	__property GroupingColumn;
	__property Groups;
	__property GroupFont;
	__property HintAlignment = {default=0};
	__property HintType = {default=0};
	__property Header;
	__property HotTrack;
	__property IncrementalSearch;
	__property Options = {default=207};
	__property PaintInfoColumn;
	__property PaintInfoGroup;
	__property PaintInfoItem;
	__property ParentBiDiMode = {default=1};
	__property ParentBackground = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property QueryInfoHintTimeout = {default=2500};
	__property RootFolder = {default=16};
	__property RootFolderCustomPath = {default=0};
	__property ShowHint;
	__property ShowGroupMargins = {default=0};
	__property ShowInactive = {default=0};
	__property ShowThemedBorder = {default=1};
	__property Sort;
	__property SortFolderFirstAlways = {default=0};
	__property Selection;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Themed = {default=1};
	__property ThumbsManager;
	__property View = {default=0};
	__property Visible = {default=1};
	__property WheelMouseDefaultScroll = {default=1};
	__property WheelMouseScrollModifierEnabled = {default=1};
	__property OnAfterPaint;
	__property OnCanResize;
	__property OnClick;
	__property OnClipboardChange;
	__property OnConstrainedResize;
	__property OnContextPopup;
	__property OnColumnCheckChanged;
	__property OnColumnCheckChanging;
	__property OnColumnClick;
	__property OnColumnContextMenu;
	__property OnColumnCustomView;
	__property OnColumnDblClick;
	__property OnColumnEnableChanged;
	__property OnColumnEnableChanging;
	__property OnColumnFreeing;
	__property OnColumnImageDraw;
	__property OnColumnImageGetSize;
	__property OnColumnImageDrawIsCustom;
	__property OnColumnInitialize;
	__property OnColumnLoadFromStream;
	__property OnColumnPaintText;
	__property OnColumnSaveToStream;
	__property OnColumnSelectionChanged;
	__property OnColumnSelectionChanging;
	__property OnColumnSizeChanged;
	__property OnColumnSizeChanging;
	__property OnColumnVisibilityChanged;
	__property OnColumnVisibilityChanging;
	__property OnContextMenu;
	__property OnContextMenu2Message;
	__property OnContextMenuAfterCmd;
	__property OnContextMenuCmd;
	__property OnContextMenuItemChange;
	__property OnContextMenuShow;
	__property OnCustomColumnAdd;
	__property OnCustomColumnCompare;
	__property OnCustomColumnGetCaption;
	__property OnCustomGrid;
	__property OnCustomGroup;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDockDrop;
	__property OnDockOver;
	__property OnEndDock;
	__property OnEndDrag;
	__property OnEndUpdate;
	__property OnEnter;
	__property OnExit;
	__property OnExplorerGroupClass;
	__property OnExplorerItemClass;
	__property OnGetDragImage;
	__property OnGetSiteInfo;
	__property OnGetStorage;
	__property OnGroupClick;
	__property OnGroupCollapse;
	__property OnGroupCollapsing;
	__property OnGroupCompare;
	__property OnGroupContextMenu;
	__property OnGroupCustomView;
	__property OnGroupDblClick;
	__property OnGroupExpand;
	__property OnGroupExpanding;
	__property OnGroupFreeing;
	__property OnGroupImageDraw;
	__property OnGroupImageGetSize;
	__property OnGroupImageDrawIsCustom;
	__property OnGroupLoadFromStream;
	__property OnGroupInitialize;
	__property OnGroupPaintText;
	__property OnGroupSaveToStream;
	__property OnGroupVisibilityChanged;
	__property OnGroupVisibilityChanging;
	__property OnHeaderDblClick;
	__property OnHeaderMouseDown;
	__property OnHeaderMouseMove;
	__property OnHeaderMouseUp;
	__property OnHintCustomInfo;
	__property OnHintCustomDraw;
	__property OnHintPauseTime;
	__property OnHintPopup;
	__property OnIncrementalSearch;
	__property OnItemCheckChange;
	__property OnItemCheckChanging;
	__property OnItemClick;
	__property OnItemCompare;
	__property OnItemContextMenu;
	__property OnItemCreateEditor;
	__property OnItemCustomView;
	__property OnItemDblClick;
	__property OnItemEditBegin;
	__property OnItemEdited;
	__property OnItemEditEnd;
	__property OnItemEnableChange;
	__property OnItemEnableChanging;
	__property OnItemFreeing;
	__property OnItemFocusChanged;
	__property OnItemFocusChanging;
	__property OnItemGetCaption;
	__property OnItemGetEditCaption;
	__property OnItemGetImageIndex;
	__property OnItemGetImageList;
	__property OnItemGetTileDetail;
	__property OnItemGetTileDetailCount;
	__property OnItemImageDraw;
	__property OnItemImageGetSize;
	__property OnItemImageDrawIsCustom;
	__property OnItemInitialize;
	__property OnItemLoadFromStream;
	__property OnItemMouseDown;
	__property OnItemPaintText;
	__property OnItemSaveToStream;
	__property OnItemSelectionChanged;
	__property OnItemSelectionChanging;
	__property OnItemStructureChange;
	__property OnItemThumbnailDraw;
	__property OnItemSelectionsChanged;
	__property OnItemVisibilityChanged;
	__property OnItemVisibilityChanging;
	__property OnKeyAction;
	__property OnMouseActivate;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseWheel;
	__property OnMouseWheelDown;
	__property OnMouseWheelUp;
	__property OnOLEDragEnd;
	__property OnOLEDragStart;
	__property OnOLEDragEnter;
	__property OnOLEDragOver;
	__property OnOLEDragLeave;
	__property OnOLEDragDrop;
	__property OnOLEGetData;
	__property OnOLEGetDataObject;
	__property OnOLEQueryContineDrag;
	__property OnOLEGiveFeedback;
	__property OnOLEQueryData;
	__property OnPaintHeaderBkGnd;
	__property OnQuickFilterCustomCompare;
	__property OnQuickFilterEnd;
	__property OnQuickFilterStart;
	__property OnRebuildingShellHeader;
	__property OnRebuiltShellHeader;
	__property OnResize;
	__property OnScroll;
	__property OnShellExecute;
	__property OnShellNotify;
	__property OnSortBegin;
	__property OnSortEnd;
	__property OnStartDock;
	__property OnStartDrag;
	__property OnThumbRequestCreate;
	__property OnUnDock;
	__property OnViewChange;
public:
	/* TCustomVirtualMultiPathExplorerEasyListview.Create */ inline __fastcall virtual TVirtualMultiPathExplorerEasyListview(System::Classes::TComponent* AOwner) : TCustomVirtualMultiPathExplorerEasyListview(AOwner) { }
	
public:
	/* TCustomVirtualExplorerEasyListview.Destroy */ inline __fastcall virtual ~TVirtualMultiPathExplorerEasyListview(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualMultiPathExplorerEasyListview(HWND ParentWindow) : TCustomVirtualMultiPathExplorerEasyListview(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualDropStack : public TCustomVirtualDropStack
{
	typedef TCustomVirtualDropStack inherited;
	
public:
	__property AllowHiddenCheckedItems = {default=0};
	__property GlobalImages;
	__property Items;
	__property States;
	__property Scrollbars;
	
__published:
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property AutoRemove = {default=0};
	__property BackGround;
	__property BevelKind = {default=0};
	__property BevelInner = {index=0, default=2};
	__property BevelOuter = {index=1, default=1};
	__property BevelWidth = {default=1};
	__property BiDiMode;
	__property BorderStyle = {default=1};
	__property BorderWidth = {default=0};
	__property CellSizes;
	__property Color = {default=-16777211};
	__property Constraints;
	__property Ctl3D;
	__property DragKind = {default=0};
	__property DragManager;
	__property Font;
	__property HintItemCount = {default=16};
	__property HotTrack;
	__property IncrementalSearch;
	__property PaintInfoItem;
	__property ParentBiDiMode = {default=1};
	__property ParentBackground = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property Selection;
	__property ShowHint;
	__property ShowInactive = {default=0};
	__property ShowThemedBorder = {default=1};
	__property Sort;
	__property StackDepth = {default=64};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Themed = {default=1};
	__property View = {default=0};
	__property Visible = {default=1};
	__property WheelMouseDefaultScroll = {default=1};
	__property WheelMouseScrollModifierEnabled = {default=1};
	__property OnAfterPaint;
	__property OnCanResize;
	__property OnClick;
	__property OnConstrainedResize;
	__property OnContextPopup;
	__property OnContextMenu;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDockDrop;
	__property OnDockOver;
	__property OnEndDock;
	__property OnEndUpdate;
	__property OnEnter;
	__property OnExit;
	__property OnGetDragImage;
	__property OnGetSiteInfo;
	__property OnHintCustomInfo;
	__property OnHintCustomDraw;
	__property OnHintPauseTime;
	__property OnHintPopup;
	__property OnIncrementalSearch;
	__property OnItemCheckChange;
	__property OnItemCheckChanging;
	__property OnItemClick;
	__property OnItemCompare;
	__property OnItemContextMenu;
	__property OnItemCustomView;
	__property OnItemDblClick;
	__property OnItemEnableChange;
	__property OnItemEnableChanging;
	__property OnItemFreeing;
	__property OnItemFocusChanged;
	__property OnItemFocusChanging;
	__property OnItemGetCaption;
	__property OnItemGetEditCaption;
	__property OnItemGetImageIndex;
	__property OnItemGetImageList;
	__property OnItemGetTileDetail;
	__property OnItemGetTileDetailCount;
	__property OnItemImageDraw;
	__property OnItemImageGetSize;
	__property OnItemImageDrawIsCustom;
	__property OnItemInitialize;
	__property OnItemLoadFromStream;
	__property OnItemMouseDown;
	__property OnItemPaintText;
	__property OnItemSaveToStream;
	__property OnItemSelectionChanged;
	__property OnItemSelectionChanging;
	__property OnItemThumbnailDraw;
	__property OnItemSelectionsChanged;
	__property OnItemVisibilityChanged;
	__property OnItemVisibilityChanging;
	__property OnKeyAction;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseWheel;
	__property OnMouseWheelDown;
	__property OnMouseWheelUp;
	__property OnResize;
	__property OnScroll;
	__property OnStartDock;
	__property OnStartDrag;
	__property OnUnDock;
	__property OnViewChange;
public:
	/* TCustomVirtualDropStack.Create */ inline __fastcall virtual TVirtualDropStack(System::Classes::TComponent* AOwner) : TCustomVirtualDropStack(AOwner) { }
	
public:
	/* TCustomEasyListview.Destroy */ inline __fastcall virtual ~TVirtualDropStack(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualDropStack(HWND ParentWindow) : TCustomVirtualDropStack(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualExplorerEasyListviewHintWindow : public Easylistview::TEasyHintWindow
{
	typedef Easylistview::TEasyHintWindow inherited;
	
private:
	Vcl::Graphics::TBitmap* FThumbBits;
	System::Types::TRect FThumbRect;
	
protected:
	virtual void __fastcall Paint(void);
	__property Vcl::Graphics::TBitmap* ThumbBits = {read=FThumbBits, write=FThumbBits};
	
public:
	virtual System::Types::TRect __fastcall CalcHintRect(int MaxWidth, const System::UnicodeString AHint, void * AData);
	__property System::Types::TRect ThumbRect = {read=FThumbRect, write=FThumbRect};
public:
	/* TEasyHintWindow.Create */ inline __fastcall virtual TVirtualExplorerEasyListviewHintWindow(System::Classes::TComponent* AOwner) : Easylistview::TEasyHintWindow(AOwner) { }
	/* TEasyHintWindow.Destroy */ inline __fastcall virtual ~TVirtualExplorerEasyListviewHintWindow(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualExplorerEasyListviewHintWindow(HWND ParentWindow) : Easylistview::TEasyHintWindow(ParentWindow) { }
	
};


typedef System::DynamicArray<TVirtualExplorerEasyListview*> TVirtualExplorerEasyListviewArray;

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 TID_ICON = System::Int8(0x64);
static const System::Int8 TID_THUMBNAIL = System::Int8(0x1);
static const System::Int8 TID_DETAILS = System::Int8(0x2);
static const System::Int8 TID_DETAILSOF = System::Int8(0x3);
static const System::Word WM_DETAILSOF_THREAD = System::Word(0x81b5);
static const System::Int8 CURRENT_EASYLISTVIEWEXPLORER_STREAM_VERSION = System::Int8(0x2);
#define IE_NAMEFORPARSING L"::{871C5380-42A0-1069-A2EA-08002B30309D}"
static const __int64 MaxInt64 = 0x7fffffffffffffffLL;
static const System::Int8 SPECIALFOLDERSTART = System::Int8(0x6);
static const System::Int8 MAXGROUPING = System::Int8(0xc);
static const System::Int8 ID_SIZE_COLUMN = System::Int8(0x1);
extern DELPHI_PACKAGE Virtualexplorereasylistview__1 GROUPINGFILESIZE;
extern DELPHI_PACKAGE System::StaticArray<__int64, 8> GROUPINGFILESIZEDELTA;
extern DELPHI_PACKAGE Virtualexplorereasylistview__2 GROUPINGMODIFIEDDATE;
extern DELPHI_PACKAGE System::StaticArray<float, 13> GROUPINGMODIFIEDDATEDELTA;
extern DELPHI_PACKAGE int UnknownFolderIconIndex;
extern DELPHI_PACKAGE int UnknownFileIconIndex;
extern DELPHI_PACKAGE void __fastcall SaveListviewToDefaultColumnWidths(TCustomVirtualExplorerEasyListview* Listview);
extern DELPHI_PACKAGE void __fastcall SaveListviewToColumnArray(TCustomVirtualExplorerEasyListview* Listview, Mpshellutilities::TColumnWidthArray &ColumnWidths);
extern DELPHI_PACKAGE void __fastcall LoadListviewWidthDefaultColumnWidths(TCustomVirtualExplorerEasyListview* Listview);
extern DELPHI_PACKAGE void __fastcall LoadListviewWithColumnArray(TCustomVirtualExplorerEasyListview* Listview, const Mpshellutilities::TColumnWidthArray &ColumnWidths);
extern DELPHI_PACKAGE int __fastcall HeaderStateCount(const TVirtualExplorerEasyListviewHeaderState &HeaderState);
extern DELPHI_PACKAGE bool __fastcall HeaderStateValidate(const TVirtualExplorerEasyListviewHeaderState &HeaderState);
extern DELPHI_PACKAGE void __fastcall HeaderStateSort(PositionSortType PositionType, const TVirtualExplorerEasyListviewHeaderState &HeaderState);
extern DELPHI_PACKAGE void __fastcall SaveHeaderState(TCustomVirtualExplorerEasyListview* Listview, PVirtualExplorerEasyListviewHeaderState HeaderState)/* overload */;
extern DELPHI_PACKAGE void __fastcall SaveHeaderState(TCustomVirtualExplorerEasyListview* Listview, TVirtualExplorerEasyListviewHeaderState &HeaderState)/* overload */;
extern DELPHI_PACKAGE void __fastcall SaveHeaderStateToStream(System::Classes::TStream* TargetStream, const TVirtualExplorerEasyListviewHeaderState &HeaderState);
extern DELPHI_PACKAGE void __fastcall LoadHeaderState(TCustomVirtualExplorerEasyListview* Listview, const TVirtualExplorerEasyListviewHeaderState &HeaderState);
extern DELPHI_PACKAGE void __fastcall LoadHeaderStateFromStream(System::Classes::TStream* SourceStream, TVirtualExplorerEasyListviewHeaderState &HeaderState);
extern DELPHI_PACKAGE int __fastcall ListBinarySearch(Winapi::Shlobj::PItemIDList Target, Easylistview::TEasyItemArray List, const _di_IShellFolder ParentFolder, int Min, int Max);
extern DELPHI_PACKAGE void __fastcall LoadDefaultGroupingModifiedArray(TGroupingModifiedArray &GroupingModifiedArray, bool CaptionsOnly);
extern DELPHI_PACKAGE void __fastcall LoadDefaultGroupingFileSizeArray(TGroupingFileSizeArray &GroupingFileSizeArray, bool CaptionsOnly);
extern DELPHI_PACKAGE void __fastcall AddThumbRequest(Vcl::Controls::TWinControl* Window, TExplorerItem* Item, const System::Types::TPoint &ThumbSize, bool UseExifThumbnail, bool UseExifOrientation, bool UseShellExtraction, bool UseSubsampling, bool IsResizing, TThumbThreadCreateProc ThumbRequestClassCallback);
extern DELPHI_PACKAGE void __fastcall ItemNamespaceQuickSort(Easylistview::TEasyItemArray ItemArray, const _di_IShellFolder ParentFolder, int L, int R);
}	/* namespace Virtualexplorereasylistview */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALEXPLOREREASYLISTVIEW)
using namespace Virtualexplorereasylistview;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualexplorereasylistviewHPP
