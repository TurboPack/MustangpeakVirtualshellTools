unit VirtualShellNewMenu;

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

{ Implements a Popupmenu that displays and executes the NewFile menu in Explorer }
{ It is necessary to override the OnCreateNewFile event and return a path were   }
{ the new file is to be created.  By default the component will create its own   }
{ unique name for the file, in Explorer style, but it is possible to return the  }
{ new name of the file as desired in the event.  It is not necessary to add the  }
{ extenstion since it is already known!                                          }
{                                                                                }
{ NOTE:
{   MemProof will report a hord of Registry errors but they are not really errors}
{ MemProof looks for Win32 Error return codes and since we are trying to open    }
{ nonexistant keys, and lots of them, the return is an error and MemProof records}
{ every one of them.  This is indicated by the round red error icon.  If it was a }
{ leak then it would have a "Registry" icon next too it, all this is per Atanas  }

//
// 7.2.02
//      - Added an "After File Create" event to allow the new node to be selected
//        for editing after it is created
//      - NOTE THERE ARE SOME NON UNICODE AWARE FUNCTIONS IN THIS UNIT LOOK IT OVER
//

interface

{$include ..\Include\AddIns.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Menus, Registry, ShlObj, ShellAPI, ImgList, VirtualResources,
  MPShellUtilities, MPCommonObjects,
  MPCommonUtilities,
  {$IFDEF USE_TOOLBAR_TB2K}
  TB2Item,
  {$ENDIF}
  Contnrs,
  CommCtrl;

{ Type defines how the ShellNew item is to create a new file.                   }
{ Null =        A 0 Byte length file, easy.                                     }
{ FileName =    Either a path to a file to copy as the new file (renamed) or a  }
{               file that is found under the ShellNew directory in the Windows  }
{               directory.  Either way the file is copied and renamed.          }
{ Data =        A file is created the the Data is copied into the file as the   }
{               the default file for the assiciated application.                }
{ Command =     A command that should be run with ShellExecute.                 }
{                                                                               }
{ nmk_Folder and nmk_Shortcut are for special menu item to mimic the Explorer   }
{ "New" Menu.                                                                   }
type
  TNewShellKind = (nmk_Unknown, nmk_Null, nmk_FileName,nmk_Command, nmk_Data, nmk_Folder,
    nmk_Shortcut);

{ This class encapsulates all the information that is stored under the ShellNew }
{ key for a particular registered file extension. The NewMenuKind property will }
{ dictate which of the Data, FileName, Command or NullFile properties contain   }
{ valid infomation.                                                             }
type

  TVirtualShellNewMenu = class;      // forward
  TVirtualShellNewMenuItem = class;


  TVirtualShellNewItem = class(TObject)
  strict private
    FData: Pointer;                // If the file is created using Data in the registry
    FDataSize: integer;            // Size of the Data
    FExtension: string;        // Extension of the file
    FFileType: string;         // String used for the Menu Text
    FNewShellKind: TNewShellKind;  // The method to create the new file
    FSpecialTxt: Boolean;
    FSystemImageIndex: integer;    // Index of the associated icon in the system imagelist
    FNewShellKindStr: string;  // The string associate with the create method, depends on FNewShellKind
    FOwner: TVirtualShellNewMenuItem;
  public
    procedure CreateNewDocument(const APopupMenu: TVirtualShellNewMenu; ANewFileTargetPath: string; const AFileName: string);
    procedure FreeData;
    function IsBriefcase: Boolean;
    function IsCreateLink: Boolean;

    property Data: Pointer read FData write FData;
    property DataSize: integer read FDataSize write FDataSize;
    destructor Destroy; override;
    property Extension: string read FExtension write FExtension;
    property FileType: string read FFileType write FFileType;
    property NewShellKind: TNewShellKind read FNewShellKind write FNewShellKind;
    property NewShellKindStr: string read FNewShellKindStr write FNewShellKindStr;
    property Owner: TVirtualShellNewMenuItem read FOwner write FOwner;
    property SpecialTxt: Boolean read FSpecialTxt write FSpecialTxt;
    property SystemImageIndex: integer read FSystemImageIndex write FSystemImageIndex;
  end;

{ TMenuItem that knows how to handle a TVirtualShellNewItem }

  TVirtualShellNewMenuItem = class(TMenuItem)
  private
    FShellNewInfo: TVirtualShellNewItem;
    FOwnerMenu: TVirtualShellNewMenu;// Owner PopupMenu
  public
    procedure Click; override;
    destructor Destroy; override;
    property OwnerMenu: TVirtualShellNewMenu read FOwnerMenu write FOwnerMenu;
    property ShellNewInfo: TVirtualShellNewItem read FShellNewInfo write FShellNewInfo;
  end;

{ TList that knows how to handle TVirtualShellNewItems }

  TVirtualShellNewItemList = class(TObjectList)
  private
    function GetItems(Index: Integer): TVirtualShellNewItem;
    procedure PutItems(Index: Integer; const Value: TVirtualShellNewItem);
  public
    procedure BuildList;
    function IsDuplicate(TestItem: TVirtualShellNewItem): Boolean;
    procedure StripDuplicates;
    property Items[Index: Integer]: TVirtualShellNewItem read GetItems write PutItems; default;
  end;

  TOnAddMenuItem = procedure(Sender: TPopupMenu; const NewMenuItem: TVirtualShellNewItem; var Allow: Boolean) of object;
  TOnCreateNewFile = procedure(Sender: TMenu; const NewMenuItem: TVirtualShellNewItem; var Path, FileName: string; var Allow: Boolean) of object;
  TOnAfterFileCreate = procedure(Sender: TMenu; const NewMenuItem: TVirtualShellNewItem; const FileName: string) of object;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualShellNewMenu = class(TPopupMenu)
  private
    FShellNewItems: TVirtualShellNewItemList;
    FDefaultAction: TBasicAction;
    FOnAddMenuItem: TOnAddMenuItem;
    FSystemImages: TImageList;
    FOnCreateNewFile: TOnCreateNewFile;
    FUseShellImages: Boolean;
    FCombineLikeItems: Boolean;
    FWarnOnOverwrite: Boolean;
    FNewShortcutItem: Boolean;
    FNewFolderItem: Boolean;
                             // Combine any items that have the same menu name (for example HTML documents with *.htm and *.html extensions)
                              // (for example HTML documents with *.htm and *.html extensions)
                              // If they are not combined then the same menu Text is used with the unique
                              // extension added to it i.e. HTML Document (.htm) and HTML Document (.html)
    FOnAfterFileCreate: TOnAfterFileCreate;

    function GetImages: TCustomImageList;
    procedure SetImages(const Value: TCustomImageList);
    procedure SetUseShellImages(const Value: Boolean);
    {$IFDEF USE_TOOLBAR_TB2K}
    procedure OnTB2KMenuItemClick(Sender: TObject);
    {$ENDIF}
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateMenuItems(ParentItem: TMenuItem);
    procedure DoAddMenuItem(NewMenuItem: TVirtualShellNewItem; var Allow: Boolean); dynamic;
    procedure DoAfterFileCreate(NewMenuItem: TVirtualShellNewItem; FileName: string); dynamic;
    procedure DoCreateNewFile(NewMenuItem: TVirtualShellNewItem; var Path, FileName: string; var Allow: Boolean);

    property ShellNewItems: TVirtualShellNewItemList read FShellNewItems;
    property SystemImages: TImageList read FSystemImages write FSystemImages;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Populate(Item: TMenuItem);
    {$IFDEF USE_TOOLBAR_TB2K}
    procedure Populate_TB2000(MenuItem: TTBCustomItem; ItemClass, SeparatorItemClass: TTBCustomItemClass); virtual;
    procedure RebuildMenu_TB2000(MenuItem: TTBCustomItem; ItemClass: TTBCustomItemClass);
    procedure CreateMenuItems_TB2000(MenuItem: TTBCustomItem; ItemClass: TTBCustomItemClass);
    {$ENDIF}
    procedure Popup(X, Y: Integer); override;
    procedure RebuildMenu;
  published
    { Published declarations }
    property CombineLikeItems: Boolean read FCombineLikeItems write FCombineLikeItems default False;
    property DefaultAction: TBasicAction read FDefaultAction write FDefaultAction;
    property Images: TCustomImageList read GetImages write SetImages;
    property OnAddMenuItem: TOnAddMenuItem read FOnAddMenuItem  write FOnAddMenuItem;
    property OnAfterFileCreate: TOnAfterFileCreate read FOnAfterFileCreate write FOnAfterFileCreate;
    property OnCreateNewFile: TOnCreateNewFile read FOnCreateNewFile write FOnCreateNewFile;
    property NewFolderItem: Boolean read FNewFolderItem write FNewFolderItem default False;
    property NewShortcutItem: Boolean read FNewShortcutItem write FNewShortcutItem default False;
    property UseShellImages: Boolean read FUseShellImages write SetUseShellImages default True;
    property WarnOnOverwrite: Boolean read FWarnOnOverwrite write FWarnOnOverwrite;
  end;

implementation

uses
  System.IOUtils;

resourcestring
  STextDocument = 'Text Document';

{ TVirtualShellNewItem }

procedure TVirtualShellNewItem.CreateNewDocument(const APopupMenu: TVirtualShellNewMenu; ANewFileTargetPath: string; const AFileName: string);
var
  lHandle: THandle;
  lNewFileSourcePath: string;
  lOldChar: WideChar;
  lParams: string;
  lPath: string;
  lShellCmd: string;
  lSkip: Boolean;
  lTail: PWideChar;
  lTemplateFound: Boolean;
begin
  if not DirectoryExists(ANewFileTargetPath) then
    Exit;

  ANewFileTargetPath := IncludeTrailingPathDelimiter(ANewFileTargetPath);
  if AFileName.IsEmpty then
  begin
    if NewShellKind <> nmk_Folder then
      ANewFileTargetPath := UniqueFileName(ANewFileTargetPath + S_NEW + FileType + Extension)
    else
      ANewFileTargetPath := UniqueDirName(ANewFileTargetPath + S_NEW + FileType)
  end
  else
  begin
    if NewShellKind <> nmk_Folder then
      ANewFileTargetPath := ANewFileTargetPath + WideStripExt(AFileName) + Extension
    else
      ANewFileTargetPath := ANewFileTargetPath + AFileName;
  end;

  lSkip := False;
  if APopupMenu.WarnOnOverwrite then
  begin
    if FileExists(ANewFileTargetPath) then
      lSkip := MessageBox(Application.Handle, PWideChar(S_WARNING),
        PWideChar(S_OVERWRITE_EXISTING_FILE), MB_OKCANCEL or MB_ICONWARNING) = IDCANCEL
  end;
  if lSkip then
    Exit;

  case NewShellKind of
    nmk_Null:
    begin
      lHandle := FileCreate(ANewFileTargetPath);
      if lHandle <> INVALID_HANDLE_VALUE then
      begin
        SHChangeNotify(SHCNE_CREATE, SHCNF_PATHW, PWideChar(ANewFileTargetPath), nil);
        FileClose(lHandle);
      end;
    end;
    nmk_FileName:
    begin
      lTemplateFound := False;
      { This is where the template should be }
      if Assigned(TemplatesFolder) then
      begin
        lNewFileSourcePath := TemplatesFolder.NameParseAddress + '\' + NewShellKindStr;
        lTemplateFound := FileExists(lNewFileSourcePath);
      end;

      {NEW: Some Programs like WinRAR store the templates elsewhere (like in their own programdirectory)}
      {So check if NewShellKindStr points directly to a template and - if yes - use it ...}
      if not lTemplateFound then
      begin
        lNewFileSourcePath := NewShellKindStr;
        lTemplateFound := FileExists(lNewFileSourcePath);
      end;

      { Microsoft can't seem to even get its applications to follow the rules   }
      { Some Templates are in the old ShellNew folder in the Windows directory. }
      if not lTemplateFound then
      begin
        lNewFileSourcePath := WindowsDirectory + '\ShellNew\' + NewShellKindStr;
        lTemplateFound := FileExists(lNewFileSourcePath);
      end;
      if lTemplateFound then
      begin
        CopyFile(PWideChar( lNewFileSourcePath), PWideChar( ANewFileTargetPath), True);
        SHChangeNotify(SHCNE_CREATE, SHCNF_PATHW, PWideChar(ANewFileTargetPath), nil);
      end
      else if SpecialTxt then
      begin
        TFile.Create(ANewFileTargetPath).Free;
        SHChangeNotify(SHCNE_CREATE, SHCNF_PATHW, PWideChar(ANewFileTargetPath), nil);
      end;
    end;
    nmk_Data:
    begin
      lHandle := FileCreate(ANewFileTargetPath);

      if lHandle <> INVALID_HANDLE_VALUE then
      try
        // should work for Unicode
        FileWrite(lHandle, Data^, DataSize)
      finally
        FileClose(lHandle);
        SHChangeNotify(SHCNE_CREATE, SHCNF_PATHW, PWideChar(ANewFileTargetPath), nil);
      end
    end;
    nmk_Command:
    begin
      if IsBriefcase then
      { The Briefcase is a special case that we need to be careful with     }
      begin
        { Strip the *.bfc extension from the file name }
        ANewFileTargetPath := WideStripExt(ANewFileTargetPath);
        { This is a bit of a hack.  The true Command string in Win2k looks  }
        { like:                                                             }
        {  %SystemRoot%\system32\rundll32.exe %SystemRoot%\system32\syncui.dll,Briefcase_Create %2!d! %1 }
        { This is undocumented as the the parameters but in Win2k and XP if }
        { You pass a lPath of the new Briefcase for %1 and then set %2 to a  }
        { number > 0 then a Briefcase will be created in the passed folder. }
        { In Win9x the param are reversed and the string is filled in:      }
        { c:\Windows\System\rundll32.exe c:\Windows\System\\syncui.dll,Briefcase_Create %1!d! %2 }
        { In this OS it is not necessary to change the %1 to 1? Oh well     }
        { Undocumented Shell fun at its best.                               }
        lPath := SystemDirectory + S_RUNDLL32;
        if not FileExists(lPath) then
          lPath := WindowsDirectory + S_RUNDLL32;
        WideShellExecute(Application.Handle, S_OPEN, lPath,
          S_BRIEFCASE_HACK_STRING + ANewFileTargetPath, '')
      end 
	  else
      begin
        NewShellKindStr := Trim(NewShellKindStr);
        if Length(NewShellKindStr) > 1 then
        begin
          if NewShellKindStr[1] = '"' then
          begin
            lTail := @NewShellKindStr[2];
            while (lTail^ <> string('"')) and (lTail^ <> WideNull) do
              Inc(lTail, 1);
            if lTail^ = string('"') then
            begin
              Inc(lTail, 1);
              lOldChar := lTail^;
              lTail^ := WideNull;
              lShellCmd := PWideChar( NewShellKindStr);
              lParams := '';
              lTail^ := lOldChar;
              if lTail^ <> WideNull then
              begin
                lParams := lTail;
                lParams := Trim(lParams)
              end
            end;
          end;
        end;
        lParams := StringReplace(lParams, '%1', ExtractFilePath(ANewFileTargetPath), [rfReplaceAll, rfIgnoreCase]);
        SpecialVariableReplacePath(lShellCmd);
        WideShellExecute(Application.Handle, S_OPEN, lShellCmd, lParams, '')
      end;
    end;
    nmk_Folder:
    begin
      CreateDir(ANewFileTargetPath);
    end;
    nmk_Shortcut:
    begin
      ANewFileTargetPath := IncludeTrailingPathDelimiter( ExtractFilePath(ANewFileTargetPath)) + S_NEW + S_SHORTCUT + '.lnk';
      lHandle := FileCreate(ANewFileTargetPath);
      if lHandle <> INVALID_HANDLE_VALUE then
      begin
        SHChangeNotify(SHCNE_CREATE, SHCNF_PATHW, PWideChar(ANewFileTargetPath), nil);
        FileClose(lHandle);
      end;
      WideShellExecute(Application.Handle, 'open', 'rundll32.exe', 'appwiz.cpl,NewLinkHere ' + ANewFileTargetPath, '')
    end;
  end;
  if Assigned(Owner) and Assigned(Owner.OwnerMenu) then
    Owner.OwnerMenu.DoAfterFileCreate(Self, ANewFileTargetPath);
end;

destructor TVirtualShellNewItem.Destroy;
begin
  FreeData;
  inherited;
end;

procedure TVirtualShellNewItem.FreeData;
begin
  if (DataSize > 0) and Assigned(Data) then
    FreeMem(Data, DataSize);
  Data := nil;
  DataSize := 0
end;

function TVirtualShellNewItem.IsBriefcase: Boolean;
begin
  Result := (Pos(S_BRIEFCASE_IDENTIFIER, NewShellKindStr) > 0)
end;

function TVirtualShellNewItem.IsCreateLink: Boolean;
begin
  Result := (Pos(S_CREATELINK_IDENTIFIER, NewShellKindStr) > 0)
end;

{ TVirtualShellNewItemList }

procedure TVirtualShellNewItemList.BuildList;
const
  cExtLnk = '.lnk';
  cExtTxt = '.txt';
  cPathDelim = '\';
  cThreshold = 20;

    { Only handle the first level extension keys, except for the lnk files }
    function IsValidExtKey(const AKey: string): Boolean;
    const
      cWildCard = '*';
    begin
      Result := False;
      if not AKey.IsEmpty then
      begin
        Result := ((AKey.Chars[0] = '.') or (AKey.Chars[0] = cWildCard)) and
          not SameText(AKey, cExtLnk)
      end;
    end;

var
  lAddedTxt: Boolean;
  lCount: Integer;
  lData: Pointer;
  lDataSize: Integer;
  lDefaultKey: string;
  lFileCreateType: string;
  lFileInfoW: TSHFileInfoW;
  lMenuText: string;
  lMenuTextTxt: string;
  lNewShellLink: TNewShellKind;
  lNewShellNewItem: TVirtualShellNewItem;
  lOldCursor: TCursor;
  lReg: TRegistry;
  lRegList: TStringList;
  lRegStr: string;
  lShellNewKeyPath: string;
begin
  Clear;
  lReg := nil;
  lRegList := nil;
  lOldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    lReg := TRegistry.Create;
    lRegList := TStringList.Create;
    lReg.RootKey := HKEY_CLASSES_ROOT;
    if not lReg.OpenKeyReadOnly(string.Empty) then
      Exit;

    { Read in all the level 1 keys under HKEY_CLASSES_ROOT }
    lReg.GetKeyNames(lRegList);
    lReg.CloseKey;
    lRegList.Sorted := True;
    lAddedTxt := False;
    lMenuTextTxt := string.Empty;
    for lRegStr in lRegList  do
    begin
      { Only work on extension keys not the extention type keys }
      if not IsValidExtKey(lRegStr) then
        Continue;
     { Open the extension key }
      lShellNewKeyPath := lRegStr;
      if not lReg.OpenKeyReadOnly(lShellNewKeyPath) then
        Continue;

      { Read the default text. This is the pointer to the extension type  }
      { key further down in the list OR it may be another key that        }
      { contains the ShellNew key                                         }
      lDefaultKey := lReg.ReadString(string.Empty);
      lReg.CloseKey;
      { Try to open the extension type pointed to by the extension type   }
      { key, and read the File Type Name to be used for creating the new  }
      { file and for use for the menu text.                               }
      if lReg.OpenKeyReadOnly(lDefaultKey) then
      begin
        lMenuText := lReg.ReadString(string.Empty);
        lReg.CloseKey;
      end
      else
        lMenuText := string.Empty;

      if SameText(lRegStr, cExtTxt) then
        lMenuTextTxt := lMenuText;

      { Check to see if it was a pointer to a sub key, with a saftety out }
      lCount := 0;
      while (not lDefaultKey.IsEmpty) and (lCount < cThreshold) do
      begin
        if lReg.OpenKeyReadOnly(lShellNewKeyPath + cPathDelim + lDefaultKey) then
        begin
          lShellNewKeyPath := lShellNewKeyPath + cPathDelim + lDefaultKey;
          lDefaultKey := lReg.ReadString(string.Empty);
          lReg.CloseKey;
        end
        else
          lDefaultKey := string.Empty;
        Inc(lCount);
      end;

      { Try to open the ShellNew subkey under the lShellNewKeyPath key     }
      if lMenuText.IsEmpty then
        Continue;

      if not lReg.OpenKeyReadOnly(lShellNewKeyPath + S_SHELLNEW_PATH) then
        Continue;

      lNewShellLink := nmk_Unknown;
      lFileCreateType := string.Empty;
      lData := nil;
      lDataSize := 0;

      if lReg.GetDataType(S_NULLFILE) = rdString then
      begin
        lFileCreateType := lReg.ReadString(S_NULLFILE);
        lNewShellLink := nmk_Null
      end
      else if lReg.GetDataType(S_FILENAME) = rdString then
      begin
        lFileCreateType := lReg.ReadString(S_FILENAME);
        lNewShellLink := nmk_FileName
      end
      else if lReg.GetDataType(S_COMMAND) = rdString then
      begin
        lFileCreateType := lReg.ReadString(S_COMMAND);
        lNewShellLink := nmk_Command
      end
      else if lReg.GetDataType(S_COMMAND) = rdExpandString  then
      begin
        lFileCreateType := lReg.ReadString(S_COMMAND);
        lNewShellLink := nmk_Command
      end
      else if lReg.GetDataType(S_DATA) = rdBinary then
      begin
        lDataSize := lReg.GetDataSize(S_DATA);
        GetMem(lData, lDataSize);
        if lDataSize = lReg.ReadBinaryData(S_DATA, lData^, lDataSize) then
          lNewShellLink := nmk_Data
      end;
      if lNewShellLink <> nmk_Unknown then
      begin
        lNewShellNewItem := TVirtualShellNewItem.Create;
        lNewShellNewItem.Extension := lRegStr;
        lNewShellNewItem.FileType := lMenuText;
        lNewShellNewItem.NewShellKind := lNewShellLink;
        lNewShellNewItem.NewShellKindStr := lFileCreateType;
        lNewShellNewItem.Data := lData;
        lNewShellNewItem.DataSize := lDataSize;
        if SHGetFileInfo(PWideChar(lNewShellNewItem.Extension),
                         FILE_ATTRIBUTE_NORMAL,
                         lFileInfoW,
                         SizeOf(lFileInfoW),
                         SHGFI_USEFILEATTRIBUTES or
                         SHGFI_SHELLICONSIZE or
                         SHGFI_ICON or
                         SHGFI_SYSICONINDEX) > 0 then
          lNewShellNewItem.SystemImageIndex := lFileInfoW.iIcon;
        Add(lNewShellNewItem);
        if SameText(lRegStr, cExtTxt) then
          lAddedTxt := True;
      end;
      lReg.CloseKey;
    end;

    //Special case for .txt files
    if lAddedTxt then
      Exit;

    lNewShellNewItem := TVirtualShellNewItem.Create;
    lNewShellNewItem.Extension := cExtTxt;
    if lMenuTextTxt.IsEmpty then
      lMenuTextTxt := STextDocument;
    lNewShellNewItem.FileType := lMenuTextTxt;
    lNewShellNewItem.NewShellKind := TNewShellKind.nmk_FileName;
    lNewShellNewItem.NewShellKindStr := string.Empty;
    lNewShellNewItem.Data := nil;
    lNewShellNewItem.DataSize := 0;
    lNewShellNewItem.SpecialTxt := True;
    if SHGetFileInfo(PWideChar(lNewShellNewItem.Extension),
                     FILE_ATTRIBUTE_NORMAL,
                     lFileInfoW,
                     SizeOf(lFileInfoW),
                     SHGFI_USEFILEATTRIBUTES or
                     SHGFI_SHELLICONSIZE or
                     SHGFI_ICON or
                     SHGFI_SYSICONINDEX) > 0 then
      lNewShellNewItem.SystemImageIndex := lFileInfoW.iIcon;
    Add(lNewShellNewItem);

  finally
    Screen.Cursor := lOldCursor;
    lReg.Free;
    lRegList.Free;
  end;
end;

function TVirtualShellNewItemList.GetItems(Index: Integer): TVirtualShellNewItem;
begin
  Result := TVirtualShellNewItem(inherited Items[Index]);
end;

procedure TVirtualShellNewItemList.PutItems(Index: Integer;
  const Value: TVirtualShellNewItem);
begin
  inherited Items[Index] := Value
end;

procedure TVirtualShellNewItemList.StripDuplicates;
var
  i, j: integer;
  TestItem: TVirtualShellNewItem;
begin
  for i := Count - 1 downto 0 do
  begin
    TestItem := Items[i];
    for j := Count - 1 downto 0 do
    begin
      { Don't count the test item if it is in the list }
      if Items[j] <> TestItem then
        if AnsiCompareStr(Items[j].FileType, TestItem.FileType) = 0 then
        begin
          Items[j].Free;
          Delete(j);
        end;
    end;
  end;
end;

function TVirtualShellNewItemList.IsDuplicate(TestItem: TVirtualShellNewItem): Boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to Count - 1 do
  begin
    if TestItem <> Items[i] then
    begin
      Result := AnsiCompareStr(Items[i].FileType, TestItem.FileType) = 0;
      if Result then
        Break
    end
  end;
end;

{ TVirtualShellNewMenuItem }

procedure TVirtualShellNewMenuItem.Click;
var
  Path, FileName: string;
  Allow: Boolean;
begin
  inherited;
  Allow := True;
  OwnerMenu.DoCreateNewFile(ShellNewInfo, Path, FileName, Allow);
  if Allow then
    ShellNewInfo.CreateNewDocument(OwnerMenu, Path, FileName);
end;

destructor TVirtualShellNewMenuItem.Destroy;
begin
  ShellNewInfo.Free;
  inherited
end;

{ TVirtualShellNewMenu }

constructor TVirtualShellNewMenu.Create(AOwner: TComponent);
begin
  inherited;
  // ShellNewItems does not own the Namespaces.
  // TVirtualShellNewMenuItem will free all the Namespaces
  // when it is destroyed.
  FShellNewItems := TVirtualShellNewItemList.Create(False);
  SystemImages := SmallSysImages;
  UseShellImages := True;
end;

procedure TVirtualShellNewMenu.CreateMenuItems(ParentItem: TMenuItem);
var
  i: integer;
  NewMenuItem: TVirtualShellNewMenuItem;
  Allow: Boolean;
begin
  if CombineLikeItems then
    ShellNewItems.StripDuplicates;
  if NewFolderItem then
  begin
    NewMenuItem := TVirtualShellNewMenuItem.Create(Self);
    NewMenuItem.OwnerMenu := Self;
    NewMenuItem.ShellNewInfo := TVirtualShellNewItem.Create;
    NewMenuItem.ShellNewInfo.Owner := NewMenuItem;
    NewMenuItem.ShellNewInfo.NewShellKind := nmk_Folder;
    NewMenuItem.ShellNewInfo.FileType := S_FOLDER;
    NewMenuItem.Action := DefaultAction;
    NewMenuItem.ImageIndex := DefaultSystemImageIndex(diNormalFolder);
    NewMenuItem.Caption := S_NEW + S_FOLDER;
    DoAddMenuItem(NewMenuItem.ShellNewInfo, Allow);
    if Allow then
      ParentItem.Add(NewMenuItem)
    else
      NewMenuItem.Free;
  end;
  if NewShortcutItem then
  begin
    NewMenuItem := TVirtualShellNewMenuItem.Create(Self);
    NewMenuItem.OwnerMenu := Self;
    NewMenuItem.ShellNewInfo := TVirtualShellNewItem.Create;
    NewMenuItem.ShellNewInfo.Owner := NewMenuItem;
    NewMenuItem.ShellNewInfo.NewShellKind := nmk_Shortcut;
    NewMenuItem.ShellNewInfo.FileType := S_SHORTCUT;
    NewMenuItem.Action := DefaultAction;
    NewMenuItem.ImageIndex := DefaultSystemImageIndex(diLink);
    NewMenuItem.Caption := S_NEW + S_SHORTCUT;
    DoAddMenuItem(NewMenuItem.ShellNewInfo, Allow);
    if Allow then
      ParentItem.Add(NewMenuItem)
    else
      NewMenuItem.Free;
  end;
  if ParentItem.Count > 0 then
  begin
    NewMenuItem := TVirtualShellNewMenuItem.Create(Self);
    NewMenuItem.OwnerMenu := Self;
    NewMenuItem.Action := DefaultAction;
    NewMenuItem.ImageIndex := 5;
    NewMenuItem.Caption := '-';
    ParentItem.Add(NewMenuItem)
  end;
  for i := 0 to ShellNewItems.Count - 1 do
  begin
    DoAddMenuItem(ShellNewItems[i], Allow);
    if Allow then
    begin
      NewMenuItem := TVirtualShellNewMenuItem.Create(Self);
      NewMenuItem.OwnerMenu := Self;
      NewMenuItem.ShellNewInfo := ShellNewItems[i];
      ShellNewItems[i].Owner := NewMenuItem;
      NewMenuItem.Action := DefaultAction;
      NewMenuItem.ImageIndex := NewMenuItem.ShellNewInfo.SystemImageIndex;
      { Save some time here. If the list has been stripped of duplicates IsDuplicate is always false }
      if not CombineLikeItems and ShellNewItems.IsDuplicate(ShellNewItems[i]) then
        NewMenuItem.Caption := NewMenuItem.ShellNewInfo.FileType + '  (' + NewMenuItem.ShellNewInfo.Extension + ')'
      else
         NewMenuItem.Caption := NewMenuItem.ShellNewInfo.FileType;
      ParentItem.Add(NewMenuItem)
    end
  end;
  ShellNewItems.Clear; // Turned over ShellNewInfo objects to menu items
end;

destructor TVirtualShellNewMenu.Destroy;
begin
  ShellNewItems.Free;
  inherited;
end;

procedure TVirtualShellNewMenu.DoAddMenuItem(NewMenuItem: TVirtualShellNewItem;
  var Allow: Boolean);
begin
  Allow := True;
  if Assigned(OnAddMenuItem) then
    OnAddMenuItem(Self, NewMenuItem, Allow);
end;

procedure TVirtualShellNewMenu.DoAfterFileCreate(
  NewMenuItem: TVirtualShellNewItem; FileName: string);
begin
  if Assigned(OnAfterFileCreate) then
    OnAfterFileCreate(Self, NewMenuItem, FileName);
end;

procedure TVirtualShellNewMenu.DoCreateNewFile(NewMenuItem: TVirtualShellNewItem;
  var Path, FileName: string; var Allow: Boolean);
begin
  Path := '';
  FileName := '';
  if Assigned(OnCreateNewFile) then
    OnCreateNewFile(Self, NewMenuItem, Path, FileName, Allow);
end;

function TVirtualShellNewMenu.GetImages: TCustomImageList;
begin
  Result := inherited Images
end;

procedure TVirtualShellNewMenu.Populate(Item: TMenuItem);
begin
  Item.Clear;
  ShellNewItems.Clear;
  ShellNewItems.BuildList;
  CreateMenuItems(Item);
end;

{$IFDEF USE_TOOLBAR_TB2K}
procedure TVirtualShellNewMenu.OnTB2KMenuItemClick(Sender: TObject);
var
  M: TComponent;
begin
  if (Sender is TComponent) then begin
    M := Sender as TComponent;
    if M.Tag > -1 then
      Items[M.Tag].Click;
  end;
end;

procedure TVirtualShellNewMenu.Populate_TB2000(MenuItem: TTBCustomItem;
  ItemClass, SeparatorItemClass: TTBCustomItemClass);
var
  I: Integer;
  M: TTBCustomItem;
begin
  MenuItem.Clear;
  MenuItem.SubMenuImages := SmallSysImages;
  RebuildMenu;
//  RebuildMenu_TB2000(MenuItem, ItemClass);

  for I := 0 to Items.Count - 1 do begin
    if Items[I].Caption <> '-' then begin
      M := ItemClass.Create(nil);
      M.Caption := Items[I].Caption;
      M.Tag := I;
      M.ImageIndex := Items[I].ImageIndex;
      M.OnClick := OnTB2KMenuItemClick;
      M.Action := DefaultAction;
      MenuItem.Add(M);
    end
    else
      MenuItem.Add(SeparatorItemClass.Create(nil));
  end;

  // We still use the old items for the implementation of the click.  Don't clear
  // them
end;
{$ENDIF}

procedure TVirtualShellNewMenu.Popup(X, Y: Integer);
begin
  RebuildMenu;
  inherited;
end;

procedure TVirtualShellNewMenu.RebuildMenu;
begin
  Items.Clear;
  ShellNewItems.Clear;
  ShellNewItems.BuildList;
  CreateMenuItems(Items);
end;

procedure TVirtualShellNewMenu.SetImages(const Value: TCustomImageList);
begin
  inherited Images := Value;
  if Value <> SystemImages then
    FUseShellImages := False;
end;

procedure TVirtualShellNewMenu.SetUseShellImages(const Value: Boolean);
begin
  FUseShellImages := Value;
  if Value then
    Images := SystemImages
  else
    Images := nil;
end;

{$IFDEF USE_TOOLBAR_TB2K}
procedure TVirtualShellNewMenu.RebuildMenu_TB2000(MenuItem: TTBCustomItem;
  ItemClass: TTBCustomItemClass);
begin
  MenuItem.Clear;

  ShellNewItems.Clear;
  ShellNewItems.BuildList;
  CreateMenuItems_TB2000(MenuItem, ItemClass);
end;

procedure TVirtualShellNewMenu.CreateMenuItems_TB2000(
  MenuItem: TTBCustomItem; ItemClass: TTBCustomItemClass);
//var
 // i: integer;
 // NewMenuItem: TVirtualShellNewMenuItem;
 // Allow: Boolean;
begin
 (*if CombineLikeItems then
    ShellNewItems.StripDuplicates;
  if NewFolderItem then
  begin
    NewMenuItem := TVirtualShellNewMenuItem.Create(Self);
    NewMenuItem.OwnerMenu := Self;
    NewMenuItem.ShellNewInfo := TVirtualShellNewItem.Create;
    NewMenuItem.ShellNewInfo.Owner := NewMenuItem;
    NewMenuItem.ShellNewInfo.NewShellKind := nmk_Folder;
    NewMenuItem.ShellNewInfo.FileType := S_FOLDER;
    NewMenuItem.Action := DefaultAction;
    NewMenuItem.ImageIndex := DefaultSystemImageIndex(diNormalFolder);
    NewMenuItem.Caption := S_NEW + S_FOLDER;
    DoAddMenuItem(NewMenuItem.ShellNewInfo, Allow);
    if Allow then
      ParentItem.Add(NewMenuItem)
    else
      NewMenuItem.Free;
  end;
  if NewShortcutItem then
  begin
    NewMenuItem := TVirtualShellNewMenuItem.Create(Self);
    NewMenuItem.OwnerMenu := Self;
    NewMenuItem.ShellNewInfo := TVirtualShellNewItem.Create;
    NewMenuItem.ShellNewInfo.Owner := NewMenuItem;
    NewMenuItem.ShellNewInfo.NewShellKind := nmk_Shortcut;
    NewMenuItem.ShellNewInfo.FileType := S_SHORTCUT;
    NewMenuItem.Action := DefaultAction;
    NewMenuItem.ImageIndex := DefaultSystemImageIndex(diLink);
    NewMenuItem.Caption := S_NEW + S_SHORTCUT;
    DoAddMenuItem(NewMenuItem.ShellNewInfo, Allow);
    if Allow then
      ParentItem.Add(NewMenuItem)
    else
      NewMenuItem.Free;
  end;
  if ParentItem.Count > 0 then
  begin
    NewMenuItem := TVirtualShellNewMenuItem.Create(Self);
    NewMenuItem.OwnerMenu := Self;
    NewMenuItem.Action := DefaultAction;
    NewMenuItem.ImageIndex := 5;
    NewMenuItem.Caption := '-';
    ParentItem.Add(NewMenuItem)
  end;
  for i := 0 to ShellNewItems.Count - 1 do
  begin
    DoAddMenuItem(ShellNewItems[i], Allow);
    if Allow then
    begin
      NewMenuItem := TVirtualShellNewMenuItem.Create(Self);
      NewMenuItem.OwnerMenu := Self;
      NewMenuItem.ShellNewInfo := ShellNewItems[i];
      ShellNewItems[i].Owner := NewMenuItem;
      NewMenuItem.Action := DefaultAction;
      NewMenuItem.ImageIndex := NewMenuItem.ShellNewInfo.SystemImageIndex;
      { Save some time here. If the list has been stripped of duplicates IsDuplicate is always false }
      if not CombineLikeItems and ShellNewItems.IsDuplicate(ShellNewItems[i]) then
        NewMenuItem.Caption := NewMenuItem.ShellNewInfo.FileType + '  (' + NewMenuItem.ShellNewInfo.Extension + ')'
      else
         NewMenuItem.Caption := NewMenuItem.ShellNewInfo.FileType;
      ParentItem.Add(NewMenuItem)
    end
  end;
  ShellNewItems.Clear; // Turned over ShellNewInfo objects to menu items
*)
end;
{$ENDIF USE_TOOLBAR_TB2K}

end.

