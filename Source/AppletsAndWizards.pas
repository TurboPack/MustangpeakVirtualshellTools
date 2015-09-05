unit AppletsAndWizards;

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

interface

//  Version 1.0.1
//
{ Jim Kueneman                                                          01.01.02 }
{ Software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,     }
{ either express or implied.                                                     }
{ The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>      }

{ Word of warning on the Return values of most of these functions.  They are    }
{ Boolean based on the result of WinExec.  The rundll32.exe will always run but }
{ the applet may not be present.  As such the result of the function is in NO   }
{ WAY representive of if the dialog actually popuped up.                        }
{                                                                               }
{ A future enhancement of this would be to incorporate a Execute And Wait       }
{ feature to the class.                                                         }
{                                                                               }
{ This unit encapsulates a number of shell dialogs and Windows property dialogs }
{ through the rundll32.exe applet/dll launch program and some undocumented SHxx }
{ functions.  Some applets allow the user to select a particular page in the    }
{ dialog.  Since the number of pages and layout of the dialogs changes with     }
{ each version of Windows the function allows a "Page" number to be passed.     }
{ These are "normal" pages for common dialogs, other will just have to be trial }
{ and error, most of this stuff is not documented so it can change, and does    }
{                                                                               }
{  Accessability Dialog                                                         }
{       Keyboard = 0                                                            }
{       Sound    = 1                                                            }
{       Display  = 2                                                            }
{       Mouse    = 3                                                            }
{       General  = 4                                                            }
{                                                                               }
{  Add/Remove Programs Dialog                                                   }
{       Install/Uninstall = 0                                                   }
{       Windows Setup     = 1                                                   }
{       Startup Disk      = 2                                                   }
{                                                                               }
{  Internet Settings Dialog                                                     }
{       General    = 0                                                          }
{       Security   = 1                                                          }
{       Content    = 2                                                          }
{       Connection = 3                                                          }
{       Programs   = 4                                                          }
{       Advanced   = 5                                                          }
{                                                                               }
{  Multimedia Settings Dialog                                                   }
{       Sound Settings   = 0                                                    }
{       Audio            = 1                                                    }
{       Video            = 2                                                    }
{       MIDI             = 3                                                    }
{       CDMUSIC          = 4                                                    }
{       Advanced Devices = 5                                                    }
{                                                                               }
{  Regional Settings Dialog                                                     }
{   NOTE: XP handles this differently thus these are of little use              }
{       Regional Settings = 0                                                   }
{       Number            = 1                                                   }
{       Currency          = 2                                                   }
{       Time              = 3                                                   }
{       Date              = 4                                                   }
{       Local Inputs      = 5                                                   }
{                                                                               }
{  Screen Settings Dialog                                                       }
{       Background   = 0                                                        }
{       Screen Saver = 1                                                        }
{       Appearance   = 2                                                        }
{       Settings     = 3                                                        }
{                                                                               }
{  System Settings Dialog                                                       }
{       This dialog is *highly* dependant on the operation system as to what    }
{       the title of the page may be.                                           }
{               This is Win2k sp 2                                              }
{               General      = 0                                                }
{               Network ID   = 1                                                }
{               Hardware     = 2                                                }
{               User Profile = 3                                                }
{               Advanced     = 4                                                }
{       WinXP has several more, WinNT4 different names etc.                     }
{                                                                               }
{  Time/Date Settings Dialog                                                    }
{       General   = 0                                                           }
{       Time Zone = 1                                                           }
{                                                                               }



uses
  Windows, Messages, SysUtils, Graphics, Controls, ShellAPI,
  ShlObj, Classes, Forms, MPShellUtilities;

resourcestring
  S_CONTROLPANEL = 'rundll32.exe shell32.dll,Control_RunDLL';

  { MultiPage Settings Dialogs }
  S_ACCESSABILITY = ' access.cpl'; // Add 1 - 5 to end of string to select initial page
  S_ADDREMOVEPROGRAM = ' appwiz.cpl'; // Add 0 - 2 to end of string to select initial page
  S_DISPLAYSETTINGS = ' desk.cpl'; // Add 0 - 3 to end of string to select initial page
  S_INTERNETCONNECTION = ' inetcpl.cpl'; // Add 0 - 5 to end of string to select initial page
  S_MULITMEDIA = ' mmsys.cpl'; // Add 0 - 4 to end of string to select initial page
  S_REGIONALSETTINGS = ' intl.cpl';  // Add 0 - 5 to end of string to select initial page
  S_SYSTEMSETTINGS = ' sysdm.cpl'; // Add 1 - 5 to end of string to select initial page
  S_TIMEDATE = ' timedate.cpl';
  { Modem Dialog }
  S_MODEM = ' modem.cpl';
  S_DIALINGPROPERTIES = ' telephon.cpl'; // WinNT only
  { Modem Dialog END}
  S_CONTROLPANELITEM = ' main.cpl @'; // Add 0 - 3 to end of string to select item
  S_FASTFIND = ' findfast.cpl';
  S_JOYSTICK = ' joy.cpl';
  S_SOUND = ' mmsys.cpl @1';
  S_EXCHANGEOUTLOOKPROPERTIES = ' mlcfg32.cpl';
  S_MAILPOSTOFFICE = ' wgpocpl.cpl';
  S_NETWORKCONFIG_NT = ' ncpa.cpl';
  S_NETWORKCONFIG_9X = ' netcpl.cpl';
  S_NETWORKSHARE = 'rundll32.exe ntlanui.dll,'; // Add ShareCreate or ShareManage  NT ONLY
  S_ODBCADMINISTRATOR = ' odbccp32.cpl';
  S_CHANGEPASSWORD = ' password.cpl'; // Win9x only
  S_COMPORTS = ' ports.cpl'; // WinNT only
  S_SERVERPROPERTIES = ' srvmgr.cpl'; // WinNT only
  S_ADDNEWHARDWARE = ' sysdm.cpl @1'; // Win9x only
  S_THEMEPROPERTIES = ' themes.cpl';
  S_UPS_POWEROPTIONS = ' ups.cpl'; // WinNT only
  S_TWEAKUI = ' tweakui.cpl';

  S_ADDNEWPRINTER = 'rundll32.exe shell32.dll,SHHelpShortcuts_RunDLL AddPrinter'; // Win9x only
  S_DISPLAYINSTALLSCREENSAVER = 'rundll32.exe desk.cpl,InstallScreenSaver ';
  S_DIALUPWIZARD = 'rundll32.exe rnaui.dll,RnaWizard'; // Wi9x only
  S_OPENWITH = 'rundll32.exe shell32.dll,OpenAs_RunDLL d:\path\filename.ext';
  S_DISKCOPY = 'rundll32 diskcopy.dll,DiskCopyRunDll';
  S_VIEWFONTS = 'rundll32.exe shell32.dll,SHHelpShortcuts_RunDLL FontsFolder';
  S_VIEWPRINTERS = 'rundll32.exe shell32.dll,SHHelpShortcuts_RunDLL PrintersFolder';
  S_CREATESHORTCUT = 'rundll32 AppWiz.Cpl,NewLinkHere ';

const
  { SHFormatDisk Constants }

  {$EXTERNALSYM SHFMT_NOFORMAT}
  SHFMT_NOFORMAT = $FFFFFFFD; // Drive is not formatable.
  {$EXTERNALSYM SHFMT_CANCEL}
  SHFMT_CANCEL = $FFFFFFFE;   // Last format was canceled.
  {$EXTERNALSYM SHFMT_ERROR}
  SHFMT_ERROR = $FFFFFFFF;   // Error, but drive may be formatable.

  { SHRunFileDlg Contants }

  {$EXTERNALSYM RFF_NOBROWSE}
  RFF_NOBROWSE      = $01;   // Removes the browse button.
  {$EXTERNALSYM RFF_NODEFAULT}
  RFF_NODEFAULT     = $02;   // No default item selected.
  {$EXTERNALSYM RFF_CALCDIRECTORY}
  RFF_CALCDIRECTORY = $04;   // Determines the work directory from the file name.
  {$EXTERNALSYM RFF_NOLABEL}
  RFF_NOLABEL       = $08;   // Removes the edit box label.
  {$EXTERNALSYM RFF_NOSEPARATEMEM}
  RFF_NOSEPARATEMEM = $20;   // Removes the Separate Memory check box (NT Only).

  {$EXTERNALSYM RFN_VALIDATE}
  RFN_VALIDATE      = -510;  // Notification code in WM_NOTIFY

  {$EXTERNALSYM RF_OK}
  RF_OK             = $00; // Allow the application to run.
  {$EXTERNALSYM RF_CANCEL}
  RF_CANCEL         = $01; // Cancel operation; close the dialog.
  {$EXTERNALSYM RF_RETRY}
  RF_RETRY          = $02; // Cancel operation; leave dialog open.

type
  PRunFileDlgA = ^TNM_RunFileDlgA;
  TNM_RunFileDlgA = {$IFNDEF CPUX64}packed{$ENDIF} record
    Hdr: TNMHdr;
    lpFile: PAnsiChar;
    lpDirectory: PAnsiChar;
    nShow: LongBool;
  end;

  PRunFileDlgW = ^TNM_RunFileDlgW;
  TNM_RunFileDlgW = {$IFNDEF CPUX64}packed{$ENDIF} record
    Hdr: TNMHdr;
    lpFile: PWideChar;
    lpDirectory: PWideChar;
    nShow: LongBool;
  end;

type
  TCmdShow = (
    swHide,              // Hides the window and activates another window.
    swMaximize,          // Maximizes the specified window.
    swMinimize,          // Minimizes the specified window and activates the next top-level window in the Z order.
    swRestore,           // Activates and displays the window. If the window is minimized or maximized, Windows restores it to its original size and position. An application should specify this flag when restoring a minimized window.
    swShow,              // Activates the window and displays it in its current size and position.
    swShowDefault,       // Sets the show state based on the SW_ flag specified in the STARTUPINFO structure passed to the CreateProcess function by the program that started the application.
    swShowMinimized,     // Activates the window and displays it as a minimized window.
    swShowMinNoActive,   // Displays the window as a minimized window. The active window remains active.
    swShowNA,            // Displays the window in its current state. The active window remains active.
    swShowNoActive,      // Displays a window in its most recent size and position. The active window remains active.
    swShowNormal         // Activates and displays a window. If the window is minimized or maximized, Windows
  );

  TControlPanel = (
    ciControlPanel,
    ciMouse,
    ciKeyboard,
    ciJoyStick,
    ciFastFind,
    ciSound,
    ciNetworkConfig,
    ciODBCAdmin,
    ciChangePassword,           // Win9x Only
    ciComPorts,                 // NT Only
    ciServerProperties,         // NT Only
    ciAddNewHardware,           // Win9x Only
    ciAddNewPrinter,            // Win9x Only
    ciThemeProperties,
    ciUPS_PowerOptions,         // NT Only
    ciTweakUI                   // if installed
  );

  TShareWizard = (
    swCreate,
    swManage
  );

  TMicrosoftApp = (
    maOutlookExchangeProp,
    maMailPostOffice
  );

  TMiscApplets = (
    maOpenWith,
    maDiskCopy,
    msViewFonts,
    msViewPrinters,
    msDialupWizard              // Win9x Only
  );

  TModemSettings = (
    msModemOptions,
    msDialingProperties         // NT Only
  );

  TSystemDialogs = (
    sdFormatDrives
  );

  TSHFormatDriveCode = (
    fdNoError,
    fdNotFormatable,
    fdCancel,
    fdError
  );

  TVirtualRunFileDialogOption = (
    roNoBrowse,           // Removes Browse button
    roNoDefault,          // No default item selected.
    roCalDirectory,       // Determines the work directory from the file name.
    roNoLabel,            // Removes the edit box label.
    roNoSeparateMem       // Removes the Separate Memory check box (NT Only).
  );
  TVirtualRunFileDialogOptions = set of TVirtualRunFileDialogOption;

  TRunFileResult = (
    frOk,               // Allow the file to be run
    frCancel,           // Cancel the file about to be run
    frRetry             // Ask for another file
  );

type
  TAppletsAndWizards = class(TObject)
  private
    FCmdShow: TCmdShow;
    FShowErrorCodes: Boolean;
  protected
    function Launch(S: AnsiString): Boolean; overload;
    function Launch(const S: string): Boolean; overload;
    function DecodeCmdShow(ACmdShow: TCmdShow): Longword;
    function EncodeCmdShow(SW_CODE: Longword): TCmdShow;
    function SelectPage(Command: string; Page: integer): Boolean;
  public
    constructor Create;
    function AccessabilityDialog(Page: integer): Boolean;
    function AddRemoveProgramsDialog(Page: integer): Boolean;
    function ControlPanel(Item: TControlPanel): Boolean;
    function CreateNewShortcut(Path: WideString): Boolean;
    function DisplayPropertiesDialog(Page: integer): Boolean;
    function SHFindComputer: Boolean;
    function SHFindFiles(Root, FilterSample: TNamespace): Boolean;
    function SHFormatDrive(DriveLetter: Char): TSHFormatDriveCode;
    function SHPickIconDialog(var FileName: WideString; var IconIndex: LongWord): Boolean;
    procedure SHRunFileDialog(Window: HWnd; Icon: HIcon; WorkingPath, Caption, Description: WideString; Options: TVirtualRunFileDialogOptions);
    function InstallScreenSaver(ScreenSaver: string): Boolean;
    function InternetSettingsDialog(Page: integer): Boolean;
    function MicrosoftApps(App: TMicrosoftApp): Boolean;
    function MiscApplets(Applet: TMiscApplets): Boolean;
    function ModemSettingsDialog(Page: TModemSettings): Boolean;
    function MultimediaSettingsDialog(Page: integer): Boolean;
    function NetworkShare(Wizard: TShareWizard): Boolean;
    function RegionalSettingsDialog(Page: integer): Boolean;
    function SystemSettingsDialog(Page: integer): Boolean;
    function TimeDateDialog(Page: integer): Boolean;

    property CmdShow: TCmdShow read FCmdShow write FCmdShow;
    property ShowErrorCodes: Boolean read FShowErrorCodes write FShowErrorCodes;
  end;


  TOnRunFile = procedure(RunFile, WorkingDirectory: string; var Result: TRunFileResult) of object;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualRunFileDialog = class(TComponent)
  private
    FOptions: TVirtualRunFileDialogOptions;
    FDescription: string;
    FCaption: string;
    FWorkingPath: string;
    FIcon: TIcon;
    FFileToRun: string;
    FHiddenWnd: HWnd;
    FOnRunFile: TOnRunFile;
    FPosition: TPoint;
    procedure SetIcon(const Value: TIcon);
  protected
    procedure DoRunFile(RunFile, WorkingDirectory: string; var Result: TRunFileResult);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Run;
    procedure WindowProc(var Message: TMessage);

    property HiddenWnd: HWnd read FHiddenWnd write FHiddenWnd;
  published
    property Caption: string read FCaption write FCaption;
    property Description: string read FDescription write FDescription;
    property FileToRun: string read FFileToRun write FFileToRun;
    property Icon: TIcon read FIcon write SetIcon;
    property OnRunFile: TOnRunFile read FOnRunFile write FOnRunFile;
    property Options: TVirtualRunFileDialogOptions read FOptions write FOptions;
    property Position: TPoint read FPosition write FPosition;
    property WorkingPath: string read FWorkingPath write FWorkingPath;
  end;

var
   Applets: TAppletsAndWizards;


implementation

var
  FormatDrive: function(Owner: HWND; Drive: UINT; FormatID: UINT; OptionFlags: UINT): DWORD; stdcall;
  PickIconDlg: function(Owner: HWND; FileName: Pointer; MaxFileNameChars: DWORD; var IconIndex: DWORD): LongBool; stdcall;
  RunFileDlg: procedure (Owner: HWND; IconHandle: HICON; WorkPath: Pointer; Caption: Pointer; Description: Pointer; Flags: UINT); stdcall;
  FindFiles:  function(SearchRoot: PItemIDList; SavedSearchFile: PItemIDList): LongBool; stdcall;
  FindComputer: function(Reserved1: PItemIDList; Reserved2: PItemIDList): LongBool; stdcall;

  ShellDLL: HMODULE;

{ TAppletsAndWizards }

function TAppletsAndWizards.AccessabilityDialog(Page: integer): Boolean;
begin
  { This one is odd it is 1 indexed }
  Result := SelectPage(S_CONTROLPANEL + S_ACCESSABILITY, Page + 1);
end;

function TAppletsAndWizards.AddRemoveProgramsDialog(Page: integer): Boolean;
begin
  Result := SelectPage(S_CONTROLPANEL + S_ADDREMOVEPROGRAM, Page);
end;

function TAppletsAndWizards.ControlPanel(Item: TControlPanel): Boolean;
begin
  case Item of
    ciControlPanel:
        Result := Launch(S_CONTROLPANEL);
    ciMouse, ciKeyboard:
        Result := Launch(S_CONTROLPANEL + S_CONTROLPANELITEM + IntToStr(Ord(Item) - 1));
    ciJoyStick:
        Result := Launch(S_CONTROLPANEL + S_JOYSTICK);
    ciFastFind:
        Result := Launch(S_CONTROLPANEL + S_FASTFIND);
    ciSound:
        Result := Launch(S_CONTROLPANEL + S_SOUND);
    ciNetworkConfig:
        if Win32Platform = VER_PLATFORM_WIN32_NT then
          Result := Launch(S_CONTROLPANEL + S_NETWORKCONFIG_NT)
        else
          Result := Launch(S_CONTROLPANEL + S_NETWORKCONFIG_9X);
    ciODBCAdmin:
        Result := Launch(S_CONTROLPANEL + S_ODBCADMINISTRATOR);
    ciChangePassword:
        if Win32Platform = VER_PLATFORM_WIN32_NT then
           Result := False
         else
           Result := Launch(S_CONTROLPANEL + S_CHANGEPASSWORD);
    ciComPorts:
        if Win32Platform = VER_PLATFORM_WIN32_NT then
           Result := Launch(S_CONTROLPANEL + S_COMPORTS)
         else
           Result := False;
    ciServerProperties:
        if Win32Platform = VER_PLATFORM_WIN32_NT then
          Result := Launch(S_CONTROLPANEL + S_SERVERPROPERTIES)
         else
           Result := False;
    ciAddNewHardware:
        if Win32Platform = VER_PLATFORM_WIN32_NT then
           Result := False
         else
           Result := Launch(S_CONTROLPANEL + S_ADDNEWHARDWARE);
    ciAddNewPrinter:
        if Win32Platform = VER_PLATFORM_WIN32_NT then
           Result := False
         else
           Result := Launch(S_ADDNEWPRINTER);
    ciThemeProperties:
        Result := Launch(S_CONTROLPANEL + S_THEMEPROPERTIES);
    ciUPS_PowerOptions:
        if Win32Platform = VER_PLATFORM_WIN32_NT then
          Result := Launch(S_CONTROLPANEL + S_UPS_POWEROPTIONS)
         else
           Result := False;
    ciTweakUI:
      Result := Launch(S_CONTROLPANEL + S_TWEAKUI)
  else
    Result := False;
  end;
end;

constructor TAppletsAndWizards.Create;
begin
  FCmdShow := swShowNormal;
  FShowErrorCodes := True;
end;

function TAppletsAndWizards.CreateNewShortcut(Path: WideString): Boolean;
begin
  Result := Launch(S_CREATESHORTCUT + Path);
end;

function TAppletsAndWizards.DecodeCmdShow(ACmdShow: TCmdShow): Longword;
begin
  case ACmdShow of
    swHide:             Result := SW_HIDE;
    swMaximize:         Result := SW_MAXIMIZE;
    swMinimize:         Result := SW_MINIMIZE;
    swRestore:          Result := SW_RESTORE;
    swShow:             Result := SW_SHOW;
    swShowDefault:      Result := SW_SHOWDEFAULT;
    swShowMinimized:    Result := SW_SHOWMINIMIZED;
    swShowMinNoActive:  Result := SW_SHOWMINNOACTIVE;
    swShowNA:           Result := SW_SHOWNA;
    swShowNoActive:     Result := SW_SHOWNOACTIVATE;
    swShowNormal:       Result := SW_SHOWNORMAL;
  else
    Result := SW_SHOWNORMAL
  end
end;

function TAppletsAndWizards.DisplayPropertiesDialog(Page: integer): Boolean;
begin
  Result := SelectPage(S_CONTROLPANEL + S_DISPLAYSETTINGS, Page);
end;

function TAppletsAndWizards.EncodeCmdShow(SW_CODE: Longword): TCmdShow;
begin
  case SW_CODE of
    SW_HIDE:            Result := swHide;
    SW_MAXIMIZE:        Result := swMaximize;
    SW_MINIMIZE:        Result := swMinimize;
    SW_RESTORE:         Result := swRestore;
    SW_SHOW:            Result := swShow;
    SW_SHOWDEFAULT:     Result := swShowDefault;
    SW_SHOWMINIMIZED:   Result := swShowMinimized;
    SW_SHOWMINNOACTIVE: Result := swShowMinNoActive;
    SW_SHOWNA :         Result := swShowNA;
    SW_SHOWNOACTIVATE : Result := swShowNoActive;
    SW_SHOWNORMAL:      Result := swShowNormal;
  else
    Result := swShowNormal
  end;
end;

function TAppletsAndWizards.InstallScreenSaver(ScreenSaver: string): Boolean;
begin
  Result := Launch(S_DISPLAYINSTALLSCREENSAVER + ScreenSaver);
end;

function TAppletsAndWizards.InternetSettingsDialog(Page: integer): Boolean;
begin
  Result := SelectPage(S_CONTROLPANEL + S_INTERNETCONNECTION, Page);
end;

function TAppletsAndWizards.Launch(S: AnsiString): Boolean;
begin
  Result := WinExec(PAnsiChar(S), DecodeCmdShow(CmdShow)) > 31;
  if not Result and ShowErrorCodes then
    RaiseLastOSError;
end;

function TAppletsAndWizards.Launch(const s: string): Boolean;
begin
  Result := Launch(AnsiString(S));
end;

function TAppletsAndWizards.MicrosoftApps(App: TMicrosoftApp): Boolean;
begin
  case App of
    maOutlookExchangeProp:
        Result := Launch(S_CONTROLPANEL + S_EXCHANGEOUTLOOKPROPERTIES);
    maMailPostOffice:
        Result := Launch(S_CONTROLPANEL + S_MAILPOSTOFFICE);
  else
    Result := False
  end
end;

function TAppletsAndWizards.MiscApplets(Applet: TMiscApplets): Boolean;
begin
  case Applet of
    maOpenWith: Result := Launch(S_OPENWITH);
    maDiskCopy: Result := Launch(S_DISKCOPY);
    msViewFonts: Result := Launch(S_VIEWFONTS);
    msViewPrinters: Result := Launch(S_VIEWPRINTERS);
    msDialUpWizard: Result := Launch(S_DIALUPWIZARD)
  else
    Result := False
  end
end;

function TAppletsAndWizards.ModemSettingsDialog(Page: TModemSettings): Boolean;
begin
  case Page of
    msModemOptions:
        Result := Launch(S_CONTROLPANEL + S_MODEM);

    msDialingProperties:
        if Win32Platform = VER_PLATFORM_WIN32_NT then
          Result := Launch(S_CONTROLPANEL + S_DIALINGPROPERTIES)
        else
          Result := Launch(S_CONTROLPANEL + S_MODEM)
  else
    Result := Launch(S_CONTROLPANEL + S_MODEM)
  end
end;

function TAppletsAndWizards.MultimediaSettingsDialog(Page: integer): Boolean;
begin
  { This seems to be off by 1. 0 is Sound and 1 is Audio in Win2k }
  Result := SelectPage(S_CONTROLPANEL + S_MULITMEDIA, Page);
end;

function TAppletsAndWizards.NetworkShare(Wizard: TShareWizard): Boolean;
begin
  Result := False;
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    case Integer(Wizard) of
      0: Launch(S_NETWORKSHARE + 'ShareCreate');
      1: Launch(S_NETWORKSHARE + 'ShareManage');
    end
end;


function TAppletsAndWizards.RegionalSettingsDialog(Page: integer): Boolean;
begin
  Result := SelectPage(S_CONTROLPANEL + S_REGIONALSETTINGS, Page);
end;

function TAppletsAndWizards.SelectPage(Command: string; Page: integer): Boolean;
begin
  if Page > -1 then
    Result := Launch(Command + ',,' + IntToStr(Page))
  else
    Result := Launch(Command);
end;

function TAppletsAndWizards.SHFindComputer: Boolean;
begin
  { Parameters ignored }
  if Assigned(FindComputer) then
    Result := FindComputer(nil, nil)
  else
    Result := False;
end;

function TAppletsAndWizards.SHFindFiles(Root, FilterSample: TNamespace): Boolean;

{ To use the Filter an *EXISTING* file must be used, you can't use wildcards    }
{ To use a sample file do this to filter of *.txt files :                       }

//   NS := TNamespace.CreateFromFileName('C:\MyDir\SomeFile.txt');
//   Applets.SHFindFiles(DrivesFolder, NS);
//   NS.Free;

var
  PIDL1, PIDL2: PItemIDList;
begin
  if Assigned(FindFiles) then
  begin
    PIDL1 := nil;
    PIDL2 := nil;
    { Shell does not keep Root PIDL }
    if Assigned(Root) then
      PIDL1 := Root.AbsolutePIDL;
    { Per Holderness, Shell keeps second PIDL unless of an error }
    if Assigned(FilterSample) then
      PIDL2 := PIDLMgr.CopyPIDL(FilterSample.AbsolutePIDL);
    Result := FindFiles(PIDL1, PIDL2);
    { Per Holderness, if error we must free second PIDL }
    if not Result then
      PIDLMgr.FreePIDL(PIDL2);
  end else
    Result := False;
end;

function TAppletsAndWizards.SHFormatDrive(
  DriveLetter: Char): TSHFormatDriveCode;
{ There are ways to set up the dialog box checkboxes but they are either broken }
{ or backward in WinNT so lets not even try to support it.                      }
begin
  if Assigned(FormatDrive) then
  begin
    case FormatDrive(Application.Handle, Ord(UpCase(DriveLetter)) - $41, 0, 0) of
      SHFMT_NOFORMAT: Result := fdNotFormatable;
      SHFMT_CANCEL: Result := fdCancel;
      SHFMT_ERROR: Result := fdError;
    else
      Result := fdNoError
    end
  end else
    Result := fdError;
end;

function TAppletsAndWizards.SHPickIconDialog(var FileName: WideString;
  var IconIndex: LongWord): Boolean;
{ Returns False if User Canceled                                                }
{ The user may browse to a different file so check the filename on return       }
var
  s: AnsiString;
  OldLen: integer;
begin
  if Assigned(PickIconDlg) then
  begin
    IconIndex := 0;
    OldLen := Length(FileName);
    if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
    begin
      s := AnsiString(FileName);
      SetLength(s, MAX_PATH);
      s[OldLen + 1] := #0;
    end else
    begin
      SetLength(FileName, MAX_PATH);
      FileName[OldLen + 1] := #0;
    end;
    if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
      Result := PickIconDlg(Application.Handle, PWideChar(FileName), MAX_PATH, IconIndex);
      SetLength(FileName, lstrLenW(PWideChar(FileName)));
    end else
    begin
      Result := PickIconDlg(Application.Handle, PAnsiChar(s), MAX_PATH, IconIndex);
      SetLength(s, lstrLenA(PAnsiChar(s)));
      FileName := string(s)
    end
  end else
    Result := False;
end;

procedure TAppletsAndWizards.SHRunFileDialog(Window: HWnd; Icon: HIcon; WorkingPath, Caption,
  Description: WideString; Options: TVirtualRunFileDialogOptions);

{ To monitor what file is being run and to cancel or force a retry use the      }
{ TPickIconDlg component with the OnRunFile event.                              }
{ The component also gives more flexablilty in positioning of the dialog.       }

var
  DescriptionA, WorkingPathA, CaptionA: AnsiString;
  Flags: Longword;
begin
  if Assigned(PickIconDlg) then
  begin
    Flags := 0;
    if roNoBrowse in Options then       // Removes Browse button
      Flags := Flags or RFF_NOBROWSE;
    if roNoDefault in Options then      // No default item selected.
      Flags := Flags or RFF_NODEFAULT;
    if roCalDirectory in Options then   // Determines the work directory from the file name.
      Flags := Flags or RFF_CALCDIRECTORY;
    if roNoLabel in Options then        // Removes the edit box label.
      Flags := Flags or RFF_NOLABEL;
    if Win32Platform = VER_PLATFORM_WIN32_NT then
      if roNoSeparateMem in Options then  // Removes the Separate Memory check box (NT Only).
        Flags := Flags or RFF_NOSEPARATEMEM;

    if Window = 0 then
      Window := Application.Handle;
    if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
      RunFileDlg(Window, Icon, PWideChar(WorkingPath), PWideChar(Caption),
        PWideChar(Description), Flags);
    end else
    begin
      WorkingPathA := AnsiString(WorkingPath);
      CaptionA := AnsiString(Caption);
      DescriptionA := AnsiString(Description);
      RunFileDlg(Window, Icon, PAnsiChar(WorkingPathA), PAnsiChar(CaptionA),
        PAnsiChar(DescriptionA), Flags);
    end
  end
end;

function TAppletsAndWizards.SystemSettingsDialog(Page: integer): Boolean;
begin
  Result := SelectPage(S_CONTROLPANEL + S_SYSTEMSETTINGS, Page);
end;

function TAppletsAndWizards.TimeDateDialog(Page: integer): Boolean;
begin
  case Page of
    0: Result := Launch(S_CONTROLPANEL + S_TIMEDATE);
    1:   Result := Launch(S_CONTROLPANEL + S_TIMEDATE + ',,/f');
  else
    Result := False
  end
end;

{ TVirtualRunFileDialog }

constructor TVirtualRunFileDialog.Create(AOwner: TComponent);
begin
  inherited;
  FIcon := TIcon.Create;
end;

destructor TVirtualRunFileDialog.Destroy;
begin
  Icon.Free;
  inherited;
end;

procedure TVirtualRunFileDialog.DoRunFile(RunFile, WorkingDirectory: string;
  var Result: TRunFileResult);
begin
  if Assigned(OnRunFile) then
    OnRunFile(RunFile, WorkingDirectory, Result);
end;

procedure TVirtualRunFileDialog.Run;
const
  SizeFlag = SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOSIZE;
begin
  Assert(WorkingPath <> '', 'WorkingPath not set for TVirtualRunFileDialog.Run');
  HiddenWnd := Classes.AllocateHWnd(WindowProc);
  SetWindowPos(HiddenWnd, 0, Position.x, Position.y, 0, 0, SizeFlag);
  Applets.SHRunFileDialog(HiddenWnd, Icon.Handle, WorkingPath, Caption, Description, Options);
  Classes.DeallocateHWnd(HiddenWnd);
end;

procedure TVirtualRunFileDialog.SetIcon(const Value: TIcon);
begin
  Icon.Assign(Value);
end;

procedure TVirtualRunFileDialog.WindowProc(var Message: TMessage);
var
  RunFileDlgA: PRunFileDlgA;
  RunFileDlgW: PRunFileDlgW;
  TempFilePathA, TempWorkingDirA: AnsiString;
  TempFilePathW, TempWorkingDirW: WideString;
  RunResult: TRunFileResult;   
begin
  case message.Msg of
    WM_NOTIFY:
       begin
         if Win32Platform = VER_PLATFORM_WIN32_NT then
         begin
           RunFileDlgW := PRunFileDlgW( TWMNotify( message).NMHdr);
           if RunFileDlgW.Hdr.code = RFN_VALIDATE then
           begin
             SetLength(TempFilePathW, lstrlenW(RunFileDlgW.lpFile));
             MoveMemory(PWideChar(TempFilePathW), PWideChar(RunFileDlgW.lpFile), Length(TempFilePathW) * 2);
             SetLength(TempWorkingDirW, lstrlenW(RunFileDlgW.lpDirectory));
             MoveMemory(PWideChar(TempWorkingDirW), PWideChar(RunFileDlgW.lpDirectory), Length(TempWorkingDirW) * 2);
             RunResult := frOk;
             DoRunFile(TempFilePathW, TempWorkingDirW, RunResult);
           end;
         end else
         begin
           RunFileDlgA := PRunFileDlgA( TWMNotify( message).NMHdr);
           if RunFileDlgA.Hdr.code = RFN_VALIDATE then
           begin
             SetLength(TempFilePathA, lstrlenA(RunFileDlgA.lpFile));
             lstrcpyA(PAnsiChar(TempFilePathA), RunFileDlgA.lpFile);
             SetLength(TempWorkingDirA, lstrlenA(RunFileDlgA.lpDirectory));
             lstrcpyA(PAnsiChar(TempWorkingDirA), RunFileDlgA.lpDirectory);
             RunResult := frOk;
             DoRunFile(string(TempFilePathA), string(TempWorkingDirA), RunResult);
           end;
         end;
         case RunResult of
           frOk:     message.Result := RF_OK;
           frCancel: message.Result := RF_CANCEL;
           frRetry:  message.Result := RF_RETRY;
         end;
       end;
  else
    message.Result := DefWindowProc(HiddenWnd, message.Msg, message.wParam, message.lParam);
  end;
end;

initialization

  ShellDLL := GetModuleHandleA(PAnsiChar(Shell32));
  if ShellDll <> 0 then
  begin
    FormatDrive := GetProcAddress(ShellDLL, AnsiString('SHFormatDrive'));
    PickIconDlg := GetProcAddress(ShellDLL, PAnsiChar(62));
    RunFileDlg := GetProcAddress(ShellDLL, PAnsiChar(61));
    FindFiles := GetProcAddress(ShellDLL, PAnsiChar(90));
    FindComputer := GetProcAddress(ShellDLL, PAnsiChar(91));
  end;
  Applets := TAppletsAndWizards.Create;

finalization
  Applets.Free;

end.
