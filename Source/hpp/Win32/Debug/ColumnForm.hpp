// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ColumnForm.pas' rev: 30.00 (Windows)

#ifndef ColumnformHPP
#define ColumnformHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <VirtualTrees.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Columnform
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFormColumnSettings;
struct TColumnData;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TVETUpdate)(System::TObject* Sender);

class PASCALIMPLEMENTATION TFormColumnSettings : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TBevel* Bevel1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TEdit* EditPixelWidth;
	Vcl::Stdctrls::TCheckBox* CheckBoxLiveUpdate;
	Vcl::Stdctrls::TButton* ButtonOk;
	Vcl::Stdctrls::TButton* ButtonCancel;
	Virtualtrees::TVirtualStringTree* VSTColumnNames;
	Vcl::Extctrls::TPanel* Panel1;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall VSTColumnNamesInitNode(Virtualtrees::TBaseVirtualTree* Sender, Virtualtrees::PVirtualNode ParentNode, Virtualtrees::PVirtualNode Node, Virtualtrees::TVirtualNodeInitStates &InitialStates);
	void __fastcall VSTColumnNamesChecking(Virtualtrees::TBaseVirtualTree* Sender, Virtualtrees::PVirtualNode Node, Virtualtrees::TCheckState &NewState, bool &Allowed);
	void __fastcall VSTColumnNamesDragOver(Virtualtrees::TBaseVirtualTree* Sender, System::TObject* Source, System::Classes::TShiftState Shift, System::Uitypes::TDragState State, const System::Types::TPoint &Pt, Virtualtrees::TDropMode Mode, int &Effect, bool &Accept);
	void __fastcall VSTColumnNamesDragAllowed(Virtualtrees::TBaseVirtualTree* Sender, Virtualtrees::PVirtualNode Node, Virtualtrees::TColumnIndex Column, bool &Allowed);
	void __fastcall VSTColumnNamesDragDrop(Virtualtrees::TBaseVirtualTree* Sender, System::TObject* Source, _di_IDataObject DataObject, Virtualtrees::TFormatArray Formats, System::Classes::TShiftState Shift, const System::Types::TPoint &Pt, int &Effect, Virtualtrees::TDropMode Mode);
	void __fastcall EditPixelWidthKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall VSTColumnNamesFocusChanging(Virtualtrees::TBaseVirtualTree* Sender, Virtualtrees::PVirtualNode OldNode, Virtualtrees::PVirtualNode NewNode, Virtualtrees::TColumnIndex OldColumn, Virtualtrees::TColumnIndex NewColumn, bool &Allowed);
	void __fastcall EditPixelWidthExit(System::TObject* Sender);
	void __fastcall VSTColumnNamesFreeNode(Virtualtrees::TBaseVirtualTree* Sender, Virtualtrees::PVirtualNode Node);
	void __fastcall CheckBoxLiveUpdateClick(System::TObject* Sender);
	void __fastcall FormKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall FormResize(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall VSTColumnNamesGetText(Virtualtrees::TBaseVirtualTree* Sender, Virtualtrees::PVirtualNode Node, Virtualtrees::TColumnIndex Column, Virtualtrees::TVSTTextType TextType, System::UnicodeString &CellText);
	
private:
	Virtualtrees::TVirtualNode *FDragNode;
	TVETUpdate FOnVETUpdate;
	__property Virtualtrees::PVirtualNode DragNode = {read=FDragNode, write=FDragNode};
	
public:
	__property TVETUpdate OnVETUpdate = {read=FOnVETUpdate, write=FOnVETUpdate};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFormColumnSettings(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFormColumnSettings(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFormColumnSettings(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFormColumnSettings(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


typedef TColumnData *PColumnData;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TColumnData
{
public:
	System::WideString Title;
	bool Enabled;
	int Width;
	int ColumnIndex;
};
#pragma pack(pop)


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFormColumnSettings* FormColumnSettings;
}	/* namespace Columnform */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_COLUMNFORM)
using namespace Columnform;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ColumnformHPP
