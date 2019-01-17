// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualFileSearch.pas' rev: 32.00 (Windows)

#ifndef VirtualfilesearchHPP
#define VirtualfilesearchHPP

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
#include <Vcl.Dialogs.hpp>
#include <Winapi.ActiveX.hpp>
#include <Winapi.ShlObj.hpp>
#include <MPCommonUtilities.hpp>
#include <MPThreadManager.hpp>
#include <MPShellTypes.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <MPShellUtilities.hpp>
#include <VirtualResources.hpp>
#include <MPCommonObjects.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualfilesearch
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TVirtualFileSearchThread;
class DELPHICLASS TVirtualFileSearch;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TVirtualSearchAttrib : unsigned char { vsaArchive, vsaCompressed, vsaEncrypted, vsaHidden, vsaNormal, vsaOffline, vsaReadOnly, vsaSystem, vsaTemporary };

typedef System::Set<TVirtualSearchAttrib, TVirtualSearchAttrib::vsaArchive, TVirtualSearchAttrib::vsaTemporary> TVirtualSearchAttribs;

typedef void __fastcall (__closure *TFileSearchProgressEvent)(System::TObject* Sender, Mpcommonobjects::TCommonPIDLList* Results, bool &Handled, bool &FreePIDLs);

typedef void __fastcall (__closure *TFileSearchFinishedEvent)(System::TObject* Sender, Mpcommonobjects::TCommonPIDLList* Results);

typedef void __fastcall (__closure *TFileSearchCompareEvent)(System::TObject* Sender, const System::WideString FilePath, const _WIN32_FIND_DATAW &FindFileData, bool &UseFile);

class PASCALIMPLEMENTATION TVirtualFileSearchThread : public Mpthreadmanager::TCommonThread
{
	typedef Mpthreadmanager::TCommonThread inherited;
	
private:
	bool FCaseSensitive;
	unsigned FFileMask;
	System::Classes::TStringList* FSearchCriteriaFileName;
	System::Classes::TStringList* FSearchPaths;
	TVirtualFileSearch* FSearchManager;
	Mpcommonobjects::TCommonPIDLList* FSearchResultsLocal;
	bool FTemporary;
	
protected:
	virtual void __fastcall Execute(void);
	void __fastcall ProcessFiles(System::WideString Path, System::Classes::TStringList* Masks, Mpcommonobjects::TCommonPIDLList* PIDLList);
	__property TVirtualFileSearch* SearchManager = {read=FSearchManager, write=FSearchManager};
	__property Mpcommonobjects::TCommonPIDLList* SearchResultsLocal = {read=FSearchResultsLocal, write=FSearchResultsLocal};
	__property bool Temporary = {read=FTemporary, write=FTemporary, nodefault};
	
public:
	__fastcall virtual TVirtualFileSearchThread(bool CreateSuspended);
	__fastcall virtual ~TVirtualFileSearchThread(void);
	void __fastcall BuildFolderList(const System::WideString Path, System::Classes::TStringList* FolderList);
	__property bool CaseSensitive = {read=FCaseSensitive, write=FCaseSensitive, nodefault};
	__property unsigned FileMask = {read=FFileMask, write=FFileMask, nodefault};
	__property System::Classes::TStringList* SearchCriteriaFileName = {read=FSearchCriteriaFileName, write=FSearchCriteriaFileName};
	__property System::Classes::TStringList* SearchPaths = {read=FSearchPaths, write=FSearchPaths};
};


class PASCALIMPLEMENTATION TVirtualFileSearch : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	bool FCaseSensitive;
	TVirtualFileSearchThread* FFileFindThread;
	bool FFinished;
	TFileSearchProgressEvent FOnProgress;
	TFileSearchCompareEvent FOnSearchCompare;
	TFileSearchFinishedEvent FOnSearchEnd;
	TVirtualSearchAttribs FSearchAttribs;
	System::Classes::TStringList* FSearchCriteriaFilename;
	System::Classes::TStringList* FSearchPath;
	Mpcommonobjects::TCommonPIDLList* FSearchResults;
	bool FSubFolders;
	System::Classes::TThreadPriority FThreadPriority;
	Vcl::Extctrls::TTimer* FTimer;
	int FUpdateRate;
	
protected:
	int __fastcall BuildMask(void);
	virtual void __fastcall DoProgress(Mpcommonobjects::TCommonPIDLList* Results, bool &Handled, bool &FreePIDLs);
	void __fastcall DoSearchCompare(const System::WideString FilePath, const _WIN32_FIND_DATAW &FindFileData, bool &UseFile);
	void __fastcall DoSearchEnd(Mpcommonobjects::TCommonPIDLList* Results);
	void __fastcall TimerTick(System::TObject* Sender);
	__property TVirtualFileSearchThread* FileFindThread = {read=FFileFindThread, write=FFileFindThread};
	__property Vcl::Extctrls::TTimer* Timer = {read=FTimer, write=FTimer};
	
public:
	__fastcall virtual TVirtualFileSearch(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TVirtualFileSearch(void);
	virtual bool __fastcall Run(void);
	virtual void __fastcall Stop(void);
	__property bool Finished = {read=FFinished, nodefault};
	__property System::Classes::TStringList* SearchCriteriaFilename = {read=FSearchCriteriaFilename, write=FSearchCriteriaFilename};
	__property System::Classes::TStringList* SearchPaths = {read=FSearchPath, write=FSearchPath};
	__property Mpcommonobjects::TCommonPIDLList* SearchResults = {read=FSearchResults, write=FSearchResults};
	
__published:
	__property bool CaseSensitive = {read=FCaseSensitive, write=FCaseSensitive, default=0};
	__property TFileSearchProgressEvent OnProgress = {read=FOnProgress, write=FOnProgress};
	__property TFileSearchCompareEvent OnSearchCompare = {read=FOnSearchCompare, write=FOnSearchCompare};
	__property TFileSearchFinishedEvent OnSearchEnd = {read=FOnSearchEnd, write=FOnSearchEnd};
	__property TVirtualSearchAttribs SearchAttribs = {read=FSearchAttribs, write=FSearchAttribs, default=511};
	__property bool SubFolders = {read=FSubFolders, write=FSubFolders, default=0};
	__property System::Classes::TThreadPriority ThreadPriority = {read=FThreadPriority, write=FThreadPriority, default=3};
	__property int UpdateRate = {read=FUpdateRate, write=FUpdateRate, default=500};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Virtualfilesearch */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALFILESEARCH)
using namespace Virtualfilesearch;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualfilesearchHPP
