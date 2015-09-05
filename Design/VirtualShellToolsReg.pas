unit VirtualShellToolsReg;
                   
// Version 2.3.0
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


interface

{$include Compilers.inc}
{$include ..\Include\AddIns.inc}

// If you are upgrading from VSTools 0.9.xx or earlier uncomment the conditional
// define.  By doing so the old components ExplorerTreeview, ExplorerListview,
// and ExplorerCombobox will also be installed in the palette.  This way your
// projects can be opened then show the form as text and change the TExplorerXXXX
// object types to TVirtualExplorerXXXXX then let Delphi update what it needs to
// by answering yes to the questions when the text is then shown again as a Form.
// I updated all the demos this way and it was suprisingly painless.

uses
  Windows, Messages, SysUtils, Classes, Controls,
  VirtualShellToolbar, VirtualExplorerTree, StdCtrls, MPShellUtilities,
  VirtualShellNewMenu, AppletsAndWizards, VirtualShellHistory,
  VirtualShellAutoComplete, VirtualSendToMenu, VirtualRedirector,
  VirtualExplorerEasyListview, VirtualFileSearch,
  VirtualExplorerEasyListModeview,
  {VirtualBreadCrumbBar}
    DesignIntf, DesignEditors;

procedure Register;

implementation

const
  sELVEnumerationCategory = 'Enumeration';
  sELVStorageCategory = 'Storage';
  sELVCustomCategory = 'Custom Columns and Groups';
  sELVRootCategory = 'Root Namespace';
  sELVShellCategory = 'Shell';
  sELVCustomClassesCategory = 'Custom Object Classes';

procedure Register;
begin
  // Unicode Controls
  RegisterComponents('Virtual Controls', [TWideSpeedButton]);
  RegisterComponents('VirtualShellTools', [TVirtualExplorerComboBox]);

  // Virtual Explorer Tree Components
  RegisterComponents('VirtualShellTools', [TVirtualExplorerTree, TVirtualExplorerTreeview,
    TVirtualExplorerListview, TVirtualDropStack]);

  // Virtual Virtual Shell Toolbar Components
  RegisterComponents('VirtualShellTools', [TVirtualShellToolbar, TVirtualDriveToolbar,
    TVirtualSpecialFolderToolbar]);

  // Assorted ShellTools Components
  RegisterComponents('VirtualShellTools', [TVirtualShellLink, TVirtualShellNewMenu,
    TVirtualShellHistory, TVirtualShellMRU, TVirtualShellAutoComplete, TVirtualSendToMenu,
    TVirtualFileSearch, TVirtualShellMultiParentContextMenu, TVirtualShellBackgroundContextMenu{,
    TVirtualBreadCrumbBar}]);

  // Applets, Wizards, and Shell Dialogs Components
  RegisterComponents('VirtualShellTools', [TVirtualRunFileDialog]);

  // Redirector Components
  RegisterComponents('VirtualShellTools', [TVirtualCommandLineRedirector,
    TVirtualRedirector]);

  // EasyListview Components
  RegisterComponents('VirtualShellTools', [TVirtualExplorerEasyListview,
   TVirtualMultiPathExplorerEasyListview, TVirtualColumnModeView]);

  RegisterPropertiesInCategory(sELVEnumerationCategory, TCustomVirtualExplorerEasyListview,
    ['OnEnum*'] );

  RegisterPropertiesInCategory(sELVStorageCategory, TCustomVirtualExplorerEasyListview,
    ['*Storage*'] );

  RegisterPropertiesInCategory(sELVCustomCategory, TCustomVirtualExplorerEasyListview,
    ['OnCustom*'] );

  RegisterPropertiesInCategory(sELVRootCategory, TCustomVirtualExplorerEasyListview,
    ['OnRoot*',
     'OnInvalidRoot*'] );

  RegisterPropertiesInCategory(sELVShellCategory, TCustomVirtualExplorerEasyListview,
    ['OnShell*'] );

  RegisterPropertiesInCategory(sELVCustomClassesCategory, TCustomVirtualExplorerEasyListview,
    ['On*Class'] );
end;

end.


