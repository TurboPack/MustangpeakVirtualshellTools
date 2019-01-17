// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualShellToolBar.pas' rev: 32.00 (Windows)

#ifndef VirtualshelltoolbarHPP
#define VirtualshelltoolbarHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Buttons.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Winapi.ShlObj.hpp>
#include <Winapi.ActiveX.hpp>
#include <Vcl.ImgList.hpp>
#include <VirtualExplorerTree.hpp>
#include <Vcl.ToolWin.hpp>
#include <MPDataObject.hpp>
#include <MPShellTypes.hpp>
#include <MPShellUtilities.hpp>
#include <VirtualResources.hpp>
#include <MPCommonObjects.hpp>
#include <MPCommonUtilities.hpp>
#include <MPThreadManager.hpp>
#include <Vcl.Themes.hpp>
#include <Winapi.UxTheme.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualshelltoolbar
{
//-- forward type declarations -----------------------------------------------
struct TClipRec;
class DELPHICLASS TVirtualButtonList;
class DELPHICLASS TVirtualShellButtonList;
class DELPHICLASS TCustomWideSpeedButton;
class DELPHICLASS TWideSpeedButton;
class DELPHICLASS TCaptionButton;
class DELPHICLASS TShellToolButton;
class DELPHICLASS TCustomVirtualToolbar;
class DELPHICLASS TVirtualToolbar;
class DELPHICLASS TCustomVirtualShellToolbar;
class DELPHICLASS TVirtualShellToolbar;
class DELPHICLASS TCustomVirtualDriveToolbar;
class DELPHICLASS TVirtualDriveToolbar;
class DELPHICLASS TCustomVirtualSpecialFolderToolbar;
class DELPHICLASS TVirtualSpecialFolderToolbar;
class DELPHICLASS TVSTShellToolbar;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TCaptionOption : unsigned char { coFolderName, coFolderPath, coNoExtension, coDriveLetterOnly };

typedef System::Set<TCaptionOption, TCaptionOption::coFolderName, TCaptionOption::coDriveLetterOnly> TCaptionOptions;

enum DECLSPEC_DENUM TButtonPaintState : unsigned char { psNormal, psHot, psPressed, psDropTarget };

enum DECLSPEC_DENUM TButtonState : unsigned char { bsMouseInButton, bsThemesActive, bsRMouseButtonDown };

typedef System::Set<TButtonState, TButtonState::bsMouseInButton, TButtonState::bsRMouseButtonDown> TButtonStates;

enum DECLSPEC_DENUM TShellToolbarContent : unsigned char { stcFolders, stcFiles, stcPrograms };

typedef System::Set<TShellToolbarContent, TShellToolbarContent::stcFolders, TShellToolbarContent::stcPrograms> TShellToolbarContents;

enum DECLSPEC_DENUM TVirtualToolbarOption : unsigned char { toAnimateHot, toContextMenu, toCustomizable, toEqualWidth, toFlat, toInsertDropable, toLaunchDropable, toShellNotifyThread, toThemeAware, toThreadedImages, toTile, toTransparent, toUserDefinedClickAction, toLargeButtons };

typedef System::Set<TVirtualToolbarOption, TVirtualToolbarOption::toAnimateHot, TVirtualToolbarOption::toLargeButtons> TVirtualToolbarOptions;

enum DECLSPEC_DENUM TVirtualToolbarState : unsigned char { tsBackBitsStale, tsThemesActive, tsShellIDListValid, tsVSTShellToobarValid, tsDragInLaunchZone, tsDragInDropZone, tsInsertImageVisible };

typedef System::Set<TVirtualToolbarState, TVirtualToolbarState::tsBackBitsStale, TVirtualToolbarState::tsInsertImageVisible> TVirtualToolbarStates;

enum DECLSPEC_DENUM TDriveSpecialFolder : unsigned char { dsfDesktop, dsfMyComputer, dsfNetworkNeighborhood, dsfRemovable, dsfReadOnly, dsfFixedDrive };

typedef System::Set<TDriveSpecialFolder, TDriveSpecialFolder::dsfDesktop, TDriveSpecialFolder::dsfFixedDrive> TDriveSpecialFolders;

enum DECLSPEC_DENUM TSpecialFolder : unsigned char { sfAdminTools, sfAltStartup, sfAppData, sfBitBucket, sfControlPanel, sfCookies, sfDesktop, sfDesktopDirectory, sfDrives, sfFavorites, sfFonts, sfHistory, sfInternet, sfInternetCache, sfLocalAppData, sfMyPictures, sfNetHood, sfNetwork, sfPersonal, sfPrinters, sfPrintHood, sfProfile, sfProgramFiles, sfCommonProgramFiles, sfPrograms, sfRecent, sfSendTo, sfStartMenu, sfStartUp, sfSystem, sfTemplate, sfWindows };

typedef System::Set<TSpecialFolder, TSpecialFolder::sfAdminTools, TSpecialFolder::sfWindows> TSpecialFolders;

enum DECLSPEC_DENUM TSpecialCommonFolder : unsigned char { sfCommonAdminTools, sfCommonAltStartup, sfCommonAppData, sfCommonDesktopDirectory, sfCommonDocuments, sfCommonFavorties, sfCommonPrograms, sfCommonStartMenu, sfCommonStartup, sfCommonTemplates };

typedef System::Set<TSpecialCommonFolder, TSpecialCommonFolder::sfCommonAdminTools, TSpecialCommonFolder::sfCommonTemplates> TSpecialCommonFolders;

typedef TClipRec *PClipRec;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TClipRec
{
public:
	void *ButtonInstance;
	unsigned Process;
	int PIDLSize;
	System::StaticArray<System::Byte, 1> PIDL;
};
#pragma pack(pop)


class PASCALIMPLEMENTATION TVirtualButtonList : public System::Classes::TList
{
	typedef System::Classes::TList inherited;
	
public:
	TCustomWideSpeedButton* operator[](int Index) { return this->Items[Index]; }
	
private:
	TCustomVirtualToolbar* FToolbar;
	int FUpdateCount;
	TCustomWideSpeedButton* __fastcall GetItems(int Index);
	void __fastcall SetItems(int Index, TCustomWideSpeedButton* const Value);
	
protected:
	virtual TCustomWideSpeedButton* __fastcall CreateToolButton(void);
	
public:
	virtual TCustomWideSpeedButton* __fastcall AddButton(int Index = 0xffffffff);
	void __fastcall RemoveButton(TCustomWideSpeedButton* Button);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	virtual void __fastcall Clear(void);
	__property TCustomWideSpeedButton* Items[int Index] = {read=GetItems, write=SetItems/*, default*/};
	__property TCustomVirtualToolbar* Toolbar = {read=FToolbar, write=FToolbar};
public:
	/* TList.Destroy */ inline __fastcall virtual ~TVirtualButtonList(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TVirtualButtonList(void) : System::Classes::TList() { }
	
};


class PASCALIMPLEMENTATION TVirtualShellButtonList : public TVirtualButtonList
{
	typedef TVirtualButtonList inherited;
	
public:
	TShellToolButton* operator[](int Index) { return this->Items[Index]; }
	
private:
	HIDESBASE TShellToolButton* __fastcall GetItems(int Index);
	HIDESBASE void __fastcall SetItems(int Index, TShellToolButton* const Value);
	
protected:
	virtual TCustomWideSpeedButton* __fastcall CreateToolButton(void);
	
public:
	virtual TCustomWideSpeedButton* __fastcall AddButton(int Index = 0xffffffff);
	__property TShellToolButton* Items[int Index] = {read=GetItems, write=SetItems/*, default*/};
public:
	/* TList.Destroy */ inline __fastcall virtual ~TVirtualShellButtonList(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TVirtualShellButtonList(void) : TVirtualButtonList() { }
	
};


class PASCALIMPLEMENTATION TCustomWideSpeedButton : public Vcl::Controls::TGraphicControl
{
	typedef Vcl::Controls::TGraphicControl inherited;
	
private:
	System::WideString FCaption;
	int FImageIndex;
	TButtonPaintState FPaintState;
	int FSpacing;
	int FMargin;
	Vcl::Buttons::TButtonLayout FLayout;
	Vcl::Imglist::TCustomImageList* FImageList;
	System::Classes::TNotifyEvent FOldOnFontChange;
	bool FFlat;
	bool FThemeAware;
	bool FTransparent;
	System::Classes::TNotifyEvent FOnDblClk;
	System::Classes::TNotifyEvent FOnMouseLeave;
	System::Classes::TNotifyEvent FOnMouseEnter;
	NativeUInt FThemeToolbar;
	NativeUInt FTimer;
	Mpcommonutilities::_di_ICallbackStub FTimerStub;
	TButtonStates FState;
	bool FDragging;
	Vcl::Imglist::TChangeLink* FImageListChangeLink;
	bool FHotAnimate;
	bool FOLEDraggable;
	int __fastcall GetBottom(void);
	virtual System::WideString __fastcall GetCaption(void);
	virtual int __fastcall GetImageIndex(void);
	Vcl::Imglist::TCustomImageList* __fastcall GetImageList(void);
	int __fastcall GetRight(void);
	NativeUInt __fastcall GetThemeToolbar(void);
	void __fastcall ReadCaption(System::Classes::TReader* Reader);
	void __fastcall SetCaption(const System::WideString Value);
	void __fastcall SetFlat(const bool Value);
	void __fastcall SetImageIndex(const int Value);
	void __fastcall SetImageList(Vcl::Imglist::TCustomImageList* const Value);
	void __fastcall SetLayout(const Vcl::Buttons::TButtonLayout Value);
	void __fastcall SetMargin(const int Value);
	void __fastcall SetPaintState(const TButtonPaintState Value);
	void __fastcall SetSpacing(const int Value);
	void __fastcall SetTransparent(const bool Value);
	void __fastcall SetThemeAware(const bool Value);
	void __fastcall WriteCaption(System::Classes::TWriter* Writer);
	
protected:
	DYNAMIC void __fastcall ActionChange(System::TObject* Sender, bool CheckDefaults);
	void __fastcall CalcButtonLayout(HDC DC, const System::Types::TRect &Client, const System::Types::TPoint AnOffset, const System::WideString Caption, Vcl::Buttons::TButtonLayout Layout, int Margin, int Spacing, System::Types::TPoint &GlyphPos, System::Types::TRect &TextBounds, int BiDiFlags);
	virtual bool __fastcall CanAutoSize(int &NewWidth, int &NewHeight);
	virtual void __fastcall DoDblClk(void);
	virtual void __fastcall DoMouseLeave(void);
	virtual void __fastcall DoMouseEnter(void);
	virtual HRESULT __fastcall DragEnter(const _di_IDataObject dataObj, int grfKeyState, System::Types::TPoint pt, int &dwEffect);
	virtual HRESULT __fastcall DragOverOLE(int grfKeyState, System::Types::TPoint pt, int &dwEffect);
	virtual HRESULT __fastcall DragLeave(void);
	void __fastcall DrawButtonText(HDC DC, const System::WideString Caption, const System::Types::TRect &TextBounds, bool Enabled, int BiDiFlags);
	virtual HRESULT __fastcall Drop(const _di_IDataObject dataObj, int grfKeyState, System::Types::TPoint pt, int &dwEffect);
	void __fastcall FontChange(System::TObject* Sender);
	DYNAMIC void __fastcall FreeThemes(void);
	virtual HRESULT __stdcall GiveFeedback(int dwEffect);
	void __fastcall ImageListChange(System::TObject* Sender);
	virtual bool __fastcall LoadFromDataObject(const Mpdataobject::_di_ICommonDataObject DataObject);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Paint(void);
	virtual void __fastcall PaintButton(HDC DC, bool ForDragImage = false);
	virtual HRESULT __stdcall QueryContinueDrag(System::LongBool fEscapePressed, int grfKeyState);
	virtual bool __fastcall SaveToDataObject(const Mpdataobject::_di_ICommonDataObject DataObject);
	void __fastcall SetBoundsR(const System::Types::TRect &Rect);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	void __fastcall StartHotTimer(void);
	void __stdcall TimerStubProc(HWND Wnd, unsigned uMsg, unsigned idEvent, unsigned dwTime);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMRButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMRButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Message);
	MESSAGE void __fastcall WMThemeChanged(Winapi::Messages::TMessage &Message);
	__property System::WideString Caption = {read=GetCaption, write=SetCaption, stored=false};
	__property bool Flat = {read=FFlat, write=SetFlat, default=0};
	__property bool HotAnimate = {read=FHotAnimate, write=FHotAnimate, default=0};
	__property int ImageIndex = {read=GetImageIndex, write=SetImageIndex, default=-1};
	__property Vcl::Imglist::TCustomImageList* ImageList = {read=GetImageList, write=SetImageList};
	__property Vcl::Imglist::TChangeLink* ImageListChangeLink = {read=FImageListChangeLink, write=FImageListChangeLink};
	__property Vcl::Buttons::TButtonLayout Layout = {read=FLayout, write=SetLayout, default=0};
	__property int Margin = {read=FMargin, write=SetMargin, default=-1};
	__property bool OLEDraggable = {read=FOLEDraggable, write=FOLEDraggable, default=0};
	__property System::Classes::TNotifyEvent OnDblClk = {read=FOnDblClk, write=FOnDblClk};
	__property System::Classes::TNotifyEvent OnMouseEnter = {read=FOnMouseEnter, write=FOnMouseEnter};
	__property System::Classes::TNotifyEvent OnMouseLeave = {read=FOnMouseLeave, write=FOnMouseLeave};
	__property TButtonPaintState PaintState = {read=FPaintState, write=SetPaintState, nodefault};
	__property int Spacing = {read=FSpacing, write=SetSpacing, default=4};
	__property TButtonStates State = {read=FState, write=FState, nodefault};
	__property bool ThemeAware = {read=FThemeAware, write=SetThemeAware, default=1};
	__property NativeUInt ThemeToolbar = {read=GetThemeToolbar};
	__property NativeUInt Timer = {read=FTimer};
	__property Mpcommonutilities::_di_ICallbackStub TimerStub = {read=FTimerStub};
	__property bool Transparent = {read=FTransparent, write=SetTransparent, default=0};
	
public:
	__fastcall virtual TCustomWideSpeedButton(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCustomWideSpeedButton(void);
	virtual void __fastcall AddToUpdateRgn(void);
	DYNAMIC void __fastcall Click(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	HIDESBASE bool __fastcall Dragging(void);
	virtual System::Types::TRect __fastcall CalcMaxExtentRect(Vcl::Graphics::TFont* Font);
	virtual System::Types::TSize __fastcall CalcMaxExtentSize(Vcl::Graphics::TFont* Font);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S);
	void __fastcall RebuildButton(void);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S);
	__property int Bottom = {read=GetBottom, nodefault};
	__property int Right = {read=GetRight, nodefault};
private:
	void *__IDropSource;	// IDropSource 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {00000121-0000-0000-C000-000000000046}
	operator _di_IDropSource()
	{
		_di_IDropSource intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator IDropSource*(void) { return (IDropSource*)&__IDropSource; }
	#endif
	
};


class PASCALIMPLEMENTATION TWideSpeedButton : public TCustomWideSpeedButton
{
	typedef TCustomWideSpeedButton inherited;
	
__published:
	__property Action;
	__property AutoSize = {default=0};
	__property Caption;
	__property Color = {default=-16777211};
	__property Constraints;
	__property Enabled = {default=1};
	__property Flat = {default=0};
	__property Font;
	__property ImageIndex = {default=-1};
	__property ImageList;
	__property HotAnimate = {default=0};
	__property Layout = {default=0};
	__property Margin = {default=-1};
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property Spacing = {default=4};
	__property Tag = {default=0};
	__property ThemeAware = {default=1};
	__property Transparent = {default=0};
	__property Visible = {default=1};
	__property Width;
	__property OnClick;
	__property OnDblClk;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseLeave;
	__property OnMouseEnter;
public:
	/* TCustomWideSpeedButton.Create */ inline __fastcall virtual TWideSpeedButton(System::Classes::TComponent* AOwner) : TCustomWideSpeedButton(AOwner) { }
	/* TCustomWideSpeedButton.Destroy */ inline __fastcall virtual ~TWideSpeedButton(void) { }
	
};


class PASCALIMPLEMENTATION TCaptionButton : public TCustomWideSpeedButton
{
	typedef TCustomWideSpeedButton inherited;
	
protected:
	virtual bool __fastcall CanResize(int &NewWidth, int &NewHeight);
	virtual void __fastcall PaintButton(HDC DC, bool ForDragImage = false);
	virtual bool __fastcall CanAutoSize(int &NewWidth, int &NewHeight);
	
public:
	__fastcall virtual TCaptionButton(System::Classes::TComponent* AOwner);
	virtual System::Types::TRect __fastcall CalcMaxExtentRect(Vcl::Graphics::TFont* Font);
public:
	/* TCustomWideSpeedButton.Destroy */ inline __fastcall virtual ~TCaptionButton(void) { }
	
};


class PASCALIMPLEMENTATION TShellToolButton : public TCustomWideSpeedButton
{
	typedef TCustomWideSpeedButton inherited;
	
private:
	Mpshellutilities::TNamespace* FNamespace;
	TCaptionOptions FCaptionOptions;
	virtual System::WideString __fastcall GetCaption(void);
	virtual int __fastcall GetImageIndex(void);
	void __fastcall SetCaptionOptions(const TCaptionOptions Value);
	
protected:
	virtual HRESULT __fastcall DragEnter(const _di_IDataObject dataObj, int grfKeyState, System::Types::TPoint pt, int &dwEffect);
	virtual HRESULT __fastcall DragOverOLE(int grfKeyState, System::Types::TPoint pt, int &dwEffect);
	virtual HRESULT __fastcall DragLeave(void);
	virtual HRESULT __fastcall Drop(const _di_IDataObject dataObj, int grfKeyState, System::Types::TPoint pt, int &dwEffect);
	virtual bool __fastcall SaveToDataObject(const Mpdataobject::_di_ICommonDataObject DataObject);
	HIDESBASE MESSAGE void __fastcall WMContextMenu(Winapi::Messages::TWMContextMenu &Message);
	
public:
	__fastcall virtual TShellToolButton(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TShellToolButton(void);
	DYNAMIC void __fastcall Click(void);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S);
	__property Action;
	__property AutoSize = {default=0};
	__property System::WideString Caption = {read=GetCaption};
	__property TCaptionOptions CaptionOptions = {read=FCaptionOptions, write=SetCaptionOptions, default=0};
	__property Color = {default=-16777211};
	__property Constraints;
	__property Enabled = {default=1};
	__property Flat = {default=0};
	__property Font;
	__property int ImageIndex = {read=GetImageIndex, default=-1};
	__property HotAnimate = {default=0};
	__property Layout = {default=0};
	__property Margin = {default=2};
	__property Mpshellutilities::TNamespace* Namespace = {read=FNamespace, write=FNamespace};
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property Spacing = {default=4};
	__property Tag = {default=0};
	__property ThemeAware = {default=1};
	__property Transparent = {default=0};
	__property Visible = {default=1};
	__property Width;
	__property OnClick;
	__property OnDblClk;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseLeave;
	__property OnMouseEnter;
};


class PASCALIMPLEMENTATION TCustomVirtualToolbar : public Vcl::Toolwin::TToolWindow
{
	typedef Vcl::Toolwin::TToolWindow inherited;
	
private:
	Vcl::Graphics::TBitmap* FBackBits;
	TVirtualButtonList* FButtonList;
	TCaptionButton* FCaptionButton;
	NativeUInt FHotTrackTimer;
	int FLockUpdateCount;
	System::Classes::TNotifyEvent FOldFontChangeEvent;
	TVirtualToolbarOptions FOptions;
	int FScrollBtnSize;
	TVirtualToolbarStates FStates;
	NativeUInt FThemeToolbar;
	int FButtonSpacing;
	int FButtonMargin;
	Vcl::Buttons::TButtonLayout FButtonLayout;
	Mpshelltypes::_di_IDropTargetHelper FDropTargetHelper;
	TCustomWideSpeedButton* FDropTarget;
	_di_IDataObject FDragDropDataObj;
	System::Types::TRect FDropMarkRect;
	TShellToolbarContents FContent;
	int FDropInsertMargin;
	bool FThreadedImagesEnabled;
	bool FChangeNotifierEnabled;
	_di_IMalloc FMalloc;
	System::Classes::TNotifyEvent FOnRecreateButtons;
	System::Classes::TNotifyEvent FOnCreateButtons;
	Vcl::Controls::TAlign __fastcall GetAlign(void);
	Vcl::Controls::TWinControl* __fastcall GetBkGndParent(void);
	Vcl::Toolwin::TEdgeBorders __fastcall GetEdgeBorders(void);
	Vcl::Toolwin::TEdgeStyle __fastcall GetEdgeInner(void);
	Vcl::Toolwin::TEdgeStyle __fastcall GetEdgeOuter(void);
	System::WideString __fastcall GetWideCaption(void);
	void __fastcall ReadCaption(System::Classes::TReader* Reader);
	HIDESBASE void __fastcall SetAlign(const Vcl::Controls::TAlign Value);
	void __fastcall SetBkGndParent(Vcl::Controls::TWinControl* const Value);
	HIDESBASE void __fastcall SetEdgeBorders(const Vcl::Toolwin::TEdgeBorders Value);
	HIDESBASE void __fastcall SetEdgeOuter(const Vcl::Toolwin::TEdgeStyle Value);
	HIDESBASE void __fastcall SetEdgeInner(const Vcl::Toolwin::TEdgeStyle Value);
	void __fastcall SetOptions(const TVirtualToolbarOptions Value);
	void __fastcall SetWideCaption(const System::WideString Value);
	void __fastcall WriteCaption(System::Classes::TWriter* Writer);
	System::Types::TRect __fastcall GetViewportBounds(void);
	void __fastcall SetButtonLayout(const Vcl::Buttons::TButtonLayout Value);
	void __fastcall SetButtonSpacing(const int Value);
	void __fastcall SetButtonMargin(const int Value);
	void __fastcall SetThreadedImagesEnabled(const bool Value);
	void __fastcall SetChangeNotiferEnabled(const bool Value);
	
protected:
	Virtualexplorertree::TCustomVirtualExplorerTree* FVirtualExplorerTree;
	void __fastcall ArrangeButtons(void);
	System::Types::TSize __fastcall CalcMaxButtonSize(Vcl::Graphics::TFont* Font);
	virtual bool __fastcall CanAutoSize(int &NewWidth, int &NewHeight);
	System::Types::TRect __fastcall ClosestButtonEdge(System::Types::TPoint ScreenPoint);
	virtual void __fastcall CreateButtons(void);
	virtual TVirtualButtonList* __fastcall CreateButtonList(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall DestroyWnd(void);
	virtual void __fastcall DoCreateButtons(void);
	virtual void __fastcall DoRecreateButtons(void);
	virtual HRESULT __stdcall DragEnter(const _di_IDataObject dataObj, int grfKeyState, System::Types::TPoint pt, int &dwEffect);
	virtual HRESULT __stdcall DragOverOLE(int grfKeyState, System::Types::TPoint pt, int &dwEffect);
	virtual HRESULT __stdcall DragLeave(void);
	void __fastcall DrawDropMarker(System::Types::PPoint MousePos, bool ForceDraw);
	virtual HRESULT __stdcall Drop(const _di_IDataObject dataObj, int grfKeyState, System::Types::TPoint pt, int &dwEffect);
	void __fastcall FontChangeNotify(System::TObject* Sender);
	void __fastcall FreeThemes(void);
	virtual HRESULT __stdcall GiveFeedback(int dwEffect);
	bool __fastcall IsValidIDListData(_di_IDataObject DataObject);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall PaintToolbar(HDC DC);
	virtual void __fastcall PaintWindow(HDC DC);
	TCustomWideSpeedButton* __fastcall PointToButton(System::Types::TPoint ScreenPt);
	int __fastcall PointToInsertIndex(System::Types::TPoint ScreenPt);
	virtual HRESULT __stdcall QueryContinueDrag(System::LongBool fEscapePressed, int grfKeyState);
	void __fastcall ReCreateButtons(void);
	void __fastcall ResizeCaptionButton(void);
	virtual void __fastcall SetName(const System::Classes::TComponentName Value);
	void __fastcall StoreBackGndBitmap(void);
	void __fastcall UpdateDropStates(System::Types::TPoint ScreenMousePos);
	HIDESBASE MESSAGE void __fastcall CMColorChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkGnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMNCDestroy(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	MESSAGE void __fastcall WMPrint(Winapi::Messages::TWMPrint &Message);
	HIDESBASE MESSAGE void __fastcall WMPrintClient(Winapi::Messages::TWMPrint &Message);
	MESSAGE void __fastcall WMRemoveButton(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	MESSAGE void __fastcall WMThemeChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMTimer(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMWindowPosChanging(Winapi::Messages::TWMWindowPosMsg &Message);
	__property Vcl::Controls::TAlign Align = {read=GetAlign, write=SetAlign, default=1};
	__property Vcl::Graphics::TBitmap* BackBits = {read=FBackBits, write=FBackBits};
	__property Vcl::Controls::TWinControl* BkGndParent = {read=GetBkGndParent, write=SetBkGndParent};
	__property Vcl::Buttons::TButtonLayout ButtonLayout = {read=FButtonLayout, write=SetButtonLayout, default=0};
	__property int ButtonMargin = {read=FButtonMargin, write=SetButtonMargin, default=-1};
	__property int ButtonSpacing = {read=FButtonSpacing, write=SetButtonSpacing, default=4};
	__property System::WideString Caption = {read=GetWideCaption, write=SetWideCaption, stored=false};
	__property TCaptionButton* CaptionButton = {read=FCaptionButton, write=FCaptionButton};
	__property bool ChangeNotifierEnabled = {read=FChangeNotifierEnabled, write=SetChangeNotiferEnabled, nodefault};
	__property TShellToolbarContents Content = {read=FContent, write=FContent, default=7};
	__property _di_IDataObject DragDropDataObj = {read=FDragDropDataObj};
	__property int DropInsertMargin = {read=FDropInsertMargin, write=FDropInsertMargin, default=4};
	__property System::Types::TRect DropMarkRect = {read=FDropMarkRect};
	__property TCustomWideSpeedButton* DropTarget = {read=FDropTarget};
	__property Mpshelltypes::_di_IDropTargetHelper DropTargetHelper = {read=FDropTargetHelper};
	__property Vcl::Toolwin::TEdgeBorders EdgeBorders = {read=GetEdgeBorders, write=SetEdgeBorders, default=2};
	__property Vcl::Toolwin::TEdgeStyle EdgeInner = {read=GetEdgeInner, write=SetEdgeInner, default=1};
	__property Vcl::Toolwin::TEdgeStyle EdgeOuter = {read=GetEdgeOuter, write=SetEdgeOuter, default=2};
	__property NativeUInt HotTrackTimer = {read=FHotTrackTimer, write=FHotTrackTimer};
	__property _di_IMalloc Malloc = {read=FMalloc};
	__property System::Classes::TNotifyEvent OnCreateButtons = {read=FOnCreateButtons, write=FOnCreateButtons};
	__property System::Classes::TNotifyEvent OnRecreateButtons = {read=FOnRecreateButtons, write=FOnRecreateButtons};
	__property TVirtualToolbarOptions Options = {read=FOptions, write=SetOptions, default=256};
	__property TVirtualToolbarStates States = {read=FStates, nodefault};
	__property NativeUInt ThemeToolbar = {read=FThemeToolbar, write=FThemeToolbar, default=0};
	__property bool ThreadedImagesEnabled = {read=FThreadedImagesEnabled, write=SetThreadedImagesEnabled, nodefault};
	__property System::Types::TRect ViewportBounds = {read=GetViewportBounds};
	
public:
	__fastcall virtual TCustomVirtualToolbar(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCustomVirtualToolbar(void);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	virtual void __fastcall LoadFromFile(System::WideString FileName);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* S);
	virtual void __fastcall Loaded(void);
	void __fastcall RebuildToolbar(void);
	void __fastcall RecreateToolbar(void);
	virtual void __fastcall SaveToFile(System::WideString FileName);
	virtual void __fastcall SaveToStream(System::Classes::TStream* S);
	__property TVirtualButtonList* ButtonList = {read=FButtonList};
public:
	/* TWinControl.CreateParented */ inline __fastcall TCustomVirtualToolbar(HWND ParentWindow) : Vcl::Toolwin::TToolWindow(ParentWindow) { }
	
private:
	void *__IDropSource;	// IDropSource 
	void *__IDropTarget;	// IDropTarget 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {00000121-0000-0000-C000-000000000046}
	operator _di_IDropSource()
	{
		_di_IDropSource intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator IDropSource*(void) { return (IDropSource*)&__IDropSource; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {00000122-0000-0000-C000-000000000046}
	operator _di_IDropTarget()
	{
		_di_IDropTarget intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator IDropTarget*(void) { return (IDropTarget*)&__IDropTarget; }
	#endif
	
};


class PASCALIMPLEMENTATION TVirtualToolbar : public TCustomVirtualToolbar
{
	typedef TCustomVirtualToolbar inherited;
	
__published:
	__property Align = {default=1};
	__property Anchors = {default=3};
	__property AutoSize = {default=0};
	__property BiDiMode;
	__property BkGndParent;
	__property ButtonLayout = {default=0};
	__property ButtonMargin = {default=-1};
	__property ButtonSpacing = {default=4};
	__property Caption;
	__property Color = {default=-16777211};
	__property Constraints;
	__property Content = {default=7};
	__property DropInsertMargin = {default=4};
	__property EdgeBorders = {default=2};
	__property EdgeInner = {default=1};
	__property EdgeOuter = {default=2};
	__property Font;
	__property Options = {default=256};
	__property OnClick;
	__property OnCreateButtons;
	__property OnRecreateButtons;
public:
	/* TCustomVirtualToolbar.Create */ inline __fastcall virtual TVirtualToolbar(System::Classes::TComponent* AOwner) : TCustomVirtualToolbar(AOwner) { }
	/* TCustomVirtualToolbar.Destroy */ inline __fastcall virtual ~TVirtualToolbar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualToolbar(HWND ParentWindow) : TCustomVirtualToolbar(ParentWindow) { }
	
};


typedef void __fastcall (__closure *TVSTOnAddButtonEvent)(TCustomVirtualToolbar* Sender, Mpshellutilities::TNamespace* Namespace, bool &Allow);

class PASCALIMPLEMENTATION TCustomVirtualShellToolbar : public TCustomVirtualToolbar
{
	typedef TCustomVirtualToolbar inherited;
	
private:
	TCaptionOptions FButtonCaptionOptions;
	Virtualexplorertree::TCustomVirtualExplorerCombobox* FVirtualExplorerComboBox;
	TVSTOnAddButtonEvent FOnAddButton;
	void __fastcall SetButtonCaptionOptions(const TCaptionOptions Value);
	void __fastcall SetVirtualExplorerTree(Virtualexplorertree::TCustomVirtualExplorerTree* const Value);
	void __fastcall SetVirtualExplorerComboBox(Virtualexplorertree::TCustomVirtualExplorerCombobox* const Value);
	
protected:
	virtual void __fastcall ChangeLinkDispatch(Winapi::Shlobj::PItemIDList PIDL);
	virtual TVirtualButtonList* __fastcall CreateButtonList(void);
	void __fastcall DoAddButton(Mpshellutilities::TNamespace* Namespace, bool &Allow);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	HIDESBASE MESSAGE void __fastcall CMRecreateWnd(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMCommonThreadCallback(Mpthreadmanager::TWMThreadRequest &Msg);
	MESSAGE void __fastcall WMShellNotify(Winapi::Messages::TMessage &Msg);
	__property TCaptionOptions ButtonCaptionOptions = {read=FButtonCaptionOptions, write=SetButtonCaptionOptions, default=0};
	__property TVSTOnAddButtonEvent OnAddButton = {read=FOnAddButton, write=FOnAddButton};
	__property Virtualexplorertree::TCustomVirtualExplorerCombobox* VirtualExplorerComboBox = {read=FVirtualExplorerComboBox, write=SetVirtualExplorerComboBox};
	__property Virtualexplorertree::TCustomVirtualExplorerTree* VirtualExplorerTree = {read=FVirtualExplorerTree, write=SetVirtualExplorerTree};
	
public:
	__fastcall virtual TCustomVirtualShellToolbar(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCustomVirtualShellToolbar(void);
	DYNAMIC void __fastcall ChangeLinkFreeing(Virtualexplorertree::_di_IVETChangeLink ChangeLink);
public:
	/* TWinControl.CreateParented */ inline __fastcall TCustomVirtualShellToolbar(HWND ParentWindow) : TCustomVirtualToolbar(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualShellToolbar : public TCustomVirtualShellToolbar
{
	typedef TCustomVirtualShellToolbar inherited;
	
__published:
	__property Align = {default=1};
	__property AutoSize = {default=0};
	__property BiDiMode;
	__property BkGndParent;
	__property ButtonCaptionOptions = {default=0};
	__property ButtonLayout = {default=0};
	__property ButtonMargin = {default=-1};
	__property ButtonSpacing = {default=4};
	__property Caption;
	__property Color = {default=-16777211};
	__property Constraints;
	__property EdgeBorders = {default=2};
	__property EdgeInner = {default=1};
	__property EdgeOuter = {default=2};
	__property Font;
	__property Options = {default=256};
	__property PopupMenu;
	__property VirtualExplorerComboBox;
	__property VirtualExplorerTree;
	__property Visible = {default=1};
	__property OnClick;
	__property OnCreateButtons;
	__property OnRecreateButtons;
public:
	/* TCustomVirtualShellToolbar.Create */ inline __fastcall virtual TVirtualShellToolbar(System::Classes::TComponent* AOwner) : TCustomVirtualShellToolbar(AOwner) { }
	/* TCustomVirtualShellToolbar.Destroy */ inline __fastcall virtual ~TVirtualShellToolbar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualShellToolbar(HWND ParentWindow) : TCustomVirtualShellToolbar(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TCustomVirtualDriveToolbar : public TCustomVirtualShellToolbar
{
	typedef TCustomVirtualShellToolbar inherited;
	
private:
	TDriveSpecialFolders FDriveSpecialFolders;
	TVirtualToolbarOptions __fastcall GetOptions(void);
	HIDESBASE void __fastcall SetOptions(const TVirtualToolbarOptions Value);
	void __fastcall SetSpecialDriveFolders(const TDriveSpecialFolders Value);
	HIDESBASE MESSAGE void __fastcall WMRemoveButton(Winapi::Messages::TMessage &Message);
	
protected:
	virtual void __fastcall CreateButtons(void);
	__property TVirtualToolbarOptions Options = {read=GetOptions, write=SetOptions, default=256};
	__property TDriveSpecialFolders SpecialDriveFolders = {read=FDriveSpecialFolders, write=SetSpecialDriveFolders, default=56};
	
public:
	__fastcall virtual TCustomVirtualDriveToolbar(System::Classes::TComponent* AOwner);
public:
	/* TCustomVirtualShellToolbar.Destroy */ inline __fastcall virtual ~TCustomVirtualDriveToolbar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TCustomVirtualDriveToolbar(HWND ParentWindow) : TCustomVirtualShellToolbar(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualDriveToolbar : public TCustomVirtualDriveToolbar
{
	typedef TCustomVirtualDriveToolbar inherited;
	
__published:
	__property Align = {default=1};
	__property AutoSize = {default=0};
	__property BiDiMode;
	__property BkGndParent;
	__property ButtonCaptionOptions = {default=0};
	__property ButtonLayout = {default=0};
	__property ButtonMargin = {default=-1};
	__property ButtonSpacing = {default=4};
	__property Caption;
	__property Color = {default=-16777211};
	__property Constraints;
	__property DropInsertMargin = {default=4};
	__property EdgeBorders = {default=2};
	__property EdgeInner = {default=1};
	__property EdgeOuter = {default=2};
	__property Font;
	__property OnAddButton;
	__property Options = {default=256};
	__property PopupMenu;
	__property SpecialDriveFolders = {default=56};
	__property VirtualExplorerComboBox;
	__property VirtualExplorerTree;
	__property Visible = {default=1};
	__property OnClick;
	__property OnCreateButtons;
	__property OnRecreateButtons;
public:
	/* TCustomVirtualDriveToolbar.Create */ inline __fastcall virtual TVirtualDriveToolbar(System::Classes::TComponent* AOwner) : TCustomVirtualDriveToolbar(AOwner) { }
	
public:
	/* TCustomVirtualShellToolbar.Destroy */ inline __fastcall virtual ~TVirtualDriveToolbar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualDriveToolbar(HWND ParentWindow) : TCustomVirtualDriveToolbar(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TCustomVirtualSpecialFolderToolbar : public TCustomVirtualDriveToolbar
{
	typedef TCustomVirtualDriveToolbar inherited;
	
private:
	TSpecialFolders FSpecialFolders;
	TSpecialCommonFolders FSpecialCommonFolders;
	void __fastcall SetSpecialFolders(const TSpecialFolders Value);
	void __fastcall SetSpecialCommonFolders(const TSpecialCommonFolders Value);
	
protected:
	virtual void __fastcall CreateButtons(void);
	__property TSpecialFolders SpecialFolders = {read=FSpecialFolders, write=SetSpecialFolders, nodefault};
	__property TSpecialCommonFolders SpecialCommonFolders = {read=FSpecialCommonFolders, write=SetSpecialCommonFolders, nodefault};
public:
	/* TCustomVirtualDriveToolbar.Create */ inline __fastcall virtual TCustomVirtualSpecialFolderToolbar(System::Classes::TComponent* AOwner) : TCustomVirtualDriveToolbar(AOwner) { }
	
public:
	/* TCustomVirtualShellToolbar.Destroy */ inline __fastcall virtual ~TCustomVirtualSpecialFolderToolbar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TCustomVirtualSpecialFolderToolbar(HWND ParentWindow) : TCustomVirtualDriveToolbar(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualSpecialFolderToolbar : public TCustomVirtualSpecialFolderToolbar
{
	typedef TCustomVirtualSpecialFolderToolbar inherited;
	
__published:
	__property Align = {default=1};
	__property AutoSize = {default=0};
	__property BiDiMode;
	__property BkGndParent;
	__property ButtonCaptionOptions = {default=0};
	__property ButtonLayout = {default=0};
	__property ButtonMargin = {default=-1};
	__property ButtonSpacing = {default=4};
	__property Caption;
	__property Color = {default=-16777211};
	__property Constraints;
	__property DropInsertMargin = {default=4};
	__property EdgeBorders = {default=2};
	__property EdgeInner = {default=1};
	__property EdgeOuter = {default=2};
	__property Font;
	__property OnAddButton;
	__property Options = {default=256};
	__property PopupMenu;
	__property SpecialFolders;
	__property SpecialCommonFolders;
	__property VirtualExplorerComboBox;
	__property VirtualExplorerTree;
	__property Visible = {default=1};
	__property OnClick;
	__property OnCreateButtons;
	__property OnRecreateButtons;
public:
	/* TCustomVirtualDriveToolbar.Create */ inline __fastcall virtual TVirtualSpecialFolderToolbar(System::Classes::TComponent* AOwner) : TCustomVirtualSpecialFolderToolbar(AOwner) { }
	
public:
	/* TCustomVirtualShellToolbar.Destroy */ inline __fastcall virtual ~TVirtualSpecialFolderToolbar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualSpecialFolderToolbar(HWND ParentWindow) : TCustomVirtualSpecialFolderToolbar(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVSTShellToolbar : public Mpdataobject::TCommonClipboardFormat
{
	typedef Mpdataobject::TCommonClipboardFormat inherited;
	
private:
	unsigned FProcess;
	_ITEMIDLIST *FPIDL;
	int __fastcall GetPIDLSize(void);
	
public:
	virtual tagFORMATETC __fastcall GetFormatEtc(void);
	virtual bool __fastcall LoadFromDataObject(_di_IDataObject DataObject);
	virtual bool __fastcall SaveToDataObject(_di_IDataObject DataObject);
	__property unsigned Process = {read=FProcess, nodefault};
	__property int PIDLSize = {read=GetPIDLSize, nodefault};
	__property Winapi::Shlobj::PItemIDList PIDL = {read=FPIDL, write=FPIDL};
public:
	/* TObject.Create */ inline __fastcall TVSTShellToolbar(void) : Mpdataobject::TCommonClipboardFormat() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TVSTShellToolbar(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word ID_TIMER_HOTTRACK = System::Word(0x190);
static const System::Word ID_TIMER_HOTTRACKDELAY = System::Word(0x191);
static const System::Int8 HOTTRACKDELAY = System::Int8(0x64);
#define CFSTR_VSTSHELLTOOLBAR L"VST ShellToolbar"
extern DELPHI_PACKAGE System::Word CF_VSTSHELLTOOLBAR;
}	/* namespace Virtualshelltoolbar */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALSHELLTOOLBAR)
using namespace Virtualshelltoolbar;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualshelltoolbarHPP
