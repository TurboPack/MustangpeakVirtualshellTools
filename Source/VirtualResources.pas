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
  StdCtrls,
  Classes,
  Menus,
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
  WM_FOLDERCHANGENOTIFY = WM_VETBASE + 12;

// <FR changes 2005-11-09>
// Const were changed to var of string type, to allow customization
// at runtime. Please not that const necessary to launch control panel applets
// and all this kind of stuff remain unmodified.

type
  TVirtualCustomEdit = TCustomEdit;
  TVirtualPopupMenu = TPopupMenu;
  TVirtualMenuItem = TMenuItem;
  TVirtualFileStream = TFileStream;
  TVirtualScrollBox = TScrollbox;

var
   S_WARNING: string = 'Warning';
   S_OPEN: string = 'Open';

  STR_GROUPMODIFIEDHOUR: string = 'Last hour';
  STR_GROUPMODIFIEDTODAY: string = 'Last twenty-four hours';
  STR_GROUPMODIFIEDTHISWEEK: string = 'This week';
  STR_GROUPMODIFIEDTWOWEEKS: string = 'Two weeks ago';
  STR_GROUPMODIFIEDTHREEWEEKS: string = 'Three weeks ago';
  STR_GROUPMODIFIEDMONTH: string = 'A month ago';
  STR_GROUPMODIFIEDTWOMONTHS: string = 'Two months ago';
  STR_GROUPMODIFIEDTHREEMONTHS: string = 'Three months ago';
  STR_GROUPMODIFIEDFOURMONTHS: string = 'Four months ago';
  STR_GROUPMODIFIEDFIVEMONTHS: string = 'Five months ago';
  STR_GROUPMODIFIEDSIXMONTHS: string = 'Six months ago';
  STR_GROUPMODIFIEDEARLIERTHISYEAR: string = 'Earlier this year' ;
  STR_GROUPMODIFIEDLONGTIMEAGO: string = 'A long time ago';

  STR_GROUPSIZEZERO: string = 'Zero';
  STR_GROUPSIZETINY: string = 'Tiny';
  STR_GROUPSIZESMALL: string = 'Small';
  STR_GROUPSIZEMEDIUM: string = 'Medium';
  STR_GROUPSIZELARGE: string = 'Large';
  STR_GROUPSIZEGIGANTIC: string = 'Gigantic';
  STR_GROUPSIZESYSFOLDER: string = 'System Folders';
  STR_GROUPSIZEFOLDER: string =  'Folders';

  STR_HEADERMENUMORE: string = 'More...';

  // < FR added 11-28-05>
  // These variables are used to customize at runtime the column dialog.
  // They are loaded in the corresponding components in the OnShow event
  // of the column dialog.
  STR_COLUMNDLG_CAPTION : string = 'Column settings';
  STR_COLUMNDLG_LABEL1  : string = 'Check the columns you would like ' +
    'to make visible in this Folder.  Drag and Drop to reorder the columns. ';
  STR_COLUMNDLG_LABEL2  : string = 'The selected column should be ';
  STR_COLUMNDLG_LABEL3  : string = 'pixels wide';
  STR_COLUMNDLG_CHECKBOXLIVEUPDATE : string = 'LiveUpdate';
  STR_COLUMNDLG_BUTTONOK     : string = 'OK';
  STR_COLUMNDLG_BUTTONCANCEL : string = 'Cancel';

    // Error given when the root of VET is set to a path that does not exist.  The
  // end user should never see this message.
  STR_ERR_INVALID_CUSTOMPATH: string = 'Invalid pathname for Custom Root Path';

  // Menu item text shown when the column popup menu has more than a specified
  // number of items or the column has told VET it should not be shown in the
  // menu but only show it in the dialog box.
  STR_COLUMNMENU_MORE: string = 'More ...';

    // --------------------------------------------------------------------------
  // TExplorerComboBox messages
  // --------------------------------------------------------------------------

  S_PATH_ERROR: string = 'Invalid Path';
  S_COMBOEDIT_DEFAULT_ERROR1: string = ' can not be found by Windows. Please check the spelling and try again.';
  // --------------------------------------------------------------------------

    // --------------------------------------------------------------------------
  // VirtualShellNewMenu strings
  // --------------------------------------------------------------------------
  // The string used as a prefix to the new file being created based on the file type
  // of the extension.  For example a Notepad TXT file will create a new file named
  // New Text Document.txt, where the "New " string is this constant.
  S_NEW: string = 'New ';
  // These are the strings that will be appended to New when the additional menu
  // item "New Folder" and "New ShortCut" are requested in the menu.
  S_FOLDER: string = 'Folder';
  S_SHORTCUT: string = 'Shortcut';
  // This is the string that is shown in the Messagebox if the new file will
  // overwrite an existing file.
  S_OVERWRITE_EXISTING_FILE: string = 'File exists.  Overwrite existing file?';

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
  VET_NOTIFY_EVENTS: array[0..19] of string = (
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
  STR_UNKNOWNCOMMAN: string = 'Unknown Command';


  STR_DRIVELETTER_A: string = 'a';

  // --------------------------------------------------------------------------
  // Common strings
  // --------------------------------------------------------------------------

  S_PRINT: string = 'print';
  S_PROPERTIES: string = 'properties';

  // --------------------------------------------------------------------------


  // ASSERT Strings
  S_KERNELNOTIFERREGISTERED: string = 'A KernelChangeNotifier is still registered with a Control';
  S_SHELLNOTIFERREGISTERED: string = 'A ShellChangeThread is still registered with a Control';
  S_SHELLNOTIFERDISPATCHTHREAD: string = 'ChangeDispatchThread is still registered';
  S_KERNELSPECIALFOLDERWATCH: string = 'A control must be registered with ' +
     'the VirtualChangeNotifier using RegisterShellChangeNotify before this ' +
     'method may be used.';

implementation

end.
