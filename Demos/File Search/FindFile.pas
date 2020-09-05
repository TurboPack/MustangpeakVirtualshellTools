{------------------------------------------------------------------------------}
{                                                                              }
{  TFindFile v3.2                                                              }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{  Special thanks to:                                                          }
{    Frederik Decoster <essevee@yahoo.com> for fixing folder look up bug.      }
{    Nitin Chandra <nitin@spectranet.com> for the idea of dir level criterion. }
{                                                                              }
{------------------------------------------------------------------------------}

unit FindFile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type

  EFindFileError = class(Exception);

  TFolderIgnore = (fiNone, fiJustThis, fiJustSubfolders, fiThisAndSubfolders);

  TFileMatchEvent = procedure (Sender: TObject; const Folder: String;
    const FileInfo: TSearchRec) of object;

  TFolderChangeEvent = procedure (Sender: TObject; const Folder: String;
    var IgnoreFolder: TFolderIgnore) of object;

  TFileCriteria = class(TPersistent)
  private
    fFilename: String;
    fLocation: String;
    fIncluded: TStringList;
    fExcluded: TStringList;
    fSubfolders: Boolean;
    fMinLevel: Word;
    fMaxLevel: Word;
    procedure SetIncluded(Value: TStringList);
    procedure SetExcluded(Value: TStringList);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property FileName: String read fFilename write fFilename;
    property Location: String read fLocation write fLocation;
    property Included: TStringList read fIncluded write SetIncluded;
    property Excluded: TStringList read fExcluded write SetExcluded;
    property Subfolders: Boolean read fSubfolders write fSubfolders default True;
    property MinLevel: Word read fMinLevel write fMinLevel default 0;
    property MaxLevel: Word read fMaxLevel write fMaxLevel default 0;
  end;

  TFileAttributes = set of (ffArchive, ffReadonly, ffHidden, ffSystem, ffDirectory);

  TAttributeCriteria = class(TPersistent)
  private
     fFlags: Integer;
     fExactMatch: Boolean;
     function GetAttributes: TFileAttributes;
     procedure SetAttributes(Value: TFileAttributes);
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    property Flags: Integer read fFlags write fFlags;
    function Matches(Attr: Integer): Boolean;
  published
    property Attributes: TFileAttributes read GetAttributes write SetAttributes
      default [ffArchive, ffReadonly, ffHidden, ffSystem];
    property ExactMatch: Boolean read fExactMatch write fExactMatch default False;
  end;

  TDateTimeCriteria = class(TPersistent)
  private
     fCreatedBefore: TDateTime;
     fCreatedAfter: TDateTime;
     fModifiedBefore: TDateTime;
     fModifiedAfter: TDateTime;
     fAccessedBefore: TDateTime;
     fAccessedAfter: TDateTime;
  public
    procedure Assign(Source: TPersistent); override;
    function Matches(const Created, Modified, Accessed: TFileTime): Boolean;
  published
    property CreatedBefore: TDateTime read fCreatedBefore write fCreatedBefore;
    property CreatedAfter: TDateTime read fCreatedAfter write fCreatedAfter;
    property ModifiedBefore: TDateTime read fModifiedBefore write fModifiedBefore;
    property ModifiedAfter: TDateTime read fModifiedAfter write fModifiedAfter;
    property AccessedBefore: TDateTime read fAccessedBefore write fAccessedBefore;
    property AccessedAfter: TDateTime read fAccessedAfter write fAccessedAfter;
  end;

  TSizeCriteria = class(TPersistent)
  private
    fMin: DWORD;
    fMax: DWORD;
  public
    procedure Assign(Source: TPersistent); override;
    function Matches(Size: DWORD): Boolean; 
  published
    property Min: DWORD read fMin write fMin default 0;
    property Max: DWORD read fMax write fMax default 0;
  end;

  TContentCriteria = class(TPersistent)
  private
    fPhrase: String;
    fPhraseLen: Integer;
    fIgnoreCase: Boolean;
    fTargetPhrase: String;
    procedure SetPhrase(const Value: String);
    procedure SetIgnoreCase(Value: Boolean);
  protected
    property TargetPhrase: String read fTargetPhrase;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    property PhraseLen: Integer read fPhraseLen;
    function Matches(const FileName: String): Boolean;
  published
    property Phrase: String read fPhrase write SetPhrase;
    property IgnoreCase: Boolean read fIgnoreCase write SetIgnoreCase default True;
  end;

  TSearchCriteria = class(TPersistent)
  private
    fFiles: TFileCriteria;
    fAttribute: TAttributeCriteria;
    fTimeStamp: TDateTimeCriteria;
    fSize: TSizeCriteria;
    fContent: TContentCriteria;
    procedure SetFiles(Value: TFileCriteria);
    procedure SetAttribute(Value: TAttributeCriteria);
    procedure SetTimeStamp(Value: TDateTimeCriteria);
    procedure SetSize(Value: TSizeCriteria);
    procedure SetContent(Value: TContentCriteria);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Files: TFileCriteria read fFiles write SetFiles;
    property Attribute: TAttributeCriteria read fAttribute write SetAttribute;
    property TimeStamp: TDateTimeCriteria read fTimeStamp write SetTimeStamp;
    property Size: TSizeCriteria read fSize write SetSize;
    property Content: TContentCriteria read fContent write SetContent;
  end;

  TTargetFolder = class(TObject)
  private
    fFolder: String;
    fSubfolders: Boolean;
    fFileMasks: TStringList;
    fMinLevel: Word;
    fMaxLevel: Word;
  public
    constructor Create;
    destructor Destroy; override;
    property Folder: String read fFolder write fFolder;
    property Subfolders: Boolean read fSubfolders write fSubfolders;
    property FileMasks: TStringList read fFileMasks;
    property MinLevel: Word read fMinLevel write fMinLevel;
    property MaxLevel: Word read fMaxLevel write fMaxLevel;
  end;

  TTargetFolderList = class(TList)
  private
    fExcludedFiles: TStringList;
    function GetItems(Index: Integer): TTargetFolder;
  public
    constructor Create;
    destructor Destroy; override;
    function IndexOfFolder(const Folder: String): Integer;
    function AddFolder(const Folder: String): TTargetFolder;
    function IsExcluded(const Folder, FileName: String): Boolean;
    property Items[Index: Integer]: TTargetFolder read GetItems; default;
    property ExcludedFiles: TStringList read fExcludedFiles;
  end;

  // TTargetSearch holds all running search parameters. This ables us to change
  // the component's properties without affecting the running search.
  TTargetSearch = class(TObject)
  protected
     TargetFolders: TTargetFolderList;
     Attribute: TAttributeCriteria;
     TimeStamp: TDateTimeCriteria;
     Size: TSizeCriteria;
     Content: TContentCriteria;
     procedure PrepareTargetFolders(FileCriteria: TFileCriteria);
  public
    constructor Create(Criteria: TSearchCriteria);
    destructor Destroy; override;
    function Matches(const Folder: String; const SR: TSearchRec): Boolean;
  end;

  TFindFile = class(TComponent)
  private
    fCriteria: TSearchCriteria;
    fThreaded: Boolean;
    fThreadPriority: TThreadPriority;
    fAborted: Boolean;
    fBusy: Boolean;
    fCurrentLevel: Word;
    fOnFileMatch: TFileMatchEvent;
    fOnFolderChange: TFolderChangeEvent;
    fOnSearchBegin: TNotifyEvent;
    fOnSearchFinish: TNotifyEvent;
    fOnSearchAbort: TNotifyEvent;
    SearchThread: TThread;
    TargetSearch: TTargetSearch;
    ActiveTargetFolder: TTargetFolder;
    procedure SetCriteria(Value: TSearchCriteria);
    procedure ThreadTerminated(Sender: TObject);
  protected
    procedure DoSearchBegin; virtual;
    procedure DoSearchFinish; virtual;
    procedure DoSearchAbort; virtual;
    function DoFolderChange(const Folder: String): TFolderIgnore; virtual;
    procedure DoFileMatch(const Folder: String; const FileInfo: TSearchRec); virtual;
    function IsAcceptable(const Folder: String; const SR: TSearchRec): Boolean;
    procedure InitializeSearch;
    procedure FinalizeSearch;
    procedure SearchForFiles;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute;
    procedure Abort;
    property Busy: Boolean read fBusy;
    property Aborted: Boolean read fAborted;
    property CurrentLevel: Word read fCurrentLevel;
  published
    property Criteria: TSearchCriteria read fCriteria write SetCriteria;
    property Threaded: Boolean read fThreaded write fThreaded default False;
    property ThreadPriority: TThreadPriority read fThreadPriority write fThreadPriority default tpNormal;
    property OnFileMatch: TFileMatchEvent read fOnFileMatch write fOnFileMatch;
    property OnFolderChange: TFolderChangeEvent read fOnFolderChange write fOnFolderChange;
    property OnSearchBegin: TNotifyEvent read fOnSearchBegin write fOnSearchBegin;
    property OnSearchFinish: TNotifyEvent read fOnSearchFinish write fOnSearchFinish;
    property OnSearchAbort: TNotifyEvent read fOnSearchAbort write fOnSearchAbort;
  end;

procedure Register;

function AddTrailingBackslash(const Path: String): String;
function RemoveTrailingBackslash(const Path: String): String;
function FileTimeToDateTime(const FileTime: TFileTime): TDateTime;
function IsDateBetween(const aDate, Before, After: TDateTime): Boolean;
function FileContains(const FileName: String; const Phrase: String;
  IgnoreCase: Boolean): Boolean;

implementation

uses
  FileCtrl;

const
  Delimiter = ';';
  IncSubfolders = '>';
  ExcSubfolders = '<';
  ValidFileAttr = faAnyFile and not faVolumeID;

procedure Register;
begin
  RegisterComponents('Delphi Area', [TFindFile]);
end;

{ Helper Functions }

function AddTrailingBackslash(const Path: String): String;
var
  PathLen: Integer;
begin
  PathLen := Length(Path);
  if (PathLen > 0) and not (Path[PathLen] in ['\', ':']) then
    Result := Path + '\'
  else
    Result := Path;
end;

function RemoveTrailingBackslash(const Path: String): String;
var
  PathLen: Integer;
begin
  PathLen := Length(Path);
  if (PathLen > 1) and (Path[PathLen] = '\') and (Path[PathLen-1] <> ':') then
    Result := Copy(Path, 1, PathLen - 1)
  else
    Result := Path;
end;

function FileTimeToDateTime(const FileTime: TFileTime): TDateTime;
var
  LocalFileTime: TFileTime;
  SystemTime: TSystemTime;
begin
  FileTimeToLocalFileTime(FileTime, LocalFileTime);
  FileTimeToSystemTime(LocalFileTime, SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;

function IsDateBetween(const aDate, Before, After: TDateTime): Boolean;
begin
  Result := True;
  if Before <> 0 then
    if Frac(Before) = 0 then      { Checks date only }
      Result := Result and (Int(aDate) <= Before)
    else if Int(Before) = 0 then  { Checks time only }
      Result := Result and (Frac(aDate) <= Before)
    else                          { Checks date and time }
      Result := Result and (aDate <= Before);
  if After <> 0 then
    if Frac(After) = 0 then       { Checks date only }
      Result := Result and (Int(aDate) >= After)
    else if Int(After) = 0 then   { Checks time only }
      Result := Result and (Frac(aDate) >= After)
    else                          { Checks date and time }
      Result := Result and (aDate >= After);
end;

function FileContainsPhrase(const FileName: String; const Phrase: PChar;
  PhraseLen: Integer; MatchLowerCase: Boolean): Boolean;
const
  MaxBufferSize = $F000; // Must be larger than PhraseLen
var
  Stream: TFileStream;
  DataSize: Integer;
  BufferSize: Integer;
  Buffer, B, P: PChar;
  N, Offset: Integer;
begin
  Result := False;
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    DataSize := Stream.Size;
    if DataSize >= PhraseLen then
    begin
      if DataSize > MaxBufferSize then
        if PhraseLen <= MaxBufferSize then
          BufferSize := MaxBufferSize
        else
          BufferSize := PhraseLen
      else
        BufferSize := DataSize;
      GetMem(Buffer, BufferSize);
      try
        P := Phrase;
        Offset := 0;
        while (DataSize + Offset) >= PhraseLen do
        begin
          B := Buffer + Offset;
          N := BufferSize - Offset;
          if N > DataSize then N := DataSize;
          Stream.Read(B^, N);
          if MatchLowerCase then AnsiLowerBuff(B, N);
          Dec(DataSize, N);
          repeat
            if B^ = P^ then
            begin
              Inc(P);
              Inc(Offset);
              Result := (Offset = PhraseLen);
            end
            else if P <> Phrase then
            begin
              P := Phrase;
              Dec(B, Offset);
              Inc(N, Offset);
              Offset := 0;
            end;
            Inc(B);
            Dec(N);
          until Result or (N = 0);
        end;
      finally
        FreeMem(Buffer, BufferSize);
      end;
    end;
  finally
    Stream.Free;
  end;
end;

function FileContains(const FileName: String; const Phrase: String;
  IgnoreCase: Boolean): Boolean;
begin
  if IgnoreCase then
    Result := FileContainsPhrase(FileName, PChar(SysUtils.AnsiLowerCase(Phrase)),
      Length(Phrase), True)
  else
    Result := FileContainsPhrase(FileName, PChar(Phrase),
      Length(Phrase), False);
end;

function StrMatches(const Str, Mask: String): Boolean;
var
  S, M: PChar;
begin
  Result := True;
  S := PChar(Str);
  M := PChar(Mask);
  while (S^ <> #0) and (M^ <> #0) do
  begin
    case M^ of
      '*': Exit;
      '?': ;
    else
      if UpCase(M^) <> UpCase(S^) then
      begin
        Result := False;
        Exit;
      end;
    end;
    Inc(S);
    Inc(M);
  end;
  if S^ = #0 then
  begin
    while M^ in ['*', '?'] do
      Inc(M);
    Result := (M^ = #0);
  end
  else
    Result := False;
end;

function FileNameMatches(const FileName, Mask: String): Boolean;
var
  fName, fExt: String;
  mName, mExt: String;
begin
  fName := ChangeFileExt(FileName, '');
  fExt := ExtractFileExt(FileName);
  mName := ChangeFileExt(Mask, '');
  mExt := ExtractFileExt(Mask);
  if Length(mExt) > 0 then
  begin
    if fExt = '' then fExt := '.';
    Result := StrMatches(fExt, mExt) and StrMatches(fName, mName);
  end
  else
    Result := StrMatches(fName, mName);
end;

function FileFullPathMatches(const FileDir, FileName, Mask: String): Boolean;
var
  MaskDrive, MaskDir, MaskName: String;
  MaskDirLen: Integer;
  FileDrive, InnerestSubDir: String;
  FileDirLen: Integer;
begin
  Result := False;
  MaskDir := ExtractFilePath(Mask);
  // Checkes part if mask contains path
  if MaskDir <> '' then
  begin
    FileDrive := ExtractFileDrive(FileDir);
    MaskDrive := ExtractFileDrive(MaskDir);
    // Checkes drive if mask contains drive
    if MaskDrive <> '' then
    begin
      if not (MaskDir[1] in ['*', '?']) and ((FileDrive = '') or
        (UpCase(FileDrive[1]) <> UpCase(MaskDrive[1])))
      then
        Exit; // Not Matched, drives are different
      // Removes drive from the Mask
      Delete(MaskDir, 1, Length(MaskDrive));
    end;
    // Checkes directory if mask contains directory
    if MaskDir <> '' then
    begin
      MaskDirLen := Length(MaskDir);
      FileDirLen := Length(FileDir);
      if MaskDirLen > FileDirLen - Length(FileDrive) then
        Exit // Not Matched, Mask's length is longer than folder's length
      else 
      begin
        // Checkes most inner sub directories
        InnerestSubDir := Copy(FileDir, FileDirLen - MaskDirLen + 1, MaskDirLen);
        if CompareText(InnerestSubDir, MaskDir) <> 0 then
          Exit; // Not Matched
      end;
    end;
  end;
  // Checkes file name part if mask contains filename
  MaskName := ExtractFileName(Mask);
  if Length(MaskName) > 0 then
    Result := FileNameMatches(FileName, MaskName)
  else
    Result := True; // Matched
end;

{ TFileCriteria }

constructor TFileCriteria.Create;
begin
  inherited Create;
  fIncluded := TStringList.Create;
  fExcluded := TStringList.Create;
  fSubfolders := True;
end;

destructor TFileCriteria.Destroy;
begin
  fIncluded.Free;
  fExcluded.Free;
  inherited Destroy;
end;

procedure TFileCriteria.Assign(Source: TPersistent);
begin
  if Source is TFileCriteria then
  begin
    Filename := TFileCriteria(Source).FileName;
    Location := TFileCriteria(Source).Location;
    Included := TFileCriteria(Source).Included;
    Excluded := TFileCriteria(Source).Excluded;
    Subfolders := TFileCriteria(Source).Subfolders;
    MinLevel := TFileCriteria(Source).MinLevel;
    MaxLevel := TFileCriteria(Source).MaxLevel;
  end
  else
    inherited Assign(Source);
end;

procedure TFileCriteria.SetIncluded(Value: TStringList);
begin
  fIncluded.Assign(Value);
end;

procedure TFileCriteria.SetExcluded(Value: TStringList);
begin
  fExcluded.Assign(Value);
end;

{ TAttributeCriteria }

constructor TAttributeCriteria.Create;
begin
  inherited Create;
  fFlags := faArchive or faReadonly or faHidden or faSysFile;
  fExactMatch := False;
end;

procedure TAttributeCriteria.Assign(Source: TPersistent);
begin
  if Source is TAttributeCriteria then
  begin
    Flags := TAttributeCriteria(Source).Flags;
    ExactMatch := TAttributeCriteria(Source).ExactMatch;
  end
  else
    inherited Assign(Source);
end;

function TAttributeCriteria.GetAttributes: TFileAttributes;
begin
  Result := [];
  if (Flags and faArchive) = faArchive then
    Include(Result, ffArchive);
  if (Flags and faReadonly) = faReadonly then
    Include(Result, ffReadonly);
  if (Flags and faHidden) = faHidden then
    Include(Result, ffHidden);
  if (Flags and faSysFile) = faSysFile then
    Include(Result, ffSystem);
  if (Flags and faDirectory) = faDirectory then
    Include(Result, ffDirectory);
end;

procedure TAttributeCriteria.SetAttributes(Value: TFileAttributes);
var
  NewFlags: Integer;
begin
  NewFlags := 0;
  if ffArchive in Value then
    NewFlags := NewFlags or faArchive;
  if ffReadonly in Value then
    NewFlags := NewFlags or faReadonly;
  if ffHidden in Value then
    NewFlags := NewFlags or faHidden;
  if ffSystem in Value then
    NewFlags := NewFlags or faSysFile;
  if ffDirectory in Value then
    NewFlags := NewFlags or faDirectory;
  Flags := NewFlags;
end;

function TAttributeCriteria.Matches(Attr: Integer): Boolean;
begin
  Attr := Attr and ValidFileAttr;
  Result := (not ExactMatch or (Flags = Attr)) and
            (ExactMatch or ((not Flags and Attr) = 0));
end;

{ TDateTimeCriteria }

procedure TDateTimeCriteria.Assign(Source: TPersistent);
begin
  if Source is TDateTimeCriteria then
  begin
    CreatedBefore := TDateTimeCriteria(Source).CreatedBefore;
    CreatedAfter := TDateTimeCriteria(Source).CreatedAfter;
    ModifiedBefore := TDateTimeCriteria(Source).ModifiedBefore;
    ModifiedAfter := TDateTimeCriteria(Source).ModifiedAfter;
    AccessedBefore := TDateTimeCriteria(Source).AccessedBefore;
    AccessedAfter := TDateTimeCriteria(Source).AccessedAfter;
  end
  else
    inherited Assign(Source);
end;

function TDateTimeCriteria.Matches(const Created, Modified, Accessed: TFileTime): Boolean;
var
  DateTime: TDateTime;
begin
  Result := False;
  if (CreatedBefore <> 0) or (CreatedAfter <> 0) then
  begin
    DateTime := FileTimeToDateTime(Created);
    if not IsDateBetween(DateTime, CreatedBefore, CreatedAfter) then Exit;
  end;
  if (ModifiedBefore <> 0) or (ModifiedAfter <> 0) then
  begin
    DateTime := FileTimeToDateTime(Modified);
    if not IsDateBetween(DateTime, ModifiedBefore, ModifiedAfter) then Exit;
  end;
  if (AccessedBefore <> 0) or (AccessedAfter <> 0) then
  begin
    DateTime := FileTimeToDateTime(Accessed);
    if not IsDateBetween(DateTime, AccessedBefore, AccessedAfter) then Exit;
  end;
  Result := True;
end;

{ TSizeCriteria }

procedure TSizeCriteria.Assign(Source: TPersistent);
begin
  if Source is TSizeCriteria then
  begin
    Min := TSizeCriteria(Source).Min;
    Max := TSizeCriteria(Source).Max;
  end
  else
    inherited Assign(Source);
end;

function TSizeCriteria.Matches(Size: DWORD): Boolean;
begin
  Result := ((Min = 0) or (Size >= Min)) and ((Max = 0) or (Size <= Max));
end;

{ TContentCriteria }

constructor TContentCriteria.Create;
begin
  inherited Create;
  fIgnoreCase := True;
end;

procedure TContentCriteria.Assign(Source: TPersistent);
begin
  if Source is TContentCriteria then
  begin
    Phrase := TContentCriteria(Source).Phrase;
    IgnoreCase := TContentCriteria(Source).IgnoreCase;
  end
  else
    inherited Assign(Source);
end;

procedure TContentCriteria.SetPhrase(const Value: String);
begin
  if Phrase <> Value then
  begin
    fPhrase := Value;
    fPhraseLen := Length(Value);
    if IgnoreCase then
      fTargetPhrase := SysUtils.AnsiLowerCase(Phrase)
    else
      fTargetPhrase := Phrase;
  end;
end;

procedure TContentCriteria.SetIgnoreCase(Value: Boolean);
begin
  if IgnoreCase <> Value then
  begin
    fIgnoreCase := Value;
    if IgnoreCase then
      fTargetPhrase := SysUtils.AnsiLowerCase(Phrase)
    else
      fTargetPhrase := Phrase;
  end;
end;

function TContentCriteria.Matches(const FileName: String): Boolean;
begin
  if PhraseLen > 0 then
    try
      Result := FileContainsPhrase(FileName, PChar(TargetPhrase), PhraseLen, IgnoreCase)
    except
      Result := False;
    end
  else
    Result := True;
end;

{ TSearchCriteria }

constructor TSearchCriteria.Create;
begin
  inherited Create;
  fFiles := TFileCriteria.Create;
  fAttribute := TAttributeCriteria.Create;
  fTimeStamp := TDateTimeCriteria.Create;
  fSize := TSizeCriteria.Create;
  fContent := TContentCriteria.Create;
end;

destructor TSearchCriteria.Destroy;
begin
  fFiles.Free;
  fAttribute.Free;
  fTimeStamp.Free;
  fSize.Free;
  fContent.Free;
  inherited Destroy;
end;

procedure TSearchCriteria.Assign(Source: TPersistent);
begin
  if Source is TSearchCriteria then
  begin
    Files := TSearchCriteria(Source).Files;
    Attribute := TSearchCriteria(Source).Attribute;
    TimeStamp := TSearchCriteria(Source).TimeStamp;
    Size := TSearchCriteria(Source).Size;
    Content := TSearchCriteria(Source).Content;
  end
  else
    inherited Assign(Source);
end;

procedure TSearchCriteria.SetFiles(Value: TFileCriteria);
begin
  Files.Assign(Value);
end;

procedure TSearchCriteria.SetAttribute(Value: TAttributeCriteria);
begin
  Attribute.Assign(Value);
end;

procedure TSearchCriteria.SetTimeStamp(Value: TDateTimeCriteria);
begin
  TimeStamp.Assign(Value);
end;

procedure TSearchCriteria.SetSize(Value: TSizeCriteria);
begin
  Size.Assign(Value);
end;

procedure TSearchCriteria.SetContent(Value: TContentCriteria);
begin
  Content.Assign(Value);
end;

{ TTargetFolder }

constructor TTargetFolder.Create;
begin
  inherited Create;
  fFileMasks := TStringList.Create;
end;

destructor TTargetFolder.Destroy;
begin
  fFileMasks.Free;
  inherited Destroy;
end;

{ TTargetFolderList }

constructor TTargetFolderList.Create;
begin
  inherited Create;
  fExcludedFiles := TStringList.Create;
end;

destructor TTargetFolderList.Destroy;
var
  Index: Integer;
begin
  fExcludedFiles.Free;
  for Index := Count - 1 downto 0 do
    Items[Index].Free;
  inherited Destroy;
end;

function TTargetFolderList.IndexOfFolder(const Folder: String): Integer;
var
  Index: Integer;
begin
  Result := -1;
  for Index := 0 to Count - 1 do
    if CompareText(Folder, Items[Index].Folder) = 0 then
    begin
      Result := -1;
      Break;
    end;
end;

function TTargetFolderList.AddFolder(const Folder: String): TTargetFolder;
var
  Index: Integer;
  FullPath: String;
begin
  FullPath := AddTrailingBackslash(ExpandFileName(Folder));
  Index := IndexOfFolder(FullPath);
  if Index >= 0 then
    Result := Items[Index]
  else
  begin
    Result := TTargetFolder.Create;
    Result.Folder := FullPath;
    Insert(0, Result);
  end;
end;

function TTargetFolderList.IsExcluded(const Folder, FileName: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := ExcludedFiles.Count - 1 downto 0 do
    if FileFullPathMatches(Folder, FileName, ExcludedFiles[I]) then
    begin
      Result := True;
      Exit;
    end;
end;

function TTargetFolderList.GetItems(Index: Integer): TTargetFolder;
begin
  Result := TTargetFolder(inherited Items[Index]);
end;

{ TTargetSearch }

constructor TTargetSearch.Create(Criteria: TSearchCriteria);
begin
  inherited Create;
  TargetFolders := TTargetFolderList.Create;
  Attribute := TAttributeCriteria.Create;
  TimeStamp := TDateTimeCriteria.Create;
  Size := TSizeCriteria.Create;
  Content := TContentCriteria.Create;
  PrepareTargetFolders(Criteria.Files);
  Attribute.Assign(Criteria.Attribute);
  TimeStamp.Assign(Criteria.TimeStamp);
  Size.Assign(Criteria.Size);
  Content.Assign(Criteria.Content);
  if Content.PhraseLen > 0 then
    Attribute.Attributes := Attribute.Attributes - [ffDirectory];
end;

destructor TTargetSearch.Destroy;
begin
  TargetFolders.Free;
  Attribute.Free;
  TimeStamp.Free;
  Size.Free;
  Content.Free;
  inherited Destroy;
end;

procedure TTargetSearch.PrepareTargetFolders(FileCriteria: TFileCriteria);

  function CreateItemsList(ItemsText: String): TStringList;
  var
    DelimiterPos: Integer;
  begin
    Result := TStringList.Create;
    Result.Duplicates := dupIgnore;
    while ItemsText <> '' do
    begin
      DelimiterPos := Pos(Delimiter, ItemsText);
      if DelimiterPos = 0 then
      begin
        Result.Add(ItemsText);
        Break;
      end
      else
      begin
        Result.Add(Copy(ItemsText, 1, DelimiterPos - 1));
        Delete(ItemsText, 1, DelimiterPos);
      end;
    end;
  end;

  function CheckSubfolders(var Folder: String): Boolean;
  begin
    Result := FileCriteria.Subfolders;
    if Folder <> '' then
    begin
      case Folder[1] of
        IncSubfolders:
        begin
          Result := True;
          Delete(Folder, 1, 1);
        end;
        ExcSubfolders:
        begin
          Result := False;
          Delete(Folder, 1, 1);
        end;
      end;
    end;
  end;

var
  I: Integer;
  Item: String;
  FileList: TStringList;
  FolderList: TStringList;
  ThisFolder: TTargetFolder;
  Subfolders: Boolean;
begin
  TargetFolders.ExcludedFiles.Assign(FileCriteria.Excluded);
  // Processes Included property
  for I := 0 to FileCriteria.Included.Count - 1 do
  begin
    Item := FileCriteria.Included[I];
    Subfolders := CheckSubfolders(Item);
    ThisFolder := TargetFolders.AddFolder(ExtractFilePath(Item));
    ThisFolder.FileMasks.Add(ExtractFileName(Item));
    ThisFolder.Subfolders := Subfolders;
  end;
  // Processes FileName and Location properties
  FileList := CreateItemsList(FileCriteria.FileName);
  try
    FolderList := CreateItemsList(FileCriteria.Location);
    try
      for I := 0 to FolderList.Count - 1 do
      begin
        Item := FolderList[I];
        Subfolders := CheckSubfolders(Item);
        ThisFolder := TargetFolders.AddFolder(Item);
        ThisFolder.FileMasks.AddStrings(FileList);
        ThisFolder.Subfolders := Subfolders;
        ThisFolder.MinLevel := FileCriteria.MinLevel;
        ThisFolder.MaxLevel := FileCriteria.MaxLevel;
      end;
    finally
      FolderList.Free;
    end;
  finally
    FileList.Free;
  end;
end;

function TTargetSearch.Matches(const Folder: String;
  const SR: TSearchRec): Boolean;
begin
  with SR.FindData do
    Result := Attribute.Matches(SR.Attr) and Size.Matches(SR.Size) and
    TimeStamp.Matches(ftCreationTime, ftLastWriteTime, ftLastAccessTime) and
    not TargetFolders.IsExcluded(Folder, SR.Name) and
    Content.Matches(Folder + SR.Name);
end;

{ TSearchThread }

type
  PSearchRec = ^TSearchRec;
  TSearchThread = class(TThread)
  private
    Owner: TFindFile;
    ThisFolder: PString;
    ThisFolderFlag: TFolderIgnore;
    MatchedSR: PSearchRec;
    procedure NotifyFolderChanged;
    procedure NotifyFileMatched;
  protected
    constructor Create(AOwner: TFindFile);
    procedure Execute; override;
  end;

constructor TSearchThread.Create(AOwner: TFindFile);
begin
  inherited Create(True);
  Owner := AOwner;
  FreeOnTerminate := True;
  Priority := Owner.ThreadPriority;
  OnTerminate := Owner.ThreadTerminated;
  Resume;
end;

procedure TSearchThread.NotifyFileMatched;
begin
  Owner.DoFileMatch(ThisFolder^, MatchedSR^);
end;

procedure TSearchThread.NotifyFolderChanged;
begin
  ThisFolderFlag := Owner.DoFolderChange(ThisFolder^);
end;

procedure TSearchThread.Execute;

  procedure SearchIn(const Path: String);
  var
    SR: TSearchRec;
    MaskIndex: Integer;
  begin
    ThisFolder := @Path;
    Inc(Owner.fCurrentLevel);
    try
      Synchronize(NotifyFolderChanged);
      with Owner.ActiveTargetFolder do
      begin
        // Searches in the current folder for all file masks
        if (ThisFolderFlag in [fiNone, fiJustSubfolders]) and
           (Owner.CurrentLevel >= MinLevel) then
        begin
          MaskIndex := FileMasks.Count;
          while not Terminated and (MaskIndex > 0) do
          begin
            Dec(MaskIndex);
            if not Terminated and (FindFirst(Path + FileMasks[MaskIndex], ValidFileAttr, SR) = 0) then
              try
                repeat
                  if (SR.Name <> '.') and (SR.Name <> '..') and Owner.IsAcceptable(Path, SR) then
                  begin
                    MatchedSR := @SR;
                    Synchronize(NotifyFileMatched);
                  end;
                until Terminated or (FindNext(SR) <> 0);
              finally
                FindClose(SR);
              end;
          end;
        end;
        // Searches in subfolders
        if Subfolders and (ThisFolderFlag in [fiNone, fiJustThis]) and
          ((MaxLevel = 0) or (Owner.CurrentLevel < MaxLevel)) then
        begin
          if not Terminated and (FindFirst(Path + '*.*', ValidFileAttr, SR) = 0) then
            try
              repeat
                if ((SR.Attr and faDirectory) = faDirectory) and
                   (SR.Name <> '.') and (SR.Name <> '..')
                then
                  SearchIn(Path + SR.Name + '\');
              until Terminated or (FindNext(SR) <> 0);
            finally
              FindClose(SR);
            end;
        end;
      end;
    finally
      Dec(Owner.fCurrentLevel);
    end;
  end;

var
  Index: Integer;
begin
  Index := Owner.TargetSearch.TargetFolders.Count;
  while not Terminated and (Index > 0) do
  begin
    Dec(Index);
    Owner.fCurrentLevel := 0;
    Owner.ActiveTargetFolder := Owner.TargetSearch.TargetFolders[Index];
    SearchIn(Owner.ActiveTargetFolder.Folder);
  end;
end;

{ TFindFile }

constructor TFindFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCriteria := TSearchCriteria.Create;
  fThreaded := False;
  fThreadPriority := tpNormal;
  fAborted := False;
  fBusy := False;
end;

destructor TFindFile.Destroy;
var
  Msg: TMsg;
begin
  if Busy then
  begin
    Abort;
    repeat
      if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
    until Busy;
  end;
  fCriteria.Free;
  inherited Destroy;
end;

procedure TFindFile.Abort;
begin
  if fBusy then
  begin
    fAborted := True;
    DoSearchAbort;
    if Assigned(SearchThread) then
      SearchThread.Terminate;
  end;
end;

procedure TFindFile.DoFileMatch(const Folder: String;
  const FileInfo: TSearchRec);
begin
  if not Aborted and Assigned(fOnFileMatch) then
    fOnFileMatch(Self, Folder, FileInfo);
end;

function TFindFile.DoFolderChange(const Folder: String): TFolderIgnore;
begin
  if Aborted then
    Result := fiThisAndSubfolders
  else
    Result := fiNone;
  if not Aborted and Assigned(fOnFolderChange) then
    fOnFolderChange(Self, Folder, Result);
end;

procedure TFindFile.DoSearchBegin;
begin
  if Assigned(fOnSearchBegin) then
    fOnSearchBegin(Self);
end;

procedure TFindFile.DoSearchFinish;
begin
  if Assigned(fOnSearchFinish) and not (csDestroying in ComponentState) then
    fOnSearchFinish(Self);
end;

procedure TFindFile.DoSearchAbort;
begin
  if Assigned(fOnSearchAbort) and not (csDestroying in ComponentState) then
    fOnSearchAbort(Self);
end;

procedure TFindFile.SearchForFiles;

  procedure SearchIn(const Path: String);
  var
    SR: TSearchRec;
    MaskIndex: Integer;
    Flag: TFolderIgnore;
  begin
    Inc(fCurrentLevel);
    try
      Flag := DoFolderChange(Path);
      with ActiveTargetFolder do
      begin
        // Searches in the current folder for all file masks
        if (Flag in [fiNone, fiJustSubfolders]) and (CurrentLevel >= MinLevel) then
        begin
          MaskIndex := FileMasks.Count;
          while not Aborted and (MaskIndex > 0) do
          begin
            Dec(MaskIndex);
            if not Aborted and (FindFirst(Path + FileMasks[MaskIndex], ValidFileAttr, SR) = 0) then
              try
                repeat
                  if (SR.Name <> '.') and (SR.Name <> '..') and IsAcceptable(Path, SR) then
                    DoFileMatch(Path, SR);
                until Aborted or (FindNext(SR) <> 0);
              finally
                FindClose(SR);
              end;
          end;
        end;
        // Searches in subfolders
        if Subfolders and (Flag in [fiNone, fiJustThis]) and
          ((MaxLevel = 0) or (CurrentLevel < MaxLevel)) then
        begin
          if not Aborted and (FindFirst(Path + '*.*', ValidFileAttr, SR) = 0) then
            try
              repeat
                if ((SR.Attr and faDirectory) = faDirectory) and
                   (SR.Name <> '.') and (SR.Name <> '..')
                then
                  SearchIn(Path + SR.Name + '\');
              until Aborted or (FindNext(SR) <> 0);
            finally
              FindClose(SR);
            end;
        end;
      end;
    finally
      Dec(fCurrentLevel);
    end;
  end;

var
  Index: Integer;
begin
  Index := TargetSearch.TargetFolders.Count;
  while not Aborted and (Index > 0) do
  begin
    Dec(Index);
    fCurrentLevel := 0;
    ActiveTargetFolder := TargetSearch.TargetFolders[Index];
    SearchIn(ActiveTargetFolder.Folder);
  end;
end;

procedure TFindFile.InitializeSearch;
begin
  fBusy := True;
  fAborted := False;
  TargetSearch := TTargetSearch.Create(Criteria);
  DoSearchBegin;
end;

procedure TFindFile.FinalizeSearch;
begin
  DoSearchFinish;
  TargetSearch.Free;
  fBusy := False;
end;

procedure TFindFile.Execute;
begin
  if not Busy then
  begin
    InitializeSearch;
    if Threaded then
      SearchThread := TSearchThread.Create(Self)
    else
    begin
      SearchForFiles;
      FinalizeSearch;
    end;
  end;
end;

function TFindFile.IsAcceptable(const Folder: String; const SR: TSearchRec): Boolean;
begin
  Result := TargetSearch.Matches(Folder, SR)
end;

procedure TFindFile.ThreadTerminated(Sender: TObject);
begin
  SearchThread := nil;
  FinalizeSearch;
end;

procedure TFindFile.SetCriteria(Value: TSearchCriteria);
begin
  Criteria.Assign(Value);
end;

end.


