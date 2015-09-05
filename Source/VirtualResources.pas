unit VirtualResources;

// Version 2.4.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
//
//----------------------------------------------------------------------------
//
// Modifications by Francois Rivierre, 2005-11-09, to allow runtime
// customization of internal strings.
//
//----------------------------------------------------------------------------

interface

{$include ..\Include\AddIns.inc}

uses
  // < FR added 11-28-05 >
  // To allow customization of check images at runtime in the column dialog
  VirtualTrees,
  Forms,
  {$IFDEF TNTSUPPORT}
  TntStdCtrls,
  TntClasses,
  TntSysUtils,
  TntMenus,
  TntForms,
  {$ELSE}
  StdCtrls,
  Classes,
  Menus,
  {$ENDIF}
  // </ FR added 11-28-05 >
  Messages;

{$include ..\Include\AddIns.inc}

const
  WM_VETBASE = WM_APP + 51;
  WM_SHELLNOTIFY = WM_VETBASE;                 // Change in the Shell occured
  WM_VTSETICONINDEX = WM_VETBASE + 1;          // Threaded Icons
  WM_INVALIDFILENAME = WM_VETBASE + 2;         // VET
  WM_SHELLNOTIFYTHREADQUIT = WM_VETBASE + 3;   // ShellNotifier
  WM_CHANGENOTIFY_NT = WM_VETBASE + 4;         // ShellNotifier
  WM_CHANGENOTIFY = WM_VETBASE + 5;            // ShellNotifier
  WM_SHELLNOTIFYTHREADEVENT = WM_VETBASE + 6;  // ShellNotifier
  WM_SHELLNOTIFYRELEASE = WM_VETBASE + 7;      // ShellNotifier
  WM_REMOVEBUTTON = WM_VETBASE + 8;            // VirtualShellToolbar
  WM_CHANGENOTIFY_CUSTOM = WM_VETBASE + 9;
  WM_UPDATESCROLLBAR = WM_VETBASE + 10;       // Signal TDropDownWnd to update scrollbar
  WM_VTSETTHREADMARK = WM_VETBASE + 11;

// <FR changes 2005-11-09>
// Const were changed to var of WideString type, to allow customization
// at runtime. Please not that const necessary to launch control panel applets
// and all this kind of stuff remain unmodified.

type
  {$IFDEF TNTSUPPORT}
  TVirtualCustomEdit = TTntCustomEdit;
  TVirtualPopupMenu = TTntPopupMenu;
  TVirtualMenuItem = TTntMenuItem;
  TVirtualFileStream = TTntFileStream;
  TVirtualScrollBox = TTntScrollbox;
  {$ELSE}
  TVirtualCustomEdit = TCustomEdit;
  TVirtualPopupMenu = TPopupMenu;
  TVirtualMenuItem = TMenuItem;
  TVirtualFileStream = TFileStream;
  TVirtualScrollBox = TScrollbox;
  {$ENDIF}

var
   S_WARNING: WideString = 'Warning';
   S_OPEN: WideString = 'Open';

  STR_GROUPMODIFIEDHOUR: WideString = 'Last hour';
  STR_GROUPMODIFIEDTODAY: WideString = 'Last twenty-four hours';
  STR_GROUPMODIFIEDTHISWEEK: WideString = 'This week';
  STR_GROUPMODIFIEDTWOWEEKS: WideString = 'Two weeks ago';
  STR_GROUPMODIFIEDTHREEWEEKS: WideString = 'Three weeks ago';
  STR_GROUPMODIFIEDMONTH: WideString = 'A month ago';
  STR_GROUPMODIFIEDTWOMONTHS: WideString = 'Two months ago';
  STR_GROUPMODIFIEDTHREEMONTHS: WideString = 'Three months ago';
  STR_GROUPMODIFIEDFOURMONTHS: WideString = 'Four months ago';
  STR_GROUPMODIFIEDFIVEMONTHS: WideString = 'Five months ago';
  STR_GROUPMODIFIEDSIXMONTHS: WideString = 'Six months ago';
  STR_GROUPMODIFIEDEARLIERTHISYEAR: WideString = 'Earlier this year' ;
  STR_GROUPMODIFIEDLONGTIMEAGO: WideString = 'A long time ago';

  STR_GROUPSIZEZERO: WideString = 'Zero';
  STR_GROUPSIZETINY: WideString = 'Tiny';
  STR_GROUPSIZESMALL: WideString = 'Small';
  STR_GROUPSIZEMEDIUM: WideString = 'Medium';
  STR_GROUPSIZELARGE: WideString = 'Large';
  STR_GROUPSIZEGIGANTIC: WideString = 'Gigantic';
  STR_GROUPSIZESYSFOLDER: WideString = 'System Folders';
  STR_GROUPSIZEFOLDER: WideString =  'Folders';

  STR_HEADERMENUMORE: WideString = 'More...';

  // < FR added 11-28-05>
  // These variables are used to customize at runtime the column dialog.
  // They are loaded in the corresponding components in the OnShow event
  // of the column dialog.
  STR_COLUMNDLG_CAPTION : WideString = 'Column settings';
  STR_COLUMNDLG_LABEL1  : WideString = 'Check the columns you would like ' +
    'to make visible in this Folder.  Drag and Drop to reorder the columns. ';
  STR_COLUMNDLG_LABEL2  : WideString = 'The selected column should be ';
  STR_COLUMNDLG_LABEL3  : WideString = 'pixels wide';
  STR_COLUMNDLG_CHECKBOXLIVEUPDATE : WideString = 'LiveUpdate';
  STR_COLUMNDLG_BUTTONOK     : WideString = 'OK';
  STR_COLUMNDLG_BUTTONCANCEL : WideString = 'Cancel';
  // The following is not a string, but I find useful to be able to change
  // the checkboxes style, so I've added another variable to manage it.
  COLUMNDLG_CHKSTYLE : TCheckImageKind = ckXP;
  // </ FR added 11-28-05>

    // Error given when the root of VET is set to a path that does not exist.  The
  // end user should never see this message.
  STR_ERR_INVALID_CUSTOMPATH: WideString = 'Invalid pathname for Custom Root Path';

  // Menu item text shown when the column popup menu has more than a specified
  // number of items or the column has told VET it should not be shown in the
  // menu but only show it in the dialog box.
  STR_COLUMNMENU_MORE: WideString = 'More ...';

    // --------------------------------------------------------------------------
  // TExplorerComboBox messages
  // --------------------------------------------------------------------------

  S_PATH_ERROR: WideString = 'Invalid Path';
  S_COMBOEDIT_DEFAULT_ERROR1: WideString = ' can not be found by Windows. Please check the spelling and try again.';
  // --------------------------------------------------------------------------

    // --------------------------------------------------------------------------
  // VirtualShellNewMenu strings
  // --------------------------------------------------------------------------
  // The string used as a prefix to the new file being created based on the file type
  // of the extension.  For example a Notepad TXT file will create a new file named
  // New Text Document.txt, where the "New " string is this constant.
  S_NEW: WideString = 'New ';
  // These are the strings that will be appended to New when the additional menu
  // item "New Folder" and "New ShortCut" are requested in the menu.
  S_FOLDER: WideString = 'Folder';
  S_SHORTCUT: WideString = 'Shortcut';
  // This is the string that is shown in the Messagebox if the new file will
  // overwrite an existing file.
  S_OVERWRITE_EXISTING_FILE: WideString = 'File exists.  Overwrite existing file?';

// FR added 2005-11-09. This allow to preserve the following as constants.
const
  // SHOULD NOT HAVE TO EDIT THESE STRINGS
  // applet launcher file, should never have to change this
  S_RUNDLL32 = '\rundll32.exe';
  // The dll launched by RunDll32.exe for the Briefcase with the necessary mods
  // Do not Modify!
  // The %1 seems to be Boolean for create on desktop on not (not being true)
  S_BRIEFCASE_HACK_STRING = 'syncui.dll,Briefcase_Create 1!d! ';
  // Test string to match up with Command string to see if the menu item will
  // create a new Briefcase or Link. Do not Modify!
  S_BRIEFCASE_IDENTIFIER = ',Briefcase_Create';
  S_CREATELINK_IDENTIFIER = ',NewLinkHere';
  S_NULLFILE = 'NullFile';
  S_FILENAME = 'FileName';
  S_COMMAND = 'Command';
  S_DATA = 'Data';
  S_SHELLNEW_PATH = '\ShellNew';
  // --------------------------------------------------------------------------

  // Literal translations of TShellNotifyEvent type.  Useful when using the
  // OnShellNotify event to print out what event occured.  VirtualShellUtilities.pas
  // has a helper function ShellNotifyEventToStr that uses these.
  VET_NOTIFY_EVENTS: array[0..19] of WideString = (
    'Assocciation Changed',
    'Attributes',
    'Item Create',
    'Item Delete',
    'Drive Add',
    'Drive Add GUI',
    'Drive Removed',
    'Free Space',
    'Media Inserted',
    'Media Removed',
    'Make Directory',
    'Network Share',
    'Network Unshare',
    'Folder Rename',
    'Item Rename',
    'Remove Directory',
    'Server Disconnect',
    'Update Directory',
    'Update Image',
    'Update Item'
  );

// const
var
  // The verb sent to the context menu notification events if the selected context
  // menu item is a non standard verb.
  STR_UNKNOWNCOMMAN: WideString = 'Unknown Command';


  STR_DRIVELETTER_A: WideString = 'a';

  // --------------------------------------------------------------------------
  // Common strings
  // --------------------------------------------------------------------------

  S_PRINT: WideString = 'print';
  S_PROPERTIES: WideString = 'properties';

  // --------------------------------------------------------------------------


  // ASSERT Strings
  S_KERNELNOTIFERREGISTERED: WideString = 'A KernelChangeNotifier is still registered with a Control';
  S_SHELLNOTIFERREGISTERED: WideString = 'A ShellChangeThread is still registered with a Control';
  S_SHELLNOTIFERDISPATCHTHREAD: WideString = 'ChangeDispatchThread is still registered';
  S_KERNELSPECIALFOLDERWATCH: WideString = 'A control must be registered with ' +
     'the VirtualChangeNotifier using RegisterShellChangeNotify before this ' +
     'method may be used.';

implementation

end.
