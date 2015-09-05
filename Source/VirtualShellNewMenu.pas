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
  {$IFDEF TNTSUPPORT}
  TntSysUtils,
  {$ENDIF}
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
  private
    FData: Pointer;                // If the file is created using Data in the registry
    FDataSize: integer;            // Size of the Data
    FExtension: WideString;        // Extension of the file
    FFileType: WideString;         // String used for the Menu Text
    FNewShellKind: TNewShellKind;  // The method to create the new file
    FSystemImageIndex: integer;    // Index of the associated icon in the system imagelist
    FNewShellKindStr: WideString;  // The string associate with the create method, depends on FNewShellKind
    FOwner: TVirtualShellNewMenuItem;
  public
    procedure CreateNewDocument(PopupMenu: TVirtualShellNewMenu; NewFileTargetPath, FileName: WideString);
    procedure FreeData;
    function IsBriefcase: Boolean;
    function IsCreateLink: Boolean;

    property Data: Pointer read FData write FData;
    property DataSize: integer read FDataSize write FDataSize;
    destructor Destroy; override;
    property Extension: WideString read FExtension write FExtension;
    property FileType: WideString read FFileType write FFileType;
    property NewShellKind: TNewShellKind read FNewShellKind write FNewShellKind;
    property NewShellKindStr: WideString read FNewShellKindStr write FNewShellKindStr;
    property Owner: TVirtualShellNewMenuItem read FOwner write FOwner;
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
  TOnCreateNewFile = procedure(Sender: TMenu; const NewMenuItem: TVirtualShellNewItem; var Path, FileName: WideString; var Allow: Boolean) of object;
  TOnAfterFileCreate = procedure(Sender: TMenu; const NewMenuItem: TVirtualShellNewItem; const FileName: WideString) of object;

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
    procedure DoAfterFileCreate(NewMenuItem: TVirtualShellNewItem; FileName: WideString); dynamic;
    procedure DoCreateNewFile(NewMenuItem: TVirtualShellNewItem; var Path, FileName: WideString; var Allow: Boolean);

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
  TypInfo, AnsiStrings;

{$IFDEF USE_TOOLBAR_TB2K}

procedure SetTBItemCaption(Item: TTBCustomItem; Caption: WideString);
// Set the unicode caption to the Item if it has a valid
// WideString Caption property.
var
  PropInfo: PPropInfo;
begin
  PropInfo := GetPropInfo(Item, 'Caption', [tkWString]);
  if PropInfo = nil then
    Item.Caption := Caption
  else
    SetWideStrProp(Item, PropInfo, Caption);
end;
{$ENDIF}

{ TVirtualShellNewItem }

procedure TVirtualShellNewItem.CreateNewDocument(PopupMenu: TVirtualShellNewMenu; NewFileTargetPath, FileName: WideString);
var
  Handle: THandle;
  TemplateFound: Boolean;
  Skip: Boolean;
  Path, ShellCmd, Params, NewFileSourcePath: WideString;
  Tail: PWideChar;
  OldChar: WideChar;
begin
  if WideDirectoryExists(NewFileTargetPath) then
  begin
    NewFileTargetPath := WideIncludeTrailingBackslash(NewFileTargetPath);
    if FileName = '' then
    begin
      if NewShellKind <> nmk_Folder then
        NewFileTargetPath := UniqueFileName(NewFileTargetPath + S_NEW + FileType + Extension)
      else
        NewFileTargetPath := UniqueDirName(NewFileTargetPath + S_NEW + FileType)
    end else
    begin
      if NewShellKind <> nmk_Folder then
        NewFileTargetPath := NewFileTargetPath + WideStripExt(FileName) + Extension
      else
        NewFileTargetPath := NewFileTargetPath + FileName
    end;

    Skip := False;
    if PopupMenu.WarnOnOverwrite then
    begin
      if FileExistsW(NewFileTargetPath) then
        Skip := WideMessageBox(Application.Handle, S_WARNING, S_OVERWRITE_EXISTING_FILE, MB_OKCANCEL or MB_ICONWARNING) = IDCANCEL
    end;
    if not Skip then
    begin
      case NewShellKind of
        nmk_Null:
          begin
            {$IFDEF TNTSUPPORT}
            Handle := WideFileCreate(NewFileTargetPath);
            {$ELSE}
            Handle := FileCreate(NewFileTargetPath);
            {$ENDIF}
            if Handle <> INVALID_HANDLE_VALUE then
            begin
              if IsUnicode then
                SHChangeNotify(SHCNE_CREATE, SHCNF_PATHW, PWideChar(NewFileTargetPath), nil)
              else
                SHChangeNotify(SHCNE_CREATE, SHCNF_PATHA, PAnsiChar( AnsiString( NewFileTargetPath)), nil);
              FileClose(Handle);
            end;
          end;
        nmk_FileName:
          begin
            TemplateFound := False;
            { This is where the template should be }
            if Assigned(TemplatesFolder) then
            begin
              NewFileSourcePath := TemplatesFolder.NameParseAddress + '\' + NewShellKindStr;
              TemplateFound := FileExistsW(NewFileSourcePath);
            end;

            {NEW: Some Programs like WinRAR store the templates elsewhere (like in their own programdirectory)}
            {So check if NewShellKindStr points directly to a template and - if yes - use it ...}
            if not TemplateFound then
            begin
              NewFileSourcePath := NewShellKindStr;
              TemplateFound := FileExistsW(NewFileSourcePath);
            end;

            { Microsoft can't seem to even get its applications to follow the rules   }
            { Some Templates are in the old ShellNew folder in the Windows directory. }
            if not TemplateFound then
            begin
              NewFileSourcePath := WindowsDirectory + '\ShellNew\' + NewShellKindStr;
              TemplateFound := FileExistsW(NewFileSourcePath);
            end;
            if TemplateFound then
            begin
              if Assigned(CopyFileW_MP) then
                CopyFileW_MP(PWideChar( NewFileSourcePath), PWideChar( NewFileTargetPath), True)
              else
                CopyFileA(PAnsiChar( AnsiString( NewFileSourcePath)), PAnsiChar( AnsiString( NewFileTargetPath)), True);
              if IsUnicode then
                SHChangeNotify(SHCNE_CREATE, SHCNF_PATHW, PWideChar(NewFileTargetPath), nil)
              else
                SHChangeNotify(SHCNE_CREATE, SHCNF_PATHA, PAnsiChar( AnsiString( NewFileTargetPath)), nil);
            end;
          end;
        nmk_Data:
          begin
            {$IFDEF TNTSUPPORT}
            Handle := WideFileCreate(NewFileTargetPath);
            {$ELSE}
            Handle := FileCreate(NewFileTargetPath);
            {$ENDIF}

            if Handle <> INVALID_HANDLE_VALUE then
            try
              // should work for Unicode
              FileWrite(Handle, Data^, DataSize)
            finally
              FileClose(Handle);
              if IsUnicode then
                SHChangeNotify(SHCNE_CREATE, SHCNF_PATHW, PWideChar(NewFileTargetPath), nil)
              else
                SHChangeNotify(SHCNE_CREATE, SHCNF_PATHA, PAnsiChar( AnsiString( NewFileTargetPath)), nil);
            end
          end;
        nmk_Command:
          begin
            if IsBriefcase then
            { The Briefcase is a special case that we need to be careful with     }
            begin
              { Strip the *.bfc extension from the file name }
              NewFileTargetPath := WideStripExt(NewFileTargetPath);
              { This is a bit of a hack.  The true Command string in Win2k looks  }
              { like:                                                             }
              {  %SystemRoot%\system32\rundll32.exe %SystemRoot%\system32\syncui.dll,Briefcase_Create %2!d! %1 }
              { This is undocumented as the the parameters but in Win2k and XP if }
              { You pass a path of the new Briefcase for %1 and then set %2 to a  }
              { number > 0 then a Briefcase will be created in the passed folder. }
              { In Win9x the param are reversed and the string is filled in:      }
              { c:\Windows\System\rundll32.exe c:\Windows\System\\syncui.dll,Briefcase_Create %1!d! %2 }
              { In this OS it is not necessary to change the %1 to 1? Oh well     }
              { Undocumented Shell fun at its best.                               }
              Path := SystemDirectory + S_RUNDLL32;
              if not FileExistsW(Path) then
                Path := WindowsDirectory + S_RUNDLL32;
              WideShellExecute(Application.Handle, S_OPEN, Path,
                S_BRIEFCASE_HACK_STRING + NewFileTargetPath, '')
            end else
            begin
              NewShellKindStr := Trim(NewShellKindStr);
              if Length(NewShellKindStr) > 1 then
              begin
                if NewShellKindStr[1] = '"' then
                begin
                  Tail := @NewShellKindStr[2];
                  while (Tail^ <> WideString('"')) and (Tail^ <> WideNull) do
                    Inc(Tail, 1);
                  if Tail^ = WideString('"') then
                  begin
                    Inc(Tail, 1);
                    OldChar := Tail^;
                    Tail^ := WideNull;
                    ShellCmd := PWideChar( NewShellKindStr);
                    Params := '';
                    Tail^ := OldChar;
                    if Tail^ <> WideNull then
                    begin
                      Params := Tail;
                      Params := Trim(Params)
                    end
                  end;
                end;  
              end;
              Params := WideStringReplace(Params, '%1', WideExtractFilePath(NewFileTargetPath), [rfReplaceAll, rfIgnoreCase]);
              SpecialVariableReplacePath(ShellCmd);
              WideShellExecute(Application.Handle, S_OPEN, ShellCmd, Params, '')
            end
          end;
        nmk_Folder:
          begin
            WideCreateDir(NewFileTargetPath);
          end;
        nmk_Shortcut:
          begin
            NewFileTargetPath := WideIncludeTrailingBackslash( WideExtractFilePath(NewFileTargetPath)) + S_NEW + S_SHORTCUT + '.lnk';
            {$IFDEF TNTSUPPORT}
            Handle := WideFileCreate(NewFileTargetPath);
            {$ELSE}
            Handle := FileCreate(NewFileTargetPath);
            {$ENDIF}
            if Handle <> INVALID_HANDLE_VALUE then
            begin
              if IsUnicode then
                SHChangeNotify(SHCNE_CREATE, SHCNF_PATHW, PWideChar(NewFileTargetPath), nil)
              else
                SHChangeNotify(SHCNE_CREATE, SHCNF_PATHA, PAnsiChar( AnsiString( NewFileTargetPath)), nil);
              FileClose(Handle);
            end;
            WideShellExecute(Application.Handle, 'open', 'rundll32.exe', 'appwiz.cpl,NewLinkHere ' + NewFileTargetPath, '')
          end;
      end;
      if Assigned(Owner) then
        if Assigned(Owner.OwnerMenu) then
          Owner.OwnerMenu.DoAfterFileCreate(Self, NewFileTargetPath);
    end
  end
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
  Result := (AnsiPos(S_BRIEFCASE_IDENTIFIER, NewShellKindStr) > 0)
end;

function TVirtualShellNewItem.IsCreateLink: Boolean;
begin
  Result := (AnsiPos(S_CREATELINK_IDENTIFIER, NewShellKindStr) > 0)
end;

{ TVirtualShellNewItemList }

procedure TVirtualShellNewItemList.BuildList;

    { Only handle the first level extension keys, except for the lnk files }
    function IsValidExtKey(Key: AnsiString): Boolean;
    begin
      Result := False;
      if Length(Key) > 0 then
        Result := ((Key[1] = '.') or (Key[1] = '*')) and
          (System.AnsiStrings.AnsiStrIComp(PAnsiChar(Key), '.lnk') <> 0)
    end;

var
  Reg: TRegistry;
  RegList: TStringList;
  i, j: integer;
  MenuText, DefaultKey, FileCreateType, ShellNewKeyPath: string;
  OldCursor: hCursor;
  NewShellNewItem: TVirtualShellNewItem;
  FileInfoA: TSHFileInfoA;
  FileInfoW: TSHFileInfoW;
  NewShellLink: TNewShellKind;
  DataSize: integer;
  Data: Pointer;
begin
  Clear;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  Reg := TRegistry.Create;
  RegList := TStringList.Create;
  if Assigned(Reg) then
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    if Reg.OpenKeyReadOnly('') then
    begin
      { Read in all the level 1 keys under HKEY_CLASSES_ROOT }
      Reg.GetKeyNames(RegList);
      Reg.CloseKey;
      RegList.Sorted := True;
      for i := 0 to RegList.Count - 1  do
        { Only work on extension keys not the extention type keys }
        if IsValidExtKey(AnsiString(RegList[i])) then
        begin
          { Open the extension key }
          ShellNewKeyPath := RegList[i];
          if Reg.OpenKeyReadOnly(ShellNewKeyPath) then
          begin
            { Read the default text. This is the pointer to the extension type  }
            { key further down in the list OR it may be another key that        }
            { contains the ShellNew key                                         }
            DefaultKey := Reg.ReadString('');
            Reg.CloseKey;
            { Try to open the extension type pointed to by the extension type   }
            { key, and read the File Type Name to be used for creating the new  }
            { file and for use for the menu text.                               }
            if Reg.OpenKeyReadOnly(DefaultKey) then
            begin
              MenuText := Reg.ReadString('');
              Reg.CloseKey;
            end else
              MenuText := '';
            { Check to see if it was a pointer to a sub key, with a saftety out }
            j := 0;
            while (DefaultKey <> '') and (j < 20) do
            begin
              if Reg.OpenKeyReadOnly(ShellNewKeyPath + '\' + DefaultKey) then
              begin
                ShellNewKeyPath := ShellNewKeyPath +  '\' + DefaultKey;
                DefaultKey := Reg.ReadString('');
                Reg.CloseKey;
              end else
                DefaultKey := '';
              Inc(j);
            end;
            { Try to open the ShellNew subkey under the ShellNewKeyPath key     }
            if (MenuText <> '') then
              if Reg.OpenKeyReadOnly(ShellNewKeyPath + S_SHELLNEW_PATH) then
              begin
                NewShellLink := nmk_Unknown;
                FileCreateType := '';
                Data := nil;
                DataSize := 0;

                if Reg.GetDataType(S_NULLFILE) = rdString then
                begin
                  FileCreateType := Reg.ReadString(S_NULLFILE);
                  NewShellLink := nmk_Null
                end else
                if Reg.GetDataType(S_FILENAME) = rdString then
                begin
                  FileCreateType := Reg.ReadString(S_FILENAME);
                  NewShellLink := nmk_FileName
                end else
                if Reg.GetDataType(S_COMMAND) = rdString then
                begin
                  FileCreateType := Reg.ReadString(S_COMMAND);
                  NewShellLink := nmk_Command
                end else
                if Reg.GetDataType(S_COMMAND) = rdExpandString  then
                begin
                  FileCreateType := Reg.ReadString(S_COMMAND);
                  NewShellLink := nmk_Command
                end else
                if Reg.GetDataType(S_DATA) = rdBinary then
                begin
                  DataSize := Reg.GetDataSize(S_DATA);
                  GetMem(Data, DataSize);
                  if DataSize = Reg.ReadBinaryData(S_DATA, Data^, DataSize) then
                  NewShellLink := nmk_Data
                end;
                if NewShellLink <> nmk_Unknown then
                begin

                  NewShellNewItem := TVirtualShellNewItem.Create;
                  NewShellNewItem.Extension := RegList[i];
                  NewShellNewItem.FileType := MenuText;
                  NewShellNewItem.NewShellKind := NewShellLink;
                  NewShellNewItem.NewShellKindStr := FileCreateType;
                  NewShellNewItem.Data := Data;
                  NewShellNewItem.DataSize := DataSize;
                  if Assigned(SHGetFileInfoW_MP) then
                  begin
                    if SHGetFileInfoW_MP(PWideChar(NewShellNewItem.Extension),
                                     FILE_ATTRIBUTE_NORMAL,
                                     FileInfoW,
                                     SizeOf( FileInfoW),
                                     SHGFI_USEFILEATTRIBUTES or
                                     SHGFI_SHELLICONSIZE or
                                     SHGFI_ICON or
                                     SHGFI_SYSICONINDEX) > 0 then
                      NewShellNewItem.SystemImageIndex := FileInfoW.iIcon;
                  end else
                  begin
                    if SHGetFileInfoA(PAnsiChar( AnsiString( NewShellNewItem.Extension)),
                                   FILE_ATTRIBUTE_NORMAL,
                                   FileInfoA,
                                   SizeOf( FileInfoA),
                                   SHGFI_USEFILEATTRIBUTES or
                                   SHGFI_SHELLICONSIZE or
                                   SHGFI_ICON or
                                   SHGFI_SYSICONINDEX) > 0 then
                    NewShellNewItem.SystemImageIndex := FileInfoA.iIcon;
                  end;
                  Add(NewShellNewItem);
                end;
                Reg.CloseKey;
              end;
          end;
        end;
      end;
  finally
    Screen.Cursor := OldCursor;
    Reg.Free;
    RegList.Free;
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
  Path, FileName: WideString;
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
  NewMenuItem: TVirtualShellNewItem; FileName: WideString);
begin
  if Assigned(OnAfterFileCreate) then
    OnAfterFileCreate(Self, NewMenuItem, FileName);
end;

procedure TVirtualShellNewMenu.DoCreateNewFile(NewMenuItem: TVirtualShellNewItem;
  var Path, FileName: WideString; var Allow: Boolean);
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
      SetTBItemCaption(M, Items[I].Caption);
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

