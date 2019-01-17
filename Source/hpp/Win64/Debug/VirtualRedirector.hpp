// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualRedirector.pas' rev: 32.00 (Windows)

#ifndef VirtualredirectorHPP
#define VirtualredirectorHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <MPShellTypes.hpp>
#include <MPCommonUtilities.hpp>
#include <MPThreadManager.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualredirector
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TPipeThread;
class DELPHICLASS TProcessTerminateThread;
class DELPHICLASS TCustomVirtualRedirector;
class DELPHICLASS TVirtualRedirector;
class DELPHICLASS TVirtualCommandLineRedirector;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TRedirectorInputEvent)(System::TObject* Sender, System::AnsiString NewInput);

typedef void __fastcall (__closure *TRedirectorChildProcessEndEvent)(System::TObject* Sender);

class PASCALIMPLEMENTATION TPipeThread : public Mpthreadmanager::TCommonThread
{
	typedef Mpthreadmanager::TCommonThread inherited;
	
private:
	NativeUInt FPipeIn;
	NativeUInt FPipeErrorIn;
	
protected:
	virtual void __fastcall Execute(void);
	__property NativeUInt PipeIn = {read=FPipeIn, write=FPipeIn};
	__property NativeUInt PipeErrorIn = {read=FPipeErrorIn, write=FPipeErrorIn};
	
public:
	virtual void __fastcall Terminate(void);
public:
	/* TCommonThread.Create */ inline __fastcall virtual TPipeThread(bool CreateSuspended) : Mpthreadmanager::TCommonThread(CreateSuspended) { }
	/* TCommonThread.Destroy */ inline __fastcall virtual ~TPipeThread(void) { }
	
};


class PASCALIMPLEMENTATION TProcessTerminateThread : public Mpthreadmanager::TCommonThread
{
	typedef Mpthreadmanager::TCommonThread inherited;
	
private:
	NativeUInt FChildProcess;
	
protected:
	virtual void __fastcall Execute(void);
	__property NativeUInt ChildProcess = {read=FChildProcess, write=FChildProcess};
public:
	/* TCommonThread.Create */ inline __fastcall virtual TProcessTerminateThread(bool CreateSuspended) : Mpthreadmanager::TCommonThread(CreateSuspended) { }
	/* TCommonThread.Destroy */ inline __fastcall virtual ~TProcessTerminateThread(void) { }
	
};


class PASCALIMPLEMENTATION TCustomVirtualRedirector : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	bool FRunning;
	NativeUInt FPipeIn;
	NativeUInt FPipeOut;
	NativeUInt FPipeErrorIn;
	_PROCESS_INFORMATION FProcessInfo;
	TRedirectorInputEvent FOnInput;
	TRedirectorInputEvent FOnErrorInput;
	TRedirectorChildProcessEndEvent FOnChildProcessEnd;
	HWND FHelperWnd;
	TPipeThread* FPipeThread;
	TProcessTerminateThread* FProcessTerminateThread;
	NativeUInt __fastcall GetChildProcessHandle(void);
	NativeUInt __fastcall GetChildProcessThread(void);
	unsigned __fastcall GetChildProcessID(void);
	unsigned __fastcall GetChildThreadID(void);
	
protected:
	void __fastcall CloseAndZeroHandle(NativeUInt &Handle);
	void __fastcall CloseHandles(void);
	virtual void __fastcall DoErrorInput(System::AnsiString NewErrorInput);
	virtual void __fastcall DoInput(System::AnsiString NewInput);
	virtual void __fastcall DoChildProcessEnd(void);
	void __fastcall HelperWndProc(Winapi::Messages::TMessage &Message);
	void __fastcall KillThreads(void);
	__property HWND HelperWnd = {read=FHelperWnd, write=FHelperWnd};
	__property TRedirectorInputEvent OnErrorInput = {read=FOnErrorInput, write=FOnErrorInput};
	__property TRedirectorInputEvent OnInput = {read=FOnInput, write=FOnInput};
	__property TRedirectorChildProcessEndEvent OnChildProcessEnd = {read=FOnChildProcessEnd, write=FOnChildProcessEnd};
	__property NativeUInt PipeOut = {read=FPipeOut, write=FPipeOut};
	__property NativeUInt PipeIn = {read=FPipeIn, write=FPipeIn};
	__property NativeUInt PipeErrorIn = {read=FPipeErrorIn, write=FPipeErrorIn};
	__property TPipeThread* PipeThread = {read=FPipeThread, write=FPipeThread};
	__property TProcessTerminateThread* ProcessTerminateThread = {read=FProcessTerminateThread, write=FProcessTerminateThread};
	__property _PROCESS_INFORMATION ProcessInfo = {read=FProcessInfo, write=FProcessInfo};
	
public:
	__fastcall virtual TCustomVirtualRedirector(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCustomVirtualRedirector(void);
	bool __fastcall Run(System::WideString FileName, System::WideString InitialDirectory, System::WideString Parameters = System::WideString());
	void __fastcall Kill(void);
	virtual void __fastcall Write(System::AnsiString Command);
	__property NativeUInt ChildProcessHandle = {read=GetChildProcessHandle};
	__property unsigned ChildProcessID = {read=GetChildProcessID, nodefault};
	__property NativeUInt ChildProcessThread = {read=GetChildProcessThread};
	__property unsigned ChildThreadID = {read=GetChildThreadID, nodefault};
	__property bool Running = {read=FRunning, nodefault};
};


class PASCALIMPLEMENTATION TVirtualRedirector : public TCustomVirtualRedirector
{
	typedef TCustomVirtualRedirector inherited;
	
__published:
	__property OnErrorInput;
	__property OnInput;
	__property OnChildProcessEnd;
public:
	/* TCustomVirtualRedirector.Create */ inline __fastcall virtual TVirtualRedirector(System::Classes::TComponent* AOwner) : TCustomVirtualRedirector(AOwner) { }
	/* TCustomVirtualRedirector.Destroy */ inline __fastcall virtual ~TVirtualRedirector(void) { }
	
};


typedef void __fastcall (__closure *TRedirectorChangeDir)(System::TObject* Sender, System::WideString NewDir, bool &Allow);

class PASCALIMPLEMENTATION TVirtualCommandLineRedirector : public TCustomVirtualRedirector
{
	typedef TCustomVirtualRedirector inherited;
	
private:
	System::AnsiString FCurrentDir;
	TRedirectorChangeDir FOnDirChange;
	void __fastcall SetCurrentDir(const System::AnsiString Value);
	
protected:
	virtual void __fastcall DoChangeDir(System::WideString NewDir, bool &Allow);
	
public:
	void __fastcall CarrageReturn(void);
	void __fastcall ChangeDir(System::AnsiString NewDir);
	System::AnsiString __fastcall FormatData(System::AnsiString Data);
	virtual void __fastcall Write(System::AnsiString Command);
	void __fastcall WriteUni(const System::UnicodeString Command);
	__property System::AnsiString CurrentDir = {read=FCurrentDir, write=SetCurrentDir};
	
__published:
	__property OnChildProcessEnd;
	__property TRedirectorChangeDir OnDirChange = {read=FOnDirChange, write=FOnDirChange};
	__property OnErrorInput;
	__property OnInput;
public:
	/* TCustomVirtualRedirector.Create */ inline __fastcall virtual TVirtualCommandLineRedirector(System::Classes::TComponent* AOwner) : TCustomVirtualRedirector(AOwner) { }
	/* TCustomVirtualRedirector.Destroy */ inline __fastcall virtual ~TVirtualCommandLineRedirector(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::ResourceString _STR_CREATE_PIPE_ERROR;
#define Virtualredirector_STR_CREATE_PIPE_ERROR System::LoadResourceString(&Virtualredirector::_STR_CREATE_PIPE_ERROR)
extern DELPHI_PACKAGE System::ResourceString _STR_ERRORREADINGERRORPIPE;
#define Virtualredirector_STR_ERRORREADINGERRORPIPE System::LoadResourceString(&Virtualredirector::_STR_ERRORREADINGERRORPIPE)
extern DELPHI_PACKAGE System::ResourceString _STR_ERRORWRITINGINPIPE;
#define Virtualredirector_STR_ERRORWRITINGINPIPE System::LoadResourceString(&Virtualredirector::_STR_ERRORWRITINGINPIPE)
extern DELPHI_PACKAGE System::ResourceString _STR_SHELLPROCESSTERMINATEERROR;
#define Virtualredirector_STR_SHELLPROCESSTERMINATEERROR System::LoadResourceString(&Virtualredirector::_STR_SHELLPROCESSTERMINATEERROR)
extern DELPHI_PACKAGE System::ResourceString _STR_SHELLPROCESSCREATEERROR;
#define Virtualredirector_STR_SHELLPROCESSCREATEERROR System::LoadResourceString(&Virtualredirector::_STR_SHELLPROCESSCREATEERROR)
extern DELPHI_PACKAGE System::ResourceString _STR_INVALIDAPPLICATIONFILE;
#define Virtualredirector_STR_INVALIDAPPLICATIONFILE System::LoadResourceString(&Virtualredirector::_STR_INVALIDAPPLICATIONFILE)
extern DELPHI_PACKAGE System::ResourceString _STR_CHILDPROCESSNOTRUNNING;
#define Virtualredirector_STR_CHILDPROCESSNOTRUNNING System::LoadResourceString(&Virtualredirector::_STR_CHILDPROCESSNOTRUNNING)
extern DELPHI_PACKAGE System::ResourceString _STR_XCOPYRUNERROR;
#define Virtualredirector_STR_XCOPYRUNERROR System::LoadResourceString(&Virtualredirector::_STR_XCOPYRUNERROR)
static const System::Word WM_NEWINPUT = System::Word(0x806f);
static const System::Word WM_ERRORINPUT = System::Word(0x8070);
static const System::Word WM_CHILDPROCESSCLOSE = System::Word(0x8071);
#define LineFeed L"\n\r"
}	/* namespace Virtualredirector */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALREDIRECTOR)
using namespace Virtualredirector;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualredirectorHPP
