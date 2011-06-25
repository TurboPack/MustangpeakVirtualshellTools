
[Setup]
AppName=Mustangpeak VirtualShellTools
#include "Version.txt"
; (use an include file for the AppVerName key for dynamic version number creation.)
DefaultDirName={commondocs}\Mustangpeak\VirtualShellTools
DefaultGroupName=VirtualShellTools
LicenseFile=..\Docs\Licence.txt
UsePreviousAppDir=true
UsePreviousGroup=true
ShowLanguageDialog=yes
OutputDir=.\

OutputBaseFilename=VirtualShellToolsSetup2.0
AppCopyright=©Jim Kueneman, Mustangpeak
AllowNoIcons=true

WizardSmallImageFile=..\..\InnoSetup\Shared\SantaRitasSmall.bmp
;WizardImageFile=D:\Program Data\Delphi Projects\3rd Party Components\InnoSetup\Shared\mustangpeak.bmp
WizardImageStretch=false

[Messages]
BeveledLabel=© Jim Kueneman, Mustangpeak.net

[Files]
Source: Setup.ini; DestDir: {app}
Source: ..\..\InnoSetup\MustangpeakComponentInstaller.dll; DestDir: {app}
Source: ..\Source\AppletsAndWizards.pas; DestDir: {app}\Source\
Source: ..\Source\ColumnForm.dfm; DestDir: {app}\Source\
Source: ..\Source\ColumnForm.pas; DestDir: {app}\Source\
Source: ..\Source\ColumnFormTNT.dfm; DestDir: {app}\Source\
Source: ..\Source\ColumnFormTNT.pas; DestDir: {app}\Source\
Source: ..\Source\ColumnFormTBX.dfm; DestDir: {app}\Source\
Source: ..\Source\ColumnFormTBX.pas; DestDir: {app}\Source\
Source: ..\Source\ColumnFormSpTBX.dfm; DestDir: {app}\Source\
Source: ..\Source\ColumnFormSpTBX.pas; DestDir: {app}\Source\
Source: ..\Source\Compilers.inc; DestDir: {app}\Source
Source: ..\Source\VirtualCommandLine.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualExplorerEasyListview.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualExplorerEasyListModeview.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualExplorerTree.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualRedirector.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualResources.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualScrollbars.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualSendToMenu.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualShellAutoComplete.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualShellHistory.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualShellNewMenu.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualShellNotifier.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualShellToolBar.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualThumbnails.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualFileSearch.pas; DestDir: {app}\Source\
Source: ..\Source\VirtualExplorerTreeExt.res; DestDir: {app}\Source\
Source: ..\Delphi\ReadMe.txt; DestDir: {app}\Delphi\
;Source: ..\Delphi\VirtualShellToolsD5.dpk; DestDir: {app}\Delphi\
;Source: ..\Delphi\VirtualShellToolsD5D.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD6.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD6D.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD7.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD7D.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD9.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD9.res; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD9D.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD9D.res; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD10.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD10.res; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD10D.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD10D.res; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD11.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD11.res; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD11D.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD11D.res; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD12.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD12.res; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD12D.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD12D.res; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD14.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD14.res; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD14D.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD14D.res; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD15.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD15.res; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD15D.dpk; DestDir: {app}\Delphi\
Source: ..\Delphi\VirtualShellToolsD15D.res; DestDir: {app}\Delphi\
Source: ..\Delphi\VSTools Build D6.bpg; DestDir: {app}\Delphi\
Source: ..\Delphi\VSTools Build D7.bpg; DestDir: {app}\Delphi\
Source: ..\Demos\Adding Custom Columns Using ShellDetails\ShellDetailsCustomColumns.dpr; DestDir: {app}\Demos\Adding Custom Columns Using ShellDetails
Source: ..\Demos\Adding Custom Columns Using ShellDetails\Unit1.dfm; DestDir: {app}\Demos\Adding Custom Columns Using ShellDetails
Source: ..\Demos\Adding Custom Columns Using ShellDetails\Unit1.pas; DestDir: {app}\Demos\Adding Custom Columns Using ShellDetails
Source: ..\Demos\Applet and Wizard Launcher\AppletWizardLauncher.dpr; DestDir: {app}\Demos\Applet and Wizard Launcher
Source: ..\Demos\Applet and Wizard Launcher\Unit1.dfm; DestDir: {app}\Demos\Applet and Wizard Launcher
Source: ..\Demos\Applet and Wizard Launcher\Unit1.pas; DestDir: {app}\Demos\Applet and Wizard Launcher
Source: ..\Demos\AutoComplete Component\AutoCompleteComponentProject.dpr; DestDir: {app}\Demos\AutoComplete Component
Source: ..\Demos\AutoComplete Component\Unit1.dfm; DestDir: {app}\Demos\AutoComplete Component
Source: ..\Demos\AutoComplete Component\Unit1.pas; DestDir: {app}\Demos\AutoComplete Component
Source: ..\Demos\AutoCompleteObject\AutoCompleteObject.dpr; DestDir: {app}\Demos\AutoCompleteObject
Source: ..\Demos\AutoCompleteObject\Unit1.dfm; DestDir: {app}\Demos\AutoCompleteObject
Source: ..\Demos\AutoCompleteObject\Unit1.pas; DestDir: {app}\Demos\AutoCompleteObject
Source: ..\Demos\Backgnd Menu\BkGndMenuProject.dpr; DestDir: {app}\Demos\Background Menu
Source: ..\Demos\Backgnd Menu\Unit1.pas; DestDir: {app}\Demos\Background Menu
Source: ..\Demos\Backgnd Menu\Unit1.dfm; DestDir: {app}\Demos\Background Menu
Source: ..\Demos\CheckBoxes\CheckBoxes.dpr; DestDir: {app}\Demos\CheckBoxes
Source: ..\Demos\CheckBoxes\TEST.TXT; DestDir: {app}\Demos\CheckBoxes
Source: ..\Demos\CheckBoxes\Unit1.dfm; DestDir: {app}\Demos\CheckBoxes
Source: ..\Demos\CheckBoxes\Unit1.pas; DestDir: {app}\Demos\CheckBoxes
Source: ..\Demos\Custom Sorting\Unit1.dfm; DestDir: {app}\Demos\Custom Sorting
Source: ..\Demos\Custom Sorting\Unit1.pas; DestDir: {app}\Demos\Custom Sorting
Source: ..\Demos\Custom Sorting\CustomSortProject.dpr; DestDir: {app}\Demos\Custom Sorting
Source: ..\Demos\Custom Columns\Unit1.dfm; DestDir: {app}\Demos\Custom Columns
Source: ..\Demos\Custom Columns\Unit1.pas; DestDir: {app}\Demos\Custom Columns
Source: ..\Demos\Custom Columns\CustomColumnProject.dpr; DestDir: {app}\Demos\Custom Columns
Source: ..\Demos\DOS Shell CommandLine\DOSCommandLineProject.dpr; DestDir: {app}\Demos\DOS Shell CommandLine
Source: ..\Demos\DOS Shell CommandLine\Unit1.dfm; DestDir: {app}\Demos\DOS Shell CommandLine
Source: ..\Demos\DOS Shell CommandLine\Unit1.pas; DestDir: {app}\Demos\DOS Shell CommandLine
Source: ..\Demos\Explorer CheckBoxes\ExplorerCheckboxes.dpr; DestDir: {app}\Demos\Explorer CheckBoxes
Source: ..\Demos\Explorer CheckBoxes\InfoForm.dfm; DestDir: {app}\Demos\Explorer CheckBoxes
Source: ..\Demos\Explorer CheckBoxes\InfoForm.pas; DestDir: {app}\Demos\Explorer CheckBoxes
Source: ..\Demos\Explorer CheckBoxes\Unit1.dfm; DestDir: {app}\Demos\Explorer CheckBoxes
Source: ..\Demos\Explorer CheckBoxes\Unit1.pas; DestDir: {app}\Demos\Explorer CheckBoxes
Source: ..\Demos\Explorer CheckBoxes\VirtualCheckboxesSynchronizer.pas; DestDir: {app}\Demos\Explorer CheckBoxes
Source: ..\Demos\File Search\FileSearch.dpr; DestDir: {app}\Demos\File Search
Source: ..\Demos\File Search\FindFile.pas; DestDir: {app}\Demos\File Search
Source: ..\Demos\File Search\FindFile.zip; DestDir: {app}\Demos\File Search
Source: ..\Demos\File Search\ReadMe.txt; DestDir: {app}\Demos\File Search
Source: ..\Demos\File Search\uWndSearchFiles.dfm; DestDir: {app}\Demos\File Search
Source: ..\Demos\File Search\uWndSearchFiles.pas; DestDir: {app}\Demos\File Search
Source: ..\Demos\FileSearch\FileSearchProject.dpr; DestDir: {app}\Demos\File Search2
Source: ..\Demos\FileSearch\Unit1.dfm; DestDir: {app}\Demos\File Search2
Source: ..\Demos\FileSearch\Unit1.pas; DestDir: {app}\Demos\File Search2
Source: ..\Demos\FolderSize\FolderSizeDemo.dpr; DestDir: {app}\Demos\FolderSize
Source: ..\Demos\FolderSize\Unit1.dfm; DestDir: {app}\Demos\FolderSize
Source: ..\Demos\FolderSize\Unit1.pas; DestDir: {app}\Demos\FolderSize
Source: ..\Demos\Namespace Browser\NamespaceBrowserProject.dpr; DestDir: {app}\Demos\Namespace Browser
Source: ..\Demos\Namespace Browser\Unit1.dfm; DestDir: {app}\Demos\Namespace Browser
Source: ..\Demos\Namespace Browser\Unit1.pas; DestDir: {app}\Demos\Namespace Browser
Source: ..\Demos\Overview\InfoForm.dfm; DestDir: {app}\Demos\Overview
Source: ..\Demos\Overview\InfoForm.pas; DestDir: {app}\Demos\Overview
Source: ..\Demos\Overview\Unit1.dfm; DestDir: {app}\Demos\Overview
Source: ..\Demos\Overview\Unit1.pas; DestDir: {app}\Demos\Overview
Source: ..\Demos\Overview\VET.dpr; DestDir: {app}\Demos\Overview
Source: ..\Demos\Overview\VETBkgnd.bmp; DestDir: {app}\Demos\Overview
Source: ..\Demos\PrevDirNode\Project1.dpr; DestDir: {app}\Demos\PrevDirNode
Source: ..\Demos\PrevDirNode\Unit1.dfm; DestDir: {app}\Demos\PrevDirNode
Source: ..\Demos\PrevDirNode\Unit1.pas; DestDir: {app}\Demos\PrevDirNode
Source: ..\Demos\SendTo Menu\SendTo Menu TBX\Back.bmp; DestDir: {app}\Demos\SendTo Menu\SendTo Menu TBX
Source: ..\Demos\SendTo Menu\SendTo Menu TBX\folder.bmp; DestDir: {app}\Demos\SendTo Menu\SendTo Menu TBX
Source: ..\Demos\SendTo Menu\SendTo Menu TBX\Fwd.bmp; DestDir: {app}\Demos\SendTo Menu\SendTo Menu TBX
Source: ..\Demos\SendTo Menu\SendTo Menu TBX\SendToMenuProject.dpr; DestDir: {app}\Demos\SendTo Menu\SendTo Menu TBX
Source: ..\Demos\SendTo Menu\SendTo Menu TBX\Unit1.dfm; DestDir: {app}\Demos\SendTo Menu\SendTo Menu TBX
Source: ..\Demos\SendTo Menu\SendTo Menu TBX\Unit1.pas; DestDir: {app}\Demos\SendTo Menu\SendTo Menu TBX
Source: ..\Demos\SendTo Menu\Back.bmp; DestDir: {app}\Demos\SendTo Menu
Source: ..\Demos\SendTo Menu\folder.bmp; DestDir: {app}\Demos\SendTo Menu
Source: ..\Demos\SendTo Menu\Fwd.bmp; DestDir: {app}\Demos\SendTo Menu
Source: ..\Demos\SendTo Menu\SendToMenuProject.dpr; DestDir: {app}\Demos\SendTo Menu
Source: ..\Demos\SendTo Menu\Unit1.dfm; DestDir: {app}\Demos\SendTo Menu
Source: ..\Demos\SendTo Menu\Unit1.pas; DestDir: {app}\Demos\SendTo Menu
Source: ..\Demos\Shell History\TBX Enabled Demo\ShellHistoryTBX.dpr; DestDir: {app}\Demos\Shell History\TBX Enabled Demo
Source: ..\Demos\Shell History\TBX Enabled Demo\Unit1.dfm; DestDir: {app}\Demos\Shell History\TBX Enabled Demo
Source: ..\Demos\Shell History\TBX Enabled Demo\Unit1.pas; DestDir: {app}\Demos\Shell History\TBX Enabled Demo
Source: ..\Demos\Shell History\ShellHistory.dpr; DestDir: {app}\Demos\Shell History
Source: ..\Demos\Shell History\Unit1.dfm; DestDir: {app}\Demos\Shell History
Source: ..\Demos\Shell History\Unit1.pas; DestDir: {app}\Demos\Shell History
Source: ..\Demos\Shell Link Shortcuts\ShellLinkShortcuts.dpr; DestDir: {app}\Demos\Shell Link Shortcuts
Source: ..\Demos\Shell Link Shortcuts\Unit1.dfm; DestDir: {app}\Demos\Shell Link Shortcuts
Source: ..\Demos\Shell Link Shortcuts\Unit1.pas; DestDir: {app}\Demos\Shell Link Shortcuts
Source: ..\Demos\Shell Notify\ShellNotify.dpr; DestDir: {app}\Demos\Shell Notify
Source: ..\Demos\Shell Notify\Unit1.dfm; DestDir: {app}\Demos\Shell Notify
Source: ..\Demos\Shell Notify\Unit1.pas; DestDir: {app}\Demos\Shell Notify
Source: ..\Demos\Shell Notify\Unit2.dfm; DestDir: {app}\Demos\Shell Notify
Source: ..\Demos\Shell Notify\Unit2.pas; DestDir: {app}\Demos\Shell Notify
Source: ..\Demos\ShellColumn State Storing\ShellColumnStateStoring.dpr; DestDir: {app}\Demos\ShellColumn State Storing
Source: ..\Demos\ShellColumn State Storing\Unit1.dfm; DestDir: {app}\Demos\ShellColumn State Storing
Source: ..\Demos\ShellColumn State Storing\Unit1.pas; DestDir: {app}\Demos\ShellColumn State Storing
Source: ..\Demos\ShellNew (New File) Menu\ShellNew_NewFileMenu.dpr; DestDir: {app}\Demos\ShellNew (New File) Menu
Source: ..\Demos\ShellNew (New File) Menu\Unit1.dfm; DestDir: {app}\Demos\ShellNew (New File) Menu
Source: ..\Demos\ShellNew (New File) Menu\Unit1.pas; DestDir: {app}\Demos\ShellNew (New File) Menu
Source: ..\Demos\ShellToolbars\ShellToolbars.dpr; DestDir: {app}\Demos\ShellToolbars
Source: ..\Demos\ShellToolbars\Unit1.dfm; DestDir: {app}\Demos\ShellToolbars
Source: ..\Demos\ShellToolbars\Unit1.pas; DestDir: {app}\Demos\ShellToolbars
Source: ..\Demos\User Data\Unit1.dfm; DestDir: {app}\Demos\User Data
Source: ..\Demos\User Data\Unit1.pas; DestDir: {app}\Demos\User Data
Source: ..\Demos\User Data\UserDataProject.dpr; DestDir: {app}\Demos\User Data
Source: ..\Demos\VirtualExplorerEasyListview\Unit1.dfm; DestDir: {app}\Demos\VirtualEasyListview
Source: ..\Demos\VirtualExplorerEasyListview\Unit1.pas; DestDir: {app}\Demos\VirtualEasyListview
Source: ..\Demos\VirtualExplorerEasyListview\VEasyListviewProject.dpr; DestDir: {app}\Demos\VirtualEasyListview
Source: ..\Demos\VirtualEasyListviewCustomContextMenu\Unit1.dfm; DestDir: {app}\Demos\VirtualEasyListviewCustomContextMenu
Source: ..\Demos\VirtualEasyListviewCustomContextMenu\Unit1.pas; DestDir: {app}\Demos\VirtualEasyListviewCustomContextMenu
Source: ..\Demos\VirtualEasyListviewCustomContextMenu\VirtaulExplorerEasyListviewMEnuProject.dpr; DestDir: {app}\Demos\VirtualEasyListviewCustomContextMenu
Source: ..\Demos\Virtual Explorer\About.dfm; DestDir: {app}\Demos\Virtual Explorer
Source: ..\Demos\Virtual Explorer\About.pas; DestDir: {app}\Demos\Virtual Explorer
Source: ..\Demos\Virtual Explorer\Event.log; DestDir: {app}\Demos\Virtual Explorer
Source: ..\Demos\Virtual Explorer\Unit1.dfm; DestDir: {app}\Demos\Virtual Explorer
Source: ..\Demos\Virtual Explorer\Unit1.pas; DestDir: {app}\Demos\Virtual Explorer
Source: ..\Demos\Virtual Explorer\VirtualExplorer.dpr; DestDir: {app}\Demos\Virtual Explorer
Source: ..\Demos\Virtual Explorer\VST Logo 1.bmp; DestDir: {app}\Demos\Virtual Explorer
Source: ..\Demos\Readme.txt; DestDir: {app}\Demos\
Source: ..\Demos\Vertical Icons Custom Draw\ProjectVerticalIcons.dpr; DestDir: {app}\Demos\Vertical Icons Custom Draw
Source: ..\Demos\Vertical Icons Custom Draw\Unit1.dfm; DestDir: {app}\Demos\Vertical Icons Custom Draw
Source: ..\Demos\Vertical Icons Custom Draw\Unit1.pas; DestDir: {app}\Demos\Vertical Icons Custom Draw
Source: ..\Demos\VirtualShellToolsDemos with Toolbar2000-TBX.bpg; DestDir: {app}\Demos\
Source: ..\Demos\VirtualShellToolsDemos.bpg; DestDir: {app}\Demos\
Source: ..\Demos\Wow64 File Redirection\Unit1.dfm; DestDir: {app}\Demos\Wow64 File Redirection
Source: ..\Demos\Wow64 File Redirection\Unit1.pas; DestDir: {app}\Demos\Wow64 File Redirection
Source: ..\Demos\Wow64 File Redirection\Wow64FileRedirection.dpr; DestDir: {app}\Demos\Wow64 File Redirection
Source: ..\Demos\KnownFolders\Unit1.dfm; DestDir: {app}\Demos\KnownFolders
Source: ..\Demos\KnownFolders\Unit1.pas; DestDir: {app}\Demos\KnownFolders
Source: ..\Demos\KnownFolders\KnwonwFoldersProject.dpr; DestDir: {app}\Demos\KnownFolders
Source: ..\Design\VirtualShellToolsReg.dcr; DestDir: {app}\Design\
Source: ..\Design\VirtualShellToolsReg.pas; DestDir: {app}\Design\
Source: ..\Design\Compilers.inc; DestDir: {app}\Design\
Source: ..\Docs\CBuilder 6 Issues.txt; DestDir: {app}\Docs\
Source: ..\Docs\Licence.txt; DestDir: {app}\Docs\
Source: ..\Docs\Mustangpeak.net.url; DestDir: {app}\Docs\
Source: ..\Docs\Unicode Compatibilty.txt; DestDir: {app}\Docs\
Source: ..\Docs\VirtualShellTools History.txt; DestDir: {app}\Docs\
;Source: ..\Docs\VirtualShellTools.chm; DestDir: {app}\Docs\
Source: ..\Docs\Whats New.txt; DestDir: {app}\Docs\
Source: ..\Include\AddIns.inc; DestDir: {app}\Include\
Source: ..\Include\uxtheme.h; DestDir: {app}\Include\
Source: ..\Resources\Images\Bkgnd.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\Folder Funnel 24x24.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\Setup Gear 24x24.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\Setup Gear 32x32.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\VET_Logo.png; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XDisk.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPBackArrow 24x24.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPBackArrow.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPFolders 16x16.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPFolders 24x24.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPFolders.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPHistory 16x16.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPHistory 24x24.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPListviewStyle.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPNextArrow 24x24.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPNextArrow.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPSearch 24x24.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPSearch.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPSearch2.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPSearch2Small.bmp; DestDir: {app}\Resources\Images
Source: ..\Resources\Images\XPUpFolder.bmp; DestDir: {app}\Resources\Images
Source: ..\CBuilder\Include\Vcl\shlobj.hpp; DestDir: {app}\CBuilder\Include\Vcl
Source: ..\CBuilder\Include\shlobj.h; DestDir: {app}\CBuilder\Include
Source: ..\CBuilder\readme.txt; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VirtualShellToolsC5.bpk; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VirtualShellToolsC5.cpp; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VirtualShellToolsC5.res; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VirtualShellToolsC5D.bpk; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VirtualShellToolsC5D.cpp; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VirtualShellToolsC5D.res; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VirtualShellToolsC6.bpk; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VirtualShellToolsC6.cpp; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VirtualShellToolsC6.res; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VirtualShellToolsC6D.bpk; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VirtualShellToolsC6D.cpp; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VirtualShellToolsC6D.res; DestDir: {app}\CBuilder\
Source: ..\CBuilder\VSTools Build C6.bpg; DestDir: {app}\CBuilder\

[Registry]
Root: HKCU; Subkey: Software\Mustangpeak\VirtualShellTools; ValueType: string; ValueName: InstallPath; ValueData: {app}; Flags: uninsdeletekey
Root: HKCU; Subkey: Software\Mustangpeak\VirtualShellTools; ValueType: string; ValueName: SourcePath; ValueData: {app}\Source\; Flags: uninsdeletekey
Root: HKCU; Subkey: Software\Mustangpeak\VirtualShellTools; ValueType: string; ValueName: DelphiPackagePath; ValueData: {app}\Delphi\; Flags: uninsdeletekey
Root: HKCU; Subkey: Software\Mustangpeak\VirtualShellTools; ValueType: string; ValueName: CBuilderPackagePath; ValueData: {app}\CBuilder\; Flags: uninsdeletekey

[Dirs]
Name: {app}\Source; Flags: uninsalwaysuninstall
Name: {app}\Delphi; Flags: uninsalwaysuninstall
Name: {app}\Demos; Flags: uninsalwaysuninstall
Name: {app}\Design; Flags: uninsalwaysuninstall
Name: {app}\Docs; Flags: uninsalwaysuninstall
Name: {app}\Include; Flags: uninsalwaysuninstall
Name: {app}\Resources; Flags: uninsalwaysuninstall
Name: {app}\CBuilder; Flags: uninsalwaysuninstall
[Code]
const
  SetupFile = 'Setup.ini';
  WaitForIDEs = False;

#include "..\..\InnoSetup\Templates\IDE Install.txt"
