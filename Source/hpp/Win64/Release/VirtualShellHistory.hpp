// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualShellHistory.pas' rev: 32.00 (Windows)

#ifndef VirtualshellhistoryHPP
#define VirtualshellhistoryHPP

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
#include <Vcl.Menus.hpp>
#include <VirtualExplorerTree.hpp>
#include <MPShellUtilities.hpp>
#include <Winapi.ShlObj.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Vcl.ImgList.hpp>
#include <MPCommonUtilities.hpp>
#include <MPCommonObjects.hpp>
#include <VirtualResources.hpp>
#include <System.Win.Registry.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualshellhistory
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TVSHMenuOptions;
class DELPHICLASS TBaseVirtualShellPersistent;
class DELPHICLASS TCustomVirtualShellMRU;
class DELPHICLASS TVirtualShellMRU;
class DELPHICLASS TCustomVirtualShellHistory;
class DELPHICLASS TVirtualShellHistory;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TVSHChangeType : unsigned char { hctAdded, hctDeleted, hctSelected, hctInvalidSelected };

enum DECLSPEC_DENUM TVSHMenuTextType : unsigned char { mttName, mttPath };

enum DECLSPEC_DENUM TBaseVSPState : unsigned char { bvsChangeNotified, bvsChangeDispatching, bvsChangeItemsLoading };

typedef System::Set<TBaseVSPState, TBaseVSPState::bvsChangeNotified, TBaseVSPState::bvsChangeItemsLoading> TBaseVSPStates;

enum DECLSPEC_DENUM TFillPopupDirection : unsigned char { fpdNewestToOldest, fpdOldestToNewest };

typedef void __fastcall (__closure *TVSPChangeEvent)(TBaseVirtualShellPersistent* Sender, int ItemIndex, TVSHChangeType ChangeType);

typedef void __fastcall (__closure *TVSPGetImageEvent)(TBaseVirtualShellPersistent* Sender, Mpshellutilities::TNamespace* NS, Vcl::Controls::TImageList* &ImageList, int &ImageIndex);

class PASCALIMPLEMENTATION TVSHMenuOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	Mpcommonutilities::TShortenStringEllipsis FEllipsisPlacement;
	bool FImages;
	int FImageBorder;
	bool FLargeImages;
	TVSHMenuTextType FTextType;
	int FMaxWidth;
	
public:
	__fastcall TVSHMenuOptions(void);
	__fastcall virtual ~TVSHMenuOptions(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	
__published:
	__property Mpcommonutilities::TShortenStringEllipsis EllipsisPlacement = {read=FEllipsisPlacement, write=FEllipsisPlacement, default=3};
	__property bool Images = {read=FImages, write=FImages, default=0};
	__property int ImageBorder = {read=FImageBorder, write=FImageBorder, default=1};
	__property bool LargeImages = {read=FLargeImages, write=FLargeImages, default=0};
	__property TVSHMenuTextType TextType = {read=FTextType, write=FTextType, default=0};
	__property int MaxWidth = {read=FMaxWidth, write=FMaxWidth, default=-1};
};


class PASCALIMPLEMENTATION TBaseVirtualShellPersistent : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	Mpshellutilities::TNamespace* operator[](int Index) { return this->Items[Index]; }
	
private:
	TVSPChangeEvent FOnChange;
	bool FSaveMappedDrivePaths;
	bool FSaveNetworkPaths;
	bool FSaveRemovableDrivePaths;
	Virtualexplorertree::TCustomVirtualExplorerCombobox* FVirtualExplorerComboBox;
	Virtualexplorertree::TCustomVirtualExplorerTree* FVirtualExplorerTree;
	int FLevels;
	TVSPGetImageEvent FOnGetImage;
	TVSHMenuOptions* FMenuOptions;
	int FItemIndex;
	System::Classes::TList* FNamespaces;
	TBaseVSPStates FState;
	void __fastcall SetVirtualExplorerComboBox(Virtualexplorertree::TCustomVirtualExplorerCombobox* const Value);
	void __fastcall SetVirtualExplorerTree(Virtualexplorertree::TCustomVirtualExplorerTree* const Value);
	void __fastcall SetLevels(const int Value);
	void __fastcall SetMenuOptions(TVSHMenuOptions* const Value);
	Vcl::Controls::TImageList* __fastcall GetLargeSysImages(void);
	Vcl::Controls::TImageList* __fastcall GetSmallSysImages(void);
	Mpshellutilities::TNamespace* __fastcall GetItems(int Index);
	void __fastcall SetItemIndex(int Value);
	int __fastcall GetCount(void);
	bool __fastcall GetHasBackItems(void);
	bool __fastcall GetHasNextItems(void);
	
