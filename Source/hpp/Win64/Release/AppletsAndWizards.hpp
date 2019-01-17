// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AppletsAndWizards.pas' rev: 32.00 (Windows)

#ifndef AppletsandwizardsHPP
#define AppletsandwizardsHPP

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
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Winapi.ShlObj.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <MPShellUtilities.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Appletsandwizards
{
//-- forward type declarations -----------------------------------------------
struct TNM_RunFileDlgA;
struct TNM_RunFileDlgW;
class DELPHICLASS TAppletsAndWizards;
class DELPHICLASS TVirtualRunFileDialog;
//-- type declarations -------------------------------------------------------
typedef TNM_RunFileDlgA *PRunFileDlgA;

struct DECLSPEC_DRECORD TNM_RunFileDlgA
{
public:
	tagNMHDR Hdr;
	char *lpFile;
	char *lpDirectory;
	System::LongBool nShow;
};


typedef TNM_RunFileDlgW *PRunFileDlgW;

struct DECLSPEC_DRECORD TNM_RunFileDlgW
{
public:
	tagNMHDR Hdr;
	System::WideChar *lpFile;
	System::WideChar *lpDirectory;
	System::LongBool nShow;
};


enum DECLSPEC_DENUM TCmdShow : unsigned char { swHide, swMaximize, swMinimize, swRestore, swShow, swShowDefault, swShowMinimized, swShowMinNoActive, swShowNA, swShowNoActive, swShowNormal };

enum DECLSPEC_DENUM TControlPanel : unsigned char { ciControlPanel, ciMouse, ciKeyboard, ciJoyStick, ciFastFind, ciSound, ciNetworkConfig, ciODBCAdmin, ciChangePassword, ciComPorts, ciServerProperties, ciAddNewHardware, ciAddNewPrinter, ciThemeProperties, ciUPS_PowerOptions, ciTweakUI };

enum DECLSPEC_DENUM TShareWizard : unsigned char { swCreate, swManage };

enum DECLSPEC_DENUM TMicrosoftApp : unsigned char { maOutlookExchangeProp, maMailPostOffice };

enum DECLSPEC_DENUM TMiscApplets : unsigned char { maOpenWith, maDiskCopy, msViewFonts, msViewPrinters, msDialupWizard };

enum DECLSPEC_DENUM TModemSettings : unsigned char { msModemOptions, msDialingProperties };

enum DECLSPEC_DENUM TSystemDialogs : unsigned char { sdFormatDrives };

enum DECLSPEC_DENUM TSHFormatDriveCode : unsigned char { fdNoError, fdNotFormatable, fdCancel, fdError };

enum DECLSPEC_DENUM TVirtualRunFileDialogOption : unsigned char { roNoBrowse, roNoDefault, roCalDirectory, roNoLabel, roNoSeparateMem };

typedef System::Set<TVirtualRunFileDialogOption, TVirtualRunFileDialogOption::roNoBrowse, TVirtualRunFileDialogOption::roNoSeparateMem> TVirtualRunFileDialogOptions;

enum DECLSPEC_DENUM TRunFileResult : unsigned char { frOk, frCancel, frRetry };

class PASCALIMPLEMENTATION TAppletsAndWizards : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TCmdShow FCmdShow;
	bool FShowErrorCodes;
	
protected:
	bool __fastcall Launch(System::AnsiString S)/* overload */;
	bool __fastcall Launch(const System::UnicodeString S)/* overload */;
	unsigned __fastcall DecodeCmdShow(TCmdShow ACmdShow);
	TCmdShow __fastcall EncodeCmdShow(unsigned SW_CODE);
	bool __fastcall SelectPage(System::UnicodeString Command, int Page);
	
public:
	__fastcall TAppletsAndWizards(void);
	bool __fastcall AccessabilityDialog(int Page);
	bool __fastcall AddRemoveProgramsDialog(int Page);
	bool __fastcall ControlPanel(TControlPanel Item);
	bool __fastcall CreateNewShortcut(System::WideString Path);
	bool __fastcall DisplayPropertiesDialog(int Page);
	bool __fastcall SHFindComputer(void);
	bool __fastcall SHFindFiles(Mpshellutilities::TNamespace* Root, Mpshellutilities::TNamespace* FilterSample);
	TSHFormatDriveCode __fastcall SHFormatDrive(System::WideChar DriveLetter);
	bool __fastcall SHPickIconDialog(System::WideString &FileName, unsigned &IconIndex);
	void __fastcall SHRunFileDialog(HWND Window, HICON Icon, System::WideString WorkingPath, System::WideString Caption, System::WideString Description, TVirtualRunFileDialogOptions Options);
	bool __fastcall InstallScreenSaver(System::UnicodeString ScreenSaver);
	bool __fastcall InternetSettingsDialog(int Page);
	bool __fastcall MicrosoftApps(TMicrosoftApp App);
	bool __fastcall MiscApplets(TMiscApplets Applet);
	bool __fastcall ModemSettingsDialog(TModemSettings Page);
	bool __fastcall MultimediaSettingsDialog(int Page);
	bool __fastcall NetworkShare(TShareWizard Wizard);
	bool __fastcall RegionalSettingsDialog(int Page);
	bool __fastcall SystemSettingsDialog(int Page);
	bool __fastcall TimeDateDialog(int Page);
	__property TCmdShow CmdShow = {read=FCmdShow, write=FCmdShow, nodefault};
	__property bool ShowErrorCodes = {read=FShowErrorCodes, write=FShowErrorCodes, nodefault};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TAppletsAndWizards(void) { }
	
};


typedef void __fastcall (__closure *TOnRunFile)(System::UnicodeString RunFile, System::UnicodeString WorkingDirectory, TRunFileResult &Result);

class PASCALIMPLEMENTATION TVirtualRunFileDialog : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	TVirtualRunFileDialogOptions FOptions;
	System::UnicodeString FDescription;
	System::UnicodeString FCaption;
	System::UnicodeString FWorkingPath;
	Vcl::Graphics::TIcon* FIcon;
	System::UnicodeString FFileToRun;
	HWND FHiddenWnd;
	TOnRunFile FOnRunFile;
	System::Types::TPoint FPosition;
	void __fastcall SetIcon(Vcl::Graphics::TIcon* const Value);
	
protected:
	void __fastcall DoRunFile(System::UnicodeString RunFile, System::UnicodeString WorkingDirectory, TRunFileResult &Result);
	
public:
	__fastcall virtual TVirtualRunFileDialog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TVirtualRunFileDialog(void);
	void __fastcall Run(void);
	void __fastcall WindowProc(Winapi::Messages::TMessage &Message);
	__property HWND HiddenWnd = {read=FHiddenWnd, write=FHiddenWnd};
	
__published:
	__property System::UnicodeString Caption = {read=FCaption, write=FCaption};
	__property System::UnicodeString Description = {read=FDescription, write=FDescription};
	__property System::UnicodeString FileToRun = {read=FFileToRun, write=FFileToRun};
	__property Vcl::Graphics::TIcon* Icon = {read=FIcon, write=SetIcon};
	__property TOnRunFile OnRunFile = {read=FOnRunFile, write=FOnRunFile};
	__property TVirtualRunFileDialogOptions Options = {read=FOptions, write=FOptions, nodefault};
	
public:
	__property System::Types::TPoint Position = {read=FPosition, write=FPosition};
	
__published:
	__property System::UnicodeString WorkingPath = {read=FWorkingPath, write=FWorkingPath};
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::ResourceString _S_CONTROLPANEL;
#define Appletsandwizards_S_CONTROLPANEL System::LoadResourceString(&Appletsandwizards::_S_CONTROLPANEL)
extern DELPHI_PACKAGE System::ResourceString _S_ACCESSABILITY;
#define Appletsandwizards_S_ACCESSABILITY System::LoadResourceString(&Appletsandwizards::_S_ACCESSABILITY)
extern DELPHI_PACKAGE System::ResourceString _S_ADDREMOVEPROGRAM;
#define Appletsandwizards_S_ADDREMOVEPROGRAM System::LoadResourceString(&Appletsandwizards::_S_ADDREMOVEPROGRAM)
extern DELPHI_PACKAGE System::ResourceString _S_DISPLAYSETTINGS;
#define Appletsandwizards_S_DISPLAYSETTINGS System::LoadResourceString(&Appletsandwizards::_S_DISPLAYSETTINGS)
extern DELPHI_PACKAGE System::ResourceString _S_INTERNETCONNECTION;
#define Appletsandwizards_S_INTERNETCONNECTION System::LoadResourceString(&Appletsandwizards::_S_INTERNETCONNECTION)
extern DELPHI_PACKAGE System::ResourceString _S_MULITMEDIA;
#define Appletsandwizards_S_MULITMEDIA System::LoadResourceString(&Appletsandwizards::_S_MULITMEDIA)
extern DELPHI_PACKAGE System::ResourceString _S_REGIONALSETTINGS;
#define Appletsandwizards_S_REGIONALSETTINGS System::LoadResourceString(&Appletsandwizards::_S_REGIONALSETTINGS)
extern DELPHI_PACKAGE System::ResourceString _S_SYSTEMSETTINGS;
#define Appletsandwizards_S_SYSTEMSETTINGS System::LoadResourceString(&Appletsandwizards::_S_SYSTEMSETTINGS)
extern DELPHI_PACKAGE System::ResourceString _S_TIMEDATE;
#define Appletsandwizards_S_TIMEDATE System::LoadResourceString(&Appletsandwizards::_S_TIMEDATE)
extern DELPHI_PACKAGE System::ResourceString _S_MODEM;
#define Appletsandwizards_S_MODEM System::LoadResourceString(&Appletsandwizards::_S_MODEM)
extern DELPHI_PACKAGE System::ResourceString _S_DIALINGPROPERTIES;
#define Appletsandwizards_S_DIALINGPROPERTIES System::LoadResourceString(&Appletsandwizards::_S_DIALINGPROPERTIES)
extern DELPHI_PACKAGE System::ResourceString _S_CONTROLPANELITEM;
#define Appletsandwizards_S_CONTROLPANELITEM System::LoadResourceString(&Appletsandwizards::_S_CONTROLPANELITEM)
extern DELPHI_PACKAGE System::ResourceString _S_FASTFIND;
#define Appletsandwizards_S_FASTFIND System::LoadResourceString(&Appletsandwizards::_S_FASTFIND)
extern DELPHI_PACKAGE System::ResourceString _S_JOYSTICK;
#define Appletsandwizards_S_JOYSTICK System::LoadResourceString(&Appletsandwizards::_S_JOYSTICK)
extern DELPHI_PACKAGE System::ResourceString _S_SOUND;
#define Appletsandwizards_S_SOUND System::LoadResourceString(&Appletsandwizards::_S_SOUND)
extern DELPHI_PACKAGE System::ResourceString _S_EXCHANGEOUTLOOKPROPERTIES;
#define Appletsandwizards_S_EXCHANGEOUTLOOKPROPERTIES System::LoadResourceString(&Appletsandwizards::_S_EXCHANGEOUTLOOKPROPERTIES)
extern DELPHI_PACKAGE System::ResourceString _S_MAILPOSTOFFICE;
#define Appletsandwizards_S_MAILPOSTOFFICE System::LoadResourceString(&Appletsandwizards::_S_MAILPOSTOFFICE)
extern DELPHI_PACKAGE System::ResourceString _S_NETWORKCONFIG_NT;
#define Appletsandwizards_S_NETWORKCONFIG_NT System::LoadResourceString(&Appletsandwizards::_S_NETWORKCONFIG_NT)
extern DELPHI_PACKAGE System::ResourceString _S_NETWORKCONFIG_9X;
#define Appletsandwizards_S_NETWORKCONFIG_9X System::LoadResourceString(&Appletsandwizards::_S_NETWORKCONFIG_9X)
extern DELPHI_PACKAGE System::ResourceString _S_NETWORKSHARE;
#define Appletsandwizards_S_NETWORKSHARE System::LoadResourceString(&Appletsandwizards::_S_NETWORKSHARE)
extern DELPHI_PACKAGE System::ResourceString _S_ODBCADMINISTRATOR;
#define Appletsandwizards_S_ODBCADMINISTRATOR System::LoadResourceString(&Appletsandwizards::_S_ODBCADMINISTRATOR)
extern DELPHI_PACKAGE System::ResourceString _S_CHANGEPASSWORD;
#define Appletsandwizards_S_CHANGEPASSWORD System::LoadResourceString(&Appletsandwizards::_S_CHANGEPASSWORD)
extern DELPHI_PACKAGE System::ResourceString _S_COMPORTS;
#define Appletsandwizards_S_COMPORTS System::LoadResourceString(&Appletsandwizards::_S_COMPORTS)
extern DELPHI_PACKAGE System::ResourceString _S_SERVERPROPERTIES;
#define Appletsandwizards_S_SERVERPROPERTIES System::LoadResourceString(&Appletsandwizards::_S_SERVERPROPERTIES)
extern DELPHI_PACKAGE System::ResourceString _S_ADDNEWHARDWARE;
#define Appletsandwizards_S_ADDNEWHARDWARE System::LoadResourceString(&Appletsandwizards::_S_ADDNEWHARDWARE)
extern DELPHI_PACKAGE System::ResourceString _S_THEMEPROPERTIES;
#define Appletsandwizards_S_THEMEPROPERTIES System::LoadResourceString(&Appletsandwizards::_S_THEMEPROPERTIES)
extern DELPHI_PACKAGE System::ResourceString _S_UPS_POWEROPTIONS;
#define Appletsandwizards_S_UPS_POWEROPTIONS System::LoadResourceString(&Appletsandwizards::_S_UPS_POWEROPTIONS)
extern DELPHI_PACKAGE System::ResourceString _S_TWEAKUI;
#define Appletsandwizards_S_TWEAKUI System::LoadResourceString(&Appletsandwizards::_S_TWEAKUI)
extern DELPHI_PACKAGE System::ResourceString _S_ADDNEWPRINTER;
#define Appletsandwizards_S_ADDNEWPRINTER System::LoadResourceString(&Appletsandwizards::_S_ADDNEWPRINTER)
extern DELPHI_PACKAGE System::ResourceString _S_DISPLAYINSTALLSCREENSAVER;
#define Appletsandwizards_S_DISPLAYINSTALLSCREENSAVER System::LoadResourceString(&Appletsandwizards::_S_DISPLAYINSTALLSCREENSAVER)
extern DELPHI_PACKAGE System::ResourceString _S_DIALUPWIZARD;
#define Appletsandwizards_S_DIALUPWIZARD System::LoadResourceString(&Appletsandwizards::_S_DIALUPWIZARD)
extern DELPHI_PACKAGE System::ResourceString _S_OPENWITH;
#define Appletsandwizards_S_OPENWITH System::LoadResourceString(&Appletsandwizards::_S_OPENWITH)
extern DELPHI_PACKAGE System::ResourceString _S_DISKCOPY;
#define Appletsandwizards_S_DISKCOPY System::LoadResourceString(&Appletsandwizards::_S_DISKCOPY)
extern DELPHI_PACKAGE System::ResourceString _S_VIEWFONTS;
#define Appletsandwizards_S_VIEWFONTS System::LoadResourceString(&Appletsandwizards::_S_VIEWFONTS)
extern DELPHI_PACKAGE System::ResourceString _S_VIEWPRINTERS;
#define Appletsandwizards_S_VIEWPRINTERS System::LoadResourceString(&Appletsandwizards::_S_VIEWPRINTERS)
extern DELPHI_PACKAGE System::ResourceString _S_CREATESHORTCUT;
#define Appletsandwizards_S_CREATESHORTCUT System::LoadResourceString(&Appletsandwizards::_S_CREATESHORTCUT)
extern DELPHI_PACKAGE TAppletsAndWizards* Applets;
}	/* namespace Appletsandwizards */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_APPLETSANDWIZARDS)
using namespace Appletsandwizards;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AppletsandwizardsHPP
