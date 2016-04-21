// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualScrollbars.pas' rev: 31.00 (Windows)

#ifndef VirtualscrollbarsHPP
#define VirtualscrollbarsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Themes.hpp>
#include <Winapi.UxTheme.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualscrollbars
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TScrollBarColors;
class DELPHICLASS TCustomOwnerDrawScrollbar;
class DELPHICLASS TOwnerDrawScrollbar;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TScrollDimensions : unsigned char { sbVArrowWidth, sbVArrowHeight, sbVThumbHeight, sbVThumbClientHeight };

enum DECLSPEC_DENUM TScrollArea : unsigned char { saBackground, saScrollUp, saScrollDown, saThumb, saThumbClient, saThumbPageDownClient, saThumbPageUpClient };

enum DECLSPEC_DENUM TScrollPaintCycle : unsigned char { pcBackground, pcScrollUp, pcScrollDown, pcThumb };

enum DECLSPEC_DENUM TScrollPaintState : unsigned char { psNormal, psHot, psPressed, psScrolling, psDisabled };

enum DECLSPEC_DENUM TScrollState : unsigned char { ssDraggingThumb, ssDownPressed, ssHotDown, ssHotThumb, ssHotUp, ssMouseCaptured, ssPageDownPressed, ssPageScrollPause, ssPageUpPressed, ssScrollDown, ssScrollUp, ssUpPressed, ssThemesAvailable };

typedef System::Set<TScrollState, TScrollState::ssDraggingThumb, TScrollState::ssThemesAvailable> TScrollStates;

enum DECLSPEC_DENUM TScrollOption : unsigned char { soThemeAware };

typedef System::Set<TScrollOption, TScrollOption::soThemeAware, TScrollOption::soThemeAware> TScrollOptions;

class PASCALIMPLEMENTATION TScrollBarColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Uitypes::TColor FThumbButton;
	System::Uitypes::TColor FBackGround;
	System::Uitypes::TColor FPageScrollHot;
	TCustomOwnerDrawScrollbar* FScrollbar;
	System::Uitypes::TColor FBackgroundBlend;
	void __fastcall SetBackground(const System::Uitypes::TColor Value);
	void __fastcall SetBackgroundBlend(const System::Uitypes::TColor Value);
	void __fastcall SetThumbButton(const System::Uitypes::TColor Value);
	
public:
	__fastcall TScrollBarColors(TCustomOwnerDrawScrollbar* AScrollbar);
	__property TCustomOwnerDrawScrollbar* Scrollbar = {read=FScrollbar};
	
__published:
	__property System::Uitypes::TColor PageScrollHot = {read=FPageScrollHot, write=FPageScrollHot, default=0};
	__property System::Uitypes::TColor Background = {read=FBackGround, write=SetBackground, default=-16777216};
	__property System::Uitypes::TColor BackgroundBlend = {read=FBackgroundBlend, write=SetBackgroundBlend, default=16777215};
	__property System::Uitypes::TColor ThumbButton = {read=FThumbButton, write=SetThumbButton, default=-16777216};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TScrollBarColors(void) { }
	
};


typedef void __fastcall (__closure *TOnScrollCustomPaint)(TCustomOwnerDrawScrollbar* Sender, TScrollPaintCycle PaintCycle, TScrollPaintState ScrollPaintState, const System::Types::TRect &PaintRect, Vcl::Graphics::TCanvas* Canvas, bool &Handled);

class PASCALIMPLEMENTATION TCustomOwnerDrawScrollbar : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
private:
	TOnScrollCustomPaint FOnScrollCustomPaint;
	Vcl::Graphics::TBrush* FBkGndBrush;
	TScrollStates FState;
	bool FFlat;
	int FMin;
	int FMax;
	int FPosition;
	int FPageSize;
	NativeUInt FTimerHot;
	NativeUInt FTimerAutoScroll;
	NativeUInt FTimerAutoScrollDelay;
	int FAutoScrollTime;
	TScrollBarColors* FColors;
	TScrollOptions FOptions;
	NativeUInt FThemeScrollbar;
	Vcl::Controls::TWinControl* FOwnerControl;
	int FLargeChange;
	int FSmallChange;
	void __fastcall SetPosition(const int Value);
	void __fastcall SetState(const TScrollStates Value);
	void __fastcall SetFlat(const bool Value);
	bool __fastcall GetThemed(void);
	void __fastcall SetPageSize(const int Value);
	void __fastcall SetMax(const int Value);
	void __fastcall SetMin(const int Value);
	int __fastcall GetMax(void);
	
protected:
	int __fastcall CalcuatePositionByPixel(int APixel);
	int __fastcall CalculateThumbCenterPixel(void);
	bool __fastcall CanScrollPage(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	void __fastcall DoPaintScrollBkgnd(HDC DC);
	void __fastcall DoPaintScrollButton(TScrollPaintCycle Cycle, HDC DC);
	void __fastcall FreeThemes(void);
	void __fastcall HandleAutoScrollTimer(bool Enable, bool DelayTimer);
	void __fastcall HandleHotTimer(bool Enable);
	void __fastcall HandleHotTracking(System::Types::TPoint MousePos, bool ForceClearAll);
	void __fastcall OpenThemes(void);
	int __fastcall Metric(TScrollDimensions Dimension);
	virtual void __fastcall Paint(void);
	void __fastcall RebuildDefaultColors(void);
	bool __fastcall SendScrollMsg(unsigned ScrollCode, int NewPos = 0x0);
	System::Types::TRect __fastcall ScrollArea(TScrollArea Area);
	void __fastcall ScrollClick(System::Types::TPoint Pos);
	HIDESBASE MESSAGE void __fastcall WMEraseBkGnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMPrintClient(Winapi::Messages::TWMPrint &Message);
	HIDESBASE MESSAGE void __fastcall WMSysColorChange(Winapi::Messages::TWMNoParams &Message);
	MESSAGE void __fastcall WMThemeChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMTimer(Winapi::Messages::TWMTimer &Message);
	__property int AutoScrollTime = {read=FAutoScrollTime, write=FAutoScrollTime, default=100};
	__property Vcl::Graphics::TBrush* BkGndBrush = {read=FBkGndBrush, write=FBkGndBrush};
	__property TScrollBarColors* Colors = {read=FColors, write=FColors};
	__property bool Flat = {read=FFlat, write=SetFlat, default=0};
	__property int LargeChange = {read=FLargeChange, write=FLargeChange, default=1};
	__property int Max = {read=GetMax, write=SetMax, default=100};
	__property int Min = {read=FMin, write=SetMin, default=0};
	__property TOnScrollCustomPaint OnScrollCustomPaint = {read=FOnScrollCustomPaint, write=FOnScrollCustomPaint};
	__property TScrollOptions Options = {read=FOptions, write=FOptions, default=1};
	__property int PageSize = {read=FPageSize, write=SetPageSize, default=1};
	__property int Position = {read=FPosition, write=SetPosition, default=0};
	__property int SmallChange = {read=FSmallChange, write=FSmallChange, default=1};
	__property bool Themed = {read=GetThemed, nodefault};
	__property NativeUInt ThemeScrollbar = {read=FThemeScrollbar, write=FThemeScrollbar};
	__property NativeUInt TimerAutoScroll = {read=FTimerAutoScroll, write=FTimerAutoScroll};
	__property NativeUInt TimerAutoScrollDelay = {read=FTimerAutoScrollDelay, write=FTimerAutoScrollDelay};
	__property NativeUInt TimerHot = {read=FTimerHot, write=FTimerHot};
	
public:
	__fastcall virtual TCustomOwnerDrawScrollbar(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCustomOwnerDrawScrollbar(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	void __fastcall SetRange(int AMin, int AMax);
	__property Vcl::Controls::TWinControl* OwnerControl = {read=FOwnerControl, write=FOwnerControl};
	__property TScrollStates State = {read=FState, write=SetState, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TCustomOwnerDrawScrollbar(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOwnerDrawScrollbar : public TCustomOwnerDrawScrollbar
{
	typedef TCustomOwnerDrawScrollbar inherited;
	
__published:
	__property Colors;
	__property Flat = {default=0};
	__property LargeChange = {default=1};
	__property Max = {default=100};
	__property Min = {default=0};
	__property OnScrollCustomPaint;
	__property Options = {default=1};
	__property PageSize = {default=1};
	__property Position = {default=0};
	__property SmallChange = {default=1};
public:
	/* TCustomOwnerDrawScrollbar.Create */ inline __fastcall virtual TOwnerDrawScrollbar(System::Classes::TComponent* AOwner) : TCustomOwnerDrawScrollbar(AOwner) { }
	/* TCustomOwnerDrawScrollbar.Destroy */ inline __fastcall virtual ~TOwnerDrawScrollbar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOwnerDrawScrollbar(HWND ParentWindow) : TCustomOwnerDrawScrollbar(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Byte ID_TIMERHOT = System::Byte(0xc9);
static const System::Byte ID_TIMERAUTOSCROLL = System::Byte(0xca);
static const System::Byte ID_TIMERAUTOSCROLLDELAY = System::Byte(0xcb);
static const System::Word TIME_AUTOSCROLLDELAY = System::Word(0x1f4);
static const System::Int8 TIMER_HOT = System::Int8(0x32);
}	/* namespace Virtualscrollbars */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALSCROLLBARS)
using namespace Virtualscrollbars;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualscrollbarsHPP
