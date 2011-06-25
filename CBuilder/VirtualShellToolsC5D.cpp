//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("VirtualShellToolsC5D.res");
USEUNIT("..\Design\VirtualShellToolsReg.pas");
USERES("..\Design\VirtualShellToolsReg.dcr");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("dclstd50.bpi");
USEPACKAGE("VirtualTreeView.bpi");
USEPACKAGE("VirtualShellToolsC5.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