protected:
	DYNAMIC void __fastcall ChangeLinkChanging(System::TObject* Server, Winapi::Shlobj::PItemIDList NewPIDL);
	virtual void __fastcall ChangeLinkDispatch(Winapi::Shlobj::PItemIDList PIDL);
	DYNAMIC void __fastcall ChangeLinkFreeing(Virtualexplorertree::_di_IVETChangeLink ChangeLink);
	DYNAMIC TVSHMenuOptions* __fastcall CreateMenuOptions(void);
	bool __fastcall DeleteDuplicates(Mpshellutilities::TNamespace* NS);
	void __fastcall ValidateLevels(void);
	virtual void __fastcall DoGetImage(Mpshellutilities::TNamespace* NS, Vcl::Controls::TImageList* &ImageList, int &ImageIndex);
	void __fastcall DoItemChange(int ItemIndex, TVSHChangeType ChangeType);
	virtual void __fastcall OnMenuItemClick(System::TObject* Sender);
	virtual void __fastcall OnMenuItemDraw(System::TObject* Sender, Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, bool Selected);
	virtual void __fastcall OnMenuItemMeasure(System::TObject* Sender, Vcl::Graphics::TCanvas* ACanvas, int &Width, int &Height);
	__property int Count = {read=GetCount, nodefault};
	__property bool HasBackItems = {read=GetHasBackItems, nodefault};
	__property bool HasNextItems = {read=GetHasNextItems, nodefault};
	__property int ItemIndex = {read=FItemIndex, write=SetItemIndex, nodefault};
	__property Vcl::Controls::TImageList* LargeSysImages = {read=GetLargeSysImages};
	__property int Levels = {read=FLevels, write=SetLevels, default=10};
	__property TVSHMenuOptions* MenuOptions = {read=FMenuOptions, write=SetMenuOptions};
	__property System::Classes::TList* Namespaces = {read=FNamespaces, write=FNamespaces};
	__property TVSPChangeEvent OnChange = {read=FOnChange, write=FOnChange};
	__property TVSPGetImageEvent OnGetImage = {read=FOnGetImage, write=FOnGetImage};
	__property bool SaveMappedDrivePaths = {read=FSaveMappedDrivePaths, write=FSaveMappedDrivePaths, default=0};
	__property bool SaveNetworkPaths = {read=FSaveNetworkPaths, write=FSaveNetworkPaths, default=0};
	__property bool SaveRemovableDrivePaths = {read=FSaveRemovableDrivePaths, write=FSaveRemovableDrivePaths, default=0};
	__property Vcl::Controls::TImageList* SmallSysImages = {read=GetSmallSysImages};
	__property Virtualexplorertree::TCustomVirtualExplorerCombobox* VirtualExplorerComboBox = {read=FVirtualExplorerComboBox, write=SetVirtualExplorerComboBox};
	__property Virtualexplorertree::TCustomVirtualExplorerTree* VirtualExplorerTree = {read=FVirtualExplorerTree, write=SetVirtualExplorerTree};
	
public:
	__fastcall virtual TBaseVirtualShellPersistent(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TBaseVirtualShellPersistent(void);
	virtual int __fastcall Add(Mpshellutilities::TNamespace* Value, bool Release = false, bool SelectAsIndex = true);
	virtual void __fastcall Clear(void);
	void __fastcall Delete(int Index);
	virtual void __fastcall FillPopupMenu(Vcl::Menus::TPopupMenu* Popupmenu, TFillPopupDirection FillDirection, System::WideString ClearItemText = System::WideString());
	void __fastcall LoadFromFile(System::WideString FileName);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S);
	void __fastcall LoadFromRegistry(unsigned RootKey, System::UnicodeString SubKey);
	void __fastcall SaveToFile(System::WideString FileName);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S, bool ForceSaveAllPaths = false);
	void __fastcall SaveToRegistry(unsigned RootKey, System::UnicodeString SubKey);
	__property TBaseVSPStates State = {read=FState, write=FState, nodefault};
	__property Mpshellutilities::TNamespace* Items[int Index] = {read=GetItems/*, default*/};
};


class PASCALIMPLEMENTATION TCustomVirtualShellMRU : public TBaseVirtualShellPersistent
{
	typedef TBaseVirtualShellPersistent inherited;
	
public:
	__property ItemIndex;
	__property LargeSysImages;
	__property SmallSysImages;
public:
	/* TBaseVirtualShellPersistent.Create */ inline __fastcall virtual TCustomVirtualShellMRU(System::Classes::TComponent* AOwner) : TBaseVirtualShellPersistent(AOwner) { }
	/* TBaseVirtualShellPersistent.Destroy */ inline __fastcall virtual ~TCustomVirtualShellMRU(void) { }
	
};


class PASCALIMPLEMENTATION TVirtualShellMRU : public TCustomVirtualShellMRU
{
	typedef TCustomVirtualShellMRU inherited;
	
__published:
	__property Count;
	__property Levels = {default=10};
	__property MenuOptions;
	__property OnChange;
	__property OnGetImage;
	__property SaveMappedDrivePaths = {default=0};
	__property SaveNetworkPaths = {default=0};
	__property SaveRemovableDrivePaths = {default=0};
	__property VirtualExplorerComboBox;
	__property VirtualExplorerTree;
public:
	/* TBaseVirtualShellPersistent.Create */ inline __fastcall virtual TVirtualShellMRU(System::Classes::TComponent* AOwner) : TCustomVirtualShellMRU(AOwner) { }
	/* TBaseVirtualShellPersistent.Destroy */ inline __fastcall virtual ~TVirtualShellMRU(void) { }
	
};


class PASCALIMPLEMENTATION TCustomVirtualShellHistory : public TBaseVirtualShellPersistent
{
	typedef TBaseVirtualShellPersistent inherited;
	
public:
	virtual int __fastcall Add(Mpshellutilities::TNamespace* Value, bool Release = false, bool SelectAsIndex = true);
	virtual void __fastcall Clear(void);
	void __fastcall Back(void);
	void __fastcall Next(void);
	__property HasBackItems;
	__property HasNextItems;
	__property ItemIndex;
	__property LargeSysImages;
	__property SmallSysImages;
public:
	/* TBaseVirtualShellPersistent.Create */ inline __fastcall virtual TCustomVirtualShellHistory(System::Classes::TComponent* AOwner) : TBaseVirtualShellPersistent(AOwner) { }
	/* TBaseVirtualShellPersistent.Destroy */ inline __fastcall virtual ~TCustomVirtualShellHistory(void) { }
	
};


class PASCALIMPLEMENTATION TVirtualShellHistory : public TCustomVirtualShellHistory
{
	typedef TCustomVirtualShellHistory inherited;
	
__published:
	__property Count;
	__property Levels = {default=10};
	__property MenuOptions;
	__property OnChange;
	__property OnGetImage;
	__property SaveMappedDrivePaths = {default=0};
	__property SaveNetworkPaths = {default=0};
	__property SaveRemovableDrivePaths = {default=0};
	__property VirtualExplorerComboBox;
	__property VirtualExplorerTree;
public:
	/* TBaseVirtualShellPersistent.Create */ inline __fastcall virtual TVirtualShellHistory(System::Classes::TComponent* AOwner) : TCustomVirtualShellHistory(AOwner) { }
	/* TBaseVirtualShellPersistent.Destroy */ inline __fastcall virtual ~TVirtualShellHistory(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define REGISTRYDATASIZE L"VirtualShellHistoryMRUSize"
#define REGISTRYDATA L"VirtualShellHistoryMRUData"
}	/* namespace Virtualshellhistory */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALSHELLHISTORY)
using namespace Virtualshellhistory;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualshellhistoryHPP
