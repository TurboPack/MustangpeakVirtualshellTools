//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USEFORMNS("..\Source\ColumnForm.pas", Columnform, FormColumnSettings);
USEUNIT("..\Source\AppletsAndWizards.pas");
USEUNIT("..\Source\VirtualCommandLine.pas");
USEUNIT("..\Source\VirtualExplorerEasyListModeview.pas");
USEUNIT("..\Source\VirtualExplorerEasyListview.pas");
USEUNIT("..\Source\VirtualExplorerTree.pas");
USEUNIT("..\Source\VirtualRedirector.pas");
USEUNIT("..\Source\VirtualResources.pas");
USEUNIT("..\Source\VirtualScrollbars.pas");
USEUNIT("..\Source\VirtualSendToMenu.pas");
USEUNIT("..\Source\VirtualShellAutoComplete.pas");
USEUNIT("..\Source\VirtualShellHistory.pas");
USEUNIT("..\Source\VirtualShellNewMenu.pas");
USEUNIT("..\Source\VirtualShellNotifier.pas");
USEUNIT("..\Source\VirtualShellToolbar.pas");
USEUNIT("..\Source\VirtualThumbnails.pas");
USEUNIT("..\Source\VirtualFileSearch.pas");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcljpg50.bpi");
USEPACKAGE("VirtualTreesC5.bpi");
USEPACKAGE("ThemeManagerC5.bpi");
USEPACKAGE("EasyListviewC5.bpi");
USEPACKAGE("MPCommonLibC5.bpi");

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
