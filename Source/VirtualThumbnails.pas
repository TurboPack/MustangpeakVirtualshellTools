unit VirtualThumbnails;

{==============================================================================
// Version 2.4.0


Software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
either express or implied.
The initial developer of this code is Robert Lee.

Requirements:
  - Jim Kuenaman's Mustangpeak Common Library
    http://www.mustangpeak.net
    http://www.tntware.com/delphicontrols/unicode/

Credits:
  Special thanks to Mike Lischke (VT) and Jim Kuenaman (VSTools) for the
  magnificent components they made available to the Delphi community.
  Thanks to (in alphabetical order):
    Aaron, Adem Baba (ImageMagick conversion), Nils Haeck (ImageMagick wrapper),
    Gerald Köder (bugs hunter), Werner Lehmann (Thumbs Cache),
    Bill Miller (HyperVirtualExplorer), Uwe Molzahn (ImageEn bugs hunter),
    Renate Schaaf (Graphics guru), Boris Tadjikov (bugs hunter),
    Milan Vandrovec (CBuilder port), Philip Wand, Troy Wolbrink (Unicode support).

Development notes:
  - Bug in Delphi 5 TGraphic class: when creating a bitmap by using its class
    type (TGraphicClass) it doesn't calls the TBitmap constructor.
    That's because in Delphi 5 the TGraphic.Create is protected, and
    TBitmap.Create is public, so TGraphicClass(ABitmap).Create will NOT call
    TBitmap.Create because it's not visible by TGraphicClass.
    To fix this we need to make it visible by creating a TGraphicClass cracker.
    Fixed in LoadGraphic helper.
    More info on:
    http://groups.google.com/groups?hl=en&lr=&ie=UTF-8&selm=VA.00000331.0164178b%40xmission.com

To Do
  -

History:
7 August 2006 - version 1.0
  - Initial release.

==============================================================================}

interface

{$include ..\Include\Addins.inc}
{$BOOLEVAL OFF} // Unit depends on short-circuit boolean evaluation

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  ComCtrls,
  ImgList,
  Dialogs,
  Forms,
  Jpeg,
  MPShellUtilities,
  VirtualResources,
  MPShellTypes,
  MPCommonObjects,
  MPCommonUtilities;

type
  TValidImageFileFormat = (
    vffValid,      // Valid image file format
    vffInvalid,    // Invalid image file format
    vffUnknown     // Unknown image file format, flag for shell extraction
  );

  TThumbsAlbumStorage = (
    tasRepository, // Store album on a central repository
    tasPerFolder   // Store album on the current folder
  );

  TThumbsAlignment = (
    talNone,       // No aligned
    talCenter,     // Centered
    talBottom      // Bottom aligned
  );

  TExtensionsList = class(TStringList)
  private
    function GetColors(Index: Integer): TColor;
    procedure SetColors(Index: Integer; const Value: TColor);
  public
    constructor Create; virtual;
    function Add(const Extension: string; HighlightColor: TColor): Integer; reintroduce;
    function AddObject(const S: string; AObject: TObject): Integer; override;
    function IndexOf(const S: string): Integer; override;
    function DeleteString(const S: string): Boolean; virtual;
    property Colors[Index: Integer]: TColor read GetColors write SetColors;
  end;

  TThumbInfo = class
  private
    FComment: string;
    FExif: string;
    FFilename: string;
    FFileDateTime: TDateTime;
    FImageWidth: Integer;
    FImageHeight: Integer;
    FStreamSignature: string;
    FTag: Integer;
    FThumbBitmapStream: TMemoryStream;
    FUseCompression: Boolean;
    function GetThumbSize: TPoint;
  protected
    function DefaultStreamSignature: string; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Assign(T: TThumbInfo); virtual;
    procedure Draw(ACanvas: TCanvas; ARect: TRect; Alignment: TThumbsAlignment; Stretch: Boolean = False);
    procedure Fill(AFilename, AExif, AComment: string;
      AFileDateTime: TDateTime; AImageWidth, AImageHeight: Integer;
      AThumbBitmapStream: TMemoryStream; ATag: Integer);
    function LoadFromStream(ST: TStream): Boolean; virtual;
    procedure SaveToStream(ST: TStream); virtual;
    function ReadBitmap(AOutBitmap: TBitmap): Boolean;
    procedure WriteBitmap(ABitmap: TBitmap);
    property Comment: string read FComment write FComment;
    property Exif: string read FExif write FExif;
    property Filename: string read FFilename write FFilename;
    property FileDateTime: TDateTime read FFileDateTime write FFileDateTime;
    property ImageWidth: Integer read FImageWidth write FImageWidth;
    property ImageHeight: Integer read FImageHeight write FImageHeight;
    property StreamSignature: string read FStreamSignature;
    property Tag: Integer read FTag write FTag;
    property ThumbBitmapStream: TMemoryStream read FThumbBitmapStream;
    property ThumbSize: TPoint read GetThumbSize;
    property UseCompression: Boolean read FUseCompression write FUseCompression;
  end;

  TThumbAlbum = class
  private
    FDirectory: string;
    FLoadedFromFile: Boolean;
    FStreamVersion: Integer;
    FSize: Integer;
    FInvalidCount: Integer;
    FThumbWidth: Integer;
    FThumbHeight: Integer;
    FComments:  TStringList;
    function GetCount: Integer;
  protected
    FHeaderFilelist: TStringList; // OwnsObjects
    function DefaultStreamVersion: Integer; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    function IndexOf(Filename: string): Integer;
    function Add(T: TThumbInfo): Integer; overload;
    procedure Assign(AThumbAlbum: TThumbAlbum);
    procedure Delete(Index: Integer); overload;
    procedure Delete(Filename: string); overload;
    function Read(Index: Integer; var OutThumbInfo: TThumbInfo): Boolean; overload;
    function Read(Index: Integer; OutBitmap: TBitmap): Boolean; overload;
    procedure LoadFromFile(const Filename: string); overload;
    procedure LoadFromFile(const Filename: string; InvalidFiles: TStringList); overload;
    procedure SaveToFile(const Filename: string);
    property Directory: string read FDirectory write FDirectory;
    property ThumbWidth: Integer read FThumbWidth write FThumbWidth;
    property ThumbHeight: Integer read FThumbHeight write FThumbHeight;
    property Comments: TStringList read FComments;
    property Count: Integer read GetCount;  // Count includes the deleted thumbs, ValidCount = Count - InvalidCount
    property InvalidCount: Integer read FInvalidCount;
    property LoadedFromFile: Boolean read FLoadedFromFile write FLoadedFromFile;
    property StreamVersion: Integer read FStreamVersion;
    property Size: Integer read FSize;
  end;

  TCustomThumbsManager = class(TPersistent)
  private
    FHideBorder: Boolean;
    FHideCaption: Boolean;
    FValidImageFormats: TExtensionsList;
    FInvalidImageFormats: TExtensionsList;
    FAlignment: TThumbsAlignment;
    FAutoLoad: Boolean;
    FAutoSave: Boolean;
    FLoadAllAtOnce: Boolean;
    FMaxThumbHeight: Integer;
    FMaxThumbWidth: Integer;
    FStorageCompressed: Boolean;
    FStorageFilename: string;
    FStorageRepositoryFolder: string;
    FStorageType: TThumbsAlbumStorage;
    FStretch: Boolean;
    FUpdateCount: Integer;
    FUseExifThumbnail: Boolean;
    FUseExifOrientation: Boolean;
    FUseFoldersShellExtraction: Boolean;
    FUseShellExtraction: Boolean;
    FUseSubsampling: Boolean;
    function GetUpdating: Boolean;
    procedure SetStorageRepositoryFolder(const Value: string);
    procedure SetAlignment(const Value: TThumbsAlignment);
  protected
    FOwner: TComponent;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure DoOptionsChanged(ResetThread, Invalidate: Boolean); virtual;
    function GetAlbumList(L: TStringList): Boolean;
    function GetAlbumFileToLoad(Dir: string): string;
    function GetAlbumFileToSave(Dir: string; AppendToAlbumList: Boolean): string;
    procedure FillImageFormats(FillColors: Boolean = True); virtual;
    property Alignment: TThumbsAlignment read FAlignment write SetAlignment default talCenter;
    property AutoLoad: Boolean read FAutoLoad write FAutoLoad default False;
    property AutoSave: Boolean read FAutoSave write FAutoSave default False;
    property HideBorder: Boolean read FHideBorder write FHideBorder default True;
    property HideCaption: Boolean read FHideCaption write FHideCaption default False;
    property LoadAllAtOnce: Boolean read FLoadAllAtOnce write FLoadAllAtOnce default False;
    property MaxThumbHeight: Integer read FMaxThumbHeight write FMaxThumbHeight default 0;
    property MaxThumbWidth: Integer read FMaxThumbWidth write FMaxThumbWidth default 0;
    property StorageCompressed: Boolean read FStorageCompressed write FStorageCompressed default False;
    property StorageFilename: string read FStorageFilename write FStorageFilename;
    property StorageRepositoryFolder: string read FStorageRepositoryFolder write SetStorageRepositoryFolder;
    property StorageType: TThumbsAlbumStorage read FStorageType write FStorageType default tasRepository;
    property Stretch: Boolean read FStretch write FStretch default False;
    property UseExifThumbnail: Boolean read FUseExifThumbnail write FUseExifThumbnail default True;
    property UseExifOrientation: Boolean read FUseExifOrientation write FUseExifOrientation default True;
    property UseFoldersShellExtraction: Boolean read FUseFoldersShellExtraction write FUseFoldersShellExtraction default True;
    property UseShellExtraction: Boolean read FUseShellExtraction write FUseShellExtraction default True;
    property UseSubsampling: Boolean read FUseSubsampling write FUseSubsampling default True;
  public
    constructor Create(AOwner: TComponent); virtual;
    destructor Destroy; override;
    function IsValidImageFileFormat(NS: TNamespace): TValidImageFileFormat;
    procedure Assign(Source: TPersistent); override;
    procedure LoadAlbum(Force: Boolean = False); virtual; abstract;
    procedure SaveAlbum; virtual; abstract;
    property Updating: Boolean read GetUpdating;
    property ValidImageFormats: TExtensionsList read FValidImageFormats;
    property InvalidImageFormats: TExtensionsList read FInvalidImageFormats;
  end;

  TThumbsManager = class(TCustomThumbsManager)
  published
    property Alignment;
    property AutoLoad;
    property AutoSave;
    property HideCaption;
    property LoadAllAtOnce;
    property MaxThumbHeight;
    property MaxThumbWidth;
    property StorageCompressed;
    property StorageFilename;
    property StorageRepositoryFolder;
    property StorageType;
    property Stretch;
    property UseExifOrientation;
    property UseExifThumbnail;
    property UseFoldersShellExtraction;
    property UseShellExtraction;
    property UseSubsampling;
  end;

{ Image manipulation helpers }
procedure SpInitBitmap(OutB: TBitmap; W, H: Integer; BackgroundColor: TColor);
function SpRectAspectRatio(ImageW, ImageH, ThumbW, ThumbH: Integer; Alignment: TThumbsAlignment; AllowEnlarge: Boolean = False): TRect;
function SpIsIncompleteJPGError(E: Exception): Boolean;
function SpGetGraphicClass(Filename: string): TGraphicClass;
function SpLoadGraphicFile(Filename: string; outP: TPicture; CatchIncompleteJPGErrors: Boolean = True): Boolean;
procedure SpPixelRotate(const AInOutB: TBitmap; const AAngle: Integer);
procedure SpStretchDraw(G: TGraphic; ACanvas: TCanvas; DestR: TRect; UseSubsampling: Boolean);
{$IFDEF USEIMAGEEN}
function SpMakeThumbFromFileImageEn(Filename: string; OutBitmap: TBitmap; ThumbW, ThumbH: Integer;
  BgColor: TColor; Subsampling, ExifThumbnail, ExifOrientation: Boolean; var ImageWidth, ImageHeight: Integer): Boolean;
{$ENDIF}
function SpMakeThumbFromFile(const AFileName: string; const AOutBitmap: TBitmap; const AThumbW, AThumbH: Integer; const ABgColor: TColor; const ASubSampling, AExifThumbnail, AExifOrientation: Boolean; var AImageWidth, AImageHeight: Integer): Boolean;
function SpCreateThumbInfoFromFile(ANamespace: TNamespace; AThumbW, AThumbH: Integer; AUseSubsampling, AUseShellExtraction, AUseExifThumbnail, AUseExifOrientation: Boolean; ABackgroundColor: TColor): TThumbInfo;
function SpReadExifThumbnail(const AFileName: string; const AExif: TStringList): TJpegImage;

{ Stream helpers }
function SpReadDateTimeFromStream(ST: TStream): TDateTime;
procedure SpWriteDateTimeToStream(ST: TStream; D: TDateTime);
function SpReadIntegerFromStream(ST: TStream): Integer;
procedure SpWriteIntegerToStream(ST: TStream; I: Integer);
function SpReadUnicodeStringFromStream(ST: TStream): string;
procedure SpWriteUnicodeStringToStream(ST: TStream; WS: string);
function SpReadMemoryStreamFromStream(const AStream: TStream; AMemoryStream: TMemoryStream): Boolean;
procedure SpWriteMemoryStreamToStream(const AStream: TStream; AMemoryStream: TMemoryStream);
function SpReadBitmapFromStream(ST: TStream; B: TBitmap): Boolean;
procedure SpWriteBitmapToStream(ST: TStream; B: TBitmap);
procedure SpConvertBitmapStreamToJPGStream(MS: TMemoryStream; CompressionQuality: TJPEGQualityRange = 90);
procedure SpConvertJPGStreamToBitmapStream(const AStream: TMemoryStream);
procedure SpConvertJPGStreamToBitmap(MS: TMemoryStream; OutBitmap: TBitmap);

implementation

uses
  System.Types, System.Math, System.IOUtils
{$IFDEF USEIMAGEEN}, ImageEnIo, ImageEnProc, hyieutils, iexBitmaps, iexHelperFunctions{$ENDIF};

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Image manipulation helpers }

function GetCrwOrientation(AStream: TStream): Integer;
// Canon CRW files doesn't have Exif, they are stored in CIFF format:
//   http://www.sno.phy.queensu.ca/~phil/exiftool/canon_raw.html
//   http://www.sno.phy.queensu.ca/~phil/exiftool/
// Exif extractor:
//   http://regex.info/exif.cgi
// Raw samples:
//   http://raw.fotosite.pl/
//   http://www.glasslantern.com/RAWpository/

  procedure ReadDir(AStream: TStream; AStart, ALength, ATagID: Integer; var AOrientation: Integer);
  var
    i,
    iDirStart,
    iEntrySize,
    iEntryOffset: Integer;
    wDirCount,
    wEntryTag: Word;
    lwValue: Longword;
    iOldPos: Int64;
    iDataLocation,
    iDataFormat,
    iTagIdx,
    iTagID: Integer;
  begin
    iOldPos := AStream.Position;
    try
      case ATagID of
        0,
        $2804,
        $2807,
        $3002,
        $3003,
        $3004,
        $300a,
        $300b:
          begin
            AStream.Seek(AStart+ALength-4, soFromBeginning);
            AStream.ReadBuffer(iDirStart, SizeOf(iDirStart));
            AStream.Seek(AStart+iDirStart, soFromBeginning);
            AStream.ReadBuffer(wDirCount, SizeOf(wDirCount));
            for i := 0 to wDirCount-1 do
            begin
              AStream.ReadBuffer(wEntryTag, SizeOf(wEntryTag));
              iDataLocation := wEntryTag and $c000;
              iDataFormat := wEntryTag and $3800;
              iTagIdx := wEntryTag and $7ff;
              iTagID := iDataFormat+iTagIdx;

              AStream.ReadBuffer(iEntrySize, SizeOf(iEntrySize));
              AStream.ReadBuffer(iEntryOffset, SizeOf(iEntryOffset));

              if iDataLocation = 0 then
                ReadDir(AStream, AStart+iEntryOffset, iEntrySize, iTagID, AOrientation);
              if AOrientation >= 0 then
                exit;
            end;
          end;
        $1810:
          begin
            AStream.Seek(AStart+12, soFromBeginning);
            AStream.ReadBuffer(lwValue, Sizeof(lwValue));
            AOrientation := lwValue;
          end;
      end;
    finally
      AStream.Position := iOldPos;
    end;
  end;
var
  wAlign: Word;
  iSize,
  acSignature: array[0..20] of char;
begin
  Result := -1;
  try
    AStream.Position := 0;
    AStream.ReadBuffer(wAlign, Sizeof(wAlign));
    AStream.ReadBuffer(iSize, Sizeof(iSize));
    AStream.ReadBuffer(acSignature, 8);
    ReadDir(AStream, 26, AStream.Size-26, 0, Result);
    if Result = 270 then
      Result := 8
    else if Result = 90 then
      Result := 6;
  except
  end;
end;

procedure SpInitBitmap(OutB: TBitmap; W, H: Integer; BackgroundColor: TColor);
begin
  OutB.Width := W;
  OutB.Height := H;
  OutB.Canvas.Brush.Color := BackgroundColor;
  OutB.Canvas.Fillrect(Rect(0, 0, W, H));
end;

function SpRectAspectRatio(ImageW, ImageH, ThumbW, ThumbH: Integer;
  Alignment: TThumbsAlignment; AllowEnlarge: Boolean = False): TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if (ImageW < 1) or (ImageH < 1) then Exit;

  if not AllowEnlarge and (ImageW <= ThumbW) and (ImageH <= ThumbH) then begin
    Result.Right := ImageW;
    Result.Bottom := ImageH;
  end
  else begin
    Result.Right := (ThumbH * ImageW) div ImageH;
    if (Result.Right <= ThumbW) then Result.Bottom := ThumbH
    else begin
      Result.Right := ThumbW;
      Result.Bottom := (ThumbW * ImageH) div ImageW;
    end;
  end;

  case Alignment of
    talCenter:
      OffsetRect(Result, (ThumbW - Result.Right) div 2, (ThumbH - Result.Bottom) div 2);
    talBottom:
      OffsetRect(Result, (ThumbW - Result.Right) div 2, ThumbH - Result.Bottom);
  end;

  // TJPEGImage doesn't accepts images with 1 pixel width or height
  // http://qc.codegear.com/wc/qcmain.aspx?d=3441
  if Result.Right <= 1 then Result.Right := 2;
  if Result.Bottom <= 1 then Result.Bottom := 2;
end;

function SpIsIncompleteJPGError(E: Exception): Boolean;
var
  S: string;
begin
  S := E.Message;
  Result := (S = 'JPEG error #68') or
            (S = 'JPEG error #67') or
            (S = 'JPEG error #60') or
            (S = 'JPEG error #57');
end;

function SpGetGraphicClass(Filename: string): TGraphicClass;
var
  Ext: string;
begin
  Ext := SysUtils.AnsiLowerCase(WideExtractFileExt(Filename));
  Delete(Ext, 1, 1);

  Result := nil;
  if (Ext = 'jpg') or (Ext = 'jpeg') or (Ext = 'jif') then Result := TJpegImage
  else if Ext = 'bmp' then Result := TBitmap
  else if (Ext = 'wmf') or (Ext = 'emf') then Result := TMetafile
  else if Ext = 'ico' then Result := TIcon;
end;

// Bug in Delphi 5:
// When creating a bitmap by using its class type (TGraphicClass) it doesn't calls
// the TBitmap constructor.
// That's because in Delphi 5 the TGraphic.Create is protected, and TBitmap.Create
// is public, so TGraphicClass(ABitmap).Create will NOT call TBitmap.Create because
// it's not visible by TGraphicClass.
// To fix this we need to make it visible by creating a TGraphicClass cracker.
// More info on:
// http://groups.google.com/groups?hl=en&lr=&ie=UTF-8&selm=VA.00000331.0164178b%40xmission.com
type
  TFixedGraphic = class(TGraphic);
  TFixedGraphicClass = class of TFixedGraphic;

function SpLoadGraphicFile(Filename: string; outP: TPicture; CatchIncompleteJPGErrors: Boolean = True): Boolean;
// Loads an image file with a unicode name
// If CatchIncompleteJPGErrors = True it tries to see if the image
// is an incomplete jpeg image file.
var
  NewGraphic: TGraphic;
  GraphicClass: TGraphicClass;
  F: TVirtualFileStream;
  J: TJpegImage;
begin
  Result := False;

  GraphicClass := SpGetGraphicClass(Filename);
  try
    if GraphicClass = nil then
      outP.LoadFromFile(Filename)
    else begin
      F := TVirtualFileStream.Create(Filename, fmOpenRead or fmShareDenyNone);
      try
        NewGraphic := TFixedGraphicClass(GraphicClass).Create;
        try
          NewGraphic.LoadFromStream(F);
          outP.Graphic := NewGraphic;
        finally
          NewGraphic.Free;
        end;
      finally
        F.Free;
      end;
    end;
    if CatchIncompleteJPGErrors and (OutP.Graphic is TJpegImage) then begin
      J := TJpegImage(OutP.Graphic);
      J.DIBNeeded; // Load the JPG
    end;
    Result := True;
  except
    on E:Exception do
      if not SpIsIncompleteJPGError(E) then
        raise;
  end;
end;

procedure SpPixelRotate(const AInOutB: TBitmap; const AAngle: Integer);
// Performs a clockwise rotation
var
  lBitmap: TBitmap;
  lCol: Integer;
  lDestHeight: Integer;
  lDestWidth: Integer;
  lOrigHeight: Integer;
  lOrigWidth: Integer;
  lRow: Integer;
begin
  if not Assigned(AInOutB) or AInOutB.Empty then
    Exit;

  lOrigWidth := AInOutB.Width;
  lOrigHeight := AInOutB.Height;
  case AAngle of
    90:  begin
           // Horizontal
           lDestWidth := lOrigHeight;
           lDestHeight := lOrigWidth;
         end;
    180: begin
           // Vertical
           lDestWidth := lOrigWidth;
           lDestHeight := lOrigHeight;
         end;
    270: begin
           // Horizontal
           lDestWidth := lOrigHeight;
           lDestHeight := lOrigWidth;
         end;
  else
    Exit;
  end;

  lBitmap := TBitmap.Create;
  try
    lBitmap.Width := lDestWidth;
    lBitmap.Height := lDestHeight;
    lBitmap.Canvas.Lock;
    try
    for lRow := 0 to lOrigWidth - 1 do
    begin
      for lCol := 0 to lOrigHeight - 1 do
      begin
        case AAngle of
          90: lBitmap.Canvas.Pixels[lOrigHeight - lCol - 1, lRow] := AInOutB.Canvas.Pixels[lRow, lCol];
          180: lBitmap.Canvas.Pixels[lOrigWidth - lRow - 1, lOrigHeight - lCol - 1] := AInOutB.Canvas.Pixels[lRow, lCol];
          270:  lBitmap.Canvas.Pixels[lCol, lOrigWidth - lRow - 1] := AInOutB.Canvas.Pixels[lRow, lCol];
        end;
      end;
    end;

    finally
      lBitmap.Canvas.Unlock;
    end;
    AInOutB.Assign(lBitmap);
  finally
    lBitmap.Free;
  end;
end;

procedure SpStretchDraw(G: TGraphic; ACanvas: TCanvas; DestR: TRect;
  UseSubsampling: Boolean);
// Canvas.StretchDraw is NOT THREADSAFE!!!
// Use StretchBlt instead, we have to use a worker bitmap
// Transparent painting is not supported
var
  Work: TBitmap;
begin
  if (G.Width <> RectWidth(DestR)) or (G.Height <> RectHeight(DestR)) then begin
    // Stretch the graphic using StretchBlt
    Work := TBitmap.Create;
    Work.Canvas.Lock;
    try
      // Paint the Picture in Work
      if (G is TJpegImage) or (G is TBitmap) then
        Work.Assign(G) // Assign works in this case
      else begin
        Work.Width := G.Width;
        Work.Height := G.Height;
        Work.PixelFormat := pf32Bit;
        Work.Canvas.Draw(0, 0, G);
      end;

      if UseSubsampling then
      begin
        SetStretchBltMode(ACanvas.Handle, STRETCH_HALFTONE);
        SetBrushOrgEx(ACanvas.Handle, 0, 0, nil);
      end else
        SetStretchBltMode(ACanvas.Handle, STRETCH_DELETESCANS);

      StretchBlt(ACanvas.Handle,
        DestR.Left, DestR.Top, DestR.Right - DestR.Left, DestR.Bottom - DestR.Top,
        Work.Canvas.Handle, 0, 0, G.Width, G.Height, SRCCopy);
    finally
      Work.Canvas.Unlock;
      Work.Free;
    end;
  end
  else begin
    // No stretch needed, just draw the graphic
    ACanvas.Draw(DestR.Left, DestR.Top, G);
  end;
end;

{$IFDEF USEIMAGEEN}
function SpMakeThumbFromFileImageEn(Filename: string; OutBitmap: TBitmap;
  ThumbW, ThumbH: Integer; BgColor: TColor; Subsampling, ExifThumbnail, ExifOrientation: Boolean;
  var ImageWidth, ImageHeight: Integer): Boolean;
var
  AttachedIEBitmap: TIEBitmap;
  ImageEnIO: TImageEnIO;
  ImageEnProc: TImageEnProc;
  TempBitmap: TBitmap;
  F: TVirtualFileStream;
  DestR: TRect;
  Ext: string;
  IsRaw, IsVideo: Boolean;
  Orientation: Integer;
begin
  Result := False;
  ImageWidth := 0;
  ImageHeight := 0;
  Orientation := 0;
  if not Assigned(OutBitmap) then Exit;
  Ext := WideLowerCase(ExtractFileExt(Filename));

  IsRaw := (ext = '.crw') or (ext = '.cr2') or (ext = '.dng')
        or (ext = '.nef') or (ext = '.raw') or (ext = '.raf')
        or (ext = '.x3f') or (ext = '.orf') or (ext = '.srf')
        or (ext = '.mrw') or (ext = '.dcr') or (ext = '.bay')
        or (ext = '.pef') or (ext = '.sr2') or (ext = '.arw')
        or (ext = '.kdc') or (ext = '.mef') or (ext = '.3fr')
        or (ext = '.k25') or (ext = '.erf') or (ext = '.cam')
        or (ext = '.cs1') or (ext = '.dc2') or (ext = '.dcs')
        or (ext = '.fff') or (ext = '.mdc') or (ext = '.mos')
        or (ext = '.nrw') or (ext = '.ptx') or (ext = '.pxn')
        or (ext = '.rdc') or (ext = '.rw2') or (ext = '.rwl')
        or (ext = '.iiq') or (ext = '.srw');

  IsVideo := (ext = '.avi') or (ext = '.mpg') or (ext = '.mpeg') or (ext = '.wmv');

  TempBitmap := TBitmap.Create;
  TempBitmap.Canvas.Lock;
  try
    AttachedIEBitmap := TIEBitmap.Create;
    ImageEnIO := TImageEnIO.Create(nil);
    ImageEnProc := TImageEnProc.Create(Nil);
    try
      ImageEnIO.AttachedIEBitmap := AttachedIEBitmap;
      ImageEnProc.AttachedIEBitmap := AttachedIEBitmap;
      ImageEnIO.Params.Width := ThumbW;
      ImageEnIO.Params.Height := ThumbH;
      ImageEnIO.Params.JPEG_Scale := ioJPEG_AUTOCALC;
      ImageEnIO.Params.JPEG_DCTMethod := ioJPEG_IFAST;
      ImageEnIO.Params.EnableAdjustOrientation := ExifOrientation;
      // ImageEn bug: TImageEnIO.LoadFromStream doesn't work with wmf/emf/sun files
      if (Ext = '.wmf') or (Ext = '.emf') or (Ext = '.sun') then
      begin
        ImageEnIO.LoadFromFile(Filename);
        ImageWidth := ImageEnIO.Params.Width;
        ImageHeight := ImageEnIO.Params.Height;
        AttachedIEBitmap.CopyToTBitmap(TempBitmap);
      end;
      if IsVideo then
      begin
        ImageEnIO.OpenMediaFile(Filename);
        ImageEnIO.LoadFromMediaFile(5);
        ImageWidth := ImageEnIO.Params.Width;
        ImageHeight := ImageEnIO.Params.Height;
        AttachedIEBitmap.CopyToTBitmap(TempBitmap);
        ImageEnIO.CloseMediaFile;
      end
      else
      begin
        F := TVirtualFileStream.Create(Filename, fmOpenRead or fmShareDenyNone);
        try
          if IsRaw then
          begin
            ImageEnIO.Params.GetThumbnail := True;
            ImageEnIO.LoadFromStreamRAW(F);
            if ExifOrientation then
              if (ext = '.crw') then
                Orientation := GetCrwOrientation(F) // CRW doesn't have Exif, read the CIFF data
              else
                Orientation := ImageEnIO.Params.EXIF_Orientation;
            if (Orientation = 6) or (Orientation = 8) then
              IEAdjustEXIFOrientation(AttachedIEBitmap, Orientation);
            ImageWidth := AttachedIEBitmap.Width;
            ImageHeight := AttachedIEBitmap.Height;
          end
          else
          // If it's not a digital camera RAW file
          begin
            ImageEnIO.Params.GetThumbnail := ExifThumbnail;
            ImageEnIO.LoadFromStream(F);
            if ImageEnIO.Params.JPEG_Scale_Used > 1 then
            begin
              ImageWidth := AttachedIEBitmap.Width;
              ImageHeight := AttachedIEBitmap.Height;
            end
            else
            begin
              ImageWidth := ImageEnIO.Params.Width;
              ImageHeight := ImageEnIO.Params.Height;
            end;
          end;
          AttachedIEBitmap.CopyToTBitmap(TempBitmap);
        finally
          F.Free;
        end;
      end;
    finally
      ImageEnIO.Free;
      ImageEnProc.Free;
      AttachedIEBitmap.Free;
    end;
    // Resize the thumb
    // Need to lock/unlock the canvas here
    OutBitmap.Canvas.Lock;
    try
      DestR := SpRectAspectRatio(ImageWidth, ImageHeight, ThumbW, ThumbH, talNone, True);
      SpInitBitmap(OutBitmap, DestR.Right, DestR.Bottom, BgColor);
      // StretchDraw is NOT THREADSAFE!!! Use SpStretchDraw instead
      SpStretchDraw(TempBitmap, OutBitmap.Canvas, DestR, Subsampling);
      Result := True;
    finally
      OutBitmap.Canvas.UnLock;
    end;
    Result := True;
  finally
    TempBitmap.Canvas.Unlock;
    TempBitmap.Free;
  end;
end;
{$ENDIF}

function SpMakeThumbFromFile(const AFileName: string; const AOutBitmap: TBitmap; const AThumbW, AThumbH: Integer; const ABgColor: TColor; const ASubSampling, AExifThumbnail, AExifOrientation: Boolean; var AImageWidth, AImageHeight: Integer): Boolean;
const
  cDegree180 = 180;
  cDegree270 = 270;
  cDegree90 = 90;
  cExtEMF = '.emf';
  cExtJIF = '.jif';
  cExtJPE = '.jpe';
  cExtJPEG = '.jpeg';
  cExtJPG = '.jpg';
  cExtWMF = '.wmf';
  cValue180Degree = '3';
  cValue270Degree = '8';
  cValue90Degree = '6';
  cValueImageHeight = '$A003';
  cValueImageWidth = '$A002';
  cValueOrientation = '$112';
var
  lBuffer: string;
  lCount: Integer;
  lDestR: TRect;
  lExif: TStringList;
  lExt: string;
  lFoundHeight: Boolean;
  lFoundWidth: Boolean;
  lHasExifThumb: Boolean;
  lJpeg: TJpegImage;
  lOrientation: Integer;
  lPicture: TPicture;
  lWMFScale: Single;
begin
  Result := False;
  if not Assigned(AOutBitmap) then
    Exit;

  lExt := TPath.GetExtension(AFileName).ToLower;
  lHasExifThumb := False;
  lOrientation := 0;
  lFoundHeight := False;
  lFoundWidth := False;

  lPicture := TPicture.Create;
  try
    // Try to load the lExif thumbnail
    if AExifThumbnail and ((lExt = cExtJPG) or (lExt = cExtJPEG) or (lExt = cEXTJIF)) or (lExt = cExtJPE) then
    begin
      lExif := TStringList.Create;
      try
        lJpeg := SpReadExifThumbnail(AFileName, lExif);

        if Assigned(lJpeg) then
        begin
          lHasExifThumb := True;
          lPicture.Assign(lJpeg);
          // Get ImageWidth
          lCount := lExif.IndexOfName(cValueImageWidth);
          if lCount > -1 then
          begin
            lBuffer := lExif.ValueFromIndex[lCount];
            if not lBuffer.IsEmpty then
            begin
              AImageWidth := StrToIntDef(lBuffer, 0);
              lFoundWidth := AImageWidth > 0;
            end;
          end;
          // Get ImageHeight
          lCount := lExif.IndexOfName(cValueImageHeight);
          if lCount > -1 then
          begin
            lBuffer := lExif.ValueFromIndex[lCount];
            if not lBuffer.IsEmpty then
            begin
              AImageHeight := StrToIntDef(lBuffer, 0);
              lFoundHeight := AImageHeight > 0;
            end;
          end;
        end;

        // Get the Orientation
        if AExifOrientation then
        begin
          lCount := lExif.IndexOfName(cValueOrientation);
          if lCount > -1 then
          begin
            lBuffer := lExif.ValueFromIndex[lCount];
            lOrientation := 0;
            if lBuffer = cValue90Degree then
              lOrientation := cDegree90
            else if lBuffer = cValue180Degree then
              lOrientation := cDegree180
            else if lBuffer = cValue270Degree then
              lOrientation := cDegree270;
          end;
        end;

      finally
        FreeAndNil(lJpeg);
        lExif.Free;
      end;
    end;

    if lHasExifThumb and (not lFoundHeight) and (not lFoundWidth) then
    begin
      SpLoadGraphicFile(AFileName, lPicture, False);
      AImageWidth := lPicture.Graphic.Width;
      AImageHeight := lPicture.Graphic.Height;
    end;

    if not lHasExifThumb then
    begin
      SpLoadGraphicFile(AFileName, lPicture, False);
      AImageWidth := lPicture.Graphic.Width;
      AImageHeight := lPicture.Graphic.Height;
      if (lExt = cExtJPG) or (lExt = cExtJPEG) or (lExt = cExtJIF) or (lExt = cExtJPE) then
      begin
        try
          // Try to load just the minimum possible jpg
          // 5x faster loading jpegs, from Danny Thorpe:
          // http://groups.google.com/groups?hl=en&frame=right&th=69a64eafb3ee2b12&seekm=01bdee71%24e5a5ded0%247e018f0a%40agamemnon#link6
          lJpeg := TJpegImage(lPicture.Graphic);
          lJpeg.Performance := jpBestSpeed;
          lJpeg.Scale := jsFullSize;
          while ((lJpeg.Width > AThumbW) or (lJpeg.Height > AThumbH)) and (lJpeg.Scale < jsEighth) do
            lJpeg.Scale := Succ(lJpeg.Scale);
          if lJpeg.Scale <> jsFullSize then
            lJpeg.Scale := Pred(lJpeg.Scale);
          lJpeg.DibNeeded; // Now load the JPG
        except
          on E: Exception do
          begin
            if not SpIsIncompleteJPGError(E) then
              raise;
          end;
        end;
      end
        // We need to scale down the metafile images
      else if (lExt = cExtWMF) or (lExt = cExtEMF) then
      begin
        lWMFScale := Min(1, Min(AThumbW/lPicture.Graphic.Width, AThumbH/lPicture.Graphic.Height));
        lPicture.Graphic.Width := Round(lPicture.Graphic.Width * lWMFScale);
        lPicture.Graphic.Height := Round(lPicture.Graphic.Height * lWMFScale);
      end;
    end;

    // Resize the thumb
    if lPicture.Graphic <> nil then
    begin
      // Need to lock/unlock the canvas here
      AOutBitmap.Canvas.Lock;
      try
        lDestR := SpRectAspectRatio(AImageWidth, AImageHeight, AThumbW, AThumbH, talNone);
        SpInitBitmap(AOutBitmap, lDestR.Right, lDestR.Bottom, ABgColor);
        // StretchDraw is NOT THREADSAFE!!! Use SpStretchDraw instead
        SpStretchDraw(lPicture.Graphic, AOutBitmap.Canvas, lDestR, ASubSampling);

        // Rotate the thumbnail based on the Exif lOrientation value
        // Modern cameras have an option to auto rotate the image
        // when the photo is saved in this case Orientation = 0
        if AExifOrientation and (lOrientation > 0) then
          SpPixelRotate(AOutBitmap, lOrientation);

        Result := True;
      finally
        AOutBitmap.Canvas.UnLock;
      end;
    end;
  finally
    lPicture.Free;
  end;
end;

function SpCreateThumbInfoFromFile(ANamespace: TNamespace; AThumbW, AThumbH: Integer; AUseSubsampling, AUseShellExtraction, AUseExifThumbnail, AUseExifOrientation: Boolean; ABackgroundColor: TColor): TThumbInfo;
var
  lBitmap: TBitmap;
  lHeight: Integer;
  lThumbInfo: TThumbInfo;
  lThumbnailExtracted: Boolean;
  lWidth: Integer;
begin
  lBitmap := nil;
  lThumbInfo := nil;
  try
    if AUseShellExtraction then
    begin
      if Assigned(ANamespace.ExtractImage) then
      begin
        // IEIFLAG_OFFLINE: use only local content for rendering.
        // IEIFLAG_ORIGSIZE: render the image to the approximate size passed in prgSize, but crop it if necessary.
        ANamespace.ExtractImage.Flags := ANamespace.ExtractImage.Flags or IEIFLAG_OFFLINE or IEIFLAG_ORIGSIZE;

        if ANamespace.Folder then
        begin
          // The standard size for the folder image is 96x96
          ANamespace.ExtractImage.Width := 96;
          ANamespace.ExtractImage.Height := 96;
        end
        else
        begin
          // Use the maximum size for a shell extracted image, 256x256
          ANamespace.ExtractImage.Width := 256; // AThumbW;
          ANamespace.ExtractImage.Height := 256; // AThumbH;
        end;
        ANamespace.ExtractImage.ImagePath;
        lBitmap := ANamespace.ExtractImage.Image;
        if Assigned(lBitmap) then
        begin
          // Use the ABackgroundColor to make the extracted bitmap transparent
          if UsesAlphaChannel(lBitmap) then
            ConvertBitmapEx(lBitmap, lBitmap, ABackgroundColor);
          lThumbInfo := TThumbInfo.Create;
          lThumbInfo.Fill(ANamespace.NameForParsing, '', '', ANamespace.LastWriteDateTime, lBitmap.Width, lBitmap.Height, nil, 0);
          lThumbInfo.WriteBitmap(lBitmap);
        end;
      end;
    end
    else
    begin
      lThumbnailExtracted := False;
      lBitmap := TBitmap.Create;
      {$IFNDEF USEIMAGEEN}
      lBitmap.PixelFormat := pf32Bit; // Jim:  This needs to be done for images that use the Alpha Channel for Transparency
      {$ENDIF}
      lBitmap.Canvas.Lock;
      try
        try
          {$IFDEF USEIMAGEEN}
          lThumbnailExtracted := SpMakeThumbFromFileImageEn(ANamespace.NameForParsing, lBitmap, AThumbW, AThumbH,
            clRed, AUseSubsampling, AUseExifThumbnail, AUseExifOrientation, lWidth, lHeight);
          {$ELSE}
          // Jim: Changed the Background so images that use the Alpha Channel for Transparency work correctly
          lThumbnailExtracted := SpMakeThumbFromFile(ANamespace.NameForParsing, lBitmap, AThumbW, AThumbH,
            ABackgroundColor, AUseSubsampling, AUseExifThumbnail, AUseExifOrientation, lWidth, lHeight);
          // Jim:  This needs to be done for images that use the Alpha Channel for Transparency
          if lThumbnailExtracted and UsesAlphaChannel(lBitmap) then
            ConvertBitmapEx(lBitmap, lBitmap, ABackgroundColor);
          {$ENDIF}
        except
          // Don't raise any image errors
        end;

        if lThumbnailExtracted then
        begin
          lThumbInfo := TThumbInfo.Create;
          lThumbInfo.Fill(ANamespace.NameForParsing, '', '', ANamespace.LastWriteDateTime, lWidth, lHeight, nil, 0);
          lThumbInfo.WriteBitmap(lBitmap);
        end;
      finally
        lBitmap.Canvas.Unlock;
      end;
    end;
    Result := lThumbInfo;
    lThumbInfo := nil;
  finally
    lThumbInfo.Free;
    lBitmap.Free;
  end;
end;

function SpReadExif(const AStream: TVirtualFileStream; const AExif: TStringList; var Ofs: LongWord): Boolean;
const
  cMagicNumber1 = $002A;
  cMagicNumberEXIF = 18;
  cMagicNumberJFIF = 16;
  cMarkerEXIF = $E1FF;
  cMarkerJFIF = $E0FF;
  cMarkerJPEG = $D8FF;
  cMarkerMotorola = $4D4D;
  cStringEXIF = 'Exif';
var
  lDummy: UInt32;
  lExifMarker_Offset: UInt32;
  lIFD_Exif_Offset: UInt32;
  lIFD1_Offset: UInt32;
  lIsMotorola: Boolean; // BigEndian
  lLong: UInt32;
  lStringBuffer: string;
  lWord: UInt16;

  procedure readit(var ABuf: UInt16); overload;
  begin
    AStream.Read(ABuf, 2);
    if lIsMotorola then
       ABuf := Swap(ABuf);
  end;

  procedure readit(var ABuf: UInt32); overload;
  var
    lA: UInt16;
    lB: UInt16;
  begin
    readit(lA);
    readit(lB);
    if lIsMotorola then
      ABuf := lB or lA
    else
      ABuf := lA or lB;
  end;

  function ReadString(ACount: Int32): string;
  const
    cSpace = #$20;
  var
    lBuffer: TBytes;
  begin
    Result := '';
    SetLength(lBuffer, ACount);
    AStream.ReadBuffer(lBuffer, ACount);
    Result := TEncoding.ANSI.GetString(lBuffer);
    // Clean it
    Result := Result.Replace(cSpace, '');
  end;

  procedure ReadExifDirectory(AOffset: LongWord; out AIFD_Exif_Offset: UInt32);
  const
    cASCIIMagicNumber1 = 4;
    cASCIIMagicNumber2 = 8;
    cDeli = ',';
    cExifFormat = '$%x=%s';
    cLongMagicNumber1 = 1;
    cMaxNumberEntries = 128;
    cShortMagicNumber1 = 2;
    cShortMagicNumber2 = 8;
    cTAG_EXIF_OFFSET = $8769;
    cTagASCII = 2;
    cTagLong = 4;
    cTagRational64u = 5;
    cTagRecordSize = 12;
    cTagShort = 3;
  var
    lBuffer: string;
    lCardinal1: UInt32;
    lCardinal2: UInt32;
    lCnt2: Integer;
    lCount: UInt16;
    lDouble: Double;
    lInner: Integer;
    lLong: UInt16;
    lMyCount: UInt32;
    lMyPos: UInt32;
    lMyTag: UInt16;
    lMyType: UInt16;
    lMyValue: UInt32;
    lWord: UInt16;
  begin
    AIFD_Exif_Offset := 0;
    if AOffset = 0 then
      Exit;

    AOffset := AOffset + cTagRecordSize; // 12 is the "tag record size"
    if AOffset >= AStream.Size then
      Exit;

    AStream.Seek(AOffset, soBeginning);

    readit(lCount); // Number of entries
    if lCount > cMaxNumberEntries then
      Exit;

    for lInner := 0 to lCount - 1 do
    begin
      lMyPos := AStream.Position;
      readit(lMyTag);   // Tag
      readit(lMyType);  // Type
      readit(lMyCount); // lCount
      readit(lMyValue); // Value

      if lMyTag = cTAG_EXIF_OFFSET then
        AIFD_Exif_Offset := lMyValue // TAG_EXIF_OFFSET
      else
      begin
        lBuffer := string.Empty;
        case lMyType of
          cTagASCII: // ASCII
          begin
            if lMyCount <= cASCIIMagicNumber1 then
              AStream.Seek(lMyPos + cASCIIMagicNumber2, soBeginning)
            else
              AStream.Seek(lExifMarker_Offset + lMyValue, soBeginning);
            lBuffer := ReadString(lMyCount);
          end;
          cTagShort: // Short
          begin
            // We can store two words in a 4 byte area.
            // So if there is less (or equal) than two items
            // in this section they are stored in the
            // Value/Offset area
            if lMyCount <= cShortMagicNumber1 Then
              AStream.Seek(lMyPos + cShortMagicNumber2, soBeginning)
            else
              AStream.Seek(lExifMarker_Offset + lMyValue, soBeginning);
            for lCnt2 := 1 To lMyCount do
            begin
              if not lBuffer.IsEmpty then
                lBuffer := lBuffer + cDeli;
              readit(lWord);
              lBuffer := lBuffer + IntToStr(lWord);
            end;
          end;
          cTagLong: // Long
            begin
              // We can store one long in a 4 byte area.
              // So if there is less (or equal) than one item
              // in this section they are stored in the
              // Value/Offset area
              if lMyCount <= cLongMagicNumber1 then
                lBuffer := IntToStr(lMyValue)
              else
              begin
                AStream.Seek(lExifMarker_Offset + lMyValue, soBeginning);
                for lCnt2 := 1 To lMyCount do
                begin
                  if not lBuffer.IsEmpty then
                    lBuffer := lBuffer + cDeli;
                  readit(lLong);
                  lBuffer := lBuffer + IntToStr(lLong);
                end;
              end;
            end;
          cTagRational64u: // Rational 64 u
            begin
              AStream.Seek(lExifMarker_Offset + lMyValue, soBeginning);
              readit(lCardinal1);
              readit(lCardinal2);
              if lCardinal2 <> 0 then
                lDouble := lCardinal1 / lCardinal2
              else
                lDouble := 0;
              lBuffer := IntToStr(Round(lDouble));
            end;
        end;

        AExif.Add(string.Format(cExifFormat, [lMyTag, lBuffer]))
      end;

      AStream.Seek(lMyPos + cTagRecordSize, soBeginning); // The 12 is the "tag record size"
    end;
  end;

begin
  Ofs := 0;
  Result := False;
  AExif.Clear;

  AStream.Position := 0;
  try
    AStream.Read(lWord, 2);
    if lWord <> cMarkerJPEG then
      Exit; // Not JPEG file

    // $E1 marker is for Exif
    // $E0 marker is for JFIF
    // $ED marker is for IPTC, Photoshop
    AStream.Read(lWord, 2);
    if (lWord <> cMarkerEXIF) and (lWord <> cMarkerJFIF) then
      Exit; // Doesn't have Exif

    // Skip JFIF header if available:
    // http://www.mustangpeak.net/phpBB2/viewtopic.php?t=1371&highlight=exif
    if lWord = cMarkerJFIF then
    begin
      AStream.Seek(cMagicNumberJFIF, soFromCurrent);
      AStream.Read(lWord, SizeOf(lWord));
      if lWord = cMarkerEXIF then
        Ofs := cMagicNumberEXIF
      else
        Exit;
    end;

    readit(lWord);
    lStringBuffer := ReadString(cStringEXIF.Length);
    if lStringBuffer <> cStringEXIF then
      Exit;
    readit(lWord);
    if lWord <> 0 then
      Exit;
    lExifMarker_Offset := AStream.Position; // This is our reference marker

    readit(lWord);
    lIsMotorola := lWord = cMarkerMotorola; // Alignment type
    readit(lWord);
    if lWord <> cMagicNumber1 then
      Exit; // Check for $002A magic number

    // We are ready to read the Exif tags
    // Note: 12 is the "tag record size"
    readit(lLong); // IFD0
    ReadExifDirectory(Ofs + lLong, lIFD_Exif_Offset);
    if lIFD_Exif_Offset = 0 then
      Exit;
    readit(lIFD1_Offset); // IFD1
    if lIFD1_Offset = 0 then
      Exit;

    // Now that we have IFD0 and IFD1 read the Exif
    // in the following order: IFD0, Exif, IFD1
    ReadExifDirectory(Ofs + lIFD_Exif_Offset, lDummy);
    ReadExifDirectory(Ofs + lIFD1_Offset, lDummy);
    Result := True;
  finally
    AStream.Position := 0;
  end;
end;

function SpReadExifThumbnail(const AFileName: string; const AExif: TStringList): TJpegImage;

  function CorrectThumbnailBuffer(AThumbBuffer: string): string;
  var
    lBeginMark: Integer;
    lEndMark: Integer;
  begin
    Result := '';

    // FFD8 marker is the SOI (Start Of Image), we need to LeftTrim the buffer
    lBeginMark := Pos(#$ff#$d8, AThumbBuffer);
    if lBeginMark <= 0 then
      Exit;

    // FFD9 marker is the end of JPEG, we need to RightTrim the buffer
    AThumbBuffer := Copy(AThumbBuffer, lBeginMark, Length(AThumbBuffer));
    lEndMark := Pos(#$ff#$d9, AThumbBuffer) + 2;
    AThumbBuffer := Copy(AThumbBuffer, 1, lEndMark);
    if AThumbBuffer.Length > 3 then
      Result := AThumbBuffer;
  end;

var
  lBuffer: string;
  lCount: Integer;
  lOfs: UInt32;
  lStream: TVirtualFileStream;
  lStringStream: TStringStream;
  lThumbBuffer: string;
  lThumbOffset: UInt32;
  lThumbSize: UInt32;
begin
  Result := nil;
  lThumbOffset := 0;
  lThumbSize := 0;

  lStream := TVirtualFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    lOfs := 0;
    if not SpReadExif(lStream, AExif, lOfs) then
      Exit;

    // For thumbnail extraction
    // $103 = Compression, (when Value = 6 it is Jpeg compressed)
    // $201 = JPEGInterchangeFormat (Integer)
    // $202 = JPEGInterchangeFormatLength (Integer)

    // Other tags
    // $10F = Make (String)
    // $110 = Model (String)
    // $112 = Orientation (Integer)
    // $131 = Software (String)
    // $9003 = Photo DateTime (String)
    // $13C = Host Computer (String)
    // $A002 = ImageWidth (Integer)
    // $A003 = ImageHeight (Integer)

    lCount := AExif.IndexOfName('$103');
    if lCount > -1 then
    begin
      lBuffer := AExif.ValueFromIndex[lCount];
      if not lBuffer.IsEmpty then
      begin
        lCount := StrToIntDef(lBuffer, 0);
        if lCount <> 6 then
          Exit; // Thumbnail is not in JPEG format
      end;
    end;

    lCount := AExif.IndexOfName('$201');
    if lCount > -1 then
    begin
      lBuffer := AExif.ValueFromIndex[lCount];
      if not lBuffer.IsEmpty then
        lThumbOffset := StrToIntDef(lBuffer, 0);
    end;

    lCount := AExif.IndexOfName('$202');
    if lCount > -1 then
    begin
      lBuffer := AExif.ValueFromIndex[lCount];
      if not lBuffer.IsEmpty then
        lThumbSize := StrToIntDef(lBuffer, 0);
    end;

    if (lThumbOffset > 0) and (lThumbSize > 0) then
    begin
      lStream.Seek(lOfs + lThumbOffset + 12, soBeginning);
      lStringStream := TStringStream.Create;
      try
        lStringStream.CopyFrom(lStream, lThumbSize);
        lStringStream.Position := 0;
        lThumbBuffer := CorrectThumbnailBuffer(lStringStream.DataString);
        if not lThumbBuffer.IsEmpty then
        begin
          lStringStream.Size := 0;
          lStringStream.WriteString(lThumbBuffer);
          lStringStream.Position := 0;
          Result := TJpegImage.Create;
          try
            Result.Performance := jpBestSpeed;
            Result.LoadFromStream(lStringStream);
            Result.DIBNeeded; // Now load the JPG
          except
            FreeAndNil(Result);
          end;
        end;
      finally
        lStringStream.Free;
      end;
    end;
  finally
    lStream.Free;
  end;
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Stream helpers }

function SpReadDateTimeFromStream(ST: TStream): TDateTime;
begin
  ST.ReadBuffer(Result, SizeOf(Result));
end;

procedure SpWriteDateTimeToStream(ST: TStream; D: TDateTime);
begin
  ST.WriteBuffer(D, SizeOf(D));
end;

function SpReadIntegerFromStream(ST: TStream): Integer;
begin
  ST.ReadBuffer(Result, SizeOf(Result));
end;

procedure SpWriteIntegerToStream(ST: TStream; I: Integer);
begin
  ST.WriteBuffer(I, SizeOf(I));
end;

function SpReadUnicodeStringFromStream(ST: TStream): string;
var
  L: Integer;
  WS: string;
begin
  Result := '';
  ST.ReadBuffer(L, SizeOf(L));
  SetLength(WS, L);
  ST.ReadBuffer(PWideChar(WS)^, 2 * L);
  Result := WS;
end;

procedure SpWriteUnicodeStringToStream(ST: TStream; WS: string);
var
  L: Integer;
begin
  L := Length(WS);
  ST.WriteBuffer(L, SizeOf(L));
  ST.WriteBuffer(PWideChar(WS)^, 2 * L);
end;

function SpReadMemoryStreamFromStream(const AStream: TStream; AMemoryStream: TMemoryStream): Boolean;
var
  lSize: Integer;
begin
  Result := False;
  AStream.ReadBuffer(lSize, SizeOf(lSize));
  if lSize > 0 then
  begin
    AMemoryStream.Size := lSize;
    AStream.ReadBuffer(AMemoryStream.Memory^, lSize);
    Result := True;
  end;
end;

procedure SpWriteMemoryStreamToStream(const AStream: TStream; AMemoryStream: TMemoryStream);
var
  lSize: Integer;
begin
  lSize := AMemoryStream.Size;
  AStream.WriteBuffer(lSize, SizeOf(lSize));
  AStream.WriteBuffer(AMemoryStream.Memory^, lSize);
end;

function SpReadBitmapFromStream(ST: TStream; B: TBitmap): Boolean;
var
  MS: TMemoryStream;
begin
  Result := False;
  MS := TMemoryStream.Create;
  try
    if SpReadMemoryStreamFromStream(ST, MS) then
      if Assigned(B) then begin
        B.LoadFromStream(MS);
        Result := True;
      end;
  finally
    MS.Free;
  end;
end;

procedure SpWriteBitmapToStream(ST: TStream; B: TBitmap);
var
  L: Integer;
  MS: TMemoryStream;
begin
  if Assigned(B) then begin
    MS := TMemoryStream.Create;
    try
      B.SaveToStream(MS);
      SpWriteMemoryStreamToStream(ST, MS);
    finally
      MS.Free;
    end;
  end
  else begin
    L := 0;
    ST.WriteBuffer(L, SizeOf(L));
  end;
end;

procedure SpConvertBitmapStreamToJPGStream(MS: TMemoryStream; CompressionQuality: TJPEGQualityRange = 90);
var
  B: TBitmap;
  J: TJPEGImage;
begin
  B := TBitmap.Create;
  J := TJPEGImage.Create;
  try
    MS.Position := 0;
    B.LoadFromStream(MS);
    //WARNING, first set the JPEG options
    J.CompressionQuality := CompressionQuality; //90 is the default, 60 is the best setting
    //Now assign the Bitmap
    J.Assign(B);
    J.Compress;
    MS.Clear;
    J.SaveToStream(MS);
    MS.Position := 0;
  finally
    B.Free;
    J.Free;
  end;
end;

procedure SpConvertJPGStreamToBitmapStream(const AStream: TMemoryStream);
var
  lBitmap: TBitmap;
  lJpeg: TJPEGImage;
begin
  lBitmap := nil;
  lJpeg := TJPEGImage.Create;
  try
    lBitmap := TBitmap.Create;
    AStream.Position := 0;
    lJpeg.LoadFromStream(AStream);
    lBitmap.Assign(lJpeg);
    AStream.Clear;
    lBitmap.SaveToStream(AStream);
    AStream.Position := 0;
  finally
    lBitmap.Free;
    lJpeg.Free;
  end;
end;

procedure SpConvertJPGStreamToBitmap(MS: TMemoryStream; OutBitmap: TBitmap);
var
  B: TMemoryStream;
begin
  B := TMemoryStream.Create;
  try
    MS.Position := 0;
    B.LoadFromStream(MS);
    MS.Position := 0;
    SpConvertJPGStreamToBitmapStream(B);
    OutBitmap.LoadFromStream(B);
  finally
    B.Free;
  end;
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ TExtensionsList }

constructor TExtensionsList.Create;
begin
  inherited;
  Sorted := True;
end;

function TExtensionsList.Add(const Extension: string; HighlightColor: TColor): Integer;
begin
  Result := inherited Add(Extension);
  if Result > -1 then
    Colors[Result] := HighlightColor;
end;

function TExtensionsList.AddObject(const S: string; AObject: TObject): Integer;
var
  Aux: string;
begin
  Aux := SysUtils.AnsiLowerCase(S);
  // Add the '.' to the extension
  if (Length(Aux) > 0) and (Aux[1] <> '.') then
    Aux := '.' + Aux;
  Result := inherited AddObject(Aux, AObject);
end;

function TExtensionsList.IndexOf(const S: string): Integer;
var
  Aux: string;
begin
  Aux := SysUtils.AnsiLowerCase(S);
  // Add the '.' to the extension
  if (Length(Aux) > 0) and (Aux[1] <> '.') then
    Aux := '.' + Aux;
  Result := inherited IndexOf(Aux);
end;

function TExtensionsList.DeleteString(const S: string): Boolean;
var
  I: Integer;
begin
  I := IndexOf(S);
  if I > -1 then begin
    Delete(I);
    Result := True;
  end
  else
    Result := False;
end;

function TExtensionsList.GetColors(Index: Integer): TColor;
begin
  if Assigned(Objects[Index]) then
    Result := TColor(Objects[Index])
  else
    Result := clNone;
end;

procedure TExtensionsList.SetColors(Index: Integer; const Value: TColor);
begin
  Objects[Index] := Pointer(Value);
end;

{ TThumbInfo }

constructor TThumbInfo.Create;
begin
  inherited Create;
  FThumbBitmapStream := TMemoryStream.Create;
  FStreamSignature := DefaultStreamSignature;
end;

destructor TThumbInfo.Destroy;
begin
  FThumbBitmapStream.Free;
  FThumbBitmapStream := nil;
  inherited Destroy;
end;

procedure TThumbInfo.Draw(ACanvas: TCanvas; ARect: TRect;
  Alignment: TThumbsAlignment; Stretch: Boolean = False);
var
  B: TBitmap;
  DestR: TRect;
  CellSize: TPoint;
begin
  B := TBitmap.Create;
  try
    if ReadBitmap(B) then begin
      CellSize.X := RectWidth(ARect);
      CellSize.Y := RectHeight(ARect);

      // If it's a folder stretch the bitmap to fit the thumbnail
      // If Stretch is true it will be stretched anyway
      if not Stretch then
        Stretch := DirectoryExists(FileName);

      DestR := SpRectAspectRatio(B.Width, B.Height, CellSize.X, CellSize.Y, Alignment, Stretch);
      OffsetRect(DestR, ARect.Left, ARect.Top);
      // StretchDraw is NOT THREADSAFE!!! Use SpStretchDraw instead
      SpStretchDraw(B, ACanvas, DestR, True);
    end;
  finally
    B.Free;
  end;
end;

procedure TThumbInfo.Fill(AFilename, AExif, AComment: string;
  AFileDateTime: TDateTime; AImageWidth, AImageHeight: Integer;
  AThumbBitmapStream: TMemoryStream; ATag: Integer);
begin
  FFilename := AFilename;
  FFileDateTime := AFileDateTime;
  FExif := AExif;
  FComment := AComment;
  FImageWidth := AImageWidth;
  FImageHeight := AImageHeight;
  FTag := ATag;
  if Assigned(AThumbBitmapStream) then
    FThumbBitmapStream.LoadFromStream(AThumbBitmapStream);
end;

function TThumbInfo.GetThumbSize: TPoint;
var
  B: TBitmap;
begin
  Result := Point(-1, -1);
  B := TBitmap.Create;
  try
    if ReadBitmap(B) then
      Result := Point(B.Width, B.Height);
  finally
    B.Free;
  end;
end;

function TThumbInfo.DefaultStreamSignature: string;
begin
  // Override this method to change the default stream signature
  // Use the StreamSignature to load or not the custom properties
  // in LoadFromStream.
  Result := '1.0';
end;

procedure TThumbInfo.Assign(T: TThumbInfo);
begin
  // Override this method to Assign the custom properties.
  Fill(T.Filename, T.Exif, T.Comment, T.FileDateTime,
    T.ImageWidth, T.ImageHeight, T.FThumbBitmapStream, T.Tag);
end;

function TThumbInfo.LoadFromStream(ST: TStream): Boolean;
begin
  // Override this method to read the properties from the stream
  // Use the StreamSignature to load or not the custom properties
  Result := True;
  FStreamSignature := SpReadUnicodeStringFromStream(ST);
  FFilename := SpReadUnicodeStringFromStream(ST);
  FFileDateTime := SpReadDateTimeFromStream(ST);
  FImageWidth := SpReadIntegerFromStream(ST);
  FImageHeight := SpReadIntegerFromStream(ST);
  FExif := SpReadUnicodeStringFromStream(ST);
  FComment := SpReadUnicodeStringFromStream(ST);
  FUseCompression := Boolean(SpReadIntegerFromStream(ST));
  SpReadMemoryStreamFromStream(ST, FThumbBitmapStream);
  if FUseCompression then
    SpConvertJPGStreamToBitmapStream(FThumbBitmapStream);
end;

procedure TThumbInfo.SaveToStream(ST: TStream);
var
  MS: TMemoryStream;
begin
  // Override this method to write the properties to the stream
  SpWriteUnicodeStringToStream(ST, FStreamSignature);
  SpWriteUnicodeStringToStream(ST, FFilename);
  SpWriteDateTimeToStream(ST, FFileDateTime);
  SpWriteIntegerToStream(ST, FImageWidth);
  SpWriteIntegerToStream(ST, FImageHeight);
  SpWriteUnicodeStringToStream(ST, FExif);
  SpWriteUnicodeStringToStream(ST, FComment);
  SpWriteIntegerToStream(ST, Integer(FUseCompression));
  if FUseCompression then begin
    MS := TMemoryStream.Create;
    try
      MS.LoadFromStream(FThumbBitmapStream);
      SpConvertBitmapStreamToJPGStream(MS); // JPEG compressed
      SpWriteMemoryStreamToStream(ST, MS);
    finally
      MS.Free;
    end;
  end
  else
    SpWriteMemoryStreamToStream(ST, FThumbBitmapStream);
end;

function TThumbInfo.ReadBitmap(AOutBitmap: TBitmap): Boolean;
begin
  Result := Assigned(AOutBitmap);
  if Result then
  begin
    try
      FThumbBitmapStream.Position := 0;
      AOutBitmap.LoadFromStream(FThumbBitmapStream);
      FThumbBitmapStream.Position := 0;
    except
      Result := False;
    end;
  end;
end;

procedure TThumbInfo.WriteBitmap(ABitmap: TBitmap);
begin
  ABitmap.SaveToStream(FThumbBitmapStream);
  FThumbBitmapStream.Position := 0;
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ TThumbAlbum }

constructor TThumbAlbum.Create;
begin
  FHeaderFilelist := TStringList.Create;  // OwnsObjects
  FComments := TStringList.Create;

  Clear;
end;

destructor TThumbAlbum.Destroy;
begin
  Clear;
  FHeaderFilelist.Free;
  FComments.Free;
  inherited;
end;

procedure TThumbAlbum.Clear;
var
  I: Integer;
begin
  // FHeaderFilelist owns the objects
  for I := 0 to FHeaderFilelist.Count - 1 do
    TThumbInfo(FHeaderFilelist.Objects[I]).Free;
  FHeaderFilelist.Clear;
  FComments.Clear;

  FStreamVersion := DefaultStreamVersion;
  FLoadedFromFile := False;
  FDirectory := '';
  FSize := 0;
  FInvalidCount := 0;
  FThumbWidth := 0;
  FThumbHeight := 0;
end;

function TThumbAlbum.IndexOf(Filename: string): Integer;
begin
  Result := FHeaderFilelist.IndexOf(Filename);
end;

function TThumbAlbum.Add(T: TThumbInfo): Integer;
begin
  Result := FHeaderFilelist.AddObject(T.Filename, T);
  if Result > -1 then
    FSize := FSize + T.FThumbBitmapStream.Size;
end;

procedure TThumbAlbum.Delete(Index: Integer);
var
  M: TMemoryStream;
begin
  if (Index > -1) and (Index < Count) then begin
    M := TThumbInfo(FHeaderFilelist.Objects[Index]).FThumbBitmapStream;
    FSize := FSize - M.Size;
    // Don't delete it from the HeaderFilelist, instead free the ThumbInfo and clear the string
    TThumbInfo(FHeaderFilelist.Objects[Index]).Free;
    FHeaderFilelist.Objects[Index] := nil;
    FHeaderFilelist[Index] := '';
    Inc(FInvalidCount);
  end;
end;

procedure TThumbAlbum.Delete(Filename: string);
var
  Index: Integer;
begin
  Index := IndexOf(Filename);
  if (Index > -1) and (Index < Count) then
    Delete(Index);
end;

function TThumbAlbum.Read(Index: Integer; var OutThumbInfo: TThumbInfo): Boolean;
begin
  if (Index > -1) and (Index < FHeaderFilelist.Count) then
    OutThumbInfo := FHeaderFilelist.Objects[Index] as TThumbInfo
  else
    OutThumbInfo := nil;
  Result := Assigned(OutThumbInfo);
end;

function TThumbAlbum.Read(Index: Integer; OutBitmap: TBitmap): Boolean;
var
  T: TThumbInfo;
begin
  Result := False;
  if Read(Index, T) then begin
    T.ReadBitmap(OutBitmap);
    Result := True;
  end;
end;

function TThumbAlbum.DefaultStreamVersion: Integer;
begin
  Result := 1;
end;

procedure TThumbAlbum.LoadFromFile(const Filename: string);
var
  FileStream: TStream;
  T: TThumbInfo;
  I, FileCount: Integer;
begin
  Clear;
  FileStream := TVirtualFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    // Read the header
    FDirectory := SpReadUnicodeStringFromStream(FileStream);
    FileCount := SpReadIntegerFromStream(FileStream);
    FStreamVersion := SpReadIntegerFromStream(FileStream);
    FThumbWidth := SpReadIntegerFromStream(FileStream);
    FThumbHeight := SpReadIntegerFromStream(FileStream);

    // Read the file list
    if FStreamVersion = DefaultStreamVersion then begin
      for I := 0 to FileCount - 1 do begin
        T := TThumbInfo.Create;
        try
          T.LoadFromStream(FileStream);
          if FileExists(T.Filename) then
            Add(T)
          else begin
            // The file is not valid, don't add it
            T.Free;
          end;
        except
          Inc(FInvalidCount);
          T.Free;
        end;
      end;
      // Read the comments or extra options
      FComments.LoadFromStream(FileStream);
      FLoadedFromFile := True;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure TThumbAlbum.LoadFromFile(const Filename: string; InvalidFiles: TStringList);
var
  AuxThumbAlbum: TThumbAlbum;
  T, TCopy: TThumbInfo;
  I: Integer;
begin
  if not Assigned(InvalidFiles) or (InvalidFiles.Count = 0) then
    LoadFromFile(Filename)
  else begin
    // Tidy the list
    for I := 0 to InvalidFiles.Count - 1 do
      InvalidFiles[I] := SysUtils.AnsiLowerCase(InvalidFiles[I]);
    InvalidFiles.Sort;
    // Load a cache file and ATTACH only the streams that are NOT in InvalidFiles list
    AuxThumbAlbum := TThumbAlbum.Create;
    try
      AuxThumbAlbum.LoadFromFile(Filename);
      for I := 0 to AuxThumbAlbum.Count - 1 do begin
        if AuxThumbAlbum.Read(I, T) and (InvalidFiles.IndexOf(T.Filename) < 0) then begin
          TCopy := TThumbInfo.Create;
          try
            TCopy.Assign(T);
            Self.Add(TCopy);
          except
            TCopy.Free;
          end;
        end;
      end;

      FLoadedFromFile := True;
    finally
      AuxThumbAlbum.Free;
    end;
  end;
end;

procedure TThumbAlbum.SaveToFile(const Filename: string);
var
  FileStream: TStream;
  T: TThumbInfo;
  I: Integer;
begin
  if Count = 0 then Exit;

  FileStream := TVirtualFileStream.Create(Filename, fmCreate);
  try
    // Write the header
    SpWriteUnicodeStringToStream(FileStream, Directory);
    SpWriteIntegerToStream(FileStream, Count - InvalidCount);
    SpWriteIntegerToStream(FileStream, DefaultStreamVersion);
    SpWriteIntegerToStream(FileStream, FThumbWidth);
    SpWriteIntegerToStream(FileStream, FThumbHeight);
    // Write the file list
    FHeaderFilelist.Sort;
    for I := 0 to Count - 1 do
      if FHeaderFilelist[I] <> '' then begin
        Read(I, T);
        T.SaveToStream(FileStream);
      end;
    // Save comments or extra options
    FComments.SaveToStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure TThumbAlbum.Assign(AThumbAlbum: TThumbAlbum);
var
  I: Integer;
  T, TCopy: TThumbInfo;
begin
  if Assigned(AThumbAlbum) then begin
    Clear;
    Directory := AThumbAlbum.Directory;
    FLoadedFromFile := AThumbAlbum.LoadedFromFile;
    FStreamVersion := AThumbAlbum.StreamVersion;
    FThumbWidth := AThumbAlbum.ThumbWidth;
    FThumbHeight := AThumbAlbum.ThumbHeight;
    FComments.Assign(AThumbAlbum.Comments);

    for I := 0 to AThumbAlbum.Count - 1 do begin
      AThumbAlbum.Read(I, T);
      if T.Filename <> '' then begin
        TCopy := TThumbInfo.Create;
        try
          TCopy.Assign(T);
          Self.Add(TCopy);
        except
          TCopy.Free;
        end;
      end;
    end;
  end;
end;

function TThumbAlbum.GetCount: Integer;
begin
  Result := FHeaderFilelist.Count;
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ TCustomThumbsManager }

constructor TCustomThumbsManager.Create(AOwner: TComponent);
begin
  inherited Create;
  FOwner := AOwner;
  FValidImageFormats := TExtensionsList.Create;
  FInvalidImageFormats := TExtensionsList.Create;
  FAlignment := talCenter;
  FUseExifThumbnail := True;
  FUseExifOrientation := True;
  FUseFoldersShellExtraction := True;
  FUseShellExtraction := True;
  FUseSubsampling := True;
  FStorageFilename := 'Thumbnails.album';
  FStorageType := tasRepository;
  FHideBorder := True;
  FillImageFormats;
end;

destructor TCustomThumbsManager.Destroy;
begin
  FreeAndNil(FValidImageFormats);
  FreeAndNil(FInvalidImageFormats);
  inherited;
end;

procedure TCustomThumbsManager.Assign(Source: TPersistent);
var
  Temp: TCustomThumbsManager;
begin
  if Source is TCustomThumbsManager then
  begin
    Temp := TCustomThumbsManager(Source);
    ValidImageFormats.Assign(Temp.ValidImageFormats);
    InvalidImageFormats.Assign(Temp.InvalidImageFormats);
    Alignment := Temp.Alignment;
    AutoLoad := Temp.AutoLoad;
    AutoSave := Temp.AutoSave;
    LoadAllAtOnce := Temp.LoadAllAtOnce;
    MaxThumbHeight := Temp.MaxThumbHeight;
    MaxThumbWidth := Temp.MaxThumbWidth;
    StorageCompressed := Temp.StorageCompressed;
    StorageFilename := Temp.StorageFilename;
    StorageRepositoryFolder := Temp.StorageRepositoryFolder;
    StorageType := Temp.StorageType;
    UseExifThumbnail := Temp.UseExifThumbnail;
    UseExifOrientation := Temp.UseExifOrientation;
    UseFoldersShellExtraction := Temp.UseFoldersShellExtraction;
    UseShellExtraction := Temp.UseShellExtraction;
    UseSubsampling := Temp.UseSubsampling;
  end
end;

procedure TCustomThumbsManager.DoOptionsChanged(ResetThread, Invalidate: Boolean);
begin
  { TODO : create a new event }
end;

procedure TCustomThumbsManager.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TCustomThumbsManager.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount < 0 then FUpdateCount := 0;
end;

procedure TCustomThumbsManager.FillImageFormats(FillColors: Boolean = True);
var
  I: Integer;
  Ext: string;
begin
  FValidImageFormats.Clear;
  with FValidImageFormats do begin
    CommaText := '.jpg, .jpeg, .jpe, .jif, .bmp, .emf, .wmf';
    {$IFDEF USEIMAGEEN}
    CommaText := CommaText + ', .tif, .tiff, .fax, .g3n, .g3f, .xif, .gif, .pcx, .dib, .rle, .ico, .cur, .png, .dcm, .dic, .dicom' +
      ', .v2, .tga, .targa, .vda, .icb, .vst, .pix, .pxm, .ppm, .pgm, .pbm, .wbmp, .jp2, .j2k, .jpc, .j2c, .dcx' +
      ', .crw, .cr2, .dng, .nef, .raw, .raf, .x3f, .orf, .srf, .mrw, .dcr, .bay, .pef, .sr2, .arw, .kdc, .mef, .3fr, .k25, .erf, .cam, .cs1, .dc2, .dcs, .fff, .mdc, .mos, .nrw, .ptx, .pxn, .rdc, .rw2, .rwl, .iiq, .srw' +
      ', .psd, .psb, .wdp, .hdp, .jxr, .dds, .heic, .heif, .heics, .avcs, .heifs, .webp, .avi, .mpe, .mpg, .mpeg, .wmv';
    {$ELSE}
    {$IFDEF USEENVISION}
      //version 1.1
      CommaText := CommaText + ', .png, .pcx, .pcc, .tif, .tiff, .dcx, .tga, .vst, .afi';
      //version 2.0, eps (Encapsulated Postscript) and jp2 (JPEG2000 version)
      //CommaText := CommaText + ', .eps, .jp2'; <<<<<<< still in beta
    {$ENDIF}
    {$ENDIF}
  end;

if FillColors then begin
    for I := 0 to FValidImageFormats.Count - 1 do begin
      Ext := FValidImageFormats[I];

      if Pos(Ext, '.jpg, .jpeg, .jpe, .jif, .bmp, .emf, .wmf') > 0 then FValidImageFormats.Colors[I] := $BADDDD
      else if Pos(Ext, '.tif, .tiff, .fax, .g3n, .g3f, .xif, .gif, .pcx, .dib, .rle, .ico, .cur, .png, .dcm, .dic, .dicom') > 0 then FValidImageFormats.Colors[I] := $EFD3D3
      else if Pos(Ext, '.v2, .tga, .targa, .vda, .icb, .vst, .pix, .pxm, .ppm, .pgm, .pbm, .wbmp, .jp2, .j2k, .jpc, .j2c, .dcx') > 0 then FValidImageFormats.Colors[I] := $7DC7B0
      else if Pos(Ext, '.crw, .cr2, .dng, .nef, .raw, .raf, .x3f, .orf, .srf, .mrw, .dcr, .bay, .pef, .sr2, .arw, .kdc, .mef, .3fr, .k25, .erf, .cam, .cs1, .dc2, .dcs, .fff, .mdc, .mos, .nrw, .ptx, .pxn, .rdc, .rw2, .rwl, .iiq, .srw') > 0 then FValidImageFormats.Colors[I] := $CCDBCC
      else if Pos(Ext, '.psd, .psb, .wdp, .hdp, .jxr, .dds, .heic, .heif, .heics, .avcs, .heifs, .webp, .avi, .mpe, .mpg, .mpeg, .wmv') > 0 then FValidImageFormats.Colors[I] := $0BBDFF;
      // $7DC7B0 = green, $0BBDFF = orange, CFCFCF = grey
    end;
  end;

  FInvalidImageFormats.CommaText := '.url, .lnk, .ico, .exe, .com, .sys, .dll, .bpl';
end;

function TCustomThumbsManager.IsValidImageFileFormat(NS: TNamespace): TValidImageFileFormat;
var
  Ext: string;
begin
  Result := vffInvalid;
  if Assigned(NS) then begin
    Ext := WideExtractFileExt(NS.NameForParsing);
    if FInvalidImageFormats.IndexOf(Ext) = -1 then
      if (FValidImageFormats.IndexOf(Ext) > -1) {$IFDEF USEIMAGEEN}or IsKnownFormat(Ext){$ENDIF} then
        Result := vffValid
      else
        if UseShellExtraction or (UseFoldersShellExtraction and NS.Folder) then
          Result := vffUnknown;
  end;
end;

function TCustomThumbsManager.GetAlbumList(L: TStringList): Boolean;
var
  S: string;
begin
  Result := False;
  L.Clear;
  S := StorageRepositoryFolder + 'AlbumList.txt';
  if FileExists(S) then begin
    L.LoadFromFile(S);
    Result := True;
  end;
end;

function TCustomThumbsManager.GetUpdating: Boolean;
begin
  Result := FUpdateCount > 0;
end;

function TCustomThumbsManager.GetAlbumFileToLoad(Dir: string): string;
var
  L: TStringList;
begin
  Result := '';
  if Dir <> '' then begin
    Dir := IncludeTrailingPathDelimiter(Dir);
    case FStorageType of
      tasPerFolder:
        if FStorageFilename <> '' then
          Result := Dir + FStorageFilename;
      tasRepository:
        if FStorageRepositoryFolder <> '' then begin
          L := TStringList.Create;
          try
            if GetAlbumList(L) then begin
              Result := L.Values[Dir];
              if Result <> '' then
                Result := FStorageRepositoryFolder + Result;
            end;
          finally
            L.Free;
          end;
        end;
    end;
  end;
end;

function TCustomThumbsManager.GetAlbumFileToSave(Dir: string; AppendToAlbumList: Boolean): string;
var
  F: string;
  I: Integer;
  L: TStringList;
begin
  Result := '';
  if Dir <> '' then begin
    Dir := IncludeTrailingPathDelimiter(Dir);
    case FStorageType of
      tasPerFolder:
        if FStorageFilename <> '' then
          Result := Dir + FStorageFilename;
      tasRepository:
        if (FStorageRepositoryFolder <> '') and (DirectoryExists(FStorageRepositoryFolder) or CreateDir(FStorageRepositoryFolder)) then begin
          L := TStringList.Create;
          try
            if GetAlbumList(L) then
              Result := L.Values[Dir];

            if Result <> '' then
              Result := FStorageRepositoryFolder + Result
            else begin
              // Find a unique file name
              if WideIsDrive(Dir) then
                F := Dir[1]
              else
                F := WideExtractFileName(WideStripTrailingBackslash(Dir));  // NameForParsingInFolder
              Result := F + '.album';
              I := 0;
              while FileExists(FStorageRepositoryFolder + Result) do begin
                inc(I);
                Result := F + '.' + IntToStr(I) + '.album';
              end;

              if AppendToAlbumList then begin
                L.Values[Dir] := Result;
                L.Sort;
                L.SaveToFile(FStorageRepositoryFolder + 'AlbumList.txt');
              end;
              Result := FStorageRepositoryFolder + Result;
            end;
          finally
            L.Free;
          end;
        end;
    end;
  end;
end;

procedure TCustomThumbsManager.SetAlignment(const Value: TThumbsAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    DoOptionsChanged(False, True);
  end;
end;

procedure TCustomThumbsManager.SetStorageRepositoryFolder(const Value: string);
begin
  FStorageRepositoryFolder := Value;
  if FStorageRepositoryFolder <> '' then
    FStorageRepositoryFolder := IncludeTrailingPathDelimiter(FStorageRepositoryFolder);
end;

end.
