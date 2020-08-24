unit VirtualBreadCrumbBar;

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
// Modifications by Francois Rivierre, 2005-11-28, to allow runtime
// customization of internal strings.
//
//----------------------------------------------------------------------------

interface

{$include ..\Include\AddIns.inc}

{$WARN IMPLICIT_STRING_CAST       OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS  OFF}

uses
  Types,
  {$IFDEF GXDEBUG}
  DbugIntf,
  {$ENDIF}
  Windows,
  Controls,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  ShellAPI,
  ActiveX,
  ShlObj,
  Menus,
  ImgList,
  ExtCtrls,
  CommCtrl,
  MPShellUtilities,
  VirtualScrollbars,
  VirtualShellNotifier,
  VirtualShellAutoComplete,
  VirtualResources,
  MPCommonObjects,
  MPCommonUtilities,
  MPThreadManager,
  MPResources,
  MPShellTypes,
  MPDataObject,
  Themes,
  UxTheme;


const
  PATH_ITEM_MARGIN = 8;
  PATH_ITEM_ARROW_MARGIN = 2;
  MARLETT_SIZE_INC = 2;  // Size + 2

type
  TVirtualBreadCrumbBarOption = (
    vbcoEditable,               // Allows typing after clicking the image on the left
    vbcoDropDownTree,           // Clicking the arrow down button shows a dropdown window with a tree to select from
    vbcoDropDownAutoComplete,   // Beginning to type will show the drop down auto complete window
    vbcoDropDownMenus,          // Each crumb has a drop down menu with the levels sibling folders
    vbcoDropDownExpandableMenus,// Each crumb has a drop down menu with the levels sibling folders which in turn have sub menus
    vbcoMenuIcons               // Drop down menus have images
  );
  TVirtualBreadCrumbBarOptions = set of TVirtualBreadCrumbBarOption;

  TVirtualBreadCrumbBarState = (
    vbcsLMouseDown,
    vbcsRMouseDown,
    vbcsMenuTracking   // A dropdown menu has been shown so moving to a new crumb shows its menu automatically
  );
  TVirtualBreadCrumbBarStates = set of TVirtualBreadCrumbBarState;

  TVirtualBreadCrumbBarObjectState = (
    vbcsHovering,     // Mouse is hovering over object
    vbcsDown,         // Object is in the "down" position
    vbcsMenuShown,    // The Dropdown menu is shown
    vbcsClicking,     // The Mouse has been pressed in the object and the object has the mouse "captured"
    vbsDropDownHot   // The dropdown button is hot
  );
  TVirtualBreadCrumbBarObjectStates = set of TVirtualBreadCrumbBarObjectState;

type
  TCustomVirtualBreadCrumbBar = class;

  TBreadCrumbBarObject = class
  private
    FDisplayRect: TRect;
    FOwner: TCustomVirtualBreadCrumbBar;
    FState: TVirtualBreadCrumbBarObjectStates;
    function GetClicking: Boolean;
    function GetDown: Boolean;
    function GetDropDownHot: Boolean;
    function GetHovering: Boolean;
    function GetMenuShown: Boolean;
    procedure SetClicking(const Value: Boolean);
    procedure SetDown(const Value: Boolean);
    procedure SetDropDownHot(const Value: Boolean);
    procedure SetHovering(const Value: Boolean);
    procedure SetMenuShown(const Value: Boolean);
  public
    constructor Create(AnOwner: TCustomVirtualBreadCrumbBar); virtual;
    destructor Destroy; override;
    function PtInDisplayRect(Pt: TPoint): Boolean; virtual;
    function PtInDropDownButton(Pt: TPoint): Boolean; virtual;
    procedure Click(Pt: TPoint); virtual;
    procedure Invalidate(Immediate: Boolean);
    procedure Paint(ACanvas: TCanvas); virtual;
    property Clicking: Boolean read GetClicking write SetClicking;
    property DisplayRect: TRect read FDisplayRect write FDisplayRect;
    property Down: Boolean read GetDown write SetDown;
    property DropDownHot: Boolean read GetDropDownHot write SetDropDownHot;
    property Hovering: Boolean read GetHovering write SetHovering;
    property MenuShown: Boolean read GetMenuShown write SetMenuShown;
    property Owner: TCustomVirtualBreadCrumbBar read FOwner write FOwner;
    property State: TVirtualBreadCrumbBarObjectStates read FState write FState;
  end;

  TBreadCrumbBarPathObject = class(TBreadCrumbBarObject)
  private
    FButtonRect: TRect;
    FDropDownArrowRect: TRect;   // Within the BoundsRect
    FNamespace: TNamespace;      // Within the BoundsRect
  protected
    function EnumFunc(MessageWnd: HWnd; APIDL: PItemIDList; AParent: TNamespace; Data: Pointer; var Terminate: Boolean): Boolean;
    procedure OnPopupMenuClick(Sender: TObject);
  public
    constructor Create(AnOwner: TCustomVirtualBreadCrumbBar; ANamespace: TNamespace); reintroduce; virtual;
    destructor Destroy; override;
    function PtInDropDownButton(Pt: TPoint): Boolean; override;
    procedure Click(Pt: TPoint); override;
    procedure Paint(ACanvas: TCanvas); override;
    property ButtonRect: TRect read FButtonRect write FButtonRect;
    property DropDownArrowRect: TRect read FDropDownArrowRect write FDropDownArrowRect;
    property Namespace: TNamespace read FNamespace write FNamespace;
  end;

  TBreadCrumbBarPathObjects = class
  private
    FCrumbs: TList;
    function GetCount: Integer;
    function GetItems(Index: Integer): TBreadCrumbBarPathObject;
    procedure SetItems(Index: Integer; Value: TBreadCrumbBarPathObject);
  protected
    property Crumbs: TList read FCrumbs write FCrumbs;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Item: TBreadCrumbBarPathObject);
    procedure Clear;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TBreadCrumbBarPathObject read GetItems write SetItems; default;
  end;

  TVirtualBreadCrumbBarPaintOptions = class(TPersistent)
  private
    FBorderColor: TColor;
    FFillColor: TColor;
    FGradient: Boolean;
    FGradientEndColorActive: TColor;
    FGradientEndColorInActive: TColor;
    FGradientStartColorActive: TColor;
    FGradientStartColorInActive: TColor;
    FRadius: Byte;
    FRounded: Boolean;
    FTextColorActive: TColor;
    FTextColorInactive: Tcolor;
  protected
  public
    constructor Create;
  published
    property BorderColor: TColor read FBorderColor write FBorderColor default clHighlight;
    property FillColor: TColor read FFillColor write FFillColor default clHighlight;
    property Gradient: Boolean read FGradient write FGradient default False;
    property GradientEndColorActive: TColor read FGradientEndColorActive write FGradientEndColorActive default clWindow;
    property GradientEndColorInActive: TColor read FGradientEndColorInActive write FGradientEndColorInActive default clWindow;
    property GradientStartColorActive: TColor read FGradientStartColorActive write FGradientStartColorActive default clHighlight;
    property GradientStartColorInActive: TColor read FGradientStartColorInActive write FGradientStartColorInActive default clBtnFace;
    property Radius: Byte read FRadius write FRadius default 4;
    property Rounded: Boolean read FRounded write FRounded default False;
    property TextColorActive: TColor read FTextColorActive write FTextColorActive default clHighlightText;
    property TextColorInactive: Tcolor read FTextColorInactive write FTextColorInactive default clWindowText;
  end;


  TCustomVirtualBreadCrumbBar = class(TCommonCanvasControl)
  private
    FActive: Boolean;
    FCrumbs: TBreadCrumbBarPathObjects;
    FCurrentTarget: TBreadCrumbBarObject;
    FDropDownButton: TBreadCrumbBarObject;
    FFileObjects: TFileObjects;
    FNamespace: TNamespace;
    FOptions: TVirtualBreadCrumbBarOptions;
    FPaintOptions: TVirtualBreadCrumbBarPaintOptions;
    FPathImage: TBreadCrumbBarObject;
    FState: TVirtualBreadCrumbBarStates;
    FTrackingMenu: TPopupMenu;             // Set/Cleared by the Crumb object when it opens a menu
    function GetPath: string;
    function GetPIDL: PItemIDList;
    procedure SetActive(const Value: Boolean);
    procedure SetOptions(const Value: TVirtualBreadCrumbBarOptions);
    procedure SetPath(const Value: string);
    procedure SetPIDL(const Value: PItemIDList);
  protected
    procedure BuildViewRects;
    procedure CalcThemedNCSize(var ContextRect: TRect); override;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CreateWnd; override;
    procedure DoMouseEnter(MousePos: TPoint); override;
    procedure DoMouseExit; override;
    procedure DoMouseTrack(MousePos: TPoint); override;
    procedure DoPaintRect(ACanvas: TCanvas; ClipRect: TRect; SelectedOnly: Boolean; ClipRectInViewPortCoords: Boolean = False); override;
    procedure PaintThemedNCBkgnd(ACanvas: TCanvas; ARect: TRect); override;
    procedure ParsePath;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMLButtonDown(var Msg: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Msg: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMMouseMove(var Msg: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMRButtonDown(var Msg: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMRButtonUp(var Msg: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMWindowPosChanging(var Msg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    property Active: Boolean read FActive write SetActive default False;
    property Crumbs: TBreadCrumbBarPathObjects read FCrumbs write FCrumbs;
    property CurrentTarget: TBreadCrumbBarObject read FCurrentTarget write FCurrentTarget;
    property FileObjects: TFileObjects read FFileObjects write FFileObjects default [foFolders];
    property Namespace: TNamespace read FNamespace;
    property Options: TVirtualBreadCrumbBarOptions read FOptions write SetOptions default [vbcoEditable, vbcoDropDownTree, vbcoDropDownAutoComplete, vbcoDropDownMenus, vbcoDropDownExpandableMenus];
    property PaintOptions: TVirtualBreadCrumbBarPaintOptions read FPaintOptions write FPaintOptions;
    property Path: string read GetPath write SetPath;
    property TrackingMenu: TPopupMenu read FTrackingMenu write FTrackingMenu;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FindCrumbByPoint(MousePt: TPoint): TBreadCrumbBarObject;
    procedure Rebuild;
    property DropDownButton: TBreadCrumbBarObject read FDropDownButton write FDropDownButton;
    property PathImage: TBreadCrumbBarObject read FPathImage write FPathImage;
    property PIDL: PItemIDList read GetPIDL write SetPIDL;
    property State: TVirtualBreadCrumbBarStates read FState write FState;
  end;

  TVirtualBreadCrumbBar = class(TCustomVirtualBreadCrumbBar)
  published
    property Active;
    property Align;
    property Anchors;
    property BevelKind;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property CacheDoubleBufferBits;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property FileObjects;
    property Font;
    property Options;
    property PaintOptions;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property Path;
    property PopupMenu;
    property ShowThemedBorder;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Themed;
    property Visible;

    property OnMouseEnter;
    property OnMouseExit;
  end;
  
implementation

{ TCustomVirtualBreadCrumbBar}
constructor TCustomVirtualBreadCrumbBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 24;
  Width := 200;
  FNamespace := TNamespace.Create(nil, nil);
  ParentColor := False;
  Color := clWindow;
  DropDownButton := TBreadCrumbBarObject.Create(Self);
  PathImage := TBreadCrumbBarObject.Create(Self);
  Crumbs := TBreadCrumbBarPathObjects.Create;
  FPaintOptions := TVirtualBreadCrumbBarPaintOptions.Create;
  FOptions := [vbcoEditable, vbcoDropDownTree, vbcoDropDownAutoComplete, vbcoDropDownMenus, vbcoDropDownExpandableMenus];
  FFileObjects := [foFolders]
end;

destructor TCustomVirtualBreadCrumbBar.Destroy;
begin
  FreeAndNil(FNamespace);
  FreeAndNil(FDropDownButton);
  FreeAndNil(FPathImage);
  FreeAndNil(FCrumbs);
  FreeAndNil(FPaintOptions);
  inherited Destroy;
end;

function TCustomVirtualBreadCrumbBar.FindCrumbByPoint(MousePt: TPoint): TBreadCrumbBarObject;
var
  i: Integer;
begin
  Result := nil;
  if PathImage.PtInDisplayRect(MousePt) then
    Result := PathImage
  else
  if DropDownButton.PtInDisplayRect(MousePt) then
    Result := DropDownButton
  else begin
    i := 0;
    while (i < Crumbs.Count) and not Assigned(Result) do
    begin
      if Crumbs[i].PtInDisplayRect(MousePt) then
        Result := Crumbs[i];
      Inc(i)
    end
  end
end;

function TCustomVirtualBreadCrumbBar.GetPath: string;
begin
  if Assigned(FNamespace) then
    Result := Namespace.NameForParsing
  else
    Result := ''
end;

function TCustomVirtualBreadCrumbBar.GetPIDL: PItemIDList;
begin
  if Assigned(FNamespace) then
    Result := PIDLMgr.CopyPIDL( Namespace.AbsolutePIDL)
  else
    Result := nil
end;

procedure TCustomVirtualBreadCrumbBar.BuildViewRects;
var
  i: Integer;
  R: TRect;
  ACanvas: TCanvas;
begin
  if HandleAllocated then
  begin
    PathImage.DisplayRect := Rect(0, 0, SmallSysImages.Width + 4, ClientHeight);
    R := PathImage.DisplayRect;
    R.Left := R.Right;
    ACanvas := TCanvas.Create;
    try
      ACanvas.Handle := GetDC(Handle);
      for i := 0 to Crumbs.Count - 1 do
      begin
        ACanvas.Font.Assign(Font);
        R.Right := R.Left + TextExtentW(Crumbs[i].Namespace.NameNormal, ACanvas).cx + PATH_ITEM_MARGIN;
        Crumbs[i].ButtonRect := R;

        R.Left := R.Right;
        ACanvas.Font.Assign(MarlettFont);
        ACanvas.Font.Size := ACanvas.Font.Size + MARLETT_SIZE_INC;

        if vbcoDropDownMenus in Options then
          R.Right := R.Left + TextExtentW('6', ACanvas).cx + PATH_ITEM_ARROW_MARGIN;
        Crumbs[i].DropDownArrowRect := R;
        UnionRect(FCrumbs[i].FDisplayRect, Crumbs[i].DropDownArrowRect, Crumbs[i].ButtonRect);
        R.Left := R.Right
      end;
    finally
      ReleaseDC(Handle, ACanvas.Handle);
      ACanvas.Handle := 0;
      ACanvas.Free
    end;
    DropDownButton.DisplayRect := Rect(ClientWidth - ClientHeight, 0, ClientWidth, ClientHeight);
  end
end;

procedure TCustomVirtualBreadCrumbBar.CalcThemedNCSize(var ContextRect: TRect);
begin
  if UseThemes then
    if Succeeded(GetThemeBackgroundContentRect(Themes.EditThemeTheme, Canvas.Handle, LVP_EMPTYTEXT, LIS_NORMAL, ContextRect, @ContextRect)) then
      InflateRect(ContextRect, -(BorderWidth), -(BorderWidth));
end;

procedure TCustomVirtualBreadCrumbBar.CreateWnd;
begin
  inherited CreateWnd;
  Rebuild;
end;

procedure TCustomVirtualBreadCrumbBar.DoMouseEnter(MousePos: TPoint);
begin
  inherited DoMouseEnter(MousePos);
end;

procedure TCustomVirtualBreadCrumbBar.DoMouseExit;
begin
  inherited DoMouseExit;
  if Assigned(CurrentTarget) then
  begin
    if not CurrentTarget.MenuShown then
    begin
      CurrentTarget.Hovering := False;
      CurrentTarget.Invalidate(True);
      if not CurrentTarget.Down then
        CurrentTarget := nil
    end
  end
end;

procedure TCustomVirtualBreadCrumbBar.DoMouseTrack(MousePos: TPoint);
//
// Called on every mouse move or tick of the hovering timer
//
var
  NewTarget: TBreadCrumbBarObject;
  InDropDownBtn, IsHovering: Boolean;
begin      beep;
  if not (vbcsLMouseDown in State) then
  begin
    NewTarget := FindCrumbByPoint(MousePos);
    if NewTarget <> CurrentTarget then
    begin
      if Assigned(CurrentTarget) then
      begin
        if not CurrentTarget.MenuShown then
        begin
          CurrentTarget.Hovering := False;
          CurrentTarget.Down := False;
          CurrentTarget.Invalidate(True)
        end
      end;
      CurrentTarget := NewTarget;
      if Assigned(NewTarget) then
      begin
        CurrentTarget.Hovering := True;
        CurrentTarget.DropDownHot := CurrentTarget.PtInDropDownButton(MousePos);
        NewTarget.Invalidate(True)
      end
    end else
    begin
      // Still on the same object, now check for subdivision within the object
      if Assigned(CurrentTarget) then
      begin
        InDropDownBtn := CurrentTarget.PtInDropDownButton(MousePos);
        if InDropDownBtn xor CurrentTarget.DropDownHot then
        begin
          CurrentTarget.DropDownHot := InDropDownBtn;
          CurrentTarget.Invalidate( True)
        end
      end
    end
  end else
  begin
    // Button is down
    if Assigned(CurrentTarget) then
    begin
      IsHovering := CurrentTarget.PtInDisplayRect(MousePos);
      if IsHovering xor CurrentTarget.Hovering then
      begin
        CurrentTarget.Hovering := IsHovering;
        CurrentTarget.Invalidate( True)
      end;
    end
  end
end;

procedure TCustomVirtualBreadCrumbBar.DoPaintRect(ACanvas: TCanvas; ClipRect: TRect; SelectedOnly: Boolean; ClipRectInViewPortCoords: Boolean = False);
var
  i: Integer;
begin
  ACanvas.Brush.Color := Color;
  ACanvas.FillRect(ClipRect);
  if Active and Assigned(Namespace) then
  begin
    ImageList_DrawEx(SmallSysImages.Handle,
        Namespace.GetIconIndex(False, icSmall),
        ACanvas.Handle,
        (RectWidth(PathImage.DisplayRect) - SmallSysImages.Width) div 2,
        (RectHeight(PathImage.DisplayRect) - SmallSysImages.Height) div 2,
        0,
        0,
        CLR_NONE,
        CLR_NONE,
        ILD_TRANSPARENT);

    ACanvas.Brush.Color := clNone;
    ACanvas.Brush.Style := bsClear;
    for i := 0 to Crumbs.Count - 1 do
    begin
      ACanvas.Brush.Assign(Brush);
      ACanvas.Font.Assign(Font);
      Crumbs[i].Paint(ACanvas);
    end
  end;
  for i := 0 to Crumbs.Count - 1 do
  begin
  end;
end;

procedure TCustomVirtualBreadCrumbBar.PaintThemedNCBkgnd(ACanvas: TCanvas; ARect: TRect);
var
  R: TRect;
begin
  if UseThemes and ShowThemedBorder then
  begin
    R := Rect(0, 0, 0, 0);
    GetThemeBackgroundExtent(Themes.EditThemeTheme, ACanvas.Handle, LVP_EMPTYTEXT, LIS_NORMAL, ARect, R);
    InflateRect(ARect, R.Left - ARect.Left, R.Top - ARect.Top);
    DrawThemeBackground(Themes.EditThemeTheme, ACanvas.Handle, LVP_EMPTYTEXT, LIS_NORMAL, ARect, nil);
  end
end;

procedure TCustomVirtualBreadCrumbBar.ParsePath;
var
  PIDLList: TCommonPIDLList;
  i: Integer;
begin
  Crumbs.Clear;
  if Assigned(Namespace) then
  begin
    PIDLList := TCommonPIDLList.Create;
    try
      PIDLList.SharePIDLs := True;
      PIDLMgr.ParsePIDL(Namespace.AbsolutePIDL, PIDLList, True);
      Crumbs.Add( TBreadCrumbBarPathObject.Create( Self, TNamespace.Create(nil, nil)));
      for i := 0 to PIDLList.Count - 1 do
        Crumbs.Add( TBreadCrumbBarPathObject.Create( Self, TNamespace.Create(PIDLList[i], nil)));
    finally
      PIDLList.Free
    end
  end
end;

procedure TCustomVirtualBreadCrumbBar.Rebuild;
begin
  ParsePath;
  BuildViewRects;
  SafeInvalidateRect(nil, False);
  // check for Active too.
end;

procedure TCustomVirtualBreadCrumbBar.SetActive(const Value: Boolean);
begin
  if Value <> FActive then
  begin
    FActive := Value;
    Rebuild;
    SafeInvalidateRect(nil, False);
  end;
end;

procedure TCustomVirtualBreadCrumbBar.SetOptions(const Value: TVirtualBreadCrumbBarOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    Rebuild
  end
end;

procedure TCustomVirtualBreadCrumbBar.SetPath(const Value: string);
var
  PIDL: PItemIDList;
  NS, OldNS: TNamespace;
begin
  if Assigned(Namespace) then
  begin
    PIDL := PathToPIDL(Value);
    if Assigned(PIDL) then
    begin
      if Namespace.ComparePIDL(PIDL, True) <> 0 then
      begin
        NS := TNamespace.Create(PIDL, nil);
        if Assigned(NS) then
        begin
          PIDL := nil; // We took over the PIDL
          OldNS := Namespace;
          FNamespace := NS;
          FreeAndNil(OldNS);
          Rebuild;
        end
      end;
      PIDLMgr.FreePIDL(PIDL)
    end
  end
end;

procedure TCustomVirtualBreadCrumbBar.SetPIDL(const Value: PItemIDList);
var
  NS, OldNS: TNamespace;
begin
  if Assigned(Value) then
  begin
    if Assigned(Namespace) then
    begin
      if Namespace.ComparePIDL(Value, True) <> 0 then
      begin
        NS := TNamespace.Create(Value, nil);
        if Assigned(NS) then
        begin
          OldNS := FNamespace;
          FNamespace := NS;
          FreeAndNil(OldNS);
          Rebuild
        end
      end
    end else
      FNamespace := TNamespace.Create(PIDLMgr.CopyPIDL(Value), nil)
  end
end;

procedure TCustomVirtualBreadCrumbBar.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
  Msg.Result := 1 // Handled
end;

procedure TCustomVirtualBreadCrumbBar.WMLButtonDown(var Msg: TWMLButtonDown);
begin
  Include(FState, vbcsLMouseDown);
  if Assigned(CurrentTarget) then
  begin
    CurrentTarget.Down := True;
    CurrentTarget.Invalidate(True);
  end;
  inherited;
end;

procedure TCustomVirtualBreadCrumbBar.WMLButtonUp(var Msg: TWMLButtonUp);
begin
  inherited;
  Exclude(FState, vbcsLMouseDown);
  if Assigned(CurrentTarget) then
  begin
    if CurrentTarget.PtInDisplayRect(SmallPointToPoint( Msg.Pos)) then
      CurrentTarget.Click(SmallPointToPoint( Msg.Pos));
    CurrentTarget.Down := False;
    CurrentTarget.Hovering := False;
    DoMouseExit;
  end;
end;

procedure TCustomVirtualBreadCrumbBar.WMMouseMove(var Msg: TWMMouseMove);
begin
  inherited;
  DoMouseTrack(SmallPointToPoint(Msg.Pos));
end;

procedure TCustomVirtualBreadCrumbBar.WMRButtonDown(var Msg: TWMRButtonDown);
begin
  Include(FState, vbcsRMouseDown);
  inherited;
end;

procedure TCustomVirtualBreadCrumbBar.WMRButtonUp(var Msg: TWMRButtonUp);
begin
  inherited;
  Exclude(FState, vbcsRMouseDown);
end;

procedure TCustomVirtualBreadCrumbBar.WMWindowPosChanging(var Msg: TWMWindowPosChanging);
begin
  inherited;
  if Msg.WindowPos.flags and SWP_NOSIZE = 0 then
    Rebuild	
end;

procedure TCustomVirtualBreadCrumbBar.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Rebuild;
end;

procedure TCustomVirtualBreadCrumbBar.CMParentFontChanged(
  var Message: TMessage);
begin
  inherited;
  Rebuild;
end;

{ TBreadCrumbBarObject}
constructor TBreadCrumbBarObject.Create(AnOwner: TCustomVirtualBreadCrumbBar);
begin
  inherited Create;
  Owner := AnOwner;
end;

destructor TBreadCrumbBarObject.Destroy;
begin
  inherited Destroy;
end;

function TBreadCrumbBarObject.GetClicking: Boolean;
begin
  Result := vbcsClicking in State
end;

function TBreadCrumbBarObject.GetDown: Boolean;
begin
  Result := vbcsDown in State
end;

function TBreadCrumbBarObject.GetDropDownHot: Boolean;
begin
  Result := vbsDropDownHot in State
end;

function TBreadCrumbBarObject.GetHovering: Boolean;
begin
  Result := vbcsHovering in State
end;

function TBreadCrumbBarObject.GetMenuShown: Boolean;
begin
  Result := vbcsMenuShown in State
end;

function TBreadCrumbBarObject.PtInDropDownButton(Pt: TPoint): Boolean;
begin
  Result := False
end;

procedure TBreadCrumbBarObject.Click(Pt: TPoint);
begin
  MessageBox(0, 'Clicked me', '', MB_OK);
end;

procedure TBreadCrumbBarObject.Invalidate(Immediate: Boolean);
begin
  if Assigned(Owner) and Owner.HandleAllocated then
    InvalidateRect(Owner.Handle, @FDisplayRect, Immediate);
end;

procedure TBreadCrumbBarObject.Paint(ACanvas: TCanvas);
begin

end;

function TBreadCrumbBarObject.PtInDisplayRect(Pt: TPoint): Boolean;
begin
  Result := PtInRect(DisplayRect, Pt)
end;

procedure TBreadCrumbBarObject.SetClicking(const Value: Boolean);
begin
  if Value then
    Include(FState, vbcsClicking)
  else
    Exclude(FState, vbcsClicking)
end;

procedure TBreadCrumbBarObject.SetDown(const Value: Boolean);
begin
  if Value then
    Include(FState, vbcsDown)
  else
    Exclude(FState, vbcsDown)
end;

procedure TBreadCrumbBarObject.SetDropDownHot(const Value: Boolean);
begin
  if Value then
    Include(FState, vbsDropDownHot)
  else
    Exclude(FState, vbsDropDownHot)
end;

procedure TBreadCrumbBarObject.SetHovering(const Value: Boolean);
begin
  if Value then
    Include(FState, vbcsHovering)
  else
    Exclude(FState, vbcsHovering)
end;

procedure TBreadCrumbBarObject.SetMenuShown(const Value: Boolean);
begin
  if Value then
    Include(FState, vbcsMenuShown)
  else
    Exclude(FState, vbcsMenuShown)
end;

{ TBreadCrumbBarPathObject}
constructor TBreadCrumbBarPathObject.Create(AnOwner: TCustomVirtualBreadCrumbBar; ANamespace: TNamespace);
begin
  inherited Create(AnOwner);
  Namespace := ANamespace;
end;

destructor TBreadCrumbBarPathObject.Destroy;
begin
  Namespace.Free;
  inherited Destroy;
end;

function TBreadCrumbBarPathObject.EnumFunc(MessageWnd: HWnd; APIDL: PItemIDList; AParent: TNamespace; Data: Pointer; var Terminate: Boolean): Boolean;
var
  MenuItem: TMenuItem;
  NS: TNamespace;
begin
  MenuItem := TMenuItem.Create(TPopupMenu( Data));
  NS := TNamespace.Create(APIDL, AParent); // Let the NS free the PIDL
  MenuItem.Caption := NS.NameNormal;
  MenuItem.OnClick := OnPopupMenuClick;
  if Assigned(TPopupMenu( Data).Images) then
    MenuItem.ImageIndex := NS.GetIconIndex(False, icSmall);
  TPopupMenu( Data).Items.Add(MenuItem);
  NS.Free;
  Result := True
end;

function TBreadCrumbBarPathObject.PtInDropDownButton(Pt: TPoint): Boolean;
begin
  Result := PtInRect(DropDownArrowRect, Pt)
end;

procedure TBreadCrumbBarPathObject.Click(Pt: TPoint);
var
  Menu: TPopupMenu;
  OriginPt: TPoint;
begin
  if PtInDropDownButton(Pt) then
  begin
    Menu := TPopupMenu.Create(nil);
    try
      if vbcoMenuIcons in Owner.Options then
        Menu.Images := SmallSysImages;
      Namespace.EnumerateFolderEx(0, Owner.FileObjects, EnumFunc, Menu);
      OriginPt := Point(DisplayRect.Left, DisplayRect.Bottom);
      OriginPt := Owner.ClientToScreen(OriginPt);
      MenuShown := True;
      Invalidate(True);
      Include( Owner.FState, vbcsMenuTracking); // Enter the special state where the menus stay open as you move from crumb to crumb
      Owner.TrackingMenu := Menu;
      Menu.Popup(OriginPt.x, OriginPt.y);
      if Owner.TrackingMenu = Menu then
        Owner.TrackingMenu := nil;
      MenuShown := False;
    finally
      FreeAndNil(Menu);
      Down := False;
    end
  end else
    inherited Click(Pt);
end;

procedure TBreadCrumbBarPathObject.OnPopupMenuClick(Sender: TObject);
begin

end;

procedure TBreadCrumbBarPathObject.Paint(ACanvas: TCanvas);
var
  Flags: TCommonDrawTextWFlags;
  R: TRect;
  Color1, Color2: TColor;
begin
  ACanvas.Pen.Color := clWindowText;
  ACanvas.Font.Color := clWindowText;
  Flags := [dtSingleLine, dtCenter, dtVCenter];
  if vbcsHovering in State then
  begin
    // Draw the Border
    ACanvas.Pen.Color := Owner.PaintOptions.BorderColor;
    R := DisplayRect;
    if Owner.PaintOptions.Rounded then
      ACanvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, Owner.PaintOptions.Radius, Owner.PaintOptions.Radius)
    else begin
      ACanvas.Brush.Color := Owner.PaintOptions.BorderColor;
      ACanvas.FrameRect(R);
    end;

    // Make a clipping region for the border
    if Owner.PaintOptions.Rounded then
    begin
      BeginPath(ACanvas.Handle);
      RoundRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom, Owner.PaintOptions.Radius, Owner.PaintOptions.Radius);
      EndPath(ACanvas.Handle);
      IntersectClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
      SelectClipPath(ACanvas.Handle, RGN_AND); // Intersection of Clip and Path
    end else
      IntersectClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);

    InflateRect(R, -1, -1);
    // Paint the inactive color across the entire object (unless the menu is shown
    if MenuShown then
    begin
      Color1 := Owner.PaintOptions.GradientStartColorActive;
      Color2 := Owner.PaintOptions.GradientEndColorActive
    end else
    begin
      Color1 := Owner.PaintOptions.GradientStartColorInActive;
      Color2 := Owner.PaintOptions.GradientEndColorInActive
    end;
    if Owner.PaintOptions.Gradient then
      FillGradient(R.Left, R.Top, R.Right, R.Bottom-1, Color1, Color2, R.Top, R.Bottom, ACanvas)
    else begin
      ACanvas.Brush.Color := Color1;
      ACanvas.FillRect(R)
    end;

    // Decide what button to draw "hot"
    if DropDownHot then
      R := DropDownArrowRect
    else
      R := ButtonRect;

    InflateRect(R, -1, -1);
    // Fill the region that is hot
    if Owner.PaintOptions.Gradient then
      FillGradient(R.Left, R.Top, R.Right, R.Bottom-1, Owner.PaintOptions.GradientStartColorActive, Owner.PaintOptions.GradientEndColorActive, R.Top, R.Bottom, ACanvas)
    else begin
      ACanvas.Brush.Color := Owner.PaintOptions.GradientStartColorActive;
      ACanvas.FillRect(R)
    end;

    SelectClipRgn(ACanvas.Handle, 0);
  end;

  // Now paint the Folder text
  ACanvas.Brush.Style := bsClear;
  R := ButtonRect;
  if vbcsHovering in State then
  begin
    if DropDownHot and not MenuShown then
      ACanvas.Font.Color := Owner.PaintOptions.TextColorInActive
    else
      ACanvas.Font.Color := Owner.PaintOptions.TextColorActive;
  end;

  if Down and Hovering and not (DropDownHot or MenuShown) then
  begin
    Inc(R.Top);
    Inc(R.Left, 2)
  end;
  DrawTextWEx(ACanvas.Handle, Namespace.NameNormal, R, Flags, 1);

  // Now paint the Arrow text
  ACanvas.Font.Assign(MarlettFont);
  ACanvas.Font.Size := ACanvas.Font.Size + MARLETT_SIZE_INC;

  R := DropDownArrowRect;
  if Hovering then
  begin
    if DropDownHot or MenuShown then
      ACanvas.Font.Color := Owner.PaintOptions.TextColorActive
    else
      ACanvas.Font.Color := Owner.PaintOptions.TextColorInActive
  end;

  if Down and Hovering and DropDownHot and not MenuShown then
  begin
    Inc(R.Top);
    Inc(R.Left, 2)
  end;

  if MenuShown then
    DrawTextWEx(ACanvas.Handle, '6', R, Flags, 1)
  else
    DrawTextWEx(ACanvas.Handle, '4', R, Flags, 1)
end;

{ TBreadCrumbBarPathObjects }
constructor TBreadCrumbBarPathObjects.Create;
begin
  inherited Create;
  Crumbs := TList.Create;
end;

destructor TBreadCrumbBarPathObjects.Destroy;
begin
  Clear;
  FreeAndNil(FCrumbs);
  inherited Destroy;
end;

function TBreadCrumbBarPathObjects.GetCount: Integer;
begin
  Result := Crumbs.Count;
end;


function TBreadCrumbBarPathObjects.GetItems(Index: Integer): TBreadCrumbBarPathObject;
begin
  Result := TBreadCrumbBarPathObject( Crumbs[Index])
end;

procedure TBreadCrumbBarPathObjects.Add(Item: TBreadCrumbBarPathObject);
begin
  Crumbs.Add(Item)
end;

procedure TBreadCrumbBarPathObjects.Clear;
var
  i: Integer;
begin
  try
    for i := 0 to Count - 1 do
      TObject( Crumbs[i]).Free;
  finally
    Crumbs.Clear;
  end
end;

procedure TBreadCrumbBarPathObjects.SetItems(Index: Integer; Value: TBreadCrumbBarPathObject);
begin
  Crumbs[Index] := Value
end;

{ TVirtualBreadCrumbBarPaintOptions }
constructor TVirtualBreadCrumbBarPaintOptions.Create;
begin
  inherited Create;
  BorderColor := clHighlight;
  FillColor := clHighlight;
  GradientEndColorActive := clWindow;
  GradientEndColorInActive := clWindow;
  GradientStartColorActive := clHighlight;
  GradientStartColorInActive := clBtnFace;
  TextColorActive := clHighlightText;
  TextColorInActive := clWindowText;
  Radius :=  4;
end;

end.
