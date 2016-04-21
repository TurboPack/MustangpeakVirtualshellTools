// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualSendToMenu.pas' rev: 31.00 (Windows)

#ifndef VirtualsendtomenuHPP
#define VirtualsendtomenuHPP

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
#include <Winapi.ActiveX.hpp>
#include <MPShellUtilities.hpp>
#include <Vcl.ImgList.hpp>
#include <Winapi.CommCtrl.hpp>
#include <VirtualResources.hpp>
#include <MPCommonUtilities.hpp>
#include <MPCommonObjects.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualsendtomenu
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TSendToMenuOptions;
class DELPHICLASS TVirtualSendToMenu;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TSendToMenuOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FImages;
	bool FLargeImages;
	int FImageBorder;
	int FMaxWidth;
	Mpcommonutilities::TShortenStringEllipsis FEllipsisPlacement;
	
public:
	__fastcall TSendToMenuOptions(void);
	
__published:
	__property Mpcommonutilities::TShortenStringEllipsis EllipsisPlacement = {read=FEllipsisPlacement, write=FEllipsisPlacement, default=2};
	__property bool Images = {read=FImages, write=FImages, default=1};
	__property bool LargeImages = {read=FLargeImages, write=FLargeImages, default=0};
	__property int ImageBorder = {read=FImageBorder, write=FImageBorder, default=1};
	__property int MaxWidth = {read=FMaxWidth, write=FMaxWidth, default=-1};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TSendToMenuOptions(void) { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TVirtualSendToEvent)(TVirtualSendToMenu* Sender, Mpshellutilities::TNamespace* SendToTarget, _di_IDataObject &SourceData);

typedef void __fastcall (__closure *TVirtualSendToGetImageEvent)(TVirtualSendToMenu* Sender, Mpshellutilities::TNamespace* NS, Vcl::Controls::TImageList* &ImageList, int &ImageIndex);

class PASCALIMPLEMENTATION TVirtualSendToMenu : public Vcl::Menus::TPopupMenu
{
	typedef Vcl::Menus::TPopupMenu inherited;
	
private:
	Mpshellutilities::TVirtualNameSpaceList* FSendToItems;
	TVirtualSendToEvent FSendToEvent;
	TSendToMenuOptions* FOptions;
	TVirtualSendToGetImageEvent FOnGetImage;
	
protected:
	void __fastcall DoGetImage(Mpshellutilities::TNamespace* NS, Vcl::Controls::TImageList* &ImageList, int &ImageIndex);
	virtual void __fastcall DoSendTo(Mpshellutilities::TNamespace* SendToTarget, _di_IDataObject &SourceData);
	bool __fastcall EnumSendToCallback(HWND ParentWnd, Winapi::Shlobj::PItemIDList APIDL, Mpshellutilities::TNamespace* AParent, void * Data, bool &Terminate);
	virtual void __fastcall OnMenuItemClick(System::TObject* Sender);
	
public:
	__fastcall virtual TVirtualSendToMenu(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TVirtualSendToMenu(void);
	virtual void __fastcall Populate(Vcl::Menus::TMenuItem* MenuItem);
	virtual void __fastcall Popup(int X, int Y);
	__property Mpshellutilities::TVirtualNameSpaceList* SendToItems = {read=FSendToItems};
	
__published:
	__property TVirtualSendToEvent SendToEvent = {read=FSendToEvent, write=FSendToEvent};
	__property TVirtualSendToGetImageEvent OnGetImage = {read=FOnGetImage, write=FOnGetImage};
	__property TSendToMenuOptions* Options = {read=FOptions, write=FOptions};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Virtualsendtomenu */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALSENDTOMENU)
using namespace Virtualsendtomenu;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualsendtomenuHPP
