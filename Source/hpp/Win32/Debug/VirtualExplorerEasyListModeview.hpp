// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualExplorerEasyListModeview.pas' rev: 31.00 (Windows)

#ifndef VirtualexplorereasylistmodeviewHPP
#define VirtualexplorereasylistmodeviewHPP

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
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Winapi.ShlObj.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Themes.hpp>
#include <Winapi.UxTheme.hpp>
#include <EasyListview.hpp>
#include <MPThreadManager.hpp>
#include <VirtualResources.hpp>
#include <VirtualExplorerEasyListview.hpp>
#include <MPShellUtilities.hpp>
#include <VirtualExplorerTree.hpp>
#include <VirtualThumbnails.hpp>
#include <MPCommonUtilities.hpp>
#include <VirtualShellNotifier.hpp>
#include <MPCommonObjects.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualexplorereasylistmodeview
{
//-- forward type declarations -----------------------------------------------
struct TDetailInfo;
struct TListModeLayoutData;
class DELPHICLASS TColumnModeViewReportItem;
class DELPHICLASS TColumnModeEasyListview;
class DELPHICLASS TListModeDetails;
class DELPHICLASS TVirtualSplitter;
class DELPHICLASS TVirtualHeaderBarAttributes;
class DELPHICLASS TVirtualHeaderBar;
class DELPHICLASS TCustomVirtualColumnModeView;
class DELPHICLASS TVirtualColumnModeView;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TListModeViewState : unsigned char { lmvsBrowsing, lmvsRebuildingView, lmvsHilightingPath, lmvsChangeLinkChanging, lmvsResizedOnce };

typedef System::Set<TListModeViewState, TListModeViewState::lmvsBrowsing, TListModeViewState::lmvsResizedOnce> TListModeViewStates;

typedef TDetailInfo *PDetailInfo;

struct DECLSPEC_DRECORD TDetailInfo
{
public:
	System::WideString Title;
	System::WideString Detail;
	System::Types::TRect TitleRect;
	System::Types::TRect DetailRect;
};


typedef System::DynamicArray<TDetailInfo> TDetailInfoArray;

struct DECLSPEC_DRECORD TListModeLayoutData
{
public:
	TVirtualSplitter* Splitter;
	int iPosition;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TColumnModeViewReportItem : public Easylistview::TEasyViewReportItem
{
	typedef Easylistview::TEasyViewReportItem inherited;
	
private:
	System::Types::TSize FArrowSize;
	
public:
	__fastcall virtual TColumnModeViewReportItem(Easylistview::TEasyGroup* AnOwner);
	virtual void __fastcall ItemRectArray(Easylistview::TEasyItem* Item, Easylistview::TEasyColumn* Column, Vcl::Graphics::TCanvas* ACanvas, const System::WideString Caption, Easylistview::TEasyRectArrayObject &RectArray);
	virtual void __fastcall PaintBefore(Easylistview::TEasyItem* Item, Easylistview::TEasyColumn* Column, const System::WideString Caption, Vcl::Graphics::TCanvas* ACanvas, const Easylistview::TEasyRectArrayObject &RectArray, bool &Handled);
	virtual void __fastcall PaintText(Easylistview::TEasyItem* Item, Easylistview::TEasyColumn* Column, const System::WideString Caption, const Easylistview::TEasyRectArrayObject &RectArray, Vcl::Graphics::TCanvas* ACanvas, int LinesToDraw);
	__property System::Types::TSize ArrowSize = {read=FArrowSize, write=FArrowSize};
public:
	/* TEasyOwnedPersistentView.Destroy */ inline __fastcall virtual ~TColumnModeViewReportItem(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TColumnModeEasyListview : public Virtualexplorereasylistview::TVirtualExplorerEasyListview
{
	typedef Virtualexplorereasylistview::TVirtualExplorerEasyListview inherited;
	
private:
	TListModeLayoutData FInfo;
	TCustomVirtualColumnModeView* FColumnModeView;
	
protected:
	virtual bool __fastcall GetHeaderVisibility(void);
	virtual Easylistview::TEasyColumn* __fastcall GetSortColumn(void);
	virtual bool __fastcall LoadStorageToRoot(Virtualexplorertree::TNodeStorage* StorageNode);
	virtual void __fastcall DoColumnContextMenu(const Easylistview::TEasyHitInfoColumn &HitInfo, const System::Types::TPoint &WindowPoint, Vcl::Menus::TPopupMenu* &Menu);
	DYNAMIC void __fastcall DoEnter(void);
	DYNAMIC void __fastcall DoExit(void);
	virtual void __fastcall DoItemCustomView(Easylistview::TEasyItem* Item, Easylistview::TEasyListStyle ViewStyle, Easylistview::TEasyViewItemClass &View);
	virtual void __fastcall DoKeyAction(System::Word &CharCode, System::Classes::TShiftState &Shift, bool &DoDefault);
	virtual void __fastcall DoShellNotify(Virtualshellnotifier::TVirtualShellEvent* ShellEvent);
	virtual void __fastcall SaveRootToStorage(Virtualexplorertree::TNodeStorage* StorageNode);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	
public:
	__fastcall virtual TColumnModeEasyListview(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TColumnModeEasyListview(void);
	virtual bool __fastcall BrowseToByPIDL(Winapi::Shlobj::PItemIDList APIDL, bool SelectTarget = true, bool ShowExplorerMsg = true);
	virtual void __fastcall BrowseToPrevLevel(void);
	__property TCustomVirtualColumnModeView* ColumnModeView = {read=FColumnModeView, write=FColumnModeView};
	__property TListModeLayoutData Info = {read=FInfo, write=FInfo};
public:
	/* TWinControl.CreateParented */ inline __fastcall TColumnModeEasyListview(HWND ParentWindow) : Virtualexplorereasylistview::TVirtualExplorerEasyListview(ParentWindow) { }
	
};


typedef System::TMetaClass* TListModeEasyListviewClass;

class PASCALIMPLEMENTATION TListModeDetails : public Vcl::Forms::TScrollBox
{
	typedef Vcl::Forms::TScrollBox inherited;
	
private:
	System::Classes::TList* FDetailInfoList;
	Vcl::Extctrls::TPaintBox* FDetailsPaintBox;
	Virtualexplorereasylistview::TVirtualExplorerEasyListview* FExplorerListview;
	int FMaxTitleWidthCache;
	System::Classes::TWndMethod FOldWndProc;
	Vcl::Extctrls::TImage* FThumbnail;
	bool FValidDetails;
	
protected:
	void __fastcall ClearInfoList(void);
	void __fastcall OnDetailsPaint(System::TObject* Sender);
	void __fastcall ResizeLabels(int NewClientW, int NewClientH);
	void __fastcall ShellExecuteNamespace(void);
	void __fastcall SplitCaption(System::WideString ACaption, System::WideString &ATitle, System::WideString &ADetail);
	void __fastcall BuildDetailInfo(Mpcommonutilities::TCommonWideStringDynArray Details);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Msg);
	void __fastcall WindowProcHook(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMWindowPosChanging(Winapi::Messages::TWMWindowPosMsg &Msg);
	__property int MaxTitleWidthCache = {read=FMaxTitleWidthCache, write=FMaxTitleWidthCache, nodefault};
	__property System::Classes::TWndMethod OldWndProc = {read=FOldWndProc, write=FOldWndProc};
	
public:
	__fastcall virtual TListModeDetails(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TListModeDetails(void);
	System::Types::TSize __fastcall MaxTitleWidth(TDetailInfoArray DetailArray, Vcl::Graphics::TFont* AFont);
	__property System::Classes::TList* DetailInfoList = {read=FDetailInfoList, write=FDetailInfoList};
	__property Vcl::Extctrls::TPaintBox* DetailsPaintBox = {read=FDetailsPaintBox, write=FDetailsPaintBox};
	__property Virtualexplorereasylistview::TVirtualExplorerEasyListview* ExplorerListview = {read=FExplorerListview, write=FExplorerListview};
	__property Vcl::Extctrls::TImage* Thumbnail = {read=FThumbnail, write=FThumbnail};
	__property bool ValidDetails = {read=FValidDetails, write=FValidDetails, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TListModeDetails(HWND ParentWindow) : Vcl::Forms::TScrollBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualSplitter : public Vcl::Controls::TGraphicControl
{
	typedef Vcl::Controls::TGraphicControl inherited;
	
private:
	System::Types::TPoint FDownPt;
	bool FDragged;
	int FLastSize;
	int FLastWidth;
	Vcl::Controls::TControl* FTestControl;
	
protected:
	HIDESBASE bool __fastcall DoCanResize(int &NewSize);
	Vcl::Controls::TControl* __fastcall FindControl(void);
	bool __fastcall VertScrollVisible(void);
	DYNAMIC void __fastcall Click(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	void __fastcall SetControlWidth(int NewSize);
	__property bool Dragged = {read=FDragged, write=FDragged, nodefault};
	__property int LastSize = {read=FLastSize, write=FLastSize, nodefault};
	__property int LastWidth = {read=FLastWidth, write=FLastWidth, nodefault};
	
public:
	__fastcall virtual TVirtualSplitter(System::Classes::TComponent* AOwner);
	
__published:
	System::Types::TRect __fastcall ExpandCollapseRect(void);
	__property Cursor = {default=-14};
	
public:
	__property System::Types::TPoint DownPt = {read=FDownPt, write=FDownPt};
	
__published:
	__property Vcl::Controls::TControl* TestControl = {read=FTestControl, write=FTestControl};
public:
	/* TGraphicControl.Destroy */ inline __fastcall virtual ~TVirtualSplitter(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TVirtualHeaderBarAttributes : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Uitypes::TColor FColor;
	bool FFlat;
	Vcl::Graphics::TFont* FFont;
	TVirtualHeaderBar* FOwner;
	void __fastcall SetColor(const System::Uitypes::TColor Value);
	void __fastcall SetFlat(const bool Value);
	
public:
	__fastcall TVirtualHeaderBarAttributes(TVirtualHeaderBar* AnOwner);
	__fastcall virtual ~TVirtualHeaderBarAttributes(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property TVirtualHeaderBar* Owner = {read=FOwner};
	
__published:
	__property System::Uitypes::TColor Color = {read=FColor, write=SetColor, default=-16777201};
	__property bool Flat = {read=FFlat, write=SetFlat, default=0};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=FFont};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TVirtualHeaderBar : public Mpcommonobjects::TCommonCanvasControl
{
	typedef Mpcommonobjects::TCommonCanvasControl inherited;
	
private:
	Vcl::Graphics::TBitmap* FBackBits;
	TVirtualHeaderBarAttributes* FAttribs;
	TCustomVirtualColumnModeView* FColumnModeView;
	
protected:
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	HIDESBASE void __fastcall ResizeBackBits(int NewWidth, int NewHeight);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Msg);
	HIDESBASE MESSAGE void __fastcall WMWindowPosChanged(Winapi::Messages::TWMWindowPosMsg &Msg);
	HIDESBASE MESSAGE void __fastcall WMWindowPosChanging(Winapi::Messages::TWMWindowPosMsg &Msg);
	__property Vcl::Graphics::TBitmap* BackBits = {read=FBackBits, write=FBackBits};
	__property TCustomVirtualColumnModeView* ColumnModeView = {read=FColumnModeView, write=FColumnModeView};
	
public:
	__fastcall virtual TVirtualHeaderBar(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TVirtualHeaderBar(void);
	__property TVirtualHeaderBarAttributes* Attribs = {read=FAttribs, write=FAttribs};
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualHeaderBar(HWND ParentWindow) : Mpcommonobjects::TCommonCanvasControl(ParentWindow) { }
	
};


typedef void __fastcall (__closure *TItemFocusChangeLMVEvent)(TCustomVirtualColumnModeView* Sender, Easylistview::TCustomEasyListview* ListModeView, Easylistview::TEasyItem* Item);

typedef void __fastcall (__closure *TItemFocusChangingLMVEvent)(TCustomVirtualColumnModeView* Sender, Easylistview::TCustomEasyListview* ListModeView, Easylistview::TEasyItem* Item, bool &Allow);

typedef void __fastcall (__closure *TItemSelectionChangeLMVEvent)(TCustomVirtualColumnModeView* Sender, Easylistview::TCustomEasyListview* ListModeView, Easylistview::TEasyItem* Item);

typedef void __fastcall (__closure *TItemSelectionChangingLMVEvent)(TCustomVirtualColumnModeView* Sender, Easylistview::TCustomEasyListview* ListModeView, Easylistview::TEasyItem* Item, bool &Allow);

typedef void __fastcall (__closure *TEasyItemSelectionsChangedLMVEvent)(TCustomVirtualColumnModeView* Sender, Easylistview::TCustomEasyListview* ListModeView);

typedef void __fastcall (__closure *TExplorerListviewClassEvent)(TCustomVirtualColumnModeView* Sender, TListModeEasyListviewClass &ViewClass);

typedef void __fastcall (__closure *TListviewEnterEvent)(TCustomVirtualColumnModeView* Sender, TColumnModeEasyListview* Listview);

typedef void __fastcall (__closure *TListviewExitEvent)(TCustomVirtualColumnModeView* Sender, TColumnModeEasyListview* Listview);

typedef void __fastcall (__closure *TListviewItemMouseDownEvent)(TCustomVirtualColumnModeView* Sender, Easylistview::TCustomEasyListview* Listview, Easylistview::TEasyItem* Item, Mpcommonutilities::TCommonMouseButton Button, bool &DoDefault);

typedef void __fastcall (__closure *TListviewItemMouseUpEvent)(TCustomVirtualColumnModeView* Sender, Easylistview::TCustomEasyListview* Listview, Easylistview::TEasyItem* Item, Mpcommonutilities::TCommonMouseButton Button, bool &DoDefault);

typedef void __fastcall (__closure *TListviewEnumFolderEvent)(TCustomVirtualColumnModeView* Sender, Virtualexplorereasylistview::TCustomVirtualExplorerEasyListview* Listview, Mpshellutilities::TNamespace* Namespace, bool &AllowAsChild);

typedef void __fastcall (__closure *TListviewContextMenuEvent)(TCustomVirtualColumnModeView* Sender, Easylistview::TCustomEasyListview* Listview, const System::Types::TPoint &MousePt, bool &Handled);

typedef void __fastcall (__closure *TListviewContextMenu2MessageEvent)(TCustomVirtualColumnModeView* Sender, Virtualexplorereasylistview::TCustomVirtualExplorerEasyListview* Listview, Winapi::Messages::TMessage &Msg);

typedef void __fastcall (__closure *TListviewDblClickEvent)(TCustomVirtualColumnModeView* Sender, Easylistview::TCustomEasyListview* Listview, Mpcommonutilities::TCommonMouseButton Button, const System::Types::TPoint &MousePos, System::Classes::TShiftState ShiftState);

typedef void __fastcall (__closure *TListviewMouseGestureEvent)(TCustomVirtualColumnModeView* Sender, Easylistview::TCustomEasyListview* Listview, Mpcommonutilities::TCommonMouseButton Button, Mpcommonutilities::TCommonKeyStates KeyState, System::WideString Gesture, bool &DoDefaultMouseAction);

typedef void __fastcall (__closure *TListviewRootChangeLMVEvent)(TCustomVirtualColumnModeView* Sender, Virtualexplorereasylistview::TCustomVirtualExplorerEasyListview* Listview);

typedef void __fastcall (__closure *TColumnModeRebuildEvent)(TCustomVirtualColumnModeView* Sender);

typedef void __fastcall (__closure *TColumnModeViewRebuildingEvent)(TCustomVirtualColumnModeView* Sender);

typedef void __fastcall (__closure *TColumnModeViewAddedEvent)(TCustomVirtualColumnModeView* Sender, TColumnModeEasyListview* NewView);

typedef void __fastcall (__closure *TColumnModeViewFreeingEvent)(TCustomVirtualColumnModeView* Sender, TColumnModeEasyListview* View);

typedef void __fastcall (__closure *TColumnModeviewMouseUp)(TCustomVirtualColumnModeView* Sender, TColumnModeEasyListview* View, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);

typedef void __fastcall (__closure *TColumnModePathChangingEvent)(TCustomVirtualColumnModeView* Sender, Mpshellutilities::TNamespace* NewPath, Mpshellutilities::TNamespace* OldPath, bool &Allow);

typedef void __fastcall (__closure *TColumnModePathChangeEvent)(TCustomVirtualColumnModeView* Sender, Mpshellutilities::TNamespace* NewPath);

class PASCALIMPLEMENTATION TCustomVirtualColumnModeView : public Vcl::Forms::TScrollBox
{
	typedef Vcl::Forms::TScrollBox inherited;
	
public:
	TColumnModeEasyListview* operator[](int Index) { return this->Views[Index]; }
	
private:
	bool FActive;
	bool FBandHilight;
	System::Uitypes::TColor FBandHilightColor;
	int FCachedScrollPos;
	int FDefaultColumnWidth;
	int FDefaultSortColumn;
	Easylistview::TEasySortDirection FDefaultSortDir;
	Mpshellutilities::TFileObjects FFileObjects;
	System::Classes::TList* FFreeViewList;
	TListModeDetails* FDetails;
	Virtualexplorertree::TVirtualExplorerCombobox* FExplorerCombobox;
	bool FGrouped;
	int FGroupingColumn;
	TVirtualHeaderBar* FHeaderBar;
	bool FHilightActiveColumn;
	System::Uitypes::TColor FHilightColumnColor;
	Easylistview::TEasyHintType FHintType;
	TColumnModeEasyListview* FLastFocusedView;
	System::Classes::TNotifyEvent FOldFontChangeEvent;
	TItemFocusChangeLMVEvent FOnItemFocusChange;
	TItemFocusChangingLMVEvent FOnItemFocusChanging;
	TItemSelectionChangeLMVEvent FOnItemSelectionChange;
	TItemSelectionChangingLMVEvent FOnItemSelectionChanging;
	TEasyItemSelectionsChangedLMVEvent FOnItemSelectionsChange;
	TExplorerListviewClassEvent FOnListviewClass;
	TListviewContextMenuEvent FOnListviewContextMenu;
	TListviewContextMenu2MessageEvent FOnListviewContextMenu2Message;
	TListviewDblClickEvent FOnListviewDblClick;
	TListviewEnterEvent FOnListviewEnter;
	TListviewEnumFolderEvent FOnListviewEnumFolder;
	TListviewExitEvent FOnListviewExit;
	TListviewItemMouseDownEvent FOnListviewItemMouseDown;
	TListviewItemMouseUpEvent FOnListviewItemMouseUp;
	TListviewRootChangeLMVEvent FOnListviewRootChanged;
	TListviewMouseGestureEvent FOnListviewMouseGesture;
	TColumnModePathChangeEvent FOnPathChange;
	TColumnModePathChangingEvent FOnPathChanging;
	TColumnModeRebuildEvent FOnRebuild;
	TColumnModeViewRebuildingEvent FOnRebuilding;
	TColumnModeViewAddedEvent FOnViewAdded;
	TColumnModeViewFreeingEvent FOnViewFreeing;
	TColumnModeviewMouseUp FOnViewMouseUp;
	Virtualexplorereasylistview::TVirtualEasyListviewOptions FOptions;
	Mpshellutilities::TNamespace* FPath;
	int FRedrawLockCount;
	bool FResetDragPendings;
	System::Word FSelectionChangeTimeInterval;
	Vcl::Extctrls::TTimer* FSelectionChangeTimer;
	bool FShellThumbnailExtraction;
	bool FShowInactive;
	int FSmoothScrollDelta;
	bool FSortFolderFirstAlways;
	TListModeViewStates FState;
	System::Classes::TList* FViewList;
	TColumnModeEasyListview* __fastcall GetFocusedView(void);
	TVirtualHeaderBarAttributes* __fastcall GetHeader(void);
	TColumnModeEasyListview* __fastcall GetViews(int Index);
	int __fastcall GetViewCount(void);
	void __fastcall SetActive(const bool Value);
	void __fastcall SetBandHilight(const bool Value);
	void __fastcall SetBandHilightColor(const System::Uitypes::TColor Value);
	void __fastcall SetDefaultColumnWidth(const int Value);
	void __fastcall SetDefaultSortColumn(const int Value);
	void __fastcall SetDefaultSortDir(const Easylistview::TEasySortDirection Value);
	void __fastcall SetExplorerCombobox(Virtualexplorertree::TVirtualExplorerCombobox* const Value);
	void __fastcall SetFileObjects(const Mpshellutilities::TFileObjects Value);
	void __fastcall SetGrouped(const bool Value);
	void __fastcall SetGroupingColumn(const int Value);
	void __fastcall SetHeader(TVirtualHeaderBarAttributes* const Value);
	void __fastcall SetHilightActiveColumn(const bool Value);
	void __fastcall SetHilightColumnColor(const System::Uitypes::TColor Value);
	void __fastcall SetHintType(const Easylistview::TEasyHintType Value);
	void __fastcall SetOptions(const Virtualexplorereasylistview::TVirtualEasyListviewOptions Value);
	void __fastcall SetPath(Mpshellutilities::TNamespace* const Value);
	void __fastcall SetSelectionChangeTimeInterval(const System::Word Value);
	void __fastcall SetShowInactive(const bool Value);
	void __fastcall SetSortFolderFirstAlways(const bool Value);
	void __fastcall SetViews(int Index, TColumnModeEasyListview* Value);
	
protected:
	virtual TColumnModeEasyListview* __fastcall AddView(Winapi::Shlobj::PItemIDList PIDL, int AWidth);
	Mpshellutilities::TNamespace* __fastcall ViewNamespace(int Index);
	TVirtualSplitter* __fastcall ViewSplitter(int Index);
	void __fastcall ClearViews(void);
	HIDESBASE MESSAGE void __fastcall CMColorChanged(Winapi::Messages::TMessage &Msg);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	void __fastcall DeleteListview(TColumnModeEasyListview* Item);
	DYNAMIC void __fastcall DoEnter(void);
	DYNAMIC void __fastcall DoExit(void);
	virtual void __fastcall DoItemFocusChange(Easylistview::TCustomEasyListview* Sender, Easylistview::TEasyItem* Item);
	virtual void __fastcall DoItemFocusChanging(Easylistview::TCustomEasyListview* ListModeView, Easylistview::TEasyItem* Item, bool &Allow);
	virtual void __fastcall DoItemSelectionChange(Easylistview::TCustomEasyListview* ListModeView, Easylistview::TEasyItem* Item);
	virtual void __fastcall DoItemSelectionChanging(Easylistview::TCustomEasyListview* ListModeView, Easylistview::TEasyItem* Item, bool &Allow);
	virtual void __fastcall DoItemSelectionsChange(Easylistview::TCustomEasyListview* ListModeView);
	void __fastcall DoListModeEasyListviewClass(TListModeEasyListviewClass &ViewClass);
	virtual void __fastcall DoListviewContextMenu(Easylistview::TCustomEasyListview* Sender, const System::Types::TPoint &MousePt, bool &Handled);
	virtual void __fastcall DoListviewContextMenu2Message(Virtualexplorereasylistview::TCustomVirtualExplorerEasyListview* Sender, Winapi::Messages::TMessage &Msg);
	virtual void __fastcall DoListviewDbkClick(Easylistview::TCustomEasyListview* Sender, Mpcommonutilities::TCommonMouseButton Button, const System::Types::TPoint &MousePos, System::Classes::TShiftState ShiftState, bool &Handled);
	void __fastcall DoListviewEnter(TColumnModeEasyListview* Listview);
	void __fastcall DoListviewEnumFolder(Virtualexplorereasylistview::TCustomVirtualExplorerEasyListview* Sender, Mpshellutilities::TNamespace* Namespace, bool &AllowAsChild);
	void __fastcall DoListviewExit(TColumnModeEasyListview* Listview);
	virtual void __fastcall DoListviewItemMouseDown(Easylistview::TCustomEasyListview* Sender, Easylistview::TEasyItem* Item, Mpcommonutilities::TCommonMouseButton Button, bool &DoDefault);
	virtual void __fastcall DoListviewItemMouseUp(Easylistview::TCustomEasyListview* Sender, Easylistview::TEasyItem* Item, Mpcommonutilities::TCommonMouseButton Button, bool &DoDefault);
	virtual void __fastcall DoListviewMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall DoListviewMouseGesture(Easylistview::TCustomEasyListview* Sender, Mpcommonutilities::TCommonMouseButton Button, Mpcommonutilities::TCommonKeyStates KeyState, System::WideString Gesture, bool &DoDefaultMouseAction);
	virtual void __fastcall DoListviewMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall DoListviewRootChange(Virtualexplorereasylistview::TCustomVirtualExplorerEasyListview* Listview);
	virtual void __fastcall DoPathChanged(Mpshellutilities::TNamespace* NewPath);
	virtual void __fastcall DoPathChanging(Mpshellutilities::TNamespace* OldPath, Mpshellutilities::TNamespace* NewPath, bool &Allow);
	virtual void __fastcall DoRebuild(void);
	virtual void __fastcall DoRebuilding(void);
	virtual void __fastcall DoViewAdded(TColumnModeEasyListview* NewView);
	virtual void __fastcall DoViewDeleting(TColumnModeEasyListview* View);
	void __fastcall EnterWindow(System::TObject* Sender);
	void __fastcall ExitWindow(System::TObject* Sender);
	void __fastcall FlushFreeViewList(bool FlushQueue);
	void __fastcall FontChanging(System::TObject* Sender);
	void __fastcall FreeView(TColumnModeEasyListview* View);
	void __fastcall ItemFocusChange(Easylistview::TCustomEasyListview* Sender, Easylistview::TEasyItem* Item);
	void __fastcall ItemFocusChanging(Easylistview::TCustomEasyListview* Sender, Easylistview::TEasyItem* Item, bool &Allow);
	void __fastcall ItemSelectionChange(Easylistview::TCustomEasyListview* Sender, Easylistview::TEasyItem* Item);
	void __fastcall ItemSelectionChanging(Easylistview::TCustomEasyListview* Sender, Easylistview::TEasyItem* Item, bool &Allow);
	void __fastcall ItemSelectionsChange(Easylistview::TCustomEasyListview* Sender);
	void __fastcall ListviewContextMenu(Easylistview::TCustomEasyListview* Sender, const System::Types::TPoint &MousePt, bool &Handled);
	void __fastcall ListviewContextMenu2Message(Virtualexplorereasylistview::TCustomVirtualExplorerEasyListview* Sender, Winapi::Messages::TMessage &Msg);
	void __fastcall ListviewDblClick(Easylistview::TCustomEasyListview* Sender, Mpcommonutilities::TCommonMouseButton Button, const System::Types::TPoint &MousePos, System::Classes::TShiftState ShiftState, bool &Handled);
	void __fastcall ListviewEnumFolder(Virtualexplorereasylistview::TCustomVirtualExplorerEasyListview* Sender, Mpshellutilities::TNamespace* Namespace, bool &AllowAsChild);
	void __fastcall ListviewItemFreeing(Easylistview::TCustomEasyListview* Sender, Easylistview::TEasyItem* Item);
	virtual void __fastcall ListviewItemMouseDown(Easylistview::TCustomEasyListview* Sender, Easylistview::TEasyItem* Item, Mpcommonutilities::TCommonMouseButton Button, bool &DoDefault);
	virtual void __fastcall ListviewItemMouseUp(Easylistview::TCustomEasyListview* Sender, Easylistview::TEasyItem* Item, Mpcommonutilities::TCommonMouseButton Button, bool &DoDefault);
	void __fastcall ListviewMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall ListviewMouseGesture(Easylistview::TCustomEasyListview* Sender, Mpcommonutilities::TCommonMouseButton Button, Mpcommonutilities::TCommonKeyStates KeyState, System::WideString Gesture, bool &DoDefaultMouseAction);
	void __fastcall ListviewResize(System::TObject* Sender);
	void __fastcall ListviewMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall ListviewRootChange(Virtualexplorereasylistview::TCustomVirtualExplorerEasyListview* Sender);
	void __fastcall RebuildView(void);
	void __fastcall RemoveView(int Index);
	void __fastcall ScrollbarSetPosition(int NewPos);
	void __fastcall ScrollLeft(void);
	void __fastcall ScrollRight(void);
	void __fastcall SelectionChangeTimerEvent(System::TObject* Sender);
	void __fastcall ShellExecute(Virtualexplorereasylistview::TCustomVirtualExplorerEasyListview* Sender, Mpshellutilities::TNamespace* Namespace, System::WideString &WorkingDir, System::WideString &CmdLineArgument, bool &Allow);
	void __fastcall TestForRebuild(System::TObject* Sender);
	HIDESBASE MESSAGE void __fastcall WMDestroy(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	MESSAGE void __fastcall WMFreeView(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	MESSAGE void __fastcall WMPostFocusBackToView(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMPostViewLosingFocus(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMThreadCallback(Mpthreadmanager::TWMThreadRequest &Msg);
	HIDESBASE MESSAGE void __fastcall WMWindowPosChanged(Winapi::Messages::TWMWindowPosMsg &Msg);
	__property bool Active = {read=FActive, write=SetActive, default=0};
	__property TColumnModeEasyListview* FocusedView = {read=GetFocusedView};
	__property bool BandHilight = {read=FBandHilight, write=SetBandHilight, default=0};
	__property System::Uitypes::TColor BandHilightColor = {read=FBandHilightColor, write=SetBandHilightColor, default=16250871};
	__property int CachedScrollPos = {read=FCachedScrollPos, write=FCachedScrollPos, nodefault};
	__property int DefaultColumnWidth = {read=FDefaultColumnWidth, write=SetDefaultColumnWidth, default=200};
	__property int DefaultSortColumn = {read=FDefaultSortColumn, write=SetDefaultSortColumn, default=0};
	__property Easylistview::TEasySortDirection DefaultSortDir = {read=FDefaultSortDir, write=SetDefaultSortDir, default=0};
	__property TListModeDetails* Details = {read=FDetails, write=FDetails};
	__property Virtualexplorertree::TVirtualExplorerCombobox* ExplorerCombobox = {read=FExplorerCombobox, write=SetExplorerCombobox};
	__property Mpshellutilities::TFileObjects FileObjects = {read=FFileObjects, write=SetFileObjects, default=3};
	__property System::Classes::TList* FreeViewList = {read=FFreeViewList, write=FFreeViewList};
	__property bool Grouped = {read=FGrouped, write=SetGrouped, nodefault};
	__property int GroupingColumn = {read=FGroupingColumn, write=SetGroupingColumn, nodefault};
	__property TVirtualHeaderBarAttributes* Header = {read=GetHeader, write=SetHeader};
	__property TVirtualHeaderBar* HeaderBar = {read=FHeaderBar, write=FHeaderBar};
	__property bool HilightActiveColumn = {read=FHilightActiveColumn, write=SetHilightActiveColumn, default=0};
	__property System::Uitypes::TColor HilightColumnColor = {read=FHilightColumnColor, write=SetHilightColumnColor, default=16250871};
	__property Easylistview::TEasyHintType HintType = {read=FHintType, write=SetHintType, default=0};
	__property TColumnModeEasyListview* LastFocusedView = {read=FLastFocusedView, write=FLastFocusedView};
	__property System::Classes::TNotifyEvent OldFontChangeEvent = {read=FOldFontChangeEvent, write=FOldFontChangeEvent};
	__property TItemFocusChangeLMVEvent OnItemFocusChange = {read=FOnItemFocusChange, write=FOnItemFocusChange};
	__property TItemFocusChangingLMVEvent OnItemFocusChanging = {read=FOnItemFocusChanging, write=FOnItemFocusChanging};
	__property TItemSelectionChangeLMVEvent OnItemSelectionChange = {read=FOnItemSelectionChange, write=FOnItemSelectionChange};
	__property TItemSelectionChangingLMVEvent OnItemSelectionChanging = {read=FOnItemSelectionChanging, write=FOnItemSelectionChanging};
	__property TEasyItemSelectionsChangedLMVEvent OnItemSelectionsChange = {read=FOnItemSelectionsChange, write=FOnItemSelectionsChange};
	__property TExplorerListviewClassEvent OnListviewClass = {read=FOnListviewClass, write=FOnListviewClass};
	__property TListviewContextMenuEvent OnListviewContextMenu = {read=FOnListviewContextMenu, write=FOnListviewContextMenu};
	__property TListviewContextMenu2MessageEvent OnListviewContextMenu2Message = {read=FOnListviewContextMenu2Message, write=FOnListviewContextMenu2Message};
	__property TListviewDblClickEvent OnListviewDblClick = {read=FOnListviewDblClick, write=FOnListviewDblClick};
	__property TListviewEnterEvent OnListviewEnter = {read=FOnListviewEnter, write=FOnListviewEnter};
	__property TListviewEnumFolderEvent OnListviewEnumFolder = {read=FOnListviewEnumFolder, write=FOnListviewEnumFolder};
	__property TListviewExitEvent OnListviewExit = {read=FOnListviewExit, write=FOnListviewExit};
	__property TListviewItemMouseDownEvent OnListviewItemMouseDown = {read=FOnListviewItemMouseDown, write=FOnListviewItemMouseDown};
	__property TListviewItemMouseUpEvent OnListviewItemMouseUp = {read=FOnListviewItemMouseUp, write=FOnListviewItemMouseUp};
	__property TListviewMouseGestureEvent OnListviewMouseGesture = {read=FOnListviewMouseGesture, write=FOnListviewMouseGesture};
	__property TListviewRootChangeLMVEvent OnListviewRootChange = {read=FOnListviewRootChanged, write=FOnListviewRootChanged};
	__property TColumnModePathChangeEvent OnPathChange = {read=FOnPathChange, write=FOnPathChange};
	__property TColumnModePathChangingEvent OnPathChanging = {read=FOnPathChanging, write=FOnPathChanging};
	__property TColumnModeRebuildEvent OnRebuild = {read=FOnRebuild, write=FOnRebuild};
	__property TColumnModeViewRebuildingEvent OnRebuilding = {read=FOnRebuilding, write=FOnRebuilding};
	__property TColumnModeViewAddedEvent OnViewAdded = {read=FOnViewAdded, write=FOnViewAdded};
	__property TColumnModeViewFreeingEvent OnViewFreeing = {read=FOnViewFreeing, write=FOnViewFreeing};
	__property TColumnModeviewMouseUp OnViewMouseUp = {read=FOnViewMouseUp, write=FOnViewMouseUp};
	__property Virtualexplorereasylistview::TVirtualEasyListviewOptions Options = {read=FOptions, write=SetOptions, default=207};
	__property Mpshellutilities::TNamespace* Path = {read=FPath, write=SetPath};
	__property int RedrawLockCount = {read=FRedrawLockCount, write=FRedrawLockCount, nodefault};
	__property bool ResetDragPendings = {read=FResetDragPendings, write=FResetDragPendings, nodefault};
	__property System::Word SelectionChangeTimeInterval = {read=FSelectionChangeTimeInterval, write=SetSelectionChangeTimeInterval, default=300};
	__property Vcl::Extctrls::TTimer* SelectionChangeTimer = {read=FSelectionChangeTimer, write=FSelectionChangeTimer};
	__property bool ShellThumbnailExtraction = {read=FShellThumbnailExtraction, write=FShellThumbnailExtraction, default=0};
	__property bool ShowInactive = {read=FShowInactive, write=SetShowInactive, default=0};
	__property int SmoothScrollDelta = {read=FSmoothScrollDelta, write=FSmoothScrollDelta, default=0};
	__property bool SortFolderFirstAlways = {read=FSortFolderFirstAlways, write=SetSortFolderFirstAlways, default=0};
	__property TListModeViewStates State = {read=FState, write=FState, nodefault};
	__property int ViewCount = {read=GetViewCount, nodefault};
	__property System::Classes::TList* ViewList = {read=FViewList, write=FViewList};
	__property TColumnModeEasyListview* Views[int Index] = {read=GetViews, write=SetViews/*, default*/};
	
public:
	__fastcall virtual TCustomVirtualColumnModeView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCustomVirtualColumnModeView(void);
	bool __fastcall BrowseToPrevLevel(void);
	TColumnModeEasyListview* __fastcall FindFirstQuickFilteredView(void);
	DYNAMIC void __fastcall ChangeLinkChanging(System::TObject* Server, Winapi::Shlobj::PItemIDList NewPIDL);
	virtual void __fastcall ChangeLinkDispatch(void);
	DYNAMIC void __fastcall ChangeLinkFreeing(Virtualexplorertree::_di_IVETChangeLink ChangeLink);
	bool __fastcall BrowseTo(Winapi::Shlobj::PItemIDList APIDL);
	void __fastcall ClearSelections(void);
	void __fastcall ClickColumn(int ColumnIndex);
	void __fastcall Flush(void);
	void __fastcall FlushThreadRequests(void);
	void __fastcall HilightPath(Winapi::Shlobj::PItemIDList PIDL);
	void __fastcall LockRedraw(void);
	void __fastcall Rebuild(void);
	void __fastcall SortOnColumn(int Index);
	void __fastcall ToggleSortDir(void);
	void __fastcall UnLockRedraw(void);
public:
	/* TWinControl.CreateParented */ inline __fastcall TCustomVirtualColumnModeView(HWND ParentWindow) : Vcl::Forms::TScrollBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TVirtualColumnModeView : public TCustomVirtualColumnModeView
{
	typedef TCustomVirtualColumnModeView inherited;
	
public:
	__property FocusedView;
	__property Details;
	__property HeaderBar;
	__property LastFocusedView;
	__property Path;
	__property State;
	__property ViewCount;
	__property Views;
	
__published:
	__property Active = {default=0};
	__property BandHilight = {default=0};
	__property BandHilightColor = {default=16250871};
	__property Color;
	__property Cursor = {default=0};
	__property DefaultColumnWidth = {default=200};
	__property DefaultSortColumn = {default=0};
	__property DefaultSortDir = {default=0};
	__property ExplorerCombobox;
	__property FileObjects = {default=3};
	__property Grouped;
	__property GroupingColumn;
	__property HilightActiveColumn = {default=0};
	__property HilightColumnColor = {default=16250871};
	__property HintType = {default=0};
	__property OnEnter;
	__property OnExit;
	__property OnItemFocusChange;
	__property OnItemFocusChanging;
	__property OnItemSelectionChange;
	__property OnItemSelectionChanging;
	__property OnItemSelectionsChange;
	__property OnListviewClass;
	__property OnListviewContextMenu;
	__property OnListviewContextMenu2Message;
	__property OnListviewDblClick;
	__property OnListviewEnter;
	__property OnListviewEnumFolder;
	__property OnListviewExit;
	__property OnListviewItemMouseDown;
	__property OnListviewItemMouseUp;
	__property OnListviewMouseGesture;
	__property OnListviewRootChange;
	__property OnPathChange;
	__property OnPathChanging;
	__property OnRebuild;
	__property OnRebuilding;
	__property OnViewAdded;
	__property OnViewFreeing;
	__property OnViewMouseUp;
	__property Options = {default=207};
	__property SelectionChangeTimeInterval = {default=300};
	__property ShellThumbnailExtraction = {default=0};
	__property ShowInactive = {default=0};
	__property SmoothScrollDelta = {default=0};
	__property SortFolderFirstAlways = {default=0};
public:
	/* TCustomVirtualColumnModeView.Create */ inline __fastcall virtual TVirtualColumnModeView(System::Classes::TComponent* AOwner) : TCustomVirtualColumnModeView(AOwner) { }
	/* TCustomVirtualColumnModeView.Destroy */ inline __fastcall virtual ~TVirtualColumnModeView(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TVirtualColumnModeView(HWND ParentWindow) : TCustomVirtualColumnModeView(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Byte WIDTH_COLUMN = System::Byte(0xc8);
static const System::Word WM_FREEVIEW = System::Word(0x8191);
static const System::Word WM_POSTFOCUSBACKTOVIEW = System::Word(0x8192);
static const System::Word WM_POSTVIEWLOSINGFOCUS = System::Word(0x8193);
}	/* namespace Virtualexplorereasylistmodeview */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALEXPLOREREASYLISTMODEVIEW)
using namespace Virtualexplorereasylistmodeview;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualexplorereasylistmodeviewHPP
