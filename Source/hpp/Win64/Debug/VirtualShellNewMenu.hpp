// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualShellNewMenu.pas' rev: 31.00 (Windows)

#ifndef VirtualshellnewmenuHPP
#define VirtualshellnewmenuHPP

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
#include <Vcl.Forms.hpp>
#include <Vcl.Menus.hpp>
#include <System.Win.Registry.hpp>
#include <Winapi.ShlObj.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Vcl.ImgList.hpp>
#include <VirtualResources.hpp>
#include <MPShellUtilities.hpp>
#include <MPCommonObjects.hpp>
#include <MPCommonUtilities.hpp>
#include <System.Contnrs.hpp>
#include <Winapi.CommCtrl.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualshellnewmenu
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TVirtualShellNewItem;
class DELPHICLASS TVirtualShellNewMenuItem;
class DELPHICLASS TVirtualShellNewItemList;
class DELPHICLASS TVirtualShellNewMenu;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TNewShellKind : unsigned char { nmk_Unknown, nmk_Null, nmk_FileName, nmk_Command, nmk_Data, nmk_Folder, nmk_Shortcut };

class PASCALIMPLEMENTATION TVirtualShellNewItem : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	void *FData;
	int FDataSize;
	System::WideString FExtension;
	System::WideString FFileType;
	TNewShellKind FNewShellKind;
	int FSystemImageIndex;
	System::WideString FNewShellKindStr;
	TVirtualShellNewMenuItem* FOwner;
	
public:
	void __fastcall CreateNewDocument(TVirtualShellNewMenu* PopupMenu, System::WideString NewFileTargetPath, System::WideString FileName);
	void __fastcall FreeData(void);
	bool __fastcall IsBriefcase(void);
	bool __fastcall IsCreateLink(void);
	__property void * Data = {read=FData, write=FData};
	__property int DataSize = {read=FDataSize, write=FDataSize, nodefault};
	__fastcall virtual ~TVirtualShellNewItem(void);
	__property System::WideString Extension = {read=FExtension, write=FExtension};
	__property System::WideString FileType = {read=FFileType, write=FFileType};
	__property TNewShellKind NewShellKind = {read=FNewShellKind, write=FNewShellKind, nodefault};
	__property System::WideString NewShellKindStr = {read=FNewShellKindStr, write=FNewShellKindStr};
	__property TVirtualShellNewMenuItem* Owner = {read=FOwner, write=FOwner};
	__property int SystemImageIndex = {read=FSystemImageIndex, write=FSystemImageIndex, nodefault};
public:
	/* TObject.Create */ inline __fastcall TVirtualShellNewItem(void) : System::TObject() { }
	
};


class PASCALIMPLEMENTATION TVirtualShellNewMenuItem : public Vcl::Menus::TMenuItem
{
	typedef Vcl::Menus::TMenuItem inherited;
	
private:
	TVirtualShellNewItem* FShellNewInfo;
	TVirtualShellNewMenu* FOwnerMenu;
	
public:
	virtual void __fastcall Click(void);
	__fastcall virtual ~TVirtualShellNewMenuItem(void);
	__property TVirtualShellNewMenu* OwnerMenu = {read=FOwnerMenu, write=FOwnerMenu};
	__property TVirtualShellNewItem* ShellNewInfo = {read=FShellNewInfo, write=FShellNewInfo};
public:
	/* TMenuItem.Create */ inline __fastcall virtual TVirtualShellNewMenuItem(System::Classes::TComponent* AOwner) : Vcl::Menus::TMenuItem(AOwner) { }
	
};


class PASCALIMPLEMENTATION TVirtualShellNewItemList : public System::Contnrs::TObjectList
{
	typedef System::Contnrs::TObjectList inherited;
	
public:
	TVirtualShellNewItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TVirtualShellNewItem* __fastcall GetItems(int Index);
	void __fastcall PutItems(int Index, TVirtualShellNewItem* const Value);
	
public:
	void __fastcall BuildList(void);
	bool __fastcall IsDuplicate(TVirtualShellNewItem* TestItem);
	void __fastcall StripDuplicates(void);
	__property TVirtualShellNewItem* Items[int Index] = {read=GetItems, write=PutItems/*, default*/};
public:
	/* TObjectList.Create */ inline __fastcall TVirtualShellNewItemList(void)/* overload */ : System::Contnrs::TObjectList() { }
	/* TObjectList.Create */ inline __fastcall TVirtualShellNewItemList(bool AOwnsObjects)/* overload */ : System::Contnrs::TObjectList(AOwnsObjects) { }
	
public:
	/* TList.Destroy */ inline __fastcall virtual ~TVirtualShellNewItemList(void) { }
	
};


typedef void __fastcall (__closure *TOnAddMenuItem)(Vcl::Menus::TPopupMenu* Sender, TVirtualShellNewItem* const NewMenuItem, bool &Allow);

typedef void __fastcall (__closure *TOnCreateNewFile)(Vcl::Menus::TMenu* Sender, TVirtualShellNewItem* const NewMenuItem, System::WideString &Path, System::WideString &FileName, bool &Allow);

typedef void __fastcall (__closure *TOnAfterFileCreate)(Vcl::Menus::TMenu* Sender, TVirtualShellNewItem* const NewMenuItem, const System::WideString FileName);

class PASCALIMPLEMENTATION TVirtualShellNewMenu : public Vcl::Menus::TPopupMenu
{
	typedef Vcl::Menus::TPopupMenu inherited;
	
private:
	TVirtualShellNewItemList* FShellNewItems;
	System::Classes::TBasicAction* FDefaultAction;
	TOnAddMenuItem FOnAddMenuItem;
	Vcl::Controls::TImageList* FSystemImages;
	TOnCreateNewFile FOnCreateNewFile;
	bool FUseShellImages;
	bool FCombineLikeItems;
	bool FWarnOnOverwrite;
	bool FNewShortcutItem;
	bool FNewFolderItem;
	TOnAfterFileCreate FOnAfterFileCreate;
	Vcl::Imglist::TCustomImageList* __fastcall GetImages(void);
	HIDESBASE void __fastcall SetImages(Vcl::Imglist::TCustomImageList* const Value);
	void __fastcall SetUseShellImages(const bool Value);
	
protected:
	void __fastcall CreateMenuItems(Vcl::Menus::TMenuItem* ParentItem);
	DYNAMIC void __fastcall DoAddMenuItem(TVirtualShellNewItem* NewMenuItem, bool &Allow);
	DYNAMIC void __fastcall DoAfterFileCreate(TVirtualShellNewItem* NewMenuItem, System::WideString FileName);
	void __fastcall DoCreateNewFile(TVirtualShellNewItem* NewMenuItem, System::WideString &Path, System::WideString &FileName, bool &Allow);
	__property TVirtualShellNewItemList* ShellNewItems = {read=FShellNewItems};
	__property Vcl::Controls::TImageList* SystemImages = {read=FSystemImages, write=FSystemImages};
	
public:
	__fastcall virtual TVirtualShellNewMenu(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TVirtualShellNewMenu(void);
	void __fastcall Populate(Vcl::Menus::TMenuItem* Item);
	virtual void __fastcall Popup(int X, int Y);
	void __fastcall RebuildMenu(void);
	
__published:
	__property bool CombineLikeItems = {read=FCombineLikeItems, write=FCombineLikeItems, default=0};
	__property System::Classes::TBasicAction* DefaultAction = {read=FDefaultAction, write=FDefaultAction};
	__property Vcl::Imglist::TCustomImageList* Images = {read=GetImages, write=SetImages};
	__property TOnAddMenuItem OnAddMenuItem = {read=FOnAddMenuItem, write=FOnAddMenuItem};
	__property TOnAfterFileCreate OnAfterFileCreate = {read=FOnAfterFileCreate, write=FOnAfterFileCreate};
	__property TOnCreateNewFile OnCreateNewFile = {read=FOnCreateNewFile, write=FOnCreateNewFile};
	__property bool NewFolderItem = {read=FNewFolderItem, write=FNewFolderItem, default=0};
	__property bool NewShortcutItem = {read=FNewShortcutItem, write=FNewShortcutItem, default=0};
	__property bool UseShellImages = {read=FUseShellImages, write=SetUseShellImages, default=1};
	__property bool WarnOnOverwrite = {read=FWarnOnOverwrite, write=FWarnOnOverwrite, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Virtualshellnewmenu */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALSHELLNEWMENU)
using namespace Virtualshellnewmenu;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualshellnewmenuHPP
