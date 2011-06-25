unit VirtualShellAutoComplete;

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

{$include Compilers.inc}
{$include ..\Include\AddIns.inc}

{$ifdef COMPILER_12_UP}
  {$WARN IMPLICIT_STRING_CAST       OFF}
 {$WARN IMPLICIT_STRING_CAST_LOSS  OFF}
{$endif COMPILER_12_UP}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ImgList, ShlObj, ShellAPI, ActiveX, ComObj, MPShellTypes,
  {$IFDEF TNTSUPPORT}
  TntClasses,
  TntSysUtils, 
  {$ENDIF}
  MPShellUtilities,
  MPCommonUtilities,
  MPCommonObjects;

type
  TAutoCompleteContent = (
    accCurrentDir,            // Include the current directory contents
    accMyComputer,            // Include any objects under MyComputer (drives, control panel etc)
    accDesktop,               // Include objects that are on the desktop
    accFavorites,             // Include the Favorites folder
    accFileSysOnly,           // Only Physical files are added to the list; no virtual objects
    accFileSysDirs,           // Include physical file directories in the search
    accFileSysFiles,          // Include physical files in the search
    accHidden,                // Include Hidden objects
    accRecursive,             // Recurse into sub folders (only valid if accFileSysDirs is enabled)
    accSortList               // Sorts the list
  );
  TAutoCompleteContents = set of TAutoCompleteContent;

const
  AutoCompleteDefault =  [accCurrentDir, accMyComputer, accFileSysDirs, accFileSysFiles];

type
  TVirtualAutoCompleteAddItem = procedure(Sender: TObject; AutoCompleteItem: TNamespace; var Allow: Boolean;
    var Terminate: Boolean) of object;

type
  TCustomVirtualShellAutoComplete = class(TComponent)
  private
    FCurrentDir: WideString;
    FStrings: {$IFDEF TNTSUPPORT}TTntStringList{$ELSE}TStringList{$ENDIF};  
    FContents: TAutoCompleteContents;
    FOnAutoCompleteAddItem: TVirtualAutoCompleteAddItem;
    FNamespaces: TVirtualNameSpaceList;
    FDirty: Boolean;
    function GetStrings: {$IFDEF TNTSUPPORT}TTntStringList{$ELSE}TStringList{$ENDIF};


    procedure ReadCurrentDir(Reader: TReader);
    procedure WriteCurrentDir(Writer: TWriter);
    procedure SetCurrentDir(const Value: WideString);

  protected
    function EnumFolder(MessageWnd: HWnd; APIDL: PItemIDList; AParent: TNamespace; Data: Pointer; var Terminate: Boolean): Boolean;
    procedure FillCurrentDir;
    procedure FillMyComputer;
    procedure FillDesktop;
    procedure FillFavorites;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoAddAutoCompleteItem(AutoCompleteItem: TNamespace; var Allow: Boolean; var Terminate: Boolean);

    property Contents: TAutoCompleteContents read FContents write FContents
      default AutoCompleteDefault;
    property CurrentDir: WideString read FCurrentDir write SetCurrentDir;
    property OnAutoCompleteAddItem: TVirtualAutoCompleteAddItem read FOnAutoCompleteAddItem write FOnAutoCompleteAddItem;
    property Namespaces: TVirtualNameSpaceList read FNamespaces write FNamespaces;
    property Strings: {$IFDEF TNTSUPPORT}TTntStringList{$ELSE}TStringList{$ENDIF} read GetStrings;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Refresh;

    property Dirty: Boolean read FDirty write FDirty;
  end;

  TVirtualShellAutoComplete = class(TCustomVirtualShellAutoComplete)
  public
    property Namespaces;
    property Strings;
  published
    property Contents;
    property CurrentDir;
    property OnAutoCompleteAddItem;
  end;

implementation

{ TVirtualShellAutoComplete }

constructor TCustomVirtualShellAutoComplete.Create(AOwner: TComponent);
begin
  inherited;
  {$IFDEF TNTSUPPORT}
  FStrings := TTntStringList.Create;
  {$ELSE}
  FStrings := TStringList.Create;
  {$ENDIF}
  Contents := AutoCompleteDefault;
  Namespaces := TVirtualNameSpaceList.Create(True);
end;

procedure TCustomVirtualShellAutoComplete.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('CurrentDir', ReadCurrentDir, WriteCurrentDir, True);
  inherited;    
end;

destructor TCustomVirtualShellAutoComplete.Destroy;
begin
  FStrings.Free;
  Namespaces.Free;
  inherited;  
end;

procedure TCustomVirtualShellAutoComplete.DoAddAutoCompleteItem(
  AutoCompleteItem: TNamespace; var Allow: Boolean; var Terminate: Boolean);
begin
  Allow := True;
  if Assigned(OnAutoCompleteAddItem) then
    OnAutoCompleteAddItem(Self, AutoCompleteItem, Allow, Terminate);
end;

function TCustomVirtualShellAutoComplete.EnumFolder(MessageWnd: HWnd; APIDL: PItemIDList;
  AParent: TNamespace; Data: Pointer; var Terminate: Boolean): Boolean;
var
  NS: TNamespace;
  DoAdd: Boolean;
  Allow: Boolean;
begin
  NS := TNamespace.Create(PIDLMgr.AppendPIDL(AParent.AbsolutePIDL, APIDL), nil);
  DoAdd := True;

  if NS.Hidden and not(accHidden in FContents) then
    DoAdd := False;
  if not NS.FileSystem and (accFileSysOnly in FContents) then
    DoAdd := False;

  if DoAdd then
  begin
    if (accRecursive in FContents) and NS.Folder then
    begin
      NS.EnumerateFolder(0, accFileSysDirs in FContents, accFileSysFiles in FContents,
        accHidden in FContents, EnumFolder, Data);
    end;
    DoAddAutoCompleteItem(NS, Allow, Terminate);
    if Allow then
      Namespaces.Add(NS)
    else
      NS.Free
  end;
  Result := True;
end;

procedure TCustomVirtualShellAutoComplete.FillCurrentDir;
var
  NS: TNamespace;
begin
  if (accCurrentDir in FContents) and WideDirectoryExists(FCurrentDir) then
  begin
    try
      NS := TNamespace.CreateFromFileName(FCurrentDir);
      if Assigned(NS) then
      begin
        NS.EnumerateFolder(0, accFileSysDirs in FContents, accFileSysFiles in FContents,
          accHidden in FContents, EnumFolder, nil);
        NS.Free
      end
    except
    end
  end
end;

procedure TCustomVirtualShellAutoComplete.FillDesktop;
begin
  if (accDesktop in FContents) and Assigned(DesktopFolder) then
    DesktopFolder.EnumerateFolder(0, accFileSysDirs in FContents, accFileSysFiles in FContents,
      accHidden in FContents, EnumFolder, nil);
end;

procedure TCustomVirtualShellAutoComplete.FillFavorites;
begin
  if (accFavorites in FContents) and Assigned(FavoritesFolder) then
    FavoritesFolder.EnumerateFolder(0, accFileSysDirs in FContents, accFileSysFiles in FContents,
      accHidden in FContents, EnumFolder, nil);
end;

procedure TCustomVirtualShellAutoComplete.FillMyComputer;
begin
  if (accMyComputer in FContents) and Assigned(DrivesFolder) then
    DrivesFolder.EnumerateFolder(0, accFileSysDirs in FContents, accFileSysFiles in FContents,
      accHidden in FContents, EnumFolder, nil);
end;

function TCustomVirtualShellAutoComplete.GetStrings: {$IFDEF TNTSUPPORT}TTntStringList{$ELSE}TStringList{$ENDIF};
var
  i: integer;
begin
  FStrings.Clear;
  for i := 0 to Namespaces.Count - 1 do
    FStrings.Add(Namespaces[i].NameParseAddress);
  if accSortList in FContents then
    FStrings.Sort;
  Result := FStrings
end;

procedure TCustomVirtualShellAutoComplete.ReadCurrentDir(Reader: TReader);
begin
  case Reader.NextValue of
    vaLString, vaString:
      FCurrentDir := Reader.ReadString;
  else
    FCurrentDir := Reader.ReadWideString;
  end;
end;

procedure TCustomVirtualShellAutoComplete.Refresh;
begin
  if Dirty then
  begin
    Namespaces.Clear;
    FillCurrentDir;
    FillDesktop;
    FillFavorites;
    FillMyComputer;
  end
end;

procedure TCustomVirtualShellAutoComplete.SetCurrentDir(
  const Value: WideString);
begin
  if (Value <> FCurrentDir) and WideDirectoryExists(Value) then
  begin
    Dirty := True;
    FCurrentDir := Value;
  end
end;

procedure TCustomVirtualShellAutoComplete.WriteCurrentDir(Writer: TWriter);
begin
  Writer.WriteWideString(FCurrentDir);
end;

end.
