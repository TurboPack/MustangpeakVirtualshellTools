// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualShellAutoComplete.pas' rev: 32.00 (Windows)

#ifndef VirtualshellautocompleteHPP
#define VirtualshellautocompleteHPP

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
#include <Vcl.ImgList.hpp>
#include <Winapi.ShlObj.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.Win.ComObj.hpp>
#include <MPShellTypes.hpp>
#include <MPShellUtilities.hpp>
#include <MPCommonUtilities.hpp>
#include <MPCommonObjects.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualshellautocomplete
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TCustomVirtualShellAutoComplete;
class DELPHICLASS TVirtualShellAutoComplete;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TAutoCompleteContent : unsigned char { accCurrentDir, accMyComputer, accDesktop, accFavorites, accFileSysOnly, accFileSysDirs, accFileSysFiles, accHidden, accRecursive, accSortList };

typedef System::Set<TAutoCompleteContent, TAutoCompleteContent::accCurrentDir, TAutoCompleteContent::accSortList> TAutoCompleteContents;

typedef void __fastcall (__closure *TVirtualAutoCompleteAddItem)(System::TObject* Sender, Mpshellutilities::TNamespace* AutoCompleteItem, bool &Allow, bool &Terminate);

class PASCALIMPLEMENTATION TCustomVirtualShellAutoComplete : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	System::WideString FCurrentDir;
	System::Classes::TStringList* FStrings;
	TAutoCompleteContents FContents;
	TVirtualAutoCompleteAddItem FOnAutoCompleteAddItem;
	Mpshellutilities::TVirtualNameSpaceList* FNamespaces;
	bool FDirty;
	System::Classes::TStringList* __fastcall GetStrings(void);
	void __fastcall ReadCurrentDir(System::Classes::TReader* Reader);
	void __fastcall WriteCurrentDir(System::Classes::TWriter* Writer);
	void __fastcall SetCurrentDir(const System::WideString Value);
	
protected:
	bool __fastcall EnumFolder(HWND MessageWnd, Winapi::Shlobj::PItemIDList APIDL, Mpshellutilities::TNamespace* AParent, void * Data, bool &Terminate);
	void __fastcall FillCurrentDir(void);
	void __fastcall FillMyComputer(void);
	void __fastcall FillDesktop(void);
	void __fastcall FillFavorites(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	void __fastcall DoAddAutoCompleteItem(Mpshellutilities::TNamespace* AutoCompleteItem, bool &Allow, bool &Terminate);
	__property TAutoCompleteContents Contents = {read=FContents, write=FContents, default=99};
	__property System::WideString CurrentDir = {read=FCurrentDir, write=SetCurrentDir};
	__property TVirtualAutoCompleteAddItem OnAutoCompleteAddItem = {read=FOnAutoCompleteAddItem, write=FOnAutoCompleteAddItem};
	__property Mpshellutilities::TVirtualNameSpaceList* Namespaces = {read=FNamespaces, write=FNamespaces};
	__property System::Classes::TStringList* Strings = {read=GetStrings};
	
public:
	__fastcall virtual TCustomVirtualShellAutoComplete(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCustomVirtualShellAutoComplete(void);
	void __fastcall Refresh(void);
	__property bool Dirty = {read=FDirty, write=FDirty, nodefault};
};


class PASCALIMPLEMENTATION TVirtualShellAutoComplete : public TCustomVirtualShellAutoComplete
{
	typedef TCustomVirtualShellAutoComplete inherited;
	
public:
	__property Namespaces;
	__property Strings;
	
__published:
	__property Contents = {default=99};
	__property CurrentDir = {default=0};
	__property OnAutoCompleteAddItem;
public:
	/* TCustomVirtualShellAutoComplete.Create */ inline __fastcall virtual TVirtualShellAutoComplete(System::Classes::TComponent* AOwner) : TCustomVirtualShellAutoComplete(AOwner) { }
	/* TCustomVirtualShellAutoComplete.Destroy */ inline __fastcall virtual ~TVirtualShellAutoComplete(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define AutoCompleteDefault (System::Set<TAutoCompleteContent, TAutoCompleteContent::accCurrentDir, TAutoCompleteContent::accSortList>() << TAutoCompleteContent::accCurrentDir << TAutoCompleteContent::accMyComputer << TAutoCompleteContent::accFileSysDirs << TAutoCompleteContent::accFileSysFiles )
}	/* namespace Virtualshellautocomplete */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALSHELLAUTOCOMPLETE)
using namespace Virtualshellautocomplete;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualshellautocompleteHPP
