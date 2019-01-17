// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'VirtualThumbnails.pas' rev: 32.00 (Windows)

#ifndef VirtualthumbnailsHPP
#define VirtualthumbnailsHPP

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
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Imaging.jpeg.hpp>
#include <MPShellUtilities.hpp>
#include <VirtualResources.hpp>
#include <MPShellTypes.hpp>
#include <MPCommonObjects.hpp>
#include <MPCommonUtilities.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Virtualthumbnails
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TExtensionsList;
class DELPHICLASS TThumbInfo;
class DELPHICLASS TThumbAlbum;
class DELPHICLASS TCustomThumbsManager;
class DELPHICLASS TThumbsManager;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TValidImageFileFormat : unsigned char { vffValid, vffInvalid, vffUnknown };

enum DECLSPEC_DENUM TThumbsAlbumStorage : unsigned char { tasRepository, tasPerFolder };

enum DECLSPEC_DENUM TThumbsAlignment : unsigned char { talNone, talCenter, talBottom };

class PASCALIMPLEMENTATION TExtensionsList : public System::Classes::TStringList
{
	typedef System::Classes::TStringList inherited;
	
private:
	System::Uitypes::TColor __fastcall GetColors(int Index);
	void __fastcall SetColors(int Index, const System::Uitypes::TColor Value);
	
public:
	__fastcall virtual TExtensionsList(void);
	HIDESBASE int __fastcall Add(const System::UnicodeString Extension, System::Uitypes::TColor HighlightColor);
	virtual int __fastcall AddObject(const System::UnicodeString S, System::TObject* AObject);
	virtual int __fastcall IndexOf(const System::UnicodeString S);
	virtual bool __fastcall DeleteString(const System::UnicodeString S);
	__property System::Uitypes::TColor Colors[int Index] = {read=GetColors, write=SetColors};
public:
	/* TStringList.Destroy */ inline __fastcall virtual ~TExtensionsList(void) { }
	
};


class PASCALIMPLEMENTATION TThumbInfo : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::WideString FComment;
	System::WideString FExif;
	System::WideString FFilename;
	System::TDateTime FFileDateTime;
	int FImageWidth;
	int FImageHeight;
	System::WideString FStreamSignature;
	int FTag;
	System::Classes::TMemoryStream* FThumbBitmapStream;
	bool FUseCompression;
	System::Types::TPoint __fastcall GetThumbSize(void);
	
protected:
	virtual System::WideString __fastcall DefaultStreamSignature(void);
	
public:
	__fastcall virtual TThumbInfo(void);
	__fastcall virtual ~TThumbInfo(void);
	virtual void __fastcall Assign(TThumbInfo* T);
	void __fastcall Draw(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, TThumbsAlignment Alignment, bool Stretch = false);
	void __fastcall Fill(System::WideString AFilename, System::WideString AExif, System::WideString AComment, System::TDateTime AFileDateTime, int AImageWidth, int AImageHeight, System::Classes::TMemoryStream* AThumbBitmapStream, int ATag);
	virtual bool __fastcall LoadFromStream(System::Classes::TStream* ST);
	virtual void __fastcall SaveToStream(System::Classes::TStream* ST);
	bool __fastcall ReadBitmap(Vcl::Graphics::TBitmap* OutBitmap);
	void __fastcall WriteBitmap(Vcl::Graphics::TBitmap* ABitmap);
	__property System::WideString Comment = {read=FComment, write=FComment};
	__property System::WideString Exif = {read=FExif, write=FExif};
	__property System::WideString Filename = {read=FFilename, write=FFilename};
	__property System::TDateTime FileDateTime = {read=FFileDateTime, write=FFileDateTime};
	__property int ImageWidth = {read=FImageWidth, write=FImageWidth, nodefault};
	__property int ImageHeight = {read=FImageHeight, write=FImageHeight, nodefault};
	__property System::WideString StreamSignature = {read=FStreamSignature};
	__property int Tag = {read=FTag, write=FTag, nodefault};
	__property System::Classes::TMemoryStream* ThumbBitmapStream = {read=FThumbBitmapStream, write=FThumbBitmapStream};
	__property System::Types::TPoint ThumbSize = {read=GetThumbSize};
	__property bool UseCompression = {read=FUseCompression, write=FUseCompression, nodefault};
};


class PASCALIMPLEMENTATION TThumbAlbum : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::WideString FDirectory;
	bool FLoadedFromFile;
	int FStreamVersion;
	int FSize;
	int FInvalidCount;
	int FThumbWidth;
	int FThumbHeight;
	System::Classes::TStringList* FComments;
	int __fastcall GetCount(void);
	
protected:
	System::Classes::TStringList* FHeaderFilelist;
	virtual int __fastcall DefaultStreamVersion(void);
	
public:
	__fastcall virtual TThumbAlbum(void);
	__fastcall virtual ~TThumbAlbum(void);
	void __fastcall Clear(void);
	int __fastcall IndexOf(System::WideString Filename);
	int __fastcall Add(TThumbInfo* T)/* overload */;
	void __fastcall Assign(TThumbAlbum* AThumbAlbum);
	void __fastcall Delete(int Index)/* overload */;
	void __fastcall Delete(System::WideString Filename)/* overload */;
	bool __fastcall Read(int Index, TThumbInfo* &OutThumbInfo)/* overload */;
	bool __fastcall Read(int Index, Vcl::Graphics::TBitmap* OutBitmap)/* overload */;
	void __fastcall LoadFromFile(const System::WideString Filename)/* overload */;
	void __fastcall LoadFromFile(const System::WideString Filename, System::Classes::TStringList* InvalidFiles)/* overload */;
	void __fastcall SaveToFile(const System::WideString Filename);
	__property System::WideString Directory = {read=FDirectory, write=FDirectory};
	__property int ThumbWidth = {read=FThumbWidth, write=FThumbWidth, nodefault};
	__property int ThumbHeight = {read=FThumbHeight, write=FThumbHeight, nodefault};
	__property System::Classes::TStringList* Comments = {read=FComments};
	__property int Count = {read=GetCount, nodefault};
	__property int InvalidCount = {read=FInvalidCount, nodefault};
	__property bool LoadedFromFile = {read=FLoadedFromFile, write=FLoadedFromFile, nodefault};
	__property int StreamVersion = {read=FStreamVersion, nodefault};
	__property int Size = {read=FSize, nodefault};
};


class PASCALIMPLEMENTATION TCustomThumbsManager : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FHideBorder;
	bool FHideCaption;
	TExtensionsList* FValidImageFormats;
	TExtensionsList* FInvalidImageFormats;
	TThumbsAlignment FAlignment;
	bool FAutoLoad;
	bool FAutoSave;
	bool FLoadAllAtOnce;
	int FMaxThumbHeight;
	int FMaxThumbWidth;
	bool FStorageCompressed;
	System::WideString FStorageFilename;
	System::WideString FStorageRepositoryFolder;
	TThumbsAlbumStorage FStorageType;
	bool FStretch;
	int FUpdateCount;
	bool FUseExifThumbnail;
	bool FUseExifOrientation;
	bool FUseFoldersShellExtraction;
	bool FUseShellExtraction;
	bool FUseSubsampling;
	bool __fastcall GetUpdating(void);
	void __fastcall SetStorageRepositoryFolder(const System::WideString Value);
	void __fastcall SetAlignment(const TThumbsAlignment Value);
	
protected:
	System::Classes::TComponent* FOwner;
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	virtual void __fastcall DoOptionsChanged(bool ResetThread, bool Invalidate);
	bool __fastcall GetAlbumList(System::Classes::TStringList* L);
	System::WideString __fastcall GetAlbumFileToLoad(System::WideString Dir);
	System::WideString __fastcall GetAlbumFileToSave(System::WideString Dir, bool AppendToAlbumList);
	virtual void __fastcall FillImageFormats(bool FillColors = true);
	__property TThumbsAlignment Alignment = {read=FAlignment, write=SetAlignment, default=1};
	__property bool AutoLoad = {read=FAutoLoad, write=FAutoLoad, default=0};
	__property bool AutoSave = {read=FAutoSave, write=FAutoSave, default=0};
	__property bool HideBorder = {read=FHideBorder, write=FHideBorder, default=1};
	__property bool HideCaption = {read=FHideCaption, write=FHideCaption, default=0};
	__property bool LoadAllAtOnce = {read=FLoadAllAtOnce, write=FLoadAllAtOnce, default=0};
	__property int MaxThumbHeight = {read=FMaxThumbHeight, write=FMaxThumbHeight, default=0};
	__property int MaxThumbWidth = {read=FMaxThumbWidth, write=FMaxThumbWidth, default=0};
	__property bool StorageCompressed = {read=FStorageCompressed, write=FStorageCompressed, default=0};
	__property System::WideString StorageFilename = {read=FStorageFilename, write=FStorageFilename};
	__property System::WideString StorageRepositoryFolder = {read=FStorageRepositoryFolder, write=SetStorageRepositoryFolder};
	__property TThumbsAlbumStorage StorageType = {read=FStorageType, write=FStorageType, default=0};
	__property bool Stretch = {read=FStretch, write=FStretch, default=0};
	__property bool UseExifThumbnail = {read=FUseExifThumbnail, write=FUseExifThumbnail, default=1};
	__property bool UseExifOrientation = {read=FUseExifOrientation, write=FUseExifOrientation, default=1};
	__property bool UseFoldersShellExtraction = {read=FUseFoldersShellExtraction, write=FUseFoldersShellExtraction, default=1};
	__property bool UseShellExtraction = {read=FUseShellExtraction, write=FUseShellExtraction, default=1};
	__property bool UseSubsampling = {read=FUseSubsampling, write=FUseSubsampling, default=1};
	
public:
	__fastcall virtual TCustomThumbsManager(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TCustomThumbsManager(void);
	TValidImageFileFormat __fastcall IsValidImageFileFormat(Mpshellutilities::TNamespace* NS);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual void __fastcall LoadAlbum(bool Force = false) = 0 ;
	virtual void __fastcall SaveAlbum(void) = 0 ;
	__property bool Updating = {read=GetUpdating, nodefault};
	__property TExtensionsList* ValidImageFormats = {read=FValidImageFormats};
	__property TExtensionsList* InvalidImageFormats = {read=FInvalidImageFormats};
};


class PASCALIMPLEMENTATION TThumbsManager : public TCustomThumbsManager
{
	typedef TCustomThumbsManager inherited;
	
__published:
	__property Alignment = {default=1};
	__property AutoLoad = {default=0};
	__property AutoSave = {default=0};
	__property HideCaption = {default=0};
	__property LoadAllAtOnce = {default=0};
	__property MaxThumbHeight = {default=0};
	__property MaxThumbWidth = {default=0};
	__property StorageCompressed = {default=0};
	__property StorageFilename = {default=0};
	__property StorageRepositoryFolder = {default=0};
	__property StorageType = {default=0};
	__property Stretch = {default=0};
	__property UseExifOrientation = {default=1};
	__property UseExifThumbnail = {default=1};
	__property UseFoldersShellExtraction = {default=1};
	__property UseShellExtraction = {default=1};
	__property UseSubsampling = {default=1};
public:
	/* TCustomThumbsManager.Create */ inline __fastcall virtual TThumbsManager(System::Classes::TComponent* AOwner) : TCustomThumbsManager(AOwner) { }
	/* TCustomThumbsManager.Destroy */ inline __fastcall virtual ~TThumbsManager(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall SpInitBitmap(Vcl::Graphics::TBitmap* OutB, int W, int H, System::Uitypes::TColor BackgroundColor);
extern DELPHI_PACKAGE System::Types::TRect __fastcall SpRectAspectRatio(int ImageW, int ImageH, int ThumbW, int ThumbH, TThumbsAlignment Alignment, bool AllowEnlarge = false);
extern DELPHI_PACKAGE bool __fastcall SpIsIncompleteJPGError(System::Sysutils::Exception* E);
extern DELPHI_PACKAGE Vcl::Graphics::TGraphicClass __fastcall SpGetGraphicClass(System::WideString Filename);
extern DELPHI_PACKAGE bool __fastcall SpLoadGraphicFile(System::WideString Filename, Vcl::Graphics::TPicture* outP, bool CatchIncompleteJPGErrors = true);
extern DELPHI_PACKAGE void __fastcall SpPixelRotate(Vcl::Graphics::TBitmap* InOutB, int Angle);
extern DELPHI_PACKAGE void __fastcall SpStretchDraw(Vcl::Graphics::TGraphic* G, Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &DestR, bool UseSubsampling);
extern DELPHI_PACKAGE bool __fastcall SpMakeThumbFromFile(System::WideString Filename, Vcl::Graphics::TBitmap* OutBitmap, int ThumbW, int ThumbH, System::Uitypes::TColor BgColor, bool SubSampling, bool ExifThumbnail, bool ExifOrientation, int &ImageWidth, int &ImageHeight);
extern DELPHI_PACKAGE TThumbInfo* __fastcall SpCreateThumbInfoFromFile(Mpshellutilities::TNamespace* NS, int ThumbW, int ThumbH, bool UseSubsampling, bool UseShellExtraction, bool UseExifThumbnail, bool UseExifOrientation, System::Uitypes::TColor BackgroundColor);
extern DELPHI_PACKAGE Vcl::Imaging::Jpeg::TJPEGImage* __fastcall SpReadExifThumbnail(System::WideString FileName, System::Classes::TStringList* Exif);
extern DELPHI_PACKAGE System::TDateTime __fastcall SpReadDateTimeFromStream(System::Classes::TStream* ST);
extern DELPHI_PACKAGE void __fastcall SpWriteDateTimeToStream(System::Classes::TStream* ST, System::TDateTime D);
extern DELPHI_PACKAGE int __fastcall SpReadIntegerFromStream(System::Classes::TStream* ST);
extern DELPHI_PACKAGE void __fastcall SpWriteIntegerToStream(System::Classes::TStream* ST, int I);
extern DELPHI_PACKAGE System::WideString __fastcall SpReadWideStringFromStream(System::Classes::TStream* ST);
extern DELPHI_PACKAGE void __fastcall SpWriteWideStringToStream(System::Classes::TStream* ST, System::WideString WS);
extern DELPHI_PACKAGE bool __fastcall SpReadMemoryStreamFromStream(System::Classes::TStream* ST, System::Classes::TMemoryStream* MS);
extern DELPHI_PACKAGE void __fastcall SpWriteMemoryStreamToStream(System::Classes::TStream* ST, System::Classes::TMemoryStream* MS);
extern DELPHI_PACKAGE bool __fastcall SpReadBitmapFromStream(System::Classes::TStream* ST, Vcl::Graphics::TBitmap* B);
extern DELPHI_PACKAGE void __fastcall SpWriteBitmapToStream(System::Classes::TStream* ST, Vcl::Graphics::TBitmap* B);
extern DELPHI_PACKAGE void __fastcall SpConvertBitmapStreamToJPGStream(System::Classes::TMemoryStream* MS, Vcl::Imaging::Jpeg::TJPEGQualityRange CompressionQuality = (Vcl::Imaging::Jpeg::TJPEGQualityRange)(0x5a));
extern DELPHI_PACKAGE void __fastcall SpConvertJPGStreamToBitmapStream(System::Classes::TMemoryStream* MS);
extern DELPHI_PACKAGE void __fastcall SpConvertJPGStreamToBitmap(System::Classes::TMemoryStream* MS, Vcl::Graphics::TBitmap* OutBitmap);
}	/* namespace Virtualthumbnails */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VIRTUALTHUMBNAILS)
using namespace Virtualthumbnails;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// VirtualthumbnailsHPP
