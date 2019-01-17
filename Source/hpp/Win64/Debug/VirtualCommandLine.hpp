// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualCommandLine.pas' rev: 32.00 (Windows)

#ifndef VirtualcommandlineHPP
#define VirtualcommandlineHPP

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
#include <Vcl.ImgList.hpp>
#include <Winapi.ShlObj.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Winapi.ActiveX.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualcommandline
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TCommandLinePipe;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TCommandLinePipe : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	NativeUInt FhPipe2Read;
	NativeUInt FhPipe1Write;
	NativeUInt FhPipe1ReadDuplicate;
	NativeUInt FhPipe2WriteDuplicate;
	System::Classes::TMemoryStream* FMemStream;
	
protected:
	__property NativeUInt hPipe1Write = {read=FhPipe1Write, write=FhPipe1Write};
	__property NativeUInt hPipe1ReadDuplicate = {read=FhPipe1ReadDuplicate, write=FhPipe1ReadDuplicate};
	__property NativeUInt hPipe2Read = {read=FhPipe2Read, write=FhPipe2Read};
	__property NativeUInt hPipe2WriteDuplicate = {read=FhPipe2WriteDuplicate, write=FhPipe2WriteDuplicate};
	__property System::Classes::TMemoryStream* MemStream = {read=FMemStream, write=FMemStream};
	
public:
	__fastcall virtual TCommandLinePipe(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCommandLinePipe(void);
	void __fastcall DOSCommand(System::AnsiString Command);
	void __fastcall Initialize(void);
	void __fastcall ReadFrom(System::Classes::TMemoryStream* Stream);
	System::AnsiString __fastcall ReadResult(void);
	void __fastcall SendTo(System::Classes::TMemoryStream* Stream);
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Virtualcommandline */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALCOMMANDLINE)
using namespace Virtualcommandline;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualcommandlineHPP
