// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualResources.pas' rev: 30.00 (Windows)

#ifndef VirtualresourcesHPP
#define VirtualresourcesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <VirtualTrees.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.Classes.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualresources
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef Vcl::Stdctrls::TCustomEdit TVirtualCustomEdit;

typedef Vcl::Menus::TPopupMenu TVirtualPopupMenu;

typedef Vcl::Menus::TMenuItem TVirtualMenuItem;

typedef System::Classes::TFileStream TVirtualFileStream;

typedef Vcl::Forms::TScrollBox TVirtualScrollBox;

typedef System::StaticArray<System::WideString, 20> Virtualresources__1;

//-- var, const, procedure ---------------------------------------------------
static const System::Word WM_VETBASE = System::Word(0x8033);
static const System::Word WM_SHELLNOTIFY = System::Word(0x8033);
static const System::Word WM_VTSETICONINDEX = System::Word(0x8034);
static const System::Word WM_INVALIDFILENAME = System::Word(0x8035);
static const System::Word WM_SHELLNOTIFYTHREADQUIT = System::Word(0x8036);
static const System::Word WM_CHANGENOTIFY_NT = System::Word(0x8037);
static const System::Word WM_CHANGENOTIFY = System::Word(0x8038);
static const System::Word WM_SHELLNOTIFYTHREADEVENT = System::Word(0x8039);
static const System::Word WM_SHELLNOTIFYRELEASE = System::Word(0x803a);
static const System::Word WM_REMOVEBUTTON = System::Word(0x803b);
static const System::Word WM_CHANGENOTIFY_CUSTOM = System::Word(0x803c);
static const System::Word WM_UPDATESCROLLBAR = System::Word(0x803d);
static const System::Word WM_VTSETTHREADMARK = System::Word(0x803e);
extern DELPHI_PACKAGE System::WideString S_WARNING;
extern DELPHI_PACKAGE System::WideString S_OPEN;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDHOUR;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDTODAY;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDTHISWEEK;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDTWOWEEKS;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDTHREEWEEKS;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDMONTH;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDTWOMONTHS;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDTHREEMONTHS;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDFOURMONTHS;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDFIVEMONTHS;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDSIXMONTHS;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDEARLIERTHISYEAR;
extern DELPHI_PACKAGE System::WideString STR_GROUPMODIFIEDLONGTIMEAGO;
extern DELPHI_PACKAGE System::WideString STR_GROUPSIZEZERO;
extern DELPHI_PACKAGE System::WideString STR_GROUPSIZETINY;
extern DELPHI_PACKAGE System::WideString STR_GROUPSIZESMALL;
extern DELPHI_PACKAGE System::WideString STR_GROUPSIZEMEDIUM;
extern DELPHI_PACKAGE System::WideString STR_GROUPSIZELARGE;
extern DELPHI_PACKAGE System::WideString STR_GROUPSIZEGIGANTIC;
extern DELPHI_PACKAGE System::WideString STR_GROUPSIZESYSFOLDER;
extern DELPHI_PACKAGE System::WideString STR_GROUPSIZEFOLDER;
extern DELPHI_PACKAGE System::WideString STR_HEADERMENUMORE;
extern DELPHI_PACKAGE System::WideString STR_COLUMNDLG_CAPTION;
extern DELPHI_PACKAGE System::WideString STR_COLUMNDLG_LABEL1;
extern DELPHI_PACKAGE System::WideString STR_COLUMNDLG_LABEL2;
extern DELPHI_PACKAGE System::WideString STR_COLUMNDLG_LABEL3;
extern DELPHI_PACKAGE System::WideString STR_COLUMNDLG_CHECKBOXLIVEUPDATE;
extern DELPHI_PACKAGE System::WideString STR_COLUMNDLG_BUTTONOK;
extern DELPHI_PACKAGE System::WideString STR_COLUMNDLG_BUTTONCANCEL;
extern DELPHI_PACKAGE Virtualtrees::TCheckImageKind COLUMNDLG_CHKSTYLE;
extern DELPHI_PACKAGE System::WideString STR_ERR_INVALID_CUSTOMPATH;
extern DELPHI_PACKAGE System::WideString STR_COLUMNMENU_MORE;
extern DELPHI_PACKAGE System::WideString S_PATH_ERROR;
extern DELPHI_PACKAGE System::WideString S_COMBOEDIT_DEFAULT_ERROR1;
extern DELPHI_PACKAGE System::WideString S_NEW;
extern DELPHI_PACKAGE System::WideString S_FOLDER;
extern DELPHI_PACKAGE System::WideString S_SHORTCUT;
extern DELPHI_PACKAGE System::WideString S_OVERWRITE_EXISTING_FILE;
#define S_RUNDLL32 L"\\rundll32.exe"
#define S_BRIEFCASE_HACK_STRING L"syncui.dll,Briefcase_Create 1!d! "
#define S_BRIEFCASE_IDENTIFIER L",Briefcase_Create"
#define S_CREATELINK_IDENTIFIER L",NewLinkHere"
#define S_NULLFILE L"NullFile"
#define S_FILENAME L"FileName"
#define S_COMMAND L"Command"
#define S_DATA L"Data"
#define S_SHELLNEW_PATH L"\\ShellNew"
extern DELPHI_PACKAGE Virtualresources__1 VET_NOTIFY_EVENTS;
extern DELPHI_PACKAGE System::WideString STR_UNKNOWNCOMMAN;
extern DELPHI_PACKAGE System::WideString STR_DRIVELETTER_A;
extern DELPHI_PACKAGE System::WideString S_PRINT;
extern DELPHI_PACKAGE System::WideString S_PROPERTIES;
extern DELPHI_PACKAGE System::WideString S_KERNELNOTIFERREGISTERED;
extern DELPHI_PACKAGE System::WideString S_SHELLNOTIFERREGISTERED;
extern DELPHI_PACKAGE System::WideString S_SHELLNOTIFERDISPATCHTHREAD;
extern DELPHI_PACKAGE System::WideString S_KERNELSPECIALFOLDERWATCH;
}	/* namespace Virtualresources */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALRESOURCES)
using namespace Virtualresources;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualresourcesHPP
