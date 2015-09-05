unit VirtualSendToMenu;

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

{$include ..\Include\AddIns.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Menus, Registry, ShlObj, ShellAPI, ActiveX, MPShellUtilities, ImgList,
  CommCtrl, VirtualResources,
  {$IFDEF USE_TOOLBAR_TB2K}
  TB2Item,
  {$ENDIF}
  MPCommonUtilities, MPCommonObjects;

type
  TVirtualSendToMenu = class;  // Forward

  TSendToMenuOptions = class(TPersistent)
  private
    FImages: Boolean;
    FLargeImages: Boolean;
    FImageBorder: Integer;
    FMaxWidth: Integer;
    FEllipsisPlacement: TShortenStringEllipsis;
  public
    constructor Create;
  published
    property EllipsisPlacement: TShortenStringEllipsis read FEllipsisPlacement write FEllipsisPlacement default sseMiddle;
    property Images: Boolean read FImages write FImages default True;
    property LargeImages: Boolean read FLargeImages write FLargeImages default False;
    property ImageBorder: Integer read FImageBorder write FImageBorder default 1;
    property MaxWidth: Integer read FMaxWidth write FMaxWidth default -1;
  end;

  TVirtualSendToEvent = procedure(Sender: TVirtualSendToMenu;
    SendToTarget: TNamespace; var SourceData: IDataObject) of object;
  TVirtualSendToGetImageEvent = procedure(Sender: TVirtualSendToMenu;
    NS: TNamespace; var ImageList: TImageList; var ImageIndex: Integer) of object;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualSendToMenu = class(TPopupMenu)
  private
    FSendToItems: TVirtualNameSpaceList;
    FSendToEvent: TVirtualSendToEvent;
    FOptions: TSendToMenuOptions;
    FOnGetImage: TVirtualSendToGetImageEvent;
  protected
    procedure DoGetImage(NS: TNamespace; var ImageList: TImageList; var ImageIndex: Integer);
    procedure DoSendTo(SendToTarget: TNamespace; var SourceData: IDataObject); virtual;
    function EnumSendToCallback(ParentWnd: HWnd; APIDL: PItemIDList; AParent: TNamespace;
      Data: Pointer; var Terminate: Boolean): Boolean;
    procedure OnMenuItemClick(Sender: TObject); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Populate(MenuItem: TMenuItem); virtual;
    {$IFDEF USE_TOOLBAR_TB2K}
    procedure Populate_TB2000(MenuItem: TTBCustomItem; ItemClass: TTBCustomItemClass); virtual;
    {$ENDIF}
    procedure Popup(X, Y: Integer); override;
    property SendToItems: TVirtualNameSpaceList read FSendToItems;
  published
    property SendToEvent: TVirtualSendToEvent read FSendToEvent write FSendToEvent;
    property OnGetImage: TVirtualSendToGetImageEvent read FOnGetImage write FOnGetImage;
    property Options: TSendToMenuOptions read FOptions write FOptions;
  end;

implementation

{$IFDEF USE_TOOLBAR_TB2K}
uses
  TypInfo;

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

function SendToMenuSort(Item1, Item2: Pointer): Integer;
begin
  if Assigned(Item1) and Assigned(Item2) then
    Result := TNamespace(Item2).ComparePIDL(TNamespace(Item1).RelativePIDL, False)
  else
    Result := 0
end;

{ TVirtualSendToMenu }

constructor TVirtualSendToMenu.Create(AOwner: TComponent);
begin
  inherited;
  // SendToItems owns the Namespaces
  FSendToItems := TVirtualNameSpaceList.Create(True);
  FOptions := TSendToMenuOptions.Create;
end;

destructor TVirtualSendToMenu.Destroy;
begin
  SendToItems.Free;
  FOptions.Free;
  inherited;
end;

procedure TVirtualSendToMenu.DoGetImage(NS: TNamespace;
  var ImageList: TImageList; var ImageIndex: Integer);
begin
  if Assigned(OnGetImage) then
    OnGetImage(Self, NS, ImageList, ImageIndex);
end;

procedure TVirtualSendToMenu.DoSendTo(SendToTarget: TNamespace;
   var SourceData: IDataObject);
begin
  SourceData := nil;
  if Assigned(SendToEvent) then
    SendToEvent(Self, SendToTarget, SourceData);
end;

function TVirtualSendToMenu.EnumSendToCallback(ParentWnd: HWnd; APIDL: PItemIDList;
  AParent: TNamespace; Data: Pointer; var Terminate: Boolean): Boolean;
var
  NS: TNamespace;
begin
  if AParent.IsMyComputer then
  begin
    NS := TNamespace.Create(PIDLMgr.AppendPIDL(AParent.AbsolutePIDL, APIDL), nil);
    if NS.Removable then
      TVirtualNameSpaceList(Data).Add(NS)
    else
      NS.Free
  end else
    TVirtualNameSpaceList(Data).Add(TNamespace.Create(PIDLMgr.AppendPIDL(AParent.AbsolutePIDL, APIDL), nil));
  Result := True
end;

procedure TVirtualSendToMenu.OnMenuItemClick(Sender: TObject);
var
  M: TComponent;
  DataObject: IDataObject;
  DropTarget: IDropTarget;
  DropEffect: Longint;
begin
  if (Sender is TComponent) then begin
    M := Sender as TComponent;
    if M.Tag > -1 then begin
      DoSendTo(SendToItems[M.Tag], DataObject);
      if Assigned(DataObject) then begin
        DropEffect := DROPEFFECT_COPY or DROPEFFECT_MOVE or DROPEFFECT_LINK;
        DropTarget := SendToItems[M.Tag].DropTargetInterface;
        if Assigned(DropTarget) then
          if Succeeded(DropTarget.DragEnter(DataObject, MK_LBUTTON, Point(0, 0), DropEffect)) then
          begin
            DropEffect := DROPEFFECT_COPY or DROPEFFECT_MOVE or DROPEFFECT_LINK;
            DropTarget.Drop(DataObject, 0, Point(0, 0), DropEffect)
          end
      end
    end;
  end;
end;

procedure TVirtualSendToMenu.Populate(MenuItem: TMenuItem);
  procedure Fill(NS: TNamespace; NonFolders: Boolean);
  var
    M: TMenuItem;
    I, SendToIndex: Integer;
    L: TVirtualNameSpaceList;
  begin
    // Fill a temp Namespace List with the shell send-to items
    // and then add them to the PopupMenu and SendToItems list.
    L := TVirtualNameSpaceList.Create(False);
    try
      // No messages
      NS.EnumerateFolder(0, False, NonFolders, False, EnumSendToCallback, L);
      L.Sort(SendToMenuSort);
      for I := 0 to L.Count - 1 do begin
        SendToIndex := SendToItems.Add(L[I]);
        M := TMenuItem.Create(Self);
        M.Caption := L[I].NameNormal;
        M.Tag := SendToIndex; // SendToItems index
        M.ImageIndex := L[I].GetIconIndex(False, icSmall);
        M.OnClick := OnMenuItemClick;
        MenuItem.Add(M);
      end;
    finally
      L.Free;
    end;
  end;

var
  NS: TNamespace;
  OldErrorMode: Integer;
begin
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOOPENFILEERRORBOX);
  try
    SendToItems.Clear;
    MenuItem.Clear;
    MenuItem.SubMenuImages := SmallSysImages;

    // Fill the shell send-to items.
    NS := CreateSpecialNamespace(CSIDL_SENDTO);
    try
      Fill(NS, True);
    finally
      NS.Free;
    end;
    // Fill the shell removable drives.
    Fill(DrivesFolder, False);
  finally
    SetErrorMode(OldErrorMode);
  end;
end;

{$IFDEF USE_TOOLBAR_TB2K}
procedure TVirtualSendToMenu.Populate_TB2000(MenuItem: TTBCustomItem; ItemClass: TTBCustomItemClass);
  procedure Fill(NS: TNamespace; NonFolders: Boolean);
  var
    M: TTBCustomItem;
    I, SendToIndex: Integer;
    L: TVirtualNameSpaceList;
  begin
    // Fill a temp Namespace List with the shell send-to items
    // and then add them to the PopupMenu and SendToItems list.
    L := TVirtualNameSpaceList.Create(False);
    try
      // No messages
      NS.EnumerateFolder(0, False, NonFolders, False, EnumSendToCallback, L);
      L.Sort(SendToMenuSort);
      for I := 0 to L.Count - 1 do begin
        SendToIndex := SendToItems.Add(L[I]);
        M := ItemClass.Create(nil);
        SetTBItemCaption(M, L[I].NameNormal);
        M.Tag := SendToIndex; // SendToItems index
        M.ImageIndex := L[I].GetIconIndex(False, icSmall);
        M.OnClick := OnMenuItemClick;
        MenuItem.Add(M);
      end;
    finally
      L.Free;
    end;
  end;

var
  NS: TNamespace;
  OldErrorMode: Integer;
begin
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOOPENFILEERRORBOX);
  try
    SendToItems.Clear;
    MenuItem.Clear;
    MenuItem.SubMenuImages := SmallSysImages;

    // Fill the shell send-to items.
    NS := CreateSpecialNamespace(CSIDL_SENDTO);
    try
      Fill(NS, True);
    finally
      NS.Free;
    end;
    // Fill the shell removable drives.
    Fill(DrivesFolder, False);
  finally
    SetErrorMode(OldErrorMode);
  end;
end;
{$ENDIF}

procedure TVirtualSendToMenu.Popup(X, Y: Integer);
begin
  Images := SmallSysImages;
  Items.Clear;
  Populate(Items);
  inherited;
end;

{ TSendToMenuOptions }

constructor TSendToMenuOptions.Create;
begin
  Images := True;
  LargeImages := False;
  ImageBorder := 1;
  FEllipsisPlacement := sseMiddle;
  MaxWidth := -1;
end;

end.
