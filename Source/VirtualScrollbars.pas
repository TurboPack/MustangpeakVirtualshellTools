unit VirtualScrollbars;

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
// Contains an Ownerdraw Vertical Scrollbar implementation for the scrollbar used
// in the Explorer Combobox popup windows.  It would take very little work to make
// is work in Horizontal mode too.  The main reason for doing this is to allow
// the popup scrollbar to be theme enabled like the rest of VET even without a
// Manifest.

interface

{$include Compilers.inc}
{$include ..\Include\AddIns.inc}

{$ifdef COMPILER_12_UP}
  {$WARN IMPLICIT_STRING_CAST       OFF}
 {$WARN IMPLICIT_STRING_CAST_LOSS  OFF}
{$endif COMPILER_12_UP}

uses
  {$IFDEF COMPILER_9_UP}
  Types,
  {$ENDIF}
  Windows,
  Messages, SysUtils, Classes, Graphics, Controls, Forms,
  {$IFDEF COMPILER_7_UP}
  Themes,
  {$ELSE}
  TMSchema, // Windows XP themes support for D5-D6. Get these units from www.delphi-gems.com.
  {$ENDIF}
  UxTheme;  // Windows XP themes support for D5-D6. Get these units from www.delphi-gems.com.


const
  ID_TIMERHOT = 201;             // ID for timer to track hot button activation/deactivation (CM_MouseLeave unreliable)
  ID_TIMERAUTOSCROLL = 202;      // ID for auto scroll timer
  ID_TIMERAUTOSCROLLDELAY = 203; // ID for auto scroll delay timer

  TIME_AUTOSCROLLDELAY = 500; // milliseconds before autoscroll starts
  TIMER_HOT = 50;             // milliseconds between checking mouse postions for mouse exit or hot button activation

type
  TScrollDimensions = (
    sbVArrowWidth,       // Arrow button width of vertical scrollbar
    sbVArrowHeight,      // Arrow button height of vertical scrollbar
    sbVThumbHeight,      // Minimum thumb box height of vertical scrollbar
    sbVThumbClientHeight // Height of the client area where the Thumb is constrained
  );

  TScrollArea = (
    saBackground,          // The client area of the scrollbar
    saScrollUp,            // The scroll up/left button
    saScrollDown,          // The scroll down/right button
    saThumb,               // The scroll dragable thumbbox
    saThumbClient,         // The "client" area that the Thumb is contained in
    saThumbPageDownClient, // The "client" area between the down button and the thumb button
    saThumbPageUpClient    // The "client" area between the up button and the thumb button
  );

  TScrollPaintCycle = (
    pcBackground,       // Paint the background
    pcScrollUp,         // Paint the Up/Left button
    pcScrollDown,       // Paint the Down/Right button
    pcThumb             // Paint the ThumbBox
  );

  TScrollPaintState = (
    psNormal,
    psHot,
    psPressed,
    psScrolling,
    psDisabled
  );

  TScrollState = (
    ssDraggingThumb,        // The mouse is dragging the Thumb knob
    ssDownPressed,          // Down Button is pressed
    ssHotDown,              // Mouse is over the Down button
    ssHotThumb,             // Mouse is over the ThumbButton
    ssHotUp,                // Mouse is over the Up button
    ssMouseCaptured,        // The control has captured the mouse
    ssPageDownPressed,      // The Thumb client area is pressed to the down side of the thumb button
    ssPageScrollPause,      // The cursor has hit the Thumbbutton during the scroll and the scroll has paused
    ssPageUpPressed,        // The Thumb client area is pressed to the up side of the thumb button
    ssScrollDown,           // The control is in the middle of a Scroll down
    ssScrollUp,             // The control is in the middle of a Scroll up
    ssUpPressed,            // The Up button is pressed
    ssThemesAvailable       // Caches the UsesTheme call in the JwaUxTheme.pas file
  );
  TScrollStates = set of TScrollState;

  TScrollOption = (
    soThemeAware       // If set and Themes are available the use Theme Drawing API
  );
  TScrollOptions = set of TScrollOption;


{$IFNDEF DELPHI_5_UP}
  // The next both message records are not declared in Delphi 5 and lower.
  TWMPrint = packed record
    Msg: Cardinal;
    DC: HDC;
    Flags: LPARAM;
    Result: LRESULT;
  end;

  TWMPrintClient = TWMPrint;
{$ENDIF}

type
  TCustomOwnerDrawScrollbar = class;  // forward

  TScrollBarColors = class(TPersistent)
  private
    FThumbButton: TColor;
    FBackGround: TColor;
    FPageScrollHot: TColor;
    FScrollbar: TCustomOwnerDrawScrollbar;
    FBackgroundBlend: TColor;
    procedure SetBackground(const Value: TColor);
    procedure SetBackgroundBlend(const Value: TColor);
    procedure SetThumbButton(const Value: TColor);
  public
    constructor Create(AScrollbar: TCustomOwnerDrawScrollbar);
    property Scrollbar: TCustomOwnerDrawScrollbar read FScrollbar;

  published
    property PageScrollHot: TColor read FPageScrollHot write FPageScrollHot default clBlack;
    property Background: TColor read FBackGround write SetBackground default clScrollbar;
    property BackgroundBlend: TColor read FBackgroundBlend write SetBackgroundBlend default clWhite;
    property ThumbButton: TColor read FThumbButton write SetThumbButton default clScrollbar;
  end;

  TOnScrollCustomPaint = procedure(Sender: TCustomOwnerDrawScrollbar;
    PaintCycle: TScrollPaintCycle; ScrollPaintState: TScrollPaintState;
    PaintRect: TRect; Canvas: TCanvas; var Handled: Boolean) of object;


  TCustomOwnerDrawScrollbar = class(TCustomControl)
  private
    FOnScrollCustomPaint: TOnScrollCustomPaint;
    FBkGndBrush: TBrush;
    FState: TScrollStates;
    FFlat: Boolean;
    FMin: integer;
    FMax: integer;
    FPosition: integer;
    FPageSize: integer;
    FTimerHot: THandle;
    FTimerAutoScroll: THandle;
    FTimerAutoScrollDelay: THandle;
    FAutoScrollTime: integer;
    FColors: TScrollBarColors;
    FOptions: TScrollOptions;
    FThemeScrollbar: HTheme;
    FOwnerControl: TWinControl;
    FLargeChange: integer;
    FSmallChange: integer;
    procedure SetPosition(const Value: integer);
    procedure SetState(const Value: TScrollStates);
    procedure SetFlat(const Value: Boolean);
    function GetThemed: Boolean;
    procedure SetPageSize(const Value: integer);
    procedure SetMax(const Value: integer);
    procedure SetMin(const Value: integer);
    function GetMax: integer;
  protected
    function CalcuatePositionByPixel(APixel: integer): integer;
    function CalculateThumbCenterPixel: integer;
    function CanScrollPage: Boolean;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;

    procedure DoPaintScrollBkgnd(DC: hDC);
    procedure DoPaintScrollButton(Cycle: TScrollPaintCycle; DC: hDC);
    procedure FreeThemes;
    procedure HandleAutoScrollTimer(Enable, DelayTimer: Boolean);
    procedure HandleHotTimer(Enable: Boolean);
    procedure HandleHotTracking(MousePos: TPoint; ForceClearAll: Boolean);
    procedure OpenThemes;
    function Metric(Dimension: TScrollDimensions): Integer;
    procedure Paint; override;
    procedure RebuildDefaultColors;
    function SendScrollMsg(ScrollCode: Longword; NewPos: integer = 0): Boolean;
    function ScrollArea(Area: TScrollArea): TRect;
    procedure ScrollClick(Pos: TPoint);
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMMouseActivate(var Message: TWMMouseActivate); message WM_MOUSEACTIVATE;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMPrintClient(var Message: TWMPrintClient); message WM_PRINTCLIENT ;
    procedure WMSysColorChange(var Message: TWMSysColorChange); message WM_SYSCOLORCHANGE;
    procedure WMThemeChanged(var Message: TMessage); message WM_THEMECHANGED;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;

    property AutoScrollTime: integer read FAutoScrollTime write FAutoScrollTime default 100; // ms
    property BkGndBrush: TBrush read FBkGndBrush write FBkGndBrush;
    property Colors: TScrollBarColors read FColors write FColors;
    property Flat: Boolean read FFlat write SetFlat default False;
    property LargeChange: integer read FLargeChange write FLargeChange default 1;
    property Max: integer read GetMax write SetMax default 100;
    property Min: integer read FMin write SetMin default 0;
    property OnScrollCustomPaint: TOnScrollCustomPaint read FOnScrollCustomPaint write FOnScrollCustomPaint;
    property Options: TScrollOptions read FOptions write FOptions default [soThemeAware];
    property PageSize: integer read FPageSize write SetPageSize default 1;
    property Position: integer read FPosition write SetPosition default 0;
    property SmallChange: integer read FSmallChange write FSmallChange default 1;
    property Themed: Boolean read GetThemed;
    property ThemeScrollbar: HTheme read FThemeScrollbar write FThemeScrollbar;
    property TimerAutoScroll: THandle read FTimerAutoScroll write FTimerAutoScroll;
    property TimerAutoScrollDelay: THandle read FTimerAutoScrollDelay write FTimerAutoScrollDelay;
    property TimerHot: THandle read FTimerHot write FTimerHot;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetRange(AMin, AMax: integer);

    property OwnerControl: TWinControl read FOwnerControl write FOwnerControl;
    property State: TScrollStates read FState write SetState;
  end;

  TOwnerDrawScrollbar = class(TCustomOwnerDrawScrollbar)
  published
    property Colors;
    property Flat;
    property LargeChange;
    property Max;
    property Min;
    property OnScrollCustomPaint;
    property Options;
    property PageSize;
    property Position;
    property SmallChange;
  end;

implementation

{ TCustomOwnerDrawScrollbar }

function TCustomOwnerDrawScrollbar.CalcuatePositionByPixel(APixel: integer): integer;

// Returns the postion of the scrollbar referenced by a particular pixel in the scrollbar

var
  R: TRect;
  PagesPerPixel: Single;
begin
  R := ScrollArea(saThumbClient); // Get the thumbs client area
  InflateRect(R, 0, -Metric(sbVThumbHeight) div 2);
  if APixel < R.Top then
    Result := 0
  else
  if APixel > R.Bottom then
    Result := Max
  else begin
    PagesPerPixel := (Max - Min) / (R.Bottom - R.Top);
    Result := Round(PagesPerPixel * (APixel - R.Top))
  end
end;

function TCustomOwnerDrawScrollbar.CalculateThumbCenterPixel: integer;

// Returns the coordinate of the center of the thumb button based on the current
// Min, Max and Position

var
  R: TRect;
  PixelsPerPage: Single;
begin
  R := ScrollArea(saThumbClient); // Get the thumbs client area

  // Special Cases
  if Position = Min then
  // At Minimum position
    Result := R.Top + Metric(sbVThumbHeight) div 2
  else
  if Position = Max then
  // At Maximum position
    Result := R.Bottom - Metric(sbVThumbHeight) div 2
  else
  // Somewhere in between
  begin
    InflateRect(R, 0, -Metric(sbVThumbHeight) div 2);
    PixelsPerPage := (R.Bottom - R.Top) / (Max - Min);
    Result := R.Top + Round(PixelsPerPage * Position)
  end
end;

function TCustomOwnerDrawScrollbar.CanScrollPage: Boolean;

// Stop the scroll if the cursor hits the thumb button or is on the wrong side of the thumb button

var
  R: TRect;
begin
  if ssPageDownPressed in State then
    R := ScrollArea(saThumbPageDownClient)
  else
  if ssPageUpPressed in State then
    R := ScrollArea(saThumbPageUpClient);
  R.BottomRight := ClientToScreen(R.BottomRight);
  R.TopLeft := ClientToScreen(R.TopLeft);
  Result := PtInRect(R, Mouse.CursorPos);
  if Result then
    Include(FState, ssPageScrollPause)
  else
    Exclude(FState, ssPageScrollPause)
end;

constructor TCustomOwnerDrawScrollbar.Create(AOwner: TComponent);
begin
  inherited;
  Colors := TScrollBarColors.Create(Self);
  Height := 200;
  Width := GetSystemMetrics(SM_CXVSCROLL);
  Color := clScrollbar;
  TabStop := False;
  FMin := 0;
  FMax := 100;
  FPageSize := 1;
  FSmallChange := 1;
  LargeChange := 1;
  AutoScrollTime := 100;
  Options := [soThemeAware];
  BkGndBrush := TBrush.Create;
  BkGndBrush.Bitmap := TBitmap.Create;
  // Must by 8x8 for Win98 and lower
  BkGndBrush.Bitmap.Width := 8;
  BkGndBrush.Bitmap.Height := 8;
end;

procedure TCustomOwnerDrawScrollbar.CreateParams(
  var Params: TCreateParams);
begin
  inherited;
end;

procedure TCustomOwnerDrawScrollbar.CreateWnd;
begin
  inherited;
  RebuildDefaultColors;
  Perform(WM_THEMECHANGED, 0, 0);
end;

destructor TCustomOwnerDrawScrollbar.Destroy;
begin
  BkGndBrush.Bitmap.Free;
  BkGndBrush.Bitmap := nil;
  BkGndBrush.Free;
  Colors.Free;
  FreeThemes;
  inherited;
end;

procedure TCustomOwnerDrawScrollbar.DoPaintScrollBkgnd(DC: hDC);
var
  Handled: Boolean;
  PartType, PartState: Longword;
  RUp, RDown: TRect;
begin
  Handled := False;
  if Assigned(OnScrollCustomPaint) then
    OnScrollCustomPaint(Self, pcBackground, psNormal, ScrollArea(saBackground),
      Canvas, Handled);
  if not Handled then
  begin
    RUp := ScrollArea(saThumbPageUpClient);
    RDown := ScrollArea(saThumbPageDownClient);
    if ssPageDownPressed in State then
    begin
      if Themed then
      begin
        PartType := SBP_UPPERTRACKVERT;
        PartState := SCRBS_PRESSED;
        DrawThemeBackground(ThemeScrollbar, DC, PartType, PartState, RDown, nil);
        PartState := SCRBS_NORMAL;
        DrawThemeBackground(ThemeScrollbar, DC, PartType, PartState, RUp, nil);
      end else
      begin
        Windows.FillRect(DC, RUp, BkGndBrush.Handle);
        Canvas.Brush.Color := Colors.PageScrollHot;
        Windows.FillRect(DC, RDown, Canvas.Brush.Handle);
      end
    end else
    if ssPageUpPressed in State then
    begin
      if Themed then
      begin
        PartType := SBP_LOWERTRACKVERT;
        PartState := SCRBS_PRESSED;
        DrawThemeBackground(ThemeScrollbar, DC, PartType, PartState, RUp, nil);
        PartState := SCRBS_NORMAL;
        DrawThemeBackground(ThemeScrollbar, DC, PartType, PartState, RDown, nil);
      end else
      begin
        Windows.FillRect(DC, RDown, BkGndBrush.Handle);
        Canvas.Brush.Color := Colors.PageScrollHot;
        Windows.FillRect(DC, RUp, Canvas.Brush.Handle);
      end
    end else
    begin
      if Themed then
      begin
        PartType := SBP_UPPERTRACKVERT;
        PartState := SCRBS_NORMAL;
        DrawThemeBackground(ThemeScrollbar, DC, PartType, PartState, RUp, nil);

        PartType := SBP_LOWERTRACKVERT;
        DrawThemeBackground(ThemeScrollbar, DC, PartType, PartState, RDown, nil);
      end else
      begin
        Windows.FillRect(DC, RUp, BkGndBrush.Handle);
        Windows.FillRect(DC, RDown, BkGndBrush.Handle);
      end
    end
  end
end;

procedure TCustomOwnerDrawScrollbar.DoPaintScrollButton(Cycle: TScrollPaintCycle; DC: hDC);
var
  Handled: Boolean;
  Flags: Longword;
  R, ContentR: TRect;
  PartType, PartState: Longword;
begin
  Handled := False;
  Flags := 0;
  if Assigned(OnScrollCustomPaint) then
    OnScrollCustomPaint(Self, pcScrollDown, psNormal, ScrollArea(saScrollDown), Canvas, Handled);
  if not Handled then
  begin
    if Cycle = pcScrollUp then
    begin
      R := ScrollArea(saScrollUp);
      if Themed then
      begin
        PartType := SBP_ARROWBTN;

        PartState := ABS_UPNORMAL;
        if not Enabled then
          PartState := ABS_UPDISABLED
        else
        if ssUpPressed in State then
          PartState := ABS_UPPRESSED
        else
        if ssHotUp in State then
          PartState := ABS_UPHOT;

        DrawThemeBackground(ThemeScrollbar, DC, PartType, PartState, R, nil);
      end else
      begin
        Flags := DFCS_SCROLLUP;

        if not Enabled then
          Flags := DFCS_INACTIVE
        else begin
          if Flat then
            Flags := Flags or DFCS_FLAT;
          if ssUpPressed in State then
            if Flat then
              Flags := Flags or DFCS_PUSHED
            else
              Flags := Flags or DFCS_FLAT
        end;
        DrawFrameControl(DC, R, DFC_SCROLL, Flags)
      end
    end else
    if Cycle = pcScrollDown then
    begin
      R := ScrollArea(saScrollDown);
      if Themed then
      begin
        PartType := SBP_ARROWBTN;

        PartState := ABS_DOWNNORMAL;
        if not Enabled then
          PartState := ABS_DOWNDISABLED
        else
        if ssDownPressed in State then
          PartState := ABS_DOWNPRESSED
        else
        if ssHotDown in State then
          PartState := ABS_DOWNHOT;

        DrawThemeBackground(ThemeScrollbar, DC, PartType, PartState, R, nil);
      end else
      begin
        Flags := DFCS_SCROLLDOWN;

        if not Enabled then
          Flags := DFCS_INACTIVE
        else begin
          if Flat then
            Flags := Flags or DFCS_FLAT;
          if ssDownPressed in State then
            if Flat then
              Flags := Flags or DFCS_PUSHED
            else
              Flags := Flags or DFCS_FLAT     
        end;
        DrawFrameControl(DC, R, DFC_SCROLL, Flags)
      end
    end else
    if Cycle = pcThumb then
    begin
      R := ScrollArea(saThumb);
      if Themed then
      begin
        if R.Bottom - R.Top > 0 then
        begin
          PartType := SBP_THUMBBTNVERT;

          PartState := SCRBS_NORMAL;
          if not Enabled then
            PartState := SCRBS_DISABLED
          else
          if ssDraggingThumb in State then
            PartState := SCRBS_PRESSED
          else
          if ssHotThumb in State then
            PartState := SCRBS_HOT;

          DrawThemeBackground(ThemeScrollbar, DC, PartType, PartState, R, nil);
          GetThemeBackgroundContentRect(ThemeScrollbar, DC, PartType, PartState, R, @ContentR);

          PartType := SBP_GRIPPERVERT;
          DrawThemeBackground(ThemeScrollbar, DC, PartType, PartState, ContentR, nil);
        end
      end else
      begin
        Canvas.Brush.Color := Colors.ThumbButton;
        FillRect(DC, R, Canvas.Brush.Handle);
        if not Flat then
        begin
          Flags := EDGE_RAISED;
          DrawEdge(DC, R, Flags, BF_RECT)
        end else
        begin
          Canvas.Brush.Color := clBtnShadow;
          Canvas.FrameRect(R);
        end;
        DrawEdge(DC, R, Flags, BF_RECT)
      end
    end
  end
end;

procedure TCustomOwnerDrawScrollbar.FreeThemes;
begin
  if ThemeScrollbar <> 0 then
    CloseThemeData(ThemeScrollbar);
  ThemeScrollbar := 0;
end;

function TCustomOwnerDrawScrollbar.GetMax: integer;
begin
  // Make bottom of page stop at bottom of window. Don't scroll into empty whitespace
  Result := FMax - FPageSize;
end;

function TCustomOwnerDrawScrollbar.GetThemed: Boolean;
begin
  Result := (ssThemesAvailable in State) and (soThemeAware in Options)
end;

procedure TCustomOwnerDrawScrollbar.HandleAutoScrollTimer(Enable, DelayTimer: Boolean);

    procedure KillDelayTimer;
    begin
      if TimerAutoScrollDelay <> 0 then
      begin
        KillTimer(Handle, TimerAutoScrollDelay);
        TimerAutoScrollDelay := 0;
      end
    end;

    procedure KillScrollTimer;
    begin
      if TimerAutoScroll <> 0 then
      begin
        KillTimer(Handle, TimerAutoScroll);
        TimerAutoScroll := 0;
      end
    end;

begin
  if Enable then
  begin
    if Enable and (not DelayTimer) and (TimerAutoScroll = 0) then
    begin
      KillDelayTimer;
      TimerAutoScroll := SetTimer(Handle, ID_TIMERAUTOSCROLL, AutoScrollTime, nil)
    end;
    if Enable and DelayTimer and (TimerAutoScrollDelay = 0) then
    begin
      KillScrollTimer;
      TimerAutoScrollDelay := SetTimer(Handle, ID_TIMERAUTOSCROLLDELAY, TIME_AUTOSCROLLDELAY, nil)
    end;
  end else
  begin
    KillDelayTimer;
    KillScrollTimer;
  end;
end;

procedure TCustomOwnerDrawScrollbar.HandleHotTimer(Enable: Boolean);
begin
  if Enable and (TimerHot = 0) then
    TimerHot := SetTimer(Handle, ID_TIMERHOT, TIMER_HOT, nil);
  if not Enable and (TimerHot <> 0) then
  begin
    KillTimer(Handle, TimerHot);
    TimerHot := 0
  end
end;

procedure TCustomOwnerDrawScrollbar.HandleHotTracking(MousePos: TPoint; ForceClearAll: Boolean);
begin
  if PtInRect(ScrollArea(saScrollUp), MousePos) then
  begin
    if not (ssHotUp in State) then
      State := State + [ssHotUp] - [ssHotDown, ssHotThumb];
  end else
  if PtInRect(ScrollArea(saScrollDown), MousePos) then
  begin
    if not (ssHotDown in State) then
      State := State + [ssHotDown] - [ssHotUp, ssHotThumb];
  end else
  if PtInRect(ScrollArea(saThumb), MousePos) then
  begin
    if not (ssHotThumb in State) then
      State := State + [ssHotThumb] - [ssHotUp, ssHotDown];
  end else
  if ForceClearAll or ((State * [ssHotUp, ssHotDown, ssHotThumb] <> []) and not (ssDraggingThumb in State)) then
    State := State - [ssHotUp, ssHotDown, ssHotThumb];
end;

procedure TCustomOwnerDrawScrollbar.Loaded;
begin
  inherited;
end;

function TCustomOwnerDrawScrollbar.Metric(Dimension: TScrollDimensions): Integer;
var
  Percent: Single;
  Temp: integer;
begin
  Result := 0;
  case Dimension of
    sbVArrowWidth  : Result := GetSystemMetrics(SM_CXVSCROLL);
    sbVArrowHeight :
      begin
        Temp := GetSystemMetrics(SM_CYVSCROLL);
        if Height > 2 * Temp then
          Result := Temp
        else
          Result := Height div 2;
      end;
    sbVThumbHeight :
      begin
        Temp := Metric(sbVThumbClientHeight);
        // Calculate the percent of the total window height that is visible (one page)
        // Note we are calcuating FMax and not using the adjusted Max returned by the property getter
        Percent := PageSize / (FMax - FMin);
        Result := Round(Percent * Temp);
        if Result < GetSystemMetrics(SM_CYVTHUMB) div 2 then
          Result := GetSystemMetrics(SM_CYVTHUMB) div 2;
        if Temp - Result < 0 then
          Result := 0;
      end;
    sbVThumbClientHeight:
      begin
        Temp := GetSystemMetrics(SM_CYVSCROLL);
        if Height > 2 * Temp then
          Result := Height - (2 * Temp)
        else
          Result := 0
      end;
  end;
end;

procedure TCustomOwnerDrawScrollbar.OpenThemes;
begin
  ThemeScrollbar := OpenThemeData(Handle, 'scrollbar');
end;

procedure TCustomOwnerDrawScrollbar.Paint;
begin
  DoPaintScrollButton(pcScrollUp, Canvas.Handle);
  DoPaintScrollButton(pcScrollDown, Canvas.Handle);
  DoPaintScrollButton(pcThumb, Canvas.Handle);
end;

procedure TCustomOwnerDrawScrollbar.RebuildDefaultColors;
var
  i, j: integer;
begin
  for i := 0 to 7 do
    for j := 0 to 7 do
      if Odd(i+j) then
        BkGndBrush.Bitmap.Canvas.Pixels[i,j] := Colors.Background
      else
        BkGndBrush.Bitmap.Canvas.Pixels[i,j] := Colors.BackgroundBlend;
  Invalidate;
  Update
end;

function TCustomOwnerDrawScrollbar.ScrollArea(Area: TScrollArea): TRect;

// Calculates the rectangle bounding the control components passed in the parameter

begin
  Result := ClientRect;

  case Area of
    saBackground:
        InflateRect(Result, 0, -Metric(sbVArrowWidth));
    saScrollUp:
        SetRect(Result, Result.Left, Result.Top, Result.Left + Metric(sbVArrowWidth), Result.Top + Metric(sbVArrowHeight));
    saScrollDown:
        SetRect(Result, Result.Left, Result.Bottom - Metric(sbVArrowHeight), Result.Left + Metric(sbVArrowWidth), Result.Bottom);
    saThumb:
        begin
          Result := ScrollArea(saThumbClient);
          Result.Top := CalculateThumbCenterPixel - Metric(sbVThumbHeight) div 2;
          Result.Bottom := Result.Top + Metric(sbVThumbHeight)
        end;
    saThumbClient:
        InflateRect(Result, 0, -Metric(sbVArrowHeight));
    saThumbPageDownClient:
        begin
          Result := ScrollArea(saThumbClient);
          Result.Top := ScrollArea(saThumb).Bottom;
        end;
    saThumbPageUpClient:
        begin
          Result := ScrollArea(saThumbClient);
          Result.Bottom := ScrollArea(saThumb).Top;
        end;
  else
    SetRect(Result, 0, 0, 0, 0);
  end;
end;

procedure TCustomOwnerDrawScrollbar.ScrollClick(Pos: TPoint);
begin
  if PtInRect(ScrollArea(saScrollUp), Pos) then
  begin
    State := State + [ssUpPressed];
    if not SendScrollMsg(SB_LINEUP) then
      Position := Position - SmallChange;
  end else
  if PtInRect(ScrollArea(saScrollDown), Pos) then
  begin
    State := State + [ssDownPressed];
    if not SendScrollMsg(SB_LINEDOWN) then
      Position := Position + SmallChange;
  end else
  if PtInRect(ScrollArea(saThumb), Pos) then
    State := State + [ssDraggingThumb]
  else
  if PtInRect(ScrollArea(saThumbPageDownClient), Pos) then
  begin
    State := State + [ssPageDownPressed];
    if not SendScrollMsg(SB_PAGEDOWN) then
      Position := Position + LargeChange;
  end else
  if PtInRect(ScrollArea(saThumbPageUpClient), Pos) then
  begin
    State := State + [ssPageUpPressed];
    if not SendScrollMsg(SB_PAGEUP) then
      Position := Position - LargeChange;
  end
end;

function TCustomOwnerDrawScrollbar.SendScrollMsg(ScrollCode: Longword; NewPos: integer = 0): Boolean;

// Scroll the ControlWnd then readjusts the scroll bar to match the new state
// of the window.  Returns false if the scroll bar has no control parent

var
  Msg: Longword;
begin
  Result := False;
  if Assigned(OwnerControl) then
  begin
    Msg := WM_VSCROLL;
    // Send the Scrollbar message
    SendMessage(OwnerControl.Handle, Msg, WPARAM(MakeLong(ScrollCode, NewPos)), LPARAM(Self));
    // All code message are followed by EndScroll except Thumbtrack
    if ScrollCode <> SB_THUMBTRACK then
      SendMessage(OwnerControl.Handle, Msg, WPARAM(MakeLong(SB_ENDSCROLL, 0)), LPARAM(Self));
    Result := True;
  end;
end;

procedure TCustomOwnerDrawScrollbar.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
begin
  if not (csLoading in ComponentState) then
    AWidth := Metric(sbVArrowWidth);
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TCustomOwnerDrawScrollbar.SetFlat(const Value: Boolean);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    Invalidate;
    Update;
  end;
end;

procedure TCustomOwnerDrawScrollbar.SetMax(const Value: integer);
begin
  if (Value <> FMax) then
  begin
    FMax := Value;
    if not (FMax > FMin) then
      FMax := FMin + 1
  end
end;

procedure TCustomOwnerDrawScrollbar.SetMin(const Value: integer);
begin
  if (FMin <> Value) then
  begin
    FMin := Value;
    if FMin >= FMax then
      FMin := FMax - 1
  end
end;

procedure TCustomOwnerDrawScrollbar.SetPageSize(const Value: integer);
begin
  if (Value <> FPageSize) then
  begin
    FPageSize := Value;
    if FPageSize > FMax - FMin then
      FPageSize := FMax - FMin;
    if FPageSize < 1 then
      FPageSize := 1;
  end;
end;

procedure TCustomOwnerDrawScrollbar.SetPosition(const Value: integer);
var
  R: TRect;
begin
  if (FPosition <> Value) then
  begin
    if (Value < Min) then
      FPosition := Min
    else
    if (Value > Max) then
      FPosition := Max
    else
      FPosition := Value;
    R := ScrollArea(saThumbClient);
    InvalidateRect(Handle, @R, True);
    Update;
  end;
end;

procedure TCustomOwnerDrawScrollbar.SetRange(AMin, AMax: integer);
begin
  Min := AMin;
  if AMax < Min then
    Max := Min
  else
    Max := AMax;
end;

procedure TCustomOwnerDrawScrollbar.SetState(const Value: TScrollStates);

    function BitChanged(Flag1, Flag2: TScrollStates; Bit: TScrollState): Boolean;
    begin
      Result := (Bit in Flag1) and (not (Bit in Flag2)) or (not (Bit in Flag1) and (Bit in Flag2))
    end;

const
  UIBits = [ssDownPressed, ssHotDown, ssHotThumb, ssScrollDown, ssUpPressed,
    ssDraggingThumb];
var
  OldState: TScrollStates;
  R: TRect;
  EraseBkGnd: Boolean;
begin
  if FState <> Value then
  begin
    OldState := FState;
    FState := Value;

    { By invalidating only what is necessary the DC obtained by BeginPaint will }
    { have only the invalided areas added to the clipping region helping to     }
    { reduce flickering.                                                        }
    SetRect(R, 0, 0, 0, 0);
    EraseBkGnd := False;
    if BitChanged(OldState, Value, ssDownPressed) or BitChanged(OldState, Value, ssHotDown) then
      R := ScrollArea(saScrollDown);
    if BitChanged(OldState, Value, ssUpPressed) or BitChanged(OldState, Value, ssHotUp) then
      R := ScrollArea(saScrollUp);
    if BitChanged(OldState, Value, ssHotThumb) or BitChanged(OldState, Value, ssDraggingThumb) then
      R := ScrollArea(saThumb);
    if BitChanged(OldState, Value, ssPageDownPressed) or BitChanged(OldState, Value, ssPageUpPressed) then
    begin
      R := ScrollArea(saThumbClient);
      EraseBkGnd := True;
    end;
    if not IsRectEmpty(R) then
    begin
      InvalidateRect(Handle, @R, EraseBkGnd);
      UpdateWindow(Handle);
    end
  end
end;

procedure TCustomOwnerDrawScrollbar.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  DoPaintScrollBkgnd(Message.DC)
end;

procedure TCustomOwnerDrawScrollbar.WMLButtonDblClk(
  var Message: TWMLButtonDblClk);
begin
  inherited;
  ScrollClick(SmallPointToPoint(Message.Pos));
  HandleAutoScrollTimer(True, True);
end;

procedure TCustomOwnerDrawScrollbar.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  Include(FState, ssMouseCaptured);
  ScrollClick(SmallPointToPoint(Message.Pos));
  HandleAutoScrollTimer(True, True);
end;

procedure TCustomOwnerDrawScrollbar.WMLButtonUp(var Message: TWMLButtonUp);
begin
  inherited;
  HandleAutoScrollTimer(False, False);
  if ssDraggingThumb in State then
    SendScrollMsg(SB_ENDSCROLL);
  State := State - [ssDownPressed, ssUpPressed, ssMouseCaptured, ssDraggingThumb, ssPageUpPressed, ssPageDownPressed];
end;

procedure TCustomOwnerDrawScrollbar.WMMouseActivate(var Message: TWMMouseActivate);
begin
  if csDesigning in ComponentState then
    inherited
  else
    Message.Result := MA_NOACTIVATE
end;

procedure TCustomOwnerDrawScrollbar.WMMouseMove(var Message: TWMMouseMove);
var
  Pos: integer;
begin
  inherited;

  if TimerHot = 0 then
    HandleHotTimer(True);

  HandleHotTracking(SmallPointToPoint(Message.Pos), False);

  // if MouseCaptured AND DraggingThumb then
  if State >= [ssMouseCaptured, ssDraggingThumb] then
  begin
    Pos := CalcuatePositionByPixel(Message.YPos);
    Position := Pos;
    SendScrollMsg(SB_THUMBTRACK, Pos)
  end
end;

procedure TCustomOwnerDrawScrollbar.WMPrintClient(var Message: TWMPrintClient);
begin
  DoPaintScrollBkgnd(Message.DC);
  DoPaintScrollButton(pcScrollUp, Message.DC);
  DoPaintScrollButton(pcScrollDown, Message.DC);
  DoPaintScrollButton(pcThumb, Message.DC);
end;

procedure TCustomOwnerDrawScrollbar.WMSysColorChange( var Message: TWMSysColorChange);
begin
  inherited;
  RebuildDefaultColors;
end;

procedure TCustomOwnerDrawScrollbar.WMThemeChanged(var Message: TMessage);
begin
  inherited;
  FreeThemes;
  if UseThemes then
  begin
    OpenThemes;
    Include(FState, ssThemesAvailable);
  end else
    Exclude(FState, ssThemesAvailable)
end;

procedure TCustomOwnerDrawScrollbar.WMTimer(var Message: TWMTimer);
var
  R: TRect;
begin
  case Message.TimerID of
    ID_TIMERHOT:
        begin
          R := ClientRect;
          R.TopLeft := ClientToScreen(R.TopLeft);
          R.BottomRight := ClientToScreen(R.BottomRight);
          if not PtInRect(R, Mouse.CursorPos) then
          // Elvis has left the building 
          begin
            HandleHotTracking(ScreenToClient(Mouse.CursorPos), True);
            HandleHotTimer(False);
          end else
            HandleHotTracking(ScreenToClient(Mouse.CursorPos), False);
        end;
    ID_TIMERAUTOSCROLLDELAY:
        begin
          HandleAutoScrollTimer(True, False);
        end;
    ID_TIMERAUTOSCROLL:
        begin
          if ssUpPressed in State then
          begin
            if not SendScrollMsg(SB_LINEUP) then
              Position := Position - SmallChange;
          end else
          if ssDownPressed in State then
          begin
            if not SendScrollMsg(SB_LINEDOWN) then
              Position := Position + SmallChange;
          end
          else begin
            if CanScrollPage then
            begin
              if ssPageDownPressed in State then
              begin
                if not SendScrollMsg(SB_PAGEDOWN) then
                  Position := Position + LargeChange;
              end else
              if ssPageUpPressed in State then
              begin
                if not SendScrollMsg(SB_PAGEUP) then
                  Position := Position - LargeChange;
              end
            end
          end
        end;
    end
end;

{ TScrollBarColors }

constructor TScrollBarColors.Create(AScrollbar: TCustomOwnerDrawScrollbar);
begin
  FScrollbar := AScrollbar;
  FBackGround := clScrollbar;
  FThumbButton := clScrollbar;
  FPageScrollHot := clBlack;
  FBackgroundBlend := clWhite;
end;

procedure TScrollBarColors.SetBackground(const Value: TColor);
begin
  if FBackGround <> Value then
  begin
    FBackGround := Value;
    Scrollbar.RebuildDefaultColors
  end
end;

procedure TScrollBarColors.SetBackgroundBlend(const Value: TColor);
begin
  if FBackgroundBlend <> Value then
  begin
    FBackgroundBlend := Value;
    Scrollbar.RebuildDefaultColors
  end
end;

procedure TScrollBarColors.SetThumbButton(const Value: TColor);
begin
  if FThumbButton <> Value then
  begin
    FThumbButton := Value;
    Scrollbar.RebuildDefaultColors
  end
end;

end.
