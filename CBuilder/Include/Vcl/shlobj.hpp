// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ShlObj.pas' rev: 6.00

#ifndef ShlObjHPP
#define ShlObjHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <UrlMon.hpp>	// Pascal unit
#include <WinInet.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <RegStr.hpp>	// Pascal unit
#include <ShellAPI.hpp>	// Pascal unit
#include <CommCtrl.hpp>	// Pascal unit
#include <ActiveX.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
// If problems occur when compiling win32 structs, records, or
// unions, please define NO_WIN32_LEAN_AND_MEAN to force inclusion
// of Windows header files.
#if defined(NO_WIN32_LEAN_AND_MEAN)
#include <ole2.h>
#include <prsht.h>
#include <commctrl.h>   // for LPTBBUTTON
#include <shlguid.h>
#include <shlobj.h>
#endif
#if !defined(NO_WIN32_LEAN_AND_MEAN)
interface DECLSPEC_UUID("0000010f-0000-0000-C000-000000000046") IAdviseSink;
interface DECLSPEC_UUID("000214e2-0000-0000-c000-000000000046") IShellBrowser;
interface DECLSPEC_UUID("000214e3-0000-0000-c000-000000000046") IShellView;
interface DECLSPEC_UUID("000214e4-0000-0000-c000-000000000046") IContextMenu;
interface DECLSPEC_UUID("000214e5-0000-0000-c000-000000000046") IShellIcon;
interface DECLSPEC_UUID("000214e6-0000-0000-c000-000000000046") IShellFolder;
interface DECLSPEC_UUID("93F2F68C-1D1B-11d3-A30E-00C04F79ABD1") IShellFolder2;
interface DECLSPEC_UUID("000214e8-0000-0000-c000-000000000046") IShellExtInit;
interface DECLSPEC_UUID("000214e9-0000-0000-c000-000000000046") IShellPropSheetExt;
interface DECLSPEC_UUID("000214ea-0000-0000-c000-000000000046") IPersistFolder;
interface DECLSPEC_UUID("000214f1-0000-0000-c000-000000000046") ICommDlgBrowser;
interface DECLSPEC_UUID("000214f2-0000-0000-c000-000000000046") IEnumIDList;
interface DECLSPEC_UUID("000214f3-0000-0000-c000-000000000046") IFileViewerSite;
interface DECLSPEC_UUID("000214f4-0000-0000-c000-000000000046") IContextMenu2;
interface DECLSPEC_UUID("88e39e80-3578-11cf-ae69-08002b2e1262") IShellView2;
interface DECLSPEC_UUID("000214e1-0000-0000-c000-000000000046") INewShortcutHookA;
interface DECLSPEC_UUID("000214f7-0000-0000-c000-000000000046") INewShortcutHookW;
interface DECLSPEC_UUID("000214f0-0000-0000-c000-000000000046") IFileViewerA;
interface DECLSPEC_UUID("000214f8-0000-0000-c000-000000000046") IFileViewerW;
interface DECLSPEC_UUID("000214ee-0000-0000-c000-000000000046") IShellLinkA;
interface DECLSPEC_UUID("000214f9-0000-0000-c000-000000000046") IShellLinkW;
interface DECLSPEC_UUID("000214eb-0000-0000-c000-000000000046") IExtractIconA;
interface DECLSPEC_UUID("000214fa-0000-0000-c000-000000000046") IExtractIconW;
interface DECLSPEC_UUID("000214f5-0000-0000-c000-000000000046") IShellExecuteHookA;
interface DECLSPEC_UUID("000214fb-0000-0000-c000-000000000046") IShellExecuteHookW;
interface DECLSPEC_UUID("000214EF-0000-0000-c000-000000000046") ICopyHookA;
interface DECLSPEC_UUID("000214FC-0000-0000-c000-000000000046") ICopyHookW;
#endif
typedef System::DelphiInterface<IAdviseSink> _di_IAdviseSink;
typedef System::DelphiInterface<IShellBrowser> _di_IShellBrowser;
typedef System::DelphiInterface<IShellView> _di_IShellView;
typedef System::DelphiInterface<IContextMenu> _di_IContextMenu;
typedef System::DelphiInterface<IShellIcon> _di_IShellIcon;
typedef System::DelphiInterface<IShellFolder> _di_IShellFolder;
typedef System::DelphiInterface<IShellFolder2> _di_IShellFolder2;
typedef System::DelphiInterface<IShellExtInit> _di_IShellExtInit;
typedef System::DelphiInterface<IShellPropSheetExt> _di_IShellPropSheetExt;
typedef System::DelphiInterface<IPersistFolder> _di_IPersistFolder;
typedef System::DelphiInterface<ICommDlgBrowser> _di_ICommDlgBrowser;
typedef System::DelphiInterface<IEnumIDList> _di_IEnumIDList;
typedef System::DelphiInterface<IFileViewerSite> _di_IFileViewerSite;
typedef System::DelphiInterface<IContextMenu2> _di_IContextMenu2;
typedef System::DelphiInterface<IShellView2> _di_IShellView2;
typedef System::DelphiInterface<INewShortcutHookA> _di_INewShortcutHookA;
typedef System::DelphiInterface<INewShortcutHookW> _di_INewShortcutHookW;
typedef System::DelphiInterface<IFileViewerA> _di_IFileViewerA;
typedef System::DelphiInterface<IFileViewerW> _di_IFileViewerW;
typedef System::DelphiInterface<IShellLinkA> _di_IShellLinkA;
typedef System::DelphiInterface<IShellLinkW> _di_IShellLinkW;
typedef System::DelphiInterface<IExtractIconA> _di_IExtractIconA;
typedef System::DelphiInterface<IExtractIconW> _di_IExtractIconW;
typedef System::DelphiInterface<IShellExecuteHookA> _di_IShellExecuteHookA;
typedef System::DelphiInterface<IShellExecuteHookW> _di_IShellExecuteHookW;
typedef System::DelphiInterface<ICopyHookA> _di_ICopyHookA;
typedef System::DelphiInterface<ICopyHookW> _di_ICopyHookW;
#ifdef UNICODE
typedef _di_INewShortcutHookW _di_INewShortcutHook;
typedef _di_IFileViewerW _di_IFileViewer;
typedef _di_IShellLinkW _di_IShellLink;
typedef _di_IExtractIconW _di_IExtractIcon;
typedef _di_IShellExecuteHookW _di_IShellExecuteHook;
typedef _di_ICopyHookW _di_ICopyHook;
#else
typedef _di_INewShortcutHookA _di_INewShortcutHook;
typedef _di_IFileViewerA _di_IFileViewer;
typedef _di_IShellLinkA _di_IShellLink;
typedef _di_IExtractIconA _di_IExtractIcon;
typedef _di_IShellExecuteHookA _di_IShellExecuteHook;
typedef _di_ICopyHookA _di_ICopyHook;
#endif
#if !defined(NO_WIN32_LEAN_AND_MEAN)
struct _SHITEMID;
struct _ITEMIDLIST;
struct _CMINVOKECOMMANDINFO;
struct _CMInvokeCommandInfoEx;
struct FVSHOWINFO;
struct FOLDERSETTINGS;
struct _SV2CVW2_PARAMS;
struct _STRRET;
struct _SHELLDETAILS;
struct DESKBANDINFO;
struct _NRESARRAY;
struct _IDA;
struct _FILEDESCRIPTORA;
struct _FILEDESCRIPTORW;
struct _FILEGROUPDESCRIPTORW;
struct _FILEGROUPDESCRIPTORA;
struct _DROPFILES;
struct _SHDESCRIPTIONID;
struct SHELLFLAGSTATE;
struct _browseinfoA;
struct _browseinfoW;
#endif

namespace Shlobj
{
//-- type declarations -------------------------------------------------------
typedef _SHITEMID *PSHItemID;

typedef _SHITEMID  TSHItemID;

typedef _ITEMIDLIST *PItemIDList;

typedef _ITEMIDLIST  TItemIDList;

typedef _CMINVOKECOMMANDINFO *PCMInvokeCommandInfo;

typedef _CMINVOKECOMMANDINFO  TCMInvokeCommandInfo;

typedef _CMInvokeCommandInfoEx *PCMInvokeCommandInfoEx;

typedef _CMInvokeCommandInfoEx  TCMInvokeCommandInfoEx;

typedef FVSHOWINFO *PFVShowInfo;

typedef FVSHOWINFO  TFVShowInfo;

typedef FOLDERSETTINGS *PFolderSettings;

typedef FOLDERSETTINGS  TFolderSettings;

typedef GUID  TShellViewID;

typedef GUID *PShellViewID;

typedef _SV2CVW2_PARAMS *PSV2CreateParams;

typedef _SV2CVW2_PARAMS  TSV2CreateParams;

typedef _STRRET *PSTRRet;

typedef _STRRET  TStrRet;

typedef _SHELLDETAILS *PShellDetails;

typedef _SHELLDETAILS  TShellDetails;

__interface IShellDetails;
typedef System::DelphiInterface<IShellDetails> _di_IShellDetails;
__interface INTERFACE_UUID("{000214EC-0000-0000-C000-000000000046}") IShellDetails  : public IInterface
{
	
public:
	virtual HRESULT __stdcall GetDetailsOf(PItemIDList pidl, unsigned iColumn, _SHELLDETAILS &pDetails) = 0 ;
	virtual HRESULT __stdcall ColumnClick(unsigned iColumn) = 0 ;
};

typedef int __stdcall (*TFNBFFCallBack)(HWND Wnd, unsigned uMsg, int lParam, int lpData);

typedef _browseinfoA *PBrowseInfoA;

typedef _browseinfoW *PBrowseInfoW;

typedef _browseinfoA *PBrowseInfo;

typedef _browseinfoA  TBrowseInfoA;

typedef _browseinfoW  TBrowseInfoW;

typedef _browseinfoA  TBrowseInfo;

typedef DESKBANDINFO *PDeskBandInfo;

typedef DESKBANDINFO  TDeskBandInfo;

typedef _NRESARRAY *PNResArray;

typedef _NRESARRAY  TNResArray;

typedef _IDA *PIDA;

typedef _IDA  TIDA;

typedef _FILEDESCRIPTORA *PFileDescriptorA;

typedef _FILEDESCRIPTORW *PFileDescriptorW;

typedef _FILEDESCRIPTORA *PFileDescriptor;

typedef _FILEDESCRIPTORA  TFileDescriptorA;

typedef _FILEDESCRIPTORW  TFileDescriptorW;

typedef _FILEDESCRIPTORA  TFileDescriptor;

typedef _FILEGROUPDESCRIPTORA *PFileGroupDescriptorA;

typedef _FILEGROUPDESCRIPTORW *PFileGroupDescriptorW;

typedef _FILEGROUPDESCRIPTORA *PFileGroupDescriptor;

typedef _FILEGROUPDESCRIPTORA  TFileGroupDescriptorA;

typedef _FILEGROUPDESCRIPTORW  TFileGroupDescriptorW;

typedef _FILEGROUPDESCRIPTORA  TFileGroupDescriptor;

typedef _DROPFILES *PDropFiles;

typedef _DROPFILES  TDropFiles;

typedef _SHDESCRIPTIONID *PSHDescriptionID;

typedef _SHDESCRIPTIONID  TSHDescriptionID;

typedef SHELLFLAGSTATE *PShellFlagState;

typedef SHELLFLAGSTATE  TShellFlagState;

//-- var, const, procedure ---------------------------------------------------
extern PACKAGE GUID CLSID_ActiveDesktop;
#define SID_INewShortcutHookA "{000214E1-0000-0000-C000-000000000046}"
#define SID_IShellBrowser "{000214E2-0000-0000-C000-000000000046}"
#define SID_IShellView "{000214E3-0000-0000-C000-000000000046}"
#define SID_IContextMenu "{000214E4-0000-0000-C000-000000000046}"
#define SID_IShellIcon "{000214E5-0000-0000-C000-000000000046}"
#define SID_IShellFolder "{000214E6-0000-0000-C000-000000000046}"
#define SID_IShellExtInit "{000214E8-0000-0000-C000-000000000046}"
#define SID_IShellPropSheetExt "{000214E9-0000-0000-C000-000000000046}"
#define SID_IPersistFolder "{000214EA-0000-0000-C000-000000000046}"
#define SID_IExtractIconA "{000214EB-0000-0000-C000-000000000046}"
#define SID_IShellLinkA "{000214EE-0000-0000-C000-000000000046}"
#define SID_IShellCopyHookA "{000214EF-0000-0000-C000-000000000046}"
#define SID_IFileViewerA "{000214F0-0000-0000-C000-000000000046}"
#define SID_ICommDlgBrowser "{000214F1-0000-0000-C000-000000000046}"
#define SID_IEnumIDList "{000214F2-0000-0000-C000-000000000046}"
#define SID_IFileViewerSite "{000214F3-0000-0000-C000-000000000046}"
#define SID_IContextMenu2 "{000214F4-0000-0000-C000-000000000046}"
#define SID_IShellExecuteHookA "{000214F5-0000-0000-C000-000000000046}"
#define SID_IPropSheetPage "{000214F6-0000-0000-C000-000000000046}"
#define SID_INewShortcutHookW "{000214F7-0000-0000-C000-000000000046}"
#define SID_IFileViewerW "{000214F8-0000-0000-C000-000000000046}"
#define SID_IShellLinkW "{000214F9-0000-0000-C000-000000000046}"
#define SID_IExtractIconW "{000214FA-0000-0000-C000-000000000046}"
#define SID_IShellExecuteHookW "{000214FB-0000-0000-C000-000000000046}"
#define SID_IShellCopyHookW "{000214FC-0000-0000-C000-000000000046}"
#define SID_IShellView2 "{88E39E80-3578-11CF-AE69-08002B2E1262}"
#define SID_IContextMenu3 "{BCFCE0A0-EC17-11d0-8D10-00A0C90F2719}"
#define SID_IPersistFolder2 "{1AC3D9F0-175C-11d1-95BE-00609797EA4F}"
#define SID_IShellIconOverlayIdentifier "{0C6C4200-C589-11D0-999A-00C04FD655E1}"
#define SID_IShellIconOverlay "{7D688A70-C613-11D0-999B-00C04FD655E1}"
#define SID_IURLSearchHook "{AC60F6A0-0FD9-11D0-99CB-00C04FD64497}"
#define SID_IInputObjectSite "{f1db8392-7331-11d0-8c99-00a0c92dbfe8}"
#define SID_IInputObject "{68284faa-6a48-11d0-8c78-00c04fd918b4}"
#define SID_IDockingWindowSite "{2a342fc2-7b26-11d0-8ca9-00a0c92dbfe8}"
#define SID_IDockingWindowFrame "{47d2657a-7b27-11d0-8ca9-00a0c92dbfe8}"
#define SID_IDockingWindow "{012dd920-7b26-11d0-8ca9-00a0c92dbfe8}"
#define SID_IDeskBand "{EB0FE172-1A3A-11D0-89B3-00A0C90A90AC}"
#define SID_IActiveDesktop "{F490EB00-1240-11D1-9888-006097DEACF9}"
#define SID_IShellChangeNotify "{00000000-0000-0000-0000-000000000000}"
#define SID_IQueryInfo "{00021500-0000-0000-C000-000000000046}"
#define SID_IShellDetails "{000214EC-0000-0000-C000-000000000046}"
#define SID_IShellFolder2 "{B82C5AA8-A41B-11D2-BE32-00C04FB93661}"
#define SID_IEnumExtraSearch "{0E700BE1-9DB6-11D1-A1CE-00C04FD75D13}"
static const Shortint SHCOLSTATE_TYPE_STR = 0x1;
static const Shortint SHCOLSTATE_TYPE_INT = 0x2;
static const Shortint SHCOLSTATE_TYPE_DATE = 0x3;
static const Shortint SHCOLSTATE_TYPEMASK = 0xf;
static const Shortint SHCOLSTATE_ONBYDEFAULT = 0x10;
static const Shortint SHCOLSTATE_SLOW = 0x20;
static const Shortint SHCOLSTATE_EXTENDED = 0x40;
static const Byte SHCOLSTATE_SECONDARYUI = 0x80;
static const Word SHCOLSTATE_HIDDEN = 0x100;
static const int SHCNE_EXTENDED_EVENT_PRE_IE4 = 0x80000;

}	/* namespace Shlobj */
using namespace Shlobj;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ShlObj
